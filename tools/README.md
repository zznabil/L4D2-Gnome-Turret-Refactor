# Squirrel ↔ C Rename Workaround for Serena Tools

This folder contains the rename scripts (toggle between `.nut` and `.c`)
plus the dev-cycle tooling (publish, build_vpk, cleanup_nut, dev_cycle).

The full SDLC + QA workflow is documented in
[../docs/SDLC_AND_QA.md](../docs/SDLC_AND_QA.md). The triple fact-check
(gauntlet) is in [../docs/QA_GAUNTLET.md](../docs/QA_GAUNTLET.md).

## Files

| File | Purpose |
| --- | --- |
| `nut_to_c.ps1` / `.bat` | Rename `.nut` → `.c` in place. |
| `c_to_nut.ps1` / `.bat` | Copy `.c` → sibling `.nut` (no overwrite, no delete). |
| `publish.ps1` / `.bat` | **Destructive** `.c` → `.nut` (overwrite). Use at end of a successful dev cycle. |
| `cleanup_nut.ps1` / `.bat` | Report which `.nut` files are reachable from the L4D2 entry chain. Read-only, never deletes. |
| `build_vpk.ps1` / `.bat` | Run the real `vpk.exe` and produce `dist/<addonname>.vpk`. |
| `dev_cycle.ps1` / `.bat` | Orchestrator. Runs the mechanical steps; pauses for the agent to run the QA gauntlet. |

The `.bat` wrappers just invoke the `.ps1` with `-ExecutionPolicy Bypass`,
so double-clicking works without changing your machine's policy.

## Workflow (rename scripts only)

1. **Switch to Serena mode** (one-time per session):
   ```
   tools\nut_to_c.bat
   ```
   Renames `scripts\vscripts\*.nut` → `*.c` in place. The game can no longer
   find the script until you step 3.

2. **Use Serena** on the `.c` files in `scripts\vscripts\`.

3. **Restore game-loadable sources** (non-destructive):
   ```
   tools\c_to_nut.bat
   ```
   Copies every `.c` to a sibling `.nut` in the same directory. The `.c`
   files are left untouched. The game can now load the mod.

## Workflow (full dev cycle)

For the recommended end-to-end cycle (edit → gauntlet → publish → build →
test → changelog), see [../docs/SDLC_AND_QA.md](../docs/SDLC_AND_QA.md).
The orchestrator is `tools\dev_cycle.bat`.

## Safety

- `c_to_nut` **never overwrites** an existing `.nut`. It reports each skip
  so nothing is silent. Run it as many times as you want; it's idempotent.
- `nut_to_c` is a no-op when no `.nut` files are present.
- `publish` **does** overwrite. That's the point. Use it only after the
  QA gauntlet has passed.
- `cleanup_nut` is read-only. It only reports; it never deletes.
- All scripts only touch `scripts/vscripts/`, `dist/`, or the project
  root. Nothing outside that scope is affected.

## Round-trip example

```bat
REM Start: 5 .nut, 0 .c
tools\nut_to_c.bat
REM Now: 0 .nut, 5 .c (Serena can read these)
tools\c_to_nut.bat
REM Now: 5 .nut, 5 .c (game can load the .nut; Serena can still read .c)

REM Safe to re-run c_to_nut
tools\c_to_nut.bat
REM 0 copied, 5 skipped (idempotent)

REM After a successful QA gauntlet, publish (destructive):
tools\publish.bat
REM 5 overwritten (or 5 created on first run)

REM Check reachability (read-only):
tools\cleanup_nut.bat
REM Expect ORPHAN entries for sm_utilities.nut + lib_utils.nut + turret.nut
REM until the load chain bug is fixed.
```

## Going back to a clean source state

If you want only `.nut` files and no `.c` siblings, delete the `.c` files
manually. The scripts deliberately do not delete `.c` files so Serena
analysis is never lost mid-session.
