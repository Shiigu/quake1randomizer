// randomdictonary.qc
// QuakeC, being an old language, lacks the ability to handle dictionaries, let alone receive vectors as parameters
// So, this file and its functions will work as a pseudo dictionary.

float AMOUNT_OF_ENTITY_TYPES = 63;
float AMOUNT_OF_MONSTER_TYPES = 16;

string ENTITY_DISPLAY_NAME_DEATH_KNIGHT = "Monster -> Death Knight";
string ENTITY_DISPLAY_NAME_ENFORCER = "Monster -> Enforcer";
string ENTITY_DISPLAY_NAME_FIEND = "Monster -> Fiend";
string ENTITY_DISPLAY_NAME_GRUNT = "Monster -> Grunt";
string ENTITY_DISPLAY_NAME_KNIGHT = "Monster -> Knight";
string ENTITY_DISPLAY_NAME_OGRE = "Monster -> Ogre";
string ENTITY_DISPLAY_NAME_ROTFISH = "Monster -> Rotfish";
string ENTITY_DISPLAY_NAME_ROTTWEILER = "Monster -> Rottweiler";
string ENTITY_DISPLAY_NAME_SCRAG = "Monster -> Scrag";
string ENTITY_DISPLAY_NAME_SHAMBLER = "Monster -> Shambler";
string ENTITY_DISPLAY_NAME_SPAWN = "Monster -> Spawn";
string ENTITY_DISPLAY_NAME_VORE = "Monster -> Vore";
string ENTITY_DISPLAY_NAME_ZOMBIE = "Monster -> Zombie";
string ENTITY_DISPLAY_NAME_CENTROID = "Monster -> Centroid";
string ENTITY_DISPLAY_NAME_GREMLIN = "Monster -> Gremlin";
string ENTITY_DISPLAY_NAME_SPIKE_MINE = "Monster -> Spike Mine";

string ENTITY_DISPLAY_NAME_HEALTH_15 = "Pickup -> Health Pack (15)";
string ENTITY_DISPLAY_NAME_HEALTH_25 = "Pickup -> Health Pack (25)";
string ENTITY_DISPLAY_NAME_ARMOR_100 = "Pickup -> Armor (Green)";
string ENTITY_DISPLAY_NAME_ARMOR_150 = "Pickup -> Armor (Yellow)";

string ENTITY_DISPLAY_NAME_SHELLS_SMALL = "Ammo -> Shells (20)";
string ENTITY_DISPLAY_NAME_SHELLS_BIG = "Ammo -> Shells (40)";
string ENTITY_DISPLAY_NAME_NAILS_SMALL = "Ammo -> Nails (25)";
string ENTITY_DISPLAY_NAME_NAILS_BIG = "Ammo -> Nails (50)";
string ENTITY_DISPLAY_NAME_ROCKETS_SMALL = "Ammo -> Rockets (5)";
string ENTITY_DISPLAY_NAME_ROCKETS_BIG = "Ammo -> Rockets (10)";
string ENTITY_DISPLAY_NAME_CELLS_SMALL = "Ammo -> Cells (6)";
string ENTITY_DISPLAY_NAME_CELLS_BIG = "Ammo -> Cells (12)";

string ENTITY_DISPLAY_NAME_BIOSUIT = "Powerup -> Biosuit";
string ENTITY_DISPLAY_NAME_PENTAGRAM_OF_PROTECTION = "Powerup -> Pentagram of Protection";
string ENTITY_DISPLAY_NAME_QUAD_DAMAGE = "Powerup -> Quad Damage";
string ENTITY_DISPLAY_NAME_RING_OF_SHADOWS = "Powerup -> Ring of Shadows";
string ENTITY_DISPLAY_NAME_EMPATHY_SHIELDS = "Powerup -> Empathy Shields";
string ENTITY_DISPLAY_NAME_WETSUIT = "Powerup -> Wetsuit";
string ENTITY_DISPLAY_NAME_HORN_OF_CONJURING = "Powerup -> Horn of Conjuring";
string ENTITY_DISPLAY_NAME_HEALTH_100 = "Powerup -> Health Pack (100)";
string ENTITY_DISPLAY_NAME_ARMOR_200 = "Powerup -> Armor (Red)";

string ENTITY_DISPLAY_NAME_DOUBLE_BARRELED_SHOTGUN = "Weapon -> Double-barreled Shotgun";
string ENTITY_DISPLAY_NAME_NAILGUN = "Weapon -> Nailgun";
string ENTITY_DISPLAY_NAME_SUPER_NAILGUN = "Weapon -> Super Nailgun";
string ENTITY_DISPLAY_NAME_GRENADE_LAUNCHER = "Weapon -> Grenade Launcher";
string ENTITY_DISPLAY_NAME_ROCKET_LAUNCHER = "Weapon -> Rocket Launcher";
string ENTITY_DISPLAY_NAME_THUNDERBOLT = "Weapon -> Thunderbolt";
string ENTITY_DISPLAY_NAME_LASER_CANNON = "Weapon -> Laser Cannon";
string ENTITY_DISPLAY_NAME_PROXIMITY_GUN = "Weapon -> Proximity Gun";
string ENTITY_DISPLAY_NAME_MJOLNIR = "Weapon -> Mjolnir";

