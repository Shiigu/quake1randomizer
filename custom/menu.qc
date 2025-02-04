
float MAIN_MENU = 1;                        // Main Menu
float UNBIASED_MENU = 2;                    // Menu to enable or disable Unbiased Mode
float BACKPACKS_MENU = 3;                   // Menu to enable or disable Backpack Mode
float SPECIFY_RANDOM_MENU = 4;              // Menu to enable or disable certain randomizations
float NIGHTMARE_MENU = 5;                   // Menu to enable or disable Remastered Nightmare settings
float RANDOMIZED_LIST_MENU = 6;             // Randomized List Menu
float SEED_MENU = 7;                        // Seed Menu
float ENDLESS_CASTLE_MENU = 8;              // Menu to enable or disable Endless Castle Mode
float SKILL_SELECT_MENU = 9;                // Menu to select Endless Castle difficulty
float ENDLESS_CASTLE_PROGRESS_MENU = 10;    // Menu to enable or disable Endless Castle Mode
float FINISHED_ENDLESS_CASTLE_MENU = 11;    // Menu to restart or end Endless Castle Mode
float FINAL_MENU = 12;                      // All Menus whose only option is to return to the main menu

entity InputCapturer; // Will take hold of the number keys until the player closes the menu or its think time expires
entity Client;     // Stores the client entity.
float CaptureTime; // Time (in seconds) in which the menu will capture all numeric inputs
float FinalEndlessCastleLevel;

void() MainMenu;
void() UnbiasedMenu;
void() BackpacksMenu;
void() RandomizedListMenu;
void() RemasteredOrClassicNightmareMenu;
void() SpecifyRandomMenu;
void() SeedMenu;
void() EndlessCastleMenu;
void() EndlessCastleDifficultyMenu;
void() EndedEndlessCastleMenu;
void() SetEndlessCastleParms;
void() AboutMenu;
void() ExitRandomMenu;
void() PrintEndlessCastleStats;

string() GetBaseDifficultyString;
string() GetCurrentDifficultyString;

void() EnterRandomMenu = {
    RandomMode = cvar("savedgamecfg");
    cvar_set("savedgamecfg", ftos(RandomMode)); // Just in case it was never present in the config file
    UnbiasedMode = RandomMode & RANDOM_UNBIASED_MODE;
    HideInBackpacks = RandomMode & RANDOM_BACKPACK_MODE;
    RandomizeMonsters = (RandomMode & DO_NOT_RANDOMIZE_MONSTERS) == 0;
    RandomizeWeaponsAndAmmo = (RandomMode & DO_NOT_RANDOMIZE_WEAPONS_AND_AMMO) == 0;
    RandomizeHealthAndArmor = (RandomMode & DO_NOT_RANDOMIZE_HEALTH_AND_ARMOR) == 0;
    RandomizePowerups = (RandomMode & DO_NOT_RANDOMIZE_POWERUPS) == 0;
    Client = self;
    InRandomMenu = 1;
    CaptureTime = 5;
    Centertime = cvar("scr_centertime");
    SetCentertime(CaptureTime);             // Temporarily change the message display time
    InputCapturer = spawn();
    InputCapturer.think = ExitRandomMenu;
    MainMenu();
};

void() MainMenu = {
    local string modTitle, randomMode, backpackMode, option1, option2, fixedOptions;
    modTitle = "\(\=\= Quake Randomizer Mod \=\=\)\n\n";
    if(UnbiasedMode)
    {
        randomMode = "Current Randomizer Mode is Unbiased\n";
        option1 = "[1] Set Randomizer to Biased\n";
    }
    else
    {
        randomMode = "Current Randomizer Mode is Biased\n";
        option1 = "[1] Set Randomizer to Unbiased\n";
    }
    if(HideInBackpacks)
    {
        backpackMode = "Backpack Mode is Enabled\n\n";
        option2 = "[2] Disable Backpack Mode\n";
    }
    else
    {
        backpackMode = "Backpack Mode is Disabled\n\n";
        option2 = "[2] Enable Backpack Mode\n";
    }
    fixedOptions = "[3] Endless Castle Mode\n[4] Change Nightmare settings\n[5] List of randomized objects\n[6] Specify randomization\n[7] Seed settings\n[8] About\n[9] Exit Menu";
    centerprint (Client, modTitle, randomMode, backpackMode, option1, option2, fixedOptions);
    CurrentMenu = MAIN_MENU;
    InputCapturer.nextthink = time + CaptureTime;
};

