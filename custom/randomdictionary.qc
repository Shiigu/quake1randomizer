// randomdictonary.qc
// QuakeC, being an old language, lacks the ability to handle dictionaries, let alone receive vectors as parameters
// So, this file works as a pseudo dictionary: every converted entity type has a numeric ID (ENTITY_*), and that ID is
// the index of its display name and of its counters. Looking one up is a plain array access.
//
// To add an entity type: add its ENTITY_* ID in the enum below, and its display name in EntityNames[] in the same position.
// Monsters must be the first IDs (they are the only ones that log killed/total), after ENTITY_NONE.

enum {
    ENTITY_NONE,                            // 0 means "not registered" (it is what an entity without an ID has)

    // Monsters
    ENTITY_DEATH_KNIGHT,
    ENTITY_ENFORCER,
    ENTITY_FIEND,
    ENTITY_GRUNT,
    ENTITY_KNIGHT,
    ENTITY_OGRE,
    ENTITY_ROTFISH,
    ENTITY_ROTTWEILER,
    ENTITY_SCRAG,
    ENTITY_SHAMBLER,
    ENTITY_SPAWN,
    ENTITY_VORE,
    ENTITY_ZOMBIE,
    ENTITY_CENTROID,
    ENTITY_GREMLIN,
    ENTITY_SPIKE_MINE,
    ENTITY_WRATH,
    ENTITY_MUMMY,
    ENTITY_EEL,
    ENTITY_HELL_SPAWN,
    ENTITY_MULTI_GRENADE_OGRE,
    ENTITY_KNIGHT_STATUE,
    ENTITY_DEATH_KNIGHT_STATUE,
    ENTITY_PHANTOM_SWORDSMAN,
    ENTITY_GUARDIAN,                        // Last monster

    ENTITY_HEALTH_15,
    ENTITY_HEALTH_25,
    ENTITY_ARMOR_100,
    ENTITY_ARMOR_150,

    ENTITY_SHELLS_SMALL,
    ENTITY_SHELLS_BIG,
    ENTITY_NAILS_SMALL,
    ENTITY_NAILS_BIG,
    ENTITY_ROCKETS_SMALL,
    ENTITY_ROCKETS_BIG,
    ENTITY_CELLS_SMALL,
    ENTITY_CELLS_BIG,
    ENTITY_LAVA_NAILS_SMALL,
    ENTITY_LAVA_NAILS_BIG,
    ENTITY_MULTI_ROCKETS_SMALL,
    ENTITY_MULTI_ROCKETS_BIG,
    ENTITY_PLASMA_SMALL,
    ENTITY_PLASMA_BIG,

    ENTITY_BIOSUIT,
    ENTITY_PENTAGRAM_OF_PROTECTION,
    ENTITY_QUAD_DAMAGE,
    ENTITY_RING_OF_SHADOWS,
    ENTITY_EMPATHY_SHIELDS,
    ENTITY_WETSUIT,
    ENTITY_HORN_OF_CONJURING,
    ENTITY_POWER_SHIELD,
    ENTITY_ANTI_GRAV_BELT,
    ENTITY_HEALTH_100,
    ENTITY_ARMOR_200,

    ENTITY_DOUBLE_BARRELED_SHOTGUN,
    ENTITY_NAILGUN,
    ENTITY_SUPER_NAILGUN,
    ENTITY_GRENADE_LAUNCHER,
    ENTITY_ROCKET_LAUNCHER,
    ENTITY_THUNDERBOLT,
    ENTITY_LASER_CANNON,
    ENTITY_PROXIMITY_GUN,
    ENTITY_MJOLNIR,

