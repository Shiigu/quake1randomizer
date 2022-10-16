

float(float lower, float upper) Random;
void(entity e, float flying) UnstuckMonster;
void(entity e) UnstuckObject;
float(entity head) IsTouchingTeleporter;
float(entity head) IsNearAWaterSurface;
float(entity head) IsNearOtherArmor;
.string Converted;  // "" if it isn't flagged for conversion, "0" if it's flagged but not converted, "1" if it is converte
.vector oldsize;

void() SUB_Null = {};

void() SUB_Remove = {remove(self);};

/*
QuakeEd only writes a single float for angles (bad idea), so up and down are
just constant angles.
*/
void() SetMovedir =
{
	if (self.angles == '0 -1 0')
		self.movedir = '0 0 1';
	else if (self.angles == '0 -2 0')
		self.movedir = '0 0 -1';
	else
	{
		makevectors (self.angles);
		self.movedir = v_forward;
	}
	
	self.angles = '0 0 0';
};

/*
================
InitTrigger
================
*/
void() InitTrigger =
{
// trigger angles are used for one-way touches.  An angle of 0 is assumed
// to mean no restrictions, so use a yaw of 360 instead.
	if (self.angles != '0 0 0')
		SetMovedir ();
	self.solid = SOLID_TRIGGER;
	setmodel (self, self.model);	// set size and link into world
	self.movetype = MOVETYPE_NONE;
	self.modelindex = 0;
	self.model = "";
};

/*
=============
SUB_CalcMove

calculate self.velocity and self.nextthink to reach dest from
self.origin traveling at speed
===============
*/
void(entity ent, vector tdest, float tspeed, void() func) SUB_CalcMoveEnt =
{
local entity	stemp;
	stemp = self;
	self = ent;

	SUB_CalcMove (tdest, tspeed, func);
	self = stemp;
};

void(vector tdest, float tspeed, void() func) SUB_CalcMove =
{
local vector	vdestdelta;
local float		len, traveltime;

	if (!tspeed)
		objerror("No speed is defined!");

	self.think1 = func;
	self.finaldest = tdest;
	self.think = SUB_CalcMoveDone;

	if (tdest == self.origin)
	{
		self.velocity = '0 0 0';
		self.nextthink = self.ltime + 0.1;
		return;
	}
		
// set destdelta to the vector needed to move
	vdestdelta = tdest - self.origin;
	
// calculate length of vector
	len = vlen (vdestdelta);
	
// divide by speed to get time to reach dest
	traveltime = len / tspeed;

	if (traveltime < 0.1)
	{
		self.velocity = '0 0 0';
		self.nextthink = self.ltime + 0.1;
		return;
	}
	
// set nextthink to trigger a think when dest is reached
	self.nextthink = self.ltime + traveltime;

// scale the destdelta vector by the time spent traveling to get velocity
	self.velocity = vdestdelta * (1/traveltime);	// qcc won't take vec/float	
};

/*
============
After moving, set origin to exact final destination
============
*/
void()  SUB_CalcMoveDone =
{
	setorigin(self, self.finaldest);
	self.velocity = '0 0 0';
	self.nextthink = -1;
	if (self.think1)
		self.think1();
};


/*
=============
SUB_CalcAngleMove

calculate self.avelocity and self.nextthink to reach destangle from
self.angles rotating 

The calling function should make sure self.think is valid
===============
*/
void(entity ent, vector destangle, float tspeed, void() func) SUB_CalcAngleMoveEnt =
{
local entity		stemp;
	stemp = self;
	self = ent;
	SUB_CalcAngleMove (destangle, tspeed, func);
	self = stemp;
};

void(vector destangle, float tspeed, void() func) SUB_CalcAngleMove =
{
local vector	destdelta;
local float		len, traveltime;

	if (!tspeed)
		objerror("No speed is defined!");
		
// set destdelta to the vector needed to move
	destdelta = destangle - self.angles;
	
// calculate length of vector
	len = vlen (destdelta);
	
// divide by speed to get time to reach dest
	traveltime = len / tspeed;

// set nextthink to trigger a think when dest is reached
	self.nextthink = self.ltime + traveltime;

// scale the destdelta vector by the time spent traveling to get velocity
	self.avelocity = destdelta * (1 / traveltime);
	
	self.think1 = func;
	self.finalangle = destangle;
	self.think = SUB_CalcAngleMoveDone;
};

