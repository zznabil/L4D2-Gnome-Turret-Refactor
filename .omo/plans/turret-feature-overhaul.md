# Turret Feature Overhaul — 7-Feature Implementation

## TL;DR

> **Quick Summary**: Implement 7 gameplay features on the L4D2 Gnome Turret mod: rename all chat commands to a fast `!tX` scheme, add dynamic laser + bullet tracers + deploy VFX, clean up ammo/demolition separation, add ammo safety clamp [5,400], and add server-global turret limit (0-32, default 4).
>
> **Deliverables**:
> - 8 new chat commands (`!ta`, `!tr`, `!tm`, `!td`, `!ts`, `!tarc`, `!tde`, `!thelp`), old names removed
> - Dynamic laser: per-frame `DebugDrawLine` from muzzle to aim point
> - Ammo type cleanup: `!ta` sets DMG_BULLET/BURN/STUMBLE; `!tde` toggles demolition separately
> - Bullet tracers: per-shot `DebugDrawLine` 0.1s duration
> - Deploy VFX: `info_particle_system` smoke + sparks at placement
> - Ammo safety clamp [5,400] at all write points
> - Turret limit: server-global counter max 32, default 4, `!thelp` to view/set
>
> **Estimated Effort**: Medium
> **Parallel Execution**: YES — 4 waves (Wave 1a, 1b, 2, Final), max 5 parallel tasks
> **Critical Path**: Wave 1a (globals + commands + VFX) → Wave 1b (ammo + limit + laser + tracers) → Wave 2 (demolition cleanup) → Wave FINAL (verification)

---

## Context

### Original Request
Full turret overhaul: command rename, dynamic laser, ammo type cleanup (demolition separate from ammo), bullet tracers, deploy VFX, ammo safety clamp [5,400], server turret limit (0-32, default 4).

### Interview Summary
**Key Decisions**:
- **Naming scheme**: Two-letter `!tX` prefix (`!ta`, `!tr`, `!tm`, `!td`, `!ts`, `!tarc`, `!tde`, `!thelp`)
- **Laser + Tracers**: `DebugDrawLine` via existing `Line()` utility (host-only visible). Fastest to implement, zero entity risk.
- **Old command aliases**: Clean break — remove old names, no backwards compat
- **Turret limit**: Server-global total, set/view via `!thelp` command
- **Ammo bounds**: `eTurret.MaxAmmo` updated from 300→400, config min comment updated to 5
- **Demolition toggle**: `!tde` toggles `g_bDemolitionMode` global, separate from ammo types

**Research Findings**:
- 6 commands in `turret.c:1204-1242` via `RegisterChatCommand`
- Laser: `weapon_laser_sight` info_particle_system attached at placement — never updated per-frame
- Tracers: NONE exist — `m_hTracerEntity` is an `info_target` for LOS targeting
- Deploy: Only moustachio sound — no VFX
- Ammo depletion: Commented out at `turret.c:1066-1069`
- `GnomeLimit <- 2` exists but is DEAD CODE — never read anywhere
- `DemolitionShot` (global, default 1) affects witch damage + triggers `env_explosion`
- `ExplosionAmmoToggle` (global, default 0) also triggers explosion — OR'd with DemolitionShot
- No test framework, no compiler — QA Gauntlet is only verification

### Metis Review
**Identified Gaps** (addressed):
- `env_beam` spawnability in L4D2 VScript — user chose DebugDrawLine approach, avoiding this risk
- `DebugDrawLine` remote client visibility — accepted as host-only limitation
- `weapon_tracers_50cal` particle exists — not using due to host-only decision, but noted for future
- `GnomeLimit` is dead code — repurposing for R7 counter storage
- `eTurret.MaxAmmo = 300` vs R6's 400 — user chose to update to 400
- Config comment says min ammo 50 vs R6's 5 — user chose to update to 5

---

## Work Objectives

### Core Objective
Implement 7 gameplay features on the Gnome Turret mod: command rename, dynamic laser, ammo/demolition separation, bullet tracers, deploy VFX, ammo clamp, and server turret limit — all in `turret.c`, `gnome_turret_trigger.c`, and `entity_pool.c`.

