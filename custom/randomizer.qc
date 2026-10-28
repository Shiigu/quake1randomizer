void() ConvertEntities;
void() ConvertToMonster;
void() ConvertToMonsterOnGroundUnbiased;
void() ConvertToMonsterOnWaterUnbiased;
void() ConvertToMonsterOnGroundBiased;
void() ConvertToMonsterOnWaterBiased;
void() ConvertMonsterSpawn;
void() ConvertMonsterSpawnOnGroundUnbiased;
void() ConvertMonsterSpawnOnWaterUnbiased;
void() ConvertMonsterSpawnOnGroundBiased;
void() ConvertMonsterSpawnOnWaterBiased;
void() ConvertToPickupBiased;
void() ConvertToPickupUnbiased;
void() ConvertToAmmoBiased;
void() ConvertToAmmoUnbiased;
void() ConvertToPowerupBiased;
void() ConvertToPowerupUnbiased;
void() ConvertToWeaponBiased;
void() ConvertToWeaponUnbiased;
void() CreateWeaponPermutation;

float FULL_WEAPON_BAG = IT_SUPER_SHOTGUN | IT_NAILGUN | IT_SUPER_NAILGUN | IT_GRENADE_LAUNCHER | IT_ROCKET_LAUNCHER | IT_LIGHTNING | IT_LASER_CANNON | IT_PROXIMITY_GUN | IT_MJOLNIR;

/* Entities will be converted to one of the same type:
    - "Monster" for Monsters
    - "Pickup" for Health (except for Mega) and Armor (except for Red)
    - "Ammo" for Ammunition (both small and big)
    - "Weapon" for Weapons
    - "Powerup" for Megahealth, Red Armor and Powerups */

entity Placeholder;
float IndexPermutation[9];

// PROBABILITY "TABLES"

string MonsterUnbiasedClassnames[] = { "monster_demon1", "monster_dog", "monster_enforcer", "monster_fish", "monster_hell_knight", "monster_knight", "monster_shalrath", "monster_shambler", "monster_army", "monster_tarbaby", "monster_wizard", "monster_ogre", "monster_scourge", "monster_gremlin", "trap_spike_mine", "monster_wrath", "monster_mummy", "monster_eel", "monster_tarbaby", "monster_ogre", "monster_knight", "monster_hell_knight", "monster_sword", "monster_zombie" };
void() MonsterUnbiasedSpawnFunctions[] = { ConvertToFiend, ConvertToDog, ConvertToEnforcer, ConvertToRotfish, ConvertToDeathKnight, ConvertToKnight, 
    ConvertToVore, ConvertToShambler, ConvertToGrunt, ConvertToSpawn, ConvertToScrag, 
    ConvertToOgre, ConvertToCentroid, ConvertToGremlin, ConvertToSpikeMine, ConvertToWrath, ConvertToMummy, ConvertToEel, ConvertToHellSpawn, ConvertToMultiGrenadeOgre, ConvertToKnightStatue, ConvertToDeathKnightStatue, ConvertToPhantomSwordsman, ConvertToZombie };

float ProbabilitiesMonsterToMonsterGround[22];
float ProbabilitiesMonsterToMonsterGroundByTier[] = {
    //  Easy  Normal  Hard  Nightmare  SuperNightmare  Unfair
     10,  14,  16,  22,  25,  29,  // Fiend
     22,  14,  12,   8,   4,   0,  // Rottweiler
     22,  18,  16,  11,   9,   0,  // Enforcer
     12,  20,  22,  26,  28,  24,  // Death Knight
     27,  31,  16,  16,  14,   0,  // Knight
     20,  18,  20,  22,  18,  22,  // Zombie
      4,   6,   8,  10,  14,  44,  // Vore
      1,   3,   5,   7,  11,  43,  // Shambler
     32,  26,  22,  13,  12,   0,  // Grunt
      2,   6,   8,  12,  12,  30,  // Spawn
     22,  24,  26,  26,  26,  40,  // Scrag
     24,  26,  26,  22,  26,   0,  // Ogre
      5,   9,  13,  15,  19,  31,  // Centroid
     16,  18,  22,  19,  16,   0,  // Gremlin
      7,  10,  11,  14,  18,  38,  // Wrath
      2,   4,   5,   7,   9,  18,  // Mummy
      1,   4,   6,  10,  10,  28,  // Hell Spawn
      2,   4,   6,   8,  12,   0,  // Multi-Grenade Ogre
     10,  13,   8,   8,   8,   0,  // Knight Statue
      9,   6,   8,  10,  12,  16,  // Death Knight Statue
     12,  20,  22,  26,  28,  24,  // Phantom Swordsman
      2,   3,   3,   4,   6,  10   // Spike Mine
};
void() MonsterGroundToGroundConverters[] = { ConvertToFiend, ConvertToDog, ConvertToEnforcer, ConvertToDeathKnight, ConvertToKnight, 
    ConvertToZombie, ConvertToVore, ConvertToShambler, ConvertToGrunt, ConvertToSpawn, ConvertToScrag, 
    ConvertToOgre, ConvertToCentroid, ConvertToGremlin, ConvertToWrath, ConvertToMummy, ConvertToHellSpawn, ConvertToMultiGrenadeOgre, ConvertToKnightStatue, ConvertToDeathKnightStatue, ConvertToPhantomSwordsman, ConvertToSpikeMine };
string MonsterGroundToGroundClassnames[] = { "monster_demon1", "monster_dog", "monster_enforcer", "monster_hell_knight", "monster_knight", "monster_zombie", "monster_shalrath", "monster_shambler", "monster_army", "monster_tarbaby", "monster_wizard", "monster_ogre", "monster_scourge", "monster_gremlin", "monster_wrath", "monster_mummy", "monster_tarbaby", "monster_ogre", "monster_knight", "monster_hell_knight", "monster_sword", "trap_spike_mine" };

float ProbabilitiesMonsterToMonsterWater[19];
float ProbabilitiesMonsterToMonsterWaterByTier[] = {
    //  Easy  Normal  Hard  Nightmare  SuperNightmare  Unfair
     16,  12,   8,   4,   2,   0,  // Fiend
     16,  24,  26,  27,  27,   0,  // Enforcer
     11,  24,  28,  28,  30,  10,  // Death Knight
     32,  22,  16,  12,   6,  20,  // Zombie
      3,   5,   8,   9,  13,  35,  // Vore
      1,   3,   5,   6,  10,  34,  // Shambler
     18,  26,  22,  27,  20,   0,  // Grunt
     10,   6,   8,   8,  14,   0,  // Spawn
     20,  24,  28,  30,  34,  70,  // Scrag
     16,  18,  18,  18,  20,   0,  // Ogre
     50,  34,  30,  22,  16,   0,  // Rotfish
      5,   9,  13,  14,  18,  20,  // Centroid
     16,  18,  22,  18,  16,   0,  // Gremlin
      6,   9,  11,  13,  17,  24,  // Wrath
      2,   3,   5,   7,   9,  12,  // Mummy
     10,  14,  31,  26,  22,   0,  // Eel
      9,   5,   7,   7,  13,   0,  // Hell Spawn
      2,   4,   6,   8,  10,   0,  // Multi-Grenade Ogre
      2,   3,   3,   4,   6, 210   // Spike Mine
};
void() MonsterWaterToWaterConverters[] = { ConvertToFiend, ConvertToEnforcer, ConvertToDeathKnight, ConvertToZombie, ConvertToVore, ConvertToShambler,
                                 ConvertToGrunt, ConvertToSpawn, ConvertToScrag, ConvertToOgre, ConvertToRotfish, ConvertToCentroid, ConvertToGremlin, ConvertToWrath, ConvertToMummy, ConvertToEel, ConvertToHellSpawn, ConvertToMultiGrenadeOgre, ConvertToSpikeMine };
string MonsterWaterToWaterClassnames[] = { "monster_demon1", "monster_enforcer", "monster_hell_knight", "monster_zombie", "monster_shalrath", "monster_shambler", "monster_army", "monster_tarbaby", "monster_wizard", "monster_ogre", "monster_fish", "monster_scourge", "monster_gremlin", "monster_wrath", "monster_mummy", "monster_eel", "monster_tarbaby", "monster_ogre", "trap_spike_mine" };

