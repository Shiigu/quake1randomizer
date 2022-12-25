float InRandomMenu; // 1 if in the menus, 0 otherwise. Used to take priority on impulses.
float CurrentMenu;  // Contains the current menu the player is
    float MAIN_MENU = 1;        // Main Menu
    float UNBIASED_MENU = 2;    // Menu to enable or disable Unbiased Mode
    float BACKPACKS_MENU = 3;   // Menu to enable or disable Backpack Mode
    float RANDOMIZED_LIST_MENU = 4;       // Randomized List Menu
    float SEED_MENU = 5;       // Seed Menu
    float FINAL_MENU = 6;       // All Menus whose only option is to return to the main menu

entity InputCapturer; // Will take hold of the number keys until the player closes the menu or its think time expires
entity Client;     // Stores the client entity.
float CaptureTime; // Time (in seconds) in which the menu will capture all numeric inputs
float Centertime; // Old scr_centertime value to reset it once the player leaves the menu

void() EnterRandomMenu;
void() MainMenu;
void() UnbiasedMenu;
void() BackpacksMenu;
void() RandomizedListMenu;
void() SeedMenu;
void() AboutMenu;
void() ExitRandomMenu;
void() CheckMenuImpulses;

void() EnterRandomMenu = {
    RandomMode = cvar("savedgamecfg");
    cvar_set("savedgamecfg", ftos(RandomMode)); // Just in case it was never present in the config file
    UnbiasedMode = RandomMode & RANDOM_UNBIASED_MODE;
    HideInBackpacks = RandomMode & RANDOM_BACKPACK_MODE;
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
    if(!UnbiasedMode && !HideInBackpacks)
        centerprint (Client, "=== Quake Randomizer Mod ===\n\n", "Current Randomizer Mode is Biased\nBackpack Mode is Disabled\n\n", "[1] Set Randomizer to Unbiased\n[2] Enable Backpack Mode\n[3] List of randomized objects\n[4] Seed settings\n[5] About\n[6] Exit Menu");
    else if(UnbiasedMode && !HideInBackpacks)
        centerprint (Client, "=== Quake Randomizer Mod ===\n\n", "Current Randomizer Mode is Unbiased\nBackpack Mode is Disabled\n\n", "[1] Set Randomizer to Biased\n[2] Enable Backpack Mode\n[3] List of randomized objects\n[4] Seed settings\n[5] About\n[6] Exit Menu");
    else if(!UnbiasedMode && HideInBackpacks)
        centerprint (Client, "=== Quake Randomizer Mod ===\n\n", "Current Randomizer Mode is Biased\nBackpack Mode is Enabled\n\n", "[1] Set Randomizer to Unbiased\n[2] Disable Backpack Mode\n[3] List of randomized objects\n[4] Seed settings\n[5] About\n[6] Exit Menu");
    else if(UnbiasedMode && HideInBackpacks)
        centerprint (Client, "=== Quake Randomizer Mod ===\n\n", "Current Randomizer Mode is Biased\nBackpack Mode is Enabled\n\n", "[1] Set Randomizer to Biased\n[2] Disable Backpack Mode\n[3] List of randomized objects\n[4] Seed settings\n[5] About\n[6] Exit Menu");
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
    if(CurrentMenu == MAIN_MENU)
    {
        if(self.impulse == 1)
            UnbiasedMenu();
        if(self.impulse == 2)
            BackpacksMenu();
        if(self.impulse == 3)
            RandomizedListMenu();
        if(self.impulse == 4)
            SeedMenu();
        if(self.impulse == 5)
            AboutMenu();
        if(self.impulse == 6)
            ExitRandomMenu();
        return;
    }
    if(CurrentMenu == UNBIASED_MENU)
    {
        if(self.impulse == 1)
        {
            if(UnbiasedMode)
            {
                centerprint (Client, "=== WARNING ===\n\n", "Biased Mode ENABLED\n\n", "(This won't take effect until\n a level is loaded)\n\n[1] Return to Main Menu");
                RandomMode = RandomMode - (RandomMode & RANDOM_UNBIASED_MODE);
                UnbiasedMode = 0;
                CurrentMenu = FINAL_MENU;
            }
            else 
            {
                centerprint (Client, "=== WARNING ===\n\n", "Unbiased Mode ENABLED\n\n", "(This won't take effect until\n a level is loaded)\n\n[1] Return to Main Menu");
                RandomMode = RandomMode | RANDOM_UNBIASED_MODE;
                UnbiasedMode = 1;
                CurrentMenu = FINAL_MENU;
            }
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
                centerprint (Client, "=== WARNING ===\n\n", "Backpack Mode DISABLED\n\n", "(This won't take effect until\n a level is loaded)\n\n[1] Return to Main Menu");
                RandomMode = RandomMode - (RandomMode & RANDOM_BACKPACK_MODE);
                HideInBackpacks = 0;
                CurrentMenu = FINAL_MENU;
            }
            else 
            {
                centerprint (Client, "=== WARNING ===\n\n", "Backpack Mode ENABLED\n\n", "(This won't take effect until\n a level is loaded)\n\n[1] Return to Main Menu");
                RandomMode = RandomMode | RANDOM_BACKPACK_MODE;
                HideInBackpacks = 1;
                CurrentMenu = FINAL_MENU;
            }
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