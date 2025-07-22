# Pull Request

## Description
Brief description of the changes in this pull request.

## Type of Change
Please delete options that are not relevant:
- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Performance improvement (non-breaking change that improves performance)
- [ ] Documentation update (changes to documentation only)
- [ ] Code refactoring (no functional changes)

## Related Issues
- Fixes #(issue number)
- Relates to #(issue number)
- Part of #(issue number)

## Changes Made
### Core Changes
- [ ] Modified `turret.nut`
- [ ] Modified `gnome_turret_trigger.nut`
- [ ] Modified `lib_utils.nut`
- [ ] Modified configuration system
- [ ] Added new features
- [ ] Fixed bugs

### Specific Changes
- Change 1: [Description]
- Change 2: [Description]
- Change 3: [Description]

## Testing
### Manual Testing
- [ ] Basic turret deployment and pickup
- [ ] Target acquisition and firing
- [ ] Configuration changes
- [ ] Multiple turret scenarios
- [ ] Edge cases and error conditions

### Performance Testing
- [ ] CPU usage impact measured
- [ ] Memory usage verified
- [ ] Server performance tested
- [ ] Client FPS impact checked

### Compatibility Testing
- [ ] Tested with existing saves
- [ ] Tested with other mods
- [ ] Tested in multiplayer
- [ ] Backward compatibility verified

## Performance Impact
### Before Changes
- CPU Usage: [e.g. 10% with 8 turrets]
- Memory Usage: [e.g. 1.5GB]
- Think Rate: [e.g. 100ms]

### After Changes
- CPU Usage: [e.g. 8% with 8 turrets]
- Memory Usage: [e.g. 1.4GB]
- Think Rate: [e.g. 100ms]

### Performance Notes
[Any specific performance considerations or improvements]

## Configuration Changes
### New Variables
```squirrel
// List any new global variables
GnomeTurretNewFeature <- 0
```

### Modified Variables
```squirrel
// List any modified variables
GnomeTurretExistingFeature <- 1  // Changed from 0 to 1
```

### Backward Compatibility
- [ ] All existing configurations will continue to work
- [ ] Configuration migration is automatic
- [ ] No manual intervention required

## Code Quality
### Code Standards
- [ ] Follows project coding conventions
- [ ] Proper variable naming (GnomeTurret prefix)
- [ ] Appropriate comments and documentation
- [ ] Error handling implemented

### Architecture
- [ ] Maintains 3-stage architecture
- [ ] Preserves performance optimizations
- [ ] Uses proper entity cleanup
- [ ] Follows stateful target management

## Documentation
### Updated Documentation
- [ ] README.md updated
- [ ] .agent.md updated
- [ ] Code comments added
- [ ] Configuration documentation updated

### New Documentation
- [ ] New features documented
- [ ] Usage examples provided
- [ ] Performance notes included

## Screenshots/Videos
If applicable, add screenshots or videos demonstrating the changes.

## Checklist
- [ ] My code follows the style guidelines of this project
- [ ] I have performed a self-review of my own code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have made corresponding changes to the documentation
- [ ] My changes generate no new warnings
- [ ] I have added tests that prove my fix is effective or that my feature works
- [ ] New and existing unit tests pass locally with my changes
- [ ] Any dependent changes have been merged and published

## Additional Notes
[Any additional information that reviewers should know]

## Reviewer Notes
### Focus Areas
Please pay special attention to:
- [ ] Performance impact
- [ ] Code quality
- [ ] Documentation completeness
- [ ] Testing coverage

### Questions for Reviewers
1. [Specific question about implementation]
2. [Question about performance trade-offs]
3. [Question about architecture decisions]