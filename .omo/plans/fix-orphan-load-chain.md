# Plan: Fix the Orphan Load Chain

**Goal:** Wire `sm_utilities.nut` (and its includes: `lib_utils.nut`, `turret.nut`) into the L4D2 load chain so the main mod logic actually runs at runtime.

**Current state:** Only `gnome_turret_trigger.nut` is reachable. `sm_utilities.nut` → `turret.nut` + `lib_utils.nut` are dead code.

**Blocking issue:** `turret.c` redefines 16 per-survivor globals + settings globals at the top level (lines 3-23) that `gnome_turret_trigger.c` also defines. Naive wiring would overwrite runtime values to zero/default. The tribal duplicates must be resolved before wiring.

## TODOs

### Phase 1: Audit Conflicts

- [x] 1. Catalog ALL tribal duplicates between gnome_turret_trigger.c and turret.c/lib_utils.c — per-survivor globals, button constants, and 12+ functions — in an exhaustive diff table; verify with explore agent
- [x] 2. Determine resolution strategy for each conflict — for globals remove from turret.c (trigger.c is canonical); for functions confirm byte-equivalence then remove duplicates from turret.c; document every per-symbol decision in notepad

### Phase 2: Resolve Conflicts

- [x] 3. Remove duplicate global definitions from turret.c: GnomeTurretDamage, GnomeTurretAmmoBase, all 8 GnomeTurret* survivor vars, all 8 GnomeTurretAmmo* vars, TurretDataSaveTimer; verify trigger.c remains canonical source
- [x] 4. If button bitmask constants (FireButton..ZoomButton) exist at top level of turret.c, remove them; turret.c depends on trigger.c for these
- [x] 5. Remove duplicate functions from turret.c that already exist in gnome_turret_trigger.c: CfgFileCheck, GenerateGnomeTurretCfgFile, GenerateGnomeVirtualInventory, GenerateGnomeVirtualInventoryReset, LoadSpecificConfigFile, IsCertainSurvivor, GetItemAmmo, SetItemAmmo, GetButtonPressed, ShowSpecialHint, GetSecondarySlot, ForcedToSwitchSecondary2; verify no name collisions remain

### Phase 3: Wire the Load Chain

- [x] 6. Add `IncludeScript("sm_utilities", getroottable())` to gnome_turret_trigger.c at end of file (after all function definitions, before event registrations if any remain); this loads sm_utilities → lib_utils → turret in shared scope

### Phase 4: Verify

- [x] 7. QA Gauntlet Pass 1 (Parse): get_symbols_overview returns valid symbols for every .c file
- [x] 8. QA Gauntlet Pass 2 (Drift): find_referencing_symbols confirms each helper is reachable where expected
- [x] 9. QA Gauntlet Pass 3 (Reachability): ALL 5 .nut files now reachable (0 orphans)
- [x] 10. Run `tools\publish.bat` then `tools\build_vpk.bat`; verify dist/turret.vpk produced successfully

## Final Verification Wave

- [x] F1. Manual review: turret.c top-level removals don't break internal references to removed globals/functions
- [x] F2. Manual review: gnome_turret_trigger.c IncludeScript placement doesn't break existing event hook registrations
- [x] F3. LSP diagnostics: zero NEW errors on changed lines in both modified files
- [x] F4. Build artifact: turret.vpk exists, contains all 5 .nut files, correct byte-size
