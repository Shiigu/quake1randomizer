void() Randomize;
void() ConvertEntities;
void() ConvertToMonster;
void() ConvertToMonsterOnGroundBiased;
void() ConvertToMonsterOnGroundUnbiased;
void() ConvertToMonsterOnWaterBiased;
void() ConvertToMonsterOnWaterUnbiased;
void() ConvertToPickupBiased;
void() ConvertToPickupUnbiased;
void() ConvertToAmmoBiased;
void() ConvertToAmmoUnbiased;
void() ConvertToPowerupBiased;
void() ConvertToPowerupUnbiased;
void() ConvertToWeaponBiased;
void() ConvertToWeaponUnbiased;
void() CreateWeaponPermutation;
void() CreateWeaponPermutation;

/* Entities will be converted to one of the same type:
    - "Monster" for Monsters
    - "Pickup" for Health (except for Mega) and Armor (except for Red)
    - "Ammo" for Ammunition (both small and big)
    - "Weapon" for Weapons
    - "Powerup" for Megahealth, Red Armor and Powerups */

entity Placeholder;
float IndexPermutation[6];

void() Randomize = {
    RandomMode = cvar("savedgamecfg");
    UnbiasedMode = (RandomMode & RANDOM_UNBIASED_MODE) > 0;
    HideInBackpacks = (RandomMode & RANDOM_BACKPACK_MODE) > 0;    
    RandomizeMonsters = (RandomMode & DO_NOT_RANDOMIZE_MONSTERS) == 0;
    RandomizeWeaponsAndAmmo = (RandomMode & DO_NOT_RANDOMIZE_WEAPONS_AND_AMMO) == 0;
    RandomizeHealthAndArmor = (RandomMode & DO_NOT_RANDOMIZE_HEALTH_AND_ARMOR) == 0;
    RandomizePowerups = (RandomMode & DO_NOT_RANDOMIZE_POWERUPS) == 0;
	fixedSeed = floor(cvar("gamecfg"));
	if(fixedSeed > 0)
	{
        seed = fixedSeed;
        seedIsFixed = 1;
    }
	else
    {
        if(time == 0)
		    seed = floor((10000000000 * time) % 40000000);
        else
            seed = floor((10000000000 * random()) % 40000000);                  // When you use "kill" or "restart", time is always 0 so this ensures there's a variable seed.
    }
    next = 0;
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
    Placeholder = spawn(); // Temporary entity to call the randomizer functions in order 
	Placeholder.think = ConvertEntities;
	Placeholder.nextthink = time;
};

void() ConvertEntities = {
    local entity temp;
    local float i;
    local float MAX_PER_CALL = 500;
    if(SpawnedWeapons & IT_SUPER_SHOTGUN && 
        SpawnedWeapons & IT_NAILGUN && 
        SpawnedWeapons & IT_SUPER_NAILGUN && 
        SpawnedWeapons & IT_GRENADE_LAUNCHER && 
        SpawnedWeapons & IT_ROCKET_LAUNCHER && 
        SpawnedWeapons & IT_LIGHTNING)
    {
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
            if(temp.flags & FL_MONSTER)
            {
                dprint("Found ");
                dprint(temp.classname);
                dprint(". ");
                if(RandomizeMonsters)
                {
                    if(temp.classname == "monster_oldone" || temp.classname == "monster_boss" || (temp.classname == "monster_zombie" && temp.spawnflags & SPAWN_CRUCIFIED))
                    {
                        if(temp.classname == "monster_zombie" && temp.spawnflags & SPAWN_CRUCIFIED)
                        {
                            dprint("This Zombie is cruficied. ");
                        }
                        dprint("Didn't flag for Convert.\n");
                    }
                    else 
                    {
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
                else if(temp.classname == "item_shells" || temp.classname == "item_spikes" || temp.classname == "item_rockets" || temp.classname == "item_cells" || temp.classname == "item_weapon")
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
                || temp.classname == "item_artifact_invisibility" || temp.classname == "item_artifact_super_damage")
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
                || temp.classname == "weapon_rocketlauncher" || temp.classname == "weapon_lightning")
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
        }
		temp = find(temp, Converted, "");
        i = i + 1;
	}
    if(temp == world || i < MAX_PER_CALL)
    {
        remove(Placeholder);
        dprint("----- Finished ConvertEntities -----\n");
    }
    else
    {
        Placeholder.think = ConvertEntities;
        Placeholder.nextthink = time;
    }
};


