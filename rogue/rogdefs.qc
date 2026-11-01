/* Dissolution of Eternity (Rogue) definitions, translated to this mod's layout.

   Ported from the Rogue source (Rogue Entertainment, 1997) defs.qc.

   The canonical item bit layout of this mod is the vanilla/Hipnotic one in
   defs.qc and hipnotic/hipdefs.qc. Rogue renumbered some of those bits, so its
   code cannot be dropped in as-is. TRANSLATION RULES for Rogue code:

   Rogue symbol                      -> This mod
   --------------------------------------------------------------------------
   IT_AXE, IT_SHELLS, IT_NAILS,
   IT_ROCKETS, IT_CELLS              -> unchanged name, canonical value
                                        (Rogue moved them one bit down)
   IT2_ARMOR1/2/3 (in .items2)       -> IT_ARMOR1/2/3 (in .items)
   IT2_SUPERHEALTH                   -> removed (Hipnotic already dropped the bit)
   IT_LAVA_NAILGUN, IT_LAVA_SUPER_NAILGUN,
   IT_MULTI_GRENADE, IT_MULTI_ROCKET,
   IT_PLASMA_GUN (in .items/.weapon) -> ROGW_* weapon id in .weapon,
                                        owned via Rog_HasWeapon/GiveWeapon/TakeWeapon
   IT2_LAVA_NAILS, IT2_PLASMA_AMMO,
   IT2_MULTI_ROCKETS, IT2_SHIELD,
   IT2_ANTIGRAV, IT2_EARTHQUAKE,
   IT2_V_SPHERE (in .items2)         -> RIT_* in .rog_items
   .items2 (Rogue meaning)           -> .rog_items  (.items2 stays Hipnotic's)
   IT_GRAPPLE (weapon id)            -> ROGW_GRAPPLE (never owned as an item, always there in CTF)
   CTF/team/rune/motd/tag symbols    -> unchanged names, see the Capture the Flag block at the end
   ammo_shells1 and so on            -> ammo_standard_shells and so on

   Rogue's original names IT_LAVA_NAILGUN, IT2_SHIELD, etc. are deliberately NOT
   defined. A use that has not been translated fails to compile, instead of
   silently testing a bit that means something else here.

   Why a private field: every bit of .items is taken (vanilla + Hipnotic fill
   all 24 float-safe bits) and .items2 already belongs to Hipnotic, so Rogue's
   state lives in .rog_items. Nothing in the engine reads it, which means the
   HUD does not see it; Rog_SyncHudBits() is the single place to add that later.
*/

//
// Rogue fields that the engine reads by name (keep these spellings)
//
.float		ammo_lava_nails;
.float		ammo_multi_rockets;
.float		ammo_plasma;

//
// Rogue-private item state (see translation rules above)
//
.float		rog_items;

// Ownership/state bits for .rog_items. Weapons first: ROGW_* ids derive from these.
float	RIT_LAVA_NAILGUN		= 1;
float	RIT_LAVA_SUPER_NAILGUN	= 2;
float	RIT_MULTI_GRENADE		= 4;
float	RIT_MULTI_ROCKET		= 8;
float	RIT_PLASMA_GUN			= 16;
float	RIT_LAVA_NAILS			= 32;	// current ammo type, for the HUD
float	RIT_PLASMA_AMMO			= 64;
float	RIT_MULTI_ROCKETS		= 128;
float	RIT_SHIELD				= 256;
float	RIT_ANTIGRAV			= 512;
float	RIT_EARTHQUAKE			= 1024;
float	RIT_V_SPHERE			= 2048;

// Weapon ids as stored in .weapon. Powers of two from 2^24 up, so they can
// never equal one of the canonical IT_* weapon values (all below 2^24).
// ROGW_x / ROGW_BASE is the matching RIT_x ownership bit (exact for powers of 2).
float	ROGW_BASE				= 16777216;
float	ROGW_LAVA_NAILGUN		= 16777216;
float	ROGW_LAVA_SUPER_NAILGUN	= 33554432;
float	ROGW_MULTI_GRENADE		= 67108864;
float	ROGW_MULTI_ROCKET		= 134217728;
float	ROGW_PLASMA_GUN			= 268435456;

//
// Rogue powerup fields
//
.float		shield_finished, antigrav_finished;
.float		shield_time, antigrav_time;
.entity		shield_entity;
.float		shield_death_time;
.float		shieldSoundTime;
.float		AGping;			// next time the Anti-Grav Belt pings

