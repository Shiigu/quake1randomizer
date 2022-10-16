void() precache_everything;
// MONSTERS
void() ConvertToFiend;
void() ConvertToDog;
void() ConvertToEnforcer;
void() ConvertToRotfish;
void() ConvertToDeathKnight;
void() ConvertToKnight;
void() ConvertToOgre;
void() ConvertToVore;
void() ConvertToShambler;
void() ConvertToGrunt;
void() ConvertToSpawn;
void() ConvertToScrag;
void() ConvertToZombie;
// PICKUPS
void() ConvertToHealth;
void() ConvertToArmor;
// AMMO
void() ConvertToShells;
void() ConvertToNails;
void() ConvertToRockets;
void() ConvertToCells;
// POWERUPS
void() ConvertToPentagramOfProtection;
void() ConvertToBiosuit;
void() ConvertToRingOfShadows;
void() ConvertToQuadDamage;
// WEAPONS
void() ConvertToDoubleBarrelledShotgun;
void() ConvertToNailgun;
void() ConvertToSuperNailgun;
void() ConvertToGrenadeLauncher;
void() ConvertToRocketLauncher;
void() ConvertToThunderbolt;
// SCRATCH1 = 1 ONLY
void() ConvertToWeaponBackpack;
void() ConvertToAmmoBackpack;

.float PickupType;				// Which kind of ammo or weapon pickup it is
.float QualityType;				// Which quality of health, armor or ammo pickup it is

