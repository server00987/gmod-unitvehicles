UV = UV or {}
UV.FAQ = UV.FAQ or {}

function UVGetFAQText(key)
	local cvar = GetConVar("gmod_language")
	local lang = cvar and string.lower(cvar:GetString()) or "en"

	-- Try exact match (sv-se)
	if UV.FAQ[lang] and UV.FAQ[lang][key] then
		return UV.FAQ[lang][key]
	end

	-- Try base language fallback (sv)
	local base = string.match(lang, "^(%a+)")
	if base and UV.FAQ[base] and UV.FAQ[base][key] then
		return UV.FAQ[base][key]
	end

	-- English fallback
	if UV.FAQ.en and UV.FAQ.en[key] then
		return UV.FAQ.en[key]
	end

	return "Missing FAQ text: " .. key
end

-- English
UV.FAQ["en"] = {
-- Introduction
["Intro"] = [[
# -- What is this addon?

Unit Vehicles is a Sandbox-oriented addon that allows players, in both Multiplayer with others or Singleplayer with AI, to engage in high-speed pursuits as or against police (Units) and thrilling races on any map.

**Here are the currently supported vehicle bases:**
 |-- prop_vehicle_jeep (default vehicle base)
 |-- simfphys
 |-- Glide (required and highly recommended)
]],
["Requirements"] = [[
# -- Do I have to install other addon(s) for this?

Yes. *Decent Vehicle - Basic AI* and *Glide // Styled's Vehicle Base* is REQUIRED for Unit Vehicles to function properly.
 |-- Decent Vehicle provides waypoints for AIs to spawn and roam around in.
 |-- Glide provides the vehicles needed to use with the Default preset.
]],
["Github"] = [[
# -- Does this addon have a GitHub repository?

Yes. It is currently private at the moment until official release.
]],
["Roadmap"] = [[
# -- How can I keep up to date with the latest updates? Is there a road map?

You can follow us on our Trello page, or our Discord server, both of which you can find on our Workshop page.
]],
["ConVars"] = [[
# -- What console commands are there I can use?

 |-- uv_spawnvehicles - Spawns patrolling AI Units
 |-- uv_setheat [x] - Sets the Heat Level
 |-- uv_despawnvehicles - Despawns Patrolling AI Units
 |-- uv_resetallsettings - Resets all server settings to their default values
 |-- uv_startpursuit - Starts a countdown before beginning a pursuit
 |-- uv_stoppursuit - Stops a pursuit with AI Units assuming you've escaped
 |-- uv_wantedtable - Prints a list of wanted suspects to the console
 |-- uv_clearbounty - Sets the bounty value to 0
 |-- uv_setbounty [x] - Sets the bounty value
 |-- uv_spawn_as_unit - Allows you to join as the Unit
]],

-- Racing
["Racing.Joining"] = [[
# -- How do I join races?

If someone has prepared a race, and they send an invite, you'll receive an on-screen notification inviting you to it, assuming that you are in a vehicle and no pursuit is ongoing.
]],

["Racing.Resetting"] = [[
# -- I'm stuck! How do I reset?

 |-- Press [key:unitvehicle_keybind_resetposition] to reset your car
 |-- Wait 3 seconds
 |-- You're back at the last checkpoint you passed!
 
**Notes**
 |-- You cannot reset when being busted
 |-- You cannot reset while already moving
]],

["Racing.Starting"] = [[
# -- How do I start racing?

Begin a race by going to **Race Manager** in the UV Menu:
 |-- Click 'Load Track'
 |-- Select any race from the list
 |-- Invite other racers, or hit 'Start Race'
 |-- You can immediately start the race, or automatically spawn AI to join your race


*Notes*
 |-- There must be at least 1 Grid Slot to start the race!
 |-- You can invite friends/AI Racers by clicking 'Invite Racers' before clicking 'Start Race' as long as a race is loaded.
 |-- If there are no existing races, you'll have to make your own
 |-- Alternatively, find some on the Workshop!
]],

["Racing.Create"] = [[
# -- How do I create races?
Use the *Creator: Races* tool:


*-- Step 1: Create Checkpoints*
 |-- Press [+attack] in one corner to start placing a checkpoint.
 |-- Press [+attack] in another to finish placing it.
 |-- Tip: Hold [+use] to increase checkpoint height automatically.
 

*-- Step 2: Set the Checkpoints in order*
 |-- Press [+attack2] on the checkpoint.
 |-- Type in the **Checkpoint ID**
 |-- Make sure the ID is in sequentual order
 |-- Branching checkpoints use a matching ID
 |-- AI will always use the last placed checkpoint ID
 

*-- Step 3: Create Grid Slots*
 |-- Press [+reload] to place Grid Slots
 |-- The numbers on the slots represent starting order
 |-- Want more racers? Place more slots!
 

*-- Step 4: Export Race*
 |-- Done with the race? Open the Spawnmenu and hit 'Export Race'
 |-- Give it a name
 |-- It will now appear as a race you can import and race on!
]],
["Racing.Create.Speedlimit"] = [[
# -- The AI Racers are going too fast around the track!

When placing checkpoints, you'll have to define the speed in which the AI will take it.
If the AI is going too fast, you'll have to alter the speedlimit value found in the **Creator: Races** settings.
If you have a race already loaded, you can Right-Click to edit the checkpoint and apply the updated speedlimit.
Alternatively, you can edit the last number in the race data file.
]],

-- Pursuits
["Pursuit.Starting"] = [[
# -- How do I start a pursuit?

 |-- Go to *Pursuit Manager*
 |-- Click *Force-Start*
 |-- Alternatively, drive into or drive recklessly near a Unit
 |-- Away you go!
]],

["Pursuit.JoinAsUnit"] = [[
# -- Can I join the Pursuit as a Unit?

Yes you can! And it's simple:
 |-- Go to *Pursuit Manager* or *Welcome Page*
 |-- Click *Spawn as a Unit*
 |-- Pick the vehicle you want to drive
 |-- Away you go!
]],
["Pursuit.Respawn"] = [[
# -- I'm stuck or too far from the suspect(s)! How do I reset?

 |-- Press [key:unitvehicle_keybind_resetposition] to open the *Unit Select* menu
 |-- Pick the vehicle you want to reset as
 |-- Away you go!
 
**Notes**
 |-- If you reset once, you'll have to wait a moment before doing so again
]],
["Pursuit.CreateUnits"] = [[
# -- I want to create Units. What do I do?

Here's what you do:
 |-- 1. Pull out the *Creator: Units* tool
 |-- 2. Spawn any vehicle
 |-- 3. Press [+attack2] on the vehicle
 |-- 4. Give the Unit a unique name
 |-- 5. (Optional) Select the Heat Level the Unit appears in
 |-- 6. (Optional) Tweak other values as you see fit
 |-- 7. Click 'Create'
 
Now apply the Unit via the *Manager: Units* tool, and you'll either face the Unit you made, or be allowed to play as the Unit against the fleeing suspects.
]],
["Pursuit.Roadblocks"] = [[
# -- I want to create Roadblocks. What do I do?

You use the *Creator: Roadblocks* tool:
 |-- 1. Using the tool, create the props and pieces necessary for the roadblock
 |-- 2.  Using the *Weld* tool (or any alternative), weld all the pieces together
 |-- 3. Once welded, press [+attack2] on any piece of the roadblock
 |-- 4. Tweak the settings to your liking, then click 'Create Roadblock'
 
The roadblock will now appear randomly when a Pursuit is active.
]],
["Pursuit.Pursuitbreaker"] = [[
# -- I want to create Pursuit Breakers. What do I do?

You use the *Creator: Pursuit Breaker* tool:
 |-- 1. Create the props and pieces necessary for the Pursuit Breaker
 |-- 2.  Using the *Weld* tool (or any alternative), weld all the pieces together
 |-- 3. Once welded, press [+attack2] on any piece of the Pursuit Breaker
 |-- 4. Tweak the settings to your liking, then click 'Create Pursuit Breaker'
]],

["Other.CreateTraffic"] = [[
# -- How do I spawn traffic?

Here's what you do:
 |-- 1. Pull out the *Creator: Traffic* tool
 |-- 2. Spawn any vehicle
 |-- 3. Press [+attack2] on the vehicle
 |-- 4. Give the vehicle a unique name
 |-- 5. (Optional) Tweak the values as you see fit
 |-- 6. Click 'Create'
 
You can then tweak general settings in the *Traffic Manager* tab in the UV Menu.
]],
["Other.PursuitTech"] = [[
# -- What are Pursuit Tech?

Pursuit Tech are a series of weapons and support devices utilized by both Racers and Units.
You can apply up to 2 Pursuit Techs to your vehicle to either fight the opponents or defend yourself.

Here's how  to apply and use them:
 |-- 1. Pull out the *Pursuit Tech* tool
 |-- 2. Select the Pursuit Tech you want to use as a Racer or Unit
 |-- 3. Press [+attack] on your vehicle or Unit
 
You can now press [key:unitvehicle_pursuittech_keybindslot_1] and [key:unitvehicle_pursuittech_keybindslot_2] to activate your Pursuit Tech while driving!
]],
["Other.RenameAI"] = [[
# -- Can I rename AI Racers and Units?

Yes you can. And it's simple:
 |-- 1. Pull out the *Name Changer* tool
 |-- 2. Type out the name you want the AI to have
 |-- 3. Press [+attack] on the AI Racer or Unit
]],
["Other.DataFolder"] = [[
# -- Where is my UV data stored?

You can find your UV-related data stored in your game's *data/unitvehicles* directory:
]],
}

