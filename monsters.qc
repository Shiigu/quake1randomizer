/* ALL MONSTERS SHOULD BE 1 0 0 IN COLOR */

// name =[framenum,	nexttime, nextthink] {code}
// expands to:
// name ()
// {
//		self.frame=framenum;
//		self.nextthink = time + nexttime;
//		self.think = nextthink
//		<code>
// };


/*
================
monster_use

Using a monster makes it angry at the current activator
================
*/

float(float lower, float upper) Random;

void() monster_use =
{
	if (self.enemy)
		return;
	if (self.health <= 0)
		return;
	if (activator.items & IT_INVISIBILITY)
		return;
	if (activator.flags & FL_NOTARGET)
		return;
	if (activator.classname != "player")
		return;
	
// delay reaction so if the monster is teleported, its sound is still
// heard
	self.enemy = activator;
	self.nextthink = time + 0.1;
	self.think = FoundTarget;
};

/*
================
monster_death_use

When a mosnter dies, it fires all of its targets with the current
enemy as activator.
================
*/
void() monster_death_use =
{
	local entity 	ent, otemp, stemp;

// fall to ground
	if (self.flags & FL_FLY)
		self.flags = self.flags - FL_FLY;
	if (self.flags & FL_SWIM)
		self.flags = self.flags - FL_SWIM;

	if (!self.target)
		return;

	activator = self.enemy;
	SUB_UseTargets ();
};


//============================================================================

void() walkmonster_start_go =
{
	local string	stemp;
	local entity	etemp;
	local vector old, neworigin;
	local float IS_IN_TELEPORTER, canMove;
	self.origin_z = self.origin_z + 1;	// raise off floor a bit

	if(self.Converted == "1" && self.Unstuckable)
	{
		IS_IN_TELEPORTER = IsTouchingTeleporter(self);

		if(!IS_IN_TELEPORTER)
		{
			if(self.mins != self.oldmins)
			{
				// The coordinates of a monster will be corrected in case the bounding boxes are differently-sized.
				neworigin = self.origin;
				neworigin_x = neworigin_x - self.mins_x + self.oldmins_x;
				neworigin_y = neworigin_y - self.mins_y + self.oldmins_y;
				neworigin_z = neworigin_z - self.mins_z + self.oldmins_z;
				setorigin(self, neworigin);
				droptofloor();
			}
			droptofloor();
		}
		else
		{		
			dprint(self.classname);
			dprint(" (");
			dprint(vtos(self.origin));
			dprint(")");
			dprint(" seems to be tied to a teleporter. Excluded from unstuck checks.\n");
		}
		
		if (!walkmove(0, 0) && !IS_IN_TELEPORTER)
		{
			old_x = self.origin_x;
			old_y = self.origin_y;
			old_z = self.origin_z;
			UnstuckMonster(self, 0, 0);
		}

		if (!walkmove(0, 0) && !IS_IN_TELEPORTER)
		{
            setorigin(self, old);
			dprint ("\nUnstuck failed. walkmonster ");
			dprint (self.classname);
			dprint (" killed at: ");
			dprint (vtos(self.origin));
			T_Damage (self, world, world, 500000); // Monster is brutally murdered for the crime of not fitting in this world. Literally.
			dprint ("\n");
			return;
		}
	}
	
	self.takedamage = DAMAGE_AIM;

	self.ideal_yaw = self.angles * '0 1 0';
	if (!self.yaw_speed)
		self.yaw_speed = 20;
	self.view_ofs = '0 0 25';
	self.use = monster_use;
	
	self.flags = self.flags | FL_MONSTER;
	
	if (self.target)
	{
		self.goalentity = self.movetarget = find(world, targetname, self.target);
		self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
		if (!self.movetarget)
		{
			dprint ("Monster can't find target at ");
			dprint (vtos(self.origin));
			dprint ("\n");
		}
// this used to be an objerror
		if (self.movetarget.classname == "path_corner")
			self.th_walk ();
		else
			self.pausetime = 99999999;
			self.th_stand ();
	}
	else
	{
		self.pausetime = 99999999;
		self.th_stand ();
	}

// spread think times so they don't all happen at same time
	self.nextthink = self.nextthink + random()*0.5;
};


