/*
*/
//JIM
void( vector pos ) placebullethole;
void (entity targ, entity inflictor, entity attacker, float damage) T_Damage;
void () player_run;
void(entity bomb, entity attacker, float rad, entity ignore) T_RadiusDamage;
void(vector org, vector vel, float damage) SpawnBlood;
void() SuperDamageSound;

//MED 10/18/96
void(float damage) spawn_touchblood;
/*
================
HIPNOTIC WEAPONS
================
*/
void() HIP_LaserTouch =
{
	local vector org;
   local vector spot1,spot2;
   local vector oldvel;
   local float mag;
   local float r;

   self.owner = world;
   self.cnt = self.cnt + 1;
   if (pointcontents(self.origin) == CONTENT_SKY)
	{
		SUB_Remove();
		return;
	}
   oldvel = normalize(self.old_velocity);
   spot1 = self.origin - (16*oldvel);
   spot2 = self.origin + (16*oldvel);
   traceline (spot1, spot2, FALSE, self);  // see through other monsters
   self.origin = trace_endpos;

   org = self.origin;

	if (other.health)
      {
      if (self.lastvictim == other)
         {
         self.dmg = self.dmg / 2;
         }
      spawn_touchblood (self.dmg);
      T_Damage (other, self, self.lastvictim, self.dmg);
      }
   else if ((self.cnt == 3) || (random()<0.15))
      {
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);
      }
   else
      {
//      self.dmg = 0.66 * self.dmg;
      self.dmg = 0.9 * self.dmg;
//      self.speed = 0.95 * self.speed;
      self.velocity = oldvel+(2*trace_plane_normal);
      self.velocity = normalize(self.velocity);
      self.velocity = self.speed * self.velocity;
      self.old_velocity = self.velocity;
      if (self.flags & FL_ONGROUND)
         self.flags = self.flags - FL_ONGROUND;
      r = random();
      sound (self, CHAN_WEAPON, "hipweap/laserric.wav", 1, ATTN_STATIC);
/*
      if (r<0.33)
         sound (self, CHAN_WEAPON, "weapons/ric1.wav", 1, ATTN_STATIC);
      else if (r<0.66)
         sound (self, CHAN_WEAPON, "weapons/ric2.wav", 1, ATTN_STATIC);
      else
         sound (self, CHAN_WEAPON, "weapons/ric3.wav", 1, ATTN_STATIC);
*/
      return;
      }
   sound (self, CHAN_WEAPON, "enforcer/enfstop.wav", 1, ATTN_STATIC);
   SUB_Remove();

};
void() HIP_LaserThink =
   {
   local float delta;


   if (time>self.attack_finished)
      {
      SUB_Remove();
      return;
      }
   if (self.flags & FL_ONGROUND)
      self.flags = self.flags - FL_ONGROUND;
   self.velocity = self.old_velocity;
   self.angles = vectoangles(self.velocity);
   self.nextthink = time+0.1;
   };

void(vector org, vector vec, float light) HIP_LaunchLaser =
{
//   sound (self ,CHAN_WEAPON, "weapons/shotgn2.wav", 1, ATTN_NORM);
   sound (self ,CHAN_WEAPON, "hipweap/laserg.wav", 1, ATTN_NORM);

   vec = normalize(vec);

	newmis = spawn();
   newmis.owner = self;
   newmis.classname = "hiplaser";
   newmis.lastvictim = self;
   newmis.movetype = MOVETYPE_FLYMISSILE;
   newmis.solid = SOLID_BBOX;
   if (light)
      newmis.effects = EF_DIMLIGHT;

   setmodel (newmis, "progs/lasrspik.mdl");
	setsize (newmis, '0 0 0', '0 0 0');

	setorigin (newmis, org);

   newmis.speed = 1000;
   newmis.dmg = 18;
   newmis.velocity = vec * newmis.speed;
   newmis.old_velocity = newmis.velocity;
   newmis.angles = vectoangles(newmis.velocity);
   newmis.avelocity = '0 0 400';

   newmis.nextthink = time;
   newmis.attack_finished = time + 5;
   newmis.think = HIP_LaserThink;
   newmis.touch = HIP_LaserTouch;
   newmis.count = 0;

};

/*
=================
HIP_FireLaser
=================
*/
void(float stat) HIP_FireLaser =
   {
	local vector org;
   local vector dir;
   local vector out;
   local float ofs;
   local float aofs;

   if (!self.button0)
      {
      player_run ();
      return;
      }
   if (self.ammo_standard_cells < 1)
      {
		self.weapon = W_BestWeapon ();
		W_SetCurrentAmmo ();
		return;
      }
   SuperDamageSound();
   self.effects = self.effects | EF_MUZZLEFLASH;
   makevectors (self.v_angle);

   ofs = 6;
   out = v_forward;
   out_z = 0;
   out = normalize(out);
   org = self.origin + ((12-ofs) * v_up) + (12*out);
//   org = self.origin + (1*v_forward);
   dir = aim (self, 1000);
   aofs = ofs * 0.707;
   if (stat == 0)
      {
      self.currentammo = self.ammo_standard_cells = self.ammo_standard_cells - 1;
      org = org + (aofs*v_right);
      org = org - (aofs*v_up);
      HIP_LaunchLaser(org, dir, 0);
      org = org - (2*aofs*v_right);
      HIP_LaunchLaser(org, dir, 0);
      }
   else if (stat == 1)
      {
      self.currentammo = self.ammo_standard_cells = self.ammo_standard_cells - 1;
      org = org + (ofs*v_up);
      if (random()<0.1)
         {
         HIP_LaunchLaser(org, dir, 1);
         newmis.dmg = 25;
         }
      else
         HIP_LaunchLaser(org, dir, 0);
      }
   self.punchangle_x = -1;
   };

/*
=================
HIP_HammerDamage
=================
*/
void(vector p1, vector p2, entity from, float damage) HIP_HammerDamage =
{
	local entity		e1, e2;
	local vector		f;

	f = p2 - p1;
	normalize (f);
	f_x = 0 - f_y;
	f_y = f_x;
	f_z = 0;
	f = f*16;

	e1 = e2 = world;

	traceline (p1, p2, FALSE, self);
//JIM
	if (trace_ent.takedamage && !trace_ent.wetsuit_finished )
	{
		particle (trace_endpos, '0 0 100', 225, damage*4);
		T_Damage (trace_ent, from, from, damage);
		if (self.classname == "player")
		{
			if (other.classname == "player")
				trace_ent.velocity_z = trace_ent.velocity_z + 400;
		}
	}
	e1 = trace_ent;

	traceline (p1 + f, p2 + f, FALSE, self);
//JIM
	if (trace_ent != e1 && trace_ent.takedamage &&
		!trace_ent.wetsuit_finished )
	{
		particle (trace_endpos, '0 0 100', 225, damage*4);
		T_Damage (trace_ent, from, from, damage);
	}
	e2 = trace_ent;

	traceline (p1 - f, p2 - f, FALSE, self);
//JIM
	if (trace_ent != e1 && trace_ent != e2 && trace_ent.takedamage &&
		!trace_ent.wetsuit_finished )
	{
		particle (trace_endpos, '0 0 100', 225, damage*4);
		T_Damage (trace_ent, from, from, damage);
	}
};

/*
void() HIP_DiversionLightningThink =
   {
   local vector   org,end;

   if (time > self.delay)
      {
      SUB_Remove();
      return;
      }

   makevectors(self.v_angle);
   org = self.origin;
   end = org + v_forward*200;
//   end = end + (((200*random()) - 100) * v_up);
   end = end + (((400*random()) - 200) * v_right);

   traceline (org, end, TRUE, self);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING2);
	WriteEntity (MSG_BROADCAST, self);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
   WriteCoord (MSG_BROADCAST, trace_endpos_x);
   WriteCoord (MSG_BROADCAST, trace_endpos_y);
   WriteCoord (MSG_BROADCAST, trace_endpos_z);

   self.nextthink = time + 0.1;
   };
*/

//void(entity prev, entity owner, float dst) HIP_SpawnMjolnirLightning;
void() HIP_LightningThink =
   {
   local vector org;
   local vector dst;
   local entity head;
   local entity selected;
   local float cur_dist;
   local float head_dist;
   local vector vec;
   local float dot;
   local float oldstate;
   local float dam;


   if (time > self.delay)
      {
      if (self.enemy != world)
         self.enemy.struck_by_mjolnir = 0;
      SUB_Remove();
      return;
      }
   oldstate = self.state;
   if (self.state==0)
      {
      // look in our immediate vicinity
      self.enemy = world;
      selected = world;
      cur_dist = self.distance;
      head = findradius(self.owner.origin, self.distance);
      while(head)
         {
         if(!(head.flags & FL_NOTARGET) && ((head.flags & FL_MONSTER) || (head.flags & FL_CLIENT)))
            {
//            if (visible(head) && (head!=self.owner.owner) && (head.health>0))
            if ((visible(head)) && (head!=self.owner.owner) && (head.health>0))
               {
               head_dist = vlen(head.origin - self.lastvictim.origin);
               if ((head_dist<cur_dist) && (head.struck_by_mjolnir==0))
                  {
                  selected = head;
                  cur_dist = head_dist;
                  }
               }
            }
         head = head.chain;
         }
      if (selected != world)
         {
         self.state = 1;
         self.enemy = selected;
         self.enemy.struck_by_mjolnir = 1;
         }
      else
         {
         local vector  end;

         makevectors(self.v_angle);
         org = self.owner.origin;
         end = org + v_forward*200;
         end = end + (((400*random()) - 200) * v_right);

         traceline (org, end, TRUE, self);

         WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
         WriteByte (MSG_BROADCAST, TE_LIGHTNING2);
         WriteEntity (MSG_BROADCAST, self);
         WriteCoord (MSG_BROADCAST, org_x);
         WriteCoord (MSG_BROADCAST, org_y);
         WriteCoord (MSG_BROADCAST, org_z);
         WriteCoord (MSG_BROADCAST, trace_endpos_x);
         WriteCoord (MSG_BROADCAST, trace_endpos_y);
         WriteCoord (MSG_BROADCAST, trace_endpos_z);

         self.nextthink = time + 0.1;
//         self.think = HIP_DiversionLightningThink;
//         self.nextthink = time;
//         self.delay = time + 0.30;
//         self.origin = self.owner.origin;
//         self.think();
         return;
         }
      }
   org = self.lastvictim.origin;
   dst = self.enemy.absmin + 0.25*(self.enemy.absmax-self.enemy.absmin);
   dst = dst + (random()*0.5*(self.enemy.absmax-self.enemy.absmin));
   traceline (org, dst, TRUE, self.owner.owner);

   if (trace_fraction != 1.0 || self.enemy.health<=0)
      {
      self.enemy.struck_by_mjolnir = 0;
      self.state = 0;
      self.nextthink = time + 0.1;
      return;
      }
   WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
   WriteByte (MSG_BROADCAST, TE_LIGHTNING2);
   WriteEntity (MSG_BROADCAST, self);
   WriteCoord (MSG_BROADCAST, org_x);
   WriteCoord (MSG_BROADCAST, org_y);
   WriteCoord (MSG_BROADCAST, org_z);
   WriteCoord (MSG_BROADCAST, trace_endpos_x);
   WriteCoord (MSG_BROADCAST, trace_endpos_y);
   WriteCoord (MSG_BROADCAST, trace_endpos_z);
   vec = normalize(self.enemy.origin - self.owner.origin);
   dot = vec * self.owner.movedir;
   head = self;
   self = self.owner.owner;
   if (oldstate==0)
      dam = 80;
   else
      dam = 30;
   if (dot>0.3)
      HIP_HammerDamage (org, trace_endpos, self, dam);
   else
      HIP_HammerDamage (org, trace_endpos, self, dam*0.5);
   self = head;

   self.nextthink = time + 0.2;
   };

