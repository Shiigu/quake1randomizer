void() Randomize;
void() ConvertEntities;
void(entity e) ConvertToMonster;
void(entity e) ConvertToMonsterOnGroundBiased;
void(entity e) ConvertToMonsterOnGroundUnbiased;
void(entity e) ConvertToMonsterOnWaterBiased;
void(entity e) ConvertToMonsterOnWaterUnbiased;
void(entity e) ConvertToPickupBiased;
void(entity e) ConvertToPickupUnbiased;
void(entity e) ConvertToAmmoBiased;
void(entity e) ConvertToAmmoUnbiased;
void(entity e) ConvertToPowerupBiased;
void(entity e) ConvertToPowerupUnbiased;
void(entity e) ConvertToWeaponBiased;
void(entity e) ConvertToWeaponUnbiased;

/* Entities will be converted to one of the same type:
    - "Monster" for Monsters
    - "Pickup" for Health (except for Mega) and Armor (except for Red)
    - "Ammo" for Ammunition (both small and big)
    - "Weapon" for Weapons
    - "Powerup" for Megahealth, Red Armor and Powerups */

entity Placeholder;

float SpawnedWeapons; // For Biased mode. Includes which weapons have been added.


void() Randomize = {
    RandomMode = cvar("savedgamecfg");
    UnbiasedMode = (RandomMode & RANDOM_UNBIASED_MODE) > 0;
    HideInBackpacks = (RandomMode & RANDOM_BACKPACK_MODE) > 0;
    SpawnedWeapons = 0;
    dprint("----- RANDOMIZER MOD -----\n");
    dprint("RandomMode is ");
    dprint(ftos(RandomMode));
    dprint(".\n");
    dprint("UnbiasedMode is ");
    dprint(ftos(UnbiasedMode));
    dprint(". ");
    if (UnbiasedMode)
    {
        dprint("Starting unbiased randomizer. Don't say I didn't warn you.\n");
    }
    dprint("HideInBackpacks is ");
    dprint(ftos(HideInBackpacks));
    dprint(". ");
    if(HideInBackpacks)
    {
        dprint("Backpack Mode is enabled. All weapons and ammo will be disguised as backpacks.\n");
    }
    Placeholder = spawn(); // Temporary entity to call the randomizer functions in order    
	Placeholder.think = ConvertEntities;
	Placeholder.nextthink = time;
};

