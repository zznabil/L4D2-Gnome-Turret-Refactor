# Gnome Turret Mod

![License](https://img.shields.io/github/license/zznabil/L4D2-Gnome-Turret-Refactor)
![Game](https://img.shields.io/badge/game-Left%204%20Dead%202-8B0000?logo=steam)
![Language](https://img.shields.io/badge/language-Squirrel-FF6600)
![Platform](https://img.shields.io/badge/platform-VScript-00AA00)
![Last Commit](https://img.shields.io/github/last-commit/zznabil/L4D2-Gnome-Turret-Refactor)

**Placeable auto-turret gnomes for Left 4 Dead 2.** After the Gnome Rescue Mission on Dark Carnival, the gnome race sent representatives to help survivors fight zombies with their transformation magic. Place a turret, choose your ammo, and watch the gnomes mow down the infected.

---

## Features

| Feature | Description |
|---------|-------------|
| **Turret Placement** | Press left-click (IN_ATTACK) to place a gnome turret. Requires a valid surface within range. |
| **Per-Survivor Ammo** | Each survivor has an independent ammo pool (300 base, clamped 5–400). Persists across rounds via virtual inventory. |
| **3 Ammo Types** | `!ta default` (bullet), `!ta fire` (incendiary/burn), `!ta explosive` (stumble/knockback) |
| **Machine Gun Mode** | `!tm` — toggle full-auto; turret picks a clip weapon variant |
| **Demolition Mode** | `!tde 1` — each shot fires an env_explosion; insta-gibs commons, staggers specials |
| **Laser Sight** | `!tl` — toggleable red laser beam drawn from muzzle to target. Always visible, follows the gun's aim. |
| **Bullet Tracer** | White-yellow tracer line from muzzle to impact point on every shot |
| **Idle Sweep** | Auto-sweeps when no target found; configurable speed (`!ts`) and arc (`!tarc`) |
| **Impact VFX** | Per-ammo impact effects: blood for default, incendiary sparks for fire, layered explosive bursts for explosive |
| **Deploy VFX** | Smoke explosion + electrical sparks on turret placement |
| **Stagger on Hit** | Fire/Explosive/Demolition shots guarantee stagger on special infected |
| **Virtual Inventory** | Tab+Shove to store a turret, Tab+Ctrl+Jump to retrieve it |
| **Turret Limit** | Server-global limit (default 4, max 32). Set with `!thelp <number>`. |

## Chat Commands

| Command | Arguments | Description | Host Only |
|---------|-----------|-------------|-----------|
| `!ta` | `default`, `explosive`, `fire` | Set ammo type for all your turrets | — |
| `!tr` | `all` (optional) | Remove your placed turret(s) | — |
| `!tm` | — | Toggle machine gun mode | — |
| `!td` | — | Toggle debug mode (shows aim lines, positions) | — |
| `!ts` | `<speed>` | Set idle sweep speed in deg/sec (1–360) | ✅ |
| `!tarc` | `<degrees>` | Set idle sweep arc (2–360) | ✅ |
| `!tde` | `0` or `1` | Toggle demolition mode | ✅ |
| `!tl` | — | Toggle laser sight ON/OFF | ✅ |
| `!thelp` | — | Show all commands, version, and turret count | — |

## Installation

### Manual
1. Download **turret.vpk** from the [dist/](./dist/) folder or [Releases](https://github.com/zznabil/L4D2-Gnome-Turret-Refactor/releases)
2. Place it in `Steam\steamapps\common\Left 4 Dead 2\left4dead2\addons\`
3. Launch L4D2 — the mod loads automatically (no campaign restart needed)

### In-Game Reload
After updating the `.vpk`, use the console command `script_reload` to reload scripts without restarting the map.

## Building from Source

The mod is written in Squirrel as `.c` files (for clangd/LSP parsing) and published to `.nut` files that the game loads.

```batch
tools\publish.bat      # Generate .nut from .c source
tools\build_vpk.bat    # Build dist/turret.vpk
```

**Dev cycle**: Edit `.c` → run QA gauntlet → `publish.bat` → `build_vpk.bat` → drop `.vpk` into `addons/`

**Requirements**: L4D2 installation with `vpk.exe`, PowerShell 5+, clangd (optional, for LSP).

### QA Gauntlet (before publishing)
1. **Parse check** — All `.c` files parse without syntax errors
2. **Drift detection** — No divergence between duplicated functions across files
3. **Reachability** — Every `.nut` file has a load path from the entry point

See [docs/QA_GAUNTLET.md](docs/QA_GAUNTLET.md) for the full procedure.

## Configuration

On first launch, config files are created at `<L4D2>\left4dead2\cfg\gnome turret\`:

| File | Purpose |
|------|---------|
| `gnome turret.txt` | Main config — ammo base, sweep, demo mode, turret limit |
| `virtual inventory\gnome virtual inventory.txt` | Per-survivor ammo persistence across rounds |

### Key Convars (edit in `gnome turret.txt`)

| Convar | Default | Description |
|--------|---------|-------------|
| `GnomeTurretAmmoBase` | 300 | Starting ammo per survivor (5–400) |
| `GnomeTurretSweepSpeed` | 20.0 | Idle sweep speed (deg/sec) |
| `GnomeTurretSweepArc` | 90.0 | Idle sweep arc (degrees total) |
| `DemolitionShot` | 0 | Toggle demolition mode (1 = on) |
| `GnomeLimit` | 2 | Max turrets per survivor |
| `g_bTurretParticlesEnabled` | 1 | Enable/disable particle effects |

## Project Structure

```
scripts/vscripts/
├── mapspawn_addon.c        # Entry point (1 line, auto-loaded)
├── gnome_turret_trigger.c  # Per-survivor state, event hooks, inventory
├── sm_utilities.c          # Utility framework (startbox, scoring, HUD)
├── lib_utils.c             # Squirrel library (~3100 lines)
├── turret.c                # Turret class, placement, targeting, commands
└── entity_pool.c           # Global entity pool (particles, sounds)
```

**Load chain**: `mapspawn_addon` → `gnome_turret_trigger` → `sm_utilities` → `lib_utils` + `turret`

## Screenshots

*[Coming soon — drop in `docs/screenshots/` and reference here]*

| | |
|---|---|
| *Turret deployed on a railing, sweeping for targets* | *Turret engaging a horde with incendiary ammo* |
| *Explosive ammo impact VFX on a special infected* | *Demolition mode gibbing common infected* |

## Credits

- [`sm_utilities`](scripts/vscripts/sm_utilities.c) + [`lib_utils`](scripts/vscripts/lib_utils.c) frameworks by **Sw1ft** ([Steam](http://steamcommunity.com/profiles/76561198397776991))
- [`entity_pool`](scripts/vscripts/entity_pool.c) system — ring-buffered particle/sound reuse
- Built on [Valve's VScript](https://developer.valvesoftware.com/wiki/Left_4_Dead_2/Scripting) (Squirrel 3.0)
- Thanks to the L4D2 modding community

## License

MIT — see [LICENSE](LICENSE) for details.

---

[CHANGELOG.md](CHANGELOG.md) • [Release Notes](RELEASE_NOTES.md) • [Development Docs](docs/SDLC_AND_QA.md) • [QA Gauntlet](docs/QA_GAUNTLET.md)
