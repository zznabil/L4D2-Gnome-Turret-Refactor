# Using Serena's LSP Tools on the Gnome Turret Mod

A practical guide for working with `mcp_serena_*` tools against the Squirrel
source of the `turret` mod, via the `.nut` → `.c` rename workaround.

**For the full SDLC + QA workflow, see [SDLC_AND_QA.md](SDLC_AND_QA.md).**
For the triple fact-check gauntlet, see [QA_GAUNTLET.md](QA_GAUNTLET.md).
For the in-game feedback questions, see [FEEDBACK_TEMPLATE.md](FEEDBACK_TEMPLATE.md).

> **Note on file roles:** `mapspawn_addon.nut` (1 line) is the L4D2 auto-
> loaded entry. It spawns a soundscape trigger that runs
> `gnome_turret_trigger.nut` (per-survivor state + first batch of helpers).
> `sm_utilities.nut` is the orchestrator that includes `lib_utils.nut` and
> `turret.nut`, but **nothing in the current load chain reaches it**. The
> main mod logic is dead code at runtime. Pass 3 of the gauntlet surfaces
> this every run; fixing the load chain is a separate code-level task.

---

## 1. Why this exists

Serena's language-server-backed code tools need a C/C++ LSP to read project
files. The mod is written in Squirrel (`.nut`), so the IDE has nothing to
attach to. The workaround in [tools/README.md](file:///d:/SteamLibrary/steamapps/common/Left%204%20Dead%202/turret/tools/README.md)
plus a global `clangd 22.1.6` install gives Serena a `.c` view of every
Squirrel source file.

**`clangd` is already installed** at
`C:\Users\zznabil\AppData\Local\Microsoft\WinGet\Links\clangd.exe` (verified
with `clangd --version`). If you ever wipe the machine, reinstall with:

```powershell
winget install --id LLVM.Clangd --accept-source-agreements --accept-package-agreements --silent
```

---

## 2. Steady-state: hybrid mode (recommended)

After a one-time setup, leave the working tree in this layout:

```
scripts/vscripts/
  mapspawn_addon.c          ← Serena indexes
  mapspawn_addon.nut        ← L4D2 auto-loads (entry point)
  gnome_turret_trigger.c    ← Serena indexes
  gnome_turret_trigger.nut  ← L4D2 loads (via soundscape trigger from mapspawn_addon)
  lib_utils.c               ← Serena indexes
  lib_utils.nut             ← L4D2 would load if reached; currently ORPHAN
  sm_utilities.c            ← Serena indexes
  sm_utilities.nut          ← L4D2 would load if reached; currently ORPHAN
  turret.c                  ← Serena indexes
  turret.nut                ← L4D2 would load if reached; currently ORPHAN
```

To reach this state from a clean checkout (only `.nut` files):

```powershell
pwsh -File tools\c_to_nut.ps1
```

Idempotent: re-running prints `0 copied, 5 skipped`.

---

## 3. Activating Serena (once per session)

Every fresh IDE/agent session must call:

```
mcp_serena_activate_project  project = "d:\SteamLibrary\steamapps\common\Left 4 Dead 2\turret"
```

Serena will respond with `Programming languages: cpp` and project name
`turret`. The `cpp` language ID is what wires up `clangd`.

After activation, the project's existing `.serena/cache/cpp/*.pkl` files
(visible in the repo's `.serena/` dir) are reused — Serena is faster on
warm starts.

---

## 4. The Serena tool catalog, in practical use order

### 4.1 Orient first: `get_symbols_overview`

Call this on a file before drilling in. Cheap, gives you the whole file's
shape in one shot.

```
mcp_serena_get_symbols_overview  relative_path = "scripts/vscripts/turret.c"  depth = 1
```

Returns a grouped structure. For `turret.c` you'll see:

- `Enum eTurret` with 21 values
- `Variable explosion_entity`
- 38 `Function` entries, including the mod's main surface: `PlaceTurret`,
  `Turret_Think`, `OnAttackPress`, `OnUsePress`, `ReplaceWeaponSpawn`,
  `PrintTurretList`, `LoadSpecificConfigFile`, plus the duplicate utilities
  the per-survivor tribal state drags in (`IsCertainSurvivor`,
  `GetItemAmmo`, `SetItemAmmo`, etc.)

### 4.2 Drill in: `find_symbol`

Find one specific symbol with its full body. Use the name returned by the
overview, or a substring.

```
mcp_serena_find_symbol
  name_path_pattern = "PlaceTurret"
  relative_path     = "scripts/vscripts/turret.c"
  depth             = 0
  include_body      = true
```

You get the source line range and the body. Example: `PlaceTurret` is at
lines 283–463. Reading the body shows the 8-way `IsCertainSurvivor` ladder
that pulls per-character ammo from `GnomeTurretAmmoNick` etc.

**Known limitation**: Squirrel `class CTurret { ... }` is **not** indexed as
a class by clangd. `find_symbol` for `CTurret` returns `[]`. Use
`get_symbols_overview` to see top-level functions; the `class` body shows
up as a sequence of method definitions at the top level of the file.

### 4.3 Cross-file references: `find_referencing_symbols`

Find where a symbol is used elsewhere. Good for tracking tribal drift.

```
mcp_serena_find_referencing_symbols
  name_path      = "LoadSpecificConfigFile"
  relative_path  = "scripts/vscripts/turret.c"
```

This will surface **both** the local `LoadSpecificConfigFile` and the
duplicate in `lib_utils.c` (because Squirrel re-defines it per file when
the files are loaded as separate scopes). Use this whenever you're about
to change a duplicated helper — to see all the call sites you'd affect.

### 4.4 Text/regex search: `search_for_pattern`

For searches clangd can't do (string contents, comments, multi-line
patterns). Don't prefix with line numbers — pass raw text or regex.

```
mcp_serena_search_for_pattern
  substring_pattern = "GnomeTurret(Ammo)?\\s*=\\s*\\d+"
  paths_include_glob = "*.c"
  relative_path      = "scripts/vscripts"
```

Good for finding config-line assignments like
`GnomeTurretDamage = 0.5`, the per-survivor ammo defaults
(`GnomeTurretAmmoNick = 1000`, etc.), and any literal that needs a sweep.

### 4.5 Diagnostics: `get_diagnostics_for_file`

`clangd` will report a wall of errors because Squirrel is being parsed as
C. **This is noise, not signal**, but two things are worth watching:

- The total error count and which lines repeat. If a new error appears
  on a line you just changed, **that's real** — it's likely a typo
  clangd genuinely catches (`missing ';'` before `}`, unterminated
  string, `expected ')'`).
- Code `enumerator_list_missing_comma` on `eTurret/<something>` lines
  → a real missing comma inside the enum (this is the same shape as
  the known bug in `turret.c` line 1082 in the `DoEntFire` call; if
  that line still shows the diagnostic, the bug is unfixed).

```
mcp_serena_get_diagnostics_for_file
  relative_path = "scripts/vscripts/turret.c"
  min_severity  = 2
```

Set `min_severity = 2` to filter out clangd's Hints; the Errors are the
ones worth reading.

---

## 5. Common recipes for this project

### "What's in this file?"

```
get_symbols_overview  relative_path = "scripts/vscripts/<file>.c"  depth = 1
```

### "Where is `X` defined?"

```
find_symbol  name_path_pattern = "X"  relative_path = "scripts/vscripts/<file>.c"  include_body = true
```

### "Where is `X` used?"

```
find_referencing_symbols  name_path = "X"  relative_path = "scripts/vscripts/<file>.c"
```

### "Show me all places that set per-survivor ammo."

```
search_for_pattern
  substring_pattern = "GnomeTurretAmmo(Nick|Coach|Ellis|Rochelle|Bill|Louis|Francis|Zoey)"
  paths_include_glob = "*.c"
  relative_path      = "scripts/vscripts"
```

### "Did my last edit introduce a new error?"

```
get_diagnostics_for_file
  relative_path = "scripts/vscripts/<file>.c"
  min_severity  = 1
  start_line    = <around your edit>
  end_line      = <around your edit>
```

### "Map every entry point a survivor can trigger."

```
get_symbols_overview  relative_path = "scripts/vscripts/turret.c"  depth = 1
# Pick the chat command registrations; they're calls to RegisterChatCommand
# inside AdditionalClassMethodsInjected.
find_symbol  name_path_pattern = "AdditionalClassMethodsInjected"  include_body = true
```

You'll see the four `RegisterChatCommand("!debugmode", ...)`, `!remove`,
`!ammo`, `!mode` bindings.

---

## 6. Editing the source

**`.c` is the source of truth for development.** L4D2 only loads `.nut`,
but the only analysis surface we have is `clangd`, and `clangd` does not
understand `.nut`. So:

- Edit `.c` files only.
- After the QA gauntlet passes, run `tools\publish.bat` to overwrite
  `.nut` from `.c`. This is the destructive counterpart of the
  non-destructive `c_to_nut.bat`.
- For the full dev cycle (edit → gauntlet → publish → build_vpk →
  feedback → changelog), see [SDLC_AND_QA.md](SDLC_AND_QA.md).

### One-off switches

- If you ever need to drop back to `.nut`-only (no `.c` siblings):
  delete `scripts\vscripts\*.c` manually. The scripts deliberately
  don't delete `.c` files so Serena's index is never lost mid-session.
- If you need to re-sync the `.c` view from the current `.nut`
  (e.g., a teammate edited the `.nut` and you want to bring Serena
  up to speed):
  ```powershell
  tools\nut_to_c.bat
  ```
  This renames `.nut` → `.c` in place. The game is broken until you
  re-publish. Don't run it casually — use the dev cycle orchestrator
  (`tools\dev_cycle.bat`) instead.

### Why both `c_to_nut` and `publish`

- `c_to_nut` is non-destructive. Use it when you want Serena to keep
  indexing the `.c` while the game is running on the `.nut`.
- `publish` is destructive (overwrite). Use it at the end of a dev
  cycle, after the gauntlet, when you're sure the `.c` is canonical.

---

## 7. What clangd gets right vs. wrong

### It indexes correctly (trust these)

- `function name(args) { ... }` — top-level functions, including nested
  ones.
- `enum name { A, B, C }` — clangd parses the list, and Squirrel's
  pattern `Name = 2000.0` (float) just looks like a non-integer
  constant to clangd. The enum is still findable, but the per-value
  values are not "typed".
- `if / else / while / for / switch / return`.
- Most C-shaped expressions.
- Variable declarations, even with Squirrel's `local` keyword (clangd
  treats `local` as an identifier and still indexes the binding).