float ProbabilityToRemovePickup;                               // "Pickup" being Health, Armor, Ammo, Powerup or Weapon
float ProbabilityToRemovePickupByTier[6] = { 0, 0, 0, 0, 5, 10 };

float ProbabilityForLowQualityPickup;                          // "Low quality pickup" being 15 health or Green Armor
float ProbabilityForLowQualityPickupByTier[6] = { 30, 50, 65, 75, 85, 100 };

float ProbabilitiesAmmoTypes[4];
float ProbabilitiesAmmoTypesByTier[] = {
    //  Easy  Normal  Hard  Nightmare  SuperNightmare  Unfair
     25,  32,  38,  45,  60,  80,  // Shells
     25,  31,  38,  31,  25,  10,  // Nails
     20,  16,  13,  15,  12,   5,  // Rockets
     20,  16,   8,   7,   3,   5   // Cells
};
void() AmmoTypeConverters[] = { ConvertToShells, ConvertToNails, ConvertToRockets, ConvertToCells };
string AmmoNetNames[] = { "shells", "nails", "rockets", "cells" };

float ProbabilityForSmallAmmoPack;
float ProbabilityForSmallAmmoPackByTier[6] = { 50, 65, 70, 75, 80, 100 };

// Dissolution of Eternity: the chance (out of 100) for any ammo to turn into one of the alternate ammos (Lava Nails,
// Multi Rockets or Plasma, all equally likely) instead of a standard one. It is strong ammo for the player, so it is much
// rarer than any standard ammo, and it gets rarer as the difficulty goes up. Unbiased Mode doesn't play fair, but it
// keeps it rare too.
float ProbabilityForAlternateAmmo;
float ProbabilityForAlternateAmmoByTier[6] = { 20, 15, 10, 8, 5, 2 };
float ProbabilityForAlternateAmmoUnbiased          = 15;
void() AlternateAmmoConverters[] = { ConvertToLavaNails, ConvertToMultiRockets, ConvertToPlasma };
string AlternateAmmoNetNames[] = { "lava nails", "multi rockets", "plasma" };

float ProbabilitiesForPowerupsNearWater[11];
float ProbabilitiesForPowerupsNearWaterByTier[] = {
    //  Easy  Normal  Hard  Nightmare  SuperNightmare  Unfair
     20,  18,  17,  15,  12,   5,  // Pentagram of Protection
     20,  18,  17,  15,  12,   5,  // Quad Damage
     20,  18,  17,  15,  12,   5,  // Ring of Shadows
     15,  18,  17,  20,  24,  25,  // Health
     20,  18,  17,  15,  12,  10,  // Armor
     10,  15,  20,  25,  35,  25,  // Biosuit
     20,  18,  17,  15,  12,   8,  // Empathy Shields
     10,  15,  20,  25,  35,  25,  // Wetsuit
     20,  15,  10,   8,   5,   5,  // Horn of Conjuring
     15,  12,   9,   7,   5,   4,  // Power Shield
      5,   8,  10,  12,  18,  31   // Anti-Grav Belt
};
void() PowerupsNearWaterConverters[] = { ConvertToPentagramOfProtection, ConvertToQuadDamage, ConvertToRingOfShadows, ConvertToHealth, ConvertToArmor, ConvertToBiosuit, ConvertToEmpathyShields, ConvertToWetsuit, ConvertToHornOfConjuring, ConvertToPowerShield, ConvertToAntiGravBelt };
string PowerupsNearWaterClassnames[] = { "item_artifact_invulnerability", "item_artifact_super_damage", "item_artifact_invisibility", "item_health", "", "item_artifact_envirosuit", "item_artifact_empathy_shields", "item_artifact_wetsuit", "item_hornofconjuring", "item_powerup_shield", "item_powerup_belt" };

float ProbabilitiesForPowerupsNotNearWater[10];
float ProbabilitiesForPowerupsNotNearWaterByTier[] = {
    //  Easy  Normal  Hard  Nightmare  SuperNightmare  Unfair
     20,  19,  18,  15,  12,   5,  // Pentagram of Protection
     20,  19,  18,  15,  12,   5,  // Quad Damage
     20,  19,  18,  15,  12,   5,  // Ring of Shadows
     15,  19,  18,  20,  24,  45,  // Health
     20,  19,  18,  15,  12,  10,  // Armor
      5,   5,  10,  20,  28,  30,  // Weapon
     20,  18,  17,  15,  12,   8,  // Empathy Shields
     20,  15,  10,   8,   5,   5,  // Horn of Conjuring
     15,  12,   9,   7,   5,   4,  // Power Shield
      5,   8,  10,  12,  17,  31   // Anti-Grav Belt
};

void() PowerupsNotNearWaterConverters[] = { ConvertToPentagramOfProtection, ConvertToQuadDamage, ConvertToRingOfShadows, ConvertToHealth, ConvertToArmor, ConvertToWeaponBiased, ConvertToEmpathyShields, ConvertToHornOfConjuring, ConvertToPowerShield, ConvertToAntiGravBelt };
string PowerupsNotNearWaterClassnames[] = { "item_artifact_invulnerability", "item_artifact_super_damage", "item_artifact_invisibility", "item_health", "", "", "item_artifact_empathy_shields", "item_hornofconjuring", "item_powerup_shield", "item_powerup_belt" };

float ProbabilityForWeaponIntoPowerup;
float ProbabilityForWeaponIntoPowerupByTier[6] = { 3, 5, 8, 10, 15, 20 };

float ProbabilityForWeaponIntoAmmo;
float ProbabilityForWeaponIntoAmmoByTier[6] = { 0, 0, 1, 5, 10, 15 };

// END PROBABILITY "TABLES"

vector LastOriginThatRestartedWeaponBag; // Only used to remember what was the last position that failed to roll a weapon.

// Tier 0..5 is the column of the *ByTier tables to use: Easy, Normal, Hard, Nightmare, Super Nightmare and Unfair.
string DifficultyTierNames[] = { "Easy", "Normal", "Hard", "Nightmare", "Super Nightmare", "Unfair" };
float DIFFICULTY_TIERS = 6;

float(float difficulty) GetDifficultyTier = {
    if (difficulty < ThresholdForNormal) return 0;
    if (difficulty < ThresholdForHard) return 1;
    if (difficulty < ThresholdForNightmare) return 2;
    if (difficulty < ThresholdForSuperNightmare) return 3;
    if (difficulty < ThresholdForUnfair) return 4;
    return 5;
};

// Copies one column of the *ByTier tables (row i is at [i * DIFFICULTY_TIERS + tier]) into the live tables the converters read.
void(float tier) LoadDifficultyTables = {
    local float i;
    for(i = 0; i < ProbabilitiesMonsterToMonsterGround.length; i++)
        ProbabilitiesMonsterToMonsterGround[i] = ProbabilitiesMonsterToMonsterGroundByTier[i * DIFFICULTY_TIERS + tier];
    for(i = 0; i < ProbabilitiesMonsterToMonsterWater.length; i++)
        ProbabilitiesMonsterToMonsterWater[i] = ProbabilitiesMonsterToMonsterWaterByTier[i * DIFFICULTY_TIERS + tier];
    for(i = 0; i < ProbabilitiesAmmoTypes.length; i++)
        ProbabilitiesAmmoTypes[i] = ProbabilitiesAmmoTypesByTier[i * DIFFICULTY_TIERS + tier];
    for(i = 0; i < ProbabilitiesForPowerupsNearWater.length; i++)
        ProbabilitiesForPowerupsNearWater[i] = ProbabilitiesForPowerupsNearWaterByTier[i * DIFFICULTY_TIERS + tier];
    for(i = 0; i < ProbabilitiesForPowerupsNotNearWater.length; i++)
        ProbabilitiesForPowerupsNotNearWater[i] = ProbabilitiesForPowerupsNotNearWaterByTier[i * DIFFICULTY_TIERS + tier];
    ProbabilityToRemovePickup = ProbabilityToRemovePickupByTier[tier];
    ProbabilityForLowQualityPickup = ProbabilityForLowQualityPickupByTier[tier];
    ProbabilityForSmallAmmoPack = ProbabilityForSmallAmmoPackByTier[tier];
    ProbabilityForAlternateAmmo = ProbabilityForAlternateAmmoByTier[tier];
    ProbabilityForWeaponIntoPowerup = ProbabilityForWeaponIntoPowerupByTier[tier];
    ProbabilityForWeaponIntoAmmo = ProbabilityForWeaponIntoAmmoByTier[tier];
};

