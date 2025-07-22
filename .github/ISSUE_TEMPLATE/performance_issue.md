---
name: Performance Issue
about: Report performance problems with the turret system
title: '[PERFORMANCE] '
labels: 'performance'
assignees: ''
---

## Performance Issue Description
A clear and concise description of the performance problem.

## Performance Metrics
Please provide specific performance data if available:

### Server Performance
- **CPU Usage**: [e.g. 15% with 4 turrets]
- **Memory Usage**: [e.g. 2GB RAM]
- **Tick Rate**: [e.g. Drops from 30 to 20]
- **FPS Impact**: [e.g. Client FPS drops from 60 to 45]

### Turret Configuration
- **Number of Turrets**: [e.g. 8 active turrets]
- **Think Rate**: [e.g. 100ms]
- **Fire Rate**: [e.g. 100ms]
- **Aiming Mode**: [e.g. 1 (Realistic)]
- **Debug Mode**: [e.g. Enabled/Disabled]

## Environment Details
- **Server Type**: [e.g. Dedicated server, Local host]
- **Player Count**: [e.g. 4 players]
- **Map**: [e.g. c1m1_hotel]
- **Game Mode**: [e.g. Campaign, Versus]
- **Other Mods**: [List other active mods]

## Reproduction Steps
1. Set up environment with [specific configuration]
2. Deploy [number] turrets
3. Engage [type] of combat scenario
4. Observe performance degradation

## Expected Performance
What performance level did you expect?
- **Target CPU Usage**: [e.g. <5% with 8 turrets]
- **Target FPS**: [e.g. Stable 60 FPS]
- **Target Tick Rate**: [e.g. Stable 30 tick]

## Actual Performance
What performance are you actually seeing?
- **Actual CPU Usage**: [e.g. 25% with 8 turrets]
- **Actual FPS**: [e.g. Drops to 30 FPS]
- **Actual Tick Rate**: [e.g. Drops to 15 tick]

## Performance Profiling
If you have profiling data, please include it:
```
Paste profiling output here
```

## Console Output
Include any performance-related console messages:
```
Paste console output here
```

## Potential Causes
If you have ideas about what might be causing the issue:
- [ ] Too frequent think rate
- [ ] Inefficient target scanning
- [ ] Memory leaks
- [ ] Excessive visual effects
- [ ] Configuration conflicts
- [ ] Other: [describe]

## Workarounds
Have you found any temporary workarounds?
- [e.g. Reducing think rate to 200ms improves performance]

## Additional Context
Add any other context about the performance issue here.

## Testing Checklist
- [ ] I have tested with default configuration
- [ ] I have tested with minimal other mods
- [ ] I have verified this occurs consistently
- [ ] I have included performance metrics above