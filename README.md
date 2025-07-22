# L4D2 Gnome Turret Refactor

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![L4D2](https://img.shields.io/badge/game-Left%204%20Dead%202-orange.svg)](https://store.steampowered.com/app/550/Left_4_Dead_2/)
[![VScript](https://img.shields.io/badge/language-Squirrel%20VScript-green.svg)](https://developer.valvesoftware.com/wiki/VScript)

> **Transform your gnomes into automated sentry turrets with advanced AI targeting and realistic ballistics**

An advanced Left 4 Dead 2 modification that converts the standard `weapon_gnome` entity into deployable, automated sentry turrets with sophisticated targeting systems and extensive customization options.

## Features

- **Intelligent Targeting**: Automatic detection and engagement of infected, special infected, and witches
- **Dual Aiming Modes**: Choose between perfect aimbot precision or realistic turret mechanics
- **Extensive Configuration**: Fine-tune performance, damage, range, and behavior
- **Multiple Ammo Types**: Standard, incendiary, and explosive ammunition options
- **Performance Optimized**: Throttled execution system for minimal server impact
- **Visual Effects**: Enhanced muzzle flashes, tracers, and impact effects

## Table of Contents

- [Installation](#installation)
- [Quick Start](#quick-start)
- [Configuration](#configuration)
- [Architecture](#architecture)
- [Performance](#performance)
- [Development](#development)
- [Contributing](#contributing)
- [License](#license)

## Installation

1. **Download** the latest release from the [Releases](../../releases) page
2. **Extract** the `gnome-turret` folder to your L4D2 addons directory:
   ```
   Steam/steamapps/common/Left 4 Dead 2/left4dead2/addons/
   ```
3. **Launch** Left 4 Dead 2 and start any campaign
4. **Find** a gnome and deploy your first turret!

## Quick Start

### Basic Usage
1. Pick up any gnome in the game
2. Aim at a suitable surface and press **USE** (default: E)
3. The gnome transforms into an automated turret
4. Pick up deployed turrets to reclaim them and remaining ammo

### Controls
- **USE + AIM**: Deploy turret at target location
- **USE + DEPLOYED TURRET**: Pick up turret and reclaim ammo

## Configuration

The mod automatically generates configuration files with extensive customization options:

### Performance Settings
- **Think Rate**: Turret update frequency (75-250ms)
- **Fire Rate**: Shots per minute (33-1000ms intervals)

### Aiming System
- **Mode 0**: Perfect aimbot with instant targeting
- **Mode 1**: Realistic turret with rotation speed and settling time
- **Rotation Speed**: 30-720 degrees per second

### Ammunition Types
- **Standard**: High-damage bullets (DMG_BULLET)
- **Incendiary**: Fire-based damage over time (DMG_BURN)
- **Explosive**: Stagger and area damage (DMG_STUMBLE)

## Architecture

### Core Purpose
This modification transforms the standard `weapon_gnome` entity into a sophisticated, deployable sentry turret system with advanced AI targeting capabilities.

### Key Components
- **Automatic Target Acquisition**: Intelligent scanning and engagement of hostile entities
- **Line-of-Sight Validation**: Prevents wasted ammunition on obstructed targets  
- **Stateful Management**: Optimized target tracking and memory management
- **Performance Optimization**: Throttled execution for minimal server impact

### Design Philosophy
The architecture prioritizes **stability** and **compatibility** by leveraging L4D2's native VScript event system. Performance optimizations are implemented as non-intrusive layers that preserve the core functionality while dramatically improving efficiency.

## Three-Stage Architecture

### Stage 1: Setup Phase (Map Load)
**Trigger**: Map initialization
**Purpose**: Establishes the foundation for turret functionality

**Key Operations:**
- **Entity Replacement**: Replaces all `weapon_gnome` spawns with custom turret-enabled versions
- **Event Registration**: Sets up button listeners and game event handlers
- **Resource Precaching**: Loads required models, sounds, and particle effects
- **Configuration Loading**: Reads settings from auto-generated config files

**Critical Implementation Details:**
- Uses `ReplaceWeaponSpawn()` to maintain compatibility with existing maps
- Registers button listeners for USE and ATTACK inputs
- Precaches all visual and audio assets to prevent runtime stutters

### Stage 2: Deployment Phase (Player Interaction)
**Trigger**: Player USE button while holding gnome
**Purpose**: Converts gnome into functional turret

**Key Operations:**
- **Placement Validation**: Checks surface suitability and positioning constraints
- **Entity Creation**: Spawns turret components (machine gun, bipod, tracer)
- **State Initialization**: Sets up turret object with default parameters
- **Visual Setup**: Applies models, angles, and initial positioning

**Critical Implementation Details:**
- Validates placement using ground distance and forward distance checks
- Creates `CTurret` class instance with proper entity references
- Applies configuration-based settings (damage type, ammo count, etc.)

### Stage 3: Active Phase (Turret Operation)
**Trigger**: Continuous execution via `Turret_Think()`
**Purpose**: Handles targeting, aiming, and firing logic

**Key Operations:**
- **Target Scanning**: Searches for valid hostile entities within range
- **Line-of-Sight Verification**: Ensures clear shot to target
- **Aiming Calculation**: Determines required rotation angles
- **Firing Control**: Manages shot timing and ammunition consumption

**Critical Implementation Details:**
- Uses throttled execution (configurable think rate) for performance
- Implements stateful target tracking to reduce redundant scans
- Supports dual aiming modes (aimbot vs realistic rotation)

## Performance

### Optimization History
The turret system evolved from a per-frame execution model to a highly optimized throttled system:

1. **Original Implementation**: Executed on every server tick (~60+ times/second)
2. **Optimized Version**: Throttled to configurable intervals (default: 10 times/second)
3. **Performance Gain**: ~85% reduction in CPU usage

### Key Optimizations
- **Stateful Target Management**: Turrets remember their targets to reduce scanning
- **Throttled Think Loop**: Main logic runs at configurable intervals
- **Conditional Target Scanning**: Only scan for new targets when needed
- **Centralized Logic**: Core functionality consolidated in `Turret_Think()`

### Performance Metrics
- **Default Think Rate**: 100ms (10 updates/second)
- **Default Fire Rate**: 100ms (600 RPM)
- **Memory Usage**: Minimal impact with proper entity cleanup
- **Server Load**: <1% CPU usage with 8 active turrets

## Development

### File Structure
```
gnome-turret/
├── scripts/vscripts/
│   ├── turret.nut              # Main turret logic
│   ├── gnome_turret_trigger.nut # Spawning and configuration
│   ├── lib_utils.nut           # Utility functions
│   ├── sm_utilities.nut        # Script mutation utilities
│   └── mapspawn_addon.nut      # Map spawn integration
└── addoninfo.txt               # Addon metadata
```

### Key Classes and Functions

#### CTurret Class
```squirrel
class CTurret {
    // State Management
    m_hTarget           // Current target entity
    m_bIsRotating       // Rotation state flag
    m_bCanFire          // Firing permission flag
    
    // Timing Control
    m_flNextShootTime   // Next allowed shot time
    m_flSettlingTime    // Aiming settle duration
    m_flLastThinkTime   // Last update timestamp
    
    // Entity References
    m_hMachineGun       // Main turret entity
    m_hTracerEntity     // Line-of-sight tracer
    m_hLaserSight       // Visual targeting aid
}
```

#### Core Functions
- `Turret_Think()` - Main logic loop with performance optimizations
- `PlaceTurret()` - Turret deployment and setup
- `RemoveTurret()` - Cleanup and removal
- `TurretShoot()` - Firing mechanics with visual effects
- `IsCanSeeEntity()` - Line-of-sight calculations

### Development Guidelines

#### Code Organization
- Use clear feature enhancement comments: `// -- FEATURE ENHANCEMENT: Description --`
- Group related global variables together
- Implement proper error handling and validation

#### Variable Naming Conventions
- Global turret settings use `GnomeTurret` prefix
- Player-specific variables include character names
- Time-based variables use descriptive suffixes

#### Performance Considerations
- Use configurable think rates to balance responsiveness vs performance
- Implement target caching to avoid redundant scanning
- Always validate entity references before use

## Common Issues and Solutions

### File Corruption
- **Issue**: Script files may become corrupted during development
- **Solution**: Maintain regular backups and verify global variable consistency

### Aiming Performance
- **Issue**: Turret too restrictive or fires while rotating
- **Solution**: Adjust tolerance values and rotation detection thresholds

### Configuration Persistence
- **Issue**: Settings not loading properly
- **Solution**: Ensure all variables are included in config file generation

## Contributing

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

### Development Setup
1. Install Left 4 Dead 2 with SDK tools
2. Set up VScript development environment
3. Follow the coding conventions outlined in `.agent.md`

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

### Development Team
- **Sw1ft** ([alkashproduction](https://steamcommunity.com/id/alkashproduction)) - Original concept and foundation
- **Kurochama** ([kurochamaw](https://steamcommunity.com/id/kurochamaw)) - Inventory system, ammo refill, 360-degree scanning, extended range
- **Sultan** ([sultanabualpepsi](https://steamcommunity.com/id/sultanabualpepsi)) & AI Copilot - Idle scanning animations, performance optimizations, turret ammunition types, configurable systems, visual effects, error handling, dual aiming modes (Mode 0/Mode 1)

### Community
- **L4D2 Community**: For extensive testing and feedback
- **Valve Corporation**: For the Source Engine and VScript system

## Links

- [Steam Workshop](https://steamcommunity.com/sharedfiles/filedetails/?id=YOUR_WORKSHOP_ID)
- [L4D2 VScript Documentation](https://developer.valvesoftware.com/wiki/L4D2_VScript_Examples)
- [Source Engine Documentation](https://developer.valvesoftware.com/wiki/Source)