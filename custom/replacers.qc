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
void() ConvertToCentroid;
void() ConvertToGremlin;
void() ConvertToSpikeMine;
// SPAWN
void(entity e) ConvertFuncSpawn;
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
void() ConvertToEmpathyShields;
void() ConvertToHornOfConjuring;
void() ConvertToWetsuit;
// WEAPONS
void() ConvertToDoubleBarrelledShotgun;
void() ConvertToNailgun;
void() ConvertToSuperNailgun;
void() ConvertToGrenadeLauncher;
void() ConvertToRocketLauncher;
void() ConvertToThunderbolt;
void() ConvertToLaserCannon;
void() ConvertToProximityGun;
void() ConvertToMjolnir;
// BACKPACKS MODE ONLY
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
	precache_sound ("hknight/hit.wav");// used by C code, so don't sound2
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
	precache_sound ("player/udeath.wav");// gib death    
	precache_model2 ("progs/tarbaby.mdl");
	precache_sound2 ("blob/death1.wav");
	precache_sound2 ("blob/hit1.wav");
	precache_sound2 ("blob/land1.wav");
	precache_sound2 ("blob/sight1.wav");
	precache_model ("progs/wizard.mdl");
	precache_model ("progs/h_wizard.mdl");
	precache_model ("progs/w_spike.mdl");
	precache_sound ("wizard/hit.wav");// used by c code
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
   
	precache_model2 ("progs/scor.mdl");
	precache_model2 ("progs/h_scourg.mdl");
	 precache_model2 ("progs/laser.mdl");
	precache_model2 ("progs/s_light.mdl");
	precache_model2 ("progs/spike.mdl");
 
	precache_model ("progs/scor.mdl");
	precache_sound ("scourge/idle.wav");
	precache_sound ("scourge/pain.wav");
	precache_sound ("scourge/pain2.wav");
	precache_sound ("scourge/sight.wav");
	precache_sound ("scourge/tailswng.wav");
	precache_sound ("scourge/walk.wav");

	precache_model ("progs/grem.mdl");
	precache_model ("progs/h_grem.mdl"); 
	precache_sound ("grem/death.wav");
	precache_sound ("grem/attack.wav");
	precache_sound ("grem/pain1.wav");
	precache_sound ("grem/pain2.wav");
	precache_sound ("grem/pain3.wav");
	precache_sound ("grem/idle.wav");
	precache_sound ("grem/sight1.wav");

	precache_model ("progs/spikmine.mdl");
	precache_sound ("weapons/r_exp3.wav");
	precache_sound ("hipitems/spikmine.wav");
	precache_sound ("misc/null.wav");
	precache_sound ("misc/foot1.wav");
	precache_sound ("misc/foot2.wav");
	precache_sound ("misc/foot3.wav");
	precache_sound ("misc/foot4.wav");
	precache_sound ("misc/foot5.wav");
	precache_sound ("misc/foot6.wav");
	precache_sound ("misc/foot7.wav");
		
	precache_model ("progs/g_hammer.mdl");
	precache_model ("progs/g_laserg.mdl");
	precache_model ("progs/g_prox.mdl");  
	precache_model ("progs/v_hammer.mdl");
	precache_model ("progs/v_laserg.mdl");
	precache_model ("progs/v_prox.mdl");
	precache_model ("progs/lasrspik.mdl");
	precache_model ("progs/proxbomb.mdl");	

	precache_model("progs/empathy.mdl");
	precache_sound("hipitems/empathy.wav");
	precache_sound("hipitems/empathy2.wav");
	precache_sound ("items/suit2.wav");

	precache_model ("progs/wetsuit.mdl");
	precache_sound ("misc/wetsuit.wav");
	precache_sound ("misc/weton.wav");
	precache_sound ("items/suit2.wav");
 
	precache_model ("progs/horn.mdl");
	precache_sound ("hipitems/horn.wav");
	
	precache_model ("progs/playham.mdl");
};

// START MONSTERS

// Replaces entity with a Fiend
void() ConvertToFiend =
{
	if (deathmatch)
	{
		SUB_Remove();
		return;
	}
	
	dprint("Converted ");
	dprint(self.classname);
	dprint(" to ");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/demon.mdl");

	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);

	if (!(self.flags & FL_ONGROUND))
		self.flags = self.flags | FL_ONGROUND;
	if (self.flags & FL_FLY)
		self.flags = self.flags - (self.flags & FL_FLY);
	if (self.flags & FL_SWIM)
		self.flags = self.flags - (self.flags & FL_SWIM);
	if (self.spawnflags & SPAWN_CRUCIFIED)
		self.spawnflags = self.spawnflags - (self.spawnflags & SPAWN_CRUCIFIED);
	self.health = 300;
	self.classname = "monster_demon1";
	
	self.touch = SUB_Null;	
	self.th_die = SUB_Null;
	self.th_stand = SUB_Null;
	self.th_walk = SUB_Null;
	self.th_run = SUB_Null;
	self.th_melee = SUB_Null;
	self.th_missile = SUB_Null;
	self.th_pain = SUB_Null;
	self.use = SUB_Null;

	self.frame = $stand1;
	self.th_stand = demon1_stand1;
	self.th_walk = demon1_walk1;
	self.th_run = demon1_run1;
	self.th_die = demon_die;
	self.th_melee = Demon_MeleeAttack;// one of two attacks
	self.th_missile = demon1_jump1;// jump attack
	self.th_pain = demon1_pain;
	self.yaw_speed = 60;
	self.attack_state = 0;
	self.state = 0;
	dprint(self.classname);
	dprint("\n");
	self.Converted = "1";
	self.EntityDisplayName = ENTITY_DISPLAY_NAME_FIEND;
	RegisterEntity(self.EntityDisplayName);
	walkmonster_start();
};

