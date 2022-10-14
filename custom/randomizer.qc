void() Randomize;
void() FlagEntities;
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

.string EntityType; 
    /* Entities will be converted to one of the same type:
       - "Monster" for Monsters
       - "Pickup" for Health (except for Mega) and Armor (except for Red)
       - "Ammo" for Ammunition (both small and big)
       - "Weapon" for Weapons
       - "Powerup" for Megahealth, Red Armor and Powerups */

entity Placeholder;
float RandomMode; // 1 (default) will be a biased mode to give the player a fairly fair fight. 2 will give every monster and item the same chance to show up.
                  // Same value as gamecfg cvar.

float SpawnedWeapons; // For Biased mode. Includes which weapons have been added.
float HideInBackpacks; // If TRUE, all Weapons and Ammo are "hidden" as backpacks.

void() Randomize = {
    RandomMode = cvar("gamecfg");
    HideInBackpacks = cvar("scratch1");
    SpawnedWeapons = 0;
    dprint("----- RANDOMIZER MOD -----\n");
    dprint("RandomMode is ");
    dprint(ftos(RandomMode));
    dprint(". ");
    if (RandomMode == 0)
    {
        dprint("Starting biased randomizer.\n");
    }
    else if (RandomMode == 1)
    {
        dprint("Starting unbiased randomizer. Don't say I didn't warn you.\n");
    }
    else if (RandomMode < 0 || RandomMode > 1)
    {
        dprint("Mode is invalid. Must be 0 or 1. Cancelling randomizing.\n");
        return;
    }
    if(HideInBackpacks)
    {
        dprint("scratch1 is 1. All weapons and ammo will be disguised as backpacks.\n");
    }
    Placeholder = spawn(); // Temporary entity to call the randomizer functions in order    
	Placeholder.think = FlagEntities;
	Placeholder.nextthink = time;
};

void() FlagEntities = {
    local entity temp;
	
	temp = find(world, Converted, "");

    dprint("----- Starting FlagEntities -----\n");
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
                    temp.EntityType = "Monster";
                    temp.Converted = "0";
                    dprint("Flagged as Monster.\n");
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
                    temp.EntityType = "Pickup";
                    temp.Converted = "0";
                    dprint("Flagged as Pickup.\n");
                }
                else if(temp.classname == "item_shells" || temp.classname == "item_spikes" || temp.classname == "item_rockets" || temp.classname == "item_cells")
                {
                    temp.EntityType = "Ammo";
                    temp.Converted = "0";
                    dprint("Flagged as Ammo.\n");
                }
                else if(temp.classname == "item_armorInv" || (temp.classname == "item_health" && (temp.spawnflags & H_MEGA)) 
                || temp.classname == "item_artifact_invulnerability" || temp.classname == "item_artifact_envirosuit"
                || temp.classname == "item_artifact_invisibility" || temp.classname == "item_artifact_super_damage")
                {
                    temp.EntityType = "Powerup";
                    temp.Converted = "0";
                    dprint("Flagged as Powerup.\n");
                }
                else if(temp.classname == "weapon_supershotgun" || temp.classname == "weapon_nailgun"
                || temp.classname == "weapon_supernailgun" || temp.classname == "weapon_grenadelauncher"
                || temp.classname == "weapon_rocketlauncher" || temp.classname == "weapon_lightning")
                {
                    temp.EntityType = "Weapon";
                    temp.Converted = "0";
                    dprint("Flagged as Weapon.\n");
                }
            }
            else 
            {
                temp.Converted = "1"; // Do NOT convert Keys or Runes
            }
        }
		temp = find(temp, Converted, "");
	}
    Placeholder.think = ConvertEntities;
    Placeholder.nextthink = time + 0.1;
    dprint("----- Finished FlagEntities -----\n");
};

