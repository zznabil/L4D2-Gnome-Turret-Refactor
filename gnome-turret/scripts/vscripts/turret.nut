// Squirrel
// Turret Mod
GnomeTurretDamage <- 50
GnomeTurretAmmoBase <- 1000
g_flLastConfigCheck <- 0.0;

// -- PERFORMANCE SETTINGS --
GnomeTurretThinkRateMS <- 100
GnomeTurretFireRateMS <- 100

// -- AIMING SYSTEM --
GnomeTurretAimMode <- 1
GnomeTurretRotationSpeed <- 160.0

// -- TURRET LIMITS --
GnomeTurretMaxCount <- 8

// -- FEATURE TOGGLES --
// GnomeTurretDemolitionMode <- 0 // DISABLED - Demolition mode removed
GnomeTurretExplosiveMode <- 0
GnomeTurretFireEnabled <- 1
GnomeTurretDebugMode <- 0
GnomeTurretDebugLastTime <- 0.0
GnomeTurretDebugInterval <- 2.0  // Debug messages every 2 seconds
GnomeTurretRange <- 6666.0

GnomeTurretNick <- 0
GnomeTurretCoach <- 0
GnomeTurretEllis <- 0
GnomeTurretRochelle <- 0
GnomeTurretBill <- 0
GnomeTurretLouis <- 0
GnomeTurretFrancis <- 0
GnomeTurretZoey <- 0
TurretDataSaveTimer <- 0

GnomeTurretAmmoNick <- 0
GnomeTurretAmmoCoach <- 0
GnomeTurretAmmoEllis <- 0
GnomeTurretAmmoRochelle <- 0
GnomeTurretAmmoBill <- 0
GnomeTurretAmmoLouis <- 0
GnomeTurretAmmoFrancis <- 0
GnomeTurretAmmoZoey <- 0

class CTurret
{
	constructor(ammo, tracer_entity, machine_gun, angles, owner, identifier, damagetype, bipod, mg_mode, mg_ammo)
	{
		m_iAmmo = ammo;
		m_hOwner = owner;
		m_hTracerEntity = tracer_entity;
		m_eDefaultAngles = angles;
		m_hMachineGun = machine_gun;
		m_sIdentifier = identifier;
		m_iDamageType = damagetype;
		m_bMachineGunMode = mg_mode;
		m_aMachineGunAmmo = mg_ammo;
		m_aBipod = bipod;
		m_hTarget = null;
	}
	function SetAmmo(iAmount)
	{
		m_iAmmo = iAmount;
	}
	function SetShootTime(fTime)
	{
		m_flNextShootTime = fTime;
	}
	function SetAnglesChangeTime(fTime)
	{
		m_flNextAnglesChangeTime = fTime;
	}
	function SetDamageType(iType)
	{
		m_iDamageType = iType;
	}
	function SetMachineGunAmmo(aAmmo)
	{
		m_aMachineGunAmmo = aAmmo;
	}
	function SetCurrentAngles(angles)
	{
		m_eCurrentAngles = angles;
	}
	function SetTargetAngles(angles)
	{
		m_eTargetAngles = angles;
	}
	function SetSettlingTime(time)
	{
		m_flSettlingTime = time;
	}
	function SetLastThinkTime(time)
	{
		m_flLastThinkTime = time;
	}
	function SetLastFireTime(time)
	{
		m_flLastFireTime = time;
	}
	m_iAmmo = 0;
	m_aBipod = null;
	m_hOwner = null;
	m_hMachineGun = null;
	m_hTracerEntity = null;
	m_hLaserSight = null;
	m_eDefaultAngles = null;
	m_eCurrentAngles = null;
	m_eTargetAngles = null;
	m_flNextShootTime = 0.0;
	m_flNextAnglesChangeTime = 0.0;
	m_flSettlingTime = 0.0;
	m_flLastThinkTime = 0.0;
	m_flLastFireTime = 0.0;
	m_iDamageType = DMG_BULLET;
	m_bMachineGunMode = false;
	m_aMachineGunAmmo = 0;
	m_sIdentifier = null;
	m_bIsRotating = false;
	m_bCanFire = true;
	m_hTarget = null;
	// Scanning animation variables
	m_bIsScanning = false;
	m_flScanStartTime = 0.0;
	m_flScanDirection = 1.0; // 1 for right, -1 for left
	m_eScanStartAngles = null;
	m_flScanRange = 120.0; // Total scan range in degrees
}

enum eTurret
{
	Damage = 50.0
	MaxAmmo = 300
	MaxAngle = 360.0 // 75
	MaxRange = 6666.0
	MaxRadiusUse = 90.0
	MaxAngleUse = 360.0 // 25
	MaxClipSize = 250
	MaxDistanceToGround = 150.0
	MaxForwardDistance = 70.0 // 50
	MinForwardDistance = 50.0 // 30
	ToleranceAngle = 25.0
	IdleTime = 3.0
	ShootTime = 0.1 //0.2
	// Scanning animation settings
	ScanSpeed = 25.0 // degrees per second (increased for faster scanning)
	ScanRange = 90.0 // total scan range in degrees (reduced from 120)
	ScanPauseTime = 1.0 // pause time at each end of scan (reduced for faster scanning)
	ShootSound = "weapons/50cal/50cal_shoot.wav"
	Shell = "weapon_shell_casing_50cal"
	MuzzleFlash = "weapon_muzzle_flash_autoshotgun"
	SmokeTrail = "weapon_muzzle_smoke_b"  // Smoke trail effect after each shot
	BulletTracer = "weapon_tracers_incendiary_streak"  // Fixed bullet tracer effect
	// HeavySmoke = "smoke_medium_01"  // Intense smoke effect (disabled for testing)
	// Sparks = "barrel_fly_embers"  // Sparks from barrel (disabled for testing)
	// BarrelHeat = "fire_jet_01_flame"  // Additional intense muzzle flash (disabled for testing)
	// GunpowderSmoke = "fire_small_02"  // Dense gunpowder smoke (disabled for testing)
	ExtraSmoke = "weapon_muzzle_smoke"  // Additional weapon smoke
	// New enhanced effects from particle list
	// MuzzleFlash50Cal = "weapon_muzzle_flash_50cal"  // Heavy 50cal muzzle flash (disabled for testing)
	// MuzzleFlashMinigun = "weapon_muzzle_flash_minigun"  // Minigun style flash (disabled for testing)
	// MuzzleFlashSparks = "weapon_muzzle_flash_sparks"  // Muzzle sparks (disabled for testing)
	MuzzleFlashSparks2 = "weapon_muzzle_flash_sparks2"  // Additional sparks
	MuzzleSmokeLong = "weapon_muzzle_smoke_long"  // Long lasting smoke
	MuzzleSmokeLongB = "weapon_muzzle_smoke_long_b"  // Alternative long smoke
	MuzzleFlashSmokeSmall = "weapon_muzzle_flash_smoke_small"  // Small smoke puffs
	MuzzleFlashSmokeSmall2 = "weapon_muzzle_flash_smoke_small2"  // More small smoke
	ImpactDefault = "blood_gib_1"
	ImpactIncendiary = "impact_incendiary_generic"
	ImpactExplosive = "impact_explosive_ammo_small"
	ImpactExplosiveExtra = "impact_explosive_ammo_large"
	Weapon = "weapon_gnome"
}

explosion_entity <-
{
	classname = "env_explosion"
	targetname = ""
	iRadiusOverride = 66
	fireballsprite = "sprites/zerogxplode.spr"
	ignoredClass = 0
	iMagnitude = 13
	rendermode = 5
	spawnflags = 6 | 64 // Repeatable | No Sound
	origin = Vector(0, 0, 0)
}

// DemolitionShot <- 1 // DISABLED - Demolition mode removed
ExplosionAmmoToggle <- 0
ExplosionEntity <- SpawnEntityFromTable("env_explosion", explosion_entity);
g_bDebugMode <- false;
g_flFindPotentialTargetsTime <- 0.0;

g_aPotentialTargets <- [];
g_aTurretList <- [];

// Helper function to check if debug messages should be displayed (rate limited)
function ShouldShowDebugMessage()
{
	if (!GnomeTurretDebugMode) return false;

	local currentTime = Time();
	if (currentTime - GnomeTurretDebugLastTime >= GnomeTurretDebugInterval)
	{
		GnomeTurretDebugLastTime = currentTime;
		return true;
	}
	return false;
}

// Function to handle smooth scanning animation
function UpdateTurretScanningAnimation(turret)
{
	if (!turret || !turret.m_hMachineGun || !turret.m_hMachineGun.IsValid()) return;

	local currentTime = Time();

	// Initialize scanning if not already started
	if (!turret.m_bIsScanning)
	{
		turret.m_bIsScanning = true;
		turret.m_flScanStartTime = currentTime;
		turret.m_eScanStartAngles = turret.m_eDefaultAngles;
		turret.m_flScanDirection = 1.0; // Start scanning right
		return;
	}

	local scanElapsed = currentTime - turret.m_flScanStartTime;
	local halfRange = eTurret.ScanRange * 0.5;

	// Simple sine wave based scanning for smooth motion
	local scanFrequency = 1.0 / (eTurret.ScanRange / eTurret.ScanSpeed + eTurret.ScanPauseTime);
	local sineValue = sin(scanElapsed * scanFrequency * 3.14159);

	// Calculate target yaw using sine wave (-1 to 1 range)
	local targetYaw = turret.m_eScanStartAngles.y + (sineValue * halfRange);

	// Smooth interpolation to prevent jarring movements
	local currentYaw = turret.m_hMachineGun.GetAngles().y;
	local yawDiff = targetYaw - currentYaw;

	// Normalize angle difference to handle 360-degree wraparound
	while (yawDiff > 180.0) yawDiff -= 360.0;
	while (yawDiff < -180.0) yawDiff += 360.0;

	// Apply smooth interpolation (reduced speed for smoother movement)
	local interpolationSpeed = 0.15; // Increased for faster movement
	local newYaw = currentYaw + (yawDiff * interpolationSpeed);

	// Apply the scanning rotation
	local newAngles = QAngle(turret.m_eScanStartAngles.x, newYaw, turret.m_eScanStartAngles.z);
	turret.m_hMachineGun.SetAngles(newAngles);
	turret.m_eCurrentAngles = newAngles;
}

// Function to stop scanning animation when target is found
function StopTurretScanning(turret)
{
	if (turret)
	{
		turret.m_bIsScanning = false;
		turret.m_flScanStartTime = 0.0;
	}
}

// Centralized entity cleanup function to prevent memory leaks
function CleanupTurretEntities(turret)
{
	if (!turret) return;

	// Clean up bipod entities
	if ("m_aBipod" in turret && turret.m_aBipod)
	{
		foreach (ent in turret.m_aBipod)
		{
			if (ent && ent.IsValid()) ent.Kill();
		}
	}

	// Clean up machine gun entity
	if ("m_hMachineGun" in turret && turret.m_hMachineGun && turret.m_hMachineGun.IsValid())
	{
		turret.m_hMachineGun.Kill();
	}

	// Clean up tracer entity
	if ("m_hTracerEntity" in turret && turret.m_hTracerEntity && turret.m_hTracerEntity.IsValid())
	{
		turret.m_hTracerEntity.Kill();
	}

	// Clean up laser sight entity
	if ("m_hLaserSight" in turret && turret.m_hLaserSight && turret.m_hLaserSight.IsValid())
	{
		turret.m_hLaserSight.Kill();
	}

	// Clear target reference
	if ("m_hTarget" in turret)
	{
		turret.m_hTarget = null;
	}
}

ButtonDelay <- 0

FireButton <- 1
JumpButton <- 2
DuckButton <- 4
ForwardButton <- 8
BackButton <- 16
UseButton <- 32
LeftButton <- 512
RightButton <- 1024
ShoveButton <- 2048
ReloadButton <- 8192
ScoreButton <- 65536
ZoomButton <- 524288

NickModel <- "models/survivors/survivor_gambler.mdl";
CoachModel <- "models/survivors/survivor_coach.mdl";
EllisModel <- "models/survivors/survivor_mechanic.mdl";
RochelleModel <- "models/survivors/survivor_producer.mdl";
BillModel <- "models/survivors/survivor_namvet.mdl";
LouisModel <- "models/survivors/survivor_manager.mdl";
FrancisModel <- "models/survivors/survivor_biker.mdl";
ZoeyModel <- "models/survivors/survivor_teenangst.mdl";

AlertIconWhite <- "icon_alert";
ForbiddenIcon <- "icon_no";
LampIcon <- "icon_tip";
GiftIcon <- "icon_upgrade";
TankIcon <- "tip_tank";
SurvivorIcon <- "Stat_vs_Most_Damage_Done";
SpecialIcon <- "Stat_Most_Special_Kills";
special_hint <-
{
	classname = "env_instructor_hint"
	hint_name = "special_hint"
	hint_caption = ""
	hint_auto_start = 0
	hint_target = ""
	hint_timeout = 5
	hint_static = 1
	hint_forcecaption = 1
	hint_icon_onscreen = ""
	hint_instance_type = 2
	hint_color = "255 255 255"
}

g_tWeaponReplacement <-
{
	[1] = {classname = "weapon_gnome", origin = Vector(0, 0, 2), angles = Vector(0, 0, 90), spawnflags = 1}
}

g_ConVar_TurretDamage <- CreateConVar("sv_turret_damage", eTurret.Damage, "float", 0);
g_ConVar_TurretAmmo <- CreateConVar("sv_turret_max_ammo", eTurret.MaxAmmo, "integer", 0);
g_ConVar_TurretRange <- CreateConVar("sv_turret_max_range", eTurret.MaxRange, "float", 0);
g_ConVar_TurretAngle <- CreateConVar("sv_turret_view_angle", eTurret.MaxAngle, "float", 0, 180);

function ReplaceWeaponSpawn(sWeaponClassname, sWeaponReplacement, sWeaponModel = null, vecAngles = null)
{
	if (sWeaponClassname == sWeaponReplacement) return printl("[ReplaceWeaponSpawn] Cannot replace the same entities");
	local iWeapons = 0;
	local function ReplaceWeapon(hWeapon)
	{
		local iCount, vecAng, iSpawnFlags;
		local vecOrigin = Vector();
		for (local i = 1; i <= g_tWeaponReplacement.len(); i++)
		{
			if (sWeaponReplacement == g_tWeaponReplacement[i].classname)
			{
				foreach (key, val in g_tWeaponReplacement[i])
				{
					switch (key)
					{
						case "origin":
						{
							vecOrigin = val;
							break;
						}
						case "angles":
						{
							vecAng = val;
							break;
						}
						case "spawnflags":
						{
							iSpawnFlags = val;
							break;
						}
						case "count":
						{
							iCount = val;
							break;
						}
					}
				}
				break;
			}
		}
		if (vecAngles == null) vecAngles = Vector(0, RandomFloat(0.0, 360.0), 0);
		local hSpawnTable =
		{
			origin = hWeapon.GetOrigin() + vecOrigin
			angles = (vecAng == null ? Vector(hWeapon.GetAngles().x, hWeapon.GetAngles().y, hWeapon.GetAngles().z) : vecAng) + vecAngles
			spawnflags = (iSpawnFlags == null ? (NetProps.HasProp(hWeapon, "m_spawnflags") ? NetProps.GetPropInt(hWeapon, "m_spawnflags") : 0) : iSpawnFlags)
			count = (iCount == null ? (NetProps.HasProp(hWeapon, "m_itemCount") ? NetProps.GetPropInt(hWeapon, "m_itemCount") : 1) : iCount)
		}
		SpawnEntityFromTable(sWeaponReplacement, hSpawnTable);
		hWeapon.Kill();
		iWeapons++;
	}
	for (local i = 1; i <= MAXENTS; i++)
	{
		local hWeapon = EntIndexToHScript(i);
		if (hWeapon != null)
		{
			if (sWeaponClassname == "weapon_spawn" && hWeapon.GetClassname() == "weapon_spawn")
			{
				if (sWeaponModel == null) ReplaceWeapon(hWeapon);
				else if (NetProps.HasProp(hWeapon, "m_ModelName") && NetProps.GetPropString(hWeapon, "m_ModelName") == sWeaponModel) ReplaceWeapon(hWeapon);
			}
			else if (hWeapon.GetClassname() == sWeaponClassname) ReplaceWeapon(hWeapon);
		}
	}
	if (iWeapons > 0) printf("[ReplaceWeaponSpawn] Replaced weapons with classname '%s': %d", sWeaponClassname, iWeapons);
}