string ENTITY_DISPLAY_NAME_BACKPACK_SHELLS_SMALL = "Backpack (Ammo) -> Shells (20)";
string ENTITY_DISPLAY_NAME_BACKPACK_SHELLS_BIG = "Backpack (Ammo) -> Shells (40)";
string ENTITY_DISPLAY_NAME_BACKPACK_NAILS_SMALL = "Backpack (Ammo) -> Nails (25)";
string ENTITY_DISPLAY_NAME_BACKPACK_NAILS_BIG = "Backpack (Ammo) -> Nails (50)";
string ENTITY_DISPLAY_NAME_BACKPACK_ROCKETS_SMALL = "Backpack (Ammo) -> Rockets (5)";
string ENTITY_DISPLAY_NAME_BACKPACK_ROCKETS_BIG = "Backpack (Ammo) -> Rockets (10)";
string ENTITY_DISPLAY_NAME_BACKPACK_CELLS_SMALL = "Backpack (Ammo) -> Cells (6)";
string ENTITY_DISPLAY_NAME_BACKPACK_CELLS_BIG = "Backpack (Ammo) -> Cells (12)";

string ENTITY_DISPLAY_NAME_BACKPACK_DOUBLE_BARRELED_SHOTGUN = "Backpack (Weapon) -> Double-barreled Shotgun";
string ENTITY_DISPLAY_NAME_BACKPACK_NAILGUN = "Backpack (Weapon) -> Nailgun";
string ENTITY_DISPLAY_NAME_BACKPACK_SUPER_NAILGUN = "Backpack (Weapon) -> Super Nailgun";
string ENTITY_DISPLAY_NAME_BACKPACK_GRENADE_LAUNCHER = "Backpack (Weapon) -> Grenade Launcher";
string ENTITY_DISPLAY_NAME_BACKPACK_ROCKET_LAUNCHER = "Backpack (Weapon) -> Rocket Launcher";
string ENTITY_DISPLAY_NAME_BACKPACK_THUNDERBOLT = "Backpack (Weapon) -> Thunderbolt";
string ENTITY_DISPLAY_NAME_BACKPACK_LASER_CANNON = "Backpack (Weapon) -> Laser Cannon";
string ENTITY_DISPLAY_NAME_BACKPACK_PROXIMITY_GUN = "Backpack (Weapon) -> Proximity Gun";
string ENTITY_DISPLAY_NAME_BACKPACK_MJOLNIR = "Backpack (Weapon) -> Mjolnir";

