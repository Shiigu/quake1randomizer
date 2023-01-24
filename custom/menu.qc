float InRandomMenu; // 1 if in the menus, 0 otherwise. Used to take priority on impulses.
float CurrentMenu;  // Contains the current menu the player is
    float MAIN_MENU = 1;            // Main Menu
    float UNBIASED_MENU = 2;        // Menu to enable or disable Unbiased Mode
    float BACKPACKS_MENU = 3;       // Menu to enable or disable Backpack Mode
    float SPECIFY_RANDOM_MENU = 4;  // Menu to enable or disable certain randomizations
    float RANDOMIZED_LIST_MENU = 5; // Randomized List Menu
    float SEED_MENU = 6;            // Seed Menu
    float FINAL_MENU = 7;           // All Menus whose only option is to return to the main menu

entity InputCapturer; // Will take hold of the number keys until the player closes the menu or its think time expires
entity Client;     // Stores the client entity.
float CaptureTime; // Time (in seconds) in which the menu will capture all numeric inputs
float Centertime; // Old scr_centertime value to reset it once the player leaves the menu

void() EnterRandomMenu;
void() MainMenu;
void() UnbiasedMenu;
void() BackpacksMenu;
void() RandomizedListMenu;
void() SpecifyRandomMenu;
void() SeedMenu;
void() AboutMenu;
void() ExitRandomMenu;
void() CheckMenuImpulses;

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
    cvar_set("scr_centertime", ftos(CaptureTime)); // Temporarily change the message display time
    InputCapturer = spawn();
    InputCapturer.think = ExitRandomMenu;
    MainMenu();
};

void() MainMenu = {
    local string modTitle, randomMode, backpackMode, option1, option2, fixedOptions;
    modTitle = "=== Quake Randomizer Mod ===\n\n";
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
    fixedOptions = "[3] List of randomized objects\n[4] Specify randomization\n[5] Seed settings\n[6] About\n[7] Exit Menu";
    centerprint (Client, modTitle, randomMode, backpackMode, option1, option2, fixedOptions);
    CurrentMenu = MAIN_MENU;
    InputCapturer.nextthink = time + CaptureTime;
};

void() UnbiasedMenu = {
    if(UnbiasedMode)
        centerprint (Client, "=== Biased Mode ===\n\n", "When enabled, the game will randomize\n everything in a way it finds fair.\n\n", "Do you want to set the\nRandomizer to Biased?\n\n", "[1] Yes\n[2] No");
    else
        centerprint (Client, "=== Unbiased Mode ===\n\n", "WARNING\n\n", "When enabled, the game will randomize\neverything without regard on whether\nthe map becomes unbeatable!\n\n", "Do you really want to set\nthe Randomizer to Unbiased?\n\n", "[1] Yes\n[2] No");
    CurrentMenu = UNBIASED_MENU;
    InputCapturer.nextthink = time + CaptureTime;
};

void() BackpacksMenu = {
    if(HideInBackpacks)
        centerprint (Client, "=== Backpack Mode ===\n\n", "When disabled, the game will show weapons\nand ammo crates as it does by default.\n\n", "Do you want to\ndisable Backpack Mode?\n\n", "[1] Yes\n[2] No");
    else
        centerprint (Client, "=== Backpack Mode ===\n\n", "WARNING\n\n", "When enabled, the game will hide weapons\nand ammo crates inside backpacks. You\nwon't know what you get until you\npick the backpack up!\n\n", "Do you really want to\nenable Backpack Mode?\n\n", "[1] Yes\n[2] No");
    CurrentMenu = BACKPACKS_MENU;
    InputCapturer.nextthink = time + CaptureTime;
};

void() RandomizedListMenu = {
    centerprint (Client, "=== RANDOMIZER LOG ===\n\n", "You wish to see the list of\nentities after randomization.\n\nThis is almost like cheating.\nDo you want to do this?\n\n", "[1] List of randomized objects\n[2] Return to Main Menu");
    CurrentMenu = RANDOMIZED_LIST_MENU;
};

void() SpecifyRandomMenu = {
    local string menuHeader, option1, option2, option3, option4, fixedOptions;
    menuHeader = "=== Specify Randomization ===\n\nCurrent randomizer settings:\n\n";
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
    fixedOptions = "\n(This won't take effect until\n a level is loaded)\n\n[5] Return to Main Menu";
    centerprint (Client, menuHeader, option1, option2, option3, option4, fixedOptions);
    InputCapturer.nextthink = time + CaptureTime;
    CurrentMenu = SPECIFY_RANDOM_MENU;
};

void() SeedMenu = {
    if(seedIsFixed)
        centerprint (Client, "Current seed is\n", ftos(seed), "\n\nThe seed is currently fixed.\nThe same map will ALWAYS give\nthe same entities.\n\n", "Do you wish to make\nthe seed dynamic again?\n\n", "[1] Yes\n[2] No");
    else
        centerprint (Client, "Current seed is\n", ftos(seed), "\n\nThe seed is currently dynamic.\nAll entities will be rerolled, even\non the same map.\n\n", "Do you wish to fix\nthe seed to the current value?\n\n", "[1] Yes\n[2] No");
    CurrentMenu = SEED_MENU;
};

void() AboutMenu = {
    centerprint (Client, "=== About the Quake Randomizer Mod ===\n\n", "Created by Shiigu\n\n", "Source Code:https://github.com/\nShiigu/quake1randomizer\n\n", "(Help is appreciated!)\n\n[1] Return to Main Menu");
    CurrentMenu = FINAL_MENU;
};

void() CheckMenuImpulses = {
	if (self.impulse == 24)
	{
        EnterRandomMenu ();
        return;
    }
    local string warning;
    if(CurrentMenu == MAIN_MENU)
    {
        if(self.impulse == 1)
            UnbiasedMenu();
        if(self.impulse == 2)
            BackpacksMenu();
        if(self.impulse == 3)
            RandomizedListMenu();
        if(self.impulse == 4)
            SpecifyRandomMenu();
        if(self.impulse == 5)
            SeedMenu();
        if(self.impulse == 6)
            AboutMenu();
        if(self.impulse == 7)
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
            centerprint (Client, "=== WARNING ===\n\n", warning, "(This won't take effect until\n a level is loaded)\n\n[1] Return to Main Menu");
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
            centerprint (Client, "=== WARNING ===\n\n", warning, "(This won't take effect until\n a level is loaded)\n\n[1] Return to Main Menu");
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
            LogResults();
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
            if(seedIsFixed)
            {
                centerprint (Client, "=== WARNING ===\n\n", "Seed is no longer fixed\n\n", "(This won't take effect until\n a level is loaded)", "\n\nYou can set this seed back in\nthe future with the following\nconsole command:\ngamecfg ", ftos(seed), "\n\n[1] Return to Main Menu");
                cvar_set("gamecfg", "0");
                seedIsFixed = 0;
                CurrentMenu = FINAL_MENU;
            }
            else 
            {
                centerprint (Client, "=== WARNING ===\n\n", "Seed is now fixed to ", ftos(seed), "\n\n", "(This won't take effect until\n a level is loaded)", "\n\nYou can set this seed back in\nthe future with the following\nconsole command:\ngamecfg ", ftos(seed), "\n\n[1] Return to Main Menu");
                cvar_set("gamecfg", ftos(seed));
                seedIsFixed = 1;
                CurrentMenu = FINAL_MENU;
            }
        }
        if(self.impulse == 2)
            ExitRandomMenu();
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
    cvar_set("scr_centertime", ftos(Centertime));
    InRandomMenu = 0;
    remove(InputCapturer);
};