// Squirrel
// Library of Utils
// Author: Sw1ft >> http://steamcommunity.com/profiles/76561198397776991

/*===============================*\
 *       List of Constants       *
 *                               *
 *     CBaseEntity MoveType      *
\*===============================*/

const MOVETYPE_NONE = 0
const MOVETYPE_ISOMETRIC = 1
const MOVETYPE_WALK = 2
const MOVETYPE_STEP = 3
const MOVETYPE_FLY = 4
const MOVETYPE_FLYGRAVITY = 5
const MOVETYPE_VPHYSICS = 6
const MOVETYPE_PUSH = 7
const MOVETYPE_NOCLIP = 8
const MOVETYPE_LADDER = 9
const MOVETYPE_OBSERVER = 10
const MOVETYPE_CUSTOM = 11

/*===============================*\
 *       CBaseEntity Flags       *
\*===============================*/

const FL_ONGROUND = 1
const FL_DUCKING = 2
const FL_WATERJUMP = 4
const FL_ONTRAIN = 8
const FL_INRAIN = 16
const FL_FROZEN = 32
const FL_ATCONTROLS = 64
const FL_CLIENT = 128
const FL_FAKECLIENT = 256
const FL_INWATER = 512
const FL_FLY = 1024
const FL_SWIM = 2048
const FL_CONVEYOR = 4096
const FL_NPC = 8192
const FL_GODMODE = 16384
const FL_NOTARGET = 32768
const FL_AIMTARGET = 65536
const FL_PARTIALGROUND = 131072
const FL_STATICPROP = 262144
const FL_GRAPHED = 524288
const FL_GRENADE = 1048576
const FL_STEPMOVEMENT = 2097152
const FL_DONTTOUCH = 4194304
const FL_BASEVELOCITY = 8388608
const FL_WORLDBRUSH = 16777216
const FL_OBJECT = 33554432
const FL_KILLME = 67108864
const FL_ONFIRE = 134217728
const FL_DISSOLVING = 268435456
const FL_TRANSRAGDOLL = 536870912
const FL_UNBLOCKABLE_BY_PLAYER = 1073741824
const FL_FREEZING = 2147483648
const FL_EP2V_UNKNOWN1 = 2147483648

/*===============================*\
 *     CBasePlayer Buttons       *
\*===============================*/

const IN_ATTACK = 1
const IN_JUMP = 2
const IN_DUCK = 4
const IN_FORWARD = 8
const IN_BACK = 16
const IN_USE = 32
const IN_CANCEL = 64
const IN_LEFT = 128
const IN_RIGHT = 256
const IN_MOVELEFT = 512
const IN_MOVERIGHT = 1024
const IN_ATTACK2 = 2048
const IN_RUN = 4096
const IN_RELOAD = 8192
const IN_ALT1 = 16384
const IN_ALT2 = 32768
const IN_SCORE = 65536
const IN_SPEED = 131072
const IN_WALK = 262144
const IN_ZOOM = 524288
const IN_WEAPON1 = 1048576
const IN_WEAPON2 = 2097152
const IN_BULLRUSH = 4194304
const IN_GRENADE1 = 8388608
const IN_GRENADE2 = 16777216
const IN_ATTACK3 = 33554432

/*===============================*\
 *    CBaseTrigger SpawnFlags    *
\*===============================*/

const TR_CLIENTS = 1
const TR_NPCS = 2
const TR_PUSHABLES = 4
const TR_PHYSICS_OBJECTS = 8
const TR_ONLY_PLAYER_ALLY_NPCS = 16
const TR_ONLY_CLIENTS_IN_VEHICLES = 32
const TR_EVERYTHING = 64
const TR_ONLY_CLIENTS_NOT_IN_VEHICLES = 512
const TR_PHYSICS_DEBRIS = 1024
const TR_ONLY_NPCS_IN_VEHICLES = 2048
const TR_DISALLOW_BOTS = 4096
const TR_OFF = 8192

/*===============================*\
 *         Damage Type           *
\*===============================*/

const DMG_GENERIC = 0
const DMG_CRUSH = 1
const DMG_BULLET = 2
const DMG_SLASH = 4
const DMG_BURN = 8
const DMG_VEHICLE = 16
const DMG_FALL = 32
const DMG_BLAST = 64
const DMG_CLUB = 128
const DMG_SHOCK = 256
const DMG_SONIC = 512
const DMG_ENERGYBEAM = 1024
const DMG_PREVENT_PHYSICS_FORCE = 2048
const DMG_NEVERGIB = 4096
const DMG_ALWAYSGIB = 8192
const DMG_DROWN = 16384
const DMG_PARALYZE = 32768
const DMG_NERVEGAS = 65536
const DMG_POISON = 131072
const DMG_RADIATION = 262144
const DMG_DROWNRECOVER = 524288
const DMG_ACID = 1048576
// const DMG_SLOWBURN = 2097152
const DMG_MELEE = 2097152
const DMG_REMOVENORAGDOLL = 4194304
const DMG_PHYSGUN = 8388608
const DMG_PLASMA = 16777216
// const DMG_AIRBOAT = 33554432
const DMG_STUMBLE = 33554432
const DMG_DISSOLVE = 67108864
const DMG_BLAST_SURFACE = 134217728
const DMG_DIRECT = 268435456
const DMG_BUCKSHOT = 536870912
const DMG_HEADSHOT = 1073741824

/*===============================*\
 *     Director Enumerations     *
\*===============================*/

/* AllowBash Flags */
const ALLOW_BASH_ALL = 0
const ALLOW_BASH_NONE = 2
const ALLOW_BASH_PUSHONLY = 1

/* BOT Sense Flags */
const BOT_CANT_FEEL = 4
const BOT_CANT_HEAR = 2
const BOT_CANT_SEE = 1

/* BOT Command Flags */
const BOT_CMD_ATTACK = 0
const BOT_CMD_MOVE = 1
const BOT_CMD_RESET = 3
const BOT_CMD_RETREAT = 2

/* BotQuery Flags */
const BOT_QUERY_NOTARGET = 1

/* Infected Flags */
const INFECTED_FLAG_CANT_FEEL_SURVIVORS = 32768
const INFECTED_FLAG_CANT_HEAR_SURVIVORS = 16384
const INFECTED_FLAG_CANT_SEE_SURVIVORS = 8192

/* Finales and Scripted Panic Events Flags */
const FINALE_CUSTOM_CLEAROUT = 11
const FINALE_CUSTOM_DELAY = 10
const FINALE_CUSTOM_PANIC = 7
const FINALE_CUSTOM_SCRIPTED = 9
const FINALE_CUSTOM_TANK = 8
const FINALE_FINAL_BOSS = 5
const FINALE_GAUNTLET_1 = 0
const FINALE_GAUNTLET_2 = 3
const FINALE_GAUNTLET_BOSS = 16
const FINALE_GAUNTLET_BOSS_INCOMING = 15
const FINALE_GAUNTLET_ESCAPE = 17
const FINALE_GAUNTLET_HORDE = 13
const FINALE_GAUNTLET_HORDE_BONUSTIME = 14
const FINALE_GAUNTLET_START = 12
const FINALE_HALflTime_BOSS = 2
const FINALE_HORDE_ATTACK_1 = 1
const FINALE_HORDE_ATTACK_2 = 4
const FINALE_HORDE_ESCAPE = 6

/* Stages Flags */
const STAGE_CLEAROUT = 4
const STAGE_DELAY = 2
const STAGE_ESCAPE = 7
const STAGE_NONE = 9
const STAGE_PANIC = 0
const STAGE_RESULTS = 8
const STAGE_SETUP = 5
const STAGE_TANK = 1

/* HUD Flags */
const HUD_FAR_LEFT = 7
const HUD_FAR_RIGHT = 8
const HUD_FLAG_ALIGN_CENTER = 512
const HUD_FLAG_ALIGN_LEFT = 256
const HUD_FLAG_ALIGN_RIGHT = 768
const HUD_FLAG_ALLOWNEGTIMER = 128
const HUD_FLAG_AS_TIME = 16
const HUD_FLAG_BEEP = 4
const HUD_FLAG_BLINK = 8
const HUD_FLAG_COUNTDOWN_WARN = 32
const HUD_FLAG_NOBG = 64
const HUD_FLAG_NOTVISIBLE = 16384
const HUD_FLAG_POSTSTR = 2
const HUD_FLAG_PRESTR = 1
const HUD_FLAG_TEAM_INFECTED = 2048
const HUD_FLAG_TEAM_MASK = 3072
const HUD_FLAG_TEAM_SURVIVORS = 1024
const HUD_LEFT_BOT = 1
const HUD_LEFT_TOP = 0
const HUD_MID_BOT = 3
const HUD_MID_BOX = 9
const HUD_MID_TOP = 2
const HUD_RIGHT_BOT = 5
const HUD_RIGHT_TOP = 4
const HUD_SCORE_1 = 11
const HUD_SCORE_2 = 12
const HUD_SCORE_3 = 13
const HUD_SCORE_4 = 14
const HUD_SCORE_TITLE = 10
const HUD_SPECIAL_COOLDOWN = 4
const HUD_SPECIAL_MAPNAME = 6
const HUD_SPECIAL_MODENAME = 7
const HUD_SPECIAL_ROUNDTIME = 5
const HUD_SPECIAL_TIMER0 = 0
const HUD_SPECIAL_TIMER1 = 1
const HUD_SPECIAL_TIMER2 = 2
const HUD_SPECIAL_TIMER3 = 3
const HUD_TICKER = 6

/* Manage Timers Flags */
const TIMER_COUNTDOWN = 2
const TIMER_COUNTUP = 1
const TIMER_DISABLE = 0
const TIMER_SET = 4
const TIMER_STOP = 3

/* Shutdown Function Flags */
const SCRIPT_SHUTDOWN_EXIT_GAME = 4
const SCRIPT_SHUTDOWN_LEVEL_TRANSITION = 3
const SCRIPT_SHUTDOWN_MANUAL = 0
const SCRIPT_SHUTDOWN_ROUND_RESTART = 1
const SCRIPT_SHUTDOWN_TEAM_SWAP = 2

/* Spawn Direction Flags */
const SPAWNDIR_E = 4
const SPAWNDIR_N = 1
const SPAWNDIR_NE = 2
const SPAWNDIR_NW = 128
const SPAWNDIR_S = 16
const SPAWNDIR_SE = 8
const SPAWNDIR_SW = 32
const SPAWNDIR_W = 64

/* Spawn Rules */
const SCRIPTED_SPAWN_BATTLEFIELD = 2
const SCRIPTED_SPAWN_FINALE = 0
const SCRIPTED_SPAWN_POSITIONAL = 3
const SCRIPTED_SPAWN_SURVIVORS = 1
const SPAWN_ABOVE_SURVIVORS = 6
const SPAWN_ANYWHERE = 0
const SPAWN_BATTLEFIELD = 2
const SPAWN_BEHIND_SURVIVORS = 1
const SPAWN_FAR_AWAY_FROM_SURVIVORS = 5
const SPAWN_FINALE = 0
const SPAWN_IN_FRONT_OF_SURVIVORS = 7
const SPAWN_LARGE_VOLUME = 9
const SPAWN_NEAR_IT_VICTIM = 2
const SPAWN_NEAR_POSITION = 10
const SPAWN_NO_PREFERENCE = -1
const SPAWN_POSITIONAL = 3
const SPAWN_SPECIALS_ANYWHERE = 4
const SPAWN_SPECIALS_IN_FRONT_OF_SURVIVORS = 3
const SPAWN_SURVIVORS = 1
const SPAWN_VERSUS_FINALE_DISTANCE = 8

/* Trace Line Mask Flags */
const TRACE_MASK_ALL = -1
const TRACE_MASK_NPC_SOLID = 33701899
const TRACE_MASK_PLAYER_SOLID = 33636363
const TRACE_MASK_SHOT = 1174421507
const TRACE_MASK_VISIBLE_AND_NPCS = 33579137
const TRACE_MASK_VISION = 33579073

/* Weapon Upgrade Types */
const UPGRADE_INCENDIARY_AMMO = 0
const UPGRADE_EXPLOSIVE_AMMO = 1
const UPGRADE_LASER_SIGHT = 2

/* Zombie Types */
const ZOMBIE_BOOMER = 2
const ZOMBIE_CHARGER = 6
const ZOMBIE_HUNTER = 3
const ZOMBIE_JOCKEY = 5
const ZOMBIE_NORMAL = 0
const ZOMBIE_SMOKER = 1
const ZOMBIE_SPITTER = 4
const ZOMBIE_TANK = 8
const ZOMBIE_WITCH = 7
const ZSPAWN_MOB = 10
const ZSPAWN_MUDMEN = 12
const ZSPAWN_WITCHBRIDE = 11

/*===============================*\
 *   Enumerations & Constants    *
\*===============================*/

const MAXENTS = 2048
const MAXCLIENTS = 32
const ZOMBIE_NONE = -1
const ZOMBIE_SURVIVOR = 9
const TEAM_SPECTATOR = 1
const TEAM_SURVIVOR = 2
const TEAM_INFECTED = 3
const PHYS_BLOCKER_EVERYONE = 0
const PHYS_BLOCKER_SURVIVORS = 1
const PHYS_BLOCKER_SI = 2
const PHYS_BLOCKER_ALL_SI = 3
const LF_PREFIX = "lf_"
const LIB_DATA_FOLDER = "lib_utils/"
const CC_EMPTY_ARGUMENT = "__STRING_EMPTY_ARGUMENT"