- Comment text — searchable via `search_for_pattern`.

### It will complain (ignore these unless the line changed)

| Squirrel feature | What clangd says | Why it's noise |
|---|---|---|
| `class Foo { ... }` | `unknown_typename`, `expected_either` | `class` is a C++ keyword; clangd is in C mode. |
| `foreach (k, v in tbl)` | various | C has no `foreach`; parses as a function call. |
| `local x = ...` | `unknown_typename` for `local` | `local` is a Squirrel keyword, not a C type. |
| `tbl["key"]` after a table literal | sometimes `expected ';'` | Squirrel tables look like C designated initializers. |
| `1.0` as enum value | `ice_not_integral` | Squirrel allows floats in enum, C doesn't. |
| `::` scope access | `expected ';' or ','` | Squirrel's scope operator. |

Rule of thumb: **if a diagnostic was already there before your edit, it's
Squirrel-as-C noise. If a diagnostic appeared on a line you changed,
look at it.**

---

## 8. Quick troubleshooting

**Serena returns nothing for a file that exists.**

- Make sure you activated the project (`mcp_serena_activate_project`).
- Check the file is `.c` in `scripts/vscripts/`, not just `.nut`. Serena
  only indexes what the language server sees.
- If you just renamed `.nut` → `.c`, wait a moment — Serena's background
  indexer catches up on the next query. Run `get_symbols_overview` to
  force a touch.