-- Swedish
UV.FAQ["sv-se"] = {
-- Introduction
["Intro"] = [[
# -- Vad är det här för tillägg?

Unit Vehicles är ett Sandbox-fokuserat tillägg som tillåter spelare, antingen flera spelare via nätet eller ensam med AI, att gå med i jakter i hög hastighet som eller emot polisen (Enheter) och spännande lopp på vilken karta som helst.

**Här är dem nuvarande stödjande fordonsbaserna:**
 |-- prop_vehicle_jeep (standard fordonsbas)
 |-- simfphys
 |-- Glide (krävs och starkt rekommenderad)
]],
["Requirements"] = [[
# -- Do I have to install other addon(s) for this?

Yes. *Decent Vehicle - Basic AI* and *Glide // Styled's Vehicle Base* is REQUIRED for Unit Vehicles to function properly.
 |-- Decent Vehicle provides waypoints for AIs to spawn and roam around in.
 |-- Glide provides the vehicles needed to use with the Default preset.
]],
["Github"] = [[
# -- Does this addon have a GitHub repository?

Yes. It is currently private at the moment until official release.
]],
["Roadmap"] = [[
# -- How can I keep up to date with the latest updates? Is there a road map?

You can follow us on our Trello page, or our Discord server, both of which you can find on our Workshop page.
]],
["ConVars"] = [[
# -- What console commands are there I can use?

 |-- uv_spawnvehicles - Spawns patrolling AI Units
 |-- uv_setheat [x] - Sets the Heat Level
 |-- uv_despawnvehicles - Despawns Patrolling AI Units
 |-- uv_resetallsettings - Resets all server settings to their default values
 |-- uv_startpursuit - Starts a countdown before beginning a pursuit
 |-- uv_stoppursuit - Stops a pursuit with AI Units assuming you've escaped
 |-- uv_wantedtable - Prints a list of wanted suspects to the console
 |-- uv_clearbounty - Sets the bounty value to 0
 |-- uv_setbounty [x] - Sets the bounty value
 |-- uv_spawn_as_unit - Allows you to join as the Unit
]],

-- Racing
["Racing.Joining"] = [[
# -- How do I join races?

If someone has prepared a race, and they send an invite, you'll receive an on-screen notification inviting you to it, assuming that you are in a vehicle and no pursuit is ongoing.
]],

["Racing.Resetting"] = [[
# -- I'm stuck! How do I reset?

 |-- Press [key:unitvehicle_keybind_resetposition] to reset your car
 |-- Wait 3 seconds
 |-- You're back at the last checkpoint you passed!
 
**Notes**
 |-- You cannot reset when being busted
 |-- You cannot reset while already moving
]],

["Racing.Starting"] = [[
# -- How do I start racing?

Begin a race by going to **Race Manager** in the UV Menu:
 |-- Click 'Load Track'
 |-- Select any race from the list
 |-- Invite other racers, or hit 'Start Race'
 |-- You can immediately start the race, or automatically spawn AI to join your race


*Notes*
 |-- There must be at least 1 Grid Slot to start the race!
 |-- You can invite friends/AI Racers by clicking 'Invite Racers' before clicking 'Start Race' as long as a race is loaded.
 |-- If there are no existing races, you'll have to make your own
 |-- Alternatively, find some on the Workshop!
]],

["Racing.Create"] = [[
# -- How do I create races?
Use the *Creator: Races* tool:


*-- Step 1: Create Checkpoints*
 |-- Press [+attack] in one corner to start placing a checkpoint.
 |-- Press [+attack] in another to finish placing it.
 |-- Tip: Hold [+use] to increase checkpoint height automatically.
 

*-- Step 2: Set the Checkpoints in order*
 |-- Press [+attack2] on the checkpoint.
 |-- Type in the **Checkpoint ID**
 |-- Make sure the ID is in sequentual order
 |-- Branching checkpoints use a matching ID
 |-- AI will always use the last placed checkpoint ID
 

*-- Step 3: Create Grid Slots*
 |-- Press [+reload] to place Grid Slots
 |-- The numbers on the slots represent starting order
 |-- Want more racers? Place more slots!
 

*-- Step 4: Export Race*
 |-- Done with the race? Open the Spawnmenu and hit 'Export Race'
 |-- Give it a name
 |-- It will now appear as a race you can import and race on!
]],
["Racing.Create.Speedlimit"] = [[
# -- The AI Racers are going too fast around the track!

When placing checkpoints, you'll have to define the speed in which the AI will take it.
If the AI is going too fast, you'll have to alter the speedlimit value found in the **Creator: Races** settings.
If you have a race already loaded, you can Right-Click to edit the checkpoint and apply the updated speedlimit.
Alternatively, you can edit the last number in the race data file.
]],

-- Pursuits
["Pursuit.Starting"] = [[
# -- How do I start a pursuit?

 |-- Go to *Pursuit Manager*
 |-- Click *Force-Start*
 |-- Alternatively, drive into or drive recklessly near a Unit
 |-- Away you go!
]],

["Pursuit.JoinAsUnit"] = [[
# -- Can I join the Pursuit as a Unit?

Yes you can! And it's simple:
 |-- Go to *Pursuit Manager* or *Welcome Page*
 |-- Click *Spawn as a Unit*
 |-- Pick the vehicle you want to drive
 |-- Away you go!
]],
["Pursuit.Respawn"] = [[
# -- I'm stuck or too far from the suspect(s)! How do I reset?

 |-- Press [key:unitvehicle_keybind_resetposition] to open the *Unit Select* menu
 |-- Pick the vehicle you want to reset as
 |-- Away you go!
 
**Notes**
 |-- If you reset once, you'll have to wait a moment before doing so again
]],
["Pursuit.CreateUnits"] = [[
# -- I want to create Units. What do I do?

Here's what you do:
 |-- 1. Pull out the *Creator: Units* tool
 |-- 2. Spawn any vehicle
 |-- 3. Press [+attack2] on the vehicle
 |-- 4. Give the Unit a unique name
 |-- 5. (Optional) Select the Heat Level the Unit appears in
 |-- 6. (Optional) Tweak other values as you see fit
 |-- 7. Click 'Create'
 
Now apply the Unit via the *Manager: Units* tool, and you'll either face the Unit you made, or be allowed to play as the Unit against the fleeing suspects.
]],
["Pursuit.Roadblocks"] = [[
# -- I want to create Roadblocks. What do I do?

You use the *Creator: Roadblocks* tool:
 |-- 1. Using the tool, create the props and pieces necessary for the roadblock
 |-- 2.  Using the *Weld* tool (or any alternative), weld all the pieces together
 |-- 3. Once welded, press [+attack2] on any piece of the roadblock
 |-- 4. Tweak the settings to your liking, then click 'Create Roadblock'
 
The roadblock will now appear randomly when a Pursuit is active.
]],
["Pursuit.Pursuitbreaker"] = [[
# -- I want to create Pursuit Breakers. What do I do?

You use the *Creator: Pursuit Breaker* tool:
 |-- 1. Create the props and pieces necessary for the Pursuit Breaker
 |-- 2.  Using the *Weld* tool (or any alternative), weld all the pieces together
 |-- 3. Once welded, press [+attack2] on any piece of the Pursuit Breaker
 |-- 4. Tweak the settings to your liking, then click 'Create Pursuit Breaker'
]],

["Other.CreateTraffic"] = [[
# -- How do I spawn traffic?

Here's what you do:
 |-- 1. Pull out the *Creator: Traffic* tool
 |-- 2. Spawn any vehicle
 |-- 3. Press [+attack2] on the vehicle
 |-- 4. Give the vehicle a unique name
 |-- 5. (Optional) Tweak the values as you see fit
 |-- 6. Click 'Create'
 
You can then tweak general settings in the *Traffic Manager* tab in the UV Menu.
]],
["Other.PursuitTech"] = [[
# -- What are Pursuit Tech?

Pursuit Tech are a series of weapons and support devices utilized by both Racers and Units.
You can apply up to 2 Pursuit Techs to your vehicle to either fight the opponents or defend yourself.

Here's how  to apply and use them:
 |-- 1. Pull out the *Pursuit Tech* tool
 |-- 2. Select the Pursuit Tech you want to use as a Racer or Unit
 |-- 3. Press [+attack] on your vehicle or Unit
 
You can now press [key:unitvehicle_pursuittech_keybindslot_1] and [key:unitvehicle_pursuittech_keybindslot_2] to activate your Pursuit Tech while driving!
]],
["Other.RenameAI"] = [[
# -- Can I rename AI Racers and Units?

Yes you can. And it's simple:
 |-- 1. Pull out the *Name Changer* tool
 |-- 2. Type out the name you want the AI to have
 |-- 3. Press [+attack] on the AI Racer or Unit
]],
["Other.DataFolder"] = [[
# -- Where is my UV data stored?

You can find your UV-related data stored in your game's *data/unitvehicles* directory:
]],
}