void() walkmonster_start =
{
// delay drop to floor to make sure all doors have been spawned
// spread think times so they don't all happen at same time
	self.nextthink = self.nextthink + random()*0.5;
	self.think = walkmonster_start_go;
	force_retouch = 2;
	total_monsters = total_monsters + 1;
};

void() flymonster_start_go =
{
	local vector old, neworigin;
	local entity	etemp;
	local float IS_IN_TELEPORTER, canMove;
	self.takedamage = DAMAGE_AIM;

	self.ideal_yaw = self.angles * '0 1 0';
	if (!self.yaw_speed)
		self.yaw_speed = 10;
	self.view_ofs = '0 0 25';
	self.use = monster_use;

	self.flags = self.flags | FL_FLY;
	self.flags = self.flags | FL_MONSTER;

	if(self.Converted == "1")
	{
		IS_IN_TELEPORTER = IsTouchingTeleporter(self);

		if(!IS_IN_TELEPORTER)
		{
			if(self.mins != self.oldmins)
			{
				// The coordinates of a monster will be corrected in case the bounding boxes are differently-sized.
				neworigin = self.origin;
				neworigin_x = neworigin_x - self.mins_x + self.oldmins_x;
				neworigin_y = neworigin_y - self.mins_y + self.oldmins_y;
				neworigin_z = neworigin_z - self.mins_z + self.oldmins_z;
				setorigin(self, neworigin);
			}
		}
		else
		{		
			dprint(self.classname);
			dprint(" (");
			dprint(vtos(self.origin));
			dprint(")");
			dprint(" seems to be tied to a teleporter. Excluded from unstuck checks.\n");
		}
		
		if (!walkmove(0, 0) && !IS_IN_TELEPORTER)
		{
			old_x = self.origin_x;
			old_y = self.origin_y;
			old_z = self.origin_z;
			UnstuckMonster(self, 1, 0);
		}
		
		if (!walkmove(0, 0) && !IS_IN_TELEPORTER)
		{
			self.origin_x = old_x;
			self.origin_y = old_y;
			self.origin_z = old_z;
			dprint ("\nUnstuck failed. flymonster ");
			dprint (self.classname);
			dprint (" killed at: ");
			dprint (vtos(self.origin));
			T_Damage (self, world, world, 500000); // Monster is brutally murdered for the crime of not fitting in this world. Literally.
			dprint ("\n");
			return;
		}
	}

	if (self.target)
	{
		self.goalentity = self.movetarget = find(world, targetname, self.target);
		if (!self.movetarget)
		{
			dprint ("Monster can't find target at ");
			dprint (vtos(self.origin));
			dprint ("\n");
		}
// this used to be an objerror
		if (self.movetarget.classname == "path_corner")
			self.th_walk ();
		else
			self.pausetime = 99999999;
			self.th_stand ();
	}
	else
	{
		self.pausetime = 99999999;
		self.th_stand ();
	}
};

void() flymonster_start =
{
// spread think times so they don't all happen at same time
	self.nextthink = self.nextthink + random()*0.5;
	self.think = flymonster_start_go;
	force_retouch = 2;
	total_monsters = total_monsters + 1;
};

void() swimmonster_start_go =
{
	if (deathmatch)
	{
		SUB_Remove();
		return;
	}

	self.takedamage = DAMAGE_AIM;
//	total_monsters = total_monsters + 1;

	self.ideal_yaw = self.angles * '0 1 0';
	if (!self.yaw_speed)
		self.yaw_speed = 10;
	self.view_ofs = '0 0 10';
	self.use = monster_use;
	
	self.flags = self.flags | FL_SWIM;
	self.flags = self.flags | FL_MONSTER;

	if (self.target)
	{
		self.goalentity = self.movetarget = find(world, targetname, self.target);
		if (!self.movetarget)
		{
			dprint ("Monster can't find target at ");
			dprint (vtos(self.origin));
			dprint ("\n");
		}
// this used to be an objerror
		self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
		self.th_walk ();
	}
	else
	{
		self.pausetime = 99999999;
		self.th_stand ();
	}

// spread think times so they don't all happen at same time
	self.nextthink = self.nextthink + random()*0.5;
};

void() swimmonster_start =
{
// spread think times so they don't all happen at same time
	self.nextthink = self.nextthink + random()*0.5;
	self.think = swimmonster_start_go;
	force_retouch = 2;
	total_monsters = total_monsters + 1;
};