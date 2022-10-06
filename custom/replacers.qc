void() precache_everything;
// MONSTERS
void(entity e) ConvertToFiend;
void(entity e) ConvertToDog;
void(entity e) ConvertToEnforcer;
void(entity e) ConvertToRotfish;
void(entity e) ConvertToDeathKnight;
void(entity e) ConvertToKnight;
void(entity e) ConvertToOgre;
void(entity e) ConvertToVore;
void(entity e) ConvertToShambler;
void(entity e) ConvertToGrunt;
void(entity e) ConvertToSpawn;
void(entity e) ConvertToScrag;
void(entity e) ConvertToZombie;
// PICKUPS
void(entity e, float type) ConvertToHealth;
void(entity e, float type) ConvertToArmor;
// AMMO
void(entity e, float type) ConvertToShells;
void(entity e, float type) ConvertToNails;
void(entity e, float type) ConvertToRockets;
void(entity e, float type) ConvertToCells;
// POWERUPS
void(entity e) ConvertToPentagramOfProtection;
void(entity e) ConvertToBiosuit;
void(entity e) ConvertToRingOfShadows;
void(entity e) ConvertToQuadDamage;
// WEAPONS
void(entity e) ConvertToDoubleBarrelledShotgun;
void(entity e) ConvertToNailgun;
void(entity e) ConvertToSuperNailgun;
void(entity e) ConvertToGrenadeLauncher;
void(entity e) ConvertToRocketLauncher;
void(entity e) ConvertToThunderbolt;
// SCRATCH1 = 1 ONLY
void(entity e, float type) ConvertToWeaponBackpack;
void(entity e, float type, float size) ConvertToAmmoBackpack;

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
void(entity e) ConvertToFiend =
{
	if (deathmatch)
	{
		remove(e);
		return;
	}

	e.solid = SOLID_SLIDEBOX;
	e.movetype = MOVETYPE_STEP;

	setmodel (e, "progs/demon.mdl");

	setsize (e, VEC_HULL2_MIN, VEC_HULL2_MAX);
	if (e.flags & FL_FLY)
		e.flags = e.flags - (e.flags & FL_FLY);
	if (e.flags & FL_SWIM)
		e.flags = e.flags - (e.flags & FL_SWIM);
	if (e.spawnflags & SPAWN_CRUCIFIED)
		e.spawnflags = e.spawnflags - (e.spawnflags & SPAWN_CRUCIFIED);
	e.health = 300;
    e.classname = "monster_demon1";
	e.th_stand = demon1_stand1;
	e.th_walk = demon1_walk1;
	e.th_run = demon1_run1;
	e.th_die = demon_die;
	e.th_melee = Demon_MeleeAttack;		// one of two attacks
	e.th_missile = demon1_jump1;			// jump attack
	e.th_pain = demon1_pain;
		
	walkmonster_start_replaced (e);
};

// Replaces entity with a Dog
void(entity e) ConvertToDog =
{
	if (deathmatch)
	{
		remove(e);
		return;
	}

	e.solid = SOLID_SLIDEBOX;
	e.movetype = MOVETYPE_STEP;

	setmodel (e, "progs/dog.mdl");

	setsize (e, '-32 -32 -24', '32 32 40');
	if (e.flags & FL_FLY)
		e.flags = e.flags - (e.flags & FL_FLY);
	if (e.flags & FL_SWIM)
		e.flags = e.flags - (e.flags & FL_SWIM);
	if (e.spawnflags & SPAWN_CRUCIFIED)
		e.spawnflags = e.spawnflags - (e.spawnflags & SPAWN_CRUCIFIED);
	e.health = 25;
    e.classname = "monster_dog";
	e.th_stand = dog_stand1;
	e.th_walk = dog_walk1;
	e.th_run = dog_run1;
	e.th_pain = dog_pain;
	e.th_die = dog_die;
	e.th_melee = dog_atta1;
	e.th_missile = dog_leap1;

	walkmonster_start_replaced (e);
};