### Concrete Deliverables
- `turret.c` — Command renames, ToggleDemolitionMode function, laser/tracer Line() calls, ammo clamp logic, turret limit counter + enforcement, deploy VFX, cleansed witch damage path
- `gnome_turret_trigger.c` — `g_bDemolitionMode` global, `g_iTurretCount` counter, `g_iMaxTurrets` limit, updated config file generation + loading, updated exports
- `entity_pool.c` — Optional: 2 additional pool entries for deploy VFX (or use direct spawn)

### Definition of Done
- [ ] All 8 chat commands registered and functional
- [ ] Old command names removed, no stale registrations
- [ ] Per-frame `DebugDrawLine` laser from muzzle to target
- [ ] Per-shot `DebugDrawLine` tracer from muzzle to impact
- [ ] Deploy smoke + sparks VFX on turret placement
- [ ] `!ta default/explosive/fire` sets ammo type correctly
- [ ] `!tde 0/1` toggles demolition mode; explosion fires only when active
- [ ] `!thelp` shows command list + current turret count/limit
- [ ] Ammo clamped [5,400] at all write points
- [ ] Turret limit enforced at placement; message only to speaker
- [ ] `publish.bat` → `build_vpk.bat` → in-game test passes

### Must Have
- All 7 features implemented and testable
- Build compiles (no syntax errors — verify via QA Gauntlet Pass 1)
- No entity leaks (verify after 5 minute gameplay)
- QA Gauntlet passes all 3 passes

### Must NOT Have (Guardrails)
- NO changes to `sm_utilities.c`, `mapspawn_addon.c`, `lib_utils.c` (chat system, not turret logic)
- NO refactoring of per-survivor ammo dispatch pattern (works, leave it)
- NO clangd noise fixes (Squirrel-as-C, ~95% false positives)
- NO removing old handler function names (`ToggleDebugMode`, etc.) — only change `RegisterChatCommand` strings
- NO new ammo types beyond normal/incendiary/explosive
- NO entity_pool.c ring buffer size changes
- NO config manager abstraction
- NO `env_beam` entity usage (unvalidated in L4D2 VScript — explicitly avoided)

---

## Verification Strategy (MANDATORY)

> **ZERO HUMAN INTERVENTION** — ALL verification is agent-executed. No exceptions.
> Acceptance criteria requiring "user manually tests/confirms" are FORBIDDEN.

### Test Decision
- **Infrastructure exists**: NO (no test framework)
- **Automated tests**: None
- **Frameworks**: None — QA Gauntlet (parse → drift → reachability) + in-game verification
- **Primary verification**: Agent-executed via L4D2 console commands (`script`), entity validation, and QA Gauntlet passes

### QA Policy
Every task MUST include agent-executed QA scenarios. Evidence saved to `.omo/evidence/task-{N}-{scenario-slug}.{ext}`.

- **VScript logic**: Use `script` console command to read globals, check entity handles, verify state — all via Serena MCP or manual console emulation
- **Entities**: Use `Entities.FindByClassname` in `script` to count particles, verify cleanup, check existence
- **Chat commands**: Use `script` to inspect `g_aChatCommands` array for correct registrations
- **Config**: Read generated config files via Serena
- **Build**: Run `c_to_nut.bat` → QA Gauntlet (3 passes) → `publish.bat` → `build_vpk.bat`

---

## Execution Strategy

### Parallel Execution Waves

```
Wave 1 (Foundation — 4 tasks, all independent):
├── Task 1: Add g_bDemolitionMode + g_iTurretCount + g_iMaxTurrets globals [quick]
├── Task 2: Update eTurret.MaxAmmo 300→400 [quick]
├── Task 3: Add ToggleDemolitionMode function [quick]
└── Task 4: Pre-add m_hLaserBeam field placeholder to CTurret [quick]

Wave 2 (Core features — 4 tasks, mostly independent):
├── Task 5: Rename all 6 commands + register !tde + !thelp [quick]
├── Task 6: Deploy VFX smoke+sparks in PlaceTurret [quick]
├── Task 7: Ammo safety clamp [5,400] at all write points [quick]
└── Task 8: Server turret limit counter + enforcement [medium]

Wave 3 (Visual features — 2 tasks):
├── Task 9: Dynamic laser Line() in Turret_Think [medium]
└── Task 10: Bullet tracer Line() per shot [quick]

Wave 4 (Demolition cleanup — 1 task):
├── Task 11: Ammo type + demolition separation, remove witch special-casing [medium]

Wave FINAL (Verification — 4 parallel reviewers):
├── Task F1: Plan compliance audit (oracle)
├── Task F2: Code quality + QA Gauntlet (3 passes)
├── Task F3: Real manual QA (in-game verification)
└── Task F4: Scope fidelity check
```