void() Randomize = {
    local float tier, atLeastOnePrint;
    IsDeveloper = cvar("developer");
    RandomMode = cvar("savedgamecfg");
    UnbiasedMode = (RandomMode & RANDOM_UNBIASED_MODE) > 0;
    HideInBackpacks = (RandomMode & RANDOM_BACKPACK_MODE) > 0;    
    RandomizeMonsters = (RandomMode & DO_NOT_RANDOMIZE_MONSTERS) == 0;
    RandomizeWeaponsAndAmmo = (RandomMode & DO_NOT_RANDOMIZE_WEAPONS_AND_AMMO) == 0;
    RandomizeHealthAndArmor = (RandomMode & DO_NOT_RANDOMIZE_HEALTH_AND_ARMOR) == 0;
    RandomizePowerups = (RandomMode & DO_NOT_RANDOMIZE_POWERUPS) == 0;
	dprint("EndlessCastleMapCount = ");
	dprint(ftos(EndlessCastleMapCount));
	dprint(".\n");

    next = 0;

    if (EndlessCastleMapCount == 0) 
        EndlessCastleMapDifficulty = ThresholdForNormal;                                   // Outside of Endless Castle, it will always play with Normal Odds
    else
    {
        if (EndlessCastleDifficultyLevel == 1) EndlessCastleMapDifficulty = EndlessCastleMapCount + StartingLevelForEasy;
        else if (EndlessCastleDifficultyLevel == 2) EndlessCastleMapDifficulty = EndlessCastleMapCount + StartingLevelForNormal;
        else if (EndlessCastleDifficultyLevel == 3) EndlessCastleMapDifficulty = EndlessCastleMapCount + StartingLevelForHard;
        else if (EndlessCastleDifficultyLevel == 4) EndlessCastleMapDifficulty = EndlessCastleMapCount + StartingLevelForNightmare;
        else if (EndlessCastleDifficultyLevel == 5) EndlessCastleMapDifficulty = EndlessCastleMapCount + StartingLevelForSuperNightmare;
        else if (EndlessCastleDifficultyLevel == 6) EndlessCastleMapDifficulty = EndlessCastleMapCount + StartingLevelForUnfair;
        EndlessCastleMapDifficulty = EndlessCastleMapDifficulty - 1;
    }

    tier = GetDifficultyTier(EndlessCastleMapDifficulty);
    LoadDifficultyTables(tier);
    dprint("Current Randomizer difficulty level is ");
    dprint(DifficultyTierNames[tier]);
    dprint(" (");
    dprint(ftos(EndlessCastleMapDifficulty));
    dprint(").\n");

    CreateWeaponPermutation();
    dprint("----- RANDOMIZER MOD -----\n");
    dprint("RandomMode is ");
    dprint(ftos(RandomMode));
    dprint(".\n");
    dprint("UnbiasedMode is ");
    dprint(ftos(UnbiasedMode));
    dprint(".\n");
    dprint("Seed is ");
    dprint(ftos(seed));
    if(seedIsFixed)
        dprint(" (FIXED)");
    dprint(".\n");    
    dprint("RandomizeMonsters is ");
    dprint(ftos(RandomizeMonsters));
    dprint(".\n");    
    dprint("RandomizeWeaponsAndAmmo is ");
    dprint(ftos(RandomizeWeaponsAndAmmo));
    dprint(".\n");    
    dprint("RandomizeHealthAndArmor is ");
    dprint(ftos(RandomizeHealthAndArmor));
    dprint(".\n");    
    dprint("RandomizePowerups is ");
    dprint(ftos(RandomizePowerups));
    dprint(".\n");
    dprint("SpawnedWeapons is ");
    dprint(ftos(SpawnedWeapons));
    if(SpawnedWeapons == 0 || SpawnedWeapons == FULL_WEAPON_BAG)
    {
        dprint(".\n");
    }
    else
    {
        atLeastOnePrint = FALSE;
        dprint(" (");
        if(SpawnedWeapons & IT_SUPER_SHOTGUN)
        {
            dprint("Double-Barreled Shotgun");
            atLeastOnePrint = TRUE;
        }
        if(SpawnedWeapons & IT_NAILGUN)
        {
            if(atLeastOnePrint)
                dprint(", ");
            dprint("Nailgun");
            atLeastOnePrint = TRUE;
        }
        if(SpawnedWeapons & IT_SUPER_NAILGUN)
        {
            if(atLeastOnePrint)
                dprint(", ");
            dprint("Super Nailgun");
            atLeastOnePrint = TRUE;
        }
        if(SpawnedWeapons & IT_GRENADE_LAUNCHER)
        {
            if(atLeastOnePrint)
                dprint(", ");
            dprint("Grenade Launcher");
            atLeastOnePrint = TRUE;
        }
        if(SpawnedWeapons & IT_ROCKET_LAUNCHER)
        {
            if(atLeastOnePrint)
                dprint(", ");
            dprint("Rocket Launcher");
            atLeastOnePrint = TRUE;
        }
        if(SpawnedWeapons & IT_LIGHTNING)
        {
            if(atLeastOnePrint)
                dprint(", ");
            dprint("Thunderbolt");
            atLeastOnePrint = TRUE;
        }
        if(SpawnedWeapons & IT_LASER_CANNON)
        {
            if(atLeastOnePrint)
                dprint(", ");
            dprint("Laser Cannon");
            atLeastOnePrint = TRUE;
        }
        if(SpawnedWeapons & IT_PROXIMITY_GUN)
        {
            if(atLeastOnePrint)
                dprint(", ");
            dprint("Proximity Gun");
            atLeastOnePrint = TRUE;
        }
        if(SpawnedWeapons & IT_MJOLNIR)
        {
            if(atLeastOnePrint)
                dprint(", ");
            dprint("Mjolnir");
        }        
        dprint(").\n");
        atLeastOnePrint = FALSE;
    }
    if (UnbiasedMode)
    {
        dprint("Starting unbiased randomizer. Don't say I didn't warn you.\n");
    }
    dprint("HideInBackpacks is ");
    dprint(ftos(HideInBackpacks));
    if(HideInBackpacks)
    {
        dprint("Backpack Mode is enabled. All weapons and ammo will be disguised as backpacks");
    }
    dprint(".\n");
    if(skill == 3)
    {
        if (IsRemastered())
        {
            dprint("Using Remastered Nightmare Mode.\n");
        }
        else
        {
            dprint("Using Classic Nightmare Mode.\n");
        }
    }
    Placeholder = spawn(); // Temporary entity to call the randomizer functions in order 
	Placeholder.think = ConvertEntities;
	Placeholder.nextthink = time;
};

