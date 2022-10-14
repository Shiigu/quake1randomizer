/*
*
* Code obtained from https://github.com/matboe/modjam2022_matboe/blob/main/extras.qc
* by matboe
* 
* Sans the removal of some functions and the addition of some public function definitions, the code is left as is.
*
*/

float(entity head) Space_Occupied;

/*==========================================
 PM_TraceCheck

 checks for obstacles such as solid entities or walls inside
 the bbox and along its borders.  if an obstacle is met, FALSE is
 returned. 
 code by Patrick Martin
==========================================*/
float(entity head, vector spot) PM_TraceCheck =
{
        local   vector  p1, p2;

	// Check for obstacles inside the bbox
        p1 = spot + head.mins;
        p2 = spot + head.maxs;
        traceline (p1, p2, FALSE, head);
        if (trace_fraction < 1)  return FALSE;

        p1_x = spot_x + head.maxs_x;
        p2_x = spot_x + head.mins_x;
        traceline (p1, p2, FALSE, head);
        if (trace_fraction < 1)  return FALSE;

        p1_y = spot_y + head.maxs_y;
        p2_y = spot_y + head.mins_y;
        traceline (p1, p2, FALSE, head);
        if (trace_fraction < 1)  return FALSE;

        p1_x = spot_x + head.mins_x;
        p2_x = spot_x + head.maxs_x;
        traceline (p1, p2, FALSE, head);
        if (trace_fraction < 1)  return FALSE;

	// Check for obstacles along the bbox boundaries
        p1 = p2 = spot + head.maxs;
        p2_z = spot_z + head.mins_z;
        traceline (p1, p2, FALSE, head);
        if (trace_fraction < 1)  return FALSE;

        p1_x = p2_x = spot_x + head.mins_x;
        traceline (p1, p2, FALSE, head);
        if (trace_fraction < 1)  return FALSE;

        p1_y = p2_y = spot_y + head.mins_x;
        traceline (p1, p2, FALSE, head);
        if (trace_fraction < 1)  return FALSE;

        p1_x = p2_x = spot_x + head.maxs_x;
        traceline (p1, p2, FALSE, head);
        if (trace_fraction < 1)  return FALSE;

        p1 = p2 = spot + head.mins;
        p2_x = spot_x + head.maxs_x;
        traceline (p1, p2, FALSE, head);
        if (trace_fraction < 1)  return FALSE;

        p1 = p2;
        p2_y = spot_y + head.maxs_y;
        traceline (p1, p2, FALSE, head);
        if (trace_fraction < 1)  return FALSE;

        p1 = p2;
        p2_x = spot_x + head.mins_x;
        traceline (p1, p2, FALSE, head);
        if (trace_fraction < 1)  return FALSE;

        p1 = p2;
        p2_y = spot_y + head.mins_y;
        traceline (p1, p2, FALSE, head);
        if (trace_fraction < 1)  return FALSE;

        p1 = p2 = spot + head.maxs;
        p2_x = spot_x + head.mins_x;
        traceline (p1, p2, FALSE, head);
        if (trace_fraction < 1)  return FALSE;

        p1 = p2;
        p2_y = spot_y + head.mins_y;
        traceline (p1, p2, FALSE, head);
        if (trace_fraction < 1)  return FALSE;

        p1 = p2;
        p2_x = spot_x + head.maxs_x;
        traceline (p1, p2, FALSE, head);
        if (trace_fraction < 1)  return FALSE;

        p1 = p2;
        p2_y = spot_y + head.maxs_y;
        traceline (p1, p2, FALSE, head);
        return (trace_fraction == 1);
};

/*========================================
 PM_InWall

 this checks if a bbox is inside a wall or sky.  the bbox's origin
 and corners are checked.  If any one points is within a solid or sky,
 TRUE is returned. code by Patrick Martin
=========================================*/
float(entity head, vector spot) PM_InWall =
{
        local   vector  p;

	// Check origin
        p = spot;
        if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
        if (pointcontents(p) == CONTENT_SKY)    return TRUE;

	// Check bbox faces
        p_x = spot_x + head.mins_x;
        if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
        if (pointcontents(p) == CONTENT_SKY)    return TRUE;

        p_x = spot_x + head.maxs_x;
        if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
        if (pointcontents(p) == CONTENT_SKY)    return TRUE;

        p = spot;
        p_y = spot_y + head.mins_y;
        if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
        if (pointcontents(p) == CONTENT_SKY)    return TRUE;

        p_y = spot_y + head.maxs_y;
        if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
        if (pointcontents(p) == CONTENT_SKY)    return TRUE;

        p = spot;
        p_z = spot_z + head.mins_z;
        if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
        if (pointcontents(p) == CONTENT_SKY)    return TRUE;

        p_z = spot_z + head.maxs_z;
        if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
        if (pointcontents(p) == CONTENT_SKY)    return TRUE;

	// Check bbox corners
        p_x = spot_x + head.maxs_x;
        p_y = spot_y + head.maxs_y;
        if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
        if (pointcontents(p) == CONTENT_SKY)    return TRUE;

        p_x = spot_x + head.mins_x;
        if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
        if (pointcontents(p) == CONTENT_SKY)    return TRUE;

        p_x = spot_x + head.maxs_x;
        p_y = spot_y + head.mins_y;
        if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
        if (pointcontents(p) == CONTENT_SKY)    return TRUE;

        p_x = spot_x + head.mins_x;
        if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
        if (pointcontents(p) == CONTENT_SKY)    return TRUE;

        p_x = spot_x + head.maxs_x;
        p_y = spot_y + head.maxs_y;
        p_z = spot_z + head.mins_z;
        if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
        if (pointcontents(p) == CONTENT_SKY)    return TRUE;

        p_x = spot_x + head.mins_x;
        if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
        if (pointcontents(p) == CONTENT_SKY)    return TRUE;

        p_x = spot_x + head.maxs_x;
        p_y = spot_y + head.mins_y;
        if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
        if (pointcontents(p) == CONTENT_SKY)    return TRUE;

        p_x = spot_x + head.mins_x;
        if (pointcontents(p) == CONTENT_SOLID)  return TRUE;
        return (pointcontents(p) == CONTENT_SKY);
};

/*========================================
 Space_Occupied

 checks if the spot is empty or occupied by a solid
========================================*/
float(entity head) Space_Occupied =
{
	// If a wall or other solid is in the way, the monster can't respawn here.
        if (PM_InWall(head, head.origin))  return TRUE;

	// Check if other obstacles such as entities are occupying the space.
        return !PM_TraceCheck(head, head.origin);
};