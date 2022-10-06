# quake1randomizer

This mod (compatible with both the classic and remastered releases of Quake 1) has a very simple task: replace ALL the monsters and objects in a level with another of the same type. That first Grunt you encounter in E1M1? Now it could be an Enforcer, a Knight... or maybe a Shambler!

## Item categories

For conversion, all items are split into five categories. Save for some exceptions in Biased Mode, all convertible entities can only be replaced with one of the same type:

- Monsters: Includes all monsters with the exception of Chthon, Shub-Niggurath and cruficied Zombies.
- Pickup: Includes Health Packs (15 and 25 Health) and Armor Suits (Green and Yellow).
- Ammo: Includes all Ammo Crates.
- Powerup: Includes all Powerups, as well as 100 Health Packs and Red Armor Suits.
- Weapon: Includes all Weapons.

## Modes

### Biased Mode ("gamecfg" cvar is "0")

This is the default mode. Here, the game will try to be fair (keyword being 'try') to avoid spawning too many of the most powerful enemies. It can still accidentally spawn too many Shamblers or Vores, or simply not give you enough ammo for the weapons you have, but you can always restart...

#### Monster replacement chances on Biased Mode

- For Monsters in the ground or air:

|Name|Odds|
|----|----|
|Fiend|7%|
|Rottweiler|7%|
|Enforcer|9%|
|Hell Knight|10%|
|Knight|12%|
|Zombie|9%|
|Vore|3%|
|Shambler|2%|
|Grunt|13%|
|Spawn|3%|
|Scrag|12%|
|Ogre|13%|

> Rotfish aren't allowed to spawn outside of water surfaces because they can't move there.

- For Monsters in the water:

|Name|Odds|
|----|----|
|Fiend|6%|
|Enforcer|12%|
|Hell Knight|12%|
|Zombie|11%|
|Vore|3%|
|Shambler|2%|
|Grunt|13%|
|Spawn|3%|
|Scrag|12%|
|Ogre|9%|
|Rotfish|15%|

> Rottweilers and Knights aren't allowed to spawn inside water surfaces because their attacks are almost completely useless there.

#### Pickup replacement chances on Biased Mode

|From|To|Odds|
|----|---------|----|
|Health Pack|Health Pack|90%|
|Health Pack|Armor Suit|10%|
|Armor Suit|Health Pack|10%|
|Armor Suit|Armor Suit|90%|

> Either quality of Health Pack (15 or 25) or Armor Suit (Green or Yellow) is equally likely to be picked.

#### Ammo replacement chances on Biased Mode

- Ammo type:

|Name|Odds|
|----|----|
|Shells|30%|
|Nails|30%|
|Rockets|15%|
|Cells|15%|
|A weapon|10%|

> The odds for which weapon to be spawned are defined below.

- Ammo crate size (in case a weapon is not spawned):

|Name|Odds|
|----|----|
|Small|65%|
|Big|35%|

#### Powerup replacement chances on Biased Mode

|Name|Odds|
|----|----|
|Pentagram of Protection|18%|
|Quad Damage|18%|
|Ring of Shadows|18%|
|100 Health Pack|18%|
|Red Armor Suit|18%|
|A weapon|6%|
|Biosuit|4%|

> The odds for which weapon to be spawned are defined below.

#### Weapon replacement chances on Biased Mode

Every weapon has an even chance to be spawned.

**However**, there's a specific procedure to select a weapon:
1. First, the game rolls any weapon.
2. It then checks if it has already spawned. If it hasn't and the weapon can be spawned*, the weapon spawns successfully. Otherwise, move on to step 3.
3. The game instead tries to spawn the lowest-ranked weapon that hasn't spawned yet.
4. If all weapons have spawned or the game can't spawn the picked weapon, it spawns a powerup instead.
5. The game returns to the initial state of thinking no weapon has spawned yet (allowing duplicates).

> * The "can be spawned" rule specifically involves that the Thunderbolt can't be spawned in Water surfaces.

### Unbiased Mode ("gamecfg" cvar is "1")

Here, the game just does not care. All convertible objects have the same chance to replace another of the same type. Have fun!

### Backpack Mode ("scratch1" cvar is "1")

This mode can be used with both Biased and Unbiased Modes. Here, all the weapons and ammo pickups are "disguised" as backpacks, so you can't know what you get until you actually get it!

---

## Where can you help?

The mod works as intended, but there are still a bunch of things in the mod that can be done better, which are as follows:
- Give more 'fair' odds for the Biased mode.
- Have the mod use its own, custom cvar instead of `gamecfg`.
- Use a better logic for `UnstuckMonster` and `UnstuckObject`. Currently, what the game does is reposition the entity in random locations around its starting spot up to 300 times, and if it can't get the entity unstuck, it either kills it gruesomely (if it's a monster) or removes it from the game (if it's an object).
- Fix "no such frame" errors for certain monster conversions.