void() ConvertEntities = {
    local entity temp;
    local float i;
    local float MAX_PER_CALL = 500;
    if(SpawnedWeapons == FULL_WEAPON_BAG)
    {
        dprint("All Weapons have Spawned at some point. Resetting Weapons Bag.\n");
        SpawnedWeapons = 0;
    }
	temp = find(world, Converted, "");
    i = 0;
    dprint("----- Starting ConvertEntities -----\n");
	while (temp != world && i < MAX_PER_CALL) // As long as it can find any entity that can be converted
	{
        temp.Converted = "-1";
        temp.Unstuckable = 0;
        if(temp.classname != "worldspawn")
        {
            if(temp.flags & FL_MONSTER || temp.classname == "trap_spike_mine")
            {
                dprint("Found ");
                dprint(temp.classname);
                dprint(". ");
                if(RandomizeMonsters)
                {
                    if(temp.classname == "monster_oldone" || temp.classname == "monster_armagon" || temp.classname == "monster_boss" || temp.classname == "monster_dragon" || temp.classname == "item_time_machine" || (temp.classname == "monster_zombie" && temp.spawnflags & SPAWN_CRUCIFIED))
                    {
                        if(temp.classname == "monster_zombie" && temp.spawnflags & SPAWN_CRUCIFIED)
                        {
                            temp.solid = SOLID_NOT;
                            dprint("This Zombie is cruficied. ");
                        }
                        dprint("Didn't flag for Convert.\n");
                    }
                    else 
                    {
                        if(temp.classname == "trap_spike_mine")
                        {
                            temp.angles = '0 0 0';
                            temp.avelocity = '0 0 0';
                        }
                        // This is to compensate the fact the replacement will ALSO increase the monster count
                        if(temp.flags & FL_MONSTER)
                            total_monsters = total_monsters - 1;
                        temp.Converted = "0";
                        temp.Unstuckable = 1;
                        temp.think = SUB_Null;
                        temp.oldsize = temp.size;
                        temp.oldmins = temp.mins;
                        temp.think = ConvertToMonster;
                        temp.nextthink = time;
                        dprint("Flagged as a monster.\n");
                    }
                }
                else
                {
                    temp.Converted = "1";
                    temp.nextClassname = self.classname;
                    dprint("Ignored due to randomizer settings.\n");
                }
            }
            else if(temp.flags & FL_ITEM)
            {
                dprint("Found ");
                dprint(temp.classname);
                dprint(". ");
                if(temp.classname == "item_key1" || temp.classname == "item_key2" || temp.classname == "item_sigil")
                {
                    dprint("Didn't flag for Convert.\n");
                }
                else if(temp.classname == "item_armor1" || temp.classname == "item_armor2"
                || (temp.classname == "item_health" && !(temp.spawnflags & H_MEGA)))
                {
                    if(RandomizeHealthAndArmor)
                    {
                        temp.Converted = "0";
                        temp.Unstuckable = 1;
                        temp.think = SUB_Null;
                        temp.oldsize = temp.size;
                        temp.oldmins = temp.mins;
                        if (!UnbiasedMode)
                        {
                            temp.think = ConvertToPickupBiased;
                        }
                        else
                        {
                            temp.think = ConvertToPickupUnbiased;
                        }
                        temp.nextthink = time;
                        dprint("Flagged as a pickup.\n");
                    }
                    else
                    {
                        temp.Converted = "1";
                        temp.nextClassname = self.classname;
                        dprint("Ignored due to randomizer settings.\n");
                    }
                }
                else if(temp.classname == "item_shells" || temp.classname == "item_spikes" || temp.classname == "item_rockets" || temp.classname == "item_cells" || temp.classname == "item_weapon"
                || temp.classname == "item_lava_spikes" || temp.classname == "item_multi_rockets" || temp.classname == "item_plasma")
                {
                    if(RandomizeWeaponsAndAmmo)
                    {
                        temp.Converted = "0";
                        temp.Unstuckable = 1;
                        temp.think = SUB_Null;
                        temp.oldsize = temp.size;
                        temp.oldmins = temp.mins;
                        if (!UnbiasedMode)
                        {
                            temp.think = ConvertToAmmoBiased;
                        }
                        else
                        {
                            temp.think = ConvertToAmmoUnbiased;
                        }
                        temp.nextthink = time;
                        dprint("Flagged as ammo.\n");
                    }
                    else
                    {
                        temp.Converted = "1";
                        temp.nextClassname = self.classname;
                        dprint("Ignored due to randomizer settings.\n");
                    }
                }
                else if(temp.classname == "item_armorInv" || (temp.classname == "item_health" && (temp.spawnflags & H_MEGA)) 
                || temp.classname == "item_artifact_invulnerability" || temp.classname == "item_artifact_envirosuit"
                || temp.classname == "item_artifact_invisibility" || temp.classname == "item_artifact_super_damage"
                || temp.classname == "item_artifact_wetsuit" || temp.classname == "item_hornofconjuring" || temp.classname == "item_artifact_empathy_shields"
                || temp.classname == "item_powerup_shield" || temp.classname == "item_powerup_belt")
                {
                    if(RandomizePowerups)
                    {
                        temp.Converted = "0";
                        temp.Unstuckable = 1;
                        temp.think = SUB_Null;
                        temp.oldsize = temp.size;
                        temp.oldmins = temp.mins;
                        if (!UnbiasedMode)
                        {
                            temp.think = ConvertToPowerupBiased;
                        }
                        else
                        {
                            temp.think = ConvertToPowerupUnbiased;
                        }
                        temp.nextthink = time;
                        dprint("Flagged as a powerup.\n");
                    }
                    else
                    {
                        temp.Converted = "1";
                        temp.nextClassname = self.classname;
                        dprint("Ignored due to randomizer settings.\n");
                    }
                }
                else if(temp.classname == "weapon_supershotgun" || temp.classname == "weapon_nailgun"
                || temp.classname == "weapon_supernailgun" || temp.classname == "weapon_grenadelauncher"
                || temp.classname == "weapon_rocketlauncher" || temp.classname == "weapon_lightning"
                || temp.classname == "weapon_laser_gun" || temp.classname == "weapon_mjolnir" || temp.classname == "weapon_proximity_gun")
                {
                    if(RandomizeWeaponsAndAmmo)
                    {
                        temp.Converted = "0";
                        temp.Unstuckable = 1;
                        temp.think = SUB_Null;
                        temp.oldsize = temp.size;
                        temp.oldmins = temp.mins;
                        if (!UnbiasedMode)
                        {
                            temp.think = ConvertToWeaponBiased;
                        }
                        else
                        {
                            temp.think = ConvertToWeaponUnbiased;
                        }
                        temp.nextthink = time;
                        dprint("Flagged as a weapon.\n");
                    }                    
                    else
                    {
                        temp.Converted = "1";
                        temp.nextClassname = self.classname;
                        dprint("Ignored due to randomizer settings.\n");
                    }
                }                
            }
            else if(temp.classname == "func_spawn" || temp.classname == "func_spawn_small")
            {
                dprint("Found ");
                dprint(temp.classname);
                dprint(". ");
                if(RandomizeMonsters)
                {
                    temp.Converted = "0";
                    temp.think = ConvertMonsterSpawn;
                    temp.nextthink = time;
                    dprint("Flagged as a Monster Spawn.\n");
                }
                else
                {
                    temp.Converted = "1";
                    temp.nextClassname = self.classname;
                    dprint("Ignored due to randomizer settings.\n");
                }
            }
        }
		temp = find(temp, Converted, "");
        i = i + 1;
	}
    if(temp == world || i < MAX_PER_CALL)
    {
        SUB_Remove_Target(Placeholder);
        dprint("----- Finished ConvertEntities -----\n");
		IsWorldFrozen = 0;
		cvar_set ("host_framerate", ftos(old_host_framerate));
        if(EndlessCastleMapCount > 0)
        {
			PrintedEndlessCastleSplash = 0;
            if(world.model == "maps/end.bsp")
                nextmap = PickNextLevel();
            else
            {
                local entity temp;
                temp = find(world, classname, "trigger_changelevel");
                while (temp != world)
                {
                    temp.map = PickNextLevel();
                    temp = find(temp, classname, "trigger_changelevel");
                }
            }
            PrintCurrentLevelCycle();
        }
    }
    else
    {
        Placeholder.think = ConvertEntities;
        Placeholder.nextthink = time;
    }
};


// Converts a monster from one type to another randomly.
// Chance depends on whether Biased Mode is on, and whether the monster is on water.
void() ConvertToMonster = {
    if(pointcontents(self.origin) != CONTENT_EMPTY)
    {
        if (!UnbiasedMode)
        {
            self.think = ConvertToMonsterOnWaterBiased;
        }
        else
        {
            self.think = ConvertToMonsterOnWaterUnbiased;
        }
    }
    else
    {
        if (!UnbiasedMode)
        {
            self.think = ConvertToMonsterOnGroundBiased;
        }
        else
        {
            self.think = ConvertToMonsterOnGroundUnbiased;
        }
    }
    self.nextthink = time;
};