void(entity prev, entity own, float dst) HIP_SpawnMjolnirLightning =
   {
   local entity light;
   // spawn actual lightning
   light = spawn();
   light.delay = time + 0.8;
   light.state = 0;
   light.lastvictim = prev;
   light.distance = dst;
   light.owner = own;
   light.v_angle = self.angles;
   light.v_angle_x = 0;
   light.v_angle_z = 0;
   light.origin = own.origin;
   light.think = HIP_LightningThink;
   light.nextthink = time;
   };

void() HIP_SpawnMjolnirBase =
   {
   local entity light;
   // spawn lightning base
   light = spawn();
//   light.origin = self.origin - '0 0 24' + (32*v_forward);
   light.origin = trace_endpos;
   light.flags = 0;
   light.owner = self;
   light.struck_by_mjolnir = 1;
   light.think = SUB_Remove;
   light.nextthink = time + 1;
   sound (light, CHAN_AUTO, "hipweap/mjolslap.wav", 1, ATTN_NORM);
   sound (light, CHAN_WEAPON, "hipweap/mjolhit.wav", 1, ATTN_NORM);
   makevectors(self.v_angle);
   light.movedir = v_forward;
   HIP_SpawnMjolnirLightning( light, light, 350 );
   HIP_SpawnMjolnirLightning( light, light, 350 );
   HIP_SpawnMjolnirLightning( light, light, 350 );
   HIP_SpawnMjolnirLightning( light, light, 350 );
   };

void() HIP_FireMjolnirLightning =
   {
   local vector   org;
	local	float		cells;

// explode if under water
	if (self.waterlevel > 1)
	{
		cells = self.ammo_standard_cells;
		self.ammo_standard_cells = 0;
      discharged = 1;
		T_RadiusDamage (self, self, 35*cells, world);
      discharged = 0;
		W_SetCurrentAmmo ();
		return;
	}

//   if (self.t_width < time)
//   {
//      sound (self, CHAN_WEAPON, "weapons/lhit.wav", 1, ATTN_NORM);
//      self.t_width = time + 0.6;
//   }
//   self.punchangle_x = 12;

   self.currentammo = self.ammo_standard_cells = self.ammo_standard_cells - 15;

   HIP_SpawnMjolnirBase();
   };

void() HIP_FireMjolnir =
   {
   local vector   org;
	local	float		cells;
   local float    damage;
   local vector   source;
   local vector   ang;


   self.attack_finished = time + 0.4;
   source = self.origin + '0 0 16';
//   ang = self.angles;
//   ang_x = 0;
//   ang_y = 0;
   makevectors(self.v_angle);
   traceline (source, source + v_forward*32, FALSE, self);
   if (trace_fraction == 1.0 && (self.ammo_standard_cells >= 15))
      {
      source = source + v_forward*32;
      traceline (source , source - v_up*50, FALSE, self);
//      dprint("fraction = ");
//      dprint(ftos(trace_fraction));
//      dprint("\n");
      if (trace_fraction > 0.3 && trace_fraction< 1.0)
         {
         HIP_FireMjolnirLightning();
         self.attack_finished = time + 1.5;
         return;
         }
      }
   org = trace_endpos - v_forward*4;

   if (trace_ent.takedamage)
      {
      damage = 50;
      if (trace_ent.classname == "monster_zombie")
         damage = 70;
      trace_ent.axhitme = 1;
      SpawnBlood (org, v_forward, damage);
      T_Damage (trace_ent, self, self, damage);
      }
   else
      {  // hit wall
      if (trace_fraction != 1.0)
         {
//         sound (self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM);
         sound (self, CHAN_WEAPON, "hipweap/mjoltink.wav", 1, ATTN_NORM);
         WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
         WriteByte (MSG_BROADCAST, TE_GUNSHOT);
         WriteCoord (MSG_BROADCAST, org_x);
         WriteCoord (MSG_BROADCAST, org_y);
         WriteCoord (MSG_BROADCAST, org_z);
         }
      else
         {
         sound (self, CHAN_WEAPON, "knight/sword1.wav", 1, ATTN_NORM);
         }
      }
   self.attack_finished = time + 0.4;

   };

// called by worldspawn
void() W_Precache =
{
	precache_sound ("weapons/r_exp3.wav");	// new rocket explosion
	precache_sound ("weapons/rocket1i.wav");	// spike gun
	precache_sound ("weapons/sgun1.wav");
	precache_sound ("weapons/guncock.wav");	// player shotgun
	precache_sound ("weapons/ric1.wav");	// ricochet (used in c code)
	precache_sound ("weapons/ric2.wav");	// ricochet (used in c code)
	precache_sound ("weapons/ric3.wav");	// ricochet (used in c code)
	precache_sound ("weapons/spike2.wav");	// super spikes
	precache_sound ("weapons/tink1.wav");	// spikes tink (used in c code)
	precache_sound ("weapons/grenade.wav");	// grenade launcher
	precache_sound ("weapons/bounce.wav");		// grenade bounce
	precache_sound ("weapons/shotgn2.wav");	// super shotgun
//MED
   precache_sound ("enforcer/enfstop.wav");   // laser cannon
//MED 11/06/96
   precache_sound ("knight/sword1.wav");   // laser cannon
   precache_sound ("hipweap/laserg.wav");   // laser cannon
   precache_sound ("hipweap/laserric.wav");   // laser cannon ricochet
   precache_sound ("hipweap/proxwarn.wav");   // proximity bomb
   precache_sound ("hipweap/proxbomb.wav");   // proximity bomb
//MED 11/19/96
   precache_sound ("hipweap/mjolhit.wav");   // mjolnir
   precache_sound ("hipweap/mjolslap.wav");   // mjolnir
   precache_sound ("hipweap/mjoltink.wav");   // mjolnir
};

float() crandom =
{
	return 2*(random() - 0.5);
};

/*
================
W_FireAxe
================
*/
void() W_FireAxe =
{
	local	vector	source;
	local	vector	org;

   makevectors (self.v_angle);
   source = self.origin + '0 0 16';
	traceline (source, source + v_forward*64, FALSE, self);
	if (trace_fraction == 1.0)
		return;

	org = trace_endpos - v_forward*4;

	if (trace_ent.takedamage)
	{
		trace_ent.axhitme = 1;
		SpawnBlood (org, '0 0 0', 20);
		T_Damage (trace_ent, self, self, 20);
	}
	else
	{	// hit wall
		sound (self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM);
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);
	}
};


//============================================================================


vector() wall_velocity =
{
	local vector	vel;

	vel = normalize (self.velocity);
	vel = normalize(vel + v_up*(random()- 0.5) + v_right*(random()- 0.5));
	vel = vel + 2*trace_plane_normal;
	vel = vel * 200;

	return vel;
};


/*
================
SpawnMeatSpray
================
*/
void(vector org, vector vel) SpawnMeatSpray =
{
	local	entity missile, mpuff;

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_NOT;

	makevectors (self.angles);

	missile.velocity = vel;
	missile.velocity_z = missile.velocity_z + 250 + 50*random();

	missile.avelocity = '3000 1000 2000';

// set missile duration
	missile.nextthink = time + 1;
	missile.think = SUB_Remove;

	setmodel (missile, "progs/zom_gib.mdl");
	setsize (missile, '0 0 0', '0 0 0');
	setorigin (missile, org);
};

/*
================
SpawnBlood
================
*/
void(vector org, vector vel, float damage) SpawnBlood =
{
	particle (org, vel*0.1, 73, damage*2);
};

/*
================
spawn_touchblood
================
*/
void(float damage) spawn_touchblood =
{
	local vector	vel;

	vel = wall_velocity () * 0.2;
	SpawnBlood (self.origin + vel*0.01, vel, damage);
};


/*
================
SpawnChunk
================
*/
void(vector org, vector vel) SpawnChunk =
{
	particle (org, vel*0.02, 0, 10);
};

/*
==============================================================================

MULTI-DAMAGE

Collects multiple small damages into a single damage

==============================================================================
*/

entity	multi_ent;
float	multi_damage;

void() ClearMultiDamage =
{
	multi_ent = world;
	multi_damage = 0;
};

void() ApplyMultiDamage =
{
	if (!multi_ent)
		return;
	T_Damage (multi_ent, self, self, multi_damage);
};

void(entity hit, float damage) AddMultiDamage =
{
	if (!hit)
		return;

	if (hit != multi_ent)
	{
		ApplyMultiDamage ();
		multi_damage = damage;
		multi_ent = hit;
	}
	else
		multi_damage = multi_damage + damage;
};

/*
==============================================================================

BULLETS

==============================================================================
*/

