# Repository Guidelines — Gnome Turret Mod (L4D2 VScript)

> Stop. Read this before you touch anything. This is NOT a normal project.

## Project Structure & Module Organization

This is a **Left 4 Dead 2 VScript mod** written in Squirrel. The source code is in `.c` files (to enable clangd/Squirrel-as-C parsing) which get published to `.nut` files that the game actually loads.

### Load Chain

```
mapspawn_addon.nut    ← L4D2 auto-loads (AddonContent_Script:1)
  └─ vscripts="gnome_turret_trigger" → gnome_turret_trigger.nut  ✓ RUNS
       └─ IncludeScript("sm_utilities") → sm_utilities.nut  ✓
            ├─ IncludeScript("lib_utils") → lib_utils.nut  ✓
            └─ IncludeScript("turret") → turret.nut  ✓
```

### File Map

| File | Role | Loaded |
|------|------|--------|
| `scripts/vscripts/mapspawn_addon.c` | Entry point (1 line) | ✓ auto |
| `scripts/vscripts/gnome_turret_trigger.c` | Per-survivor state, event hooks, inventory | ✓ |
| `scripts/vscripts/sm_utilities.c` | Utility framework (startbox, scoring, HUD) | ✓ via trigger |
| `scripts/vscripts/lib_utils.c` | Squirrel library (~3074 lines) | ✓ via sm_utilities |
| `scripts/vscripts/turret.c` | Turret class, placement, targeting, chat commands | ✓ via sm_utilities |
| `addoninfo.txt` | Addon manifest | — |
| `scripts/vscripts/` | All VScript source | — |
| `tools/` | Build and dev tooling | — |
| `docs/` | QA gauntlet, SDLC, Serena guide, feedback template | — |
| `dist/` | Built `.vpk` output (cleaned each build) | — |
| `.omo/` | OpenCode work tracking (boulder, plans, notepads) | — |

## Build, Test, and Development Commands

### Session Startup (every session)

```powershell
# 1. Ensure .c view is current
tools\nut_to_c.bat

# 2. Restore .nut so the game can run (hybrid mode, safe, idempotent)
tools\c_to_nut.bat

# 3. Activate Serena LSP (MANDATORY — once per session)
mcp_serena_activate_project  project="d:\SteamLibrary\steamapps\common\Left 4 Dead 2\turret"
```

### Edit → Verify → Publish → Build Cycle

```
Edit .c → QA Gauntlet (3 passes) → publish.bat → build_vpk.bat → user tests
```

| Step | Command | Notes |
|------|---------|-------|
| Edit | Edit `scripts/vscripts/*.c` only | Never touch `.nut` directly |
| Verify | `mcp_serena_*` per `docs/QA_GAUNTLET.md` | Parse → Drift → Reachability. Stop on failure. |
| Publish | `tools\publish.bat` | **Destructive** — overwrites `.nut` from `.c`. Run only after gauntlet passes. |
| Build | `tools\build_vpk.bat` | Produces `dist/turret.vpk`. vpk.exe path is hardcoded. |
| Test | Drop `.vpk` into L4D2 `addons/` | Ask `docs/FEEDBACK_TEMPLATE.md` questions. |

### Tools Reference

| Tool | Effect | Danger |
|------|--------|--------|
| `c_to_nut.bat` | Copies `.c` → `.nut`. Skips if `.nut` exists. | **Safe** (idempotent) |
| `nut_to_c.bat` | Renames `.nut` → `.c` in place | **Breaks game** until re-published |
| `publish.bat` | Overwrites `.nut` from `.c` | **Destructive** — only after QA gauntlet |
| `build_vpk.bat` | Runs `vpk.exe` → `dist/turret.vpk` | Hardcoded vpk.exe path |
| `cleanup_nut.bat` | Read-only reachability report | **Read-only** — never deletes |
| `dev_cycle.bat` | Orchestrator (interactive) | Pauses for gauntlet confirmation |
| `graphify-run.bat` | Builds semantic code graph | Requires `graphify` binary |
| `graphify-query.bat`| Queries graph with natural language | Requires existing graph |
| `graphify-status.bat`| Summarizes graph health & stats | Read-only |

**There is no test runner, no compiler, no type checker, no CI.** The QA gauntlet is your ONLY verification. The user is the tester.

### Quick Iteration

Use L4D2 console command `script_reload` to reload scripts in-game without rebuilding the `.vpk`.

## Coding Style & Naming Conventions

### Source of Truth Rule

- **Edit `.c` only.** NEVER edit `.nut` directly — it gets overwritten by `publish.bat`.
- `.c` files are Squirrel code renamed to `.c` so Serena/clangd can parse them. The game loads `.nut` files. They must match byte-for-byte.
- No Squirrel LSP exists. The rename-to-`.c` hack + clangd is the only analysis surface available.

### Squirrel Language Notes