// Ammo. Like in Rogue (where these are called ammo_shells1 and so on), the real standard ammo is in
// ammo_standard_shells/nails/rockets/cells, and the alternate ammo in
// ammo_lava_nails/multi_rockets/plasma. ammo_shells/nails/rockets/cells (declared in defs.qc, the ones the
// engine puts on the status bar) are DISPLAY ONLY: UpdateAmmoCounts() fills them in every frame, showing the
// alternate ammo in the nails, rockets and cells counters while a combo weapon is selected. No game code may
// read or write them, anything written there is overwritten the next frame.
// (The engine's own "give" command writes them, so it has no lasting effect: use impulse 9.)
.float		ammo_standard_shells, ammo_standard_nails, ammo_standard_rockets, ammo_standard_cells;

//
// elevator fields
//
.float		elevatorLastUse;
.float		elevatorOnFloor;
.float		elevatorToFloor;
.vector		elevatorDestination;

//
// plat2 fields
//
.float		plat2Called;
.float		plat2LastMove;
.float		plat2GoTime;
.float		plat2GoTo;

//
// new AI fields
//
.float		orbitPosition;

//
// dragon specific fields
//
.float		playerInRoom;
.float		playerInTransit;
.float		dragonInRoom;
.float		dragonInTransit;
.float		dragonAttacking;
.float		dragonPainSequence;
.vector		dragonLastVelocity;
.float		dragonDeathState;

//
// Other Rogue fields
//
.float		childrenSpawned;
.float		ltrailLastUsed;

//
// Rogue constants and globals
//
float	TE_EXPLOSION2		= 12;
float	TE_BEAM				= 13;

float	earthquake_active;
float	earthquake_intensity;
float	cutscene_running;
float	lavaGunFired;		// set when a Lava Nailgun shot goes off, W_WeaponFrame plays its sound once

// Set by worldspawn on Dissolution of Eternity's own maps. The map entities Rogue changed (trap shooters, push
// fields, ...) keep their usual behaviour everywhere else, because the same spawnflag bits mean something else there.
float	RogueMap;

// Rogue's trap_spikeshooter spawnflags (1 and 2, superspike and laser, are the usual ones)
float	SPAWNFLAG_LAVASPIKE		= 4;
float	SPAWNFLAG_SUPERLAVA		= 8;
float	SPAWNFLAG_LAVASKILL		= 16;	// super lava spikes on skill 2 and 3
float	SPAWNFLAG_FIREBALL		= 32;

void(vector org, vector dir) launch_fireball;		// rogue/dragon.qc
void() xpackEnding;								// rogue/ending.qc

// TODO when ported: prototypes for void(entity theEntity) UpdateAmmoCounts
// (weapons.qc) and void(entity ownerEntity) sphere_remove (sphere.qc). FTEQCC
// errors on a prototype with no body, so they go in with their definitions.

//
// Item helpers
//
float(entity e, float bit) Rog_Has =
{
	return (e.rog_items & bit);
};

void(entity e, float bit) Rog_Give =
{
	e.rog_items = e.rog_items | bit;
};

void(entity e, float bit) Rog_Take =
{
	e.rog_items = e.rog_items - (e.rog_items & bit);
};

float(float w) Rog_IsRogueWeapon =
{
	return (w >= ROGW_BASE);
};

// w is a ROGW_* id
float(entity e, float w) Rog_HasWeapon =
{
	return (e.rog_items & (w / ROGW_BASE));
};

void(entity e, float w) Rog_GiveWeapon =
{
	Rog_Give(e, w / ROGW_BASE);
};

void(entity e, float w) Rog_TakeWeapon =
{
	Rog_Take(e, w / ROGW_BASE);
};


//
// Team play, Capture the Flag, runes and the grapple (rogue/teamplay.qc, runes.qc, grapple.qc, motd.qc, dmatch.qc)
// Deathmatch only, they do nothing in single player. Original names and values, except for the weapon:
// IT_GRAPPLE is a weapon id here, ROGW_GRAPPLE, that is never owned as an item (the grapple is always there in CTF).
//
float	ROGW_GRAPPLE			= 536870912;

entity	tag_token_owner;		// Deathmatch Tag: who has the token

// New entity fields

.float steam;		// selected team
.float suicide_count; // how many times has this player done something silly?
.float ctf_flags; // various flags for CTF
.float ctf_killed;	// used for base spawning
.float ctf_flagsince;	// when we picked up the flag
.float ctf_lasthurtcarrier; // when we last hurt the carrier
.float ctf_lastreturnedflag; // when we returned the flag
.float ctf_lastfraggedcarrier; // when we last fragged the carrier

float TEAM1	= 5;  // color of team1 (red), note that this is self.team which
				//is one more than the color setting, so 'color 4' is red.
float TEAM2 = 14;  // color of team2 (blue), note that this is self.team which
				//is one more than the color setting, so 'color 13' is blue.
float TEAM3	= 1; // color of team3 (grey) in alt CTF

entity team1_lastspawn;  // last spawn spot for team1
entity team2_lastspawn;  // last spawn spot for team2
float nextteamupdtime; // next time for a broadcast update

// TEAMPLAY VALUES