**`find_symbol` for a Squirrel class returns `[]`.**

- Expected. `class CTurret { ... }` is not parseable as C. The methods
  appear at top level in `get_symbols_overview`; find them by their
  `function method_name(...)` form.

**LSP feels stale after a big edit.**

- The `compile_commands.json` for this project doesn't exist — that's
  fine, clangd falls back to extension-based heuristics. To force a full
  rebuild, delete `.serena/cache/cpp/` and re-activate the project.

**`clangd` not on PATH after a machine refresh.**

```powershell
winget install --id LLVM.Clangd --accept-source-agreements --accept-package-agreements --silent
refreshenv
clangd --version
```

**Game won't start after working in Serena mode.**

You left the tree in `.c`-only state (ran `nut_to_c` and never restored).
Fix:

```powershell
tools\c_to_nut.bat
```

You should see `5 copied, 0 skipped`.

---

## 9. See also

- [SDLC_AND_QA.md](SDLC_AND_QA.md) — the full development lifecycle.
- [QA_GAUNTLET.md](QA_GAUNTLET.md) — the triple fact-check passes.
- [FEEDBACK_TEMPLATE.md](FEEDBACK_TEMPLATE.md) — questions to ask the user after in-game test.
- [../CHANGELOG.md](../CHANGELOG.md) — version history (Keep a Changelog).
- [../RELEASE_NOTES.md](../RELEASE_NOTES.md) — curated release highlights.
- [../tools/README.md](../tools/README.md) — script reference.
