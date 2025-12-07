if CLIENT then
	UV = UV or {}
	UV.SettingsTable = UV.SettingsTable or {}

	local blink = math.abs(math.sin(RealTime() * 10))

	-- UVTrax
	local uvtraxfiles, uvtraxfolders = file.Find("sound/uvracemusic/*", "GAME")
	local uvtraxcontent = {}

	if uvtraxfolders then
		for _, v in ipairs(uvtraxfolders) do
			uvtraxcontent[#uvtraxcontent + 1] = { v, v }
		end
	end

	-- Pursuit Themes
	local pursuitfiles, pursuitfolders = file.Find("sound/uvpursuitmusic/*", "GAME")
	local pursuitcontent = {}

	if pursuitfolders then
		for _, v in ipairs(pursuitfolders) do
			pursuitcontent[#pursuitcontent + 1] = { v, v }
		end
	end

	-- Patch Notes -- Change this whenever a new update is releasing!
	UV.PNotes = [[
# New Features
**Tools**
- Added the **Manager: AI Racer** tool, allowing you to create free roaming AI racers, or tweak a new Vehicle Override feature

**AI**
- Added the option for **Traction Control** for AI Racers and Units, where they reduce their throttle when driving Glide or Simfphys cars when losing control

**Localization**
- Added WIP Thai localization

# Changes
**Tools**
- Race Manager - Added a new "Race Options" menu when you try to begin a race, now having the option to immediately start it as-is, spawn X amount of AI racers and invite them, or fill the entire grid with AI and then invite them
- Race Manager - Added a new "Save props" prompt when exporting new races
- Manager: Traffic - Applied the nice settings from Manager: Units.

**UI**
- Capped the amount of racers on the racer list on multiple UI Styles
- Tweaked a few UI Styles to be more 1:1
- Fixed that the Underground 2 race results caused an error when trying to close it with the jump button
- Added the vehicle names used by racers to some UI Style race results

**Other**
- Adjusted localization for all tools
- Fixed that HL2 Jeep vehicles caused errors at certain times

And various other undocumented tweaks
]]

		-- FAQ - Update if need be.
	UV.FAQ = {
[1] = [[
# What is this addon all about?
Unit Vehicles is a Sandbox-oriented addon that allows players, in both Multiplayer with others or Singleplayer with AI, to engage in high-speed pursuits as or against police (Units) and thrilling races on any map.

**Here are the currently supported vehicle bases:**
- prop_vehicle_jeep (default vehicle base)
- simfphys
- Glide
]],
[2] = [[
# Do I have to install other addon(s) for this?
Yes. Decent Vehicle - Basic AI and Glide // Styled's Vehicle Base is REQUIRED for Unit Vehicles to function properly.
- Decent Vehicle provides waypoints for AIs to spawn and roam around in.
- Glide provides the vehicles needed to use with the Default preset.
]],
[3] = [[
# Does this addon have a GitHub repository?
Yes. It is currently private at the moment until official release.
]],
[4] = [[
# How do I start a pursuit?
Start a pursuit by going to **Pursuit Manager**, then clicking **Force-Start Pursuit**. 
Alternatively, find a patrolling Unit and get them to chase you; just don't pull over!
]],
[5] = [[
# How do I start a race?
Using the **Race Manager** tool:
- Click 'Import Race'
- Select any race from the list
- Invite other racers, or hit 'Start Race'
- You can immediately start the race, or automatically spawn AI to join your race

**Notes**
- There must be at least 1 Grid Slot to start the race!
- You can invite friends/AI Racers by clicking 'Invite Racers' before clicking 'Start Race' as long as the race is imported.
- If there are no existing races, you'll have to make your own (or look for any addon on the workshop that contains UV Race data for that particular map).
]],
[6] = [[
# How do I spawn or modify Units?
Use the **Manager: Units** tool:

**Step 1: Save a Unit**
Right-click a vehicle and enter the details. It should appear on the database list depending on what vehicle base you have chosen. Do this for other vehicles you would like to chase you.

**Step 2: Assign a Unit**
Choose a Heat Level, then select the Unit you want for this vehicle to appear as. Click on the vehicle to assign/select it.
For all Heat Levels from Min to Max, there must be at least one assigned Unit!

**Step 3: Adjust other settings**
The Manager: Units tool allows for many variables to be adjusted. Tweak the settings as you see fit.

**Step 4: Save Changes**
Click 'Save Changes' button at the very top. Now be prepared to face new enemies!
Save them as presets so you don't have to worry about doing it all again. You can even export the settings and share it to the community!
]],
[6] = [[
# I want to be a cop. Can I join the Units?
You can! Assuming there are already assigned Units, head over to **Pursuit Manager** and select **Spawn as a Unit**!
]],
[7] = [[
# How do I get traffic to spawn?
Use the **Manager: Traffic** tool:

Right-click a vehicle and enter the details. It should appear on the database list depending on what vehicle base you have chosen.
]],
[8] = [[
# How do I set up roadblocks?
Use the **Creator: Roadblocks** Tool:

**Step 1: Creation**
Using the tool, create the props and pieces necessary for the roadblock.

**Step 2: Welding it (very important)**
Switch to the **Weld** tool and ensure that all the pieces are connected to one another.

**Step 3: Saving**
Once the pieces are welded, you can right-click on any piece to save the roadblock.
]],
[9] = [[
# How do I create races?
Use the **Race Manager** tool:

**Step 1: Create Checkpoints**
Left-click on one corner to start placing the checkpoint, left click again to finish (hold E to increase the height of the checkpoint).
Leave some space between the checkpoints to ensure easier detection when racing.

**Step 2: Set the Checkpoints in order**
Right-click an existing checkpoint to set a new ID, beginning with 1. Must be in sequential order; use the same ID for branching checkpoints.
For branching checkpoints, the AI will ALWAYS take the MOST RECENT checkpoint created.

**Step 3: Create Grid Slots**
Press your Reload key to place grid slots at your crosshair. The numbers represent the starting order.
If you want more racers to join in, place more grid slots!

**Step 4: Export Race**
Press the 'Export Race' button and give it a name. Now you can import the race!
]],
[10] = [[
# AI Racers don't slow down at corners! How can I fix that?
You can set the speed limit for each checkpoint BEFORE creating a new one.
You can alternatively edit the last number in the line for each checkpoint within the .txt file.
]],
[11] = [[
# How do I set up Pursuit Breakers?
Using the **Creator: Pursuit Breaker** tool:

**Step 1: Build a simple structure**
Build a structure, be it a scaffolding or a gas station. Get creative! Don't use too many props or else the game might lag!

**Step 2: Weld the structure**
Weld the structure. For easier welding process, try using addons such as **Smart Weld** and **OptiWeld**.
TIP: After welding the structure, unfreeze the pillars so your vehicle doesn't take damage when ramming through!

**Step 3: Save the structure**
Right-click the structure and enter the details.
TIP: Save the structure as a dupe so you don't have to do Step 1 and 2 when reusing the same structure!
]],
[12] = [[
# What are Pursuit Techs? Are they like power-ups?
Pursuit Tech are a series of weapons and support devices utilised by both Racers and Units. Up to 2 Pursuit Techs can be equipped to a single vehicle at any point.

**Shared Pursuit Tech**
EMP, ESF, Repair Kit & Spike Strips

**Racer Pursuit Tech**
Power Play, Juggernaut, Jammer, Shockwave & Stun Mine

**Unit Pursuit Tech**
Killswitch, Shock Ram & GPS Dart

You can assign Pursuit Tech with the **Pursuit Tech** tool, and learn more about them.
]],
[13] = [[
# Can I change the name of the Racers or Units?
Use the **Name Changer** tool to change the name of Racers and Units!
]],
[14] = [[
# What console commands are there I can use?
- uv_spawnvehicles - Spawns patrolling AI Units
- uv_setheat [x] - Sets the Heat Level
- uv_despawnvehicles - Despawns Patrolling AI Units
- uv_resetallsettings - Resets all server settings to their default values
- uv_startpursuit - Starts a countdown before beginning a pursuit
- uv_stoppursuit - Stops a pursuit with AI Units assuming you've escaped
- uv_wantedtable - Prints a list of wanted suspects to the console
- uv_clearbounty - Sets the bounty value to 0
- uv_setbounty [x] - Sets the bounty value
- uv_spawn_as_unit - Allows you to join as the Unit
]],
[15] = [[
# Where can I find and edit UV-related data?
Find and edit UV-related under in your game's *data* folder, then in *unitvehicles*.
]],
[16] = [[
# My game is lagging a lot whenever a new Unit spawns. Is this addon resource-intensive?
Units using simfphys tends to be more resource-intensive compared to other vehicle bases. Either lower the count of 'Maximum Units' or use other vehicle bases.
]],
[17] = [[
# How can I keep up to date with the latest updates? Is there a road map?
You can follow us on our Trello page, or our Discord server, both of which you can find on our Workshop page.
]],
[18] = [[
# Source engine limits the true potential of UV, most noticeably with limited map size. Will it expand into other games as an addon anytime soon?
There are plans to expand UV into s&box, making full use of Source 2 engine, but only time will tell :3
]],
[19] = [[
# How can I export UV files/presets as addons?

**Note** - This is slightly dumbed down and does not have a direct download for the preset. Visit our Discord server to find out more!

With the recent update for Unit Vehicles, we have introduced a import/export system which will allow users to upload their Unit presets as Workshop addons, as well as any other UV related data (such as races, roadblocks, racer names, etc.).

You can now find a new button inside of Unit Manager and Pursuit Tech STool panel right under the preset dropdown menu, Export Settings. This will export your currently loaded preset into a file which can later be used inside of our addon template for "UV data packs", using which you can upload that preset as well as any other UV files of your choosing onto the Workshop. This allows you to easily distribute & share your cool configs :)

**How does it work?**
After exporting a preset, the path of it will be located inside garrysmod/data/unitvehicles/preset_export/. Inside of that folder you will be able to find another folder which corresponds to the tool from which you exported the preset (e.g. exporting a Unit Manager preset will save it inside a "uvunitmanager" folder). We will take the contents of preset_export and use it for our UV data pack

Essentially, what you're looking for is a file structure like this: **data_static/uv_import/presetnamehere**
Inside this folder, you'll have the following file structures:
**uvdata** - Place any UV-related folders here, such as **glide**, **simfphys** or **races**. 
**uvdvwaypoints** - You can dump any DV Waypoint .txt files in here.

Now that you've included all the relevant files you wish to include with your addon, it's time to add your exported STool presets. You'd want to create a new folder inside of uvdata named preset_import. Once you've done this, simply copy the folders from garrysmod/data/unitvehicles/preset_export/ inside of the newly created folder.

That's all! You can now upload your data pack to Workshop and share it without having users go through the hassle of manually placing your files!

IMPORTANT
You must not include dots while naming the 'presetnamehere' folder, otherwise the presets will fail to load!

For example:
"my preset 1.0" - ❌ This will not work
"my preset" - ✅ Will work 
]],
}
	
	UVMenu.Settings = function()
		UVMenu.CurrentMenu = UVMenu:Open({
			Name = language.GetPhrase("uv.settings.unitvehicles") .. " | " .. language.GetPhrase("uv.settings.tab.settings"),
			Width = ScrW() * 0.8,
			Height = ScrH() * 0.7,
			Description = true,
			UnfocusClose = true,
			Tabs = {
				{ TabName = "#uv.settings.uistyle.title", Icon = "unitvehicles/icons_settings/display.png",

					{ type = "label", text = "#uv.settings.general" },
					{ type = "combo", text = "#uv.settings.uistyle.main", desc = "uv.settings.uistyle.main.desc", convar = "unitvehicle_hudtype_main", content = {
							{ "Crash Time - Undercover", "ctu"} ,
							{ "NFS Most Wanted", "mostwanted"} ,
							{ "NFS Carbon", "carbon"} ,
							{ "NFS Underground", "underground"} ,
							{ "NFS Underground 2", "underground2"} ,
							{ "NFS Undercover", "undercover"} ,
							{ "NFS ProStreet", "prostreet"} ,
							{ "NFS World", "world"} ,
							{ "#uv.uistyle.original", "original"} ,
							{ "#uv.uistyle.none", "" }
						},
					},
					{ type = "combo", text = "#uv.settings.uistyle.backup", desc = "uv.settings.uistyle.backup.desc", convar = "unitvehicle_hudtype_backup", content = {
								{ "NFS Most Wanted", "mostwanted" },
								{ "NFS Carbon", "carbon" },
								{ "NFS Undercover", "undercover" },
								{ "NFS World", "world" },
								{ "#uv.uistyle.original", "original" }
						},
					},
					{ type = "bool", text = "#uv.settings.ui.racertags", desc = "uv.settings.ui.racertags.desc", convar = "unitvehicle_racertags" },
					{ type = "bool", text = "#uv.settings.ui.preracepopup", desc = "uv.settings.ui.preracepopup.desc", convar = "unitvehicle_preraceinfo" },
					{ type = "bool", text = "#uv.settings.ui.subtitles", desc = "uv.settings.ui.subtitles.desc", convar = "unitvehicle_subtitles" },
					{ type = "bool", text = "#uv.settings.ui.vehnametakedown", desc = "uv.settings.ui.vehnametakedown.desc", convar = "unitvehicle_vehiclenametakedown" },
					{ type = "combo", text = "#uv.settings.ui.unitstype", desc = "uv.settings.ui.unitstype.desc", convar = "unitvehicle_unitstype", content = {
							{ "#uv.settings.ui.unitstype.meter", 0 },
							{ "#uv.settings.ui.unitstype.feet", 1 },
							{ "#uv.settings.ui.unitstype.yards", 2 },
						},
					},
				},
				{ TabName = "#uv.settings.audio.title", Icon = "unitvehicles/icons_settings/audio.png",

					{ type = "label", text = "#uv.settings.general" },
					{ type = "slider", text = "#uv.settings.audio.volume", desc = "uv.settings.audio.volume.desc", convar = "unitvehicle_pursuitthemevolume", min = 0, max = 2, decimals = 1 },
					{ type = "slider", text = "#uv.settings.audio.copchatter", desc = "uv.settings.audio.copchatter.desc", convar = "unitvehicle_chattervolume", min = 0, max = 5, decimals = 1 },
					{ type = "bool", text = "#uv.settings.audio.mutecp", desc = "uv.settings.audio.mutecp.desc", convar = "unitvehicle_mutecheckpointsfx" },

					{ type = "label", text = "#uv.settings.audio.uvtrax" },
					{ type = "bool", text = "#uv.settings.audio.uvtrax.enable", desc = "uv.settings.audio.uvtrax.desc", convar = "unitvehicle_racingmusic" },
					{ type = "combo", text = "#uv.settings.audio.uvtrax.profile", desc = "uv.settings.audio.uvtrax.profile.desc", convar = "unitvehicle_racetheme", content = uvtraxcontent, requireparentconvar = "unitvehicle_racingmusic" },
					{ type = "bool", text = "#uv.settings.audio.uvtrax.freeroam", desc = "uv.settings.audio.uvtrax.freeroam.desc", convar = "unitvehicle_uvtraxinfreeroam", requireparentconvar = "unitvehicle_racingmusic" },
					{ type = "bool", text = "#uv.settings.audio.uvtrax.pursuits", desc = "uv.settings.audio.uvtrax.pursuits.desc", convar = "unitvehicle_racingmusicoutsideraces", requireparentconvar = "unitvehicle_racingmusic" },

					{ type = "label", text = "#uv.settings.audio.pursuit" },
					{ type = "bool", text = "#uv.settings.audio.pursuit.enable", desc = "uv.settings.audio.pursuit.desc", convar = "unitvehicle_playmusic" },
					{ type = "combo", text = "#uv.settings.audio.pursuittheme", desc = "uv.settings.audio.pursuittheme.desc", convar = "unitvehicle_pursuittheme", content = pursuitcontent, requireparentconvar = "unitvehicle_playmusic" },
					{ type = "bool", text = "#uv.settings.audio.pursuitpriority", desc = "uv.settings.audio.pursuitpriority.desc", convar = "unitvehicle_racingmusicpriority", requireparentconvar = "unitvehicle_playmusic" },
					{ type = "bool", text = "#uv.settings.audio.pursuittheme.random", desc = "uv.settings.audio.pursuittheme.random.desc", convar = "unitvehicle_pursuitthemeplayrandomheat" },
					{ type = "combo", text = "#uv.settings.audio.pursuittheme.random.type", desc = "uv.settings.audio.pursuittheme.random.type.desc", convar = "unitvehicle_pursuitthemeplayrandomheattype", requireparentconvar = "unitvehicle_pursuitthemeplayrandomheat", content = {
							{ "#uv.settings.audio.pursuittheme.random.type.sequential", "sequential" },
							{ "#uv.settings.audio.pursuittheme.random.minutes", "everyminutes" },
						},
					},
					{ type = "slider", text = "#uv.settings.audio.pursuittheme.random.minutes", desc = "uv.settings.audio.pursuittheme.random.minutes.desc", convar = "unitvehicle_chattervolume", min = 1, max = 10, decimals = 0, requireparentconvar = "unitvehicle_pursuitthemeplayrandomheat" },
				},
				-- { TabName = "#uv.settings.keybinds", Icon = "unitvehicles/icons_settings/controls.png", -- Can't get it to work - oh well.

					-- { type = "label", text = "#uv.settings.keybinds.pt" },
					-- { type = "keybind", text = "#uv.settings.ptech.slot1", desc = "uv.settings.keybind.skipsong.desc", convar = "UVPTKeybindSlot1", slot = 1 },
					-- { type = "keybind", text = "#uv.settings.ptech.slot2", desc = "uv.settings.keybind.skipsong.desc", convar = "UVPTKeybindSlot2", slot = 2 },
					
					-- { type = "label", text = "#uv.settings.keybinds.races" },
					-- { type = "keybind", text = "#uv.settings.keybind.skipsong", desc = "uv.settings.keybind.skipsong.desc", convar = "unitvehicle_keybind_skipsong", slot = 3 },
					-- { type = "keybind", text = "#uv.settings.keybind.resetposition", desc = "uv.settings.keybind.resetposition.desc", convar = "UVKeybindResetPosition", slot = 4 },
					-- { type = "keybind", text = "#uv.settings.keybind.showresults", desc = "uv.settings.keybind.showresults.desc", convar = "UVKeybindShowRaceResults", slot = 5 },
				-- },
				{ TabName = "#uv.settings.pursuit", Icon = "unitvehicles/icons/(9)T_UI_PlayerCop_Large_Icon.png", sv = true,
					{ type = "label", text = "#uv.settings.heatlevels", sv = true },
					{ type = "bool", text = "#uv.settings.heatlevels.enable", desc = "uv.settings.heatlevels.enable.desc", convar = "unitvehicle_heatlevels", sv = true },
					{ type = "bool", text = "#uv.settings.heatlevels.aiunits", desc = "uv.settings.heatlevels.aiunits.desc", convar = "unitvehicle_spawnmainunits", sv = true },
					
					{ type = "label", text = "#uv.settings.general", sv = true },
					{ type = "bool", text = "#uv.settings.pursuit.randomplayerunits", desc = "uv.settings.pursuit.randomplayerunits.desc", convar = "unitvehicle_randomplayerunits", sv = true },
					{ type = "bool", text = "#uv.settings.pursuit.autohealth", desc = "uv.settings.pursuit.autohealth.desc", convar = "unitvehicle_autohealth", sv = true },
					{ type = "bool", text = "#uv.settings.pursuit.wheelsdetaching", desc = "uv.settings.pursuit.wheelsdetaching.desc", convar = "unitvehicle_wheelsdetaching", sv = true },
					{ type = "bool", text = "#uv.settings.pursuit.spottedfreezecam", desc = "uv.settings.pursuit.spottedfreezecam.desc", convar = "unitvehicle_spottedfreezecam", sv = true },
					{ type = "slider", text = "#uv.settings.pursuit.repaircooldown", desc = "uv.settings.pursuit.repaircooldown.desc", convar = "unitvehicle_repaircooldown", min = 5, max = 300, decimals = 0, sv = true },
					{ type = "slider", text = "#uv.settings.pursuit.repairrange", desc = "uv.settings.pursuit.repairrange.desc", convar = "unitvehicle_repairrange", min = 10, max = 1000, decimals = 0, sv = true },
					{ type = "bool", text = "#uv.settings.pursuit.noevade", desc = "uv.settings.pursuit.noevade.desc", convar = "unitvehicle_neverevade", sv = true },
					{ type = "slider", text = "#uv.settings.pursuit.bustedtime", desc = "uv.settings.pursuit.bustedtime.desc", convar = "unitvehicle_bustedtimer", min = 0, max = 10, decimals = 1, sv = true },
					{ type = "slider", text = "#uv.settings.pursuit.respawntime", desc = "uv.settings.pursuit.respawntime.desc", convar = "unitvehicle_spawncooldown", min = 0, max = 120, decimals = 0, sv = true },
					{ type = "slider", text = "#uv.settings.pursuit.spikeduration", desc = "uv.settings.pursuit.spikeduration.desc", convar = "unitvehicle_spikestripduration", min = 0, max = 120, decimals = 0, sv = true },
				},
				{ TabName = "#uv.settings.ptech", Icon = "unitvehicles/icons_carbon/wingman_target.png", sv = true,
					{ type = "label", text = "#uv.settings.general", sv = true },
					{ type = "bool", text = "#uv.settings.ptech.racer", desc = "uv.settings.ptech.racer.desc", convar = "unitvehicle_racerpursuittech", sv = true },
					{ type = "bool", text = "#uv.settings.ptech.friendlyfire", desc = "uv.settings.ptech.friendlyfire.desc", convar = "unitvehicle_racerfriendlyfire", sv = true },
					{ type = "bool", text = "#uv.settings.ptech.roadblockfriendlyfire", desc = "uv.settings.ptech.roadblockfriendlyfire.desc", convar = "unitvehicle_spikestriproadblockfriendlyfire", sv = true },
				},
				{ TabName = "#uv.settings.tab.ai", Icon = "unitvehicles/icons/milestone_pursuit.png", sv = true,
					{ type = "label", text = "#uv.settings.ailogic", sv = true },
					{ type = "bool", text = "#uv.settings.ailogic.optimizerespawn", desc = "uv.settings.ailogic.optimizerespawn.desc", convar = "unitvehicle_optimizerespawn", sv = true },
					{ type = "bool", text = "#uv.settings.ailogic.relentless", desc = "uv.settings.ailogic.relentless.desc", convar = "unitvehicle_relentless", sv = true },
					{ type = "bool", text = "#uv.settings.ailogic.wrecking", desc = "uv.settings.ailogic.wrecking.desc", convar = "unitvehicle_canwreck", sv = true },
					{ type = "slider", text = "#uv.settings.ailogic.detectionrange", desc = "uv.settings.ailogic.detectionrange.desc", convar = "unitvehicle_detectionrange", min = 1, max = 100, decimals = 0, sv = true },
					{ type = "bool", text = "#uv.settings.ailogic.headlights", desc = "uv.settings.ailogic.headlights.desc", convar = "unitvehicle_enableheadlights", sv = true },
					{ type = "bool", text = "#uv.settings.ailogic.usenitrousracer", desc = "uv.settings.ailogic.usenitrousracer.desc", convar = "unitvehicle_usenitrousracer", sv = true },
					{ type = "bool", text = "#uv.settings.ailogic.usenitrousunit", desc = "uv.settings.ailogic.usenitrousunit.desc", convar = "unitvehicle_usenitrousunit", sv = true },
					{ type = "bool", text = "#uv.settings.ailogic.autohealthracer", desc = "uv.settings.ailogic.autohealthracer.desc", convar = "unitvehicle_autohealthracer", sv = true },
					{ type = "bool", text = "#uv.settings.ailogic.customizeracer", desc = "uv.settings.ailogic.customizeracer.desc", convar = "unitvehicle_customizeracer", sv = true },
					{ type = "bool", text = "#uv.settings.ailogic.tractioncontrol", desc = "uv.settings.ailogic.tractioncontrol.desc", convar = "unitvehicle_tractioncontrol", sv = true },
					
					{ type = "label", text = "#uv.settings.ainav", sv = true },
					{ type = "bool", text = "#uv.settings.ainav.pathfind", desc = "uv.settings.ainav.pathfind.desc", convar = "unitvehicle_pathfinding", sv = true },
					{ type = "bool", text = "#uv.settings.ainav.dvpriority", desc = "uv.settings.ainav.dvpriority.desc", convar = "unitvehicle_dvwaypointspriority", sv = true },
					
					{ type = "label", text = "#uv.settings.chatter", sv = true },
					{ type = "bool", text = "#uv.settings.chatter.enable", desc = "uv.settings.chatter.enable.desc", convar = "unitvehicle_chatter", sv = true },
					{ type = "bool", text = "#uv.settings.chatter.text", desc = "uv.settings.chatter.text.desc", convar = "unitvehicle_chattertext", sv = true },
					
					{ type = "label", text = "#uv.settings.response", sv = true },
					{ type = "bool", text = "#uv.settings.response.enable", desc = "uv.settings.response.enable.desc", convar = "unitvehicle_callresponse", sv = true },
					{ type = "slider", text = "#uv.settings.response.speedlimit", desc = "uv.settings.response.speedlimit.desc", convar = "unitvehicle_speedlimit", min = 0, max = 100, decimals = 0, sv = true },
				},
				
				-- { TabName = "#uv.back", Icon = "unitvehicles/icons_settings/options.png", func = function()
				{ TabName = "#uv.back", func = function()
						UVMenu.OpenMenu(UVMenu.Main)
					end,
					{ type = "label", text = "#uv.settings.addon.builtin" },
				},
			}
		})
	end
end