/*
================
TraceAttack
================
*/
void(float damage, vector dir) TraceAttack =
{
	local	vector	vel, org;

	vel = normalize(dir + v_up*crandom() + v_right*crandom());
	vel = vel + 2*trace_plane_normal;
	vel = vel * 200;

	org = trace_endpos - dir*4;

	if (trace_ent.takedamage)
	{
		SpawnBlood (org, vel*0.2, damage);
		AddMultiDamage (trace_ent, damage);
	}
	else
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);
	}
};

/*
================
FireBullets

Used by shotgun, super shotgun, and enemy soldier firing
Go to the trouble of combining multiple pellets into a single damage call.
================
*/
void(float shotcount, vector dir, vector spread) FireBullets =
{
	local	vector direction;
	local	vector	src;
   //JIM
   local float bullet;
   bullet = 0;

	makevectors(self.v_angle);

	src = self.origin + v_forward*10;
	src_z = self.absmin_z + self.size_z * 0.7;

	ClearMultiDamage ();
	while (shotcount > 0)
	{
		direction = dir + crandom()*spread_x*v_right + crandom()*spread_y*v_up;

		traceline (src, src + direction*2048, FALSE, self);
		if (trace_fraction != 1.0)
         //JIM
         {
			TraceAttack (4, direction);
         if ( ( !bullet ) && ( trace_ent == world ) )
            {
            placebullethole( trace_endpos );
            bullet = 1;
            }
         }

		shotcount = shotcount - 1;
	}
	ApplyMultiDamage ();
};

/*
================
W_FireShotgun
================
*/
void() W_FireShotgun =
{
	local vector dir;

	sound (self, CHAN_WEAPON, "weapons/guncock.wav", 1, ATTN_NORM);

	self.punchangle_x = -2;

	self.currentammo = self.ammo_standard_shells = self.ammo_standard_shells - 1;
	dir = aim (self, 100000);
	FireBullets (6, dir, '0.04 0.04 0');
};


/*
================
W_FireSuperShotgun
================
*/
void() W_FireSuperShotgun =
{
	local vector dir;

	if (self.currentammo == 1)
	{
		W_FireShotgun ();
		return;
	}

	sound (self ,CHAN_WEAPON, "weapons/shotgn2.wav", 1, ATTN_NORM);

	self.punchangle_x = -4;

	self.currentammo = self.ammo_standard_shells = self.ammo_standard_shells - 2;
	dir = aim (self, 100000);
	FireBullets (14, dir, '0.14 0.08 0');
};


/*
==============================================================================

ROCKETS

==============================================================================
*/

void()	s_explode1	=	[0,		s_explode2] {};
void()	s_explode2	=	[1,		s_explode3] {};
void()	s_explode3	=	[2,		s_explode4] {};
void()	s_explode4	=	[3,		s_explode5] {};
void()	s_explode5	=	[4,		s_explode6] {};
void()	s_explode6	=	[5,		SUB_Remove] {};

void() BecomeExplosion =
{
	self.movetype = MOVETYPE_NONE;
	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	setmodel (self, "progs/s_explod.spr");
	self.solid = SOLID_NOT;
	s_explode1 ();
};

void() T_MissileTouch =
{
	local float	damg;

	if (other == self.owner)
		return;		// don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		SUB_Remove();
		return;
	}

	damg = 100 + random()*20;

	if (other.health)
	{
		if (other.classname == "monster_shambler")
			damg = damg * 0.5;	// mostly immune
		T_Damage (other, self, self.owner, damg );
	}

	// don't do radius damage to the other, because all the damage
	// was done in the impact
	T_RadiusDamage (self, self.owner, 120, other);

//	sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);
	self.origin = self.origin - 8*normalize(self.velocity);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	BecomeExplosion ();
};



/*
================
W_FireRocket
================
*/
void() W_FireRocket =
{
	local	entity missile, mpuff;

	self.currentammo = self.ammo_standard_rockets = self.ammo_standard_rockets - 1;

	sound (self, CHAN_WEAPON, "weapons/sgun1.wav", 1, ATTN_NORM);

	self.punchangle_x = -2;

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "missile";

// set missile speed

	makevectors (self.v_angle);
	missile.velocity = aim(self, 1000);
	missile.velocity = missile.velocity * 1000;
	missile.angles = vectoangles(missile.velocity);

	missile.touch = T_MissileTouch;

// set missile duration
	missile.nextthink = time + 5;
	missile.think = SUB_Remove;

	setmodel (missile, "progs/missile.mdl");
	setsize (missile, '0 0 0', '0 0 0');
	setorigin (missile, self.origin + v_forward*8 + '0 0 16');
//MED 11/09/96
   newmis = missile;
};

/*
===============================================================================

LIGHTNING

===============================================================================
*/

/*
=================
LightningDamage
=================
*/
void(vector p1, vector p2, entity from, float damage) LightningDamage =
{
	local entity		e1, e2;
	local vector		f;

	f = p2 - p1;
	normalize (f);
	f_x = 0 - f_y;
	f_y = f_x;
	f_z = 0;
	f = f*16;

	e1 = e2 = world;

	traceline (p1, p2, FALSE, self);
//JIM
	if (trace_ent.takedamage && !trace_ent.wetsuit_finished )
	{
		particle (trace_endpos, '0 0 100', 225, damage*4);
		T_Damage (trace_ent, from, from, damage);
		if (self.classname == "player")
		{
			if (other.classname == "player")
				trace_ent.velocity_z = trace_ent.velocity_z + 400;
		}
	}
	e1 = trace_ent;

	traceline (p1 + f, p2 + f, FALSE, self);
//JIM
	if (trace_ent != e1 && trace_ent.takedamage &&
		!trace_ent.wetsuit_finished )
	{
		particle (trace_endpos, '0 0 100', 225, damage*4);
		T_Damage (trace_ent, from, from, damage);
	}
	e2 = trace_ent;

	traceline (p1 - f, p2 - f, FALSE, self);
//JIM
	if (trace_ent != e1 && trace_ent != e2 && trace_ent.takedamage &&
		!trace_ent.wetsuit_finished )
	{
		particle (trace_endpos, '0 0 100', 225, damage*4);
		T_Damage (trace_ent, from, from, damage);
	}
};


void() W_FireLightning =
{
	local	vector		org;
	local	float		cells;

	if (self.ammo_standard_cells < 1)
	{
		self.weapon = W_BestWeapon ();
		W_SetCurrentAmmo ();
		return;
	}

// explode if under water
	if (self.waterlevel > 1)
	{
		cells = self.ammo_standard_cells;
		self.ammo_standard_cells = 0;
      //MED 01/05/97 added discharge flag
      discharged = 1;
		T_RadiusDamage (self, self, 35*cells, world);
      discharged = 0;
		W_SetCurrentAmmo ();
		return;
	}

	if (self.t_width < time)
	{
		sound (self, CHAN_WEAPON, "weapons/lhit.wav", 1, ATTN_NORM);
		self.t_width = time + 0.6;
	}
	self.punchangle_x = -2;

	self.currentammo = self.ammo_standard_cells = self.ammo_standard_cells - 1;

	org = self.origin + '0 0 16';

	traceline (org, org + v_forward*600, TRUE, self);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING2);
	WriteEntity (MSG_BROADCAST, self);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
	WriteCoord (MSG_BROADCAST, trace_endpos_x);
	WriteCoord (MSG_BROADCAST, trace_endpos_y);
	WriteCoord (MSG_BROADCAST, trace_endpos_z);

	LightningDamage (self.origin, trace_endpos + v_forward*4, self, 30);
};


//=============================================================================


void() GrenadeExplode =
{
	T_RadiusDamage (self, self.owner, 120, world);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	BecomeExplosion ();
};

void() GrenadeTouch =
{
	if (other == self.owner)
		return;		// don't explode on owner
	if (other.takedamage == DAMAGE_AIM)
	{
		GrenadeExplode();
		return;
	}
	sound (self, CHAN_WEAPON, "weapons/bounce.wav", 1, ATTN_NORM);	// bounce sound
	if (self.velocity == '0 0 0')
		self.avelocity = '0 0 0';
};

/*
================
W_FireGrenade
================
*/
void() W_FireGrenade =
{
	local	entity missile, mpuff;

	self.currentammo = self.ammo_standard_rockets = self.ammo_standard_rockets - 1;

	sound (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);

	self.punchangle_x = -2;

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	missile.classname = "grenade";

// set missile speed

	makevectors (self.v_angle);

	if (self.v_angle_x)
		missile.velocity = v_forward*600 + v_up * 200 + crandom()*v_right*10 + crandom()*v_up*10;
	else
	{
		missile.velocity = aim(self, 10000);
		missile.velocity = missile.velocity * 600;
		missile.velocity_z = 200;
	}

	missile.avelocity = '300 300 300';

	missile.angles = vectoangles(missile.velocity);

	missile.touch = GrenadeTouch;

// set missile duration
	missile.nextthink = time + 2.5;
	missile.think = GrenadeExplode;

	setmodel (missile, "progs/grenade.mdl");
	setsize (missile, '0 0 0', '0 0 0');
	setorigin (missile, self.origin);
};

void() ProximityExplode =
{
   T_RadiusDamage (self, self.owner, 95, world);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	BecomeExplosion ();
};

//MED 10/31/96
float NumProximityGrenades;
/*
================
ProximityGrenadeExplode
================
*/
void() ProximityGrenadeExplode =
   {
   self.takedamage = DAMAGE_NO;
   NumProximityGrenades = NumProximityGrenades - 1;
   self.deathtype = "exploding";
   self.nextthink = time + 0.1;
   self.owner = self.lastvictim;
   self.think = ProximityExplode;
   };

/*
================
ProximityGrenadeTouch
================
*/
void() ProximityGrenadeTouch =
   {
   if (other == self)
      return;
   if (other.classname == self.classname)
      return;
   self.movetype = MOVETYPE_TOSS;
   if (self.state == 1)
      return;
   if (vlen(other.velocity) > 0)
      {
      ProximityGrenadeExplode();
      self.think();
      return;
      }
   if (other.takedamage == DAMAGE_AIM)
      {
      ProximityGrenadeExplode();
      self.think();
      return;
      }
   sound (self, CHAN_WEAPON, "weapons/bounce.wav", 1, ATTN_NORM); // bounce sound
   self.movetype = MOVETYPE_NONE;
   setsize (self, '-8 -8 -8', '8 8 8');
   self.state = 1;
   self.spawnmaster = other;
   };

