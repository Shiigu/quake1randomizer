# quake1randomizer

This mod (compatible with both the classic and remastered releases of Quake 1) has a very simple task: replace ALL the monsters and objects in a level with another of the same type. That first Grunt you encounter in `E1M1`? Now it could be an Enforcer, a Knight... or maybe a Shambler!

## How to start playing

This mod is installed like any other. Extract the zip file as a folder where your Quake executable is located, then use the `-game` launch parameter so that it executes the mod on launch (some source ports also have a mod selection menu).

## How to configure

To set up the game modes, press the 'M' key, and the Randomization Menu will show up. Follow the instructions in there.

> In case you accidentally overwrote the 'M' keybind, the command to bring up the menu is `impulse 24`.

> The Randomizer modes are stored in the `savedgamecfg` cvar.

> It is possible to preset a seed by storing it in the `gamecfg` cvar. In the "Seed settings" menu you can see the seed used for the actual level in case you wish to keep it (as well as the option to force the game to reuse that seed until it's closed or the option is changed).

## Item categories

For conversion, all items are split into five categories. Save for some exceptions in Biased Mode, all convertible entities can only be replaced with one of the same type:

- **Monsters**: Includes all monsters with the exception of Chthon, Shub-Niggurath and cruficied Zombies.
- **Pickup**: Includes Health Packs (15 and 25 Health) and Armor Suits (Green and Yellow).
- **Ammo**: Includes all Ammo Crates.
- **Powerup**: Includes all Powerups, as well as 100 Health Packs and Red Armor Suits.
- **Weapon**: Includes all Weapons.

## Modes

### Normal Mode

This is the default playthrough mode. You go through all of vanilla Quake's levels (plus any compatible maps through the `map` command), albeit with randomization affecting all existing objects.

All the odds used in this mode are the same as the Endless Castle in Normal Odds difficulty.

### Endless Castle Mode

Added in v1.7, this mode, which can only be enabled through the Randomization Menu, puts you through an endless stream of vanilla Quake levels. The levels themselves are randomized, so that every time you get to the exit of a level, you may end up in a completely different place.

Every level is set up to only show up once until all other levels have been set as exits. This has two consequences:
- Since there are four levels with secret exits, two different levels will be set up as exits in their case. That means that, out of 31 possible levels, you will only see 28 per sequence.
- Every level may only appear again 28 levels after the previous time it showed up.
- As a unique rule, Shub-Niggurath's lair (better known as `END`) cannot be rolled as one of the first four levels of any Endless Castle run, given the fact it's almost impossible to get out of it without a full set of weapons.
- If, for some reason, the level picker fails to work, it will default to `E4M3`.

Furthermore, as you venture through the Endless Castle, with every passing level, the Randomization itself starts playing less and less fair (on Biased Mode, on Unbiased Mode it always stays the same):
- **Easy Odds** start at the lowest levels of the Endless Castle, until Level 5.
- **Normal Odds** start at Level 6, until Level 10.
- **Hard Odds** start at Level 11, until Level 20.
- **Nightmare Odds** start at Level 21, until Level 35.
- **Super Nightmare Odds** start at Level 36, until Level 60.
- **Unfair Odds** start at Level 61, and will never end.

Within the Endless Castle menu itself, there are six possible difficulty modes:
- **Easy**: *The Endless Castle starts at Level 1.*
- **Normal**: *The Endless Castle starts at Level 8.*
- **Hard**: *The Endless Castle starts at Level 16.*
- **Nightmare**: *The Endless Castle starts at Level 26.*
- **Super Nightmare**: *The Endless Castle starts at Level 46.*
- **Unfair**: *The Endless Castle starts at Level 66.*

**Dying in the Endless Castle IS FINAL.** There's no retrying a level after you get killed by the monsters (outside of reloading the savegame; this option might be removed in the future if it's possible).

Using the `map` command will instantly end Endless Castle mode. Most cheat codes (such as `god`, `noclip` or `impulse 255`) will instantly boot the player out of Endless Castle mode.

