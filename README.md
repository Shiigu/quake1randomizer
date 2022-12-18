# quake1randomizer

This mod (compatible with both the classic and remastered releases of Quake 1) has a very simple task: replace ALL the monsters and objects in a level with another of the same type. That first Grunt you encounter in E1M1? Now it could be an Enforcer, a Knight... or maybe a Shambler!

## How to start playing

This mod is installed like any other. Extract the zip file as a folder where your Quake executable is located, then use the `-game` launch parameter so that it executes the mod on launch (some source ports also have a mod selection menu).

## How to configure

To set up the game modes, press the 'M' key, and a menu will show up. Follow the instructions in there.

> In case you accidentally overwrote the 'M' keybind, the command to bring up the menu is `impulse 24`.

> The Randomizer modes are stored in the `savedgamecfg` cvar.

> It is possible to preset a seed by storing it in the `gamecfg` cvar. In the "Seed settings" menu you can see the seed used for the actual level in case you wish to keep it (as well as the option to force the game to reuse that seed until it's closed or the option is changed).

## Item categories

For conversion, all items are split into five categories. Save for some exceptions in Biased Mode, all convertible entities can only be replaced with one of the same type:

- Monsters: Includes all monsters with the exception of Chthon, Shub-Niggurath and cruficied Zombies.
- Pickup: Includes Health Packs (15 and 25 Health) and Armor Suits (Green and Yellow).
- Ammo: Includes all Ammo Crates.
- Powerup: Includes all Powerups, as well as 100 Health Packs and Red Armor Suits.
- Weapon: Includes all Weapons.

## Modes

### Biased Mode

This is the default Randomizer mode. Here, the game will try to be fair (keyword being 'try') to avoid spawning too many of the most powerful enemies. It can still accidentally spawn too many Shamblers or Vores, or simply not give you enough ammo for the weapons you have, but you can always restart...

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

> An Armor Suit cannot spawn if there's another Armor Suit (regardless of color) up to 256 units away from it. If there is, it spawns a Health Crate of the same quality level instead.

#### Ammo replacement chances on Biased Mode

- Ammo type:

|Name|Odds|
|----|----|
|Shells|32%|
|Nails|31%|
|Rockets|16%|
|Cells|16%|
|A weapon|5%|

> The odds for which weapon to be spawned are defined below.

- Ammo crate size (in case a weapon is not spawned):

|Name|Odds|
|----|----|
|Small|65%|
|Big|35%|

#### Powerup replacement chances on Biased Mode

- If there's a liquid body within 256 units of distance

|Name|Odds|
|----|----|
|Pentagram of Protection|18%|
|Quad Damage|18%|
|Ring of Shadows|18%|
|100 Health Pack|18%|
|Red Armor Suit|18%|
|Biosuit|10%|

- If there's no liquid body within 256 units of distance

|Name|Odds|
|----|----|
|Pentagram of Protection|19%|
|Quad Damage|19%|
|Ring of Shadows|19%|
|100 Health Pack|19%|
|Red Armor Suit|19%|
|A weapon|5%|

> A Red Armor suit cannot spawn if there's another suit of armor (regardless of color) up to 256 units away from its center. If it does, then it spawns another powerup (except for a Biosuit) instead.

> Preferably, Powerups of the same type will avoid spawning within 256 units of distance from each other. It should only happen when no other powerup or weapon is available for spawning instead.

> The odds for which weapon to be spawned are defined below.

#### Weapon replacement chances on Biased Mode

Every weapon has an even chance to be spawned.

It works as follows:
1. The Randomizer creates a "bag" of 6 shuffled weapons (Double-barreled Shotgun, Nailgun, Super Nailgun, Grenade Launcher, Rocket Launcher, Thunderbolt), with the weapons the player already has placed first.
2. It moves across the "bag" until it finds a weapon that hasn't been spawned yet and can be spawned in the target location*. Having placed the already-owned weapons first, this gives priority to weapons the player isn't currently carrying.
3. If it reaches the end of the bag without picking a weapon that can be spawned in the target location*, it spawns a powerup (except for a Biosuit or Red Armor suit) instead.
4. If all weapons have spawned, it creates a new "bag", and goes back to Step 2.

> * The "can be spawned" rule specifically involves that the Thunderbolt can't be spawned inside liquid surfaces, due to the fact it will instantly kill a non-invulnerable player if used in there.

### Unbiased Mode

Here, the Randomizer just does not care on whether the randomization is fair or not. All convertible objects have the same chance to replace another of the same type, with the exclusive exception that Rotfish can't spawn outside of water surfaces because they wouldn't be able to move.

Have fun!

### Backpack Mode

This mode is disabled by default. Here, all the weapons and ammo pickups are "disguised" as backpacks, so you can't know what you get until you actually get it!

> To match the behaviour of ammo crates, Backpacks that only contain ammo can't be picked up if your respective ammo reserves are full.

---

## Where can you help?

The mod works as intended, but there are still a bunch of things in the mod that can be done better, which are as follows:
- Give more 'fair' odds for the Biased mode.
- Have the mod use its own, custom cvar instead of `savedgamecfg`.
- Use a better logic for `UnstuckMonster` and `UnstuckObject`. Currently, what the game does is reposition the entity in random locations around its starting spot up to 300 times, and if it can't get the entity unstuck, it either kills it gruesomely (if it's a monster) or removes it from the game (if it's an object). Monsters touching teleporters are excluded from this logic because they are expected to move out of those positions.