const HIDE_HUD_NONE = 0
const HIDE_HUD_WEAPON_SELECTION = 1
const HIDE_HUD_FLASHLIGHT = 2
const HIDE_HUD_ALL = 4
const HIDE_HUD_HEALTH = 8
const HIDE_HUD_PLAYER_DEAD = 16
const HIDE_HUD_NEED_SUIT = 32
const HIDE_HUD_MISC = 64
const HIDE_HUD_CHAT = 128
const HIDE_HUD_CROSSHAIR = 256
const HIDE_HUD_VEHICLE_CROSSHAIR = 512
const HIDE_HUD_IN_VEHICLE = 1024

enum eTrace
{
	Mask_All = -1
	Mask_NPC_Solid = 33701899
	Mask_Player_Solid = 33636363
	Mask_Shot = 1174421507
	Mask_Visible_And_NPCS = 33579137
	Mask_Visible = 33579073
	Distance = 1000000000
	Type_Hit = 1
	Type_Pos = 2
}

enum eUpgrade
{
	None = 0
	Incendiary = 1
	Explosive = 2
	Laser = 4
}

enum eInventoryWeapon
{
	Primary
	Secondary
}

enum eTeam
{
	Everyone
	Survivor
	Infected
}

enum eButtonType
{
	Pressed
	Released
	Hold
}

/*===============================*\
 *           Classes             *
\*===============================*/

/** Class Entity
 * Signature: class CEntity(CBaseEntity entity)
*/

class CEntity
{
	constructor(ent)
	{
		if (typeof(ent) == "instance")
		{
			hEntity = ent;
			entidx = ent.GetEntityIndex();
		}
		else if (typeof(ent) == "integer")
		{
			hEntity = EntIndexToHScript(ent);
			entidx = ent;
		}
		else if (typeof(ent) == "string")
		{
			if (hEntity = Entities.FindByName(null, ent))
				entidx = hEntity.GetEntityIndex();
		}
	}
	function IsEntityValid()
	{
		if (!hEntity)
		{
			printl("[Class Entity] Entity not found");
			return false;
		}
		return true;
	}
	function GetClassType()
	{
		return m_sClassType;
	}
	static m_sClassType = "CEntity";
	hEntity = null;
	entidx = null;
}

/** Class Loop function
 * Signature: class CLoopFunction(string funcName, float refiretime, any args)
*/

class CLoopFunction
{
	constructor(sFunction, flInterval, aInputVars = [])
	{
		local aArgs = [this];
		aArgs.extend(aInputVars);
		m_aInputVars = aArgs;
		m_sFunctionName = sFunction;
		m_sTimerName = LF_PREFIX + sFunction.tolower();
		if (flInterval != null) m_flInterval = flInterval;
	}
	function GetInputVariables()
	{
		return m_aInputVars;
	}
	function GetFunctionName()
	{
		return m_sFunctionName;
	}
	function GetTimerName()
	{
		return m_sTimerName;
	}
	function GetRefireTime()
	{
		return m_flInterval;
	}
	function GetClassType()
	{
		return m_sClassType;
	}
	static m_sClassType = "CLoopFunction";
	m_sFunctionName = null;
	m_aInputVars = null;
	m_sTimerName = null;
	m_flInterval = null;
}

/** Class On tick function
 * Signature: class COnTickFunction(string funcName, any args)
*/

class COnTickFunction
{
	constructor(sFunction, aInputVars = [])
	{
		local aArgs = [this];
		aArgs.extend(aInputVars);
		m_aInputVars = aArgs;
		m_sFunctionName = sFunction;
	}
	function GetInputVariables()
	{
		return m_aInputVars;
	}
	function GetFunctionHandle()
	{
		return compilestring("return " + m_sFunctionName)();
	}
	function GetFunctionName()
	{
		return m_sFunctionName;
	}
	function GetClassType()
	{
		return m_sClassType;
	}
	static m_sClassType = "COnTickFunction";
	m_sFunctionName = null;
	m_aInputVars = null;
}

/** Class Chat command
 * Signature: class CChatCommand(string command, function callFunction, bool bInputPlayerHandle, bool bInputValue)
*/

class CChatCommand
{
	constructor(sCommand, hFunction, bInputPlayerHandle, bInputValue)
	{
		m_sCommand = sCommand;
		m_Function = hFunction;
		m_bInputPlayerHandle = bInputPlayerHandle;
		m_bInputValue = bInputValue;
	}
	function GetCommand()
	{
		return m_sCommand;
	}
	function GetFunctionHandle()
	{
		return m_Function;
	}
	function GetInputPlayerHandle()
	{
		return m_bInputPlayerHandle;
	}
	function GetInputValue()
	{
		return m_bInputValue;
	}
	function GetClassType()
	{
		return m_sClassType;
	}
	static m_sClassType = "CChatCommand";
	m_sCommand = null;
	m_Function = null;
	m_bInputPlayerHandle = false;
	m_bInputValue = false;
}

/** Class Button
 * Signature: class CButtonListener(int button, string funcName, int pressType, int team)
*/

class CButtonListener
{
	constructor(nButtons, sFunction, iType, iTeam)
	{
		m_nButtons = nButtons;
		m_sFunctionName = sFunction;
		m_iPressType = iType;
		m_iTeam = iTeam;
	}
	function GetCallingFunction()
	{
		return compilestring("return " + m_sFunctionName)();
	}
	function GetFunction() 
	{
		return m_sFunctionName;
	}
	function GetButton()
	{
		return m_nButtons;
	}
	function GetTeam()
	{
		return m_iTeam;
	}
	function GetType()
	{
		return m_iPressType;
	}
	function GetClassType()
	{
		return m_sClassType;
	}
	static m_sClassType = "CButtonListener";
	m_sFunctionName = null;
	m_nButtons = null;
	m_iPressType = null;
	m_iTeam = null;
}

/** Class ConVar
 * Signature: class CConVar(string name, string defaultValue, string variableType, float minValue, float maxValue)
*/

class CConVar
{
	constructor(sName, sDefaultValue, sType = null, flMinValue = null, flMaxValue = null)
	{
		m_sName = sName;
		m_sValue = sDefaultValue;
		m_sDefaultValue = sDefaultValue;
		m_sType = sType;
		m_flMinValue = flMinValue;
		m_flMaxValue = flMaxValue;
	}
	function GetName()
	{
		return m_sName;
	}
	function GetDefault()
	{
		return m_sDefaultValue;
	}
	function GetValue(bReturnFloat = false)
	{
		return bReturnFloat ? Convars.GetFloat(m_sName) : Convars.GetStr(m_sName);
	}
	function GetCurrentValue()
	{
		return m_sValue;
	}
	function RestoreDefault()
	{
		m_sValue = m_sDefaultValue;
	}
	function SetValue(Value)
	{
		SendToServerConsole(format("setinfo %s %s", m_sName, Value.tostring()));
	}
	function AddChangeHook(hFunction = @(){})
	{
		if (!m_bChangeHook)
		{
			m_bChangeHook = true;
			m_ChangeHookFunction = hFunction;
			printf("[Class ConVar] A function has been hooked for cvar '%s'", m_sName);
		}
	}
	function RemoveChangeHook()
	{
		if (m_bChangeHook)
		{
			m_bChangeHook = false;
			m_ChangeHookFunction = null;
			printf("[Class ConVar] A function has been unhooked for cvar '%s'", m_sName);
		}
	}
	function GetClassType()
	{
		return m_sClassType;
	}
	static m_sClassType = "CConVar";
	m_sName = null;
	m_sValue = null;
	m_sDefaultValue = null;
	m_bChangeHook = false;
	m_ChangeHookFunction = null;
	m_flMinValue = null;
	m_flMaxValue = null;
	m_sType = null;
}

/** Class Timer
 * Signature: class CTimer(float callTime, function callFunction, any args)
*/

class CTimer
{
	constructor(flCallTime, hFunction, aInputVars = [])
	{
		local aArgs = [this];
		aArgs.extend(aInputVars);
		m_aInputVars = aArgs;
		m_sIdentifier = UniqueString();
		m_Function = hFunction;
		m_flCallTime = flCallTime;
	}
	function GetFunctionHandle()
	{
		return m_Function;
	}
	function GetCallTime()
	{
		return m_flCallTime;
	}
	function GetInputVariables()
	{
		return m_aInputVars;
	}
	function GetIdentifier()
	{
		return m_sIdentifier;
	}
	function GetClassType()
	{
		return m_sClassType;
	}
	static m_sClassType = "CTimer";
	m_sIdentifier = null;
	m_flCallTime = null;
	m_Function = null;
	m_aInputVars = null;
}

/*===============================*\
 *          Variables            *
\*===============================*/



/*===============================*\
 *           Tables              *
\*===============================*/

g_tCallBackEvents <- {};
VMath <- {};

Math <-
{
	Deg2Rad = PI / 180
	Rad2Deg = 180 / PI
};

/*===============================*\
 *           Arrays              *
\*===============================*/

g_bAllowChangeCameraAngles <- array(MAXENTS + 1, true);
g_aLoopFunctions <- [];
g_aOnTickFunctions <- [];
g_aChatCommands <- [];
g_aButtonsListener <- [];
g_aConVars <- [];
g_aTimers <- [];

/*===============================*\
 *         Functions             *
\*===============================*/

/** Print format
 * Signature: void printf(string message, args)
 * Credits: kapkan
*/

function printf(sMsg, ...)
{
	local aInputVars = [this, sMsg];
	aInputVars.extend(vargv);
	printl(format.acall(aInputVars));
}

/** Say format
 * Signature: void sayf(string message, args)
*/

function sayf(sMsg, ...)
{
	local aInputVars = [this, sMsg];
	aInputVars.extend(vargv);
	try {
		Say(null, format.acall(aInputVars), false);
	} catch (e) {
		// Fallback to printl if Say function fails
		printl(format.acall(aInputVars));
	}
}

/** Simplified a Say function
 * Signature: void say(string message)
*/

function SayMsg(sMsg)
{
	try {
		Say(null, sMsg.tostring(), false);
	} catch (e) {
		// Fallback to printl if Say function fails
		printl(sMsg.tostring());
	}
}

/** Set a value for a console variable or return the current value
 * Signature: void/string/float cvar(string convar, any value, bool bReturnString)
*/

function cvar(sName = null, value = null, bReturnString = true)
{
	if (sName != null)
	{
		if (value != null) Convars.SetValue(sName.tostring(), value.tostring());
		else if (bReturnString) return Convars.GetStr(sName.tostring());
		else return Convars.GetFloat(sName.tostring());
	}
}

/** Interpreting the ToKVString method
 * Signature: string kvstr(instance)
*/

function kvstr(__instance)
{
	if (__instance instanceof Vector)
		return __instance.x + " " + __instance.y + " " + __instance.z;

	if (__instance instanceof QAngle)
		return __instance.x + " " + __instance.y + " " + __instance.z;

	if (__instance instanceof Vector2D)
		return __instance.x + " " + __instance.y;

	if (__instance instanceof Vector4D)
		return __instance.x + " " + __instance.y + " " + __instance.z + " " + __instance.w;

	if (__instance instanceof Quaternion)
		return __instance.x + " " + __instance.y + " " + __instance.z + " " + __instance.w;

	return "0 0 0";
}

/** Draw a point
 * Signature: void Mark(Vector origin, float duration, Vector min, Vector max, int r, int g, int b, int alpha)
 * Credits: kapkan (the name of function)
*/

function Mark(vecPos, flDuration = 5.0, vecMins = Vector(2, 2, 2), vecMaxs = Vector(-2, -2, -2), iRed = 232, iGreen = 0, iBlue = 232, iAlpha = 255)
{
	DebugDrawBox(vecPos, vecMins, vecMaxs, iRed, iGreen, iBlue, iAlpha, flDuration);
}

/** Draw a line
 * Signature: void Line(Vector start, Vector end, float time, int red, int green, int blue)
*/

function Line(vecStart, vecEnd, flTime = 5.0, iRed = 232, iGreen = 0, iBlue = 232)
{
	DebugDrawLine(vecStart, vecEnd, iRed, iGreen, iBlue, false, flTime);
}

/** Is a function exist
 * Signature: bool IsFunctionExist(string funcName)
*/

function IsFunctionExist(sFunction)
{
	if (type(sFunction) != "string") return printl("[IsFunctionExist] Wrong type of variable");
	local aString = split(sFunction, "(");
	try
	{
		foreach (val in aString) if (typeof(compilestring("return " + val)()) == "function") return true;
		return false;
	}
	catch (val) return false;
}

/** Accept an entity input
 * Signature: void AcceptEntityInput(handle caller, string command, string value, handle activator, float delay)
*/

function AcceptEntityInput(hEntity, sInput, sValue = "", flDelay = 0.0, hActivator = null)
{
	if (!hEntity) return printl("[AcceptEntityInput] Entity doesn't exist");
	DoEntFire("!self", sInput.tostring(), sValue.tostring(), flDelay.tofloat(), hActivator, hEntity);
}

/** Run a script code with the delay
 * Signature: void RunScriptCode(string script, float delay, handle activator, handle caller)
*/

function RunScriptCode(sScript, flDelay = 0.0, hActivator = null, hCaller = null)
{
	if (type(sScript) != "string") return printl("[RunScriptCode] Wrong type of variable");
	if (!hCaller) EntFire((hActivator != null ? "!activator" : "worldspawn"), "RunScriptCode", sScript, flDelay, hActivator);
	else AcceptEntityInput(hCaller, "RunScriptCode", sScript, flDelay, hActivator);
}

/** Call a script function code with the delay
 * Signature: void CallScriptFunction(string function, float delay, handle activator, handle caller)
*/

function CallScriptFunction(sFunction, flDelay = 0.0, hActivator = null, hCaller = null)
{
	if (type(sFunction) != "string") return printl("[CallScriptFunction] Wrong type of variable");
	if (!hCaller) EntFire((hActivator != null ? "!activator" : "worldspawn"), "CallScriptFunction", sFunction, flDelay, hActivator);
	else AcceptEntityInput(hCaller, "CallScriptFunction", sFunction, flDelay, hActivator);
}