/*
================
ProximityBomb
================
*/
void() ProximityBomb =
   {
   local entity   head;
   local float    blowup;

   if ((time > self.delay) || (NumProximityGrenades > 15) || (vlen(self.spawnmaster.velocity)>0) )
      {
      ProximityGrenadeExplode();
      self.think();
      return;
      }
   self.owner = world;
   self.takedamage = DAMAGE_YES;
   head = findradius(self.origin, 140);
   blowup = 0;

   while (head)
      {
      if ((head != self) && (head.health > 0) && (head.flags & (FL_CLIENT|FL_MONSTER)) && (head.classname!=self.classname))
         blowup = 1;
      if ((head.classname == self.classname) && (head.state==0))
         blowup = 1;
      traceline(self.origin,head.origin,TRUE,self);
      if (trace_fraction != 1.0)
         blowup = 0;
      if (blowup==1)
         {
         sound (self, CHAN_WEAPON, "hipweap/proxwarn.wav", 1, ATTN_NORM);
         ProximityGrenadeExplode();
         self.nextthink = time + 0.5;
         return;
         }
      head = head.chain;
      }
   self.nextthink = time + 0.25;
   };

/*
================
W_FireProximityGrenade
================
*/
void() W_FireProximityGrenade =
   {
   local entity missile, mpuff;

   NumProximityGrenades = NumProximityGrenades + 1;
   self.currentammo = self.ammo_standard_rockets = self.ammo_standard_rockets - 1;

   sound (self, CHAN_WEAPON, "hipweap/proxbomb.wav", 1, ATTN_NORM);

	self.punchangle_x = -2;

	missile = spawn ();
   missile.owner = self;
   missile.lastvictim = self;
   missile.movetype = MOVETYPE_TOSS;
	missile.solid = SOLID_BBOX;
   missile.classname = "proximity_grenade";
   missile.takedamage = DAMAGE_NO;
   missile.health = 5;
   missile.state = 0;

// set missile speed

	makevectors (self.v_angle);

	if (self.v_angle_x)
		missile.velocity = v_forward*600 + v_up * 200 + crandom()*v_right*10 + crandom()*v_up*10;
	else
	{
		missile.velocity = aim(self, 10000);
		missile.velocity = missile.velocity * 600;
		missile.velocity_z = 200;
	}

   missile.avelocity = '100 600 100';

	missile.angles = vectoangles(missile.velocity);

   missile.touch = ProximityGrenadeTouch;

// set missile duration
   missile.nextthink = time + 2;
   missile.delay = time + 15 + (10*random());
   missile.think = ProximityBomb;
   missile.th_die = ProximityGrenadeExplode;

   setmodel (missile, "progs/proxbomb.mdl");
   setorigin (missile, self.origin);
   setsize (missile, '-1 -1 -1', '1 1 1');
   };

//=============================================================================

void() spike_touch;
void() superspike_touch;


/*
===============
launch_spike

Used for both the player and the ogre
===============
*/
void(vector org, vector dir) launch_spike =
{
	newmis = spawn ();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;

	newmis.angles = vectoangles(dir);

	newmis.touch = spike_touch;
	newmis.classname = "spike";
	newmis.think = SUB_Remove;
	newmis.nextthink = time + 6;
	setmodel (newmis, "progs/spike.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
	setorigin (newmis, org);

	newmis.velocity = dir * 1000;
};

void() W_FireSuperSpikes =
{
	local vector	dir;
	local entity	old;

	sound (self, CHAN_WEAPON, "weapons/spike2.wav", 1, ATTN_NORM);
	self.attack_finished = time + 0.2;
	self.currentammo = self.ammo_standard_nails = self.ammo_standard_nails - 2;
	dir = aim (self, 1000);
	launch_spike (self.origin + '0 0 16', dir);
	newmis.touch = superspike_touch;
	setmodel (newmis, "progs/s_spike.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
	self.punchangle_x = -2;
};

void(float ox) W_FireSpikes =
{
	local vector	dir;
	local entity	old;

	makevectors (self.v_angle);

	if (self.ammo_standard_nails >= 2 && self.weapon == IT_SUPER_NAILGUN)
	{
		W_FireSuperSpikes ();
		return;
	}

	if (self.ammo_standard_nails < 1)
	{
		self.weapon = W_BestWeapon ();
		W_SetCurrentAmmo ();
		return;
	}

	sound (self, CHAN_WEAPON, "weapons/rocket1i.wav", 1, ATTN_NORM);
	self.attack_finished = time + 0.2;
	self.currentammo = self.ammo_standard_nails = self.ammo_standard_nails - 1;
	dir = aim (self, 1000);
	launch_spike (self.origin + '0 0 16' + v_right*ox, dir);

	self.punchangle_x = -2;
};



.float hit_z;
void() spike_touch =
{
local float rand;
	if (other == self.owner)
		return;

	if (other.solid == SOLID_TRIGGER)
		return;	// trigger field, do nothing

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		SUB_Remove();
		return;
	}

// hit something that bleeds
	if (other.takedamage)
	{
		spawn_touchblood (9);
		T_Damage (other, self, self.owner, 9);
	}
	else
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);

		if (self.classname == "wizspike")
			WriteByte (MSG_BROADCAST, TE_WIZSPIKE);
		else if (self.classname == "knightspike")
			WriteByte (MSG_BROADCAST, TE_KNIGHTSPIKE);
		else
			WriteByte (MSG_BROADCAST, TE_SPIKE);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
	}

	SUB_Remove();

};

void() superspike_touch =
{
local float rand;
	if (other == self.owner)
		return;

	if (other.solid == SOLID_TRIGGER)
		return;	// trigger field, do nothing

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		SUB_Remove();
		return;
	}

// hit something that bleeds
	if (other.takedamage)
	{
		spawn_touchblood (18);
		T_Damage (other, self, self.owner, 18);
	}
	else
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_SUPERSPIKE);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
	}

	SUB_Remove();

};


/*
===============================================================================

PLAYER WEAPON USE

===============================================================================
*/

//MED 10/18/96 added HIPWEAPONS
// Dissolution of Eternity: combo weapons (ids from ROGW_BASE up) are owned through .rog_items, every
// other weapon through .items.
float(float w) WeaponOwned =
{
	if (Rog_IsRogueWeapon(w))
		return Rog_HasWeapon(self, w);
	return (self.items & w);
};

// TRUE if the player doesn't have the ammo to use weapon w (the Axe and Mjolnir don't need any)
float(float w) WeaponLacksAmmo =
{
	if (w == IT_SHOTGUN)
		return (self.ammo_standard_shells < 1);
	if (w == IT_SUPER_SHOTGUN)
		return (self.ammo_standard_shells < 2);
	if (w == IT_NAILGUN)
		return (self.ammo_standard_nails < 1);
	if (w == IT_SUPER_NAILGUN)
		return (self.ammo_standard_nails < 2);
	if (w == IT_GRENADE_LAUNCHER || w == IT_ROCKET_LAUNCHER || w == IT_PROXIMITY_GUN)
		return (self.ammo_standard_rockets < 1);
	if (w == IT_LIGHTNING || w == IT_LASER_CANNON)
		return (self.ammo_standard_cells < 1);
	if (w == ROGW_LAVA_NAILGUN || w == ROGW_LAVA_SUPER_NAILGUN)
		return (self.ammo_lava_nails < 1);
	if (w == ROGW_MULTI_GRENADE || w == ROGW_MULTI_ROCKET)
		return (self.ammo_multi_rockets < 1);
	if (w == ROGW_PLASMA_GUN)
		return (self.ammo_plasma < 1);
	return FALSE;
};

// The base weapon a combo weapon needs (any other weapon is its own base weapon)
float(float w) ComboBaseWeapon =
{
	if (w == ROGW_LAVA_NAILGUN)
		return IT_NAILGUN;
	if (w == ROGW_LAVA_SUPER_NAILGUN)
		return IT_SUPER_NAILGUN;
	if (w == ROGW_MULTI_GRENADE)
		return IT_GRENADE_LAUNCHER;
	if (w == ROGW_MULTI_ROCKET)
		return IT_ROCKET_LAUNCHER;
	if (w == ROGW_PLASMA_GUN)
		return IT_LIGHTNING;
	return w;
};

// A combo weapon is only usable while you own its base weapon, so drop the ones whose base weapon is gone
// (a Gremlin stole it). EnableComboWeapons gives them back when you get the base weapon again.
void(entity e) DisableOrphanedComboWeapons =
{
	if ((e.rog_items & RIT_LAVA_NAILGUN) && !(e.items & IT_NAILGUN))
		e.rog_items = e.rog_items - RIT_LAVA_NAILGUN;
	if ((e.rog_items & RIT_LAVA_SUPER_NAILGUN) && !(e.items & IT_SUPER_NAILGUN))
		e.rog_items = e.rog_items - RIT_LAVA_SUPER_NAILGUN;
	if ((e.rog_items & RIT_MULTI_GRENADE) && !(e.items & IT_GRENADE_LAUNCHER))
		e.rog_items = e.rog_items - RIT_MULTI_GRENADE;
	if ((e.rog_items & RIT_MULTI_ROCKET) && !(e.items & IT_ROCKET_LAUNCHER))
		e.rog_items = e.rog_items - RIT_MULTI_ROCKET;
	if ((e.rog_items & RIT_PLASMA_GUN) && !(e.items & IT_LIGHTNING))
		e.rog_items = e.rog_items - RIT_PLASMA_GUN;
};

// Which weapon an impulse selects when its slot holds several (a weapon and its combo versions, ...).
// Pressing it again moves on to the next one you own that has ammo. If none has ammo it returns the first one
// you own, so you get the "not enough ammo." message, and 0 if you own none.
float(float a, float b, float c) WeaponForSlot =
{
	local float cur, n, i, w, first;

	cur = 0;
	if (self.weapon == a)
		cur = 1;
	else if (self.weapon == b)
		cur = 2;
	else if (self.weapon == c)
		cur = 3;
	first = 0;
	for (n = 1; n <= 3; n++)
	{
		i = cur + n;
		if (i > 3)
			i = i - 3;
		if (i == 1)
			w = a;
		else if (i == 2)
			w = b;
		else
			w = c;
		if (w && WeaponOwned(w))
		{
			if (!first)
				first = w;
			if (!WeaponLacksAmmo(w))
				return w;
		}
	}
	return first;
};