- `<-` operator for new table slots, `=` for existing slots.
- `local` keyword for variable declarations.
- `foreach (k, v in table)` for iteration.
- `IncludeScript("name", getroottable())` for cross-file loading into shared scope.
- Shared functions and globals are exported via `::` operator (see `gnome_turret_trigger.c:975-1051`).

### Clangd Error Classification (95% Noise)

clangd parses Squirrel as C and reports dozens of errors per file. This is normal.

- **Noise (ignore):** `class`, `foreach`, `local`, float enums, `::` scope operator — present before your edit.
- **Signal (investigate):** `missing ';'`, unclosed strings, `expected ')'`, missing commas — appeared on a line you changed.
- `class CTurret` is NOT findable by clangd. Use `find_symbol` by method name instead.

## Testing Guidelines

This project has **no automated test framework**. Verification is manual via the QA Gauntlet:

1. **Pass 1 — Parse Check:** Verify all `.c` files parse without syntax errors.
2. **Pass 2 — Drift Detection:** Confirm no divergence between duplicated functions across files (especially `lib_utils.c` vs `gnome_turret_trigger.c`).
3. **Pass 3 — Reachability:** Ensure every `.nut` file has at least one load path from the entry point. No orphans.

See `docs/QA_GAUNTLET.md` for the full checklist and `mcp_serena_*` commands to run each pass.

## Workflow & Tooling Gotchas

- **`dev_cycle.bat` is interactive** — It pauses with `Read-Host "Type 'gauntlet passed' to continue"`. Run individual steps instead: `nut_to_c.ps1` → QA gauntlet → `publish.ps1` → `build_vpk.ps1`.
- **`build_vpk.bat` auto-closes** — 5-second countdown on success. Call `build_vpk.ps1` directly to capture output.
- **`build_vpk.ps1` cleans `dist/` each run** — Don't store anything valuable in `dist/`.
- **`c_to_nut.ps1` silently skips existing `.nut`** — Does NOT compare content or timestamps. Use `publish.ps1` to force overwrite from `.c`.
- **`publish.ps1` requires `.c` files** — If only `.nut` files exist, run `nut_to_c.ps1` first.
- **Config file paths are game-relative** — `gnome turret/gnome turret.txt` and `gnome turret/virtual inventory/gnome virtual inventory.txt` are relative to the L4D2 game root, NOT the project root.
- **No VCS, no CI.** Single developer. No git repository.

## Agent-Specific Instructions

### OpenCode Workflow (.omo/)

This project uses OpenCode's `.omo/` directory for work tracking:

| Path | Purpose |
|------|---------|
| `.omo/boulder.json` | Active work sessions, plan state, task completion |
| `.omo/plans/` | Prometheus-generated work plans (referenced by boulder.json) |
| `.omo/run-continuation/` | Session state for resuming interrupted ULW loops |
| `.omo/notepads/` | Working memory across sessions (learnings, decisions, issues) |

**Conflict resolution:** `boulder.json` records factual history. `AGENTS.md` describes the intended current state. When they conflict, `AGENTS.md` is the target. Flag discrepancies to the user.

**No `opencode.json` exists** in this repo. Do NOT create one.

### What NOT To Do

1. **DO NOT edit `.nut` files directly** — Next publish/nut_to_c overwrites them.
2. **DO NOT edit source `.c` files without running publish + build afterward** — Changes don't reach the game until rebuilt.
3. **DO NOT "fix" clangd errors** — They're Squirrel-as-C noise. Fixing them breaks valid Squirrel.
4. **DO NOT run publish.bat without passing the QA gauntlet first** — It's destructive.
5. **DO NOT create new `.c` files without adding a load edge** — Reachability pass will flag them as orphans.

## Additional References

- **Button bitmask:** Fire=1, Jump=2, Duck=4, Forward=8, Back=16, Use=32, Left=512, Right=1024, Shove=2048, Reload=8192, Score=65536, Zoom=524288.
- **Per-survivor globals:** 16 vars (8 survivors × gnome count + ammo count each). Defined in `gnome_turret_trigger.c` and exported to `turret.c` via `::` operator. Only `TurretDataSaveTimer` and `g_*` utility globals remain in `turret.c`.
- **Tribal duplication:** 12+ functions were historically duplicated across files (e.g., `LoadSpecificConfigFile` existed in lib_utils.c, turret.c, AND gnome_turret_trigger.c). After the orphan fix, turret.c accesses shared functions via `getroottable()` exports. QA Pass 2 (Drift) catches any remaining divergence.
- **Former orphan fix (verified 2026-06-05 code-level, runtime unconfirmed):** `gnome_turret_trigger.c:973` loads `sm_utilities` → `lib_utils` + `turret` into shared scope. If the mod doesn't work at runtime, run `tools\publish.bat` then `tools\build_vpk.bat`.