void(entity e) ConvertToEnforcer =
{
	if (deathmatch)
	{
		remove(e);
		return;
	}
	
	e.solid = SOLID_SLIDEBOX;
	e.movetype = MOVETYPE_STEP;

	setmodel (e, "progs/enforcer.mdl");

	setsize (e, '-16 -16 -24', '16 16 40');
	if (e.flags & FL_FLY)
		e.flags = e.flags - (e.flags & FL_FLY);
	if (e.flags & FL_SWIM)
		e.flags = e.flags - (e.flags & FL_SWIM);
	if (e.spawnflags & SPAWN_CRUCIFIED)
		e.spawnflags = e.spawnflags - (e.spawnflags & SPAWN_CRUCIFIED);
	e.health = 80;
    e.classname = "monster_enforcer";
	e.th_stand = enf_stand1;
	e.th_walk = enf_walk1;
	e.th_run = enf_run1;
	e.th_pain = enf_pain;
	e.th_die = enf_die;
	e.th_missile = enf_atk1;
    e.th_melee = SUB_Null;

	walkmonster_start_replaced (e);
};

// Replaces entity with a Rotfish
void(entity e) ConvertToRotfish =
{
	if (deathmatch)
	{
		remove(e);
		return;
	}

	e.solid = SOLID_SLIDEBOX;
	e.movetype = MOVETYPE_STEP;

	setmodel (e, "progs/fish.mdl");

	setsize (e, '-16 -16 -24', '16 16 24');
	if (e.flags & FL_FLY)
		e.flags = e.flags - (e.flags & FL_FLY);
	if (!(e.flags & FL_SWIM))
		e.flags = e.flags | FL_SWIM;
	if (e.spawnflags & SPAWN_CRUCIFIED)
		e.spawnflags = e.spawnflags - (e.spawnflags & SPAWN_CRUCIFIED);
	e.health = 25;
	e.classname = "monster_fish";
	e.th_stand = f_stand1;
	e.th_walk = f_walk1;
	e.th_run = f_run1;
	e.th_die = f_death1;
	e.th_pain = fish_pain;
	e.th_melee = f_attack1;
    e.th_missile = SUB_Null;
	
	swimmonster_start_replaced (e);
};

// Replaces entity with a Death Knight
void(entity e) ConvertToDeathKnight =
{
	if (deathmatch)
	{
		remove(e);
		return;
	}
	
	e.solid = SOLID_SLIDEBOX;
	e.movetype = MOVETYPE_STEP;

	setmodel (e, "progs/hknight.mdl");

	setsize (e, '-16 -16 -24', '16 16 40');
	if (e.flags & FL_FLY)
		e.flags = e.flags - (e.flags & FL_FLY);
	if (e.flags & FL_SWIM)
		e.flags = e.flags - (e.flags & FL_SWIM);
	if (e.spawnflags & SPAWN_CRUCIFIED)
		e.spawnflags = e.spawnflags - (e.spawnflags & SPAWN_CRUCIFIED);
	e.health = 250;
    e.classname = "monster_hell_knight";
	e.th_stand = hknight_stand1;
	e.th_walk = hknight_walk1;
	e.th_run = hknight_run1;
	e.th_melee = hknight_melee;
	e.th_missile = hknight_magicc1;
	e.th_pain = hknight_pain;
	e.th_die = hknight_die;
	
	walkmonster_start_replaced (e);
};

// Replaces entity with a Knight
void(entity e) ConvertToKnight =
{
	if (deathmatch)
	{
		remove(e);
		return;
	}
	e.solid = SOLID_SLIDEBOX;
	e.movetype = MOVETYPE_STEP;

	setmodel (e, "progs/knight.mdl");

	setsize (e, '-16 -16 -24', '16 16 40');
	if (e.flags & FL_FLY)
		e.flags = e.flags - (e.flags & FL_FLY);
	if (e.flags & FL_SWIM)
		e.flags = e.flags - (e.flags & FL_SWIM);
	if (e.spawnflags & SPAWN_CRUCIFIED)
		e.spawnflags = e.spawnflags - (e.spawnflags & SPAWN_CRUCIFIED);
	e.health = 75;
    e.classname = "monster_knight";
	e.th_stand = knight_stand1;
	e.th_walk = knight_walk1;
	e.th_run = knight_run1;
	e.th_melee = knight_atk1;
	e.th_pain = knight_pain;
	e.th_die = knight_die;
    e.th_missile = SUB_Null;
	
	walkmonster_start_replaced (e);
};

