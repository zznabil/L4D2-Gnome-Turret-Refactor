// Squirrel
// Turret Mod

TurretDataSaveTimer <- 0


class CTurret
{
	constructor(ammo, tracer_entity, machine_gun, laser_entity, angles, owner, identifier, damagetype, bipod, mg_mode, mg_ammo)
	{
		m_flSweepOffset = 0.0;
		m_flLastSweepTime = 0.0;
		m_iAmmo = ammo;
		m_hOwner = owner;
		m_hTracerEntity = tracer_entity;
		m_hMachineGun = machine_gun;
		m_hLaserEntity = laser_entity;
		m_eDefaultAngles = angles;
		m_sIdentifier = identifier;
		m_iDamageType = damagetype;
		m_bMachineGunMode = mg_mode;
		m_aMachineGunAmmo = mg_ammo;
		m_aBipod = bipod;
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
	m_iAmmo = 0;
	m_aBipod = null;
	m_hOwner = null;
	m_hMachineGun = null;
	m_hTracerEntity = null;
	m_hLaserEntity = null;
	m_hShellEntity = null;
	m_hMuzzleEntity = null;
	m_eDefaultAngles = null;
	m_flNextShootTime = 0.0;
	m_flNextAnglesChangeTime = 0.0;
	m_iDamageType = DMG_BULLET;
	m_bMachineGunMode = false;
	m_aMachineGunAmmo = 0;
	m_sIdentifier = null;
	m_flSweepOffset = 0.0;
	m_flLastSweepTime = 0.0;
}

enum eTurret
{
	Damage = 50.0
	MaxAmmo = 400
	MaxAngle = 360.0 // 75
	MaxRange = 6666.0
	MaxRadiusUse = 90.0
	MaxAngleUse = 360.0 // 25
	MaxClipSize = 250
	MaxDistanceToGround = 150.0
	MaxForwardDistance = 70.0 // 50
	MinForwardDistance = 50.0 // 30
	ToleranceAngle = 5.0
	IdleTime = 3.0
	SweepSpeed = 20.0
	SweepArc = 90.0
	ShootTime = 0.2 //0.2
	ShootSound = "weapons/50cal/50cal_shoot.wav"
	Shell = "weapon_shell_casing_50cal"
	MuzzleFlash = "weapon_muzzle_flash_assaultrifle"
	Laser = "weapon_laser_sight"
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

ExplosionEntity <- SpawnEntityFromTable("env_explosion", explosion_entity);
g_bDebugMode <- false;
g_flFindPotentialTargetsTime <- 0.0;
g_flTurretThinkThrottle <- 0.0;
g_bLaserEnabled <- true;

g_aPotentialTargets <- [];
g_aTurretList <- [];
function ClampAmmo(amount)
{
	if (amount < 5) return 5;
	if (amount > 400) return 400;
	return amount;
}

// Safety fallback: ensure g_iTurretCount exists in this module scope
if (!("g_iTurretCount" in getroottable())) g_iTurretCount <- 0;


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
			spawnflags = (iSpawnFlags == null ? NetProps.GetPropInt(hWeapon, "m_spawnflags") : iSpawnFlags)
			count = (iCount == null ? NetProps.GetPropInt(hWeapon, "m_itemCount") : iCount)
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
				else if (NetProps.GetPropString(hWeapon, "m_ModelName") == sWeaponModel) ReplaceWeapon(hWeapon);
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
		if (g_iTurretCount >= g_iMaxTurrets) { sayf("Server turret limit reached (%d/%d).", g_iTurretCount, g_iMaxTurrets); return; }
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
		local vecMuzzlePos = vecPos + Vector(0, 0, 42) + Vector(0, 0, 4) + QAngle(0, eAngles.y, 0).Forward() * 38;
		local hLaserEntity = SpawnEntityFromTable("info_particle_system", {
			effect_name = eTurret.Laser
			origin = vecMuzzlePos
			angles = Vector(0, eAngles.y, 0)
			start_active = 1
		});
		CEntity(hMachineGun).AttachEntity(hLaserEntity);

