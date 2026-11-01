
// Picking a random level for Endless Castle mode
//
// The levels are served from a shuffled "bag": every level is handed out exactly once before the bag is reshuffled.
// Instead of remembering WHICH levels were already used (one bit per level, which doesn't scale), only the seed that
// shuffled the bag and how many levels were already taken from it are remembered. The order is rebuilt from the seed
// whenever it is needed. That is 16 + 7 bits no matter how many levels are in the pool.
// To add levels, append them to LevelNames (up to BAG_MAX_LEVELS in total).

float BAG_MAX_LEVELS = 127;									// The index is stored in 7 bits.
float BAG_SAFE_PREFIX = 6;									// A fresh bag never serves the map being played among its first picks (one level load may pick once per exit).
float BAG_END_MIN_POSITION = 8;								// If the run just began, Shub-Niggurath's Pit ("end") isn't among the first picks of the bag.

float EndlessCastleBagSeed;									// 16 bit integer [1; 65535]. The seed the current bag was shuffled with. 0 if there is no bag yet.
float EndlessCastleBagIndex;								// 7 bit integer. How many levels were already taken from the current bag.

// Dissolution of Eternity: r2m8 is left out, it ends with a long cutscene.
string LevelNames[] = {
	"e1m1", "e1m2", "e1m3", "e1m4", "e1m5", "e1m6", "e1m7", "e1m8",
	"e2m1", "e2m2", "e2m3", "e2m4", "e2m5", "e2m6", "e2m7",
	"e3m1", "e3m2", "e3m3", "e3m4", "e3m5", "e3m6", "e3m7", "end",
	"e4m1", "e4m2", "e4m3", "e4m4", "e4m5", "e4m6", "e4m7", "e4m8",
	"r1m1", "r1m2", "r1m3", "r1m4", "r1m5", "r1m6", "r1m7", "r2m1", "r2m2", "r2m3", "r2m4", "r2m5", "r2m6", "r2m7",
	"hip1m1", "hip1m2", "hip1m3", "hip1m4", "hip1m5", "hip2m1", "hip2m2", "hip2m3", "hip2m4", "hip2m5", "hip2m6", "hip3m1", "hip3m2", "hip3m3", "hip3m4", "hipdm1"
};

float BagOrder[128];										// LevelNames indexes in the order the current bag serves them.
float BagState;

void() PrintCurrentLevelCycle;
string() PickNextLevel;
float() GetElapsedTime;
void(float bagSeed) BuildBag;
void() StartNewBag;
float() NextBagNumber;

// Tiny deterministic generator (the ZX81 one: full period modulo 65537). The products stay under 2^23, so they are exact in a float.
// The shared rand() can't be used here, because the bag has to be rebuilt identically in every level.
float() NextBagNumber = {
	BagState = mod(BagState * 75 + 74, 65537);
	return BagState;
};

// Shuffles BagOrder (Fisher-Yates) in a way that depends only on the seed.
void(float bagSeed) BuildBag = {
	local float i, j, swap, count;
	count = LevelNames.length;
	for(i = 0; i < count; i++)
		BagOrder[i] = i;
	BagState = bagSeed;
	for(i = count - 1; i > 0; i--)
	{
		j = floor(NextBagNumber() / 65537 * (i + 1));
		if(j > i) j = i;
		swap = BagOrder[i];
		BagOrder[i] = BagOrder[j];
		BagOrder[j] = swap;
	}
};

// Looks for a seed whose shuffle respects the rules, since the order can't be fixed after the fact.
void() StartNewBag = {
	local float attempts, i, count, valid;
	count = LevelNames.length;
	if(count > BAG_MAX_LEVELS)
		dprint("There are more levels than the bag can index. Raise the bits reserved for EndlessCastleBagIndex.\n");
	for(attempts = 0; attempts < 100; attempts++)
	{
		EndlessCastleBagSeed = Random(1, 65535);
		BuildBag(EndlessCastleBagSeed);
		valid = TRUE;
		for(i = 0; i < BAG_SAFE_PREFIX && i < count; i++)
		{
			if(LevelNames[BagOrder[i]] == mapname)
				valid = FALSE;
		}
		if(EndlessCastleMapCount < 4)
		{
			for(i = 0; i < BAG_END_MIN_POSITION && i < count; i++)
			{
				if(LevelNames[BagOrder[i]] == "end")
					valid = FALSE;
			}
		}
		if(valid) break;
	}
	EndlessCastleBagIndex = 0;
	dprint("Started a new level bag with seed ");
	dprint(ftos(EndlessCastleBagSeed));
	dprint(".\n");
};

string() PickNextLevel = {
	local string pickedLevel;
	if(EndlessCastleMapCount == 0) return "";
	if(EndlessCastleBagSeed == 0 || EndlessCastleBagIndex >= LevelNames.length)
		StartNewBag();
	else
		BuildBag(EndlessCastleBagSeed);
	pickedLevel = LevelNames[BagOrder[EndlessCastleBagIndex]];
	EndlessCastleBagIndex = EndlessCastleBagIndex + 1;
	dprint("Level ");
	dprint(pickedLevel);
	dprint(" is valid. Setting it as an exit (");
	dprint(ftos(EndlessCastleBagIndex));
	dprint("/");
	dprint(ftos(LevelNames.length));
	dprint(" of the bag).\n");
	return pickedLevel;
};

float() GetElapsedTime = {
    float currentTime = time; // Get the current time
    float elapsedTime = currentTime - startTime; // Calculate elapsed time in seconds
    return elapsedTime;
}

void() PrintCurrentLevelCycle = {
	local float i;
	dprint("--- CURRENT ENDLESS CASTLE CYCLE USED LEVELS ---\n");
	if(EndlessCastleBagSeed == 0 || EndlessCastleBagIndex == 0)
	{
		dprint("NONE");
	}
	else
	{
		BuildBag(EndlessCastleBagSeed);
		for(i = 0; i < EndlessCastleBagIndex && i < LevelNames.length; i++)
		{
			if(i > 0)
				dprint(", ");
			dprint(LevelNames[BagOrder[i]]);
		}
	}
	dprint("\n--- CURRENT ENDLESS CASTLE CYCLE USED LEVELS ---\n");
}
