# Plan: Add Idle Sweep Behavior to Gnome Turrets

## TL;DR

> **Quick Summary**: Add smooth pendulum sweep to turrets when no target detected — ±45° arc at 20°/s, customizable via host-only chat commands `!trsweepspeed` and `!trdegree`, persisted to config file.

> **Deliverables**:
> - Modified `turret.c`: CTurret sweep members, Turret_Think sweep logic, 2 chat commands, 2 globals, 2 eTurret entries
> - Modified `gnome_turret_trigger.c`: 2 new config entries (gen + parse)
> - Published `.nut` files + rebuilt `turret.vpk`

> **Estimated Effort**: Medium
> **Parallel Execution**: YES — 3 waves
> **Critical Path**: Audit → Config → Turret Think → QA Gauntlet → Publish

---

## Context

### Original Request
Add idle sweeping to gnome turrets. When no target, smoothly sweep ±45° (90° total). Speed customizable via `!trsweepspeed x`, arc via `!trdegree x`. All host-only. Persist to config file. Sweep stops immediately on target acquisition.

### Interview Summary
| Decision | Choice |
|----------|--------|
| Sweep motion | Smooth pendulum, constant speed |
| Arc definition | Total arc width (90 = ±45° from center) |
| Speed unit | Degrees per second (default 20) |
| Persistence | Config file `gnome turret/gnome turret.txt` |
| Target interaction | Disable on target, resume after IdleTime (3s) |
| Return-to-default | REPLACE with sweep |
| Mode interaction | All modes |
| Commands | Host-only (!debugmode pattern) |
| Zero values | Reject with safety clamps |
| `!tr` command | Template only — NOT implemented |
| Per-turret state | Instance members on CTurret |

### Metis Review
**Critical finding**: `SetAnglesBySteps` cannot be used for continuous sweeping — it stacks `CreateTimer` calls and causes timer explosion. Must use direct `SetAngles()` with `Time()`-based delta computation per tick.

**Guardrails applied**:
- Direct per-tick angle computation, NOT SetAnglesBySteps
- Frame-rate independent (Time() delta)
- Replace (not coexist with) existing return-to-default block
- Angle wrapping handled via signed delta from center
- Safety clamps on all inputs
- Config regeneration triggered on command use

---

## Work Objectives

### Core Objective
Add smooth pendulum idle sweep to gnome turrets when no target is within range, customizable via host chat commands and persistent across rounds.

### Concrete Deliverables
- `scripts/vscripts/turret.c` — sweep logic, commands, globals, eTurret entries
- `scripts/vscripts/gnome_turret_trigger.c` — config generation and parsing
- Updated `.nut` files + `dist/turret.vpk`

### Must Have
- Pendulum sweep at configurable speed and arc
- `!trsweepspeed` and `!trdegree` host-only commands
- Config persistence in `gnome turret/gnome turret.txt`
- Sweep stops immediately on target acquisition
- Frame-rate independent (Time() delta)
- Safety clamps on all numeric inputs

### Must NOT Have
- SetAnglesBySteps usage for sweep (timer explosion risk)
- !tr command implementation
- Vertical (pitch) sweep — yaw only
- Visual effects, sounds, or HUD changes
- Multiple sweep patterns (pendulum only)
- Per-turret customization — global settings only

---

## Verification Strategy

### Test Decision
- **Infrastructure exists**: NO
- **Automated tests**: None — no test runner for Squirrel/VScript
- **QA Method**: Serena QA Gauntlet (3 passes) + manual code review + user in-game test

### QA Policy
- Pass 1 (Parse): `get_symbols_overview` on all modified `.c` files
- Pass 2 (Drift): `find_referencing_symbols` for config functions
- Pass 3 (Reachability): Load chain intact, no new orphans
- Final: `publish.bat` + `build_vpk.bat` → user drops VPK into L4D2

---

## Execution Strategy

```
Wave 1 (Config & Globals — MAX PARALLEL):
├── Task 1: Add new eTurret enum entries (SweepSpeed, SweepArc)
├── Task 2: Add globals + config gen entries to trigger.c
├── Task 3: Add config parsing to trigger.c LoadSpecificConfigFile
└── Task 4: Add CTurret sweep members to constructor

Wave 2 (Core Logic):
├── Task 5: Implement Turret_Think sweep logic (replaces return-to-default)
└── Task 6: Register chat commands (!trsweepspeed, !trdegree)

Wave 3 (Verify):
├── Task 7: QA Gauntlet Passes 1-3
└── Task 8: Publish + Build + Final Wave
```

---

## TODOs

