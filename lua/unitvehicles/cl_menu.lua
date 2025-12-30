UV = UV or {}
UVMenu = UVMenu or {}

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

-- AI Spawner helper
local function SpawnAI(amount, racestart, police)
	local beginrace = racestart or false
	local cv = police and "uv_spawnvehicles" or "uvrace_spawnai"
	
	for i = 1, amount do
		RunConsoleCommand(cv)
	end
	
	if beginrace then
		timer.Simple(0.5, function()
			RunConsoleCommand("uvrace_startinvite")
		end)

		timer.Simple(2, function()
			RunConsoleCommand("uvrace_startrace", GetConVar("uvracemanager_laps"):GetString())
		end)
	end
end

-- HUD Type helper
local function BuildHUDComboLists()
    local mainHUDs = {}
    local backupHUDs = {}
	
	print("[UV HUD] Registry contents:")
	PrintTable(UV.HUDRegistry)

    for _, hud in pairs(UV.HUDRegistry or {}) do
		table.insert(mainHUDs, {
			hud.name,       -- display text
			hud.codename    -- convar value
		})

        if hud.backup then
            table.insert(backupHUDs, {
                hud.name,
                hud.codename
            })
        end
    end

    table.sort(mainHUDs, function(a, b)
        return a[1] < b[1]
    end)

    table.sort(backupHUDs, function(a, b)
        return a[1] < b[1]
    end)

    return mainHUDs, backupHUDs
end

local mainHUDList, backupHUDList = BuildHUDComboLists()