// Converts entities to one of the same type.
void() ConvertEntities = {
    local entity temp;
    local vector oldsize, neworigin;
	
	temp = find(world, Converted, "0");

    dprint("----- Starting ConvertEntities -----\n");
	while (temp != world) // As long as it can find any entity that can be converted
	{
        dprint("Converted ");
        dprint(temp.classname);
        dprint(" to: ");
        if(temp.classname != "worldspawn")
        {
            oldsize = temp.size;
            if(temp.EntityType == "Monster")
            {
                ConvertToMonster(temp);
            }
            else if(temp.EntityType == "Pickup")
            {
                if (RandomMode == 0)
                {
                    ConvertToPickupBiased(temp);
                }
                else if (RandomMode == 1)
                {
                    ConvertToPickupUnbiased(temp);
                }
            }
            else if(temp.EntityType == "Ammo")
            {
                if (RandomMode == 0)
                {
                    ConvertToAmmoBiased(temp);
                }
                else if (RandomMode == 1)
                {
                    ConvertToAmmoUnbiased(temp);
                }
            }
            else if(temp.EntityType == "Powerup")
            {
                if (RandomMode == 0)
                {
                    ConvertToPowerupBiased(temp);
                }
                else if (RandomMode == 1)
                {
                    ConvertToPowerupUnbiased(temp);
                }
            }
            else if(temp.EntityType == "Weapon")
            {
                if (RandomMode == 0)
                {
                    ConvertToWeaponBiased(temp);
                }
                else if (RandomMode == 1)
                {
                    ConvertToWeaponUnbiased(temp);
                }
            }
            else {
                temp.Converted = "1"; // Just in case something that shouldn't have been flagged was actually flagged.
            }
            if((temp.flags & FL_ITEM) && oldsize_z < temp.size_z)
            {
                // If an item was converted into a taller one (e.g. Ammo to weapon, or between powerups)...
                // ... move it a bit higher to not instantly flag it as stuck. Turning into a smaller item is fair game though.
                neworigin = temp.origin;
                neworigin_z = neworigin_z + fabs(temp.size_z - oldsize_z);
                temp.origin = neworigin;
            }
        }
		temp = find(temp, Converted, "0");
	}
    remove(Placeholder);
    dprint("----- Finished ConvertEntities -----\n");
};

// Converts a monster from one type to another randomly.
// Chances are completely even
void(entity e) ConvertToMonster = {
    if(pointcontents(e.origin) != CONTENT_EMPTY)
    {
        if (RandomMode == 0)
        {
            ConvertToMonsterOnWaterBiased(e);
        }
        else if (RandomMode == 1)
        {
            ConvertToMonsterOnWaterUnbiased(e);
        }
    }
    else
    {
        if (RandomMode == 0)
        {
            ConvertToMonsterOnGroundBiased(e);
        }
        else if (RandomMode == 1)
        {
            ConvertToMonsterOnGroundUnbiased(e);
        }
        if(e.classname != "monster_wizard") // if Monster isn't a Scrag, drop it to the ground.
        {
            e.velocity_z = 100 + 100*random();
            e.flags = e.flags - (e.flags & FL_ONGROUND);
        }
    }
    e.Converted = "1";
    dprint(e.classname);
    dprint("\n");
};

// To convert a monster present in ground. Prevents spawning Rotfish in ground.
// Every monster has an equal chance to be appear.
void(entity e) ConvertToMonsterOnGroundUnbiased = {
    local float rng;
    rng = Random(1, 12);
    if(rng == 1)
    { 
        ConvertToFiend(e);
    }
    else if(rng == 2)
    { 
        ConvertToDog(e);
    }
    else if(rng == 3)
    { 
        ConvertToEnforcer(e);
    }
    else if(rng == 4)
    { 
        ConvertToDeathKnight(e);
    }
    else if(rng == 5)
    { 
        ConvertToKnight(e);
    }
    else if(rng == 6)
    { 
        ConvertToZombie(e);
    }
    else if(rng == 7)
    { 
        ConvertToVore(e);
    }
    else if(rng == 8)
    { 
        ConvertToShambler(e);
    }
    else if(rng == 9)
    { 
        ConvertToGrunt(e);
    }
    else if(rng == 10)
    { 
        ConvertToSpawn(e);
    }
    else if(rng == 11)
    { 
        ConvertToScrag(e);
    }
    else if(rng == 12)
    { 
        ConvertToOgre(e);
    }
};