void() precache_everything = 
{
	precache_model ("progs/demon.mdl");
	precache_model ("progs/h_demon.mdl");
	precache_sound ("demon/ddeath.wav");
	precache_sound ("demon/dhit2.wav");
	precache_sound ("demon/djump.wav");
	precache_sound ("demon/dpain1.wav");
	precache_sound ("demon/idle1.wav");
	precache_sound ("demon/sight2.wav");
	precache_model ("progs/h_dog.mdl");
	precache_model ("progs/dog.mdl");
	precache_sound ("dog/dattack1.wav");
	precache_sound ("dog/ddeath.wav");
	precache_sound ("dog/dpain1.wav");
	precache_sound ("dog/dsight.wav");
	precache_sound ("dog/idle.wav");    
	precache_model2 ("progs/enforcer.mdl");
	precache_model2 ("progs/h_mega.mdl");
	precache_model2 ("progs/laser.mdl");
	precache_sound2 ("enforcer/death1.wav");
	precache_sound2 ("enforcer/enfire.wav");
	precache_sound2 ("enforcer/enfstop.wav");
	precache_sound2 ("enforcer/idle1.wav");
	precache_sound2 ("enforcer/pain1.wav");
	precache_sound2 ("enforcer/pain2.wav");
	precache_sound2 ("enforcer/sight1.wav");
	precache_sound2 ("enforcer/sight2.wav");
	precache_sound2 ("enforcer/sight3.wav");
	precache_sound2 ("enforcer/sight4.wav");
	precache_model2 ("progs/fish.mdl");
	precache_sound2 ("fish/death.wav");
	precache_sound2 ("fish/bite.wav");
	precache_sound2 ("fish/idle.wav");
	precache_model2 ("progs/hknight.mdl");
	precache_model2 ("progs/k_spike.mdl");
	precache_model2 ("progs/h_hellkn.mdl");	
	precache_sound2 ("hknight/attack1.wav");
	precache_sound2 ("hknight/death1.wav");
	precache_sound2 ("hknight/pain1.wav");
	precache_sound2 ("hknight/sight1.wav");
	precache_sound ("hknight/hit.wav");		// used by C code, so don't sound2
	precache_sound2 ("hknight/slash1.wav");
	precache_sound2 ("hknight/idle.wav");
	precache_sound2 ("hknight/grunt.wav");
	precache_sound ("knight/sword1.wav");
	precache_sound ("knight/sword2.wav");
	precache_model ("progs/knight.mdl");
	precache_model ("progs/h_knight.mdl");
	precache_sound ("knight/kdeath.wav");
	precache_sound ("knight/khurt.wav");
	precache_sound ("knight/ksight.wav");
	precache_sound ("knight/sword1.wav");
	precache_sound ("knight/sword2.wav");
	precache_sound ("knight/idle.wav");
	precache_model ("progs/ogre.mdl");
	precache_model ("progs/h_ogre.mdl");
	precache_model ("progs/grenade.mdl");
	precache_sound ("ogre/ogdrag.wav");
	precache_sound ("ogre/ogdth.wav");
	precache_sound ("ogre/ogidle.wav");
	precache_sound ("ogre/ogidle2.wav");
	precache_sound ("ogre/ogpain1.wav");
	precache_sound ("ogre/ogsawatk.wav");
	precache_sound ("ogre/ogwake.wav");
	precache_model2 ("progs/shalrath.mdl");
	precache_model2 ("progs/h_shal.mdl");
	precache_model2 ("progs/v_spike.mdl");	
	precache_sound2 ("shalrath/attack.wav");
	precache_sound2 ("shalrath/attack2.wav");
	precache_sound2 ("shalrath/death.wav");
	precache_sound2 ("shalrath/idle.wav");
	precache_sound2 ("shalrath/pain.wav");
	precache_sound2 ("shalrath/sight.wav");
	precache_model ("progs/shambler.mdl");
	precache_model ("progs/s_light.mdl");
	precache_model ("progs/h_shams.mdl");
	precache_model ("progs/bolt.mdl");	
	precache_sound ("shambler/sattck1.wav");
	precache_sound ("shambler/sboom.wav");
	precache_sound ("shambler/sdeath.wav");
	precache_sound ("shambler/shurt2.wav");
	precache_sound ("shambler/sidle.wav");
	precache_sound ("shambler/ssight.wav");
	precache_sound ("shambler/melee1.wav");
	precache_sound ("shambler/melee2.wav");
	precache_sound ("shambler/smack.wav");
	precache_model ("progs/soldier.mdl");
	precache_model ("progs/h_guard.mdl");
	precache_model ("progs/gib1.mdl");
	precache_model ("progs/gib2.mdl");
	precache_model ("progs/gib3.mdl");
	precache_sound ("soldier/death1.wav");
	precache_sound ("soldier/idle.wav");
	precache_sound ("soldier/pain1.wav");
	precache_sound ("soldier/pain2.wav");
	precache_sound ("soldier/sattck1.wav");
	precache_sound ("soldier/sight1.wav");
	precache_sound ("player/udeath.wav");		// gib death    
	precache_model2 ("progs/tarbaby.mdl");
	precache_sound2 ("blob/death1.wav");
	precache_sound2 ("blob/hit1.wav");
	precache_sound2 ("blob/land1.wav");
	precache_sound2 ("blob/sight1.wav");
	precache_model ("progs/wizard.mdl");
	precache_model ("progs/h_wizard.mdl");
	precache_model ("progs/w_spike.mdl");
	precache_sound ("wizard/hit.wav");		// used by c code
	precache_sound ("wizard/wattack.wav");
	precache_sound ("wizard/wdeath.wav");
	precache_sound ("wizard/widle1.wav");
	precache_sound ("wizard/widle2.wav");
	precache_sound ("wizard/wpain.wav");
	precache_sound ("wizard/wsight.wav");
	precache_model ("progs/zombie.mdl");
	precache_model ("progs/h_zombie.mdl");
	precache_model ("progs/zom_gib.mdl");
	precache_sound ("zombie/z_idle.wav");
	precache_sound ("zombie/z_idle1.wav");
	precache_sound ("zombie/z_shot1.wav");
	precache_sound ("zombie/z_gib.wav");
	precache_sound ("zombie/z_pain.wav");
	precache_sound ("zombie/z_pain1.wav");
	precache_sound ("zombie/z_fall.wav");
	precache_sound ("zombie/z_miss.wav");
	precache_sound ("zombie/z_hit.wav");
	precache_sound ("zombie/idle_w2.wav");
    precache_model("maps/b_bh10.bsp");
    precache_sound("items/r_item1.wav");
    precache_model("maps/b_bh100.bsp");
    precache_sound("items/r_item2.wav");
    precache_model("maps/b_bh25.bsp");
	precache_sound("items/health1.wav");
    precache_model ("progs/armor.mdl");
    precache_model ("maps/b_shell1.bsp");
    precache_model ("maps/b_shell0.bsp");
    precache_model ("maps/b_nail1.bsp");
    precache_model ("maps/b_nail0.bsp");
    precache_model ("maps/b_rock1.bsp");
    precache_model ("maps/b_rock0.bsp");
    precache_model ("maps/b_batt1.bsp");
    precache_model ("maps/b_batt0.bsp");
	precache_model ("progs/invulner.mdl");
	precache_sound ("items/protect.wav");
	precache_sound ("items/protect2.wav");
	precache_sound ("items/protect3.wav");
	precache_model ("progs/suit.mdl");
	precache_sound ("items/suit.wav");
	precache_sound ("items/suit2.wav");
	precache_model ("progs/invisibl.mdl");
	precache_sound ("items/inv1.wav");
	precache_sound ("items/inv2.wav");
	precache_sound ("items/inv3.wav");
	precache_model ("progs/quaddama.mdl");
	precache_sound ("items/damage.wav");
	precache_sound ("items/damage2.wav");
	precache_sound ("items/damage3.wav");
	precache_model ("progs/g_shot.mdl");
	precache_model ("progs/g_nail.mdl");
	precache_model ("progs/g_nail2.mdl");
	precache_model ("progs/g_rock.mdl");
	precache_model ("progs/g_rock2.mdl");
	precache_model ("progs/g_light.mdl");
};