// Next (direction 1) or previous (direction -1) weapon you own that has ammo, in this order
float WeaponCycleOrder[16] = { IT_AXE, IT_SHOTGUN, IT_SUPER_SHOTGUN, IT_NAILGUN, ROGW_LAVA_NAILGUN, IT_SUPER_NAILGUN,
	ROGW_LAVA_SUPER_NAILGUN, IT_GRENADE_LAUNCHER, ROGW_MULTI_GRENADE, IT_PROXIMITY_GUN, IT_ROCKET_LAUNCHER,
	ROGW_MULTI_ROCKET, IT_LIGHTNING, ROGW_PLASMA_GUN, IT_LASER_CANNON, IT_MJOLNIR };

void(float direction) CycleWeapon =
{
	local float i, start, tries;

	EnableComboWeapons ( self );
	self.impulse = 0;
	start = 0;
	for (i = 0; i < 16; i++)
	{
		if (WeaponCycleOrder[i] == self.weapon)
			start = i;
	}
	i = start;
	for (tries = 0; tries < 16; tries++)
	{
		i = i + direction;
		if (i >= 16)
			i = 0;
		else if (i < 0)
			i = 15;
		if (WeaponOwned(WeaponCycleOrder[i]) && !WeaponLacksAmmo(WeaponCycleOrder[i]))
		{
			self.weapon = WeaponCycleOrder[i];
			W_SetCurrentAmmo ();
			return;
		}
	}
};

void() W_SetCurrentAmmo =
{
	player_run ();		// get out of any weapon firing states

	self.items = self.items - ( self.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS) );
	self.rog_items = self.rog_items - (self.rog_items & (RIT_LAVA_NAILS | RIT_PLASMA_AMMO | RIT_MULTI_ROCKETS));

	if (self.weapon == IT_AXE)
	{
		self.currentammo = 0;
		self.weaponmodel = "progs/v_axe.mdl";
		self.weaponframe = 0;
	}
	else if (self.weapon == IT_SHOTGUN)
	{
		self.currentammo = self.ammo_standard_shells;
		self.weaponmodel = "progs/v_shot.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_SHELLS;
	}
	else if (self.weapon == IT_SUPER_SHOTGUN)
	{
		self.currentammo = self.ammo_standard_shells;
		self.weaponmodel = "progs/v_shot2.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_SHELLS;
	}
//Dissolution of Eternity
	else if (self.weapon == ROGW_LAVA_NAILGUN)
	{
		self.currentammo = self.ammo_lava_nails;
		self.weaponmodel = "progs/v_lava.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_NAILS;
		self.rog_items = self.rog_items | RIT_LAVA_NAILS;
	}
	else if (self.weapon == ROGW_LAVA_SUPER_NAILGUN)
	{
		self.currentammo = self.ammo_lava_nails;
		self.weaponmodel = "progs/v_lava2.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_NAILS;
		self.rog_items = self.rog_items | RIT_LAVA_NAILS;
	}
	else if (self.weapon == ROGW_MULTI_GRENADE)
	{
		self.currentammo = self.ammo_multi_rockets;
		self.weaponmodel = "progs/v_multi.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_ROCKETS;
		self.rog_items = self.rog_items | RIT_MULTI_ROCKETS;
	}
	else if (self.weapon == ROGW_MULTI_ROCKET)
	{
		self.currentammo = self.ammo_multi_rockets;
		self.weaponmodel = "progs/v_multi2.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_ROCKETS;
		self.rog_items = self.rog_items | RIT_MULTI_ROCKETS;
	}
	else if (self.weapon == ROGW_PLASMA_GUN)
	{
		self.currentammo = self.ammo_plasma;
		self.weaponmodel = "progs/v_plasma.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_CELLS;
		self.rog_items = self.rog_items | RIT_PLASMA_AMMO;
	}
	else if (self.weapon == IT_NAILGUN)
	{
		self.currentammo = self.ammo_standard_nails;
		self.weaponmodel = "progs/v_nail.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_NAILS;
	}
	else if (self.weapon == IT_SUPER_NAILGUN)
	{
		self.currentammo = self.ammo_standard_nails;
		self.weaponmodel = "progs/v_nail2.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_NAILS;
	}
//MED
   else if (self.weapon == IT_LASER_CANNON)
	{
		self.currentammo = self.ammo_standard_cells;
      self.weaponmodel = "progs/v_laserg.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_CELLS;
	}
   else if (self.weapon == IT_GRENADE_LAUNCHER)
	{
		self.currentammo = self.ammo_standard_rockets;
		self.weaponmodel = "progs/v_rock.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_ROCKETS;
	}
	else if (self.weapon == IT_ROCKET_LAUNCHER)
	{
		self.currentammo = self.ammo_standard_rockets;
		self.weaponmodel = "progs/v_rock2.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_ROCKETS;
	}
	else if (self.weapon == IT_LIGHTNING)
	{
		self.currentammo = self.ammo_standard_cells;
		self.weaponmodel = "progs/v_light.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_CELLS;
	}
//MED
   else if (self.weapon == IT_MJOLNIR)
	{
      self.currentammo = self.ammo_standard_cells;
      self.weaponmodel = "progs/v_hammer.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_CELLS;
	}
//MED
   else if (self.weapon == IT_PROXIMITY_GUN)
	{
      self.currentammo = self.ammo_standard_rockets;
      self.weaponmodel = "progs/v_prox.mdl";
		self.weaponframe = 0;
      self.items = self.items | IT_ROCKETS;
	}
   else
	{
		self.currentammo = 0;
		self.weaponmodel = "";
		self.weaponframe = 0;
	}
};

float() W_BestWeapon =
{
	local	float	it;

	it = self.items;

   if (self.waterlevel <= 1 && self.ammo_standard_cells >= 1 && (it & IT_LIGHTNING) )
      return IT_LIGHTNING;
//MED
   else if(self.ammo_standard_cells >= 1 && (it & IT_LASER_CANNON) )
      return IT_LASER_CANNON;
//Dissolution of Eternity
   else if(self.ammo_lava_nails >= 2 && Rog_HasWeapon(self, ROGW_LAVA_SUPER_NAILGUN) )
		return ROGW_LAVA_SUPER_NAILGUN;
   else if(self.ammo_standard_nails >= 2 && (it & IT_SUPER_NAILGUN) )
		return IT_SUPER_NAILGUN;
	else if(self.ammo_standard_shells >= 2 && (it & IT_SUPER_SHOTGUN) )
		return IT_SUPER_SHOTGUN;
//Dissolution of Eternity
	else if(self.ammo_lava_nails >= 1 && Rog_HasWeapon(self, ROGW_LAVA_NAILGUN) )
		return ROGW_LAVA_NAILGUN;
	else if(self.ammo_standard_nails >= 1 && (it & IT_NAILGUN) )
		return IT_NAILGUN;
	else if(self.ammo_standard_shells >= 1 && (it & IT_SHOTGUN) )
		return IT_SHOTGUN;
//MED
   else if( it & IT_MJOLNIR )
      return IT_MJOLNIR;

/*
	if(self.ammo_standard_rockets >= 1 && (it & IT_ROCKET_LAUNCHER) )
		return IT_ROCKET_LAUNCHER;
	else if(self.ammo_standard_rockets >= 1 && (it & IT_GRENADE_LAUNCHER) )
		return IT_GRENADE_LAUNCHER;

*/

	return IT_AXE;
};

float() W_CheckNoAmmo =
{
	if (self.currentammo > 0)
		return TRUE;

	if (self.weapon == IT_AXE)
		return TRUE;

//MED
   if (self.weapon == IT_MJOLNIR)
      {
      return TRUE;
      }

   self.weapon = W_BestWeapon ();

	W_SetCurrentAmmo ();

// drop the weapon down
	return FALSE;
};

/*
============
W_Attack

An attack impulse can be triggered now
============
*/
void()	player_axe1;
void()	player_axeb1;
void()	player_axec1;
void()	player_axed1;
void()	player_shot1;
void()	player_nail1;
void()	player_light1;
void()	player_rocket1;
//MED
void()   player_laser1;
void()   player_hammer1;
void()   player_mjolnir1;
//Dissolution of Eternity
void()   player_lava_nail1;
void()   W_FireMultiGrenade;
void()   W_FireMultiRocket;


void() W_Attack =
{
	local	float	r;

	if (!W_CheckNoAmmo () || ((!IsSeedCalculated || IsWorldFrozen) && (EndlessCastleMapCount == 0 || EndlessCastleSeed == 0) && FixedSeed <= 0))
		return;

	makevectors	(self.v_angle);			// calculate forward angle for velocity
	self.show_hostile = time + 1;	// wake monsters up

	if (self.weapon == IT_AXE)
	{
		sound (self, CHAN_WEAPON, "weapons/ax1.wav", 1, ATTN_NORM);
		r = random();
		if (r < 0.25)
			player_axe1 ();
		else if (r<0.5)
			player_axeb1 ();
		else if (r<0.75)
			player_axec1 ();
		else
			player_axed1 ();
		self.attack_finished = time + 0.5;
	}
	else if (self.weapon == IT_SHOTGUN)
	{
		player_shot1 ();
		W_FireShotgun ();
		self.attack_finished = time + 0.5;
	}
	else if (self.weapon == IT_SUPER_SHOTGUN)
	{
		player_shot1 ();
		W_FireSuperShotgun ();
		self.attack_finished = time + 0.7;
	}
	else if (self.weapon == IT_NAILGUN)
	{
		player_nail1 ();
	}
	else if (self.weapon == IT_SUPER_NAILGUN)
	{
		player_nail1 ();
	}
	else if (self.weapon == IT_GRENADE_LAUNCHER)
	{
		player_rocket1();
		W_FireGrenade();
		self.attack_finished = time + 0.6;
	}
	else if (self.weapon == IT_ROCKET_LAUNCHER)
	{
		player_rocket1();
		W_FireRocket();
		self.attack_finished = time + 0.8;
	}
	else if (self.weapon == IT_LIGHTNING)
	{
		player_light1();
		self.attack_finished = time + 0.1;
		sound (self, CHAN_AUTO, "weapons/lstart.wav", 1, ATTN_NORM);
	}
//MED
   else if (self.weapon == IT_LASER_CANNON)
   {
      player_laser1();
   }
//MED
   else if (self.weapon == IT_MJOLNIR)
   {
      if (self.ammo_standard_cells < 30)
         player_hammer1();
      else
         player_mjolnir1();
      self.attack_finished = time + 0.8;
   }
//MED
   else if (self.weapon == IT_PROXIMITY_GUN)
   {
      player_rocket1();
      W_FireProximityGrenade();
      self.attack_finished = time + 0.6;
   }
//Dissolution of Eternity
   else if (self.weapon == ROGW_LAVA_NAILGUN || self.weapon == ROGW_LAVA_SUPER_NAILGUN)
   {
      lavaGunFired = 1;
      player_lava_nail1 ();
   }
   else if (self.weapon == ROGW_MULTI_GRENADE)
   {
      player_rocket1();
      W_FireMultiGrenade();
      self.attack_finished = time + 0.6;
   }
   else if (self.weapon == ROGW_MULTI_ROCKET)
   {
      player_rocket1();
      W_FireMultiRocket();
      self.attack_finished = time + 0.8;
   }
   else if (self.weapon == ROGW_PLASMA_GUN)
   {
      // player_light1 picks W_FirePlasma instead of W_FireLightning, with the same flash and frames
      self.attack_finished = time + 1.0;
      player_light1 ();
   }
};