/*
============
After rotating, set angle to exact final angle
============
*/
void() SUB_CalcAngleMoveDone =
{
	self.angles = self.finalangle;
	self.avelocity = '0 0 0';
	self.nextthink = -1;
	if (self.think1)
		self.think1();
};


//=============================================================================

void() DelayThink =
{
	activator = self.enemy;
	SUB_UseTargets ();
	remove(self);
};

/*
==============================
SUB_UseTargets

the global "activator" should be set to the entity that initiated the firing.

If self.delay is set, a DelayedUse entity will be created that will actually
do the SUB_UseTargets after that many seconds have passed.

Centerprints any self.message to the activator.

Removes all entities with a targetname that match self.killtarget,
and removes them, so some events can remove other triggers.

Search for (string)targetname in all entities that
match (string)self.target and call their .use function

==============================
*/
void() SUB_UseTargets =
{
	local entity t, stemp, otemp, act;

//
// check for a delay
//
	if (self.delay)
	{
	// create a temp object to fire at a later time
		t = spawn();
		t.classname = "DelayedUse";
		t.nextthink = time + self.delay;
		t.think = DelayThink;
		t.enemy = activator;
		t.message = self.message;
		t.killtarget = self.killtarget;
		t.target = self.target;
		return;
	}
	
	
//
// print the message
//
	if (activator.classname == "player" && self.message != "")
	{
		centerprint (activator, self.message);
		if (!self.noise)
			sound (activator, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NORM);
	}

//
// kill the killtagets
//
	if (self.killtarget)
	{
		t = world;
		do
		{
			t = find (t, targetname, self.killtarget);
			if (!t)
				return;
			remove (t);
		} while ( 1 );
	}
	
//
// fire targets
//
	if (self.target)
	{
		act = activator;
		t = world;
		do
		{
			t = find (t, targetname, self.target);
			if (!t)
			{
				return;
			}
			stemp = self;
			otemp = other;
			self = t;
			other = stemp;
			if (self.use != SUB_Null)
			{
				if (self.use)
					self.use ();
			}
			self = stemp;
			other = otemp;
			activator = act;
		} while ( 1 );
	}
	

};


/*

in nightmare mode, all attack_finished times become 0
some monsters refire twice automatically

*/

void(float normal) SUB_AttackFinished =
{
	self.cnt = 0;		// refire count for nightmare
	if (skill != 3)
		self.attack_finished = time + normal;
};

float (entity targ) visible;

void (void() thinkst) SUB_CheckRefire =
{
	if (skill != 3)
		return;
	if (self.cnt == 1)
		return;
	if (!visible (self.enemy))
		return;
	self.cnt = 1;
	self.think = thinkst;
};

float(float lower, float upper) Random =
{
	return floor (lower + random() * (upper - lower + 1));
};

void(entity e, float flying) UnstuckMonster = 
{
	local entity oldself;
	local float CURRENT_TRY;
	local float MAX_TRIES;
	local vector fixvector;
	local vector old;
	local vector min;
	local vector max;
	local vector diff;
	local float occupied, canMove;

	oldself = self;
	self = e;

	MAX_TRIES = 300;
	CURRENT_TRY = 0;
	diff_x = 0;
	diff_y = 0;
	diff_z = 0;
	old_x = self.origin_x;
	old_y = self.origin_y;
	old_z = self.origin_z;
	dprint("Attempting to unstuck ");
	dprint(self.classname);
	dprint(" (");
	dprint(vtos(self.origin));
	dprint(").");
	do
	{
		fixvector_x = old_x;
		fixvector_y = old_y;
		fixvector_z = old_z;
		// Give three tries with a single coordinate change in case it works
		if(CURRENT_TRY == 0 || CURRENT_TRY > 2)
			diff_x = diff_x + 3;
		if(CURRENT_TRY == 1 || CURRENT_TRY > 2)
			diff_y = diff_y + 3;
		if(CURRENT_TRY >= 2)
			diff_z = diff_z + 3;
		min_x = old_x - diff_x;
		min_y = old_y - diff_y;
		min_z = old_z - diff_z;
		max_x = old_x + diff_x;
		max_y = old_y + diff_y;
		max_z = old_z + diff_z;
		fixvector_x = Random(min_x, max_x);
		fixvector_y = Random(min_y, max_y);
		fixvector_z = Random(min_z, max_z);
		setorigin(self, fixvector);
		if(!flying)
			droptofloor();
		CURRENT_TRY = CURRENT_TRY + 1;
		occupied = Space_Occupied(self);
		canMove = walkmove(0,0);
		if(!occupied && canMove)
		{ 
			dprint(" Worked after ");
			dprint(ftos(CURRENT_TRY));
			dprint(" attempt(s).\n");
		}
	}
	while((occupied || !canMove) && CURRENT_TRY < MAX_TRIES);
	self = oldself;
};

