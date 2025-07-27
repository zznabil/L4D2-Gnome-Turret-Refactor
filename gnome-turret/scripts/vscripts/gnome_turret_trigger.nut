// NOTE: Global turret settings are now defined in turret.nut to avoid conflicts
// This file only handles inventory management and trigger events

GnomeTurretNick <- 0
GnomeTurretCoach <- 0
GnomeTurretEllis <- 0
GnomeTurretRochelle <- 0
GnomeTurretBill <- 0
GnomeTurretLouis <- 0
GnomeTurretFrancis <- 0
GnomeTurretZoey <- 0

GnomeTurretAmmoNick <- 0
GnomeTurretAmmoCoach <- 0
GnomeTurretAmmoEllis <- 0
GnomeTurretAmmoRochelle <- 0
GnomeTurretAmmoBill <- 0
GnomeTurretAmmoLouis <- 0
GnomeTurretAmmoFrancis <- 0
GnomeTurretAmmoZoey <- 0

GnomeLimit <- 2
// DemolitionShot <- 1 // DISABLED - Demolition mode removed
ExplosionAmmoToggle <- 0
ExplosionEntity <- null;

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
		"// ====== PERFORMANCE SETTINGS ======",
		"GnomeTurretThinkRateMS " + GnomeTurretThinkRateMS,
		"GnomeTurretFireRateMS " + GnomeTurretFireRateMS,
		".",
		"// ====== AIMING SYSTEM ======",
		"GnomeTurretAimMode " + GnomeTurretAimMode,
		"GnomeTurretRotationSpeed " + GnomeTurretRotationSpeed,
		".",
		"// ====== TURRET LIMITS ======",
		"GnomeTurretMaxCount " + GnomeTurretMaxCount,
		"g_iMaxTurretsPerTarget " + g_iMaxTurretsPerTarget,
		".",
		"// ====== FEATURE TOGGLES ======",
		// "GnomeTurretDemolitionMode " + GnomeTurretDemolitionMode, // DISABLED - Demolition removed
		"GnomeTurretExplosiveMode " + GnomeTurretExplosiveMode,
		"GnomeTurretFireEnabled " + GnomeTurretFireEnabled,
		"GnomeTurretDebugMode " + GnomeTurretDebugMode,
		".",
		"// ====== LEGACY SETTINGS ======",
		// "DemolitionShot " + DemolitionShot, // DISABLED - Demolition removed
		"GnomeTurretDamage " + GnomeTurretDamage,
		"GnomeTurretAmmoBase " + GnomeTurretAmmoBase,
		"GnomeTurretRange " + GnomeTurretRange,
		".",
		".",
		"// ====== SETTING DESCRIPTIONS ======",
		"//GnomeTurretThinkRateMS= Turret think rate in milliseconds (75-250ms, default 75)",
		"//GnomeTurretFireRateMS= Turret fire rate in milliseconds (75-250ms, default 75)",
		"//GnomeTurretAimMode= 0=Aimbot (instant), 1=Realistic (default)",
		"//GnomeTurretRotationSpeed= Rotation speed for realistic aiming (default 50)",
		"//GnomeTurretMaxCount= Maximum turrets server-wide (default 8, configurable 1-50)",
		"//g_iMaxTurretsPerTarget= Max turrets per target for performance (default 2, range 1-" + GnomeTurretMaxCount + ")",
		// "//GnomeTurretDemolitionMode= 0=Off, 1=On (default)", // DISABLED - Demolition removed
		"//GnomeTurretExplosiveMode= 0=Off (default), 1=On",
		"//GnomeTurretFireEnabled= 0=Disable firing, 1=Enable firing (default)",
		"//GnomeTurretDebugMode= 0=Off (default), 1=On",
		// "//DemolitionShot= Legacy setting for demolition bullets", // DISABLED - Demolition removed
		"//GnomeTurretDamage= Damage per shot (default 50)",
		"//GnomeTurretAmmoBase= Base ammo amount (default 300)",
		"//GnomeTurretRange= Turret range (default 1000)",
		".",
		"// =================================",
		"//Notes: Press 'TAB + SHOVE' & shove any objects when carrying gnome to store gnome to virtual inventory.",
		"//Notes 2: Press 'TAB + CTRL + JUMP' to pick gnome from virtual inventory.",
		"//Notes 3: This cfg file is generated automatically and loaded when placing turrets.",
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
		"// =================================",
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
	"// =================================",
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
				if(togglecommand == "ExplosionAmmoToggle")
				{
					ExplosionAmmoToggle = togglevalue.tointeger();
					
				}
				// DISABLED - Demolition mode removed
			// if(togglecommand == "DemolitionShot")
			// {
			//		DemolitionShot = togglevalue.tointeger();
			//		
		// }
				if(togglecommand == "GnomeTurretDamage")
				{
					if(togglevalue.tofloat() <= 1)
					{
						GnomeTurretDamage = 1;
					}
					if(togglevalue.tofloat() > 1)
					{
						GnomeTurretDamage = togglevalue.tofloat();
						
					}
					
				}
				if(togglecommand == "GnomeTurretAmmoBase")
				{
					GnomeTurretAmmoBase = togglevalue.tointeger();
				}
				if(togglecommand == "GnomeTurretThinkRateMS")
			{
				GnomeTurretThinkRateMS = togglevalue.tointeger();
				if (GnomeTurretThinkRateMS < 75) GnomeTurretThinkRateMS = 75;
				if (GnomeTurretThinkRateMS > 250) GnomeTurretThinkRateMS = 250;
				printl("[CONFIG] Set GnomeTurretThinkRateMS to " + GnomeTurretThinkRateMS);
			}
			if(togglecommand == "GnomeTurretFireRateMS")
			{
				GnomeTurretFireRateMS = togglevalue.tointeger();
				// Validate fire rate MS (75-250ms corresponds to 240-800 RPM)
				if (GnomeTurretFireRateMS < 75) GnomeTurretFireRateMS = 75;
				if (GnomeTurretFireRateMS > 250) GnomeTurretFireRateMS = 250;
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
				local iOldValue = GnomeTurretMaxCount;
				GnomeTurretMaxCount = togglevalue.tointeger();
				printl("[CONFIG] Set GnomeTurretMaxCount from " + iOldValue + " to " + GnomeTurretMaxCount);
			}
			if(togglecommand == "g_iMaxTurretsPerTarget")
			{
				local iOldValue = g_iMaxTurretsPerTarget;
				g_iMaxTurretsPerTarget = togglevalue.tointeger();
				if (g_iMaxTurretsPerTarget < 1) g_iMaxTurretsPerTarget = 1;
				if (g_iMaxTurretsPerTarget > GnomeTurretMaxCount) g_iMaxTurretsPerTarget = GnomeTurretMaxCount;
				printl("[CONFIG] Set g_iMaxTurretsPerTarget from " + iOldValue + " to " + g_iMaxTurretsPerTarget);
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

function GetItemAmmo(kent, itemclass)
{
	local playerweapon = null;
	local loopCounter = 0;
	local maxIterations = 100; // Safety limit
	while(playerweapon = Entities.FindByClassname(playerweapon, itemclass))
	{
		if(++loopCounter > maxIterations)
		{
			printl("Warning: GetItemAmmo loop exceeded maximum iterations");
			break;
		}
		if(playerweapon.GetOwnerEntity() == kent)
		{
			try {
				return NetProps.GetPropIntArray(kent, "m_iAmmo", NetProps.GetPropInt(playerweapon, "m_iPrimaryAmmoType"));
			} catch (e) {
				printl("Warning: NetProps access failed in GetItemAmmo: " + e);
				return null;
			}
		}
	}
	return null;
}
function SetItemAmmo(kent, itemclass, ammo)
{
	local playerweapon = null;
	local loopCounter = 0;
	local maxIterations = 100; // Safety limit
	while(playerweapon = Entities.FindByClassname(playerweapon, itemclass))
	{
		if(++loopCounter > maxIterations)
		{
			printl("Warning: SetItemAmmo loop exceeded maximum iterations");
			break;
		}
		if(playerweapon.GetOwnerEntity() == kent)
		{
			try {
				return NetProps.SetPropIntArray(kent, "m_iAmmo", ammo, NetProps.GetPropInt(playerweapon, "m_iPrimaryAmmoType"));
			} catch (e) {
				printl("Warning: NetProps access failed in SetItemAmmo: " + e);
				return null;
			}
		}
	}
	return null;
}

function IsCertainSurvivor(kent, certainsurv)
{
	local player = null;
	local loopCounter = 0;
	local maxIterations = 100; // Safety limit
	while(player = Entities.FindByModel(player, certainsurv))
	{
		if(++loopCounter > maxIterations)
		{
			printl("Warning: IsCertainSurvivor loop exceeded maximum iterations");
			break;
		}
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
function GetActiveMainWeapon(player)
{
	local weapon = player.GetActiveWeapon();
	
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
			try {
				if (NetProps.HasProp(kent, "m_hActiveWeapon")) {
					return NetProps.SetPropEntity(kent, "m_hActiveWeapon", item2);
				}
			} catch (e) {
				printl("Warning: NetProps access failed in ForcedToSwitchSecondary2: " + e);
			}
			
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


function OnGameEvent_final_reportscreen(event)
{
	GenerateGnomeVirtualInventoryReset();
	
}
function OnGameEvent_final_win(event)
{
	GenerateGnomeVirtualInventoryReset();
	
}
function OnGameEvent_finale_vehicle_leaving(event)
{
	GenerateGnomeVirtualInventoryReset();
	
}
function OnGameEvent_player_disconnect(event)
{
	local kent = null;
	if("userid" in event)
	{
		kent = GetPlayerFromUserID(event.userid);
	}
	if(kent && kent.IsValid() && kent.IsSurvivor())
	{
		if(IsCertainSurvivor(kent, NickModel))
		{
			GnomeTurretNick = 0;
			GnomeTurretAmmoNick = GnomeTurretAmmoBase;
		}
		else if(IsCertainSurvivor(kent, CoachModel))
		{
			GnomeTurretCoach = 0;
			GnomeTurretAmmoCoach = GnomeTurretAmmoBase;
		}
		else if(IsCertainSurvivor(kent, EllisModel))
		{
			GnomeTurretEllis = 0;
			GnomeTurretAmmoEllis = GnomeTurretAmmoBase;
		}
		else if(IsCertainSurvivor(kent, RochelleModel))
		{
			GnomeTurretRochelle = 0;
			GnomeTurretAmmoRochelle = GnomeTurretAmmoBase;
		}
		else if(IsCertainSurvivor(kent, BillModel))
		{
			GnomeTurretBill = 0;
			GnomeTurretAmmoBill = GnomeTurretAmmoBase;
		}
		else if(IsCertainSurvivor(kent, LouisModel))
		{
			GnomeTurretLouis = 0;
			GnomeTurretAmmoLouis = GnomeTurretAmmoBase;
		}
		else if(IsCertainSurvivor(kent, FrancisModel))
		{
			GnomeTurretFrancis = 0;
			GnomeTurretAmmoFrancis = GnomeTurretAmmoBase;
		}
		else if(IsCertainSurvivor(kent, ZoeyModel))
		{
			GnomeTurretZoey = 0;
			GnomeTurretAmmoZoey = GnomeTurretAmmoBase;
		}
		GenerateGnomeVirtualInventory();
	}
}
function OnGameEvent_player_first_spawn(event)
{
	local kent = null;
	if("userid" in event)
	{
		kent = GetPlayerFromUserID(event.userid);
	}
	if(kent && kent.IsValid() && kent.IsSurvivor())
	{
		if(IsCertainSurvivor(kent, NickModel))
		{
			GnomeTurretNick = 0;
			GnomeTurretAmmoNick = GnomeTurretAmmoBase;
		}
		else if(IsCertainSurvivor(kent, CoachModel))
		{
			GnomeTurretCoach = 0;
			GnomeTurretAmmoCoach = GnomeTurretAmmoBase;
		}
		else if(IsCertainSurvivor(kent, EllisModel))
		{
			GnomeTurretEllis = 0;
			GnomeTurretAmmoEllis = GnomeTurretAmmoBase;
		}
		else if(IsCertainSurvivor(kent, RochelleModel))
		{
			GnomeTurretRochelle = 0;
			GnomeTurretAmmoRochelle = GnomeTurretAmmoBase;
		}
		else if(IsCertainSurvivor(kent, BillModel))
		{
			GnomeTurretBill = 0;
			GnomeTurretAmmoBill = GnomeTurretAmmoBase;
		}
		else if(IsCertainSurvivor(kent, LouisModel))
		{
			GnomeTurretLouis = 0;
			GnomeTurretAmmoLouis = GnomeTurretAmmoBase;
		}
		else if(IsCertainSurvivor(kent, FrancisModel))
		{
			GnomeTurretFrancis = 0;
			GnomeTurretAmmoFrancis = GnomeTurretAmmoBase;
		}
		else if(IsCertainSurvivor(kent, ZoeyModel))
		{
			GnomeTurretZoey = 0;
			GnomeTurretAmmoZoey = GnomeTurretAmmoBase;
		}
		GenerateGnomeVirtualInventory();
	}
}

function OnGameEvent_player_jump(event)
{
	local kent = GetPlayerFromUserID(event.userid);

	if(kent && kent.IsValid() && kent.IsSurvivor())
	{
		if(GetButtonPressed(kent, ScoreButton) && GetButtonPressed(kent, DuckButton))
		{
			if(GetActiveMainWeapon(kent) != "weapon_gnome")
			{
				// Removed LoadSpecificConfigFile call to preserve custom turret settings
				if(IsCertainSurvivor(kent, NickModel))
				{
					if(GnomeTurretNick > 0)
					{
						GnomeTurretNick--;
						local storedAmmo = GnomeTurretAmmoNick;
						kent.GiveItem("gnome");
						local invTable = {};
						GetInvTable(kent, invTable);
						local newWeapon = null;
						if("slot1" in invTable) newWeapon = invTable.slot1;
						if(newWeapon && newWeapon.GetClassname() == "weapon_gnome")
						{
							CEntity(newWeapon).SetScriptScopeVar("turret_scope", {ammo = storedAmmo});
							try {
								if (NetProps.HasProp(kent, "m_hActiveWeapon")) {
									NetProps.SetPropEntity(kent, "m_hActiveWeapon", newWeapon);
								}
							} catch (e) {
								printl("[OnGameEvent_player_use] Error setting active weapon: " + e);
							}
							ShowSpecialHint(kent, "Gnome obtained...", GiftIcon, 0.1, 3);
						}
						else
						{
							ShowSpecialHint(kent, "Could not obtain gnome! Slot occupied?", ForbiddenIcon, 0.1, 3);
						}
						if(GnomeTurretNick < 0) GnomeTurretNick = 0;
					}
					else
					{
						ShowSpecialHint(kent, "No gnomes in inventory!", ForbiddenIcon, 0.1, 3);
					}
				}
				else if(IsCertainSurvivor(kent, CoachModel))
				{
					if(GnomeTurretCoach > 0)
					{
						GnomeTurretCoach--;
						local storedAmmo = GnomeTurretAmmoCoach;
						kent.GiveItem("gnome");
						local invTable = {};
						GetInvTable(kent, invTable);
						local newWeapon = null;
						if("slot1" in invTable) newWeapon = invTable.slot1;
						if(newWeapon && newWeapon.GetClassname() == "weapon_gnome")
						{
							CEntity(newWeapon).SetScriptScopeVar("turret_scope", {ammo = storedAmmo});
							try {
								if (NetProps.HasProp(kent, "m_hActiveWeapon")) {
									NetProps.SetPropEntity(kent, "m_hActiveWeapon", newWeapon);
								}
							} catch (e) {
								printl("[OnGameEvent_player_use] Error setting active weapon: " + e);
							}
							ShowSpecialHint(kent, "Gnome obtained...", GiftIcon, 0.1, 3);
						}
						else
						{
							ShowSpecialHint(kent, "Could not obtain gnome! Slot occupied?", ForbiddenIcon, 0.1, 3);
						}
						if(GnomeTurretCoach < 0) GnomeTurretCoach = 0;
					}
					else
					{
						ShowSpecialHint(kent, "No gnomes in inventory!", ForbiddenIcon, 0.1, 3);
					}
				}
				else if(IsCertainSurvivor(kent, EllisModel))
				{
					if(GnomeTurretEllis > 0)
					{
						GnomeTurretEllis--;
						local storedAmmo = GnomeTurretAmmoEllis;
						kent.GiveItem("gnome");
						local invTable = {};
						GetInvTable(kent, invTable);
						local newWeapon = null;
						if("slot1" in invTable) newWeapon = invTable.slot1;
						if(newWeapon && newWeapon.GetClassname() == "weapon_gnome")
						{
							CEntity(newWeapon).SetScriptScopeVar("turret_scope", {ammo = storedAmmo});
							try {
								if (NetProps.HasProp(kent, "m_hActiveWeapon")) {
									NetProps.SetPropEntity(kent, "m_hActiveWeapon", newWeapon);
								}
							} catch (e) {
								printl("[OnGameEvent_player_use] Error setting active weapon: " + e);
							}
							ShowSpecialHint(kent, "Gnome obtained...", GiftIcon, 0.1, 3);
						}
						else
						{
							ShowSpecialHint(kent, "Could not obtain gnome! Slot occupied?", ForbiddenIcon, 0.1, 3);
						}
						if(GnomeTurretEllis < 0) GnomeTurretEllis = 0;
					}
					else
					{
						ShowSpecialHint(kent, "No gnomes in inventory!", ForbiddenIcon, 0.1, 3);
					}
				}
				else if(IsCertainSurvivor(kent, RochelleModel))
				{
					if(GnomeTurretRochelle > 0)
					{
						GnomeTurretRochelle--;
						local storedAmmo = GnomeTurretAmmoRochelle;
						kent.GiveItem("gnome");
						local invTable = {};
						GetInvTable(kent, invTable);
						local newWeapon = null;
						if("slot1" in invTable) newWeapon = invTable.slot1;
						if(newWeapon && newWeapon.GetClassname() == "weapon_gnome")
						{
							CEntity(newWeapon).SetScriptScopeVar("turret_scope", {ammo = storedAmmo});
							try {
								if (NetProps.HasProp(kent, "m_hActiveWeapon")) {
									NetProps.SetPropEntity(kent, "m_hActiveWeapon", newWeapon);
								}
							} catch (e) {
								printl("[OnGameEvent_player_use] Error setting active weapon: " + e);
							}
							ShowSpecialHint(kent, "Gnome obtained...", GiftIcon, 0.1, 3);
						}
						else
						{
							ShowSpecialHint(kent, "Could not obtain gnome! Slot occupied?", ForbiddenIcon, 0.1, 3);
						}
						if(GnomeTurretRochelle < 0) GnomeTurretRochelle = 0;
					}
					else
					{
						ShowSpecialHint(kent, "No gnomes in inventory!", ForbiddenIcon, 0.1, 3);
					}
				}
				else if(IsCertainSurvivor(kent, BillModel))
				{
					if(GnomeTurretBill > 0)
					{
						GnomeTurretBill--;
						local storedAmmo = GnomeTurretAmmoBill;
						kent.GiveItem("gnome");
						local invTable = {};
						GetInvTable(kent, invTable);
						local newWeapon = null;
						if("slot1" in invTable) newWeapon = invTable.slot1;
						if(newWeapon && newWeapon.GetClassname() == "weapon_gnome")
						{
							CEntity(newWeapon).SetScriptScopeVar("turret_scope", {ammo = storedAmmo});
							try {
								if (NetProps.HasProp(kent, "m_hActiveWeapon")) {
									NetProps.SetPropEntity(kent, "m_hActiveWeapon", newWeapon);
								}
							} catch (e) {
								printl("[OnGameEvent_player_use] Error setting active weapon: " + e);
							}
							ShowSpecialHint(kent, "Gnome obtained...", GiftIcon, 0.1, 3);
						}
						else
						{
							ShowSpecialHint(kent, "Could not obtain gnome! Slot occupied?", ForbiddenIcon, 0.1, 3);
						}
						if(GnomeTurretBill < 0) GnomeTurretBill = 0;
					}
					else
					{
						ShowSpecialHint(kent, "No gnomes in inventory!", ForbiddenIcon, 0.1, 3);
					}
				}
				else if(IsCertainSurvivor(kent, LouisModel))
				{
					if(GnomeTurretLouis > 0)
					{
						GnomeTurretLouis--;
						local storedAmmo = GnomeTurretAmmoLouis;
						kent.GiveItem("gnome");
						local invTable = {};
						GetInvTable(kent, invTable);
						local newWeapon = null;
						if("slot1" in invTable) newWeapon = invTable.slot1;
						if(newWeapon && newWeapon.GetClassname() == "weapon_gnome")
						{
							CEntity(newWeapon).SetScriptScopeVar("turret_scope", {ammo = storedAmmo});
							try {
								if (NetProps.HasProp(kent, "m_hActiveWeapon")) {
									NetProps.SetPropEntity(kent, "m_hActiveWeapon", newWeapon);
								}
							} catch (e) {
								printl("[OnGameEvent_player_use] Error setting active weapon: " + e);
							}
							ShowSpecialHint(kent, "Gnome obtained...", GiftIcon, 0.1, 3);
						}
						else
						{
							ShowSpecialHint(kent, "Could not obtain gnome! Slot occupied?", ForbiddenIcon, 0.1, 3);
						}
						if(GnomeTurretLouis < 0) GnomeTurretLouis = 0;
					}
					else
					{
						ShowSpecialHint(kent, "No gnomes in inventory!", ForbiddenIcon, 0.1, 3);
					}
				}
				else if(IsCertainSurvivor(kent, FrancisModel))
				{
					if(GnomeTurretFrancis > 0)
					{
						GnomeTurretFrancis--;
						local storedAmmo = GnomeTurretAmmoFrancis;
						kent.GiveItem("gnome");
						local invTable = {};
						GetInvTable(kent, invTable);
						local newWeapon = null;
						if("slot1" in invTable) newWeapon = invTable.slot1;
						if(newWeapon && newWeapon.GetClassname() == "weapon_gnome")
						{
							CEntity(newWeapon).SetScriptScopeVar("turret_scope", {ammo = storedAmmo});
							try {
								if (NetProps.HasProp(kent, "m_hActiveWeapon")) {
									NetProps.SetPropEntity(kent, "m_hActiveWeapon", newWeapon);
								}
							} catch (e) {
								printl("[OnGameEvent_player_use] Error setting active weapon: " + e);
							}
							ShowSpecialHint(kent, "Gnome obtained...", GiftIcon, 0.1, 3);
						}
						else
						{
							ShowSpecialHint(kent, "Could not obtain gnome! Slot occupied?", ForbiddenIcon, 0.1, 3);
						}
						if(GnomeTurretFrancis < 0) GnomeTurretFrancis = 0;
					}
					else
					{
						ShowSpecialHint(kent, "No gnomes in inventory!", ForbiddenIcon, 0.1, 3);
					}
				}
				else if(IsCertainSurvivor(kent, ZoeyModel))
				{
					if(GnomeTurretZoey > 0)
					{
						GnomeTurretZoey--;
						local storedAmmo = GnomeTurretAmmoZoey;
						kent.GiveItem("gnome");
						local invTable = {};
						GetInvTable(kent, invTable);
						local newWeapon = null;
						if("slot1" in invTable) newWeapon = invTable.slot1;
						if(newWeapon && newWeapon.GetClassname() == "weapon_gnome")
						{
							CEntity(newWeapon).SetScriptScopeVar("turret_scope", {ammo = storedAmmo});
						NetProps.SetPropEntity(kent, "m_hActiveWeapon", newWeapon);
							ShowSpecialHint(kent, "Gnome obtained...", GiftIcon, 0.1, 3);
						}
						else
						{
							ShowSpecialHint(kent, "Could not obtain gnome! Slot occupied?", ForbiddenIcon, 0.1, 3);
						}
				if(GnomeTurretZoey < 0) GnomeTurretZoey = 0;
					}
					else
					{
						ShowSpecialHint(kent, "No gnomes in inventory!", ForbiddenIcon, 0.1, 3);
					}
				}
		// Load main config file to apply custom turret settings
				LoadSpecificConfigFile("gnome turret/gnome turret.txt");
				GenerateGnomeVirtualInventory();
			}
	
		}
	}
}

function OnGameEvent_entity_shoved(event)
{
	local entDamage = {}
	local kent = GetPlayerFromUserID(event.attacker);
	if(kent && kent.IsValid() && kent.IsSurvivor())
	{
		if(GetButtonPressed(kent, ReloadButton))
	{
			if(GetActiveMainWeapon(kent) == "weapon_gnome")
			{
				if(Time() >= ButtonDelay + 0.5)
				{
					ButtonDelay = Time();
					// Removed LoadSpecificConfigFile call to preserve custom turret settings
					if(RandomInt(0,100) <= 100)
					{
						if(IsCertainSurvivor(kent, NickModel))
						{
							GnomeTurretNick++;
							GnomeTurretAmmoNick = GnomeTurretAmmoBase;
							if(GnomeTurretNick > 2)
							{
								GnomeTurretNick = 2;
								ShowSpecialHint(kent, ("Gnome inventory is full. You have " + GnomeTurretNick + " gnomes."), ForbiddenIcon, 0.1, 3);
								
							}
							if(GnomeTurretNick <= 2)
							{
								kent.GetActiveWeapon().Kill();
								ForcedToSwitchSecondary2(kent);
								ShowSpecialHint(kent, "Gnome is stored in virtual inventory. Press TAB + CTRL + JUMP to pick.", LampIcon, 0.1, 3);
								
							}
							
						}
						else if(IsCertainSurvivor(kent, CoachModel))
			{
							GnomeTurretCoach++;
							GnomeTurretAmmoCoach = GnomeTurretAmmoBase;
							if(GnomeTurretCoach > 2)
							{
								GnomeTurretCoach = 2;
								ShowSpecialHint(kent, ("Gnome inventory is full. You have " + GnomeTurretCoach + " gnomes."), ForbiddenIcon, 0.1, 3);
								
							}
							if(GnomeTurretCoach <= 2)
				{
								kent.GetActiveWeapon().Kill();
								ForcedToSwitchSecondary2(kent);
								ShowSpecialHint(kent, "Gnome is stored in virtual inventory. Press TAB + CTRL + JUMP to pick.", LampIcon, 0.1, 3);
								
							}
							
						}
						else if(IsCertainSurvivor(kent, EllisModel))
						{
							GnomeTurretEllis++;
							GnomeTurretAmmoEllis = GnomeTurretAmmoBase;
							if(GnomeTurretEllis > 2)
							{
								GnomeTurretEllis = 2;
								ShowSpecialHint(kent, ("Gnome inventory is full. You have " + GnomeTurretEllis + " gnomes."), ForbiddenIcon, 0.1, 3);
								
							}
							if(GnomeTurretEllis <= 2)
							{
								kent.GetActiveWeapon().Kill();
								ForcedToSwitchSecondary2(kent);
								ShowSpecialHint(kent, "Gnome is stored in virtual inventory. Press TAB + CTRL + JUMP to pick.", LampIcon, 0.1, 3);
								
							}
							
						}
						else if(IsCertainSurvivor(kent, RochelleModel))
						{
							GnomeTurretRochelle++;
							GnomeTurretAmmoRochelle = GnomeTurretAmmoBase;
							if(GnomeTurretRochelle > 2)
							{
								GnomeTurretRochelle = 2;
								ShowSpecialHint(kent, ("Gnome inventory is full. You have " + GnomeTurretRochelle + " gnomes."), ForbiddenIcon, 0.1, 3);
								
							}
							if(GnomeTurretRochelle <= 2)
							{
								kent.GetActiveWeapon().Kill();
								ForcedToSwitchSecondary2(kent);
					ShowSpecialHint(kent, "Gnome is stored in virtual inventory. Press TAB + CTRL + JUMP to pick.", LampIcon, 0.1, 3);
								
							}
							
						}
						else if(IsCertainSurvivor(kent, BillModel))
						{
							GnomeTurretBill++;
							GnomeTurretAmmoBill = GnomeTurretAmmoBase;
							if(GnomeTurretBill > 2)
							{
								GnomeTurretBill = 2;
								ShowSpecialHint(kent, ("Gnome inventory is full. You have " + GnomeTurretBill + " gnomes."), ForbiddenIcon, 0.1, 3);
								
							}
							if(GnomeTurretBill <= 2)
							{
								kent.GetActiveWeapon().Kill();
								ForcedToSwitchSecondary2(kent);
								ShowSpecialHint(kent, "Gnome is stored in virtual inventory. Press TAB + CTRL + JUMP to pick.", LampIcon, 0.1, 3);
								
							}
							
						}
						else if(IsCertainSurvivor(kent, LouisModel))
						{
							GnomeTurretLouis++;
							GnomeTurretAmmoLouis = GnomeTurretAmmoBase;
							if(GnomeTurretLouis > 2)
							{
								GnomeTurretLouis = 2;
								ShowSpecialHint(kent, ("Gnome inventory is full. You have " + GnomeTurretLouis + " gnomes."), ForbiddenIcon, 0.1, 3);
								
							}
							if(GnomeTurretLouis <= 2)
							{
								kent.GetActiveWeapon().Kill();
								ForcedToSwitchSecondary2(kent);
								ShowSpecialHint(kent, "Gnome is stored in virtual inventory. Press TAB + CTRL + JUMP to pick.", LampIcon, 0.1, 3);
								
							}
							
						}
						else if(IsCertainSurvivor(kent, FrancisModel))
					{
							GnomeTurretFrancis++;
							GnomeTurretAmmoFrancis = GnomeTurretAmmoBase;
							if(GnomeTurretFrancis > 2)
							{
								GnomeTurretFrancis = 2;
								ShowSpecialHint(kent, ("Gnome inventory is full. You have " + GnomeTurretFrancis + " gnomes."), ForbiddenIcon, 0.1, 3);
								
							}
							if(GnomeTurretFrancis <= 2)
							{
								kent.GetActiveWeapon().Kill();
								ForcedToSwitchSecondary2(kent);
								ShowSpecialHint(kent, "Gnome is stored in virtual inventory. Press TAB + CTRL + JUMP to pick.", LampIcon, 0.1, 3);
								
							}
							
						}
						else if(IsCertainSurvivor(kent, ZoeyModel))
						{
							GnomeTurretZoey++;
							GnomeTurretAmmoZoey = GnomeTurretAmmoBase;
							if(GnomeTurretZoey > 2)
							{
								GnomeTurretZoey = 2;
								ShowSpecialHint(kent, ("Gnome inventory is full. You have " + GnomeTurretZoey + " gnomes."), ForbiddenIcon, 0.1, 3);
								
							}
							if(GnomeTurretZoey <= 2)
							{
								kent.GetActiveWeapon().Kill();
								ForcedToSwitchSecondary2(kent);
								ShowSpecialHint(kent, "Gnome is stored in virtual inventory. Press TAB + CTRL + JUMP to pick.", LampIcon, 0.1, 3);
								
							}
							
						}
					
				}
				// Load main config file to apply custom turret settings
				LoadSpecificConfigFile("gnome turret/gnome turret.txt");
				GenerateGnomeVirtualInventory();
			}
		}
		
	}
}
}
function OnGameEvent_round_start_post_nav(event)
{
	printl("The 'GNOME TURRET' mod is loaded...");
	// Only generate config file if it doesn't exist (preserves custom settings)
	GenerateGnomeTurretCfgFile();
	// IMPORTANT: Load main config file IMMEDIATELY after generation to apply any custom settings
	LoadSpecificConfigFile("gnome turret/gnome turret.txt");
	if(!CfgFileCheck("gnome turret/virtual inventory/gnome virtual inventory.txt"))
	{
		GenerateGnomeVirtualInventory();
	}
	// Load virtual inventory
	LoadSpecificConfigFile("gnome turret/virtual inventory/gnome virtual inventory.txt");
}