/*
============
W_ChangeWeapon

============
*/
//MED 10/18/96 added hipweapons
void() W_ChangeWeapon =
{
	local	float	fl;

	EnableComboWeapons ( self );
	fl = 0;
//MED
	if (self.impulse == 1)
	{
		fl = IT_AXE;
	}
	else if (self.impulse == 2)
	{
		fl = IT_SHOTGUN;
	}
	else if (self.impulse == 3)
	{
		fl = IT_SUPER_SHOTGUN;
	}
	// Dissolution of Eternity: a slot can hold several weapons, pressing it again goes to the next one
	else if (self.impulse == 4)
	{
		fl = WeaponForSlot (IT_NAILGUN, ROGW_LAVA_NAILGUN, 0);
	}
	else if (self.impulse == 5)
	{
		fl = WeaponForSlot (IT_SUPER_NAILGUN, ROGW_LAVA_SUPER_NAILGUN, 0);
	}
	else if (self.impulse == 6)
	{
		fl = WeaponForSlot (IT_GRENADE_LAUNCHER, ROGW_MULTI_GRENADE, IT_PROXIMITY_GUN);
	}
	else if (self.impulse == 7)
	{
		fl = WeaponForSlot (IT_ROCKET_LAUNCHER, ROGW_MULTI_ROCKET, 0);
	}
	else if (self.impulse == 8)
	{
		fl = WeaponForSlot (IT_LIGHTNING, ROGW_PLASMA_GUN, 0);
	}
	else if (self.impulse == 60)
		fl = ROGW_LAVA_NAILGUN;
	else if (self.impulse == 61)
		fl = ROGW_LAVA_SUPER_NAILGUN;
	else if (self.impulse == 62)
		fl = ROGW_MULTI_GRENADE;
	else if (self.impulse == 63)
		fl = ROGW_MULTI_ROCKET;
	else if (self.impulse == 64)
		fl = ROGW_PLASMA_GUN;
//MED
	else if (self.impulse == 225)
	{
		fl = IT_LASER_CANNON;
	}
	else if (self.impulse == 226)
	{
		fl = IT_MJOLNIR;
	}

	self.impulse = 0;
	if (!fl || !WeaponOwned(fl))
	{
		sprint (self, "no weapon.\n");
		return;
	}
	if (WeaponLacksAmmo(fl))
	{	// don't have the ammo
		sprint (self, "not enough ammo.\n");
		return;
	}

	if (self.weapon != fl)
	{
		if (self.weapon == ROGW_LAVA_NAILGUN || self.weapon == ROGW_LAVA_SUPER_NAILGUN)
		{
			if (fl == IT_NAILGUN || fl == IT_SUPER_NAILGUN)
				sprint (self, "Normal Nails\n");
		}
		else if (self.weapon == ROGW_MULTI_GRENADE)
		{
			if (fl == IT_GRENADE_LAUNCHER)
				sprint (self, "Normal Grenades\n");
		}
		else if (self.weapon == ROGW_MULTI_ROCKET)
		{
			if (fl == IT_ROCKET_LAUNCHER)
				sprint (self, "Normal Rockets\n");
		}
		else if (self.weapon == ROGW_PLASMA_GUN)
		{
			if (fl == IT_LIGHTNING)
				sprint (self, "Lightning Gun\n");
		}
		else if (fl == ROGW_LAVA_NAILGUN || fl == ROGW_LAVA_SUPER_NAILGUN)
			sprint (self, "Lava Nails!\n");
		else if (fl == ROGW_MULTI_GRENADE)
			sprint (self, "Multi-Grenades!\n");
		else if (fl == ROGW_MULTI_ROCKET)
			sprint (self, "Multi-Rockets!\n");
		else if (fl == ROGW_PLASMA_GUN)
			sprint (self, "Plasma Gun!\n");
	}
//
// set weapon, set ammo
//
	self.weapon = fl;
	W_SetCurrentAmmo ();
};

/*
============
CheatCommand
============
*/
void() CheatCommand =
{
	if (deathmatch || coop)
		return;
	
	if (EndlessCastleMapCount > 0)
	{
		bprint("Dark forces prevent your manipulation of the Endless Castle.\n");
		localcmd("map start\n");
		return;
	}

	self.ammo_standard_rockets = 100;
	self.ammo_standard_nails = 200;
	self.ammo_standard_shells = 100;
	self.items = self.items |
		IT_AXE |
		IT_SHOTGUN |
		IT_SUPER_SHOTGUN |
		IT_NAILGUN |
		IT_SUPER_NAILGUN |
		IT_GRENADE_LAUNCHER |
		IT_ROCKET_LAUNCHER |
		IT_LIGHTNING |
		IT_LASER_CANNON |
		IT_MJOLNIR |
		IT_PROXIMITY_GUN |
		IT_KEY1 | IT_KEY2;

	self.ammo_standard_cells = 200;
	self.items = self.items | IT_LIGHTNING;
//MED
   self.items = self.items | IT_LASER_CANNON;
   self.items = self.items | IT_MJOLNIR;
   self.items = self.items | IT_PROXIMITY_GUN;

	// Dissolution of Eternity
	self.ammo_lava_nails = 200;
	self.ammo_multi_rockets = 100;
	self.ammo_plasma = 100;
	self.rog_items = self.rog_items | RIT_LAVA_NAILGUN | RIT_LAVA_SUPER_NAILGUN | RIT_MULTI_GRENADE | RIT_MULTI_ROCKET | RIT_PLASMA_GUN;
	self.weapon = IT_ROCKET_LAUNCHER;
	self.impulse = 0;
	W_SetCurrentAmmo ();
};

/*
============
CycleWeaponCommand

Go to the next weapon with ammo
============
*/
void() CycleWeaponCommand =
{
	CycleWeapon (1);
};

/*
============
CycleWeaponReverseCommand

Go to the prev weapon with ammo
============
*/
void() CycleWeaponReverseCommand =
{
	CycleWeapon (-1);
};

/*
============
ServerflagsCommand

Just for development
============
*/
void() ServerflagsCommand =
{
	serverflags = serverflags * 2 + 1;
};

void() QuadCheat =
{
	if (deathmatch || coop)
		return;

	if (EndlessCastleMapCount > 0)
	{
		bprint("Dark forces prevent your manipulation of the Endless Castle.\n");
		localcmd("map start\n");
		return;
	}
	self.super_time = 1;
	self.super_damage_finished = time + 30;
	self.items = self.items | IT_QUAD;
   	bprint ("quad cheat\n");
};

//MED
void() WetsuitCheat =
{
	if (deathmatch || coop)
		return;

	if (EndlessCastleMapCount > 0)
	{
		bprint("Dark forces prevent your manipulation of the Endless Castle.\n");
		localcmd("map start\n");
		return;
	}
	self.items2 = self.items2 | HIP_IT_WETSUIT;
	self.wetsuit_time = 1;
	self.wetsuit_finished = time + 30;
	bprint( "wetsuit cheat\n" );
};

//MED
void() EmpathyShieldsCheat =
{
	if (deathmatch || coop)
		return;

	if (EndlessCastleMapCount > 0)
	{
		bprint("Dark forces prevent your manipulation of the Endless Castle.\n");
		localcmd("map start\n");
		return;
	}

	self.items2 = self.items2 | HIP_IT_EMPATHY_SHIELDS;
	self.empathy_time = 1;
	self.empathy_finished = time + 30;
	bprint( "empathy shields cheat\n" );
};

void() DumpEntities =
   {
   local entity   head;
   local float i;

   i = 1;
   head = nextent(world);
   while (head!=world)
      {
      dprint(ftos(i));
      dprint(" ");
      dprint(head.classname);
      dprint("\n");
      head = nextent(head);
      i = i + 1;
      }
   };

void() DumpLiveEntities =
   {
   local entity   head;
   local float i;

   i = 1;
   head = nextent(world);
   while (head!=world)
      {
      if (head.health > 0)
         {
         dprint(ftos(i));
         dprint(" ");
         dprint(head.classname);
         dprint(" ");
         dprint(vtos(head.origin));
         dprint("\n");
         dprint("--------------------\n");
         }
      head = nextent(head);
      i = i + 1;
      }
   };

void() Genocide =
{
   local entity   head;

	if (deathmatch || coop)
		return;

	if (EndlessCastleMapCount > 0)
	{
		bprint("Dark forces prevent your manipulation of the Endless Castle.\n");
		localcmd("map start\n");
		return;
	}
	bprint("Genocide!\n");
	head = nextent(world);
	while (head!=world)
	{
		if ((head.health > 0) && (head.flags & FL_MONSTER))
		{
			T_Damage(head,world,world,head.health+10);
		}
		head = nextent(head);
	}
};

float dump_coord;
void () ToggleDump =
   {
   dump_coord = 1 - dump_coord;
   if (dump_coord == 1)
      bprint("Dumping Player Location\n");
   };
void () DumpCoordinates =
   {
   local entity pl;
   pl = checkclient();
   if (pl)
      {
      bprint("Player: ");
      bprint(vtos(pl.origin));
      bprint("\n");
      }
   };