		local hShellEntity = null;
		local hMuzzleEntity = null;
		if (g_bTurretParticlesEnabled)
		{
			hShellEntity = SpawnEntityFromTable("info_particle_system", {
				effect_name = eTurret.Shell
				start_active = 0
			});
			CEntity(hMachineGun).AttachEntity(hShellEntity, "Shell");
			hMuzzleEntity = SpawnEntityFromTable("info_particle_system", {
				effect_name = eTurret.MuzzleFlash
				start_active = 0
			});
		}
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
					iAmmo = ClampAmmo(val);
					if(RandomInt(0,100) <= 100)
					{
						if(IsCertainSurvivor(hPlayer, NickModel))
						{
							iAmmo = ClampAmmo(GnomeTurretAmmoNick);
						}
						else if(IsCertainSurvivor(hPlayer, CoachModel))
						{
							iAmmo = ClampAmmo(GnomeTurretAmmoCoach);
						}
						else if(IsCertainSurvivor(hPlayer, EllisModel))
						{
							iAmmo = ClampAmmo(GnomeTurretAmmoEllis);
						}
						else if(IsCertainSurvivor(hPlayer, RochelleModel))
						{
							iAmmo = ClampAmmo(GnomeTurretAmmoRochelle);
						}
						else if(IsCertainSurvivor(hPlayer, BillModel))
						{
							iAmmo = ClampAmmo(GnomeTurretAmmoBill);
						}
						else if(IsCertainSurvivor(hPlayer, LouisModel))
						{
							iAmmo = ClampAmmo(GnomeTurretAmmoLouis);
						}
						else if(IsCertainSurvivor(hPlayer, FrancisModel))
						{
							iAmmo = ClampAmmo(GnomeTurretAmmoFrancis);
						}
						else if(IsCertainSurvivor(hPlayer, ZoeyModel))
						{
							iAmmo = ClampAmmo(GnomeTurretAmmoZoey);
						}
						
					}
				}
				else if (key == "damagetype") iDamageType = val;
				else if (key == "identifier") sIdentifier = val;
				else if (key == "mg_mode") bMachineGunMode = val;
				else if (key == "mg_ammo") aMachineGunAmmo = val;
			}
		}
		if (!iAmmo)
		{
			iAmmo = ClampAmmo(GetConVarInt(g_ConVar_TurretAmmo));
			if(RandomInt(0,100) <= 100)
			{
				if(IsCertainSurvivor(hPlayer, NickModel))
				{
					iAmmo = ClampAmmo(GnomeTurretAmmoNick);
				}
				else if(IsCertainSurvivor(hPlayer, CoachModel))
				{
					iAmmo = ClampAmmo(GnomeTurretAmmoCoach);
				}
				else if(IsCertainSurvivor(hPlayer, EllisModel))
				{
					iAmmo = ClampAmmo(GnomeTurretAmmoEllis);
				}
				else if(IsCertainSurvivor(hPlayer, RochelleModel))
				{
					iAmmo = ClampAmmo(GnomeTurretAmmoRochelle);
				}
				else if(IsCertainSurvivor(hPlayer, BillModel))
				{
					iAmmo = ClampAmmo(GnomeTurretAmmoBill);
				}
				else if(IsCertainSurvivor(hPlayer, LouisModel))
				{
					iAmmo = ClampAmmo(GnomeTurretAmmoLouis);
				}
				else if(IsCertainSurvivor(hPlayer, FrancisModel))
				{
					iAmmo = ClampAmmo(GnomeTurretAmmoFrancis);
				}
				else if(IsCertainSurvivor(hPlayer, ZoeyModel))
				{
					iAmmo = ClampAmmo(GnomeTurretAmmoZoey);
				}
				
			}
			
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
		g_aTurretList.push(CTurret(iAmmo, hTracerEntity, hMachineGun, hLaserEntity, eAngles, hPlayer, sIdentifier, iDamageType, aBipod, bMachineGunMode, aMachineGunAmmo));

		local newTurret = g_aTurretList[g_aTurretList.len()-1];
		newTurret.m_hShellEntity = hShellEntity;
		newTurret.m_hMuzzleEntity = hMuzzleEntity;

		if (g_bTurretParticlesEnabled)
		{
			local hSmoke = SpawnEntityFromTable("info_particle_system", {
				effect_name = "gas_explosion_main"
				origin = vecPos + Vector(0, 0, 10)
				start_active = 1
			});
			local hSparks = SpawnEntityFromTable("info_particle_system", {
				effect_name = "impact_explosive_ammo_small"
				origin = vecPos + Vector(0, 0, 5)
				start_active = 1
			});
			AcceptEntityInput(hSmoke, "Stop", "", 1.5);
			AcceptEntityInput(hSparks, "Stop", "", 1.5);
			DoEntFire("!self", "Kill", "", 2.5, hSmoke, hSmoke);
			DoEntFire("!self", "Kill", "", 2.5, hSparks, hSparks);
		}

		if (hWeapon.GetClassname() == eTurret.Weapon) hWeapon.Kill();
		if (g_bDebugMode) PrintTurretList();
		if(CfgFileCheck("demolition gunners/demolition gunners cfg/explosion ammo cfg.txt"))
		{
			LoadSpecificConfigFile("demolition gunners/demolition gunners cfg/explosion ammo cfg.txt");
		}
		
		switch(RandomInt(0, 1))
		{
			case 0:
				hPlayer.PrecacheScriptSound("Moustachio_STRENGTHATTRACT_RANDOM");
				EmitSoundOnClient("Moustachio_STRENGTHATTRACT_RANDOM", hPlayer);
				break;
			
			case 1:
				hPlayer.PrecacheScriptSound("Moustachio_STRENGTHATTRACT_RANDOMLAUGH");
				EmitSoundOnClient("Moustachio_STRENGTHATTRACT_RANDOMLAUGH", hPlayer);
				break;
			
			
		}
		
		GenerateGnomeTurretCfgFile();
		LoadSpecificConfigFile("gnome turret/gnome turret.txt");
		
		ShowSpecialHint(hPlayer, ("Turret Ammo = " + iAmmo), LampIcon, 0.1, 3);
		g_iTurretCount++;
if (g_iTurretCount < 0) g_iTurretCount = 0;
if (g_iTurretCount > 32) g_iTurretCount = 32;
		
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
					tParams["mg_ammo"][0] = NetProps.GetPropInt(hWeapon, "m_iClip1");
					tParams["mg_ammo"][1] = NetProps.GetPropIntArray(hPlayer, "m_iAmmo", NetProps.GetPropInt(hWeapon, "m_iPrimaryAmmoType"));
					CEntity(hWeapon).GetScriptScopeVar("turret_scope")["ammo"] = tParams["mg_ammo"][0] + tParams["mg_ammo"][1];
					EmitSoundOnClient("Buttons.snd11", hPlayer);
				}
				else
				{
					SetMachineGunAmmo(hPlayer, hWeapon, tParams["mg_ammo"][1], tParams["mg_ammo"][0]);
					NetProps.SetPropFloat(hWeapon, "m_flNextPrimaryAttack", 0.0);
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

function ToggleLaser(hPlayer)
{
	if (hPlayer.IsHost())
	{
		g_bLaserEnabled = !g_bLaserEnabled;
		ShowSpecialHint(hPlayer, "Laser sight: " + (g_bLaserEnabled ? "ON" : "OFF"), LampIcon, 0.1, 3);
		printl("[Turret] Laser toggled " + (g_bLaserEnabled ? "ON" : "OFF") + " by " + hPlayer.GetPlayerName());
	}
}

function ToggleDemolitionMode(hPlayer, sValue)
{
	if (!hPlayer.IsHost())
	{
		ShowSpecialHint(hPlayer, "Only the host can toggle demolition mode.", ForbiddenIcon, 0.1, 3);
		return;
	}
	if (sValue == CC_EMPTY_ARGUMENT || sValue == "")
	{
		sayf("* Demolition mode is %s", g_bDemolitionMode ? "ON" : "OFF");
		return;
	}
	local val = strip(split(sValue, " ")[0]).tointeger();
	g_bDemolitionMode = val > 0 ? true : false;
	GenerateGnomeTurretCfgFile();
	sayf("* Demolition mode set to %s", g_bDemolitionMode ? "ON" : "OFF");
	printl("[Turret] Demolition mode set to " + g_bDemolitionMode + " by " + hPlayer.GetPlayerName());
}

function RemoveTurret(hPlayer, sValue)
{
	if (hPlayer.IsDead() || hPlayer.IsIncapacitated() || !g_bDebugMode) return;
	if (sValue == CC_EMPTY_ARGUMENT)
	{
		foreach (idx, turret in g_aTurretList)
			{
				if (turret.m_hOwner == hPlayer)
				{
					foreach (ent in turret.m_aBipod) if (ent.IsValid()) ent.Kill();
					if (turret.m_hMachineGun.IsValid()) turret.m_hMachineGun.Kill();
					if (turret.m_hTracerEntity.IsValid()) turret.m_hTracerEntity.Kill();
					if (turret.m_hLaserEntity.IsValid()) turret.m_hLaserEntity.Kill();
					if (turret.m_hShellEntity.IsValid()) turret.m_hShellEntity.Kill();
					if (turret.m_hMuzzleEntity.IsValid()) turret.m_hMuzzleEntity.Kill();
					g_aTurretList.remove(idx);
					sayf("* %s removed a turret (Ammo: %d)", hPlayer.GetPlayerName(), turret.m_iAmmo);
					return;
				}
			}
		sayf("* You haven't a turret");
	}
	else if (split(sValue, " ")[0] == "all")
	{
		local turret;
		local bFound = false;
		for (local i = 0; i < g_aTurretList.len(); i++)
		{
			if (g_aTurretList[i].m_hOwner == hPlayer)
					{
						turret = g_aTurretList[i];
						foreach (ent in turret.m_aBipod) if (ent.IsValid()) ent.Kill();
						if (turret.m_hMachineGun.IsValid()) turret.m_hMachineGun.Kill();
						if (turret.m_hTracerEntity.IsValid()) turret.m_hTracerEntity.Kill();
						if (turret.m_hLaserEntity.IsValid()) turret.m_hLaserEntity.Kill();
						if (turret.m_hLaserEntity.IsValid()) turret.m_hLaserEntity.Kill();
						if (turret.m_hShellEntity.IsValid()) turret.m_hShellEntity.Kill();
						if (turret.m_hMuzzleEntity.IsValid()) turret.m_hMuzzleEntity.Kill();
						if (!bFound) bFound = true;
						g_aTurretList.remove(i);
						i--;
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
					if (iCount == 0) sayf("* %s's Turret List (!ta):", hPlayer.GetPlayerName());
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
								sayf("* Ammo set: default");
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
								sayf("* Ammo set: explosive");
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
								sayf("* Ammo set: incendiary");
							}
						}
					}
				}
			}
		}
		else sayf("* You haven't a turret");
	}
}