void(entity e) UnstuckObject =
{
	local entity oldself;
	local float CURRENT_TRY;
	local float MAX_TRIES;
	local vector fixvector;
	local vector old;
	local vector min;
	local vector max;
	local vector diff;
	local float occupied, dropped;

	oldself = self;
	self = e;

	MAX_TRIES = 300;
	CURRENT_TRY = 0;
	diff_x = 0;
	diff_y = 0;
	diff_z = 0;
	old_x = self.origin_x;
	old_y = self.origin_y;
	old_z = self.origin_z;
	dprint("Attempting to unstuck ");
	dprint(self.classname);
	dprint(" (");
	dprint(vtos(self.origin));
	dprint(").");
	do
	{
		fixvector_x = old_x;
		fixvector_y = old_y;
		fixvector_z = old_z;
		// Give three tries with a single coordinate change in case it works
		if(CURRENT_TRY == 0 || CURRENT_TRY > 2)
			diff_x = diff_x + 3;
		if(CURRENT_TRY == 1 || CURRENT_TRY > 2)
			diff_y = diff_y + 3;
		if(CURRENT_TRY >= 2)
			diff_z = diff_z + 3;
		min_x = old_x - diff_x;
		min_y = old_y - diff_y;
		min_z = old_z - diff_z;
		max_x = old_x + diff_x;
		max_y = old_y + diff_y;
		max_z = old_z + diff_z;
		fixvector_x = Random(min_x, max_x);
		fixvector_y = Random(min_y, max_y);
		fixvector_z = Random(min_z, max_z);
		setorigin(self, fixvector);
		CURRENT_TRY = CURRENT_TRY + 1;
		occupied = Space_Occupied(self);
		dropped = droptofloor();
		if(!occupied && dropped)
		{
			dprint(" Worked after ");
			dprint(ftos(CURRENT_TRY));
			dprint(" attempt(s).\n");
		}
	}
	while((occupied || !dropped) && CURRENT_TRY < MAX_TRIES);
	self = oldself;
};

float(entity head) IsTouchingTeleporter =
{
        local entity e;
		local vector center = head.origin;
		local float radius, side;

		// Get the biggest measure to create the biggest possible cube that contains the entity
		if(head.size_x >= head.size_y && head.size_x >= head.size_z)
			side = head.size_x;
		else if(head.size_y >= head.size_x && head.size_y >= head.size_z)
			side = head.size_y;
		else if(head.size_z >= head.size_x && head.size_z >= head.size_x)
			side = head.size_z;

		// The radius of a sphere that only touches the vertexes of a cube is half the cube's body diagonal
		// (The body diagonal of a cube whose sides equal x is "sqrt(3) * x")
		radius = (side * sqrt(3)) / 2;
		e = findradius(head.origin, radius);

		while(e)
		{
			if(e.classname == "trigger_teleport" && e.targetname)
			{
				dprint(head.classname);
				dprint(" (");
				dprint(vtos(head.origin));
				dprint(")");
				dprint(" is tied to a teleporter. Excluded from unstuck checks.\n");
				return TRUE;
			}
			e = e.chain;
		}
		return FALSE;
};

// Checks if there are already-converted Armor suits nearby
float(entity head) IsNearOtherArmor =
{
        local entity e;
		local vector center = head.origin;
		local float radius, side;

		// Search for all entities in a 256 unit radius
		e = findradius(head.origin, 256);

		while(e)
		{
			if(e.Converted == "1" && (e.classname == "item_armor1" || e.classname == "item_armor2" || e.classname == "item_armorInv"))
			{
				dprint(" (REROLL ARMOR) ");
				return TRUE;
			}
			e = e.chain;
		}
		return FALSE;
};

