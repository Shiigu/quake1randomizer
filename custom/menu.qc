float InRandomMenu; // 1 if in the menus, 0 otherwise. Used to take priority on impulses.
float CurrentMenu;  // Contains the current menu the player is
    float MAIN_MENU = 1;        // Main Menu
    float UNBIASED_MENU = 2;    // Menu to enable or disable Unbiased Mode
    float BACKPACKS_MENU = 3;   // Menu to enable or disable Backpacks Mode
    float ABOUT_MENU = 4;       // "About" Menu

entity InputCapturer; // Will take hold of the number keys until the player closes the menu or its think time expires
entity Client;     // Stores the client entity.
float CaptureTime; // Time (in seconds) the player has to make a selection, or the menu will be instantly closed

void() EnterRandomMenu;
void() MainMenu;
void() UnbiasedMenu;
void() BackpacksMenu;
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
    CaptureTime = 2;
    InputCapturer = spawn();
    InputCapturer.think = ExitRandomMenu;
    MainMenu();
};

void() MainMenu = {
    if(!UnbiasedMode && !HideInBackpacks)
        centerprint (Client, "=== Quake Randomizer Mod ===\n\nCurrent Randomizer Mode is Biased\nBackpacks Mode is Disabled\n\n[1] Set Randomizer to Unbiased\n[2] Enable Backpack Mode\n[3] About\n[4] Exit Menu");
    else if(UnbiasedMode && !HideInBackpacks)
        centerprint (Client, "=== Quake Randomizer Mod ===\n\nCurrent Randomizer Mode is Unbiased\nBackpacks Mode is Disabled\n\n[1] Set Randomizer to Biased\n[2] Enable Backpack Mode\n[3] About\n[4] Exit Menu");
    else if(!UnbiasedMode && HideInBackpacks)
        centerprint (Client, "=== Quake Randomizer Mod ===\n\nCurrent Randomizer Mode is Biased\nBackpacks Mode is Enabled\n\n[1] Set Randomizer to Unbiased\n[2] Disable Backpack Mode\n[3] About\n[4] Exit Menu");
    else if(UnbiasedMode && HideInBackpacks)
        centerprint (Client, "=== Quake Randomizer Mod ===\n\nCurrent Randomizer Mode is Biased\nBackpacks Mode is Enabled\n\n[1] Set Randomizer to Biased\n[2] Disable Backpack Mode\n[3] About\n[4] Exit Menu");
    CurrentMenu = MAIN_MENU;
    InputCapturer.nextthink = time + CaptureTime;
};

void() UnbiasedMenu = {
    if(UnbiasedMode)
        centerprint (Client, "=== Biased Mode ===\n\nWhen enabled, the game will randomize\n everything in a way it finds fair.\n\nDo you want to set the\nRandomizer to Biased?\n\n[1] Yes\n[2] No");
    else
        centerprint (Client, "=== Unbiased Mode ===\n\nWARNING\n\nWhen enabled, the game will randomize\neverything without regard on whether\nthe map becomes unbeatable!\n\nDo you really want to set\nthe Randomizer to Unbiased?\n\n[1] Yes\n[2] No");
    CurrentMenu = UNBIASED_MENU;
    InputCapturer.nextthink = time + CaptureTime;
};

void() BackpacksMenu = {
    if(HideInBackpacks)
        centerprint (Client, "=== Backpacks Mode ===\n\nWhen disabled, the game will show weapons\nand ammo crates as it does by default.\n\nDo you want to\ndisable Backpacks Mode?\n\n[1] Yes\n[2] No");
    else
        centerprint (Client, "=== Backpacks Mode ===\n\nWARNING\n\nWhen enabled, the game will hide weapons\nand ammo crates inside backpacks. You\nwon't know what you get until you\npick the backpack up!\n\nDo you really want to\nenable Backpacks Mode?\n\n[1] Yes\n[2] No");
    CurrentMenu = BACKPACKS_MENU;
    InputCapturer.nextthink = time + CaptureTime;
};

void() AboutMenu = {
    centerprint (Client, "=== About the Quake Randomizer Mod ===\n\nCreated by Shiigu\n\nSource Code:https://github.com/\nShiigu/quake1randomizer\n\n(Help is appreciated!)");
    CurrentMenu = ABOUT_MENU;
    InRandomMenu = 0;
    remove(InputCapturer);
};

void() CheckMenuImpulses = {
    if(CurrentMenu == MAIN_MENU)
    {
        if(self.impulse == 1)
            UnbiasedMenu();
        if(self.impulse == 2)
            BackpacksMenu();
        if(self.impulse == 3)
            AboutMenu();
        if(self.impulse == 4)
            ExitRandomMenu();
        return;
    }
    if(CurrentMenu == UNBIASED_MENU)
    {
        if(self.impulse == 1)
        {
            if(UnbiasedMode)
            {
                centerprint (Client, "=== WARNING ===\n\nBiased Mode ENABLED\n\n(This won't take effect until\n a level is loaded)");
                RandomMode = RandomMode - (RandomMode & RANDOM_UNBIASED_MODE);
                UnbiasedMode = 0;
            }
            else 
            {
                centerprint (Client, "=== WARNING ===\n\nUnbiased Mode ENABLED\n\n(This won't take effect until\n a level is loaded)");
                RandomMode = RandomMode | RANDOM_UNBIASED_MODE;
                UnbiasedMode = 1;
            }
            cvar_set("savedgamecfg", ftos(RandomMode));
            InRandomMenu = 0;
            remove(InputCapturer);
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
                centerprint (Client, "=== WARNING ===\n\nBackpacks Mode DISABLED\n\n(This won't take effect until\n a level is loaded)");
                RandomMode = RandomMode - (RandomMode & RANDOM_BACKPACK_MODE);
                HideInBackpacks = 0;
            }
            else 
            {
                centerprint (Client, "=== WARNING ===\n\nBackpacks Mode ENABLED\n\n(This won't take effect until\n a level is loaded)");
                RandomMode = RandomMode | RANDOM_BACKPACK_MODE;
                HideInBackpacks = 1;
            }
            cvar_set("savedgamecfg", ftos(RandomMode));
            InRandomMenu = 0;
            remove(InputCapturer);
        }
        if(self.impulse == 2)
            ExitRandomMenu();
        return;
    }
};

void() ExitRandomMenu = {
    centerprint (Client, string_null);
    InRandomMenu = 0;
    remove(InputCapturer);
};