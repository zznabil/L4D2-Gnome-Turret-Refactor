# Changelog

All notable changes to the Gnome Turret Mod are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added
- Laser sight toggle: `!tl` command + `g_bLaserEnabled` global, persistent red beam drawn from muzzle
- Stagger on hit: Fire (`DMG_BURN`), Explosive (`DMG_STUMBLE`), and Demolition shots now guarantee `Stagger(Vector(0, 0, 50))` on special infected
- Insta-gib commons for demolition shot: `TakeDamage(1000, DMG_BLAST | DMG_ALWAYSGIB)` on common infected inside demo toggle block
- Layered explosive impact VFX: both `impact_explosive_ammo_small` + `impact_explosive_ammo_large` at target torso position
- Bullet tracer with `Line()` DebugDrawLine (white-yellow, 0.05s) from muzzle to occlusion point
- Entity pool system: pre-spawned ring buffer for impact particles and shoot sounds
- `.gitignore`, MIT `LICENSE`, professional `README.md`

### Changed
- Explosive ammo VFX + stagger gated by `turret.m_iDamageType == DMG_STUMBLE` instead of `g_bDemolitionMode || ExplosionAmmoToggle` — fixes explosive ammo having no VFX or stagger when demolition toggle is off
- Explosive VFX position from `tbl["target"].GetOrigin()` (feet) to `tbl["position"]` (torso/body position) — VFX now appears at chest height
- Impact VFX for explosive ammo: single `impact_explosive_ammo_large` → layered `impact_explosive_ammo_small` + `impact_explosive_ammo_large` for richer burst
- Demolition/explosive VFX now uses `Vector(x, y, z)` instead of `QAngle` for entity spawn keyvalues — eliminates console errors
- Stagger force from `Vector(RandomInt(10,30), RandomInt(10,30), 0)` to `Vector(0, 0, 50)` for reliable vertical stumble
- `CreateSingleSimpleEntityFromTable` in `sm_utilities.c` now sets `angles` as `Vector` not `QAngle` — fixes "Unsupported KeyValue type for key angles (type qangle)" errors in console

### Fixed
- Special infected not targetable: `GetEntityPosition` return path trapped inside `else if (infected/witch)` brace block
- Sweep laser crash: `DoTraceLine` returning entity handle (`Type_Hit`) fed into `Line()` which expects Vector — changed to `Type_Pos` in both sweeping and aiming paths
- Unknown particle `generic_explosion` → replaced with `gas_explosion_main` in `PlaceTurret`
- `QAngle` type error in entity spawn keyvalues — three occurrences silenced in `sm_utilities.c`
- Explosive ammo VFX and stagger not firing when demolition toggle was off — decoupled from toggle gate

### Removed
- `weapon_tracers_50cal` / `weapon_tracers_incendiary_streak` / `weapon_tracers_incendiary_smoke` particle tracers — all three have incorrect internal orientation in Source particle system; replaced with `Line()` DebugDrawLine for accurate directional tracer

## [2.0.0] - 2025-XX-XX

### Added
- Initial release by Sw1ft.
- Placeable gnome turret (left-click) with per-survivor ammo tracking.
- Chat commands: `!debugmode`, `!remove`, `!ammo`, `!mode`.
- Virtual inventory persistence across rounds.

### Notes
- Known issue: the mod's main logic in `sm_utilities.nut` (and the
  `lib_utils` / `turret` it includes) is not reachable from the L4D2
  entry chain. Only the per-survivor state in `gnome_turret_trigger.nut`
  is loaded at runtime. See `docs/QA_GAUNTLET.md` Pass 3 for the
  reachability analysis. Fixing the load chain is a prerequisite for
  any feature in 2.0.0 to actually take effect in-game.