### Biased Mode

This is the default Randomizer mode. Here, the game will try to be fair (keyword being 'try') to avoid spawning too many of the most powerful enemies. It can still accidentally spawn too many Centroids, Shamblers or Vores, or simply not give you enough ammo for the weapons you have, but you can always restart...

#### Monster replacement chances on Biased Mode

- For Monsters in the ground or air:

|Name|Easy Odds|Normal Odds|Hard Odds|Nightmare Odds|Super Nightmare Odds|Unfair Odds|
|----|----|----|----|----|----|----|
|Fiend|5%|7%|8%|10%|11%|12%|
|Rottweiler|11%|7%|6%|4%|2%|0%|
|Enforcer|11%|9%|9%|7%|6%|0%|
|Hell Knight|9%|10%|11%|13%|14%|12%|
|Knight|11%|12%|8%|8%|7%|0%|
|Zombie|10%|9%|10%|11%|9%|11%|
|Vore|2%|3%|4%|5%|7%|20%|
|Shambler|1%|2%|3%|4%|6%|20%|
|Grunt|16%|13%|11%|8%|6%|0%|
|Spawn|1%|3%|4%|6%|6%|15%|
|Scrag|11%|12%|13%|13%|13%|10%|
|Ogre|12%|13%|13%|11%|13%|0%|
|Centroid|3%|5%|7%|8%|10%|15%|
|Gremlin|8%|9%|11%|10%|8%|0%|
|Spike Mine|2%|3%|3%|4%|6%|10%|

> Rotfish aren't allowed to spawn outside of water surfaces because they can't move there.
> Zombies can't spawn on monster spots that are tied to a trigger.

- For Monsters in the water:

|Name|Easy Odds|Normal Odds|Hard Odds|Nightmare Odds|Super Nightmare Odds|Unfair Odds|
|----|----|----|----|----|----|----|
|Fiend|8%|6%|4%|2%|1%|0%|
|Enforcer|8%|12%|14%|15%|15%|0%|
|Hell Knight|8%|12%|14%|14%|15%|5%|
|Zombie|16%|11%|8%|6%|3%|10%|
|Vore|2%|3%|4%|5%|7%|25%|
|Shambler|1%|2%|3%|4%|6%|25%|
|Grunt|9%|13%|11%|15%|10%|0%|
|Spawn|5%|3%|4%|4%|7%|0%|
|Scrag|10%|12%|14%|15%|17%|35%|
|Ogre|8%|9%|9%|9%|11%|0%|
|Rotfish|25%|17%|15%|11%|8%|0%|
|Centroid|3%|5%|7%|8%|10%|15%|
|Gremlin|8%|9%|11%|10%|8%|0%|
|Spike Mine|2%|3%|3%|4%|6%|10%|

> Rottweilers and Knights aren't allowed to spawn inside water surfaces because their attacks are almost completely useless there.
> Zombies can't spawn on monster spots that are tied to a trigger.

#### Pickup replacement chances on Biased Mode

|From|To|Odds|
|----|---------|----|
|Health Pack|Health Pack|90%|
|Health Pack|Armor Suit|10%|
|Armor Suit|Health Pack|10%|
|Armor Suit|Armor Suit|90%|

Whichever quality of Pickup that is spawned depends on the Odds difficulty level:

|Quality|Easy Odds|Normal Odds|Hard Odds|Nightmare Odds|Super Nightmare Odds|Unfair Odds|
|----|----|----|----|----|----|----|
|High|70%|50%|35%|25%|15%|0%|
|Low|30%|50%|65%|75%|85%|100%|

Exclusive to Endless Castle Mode, there's a chance that the Pickup will be removed from the level altogether. This applies before calculating the aforementioned odds:

|-|Easy Odds|Normal Odds|Hard Odds|Nightmare Odds|Super Nightmare Odds|Unfair Odds|
|----|----|----|----|----|----|----|
|Odds to Remove|0%|0%|0%|0%|5%|10%|