function PrintTurretList()
{
	printl("~~~~~~~~~~~~~~~~~~~~~ g_aTurretList Array ~~~~~~~~~~~~~~~~~~~~~~");
	foreach (idx, turret in g_aTurretList)
	{
		printf("Turret #%d", idx + 1);
		printf("{");
		printf("\tIdentifier: %s", turret.m_sIdentifier);
		printf("\tOwner: %s", turret.m_hOwner.IsValid() ? turret.m_hOwner.GetPlayerName() : "invalid client");
		printf("\tAmmo: %d", turret.m_iAmmo);
		printf("\tAmmo Type: %s", turret.m_iDamageType == DMG_BURN ? "Incendiary" : turret.m_iDamageType == DMG_STUMBLE ? "Explosive" : "Default");
		printf("\tTracer Entity: " + (turret.m_hTracerEntity.IsValid() ? turret.m_hTracerEntity : "invalid entity"));
		printf("\tMachine Gun Entity: " + (turret.m_hMachineGun.IsValid() ? turret.m_hMachineGun : "invalid entity"));
		printf("\tNext Shoot Time: %.03f", turret.m_flNextShootTime);
		printf("\tNext Angle Change Time: %.03f", turret.m_flNextAnglesChangeTime);
		printf("\tDefault Yaw Angle: %.03f", turret.m_eDefaultAngles.y);
		printf("\tMachine Gun Mode: %s", turret.m_bMachineGunMode.tostring());
		printf("\tMachine Gun Ammo Array");
		printf("\t{");
		foreach (_idx, ammo in turret.m_aMachineGunAmmo)
		{
			if (_idx == 0) printf("\t\tClip: %d", ammo);
			else printf("\t\tAmmo: %d", ammo);
		}
		printf("\t}");
		printf("\tBipod Array");
		printf("\t{");
		foreach (_idx, bipod in turret.m_aBipod)
		{
			_idx++;
			printf("\t\tBipod #" + _idx + ": " + (bipod.IsValid() ? bipod : "invalid entity"));
		}
		printf("\t}");
		printf("}\n");
	}
	printl("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
}

function PlaceTurret(hPlayer, hWeapon)
{
	if (!hPlayer.IsDead() && !hPlayer.IsIncapacitated())
	{
		// Check server-wide turret count limit (8 total across all players)
		local iTotalTurretCount = g_aTurretList.len();
		if (iTotalTurretCount >= GnomeTurretMaxCount)
		{
			sayf("* Server turret limit reached (%d/%d). Remove existing turrets first.", iTotalTurretCount, GnomeTurretMaxCount);
			return;
		}
		local vecPos = DoTraceLine(hPlayer.EyePosition(), QAngle(0, hPlayer.EyeAngles().y, 0).Forward(), eTrace.Type_Pos, eTurret.MaxForwardDistance, eTrace.Mask_Shot, hPlayer);
		local vecPosGround = DoTraceLine(vecPos, Vector(0, 0, -1), eTrace.Type_Pos, eTurret.MaxDistanceToGround, eTrace.Mask_Shot, hPlayer);
		if ((hPlayer.EyePosition() - vecPos).LengthSqr() <= eTurret.MinForwardDistance * eTurret.MinForwardDistance) return;
		if ((vecPos - vecPosGround).LengthSqr() + 0.01 > eTurret.MaxDistanceToGround * eTurret.MaxDistanceToGround) return;
		if (g_bDebugMode)
		{
			Mark(vecPos, 3.0);
			Mark(vecPosGround, 3.0);
		}
		vecPos = vecPosGround;
		local aBipod = [];
		local iAmmo, iDamageType, sIdentifier, bMachineGunMode, aMachineGunAmmo;
		local eAngles = QAngle(0, hPlayer.EyeAngles().y, 0);
		local hTracerEntity = SpawnEntityFromTable("info_target", {
			origin = vecPos + Vector(0, 0, 55) // vecPos + Vector(0, 0, 55)
			angles = Vector(0, eAngles.y, 0)
		});
		local hMachineGun = SpawnEntityFromTable("prop_dynamic_override", {
			model = "models/w_models/weapons/w_sniper_military.mdl"
			origin = vecPos + Vector(0, 0, 42) // vecPos + Vector(0, 0, 42)
			angles = Vector(0, eAngles.y, 0)
			solid = 6
			disableshadows = 1
		});

		// Create laser sight entity (DISABLED - commented out for now)
		// local hLaserSight = SpawnEntityFromTable("env_laser", {
		// 	origin = vecPos + Vector(0, 0, 42)
		// 	angles = Vector(0, eAngles.y, 0)
		// 	LaserTarget = "!activator"
		// 	width = 2
		// 	NoiseAmplitude = 0
		// 	texture = "sprites/laserbeam.spr"
		// 	EndSprite = "sprites/redglow1.spr"
		// 	rendercolor = "255 0 0"
		// 	renderamt = 100
		// 	damage = 0
		// 	spawnflags = 1
		// });
		local hLaserSight = null; // Disabled laser sight
		local hTable = {
			origin = vecPos + Vector(0, 0, 41)
			angles = Vector(0.239000, -91.575996, 165.845993)
			model = "models/props_urban/wood_railing_post001.mdl"
			disableshadows = 1
			solid = 6
		}
		aBipod.push(SpawnEntityFromTable("prop_dynamic", hTable));
		hTable["angles"] = Vector(0.585000, -180.240997, 164.990005);
		aBipod.push(SpawnEntityFromTable("prop_dynamic", hTable));
		hTable["angles"] = Vector(-1.885000, 0.390000, 166.078995);
		aBipod.push(SpawnEntityFromTable("prop_dynamic", hTable));
		hTable["angles"] = Vector(0.142, 89.488, -193.972);
		aBipod.push(SpawnEntityFromTable("prop_dynamic", hTable));

		LoadSpecificConfigFile("gnome turret/virtual inventory/gnome virtual inventory.txt");

		if (CEntity(hWeapon).KeyInScriptScope("turret_scope"))
		{
			foreach (key, val in CEntity(hWeapon).GetScriptScopeVar("turret_scope"))
			{
				if (key == "ammo")
			{
				iAmmo = val;
			}
				else if (key == "damagetype") iDamageType = val;
				else if (key == "identifier") sIdentifier = val;
				else if (key == "mg_mode") bMachineGunMode = val;
				else if (key == "mg_ammo") aMachineGunAmmo = val;
			}
		}
		if (!iAmmo)
		{
			iAmmo = GnomeTurretAmmoBase;
		}
		if (!iDamageType)
			iDamageType = DMG_BULLET;
		if (!sIdentifier)
			sIdentifier = "__" + UniqueString() + "__";
		if (!bMachineGunMode)
			bMachineGunMode = false;
		if (!aMachineGunAmmo)
		{
			local iAmmo = 0;
			local iClip = eTurret.MaxClipSize;
			if (GetConVarInt(g_ConVar_TurretAmmo) < eTurret.MaxClipSize) iClip = GetConVarInt(g_ConVar_TurretAmmo);
			else iAmmo = GetConVarInt(g_ConVar_TurretAmmo) - eTurret.MaxClipSize;
			aMachineGunAmmo = [iClip, iAmmo];
		}
		local newTurret = CTurret(iAmmo, hTracerEntity, hMachineGun, eAngles, hPlayer, sIdentifier, iDamageType, aBipod, bMachineGunMode, aMachineGunAmmo);
		// Initialize new properties
		newTurret.m_hLaserSight = hLaserSight;
		newTurret.m_eCurrentAngles = eAngles;
		newTurret.m_eTargetAngles = eAngles;
		newTurret.m_flSettlingTime = 0.0;
		newTurret.m_flLastThinkTime = Time();
		newTurret.m_flLastFireTime = 0.0;
		newTurret.m_bIsRotating = false;
		newTurret.m_bCanFire = true;
		// Initialize scanning animation variables
		newTurret.m_bIsScanning = false;
		newTurret.m_flScanStartTime = 0.0;
		newTurret.m_flScanDirection = 1.0;
		newTurret.m_eScanStartAngles = eAngles;
		newTurret.m_flScanRange = eTurret.ScanRange;
		if (g_aTurretList.len() < 8) {
			g_aTurretList.push(newTurret);
			// Apply current config settings to the newly created turret
			ApplyConfigToNewTurret(newTurret);
		} else {
			// Remove created entities if limit reached
			foreach (ent in aBipod) if (ent.IsValid()) ent.Kill();
			if (hMachineGun.IsValid()) hMachineGun.Kill();
			if (hTracerEntity.IsValid()) hTracerEntity.Kill();
			if (hLaserSight && hLaserSight.IsValid()) hLaserSight.Kill();
			ShowSpecialHint(hPlayer, "Server turret limit of 8 reached!", ForbiddenIcon, 0.1, 3);
		}

		if (hWeapon.GetClassname() == eTurret.Weapon) hWeapon.Kill();
		if (g_bDebugMode) PrintTurretList();
		// DISABLED - Demolition config loading removed
		// if(CfgFileCheck("demolition gunners/demolition gunners cfg/explosion ammo cfg.txt"))
		// {
		//		LoadSpecificConfigFile("demolition gunners/demolition gunners cfg/explosion ammo cfg.txt");
		// }

		switch(RandomInt(0, 1))
		{
			case 0:
				EmitSoundOnClient("Moustachio_STRENGTHATTRACT_RANDOM", hPlayer);
				break;

			case 1:
				EmitSoundOnClient("Moustachio_STRENGTHATTRACT_RANDOMLAUGH", hPlayer);
				break;
		}



		ShowSpecialHint(hPlayer, ("Turret Ammo = " + iAmmo), LampIcon, 0.1, 3);

	}
}

function ToggleTurretMode(hPlayer)
{
	local hWeapon = hPlayer.GetActiveWeapon();
	if (hWeapon)
	{
		if (hWeapon.GetClassname() == eTurret.Weapon)
		{
			if (CEntity(hWeapon).KeyInScriptScope("turret_scope"))
			{
				local tParams = CEntity(hWeapon).GetScriptScopeVar("turret_scope");
				if (tParams["mg_mode"])
				{
					try {
				tParams["mg_ammo"][0] = NetProps.HasProp(hWeapon, "m_iClip1") ? NetProps.GetPropInt(hWeapon, "m_iClip1") : 0;
				local ammoType = NetProps.HasProp(hWeapon, "m_iPrimaryAmmoType") ? NetProps.GetPropInt(hWeapon, "m_iPrimaryAmmoType") : 0;
				tParams["mg_ammo"][1] = NetProps.HasProp(hPlayer, "m_iAmmo") ? NetProps.GetPropIntArray(hPlayer, "m_iAmmo", ammoType) : 0;
			} catch (e) {
				if (GnomeTurretDebugMode) {
					print("[Turret Debug] Failed to get weapon ammo properties: " + e.tostring() + "\n");
				}
				tParams["mg_ammo"][0] = 0;
				tParams["mg_ammo"][1] = 0;
			}
					CEntity(hWeapon).GetScriptScopeVar("turret_scope")["ammo"] = tParams["mg_ammo"][0] + tParams["mg_ammo"][1];
					EmitSoundOnClient("Buttons.snd11", hPlayer);
				}
				else
				{
					SetMachineGunAmmo(hPlayer, hWeapon, tParams["mg_ammo"][1], tParams["mg_ammo"][0]);
					try {
			if (NetProps.HasProp(hWeapon, "m_flNextPrimaryAttack")) {
				NetProps.SetPropFloat(hWeapon, "m_flNextPrimaryAttack", 0.0);
			}
		} catch (e) {
			if (GnomeTurretDebugMode) {
				print("[Turret Debug] Failed to set weapon attack time: " + e.tostring() + "\n");
			}
		}
					EmitSoundOnClient("EDIT_TOGGLE_PLACE_MODE", hPlayer);
				}
				tParams["mg_mode"] = !tParams["mg_mode"];
			}
			else
			{
				local iAmmo = 0;
				local iClip = eTurret.MaxClipSize;
				if (GetConVarInt(g_ConVar_TurretAmmo) < eTurret.MaxClipSize) iClip = GetConVarInt(g_ConVar_TurretAmmo);
				else iAmmo = GetConVarInt(g_ConVar_TurretAmmo) - eTurret.MaxClipSize;
				CEntity(hWeapon).SetScriptScopeVar("turret_scope", {
					ammo = GetConVarInt(g_ConVar_TurretAmmo)
					mg_ammo = [iClip, iAmmo]
					mg_mode = false
				});
				ToggleTurretMode(hPlayer);
			}
		}
	}

	// After loading all config settings, update existing turrets with proper damage types
	UpdateExistingTurretsFromConfig();
}

function ToggleDebugMode(hPlayer)
{
	if (hPlayer.IsHost())
	{
		if (g_bDebugMode) EmitSoundOnClient("Buttons.snd11", hPlayer);
		else EmitSoundOnClient("EDIT_TOGGLE_PLACE_MODE", hPlayer);
		g_bDebugMode = !g_bDebugMode;
	}
}

function ToggleGlobalDebugMode(hPlayer, sValue)
{
	if (!hPlayer || !hPlayer.IsValid())
		return;

	if (sValue == CC_EMPTY_ARGUMENT)
	{
		sayf("* Current global debug mode: %d (0=Off, 1=Detailed)", GnomeTurretDebugMode);
		if (GnomeTurretDebugMode == 1)
		{
			ShowDetailedDebugInfo(hPlayer);
		}
		return;
	}

	local iValue = sValue.tointeger();
	if (iValue < 0) iValue = 0;
	if (iValue > 1) iValue = 1;

	GnomeTurretDebugMode = iValue;
	SaveCurrentTurretSettings();
	GenerateGnomeVirtualInventory();
	sayf("* %s set global debug mode to %d (%s)", hPlayer.GetPlayerName(), iValue, iValue == 0 ? "Off" : "Detailed");

	if (iValue == 1)
	{
		sayf("[DEBUG] Enhanced debug mode enabled - detailed turret information will be displayed every %.1fs", GnomeTurretDebugInterval);
		ShowDetailedDebugInfo(hPlayer);
	}
	else
	{
		sayf("[DEBUG] Debug mode disabled");
	}
}

function SetDebugInterval(hPlayer, sValue)
{
	if (!hPlayer || !hPlayer.IsValid())
		return;

	if (sValue == CC_EMPTY_ARGUMENT)
	{
		sayf("* Current debug interval: %.1f seconds (Range: 0.5-10.0s)", GnomeTurretDebugInterval);
		return;
	}

	local fValue = sValue.tofloat();
	if (fValue < 0.5) fValue = 0.5;
	if (fValue > 10.0) fValue = 10.0;

	GnomeTurretDebugInterval = fValue;
	SaveCurrentTurretSettings();
	GenerateGnomeVirtualInventory();
	sayf("* %s set debug interval to %.1f seconds", hPlayer.GetPlayerName(), fValue);
}

function RemoveTurret(hPlayer, sValue)
{
	if (hPlayer.IsDead() || hPlayer.IsIncapacitated() || !g_bDebugMode) return;
	if (sValue == CC_EMPTY_ARGUMENT)
	{
		// Iterate in reverse to safely remove items
		for (local i = g_aTurretList.len() - 1; i >= 0; i--)
		{
			local turret = g_aTurretList[i];
			if (turret.m_hOwner == hPlayer)
			{
				CleanupTurretEntities(turret);
				g_aTurretList.remove(i);
				sayf("* %s removed a turret (Ammo: %d)", hPlayer.GetPlayerName(), turret.m_iAmmo);
				return;
			}
		}
		sayf("* You haven't a turret");
	}
	else if (split(sValue, " ")[0] == "all")
	{
		local bFound = false;
		// Iterate in reverse to safely remove items
		for (local i = g_aTurretList.len() - 1; i >= 0; i--)
		{
			local turret = g_aTurretList[i];
			if (turret.m_hOwner == hPlayer)
			{
				CleanupTurretEntities(turret);
				if (!bFound) bFound = true;
				g_aTurretList.remove(i);
			}
		}
		if (!bFound) sayf("* You haven't a turret");
		else sayf("* %s removed all turrets", hPlayer.GetPlayerName());
	}
}

function ChangeTurretAmmo(hPlayer, sValue)
{
	local bFound = false;
	if (sValue == CC_EMPTY_ARGUMENT)
	{
		local iCount = 0;
		foreach (idx, turret in g_aTurretList)
		{
			if (turret.m_hOwner == hPlayer)
			{
				bFound = true;
				break;
			}
		}
		if (bFound)
		{
			foreach (idx, turret in g_aTurretList)
			{
				if (turret.m_hOwner == hPlayer)
				{
					if (iCount == 0) sayf("* %s's Turret List:", hPlayer.GetPlayerName());
					sayf("Turret #%d - Ammo: %d %s", iCount, turret.m_iAmmo, turret.m_iDamageType == DMG_BURN ? "(Incendiary)" : turret.m_iDamageType == DMG_STUMBLE ? "(Explosive)" : "");
					iCount++;
				}
			}
		}
		else sayf("* You haven't a turret");
	}
	else
	{
		if (hPlayer.IsDead() || hPlayer.IsIncapacitated()) return;
		foreach (turret in g_aTurretList)
		{
			if (turret.m_hOwner == hPlayer)
			{
				bFound = true;
				break;
			}
		}
		if (bFound)
		{
			sValue = split(sValue, " ")[0];
			local bOnce = true;
			local bUpgrade = false;
			foreach (turret in g_aTurretList)
			{
				if (turret.m_hOwner == hPlayer)
				{
					if (sValue == "default")
					{
						if (turret.m_iDamageType != DMG_BULLET)
						{
							turret.SetDamageType(DMG_BULLET);
							if (bOnce)
							{
								bOnce = false;
								sayf("* You've installed default ammo on all turrets");
							}
						}
					}
					else if (sValue == "explosive")
					{
						if (turret.m_iDamageType != DMG_STUMBLE)
						{
							turret.SetDamageType(DMG_STUMBLE);
							if (bOnce)
							{
								bOnce = false;
								sayf("* You've installed explosive ammo on all turrets");
							}
						}
					}
					else if (sValue == "fire")
					{
						if (turret.m_iDamageType != DMG_BURN)
						{
							turret.SetDamageType(DMG_BURN);
							if (bOnce)
							{
								bOnce = false;
								sayf("* You've installed incendiary ammo on all turrets");
							}
						}
					}
				}
			}
		}
		else sayf("* You haven't a turret");
	}
}

function ChangeTurretBaseAmmo(hPlayer, sValue)
{
	if (sValue == CC_EMPTY_ARGUMENT)
	{
		sayf("* Current base turret ammo: %d", GnomeTurretAmmoBase);
		return;
	}

	local iNewAmmo = sValue.tointeger();
	if (iNewAmmo < 50) iNewAmmo = 50; // Minimum ammo limit

	// Update global base ammo
	GnomeTurretAmmoBase = iNewAmmo;

	// Update all individual player ammo variables
	GnomeTurretAmmoNick = iNewAmmo;
	GnomeTurretAmmoCoach = iNewAmmo;
	GnomeTurretAmmoEllis = iNewAmmo;
	GnomeTurretAmmoRochelle = iNewAmmo;
	GnomeTurretAmmoBill = iNewAmmo;
	GnomeTurretAmmoLouis = iNewAmmo;
	GnomeTurretAmmoFrancis = iNewAmmo;
	GnomeTurretAmmoZoey = iNewAmmo;

	// Update all existing turrets immediately
	foreach (turret in g_aTurretList)
	{
		turret.SetAmmo(iNewAmmo);
	}

	// Save to inventory file to maintain consistency
	GenerateGnomeVirtualInventory();

	sayf("* %s set global turret base ammo to %d (affects all turrets)", hPlayer.GetPlayerName(), iNewAmmo);
	ShowSpecialHint(hPlayer, ("Global Turret Ammo = " + iNewAmmo), LampIcon, 0.1, 3);
}

function SetMachineGunAmmo(hPlayer, hMachineGun, iAmmo, iClip)
{
	try {
		if (NetProps.HasProp(hMachineGun, "m_iClip1")) {
			NetProps.SetPropInt(hMachineGun, "m_iClip1", iClip);
		}
		if (NetProps.HasProp(hMachineGun, "m_iPrimaryAmmoType") && NetProps.HasProp(hPlayer, "m_iAmmo")) {
			local ammoType = NetProps.GetPropInt(hMachineGun, "m_iPrimaryAmmoType");
			NetProps.SetPropIntArray(hPlayer, "m_iAmmo", iAmmo, ammoType);
		}
	} catch (e) {
		if (GnomeTurretDebugMode) {
			print("[Turret Debug] Failed to set machine gun ammo: " + e.tostring() + "\n");
		}
	}
}

function ShowDetailedDebugInfo(hPlayer)
{
	local currentTime = Time();
	sayf("=== TURRET DEBUG INFORMATION ===");
	sayf("[ENGINE] Game Time: %.3f | Frame Time: %.3f", currentTime, FrameTime());
	sayf("[SYSTEM] Active Turrets: %d/%d | Think Rate: %dms | Fire Rate: %dms",
		g_aTurretList.len(), GnomeTurretMaxCount, GnomeTurretThinkRateMS, GnomeTurretFireRateMS);

	if (g_aTurretList.len() > 0)
	{
		sayf("=== INDIVIDUAL TURRET STATUS ===");
		foreach (idx, turret in g_aTurretList)
		{
			if (turret && turret.m_hMachineGun && turret.m_hMachineGun.IsValid())
			{
				local owner = turret.m_hOwner ? turret.m_hOwner.GetPlayerName() : "Unknown";
				local pos = turret.m_hMachineGun.GetOrigin();
				local angles = turret.m_hMachineGun.GetAngles();
				local timeSinceThink = currentTime - turret.m_flLastThinkTime;
				local timeSinceFire = currentTime - turret.m_flLastFireTime;

				sayf("[T%d] Owner: %s | Ammo: %d | Type: %s", idx, owner, turret.m_iAmmo,
				turret.m_iDamageType == DMG_BURN ? "Incendiary" :
				turret.m_iDamageType == DMG_STUMBLE ? "Explosive" :
				// turret.m_iDamageType == DMG_BLAST ? "Demolition" : // DISABLED - Demolition mode removed
				"Default");

				sayf("[T%d] Pos: (%.1f,%.1f,%.1f) | Angles: (%.1f,%.1f,%.1f)",
					idx, pos.x, pos.y, pos.z, angles.x, angles.y, angles.z);

				sayf("[T%d] CanFire: %s | Rotating: %s | ThinkDelta: %.3fs | FireDelta: %.3fs",
					idx, turret.m_bCanFire.tostring(), turret.m_bIsRotating.tostring(),
					timeSinceThink, timeSinceFire);

				if (turret.m_bIsRotating)
				{
					local currentAngles = turret.m_eCurrentAngles;
					local targetAngles = turret.m_eTargetAngles;
					sayf("[T%d] Current: (%.1f,%.1f,%.1f) | Target: (%.1f,%.1f,%.1f)",
						idx, currentAngles.x, currentAngles.y, currentAngles.z,
						targetAngles.x, targetAngles.y, targetAngles.z);
				}

				// Entity validation
				local entityStatus = "";
				if (turret.m_hTracerEntity && turret.m_hTracerEntity.IsValid())
					entityStatus += "Tracer:OK ";
				else
					entityStatus += "Tracer:INVALID ";

				if (turret.m_aBipod.len() > 0)
				{
					local validBipods = 0;
					foreach (bipod in turret.m_aBipod)
					{
						if (bipod && bipod.IsValid()) validBipods++;
					}
					entityStatus += format("Bipods:%d/%d ", validBipods, turret.m_aBipod.len());
				}

				sayf("[T%d] Entities: %s", idx, entityStatus);
			}
			else
			{
				sayf("[T%d] INVALID TURRET - Missing or invalid entities", idx);
			}
		}
	}

	// Performance and target information
	local targetCount = 0;
	local playerCount = 0;
	local infectedCount = 0;

	foreach (ent in g_aPotentialTargets)
	{
		if (ent && ent.IsValid())
		{
			targetCount++;
			if (ent.IsPlayer()) playerCount++;
			else infectedCount++;
		}
	}

	sayf("[TARGETS] Total: %d | Players: %d | Infected: %d", targetCount, playerCount, infectedCount);
	sayf("[CONFIG] Range: %.0f | Damage: %d | Rotation: %.1f | AimMode: %s",
		GnomeTurretRange, GnomeTurretDamage, GnomeTurretRotationSpeed,
		GnomeTurretAimMode == 0 ? "Aimbot" : "Realistic");
	sayf("=================================");
}

function TurretShoot(hMachineGun, targetPosition = null)
{
	local hShell = SpawnEntityFromTable("info_particle_system", {
		effect_name = eTurret.Shell
		start_active = 1
	});
	local hShootFire = SpawnEntityFromTable("info_particle_system", {
		effect_name = eTurret.MuzzleFlash
		angles = Vector(hMachineGun.GetAngles().x, hMachineGun.GetAngles().y, hMachineGun.GetAngles().z)
		start_active = 1
	});
	// Create smoke trail effect
	local hSmokeTrail = SpawnEntityFromTable("info_particle_system", {
		effect_name = eTurret.SmokeTrail
		angles = Vector(hMachineGun.GetAngles().x, hMachineGun.GetAngles().y, hMachineGun.GetAngles().z)
		start_active = 1
	});
	// Create heavy smoke effect
	// local hHeavySmoke = SpawnEntityFromTable("info_particle_system", {
	//	effect_name = eTurret.HeavySmoke
	//	angles = Vector(hMachineGun.GetAngles().x, hMachineGun.GetAngles().y, hMachineGun.GetAngles().z)
	//	start_active = 1
	// });  // Heavy smoke effect (disabled for testing)
	// Create sparks effect (disabled for testing)
	// local hSparks = SpawnEntityFromTable("info_particle_system", {
	//	effect_name = eTurret.Sparks
	//	angles = Vector(hMachineGun.GetAngles().x, hMachineGun.GetAngles().y, hMachineGun.GetAngles().z)
	//	start_active = 1
	// });
	// Create barrel heat effect (disabled for testing)
	// local hBarrelHeat = SpawnEntityFromTable("info_particle_system", {
	//	effect_name = eTurret.BarrelHeat
	//	angles = Vector(hMachineGun.GetAngles().x, hMachineGun.GetAngles().y, hMachineGun.GetAngles().z)
	//	start_active = 1
	// });
	// Create gunpowder smoke effect (disabled for testing)
	// local hGunpowderSmoke = SpawnEntityFromTable("info_particle_system", {
	//	effect_name = eTurret.GunpowderSmoke
	//	angles = Vector(hMachineGun.GetAngles().x, hMachineGun.GetAngles().y, hMachineGun.GetAngles().z)
	//	start_active = 1
	// });
	// Create extra smoke effect
	local hExtraSmoke = SpawnEntityFromTable("info_particle_system", {
		effect_name = eTurret.ExtraSmoke
		angles = Vector(hMachineGun.GetAngles().x, hMachineGun.GetAngles().y, hMachineGun.GetAngles().z)
		start_active = 1
	});
	// Create enhanced muzzle effects
	// local hMuzzleFlash50Cal = SpawnEntityFromTable("info_particle_system", {
	//	effect_name = eTurret.MuzzleFlash50Cal
	//	angles = Vector(hMachineGun.GetAngles().x, hMachineGun.GetAngles().y, hMachineGun.GetAngles().z)
	//	start_active = 1
	// });  // Heavy 50cal muzzle flash (disabled for testing)
	// local hMuzzleFlashMinigun = SpawnEntityFromTable("info_particle_system", {
	//	effect_name = eTurret.MuzzleFlashMinigun
	//	angles = Vector(hMachineGun.GetAngles().x, hMachineGun.GetAngles().y, hMachineGun.GetAngles().z)
	//	start_active = 1
	// });  // Minigun style flash (disabled for testing)
	// local hMuzzleFlashSparks = SpawnEntityFromTable("info_particle_system", {
	//	effect_name = eTurret.MuzzleFlashSparks
	//	angles = Vector(hMachineGun.GetAngles().x, hMachineGun.GetAngles().y, hMachineGun.GetAngles().z)
	//	start_active = 1
	// });  // Muzzle sparks (disabled for testing)
	local hMuzzleSmokeLong = SpawnEntityFromTable("info_particle_system", {
		effect_name = eTurret.MuzzleSmokeLong
		angles = Vector(hMachineGun.GetAngles().x, hMachineGun.GetAngles().y, hMachineGun.GetAngles().z)
		start_active = 1
	});
	local hMuzzleFlashSmokeSmall = SpawnEntityFromTable("info_particle_system", {
		effect_name = eTurret.MuzzleFlashSmokeSmall
		angles = Vector(hMachineGun.GetAngles().x, hMachineGun.GetAngles().y, hMachineGun.GetAngles().z)
		start_active = 1
	});
	// Create dynamic muzzle flash light
	local hMuzzleLight = SpawnEntityFromTable("light_dynamic", {
		_light = "255 200 100 200"  // Bright orange-yellow light
		brightness = 3
		distance = 150
		style = 0  // Normal light
		spawnflags = 1  // Start on
	});
	local vecPos = hMachineGun.GetOrigin() + hMachineGun.GetAngles().Up() * 4 + hMachineGun.GetAngles().Forward() * 38;

	// Create bullet tracer effect if target position is provided
	local hBulletTracer = null;
	if (targetPosition != null)
	{
		// Create a unique target name for the tracer end point
		local targetName = "tracer_target_" + RandomInt(1000, 9999) + "_" + Time().tointeger();

		// Create a target entity for the tracer end point
		local hTracerTarget = SpawnEntityFromTable("info_target", {
			targetname = targetName
			origin = targetPosition
			spawnflags = 1  // Transmit to client
		});

		// Create the bullet tracer with proper control points
		hBulletTracer = SpawnEntityFromTable("info_particle_system", {
			effect_name = eTurret.BulletTracer
			origin = vecPos
			cpoint1 = targetName  // Link to target entity by name
			start_active = 1
		});

		// Schedule target entity for cleanup
		AcceptEntityInput(hTracerTarget, "Kill", "", 0.4);
	}

	CEntity(hMachineGun).AttachEntity(hShell, "Shell");
	hShootFire.SetOrigin(vecPos);
	hSmokeTrail.SetOrigin(vecPos);
	// hHeavySmoke.SetOrigin(vecPos);  // Heavy smoke origin (disabled for testing)
	// hSparks.SetOrigin(vecPos);  // Disabled for testing
	// hBarrelHeat.SetOrigin(vecPos);  // Barrel heat origin (disabled for testing)
	// hGunpowderSmoke.SetOrigin(vecPos);  // Gunpowder smoke origin (disabled for testing)
	hExtraSmoke.SetOrigin(vecPos);
	// hMuzzleFlash50Cal.SetOrigin(vecPos);  // Heavy 50cal flash origin (disabled for testing)
	// hMuzzleFlashMinigun.SetOrigin(vecPos);  // Minigun flash origin (disabled for testing)
	// hMuzzleFlashSparks.SetOrigin(vecPos);  // Muzzle sparks origin (disabled for testing)
	hMuzzleSmokeLong.SetOrigin(vecPos);
	hMuzzleFlashSmokeSmall.SetOrigin(vecPos);
	hMuzzleLight.SetOrigin(vecPos);
	AcceptEntityInput(hShell, "Kill", "", 0.05);
	AcceptEntityInput(hShootFire, "Kill", "", 0.05);
	AcceptEntityInput(hSmokeTrail, "Kill", "", 1.5);  // Smoke lasts longer than muzzle flash
	// AcceptEntityInput(hHeavySmoke, "Kill", "", 2.5);  // Heavy smoke lasts even longer (disabled for testing)
	// AcceptEntityInput(hSparks, "Kill", "", 0.3);  // Sparks last briefly (disabled for testing)
	// AcceptEntityInput(hBarrelHeat, "Kill", "", 0.1);  // Barrel heat flash is quick (disabled for testing)
	// AcceptEntityInput(hGunpowderSmoke, "Kill", "", 2.0);  // Gunpowder smoke lingers (disabled for testing)
	AcceptEntityInput(hExtraSmoke, "Kill", "", 1.8);  // Extra smoke effect
	// AcceptEntityInput(hMuzzleFlash50Cal, "Kill", "", 0.08);  // Heavy 50cal flash (disabled for testing)
	// AcceptEntityInput(hMuzzleFlashMinigun, "Kill", "", 0.06);  // Minigun flash (disabled for testing)
	// AcceptEntityInput(hMuzzleFlashSparks, "Kill", "", 0.4);  // Muzzle sparks (disabled for testing)
	AcceptEntityInput(hMuzzleSmokeLong, "Kill", "", 3.0);  // Long lasting smoke
	AcceptEntityInput(hMuzzleFlashSmokeSmall, "Kill", "", 1.2);  // Small smoke puffs
	AcceptEntityInput(hMuzzleLight, "Kill", "", 0.05);  // Same duration as muzzle flash
	if (hBulletTracer != null) AcceptEntityInput(hBulletTracer, "Kill", "", 0.3);  // Bullet tracer duration
	if (g_bDebugMode) Mark(vecPos, 3.0);
}

function TurretShootFakeImpact(turret, hEntity, vecPos)
{
	local sEffect;
	if (turret.m_iDamageType == DMG_BULLET) sEffect = eTurret.ImpactDefault;
	else if (turret.m_iDamageType == DMG_BURN) sEffect = eTurret.ImpactIncendiary;
	else if (turret.m_iDamageType == DMG_STUMBLE) sEffect = (hEntity.IsPlayer() ? eTurret.ImpactExplosiveExtra : eTurret.ImpactExplosive);
	local hParticle = SpawnEntityFromTable("info_particle_system", {
		effect_name = sEffect
		origin = vecPos
		start_active = 1
	});
	AcceptEntityInput(hParticle, "Kill", "", 0.05);
	if (g_bDebugMode)
	{
		local hMachineGun = turret.m_hMachineGun;
		Mark(vecPos, 3.0);
		Line(hMachineGun.GetOrigin() + hMachineGun.GetAngles().Up() * 4 + hMachineGun.GetAngles().Forward() * 38, vecPos, 3.0);
	}
}

function IsCanSeeEntity(hTracerEntity, hTarget, hIgnoreEntity, vecPos)
{
	local hEntity = DoTraceLine(hTracerEntity.GetOrigin(), (vecPos - hTracerEntity.GetOrigin()).Normalize(), eTrace.Type_Hit, GetConVarFloat(g_ConVar_TurretRange), eTrace.Mask_Shot, hIgnoreEntity);
	if (hEntity)
	{
		if (hEntity == hTarget || hEntity.GetRootMoveParent() == hTarget) return true;
		if (hEntity.IsPlayer()) if (hEntity.IsSurvivor()) if (hEntity.IsAttackedBySI()) if (hEntity.GetSIAttacker() == hTarget) return true;
	}
	return false;
}

function GetEntityPosition(hEntity, sClass)
{
	// Check if entity is valid before attempting to get position
	if (hEntity == null || !hEntity.IsValid())
	{
		if (GnomeTurretDebugMode)
		{
			print("Warning: Entity is null or invalid in GetEntityPosition\n");
		}
		return null;
	}

	// Initialize position as null
	local vecPos = null;

	try
	{
		// Handle different entity types
		if (sClass == "player")
		{
				// Extra validation for player entities
			if (!hEntity.IsValid() || hEntity.GetHealth() <= 0 || hEntity.IsDead())
			{
				if (GnomeTurretDebugMode)
				{
					print("Warning: Player entity is invalid or dead in GetEntityPosition\n");
				}
				return null;
			}

			// Check for spectator mode or ghost state (for dead special infected)
			try {
				local observerMode = NetProps.HasProp(hEntity, "m_iObserverMode") ? NetProps.GetPropInt(hEntity, "m_iObserverMode") : 0;
				local isGhost = NetProps.HasProp(hEntity, "m_isGhost") ? NetProps.GetPropInt(hEntity, "m_isGhost") : 0;
				if (observerMode != 0 || isGhost != 0)
				{
					if (GnomeTurretDebugMode)
					{
						print("Warning: Player entity is in spectator mode or ghost state\n");
					}
					return null;
				}
			} catch (e) {
				if (GnomeTurretDebugMode)
				{
					print("Warning: NetProps access failed for observer/ghost check: " + e + "\n");
				}
				return null;
			}

			local iType = hEntity.GetZombieType();
			if (iType != ZOMBIE_TANK)
			{
				if (iType == ZOMBIE_SMOKER) vecPos = hEntity.GetBodyPosition(0.95);
				else if (iType == ZOMBIE_BOOMER) vecPos = hEntity.GetBodyPosition(0.8);
				else if (iType == ZOMBIE_HUNTER) vecPos = hEntity.GetBodyPosition(0.7);
				else if (iType == ZOMBIE_SPITTER) vecPos = hEntity.GetBodyPosition(0.9);
				else if (iType == ZOMBIE_CHARGER)
					{
					// Safely check if charger is charging with error handling
					try {
						local customAbility = NetProps.HasProp(hEntity, "m_customAbility") ? NetProps.GetPropEntity(hEntity, "m_customAbility") : null;
						local isCharging = false;
						if (customAbility && customAbility.IsValid() && NetProps.HasProp(customAbility, "m_isCharging"))
						{
							isCharging = NetProps.GetPropInt(customAbility, "m_isCharging") != 0;
						}
						if (isCharging)
						{
							vecPos = hEntity.GetBodyPosition(0.75);
						}
						else
						{
							vecPos = hEntity.GetBodyPosition(0.85);
						}
					} catch (e) {
						if (GnomeTurretDebugMode)
						{
							print("Warning: NetProps access failed for charger ability check: " + e + "\n");
						}
						vecPos = hEntity.GetBodyPosition(0.85); // Safe fallback
					}
				}
				else if (iType == ZOMBIE_JOCKEY)
				{
					try {
						local jockeyVictim = NetProps.HasProp(hEntity, "m_jockeyVictim") ? NetProps.GetPropEntity(hEntity, "m_jockeyVictim") : null;
						if (jockeyVictim && jockeyVictim.IsValid()) vecPos = hEntity.GetBodyPosition(1.3);
						else vecPos = hEntity.GetBodyPosition(0.5);
					} catch (e) {
						if (GnomeTurretDebugMode)
						{
							print("Warning: NetProps access failed for jockey victim check: " + e + "\n");
						}
						vecPos = hEntity.GetBodyPosition(0.5); // Safe fallback
					}
				}
				else
				{
					// Default for other special infected
					vecPos = hEntity.GetBodyPosition(0.7);
				}
			}
			else
			{
				// Tank
				vecPos = hEntity.GetBodyPosition(0.8);
			}
		}
		else if (sClass == "infected" || sClass == "witch")
		{
			// Extra validation for infected/witch entities
			if (!hEntity.IsValid() || hEntity.GetHealth() <= 0)
			{
				if (GnomeTurretDebugMode)
				{
					print("Warning: " + sClass + " entity is invalid or dead in GetEntityPosition\n");
				}
				return null;
			}

			if (CEntity(hEntity).KeyInScriptScope("trace_hull"))
			{
				local traceHull = CEntity(hEntity).GetScriptScopeVar("trace_hull");
				if (traceHull != null && traceHull.IsValid()) {
					vecPos = VectorLerp(hEntity.GetOrigin(), traceHull.GetOrigin(), 0.8);
				} else {
					if (GnomeTurretDebugMode)
					{
						print("Warning: trace_hull is null or invalid in GetEntityPosition\n");
					}
					vecPos = hEntity.GetOrigin(); // Fallback to entity origin
				}
			}
			else
			{
				// Fallback for infected/witch without trace_hull
				vecPos = hEntity.GetOrigin();
			}
		}
		else
		{
			// Default fallback for other entity types
			vecPos = hEntity.GetOrigin();
		}
	}
	catch (error)
	{
		if (GnomeTurretDebugMode)
		{
			print("Error in GetEntityPosition: " + error + "\n");
		}
		return null;
	}

	// Final validation check
	if (vecPos == null)
	{
		if (GnomeTurretDebugMode)
		{
			print("Warning: Failed to get position for entity in GetEntityPosition\n");
		}
		return null;
	}

	// Verify the position is valid (not NaN or infinite)
	if (vecPos.x != vecPos.x || vecPos.y != vecPos.y || vecPos.z != vecPos.z ||
		fabs(vecPos.x) >= 16384 || fabs(vecPos.y) >= 16384 || fabs(vecPos.z) >= 16384)
	{
		if (GnomeTurretDebugMode)
		{
			print("Warning: Invalid position values detected in GetEntityPosition\n");
		}
		return null;
	}

	return vecPos;
}

function GetNearestEntity(hTracerEntity, hMachineGun)
{
	local length = g_aPotentialTargets.len();
	local flDistanceSqr = GetConVarFloat(g_ConVar_TurretRange) * GetConVarFloat(g_ConVar_TurretRange);
	local hEntity = null;
	local vecPos = null;
	local hTarget = null;
	local vecPosTemp = null;
	local flDistanceSqrTemp = 0;

	// Early return if no potential targets
	if (length == 0)
	{
		if (ShouldShowDebugMessage())
	{
		print("GetNearestEntity: No potential targets available\n");
	}
		return { target = null, position = null };
	}

	if (ShouldShowDebugMessage())
	{
		print("GetNearestEntity: Searching through " + length + " potential targets\n");
	}

	// Use reverse iteration to safely remove elements during iteration
	for (local idx = length - 1; idx >= 0; idx--)
	{
		try
		{
			// Get entity from potential targets (reverse iteration is safe)
			hEntity = g_aPotentialTargets[idx];
			if (hEntity && hEntity.IsValid())
			{
				// Validate entity health and status
				if (hEntity.IsPlayer())
				{
					// Comprehensive validation for special infected
					// Safe NetProps access with try-catch
					local observerMode = 0;
					local isGhost = 0;
					try {
						if (NetProps.HasProp(hEntity, "m_iObserverMode"))
							observerMode = NetProps.GetPropInt(hEntity, "m_iObserverMode");
						if (NetProps.HasProp(hEntity, "m_isGhost"))
							isGhost = NetProps.GetPropInt(hEntity, "m_isGhost");
					} catch (e) {
						// NetProps access failed, assume safe defaults
					}
					if (hEntity.IsIncapacitated() ||
					    hEntity.GetHealth() < 1 ||
					    hEntity.IsDead() ||
					    observerMode != 0 ||
					    isGhost != 0)
					{
						if (ShouldShowDebugMessage())
				{
					print("GetNearestEntity: Removing invalid player: Type=" + hEntity.GetZombieType() +
					      " IsDead=" + hEntity.IsDead() +
					      " Health=" + hEntity.GetHealth() +
					      " ObserverMode=" + observerMode +
					      " IsGhost=" + isGhost + "\n");
				}
						g_aPotentialTargets.remove(idx);
						continue;
					}
				}
				else if (hEntity.GetHealth() < 1)
				{
					if (ShouldShowDebugMessage())
				{
					print("GetNearestEntity: Removing dead entity: " + hEntity.GetClassname() + "\n");
				}
					g_aPotentialTargets.remove(idx);
					continue;
				}

				// Check distance
				flDistanceSqrTemp = (hEntity.GetOrigin() - hTracerEntity.GetOrigin()).LengthSqr();
				if (flDistanceSqrTemp < flDistanceSqr)
				{
					// Get entity position
					vecPosTemp = GetEntityPosition(hEntity, hEntity.GetClassname());
					if (hEntity && hEntity.IsValid() && vecPosTemp)
					{
						// Check angle and visibility
						if (GetAngleBetweenEntities(hTracerEntity, hEntity) <= GetConVarFloat(g_ConVar_TurretAngle))
						{
							if (IsCanSeeEntity(hTracerEntity, hEntity, hMachineGun, vecPosTemp))
							{
								flDistanceSqr = flDistanceSqrTemp;
								hTarget = hEntity;
								vecPos = vecPosTemp;

								if (ShouldShowDebugMessage())
					{
						print("GetNearestEntity: Found valid target " + hEntity.GetClassname() + " at distance " + sqrt(flDistanceSqrTemp) + "\n");
					}
							}
							else if (ShouldShowDebugMessage())
				{
					print("GetNearestEntity: Cannot see entity " + hEntity.GetClassname() + "\n");
				}
						}
						else if (ShouldShowDebugMessage())
				{
					print("GetNearestEntity: Entity " + hEntity.GetClassname() + " outside of angle limit\n");
				}
					}
					else if (ShouldShowDebugMessage())
			{
				print("GetNearestEntity: Failed to get position for " + hEntity.GetClassname() + "\n");
			}
				}
				else if (ShouldShowDebugMessage())
		{
			print("GetNearestEntity: Entity " + hEntity.GetClassname() + " outside of range\n");
		}
			}
			else
			{
				// Remove invalid entity
				if (ShouldShowDebugMessage())
			{
				print("GetNearestEntity: Removing invalid entity at index " + idx + "\n");
			}
				g_aPotentialTargets.remove(idx);
				continue;
			}
		}
		catch (error)
		{
			if (ShouldShowDebugMessage())
		{
			print("Error in GetNearestEntity: " + error + "\n");
		}

			// Remove invalid entity
			g_aPotentialTargets.remove(idx);
			continue;
		}
	}

	// Return result with proper null checks
	if (hTarget == null || vecPos == null)
	{
		if (ShouldShowDebugMessage())
	{
		print("GetNearestEntity: No valid target found within range and angle\n");
	}
	}
	else if (ShouldShowDebugMessage())
	{
		print("GetNearestEntity: Returning target " + hTarget.GetClassname() + " with position " + vecPos + "\n");
	}

	return {
		target = hTarget,
		position = vecPos
	};
}

function OnAttackPress(hPlayer)
{
	if (!hPlayer.IsDead() && !IsPlayerABot(hPlayer) && !hPlayer.IsIncapacitated())
	{
		local hWeapon = hPlayer.GetActiveWeapon();
		if (hWeapon)
		{
			if (hWeapon.GetClassname() == eTurret.Weapon)
			{
				if (CEntity(hWeapon).KeyInScriptScope("turret_scope")) if (CEntity(hWeapon).GetScriptScopeVar("turret_scope")["mg_mode"]) return;
				PlaceTurret(hPlayer, hWeapon);

			}
		}
	}
}

function OnUsePress(hPlayer)
{
	local flMaxRadiusUseSqr = eTurret.MaxRadiusUse * eTurret.MaxRadiusUse;
	if (!hPlayer.IsDead() && !IsPlayerABot(hPlayer) && !hPlayer.IsIncapacitated())
	{
		foreach (turret in g_aTurretList)
		{
			if (turret.m_hMachineGun && turret.m_hMachineGun.IsValid() && CEntity(hPlayer).GetDistance(turret.m_hMachineGun, true) <= flMaxRadiusUseSqr && turret.m_iAmmo >= 0)
			{
				if (GetAngleBetweenEntities(hPlayer, turret.m_hMachineGun, Vector(0, 0, -10)) <= eTurret.MaxAngleUse)
				{
					local hWeapon = hPlayer.GetActiveWeapon();
					local tScope = {
						ammo = turret.m_iAmmo
						damagetype = turret.m_iDamageType
						identifier = turret.m_sIdentifier
						mg_mode = turret.m_bMachineGunMode
						mg_ammo = turret.m_aMachineGunAmmo
					}
					foreach (idx, _turret in g_aTurretList)
					{
						if (_turret.m_sIdentifier == turret.m_sIdentifier)
						{
							if(RandomInt(0,100) <= 100)
							{
								if(IsCertainSurvivor(hPlayer, NickModel))
								{
									GnomeTurretAmmoNick = turret.m_iAmmo;
								}
								else if(IsCertainSurvivor(hPlayer, CoachModel))
								{
									GnomeTurretAmmoCoach = turret.m_iAmmo;
								}
								else if(IsCertainSurvivor(hPlayer, EllisModel))
								{
									GnomeTurretAmmoEllis = turret.m_iAmmo;
								}
								else if(IsCertainSurvivor(hPlayer, RochelleModel))
								{
									GnomeTurretAmmoRochelle = turret.m_iAmmo;
								}
								else if(IsCertainSurvivor(hPlayer, BillModel))
								{
									GnomeTurretAmmoBill = turret.m_iAmmo;
								}
								else if(IsCertainSurvivor(hPlayer, LouisModel))
								{
									GnomeTurretAmmoLouis = turret.m_iAmmo;
								}
								else if(IsCertainSurvivor(hPlayer, FrancisModel))
								{
									GnomeTurretAmmoFrancis = turret.m_iAmmo;
								}
								else if(IsCertainSurvivor(hPlayer, ZoeyModel))
								{
									GnomeTurretAmmoZoey = turret.m_iAmmo;
								}

							}
							GenerateGnomeVirtualInventory();

							foreach (ent in turret.m_aBipod) if (ent.IsValid()) ent.Kill();
							if (turret.m_hMachineGun.IsValid()) turret.m_hMachineGun.Kill();
							if (turret.m_hTracerEntity.IsValid()) turret.m_hTracerEntity.Kill();
							g_aTurretList.remove(idx);
							break;
						}
					}
					if (hWeapon)
					{
						if (hWeapon.GetClassname() == eTurret.Weapon)
						{
							hPlayer.GiveItem("rifle");
							hWeapon = hPlayer.GetActiveWeapon();
							hWeapon.Kill();
						}
					}
					hPlayer.GiveItem(eTurret.Weapon);
					hWeapon = hPlayer.GetActiveWeapon();

					CEntity(hWeapon).SetScriptScopeVar("turret_scope", tScope);

					ShowSpecialHint(hPlayer, ("Turret Ammo = " + turret.m_iAmmo), LampIcon, 0.1, 2);

				}
			}
		}
	}
}

function Turret_Think()
{
	local currentTime = Time();
	local hPlayer, hWeapon, iAmmo;
	while (hPlayer = Entities.FindByClassname(hPlayer, "player"))
	{
		if (!hPlayer.IsDead() && !IsPlayerABot(hPlayer) && !hPlayer.IsIncapacitated())
		{
			hWeapon = hPlayer.GetActiveWeapon();
			if (hWeapon)
			{
				if (hWeapon.GetClassname() == eTurret.Weapon)
				{
					if (CEntity(hWeapon).KeyInScriptScope("turret_scope"))
					{
						if (CEntity(hWeapon).GetScriptScopeVar("turret_scope")["mg_mode"])
					{
						try {
							local currentClip = NetProps.HasProp(hWeapon, "m_iClip1") ? NetProps.GetPropInt(hWeapon, "m_iClip1") : 0;
							if (currentClip == 1)
							{
								local ammoType = NetProps.HasProp(hWeapon, "m_iPrimaryAmmoType") ? NetProps.GetPropInt(hWeapon, "m_iPrimaryAmmoType") : 0;
								local currentAmmo = NetProps.HasProp(hPlayer, "m_iAmmo") ? NetProps.GetPropIntArray(hPlayer, "m_iAmmo", ammoType) : 0;
								if (currentAmmo > 0 && NetProps.HasProp(hWeapon, "m_iClip1"))
								{
									NetProps.SetPropInt(hWeapon, "m_iClip1", 0);
								}
							}
						} catch (e) {
							if (GnomeTurretDebugMode) {
								print("[Turret Debug] Failed to manage MG mode weapon: " + e.tostring() + "\n");
							}
						}
						continue;
					}
						try {
						iAmmo = CEntity(hWeapon).GetScriptScopeVar("turret_scope")["ammo"];
						local currentClip = NetProps.HasProp(hWeapon, "m_iClip1") ? NetProps.GetPropInt(hWeapon, "m_iClip1") : 0;
						local ammoType = NetProps.HasProp(hWeapon, "m_iPrimaryAmmoType") ? NetProps.GetPropInt(hWeapon, "m_iPrimaryAmmoType") : 0;
						local currentAmmo = NetProps.HasProp(hPlayer, "m_iAmmo") ? NetProps.GetPropIntArray(hPlayer, "m_iAmmo", ammoType) : 0;
						if (currentClip != 1 || currentAmmo != iAmmo)
							SetMachineGunAmmo(hPlayer, hWeapon, iAmmo, 1);
					} catch (e) {
						if (GnomeTurretDebugMode) {
							print("[Turret Debug] Failed to manage scoped weapon ammo: " + e.tostring() + "\n");
						}
					}
				}
				else {
					try {
						local currentClip = NetProps.HasProp(hWeapon, "m_iClip1") ? NetProps.GetPropInt(hWeapon, "m_iClip1") : 0;
						local ammoType = NetProps.HasProp(hWeapon, "m_iPrimaryAmmoType") ? NetProps.GetPropInt(hWeapon, "m_iPrimaryAmmoType") : 0;
						local currentAmmo = NetProps.HasProp(hPlayer, "m_iAmmo") ? NetProps.GetPropIntArray(hPlayer, "m_iAmmo", ammoType) : 0;
						if (currentClip != 1 || currentAmmo != GetConVarInt(g_ConVar_TurretAmmo))
							SetMachineGunAmmo(hPlayer, hWeapon, GetConVarInt(g_ConVar_TurretAmmo), 1);
					} catch (e) {
						if (GnomeTurretDebugMode) {
							print("[Turret Debug] Failed to manage default weapon ammo: " + e.tostring() + "\n");
						}
					}
				}
				try {
					local nextAttack = NetProps.HasProp(hWeapon, "m_flNextPrimaryAttack") ? NetProps.GetPropFloat(hWeapon, "m_flNextPrimaryAttack") : 0.0;
					if (nextAttack < Time() + 5.0 && NetProps.HasProp(hWeapon, "m_flNextPrimaryAttack")) {
						NetProps.SetPropFloat(hWeapon, "m_flNextPrimaryAttack", Time() + (1 << 10));
					}
				} catch (e) {
					if (GnomeTurretDebugMode) {
						print("[Turret Debug] Failed to set weapon attack time: " + e.tostring() + "\n");
					}
				}
				}
			}
		}
	}
	if (g_aTurretList.len() > 0)
	{
		local hEntity, hMachineGun, sClass, bInvalidTurret, turret, trace_hull_ent, tbl;
		for (local i = 0; i < g_aTurretList.len(); i++)
		{
			bInvalidTurret = false;
			turret = g_aTurretList[i];
			foreach (ent in turret.m_aBipod)
			{
				if (!ent.IsValid())
				{
					bInvalidTurret = true;
					break;
				}
			}
			if (!turret.m_hMachineGun.IsValid())
			{
				bInvalidTurret = true;
				break;
			}
			if (!turret.m_hTracerEntity.IsValid())
			{
				bInvalidTurret = true;
				break;
			}
			if (bInvalidTurret)
			{
				foreach (ent in turret.m_aBipod) if (ent.IsValid()) ent.Kill();
				if (turret.m_hMachineGun.IsValid()) turret.m_hMachineGun.Kill();
				if (turret.m_hTracerEntity.IsValid()) turret.m_hTracerEntity.Kill();
				g_aTurretList.remove(i);
				i--;
			}
			else if (turret.m_iAmmo > 0)
			{
				if (g_flFindPotentialTargetsTime < Time())
					{
						g_aPotentialTargets.clear();
					g_flFindPotentialTargetsTime = Time() + 0.1;
					local playerLoopCounter = 0;
					local maxPlayerIterations = 100; // Safety limit
					while (hEntity = Entities.FindByClassname(hEntity, "player"))
					{
						if(++playerLoopCounter > maxPlayerIterations)
						{
							printl("Warning: Player finding loop exceeded maximum iterations");
							break;
						}
						// Only include non-survivor, non-incapacitated, non-observer, non-ghost players with health > 0
					// Safe NetProps access
					local observerMode = 0;
					local isGhost = 0;
					try {
						if (NetProps.HasProp(hEntity, "m_iObserverMode"))
							observerMode = NetProps.GetPropInt(hEntity, "m_iObserverMode");
						if (NetProps.HasProp(hEntity, "m_isGhost"))
							isGhost = NetProps.GetPropInt(hEntity, "m_isGhost");
					} catch (e) {
						// NetProps access failed, assume safe defaults
					}
					if (!hEntity.IsSurvivor() &&
					    !hEntity.IsIncapacitated() &&
					    !hEntity.IsDead() &&
					    hEntity.GetHealth() > 0 &&
					    observerMode == 0 &&
					    isGhost == 0)
						{
							if (ShouldShowDebugMessage())
				{
					print("Adding player to potential targets: " + hEntity.GetZombieType() + "\n");
				}
							g_aPotentialTargets.push(hEntity);
						}
							else if (ShouldShowDebugMessage() && !hEntity.IsSurvivor())
			{
				// Debug info for rejected special infected
				print("Rejected special infected: Type=" + hEntity.GetZombieType() +
				      " IsDead=" + hEntity.IsDead() +
				      " Health=" + hEntity.GetHealth() +
				      " ObserverMode=" + observerMode +
				      " IsGhost=" + isGhost + "\n");
			}
					}
					local infectedLoopCounter = 0;
					local maxInfectedIterations = 200; // Higher limit for infected
					while (hEntity = Entities.FindByClassname(hEntity, "infected"))
					{
						if(++infectedLoopCounter > maxInfectedIterations)
						{
							printl("Warning: Infected finding loop exceeded maximum iterations");
							break;
						}
						try {
							local movetype = NetProps.HasProp(hEntity, "movetype") ? NetProps.GetPropInt(hEntity, "movetype") : MOVETYPE_NONE;
							if (hEntity.IsValid() && hEntity.GetHealth() > 0 && movetype != MOVETYPE_NONE)
							{
								if (!CEntity(hEntity).KeyInScriptScope("trace_hull"))
								{
									trace_hull_ent = SpawnEntityFromTable("info_target", {});
									CEntity(hEntity).AttachEntity(trace_hull_ent, "head");
									CEntity(hEntity).SetScriptScopeVar("trace_hull", trace_hull_ent);
								}
								g_aPotentialTargets.push(hEntity);
							}
						} catch (e) {
							if (ShouldShowDebugMessage())
			{
				print("Warning: NetProps access failed for infected: " + e + "\n");
			}
						}
					}
					local witchLoopCounter = 0;
					local maxWitchIterations = 50; // Lower limit for witches
					while (hEntity = Entities.FindByClassname(hEntity, "witch"))
					{
						if(++witchLoopCounter > maxWitchIterations)
						{
							printl("Warning: Witch finding loop exceeded maximum iterations");
							break;
						}
						try {
							local rage = NetProps.HasProp(hEntity, "m_rage") ? NetProps.GetPropFloat(hEntity, "m_rage") : 0.0;
							if (hEntity.GetHealth() > 0 && rage >= 1.0)
							{
								if (!CEntity(hEntity).KeyInScriptScope("trace_hull"))
								{
									trace_hull_ent = SpawnEntityFromTable("info_target", {});
									CEntity(hEntity).AttachEntity(trace_hull_ent, "leye");
									CEntity(hEntity).SetScriptScopeVar("trace_hull", trace_hull_ent);
								}
								g_aPotentialTargets.push(hEntity);
							}
						} catch (e) {
							if (ShouldShowDebugMessage())
			{
				print("Warning: NetProps access failed for witch: " + e + "\n");
			}
						}
					}
				}
				// Check if enough time has passed for this turret's think cycle
				local currentTime = Time();
				// Safety check to prevent division by zero
			local thinkInterval = (GnomeTurretThinkRateMS > 0) ? (GnomeTurretThinkRateMS / 1000.0) : 0.1;
			if (currentTime - turret.m_flLastThinkTime >= thinkInterval)
				{
					turret.m_flLastThinkTime = currentTime;

					// Check if current target is still valid and alive
					local targetValid = false;
					local targetPos = null;

					if (turret.m_hTarget && turret.m_hTarget.IsValid()) {
					// Extra validation for special infected
					if (turret.m_hTarget.GetClassname() == "player" && turret.m_hTarget.GetZombieType() != 0) {
						// Special infected require stricter validation
						local observerMode = 0;
					local isGhost = 0;
					try {
						if (NetProps.HasProp(turret.m_hTarget, "m_iObserverMode")) {
							observerMode = NetProps.GetPropInt(turret.m_hTarget, "m_iObserverMode");
						}
						if (NetProps.HasProp(turret.m_hTarget, "m_isGhost")) {
							isGhost = NetProps.GetPropInt(turret.m_hTarget, "m_isGhost");
						}
					} catch (e) {
						if (GnomeTurretDebugMode) {
							sayf("[Turret Debug] Failed to access NetProps for target validation: %s", e.tostring());
						}
					}
					if (turret.m_hTarget.GetHealth() > 0 &&
					    !turret.m_hTarget.IsDead() &&
					    observerMode == 0 &&
					    isGhost == 0) {
							targetPos = GetEntityPosition(turret.m_hTarget, turret.m_hTarget.GetClassname());
							if (targetPos) {
								targetValid = true;
							} else if (ShouldShowDebugMessage()) {
							sayf("[Turret Debug] Special infected target exists but position is invalid");
						}
					} else if (ShouldShowDebugMessage()) {
					sayf("[Turret Debug] Special infected target invalid - Health: %d, IsDead: %s, ObserverMode: %d, IsGhost: %d",
					     turret.m_hTarget.GetHealth(),
					     turret.m_hTarget.IsDead().tostring(),
					     observerMode,
					     isGhost);
					}
					}
						// Standard validation for other entities
						else if (turret.m_hTarget.GetHealth() > 0) {
							targetPos = GetEntityPosition(turret.m_hTarget, turret.m_hTarget.GetClassname());
							if (targetPos) {
								targetValid = true;
							} else if (ShouldShowDebugMessage()) {
								sayf("[Turret Debug] Target exists but position is invalid");
							}
						} else if (ShouldShowDebugMessage()) {
							sayf("[Turret Debug] Target has no health");
						}
					} else if (ShouldShowDebugMessage() && turret.m_hTarget) {
						sayf("[Turret Debug] Target is invalid");
					}

					if (targetValid) {
						// Stick with current valid target
						tbl = { target = turret.m_hTarget, position = targetPos };
						if (ShouldShowDebugMessage()) {
							sayf("[Turret Debug] Sticking to current target: %s at position (%f, %f, %f)",
								turret.m_hTarget.GetClassname(), targetPos.x, targetPos.y, targetPos.z);
						}
					} else {
						// Target is invalid, dead, or position couldn't be determined
					// Clear current target and find a new one
					turret.m_hTarget = null;
					// Reset rotation and firing state to prevent shooting at invalid targets
					turret.m_bIsRotating = false;
					turret.m_bCanFire = false;
					if (ShouldShowDebugMessage()) {
						sayf("[Turret Debug] Target eliminated or invalid, finding new target");
					}
					tbl = GetNearestEntity(turret.m_hTracerEntity, turret.m_hMachineGun);
					turret.m_hTarget = tbl["target"];
					// Double-check the new target for spectator mode or ghost state
					if (turret.m_hTarget && turret.m_hTarget.IsPlayer() && turret.m_hTarget.GetZombieType() != 0) {
						local newTargetObserverMode = 0;
						local newTargetIsGhost = 0;
						try {
							if (NetProps.HasProp(turret.m_hTarget, "m_iObserverMode")) {
								newTargetObserverMode = NetProps.GetPropInt(turret.m_hTarget, "m_iObserverMode");
							}
							if (NetProps.HasProp(turret.m_hTarget, "m_isGhost")) {
								newTargetIsGhost = NetProps.GetPropInt(turret.m_hTarget, "m_isGhost");
							}
						} catch (e) {
							if (ShouldShowDebugMessage()) {
								sayf("[Turret Debug] Failed to access NetProps for new target validation: %s", e.tostring());
							}
						}
						if (newTargetObserverMode != 0 || newTargetIsGhost != 0) {
							if (ShouldShowDebugMessage()) {
								sayf("[Turret Debug] New target is in spectator mode or ghost state, rejecting");
							}
							turret.m_hTarget = null;
						}
					}
					}
					if (ShouldShowDebugMessage() && g_aPotentialTargets.len() > 0)
					{
						sayf("[Turret Debug] Found %d potential targets", g_aPotentialTargets.len());
					}
					if (tbl["target"] && tbl["position"])
				{
					// Stop scanning animation when target is found
					StopTurretScanning(turret);

					if (ShouldShowDebugMessage())
					{
						sayf("[Turret Debug] Target acquired: %s at position (%f, %f, %f)",
							tbl["target"].GetClassname(), tbl["position"].x, tbl["position"].y, tbl["position"].z);
					}
					hMachineGun = turret.m_hMachineGun;
						local targetPos = tbl["position"];
						local targetAngles = VectorToQAngle(targetPos - hMachineGun.GetOrigin());

						// Update laser sight to point at target (DISABLED)
						// if (turret.m_hLaserSight && turret.m_hLaserSight.IsValid())
						// {
						// 	turret.m_hLaserSight.SetOrigin(hMachineGun.GetOrigin() + hMachineGun.GetAngles().Forward() * 38);
						// 	turret.m_hLaserSight.SetAngles(targetAngles);
						// }

						// Implement aiming mode
						if (GnomeTurretAimMode == 0)
						{
							// Aimbot mode - instant perfect aim
							hMachineGun.SetAngles(targetAngles);
							turret.m_eCurrentAngles = targetAngles;
							turret.m_bCanFire = true;
						}
						else
						{
							// Realistic aiming mode
							// Stop scanning when target is acquired
							StopTurretScanning(turret);

							// Update current angles to match actual turret position if transitioning from scanning
							if (!turret.m_eCurrentAngles || turret.m_eCurrentAngles == null)
							{
								turret.m_eCurrentAngles = hMachineGun.GetAngles();
							}

							turret.m_eTargetAngles = targetAngles;
							local angleDiff = GetAngleBetweenVectors(turret.m_eCurrentAngles.Forward(), targetAngles.Forward());

							if (angleDiff > 2.0) // If target is not close enough
								{
									turret.m_bIsRotating = true;
									turret.m_bCanFire = false;
									// Settling time equals think rate (1:1 ratio)
									local settlingDelay = (GnomeTurretThinkRateMS > 0) ? (GnomeTurretThinkRateMS / 1000.0) : 0.1;
									turret.m_flSettlingTime = currentTime + settlingDelay;

								// Smooth rotation towards target (increased speed for better responsiveness)
							// Safety check to prevent division by zero or invalid rotation speed
							local rotationSpeed = (GnomeTurretRotationSpeed > 0) ? (GnomeTurretRotationSpeed / 100.0) : 0.01;
								local newAngles = QAngle(
									turret.m_eCurrentAngles.x + (targetAngles.x - turret.m_eCurrentAngles.x) * rotationSpeed,
									turret.m_eCurrentAngles.y + (targetAngles.y - turret.m_eCurrentAngles.y) * rotationSpeed,
									turret.m_eCurrentAngles.z + (targetAngles.z - turret.m_eCurrentAngles.z) * rotationSpeed
								);
								turret.m_eCurrentAngles = newAngles;
								hMachineGun.SetAngles(newAngles);
							}
							else
							{
								turret.m_bIsRotating = false;
								if (currentTime >= turret.m_flSettlingTime)
								{
									turret.m_bCanFire = true;
								}
							}
						}

						// Check if turret can fire
				if (ShouldShowDebugMessage())
				{
					local targetName = tbl["target"] ? tbl["target"].GetClassname() : "None";
					local targetPos = tbl["target"] ? tbl["target"].GetOrigin() : Vector(0,0,0);
					local distance = tbl["target"] ? (turret.m_hTracerEntity.GetOrigin() - targetPos).Length() : 0;

					sayf("[T%d-THINK] Target: %s | Dist: %.1f | CanFire: %s | FireEnabled: %s",
						g_aTurretList.find(turret), targetName, distance,
						turret.m_bCanFire.tostring(), GnomeTurretFireEnabled.tostring());

					local fireInterval = (GnomeTurretFireRateMS > 0) ? (GnomeTurretFireRateMS / 1000.0) : 0.1;
					sayf("[T%d-TIMING] TimeSinceLastFire: %.3fs | Required: %.3fs | Ready: %s",
						g_aTurretList.find(turret), (currentTime - turret.m_flLastFireTime),
						fireInterval,
						((currentTime - turret.m_flLastFireTime) >= fireInterval).tostring());

					if (turret.m_bIsRotating)
					{
						local angleDiff = GetAngleBetweenVectors(turret.m_eCurrentAngles.Forward(), turret.m_eTargetAngles.Forward());
						sayf("[T%d-AIM] Rotating | AngleDiff: %.2f° | SettlingTime: %.3fs",
							g_aTurretList.find(turret), angleDiff,
							turret.m_flSettlingTime ? (turret.m_flSettlingTime - currentTime) : 0);
					}
				}
				// Safety check for fire rate calculation
			local fireRateInterval = (GnomeTurretFireRateMS > 0) ? (GnomeTurretFireRateMS / 1000.0) : 0.1;
			if (turret.m_bCanFire && GnomeTurretFireEnabled && (currentTime - turret.m_flLastFireTime >= fireRateInterval))
				{
					if (ShouldShowDebugMessage())
					{
						local targetHealth = "Unknown";
						if (tbl["target"].IsPlayer())
						{
							targetHealth = format("%d/%d", tbl["target"].GetHealth(), tbl["target"].GetMaxHealth());
						}
						else if (NetProps.HasProp(tbl["target"], "m_iHealth"))
						{
							try {
								targetHealth = NetProps.GetPropInt(tbl["target"], "m_iHealth").tostring();
							} catch (e) {
								if (ShouldShowDebugMessage()) {
									sayf("[Turret Debug] Failed to get target health: %s", e.tostring());
								}
								targetHealth = "Error";
							}
						}

						sayf("[T%d-FIRE] SHOOTING %s | Health: %s | Damage: %d | Type: %s",
							g_aTurretList.find(turret), tbl["target"].GetClassname(), targetHealth,
							GnomeTurretDamage,
							turret.m_iDamageType == DMG_BURN ? "Incendiary" :
							turret.m_iDamageType == DMG_BLAST ? "Explosive" :
							turret.m_iDamageType == DMG_STUMBLE ? "Demolition" : "Default");
					}
							turret.m_flLastFireTime = currentTime;

							// Apply damage based on target type and settings
							if (tbl["target"] && tbl["target"].IsValid())
							{
								if (tbl["target"].GetClassname() == "witch")
						{
							// if (GnomeTurretDemolitionMode) // DISABLED - Demolition removed
							// {
							//		tbl["target"].TakeDamage(GnomeTurretDamage, 64, turret.m_hOwner);
							// }
							// else
							// {
								tbl["target"].TakeDamage(GnomeTurretDamage, turret.m_iDamageType, turret.m_hOwner);
							// }
						}
								else
								{
									tbl["target"].TakeDamage(GnomeTurretDamage, turret.m_iDamageType, turret.m_hOwner);
								}
							}

							// Apply burning effect for incendiary ammo
							if (turret.m_iDamageType == DMG_BURN && tbl["target"] && tbl["target"].IsValid())
							{
								CEntity(tbl["target"]).Ignite(turret.m_hOwner, 5.0);
							}

							// Visual and audio effects
						TurretShoot(hMachineGun, tbl["position"]);
						TurretShootFakeImpact(turret, tbl["target"], tbl["position"]);
							EmitSound(turret.m_hTracerEntity.GetOrigin(), eTurret.ShootSound);

							// Update ammo
					turret.SetAmmo(turret.m_iAmmo - 1);
					if (turret.m_aMachineGunAmmo[0] > 0) turret.SetMachineGunAmmo([turret.m_aMachineGunAmmo[0] - 1, turret.m_aMachineGunAmmo[1]]);
					else if (turret.m_aMachineGunAmmo[1] > 0) turret.SetMachineGunAmmo([0, turret.m_aMachineGunAmmo[1] - 1]);

					if (ShouldShowDebugMessage())
					{
						sayf("[T%d-AMMO] Remaining: %d | MG Ammo: [%d,%d] | Shot Complete",
							g_aTurretList.find(turret), turret.m_iAmmo,
							turret.m_aMachineGunAmmo[0], turret.m_aMachineGunAmmo[1]);
					}

							// Safely access camera angles array
					local entityIndex = hMachineGun.GetEntityIndex();
					if (entityIndex >= 0 && entityIndex < g_bAllowChangeCameraAngles.len() && g_bAllowChangeCameraAngles[entityIndex])
					{
						g_bAllowChangeCameraAngles[entityIndex] = false;
					}
					else if (GnomeTurretDebugMode && (entityIndex < 0 || entityIndex >= g_bAllowChangeCameraAngles.len()))
					{
						sayf("[Turret Debug] Invalid entity index for camera angles reset: %d (array size: %d)", entityIndex, g_bAllowChangeCameraAngles.len());
					}

							// Explosive effects
			if (GnomeTurretExplosiveMode && tbl["target"] && tbl["target"].IsValid()) // Removed demolition mode
			{
				NetProps.SetPropEntity(ExplosionEntity, "m_hOwnerEntity", turret.m_hOwner);
				ExplosionEntity.SetOrigin(tbl["target"].GetOrigin());
				DoEntFire("!self", "Explode", "", 0, turret.m_hOwner, ExplosionEntity);

				if (tbl["target"].GetClassname() == "player")
				{
					if (tbl["target"].GetZombieType() <= 8)
					{
						tbl["target"].Stagger(Vector(RandomInt(10,30), RandomInt(10,30), 0));
					}
				}
			}

							TurretDataSaveTimer = Time();
					}

				}
				else
				{
					// No valid target or position found
					// Ensure all turret states are reset
					turret.m_bCanFire = false;
					turret.m_bIsRotating = false;
					turret.m_hTarget = null;

					if (ShouldShowDebugMessage())
				{
					if (tbl["target"] && !tbl["position"])
						{
							sayf("[Turret Debug] Target found but position is invalid: %s", tbl["target"].GetClassname());
							if (tbl["target"].GetClassname() == "player" && tbl["target"].GetZombieType() != 0) {
							local debugObserverMode = 0;
							local debugIsGhost = 0;
							try {
								if (NetProps.HasProp(tbl["target"], "m_iObserverMode")) {
									debugObserverMode = NetProps.GetPropInt(tbl["target"], "m_iObserverMode");
								}
								if (NetProps.HasProp(tbl["target"], "m_isGhost")) {
									debugIsGhost = NetProps.GetPropInt(tbl["target"], "m_isGhost");
								}
							} catch (e) {
								if (ShouldShowDebugMessage()) {
									sayf("[Turret Debug] Failed to access NetProps for debug info: %s", e.tostring());
								}
							}
							sayf("[Turret Debug] Special infected target with invalid position - Type: %d, Health: %d, IsDead: %s, ObserverMode: %d, IsGhost: %d",
								tbl["target"].GetZombieType(),
								tbl["target"].GetHealth(),
								tbl["target"].IsDead().tostring(),
								debugObserverMode,
								debugIsGhost);
							}
						}
					else
					{
						sayf("[Turret Debug] No valid target found");
					}
				}

					if (ShouldShowDebugMessage())
					{
						if (tbl["target"] && !tbl["position"])
						{
							sayf("[T%d-IDLE] Target found but position is invalid | Scanning...",
								g_aTurretList.find(turret));
						}
						else
						{
							sayf("[T%d-IDLE] No valid target found | Range: %.0f | Potential targets: %d | Scanning...",
								g_aTurretList.find(turret), GnomeTurretRange, g_aPotentialTargets.len());
						}
					}
				}

				// Handle idle scanning animation when no target is found
				if (turret.m_flNextShootTime + eTurret.IdleTime < Time())
				{
					// Start or continue scanning animation
					UpdateTurretScanningAnimation(turret);

					// Safely access camera angles array with bounds checking
					local entityIndex = turret.m_hMachineGun.GetEntityIndex();
					if (entityIndex >= 0 && entityIndex < g_bAllowChangeCameraAngles.len())
					{
						g_bAllowChangeCameraAngles[entityIndex] = true;
					}
					else if (ShouldShowDebugMessage())
					{
						sayf("[Turret Debug] Invalid entity index for camera angles: %d (array size: %d)", entityIndex, g_bAllowChangeCameraAngles.len());
					}
				}
			}
		}
			if(Time() == TurretDataSaveTimer + 0.5)
			{
				if(RandomInt(0,100) <= 100)
				{
					if(IsCertainSurvivor(turret.m_hOwner, NickModel))
					{
						GnomeTurretAmmoNick = turret.m_iAmmo;
					}
					else if(IsCertainSurvivor(turret.m_hOwner, CoachModel))
					{
						GnomeTurretAmmoCoach = turret.m_iAmmo;
					}
					else if(IsCertainSurvivor(turret.m_hOwner, EllisModel))
					{
						GnomeTurretAmmoEllis = turret.m_iAmmo;
					}
					else if(IsCertainSurvivor(turret.m_hOwner, RochelleModel))
					{
						GnomeTurretAmmoRochelle = turret.m_iAmmo;
					}
					else if(IsCertainSurvivor(turret.m_hOwner, BillModel))
					{
						GnomeTurretAmmoBill = turret.m_iAmmo;
					}
					else if(IsCertainSurvivor(turret.m_hOwner, LouisModel))
					{
						GnomeTurretAmmoLouis = turret.m_iAmmo;
					}
					else if(IsCertainSurvivor(turret.m_hOwner, FrancisModel))
					{
						GnomeTurretAmmoFrancis = turret.m_iAmmo;
					}
					else if(IsCertainSurvivor(turret.m_hOwner, ZoeyModel))
					{
						GnomeTurretAmmoZoey = turret.m_iAmmo;
					}

				}
				GenerateGnomeVirtualInventory();
			}
			if (turret.m_iAmmo <= 0)
			{
				if (ShouldShowDebugMessage())
			{
				sayf("[T%d-AMMO] OUT OF AMMO - Removing turret | Owner: %s",
					g_aTurretList.find(turret),
					turret.m_hOwner ? turret.m_hOwner.GetPlayerName() : "Unknown");
			}

				// Find and remove the current turret safely
				local currentTurretIndex = g_aTurretList.find(turret);
				if (currentTurretIndex != null)
				{
					// Play sound and show message
					switch(RandomInt(0, 1))
					{
						case 0:
							EmitSoundOnClient("Moustachio_STRENGTHATTRACT_RANDOM", turret.m_hOwner);
							break;
						case 1:
							EmitSoundOnClient("Moustachio_STRENGTHATTRACT_RANDOMLAUGH", turret.m_hOwner);
							break;
					}
					ShowSpecialHint(turret.m_hOwner, "GNOME: 'My mission to protect you is done. See you again, hooman...!'", AlertIconWhite, 0.1, 5);

					// Clean up turret entities
					foreach (ent in turret.m_aBipod) if (ent.IsValid()) ent.Kill();
					if (turret.m_hMachineGun.IsValid()) turret.m_hMachineGun.Kill();
					if (turret.m_hTracerEntity.IsValid()) turret.m_hTracerEntity.Kill();

					// Remove from list and break to avoid further processing
					g_aTurretList.remove(currentTurretIndex);
					break;
				}
			}
		}
	}
}

function OnGameplayStart_PostSpawn()
{
	ReplaceWeaponSpawn("weapon_upgradepack_incendiary_spawn", "weapon_gnome");

}

// Chat command functions for new turret features
function SetTurretThinkRate(hPlayer, sValue)
{
	if (!hPlayer || !hPlayer.IsValid() || hPlayer.IsDead() || hPlayer.IsIncapacitated())
		return;

	if (sValue == CC_EMPTY_ARGUMENT)
	{
		sayf("* Current turret think rate: %dms (Range: 75-250ms)", GnomeTurretThinkRateMS);
		return;
	}

	local iValue = sValue.tointeger();
	if (iValue < 75) iValue = 75;
	if (iValue > 250) iValue = 250;

	GnomeTurretThinkRateMS = iValue;
	SaveCurrentTurretSettings();
	GenerateGnomeVirtualInventory();
	sayf("* %s set turret think rate to %dms", hPlayer.GetPlayerName(), iValue);
}

function SetTurretFireRate(hPlayer, sValue)
{
	if (!hPlayer || !hPlayer.IsValid() || hPlayer.IsDead() || hPlayer.IsIncapacitated())
		return;

	if (sValue == CC_EMPTY_ARGUMENT)
	{
		sayf("* Current turret fire rate: %dms (Range: 75-250ms)", GnomeTurretFireRateMS);
		return;
	}

	local iValue = sValue.tointeger();
	if (iValue < 75) iValue = 75;
	if (iValue > 250) iValue = 250;

	GnomeTurretFireRateMS = iValue;
	SaveCurrentTurretSettings();
	GenerateGnomeVirtualInventory();
	sayf("* %s set turret fire rate to %dms per shot", hPlayer.GetPlayerName(), iValue);
}

function SetTurretAimMode(hPlayer, sValue)
{
	if (!hPlayer || !hPlayer.IsValid() || hPlayer.IsDead() || hPlayer.IsIncapacitated())
		return;

	if (sValue == CC_EMPTY_ARGUMENT)
	{
		sayf("* Current aim mode: %d (0=Aimbot, 1=Realistic)", GnomeTurretAimMode);
		return;
	}

	local iValue = sValue.tointeger();
	if (iValue < 0) iValue = 0;
	if (iValue > 1) iValue = 1;

	GnomeTurretAimMode = iValue;
	SaveCurrentTurretSettings();
	GenerateGnomeVirtualInventory();
	sayf("* %s set aim mode to %d (%s)", hPlayer.GetPlayerName(), iValue, iValue == 0 ? "Aimbot" : "Realistic");
}

function SetTurretType(hPlayer, sValue)
{
	if (!hPlayer || !hPlayer.IsValid() || hPlayer.IsDead() || hPlayer.IsIncapacitated())
		return;

	if (sValue == CC_EMPTY_ARGUMENT)
	{
		sayf("* Current turret type: %d (0=Default, 1=Incendiary, 2=Explosive)",
			(GnomeTurretExplosiveMode ? 2 : (GnomeTurretFireEnabled ? 1 : 0)));
		return;
	}

	local iValue = sValue.tointeger();
	if (iValue < 0) iValue = 0;
	if (iValue > 2) iValue = 2; // Limit to types 0-2 only

	// Reset all modes first
	// GnomeTurretDemolitionMode = 0; // DISABLED - Demolition mode removed
	GnomeTurretExplosiveMode = 0;
	GnomeTurretFireEnabled = 1;

	// Set the selected mode
	if (iValue == 1) {
		// Incendiary mode - already enabled by default
	} else if (iValue == 2) {
		GnomeTurretExplosiveMode = 1;
	} else {
		// Default mode (0) - vanilla turret with normal bullets, fire enabled
		// GnomeTurretFireEnabled remains 1 (enabled by default above)
	}

	// Update all existing turrets
	foreach (turret in g_aTurretList)
	{
		if (turret && turret.m_hMachineGun && turret.m_hMachineGun.IsValid())
		{
			if (iValue == 0) turret.SetDamageType(DMG_BULLET);
			else if (iValue == 1) turret.SetDamageType(DMG_BURN);
			else if (iValue == 2) turret.SetDamageType(DMG_STUMBLE);
			// else if (iValue == 3) turret.SetDamageType(DMG_BLAST); // DISABLED - Demolition removed
		}
	}

	SaveCurrentTurretSettings();
	GenerateGnomeVirtualInventory();
	local sTypeName = ["Default Vanilla", "Incendiary Fire", "Explosive Stagger"][iValue]; // Removed demolition
	sayf("* %s set turret type to %d (%s)", hPlayer.GetPlayerName(), iValue, sTypeName);
}

function SetTurretDamage(hPlayer, sValue)
{
	if (!hPlayer || !hPlayer.IsValid() || hPlayer.IsDead() || hPlayer.IsIncapacitated())
		return;

	if (sValue == CC_EMPTY_ARGUMENT)
	{
		sayf("* Current turret damage: %d (Range: 1-1000)", GnomeTurretDamage);
		return;
	}

	local iValue = sValue.tointeger();
	if (iValue < 1) iValue = 1;
	if (iValue > 1000) iValue = 1000;

	GnomeTurretDamage = iValue;
	SaveCurrentTurretSettings();
	GenerateGnomeVirtualInventory();
	sayf("* %s set turret damage to %d per shot", hPlayer.GetPlayerName(), iValue);
}

function SetTurretRotationSpeed(hPlayer, sValue)
{
	if (!hPlayer || !hPlayer.IsValid() || hPlayer.IsDead() || hPlayer.IsIncapacitated())
		return;

	if (sValue == CC_EMPTY_ARGUMENT)
	{
		sayf("* Current turret rotation speed: %.1f (Range: 45-359, affects realistic aim mode only)", GnomeTurretRotationSpeed);
		return;
	}

	local fValue = sValue.tofloat();
	if (fValue < 45.0) fValue = 45.0;
	if (fValue > 359.0) fValue = 359.0;

	GnomeTurretRotationSpeed = fValue;
	SaveCurrentTurretSettings();
	GenerateGnomeVirtualInventory();
	sayf("* %s set turret rotation speed to %.1f degrees/sec", hPlayer.GetPlayerName(), fValue);
}

// DISABLED - Demolition mode removed
/*
function SetTurretDemolition(hPlayer, sValue)
{
	if (!hPlayer || !hPlayer.IsValid() || hPlayer.IsDead() || hPlayer.IsIncapacitated())
		return;

	if (sValue == CC_EMPTY_ARGUMENT)
	{
		// sayf("* Current demolition mode: %d (0=Off, 1=On)", GnomeTurretDemolitionMode); // DISABLED - Demolition removed
		return;
	}

	local iValue = sValue.tointeger();
	if (iValue < 0) iValue = 0;
	if (iValue > 1) iValue = 1;

	// GnomeTurretDemolitionMode = iValue; // DISABLED - Demolition removed

	// Update all existing turrets immediately
	foreach (turret in g_aTurretList)
	{
		if (turret && turret.m_hMachineGun && turret.m_hMachineGun.IsValid())
		{
			if (iValue == 1) turret.SetDamageType(DMG_STUMBLE); // Changed from DMG_BLAST (demolition) to DMG_STUMBLE (explosive)
		}
	}

	SaveCurrentTurretSettings();
	GenerateGnomeVirtualInventory();
	sayf("* %s set demolition mode to %d (%s)", hPlayer.GetPlayerName(), iValue, iValue == 0 ? "Off" : "On");
}
*/

function SetTurretExplosive(hPlayer, sValue)
{
	if (!hPlayer || !hPlayer.IsValid() || hPlayer.IsDead() || hPlayer.IsIncapacitated())
		return;

	if (sValue == CC_EMPTY_ARGUMENT)
	{
		sayf("* Current explosive mode: %d (0=Off, 1=On)", GnomeTurretExplosiveMode);
		return;
	}

	local iValue = sValue.tointeger();
	if (iValue < 0) iValue = 0;
	if (iValue > 1) iValue = 1;

	GnomeTurretExplosiveMode = iValue;

	// Update all existing turrets immediately
	foreach (turret in g_aTurretList)
	{
		if (turret && turret.m_hMachineGun && turret.m_hMachineGun.IsValid())
		{
			if (iValue == 1) turret.SetDamageType(DMG_STUMBLE);
		}
	}

	SaveCurrentTurretSettings();
	GenerateGnomeVirtualInventory();
	sayf("* %s set explosive mode to %d (%s)", hPlayer.GetPlayerName(), iValue, iValue == 0 ? "Off" : "On");
}

function SetTurretFire(hPlayer, sValue)
{
	if (!hPlayer || !hPlayer.IsValid() || hPlayer.IsDead() || hPlayer.IsIncapacitated())
		return;

	if (sValue == CC_EMPTY_ARGUMENT)
	{
		sayf("* Current fire enabled: %d (0=Disabled, 1=Enabled)", GnomeTurretFireEnabled);
		return;
	}

	local iValue = sValue.tointeger();
	if (iValue < 0) iValue = 0;
	if (iValue > 1) iValue = 1;

	GnomeTurretFireEnabled = iValue;
	SaveCurrentTurretSettings();
	GenerateGnomeVirtualInventory();
	sayf("* %s set fire enabled to %d (%s)", hPlayer.GetPlayerName(), iValue, iValue == 0 ? "Disabled" : "Enabled");
}

function SetTurretRange(hPlayer, sValue)
{
	if (!hPlayer || !hPlayer.IsValid() || hPlayer.IsDead() || hPlayer.IsIncapacitated())
		return;

	if (sValue == CC_EMPTY_ARGUMENT)
	{
		sayf("* Current turret range: %.0f units (Range: 300-9000)", GnomeTurretRange);
		return;
	}

	local iValue = sValue.tointeger();
	if (iValue < 300) iValue = 300;
	if (iValue > 9000) iValue = 9000;

	GnomeTurretRange = iValue.tofloat();
	SaveCurrentTurretSettings();
	GenerateGnomeVirtualInventory();
	sayf("* %s set turret range to %.0f units", hPlayer.GetPlayerName(), GnomeTurretRange);
}

function ShowTurretHelp(hPlayer)
{
	if (!hPlayer || !hPlayer.IsValid())
		return;

	sayf("=== GNOME TURRET GLOBAL COMMANDS ===");
	sayf("!turret_ammo <amount> - Set base ammo (min 50, affects all turrets)");
	sayf("!turret_type <0-2> - 0=Default, 1=Incendiary, 2=Explosive"); // Demolition removed
	sayf("!turret_think <75-250> - Turret think rate in milliseconds");
	sayf("!turret_firerate <75-250> - Fire rate in milliseconds");
	sayf("!turret_range <300-9000> - Target detection range in units");
	sayf("!turret_damage <1-1000> - Damage per shot");
	sayf("!turret_rotation <45-359> - Rotation speed (realistic aim only)");
	sayf("!turret_aim <0/1> - 0=Aimbot, 1=Realistic aim");
	sayf("!turret_debug <0/1> - Toggle detailed debug mode");
	sayf("!turret_debug_interval <0.5-10.0> - Debug message interval in seconds");
	sayf("=== CURRENT SETTINGS ===");
	sayf("Ammo: %d | Type: %d | Think: %dms | FireRate: %dms",
		GnomeTurretAmmoBase,
		(GnomeTurretExplosiveMode ? 2 : (GnomeTurretFireEnabled ? 1 : 0)), // Demolition removed
		GnomeTurretThinkRateMS, GnomeTurretFireRateMS);
	sayf("Range: %.0f | Damage: %d | Rotation: %.1f | Aim: %d | Debug: %d",
		GnomeTurretRange, GnomeTurretDamage, GnomeTurretRotationSpeed,
		GnomeTurretAimMode, GnomeTurretDebugMode);
}

function AdditionalClassMethodsInjected()
{
	// ONLY ALLOWED GLOBAL COMMANDS - ALL OTHERS DISABLED
	RegisterChatCommand("!turret_ammo", ChangeTurretBaseAmmo, true, true);
	RegisterChatCommand("!turret", ShowTurretHelp, true);
	RegisterChatCommand("!turret_debug", ToggleGlobalDebugMode, true, true);
	RegisterChatCommand("!turret_debug_interval", SetDebugInterval, true, true);
	RegisterChatCommand("!turret_type", SetTurretType, true, true);
	RegisterChatCommand("!turret_think", SetTurretThinkRate, true, true);
	RegisterChatCommand("!turret_firerate", SetTurretFireRate, true, true);
	RegisterChatCommand("!turret_range", SetTurretRange, true, true);
	RegisterChatCommand("!turret_damage", SetTurretDamage, true, true);
	RegisterChatCommand("!turret_rotation", SetTurretRotationSpeed, true, true);
	RegisterChatCommand("!turret_aim", SetTurretAimMode, true, true);

	// ALL OTHER COMMANDS DISABLED:
	// RegisterChatCommand("!debugmode", ToggleDebugMode, true);
	// RegisterChatCommand("!remove", RemoveTurret, true, true);
	// RegisterChatCommand("!ammo", ChangeTurretAmmo, true, true);
	// RegisterChatCommand("!mode", ToggleTurretMode, true);
	// RegisterChatCommand("!turret_demolition", SetTurretDemolition, true, true);
	// RegisterChatCommand("!turret_explosive", SetTurretExplosive, true, true);
	// RegisterChatCommand("!turret_fire", SetTurretFire, true, true);
}

RegisterOnTickFunction("Turret_Think");

RegisterButtonListener(IN_ATTACK, "OnAttackPress", eButtonType.Pressed, eTeam.Survivor);
RegisterButtonListener(IN_USE, "OnUsePress", eButtonType.Pressed, eTeam.Survivor);

PrecacheEntityFromTable({classname = "prop_dynamic", model = "models/props_urban/wood_railing_post001.mdl"});
PrecacheEntityFromTable({classname = "ambient_generic", message = "weapons/50cal/50cal_shoot.wav"});


function CfgFileCheck(filename)
{
	local files = FileToString(filename);
	if(!files)
	{
		return false;
	}
	return true;
}

function GenerateGnomeTurretCfgFile()
{
	local DefaultToggleFile = "";

	local CfgToggleFile =
	[
		"// -- PERFORMANCE SETTINGS --",
		"GnomeTurretThinkRateMS " + GnomeTurretThinkRateMS,
		"GnomeTurretFireRateMS " + GnomeTurretFireRateMS,
		".",
		"// -- AIMING SYSTEM --",
		"GnomeTurretAimMode " + GnomeTurretAimMode,
		"GnomeTurretRotationSpeed " + GnomeTurretRotationSpeed,
		".",
		"// -- TURRET LIMITS --",
		"GnomeTurretMaxCount " + GnomeTurretMaxCount,
		".",
		"// -- FEATURE TOGGLES --",
		// "GnomeTurretDemolitionMode " + GnomeTurretDemolitionMode, // DISABLED - Demolition removed
		"GnomeTurretExplosiveMode " + GnomeTurretExplosiveMode,
		"GnomeTurretFireEnabled " + GnomeTurretFireEnabled,
		"GnomeTurretDebugMode " + GnomeTurretDebugMode,
		"GnomeTurretRange " + GnomeTurretRange,
		".",
		"// -- LEGACY SETTINGS --",
		// "DemolitionShot 1", // DISABLED - Demolition removed
		"GnomeTurretDamage 50",
		"GnomeTurretAmmoBase " + GnomeTurretAmmoBase,
		".",
		".",
		"// =================================",
		"//Notes: This cfg file is generated automatically when starting a campaign, & loaded on each stage & when installing the gnome turret on the ground.",
		"//Notes 2: Install the gnome turret on the ground to load settings of cfg file on the turret.",
		"."

	]

	foreach (line in CfgToggleFile)
	{
		DefaultToggleFile = DefaultToggleFile + line + "\n";
	}
	if(!CfgFileCheck("gnome turret/gnome turret.txt"))
	{

		StringToFile("gnome turret/gnome turret.txt", DefaultToggleFile);
		printl("The 'gnome turret.txt' file can't be found. Generating a new 'gnome turret.txt' file...");

	}

}

function SaveCurrentTurretSettings()
{
	// Save current settings to the configuration file in gnome_turret_trigger.nut format
	local DefaultToggleFile = "";

	local CfgToggleFile =
	[
		"// -- PERFORMANCE SETTINGS --",
		"GnomeTurretThinkRateMS " + GnomeTurretThinkRateMS,
		"GnomeTurretFireRateMS " + GnomeTurretFireRateMS,
		".",
		"// -- AIMING SYSTEM --",
		"GnomeTurretAimMode " + GnomeTurretAimMode,
		"GnomeTurretRotationSpeed " + GnomeTurretRotationSpeed,
		".",
		"// -- TURRET LIMITS --",
		"GnomeTurretMaxCount " + GnomeTurretMaxCount,
		".",
		"// -- FEATURE TOGGLES --",
		// "GnomeTurretDemolitionMode " + GnomeTurretDemolitionMode, // DISABLED - Demolition removed
		"GnomeTurretExplosiveMode " + GnomeTurretExplosiveMode,
		"GnomeTurretFireEnabled " + GnomeTurretFireEnabled,
		"GnomeTurretDebugMode " + GnomeTurretDebugMode,
		"GnomeTurretRange " + GnomeTurretRange,
		".",
		"// -- LEGACY SETTINGS --",
		// "DemolitionShot 1", // DISABLED - Demolition removed
		"GnomeTurretDamage 50",
		"GnomeTurretAmmoBase " + GnomeTurretAmmoBase
	]

	foreach (line in CfgToggleFile)
	{
		DefaultToggleFile = DefaultToggleFile + line + "\n";
	}

	StringToFile("gnome turret/gnome turret.txt", DefaultToggleFile);

	// Also update the virtual inventory file to maintain consistency
	GenerateGnomeVirtualInventory();
}
function GenerateGnomeVirtualInventory()
{
	local DefaultToggleFile = "";

	// Update all character ammo variables to current base ammo for consistency
	// Only update if the character has gnomes in inventory
	if(GnomeTurretNick > 0) GnomeTurretAmmoNick = GnomeTurretAmmoBase;
	if(GnomeTurretCoach > 0) GnomeTurretAmmoCoach = GnomeTurretAmmoBase;
	if(GnomeTurretEllis > 0) GnomeTurretAmmoEllis = GnomeTurretAmmoBase;
	if(GnomeTurretRochelle > 0) GnomeTurretAmmoRochelle = GnomeTurretAmmoBase;
	if(GnomeTurretBill > 0) GnomeTurretAmmoBill = GnomeTurretAmmoBase;
	if(GnomeTurretLouis > 0) GnomeTurretAmmoLouis = GnomeTurretAmmoBase;
	if(GnomeTurretFrancis > 0) GnomeTurretAmmoFrancis = GnomeTurretAmmoBase;
	if(GnomeTurretZoey > 0) GnomeTurretAmmoZoey = GnomeTurretAmmoBase;

	local CfgToggleFile =
	[
		"GnomeTurretNick " + GnomeTurretNick,
		"GnomeTurretCoach " + GnomeTurretCoach,
		"GnomeTurretEllis " + GnomeTurretEllis,
		"GnomeTurretRochelle " + GnomeTurretRochelle,
		"GnomeTurretBill " + GnomeTurretBill,
		"GnomeTurretLouis " + GnomeTurretLouis,
		"GnomeTurretFrancis " + GnomeTurretFrancis,
		"GnomeTurretZoey " + GnomeTurretZoey,
		".",
		"GnomeTurretAmmoNick " + GnomeTurretAmmoNick,
		"GnomeTurretAmmoCoach " + GnomeTurretAmmoCoach,
		"GnomeTurretAmmoEllis " + GnomeTurretAmmoEllis,
		"GnomeTurretAmmoRochelle " + GnomeTurretAmmoRochelle,
		"GnomeTurretAmmoBill " + GnomeTurretAmmoBill,
		"GnomeTurretAmmoLouis " + GnomeTurretAmmoLouis,
		"GnomeTurretAmmoFrancis " + GnomeTurretAmmoFrancis,
		"GnomeTurretAmmoZoey " + GnomeTurretAmmoZoey,
		".",
		".",
		"// =================================",
		"//Notes: This file is just for virtual inventory to save data in game.",
		"."

	]

	foreach (line in CfgToggleFile)
	{
		DefaultToggleFile = DefaultToggleFile + line + "\n";
	}

	// Always write the file to update current inventory state
	StringToFile("gnome turret/virtual inventory/gnome virtual inventory.txt", DefaultToggleFile);

	if(!CfgFileCheck("gnome turret/virtual inventory/gnome virtual inventory.txt"))
	{
		printl("Warning: Failed to create 'gnome virtual inventory.txt' file!");
	}

}
function GenerateGnomeVirtualInventoryReset()
{
	local DefaultToggleFile = "";

	GnomeTurretNick = 0;
	GnomeTurretCoach = 0;
	GnomeTurretEllis = 0;
	GnomeTurretRochelle = 0;
	GnomeTurretBill = 0;
	GnomeTurretLouis = 0;
	GnomeTurretFrancis = 0;
	GnomeTurretZoey = 0;

	GnomeTurretAmmoNick = 0;
	GnomeTurretAmmoCoach = 0;
	GnomeTurretAmmoEllis = 0;
	GnomeTurretAmmoRochelle = 0;
	GnomeTurretAmmoBill = 0;
	GnomeTurretAmmoLouis = 0;
	GnomeTurretAmmoFrancis = 0;
	GnomeTurretAmmoZoey = 0;

	local CfgToggleFile =
	[
		"GnomeTurretNick 0",
		"GnomeTurretCoach 0",
		"GnomeTurretEllis 0",
		"GnomeTurretRochelle 0",
		"GnomeTurretBill 0",
		"GnomeTurretLouis 0",
		"GnomeTurretFrancis 0",
		"GnomeTurretZoey 0",
		".",
		"GnomeTurretAmmoNick 0",
		"GnomeTurretAmmoCoach 0",
		"GnomeTurretAmmoEllis 0",
		"GnomeTurretAmmoRochelle 0",
		"GnomeTurretAmmoBill 0",
		"GnomeTurretAmmoLouis 0",
		"GnomeTurretAmmoFrancis 0",
		"GnomeTurretAmmoZoey 0",
		".",
		".",
		"// =================================",
		"//Notes: This file is just for virtual inventory to save data in game.",
		"."

	]

	foreach (line in CfgToggleFile)
	{
		DefaultToggleFile = DefaultToggleFile + line + "\n";
	}

	// Always write the file to reset inventory state
	StringToFile("gnome turret/virtual inventory/gnome virtual inventory.txt", DefaultToggleFile);

	if(!CfgFileCheck("gnome turret/virtual inventory/gnome virtual inventory.txt"))
	{
		printl("Warning: Failed to reset 'gnome virtual inventory.txt' file!");
	}

}
function LoadSpecificConfigFile(filename)
{
	local trigger = 0;
	local files = FileToString(filename);
	if(!files)
	{
		printl("[CONFIG] Failed to load config file: " + filename);
		return trigger;
	}
	printl("[CONFIG] Loading config file: " + filename);
	local toggles = split(files, "\r\n");
	foreach(toggle in toggles)
	{
		if(toggle && toggle != "")
		{
			toggle = strip(toggle);
			local idx = toggle.find(" ");
			if (idx != null)
			{
				local togglecommand = toggle.slice(0, idx);
				local togglevalue = toggle.slice(idx + 1);

				// Main turret configuration settings
				if(togglecommand == "GnomeTurretThinkRateMS")
			{
				GnomeTurretThinkRateMS = togglevalue.tointeger();
				printl("[CONFIG] Set GnomeTurretThinkRateMS to " + GnomeTurretThinkRateMS);
			}
			if(togglecommand == "GnomeTurretFireRateMS")
			{
				GnomeTurretFireRateMS = togglevalue.tointeger();
				printl("[CONFIG] Set GnomeTurretFireRateMS to " + GnomeTurretFireRateMS);
			}
			if(togglecommand == "GnomeTurretAimMode")
			{
				GnomeTurretAimMode = togglevalue.tointeger();
				printl("[CONFIG] Set GnomeTurretAimMode to " + GnomeTurretAimMode);
			}
				if(togglecommand == "GnomeTurretRotationSpeed")
				{
					GnomeTurretRotationSpeed = togglevalue.tofloat();
				}
				if(togglecommand == "GnomeTurretMaxCount")
				{
					GnomeTurretMaxCount = togglevalue.tointeger();
				}
				// DISABLED - Demolition mode removed
		// if(togglecommand == "GnomeTurretDemolitionMode")
		// {
		//		GnomeTurretDemolitionMode = togglevalue.tointeger();
		// }
				if(togglecommand == "GnomeTurretExplosiveMode")
				{
					GnomeTurretExplosiveMode = togglevalue.tointeger();
				}
				if(togglecommand == "GnomeTurretFireEnabled")
				{
					GnomeTurretFireEnabled = togglevalue.tointeger();
				}
				if(togglecommand == "GnomeTurretDebugMode")
				{
					GnomeTurretDebugMode = togglevalue.tointeger();
				}
				if(togglecommand == "GnomeTurretRange")
				{
					GnomeTurretRange = togglevalue.tofloat();
				}

				// Legacy settings
				if(togglecommand == "ExplosionAmmoToggle")
				{
					ExplosionAmmoToggle = togglevalue.tointeger();
				}
				// DISABLED - Demolition mode removed
		// if(togglecommand == "DemolitionShot")
		// {
		//		DemolitionShot = togglevalue.tointeger();
		// }
				if(togglecommand == "GnomeTurretDamage")
				{
					if(togglevalue.tointeger() <= 1)
					{
						GnomeTurretDamage = 1;
					}
					if(togglevalue.tofloat() > 1)
					{
						GnomeTurretDamage = togglevalue.tointeger();

					}

				}
				if(togglecommand == "GnomeTurretAmmoBase")
				{
					GnomeTurretAmmoBase = togglevalue.tointeger();
				}
				if(togglecommand == "GnomeTurretAmmoNick")
				{
					GnomeTurretAmmoNick = togglevalue.tointeger();

				}
				if(togglecommand == "GnomeTurretAmmoCoach")
				{
					GnomeTurretAmmoCoach = togglevalue.tointeger();

				}
				if(togglecommand == "GnomeTurretAmmoEllis")
				{
					GnomeTurretAmmoEllis = togglevalue.tointeger();

				}
				if(togglecommand == "GnomeTurretAmmoRochelle")
				{
					GnomeTurretAmmoRochelle = togglevalue.tointeger();

				}
				if(togglecommand == "GnomeTurretAmmoBill")
				{
					GnomeTurretAmmoBill = togglevalue.tointeger();

				}
				if(togglecommand == "GnomeTurretAmmoLouis")
				{
					GnomeTurretAmmoLouis = togglevalue.tointeger();

				}
				if(togglecommand == "GnomeTurretAmmoFrancis")
				{
					GnomeTurretAmmoFrancis = togglevalue.tointeger();

				}
				if(togglecommand == "GnomeTurretAmmoZoey")
				{
					GnomeTurretAmmoZoey = togglevalue.tointeger();

				}
				if(togglecommand == "GnomeTurretNick")
				{
					GnomeTurretNick = togglevalue.tointeger();

				}
				if(togglecommand == "GnomeTurretCoach")
				{
					GnomeTurretCoach = togglevalue.tointeger();

				}
				if(togglecommand == "GnomeTurretEllis")
				{
					GnomeTurretEllis = togglevalue.tointeger();

				}
				if(togglecommand == "GnomeTurretRochelle")
				{
					GnomeTurretRochelle = togglevalue.tointeger();

				}
				if(togglecommand == "GnomeTurretBill")
				{
					GnomeTurretBill = togglevalue.tointeger();

				}
				if(togglecommand == "GnomeTurretLouis")
				{
					GnomeTurretLouis = togglevalue.tointeger();

				}
				if(togglecommand == "GnomeTurretFrancis")
				{
					GnomeTurretFrancis = togglevalue.tointeger();

				}
				if(togglecommand == "GnomeTurretZoey")
				{
					GnomeTurretZoey = togglevalue.tointeger();

				}

			}
		}
	}
}

function UpdateExistingTurretsFromConfig()
{
	// Determine current turret type based on loaded config settings
	local currentType = 0; // Default
	// if (GnomeTurretDemolitionMode) currentType = 3; // DISABLED - Demolition removed
	if (GnomeTurretExplosiveMode) currentType = 2;
	else if (GnomeTurretFireEnabled) currentType = 1;

	// Update all existing turrets with the correct damage type
	foreach (turret in g_aTurretList)
	{
		if (turret && turret.m_hMachineGun && turret.m_hMachineGun.IsValid())
		{
			if (currentType == 0) turret.SetDamageType(DMG_BULLET);
			else if (currentType == 1) turret.SetDamageType(DMG_BURN);
			else if (currentType == 2) turret.SetDamageType(DMG_STUMBLE);
			// else if (currentType == 3) turret.SetDamageType(DMG_BLAST); // DISABLED - Demolition removed
		}
	}

	if (GnomeTurretDebugMode)
	{
		local sTypeName = ["Default Vanilla", "Incendiary Fire", "Explosive Stagger"][currentType]; // Removed demolition
		printl("[CONFIG] Updated " + g_aTurretList.len() + " existing turrets to type " + currentType + " (" + sTypeName + ")");
	}
}

function ApplyConfigToNewTurret(turret)
{
	// Determine current turret type based on loaded config settings
	local currentType = 0; // Default
	// if (GnomeTurretDemolitionMode) currentType = 3; // DISABLED - Demolition removed
	if (GnomeTurretExplosiveMode) currentType = 2;
	else if (GnomeTurretFireEnabled) currentType = 1;

	// Apply the correct damage type to the new turret
	if (turret && turret.m_hMachineGun && turret.m_hMachineGun.IsValid())
	{
		if (currentType == 0) turret.SetDamageType(DMG_BULLET);
		else if (currentType == 1) turret.SetDamageType(DMG_BURN);
		else if (currentType == 2) turret.SetDamageType(DMG_STUMBLE);
		// else if (currentType == 3) turret.SetDamageType(DMG_BLAST); // DISABLED - Demolition removed

		if (GnomeTurretDebugMode)
		{
			local sTypeName = ["Default Vanilla", "Incendiary Fire", "Explosive Stagger"][currentType]; // Removed demolition
			printl("[CONFIG] Applied type " + currentType + " (" + sTypeName + ") to new turret");
		}
	}
}

function IsCertainSurvivor(kent, certainsurv)
{
	local player = null
	while(player = Entities.FindByModel(player, certainsurv))
	{
		if(kent == player)
		{
			return true;
		}

	}
	return false;

}
function GetSecondarySlot(player)
{
	local invTable = {};
	GetInvTable(player, invTable);

	if(!("slot1" in invTable))
		return null;

	local weapon = invTable.slot1;

	if(weapon)
		return weapon.GetClassname();

	return null;
}
function ForcedToSwitchSecondary2(kent)
{
	local invTable = {}
	GetInvTable(kent, invTable)
	if(!("slot1" in invTable))
	{
		return null;
	}
	if(("slot1" in invTable))
	{
		local item2 = invTable.slot1;

		if(GetSecondarySlot(kent) != null)
		{
			return NetProps.SetPropEntity(kent, "m_hActiveWeapon", item2);

		}

	}
	return null;
}
function GetButtonPressed(kent, keyvalue)
{
	if(kent.GetButtonMask() & keyvalue)
	{
		return true;
	}
	return false;
}

function GetItemAmmo(kent, itemclass)
{
	local playerweapon = null;
	while(playerweapon = Entities.FindByClassname(playerweapon, itemclass))
	{
		if(playerweapon.GetOwnerEntity() == kent)
		{
			return NetProps.GetPropIntArray(kent, "m_iAmmo", NetProps.GetPropInt(playerweapon, "m_iPrimaryAmmoType"));
		}

	}
	return null;
}
function SetItemAmmo(kent, itemclass, ammo)
{
	local playerweapon = null;
	while(playerweapon = Entities.FindByClassname(playerweapon, itemclass))
	{
		if(playerweapon.GetOwnerEntity() == kent)
		{
			return NetProps.SetPropIntArray(kent, "m_iAmmo", ammo, NetProps.GetPropInt(playerweapon, "m_iPrimaryAmmoType"));
		}

	}
	return null;
}

function ShowSpecialHint(kent, customhint, customicon, delay, duration)
{
	local spechint = clone special_hint;
	if(!kent.IsDead())
	{
		spechint.hint_caption = customhint;
		spechint.hint_icon_onscreen = customicon;
		local spechintentity = SpawnEntityFromTable("env_instructor_hint", spechint);
		DoEntFire("!self", "ShowHint", "!activator", delay, kent, spechintentity);
		DoEntFire("!self", "kill", "", duration, spechintentity, spechintentity);

	}
	return null;
}