// Replaces entity with a Dog
void() ConvertToDog =
{
	if (deathmatch)
	{
		SUB_Remove();
		return;
	}
	
	dprint("Converted ");
	dprint(self.classname);
	dprint(" to ");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/dog.mdl");

	setsize (self, '-32 -32 -24', '32 32 40');

	if (!(self.flags & FL_ONGROUND))
		self.flags = self.flags | FL_ONGROUND;
	if (self.flags & FL_FLY)
		self.flags = self.flags - (self.flags & FL_FLY);
	if (self.flags & FL_SWIM)
		self.flags = self.flags - (self.flags & FL_SWIM);
	if (self.spawnflags & SPAWN_CRUCIFIED)
		self.spawnflags = self.spawnflags - (self.spawnflags & SPAWN_CRUCIFIED);
	self.health = 25;
	self.classname = "monster_dog";
	self.frame = $stand1;
	
	self.touch = SUB_Null;	
	self.th_die = SUB_Null;
	self.th_stand = SUB_Null;
	self.th_walk = SUB_Null;
	self.th_run = SUB_Null;
	self.th_melee = SUB_Null;
	self.th_missile = SUB_Null;
	self.th_pain = SUB_Null;
	self.use = SUB_Null;

	self.th_stand = dog_stand1;
	self.th_walk = dog_walk1;
	self.th_run = dog_run1;
	self.th_pain = dog_pain;
	self.th_die = dog_die;
	self.th_melee = dog_atta1;
	self.th_missile = dog_leap1;
	self.yaw_speed = 60;
	self.attack_state = 0;
	self.state = 0;

	dprint(self.classname);
	dprint("\n");
	self.Converted = "1";
	self.EntityDisplayName = ENTITY_DISPLAY_NAME_ROTTWEILER;
	RegisterEntity(self.EntityDisplayName);
	walkmonster_start();
};

void() ConvertToEnforcer =
{
	if (deathmatch)
	{
		SUB_Remove();
		return;
	}
	
	dprint("Converted ");
	dprint(self.classname);
	dprint(" to ");
	
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/enforcer.mdl");

	setsize (self, '-16 -16 -24', '16 16 40');
	
	if (!(self.flags & FL_ONGROUND))
		self.flags = self.flags | FL_ONGROUND;
	if (self.flags & FL_FLY)
		self.flags = self.flags - (self.flags & FL_FLY);
	if (self.flags & FL_SWIM)
		self.flags = self.flags - (self.flags & FL_SWIM);
	if (self.spawnflags & SPAWN_CRUCIFIED)
		self.spawnflags = self.spawnflags - (self.spawnflags & SPAWN_CRUCIFIED);
	self.health = 80;
	self.classname = "monster_enforcer";
	self.frame = $stand1;
	
	self.touch = SUB_Null;	
	self.th_die = SUB_Null;
	self.th_stand = SUB_Null;
	self.th_walk = SUB_Null;
	self.th_run = SUB_Null;
	self.th_melee = SUB_Null;
	self.th_missile = SUB_Null;
	self.th_pain = SUB_Null;

	self.use = SUB_Null;
	self.th_stand = enf_stand1;
	self.th_walk = enf_walk1;
	self.th_run = enf_run1;
	self.th_pain = enf_pain;
	self.th_die = enf_die;
	self.th_missile = enf_atk1;
	self.th_melee = enf_atk1;
	self.yaw_speed = 60;
	self.attack_state = 0;
	self.state = 0;

	dprint(self.classname);
	dprint("\n");
	self.Converted = "1";

	self.EntityDisplayName = ENTITY_DISPLAY_NAME_ENFORCER;
	RegisterEntity(self.EntityDisplayName);
	walkmonster_start();
};

// Replaces entity with a Rotfish
void() ConvertToRotfish =
{
	if (deathmatch)
	{
		SUB_Remove();
		return;
	}
	
	dprint("Converted ");
	dprint(self.classname);
	dprint(" to ");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/fish.mdl");

	setsize (self, '-16 -16 -24', '16 16 24');

	if (self.flags & FL_ONGROUND)
		self.flags = self.flags - (self.flags & FL_ONGROUND);
	if (self.flags & FL_FLY)
		self.flags = self.flags - (self.flags & FL_FLY);
	if (!(self.flags & FL_SWIM))
		self.flags = self.flags | FL_SWIM;
	if (self.spawnflags & SPAWN_CRUCIFIED)
		self.spawnflags = self.spawnflags - (self.spawnflags & SPAWN_CRUCIFIED);
	self.health = 25;
	self.classname = "monster_fish";
	self.frame = $stand1;
	
	self.touch = SUB_Null;	
	self.th_die = SUB_Null;
	self.th_stand = SUB_Null;
	self.th_walk = SUB_Null;
	self.th_run = SUB_Null;
	self.th_melee = SUB_Null;
	self.th_missile = SUB_Null;
	self.th_pain = SUB_Null;

	self.use = SUB_Null;
	self.th_stand = f_stand1;
	self.th_walk = f_walk1;
	self.th_run = f_run1;
	self.th_die = fish_die;
	self.th_pain = fish_pain;
	self.th_melee = f_attack1;
	self.th_stand = f_stand1;
	self.th_walk = f_walk1;
	self.th_run = f_run1;
	self.yaw_speed = 60;
	self.attack_state = 0;
	self.state = 0;
	
	dprint(self.classname);
	dprint("\n");
	self.Converted = "1";

	self.EntityDisplayName = ENTITY_DISPLAY_NAME_ROTFISH;
	RegisterEntity(self.EntityDisplayName);
	swimmonster_start ();
};

// Replaces entity with a Death Knight
void() ConvertToDeathKnight =
{
	if (deathmatch)
	{
		SUB_Remove();
		return;
	}
	
	dprint("Converted ");
	dprint(self.classname);
	dprint(" to ");
	
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/hknight.mdl");

	setsize (self, '-16 -16 -24', '16 16 40');
	
	if (!(self.flags & FL_ONGROUND))
		self.flags = self.flags | FL_ONGROUND;
	if (self.flags & FL_FLY)
		self.flags = self.flags - (self.flags & FL_FLY);
	if (self.flags & FL_SWIM)
		self.flags = self.flags - (self.flags & FL_SWIM);
	if (self.spawnflags & SPAWN_CRUCIFIED)
		self.spawnflags = self.spawnflags - (self.spawnflags & SPAWN_CRUCIFIED);
	self.health = 250;
	self.classname = "monster_hell_knight";
	self.frame = $stand1;
	
	self.touch = SUB_Null;	
	self.th_die = SUB_Null;
	self.th_stand = SUB_Null;
	self.th_walk = SUB_Null;
	self.th_run = SUB_Null;
	self.th_melee = SUB_Null;
	self.th_missile = SUB_Null;
	self.th_pain = SUB_Null;
	self.use = SUB_Null;

	self.th_stand = hknight_stand1;
	self.th_walk = hknight_walk1;
	self.th_run = hknight_run1;
	self.th_melee = hknight_melee;
	self.th_missile = hknight_magicc1;
	self.th_pain = hknight_pain;
	self.th_die = hknight_die;
	self.yaw_speed = 60;
	self.attack_state = 0;
	self.state = 0;
	
	dprint(self.classname);
	dprint("\n");
	self.Converted = "1";

	self.EntityDisplayName = ENTITY_DISPLAY_NAME_DEATH_KNIGHT;
	RegisterEntity(self.EntityDisplayName);
	walkmonster_start();
};