// START MONSTERS

// Replaces entity with a Fiend
void() ConvertToFiend =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	dprint("Converted ");
	dprint(self.classname);
	dprint(" to ");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/demon.mdl");

	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	if (self.flags & FL_FLY)
		self.flags = self.flags - (self.flags & FL_FLY);
	if (self.flags & FL_SWIM)
		self.flags = self.flags - (self.flags & FL_SWIM);
	if (self.spawnflags & SPAWN_CRUCIFIED)
		self.spawnflags = self.spawnflags - (self.spawnflags & SPAWN_CRUCIFIED);
	self.health = 300;
	self.classname = "monster_demon1";
	self.frame = $stand1;
	self.th_stand = demon1_stand1;
	self.th_walk = demon1_walk1;
	self.th_run = demon1_run1;
	self.th_die = demon_die;
	self.th_melee = Demon_MeleeAttack;		// one of two attacks
	self.th_missile = demon1_jump1;			// jump attack
	self.th_pain = demon1_pain;
	dprint(self.classname);
	dprint("\n");	

	walkmonster_start();
};

// Replaces entity with a Dog
void() ConvertToDog =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	dprint("Converted ");
	dprint(self.classname);
	dprint(" to ");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/dog.mdl");

	setsize (self, '-32 -32 -24', '32 32 40');
	if (self.flags & FL_FLY)
		self.flags = self.flags - (self.flags & FL_FLY);
	if (self.flags & FL_SWIM)
		self.flags = self.flags - (self.flags & FL_SWIM);
	if (self.spawnflags & SPAWN_CRUCIFIED)
		self.spawnflags = self.spawnflags - (self.spawnflags & SPAWN_CRUCIFIED);
	self.health = 25;
	self.classname = "monster_dog";
	self.frame = $stand1;
	self.th_stand = dog_stand1;
	self.th_walk = dog_walk1;
	self.th_run = dog_run1;
	self.th_pain = dog_pain;
	self.th_die = dog_die;
	self.th_melee = dog_atta1;
	self.th_missile = dog_leap1;

	dprint(self.classname);
	dprint("\n");	

	walkmonster_start();
};

void() ConvertToEnforcer =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	dprint("Converted ");
	dprint(self.classname);
	dprint(" to ");
	
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/enforcer.mdl");

	setsize (self, '-16 -16 -24', '16 16 40');
	if (self.flags & FL_FLY)
		self.flags = self.flags - (self.flags & FL_FLY);
	if (self.flags & FL_SWIM)
		self.flags = self.flags - (self.flags & FL_SWIM);
	if (self.spawnflags & SPAWN_CRUCIFIED)
		self.spawnflags = self.spawnflags - (self.spawnflags & SPAWN_CRUCIFIED);
	self.health = 80;
	self.classname = "monster_enforcer";
	self.frame = $stand1;
	self.th_stand = enf_stand1;
	self.th_walk = enf_walk1;
	self.th_run = enf_run1;
	self.th_pain = enf_pain;
	self.th_die = enf_die;
	self.th_missile = enf_atk1;
	self.th_melee = SUB_Null;

	dprint(self.classname);
	dprint("\n");	

	walkmonster_start();
};

// Replaces entity with a Rotfish
void() ConvertToRotfish =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	dprint("Converted ");
	dprint(self.classname);
	dprint(" to ");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/fish.mdl");

	setsize (self, '-16 -16 -24', '16 16 24');
	if (self.flags & FL_FLY)
		self.flags = self.flags - (self.flags & FL_FLY);
	if (!(self.flags & FL_SWIM))
		self.flags = self.flags | FL_SWIM;
	if (self.spawnflags & SPAWN_CRUCIFIED)
		self.spawnflags = self.spawnflags - (self.spawnflags & SPAWN_CRUCIFIED);
	self.health = 25;
	self.classname = "monster_fish";
	self.frame = $stand1;
	self.th_stand = f_stand1;
	self.th_walk = f_walk1;
	self.th_run = f_run1;
	self.th_die = f_death1;
	self.th_pain = fish_pain;
	self.th_melee = f_attack1;
	self.th_missile = SUB_Null;
	
	dprint(self.classname);
	dprint("\n");	

	swimmonster_start ();
};

// Replaces entity with a Death Knight
void() ConvertToDeathKnight =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	dprint("Converted ");
	dprint(self.classname);
	dprint(" to ");
	
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/hknight.mdl");

	setsize (self, '-16 -16 -24', '16 16 40');
	if (self.flags & FL_FLY)
		self.flags = self.flags - (self.flags & FL_FLY);
	if (self.flags & FL_SWIM)
		self.flags = self.flags - (self.flags & FL_SWIM);
	if (self.spawnflags & SPAWN_CRUCIFIED)
		self.spawnflags = self.spawnflags - (self.spawnflags & SPAWN_CRUCIFIED);
	self.health = 250;
	self.classname = "monster_hell_knight";
	self.frame = $stand1;
	self.th_stand = hknight_stand1;
	self.th_walk = hknight_walk1;
	self.th_run = hknight_run1;
	self.th_melee = hknight_melee;
	self.th_missile = hknight_magicc1;
	self.th_pain = hknight_pain;
	self.th_die = hknight_die;
	
	dprint(self.classname);
	dprint("\n");	

	walkmonster_start();
};