------- [ Main Menu ]-------
UVMenu.Main = function()
	local mainHUDList, backupHUDList = BuildHUDComboLists()
	
	UVMenu.CurrentMenu = UVMenu:Open({
		Name = language.GetPhrase("uv.unitvehicles") .. " - " .. UV.CurVersion,
		Width  = UV.ScaleW(1540),
		Height = UV.ScaleH(760),
		Description = true,
		UnfocusClose = true,
		BindPanel = true,
		Tabs = {
		
			{ TabName = "#uv.menu.welcome", Icon = "unitvehicles/icons_settings/info.png", -- Welcome Page
				{ type = "label", text = "#uv.menu.quick", desc = "#uv.menu.quick.desc" },
				-- { type = "combo", text = "#uv.ui.main", desc = "uv.ui.main.desc", convar = "unitvehicle_hudtype_main", content = {
						-- { "Crash Time - Undercover", "ctu"} ,
						-- { "NFS Most Wanted", "mostwanted"} ,
						-- { "NFS Carbon", "carbon"} ,
						-- { "NFS Underground", "underground"} ,
						-- { "NFS Underground 2", "underground2"} ,
						-- { "NFS Undercover", "undercover"} ,
						-- { "NFS ProStreet", "prostreet"} ,
						-- { "NFS World", "world"} ,
						-- { "#uv.ui.original", "original"} ,
						-- { "#uv.ui.none", "" }
					-- },
				-- },
				{ type = "combo", text = "#uv.ui.main", desc = "uv.ui.main.desc", convar = "unitvehicle_hudtype_main", content = mainHUDList },
				{ type = "bool", text = "#uv.audio.uvtrax.enable", desc = "uv.audio.uvtrax.desc", convar = "unitvehicle_racingmusic" },
				{ type = "combo", text = "#uv.audio.uvtrax.profile", desc = "uv.audio.uvtrax.profile.desc", convar = "unitvehicle_racetheme", content = uvtraxcontent, requireparentconvar = "unitvehicle_racingmusic" },
				{ type = "button", text = "#uv.pm.spawnas", desc = "uv.pm.spawnas.desc", convar = "uv_spawn_as_unit", func = 
				function(self2)
					UVMenu.CloseCurrentMenu(true)
					UVMenu.PlaySFX("clickopen")
					timer.Simple(tonumber(GetConVar("uvmenu_close_speed"):GetString()) or 0.2, function()
						RunConsoleCommand("uv_spawn_as_unit")
					end)
				end
				},
				
				{ type = "label", text = "#uv.menu.pnotes" },
				{ type = "image", image = "unitvehicles/icons_settings/pnotes/" .. UV.CurVersion .. ".png" },
				{ type = "info", text = UV.PNotes, centered = true },
			},
			
			{ TabName = "#uv.rm", Icon = "unitvehicles/icons/race_events.png", sv = true, playsfx = "clickopen", func = function()
					UVMenu.OpenMenu(UVMenu.RaceManager) -- Race Manager
				end,
			},
			
			{ TabName = "#uv.pm", Icon = "unitvehicles/icons/milestone_911.png", -- Pursuit Manager
				{ type = "button", text = "#uv.pm.spawnas", desc = "uv.pm.spawnas.desc", convar = "uv_spawn_as_unit", func = 
				function(self2)
					UVMenu.CloseCurrentMenu(true)
					UVMenu.PlaySFX("clickopen")
					timer.Simple(tonumber(GetConVar("uvmenu_close_speed"):GetString()) or 0.2, function()
						RunConsoleCommand("uv_spawn_as_unit")
					end)
				end
				},
				{ type  = "buttonsw", text  = language.GetPhrase("uv.pm.spawnai.val"), desc  = "uv.pm.spawnai.val.desc", sv = true, min = 1, max = 20, start = 1,
					func = function(self2, amount)
						SpawnAI(amount, nil, true)
					end,
				},
				{ type = "button", text = "#uv.pm.clearai", desc = "uv.pm.clearai", convar = "uv_despawnvehicles", sv = true },
				
				{ type = "label", text = "#uv.pursuit", sv = true },
				-- { type = "button", text = "#uv.pm.pursuit.toggle", desc = "uv.pm.pursuit.toggle.desc", convar = "uv_startpursuit", sv = true },
				{ type = "button", text = "#uv.pm.pursuit.start", desc = "uv.pm.pursuit.start.desc", convar = "uv_startpursuit", sv = true },
				{ type = "button", text = "#uv.pm.pursuit.stop", desc = "uv.pm.pursuit.stop.desc", convar = "uv_stoppursuit", sv = true },
				{ type = "slider", text = "#uv.pm.heatlevel", desc = "uv.pm.heatlevel.desc", command = "uv_setheat", min = 1, max = MAX_HEAT_LEVEL, decimals = 0, sv = true },

				{ type = "label", text = "#uv.pm.misc", sv = true },
				{ type = "button", text = "#uv.pm.clearbounty", convar = "uv_clearbounty", sv = true },
				{ type = "button", text = "#uv.pm.wantedtable", convar = "uv_wantedtable", sv = true },
				
				-- { type = "label", text = "#uv.pm.misc", sv = true },
				-- { type = "button", text = "#uv.hm.open", desc = "uv.hm.open.desc", playsfx = "clickopen", func = function() UVMenu.OpenMenu(UVMenu.HeatManager, true) end },
			},
			
			{ TabName = "#uv.airacer", Icon = "unitvehicles/icons/(9)T_UI_PlayerRacer_Large_Icon.png", -- AI Racer Manager
				{ type = "combo", text = "#uv.tool.base.title", desc = "uv.tool.base.desc", convar = "uvracermanager_vehiclebase", sv = true, content = {
						{ "HL2 Jeep", 1 } ,
						{ "Simfphys", 2 } ,
						{ "Glide", 3 } ,
					},
				},
				{ type = "combo", text = "#uv.tool.spawncondition", desc = "uv.tool.spawncondition.desc", convar = "uvracermanager_spawncondition", sv = true, content = {
						{ "#uv.tool.spawncondition.never", 1 } ,
						{ "#uv.tool.spawncondition.driving", 2 } ,
						{ "#uv.tool.spawncondition.always", 3 } ,
					},
				},
				{ type = "slider", text = "#uv.tool.maxamount", desc = "uv.tool.maxamount.desc", convar = "uvracermanager_maxracer", min = 0, max = 20, decimals = 0, sv = true },
												
				{ type = "button", text = "#uv.applysett", desc = "uv.applysett.desc", convar = "uv_cleartraffic", sv = true, func = function()
					local convar_table = {}
					
					convar_table['unitvehicle_traffic_vehiclebase'] = GetConVar('uvtrafficmanager_vehiclebase'):GetInt()
					convar_table['unitvehicle_traffic_spawncondition'] = GetConVar('uvtrafficmanager_spawncondition'):GetInt()
					convar_table['unitvehicle_traffic_maxtraffic'] = GetConVar('uvtrafficmanager_maxtraffic'):GetInt()

					net.Start("UVUpdateSettings")
					net.WriteTable(convar_table)
					net.SendToServer()
					
					notification.AddLegacy( "#uv.tool.applied", NOTIFY_UNDO, 5 )
				end },
				
				-- { type = "button", text = "#uv.airacer.spawnai", desc = "uv.airacer.spawnai.desc", convar = "uvrace_spawnai", sv = true }, -- Single one - redundant?
				{ type = "buttonsw", text = language.GetPhrase("uv.airacer.spawnai.val"), desc = "uv.airacer.spawnai.val.desc", convar = "uvrace_spawnai", sv = true, min = 1, max = 20, start = 1, func = function(self2, amount) SpawnAI(amount) end, },
				{ type = "button", text = "#uv.airacer.clear", desc = "uv.airacer.clear.desc", convar = "uv_clearracers", sv = true },
				
				{ type = "bool", text = "#uv.airacer.override", desc = "uv.airacer.override.desc", convar = "uvracermanager_assignracers", sv = true },
				{ type = "ai_overridelist", text = "#uv.airacer.overridelist", desc = "uv.airacer.overridelist.desc", convar = "uvracermanager_racers", sv = true, parentconvar = "uvracermanager_assignracers" },
			},
			
			{ TabName = "#uv.tm", Icon = "unitvehicles/icons_settings/gameplay.png", -- Traffic Manager
				{ type = "combo", text = "#uv.tool.base.title", desc = "uv.tool.base.desc", convar = "uvtrafficmanager_vehiclebase", sv = true, content = {
						{ "HL2 Jeep", 1 } ,
						{ "Simfphys", 2 } ,
						{ "Glide", 3 } ,
					},
				},
				{ type = "combo", text = "#uv.tool.spawncondition", desc = "uv.tool.spawncondition.desc", convar = "uvtrafficmanager_spawncondition", sv = true, content = {
						{ "#uv.tool.spawncondition.never", 1 } ,
						{ "#uv.tool.spawncondition.driving", 2 } ,
						{ "#uv.tool.spawncondition.always", 3 } ,
					},
				},
				{ type = "slider", text = "#uv.tool.maxamount", desc = "uv.tool.maxamount.desc", convar = "uvtrafficmanager_maxtraffic", min = 0, max = 20, decimals = 0, sv = true },
				
				{ type = "button", text = "#uv.applysett", desc = "uv.applysett.desc", convar = "uv_cleartraffic", sv = true, func = function()
					local convar_table = {}
					
					convar_table['unitvehicle_traffic_vehiclebase'] = GetConVar('uvtrafficmanager_vehiclebase'):GetInt()
					convar_table['unitvehicle_traffic_spawncondition'] = GetConVar('uvtrafficmanager_spawncondition'):GetInt()
					convar_table['unitvehicle_traffic_maxtraffic'] = GetConVar('uvtrafficmanager_maxtraffic'):GetInt()

					net.Start("UVUpdateSettings")
					net.WriteTable(convar_table)
					net.SendToServer()
					
					notification.AddLegacy( "#uv.tool.applied", NOTIFY_UNDO, 5 )
				end },
				
				{ type = "button", text = "#uv.tm.clear", desc = "uv.tm.clear.desc", convar = "uv_cleartraffic", sv = true },
			},

			{ TabName = "#uv.settings", Icon = "unitvehicles/icons_settings/options.png", playsfx = "clickopen", func = function()
					UVMenu.OpenMenu(UVMenu.Settings) -- Settings Menu
				end,
			},

			{ TabName = "#uv.faq", Icon = "unitvehicles/icons_settings/question.png", playsfx = "clickopen", func = function()
					UVMenu.OpenMenu(UVMenu.FAQ) -- FAQ
				end,
			},

			{ TabName = "#uv.credits", Icon = "unitvehicles/icons/milestone_outrun_pursuits_won.png", playsfx = "clickopen", func = function()
					UVMenu.OpenMenu(UVMenu.Credits, true) -- Credits
				end,
			},
			
		}
	})