void() ConvertEntities = {
    local entity temp;
    SpawnedWeapons = 0;	
	temp = find(world, Converted, "");

    dprint("----- Starting ConvertEntities -----\n");
	while (temp != world) // As long as it can find any entity that can be converted
	{
        if(temp.classname != "worldspawn")
        {
            if(temp.flags & FL_MONSTER)
            {
                dprint("Found ");
                dprint(temp.classname);
                dprint(". ");
                if(temp.classname == "monster_oldone" || temp.classname == "monster_boss" || (temp.classname == "monster_zombie" && temp.spawnflags & SPAWN_CRUCIFIED))
                {
                    temp.Converted = "1"; // Do NOT convert Chthon, Shub-Niggurath or a crucified Zombie
                    if(temp.classname == "monster_zombie" && temp.spawnflags & SPAWN_CRUCIFIED)
                    {
                        dprint("This Zombie is cruficied. ");
                    }
                    dprint("Didn't flag for Convert.\n");
                }
                else 
                {
                    temp.think = SUB_Null;
                    temp.oldsize = temp.size;
                    ConvertToMonster(temp);
                    dprint("Flagged as a monster.\n");
                }
            }
            else if(temp.flags & FL_ITEM)
            {
                dprint("Found ");
                dprint(temp.classname);
                dprint(". ");
                if(temp.classname == "item_key1" || temp.classname == "item_key2" || temp.classname == "item_sigil")
                {
                    temp.Converted = "1"; // Do NOT convert Keys or Runes
                    dprint("Didn't flag for Convert.\n");
                }
                else if(temp.classname == "item_armor1" || temp.classname == "item_armor2"
                || (temp.classname == "item_health" && !(temp.spawnflags & H_MEGA)))
                {
                    temp.think = SUB_Null;
                    temp.oldsize = temp.size;
                    if (!UnbiasedMode)
                    {
                        ConvertToPickupBiased(temp);
                    }
                    else
                    {
                        ConvertToPickupUnbiased(temp);
                    }
                    dprint("Flagged as a pickup.\n");
                }
                else if(temp.classname == "item_shells" || temp.classname == "item_spikes" || temp.classname == "item_rockets" || temp.classname == "item_cells")
                {
                    temp.think = SUB_Null;
                    temp.oldsize = temp.size;
                    if (!UnbiasedMode)
                    {
                        ConvertToAmmoBiased(temp);
                    }
                    else
                    {
                        ConvertToAmmoUnbiased(temp);
                    }
                    dprint("Flagged as ammo.\n");
                }
                else if(temp.classname == "item_armorInv" || (temp.classname == "item_health" && (temp.spawnflags & H_MEGA)) 
                || temp.classname == "item_artifact_invulnerability" || temp.classname == "item_artifact_envirosuit"
                || temp.classname == "item_artifact_invisibility" || temp.classname == "item_artifact_super_damage")
                {
                    temp.think = SUB_Null;
                    temp.oldsize = temp.size;
                    if (!UnbiasedMode)
                    {
                        ConvertToPowerupBiased(temp);
                    }
                    else
                    {
                        ConvertToPowerupUnbiased(temp);
                    }
                    dprint("Flagged as a powerup.\n");
                }
                else if(temp.classname == "weapon_supershotgun" || temp.classname == "weapon_nailgun"
                || temp.classname == "weapon_supernailgun" || temp.classname == "weapon_grenadelauncher"
                || temp.classname == "weapon_rocketlauncher" || temp.classname == "weapon_lightning")
                {
                    temp.think = SUB_Null;
                    temp.oldsize = temp.size;
                    if (!UnbiasedMode)
                    {
                        ConvertToWeaponBiased(temp);
                    }
                    else
                    {
                        ConvertToWeaponUnbiased(temp);
                    }
                    dprint("Flagged as a weapon.\n");
                }
            }
            else 
            {
                temp.Converted = "1"; // Do NOT convert Keys or Runes
            }
        }
		temp = find(temp, Converted, "");
	}
    remove(Placeholder);
    dprint("----- Finished ConvertEntities -----\n");
};

// Converts a monster from one type to another randomly.
// Chances are completely even
void(entity e) ConvertToMonster = {
    if(pointcontents(e.origin) != CONTENT_EMPTY)
    {
        if (!UnbiasedMode)
        {
            ConvertToMonsterOnWaterBiased(e);
        }
        else
        {
            ConvertToMonsterOnWaterUnbiased(e);
        }
    }
    else
    {
        if (!UnbiasedMode)
        {
            ConvertToMonsterOnGroundBiased(e);
        }
        else
        {
            ConvertToMonsterOnGroundUnbiased(e);
        }
    }
};

// To convert a monster present in ground. Prevents spawning Rotfish in ground.
// Every monster has an equal chance to be appear.
void(entity e) ConvertToMonsterOnGroundUnbiased = {
    local float rng;
    local void() Converters[] = { ConvertToFiend, ConvertToDog, ConvertToEnforcer, ConvertToDeathKnight, ConvertToKnight, 
                                ConvertToZombie, ConvertToVore, ConvertToShambler, ConvertToGrunt, ConvertToSpawn, ConvertToScrag, ConvertToOgre };
    rng = Random(1, 12);
    e.think = Converters[rng - 1];
    e.nextthink = time;
};