> "High Quality" Pickups denote a 25 Health Pack or Yellow Armor. "Low Quality" Pickups denote a 15 Health Pack or Green Armor.

> An Armor Suit are not meant to spawn if there's another Armor Suit (regardless of color) up to 512 units away from it. If there is, it spawns a Health Crate of the same quality level instead.

#### Ammo replacement chances on Biased Mode

- Ammo type:

|Name|Easy Odds|Normal Odds|Hard Odds|Nightmare Odds|Super Nightmare Odds|Unfair Odds|
|----|----|----|----|----|----|----|
|Shells|25%|32%|38%|45%|60%|80%|
|Nails|25%|31%|38%|31%|25%|10%|
|Rockets|20%|16%|13%|15%|12%|5%|
|Cells|20%|16%|8%|7%|16%|5%|
|A weapon|10%|5%|3%|2%|0%|0%|

> The odds for which weapon to be spawned are defined below.

- Ammo crate size (in case a weapon is not spawned):

|Size|Easy Odds|Normal Odds|Hard Odds|Nightmare Odds|Super Nightmare Odds|Unfair Odds|
|----|----|----|----|----|----|----|
|Small|50%|65%|70%|75%|80%|100%|
|Big|50%|35%|30%|25%|20%|0%|

Exclusive to Endless Castle Mode, there's a chance that the Ammo Pack will be removed from the level altogether. This applies before calculating the aforementioned odds:

|-|Easy Odds|Normal Odds|Hard Odds|Nightmare Odds|Super Nightmare Odds|Unfair Odds|
|----|----|----|----|----|----|----|
|Odds to Remove|0%|0%|0%|0%|5%|10%|

#### Powerup replacement chances on Biased Mode

- If there's a liquid body within 512 units of distance

|Name|Easy Odds|Normal Odds|Hard Odds|Nightmare Odds|Super Nightmare Odds|Unfair Odds|
|----|----|----|----|----|----|----|
|Pentagram of Protection|20%|18%|17%|15%|12%|5%|
|Quad Damage|20%|18%|17%|15%|12%|5%|
|Ring of Shadows|20%|18%|17%|15%|12%|5%|
|100 Health Pack|15%|18%|17%|20%|24%|25%|
|Red Armor Suit|20%|18%|17%|15%|12%|10%|
|Biosuit|10%|15%|20%|25%|35%|25%|
|Empathy Shields|20%|18%|17%|15%|12%|8%|
|Wetsuit|10%|15%|20%|25%|35%|25%|
|Horn of Conjuring|20%|15%|10%|8%|5%|5%|

- If there's no liquid body within 512 units of distance

|Name|Easy Odds|Normal Odds|Hard Odds|Nightmare Odds|Super Nightmare Odds|Unfair Odds|
|----|----|----|----|----|----|----|
|Pentagram of Protection|20%|19%|18%|15%|12%|5%|
|Quad Damage|20%|19%|18%|15%|12%|5%|
|Ring of Shadows|20%|19%|18%|15%|12%|5%|
|100 Health Pack|15%|19%|18%|20%|24%|45%|
|Red Armor Suit|20%|19%|18%|15%|12%|10%|
|A weapon|5%|5%|10%|20%|28%|30%|
|Empathy Shields|20%|18%|17%|15%|12%|8%|
|Horn of Conjuring|20%|15%|10%|8%|5%|5%|

Exclusive to Endless Castle Mode, there's a chance that the Powerup will be removed from the level altogether. This applies before calculating the aforementioned odds:

|-|Easy Odds|Normal Odds|Hard Odds|Nightmare Odds|Super Nightmare Odds|Unfair Odds|
|----|----|----|----|----|----|----|
|Odds to Remove|0%|0%|0%|0%|5%|10%|

> A Red Armor suit is not meant to spawn if there's another suit of armor (regardless of color) up to 512 units away from its center. If it does, then it spawns another powerup (except for a Biosuit or Wetsuit) instead.

> Preferably, Powerups of the same type will avoid spawning within 512 units of distance from each other. It should only happen when no other powerup or weapon is available for spawning instead.