// Replaces entity with a Knight
void() ConvertToKnight =
{
	if (deathmatch)
	{
		SUB_Remove();
		return;
	}
	
	dprint("Converted ");
	dprint(self.classname);
	dprint(" to ");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/knight.mdl");

	setsize (self, '-16 -16 -24', '16 16 40');
	
	if (!(self.flags & FL_ONGROUND))
		self.flags = self.flags | FL_ONGROUND;
	if (self.flags & FL_FLY)
		self.flags = self.flags - (self.flags & FL_FLY);
	if (self.flags & FL_SWIM)
		self.flags = self.flags - (self.flags & FL_SWIM);
	if (self.spawnflags & SPAWN_CRUCIFIED)
		self.spawnflags = self.spawnflags - (self.spawnflags & SPAWN_CRUCIFIED);
	self.health = 75;
	self.classname = "monster_knight";
	self.frame = $stand1;
	
	self.touch = SUB_Null;	
	self.th_die = SUB_Null;
	self.th_stand = SUB_Null;
	self.th_walk = SUB_Null;
	self.th_run = SUB_Null;
	self.th_melee = SUB_Null;
	self.th_missile = SUB_Null;
	self.th_pain = SUB_Null;
	self.use = SUB_Null;

	self.th_stand = knight_stand1;
	self.th_walk = knight_walk1;
	self.th_run = knight_run1;
	self.th_melee = knight_atk1;
	self.th_pain = knight_pain;
	self.th_die = knight_die;
	self.yaw_speed = 60;
	self.attack_state = 0;
	self.state = 0;
	
	dprint(self.classname);
	dprint("\n");
	self.Converted = "1";

	self.EntityDisplayName = ENTITY_DISPLAY_NAME_KNIGHT;
	RegisterEntity(self.EntityDisplayName);
	walkmonster_start();
};

// Replaces entity with an Ogre
void() ConvertToOgre =
{
	if (deathmatch)
	{
		SUB_Remove();
		return;
	}
	
	dprint("Converted ");
	dprint(self.classname);
	dprint(" to ");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/ogre.mdl");

	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	
	if (!(self.flags & FL_ONGROUND))
		self.flags = self.flags | FL_ONGROUND;
	if (self.flags & FL_FLY)
		self.flags = self.flags - (self.flags & FL_FLY);
	if (self.flags & FL_SWIM)
		self.flags = self.flags - (self.flags & FL_SWIM);
	if (self.spawnflags & SPAWN_CRUCIFIED)
		self.spawnflags = self.spawnflags - (self.spawnflags & SPAWN_CRUCIFIED);
	self.health = 200;
	self.classname = "monster_ogre";
	self.frame = $stand1;
	
	self.touch = SUB_Null;	
	self.th_die = SUB_Null;
	self.th_stand = SUB_Null;
	self.th_walk = SUB_Null;
	self.th_run = SUB_Null;
	self.th_melee = SUB_Null;
	self.th_missile = SUB_Null;
	self.th_pain = SUB_Null;
	self.use = SUB_Null;

	self.th_stand = ogre_stand1;
	self.th_walk = ogre_walk1;
	self.th_run = ogre_run1;
	self.th_die = ogre_die;
	self.th_melee = ogre_melee;
	self.th_missile = ogre_nail1;
	self.th_pain = ogre_pain;
	self.yaw_speed = 60;
	self.attack_state = 0;
	self.state = 0;
	
	dprint(self.classname);
	dprint("\n");
	self.Converted = "1";

	self.EntityDisplayName = ENTITY_DISPLAY_NAME_OGRE;
	RegisterEntity(self.EntityDisplayName);
	walkmonster_start();
};

// Replaces entity with a Vore
void() ConvertToVore =
{
	if (deathmatch)
	{
		SUB_Remove();
		return;
	}
	
	dprint("Converted ");
	dprint(self.classname);
	dprint(" to ");
	
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	
	setmodel (self, "progs/shalrath.mdl");
	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	
	if (!(self.flags & FL_ONGROUND))
		self.flags = self.flags | FL_ONGROUND;
	if (self.flags & FL_FLY)
		self.flags = self.flags - (self.flags & FL_FLY);
	if (self.flags & FL_SWIM)
		self.flags = self.flags - (self.flags & FL_SWIM);
	if (self.spawnflags & SPAWN_CRUCIFIED)
		self.spawnflags = self.spawnflags - (self.spawnflags & SPAWN_CRUCIFIED);
	self.health = 400;
	self.classname = "monster_shalrath";
	self.frame = $stand1;
	
	self.touch = SUB_Null;	
	self.th_die = SUB_Null;
	self.th_stand = SUB_Null;
	self.th_walk = SUB_Null;
	self.th_run = SUB_Null;
	self.th_melee = SUB_Null;
	self.th_missile = SUB_Null;
	self.th_pain = SUB_Null;
	self.use = SUB_Null;

	self.th_stand = shal_stand;
	self.th_walk = shal_walk1;
	self.th_run = shal_run1;
	self.th_die = shalrath_die;
	self.th_pain = shalrath_pain;
	self.th_missile = shal_attack1;
	self.th_melee = shal_attack1;
	self.yaw_speed = 60;
	self.attack_state = 0;
	self.state = 0;

	dprint(self.classname);
	dprint("\n");
	self.Converted = "1";

	self.EntityDisplayName = ENTITY_DISPLAY_NAME_VORE;
	RegisterEntity(self.EntityDisplayName);
	walkmonster_start();
};