// Tries, in six increments, whether there's some liquid surface between the start and the destination
float(vector center, float plusX, float plusY, float plusZ) GoesThroughALiquid =
{
	local float MAX_TRIES = 6;
	local float CURRENT_TRIES, contents;
	local vector increment, target;
	if(plusX != 0)
		increment_x = plusX / MAX_TRIES;
	if(plusY != 0)
		increment_y = plusY / MAX_TRIES;
	if(plusZ != 0)
		increment_z = plusZ / MAX_TRIES;
	target = center;
	while(CURRENT_TRIES < MAX_TRIES)
	{
		contents = pointcontents(target);
		if(contents == CONTENT_WATER || contents == CONTENT_SLIME || contents == CONTENT_LAVA)
			return TRUE;
		else
		{
			traceline(center, target, TRUE, world);
			if(trace_inwater)
				return TRUE;
		}
		CURRENT_TRIES = CURRENT_TRIES + 1;
		target_x = target_x + increment_x;
		target_y = target_y + increment_y;
		target_z = target_z + increment_z;
	}
	return FALSE;
};

// Checks if there are liquid surfaces around 256 away from the object
// (It does NOT check if there are liquid surfaces above the object, as that is likely to be separated by a wall)
float(entity head) IsNearAWaterSurface =
{
		local vector center = head.origin;
		local float IsNearLiquid;

		IsNearLiquid = 0;

		// Plane in the center

		IsNearLiquid = GoesThroughALiquid(center, 256, 0, 0);		// RIGHT?
		if(IsNearLiquid == 0)
			IsNearLiquid = GoesThroughALiquid(center, -256, 0, 0);		// LEFT?
		if(IsNearLiquid == 0)
			IsNearLiquid = GoesThroughALiquid(center, 0, 256, 0);		// UP?
		if(IsNearLiquid == 0)
			IsNearLiquid = GoesThroughALiquid(center, 0, -256, 0);		// DOWN?
		if(IsNearLiquid == 0)
			IsNearLiquid = GoesThroughALiquid(center, 256, 256, 0);		// UPPER RIGHT CORNER?
		if(IsNearLiquid == 0)
			IsNearLiquid = GoesThroughALiquid(center, 256, -256, 0); 	// LOWER RIGHT CORNER?
		if(IsNearLiquid == 0)
			IsNearLiquid = GoesThroughALiquid(center, -256, 256, 0);	// UPPER LEFT CORNER?
		if(IsNearLiquid == 0)
			IsNearLiquid = GoesThroughALiquid(center, -256, -256, 0);	// LOWER LEFT CORNER?

		// LOWER HALF OF THE OBJECT

		if(IsNearLiquid == 0)
			IsNearLiquid = GoesThroughALiquid(center, 256, 0, -256);		// RIGHT?
		if(IsNearLiquid == 0)
			IsNearLiquid = GoesThroughALiquid(center, -256, 0, -256);		// LEFT?
		if(IsNearLiquid == 0)
			IsNearLiquid = GoesThroughALiquid(center, 0, 256, -256);		// UP?
		if(IsNearLiquid == 0)
			IsNearLiquid = GoesThroughALiquid(center, 0, -256, -256);		// DOWN?
		if(IsNearLiquid == 0)
			IsNearLiquid = GoesThroughALiquid(center, 256, 256, -256);		// UPPER RIGHT CORNER?
		if(IsNearLiquid == 0)
			IsNearLiquid = GoesThroughALiquid(center, 256, -256, -256); 	// LOWER RIGHT CORNER?
		if(IsNearLiquid == 0)
			IsNearLiquid = GoesThroughALiquid(center, -256, 256, -256);		// UPPER LEFT CORNER?
		if(IsNearLiquid == 0)
			IsNearLiquid = GoesThroughALiquid(center, -256, -256, -256);	// LOWER LEFT CORNER?

		// We don't pay attention to the upper half because having water above the object might mean it's in a different floor altogether
		return IsNearLiquid;
};