// To convert a monster present in water.
// Every monster has an equal chance to be appear.
void(entity e) ConvertToMonsterOnWaterUnbiased = {
    local float rng;
    rng = Random(1, 13);
    if(rng == 1)
    { 
        ConvertToFiend(e);
    }
    else if(rng == 2)
    { 
        ConvertToDog(e);
    }
    else if(rng == 3)
    { 
        ConvertToEnforcer(e);
    }
    else if(rng == 4)
    { 
        ConvertToDeathKnight(e);
    }
    else if(rng == 5)
    { 
        ConvertToKnight(e);
    }
    else if(rng == 6)
    { 
        ConvertToZombie(e);
    }
    else if(rng == 7)
    { 
        ConvertToVore(e);
    }
    else if(rng == 8)
    {
        ConvertToShambler(e);
    }
    else if(rng == 9)
    { 
        ConvertToGrunt(e);
    }
    else if(rng == 10)
    { 
        ConvertToSpawn(e);
    }
    else if(rng == 11)
    { 
        ConvertToScrag(e);
    }
    else if(rng == 12)
    { 
        ConvertToOgre(e);
    }
    else if(rng == 13)
    { 
        ConvertToRotfish(e);
    }
};

// To convert a monster present in ground. Prevents spawning Rotfish in ground.
// Monsters have an arbitrarily "fair" chance to appear.
void(entity e) ConvertToMonsterOnGroundBiased = {
    local float rng;
    rng = Random(1, 100);
    if(rng >= 1 && rng <= 7)
    { 
        ConvertToFiend(e);
    }
    else if(rng >= 8 && rng <= 14)
    { 
        ConvertToDog(e);
    }
    else if(rng >= 15 && rng <= 23)
    { 
        ConvertToEnforcer(e);
    }
    else if(rng >= 24 && rng <= 33)
    { 
        ConvertToDeathKnight(e);
    }
    else if(rng >= 34 && rng <= 45)
    { 
        ConvertToKnight(e);
    }
    else if(rng >= 46 && rng <= 54)
    { 
        ConvertToZombie(e);
    }
    else if(rng >= 55 && rng <= 57)
    { 
        ConvertToVore(e);
    }
    else if(rng >= 58 && rng <= 59)
    { 
        ConvertToShambler(e);
    }
    else if(rng >= 60 && rng <= 72)
    { 
        ConvertToGrunt(e);
    }
    else if(rng >= 73 && rng <= 75)
    {
        ConvertToSpawn(e);
    }
    else if(rng >= 76 && rng <= 87)
    { 
        ConvertToScrag(e);
    }
    else if(rng >= 88 && rng <= 100)
    { 
        ConvertToOgre(e);
    }
};

// To convert a monster present in water.
// Monsters have an arbitrarily "fair" chance to appear. Dogs and Knights are not allowed to spawn in water (because they are melee-only, and thus useless there).
void(entity e) ConvertToMonsterOnWaterBiased = {
    local float rng;
    rng = Random(1, 100);
    if(rng >= 1 && rng <= 6)
    { 
        ConvertToFiend(e);
    }
    else if(rng >= 7 && rng <= 18)
    { 
        ConvertToEnforcer(e);
    }
    else if(rng >= 19 && rng <= 30)
    { 
        ConvertToDeathKnight(e);
    }
    else if(rng >= 31 && rng <= 41)
    { 
        ConvertToZombie(e);
    }
    else if(rng >= 42 && rng <= 44)
    { 
        ConvertToVore(e);
    }
    else if(rng >= 45 && rng <= 46)
    { 
        ConvertToShambler(e);
    }
    else if(rng >= 47 && rng <= 59)
    { 
        ConvertToGrunt(e);
    }
    else if(rng >= 60 && rng <= 62)
    { 
        ConvertToSpawn(e);
    }
    else if(rng >= 63 && rng <= 75)
    { 
        ConvertToScrag(e);
    }
    else if(rng >= 76 && rng <= 84)
    { 
        ConvertToOgre(e);
    }
    else if(rng >= 85 && rng <= 100)
    { 
        ConvertToRotfish(e);
    }
};

// Converts a pickup of one type to another randomly.
// Even chance for a non-Mega Health Pickup or a non-Red Armor Pickup.
void(entity e) ConvertToPickupUnbiased = {
    local float rng;
    rng = Random(1, 4);
    if(rng == 1)
    { 
        ConvertToHealth(e, 1);
        dprint(e.classname);
        dprint(" (15)\n");
    }
    else if(rng == 2)
    { 
        ConvertToHealth(e, 2);
        dprint(e.classname);
        dprint(" (25)\n");
    }
    else if(rng == 3)
    { 
        ConvertToArmor(e, 0);
        dprint(e.classname);
        dprint("\n");
    }
    else if(rng == 4)
    { 
        ConvertToArmor(e, 1);
        dprint(e.classname);
        dprint("\n");
    }
    e.Converted = "1";
};