// Replaces entity with a Shambler
void() ConvertToShambler =
{
	if (deathmatch)
	{
		SUB_Remove();
		return;
	}
	
	dprint("Converted ");
	dprint(self.classname);
	dprint(" to ");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel (self, "progs/shambler.mdl");

	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	
	if (!(self.flags & FL_ONGROUND))
		self.flags = self.flags | FL_ONGROUND;
	if (self.flags & FL_FLY)
		self.flags = self.flags - (self.flags & FL_FLY);
	if (self.flags & FL_SWIM)
		self.flags = self.flags - (self.flags & FL_SWIM);
	if (self.spawnflags & SPAWN_CRUCIFIED)
		self.spawnflags = self.spawnflags - (self.spawnflags & SPAWN_CRUCIFIED);
	self.health = 600;
	self.classname = "monster_shambler";
	self.frame = $stand1;
	
	self.touch = SUB_Null;	
	self.th_die = SUB_Null;
	self.th_stand = SUB_Null;
	self.th_walk = SUB_Null;
	self.th_run = SUB_Null;
	self.th_melee = SUB_Null;
	self.th_missile = SUB_Null;
	self.th_pain = SUB_Null;
	self.use = SUB_Null;

	self.th_stand = sham_stand1;
	self.th_walk = sham_walk1;
	self.th_run = sham_run1;
	self.th_die = sham_die;
	self.th_melee = sham_melee;
	self.th_missile = sham_magic1;
	self.th_pain = sham_pain;
	self.yaw_speed = 60;
	self.attack_state = 0;
	self.state = 0;
	
	dprint(self.classname);
	dprint("\n");
	self.Converted = "1";

	self.EntityDisplayName = ENTITY_DISPLAY_NAME_SHAMBLER;
	RegisterEntity(self.EntityDisplayName);
	walkmonster_start();
};

// Replaces entity with a Grunt
void() ConvertToGrunt =
{	
	if (deathmatch)
	{
		SUB_Remove();
		return;
	}
	
	dprint("Converted ");
	dprint(self.classname);
	dprint(" to ");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/soldier.mdl");

	setsize (self, '-16 -16 -24', '16 16 40');
	
	if (!(self.flags & FL_ONGROUND))
		self.flags = self.flags | FL_ONGROUND;
	if (self.flags & FL_FLY)
		self.flags = self.flags - (self.flags & FL_FLY);
	if (self.flags & FL_SWIM)
		self.flags = self.flags - (self.flags & FL_SWIM);
	if (self.spawnflags & SPAWN_CRUCIFIED)
		self.spawnflags = self.spawnflags - (self.spawnflags & SPAWN_CRUCIFIED);
	self.health = 30;
	self.classname = "monster_army";
	self.frame = $stand1;
	
	self.touch = SUB_Null;	
	self.th_die = SUB_Null;
	self.th_stand = SUB_Null;
	self.th_walk = SUB_Null;
	self.th_run = SUB_Null;
	self.th_melee = SUB_Null;
	self.th_missile = SUB_Null;
	self.th_pain = SUB_Null;
	self.use = SUB_Null;

	self.th_stand = army_stand1;
	self.th_walk = army_walk1;
	self.th_run = army_run1;
	self.th_missile = army_atk1;
	self.th_pain = army_pain;
	self.th_die = army_die;
	self.th_melee = army_atk1;
	self.yaw_speed = 60;
	self.attack_state = 0;
	self.state = 0;

	dprint(self.classname);
	dprint("\n");
	self.Converted = "1";

	self.EntityDisplayName = ENTITY_DISPLAY_NAME_GRUNT;
	RegisterEntity(self.EntityDisplayName);
	walkmonster_start();
};

// Replaces entity with an Spawn
void() ConvertToSpawn =
{
	if (deathmatch)
	{
		SUB_Remove();
		return;
	}
	
	dprint("Converted ");
	dprint(self.classname);
	dprint(" to ");
	
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/tarbaby.mdl");

	setsize (self, '-16 -16 -24', '16 16 40');
	
	if (!(self.flags & FL_ONGROUND))
		self.flags = self.flags | FL_ONGROUND;
	if (self.flags & FL_FLY)
		self.flags = self.flags - (self.flags & FL_FLY);
	if (self.flags & FL_SWIM)
		self.flags = self.flags - (self.flags & FL_SWIM);
	if (self.spawnflags & SPAWN_CRUCIFIED)
		self.spawnflags = self.spawnflags - (self.spawnflags & SPAWN_CRUCIFIED);
	self.health = 80;
	self.classname = "monster_tarbaby";
	self.frame = $stand1;
	
	self.touch = SUB_Null;	
	self.th_die = SUB_Null;
	self.th_stand = SUB_Null;
	self.th_walk = SUB_Null;
	self.th_run = SUB_Null;
	self.th_melee = SUB_Null;
	self.th_missile = SUB_Null;
	self.th_pain = SUB_Null;
	self.use = SUB_Null;

	self.th_stand = tbaby_stand1;
	self.th_walk = tbaby_walk1;
	self.th_run = tbaby_run1;
	self.th_missile = tbaby_jump1;
	self.th_melee = tbaby_jump1;
	self.th_die = tbaby_die1;
	self.yaw_speed = 60;
	self.attack_state = 0;
	self.state = 0;
	
	dprint(self.classname);
	dprint("\n");
	self.Converted = "1";

	self.EntityDisplayName = ENTITY_DISPLAY_NAME_SPAWN;
	RegisterEntity(self.EntityDisplayName);
	walkmonster_start();
};

