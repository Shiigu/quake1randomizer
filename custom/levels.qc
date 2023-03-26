

// Picking a random level for Endless Castle mode

float LevelCount;								// Amount of Endless Castle levels in the current run.
float DeathToll;                                // Amount of dead monsters across all Endless Castle levels.
float Episode1Levels;							// 8 bit integer. MSE is e1m8, LSE is e1m1. If bit is "1" the level has been part of the cycle.
float Episode2Levels;							// 7 bit integer. MSE is e2m7, LSE is e2m1. If bit is "1" the level has been part of the cycle.
float Episode3Levels;							// 8 bit integer. MSE is end, LSE is e3m1. If bit is "1" the level has been part of the cycle.
float Episode4Levels;							// 8 bit integer. MSE is e4m8, LSE is e4m1. If bit is "1" the level has been part of the cycle.

string() PickNextLevel;
string(float level) ToEpisode1Level;
string(float level) ToEpisode2Level;
string(float level) ToEpisode3Level;
string(float level) ToEpisode4Level;

string() PickNextLevel = {
    if(LevelCount == 0) return "";
    local float rngEpisode, rngLevel, PASSED, levelFlag, bitFlag, ATTEMPTS, MAX_ATTEMPTS, i, addComma;
	ATTEMPTS = 0;
	MAX_ATTEMPTS = 30;
	if(Episode1Levels == 255 && Episode2Levels == 127 && Episode3Levels == 255 && Episode4Levels == 255)
	{
        dprint("Resetting level cycle.\n");
		// If all levels appeared exactly once, restart randomization
		Episode1Levels = 0;
		Episode2Levels = 0;
		Episode3Levels = 0;
		Episode4Levels = 0;
	}
    dprint("--- CURRENT MYSTERIOUS CASTLE CYCLE USED LEVELS ---\n");
    dprint("EPISODE 1 -> ");
    addComma = 0;
    if(Episode1Levels == 0)
    {
        dprint("NONE");
    }
    else {
        for(i = 1; i < 9; i++) {
            bitFlag = fpow(2, i - 1);
            if(Episode1Levels & bitFlag)
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
    if(Episode2Levels == 0)
    {
        dprint("NONE");
    }
    else {
        for(i = 1; i < 8; i++) {
            bitFlag = fpow(2, i - 1);
            if(Episode2Levels & bitFlag)
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
    if(Episode3Levels == 0 || Episode3Levels == 128)
    {
        dprint("NONE");
    }
    else {
        for(i = 1; i < 8; i++) {
            bitFlag = fpow(2, i - 1);
            if(Episode3Levels & bitFlag)
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
    if(Episode4Levels == 0)
    {
        dprint("NONE");
    }
    else {
        for(i = 1; i < 9; i++) {
            bitFlag = fpow(2, i - 1);
            if(Episode4Levels & bitFlag)
            {
                if(addComma == 1)
                    dprint(", ");    
                dprint(ToEpisode4Level(i - 1));
                addComma = 1;
            }
        }
    }
    if(Episode3Levels & 128)
        dprint("\nend");
    dprint("\n--- CURRENT MYSTERIOUS CASTLE CYCLE USED LEVELS ---\n");
	while(ATTEMPTS < MAX_ATTEMPTS) {
		rngEpisode = Random(1, 4);
		rngLevel = Random(1, 8);
		bitFlag = fpow(2, rngLevel - 1);					// Represents the "digit" in the level flags to check if the level had been spawned already
		if(rngEpisode == 1)
		{
			if(!(Episode1Levels & bitFlag))
			{
				Episode1Levels = Episode1Levels | bitFlag;
				return ToEpisode1Level(rngLevel - 1);
			}
		}
		else if(rngEpisode == 2 && rngLevel != 8)
		{
			if(!(Episode2Levels & bitFlag))
			{
				Episode2Levels = Episode2Levels | bitFlag;
				return ToEpisode2Level(rngLevel - 1);
			}
		}
		else if(rngEpisode == 3)
		{
			if(!(Episode3Levels & bitFlag))
			{
				Episode3Levels = Episode3Levels | bitFlag;
				return ToEpisode3Level(rngLevel - 1);
			}
		}
		else if(rngEpisode == 4)
		{
			if(!(Episode4Levels & bitFlag))
			{
				Episode4Levels = Episode4Levels | bitFlag;
				return ToEpisode4Level(rngLevel - 1);
			}
		}
		ATTEMPTS = ATTEMPTS + 1;
	}
	// If all 30 attempts have been exhausted, pick the earliest level it can encounter that has not been spawned.
    dprint("Looking for an unused Episode 1 level.\n");
	for(i = 1; i < 9; i++) {
		bitFlag = fpow(2, i - 1);
		if(!(Episode1Levels & bitFlag))
		{
			Episode1Levels = Episode1Levels | bitFlag;
			return ToEpisode1Level(i - 1);
		}
	}
    dprint("Looking for an unused Episode 2 level.\n");
	for(i = 1; i < 8; i++) {
		bitFlag = fpow(2, i - 1);
		if(!(Episode2Levels & bitFlag))
		{
			Episode2Levels = Episode2Levels | bitFlag;
			return ToEpisode2Level(i - 1);
		}
	}
    dprint("Looking for an unused Episode 3 level (or end).\n");
	for(i = 1; i < 9; i++) {
		bitFlag = fpow(2, i - 1);
		if(!(Episode3Levels & bitFlag))
		{
			Episode3Levels = Episode3Levels | bitFlag;
			return ToEpisode3Level(i - 1);
		}
	}
    dprint("Looking for an unused Episode 4 level.\n");
	for(i = 1; i < 9; i++) {
		bitFlag = fpow(2, i - 1);
		if(!(Episode4Levels & bitFlag))
		{
			Episode4Levels = Episode4Levels | bitFlag;
			return ToEpisode4Level(i - 1);
		}
	}
	// But if it can't find any, it gives up, restarts randomization, and sends a specific map.
	Episode1Levels = 0;
	Episode2Levels = 0;
	Episode3Levels = 0;
	Episode4Levels = 0;
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