void() UnbiasedMenu = {
    if(EndlessCastleMapCount == 0)
    {
        if(UnbiasedMode)
            centerprint (Client, "\(\=\= Biased Mode \=\=\)\n\n", "When enabled, the game will randomize\n everything in a way it finds fair.\n\n", "Do you want to set the\nRandomizer to Biased?\n\n", "[1] Yes\n[2] No");
        else
            centerprint (Client, "\(\=\= Unbiased Mode \=\=\)\n\n", "WARNING\n\n", "When enabled, the game will randomize\neverything without regard on whether\nthe map becomes unbeatable!\n\n", "Do you really want to set\nthe Randomizer to Unbiased?\n\n", "[1] Yes\n[2] No");
        CurrentMenu = UNBIASED_MENU;
        InputCapturer.nextthink = time + CaptureTime;
    }
    else
    {
        if(UnbiasedMode)
            centerprint (Client, "\(\=\= Biased Mode \=\=\)\n\n", "When enabled, the game will randomize\n everything in a way it finds fair.\n\n", "(This can't be changed until\nEndless Castle is over)\n\n", "[1] Return to Main Menu");
        else
            centerprint (Client, "\(\=\= Unbiased Mode \=\=\)\n\n", "When enabled, the game will randomize\neverything without regard on whether\nthe map becomes unbeatable!\n\n", "(This can't be changed until\nEndless Castle is over)\n\n", "[1] Return to Main Menu");
        CurrentMenu = FINAL_MENU;
    }
};

void() BackpacksMenu = {
    if(EndlessCastleMapCount == 0)
    {
        if(HideInBackpacks)
            centerprint (Client, "\(\=\= Backpack Mode \=\=\)\n\n", "When disabled, the game will show weapons\nand ammo crates as it does by default.\n\n", "Do you want to\ndisable Backpack Mode?\n\n", "[1] Yes\n[2] No");
        else
            centerprint (Client, "\(\=\= Backpack Mode \=\=\)\n\n", "WARNING\n\n", "When enabled, the game will hide weapons\nand ammo crates inside backpacks. You\nwon't know what you get until you\npick the backpack up!\n\n", "Do you really want to\nenable Backpack Mode?\n\n", "[1] Yes\n[2] No");
        CurrentMenu = BACKPACKS_MENU;
        InputCapturer.nextthink = time + CaptureTime;
    }
    else
    {
        if(HideInBackpacks)
            centerprint (Client, "\(\=\= Backpack Mode \=\=\)\n\n", "When disabled, the game will show weapons\nand ammo crates as it does by default.\n\n", "(This can't be changed until\nEndless Castle is over)\n\n", "[1] Return to Main Menu");
        else
            centerprint (Client, "\(\=\= Backpack Mode \=\=\)\n\n", "When enabled, the game will hide weapons\nand ammo crates inside backpacks. You\nwon't know what you get until you\npick the backpack up!\n\n", "(This can't be changed until\nEndless Castle is over)\n\n", "[1] Return to Main Menu");
        CurrentMenu = FINAL_MENU;
    }
};