### Dependency Matrix
- **1-4**: None (start immediately)
- **5**: 1 (needs g_bDemolitionMode for !tde handler reference)
- **6**: None (independent)
- **7**: 2 (needs MaxAmmo=400)
- **8**: 3 (needs ToggleDemolitionMode reference) — actually, Task 8 doesn't need Task 3. Task 8 is turret limit. It doesn't depend on Task 3. Let me fix this.
- **8**: None (independent — just needs g_iTurretCount/ g_iMaxTurrets from Task 1)
- **9**: 4 (needs m_hLaserBeam field), then actually I realize m_hLaserBeam is just for potential future env_beam. Since we're using DebugDrawLine (Line()), we actually don't need m_hLaserBeam at all. So Task 9: None (independent, uses Line() which already exists)
- **10**: None (independent, uses Line() which already exists)
- **11**: 5 (needs renamed commands), 3 (needs ToggleDemolitionMode)

Corrected:
- **1-4**: Start immediately, independent
- **5**: 3 (needs ToggleDemolitionMode function for registration)
- **6, 7, 8, 9, 10**: Independent (no blockers from Wave 1)
- **11**: 5 (needs renamed commands), Depends on any ammo-related changes

Let me simplify:

Wave 1 (Start Immediately):
├── 1. Add globals: g_bDemolitionMode, g_iTurretCount, g_iMaxTurrets
├── 2. Update eTurret.MaxAmmo 300→400
├── 3. Add ToggleDemolitionMode function
├── 4. Rename all 6 commands + register !tde + !thelp
├── 5. Deploy VFX: smoke + sparks in PlaceTurret
├── 6. Ammo safety clamp [5,400]
├── 7. Server turret limit enforcement
├── 8. Dynamic laser Line() in Turret_Think
├── 9. Bullet tracer Line() per shot
└── 10. Config file + load paths: g_bDemolitionMode, max ammo comment

Wave 2:
└── 11. Ammo type + demolition separation, witch special-case removal, ExplosionAmmoToggle alias

Wait, Task 10 (config file changes) should also be in Wave 1. Let me reorganize.

Actually, all of these are truly independent because:
- Command renames are just string changes in registration table
- Deploy VFX adds new code in PlaceTurret  
- Ammo clamp adds clamping logic at write points
- Turret limit adds new global + count logic
- Laser + tracers add Line() calls
- Config changes are in gnome_turret_trigger.c

They all touch DIFFERENT LINE RANGES in the same file or different files, so no merge conflicts.

Let me restructure:

Wave 1a (Foundation A — 5 tasks, all independent):
├── 1. Add globals to gnome_turret_trigger.c [unspecified-low]
├── 2. Update eTurret.MaxAmmo enum [quick]
├── 3. ToggleDemolitionMode function [quick]
├── 4. Rename 6 commands + add 2 new [quick]
└── 5. Deploy VFX (PlaceTurret) [unspecified-low]

Wave 1b (Foundation B — 5 tasks, all independent):
├── 6. Ammo clamp [quick]
├── 7. Turret limit counter + enforcement [unspecified-high]
├── 8. Dynamic laser [quick]
├── 9. Bullet tracers [quick]
└── 10. Config file changes [quick]

Wave 2 (1 task, depends on 3+4+10):
└── 11. Demolition cleanup: witch path, explosion gate, user-facing strings

Wave FINAL:
F1-F4 parallel verification

This is much more parallel — 10 tasks in 2 waves.

---

## TODOs

> **IMPORTANT**: Edit ONLY `.c` files. NEVER edit `.nut` directly. Run `c_to_nut.bat` after each edit session. Run QA Gauntlet before `publish.bat`.
> ALL task labels use bare numbers (1., 2.) — NOT T1., Task 1. Final wave uses F1., F2. format.

### Wave 1a (Foundation A — 5 parallel tasks)