// To convert a monster present in ground.
// Every monster has an equal chance to be appear.
// Prevents spawning Zombies if they are tied to a trigger (to prevent potential soft-locks).
void() ConvertToMonsterOnGroundUnbiased = {
    local float rng;
    rng = Random(1, MonsterUnbiasedClassnames.length);
    if(IsTiedToATrigger(self)) {
        rng = Random(1, MonsterUnbiasedSpawnFunctions.length - 1);
    }
    else {        
        rng = Random(1, MonsterUnbiasedSpawnFunctions.length);
    }
    while(MonsterUnbiasedSpawnFunctions[rng] == ConvertToRotfish || MonsterUnbiasedSpawnFunctions[rng] == ConvertToEel)
    {
        if(IsTiedToATrigger(self)) {
            rng = Random(1, MonsterUnbiasedSpawnFunctions.length - 1);
        }
        else {        
            rng = Random(1, MonsterUnbiasedSpawnFunctions.length);
        }
    }
    self.touch = SUB_Null;
    self.th_stand = SUB_Null;
    self.th_walk = SUB_Null;
    self.th_run = SUB_Null;
    self.th_melee = SUB_Null;
    self.th_missile = SUB_Null;
    self.th_pain = SUB_Null;
    self.use = SUB_Null;
    self.charmed = FALSE;
    self.think = MonsterUnbiasedSpawnFunctions[rng - 1];
    self.nextthink = time;
};

// To convert a monster present in water.
// Every monster has an equal chance to be appear.
// Prevents spawning Zombies if they are tied to a trigger (to prevent potential soft-locks).
void() ConvertToMonsterOnWaterUnbiased = {
    local float rng;
    if(IsTiedToATrigger(self)) {
        rng = Random(1, MonsterUnbiasedSpawnFunctions.length - 1);
    }
    else {        
        rng = Random(1, MonsterUnbiasedSpawnFunctions.length);
    }
    self.touch = SUB_Null;
    self.th_stand = SUB_Null;
    self.th_walk = SUB_Null;
    self.th_run = SUB_Null;
    self.th_melee = SUB_Null;
    self.th_missile = SUB_Null;
    self.th_pain = SUB_Null;
    self.use = SUB_Null;
    self.charmed = FALSE;
    self.think = MonsterUnbiasedSpawnFunctions[rng - 1];
    self.nextthink = time;
};

// To convert a monster present in ground.
// Monsters have an arbitrarily "fair" chance to appear.
// Prevents spawning Rotfish in ground (because they can't move there).
// Prevents spawning Spike Mines less than 128 units near the player (to give them a chance to react) or if they are tied to a trigger (to prevent potential soft-locks).
// Prevents spawning Zombies if they are tied to a trigger (to prevent potential soft-locks).
void() ConvertToMonsterOnGroundBiased = {
    local float rng, maxpossiblerng, minrng, maxrng, DONE, i, amountOfChoices, preventSpikeMines, preventZombies, distanceToPlayer, weight;

    amountOfChoices = ProbabilitiesMonsterToMonsterGround.length;
    distanceToPlayer = vlen(self.origin - playerPosition);

    // The excluded monsters get a weight of 0 below. The tables themselves are never touched.
    if(IsTiedToATrigger(self))
    {
        preventSpikeMines = 1;
        preventZombies = 1;
        dprint("Monster at ");
        dprint(vtos(self.origin));
        dprint(" is tied to a trigger. It won't spawn a Zombie or a Spike Mine.\n");
    }
    else if(distanceToPlayer < 128)
    {
        preventSpikeMines = 1;
        dprint("Monster at ");
        dprint(vtos(self.origin));
        dprint(" is too close to the player at ");
        dprint(vtos(playerPosition));
        dprint(" to spawn a Spike Mine in.\n");
    }

    maxpossiblerng = 0;
    for(i = 0; i < amountOfChoices; i++)
    {
        weight = ProbabilitiesMonsterToMonsterGround[i];
        if(preventSpikeMines && MonsterGroundToGroundClassnames[i] == "trap_spike_mine")
            weight = 0;
        if(preventZombies && MonsterGroundToGroundClassnames[i] == "monster_zombie")
            weight = 0;
        maxpossiblerng = maxpossiblerng + weight;
    }
    rng = Random(1, maxpossiblerng);
    minrng = 0;
    maxrng = 0;
    DONE = 0;
    i = 0;
    while(!DONE && minrng < maxpossiblerng && i < amountOfChoices)
    {
        weight = ProbabilitiesMonsterToMonsterGround[i];
        if(preventSpikeMines && MonsterGroundToGroundClassnames[i] == "trap_spike_mine")
            weight = 0;
        if(preventZombies && MonsterGroundToGroundClassnames[i] == "monster_zombie")
            weight = 0;
        if(weight > 0)
        {
            minrng = maxrng + 1;
            maxrng = maxrng + weight;
            if(rng >= minrng && rng <= maxrng)
            {
                DONE = 1;
                self.think = MonsterGroundToGroundConverters[i];
            }
        }
        i++;
    }
    self.nextthink = time;
};

// To convert a monster present in water. Prevents spawning Dogs and Knights in water (because they are melee-only, and thus useless there).
// Monsters have an arbitrarily "fair" chance to appear.
// Prevents spawning Spike Mines less than 128 units near the player (to give them a chance to react) or if they are tied to a trigger (to prevent potential soft-locks).
// Prevents spawning Zombies if they are tied to a trigger (to prevent potential soft-locks).
void() ConvertToMonsterOnWaterBiased = {
    local float rng, maxpossiblerng, minrng, maxrng, DONE, i, amountOfChoices, preventSpikeMines, preventZombies, distanceToPlayer, weight;

    amountOfChoices = ProbabilitiesMonsterToMonsterWater.length;
    distanceToPlayer = vlen(self.origin - playerPosition);

    // The excluded monsters get a weight of 0 below. The tables themselves are never touched.
    if(IsTiedToATrigger(self))
    {
        preventSpikeMines = 1;
        preventZombies = 1;
        dprint("Monster at ");
        dprint(vtos(self.origin));
        dprint(" is tied to a trigger. It won't spawn a Zombie or a Spike Mine.\n");
    }
    else if(distanceToPlayer < 128)
    {
        preventSpikeMines = 1;
        dprint("Monster at ");
        dprint(vtos(self.origin));
        dprint(" is too close to the player at ");
        dprint(vtos(playerPosition));
        dprint(" to spawn a Spike Mine in.\n");
    }

    maxpossiblerng = 0;
    for(i = 0; i < amountOfChoices; i++)
    {
        weight = ProbabilitiesMonsterToMonsterWater[i];
        if(preventSpikeMines && MonsterWaterToWaterClassnames[i] == "trap_spike_mine")
            weight = 0;
        if(preventZombies && MonsterWaterToWaterClassnames[i] == "monster_zombie")
            weight = 0;
        maxpossiblerng = maxpossiblerng + weight;
    }
    rng = Random(1, maxpossiblerng);
    minrng = 0;
    maxrng = 0;
    DONE = 0;
    i = 0;
    while(!DONE && minrng < maxpossiblerng && i < amountOfChoices)
    {
        weight = ProbabilitiesMonsterToMonsterWater[i];
        if(preventSpikeMines && MonsterWaterToWaterClassnames[i] == "trap_spike_mine")
            weight = 0;
        if(preventZombies && MonsterWaterToWaterClassnames[i] == "monster_zombie")
            weight = 0;
        if(weight > 0)
        {
            minrng = maxrng + 1;
            maxrng = maxrng + weight;
            if(rng >= minrng && rng <= maxrng)
            {
                DONE = 1;
                self.think = MonsterWaterToWaterConverters[i];
            }
        }
        i++;
    }
    self.nextthink = time;
};

// Sets a func_spawn for a Monster from one type to another randomly.
// Chance depends on whether Biased Mode is on, and whether the monster is on water.
void() ConvertMonsterSpawn = {
    if(pointcontents(self.origin) != CONTENT_EMPTY)
    {
        if (!UnbiasedMode)
        {
            self.think = ConvertMonsterSpawnOnWaterBiased;
        }
        else
        {
            self.think = ConvertMonsterSpawnOnWaterUnbiased;
        }
    }
    else
    {
        if (!UnbiasedMode)
        {
            self.think = ConvertMonsterSpawnOnGroundBiased;
        }
        else
        {
            self.think = ConvertMonsterSpawnOnGroundUnbiased;
        }
    }
    self.nextthink = time;
};

// To set a func_spawn for a monster present in ground.
// Every monster has an equal chance to be appear.
void() ConvertMonsterSpawnOnGroundUnbiased = {
    local float rng;
    rng = Random(1, MonsterUnbiasedClassnames.length);
    self.Converted = "1";
    self.think = SUB_Null;
    self.spawnfunction = MonsterUnbiasedSpawnFunctions[rng - 1];
    self.spawnclassname = MonsterUnbiasedClassnames[rng - 1];
    ConvertFuncSpawn(self);
};