/*
============
ImpulseCommands

============
*/
void() ImpulseCommands =
{
	if(InRandomMenu)
	{
		CheckMenuImpulses();
		self.impulse = 0;
		return;
	}

	if (self.impulse >= 1 && self.impulse <= 8)
		W_ChangeWeapon ();

   if (self.impulse >= 225 && self.impulse <= 226)
		W_ChangeWeapon ();
	if (self.impulse >= 60 && self.impulse <= 64)	// Dissolution of Eternity
		W_ChangeWeapon ();

	if (self.impulse == 9)
		CheatCommand ();
   if (self.impulse == 10)
		CycleWeaponCommand ();
	if (self.impulse == 11)
		ServerflagsCommand ();
	if (self.impulse == 12)
		CycleWeaponReverseCommand ();
	if (self.impulse == 24)
		EnterRandomMenu ();
//JIM
	if ( self.impulse == 200 )
		WetsuitCheat();
//MED
   if ( self.impulse == 201 )
      EmpathyShieldsCheat();
   if ( self.impulse == 205 )
      Genocide();
   if ( self.impulse == 206 )
      ToggleDump();
   if ( self.impulse == 202 )
      DumpEntities();
   if ( self.impulse == 203 )
      DumpLiveEntities();
   if (self.impulse == 255)
		QuadCheat ();
   if (dump_coord == 1)
      DumpCoordinates();

	self.impulse = 0;
};

/*
============
W_WeaponFrame

Called every frame so impulse events can be handled as well as possible
============
*/
void() W_WeaponFrame =
{
	if (time < self.attack_finished)
		return;

	// Dissolution of Eternity
	if (lavaGunFired)
	{
		if (self.weapon == ROGW_LAVA_NAILGUN || self.weapon == ROGW_LAVA_SUPER_NAILGUN)
			sound (self, CHAN_WEAPON, "lavagun/snail.wav", 1, ATTN_NORM);
		lavaGunFired = 0;
	}


	if (self.impulse)
		ImpulseCommands ();

// check for attack
	if (self.button0)
	{
		SuperDamageSound ();
		W_Attack ();
	}
};

/*
========
SuperDamageSound

Plays sound if needed
========
*/
void() SuperDamageSound =
{
	if (self.super_damage_finished > time)
	{
		if (self.super_sound < time)
		{
			self.super_sound = time + 1;
			sound (self, CHAN_BODY, "items/damage3.wav", 1, ATTN_NORM);
		}
	}
	return;
};

//============================================================================
// Dissolution of Eternity: Plasma projectile (used by the Dragon, and by the
// Plasma Gun once it is ported)
//============================================================================
void(vector p1, vector p2, entity from, float damage) PlasmaDamage =
{
	local entity		e1, e2;
	local vector		f;
	
	f = p2 - p1;
	normalize (f);
	f_x = 0 - f_y;
	f_y = f_x;
	f_z = 0;
	f = f*16;

	e1 = e2 = world;

	traceline (p1, p2, FALSE, self);
	if (trace_ent.takedamage)
	{
		particle (trace_endpos, '0 0 100', 225, damage*4);
		T_Damage (trace_ent, from, from.owner, damage);
		if (self.classname == "player")
		{
			if (other.classname == "player")
				trace_ent.velocity_z = trace_ent.velocity_z + 400;
		}
	}
	e1 = trace_ent;

	traceline (p1 + f, p2 + f, FALSE, self);
	if (trace_ent != e1 && trace_ent.takedamage)
	{
		particle (trace_endpos, '0 0 100', 225, damage*4);
		T_Damage (trace_ent, from, from.owner, damage);
	}
	e2 = trace_ent;

	traceline (p1 - f, p2 - f, FALSE, self);
	if (trace_ent != e1 && trace_ent != e2 && trace_ent.takedamage)
	{
		particle (trace_endpos, '0 0 100', 225, damage*4);
		T_Damage (trace_ent, from, from.owner, damage);
	}
};

//================================
//================================
void(entity current, float doDamage) PlasmaDischarge =
{
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING2);
	WriteEntity (MSG_BROADCAST, current);
	WriteCoord (MSG_BROADCAST, current.origin_x);
	WriteCoord (MSG_BROADCAST, current.origin_y);
	WriteCoord (MSG_BROADCAST, current.origin_z);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	sound (self, CHAN_VOICE, "weapons/lhit.wav", 1, ATTN_NORM);
	if (doDamage == 1)
        PlasmaDamage (self.origin, current.origin, self, 50);
};

//================================
//================================
void() PlasmaGroundOut = 
{
	local entity 	current, start;
	local float		monstersHit;
	
	monstersHit = 0;
	current = findradius ( self.origin, 320 );
	start = current;
	while ( monstersHit < 5 )
	{
		if ( current.flags & FL_MONSTER || current.classname == "player")
		{
			if ( current != self.owner )
			{
				traceline ( self.origin, current.origin, TRUE, world );
				if (trace_fraction == 1)
				{
					monstersHit = monstersHit + 1;
					PlasmaDischarge ( current, 1 );
				}
			}
		}
		current = current.chain;
		if (start == current || !current)
			return;
	}
};

//================================
//================================
void() PlasmaTouch = 
{
	local float	damg;

	if (other == self.owner)
		return;		// don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		SUB_Remove();
		return;
	}

	damg = 80 + random()*20;
	sound (self, CHAN_WEAPON, "plasma/explode.wav", 1, ATTN_NORM);
	
	if (other.health)
	{
		if (other.classname == "monster_shambler")
			damg = damg * 0.5;	// mostly immune
		T_Damage (other, self, self.owner, damg );
	}

	// don't do radius damage to the other, because all the damage
	// was done in the impact
	T_RadiusDamage (self, self.owner, 70, other);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION2);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
	WriteByte (MSG_BROADCAST, 244);
	WriteByte (MSG_BROADCAST, 3);

	PlasmaGroundOut();
	SUB_Remove();
};

//================================
//================================
void() PlasmaLaunch =
{
	self.velocity = normalize(self.velocity);
	self.velocity = self.velocity * 1250;

	self.nextthink = time + 5;
	self.think = SUB_Remove;
};

void(vector org, vector dir) launch_plasma =
{
	local entity	missile, mpuff;

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "plasma";
	
// set missile speed	
	missile.velocity = dir * 0.01;
	missile.avelocity = '300 300 300';
	missile.angles = vectoangles(missile.velocity);
	missile.touch = PlasmaTouch;
	
	setmodel (missile, "progs/plasma.mdl");
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, org);

	sound (missile, CHAN_WEAPON, "plasma/flight.wav", 1, ATTN_NORM);
	if (!deathmatch && !coop)
		missile.effects = EF_BRIGHTLIGHT;
	
// set missile duration
	missile.think = PlasmaLaunch;
	missile.nextthink = time + 0.1;
};

//============================================================================
// Dissolution of Eternity: Multi-Grenade projectile (used by the Multi-Grenade Ogre, and by the
// Multi-Grenade Launcher once it is ported)
//============================================================================
void() MultiGrenadeTouch;

void() MiniGrenadeExplode =
{
	if ( self.owner.classname == "player")
		T_RadiusDamage (self, self.owner, 90, world);
	else
		T_RadiusDamage (self, self.owner, 60, world);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION2);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
    WriteByte (MSG_BROADCAST, 230);
    WriteByte (MSG_BROADCAST, 5);

	BecomeExplosion ();
};

//================================
//================================
void(float offsetAngle) MiniGrenadeLaunch =
{
	local	entity missile, mpuff;
	local	float	tempRand;
	
	missile = spawn ();
	missile.owner = self.owner;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	missile.classname = "MiniGrenade";
		
// set missile speed	
	missile.v_angle = self.v_angle;
	missile.v_angle_y = missile.v_angle_y + offsetAngle;
	makevectors (missile.v_angle);
		
		missile.velocity = v_forward*100 + v_up*400;
		tempRand = (crandom()*60) - 30;
		missile.velocity = missile.velocity + tempRand * v_forward;
		tempRand = (crandom()*40) - 20;
		missile.velocity = missile.velocity + tempRand * v_right;
		tempRand = (crandom()*60) - 30;
		missile.velocity = missile.velocity + tempRand * v_up;

	missile.avelocity = '300 300 300';
	missile.angles = vectoangles(missile.velocity);
	missile.touch = MultiGrenadeTouch;
	
	setmodel (missile, "progs/mervup.mdl");
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, self.origin);

// set missile duration
	missile.nextthink = time + 1 + (crandom() * 0.5);
	missile.think = MiniGrenadeExplode;
};

//================================
//================================
void() MultiGrenadeExplode =
{
	MiniGrenadeLaunch(0);
	MiniGrenadeLaunch(72);
	MiniGrenadeLaunch(144);
	MiniGrenadeLaunch(216);
	MiniGrenadeLaunch(288);

	SUB_Remove();
};

//================================
//================================
void() MultiGrenadeTouch =
{
	if (other == self.owner)
		return;		// don't explode on owner
	if (other.takedamage == DAMAGE_AIM)
	{
		if (self.classname == "MiniGrenade")
			MiniGrenadeExplode();
		else
		{
			if (self.owner.classname == "player")
				GrenadeExplode();
			else
				MiniGrenadeExplode();
		}
		return;
	}
	// bounce sound
	sound (self, CHAN_WEAPON, "weapons/bounce.wav", 1, ATTN_NORM);	
	if (self.velocity == '0 0 0')
		self.avelocity = '0 0 0';
};

//============================================================================
// Dissolution of Eternity: the Lava Nailgun and Lava Super Nailgun
//============================================================================
void() lavaspike_touch;
void() superlavaspike_touch;

// =============== Lava Spike Touch Routines

void() lavaspike_touch =
{
local float rand;
local float old_armortype;
local float old_armorvalue;
local float old_armormask;

	if (other == self.owner)
		return;

	if (other.solid == SOLID_TRIGGER)
		return;	// trigger field, do nothing

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		SUB_Remove();
		return;
	}
	
