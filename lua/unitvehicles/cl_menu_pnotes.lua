UV = UV or {}

-- ["VERSIONNUMBER"] = {
-- Date = "RELEASEDATE",
-- Text = [[

-- ]],
-- },

UV.PNotes = {
["v0.42.0"] = {
Date = "2026/01/16",
Text = [[
**Almost there!**
Unit Vehicles is getting closer and closer to its v1.0 release on *January 29th*!
Mark your calendars, it's almost time to **Race, Chase or Escape**!

**New Features**
- Added the *UVPD Rhino Truck*
- Added the *Heat Level Manager* to the *Pursuit Manager* UV Menu Tab
 |-- This replaces the *Manager: Units* settings.
- Added a Race Countdown to the NFS: ProStreet HUD
- Added a new, updated list appearance to the AI Racers, Pursuit Breaker, Roadblocks, Traffic & Units tools
 |-- AI Racers, Traffic and Units also have new base sorting to only list vehicles from a particular base

**Changes**
- UV Menu: All convars in the menu now control their correct server convars
 |-- This means that the "Apply Settings" buttons will be removed across the board
- Moved the "Creator: Pursuit Breaker" and "Creator: Roadblocks" settings to the UV Menu
 |-- Roadblocks: UV Menu > Settings > Pursuit Settings
 |-- Pursuit Breakers: UV Menu > Settings > Pursuit Breakers
- Renamed the "Manager: Units" tool to "Creator: Units"
- Removed all settings from all Creator tools
- Removed "Relentless" AI option and replaced it with a dynamic behaviour system
 |-- Patrol and Support Units are never relentless
 |-- Pursuit, Interceptor and Air Units have a random chance to become relentless
 |-- Special, Commander and Rhino Units are always relentless
- Improved AI Unit pursuit tactics
- Removed some default cop chatter and updated others
- Air Unit's wreck callout will now have priority over all others

**Fixes**
- Fixed that Repair Shops repaired less health than it should've when Infinite Durability is enabled
- Fixed that "Evade" and "Busted" meters could fill up at the same time on rare instances
]],
},

["v0.41.0"] = {
Date = "2026/01/05",
Text = [[
**New Features**
- Added the *UVPD Chevrolet Colorado ZR2 2017 Police Cruiser*
- Added a new *Update History* section in the UV Menu - accessed via the *Welcome Page*

**Changes**
- Special and Commander Units' Pursuit Tech now has x2 power (excluding Spike Strips)
- "Enable Headlights" AI Settings option now allows an "Automatic" setting, where AI enable their headlights in dark areas
- When exporting races, you can now choose if you want to export DV Waypoints or not
- Vehicles and hand-spawned entities will no longer be removed when loading a race with props
- Updated translations

**Fixes**
- Fixed that the "Glide" category within the AI Racer Manager's "Vehicle Override" was duplicated, and caused errors if too many Glide vehicles were installed
- Fixed that Keybinds never displayed their "Press any button" prompt
- Fixed that Commander Unit's health reset when "Optimize Respawn" was enabled, and the Commander Unit was moved
- Fixed that Settings were never transmitted to the server when running in a Multiplayer instance
]],
},

["v0.40.0"] = {
Date = "2025/12/31",
Text = [[
**The final stretch!**
We're now preparing Unit Vehicles for its v1.0 release. There's lots to do still, and we hope to keep receiving feedback until then.

**New Features**
- Added the *UVPD Chevrolet Corvette Grand Sport (C7) Police Cruiser*
- Added the ability to reset in freeroam and in pursuits
- AI Racers and Units will no longer rotate while mid-air
  |-- Only applies to Glide vehicles
- The UV Menu and all fonts will now scale properly on all resolutions
- Added the ability for the community to create custom HUDs
 |-- These are automatically added to the UV Menu Settings
- Added Polish translations
  
**UV Menu**
- Added new *AI Racer Manager*, *Traffic Manager* and *Credits* tabs
  |-- Moved all of the "Manager: AI Racers" and "Manager: Traffic" settings to these tabs
- Added new *Keybinds* tab inside the Settings instance
- Added a *Timer* variable in the UV Menu, applied to the *Totaled* and *Race Invite* menus
- Added a custom dropdown menu in the UV Menu, used by the *UVTrax Profile* and *HUD Types*
- Texts on all options will now scale and split properly
- Rewrote the entire *FAQ* section

**Changes**
- Pursuit Breakers will now always trigger a call response
- The *Vehicle Override* feature from the "Manager: AI Racers" tool (now present in the UV Menu) now supports infinite amount of racers
- The Air Unit will now create dust effects depending on what surface it hovers over
- Relentless AI Units will no longer know player hiding spots
- UV Menu: The *FAQ* tab now sends you to a separate menu instance with categorized information
- UV Menu: The *Addons* tab was moved to UV Settings
- UV Menu: The *Freeze Cam* option no longer appears in the UV Menu while in a Multiplayer session
- Updated various default Cop Chatter lines
- Updated localizations

**Fixes**
- Fixed that AI Racers sometimes steered weirdly after entering another lap
- Fixed that the Air Unit's spotlight wasn't always active
- Fixed that Units still respawned when the Backup timer was active
- Fixed that roadblocks sometimes spawned when a call response was triggered
- Fixed that the EMP Pursuit Tech did not have a localized string on the HUD
- Fixed that the Busted debrief did not always trigger if multiple racers were busted in a short time
- Fixed that the Race Options caused errors in Multiplayer
- Fixed that the Race Invite caused an error when clicking outside of its window, causing it to close prematurely
- Fixed that invalid Subtitles sent the Pursuit Tech notification upwards
- Fixed that clicking on a dropdown option outside the UV Menu, the menu would close if it was set to "Close on Unfocus"
- Fixed a lag spike when pursuit music plays for the first time
- Fixed that Pursuit Breakers sometimes did not wreck Units
]],
},

["v0.39.1"] = {
Date = "2025/12/17",
Text = [[
# New Features
- **UV Menu**: Added **Carbon** Menu SFX
- **Race Manager**: Added new race options:
> - Start a pursuit X seconds after a race begins
> - Stop the pursuit after the race finishes
> - Clear all AI racers and/or Units when the race finishes
> - Visually hide the checkpoint boxes when racing

- **Race Invites** now use the new menu system
- **Unit Totaled**: Slightly tweaked appearance

**Chatter**
- Added more lines for Cop6

And various other undocumented tweaks
]],
},

["v0.39.0"] = {
Date = "2025/12/11",
Text = [[
# New Features
**UV Menu**
Say hello to the newly introduced UV Menu, the full replacement for the Spawn Menu options and more. Accessed via the Context Menu or **unitvehicles_menu** command:

- **Welcome Page** - Includes some quick access buttons and variables, and a handy **What's New** section, where we will post update notes
- **Race Manager** - Moved the Race Manager tool race control variables here
- **Pursuit Manager** - Moved all Pursuit Manager buttons here
- **Addons** - The one place for both included and third-party UV addons. Moved **Circular Functions** variables here
- **FAQ** - Need some quick help? The Discord FAQ has been uploaded here!
- **Settings** - Want to tweak something? All Client and Server settings are present here

Additionally, both the **Unit Totaled** and **Unit Select** now use the same menu system.

Don't like the colours? Then change it! Change the colour of buttons, the background and more in the **User Interface** settings tab!

**Things to note**
- Many options are server only, meaning they will not be displayed to clients.
- The options present in the menu can still be accessed via their original methods (Spawn Menu > Options > Unit Vehicles) for roughly 3 update cycles of UV before they will be removed.
- The menu isn't perfect - it will be refined over time.

# Changes
**Tools**
- Race Manager - Renamed to **Creator: Races**

**UI**
- MW HUD: Fixed that the "Split Time" notification did not fade out properly
- Carbon HUD: Fixed that the notifications did not fade out properly

**AI**
- Fixed that the AI did not always respect Nitrous settings (Circular Functions)

**Pursuit**
- Fixed roadblocks not always spawning properly, and sometimes didn't spawn with any Units
- Fixed that regular Units sometimes appeared in Rhino-only roadblocks
- Air Support now gets removed when despawning AI Units

And various other undocumented tweaks
]],
},

}