// Converts a pickup of one type to another randomly.
// 90% chance of being a pickup of the type it already is (Health or Armor, but quality can change), 10% of becoming of the other type.
// If there are nearby sources of armor, it will spawn a health pack instead
void(entity e) ConvertToPickupBiased = {
    local float rng;
    rng = Random(1, 100);
    if(e.classname == "item_health")
    {
        if(rng >= 1 && rng <= 45)
        { 
            ConvertToHealth(e, 1);
            dprint(e.classname);
            dprint(" (15)\n");
        }
        else if(rng >= 46 && rng <= 90)
        { 
            ConvertToHealth(e, 2);
            dprint(e.classname);
            dprint(" (25)\n");
        }
        else if(rng >= 91 && rng <= 95)
        { 
            if(!IsNearOtherArmor(e))
            {
                ConvertToArmor(e, 0);
                dprint(e.classname);
                dprint("\n");
            }
            else
            {
                ConvertToHealth(e, 1);
                dprint(e.classname);
                dprint(" (15)\n");
            }
        }
        else if(rng >= 96 && rng <= 100)
        { 
            if(!IsNearOtherArmor(e))
            {
                ConvertToArmor(e, 1);
                dprint(e.classname);
                dprint("\n");
            }
            else
            {
                ConvertToHealth(e, 2);
                dprint(e.classname);
                dprint(" (25)\n");
            }
        }
    }
    else if(e.classname == "item_armor1" || e.classname == "item_armor2")
    {
        if(rng >= 1 && rng <= 5)
        { 
            ConvertToHealth(e, 1);
            dprint(e.classname);
            dprint(" (15)\n");
        }
        else if(rng >= 6 && rng <= 10)
        { 
            ConvertToHealth(e, 2);
            dprint(e.classname);
            dprint(" (25)\n");
        }
        else if(rng >= 11 && rng <= 55)
        { 
            if(!IsNearOtherArmor(e))
            {
                ConvertToArmor(e, 0);
                dprint(e.classname);
                dprint("\n");
            }
            else
            {
                ConvertToHealth(e, 1);
                dprint(e.classname);
                dprint(" (15)\n");
            }
        }
        else if(rng >= 56 && rng <= 100)
        { 
            if(!IsNearOtherArmor(e))
            {
                ConvertToArmor(e, 1);
                dprint(e.classname);
                dprint("\n");
            }
            else
            {
                ConvertToHealth(e, 2);
                dprint(e.classname);
                dprint(" (25)\n");
            }
        }
    }
    e.Converted = "1";
};

// Converts ammo of one type to another randomly.
// Even chance for all ammo types and sizes
void(entity e) ConvertToAmmoUnbiased = {
    local float AmmoTypeRng;
    local float AmmoSizeRng;
    AmmoTypeRng = Random(1, 4);
    AmmoSizeRng = Random(1, 2);
    if(!HideInBackpacks)
    {
        if(AmmoTypeRng == 1)
        {
            ConvertToShells(e, AmmoSizeRng);
        }
        else if(AmmoTypeRng == 2)
        { 
            ConvertToNails(e, AmmoSizeRng);
        }
        else if(AmmoTypeRng == 3)
        { 
            ConvertToRockets(e, AmmoSizeRng);
        }
        else if(AmmoTypeRng == 4)
        { 
            ConvertToCells(e, AmmoSizeRng);
        }
    }
    else
    {
        ConvertToAmmoBackpack(e, AmmoTypeRng, AmmoSizeRng);
    }
    dprint(e.classname);
    if(AmmoSizeRng == 1)
    {
        dprint(" (BIG)");
    }
    else if(AmmoSizeRng == 2)
    {
        dprint(" (SMALL)");
    }
    else
    {
        dprint(" (INVALID AMMO SIZE TYPE OF ");
        dprint(ftos(AmmoSizeRng));
        dprint(")");
    }
    dprint("\n");
    e.Converted = "1";
};