// Replaces entity with a Knight
void() ConvertToKnight =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	dprint("Converted ");
	dprint(self.classname);
	dprint(" to ");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/knight.mdl");

	setsize (self, '-16 -16 -24', '16 16 40');
	if (self.flags & FL_FLY)
		self.flags = self.flags - (self.flags & FL_FLY);
	if (self.flags & FL_SWIM)
		self.flags = self.flags - (self.flags & FL_SWIM);
	if (self.spawnflags & SPAWN_CRUCIFIED)
		self.spawnflags = self.spawnflags - (self.spawnflags & SPAWN_CRUCIFIED);
	self.health = 75;
	self.classname = "monster_knight";
	self.frame = $stand1;
	self.th_stand = knight_stand1;
	self.th_walk = knight_walk1;
	self.th_run = knight_run1;
	self.th_melee = knight_atk1;
	self.th_pain = knight_pain;
	self.th_die = knight_die;
	self.th_missile = SUB_Null;
	
	dprint(self.classname);
	dprint("\n");	

	walkmonster_start();
};

// Replaces entity with an Ogre
void() ConvertToOgre =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	dprint("Converted ");
	dprint(self.classname);
	dprint(" to ");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/ogre.mdl");

	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	if (self.flags & FL_FLY)
		self.flags = self.flags - (self.flags & FL_FLY);
	if (self.flags & FL_SWIM)
		self.flags = self.flags - (self.flags & FL_SWIM);
	if (self.spawnflags & SPAWN_CRUCIFIED)
		self.spawnflags = self.spawnflags - (self.spawnflags & SPAWN_CRUCIFIED);
	self.health = 200;
	self.classname = "monster_ogre";
	self.frame = $stand1;
	self.th_stand = ogre_stand1;
	self.th_walk = ogre_walk1;
	self.th_run = ogre_run1;
	self.th_die = ogre_die;
	self.th_melee = ogre_melee;
	self.th_missile = ogre_nail1;
	self.th_pain = ogre_pain;
	
	dprint(self.classname);
	dprint("\n");	

	walkmonster_start();
};

// Replaces entity with a Vore
void() ConvertToVore =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	dprint("Converted ");
	dprint(self.classname);
	dprint(" to ");
	
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	
	setmodel (self, "progs/shalrath.mdl");
	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	if (self.flags & FL_FLY)
		self.flags = self.flags - (self.flags & FL_FLY);
	if (self.flags & FL_SWIM)
		self.flags = self.flags - (self.flags & FL_SWIM);
	if (self.spawnflags & SPAWN_CRUCIFIED)
		self.spawnflags = self.spawnflags - (self.spawnflags & SPAWN_CRUCIFIED);
	self.health = 400;
	self.classname = "monster_shalrath";
	self.frame = $stand1;
	self.th_stand = shal_stand;
	self.th_walk = shal_walk1;
	self.th_run = shal_run1;
	self.th_die = shalrath_die;
	self.th_pain = shalrath_pain;
	self.th_missile = shal_attack1;
	self.th_melee = SUB_Null;

	dprint(self.classname);
	dprint("\n");	

	walkmonster_start();
};

// Replaces entity with a Shambler
void() ConvertToShambler =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	dprint("Converted ");
	dprint(self.classname);
	dprint(" to ");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel (self, "progs/shambler.mdl");

	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	if (self.flags & FL_FLY)
		self.flags = self.flags - (self.flags & FL_FLY);
	if (self.flags & FL_SWIM)
		self.flags = self.flags - (self.flags & FL_SWIM);
	if (self.spawnflags & SPAWN_CRUCIFIED)
		self.spawnflags = self.spawnflags - (self.spawnflags & SPAWN_CRUCIFIED);
	self.health = 600;
	self.classname = "monster_shambler";
	self.frame = $stand1;
	self.th_stand = sham_stand1;
	self.th_walk = sham_walk1;
	self.th_run = sham_run1;
	self.th_die = sham_die;
	self.th_melee = sham_melee;
	self.th_missile = sham_magic1;
	self.th_pain = sham_pain;
	
	dprint(self.classname);
	dprint("\n");	

	walkmonster_start();
};