float TEAM_NORMAL_NODAMAGE	=	1;	// id's normal teamplay, can't hurt self
float TEAM_NORMAL_DAMAGE	=	2;	// id's alt teamplay, can hurt self/team
float TEAM_DMATCH_TAG		=	3;	// deathmatch tag, no 'team' stuff
float TEAM_CTF				=	4;	// regular CTF, locked colors
float TEAM_CTF_ONEFLAG		=	5;	// one flag CTF
float TEAM_CTF_ALT			=	6;	// alternate CTF (three teams)

// gamecfg cvar fields

float GAMECFG_ENABLE_RUNES		=	1; // enable runes (default is disabled)
float GAMECFG_TEAM_ARMOR_DMG	=	2; // 2 team damage affects armor (default is not)
float GAMECFG_TEAM_HEALTH_DMG	=	4; // 4 team damage affects health (default is not)
float GAMECFG_USE_COLOR			=	8; // use color player joins as (if you join and start with blue, you will go
//    to blue team, same with red/green.  If you are an illegal color, you'll
//    get assigned).
float GAMECFG_ALLOW_CHG			=	16; // allow people to change teams

float CTF_CAPTURE_BONUS = 15; // what you get for capture
float CTF_TEAM_BONUS = 10; // what your team gets for capture
float CTF_ALT_CAPTURE_BONUS = 8; // what you get for capture
float CTF_ALT_TEAM_BONUS = 4; // what your team gets for capture
float CTF_RECOVERY_BONUS = 1; // what you get for recovery
float CTF_FLAG_BONUS = 0; // what you get for picking up enemy flag
float CTF_FRAG_CARRIER_BONUS = 2; // what you get for fragging enemy flag carrier
float CTF_FLAG_RETURN_TIME = 40; // seconds until auto return
float CTF_CARRIER_DANGER_PROTECT_BONUS = 2; // bonus for fraggin someone
	// who has recently hurt your flag carrier
float CTF_CARRIER_PROTECT_BONUS = 1; // bonus for fraggin someone while
	// either you or your target are near your flag carrier
float CTF_FLAG_DEFENSE_BONUS = 1; // bonus for fraggin someone while
	// either you or your target are near your flag
float CTF_RETURN_FLAG_ASSIST_BONUS = 1; // awarded for returning a flag that causes a
	// capture to happen almost immediately
float CTF_FRAG_CARRIER_ASSIST_BONUS = 2; // award for fragging a flag carrier if a
	// capture happens almost immediately
float CTF_TARGET_PROTECT_RADIUS = 400; // the radius around an object being
	// defended where a target will be worth extra frags
float CTF_ATTACKER_PROTECT_RADIUS = 400; // the radius around an object being
	// defended where an attacker will get extra frags when making kills
float CTF_CARRIER_DANGER_PROTECT_TIMEOUT = 4;
float CTF_CARRIER_FLAG_SINCE_TIMEOUT = 2;
float CTF_FRAG_CARRIER_ASSIST_TIMEOUT = 6;
float CTF_RETURN_FLAG_ASSIST_TIMEOUT = 4;
float CTF_UPDATE_TIME = 120;

// CTF flags
float CTF_FLAG_FLAG			=	1;	// palyer has flag in one flag mode
float CTF_FLAG_TEAM1		=	1;	// player has team1's flag
float CTF_FLAG_TEAM2		=	2;	// player has team2's flag
float CTF_FLAG_STUFF_COLOR	=	4;	// gotta stuff his color

// flag status used in cnt field of flag
float FLAG_AT_BASE = 0;
float FLAG_CARRIED = 1;
float FLAG_DROPPED = 2;

// Prototypes for the functions the rest of the game calls
float(entity targ, entity inflictor, entity attacker, float damage) TeamArmorDam;
float(entity targ, entity inflictor, entity attacker, float damage) TeamHealthDam;
void(entity who) TeamResetCarrier;
void(entity targ, entity attacker) TeamAssists;
float(float color) TeamColorIsLegal;
void() TeamSetSkin;
void() TeamCheckLock;
void() TeamCheckUpdate;
void() TeamFlagStatusReport;
void(entity player) TeamDropFlagOfPlayer;
void() TossBackpack;
void() TossWeapon;

void() RunePrecache;
void() SpawnRunes;
void() DropRune;
float(float damage, entity who) RuneApplyEarth;
void(entity who) RuneApplyBlackNoise;
float(float damage, entity who) RuneApplyBlack;
float(float tvalue, entity who) RuneApplyHell;
void(entity who) RuneApplyElder;
float(entity who) RuneHasElder;

.entity	hook;			// this is my hook
.float	on_hook;		// we're on it
.float	hook_out;		// it's out
void() GrappleService;
void() W_FireGrapple;

void() CheckMOTD;
void() SetMOTD;

void(entity targ, entity attacker) dmatch_score;
void() tag_token_drop;