// Replaces entity with an Ogre
void(entity e) ConvertToOgre =
{
	if (deathmatch)
	{
		remove(e);
		return;
	}

	e.solid = SOLID_SLIDEBOX;
	e.movetype = MOVETYPE_STEP;

	setmodel (e, "progs/ogre.mdl");

	setsize (e, VEC_HULL2_MIN, VEC_HULL2_MAX);
	if (e.flags & FL_FLY)
		e.flags = e.flags - (e.flags & FL_FLY);
	if (e.flags & FL_SWIM)
		e.flags = e.flags - (e.flags & FL_SWIM);
	if (e.spawnflags & SPAWN_CRUCIFIED)
		e.spawnflags = e.spawnflags - (e.spawnflags & SPAWN_CRUCIFIED);
	e.health = 200;
    e.classname = "monster_ogre";
	e.th_stand = ogre_stand1;
	e.th_walk = ogre_walk1;
	e.th_run = ogre_run1;
	e.th_die = ogre_die;
	e.th_melee = ogre_melee;
	e.th_missile = ogre_nail1;
	e.th_pain = ogre_pain;
	
	walkmonster_start_replaced (e);
};

// Replaces entity with a Vore
void(entity e) ConvertToVore =
{
	if (deathmatch)
	{
		remove(e);
		return;
	}
	
	e.solid = SOLID_SLIDEBOX;
	e.movetype = MOVETYPE_STEP;
	
	setmodel (e, "progs/shalrath.mdl");
	setsize (e, VEC_HULL2_MIN, VEC_HULL2_MAX);
	if (e.flags & FL_FLY)
		e.flags = e.flags - (e.flags & FL_FLY);
	if (e.flags & FL_SWIM)
		e.flags = e.flags - (e.flags & FL_SWIM);
	if (e.spawnflags & SPAWN_CRUCIFIED)
		e.spawnflags = e.spawnflags - (e.spawnflags & SPAWN_CRUCIFIED);
	e.health = 400;
    e.classname = "monster_shalrath";
	e.th_stand = shal_stand;
	e.th_walk = shal_walk1;
	e.th_run = shal_run1;
	e.th_die = shalrath_die;
	e.th_pain = shalrath_pain;
	e.th_missile = shal_attack1;
    e.th_melee = SUB_Null;

	walkmonster_start_replaced (e);
};

// Replaces entity with a Shambler
void(entity e) ConvertToShambler =
{
	if (deathmatch)
	{
		remove(e);
		return;
	}

	e.solid = SOLID_SLIDEBOX;
	e.movetype = MOVETYPE_STEP;
	setmodel (e, "progs/shambler.mdl");

	setsize (e, VEC_HULL2_MIN, VEC_HULL2_MAX);
	if (e.flags & FL_FLY)
		e.flags = e.flags - (e.flags & FL_FLY);
	if (e.flags & FL_SWIM)
		e.flags = e.flags - (e.flags & FL_SWIM);
	if (e.spawnflags & SPAWN_CRUCIFIED)
		e.spawnflags = e.spawnflags - (e.spawnflags & SPAWN_CRUCIFIED);
	e.health = 600;
    e.classname = "monster_shambler";
	e.th_stand = sham_stand1;
	e.th_walk = sham_walk1;
	e.th_run = sham_run1;
	e.th_die = sham_die;
	e.th_melee = sham_melee;
	e.th_missile = sham_magic1;
	e.th_pain = sham_pain;
	
	walkmonster_start_replaced (e);
};