// Replaces entity with a Grunt
void() ConvertToGrunt =
{	
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	dprint("Converted ");
	dprint(self.classname);
	dprint(" to ");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/soldier.mdl");

	setsize (self, '-16 -16 -24', '16 16 40');
	if (self.flags & FL_FLY)
		self.flags = self.flags - (self.flags & FL_FLY);
	if (self.flags & FL_SWIM)
		self.flags = self.flags - (self.flags & FL_SWIM);
	if (self.spawnflags & SPAWN_CRUCIFIED)
		self.spawnflags = self.spawnflags - (self.spawnflags & SPAWN_CRUCIFIED);
	self.health = 30;
	self.classname = "monster_army";
	self.frame = $stand1;
	self.th_stand = army_stand1;
	self.th_walk = army_walk1;
	self.th_run = army_run1;
	self.th_missile = army_atk1;
	self.th_pain = army_pain;
	self.th_die = army_die;
	self.th_melee = SUB_Null;

	dprint(self.classname);
	dprint("\n");	

	walkmonster_start();
};

// Replaces entity with an Spawn
void() ConvertToSpawn =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	dprint("Converted ");
	dprint(self.classname);
	dprint(" to ");
	
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/tarbaby.mdl");

	setsize (self, '-16 -16 -24', '16 16 40');
	if (self.flags & FL_FLY)
		self.flags = self.flags - (self.flags & FL_FLY);
	if (self.flags & FL_SWIM)
		self.flags = self.flags - (self.flags & FL_SWIM);
	if (self.spawnflags & SPAWN_CRUCIFIED)
		self.spawnflags = self.spawnflags - (self.spawnflags & SPAWN_CRUCIFIED);
	self.health = 80;
	self.classname = "monster_tarbaby";
	self.frame = $stand1;
	self.th_stand = tbaby_stand1;
	self.th_walk = tbaby_walk1;
	self.th_run = tbaby_run1;
	self.th_missile = tbaby_jump1;
	self.th_melee = tbaby_jump1;
	self.th_die = tbaby_die1;
	self.th_pain = SUB_Null;
	
	dprint(self.classname);
	dprint("\n");	

	walkmonster_start();
};

// Replaces entity with an Scrag
void() ConvertToScrag =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	dprint("Converted ");
	dprint(self.classname);
	dprint(" to ");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/wizard.mdl");

	setsize (self, '-16 -16 -24', '16 16 40');
	if (!(self.flags & FL_FLY))
		self.flags = self.flags | FL_FLY;
	if (self.flags & FL_SWIM)
		self.flags = self.flags - (self.flags & FL_SWIM);
	if (self.spawnflags & SPAWN_CRUCIFIED)
		self.spawnflags = self.spawnflags - (self.spawnflags & SPAWN_CRUCIFIED);
	self.health = 80;
	self.classname = "monster_wizard";
	self.frame = $stand1;
	self.th_stand = wiz_stand1;
	self.th_walk = wiz_walk1;
	self.th_run = wiz_run1;
	self.th_missile = Wiz_Missile;
	self.th_pain = Wiz_Pain;
	self.th_die = wiz_die;
	self.th_melee = SUB_Null;
		
	dprint(self.classname);
	dprint("\n");	

	flymonster_start ();
};

// Replaces entity with a (non-crucified) Zombie
void() ConvertToZombie =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	dprint("Converted ");
	dprint(self.classname);
	dprint(" to ");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/zombie.mdl");

	setsize (self, '-16 -16 -24', '16 16 40');    
	if (self.flags & FL_FLY)
		self.flags = self.flags - (self.flags & FL_FLY);
	if (self.flags & FL_SWIM)
		self.flags = self.flags - (self.flags & FL_SWIM);
	self.health = 60;
	self.classname = "monster_zombie";
	self.frame = $stand1;
	self.th_stand = zombie_stand1;
	self.th_walk = zombie_walk1;
	self.th_run = zombie_run1;
	self.th_pain = zombie_pain;
	self.th_die = zombie_die;
	self.th_missile = zombie_missile;
	self.th_melee = SUB_Null;

    dprint(self.classname);
	dprint("\n");	

	walkmonster_start();
};

// END MONSTERS

// START PICKUPS

// Converts entity to a health pack
// "type" indicates whether it's a 15 pack, 25 pack or 100 pack
void() ConvertToHealth =
{	
	dprint("Converted ");
	dprint(self.classname);
	dprint(" to ");

	self.touch = health_touch;
	self.classname = "item_health";
	if (self.QualityType == 1)
	{
        setmodel(self, "maps/b_bh10.bsp");
		self.noise = "items/r_item1.wav";
		self.healamount = 15;
		self.healtype = 0;
	}
	else if (self.QualityType == 2)
	{		
		setmodel(self, "maps/b_bh25.bsp");
		self.noise = "items/health1.wav";
		self.healamount = 25;
		self.healtype = 1;
	}
	else if (self.QualityType == 3)
	{
		setmodel(self, "maps/b_bh100.bsp");
		self.noise = "items/r_item2.wav";
		self.healamount = 100;
		self.healtype = 2;
	}
	setsize (self, '0 0 0', '32 32 56');
	dprint(self.classname);
	dprint(" (");
	dprint(ftos(self.healamount));
	dprint(")");
	dprint("\n");
	StartItem ();
};

