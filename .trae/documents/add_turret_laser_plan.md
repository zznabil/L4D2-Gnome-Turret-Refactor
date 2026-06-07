# Red Laser Implementation Plan for Gnome Turret Mod

## Objective
Add a red laser beam effect that follows the turret's aim direction at all times.

## Repository Analysis
### Current Code Structure
- **turret.c**: Contains the main turret logic (CTurret class, placement, firing, thinking loop)
- **sm_utilities.c**: Has helper functions like CreateParticleSystemAt
- **lib_utils.c**: Provides general utility functions
- **gnome_turret_trigger.c**: Entry point that loads sm_utilities and manages config
- **AGENTS.md**: Updated to document Graphify tools (done earlier)

### Existing Particle System Usage
- The mod uses `info_particle_system` entities with `effect_name` key
- Example effects: `weapon_shell_casing_50cal`, `weapon_muzzle_flash_assaultrifle`, etc.
- We'll need to use a laser/beam particle effect (likely from L4D2's built-in particle systems)

## Implementation Steps

### Step 1: Update CTurret Class
Add a member variable to the CTurret class to store the laser entity handle
- File: `scripts/vscripts/turret.c`
- Add `m_hLaserEntity` to the class body and constructor

### Step 2: Spawn Laser Entity on Turret Placement
Modify `PlaceTurret` function to spawn a laser particle system when a turret is placed
- File: `scripts/vscripts/turret.c`
- Use `SpawnEntityFromTable` to create an `info_particle_system`
- Attach it to the machine gun entity
- Choose a red laser particle effect (likely something like `laser_sight_red` or similar)

### Step 3: Update Laser Position Every Frame
Modify `Turret_Think` function to update the laser's origin and angles to match the machine gun's aim direction
- File: `scripts/vscripts/turret.c`
- Every think tick, if the laser entity exists, update its position and orientation
- Make the laser extend out in front of the turret

### Step 4: Clean Up Laser Entity on Turret Removal
Ensure the laser entity is properly killed when:
- Turret is removed (RemoveTurret function)
- Turret runs out of ammo and self-destructs
- File: `scripts/vscripts/turret.c`

### Step 5: QA Verification
- Verify all files compile/parse correctly
- Verify load chain still intact
- Test turret placement with laser visible
- Test laser follows turret aim
- Test laser is cleaned up properly

## Implementation Details

### Particle Effect Choice
L4D2 has built-in laser particles! We can use:
- `laser_sight_red` - Common choice for weapon laser sights
- Or any other appropriate beam/laser particle

### Laser Attachment Point
We'll attach the laser entity to the machine gun entity, or position it at the gun's muzzle
- Muzzle position: machine gun origin + up offset + forward offset

### Laser Configuration
- `start_active` - 1 (always active)
- `effect_name` - laser particle
- Attach to the machine gun's muzzle

## Files to Modify
1. `scripts/vscripts/turret.c` - Main changes
2. Possibly `eTurret` enum if we want to make the laser effect configurable

## Notes
- Do NOT edit `.nut` files directly (per AGENTS.md)
- After QA, run publish.bat to update .nut files
- Then build_vpk.bat to create a new VPK