// Replaces entity with a Scrag
void() ConvertToScrag =
{
	if (deathmatch)
	{
		SUB_Remove();
		return;
	}
	
	dprint("Converted ");
	dprint(self.classname);
	dprint(" to ");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/wizard.mdl");

	setsize (self, '-16 -16 -24', '16 16 40');

	if (self.flags & FL_ONGROUND)
		self.flags = self.flags - (self.flags & FL_ONGROUND);
	if (!(self.flags & FL_FLY))
		self.flags = self.flags | FL_FLY;
	if (self.flags & FL_SWIM)
		self.flags = self.flags - (self.flags & FL_SWIM);
	if (self.spawnflags & SPAWN_CRUCIFIED)
		self.spawnflags = self.spawnflags - (self.spawnflags & SPAWN_CRUCIFIED);

	self.health = 80;
	self.classname = "monster_wizard";
	self.frame = $stand1;
	
	self.touch = SUB_Null;	
	self.th_die = SUB_Null;
	self.th_stand = SUB_Null;
	self.th_walk = SUB_Null;
	self.th_run = SUB_Null;
	self.th_melee = SUB_Null;
	self.th_missile = SUB_Null;
	self.th_pain = SUB_Null;
	self.use = SUB_Null;

	self.th_stand = wiz_stand1;
	self.th_walk = wiz_walk1;
	self.th_run = wiz_run1;
	self.th_missile = Wiz_Missile;
	self.th_pain = Wiz_Pain;
	self.th_die = wiz_die;
	self.th_melee = Wiz_Missile;
	self.yaw_speed = 60;
	self.attack_state = 0;
	self.state = 0;
		
	dprint(self.classname);
	dprint("\n");
	self.Converted = "1";

	self.EntityDisplayName = ENTITY_DISPLAY_NAME_SCRAG;
	RegisterEntity(self.EntityDisplayName);
	flymonster_start ();
};

// Replaces entity with a (non-crucified) Zombie
void() ConvertToZombie =
{
	if (deathmatch)
	{
		SUB_Remove();
		return;
	}
	
	dprint("Converted ");
	dprint(self.classname);
	dprint(" to ");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/zombie.mdl");

	setsize (self, '-16 -16 -24', '16 16 40');    
	
	if (!(self.flags & FL_ONGROUND))
		self.flags = self.flags | FL_ONGROUND;
	if (self.flags & FL_FLY)
		self.flags = self.flags - (self.flags & FL_FLY);
	if (self.flags & FL_SWIM)
		self.flags = self.flags - (self.flags & FL_SWIM);
	self.health = 60;
	self.classname = "monster_zombie";
	self.frame = $stand1;
	
	self.touch = SUB_Null;	
	self.th_die = SUB_Null;
	self.th_stand = SUB_Null;
	self.th_walk = SUB_Null;
	self.th_run = SUB_Null;
	self.th_melee = SUB_Null;
	self.th_missile = SUB_Null;
	self.th_pain = SUB_Null;
	self.use = SUB_Null;

	self.th_stand = zombie_stand1;
	self.th_walk = zombie_walk1;
	self.th_run = zombie_run1;
	self.th_pain = zombie_pain;
	self.th_die = zombie_die;
	self.th_missile = zombie_missile;
	self.th_melee = zombie_missile;
	self.yaw_speed = 60;
	self.attack_state = 0;
	self.state = 0;

    dprint(self.classname);
	dprint("\n");
	self.Converted = "1";

	self.EntityDisplayName = ENTITY_DISPLAY_NAME_ZOMBIE;
	RegisterEntity(self.EntityDisplayName);
	walkmonster_start();
};

// Replaces entity with a Centroid
void() ConvertToCentroid =
{
	local entity trig;

	if (deathmatch)
	{
		SUB_Remove();
		return;
	}
	
	dprint("Converted ");
	dprint(self.classname);
	dprint(" to ");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	self.classname = "monster_scourge";
	setmodel (self, "progs/scor.mdl");

	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	
	if (!(self.flags & FL_ONGROUND))
		self.flags = self.flags | FL_ONGROUND;
	if (self.flags & FL_FLY)
		self.flags = self.flags - (self.flags & FL_FLY);
	if (self.flags & FL_SWIM)
		self.flags = self.flags - (self.flags & FL_SWIM);
	if (self.spawnflags & SPAWN_CRUCIFIED)
		self.spawnflags = self.spawnflags - (self.spawnflags & SPAWN_CRUCIFIED);

	self.health = 300;	
	
	self.touch = SUB_Null;	
	self.th_die = SUB_Null;
	self.th_stand = SUB_Null;
	self.th_walk = SUB_Null;
	self.th_run = SUB_Null;
	self.th_melee = SUB_Null;
	self.th_missile = SUB_Null;
	self.th_pain = SUB_Null;
	self.use = SUB_Null;

	self.th_stand = scourge_stand1;
	self.th_walk = scourge_walk1;
	self.th_run = scourge_run1;
	self.th_pain = scourge_pain;
	self.th_die = scourge_die;
	self.th_melee = scourge_melee;
	self.th_missile = scourge_atk1;
	self.yaw_speed = 60;
	self.attack_state = AS_DODGING;
	self.state = 0;

    dprint(self.classname);
	dprint("\n");
	self.Converted = "1";

	self.EntityDisplayName = ENTITY_DISPLAY_NAME_CENTROID;
	RegisterEntity(self.EntityDisplayName);
	walkmonster_start();
};

// Replaces entity with a Gremlin
void() ConvertToGremlin =
{
	if (deathmatch)
	{
		SUB_Remove();
		return;
	}
	
	dprint("Converted ");
	dprint(self.classname);
	dprint(" to ");

	NumGremlins = NumGremlins + 1;

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	self.classname = "monster_gremlin";
	setmodel (self, "progs/grem.mdl");

	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	
	if (!(self.flags & FL_ONGROUND))
		self.flags = self.flags | FL_ONGROUND;
	if (self.flags & FL_FLY)
		self.flags = self.flags - (self.flags & FL_FLY);
	if (self.flags & FL_SWIM)
		self.flags = self.flags - (self.flags & FL_SWIM);
	if (self.spawnflags & SPAWN_CRUCIFIED)
		self.spawnflags = self.spawnflags - (self.spawnflags & SPAWN_CRUCIFIED);

	self.health = 100;
	self.max_health = 101;
	self.yaw_speed = 40;
	
	self.touch = SUB_Null;	
	self.th_die = SUB_Null;
	self.th_stand = SUB_Null;
	self.th_walk = SUB_Null;
	self.th_run = SUB_Null;
	self.th_melee = SUB_Null;
	self.th_missile = SUB_Null;
	self.th_pain = SUB_Null;
	self.use = SUB_Null;

	self.th_stand = gremlin_stand1;
	self.th_walk = gremlin_walk1;
	self.th_run = gremlin_run1;
	self.th_die = gremlin_die;
	self.th_melee = Gremlin_MeleeAttack;     // one of two attacks
	self.th_missile = Gremlin_MissileAttack; // check for random jump or firing of weapon
	self.th_pain = gremlin_pain;
	self.attack_state = 0;
	self.state = 0;

    dprint(self.classname);
	dprint("\n");
	self.Converted = "1";

	self.EntityDisplayName = ENTITY_DISPLAY_NAME_GREMLIN;
	RegisterEntity(self.EntityDisplayName);
	walkmonster_start();
};

