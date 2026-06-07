# Contributing to Gnome Turret

> **Quick start**: If you already know Lua/SourcePawn, start with [Before You Start — Key Concepts](#before-you-start--key-concepts) and [Code Conventions](#code-conventions) — especially the `<-` vs `=` distinction and the `.c`/`.nut` duality. Jumping straight to the development cycle without these will cause confusing runtime errors.

## Table of Contents

1. [Before You Start — Key Concepts](#before-you-start--key-concepts)
2. [Environment Setup](#environment-setup)
3. [Project Layout](#project-layout)
4. [Development Cycle](#development-cycle)
5. [Code Conventions](#code-conventions)
6. [QA Gauntlet (Before Publishing)](#qa-gauntlet-before-publishing)
7. [Publishing & Building](#publishing--building)
8. [Configuration Files](#configuration-files)
9. [Testing Strategy (Or Lack Thereof)](#testing-strategy-or-lack-thereof)
10. [Troubleshooting](#troubleshooting)
11. [Pull Request Guidelines](#pull-request-guidelines)
12. [Technical Debt & Known Issues](#technical-debt--known-issues)
13. [Appendix: Squirrel vs Lua/SourcePawn Quick Reference](#appendix-squirrel-vs-luasourcepawn-quick-reference)

---

## Before You Start — Key Concepts

### The `.c` File Trick (DO NOT SKIP)

This project stores its **Squirrel code in `.c` files**. This is intentional — the `.c` extension enables clangd (the LSP) to parse the code, giving you code navigation, syntax highlighting, and basic diagnostics.

**What the game actually loads**: Left 4 Dead 2 loads `.nut` files (Squirrel scripts). The `.c` files are the SOURCE; the `.nut` files are generated copies.

**Rule**: Edit `.c` files only. Never edit `.nut` files directly — they get overwritten when you publish.

### clangd Errors: 95% Are Noise

clangd thinks it's parsing C, but it's parsing Squirrel. Every Squirrel keyword that doesn't exist in C will show as an error:

| clangd Error | Actual Cause | Action |
|---|---|---|
| `unknown type name 'class'` | Squirrel `class` keyword | Ignore |
| `expected ';'` after `foreach` | Squirrel `foreach` keyword | Ignore |
| `use of undeclared identifier 'local'` | Squirrel `local` keyword | Ignore |
| `expected ')'` at `<-` | Squirrel slot operator `<-` | Ignore |
| `unknown type name 'true'` | Squirrel `true` literal | Ignore |

**Real errors to watch for** (on lines YOU changed):
- Missing `;` (Squirrel does need semicolons)
- Unclosed strings
- Missing `)` or `}`
- Typo'd function/variable names

> If clangd reports errors on lines you didn't touch, they're pre-existing noise. Don't "fix" them — fixing them breaks valid Squirrel.

### No Compiler, No Type Checker, No CI

This mod has **zero automated test infrastructure**. There is no build-time type checker, no linter that understands Squirrel, and no CI pipeline. Your only verification is:
1. Manual code review
2. The **QA Gauntlet** (see below)
3. In-game testing

---

## Environment Setup

### Required Tools

| Tool | Purpose | Notes |
|---|---|---|
| **Left 4 Dead 2** | Runtime | Steam install required |
| **clangd** | LSP for `.c` files | Squirrel-as-C parsing (noisy) |
**Serena LSP** | Squirrel-aware analysis | Required for QA gauntlet passes
| **VPK tool** | Package building | Path hardcoded in `tools/build_vpk.ps1` |
| **PowerShell 7+** | Running build tools | Windows, cross-platform shell |

### Serena LSP — Required (Not Optional)

The QA Gauntlet (see below) uses `mcp_serena_*` commands for parse checks and drift detection. Without Serena, you cannot run the QA passes. Activate it once per session:

```
mcp_serena_activate_project  project="D:\SteamLibrary\steamapps\common\Left 4 Dead 2\turret"
```

This gives you:
- Symbol search across Squirrel code
- Definition/reference navigation
- Diagnostics that understand Squirrel (unlike clangd)
- The ability to run QA Gauntlet passes

**If Serena is not available**: you can verify parse correctness by reading `.c` files manually or using the `script_reload` command in-game to catch syntax errors at load time — but the QA Gauntlet procedures in this document assume Serena is active.
### First-Time Setup

1. Clone the repo:
   ```
   git clone https://github.com/zznabil/L4D2-Gnome-Turret-Refactor
   cd turret
   ```

2. Generate `.nut` files from `.c` source so the game can load them:
   ```
   tools\c_to_nut.bat
   ```
   (Copies `.c` → `.nut`. Safe and idempotent — skips if `.nut` already exists.)

3. Activate Serena LSP (once per session — see above).

**Note**: `nut_to_c.bat` (renames `.nut` → `.c`) is only needed if you're recovering from a `.nut`-only checkout. On a fresh clone, `.c` files are already the source — just run `c_to_nut.bat`.

---

## Project Layout

```
turret/
├── scripts/vscripts/          ← ALL source code (.c files)
│   ├── mapspawn_addon.c       # Entry point (1 line)
│   ├── gnome_turret_trigger.c # Per-survivor state, event hooks, inventory, config
│   ├── sm_utilities.c         # Utility framework (startbox, scoring, HUD)
│   ├── lib_utils.c            # Squirrel standard library (~3100 lines)
│   ├── turret.c               # Turret class, placement, targeting, chat commands
│   └── entity_pool.c          # Global entity pool
├── tools/                     # Build and dev tooling
│   ├── publish.ps1            # .c → .nut (destructive overwrite)
│   ├── publish.bat            # Batch wrapper
│   ├── build_vpk.ps1          # VPK packaging
│   ├── build_vpk.bat          # Batch wrapper
│   ├── c_to_nut.ps1           # .c → .nut (safe, idempotent)
│   ├── nut_to_c.ps1           # .nut → .c (in-place rename)
│   ├── cleanup_nut.ps1        # Read-only reachability report
│   └── dev_cycle.bat          # Interactive orchestrator
├── docs/
│   ├── QA_GAUNTLET.md         # QA verification process
│   ├── SDLC.md                # Development lifecycle documentation
│   ├── FEEDBACK_TEMPLATE.md   # Testing feedback form
│   └── SERENA_GUIDE.md        # Serena LSP usage guide
├── dist/                      # Built .vpk output (cleaned each build)
├── .omo/                      # OpenCode work tracking (boulder, plans, notepads)
├── AGENTS.md                  # AI agent instructions (developer notes)
└── README.md                  # User-facing readme
```

### File Load Chain (How the Game Loads Your Code)

```
mapspawn_addon.nut       ← L4D2 auto-loads this (AddonContent_Script:1)
  └─ gnome_turret_trigger.nut  ← IncludeScript("gnome_turret_trigger")
       └─ sm_utilities.nut     ← IncludeScript("sm_utilities")
            ├─ lib_utils.nut   ← IncludeScript("lib_utils")
            ├─ turret.nut      ← IncludeScript("turret")
            └─ entity_pool.nut ← IncludeScript("entity_pool")
```

Key rules:
- `mapspawn_addon.nut` is auto-loaded via `scripts/vscripts/mapspawn_addon` in `addoninfo.txt`
- Each file loads the next via `IncludeScript("name", getroottable())`
- `lib_utils.nut` (~3100 lines) is a shared utility library — functions here are accessible from any file that loads it
- Functions and globals are exported to shared scope via the `::` operator
- `entity_pool.nut` is loaded alongside `lib_utils` and `turret` from `sm_utilities`

### Per-Survivor Globals

State is tracked per survivor via 16 global variables (8 survivors × gnome count + ammo count). These are defined in `gnome_turret_trigger.c` and accessed by `turret.c` via `::` scope:

```
::g_bPlayerHasTurret[N]    ← bool
::g_iPlayerAmmo[N]         ← int
::g_bPlayerHasLaser[N]     ← bool
// ... etc. for each configurable
```

**Important**: These globals are initialized fresh each map. For persistent state, see [Configuration Files](#configuration-files).

---

## Development Cycle

### Full Cycle (Edit → Test → Publish → Build)

```
Edit .c files
    ↓
Run QA Gauntlet (3 passes — see below)
    ↓
tools\publish.bat          ← overwrites .nut from .c
    ↓
tools\build_vpk.bat        ← produces dist/turret.vpk
    ↓
Drop .vpk into game's addons/
```

### Quick Iteration (No VPK Rebuild)

During active development, use L4D2's `script_reload` console command to reload scripts without restarting the map or rebuilding the VPK:

1. Run `tools\publish.bat` to update `.nut` files from your `.c` edits
2. In L4D2, open developer console (~) and type: `script_reload`
3. Scripts reload in-place — test your changes immediately

This works for most changes. Some changes (entity spawning, model/precache changes) still require a map restart.

### Session Startup (Every Session)

```
# 1. Generate .nut files from .c source (safe, idempotent)
tools\c_to_nut.bat

# 2. Activate Serena LSP (once per session)
mcp_serena_activate_project project="D:\SteamLibrary\steamapps\common\Left 4 Dead 2\turret"
```

**Note**: `c_to_nut.bat` copies `.c` → `.nut` and is SAFE (skips if `.nut` already exists). `nut_to_c.bat` does the reverse (`.nut` → `.c`) and is only needed if you're recovering from a `.nut`-only checkout. On a fresh clone, just run `c_to_nut.bat`.

If you previously ran `nut_to_c.bat` to start editing, always run `c_to_nut.bat` afterward so the game can see the scripts.
### Available Chat Commands (For Testing)

| Command | Action | Host Only? |
|---|---|---|
| `!ta default\|explosive\|fire` | Set ammo type | No |
| `!tr [all]` | Remove turret(s) | No |
| `!tm` | Toggle machine gun mode | No |
| `!td` | Toggle debug mode | No |
| `!ts <speed>` | Set sweep speed (deg/sec) | Yes |
| `!tarc <deg>` | Set sweep arc (degrees total) | Yes |
| `!tde 0\|1` | Toggle demolition mode | Yes |
| `!thelp [N]` | Show help / set turret limit | Yes |
| `!tl` | Toggle laser sight | Yes |

### Adding a New Chat Command

To add a new chat command:

1. Define the handler function in the appropriate `.c` file (use `turret.c` for turret-related commands, `gnome_turret_trigger.c` for inventory/config commands).
2. Register the command in the chat command parsing logic in `turret.c` by adding an entry to the command table.
3. Add the `::` global if the command modifies persistent state (e.g., `::g_bLaserEnabled` for `!tl`).
4. If the command changes a configurable, write the new value back to config via `GenerateGnomeTurretCfgFile()`.
5. Add the command to the table above in this document.

See `!tl` (targeting/toggle) or `!thelp` (limit setter) as reference patterns.

---

## Code Conventions

### Naming

| Type | Prefix | Example |
|---|---|---|
| Global variables | `g_` | `g_bLaserEnabled`, `g_iTurretCount` |
| Class members | `m_` | `m_hMachineGun`, `m_iAmmo` |
| Functions | PascalCase | `LoadSpecificConfigFile()`, `ToggleLaser()` |
| Config keys | PascalCase | `GnomeTurretSweepSpeed`, `DemolitionShot` |

### Squirrel Language Quirks

If you know Lua or SourcePawn, here's what's different:

| Concept | Squirrel | Lua | SourcePawn |
|---|---|---|---|
| Variable declaration | `local x = 5` | `local x = 5` | `int x = 5;` |
| New table slot | `table.newfield <- value` | `table.newfield = value` | N/A |
| Existing slot update | `table.field = value` | `table.field = value` | `struct.field = value` |
| Iteration | `foreach (k, v in table)` | `for k,v in pairs(table)` | `for (int i=0; ...)` |
| Global scope | `::globalFunc()` | `_G.globalFunc()` | N/A |
| Include script | `IncludeScript("name", getroottable())` | `require("name")` | `#include <name>` |
| String formatting | `format("x=%d", x)` | `string.format("x=%d", x)` | `Format("x=%d", x)` |
| Ternary | `a ? b : c` | `a and b or c` | `a ? b : c` |
| Function def | `function name(args) { }` | `function name(args) end` | `public void name(args) { }` |
| Class | `class Name { constructor() { } }` | Metatables | `methodmap Name { }` |

### Semicolons Are Required

Unlike Lua, Squirrel requires semicolons at the end of statements. Missing semicolons are one of the few **real** clangd errors.

### The `<-` vs `=` Distinction

- `<-` creates a **new slot** in a table (like assigning to a new key)
- `=` updates an **existing slot**

```squirrel
local t = {}
t.newKey <- "first"    // OK: creates slot
t.newKey = "updated"   // OK: updates existing slot
t.missing = "oops"     // RUNTIME ERROR: slot doesn't exist
```

### Loading Code Across Files

```squirrel
// In gnome_turret_trigger.nut:
IncludeScript("sm_utilities", getroottable())

// Then in turret.nut (loaded by sm_utilities.nut):
// Access globals from gnome_turret_trigger.nut:
::g_bPlayerHasTurret[0] = true    // via :: operator
```

Shared functions and globals are exported via `::` operator to `getroottable()`.

---

## QA Gauntlet (Before Publishing)

> **Do not run `publish.bat` until all 3 passes pass.** Publishing overwrites `.nut` files destructively — if your `.c` has errors, the game won't load.

### Pass 1 — Parse Check

Verify every `.c` file parses without syntax errors:

```
serena tool: get_diagnostics_for_file(path)
```

Check each file in `scripts/vscripts/`:
- `mapspawn_addon.c`
- `gnome_turret_trigger.c`
- `sm_utilities.c`
- `lib_utils.c`
- `turret.c`
- `entity_pool.c`

What to look for:
- **Real errors**: unclosed strings, missing semicolons, missing parentheses, missing commas
- **Noise to ignore**: `class`, `foreach`, `local`, `<-`, `::` — these are Squirrel keywords, not C errors

### Pass 2 — Drift Detection

Several functions are historically duplicated across files (tribal duplication). Check that they haven't diverged:

```
serena tool: search_for_pattern(...)
```

Key functions to check:
- `LoadSpecificConfigFile` — exists in `lib_utils.c`, previously existed in `turret.c` and `gnome_turret_trigger.c`
- Config-related helper functions
- Any function that appears in multiple files

If drift is found, consolidate into `lib_utils.c` and reference via `::` scope.

### Pass 3 — Reachability

Ensure every `.nut` file has at least one load path from the entry point:

```
tools\cleanup_nut.ps1    # Read-only reachability report
```

The tool reports:
- **Loaded**: files with a valid load chain from `mapspawn_addon.nut`
- **Orphaned**: files with no load path — these are dead code

Every `.nut` should be in the "Loaded" list. Orphans indicate either:
- A missing `IncludeScript` call
- A file that should be added to the load chain
- Dead code that should be removed

---

## Publishing & Building

### Step 1: Publish (.c → .nut)

```
tools\publish.bat
```

Or directly:

```
tools\publish.ps1
```

**What it does**: Overwrites each `.nut` file with the content of its `.c` counterpart. This is **destructive** — any changes made directly to `.nut` files (which you shouldn't be doing) will be lost.

**Prerequisite**: `.nut` files must exist for the game to load them. Run `c_to_nut.bat` after editing `.c` files to regenerate `.nut` files for publishing.

### Step 2: Build VPK

```
tools\build_vpk.bat
```

Or directly:

```
tools\build_vpk.ps1
```

**What it does**:
1. Cleans `dist/` directory
2. Runs `vpk.exe` to package scripts, models, materials into `dist/turret.vpk`
3. Shows a 5-second countdown on success

**Output**: `dist/turret.vpk` (ready to drop into L4D2's `addons/` folder)

### Step 3: Deploy

Copy `dist/turret.vpk` to:
```
<SteamLibrary>\steamapps\common\Left 4 Dead 2\left4dead2\addons\turret.vpk
```

---

## Configuration Files

Config files live **outside the project**, under the L4D2 game root:

```
<L4D2>\left4dead2\cfg\gnome turret\
├── gnome turret.txt                  ← Main config
└── virtual inventory\                ← Per-survivor ammo
    └── gnome virtual inventory.txt
```

**The path is relative to the game root**, NOT the project root. The config directory is `cfg\gnome turret\` under your L4D2 installation.

### Config Keys (gnome turret.txt)

| Key | Type | Default | Description |
|---|---|---|---|
| `GnomeTurretSweepSpeed` | float | 45.0 | Rotation speed in deg/sec |
| `GnomeTurretSweepArc` | float | 90.0 | Total sweep arc in degrees |
| `DemolitionShot` | int | 0 | Toggle demolition mode (0/1) |
| `LaserEnabled` | int | 0 | Toggle laser sight (0/1) |
| `MaxTurrets` | int | -1 | Turret limit (-1 = unlimited) |
| `TurretAmmoNormal` | int | 100 | Default ammo count |
| `TurretAmmoExplosive` | int | 50 | Explosive ammo count |
| `TurretAmmoFire` | int | 75 | Fire ammo count |

These are read/merged at runtime by `GenerateGnomeTurretCfgFile()` in `gnome_turret_trigger.c`. The function always writes all known keys to ensure defaults are available even if the config file is missing keys.

### Adding a New Config Key

To add a new persistent config option:

1. Add the key-value pair in `GenerateGnomeTurretCfgFile()` in `gnome_turret_trigger.c` (alongside existing keys like `LaserEnabled`).
2. Read the value via `FileToString()` + parsing logic at session start.
3. Store it in a `::` global variable (e.g., `::g_bMyNewOption`).
4. Use `::` global in the runtime code path (turret placement, targeting, etc.).
5. Add a chat command to toggle it at runtime, writing the new value back to config.

See existing patterns like `LaserEnabled`/`!tl` for reference.

## Testing Strategy (Or Lack Thereof)

**There is no test framework.** This mod has:
- ❌ No automated test runner
- ❌ No type checker for Squirrel
- ❌ No CI pipeline
- ❌ No linting that understands Squirrel

All testing is manual:
1. **Parse check** (QA Pass 1) catches syntax errors
2. **Drift detection** (QA Pass 2) catches function divergence
3. **In-game testing**: Drop the VPK, load a map, use chat commands to exercise features
4. **`script_reload`**: Quick iteration without map restarts
5. **Feedback template**: Use `docs/FEEDBACK_TEMPLATE.md` to report structured testing results

When adding new functionality:
- Test with multiple survivors
- Test through map transitions (config persistence)
- Test with `script_reload` after initial implementation
- Test full VPK build + map restart before finalizing

---

## Troubleshooting

### "Game doesn't load my changes"

| Symptom | Likely Cause | Fix |
|---|---|---|
| Old behavior persists | `.nut` files out of sync | Run `publish.bat` to sync `.c` → `.nut` |
| Script errors at load | Syntax error in `.c` | Run QA Pass 1 — check for real errors |
| `SCRIPT ERROR: [...]` at map load | Syntax error in `.nut` | Check unclosed strings, missing semicolons, missing `)` or `}` in your changed lines |
| `SCRIPT ERROR: Invalid parameter` | Wrong arg type/count | Check function signatures match their callsites |
| Config not persisting | Config not written after change | Ensure `GenerateGnomeTurretCfgFile()` includes your new key |
| clangd shows errors everywhere | Squirrel-as-C noise | Check if errors are on YOUR changed lines; ignore others |
| `script_reload` doesn't work | Change requires map restart | Restart map or use full VPK build |

### "clangd is red everywhere"

This is normal. See [Before You Start — Key Concepts](#before-you-start--key-concepts). The vast majority of clangd errors are Squirrel keywords that clangd interprets as C syntax errors.

### "VPK build fails"

Check:
- vpk.exe path in `tools/build_vpk.ps1` — it's hardcoded
- `dist/` directory is writable
- No VPK files are locked by another process

### "How do I test without rebuilding VPK?"

Use `script_reload`:
1. `publish.bat` to sync `.c` → `.nut`
2. In L4D2 console: `script_reload`
3. Changes apply immediately

### "How do I see debug output?"

Use `!td` to toggle debug mode in-game. Debug messages appear in the developer console (~).

---

## Pull Request Guidelines

### Before Submitting

- [ ] All 3 QA Gauntlet passes pass (parse, drift, reachability)
- [ ] `publish.bat` + `build_vpk.bat` run without errors
- [ ] Changes tested in-game (with `script_reload` or full VPK)
- [ ] New config keys added to `GenerateGnomeTurretCfgFile()`
- [ ] No `.nut` files edited directly — only `.c` files
- [ ] clangd errors on unchanged lines are NOT "fixed"
- [ ] CHANGELOG.md updated with a brief description of changes

### PR Description Template

```markdown
## Summary
<!-- One-line description -->

## Changes
<!-- List of changes with file:line references -->

## Testing
<!-- How was this tested? script_reload? Full VPK? What scenarios? -->

## Config Changes
<!-- Any new config keys? Are they written by GenerateGnomeTurretCfgFile()? -->

## Related Issues
<!-- Closes #N, addresses #N, etc. -->
```

### What Gets Reviewed

1. **Correctness** — Does the code do what it claims?
2. **Consistency** — Does it follow project conventions (naming, pattern, structure)?
3. **Config persistence** — Are new configurables written to config file?
4. **Load chain** — Does it break any IncludeScript dependencies?
5. **Per-survivor state** — Does it handle all 8 survivors correctly?
6. **QA gauntlet** — Have the 3 passes been run?

---

## Technical Debt & Known Issues

### Tribal Duplication

Several functions exist in multiple files (`LoadSpecificConfigFile` and config helpers). The codebase was historically restructured to use `getroottable()` exports instead of duplication, but remnants may still exist. If you find a function duplicated across files, consolidate it into `lib_utils.c`.

### Orphan Functions

After the file restructure, some functions in `sm_utilities.c` may no longer be called from anywhere. These are candidates for cleanup.

### clangd Incompatibility

The `.c` extension trick is a hack. It enables basic LSP features but produces hundreds of false errors. There is no proper Squirrel LSP for clangd.

### No Test Framework

The lack of automated testing means regression is possible. Always run the full QA gauntlet and do in-game testing.

### Config File Path Hardcoding

Config paths are relative to the L4D2 game root. If L4D2 is installed to a nonstandard location, only the game's own `GetCfgDirectory()` calls will find them correctly. The path `cfg\gnome turret\` is hardcoded in script.

### Entity Pool Integration

`entity_pool.c` is included in the build but its interaction with the main turret system may not be fully exercised. Changes to entity lifecycle logic should test with the pool enabled.

---

## Appendix: Squirrel vs Lua/SourcePawn Quick Reference

### If You Know Lua

| You want... | In Lua | In Squirrel |
|---|---|---|
| Declare a variable | `local x = 5` | `local x = 5` |
| Define a function | `function f(x) ... end` | `function f(x) { ... }` |
| String concat | `"a" .. "b"` | `"a" + "b"` |
| Not-equal | `~=` | `!=` |
| Ternary | `a and b or c` | `a ? b : c` |
| For loop | `for i=1,10 do` | `for (local i = 1; i <= 10; i++)` |
| Table iteration | `for k,v in pairs(t)` | `foreach (k, v in t)` |
| New key in table | `t.k = v` | `t.k <- v` (new) or `t.k = v` (existing) |
| Length | `#t` | `t.len()` |
| Comments | `-- comment` | `// comment` or `/* block */` |
| Include file | `require("file")` | `IncludeScript("file", getroottable())` |

### If You Know SourcePawn

| You want... | In SourcePawn | In Squirrel |
|---|---|---|
| Variable | `int x = 5;` | `local x = 5` |
| Function | `public void f() { }` | `function f() { }` |
| Array | `int arr[10];` | `local arr = array(10)` |
| String format | `Format(buf, sz, "%d", x)` | `format("x=%d", x)` |
| If/else | `if (x) { } else { }` | Same |
| Switch | `switch (x) { case 1: }` | Same (needs `break`) |
| Ternary | `x ? a : b` | Same |
| For loop | `for (int i=0; i<10; i++)` | Same (`local` instead of type) |
| Class | `methodmap Name { }` | `class Name { constructor() { } }` |
| Enum | `enum { A, B }` | `enum { A, B }` |
| Null | `view_as<int>(0)` / `null` | `null` |
| Boolean | `true`/`false` | Same |

### Common Squirrel Pitfalls

1. **`<-` vs `=`** — Using `=` on a nonexistent slot is a RUNTIME error, not a silent create. Use `<-` for new slots.
2. **Semicolons** — Required. Forgetting them is a real syntax error.
3. **`foreach` syntax** — `foreach (k, v in table)` with `in`, not `,`.
4. **`::` operator** — Required to access globals from other files. `GlobalVar` won't work; `::GlobalVar` will.
5. **No automatic type coercion** — Unlike Lua, Squirrel is stricter about types. `"5" + 5` is a type error.
6. **Classes are reference types** — Assignment copies references, not values.
7. **Array length** — `arr.len()`, not `#arr` or `sizeof(arr)`.