// Converts item into an Armor suit
// "type" contains whether it's a Green Armor, Yellow Armor or Red Armor
void() ConvertToArmor =
{	
	dprint("Converted ");
	dprint(self.classname);
	dprint(" to ");

	self.touch = armor_touch;
    setmodel (self, "progs/armor.mdl");
    self.skin = self.QualityType - 1;
    if(self.QualityType == 1)
    {
    	self.classname = "item_armor1";
    }
    else if (self.QualityType == 2)
    {
    	self.classname = "item_armor2";
    }
    else if (self.QualityType == 3)
    {
    	self.classname = "item_armorInv";
    }
	setsize (self, '-16 -16 0', '16 16 56');
	dprint(self.classname);
	dprint("\n");
	StartItem ();
};

// END PICKUPS

// START AMMO

// Converts entity into a box of shells
// "type" contains whether it's a small box (20) or a big box (40)
void() ConvertToShells =
{	
	dprint("Converted ");
	dprint(self.classname);
	dprint(" to ");

	self.touch = ammo_touch;
	self.classname = "item_shells";
	if (self.QualityType == 1)
	{
		setmodel (self, "maps/b_shell0.bsp");
		self.aflag = 20;
	}
	else if (self.QualityType == 2)
	{
		setmodel (self, "maps/b_shell1.bsp");
		self.aflag = 40;
	}
	self.weapon = 1;
	self.netname = "shells";
	self.skin = 0;
	setsize (self, '0 0 0', '32 32 56');
	dprint(self.classname);
	dprint(" (");
	dprint(ftos(self.aflag));
	dprint(")");
	dprint("\n");
	StartItem ();
};

// Converts entity into a box of shells
// "type" contains whether it's a small box (25) or a big box (50)
void() ConvertToNails =
{	
	dprint("Converted ");
	dprint(self.classname);
	dprint(" to ");

	self.touch = ammo_touch;
	self.classname = "item_spikes";
	if (self.QualityType == 1)
	{
		setmodel (self, "maps/b_nail0.bsp");
		self.aflag = 25;
	}
	else if (self.QualityType == 2)
	{
		setmodel (self, "maps/b_nail1.bsp");
		self.aflag = 50;
	}
	self.weapon = 2;
	self.netname = "nails";
	self.skin = 0;
	setsize (self, '0 0 0', '32 32 56');
	dprint(self.classname);
	dprint(" (");
	dprint(ftos(self.aflag));
	dprint(")");
	dprint("\n");
	StartItem ();
};

// Converts entity into a box of shells
// "type" contains whether it's a small box (5) or a big box (10)
void() ConvertToRockets =
{	
	dprint("Converted ");
	dprint(self.classname);
	dprint(" to ");

	self.touch = ammo_touch;
	self.classname = "item_rockets";
	if (self.QualityType == 1)
	{
		setmodel (self, "maps/b_rock0.bsp");
		self.aflag = 5;
	}
	else if (self.QualityType == 2)
	{
		setmodel (self, "maps/b_rock1.bsp");
		self.aflag = 10;
	}
	self.weapon = 3;
	self.netname = "rockets";
	self.skin = 0;
	setsize (self, '0 0 0', '32 32 56');
	dprint(self.classname);
	dprint(" (");
	dprint(ftos(self.aflag));
	dprint(")");
	dprint("\n");
	StartItem ();
};

// Converts entity into a box of shells
// "type" contains whether it's a small box (6) or a big box (12)
void() ConvertToCells =
{	
	dprint("Converted ");
	dprint(self.classname);
	dprint(" to ");

	self.touch = ammo_touch;
	self.classname = "item_cells";
	if (self.QualityType == 1)
	{
		setmodel (self, "maps/b_batt0.bsp");
		self.aflag = 6;
	}
	else if (self.QualityType == 2)
	{
		setmodel (self, "maps/b_batt1.bsp");
		self.aflag = 12;
	}
	self.weapon = 4;
	self.netname = "cells";
	self.skin = 0;
	setsize (self, '0 0 0', '32 32 56');
	dprint(self.classname);
	dprint(" (");
	dprint(ftos(self.aflag));
	dprint(")");
	dprint("\n");
	StartItem ();
};

// END AMMO

// START POWERUPS

// Converts entity into a Pentagram of Protection
void() ConvertToPentagramOfProtection =
{	
	dprint("Converted ");
	dprint(self.classname);
	dprint(" to ");

	self.touch = powerup_touch;
	self.classname = "item_artifact_invulnerability";
	self.noise = "items/protect.wav";
	setmodel (self, "progs/invulner.mdl");
	self.netname = "Pentagram of Protection";
	self.items = IT_INVULNERABILITY;
	self.skin = 0;
	setsize (self, '-16 -16 -24', '16 16 32');
	dprint(self.classname);
	dprint("\n");
	StartItem ();
};