function SetMachineGunAmmo(hPlayer, hMachineGun, iAmmo, iClip)
{
	NetProps.SetPropInt(hMachineGun, "m_iClip1", iClip);
	NetProps.SetPropIntArray(hPlayer, "m_iAmmo", iAmmo, NetProps.GetPropInt(hMachineGun, "m_iPrimaryAmmoType"));
}

function TurretShoot(hMachineGun, turret)
{
	if (!g_bTurretParticlesEnabled) return;
	local hShell = turret.m_hShellEntity;
	local hShootFire = turret.m_hMuzzleEntity;
	if (!hShell || !hShell.IsValid() || !hShootFire || !hShootFire.IsValid()) return;
	local vecPos = hMachineGun.GetOrigin() + hMachineGun.GetAngles().Up() * 4 + hMachineGun.GetAngles().Forward() * 38;
	AcceptEntityInput(hShell, "Stop");
	CEntity(hMachineGun).AttachEntity(hShell, "Shell");
	AcceptEntityInput(hShell, "Start");
	AcceptEntityInput(hShell, "Stop", "", 0.05);
	AcceptEntityInput(hShootFire, "Stop");
	hShootFire.SetOrigin(vecPos);
	AcceptEntityInput(hShootFire, "Start");
	AcceptEntityInput(hShootFire, "Stop", "", 0.05);
	if (g_bDebugMode) Mark(vecPos, 3.0);
}

