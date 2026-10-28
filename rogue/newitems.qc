/* New items: the Power Shield and the Anti-Grav Belt
   Dissolution of Eternity (Rogue), Copyright (c) 1997 Rogue Entertainment.

   Ported to this mod:
   - Rogue's .items2 bits (IT2_SHIELD, IT2_ANTIGRAV) are .rog_items bits here (RIT_SHIELD, RIT_ANTIGRAV).
   - The Vengeance Sphere and the Random Powerup box (item_sphere, item_random_powerup) are
     deathmatch only in Rogue (they remove themselves everywhere else), so they only exist here as
     stubs that do the same.
   - UpdateAmmoCounts, also in Rogue's newitems.qc, belongs to the ammo swap logic and comes with it.
*/

void() newitems_touch =
{
	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;

	sprint (other, "You got the ");
	sprint (other, self.netname);
	sprint (other,"\n");

	if (deathmatch)
	{
		self.mdl = self.model;
		self.nextthink = time + 60;
		self.think = SUB_regen;
	}

	sound (other, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	stuffcmd (other, "bf\n");
	self.solid = SOLID_NOT;
	other.items = other.items | self.items;
	other.rog_items = other.rog_items | self.rog_items;
	self.model = string_null;

// do the apropriate action
	if (self.netname == "Power Shield")
	{
		other.shield_time = 1;
		other.shield_finished = time + 30;
	}
	else if (self.netname == "Anti-Grav Belt")
	{
		other.antigrav_time = 1;
		other.antigrav_finished = time + 45;
		other.gravity = 0.25;
	}

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};


/*QUAKED item_powerup_shield (0 .5 .8) (-16 -16 -24) (16 16 32)
The shield upgrade
*/
void() item_powerup_shield =
{
	self.touch = newitems_touch;

	precache_model ("progs/shield.mdl");
	precache_model ("progs/p_shield.mdl");
	precache_sound ("shield/pickup.wav");
	precache_sound ("shield/hit.wav");
	precache_sound ("shield/fadeout.wav");
	self.noise = "shield/pickup.wav";
	setmodel (self, "progs/shield.mdl");
	self.netname = "Power Shield";
	self.rog_items = RIT_SHIELD;
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
};

/*QUAKED item_powerup_belt (0 .5 .8) (-16 -16 -24) (16 16 32)
The anti-grav belt
*/
void() item_powerup_belt =
{
	self.touch = newitems_touch;

	precache_model ("progs/beltup.mdl");
	precache_sound ("belt/pickup.wav");
	precache_sound ("belt/use.wav");
	precache_sound ("belt/fadeout.wav");
	self.noise = "belt/pickup.wav";
	setmodel (self, "progs/beltup.mdl");
	self.netname = "Anti-Grav Belt";
	self.rog_items = RIT_ANTIGRAV;
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
};

/*QUAKED item_lava_spikes (0 .5 .8) (0 0 0) (32 32 32) big
Small box is 25, Big box is 50.
*/
void() item_lava_spikes =
{
	self.touch = ammo_touch;
	if (self.spawnflags & WEAPON_BIG2)
	{
		precache_model ("maps/b_lnail1.bsp");
		setmodel (self, "maps/b_lnail1.bsp");
		self.aflag = 50;
	}
	else
	{
		precache_model ("maps/b_lnail0.bsp");
		setmodel (self, "maps/b_lnail0.bsp");
		self.aflag = 25;
	}
	self.weapon = 5;
	self.netname = "lava nails";
	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
};

/*QUAKED item_multi_rockets (0 .5 .8) (0 0 0) (32 32 32) big
Small box is 5, Big box is 10.
*/
void() item_multi_rockets =
{
	self.touch = ammo_touch;
	if (self.spawnflags & WEAPON_BIG2)
	{
		precache_model ("maps/b_mrock1.bsp");
		setmodel (self, "maps/b_mrock1.bsp");
		self.aflag = 10;
	}
	else
	{
		precache_model ("maps/b_mrock0.bsp");
		setmodel (self, "maps/b_mrock0.bsp");
		self.aflag = 5;
	}
	self.weapon = 6;
	self.netname = "multi rockets";
	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
};

/*QUAKED item_plasma (0 .5 .8) (0 0 0) (32 32 32) big
Small box is 6, Big box is 12.
*/
void() item_plasma =
{
	self.touch = ammo_touch;
	if (self.spawnflags & WEAPON_BIG2)
	{
		precache_model ("maps/b_plas1.bsp");
		setmodel (self, "maps/b_plas1.bsp");
		self.aflag = 12;
	}
	else
	{
		precache_model ("maps/b_plas0.bsp");
		setmodel (self, "maps/b_plas0.bsp");
		self.aflag = 6;
	}
	self.weapon = 7;
	self.netname = "plasma";
	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
};

/*QUAKED item_sphere (0 0 1) (-8 -8 -8) (8 8 8) ?
The Vengeance Sphere. DEATHMATCH ONLY, so it is just removed here.
*/
void() item_sphere =
{
	SUB_Remove();
};

/*QUAKED item_random_powerup (0 .5 .8) (-16 -16 -24) (16 16 32)
The Random Box. DEATHMATCH ONLY, so it is just removed here.
*/
void() item_random_powerup =
{
	SUB_Remove();
};