// Replaces entity with a Spike Mine
void() ConvertToSpikeMine =
{
	if (deathmatch)
	{
		SUB_Remove();
		return;
	}

	local vector fix;

	fix = self.origin;

	dprint("Converted ");
	dprint(self.classname);
	dprint(" to ");

	setmodel (self, "progs/spikmine.mdl");

	setsize (self, self.mins, self.maxs);

	self.classname = "trap_spike_mine";
	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_FLYMISSILE;
	
	if (self.flags & FL_ONGROUND)
	{
		fix_z = fix_z + self.size_z / 2;
		setorigin(self, fix);
		self.flags = self.flags - (self.flags & FL_ONGROUND);
	}
	if (self.flags & FL_FLY)
		self.flags = self.flags - (self.flags & FL_FLY);
	if (!(self.flags & FL_MONSTER))
		self.flags = self.flags | FL_MONSTER;
	if (self.flags & FL_SWIM)
		self.flags = self.flags - (self.flags & FL_SWIM);
	if (self.spawnflags & SPAWN_CRUCIFIED)
		self.spawnflags = self.spawnflags - (self.spawnflags & SPAWN_CRUCIFIED);

	self.avelocity = '-50 100 150';
	if (cvar("skill") <= 1)
		self.health = 200;
	else
		self.health = 400;
	self.frame = 0;
	
	self.touch = SUB_Null;	
	self.th_die = SUB_Null;
	self.th_stand = SUB_Null;
	self.th_walk = SUB_Null;
	self.th_run = SUB_Null;
	self.th_melee = SUB_Null;
	self.th_missile = SUB_Null;
	self.th_pain = SUB_Null;
	self.use = SUB_Null;

	self.touch = spikemine_Touch;
	self.th_die = spikemine_Touch;
	self.th_stand = spikemine_Home;
	self.th_walk = spikemine_Home;
	self.th_run = spikemine_Home;
	self.th_melee = spikemine_Home;
	self.th_missile = spikemine_Home;
	self.think = spike_mine_first_think;
	self.yaw_speed = 60;
	self.attack_state = 0;
	self.state = 0;

	self.nextthink = time + 0.2;
	self.deathtype = "";
	self.EntityDisplayName = ENTITY_DISPLAY_NAME_SPIKE_MINE;
	self.Converted = "1";
	RegisterEntity(self.EntityDisplayName);
};

// END MONSTERS

void(entity e) ConvertFuncSpawn =
{
	e.solid = SOLID_NOT;
	e.movetype = MOVETYPE_NONE;
	e.modelindex = 0;
	e.model = "";
	setmodel (e, e.model);
	e.use = spawn_use_random;
};


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
		RegisterEntity(ENTITY_DISPLAY_NAME_HEALTH_15);
	}
	else if (self.QualityType == 2)
	{		
		setmodel(self, "maps/b_bh25.bsp");
		self.noise = "items/health1.wav";
		self.healamount = 25;
		self.healtype = 1;
		RegisterEntity(ENTITY_DISPLAY_NAME_HEALTH_25);
	}
	else if (self.QualityType == 3)
	{
		setmodel(self, "maps/b_bh100.bsp");
		self.noise = "items/r_item2.wav";
		self.healamount = 100;
		self.healtype = 2;
		RegisterEntity(ENTITY_DISPLAY_NAME_HEALTH_100);
	}
	setsize (self, '0 0 0', '32 32 56');
	dprint(self.classname);
	dprint(" (");
	dprint(ftos(self.healamount));
	dprint(")");
	dprint("\n");
	self.Converted = "1";
	StartItem ();
};

// Converts item into an Armor suit
// "type" contains whether it's a Green Armor, Yellow Armor or Red Armor
// If there's nearby armor, it will turn into a Health Pack of the same quality instead.
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
		RegisterEntity(ENTITY_DISPLAY_NAME_ARMOR_100);
    }
    else if (self.QualityType == 2)
    {
    	self.classname = "item_armor2";
		RegisterEntity(ENTITY_DISPLAY_NAME_ARMOR_150);
    }
    else if (self.QualityType == 3)
    {
    	self.classname = "item_armorInv";
		RegisterEntity(ENTITY_DISPLAY_NAME_ARMOR_200);
    }
	setsize (self, '-16 -16 0', '16 16 56');
	dprint(self.classname);
	dprint("\n");
	self.Converted = "1";
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
		RegisterEntity(ENTITY_DISPLAY_NAME_SHELLS_SMALL);
	}
	else if (self.QualityType == 2)
	{
		setmodel (self, "maps/b_shell1.bsp");
		self.aflag = 40;
		RegisterEntity(ENTITY_DISPLAY_NAME_SHELLS_BIG);
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
	self.Converted = "1";
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
		RegisterEntity(ENTITY_DISPLAY_NAME_NAILS_SMALL);
		self.aflag = 25;
	}
	else if (self.QualityType == 2)
	{
		setmodel (self, "maps/b_nail1.bsp");
		RegisterEntity(ENTITY_DISPLAY_NAME_NAILS_BIG);
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
	self.Converted = "1";
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
		RegisterEntity(ENTITY_DISPLAY_NAME_ROCKETS_SMALL);
		self.aflag = 5;
	}
	else if (self.QualityType == 2)
	{
		setmodel (self, "maps/b_rock1.bsp");
		RegisterEntity(ENTITY_DISPLAY_NAME_ROCKETS_BIG);
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
	self.Converted = "1";
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
		RegisterEntity(ENTITY_DISPLAY_NAME_CELLS_SMALL);
		self.aflag = 6;
	}
	else if (self.QualityType == 2)
	{
		setmodel (self, "maps/b_batt1.bsp");
		RegisterEntity(ENTITY_DISPLAY_NAME_CELLS_BIG);
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
	self.Converted = "1";
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
	self.Converted = "1";
	StartItem ();
	RegisterEntity(ENTITY_DISPLAY_NAME_PENTAGRAM_OF_PROTECTION);
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
	self.Converted = "1";
	StartItem ();
	RegisterEntity(ENTITY_DISPLAY_NAME_BIOSUIT);
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
	self.Converted = "1";
	StartItem ();
	RegisterEntity(ENTITY_DISPLAY_NAME_RING_OF_SHADOWS);
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
	self.Converted = "1";
	StartItem ();
	RegisterEntity(ENTITY_DISPLAY_NAME_QUAD_DAMAGE);
};

