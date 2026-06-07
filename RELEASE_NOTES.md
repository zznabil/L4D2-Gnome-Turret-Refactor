# Release Notes

Curated highlights for each release. Used as the basis for the Steam
Workshop description and the mod's README.

## Latest (unreleased)

### New Features
- **Laser sight toggle** (`!tl`) — persistent red beam from muzzle follows the gun's aim at all times
- **Guaranteed stagger** — Fire, Explosive, and Demolition shots now reliably stumble special infected
- **Demolition insta-gib** — Common infected explode instantly on demolition shot
- **Layered explosive VFX** — Dual particle burst (small + large) at chest height on explosive ammo hits
- **Professional repo** — Added `README.md`, `LICENSE` (MIT), `.gitignore`, updated changelog

### Bug Fixes
- Special infected are now targetable (broken brace path in `GetEntityPosition`)
- Explosive ammo VFX and stagger no longer depend on demolition toggle being on
- Sweep and aiming lasers no longer crash (fixed `Type_Hit` → `Type_Pos` for `Line()`)
- `QAngle` keyvalue errors eliminated from entity spawn system
- Unknown particle `generic_explosion` replaced with working `gas_explosion_main`

## v2.0.0 (original release)
- Placeable gnome turret that shoots at infected.
- Per-survivor ammo, virtual inventory, four chat commands.
- Built on Valve's VScript + Sw1ft's `lib_utils` framework.