    ENTITY_BACKPACK_SHELLS_SMALL,
    ENTITY_BACKPACK_SHELLS_BIG,
    ENTITY_BACKPACK_NAILS_SMALL,
    ENTITY_BACKPACK_NAILS_BIG,
    ENTITY_BACKPACK_ROCKETS_SMALL,
    ENTITY_BACKPACK_ROCKETS_BIG,
    ENTITY_BACKPACK_CELLS_SMALL,
    ENTITY_BACKPACK_CELLS_BIG,
    ENTITY_BACKPACK_LAVA_NAILS_SMALL,
    ENTITY_BACKPACK_LAVA_NAILS_BIG,
    ENTITY_BACKPACK_MULTI_ROCKETS_SMALL,
    ENTITY_BACKPACK_MULTI_ROCKETS_BIG,
    ENTITY_BACKPACK_PLASMA_SMALL,
    ENTITY_BACKPACK_PLASMA_BIG,

    ENTITY_BACKPACK_DOUBLE_BARRELED_SHOTGUN,
    ENTITY_BACKPACK_NAILGUN,
    ENTITY_BACKPACK_SUPER_NAILGUN,
    ENTITY_BACKPACK_GRENADE_LAUNCHER,
    ENTITY_BACKPACK_ROCKET_LAUNCHER,
    ENTITY_BACKPACK_THUNDERBOLT,
    ENTITY_BACKPACK_LASER_CANNON,
    ENTITY_BACKPACK_PROXIMITY_GUN,
    ENTITY_BACKPACK_MJOLNIR,

    ENTITY_COUNT                            // Not an entity: the amount of IDs, ENTITY_NONE included
};

// Must stay in the same order as the enum above.
string EntityNames[] = {
    "",
    "Monster -> Death Knight",
    "Monster -> Enforcer",
    "Monster -> Fiend",
    "Monster -> Grunt",
    "Monster -> Knight",
    "Monster -> Ogre",
    "Monster -> Rotfish",
    "Monster -> Rottweiler",
    "Monster -> Scrag",
    "Monster -> Shambler",
    "Monster -> Spawn",
    "Monster -> Vore",
    "Monster -> Zombie",
    "Monster -> Centroid",
    "Monster -> Gremlin",
    "Monster -> Spike Mine",
    "Monster -> Wrath",
    "Monster -> Mummy",
    "Monster -> Eel",
    "Monster -> Hell Spawn",
    "Monster -> Multi-Grenade Ogre",
    "Monster -> Knight Statue",
    "Monster -> Death Knight Statue",
    "Monster -> Phantom Swordsman",
    "Monster -> Guardian",

    "Pickup -> Health Pack (15)",
    "Pickup -> Health Pack (25)",
    "Pickup -> Armor (Green)",
    "Pickup -> Armor (Yellow)",

    "Ammo -> Shells (20)",
    "Ammo -> Shells (40)",
    "Ammo -> Nails (25)",
    "Ammo -> Nails (50)",
    "Ammo -> Rockets (5)",
    "Ammo -> Rockets (10)",
    "Ammo -> Cells (6)",
    "Ammo -> Cells (12)",
    "Ammo -> Lava Nails (25)",
    "Ammo -> Lava Nails (50)",
    "Ammo -> Multi Rockets (5)",
    "Ammo -> Multi Rockets (10)",
    "Ammo -> Plasma (6)",
    "Ammo -> Plasma (12)",

    "Powerup -> Biosuit",
    "Powerup -> Pentagram of Protection",
    "Powerup -> Quad Damage",
    "Powerup -> Ring of Shadows",
    "Powerup -> Empathy Shields",
    "Powerup -> Wetsuit",
    "Powerup -> Horn of Conjuring",
    "Powerup -> Power Shield",
    "Powerup -> Anti-Grav Belt",
    "Powerup -> Health Pack (100)",
    "Powerup -> Armor (Red)",

    "Weapon -> Double-barreled Shotgun",
    "Weapon -> Nailgun",
    "Weapon -> Super Nailgun",
    "Weapon -> Grenade Launcher",
    "Weapon -> Rocket Launcher",
    "Weapon -> Thunderbolt",
    "Weapon -> Laser Cannon",
    "Weapon -> Proximity Gun",
    "Weapon -> Mjolnir",

    "Backpack (Ammo) -> Shells (20)",
    "Backpack (Ammo) -> Shells (40)",
    "Backpack (Ammo) -> Nails (25)",
    "Backpack (Ammo) -> Nails (50)",
    "Backpack (Ammo) -> Rockets (5)",
    "Backpack (Ammo) -> Rockets (10)",
    "Backpack (Ammo) -> Cells (6)",
    "Backpack (Ammo) -> Cells (12)",
    "Backpack (Ammo) -> Lava Nails (25)",
    "Backpack (Ammo) -> Lava Nails (50)",
    "Backpack (Ammo) -> Multi Rockets (5)",
    "Backpack (Ammo) -> Multi Rockets (10)",
    "Backpack (Ammo) -> Plasma (6)",
    "Backpack (Ammo) -> Plasma (12)",

    "Backpack (Weapon) -> Double-barreled Shotgun",
    "Backpack (Weapon) -> Nailgun",
    "Backpack (Weapon) -> Super Nailgun",
    "Backpack (Weapon) -> Grenade Launcher",
    "Backpack (Weapon) -> Rocket Launcher",
    "Backpack (Weapon) -> Thunderbolt",
    "Backpack (Weapon) -> Laser Cannon",
    "Backpack (Weapon) -> Proximity Gun",
    "Backpack (Weapon) -> Mjolnir"
};

