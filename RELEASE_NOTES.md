# Release Notes

Curated highlights for each release. Used as the basis for the Steam
Workshop description and the mod's README.

## v2.0.0 (current)
- Placeable gnome turret that shoots at infected.
- Per-survivor ammo, virtual inventory, four chat commands.
- Built on Valve's VScript + Sw1ft's `lib_utils` framework.

> **Heads up for testers:** the 2.0.0 build as published has the per-
> survivor state in `gnome_turret_trigger.nut` wired up, but the main
> mod logic in `sm_utilities.nut` is not currently reached by L4D2's
> entry chain. If the turret itself doesn't appear when you press
> attack, that's why. See `CHANGELOG.md` `[2.0.0]` for the open issue.