- [x] 1. **Add globals to gnome_turret_trigger.c**

  **What to do**:
  - Add `g_bDemolitionMode <- false` alongside existing DemolitionShot/ExplosionAmmoToggle
  - Add `g_iTurretCount <- 0` and `g_iMaxTurrets <- 4` for server turret limit
  - Update `::` exports section to export new globals
  - Keep DemolitionShot and ExplosionAmmoToggle for backward compat

  **Must NOT do**:
  - Do NOT remove DemolitionShot or ExplosionAmmoToggle
  - Do NOT change the export order — append new exports at end

  **Agent Profile**: unspecified-low — simple variable declarations
  **Parallelization**: Wave 1a — independent
  **Blocks**: None | **Blocked By**: None

  **References**: gnome_turret_trigger.c:1-28 (existing globals), :996-1021 (exports)

  **Acceptance Criteria**:
  - [ ] `script g_bDemolitionMode` returns false on fresh init
  - [ ] `script g_iTurretCount` returns 0 on fresh init
  - [ ] `script g_iMaxTurrets` returns 4 on fresh init
  - [ ] QA Gauntlet Pass 1 passes for gnome_turret_trigger.c

  **QA Scenario**: Verify globals init via Serena LSP symbol overview on gnome_turret_trigger.c
  Evidence: .omo/evidence/task-1-globals.txt

  **Commit**: YES (with 2-10) — chore(turret): add demolition mode, turret count, max turrets globals

- [x] 2. **Update eTurret.MaxAmmo from 300 to 400**

  **What to do**:
  - Change turret.c:67 from MaxAmmo = 300 to MaxAmmo = 400
  - Update config file comment at gnome_turret_trigger.c (min ammo 50 to 5)

  **Must NOT do**: Do NOT change any other enum values

  **Parallelization**: Wave 1a — independent

  **Acceptance Criteria**:
  - [ ] Script reads eTurret.MaxAmmo as 400
  - [ ] Config file comment says min 5 for GnomeTurretAmmoBase

  **QA Scenario**: Read turret.c via Serena, verify MaxAmmo line changed
  Evidence: .omo/evidence/task-2-maxammo.txt

  **Agent Profile**: quick — follow existing function pattern, ~30 lines
- [x] 3. **Add ToggleDemolitionMode function**

  **What to do**:
  - Add new function after ToggleDebugMode (~turret.c:493)
  - Pattern: host-only check, parse value, set g_bDemolitionMode, persist
  - Follow existing ToggleDebugMode + sweep lambda patterns

  **Must NOT do**: Do NOT modify existing functions or explosion logic

  **Parallelization**: Wave 1a | **Blocks**: Task 4

  **Acceptance Criteria**:
  - [ ] Function exists and non-host gets forbidden hint
  - [ ] g_bDemolitionMode toggles with 0/1 input
  - [ ] Config file updated after toggle

  **QA Scenario**: Call ToggleDemolitionMode with 1, verify global flipped
  Evidence: .omo/evidence/task-3-demofunc.txt

  **Agent Profile**: quick — command registration edit + new help function

- [x] 4. **Rename 6 commands + add !tde + !thelp**

  **What to do**:
  - In turret.c:1206-1241, replace all 6 command strings:
    - !debugmode -> !td, !remove -> !tr, !ammo -> !ta
    - !mode -> !tm, !trsweepspeed -> !ts, !trdegree -> !tarc
  - Register !tde (ToggleDemolitionMode) and !thelp (PrintTurretHelp)
  - Create PrintTurretHelp(hPlayer, sValue) function:
    - Lists all 8 commands with brief descriptions
    - Shows current turret count / max limit
    - If host and arg is number: sets g_iMaxTurrets (clamped 0-32)

  **Must NOT do**: Do NOT change handler function names or RegisterChatCommand signature

  **Parallelization**: Wave 1a | **Blocked By**: Task 3

  **Acceptance Criteria**:
  - [ ] g_aChatCommands has 8 new names, 0 old names
  - [ ] !thelp shows command list + turret count/limit
  - [ ] Host can set limit with !thelp N, non-host gets forbidden
  - [ ] Old names produce no response

  **QA Scenario**: Dump g_aChatCommands array via script, verify all 8 present
  Evidence: .omo/evidence/task-4-commands.txt