// Converts a monster from one type to another randomly.
// Chances are completely even
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

// To convert a monster present in ground. Prevents spawning Rotfish in ground.
// Every monster has an equal chance to be appear.
void() ConvertToMonsterOnGroundUnbiased = {
    local float rng;
    local void() Converters[] = { ConvertToFiend, ConvertToDog, ConvertToEnforcer, ConvertToDeathKnight, ConvertToKnight, 
                                ConvertToZombie, ConvertToVore, ConvertToShambler, ConvertToGrunt, ConvertToSpawn, ConvertToScrag, ConvertToOgre };
    rng = Random(1, 12);
    self.think = Converters[rng - 1];
    self.nextthink = time;
};

// To convert a monster present in water.
// Every monster has an equal chance to be appear.
void() ConvertToMonsterOnWaterUnbiased = {
    local float rng;
    local void() Converters[] = { ConvertToFiend, ConvertToDog, ConvertToEnforcer, ConvertToDeathKnight, ConvertToKnight, ConvertToZombie,
                                ConvertToVore, ConvertToShambler, ConvertToGrunt, ConvertToSpawn, ConvertToScrag, ConvertToOgre, ConvertToRotfish };
    rng = Random(1, 13);
    self.think = Converters[rng - 1];
    self.nextthink = time;
};

// To convert a monster present in ground. Prevents spawning Rotfish in ground (because they can't move there).
// Monsters have an arbitrarily "fair" chance to appear.
void() ConvertToMonsterOnGroundBiased = {
    local float rng, minrng, maxrng, DONE, i, amountOfChoices;
    local void() Converters[] = { ConvertToFiend, ConvertToDog, ConvertToEnforcer, ConvertToDeathKnight, ConvertToKnight, 
                                ConvertToZombie, ConvertToVore, ConvertToShambler, ConvertToGrunt, ConvertToSpawn, ConvertToScrag, ConvertToOgre };
    local float Probabilities[] = { 7, 7, 9, 10, 12, 9, 3, 2, 13, 3, 12, 13 };
    amountOfChoices = Probabilities.length;
    rng = Random(1, 100);
    minrng = 0;
    maxrng = 0;
    DONE = 0;
    i = 0;
    while(!DONE && minrng < 100 && i < amountOfChoices)
    {
        minrng = maxrng + 1;
        maxrng = maxrng + Probabilities[i];
        if(rng >= minrng && rng <= maxrng)
        {
            DONE = 1;
            self.think = Converters[i];
        }
        i++;
    }
    self.nextthink = time;
};

