# Learnings — Fix Orphan Load Chain

## Phase 2: Tribal Deduplication (turret.c)

### Completed: 2026-06-05

### Summary
Removed ALL duplicate definitions from `turret.c` that already exist in `gnome_turret_trigger.c`.

### Removed (489 lines deleted, 1639 → 1154 lines)

**Top-level globals (lines 3-4):**
- `GnomeTurretDamage <- 50`
- `GnomeTurretAmmoBase <- 300`

**Per-survivor globals (lines 6-13, 16-23):**
- 8x `GnomeTurret* <- 0` (Nick..Zoey)
- 8x `GnomeTurretAmmo* <- 0` (Nick..Zoey)
- **Preserved:** `TurretDataSaveTimer <- 0` (line 14, turret-only)

**Config/toggle globals (lines 112-113, 121):**
- `DemolitionShot <- 1`
- `ExplosionAmmoToggle <- 0`
- `ButtonDelay <- 0`
- **Preserved:** `ExplosionEntity <- SpawnEntityFromTable(...)` (different from trigger's `null`)

**Button bitmask constants (lines 123-134):**
- FireButton..ZoomButton (12 constants)

**Survivor model strings (lines 136-143):**
- NickModel..ZoeyModel (8 strings)

**Icon constants (lines 145-151):**
- AlertIconWhite..SpecialIcon (7 strings)

**Tables (lines 152-165):**
- `special_hint <- { ... }` table

**Functions (lines 1218-1639):**
- CfgFileCheck
- GenerateGnomeTurretCfgFile
- GenerateGnomeVirtualInventory
- GenerateGnomeVirtualInventoryReset
- LoadSpecificConfigFile
- IsCertainSurvivor
- GetSecondarySlot
- ForcedToSwitchSecondary2
- GetButtonPressed
- GetItemAmmo
- SetItemAmmo
- ShowSpecialHint

### Preserved (turret-only)
- `TurretDataSaveTimer`, `ExplosionEntity` (spawn), `g_bDebugMode`, `g_flFindPotentialTargetsTime`, `g_aPotentialTargets`, `g_aTurretList`
- `class CTurret`, `enum eTurret`, `explosion_entity` table, `g_tWeaponReplacement`, `g_ConVar_*`
- All turret-specific functions: ReplaceWeaponSpawn, PlaceTurret, Turret_Think, chat commands, etc.
- RegisterButtonListener, PrecacheEntityFromTable, RegisterOnTickFunction, OnGameplayStart_PostSpawn, AdditionalClassMethodsInjected

### Remaining references
77 call sites in turret.c reference the now-deleted symbols (IsCertainSurvivor, ShowSpecialHint, GnomeTurretAmmoNick, DemolitionShot, etc.). These resolve at runtime via Squirrel's `getroottable()` — trigger.c loads first and provides canonical definitions.

### Verification
- `mcp_serena_get_symbols_overview`: eTurret enum (21 members), all 17 turret-specific functions present
- `grep` for all 12 functions: zero matches in turret.c
- `grep` for all deleted globals/constants: zero matches in turret.c
- `grep` for all preserved turret-only items: confirmed present with active references
- clangd diagnostics: all errors are pre-existing Squirrel-as-C noise; no new errors on edited lines
- File size: 1639 → 1154 lines (485 lines removed, close to ~1160 expected)