// Replaces entity with a Grunt
void(entity e) ConvertToGrunt =
{	
	if (deathmatch)
	{
		remove(e);
		return;
	}
	e.solid = SOLID_SLIDEBOX;
	e.movetype = MOVETYPE_STEP;

	setmodel (e, "progs/soldier.mdl");

	setsize (e, '-16 -16 -24', '16 16 40');
	if (e.flags & FL_FLY)
		e.flags = e.flags - (e.flags & FL_FLY);
	if (e.flags & FL_SWIM)
		e.flags = e.flags - (e.flags & FL_SWIM);
	if (e.spawnflags & SPAWN_CRUCIFIED)
		e.spawnflags = e.spawnflags - (e.spawnflags & SPAWN_CRUCIFIED);
	e.health = 30;
    e.classname = "monster_army";
	e.th_stand = army_stand1;
	e.th_walk = army_walk1;
	e.th_run = army_run1;
	e.th_missile = army_atk1;
	e.th_pain = army_pain;
	e.th_die = army_die;
    e.th_melee = SUB_Null;

	walkmonster_start_replaced (e);
};

// Replaces entity with an Spawn
void(entity e) ConvertToSpawn =
{
	if (deathmatch)
	{
		remove(e);
		return;
	}
	
	e.solid = SOLID_SLIDEBOX;
	e.movetype = MOVETYPE_STEP;

	setmodel (e, "progs/tarbaby.mdl");

	setsize (e, '-16 -16 -24', '16 16 40');
	if (e.flags & FL_FLY)
		e.flags = e.flags - (e.flags & FL_FLY);
	if (e.flags & FL_SWIM)
		e.flags = e.flags - (e.flags & FL_SWIM);
	if (e.spawnflags & SPAWN_CRUCIFIED)
		e.spawnflags = e.spawnflags - (e.spawnflags & SPAWN_CRUCIFIED);
	e.health = 80;
    e.classname = "monster_tarbaby";
	e.th_stand = tbaby_stand1;
	e.th_walk = tbaby_walk1;
	e.th_run = tbaby_run1;
	e.th_missile = tbaby_jump1;
	e.th_melee = tbaby_jump1;
	e.th_die = tbaby_die1;
    e.th_pain = SUB_Null;
	
	walkmonster_start_replaced (e);
};

// Replaces entity with an Scrag
void(entity e) ConvertToScrag =
{
	if (deathmatch)
	{
		remove(e);
		return;
	}

	e.solid = SOLID_SLIDEBOX;
	e.movetype = MOVETYPE_STEP;

	setmodel (e, "progs/wizard.mdl");

	setsize (e, '-16 -16 -24', '16 16 40');
	if (!(e.flags & FL_FLY))
		e.flags = e.flags | FL_FLY;
	if (e.flags & FL_SWIM)
		e.flags = e.flags - (e.flags & FL_SWIM);
	if (e.spawnflags & SPAWN_CRUCIFIED)
		e.spawnflags = e.spawnflags - (e.spawnflags & SPAWN_CRUCIFIED);
	e.health = 80;
    e.classname = "monster_wizard";
	e.th_stand = wiz_stand1;
	e.th_walk = wiz_walk1;
	e.th_run = wiz_run1;
	e.th_missile = Wiz_Missile;
	e.th_pain = Wiz_Pain;
	e.th_die = wiz_die;
    e.th_melee = SUB_Null;
		
	flymonster_start_replaced (e);
};

// Replaces entity with a (non-crucified) Zombie
void(entity e) ConvertToZombie =
{
	if (deathmatch)
	{
		remove(e);
		return;
	}

	e.solid = SOLID_SLIDEBOX;
	e.movetype = MOVETYPE_STEP;

	setmodel (e, "progs/zombie.mdl");

	setsize (e, '-16 -16 -24', '16 16 40');    
	if (e.flags & FL_FLY)
		e.flags = e.flags - (e.flags & FL_FLY);
	if (e.flags & FL_SWIM)
		e.flags = e.flags - (e.flags & FL_SWIM);
	e.health = 60;
    e.classname = "monster_zombie";
	e.th_stand = zombie_stand1;
	e.th_walk = zombie_walk1;
	e.th_run = zombie_run1;
	e.th_pain = zombie_pain;
	e.th_die = zombie_die;
	e.th_missile = zombie_missile;
    e.th_melee = SUB_Null;

    walkmonster_start_replaced (e);
};