string EntityNames[] = { ENTITY_DISPLAY_NAME_DEATH_KNIGHT, ENTITY_DISPLAY_NAME_ENFORCER, ENTITY_DISPLAY_NAME_FIEND, ENTITY_DISPLAY_NAME_GRUNT, ENTITY_DISPLAY_NAME_KNIGHT, 
                            ENTITY_DISPLAY_NAME_OGRE, ENTITY_DISPLAY_NAME_ROTFISH, ENTITY_DISPLAY_NAME_ROTTWEILER, ENTITY_DISPLAY_NAME_SCRAG, ENTITY_DISPLAY_NAME_SHAMBLER, 
                            ENTITY_DISPLAY_NAME_SPAWN, ENTITY_DISPLAY_NAME_VORE, ENTITY_DISPLAY_NAME_ZOMBIE, ENTITY_DISPLAY_NAME_CENTROID, ENTITY_DISPLAY_NAME_GREMLIN, ENTITY_DISPLAY_NAME_SPIKE_MINE, ENTITY_DISPLAY_NAME_HEALTH_15, ENTITY_DISPLAY_NAME_HEALTH_25, 
                            ENTITY_DISPLAY_NAME_ARMOR_100, ENTITY_DISPLAY_NAME_ARMOR_150, ENTITY_DISPLAY_NAME_SHELLS_SMALL, ENTITY_DISPLAY_NAME_SHELLS_BIG, 
                            ENTITY_DISPLAY_NAME_NAILS_SMALL, ENTITY_DISPLAY_NAME_NAILS_BIG, ENTITY_DISPLAY_NAME_ROCKETS_SMALL, ENTITY_DISPLAY_NAME_ROCKETS_BIG, 
                            ENTITY_DISPLAY_NAME_CELLS_SMALL, ENTITY_DISPLAY_NAME_CELLS_BIG, ENTITY_DISPLAY_NAME_BIOSUIT, ENTITY_DISPLAY_NAME_PENTAGRAM_OF_PROTECTION, 
                            ENTITY_DISPLAY_NAME_QUAD_DAMAGE, ENTITY_DISPLAY_NAME_RING_OF_SHADOWS, ENTITY_DISPLAY_NAME_EMPATHY_SHIELDS, ENTITY_DISPLAY_NAME_WETSUIT, ENTITY_DISPLAY_NAME_HORN_OF_CONJURING, ENTITY_DISPLAY_NAME_HEALTH_100, ENTITY_DISPLAY_NAME_ARMOR_200, 
                            ENTITY_DISPLAY_NAME_DOUBLE_BARRELED_SHOTGUN, ENTITY_DISPLAY_NAME_NAILGUN, ENTITY_DISPLAY_NAME_SUPER_NAILGUN, ENTITY_DISPLAY_NAME_GRENADE_LAUNCHER, 
                            ENTITY_DISPLAY_NAME_ROCKET_LAUNCHER, ENTITY_DISPLAY_NAME_THUNDERBOLT, ENTITY_DISPLAY_NAME_LASER_CANNON, ENTITY_DISPLAY_NAME_PROXIMITY_GUN, ENTITY_DISPLAY_NAME_MJOLNIR, ENTITY_DISPLAY_NAME_BACKPACK_SHELLS_SMALL, 
                            ENTITY_DISPLAY_NAME_BACKPACK_SHELLS_BIG, ENTITY_DISPLAY_NAME_BACKPACK_NAILS_SMALL, ENTITY_DISPLAY_NAME_BACKPACK_NAILS_BIG, 
                            ENTITY_DISPLAY_NAME_BACKPACK_ROCKETS_SMALL, ENTITY_DISPLAY_NAME_BACKPACK_ROCKETS_BIG, ENTITY_DISPLAY_NAME_BACKPACK_CELLS_SMALL, 
                            ENTITY_DISPLAY_NAME_BACKPACK_CELLS_BIG, ENTITY_DISPLAY_NAME_BACKPACK_DOUBLE_BARRELED_SHOTGUN, ENTITY_DISPLAY_NAME_BACKPACK_NAILGUN, 
                            ENTITY_DISPLAY_NAME_BACKPACK_SUPER_NAILGUN, ENTITY_DISPLAY_NAME_BACKPACK_GRENADE_LAUNCHER, ENTITY_DISPLAY_NAME_BACKPACK_ROCKET_LAUNCHER, 
                            ENTITY_DISPLAY_NAME_BACKPACK_THUNDERBOLT, ENTITY_DISPLAY_NAME_BACKPACK_LASER_CANNON, ENTITY_DISPLAY_NAME_BACKPACK_PROXIMITY_GUN, ENTITY_DISPLAY_NAME_BACKPACK_MJOLNIR };
float EntityQuantities[AMOUNT_OF_ENTITY_TYPES];
float DeadEntityQuantities[AMOUNT_OF_MONSTER_TYPES];

void(string key) RegisterEntity;
void(string key) RegisterDeadEntity;
void() LogRandomizerResults;

void() LogRandomizerResults = {
	if(!RandomizeMonsters && !RandomizeWeaponsAndAmmo && !RandomizeHealthAndArmor && !RandomizePowerups)
    {
        bprint("There are no converted entities to show!\n");
        return;
    }
    float i;
    bprint("------- List of converted objects -------\n");
    for(i = 0; i < EntityNames.length; i++)
    {
        if(EntityNames[i] == string_null) break;
        if(i < DeadEntityQuantities.length)
        {
            if(EntityQuantities[i] != 0)
                bprint(EntityNames[i], ": ", ftos(DeadEntityQuantities[i]), "/", ftos(EntityQuantities[i]), " killed\n");
        }
        else
        {
            if(EntityQuantities[i] != 0)
                bprint(EntityNames[i], ": ", ftos(EntityQuantities[i]), "\n");
        }
    }
    bprint("----- End list of converted objects -----\n");
};

float(string classname) GetPositionOfEntry = {
    float i;
    for(i = 0; i < EntityNames.length; i++)
    {
        if (EntityNames[i] == classname)
            return i;
    }
    return -1;
};

void(string key) RegisterEntity =
{
    float i;
    i = GetPositionOfEntry(key);
    if(i == -1)
    {
        dprint(key);
        dprint(" is not present in EntityNames dictionary.\n");
    }
    else
    {
        // Prevent Horn of Conjuring monsters and Gremlins created by eating a body from resetting the counter
        if(i < DeadEntityQuantities.length && !self.spawnfunction && !self.gorging)
            DeadEntityQuantities[i] = 0;
        EntityQuantities[i] = EntityQuantities[i] + 1;
    }
};

void(string key) RegisterDeadEntity = 
{
    float i;
    i = GetPositionOfEntry(key);
    if(i == -1)
    {
        dprint(key);
        dprint(" is not present in EntityNames dictionary.\n");
    }
    else if (i > DeadEntityQuantities.length)
    {
        dprint(key);
        dprint(" is not a monster.\n");
    }
    else
    {
        DeadEntityQuantities[i] = DeadEntityQuantities[i] + 1;
    }
};