// To set a func_spawn for a monster present in water.
// Every monster has an equal chance to be appear.
void() ConvertMonsterSpawnOnWaterUnbiased = {
    local float rng;
    self.Converted = "1";
    self.think = SUB_Null;
    rng = Random(1, MonsterUnbiasedClassnames.length);
    self.spawnfunction = MonsterUnbiasedSpawnFunctions[rng - 1];
    self.spawnclassname = MonsterUnbiasedClassnames[rng - 1];
    ConvertFuncSpawn(self);
};

// To set a func_spawn for a monster present in ground. Prevents spawning Rotfish in ground (because they can't move there).
// Monsters have an arbitrarily "fair" chance to appear.
void() ConvertMonsterSpawnOnGroundBiased = {
    local float rng, maxpossiblerng, minrng, maxrng, DONE, i, amountOfChoices;
    self.think = SUB_Null;    
    maxpossiblerng = 0;
    for(i = 0; i < ProbabilitiesMonsterToMonsterGround.length; i++)
    {
        maxpossiblerng = maxpossiblerng + ProbabilitiesMonsterToMonsterGround[i];
    }
    amountOfChoices = ProbabilitiesMonsterToMonsterGround.length;
    rng = Random(1, maxpossiblerng);
    minrng = 0;
    maxrng = 0;
    DONE = 0;
    i = 0;
    while(!DONE && minrng < maxpossiblerng && i < amountOfChoices)
    {
        if(ProbabilitiesMonsterToMonsterGround[i] > 0)
        {
            minrng = maxrng + 1;
            maxrng = maxrng + ProbabilitiesMonsterToMonsterGround[i];
            if(rng >= minrng && rng <= maxrng)
            {
                DONE = 1;
                self.spawnfunction = MonsterGroundToGroundConverters[i];
                self.spawnclassname = MonsterGroundToGroundClassnames[i];
            }
        }
        i++;
    }
    ConvertFuncSpawn(self);
};

// To set a func_spawn for a monster present in water. Prevents spawning Dogs and Knights in water (because they are melee-only, and thus useless there).
// Monsters have an arbitrarily "fair" chance to appear.
void() ConvertMonsterSpawnOnWaterBiased = {
    local float rng, maxpossiblerng, minrng, maxrng, DONE, i, amountOfChoices;
    self.think = SUB_Null;
    maxpossiblerng = 0;
    for(i = 0; i < ProbabilitiesMonsterToMonsterWater.length; i++)
    {
        maxpossiblerng = maxpossiblerng + ProbabilitiesMonsterToMonsterWater[i];
    }

    amountOfChoices = ProbabilitiesMonsterToMonsterWater.length;
    rng = Random(1, maxpossiblerng);
    minrng = 0;
    maxrng = 0;
    DONE = 0;
    i = 0;
    while(!DONE && minrng < maxpossiblerng && i < amountOfChoices)
    {
        if(ProbabilitiesMonsterToMonsterWater[i] > 0)
        {
            minrng = maxrng + 1;
            maxrng = maxrng + ProbabilitiesMonsterToMonsterWater[i];
            if(rng >= minrng && rng <= maxrng)
            {
                DONE = 1;
                self.spawnfunction = MonsterWaterToWaterConverters[i];
                self.spawnclassname = MonsterWaterToWaterClassnames[i];
            }
        }
        i++;
    }
    ConvertFuncSpawn(self);
};

// Converts a pickup of one type to another randomly.
// Even chance for a non-Mega Health Pickup or a non-Red Armor Pickup.
void() ConvertToPickupUnbiased = {
    local float rngType, rngQuality;
    local void() Converters[] = { ConvertToHealth, ConvertToArmor };
    rngType = Random(1, 2);
    rngQuality = Random(1, 2);
    self.think = Converters[rngType - 1];
    self.QualityType = floor(rngQuality);
    self.nextthink = time;
};

// Converts a pickup of one type to another randomly.
// 90% chance of being a pickup of the type it already is (Health or Armor, but quality can change), 10% of becoming of the other type.
// If there are nearby sources of armor, it will spawn a health pack instead
void() ConvertToPickupBiased = {
    if(ProbabilityToRemovePickup > 0)
    {
        local float rngRemove = Random(1, 100);
        if(rngRemove <= ProbabilityToRemovePickup)
            SUB_Remove();
    }
    local float rngType, rngQuality;
    local float ProbabilityForSameType = 90;
    local float nearbyArmor;
    rngType = Random(1, 100);
    rngQuality = Random(1, 100);
    if(rngQuality <= ProbabilityForLowQualityPickup)
        self.QualityType = 1;
    else
        self.QualityType = 2;
    nearbyArmor = IsNearOneOf(self, "item_armor1", "item_armor2", "item_armorInv");
    if(self.classname == "item_health")
    {
        if(nearbyArmor || (rngType >= 1 && rngType <= ProbabilityForSameType))
        { 
            self.think = ConvertToHealth;
        }
        else
        {
            if(rngQuality <= ProbabilityForLowQualityPickup)
		        self.nextClassname = "item_armor1";
            else
                self.nextClassname = "item_armor2";
            self.think = ConvertToArmor;
        }
    }
    else if(self.classname == "item_armor1" || self.classname == "item_armor2")
    {
        if(!nearbyArmor && rngType >= 1 && rngType <= ProbabilityForSameType)
        { 
            if(rngQuality <= ProbabilityForLowQualityPickup)
		        self.nextClassname = "item_armor1";
            else
                self.nextClassname = "item_armor2";
            self.think = ConvertToArmor;
        }
        else
        {
            self.think = ConvertToHealth;
        }
    }
    self.nextthink = time;
};

// Dissolution of Eternity: turns the entity into one of the alternate ammos (all equally likely).
void(float packSize) PickAlternateAmmo = {
    local float AmmoTypeRng;
    AmmoTypeRng = Random(1, AlternateAmmoConverters.length);
    self.QualityType = packSize;
    self.netname = AlternateAmmoNetNames[AmmoTypeRng - 1];
    if(!HideInBackpacks)
    {
        self.think = AlternateAmmoConverters[AmmoTypeRng - 1];
    }
    else
    {
        self.PickupType = AmmoTypeRng + 4;          // 5, 6 and 7 follow Shells, Nails, Rockets and Cells
        self.think = ConvertToAmmoBackpack;
    }
    self.nextthink = time;
};

// Converts ammo of one type to another randomly.
// Even chance for all ammo types and sizes
void() ConvertToAmmoUnbiased = {
    local float AmmoTypeRng, AmmoSizeRng;
    AmmoTypeRng = Random(1, 4);
    AmmoSizeRng = Random(1, 2);
    if(Random(1, 100) <= ProbabilityForAlternateAmmoUnbiased)
    {
        PickAlternateAmmo(AmmoSizeRng);
        return;
    }
    self.QualityType = AmmoSizeRng;
    self.netname = AmmoNetNames[AmmoTypeRng - 1];
    if(!HideInBackpacks)
    {    
        self.think = AmmoTypeConverters[AmmoTypeRng - 1];
    }
    else
    {
        self.PickupType = AmmoTypeRng;
        self.think = ConvertToAmmoBackpack;
    }
    self.nextthink = time;
};

// Converts ammo of one type to another randomly.
// 32% chance of being Shells, 31% chance of being Nails, 16% chance of being Rockets, 16% chance of being Cells, 5% chance of being any weapon (if enabled)
// For ammo, 65% chance of being a small pack, 35% chance of being a big pack
void() ConvertToAmmoBiased = {
    if(ProbabilityToRemovePickup > 0)
    {
        local float rngRemove = Random(1, 100);
        if(rngRemove <= ProbabilityToRemovePickup)
            SUB_Remove();
    }
    local float AmmoTypeRng, AmmoSizeRng, AmmoPackSize, minrng, maxrng, DONE, i, amountOfChoices;
    AmmoTypeRng = Random(1, 100);
    AmmoSizeRng = Random(1, 100);
    if(AmmoSizeRng <= ProbabilityForSmallAmmoPack)
        AmmoPackSize = 1;
    else
        AmmoPackSize = 2;
    if(ProbabilityForAlternateAmmo > 0 && Random(1, 100) <= ProbabilityForAlternateAmmo)
    {
        PickAlternateAmmo(AmmoPackSize);
        return;
    }
    amountOfChoices = ProbabilitiesAmmoTypes.length;
    minrng = 0;
    maxrng = 0;
    DONE = 0;
    i = 0;
    self.netname = string_null;
    while(!DONE && minrng < 100 && i < amountOfChoices)
    {
        if(ProbabilitiesAmmoTypes[i] > 0)
        {
            minrng = maxrng + 1;
            maxrng = maxrng + ProbabilitiesAmmoTypes[i];
            if(AmmoTypeRng >= minrng && AmmoTypeRng <= maxrng)
            {
                DONE = 1;
                self.QualityType = AmmoPackSize;
                self.netname = AmmoNetNames[i];
                if(!HideInBackpacks)
                    self.think = AmmoTypeConverters[i];
                else
                {
                    self.PickupType = i + 1;
                    self.think = ConvertToAmmoBackpack;
                }
            }
        }
        i++;
    }
    if(!DONE || self.netname == string_null)
    {
        self.think = ConvertToWeaponBiased;
        self.nextthink = time;
        return;
    }
    self.nextthink = time;
};

