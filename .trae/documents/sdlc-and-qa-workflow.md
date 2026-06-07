# Plan: SDLC + QA Gauntlet Workflow

## 1. Summary

Adopt a documented SDLC for the Gnome Turret Mod that uses Serena's LSP as a
QA gauntlet (because no native Squirrel compiler/syntax-checker exists).
The cycle is:

1. **Edit `.c` only.** The `.nut` files are auto-generated artifacts.
2. **Triple fact-check** every change via Serena MCP: **Parse** (structure
   intact), **Drift** (duplicated tribal helpers both still reachable),
   **Reachability** (every `.nut` is loaded by the L4D2 entry chain).
3. **Publish** by overwriting `.nut` from `.c`.
4. **Compile** to `.vpk`.
5. **User tests in-game.**
6. **Agent collects feedback** and writes a **changelog entry**.

The plan delivers the docs, scripts, and changelog scaffolding for this
loop.

---

## 2. Current State Analysis (deep dive, re-verified this turn)

### 2.1 What's already in place
- [tools/nut_to_c.ps1](file:///d:/SteamLibrary/steamapps/common/Left%204%20Dead%202/turret/tools/nut_to_c.ps1) / [.bat](file:///d:/SteamLibrary/steamapps/common/Left%204%20Dead%202/turret/tools/nut_to_c.bat) — rename in place.
- [tools/c_to_nut.ps1](file:///d:/SteamLibrary/steamapps/common/Left%204%20Dead%202/turret/tools/c_to_nut.ps1) / [.bat](file:///d:/SteamLibrary/steamapps/common/Left%204%20Dead%202/turret/tools/c_to_nut.bat) — non-destructive copy.
- [tools/README.md](file:///d:/SteamLibrary/steamapps/common/Left%204%20Dead%202/turret/tools/README.md), [docs/SERENA_LSP_GUIDE.md](file:///d:/SteamLibrary/steamapps/common/Left%204%20Dead%202/turret/docs/SERENA_LSP_GUIDE.md), plan file at [.trae/documents/squirrel-to-c-workaround-scripts.md](file:///d:/SteamLibrary/steamapps/common/Left%204%20Dead%202/turret/.trae/documents/squirrel-to-c-workaround-scripts.md).
- `clangd 22.1.6` globally installed.
- `.serena/project.yml` declares `languages: cpp` — Serena's LSP is wired.
- Hybrid mode active: 5 `.nut` + 5 `.c` co-exist in `scripts/vscripts/`.
- Real `vpk.exe` located at `D:\SteamLibrary\steamapps\common\Left 4 Dead 2\bin\vpk.exe`.

### 2.2 File roles (corrected)

| File | Lines | Role |
|---|---|---|
| [mapspawn_addon.nut](file:///d:/SteamLibrary/steamapps/common/Left%204%20Dead%202/turret/scripts/vscripts/mapspawn_addon.nut) | 1 | L4D2 auto-loaded entry for `AddonContent_Script 1` mods. Single line: `SpawnEntityFromTable("env_soundscape_triggerable", { vscripts = "gnome_turret_trigger" });` |
| [gnome_turret_trigger.nut](file:///d:/SteamLibrary/steamapps/common/Left%204%20Dead%202/turret/scripts/vscripts/gnome_turret_trigger.nut) | 100+ | Loaded by the soundscape trigger. Contains per-survivor state (`GnomeTurretNick`, `GnomeTurretAmmoCoach`, etc.), button bitmasks (`FireButton`, `DuckButton`, etc.), model paths, icon strings, and the first batch of helpers (`CfgFileCheck`, `GenerateGnomeTurretCfgFile`, …). |
| [sm_utilities.nut](file:///d:/SteamLibrary/steamapps/common/Left%204%20Dead%202/turret/scripts/vscripts/sm_utilities.nut) | 1,566 | Last 6 lines do `IncludeScript("lib_utils", getroottable())` + `IncludeScript("turret", getroottable())` + printl banner. The other 1,560 lines are L4D2 mutation boilerplate (`TeleportPlayersToStartPoints`, `StartboxSpeedbump_Info`, …). |
| [lib_utils.nut](file:///d:/SteamLibrary/steamapps/common/Left%204%20Dead%202/turret/scripts/vscripts/lib_utils.nut) | 3,074 | Utility library: `CEntity`, `RegisterOnTickFunction`, math/vector/quat helpers, ConVars. |
| [turret.nut](file:///d:/SteamLibrary/steamapps/common/Left%204%20Dead%202/turret/scripts/vscripts/turret.nut) | 1,639 | `class CTurret`, `PlaceTurret`, `Turret_Think`, `OnAttackPress`, `OnUsePress`, chat command registrations. |

### 2.3 Critical bug found in the mod load chain

`sm_utilities.nut` (which includes `lib_utils` and `turret`) is **never
loaded by anything in the project**. A grep for `IncludeScript` across all
5 `.nut` files returns matches only in `sm_utilities.nut` itself. A grep
for `vscripts = "sm_utilities"` returns zero matches. The only loading
edges that exist in the project are:

- L4D2 auto-loads `mapspawn_addon.nut` (well-known convention).
- `mapspawn_addon.nut` calls `SpawnEntityFromTable("env_soundscape_triggerable", { vscripts = "gnome_turret_trigger" })` — the soundscape trigger runs `gnome_turret_trigger.nut`.

That means `sm_utilities.nut`, `lib_utils.nut`, and `turret.nut` are
**dead code at runtime**. The mod's actual logic (place turret, target
acquisition, shoot, chat commands) is never executed. Pass 3
(Reachability) of the gauntlet will surface this every time — that's by
design, and fixing the load chain is out of scope for this plan.

### 2.4 Stale descriptions in existing docs

The plan file and the LSP guide describe `gnome_turret_trigger.nut` as
the 1-line bootstrap and `mapspawn_addon.nut` as a 1,566-line mutation
file. **Both descriptions are swapped.** The corrections are tabulated
above (2.2) and the doc updates in §3.3 fix them.

---

## 3. Proposed Changes

### 3.1 New docs

| File | Purpose |
|---|---|
| `docs/SDLC_AND_QA.md` | The full SDLC: phases, what each role does, what the agent does, what the user does. The single entry point for the workflow. |
| `docs/QA_GAUNTLET.md` | The triple fact-check as a step-by-step checklist the agent follows before publishing. Maps each pass to specific `mcp_serena_*` calls. |
| `docs/FEEDBACK_TEMPLATE.md` | Standard questions the agent asks the user after the user runs the in-game build. |
| `CHANGELOG.md` (project root) | Keep a Changelog 1.1.0 format. Sections: `## [Unreleased]` + per-release `## [VERSION] - DATE` with `### Added`/`### Changed`/`### Fixed`/`### Removed`. |
| `RELEASE_NOTES.md` (project root) | Curated highlights for the Steam Workshop description or readme. One section per release. |

### 3.2 New scripts

| File | Purpose |
|---|---|
| `tools/publish.ps1` / `.bat` | **Destructive** `.c` → `.nut` (overwrites the existing `.nut`). Used at the end of a successful dev cycle. |
| `tools/build_vpk.ps1` / `.bat` | Runs the real `vpk.exe` (resolved to `D:\SteamLibrary\steamapps\common\Left 4 Dead 2\bin\vpk.exe`) against the project root, producing `<projectname>.vpk` in `dist/`. |
| `tools/cleanup_nut.ps1` / `.bat` | Static report: for every `.nut` in `scripts/vscripts/`, prints `REACHABLE` or `ORPHAN: <reason>`. Never deletes. |
| `tools/dev_cycle.ps1` / `.bat` | Orchestrator: prints the steps the agent must follow (nut_to_c → gauntlet prompt → publish → build_vpk → ask for feedback). Does **not** run the gauntlet itself (that's an MCP/agent action); it just sequences the scripts. |

### 3.3 Updates to existing docs (corrections + cross-references)

| File | Change |
|---|---|
| `tools/README.md` | Add a "Workflow / dev cycle" section linking to `docs/SDLC_AND_QA.md`, the new tools, and the changelog. Keep the existing rename-script docs intact. |
| `docs/SERENA_LSP_GUIDE.md` | Fix the swapped file descriptions in §5's "Map every entry point a survivor can trigger" recipe (refer to the correct file: `mapspawn_addon.nut` is the entry, `gnome_turret_trigger.nut` is the state file). Add a "See also: `docs/SDLC_AND_QA.md`" footer. |
| `.trae/documents/squirrel-to-c-workaround-scripts.md` | Fix the swapped file descriptions in §2.1. Note in §2.2 that `sm_utilities.nut` is currently unreachable (flag for the user). |

---

## 4. Triple Fact-Check Definition

The gauntlet is run by the **agent** (not by a script), because every pass
is a `mcp_serena_*` MCP call. `tools/dev_cycle.ps1` prompts the agent to
run them; the actual calls are documented in `docs/QA_GAUNTLET.md`.

### Pass 1: Parse
For each `.c` in `scripts/vscripts/`:
- `mcp_serena_get_symbols_overview  relative_path = "scripts/vscripts/<name>.c"  depth = 1`
- **Fail if** the response contains zero symbols (file is unparseable by clangd).
- **Pass if** at least one Enum / Function / Variable is returned.

This is a smoke test. It catches obvious corruption (truncated file,
accidental deletion of a brace) faster than a full symbol walk.

### Pass 2: Drift
For each known tribal-duplicated helper (the long list identified in
§2.4 of the previous plan — `LoadSpecificConfigFile`, `IsCertainSurvivor`,
`GetSecondarySlot`, `ForcedToSwitchSecondary2`, `GetButtonPressed`,
`GetItemAmmo`, `SetItemAmmo`, `ShowSpecialHint`, `CfgFileCheck`,
`GenerateGnomeTurretCfgFile`, `GenerateGnomeVirtualInventory`,
`GenerateGnomeVirtualInventoryReset`, per-survivor `GnomeTurretAmmo*` /
`GnomeTurret*` globals, button bitmask constants):

- `mcp_serena_find_referencing_symbols  name_path = "<helper>"  relative_path = "scripts/vscripts/lib_utils.c"`
- `mcp_serena_find_referencing_symbols  name_path = "<helper>"  relative_path = "scripts/vscripts/turret.c"`
- **Pass if** at least one reference exists in each file's referenced set, **OR** the duplication was intentionally removed (the doc records this in `CHANGELOG.md`).
- **Fail / flag if** a "duplicate" has zero references in one file (it's now dead code; delete the duplicate or merge).

### Pass 3: Reachability
- `mcp_serena_search_for_pattern  substring_pattern = "IncludeScript\\s*\\(\\s*\"([^\"]+)\""  paths_include_glob = "*.c"  relative_path = "scripts/vscripts"` — yields all `IncludeScript` targets.
- `mcp_serena_search_for_pattern  substring_pattern = "vscripts\\s*=\\s*\"([^\"]+)\""  paths_include_glob = "*.c"  relative_path = "scripts/vscripts"` — yields all `vscripts = "..."` targets.
- Hand-build the load graph (the agent does this mentally; the doc gives the rules):
  - L4D2 entry → `mapspawn_addon.nut` (auto-load)
  - `mapspawn_addon.nut` → `gnome_turret_trigger.nut` (soundscape trigger)
  - `gnome_turret_trigger.nut` → no `IncludeScript` calls; stop
  - **Anything else is currently an orphan.** Expected: `sm_utilities.nut`, `lib_utils.nut`, `turret.nut`.
- **Fail** if any orphan is not annotated in `CHANGELOG.md` as "intentionally orphaned for refactor" or similar. Otherwise **pass with warnings**.

`tools/cleanup_nut.ps1` runs the same logic at the script level (without
the Serena MCP), so the user can confirm reachability status without
activating a session.

---

## 5. The full dev cycle (per `docs/SDLC_AND_QA.md`)

```
┌──────────────────────────────────────────────────────────────────────┐
│  AGENT  1. cd to project root                                        │
│         2. tools\nut_to_c.bat     (ensures .c view is current)       │
│         3. mcp_serena_activate_project                              │
│         4. Edit scripts/vscripts/*.c                                │
│         5. Run QA gauntlet (Parse / Drift / Reachability)           │
│         6. tools\publish.bat      (overwrites .nut from .c)         │
│         7. tools\build_vpk.bat    (produces dist/<name>.vpk)         │
│         8. Update CHANGELOG.md (Unreleased section)                 │
│                                                                      │
│  USER   9. Drop dist/<name>.vpk into L4D2/left4dead2/addons/        │
│        10. Launch L4D2, play a map                                  │
│                                                                      │
│  AGENT 11. Ask user the FEEDBACK_TEMPLATE questions                 │
│        12. If feedback = "good, ship it": cut a release:             │
│              - rename `## [Unreleased]` → `## [VERSION] - DATE`      │
│              - curate highlights into RELEASE_NOTES.md               │
│        13. Loop back to step 1                                       │
└──────────────────────────────────────────────────────────────────────┘
```

Step 1–2 happen once per session. Step 3 once per session. Steps 4–13
repeat per change.

---

## 6. Changelog / Release Notes (Keep a Changelog 1.1.0)

`CHANGELOG.md` template (delivered as the initial file):

```markdown
# Changelog

All notable changes to the Gnome Turret Mod are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added
- (nothing yet)

### Changed
- (nothing yet)

### Fixed
- (nothing yet)

### Removed
- (nothing yet)

## [2.0.0] - 2025-XX-XX

### Added
- Initial release by Sw1ft.
- Placeable gnome turret (left-click) with per-survivor ammo tracking.
- Chat commands: `!debugmode`, `!remove`, `!ammo`, `!mode`.
- Virtual inventory persistence across rounds.
```

`RELEASE_NOTES.md` template (delivered as the initial file):

```markdown
# Release Notes

Curated highlights for each release. Used as the basis for the Steam
Workshop description and the mod's README.

## v2.0.0 (current)
- Placeable gnome turret that shoots at infected.
- Per-survivor ammo, virtual inventory, four chat commands.
- Built on Valve's VScript + Sw1ft's `lib_utils` framework.
```

Process: every dev cycle that produces a user-visible change adds a
bullet under `## [Unreleased]`. When cutting a release, the agent
renames the section to `## [VERSION] - DATE` and copies the relevant
bullets into a new `## vX.Y.Z` block in `RELEASE_NOTES.md`.

---

## 7. In-game Feedback Template (`docs/FEEDBACK_TEMPLATE.md`)

After the user runs the in-game build, the agent asks:

1. **Mod load:** did the mod load without console errors? (paste any
   red text from the L4D2 console if present)
2. **Core feature:** does the new behavior work as described in the
   CHANGELOG entry? (yes / no / partial — describe)
3. **Stability:** any crashes, freezes, or visual glitches?
4. **Balance:** are the numbers (damage, ammo, range) where you want them?
5. **Polish:** anything that feels off, even if you can't name it?
6. **Next:** what would you like to see in the next iteration?

If the user says "good, ship it" to all six, the agent proceeds to the
release-cut steps in §5.

---

## 8. Assumptions & Decisions

1. **Triple fact-check = three different passes** (Parse / Drift /
   Reachability), not three repetitions of the same check. This is the
   most useful interpretation given the user's "no proper squirrel
   tools" constraint — we use every dimension of the LSP, not just one.
2. **Cleanup tool flags only, never deletes.** Per user choice. The
   user manually decides what to do with orphans.
3. **The broken mod load chain (`sm_utilities.nut` never loaded) is
   out of scope to fix.** The QA gauntlet surfaces it; the user triages.
4. **The real `vpk.exe` is resolved by absolute path.** Future Steam
   updates that move the file will require editing `tools/build_vpk.ps1`.
   The script fails with a clear error if the exe is missing.
5. **Changelog follows Keep a Changelog 1.1.0.** The user can switch to
   a different format later; the templates are easy to rewrite.
6. **No git hooks or CI.** The project has no VCS in the tree.
7. **Windows-only.** Same as the previous plan.
8. **The dev_cycle orchestrator does NOT run the gauntlet.** The
   gauntlet is an MCP/agent action, not a CLI script. The orchestrator
   prints the steps and pauses for the agent to do the right thing.
9. **Fixed file descriptions in existing docs are a correction, not a
   rewrite.** Only the swapped paragraphs change; the rest of the
   LSP guide and the plan file stay as they are.

---

## 9. Verification

After implementation:

1. **Parse-check** every new `.ps1`:
   `pwsh -NoProfile -Command "[scriptblock]::Create((Get-Content -Raw -LiteralPath <file>))"`
2. **Round-trip test** of `tools/cleanup_nut.ps1`:
   - Should report `ORPHAN: sm_utilities.nut (no edge loads it from any reachable .nut)`
   - Should report `ORPHAN: lib_utils.nut` and `turret.nut` (only reachable through sm_utilities)
   - Should report `REACHABLE: mapspawn_addon.nut (L4D2 auto-load)`
   - Should report `REACHABLE: gnome_turret_trigger.nut (loaded by mapspawn_addon.nut)`
   - Should NOT delete anything.
3. **`tools/publish.ps1` smoke test** in a temp dir: copy a `.c`, create
   a `.nut` with different content, run publish, confirm `.nut` now
   matches `.c`. (Cleanup after.)
4. **`tools/build_vpk.ps1` smoke test**: run with no args, expect it to
   print "vpk.exe not found at …" or actually produce a vpk. Both are
   acceptable; just confirm it doesn't crash.
5. **Dry-run of the agent gauntlet** (manual, by the agent): run the
   three passes against the current tree, confirm Pass 3 reports the
   same orphans as `cleanup_nut.ps1`.
6. **Doc review**: open `docs/SDLC_AND_QA.md`, `docs/QA_GAUNTLET.md`,
   `docs/FEEDBACK_TEMPLATE.md`, `CHANGELOG.md`, `RELEASE_NOTES.md` —
   confirm each is readable and references real files / tool names.
7. **Existing doc corrections**: open `docs/SERENA_LSP_GUIDE.md` and
   `.trae/documents/squirrel-to-c-workaround-scripts.md`, confirm the
   swapped paragraphs now match the table in §2.2.