// hit something that bleeds
	if (other.takedamage)
	{
		spawn_touchblood (9);
		if(other.classname == "player")
		{
			old_armortype = other.armortype;
			old_armorvalue = other.armorvalue;
			old_armormask = other.items & (IT_ARMOR1|IT_ARMOR2|IT_ARMOR3);
			other.armortype = 0;
			other.armorvalue = 0;
			T_Damage (other, self, self.owner, 9);
			other.armortype = old_armortype;
			other.armorvalue = old_armorvalue;
			other.items = other.items | old_armormask;
		}
		else		// is a monster
		{
			if ( other.classname != "monster_lava_man")
			{
				T_Damage (other, self, self.owner, 15);
			}
		}
	}
	else
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		
		if (self.classname == "wizspike")
			WriteByte (MSG_BROADCAST, TE_WIZSPIKE);
		else if (self.classname == "knightspike")
			WriteByte (MSG_BROADCAST, TE_KNIGHTSPIKE);
		else
			WriteByte (MSG_BROADCAST, TE_SPIKE);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
	}

	SUB_Remove();

};

void() superlavaspike_touch =
{
local float rand;
local float old_armortype;
//local float old_armorvalue;

	if (other == self.owner)
		return;

	if (other.solid == SOLID_TRIGGER)
		return;	// trigger field, do nothing

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		SUB_Remove();
		return;
	}
	
// hit something that bleeds
	if (other.takedamage)
	{
		spawn_touchblood (18);
		
		// halve the effectiveness of the armor for players..
		if(other.classname == "player")
		{
			// save the old armor values...
			old_armortype = other.armortype;
//			old_armorvalue = other.armorvalue;
			other.armortype = other.armortype * 0.5;
//			other.armorvalue = 0;
			T_Damage (other, self, self.owner, 18);
			
			// if the damage didn't wipe out the armor, armortype 
			if(other.armortype != 0)
			{
				other.armortype = old_armortype;
//				other.armorvalue = old_armorvalue;
			}
		}
		else		// is a monster, do 50% more damage
		{
			if ( other.classname != "monster_lava_man")
			{
				T_Damage (other, self, self.owner, 30);
			}
		}
	}
	else
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_SUPERSPIKE);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
	}

	SUB_Remove();

};

/*
===============
launch_lava_spike

Used for both the player and the ogre
===============
*/
void(vector org, vector dir) launch_lava_spike =
{
	newmis = spawn ();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;

	newmis.angles = vectoangles(dir);
	
	newmis.touch = lavaspike_touch;
	newmis.classname = "lava_spike";
	newmis.think = SUB_Remove;
	newmis.nextthink = time + 6;
	setmodel (newmis, "progs/lspike.mdl");	
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);		
	setorigin (newmis, org);

	newmis.velocity = dir * 1000;
};

void() W_FireSuperLavaSpikes =
{
	local vector	dir;
	local entity	old;
	
	sound (self, CHAN_WEAPON, "weapons/spike2.wav", 1, ATTN_NORM);
	self.attack_finished = time + 0.2;
	self.currentammo = self.ammo_lava_nails = self.ammo_lava_nails - 2;
	
	dir = aim (self, 1000);
	launch_lava_spike (self.origin + '0 0 16', dir);
	newmis.touch = superlavaspike_touch;

//	setmodel (newmis, "progs/lspike.mdl");			

	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);		
	self.punchangle_x = -2;
};

void(float ox) W_FireLavaSpikes =
{
	local vector	dir;
	local entity	old;
	
	makevectors (self.v_angle);
	
	if (self.ammo_lava_nails >= 2 && self.weapon == ROGW_LAVA_SUPER_NAILGUN)
	{
		W_FireSuperLavaSpikes ();
		return;
	}

	if (self.ammo_lava_nails < 1)
	{
		sprint (self, "Out of Lava Nails\n");
		self.weapon = W_BestWeapon ();
		W_SetCurrentAmmo ();
		return;
	}

	sound (self, CHAN_WEAPON, "weapons/rocket1i.wav", 1, ATTN_NORM);
	self.attack_finished = time + 0.2;
	self.currentammo = self.ammo_lava_nails = self.ammo_lava_nails - 1;
	
	dir = aim (self, 1000);
	launch_lava_spike (self.origin + '0 0 16' + v_right*ox, dir);

	self.punchangle_x = -2;
};

//============================================================================
// Dissolution of Eternity: the Multi-Grenade Launcher and the Multi-Rocket Launcher
//============================================================================
void() W_FireMultiGrenade =
{
	local	entity missile, mpuff;
	
	self.currentammo = self.ammo_multi_rockets = self.ammo_multi_rockets - 1;
	
	sound (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);

	self.punchangle_x = -2;

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	missile.classname = "MultiGrenade";
		
// set missile speed	
	makevectors (self.v_angle);
	if (self.v_angle_x)
		missile.velocity = v_forward*600 + v_up * 200 + crandom()*v_right*10 + crandom()*v_up*10;
	else
	{
		missile.velocity = aim(self, 10000);
		missile.velocity = missile.velocity * 600;
		missile.velocity_z = 200;
	}

	missile.avelocity = '300 300 300';
	missile.angles = vectoangles(missile.velocity);
	missile.touch = MultiGrenadeTouch;
	
// set missile duration
	missile.nextthink = time + 1;
	missile.think = MultiGrenadeExplode;

	setmodel (missile, "progs/mervup.mdl");
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, self.origin);
};

//=============================================================================
// Multi Rocket Code
//=============================================================================

//================================
//================================
void() MultiRocketExplode = 
{
	local float	damg;

//	Stock Single Rocket Damage...
//	damg = 100 + random()*20;

	damg = 60 + random()*15;

	if (other.health)
	{
		if (other.classname == "monster_shambler")
			damg = damg * 0.5;	// mostly immune
		if (other.classname == "monster_dragon")
			damg = damg * 0.5;	// mostly immune
		T_Damage (other, self, self.owner, damg );
	}

	// don't do radius damage to the other, because all the damage
	// was done in the impact
//	Stock single rocket damage.
//	T_RadiusDamage (self, self.owner, 120, other);

	T_RadiusDamage (self, self.owner, 75, other);

//	sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);
	self.origin = self.origin - 8*normalize(self.velocity);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	BecomeExplosion ();
};

//================================
//================================
void() MultiRocketTouch =
{
	if (other == self.owner)
		return;		// don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		SUB_Remove();
		return;
	}

	MultiRocketExplode ();
};


//================================
//================================
void() HomingMissileThink =
{
	local vector	dir;

	if (self.enemy.health < 1)
	{
		SUB_Remove();
		return;
	}

	dir = normalize(self.enemy.origin - self.origin);
	self.velocity = dir * 1000;
	self.nextthink = time + 0.1;
	self.think = HomingMissileThink;	
};


//================================
//================================
void() HomingMissileAcquire =
{
	local vector	oldVelocity;
	local vector	aimangle;

	if ( self.delay < time )
	{
		MultiRocketExplode ();
		return;
	}

	oldVelocity = self.velocity;
	makevectors (self.v_angle);
	self.velocity = aim (self, 1000);
	self.velocity = self.velocity * 1000;

	aimangle = self.origin + self.velocity;	
	traceline ( self.origin, aimangle, FALSE, self );
	if (trace_fraction < 1)
	{
		if (trace_ent.flags & FL_MONSTER)
		{
			self.enemy = trace_ent;
			HomingMissileThink();
			return;
		}
	}
	
	self.velocity = oldVelocity;
	self.v_angle = vectoangles ( self.velocity );
	self.angles = self.v_angle;
	self.think = HomingMissileAcquire;
	self.nextthink = time + 0.2;
};

//================================
//================================
void(float offset, float frameNum) MultiRocketLaunch = 
{
	local entity 	missile, mpuff;
	local vector	aimangle;
	
	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "MultiRocket";
	missile.delay = time + 4;
	missile.frame = frameNum;
	missile.touch = MultiRocketTouch;

	if (deathmatch || coop)
		setmodel (missile, "progs/rockup_d.mdl");
	else
		setmodel (missile, "progs/rockup.mdl");

	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, self.origin + v_forward*8 + '0 0 16');
	
	if ( coop || deathmatch)
	{
		aimangle = self.v_angle;
		aimangle_y = aimangle_y + (offset * 0.66);
		makevectors (aimangle);
		missile.velocity = aim(self, 1000);
		missile.velocity = missile.velocity * 1000;
		missile.angles = vectoangles(missile.velocity);

		missile.think = MultiRocketExplode;
		missile.nextthink = time + 4;
	}
	else
	{
		makevectors (self.v_angle);
		missile.velocity = v_forward * 1000 - v_right*offset*8;
		missile.angles = vectoangles(missile.velocity);
		missile.v_angle = self.v_angle;	

		aimangle = missile.origin + missile.velocity;
		traceline ( missile.origin, aimangle, FALSE, self );
		if (trace_fraction < 1)
		{
			if (trace_ent.flags & FL_MONSTER)
			{
				missile.enemy = trace_ent;
				missile.think = HomingMissileThink;
				return;
			}
		}

		missile.think = HomingMissileAcquire;
		missile.nextthink = time + 0.1;
	}
};

//================================

void() W_FireMultiRocket =
{
	self.currentammo = self.ammo_multi_rockets = self.ammo_multi_rockets - 1;
	
	sound (self, CHAN_WEAPON, "weapons/sgun1.wav", 1, ATTN_NORM);

	self.punchangle_x = -2;
	
	MultiRocketLaunch ( -10, 2 );
	MultiRocketLaunch ( -5, 3 );
	MultiRocketLaunch ( 5, 0 );
	MultiRocketLaunch ( 10, 1 );
};

//============================================================================
// Dissolution of Eternity: the Plasma Gun
//============================================================================
void() W_FirePlasma = 
{
	local float		cells;
	local vector 	dir;
	
	if (self.ammo_plasma < 1)
	{
		self.weapon = W_BestWeapon ();
		W_SetCurrentAmmo ();
		return;
	}

// explode if under water
	if (self.waterlevel > 1)
	{
		cells = self.ammo_plasma;
		self.ammo_plasma = 0;
		W_SetCurrentAmmo ();
		T_RadiusDamage (self, self, 35*cells, world);
		return;
	}
	self.currentammo = self.ammo_plasma = self.ammo_plasma - 1;
	sound (self, CHAN_WEAPON, "plasma/fire.wav", 0.5, ATTN_NORM);
	self.punchangle_x = -2;

	makevectors (self.v_angle);
	dir = aim ( self, 1000 );
	launch_plasma (self.origin + v_forward*24 + '0 0 16', dir);
};
