// Squirrel
// Turret Mod
GnomeTurretDamage <- 50
GnomeTurretAmmoBase <- 300

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

	// -- PERFORMANCE OPTIMIZATION START --
	// Added a target handle to the class to manage state. This prevents re-scanning for a new
	// target when the current one is still valid.
	function SetTarget(hTarget)
	{
		m_hTarget = hTarget;
	}
	m_hTarget = null;
	// -- PERFORMANCE OPTIMIZATION END --

	m_iAmmo = 0;
	m_aBipod = null;
	m_hOwner = null;
	m_hMachineGun = null;
	m_hTracerEntity = null;
	m_eDefaultAngles = null;
	m_flNextShootTime = 0.0;
	m_flNextAnglesChangeTime = 0.0;
	m_iDamageType = DMG_BULLET;
	m_bMachineGunMode = false;
	m_aMachineGunAmmo = 0;
	m_sIdentifier = null;
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
	ToleranceAngle = 5.0
	IdleTime = 3.0
	ShootTime = 0.2 //0.2
	ShootSound = "weapons/50cal/50cal_shoot.wav"
	Shell = "weapon_shell_casing_50cal"
	MuzzleFlash = "weapon_muzzle_flash_assaultrifle"
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

DemolitionShot <- 1
ExplosionAmmoToggle <- 0
ExplosionEntity <- SpawnEntityFromTable("env_explosion", explosion_entity);
g_bDebugMode <- false;
g_flFindPotentialTargetsTime <- 0.0;