/** Call a function with the delay and input variables
 * Signature: handle CreateTimer(float delay, function callFunction, array args)
*/

function CreateTimer(flDelay, hFunction, ...)
{
	if (typeof(hFunction) != "function") return printl("[CreateTimer] Wrong type of variable");
	local hTimer = CTimer(Time() + flDelay, hFunction, vargv);
	g_aTimers.push(hTimer);
	return hTimer;
}

/** Call a function in the next game tick with input variables
 * Signature: handle RunNextTickFunction(function callFunction, array args)
*/

function RunNextTickFunction(hFunction, ...)
{
	if (typeof(hFunction) != "function") return printl("[RunNextTickFunction] Wrong type of variable");
	local hTimer = CTimer(Time() + 0.0334, hFunction, vargv);
	g_aTimers.push(hTimer);
	return hTimer;
}

/** Emit a sound
 * Signature: void EmitSound(string soundFile)
*/

function EmitSound(vecPos, sSound, iRadius = 3000.0)
{
	local hEntity = SpawnEntityFromTable("ambient_generic", {
		origin = vecPos
		message = sSound
		radius = iRadius
		spawnflags = 48
		health = 100
	});
	AcceptEntityInput(hEntity, "PlaySound");
	AcceptEntityInput(hEntity, "Kill");
}

/** Emit a sound to all players
 * Signature: void EmitSoundToAll(string soundScript)
*/

function EmitSoundToAll(sSound)
{
	local hPlayer;
	while (hPlayer = Entities.FindByClassname(hPlayer, "player"))
		EmitSoundOnClient(sSound, hPlayer);
}

/** Is arrays equal
 * Signature: bool IsArraysEqual(array arr1, array arr2)
*/

function IsArraysEqual(a, _a)
{
	if (a.len() != _a.len()) return false;
	foreach (idx, val in a) if (_a[idx] != val) return false;
	return true;
}

/** Create an invisible wall
 * Signature: handle CreateInvisibleWall(string targetname, Vector origin, Vector maxs, Vector mins, int type, bool bEnable)
*/

function CreateInvisibleWall(sName, vecPos, vecMaxs = Vector(64, 64, 128), vecMins = Vector(-64, -64, 0), iType = PHYS_BLOCKER_EVERYONE, bEnable = true)
{
	local hEntity = SpawnEntityFromTable("env_physics_blocker", {
		origin = vecPos
		targetname = sName.tostring()
		initialstate = bEnable.tointeger()
		blocktype = iType
	});
	hEntity.__KeyValueFromVector("maxs", vecMaxs);
	hEntity.__KeyValueFromVector("mins", vecMins);
	hEntity.ValidateScriptScope();
	return hEntity;
}

/** Encode a string
 * Signature: string EncodeString(string message, bool bStringToFile, string fileName)
*/

function EncodeString(sInput = null, bStringToFile = false, sFileName = null)
{
	if (typeof(sInput) != "string") return;
	local sOutput = "";
	foreach (symbol in sInput)
	{
		symbol = format("/x%X", symbol)
		if (symbol.find("FFFFFF") != null) symbol = "/x" + symbol.slice(8);
		sOutput += symbol;
	}
	if (bStringToFile)
	{
		if (typeof(sFileName) != "string") return;
		sOutput = format("\"%s\"", sOutput);
		sOutput += "\n";
		return StringToFile(sFileName, sOutput);
	}
	return sOutput;
}

/** Decode a string
 * Signature: string DecodeString(string message, bool bFileToString, string fileName)
*/

function DecodeString(sInput = null, bFileToString = false, sFileName = null)
{
	if (!bFileToString) if (typeof(sInput) != "string") return;
	if (bFileToString)
	{
		if (typeof(sFileName) != "string") return;
		sInput = compilestring("return " + FileToString(sFileName))();
	}
	local aInput = split(sInput, "/x");
	local sOutput = "";
	foreach (symbol in aInput)
		if (symbol != "/x")
			sOutput += compilestring("return 0x" + symbol)().tochar().tostring();
	return sOutput;
}

/** Teleport an entity
 * Signature: void TP(Vector Origin, Vector/QAngle Angles, Vector Velocity, bool bNormalizedAngles)
*/

function TP(hEntity = null, vecPos = Vector(), eAngles = QAngle(), vecVel = Vector(), bNormalizedAngles = false)
{
	if (hEntity != null)
	{
		if (vecPos != null)
		{
			hEntity.SetOrigin(vecPos);
		}
		if (eAngles != null)
		{
			if (hEntity.IsPlayer()) hEntity.SetForwardVector(bNormalizedAngles ? eAngles : eAngles.Forward());
			else hEntity.SetAngles(bNormalizedAngles ? VectorToQAngle(eAngles) : eAngles);
		}
		if (vecVel != null)
		{
			if (hEntity.IsPlayer()) hEntity.SetVelocity(vecVel);
			else hEntity.ApplyAbsVelocityImpulse(vecVel);
		}
	}
}

/** Convert the time to clock/timer format
 * Signature: string ToClock(float time, bool bMs)
*/

function ToClock(flTime = 0.0, bMs = true)
{
	local min = (flTime / 60).tointeger();
	local sec = (flTime % 60).tointeger();
	local hr = min / 60;
    local day = hr / 24;
    local hr_dbg = "";
    local day_dbg = "";
	local ms_dbg = "";
    if (day >= 1)
    {
        hr %= 24;
        day_dbg = day < 10 ? "0" + day + ":" : day + ":";
    }
	if (hr >= 1 || day >= 1)
	{
		min %= 60;
		hr_dbg = hr < 10 ? "0" + hr + ":" : hr + ":";
	}
	if (bMs)
	{
		ms_dbg = "," + split(format("%.03f", flTime), ".")[1];
	}
	return day_dbg + hr_dbg + (min < 10 ? "0" + min : min) + (sec < 10 ? ":0" + sec : ":" + sec) + ms_dbg;
}

/** Get an angle between entities
 * Signature: float GetAngleBetweenEntities(handle entity, handle target)
*/

function GetAngleBetweenEntities(hEntity = null, hTarget = null, vecCorrection = Vector(), bMethod2D = false)
{
	if (!hEntity || !hTarget || !hEntity.IsValid() || !hTarget.IsValid()) return printl("[GetAngleBetweenEntities] Entity doesn't exist or is invalid");
	local vecPos = hEntity.IsPlayer() ? hEntity.EyePosition() : hEntity.GetOrigin();
	local _vecPos = hTarget.IsPlayer() ? hTarget.EyePosition() : hTarget.GetOrigin();
	if (bMethod2D)
	{
		vecPos.z = 0.0;
		_vecPos.z = 0.0;
	}
	return acos(((hEntity.IsPlayer() ? hEntity.EyeAngles() : hEntity.GetAngles()).Forward()).Dot(((_vecPos - vecPos) + vecCorrection).Normalize())) * Math.Rad2Deg;
}

/** Get the host player
 * Signature: handle GetHostPlayer()
*/

function GetHostPlayer()
{
	local hPlayerManager;
	if (hPlayerManager = Entities.FindByClassname(null, "terror_player_manager"))
	{
		local idx = 1;
		while (idx < NetProps.GetPropArraySize(hPlayerManager, "m_listenServerHost"))
		{
			if (NetProps.GetPropIntArray(hPlayerManager, "m_listenServerHost", idx))
			{
				return PlayerInstanceFromIndex(idx);
			}
			idx++;
		}
	}
	return null;
}

/** Collect alive survivors into a table
 * Signature: table CollectAliveSurvivors()
*/

function CollectAliveSurvivors()
{
	local hPlayer;
	local tSurvivors = {};
	while (hPlayer = Entities.FindByClassname(hPlayer, "player"))
	{
		if (hPlayer.IsSurvivor())
		{
			if (hPlayer.IsAlive() && !hPlayer.IsIncapacitated())
			{
				tSurvivors[hPlayer.GetEntityIndex()] <- hPlayer;
			}
		}
	}
	return tSurvivors;
}

/** Collect alive players into a table
 * Signature: table CollectAlivePlayers()
*/

function CollectAlivePlayers()
{
	local hPlayer;
	local tPlayers = {};
	while (hPlayer = Entities.FindByClassname(hPlayer, "player"))
	{
		if (hPlayer.IsSurvivor())
		{
			if (hPlayer.IsAlive())
			{
				tPlayers[hPlayer.GetEntityIndex()] <- hPlayer;
			}
		}
		else
		{
			local observerMode = 0;
			try {
				if (NetProps.HasProp(hPlayer, "m_iObserverMode")) {
					observerMode = NetProps.GetPropInt(hPlayer, "m_iObserverMode");
				}
			} catch (e) {
				// Silently handle error, assume not in observer mode
			}
			if (observerMode == 0)
			{
				tPlayers[hPlayer.GetEntityIndex()] <- hPlayer;
			}
		}
	}
	return tPlayers;
}

/** Collect all players into a table
 * Signature: array CollectAliveSurvivors()
*/

function CollectPlayers()
{
	local hPlayer;
	local tPlayers = {};
	while (hPlayer = Entities.FindByClassname(hPlayer, "player"))
	{
		tPlayers[hPlayer.GetEntityIndex()] <- hPlayer;
	}
	return tPlayers;
}

/** Send a command to a bot
 * Signature: void SendCommandToBot(int command, handle bot, handle target, Vector position)
*/

function SendCommandToBot(iCommand = BOT_CMD_MOVE, hBot = null, hTarget = null, vecPos = null)
{
	local tCommands =
	{
		cmd = iCommand
		bot = hBot
	}
	if (hTarget != null) tCommands.rawset("target", hTarget);
	if (vecPos != null) tCommands.rawset("pos", vecPos);
	CommandABot(tCommands);
}

/** Send a server command
 * Signature: void ServerCommand(string command, float delay)
*/

function ServerCommand(sCommand = "", flDelay = 0.0)
{
	local hServerCommand = SpawnEntityFromTable("point_servercommand", {});
	AcceptEntityInput(hServerCommand, "Command", sCommand.tostring(), flDelay.tofloat(), null);
	AcceptEntityInput(hServerCommand, "Kill", "", flDelay.tofloat(), null);
}

/** Send a client command to all
 * Signature: void ClientCommandToAll(string command, float delay)
*/

function ClientCommandToAll(sCommand = "", flDelay = 0.0)
{
	local hBroadcastClientCommand = SpawnEntityFromTable("point_broadcastclientcommand", {});
	AcceptEntityInput(hBroadcastClientCommand, "Command", sCommand.tostring(), flDelay.tofloat(), null);
	AcceptEntityInput(hBroadcastClientCommand, "Kill", "", flDelay.tofloat(), null);
}

/** Do trace line
 * Signature: handle/Vector DoTraceLine(Vector Start, Vector Direction, int hittype, float distance, int masktype, handle ignoreEntity)
*/

function DoTraceLine(vecStart = Vector(), vecDir = Vector(), tr_type = eTrace.Type_Hit, tr_dist = eTrace.Distance, tr_mask = eTrace.Mask_All, tr_ignore = null)
{
    local ent;
    local vecEnd = vecStart + vecDir.Scale(tr_dist);
    local hTrace =
    {
        start = vecStart
        end = vecEnd
        ignore = tr_ignore
        mask = tr_mask
    }
    TraceLine(hTrace);
    if (tr_type == eTrace.Type_Hit)
        if (hTrace.hit)
            if ((ent = hTrace.enthit).GetEntityIndex() != 0)
                return ent;
    if (tr_type == eTrace.Type_Pos) return hTrace.pos;
    return null;
}

/*===============================*\
 *     ConVar Class Functions    *
\*===============================*/

/** Create a new console variable
 * Signature: ConVar CreateConVar(string name, string defaultValue, string variableType, float minValue, float maxValue)
*/

function CreateConVar(sName, sDefaultValue, sType = null, flMinValue = null, flMaxValue = null)
{
	foreach (cvar in g_aConVars) if (cvar.GetName() == sName) return printf("[CreateConVar] ConVar '%s' already created", sName);
	sDefaultValue = sDefaultValue.tostring();
	local cvar = CConVar(sName, sDefaultValue, sType, flMinValue, flMaxValue);
	local cvar_value = Convars.GetStr(sName);
	printf("[CreateConVar] ConVar '%s' with default value '%s' has been created", sName, sDefaultValue);
	g_aConVars.push(cvar);
	if (!cvar_value) SendToServerConsole(format("setinfo %s \"%s\"", sName, sDefaultValue));
	else if (sDefaultValue != cvar_value) cvar.m_sValue = cvar_value;
	return cvar;
}

/** Find a ConVar
 * Signature: ConVar FindConVar(string name)
*/

function FindConVar(sName)
{
	foreach (cvar in g_aConVars)
	{
		if (cvar.GetName() == sName)
			return cvar;
	}
	return null;
}

/** Get a ConVar string
 * Signature: string GetConVarBool(ConVar cvar)
*/

function GetConVarString(convar)
{
	foreach (cvar in g_aConVars)
	{
		if (cvar.GetName() == convar.GetName())
		{
			return cvar.GetValue();
		}
	}
}
/** Get a ConVar bool
 * Signature: bool GetConVarBool(ConVar cvar)
*/

function GetConVarBool(convar)
{
	foreach (cvar in g_aConVars)
	{
		if (cvar.GetName() == convar.GetName())
		{
			return cvar.GetValue() != "0" && cvar.GetValue() != "false";
		}
	}
}

/** Get a ConVar integer
 * Signature: int GetConVarBool(ConVar cvar)
*/