// Converts entity into a Biosuit
void() ConvertToBiosuit =
{	
	dprint("Converted ");
	dprint(self.classname);
	dprint(" to ");

	self.touch = powerup_touch;
	self.classname = "item_artifact_envirosuit";
	self.noise = "items/suit.wav";
	setmodel (self, "progs/suit.mdl");
	self.netname = "Biosuit";
	self.items = IT_SUIT;
	self.skin = 0;
	setsize (self, '-16 -16 -24', '16 16 32');
	dprint(self.classname);
	dprint("\n");
	StartItem ();
};

// Converts entity into a Ring of Shadows
void() ConvertToRingOfShadows =
{	
	dprint("Converted ");
	dprint(self.classname);
	dprint(" to ");

	self.touch = powerup_touch;
	self.classname = "item_artifact_invisibility";
	self.noise = "items/inv1.wav";
	setmodel (self, "progs/invisibl.mdl");
	self.netname = "Ring of Shadows";
	self.items = IT_INVISIBILITY;
	self.skin = 0;
	setsize (self, '-16 -16 -24', '16 16 32');
	dprint(self.classname);
	dprint("\n");
	StartItem ();
};

// Converts entity into a Quad Damage
void() ConvertToQuadDamage =
{	
	dprint("Converted ");
	dprint(self.classname);
	dprint(" to ");

	self.touch = powerup_touch;
	self.classname = "item_artifact_super_damage";
	self.noise = "items/damage.wav";
	setmodel (self, "progs/quaddama.mdl");
	self.netname = "Quad Damage";
	self.items = IT_QUAD;
	self.skin = 0;
	setsize (self, '-16 -16 -24', '16 16 32');
	dprint(self.classname);
	dprint("\n");
	StartItem ();
};

// END POWERUPS

// START WEAPONS

// Converts entity into a Double-Barrelled Shotgun
void() ConvertToDoubleBarrelledShotgun =
{	
	dprint("Converted ");
	dprint(self.classname);
	dprint(" to ");

	setmodel (self, "progs/g_shot.mdl");
	self.classname = "weapon_supershotgun";
	self.weapon = IT_SUPER_SHOTGUN;
	self.netname = "Double-barrelled Shotgun";
	self.touch = weapon_touch;
	self.skin = 0;
	setsize (self, '-16 -16 0', '16 16 56');
	dprint(self.classname);
	dprint("\n");
	StartItem ();
};

// Converts entity into a Nailgun
void() ConvertToNailgun =
{	
	dprint("Converted ");
	dprint(self.classname);
	dprint(" to ");

	setmodel (self, "progs/g_nail.mdl");
	self.classname = "weapon_nailgun";
	self.weapon = IT_NAILGUN;
	self.netname = "nailgun";
	self.touch = weapon_touch;
	self.skin = 0;
	setsize (self, '-16 -16 0', '16 16 56');
	dprint(self.classname);
	dprint("\n");
	StartItem ();
};

// Converts entity into a Super Nailgun
void() ConvertToSuperNailgun =
{	
	dprint("Converted ");
	dprint(self.classname);
	dprint(" to ");

	setmodel (self, "progs/g_nail2.mdl");
	self.classname = "weapon_supernailgun";
	self.weapon = IT_SUPER_NAILGUN;
	self.netname = "Super Nailgun";
	self.touch = weapon_touch;
	self.skin = 0;
	setsize (self, '-16 -16 0', '16 16 56');
	dprint(self.classname);
	dprint("\n");
	StartItem ();
};

// Converts entity into a Grenade Launcher
void() ConvertToGrenadeLauncher =
{	
	dprint("Converted ");
	dprint(self.classname);
	dprint(" to ");

	setmodel (self, "progs/g_rock.mdl");
	self.classname = "weapon_grenadelauncher";
	self.weapon = 3;
	self.netname = "Grenade Launcher";
	self.touch = weapon_touch;
	self.skin = 0;
	setsize (self, '-16 -16 0', '16 16 56');
	dprint(self.classname);
	dprint("\n");
	StartItem ();
};

// Converts entity into a Rocket Launcher
void() ConvertToRocketLauncher =
{	
	dprint("Converted ");
	dprint(self.classname);
	dprint(" to ");

	setmodel (self, "progs/g_rock2.mdl");
	self.classname = "weapon_rocketlauncher";
	self.weapon = 3;
	self.netname = "Rocket Launcher";
	self.touch = weapon_touch;
	self.skin = 0;
	setsize (self, '-16 -16 0', '16 16 56');
	dprint(self.classname);
	dprint("\n");
	StartItem ();
};