- [x] 1. Add eTurret enum entries for sweep defaults

  **What to do**: Add `SweepSpeed = 20.0` and `SweepArc = 90.0` inside `enum eTurret { ... }` in turret.c near existing configurable values like `Damage = 50.0`, `MaxAmmo = 300`, `IdleTime = 3.0`. These serve as compile-time fallback defaults when config file is missing.

  **Recommended Agent**: `quick` — single file, 2-line addition, well-defined location. Skills: none.
  **Parallel**: Wave 1 with Tasks 2, 3, 4 | **Blocks**: Task 5 | **Blocked By**: None

  **Acceptance Criteria**:
  - [ ] `SweepSpeed = 20.0` exists inside eTurret enum
  - [ ] `SweepArc = 90.0` exists inside eTurret enum
  - [ ] Serena get_symbols_overview shows both new entries under eTurret
  - [ ] Values use float type (20.0 not 20) to match existing float entries

- [x] 2. Add globals and config generation entries to gnome_turret_trigger.c

  **What to do**: Add 2 global declarations after existing config globals (~line 20): `g_flGnomeTurretSweepSpeed <- 20.0;` and `g_flGnomeTurretSweepArc <- 90.0;`. Add 2 entries to CfgToggleFile array in GenerateGnomeTurretCfgFile: `"GnomeTurretSweepSpeed 20.0",` and `"GnomeTurretSweepArc 90.0",`. Add brief documentation comments in the notes section.

  **Recommended Agent**: `quick` | **Parallel**: Wave 1 with Tasks 1, 3, 4 | **Blocks**: Task 5 | **Blocked By**: None

  **Acceptance Criteria**:
  - [ ] `g_flGnomeTurretSweepSpeed <- 20.0;` declared near other config globals
  - [ ] `g_flGnomeTurretSweepArc <- 90.0;` declared near other config globals
  - [ ] CfgToggleFile array contains both new entries
  - [ ] Notes section includes brief documentation for new settings

- [x] 3. Add config parsing to gnome_turret_trigger.c LoadSpecificConfigFile

  **What to do**: Add 2 new `if(togglecommand == ...)` blocks in LoadSpecificConfigFile after existing GnomeTurretAmmoBase block. Each must include safety clamps: speed [1..360] with fallback to 20.0, arc [2..360] with fallback to 90.0. Use `togglevalue.tofloat()` for parsing. Reference: existing GnomeTurretDamage parsing block pattern.

  **Recommended Agent**: `quick` | **Parallel**: Wave 1 with Tasks 1, 2, 4 | **Blocks**: Task 5 | **Blocked By**: Task 2 (same file, same function — can merge)

  **Acceptance Criteria**:
  - [ ] Two new togglecommand blocks exist, matching existing block structure
  - [ ] Safety clamps: speed [1..360] → default 20.0 on out-of-range
  - [ ] Safety clamps: arc [2..360] → default 90.0 on out-of-range
  - [ ] Serena get_symbols_overview confirms LoadSpecificConfigFile still parseable

- [x] 4. Add CTurret sweep state members

  **What to do**: Add 3 instance members to CTurret constructor in turret.c: `m_flSweepOffset = 0.0;` (current angular offset), `m_iSweepDir = 1;` (direction: 1=right, -1=left), `m_flLastSweepTime = 0.0;` (for delta-time calc). Also declare in class body (~line 60-72 after m_sIdentifier). Reference: existing member pattern `m_iAmmo = 0;` `m_flNextShootTime = 0.0;`.

  **Recommended Agent**: `quick` | **Parallel**: Wave 1 with Tasks 1, 2, 3 | **Blocks**: Task 5 | **Blocked By**: None

  **Acceptance Criteria**:
  - [ ] CTurret constructor initializes 3 new members (m_flSweepOffset, m_iSweepDir, m_flLastSweepTime)
  - [ ] Class body declares these members (Squirrel requires declaration before use)
  - [ ] Serena get_symbols_overview shows CTurret class and methods still present

---

- [x] 5. Implement Turret_Think sweep logic (replaces return-to-default)

  **What to do**: In turret.c Turret_Think, replace the return-to-default block (~lines 1035-1046) with sweep logic. After target-not-found + IdleTime check:
  - Compute delta: `local delta = g_flGnomeTurretSweepSpeed * (Time() - turret.m_flLastSweepTime)`
  - Update offset: `turret.m_flSweepOffset += turret.m_iSweepDir * delta`
  - Clamp to ±arc/2: `local halfArc = g_flGnomeTurretSweepArc / 2.0`
  - If `|turret.m_flSweepOffset| >= halfArc`: clamp to boundary and flip `turret.m_iSweepDir`
  - Apply: `machine_gun.SetAngles(m_eDefaultAngles + QAngle(0, turret.m_flSweepOffset, 0))`
  - Update timestamp: `turret.m_flLastSweepTime = Time()`
  - CRITICAL: use `if ("m_flSweepOffset" in turret)` guard for turrets placed before this update

  **Must NOT do**: Use SetAnglesBySteps (timer explosion). Use tick-count instead of Time() delta. Omit the `in` guard.

  **Recommended Agent**: `unspecified-high` — core logic change, critical correctness. Skills: none.
  **Parallel**: Wave 2 (sequential after Wave 1) | **Blocks**: Tasks 7, 8 | **Blocked By**: Tasks 1-4

  **Acceptance Criteria**:
  - [ ] Sweep block runs when no target found AND IdleTime elapsed
  - [ ] Delta-time computation: `Time() - m_flLastSweepTime` multiplied by sweep speed
  - [ ] Angle clamped to ±sweepArc/2 centered on m_eDefaultAngles.y
  - [ ] Direction reverses at boundaries with no overshoot
  - [ ] Old return-to-default block (SetAnglesBySteps call) is REMOVED
  - [ ] `"m_flSweepOffset" in turret` guard prevents crash on existing turrets
  - [ ] Angle wrapping handles ±180° boundary via signed delta from center (use `normalizeAngle` helper if needed)

