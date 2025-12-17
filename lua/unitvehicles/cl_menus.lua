UV = UV or {}
UVMenu = UVMenu or {}
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

-- Race SFX
local racesfxfiles, racesfxfolders = file.Find("sound/uvracesfx/*", "GAME")
local racesfxcontent = {}

if racesfxfolders then
	for _, v in ipairs(racesfxfolders) do
		racesfxcontent[#racesfxcontent + 1] = { v, v }
	end
end

-- Patch Notes & Current Version -- Change this whenever a new update is releasing!
UV.CurVersion = "v0.39.1" --MAJOR.MINOR.PATCH
UV.PNotes = [[
**[ Patch 1 v0.39.1 - December 17th 2025 ]**
# New Features
- **UV Menu**: Added **Carbon** Menu SFX
- **Race Manager**: Added new race options:
  |-- Start a pursuit X seconds after a race begins
  |-- Stop the pursuit after the race finishes
  |-- Clear all AI racers and/or Units when the race finishes
  |-- Visually hide the checkpoint boxes when racing

- **Race Invites** now use the new menu system
- **Unit Totaled**: Slightly tweaked appearance

**Chatter**
- Added more lines for Cop6

And various other undocumented tweaks

**[ Main Update v0.39.0 - December 12th 2025 ]**
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
]]

-- Sounds Table
UVMenu.Sounds = {
    ["MW"] = {
        menuopen = "uvui/mw/fe_common_mb [8].wav",
        menuclose = "uvui/mw/fe_common_mb [9].wav",
        hover = "uvui/mw/fe_common_mb [1].wav",
        hovertab = "uvui/mw/fe_common_mb [2].wav",
        click = "uvui/mw/fe_common_mb [8].wav",
        clickopen = "uvui/mw/fe_common_mb [3].wav",
        clickback = "uvui/mw/fe_common_mb [4].wav",
        confirm = "uvui/mw/fe_common_mb [5].wav"
    },
    ["Carbon"] = {
        menuopen = "uvui/carbon/fe_mb [1].wav",
        menuclose = "uvui/carbon/fe_common_mb [10].wav",
        hover = "uvui/carbon/fe_common_mb [1].wav",
        hovertab = "uvui/carbon/fe_common_mb [2].wav",
        click = "uvui/carbon/fe_common_mb [8].wav",
        clickopen = "uvui/carbon/fe_common_mb [5].wav",
        clickback = "uvui/carbon/fe_common_mb [6].wav",
        confirm = "uvui/carbon/fe_common_mb [5].wav"
    },
}

-- Main Menu
UVMenu.Main = function()
	UVMenu.CurrentMenu = UVMenu:Open({
		Name = language.GetPhrase("uv.unitvehicles") .. " - " .. UV.CurVersion,
		Width = ScrW() * 0.8,
		Height = ScrH() * 0.7,
		Description = true,
		UnfocusClose = true,
		Tabs = {
			{ TabName = "#uv.menu.welcome", Icon = "unitvehicles/icons_settings/info.png",
				{ type = "label", text = "#uv.menu.quick", desc = "#uv.menu.quick.desc" },
				{ type = "combo", text = "#uv.ui.main", desc = "uv.ui.main.desc", convar = "unitvehicle_hudtype_main", content = {
						{ "Crash Time - Undercover", "ctu"} ,
						{ "NFS Most Wanted", "mostwanted"} ,
						{ "NFS Carbon", "carbon"} ,
						{ "NFS Underground", "underground"} ,
						{ "NFS Underground 2", "underground2"} ,
						{ "NFS Undercover", "undercover"} ,
						{ "NFS ProStreet", "prostreet"} ,
						{ "NFS World", "world"} ,
						{ "#uv.ui.original", "original"} ,
						{ "#uv.ui.none", "" }
					},
				},
				{ type = "combo", text = "#uv.audio.uvtrax.profile", desc = "uv.audio.uvtrax.profile.desc", convar = "unitvehicle_racetheme", content = uvtraxcontent },
				{ type = "button", text = "#uv.pm.spawnas", convar = "uv_spawn_as_unit", func = 
				function(self2)
					UVMenu.CloseCurrentMenu(true)
					UVMenu.PlaySFX("clickopen")
					timer.Simple(tonumber(GetConVar("uvmenu_close_speed"):GetString()) or 0.2, function()
						RunConsoleCommand("uv_spawn_as_unit")
					end)
				end
				},
				
				{ type = "label", text = "#uv.menu.pnotes" },
				{ type = "info", text = UV.PNotes, centered = true },
				{ type = "image", image = "unitvehicles/icons_settings/latestpatch.png" },
			},
			{ TabName = "#uv.rm", Icon = "unitvehicles/icons/race_events.png", sv = true, playsfx = "clickopen", func = function()
					UVMenu.OpenMenu(UVMenu.RaceManager)
				end,
				{ type = "label", text = "#uv.addons.builtin" },
			},
			{ TabName = "#uv.pm", Icon = "unitvehicles/icons/milestone_911.png",
				{ type = "button", text = "#uv.pm.spawnas", convar = "uv_spawn_as_unit", func = 
				function(self2)
					UVMenu.CloseCurrentMenu(true)
					UVMenu.PlaySFX("clickopen")
					timer.Simple(tonumber(GetConVar("uvmenu_close_speed"):GetString()) or 0.2, function()
						RunConsoleCommand("uv_spawn_as_unit")
					end)
				end
				},

				{ type = "label", text = "#uv.settings.server", sv = true },
				-- { type = "button", text = "#uv.pm.pursuit.toggle", desc = "uv.pm.pursuit.toggle.desc", convar = "uv_startpursuit", sv = true },
				{ type = "button", text = "#uv.pm.pursuit.start", desc = "uv.pm.pursuit.start.desc", convar = "uv_startpursuit", sv = true },
				{ type = "button", text = "#uv.pm.pursuit.stop", desc = "uv.pm.pursuit.stop.desc", convar = "uv_stoppursuit", sv = true },
				{ type = "slider", text = "#uv.pm.heatlevel", desc = "uv.pm.heatlevel.desc", command = "uv_setheat", min = 1, max = MAX_HEAT_LEVEL, decimals = 0, sv = true },
				
				{ type = "button", text = "#uv.pm.ai.spawn", convar = "uv_spawnvehicles", sv = true },
				{ type = "button", text = "#uv.pm.ai.despawn", convar = "uv_despawnvehicles", sv = true },
				
				{ type = "label", text = "#uv.pm.misc", sv = true },
				{ type = "button", text = "#uv.pm.clearbounty", convar = "uv_clearbounty", sv = true },
				{ type = "button", text = "#uv.pm.wantedtable", convar = "uv_wantedtable", sv = true },
			},
			{ TabName = "#uv.addons", Icon = "unitvehicles/icons/generic_cart.png", sv = true,
				{ type = "label", text = "#uv.addons.builtin", desc = "uv.addons.builtin.desc", sv = true },
				{ type = "bool", text = "#uv.addons.vcmod.els", desc = "uv.addons.vcmod.els.desc", convar = "unitvehicle_vcmodelspriority", sv = true },
				{ type = "label", text = "Circular Functions", sv = true },
				{ type = "bool", text = "#uv.ailogic.usenitrousracer", desc = "uv.ailogic.usenitrousracer.desc", convar = "unitvehicle_usenitrousracer", sv = true },
				{ type = "bool", text = "#uv.ailogic.usenitrousunit", desc = "uv.ailogic.usenitrousunit.desc", convar = "unitvehicle_usenitrousunit", sv = true },
			},
			{ TabName = "#uv.faq", Icon = "unitvehicles/icons_settings/question.png",
				{ type = "info", text = UV.FAQ[1] },
				{ type = "info", text = UV.FAQ[2] },
				{ type = "info", text = UV.FAQ[3] },
				{ type = "info", text = UV.FAQ[4] },
				{ type = "info", text = UV.FAQ[5] },
				{ type = "info", text = UV.FAQ[6] },
				{ type = "info", text = UV.FAQ[7] },
				{ type = "info", text = UV.FAQ[8] },
				{ type = "info", text = UV.FAQ[9] },
				{ type = "info", text = UV.FAQ[10] },
				{ type = "info", text = UV.FAQ[11] },
				{ type = "info", text = UV.FAQ[12] },
				{ type = "info", text = UV.FAQ[13] },
				{ type = "info", text = UV.FAQ[14] },
				{ type = "info", text = UV.FAQ[15] },
				{ type = "info", text = UV.FAQ[16] },
				{ type = "info", text = UV.FAQ[17] },
				{ type = "info", text = UV.FAQ[18] },
				{ type = "info", text = UV.FAQ[19] },
			},
			{ TabName = "#uv.settings", Icon = "unitvehicles/icons_settings/options.png", playsfx = "clickopen", func = function()
					UVMenu.OpenMenu(UVMenu.Settings)
				end,
				{ type = "label", text = "#uv.addons.builtin" },
			},
		}
	})
end

-- Settings
UVMenu.Settings = function()
	UVMenu.CurrentMenu = UVMenu:Open({
		Name = language.GetPhrase("uv.unitvehicles") .. " | " .. language.GetPhrase("uv.settings"),
		Width = ScrW() * 0.8,
		Height = ScrH() * 0.7,
		Description = true,
		UnfocusClose = true,
		Tabs = {
			{ TabName = "#uv.ui.title", Icon = "unitvehicles/icons_settings/display.png",

				{ type = "label", text = "#uv.settings.general" },
				{ type = "combo", text = "#uv.ui.main", desc = "uv.ui.main.desc", convar = "unitvehicle_hudtype_main", content = {
						{ "Crash Time - Undercover", "ctu"} ,
						{ "NFS Most Wanted", "mostwanted"} ,
						{ "NFS Carbon", "carbon"} ,
						{ "NFS Underground", "underground"} ,
						{ "NFS Underground 2", "underground2"} ,
						{ "NFS Undercover", "undercover"} ,
						{ "NFS ProStreet", "prostreet"} ,
						{ "NFS World", "world"} ,
						{ "#uv.ui.original", "original"} ,
						{ "#uv.ui.none", "" }
					},
				},
				{ type = "combo", text = "#uv.ui.backup", desc = "uv.ui.backup.desc", convar = "unitvehicle_hudtype_backup", content = {
							{ "NFS Most Wanted", "mostwanted" },
							{ "NFS Carbon", "carbon" },
							{ "NFS Undercover", "undercover" },
							{ "NFS World", "world" },
							{ "#uv.ui.original", "original" }
					},
				},
				{ type = "bool", text = "#uv.ui.racertags", desc = "uv.ui.racertags.desc", convar = "unitvehicle_racertags" },
				{ type = "bool", text = "#uv.ui.preracepopup", desc = "uv.ui.preracepopup.desc", convar = "unitvehicle_preraceinfo" },
				{ type = "bool", text = "#uv.ui.subtitles", desc = "uv.ui.subtitles.desc", convar = "unitvehicle_subtitles" },
				{ type = "bool", text = "#uv.ui.vehnametakedown", desc = "uv.ui.vehnametakedown.desc", convar = "unitvehicle_vehiclenametakedown" },
				{ type = "combo", text = "#uv.ui.unitstype", desc = "uv.ui.unitstype.desc", convar = "unitvehicle_unitstype", content = {
						{ "#uv.ui.unitstype.meter", 0 },
						{ "#uv.ui.unitstype.feet", 1 },
						{ "#uv.ui.unitstype.yards", 2 },
					},
				},

				{ type = "label", text = "#uv.ui.menu", desc = "uv.ui.menu.desc" },
				{ type = "bool", text = "#uv.ui.menu.hidedesc", desc = "uv.ui.menu.hidedesc.desc", convar = "uvmenu_hide_description" },
				{ type = "slider", text = "#uv.ui.menu.openspeed", desc = "uv.ui.menu.openspeed.desc", convar = "uvmenu_open_speed", min = 0.1, max = 1, decimals = 2 },
				{ type = "slider", text = "#uv.ui.menu.closespeed", desc = "uv.ui.menu.closespeed.desc", convar = "uvmenu_close_speed", min = 0.1, max = 1, decimals = 2 },
				{ type = "button", text = "#uv.ui.menu.custcol", desc = "uv.ui.menu.custcol.desc", playsfx = "clickopen", func = function() UVMenu.OpenMenu(UVMenu.SettingsCol, true) end },
			},
			{ TabName = "#uv.audio.title", Icon = "unitvehicles/icons_settings/audio.png",

				{ type = "label", text = "#uv.settings.general" },
				{ type = "slider", text = "#uv.audio.volume", desc = "uv.audio.volume.desc", convar = "unitvehicle_pursuitthemevolume", min = 0, max = 2, decimals = 1 },
				{ type = "slider", text = "#uv.audio.copchatter", desc = "uv.audio.copchatter.desc", convar = "unitvehicle_chattervolume", min = 0, max = 5, decimals = 1 },
				{ type = "bool", text = "#uv.audio.mutecp", desc = "uv.audio.mutecp.desc", convar = "unitvehicle_mutecheckpointsfx" },
				{ type = "bool", text = "#uv.audio.menu.sfx", desc = "uv.audio.menu.sfx.desc", convar = "uvmenu_sound_enabled" },
				{ type = "combo", text = "#uv.audio.menu.sfx.profile", desc = "uv.audio.menu.sfx.profile.desc", convar = "uvmenu_sound_set", requireparentconvar = "uvmenu_sound_enabled", content = {
						{ "NFS Most Wanted", "MW" },
						{ "NFS Carbon", "Carbon" },
					},
				},

				{ type = "label", text = "#uv.audio.uvtrax" },
				{ type = "bool", text = "#uv.audio.uvtrax.enable", desc = "uv.audio.uvtrax.desc", convar = "unitvehicle_racingmusic" },
				{ type = "combo", text = "#uv.audio.uvtrax.profile", desc = "uv.audio.uvtrax.profile.desc", convar = "unitvehicle_racetheme", content = uvtraxcontent, requireparentconvar = "unitvehicle_racingmusic" },
				{ type = "bool", text = "#uv.audio.uvtrax.freeroam", desc = "uv.audio.uvtrax.freeroam.desc", convar = "unitvehicle_uvtraxinfreeroam", requireparentconvar = "unitvehicle_racingmusic" },
				{ type = "bool", text = "#uv.audio.uvtrax.pursuits", desc = "uv.audio.uvtrax.pursuits.desc", convar = "unitvehicle_racingmusicoutsideraces", requireparentconvar = "unitvehicle_racingmusic" },

				{ type = "label", text = "#uv.audio.pursuit" },
				{ type = "bool", text = "#uv.audio.pursuit.enable", desc = "uv.audio.pursuit.desc", convar = "unitvehicle_playmusic" },
				{ type = "combo", text = "#uv.audio.pursuittheme", desc = "uv.audio.pursuittheme.desc", convar = "unitvehicle_pursuittheme", content = pursuitcontent, requireparentconvar = "unitvehicle_playmusic" },
				{ type = "bool", text = "#uv.audio.pursuitpriority", desc = "uv.audio.pursuitpriority.desc", convar = "unitvehicle_racingmusicpriority", requireparentconvar = "unitvehicle_playmusic" },
				{ type = "bool", text = "#uv.audio.pursuittheme.random", desc = "uv.audio.pursuittheme.random.desc", convar = "unitvehicle_pursuitthemeplayrandomheat" },
				{ type = "combo", text = "#uv.audio.pursuittheme.random.type", desc = "uv.audio.pursuittheme.random.type.desc", convar = "unitvehicle_pursuitthemeplayrandomheattype", requireparentconvar = "unitvehicle_pursuitthemeplayrandomheat", content = {
						{ "#uv.audio.pursuittheme.random.type.sequential", "sequential" },
						{ "#uv.audio.pursuittheme.random.minutes", "everyminutes" },
					},
				},
				{ type = "slider", text = "#uv.audio.pursuittheme.random.minutes", desc = "uv.audio.pursuittheme.random.minutes.desc", convar = "unitvehicle_chattervolume", min = 1, max = 10, decimals = 0, requireparentconvar = "unitvehicle_pursuitthemeplayrandomheat" },
				
				{ type = "label", text = "#uv.audio.racing" },
				{ type = "combo", text = "#uv.audio.racing.sfx", desc = "uv.audio.racing.sfx.desc", convar = "unitvehicle_sfxtheme", content = racesfxcontent },
			},
			-- { TabName = "#uv.keybinds", Icon = "unitvehicles/icons_settings/controls.png", -- Can't get it to work - oh well.

				-- { type = "label", text = "#uv.keybinds.pt" },
				-- { type = "keybind", text = "#uv.ptech.slot1", desc = "uv.keybind.skipsong.desc", convar = "UVPTKeybindSlot1", slot = 1 },
				-- { type = "keybind", text = "#uv.ptech.slot2", desc = "uv.keybind.skipsong.desc", convar = "UVPTKeybindSlot2", slot = 2 },
				
				-- { type = "label", text = "#uv.keybinds.races" },
				-- { type = "keybind", text = "#uv.keybind.skipsong", desc = "uv.keybind.skipsong.desc", convar = "unitvehicle_keybind_skipsong", slot = 3 },
				-- { type = "keybind", text = "#uv.keybind.resetposition", desc = "uv.keybind.resetposition.desc", convar = "UVKeybindResetPosition", slot = 4 },
				-- { type = "keybind", text = "#uv.keybind.showresults", desc = "uv.keybind.showresults.desc", convar = "UVKeybindShowRaceResults", slot = 5 },
			-- },
			{ TabName = "#uv.pursuit", Icon = "unitvehicles/icons/milestone_pursuit.png", sv = true,
				{ type = "label", text = "#uv.pursuit.heatlevels", sv = true },
				{ type = "bool", text = "#uv.pursuit.heatlevels.enable", desc = "uv.pursuit.heatlevels.enable.desc", convar = "unitvehicle_heatlevels", sv = true },
				{ type = "bool", text = "#uv.pursuit.heatlevels.aiunits", desc = "uv.pursuit.heatlevels.aiunits.desc", convar = "unitvehicle_spawnmainunits", sv = true },
				
				{ type = "label", text = "#uv.settings.general", sv = true },
				{ type = "bool", text = "#uv.pursuit.randomplayerunits", desc = "uv.pursuit.randomplayerunits.desc", convar = "unitvehicle_randomplayerunits", sv = true },
				{ type = "bool", text = "#uv.pursuit.autohealth", desc = "uv.pursuit.autohealth.desc", convar = "unitvehicle_autohealth", sv = true },
				{ type = "bool", text = "#uv.pursuit.wheelsdetaching", desc = "uv.pursuit.wheelsdetaching.desc", convar = "unitvehicle_wheelsdetaching", sv = true },
				{ type = "bool", text = "#uv.pursuit.spottedfreezecam", desc = "uv.pursuit.spottedfreezecam.desc", convar = "unitvehicle_spottedfreezecam", sv = true },
				{ type = "slider", text = "#uv.pursuit.repaircooldown", desc = "uv.pursuit.repaircooldown.desc", convar = "unitvehicle_repaircooldown", min = 5, max = 300, decimals = 0, sv = true },
				{ type = "slider", text = "#uv.pursuit.repairrange", desc = "uv.pursuit.repairrange.desc", convar = "unitvehicle_repairrange", min = 10, max = 1000, decimals = 0, sv = true },
				{ type = "bool", text = "#uv.pursuit.noevade", desc = "uv.pursuit.noevade.desc", convar = "unitvehicle_neverevade", sv = true },
				{ type = "slider", text = "#uv.pursuit.bustedtime", desc = "uv.pursuit.bustedtime.desc", convar = "unitvehicle_bustedtimer", min = 0, max = 10, decimals = 1, sv = true },
				{ type = "slider", text = "#uv.pursuit.respawntime", desc = "uv.pursuit.respawntime.desc", convar = "unitvehicle_spawncooldown", min = 0, max = 120, decimals = 0, sv = true },
				{ type = "slider", text = "#uv.pursuit.spikeduration", desc = "uv.pursuit.spikeduration.desc", convar = "unitvehicle_spikestripduration", min = 0, max = 120, decimals = 0, sv = true },
			},
			{ TabName = "#uv.ptech", Icon = "unitvehicles/icons_carbon/wingman_target.png", sv = true,
				{ type = "label", text = "#uv.settings.general", sv = true },
				{ type = "bool", text = "#uv.ptech.racer", desc = "uv.ptech.racer.desc", convar = "unitvehicle_racerpursuittech", sv = true },
				{ type = "bool", text = "#uv.ptech.friendlyfire", desc = "uv.ptech.friendlyfire.desc", convar = "unitvehicle_racerfriendlyfire", sv = true },
				{ type = "bool", text = "#uv.ptech.roadblockfriendlyfire", desc = "uv.ptech.roadblockfriendlyfire.desc", convar = "unitvehicle_spikestriproadblockfriendlyfire", sv = true },
			},
			{ TabName = "#uv.ai.title", Icon = "unitvehicles/icons/cops_icon.png", sv = true,
				{ type = "label", text = "#uv.ailogic", sv = true },
				{ type = "bool", text = "#uv.ailogic.optimizerespawn", desc = "uv.ailogic.optimizerespawn.desc", convar = "unitvehicle_optimizerespawn", sv = true },
				{ type = "bool", text = "#uv.ailogic.relentless", desc = "uv.ailogic.relentless.desc", convar = "unitvehicle_relentless", sv = true },
				{ type = "bool", text = "#uv.ailogic.wrecking", desc = "uv.ailogic.wrecking.desc", convar = "unitvehicle_canwreck", sv = true },
				{ type = "slider", text = "#uv.ailogic.detectionrange", desc = "uv.ailogic.detectionrange.desc", convar = "unitvehicle_detectionrange", min = 1, max = 100, decimals = 0, sv = true },
				{ type = "bool", text = "#uv.ailogic.headlights", desc = "uv.ailogic.headlights.desc", convar = "unitvehicle_enableheadlights", sv = true },
				{ type = "bool", text = "#uv.ailogic.autohealthracer", desc = "uv.ailogic.autohealthracer.desc", convar = "unitvehicle_autohealthracer", sv = true },
				{ type = "bool", text = "#uv.ailogic.customizeracer", desc = "uv.ailogic.customizeracer.desc", convar = "unitvehicle_customizeracer", sv = true },
				{ type = "bool", text = "#uv.ailogic.tractioncontrol", desc = "uv.ailogic.tractioncontrol.desc", convar = "unitvehicle_tractioncontrol", sv = true },
				
				{ type = "label", text = "#uv.ainav", sv = true },
				{ type = "bool", text = "#uv.ainav.pathfind", desc = "uv.ainav.pathfind.desc", convar = "unitvehicle_pathfinding", sv = true },
				{ type = "bool", text = "#uv.ainav.dvpriority", desc = "uv.ainav.dvpriority.desc", convar = "unitvehicle_dvwaypointspriority", sv = true },
				
				{ type = "label", text = "#uv.chatter", sv = true },
				{ type = "bool", text = "#uv.chatter.enable", desc = "uv.chatter.enable.desc", convar = "unitvehicle_chatter", sv = true },
				{ type = "bool", text = "#uv.chatter.text", desc = "uv.chatter.text.desc", convar = "unitvehicle_chattertext", sv = true },
				
				{ type = "label", text = "#uv.response", sv = true },
				{ type = "bool", text = "#uv.response.enable", desc = "uv.response.enable.desc", convar = "unitvehicle_callresponse", sv = true },
				{ type = "slider", text = "#uv.response.speedlimit", desc = "uv.response.speedlimit.desc", convar = "unitvehicle_speedlimit", min = 0, max = 100, decimals = 0, sv = true },
			},
			
			{ TabName = "#uv.back", playsfx = "clickback", func = function()
					UVMenu.OpenMenu(UVMenu.Main)
				end,
				{ type = "label", text = "#uv.addons.builtin" },
			},
		}
	})
end

-- Colour Settings
UVMenu.SettingsCol = function()
	UVMenu.CurrentMenu = UVMenu:Open({
		Name = " ",
		Width = ScrW() * 0.65,
		Height = ScrH() * 0.7,
		Description = true,
		-- ColorPreview = true,
		UnfocusClose = true,
		Tabs = {
			{ TabName = "#uv.ui.menu.custcol",
				{ type = "button", text = "#uv.back", playsfx = "clickback",
						func = function(self2) UVMenu.OpenMenu(UVMenu.Settings) end
				},
				{ type = "label", text = "#uv.ui.menu.col.bg" },
				{ type = "coloralpha", text = "#uv.ui.menu.col", desc = "uv.ui.menu.col.desc", convar = "uvmenu_col_bg" },
				
				{ type = "label", text = "#uv.ui.menu.col.description" },
				{ type = "coloralpha", text = "#uv.ui.menu.col", desc = "uv.ui.menu.col.desc", convar = "uvmenu_col_desc" },
				
				{ type = "label", text = "#uv.ui.menu.col.tabs" },
				{ type = "coloralpha", text = "#uv.ui.menu.col.background", desc = "uv.ui.menu.col.background.desc", convar = "uvmenu_col_tabs" },
				{ type = "coloralpha", text = "#uv.ui.menu.col", desc = "uv.ui.menu.col.desc", convar = "uvmenu_col_tab_default" },
				{ type = "coloralpha", text = "#uv.ui.menu.col.active", desc = "uv.ui.menu.col.active.desc", convar = "uvmenu_col_tab_active" },
				{ type = "coloralpha", text = "#uv.ui.menu.col.hover", desc = "uv.ui.menu.col.hover.desc", convar = "uvmenu_col_tab_hover" },
				
				{ type = "label", text = "#uv.ui.menu.col.label" },
				{ type = "coloralpha", text = "#uv.ui.menu.col", desc = "uv.ui.menu.col.desc", convar = "uvmenu_col_label" },
				
				{ type = "label", text = "#uv.ui.menu.col.bool" },
				{ type = "coloralpha", text = "#uv.ui.menu.col", desc = "uv.ui.menu.col.desc", convar = "uvmenu_col_bool" },
				{ type = "coloralpha", text = "#uv.ui.menu.col.active", desc = "uv.ui.menu.col.active.desc", convar = "uvmenu_col_bool_active" },
				
				{ type = "label", text = "#uv.ui.menu.col.button" },
				{ type = "coloralpha", text = "#uv.ui.menu.col", desc = "uv.ui.menu.col.desc", convar = "uvmenu_col_button" },
				{ type = "coloralpha", text = "#uv.ui.menu.col.hover", desc = "uv.ui.menu.col.hover.desc", convar = "uvmenu_col_button_hover" },

				{ type = "button", text = "#uv.back", playsfx = "clickback",
						func = function(self2) UVMenu.OpenMenu(UVMenu.Settings) end
				},
			},
		}
	})
end

if CLIENT then
	list.Set("DesktopWindows", "UnitVehiclesMenu", {
		title = "#uv.unitvehicles",
		icon  = "unitvehicles/icons/MILESTONE_OUTRUN_PURSUITS_WON.png",
		init = function(icon, window)
			RunConsoleCommand("unitvehicles_menu")
		end
	})
end

concommand.Add("unitvehicles_menu", function()
    if UVMenu.CurrentMenu and IsValid(UVMenu.CurrentMenu) then
        UVMenu.OpenMenu(UVMenu.CurrentMenu, true)
    elseif UVMenu.LastMenu then
        UVMenu.OpenMenu(UVMenu.LastMenu)
    else
        UVMenu.OpenMenu(UVMenu.Main)
    end
	UVMenu.PlaySFX("menuopen")
end)

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

--[[ 
UVMenu Framework
Single-file menu system for Garry's Mod
Author: Adapted from UnitVehicles Settings menu
]]

--[[ UVMenu:Open
    config = {
        Title = "Menu title",
        Width = 800,
        Height = 600,
        MainColor = Color(...),
        PanelColor = Color(...),
        AccentColor = Color(...),
        TitleFont = "fontname",
        ItemFont = "fontname",
        Description = true/false,
        Tabs = { {name="tab1", items={...}}, ... }
    }
--]]

-- Store all menus globally
UVMenu.Menus = UVMenu.Menus or {}

-- [[ Start of Menu ConVars ]] --
	-- Sounds
	CreateClientConVar("uvmenu_sound_enabled", 1, true, false)
	CreateClientConVar("uvmenu_sound_set", "MW", true, false)

	-- Background
	CreateClientConVar("uvmenu_hide_description", 0, true, false)

	CreateClientConVar("uvmenu_open_speed", 0.25, true, false)
	CreateClientConVar("uvmenu_close_speed", 0.25, true, false)

	-- Background colour
	CreateClientConVar("uvmenu_col_bg_r", 25, true, false)
	CreateClientConVar("uvmenu_col_bg_g", 25, true, false)
	CreateClientConVar("uvmenu_col_bg_b", 25, true, false)
	CreateClientConVar("uvmenu_col_bg_a", 245, true, false)

	-- Description panel colour
	CreateClientConVar("uvmenu_col_desc_r", 28, true, false)
	CreateClientConVar("uvmenu_col_desc_g", 28, true, false)
	CreateClientConVar("uvmenu_col_desc_b", 28, true, false)
	CreateClientConVar("uvmenu_col_desc_a", 150, true, false)

	-- Tabs sidebar colour
	CreateClientConVar("uvmenu_col_tabs_r", 125, true, false)
	CreateClientConVar("uvmenu_col_tabs_g", 125, true, false)
	CreateClientConVar("uvmenu_col_tabs_b", 125, true, false)
	CreateClientConVar("uvmenu_col_tabs_a", 75,  true, false)

	-- Tab button (active/hover/default)
	CreateClientConVar("uvmenu_col_tab_default_r", 125, true, false)
	CreateClientConVar("uvmenu_col_tab_default_g", 125, true, false)
	CreateClientConVar("uvmenu_col_tab_default_b", 125, true, false)

	CreateClientConVar("uvmenu_col_tab_active_r", 255, true, false)
	CreateClientConVar("uvmenu_col_tab_active_g", 255, true, false)
	CreateClientConVar("uvmenu_col_tab_active_b", 255, true, false)

	CreateClientConVar("uvmenu_col_tab_hover_r", 255, true, false)
	CreateClientConVar("uvmenu_col_tab_hover_g", 255, true, false)
	CreateClientConVar("uvmenu_col_tab_hover_b", 255, true, false)

	-- Label colour
	CreateClientConVar("uvmenu_col_label_r", 100, true, false)
	CreateClientConVar("uvmenu_col_label_g", 100, true, false)
	CreateClientConVar("uvmenu_col_label_b", 100, true, false)
	CreateClientConVar("uvmenu_col_label_a", 75,  true, false)

	-- Bool colour
	CreateClientConVar("uvmenu_col_bool_r", 125, true, false)
	CreateClientConVar("uvmenu_col_bool_g", 125, true, false)
	CreateClientConVar("uvmenu_col_bool_b", 125, true, false)
	CreateClientConVar("uvmenu_col_bool_a", 200, true, false)

	CreateClientConVar("uvmenu_col_bool_active_r", 58, true, false)
	CreateClientConVar("uvmenu_col_bool_active_g", 193, true, false)
	CreateClientConVar("uvmenu_col_bool_active_b", 0, true, false)

	-- Bool colour
	CreateClientConVar("uvmenu_col_button_r", 125, true, false)
	CreateClientConVar("uvmenu_col_button_g", 125, true, false)
	CreateClientConVar("uvmenu_col_button_b", 125, true, false)
	CreateClientConVar("uvmenu_col_button_a", 125, true, false)

	CreateClientConVar("uvmenu_col_button_hover_r", 125, true, false)
	CreateClientConVar("uvmenu_col_button_hover_g", 125, true, false)
	CreateClientConVar("uvmenu_col_button_hover_b", 125, true, false)
	CreateClientConVar("uvmenu_col_button_hover_a", 200, true, false)

-- [[ End of Color ConVars ]] --

function UV.PlayerCanSeeSetting(st)
	if st.sv or st.admin then
		local ply = LocalPlayer()
		if not IsValid(ply) then return false end
		if not ply:IsAdmin() and not ply:IsSuperAdmin() then
		-- if ply:IsAdmin() and ply:IsSuperAdmin() then
			return false
		end
	end
	return true
end

-- Filtering logic similar to ARC9
function UV.ShouldDrawSetting(st)
	if not UV.PlayerCanSeeSetting(st) then
		return false
	end

	if st.showfunc and st.showfunc() == false then return false end
	
	if st.cond and st.cond() == false then return false end

	if st.requireparentconvar then
		local c = GetConVar(st.requireparentconvar)
		if c then
			local v = c:GetBool()
			if st.parentinvert then v = not v end
			if not v then return false end
		end
	elseif st.parentconvar then
		local c = GetConVar(st.parentconvar)
		if c then
			local v = c:GetBool()
			if st.parentinvert then v = not v end
			if not v then return false end
		end
	end

	if st.requireconvar then
		local c = GetConVar(st.requireconvar)
		if c and not c:GetBool() then return false end
	end

	if st.requireconvaroff then
		local c = GetConVar(st.requireconvaroff)
		if c and c:GetBool() then return false end
	end

	return true
end

-- small materials for on/off indicators
local matTick = Material("unitvehicles/icons/generic_check.png", "mips")
local matCross = Material("unitvehicles/icons/generic_uncheck.png", "mips")

-- Build one setting (label / bool / slider / combo / button)
function UV.BuildSetting(parent, st, descPanel)
	local function GetDisplayText()
		local prefix = ""

		-- If parentconvar or requireparentconvar is active, show prefix
		local parentName = st.parentconvar or st.requireparentconvar
		if parentName then
			local cv = GetConVar(parentName)
			if cv and cv:GetBool() then
				prefix = "|--- "
			end
		end

		return prefix .. language.GetPhrase(st.text)
	end
		
	-- if st is an information panel
	if st.type == "info" then
		local function ConvertDiscordFormatting(str)
			str = str:gsub("%*%*(.-)%*%*", "<font=UVSettingsFontSmall-Bold>%1</font>")
			str = str:gsub("(%s)%*(.-)%*", "<font=UVSettingsFontSmall-Italic> %2 </font>")
			str = str:gsub("^%*(.-)%*", "[i]%1[/i]")
			str = str:gsub("__(.-)__", "[u]%1[/u]")
			str = str:gsub("^#%s*(.-)\n", "<font=UVSettingsFontBig>%1</font>\n")
			str = str:gsub("\n#%s*(.-)\n", "\n<font=UVSettingsFontBig>%1</font>\n")
			return str
		end

		local p = vgui.Create("DPanel", parent)
		p:Dock(TOP)
		p:DockMargin(6, 6, 6, 2)
		p:SetPaintBackground(false)

		local rawText = language.GetPhrase(st.text or "") or ""
		rawText = ConvertDiscordFormatting(rawText)

		local mk
		local lastWidth = 0
		local padding = 10

		function p:Rebuild()
			local w = self:GetWide()
			if w <= 0 then return end

			local text = rawText

			mk = markup.Parse(
				"<font=UVSettingsFontSmall>" .. text .. "</font>",
				w - 20
			)

			self:SetTall(mk:GetHeight() + 20)
		end

		function p:PerformLayout()
			local w = self:GetWide()
			if w ~= lastWidth then
				lastWidth = w
				self:Rebuild()
			end
		end

		function p:Paint(w, h)
			surface.SetDrawColor(28, 28, 28, 150)
			surface.DrawRect(0, 0, w, h)

			if mk then
				mk:Draw(10, 10)
			end
		end

		return p
	end

	-- if st is a header label
	if st.type == "infosimple" then
		local p = vgui.Create("DPanel", parent)
		p:Dock(TOP)
		p:SetTall(46)
		p:DockMargin(6, 6, 6, 2)
		p.Paint = function(self, w, h)
            local a = self:GetAlpha()
			local bg = Color( GetConVar("uvmenu_col_label_r"):GetInt(), GetConVar("uvmenu_col_label_g"):GetInt(), GetConVar("uvmenu_col_label_b"):GetInt(), GetConVar("uvmenu_col_label_a"):GetInt() )

			if a > 5 then
				local baseFont = "UVMostWantedLeaderboardFont"
				local multiFont = baseFont
				local text = language.GetPhrase(st.text) or "???"

				-- First, pre-wrap all text to count lines
				local paragraphs = string.Split(text, "\n")
				local wrappedLines = {}

				for _, paragraph in ipairs(paragraphs) do
					if paragraph == "" then
						table.insert(wrappedLines, "")
					else
						local wrapped = UV_WrapText(paragraph, baseFont, w - (w * 0.15) * 2)
						for _, line in ipairs(wrapped) do
							table.insert(wrappedLines, line)
						end
					end
				end

				-- Total line count
				local lineCount = #wrappedLines

				-- Rule 3: If 3+ lines, switch font
				if lineCount >= 3 then
					multiFont = "UVMostWantedLeaderboardFont2"
				end

				surface.SetFont(multiFont)
				local _, lineHeight = surface.GetTextSize("A")

				local totalHeight = lineHeight * lineCount
				local centerY = h * 0.5
				local xPadding = st.centered and w*0.5 or 0

				-- Center vertically depending on line count
				local startY = centerY - (totalHeight / 2)

				local color = Color(255, 255, 255, a)

				-- Draw wrapped text
				local yOffset = startY
				for _, line in ipairs(wrappedLines) do
					draw.DrawText(line, multiFont, xPadding, yOffset, color, st.centered and TEXT_ALIGN_CENTER or TEXT_ALIGN_LEFT)
					yOffset = yOffset + lineHeight
				end
			end
		end
		
		if st.desc then
			p.OnCursorEntered = function()
				if descPanel then
					descPanel.Text = st.text
					descPanel.Desc = st.desc or ""
				end
			end

			p.OnCursorExited = function()
				if descPanel then
					descPanel.Text = ""
					descPanel.Desc = ""
				end
			end
		end
		
		return p
	end

	-- if st is a singular image
	if st.type == "image" then
		local p = vgui.Create("DPanel", parent)
		p:Dock(TOP)
		p:DockMargin(6, 6, 6, 2)

		-- Force 16:9 height based on available width
		p.PerformLayout = function(self, w, h)
			local newH = math.floor((w / 16) * 9)
			self:SetTall(newH)
		end

		local mat = Material(st.image or "", "smooth")

		p.Paint = function(self, w, h)
			surface.SetDrawColor(0, 0, 0, 200)
			surface.DrawRect(0, 0, w, h)

			if not mat or mat:IsError() then
				draw.SimpleText("Missing image", "DermaLarge", w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				return
			end

			-- Draw image fully scaled to panel (letterboxed)
			local iw, ih = mat:Width(), mat:Height()
			if iw == 0 or ih == 0 then return end

			local ratio = math.min(w / iw, h / ih)
			local fw, fh = iw * ratio, ih * ratio
			local x = (w - fw) * 0.5
			local y = (h - fh) * 0.5

			surface.SetMaterial(mat)
			surface.SetDrawColor(255, 255, 255)
			surface.DrawTexturedRect(x, y, fw, fh)
		end
		return p
	end

	-- if st is a header label
	if st.type == "label" then
		local p = vgui.Create("DPanel", parent)
		p:Dock(TOP)
		p:SetTall(36)
		p:DockMargin(6, 6, 6, 2)
		p.Paint = function(self, w, h)
			local bg = Color( GetConVar("uvmenu_col_label_r"):GetInt(), GetConVar("uvmenu_col_label_g"):GetInt(), GetConVar("uvmenu_col_label_b"):GetInt(), GetConVar("uvmenu_col_label_a"):GetInt() )
			
			draw.RoundedBox(4, 0, 0, w, h, bg)
			draw.SimpleText(st.text, "UVFont5UI", w*0.5, h*0.4, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		
		if st.desc then
			p.OnCursorEntered = function()
				if descPanel then
					descPanel.Text = st.text
					descPanel.Desc = st.desc or ""
				end
			end

			p.OnCursorExited = function()
				if descPanel then
					descPanel.Text = ""
					descPanel.Desc = ""
				end
			end
		end
		
		return p
	end

	---- boolean custom button ----
	if st.type == "bool" then
		local wrap = vgui.Create("DButton", parent)
		wrap:Dock(TOP)
		wrap:DockMargin(6, 4, 6, 4)
		wrap:SetTall(30)
		wrap:SetText("")
		wrap:SetCursor("hand")

		local cv = GetConVar(st.convar)
		local function getBool()
			if cv then return cv:GetBool() end
			return false
		end

		wrap.DoClick = function()
			if not cv then return end
			local new = getBool() and "0" or "1"
			RunConsoleCommand(st.convar, new)
			UVMenu.PlaySFX("confirm")
		end

		wrap.OnCursorEntered = function()
			-- UVMenu.PlaySFX("hover")
			if descPanel then
				descPanel.Text = st.text
				descPanel.Desc = st.desc or ""
				if st.convar then
					descPanel.SelectedDefault = GetConVar(st.convar):GetDefault() or "?"
					descPanel.SelectedConVar = st.convar or "?"
				end
			end
		end

		wrap.OnCursorExited = function()
			if descPanel then
				descPanel.Text = ""
				descPanel.Desc = ""
				if st.convar then
					descPanel.SelectedDefault = ""
					descPanel.SelectedConVar = ""
				end
			end
		end

		wrap.Paint = function(self, w, h)
			local enabled = getBool()
			local hovered = self:IsHovered()

			local bga = hovered and 
			GetConVar("uvmenu_col_bool_a"):GetInt() * math.abs(math.sin(RealTime()*4)) 
			or GetConVar("uvmenu_col_bool_a"):GetInt() * 0.75
			local bg

			local default = Color( 
				GetConVar("uvmenu_col_bool_r"):GetInt(),
				GetConVar("uvmenu_col_bool_g"):GetInt(),
				GetConVar("uvmenu_col_bool_b"):GetInt(),
				bga
			)
			local active = Color(
				GetConVar("uvmenu_col_bool_active_r"):GetInt(),
				GetConVar("uvmenu_col_bool_active_g"):GetInt(),
				GetConVar("uvmenu_col_bool_active_b"):GetInt(),
				bga
			)

			bg = enabled and active or default

			-- background & text
			draw.RoundedBox(6, w - 34, 0, 30, h, bg)
			draw.SimpleText(GetDisplayText(), "UVMostWantedLeaderboardFont", 10, h/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

			-- icon right
			-- if enabled then
				-- surface.SetDrawColor(255,255,255, enabled and 255 or 200)
				-- surface.SetMaterial(enabled and matTick or matCross)
				-- surface.DrawTexturedRect(w - 34, 0, 30, 30)
			-- end
		end

		-- dynamic update when convar changes - simple timer check
		wrap.Think = function(self)
			-- nothing heavy; updates on click via convar toggle
		end
		
		wrap.OnMousePressed = function(self, mc)
			if mc == MOUSE_MIDDLE and st.convar then
				local cv = GetConVar(st.convar)
				if cv then
					RunConsoleCommand(st.convar, cv:GetDefault())
					UVMenu.PlaySFX("confirm")
				end
				return
			end
			-- existing left-click handling:
			if mc == MOUSE_LEFT then
				self:DoClick()
			end
		end

		return wrap
	end

	---- slider: label left, slider right ----
	if st.type == "slider" then
		local wrap = vgui.Create("DPanel", parent)
		wrap:Dock(TOP)
		wrap:DockMargin(6, 4, 6, 4)

		local function RecalcWrapHeight()
			if not IsValid(wrap) then return end

			local baseFont = "UVMostWantedLeaderboardFont"
			local multiFont = baseFont
			local desc = language.GetPhrase(GetDisplayText()) or "???"
			local maxTextWidth = wrap:GetWide() - (wrap:GetWide() * 0.25) * 2
			if maxTextWidth <= 0 then return end

			local paragraphs = string.Split(desc, "\n")
			local wrappedLines = {}
			for _, paragraph in ipairs(paragraphs) do
				if paragraph == "" then
					table.insert(wrappedLines, "")
				else
					for _, line in ipairs(UV_WrapText(paragraph, baseFont, maxTextWidth)) do
						table.insert(wrappedLines, line)
					end
				end
			end

			if #wrappedLines >= 3 then multiFont = "UVMostWantedLeaderboardFont2" end
			surface.SetFont(multiFont)
			local _, lineHeight = surface.GetTextSize("A")

			local newHeight = math.max(36, (#wrappedLines * lineHeight) + 12)
			if wrap:GetTall() ~= newHeight then wrap:SetTall(newHeight) end
		end

		wrap.PerformLayout = RecalcWrapHeight

		wrap.Paint = function(self, w, h)
			local a = self:GetAlpha()
			if a <= 5 then return end

			local baseFont = "UVMostWantedLeaderboardFont"
			local multiFont = baseFont
			local desc = language.GetPhrase(GetDisplayText()) or "???"

			local paragraphs = string.Split(desc, "\n")
			local wrappedLines = {}
			for _, paragraph in ipairs(paragraphs) do
				if paragraph == "" then
					table.insert(wrappedLines, "")
				else
					for _, line in ipairs(UV_WrapText(paragraph, baseFont, w - (w * 0.25) * 2)) do
						table.insert(wrappedLines, line)
					end
				end
			end

			if #wrappedLines >= 3 then multiFont = "UVMostWantedLeaderboardFont2" end
			surface.SetFont(multiFont)
			local _, lineHeight = surface.GetTextSize("A")

			local totalHeight = lineHeight * #wrappedLines
			local startY = (h - totalHeight) / 2
			local color = Color(255, 255, 255, a)

			for i, line in ipairs(wrappedLines) do
				draw.DrawText(line, multiFont, 10, startY + (i-1)*lineHeight, color, TEXT_ALIGN_LEFT)
			end
		end

		local function PushDesc()
			if descPanel then
				descPanel.Text = st.text
				descPanel.Desc = st.desc or ""
				if st.convar then
					descPanel.SelectedDefault = GetConVar(st.convar):GetDefault() or "?"
					descPanel.SelectedConVar = st.convar or st.command or "?"
				elseif st.command then
					descPanel.SelectedConVar = st.command or "?"
				end
			end
		end
		local function PopDesc()
			if descPanel then
				descPanel.Text = ""
				descPanel.Desc = ""
				if st.convar then
					descPanel.SelectedDefault = ""
					descPanel.SelectedConVar = ""
				elseif st.command then
					descPanel.SelectedConVar = ""
				end
			end
		end
		wrap.OnCursorEntered = PushDesc
		wrap.OnCursorExited  = PopDesc

		local slider = vgui.Create("DNumSlider", wrap)
		slider:Dock(RIGHT)
		slider:SetWide(220)
		slider:DockMargin(8, 0, 6, 0)
		slider:SetContentAlignment(5)
		slider:SetMin(st.min or 0)
		slider:SetMax(st.max or 100)
		slider:SetDecimals(st.decimals or 0)
		slider:SetValue(st.min or 0)
		slider.Label:SetVisible(false)
		slider.TextArea:SetVisible(false)
		slider.OnCursorEntered = PushDesc
		slider.OnCursorExited  = PopDesc

		local valPanel = vgui.Create("DPanel", wrap)
		valPanel:SetWide(84)
		valPanel:Dock(RIGHT)
		valPanel.Paint = function() end

		local valBox = vgui.Create("DTextEntry", valPanel)
		valBox:SetWide(60)
		valBox:SetFont("UVMostWantedLeaderboardFont")
		valBox:SetTextColor(color_white)
		valBox:SetHighlightColor(Color(58,193,0))
		valBox:SetCursorColor(Color(58,193,0))
		valBox.Paint = function(self2, w, h)
			draw.RoundedBox(4, 0, 0, w, h, Color(30,30,30,200))
			self2:DrawTextEntryText(color_white, Color(58,193,0), color_white)
		end
		valBox.OnCursorEntered = PushDesc
		valBox.OnCursorExited  = PopDesc

		-- Only validate on enter/apply, allow free typing
		valBox.OnTextChanged = function(self2)
			local v = tonumber(self2:GetValue())
			if v then
				-- store as pending value but don't overwrite with applied yet
				pendingValue = v
				applyBtn:SetVisible(math.abs(pendingValue - appliedValue) > 0)
			end
		end

		local applyBtn = vgui.Create("DButton", valPanel)
		applyBtn:SetSize(20, valBox:GetTall())
		applyBtn:SetText("✔")
		applyBtn:SetVisible(false)
		applyBtn.Paint = function(self2, w, h)
			draw.RoundedBox(4,0,0,w,h,self2:IsHovered() and Color(60,180,60) or Color(45,140,45))
			draw.SimpleText("✔", "UVMostWantedLeaderboardFont", w/2,h/2,color_white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		end
		applyBtn.OnCursorEntered = PushDesc
		applyBtn.OnCursorExited  = PopDesc

		-- Vertically center value box and button
		local function LayoutValPanel()
			if not (IsValid(valBox) and IsValid(applyBtn)) then return end
			local offsetY = (wrap:GetTall() - valBox:GetTall()) / 2
			valBox:SetPos(0, offsetY)
			applyBtn:SetPos(valBox:GetWide() + 2, offsetY)
		end
		wrap.OnSizeChanged = LayoutValPanel

		local appliedValue = st.min or 0
		local pendingValue = appliedValue

		local function RoundValue(val)
			if st.decimals then
				local factor = 10 ^ st.decimals
				return math.floor(val * factor + 0.5) / factor
			end
			return val
		end

		local function ApplyPendingValue()
			local val = RoundValue(pendingValue)
			appliedValue = val
			if st.convar and GetConVar(st.convar) then
				RunConsoleCommand(st.convar, tostring(val))
			elseif st.command then
				RunConsoleCommand(st.command, tostring(val))
			end
			if st.func then pcall(st.func, val) end
			valBox:SetText(string.format("%."..(st.decimals or 2).."f", val))
			applyBtn:SetVisible(false)
			UVMenu.PlaySFX("confirm")
		end

		valBox:SetText(string.format("%."..slider:GetDecimals().."f", appliedValue))
		slider:SetValue(appliedValue)

		local typing = false

		valBox.OnGetFocus = function()
			typing = true
			if IsValid(UV.SettingsFrame) then
				UV.SettingsFrame:SetKeyboardInputEnabled(true)
			end
		end

		valBox.OnLoseFocus = function()
			typing = false
			if IsValid(UV.SettingsFrame) then
				UV.SettingsFrame:SetKeyboardInputEnabled(false)
			end
		end

		slider.OnValueChanged = function(_, val)
			pendingValue = val
			applyBtn:SetVisible(math.abs(pendingValue - appliedValue) > 0)

			if not typing and IsValid(valBox) then
				valBox:SetText(string.format("%."..slider:GetDecimals().."f", val))
			end
		end

		valBox.OnEnter = function(self2)
			local v = tonumber(self2:GetValue()) or st.max
			if st.min then v = math.max(st.min, v) end
			if st.max then v = math.min(st.max, v) end

			pendingValue = v
			slider:SetValue(v)
			ApplyPendingValue()
		end

		valBox.OnTextChanged = function(self2)
			local v = tonumber(self2:GetValue())
			if not v then return end
			pendingValue = v
			slider:SetValue(v)
			applyBtn:SetVisible(math.abs(pendingValue - appliedValue) > 0)
		end

		applyBtn.DoClick = function()
			local v = tonumber(valBox:GetValue()) or st.max
			if st.min then v = math.max(st.min, v) end
			if st.max then v = math.min(st.max, v) end

			pendingValue = v
			slider:SetValue(v)
			ApplyPendingValue()
		end

		if st.convar then
			local cv = GetConVar(st.convar)
			if cv then
				appliedValue = cv:GetFloat()
				pendingValue = appliedValue
				slider:SetValue(appliedValue)
				valBox:SetText(string.format("%."..slider:GetDecimals().."f", appliedValue))
			end
		end

		wrap.OnMousePressed = function(self, mc)
			if mc == MOUSE_MIDDLE and st.convar then
				local cv = GetConVar(st.convar)
				if cv then
					local def = tonumber(cv:GetDefault()) or st.min or 0
					slider:SetValue(def)
					valBox:SetText(tostring(def))
					pendingValue = def
					applyBtn:SetVisible(math.abs(pendingValue - appliedValue) > 0)
				end
			end
		end

		return wrap
	end

	---- combo: label left, dropdown right ----
	if st.type == "combo" then
		local wrap = vgui.Create("DPanel", parent)
		wrap:Dock(TOP)
		wrap:DockMargin(6, 4, 6, 4)
		wrap:SetTall(30)
		wrap.Paint = function(self, w, h)
			local hovered = self:IsHovered()
			local bga = hovered and 200 or 125
			local bg = Color( 125, 125, 125, 0 )
			
			if enabled then
				bg = Color( 58, 193, 0, bga )
			end
			
			draw.RoundedBox(6, 0, 0, w, h, bg)
			draw.SimpleText(GetDisplayText(), "UVMostWantedLeaderboardFont", 10, h/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end

		wrap.OnCursorEntered = function()
			if descPanel then
				descPanel.Text = st.text
				descPanel.Desc = st.desc or ""
				if st.convar then
					descPanel.SelectedDefault = GetConVar(st.convar):GetDefault() or "?"
					descPanel.SelectedConVar = st.convar or "?"
				end
			end
		end

		wrap.OnCursorExited = function()
			if descPanel then
				descPanel.Text = ""
				descPanel.Desc = ""
				if st.convar then
					descPanel.SelectedDefault = ""
					descPanel.SelectedConVar = ""
				end
			end
		end

		local combo = vgui.Create("DComboBox", wrap)
		combo:Dock(RIGHT)
		combo:SetWide(220)
		combo:DockMargin(6, 6, 6, 6)

		-- Add choices first
		for _, entry in ipairs(st.content or {}) do
			combo:AddChoice(entry[1], entry[2])
		end

		-- Set selected value based on convar
		if st.convar then
			local cv = GetConVar(st.convar)
			if cv then
				local cur = cv:GetString()
				local found = false
				for _, v in ipairs(st.content or {}) do
					if tostring(v[2]) == tostring(cur) then
						combo:SetText(v[1])
						found = true
						break
					end
				end
				if not found then
					combo:SetText(st.text)
				end
			end
		else
			combo:SetText(st.text)
		end

		combo.OnSelect = function(_, _, val, data)
			if st.convar then
				RunConsoleCommand(st.convar, tostring(data))
				combo:SetText(val)
			end
			if st.func then st.func(combo) end
		end

		combo.OnCursorEntered = function()
			if descPanel then
				descPanel.Text = st.text
				descPanel.Desc = st.desc or ""
				if st.convar then
					descPanel.SelectedDefault = GetConVar(st.convar):GetDefault() or "?"
					descPanel.SelectedConVar = st.convar or "?"
				end
			end
		end

		combo.OnCursorExited = function()
			if descPanel then
				descPanel.Text = ""
				descPanel.Desc = ""
				if st.convar then
					descPanel.SelectedDefault = ""
					descPanel.SelectedConVar = ""
				end
			end
		end
		
		wrap.OnMousePressed = function(self, mc)
			if mc == MOUSE_MIDDLE and st.convar then
				local cv = GetConVar(st.convar)
				if cv then
					local def = cv:GetDefault()

					-- find matching display text
					for _, v in ipairs(st.content or {}) do
						if tostring(v[2]) == tostring(def) then
							combo:SetText(v[1])
							UVMenu.PlaySFX("hover")
							break
						end
					end

					RunConsoleCommand(st.convar, def)
				end
			end
		end

		return wrap
	end

	---- button ----
	if st.type == "button" then
		local btn = vgui.Create("DButton", parent)
		btn:Dock(TOP)
		btn:DockMargin(6, 6, 6, 6)
		btn:SetTall(30)
		btn:SetText("")
		btn.Paint = function(self, w, h)
			local hovered = self:IsHovered()
			local default = Color( 
				GetConVar("uvmenu_col_button_r"):GetInt(),
				GetConVar("uvmenu_col_button_g"):GetInt(),
				GetConVar("uvmenu_col_button_b"):GetInt(),
				GetConVar("uvmenu_col_button_a"):GetInt()
				)
			local hover = Color( 
				GetConVar("uvmenu_col_button_hover_r"):GetInt(),
				GetConVar("uvmenu_col_button_hover_g"):GetInt(),
				GetConVar("uvmenu_col_button_hover_b"):GetInt(),
				GetConVar("uvmenu_col_button_hover_a"):GetInt() * math.abs(math.sin(RealTime()*4))
				)

			-- background & text
			draw.RoundedBox(12, w*0.1, 0, w*0.8, h, default)
			if hovered then draw.RoundedBox(12, w*0.1, 0, w*0.8, h, hover) end
			draw.SimpleText(GetDisplayText(), "UVMostWantedLeaderboardFont", w*0.5, h*0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		
		btn.DoClick = function(self)
			if st.playsfx then UVMenu.PlaySFX(st.playsfx) end
			if st.func then st.func(self) end
			if st.convar and not st.func then
				RunConsoleCommand(st.convar)
			end
		end
		btn.OnCursorEntered = function()
			if descPanel then
				descPanel.Text = st.text
				descPanel.Desc = st.desc or ""
				if st.convar then
					-- descPanel.SelectedDefault = GetConVar(st.convar):GetDefault() or "?"
					descPanel.SelectedDefault = ""
					descPanel.SelectedConVar = st.convar or "?"
				end
			end
		end
		btn.OnCursorExited = function()
			if descPanel then
				descPanel.Text = ""
				descPanel.Desc = ""
				if st.convar then
					descPanel.SelectedDefault = ""
					descPanel.SelectedConVar = ""
				end
			end
		end

		return btn
	end

	---- button with scroll wheel functionality ----
	if st.type == "buttonsw" then
		local val = st.start or st.min or 1
		local min = st.min or 0
		local max = st.max or 10

		local btn = vgui.Create("DButton", parent)
		btn:Dock(TOP)
		btn:DockMargin(6, 6, 6, 6)
		btn:SetTall(30)
		btn:SetText("")

		btn.Paint = function(self, w, h)
			local hovered = self:IsHovered()
			local default = Color( 
				GetConVar("uvmenu_col_button_r"):GetInt(),
				GetConVar("uvmenu_col_button_g"):GetInt(),
				GetConVar("uvmenu_col_button_b"):GetInt(),
				GetConVar("uvmenu_col_button_a"):GetInt()
				)
			local hover = Color( 
				GetConVar("uvmenu_col_button_hover_r"):GetInt(),
				GetConVar("uvmenu_col_button_hover_g"):GetInt(),
				GetConVar("uvmenu_col_button_hover_b"):GetInt(),
				GetConVar("uvmenu_col_button_hover_a"):GetInt() * math.abs(math.sin(RealTime()*4))
				)

			draw.RoundedBox(12, w*0.1, 0, w*0.8, h, default)
			if hovered then draw.RoundedBox(12, w*0.1, 0, w*0.8, h, hover) end

			local display = language.GetPhrase(st.text)
			if st.text:find("%%s") then
				display = string.format(GetDisplayText(), val)
			end

			draw.SimpleText(display, "UVMostWantedLeaderboardFont",
				w*0.5, h*0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		-- Adjust value with mouse wheel
		btn.OnMouseWheeled = function(self, delta)
			val = math.Clamp(val + delta, min, max)
			return true
		end

		btn.DoClick = function(self)
			if st.func then st.func(self, val) end
		end

		btn.OnCursorEntered = function()
			if descPanel then
				descPanel.Text = st.text
				descPanel.Desc = st.desc or ""
				if st.convar then
					-- descPanel.SelectedDefault = GetConVar(st.convar):GetDefault() or "?"
					descPanel.SelectedDefault = ""
					descPanel.SelectedConVar = st.convar or "?"
				end
			end
		end

		btn.OnCursorExited = function()
			if descPanel then
				descPanel.Text = ""
				descPanel.Desc = ""
				if st.convar then
					descPanel.SelectedDefault = ""
					descPanel.SelectedConVar = ""
				end
			end
		end

		return btn
	end

	---- color remains as basic DColorMixer or DColorButton (user requested keep as-is) ----
	if st.type == "color" or st.type == "coloralpha" then
		local p = vgui.Create("DPanel", parent)
		p:Dock(TOP)
		p:DockMargin(6, 4, 6, 4)
		p:SetTall(120)

		-- Check for existence of color convars
		local base = st.convar
		local cv_r = GetConVar(base .. "_r")
		local cv_g = GetConVar(base .. "_g")
		local cv_b = GetConVar(base .. "_b")
		local cv_a = GetConVar(base .. "_a") -- optional
		local invalidtext = " "

		if not cv_r or not cv_g or not cv_b then
			invalidtext = "INVALID COL. CONVAR"
		end
		
		p.Paint = function(self, w, h)
			draw.SimpleText(GetDisplayText(), "UVMostWantedLeaderboardFont", 0, h/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			
			draw.SimpleText(invalidtext, "UVMostWantedLeaderboardFont", w * 0.99, h/2, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		end

		local allowAlpha = st.type == "coloralpha" and cv_a ~= nil

		-- Initial color
		local initial = Color(cv_r:GetInt(), cv_g:GetInt(), cv_b:GetInt(), allowAlpha and cv_a:GetInt() or 255)

		local mixer = vgui.Create("DColorMixer", p)
		mixer:Dock(RIGHT)
		mixer:SetWide(240)
		mixer:DockMargin(6, 6, 6, 6)
		mixer:SetColor(initial)
		mixer:SetPalette(false)
		mixer:SetAlphaBar(allowAlpha)
		mixer:SetWangs(true)
		mixer:SetConVarR(base .. "_r")
		mixer:SetConVarG(base .. "_g")
		mixer:SetConVarB(base .. "_b")
		if allowAlpha then
			mixer:SetConVarA(base .. "_a")
		end

		p.OnCursorEntered = function()
			-- UVMenu.PlaySFX("hover")
			if descPanel then
				descPanel.Text = st.text
				descPanel.Desc = st.desc or ""
				if st.convar then
					descPanel.SelectedConVar = st.convar .. "_r/" .. "_g/" .. "_b/" .. (allowAlpha and "_a/" or "")
					descPanel.SelectedDefault = cv_r:GetDefault() .. ", " .. cv_g:GetDefault() .. ", " .. cv_b:GetDefault() .. (allowAlpha and ", " .. cv_r:GetDefault() or "")
				end
			end
		end

		p.OnCursorExited = function()
			if descPanel then
				descPanel.Text = ""
				descPanel.Desc = ""
				if st.convar then
					descPanel.SelectedConVar = ""
					descPanel.SelectedDefault = ""
				end
			end
		end

		mixer.OnCursorEntered = function()
			if descPanel then
				descPanel.Text = st.text
				descPanel.Desc = st.desc or ""
				if st.convar then
					descPanel.SelectedConVar = st.convar .. "_r/" .. "_g/" .. "_b/" .. (allowAlpha and "_a/" or "")
					
					-- descPanel.SelectedDefault = GetConVar(st.convar):GetDefault()
				end
			end
		end

		mixer.OnCursorExited = function()
			if descPanel then
				descPanel.Text = ""
				descPanel.Desc = ""
				if st.convar then
					descPanel.SelectedConVar = st.convar or "?"
					descPanel.SelectedDefault = ""
				end
			end
		end
		
		p.OnMousePressed = function(self, mc)
			if mc == MOUSE_MIDDLE then
				if cv_r and cv_g and cv_b then
					local r = tonumber(cv_r:GetDefault())
					local g = tonumber(cv_g:GetDefault())
					local b = tonumber(cv_b:GetDefault())
					local a = cv_a and tonumber(cv_a:GetDefault()) or 255
					
					mixer:SetColor(Color(r, g, b, a))

					-- Push to convars
					RunConsoleCommand(base .. "_r", r)
					RunConsoleCommand(base .. "_g", g)
					RunConsoleCommand(base .. "_b", b)
					if cv_a then RunConsoleCommand(base .. "_a", a) end

					UVMenu.PlaySFX("hover")
				end
			end
		end

		return p
	end

	---- keybind button ----
	-- if st.type == "keybind" then
		-- local wrap = vgui.Create("DButton", parent)
		-- wrap:Dock(TOP)
		-- wrap:DockMargin(6, 4, 6, 4)
		-- wrap:SetTall(30)
		-- wrap:SetText("")
		-- wrap:SetCursor("hand")
		-- wrap:SetKeyboardInputEnabled(true)
		-- wrap:SetMouseInputEnabled(true)

		-- local data = KeybindManager.keybinds[st.slot]
		-- local cv = GetConVar(data.convar)
		-- wrap.DisplayText = cv and string.upper(input.GetKeyName(cv:GetInt()) or "NONE") or "NONE"

		-- KeyBindButtons[st.slot] = { data.convar, wrap }

		-- wrap.Paint = function(self, w, h)
			-- local hovered = self:IsHovered()
			-- local bga = hovered and 200 * math.abs(math.sin(RealTime()*4)) or 125
			-- local bg = Color(125, 125, 125, bga)

			-- draw.RoundedBox(6, w*0.955, 0, w*0.045, h, bg)
			-- draw.SimpleText(st.text, "UVMostWantedLeaderboardFont", 10, h/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			-- draw.SimpleText(self.DisplayText, "UVMostWantedLeaderboardFont", w - 10, h/2, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		-- end

		-- wrap.OnCursorEntered = function()
			-- if descPanel then
				-- descPanel.Text = st.text
				-- descPanel.Desc = st.desc or ""
			-- end
		-- end
		-- wrap.OnCursorExited = function()
			-- if descPanel then
				-- descPanel.Text = ""
				-- descPanel.Desc = ""
			-- end
		-- end

		-- wrap.DoClick = function()
			-- if KeybindManager.waitingForInput then return end
			-- KeybindManager.waitingForInput = st.slot
			-- wrap.DisplayText = "PRESS ANY BUTTON"
			-- wrap:MakePopup()
		-- end

		-- wrap.OnKeyCodePressed = function(self, key)
			-- if KeybindManager.waitingForInput ~= st.slot then return end
			-- self.DisplayText = string.upper(input.GetKeyName(key))
			-- net.Start("UVPTKeybindRequest")
			-- net.WriteInt(st.slot, 16)
			-- net.WriteInt(key, 16)
			-- net.SendToServer()
			-- KeybindManager.waitingForInput = false
		-- end

		-- wrap.OnMousePressed = function(self, mouseCode)
			-- if KeybindManager.waitingForInput ~= st.slot then return end
			-- self.DisplayText = string.upper(input.GetKeyName(mouseCode))
			-- net.Start("UVPTKeybindRequest")
			-- net.WriteInt(st.slot, 16)
			-- net.WriteInt(mouseCode, 16)
			-- net.SendToServer()
			-- KeybindManager.waitingForInput = false
		-- end

		-- return wrap
	-- end

	-- fallback: do nothing
	return nil
end

UV_WrapCache = UV_WrapCache or {}

function UV_WrapText(text, font, maxwidth)
	local cacheKey = font .. "|" .. tostring(maxwidth) .. "|" .. text

	-- return cached result if it exists
	local cached = UV_WrapCache[cacheKey]
	if cached then
		return cached
	end

	-- compute wrapped lines
	surface.SetFont(font)

	local lines = {}
	local curline = ""

	local words = string.Explode(" ", text)

	local function utf8_chars(str)
		return string.gmatch(str, "[%z\1-\127\194-\244][\128-\191]*")
	end

	for _, word in ipairs(words) do
		local test = (curline == "" and word) or (curline .. " " .. word)
		local w = surface.GetTextSize(test)

		if w > maxwidth then
			if surface.GetTextSize(word) > maxwidth then
				for char in utf8_chars(word) do
					local test2 = curline .. char
					if surface.GetTextSize(test2) > maxwidth then
						if curline ~= "" then
							table.insert(lines, curline)
						end
						curline = char
					else
						curline = test2
					end
				end
			else
				if curline ~= "" then
					table.insert(lines, curline)
				end
				curline = word
			end
		else
			curline = test
		end
	end

	if curline ~= "" then
		table.insert(lines, curline)
	end

	-- store result
	UV_WrapCache[cacheKey] = lines
	return lines
end

-- Plays Sound SFX for the menu
function UVMenu.PlaySFX(name, overrideSet)
    if not GetConVar("uvmenu_sound_enabled"):GetBool() then return end
    name = tostring(name or "")
    local setName = overrideSet or GetConVar("uvmenu_sound_set"):GetString() or "MW"
    local setTbl = UVMenu.Sounds[setName] or UVMenu.Sounds["MW"]
    if not setTbl then return end
    local snd = setTbl[name]
    if not snd or snd == "" then return end
	
    surface.PlaySound(snd)
end

-- Helper to open menus safely
function UVMenu.OpenMenu(menuFunc, dontsave)
    if not dontsave and menuFunc then
        UVMenu.LastMenu = menuFunc
    end

    if UVMenu.CurrentMenu and IsValid(UVMenu.CurrentMenu) then
        -- Close current menu first
        UVMenu.CloseCurrentMenu(true)
        -- Delay opening new menu to allow closing animation to start
        timer.Simple(tonumber(GetConVar("uvmenu_close_speed"):GetString()) or 0.2, function()
            if menuFunc then
                menuFunc()
                -- Update CurrentMenu to the newly created frame
                UVMenu.CurrentMenu = UV.SettingsFrame
				UVMenu.PlaySFX("menuopen")
            end
        end)
        return
    end

    -- Open menu immediately if nothing is open
    if menuFunc then
        menuFunc()
        UVMenu.CurrentMenu = UV.SettingsFrame
    end
end

-- Close the currently open menu with animation
function UVMenu.CloseCurrentMenu(noCloseSound)
    local frame = UVMenu.CurrentMenu or UV.SettingsFrame
    if not IsValid(frame) or frame._closing then return end

    -- Play close sound unless explicitly disabled OR convars disallow
    if not noCloseSound and GetConVar("uvmenu_sound_enabled"):GetBool() then UVMenu.PlaySFX("menuclose") end

    frame._closing = true
    frame._closeStart = CurTime()

    local closeSpeed = tonumber(GetConVar("uvmenu_close_speed"):GetString()) or 0.2
    frame._closeFadeDur = closeSpeed * 0.5
    frame._closeShrinkDur = closeSpeed
    frame._closeShrinkStart = frame._closeStart + frame._closeFadeDur * 0.5

    UVMenu.CurrentMenu = nil
end

-- Opens a UVMenu menu
function UVMenu:Open(menu)
    local CurrentMenu = menu or {}
    local Name = CurrentMenu.Name or "#uv.unitvehicles"
    local Width = CurrentMenu.Width or math.max(800, ScrW() * 0.9)
    local Height = CurrentMenu.Height or math.max(480, ScrH() * 0.66)
    local ShowDesc = CurrentMenu.Description == true and not GetConVar("uvmenu_hide_description"):GetBool()
    local Tabs = CurrentMenu.Tabs or {}
    local UnfocusClose = CurrentMenu.UnfocusClose == true
	local ShowCPreview = CurrentMenu.ColorPreview == true
	
	if CurrentMenu.Description == true and GetConVar("uvmenu_hide_description"):GetBool() then
		Width = Width * 0.75
	end

    if IsValid(UV.SettingsFrame) then UV.SettingsFrame:Remove() end
    gui.EnableScreenClicker(true)

    local sw, sh = ScrW(), ScrH()
    local fw, fh = Width, Height
    local fx, fy = (sw - fw) * 0.5, (sh - fh) * 0.5
    local watchedConvars = {}

    local frame = vgui.Create("DFrame")
    UV.SettingsFrame = frame
    frame:SetSize(0, 0)
    frame:SetPos(fx + fw * 0.5, fy + fh * 0.5)
    frame:SetTitle("")
    frame:ShowCloseButton(false)
    frame:SetDraggable(false)
    frame:MakePopup()
    frame:SetKeyboardInputEnabled(false)
	
	frame.Tabs = CurrentMenu.Tabs or {}

    frame.TargetWidth = fw
    frame.TargetHeight = fh

    local animStart = CurTime()
    local animDur = tonumber(GetConVar("uvmenu_open_speed"):GetString()) or 0.2
    local primaryFadeStart = animStart + animDur * 0.5
    local primaryFadeDur = animDur * 1.25
    local secondaryFadeStart = animStart + animDur * 0.5
    local secondaryFadeDur = animDur * 1.25

    frame._open_animStart = animStart
    frame._open_animDur = animDur
    frame._open_primaryFadeStart = primaryFadeStart
    frame._open_primaryFadeEnd = primaryFadeStart + primaryFadeDur
    frame._open_secondaryFadeStart = secondaryFadeStart
    frame._open_secondaryFadeEnd = secondaryFadeStart + secondaryFadeDur
    frame._closing = false

    frame.TitleAlpha = 0

    -- Right description panel
    local descPanel
    if ShowDesc then
        descPanel = vgui.Create("DPanel", frame)
        descPanel:Dock(RIGHT)
        descPanel:SetWide(math.Clamp(fw * 0.25, 220, 380))
        descPanel.Paint = function(self, w, h)
            local a = self:GetAlpha()
            surface.SetDrawColor( GetConVar("uvmenu_col_desc_r"):GetInt(), GetConVar("uvmenu_col_desc_g"):GetInt(), GetConVar("uvmenu_col_desc_b"):GetInt(), math.floor(GetConVar("uvmenu_col_desc_a"):GetInt() * (a / 255)) )
            surface.DrawRect(0, 0, w, h)

            if self.Text and a > 5 then
                local font = "UVMostWantedLeaderboardFont2"
                local color = Color(255, 255, 255, a)
                local xPadding, yPadding = 10, 10
                local wrapWidth = w - xPadding * 2
                local yOffset = yPadding

                surface.SetFont(font)
                local desc = language.GetPhrase(self.Desc or "") or ""

                local paragraphs = string.Split(desc, "\n")
                for _, paragraph in ipairs(paragraphs) do
                    if paragraph == "" then
                        local _, th = surface.GetTextSize("A")
                        yOffset = yOffset + th
                    else
                        local wrapped = UV_WrapText(paragraph, font, wrapWidth)
                        for _, line in ipairs(wrapped) do
                            draw.DrawText(line, font, xPadding, yOffset, color, TEXT_ALIGN_LEFT)
                            local _, th = surface.GetTextSize(line)
                            yOffset = yOffset + th
                        end
                    end
                end
            end
			if self.SelectedConVar then
				draw.SimpleText(self.SelectedConVar, "UVMostWantedLeaderboardFont2", 10, h * 0.98 - 20, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end
			if self.SelectedDefault and self.SelectedDefault ~= ""then
				draw.SimpleText("Default: " .. self.SelectedDefault, "UVMostWantedLeaderboardFont2", 10, h * 0.98, Color(175, 175, 175, a), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end
			
        end
        descPanel.Text = ""
        descPanel.Desc = ""
        descPanel.SelectedConVar = ""
        descPanel.SelectedDefault = ""
        descPanel:SetAlpha(0)
    end

    -- Right description panel
    local colpreviewPanel
    if ShowCPreview then
        colpreviewPanel = vgui.Create("DPanel", frame)
        colpreviewPanel:Dock(RIGHT)
        colpreviewPanel:SetWide(math.Clamp(fw * 0.5, 220, 570))
        colpreviewPanel.Paint = function(self, w, h)
			-- Background
			local bg = Color( GetConVar("uvmenu_col_bg_r"):GetInt(), GetConVar("uvmenu_col_bg_g"):GetInt(), GetConVar("uvmenu_col_bg_b"):GetInt(), GetConVar("uvmenu_col_bg_a"):GetInt() )
			draw.RoundedBox(0, 0, 0, w, h * 0.5, bg)
						
			draw.SimpleText("#uv.unitvehicles", "UVMostWantedLeaderboardFont2", w * 0.005, h * 0.01, titleColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			
			-- Tabs
			surface.SetDrawColor(
				GetConVar("uvmenu_col_tabs_r"):GetInt(),
				GetConVar("uvmenu_col_tabs_g"):GetInt(),
				GetConVar("uvmenu_col_tabs_b"):GetInt(),
				GetConVar("uvmenu_col_tabs_a"):GetInt()
			)
			surface.DrawRect(0, h*0.025, w*0.25, h*0.475)
			
			local default = Color( GetConVar("uvmenu_col_tab_default_r"):GetInt(), GetConVar("uvmenu_col_tab_default_g"):GetInt(), GetConVar("uvmenu_col_tab_default_b"):GetInt(), 75 )
			local active = Color( GetConVar("uvmenu_col_tab_active_r"):GetInt(), GetConVar("uvmenu_col_tab_active_g"):GetInt(), GetConVar("uvmenu_col_tab_active_b"):GetInt(), 75 )
			local hover = Color( GetConVar("uvmenu_col_tab_hover_r"):GetInt(), GetConVar("uvmenu_col_tab_hover_g"):GetInt(), GetConVar("uvmenu_col_tab_hover_b"):GetInt(), 175 )

			local bg = isSelected and active or (hovered and hover or default)

			draw.RoundedBox(5, w*0.01, h * 0.03, w * 0.225, 16, default)
			draw.SimpleText("Tab", "UVMostWantedLeaderboardFont2", w * 0.01, h*0.04, Color(255, 255, 255, self:GetAlpha()), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

			draw.RoundedBox(5, w*0.01, h * 0.06, w * 0.225, 16, hover)
			draw.SimpleText("Tab (Hover)", "UVMostWantedLeaderboardFont2", w * 0.01, h*0.07, Color(255, 255, 255, self:GetAlpha()), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

			draw.RoundedBox(5, w*0.01, h * 0.09, w * 0.225, 16, active)
			draw.SimpleText("Tab (Active)", "UVMostWantedLeaderboardFont2", w * 0.01, h*0.1, Color(255, 255, 255, self:GetAlpha()), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

			-- Center Part
			
			draw.SimpleText("Tab", "UVMostWantedLeaderboardFont", w * 0.5, h*0.035, Color(255, 255, 255, self:GetAlpha()), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			-- Labels
			surface.SetDrawColor(
				GetConVar("uvmenu_col_label_r"):GetInt(),
				GetConVar("uvmenu_col_label_g"):GetInt(),
				GetConVar("uvmenu_col_label_b"):GetInt(),
				GetConVar("uvmenu_col_label_a"):GetInt()
			)
			surface.DrawRect(0, h*0.025, w*0.25, h*0.475)
			
        end
		colpreviewPanel:SetAlpha(0)
    end

    -- Center scroll panel
    local center = vgui.Create("DScrollPanel", frame)
    center:Dock(FILL)
    center:DockMargin(8, 8, 8, 8)
    center:SetAlpha(0)

    -- Left tabs panel (only if >1 tab)
    local tabsPanel
    if #Tabs > 1 then
        tabsPanel = vgui.Create("DPanel", frame)
        tabsPanel:Dock(LEFT)
        tabsPanel:SetWide(ScrW()*0.15)
        tabsPanel.Paint = function(self, w, h)
			surface.SetDrawColor(
				GetConVar("uvmenu_col_tabs_r"):GetInt(),
				GetConVar("uvmenu_col_tabs_g"):GetInt(),
				GetConVar("uvmenu_col_tabs_b"):GetInt(),
				GetConVar("uvmenu_col_tabs_a"):GetInt()
			)
			surface.DrawRect(0, 0, w, h)
		end
        tabsPanel:SetAlpha(0)
    end

    local closeBtn = vgui.Create("DButton", frame)
    closeBtn:SetSize(20, 20)
    closeBtn:SetText("")
    closeBtn:SetFont("DermaDefaultBold")
    closeBtn.DoClick = function()
        UVMenu.CloseCurrentMenu()
    end
    closeBtn.Paint = function(self, w, h)
        local hovered = self:IsHovered()
        local bg = hovered and Color(200, 60, 60, self:GetAlpha()) or Color(140, 50, 50, self:GetAlpha())
        draw.RoundedBox(4, 0, 0, w, h, bg)
        draw.SimpleText("X", "DermaDefaultBold", w / 2, h / 2, Color(255, 255, 255, self:GetAlpha()), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    closeBtn:SetAlpha(0)

    local primaryGroup = {closeBtn}
    local secondaryGroup = {center}
    if tabsPanel then table.insert(secondaryGroup, tabsPanel) end
    if descPanel then table.insert(secondaryGroup, descPanel) end
    if colpreviewPanel then table.insert(secondaryGroup, colpreviewPanel) end

    local CURRENT_TAB = 1

    -- Build tab content
    local function BuildTab(tabIndex)
        center.CurrentTabIndex = tabIndex
        center:Clear()
        if descPanel then
            descPanel.Text = ""
            descPanel.Desc = ""
        end

        local tab = Tabs[tabIndex]
        if not tab then return end

        local title = vgui.Create("DLabel", center)
        title:SetText("")
        title:Dock(TOP)
        title:DockMargin(6, 6, 6, 12)
        title:SetTall(24)

        title.Paint = function(self, w, h)
            draw.SimpleText(tab.TabName or ("Tab " .. tostring(tabIndex)), "UVFont5UI", w * 0.5, h * 0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        watchedConvars = {} -- reset
        for k2, entry in ipairs(tab) do
            if istable(entry) and entry.type then
                if entry.parentconvar then watchedConvars[entry.parentconvar] = true end
                if entry.requireparentconvar then watchedConvars[entry.requireparentconvar] = true end
            end
        end

        for k2, entry in ipairs(tab) do
            if istable(entry) and entry.type then
                local pnl = UV.BuildSetting(center, entry, descPanel)
                if IsValid(pnl) then
                    pnl:SetVisible(UV.ShouldDrawSetting(entry))
                    pnl:SetAlpha(0)
                end
            end
        end
    end

    local lastValues = {}

    local function SetGroupAlpha(group, a)
        for _, pnl in ipairs(group) do
            if IsValid(pnl) and pnl.SetAlpha then pnl:SetAlpha(a) end
        end
    end

    local function SetCenterChildrenAlpha(a)
        for _, child in ipairs(center:GetChildren()) do
            if IsValid(child) and child.SetAlpha then
                child:SetAlpha(a)
            end
        end
    end

    local function SetAlphaRecursive(panel, a)
        if not IsValid(panel) then return end
        if panel.SetAlpha then panel:SetAlpha(a) end
        for _, child in ipairs(panel:GetChildren()) do
            SetAlphaRecursive(child, a)
        end
    end

    frame.Think = function(self)
        if not self._closing then
            local elapsed = CurTime() - self._open_animStart
            local p = math.Clamp(elapsed / self._open_animDur, 0, 1)

            local w = Lerp(p, 0, self.TargetWidth)
            local h = Lerp(p, 0, self.TargetHeight)
            local x = fx + (fw * 0.5) - (w * 0.5)
            local y = fy + (fh * 0.5) - (h * 0.5)
            self:SetSize(w, h)
            self:SetPos(x, y)

            closeBtn:SetPos(math.max(self:GetWide() - 24, 8), 4)

            local primaryA = 0
            if CurTime() >= self._open_primaryFadeStart then
                primaryA = math.Clamp((CurTime() - self._open_primaryFadeStart) / (self._open_primaryFadeEnd - self._open_primaryFadeStart), 0, 1) * 255
            end
            self.TitleAlpha = primaryA
            SetGroupAlpha(primaryGroup, primaryA)

            local secondaryA = 0
            if CurTime() >= self._open_secondaryFadeStart then
                secondaryA = math.Clamp((CurTime() - self._open_secondaryFadeStart) / (self._open_secondaryFadeEnd - self._open_secondaryFadeStart), 0, 1) * 255
            end
            SetGroupAlpha(secondaryGroup, secondaryA)
            SetAlphaRecursive(center, secondaryA)

            -- unfocus auto-close
            if UnfocusClose and input.IsMouseDown(MOUSE_LEFT) then
                local mx, my = gui.MousePos()
                if mx and my then
                    local fx2, fy2 = self:GetPos()
                    local fw2, fh2 = self:GetSize()
                    if mx < fx2 or mx > fx2 + fw2 or my < fy2 or my > fy2 + fh2 then
                        timer.Simple(0, function()
                            if IsValid(self) then UVMenu.CloseCurrentMenu() end
                        end)
                    end
                end
            end

            local shouldRefresh = false
            for cvName in pairs(watchedConvars) do
                local cv = GetConVar(cvName)
                if cv then
                    local val = cv:GetBool()
                    if lastValues[cvName] ~= val then
                        lastValues[cvName] = val
                        shouldRefresh = true
                    end
                end
            end

            if shouldRefresh then
                BuildTab(center.CurrentTabIndex)
            end
        else
            local now = CurTime()
            local fadeStart = self._closeStart
            local fadeEnd = fadeStart + self._closeFadeDur
            local shrinkStart = self._closeShrinkStart
            local shrinkEnd = shrinkStart + self._closeShrinkDur

            local fadeT = 0
            if now <= fadeStart then
                fadeT = 0
            elseif now >= fadeEnd then
                fadeT = 1
            else
                fadeT = (now - fadeStart) / (fadeEnd - fadeStart)
            end
            local invFade = 1 - fadeT
            local fadeA = math.floor(invFade * 255)

            self.TitleAlpha = fadeA
            SetGroupAlpha(primaryGroup, fadeA)
            SetGroupAlpha(secondaryGroup, fadeA)
            SetCenterChildrenAlpha(fadeA)

            local shrinkT = 0
            if now <= shrinkStart then
                shrinkT = 0
            elseif now >= shrinkEnd then
                shrinkT = 1
            else
                shrinkT = (now - shrinkStart) / (shrinkEnd - shrinkStart)
            end
            local w = Lerp(shrinkT, self.TargetWidth, 0)
            local h = Lerp(shrinkT, self.TargetHeight, 0)
            local x = fx + (fw * 0.5) - (w * 0.5)
            local y = fy + (fh * 0.5) - (h * 0.5)
            self:SetSize(w, h)
            self:SetPos(x, y)

            if now >= math.max(fadeEnd, shrinkEnd) then
                if IsValid(self) then
                    self:Remove()
                end
                gui.EnableScreenClicker(false)
                UV.SettingsFrame = nil
            end
        end
    end

    frame.Paint = function(self, w, h)
		local bg = Color( GetConVar("uvmenu_col_bg_r"):GetInt(), GetConVar("uvmenu_col_bg_g"):GetInt(), GetConVar("uvmenu_col_bg_b"):GetInt(), GetConVar("uvmenu_col_bg_a"):GetInt() )
		draw.RoundedBox(0, 0, 0, w, h, bg)

        local titleColor = Color(255, 255, 255, math.Clamp(math.floor(self.TitleAlpha), 0, 255))
        draw.SimpleText(Name, "UVMostWantedLeaderboardFont", w * 0.01, h * 0.02, titleColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    -- Build tabs if more than 1
    local TAB_START_OFFSET = 15
    local TAB_BUTTON_HEIGHT = 64
    local TAB_BUTTON_PADDING = 0
    local TAB_SIDE_PADDING = 6
    local TAB_CORNER_RADIUS = 4

    if tabsPanel then
        tabsPanel:DockPadding(0, TAB_START_OFFSET, 0, 0)
		local uv_tab_hover_last = uv_tab_hover_last or 0
        for i, tab in ipairs(Tabs) do
            if not UV.PlayerCanSeeSetting(tab) then continue end

            local btn = vgui.Create("DButton", tabsPanel)
            btn:Dock(TOP)
            btn:DockMargin(0, 0, 0, TAB_BUTTON_PADDING)
            btn:SetTall(TAB_BUTTON_HEIGHT)
            btn:SetText("")

            btn.Paint = function(self, w, h)
				local a = self:GetAlpha()
				local isSelected = (CURRENT_TAB == i)
				local hovered = self:IsHovered()

				local pulse = math.abs(math.sin(RealTime() * 4))

				local baseAlpha  = 75
				local hoverAlpha = 175 * pulse

				local default = Color(
					GetConVar("uvmenu_col_tab_default_r"):GetInt(),
					GetConVar("uvmenu_col_tab_default_g"):GetInt(),
					GetConVar("uvmenu_col_tab_default_b"):GetInt(),
					baseAlpha
				)

				local active = Color(
					GetConVar("uvmenu_col_tab_active_r"):GetInt(),
					GetConVar("uvmenu_col_tab_active_g"):GetInt(),
					GetConVar("uvmenu_col_tab_active_b"):GetInt(),
					baseAlpha
				)

				local hoverCol = Color(
					GetConVar("uvmenu_col_tab_hover_r"):GetInt(),
					GetConVar("uvmenu_col_tab_hover_g"):GetInt(),
					GetConVar("uvmenu_col_tab_hover_b"):GetInt(),
					hoverAlpha
				)
				local bg = isSelected and active or default

				draw.RoundedBox( TAB_CORNER_RADIUS, TAB_SIDE_PADDING, 4, w - TAB_SIDE_PADDING * 2, h - 8, bg )

				if hovered then
					draw.RoundedBox( TAB_CORNER_RADIUS, TAB_SIDE_PADDING, 4, w - TAB_SIDE_PADDING * 2, h - 8, hoverCol )
				end
				
				if a > 5 then
					local baseFont = "UVMostWantedLeaderboardFont"
					local multiFont = baseFont
					local desc = language.GetPhrase(tab.TabName) or "Tab"

					-- First, pre-wrap all text to count lines
					local paragraphs = string.Split(desc, "\n")
					local wrappedLines = {}

					for _, paragraph in ipairs(paragraphs) do
						if paragraph == "" then
							table.insert(wrappedLines, "")
						else
							local wrapped = UV_WrapText(paragraph, baseFont, w - (w * 0.15) * 2)
							for _, line in ipairs(wrapped) do
								table.insert(wrappedLines, line)
							end
						end
					end

					-- Total line count
					local lineCount = #wrappedLines

					-- Rule 3: If 3+ lines, switch font
					if lineCount >= 3 then
						multiFont = "UVMostWantedLeaderboardFont2"
					end

					surface.SetFont(multiFont)
					local _, lineHeight = surface.GetTextSize("A")

					local totalHeight = lineHeight * lineCount
					local centerY = h * 0.5
					local xPadding = w * 0.21

					-- Center vertically depending on line count
					local startY = centerY - (totalHeight / 2)

					local color = Color(255, 255, 255, a)

					-- Draw wrapped text
					local yOffset = startY
					for _, line in ipairs(wrappedLines) do
						draw.DrawText(line, multiFont, xPadding, yOffset, color, TEXT_ALIGN_LEFT)
						yOffset = yOffset + lineHeight
					end
				end

				
                if tab.Icon then
                    local mat = Material(tab.Icon, "smooth")
                    local iconSize = h * 0.75
                    local iconX = TAB_SIDE_PADDING + 2
                    local iconY = (h - iconSize) / 2
                    surface.SetDrawColor(255, 255, 255, self:GetAlpha())
                    surface.SetMaterial(mat)
                    surface.DrawTexturedRect(iconX, iconY, iconSize, iconSize)
                end
            end

			-- btn.OnCursorEntered = function(self)
				-- if not IsValid(self) then return end
				-- if not GetConVar("uvmenu_sound_enabled"):GetBool() then return end

				-- local now = CurTime()
				-- local key = tostring(self) -- unique-ish key per panel
				-- local last = uv_tab_hover_last or 0
				-- if now - last >= 0.025 then           -- 120ms debounce; tweak if needed
					-- uv_tab_hover_last = now
					-- UVMenu.PlaySFX("hovertab")
				-- end
			-- end

            btn.DoClick = function()
				if tab.playsfx then UVMenu.PlaySFX(tab.playsfx) end
				if tab.func then tab.func(self) return end
                CURRENT_TAB = i
                BuildTab(i)
                tabsPanel:InvalidateLayout(true)
            end

            if i == 1 then BuildTab(1) end
        end
    else
        -- Only 1 tab → just build that tab directly
        BuildTab(1)
    end

    frame.OnRemove = function()
        gui.EnableScreenClicker(false)
        if UV.SettingsFrame == frame then UV.SettingsFrame = nil end
    end
end