void() EndlessCastleMenu = {
    if(EndlessCastleMapCount == 0)
    {
        if(seedIsFixed)
            centerprint (Client, "\(\=\= Endless Castle Mode \=\=\)\n\n", "WARNING\n\n", "This mode sends you to an endless,\nrandom sequence of Quake levels.\n\nThis can't be disabled until you die\nor restart.\n\nAre you up to it?\n(NOTE: Seed will be made dynamic\nas long as this mode is enabled)\n\n[1] Enter Endless Castle\n[2] Return to Main Menu");
        else
            centerprint (Client, "\(\=\= Endless Castle Mode \=\=\)\n\n", "WARNING\n\n", "This mode sends you to an endless,\nrandom sequence of Quake levels.\n\nThis can't be disabled until you die\nor restart.\n\nAre you up to it?\n\n[1] Enter Endless Castle\n[2] Return to Main Menu");
        CurrentMenu = ENDLESS_CASTLE_MENU;
        InputCapturer.nextthink = time + CaptureTime;
    }
    else
    {
        centerprint (Client, "\(\=\= Endless Castle Mode  \=\=\)\n\nYou are currently at Level ", ftos(EndlessCastleMapCount), ".\n\nDifficulty level: ", GetCurrentDifficultyString(), ".\n(Map difficulty level: ", ftos(EndlessCastleMapDifficulty), ")\n\n[1] Print Current Stats\n[2] Return to Main Menu");
        CurrentMenu = ENDLESS_CASTLE_PROGRESS_MENU;
    }
};

void() EndlessCastleDifficultyMenu = {
    InSkillSelect = 1;
    if(FinalEndlessCastleLevel == 0)
        centerprint (Client, "\(\=\= Endless Castle Mode \=\=\)\n\n", "DIFFICULTY SELECTION\n\n", "Please pick the difficulty\nlevel for the next Endless Castle\n\n[1] Easy\n[2] Normal\n[3] Hard\n[4] Nightmare\n[5] Super Nightmare\n[6] Unfair\n[7] Return to Main Menu");
    else
        centerprint (Client, "\(\=\= Endless Castle Mode \=\=\)\n\n", "DIFFICULTY SELECTION\n\n", "Please pick the difficulty\nlevel for the next Endless Castle\n\n[1] Easy\n[2] Normal\n[3] Hard\n[4] Nightmare\n[5] Super Nightmare\n[6] Unfair\n[7] Cancel selection");
    CurrentMenu = SKILL_SELECT_MENU;
    InputCapturer.nextthink = time + CaptureTime;
};

void() EndedEndlessCastleMenu = {
    if(EndlessCastleMapCount > 0)
        FinalEndlessCastleLevel = EndlessCastleMapCount;
    InRandomMenu = 1;
    CaptureTime = 100000;
    InputCapturer = spawn();
    InputCapturer.think = ExitRandomMenu;
    InputCapturer.nextthink = time + CaptureTime;
    Client = self;
    centerprint (Client, "\(\=\= Brave Warrior's Obituary \=\=\)\n\nYour trek through the Endless Castle\nhas ended at level ", ftos(FinalEndlessCastleLevel), "\n\nDifficulty level: ", GetBaseDifficultyString(),".\n\nYour performance has been\nprinted to the console.\n\n[1] Restart Endless Castle\n[2] Return to Introduction");
    CurrentMenu = FINISHED_ENDLESS_CASTLE_MENU;
};

void() RemasteredOrClassicNightmareMenu = {
    if(EndlessCastleMapCount == 0)
    {
        if(IsRemastered())
            centerprint (Client, "\(\=\= Nightmare Settings \=\=\)\n\n", "Settings are set to\nRemastered Mode\n\n(50 Maximum Health and\nMonsters fire normally).\n\n", "Do you want to change\nto Classic Nightmare Mode?\n\n", "[1] Yes\n[2] No");
        else
            centerprint (Client, "\(\=\= Nightmare Settings \=\=\)\n\n", "Settings are set to\nClassic Mode\n\n(100 Maximum Health and\nMonsters fire very quickly).\n\n", "Do you want to change\nto Remastered Nightmare Mode?\n\n", "[1] Yes\n[2] No");
        CurrentMenu = NIGHTMARE_MENU;
        InputCapturer.nextthink = time + CaptureTime;
    }
    else
    {
        if(IsRemastered())
            centerprint (Client, "\(\=\= Nightmare Settings \=\=\)\n\n", "Settings are set to\nRemastered Mode\n\n(50 Maximum Health and\nMonsters fire normally).\n\n", "(This can't be changed until\nEndless Castle is over)\n\n", "[1] Return to Main Menu");
        else
            centerprint (Client, "\(\=\= Nightmare Settings \=\=\)\n\n", "Settings are set to\nClassic Mode\n\n(100 Maximum Health and\nMonsters fire very quickly).\n\n", "(This can't be changed until\nEndless Castle is over)\n\n", "[1] Return to Main Menu");
        CurrentMenu = FINAL_MENU;
    }
}