// Converts entity into Empathy Shields
void() ConvertToEmpathyShields =
{	
	dprint("Converted ");
	dprint(self.classname);
	dprint(" to ");

	self.touch = hip_powerup_touch;
	self.classname = "item_artifact_empathy_shields";

	setmodel(self, "progs/empathy.mdl");
	self.noise = "hipitems/empathy.wav";
	self.netname = "Empathy Shields";
	self.items2 = HIP_IT_EMPATHY_SHIELDS;
	self.skin = 0;
	setsize (self, '-16 -16 0', '16 16 32');

	dprint(self.classname);
	dprint("\n");
	self.Converted = "1";
	StartItem ();
	RegisterEntity(ENTITY_DISPLAY_NAME_EMPATHY_SHIELDS);
};

// Converts entity into a Wetsuit
void() ConvertToWetsuit =
{	
	dprint("Converted ");
	dprint(self.classname);
	dprint(" to ");

	self.touch = hip_powerup_touch;
	self.classname = "item_artifact_wetsuit";

	self.noise = "misc/weton.wav";
	setmodel (self, "progs/wetsuit.mdl");
	self.netname = "Wetsuit";
	self.items2 = HIP_IT_WETSUIT;
	self.skin = 0;
	setsize (self, '-16 -16 -24', '16 16 32');

	dprint(self.classname);
	dprint("\n");
	self.Converted = "1";
	StartItem ();
	RegisterEntity(ENTITY_DISPLAY_NAME_WETSUIT);
};

// Converts entity into a Horn of Conjuring
// It also produces a spawn to produce the conjured monster
void() ConvertToHornOfConjuring =
{	
	dprint("Converted ");
	dprint(self.classname);
	dprint(" to ");

	self.classname = "item_hornofconjuring";
	self.touch = horn_touch_random;
	setmodel(self, "progs/horn.mdl");
	self.noise = "hipitems/horn.wav";
	self.netname = "Horn of Conjuring";
	self.skin = 0;
	setsize (self, '-16 -16 0', '16 16 32');

	dprint(self.classname);
	dprint("\n");
	self.Converted = "1";
	StartItem ();
	RegisterEntity(ENTITY_DISPLAY_NAME_HORN_OF_CONJURING);
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
	self.Converted = "1";
	StartItem ();
	RegisterEntity(ENTITY_DISPLAY_NAME_DOUBLE_BARRELED_SHOTGUN);
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
	self.netname = "Nailgun";
	self.touch = weapon_touch;
	self.skin = 0;
	setsize (self, '-16 -16 0', '16 16 56');
	dprint(self.classname);
	dprint("\n");
	self.Converted = "1";
	StartItem ();
	RegisterEntity(ENTITY_DISPLAY_NAME_NAILGUN);
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
	self.Converted = "1";
	StartItem ();
	RegisterEntity(ENTITY_DISPLAY_NAME_SUPER_NAILGUN);
};

// Converts entity into a Grenade Launcher
void() ConvertToGrenadeLauncher =
{	
	dprint("Converted ");
	dprint(self.classname);
	dprint(" to ");

	setmodel (self, "progs/g_rock.mdl");
	self.classname = "weapon_grenadelauncher";
	self.weapon = IT_GRENADE_LAUNCHER;
	self.netname = "Grenade Launcher";
	self.touch = weapon_touch;
	self.skin = 0;
	setsize (self, '-16 -16 0', '16 16 56');
	dprint(self.classname);
	dprint("\n");
	self.Converted = "1";
	StartItem ();
	RegisterEntity(ENTITY_DISPLAY_NAME_GRENADE_LAUNCHER);
};

// Converts entity into a Rocket Launcher
void() ConvertToRocketLauncher =
{	
	dprint("Converted ");
	dprint(self.classname);
	dprint(" to ");

	setmodel (self, "progs/g_rock2.mdl");
	self.classname = "weapon_rocketlauncher";
	self.weapon = IT_ROCKET_LAUNCHER;
	self.netname = "Rocket Launcher";
	self.touch = weapon_touch;
	self.skin = 0;
	setsize (self, '-16 -16 0', '16 16 56');
	dprint(self.classname);
	dprint("\n");
	self.Converted = "1";
	StartItem ();
	RegisterEntity(ENTITY_DISPLAY_NAME_ROCKET_LAUNCHER);
};

// Converts entity into a Thunderbolt
void() ConvertToThunderbolt =
{	
	dprint("Converted ");
	dprint(self.classname);
	dprint(" to ");

	setmodel (self, "progs/g_light.mdl");
	self.classname = "weapon_lightning";
	self.weapon = IT_LIGHTNING;
	self.netname = "Thunderbolt";
	self.touch = weapon_touch;
	self.skin = 0;
	setsize (self, '-16 -16 0', '16 16 56');
	dprint(self.classname);
	dprint("\n");
	self.Converted = "1";
	StartItem ();
	RegisterEntity(ENTITY_DISPLAY_NAME_THUNDERBOLT);
};

// Converts entity into a Laser Cannon
void() ConvertToLaserCannon =
{	
	dprint("Converted ");
	dprint(self.classname);
	dprint(" to ");
	
	setmodel (self, "progs/g_laserg.mdl");
	self.classname = "weapon_laser_gun";
	self.weapon = 3;
   	self.netname = "Laser Cannon";
   	self.items = IT_LASER_CANNON;
   	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
	
	dprint(self.classname);
	dprint("\n");
	self.Converted = "1";
	StartItem ();
	RegisterEntity(ENTITY_DISPLAY_NAME_LASER_CANNON);
};