// To convert a monster present in water.
// Every monster has an equal chance to be appear.
void(entity e) ConvertToMonsterOnWaterUnbiased = {
    local float rng;
    local void() Converters[] = { ConvertToFiend, ConvertToDog, ConvertToEnforcer, ConvertToDeathKnight, ConvertToKnight, ConvertToZombie,
                                ConvertToVore, ConvertToShambler, ConvertToGrunt, ConvertToSpawn, ConvertToScrag, ConvertToOgre, ConvertToRotfish };
    rng = Random(1, 13);
    e.think = Converters[rng - 1];
    e.nextthink = time;
};

// To convert a monster present in ground. Prevents spawning Rotfish in ground.
// Monsters have an arbitrarily "fair" chance to appear.
void(entity e) ConvertToMonsterOnGroundBiased = {
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
            e.think = Converters[i];
        }
        i++;
    }
    e.nextthink = time;
};

// To convert a monster present in water.
// Monsters have an arbitrarily "fair" chance to appear. Dogs and Knights are not allowed to spawn in water (because they are melee-only, and thus useless there).
void(entity e) ConvertToMonsterOnWaterBiased = {
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
            e.think = Converters[i];
        }
        i++;
    }
    e.nextthink = time;
};

// Converts a pickup of one type to another randomly.
// Even chance for a non-Mega Health Pickup or a non-Red Armor Pickup.
void(entity e) ConvertToPickupUnbiased = {
    local float rngType, rngQuality;
    local void() Converters[] = { ConvertToHealth, ConvertToArmor };
    rngType = Random(1, 2);
    rngQuality = Random(1, 2);
    e.think = Converters[rngType - 1];
    e.QualityType = floor(rngQuality);
    e.nextthink = time;
};

// Converts a pickup of one type to another randomly.
// 90% chance of being a pickup of the type it already is (Health or Armor, but quality can change), 10% of becoming of the other type.
// If there are nearby sources of armor, it will spawn a health pack instead
void(entity e) ConvertToPickupBiased = {
    local float rngType, rngQuality;
    local float ProbabilityForSameType = 90;
    rngType = Random(1, 100);
    rngQuality = Random(1, 2);
    e.QualityType = rngQuality;
    if(e.classname == "item_health")
    {
        if(rngType >= 1 && rngType <= ProbabilityForSameType)
        { 
            e.think = ConvertToHealth;
        }
        else
        {
            e.think = ConvertToArmor;
        }
    }
    else if(e.classname == "item_armor1" || e.classname == "item_armor2")
    {
        if(rngType >= 1 && rngType <= ProbabilityForSameType)
        { 
            e.think = ConvertToArmor;
        }
        else
        {
            e.think = ConvertToHealth;
        }
    }
    e.nextthink = time;
};

// Converts ammo of one type to another randomly.
// Even chance for all ammo types and sizes
void(entity e) ConvertToAmmoUnbiased = {
    local float AmmoTypeRng, AmmoSizeRng;
    local void() Converters[] = { ConvertToShells, ConvertToNails, ConvertToRockets, ConvertToCells };
    local string AmmoNetNames[] = { "shells", "nails", "rockets", "cells" };
    AmmoTypeRng = Random(1, 4);
    AmmoSizeRng = Random(1, 2);
    e.QualityType = AmmoSizeRng;
    e.netname = AmmoNetNames[AmmoTypeRng - 1];
    if(!HideInBackpacks)
    {    
        e.think = Converters[AmmoTypeRng - 1];
    }
    else
    {
        e.PickupType = AmmoTypeRng;
        e.think = ConvertToAmmoBackpack;
    }
    e.nextthink = time;
};