- [x] 5. **Deploy VFX: smoke + sparks in PlaceTurret**

  **What to do**:
  - In PlaceTurret() (~turret.c:420 area, after entity storage but before sounds):
  - Spawn info_particle_system with effect_name for smoke puff
  - Spawn info_particle_system with effect_name for sparks
  - Auto-stop both after 1.5s (AcceptEntityInput Stop with delay)
  - Auto-kill both after 2.5s (DoEntFire Kill with delay)
  - Keep existing moustachio sound alongside VFX

  **Must NOT do**: Do NOT modify existing sounds or entity flow

  **Agent Profile**: unspecified-low — simple particle spawn, 10-15 lines

  **Parallelization**: Wave 1a — independent

  **Acceptance Criteria**:
  - [ ] Placement creates 2 additional info_particle_system entities
  - [ ] Both auto-cleanup after ~2.5s (entity count returns to baseline)
  - [ ] Respects g_bTurretParticlesEnabled (skip if disabled)
  - [ ] Sound still plays alongside VFX

  **QA Scenario**: Count info_particle_system entities before and after placement, verify 2 new then cleanup
  Evidence: .omo/evidence/task-5-deployvfx.txt

### Wave 1b (Foundation B — 5 parallel tasks)

- [x] 6. **Ammo safety clamp [5,400] at all write points**

  **What to do**:
  - Add clamp helper: function ClampAmmo(amount) returning min(max(amount,5),400)
  - Apply at every ammo write point:
    - PlaceTurret(): per-survivor ammo read from virtual inventory (lines ~311-390)
    - PlaceTurret(): GetConVarInt fallback for ammo (line 354)
    - OnUsePress(): pickup ammo (line 820-825 area)
    - Config file LoadSpecificConfigFile(): clamp GnomeTurretAmmoBase value
  - After clamp function is defined, wrap each ammo assignment: iAmmo = ClampAmmo(val)

  **Must NOT do**: Do NOT change ammo from int to float. Do NOT add validation that breaks existing paths.

  **Agent Profile**: quick — helper function + 4 call-site wrappers

  **Parallelization**: Wave 1b — independent

  **Acceptance Criteria**:
  - [ ] Config GnomeTurretAmmoBase=2 -> placed turret has 5 ammo
  - [ ] Config GnomeTurretAmmoBase=500 -> placed turret has 400 ammo
  - [ ] Per-survivor override of 2 -> clamped to 5
  - [ ] Existing path with 300 ammo unchanged (300 < 400)

  **QA Scenario**: Set ammo to 2 via config, place turret, script turret.m_iAmmo == 5
  Evidence: .omo/evidence/task-6-ammoclamp.txt

- [x] 7. **Server turret limit counter + enforcement**

  **What to do**:
  - On turret placement (PlaceTurret, ~line 407):
    - If g_iTurretCount >= g_iMaxTurrets: abort placement, send sayf to player ONLY
    - Else: g_iTurretCount++, place turret normally
  - On turret pickup (OnUsePress, ~line 868-873 kill area):
    - g_iTurretCount--
  - On invalid turret cleanup (Turret_Think invalid check ~line 968-976):
    - g_iTurretCount--
  - On round start: g_iTurretCount = 0 (in round_start event handler)
  - On map transition: all entities gone, counter reset is automatic via round_start

  **Must NOT do**:
  - Do NOT use GnomeLimit variable (dead code, confusing)
  - Do NOT broadcast count to all players — sayf to speaker only
  - Do NOT prevent pickup when at limit — only placement

  **Agent Profile**: unspecified-high — counter logic at multiple points, edge cases
  **Parallelization**: Wave 1b — independent

  **Acceptance Criteria**:
  - [ ] Setting limit to 0 prevents all placement, counts to speaker only
  - [ ] Setting limit to 32 allows 32 turrets, placement of 33rd blocked
  - [ ] Picking up a turret decrements counter
  - [ ] Message only visible to the deploying player
  - [ ] Count resets on map transition

  **QA Scenario**: Set limit to 1 via !thelp 1, place 1 turret, try 2nd, verify blocked message
  Evidence: .omo/evidence/task-7-turretlimit.txt