// Converts a powerup of one type to another randomly.
// Equal chance for a Megahealth, Red Armor, Pentagram of Protection, Quad Damage, Ring of Shadows, Biosuit, Empathy Shields, Wetsuit or Horn of Conjuring
void() ConvertToPowerupUnbiased = {
    local float rng;
    local void() Converters[] = { ConvertToPentagramOfProtection, ConvertToQuadDamage, ConvertToRingOfShadows, ConvertToHealth, ConvertToArmor, ConvertToBiosuit, ConvertToEmpathyShields, ConvertToWetsuit, ConvertToHornOfConjuring, ConvertToPowerShield, ConvertToAntiGravBelt };
    rng = Random(1, Converters.length);
    if(rng == 4 || rng == 5)
        self.QualityType = 3;
    self.think = Converters[rng - 1];
    self.nextthink = time;
};

// Converts a powerup of one type to another randomly.
// If there's Slime or Lava nearby: 18% chance of being either a Megahealth, Red Armor, Pentagram of Protection, Quad Damage or Ring of Shadows, 10% chance of being a Biosuit
// If there's no Slime or Lava nearby: 19% chance of being either a Megahealth, Red Armor, Pentagram of Protection, Quad Damage or Ring of Shadows, 5% chance of being a Weapon
// It spawns a weapon instead if it's trying to spawn in invalid conditions (Red Armor near another suit of armor, Powerup of the same type nearby)
void() ConvertToPowerupBiased = {
    if(ProbabilityToRemovePickup > 0)
    {
        local float rngRemove = Random(1, 100);
        if(rngRemove <= ProbabilityToRemovePickup)
            SUB_Remove();
    }
    local float rng, minrng, maxrng, maxpossiblerng, DONE, i, amountOfChoices, nearALiquid;
    
    nearALiquid = self.classname == "item_artifact_envirosuit" || self.classname == "item_artifact_wetsuit" || IsNearAHarmfulLiquidSurface(self, 512);
    maxpossiblerng = 0;
    if(nearALiquid)
    {
        for(i = 0; i < ProbabilitiesForPowerupsNearWater.length; i++)
        {
            maxpossiblerng = maxpossiblerng + ProbabilitiesForPowerupsNearWater[i];
        }
    }
    else 
    {
        for(i = 0; i < ProbabilitiesForPowerupsNotNearWater.length; i++)
        {
            maxpossiblerng = maxpossiblerng + ProbabilitiesForPowerupsNotNearWater[i];
        }
    }
    rng = Random(1, maxpossiblerng);
    minrng = 0;
    maxrng = 0;
    DONE = 0;
    i = 0;
    if(nearALiquid)
    {
        amountOfChoices = ProbabilitiesForPowerupsNearWater.length;
        while(!DONE && minrng < maxpossiblerng && i < amountOfChoices)
        {
            if(ProbabilitiesForPowerupsNearWater[i] > 0)
            {
                minrng = maxrng + 1;
                maxrng = maxrng + ProbabilitiesForPowerupsNearWater[i];
                if(rng >= minrng && rng <= maxrng)
                {
                    if(i != 4 && PowerupsNearWaterClassnames[i] != "")  // Not ConvertToArmor
                    {
                        if(!IsNearOneOf(self, PowerupsNearWaterClassnames[i], "", ""))
                        {                    
                            DONE = 1;
                            if(i == 3)                          // ConvertToHealth
                            {
                                self.healamount = 100;
                                self.QualityType = 3;
                            }
                            self.nextClassname = PowerupsNearWaterClassnames[i];
                            self.think = PowerupsNearWaterConverters[i];
                        }
                    }
                    else if(i == 4)                             // ConvertToArmor
                    {
                        if(!IsNearOneOf(self, "item_armor1", "item_armor2", "item_armorInv"))
                        {                    
                            DONE = 1;
                            self.QualityType = 3;
                            self.nextClassname = PowerupsNearWaterClassnames[i];
                            self.think = PowerupsNearWaterConverters[i];
                        }
                    }
                    break;
                }
            }
            i++;
        }
    }
    else
    {
        amountOfChoices = ProbabilitiesForPowerupsNotNearWater.length;
        while(!DONE && minrng < maxpossiblerng && i < amountOfChoices)
        {
            if(ProbabilitiesForPowerupsNotNearWater[i] > 0)
            {
                minrng = maxrng + 1;
                maxrng = maxrng + ProbabilitiesForPowerupsNotNearWater[i];
                if(rng >= minrng && rng <= maxrng)
                {
                    if(i != 4 && i != 5 && PowerupsNotNearWaterClassnames[i] != "")  // Not ConvertToArmor
                    {
                        if(!IsNearOneOf(self, PowerupsNotNearWaterClassnames[i], "", ""))
                        {                    
                            DONE = 1;
                            if(i == 3)                          // ConvertToHealth
                            {
                                self.healamount = 100;
                                self.QualityType = 3;
                            }
                            self.nextClassname = PowerupsNotNearWaterClassnames[i];
                            self.think = PowerupsNotNearWaterConverters[i];
                        }
                    }
                    else if(i == 4)                             // ConvertToArmor
                    {
                        if(!IsNearOneOf(self, "item_armor1", "item_armor2", "item_armorInv"))
                        {                    
                            DONE = 1;
                            self.QualityType = 3;
                            self.nextClassname = PowerupsNotNearWaterClassnames[i];
                            self.think = PowerupsNotNearWaterConverters[i];
                        }
                    }
                    else if(i == 5)
                    {
                        if(RandomizeWeaponsAndAmmo)
                        {
                            self.nextClassname = PowerupsNotNearWaterClassnames[i];
                            self.think = PowerupsNotNearWaterConverters[i];
                        }
                        else
                        {
                            self.nextClassname = "item_artifact_super_damage";
                            self.think = ConvertToQuadDamage;
                        }
                    }
                    break;
                }
            }
            i++;
        }
    }
    if(!DONE)
    {
        if(RandomizeWeaponsAndAmmo)
        {
            self.think = ConvertToWeaponBiased;
        }
        else
        {
            self.think = ConvertToPowerupUnbiased;        // Disregard proximity if weapons are disabled.
        }
        self.nextthink = time;
        return;
    }
    self.nextthink = time;
};

// Converts a weapon of one type to another randomly.
// Chances are completely even, even in Biased mode.
void() ConvertToWeaponUnbiased = {
    local float rng;
    local void() Converters[] = { ConvertToDoubleBarrelledShotgun, ConvertToNailgun, ConvertToSuperNailgun, ConvertToGrenadeLauncher, ConvertToRocketLauncher, ConvertToThunderbolt, ConvertToLaserCannon, ConvertToProximityGun, ConvertToMjolnir };
    local float PickupTypes[] = { IT_SUPER_SHOTGUN, IT_NAILGUN, IT_SUPER_NAILGUN, IT_GRENADE_LAUNCHER, IT_ROCKET_LAUNCHER, IT_LIGHTNING, IT_LASER_CANNON, IT_PROXIMITY_GUN, IT_MJOLNIR };
    rng = Random(1, 6);
    if(!HideInBackpacks)
        self.think = Converters[rng - 1];
    else
    {
        self.PickupType = PickupTypes[rng - 1];
        self.think = ConvertToWeaponBackpack;
    }
    self.nextthink = time;
};