// Converts ammo of one type to another randomly.
// 30% chance of being Shells, 30% chance of being Nails, 15% chance of being Rockets, 15% chance of being Cells, 10% chance of being any weapon (!)
// For ammo, 65% chance of being a small pack, 35% chance of being a big pack
void(entity e) ConvertToAmmoBiased = {
    local float AmmoTypeRng;
    local float AmmoSizeRng;
    local float AmmoPackSize;
    AmmoTypeRng = Random(1, 100);
    AmmoSizeRng = Random(1, 100);
    if(AmmoSizeRng >= 1 && AmmoSizeRng <= 65)
    {
        AmmoPackSize = 2;
    }
    else if (AmmoSizeRng >= 66 && AmmoSizeRng <= 100)
    {
        AmmoPackSize = 1;
    }
    if(AmmoTypeRng >= 1 && AmmoTypeRng <= 30)
    {
        if(!HideInBackpacks)
            ConvertToShells(e, AmmoPackSize);
        else
            ConvertToAmmoBackpack(e, 1, AmmoPackSize);
    }
    else if(AmmoTypeRng >= 31 && AmmoTypeRng <= 60)
    { 
        if(!HideInBackpacks)
            ConvertToNails(e, AmmoPackSize);
        else
            ConvertToAmmoBackpack(e, 2, AmmoPackSize);
    }
    else if(AmmoTypeRng >= 61 && AmmoTypeRng <= 75)
    { 
        if(!HideInBackpacks)
            ConvertToRockets(e, AmmoPackSize);
        else
            ConvertToAmmoBackpack(e, 3, AmmoPackSize);
    }
    else if(AmmoTypeRng >= 76 && AmmoTypeRng <= 90)
    { 
        if(!HideInBackpacks)
            ConvertToCells(e, AmmoPackSize);
        else
            ConvertToAmmoBackpack(e, 4, AmmoPackSize);
    }
    else if(AmmoTypeRng >= 91 && AmmoTypeRng <= 100)
    {
        dprint("(WEAPON!) ");
        ConvertToWeaponBiased(e);
        return;
    }
    dprint(e.classname);
    if(AmmoPackSize == 1)
    {
        dprint(" (BIG)");
    }
    else if(AmmoPackSize == 2)
    {
        dprint(" (SMALL)");
    }
    dprint("\n");
    e.Converted = "1";
};

// Converts a powerup of one type to another randomly.
// Equal chance for a Megahealth, Red Armor, Pentagram of Protection, Quad Damage, Ring of Shadows or Biosuit
void(entity e) ConvertToPowerupUnbiased = {
    local float rng;
    rng = Random(1, 6);
    if(rng == 1)
    { 
        ConvertToPentagramOfProtection(e);
        dprint(e.classname);
        dprint("\n");
    }
    else if(rng == 2)
    { 
        ConvertToQuadDamage(e);
        dprint(e.classname);
        dprint("\n");
    }
    else if(rng == 3)
    { 
        ConvertToRingOfShadows(e);
        dprint(e.classname);
        dprint("\n");
    }
    else if(rng == 4)
    { 
        ConvertToHealth(e, 3);
        dprint(e.classname);
        dprint(" (100)\n");
    }
    else if(rng == 5)
    { 
        ConvertToArmor(e, 2);
        dprint(e.classname);
        dprint("\n");
    }
    else if(rng == 6)
    { 
        ConvertToBiosuit(e);
        dprint(e.classname);
        dprint("\n");
    }
    e.Converted = "1";
};

// Used to FORCE a weapon to convert into any powerup, no strings attached.
// It can't become a Biosuit or a Red Armor. Even chances for everything.
void(entity e) ConvertToGuaranteedPowerup = {
    local float rng;
    rng = Random(1, 4);
    if(rng == 1)
    { 
        ConvertToPentagramOfProtection(e);
        dprint(e.classname);
        dprint("\n");
    }
    else if(rng == 2)
    { 
        ConvertToQuadDamage(e);
        dprint(e.classname);
        dprint("\n");
    }
    else if(rng == 3)
    { 
        ConvertToRingOfShadows(e);
        dprint(e.classname);
        dprint("\n");
    }
    else if(rng == 4)
    { 
        ConvertToHealth(e, 3);
        dprint(e.classname);
        dprint(" (100)\n");
    }
    e.Converted = "1";
};