- [x] 8. **Dynamic laser in Turret_Think**

  **What to do**:
  - In Turret_Think() at the target acquisition block (after line 1032 aim update):
    - Calculate muzzle position using same formula as TurretShoot line 646
    - When target locked: Line(muzzle, target position, 0.1, 255, 0, 0)
    - When idling/sweeping (line ~1105-1107): Line(muzzle, aim direction * range, 0.15, 255, 50, 0)
  - This uses the existing Line() wrapper from lib_utils.c for DebugDrawLine

  **Must NOT do**:
  - Do NOT modify existing aiming logic
  - Do NOT add env_beam entities (risk rejected by user)
  - Do NOT add new particle effects

  **Agent Profile**: quick — 4 lines of Line() calls in existing function
  **Parallelization**: Wave 1b — independent

  **Acceptance Criteria**:
  - [ ] Red laser line visible from muzzle to target when turret is shooting
  - [ ] Orange laser line visible when turret is sweeping idle
  - [ ] Line updates every Think frame (~30Hz)
  - [ ] g_bDebugMode NOT required for this (always-on for host)

  **QA Scenario**: Place turret, acquire target, verify Line() called at correct positions
  Evidence: .omo/evidence/task-8-laser.txt

- [x] 9. **Bullet tracer per shot**

  **What to do**:
  - In Turret_Think() after TurretShoot + TurretShootFakeImpact calls (line ~1061):
    - Calculate muzzle position
    - Call Line(muzzle, tbl["position"], 0.1, 255, 255, 50) for tracer streak
  - OR add inside TurretShoot() function for cleaner organization
  - Duration 0.1s = half the shoot interval, visible as brief streak

  **Must NOT do**:
  - Do NOT add entity-based tracers (unvalidated approach)
  - Do NOT modify shoot timing or damage flow

  **Agent Profile**: quick — 2 lines of Line() calls in existing function
  **Parallelization**: Wave 1b — independent

  **Acceptance Criteria**:
  - [ ] Yellow tracer line visible from muzzle to impact each shot
  - [ ] Duration matches ~0.1s
  - [ ] No entity leak after 100 shots
  - [ ] Does not block or delay the damage/shoot pipeline

  **QA Scenario**: Place turret facing target, fire 3 shots, verify 3 Line() calls
  Evidence: .omo/evidence/task-9-tracer.txt

- [x] 10. **Update config generation + loading for new globals**

  **What to do**:
  - In gnome_turret_trigger.c GenerateGnomeTurretCfgFile():
    - Add g_bDemolitionMode to config output (around line 92-93)
    - Update min ammo comment from 50 to 5
  - In LoadSpecificConfigFile():
    - Add alias parsing: if key is g_bDemolitionMode or DemolitionShot -> set g_bDemolitionMode
    - Keep ExplosionAmmoToggle as config-only alias (maps to same global)
    - Clamp GnomeTurretAmmoBase to [5,400] after loading
  - Ensure :: exports updated (from Task 1 scope)

  **Must NOT do**:
  - Do NOT remove DemolitionShot or ExplosionAmmoToggle config keys (backward compat)
  - Do NOT change config file format

  **Agent Profile**: quick — config file key additions + backward compat alias
  **Parallelization**: Wave 1b — independent

  **Acceptance Criteria**:
  - [ ] Config file contains g_bDemolitionMode entry
  - [ ] Old DemolitionShot key still loads correctly into g_bDemolitionMode
  - [ ] ExplosionAmmoToggle still loads as alias
  - [ ] GnomeTurretAmmoBase > 400 gets clamped to 400 on load
  - [ ] GnomeTurretAmmoBase < 5 gets clamped to 5 on load

  **QA Scenario**: Set DemolitionShot=1 in config, reload, verify g_bDemolitionMode == true
  Evidence: .omo/evidence/task-10-config.txt

### Wave 2 (Integration — 1 task)