function TurretShootFakeImpact(turret, hEntity, vecPos)
{
	local sEffect;
	if (turret.m_iDamageType == DMG_BULLET) sEffect = eTurret.ImpactDefault;
	else if (turret.m_iDamageType == DMG_BURN) sEffect = eTurret.ImpactIncendiary;
	else if (turret.m_iDamageType == DMG_STUMBLE) sEffect = (hEntity.IsPlayer() ? eTurret.ImpactExplosiveExtra : eTurret.ImpactExplosive);
	PlayImpactEffect(vecPos, sEffect);
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
	local vecPos;
	if (sClass == "player")
	{
		local iType = hEntity.GetZombieType();
		if (iType != ZOMBIE_TANK)
		{
			if (iType == ZOMBIE_SMOKER) vecPos = hEntity.GetBodyPosition(0.95);
			else if (iType == ZOMBIE_BOOMER) vecPos = hEntity.GetBodyPosition(0.8);
			else if (iType == ZOMBIE_HUNTER) vecPos = hEntity.GetBodyPosition(0.7);
			else if (iType == ZOMBIE_SPITTER) vecPos = hEntity.GetBodyPosition(0.9);
			else if (iType == ZOMBIE_CHARGER)
			{
				if (NetProps.GetPropInt(NetProps.GetPropEntity(hEntity, "m_customAbility"), "m_isCharging")) vecPos = hEntity.GetBodyPosition(0.75);
				else vecPos = hEntity.GetBodyPosition(0.85);
			}
			else if (iType == ZOMBIE_JOCKEY)
			{
				if (NetProps.GetPropEntity(hEntity, "m_jockeyVictim")) vecPos = hEntity.GetBodyPosition(1.3);
				else vecPos = hEntity.GetBodyPosition(0.5);
			}
		}
		else
		{
			vecPos = hEntity.GetBodyPosition(0.8);
		}
	}
	else if (sClass == "infected" || sClass == "witch")
	{
		if (hEntity != null && CEntity(hEntity).KeyInScriptScope("trace_hull"))
		{
			local traceHull = CEntity(hEntity).GetScriptScopeVar("trace_hull");
			if (traceHull != null && traceHull.IsValid()) {
			vecPos = VectorLerp(hEntity.GetOrigin(), traceHull.GetOrigin(), 0.8);
			} else {
			// Recreate trace_hull entity if it became invalid
			local sAttach = (sClass == "witch") ? "leye" : "head";
			local newTraceHull = SpawnEntityFromTable("info_target", {});
			CEntity(hEntity).AttachEntity(newTraceHull, sAttach);
			CEntity(hEntity).SetScriptScopeVar("trace_hull", newTraceHull);
			vecPos = hEntity.GetOrigin();
		}
	}
	}
	if (!vecPos) vecPos = hEntity.GetOrigin();
	return vecPos;
}

