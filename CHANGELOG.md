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

### Notes
- Known issue: the mod's main logic in `sm_utilities.nut` (and the
  `lib_utils` / `turret` it includes) is not reachable from the L4D2
  entry chain. Only the per-survivor state in `gnome_turret_trigger.nut`
  is loaded at runtime. See `docs/QA_GAUNTLET.md` Pass 3 for the
  reachability analysis. Fixing the load chain is a prerequisite for
  any feature in 2.0.0 to actually take effect in-game.