// Converts entity into a Thunderbolt
void() ConvertToThunderbolt =
{	
	dprint("Converted ");
	dprint(self.classname);
	dprint(" to ");

	setmodel (self, "progs/g_light.mdl");
	self.classname = "weapon_lightning";
	self.weapon = 3;
	self.netname = "Thunderbolt";
	self.touch = weapon_touch;
	self.skin = 0;
	setsize (self, '-16 -16 0', '16 16 56');
	dprint(self.classname);
	dprint("\n");
	StartItem ();
};

// END WEAPONS

// START SCRATCH1 = 1 ONLY

void() ConvertToWeaponBackpack =
{	
	dprint("Converted ");
	dprint(self.classname);
	dprint(" to ");

	self.items = self.PickupType;
	self.ammo_shells = 0;
	self.ammo_nails = 0;
	self.ammo_rockets = 0;
	self.ammo_cells = 0;
	self.skin = 0;
	if (self.PickupType == IT_SUPER_SHOTGUN)
	{
		self.classname = "item_backpack_supershotgun";
		self.netname = "Double-barrelled Shotgun";
		self.ammo_shells = 5;
	}
	else if (self.PickupType == IT_NAILGUN)
	{
		self.classname = "item_backpack_nailgun";
		self.netname = "Nailgun";
		self.ammo_nails = 30;
	}
	else if (self.PickupType == IT_SUPER_NAILGUN)
	{
		self.classname = "item_backpack_supernailgun";
		self.netname = "Super Nailgun";
		self.ammo_nails = 30;
	}
	else if (self.PickupType == IT_GRENADE_LAUNCHER)
	{
		self.classname = "item_backpack_grenadelauncher";
		self.netname = "Grenade Launcher";
		self.ammo_rockets = 5;
	}
	else if (self.PickupType == IT_ROCKET_LAUNCHER)
	{
		self.classname = "item_backpack_rocketlauncher";
		self.netname = "Rocket Launcher";
		self.ammo_rockets = 5;
	}
	else if (self.PickupType == IT_LIGHTNING)
	{
		self.classname = "item_backpack_lightning";
		self.netname = "Thunderbolt";
		self.ammo_cells = 15;
	}
	else
	{
		self.netname = "";
		dprint("Invalid weapon type.");	
		return;
	}

	self.flags = FL_ITEM;
	self.solid = SOLID_TRIGGER;
	self.movetype = MOVETYPE_TOSS;
	setmodel (self, "progs/backpack.mdl");
	setsize (self, '-16 -16 0', '16 16 56');
	self.touch = BackpackTouch_Replaced;
	dprint(self.classname);
	dprint("\n");
	StartItem ();
};

void() ConvertToAmmoBackpack =
{	
	dprint("Converted ");
	dprint(self.classname);
	dprint(" to ");

	self.items = 0;
	self.skin = 0;
	if (self.PickupType == 1) // Shells
	{
		self.classname = "item_backpack_shells";
		if(self.QualityType == 1)
			self.ammo_shells = 20;
		else if(self.QualityType == 2)
			self.ammo_shells = 40;
		dprint(self.classname);
		dprint(" (");
		dprint(ftos(self.ammo_shells));
		dprint(")");
	}
	else if (self.PickupType == 2) // Nails
	{
		self.classname = "item_backpack_spikes";
		if(self.QualityType == 1)
			self.ammo_nails = 25;
		else if(self.QualityType == 2)
			self.ammo_nails = 50;
		dprint(self.classname);
		dprint(" (");
		dprint(ftos(self.ammo_nails));
		dprint(")");
	}
	else if (self.PickupType == 3) // Rockets
	{
		self.classname = "item_backpack_rockets";
		if(self.QualityType == 1)
			self.ammo_rockets = 5;
		else if(self.QualityType == 2)
			self.ammo_rockets = 10;
		dprint(self.classname);
		dprint(" (");
		dprint(ftos(self.ammo_rockets));
		dprint(")");
	}
	else if (self.PickupType == 4) // Cells
	{
		self.classname = "item_backpack_cells";
		if(self.QualityType == 1)
			self.ammo_cells = 6;
		else if(self.QualityType == 2)
			self.ammo_cells = 12;
		dprint(self.classname);
		dprint(" (");
		dprint(ftos(self.ammo_cells));
		dprint(")");
	}
	else
	{
		self.netname = "";
		dprint("Invalid ammo type.\n");	
		return;
	}

	self.flags = FL_ITEM;
	self.solid = SOLID_TRIGGER;
	self.movetype = MOVETYPE_TOSS;
	setmodel (self, "progs/backpack.mdl");
	setsize (self, '-16 -16 0', '16 16 56');
	self.touch = BackpackTouch_Replaced;
	dprint("\n");	
	StartItem ();
};

// END SCRATCH1 = 1 ONLY