void() RandomizedListMenu = {
    if(EndlessCastleMapCount == 0)
    {
        centerprint (Client, "\(\=\= RANDOMIZER LOG \=\=\)\n\n", "You wish to see the list of\nentities after randomization.\n\nThis is almost like cheating.\nDo you want to do this?\n\n", "[1] List of randomized objects\n[2] Return to Main Menu");
        CurrentMenu = RANDOMIZED_LIST_MENU;
        InputCapturer.nextthink = time + CaptureTime;
    }
    else
    {
        centerprint (Client, "\(\=\= RANDOMIZER LOG \=\=\)\n\n", "You cannot see the list of\nentities after randomization\nDuring Endless Castle Mode.\n\n", "[1] Return to Main Menu");
        CurrentMenu = FINAL_MENU;
    }
};

void() SpecifyRandomMenu = {
    local string menuHeader, option1, option2, option3, option4, fixedOptions;
    menuHeader = "\(\=\= Specify Randomization  \=\=\)\n\nCurrent randomizer settings:\n\n";
    if(EndlessCastleMapCount == 0)
    {
        if(RandomizeMonsters)
            option1 = "[1] Randomize Monsters\n";
        else
            option1 = "[1] Don't Randomize Monsters\n";
        if(RandomizeWeaponsAndAmmo)
            option2 = "[2] Randomize Weapons and Ammo\n";
        else
            option2 = "[2] Don't Randomize Weapons and Ammo\n";
        if(RandomizeHealthAndArmor)
            option3 = "[3] Randomize Health and Armor\n";
        else
            option3 = "[3] Don't Randomize Health and Armor\n";
        if(RandomizePowerups)
            option4 = "[4] Randomize Powerups\n";
        else
            option4 = "[4] Don't Randomize Powerups\n";
        fixedOptions = "\n(This won't take effect until\na level is loaded)\n\n[5] Return to Main Menu";
        InputCapturer.nextthink = time + CaptureTime;
        CurrentMenu = SPECIFY_RANDOM_MENU;
    }
    else {
        if(RandomizeMonsters)
            option1 = "- Randomize Monsters\n";
        else
            option1 = "- Don't Randomize Monsters\n";
        if(RandomizeWeaponsAndAmmo)
            option2 = "- Randomize Weapons and Ammo\n";
        else
            option2 = "- Don't Randomize Weapons and Ammo\n";
        if(RandomizeHealthAndArmor)
            option3 = "- Randomize Health and Armor\n";
        else
            option3 = "- Don't Randomize Health and Armor\n";
        if(RandomizePowerups)
            option4 = "- Randomize Powerups\n";
        else
            option4 = "- Don't Randomize Powerups\n";
        fixedOptions = "\n(This can't be changed until\nEndless Castle is over)\n\n[1] Return to Main Menu";
        CurrentMenu = FINAL_MENU;
    }
    centerprint (Client, menuHeader, option1, option2, option3, option4, fixedOptions);
};

void() SeedMenu = {
    if(EndlessCastleMapCount == 0)
    {
        if(seedIsFixed)
            centerprint (Client, "Current seed is\n", ftos(seed), "\n\nThe seed is currently fixed.\nThe same map will ALWAYS give\nthe same entities.\n\n", "Do you wish to make\nthe seed dynamic again?\n\n", "[1] Yes\n[2] No");
        else
            centerprint (Client, "Current seed is\n", ftos(seed), "\n\nThe seed is currently dynamic.\nAll entities will be rerolled, even\non the same map.\n\n", "Do you wish to fix\nthe seed to the current value?\n\n", "[1] Yes\n[2] No");
        CurrentMenu = SEED_MENU;
        InputCapturer.nextthink = time + CaptureTime;
    }
    else
    {
        centerprint (Client, "Current seed is\n", ftos(seed), "\n\nThe seed is currently fixed.\nThe same map will ALWAYS give\nthe same entities.\n\n", "(Changing is currently disabled,\nas you are in Endless Castle)\n\n", "[1] Return to Main Menu");
        CurrentMenu = FINAL_MENU;
    }
};