function GetConVarInt(convar)
{
	foreach (cvar in g_aConVars)
	{
		if (cvar.GetName() == convar.GetName())
		{
			local value, min, max;
			if (!(value = cvar.GetValue(true)))
				return 0;
			value = value.tointeger();
			if (cvar.m_sType == "integer")
			{
				if (cvar.m_flMinValue != null && cvar.m_flMaxValue != null)
				{
					if (value < (min = cvar.m_flMinValue.tointeger()))
						return min;
					if (value > (max = cvar.m_flMaxValue.tointeger()))
						return max;
				}
				else if (cvar.m_flMinValue != null && cvar.m_flMaxValue == null)
				{
					if (value < (min = cvar.m_flMinValue.tointeger()))
						return min;
				}
				else if (cvar.m_flMinValue == null && cvar.m_flMaxValue != null)
				{
					if (value > (max = cvar.m_flMaxValue.tointeger()))
						return max;
				}
			}
			return value;
		}
	}
}

/** Get a ConVar float
 * Signature: float GetConVarBool(ConVar cvar)
*/

function GetConVarFloat(convar)
{
	foreach (cvar in g_aConVars)
	{
		if (cvar.GetName() == convar.GetName())
		{
			local value = cvar.GetValue(true);
			if (!value)
				return 0.0;
			value = value.tofloat();
			if (cvar.m_sType == "float")
			{
				if (cvar.m_flMinValue != null && cvar.m_flMaxValue != null)
				{
					if (value < cvar.m_flMinValue)
						return cvar.m_flMinValue;
					if (value > cvar.m_flMaxValue)
						return cvar.m_flMaxValue;
				}
				else if (cvar.m_flMinValue != null && cvar.m_flMaxValue == null)
				{
					if (value < cvar.m_flMinValue)
						return cvar.m_flMinValue;
				}
				else if (cvar.m_flMinValue == null && cvar.m_flMaxValue != null)
				{
					if (value > cvar.m_flMaxValue)
						return cvar.m_flMaxValue;
				}
			}
			return value;
		}
	}
}

/*===============================*\
 *     Entity Class Functions    *
\*===============================*/

/** Attach an entity
 * Signature: void CEntity(CBaseEntity entity).AttachEntity(handle target, string attachment, float delay)
*/

function CEntity::AttachEntity(hTarget, sAttachment = null, flDelay = 0.0)
{
	if (!IsEntityValid()) return;
	AcceptEntityInput(hTarget, "SetParent", "!activator", flDelay, hEntity);
	if (sAttachment != null) AcceptEntityInput(hTarget, "SetParentAttachment", sAttachment, flDelay, hEntity);
}

/** Remove an attachment
 * Signature: void CEntity(CBaseEntity entity).RemoveAttachment(handle target, float delay)
*/

function CEntity::RemoveAttachment(hTarget, flDelay = 0.0)
{
	if (!IsEntityValid()) return;
	AcceptEntityInput(hTarget, "ClearParent", "", flDelay, hEntity);
}

/** Get a distance between two entities
 * Signature: void CEntity(CBaseEntity entity).GetDistance(handle target, bool bSquared, bool bMethod2D)
*/

function CEntity::GetDistance(hTarget, bSquared = false, bMethod2D = false)
{
	if (!IsEntityValid()) return;
	if (!hTarget || !hTarget.IsValid()) return;
	local flDistance;
	if (bSquared) flDistance = bMethod2D ? (hEntity.GetOrigin() - hTarget.GetOrigin()).Length2DSqr() : (hEntity.GetOrigin() - hTarget.GetOrigin()).LengthSqr();
	else flDistance = bMethod2D ? (hEntity.GetOrigin() - hTarget.GetOrigin()).Length2D() : (hEntity.GetOrigin() - hTarget.GetOrigin()).Length();
	return flDistance;
}

/** Ignite an entity
 * Signature: void CEntity(CBaseEntity player).Ignite(handle attacker, float interval)
*/

function CEntity::Ignite(hAttacker = null, flInterval = 5.0)
{
	if (!IsEntityValid()) return;
	if (hEntity.IsPlayer() || hEntity.GetClassname() == "witch") hEntity.TakeDamage(0.01, DMG_BURN, !hAttacker ? hEntity : hAttacker);
	else AcceptEntityInput(hEntity, "IgniteLifeTime", flInterval.tostring());
	if (hEntity.IsPlayer())
	{
		if (!hEntity.IsSurvivor())
		{
			CEntity(hEntity).SetScriptScopeVar("extinguish_time", Time() + flInterval);
			CreateTimer(flInterval, function(hPlayer){
				if (hPlayer.IsValid()) if (hPlayer.IsOnFire()) if (CEntity(hPlayer).GetScriptScopeVar("extinguish_time") <= Time()) hPlayer.Extinguish();
			}, hEntity);
		}
	}
}

/** Set entity angles by steps
 * Signature: void CEntity(CBaseEntity entity).SetAnglesBySteps(QAngle angles, int steps, float deltaTime, bool sphericalLerp)
*/

function CEntity::SetAnglesBySteps(eAngles, iSteps, flDeltaTime = 0.01, bSlerp = true)
{
	if (!IsEntityValid()) return;
	local eAnglesStart = hEntity.IsPlayer() ? hEntity.EyeAngles() : hEntity.GetAngles();
	if ((Vector(eAngles.x, eAngles.y, eAngles.z) - Vector(eAnglesStart.x, eAnglesStart.y, eAnglesStart.z)).LengthSqr() >= 1)
	{
		local flTime = 0.0;
		if (hEntity.IsPlayer()) // linear interpolation only
		{
			if (eAngles.z != 0) eAngles.z = 0;
			if (eAngles.y < -180 || eAngles.y > 180) eAngles.y = Math.NormalizeAngle(eAngles.y);
			if (eAnglesStart.y < -180 || eAnglesStart.y > 180) eAnglesStart.y = Math.NormalizeAngle(eAnglesStart.y);
			if (eAngles.y < 0) eAngles.y += 360;
			if (eAnglesStart.y < 0) eAnglesStart.y += 360;
			local eAnglesDifference = eAngles - eAnglesStart;
			if (eAngles.y + fabs(360 - eAnglesStart.y) < fabs(eAngles.y - eAnglesStart.y)) eAnglesDifference.y = eAngles.y + fabs(360 - eAnglesStart.y);
			else if (eAnglesStart.y + fabs(360 - eAngles.y) < fabs(eAnglesStart.y - eAngles.y)) eAnglesDifference.y = -(eAnglesStart.y + fabs(360 - eAngles.y));
			local eAnglesDelta = QAngle(eAnglesDifference.x / iSteps, eAnglesDifference.y / iSteps, 0);
			for (local i = 0; i < iSteps; i++)
			{
				flTime += flDeltaTime;
				eAnglesStart += eAnglesDelta;
				CreateTimer(flTime, function(hEntity, eAngles){
					if (hEntity.IsValid())
					{
						if (g_bAllowChangeCameraAngles[hEntity.GetEntityIndex()])
						{
							if (eAngles.y < -180 || eAngles.y > 180) eAngles.y = Math.NormalizeAngle(eAngles.y);
							TP(hEntity, null, eAngles, null);
						}
					}
				}, hEntity, eAnglesStart);
				if (i == iSteps - 1)
				{
					CreateTimer(flTime, function(hEntity){
						if ("SetCameraAnglesCompleted" in getroottable()) SetCameraAnglesCompleted(hEntity);
					}, hEntity);
				}
			}
		}
		else // spherical (with a choice) linear interpolation
		{
			local frametime = 1.0 / iSteps;
			for (local t = frametime; t < 1.0; t += frametime)
			{
				flTime += flDeltaTime;
				CreateTimer(flTime, function(hEntity, eAngles){
					if (hEntity.IsValid())
					{
						if (g_bAllowChangeCameraAngles[hEntity.GetEntityIndex()])
						{
							hEntity.SetAngles(eAngles);
						}
					}
				}, hEntity, OrientationLerp(eAnglesStart, eAngles, t, bSlerp, true));
				if (t + frametime >= 1.0)
				{
					CreateTimer(flTime, function(hEntity){
						if ("SetCameraAnglesCompleted" in getroottable()) SetCameraAnglesCompleted(hEntity);
					}, hEntity);
				}
			}
		}
	}
}

/** Set an entity angles to an entity
 * Signature: void CEntity(CBaseEntity entity).SetAnglesToEntity(handle entity, Vector vecCorrection, bool bUseBodyPosition, float bodyPositionPercent)
*/

function CEntity::SetAnglesToEntity(hTarget, vecCorrection = Vector(), bUseBodyPosition = false, flBodyPositionPercent = 0.5)
{
    if (!IsEntityValid()) return;
    local vecDir = vecCorrection;
    if (hTarget.IsPlayer()) vecDir += (bUseBodyPosition ? hTarget.GetBodyPosition(flBodyPositionPercent) : hTarget.EyePosition()) - (hEntity.IsPlayer() ? hEntity.EyePosition() : hEntity.GetOrigin());
    else vecDir += hTarget.GetOrigin() - (hEntity.IsPlayer() ? hEntity.EyePosition() : hEntity.GetOrigin());
    TP(hEntity, null, vecDir.Normalize(), null, true);
}

/** Get an entity angles to anentity
 * Signature: float CEntity(CBaseEntity entity).GetAnglesToEntity(handle entity, Vector vecCorrection, bool bUseBodyPosition, float bodyPositionPercent)
*/

function CEntity::GetAnglesToEntity(hTarget, vecCorrection = Vector(), bUseBodyPosition = false, flBodyPositionPercent = 0.5)
{
    if (!IsEntityValid()) return;
	local vecDir = vecCorrection;
    if (hTarget.IsPlayer()) vecDir += (bUseBodyPosition ? hTarget.GetBodyPosition(flBodyPositionPercent) : hTarget.EyePosition()) - (hEntity.IsPlayer() ? hEntity.EyePosition() : hEntity.GetOrigin());
    else vecDir += hTarget.GetOrigin() - (hEntity.IsPlayer() ? hEntity.EyePosition() : hEntity.GetOrigin());
    return VVectorToQAngle(vecDir.Normalize());
}

/** Get a position to ground
 * Signature: Vector CEntity(CBaseEntity entity).GetPositionToGround()
*/

function CEntity::GetPositionToGround()
{
    if (!IsEntityValid()) return;
	return DoTraceLine(hEntity.GetOrigin(), Vector(0, 0, -1), eTrace.Type_Pos, eTrace.Distance, eTrace.Mask_Shot, hEntity);
}

/** Get a distance to ground
 * Signature: Vector CEntity(CBaseEntity entity).GetDistanceToGround()
*/

function CEntity::GetDistanceToGround()
{
    if (!IsEntityValid()) return;
	return (hEntity.GetOrigin() - DoTraceLine(hEntity.GetOrigin(), Vector(0, 0, -1), eTrace.Type_Pos, eTrace.Distance, eTrace.Mask_Shot, hEntity)).Length();
}

/** Get entity's script scope table
 * Signature: table CEntity(CBaseEntity entity).GetScriptScope()
*/

function CEntity::GetScriptScope()
{
	if (!IsEntityValid()) return;
	hEntity.ValidateScriptScope();
	return hEntity.GetScriptScope();
}

/** Get entity's script scope variable
 * Signature: any CEntity(CBaseEntity entity).GetScriptScopeVar(any key)
*/

function CEntity::GetScriptScopeVar(key)
{
	if (!IsEntityValid()) return;
	hEntity.ValidateScriptScope();
	if (CEntity(hEntity).KeyInScriptScope(key)) return CEntity(hEntity).GetScriptScope()[key];
}

/** Set entity's script scope variable
 * Signature: void CEntity(CBaseEntity entity).SetScriptScopeVar(any key, any variable)
*/

function CEntity::SetScriptScopeVar(key, var)
{
	if (!IsEntityValid()) return;
	hEntity.ValidateScriptScope();
	hEntity.GetScriptScope()[key] <- var;
}

/** If a key in entity's script scope
 * Signature: bool CEntity(CBaseEntity entity).KeyInScriptScope(any key)
*/

function CEntity::KeyInScriptScope(key)
{
	if (!IsEntityValid()) return;
	hEntity.ValidateScriptScope();
	if (key in CEntity(hEntity).GetScriptScope()) return true;
	return false;
}

/** Remove entity's script scope key
 * Signature: void CEntity(CBaseEntity entity).RemoveScriptScopeKey(any key)
*/

function CEntity::RemoveScriptScopeKey(key)
{
	if (!IsEntityValid()) return;
	hEntity.ValidateScriptScope();
	if (CEntity(hEntity).KeyInScriptScope(key)) delete CEntity(hEntity).GetScriptScope()[key];
}

/*===============================*\
 *    Extends Classes Methods    *
\*===============================*/