- [x] 6. Register chat commands !trsweepspeed and !trdegree

  **What to do**: Register 2 commands in turret.c AdditionalClassMethodsInjected via `RegisterChatCommand`. Host-only (use `IsHostPlayer` check). Each command: parse float arg, apply safety clamps (speed [1..360]→default 20, arc [2..360]→default 90), update global, call `GenerateGnomeTurretCfgFile()` to persist to config file. Show feedback hint on success. Print to console. Reference: existing !debugmode pattern for host-only, !ammo pattern for value update.

  **Must NOT do**: Skip IsHostPlayer check. Skip config file regeneration after value change. Accept zero/negative values.

  **Recommended Agent**: `quick` | **Parallel**: Wave 2 with Task 5 | **Blocks**: Tasks 7, 8 | **Blocked By**: Tasks 2, 3

  **Acceptance Criteria**:
  - [ ] `RegisterChatCommand("!trsweepspeed", ...)` in AdditionalClassMethodsInjected
  - [ ] `RegisterChatCommand("!trdegree", ...)` in AdditionalClassMethodsInjected
  - [ ] Both commands check `IsHostPlayer(kent)` and reject non-host with hint
  - [ ] Commands parse float value, apply safety clamps, update global, call GenerateGnomeTurretCfgFile()
  - [ ] Feedback shown via ShowSpecialHint on success
  - [ ] Commands work with decimal values (e.g., `!trsweepspeed 25.5`)

---

- [x] 7. QA Gauntlet Passes 1-3

  **What to do**: Pass 1: `get_symbols_overview` on turret.c and gnome_turret_trigger.c — must return valid symbols. Pass 2: `find_referencing_symbols` for GenerateGnomeTurretCfgFile/LoadSpecificConfigFile — confirm config functions consistent. Pass 3: `search_for_pattern` for IncludeScript/vscripts — confirm load chain intact (5 reachable, 0 orphans).

  **Acceptance Criteria**:
  - [ ] Pass 1: all .c files return Enum/Function/Variable entries
  - [ ] Pass 2: config functions have references in trigger.c (only copy exists after dedup)
  - [ ] Pass 3: all 5 .nut files reachable, 0 orphans
  - [ ] Zero NEW clangd errors on changed lines

- [x] 8. Publish, Build, and Final Wave

  **What to do**: `tools\publish.bat` then `tools\build_vpk.bat`. Verify turret.vpk produced. Run Final Wave: F1 manual review of sweep logic correctness, F2 manual review of command handlers, F3 LSP diagnostics check, F4 VPK artifact check.

  **Acceptance Criteria**:
  - [ ] publish.bat: all 5 .nut files overwritten from .c
  - [ ] build_vpk.bat: dist/turret.vpk produced (confirmed size)
  - [ ] F1: sweep computation correct (delta-time, clamping, direction flip)
  - [ ] F2: command handlers correct (host-only, clamps, config save)
  - [ ] F3: zero new LSP errors on modified files
  - [ ] F4: turret.vpk exists and contains all expected files

---

## Final Verification Wave

- [x] F1. Parse: all .c files return valid symbols
- [x] F2. Drift: config functions consistent across files
- [x] F3. Reachability: load chain intact, 0 orphans
- [x] F4. Build: turret.vpk produced successfully

---

## Success Criteria

### Verification Commands
```powershell
# Serena parse check
mcp_serena_get_symbols_overview relative_path="scripts/vscripts/turret.c" depth=0
mcp_serena_get_symbols_overview relative_path="scripts/vscripts/gnome_turret_trigger.c" depth=0

# Build
tools\publish.bat && tools\build_vpk.bat
```

### Final Checklist
- [ ] Turret sweeps when no target found
- [ ] Turret locks on target immediately
- [ ] !trsweepspeed and !trdegree work (host-only)
- [ ] Settings persist in config file
- [ ] Defaults: 20°/s, 90° arc
- [ ] Zero/negative inputs rejected
- [ ] No timer explosion from SetAnglesBySteps