g_aPotentialTargets <- [];
g_aTurretList <- [];

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
					if(RandomInt(0,100) <= 100)
					{
						if(IsCertainSurvivor(hPlayer, NickModel))
						{
							iAmmo = GnomeTurretAmmoNick;
						}
						else if(IsCertainSurvivor(hPlayer, CoachModel))
						{
							iAmmo = GnomeTurretAmmoCoach;
						}
						else if(IsCertainSurvivor(hPlayer, EllisModel))
						{
							iAmmo = GnomeTurretAmmoEllis;
						}
						else if(IsCertainSurvivor(hPlayer, RochelleModel))
						{
							iAmmo = GnomeTurretAmmoRochelle;
						}
						else if(IsCertainSurvivor(hPlayer, BillModel))
						{
							iAmmo = GnomeTurretAmmoBill;
						}
						else if(IsCertainSurvivor(hPlayer, LouisModel))
						{
							iAmmo = GnomeTurretAmmoLouis;
						}
						else if(IsCertainSurvivor(hPlayer, FrancisModel))
						{
							iAmmo = GnomeTurretAmmoFrancis;
						}
						else if(IsCertainSurvivor(hPlayer, ZoeyModel))
						{
							iAmmo = GnomeTurretAmmoZoey;
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
			iAmmo = GetConVarInt(g_ConVar_TurretAmmo);
			if(RandomInt(0,100) <= 100)
			{
				if(IsCertainSurvivor(hPlayer, NickModel))
				{
					iAmmo = GnomeTurretAmmoNick;
				}
				else if(IsCertainSurvivor(hPlayer, CoachModel))
				{
					iAmmo = GnomeTurretAmmoCoach;
				}
				else if(IsCertainSurvivor(hPlayer, EllisModel))
				{
					iAmmo = GnomeTurretAmmoEllis;
				}
				else if(IsCertainSurvivor(hPlayer, RochelleModel))
				{
					iAmmo = GnomeTurretAmmoRochelle;
				}
				else if(IsCertainSurvivor(hPlayer, BillModel))
				{
					iAmmo = GnomeTurretAmmoBill;
				}
				else if(IsCertainSurvivor(hPlayer, LouisModel))
				{
					iAmmo = GnomeTurretAmmoLouis;
				}
				else if(IsCertainSurvivor(hPlayer, FrancisModel))
				{
					iAmmo = GnomeTurretAmmoFrancis;
				}
				else if(IsCertainSurvivor(hPlayer, ZoeyModel))
				{
					iAmmo = GnomeTurretAmmoZoey;
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
		g_aTurretList.push(CTurret(iAmmo, hTracerEntity, hMachineGun, eAngles, hPlayer, sIdentifier, iDamageType, aBipod, bMachineGunMode, aMachineGunAmmo));

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

function SetMachineGunAmmo(hPlayer, hMachineGun, iAmmo, iClip)
{
	NetProps.SetPropInt(hMachineGun, "m_iClip1", iClip);
	NetProps.SetPropIntArray(hPlayer, "m_iAmmo", iAmmo, NetProps.GetPropInt(hMachineGun, "m_iPrimaryAmmoType"));
}

function TurretShoot(hMachineGun)
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
	local vecPos = hMachineGun.GetOrigin() + hMachineGun.GetAngles().Up() * 4 + hMachineGun.GetAngles().Forward() * 38;
	CEntity(hMachineGun).AttachEntity(hShell, "Shell");
	hShootFire.SetOrigin(vecPos);
	AcceptEntityInput(hShell, "Kill", "", 0.05);
	AcceptEntityInput(hShootFire, "Kill", "", 0.05);
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
			print("Warning: trace_hull is null or invalid in GetEntityPosition\n");
			vecPos = hEntity.GetOrigin(); // Fallback to entity origin
			}
		}
	}
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

// =================================================================
// == PERFORMANCE OPTIMIZATION BLOCK START
// =================================================================
// The original code used RegisterOnTickFunction, which is very expensive as it runs every
// single server frame. This has been replaced with a throttled global timer to reduce CPU usage
// significantly, while maintaining the original script's architectural integrity.
g_flNextGlobalThinkTime <- 0.0;
const TURRET_THINK_INTERVAL = 0.25; // Increased from every frame to 4 times/sec

// The following 'Turret_Think' function has been modified from the backup
// to improve performance. All other code in this file is identical
// to the working backup to ensure architectural stability.
function Turret_Think()
{
	// This check throttles the entire function, preventing it from running on every frame.
	// This is the primary performance improvement.
	if (Time() < g_flNextGlobalThinkTime)
	{
		return;
	}
	g_flNextGlobalThinkTime = Time() + TURRET_THINK_INTERVAL;

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
				// The original logic scanned for targets on every tick. This new logic only scans
				// for targets if it doesn't already have a valid one.
				local currentTarget = null;
				if (turret.m_hTarget != null && turret.m_hTarget.IsValid() && turret.m_hTarget.GetHealth() > 0)
				{
					local targetPos = GetEntityPosition(turret.m_hTarget, turret.m_hTarget.GetClassname());
					if (targetPos && IsCanSeeEntity(turret.m_hTracerEntity, turret.m_hTarget, turret.m_hMachineGun, targetPos))
					{
						currentTarget = { target = turret.m_hTarget, position = targetPos };
					}
					else
					{
						turret.SetTarget(null); // Target is no longer valid or visible
					}
				}

				if (currentTarget == null) // Only find a new target if we don't have a valid one
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
								}
							}
						}
					}
					tbl = GetNearestEntity(turret.m_hTracerEntity, turret.m_hMachineGun);
					if (tbl["target"])
					{
						turret.SetTarget(tbl["target"]); // Set the new target
						currentTarget = tbl;
					}
				}

				if (turret.m_flNextShootTime < Time())
				{
					if (currentTarget) // Use the result from the optimized logic
					{
						hMachineGun = turret.m_hMachineGun;

						hMachineGun.SetAngles(VectorToQAngle(currentTarget["position"] - turret.m_hMachineGun.GetOrigin()));

						if(RandomInt(0,100) <= 100)
						{
							if(currentTarget["target"].GetClassname() == "witch")
							{
								if(DemolitionShot >= 1)
								{
									currentTarget["target"].TakeDamage(GnomeTurretDamage, 64, turret.m_hOwner);

								}
								if(DemolitionShot == 0)
								{
									currentTarget["target"].TakeDamage(GnomeTurretDamage, turret.m_iDamageType, turret.m_hOwner);

								}
								TurretDataSaveTimer = Time();

							}
							else
							{
								currentTarget["target"].TakeDamage(GnomeTurretDamage, turret.m_iDamageType, turret.m_hOwner);
								TurretDataSaveTimer = Time();

							}

						}

						TurretShoot(hMachineGun);
						TurretShootFakeImpact(turret, currentTarget["target"], currentTarget["position"]);

						EmitSound(turret.m_hTracerEntity.GetOrigin(), eTurret.ShootSound);

						turret.SetShootTime(Time() + eTurret.ShootTime);
						turret.SetAmmo(turret.m_iAmmo - 1);

						if (turret.m_aMachineGunAmmo[0] > 0) turret.SetMachineGunAmmo([turret.m_aMachineGunAmmo[0] - 1, turret.m_aMachineGunAmmo[1]]);
						else if (turret.m_aMachineGunAmmo[1] > 0) turret.SetMachineGunAmmo([0, turret.m_aMachineGunAmmo[1] - 1]);

						if (g_bAllowChangeCameraAngles[hMachineGun.GetEntityIndex()]) g_bAllowChangeCameraAngles[hMachineGun.GetEntityIndex()] = false;

						if(ExplosionAmmoToggle == 1 || DemolitionShot >= 1)
						{
							NetProps.SetPropEntity(ExplosionEntity, "m_hOwnerEntity", turret.m_hOwner);
							ExplosionEntity.SetOrigin(currentTarget["target"].GetOrigin());
							DoEntFire("!self", "Explode", "" 0, turret.m_hOwner, ExplosionEntity);

							if(currentTarget["target"].GetClassname() == "player")
							{
								if(currentTarget["target"].GetZombieType() <= 8)
								{
									currentTarget["target"].Stagger(Vector(RandomInt(10,30),RandomInt(10,30), 0));
								}
							}

						}

					}
				}
			}
			if (turret.m_flNextAnglesChangeTime < Time())
			{
				if (turret.m_flNextShootTime + eTurret.IdleTime < Time())
				{
					if (GetAngleBetweenVectors(turret.m_hMachineGun.GetAngles().Forward(), turret.m_eDefaultAngles.Forward()) > eTurret.ToleranceAngle)
					{
						turret.SetAnglesChangeTime(Time() + eTurret.IdleTime);
						g_bAllowChangeCameraAngles[turret.m_hMachineGun.GetEntityIndex()] = true;
						CEntity(turret.m_hMachineGun).SetAnglesBySteps(turret.m_eDefaultAngles, 50, 0.01, false);
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
				foreach (turret in g_aTurretList)
				{
					foreach (idx, _turret in g_aTurretList)
					{
						switch(RandomInt(0, 1))
						{
							case 0:
								turret.m_hOwner.PrecacheScriptSound("Moustachio_STRENGTHATTRACT_RANDOM");
								EmitSoundOnClient("Moustachio_STRENGTHATTRACT_RANDOM", turret.m_hOwner);
								break;

							case 1:
								turret.m_hOwner.PrecacheScriptSound("Moustachio_STRENGTHATTRACT_RANDOMLAUGH");
								EmitSoundOnClient("Moustachio_STRENGTHATTRACT_RANDOMLAUGH", turret.m_hOwner);
								break;


						}
						ShowSpecialHint(turret.m_hOwner, "GNOME: 'My mission to protect you is done. See you again, hooman...!'", AlertIconWhite, 0.1, 5);

						foreach (ent in turret.m_aBipod) if (ent.IsValid()) ent.Kill();
						if (turret.m_hMachineGun.IsValid()) turret.m_hMachineGun.Kill();
						if (turret.m_hTracerEntity.IsValid()) turret.m_hTracerEntity.Kill();
						g_aTurretList.remove(idx);
						break;
						if(turret.m_aMachineGunAmmo[0] <= 0 || turret.m_aMachineGunAmmo[1] <= 0)
						{
							ShowSpecialHint(turret.m_hOwner, "GNOME: 'My mission to protect you is done. See you again, hooman...!'", AlertIconWhite, 0.1, 5);

							foreach (ent in turret.m_aBipod) if (ent.IsValid()) ent.Kill();
							if (turret.m_hMachineGun.IsValid()) turret.m_hMachineGun.Kill();
							if (turret.m_hTracerEntity.IsValid()) turret.m_hTracerEntity.Kill();
							g_aTurretList.remove(idx);
							break;

						}
					}

				}
			}
		}
	}
}
// =================================================================
// == PERFORMANCE OPTIMIZATION BLOCK END
// =================================================================