void() AboutMenu = {
    centerprint (Client, "\(\=\= About the Quake Randomizer Mod \=\=\)\n\n", "Created by Shiigu\n\n", "Source Code:https://github.com/\nShiigu/quake1randomizer\n\n", "(Help is appreciated!)\n\n[1] Return to Main Menu");
    CurrentMenu = FINAL_MENU;
};

void() CheckMenuImpulses = {
	if (EndlessCastleMapCount != -1 && self.impulse == 24)
	{
        EnterRandomMenu ();
        return;
    }
    local string warning;
    SetCentertime(CaptureTime);
    if(CurrentMenu == MAIN_MENU)
    {
        if(self.impulse == 1)
            UnbiasedMenu();
        if(self.impulse == 2)
            BackpacksMenu();
        if(self.impulse == 3)
            EndlessCastleMenu();
        if(self.impulse == 4)
            RemasteredOrClassicNightmareMenu();
        if(self.impulse == 5)
            RandomizedListMenu();
        if(self.impulse == 6)
            SpecifyRandomMenu();
        if(self.impulse == 7)
            SeedMenu();
        if(self.impulse == 8)
            AboutMenu();
        if(self.impulse == 225)                     // "9" key, as it's now shared with the Laser Cannon
            ExitRandomMenu();
        return;
    }
    if(CurrentMenu == UNBIASED_MENU)
    {
        if(self.impulse == 1)
        {
            if(UnbiasedMode)
            {
                warning = "Biased Mode ENABLED\n\n";
                RandomMode = RandomMode - (RandomMode & RANDOM_UNBIASED_MODE);
                UnbiasedMode = 0;
                CurrentMenu = FINAL_MENU;
            }
            else 
            {
                warning = "Unbiased Mode ENABLED\n\n";
                RandomMode = RandomMode | RANDOM_UNBIASED_MODE;
                UnbiasedMode = 1;
                CurrentMenu = FINAL_MENU;
            }
            centerprint (Client, "\(\=\= WARNING \=\=\)\n\n", warning, "(This won't take effect until\na level is loaded)\n\n[1] Return to Main Menu");
            cvar_set("savedgamecfg", ftos(RandomMode));
        }
        if(self.impulse == 2)
            ExitRandomMenu();
        return;
    }
    if(CurrentMenu == BACKPACKS_MENU)
    {
        if(self.impulse == 1)
        {
            if(HideInBackpacks)
            {
                warning = "Backpack Mode DISABLED\n\n";
                RandomMode = RandomMode - (RandomMode & RANDOM_BACKPACK_MODE);
                HideInBackpacks = 0;
                CurrentMenu = FINAL_MENU;
            }
            else 
            {
                warning = "Backpack Mode ENABLED\n\n";
                RandomMode = RandomMode | RANDOM_BACKPACK_MODE;
                HideInBackpacks = 1;
                CurrentMenu = FINAL_MENU;
            }
            centerprint (Client, "\(\=\= WARNING \=\=\)\n\n", warning, "(This won't take effect until\na level is loaded)\n\n[1] Return to Main Menu");
            cvar_set("savedgamecfg", ftos(RandomMode));
        }
        if(self.impulse == 2)
            ExitRandomMenu();
        return;
    }
    if(CurrentMenu == NIGHTMARE_MENU)
    {
        if(self.impulse == 1)
        {
            if(IsRemastered())
            {
                warning = "Nightmare Mode is now\nusing Classic settings\n\n(100 Maximum Health and\nMonsters fire very quickly)\n\n";
                RandomMode = RandomMode - (RandomMode & USE_REMASTERED_NIGHTMARE_SETTINGS);
                HideInBackpacks = 0;
                CurrentMenu = FINAL_MENU;
            }
            else 
            {
                warning = "Nightmare Mode is now\nusing Remastered settings\n\n(50 Maximum Health and\nMonsters fire normally)\n\n";
                RandomMode = RandomMode | USE_REMASTERED_NIGHTMARE_SETTINGS;
                HideInBackpacks = 1;
                CurrentMenu = FINAL_MENU;
            }
            centerprint (Client, "\(\=\= WARNING \=\=\)\n\n", warning, "(This won't take effect until\na level is loaded)\n\n[1] Return to Main Menu");
            cvar_set("savedgamecfg", ftos(RandomMode));
        }
        if(self.impulse == 2)
            ExitRandomMenu();
        return;
    }
    if(CurrentMenu == RANDOMIZED_LIST_MENU)
    {
        if(self.impulse == 1)
        {
            LogRandomizerResults();
            centerprint (Client, "You can see the list of randomized\nentities in the console.\n\nEntities like bosses, keys or runes\nare not present in the list\nbecause they are never converted.\n\n[1] Return to Main Menu");
            CurrentMenu = FINAL_MENU;
        }
        if(self.impulse == 2)
            MainMenu();
        return;
    }
    if(CurrentMenu == SPECIFY_RANDOM_MENU)
    {
        if(self.impulse == 1)
        {
            if(RandomizeMonsters)
            {
                RandomMode = RandomMode | DO_NOT_RANDOMIZE_MONSTERS;
                RandomizeMonsters = 0;
            }
            else
            {
                RandomMode = RandomMode - (RandomMode & DO_NOT_RANDOMIZE_MONSTERS);
                RandomizeMonsters = 1;
            }
        }
        if(self.impulse == 2)
        {
            if(RandomizeWeaponsAndAmmo)
            {
                RandomMode = RandomMode | DO_NOT_RANDOMIZE_WEAPONS_AND_AMMO;
                RandomizeWeaponsAndAmmo = 0;
            }
            else
            {
                RandomMode = RandomMode - (RandomMode & DO_NOT_RANDOMIZE_WEAPONS_AND_AMMO);
                RandomizeWeaponsAndAmmo = 1;
            }
        }
        if(self.impulse == 3)
        {
            if(RandomizeHealthAndArmor)
            {
                RandomMode = RandomMode | DO_NOT_RANDOMIZE_HEALTH_AND_ARMOR;
                RandomizeHealthAndArmor = 0;
            }
            else
            {
                RandomMode = RandomMode - (RandomMode & DO_NOT_RANDOMIZE_HEALTH_AND_ARMOR);
                RandomizeHealthAndArmor = 1;
            }
        }
        if(self.impulse == 4)
        {
            if(RandomizePowerups)
            {
                RandomMode = RandomMode | DO_NOT_RANDOMIZE_POWERUPS;
                RandomizePowerups = 0;
            }
            else
            {
                RandomMode = RandomMode - (RandomMode & DO_NOT_RANDOMIZE_POWERUPS);
                RandomizePowerups = 1;
            }
        }
        if(self.impulse == 5)
        {
            MainMenu();
            return;
        }
        cvar_set("savedgamecfg", ftos(RandomMode));
        SpecifyRandomMenu();
        return;
    }
    if(CurrentMenu == SEED_MENU)
    {
        if(self.impulse == 1)
        {
            if(EndlessCastleMapCount <= 0)
            {
                if(seedIsFixed)
                {
                    centerprint (Client, "\(\=\= WARNING \=\=\)\n\n", "Seed is no longer fixed\n\n", "(This won't take effect until\na level is loaded)\n\nYou can set this seed back in\nthe future with the following\nconsole command:\ngamecfg ", ftos(seed), "\n\n[1] Return to Main Menu");
                    cvar_set("gamecfg", "0");
                    seedIsFixed = 0;
                    CurrentMenu = FINAL_MENU;
                }
                else 
                {
                    centerprint (Client, "\(\=\= WARNING \=\=\)\n\n", "Seed is now fixed to ", ftos(seed), "\n\n(This won't take effect until\na level is loaded)\n\nYou can set this seed back in\nthe future with the following\nconsole command:\ngamecfg ", ftos(seed), "\n\n[1] Return to Main Menu");
                    cvar_set("gamecfg", ftos(seed));
                    seedIsFixed = 1;
                    CurrentMenu = FINAL_MENU;
                }
            }
            else
                ExitRandomMenu();
        }
        if(self.impulse == 2)
            ExitRandomMenu();
        return;
    }
    if(CurrentMenu == ENDLESS_CASTLE_MENU)
    {
        if(self.impulse == 1)
        {
			EndlessCastleDifficultyMenu();
        }
        if(self.impulse == 2)
            MainMenu();
        return;
    }
    if(CurrentMenu == ENDLESS_CASTLE_PROGRESS_MENU)
    {
        if(self.impulse == 1)
        {
			PrintEndlessCastleStats();
            centerprint (Client, "You can see your current progress\nat the Endless Castle in the console.\n\n[1] Return to Main Menu");
            CurrentMenu = FINAL_MENU;
        }
        if(self.impulse == 2)
            MainMenu();
        return;
    }
    if(CurrentMenu == FINISHED_ENDLESS_CASTLE_MENU)
    {
        if(self.impulse == 1)
        {
			EndlessCastleDifficultyMenu();
        }
        if(self.impulse == 2)
        {
            if(Centertime != 0)
            {
                SetCentertime(Centertime);
                Centertime = 0;
            }
			EndlessCastleMapCount = 0;
			localcmd("map start\n");
        }
        return;
    }
    if(CurrentMenu == SKILL_SELECT_MENU)
    {
        InSkillSelect = 0;
        if(self.impulse == 1) EndlessCastleDifficultyLevel = 1;
        if(self.impulse == 2) EndlessCastleDifficultyLevel = 2;
        if(self.impulse == 3) EndlessCastleDifficultyLevel = 3;
        if(self.impulse == 4) EndlessCastleDifficultyLevel = 4;
        if(self.impulse == 5) EndlessCastleDifficultyLevel = 5;
        if(self.impulse == 6) EndlessCastleDifficultyLevel = 6;
        if(self.impulse == 7)
        {
            if(FinalEndlessCastleLevel == 0)
                MainMenu();
            else
                EndedEndlessCastleMenu();
            return;
        }
        SetEndlessCastleParms();
        changelevel(PickNextLevel());
        return;
    }
    if(CurrentMenu == FINAL_MENU)
    {
        if(self.impulse == 1)
            MainMenu();
        return;
    }
};