// Converts entity into a Proximity Gun
void() ConvertToProximityGun =
{	
	dprint("Converted ");
	dprint(self.classname);
	dprint(" to ");
	
	setmodel (self, "progs/g_prox.mdl");
	self.classname = "weapon_proximity_gun";
	self.weapon = 3;
	self.netname = "Proximity Gun";
	self.items = IT_PROXIMITY_GUN;
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
	
	dprint(self.classname);
	dprint("\n");
	self.Converted = "1";
	StartItem ();
	RegisterEntity(ENTITY_DISPLAY_NAME_PROXIMITY_GUN);
};

// Converts entity into a Mjolnir
void() ConvertToMjolnir =
{	
	dprint("Converted ");
	dprint(self.classname);
	dprint(" to ");
	
	setmodel (self, "progs/g_hammer.mdl");
	self.classname = "weapon_mjolnir";
	self.weapon = 3;
	self.netname = "Mjolnir";
	self.items = IT_MJOLNIR;
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	StartItem ();
	
	dprint(self.classname);
	dprint("\n");
	self.Converted = "1";
	StartItem ();
	RegisterEntity(ENTITY_DISPLAY_NAME_MJOLNIR);
};

// END WEAPONS

// START BACKPACKS

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
		RegisterEntity(ENTITY_DISPLAY_NAME_BACKPACK_DOUBLE_BARRELED_SHOTGUN);
	}
	else if (self.PickupType == IT_NAILGUN)
	{
		self.classname = "item_backpack_nailgun";
		self.netname = "Nailgun";
		self.ammo_nails = 30;
		RegisterEntity(ENTITY_DISPLAY_NAME_BACKPACK_NAILGUN);
	}
	else if (self.PickupType == IT_SUPER_NAILGUN)
	{
		self.classname = "item_backpack_supernailgun";
		self.netname = "Super Nailgun";
		self.ammo_nails = 30;
		RegisterEntity(ENTITY_DISPLAY_NAME_BACKPACK_SUPER_NAILGUN);
	}
	else if (self.PickupType == IT_GRENADE_LAUNCHER)
	{
		self.classname = "item_backpack_grenadelauncher";
		self.netname = "Grenade Launcher";
		self.ammo_rockets = 5;
		RegisterEntity(ENTITY_DISPLAY_NAME_BACKPACK_GRENADE_LAUNCHER);
	}
	else if (self.PickupType == IT_ROCKET_LAUNCHER)
	{
		self.classname = "item_backpack_rocketlauncher";
		self.netname = "Rocket Launcher";
		self.ammo_rockets = 5;
		RegisterEntity(ENTITY_DISPLAY_NAME_BACKPACK_ROCKET_LAUNCHER);
	}
	else if (self.PickupType == IT_LIGHTNING)
	{
		self.classname = "item_backpack_lightning";
		self.netname = "Thunderbolt";
		self.ammo_cells = 15;
		RegisterEntity(ENTITY_DISPLAY_NAME_BACKPACK_THUNDERBOLT);
	}
	else if (self.PickupType == IT_LASER_CANNON)
	{
		self.classname = "item_backpack_laser_gun";
		self.netname = "Laser Cannon";
		self.ammo_cells = 30;
		RegisterEntity(ENTITY_DISPLAY_NAME_BACKPACK_LASER_CANNON);
	}
	else if (self.PickupType == IT_PROXIMITY_GUN)
	{
		self.classname = "item_backpack_proximity_gun";
		self.netname = "Proximity Gun";
		self.ammo_rockets = 6;
		RegisterEntity(ENTITY_DISPLAY_NAME_BACKPACK_PROXIMITY_GUN);
	}
	else if (self.PickupType == IT_MJOLNIR)
	{
		self.classname = "item_backpack_mjolnir";
		self.netname = "Mjolnir";
		self.ammo_cells = 30;
		RegisterEntity(ENTITY_DISPLAY_NAME_BACKPACK_MJOLNIR);
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
	self.Converted = "1";
	self.origin_z = self.origin_z + 24;
	droptofloor();
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
		{
			self.ammo_shells = 20;
			RegisterEntity(ENTITY_DISPLAY_NAME_BACKPACK_SHELLS_SMALL);
		}
		else if(self.QualityType == 2)
		{
			self.ammo_shells = 40;
			RegisterEntity(ENTITY_DISPLAY_NAME_BACKPACK_SHELLS_BIG);
		}
		dprint(self.classname);
		dprint(" (");
		dprint(ftos(self.ammo_shells));
		dprint(")");
	}
	else if (self.PickupType == 2) // Nails
	{
		self.classname = "item_backpack_spikes";
		if(self.QualityType == 1)
		{	
			self.ammo_nails = 25;
			RegisterEntity(ENTITY_DISPLAY_NAME_BACKPACK_NAILS_SMALL);
		}
		else if(self.QualityType == 2)
		{	
			self.ammo_nails = 50;
			RegisterEntity(ENTITY_DISPLAY_NAME_BACKPACK_NAILS_BIG);
		}
		dprint(self.classname);
		dprint(" (");
		dprint(ftos(self.ammo_nails));
		dprint(")");
	}
	else if (self.PickupType == 3) // Rockets
	{
		self.classname = "item_backpack_rockets";
		if(self.QualityType == 1)
		{
			self.ammo_rockets = 5;
			RegisterEntity(ENTITY_DISPLAY_NAME_BACKPACK_ROCKETS_SMALL);
		}
		else if(self.QualityType == 2)
		{
			self.ammo_rockets = 10;
			RegisterEntity(ENTITY_DISPLAY_NAME_BACKPACK_ROCKETS_BIG);
		}
		dprint(self.classname);
		dprint(" (");
		dprint(ftos(self.ammo_rockets));
		dprint(")");
	}
	else if (self.PickupType == 4) // Cells
	{
		self.classname = "item_backpack_cells";
		if(self.QualityType == 1)
		{
			self.ammo_cells = 6;
			RegisterEntity(ENTITY_DISPLAY_NAME_BACKPACK_CELLS_SMALL);
		}
		else if(self.QualityType == 2)
		{
			self.ammo_cells = 12;
			RegisterEntity(ENTITY_DISPLAY_NAME_BACKPACK_CELLS_BIG);
		}
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
	self.Converted = "1";
	self.origin_z = self.origin_z + 24;
	droptofloor();
	StartItem ();
};

// END BACKPACKS