function InjectAdditionalClassMethods()
{
	if (!("CTerrorPlayer" in getroottable())) return;

	/** Send a client command
	* Signature: void CTerrorPlayer.ClientCommand(string command, float delay)
	*/

	function CTerrorPlayer::ClientCommand(sCommand = "", flDelay = 0.0)
	{
		local hClientCommand = SpawnEntityFromTable("point_clientcommand", {});
		AcceptEntityInput(hClientCommand, "Command", sCommand.tostring(), flDelay.tofloat(), this);
		AcceptEntityInput(hClientCommand, "Kill", "", flDelay.tofloat(), null);
	}

	/** Press a button
	* Signature: void CTerrorPlayer.PressButton(int button, float releasedelay)
	*/

	function CTerrorPlayer::PressButton(iButton, flReleaseDelay = 0.01)
	{
		if (CEntity(this).KeyInScriptScope(format("is_bitmask_%d_forced", iButton)))
			if (CEntity(this).GetScriptScopeVar(format("is_bitmask_%d_forced", iButton)))
				return;

		NetProps.SetPropInt(this, "m_afButtonForced", NetProps.GetPropInt(this, "m_afButtonForced") | iButton);
		CEntity(this).SetScriptScopeVar(format("is_bitmask_%d_forced", iButton), true);

		CreateTimer(flReleaseDelay, function(hPlayer, iButton){
			NetProps.SetPropInt(hPlayer, "m_afButtonForced", NetProps.GetPropInt(hPlayer, "m_afButtonForced") & ~iButton)
			CEntity(hPlayer).SetScriptScopeVar(format("is_bitmask_%d_forced", iButton), false);
		}, this, iButton);
	}

	/** Is a player the host
	* Signature: bool CTerrorPlayer.IsHost()
	*/

	function CTerrorPlayer::IsHost()
	{
		local hGameRules, hPlayerManager;
		if (!(hGameRules = Entities.FindByClassname(null, "terror_gamerules")) || !(hPlayerManager = Entities.FindByClassname(null, "terror_player_manager"))) return false;
		try {
			if (NetProps.HasProp(hPlayerManager, "m_listenServerHost") && NetProps.HasProp(hGameRules, "m_bIsDedicatedServer")) {
				return NetProps.GetPropIntArray(hPlayerManager, "m_listenServerHost", this.GetEntityIndex()) && !NetProps.GetPropInt(hGameRules, "m_bIsDedicatedServer");
			}
		} catch (e) {
			printl("[IsHost] Error accessing NetProps: " + e);
		}
		return false;
	}

	/** Is a player alive
	* Signature: bool CTerrorPlayer.IsAlive()
	*/

	function CTerrorPlayer::IsAlive()
	{
		if (this.IsDead() || this.IsDying()) return false;
		return true;
	}

	/** Kill a player
	* Signature: void CTerrorPlayer.KillPlayer(handle attacker, int damageType)
	*/

	function CTerrorPlayer::KillPlayer(hAttacker = null, iDamageType = DMG_GENERIC)
	{
		if (this.IsSurvivor()) this.SetReviveCount(2);
		this.TakeDamage((1 << 30), DMG_GENERIC, !hAttacker ? this : hAttacker);
	}

	/** Hide the player's HUD
	* Signature: void CTerrorPlayer.HideHUD(int bitmask)
	*/

	function CTerrorPlayer::HideHUD(bitmask)
	{
		try {
			if (NetProps.HasProp(this, "m_Local.m_iHideHUD")) {
				NetProps.SetPropInt(this, "m_Local.m_iHideHUD", bitmask);
			}
		} catch (e) {
			printl("[HideHUD] Error setting HUD visibility: " + e);
		}
	}

	/** Returns a vector between player's eye position and foot position
	* Signature: Vector CTerrorPlayer.GetBodyPosition(float distanceFactor)
	*/

	function CTerrorPlayer::GetBodyPosition(flPercent = 0.5)
	{
		return VectorLerp(this.GetOrigin(), this.EyePosition(), flPercent);
	}

	/** Is a player attacked by a special infected
	* Signature: bool CTerrorPlayer.IsAttackedBySI()
	*/

	function CTerrorPlayer::IsAttackedBySI()
	{
		if (this.IsSurvivor())
		{
			try {
				if ((NetProps.HasProp(this, "m_pounceAttacker") && NetProps.GetPropEntity(this, "m_pounceAttacker")) ||
					(NetProps.HasProp(this, "m_jockeyAttacker") && NetProps.GetPropEntity(this, "m_jockeyAttacker")) ||
					(NetProps.HasProp(this, "m_pummelAttacker") && NetProps.GetPropEntity(this, "m_pummelAttacker")) ||
					(NetProps.HasProp(this, "m_carryAttacker") && NetProps.GetPropEntity(this, "m_carryAttacker")) ||
					(NetProps.HasProp(this, "m_tongueOwner") && NetProps.GetPropEntity(this, "m_tongueOwner")))
					return true;
			} catch (e) {
				// Silently handle error, assume not attacked
			}
			return false;
		}
		printl("[IsAttackedBySI] Player is not a survivor");
	}

	/** Get a SI attacked a player
	* Signature: handle CTerrorPlayer.GetSIAttacker()
	*/

	function CTerrorPlayer::GetSIAttacker()
	{
		if (this.IsSurvivor())
		{
			try {
				if (NetProps.HasProp(this, "m_pounceAttacker")) {
					local attacker = NetProps.GetPropEntity(this, "m_pounceAttacker");
					if (attacker) return attacker;
				}
				if (NetProps.HasProp(this, "m_jockeyAttacker")) {
					local attacker = NetProps.GetPropEntity(this, "m_jockeyAttacker");
					if (attacker) return attacker;
				}
				if (NetProps.HasProp(this, "m_pummelAttacker")) {
					local attacker = NetProps.GetPropEntity(this, "m_pummelAttacker");
					if (attacker) return attacker;
				}
				if (NetProps.HasProp(this, "m_carryAttacker")) {
					local attacker = NetProps.GetPropEntity(this, "m_carryAttacker");
					if (attacker) return attacker;
				}
				if (NetProps.HasProp(this, "m_tongueOwner")) {
					local attacker = NetProps.GetPropEntity(this, "m_tongueOwner");
					if (attacker) return attacker;
				}
			} catch (e) {
				// Silently handle error
			}
			return null;
		}
		printl("[IsAttackedBySI] Player is not a survivor");
	}

	/** Get a SI's victim
	* Signature: handle CTerrorPlayer.GetSIVictim()
	*/

	function CTerrorPlayer::GetSIVictim()
	{
		if (!this.IsSurvivor())
		{
			try {
				if (NetProps.HasProp(this, "m_pounceVictim")) {
					local victim = NetProps.GetPropEntity(this, "m_pounceVictim");
					if (victim) return victim;
				}
				if (NetProps.HasProp(this, "m_jockeyVictim")) {
					local victim = NetProps.GetPropEntity(this, "m_jockeyVictim");
					if (victim) return victim;
				}
				if (NetProps.HasProp(this, "m_pummelVictim")) {
					local victim = NetProps.GetPropEntity(this, "m_pummelVictim");
					if (victim) return victim;
				}
				if (NetProps.HasProp(this, "m_carryVictim")) {
					local victim = NetProps.GetPropEntity(this, "m_carryVictim");
					if (victim) return victim;
				}
				if (NetProps.HasProp(this, "m_tongueVictim")) {
					local victim = NetProps.GetPropEntity(this, "m_tongueVictim");
					if (victim) return victim;
				}
			} catch (e) {
				// Silently handle error
			}
			return null;
		}
		printl("[IsAttackedBySI] Player is not an infected");
	}

	/** Is a player a special infected
	* Signature: bool CTerrorPlayer.IsSpecialInfected()
	*/

	function CTerrorPlayer::IsSpecialInfected()
	{
		local teamNum = 0;
		try {
			if (NetProps.HasProp(this, "m_iTeamNum")) {
				teamNum = NetProps.GetPropInt(this, "m_iTeamNum");
			}
		} catch (e) {
			// Silently handle error, assume not infected team
		}
		if (teamNum == 3)
		{
			switch (this.GetZombieType())
			{
				case ZOMBIE_SMOKER:
				case ZOMBIE_BOOMER:
				case ZOMBIE_HUNTER:
				case ZOMBIE_SPITTER:
				case ZOMBIE_JOCKEY:
				case ZOMBIE_CHARGER:
					return true;
				default:
					return false;
			}
		}
		printl("[IsSpecialInfected] Player is not an infected");
	}

	/** Set a player's ammo
	* Signature: void CTerrorPlayer.SetAmmo(int slot, int clips, int ammo, int upgradeammo)
	*/

	function CTerrorPlayer::SetAmmo(iSlot, iClip = null, iAmmo = null, iUpgradeAmmo = null)
	{
		local tInv = {};
		GetInvTable(this, tInv);
		if (iSlot == eInventoryWeapon.Primary)
		{
			if ("slot0" in tInv)
			{
				local hWeapon = tInv["slot0"];
				if (iClip != null)
				{
					NetProps.SetPropInt(hWeapon, "m_iClip1", iClip);
				}
				if (iAmmo != null)
			{
				try {
					local ammoType = NetProps.HasProp(hWeapon, "m_iPrimaryAmmoType") ? NetProps.GetPropInt(hWeapon, "m_iPrimaryAmmoType") : 0;
					if (NetProps.HasProp(this, "m_iAmmo")) {
						NetProps.SetPropIntArray(this, "m_iAmmo", iAmmo, ammoType);
					}
					if (iUpgradeAmmo != null)
					{
						local iUpgradeType = NetProps.HasProp(hWeapon, "m_upgradeBitVec") ? NetProps.GetPropInt(hWeapon, "m_upgradeBitVec") : 0;
						if ((iUpgradeType & eUpgrade.Incendiary || iUpgradeType & eUpgrade.Explosive) && NetProps.HasProp(hWeapon, "m_nUpgradedPrimaryAmmoLoaded")) {
							NetProps.SetPropInt(hWeapon, "m_nUpgradedPrimaryAmmoLoaded", iUpgradeAmmo);
						} else {
							printl("[SetAmmo] No upgrade ammo found");
						}
					}
				} catch (e) {
					printl("[SetAmmo] NetProps access failed for primary weapon: " + e);
				}
			}
			}
			else printl("[SetAmmo] Invalid weapon");
		}
		else if (iSlot == eInventoryWeapon.Secondary && iClip != null)
		{
			if ("slot1" in tInv && tInv["slot1"].GetClassname() != "weapon_melee") {
				try {
					if (NetProps.HasProp(tInv["slot1"], "m_iClip1")) {
						NetProps.SetPropInt(tInv["slot1"], "m_iClip1", iClip);
					}
				} catch (e) {
					printl("[SetAmmo] NetProps access failed for secondary weapon: " + e);
				}
			} else {
				printl("[SetAmmo] Invalid weapon");
			}
		}
		else printl("[SetAmmo] Wrong inventory slot");
	}

	/** Do trace Line
	* Signature: handle/Vector CTerrorPlayer.DoTraceLine(int hittype, float distance, int masktype)
	*/

	function CTerrorPlayer::DoTraceLine(tr_type = eTrace.Type_Hit, tr_dist = eTrace.Distance, tr_mask = eTrace.Mask_All)
	{
		local ent;
		local vecStart = this.EyePosition();
		local vecEnd = vecStart + this.EyeAngles().Forward().Scale(tr_dist);
		local hTrace =
		{
			start = vecStart
			end = vecEnd
			ignore = this
			mask = tr_mask
		}
		TraceLine(hTrace);
		if (tr_type == eTrace.Type_Hit)
			if (hTrace.hit)
				if ((ent = hTrace.enthit).GetEntityIndex() != 0)
					return ent;
		if (tr_type == eTrace.Type_Pos) return hTrace.pos;
		return null;
	}
}

/*===============================*\
 *        Hook Functions         *
\*===============================*/

/* Game event hook */

/** Hook game event
 * Signature: void HookEvent(string event, function callFunction, table scope)
*/