function GetNearestEntity(hTracerEntity, hMachineGun)
{
	local idx = 0;
	local length = g_aPotentialTargets.len();
	local flDistanceSqr = GetConVarFloat(g_ConVar_TurretRange) * GetConVarFloat(g_ConVar_TurretRange);
	local hEntity, vecPos, hTarget, vecPosTemp, flDistanceSqrTemp;
	while (idx < length)
	{
		if (hEntity = g_aPotentialTargets[idx])
		{
			try {
				if (hEntity.IsPlayer())
				{
					if (hEntity.IsIncapacitated() || hEntity.GetHealth() < 1)
					{
						g_aPotentialTargets.remove(idx);
						length--;
						continue;
					}
				}
				else if (hEntity.GetHealth() < 1)
				{
					g_aPotentialTargets.remove(idx);
					length--;
					continue;
				}
			}
			catch (error) {
				g_aPotentialTargets.remove(idx);
				length--;
				continue;
			}
			flDistanceSqrTemp = (hEntity.GetOrigin() - hTracerEntity.GetOrigin()).LengthSqr();
			if (flDistanceSqrTemp < flDistanceSqr)
			{
				vecPosTemp = GetEntityPosition(hEntity, hEntity.GetClassname());
				if (hEntity && vecPosTemp)
				{
					if (GetAngleBetweenEntities(hTracerEntity, hEntity) <= GetConVarFloat(g_ConVar_TurretAngle))
					{
						if (IsCanSeeEntity(hTracerEntity, hEntity, hMachineGun, vecPosTemp))
						{
							flDistanceSqr = flDistanceSqrTemp;
							hTarget = hEntity;
							vecPos = vecPosTemp;
						}
					}
				}
			}
		}
		idx++;
	}
	return {
		target = hTarget
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
			if (CEntity(hPlayer).GetDistance(turret.m_hMachineGun, true) <= flMaxRadiusUseSqr && turret.m_iAmmo >= 0)
			{
				if (GetAngleBetweenEntities(hPlayer, turret.m_hMachineGun, Vector(0, 0, -10)) <= eTurret.MaxAngleUse)
				{
					local hWeapon = hPlayer.GetActiveWeapon();
					local tScope = {
						ammo = ClampAmmo(turret.m_iAmmo)
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
						if (turret.m_hShellEntity.IsValid()) turret.m_hShellEntity.Kill();
						if (turret.m_hMuzzleEntity.IsValid()) turret.m_hMuzzleEntity.Kill();
							g_aTurretList.remove(idx);
							g_iTurretCount--;
if (g_iTurretCount < 0) g_iTurretCount = 0;
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

g_flTurretWeaponCheckTimer <- 0.0;
function Turret_Think()
{
	// Throttle to ~30Hz (0.03s) instead of 100Hz - internal timers (weapon 0.2s, targets 0.1s) still control their own rate
	if (g_flTurretThinkThrottle > Time()) return;
	g_flTurretThinkThrottle = Time() + 0.03;
	local hPlayer, hWeapon, iAmmo;
	if (g_flTurretWeaponCheckTimer < Time())
	{
		g_flTurretWeaponCheckTimer = Time() + 0.2;
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
							if (NetProps.GetPropInt(hWeapon, "m_iClip1") == 1)
							{
								if (NetProps.GetPropIntArray(hPlayer, "m_iAmmo", NetProps.GetPropInt(hWeapon, "m_iPrimaryAmmoType")) > 0)
								{
									NetProps.SetPropInt(hWeapon, "m_iClip1", 0);
								}
							}
							continue;
						}
						iAmmo = CEntity(hWeapon).GetScriptScopeVar("turret_scope")["ammo"];
						if (NetProps.GetPropInt(hWeapon, "m_iClip1") != 1 || NetProps.GetPropIntArray(hPlayer, "m_iAmmo", NetProps.GetPropInt(hWeapon, "m_iPrimaryAmmoType")) != iAmmo)
							SetMachineGunAmmo(hPlayer, hWeapon, iAmmo, 1);
					}
					else if (NetProps.GetPropInt(hWeapon, "m_iClip1") != 1 || NetProps.GetPropIntArray(hPlayer, "m_iAmmo", NetProps.GetPropInt(hWeapon, "m_iPrimaryAmmoType")) != GetConVarInt(g_ConVar_TurretAmmo))
						SetMachineGunAmmo(hPlayer, hWeapon, GetConVarInt(g_ConVar_TurretAmmo), 1);
					if (NetProps.GetPropFloat(hWeapon, "m_flNextPrimaryAttack") < Time() + 5.0) NetProps.SetPropFloat(hWeapon, "m_flNextPrimaryAttack", Time() + (1 << 10));
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
				if (turret.m_hLaserEntity.IsValid()) turret.m_hLaserEntity.Kill();
				if (turret.m_hShellEntity.IsValid()) turret.m_hShellEntity.Kill();
				if (turret.m_hMuzzleEntity.IsValid()) turret.m_hMuzzleEntity.Kill();
				g_aTurretList.remove(i);
				i--;
				g_iTurretCount--;
if (g_iTurretCount < 0) g_iTurretCount = 0;
			}
			else if (turret.m_iAmmo > 0)
			{
				if (g_flFindPotentialTargetsTime < Time())
				{
					g_aPotentialTargets.clear();
					g_flFindPotentialTargetsTime = Time() + 0.1;
					while (hEntity = Entities.FindByClassname(hEntity, "player"))
					{
						if (!hEntity.IsSurvivor() && !hEntity.IsIncapacitated() && NetProps.GetPropInt(hEntity, "m_iObserverMode") == 0 && !NetProps.GetPropInt(hEntity, "m_isGhost"))
						{
							g_aPotentialTargets.push(hEntity);
						}
					}
					while (hEntity = Entities.FindByClassname(hEntity, "infected"))
					{
						if (hEntity.IsValid() && hEntity.GetHealth() > 0 && NetProps.GetPropInt(hEntity, "movetype") != MOVETYPE_NONE)
						{
							if (CEntity(hEntity).KeyInScriptScope("trace_hull"))
							{
								g_aPotentialTargets.push(hEntity);
							}
							else
							{
								trace_hull_ent = SpawnEntityFromTable("info_target", {});
								CEntity(hEntity).AttachEntity(trace_hull_ent, "head");
								CEntity(hEntity).SetScriptScopeVar("trace_hull", trace_hull_ent);
								g_aPotentialTargets.push(hEntity);
							}
						}
					}
					while (hEntity = Entities.FindByClassname(hEntity, "witch"))
					{
						if (hEntity.GetHealth() > 0 && NetProps.GetPropFloat(hEntity, "m_rage") >= 1.0)
						{
							if (CEntity(hEntity).KeyInScriptScope("trace_hull"))
							{
								g_aPotentialTargets.push(hEntity);
							}
							else
							{
								trace_hull_ent = SpawnEntityFromTable("info_target", {});
								CEntity(hEntity).AttachEntity(trace_hull_ent, "leye");
								CEntity(hEntity).SetScriptScopeVar("trace_hull", trace_hull_ent);
								g_aPotentialTargets.push(hEntity);
							}
						}
					}
				}
				if (turret.m_flNextShootTime < Time())
				{
					tbl = GetNearestEntity(turret.m_hTracerEntity, turret.m_hMachineGun);
					if (tbl["target"])
					{
						hMachineGun = turret.m_hMachineGun;

						hMachineGun.SetAngles(VectorToQAngle(tbl["position"] - turret.m_hMachineGun.GetOrigin()));

						if(RandomInt(0,100) <= 100)
						{
							tbl["target"].TakeDamage(GnomeTurretDamage, turret.m_iDamageType, turret.m_hOwner);
							// TurretDataSaveTimer = Time();
							
						}

						TurretShoot(hMachineGun, turret);
						TurretShootFakeImpact(turret, tbl["target"], tbl["position"]);
						local vecMuzzle = hMachineGun.GetOrigin() + hMachineGun.GetAngles().Up() * 4 + hMachineGun.GetAngles().Forward() * 38;
						local traceEnd = DoTraceLine(vecMuzzle, (tbl["position"] - vecMuzzle).Normalize(), eTrace.Type_Pos, GetConVarFloat(g_ConVar_TurretRange), eTrace.Mask_Shot, null);
						Line(vecMuzzle, traceEnd, 0.05, 255, 220, 100);

						PlayShootSound(turret.m_hTracerEntity.GetOrigin());

						turret.SetShootTime(Time() + eTurret.ShootTime);
						// turret.SetAmmo(turret.m_iAmmo - 1);
						
						// if (turret.m_aMachineGunAmmo[0] > 0) turret.SetMachineGunAmmo([turret.m_aMachineGunAmmo[0] - 1, turret.m_aMachineGunAmmo[1]]);
						// else if (turret.m_aMachineGunAmmo[1] > 0) turret.SetMachineGunAmmo([0, turret.m_aMachineGunAmmo[1] - 1]);

						if (g_bAllowChangeCameraAngles[hMachineGun.GetEntityIndex()]) g_bAllowChangeCameraAngles[hMachineGun.GetEntityIndex()] = false;
						
						if(g_bDemolitionMode || ExplosionAmmoToggle == 1)
						{
							NetProps.SetPropEntity(ExplosionEntity, "m_hOwnerEntity", turret.m_hOwner);
							ExplosionEntity.SetOrigin(tbl["target"].GetOrigin());
							DoEntFire("!self", "Explode", "" 0, turret.m_hOwner, ExplosionEntity);

							// Stagger for demolition/explosive shot
							if(tbl["target"].GetClassname() == "player")
							{
								if(tbl["target"].GetZombieType() <= 8)
									tbl["target"].Stagger(Vector(0, 0, 50));
							}
							// Insta-gib common infected for demolition shot
							if(tbl["target"].GetClassname() == "infected")
								tbl["target"].TakeDamage(1000, DMG_BLAST | DMG_ALWAYSGIB, turret.m_hOwner);
						}

						// Explosive ammo visual effect and stagger
						if (turret.m_iDamageType == DMG_STUMBLE)
						{
							if (g_bTurretParticlesEnabled)
							{
								local hExplodeFX = SpawnEntityFromTable("info_particle_system", {
									effect_name = "impact_explosive_ammo_small"
									origin = tbl["position"]
									start_active = 1
								});
								AcceptEntityInput(hExplodeFX, "Stop", "", 0.3);
								DoEntFire("!self", "Kill", "", 1.0, hExplodeFX, hExplodeFX);

								local hExplodeFX2 = SpawnEntityFromTable("info_particle_system", {
									effect_name = "impact_explosive_ammo_large"
									origin = tbl["position"]
									start_active = 1
								});
								AcceptEntityInput(hExplodeFX2, "Stop", "", 0.3);
								DoEntFire("!self", "Kill", "", 1.0, hExplodeFX2, hExplodeFX2);
							}

							if(tbl["target"].GetClassname() == "player")
							{
								if(tbl["target"].GetZombieType() <= 8)
									tbl["target"].Stagger(Vector(0, 0, 50));
							}
						}

						// Fire ammo stagger
						if (turret.m_iDamageType == DMG_BURN)
						{
							if(tbl["target"].GetClassname() == "player")
							{
								if(tbl["target"].GetZombieType() <= 8)
									tbl["target"].Stagger(Vector(0, 0, 50));
							}
						}
						
					}
				}
			}

			// Persistent laser sight
			if (g_bLaserEnabled && turret.m_hMachineGun.IsValid())
			{
				local laserMuzzle = turret.m_hMachineGun.GetOrigin() + turret.m_hMachineGun.GetAngles().Up() * 4 + turret.m_hMachineGun.GetAngles().Forward() * 38;
				local laserDir = turret.m_hMachineGun.GetAngles().Forward();
				local laserRange = GetConVarFloat(g_ConVar_TurretRange);
				local laserEnd = DoTraceLine(laserMuzzle, laserDir, eTrace.Type_Pos, laserRange, eTrace.Mask_Shot, null);
				Line(laserMuzzle, laserEnd ? laserEnd : (laserMuzzle + laserDir * laserRange), 0.1, 255, 50, 0);
			}
			// Idle sweep: sine-wave oscillation when no target found
			if (turret.m_flNextShootTime + eTurret.IdleTime < Time())
			{
				if (("m_flSweepOffset" in turret) && ("m_flLastSweepTime" in turret))
				{
					if (turret.m_flLastSweepTime < 0.001)
						turret.m_flLastSweepTime = Time();

					local elapsed = Time() - turret.m_flLastSweepTime;
					local halfArc = g_flGnomeTurretSweepArc / 2.0;
					local rate = g_flGnomeTurretSweepSpeed * (PI / 180.0);
					turret.m_flSweepOffset = halfArc * sin(rate * elapsed);

					local sweepAngles = QAngle(turret.m_eDefaultAngles.x, turret.m_eDefaultAngles.y + turret.m_flSweepOffset, turret.m_eDefaultAngles.z);

					turret.m_hMachineGun.SetAngles(sweepAngles);
					local vecMuzzle = turret.m_hMachineGun.GetOrigin() + turret.m_hMachineGun.GetAngles().Up() * 4 + turret.m_hMachineGun.GetAngles().Forward() * 38;
					local sweepDir = turret.m_hMachineGun.GetAngles().Forward();
					local traceEnd = DoTraceLine(vecMuzzle, sweepDir, eTrace.Type_Pos, GetConVarFloat(g_ConVar_TurretRange), eTrace.Mask_Shot, null);
					local range = GetConVarFloat(g_ConVar_TurretRange);
					Line(vecMuzzle, traceEnd ? traceEnd : (vecMuzzle + sweepDir * range), 0.15, 255, 50, 0);
				}
			}
			// if(Time() == TurretDataSaveTimer + 0.5)
			// {
			// 	if(RandomInt(0,100) <= 100)
			// 	{
			// 		if(IsCertainSurvivor(turret.m_hOwner, NickModel))
			// 		{
			// 			GnomeTurretAmmoNick = turret.m_iAmmo;
			// 		}
			// 		else if(IsCertainSurvivor(turret.m_hOwner, CoachModel))
			// 		{
			// 			GnomeTurretAmmoCoach = turret.m_iAmmo;
			// 		}
			// 		else if(IsCertainSurvivor(turret.m_hOwner, EllisModel))
			// 		{
			// 			GnomeTurretAmmoEllis = turret.m_iAmmo;
			// 		}
			// 		else if(IsCertainSurvivor(turret.m_hOwner, RochelleModel))
			// 		{
			// 			GnomeTurretAmmoRochelle = turret.m_iAmmo;
			// 		}
			// 		else if(IsCertainSurvivor(turret.m_hOwner, BillModel))
			// 		{
			// 			GnomeTurretAmmoBill = turret.m_iAmmo;
			// 		}
			// 		else if(IsCertainSurvivor(turret.m_hOwner, LouisModel))
			// 		{
			// 			GnomeTurretAmmoLouis = turret.m_iAmmo;
			// 		}
			// 		else if(IsCertainSurvivor(turret.m_hOwner, FrancisModel))
			// 		{
			// 			GnomeTurretAmmoFrancis = turret.m_iAmmo;
			// 		}
			// 		else if(IsCertainSurvivor(turret.m_hOwner, ZoeyModel))
			// 		{
			// 			GnomeTurretAmmoZoey = turret.m_iAmmo;
			// 		}
					
			// 	}
			// 	GenerateGnomeVirtualInventory();
			// }
			// if (turret.m_iAmmo <= 0)
			// {
			// 	foreach (turret in g_aTurretList)
			// 	{
			// 		foreach (idx, _turret in g_aTurretList)
			// 		{
			// 			switch(RandomInt(0, 1))
			// 			{
			// 				case 0:
			// 					turret.m_hOwner.PrecacheScriptSound("Moustachio_STRENGTHATTRACT_RANDOM");
			// 					EmitSoundOnClient("Moustachio_STRENGTHATTRACT_RANDOM", turret.m_hOwner);
			// 					break;
							
			// 				case 1:
			// 					turret.m_hOwner.PrecacheScriptSound("Moustachio_STRENGTHATTRACT_RANDOMLAUGH");
			// 					EmitSoundOnClient("Moustachio_STRENGTHATTRACT_RANDOMLAUGH", turret.m_hOwner);
			// 					break;
							
							
			// 			}
			// 			ShowSpecialHint(turret.m_hOwner, "GNOME: 'My mission to protect you is done. See you again, hooman...!'", AlertIconWhite, 0.1, 5);
						
			// 			foreach (ent in turret.m_aBipod) if (ent.IsValid()) ent.Kill();
			// 			if (turret.m_hMachineGun.IsValid()) turret.m_hMachineGun.Kill();
			// 			if (turret.m_hTracerEntity.IsValid()) turret.m_hTracerEntity.Kill();
			// 			if (turret.m_hLaserEntity.IsValid()) turret.m_hLaserEntity.Kill();
			// 			g_aTurretList.remove(idx);
			// 			break;
			// 			if(turret.m_aMachineGunAmmo[0] <= 0 || turret.m_aMachineGunAmmo[1] <= 0)
			// 			{
			// 				ShowSpecialHint(turret.m_hOwner, "GNOME: 'My mission to protect you is done. See you again, hooman...!'", AlertIconWhite, 0.1, 5);
							
			// 				foreach (ent in turret.m_aBipod) if (ent.IsValid()) ent.Kill();
			// 				if (turret.m_hMachineGun.IsValid()) turret.m_hMachineGun.Kill();
						// 	if (turret.m_hTracerEntity.IsValid()) turret.m_hTracerEntity.Kill();
						// 	g_aTurretList.remove(idx);
						// 	break;
							
						// }
					// }
					
				// }
			// }
		}
	}

}

function OnGameplayStart_PostSpawn()
{
	ReplaceWeaponSpawn("weapon_upgradepack_incendiary_spawn", "weapon_gnome");
	
}

function PrintTurretHelp(hPlayer, sValue)
{
	if (sValue != CC_EMPTY_ARGUMENT && sValue != "")
	{
		if (!hPlayer.IsHost())
		{
			ShowSpecialHint(hPlayer, "Only the host can change the turret limit.", ForbiddenIcon, 0.1, 3);
			return;
		}
		local val = strip(split(sValue, " ")[0]).tointeger();
		g_iMaxTurrets = (val < 0) ? 0 : ((val > 32) ? 32 : val);
		sayf("* Turret limit set to %d", g_iMaxTurrets);
		return;
	}
	sayf("* === Turret Commands ===");
	sayf("* !ta default|explosive|fire - Set ammo type");
	sayf("* !tr [all] - Remove turret(s)");
	sayf("* !tm - Toggle machine gun mode");
	sayf("* !td - Toggle debug mode");
	sayf("* !ts <speed> - Set sweep speed (deg/sec)");
	sayf("* !tarc <deg> - Set sweep arc (degrees total)");
	sayf("* !tde 0|1 - Toggle demolition mode");
	sayf("* !thelp - Show this help");
	sayf("* !tl - Toggle laser sight");
	sayf("* Turrets placed: %d/%d", g_iTurretCount, g_iMaxTurrets);
}
function AdditionalClassMethodsInjected()
{
	RegisterChatCommand("!td", ToggleDebugMode, true);
	RegisterChatCommand("!tr", RemoveTurret, true, true);
	RegisterChatCommand("!ta", ChangeTurretAmmo, true, true);
	RegisterChatCommand("!tm", ToggleTurretMode, true);

	RegisterChatCommand("!ts", function(kent, sValue)
	{
		if (!IsHostPlayer(kent))
		{
			ShowSpecialHint(kent, "Only the host can change sweep settings.", ForbiddenIcon, 0.1, 3);
			return;
		}
		local val = strip(split(sValue, " ")[0]).tofloat();
		if (val < 1.0) val = 20.0;
		if (val > 360.0) val = 20.0;
		g_flGnomeTurretSweepSpeed = val;
		GenerateGnomeTurretCfgFile();
		ShowSpecialHint(kent, ("Turret sweep speed set to " + val + " degrees/sec."), LampIcon, 0.1, 3);
		printl("[Turret] Sweep speed set to " + val + " deg/sec by " + kent.GetPlayerName());
	}, "", 0);

	RegisterChatCommand("!tarc", function(kent, sValue)
	{
		if (!IsHostPlayer(kent))
		{
			ShowSpecialHint(kent, "Only the host can change sweep settings.", ForbiddenIcon, 0.1, 3);
			return;
		}
		local val = strip(split(sValue, " ")[0]).tofloat();
		if (val < 2.0) val = 90.0;
		if (val > 360.0) val = 90.0;
		g_flGnomeTurretSweepArc = val;
		GenerateGnomeTurretCfgFile();
		ShowSpecialHint(kent, ("Turret sweep arc set to " + val + " degrees total."), LampIcon, 0.1, 3);
		printl("[Turret] Sweep arc set to " + val + " deg by " + kent.GetPlayerName());
	}, "", 0);
	RegisterChatCommand("!tde", ToggleDemolitionMode, true, true);
	RegisterChatCommand("!thelp", PrintTurretHelp, true, true);
	RegisterChatCommand("!tl", ToggleLaser, true);
	}


RegisterOnTickFunction("Turret_Think");

RegisterButtonListener(IN_ATTACK, "OnAttackPress", eButtonType.Pressed, eTeam.Survivor);
RegisterButtonListener(IN_USE, "OnUsePress", eButtonType.Pressed, eTeam.Survivor);

PrecacheEntityFromTable({classname = "prop_dynamic", model = "models/props_urban/wood_railing_post001.mdl"});
PrecacheEntityFromTable({classname = "ambient_generic", message = "weapons/50cal/50cal_shoot.wav"});