void() ExitRandomMenu = {
    centerprint (Client, string_null);
    SetCentertime(Centertime);
    Centertime = 0;
    InRandomMenu = 0;
    SUB_Remove_Target(InputCapturer);
};

void() SetEndlessCastleParms = {
	if(IsRemastered())
		self.health = 50;
	else
		self.health = 100;
    SetNewParms();
    self.items = IT_SHOTGUN | IT_AXE;
	self.armorvalue = 0;
	self.ammo_shells = 25;
	self.ammo_nails = 0;
	self.ammo_rockets = 0;
	self.ammo_cells = 0;
	self.weapon = 1;
	self.armortype = 0;
    localcmd("skill 3\n");
	SpawnedWeapons = 0;
    EndlessCastleMapCount = 1;
    FinalEndlessCastleLevel = 0;
	EndlessCastleEpisode1Flags = 0;
	EndlessCastleEpisode2Flags = 0;
	EndlessCastleEpisode3Flags = 0;
	EndlessCastleEpisode4Flags = 0;
	EndlessCastleElapsedTime = 0;
    EndlessCastleDeadMonsters = 0;
	EndlessCastleTotalMonsters = 0;
    EndlessCastleFoundSecrets = 0;
	EndlessCastleTotalSecrets = 0;
	EndlessCastleSeed = 0;
    ExitRandomMenu();
};