// Converts a powerup of one type to another randomly.
// 18% chance of being either a Megahealth, Red Armor, Pentagram of Protection, Quad Damage or Ring of Shadows, 10% chance of being a Biosuit
// It spawns a weapon instead if it's trying to spawn in invalid conditions (Red Armor near another suit of armor, or Biosuit when there are no nearby liquid surfaces)
void(entity e) ConvertToPowerupBiased = {
    local float rng;
    rng = Random(1, 100);
    if(rng >= 1 && rng <= 18)
    { 
        ConvertToPentagramOfProtection(e);
        dprint(e.classname);
        dprint("\n");
    }
    else if(rng >= 19 && rng <= 36)
    { 
        ConvertToQuadDamage(e);
        dprint(e.classname);
        dprint("\n");
    }
    else if(rng >= 37 && rng <= 54)
    { 
        ConvertToRingOfShadows(e);
        dprint(e.classname);
        dprint("\n");
    }
    else if(rng >= 55 && rng <= 72)
    { 
        ConvertToHealth(e, 3);
        dprint(e.classname);
        dprint(" (100)\n");
    }
    else if(rng >= 73 && rng <= 90)
    {
        if(!IsNearOtherArmor(e))
        {
            ConvertToArmor(e, 2);
            dprint(e.classname);
            dprint("\n");
        }
        else
        {
            dprint(" (WEAPON!) ");
            ConvertToWeaponBiased(e);
        }
    }
    else if(rng >= 91 && rng <= 100)
    {
        if(IsNearAWaterSurface(e))
        { 
            dprint(" (WATER!) ");
            ConvertToBiosuit(e);
            dprint(e.classname);
            dprint("\n");
        }
        else
        {
            dprint(" (WEAPON!) ");
            ConvertToWeaponBiased(e);
        }
    }
    e.Converted = "1";
};

// Converts a weapon of one type to another randomly.
// Chances are completely even, even in Biased mode.
void(entity e) ConvertToWeaponUnbiased = {
    local float rng;
    rng = Random(1, 6);
    if(rng == 1)
    { 
        if(!HideInBackpacks)
            ConvertToDoubleBarrelledShotgun(e);
        else
            ConvertToWeaponBackpack(e, IT_SUPER_SHOTGUN);
    }
    else if(rng == 2)
    { 
        if(!HideInBackpacks)
            ConvertToNailgun(e);
        else
            ConvertToWeaponBackpack(e, IT_NAILGUN);
    }
    else if(rng == 3)
    { 
        if(!HideInBackpacks)
            ConvertToSuperNailgun(e);
        else
            ConvertToWeaponBackpack(e, IT_SUPER_NAILGUN);
    }
    else if(rng == 4)
    { 
        if(!HideInBackpacks)
            ConvertToGrenadeLauncher(e);
        else
            ConvertToWeaponBackpack(e, IT_GRENADE_LAUNCHER);
    }
    else if(rng == 5)
    { 
        if(!HideInBackpacks)
            ConvertToRocketLauncher(e);
        else
            ConvertToWeaponBackpack(e, IT_ROCKET_LAUNCHER);
    }
    else if(rng == 6)
    { 
        if(!HideInBackpacks)
            ConvertToThunderbolt(e);
        else
            ConvertToWeaponBackpack(e, IT_LIGHTNING);
    }
    dprint(e.classname);
    dprint("\n");
    e.Converted = "1";
};