// Converts ammo of one type to another randomly.
// 30% chance of being Shells, 30% chance of being Nails, 15% chance of being Rockets, 15% chance of being Cells, 10% chance of being any weapon (!)
// For ammo, 65% chance of being a small pack, 35% chance of being a big pack
void(entity e) ConvertToAmmoBiased = {
    local float AmmoTypeRng, AmmoSizeRng, AmmoPackSize, minrng, maxrng, DONE, i, amountOfChoices;
    local void() Converters[] = { ConvertToShells, ConvertToNails, ConvertToRockets, ConvertToCells };
    local string AmmoNetNames[] = { "shells", "nails", "rockets", "cells" };
    local float ProbabilityForSmallPack = 65;
    local float AmmoTypeProbabilities[] = { 30, 30, 15, 15 };
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
    while(!DONE && minrng < 100 && i < amountOfChoices)
    {
        minrng = maxrng + 1;
        maxrng = maxrng + AmmoTypeProbabilities[i];
        if(AmmoTypeRng >= minrng && AmmoTypeRng <= maxrng)
        {
            DONE = 1;
            e.QualityType = AmmoPackSize;
            e.netname = AmmoNetNames[i];
            if(!HideInBackpacks)
                e.think = Converters[i];
            else
            {
                e.PickupType = i + 1;
                e.think = ConvertToAmmoBackpack;
            }
        }
        i++;
    }
    if(!DONE)
    {
        ConvertToWeaponBiased(e);
        return;
    }
    e.nextthink = time;
};

// Converts a powerup of one type to another randomly.
// Equal chance for a Megahealth, Red Armor, Pentagram of Protection, Quad Damage, Ring of Shadows or Biosuit
void(entity e) ConvertToPowerupUnbiased = {
    local float rng;
    local void() Converters[] = { ConvertToPentagramOfProtection, ConvertToQuadDamage, ConvertToRingOfShadows, ConvertToHealth, ConvertToArmor, ConvertToBiosuit };
    rng = Random(1, 6);
    if(rng == 4 || rng == 5)
        e.QualityType = 3;
    e.think = Converters[rng - 1];
    e.nextthink = time;
};

// Used to FORCE a weapon to convert into any powerup, no strings attached.
// It can't become a Biosuit or a Red Armor. Even chances for everything.
void(entity e) ConvertToGuaranteedPowerup = {
    local float rng;
    rng = Random(1, 4);
    local void() Converters[] = { ConvertToPentagramOfProtection, ConvertToQuadDamage, ConvertToRingOfShadows, ConvertToHealth };
    if(rng == 4)
        e.QualityType = 3;
    e.think = Converters[rng - 1];
    e.nextthink = time;
};

// Converts a powerup of one type to another randomly.
// 18% chance of being either a Megahealth, Red Armor, Pentagram of Protection, Quad Damage or Ring of Shadows, 10% chance of being a Biosuit
// It spawns a weapon instead if it's trying to spawn in invalid conditions (Red Armor near another suit of armor, or Biosuit when there are no nearby liquid surfaces)
void(entity e) ConvertToPowerupBiased = {    
    local float rng, minrng, maxrng, DONE, i, amountOfChoices;
    local void() Converters[] = { ConvertToPentagramOfProtection, ConvertToQuadDamage, ConvertToRingOfShadows, ConvertToHealth, ConvertToArmor, ConvertToBiosuit };
    local float Probabilities[] = { 18, 18, 18, 18, 18, 10 };
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
            if(i == 3 || i == 4)
                e.QualityType = 3;
            if(i == 5)
            {
                if(!IsNearAWaterSurface(e))
                {
                    ConvertToWeaponBiased(e);
                    return;
                }
            }
            e.think = Converters[i];
        }
        i++;
    }
    e.nextthink = time;
};

// Converts a weapon of one type to another randomly.
// Chances are completely even, even in Biased mode.
void(entity e) ConvertToWeaponUnbiased = {
    local float rng;
    local void() Converters[] = { ConvertToDoubleBarrelledShotgun, ConvertToNailgun, ConvertToSuperNailgun, ConvertToGrenadeLauncher, ConvertToRocketLauncher, ConvertToThunderbolt };
    local float PickupTypes[] = { IT_SUPER_SHOTGUN, IT_NAILGUN, IT_SUPER_NAILGUN, IT_GRENADE_LAUNCHER, IT_ROCKET_LAUNCHER, IT_LIGHTNING };
    rng = Random(1, 6);
    if(!HideInBackpacks)
        e.think = Converters[rng - 1];
    else
    {
        e.PickupType = PickupTypes[rng - 1];
        e.think = ConvertToWeaponBackpack;
    }
    e.nextthink = time;
};