// To convert a monster present in water. Prevents spawning Dogs and Knights in water (because they are melee-only, and thus useless there).
// Monsters have an arbitrarily "fair" chance to appear.
void() ConvertToMonsterOnWaterBiased = {
    local float rng, minrng, maxrng, DONE, i, amountOfChoices;
    local void() Converters[] = { ConvertToFiend, ConvertToEnforcer, ConvertToDeathKnight, ConvertToZombie, ConvertToVore, ConvertToShambler,
                                 ConvertToGrunt, ConvertToSpawn, ConvertToScrag, ConvertToOgre, ConvertToRotfish };
    local float Probabilities[] = { 6, 12, 12, 11, 3, 2, 13, 3, 12, 9, 16 };
    amountOfChoices = Probabilities.length;
    rng = Random(1, 100);
    minrng = 0;
    maxrng = 0;
    DONE = 0;
    i = 0;
    while(!DONE && minrng < 100 && i < amountOfChoices)
    {
        minrng = maxrng + 1;
        maxrng = maxrng + Probabilities[i];
        if(rng >= minrng && rng <= maxrng)
        {
            DONE = 1;
            self.think = Converters[i];
        }
        i++;
    }
    self.nextthink = time;
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
    local float rngType, rngQuality;
    local float ProbabilityForSameType = 90;
    local float nearbyArmor;
    rngType = Random(1, 100);
    rngQuality = Random(1, 2);
    self.QualityType = rngQuality;
    nearbyArmor = IsNearOneOf(self, "item_armor1", "item_armor2", "item_armorInv");
    if(self.classname == "item_health")
    {
        if(nearbyArmor || (rngType >= 1 && rngType <= ProbabilityForSameType))
        { 
            self.think = ConvertToHealth;
        }
        else
        {
            if(rngQuality == 1)
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
            if(rngQuality == 1)
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

// Converts ammo of one type to another randomly.
// Even chance for all ammo types and sizes
void() ConvertToAmmoUnbiased = {
    local float AmmoTypeRng, AmmoSizeRng;
    local void() Converters[] = { ConvertToShells, ConvertToNails, ConvertToRockets, ConvertToCells };
    local string AmmoNetNames[] = { "shells", "nails", "rockets", "cells" };
    AmmoTypeRng = Random(1, 4);
    AmmoSizeRng = Random(1, 2);
    self.QualityType = AmmoSizeRng;
    self.netname = AmmoNetNames[AmmoTypeRng - 1];
    if(!HideInBackpacks)
    {    
        self.think = Converters[AmmoTypeRng - 1];
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
    local float AmmoTypeRng, AmmoSizeRng, AmmoPackSize, minrng, maxrng, DONE, i, amountOfChoices;
    local void() Converters[] = { ConvertToShells, ConvertToNails, ConvertToRockets, ConvertToCells };
    local string AmmoNetNames[] = { "shells", "nails", "rockets", "cells" };
    local float ProbabilityForSmallPack = 65;
    local float AmmoTypeProbabilities[] = { 32, 31, 16, 16 };
    AmmoTypeRng = Random(1, 100);
    AmmoSizeRng = Random(1, 100);
    if(AmmoSizeRng <= ProbabilityForSmallPack)
        AmmoPackSize = 1;
    else
        AmmoPackSize = 2;
    amountOfChoices = AmmoTypeProbabilities.length;
    minrng = 0;
    maxrng = 0;
    DONE = 0;
    i = 0;
    self.netname = string_null;
    while(!DONE && minrng < 100 && i < amountOfChoices)
    {
        minrng = maxrng + 1;
        maxrng = maxrng + AmmoTypeProbabilities[i];
        if(AmmoTypeRng >= minrng && AmmoTypeRng <= maxrng)
        {
            DONE = 1;
            self.QualityType = AmmoPackSize;
            self.netname = AmmoNetNames[i];
            if(!HideInBackpacks)
                self.think = Converters[i];
            else
            {
                self.PickupType = i + 1;
                self.think = ConvertToAmmoBackpack;
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
// Equal chance for a Megahealth, Red Armor, Pentagram of Protection, Quad Damage, Ring of Shadows or Biosuit
void() ConvertToPowerupUnbiased = {
    local float rng;
    local void() Converters[] = { ConvertToPentagramOfProtection, ConvertToQuadDamage, ConvertToRingOfShadows, ConvertToHealth, ConvertToArmor, ConvertToBiosuit };
    rng = Random(1, 6);
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
    local float rng, minrng, maxrng, DONE, i, amountOfChoices;
    local void() Converters[] = { ConvertToPentagramOfProtection, ConvertToQuadDamage, ConvertToRingOfShadows, ConvertToHealth, ConvertToArmor, ConvertToBiosuit };
    local string Classnames[] = { "item_artifact_invulnerability", "item_artifact_super_damage", "item_artifact_invisibility", "item_health", string_null, "item_artifact_envirosuit" };
    local float Probabilities[] = { 18, 18, 18, 18, 18, 10 };
    amountOfChoices = Probabilities.length;
    if(!IsNearAHarmfulLiquidSurface(self, 512))
    {
        // Adjust possibilities to allow weapons (or Quad Damage in case weapon randomization is disabled) in case there's no nearby water body
        if(RandomizeWeaponsAndAmmo)
        {
            Converters[amountOfChoices - 1] = ConvertToWeaponBiased;
            Classnames[amountOfChoices - 1] = string_null;
        }
        else        
        {
            Converters[amountOfChoices - 1] = ConvertToQuadDamage;
            Classnames[amountOfChoices - 1] = "item_artifact_super_damage";
        }
        for(i = 0; i < 5; i++)
            Probabilities[i] = 19;
        Probabilities[amountOfChoices - 1] = 5;
    }
    rng = Random(1, 100);
    minrng = 0;
    maxrng = 0;
    DONE = 0;
    i = 0;
    while(!DONE && minrng < 100 && i < amountOfChoices)
    {
        minrng = maxrng + 1;
        maxrng = maxrng + Probabilities[i];
        if(rng >= minrng && rng <= maxrng)
        {
            if(i != 4 && Classnames[i] != string_null)  // Not ConvertToArmor
            {
                if(!IsNearOneOf(self, Classnames[i], string_null, string_null))
                {                    
                    DONE = 1;
                    if(i == 3)                          // ConvertToHealth
                    {
                        self.healamount = 100;
                        self.QualityType = 3;
                    }
                    self.nextClassname = Classnames[i];
                    self.think = Converters[i];
                }
            }
            else if(i == 4)                             // ConvertToArmor
            {
                if(!IsNearOneOf(self, "item_armor1", "item_armor2", "item_armorInv"))
                {                    
                    DONE = 1;
                    self.QualityType = 3;
                    self.nextClassname = Classnames[i];
                    self.think = Converters[i];
                }
            }
            break;
        }
        i++;
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
    local void() Converters[] = { ConvertToDoubleBarrelledShotgun, ConvertToNailgun, ConvertToSuperNailgun, ConvertToGrenadeLauncher, ConvertToRocketLauncher, ConvertToThunderbolt };
    local float PickupTypes[] = { IT_SUPER_SHOTGUN, IT_NAILGUN, IT_SUPER_NAILGUN, IT_GRENADE_LAUNCHER, IT_ROCKET_LAUNCHER, IT_LIGHTNING };
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

// Creates a "bag" of six randomly permutated weapons
void() CreateWeaponPermutation = {
    local float PickupTypes[] = { IT_SUPER_SHOTGUN, IT_NAILGUN, IT_SUPER_NAILGUN, IT_GRENADE_LAUNCHER, IT_ROCKET_LAUNCHER, IT_LIGHTNING };
    local float numbers[] = { 0, 1, 2, 3, 4, 5 };
    local float shuffledNumbers[6];
    local float rng, count, i, j, shuffled;
    count = 6;
    // If the player owns SOME of the spawnable weapons, but not all of them, place them first in the shuffled list because they will be skipped
    if(SpawnedWeapons && !(SpawnedWeapons & IT_SUPER_SHOTGUN && 
        SpawnedWeapons & IT_NAILGUN && 
        SpawnedWeapons & IT_SUPER_NAILGUN && 
        SpawnedWeapons & IT_GRENADE_LAUNCHER && 
        SpawnedWeapons & IT_ROCKET_LAUNCHER && 
        SpawnedWeapons & IT_LIGHTNING))
    {
        rng = 0;
        shuffled = 1;
        for(j = 0; j < 6 && shuffled; j++)
        {
            shuffled = 0;
            for(i = 0; i < count; i++)
            {
                if(rng < 6)
                {
                    if(SpawnedWeapons & PickupTypes[i])
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
    }
    for(i = (6 - count); i < 5; i++)
    {
        rng = Random(0, (count - 1));
        shuffledNumbers[i] = numbers[rng];
        numbers[rng] = numbers[count - 1];
        PickupTypes[rng] = PickupTypes[count - 1];
        count = count - 1;
    }
    shuffledNumbers[i] = numbers[count - 1];
    for(i = 0; i < 6; i++)
        IndexPermutation[i] = shuffledNumbers[i];
};

// Converts a weapon of one type to another randomly.
// Chances are completely even, even in Biased mode. However, in Biased mode, a weapon may not appear more than once if any of the other weapons hasn't appeared yet.
// If all weapons have spawned, it will create a new weapon bag. It has a 50% chance of spawning a powerup (if enabled) or a new weapon.
// Thunderbolts can't be spawned in liquid surfaces (if it's the only weapon left to spawn, it will spawn a powerup (if enabled) instead.
// In any moment, there's a 5% chance of a Powerup spawning (if enabled) instead of a weapon.
void() ConvertToWeaponBiased = {
    local float rng;
    if(SpawnedWeapons & IT_SUPER_SHOTGUN && 
        SpawnedWeapons & IT_NAILGUN && 
        SpawnedWeapons & IT_SUPER_NAILGUN && 
        SpawnedWeapons & IT_GRENADE_LAUNCHER && 
        SpawnedWeapons & IT_ROCKET_LAUNCHER && 
        SpawnedWeapons & IT_LIGHTNING)
    {
        rng = Random(1, 100);
        if(RandomizePowerups && rng <= 50)
            self.think = ConvertToPowerupBiased;
        else
        {
            SpawnedWeapons = 0;
            CreateWeaponPermutation();
            self.think = ConvertToWeaponBiased;
        }
        self.nextthink = time;
        return;
    }
    rng = Random(1, 100);
    if(RandomizePowerups && rng >= 95)
    {    
        self.think = ConvertToPowerupBiased;
        self.nextthink = time;
        return;
    }
    local float i, currentSurface, isValidSurface;
    local void() Converters[] = { ConvertToDoubleBarrelledShotgun, ConvertToNailgun, ConvertToSuperNailgun, ConvertToGrenadeLauncher, ConvertToRocketLauncher, ConvertToThunderbolt };
    local float PickupTypes[] = { IT_SUPER_SHOTGUN, IT_NAILGUN, IT_SUPER_NAILGUN, IT_GRENADE_LAUNCHER, IT_ROCKET_LAUNCHER, IT_LIGHTNING };
    local string Classnames[] = { "weapon_supershotgun", "weapon_nailgun", "weapon_supernailgun", "weapon_grenadelauncher", "weapon_rocketlauncher", "weapon_lightning" };
    local float WeaponPermutation[6];
    local void() ConvertersPermutation[6];
    for(i = 0; i < 6; i++)
    {
        ConvertersPermutation[i] = Converters[IndexPermutation[i]];
        WeaponPermutation[i] = PickupTypes[IndexPermutation[i]];
    }
    local float PickedWeapon;
    for(i = 0; i < 6; i++)
    {
        PickedWeapon = WeaponPermutation[i];
        if(PickedWeapon != IT_LIGHTNING)
            isValidSurface = 1;
        else
        {
            currentSurface = pointcontents(self.origin);
            isValidSurface = currentSurface != CONTENT_WATER && currentSurface != CONTENT_SLIME && currentSurface != CONTENT_LAVA;
        }
        if(!(SpawnedWeapons & PickedWeapon) && isValidSurface)
        {
            if(!IsNearOneOf(self, Classnames[i], string_null, string_null))
            {
                self.nextClassname = Classnames[i];
                if(!HideInBackpacks)
                    self.think = ConvertersPermutation[i];
                else
                {
                    self.PickupType = PickedWeapon;
                    self.think = ConvertToWeaponBackpack;
                }
                SpawnedWeapons = SpawnedWeapons | PickedWeapon;
                break;
            }
        }
    }
    if(i == 6) 
    {
        // If all weapons were rolled (or can't be spawned in the current location), it will instead spawn a powerup (if enabled; otherwise it restarts the bag).
        if(RandomizePowerups)
        {
            self.think = ConvertToPowerupBiased;
        }
        else
        {            
            SpawnedWeapons = 0;
            CreateWeaponPermutation();
            self.think = ConvertToWeaponBiased;
        }
        self.nextthink = time;
        return;
    }
    self.nextthink = time;
};