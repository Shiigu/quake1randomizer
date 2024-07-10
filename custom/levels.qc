

// Picking a random level for Endless Castle mode

float EndlessCastleEpisode1Flags;							// 8 bit integer. MSE is e1m8, LSE is e1m1. If bit is "1" the level has been part of the cycle.
float EndlessCastleEpisode2Flags;							// 7 bit integer. MSE is e2m7, LSE is e2m1. If bit is "1" the level has been part of the cycle.
float EndlessCastleEpisode3Flags;							// 8 bit integer. MSE is end, LSE is e3m1. If bit is "1" the level has been part of the cycle.
float EndlessCastleEpisode4Flags;							// 8 bit integer. MSE is e4m8, LSE is e4m1. If bit is "1" the level has been part of the cycle.

string() PickNextLevel;
string(float level) ToEpisode1Level;
string(float level) ToEpisode2Level;
string(float level) ToEpisode3Level;
string(float level) ToEpisode4Level;
float() GetElapsedTime;

string() PickNextLevel = {
    if(EndlessCastleMapCount == 0) return "";
    local float rngEpisode, rngLevel, bitFlag, ATTEMPTS, MAX_ATTEMPTS, i, addComma;
	ATTEMPTS = 0;
	MAX_ATTEMPTS = 30;
	if(EndlessCastleEpisode1Flags == 255 && EndlessCastleEpisode2Flags == 127 && EndlessCastleEpisode3Flags == 255 && EndlessCastleEpisode4Flags == 255)
	{
        dprint("Resetting level cycle.\n");
		// If all levels appeared exactly once, restart randomization
		EndlessCastleEpisode1Flags = 0;
		EndlessCastleEpisode2Flags = 0;
		EndlessCastleEpisode3Flags = 0;
		EndlessCastleEpisode4Flags = 0;
	}
    dprint("--- CURRENT ENDLESS CASTLE CYCLE USED LEVELS ---\n");
    dprint("EPISODE 1 -> ");
    addComma = 0;
    if(EndlessCastleEpisode1Flags == 0)
    {
        dprint("NONE");
    }
    else {
        for(i = 1; i < 9; i++) {
            bitFlag = fpow(2, i - 1);
            if(EndlessCastleEpisode1Flags & bitFlag)
            {
                if(addComma == 1)
                    dprint(", ");    
                dprint(ToEpisode1Level(i - 1));
                addComma = 1;
            }
        }
    }
    dprint("\nEPISODE 2 -> ");
    addComma = 0;
    if(EndlessCastleEpisode2Flags == 0)
    {
        dprint("NONE");
    }
    else {
        for(i = 1; i < 8; i++) {
            bitFlag = fpow(2, i - 1);
            if(EndlessCastleEpisode2Flags & bitFlag)
            {
                if(addComma == 1)
                    dprint(", ");    
                dprint(ToEpisode2Level(i - 1));
                addComma = 1;
            }
        }
    }
    dprint("\nEPISODE 3 -> ");
    addComma = 0;
    if(EndlessCastleEpisode3Flags == 0 || EndlessCastleEpisode3Flags == 128)
    {
        dprint("NONE");
    }
    else {
        for(i = 1; i < 8; i++) {
            bitFlag = fpow(2, i - 1);
            if(EndlessCastleEpisode3Flags & bitFlag)
            {
                if(addComma == 1)
                    dprint(", ");    
                dprint(ToEpisode3Level(i - 1));
                addComma = 1;
            }
        }
    }
    dprint("\nEPISODE 4 -> ");
    addComma = 0;
    if(EndlessCastleEpisode4Flags == 0)
    {
        dprint("NONE");
    }
    else {
        for(i = 1; i < 9; i++) {
            bitFlag = fpow(2, i - 1);
            if(EndlessCastleEpisode4Flags & bitFlag)
            {
                if(addComma == 1)
                    dprint(", ");    
                dprint(ToEpisode4Level(i - 1));
                addComma = 1;
            }
        }
    }
    if(EndlessCastleEpisode3Flags & 128)
        dprint("\nend");
    dprint("\n--- CURRENT ENDLESS CASTLE CYCLE USED LEVELS ---\n");
	while(ATTEMPTS < MAX_ATTEMPTS) {
		rngEpisode = Random(1, 4);
		rngLevel = Random(1, 8);
		bitFlag = fpow(2, rngLevel - 1);					// Represents the "digit" in the level flags to check if the level had been spawned already
		if(rngEpisode == 1)
		{
			if(!(EndlessCastleEpisode1Flags & bitFlag))
			{
				EndlessCastleEpisode1Flags = EndlessCastleEpisode1Flags | bitFlag;
				return ToEpisode1Level(rngLevel - 1);
			}
		}
		else if(rngEpisode == 2 && rngLevel != 8)
		{
			if(!(EndlessCastleEpisode2Flags & bitFlag))
			{
				EndlessCastleEpisode2Flags = EndlessCastleEpisode2Flags | bitFlag;
				return ToEpisode2Level(rngLevel - 1);
			}
		}
		else if(rngEpisode == 3)
		{
			// Prevent rolling Shub-Niggurath's Lair among the first three Endless Castle Levels
			if(!(EndlessCastleEpisode3Flags & bitFlag) && (rngLevel == 8 && EndlessCastleMapCount >= 4))
			{
				EndlessCastleEpisode3Flags = EndlessCastleEpisode3Flags | bitFlag;
				return ToEpisode3Level(rngLevel - 1);
			}
		}
		else if(rngEpisode == 4)
		{
			if(!(EndlessCastleEpisode4Flags & bitFlag))
			{
				EndlessCastleEpisode4Flags = EndlessCastleEpisode4Flags | bitFlag;
				return ToEpisode4Level(rngLevel - 1);
			}
		}
		ATTEMPTS = ATTEMPTS + 1;
	}
	// If all 30 attempts have been exhausted, pick the earliest level it can encounter that has not been spawned.
    dprint("Looking for an unused Episode 1 level.\n");
	for(i = 1; i < 9; i++) {
		bitFlag = fpow(2, i - 1);
		if(!(EndlessCastleEpisode1Flags & bitFlag))
		{
			EndlessCastleEpisode1Flags = EndlessCastleEpisode1Flags | bitFlag;
			return ToEpisode1Level(i - 1);
		}
	}
    dprint("Looking for an unused Episode 2 level.\n");
	for(i = 1; i < 8; i++) {
		bitFlag = fpow(2, i - 1);
		if(!(EndlessCastleEpisode2Flags & bitFlag))
		{
			EndlessCastleEpisode2Flags = EndlessCastleEpisode2Flags | bitFlag;
			return ToEpisode2Level(i - 1);
		}
	}
    dprint("Looking for an unused Episode 3 level (or end).\n");
	for(i = 1; i < 9; i++) {
		bitFlag = fpow(2, i - 1);
		if(bitFlag != 8)
		{
			if(!(EndlessCastleEpisode3Flags & bitFlag))
			{
				EndlessCastleEpisode3Flags = EndlessCastleEpisode3Flags | bitFlag;
				return ToEpisode3Level(i - 1);
			}
		}
	}
    dprint("Looking for an unused Episode 4 level.\n");
	for(i = 1; i < 9; i++) {
		bitFlag = fpow(2, i - 1);
		if(!(EndlessCastleEpisode4Flags & bitFlag))
		{
			EndlessCastleEpisode4Flags = EndlessCastleEpisode4Flags | bitFlag;
			return ToEpisode4Level(i - 1);
		}
	}
	// But if it can't find any, it gives up, restarts randomization, and sends a specific map.
	EndlessCastleEpisode1Flags = 0;
	EndlessCastleEpisode2Flags = 0;
	EndlessCastleEpisode3Flags = 0;
	EndlessCastleEpisode4Flags = 0;
    dprint("Unsatisfactory randomization. Picking e4m3 instead.\n");
	return "e4m3";
};

string(float level) ToEpisode1Level = {
	local string maps[] = { "e1m1", "e1m2", "e1m3", "e1m4", "e1m5", "e1m6", "e1m7", "e1m8" };
	return maps[level];
}

string(float level) ToEpisode2Level = {
	local string maps[] = { "e2m1", "e2m2", "e2m3", "e2m4", "e2m5", "e2m6", "e2m7" };
	return maps[level];
}

string(float level) ToEpisode3Level = {
	local string maps[] = { "e3m1", "e3m2", "e3m3", "e3m4", "e3m5", "e3m6", "e3m7", "end" };
	return maps[level];
}

string(float level) ToEpisode4Level = {
	local string maps[] = { "e4m1", "e4m2", "e4m3", "e4m4", "e4m5", "e4m6", "e4m7", "e4m8" };
	return maps[level];
}

float GetElapsedTime() {
    float currentTime = time; // Get the current time
    float elapsedTime = currentTime - startTime; // Calculate elapsed time in seconds
    return elapsedTime;
}