// Converts a weapon of one type to another randomly.
// Chances are completely even, even in Biased mode. However, in Biased mode, a weapon may not appear more than once.
// If all weapons have spawned, it will instead spawn a powerup. Then it will allow weapons again.
void(entity e) ConvertToWeaponBiased = {
    local float rng;
    if(SpawnedWeapons & IT_SUPER_SHOTGUN && 
        SpawnedWeapons & IT_NAILGUN && 
        SpawnedWeapons & IT_SUPER_NAILGUN && 
        SpawnedWeapons & IT_GRENADE_LAUNCHER && 
        SpawnedWeapons & IT_ROCKET_LAUNCHER && 
        SpawnedWeapons & IT_LIGHTNING)
    {
        dprint("(NOT A WEAPON) ");
        ConvertToGuaranteedPowerup(e);
        SpawnedWeapons = 0;
        return;
    }
    rng = Random(1, 6);
    if(rng == 1 && !(SpawnedWeapons & IT_SUPER_SHOTGUN))
    {
        if(!HideInBackpacks)
            ConvertToDoubleBarrelledShotgun(e);
        else
            ConvertToWeaponBackpack(e, IT_SUPER_SHOTGUN);
        SpawnedWeapons = SpawnedWeapons | IT_SUPER_SHOTGUN;
    }
    else if(rng == 2 && !(SpawnedWeapons & IT_NAILGUN))
    { 
        if(!HideInBackpacks)
            ConvertToNailgun(e);
        else
            ConvertToWeaponBackpack(e, IT_NAILGUN);
        SpawnedWeapons = SpawnedWeapons | IT_NAILGUN;
    }
    else if(rng == 3 && !(SpawnedWeapons & IT_SUPER_NAILGUN))
    { 
        if(!HideInBackpacks)
            ConvertToSuperNailgun(e);
        else
            ConvertToWeaponBackpack(e, IT_SUPER_NAILGUN);
        SpawnedWeapons = SpawnedWeapons | IT_SUPER_NAILGUN;
    }
    else if(rng == 4 && !(SpawnedWeapons & IT_GRENADE_LAUNCHER))
    { 
        if(!HideInBackpacks)
            ConvertToGrenadeLauncher(e);
        else
            ConvertToWeaponBackpack(e, IT_GRENADE_LAUNCHER);
        SpawnedWeapons = SpawnedWeapons | IT_GRENADE_LAUNCHER;
    }
    else if(rng == 5 && !(SpawnedWeapons & IT_ROCKET_LAUNCHER))
    { 
        if(!HideInBackpacks)
            ConvertToRocketLauncher(e);
        else
            ConvertToWeaponBackpack(e, IT_ROCKET_LAUNCHER);
        SpawnedWeapons = SpawnedWeapons | IT_ROCKET_LAUNCHER;
    }
    else if(rng == 6 && !(SpawnedWeapons & IT_LIGHTNING) && pointcontents(e.origin) == CONTENT_EMPTY)
    { 
        if(!HideInBackpacks)
            ConvertToThunderbolt(e);
        else
            ConvertToWeaponBackpack(e, IT_LIGHTNING);
        SpawnedWeapons = SpawnedWeapons | IT_LIGHTNING;
    }
    else
    {
        // If it rolled an already-spawned weapon (or tried to spawn a Thunderbolt in water), it will instead spawn the lowest-ranked weapon not yet present.
        dprint("(DEFAULT) ");
        if (!(SpawnedWeapons & IT_SUPER_SHOTGUN))
        {
            if(!HideInBackpacks)
                ConvertToDoubleBarrelledShotgun(e);
            else
                ConvertToWeaponBackpack(e, IT_SUPER_SHOTGUN);
            SpawnedWeapons = SpawnedWeapons | IT_SUPER_SHOTGUN;
        }
        else if (!(SpawnedWeapons & IT_NAILGUN))
        {
            if(!HideInBackpacks)
                ConvertToNailgun(e);
            else
                ConvertToWeaponBackpack(e, IT_NAILGUN);
            SpawnedWeapons = SpawnedWeapons | IT_NAILGUN;
        }
        else if (!(SpawnedWeapons & IT_SUPER_NAILGUN))
        {
            if(!HideInBackpacks)
                ConvertToSuperNailgun(e);
            else
                ConvertToWeaponBackpack(e, IT_SUPER_NAILGUN);
            SpawnedWeapons = SpawnedWeapons | IT_SUPER_NAILGUN;
        }
        else if (!(SpawnedWeapons & IT_GRENADE_LAUNCHER))
        {        
            if(!HideInBackpacks)
                ConvertToGrenadeLauncher(e);
            else
                ConvertToWeaponBackpack(e, IT_GRENADE_LAUNCHER);
            SpawnedWeapons = SpawnedWeapons | IT_GRENADE_LAUNCHER;
        }
        else if (!(SpawnedWeapons & IT_ROCKET_LAUNCHER))
        {
            if(!HideInBackpacks)
                ConvertToRocketLauncher(e);
            else
                ConvertToWeaponBackpack(e, IT_ROCKET_LAUNCHER);
            SpawnedWeapons = SpawnedWeapons | IT_ROCKET_LAUNCHER;
        }
        else if (!(SpawnedWeapons & IT_LIGHTNING) && pointcontents(e.origin) == CONTENT_EMPTY)
        {
            if(!HideInBackpacks)
                ConvertToThunderbolt(e);
            else
                ConvertToWeaponBackpack(e, IT_LIGHTNING);
            SpawnedWeapons = SpawnedWeapons | IT_LIGHTNING;
        }
        else 
        {
            // If all weapons were rolled (or yet again tried to spawn a Thunderbolt in water), it will instead spawn a powerup.
            dprint("(NOT A WEAPON) ");
            ConvertToGuaranteedPowerup(e);
            return;
        }
    }
    dprint(e.classname);
    dprint("\n");
    e.Converted = "1";
};