// Creates a "bag" of nine randomly permutated weapons
void() CreateWeaponPermutation = {
    local float PickupTypes[] = { IT_SUPER_SHOTGUN, IT_NAILGUN, IT_SUPER_NAILGUN, IT_GRENADE_LAUNCHER, IT_ROCKET_LAUNCHER, IT_LIGHTNING, IT_LASER_CANNON, IT_PROXIMITY_GUN, IT_MJOLNIR };
    local string Classnames[] = { "weapon_supershotgun", "weapon_nailgun", "weapon_supernailgun", "weapon_grenadelauncher", "weapon_rocketlauncher", "weapon_lightning", "weapon_laser_gun", "weapon_proximity_gun", "weapon_mjolnir" };
    local float numbers[] = { 0, 1, 2, 3, 4, 5, 6, 7, 8 };
    local float shuffledNumbers[numbers.length];
    local float rng, count, i, j, n, shuffled, atLeastOnePrint;
    count = numbers.length;
    if(SpawnedWeapons == 0)
    {
        rng = 0;
        shuffled = 1;
        for(j = 0; j < numbers.length && shuffled; j++)
        {
            shuffled = 0;
            for(i = 0; i < count; i++)
            {
                if(rng < numbers.length)
                {
                    shuffled = 1;
                    shuffledNumbers[rng] = numbers[i];
                    numbers[i] = numbers[count - 1];
                    PickupTypes[i] = PickupTypes[count - 1];
                    count = count - 1;
                    rng = rng + 1;
                }
            }
        }
    }
    for(i = (numbers.length - count); i < 8; i++)
    {
        rng = Random(0, (count - 1));
        shuffledNumbers[i] = numbers[rng];
        numbers[rng] = numbers[count - 1];
        PickupTypes[rng] = PickupTypes[count - 1];
        count = count - 1;
    }
    shuffledNumbers[i] = numbers[count - 1];
    for(i = 0; i < numbers.length; i++)
        IndexPermutation[i] = shuffledNumbers[i];
        
    dprint("Weapon Permutation for the level: ");
    atLeastOnePrint = FALSE;
    for(i = 0; i < IndexPermutation.length; i++)
    {
        if(atLeastOnePrint)
            dprint(", ");
        dprint(Classnames[IndexPermutation[i]]);
        atLeastOnePrint = TRUE;    
    }
    dprint(".\n");
    atLeastOnePrint = FALSE;
};

// Converts a weapon of one type to another randomly.
// Chances are completely even, even in Biased mode. However, in Biased mode, a weapon may not appear more than once if any of the other weapons hasn't appeared yet.
// If all weapons have spawned, it will create a new weapon bag. It has a 50% chance of spawning a powerup (if enabled) or a new weapon.
// Thunderbolts can't be spawned in liquid surfaces (if it's the only weapon left to spawn, it will spawn a powerup (if enabled) instead.
// In any moment, there's a 5% chance of a Powerup spawning (if enabled) instead of a weapon.
void() ConvertToWeaponBiased = {
    if(ProbabilityToRemovePickup > 0)
    {
        local float rngRemove = Random(1, 100);
        if(rngRemove <= ProbabilityToRemovePickup)
            SUB_Remove();
    }
    local float rng;
    if(SpawnedWeapons == FULL_WEAPON_BAG)
    {
        dprint("All Weapons have Spawned at some point. Trying to roll something different.\n");
        rng = Random(1, 100);
        SpawnedWeapons = 0;
        if(RandomizePowerups && rng <= 50)
            self.think = ConvertToPowerupBiased;
        else
            self.think = ConvertToWeaponBiased;
        self.nextthink = time;
        return;
    }
    rng = Random(1, 100);
    if(RandomizePowerups)
    {    
        if(rng >= (100 - ProbabilityForWeaponIntoPowerup))
        {
            dprint("Weapon is getting converted into a powerup.\n");
            self.think = ConvertToPowerupBiased;
            self.nextthink = time;
            return;
        }
        else if (rng >= (100 - ProbabilityForWeaponIntoPowerup - ProbabilityForWeaponIntoAmmo))
        {    
            dprint("Weapon is getting converted into ammo.\n");
            self.think = ConvertToAmmoBiased;
            self.nextthink = time;
            return;
        }
    }
    else
    {
        if (rng >= (100 - ProbabilityForWeaponIntoAmmo))
        {    
            dprint("Weapon is getting converted into ammo.\n");
            self.think = ConvertToAmmoBiased;
            self.nextthink = time;
            return;
        }
    }
    
    local float i, currentSurface, isValidSurface;
    local void() Converters[] = { ConvertToDoubleBarrelledShotgun, ConvertToNailgun, ConvertToSuperNailgun, ConvertToGrenadeLauncher, ConvertToRocketLauncher, ConvertToThunderbolt, ConvertToLaserCannon, ConvertToProximityGun, ConvertToMjolnir };
    local float PickupTypes[] = { IT_SUPER_SHOTGUN, IT_NAILGUN, IT_SUPER_NAILGUN, IT_GRENADE_LAUNCHER, IT_ROCKET_LAUNCHER, IT_LIGHTNING, IT_LASER_CANNON, IT_PROXIMITY_GUN, IT_MJOLNIR };
    local string Classnames[] = { "weapon_supershotgun", "weapon_nailgun", "weapon_supernailgun", "weapon_grenadelauncher", "weapon_rocketlauncher", "weapon_lightning", "weapon_laser_gun", "weapon_proximity_gun", "weapon_mjolnir" };
    local float WeaponPermutation[Converters.length];
    local void() ConvertersPermutation[Converters.length];
    for(i = 0; i < Converters.length; i++)
    {
        ConvertersPermutation[i] = Converters[IndexPermutation[i]];
        WeaponPermutation[i] = PickupTypes[IndexPermutation[i]];
    }
    local float PickedWeapon;
    for(i = 0; i < Converters.length; i++)
    {
        PickedWeapon = WeaponPermutation[i];
        if(PickedWeapon != IT_LIGHTNING && PickedWeapon != IT_MJOLNIR)
        {
            isValidSurface = 1;
        }
        else
        {
            currentSurface = pointcontents(self.origin);
            isValidSurface = currentSurface != CONTENT_WATER && currentSurface != CONTENT_SLIME && currentSurface != CONTENT_LAVA;
        }
        if(SpawnedWeapons & PickedWeapon)
        {
            dprint(Classnames[i]);
            dprint(" had already been spawned. Looking for another.\n");
        }
        else if (!isValidSurface) 
        {
            dprint(Classnames[i]);
            dprint(" can't be spawned on liquids. Looking for another.\n");
        }
        else if(IsNearOneOf(self, Classnames[i], string_null, string_null))
        {
            dprint(Classnames[i]);
            dprint(" can't be spawned too close to another of its same type. Looking for another.\n");
        }
        else        
        {
            self.nextClassname = Classnames[i];
            if(!HideInBackpacks)
            {    
                self.think = ConvertersPermutation[i];
            }
            else
            {
                self.PickupType = PickedWeapon;
                self.think = ConvertToWeaponBackpack;
            }
            SpawnedWeapons = SpawnedWeapons | PickedWeapon;
            self.nextthink = time;
            return;
        }
    }

    if(LastOriginThatRestartedWeaponBag == self.origin)
    {
        // There are some strange situations where the weapon roll keeps failing. We stop it by forcing an ammo spawn instead.
        dprint("Weapon bag restart detected at the same location as last time. Forcing spawn of Ammo instead.\n");
        self.think = ConvertToAmmoBiased;
        self.nextthink = time;
        return;
    }
    // If all weapons were rolled (or can't be spawned in the current location), it will instead spawn a powerup (if enabled; otherwise it spawns Ammo) and restarts the bag.
    if(RandomizePowerups)
    {
        dprint("Weapon is getting converted into a powerup.\n");
        self.think = ConvertToPowerupBiased;
    }
    else
    {
        dprint("Weapon is getting converted into ammo.\n");
        self.think = ConvertToAmmoBiased;
    }
    dprint("All Weapon rolls failed. Restarting bag.\n");
    SpawnedWeapons = 0;
    LastOriginThatRestartedWeaponBag = self.origin;
    self.nextthink = time;
    return;
};