// END MONSTERS

// START PICKUPS

// Converts entity to a health pack
// "type" indicates whether it's a 15 pack, 25 pack or 100 pack
void(entity e, float type) ConvertToHealth =
{	
	e.touch = health_touch;
    e.classname = "item_health";
	if (type == 1)
	{
        setmodel(e, "maps/b_bh10.bsp");
		e.noise = "items/r_item1.wav";
		e.healamount = 15;
		e.healtype = 0;
	}
	else if (type == 2)
	{		
		setmodel(e, "maps/b_bh25.bsp");
		e.noise = "items/health1.wav";
		e.healamount = 25;
		e.healtype = 1;
	}
	else if (type == 3)
	{
		setmodel(e, "maps/b_bh100.bsp");
		e.noise = "items/r_item2.wav";
		e.healamount = 100;
		e.healtype = 2;
	}
	setsize (e, '0 0 0', '32 32 56');
	StartItem_Replaced (e);
};

// Converts item into an Armor suit
// "type" contains whether it's a Green Armor, Yellow Armor or Red Armor
void(entity e, float type) ConvertToArmor =
{
	e.touch = armor_touch;
    setmodel (e, "progs/armor.mdl");
    e.skin = type;
    if(type == 0)
    {
        e.classname = "item_armor1";
    }
    else if (type == 1)
    {
        e.classname = "item_armor2";
    }
    else if (type == 2)
    {
        e.classname = "item_armorInv";
    }
	setsize (e, '-16 -16 0', '16 16 56');
	StartItem_Replaced (e);
};

// END PICKUPS

// START AMMO

// Converts entity into a box of shells
// "type" contains whether it's a small box (20) or a big box (40)
void(entity e, float type) ConvertToShells =
{
	e.touch = ammo_touch;
    e.classname = "item_shells";
	if (type == 1)
	{
		setmodel (e, "maps/b_shell1.bsp");
		e.aflag = 40;
	}
	else if (type == 2)
	{
		setmodel (e, "maps/b_shell0.bsp");
		e.aflag = 20;
	}
	e.weapon = 1;
	e.netname = "shells";
	e.skin = 0;
	setsize (e, '0 0 0', '32 32 56');
	StartItem_Replaced (e);
};

// Converts entity into a box of shells
// "type" contains whether it's a small box (25) or a big box (50)
void(entity e, float type) ConvertToNails =
{
	e.touch = ammo_touch;
    e.classname = "item_spikes";
	if (type == 1)
	{
		setmodel (e, "maps/b_nail1.bsp");
		e.aflag = 50;
	}
	else if (type == 2)
	{
		setmodel (e, "maps/b_nail0.bsp");
		e.aflag = 25;
	}
	e.weapon = 2;
	e.netname = "nails";
	e.skin = 0;
	setsize (e, '0 0 0', '32 32 56');
	StartItem_Replaced (e);
};

// Converts entity into a box of shells
// "type" contains whether it's a small box (5) or a big box (10)
void(entity e, float type) ConvertToRockets =
{
	e.touch = ammo_touch;
    e.classname = "item_rockets";
	if (type == 1)
	{
		setmodel (e, "maps/b_rock1.bsp");
		e.aflag = 10;
	}
	else if (type == 2)
	{
		setmodel (e, "maps/b_rock0.bsp");
		e.aflag = 5;
	}
	e.weapon = 3;
	e.netname = "rockets";
	e.skin = 0;
	setsize (e, '0 0 0', '32 32 56');
	StartItem_Replaced (e);
};

// Converts entity into a box of shells
// "type" contains whether it's a small box (6) or a big box (12)
void(entity e, float type) ConvertToCells =
{
	e.touch = ammo_touch;
    e.classname = "item_cells";
	if (type == 1)
	{
		setmodel (e, "maps/b_batt1.bsp");
		e.aflag = 12;
	}
	else if (type == 2)
	{
		setmodel (e, "maps/b_batt0.bsp");
		e.aflag = 6;
	}
	e.weapon = 4;
	e.netname = "cells";
	e.skin = 0;
	setsize (e, '0 0 0', '32 32 56');
	StartItem_Replaced (e);
};