end

-- Settings
UVMenu.Settings = function()
	UVMenu.CurrentMenu = UVMenu:Open({
		Name = language.GetPhrase("uv.unitvehicles") .. " | " .. language.GetPhrase("uv.settings"),
		Width  = UV.ScaleW(1540),
		Height = UV.ScaleH(760),
		Description = true,
		UnfocusClose = true,
		Tabs = {
			{ TabName = "#uv.ui.title", Icon = "unitvehicles/icons_settings/display.png",

				{ type = "label", text = "#uv.settings.general" },
				{ type = "combo", text = "#uv.ui.main", desc = "uv.ui.main.desc", convar = "unitvehicle_hudtype_main", content = mainHUDList },
				{ type = "combo", text = "#uv.ui.backup", desc = "uv.ui.backup.desc", convar = "unitvehicle_hudtype_backup", content = backupHUDList },
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
				{ type = "slider", text = "#uv.ui.deadzone", desc = "uv.ui.deadzone.desc", convar = "unitvehicle_hud_deadzone", min = 0, max = 500, decimals = 0 },
				{ type = "slider", text = "#uv.ui.scale", desc = "uv.ui.scale.desc", convar = "unitvehicle_hud_scale", min = 0.1, max = 1, decimals = 2 },

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
			{ TabName = "#uv.keybinds", Icon = "unitvehicles/icons_settings/controls.png", -- Can't get it to work - oh well.

				{ type = "label", text = "#uv.keybinds.pt" },
				{ type = "keybind", text = "#uv.keybind.slot1", desc = "uv.keybind.slot1.desc", convar = "unitvehicle_pursuittech_keybindslot_1", slot = 1 },
				{ type = "keybind", text = "#uv.keybind.slot2", desc = "uv.keybind.slot2.desc", convar = "unitvehicle_pursuittech_keybindslot_2", slot = 2 },
				
				{ type = "label", text = "#uv.keybinds.races" },
				{ type = "keybind", text = "#uv.keybind.skipsong", desc = "uv.keybind.skipsong.desc", convar = "unitvehicle_keybind_skipsong", slot = 3 },
				{ type = "keybind", text = "#uv.keybind.resetposition", desc = "uv.keybind.resetposition.desc", convar = "unitvehicle_keybind_resetposition", slot = 4 },
				{ type = "keybind", text = "#uv.keybind.showresults", desc = "uv.keybind.showresults.desc", convar = "unitvehicle_keybind_raceresults", slot = 5 },
			},
			{ TabName = "#uv.pursuit", Icon = "unitvehicles/icons/milestone_pursuit.png", sv = true,
				{ type = "label", text = "#uv.pursuit.heatlevels", sv = true },
				{ type = "bool", text = "#uv.pursuit.heatlevels.enable", desc = "uv.pursuit.heatlevels.enable.desc", convar = "unitvehicle_heatlevels", sv = true },
				{ type = "bool", text = "#uv.pursuit.heatlevels.aiunits", desc = "uv.pursuit.heatlevels.aiunits.desc", convar = "unitvehicle_spawnmainunits", sv = true },
				
				{ type = "label", text = "#uv.settings.general", sv = true },
				{ type = "bool", text = "#uv.pursuit.spottedfreezecam", desc = "uv.pursuit.spottedfreezecam.desc", convar = "unitvehicle_spottedfreezecam", sv = true, sp = true },
				{ type = "bool", text = "#uv.pursuit.randomplayerunits", desc = "uv.pursuit.randomplayerunits.desc", convar = "unitvehicle_randomplayerunits", sv = true },
				{ type = "bool", text = "#uv.pursuit.autohealth", desc = "uv.pursuit.autohealth.desc", convar = "unitvehicle_autohealth", sv = true },
				{ type = "bool", text = "#uv.pursuit.wheelsdetaching", desc = "uv.pursuit.wheelsdetaching.desc", convar = "unitvehicle_wheelsdetaching", sv = true },
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
			{ TabName = "#uv.addons", Icon = "unitvehicles/icons/generic_cart.png", sv = true,
				{ type = "label", text = "#uv.addons.builtin", desc = "uv.addons.builtin.desc", sv = true },
				{ type = "bool", text = "#uv.addons.vcmod.els", desc = "uv.addons.vcmod.els.desc", convar = "unitvehicle_vcmodelspriority", sv = true },
				{ type = "label", text = "Glide // Circular Functions", sv = true },
				{ type = "bool", text = "#uv.ailogic.usenitrousracer", desc = "uv.ailogic.usenitrousracer.desc", convar = "unitvehicle_usenitrousracer", sv = true },
				{ type = "bool", text = "#uv.ailogic.usenitrousunit", desc = "uv.ailogic.usenitrousunit.desc", convar = "unitvehicle_usenitrousunit", sv = true },
			},

			{ TabName = "#uv.back", playsfx = "clickback", func = function()
					UVMenu.OpenMenu(UVMenu.Main)
				end,
			},
		}
	})
end

-- Colour Settings
UVMenu.SettingsCol = function()
	UVMenu.CurrentMenu = UVMenu:Open({
		Name = " ",
		Width  = UV.ScaleW(1250),
		Height = UV.ScaleH(760),
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

-- FAQ Data List
UV.FAQ = {
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

-- FAQ Menu
UVMenu.FAQ = function()
	UVMenu.CurrentMenu = UVMenu:Open({
		Name = language.GetPhrase("uv.unitvehicles") .. " | " .. language.GetPhrase("uv.faq"),
		Width  = UV.ScaleW(1540),
		Height = UV.ScaleH(760),
		UnfocusClose = true,
		Tabs = {
			{ TabName = "#uv.faq.intro", Icon = "unitvehicles/icons_settings/info.png",
				{ type = "info", text = UV.FAQ["Intro"] },
				{ type = "info", text = UV.FAQ["Requirements"] },
				{ type = "info", text = UV.FAQ["Github"] },
				{ type = "info", text = UV.FAQ["ConVars"] },
				{ type = "info", text = UV.FAQ["Roadmap"] },
			},

			{ TabName = "#uv.faq.racing", Icon = "unitvehicles/icons/race_events.png",
				{ type = "info", text = UV.FAQ["Racing.Joining"] },
				{ type = "info", text = UV.FAQ["Racing.Resetting"] },
				
				{ type = "info", text = UV.FAQ["Racing.Starting"], sv = true },
				{ type = "info", text = UV.FAQ["Racing.Create"], sv = true },
				{ type = "info", text = UV.FAQ["Racing.Create.Speedlimit"], sv = true },
			},

			{ TabName = "#uv.faq.pursuits", Icon = "unitvehicles/icons/milestone_911.png",
				{ type = "info", text = UV.FAQ["Pursuit.Starting"], sv = true },
				
				{ type = "info", text = UV.FAQ["Pursuit.JoinAsUnit"] },
				{ type = "info", text = UV.FAQ["Pursuit.Respawn"] },

				{ type = "info", text = UV.FAQ["Pursuit.CreateUnits"], sv = true },
				{ type = "info", text = UV.FAQ["Pursuit.Roadblocks"], sv = true },
				{ type = "info", text = UV.FAQ["Pursuit.Pursuitbreaker"], sv = true },
			},

			{ TabName = "#uv.faq.other", Icon = "unitvehicles/icons_settings/info.png",
				{ type = "info", text = UV.FAQ["Other.CreateTraffic"], sv = true },
				{ type = "info", text = UV.FAQ["Other.PursuitTech"] },
				
				{ type = "info", text = UV.FAQ["Other.RenameAI"], sv = true },
				{ type = "info", text = UV.FAQ["Other.DataFolder"], sv = true },
			},

			{ TabName = "#uv.back", playsfx = "clickback", func = function()
					UVMenu.OpenMenu(UVMenu.Main)
				end,
			},
		}
	})
end

-- Credits List
UV.Credits = {
["UVTeam"] = [[
**Project Lead: Roboboy**
**Aux**
**Moka**
**TalonSolid**
**ET7970**
]],
["TranslationsRaw"] = [[
[flag_se] **Moka**
[flag_el] **TalonSolid**
[flag_ru] **WladZ**
[flag_cz] **Despe**
[flag_es] **Dami**
[flag_br] **Raiden_Gm**
[flag_cn] **Pathfinder_FUFU**
[flag_th] **Takis036**
[flag_ua] **Mr.Negative & Renegade_Glitch**
[flag_pl] **TheSilent1**
]],
["Translations"] = {
		{ flag = "se", desc = "Svenska - Swedish", name = "Moka" },
		{ flag = "gr", desc = "Ελληνικά - Greek", name = "TalonSolid" },
		{ flag = "ru", desc = "Русский - Russian", name = "WladZ" },
		{ flag = "cz", desc = "Čeština - Czech", name = "Despe" },
		{ flag = "es", desc = "Español - Spanish", name = "Dami" },
		{ flag = "br", desc = "Português Brasileiro - Brazilian Portuguese", name = "Raiden_Gm" },
		{ flag = "cn", desc = "简体中文 - Simplified Chinese", name = "Pathfinder_FUFU" },
		{ flag = "th", desc = "แบบไทย - Thai", name = "Takis036" },
		{ flag = "ua", desc = "Українська - Ukrainian", name = "Mr.Negative & Renegade_Glitch" },
		{ flag = "pl", desc = "Polski - Polish", name = "TheSilent1" },
	},
}

-- Credits Menu
UVMenu.Credits = function()
	UVMenu.CurrentMenu = UVMenu:Open({
		Name = " ",
		Width  = UV.ScaleW(500),
		Height = UV.ScaleH(700),
		UnfocusClose = true,
		Tabs = {
			{ TabName = "#uv.credits", Icon = "unitvehicles/icons_settings/info.png",
				{ type = "button", text = "#uv.back", sv = true, playsfx = "clickback",
					func = function(self2) UVMenu.OpenMenu(UVMenu.Main) end
				},
				{ type = "label", text = "#uv.credits.uvteam" },
				{ type = "info", text = UV.Credits["UVTeam"] },
				{ type = "label", text = "#uv.credits.translations" },
				-- { type = "info", text = UV.Credits["Translations"] },
				{ type = "info_flags", entries = UV.Credits["Translations"] },
			},
		}
	})
end

------- [ Race Manager ] -------
UVMenu.RaceManager = function()
	UVMenu.CurrentMenu = UVMenu:Open({
		Name = " ",
		Width  = UV.ScaleW(580),
		Height = UV.ScaleH(380),
		UnfocusClose = true,
		Tabs = {
			{ TabName = "#uv.rm",
				-- No track loaded, none active
				{ type = "button", text = "#uv.rm.loadrace", sv = true, playsfx = "clickopen",
					cond = function() return #ents.FindByClass( "uvrace_spawn" ) == 0 end,
					func = function(self2) RunConsoleCommand("uvrace_queryimport") end
				},
				
				-- Track loaded, race not started
				{ type = "button", text = "#uv.rm.startrace", sv = true, playsfx = "clickopen",
					cond = function() return #ents.FindByClass( "uvrace_spawn" ) > 0 and not (UVRaceStarting or UVHUDDisplayRacing) end,
					func = function(self2) UVMenu.OpenMenu(UVMenu.RaceManagerStartRace, true) end
				},
				{ type = "button", text = "#uv.rm.sendinvite", sv = true, convar = "uvrace_startinvite", playsfx = "confirm",
					cond = function() return #ents.FindByClass( "uvrace_spawn" ) > 0 and not (UVRaceStarting or UVHUDDisplayRacing) end,
				},
				{ type = "button", text = "#uv.rm.changerace", sv = true, playsfx = "clickopen",
					cond = function() return #ents.FindByClass( "uvrace_spawn" ) > 0 and not (UVRaceStarting or UVHUDDisplayRacing) end,
					func = function(self2) RunConsoleCommand("uvrace_queryimport") end
				},
				{ type = "button", text = "#uv.rm.cancelrace", sv = true, playsfx = "clickopen",
					cond = function() return #ents.FindByClass( "uvrace_spawn" ) > 0 and not (UVRaceStarting or UVHUDDisplayRacing) end,
					func = function(self2) RunConsoleCommand("uvrace_stop") UVMenu.OpenMenu(UVMenu.RaceManager) end
				},
				
				-- Race active
				{ type = "button", text = "#uv.rm.stoprace", sv = true, playsfx = "clickopen",
					cond = function() return UVRaceStarting or UVHUDDisplayRacing end,
					func = function(self2) RunConsoleCommand("uvrace_stop") UVMenu.OpenMenu(UVMenu.RaceManager) end
				},

				-- Always active
				{ type = "button", text = "#uv.rm.options", sv = true, playsfx = "clickopen",
					func = function(self2) UVMenu.OpenMenu(UVMenu.RaceManagerSettings, true) end
				},
				{ type = "button", text = "#uv.back", sv = true, playsfx = "clickback",
					func = function(self2) UVMenu.OpenMenu(UVMenu.Main) end
				},
			}
		}
	})
end

-- Race Manager, Settings
UVMenu.RaceManagerSettings = function()
	UVMenu.CurrentMenu = UVMenu:Open({
		Name = " ",
		Width  = UV.ScaleW(900),
		Height = UV.ScaleH(600),
		Description = true,
		UnfocusClose = true,
		Tabs = {
			{ TabName = "#uv.rm.options",
				{ type = "slider", text = "#uv.rm.options.laps", desc = "uv.rm.options.laps.desc", convar = "uvracemanager_laps", min = 1, max = 99, decimals = 0, sv = true },
				{ type = "slider", text = "#uv.rm.options.dnftimer", desc = "uv.rm.options.dnftimer.desc", convar = "unitvehicle_racednftimer", min = 0, max = 90, decimals = 0, sv = true },
				{ type = "bool", text = "#uv.rm.options.visiblecheckpoints", desc = "uv.rm.options.visiblecheckpoints.desc", convar = "unitvehicle_racevisiblecheckpoints", sv = true },
				{ type = "label", text = "#uv.pursuit" },
				{ type = "slider", text = "#uv.rm.options.pursuitstart", desc = "uv.rm.options.pursuitstart.desc", convar = "unitvehicle_racepursuitstart", min = 0, max = 90, decimals = 0, sv = true },
				{ type = "bool", text = "#uv.rm.options.pursuitclear", desc = "uv.rm.options.pursuitclear.desc", convar = "unitvehicle_racepursuitstop", sv = true },
				{ type = "bool", text = "#uv.rm.options.pursuitclear.ai", desc = "uv.rm.options.pursuitclear.ai.desc", convar = "unitvehicle_racepursuitstop_despawn", parentconvar = "unitvehicle_racepursuitstop", sv = true },
				{ type = "label", text = "#uv.ai.title" },
				{ type = "bool", text = "#uv.rm.options.clearai", desc = "uv.rm.options.clearai.desc", convar = "unitvehicle_raceclearai", sv = true },
				{ type = "button", text = "#uv.back", sv = true, playsfx = "clickback",
					func = function(self2) UVMenu.OpenMenu(UVMenu.RaceManager) end
				},
			}
		}
	})
end

local function ParseRaceFile(path)
	local content = file.Read(path, "DATA")
	if not content then return nil end

	local lines = string.Split(content, "\n")
	local header = lines[1] or ""
	local params = string.Split(header, " ")
	local raceName = params[2] or "Unknown"
	local author = header:match("'(.-)'") or "Unknown"

	local checkpoints = {}
	local idList = {}
	local spawns = {}

	for _, line in ipairs(lines) do
		if string.match(line, "^%d+%s") then
			local t = string.Explode(" ", line)
			local id = tonumber(t[1])
			if id and #t >= 8 then
				if not checkpoints[id] then
					checkpoints[id] = {}
					table.insert(idList, id)
				end
				table.insert(checkpoints[id], {
					start = Vector(tonumber(t[2]), tonumber(t[3]), tonumber(t[4])),
					endp  = Vector(tonumber(t[5]), tonumber(t[6]), tonumber(t[7])),
				})
			end
		elseif string.match(line, "^spawn") then
			local t = string.Explode(" ", line)
			if #t >= 6 then
				table.insert(spawns, Vector(tonumber(t[2]), tonumber(t[3]), tonumber(t[4])))
			end
		end
	end

	table.SortByMember(idList, nil, true)
	table.sort(idList, function(a,b) return a < b end)

	return {
		filename = string.GetFileFromFilename(path),
		name = raceName:Replace("_", " "),
		author = author,
		checkpoints = checkpoints,
		idList = idList,
		spawns = spawns,
	}
end

-- Race Manager, Track Select
UVMenu.RaceManagerTrackSelect = function()
	local files = file.Find("unitvehicles/races/" .. game.GetMap() .. "/*.txt", "DATA")
	local raceEntries = {}

	for _, fname in ipairs(files) do
		local rec = ParseRaceFile("unitvehicles/races/" .. game.GetMap() .. "/" .. fname)
		if rec then
			table.insert(raceEntries, {
				type = "button",
				text = rec.name,
				desc = string.format( language.GetPhrase( "uv.rm.author" ), rec.author ) .. "\n"  .. 
				string.format( language.GetPhrase( "uv.rm.checkpoints" ), #rec.checkpoints ) .. "\n" .. 
				string.format( language.GetPhrase( "uv.rm.startslots" ), #rec.spawns ),
				playsfx = "clickopen",
				func = function()
					RunConsoleCommand("uvrace_import", rec.filename)
					UVMenu.CloseCurrentMenu(true)
					timer.Simple(tonumber(GetConVar("uvmenu_close_speed"):GetString()) or 0.2, function()
						UVMenu.OpenMenu(UVMenu.RaceManager)
						UVMenu.PlaySFX("menuopen") -- This shouldn't be necessary but ah well
					end)
				end
			})
		end
	end
	
	local entriesWithBack = {}
	for _, entry in ipairs(raceEntries) do
		table.insert(entriesWithBack, entry)
	end

	table.insert(entriesWithBack, { type = "button", text = "#uv.back", sv = true, playsfx = "clickback", func = function(self2)
			UVMenu.OpenMenu(UVMenu.RaceManager)
		end
	})

	UVMenu:Open({
		Name = " ",
		Width  = UV.ScaleW(580),
		Height = UV.ScaleH(705),
		Description = true,
		UnfocusClose = true,
		Tabs = {
			{
				TabName = "#uv.rm.loadrace",
				unpack(entriesWithBack)
			}
		}
	})
end

-- Race Manager, Start Race
UVMenu.RaceManagerStartRace = function()
	local function GetAvailableAISlots()
		local racerList = UVRace_RacerList or {}
		local spawnCount = #ents.FindByClass("uvrace_spawn") or 0
		local existingAI = #ents.FindByClass("npc_racervehicle") or 0
		local hostAdjustment = 1

		return math.max(spawnCount - (#racerList + existingAI + hostAdjustment), 0)
	end

	local function FillGridWithAI()
		local racerList = UVRace_RacerList or {}
		local spawnCount = #ents.FindByClass("uvrace_spawn") or 0
		local existingAI = #ents.FindByClass("npc_racervehicle") or 0
		local hostAdjustment = 1

		RunConsoleCommand("uvrace_startinvite")

		local neededAI = math.max(spawnCount - (#racerList + existingAI + hostAdjustment), 0)
		for i = 1, neededAI do
			RunConsoleCommand("uvrace_spawnai")
		end

		timer.Simple(0.5, function()
			RunConsoleCommand("uvrace_startinvite")
		end)

		timer.Simple(2, function()
			RunConsoleCommand("uvrace_startrace", GetConVar("uvracemanager_laps"):GetString())
		end)
	end

	local maxSlots = GetAvailableAISlots()
	local spawnAmountStart = math.Clamp(1, 1, maxSlots)

	UVMenu.CurrentMenu = UVMenu:Open({
		Name = " ",
		Width  = UV.ScaleW(960),
		Height = UV.ScaleH(325),
		Description = true,
		UnfocusClose = true,
		Tabs = {
			{
				TabName = "#uv.rm",
				{ type = "button", text = "#uv.rm.startrace", desc = "uv.rm.startrace.desc", sv = true,
					func = function()
						RunConsoleCommand("uvrace_startrace", GetConVar("uvracemanager_laps"):GetString())
						UVMenu.CloseCurrentMenu()
					end
				},
				{ type  = "buttonsw", text  = language.GetPhrase("uv.rm.startrace.addai"), desc  = "uv.rm.startrace.addai.desc", sv = true, min = 1, max = maxSlots, start = spawnAmountStart,
					func = function(self2, amount)
						SpawnAI(amount, true)
						UVMenu.CloseCurrentMenu()
					end,
					cond = function() return maxSlots > 0 end,
				},
				{ type = "button", text = "#uv.rm.startrace.fillai", desc = string.format( language.GetPhrase("uv.rm.startrace.fillai.desc"), maxSlots ), sv   = true,
					func = function()
						FillGridWithAI()
						UVMenu.CloseCurrentMenu()
					end,
					cond = function() return maxSlots > 0 end,
				},
				{ type = "button", text = "#uv.back", sv   = true, playsfx = "clickback",
					func = function()
						UVMenu.OpenMenu(UVMenu.RaceManager)
					end
				},
			}
		}
	})
end

------- [ Pursuit Related ]-------
-- Unit Select
function UVMenu.UnitSelect(unittable, unittablename, unittablenpc)
	local menuEntries = {}

	for classIndex, unitsString in ipairs(unittable) do
		-- split units list
		local available = {}
		for unitName in string.gmatch(unitsString, "%S+") do
			table.insert(available, unitName)
		end

		if #available > 0 then
			-- Category label
			table.insert(menuEntries, {
				type = "label",
				text = unittablename[classIndex],
			})

			-- Buttons for each unit
			for _, unitName in ipairs(available) do
				table.insert(menuEntries, {
					type = "button",
					text = unitName,
					func = function()
						local npcClass = unittablenpc[classIndex]
						local isRhino = (classIndex == 6)
						local cleanLabel = string.Trim(unittablename[classIndex], "#")

						net.Start("UVHUDRespawnInUV")
						net.WriteString(unitName)
						net.WriteString(npcClass)
						net.WriteBool(isRhino)
						net.WriteString(cleanLabel)
						net.SendToServer()

						UVMenu.CloseCurrentMenu(true)
					end
				})
			end
		end
	end

	-- Back button
	table.insert(menuEntries, {
		type = "button",
		text = "#uv.back",
		playsfx = "clickback",
		func = function()
			UVMenu.OpenMenu(UVMenu.Main)
		end
	})

	-- Open the menu with fully prebuilt entries
	UVMenu.CurrentMenu = UVMenu:Open({
		Name = " ",
		Width  = UV.ScaleW(580),
		Height = UV.ScaleH(705),
		-- Description = true,
		UnfocusClose = false,

		Tabs = {
			{
				TabName = "#uv.chase.select.menu",
				unpack(menuEntries),
			}
		}
	})
end

-- Unit Wrecked
UVMenu.WreckedDebrief = function()
	UVMenu.CurrentMenu = UVMenu:Open({
		Name = " ",
		Width  = UV.ScaleW(870),
		Height = UV.ScaleH(300),
		UnfocusClose = false,
		HideCloseButton = true,
		Tabs = {
			{ TabName = "#uv.chase.wrecked", Icon = "unitvehicles/icons_settings/display.png",

				{ type = "infosimple", text = language.GetPhrase("uv.chase.wrecked.text1") .. "\n" .. language.GetPhrase("uv.chase.wrecked.text2"), centered = true },
				{ type = "button", text = "#uv.chase.wrecked.rejoin", playsfx = "clickopen", func = 
				function(self2)
					net.Start("UVHUDRespawnInUVGetInfo")
					net.SendToServer()
				end
				},
				{ type = "button", text = "#uv.chase.wrecked.abandon", func = 
				function(self2)
					UVMenu.CloseCurrentMenu()
				end
				},
				{ type = "timer", text = "#uv.results.autoclose", duration = 10, func = 
					function(self2)
						net.Start("uvrace_invite")
						net.WriteBool(false)
						net.SendToServer()
						UVMenu.CloseCurrentMenu()
					end
				},
			}
		}
	})
end

------- [ Racing Related ]-------
UVMenu.RaceInvite = function()
	UVMenu.CurrentMenu = UVMenu:Open({
		Name = " ",
		Width  = UV.ScaleW(870),
		Height = UV.ScaleH(335),
		UnfocusClose = false,
		HideCloseButton = true,
		Tabs = {
			{ TabName = "#uv.race.invite", Icon = "unitvehicles/icons_settings/display.png",

				{ type = "infosimple", text = language.GetPhrase("uv.race.invite.desc") .. "\n" .. language.GetPhrase("uv.race.invite.desc2"), centered = true },
				{ type = "infosimple", text = string.format( language.GetPhrase("uv.race.invite.host"), UVRace_CurrentTrackHost ) .. "\n" .. string.format( language.GetPhrase("uv.prerace.name"), UVRace_CurrentTrackName ), centered = true },
				{ type = "button", text = "#uv.race.invite.accept", func = 
				function(self2)
					net.Start("uvrace_invite")
					net.WriteBool(true)
					net.SendToServer()
					UVMenu.CloseCurrentMenu()
				end
				},
				{ type = "button", text = "#uv.race.invite.decline", func = 
				function(self2)
					net.Start("uvrace_invite")
					net.WriteBool(false)
					net.SendToServer()
					UVMenu.CloseCurrentMenu()
				end
				},
				{ type = "timer", text = "#uv.race.invite.autodecline", duration = 10, func = 
					function(self2)
						net.Start("uvrace_invite")
						net.WriteBool(false)
						net.SendToServer()
						UVMenu.CloseCurrentMenu()
					end
				},
			}
		}
	})
end

------- [ Heat Manager ] -------
UVMenu.HeatManager = function()
	UVMenu.CurrentMenu = UVMenu:Open({
		Name = language.GetPhrase("uv.unitvehicles") .. " | " .. language.GetPhrase("uv.hm"),
		Width  = UV.ScaleW(1540),
		Height = UV.ScaleH(760),
		Description = true,
		UnfocusClose = true,
		Tabs = {
			{ TabName = "#uv.settings.general",
				{ type = "bool", text = "#uv.hm.timedhl", desc = "uv.hm.timedhl.desc", convar = "uvunitmanager_timetillnextheatenabled", sv = true },
				{ type = "slider", text = "#uv.hm.minhl", desc = "uv.hm.minhl.desc", convar = "uvunitmanager_minheat", min = 1, max = MAX_HEAT_LEVEL, decimals = 0, sv = true },
				{ type = "slider", text = "#uv.hm.maxhl", desc = "uv.hm.maxhl.desc", convar = "uvunitmanager_maxheat", min = 1, max = MAX_HEAT_LEVEL, decimals = 0, sv = true },
			},
			{ TabName = string.format( language.GetPhrase("uv.hm.lvl"), 1 ),
			},
			{ TabName = string.format( language.GetPhrase("uv.hm.lvl"), 2 ),
			},
			{ TabName = string.format( language.GetPhrase("uv.hm.lvl"), 3 ),
			},
			{ TabName = string.format( language.GetPhrase("uv.hm.lvl"), 4 ),
			},
			{ TabName = string.format( language.GetPhrase("uv.hm.lvl"), 5 ),
			},
			{ TabName = string.format( language.GetPhrase("uv.hm.lvl"), 6 ),
			},
			{ TabName = string.format( language.GetPhrase("uv.hm.lvl"), 7 ),
			},
			{ TabName = string.format( language.GetPhrase("uv.hm.lvl"), 8 ),
			},
			{ TabName = string.format( language.GetPhrase("uv.hm.lvl"), 9 ),
			},
			{ TabName = string.format( language.GetPhrase("uv.hm.lvl"), 10 ),
			},
			{ TabName = "#uv.back", playsfx = "clickback", func = function()
					UVMenu.OpenMenu(UVMenu.Main)
				end,
			},
		}
	})
end