function HookEvent(sEvent = null, hFunction = null, tScope = null)
{
	if (typeof(sEvent) != "string" || typeof(hFunction) != "function") return printl("[HookEvent] Wrong type of variable");
	if (!(sEvent in g_tCallBackEvents))
	{
		g_tCallBackEvents[sEvent] <- {};
		g_tCallBackEvents[sEvent]["CallBack_Functions"] <- [];
		g_tCallBackEvents[sEvent]["OnGameEvent_" + sEvent] <- function(tParams)
		{
			foreach (func in g_tCallBackEvents[sEvent]["CallBack_Functions"])
			{
				if ("userid" in tParams) tParams["_player"] <- GetPlayerFromUserID(tParams.userid);
				if ("victim" in tParams) tParams["_victim"] <- GetPlayerFromUserID(tParams.victim);
				if ("entityid" in tParams) tParams["_entity"] <- EntIndexToHScript(tParams.entityid);
				if ("subject" in tParams) tParams["_subject"] <- GetPlayerFromUserID(tParams.subject);
				if ("attacker" in tParams) tParams["_attacker"] <- GetPlayerFromUserID(tParams.attacker);
				// func = compilestring("return " + func)();
				func(tParams);
			}
		}
	}
	if (hFunction != null)
	{
		local sFunction;
		foreach (key, val in (tScope != null ? tScope : getroottable()))
		{
			if (val == hFunction)
			{
				sFunction = key;
				break;
			}
		}
		if (!sFunction) return printl("[HookEvent] The specified function was not found in the certain scope");
		foreach (func in g_tCallBackEvents[sEvent]["CallBack_Functions"]) if (func == sFunction) return printf("[HookEvent] Event hook function '%s' already registered", sFunction);
		printf("[HookEvent] Event hook function '%s' has been registered for the game event '%s'", sFunction, sEvent);
		g_tCallBackEvents[sEvent]["CallBack_Functions"].push(hFunction); // replaced by a function address
	}
	else return printl("[HookEvent] Invalid function specified");
	__CollectEventCallbacks(g_tCallBackEvents[sEvent], "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener);
}

/** Unhook game event or function
 * Signature: void UnhookEvent(string event, function callFunction, table scope)
*/

function UnhookEvent(sEvent = null, hFunction = null, tScope = null)
{
	if (typeof(sEvent) != "string") return printl("[UnhookEvent] Wrong type of variable");
	if (sEvent in g_tCallBackEvents)
	{
		if (hFunction != null)
		{
			if (typeof(hFunction) != "function") return printl("[UnhookEvent] Wrong type of variable");
			local sFunction;
			foreach (key, val in (tScope != null ? tScope : getroottable()))
			{
				if (val == hFunction)
				{
					sFunction = key;
					break;
				}
			}
			if (!sFunction) return printl("[UnhookEvent] The specified function was not found in the certain scope");
			foreach (idx, func in g_tCallBackEvents[sEvent]["CallBack_Functions"])
			{
				if (func == sFunction)
				{
					printf("[UnhookEvent] Event hook function '%s' has been unhooked for the game event '%s'", sFunction, sEvent);
					return g_tCallBackEvents[sEvent]["CallBack_Functions"].remove(idx);
				}
			}
			return printf("[UnhookEvent] Event hook function '%s' is not registered", sFunction);
		}
		else
		{
			printf("[UnhookEvent] Game event '%s' has been unhooked", sEvent);
			return delete g_tCallBackEvents[sEvent];
		}
	}
	printf("[UnhookEvent] Event '%s' is not registered", sEvent); 
}

/** Unhook all game events
 * Signature: void UnhookAllEvents()
*/

function UnhookAllEvents()
{
	foreach (event, val in g_tCallBackEvents) delete g_tCallBackEvents[event];
	printl("[UnhookAllEvents] All events have been unhooked");
}

/** Print callback table
 * Signature: void PrintCallBackTable(bool bDeepPrint)
*/

function PrintCallBackTable(bDeepPrint = true)
{
	printl("~~~~~~~~~~~~~~~~~~~~~~ g_tCallBackEvents Table ~~~~~~~~~~~~~~~~~~~~~~~" + (bDeepPrint ? "\n" : ""));
	foreach (event, val in g_tCallBackEvents)
	{
		printl("Game Event = " + event);
		if (bDeepPrint)
		{
			printl("{");
			foreach (key, value in g_tCallBackEvents[event])
			{
				printl("\t" + key + " = " + value);
				if (key == "CallBack_Functions" && key.len() != 0)
				{
					printl("\t{");
					foreach (idx, func in g_tCallBackEvents[event][key]) printl("\t\t" + func);
					printl("\t}");
				}
			}
			printl("}\n");
		}
	}
	printl("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
}

/* Registration of functions called after a certain interval */

/** Register loop function
 * Signature: void RegisterLoopFunction(string callFunction, float refireTime, any args)
*/

function RegisterLoopFunction(sFunction, flRefireTime, ...)
{
	if (typeof(sFunction) != "string") return printl("[RegisterLoopFunction] Wrong type of variable");
	if (!IsFunctionExist(sFunction)) return printf("[RegisterLoopFunction] Function '%s' doesn't exist", sFunction);
	foreach (func in g_aLoopFunctions)
	{
		if (func.GetFunctionName() == sFunction)
		{
			local aVars = clone func.GetInputVariables();
			aVars.remove(0);
			if (IsArraysEqual(aVars, vargv)) printf("[RegisterLoopFunction] Function '%s' already registered", sFunction);
			else printf("[RegisterLoopFunction] Function '%s' already registered", sFunction);
			return;
		}
	}
	local sName = LF_PREFIX + sFunction.tolower();
	local hTimer = Entities.FindByName(null, sName);
	if (!hTimer)
	{
		local __loop_func = CLoopFunction(sFunction, flRefireTime, vargv);
		hTimer = SpawnEntityFromTable("logic_script", {targetname = sName});
		CEntity(hTimer).SetScriptScopeVar("__loop_params", {
			__func = sFunction
			__with_args = vargv.len() > 0
			__args = __loop_func.GetInputVariables()
		});
		CEntity(hTimer).SetScriptScopeVar("Think", function(){
			if (this["__loop_params"].__with_args)
			{
				CreateTimer(flRefireTime, function(sFunction, aInputVars){
					if (IsFunctionExist(sFunction))
						compilestring("return " + sFunction)().acall(aInputVars);
				}, this["__loop_params"].__func, this["__loop_params"].__args);
			}
			else CallScriptFunction(sFunction, flRefireTime, self, self);
			CallScriptFunction("Think", flRefireTime, self, self);
		});
		if (vargv.len() > 0)
		{
			CreateTimer(0.01, function(sFunction, aInputVars){
				compilestring("return " + sFunction)().acall(aInputVars);
			}, sFunction, __loop_func.GetInputVariables());
		}
		else CallScriptFunction(sFunction, 0.01, hTimer, hTimer);
		CallScriptFunction("Think", 0.01, hTimer, hTimer);
		if (vargv.len() > 0)
		{
			local sVars = "";
			foreach (idx, var in vargv)
			{
				if (vargv.len() - 1 == idx) sVars += var;
				else sVars += var + ", ";
			}
			printf("[RegisterLoopFunction] Function '%s' with refire time '%.02f' and input variables: '%s' has been registered", sFunction, flRefireTime, sVars);
		}
		else printf("[RegisterLoopFunction] Function '%s' with refire time '%.02f' has been registered", sFunction, flRefireTime);
		g_aLoopFunctions.push(__loop_func);
	}
	else
	{
		hTimer.Kill();
		if (vargv.len() > 0)
		{
			local aVars = [this, sFunction, flRefireTime];
			aVars.extend(vargv);
			RegisterLoopFunction.acall(aVars);
		}
		else
		{
			RegisterLoopFunction(sFunction, flRefireTime);
		}
	}
}

/** Remove loop function
 * Signature: void RemoveLoopFunction(string callFunction, any args)
*/

function RemoveLoopFunction(sFunction, ...)
{
	if (typeof(sFunction) != "string") return printl("[RemoveLoopFunction] Wrong type of variable");
	if (!IsFunctionExist(sFunction)) return printf("[RemoveLoopFunction] Function '%s' doesn't exist", sFunction);
	foreach (idx, func in g_aLoopFunctions)
	{
		if (func.GetFunctionName() == sFunction)
		{
			if (vargv.len() > 0)
			{
				local aVars = clone func.GetInputVariables();
				aVars.remove(0);
				if (IsArraysEqual(aVars, vargv))
				{
					local sVars = "";
					local hTimer = Entities.FindByName(null, func.GetTimerName());
					if (hTimer) hTimer.Kill();
					foreach (idx, var in vargv)
					{
						if (vargv.len() - 1 == idx) sVars += var;
						else sVars += var + ", ";
					}
					printf("[RemoveLoopFunction] Function '%s' with input variables: '%s' has been removed", sFunction, sVars);
					g_aLoopFunctions.remove(idx);
					return;
				}
			}
			else
			{
				local hTimer = Entities.FindByName(null, func.GetTimerName());
				if (hTimer) hTimer.Kill();
				printf("[RemoveLoopFunction] Function '%s' has been removed", sFunction);
				g_aLoopFunctions.remove(idx);
				return;
			}
		}
	}
	if (vargv.len() > 0)
	{
		local sVars = "";
		foreach (idx, var in vargv)
		{
			if (vargv.len() - 1 == idx) sVars += var;
			else sVars += var + ", ";
		}
		printf("[RemoveLoopFunction] Function '%s' with input variables: '%s' is not registered", sFunction, sVars);
	}
	else printf("[RemoveLoopFunction] Function '%s' is not registered", sFunction);
}

/** Is loop function registered
 * Signature: bool IsLoopFunctionRegistered(string callFunction, any args)
*/

function IsLoopFunctionRegistered(sFunction, ...)
{
    if (typeof(sFunction) != "string") return printl("[IsLoopFunctionRegistered] Wrong type of variable");
    if (!IsFunctionExist(sFunction)) return printf("[IsLoopFunctionRegistered] Function '%s' doesn't exist", sFunction);
	foreach (idx, func in g_aLoopFunctions)
	{
		if (func.GetFunctionName() == sFunction)
		{
			local aVars = clone func.GetInputVariables();
			aVars.remove(0);
			if (IsArraysEqual(aVars, vargv)) return true;
		}
	}
	return false;
}

/** Print loop functions
 * Signature: void PrintLoopFunctions(bool bDeepPrint)
*/

function PrintLoopFunctions(bDeepPrint = true)
{
	printl("~~~~~~~~~~~~~~~~~~~~ g_aLoopFunctions Array ~~~~~~~~~~~~~~~~~~~~" + (bDeepPrint ? "\n" : ""));
	foreach (func in g_aLoopFunctions)
	{
		printl("Function = " + func.GetFunctionName());
		if (bDeepPrint)
		{
			printl("{");
			printl("\tLogic Timer: " + func.GetTimerName());
			printl("\tRefire Time: " + func.GetRefireTime() + (func.GetRefireTime() == 0.01 ? " (per game tick)" : ""));
			printl("}\n");
		}
	}
	printl("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
}

/* Registration of functions called every tick */

/** Register on tick function
 * Signature: void RegisterOnTickFunction(string callFunction, args)
*/

function RegisterOnTickFunction(sFunction, ...)
{
	if (typeof(sFunction) != "string") return printl("[RegisterOnTickFunction] Wrong type of variable");
	if (!IsFunctionExist(sFunction)) return printl("[RegisterOnTickFunction] The specified function doesn't exist");
	foreach (func in g_aOnTickFunctions)
	{
		if (func.GetFunctionName() == sFunction)
		{
			local aVars = clone func.GetInputVariables();
			aVars.remove(0);
			if (IsArraysEqual(aVars, vargv)) return printf("[RegisterOnTickFunction] Function '%s' already registered", sFunction);
		}
	}
	if (vargv.len() > 0)
	{
		local sVars = "";
		foreach (idx, var in vargv)
		{
			if (vargv.len() - 1 == idx) sVars += var;
			else sVars += var + ", ";
		}
		printf("[RegisterOnTickFunction] Function '%s' with input variables: '%s' has been registered", sFunction, sVars);
	}
	else printf("[RegisterOnTickFunction] Function '%s' has been registered", sFunction);
	g_aOnTickFunctions.push(COnTickFunction(sFunction, vargv));
}

/** Remove on tick function
 * Signature: void RemoveOnTickFunction(string callFunction, args)
*/

function RemoveOnTickFunction(sFunction, ...)
{
	if (typeof(sFunction) != "string") return printl("[RemoveOnTickFunction] Wrong type of variable");
	if (!IsFunctionExist(sFunction)) return printl("[RemoveOnTickFunction] The specified function doesn't exist");
	foreach (idx, func in g_aOnTickFunctions)
	{
		if (func.GetFunctionName() == sFunction)
		{
			if (vargv.len() > 0)
			{
				local aVars = clone func.GetInputVariables();
				aVars.remove(0);
				if (IsArraysEqual(aVars, vargv))
				{
					local sVars = "";
					foreach (idx, var in vargv)
					{
						if (vargv.len() - 1 == idx) sVars += var;
						else sVars += var + ", ";
					}
					printf("[RemoveOnTickFunction] Function '%s' with input variables: '%s' has been removed", sFunction, sVars);
					return g_aOnTickFunctions.remove(idx);
				}
			}
			else
			{
				printf("[RemoveOnTickFunction] Function '%s' has been removed", sFunction);
				return g_aOnTickFunctions.remove(idx);
			}
		}
	}
	if (vargv.len() > 0)
	{
		local sVars = "";
		foreach (idx, var in vargv)
		{
			if (vargv.len() - 1 == idx) sVars += var;
			else sVars += var + ", ";
		}
		printf("[RemoveOnTickFunction] Function '%s' with input variables: '%s' is not registered", sFunction, sVars);
	}
	else printf("[RemoveOnTickFunction] Function '%s' is not registered", sFunction);
}

/** Is on tick function registered
 * Signature: bool IsOnTickFunctionRegistered(string callFunction, args)
*/

function IsOnTickFunctionRegistered(sFunction, ...)
{
	if (typeof(sFunction) != "string") return printl("[IsOnTickFunctionRegistered] Wrong type of variable");
	if (!IsFunctionExist(sFunction)) return printl("[IsOnTickFunctionRegistered] The specified function doesn't exist");
	foreach (idx, func in g_aOnTickFunctions)
	{
		if (func.GetFunctionName() == sFunction)
		{
			local aVars = clone func.GetInputVariables();
			aVars.remove(0);
			if (IsArraysEqual(aVars, vargv)) return true;
		}
	}
	return false;
}

/** Print on tick functions
 * Signature: void PrintOnTickFunctions(bool bDeepPrint)
*/

function PrintOnTickFunctions(bDeepPrint = true)
{
	printl("~~~~~~~~~~~~~~~~~~~ g_aOnTickFunctions Array ~~~~~~~~~~~~~~~~~~~" + (bDeepPrint ? "\n" : ""));
	foreach (func in g_aOnTickFunctions)
	{
		printl("Function = " + func.GetFunctionName());
		if (bDeepPrint)
		{
			if (func.GetInputVariables().len() == 1)
			{
				printl("\t");
				continue;
			}
			printl("{");
			foreach (idx, var in func.GetInputVariables())
			{
				if (idx == 0)
				{
					printl("\tInput Variables:");
					printl("\t{");
					continue;
				}
				printl("\t\tVar " + idx + " = " + var);
			}
			printl("\t}");
			printl("}\n");
		}
	}
	printl("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
}

/* Registration of custom chat commands */

/** Register chat command
 * Signature: void RegisterChatCommand(string command, function callFunction, bool bInputPlayerHandle, bool bInputValue)
*/

function RegisterChatCommand(sCommand = null, hFunction = null, bInputPlayerHandle = false, bInputValue = false)
{
	if (typeof(sCommand) != "string" || typeof(hFunction) != "function" || typeof(bInputPlayerHandle) != "bool" || typeof(bInputValue) != "bool") return printl("[RegisterChatCommand] Wrong type of variable");
	sCommand = sCommand.tolower();
	local ChatCommand = CChatCommand(sCommand, hFunction, bInputPlayerHandle, bInputValue);
	foreach (idx, command in g_aChatCommands)
	{
		if (typeof(command) == "instance")
		{
			if (sCommand == command.GetCommand())
			{
				g_aChatCommands[idx] = ChatCommand;
				return printf("[RegisterChatCommand] Already registered, but chat command '%s' has been replaced by an existing one", sCommand);
			}
		}
	}
	g_aChatCommands.push(ChatCommand);
	printf("[RegisterChatCommand] Chat command '%s' has been registered", sCommand);
}

/** Remove chat command
 * Signature: void RemoveChatCommand(string command)
*/

function RemoveChatCommand(sCommand = null)
{
	if (typeof(sCommand) != "string") return printl("[RemoveChatCommand] Wrong type of variable");
	sCommand = sCommand.tolower();
	foreach (idx, command in g_aChatCommands)
	{
		if (sCommand == command.GetCommand())
		{
			g_aChatCommands.remove(idx);
			return printf("[RemoveChatCommand] Chat command '%s' has been removed", sCommand);
		}
	}
	printf("[RemoveChatCommand] Chat command '%s' is not registered", sCommand);
}

/** Print chat commands
 * Signature: void PrintChatCommands(bool bDeepPrint)
*/

function PrintChatCommands(bDeepPrint = true)
{
	printl("~~~~~~~~~~~~~~~~~~~~ g_aChatCommands Array ~~~~~~~~~~~~~~~~~~~~~" + (bDeepPrint ? "\n" : ""));
	foreach (command in g_aChatCommands)
	{
		printl("Command = " + command.GetCommand());
		if (bDeepPrint)
		{
			printl("{");
			printl("\tCalling Function: " + command.GetFunctionHandle());
			printl("\tInput Player Handle: " + command.GetInputPlayerHandle());
			printl("\tInput Value: " + command.GetInputValue());
			printl("}\n");
		}
	}
	printl("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
}

/* Registration of callback functions by pressing a button */

/** Register callback function for a specified button
 * Signature: void RegisterButtonListener(int button, string callFunction, int presstype, int team)
*/

function RegisterButtonListener(iButton = null, sFunction = null, iType = eButtonType.Pressed, iTeam = eTeam.Everyone)
{
	if (typeof(iButton) != "integer" || typeof(sFunction) != "string" || typeof(iTeam) != "integer" || typeof(iType) != "integer") return printl("[RegisterButtonListener] Wrong type of variable");
	if (eButtonType.Pressed < iType && iType > eButtonType.Hold || eTeam.Everyone < iTeam && iTeam > eTeam.Infected) return printl("[RegisterButtonListener] Invalid button type or team");
	foreach (button in g_aButtonsListener)
		if (button.GetButton() == iButton)
			if (button.GetFunction() == sFunction)
				return printf("[RegisterButtonListener] Button '%d' with a callback function '%s' already registered", iButton, sFunction);
	printf("[RegisterButtonListener] Button '%d' with a callback function '%s' has been registered", iButton, sFunction);
	g_aButtonsListener.push(CButtonListener(iButton, sFunction, iType, iTeam));
}

/** Remove registered button or bound callback function
 * Signature: void RemoveButtonListener(int button, string callFunction)
*/

function RemoveButtonListener(iButton = null, sFunction = null)
{
	if (typeof(iButton) != "integer") return printl("[RemoveButtonListener] Wrong type of variable");
	foreach (idx, button in g_aButtonsListener)
	{
		if (button.GetButton() == iButton)
		{
			if (sFunction != null)
			{
				if (button.GetFunction() == sFunction)
				{
					printf("[RemoveButtonListener] Callback function '%d' for the '%d' button has been removed", sFunction, iButton);
					return g_aButtonsListener.remove(idx);
				}
			}
			local shift = 0; local aButtons = [];
			for (local i = 0; i < g_aButtonsListener.len(); i++) if (g_aButtonsListener[i].GetButton() == iButton) aButtons.push(i);
			for (local j = 0; j < aButtons.len(); j++)
			{
				g_aButtonsListener.remove(aButtons[j] - shift);
				shift++;
			}
			printf("[RemoveButtonListener] Button '%d' has been removed", iButton);
		}
	}
	printf("[RemoveButtonListener] Button '%d' is not registered", iButton);
}

/** Print array of registered buttons
 * Signature: void PrintButtonsListenerArray(bool bDeepPrint)
*/

function PrintButtonsListenerArray(bDeepPrint = true)
{
	printl("~~~~~~~~~~~~~~~~~~~~~~ g_aButtonsListener Array ~~~~~~~~~~~~~~~~~~~~~~" + (bDeepPrint ? "\n" : ""));
	foreach (button in g_aButtonsListener)
	{
		printl("Buttons = " + button.GetButton());
		if (bDeepPrint)
		{
			local sType;
			local sFunction = "doesn't exist";
			foreach (name, val in getroottable())
			{
				if (button.GetCallingFunction() == val)
				{
					sFunction = name;
					break;
				}
			}
			switch (button.GetType())
			{
				case eButtonType.Pressed:
				{
					sType = "pressed";
					break;
				}
				case eButtonType.Released:
				{
					sType = "released";
					break;
				}
				case eButtonType.Hold:
				{
					sType = "hold";
					break;
				}
			}
			printl("{");
			printl("\tCalling Function: " + sFunction);
			printl("\tButton Type: " + sType);
			printl("\tTeam: " + button.GetTeam());
			printl("}\n");
		}
	}
	printl("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
}

/* Ready-made templates */

function OnTickCall()
{
	local bException, bProhibitChangeHook, NewValue, CurrentValue, min, max;
	for (local i = 0; i < g_aOnTickFunctions.len(); i++)
	{
		bException = false;
		try {
			g_aOnTickFunctions[i].GetFunctionHandle().acall(g_aOnTickFunctions[i].GetInputVariables());
		}
		catch (i) {
			printl("[OnTickFunction Watchdog] An error has occurred, on tick function has been removed");
			bException = true;
		}
		if (bException)
		{
			g_aOnTickFunctions.remove(i);
			i--;
		}
	}
	for (local j = 0; j < g_aTimers.len(); j++)
	{
		if (g_aTimers[j].GetCallTime() <= Time())
		{
			try {
				g_aTimers[j].GetFunctionHandle().acall(g_aTimers[j].GetInputVariables());
			}
			catch (j) {
				printl("[Timer Watchdog] An error has occurred, calling task has been removed");
			}
			g_aTimers.remove(j);
			j--;
		}
	}
	foreach (cvar in g_aConVars)
	{
		if (cvar.GetCurrentValue() != cvar.GetValue())
		{
			bProhibitChangeHook = false;
			NewValue = cvar.GetValue();
			CurrentValue = cvar.GetCurrentValue();
			try {
				switch (cvar.m_sType)
				{
					case "integer":
					{
						NewValue = NewValue.tointeger();
						CurrentValue = CurrentValue.tointeger();
						if (cvar.m_flMinValue != null && cvar.m_flMaxValue != null)
						{
							min = cvar.m_flMinValue.tointeger();
							max = cvar.m_flMaxValue.tointeger();
							if (CurrentValue < min || CurrentValue > max)
								bProhibitChangeHook = true;
							NewValue = Math.Clamp(NewValue, min, max);
						}
						else if (cvar.m_flMinValue != null && cvar.m_flMaxValue == null)
						{
							min = cvar.m_flMinValue.tointeger();
							if (CurrentValue < min) bProhibitChangeHook = true;
							if (NewValue < min) NewValue = min;
						}
						else if (cvar.m_flMinValue == null && cvar.m_flMaxValue != null)
						{
							max = cvar.m_flMaxValue.tointeger();
							if (CurrentValue > max) bProhibitChangeHook = true;
							if (NewValue > max) NewValue = max;
						}
						break;
					}
					case "float":
					{
						min = cvar.m_flMinValue;
						max = cvar.m_flMaxValue;
						NewValue = NewValue.tofloat();
						CurrentValue = CurrentValue.tofloat();
						if (cvar.m_flMinValue != null && cvar.m_flMaxValue != null)
						{
							if (CurrentValue < min || CurrentValue > max) bProhibitChangeHook = true;
							NewValue = Math.Clamp(NewValue, min, max);
						}
						else if (cvar.m_flMinValue != null && cvar.m_flMaxValue == null)
						{
							if (CurrentValue < min) bProhibitChangeHook = true;
							if (NewValue < min) NewValue = min;
						}
						else if (cvar.m_flMinValue == null && cvar.m_flMaxValue != null)
						{
							if (CurrentValue > max) bProhibitChangeHook = true;
							if (NewValue > max) NewValue = max;
						}
						break;
					}
				}
			}
			catch (error) {
				cvar.SetValue(CurrentValue);
				continue;
			}
			cvar.SetValue(NewValue);
			cvar.m_sValue = NewValue.tostring();
			if (cvar.m_bChangeHook && !bProhibitChangeHook && NewValue != CurrentValue)
			{
				cvar.m_ChangeHookFunction(cvar, CurrentValue, NewValue)
			}
		}
	}
}

function OnRoundStart(tParams)
{
	if ("OnGameplayStart" in getroottable())
		OnGameplayStart();

	if ("OnGameplayStart_PostSpawn" in getroottable())
		CreateTimer(0.01, OnGameplayStart_PostSpawn);
}

function OnPlayerSay(tParams)
{
	if (g_aChatCommands.len() > 0 && tParams["_player"])
	{
		local hPlayer = tParams["_player"];
		local sText = tParams.text.tolower();
		local sValue, aArgs, hFunction, bInputHandle, bInputValue, aArgsTemp;
		foreach (command in g_aChatCommands)
		{
			if (split(sText, " ")[0] == command.GetCommand())
			{
				sValue = null;
				aArgs = [this];
				hFunction = command.GetFunctionHandle();
				bInputHandle = command.GetInputPlayerHandle();
				bInputValue = command.GetInputValue();
				if (bInputValue)
				{
					aArgsTemp = split(sText, " ");
					foreach (idx, arg in aArgsTemp)
					{
						if (idx > 0)
						{
							if (!sValue) sValue = arg;
							else sValue += " " + arg;
						}
					}
					if (!sValue) sValue = CC_EMPTY_ARGUMENT;
				}
				if (sValue != CC_EMPTY_ARGUMENT && sValue != null) sValue = sValue.tolower();
				if (bInputHandle && !bInputValue) aArgs.extend([hPlayer]);
				else if (!bInputHandle && bInputValue) aArgs.extend([sValue]);
				else if (bInputHandle && bInputValue) aArgs.extend([hPlayer, sValue]);
				hFunction.acall(aArgs);
			}
		}
	}
}

function ButtonsListener_Think()
{
	if (g_aButtonsListener.len() > 0)
	{
		local hPlayer, team;
		while (hPlayer = Entities.FindByClassname(hPlayer, "player"))
		{
			foreach (button in g_aButtonsListener)
			{
				team = button.GetTeam();
				if (team == eTeam.Everyone) CheckButtons(hPlayer, button);
				else if (team == eTeam.Survivor && hPlayer.IsSurvivor()) CheckButtons(hPlayer, button);
				else CheckButtons(hPlayer, button);
			}
		}
	}
}

function CheckButtons(hPlayer, button)
{
	local buttons = 0;
	local button_type = button.GetType();
	local idx = hPlayer.GetEntityIndex();
	try {
		if (button_type == eButtonType.Pressed && NetProps.HasProp(hPlayer, "m_afButtonPressed")) {
			buttons = NetProps.GetPropInt(hPlayer, "m_afButtonPressed");
		} else if (button_type == eButtonType.Released && NetProps.HasProp(hPlayer, "m_afButtonReleased")) {
			buttons = NetProps.GetPropInt(hPlayer, "m_afButtonReleased");
		} else if (NetProps.HasProp(hPlayer, "m_nButtons")) {
			buttons = NetProps.GetPropInt(hPlayer, "m_nButtons");
		}
		if (buttons & button.GetButton()) button.GetCallingFunction()(hPlayer);
	} catch (e) {
		// Silently handle NetProps access errors
	}
}

function InjectAdditionalClassMethods_Think()
{
	local hPlayer;
	while (hPlayer = Entities.FindByClassname(hPlayer, "player"))
	{
		InjectAdditionalClassMethods();
		RemoveOnTickFunction("InjectAdditionalClassMethods_Think");
		printl("[InjectAdditionalClassMethods] Successfully injected");
		if ("AdditionalClassMethodsInjected" in getroottable())
			::AdditionalClassMethodsInjected();
		break;
	}
}

RegisterLoopFunction("OnTickCall", 0.01);
RegisterOnTickFunction("ButtonsListener_Think");
RegisterOnTickFunction("InjectAdditionalClassMethods_Think");

HookEvent("player_say", OnPlayerSay);
HookEvent("round_start", OnRoundStart);

/*===============================*\
 *         Math Functions        *
\*===============================*/

/** If the value is not a number
 * Signature: bool Math.IsNaN(float value)
*/

function Math::IsNaN(value)
{
	return ["1.#INF", "-1.#INF", "1.#IND", "-1.#IND", "1.#SNAN", "1.#QNAN"].find(value.tostring()) != null;
}

/** If the value is between two values
 * Signature: bool Math.Between(float value, float min, float max)
*/

function Math::Between(value, min, max)
{
	return max > min ? (value > min && value < max) : (value > max && value < min);
}

/** Get the sign of value
 * Signature: bool Math.Sign(float value)
*/

function Math::Sign(value)
{
	return value <=> 0;
}

/** Get the minimum value
 * Signature: bool Math.Min(float a, float b)
*/

function Math::Min(a, b)
{
	return a < b ? a : b;
}

/** Get the maximum value
 * Signature: bool Math.Min(float a, float, b)
*/

function Math::Max(a, b)
{
	return a > b ? a : b;
}

/** Get the clamped value
 * Signature: float Math.Clamp(float value, float min, float max)
*/

function Math::Clamp(n, min, max)
{
	return n < min ? min : (n > max ? max : n);
}

/** Linear Interpolation
 * Signature: float Math.Lerp(float start, float end, float percent)
*/

function Math::Lerp(a, b, t)
{
	if (a == b || t == 0) return a;
	if (t == 1) return b;
	return a + (b - a) * t;
}

/** Linear Interpolation #2
 * Signature: float Math.FLerp(float x, float x_start, float x_end, float y_start, float y_end)
*/

function Math::FLerp(x, x_start, x_end, y_start, y_end)
{
	x_end = x_end.tofloat(); x_start = x_start.tofloat();
	return y_start + ((x - x_start) * (y_end - y_start) / (x_end - x_start));
}

/** Returns the normalized angle
 * Signature: float Math.NormalizeAngle(float angle)
*/

function Math::NormalizeAngle(flAngle)
{
	if (flAngle >= -180.0 && flAngle <= 180.0) return flAngle;
	while (flAngle < -180.0) flAngle += 360.0;
	while (flAngle > 180.0) flAngle -= 360.0;
	return flAngle;
}

/*===============================*\
 *   Additional Vector Methods   *
\*===============================*/

/** Returns true if a vector is zero
 * Signature: Vector *instance.IsZero(float tolerance)
*/

function Vector::IsZero(flTolerance = 0.001)
{
	if (flTolerance < 0) flTolerance *= -1;
	return x >= -flTolerance && x <= flTolerance && y >= -flTolerance && y <= flTolerance && z >= -flTolerance && z <= flTolerance;
}

/** Returns a normalized vector
 * Signature: Vector *instance.Normalize()
*/

function Vector::Normalize()
{
	return this.Scale(1.0 / this.Length());
}

/** Returns the projection of vector from direction
 * Signature: Vector *instance.Project(Vector vector)
*/

function Vector::Project(vector)
{
	local vecNorm = vector.Normalize();
	return vecNorm.Scale(this.Dot(vecNorm));
}

/** Returns the rejection of vector from direction
 * Signature: Vector *instance.Reject(Vector vector)
*/

function Vector::Reject(vector)
{
	local vecNorm = vector.Normalize();
	return this - vecNorm.Scale(this.Dot(vecNorm));
}

/** Returns the reflection of a vector off a surface that have the specified normal
 * Signature: Vector VMath.Reflect(Vector vector_a, Vector vector_b, bool projectMethod, float factor)
*/

function VMath::Reflect(vector_a, vector_b, bProjectMethod = true, fFactor = 2.0)
{
	if (bProjectMethod) return vector_a - (vector_a.Project(vector_b) * fFactor);
	else return (vector_a.Reject(vector_b) * fFactor) - vector_a;
}

/** The scalar product of two vectors
 * Signature: float VMath.Dot(Vector vector_a, Vector vector_b)
*/

function VMath::Dot(vector_a, vector_b)
{
	return (vector_a.x * vector_b.x) + (vector_a.y * vector_b.y) + (vector_a.z * vector_b.z);
}

/** The vector product of two vectors
 * Signature: Vector VMath.Cross(Vector vector_a, Vector vector_b)
*/

function VMath::Cross(vector_a, vector_b)
{
	return Vector(vector_a.y * vector_b.z - vector_b.y * vector_a.z, vector_a.z * vector_b.x - vector_b.z * vector_a.x, vector_a.x * vector_b.y - vector_b.x * vector_a.y);
}

/** Returns the Forward Vector of angles
 * Signature: Vector VMath.Forward(QAngle angles)
*/

function VMath::Forward(eAngles)
{
	local flPitch = eAngles.x * Math.Deg2Rad;
	local flYaw = eAngles.y * Math.Deg2Rad;
	return Vector(cos(flPitch) * cos(flYaw), cos(flPitch) * sin(flYaw), sin(-flPitch));
}

/** Returns the Forward 2D Vector of angles
 * Signature: Vector VMath.Forward(QAngle angles)
*/

function VMath::Forward2D(eAngles)
{
	local flYaw = eAngles.y * Math.Deg2Rad;
	return Vector(cos(flYaw), sin(flYaw), 0);
}

/** Returns the Left Vector of angles
 * Signature: Vector VMath.Left(QAngle angles)
*/

function VMath::Left(eAngles)
{
	local flPitch = eAngles.x * Math.Deg2Rad;
	local flYaw = eAngles.y * Math.Deg2Rad;
	local flRoll = eAngles.z * Math.Deg2Rad;
	local flSinRoll, flSinPitch, flSinYaw, flCosRoll, flCosPitch, flCosYaw;
	flSinRoll = sin(flRoll); flSinPitch = sin(flPitch); flSinYaw = sin(flYaw);
	flCosRoll = cos(flRoll); flCosPitch = cos(flPitch); flCosYaw = cos(flYaw);
	return Vector(-1 * flSinRoll * flSinPitch * flCosYaw + -1 * flCosRoll * -flSinYaw, -1 * flSinRoll * flSinPitch * flSinYaw + -1 * flCosRoll * flCosYaw, -1 * flSinRoll * flCosPitch);
}

/** Returns the Up Vector of angles
 * Signature: Vector VMath.Up(QAngle angles)
*/

function VMath::Up(eAngles)
{
	local flPitch = eAngles.x * Math.Deg2Rad;
	local flYaw = eAngles.y * Math.Deg2Rad;
	local flRoll = eAngles.z * Math.Deg2Rad;
	local flSinRoll, flSinPitch, flSinYaw, flCosRoll, flCosPitch, flCosYaw;
	flSinRoll = sin(flRoll); flSinPitch = sin(flPitch); flSinYaw = sin(flYaw);
	flCosRoll = cos(flRoll); flCosPitch = cos(flPitch); flCosYaw = cos(flYaw);
	return Vector(flCosRoll * flSinPitch * flCosYaw + -flSinRoll * -flSinYaw, flCosRoll * flSinPitch * flSinYaw + -flSinRoll * flCosYaw, flCosRoll * flCosPitch);
}

/** Get the angle between two normalized vectors using the scalar product method (faster)
 * Signature: float GetAngleBetweenVectors(Vector vector_a, Vector vector_b)
*/

function GetAngleBetweenVectors(vector_a, vector_b)
{
	return acos(vector_a.Dot(vector_b)) * Math.Rad2Deg;
}

/** Get the angle between two normalized vectors using the vector product method
 * Signature: float GetAngleBetweenVectors(Vector vector_a, Vector vector_b)
*/

function GetAngleBetweenVectors2(vector_a, vector_b)
{
	return asin(vector_a.Cross(vector_b).Length()) * Math.Rad2Deg;
}

/** Returns euler angles of the vector
 * Signature: QAngle VectorToQAngle(Vector vector)
*/

function VectorToQAngle(vector)
{
	if (vector.IsZero(0.0)) return QAngle(0, 0, 0);
	local flPitch = -(atan(vector.z / vector.Length2D()) * Math.Rad2Deg);
	local flYaw = atan(vector.y / vector.x) * Math.Rad2Deg;
	if (vector.x < 0) flYaw += 180;
	return QAngle(flPitch, Math.IsNaN(flYaw) ? 0 : flYaw, 0);
}

/** Returns euler angles of the normalized vector
 * Signature: QAngle VectorToQAngle2(Vector direction)
*/

function VectorToQAngle2(vecDirection)
{
    local flPitch = asin(vecDirection.z);
    local flYaw = asin(vecDirection.y / cos(flPitch)) * Math.Rad2Deg;
	flPitch = -flPitch * Math.Rad2Deg;
    if (vecDirection.x < 0)
	{
		flYaw *= -1;
		flYaw -= 180;
	}
    return VMath.NormalizeQAngle(QAngle(flPitch, flYaw, 0));
}

/** Linear interpolation between two vectors
 * Signature: Vector VectorLerp(Vector vector_a, Vector vector_b, float time)
*/

function VectorLerp(vector_a, vector_b, t)
{
	return vector_a + (vector_b - vector_a) * t;
}

/** If the vector is between two vectors
 * Signature: bool VectorBetween(Vector vector_min, Vector vector_max, Vector vector)
*/

function VectorBetween(vector_min, vector_max, vector)
{
    return Math.Between(vector.x, vector_min.x, vector_max.x) && Math.Between(vector.y, vector_min.y, vector_max.y) && Math.Between(vector.z, vector_min.z, vector_max.z);
}

/*===============================*\
 *   Additional QAngle Methods   *
\*===============================*/

/** Returns the normalized angles of the player's pov
 * Signature: QAngle *instance.Normalize()
*/

function QAngle::Normalize()
{
	local eAngles = this;
	while (eAngles.x < -90.0) eAngles.x += 180.0;
	while (eAngles.x > 90.0) eAngles.x -= 180.0;
	while (eAngles.y < -180.0) eAngles.y += 360.0;
	while (eAngles.y > 180.0) eAngles.y -= 360.0;
	while (eAngles.z < -50.0) eAngles.z += 100.0;
	while (eAngles.z > 50.0) eAngles.z -= 100.0;
	return eAngles;
}

/** Interpolate euler angles via quaternions
 * Signature: QAngle OrientationLerp(QAngle a1, QAngle a2, float time, bool bSlerp, bool shortWay)
*/

function OrientationLerp(a1, a2, t, bSlerp, bShortWay)
{
	if (a1 == a2 || t == 0) return a1;
	if (t == 1) return a2;
	return bSlerp ? QuaternionSlerp(a1.ToQuat(), a2.ToQuat(), t, bShortWay).ToQAngle() : QuaternionLerp(a1.ToQuat(), a2.ToQuat(), t, bShortWay).ToQAngle();
}

/** Rotate euler angles using quaternion
 * Signature: QAngle RotateOrientationWithQuaternion(QAngle angles)
*/

function RotateOrientationWithQuaternion(eAngles)
{
	local qYaw = QuaternionRotation(Vector(0, 0, 1), Math.Deg2Rad * eAngles.y);
	local qPitch = QuaternionRotation(Vector(0, -1, 0), Math.Deg2Rad * eAngles.x);
	local qRoll = QuaternionRotation(Vector(1, 0, 0), Math.Deg2Rad * eAngles.z);
	eAngles = qYaw.Multiply(qPitch).Multiply(qRoll).Invert().ToQAngle();
	eAngles.y *= -1;
	return eAngles;
}

/*=================================*\
 *  Additional Quaternion Methods  *
\*=================================*/

/** Negating the imaginary part
 * Signature: Quaternion *instance.Conjugate()
*/

function Quaternion::Conjugate()
{
	return Quaternion(-x, -y, -z, w);
}

/** Inverse a quaternion
 * Signature: Quaternion *instance.Inverse()
*/

function Quaternion::Inverse()
{
	local q = q.Conjugate();
	local norm = x * x + y * y + z * z + w * w;
	return Quaternion(q.x / norm, q.y / norm, q.z / norm, q.w / norm);
}

/** Multiply a quaternion by another quaternion
 * Signature: Quaternion *instance.Multiply(Quaternion q)
*/

function Quaternion::Multiply(q)
{
	return Quaternion(w * q.x  +  x * q.w  +  y * q.z  -  z * q.y, w * q.y  -  x * q.z  +  y * q.w  +  z * q.x,
					  w * q.z  +  x * q.y  -  y * q.x  +  z * q.w, w * q.w  -  x * q.x  -  y * q.y  -  z * q.z);
}

/** Create a quaternion to rotate a normalized vector by a specific angle in radians
 * Signature: Quaternion QuaternionRotation(Vector direction, float angle)
*/

function QuaternionRotation(vecDirection, flAngle)
{
	local flSinAngle = sin(flAngle / 2.0);
	return Quaternion(vecDirection.x * flSinAngle, vecDirection.y * flSinAngle, vecDirection.z * flSinAngle, cos(flAngle / 2.0));
}

/** Linear interpolation between two quaternions
 * Signature: Quaternion Quaternionlerp(Quaternion q1, Quaternion q2, float time, bool shortWay)
*/

function QuaternionLerp(q1, q2, t, bShortWay)
{
	if (q1 == q2 || t == 0) return q1;
	if (t == 1) return q2;

	local t2 = 1.0 - t;

	if (bShortWay)
	{
		if (q1.Dot(q2) < 0)
		{
			q1.x = -q1.x;
			q1.y = -q1.y;
			q1.z = -q1.z;
			q1.w = -q1.w;
		}
	}
	
	return Quaternion(q1.x * t2 + q2.x * t, q1.y * t2 + q2.y * t, q1.z * t2 + q2.z * t, q1.w * t2 + q2.w * t);
}

/** Spherical linear interpolation between two quaternions
 * Signature: Quaternion QuaternionSlerp(Quaternion q1, Quaternion q2, float time, bool shortWay)
*/

function QuaternionSlerp(q1, q2, t, bShortWay)
{
	if (q1 == q2 || t == 0) return q1;
	if (t == 1) return q2;

	local flCosAngle = q1.Dot(q2);

	if (bShortWay)
	{
		if (flCosAngle < 0)
		{
			q2.x = -q2.x;
			q2.y = -q2.y;
			q2.z = -q2.z;
			q2.w = -q2.w;
			flCosAngle *= -1;
		}
	}
	if (abs(flCosAngle) >= 1.0) return q1;

	local flAngle = acos(flCosAngle);
	local flSinAngle = sqrt(1.0 - flCosAngle * flCosAngle);

	if (fabs(flSinAngle) < 0.001) return Quaternion(q1.x * 0.5 + q2.x * 0.5, q1.y * 0.5 + q2.y * 0.5, q1.z * 0.5 + q2.z * 0.5, q1.w * 0.5 + q2.w * 0.5);

	local ratioA = sin((1 - t) * flAngle) / flSinAngle;
	local ratioB = sin(t * flAngle) / flSinAngle;

	return Quaternion(q1.x * ratioA + q2.x * ratioB, q1.y * ratioA + q2.y * ratioB, q1.z * ratioA + q2.z * ratioB, q1.w * ratioA + q2.w * ratioB);
}