// END AMMO

// START POWERUPS

// Converts entity into a Pentagram of Protection
void(entity e) ConvertToPentagramOfProtection =
{
	e.touch = powerup_touch;
    e.classname = "item_artifact_invulnerability";
	e.noise = "items/protect.wav";
	setmodel (e, "progs/invulner.mdl");
	e.netname = "Pentagram of Protection";
	e.items = IT_INVULNERABILITY;
	e.skin = 0;
	setsize (e, '-16 -16 -24', '16 16 32');
	StartItem_Replaced (e);
};

// Converts entity into a Biosuit
void(entity e) ConvertToBiosuit =
{
	e.touch = powerup_touch;
    e.classname = "item_artifact_envirosuit";
	e.noise = "items/suit.wav";
	setmodel (e, "progs/suit.mdl");
	e.netname = "Biosuit";
	e.items = IT_SUIT;
	e.skin = 0;
	setsize (e, '-16 -16 -24', '16 16 32');
	StartItem_Replaced (e);
};

// Converts entity into a Ring of Shadows
void(entity e) ConvertToRingOfShadows =
{
	e.touch = powerup_touch;
    e.classname = "item_artifact_invisibility";
	e.noise = "items/inv1.wav";
	setmodel (e, "progs/invisibl.mdl");
	e.netname = "Ring of Shadows";
	e.items = IT_INVISIBILITY;
	e.skin = 0;
	setsize (e, '-16 -16 -24', '16 16 32');
	StartItem_Replaced (e);
};

// Converts entity into a Quad Damage
void(entity e) ConvertToQuadDamage =
{
	e.touch = powerup_touch;
    e.classname = "item_artifact_super_damage";
	e.noise = "items/damage.wav";
	setmodel (e, "progs/quaddama.mdl");
	e.netname = "Quad Damage";
	e.items = IT_QUAD;
	e.skin = 0;
	setsize (e, '-16 -16 -24', '16 16 32');
	StartItem_Replaced (e);
};

// END POWERUPS

// START WEAPONS

// Converts entity into a Double-Barrelled Shotgun
void(entity e) ConvertToDoubleBarrelledShotgun =
{
	setmodel (e, "progs/g_shot.mdl");
    e.classname = "weapon_supershotgun";
	e.weapon = IT_SUPER_SHOTGUN;
	e.netname = "Double-barrelled Shotgun";
	e.touch = weapon_touch;
	e.skin = 0;
	setsize (e, '-16 -16 0', '16 16 56');
	StartItem_Replaced (e);
};

// Converts entity into a Nailgun
void(entity e) ConvertToNailgun =
{
	setmodel (e, "progs/g_nail.mdl");
    e.classname = "weapon_nailgun";
	e.weapon = IT_NAILGUN;
	e.netname = "nailgun";
	e.touch = weapon_touch;
	e.skin = 0;
	setsize (e, '-16 -16 0', '16 16 56');
	StartItem_Replaced (e);
};

// Converts entity into a Super Nailgun
void(entity e) ConvertToSuperNailgun =
{
	setmodel (e, "progs/g_nail2.mdl");
    e.classname = "weapon_supernailgun";
	e.weapon = IT_SUPER_NAILGUN;
	e.netname = "Super Nailgun";
	e.touch = weapon_touch;
	e.skin = 0;
	setsize (e, '-16 -16 0', '16 16 56');
	StartItem_Replaced (e);
};

// Converts entity into a Grenade Launcher
void(entity e) ConvertToGrenadeLauncher =
{
	setmodel (e, "progs/g_rock.mdl");
    e.classname = "weapon_grenadelauncher";
	e.weapon = 3;
	e.netname = "Grenade Launcher";
	e.touch = weapon_touch;
	e.skin = 0;
	setsize (e, '-16 -16 0', '16 16 56');
	StartItem_Replaced (e);
};

