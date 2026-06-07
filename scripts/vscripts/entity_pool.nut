// entity_pool.c — Global entity pool system
// Pre-spawns entities at init, reuses via Stop/Start/SetParticleSystem.
// No Kill() in per-shot path → no CGameStringPool leak.
//
// Pools:
//   Impact ring buffer: N=4 info_particle_system, round-robin, SetParticleSystem per use
//   Sound ring buffer:  N=4 ambient_generic, round-robin, PlaySound per use

// === Impact Particle Ring Buffer ===
g_aImpactParticlePool <- [];
g_iImpactParticleIndex <- 0;
const IMPACT_POOL_SIZE = 4;

// === Sound Entity Ring Buffer ===
g_aShootSoundPool <- [];
g_iSoundEntityIndex <- 0;
const SOUND_POOL_SIZE = 4;

function InitParticlePools()
{
	// Pre-spawn impact particles (dummy effect, changed per-use via SetParticleSystem input)
	for (local i = 0; i < IMPACT_POOL_SIZE; i++)
	{
		local hParticle = SpawnEntityFromTable("info_particle_system", {
			effect_name = "blood_gib_1"
			start_active = 0
		});
		g_aImpactParticlePool.push(hParticle);
	}

	// Pre-spawn ambient_generic entities for shoot sound
	for (local i = 0; i < SOUND_POOL_SIZE; i++)
	{
		local hSound = SpawnEntityFromTable("ambient_generic", {
			message = "weapons/50cal/50cal_shoot.wav"
			spawnflags = 48
			health = 100
		});
		g_aShootSoundPool.push(hSound);
	}

	printl("[EntityPool] Init: " + IMPACT_POOL_SIZE + " impact particles, " + SOUND_POOL_SIZE + " sound entities");
}

function PlayImpactEffect(vecPos, sEffectName)
{
	if (!g_bTurretParticlesEnabled) return;

	local hParticle = g_aImpactParticlePool[g_iImpactParticleIndex];
	g_iImpactParticleIndex = (g_iImpactParticleIndex + 1) % IMPACT_POOL_SIZE;

	if (!hParticle || !hParticle.IsValid())
		return;

	// Stop any current effect
	AcceptEntityInput(hParticle, "Stop");

	// Switch to new effect
	DoEntFire("!self", "SetParticleSystem", sEffectName, 0.0, hParticle, hParticle);

	// Position at impact point
	hParticle.SetOrigin(vecPos);

	// Play
	AcceptEntityInput(hParticle, "Start");

	// Auto-stop after visual lifetime
	AcceptEntityInput(hParticle, "Stop", "", 0.05);
}

function PlayShootSound(vecPos)
{
	if (!g_bTurretParticlesEnabled) return;

	local hSound = g_aShootSoundPool[g_iSoundEntityIndex];
	g_iSoundEntityIndex = (g_iSoundEntityIndex + 1) % SOUND_POOL_SIZE;

	if (!hSound || !hSound.IsValid())
		return;

	hSound.SetOrigin(vecPos);
	AcceptEntityInput(hSound, "PlaySound");
}