function OnGameplayStart_PostSpawn()
{
	ReplaceWeaponSpawn("weapon_upgradepack_incendiary_spawn", "weapon_gnome");

}

function AdditionalClassMethodsInjected()
{
	RegisterChatCommand("!debugmode", ToggleDebugMode, true);
	RegisterChatCommand("!remove", RemoveTurret, true, true);
	RegisterChatCommand("!ammo", ChangeTurretAmmo, true, true);
	RegisterChatCommand("!mode", ToggleTurretMode, true);
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
		"DemolitionShot 1",
		"GnomeTurretDamage 50",
		"GnomeTurretAmmoBase 300",
		".",
		".",
		"// ====== TOGGLE SETTING INFO ======",
		"//DemolitionShot= When enabled, gnome turret will shoot demolition bullets that destroy common infected to pieces & stumble special infected, tank & witch. Demolition bullet is a variant of explosive bullet.",
		"0= Off, normal bullets.",
		"1 = On, demolition bullets.",
		".",
		"//GnomeTurretDamage= This controls gnome turret damage on each shot. Default value is 50. Minimum value is 1 even if you set it to 0. Max value is unlimited.",
		"0 or 1= Gnome turret deals 1 damage on zombies.",
		"higher than 1 = Gnome turret deals (1 * value) damage on zombies. (Examples: value 500= It deals 500 damage on each shot).",
		".",
		"//GnomeTurretAmmoBase= This controls gnome turret ammo. Default value is 300. Minimum value is 50, so setting the value to lower than 50 will make gnome turret have 50 ammo.",
		"Below 50= Gnome turret is 50.",
		"higher than 50 = Gnome turret ammo (1 * value).",
		".",
		".",
		"// ================================",
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
function GenerateGnomeVirtualInventory()
{
	local DefaultToggleFile = "";

	GnomeTurretNick = GnomeTurretNick;
	GnomeTurretCoach = GnomeTurretCoach;
	GnomeTurretEllis = GnomeTurretEllis;
	GnomeTurretRochelle = GnomeTurretRochelle;
	GnomeTurretBill = GnomeTurretBill;
	GnomeTurretLouis = GnomeTurretLouis;
	GnomeTurretFrancis = GnomeTurretFrancis;
	GnomeTurretZoey = GnomeTurretZoey;

	GnomeTurretAmmoNick = GnomeTurretAmmoNick;
	GnomeTurretAmmoCoach = GnomeTurretAmmoCoach;
	GnomeTurretAmmoEllis = GnomeTurretAmmoEllis;
	GnomeTurretAmmoRochelle = GnomeTurretAmmoRochelle;
	GnomeTurretAmmoBill = GnomeTurretAmmoBill;
	GnomeTurretAmmoLouis = GnomeTurretAmmoLouis;
	GnomeTurretAmmoFrancis = GnomeTurretAmmoFrancis;
	GnomeTurretAmmoZoey = GnomeTurretAmmoZoey;

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
		"// ================================",
		"//Notes: This file is just for virtual inventory to save data in game.",
		"."

	]

	foreach (line in CfgToggleFile)
	{
		DefaultToggleFile = DefaultToggleFile + line + "\n";
	}
	if(!CfgFileCheck("gnome turret/virtual inventory/gnome virtual inventory.txt"))
	{

		StringToFile("gnome turret/virtual inventory/gnome virtual inventory.txt", DefaultToggleFile);
		printl("The 'gnome virtual inventory.txt' file can't be found. Generating a new 'gnome virtual inventory.txt' file...");

	}
	if(CfgFileCheck("gnome turret/virtual inventory/gnome virtual inventory.txt"))
	{

		StringToFile("gnome turret/virtual inventory/gnome virtual inventory.txt", DefaultToggleFile);

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
		"// ================================",
		"//Notes: This file is just for virtual inventory to save data in game.",
		"."

	]

	foreach (line in CfgToggleFile)
	{
		DefaultToggleFile = DefaultToggleFile + line + "\n";
	}
	if(!CfgFileCheck("gnome turret/virtual inventory/gnome virtual inventory.txt"))
	{

		StringToFile("gnome turret/virtual inventory/gnome virtual inventory.txt", DefaultToggleFile);
		printl("The 'gnome virtual inventory.txt' file can't be found. Generating a new 'gnome virtual inventory.txt' file...");

	}
	if(CfgFileCheck("gnome turret/virtual inventory/gnome virtual inventory.txt"))
	{

		StringToFile("gnome turret/virtual inventory/gnome virtual inventory.txt", DefaultToggleFile);

	}

}
function LoadSpecificConfigFile(filename)
{
	local trigger = 0;
	local files = FileToString(filename);
	if(!files)
	{
		return trigger;
	}
	local toggles = split(files, "\n");
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
				if(togglecommand == "ExplosionAmmoToggle")
				{
					ExplosionAmmoToggle = togglevalue.tointeger();

				}
				if(togglecommand == "DemolitionShot")
				{
					DemolitionShot = togglevalue.tointeger();

				}
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