> The odds for which weapon to be spawned are defined below.

> If weapon randomization is disabled, the weapon will be replaced by a Quad Damage, or a random Powerup in case proximity checks prevent it.

> The odds of a monster spawned by the Horn of Conjuring follow the same rule as the current randomizer difficulty setting. Thus, the higher the Endless Castle level, the more likely you are to get a powerful monster.

#### Weapon replacement chances on Biased Mode

Every weapon has an even chance to be spawned.

It works as follows:
1. The Randomizer creates a "bag" of 9 shuffled weapons (Double-barreled Shotgun, Nailgun, Super Nailgun, Grenade Launcher, Rocket Launcher, Thunderbolt, Proximity Gun, Laser Cannon, Mjolnir). If the map has been loaded via `changelevel` (such as by reaching a map exit), the weapons that were spawned in the previous map will be skipped (prioritizing weapons that the player could not have obtained yet); otherwise, the ones to be skipped will be the weapons the player already owns.
2. It moves across the "bag" until it finds a weapon that hasn't been spawned or skipped yet and can be spawned in the target location. Having placed the already-owned weapons first, this gives priority to weapons the player isn't currently carrying.
3. If it reaches the end of the bag without picking a weapon that can be spawned in the target location*, it spawns a powerup (except for a Biosuit or Red Armor suit) instead.
4. If all weapons have spawned, it creates a new "bag", and goes back to Step 2.

> The "can be spawned" rule specifically involves that the Thunderbolt and Mjolnir can't be spawned inside liquid surfaces, due to the fact they will instantly kill a non-invulnerable player if used in there.

At every point in the weapon "bag", the following odds are calculated:

|Name|Easy Odds|Normal Odds|Hard Odds|Nightmare Odds|Super Nightmare Odds|Unfair Odds|
|----|----|----|----|----|----|----|
|A weapon|97%|95%|92%|89%|75%|65%|
|A powerup|3%|5%|8%|10%|15%|20%|
|An Ammo Pack|0%|0%|1%|5%|10%|15%|

> The odds for a Powerup only apply if the ability to randomize Powerups is enabled

Exclusive to Endless Castle Mode, there's a chance that the Weapon will be removed from the level altogether. This applies before calculating the aforementioned odds:

|-|Easy Odds|Normal Odds|Hard Odds|Nightmare Odds|Super Nightmare Odds|Unfair Odds|
|----|----|----|----|----|----|----|
|Odds to Remove|0%|0%|0%|0%|5%|10%|

> When the weapon "bag" is complete, there's a 50% chance to spawn a Powerup (if Powerup randomization is enabled) or an Ammo Pack (if Powerup randomization is disabled) instead of immediately create a new weapon "bag".

### Unbiased Mode

Here, the Randomizer just does not care on whether the randomization is fair or not. All convertible objects have the same chance to replace another of the same type, with the exclusive exception that Rotfish can't spawn outside of water surfaces because they wouldn't be able to move, and Zombies cannot spawn tied to a trigger to avoid potential softlocks.

Have fun!

### Backpack Mode

This mode is disabled by default. Here, all the weapons and ammo pickups are "disguised" as backpacks, so you can't know what you get until you actually get it!

> To match the behaviour of ammo crates, Backpacks that only contain ammo can't be picked up if your respective ammo reserves are full.

---

## Where can you help?

The mod works as intended, but there are still a bunch of things in the mod that can be done better, which are as follows:
- Give more 'fair' odds for the Biased mode.
- Create forks of this mod in which it can fully work for Dissolution of Eternity.
- Have the mod use its own, custom cvar instead of `savedgamecfg`.
- Use a better logic for `UnstuckMonster` and `UnstuckObject`. Currently, what the game does is reposition the entity in random locations around its starting spot up to 1500 times, and if it can't get the entity unstuck, it either kills it gruesomely (if it's a monster) or removes it from the game (if it's an object). Monsters touching teleporters are excluded from this logic because they are expected to move out of those positions.
