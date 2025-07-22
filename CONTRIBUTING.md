# Contributing to L4D2 Gnome Turret Refactor

Thank you for your interest in contributing to the L4D2 Gnome Turret Refactor project! This document provides guidelines and information for contributors.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Contributing Guidelines](#contributing-guidelines)
- [Coding Standards](#coding-standards)
- [Testing](#testing)
- [Submitting Changes](#submitting-changes)

## Code of Conduct

This project follows a simple code of conduct:
- Be respectful and constructive in all interactions
- Focus on the technical aspects of contributions
- Help maintain a welcoming environment for all contributors

## Getting Started

### Prerequisites
- Left 4 Dead 2 installed with SDK tools
- Basic understanding of Squirrel scripting language
- Familiarity with L4D2 VScript system
- Text editor with syntax highlighting (VS Code recommended)

### Development Environment
1. **Install L4D2**: Ensure you have Left 4 Dead 2 with the SDK tools
2. **Clone Repository**: Fork and clone this repository
3. **Setup Workspace**: Follow the setup instructions in `.agent.md`
4. **Test Installation**: Deploy a test turret to verify everything works

## Development Setup

### File Structure
```
L4D2-Gnome-Turret-Refactor/
├── gnome-turret/
│   ├── scripts/vscripts/
│   │   ├── turret.nut              # Main turret logic
│   │   ├── gnome_turret_trigger.nut # Spawning and configuration
│   │   ├── lib_utils.nut           # Utility functions
│   │   ├── sm_utilities.nut        # Script mutation utilities
│   │   └── mapspawn_addon.nut      # Map spawn integration
│   └── addoninfo.txt               # Addon metadata
├── README.md                       # Project documentation
├── TLDR.md                        # Quick reference guide
├── changelog.md                   # Performance evolution history
├── .agent.md                      # Developer reference
└── CONTRIBUTING.md                # This file
```

### Key Files to Understand
- **`.agent.md`**: Comprehensive developer reference with best practices
- **`turret.nut`**: Core turret functionality and performance optimizations
- **`lib_utils.nut`**: Chat command system and utility functions

## Contributing Guidelines

### Types of Contributions

#### Bug Fixes
- Performance issues
- Targeting problems
- Memory leaks
- Configuration errors

#### Feature Enhancements
- New aiming modes
- Additional ammunition types
- Configuration options
- Visual effects improvements

#### Documentation
- Code comments
- User guides
- Technical documentation
- Examples and tutorials

#### Performance Optimizations
- Execution efficiency improvements
- Memory usage optimizations
- Server load reductions

### Before You Start
1. **Check Issues**: Look for existing issues or feature requests
2. **Discuss Changes**: For major changes, open an issue first to discuss
3. **Read Documentation**: Review `.agent.md` for development guidelines
4. **Understand Architecture**: Familiarize yourself with the 3-stage architecture

## Coding Standards

### Squirrel Script Conventions

#### Variable Naming
```squirrel
// Global turret settings - use GnomeTurret prefix
GnomeTurretDamage <- 50
GnomeTurretAimMode <- 1

// Player-specific variables - include character names
GnomeTurretNick <- 0
GnomeTurretAmmoCoach <- 0

// Time-based variables - use descriptive suffixes
GnomeTurretThinkRateMS <- 100
GnomeTurretFireRateMS <- 100
```

#### Function Organization
```squirrel
// Use clear feature enhancement comments
// -- FEATURE ENHANCEMENT: Realistic Aiming System --
function CalculateTargetAngles(turret, target)
{
    // Implementation here
}

// Group related functions together
// -- AIMING MODE TOGGLE SYSTEM --
function SetAimingMode(mode) { /* ... */ }
function GetAimingMode() { /* ... */ }
```

#### Error Handling
```squirrel
// Always validate entity references
if (!turret || !turret.m_hMachineGun || !turret.m_hMachineGun.IsValid())
{
    return false;
}

// Use proper null checks
if ("m_hTarget" in turret && turret.m_hTarget != null)
{
    // Safe to use target
}
```

### Performance Considerations
- Use configurable think rates to balance responsiveness vs performance
- Implement target caching to avoid redundant scanning
- Always validate entity references before use
- Clamp user inputs to prevent extreme values

### Documentation Standards
```squirrel
/**
 * Calculates the required rotation angles for turret targeting
 * @param {CTurret} turret - The turret instance
 * @param {CBaseEntity} target - The target entity
 * @return {QAngle} Required angles for targeting
 */
function CalculateTargetAngles(turret, target)
{
    // Implementation
}
```

## Testing

### Manual Testing
1. **Basic Functionality**: Deploy and pickup turrets
2. **Target Acquisition**: Test against various infected types
3. **Configuration**: Verify all settings work correctly
4. **Performance**: Monitor server performance with multiple turrets

### Performance Testing
- Test with maximum turret count (default: 8)
- Monitor CPU usage during intense combat
- Verify memory cleanup after turret removal
- Test configuration file loading/saving

### Edge Case Testing
- Invalid entity references
- Corrupted configuration files
- Extreme configuration values
- Network lag scenarios

## Submitting Changes

### Pull Request Process

1. **Fork the Repository**
   ```bash
   git fork https://github.com/username/L4D2-Gnome-Turret-Refactor
   ```

2. **Create Feature Branch**
   ```bash
   git checkout -b feature/amazing-feature
   ```

3. **Make Changes**
   - Follow coding standards
   - Add appropriate comments
   - Update documentation if needed

4. **Test Thoroughly**
   - Manual testing in L4D2
   - Performance verification
   - Edge case validation

5. **Commit Changes**
   ```bash
   git commit -m "Add amazing feature: detailed description"
   ```

6. **Push to Branch**
   ```bash
   git push origin feature/amazing-feature
   ```

7. **Open Pull Request**
   - Provide clear description
   - Reference related issues
   - Include testing information

### Pull Request Guidelines

#### Title Format
- Use descriptive titles: "Fix targeting issue with special infected"
- Include type prefix: "feat:", "fix:", "docs:", "perf:"

#### Description Template
```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Performance improvement
- [ ] Documentation update

## Testing
- [ ] Manual testing completed
- [ ] Performance impact verified
- [ ] Edge cases tested

## Related Issues
Fixes #123
```

### Review Process
1. **Automated Checks**: Code formatting and basic validation
2. **Technical Review**: Code quality and architecture compliance
3. **Testing Review**: Verification of testing completeness
4. **Performance Review**: Impact on server performance
5. **Documentation Review**: Updates to relevant documentation

## Development Tips

### Debugging
- Use `GnomeTurretDebugMode` for detailed output
- Implement rate-limited debug messages
- Test with various server configurations

### Performance Optimization
- Profile code changes with multiple turrets
- Use throttled execution patterns
- Implement proper entity cleanup

### Configuration Management
- Ensure all new variables are included in config generation
- Test configuration loading with edge cases
- Maintain backward compatibility

## Getting Help

### Resources
- **Developer Reference**: See `.agent.md` for comprehensive guidelines
- **Technical Documentation**: Review `README.md` architecture section
- **Performance Guide**: Check `changelog.md` for optimization patterns

### Community
- **Issues**: Use GitHub issues for bug reports and feature requests
- **Discussions**: Use GitHub discussions for general questions
- **Discord**: Join the L4D2 modding community Discord

## Recognition

Contributors will be recognized in:
- README.md acknowledgments section
- Git commit history
- Release notes for significant contributions

Thank you for contributing to the L4D2 Gnome Turret Refactor project!