float AMOUNT_OF_MONSTER_SLOTS = ENTITY_GUARDIAN + 1;	// Monsters are the only ones to count kills, so they only need their own counters.
float EntityQuantities[ENTITY_COUNT];
float DeadEntityQuantities[AMOUNT_OF_MONSTER_SLOTS];

void(float id) RegisterEntity;
void(float id) RegisterDeadEntity;
void() LogRandomizerResults;

void() LogRandomizerResults = {
	if(!RandomizeMonsters && !RandomizeWeaponsAndAmmo && !RandomizeHealthAndArmor && !RandomizePowerups)
    {
        bprint("There are no converted entities to show!\n");
        return;
    }
    float i;
    if(EntityNames.length != ENTITY_COUNT)
        dprint("EntityNames doesn't have the same amount of entries as the ENTITY_* enum.\n");
    bprint("------- List of converted objects -------\n");
    for(i = 1; i < ENTITY_COUNT && i < EntityNames.length; i++)
    {
        if(EntityQuantities[i] == 0)
            continue;
        if(i < AMOUNT_OF_MONSTER_SLOTS)
            bprint(EntityNames[i], ": ", ftos(DeadEntityQuantities[i]), "/", ftos(EntityQuantities[i]), " killed\n");
        else
            bprint(EntityNames[i], ": ", ftos(EntityQuantities[i]), "\n");
    }
    bprint("----- End list of converted objects -----\n");
};

void(float id) RegisterEntity =
{
    if(id <= ENTITY_NONE || id >= ENTITY_COUNT)
    {
        dprint("Entity ID ");
        dprint(ftos(id));
        dprint(" is not present in the EntityNames dictionary.\n");
        return;
    }
    // Prevent Horn of Conjuring monsters and Gremlins created by eating a body from resetting the counter
    if(id < AMOUNT_OF_MONSTER_SLOTS && !self.spawnfunction && !self.gorging)
        DeadEntityQuantities[id] = 0;
    EntityQuantities[id] = EntityQuantities[id] + 1;
};

void(float id) RegisterDeadEntity =
{
    if(id <= ENTITY_NONE || id >= ENTITY_COUNT)
    {
        dprint("Entity ID ");
        dprint(ftos(id));
        dprint(" is not present in the EntityNames dictionary.\n");
    }
    else if (id >= AMOUNT_OF_MONSTER_SLOTS)
    {
        dprint(EntityNames[id]);
        dprint(" is not a monster.\n");
    }
    else
    {
        DeadEntityQuantities[id] = DeadEntityQuantities[id] + 1;
    }
};