string() GetBaseDifficultyString = {
    if(EndlessCastleDifficultyLevel == 1) return "Easy";
    if(EndlessCastleDifficultyLevel == 2) return "Normal";
    if(EndlessCastleDifficultyLevel == 3) return "Hard";
    if(EndlessCastleDifficultyLevel == 4) return "Nightmare";
    if(EndlessCastleDifficultyLevel == 5) return "Super Nightmare";
    if(EndlessCastleDifficultyLevel == 6) return "Unfair";
    return "NULL";
};

string() GetCurrentDifficultyString = {
    if(EndlessCastleMapDifficulty >= ThresholdForUnfair) return "Unfair";
    if(EndlessCastleMapDifficulty >= ThresholdForSuperNightmare) return "Super Nightmare";
    if(EndlessCastleMapDifficulty >= ThresholdForNightmare) return "Nightmare";
    if(EndlessCastleMapDifficulty >= ThresholdForHard) return "Hard";
    if(EndlessCastleMapDifficulty >= ThresholdForNormal) return "Normal";
    return "Easy";
};

void() PrintEndlessCastleStats = {
    if(EndlessCastleDifficultyLevel == 0) return;
    bprint("\(\=\= ENDLESS CASTLE PERFORMANCE \=\=\)\n\n");
    if(FinalEndlessCastleLevel > 0)
        bprint("-> Final Map Level: ");
    else
        bprint("-> Current Map Level: ");
    bprint(ftos(EndlessCastleMapCount));
    bprint(".\n-> Base Difficulty: ");
    bprint(GetBaseDifficultyString());
    bprint(".\n-> Difficulty Level: ");
    bprint(ftos(EndlessCastleMapDifficulty));
    bprint(".\n-> Current Difficulty: ");
    bprint(GetCurrentDifficultyString());
    bprint(".\n-> Time Elapsed: ");

    local float hours, minutes, seconds, timeToUse, totalMonsters, deadMonsters, totalSecrets, foundSecrets;
    
    if(FinalEndlessCastleLevel > 0)
    {
        timeToUse = EndlessCastleElapsedTime;
        totalMonsters = EndlessCastleTotalMonsters;
        deadMonsters = EndlessCastleDeadMonsters;
        totalSecrets = EndlessCastleTotalSecrets;
        foundSecrets = EndlessCastleFoundSecrets;
    }
    else
    {
        timeToUse = EndlessCastleElapsedTime + time;
        totalMonsters = EndlessCastleTotalMonsters + total_monsters;
        deadMonsters = EndlessCastleDeadMonsters + killed_monsters;
        totalSecrets = EndlessCastleTotalSecrets + total_secrets;
        foundSecrets = EndlessCastleFoundSecrets + found_secrets;
    }

    hours = GetHours(timeToUse);
    minutes = GetMinutes(timeToUse);
    seconds = GetSeconds(timeToUse);
    
    if (hours < 10) bprint("0");
    bprint(ftos(hours));
    bprint(":");
    if (minutes < 10) bprint("0");
    bprint(ftos(minutes));
    bprint(":");
    if (seconds < 10) bprint("0");
    bprint(ftos(seconds));

    bprint(".\n-> Total Monsters Created: ");
    bprint(ftos(totalMonsters));
    bprint(".\n-> Total Monsters Dead: ");
    bprint(ftos(deadMonsters));
    bprint(" (");
    bprint(ftos(floor(deadMonsters / totalMonsters * 100)));
    bprint("%)");
    bprint(".\n-> Total Secrets Created: ");
    bprint(ftos(totalSecrets));
    bprint(".\n-> Total Secrets Found: ");
    bprint(ftos(foundSecrets));
    bprint(" (");
    bprint(ftos(floor(foundSecrets / totalSecrets * 100)));
    bprint("%)");
    bprint(".\n-> Endless Castle Seed: ");
    bprint(ftos(EndlessCastleSeed));
    bprint(".\n\n\(\=\= ENDLESS CASTLE PERFORMANCE \=\=\)\n\n");
};