// Converts a weapon of one type to another randomly.
// Chances are completely even, even in Biased mode. However, in Biased mode, a weapon may not appear more than once if any of the other weapons hasn't appeared yet.
// If all weapons have spawned, it will instead spawn a powerup. Then it will allow weapons again.
// Thunderbolts can't be spawned in liquid surfaces.
void(entity e) ConvertToWeaponBiased = {
    if(SpawnedWeapons & IT_SUPER_SHOTGUN && 
        SpawnedWeapons & IT_NAILGUN && 
        SpawnedWeapons & IT_SUPER_NAILGUN && 
        SpawnedWeapons & IT_GRENADE_LAUNCHER && 
        SpawnedWeapons & IT_ROCKET_LAUNCHER && 
        SpawnedWeapons & IT_LIGHTNING)
    {
        ConvertToGuaranteedPowerup(e);
        SpawnedWeapons = 0;
        return;
    }
    local float rng, DONE, i, amountOfChoices, currentSurface, isValidSurface;
    local void() Converters[] = { ConvertToDoubleBarrelledShotgun, ConvertToNailgun, ConvertToSuperNailgun, ConvertToGrenadeLauncher, ConvertToRocketLauncher, ConvertToThunderbolt };
    local float PickupTypes[] = { IT_SUPER_SHOTGUN, IT_NAILGUN, IT_SUPER_NAILGUN, IT_GRENADE_LAUNCHER, IT_ROCKET_LAUNCHER, IT_LIGHTNING };
    local float PickedWeapon;
    amountOfChoices = PickupTypes.length;
    DONE = 0;
    rng = Random(1, 6);
    PickedWeapon = PickupTypes[rng - 1];
    if(PickedWeapon != IT_LIGHTNING)
        isValidSurface = 1;
    else
    {
        currentSurface = pointcontents(e.origin);
        isValidSurface = currentSurface != CONTENT_WATER && currentSurface != CONTENT_SLIME && currentSurface != CONTENT_LAVA;
    }
    if(!(SpawnedWeapons & PickedWeapon) && isValidSurface)
    {
        if(!HideInBackpacks)
            e.think = Converters[rng - 1];
        else
        {
            e.PickupType = PickedWeapon;
            e.think = ConvertToWeaponBackpack;
        }
        SpawnedWeapons = SpawnedWeapons | PickedWeapon;
    }
    else
    {
        // If it rolled an already-spawned weapon (or tried to spawn a Thunderbolt in a liquid), it will instead spawn the lowest-ranked weapon not yet present.
        for(i = 0; i < amountOfChoices && !DONE; i++)
        {
            PickedWeapon = PickupTypes[i];
            if(PickedWeapon != IT_LIGHTNING)
                isValidSurface = 1;
            else
            {
                currentSurface = pointcontents(e.origin);
                isValidSurface = currentSurface != CONTENT_WATER && currentSurface != CONTENT_SLIME && currentSurface != CONTENT_LAVA;
            }
            if(!(SpawnedWeapons & PickedWeapon) && isValidSurface)
            {
                DONE = 1;
                if(!HideInBackpacks)
                    e.think = Converters[i];
                else
                {
                    e.PickupType = PickedWeapon;
                    e.think = ConvertToWeaponBackpack;
                }
                SpawnedWeapons = SpawnedWeapons | PickedWeapon;
            }
        }
        if(!DONE) 
        {
            // If all weapons were rolled (or yet again tried to spawn a Thunderbolt in water), it will instead spawn a powerup.
            ConvertToGuaranteedPowerup(e);
            return;
        }
    }
    e.nextthink = time;
};