- [x] 11. **Demolition separation + witch path cleanup + strings**

  **What to do**:
  - **Witch damage path** (turret.c:1036-1056): Remove special-casing. Witch uses same m_iDamageType. Delete the if(witch) block, keep non-witch TakeDamage path.
  - **Explosion gate** (turret.c:1073): Change to if(g_bDemolitionMode || ExplosionAmmoToggle == 1)
  - **User-facing strings**: Update all sayf() messages in ChangeTurretAmmo to concise format referencing !ta
  - **Ammo list display** (turret.c:563-564): Reference !ta instead of !ammo

  **Must NOT do**: Do NOT remove ExplosionAmmoToggle from gate. Do NOT change explosion params.

  **Agent Profile**: unspecified-high — careful logic change in damage pipeline, backward compat needed
  **Parallelization**: Wave 2 | **Blocked By**: Tasks 4, 10
  **Must NOT do**: Do NOT remove ExplosionAmmoToggle from gate. Do NOT change explosion params.

  **Parallelization**: Wave 2 | **Blocked By**: Tasks 4, 10

  **Acceptance Criteria**:
  - [ ] Witch takes same m_iDamageType as other targets (no DMG_BLAST special)
  - [ ] Explosion fires when EITHER g_bDemolitionMode or ExplosionAmmoToggle active
  - [ ] !ta output references new command names
  - [ ] Old verbose strings updated to concise format

  **QA Scenario**: Spawn witch with normal ammo turret, verify DMG_BULLET not DMG_BLAST
  Evidence: .omo/evidence/task-11-demolition.txt

---

## Final Verification Wave (MANDATORY — AFTER all implementation tasks)

> 4 review agents run in PARALLEL. ALL must APPROVE. Get explicit user okay.
> Do NOT auto-proceed.

- [x] F1. **Plan Compliance Audit** — oracle
  Verify: All 7 features per spec. Must Haves present. Must NOT Haves absent.
  Output: Must Have [N/N] | Must NOT Have [N/N] | Tasks [N/N] | VERDICT

- [x] F2. **Code Quality + QA Gauntlet** — unspecified-high
  Pass 1 (Parse), Pass 2 (Drift), Pass 3 (Reachability). Entity leak check.
  Output: Parse [PASS/FAIL] | Drift [PASS/FAIL] | Reachability [PASS/FAIL] | VERDICT

- [x] F3. **Real Manual QA** — unspecified-high
  Execute EVERY QA scenario. Cross-feature integration. Save to .omo/evidence/final-qa/
  Output: Scenarios [N/N pass] | Integration [N/N] | VERDICT

- [x] F4. **Scope Fidelity Check** — deep
  Read What to do vs actual diff. No scope creep.
  Output: Tasks [N/N compliant] | Unaccounted [CLEAN/N files] | VERDICT

---

## Commit Strategy

- Wave 1 (tasks 1-10): One commit
  Message: feat(turret): overhaul commands, VFX, ammo clamp, turret limit, laser, tracers
- Wave 2 (task 11): One commit
  Message: fix(turret): clean demolition separation, witch damage path, command strings
- Final: One commit per F1-F4 fix if issues found

---

## Success Criteria

### Verification Commands
```powershell
# 1. Restore .nut files from .c
tools\c_to_nut.bat

# 2. QA Gauntlet Pass 1: Parse check
mcp_serena_get_symbols_overview turret.c depth=1
mcp_serena_get_symbols_overview gnome_turret_trigger.c depth=1

# 3. QA Gauntlet Pass 2: Drift check
mcp_serena_find_referencing_symbols LoadSpecificConfigFile turret.c

# 4. QA Gauntlet Pass 3: Reachability
mcp_serena_search_for_pattern IncludeScript paths_include_glob=*.c

# 5. Publish .nut from .c (only after gauntlet passes)
tools\publish.bat

# 6. Build VPK
tools\build_vpk.bat
```

### Final Checklist
- [ ] All 8 commands work (ta, tr, tm, td, ts, tarc, tde, thelp)
- [ ] 0 old commands remain registered
- [ ] Laser line visible when turret is tracking/sweeping
- [ ] Tracer line visible per shot
- [ ] Deploy smoke + sparks on placement
- [ ] Ammo clamped [5,400] at all write points
- [ ] Turret limit enforced (default 4, max 32)
- [ ] tde toggles demolition mode correctly
- [ ] Witch normal damage type (no DMG_BLAST special)
- [ ] Config backward compat: old DemolitionShot key works
- [ ] g_bTurretParticlesEnabled respected by deploy VFX
- [ ] QA Gauntlet all 3 passes
- [ ] publish.bat + build_vpk.bat succeed
- [ ] No entity leaks (count before/after 5 min)
