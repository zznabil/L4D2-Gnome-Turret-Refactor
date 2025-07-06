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

GnomeTurretAmmoNick <- 0
GnomeTurretAmmoCoach <- 0
GnomeTurretAmmoEllis <- 0
GnomeTurretAmmoRochelle <- 0
GnomeTurretAmmoBill <- 0
GnomeTurretAmmoLouis <- 0
GnomeTurretAmmoFrancis <- 0
GnomeTurretAmmoZoey <- 0

GnomeLimit <- 2
DemolitionShot <- 1
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
		"DemolitionShot 1",
		"GnomeTurretDamage 50",
		"GnomeTurretAmmoBase 300",
		".",
		".",
		"// ====== TOGGLE SETTING INFO ======",
		"//DemolitionShot= When enabled, gnome turret will shoot demolition bullets that destroy common infected to pieces & stumble special infected, tank & witch. Demolition bullet is a variant of explosive bullet.",
		"0= Off, normal bullets.",
		"1= On, demolition bullets.",
		".",
		"//GnomeTurretDamage= This controls gnome turret damage on each shot. Default value is 50. Minimum value is 1 even if you set it to 0. Max value is unlimited.",
		"0 or 1= Gnome turret deals 1 damage on zombies.",
		"higher than 1= Gnome turret deals (1 * value) damage on zombies. (Examples: value 500= It deals 500 damage on each shot).",
		".",
		"//GnomeTurretAmmoBase= This controls gnome turret ammo. Default value is 300. Minimum value is 50, so setting the value to lower than 50 will make gnome turret have 50 ammo.",
		"Below 50= Gnome turret is 50.",
		"higher than 50= Gnome turret ammo (1 * value).",
		".",
		".",
		"// =================================",
		"//Notes: Press 'TAB + SHOVE' & shove any objects when carrying gnome to store gnome to virtual inventory. Press 'TAB + CTRL + JUMP' to pick gnome from virtual inventory.",
		"//Notes 2: This cfg file is generated automatically when starting a campaign, & loaded on each stage & when installing the gnome turret on the ground.",
		"//Notes 3: Install the gnome turret on the ground to load settings of cfg file on the turret.",
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
		return trigger;
	}
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
				if(togglecommand == "DemolitionShot")
				{
					DemolitionShot = togglevalue.tointeger();
					
				}
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
	if(kent.IsSurvivor())
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
	if(kent.IsSurvivor())
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

	if(kent.IsSurvivor())
	{
		if(GetButtonPressed(kent, ScoreButton) && GetButtonPressed(kent, DuckButton))
		{
			if(GetActiveMainWeapon(kent) != "weapon_gnome")
			{
				if(RandomInt(0,100) <= 100)
				{
					if(IsCertainSurvivor(kent, NickModel))
					{
						if(GnomeTurretNick > 0)
						{
							GnomeTurretNick--;
							kent.GiveItem("gnome");
							ShowSpecialHint(kent, "Gnome obtained...", GiftIcon, 0.1, 3);
						}
						if(GnomeTurretNick < 0)
						{
							GnomeTurretNick = 0;
						}
						
					}
					else if(IsCertainSurvivor(kent, CoachModel))
					{
						if(GnomeTurretCoach > 0)
						{
							GnomeTurretCoach--;
							kent.GiveItem("gnome");
							ShowSpecialHint(kent, "Gnome obtained...", GiftIcon, 0.1, 3);
						}
						if(GnomeTurretCoach < 0)
						{
							GnomeTurretCoach = 0;
						}
						
					}
					else if(IsCertainSurvivor(kent, EllisModel))
					{
						if(GnomeTurretEllis > 0)
						{
							GnomeTurretEllis--;
							kent.GiveItem("gnome");
							ShowSpecialHint(kent, "Gnome obtained...", GiftIcon, 0.1, 3);
						}
						if(GnomeTurretEllis < 0)
						{
							GnomeTurretEllis = 0;
						}
						
					}
					else if(IsCertainSurvivor(kent, RochelleModel))
					{
						if(GnomeTurretRochelle > 0)
						{
							GnomeTurretRochelle--;
							kent.GiveItem("gnome");
							ShowSpecialHint(kent, "Gnome obtained...", GiftIcon, 0.1, 3);
						}
						if(GnomeTurretRochelle < 0)
						{
							GnomeTurretRochelle = 0;
						}
						
					}
					else if(IsCertainSurvivor(kent, BillModel))
					{
						if(GnomeTurretBill > 0)
						{
							GnomeTurretBill--;
							kent.GiveItem("gnome");
							ShowSpecialHint(kent, "Gnome obtained...", GiftIcon, 0.1, 3);
						}
						if(GnomeTurretBill < 0)
						{
							GnomeTurretBill = 0;
						}
						
					}
					else if(IsCertainSurvivor(kent, LouisModel))
					{
						if(GnomeTurretLouis > 0)
						{
							GnomeTurretLouis--;
							kent.GiveItem("gnome");
							ShowSpecialHint(kent, "Gnome obtained...", GiftIcon, 0.1, 3);
						}
						if(GnomeTurretLouis < 0)
						{
							GnomeTurretLouis = 0;
						}
						
					}
					else if(IsCertainSurvivor(kent, FrancisModel))
					{
						if(GnomeTurretFrancis > 0)
						{
							GnomeTurretFrancis--;
							kent.GiveItem("gnome");
							ShowSpecialHint(kent, "Gnome obtained...", GiftIcon, 0.1, 3);
						}
						if(GnomeTurretFrancis < 0)
						{
							GnomeTurretFrancis = 0;
						}
						
					}
					else if(IsCertainSurvivor(kent, ZoeyModel))
					{
						if(GnomeTurretZoey > 0)
						{
							GnomeTurretZoey--;
							kent.GiveItem("gnome");
							ShowSpecialHint(kent, "Gnome obtained...", GiftIcon, 0.1, 3);
						}
						if(GnomeTurretZoey < 0)
						{
							GnomeTurretZoey = 0;
						}
						
					}
					
				}
				GenerateGnomeVirtualInventory();
			}
			
		}
	}
}

function OnGameEvent_entity_shoved(event)
{
	local entDamage = {}
	local kent = GetPlayerFromUserID(event.attacker);
	if(kent.IsSurvivor())
	{
		if(GetButtonPressed(kent, ReloadButton))
		{
			if(GetActiveMainWeapon(kent) == "weapon_gnome")
			{
				if(Time() >= ButtonDelay + 0.5)
				{
					ButtonDelay = Time();
					LoadSpecificConfigFile("gnome turret/gnome turret.txt");
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
					GenerateGnomeVirtualInventory();
				}
			}
			
		}
	}
}
function OnGameEvent_round_start_post_nav(event)
{
	printl("The 'GNOME TURRET' mod is loaded...");
	GenerateGnomeTurretCfgFile();
	if(!CfgFileCheck("gnome turret/virtual inventory/gnome virtual inventory.txt"))
	{
		GenerateGnomeVirtualInventory();
		
	}
	LoadSpecificConfigFile("gnome turret/gnome turret.txt");
	LoadSpecificConfigFile("gnome turret/virtual inventory/gnome virtual inventory.txt");
	
}
