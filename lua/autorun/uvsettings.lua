AddCSLuaFile()

if CLIENT then -- Start of CLIENT Section
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
	local pnote = [[
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

	UV.SettingsTable = {
		{
			TabName = "#uv.settings.tab.welcome", Icon = "unitvehicles/icons_settings/ingame_icon_options.png",
			
			{ type = "label", text = "#uv.settings.quick", desc = "#uv.settings.quick.desc" },
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
			{ type = "combo", text = "#uv.settings.audio.uvtrax.profile", desc = "uv.settings.audio.uvtrax.profile.desc", convar = "unitvehicle_racetheme", content = uvtraxcontent },
			{ type = "button", text = "#uv.settings.pm.ai.spawnas", convar = "uv_spawn_as_unit", func = 
			function(self2)
				RunConsoleCommand("uv_spawn_as_unit")
				if IsValid(UV.SettingsFrame) then
					UV.SettingsFrame:Remove()
				end
			end
			},
			
			{ type = "label", text = "#uv.settings.pnotes" },
			{ type = "image", image = "unitvehicles/icons_settings/latestpatch.png" },
			{ type = "info", text = pnote },
		},
		{
			TabName = "#uv.settings.uistyle.title", Icon = "unitvehicles/icons_settings/options_icon_display.png",

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
		{
			TabName = "#uv.settings.audio.title", Icon = "unitvehicles/icons_settings/options_icon_audio.png",

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
		-- { -- Can't get it to work - oh well.
			-- TabName = "#uv.settings.keybinds", Icon = "unitvehicles/icons_settings/options_icon_controls.png",

			-- { type = "label", text = "#uv.settings.keybinds.pt" },
			-- { type = "keybind", text = "#uv.settings.ptech.slot1", desc = "uv.settings.keybind.skipsong.desc", convar = "UVPTKeybindSlot1", slot = 1 },
			-- { type = "keybind", text = "#uv.settings.ptech.slot2", desc = "uv.settings.keybind.skipsong.desc", convar = "UVPTKeybindSlot2", slot = 2 },
			
			-- { type = "label", text = "#uv.settings.keybinds.races" },
			-- { type = "keybind", text = "#uv.settings.keybind.skipsong", desc = "uv.settings.keybind.skipsong.desc", convar = "unitvehicle_keybind_skipsong", slot = 3 },
			-- { type = "keybind", text = "#uv.settings.keybind.resetposition", desc = "uv.settings.keybind.resetposition.desc", convar = "UVKeybindResetPosition", slot = 4 },
			-- { type = "keybind", text = "#uv.settings.keybind.showresults", desc = "uv.settings.keybind.showresults.desc", convar = "UVKeybindShowRaceResults", slot = 5 },
		-- },
		{
			TabName = "#uv.settings.pm", Icon = "unitvehicles/icons/cops_icon.png",

			{ type = "button", text = "#uv.settings.pm.ai.spawnas", convar = "uv_spawn_as_unit", func = 
			function(self2)
				RunConsoleCommand("uv_spawn_as_unit")
				if IsValid(UV.SettingsFrame) then
					UV.SettingsFrame:Remove()
				end
			end
			},

			{ type = "label", text = "#uv.settings.server", sv = true },
			-- { type = "button", text = "#uv.settings.pm.pursuit.toggle", desc = "uv.settings.pm.pursuit.toggle.desc", convar = "uv_startpursuit", sv = true },
			{ type = "button", text = "#uv.settings.pm.pursuit.start", desc = "uv.settings.pm.pursuit.start.desc", convar = "uv_startpursuit", sv = true },
			{ type = "button", text = "#uv.settings.pm.pursuit.stop", desc = "uv.settings.pm.pursuit.stop.desc", convar = "uv_stoppursuit", sv = true },
			{ type = "slider", text = "#uv.settings.pm.heatlevel", desc = "uv.settings.pm.heatlevel.desc", convar = "uv_setheat", min = 1, max = MAX_HEAT_LEVEL, decimals = 0, sv = true },
			
			{ type = "button", text = "#uv.settings.pm.ai.spawn", convar = "uv_spawnvehicles", sv = true },
			{ type = "button", text = "#uv.settings.pm.ai.despawn", convar = "uv_despawnvehicles", sv = true },
			
			{ type = "label", text = "#uv.settings.pm.misc", sv = true },
			{ type = "button", text = "#uv.settings.clearbounty", convar = "uv_clearbounty", sv = true },
			{ type = "button", text = "#uv.settings.print.wantedtable", convar = "uv_wantedtable", sv = true },
		},
		{
			TabName = "#uv.settings.pursuit", Icon = "unitvehicles/icons_settings/ingame_icon_options.png", sv = true,
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
		{
			TabName = "#uv.settings.ptech", Icon = "unitvehicles/icons_carbon/wingman_target.png", sv = true,
			{ type = "label", text = "#uv.settings.general", sv = true },
			{ type = "bool", text = "#uv.settings.ptech.racer", desc = "uv.settings.ptech.racer.desc", convar = "unitvehicle_racerpursuittech", sv = true },
			{ type = "bool", text = "#uv.settings.ptech.friendlyfire", desc = "uv.settings.ptech.friendlyfire.desc", convar = "unitvehicle_racerfriendlyfire", sv = true },
			{ type = "bool", text = "#uv.settings.ptech.roadblockfriendlyfire", desc = "uv.settings.ptech.roadblockfriendlyfire.desc", convar = "unitvehicle_spikestriproadblockfriendlyfire", sv = true },
		},
		{
			TabName = "#uv.settings.tab.ai", Icon = "unitvehicles/icons_settings/ingame_icon_options.png", sv = true,
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
		{
			TabName = "#uv.settings.tab.addons", Icon = "unitvehicles/icons_settings/ingame_icon_options.png", sv = true,
			{ type = "label", text = "#uv.settings.addon.builtin", desc = "uv.settings.addon.builtin.desc", sv = true },
			{ type = "bool", text = "#uv.settings.addon.vcmod.els", desc = "uv.settings.addon.vcmod.els.desc", convar = "unitvehicle_vcmodelspriority", sv = true },
		},
	}

	-- Open / close helpers
	function UV.CloseSettings()
		if IsValid(UV.SettingsFrame) then
			UV.SettingsFrame:Remove()
		end
		gui.EnableScreenClicker(false)
	end
	
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

	-- Create the desktop icon entry (clicking it runs console command which opens our menu)
	list.Set("DesktopWindows", "UnitVehiclesSettings", {
		title = "#uv.settings.unitvehicles",
		icon  = "unitvehicles/icons/MILESTONE_OUTRUN_PURSUITS_WON.png",
		init = function(icon, window)
			RunConsoleCommand("unitvehicles_open_settings")
		end
	})

	concommand.Add("unitvehicles_open_settings", function()
		UV.OpenSettings()
	end)

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
				str = str:gsub("(%s)%*(.-)%*", "%1[i]%2[/i]")
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

			local mk = nil
			local lastWidth = 0

			-- function to rebuild markup when width changes
			function p:Rebuild()
				local w = self:GetWide()
				if w <= 0 then return end

				mk = markup.Parse("<font=UVSettingsFontSmall>" .. rawText .. "</font>", w - 20)

				self:SetTall(mk:GetHeight() + 20)
			end

			-- Called every time the panel is laid out
			function p:PerformLayout()
				local w = self:GetWide()
				if w ~= lastWidth then
					lastWidth = w
					self:Rebuild()
				end
			end

			p.Paint = function(self, w, h)
				surface.SetDrawColor(28, 28, 28, 150)
				surface.DrawRect(0, 0, w, h)

				if mk then
					mk:Draw(10, 10)
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
				draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 200))
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
			end

			wrap.OnCursorEntered = function()
				if descPanel then
					descPanel.Text = st.text
					descPanel.Desc = st.desc or ""
				end
			end

			wrap.OnCursorExited = function()
				if descPanel then
					descPanel.Text = ""
					descPanel.Desc = ""
				end
			end

			wrap.Paint = function(self, w, h)
				local enabled = getBool()
				local hovered = self:IsHovered()
				local bga = hovered and 200 * math.abs(math.sin(RealTime()*4)) or 125
				local bg = Color( 125, 125, 125, bga )
				
				if enabled then
					bg = Color( 58, 193, 0, bga )
				end
				
				-- background & text
				draw.RoundedBox(6, w*0.955, 0, w*0.045, h, bg)
				draw.SimpleText(GetDisplayText(), "UVMostWantedLeaderboardFont", 10, h/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

				-- icon right
				if enabled then
					surface.SetDrawColor(255,255,255, enabled and 255 or 200)
					surface.SetMaterial(enabled and matTick or matCross)
					surface.DrawTexturedRect(w - 32, 0, 30, 30)
				end
			end

			-- dynamic update when convar changes - simple timer check
			wrap.Think = function(self)
				-- nothing heavy; updates on click via convar toggle
			end

			return wrap
		end

		---- slider: label left, slider right ----
		if st.type == "slider" then
			local wrap = vgui.Create("DPanel", parent)
			wrap:Dock(TOP)
			wrap:DockMargin(6, 4, 6, 4)
			wrap:SetTall(36)
			wrap.Paint = function(self, w, h)
				draw.RoundedBox(6, w*0.575, 0, w*0.425, h, Color(0,0,0,120))
				draw.SimpleText(GetDisplayText(), "UVMostWantedLeaderboardFont", 10, h/2,
					color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end

			-------------------------------------------------------------
			-- Hover description functions
			-------------------------------------------------------------
			local function PushDesc()
				if descPanel then
					descPanel.Text = st.text
					descPanel.Desc = st.desc or ""
				end
			end
			local function PopDesc()
				if descPanel then
					descPanel.Text = ""
					descPanel.Desc = ""
				end
			end
			wrap.OnCursorEntered = PushDesc
			wrap.OnCursorExited  = PopDesc

			-------------------------------------------------------------
			-- Slider
			-------------------------------------------------------------
			local slider = vgui.Create("DNumSlider", wrap)
			slider:Dock(RIGHT)
			slider:SetWide(220)
			slider:DockMargin(8, 8, 6, 8)
			slider:SetMin(st.min or 0)
			slider:SetMax(st.max or 100)
			slider:SetDecimals(st.decimals or 0)
			slider:SetValue(st.min or 0)
			slider.Label:SetVisible(false)
			slider.TextArea:SetVisible(false)
			slider.OnCursorEntered = PushDesc
			slider.OnCursorExited  = PopDesc

			-------------------------------------------------------------
			-- Value box and confirm button container
			-------------------------------------------------------------
			local valPanel = vgui.Create("DPanel", wrap)
			valPanel:SetWide(84)
			valPanel:Dock(RIGHT)
			valPanel:DockMargin(4, 8, 4, 8)
			valPanel:SetPaintBackground(false)

			local valBox = vgui.Create("DTextEntry", valPanel)
			valBox:SetWide(60)
			valBox:SetPos(0,0)
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

			local applyBtn = vgui.Create("DButton", valPanel)
			applyBtn:SetSize(20, valBox:GetTall())
			applyBtn:SetPos(valBox:GetWide() + 2,0)
			applyBtn:SetText("✔")
			applyBtn:SetVisible(false)
			applyBtn.Paint = function(self2, w, h)
				draw.RoundedBox(4,0,0,w,h,self2:IsHovered() and Color(60,180,60) or Color(45,140,45))
				draw.SimpleText("✔", "UVMostWantedLeaderboardFont", w/2,h/2,color_white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			end
			applyBtn.OnCursorEntered = PushDesc
			applyBtn.OnCursorExited  = PopDesc

			-------------------------------------------------------------
			-- Value tracking
			-------------------------------------------------------------
			local appliedValue = st.min or 0
			local pendingValue = appliedValue

			local function RoundValue(val)
				if st.decimals ~= nil then
					local factor = 10 ^ st.decimals
					return math.floor(val * factor + 0.5) / factor
				end
				return val
			end

			local function ApplyPendingValue()
				local val = RoundValue(pendingValue)
				appliedValue = val
				if st.convar then RunConsoleCommand(st.convar, tostring(val)) end
				if st.func then pcall(st.func, val) end
				valBox:SetText(string.format("%."..(st.decimals or 2).."f", val))
				applyBtn:SetVisible(false)
			end

			valBox:SetText(string.format("%."..slider:GetDecimals().."f", appliedValue))
			slider:SetValue(appliedValue)

			-------------------------------------------------------------
			-- Slider -> valBox sync
			-------------------------------------------------------------
			slider.OnValueChanged = function(_, val)
				pendingValue = val
				if IsValid(valBox) then
					valBox:SetText(string.format("%."..slider:GetDecimals().."f", val))
				end
				applyBtn:SetVisible(math.abs(pendingValue - appliedValue) > 0)
			end

			-------------------------------------------------------------
			-- valBox -> slider sync
			-------------------------------------------------------------
			valBox.OnTextChanged = function(self2)
				local v = tonumber(self2:GetValue())
				if not v then return end
				pendingValue = v
				slider:SetValue(v)
				applyBtn:SetVisible(math.abs(pendingValue - appliedValue) > 0)
			end

			valBox.OnEnter = ApplyPendingValue
			applyBtn.DoClick = ApplyPendingValue

			-------------------------------------------------------------
			-- Initialize from convar
			-------------------------------------------------------------
			if st.convar then
				local cv = GetConVar(st.convar)
				if cv then
					appliedValue = cv:GetFloat()
					pendingValue = appliedValue
					slider:SetValue(appliedValue)
					valBox:SetText(string.format("%."..slider:GetDecimals().."f", appliedValue))
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
				end
			end

			wrap.OnCursorExited = function()
				if descPanel then
					descPanel.Text = ""
					descPanel.Desc = ""
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
				end
			end

			combo.OnCursorExited = function()
				if descPanel then
					descPanel.Text = ""
					descPanel.Desc = ""
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
				local bga = hovered and 200 * math.abs(math.sin(RealTime()*4)) or 125
				local bg = Color( 125, 125, 125, bga )

				-- background & text
				draw.RoundedBox(12, 0, 0, w*0.99, h, bg)
				draw.SimpleText(GetDisplayText(), "UVMostWantedLeaderboardFont", w*0.5, h*0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
			btn.DoClick = function(self)
				if st.func then st.func(self) end
				if st.convar and not st.func then
					RunConsoleCommand(st.convar)
				end
			end
			btn.OnCursorEntered = function()
				if descPanel then
					descPanel.Text = st.text
					descPanel.Desc = st.desc or ""
				end
			end
			btn.OnCursorExited = function()
				if descPanel then
					descPanel.Text = ""
					descPanel.Desc = ""
				end
			end

			return btn
		end

		---- color remains as basic DColorMixer or DColorButton (user requested keep as-is) ----
		if st.type == "color" or st.type == "coloralpha" then
			local p = vgui.Create("DPanel", parent)
			p:Dock(TOP)
			p:DockMargin(6, 6, 6, 6)
			p:SetTall(120)

			local mixer = vgui.Create("DColorMixer", p)
			mixer:Dock(FILL)
			-- hooking into convars for colors is left as an exercise for your addon specifics
			mixer.OnCursorEntered = function()
				if descPanel then
					descPanel.Text = st.text
					descPanel.Desc = st.desc or ""
				end
			end

			mixer.OnCursorExited = function()
				if descPanel then
					descPanel.Text = ""
					descPanel.Desc = ""
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

	-- Main open function (horizontal expansion, tabs icons on left which extend left on hover)
	function UV.OpenSettings()
		-- remove existing
		if IsValid(UV.SettingsFrame) then UV.SettingsFrame:Remove() end
		gui.EnableScreenClicker(true)

		local sw, sh = ScrW(), ScrH()
		local fw, fh = math.max(800, sw * 0.62), math.max(480, sh * 0.66)
		local fx, fy = (sw - fw) * 0.5, (sh - fh) * 0.5
		local watchedConvars = {}

		local frame = vgui.Create("DFrame")
		UV.SettingsFrame = frame
		frame:SetSize(0, fh)
		frame:SetPos(fx + fw * 0.5, fy)
		frame:SetTitle("")
		frame:ShowCloseButton(false)
		frame:SetDraggable(false)
		frame:MakePopup()

		frame.TargetWidth = fw
		local animStart = CurTime()
		local animDur = 0.25

		-- Right description
		local descPanel = vgui.Create("DPanel", frame)
		descPanel:Dock(RIGHT)
		descPanel:SetWide(math.Clamp(fw * 0.25, 220, 380))
		descPanel.Paint = function(self, w, h)
			surface.SetDrawColor(28,28,28,150)
			surface.DrawRect(0,0,w,h)

			if self.Text then
				local font = "UVMostWantedLeaderboardFont2"
				local color = Color(200,200,200)
				local xPadding, yPadding = 10, 10
				local wrapWidth = w - xPadding * 2
				local yOffset = yPadding

				surface.SetFont(font)

				local desc = language.GetPhrase(self.Desc or "") or ""

				for paragraph in desc:gmatch("[^\n]+") do
					local wrapped = UV_WrapText(paragraph, font, wrapWidth)

					for _, line in ipairs(wrapped) do
						draw.DrawText(line, font, xPadding, yOffset, color, TEXT_ALIGN_LEFT)
						local _, h = surface.GetTextSize(line)
						yOffset = yOffset + h
					end
				end
			end
		end

		descPanel.Text = ""
		descPanel.Desc = ""

		-- Center settings
		local center = vgui.Create("DScrollPanel", frame)
		center:Dock(FILL)
		center:DockMargin(8, 8, 8, 8)

		-- Left tabs
		local tabsPanel = vgui.Create("DPanel", frame)
		tabsPanel:Dock(LEFT)
		tabsPanel:SetWide(64)
		tabsPanel.Paint = function() end

		-- Close X (top-right of frame)
		local closeBtn = vgui.Create("DButton", frame)
		closeBtn:SetSize(20, 20)
		closeBtn:SetText("")
		closeBtn:SetFont("DermaDefaultBold")
		closeBtn.DoClick = function()
			UV.CloseSettings()
		end
		closeBtn.Paint = function(self,w,h)
			local hovered = self:IsHovered()
			draw.RoundedBox(4,0,0,w,h, hovered and Color(200,60,60) or Color(140,50,50))
			draw.SimpleText("X", "DermaDefaultBold", w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		frame.Paint = function(self,w,h)
			draw.RoundedBox(0,0,0,w,h * 0.05, Color(25, 25, 25, 225))
			
			draw.RoundedBox(0,0,0,w,h, Color(25, 25, 25, 200))
			draw.SimpleText("#uv.settings.unitvehicles", "UVFont5UI", w*0.01, h *0.025, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end

		local CURRENT_TAB = 1

		-- Build tab behavior
		local function BuildTab(tabIndex)
			center.CurrentTabIndex = tabIndex
			center:Clear()
			descPanel.Text = ""
			descPanel.Desc = ""

			local tab = UV.SettingsTable[tabIndex]
			if not tab then return end

			-- Title at top of center
			local title = vgui.Create("DLabel", center)
			-- title:SetText(tab.TabName or ("Tab " .. tostring(tabIndex)))
			-- title:SetFont("UVFont5UI")
			title:SetText("")
			title:Dock(TOP)
			title:DockMargin(6, 6, 6, 12)
			title:SetTall(36)
			
			title.Paint = function(self,w,h)
				draw.SimpleText(tab.TabName or ("Tab " .. tostring(tabIndex)), "UVFont5UI", w*0.5, h *0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end


			watchedConvars = {} -- reset

			for k2, entry in ipairs(tab) do
				if istable(entry) and entry.type then
					if entry.parentconvar then
						watchedConvars[entry.parentconvar] = true
					end
					if entry.requireparentconvar then
						watchedConvars[entry.requireparentconvar] = true
					end
				end
			end

			-- Process entries
			for k2, entry in ipairs(tab) do
				if istable(entry) and entry.type then
					-- Always build the element
					local pnl = UV.BuildSetting(center, entry, descPanel)

					-- If the element is valid, toggle visibility based on ShouldDrawSetting
					if IsValid(pnl) then
						pnl:SetVisible(UV.ShouldDrawSetting(entry))
					end
				end
			end
		end
		
		local lastValues = {}
		
		-- widget to re-center the close button as frame width animates
		frame.Think = function(self)
			local t = math.Clamp((CurTime() - animStart) / animDur, 0, 1)
			local w = Lerp(t, 0, self.TargetWidth)
			-- place the frame so it opens horizontally expanding from center leftwards:
			local x = fx + (fw * 0.5) - (w * 0.5)
			self:SetSize(w, fh)
			self:SetPos(x, fy)

			closeBtn:SetPos(self:GetWide() - 36, 8)

			-- auto-close if click happened outside
			if input.IsMouseDown(MOUSE_LEFT) then
				local mx, my = gui.MousePos()
				if mx and my then
					local fx2, fy2 = self:GetPos()
					local fw2, fh2 = self:GetSize()
					if mx < fx2 or mx > fx2 + fw2 or my < fy2 or my > fy2 + fh2 then
						-- small delay so immediate click that opened doesn't immediately close
						timer.Simple(0, function()
							if IsValid(self) then UV.CloseSettings() end
						end)
					end
				end
			end
			    
			local shouldRefresh = false
			for cvName in pairs(watchedConvars) do
				local cv = GetConVar(cvName)
				if cv then
					local val = cv:GetBool() -- only need bools for visibility
					if lastValues[cvName] ~= val then
						lastValues[cvName] = val
						shouldRefresh = true
					end
				end
			end

			if shouldRefresh then
				BuildTab(center.CurrentTabIndex)
			end
		end

		-- Create tab icons with hover popup that extends LEFT
		local TAB_START_OFFSET = 15
		local TAB_BUTTON_HEIGHT = 64
		local TAB_BUTTON_PADDING = 0
		local TAB_SIDE_PADDING = 6
		local TAB_CORNER_RADIUS = 4
		
		tabsPanel:DockPadding(0, TAB_START_OFFSET, 0, 0)

		for i, tab in ipairs(UV.SettingsTable) do
			if not UV.PlayerCanSeeSetting(tab) then
				continue -- skip this tab entirely
			end

			local btn = vgui.Create("DButton", tabsPanel)
			btn:Dock(TOP)
			btn:DockMargin(0, 0, 0, TAB_BUTTON_PADDING)
			btn:SetTall(TAB_BUTTON_HEIGHT)
			btn:SetText("")

			btn.Paint = function(self, w, h)
				local isSelected = (CURRENT_TAB == i)
				local hovered = self:IsHovered()

				local bga = hovered and 175 or 75
				local bg = isSelected and Color(255, 255, 255, bga) or Color(125, 125, 125, bga)

				draw.RoundedBox(TAB_CORNER_RADIUS, TAB_SIDE_PADDING, 4, w - TAB_SIDE_PADDING*2, h - 8, bg)

				-- Draw icon dynamically scaled
				if tab.Icon then
					local mat = Material(tab.Icon, "smooth")

					local iconSize = h * 0.75       -- Scales with button height
					local iconX = TAB_SIDE_PADDING + 2
					local iconY = (h - iconSize) / 2

					surface.SetDrawColor(255,255,255, hovered and 255 or 200)
					surface.SetMaterial(mat)
					surface.DrawTexturedRect(iconX, iconY, iconSize, iconSize)
				else
					draw.SimpleText(tab.TabName or "Tab",
						"UVMostWantedLeaderboardFont",
						w/2, h/2,
						color_white,
						TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
			end

			-- Hover pop-up name
			local hoverPopup
			btn.OnCursorEntered = function(self)
				if IsValid(hoverPopup) then hoverPopup:Remove() end

				hoverPopup = vgui.Create("DPanel")
				local pw, ph = ScrW()*0.15, 32
				local sx, sy = self:LocalToScreen(0, 8)

				hoverPopup:SetPos(sx - pw - 6, sy)
				hoverPopup:SetSize(pw, ph)

				hoverPopup.Paint = function(_, w, h)
					draw.RoundedBox(6, 0, 0, w, h, Color(30,30,30,220))
					draw.SimpleText(tab.TabName or "",
						"UVMostWantedLeaderboardFont",
						w/2, h/2,
						color_white,
						TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end

				self._hoverPopup = hoverPopup
			end

			btn.OnCursorExited = function(self)
				if IsValid(self._hoverPopup) then
					self._hoverPopup:Remove()
					self._hoverPopup = nil
				end
			end

			btn.DoClick = function()
				CURRENT_TAB = i
				BuildTab(i)
				tabsPanel:InvalidateLayout(true) -- force repaint of buttons
			end

			if i == 1 then BuildTab(1) end
		end

		-- Remove focus when frame removed
		frame.OnRemove = function()
			gui.EnableScreenClicker(false)
		end
	end

end -- End of CLIENT Section