// Converts entity into a Rocket Launcher
void(entity e) ConvertToRocketLauncher =
{
	setmodel (e, "progs/g_rock2.mdl");
    e.classname = "weapon_rocketlauncher";
	e.weapon = 3;
	e.netname = "Rocket Launcher";
	e.touch = weapon_touch;
	e.skin = 0;
	setsize (e, '-16 -16 0', '16 16 56');
	StartItem_Replaced (e);
};

// Converts entity into a Thunderbolt
void(entity e) ConvertToThunderbolt =
{
	setmodel (e, "progs/g_light.mdl");
    e.classname = "weapon_lightning";
	e.weapon = 3;
	e.netname = "Thunderbolt";
	e.touch = weapon_touch;
	e.skin = 0;
	setsize (e, '-16 -16 0', '16 16 56');
	StartItem_Replaced (e);
};

// END WEAPONS

// START SCRATCH1 = 1 ONLY

void(entity e, float type) ConvertToWeaponBackpack =
{
	e.items = type;
	e.ammo_shells = 0;
	e.ammo_nails = 0;
	e.ammo_rockets = 0;
	e.ammo_cells = 0;
	if (type == IT_SUPER_SHOTGUN)
	{
		e.classname = "item_backpack_supershotgun";
		e.netname = "Double-barrelled Shotgun";
		e.ammo_shells = 5;
	}
	else if (type == IT_NAILGUN)
	{
		e.classname = "item_backpack_nailgun";
		e.netname = "Nailgun";
		e.ammo_nails = 30;
	}
	else if (type == IT_SUPER_NAILGUN)
	{
		e.classname = "item_backpack_supernailgun";
		e.netname = "Super Nailgun";
		e.ammo_nails = 30;
	}
	else if (type == IT_GRENADE_LAUNCHER)
	{
		e.classname = "item_backpack_grenadelauncher";
		e.netname = "Grenade Launcher";
		e.ammo_rockets = 5;
	}
	else if (type == IT_ROCKET_LAUNCHER)
	{
		e.classname = "item_backpack_rocketlauncher";
		e.netname = "Rocket Launcher";
		e.ammo_rockets = 5;
	}
	else if (type == IT_LIGHTNING)
	{
		e.classname = "item_backpack_lightning";
		e.netname = "Thunderbolt";
		e.ammo_cells = 15;
	}
	else
	{
		e.netname = "";
		dprint("Invalid weapon type\n");	
		return;
	}

	e.flags = FL_ITEM;
	e.solid = SOLID_TRIGGER;
	e.movetype = MOVETYPE_TOSS;
	setmodel (e, "progs/backpack.mdl");
	setsize (e, '-16 -16 0', '16 16 56');
	e.touch = BackpackTouch_Replaced;
	StartItem_Replaced (e);
};

void(entity e, float type, float size) ConvertToAmmoBackpack =
{
	e.items = 0;
	if (type == 1) // Shells
	{
		e.classname = "item_backpack_shells";
		if(size == 1)
			e.ammo_shells = 40;
		else if(size == 2)
			e.ammo_shells = 20;
	}
	else if (type == 2) // Nails
	{
		e.classname = "item_backpack_spikes";
		if(size == 1)
			e.ammo_nails = 50;
		else if(size == 2)
			e.ammo_nails = 25;
	}
	else if (type == 3) // Rockets
	{
		e.classname = "item_backpack_rockets";
		if(size == 1)
			e.ammo_rockets = 10;
		else if(size == 2)
			e.ammo_rockets = 5;
	}
	else if (type == 4) // Cells
	{
		e.classname = "item_backpack_cells";
		if(size == 1)
			e.ammo_cells = 12;
		else if(size == 2)
			e.ammo_cells = 6;
	}
	else
	{
		e.netname = "";
		dprint("Invalid ammo type\n");	
		return;
	}

	e.flags = FL_ITEM;
	e.solid = SOLID_TRIGGER;
	e.movetype = MOVETYPE_TOSS;
	setmodel (e, "progs/backpack.mdl");
	setsize (e, '-16 -16 0', '16 16 56');
	e.touch = BackpackTouch_Replaced;
	StartItem_Replaced (e);
};

// END SCRATCH1 = 1 ONLY