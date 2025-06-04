local Colors = {
    ["MW_LocalPlayer"] = Color(223, 184, 127), --Color(255, 187, 0),
    ["MW_Accent"] = Color(223, 184, 127),
    ["MW_Others"] = Color(255, 255, 255),
    ["MW_Disqualified"] = Color(255, 50, 50, 133),
    ["MW_Cop"] = Color(61, 184, 255, 107),
    ["MW_CopShade"] = Color(41, 149, 212, 107),
    ["MW_Racer"] = Color(255, 221, 142, 107),
    ["MW_RacerShade"] = Color(166, 142, 85, 107),
    --
    ["Carbon_Accent"] = Color(86, 214, 205),
    ["Carbon_AccentTransparent"] = Color(86, 214, 205, 50),
    ["Carbon_AccentDarker"] = Color(62, 153, 145),
    ["Carbon_Accent2"] = Color(168, 168, 168),
    ["Carbon_Accent2Bright"] = Color(189, 189, 189),
    ["Carbon_Accent2Transparent"] = Color(168, 168, 168, 100),
    ["Carbon_LocalPlayer"] = Color(86, 214, 205),
    ["Carbon_Others"] = Color(255, 255, 255),
    ["Carbon_OthersDark"] = Color(255, 255, 255, 121),
    ["Carbon_Disqualified"] = Color(255, 50, 50, 133),
    --
    ["Original_LocalPlayer"] = Color(255, 217, 0),
    ["Original_Others"] = Color(255, 255, 255),
    ["Original_Disqualified"] = Color(255, 50, 50, 133),
    --
    ["Undercover_Accent1"] = Color(255, 255, 255),
    ["Undercover_Accent2"] = Color(187, 226, 220),
    ["Undercover_Accent2Transparent"] = Color(187, 226, 220, 150)
}

UVMaterials = {
    ["RACE_COUNTDOWN_BG"] = Material("unitvehicles/hud/COUNTDOWN_BG.png"),
	
    ["UNITS_DAMAGED"] = Material("unitvehicles/icons/COPS_DAMAGED_ICON.png"),
    ["UNITS_DISABLED"] = Material("unitvehicles/icons/COPS_TAKENOUT_ICON.png"),
    ["UNITS"] = Material("unitvehicles/icons/COPS_ICON.png"),
    ["HEAT"] = Material("unitvehicles/icons/HEAT_ICON.png"),
    ["CLOCK"] = Material("unitvehicles/icons/TIMER_ICON.png"),
    ["CLOCK_BG"] = Material("unitvehicles/icons/TIMER_ICON_BG.png", "smooth mips"),
    ["CHECK"] = Material("unitvehicles/icons/MINIMAP_ICON_CIRCUIT.png"),
    ["RESULTCOP"] = Material("unitvehicles/icons/(9)T_UI_PlayerCop_Large_Icon.png"),
    ["RESULTRACER"] = Material("unitvehicles/icons/(9)(9)T_UI_PlayerRacer_Large_Icon.png"),
    ["HIDECAR"] = Material("unitvehicles/icons/HIDE_CAR_ICON.png"),
	
    ["RACE_BG_POS"] = Material("unitvehicles/hud/POSITION_BACKING.png"),
    ["RACE_BG_TIME"] = Material("unitvehicles/hud/TIME_BACKING.png"),
	
    ["PURSUIT_BG_TOP"] = Material("unitvehicles/hud/PURSUIT_BACKING_TOP.png"),
    ["PURSUIT_BG_BOTTOM"] = Material("unitvehicles/hud/PURSUIT_BACKING_BOTTOM.png"),
    ["PURSUIT_BG_PULSE"] = Material("unitvehicles/hud/PURSUIT_LEADERLIST_PULSE.png"),
	
    ["PURSUIT_BG_BOTBAR"] = Material("unitvehicles/hud/OUTRUN_BACKING.png"),
    ["PURSUIT_BG_BOTBAR_ALT"] = Material("unitvehicles/hud/OUTRUN_BACKING_ALT.png"),
	
    ["BACKGROUND"] = Material("unitvehicles/hud/NFSMW_BACKGROUND.png"),
    ["BACKGROUND_BIG"] = Material("unitvehicles/hud/NFSMW_BACKGROUND_BIG.png"),
    ["BACKGROUND_BIGGER"] = Material("unitvehicles/hud/NFSMW_BACKGROUND_BIGGER.png"),
	
-- Carbon
    ["UNITS_DISABLED_CARBON"] = Material("unitvehicles/icons_carbon/COPS_DESTROYED.png"),
    ["UNITS_CARBON"] = Material("unitvehicles/icons_carbon/COPS_INVOLVED.png"),
    ["HEAT_CARBON"] = Material("unitvehicles/icons_carbon/FLASHER_ICON_HEAT.png"),

    ["ARROW_CARBON"] = Material("unitvehicles/hud_carbon/NFSC_ARROWRIGHT.png"),
    ["BACKGROUND_CARBON"] = Material("unitvehicles/hud_carbon/NFSC_GRADIENT.png"),
    ["BACKGROUND_CARBON_INVERTED"] = Material("unitvehicles/hud_carbon/NFSC_GRADIENT_INV.png"),
    ["BACKGROUND_CARBON_SMALL"] = Material("unitvehicles/hud_carbon/NFSC_GRADIENT_SMALL.png"),
    ["BACKGROUND_CARBON_SMALL_INVERTED"] = Material("unitvehicles/hud_carbon/NFSC_GRADIENT_SMALL_INV.png"),
    ["BACKGROUND_CARBON_SOLID"] = Material("unitvehicles/hud_carbon/NFSC_GRADIENT_SOLID.png"),
    ["BACKGROUND_CARBON_SOLID_INVERTED"] = Material("unitvehicles/hud_carbon/NFSC_GRADIENT_SOLID_INV.png"),
	
    ["BACKGROUND_CARBON_FILLED"] = Material("unitvehicles/hud_carbon/NFSC_GRADIENT_FILLED.png"),
    ["BACKGROUND_CARBON_FILLED_INVERTED"] = Material("unitvehicles/hud_carbon/NFSC_GRADIENT_FILLED_INV.png"),
	
    ["X_OUTER_CARBON"] = Material("unitvehicles/hud_carbon/SHAPE_INGAME_OUTLINE.png"),
    ["EOC_FRAME_CARBON"] = Material("unitvehicles/hud_carbon/PC_HELP_FRAME_LONG.png"),
		
-- Undercover
    ["ARREST_BG_UC"] = Material("unitvehicles/hud_undercover/BUSTED_HEADER.png"),
    ["ARREST_LIGHT_UC"] = Material("unitvehicles/hud_undercover/BUSTED_COPLIGHT_BG.png"),
	
    ["UNITS_DISABLED_UC"] = Material("unitvehicles/icons_undercover/HUD_COP_TAKEDOWN_ICON.png"),
    ["CTS_UC"] = Material("unitvehicles/icons_undercover/HUD_CTS_ICON.png"),
	
    ["BUSTED_ICON_UC"] = Material("unitvehicles/icons_undercover/BUST_COP_ICON.png", "smooth mips"),
    ["BUSTED_ICON_UC_GLOW"] = Material("unitvehicles/icons_undercover/BUSTED_ICON_GLOW.png", "smooth mips"),
    ["EVADE_ICON_UC"] = Material("unitvehicles/icons_undercover/EVADE_CAR_ICON.png", "smooth mips"),
    ["EVADE_ICON_UC_GLOW"] = Material("unitvehicles/icons_undercover/EVADE_ICON_GLOW.png", "smooth mips"),
}

function Carbon_FormatRaceTime(curTime)
    local minutes = math.floor(curTime / 60)
    local seconds = math.floor(curTime % 60)
    local milliseconds = math.floor((curTime % 1) * 100)
    
    if minutes > 0 then
        return string.format("%d:%02d.%02d", minutes, seconds, milliseconds)
    else
        return string.format("%01d.%02d", seconds, milliseconds)
    end
end

UV_UI = {}

for _, v in pairs( {'racing', 'pursuit'} ) do
    UV_UI[v] = {}
end

-- Universal
UV_UI.general = {}

local function uv_general( ... )
	local w = ScrW()
    local h = ScrH()		
	local vehicle = LocalPlayer():GetVehicle()
	local localPlayer = LocalPlayer()
    local lang = language.GetPhrase
		
	if not KeyBindButtons then
		KeyBindButtons = {}
	end

	if UVHUDPursuitTech then
		local PT_Replacement_Strings = {
			['ESF'] = '#uv.ptech.esf.short',
			['Killswitch'] = '#uv.ptech.killswitch.short',
			['Jammer'] = '#uv.ptech.jammer.short',
			['Shockwave'] = '#uv.ptech.shockwave.short',
			['Stunmine'] = '#uv.ptech.stunmine.short',
			['Spikestrip'] = '#uv.ptech.spikes.short',
			['Repair Kit'] = '#uv.ptech.repairkit.short'
		}
		
		local BindTextReplace = {
			KP_INS = "KP 0",
			KP_END = "KP 1",
			KP_DOWNARROW = "KP 2",
			KP_PGDN = "KP 3",
			KP_LEFTARROW = "KP 4",
			KP_5 = "KP 5",
			KP_RIGHTARROW = "KP 6",
			KP_HOME = "KP 7",
			KP_UPARROW = "KP 8",
			KP_PGUP = "KP 9",
			KP_SLASH = "KP /",
			KP_MULTIPLY = "KP *",
			KP_MINUS = "KP -",
			KP_PLUS = "KP +",
			KP_ENTER = "KP ENTER",
			KP_DEL = "KP .",
		}

		if !uvclientjammed then
			for i=1, 2, 1 do
				local var = GetConVar('unitvehicle_pursuittech_keybindslot_'..i):GetInt()

				local function GetFriendlyKeyName(var)
					local keyName = input.GetKeyName(var)
					if not keyName then return "UNKNOWN" end

					local upperKeyName = string.upper(keyName)
					return BindTextReplace[upperKeyName] or keyName
				end

				if UVHUDPursuitTech[i] then
					if input.IsKeyDown(var) and !gui.IsGameUIVisible() and vgui.GetKeyboardFocus() == nil then
						net.Start("UVPTUse")
						net.WriteInt(i, 16)
						net.SendToServer()
					end

					if UVHUDPursuitTech[i].Ammo > 0 and CurTime() - UVHUDPursuitTech[i].LastUsed <= UVHUDPursuitTech[i].Cooldown then
						local cooldown = UVHUDPursuitTech[i].Cooldown
						local time_since_used = CurTime() - UVHUDPursuitTech[i].LastUsed
						local sanitized_cooldown = math.Round(cooldown - time_since_used, 1)
						
						local blink = 255 * math.abs(math.sin(RealTime() * 3))

						local x = w * (0.8575 + ((i - 1) * 0.05))
						local y = h * 0.6
						local bw = w * 0.0475
						local bh = h * 0.05

						-- Background
						surface.SetDrawColor(0, 0, 0, 200)
						surface.DrawRect(x, y, bw, bh)

						-- Cooldown fill overlay
						local fill_frac = math.Clamp(time_since_used / cooldown, 0, 1)
						local fill_width = bw * fill_frac
						surface.SetDrawColor(blink, blink, 0, 100)
						surface.DrawRect(x, y, fill_width, bh)

						draw.DrawText( GetFriendlyKeyName(var), "UVFont4", w * (0.88 + ((i - 1) * 0.05)), h * 0.575, Color(255, 255, 255, 125), TEXT_ALIGN_CENTER )

						draw.DrawText(
							(PT_Replacement_Strings[UVHUDPursuitTech[i].Tech] or UVHUDPursuitTech[i].Tech) ..
							"\n"..UVHUDPursuitTech[i].Ammo,
							"UVFont4",
							w * (0.88 + ((i - 1) * 0.05)),
							h * 0.6,
							Color(255, 255, 255, 125),
							TEXT_ALIGN_CENTER
						)
					else
						local kbc = Color(255, 255, 255)
						
						local x = w * (0.8575 + ((i - 1) * 0.05))
						local y = h * 0.6
						local bw = w * 0.0475
						local bh = h * 0.05

						-- Background
						if UVHUDPursuitTech[i].Ammo > 0 then
							surface.SetDrawColor( 0, 200, 0, 200 )
						else
							surface.SetDrawColor( 200, 0, 0, 100 )
							kbc = Color(200, 50, 50, 255)
						end
						surface.DrawRect(x, y, bw, bh)
						
						draw.DrawText( GetFriendlyKeyName(var), "UVFont4", w * (0.88 + ((i - 1) * 0.05)), h * 0.575, kbc, TEXT_ALIGN_CENTER )

						draw.DrawText(
							(PT_Replacement_Strings[UVHUDPursuitTech[i].Tech] or UVHUDPursuitTech[i].Tech) ..
							"\n"..(UVHUDPursuitTech[i].Ammo > 0 and UVHUDPursuitTech[i].Ammo or " - "),
							"UVFont4",
							w * (0.88 + ((i - 1) * 0.05)),
							h * 0.6,
							(UVHUDPursuitTech[i].Ammo > 0 and Color(255,255,255)) or Color(255,75,75),
							TEXT_ALIGN_CENTER
						)
					end
				else
					draw.DrawText(
						GetFriendlyKeyName(var) .. "\n" ..
						" - " ..
						"\n ",
						"UVFont4",
						w * (0.88 + ((i - 1) * 0.05)),
						h * 0.6,
						Color( 255, 255, 255, 166),
						TEXT_ALIGN_CENTER
					)
				end
			end
		else
			draw.DrawText(
				"#uv.ptech.jammer.hit.you",
				"UVFont4",
				w * 0.925,
				h * 0.6,
				Color( 255, 255, 255, 166),
				TEXT_ALIGN_RIGHT
			)
		end
	end
end

UV_UI.general.main = uv_general

-- Carbon
UV_UI.racing.carbon = {}
UV_UI.pursuit.carbon = {}

UV_UI.pursuit.carbon.states = {
    TagsColor = Color(255,255,255,150),
    WrecksColor = Color(255,255,255,150),
    UnitsColor = Color(255,255,255,150),
    BustedColor = Color(255, 255, 255, 50),
    EvasionColor = Color(255, 255, 255, 50),
}

UV_UI.racing.carbon.events = {
    onRaceEnd = function(...)
        print( 'onRaceEnd', ... )
    end
}

UV_UI.pursuit.carbon.events = {
    onUnitDeploy = function(...)
        local new_value = select (1, ...)
        local old_value = select (2, ...)

        print(new_value, old_value)
    end,
    -- _onUpdate = function( data_name, ...)
    --     if data_name == 'Wrecks' then
    --         UV_UI.pursuit.mostwanted.callbacks.onUnitWreck( ... )
    --     elseif data_name == 'Tags' then
    --         UV_UI.pursuit.mostwanted.callbacks.onUnitTag( ... )
    --     elseif data_name == 'ChasingUnits' then
    --         UV_UI.pursuit.mostwanted.callbacks.onChasingUnitsChange( ... )
    --     end
    -- end,
    onUnitWreck = function(...)
        
        hook.Remove("Think", "MW_WRECKS_COLOR_PULSE")
        
        if timer.Exists("MW_WRECKS_COLOR_PULSE_DELAY") then timer.Remove("MW_WRECKS_COLOR_PULSE_DELAY") end
        UV_UI.pursuit.mostwanted.states.WrecksColor = Color(255,255,0, 150)
        
        timer.Create("MW_WRECKS_COLOR_PULSE_DELAY", 1, 1, function()
            hook.Add("Think", "MW_WRECKS_COLOR_PULSE", function()
                UV_UI.pursuit.mostwanted.states.WrecksColor.b = UV_UI.pursuit.mostwanted.states.WrecksColor.b + 600 * RealFrameTime()
                if UV_UI.pursuit.mostwanted.states.WrecksColor.b >= 255 then hook.Remove("Think", "MW_WRECKS_COLOR_PULSE") end
            end)
        end)
        
    end,
    onUnitTag = function(...)
        
        hook.Remove("Think", "MW_TAGS_COLOR_PULSE")
        if timer.Exists("MW_TAGS_COLOR_PULSE_DELAY") then timer.Remove("MW_TAGS_COLOR_PULSE_DELAY") end
        
        UV_UI.pursuit.mostwanted.states.TagsColor = Color(255,255,0, 150)
        
        timer.Create("MW_TAGS_COLOR_PULSE_DELAY", 1, 1, function()
            
            hook.Add("Think", "MW_TAGS_COLOR_PULSE", function()
                UV_UI.pursuit.mostwanted.states.TagsColor.b = UV_UI.pursuit.mostwanted.states.TagsColor.b + 600 * RealFrameTime()
                if UV_UI.pursuit.mostwanted.states.TagsColor.b >= 255 then hook.Remove("Think", "MW_TAGS_COLOR_PULSE") end
            end)
            
        end)
        
    end,
    onResourceChange = function(...)
        
        local new_data = select( 1, ... )
        local old_data = select( 2, ... )
        
        hook.Remove("Think", "MW_RP_COLOR_PULSE")
        UV_UI.pursuit.mostwanted.states.UnitsColor = (new_data < (old_data or 0) and Color(255,50,50, 150)) or Color(50,255,50, 150)
        --UVResourcePointsColor = (rp_num < UVResourcePoints and Color(255,50,50)) or Color(50,255,50)
        
        local clrs = {}
        
        for _, v in pairs( { 'r', 'g', 'b' } ) do
            if UV_UI.pursuit.mostwanted.states.UnitsColor[v] ~= 255 then table.insert(clrs, v) end
        end 
        
        -- if timer.Exists("UVWrecksColor") then
        -- 	timer.Remove("UVWrecksColor")
        -- end
        local val = 50
        
        hook.Add("Think", "MW_RP_COLOR_PULSE", function()
            val = val + 200 * RealFrameTime()
            -- UVResourcePointsColor.b = val
            -- UVResourcePointsColor.g = val
            for _, v in pairs( clrs ) do
                UV_UI.pursuit.mostwanted.states.UnitsColor[v] = val
            end
            
            if val >= 255 then hook.Remove("Think", "MW_RP_COLOR_PULSE") end
        end)
        
    end,
    onChasingUnitsChange = function(...)
        
    end,
    onHeatLevelUpdate = function(...)
        
    end,
    onCopBustedDebrief = function(...)
        local w = ScrW()
		local h = ScrH()

        local bustedtable = select( 1, ... )

        --------------------------------------

        local time = UVDisplayTime(UVTimerProgress)
		local deploys = bustedtable["Deploys"]
		local roadblocksdodged = bustedtable["Roadblocks"]
		local spikestripsdodged = bustedtable["Spikestrips"]
		local bounty = UVBounty
		local tags = UVTags
		local wrecks = UVWrecks
		local suspects = UVHUDWantedSuspectsNumber
		
		local ResultPanel = vgui.Create("DFrame")
		local OK = vgui.Create("DButton")
		
		ResultPanel:Add(OK)
		ResultPanel:SetSize(w, h)
		ResultPanel:SetBackgroundBlur(true)
		ResultPanel:ShowCloseButton(false)
		ResultPanel:Center()
		ResultPanel:SetTitle("")
		ResultPanel:SetDraggable(false)
		ResultPanel:MakePopup()
		ResultPanel:SetKeyboardInputEnabled(false)

		OK:SetText("X")
		OK:SetSize(w*0.015, h*0.03)
		OK:SetPos(w*0.725, h*0.205)
		
		local timetotal = 30
		local timestart = CurTime()
		
		ResultPanel.Paint = function(self, w, h)
			local timeremaining = math.ceil(timetotal - (CurTime() - timestart))
			local lang = language.GetPhrase

			-- Main black BG
			surface.SetDrawColor( 0, 0, 0, 200 )
			surface.DrawRect( 0, 0, w, h)
			
			-- Upper Results Tab
			surface.SetDrawColor( 0, 0, 0, 235 )
			surface.DrawRect( w*0.25, h*0.185, w*0.5, h*0.075)
			
			surface.SetMaterial(UVMaterials['EOC_FRAME_CARBON'])
			surface.SetDrawColor(86, 214, 205)
			surface.DrawTexturedRect( w*0.26, h*0.17825, w*0.485, h*0.09)

			DrawIcon( UVMaterials['X_OUTER_CARBON'], w*0.255, h*0.215, 0.2, Color(0,0,0) ) -- Icon
			DrawIcon( Material("unitvehicles/hud_carbon/x_anim"), w*0.255, h*0.215, 0.2, Color(255,255,255) ) -- Animated Icon; TBD

			draw.DrawText( "★" .. lang("uv.results.pursuit.carbon") .. "★", "UVCarbonFont", w*0.3, h*0.2, Color( 255, 255, 255), TEXT_ALIGN_LEFT )
			
			-- Next Lower, results subtext
			-- surface.SetMaterial(UVMaterials['BACKGROUND_BIGGER'])
			surface.SetDrawColor( 0, 0, 0, 235 )
			surface.DrawRect( w*0.25, h*0.3, w*0.5, h*0.03)
			
			draw.DrawText( "#uv.results.chase.item.carbon", "UVCarbonLeaderboardFont", w*0.2565, h*0.3025, Color( 255, 255, 255), TEXT_ALIGN_LEFT )
			
			draw.DrawText( "#uv.results.chase.value.carbon", "UVCarbonLeaderboardFont", w*0.74, h*0.3025, Color( 255, 255, 255), TEXT_ALIGN_RIGHT )
			
			-- All middle tabs, light ones
			local numRectsLight = 3
			for i=0, numRectsLight, 1 do
				local yPos = i * h * 0.08
				surface.SetMaterial(UVMaterials['BACKGROUND_CARBON_FILLED'])
				surface.SetDrawColor( 86, 214, 205, 100 )
				surface.DrawTexturedRect( w*0.25, h*0.34 + yPos, w*0.485, h*0.035)
				
				surface.SetMaterial(UVMaterials['ARROW_CARBON'])
				surface.DrawTexturedRect( w*0.735, h*0.34 + yPos, w*0.015, h*0.035)
			end
			
			-- All middle tabs, dark ones
			local numRectsDark = 3
			for i=0, numRectsDark, 1 do
				local yPos = i * h * 0.08
				surface.SetMaterial(UVMaterials['BACKGROUND_CARBON_FILLED'])
				surface.SetDrawColor( 86, 214, 205, 25 )
				surface.DrawTexturedRect( w*0.25, h*0.38 + yPos, w*0.485, h*0.035)
				
				surface.SetMaterial(UVMaterials['ARROW_CARBON'])
				surface.DrawTexturedRect( w*0.735, h*0.38 + yPos, w*0.015, h*0.035)
			end
			
			local h1, h2 = h*0.3825, h*0.4225
			
			-- Text
			draw.DrawText( "#uv.results.suspects.busted", "UVCarbonLeaderboardFont", w*0.2565, h*0.3425, Color( 255, 255, 0), TEXT_ALIGN_LEFT )

			draw.SimpleText( "#uv.results.chase.bounty", "UVCarbonLeaderboardFont", w*0.2565, h1, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.time", "UVCarbonLeaderboardFont", w*0.2565, h2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.units.deployed", "UVCarbonLeaderboardFont", w*0.2565, h1 + h*0.08, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.units.damaged", "UVCarbonLeaderboardFont", w*0.2565, h2 + h*0.08, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.units.destroyed", "UVCarbonLeaderboardFont", w*0.2565, h1 + h*0.16, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.dodged.blocks", "UVCarbonLeaderboardFont", w*0.2565, h2 + h*0.16, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.dodged.spikes", "UVCarbonLeaderboardFont", w*0.2565, h1 + h*0.24, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			
			-- draw.SimpleText( unit, "UVCarbonLeaderboardFont", w*0.74, h*0.3425, Color( 255, 255, 0), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			
			draw.SimpleText( bounty, "UVCarbonLeaderboardFont", w*0.74, h1, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( time, "UVCarbonLeaderboardFont", w*0.74, h2, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( deploys, "UVCarbonLeaderboardFont", w*0.74, h1 + h*0.08, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( tags, "UVCarbonLeaderboardFont", w*0.74, h2 + h*0.08, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( wrecks, "UVCarbonLeaderboardFont", w*0.74, h1 + h*0.16, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( roadblocksdodged, "UVCarbonLeaderboardFont", w*0.74, h2 + h*0.16, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( spikestripsdodged, "UVCarbonLeaderboardFont", w*0.74, h1 + h*0.24, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			
			
			-- Time remaining and closing
			surface.SetDrawColor( 100, 100, 100, 125 )
			surface.DrawRect( w*0.2565, h*0.675, w*0.485, h*0.035)
			
			draw.DrawText( "( " .. input.LookupBinding("+jump") .. " ) " .. lang("uv.results.continue"), "UVCarbonLeaderboardFont", w*0.2585, h*0.6785, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT )
			draw.DrawText( string.format( language.GetPhrase("uv.results.autoclose"), timeremaining ), "UVCarbonLeaderboardFont", w*0.74, h*0.6785, Color( 255, 255, 255 ), TEXT_ALIGN_RIGHT )
			
			if timeremaining < 1 then
				hook.Remove("Think", "CheckJumpKeyForDebrief")
				self:Close()
			end
			
		end
		
		function OK:DoClick() 
			hook.Remove("Think", "CheckJumpKeyForDebrief")
			ResultPanel:Close()
		end
		
		local wasJumping = false
		hook.Add("Think", "CheckJumpKeyForDebrief", function()
			local ply = LocalPlayer()
			if not IsValid(ply) then return end
			
			if ply:KeyDown(IN_JUMP) then
				if not wasJumping then
					wasJumping = true
					if IsValid(ResultPanel) then
						ResultPanel:Close()
						hook.Remove("Think", "CheckJumpKeyForDebrief")
					end
				end
			else
				wasJumping = false
			end
		end)
    end,
    onCopEscapedDebrief = function(...)

        local w = ScrW()
		local h = ScrH()

        local escapedtable = select( 1, ... )

        --------------------------------------

        local time = UVDisplayTime(UVTimerProgress)
		local deploys = escapedtable["Deploys"]
		local roadblocksdodged = escapedtable["Roadblocks"]
		local spikestripsdodged = escapedtable["Spikestrips"]
		local bounty = UVBounty
		local tags = UVTags
		local wrecks = UVWrecks
		local suspects = UVHUDWantedSuspectsNumber
		
		local ResultPanel = vgui.Create("DFrame")
		local OK = vgui.Create("DButton")
		
		ResultPanel:Add(OK)
		ResultPanel:SetSize(w, h)
		ResultPanel:SetBackgroundBlur(true)
		ResultPanel:ShowCloseButton(false)
		ResultPanel:Center()
		ResultPanel:SetTitle("")
		ResultPanel:SetDraggable(false)
		ResultPanel:MakePopup()
		ResultPanel:SetKeyboardInputEnabled(false)

		OK:SetText("X")
		OK:SetSize(w*0.015, h*0.03)
		OK:SetPos(w*0.725, h*0.205)
		
		local timetotal = 30
		local timestart = CurTime()
		
		ResultPanel.Paint = function(self, w, h)
			local timeremaining = math.ceil(timetotal - (CurTime() - timestart))
			local lang = language.GetPhrase

			-- Main black BG
			surface.SetDrawColor( 0, 0, 0, 200 )
			surface.DrawRect( 0, 0, w, h)
			
			-- Upper Results Tab
			surface.SetDrawColor( 0, 0, 0, 235 )
			surface.DrawRect( w*0.25, h*0.185, w*0.5, h*0.075)
			
			surface.SetMaterial(UVMaterials['EOC_FRAME_CARBON'])
			surface.SetDrawColor(86, 214, 205)
			surface.DrawTexturedRect( w*0.26, h*0.17825, w*0.485, h*0.09)

			DrawIcon( UVMaterials['X_OUTER_CARBON'], w*0.255, h*0.215, 0.2, Color(0,0,0) ) -- Icon
			DrawIcon( Material("unitvehicles/hud_carbon/x_anim"), w*0.255, h*0.215, 0.2, Color(255,255,255) ) -- Animated Icon; TBD

			draw.DrawText( "★" .. lang("uv.results.pursuit.carbon") .. "★", "UVCarbonFont", w*0.3, h*0.2, Color( 255, 255, 255), TEXT_ALIGN_LEFT )
			
			-- Next Lower, results subtext
			-- surface.SetMaterial(UVMaterials['BACKGROUND_BIGGER'])
			surface.SetDrawColor( 0, 0, 0, 235 )
			surface.DrawRect( w*0.25, h*0.3, w*0.5, h*0.03)
			
			draw.DrawText( "#uv.results.chase.item.carbon", "UVCarbonLeaderboardFont", w*0.2565, h*0.3025, Color( 255, 255, 255), TEXT_ALIGN_LEFT )
			
			draw.DrawText( "#uv.results.chase.value.carbon", "UVCarbonLeaderboardFont", w*0.74, h*0.3025, Color( 255, 255, 255), TEXT_ALIGN_RIGHT )
			
			-- All middle tabs, light ones
			local numRectsLight = 3
			for i=0, numRectsLight, 1 do
				local yPos = i * h * 0.08
				surface.SetMaterial(UVMaterials['BACKGROUND_CARBON_FILLED'])
				surface.SetDrawColor( 86, 214, 205, 100 )
				surface.DrawTexturedRect( w*0.25, h*0.34 + yPos, w*0.485, h*0.035)
				
				surface.SetMaterial(UVMaterials['ARROW_CARBON'])
				surface.DrawTexturedRect( w*0.735, h*0.34 + yPos, w*0.015, h*0.035)
			end
			
			-- All middle tabs, dark ones
			local numRectsDark = 3
			for i=0, numRectsDark, 1 do
				local yPos = i * h * 0.08
				surface.SetMaterial(UVMaterials['BACKGROUND_CARBON_FILLED'])
				surface.SetDrawColor( 86, 214, 205, 25 )
				surface.DrawTexturedRect( w*0.25, h*0.38 + yPos, w*0.485, h*0.035)
				
				surface.SetMaterial(UVMaterials['ARROW_CARBON'])
				surface.DrawTexturedRect( w*0.735, h*0.38 + yPos, w*0.015, h*0.035)
			end
			
			local h1, h2 = h*0.3825, h*0.4225
			
			-- Text
			draw.DrawText( "#uv.results.suspects.escaped.num.carbon", "UVCarbonLeaderboardFont", w*0.2565, h*0.3425, Color( 255, 255, 0), TEXT_ALIGN_LEFT )
			
			draw.SimpleText( "#uv.results.chase.bounty", "UVCarbonLeaderboardFont", w*0.2565, h1, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.time", "UVCarbonLeaderboardFont", w*0.2565, h2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.units.deployed", "UVCarbonLeaderboardFont", w*0.2565, h1 + h*0.08, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.units.damaged", "UVCarbonLeaderboardFont", w*0.2565, h2 + h*0.08, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.units.destroyed", "UVCarbonLeaderboardFont", w*0.2565, h1 + h*0.16, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.dodged.blocks", "UVCarbonLeaderboardFont", w*0.2565, h2 + h*0.16, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.dodged.spikes", "UVCarbonLeaderboardFont", w*0.2565, h1 + h*0.24, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			
			draw.SimpleText( UVHUDWantedSuspectsNumber, "UVCarbonLeaderboardFont", w*0.74, h*0.3425, Color( 255, 255, 0), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			
			draw.SimpleText( bounty, "UVCarbonLeaderboardFont", w*0.74, h1, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( time, "UVCarbonLeaderboardFont", w*0.74, h2, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( deploys, "UVCarbonLeaderboardFont", w*0.74, h1 + h*0.08, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( tags, "UVCarbonLeaderboardFont", w*0.74, h2 + h*0.08, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( wrecks, "UVCarbonLeaderboardFont", w*0.74, h1 + h*0.16, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( roadblocksdodged, "UVCarbonLeaderboardFont", w*0.74, h2 + h*0.16, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( spikestripsdodged, "UVCarbonLeaderboardFont", w*0.74, h1 + h*0.24, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			
			
			-- Time remaining and closing
			surface.SetDrawColor( 100, 100, 100, 125 )
			surface.DrawRect( w*0.2565, h*0.675, w*0.485, h*0.035)
			
			draw.DrawText( "( " .. input.LookupBinding("+jump") .. " ) " .. lang("uv.results.continue"), "UVCarbonLeaderboardFont", w*0.2585, h*0.6785, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT )
			draw.DrawText( string.format( language.GetPhrase("uv.results.autoclose"), timeremaining ), "UVCarbonLeaderboardFont", w*0.74, h*0.6785, Color( 255, 255, 255 ), TEXT_ALIGN_RIGHT )
			
			if timeremaining < 1 then
				hook.Remove("Think", "CheckJumpKeyForDebrief")
				self:Close()
			end
			
		end
		
		function OK:DoClick() 
			hook.Remove("Think", "CheckJumpKeyForDebrief")
			ResultPanel:Close()
		end
		
		local wasJumping = false
		hook.Add("Think", "CheckJumpKeyForDebrief", function()
			local ply = LocalPlayer()
			if not IsValid(ply) then return end
			
			if ply:KeyDown(IN_JUMP) then
				if not wasJumping then
					wasJumping = true
					if IsValid(ResultPanel) then
						ResultPanel:Close()
						hook.Remove("Think", "CheckJumpKeyForDebrief")
					end
				end
			else
				wasJumping = false
			end
		end)
    end,
    onRacerEscapedDebrief = function(...)
        if UVHUDRace then return end
		
		local w = ScrW()
		local h = ScrH()

        local escapedtable = select( 1, ... )

        --------------------------------------

        local time = UVDisplayTime(UVTimerProgress)
		local deploys = escapedtable["Deploys"]
		local roadblocksdodged = escapedtable["Roadblocks"]
		local spikestripsdodged = escapedtable["Spikestrips"]
		local bounty = UVBounty
		local tags = UVTags
		local wrecks = UVWrecks
		
		local ResultPanel = vgui.Create("DFrame")
		local OK = vgui.Create("DButton")
		
		ResultPanel:Add(OK)
		ResultPanel:SetSize(w, h)
		ResultPanel:SetBackgroundBlur(true)
		ResultPanel:ShowCloseButton(false)
		ResultPanel:Center()
		ResultPanel:SetTitle("")
		ResultPanel:SetDraggable(false)
		ResultPanel:MakePopup()
		ResultPanel:SetKeyboardInputEnabled(false)
		
		OK:SetText("X")
		OK:SetSize(w*0.015, h*0.03)
		OK:SetPos(w*0.725, h*0.205)
		
		local timetotal = 30
		local timestart = CurTime()
		
		ResultPanel.Paint = function(self, w, h)
			local timeremaining = math.ceil(timetotal - (CurTime() - timestart))
			local lang = language.GetPhrase

			-- Main black BG
			surface.SetDrawColor( 0, 0, 0, 200 )
			surface.DrawRect( 0, 0, w, h)
			
			-- Upper Results Tab
			surface.SetDrawColor( 0, 0, 0, 235 )
			surface.DrawRect( w*0.25, h*0.185, w*0.5, h*0.075)
			
			surface.SetMaterial(UVMaterials['EOC_FRAME_CARBON'])
			surface.SetDrawColor(86, 214, 205)
			surface.DrawTexturedRect( w*0.26, h*0.17825, w*0.485, h*0.09)

			DrawIcon( UVMaterials['X_OUTER_CARBON'], w*0.255, h*0.215, 0.2, Color(0,0,0) ) -- Icon
			DrawIcon( Material("unitvehicles/hud_carbon/x_anim"), w*0.255, h*0.215, 0.2, Color(255,255,255) ) -- Animated Icon; TBD

			draw.DrawText( "★" .. lang("uv.results.pursuit.carbon") .. "★", "UVCarbonFont", w*0.3, h*0.2, Color( 255, 255, 255), TEXT_ALIGN_LEFT )
			
			-- Next Lower, results subtext
			-- surface.SetMaterial(UVMaterials['BACKGROUND_BIGGER'])
			surface.SetDrawColor( 0, 0, 0, 235 )
			surface.DrawRect( w*0.25, h*0.3, w*0.5, h*0.03)
			
			draw.DrawText( "#uv.results.chase.item.carbon", "UVCarbonLeaderboardFont", w*0.2565, h*0.3025, Color( 255, 255, 255), TEXT_ALIGN_LEFT )
			
			draw.DrawText( "#uv.results.chase.value.carbon", "UVCarbonLeaderboardFont", w*0.74, h*0.3025, Color( 255, 255, 255), TEXT_ALIGN_RIGHT )
			
			-- All middle tabs, light ones
			local numRectsLight = 3
			for i=0, numRectsLight, 1 do
				local yPos = i * h * 0.08
				surface.SetMaterial(UVMaterials['BACKGROUND_CARBON_FILLED'])
				surface.SetDrawColor( 86, 214, 205, 100 )
				surface.DrawTexturedRect( w*0.25, h*0.34 + yPos, w*0.485, h*0.035)
				
				surface.SetMaterial(UVMaterials['ARROW_CARBON'])
				surface.DrawTexturedRect( w*0.735, h*0.34 + yPos, w*0.015, h*0.035)
			end
			
			-- All middle tabs, dark ones
			local numRectsDark = 3
			for i=0, numRectsDark, 1 do
				local yPos = i * h * 0.08
				surface.SetMaterial(UVMaterials['BACKGROUND_CARBON_FILLED'])
				surface.SetDrawColor( 86, 214, 205, 25 )
				surface.DrawTexturedRect( w*0.25, h*0.38 + yPos, w*0.485, h*0.035)
				
				surface.SetMaterial(UVMaterials['ARROW_CARBON'])
				surface.DrawTexturedRect( w*0.735, h*0.38 + yPos, w*0.015, h*0.035)
			end
			
			local h1, h2 = h*0.3825, h*0.4225
			
			-- Text
			draw.DrawText( "#uv.results.escapedfrom", "UVCarbonLeaderboardFont", w*0.2565, h*0.3425, Color( 255, 255, 0), TEXT_ALIGN_LEFT )
			
			draw.SimpleText( "#uv.results.chase.bounty", "UVCarbonLeaderboardFont", w*0.2565, h1, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.time", "UVCarbonLeaderboardFont", w*0.2565, h2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.units.deployed", "UVCarbonLeaderboardFont", w*0.2565, h1 + h*0.08, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.units.damaged", "UVCarbonLeaderboardFont", w*0.2565, h2 + h*0.08, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.units.destroyed", "UVCarbonLeaderboardFont", w*0.2565, h1 + h*0.16, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.dodged.blocks", "UVCarbonLeaderboardFont", w*0.2565, h2 + h*0.16, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.dodged.spikes", "UVCarbonLeaderboardFont", w*0.2565, h1 + h*0.24, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			
			-- draw.SimpleText( "Yes", "UVCarbonLeaderboardFont", w*0.74, h*0.3425, Color( 255, 255, 0), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			
			draw.SimpleText( bounty, "UVCarbonLeaderboardFont", w*0.74, h1, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( time, "UVCarbonLeaderboardFont", w*0.74, h2, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( deploys, "UVCarbonLeaderboardFont", w*0.74, h1 + h*0.08, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( tags, "UVCarbonLeaderboardFont", w*0.74, h2 + h*0.08, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( wrecks, "UVCarbonLeaderboardFont", w*0.74, h1 + h*0.16, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( roadblocksdodged, "UVCarbonLeaderboardFont", w*0.74, h2 + h*0.16, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( spikestripsdodged, "UVCarbonLeaderboardFont", w*0.74, h1 + h*0.24, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			
			
			-- Time remaining and closing
			surface.SetDrawColor( 100, 100, 100, 125 )
			surface.DrawRect( w*0.2565, h*0.675, w*0.485, h*0.035)
			
			draw.DrawText( "( " .. input.LookupBinding("+jump") .. " ) " .. lang("uv.results.continue"), "UVCarbonLeaderboardFont", w*0.2585, h*0.6785, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT )
			draw.DrawText( string.format( language.GetPhrase("uv.results.autoclose"), timeremaining ), "UVCarbonLeaderboardFont", w*0.74, h*0.6785, Color( 255, 255, 255 ), TEXT_ALIGN_RIGHT )
			
			if timeremaining < 1 then
				hook.Remove("Think", "CheckJumpKeyForDebrief")
				self:Close()
			end
			
		end
		
		function OK:DoClick() 
			hook.Remove("Think", "CheckJumpKeyForDebrief")
			ResultPanel:Close()
		end
		
		local wasJumping = false
		hook.Add("Think", "CheckJumpKeyForDebrief", function()
			local ply = LocalPlayer()
			if not IsValid(ply) then return end
			
			if ply:KeyDown(IN_JUMP) then
				if not wasJumping then
					wasJumping = true
					if IsValid(ResultPanel) then
						ResultPanel:Close()
						hook.Remove("Think", "CheckJumpKeyForDebrief")
					end
				end
			else
				wasJumping = false
			end
		end)
    end,
    onRacerBustedDebrief = function(...)
        local w = ScrW()
		local h = ScrH()

        local bustedtable = select( 1, ... )

        --------------------------------------

        local time = UVDisplayTime(UVTimerProgress)
		local unit = bustedtable["Unit"]
		local deploys = bustedtable["Deploys"]
		local roadblocksdodged = bustedtable["Roadblocks"]
		local spikestripsdodged = bustedtable["Spikestrips"]
		local bounty = UVBounty
		local tags = UVTags
		local wrecks = UVWrecks
		
		local ResultPanel = vgui.Create("DFrame")
		local OK = vgui.Create("DButton")
		
		ResultPanel:Add(OK)
		ResultPanel:SetSize(w, h)
		ResultPanel:SetBackgroundBlur(true)
		ResultPanel:ShowCloseButton(false)
		ResultPanel:Center()
		ResultPanel:SetTitle("")
		ResultPanel:SetDraggable(false)
		ResultPanel:MakePopup()
		ResultPanel:SetKeyboardInputEnabled(false)

		OK:SetText("X")
		OK:SetSize(w*0.015, h*0.03)
		OK:SetPos(w*0.725, h*0.205)
		
		local timetotal = 30
		local timestart = CurTime()
		
		ResultPanel.Paint = function(self, w, h)
			local timeremaining = math.ceil(timetotal - (CurTime() - timestart))
			local lang = language.GetPhrase

			-- Main black BG
			surface.SetDrawColor( 0, 0, 0, 200 )
			surface.DrawRect( 0, 0, w, h)
			
			-- Upper Results Tab
			surface.SetDrawColor( 0, 0, 0, 235 )
			surface.DrawRect( w*0.25, h*0.185, w*0.5, h*0.075)
			
			surface.SetMaterial(UVMaterials['EOC_FRAME_CARBON'])
			surface.SetDrawColor(86, 214, 205)
			surface.DrawTexturedRect( w*0.26, h*0.17825, w*0.485, h*0.09)

			DrawIcon( UVMaterials['X_OUTER_CARBON'], w*0.255, h*0.215, 0.2, Color(0,0,0) ) -- Icon
			DrawIcon( Material("unitvehicles/hud_carbon/x_anim"), w*0.255, h*0.215, 0.2, Color(255,255,255) ) -- Animated Icon; TBD

			draw.DrawText( "★" .. lang("uv.results.pursuit.carbon") .. "★", "UVCarbonFont", w*0.3, h*0.2, Color( 255, 255, 255), TEXT_ALIGN_LEFT )
			
			-- Next Lower, results subtext
			-- surface.SetMaterial(UVMaterials['BACKGROUND_BIGGER'])
			surface.SetDrawColor( 0, 0, 0, 235 )
			surface.DrawRect( w*0.25, h*0.3, w*0.5, h*0.03)
			
			draw.DrawText( "#uv.results.chase.item.carbon", "UVCarbonLeaderboardFont", w*0.2565, h*0.3025, Color( 255, 255, 255), TEXT_ALIGN_LEFT )
			
			draw.DrawText( "#uv.results.chase.value.carbon", "UVCarbonLeaderboardFont", w*0.74, h*0.3025, Color( 255, 255, 255), TEXT_ALIGN_RIGHT )
			
			-- All middle tabs, light ones
			local numRectsLight = 3
			for i=0, numRectsLight, 1 do
				local yPos = i * h * 0.08
				surface.SetMaterial(UVMaterials['BACKGROUND_CARBON_FILLED'])
				surface.SetDrawColor( 86, 214, 205, 100 )
				surface.DrawTexturedRect( w*0.25, h*0.34 + yPos, w*0.485, h*0.035)
				
				surface.SetMaterial(UVMaterials['ARROW_CARBON'])
				surface.DrawTexturedRect( w*0.735, h*0.34 + yPos, w*0.015, h*0.035)
			end
			
			-- All middle tabs, dark ones
			local numRectsDark = 3
			for i=0, numRectsDark, 1 do
				local yPos = i * h * 0.08
				surface.SetMaterial(UVMaterials['BACKGROUND_CARBON_FILLED'])
				surface.SetDrawColor( 86, 214, 205, 25 )
				surface.DrawTexturedRect( w*0.25, h*0.38 + yPos, w*0.485, h*0.035)
				
				surface.SetMaterial(UVMaterials['ARROW_CARBON'])
				surface.DrawTexturedRect( w*0.735, h*0.38 + yPos, w*0.015, h*0.035)
			end
			
			local h1, h2 = h*0.3825, h*0.4225
			
			-- Text
			draw.DrawText( "#uv.results.bustedby.carbon", "UVCarbonLeaderboardFont", w*0.2565, h*0.3425, Color( 255, 255, 0), TEXT_ALIGN_LEFT )

			draw.SimpleText( "#uv.results.chase.bounty", "UVCarbonLeaderboardFont", w*0.2565, h1, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.time", "UVCarbonLeaderboardFont", w*0.2565, h2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.units.deployed", "UVCarbonLeaderboardFont", w*0.2565, h1 + h*0.08, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.units.damaged", "UVCarbonLeaderboardFont", w*0.2565, h2 + h*0.08, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.units.destroyed", "UVCarbonLeaderboardFont", w*0.2565, h1 + h*0.16, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.dodged.blocks", "UVCarbonLeaderboardFont", w*0.2565, h2 + h*0.16, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.dodged.spikes", "UVCarbonLeaderboardFont", w*0.2565, h1 + h*0.24, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			
			draw.SimpleText( unit, "UVCarbonLeaderboardFont", w*0.74, h*0.3425, Color( 255, 255, 0), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			
			draw.SimpleText( bounty, "UVCarbonLeaderboardFont", w*0.74, h1, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( time, "UVCarbonLeaderboardFont", w*0.74, h2, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( deploys, "UVCarbonLeaderboardFont", w*0.74, h1 + h*0.08, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( tags, "UVCarbonLeaderboardFont", w*0.74, h2 + h*0.08, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( wrecks, "UVCarbonLeaderboardFont", w*0.74, h1 + h*0.16, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( roadblocksdodged, "UVCarbonLeaderboardFont", w*0.74, h2 + h*0.16, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( spikestripsdodged, "UVCarbonLeaderboardFont", w*0.74, h1 + h*0.24, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			
			
			-- Time remaining and closing
			surface.SetDrawColor( 100, 100, 100, 125 )
			surface.DrawRect( w*0.2565, h*0.675, w*0.485, h*0.035)
			
			draw.DrawText( "( " .. input.LookupBinding("+jump") .. " ) " .. lang("uv.results.continue"), "UVCarbonLeaderboardFont", w*0.2585, h*0.6785, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT )
			draw.DrawText( string.format( language.GetPhrase("uv.results.autoclose"), timeremaining ), "UVCarbonLeaderboardFont", w*0.74, h*0.6785, Color( 255, 255, 255 ), TEXT_ALIGN_RIGHT )
			
			if timeremaining < 1 then
				hook.Remove("Think", "CheckJumpKeyForDebrief")
				self:Close()
			end
			
		end
		
		function OK:DoClick() 
			hook.Remove("Think", "CheckJumpKeyForDebrief")
			ResultPanel:Close()
		end
		
		local wasJumping = false
		hook.Add("Think", "CheckJumpKeyForDebrief", function()
			local ply = LocalPlayer()
			if not IsValid(ply) then return end
			
			if ply:KeyDown(IN_JUMP) then
				if not wasJumping then
					wasJumping = true
					if IsValid(ResultPanel) then
						ResultPanel:Close()
						hook.Remove("Think", "CheckJumpKeyForDebrief")
					end
				end
			else
				wasJumping = false
			end
		end)
    end
}

local function carbon_racing_main( ... )
    local w = ScrW()
    local h = ScrH()
    
    local my_vehicle = select(1, ...)
    local my_array = select(2, ...)
    local string_array = select(3, ...)
    
    local racer_count = #string_array
    local lang = language.GetPhrase
    
    local checkpoint_count = #my_array["Checkpoints"]
    
    ------------------------------------
    
    -- Timer
    surface.SetMaterial(UVMaterials["ARROW_CARBON"])
    surface.SetDrawColor(Colors.Carbon_AccentTransparent)
    surface.DrawTexturedRect(w * 0.815, h * 0.111, w * 0.025, h * 0.033)
    
    DrawIcon(UVMaterials["CLOCK_BG"], w * 0.815, h * 0.124, .0625, Colors.Carbon_Accent) -- Icon
    
    draw.DrawText(Carbon_FormatRaceTime((UVHUDRaceInfo.Info.Started and (CurTime() - UVHUDRaceInfo.Info.Time)) or 0),"UVCarbonFont",w * 0.97, h * 0.105, Colors.Carbon_Accent, TEXT_ALIGN_RIGHT)
    
    -- Lap & Checkpoint Counter
    surface.SetMaterial(UVMaterials["BACKGROUND_CARBON"])
    surface.SetDrawColor(Colors.Carbon_Accent2Transparent:Unpack())
    surface.DrawTexturedRect(w * 0.69, h * 0.157, w * 0.2, h * 0.04)
    
    local laptext = "<color=" .. Colors.Carbon_Accent.r .. ", " .. Colors.Carbon_Accent.g .. ", " ..Colors.Carbon_Accent.b ..">" .. my_array.Lap .. ": </color>" .. UVHUDRaceInfo.Info.Laps
    
    if UVHUDRaceInfo.Info.Laps > 1 then
        draw.DrawText("#uv.race.hud.lap","UVCarbonFont",w * 0.875,h * 0.155,Colors.Carbon_Accent2Bright,TEXT_ALIGN_RIGHT) -- Lap Counter
    else
        draw.DrawText("#uv.race.hud.complete","UVCarbonFont",w * 0.875,h * 0.155,Colors.Carbon_Accent2Bright,TEXT_ALIGN_RIGHT) -- Checkpoint Text
        laptext = math.floor(((checkpoint_count / GetGlobalInt("uvrace_checkpoints")) * 100)) .. "%"
    end
    
    markup.Parse("<font=UVCarbonFont>" .. laptext):Draw(w * 0.97,h * 0.155,TEXT_ALIGN_RIGHT,TEXT_ALIGN_RIGHT)
    
    -- Racer List
    local alt = math.floor(CurTime() / 5) % 2 == 1 -- toggles every 5 seconds
    for i = 1, racer_count, 1 do
        if racer_count == 1 then
            return
        end
        local entry = string_array[i]
        
        local racer_name = entry[1]
        local is_local_player = entry[2]
        local mode = entry[3]
        local diff = entry[4]
        
        local racercount = i * w * 0.0135
        
        local status_text = "-----"
        
        local Strings = {
            ["Time"] = "%s",
            ["Lap"] = lang("uv.race.suffix.lap"),
            -- ["Laps"] = lang("uv.race.suffix.laps"),
            ["Finished"] = lang("uv.race.suffix.finished"),
            ["Disqualified"] = lang("uv.race.suffix.dnf"),
            ["Busted"] = lang("uv.race.suffix.busted"),
        }
        
        if entry[3] then
            local status_string = Strings[entry[3]]
            
            if status_string then
                local args = {}
                
                if entry[4] then
                    local num = tonumber(entry[4])
                    num =
                    ((num > 0 and "+ ") or "- ") ..
                    string.format((entry[3] == "Lap" and "%s") or "%.2f", math.abs(num))
                    
                    table.insert(args, num)
                end
                
                status_text = #args <= 0 and status_string or string.format(status_string, unpack(args))
            end
        end
        
        local color = nil
        
        if is_local_player then
            color = Colors.Carbon_LocalPlayer
        elseif entry[3] == "Disqualified" or entry[3] == "Busted" then
            color = Colors.Carbon_Disqualified
        else
            color = (i > 4 and Colors.Carbon_OthersDark) or Colors.Carbon_Others
        end
        
        local text = alt and (status_text .. "   " .. i) or (racer_name .. "   " .. i)
        
        if is_local_player then
            surface.SetMaterial(UVMaterials["BACKGROUND_CARBON_INVERTED"])
            surface.SetDrawColor(89, 255, 255, 100)
            surface.DrawTexturedRect(w * 0.72, h * 0.185 + racercount, w * 0.255, h * 0.025)
        end
        
		
        draw.DrawText(text, "UVCarbonLeaderboardFont", w * 0.97, (h * 0.185) + racercount, color, TEXT_ALIGN_RIGHT)
    end
end

local function carbon_pursuit_main( ... )
    local hudyes = GetConVar("cl_drawhud"):GetBool()
    
    if not hudyes then return end
    if not UVHUDDisplayPursuit then return end
    
    local vehicle = LocalPlayer():GetVehicle()
    
    local w = ScrW()
    local h = ScrH()
    local lang = language.GetPhrase
    
    local UnitsChasing = tonumber(UVUnitsChasing)
    local UVBustTimer = BustedTimer:GetFloat()
    
    local states = UV_UI.pursuit.carbon.states
    
    local UVWrecksColor = states.WrecksColor
    local UVTagsColor = states.TagsColor
    local UVUnitsColor = states.UnitsColor
    
    --------------------------------------------------
    
    outofpursuit = CurTime()
    
    local UVHeatBountyMin
    local UVHeatBountyMax
    states.EvasionColor = Color(0, 255, 0, 0)
    states.BustedColor = Color(193, 66, 0, 0)
    
    if vehicle == NULL then return end
    
    if UVHUDCopMode and not UVHUDDisplayNotification then
        UVHUDDisplayBusting = false
    end
    
    if UVHUDCopMode and next(UVHUDWantedSuspects) ~= nil then
        local ply = LocalPlayer()
        
        UVClosestSuspect = nil
        UVHUDDisplayBusting = false
        
        local closestDistance = math.huge
        
        for _, suspect in pairs(UVHUDWantedSuspects) do
            if not IsValid(suspect) then continue end
            local dist = ply:GetPos():DistToSqr(suspect:GetPos())
            
            if (#UVHUDWantedSuspects == 1 or dist < 250000) and dist < closestDistance then
                closestDistance = dist
                UVClosestSuspect = suspect
            end
        end
        
        if UVClosestSuspect then
            if UVClosestSuspect.beingbusted then
                UVHUDDisplayBusting = true
                UVBustingProgress = UVClosestSuspect.uvbustingprogress
                
                local blink = 255 * math.abs(math.sin(RealTime() * 8))
                states.BustedColor = Color(255, blink, blink)
            end
        end
    end
    
    if not UVHUDRace then
        local ResourceText = UVResourcePoints
        
        -- [[ Commander Stuff ]]
        if UVOneCommanderActive then
            if not UVHUDCommanderLastHealth or not UVHUDCommanderLastMaxHealth then
                UVHUDCommanderLastHealth = 0
                UVHUDCommanderLastMaxHealth = 0
            end
            if IsValid(UVHUDCommander) then
                if UVHUDCommander.IsSimfphyscar then
                    UVHUDCommanderLastHealth = UVHUDCommander:GetCurHealth()
                    UVHUDCommanderLastMaxHealth =
                    UVUOneCommanderHealth:GetInt() - (UVHUDCommander:GetMaxHealth() * 0.3)
                elseif UVHUDCommander.IsGlideVehicle then
                    local enginehealth = UVHUDCommander:GetEngineHealth()
                    UVHUDCommanderLastHealth = UVHUDCommander:GetChassisHealth() * enginehealth
                    UVHUDCommanderLastMaxHealth = UVUOneCommanderHealth:GetInt()
                elseif vcmod_main then
                    UVHUDCommanderLastHealth =
                    UVUOneCommanderHealth:GetInt() * (UVHUDCommander:VC_getHealth() / 100) --vcmod returns % health clientside
                    UVHUDCommanderLastMaxHealth = UVUOneCommanderHealth:GetInt()
                else
                    UVHUDCommanderLastHealth = UVHUDCommander:Health()
                    UVHUDCommanderLastMaxHealth = UVUOneCommanderHealth:GetInt()
                end
            end
            local healthratio = UVHUDCommanderLastHealth / UVHUDCommanderLastMaxHealth
            local healthcolor
            if healthratio >= 0.5 then
                healthcolor = Color(255, 255, 255, 200)
            elseif healthratio >= 0.25 then
                if math.floor(RealTime() * 2) == math.Round(RealTime() * 2) then
                    healthcolor = Color(255, 0, 0)
                else
                    healthcolor = Color(255, 255, 255)
                end
            else
                if math.floor(RealTime() * 4) == math.Round(RealTime() * 4) then
                    healthcolor = Color(255, 0, 0)
                else
                    healthcolor = Color(255, 255, 255)
                end
            end
            ResourceText = "⛊"
            local element3 = {
                {x = w / 3, y = 0},
                {x = w / 3 + 12 + w / 3, y = 0},
                {x = w / 3 + 12 + w / 3 - 25, y = h / 20},
                {x = w / 3 + 25, y = h / 20}
            }
            surface.SetDrawColor(0, 0, 0, 200)
            draw.NoTexture()
            surface.DrawPoly(element3)
            if healthratio > 0 then
                surface.SetDrawColor(Color(109, 109, 109, 200))
                surface.DrawRect(w / 3 + 25, h / 20, w / 3 - 38, 8)
                surface.SetDrawColor(healthcolor)
                local T = math.Clamp((healthratio) * (w / 3 - 38), 0, w / 3 - 38)
                surface.DrawRect(w / 3 + 25, h / 20, T, 8)
            end
            draw.DrawText("⛊ " .. lang("uv.unit.commander") .. " ⛊","UVFont5UI-BottomBar",w / 2,0,Color(0, 161, 255),TEXT_ALIGN_CENTER)
        end
        
        -- [ Upper Right Info Box ] --
        -- Timer
		if not UVHUDDisplayBackupTimer then
			surface.SetMaterial(UVMaterials["ARROW_CARBON"])
			surface.SetDrawColor(Colors.Carbon_AccentTransparent)
			surface.DrawTexturedRect(w * 0.8, h * 0.111, w * 0.025, h * 0.033)
		else
			surface.SetMaterial(UVMaterials["BACKGROUND_CARBON_SOLID"])
			surface.SetDrawColor(Color(193, 66, 0))
			surface.DrawTexturedRect(w * 0.795, h * 0.111, w * 0.085, h * 0.033)
			
			surface.SetMaterial(UVMaterials["ARROW_CARBON"])
			surface.DrawTexturedRectRotated(w * 0.84, h * 0.1512, w * 0.01, h * 0.02, -90)
			
			draw.DrawText(UVBackupTimer,"UVCarbonLeaderboardFont",w * 0.865,h*0.111 * 1.001,Color(0,0,0),TEXT_ALIGN_RIGHT)
		end

		DrawIcon(UVMaterials["CLOCK_BG"], w * 0.8, h * 0.124, .0625, Colors.Carbon_Accent) -- Icon
		draw.DrawText(UVTimer,"UVCarbonFont",w * 0.97 + 2, h * 0.105 + 2, Color(0,0,0), TEXT_ALIGN_RIGHT)
		draw.DrawText(UVTimer,"UVCarbonFont",w * 0.97, h * 0.105, Colors.Carbon_Accent, TEXT_ALIGN_RIGHT)
    
        -- Bounty
        -- surface.SetDrawColor(0, 0, 0, 200)
        -- surface.DrawRect(w * 0.7, h * 0.155, w * 0.275, h * 0.05)
        -- draw.DrawText("#uv.hud.bounty","UVFont5",w * 0.7025,h * 0.157,Color(255, 255, 255),TEXT_ALIGN_LEFT)
        -- draw.DrawText(UVBounty, "UVFont5", w * 0.97, h * 0.157, Color(255, 255, 255), TEXT_ALIGN_RIGHT)
        
        -- Heat Level
        -- surface.SetDrawColor(0, 0, 0, 200)
        -- surface.DrawRect(w * 0.7, h * 0.21, w * 0.275, h * 0.05)
        
        if UVHeatLevel == 1 then
            UVHeatBountyMin = UVUHeatMinimumBounty1:GetInt()
            UVHeatBountyMax = UVUHeatMinimumBounty2:GetInt()
        elseif UVHeatLevel == 2 then
            UVHeatBountyMin = UVUHeatMinimumBounty2:GetInt()
            UVHeatBountyMax = UVUHeatMinimumBounty3:GetInt()
        elseif UVHeatLevel == 3 then
            UVHeatBountyMin = UVUHeatMinimumBounty3:GetInt()
            UVHeatBountyMax = UVUHeatMinimumBounty4:GetInt()
        elseif UVHeatLevel == 4 then
            UVHeatBountyMin = UVUHeatMinimumBounty4:GetInt()
            UVHeatBountyMax = UVUHeatMinimumBounty5:GetInt()
        elseif UVHeatLevel == 5 then
            UVHeatBountyMin = UVUHeatMinimumBounty5:GetInt()
            UVHeatBountyMax = UVUHeatMinimumBounty6:GetInt()
        elseif UVHeatLevel == 6 then
            UVHeatBountyMin = UVUHeatMinimumBounty6:GetInt()
            UVHeatBountyMax = math.huge
        end

        DrawIcon(UVMaterials["HEAT_CARBON"], w * 0.8, h * 0.28, .045, Colors.Carbon_Accent) -- Icon
        draw.DrawText("x" .. UVHeatLevel, "UVCarbonFont", w * 0.81 + 2, h * 0.26 + 2, Color(0,0,0), TEXT_ALIGN_LEFT)
        draw.DrawText("x" .. UVHeatLevel, "UVCarbonFont", w * 0.81, h * 0.26, Colors.Carbon_Accent, TEXT_ALIGN_LEFT)
        
        surface.SetDrawColor(Color(0,0,0))
        surface.DrawRect(w * 0.835 - 4, h * 0.275 - 3, w * 0.145 + 8.5, h * 0.015 + 6)
        surface.SetDrawColor(Colors.Carbon_AccentDarker)
        surface.DrawRect(w * 0.835, h * 0.275, w * 0.145, h * 0.015)
        surface.SetDrawColor(Color(255, 255, 255))
        local HeatProgress = 0
        if MaxHeatLevel:GetInt() ~= UVHeatLevel then
            if UVUTimeTillNextHeatEnabled:GetInt() == 1 and UVTimeTillNextHeat then --Time till next heat level
                if UVHeatLevel == 1 then
                    local maxtime = UVUTimeTillNextHeat1:GetInt()
                    HeatProgress = (maxtime - UVTimeTillNextHeat) / maxtime
                elseif UVHeatLevel == 2 then
                    local maxtime = UVUTimeTillNextHeat2:GetInt()
                    HeatProgress = (maxtime - UVTimeTillNextHeat) / maxtime
                elseif UVHeatLevel == 3 then
                    local maxtime = UVUTimeTillNextHeat3:GetInt()
                    HeatProgress = (maxtime - UVTimeTillNextHeat) / maxtime
                elseif UVHeatLevel == 4 then
                    local maxtime = UVUTimeTillNextHeat4:GetInt()
                    HeatProgress = (maxtime - UVTimeTillNextHeat) / maxtime
                elseif UVHeatLevel == 5 then
                    local maxtime = UVUTimeTillNextHeat5:GetInt()
                    HeatProgress = (maxtime - UVTimeTillNextHeat) / maxtime
                elseif UVHeatLevel == 6 then
                    HeatProgress = 0
                end
            else
                HeatProgress = ((UVBountyNo - UVHeatBountyMin) / (UVHeatBountyMax - UVHeatBountyMin))
            end
        end
        local B = math.Clamp((HeatProgress) * w * 0.145, 0, w * 0.145)
        local blink = 255 * math.abs(math.sin(RealTime() * 4))
        local blink2 = 255 * math.abs(math.sin(RealTime() * 6))
        local blink3 = 255 * math.abs(math.sin(RealTime() * 8))
        
        -- if HeatProgress >= 0.6 and HeatProgress < 0.75 then
            -- surface.SetDrawColor(Color(255, blink, blink))
        -- elseif HeatProgress >= 0.75 and HeatProgress < 0.9 then
            -- surface.SetDrawColor(Color(255, blink2, blink2))
        -- elseif HeatProgress >= 0.9 and HeatProgress < 1 then
            -- surface.SetDrawColor(Color(255, blink3, blink3))
        -- elseif HeatProgress >= 1 then
            surface.SetDrawColor(Colors.Carbon_Accent)
        -- end
        
        surface.DrawRect(w * 0.835, h * 0.275, B, h * 0.015)
		
        -- General Icons
		surface.SetMaterial(UVMaterials["BACKGROUND_CARBON_SMALL_INVERTED"])
		surface.SetDrawColor(Color(255, 255, 255, 50))
		surface.DrawTexturedRect(w * 0.9, h * 0.16, w * 0.075, h * 0.033)

		DrawIcon(UVMaterials["UNITS_DISABLED_CARBON"], w * 0.97, h * 0.175, .05, Colors.Carbon_Accent)
		draw.DrawText(UVWrecks,"UVCarbonFont",w * 0.9125 + 1.5,h * 0.1525 + 1.5,Color(0,0,0),TEXT_ALIGN_LEFT)
		draw.DrawText(UVWrecks,"UVCarbonFont",w * 0.9125,h * 0.1525,Colors.Carbon_Accent,TEXT_ALIGN_LEFT)

		-- draw.DrawText(UVTags, "UVFont5WeightShadow", w * 0.36, bottomy4, UVTagsColor, TEXT_ALIGN_LEFT)
		-- DrawIcon(UVMaterials["UNITS_DAMAGED"], w * 0.345, bottomy5, 0.06, UVTagsColor)
		
		surface.SetMaterial(UVMaterials["BACKGROUND_CARBON_SMALL"])
		surface.SetDrawColor(Color(255, 255, 255, 50))
		surface.DrawTexturedRect(w * 0.79, h * 0.16, w * 0.075, h * 0.033)

		DrawIcon(UVMaterials["UNITS_CARBON"], w * 0.8, h * 0.175, .05, Colors.Carbon_Accent)
		draw.DrawText(ResourceText,"UVCarbonFont",w * 0.853 + 1.5,h * 0.1525 + 1.5,Color(0,0,0),TEXT_ALIGN_RIGHT) -- Shadow
		draw.DrawText(ResourceText,"UVCarbonFont",w * 0.853,h * 0.1525,Colors.Carbon_Accent,TEXT_ALIGN_RIGHT)
            
        -- [ Bottom Info Box ] --
        local middlergb = {
            r = 255,
            g = 255,
            b = 0,
            a = 255
        }

        if not UVHUDDisplayCooldown then
            -- Evade Box, Coloured Backgrounds
            surface.SetMaterial(UVMaterials["BACKGROUND_CARBON_SOLID_INVERTED"]) -- Busted
			surface.SetDrawColor(Color(0, 0, 0, 255)) -- Shadow
			surface.DrawTexturedRect(w * 0.79 - 5, h * 0.215 - 3.5, w * 0.085 + 30, h * 0.015 + 8.5)

			surface.SetDrawColor(Color(193, 66, 0, 175))
			surface.DrawTexturedRect(w * 0.79, h * 0.215, w * 0.085, h * 0.015)

            surface.SetMaterial(UVMaterials["BACKGROUND_CARBON_SOLID"]) -- Evade
			surface.SetDrawColor(Color(0, 0, 0, 255)) -- Shadow
			surface.DrawTexturedRect(w * 0.8925 - 25, h * 0.215 - 3.5, w * 0.085 + 30, h * 0.015 + 8.5)
			
			surface.SetDrawColor(Color(0, 200, 0, 175))
			surface.DrawTexturedRect(w * 0.8925, h * 0.215, w * 0.085, h * 0.015)

            -- Evade Box, Busted Meter
            if UVHUDDisplayBusting and not UVHUDDisplayCooldown then
                if not BustingProgress or BustingProgress == 0 then
                    BustingProgress = CurTime()
                end
                
                local blink = 255 * math.abs(math.sin(RealTime() * 4))
                local blink2 = 255 * math.abs(math.sin(RealTime() * 6))
                local blink3 = 255 * math.abs(math.sin(RealTime() * 8))
                
                local timeLeft = ((UVHUDDisplayNotification and -1) or (UVBustTimer - UVBustingProgress))
                
                local playbusting = (UVHUDCopMode and UVHUDWantedSuspectsNumber == 1) or not UVHUDCopMode
                
                if timeLeft >= UVBustTimer * 0.5 then
                    states.BustedColor = Color(193, 66, 0, blink)
                    -- UVSoundBusting()
                elseif timeLeft >= UVBustTimer * 0.2 then
                    states.BustedColor = Color(193, 66, 0, blink2)
                    if playbusting then
                        UVSoundBusting()
                    end
                elseif timeLeft >= 0 then
                    states.BustedColor = Color(193, 66, 0, blink3)
                    if playbusting then
                        UVSoundBusting()
                    end
                else
                    states.BustedColor = Color(193, 66, 0)
                end
                
                local T = math.Clamp((UVBustingProgress / UVBustTimer) * (w * 0.085), 0, w * 0.085)
				T = math.floor(T)
				surface.SetMaterial(UVMaterials["BACKGROUND_CARBON_SOLID_INVERTED"])
                surface.SetDrawColor(193, 66, 0)
                surface.DrawTexturedRect(w * 0.79 + (w * 0.085 - T), h * 0.215, T, h * 0.015)
                middlergb = {
                    r = 175,
                    g = 175,
                    b = 0,
                }
            else
                UVBustedColor = Color(193, 66, 0, 0)
                BustingProgress = 0
            end
            
            -- Evade Box, Evade Meter
            if not UVHUDDisplayNotification and not UVHUDDisplayCooldown and UnitsChasing == 0 then
                --UVSoundHeat(UVHeatLevel)
                if not EvadingProgress or EvadingProgress == 0 then
                    EvadingProgress = CurTime()
                    UVEvadingProgress = EvadingProgress
                end
                
                local T = math.Clamp((UVEvadingProgress) * (w * 0.082), 0, w * 0.082)
				surface.SetMaterial(UVMaterials["BACKGROUND_CARBON_SOLID"])
                surface.SetDrawColor(0, 255, 0)
                surface.DrawTexturedRect(w * 0.895, h * 0.215, T, h * 0.015)
                middlergb = {
                    r = 175,
                    g = 175,
                    b = 0,
                }
                
                states.EvasionColor = Color(0, 255, 0, blink)
            else
                EvadingProgress = 0
            end
            
            -- Evade Box, Middle Piece
            surface.SetDrawColor(middlergb.r, middlergb.g, middlergb.b, 255)
            surface.DrawRect(w * 0.875, h * 0.215, w * 0.0195, h * 0.015)
            
            draw.DrawText("#uv.chase.busted","UVCarbonLeaderboardFont",w * 0.795 + 2,h* 0.23 + 2,Color(0,0,0,100),TEXT_ALIGN_LEFT)
            draw.DrawText("#uv.chase.evade","UVCarbonLeaderboardFont",w * 0.975 + 2,h * 0.23 + 2,Color(0,0,0,100),TEXT_ALIGN_RIGHT)
			
            draw.DrawText("#uv.chase.busted","UVCarbonLeaderboardFont",w * 0.795,h* 0.23,Color(193, 66, 0, 100),TEXT_ALIGN_LEFT)
            draw.DrawText("#uv.chase.evade","UVCarbonLeaderboardFont",w * 0.975,h * 0.23,Color(0, 255, 0, 100),TEXT_ALIGN_RIGHT)
			
            draw.DrawText("#uv.chase.busted","UVCarbonLeaderboardFont",w * 0.795,h* 0.23,states.BustedColor,TEXT_ALIGN_LEFT)
            draw.DrawText("#uv.chase.evade","UVCarbonLeaderboardFont",w * 0.975,h * 0.23,states.EvasionColor,TEXT_ALIGN_RIGHT)
            
            -- Lower Box
            local lbtext = "REPLACEME"
            local uloc, utype = "uv.chase.unit", UnitsChasing
            if not UVHUDCopMode then
                if UnitsChasing ~= 1 then
                    uloc = "uv.chase.units"
                end
            else
                utype = UVHUDWantedSuspectsNumber
                uloc = "uv.chase.suspects"
            end

            draw.DrawText(string.format(lang(uloc), utype),"UVCarbonFont",w * 0.9825 + 2,h * 0.3 + 2,Color(0,0,0),TEXT_ALIGN_RIGHT)
            draw.DrawText(string.format(lang(uloc), utype),"UVCarbonFont",w * 0.9825,h * 0.3,Colors.Carbon_Accent,TEXT_ALIGN_RIGHT)
        else
            -- Lower Box
            -- Evade Box, All BG (Moved to inner if clauses)
            
            -- Evade Box, Cooldown Meter
            if UVHUDDisplayCooldown then
                if not CooldownProgress or CooldownProgress == 0 then
                    CooldownProgress = CurTime()
                end
                
                UVSoundCooldown()
                EvadingProgress = 0
                
                -- Upper Box
                if not UVHUDCopMode then
                    -- if UVHUDDisplayHidingPrompt then
						-- draw.DrawText("#uv.chase.hiding","UVCarbonLeaderboardFont",w * 0.795 + 2,h * 0.23 + 2,Color(0,0,0),TEXT_ALIGN_LEFT)
						-- draw.DrawText("#uv.chase.hiding","UVCarbonLeaderboardFont",w * 0.795 ,h * 0.23,Colors.Carbon_Accent,TEXT_ALIGN_LEFT)
                    -- end

                    local T = math.Clamp((UVCooldownTimer) * (w * 0.19), 0, w * 0.19)
					T = math.floor(T)
					
					surface.SetMaterial(UVMaterials["BACKGROUND_CARBON_SOLID_INVERTED"])
					surface.SetDrawColor(Color(0,0,0)) -- Shadow
					surface.DrawTexturedRect(w * 0.79 - 5, h * 0.215 - 3.5, w * 0.19 + 10, h * 0.015 + 8.5)
					
					surface.SetDrawColor(Colors.Carbon_AccentDarker)
					surface.DrawTexturedRect(w * 0.79, h * 0.215, w * 0.19, h * 0.015)

					surface.SetDrawColor(Colors.Carbon_Accent)
					surface.DrawTexturedRect(w * 0.79 + (w * 0.19 - T), h * 0.215, T, h * 0.015)

                    draw.DrawText("#uv.chase.cooldown","UVCarbonLeaderboardFont",w * 0.975 + 2,h * 0.23 + 2,Color(0,0,0),TEXT_ALIGN_RIGHT)
                    draw.DrawText("#uv.chase.cooldown","UVCarbonLeaderboardFont",w * 0.975,h * 0.23,Colors.Carbon_Accent,TEXT_ALIGN_RIGHT)
                else
                    draw.DrawText("#uv.chase.cooldown","UVCarbonLeaderboardFont",w * 0.975 + 2,h * 0.23 + 2,Color(0,0,0),TEXT_ALIGN_RIGHT)
                    draw.DrawText("#uv.chase.cooldown", "UVCarbonLeaderboardFont",w * 0.975,h * 0.23,Colors.Carbon_Accent,TEXT_ALIGN_RIGHT)
                end
            else
                CooldownProgress = 0
            end
        end
    end
end

UV_UI.pursuit.carbon.main = carbon_pursuit_main
UV_UI.racing.carbon.main = carbon_racing_main

----------# Most Wanted

UV_UI.racing.mostwanted = {}
UV_UI.pursuit.mostwanted = {}

UV_UI.pursuit.mostwanted.states = {
    TagsColor = Color(255,255,255,150),
    WrecksColor = Color(255,255,255,150),
    UnitsColor = Color(255,255,255,150),
    BustedColor = Color(255, 255, 255, 50),
    EvasionColor = Color(255, 255, 255, 50),
}

UV_UI.racing.mostwanted.events = {
    onRaceEnd = function(...)
        print( 'onRaceEnd', ... )
    end
}

UV_UI.pursuit.mostwanted.events = {
    -- _onUpdate = function( data_name, ...)
    --     if data_name == 'Wrecks' then
    --         UV_UI.pursuit.mostwanted.callbacks.onUnitWreck( ... )
    --     elseif data_name == 'Tags' then
    --         UV_UI.pursuit.mostwanted.callbacks.onUnitTag( ... )
    --     elseif data_name == 'ChasingUnits' then
    --         UV_UI.pursuit.mostwanted.callbacks.onChasingUnitsChange( ... )
    --     end
    -- end,
    onUnitWreck = function(...)
        
        hook.Remove("Think", "MW_WRECKS_COLOR_PULSE")
        
        if timer.Exists("MW_WRECKS_COLOR_PULSE_DELAY") then timer.Remove("MW_WRECKS_COLOR_PULSE_DELAY") end
        UV_UI.pursuit.mostwanted.states.WrecksColor = Color(255,255,0, 150)
        
        timer.Create("MW_WRECKS_COLOR_PULSE_DELAY", 1, 1, function()
            hook.Add("Think", "MW_WRECKS_COLOR_PULSE", function()
                UV_UI.pursuit.mostwanted.states.WrecksColor.b = UV_UI.pursuit.mostwanted.states.WrecksColor.b + 600 * RealFrameTime()
                if UV_UI.pursuit.mostwanted.states.WrecksColor.b >= 255 then hook.Remove("Think", "MW_WRECKS_COLOR_PULSE") end
            end)
        end)
        
    end,
    onUnitTag = function(...)
        
        hook.Remove("Think", "MW_TAGS_COLOR_PULSE")
        if timer.Exists("MW_TAGS_COLOR_PULSE_DELAY") then timer.Remove("MW_TAGS_COLOR_PULSE_DELAY") end
        
        UV_UI.pursuit.mostwanted.states.TagsColor = Color(255,255,0, 150)
        
        timer.Create("MW_TAGS_COLOR_PULSE_DELAY", 1, 1, function()
            
            hook.Add("Think", "MW_TAGS_COLOR_PULSE", function()
                UV_UI.pursuit.mostwanted.states.TagsColor.b = UV_UI.pursuit.mostwanted.states.TagsColor.b + 600 * RealFrameTime()
                if UV_UI.pursuit.mostwanted.states.TagsColor.b >= 255 then hook.Remove("Think", "MW_TAGS_COLOR_PULSE") end
            end)
            
        end)
        
    end,
    onResourceChange = function(...)
        
        local new_data = select( 1, ... )
        local old_data = select( 2, ... )
        
        hook.Remove("Think", "MW_RP_COLOR_PULSE")
        UV_UI.pursuit.mostwanted.states.UnitsColor = (new_data < (old_data or 0) and Color(255,50,50, 150)) or Color(50,255,50, 150)
        --UVResourcePointsColor = (rp_num < UVResourcePoints and Color(255,50,50)) or Color(50,255,50)
        
        local clrs = {}
        
        for _, v in pairs( { 'r', 'g', 'b' } ) do
            if UV_UI.pursuit.mostwanted.states.UnitsColor[v] ~= 255 then table.insert(clrs, v) end
        end 
        
        -- if timer.Exists("UVWrecksColor") then
        -- 	timer.Remove("UVWrecksColor")
        -- end
        local val = 50
        
        hook.Add("Think", "MW_RP_COLOR_PULSE", function()
            val = val + 200 * RealFrameTime()
            -- UVResourcePointsColor.b = val
            -- UVResourcePointsColor.g = val
            for _, v in pairs( clrs ) do
                UV_UI.pursuit.mostwanted.states.UnitsColor[v] = val
            end
            
            if val >= 255 then hook.Remove("Think", "MW_RP_COLOR_PULSE") end
        end)
        
    end,
    onChasingUnitsChange = function(...)
        
    end,
    onHeatLevelUpdate = function(...)
        
    end,
    onCopBustedDebrief = function(...)
        local w = ScrW()
		local h = ScrH()

        local bustedtable = select( 1, ... )

        --------------------------------------

        local time = UVDisplayTime(UVTimerProgress)
		local deploys = bustedtable["Deploys"]
		local roadblocksdodged = bustedtable["Roadblocks"]
		local spikestripsdodged = bustedtable["Spikestrips"]
		local bounty = UVBounty
		local tags = UVTags
		local wrecks = UVWrecks
		local suspects = UVHUDWantedSuspectsNumber
		
		local ResultPanel = vgui.Create("DFrame")
		local OK = vgui.Create("DButton")
		
		ResultPanel:Add(OK)
		ResultPanel:SetSize(w, h)
		ResultPanel:SetBackgroundBlur(true)
		ResultPanel:ShowCloseButton(false)
		ResultPanel:Center()
		ResultPanel:SetTitle("")
		ResultPanel:SetDraggable(false)
		ResultPanel:MakePopup()
		ResultPanel:SetKeyboardInputEnabled(false)
		
		OK:SetText("X")
		OK:SetSize(w*0.015, h*0.03)
		OK:SetPos(w*0.775, h*0.115)
		
		local timetotal = 30
		local timestart = CurTime()
		
		ResultPanel.Paint = function(self, w, h)
			local timeremaining = math.ceil(timetotal - (CurTime() - timestart))
			local lang = language.GetPhrase
			-- Main black BG
			surface.SetDrawColor( 0, 0, 0, 200 )
			surface.DrawRect( 0, 0, w, h)
			
			surface.SetDrawColor( 61, 183, 255, 50 )
			surface.DrawRect( w*0.2, h*0.1, w*0.6, h*0.075)
			
			-- Upper Results Tab
			DrawIcon( UVMaterials['RESULTCOP'], w*0.225, h*0.135, .05, Color(61, 183, 255) ) -- Icon
			draw.DrawText( "#uv.results.pursuit", "UVFont5", w*0.25, h*0.115, Color( 61, 183, 255), TEXT_ALIGN_LEFT )
			
			-- Next Lower, results subtext
			surface.SetMaterial(UVMaterials['BACKGROUND_BIGGER'])
			-- surface.SetMaterial(Material("unitvehicles/hud/bg_anim"))
			surface.SetDrawColor( 61, 183, 255, 25 )
			surface.DrawTexturedRect( w*0.2, h*0.175, w*0.6, h*0.075)
			draw.DrawText( string.format( lang("uv.results.suspects.busted"), unit ), "UVFont5", w*0.5, h*0.19, Color( 255, 255, 255), TEXT_ALIGN_CENTER )
			
			-- All middle tabs, light ones
			local numRectsLight = 6
			for i=0, numRectsLight, 1 do
				local yPos = i * h * 0.08
				surface.SetDrawColor( 61, 183, 255, 25 )
				surface.DrawRect( w*0.2, h*0.25 + yPos, w*0.6, h*0.04)
			end
			
			-- All middle tabs, dark ones
			local numRectsDark = 5
			for i=0, numRectsDark, 1 do
				local yPos = i * h * 0.08
				surface.SetDrawColor( 0, 0, 0, 50 )
				surface.DrawRect( w*0.2, h*0.29 + yPos, w*0.6, h*0.04)
			end
			
			local h1, h2 = h*0.2475, h*0.2875
			
			-- Text
			draw.SimpleText( "#uv.results.chase.bounty", "UVFont5", w*0.205, h1, Color(61, 183, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.time", "UVFont5", w*0.205, h2, Color(61, 183, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.units.deployed", "UVFont5", w*0.205, h1 + h*0.08, Color(61, 183, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.units.damaged", "UVFont5", w*0.205, h2 + h*0.08, Color(61, 183, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.units.destroyed", "UVFont5", w*0.205, h1 + h*0.16, Color(61, 183, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.dodged.blocks", "UVFont5", w*0.205, h2 + h*0.16, Color(61, 183, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.dodged.spikes", "UVFont5", w*0.205, h1 + h*0.24, Color(61, 183, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			
			draw.SimpleText( bounty, "UVFont5", w*0.795, h1, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( time, "UVFont5", w*0.795, h2, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( deploys, "UVFont5", w*0.795, h1 + h*0.08, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( tags, "UVFont5", w*0.795, h2 + h*0.08, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( wrecks, "UVFont5", w*0.795, h1 + h*0.16, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( roadblocksdodged, "UVFont5", w*0.795, h2 + h*0.16, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( spikestripsdodged, "UVFont5", w*0.795, h1 + h*0.24, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			
			
			surface.SetDrawColor( 61, 183, 255, 25 )
			surface.SetMaterial(Material("unitvehicles/hud/bg_anim"))
			surface.DrawTexturedRect( w*0.2, h*0.7725, w*0.6, h*0.04)
			draw.DrawText( "[ " .. input.LookupBinding("+jump") .. " ] " .. lang("uv.results.continue"), "UVFont5", w*0.205, h*0.7675, Color( 61, 183, 255 ), TEXT_ALIGN_LEFT )
			
			-- Time remaining and closing
			draw.DrawText( string.format( language.GetPhrase("uv.results.autoclose"), timeremaining ), "UVFont5", w*0.795, h*0.7675, Color( 61, 183, 255 ), TEXT_ALIGN_RIGHT )
			if timeremaining < 1 then
				hook.Remove("Think", "CheckJumpKeyForDebrief")
				self:Close()
			end
			
		end
		
		function OK:DoClick() 
			hook.Remove("Think", "CheckJumpKeyForDebrief")
			ResultPanel:Close()
		end
		
		local wasJumping = false
		hook.Add("Think", "CheckJumpKeyForDebrief", function()
			local ply = LocalPlayer()
			if not IsValid(ply) then return end
			
			if ply:KeyDown(IN_JUMP) then
				if not wasJumping then
					wasJumping = true
					if IsValid(ResultPanel) then
						ResultPanel:Close()
						hook.Remove("Think", "CheckJumpKeyForDebrief")
					end
				end
			else
				wasJumping = false
			end
		end)
    end,
    onCopEscapedDebrief = function(...)

        local w = ScrW()
		local h = ScrH()

        local escapedtable = select( 1, ... )

        --------------------------------------

        local time = UVDisplayTime(UVTimerProgress)
		local deploys = escapedtable["Deploys"]
		local roadblocksdodged = escapedtable["Roadblocks"]
		local spikestripsdodged = escapedtable["Spikestrips"]
		local bounty = UVBounty
		local tags = UVTags
		local wrecks = UVWrecks
		local suspects = UVHUDWantedSuspectsNumber
		
		local ResultPanel = vgui.Create("DFrame")
		local OK = vgui.Create("DButton")
		
		ResultPanel:Add(OK)
		ResultPanel:SetSize(w, h)
		ResultPanel:SetBackgroundBlur(true)
		ResultPanel:ShowCloseButton(false)
		ResultPanel:Center()
		ResultPanel:SetTitle("")
		ResultPanel:SetDraggable(false)
		ResultPanel:MakePopup()
		ResultPanel:SetKeyboardInputEnabled(false)
		
		OK:SetText("X")
		OK:SetSize(w*0.015, h*0.03)
		OK:SetPos(w*0.775, h*0.115)
		
		local timetotal = 30
		local timestart = CurTime()
		
		ResultPanel.Paint = function(self, w, h)
			local timeremaining = math.ceil(timetotal - (CurTime() - timestart))
			local lang = language.GetPhrase
			-- Main black BG
			surface.SetDrawColor( 0, 0, 0, 200 )
			surface.DrawRect( 0, 0, w, h)
			
			surface.SetDrawColor( 61, 183, 255, 50 )
			surface.DrawRect( w*0.2, h*0.1, w*0.6, h*0.075)
			
			-- Upper Results Tab
			DrawIcon( UVMaterials['RESULTCOP'], w*0.225, h*0.135, .05, Color(61, 183, 255) ) -- Icon
			draw.DrawText( "#uv.results.pursuit", "UVFont5", w*0.25, h*0.115, Color( 61, 183, 255), TEXT_ALIGN_LEFT )
			
			-- Next Lower, results subtext
			surface.SetMaterial(UVMaterials['BACKGROUND_BIGGER'])
			-- surface.SetMaterial(Material("unitvehicles/hud/bg_anim"))
			surface.SetDrawColor( 61, 183, 255, 25 )
			surface.DrawTexturedRect( w*0.2, h*0.175, w*0.6, h*0.075)
			draw.DrawText( string.format(lang("uv.results.suspects.escaped.num"), UVHUDWantedSuspectsNumber), "UVFont5", w*0.5, h*0.19, Color( 255, 255, 255), TEXT_ALIGN_CENTER )
			
			-- All middle tabs, light ones
			local numRectsLight = 6
			for i=0, numRectsLight, 1 do
				local yPos = i * h * 0.08
				surface.SetDrawColor( 61, 183, 255, 25 )
				surface.DrawRect( w*0.2, h*0.25 + yPos, w*0.6, h*0.04)
			end
			
			-- All middle tabs, dark ones
			local numRectsDark = 5
			for i=0, numRectsDark, 1 do
				local yPos = i * h * 0.08
				surface.SetDrawColor( 0, 0, 0, 50 )
				surface.DrawRect( w*0.2, h*0.29 + yPos, w*0.6, h*0.04)
			end
			
			local h1, h2 = h*0.2475, h*0.2875
			
			-- Text
			draw.SimpleText( "#uv.results.chase.bounty", "UVFont5", w*0.205, h1, Color(61, 183, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.time", "UVFont5", w*0.205, h2, Color(61, 183, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.units.deployed", "UVFont5", w*0.205, h1 + h*0.08, Color(61, 183, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.units.damaged", "UVFont5", w*0.205, h2 + h*0.08, Color(61, 183, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.units.destroyed", "UVFont5", w*0.205, h1 + h*0.16, Color(61, 183, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.dodged.blocks", "UVFont5", w*0.205, h2 + h*0.16, Color(61, 183, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.dodged.spikes", "UVFont5", w*0.205, h1 + h*0.24, Color(61, 183, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			
			draw.SimpleText( bounty, "UVFont5", w*0.795, h1, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( time, "UVFont5", w*0.795, h2, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( deploys, "UVFont5", w*0.795, h1 + h*0.08, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( tags, "UVFont5", w*0.795, h2 + h*0.08, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( wrecks, "UVFont5", w*0.795, h1 + h*0.16, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( roadblocksdodged, "UVFont5", w*0.795, h2 + h*0.16, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( spikestripsdodged, "UVFont5", w*0.795, h1 + h*0.24, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			
			
			surface.SetDrawColor( 61, 183, 255, 25 )
			surface.SetMaterial(Material("unitvehicles/hud/bg_anim"))
			surface.DrawTexturedRect( w*0.2, h*0.7725, w*0.6, h*0.04)
			draw.DrawText( "[ " .. input.LookupBinding("+jump") .. " ] " .. lang("uv.results.continue"), "UVFont5", w*0.205, h*0.7675, Color( 61, 183, 255 ), TEXT_ALIGN_LEFT )
			
			-- Time remaining and closing
			draw.DrawText( string.format( language.GetPhrase("uv.results.autoclose"), timeremaining ), "UVFont5", w*0.795, h*0.7675, Color( 61, 183, 255 ), TEXT_ALIGN_RIGHT )
			if timeremaining < 1 then
				hook.Remove("Think", "CheckJumpKeyForDebrief")
				self:Close()
			end
			
		end
		
		function OK:DoClick() 
			hook.Remove("Think", "CheckJumpKeyForDebrief")
			ResultPanel:Close()
		end
		
		local wasJumping = false
		hook.Add("Think", "CheckJumpKeyForDebrief", function()
			local ply = LocalPlayer()
			if not IsValid(ply) then return end
			
			if ply:KeyDown(IN_JUMP) then
				if not wasJumping then
					wasJumping = true
					if IsValid(ResultPanel) then
						ResultPanel:Close()
						hook.Remove("Think", "CheckJumpKeyForDebrief")
					end
				end
			else
				wasJumping = false
			end
		end)
    end,
    onRacerEscapedDebrief = function(...)
        if UVHUDRace then return end
		
		local w = ScrW()
		local h = ScrH()

        local escapedtable = select( 1, ... )

        --------------------------------------

        local time = UVDisplayTime(UVTimerProgress)
		local deploys = escapedtable["Deploys"]
		local roadblocksdodged = escapedtable["Roadblocks"]
		local spikestripsdodged = escapedtable["Spikestrips"]
		local bounty = UVBounty
		local tags = UVTags
		local wrecks = UVWrecks
		
		local ResultPanel = vgui.Create("DFrame")
		local OK = vgui.Create("DButton")
		
		ResultPanel:Add(OK)
		ResultPanel:SetSize(w, h)
		ResultPanel:SetBackgroundBlur(true)
		ResultPanel:ShowCloseButton(false)
		ResultPanel:Center()
		ResultPanel:SetTitle("")
		ResultPanel:SetDraggable(false)
		ResultPanel:MakePopup()
		ResultPanel:SetKeyboardInputEnabled(false)
		
		OK:SetText("X")
		OK:SetSize(w*0.015, h*0.03)
		OK:SetPos(w*0.775, h*0.115)
		
		local timetotal = 30
		local timestart = CurTime()
		
		ResultPanel.Paint = function(self, w, h)
			local timeremaining = math.ceil(timetotal - (CurTime() - timestart))
			local lang = language.GetPhrase
			-- Main black BG
			surface.SetDrawColor( 0, 0, 0, 200 )
			surface.DrawRect( 0, 0, w, h)
			
			surface.SetDrawColor( 255, 183, 61, 50 )
			surface.DrawRect( w*0.2, h*0.1, w*0.6, h*0.075)
			
			-- Upper Results Tab
			DrawIcon( UVMaterials['RESULTCOP'], w*0.225, h*0.135, .05, Color(255, 183, 61) ) -- Icon
			draw.DrawText( "#uv.results.pursuit", "UVFont5", w*0.25, h*0.115, Color( 255, 183, 61), TEXT_ALIGN_LEFT )
			
			-- Next Lower, results subtext
			surface.SetMaterial(UVMaterials['BACKGROUND_BIGGER'])
			-- surface.SetMaterial(Material("unitvehicles/hud/bg_anim"))
			surface.SetDrawColor( 255, 183, 61, 25 )
			surface.DrawTexturedRect( w*0.2, h*0.175, w*0.6, h*0.075)
			draw.DrawText( "#uv.results.escapedfrom", "UVFont5", w*0.5, h*0.19, Color( 255, 255, 255), TEXT_ALIGN_CENTER )
			
			-- All middle tabs, light ones
			local numRectsLight = 6
			for i=0, numRectsLight, 1 do
				local yPos = i * h * 0.08
				surface.SetDrawColor( 255, 183, 61, 25 )
				surface.DrawRect( w*0.2, h*0.25 + yPos, w*0.6, h*0.04)
			end
			
			-- All middle tabs, dark ones
			local numRectsDark = 5
			for i=0, numRectsDark, 1 do
				local yPos = i * h * 0.08
				surface.SetDrawColor( 0, 0, 0, 50 )
				surface.DrawRect( w*0.2, h*0.29 + yPos, w*0.6, h*0.04)
			end
			
			local h1, h2 = h*0.2475, h*0.2875
			
			-- Text
			draw.SimpleText( "#uv.results.chase.bounty", "UVFont5", w*0.205, h1, Color(255, 183, 61), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.time", "UVFont5", w*0.205, h2, Color(255, 183, 61), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.units.deployed", "UVFont5", w*0.205, h1 + h*0.08, Color(255, 183, 61), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.units.damaged", "UVFont5", w*0.205, h2 + h*0.08, Color(255, 183, 61), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.units.destroyed", "UVFont5", w*0.205, h1 + h*0.16, Color(255, 183, 61), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.dodged.blocks", "UVFont5", w*0.205, h2 + h*0.16, Color(255, 183, 61), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.dodged.spikes", "UVFont5", w*0.205, h1 + h*0.24, Color(255, 183, 61), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			
			draw.SimpleText( bounty, "UVFont5", w*0.795, h1, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( time, "UVFont5", w*0.795, h2, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( deploys, "UVFont5", w*0.795, h1 + h*0.08, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( tags, "UVFont5", w*0.795, h2 + h*0.08, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( wrecks, "UVFont5", w*0.795, h1 + h*0.16, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( roadblocksdodged, "UVFont5", w*0.795, h2 + h*0.16, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( spikestripsdodged, "UVFont5", w*0.795, h1 + h*0.24, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			
			
			surface.SetDrawColor( 255, 183, 61, 25 )
			surface.SetMaterial(Material("unitvehicles/hud/bg_anim"))
			surface.DrawTexturedRect( w*0.2, h*0.7725, w*0.6, h*0.04)
			draw.DrawText( "[ " .. input.LookupBinding("+jump") .. " ] " .. lang("uv.results.continue"), "UVFont5", w*0.205, h*0.7675, Color( 255, 183, 61 ), TEXT_ALIGN_LEFT )
			
			-- Time remaining and closing
			draw.DrawText( string.format( language.GetPhrase("uv.results.autoclose"), timeremaining ), "UVFont5", w*0.795, h*0.7675, Color( 255, 183, 61 ), TEXT_ALIGN_RIGHT )
			if timeremaining < 1 then
				hook.Remove("Think", "CheckJumpKeyForDebrief")
				self:Close()
			end
			
		end
		
		function OK:DoClick() 
			hook.Remove("Think", "CheckJumpKeyForDebrief")
			ResultPanel:Close()
		end
		
		local wasJumping = false
		hook.Add("Think", "CheckJumpKeyForDebrief", function()
			local ply = LocalPlayer()
			if not IsValid(ply) then return end
			
			if ply:KeyDown(IN_JUMP) then
				if not wasJumping then
					wasJumping = true
					if IsValid(ResultPanel) then
						ResultPanel:Close()
						hook.Remove("Think", "CheckJumpKeyForDebrief")
					end
				end
			else
				wasJumping = false
			end
		end)
    end,
    onRacerBustedDebrief = function(...)
        local w = ScrW()
		local h = ScrH()

        local bustedtable = select( 1, ... )

        --------------------------------------

        local time = UVDisplayTime(UVTimerProgress)
		local unit = bustedtable["Unit"]
		local deploys = bustedtable["Deploys"]
		local roadblocksdodged = bustedtable["Roadblocks"]
		local spikestripsdodged = bustedtable["Spikestrips"]
		local bounty = UVBounty
		local tags = UVTags
		local wrecks = UVWrecks
		
		local ResultPanel = vgui.Create("DFrame")
		local OK = vgui.Create("DButton")
		
		ResultPanel:Add(OK)
		ResultPanel:SetSize(w, h)
		ResultPanel:SetBackgroundBlur(true)
		ResultPanel:ShowCloseButton(false)
		ResultPanel:Center()
		ResultPanel:SetTitle("")
		ResultPanel:SetDraggable(false)
		ResultPanel:MakePopup()
		ResultPanel:SetKeyboardInputEnabled(false)
		
		OK:SetText("X")
		OK:SetSize(w*0.015, h*0.03)
		OK:SetPos(w*0.775, h*0.115)
		
		local timetotal = 30
		local timestart = CurTime()
		
		ResultPanel.Paint = function(self, w, h)
			local timeremaining = math.ceil(timetotal - (CurTime() - timestart))
			local lang = language.GetPhrase
			-- Main black BG
			surface.SetDrawColor( 0, 0, 0, 200 )
			surface.DrawRect( 0, 0, w, h)
			
			surface.SetDrawColor( 255, 183, 61, 50 )
			surface.DrawRect( w*0.2, h*0.1, w*0.6, h*0.075)
			
			-- Upper Results Tab
			DrawIcon( UVMaterials['RESULTCOP'], w*0.225, h*0.135, .05, Color(255, 183, 61) ) -- Icon
			draw.DrawText( "#uv.results.pursuit", "UVFont5", w*0.25, h*0.115, Color( 255, 183, 61), TEXT_ALIGN_LEFT )
			
			-- Next Lower, results subtext
			surface.SetMaterial(UVMaterials['BACKGROUND_BIGGER'])
			-- surface.SetMaterial(Material("unitvehicles/hud/bg_anim"))
			surface.SetDrawColor( 255, 183, 61, 25 )
			surface.DrawTexturedRect( w*0.2, h*0.175, w*0.6, h*0.075)
			draw.DrawText( string.format(lang("uv.results.bustedby"), unit ), "UVFont5", w*0.5, h*0.19, Color( 255, 255, 255), TEXT_ALIGN_CENTER )
			
			-- All middle tabs, light ones
			local numRectsLight = 6
			for i=0, numRectsLight, 1 do
				local yPos = i * h * 0.08
				surface.SetDrawColor( 255, 183, 61, 25 )
				surface.DrawRect( w*0.2, h*0.25 + yPos, w*0.6, h*0.04)
			end
			
			-- All middle tabs, dark ones
			local numRectsDark = 5
			for i=0, numRectsDark, 1 do
				local yPos = i * h * 0.08
				surface.SetDrawColor( 0, 0, 0, 50 )
				surface.DrawRect( w*0.2, h*0.29 + yPos, w*0.6, h*0.04)
			end
			
			local h1, h2 = h*0.2475, h*0.2875
			
			-- Text
			draw.SimpleText( "#uv.results.chase.bounty", "UVFont5", w*0.205, h1, Color(255, 183, 61), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.time", "UVFont5", w*0.205, h2, Color(255, 183, 61), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.units.deployed", "UVFont5", w*0.205, h1 + h*0.08, Color(255, 183, 61), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.units.damaged", "UVFont5", w*0.205, h2 + h*0.08, Color(255, 183, 61), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.units.destroyed", "UVFont5", w*0.205, h1 + h*0.16, Color(255, 183, 61), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.dodged.blocks", "UVFont5", w*0.205, h2 + h*0.16, Color(255, 183, 61), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.dodged.spikes", "UVFont5", w*0.205, h1 + h*0.24, Color(255, 183, 61), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			
			draw.SimpleText( bounty, "UVFont5", w*0.795, h1, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( time, "UVFont5", w*0.795, h2, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( deploys, "UVFont5", w*0.795, h1 + h*0.08, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( tags, "UVFont5", w*0.795, h2 + h*0.08, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( wrecks, "UVFont5", w*0.795, h1 + h*0.16, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( roadblocksdodged, "UVFont5", w*0.795, h2 + h*0.16, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( spikestripsdodged, "UVFont5", w*0.795, h1 + h*0.24, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			
			
			surface.SetDrawColor( 255, 183, 61, 25 )
			surface.SetMaterial(Material("unitvehicles/hud/bg_anim"))
			surface.DrawTexturedRect( w*0.2, h*0.7725, w*0.6, h*0.04)
			draw.DrawText( "[ " .. input.LookupBinding("+jump") .. " ] " .. lang("uv.results.continue"), "UVFont5", w*0.205, h*0.7675, Color( 255, 183, 61 ), TEXT_ALIGN_LEFT )
			
			-- Time remaining and closing
			draw.DrawText( string.format( language.GetPhrase("uv.results.autoclose"), timeremaining ), "UVFont5", w*0.795, h*0.7675, Color( 255, 183, 61 ), TEXT_ALIGN_RIGHT )
			if timeremaining < 1 then
				hook.Remove("Think", "CheckJumpKeyForDebrief")
				self:Close()
			end
			
		end
		
		function OK:DoClick() 
			hook.Remove("Think", "CheckJumpKeyForDebrief")
			ResultPanel:Close()
		end
		
		local wasJumping = false
		hook.Add("Think", "CheckJumpKeyForDebrief", function()
			local ply = LocalPlayer()
			if not IsValid(ply) then return end
			
			if ply:KeyDown(IN_JUMP) then
				if not wasJumping then
					wasJumping = true
					if IsValid(ResultPanel) then
						ResultPanel:Close()
						hook.Remove("Think", "CheckJumpKeyForDebrief")
					end
				end
			else
				wasJumping = false
			end
		end)
    end
}

-- Functions

local function mw_racing_main( ... )
    local w = ScrW()
    local h = ScrH()
    
    local my_vehicle = select(1, ...)
    local my_array = select(2, ...)
    local string_array = select(3, ...)
    
    local racer_count = #string_array
    local lang = language.GetPhrase
    
    local checkpoint_count = #my_array["Checkpoints"]
    
    ------------------------------------
    
    -- Timer
    surface.SetMaterial(UVMaterials["RACE_BG_TIME"])
    surface.SetDrawColor(0, 0, 0, 255)
    surface.DrawTexturedRect(w * 0.8, h * 0.096, w * 0.19, h * 0.055)
    
    DrawIcon(UVMaterials["CLOCK"], w * 0.815, h * 0.124, .05, Colors.MW_Accent) -- Icon
    draw.DrawText(Carbon_FormatRaceTime((UVHUDRaceInfo.Info.Started and (CurTime() - UVHUDRaceInfo.Info.Time)) or 0),"UVFont5UI",w * 0.965,h * 0.1075,Colors.MW_Accent,TEXT_ALIGN_RIGHT)
    
    -- Lap & Checkpoint Counter
    surface.SetDrawColor(0, 0, 0, 175)
    surface.DrawRect(w * 0.8, h * 0.155, w * 0.174, h * 0.05)
    
    if UVHUDRaceInfo.Info.Laps > 1 then
        draw.DrawText("#uv.race.hud.lap","UVFont5UI",w * 0.805,h * 0.16,Color(255, 255, 255),TEXT_ALIGN_LEFT) -- Lap Counter
        draw.DrawText(my_array.Lap .. "/" .. UVHUDRaceInfo.Info.Laps,"UVFont5UI",w * 0.97,h * 0.16,Color(255, 255, 255),TEXT_ALIGN_RIGHT) -- Lap Counter
    else
        --DrawIcon(UVMaterials["CHECK"], w * 0.815, h * 0.18, .04, Color(255, 255, 255)) -- Icon
        draw.DrawText("#uv.race.hud.complete","UVFont5UI",w * 0.805,h * 0.16,Color(255, 255, 255),TEXT_ALIGN_LEFT)
        draw.DrawText(math.floor(((checkpoint_count / GetGlobalInt("uvrace_checkpoints")) * 100)) .. "%","UVFont5UI",w * 0.97,h * 0.16,Color(255, 255, 255),TEXT_ALIGN_RIGHT)
    end
    
    local racer_count = #string_array
    
    -- Position Counter
    if racer_count > 1 then
        surface.SetMaterial(UVMaterials["RACE_BG_POS"])
        surface.SetDrawColor(0, 0, 0, 255)
        surface.DrawTexturedRect(w * 0.7175, h * 0.094, w * 0.08, h * 0.112)
        
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawRect(w * 0.745, h * 0.15, w * 0.04, h * 0.005) -- Divider
        
        draw.DrawText(UVHUDRaceCurrentPos,"UVFont5",w * 0.765,h * 0.107,Colors.MW_Accent,TEXT_ALIGN_CENTER) -- Upper, Your Position
        draw.DrawText(UVHUDRaceCurrentParticipants,"UVFont5",w * 0.765,h * 0.155,Color(255, 255, 255), TEXT_ALIGN_CENTER) -- Lower, Total Positions
    end
    
    -- Racer List
    local alt = math.floor(CurTime() / 5) % 2 == 1 -- toggles every 5 seconds
    for i = 1, racer_count, 1 do
        if racer_count == 1 then
            return
        end
        local entry = string_array[i]
        
        local racer_name = entry[1]
        local is_local_player = entry[2]
        local mode = entry[3]
        local diff = entry[4]
        -- local racercount = i * (racer_count > 8 and w*0.0135 or w*0.0115)
        local racercount = i * w * 0.014
        -- local text = alt and (entry[3] .. "  " .. i) or (entry[2] .. "  " .. i)
        
        local Strings = {
            ["Time"] = "%s",
            ["Lap"] = lang("uv.race.suffix.lap"),
            -- ["Laps"] = lang("uv.race.suffix.laps"),
            ["Finished"] = lang("uv.race.suffix.finished"),
            ["Disqualified"] = lang("uv.race.suffix.dnf"),
            ["Busted"] = lang("uv.race.suffix.busted"),
        }
        
        local status_text = "- - - - -"
        
        if entry[3] then
            local status_string = Strings[entry[3]]
            
            if status_string then
                local args = {}
                
                if entry[4] then
                    local num = tonumber(entry[4])
                    num =
                    ((num > 0 and "+") or "-") ..
                    string.format((entry[3] == "Lap" and "%s") or "%.2f", math.abs(num))
                    
                    table.insert(args, num)
                end
                
                status_text = #args <= 0 and status_string or string.format(status_string, unpack(args))
            end
        end
        
        local color = nil
        
        if is_local_player then
            color = Colors.MW_LocalPlayer
        elseif entry[3] == "Disqualified" or entry[3] == "Busted" then
            color = Colors.MW_Disqualified
        else
            color = Colors.MW_Others
        end
        
        local text = alt and (status_text) or (racer_name)
        
        surface.SetDrawColor(0, 0, 0, 200)
        draw.NoTexture()
        surface.DrawRect(w * 0.7275, h * 0.185 + racercount, w * 0.2475, h * 0.025)
        
        draw.DrawText(i,"UVMostWantedLeaderboardFont",w * 0.73,(h * 0.185) + racercount,color,TEXT_ALIGN_LEFT)
        draw.DrawText(text,"UVMostWantedLeaderboardFont",w * 0.97,(h * 0.185) + racercount,color,TEXT_ALIGN_RIGHT)
    end
end

local function mw_pursuit_main( ... )
    local hudyes = GetConVar("cl_drawhud"):GetBool()
    
    if not hudyes then return end
    if not UVHUDDisplayPursuit then return end
    
    local vehicle = LocalPlayer():GetVehicle()
    
    local w = ScrW()
    local h = ScrH()
    local lang = language.GetPhrase
    
    local UnitsChasing = tonumber(UVUnitsChasing)
    local UVBustTimer = BustedTimer:GetFloat()
    
    local states = UV_UI.pursuit.mostwanted.states
    
    local UVWrecksColor = states.WrecksColor
    local UVTagsColor = states.TagsColor
    local UVUnitsColor = states.UnitsColor
    
    --------------------------------------------------
    
    outofpursuit = CurTime()
    
    local UVHeatBountyMin
    local UVHeatBountyMax
	
    states.EvasionColor = Color(255, 255, 255, 50)
    states.BustedColor = Color(255, 255, 255, 50)
    
    if vehicle == NULL then return end
    
    if UVHUDCopMode and not UVHUDDisplayNotification then
        UVHUDDisplayBusting = false
    end
    
    if UVHUDCopMode and next(UVHUDWantedSuspects) ~= nil then
        local ply = LocalPlayer()
        
        UVClosestSuspect = nil
        UVHUDDisplayBusting = false
        
        local closestDistance = math.huge
        
        for _, suspect in pairs(UVHUDWantedSuspects) do
            if not IsValid(suspect) then continue end
            local dist = ply:GetPos():DistToSqr(suspect:GetPos())
            
            if (#UVHUDWantedSuspects == 1 or dist < 250000) and dist < closestDistance then
                closestDistance = dist
                UVClosestSuspect = suspect
            end
        end
        
        if UVClosestSuspect then
            if UVClosestSuspect.beingbusted then
                UVHUDDisplayBusting = true
                UVBustingProgress = UVClosestSuspect.uvbustingprogress
                
                local blink = 255 * math.abs(math.sin(RealTime() * 8))
                states.BustedColor = Color(255, blink, blink)
            end
        end
    end
    
    if not UVHUDRace then
        local ResourceText = UVResourcePoints
        
        -- [[ Commander Stuff ]]
        if UVOneCommanderActive then
            if not UVHUDCommanderLastHealth or not UVHUDCommanderLastMaxHealth then
                UVHUDCommanderLastHealth = 0
                UVHUDCommanderLastMaxHealth = 0
            end
            if IsValid(UVHUDCommander) then
                if UVHUDCommander.IsSimfphyscar then
                    UVHUDCommanderLastHealth = UVHUDCommander:GetCurHealth()
                    UVHUDCommanderLastMaxHealth =
                    UVUOneCommanderHealth:GetInt() - (UVHUDCommander:GetMaxHealth() * 0.3)
                elseif UVHUDCommander.IsGlideVehicle then
                    local enginehealth = UVHUDCommander:GetEngineHealth()
                    UVHUDCommanderLastHealth = UVHUDCommander:GetChassisHealth() * enginehealth
                    UVHUDCommanderLastMaxHealth = UVUOneCommanderHealth:GetInt()
                elseif vcmod_main then
                    UVHUDCommanderLastHealth =
                    UVUOneCommanderHealth:GetInt() * (UVHUDCommander:VC_getHealth() / 100) --vcmod returns % health clientside
                    UVHUDCommanderLastMaxHealth = UVUOneCommanderHealth:GetInt()
                else
                    UVHUDCommanderLastHealth = UVHUDCommander:Health()
                    UVHUDCommanderLastMaxHealth = UVUOneCommanderHealth:GetInt()
                end
            end
            local healthratio = UVHUDCommanderLastHealth / UVHUDCommanderLastMaxHealth
            local healthcolor
            if healthratio >= 0.5 then
                healthcolor = Color(255, 255, 255, 200)
            elseif healthratio >= 0.25 then
                if math.floor(RealTime() * 2) == math.Round(RealTime() * 2) then
                    healthcolor = Color(255, 0, 0)
                else
                    healthcolor = Color(255, 255, 255)
                end
            else
                if math.floor(RealTime() * 4) == math.Round(RealTime() * 4) then
                    healthcolor = Color(255, 0, 0)
                else
                    healthcolor = Color(255, 255, 255)
                end
            end
            ResourceText = "⛊"
            local element3 = {
                {x = w / 3, y = 0},
                {x = w / 3 + 12 + w / 3, y = 0},
                {x = w / 3 + 12 + w / 3 - 25, y = h / 20},
                {x = w / 3 + 25, y = h / 20}
            }
            surface.SetDrawColor(0, 0, 0, 200)
            draw.NoTexture()
            surface.DrawPoly(element3)
            if healthratio > 0 then
                surface.SetDrawColor(Color(109, 109, 109, 200))
                surface.DrawRect(w / 3 + 25, h / 20, w / 3 - 38, 8)
                surface.SetDrawColor(healthcolor)
                local T = math.Clamp((healthratio) * (w / 3 - 38), 0, w / 3 - 38)
                surface.DrawRect(w / 3 + 25, h / 20, T, 8)
            end
            draw.DrawText("⛊ " .. lang("uv.unit.commander") .. " ⛊","UVFont5UI-BottomBar",w / 2,0,Color(0, 161, 255),TEXT_ALIGN_CENTER)
        end
		
        local theme_color = (UVHUDCopMode and table.Copy(Colors.MW_Cop)) or table.Copy(Colors.MW_Racer)
		
        -- [ Upper Right Info Box ] --
        -- Full BG
		if UVHUDCopMode then
			surface.SetDrawColor(61, 184, 255, 100 * math.abs(math.sin(RealTime() * 2.75))) -- Main border
		else
			surface.SetDrawColor(223, 184, 127, 100 * math.abs(math.sin(RealTime() * 2.75))) -- Main border
		end
		surface.SetMaterial(UVMaterials["PURSUIT_BG_PULSE"])
        surface.DrawTexturedRect(w * 0.7, h * 0.101, w * 0.275, h * 0.1175)
        
        surface.SetDrawColor(0, 0, 0, 255) -- Timer BG
		surface.SetMaterial(UVMaterials["PURSUIT_BG_TOP"])
        surface.DrawTexturedRect(w * 0.7125, h * 0.1075, w * 0.2575, h * 0.05)
        
        surface.SetDrawColor(0, 0, 0, 255) -- Bounty BG
		surface.SetMaterial(UVMaterials["PURSUIT_BG_BOTTOM"])
        surface.DrawTexturedRect(w * 0.707, h * 0.16, w * 0.2625, h * 0.05)
        
        -- Timer
        DrawIcon(UVMaterials["CLOCK"], w * 0.735, h * 0.1325, .0625, UVHUDCopMode and Colors.MW_Cop or Colors.MW_Accent) -- Icon
        draw.DrawText(UVTimer, "UVFont5UI", w * 0.965, h * 0.115, UVHUDCopMode and Colors.MW_Cop or Colors.MW_Accent, TEXT_ALIGN_RIGHT)
        
        -- Bounty
        draw.DrawText("#uv.hud.bounty","UVFont5UI",w * 0.7175,h * 0.1625,Color(255, 255, 255),TEXT_ALIGN_LEFT) -- Bounty Text
        draw.DrawText(UVBounty, "UVFont5UI", w * 0.965, h * 0.1625, Color(255, 255, 255), TEXT_ALIGN_RIGHT) -- Bounty Counter
        
        -- Heat Level
        surface.SetDrawColor(0, 0, 0, 200)
        surface.DrawRect(w * 0.7075, h * 0.2175, w * 0.035, h * 0.035)
        
        if UVHeatLevel == 1 then
            UVHeatBountyMin = UVUHeatMinimumBounty1:GetInt()
            UVHeatBountyMax = UVUHeatMinimumBounty2:GetInt()
        elseif UVHeatLevel == 2 then
            UVHeatBountyMin = UVUHeatMinimumBounty2:GetInt()
            UVHeatBountyMax = UVUHeatMinimumBounty3:GetInt()
        elseif UVHeatLevel == 3 then
            UVHeatBountyMin = UVUHeatMinimumBounty3:GetInt()
            UVHeatBountyMax = UVUHeatMinimumBounty4:GetInt()
        elseif UVHeatLevel == 4 then
            UVHeatBountyMin = UVUHeatMinimumBounty4:GetInt()
            UVHeatBountyMax = UVUHeatMinimumBounty5:GetInt()
        elseif UVHeatLevel == 5 then
            UVHeatBountyMin = UVUHeatMinimumBounty5:GetInt()
            UVHeatBountyMax = UVUHeatMinimumBounty6:GetInt()
        elseif UVHeatLevel == 6 then
            UVHeatBountyMin = UVUHeatMinimumBounty6:GetInt()
            UVHeatBountyMax = math.huge
        end
        
        DrawIcon(UVMaterials["HEAT"], w * 0.7175, h * 0.2325, .0375, Color(255, 255, 255)) -- Icon
        draw.DrawText(UVHeatLevel, "UVFont5UI", w * 0.7375, h * 0.2125, Color(255, 255, 255), TEXT_ALIGN_RIGHT)
        
        surface.SetDrawColor(Color(109, 109, 109, 200))
        surface.DrawRect(w * 0.745, h * 0.2175, w * 0.2225, h * 0.035)
        surface.SetDrawColor(Color(255, 255, 255))
        local HeatProgress = 0
        if MaxHeatLevel:GetInt() ~= UVHeatLevel then
            if UVUTimeTillNextHeatEnabled:GetInt() == 1 and UVTimeTillNextHeat then --Time till next heat level
                if UVHeatLevel == 1 then
                    local maxtime = UVUTimeTillNextHeat1:GetInt()
                    HeatProgress = (maxtime - UVTimeTillNextHeat) / maxtime
                elseif UVHeatLevel == 2 then
                    local maxtime = UVUTimeTillNextHeat2:GetInt()
                    HeatProgress = (maxtime - UVTimeTillNextHeat) / maxtime
                elseif UVHeatLevel == 3 then
                    local maxtime = UVUTimeTillNextHeat3:GetInt()
                    HeatProgress = (maxtime - UVTimeTillNextHeat) / maxtime
                elseif UVHeatLevel == 4 then
                    local maxtime = UVUTimeTillNextHeat4:GetInt()
                    HeatProgress = (maxtime - UVTimeTillNextHeat) / maxtime
                elseif UVHeatLevel == 5 then
                    local maxtime = UVUTimeTillNextHeat5:GetInt()
                    HeatProgress = (maxtime - UVTimeTillNextHeat) / maxtime
                elseif UVHeatLevel == 6 then
                    HeatProgress = 0
                end
            else
                HeatProgress = ((UVBountyNo - UVHeatBountyMin) / (UVHeatBountyMax - UVHeatBountyMin))
            end
        end
        local B = math.Clamp((HeatProgress) * w * 0.2225, 0, w * 0.2225)
        local blink = 255 * math.abs(math.sin(RealTime() * 4))
        local blink2 = 255 * math.abs(math.sin(RealTime() * 6))
        local blink3 = 255 * math.abs(math.sin(RealTime() * 8))
        
        if HeatProgress >= 0.6 and HeatProgress < 0.75 then
            surface.SetDrawColor(Color(255, blink, blink))
        elseif HeatProgress >= 0.75 and HeatProgress < 0.9 then
            surface.SetDrawColor(Color(255, blink2, blink2))
        elseif HeatProgress >= 0.9 and HeatProgress < 1 then
            surface.SetDrawColor(Color(255, blink3, blink3))
        elseif HeatProgress >= 1 then
            surface.SetDrawColor(Color(255, 0, 0))
        end

        surface.DrawRect(w * 0.745, h * 0.2175, B, h * 0.035)
        
        -- [ Bottom Info Box ] --
        local middlergb = {
            r = 255,
            g = 255,
            b = 255,
            a = 255 * math.abs(math.sin(RealTime() * 4))
        }
        local bottomy = h * 0.86
        local bottomy2 = h * 0.9
        local bottomy3 = h * 0.91
        local bottomy4 = h * 0.81
        local bottomy5 = h * 0.83
        local bottomy6 = h * 0.79
        
        if not UVHUDDisplayCooldown then
            -- General Icons
            draw.DrawText( UVWrecks, "UVFont5UI", w * 0.64, h * 0.825, UVWrecksColor, TEXT_ALIGN_RIGHT)
            DrawIcon(UVMaterials["UNITS_DISABLED"], w * 0.6525, h * 0.84, 0.06, UVWrecksColor)
            
            draw.DrawText(UVTags, "UVFont5UI", w * 0.3625, h * 0.825, UVTagsColor, TEXT_ALIGN_LEFT)
            DrawIcon(UVMaterials["UNITS_DAMAGED"], w * 0.35, h * 0.84, 0.06, UVTagsColor)
            
            draw.DrawText(ResourceText,"UVFont5UI-BottomBar",w * 0.5,h * 0.825,UVUnitsColor,TEXT_ALIGN_CENTER)
            DrawIcon(UVMaterials["UNITS"], w * 0.5, h * 0.8, .07, UVUnitsColor)
            
            -- Evade Box, All BG
            surface.SetDrawColor(200, 200, 200, 100)
            surface.DrawRect(w * 0.333, bottomy2, w * 0.34, h * 0.01)
            
            -- Evade Box, Busted Meter
            if UVHUDDisplayBusting and not UVHUDDisplayCooldown then
                if not BustingProgress or BustingProgress == 0 then
                    BustingProgress = CurTime()
                end
                
                local blink = 255 * math.abs(math.sin(RealTime() * 4))
                local blink2 = 255 * math.abs(math.sin(RealTime() * 6))
                local blink3 = 255 * math.abs(math.sin(RealTime() * 8))
                
                local timeLeft = ((UVHUDDisplayNotification and -1) or (UVBustTimer - UVBustingProgress))
                
                local playbusting = (UVHUDCopMode and UVHUDWantedSuspectsNumber == 1) or not UVHUDCopMode
                
                if timeLeft >= UVBustTimer * 0.5 then
                    states.BustedColor = Color(255, 0, 0, blink)
                    -- UVSoundBusting()
                elseif timeLeft >= UVBustTimer * 0.2 then
                    states.BustedColor = Color(255, 0, 0, blink2)
                    if playbusting then
                        UVSoundBusting()
                    end
                elseif timeLeft >= 0 then
                    states.BustedColor = Color(255, 0, 0, blink3)
                    if playbusting then
                        UVSoundBusting()
                    end
                else
                    states.BustedColor = Color(255, 0, 0)
                end
                
                local T = math.Clamp((UVBustingProgress / UVBustTimer) * (w * 0.1515), 0, w * 0.1515)
				T = math.floor(T)
                surface.SetDrawColor(255, 0, 0)
                surface.DrawRect(w * 0.333 + (w * 0.1515 - T), bottomy2, T, h * 0.01)
                middlergb = {
                    r = 255,
                    g = 0,
                    b = 0,
                    a = 255
                }
            else
                UVBustedColor = Color(255, 255, 255, 50)
                BustingProgress = 0
            end
            
            -- Evade Box, Evade Meter
            if not UVHUDDisplayNotification and not UVHUDDisplayCooldown and UnitsChasing == 0 then
                --UVSoundHeat(UVHeatLevel)
                if not EvadingProgress or EvadingProgress == 0 then
                    EvadingProgress = CurTime()
                    UVEvadingProgress = EvadingProgress
                end
                
                local T = math.Clamp((UVEvadingProgress) * (w * 0.16225), 0, w * 0.16225)
                surface.SetDrawColor(155, 207, 0)
                surface.DrawRect(w * 0.51, bottomy2, T, h * 0.01)
                middlergb = {
                    r = 155,
                    g = 207,
                    b = 0,
                    a = 255
                }
                
                states.EvasionColor = Color(blink, 255, blink)
            else
                EvadingProgress = 0
            end
            
            -- Evade Box, Middle
            surface.SetDrawColor(middlergb.r, middlergb.g, middlergb.b, middlergb.a)
            surface.DrawRect(w * 0.49, bottomy2, w * 0.021, h * 0.01)
            
            -- Evade Box, Dividers
            surface.SetDrawColor(255, 255, 255, 255)
            surface.DrawRect(w * 0.485, bottomy2, w * 0.005, h * 0.01)
            surface.DrawRect(w * 0.4, bottomy2, w * 0.005, h * 0.01)
            
            surface.DrawRect(w * 0.51, bottomy2, w * 0.005, h * 0.01)
            surface.DrawRect(w * 0.6, bottomy2, w * 0.005, h * 0.01)
            
            -- Upper Box
            surface.SetDrawColor(0, 0, 0, 255)
			surface.SetMaterial(UVMaterials["PURSUIT_BG_BOTBAR_ALT"])
			surface.DrawTexturedRect(w * 0.303, h * 0.84, w * 0.4015, h * 0.06)

            draw.DrawText("#uv.chase.busted","UVFont5UI",w * 0.34,h * 0.8625,states.BustedColor,TEXT_ALIGN_LEFT)
            draw.DrawText("#uv.chase.evade","UVFont5UI",w * 0.66,h * 0.8625,states.EvasionColor,TEXT_ALIGN_RIGHT)
            
            -- Lower Box
            local shade_theme_color =
            (UVHUDCopMode and table.Copy(Colors.MW_CopShade)) or table.Copy(Colors.MW_RacerShade)
            local theme_color =
            (UVHUDCopMode and table.Copy(Colors.MW_Cop)) or table.Copy(Colors.MW_Racer)

            surface.SetDrawColor(theme_color:Unpack())
			surface.SetMaterial(UVMaterials["PURSUIT_BG_BOTBAR"])
			surface.DrawTexturedRect(w * 0.302, h * 0.9125, w * 0.4015, h * 0.06)

            local lbtext = "REPLACEME"
            local uloc, utype = "uv.chase.unit", UnitsChasing
            if not UVHUDCopMode then
                if UnitsChasing ~= 1 then
                    uloc = "uv.chase.units"
                end
            else
                utype = UVHUDWantedSuspectsNumber
                uloc = "uv.chase.suspects"
            end
            
            --local color = Color(255,255,255)
            if not UVBackupColor then
                UVBackupColor = Color(255, 255, 255)
            end
            local num = UVBackupTimerSeconds
            
            if not UVHUDDisplayBackupTimer then
                lbtext = string.format(lang(uloc), utype)
            else
                if num then
                    if num < 10 and _last_backup_pulse_second ~= math.floor(num) then
                        _last_backup_pulse_second = math.floor(num)
                        
                        hook.Remove("Think", "UVBackupColorPulse")
                        UVBackupColor = Color(255, 255, 0)
                        
                        hook.Add("Think","UVBackupColorPulse",function()
                            UVBackupColor.b = UVBackupColor.b + 600 * RealFrameTime()
                            if UVBackupColor.b >= 255 then
                                hook.Remove("Think", "UVBackupColorPulse")
                            end
                        end)
                    end
                end
                
                lbtext = string.format(lang("uv.chase.backupin"), UVBackupTimer)
            end
            
            draw.DrawText(lbtext,"UVFont5UI",w * 0.5,bottomy3 * 1.001,UVBackupColor,TEXT_ALIGN_CENTER)
        else
            -- Lower Box
            -- Evade Box, All BG (Moved to inner if clauses)
            
            -- Evade Box, Cooldown Meter
            if UVHUDDisplayCooldown then
                if not CooldownProgress or CooldownProgress == 0 then
                    CooldownProgress = CurTime()
                end
                
                UVSoundCooldown()
                EvadingProgress = 0
                
                -- Upper Box
                if not UVHUDCopMode then
                    if UVHUDDisplayHidingPrompt then
                        local blink = 200 * math.abs(math.sin(RealTime() * 2))
						
                        surface.SetDrawColor(0, 175, 0, 200)
						surface.SetMaterial(UVMaterials["PURSUIT_BG_BOTBAR_ALT"])
						surface.DrawTexturedRect(w * 0.303, h * 0.84, w * 0.4015, h * 0.06)

						DrawIcon(UVMaterials["HIDECAR"], w * 0.5, h * 0.835, .07, Color(blink, 255, blink))
                        draw.DrawText( "#uv.chase.hiding", "UVFont5UI", w * 0.5, h * 0.8625, Color(255,255,255), TEXT_ALIGN_CENTER)
                    end
                    
                    surface.SetDrawColor(255, 255, 255, 50)
                    surface.DrawRect(w * 0.333, h * 0.9, w * 0.34, h * 0.01)
                    
                    local T = math.Clamp((UVCooldownTimer) * (w * 0.34), 0, w * 0.34)
                    surface.SetDrawColor(75, 75, 255)
                    surface.DrawRect(w * 0.333, h * 0.9, T, h * 0.01)
                    
                    surface.SetDrawColor(0, 0, 0)
					surface.SetMaterial(UVMaterials["PURSUIT_BG_BOTBAR"])
					surface.DrawTexturedRect(w * 0.302, h * 0.9125, w * 0.4015, h * 0.06)

                    draw.DrawText("#uv.chase.cooldown", "UVFont5UI", w * 0.5, h * 0.91, Color(255, 255, 255), TEXT_ALIGN_CENTER)
                else
                    local shade_theme_color = (UVHUDCopMode and table.Copy(Colors.MW_CopShade)) or table.Copy(Colors.MW_RacerShade)
                    local theme_color = (UVHUDCopMode and table.Copy(Colors.MW_Cop)) or table.Copy(Colors.MW_Racer)
                    
                    -- surface.SetDrawColor( shade_theme_color:Unpack() )
                    -- surface.DrawRect( w*0.333, bottomy2, w*0.34, h*0.01)
                    
                    -- shade_theme_color.a = shade_theme_color.a - 35
                    -- theme_color.a = theme_color.a - 35
                    
                    local blink = 255 * math.Clamp(math.abs(math.sin(RealTime())), .7, 1)
                    -- color = Color(blink, blink, 255)
                    
                    -- surface.SetDrawColor(shade_theme_color:Unpack())
                    -- surface.DrawRect(w * 0.333, bottomy3, w * 0.34, h * 0.05)
                    
                    surface.SetDrawColor(theme_color:Unpack())
                    surface.SetMaterial(UVMaterials["PURSUIT_BG_BOTBAR"])
					surface.DrawTexturedRect(w * 0.302, h * 0.9125, w * 0.4015, h * 0.06)

                    draw.DrawText("#uv.chase.cooldown", "UVFont5UI", w * 0.5, h * 0.91, Color(255, 255, 255), TEXT_ALIGN_CENTER)
					
					DrawIcon(UVMaterials["HIDECAR"], w * 0.5, h * 0.875, .07, Colors.MW_Cop)
                end
            else
                CooldownProgress = 0
            end
        end
    end
end

UV_UI.pursuit.mostwanted.main = mw_pursuit_main
UV_UI.racing.mostwanted.main = mw_racing_main

-- Undercover

UV_UI.racing.undercover = {}
UV_UI.pursuit.undercover = {}

UV_UI.pursuit.undercover.states = {
    TagsColor = Color(255,255,255,150),
    WrecksColor = Color(255,255,255,150),
    UnitsColor = Color(255,255,255,150),
    BustedColor = Color(255, 255, 255, 50),
    EvasionColor = Color(255, 255, 255, 50),
}

UV_UI.pursuit.undercover.events = {
    onUnitDeploy = function(...)
        local new_value = select (1, ...)
        local old_value = select (2, ...)

        print(new_value, old_value)
    end,

    onUnitWreck = function(...)
        hook.Remove("Think", "MW_WRECKS_COLOR_PULSE")
        
        if timer.Exists("MW_WRECKS_COLOR_PULSE_DELAY") then timer.Remove("MW_WRECKS_COLOR_PULSE_DELAY") end
        UV_UI.pursuit.mostwanted.states.WrecksColor = Color(255,255,0, 150)
        
        timer.Create("MW_WRECKS_COLOR_PULSE_DELAY", 1, 1, function()
            hook.Add("Think", "MW_WRECKS_COLOR_PULSE", function()
                UV_UI.pursuit.mostwanted.states.WrecksColor.b = UV_UI.pursuit.mostwanted.states.WrecksColor.b + 600 * RealFrameTime()
                if UV_UI.pursuit.mostwanted.states.WrecksColor.b >= 255 then hook.Remove("Think", "MW_WRECKS_COLOR_PULSE") end
            end)
        end)
        
    end,
    onUnitTag = function(...)
        
        hook.Remove("Think", "MW_TAGS_COLOR_PULSE")
        if timer.Exists("MW_TAGS_COLOR_PULSE_DELAY") then timer.Remove("MW_TAGS_COLOR_PULSE_DELAY") end
        
        UV_UI.pursuit.mostwanted.states.TagsColor = Color(255,255,0, 150)
        
        timer.Create("MW_TAGS_COLOR_PULSE_DELAY", 1, 1, function()
            
            hook.Add("Think", "MW_TAGS_COLOR_PULSE", function()
                UV_UI.pursuit.mostwanted.states.TagsColor.b = UV_UI.pursuit.mostwanted.states.TagsColor.b + 600 * RealFrameTime()
                if UV_UI.pursuit.mostwanted.states.TagsColor.b >= 255 then hook.Remove("Think", "MW_TAGS_COLOR_PULSE") end
            end)
            
        end)
        
    end,
    onResourceChange = function(...)
        
        local new_data = select( 1, ... )
        local old_data = select( 2, ... )
        
        hook.Remove("Think", "MW_RP_COLOR_PULSE")
        UV_UI.pursuit.mostwanted.states.UnitsColor = (new_data < (old_data or 0) and Color(255,50,50, 150)) or Color(50,255,50, 150)
        --UVResourcePointsColor = (rp_num < UVResourcePoints and Color(255,50,50)) or Color(50,255,50)
        
        local clrs = {}
        
        for _, v in pairs( { 'r', 'g', 'b' } ) do
            if UV_UI.pursuit.mostwanted.states.UnitsColor[v] ~= 255 then table.insert(clrs, v) end
        end 
        
        -- if timer.Exists("UVWrecksColor") then
        -- 	timer.Remove("UVWrecksColor")
        -- end
        local val = 50
        
        hook.Add("Think", "MW_RP_COLOR_PULSE", function()
            val = val + 200 * RealFrameTime()
            -- UVResourcePointsColor.b = val
            -- UVResourcePointsColor.g = val
            for _, v in pairs( clrs ) do
                UV_UI.pursuit.mostwanted.states.UnitsColor[v] = val
            end
            
            if val >= 255 then hook.Remove("Think", "MW_RP_COLOR_PULSE") end
        end)
        
    end,
    onChasingUnitsChange = function(...)
        
    end,
    onHeatLevelUpdate = function(...)
        
    end,
    onCopBustedDebrief = function(...)
        local w = ScrW()
		local h = ScrH()

        local bustedtable = select( 1, ... )

        --------------------------------------

        local time = UVDisplayTime(UVTimerProgress)
		local deploys = bustedtable["Deploys"]
		local roadblocksdodged = bustedtable["Roadblocks"]
		local spikestripsdodged = bustedtable["Spikestrips"]
		local bounty = UVBounty
		local tags = UVTags
		local wrecks = UVWrecks
		local suspects = UVHUDWantedSuspectsNumber
		
		local ResultPanel = vgui.Create("DFrame")
		local OK = vgui.Create("DButton")
		
		ResultPanel:Add(OK)
		ResultPanel:SetSize(w, h)
		ResultPanel:SetBackgroundBlur(true)
		ResultPanel:ShowCloseButton(false)
		ResultPanel:Center()
		ResultPanel:SetTitle("")
		ResultPanel:SetDraggable(false)
		ResultPanel:MakePopup()
		ResultPanel:SetKeyboardInputEnabled(false)
		
		ResultPanel:Add(OK)
		ResultPanel:SetSize(w, h)
		ResultPanel:SetBackgroundBlur(true)
		ResultPanel:ShowCloseButton(false)
		ResultPanel:Center()
		ResultPanel:SetTitle("")
		ResultPanel:SetDraggable(false)
		ResultPanel:MakePopup()
		ResultPanel:SetKeyboardInputEnabled(false)
		
		OK:SetText("X")
		OK:SetSize(w*0.015, h*0.03)
		OK:SetPos(w*0.635, h*0.225)
		
		local timetotal = 30
		local timestart = CurTime()
		
		ResultPanel.Paint = function(self, w, h)
			local timeremaining = math.ceil(timetotal - (CurTime() - timestart))
			local lang = language.GetPhrase

			-- Main black BG
			surface.SetDrawColor( 20, 53, 91, 240 )
			surface.DrawRect( 0, 0, w, h)
			
			-- Upper Results Tab
			surface.SetDrawColor( 0, 0, 0, 235 )
			surface.DrawRect( w*0.33, h*0.215, w*0.33, h*0.06)

			local blend = (math.sin(CurTime() * 6) + 1) / 2
			
			surface.SetMaterial(UVMaterials["ARREST_LIGHT_UC"])
			surface.SetDrawColor( 255 * blend, 0, 255 * (1 - blend), 175 )
			surface.DrawTexturedRect( w*0.33, h*0.215, w*0.33, h*0.06)

			draw.DrawText("#uv.results.won", "UVUndercoverWhiteFont", w*0.332, h*0.22, Color( 255, 200, 50), TEXT_ALIGN_LEFT )

			-- Busted Tab
			surface.SetMaterial(UVMaterials["ARREST_BG_UC"])
			surface.SetDrawColor( 255, 255, 255 )
			surface.DrawTexturedRect( w*0.25, h*0.2735, w*0.5, h*0.06)

			-- All middle tabs, dark ones
			local numRectsDark = 5
			for i=0, numRectsDark, 1 do
				local yPos = i * h * 0.0675
				surface.SetDrawColor( 50, 50, 50, 150 )
				surface.DrawRect( w*0.33, h*0.275 + yPos, w*0.33, h*0.035)
			end
			
			-- All middle tabs, light ones
			local numRectsLight = 4
			for i=0, numRectsLight, 1 do
				local yPos = i * h * 0.0675
				surface.SetDrawColor( 150, 150, 150, 75 )
				surface.DrawRect( w*0.33, h*0.3075 + yPos, w*0.33, h*0.035)
			end

			local h1, h2 = h*0.34, h*(0.34 + 0.0325)
			
			-- Text
			draw.DrawText( "#uv.results.suspects.busted", "UVUndercoverAccentFont", w*0.332, h2 - h*0.0675, Color( 255, 255, 255), TEXT_ALIGN_LEFT )
			draw.SimpleText( "#uv.results.chase.bounty", "UVUndercoverAccentFont", w*0.332, h1, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.time", "UVUndercoverAccentFont", w*0.332, h2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.units.deployed", "UVUndercoverAccentFont", w*0.332, h1 + h*0.0675, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.units.damaged", "UVUndercoverAccentFont", w*0.332, h2 + h*0.0675, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.units.destroyed", "UVUndercoverAccentFont", w*0.332, h1 + h*0.135, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.dodged.blocks", "UVUndercoverAccentFont", w*0.332, h2 + h*0.135, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.dodged.spikes", "UVUndercoverAccentFont", w*0.332, h1 + h*0.2025, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

			-- draw.SimpleText( unit, "UVUndercoverAccentFont", w*0.6575, h2 - h*0.0675, Color( 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( "$" .. bounty, "UVUndercoverAccentFont", w*0.6575, h1, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( time, "UVUndercoverAccentFont", w*0.6575, h2, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( deploys, "UVUndercoverAccentFont", w*0.6575, h1 + h*0.0675, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( tags, "UVUndercoverAccentFont", w*0.6575, h2 + h*0.0675, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( wrecks, "UVUndercoverAccentFont", w*0.6575, h1 + h*0.135, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( roadblocksdodged, "UVUndercoverAccentFont", w*0.6575, h2 + h*0.135, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( spikestripsdodged, "UVUndercoverAccentFont", w*0.6575, h1 + h*0.2025, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			
			
			-- Time remaining and closing
			surface.SetDrawColor( 0, 0, 0, 235 )
			surface.DrawRect( w*0.33, h*0.6425, w*0.33, h*0.06)
			
			draw.DrawText( lang("uv.results.continue") .. " [" .. input.LookupBinding("+jump") .. "]", "UVUndercoverAccentFont", w*0.332, h*0.6525, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT )
			draw.DrawText( string.format( language.GetPhrase("uv.results.autoclose"), timeremaining ), "UVUndercoverAccentFont", w*0.6575, h*0.61, Color( 255, 255, 255 ), TEXT_ALIGN_RIGHT )

			if timeremaining < 1 then
				hook.Remove("Think", "CheckJumpKeyForDebrief")
				self:Close()
			end
			
		end
		
		function OK:DoClick() 
			hook.Remove("Think", "CheckJumpKeyForDebrief")
			ResultPanel:Close()
		end
		
		local wasJumping = false
		hook.Add("Think", "CheckJumpKeyForDebrief", function()
			local ply = LocalPlayer()
			if not IsValid(ply) then return end
			
			if ply:KeyDown(IN_JUMP) then
				if not wasJumping then
					wasJumping = true
					if IsValid(ResultPanel) then
						ResultPanel:Close()
						hook.Remove("Think", "CheckJumpKeyForDebrief")
					end
				end
			else
				wasJumping = false
			end
		end)
    end,
    onCopEscapedDebrief = function(...)

        local w = ScrW()
		local h = ScrH()

        local escapedtable = select( 1, ... )

        --------------------------------------

        local time = UVDisplayTime(UVTimerProgress)
		local deploys = escapedtable["Deploys"]
		local roadblocksdodged = escapedtable["Roadblocks"]
		local spikestripsdodged = escapedtable["Spikestrips"]
		local bounty = UVBounty
		local tags = UVTags
		local wrecks = UVWrecks
		local suspects = UVHUDWantedSuspectsNumber
		
		local ResultPanel = vgui.Create("DFrame")
		local OK = vgui.Create("DButton")
		
		ResultPanel:Add(OK)
		ResultPanel:SetSize(w, h)
		ResultPanel:SetBackgroundBlur(true)
		ResultPanel:ShowCloseButton(false)
		ResultPanel:Center()
		ResultPanel:SetTitle("")
		ResultPanel:SetDraggable(false)
		ResultPanel:MakePopup()
		ResultPanel:SetKeyboardInputEnabled(false)
		
		OK:SetText("X")
		OK:SetSize(w*0.015, h*0.03)
		OK:SetPos(w*0.635, h*0.225)
		
		local timetotal = 30
		local timestart = CurTime()
		
		ResultPanel.Paint = function(self, w, h)
			local timeremaining = math.ceil(timetotal - (CurTime() - timestart))
			local lang = language.GetPhrase

			-- Main black BG
			surface.SetDrawColor( 20, 53, 91, 240 )
			surface.DrawRect( 0, 0, w, h)
			
			-- Upper Results Tab
			surface.SetDrawColor( 0, 0, 0, 235 )
			surface.DrawRect( w*0.33, h*0.215, w*0.33, h*0.06)

			local blend = (math.sin(CurTime() * 6) + 1) / 2
			
			surface.SetMaterial(UVMaterials["ARREST_LIGHT_UC"])
			surface.SetDrawColor( 255 * blend, 0, 255 * (1 - blend), 175 )
			surface.DrawTexturedRect( w*0.33, h*0.215, w*0.33, h*0.06)

			draw.DrawText("#uv.results.lost", "UVUndercoverWhiteFont", w*0.332, h*0.22, Color( 255, 200, 50), TEXT_ALIGN_LEFT )

			-- Busted Tab
			surface.SetMaterial(UVMaterials["ARREST_BG_UC"])
			surface.SetDrawColor( 255, 255, 255 )
			surface.DrawTexturedRect( w*0.25, h*0.2735, w*0.5, h*0.06)

			-- All middle tabs, dark ones
			local numRectsDark = 5
			for i=0, numRectsDark, 1 do
				local yPos = i * h * 0.0675
				surface.SetDrawColor( 50, 50, 50, 150 )
				surface.DrawRect( w*0.33, h*0.275 + yPos, w*0.33, h*0.035)
			end
			
			-- All middle tabs, light ones
			local numRectsLight = 4
			for i=0, numRectsLight, 1 do
				local yPos = i * h * 0.0675
				surface.SetDrawColor( 150, 150, 150, 75 )
				surface.DrawRect( w*0.33, h*0.3075 + yPos, w*0.33, h*0.035)
			end

			local h1, h2 = h*0.34, h*(0.34 + 0.0325)
			
			-- Text
			draw.DrawText( "#uv.results.suspects.escaped.num.carbon", "UVUndercoverAccentFont", w*0.332, h2 - h*0.0675, Color( 255, 255, 255), TEXT_ALIGN_LEFT )
			draw.SimpleText( "#uv.results.chase.bounty", "UVUndercoverAccentFont", w*0.332, h1, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.time", "UVUndercoverAccentFont", w*0.332, h2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.units.deployed", "UVUndercoverAccentFont", w*0.332, h1 + h*0.0675, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.units.damaged", "UVUndercoverAccentFont", w*0.332, h2 + h*0.0675, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.units.destroyed", "UVUndercoverAccentFont", w*0.332, h1 + h*0.135, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.dodged.blocks", "UVUndercoverAccentFont", w*0.332, h2 + h*0.135, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.dodged.spikes", "UVUndercoverAccentFont", w*0.332, h1 + h*0.2025, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

			draw.SimpleText( UVHUDWantedSuspectsNumber, "UVUndercoverAccentFont", w*0.6575, h2 - h*0.0675, Color( 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( "$" .. bounty, "UVUndercoverAccentFont", w*0.6575, h1, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( time, "UVUndercoverAccentFont", w*0.6575, h2, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( deploys, "UVUndercoverAccentFont", w*0.6575, h1 + h*0.0675, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( tags, "UVUndercoverAccentFont", w*0.6575, h2 + h*0.0675, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( wrecks, "UVUndercoverAccentFont", w*0.6575, h1 + h*0.135, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( roadblocksdodged, "UVUndercoverAccentFont", w*0.6575, h2 + h*0.135, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( spikestripsdodged, "UVUndercoverAccentFont", w*0.6575, h1 + h*0.2025, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			
			
			-- Time remaining and closing
			surface.SetDrawColor( 0, 0, 0, 235 )
			surface.DrawRect( w*0.33, h*0.6425, w*0.33, h*0.06)
			
			draw.DrawText( lang("uv.results.continue") .. " [" .. input.LookupBinding("+jump") .. "]", "UVUndercoverAccentFont", w*0.332, h*0.6525, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT )
			draw.DrawText( string.format( language.GetPhrase("uv.results.autoclose"), timeremaining ), "UVUndercoverAccentFont", w*0.6575, h*0.61, Color( 255, 255, 255 ), TEXT_ALIGN_RIGHT )

			if timeremaining < 1 then
				hook.Remove("Think", "CheckJumpKeyForDebrief")
				self:Close()
			end
			
		end
		
		function OK:DoClick() 
			hook.Remove("Think", "CheckJumpKeyForDebrief")
			ResultPanel:Close()
		end
		
		local wasJumping = false
		hook.Add("Think", "CheckJumpKeyForDebrief", function()
			local ply = LocalPlayer()
			if not IsValid(ply) then return end
			
			if ply:KeyDown(IN_JUMP) then
				if not wasJumping then
					wasJumping = true
					if IsValid(ResultPanel) then
						ResultPanel:Close()
						hook.Remove("Think", "CheckJumpKeyForDebrief")
					end
				end
			else
				wasJumping = false
			end
		end)
    end,
    onRacerEscapedDebrief = function(...)
        if UVHUDRace then return end
		
		local w = ScrW()
		local h = ScrH()

        local escapedtable = select( 1, ... )

        --------------------------------------

        local time = UVDisplayTime(UVTimerProgress)
		local deploys = escapedtable["Deploys"]
		local roadblocksdodged = escapedtable["Roadblocks"]
		local spikestripsdodged = escapedtable["Spikestrips"]
		local bounty = UVBounty
		local tags = UVTags
		local wrecks = UVWrecks
		
		local ResultPanel = vgui.Create("DFrame")
		local OK = vgui.Create("DButton")
		
		ResultPanel:Add(OK)
		ResultPanel:SetSize(w, h)
		ResultPanel:SetBackgroundBlur(true)
		ResultPanel:ShowCloseButton(false)
		ResultPanel:Center()
		ResultPanel:SetTitle("")
		ResultPanel:SetDraggable(false)
		ResultPanel:MakePopup()
		ResultPanel:SetKeyboardInputEnabled(false)
		
		OK:SetText("X")
		OK:SetSize(w*0.015, h*0.03)
		OK:SetPos(w*0.635, h*0.225)
		
		local timetotal = 30
		local timestart = CurTime()
		
		ResultPanel.Paint = function(self, w, h)
			local timeremaining = math.ceil(timetotal - (CurTime() - timestart))
			local lang = language.GetPhrase

			-- Main black BG
			surface.SetDrawColor( 20, 53, 91, 240 )
			surface.DrawRect( 0, 0, w, h)
			
			-- Upper Results Tab
			surface.SetDrawColor( 0, 0, 0, 235 )
			surface.DrawRect( w*0.33, h*0.215, w*0.33, h*0.06)

			draw.DrawText("#uv.results.evaded", "UVUndercoverWhiteFont", w*0.332, h*0.22, Color( 255, 200, 50), TEXT_ALIGN_LEFT )

			-- All middle tabs, dark ones
			local numRectsDark = 5
			for i=0, numRectsDark, 1 do
				local yPos = i * h * 0.0675
				surface.SetDrawColor( 50, 50, 50, 150 )
				surface.DrawRect( w*0.33, h*0.275 + yPos, w*0.33, h*0.035)
			end
			
			-- All middle tabs, light ones
			local numRectsLight = 4
			for i=0, numRectsLight, 1 do
				local yPos = i * h * 0.0675
				surface.SetDrawColor( 150, 150, 150, 75 )
				surface.DrawRect( w*0.33, h*0.3075 + yPos, w*0.33, h*0.035)
			end
			
			local h1, h2 = h*0.3825, h*0.4225
			local h1, h2 = h*0.275, h*0.3075
			
			-- Text
			draw.SimpleText( "#uv.results.chase.bounty", "UVUndercoverAccentFont", w*0.332, h1, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.time", "UVUndercoverAccentFont", w*0.332, h2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.units.deployed", "UVUndercoverAccentFont", w*0.332, h1 + h*0.0675, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.units.damaged", "UVUndercoverAccentFont", w*0.332, h2 + h*0.0675, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.units.destroyed", "UVUndercoverAccentFont", w*0.332, h1 + h*0.135, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.dodged.blocks", "UVUndercoverAccentFont", w*0.332, h2 + h*0.135, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.dodged.spikes", "UVUndercoverAccentFont", w*0.332, h1 + h*0.2025, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			
			draw.SimpleText( "$" .. bounty, "UVUndercoverAccentFont", w*0.6575, h1, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( time, "UVUndercoverAccentFont", w*0.6575, h2, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( deploys, "UVUndercoverAccentFont", w*0.6575, h1 + h*0.0675, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( tags, "UVUndercoverAccentFont", w*0.6575, h2 + h*0.0675, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( wrecks, "UVUndercoverAccentFont", w*0.6575, h1 + h*0.135, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( roadblocksdodged, "UVUndercoverAccentFont", w*0.6575, h2 + h*0.135, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( spikestripsdodged, "UVUndercoverAccentFont", w*0.6575, h1 + h*0.2025, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			
			
			-- Time remaining and closing
			surface.SetDrawColor( 0, 0, 0, 235 )
			surface.DrawRect( w*0.33, h*0.6425, w*0.33, h*0.06)
			
			draw.DrawText( lang("uv.results.continue") .. " [" .. input.LookupBinding("+jump") .. "]", "UVUndercoverAccentFont", w*0.332, h*0.6525, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT )
			draw.DrawText( string.format( language.GetPhrase("uv.results.autoclose"), timeremaining ), "UVUndercoverAccentFont", w*0.6575, h*0.61, Color( 255, 255, 255 ), TEXT_ALIGN_RIGHT )
			
			if timeremaining < 1 then
				hook.Remove("Think", "CheckJumpKeyForDebrief")
				self:Close()
			end
			
		end
		
		function OK:DoClick() 
			hook.Remove("Think", "CheckJumpKeyForDebrief")
			ResultPanel:Close()
		end
		
		local wasJumping = false
		hook.Add("Think", "CheckJumpKeyForDebrief", function()
			local ply = LocalPlayer()
			if not IsValid(ply) then return end
			
			if ply:KeyDown(IN_JUMP) then
				if not wasJumping then
					wasJumping = true
					if IsValid(ResultPanel) then
						ResultPanel:Close()
						hook.Remove("Think", "CheckJumpKeyForDebrief")
					end
				end
			else
				wasJumping = false
			end
		end)
    end,
    onRacerBustedDebrief = function(...)
        local w = ScrW()
		local h = ScrH()

        local bustedtable = select( 1, ... )

        --------------------------------------

        local time = UVDisplayTime(UVTimerProgress)
		local unit = bustedtable["Unit"]
		local deploys = bustedtable["Deploys"]
		local roadblocksdodged = bustedtable["Roadblocks"]
		local spikestripsdodged = bustedtable["Spikestrips"]
		local bounty = UVBounty
		local tags = UVTags
		local wrecks = UVWrecks
		
		local ResultPanel = vgui.Create("DFrame")
		local OK = vgui.Create("DButton")
		
		ResultPanel:Add(OK)
		ResultPanel:SetSize(w, h)
		ResultPanel:SetBackgroundBlur(true)
		ResultPanel:ShowCloseButton(false)
		ResultPanel:Center()
		ResultPanel:SetTitle("")
		ResultPanel:SetDraggable(false)
		ResultPanel:MakePopup()
		ResultPanel:SetKeyboardInputEnabled(false)
		
		OK:SetText("X")
		OK:SetSize(w*0.015, h*0.03)
		OK:SetPos(w*0.635, h*0.225)
		
		local timetotal = 30
		local timestart = CurTime()
		
		ResultPanel.Paint = function(self, w, h)
			local timeremaining = math.ceil(timetotal - (CurTime() - timestart))
			local lang = language.GetPhrase

			-- Main black BG
			surface.SetDrawColor( 20, 53, 91, 240 )
			surface.DrawRect( 0, 0, w, h)
			
			-- Upper Results Tab
			surface.SetDrawColor( 0, 0, 0, 235 )
			surface.DrawRect( w*0.33, h*0.215, w*0.33, h*0.06)

			local blend = (math.sin(CurTime() * 6) + 1) / 2
			
			surface.SetMaterial(UVMaterials["ARREST_LIGHT_UC"])
			surface.SetDrawColor( 255 * blend, 0, 255 * (1 - blend), 175 )
			surface.DrawTexturedRect( w*0.33, h*0.215, w*0.33, h*0.06)

			draw.DrawText("#uv.results.busted", "UVUndercoverWhiteFont", w*0.332, h*0.22, Color( 255, 200, 50), TEXT_ALIGN_LEFT )

			-- Busted Tab
			surface.SetMaterial(UVMaterials["ARREST_BG_UC"])
			surface.SetDrawColor( 255, 255, 255 )
			surface.DrawTexturedRect( w*0.25, h*0.2735, w*0.5, h*0.06)

			-- All middle tabs, dark ones
			local numRectsDark = 5
			for i=0, numRectsDark, 1 do
				local yPos = i * h * 0.0675
				surface.SetDrawColor( 50, 50, 50, 150 )
				surface.DrawRect( w*0.33, h*0.275 + yPos, w*0.33, h*0.035)
			end
			
			-- All middle tabs, light ones
			local numRectsLight = 4
			for i=0, numRectsLight, 1 do
				local yPos = i * h * 0.0675
				surface.SetDrawColor( 150, 150, 150, 75 )
				surface.DrawRect( w*0.33, h*0.3075 + yPos, w*0.33, h*0.035)
			end

			local h1, h2 = h*0.34, h*(0.34 + 0.0325)
			
			-- Text
			draw.DrawText( "#uv.results.bustedby.carbon", "UVUndercoverAccentFont", w*0.332, h2 - h*0.0675, Color( 255, 255, 255), TEXT_ALIGN_LEFT )
			draw.SimpleText( "#uv.results.chase.bounty", "UVUndercoverAccentFont", w*0.332, h1, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.time", "UVUndercoverAccentFont", w*0.332, h2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.units.deployed", "UVUndercoverAccentFont", w*0.332, h1 + h*0.0675, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.units.damaged", "UVUndercoverAccentFont", w*0.332, h2 + h*0.0675, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.units.destroyed", "UVUndercoverAccentFont", w*0.332, h1 + h*0.135, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.dodged.blocks", "UVUndercoverAccentFont", w*0.332, h2 + h*0.135, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.dodged.spikes", "UVUndercoverAccentFont", w*0.332, h1 + h*0.2025, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

			draw.SimpleText( unit, "UVUndercoverAccentFont", w*0.6575, h2 - h*0.0675, Color( 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( "$" .. bounty, "UVUndercoverAccentFont", w*0.6575, h1, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( time, "UVUndercoverAccentFont", w*0.6575, h2, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( deploys, "UVUndercoverAccentFont", w*0.6575, h1 + h*0.0675, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( tags, "UVUndercoverAccentFont", w*0.6575, h2 + h*0.0675, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( wrecks, "UVUndercoverAccentFont", w*0.6575, h1 + h*0.135, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( roadblocksdodged, "UVUndercoverAccentFont", w*0.6575, h2 + h*0.135, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( spikestripsdodged, "UVUndercoverAccentFont", w*0.6575, h1 + h*0.2025, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			
			
			-- Time remaining and closing
			surface.SetDrawColor( 0, 0, 0, 235 )
			surface.DrawRect( w*0.33, h*0.6425, w*0.33, h*0.06)
			
			draw.DrawText( lang("uv.results.continue") .. " [" .. input.LookupBinding("+jump") .. "]", "UVUndercoverAccentFont", w*0.332, h*0.6525, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT )
			draw.DrawText( string.format( language.GetPhrase("uv.results.autoclose"), timeremaining ), "UVUndercoverAccentFont", w*0.6575, h*0.61, Color( 255, 255, 255 ), TEXT_ALIGN_RIGHT )
			
			if timeremaining < 1 then
				hook.Remove("Think", "CheckJumpKeyForDebrief")
				self:Close()
			end
			
		end
		
		function OK:DoClick() 
			hook.Remove("Think", "CheckJumpKeyForDebrief")
			ResultPanel:Close()
		end
		
		local wasJumping = false
		hook.Add("Think", "CheckJumpKeyForDebrief", function()
			local ply = LocalPlayer()
			if not IsValid(ply) then return end
			
			if ply:KeyDown(IN_JUMP) then
				if not wasJumping then
					wasJumping = true
					if IsValid(ResultPanel) then
						ResultPanel:Close()
						hook.Remove("Think", "CheckJumpKeyForDebrief")
					end
				end
			else
				wasJumping = false
			end
		end)
    end
}

local function undercover_racing_main( ... )
    local w = ScrW()
    local h = ScrH()
    
    local my_vehicle = select(1, ...)
    local my_array = select(2, ...)
    local string_array = select(3, ...)
    
    local racer_count = #string_array
    local lang = language.GetPhrase
    
    local checkpoint_count = #my_array["Checkpoints"]
    
    ------------------------------------
    
    -- Timer
    --surface.SetMaterial(UVMaterials["ARROW_CARBON"])
    -- surface.SetDrawColor( 89, 255, 255, 200)
    -- surface.DrawTexturedRect( w*0.7175, h*0.1, w*0.03, h*0.05)
    -- surface.SetMaterial(UVMaterials["ARROW_CARBON"])
    -- surface.SetDrawColor(Colors.Carbon_AccentTransparent)
    -- surface.DrawTexturedRect(w * 0.815, h * 0.111, w * 0.025, h * 0.033)
    
    draw.DrawText("#uv.race.hud.time","UVUndercoverAccentFont",w * 0.75,h * 0.123,Colors.Undercover_Accent2,TEXT_ALIGN_LEFT)
    
    draw.DrawText(Carbon_FormatRaceTime((UVHUDRaceInfo.Info.Started and (CurTime() - UVHUDRaceInfo.Info.Time)) or 0),"UVUndercoverWhiteFont",w * 0.75,h * 0.15,Colors.Undercover_Accent1,TEXT_ALIGN_LEFT)
    
    if UVHUDRaceInfo.Info.Laps > 1 then
        -- draw.DrawText("#uv.race.mw.lap", "UVFont5", w * 0.805, h * 0.155, Color(255, 255, 255), TEXT_ALIGN_LEFT) -- Lap Counter
        -- draw.DrawText(
        --     my_array.Lap .. "/" .. UVHUDRaceInfo.Info.Laps,
        --     "UVFont5",
        --     w * 0.97,
        --     h * 0.155,
        --     Color(255, 255, 255),
        --     TEXT_ALIGN_RIGHT
        -- ) -- Lap Counter
        draw.DrawText("#uv.race.hud.lap","UVUndercoverAccentFont",w * 0.94,h * 0.123,Colors.Undercover_Accent2,TEXT_ALIGN_RIGHT)
        draw.DrawText(my_array.Lap .. "/" .. UVHUDRaceInfo.Info.Laps,"UVUndercoverWhiteFont",w * 0.94,h * 0.15,Colors.Undercover_Accent1,TEXT_ALIGN_RIGHT)
    else
        --DrawIcon(UVMaterials["CHECK"], w * 0.815, h * 0.18, .04, Color(255, 255, 255)) -- Icon
        draw.DrawText("#uv.race.hud.complete","UVUndercoverAccentFont",w * 0.94,h * 0.123,Colors.Undercover_Accent2,TEXT_ALIGN_RIGHT)
        draw.DrawText(math.floor(((checkpoint_count / GetGlobalInt("uvrace_checkpoints")) * 100)) .. "%","UVUndercoverWhiteFont",w * 0.94,h * 0.15,Colors.Undercover_Accent1,TEXT_ALIGN_RIGHT)
    end
    
    surface.SetDrawColor(Colors.Undercover_Accent2:Unpack())
    surface.DrawRect(w * 0.75, h * 0.195, w * 0.19, h * 0.005) -- Divider
    
    -- -- Racer List
    local alt = math.floor(CurTime() / 5) % 2 == 1 -- toggles every 5 seconds
    
    local baseY = h * 0.21 -- starting Y position of the list (adjust this freely)
    local spacing = h * 0.035 -- spacing between each racer (vertical gap)
    
    for i = 1, racer_count, 1 do
        if racer_count == 1 then
            return
        end
        local entry = string_array[i]
        
        local racer_name = entry[1]
        local is_local_player = entry[2]
        local mode = entry[3]
        local diff = entry[4]
        
        --local racercount = i * w * 0.02
        local racercount = (i - 1) * spacing
        
        local status_text = "-----"
        
        local Strings = {
            ["Time"] = "%s",
            ["Lap"] = lang("uv.race.suffix.lap"),
            -- ["Laps"] = lang("uv.race.suffix.laps"),
            ["Finished"] = lang("uv.race.suffix.finished"),
            ["Disqualified"] = lang("uv.race.suffix.dnf"),
            ["Busted"] = lang("uv.race.suffix.busted"),
        }
        
        if entry[3] then
            local status_string = Strings[entry[3]]
            
            if status_string then
                local args = {}
                
                if entry[4] then
                    local num = tonumber(entry[4])
                    num =
                    ((num > 0 and "+") or "-") ..
                    string.format((entry[3] == "Lap" and "%s") or "%.2f", math.abs(num))
                    
                    table.insert(args, num)
                end
                
                status_text = #args <= 0 and status_string or string.format(status_string, unpack(args))
            end
        end
        -- local text = alt and (entry[3] .. "  " .. i) or (entry[2] .. "  " .. i)
        local color = nil
        
        if is_local_player then
            color = Colors.Undercover_Accent1
        elseif entry[3] == "Disqualified" or entry[3] == "Busted" then
            color = Colors.Carbon_Disqualified
        else
            color = Colors.Undercover_Accent2
        end
        
        local text = alt and (status_text) or (racer_name)
        text = string.upper(text)
        
        -- This should only draw on LocalPlayer() but couldn't figure it out
        if is_local_player then
            surface.SetDrawColor(Colors.Undercover_Accent2Transparent:Unpack())
            surface.DrawRect(w * 0.75, baseY + racercount, w * 0.19, h * 0.03)
            
            draw.DrawText(text,"UVUndercoverLeaderboardFont",w * 0.76,baseY + racercount,color,TEXT_ALIGN_LEFT)
            
            draw.DrawText(i,"UVUndercoverLeaderboardFont",w * 0.93,baseY + racercount,color,TEXT_ALIGN_RIGHT)
        else
            -- draw.DrawText(
            --     text,
            --     "UVCarbonLeaderboardFont",
            --     w * 0.97,
            --     (h * 0.185) + racercount,
            --     color,
            --     TEXT_ALIGN_RIGHT
            -- )
            draw.DrawText(text,"UVUndercoverLeaderboardFont",w * 0.76,baseY + racercount,color,TEXT_ALIGN_LEFT)
            draw.DrawText(i,"UVUndercoverLeaderboardFont",w * 0.93,baseY + racercount,color,TEXT_ALIGN_RIGHT)
        end
    end
end

local function undercover_pursuit_main( ... )
    local hudyes = GetConVar("cl_drawhud"):GetBool()
    
    if not hudyes then return end
    if not UVHUDDisplayPursuit then return end
    
    local vehicle = LocalPlayer():GetVehicle()
    
    local w = ScrW()
    local h = ScrH()
    local lang = language.GetPhrase
    
    local UnitsChasing = tonumber(UVUnitsChasing)
    local UVBustTimer = BustedTimer:GetFloat()
    
    local states = UV_UI.pursuit.undercover.states
    
    local UVWrecksColor = states.WrecksColor
    local UVTagsColor = states.TagsColor
    local UVUnitsColor = states.UnitsColor
    
    --------------------------------------------------
    
    outofpursuit = CurTime()
    
    local UVHeatBountyMin
    local UVHeatBountyMax
	
    states.EvasionColor = Color(50, 173, 255)
    states.BustedColor = Color(255, 100, 100, 125)
    
    if vehicle == NULL then return end
    
    if UVHUDCopMode and not UVHUDDisplayNotification then
        UVHUDDisplayBusting = false
    end
    
    if UVHUDCopMode and next(UVHUDWantedSuspects) ~= nil then
        local ply = LocalPlayer()
        
        UVClosestSuspect = nil
        UVHUDDisplayBusting = false
        
        local closestDistance = math.huge
        
        for _, suspect in pairs(UVHUDWantedSuspects) do
            if not IsValid(suspect) then continue end
            local dist = ply:GetPos():DistToSqr(suspect:GetPos())
            
            if (#UVHUDWantedSuspects == 1 or dist < 250000) and dist < closestDistance then
                closestDistance = dist
                UVClosestSuspect = suspect
            end
        end
        
        if UVClosestSuspect then
            if UVClosestSuspect.beingbusted then
                UVHUDDisplayBusting = true
                UVBustingProgress = UVClosestSuspect.uvbustingprogress
                
                local blink = 255 * math.abs(math.sin(RealTime() * 8))
                states.BustedColor = Color(255, 100, 100, blink)
            end
        end
    end
    
    if not UVHUDRace then
        local ResourceText = UVResourcePoints
        
        -- [[ Commander Stuff ]]
        if UVOneCommanderActive then
            if not UVHUDCommanderLastHealth or not UVHUDCommanderLastMaxHealth then
                UVHUDCommanderLastHealth = 0
                UVHUDCommanderLastMaxHealth = 0
            end
            if IsValid(UVHUDCommander) then
                if UVHUDCommander.IsSimfphyscar then
                    UVHUDCommanderLastHealth = UVHUDCommander:GetCurHealth()
                    UVHUDCommanderLastMaxHealth =
                    UVUOneCommanderHealth:GetInt() - (UVHUDCommander:GetMaxHealth() * 0.3)
                elseif UVHUDCommander.IsGlideVehicle then
                    local enginehealth = UVHUDCommander:GetEngineHealth()
                    UVHUDCommanderLastHealth = UVHUDCommander:GetChassisHealth() * enginehealth
                    UVHUDCommanderLastMaxHealth = UVUOneCommanderHealth:GetInt()
                elseif vcmod_main then
                    UVHUDCommanderLastHealth =
                    UVUOneCommanderHealth:GetInt() * (UVHUDCommander:VC_getHealth() / 100) --vcmod returns % health clientside
                    UVHUDCommanderLastMaxHealth = UVUOneCommanderHealth:GetInt()
                else
                    UVHUDCommanderLastHealth = UVHUDCommander:Health()
                    UVHUDCommanderLastMaxHealth = UVUOneCommanderHealth:GetInt()
                end
            end
            local healthratio = UVHUDCommanderLastHealth / UVHUDCommanderLastMaxHealth
            local healthcolor
            if healthratio >= 0.5 then
                healthcolor = Color(255, 255, 255, 200)
            elseif healthratio >= 0.25 then
                if math.floor(RealTime() * 2) == math.Round(RealTime() * 2) then
                    healthcolor = Color(255, 0, 0)
                else
                    healthcolor = Color(255, 255, 255)
                end
            else
                if math.floor(RealTime() * 4) == math.Round(RealTime() * 4) then
                    healthcolor = Color(255, 0, 0)
                else
                    healthcolor = Color(255, 255, 255)
                end
            end
            ResourceText = "⛊"
            local element3 = {
                {x = w / 3, y = 0},
                {x = w / 3 + 12 + w / 3, y = 0},
                {x = w / 3 + 12 + w / 3 - 25, y = h / 20},
                {x = w / 3 + 25, y = h / 20}
            }
            surface.SetDrawColor(0, 0, 0, 200)
            draw.NoTexture()
            surface.DrawPoly(element3)
            if healthratio > 0 then
                surface.SetDrawColor(Color(109, 109, 109, 200))
                surface.DrawRect(w / 3 + 25, h / 20, w / 3 - 38, 8)
                surface.SetDrawColor(healthcolor)
                local T = math.Clamp((healthratio) * (w / 3 - 38), 0, w / 3 - 38)
                surface.DrawRect(w / 3 + 25, h / 20, T, 8)
            end
            draw.DrawText("⛊ " .. lang("uv.unit.commander") .. " ⛊","UVFont5UI-BottomBar",w / 2,0,Color(0, 161, 255),TEXT_ALIGN_CENTER)
        end
        
        -- [ Upper Right Info Box ] --
		-- Divider
		surface.SetDrawColor(Colors.Undercover_Accent2:Unpack())
		surface.DrawRect(w * 0.75, h * 0.195, w * 0.19, h * 0.005)
    
        -- Timer
		draw.DrawText("#uv.race.hud.time","UVUndercoverAccentFont",w * 0.75,h * 0.123,Colors.Undercover_Accent2,TEXT_ALIGN_LEFT)
		draw.DrawText(UVTimer,"UVUndercoverWhiteFont",w * 0.75,h * 0.15,Colors.Undercover_Accent1,TEXT_ALIGN_LEFT)
    
        -- Bounty
        DrawIcon(UVMaterials["CTS_UC"], w * 0.76, h * 0.235, .06, Colors.Undercover_Accent1) -- Icon
        draw.DrawText(UVBounty, "UVFont5", w * 0.775, h * 0.21, Color(255, 255, 255), TEXT_ALIGN_LEFT) -- Bounty Counter

		-- General Icons
		DrawIcon(UVMaterials["UNITS"], w * 0.76, h * 0.355, .06, Colors.Undercover_Accent1)
		draw.DrawText(ResourceText,"UVFont5WeightShadow",w * 0.78,h * 0.335,Colors.Undercover_Accent1,TEXT_ALIGN_LEFT)
		
		if UVHUDDisplayBackupTimer then
            if not UVBackupColor then
                UVBackupColor = Color(255, 255, 255)
            end
			if num then
				if num < 10 and _last_backup_pulse_second ~= math.floor(num) then
					_last_backup_pulse_second = math.floor(num)

					hook.Remove("Think", "UVBackupColorPulse")
					UVBackupColor = Color(255, 255, 0)

					hook.Add("Think","UVBackupColorPulse",function()
						UVBackupColor.b = UVBackupColor.b + 600 * RealFrameTime()
						if UVBackupColor.b >= 255 then
							hook.Remove("Think", "UVBackupColorPulse")
						end
					end)
				end
			end
			draw.DrawText("        (" .. UVBackupTimer .. ")","UVFont5WeightShadow",w * 0.78,h * 0.335,UVBackupColor,TEXT_ALIGN_LEFT)
		end

		DrawIcon(UVMaterials["UNITS_DAMAGED"], w * 0.76, h * 0.415, .07, Colors.Undercover_Accent1)
		draw.DrawText(UVTags, "UVFont5WeightShadow", w * 0.78, h * 0.395, Colors.Undercover_Accent1, TEXT_ALIGN_LEFT)
		
		DrawIcon(UVMaterials["UNITS_DISABLED_UC"], w * 0.76, h * 0.475, .07, Colors.Undercover_Accent1)
		draw.DrawText( UVWrecks, "UVFont5WeightShadow", w * 0.78, h * 0.455, Colors.Undercover_Accent1, TEXT_ALIGN_LEFT)
		
        -- Heat Level
        DrawIcon(UVMaterials["HEAT"], w * 0.76, h * 0.295, .06, Colors.Undercover_Accent1) -- Icon
        draw.DrawText("x" .. UVHeatLevel, "UVUndercoverWhiteFont", w * 0.775, h * 0.275, Colors.Undercover_Accent1, TEXT_ALIGN_LEFT)

        if UVHeatLevel == 1 then
            UVHeatBountyMin = UVUHeatMinimumBounty1:GetInt()
            UVHeatBountyMax = UVUHeatMinimumBounty2:GetInt()
        elseif UVHeatLevel == 2 then
            UVHeatBountyMin = UVUHeatMinimumBounty2:GetInt()
            UVHeatBountyMax = UVUHeatMinimumBounty3:GetInt()
        elseif UVHeatLevel == 3 then
            UVHeatBountyMin = UVUHeatMinimumBounty3:GetInt()
            UVHeatBountyMax = UVUHeatMinimumBounty4:GetInt()
        elseif UVHeatLevel == 4 then
            UVHeatBountyMin = UVUHeatMinimumBounty4:GetInt()
            UVHeatBountyMax = UVUHeatMinimumBounty5:GetInt()
        elseif UVHeatLevel == 5 then
            UVHeatBountyMin = UVUHeatMinimumBounty5:GetInt()
            UVHeatBountyMax = UVUHeatMinimumBounty6:GetInt()
        elseif UVHeatLevel == 6 then
            UVHeatBountyMin = UVUHeatMinimumBounty6:GetInt()
            UVHeatBountyMax = math.huge
        end

        surface.SetDrawColor(Color(109, 109, 109, 200))
        surface.DrawRect(w * 0.805, h * 0.2815, w * 0.1375, h * 0.035)
        surface.SetDrawColor(Color(255, 255, 255))
        local HeatProgress = 0
        if MaxHeatLevel:GetInt() ~= UVHeatLevel then
            if UVUTimeTillNextHeatEnabled:GetInt() == 1 and UVTimeTillNextHeat then --Time till next heat level
                if UVHeatLevel == 1 then
                    local maxtime = UVUTimeTillNextHeat1:GetInt()
                    HeatProgress = (maxtime - UVTimeTillNextHeat) / maxtime
                elseif UVHeatLevel == 2 then
                    local maxtime = UVUTimeTillNextHeat2:GetInt()
                    HeatProgress = (maxtime - UVTimeTillNextHeat) / maxtime
                elseif UVHeatLevel == 3 then
                    local maxtime = UVUTimeTillNextHeat3:GetInt()
                    HeatProgress = (maxtime - UVTimeTillNextHeat) / maxtime
                elseif UVHeatLevel == 4 then
                    local maxtime = UVUTimeTillNextHeat4:GetInt()
                    HeatProgress = (maxtime - UVTimeTillNextHeat) / maxtime
                elseif UVHeatLevel == 5 then
                    local maxtime = UVUTimeTillNextHeat5:GetInt()
                    HeatProgress = (maxtime - UVTimeTillNextHeat) / maxtime
                elseif UVHeatLevel == 6 then
                    HeatProgress = 0
                end
            else
                HeatProgress = ((UVBountyNo - UVHeatBountyMin) / (UVHeatBountyMax - UVHeatBountyMin))
            end
        end
        local B = math.Clamp((HeatProgress) * w * 0.1375, 0, w * 0.1375)
        local blink = 255 * math.abs(math.sin(RealTime() * 4))
        local blink2 = 255 * math.abs(math.sin(RealTime() * 6))
        local blink3 = 255 * math.abs(math.sin(RealTime() * 8))
        
        if HeatProgress >= 0.6 and HeatProgress < 0.75 then
            surface.SetDrawColor(Color(255, blink, blink))
        elseif HeatProgress >= 0.75 and HeatProgress < 0.9 then
            surface.SetDrawColor(Color(255, blink2, blink2))
        elseif HeatProgress >= 0.9 and HeatProgress < 1 then
            surface.SetDrawColor(Color(255, blink3, blink3))
        elseif HeatProgress >= 1 then
            surface.SetDrawColor(Color(255, 0, 0))
        end
        
        surface.DrawRect(w * 0.805, h * 0.2815, B, h * 0.035)
        
        -- [ Bottom Info Box ] --
        local bottomy = h * 0.86
        local bottomy2 = h * 0.9
        local bottomy3 = h * 0.91
        local bottomy4 = h * 0.81
        local bottomy5 = h * 0.83
        local bottomy6 = h * 0.79
        
        if not UVHUDDisplayCooldown then
            -- Evade Box, All BG
            -- surface.SetDrawColor(255,255,255,25)
            -- surface.DrawRect(w * 0.331, bottomy - 4, w * 0.344, h * 0.041)
            
			draw.NoTexture()
            surface.SetDrawColor(200, 200, 200, 255)
            surface.DrawRect(w * 0.333, bottomy - (h*0.004), w * 0.34, h * 0.004)
            surface.DrawRect(w * 0.333, bottomy + (h*0.034), w * 0.34, h * 0.004)
            surface.DrawTexturedRectRotated(w * 0.333, bottomy + (h*0.017), w * 0.0235, h * 0.004, 90)
            surface.DrawTexturedRectRotated(w * 0.6735, bottomy + (h*0.017), w * 0.0235, h * 0.004, 90)

            surface.SetDrawColor(100, 100, 100, 230)
            surface.DrawRect(w * 0.333  , bottomy, w * 0.34, h * 0.035)
            
            -- Evade Box, Evade BG
			surface.SetMaterial(UVMaterials["BACKGROUND_CARBON_FILLED"])
            surface.SetDrawColor(50, 214, 255, 100)
            surface.DrawTexturedRect(w * 0.5, bottomy, w * 0.1725, h * 0.035)
            
            -- Evade Box, Busted BG
			surface.SetMaterial(UVMaterials["BACKGROUND_CARBON_FILLED_INVERTED"])
            surface.SetDrawColor(255, 0, 0, 100)
            surface.DrawTexturedRect(w * 0.333, bottomy, w * 0.1725, h * 0.035)
            
            -- surface.SetDrawColor(200, 200, 200, 100)
            -- surface.DrawRect(w * 0.333, bottomy, w * 0.34, h * 0.035)
            
            -- Evade Box, Busted Meter
            if UVHUDDisplayBusting and not UVHUDDisplayCooldown then
                if not BustingProgress or BustingProgress == 0 then
                    BustingProgress = CurTime()
                end
                
                local blink = 255 * math.abs(math.sin(RealTime() * 4))
                local blink2 = 255 * math.abs(math.sin(RealTime() * 6))
                local blink3 = 255 * math.abs(math.sin(RealTime() * 8))
                
                local timeLeft = ((UVHUDDisplayNotification and -1) or (UVBustTimer - UVBustingProgress))
                
                local playbusting = (UVHUDCopMode and UVHUDWantedSuspectsNumber == 1) or not UVHUDCopMode
                
                if timeLeft >= UVBustTimer * 0.5 then
                    states.BustedColor = Color(255, 100, 100, blink)
                    -- UVSoundBusting()
                elseif timeLeft >= UVBustTimer * 0.2 then
                    states.BustedColor = Color(255, 100, 100, blink2)
                    if playbusting then
                        UVSoundBusting()
                    end
                elseif timeLeft >= 0 then
                    states.BustedColor = Color(255, 100, 100, blink3)
                    if playbusting then
                        UVSoundBusting()
                    end
                else
                    states.BustedColor = Color(255, 100, 100)
                end
                
                local T = math.Clamp((UVBustingProgress / UVBustTimer) * (w * 0.1675), 0, w * 0.1675)
				T = math.floor(T)
                surface.SetDrawColor(255, 0, 0)
                surface.DrawRect(w * 0.333 + (w * 0.1675 - T), bottomy, T, h * 0.035)
            else
                UVBustedColor = Color(255, 100, 100, 125)
                BustingProgress = 0
            end
            
            -- Evade Box, Evade Meter
            if not UVHUDDisplayNotification and not UVHUDDisplayCooldown and UnitsChasing == 0 then
                --UVSoundHeat(UVHeatLevel)
                if not EvadingProgress or EvadingProgress == 0 then
                    EvadingProgress = CurTime()
                    UVEvadingProgress = EvadingProgress
                end
                
                local T = math.Clamp((UVEvadingProgress) * (w * 0.1725), 0, w * 0.1725)
                surface.SetDrawColor(50, 173, 255)
                surface.DrawRect(w * 0.5, bottomy, T, h * 0.035)
                states.EvasionColor = Color(50, 173, 255, blink)
            else
                EvadingProgress = 0
            end

            -- Evade Box, Icons
			DrawIcon(UVMaterials["BUSTED_ICON_UC_GLOW"], w * 0.315, bottomy + (h*0.015), .05, states.BustedColor) -- Icon, Glow
			DrawIcon(UVMaterials["BUSTED_ICON_UC"], w * 0.315, bottomy + (h*0.015), .05, Color(255,0,0, 125)) -- Icon
			DrawIcon(UVMaterials["EVADE_ICON_UC_GLOW"], w * 0.6925, bottomy + (h*0.015), .05, states.EvasionColor) -- Icon, Glow
			DrawIcon(UVMaterials["EVADE_ICON_UC"], w * 0.6925, bottomy + (h*0.015), .05, Color(50, 173, 255, 125)) -- Icon

            -- Evade Box, Dividers
            surface.SetDrawColor(255, 255, 255, 255)
            surface.DrawRect(w * 0.499, bottomy, w * 0.0015, h * 0.035)

            -- Lower Box
            -- local shade_theme_color =
            -- (UVHUDCopMode and table.Copy(Colors.MW_CopShade)) or table.Copy(Colors.MW_RacerShade)
            -- local theme_color =
            -- (UVHUDCopMode and table.Copy(Colors.MW_Cop)) or table.Copy(Colors.MW_Racer)
            
            -- shade_theme_color.a = shade_theme_color.a - 35
            -- theme_color.a = theme_color.a - 35
            
            -- surface.SetDrawColor(shade_theme_color:Unpack())
            -- surface.DrawRect(w * 0.333, bottomy3, w * 0.34, h * 0.05)
            
            -- surface.SetDrawColor(theme_color:Unpack())
            -- surface.SetMaterial(UVMaterials["BACKGROUND"])
            -- surface.DrawTexturedRect(w * 0.333, bottomy3, w * 0.34, h * 0.05)
            
            -- surface.SetDrawColor( 0, 0, 0, 200)
            -- surface.DrawRect( w*0.333, bottomy3, w*0.34, h*0.05)
            
            -- local lbtext = "REPLACEME"
            -- local uloc, utype = "uv.chase.unit", UnitsChasing
            -- if not UVHUDCopMode then
                -- if UnitsChasing ~= 1 then
                    -- uloc = "uv.chase.units"
                -- end
            -- else
                -- utype = UVHUDWantedSuspectsNumber
                -- uloc = "uv.chase.suspects"
            -- end

            -- if not UVBackupColor then
                -- UVBackupColor = Color(255, 255, 255)
            -- end
            -- local num = UVBackupTimerSeconds
            
            -- if not UVHUDDisplayBackupTimer then
                -- lbtext = string.format(lang(uloc), utype)
            -- else
                -- if num then
                    -- if num < 10 and _last_backup_pulse_second ~= math.floor(num) then
                        -- _last_backup_pulse_second = math.floor(num)
                        
                        -- hook.Remove("Think", "UVBackupColorPulse")
                        -- UVBackupColor = Color(255, 255, 0)
                        
                        -- hook.Add("Think","UVBackupColorPulse",function()
                            -- UVBackupColor.b = UVBackupColor.b + 600 * RealFrameTime()
                            -- if UVBackupColor.b >= 255 then
                                -- hook.Remove("Think", "UVBackupColorPulse")
                            -- end
                        -- end)
                    -- end
                -- end
                
                -- lbtext = string.format(lang("uv.chase.backupin"), UVBackupTimer)
            -- end
            
            -- draw.DrawText(lbtext,"UVFont5UI-BottomBar",w * 0.5,bottomy3 * 1.001,UVBackupColor,TEXT_ALIGN_CENTER)
        else
            -- Lower Box
            -- Evade Box, Cooldown Meter
            if UVHUDDisplayCooldown then
				
                local blink = 255 * math.abs(math.sin(RealTime() * 4))
                local blink2 = 255 * math.abs(math.sin(RealTime() * 6))
                local blink3 = 255 * math.abs(math.sin(RealTime() * 8))
                
                if not CooldownProgress or CooldownProgress == 0 then
                    CooldownProgress = CurTime()
                end
                
                UVSoundCooldown()
                EvadingProgress = 0
                
                -- Upper Box
                if not UVHUDCopMode then
                    -- if UVHUDDisplayHidingPrompt then
                        -- surface.SetMaterial(Material("unitvehicles/hud/bg_anim"))
                        -- surface.SetDrawColor(0, 175, 0, 200)
                        -- surface.DrawTexturedRect(w * 0.333, bottomy, w * 0.34, h * 0.05)
                        
                        -- local blink = 255 * math.Clamp(math.abs(math.sin(RealTime() * 2)), .7, 1)
                        -- color = Color(blink, 255, blink)
                        
                        -- surface.SetDrawColor(130, 199, 74, 124)
                        -- surface.DrawRect(w * 0.333, bottomy, w * 0.34, h * 0.05)
                        -- draw.DrawText(
                        -- "#uv.chase.hiding",
                        -- "UVFont5UI-BottomBar",
                        -- w * 0.5,
                        -- bottomy,
                        -- color,
                        -- TEXT_ALIGN_CENTER)
                    -- end
                    
					DrawIcon(UVMaterials["EVADE_ICON_UC_GLOW"], w * 0.6925, bottomy + (h*0.015), .05, Color(50, 214, 255, blink2)) -- Icon, Glow
					DrawIcon(UVMaterials["EVADE_ICON_UC"], w * 0.6925, bottomy + (h*0.015), .05, Color(50, 214, 255, 125)) -- Icon
					
					-- surface.SetMaterial(UVMaterials["BACKGROUND_CARBON_SOLID"])
                    surface.SetDrawColor(200, 200, 200, 125)
                    surface.DrawRect(w * 0.333, bottomy, w * 0.344, h * 0.03)
                    
                    local T = math.Clamp((UVCooldownTimer) * (w * 0.344), 0, w * 0.344)
                    surface.SetDrawColor(50, 173, 255, 255)
					
                    surface.DrawRect(w * 0.333, bottomy, T, h * 0.03)
                    
                    -- surface.SetDrawColor(0, 0, 0, 200)
                    -- surface.DrawRect(w * 0.331, bottomy - 4, w * 0.344, h * 0.041)
                    -- surface.DrawRect(w * 0.333, bottomy3, w * 0.34, h * 0.05)
                    -- draw.DrawText("#uv.chase.cooldown","UVFont5UI-BottomBar",w * 0.5,bottomy3,Color(255, 255, 255),TEXT_ALIGN_CENTER)
                else
                    local shade_theme_color = (UVHUDCopMode and table.Copy(Colors.MW_CopShade)) or table.Copy(Colors.MW_RacerShade)
                    local theme_color = (UVHUDCopMode and table.Copy(Colors.MW_Cop)) or table.Copy(Colors.MW_Racer)
                    
                    -- surface.SetDrawColor( shade_theme_color:Unpack() )
                    -- surface.DrawRect( w*0.333, bottomy2, w*0.34, h*0.01)
                    
                    shade_theme_color.a = shade_theme_color.a - 35
                    theme_color.a = theme_color.a - 35
                    
                    local blink = 255 * math.Clamp(math.abs(math.sin(RealTime())), .7, 1)
                    color = Color(blink, blink, 255)
                    
                    surface.SetDrawColor(shade_theme_color:Unpack())
                    surface.DrawRect(w * 0.333, bottomy3, w * 0.34, h * 0.05)
                    
                    surface.SetDrawColor(theme_color:Unpack())
                    
                    surface.SetMaterial(UVMaterials["BACKGROUND"])
                    surface.DrawTexturedRect(w * 0.333, bottomy3, w * 0.34, h * 0.05)
                    
                    local text = lang("uv.chase.cooldown")
                    draw.DrawText(text, "UVFont5UI-BottomBar", w / 2, bottomy3, color, TEXT_ALIGN_CENTER)
                end
            else
                CooldownProgress = 0
            end
        end
    end
end

UV_UI.pursuit.undercover.main = undercover_pursuit_main
UV_UI.racing.undercover.main = undercover_racing_main

-- OG

-- Functions

UV_UI.racing.original = {}
UV_UI.pursuit.original = {}

UV_UI.pursuit.original.states = {
    TagsColor = Color(255,255,255,150),
    WrecksColor = Color(255,255,255,150),
    UnitsColor = Color(255,255,255,150),
    BustedColor = Color(255, 255, 255, 50),
    EvasionColor = Color(255, 255, 255, 50),
}

UV_UI.racing.original.events = {
    onRaceEnd = function(...)
        print( 'onRaceEnd', ... )
    end
}

UV_UI.pursuit.original.events = {
    -- _onUpdate = function( data_name, ...)
    --     if data_name == 'Wrecks' then
    --         UV_UI.pursuit.mostwanted.callbacks.onUnitWreck( ... )
    --     elseif data_name == 'Tags' then
    --         UV_UI.pursuit.mostwanted.callbacks.onUnitTag( ... )
    --     elseif data_name == 'ChasingUnits' then
    --         UV_UI.pursuit.mostwanted.callbacks.onChasingUnitsChange( ... )
    --     end
    -- end,
    onUnitWreck = function(...)
        
        hook.Remove("Think", "MW_WRECKS_COLOR_PULSE")
        
        if timer.Exists("MW_WRECKS_COLOR_PULSE_DELAY") then timer.Remove("MW_WRECKS_COLOR_PULSE_DELAY") end
        UV_UI.pursuit.mostwanted.states.WrecksColor = Color(255,255,0, 150)
        
        timer.Create("MW_WRECKS_COLOR_PULSE_DELAY", 1, 1, function()
            hook.Add("Think", "MW_WRECKS_COLOR_PULSE", function()
                UV_UI.pursuit.mostwanted.states.WrecksColor.b = UV_UI.pursuit.mostwanted.states.WrecksColor.b + 600 * RealFrameTime()
                if UV_UI.pursuit.mostwanted.states.WrecksColor.b >= 255 then hook.Remove("Think", "MW_WRECKS_COLOR_PULSE") end
            end)
        end)
        
    end,
    onUnitTag = function(...)
        
        hook.Remove("Think", "MW_TAGS_COLOR_PULSE")
        if timer.Exists("MW_TAGS_COLOR_PULSE_DELAY") then timer.Remove("MW_TAGS_COLOR_PULSE_DELAY") end
        
        UV_UI.pursuit.mostwanted.states.TagsColor = Color(255,255,0, 150)
        
        timer.Create("MW_TAGS_COLOR_PULSE_DELAY", 1, 1, function()
            
            hook.Add("Think", "MW_TAGS_COLOR_PULSE", function()
                UV_UI.pursuit.mostwanted.states.TagsColor.b = UV_UI.pursuit.mostwanted.states.TagsColor.b + 600 * RealFrameTime()
                if UV_UI.pursuit.mostwanted.states.TagsColor.b >= 255 then hook.Remove("Think", "MW_TAGS_COLOR_PULSE") end
            end)
            
        end)
        
    end,
    onResourceChange = function(...)
        
        local new_data = select( 1, ... )
        local old_data = select( 2, ... )
        
        hook.Remove("Think", "MW_RP_COLOR_PULSE")
        UV_UI.pursuit.mostwanted.states.UnitsColor = (new_data < (old_data or 0) and Color(255,50,50, 150)) or Color(50,255,50, 150)
        --UVResourcePointsColor = (rp_num < UVResourcePoints and Color(255,50,50)) or Color(50,255,50)
        
        local clrs = {}
        
        for _, v in pairs( { 'r', 'g', 'b' } ) do
            if UV_UI.pursuit.mostwanted.states.UnitsColor[v] ~= 255 then table.insert(clrs, v) end
        end 
        
        -- if timer.Exists("UVWrecksColor") then
        -- 	timer.Remove("UVWrecksColor")
        -- end
        local val = 50
        
        hook.Add("Think", "MW_RP_COLOR_PULSE", function()
            val = val + 200 * RealFrameTime()
            -- UVResourcePointsColor.b = val
            -- UVResourcePointsColor.g = val
            for _, v in pairs( clrs ) do
                UV_UI.pursuit.mostwanted.states.UnitsColor[v] = val
            end
            
            if val >= 255 then hook.Remove("Think", "MW_RP_COLOR_PULSE") end
        end)
        
    end,
    onChasingUnitsChange = function(...)
        
    end,
    onHeatLevelUpdate = function(...)
        
    end,
    onCopBustedDebrief = function(...)
        local w = ScrW()
		local h = ScrH()

        local bustedtable = select( 1, ... )

        --------------------------------------

        local time = UVDisplayTime(UVTimerProgress)
		local deploys = bustedtable["Deploys"]
		local roadblocksdodged = bustedtable["Roadblocks"]
		local spikestripsdodged = bustedtable["Spikestrips"]
		local bounty = UVBounty
		local tags = UVTags
		local wrecks = UVWrecks
		local suspects = UVHUDWantedSuspectsNumber
		
		local ResultPanel = vgui.Create("DFrame")
		local OK = vgui.Create("DButton")
		
		ResultPanel:Add(OK)
		ResultPanel:SetSize(math.Round(w*0.5208333333), math.Round(h*0.5555555556))
		ResultPanel:SetBackgroundBlur(true)
		ResultPanel:ShowCloseButton(false)
		ResultPanel:Center()
		ResultPanel:SetTitle("")
		ResultPanel:SetDraggable(false)
		ResultPanel:MakePopup()
		ResultPanel:SetKeyboardInputEnabled(false)
		
		OK:SetText("#addons.confirm")
		OK:SetSize(ResultPanel:GetWide() * 5 / 16, 22)
		OK:Dock(BOTTOM)
		
		local timetotal = 30
		local timestart = CurTime()
		
		ResultPanel.Paint = function(self, w, h)
			local timeremaining = math.ceil(timetotal - (CurTime() - timestart))
			local lang = language.GetPhrase

			draw.RoundedBox(2, 0, 0, w, h, Color(0,0,0,225))
			draw.SimpleText("/// " .. lang("uv.chase.busted") .. " ///", "UVFont", w*0.5, h*0.01, Color(0, 255, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText(string.format( lang("uv.results.suspects.busted"), unit ), "UVFont5", w*0.5, h*0.075, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.bounty", "UVFont5", w*0.01, h*0.15, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.time", "UVFont5", w*0.01, h*0.25, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.units.deployed", "UVFont5", w*0.01, h*0.35, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.units.damaged", "UVFont5", w*0.01, h*0.45, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.units.destroyed", "UVFont5", w*0.01, h*0.55, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.dodged.blocks", "UVFont5", w*0.01, h*0.65, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.dodged.spikes", "UVFont5", w*0.01, h*0.75, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			
			draw.SimpleText( bounty, "UVFont5", w*0.99, h*0.15, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( time, "UVFont5", w*0.99, h*0.25, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( deploys, "UVFont5", w*0.99, h*0.35, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( tags, "UVFont5", w*0.99, h*0.45, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( wrecks, "UVFont5", w*0.99, h*0.55, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( roadblocksdodged, "UVFont5", w*0.99, h*0.65, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( spikestripsdodged, "UVFont5", w*0.99, h*0.75, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			
			-- Time remaining and closing
			draw.DrawText( "[ " .. input.LookupBinding("+jump") .. " ] " .. lang("uv.results.continue"), "UVFont5", w*0.01, h*0.85, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT )
			
			draw.DrawText( string.format( language.GetPhrase("uv.results.autoclose"), timeremaining ), "UVFont5", w*0.99, h*0.85, Color( 255, 255, 255 ), TEXT_ALIGN_RIGHT )
			if timeremaining < 1 then
				hook.Remove("Think", "CheckJumpKeyForDebrief")
				self:Close()
			end
			
		end
		
		function OK:DoClick() 
			hook.Remove("Think", "CheckJumpKeyForDebrief")
			ResultPanel:Close()
		end
		
		local wasJumping = false
		hook.Add("Think", "CheckJumpKeyForDebrief", function()
			local ply = LocalPlayer()
			if not IsValid(ply) then return end
			
			if ply:KeyDown(IN_JUMP) then
				if not wasJumping then
					wasJumping = true
					if IsValid(ResultPanel) then
						ResultPanel:Close()
						hook.Remove("Think", "CheckJumpKeyForDebrief")
					end
				end
			else
				wasJumping = false
			end
		end)
    end,
    onCopEscapedDebrief = function(...)

        local w = ScrW()
		local h = ScrH()

        local escapedtable = select( 1, ... )

        --------------------------------------

        local time = UVDisplayTime(UVTimerProgress)
		local deploys = escapedtable["Deploys"]
		local roadblocksdodged = escapedtable["Roadblocks"]
		local spikestripsdodged = escapedtable["Spikestrips"]
		local bounty = UVBounty
		local tags = UVTags
		local wrecks = UVWrecks
		local suspects = UVHUDWantedSuspectsNumber
		
		local ResultPanel = vgui.Create("DFrame")
		local OK = vgui.Create("DButton")
		
		ResultPanel:Add(OK)
		ResultPanel:SetSize(math.Round(w*0.5208333333), math.Round(h*0.5555555556))
		ResultPanel:SetBackgroundBlur(true)
		ResultPanel:ShowCloseButton(false)
		ResultPanel:Center()
		ResultPanel:SetTitle("")
		ResultPanel:SetDraggable(false)
		ResultPanel:MakePopup()
		ResultPanel:SetKeyboardInputEnabled(false)
		
		OK:SetText("#addons.confirm")
		OK:SetSize(ResultPanel:GetWide() * 5 / 16, 22)
		OK:Dock(BOTTOM)
		
		local timetotal = 30
		local timestart = CurTime()
		
		ResultPanel.Paint = function(self, w, h)
			local timeremaining = math.ceil(timetotal - (CurTime() - timestart))
			local lang = language.GetPhrase

			draw.RoundedBox(2, 0, 0, w, h, Color(0,0,0,225))
			draw.SimpleText("--- " .. lang("uv.chase.evade") .. " ---", "UVFont", w*0.5, h*0.01, Color(255, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText( string.format( lang("uv.results.suspects.escaped.num"), UVHUDWantedSuspectsNumber), "UVFont5", w*0.5, h*0.075, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.bounty", "UVFont5", w*0.01, h*0.15, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.time", "UVFont5", w*0.01, h*0.25, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.units.deployed", "UVFont5", w*0.01, h*0.35, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.units.damaged", "UVFont5", w*0.01, h*0.45, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.units.destroyed", "UVFont5", w*0.01, h*0.55, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.dodged.blocks", "UVFont5", w*0.01, h*0.65, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.dodged.spikes", "UVFont5", w*0.01, h*0.75, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			
			draw.SimpleText( bounty, "UVFont5", w*0.99, h*0.15, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( time, "UVFont5", w*0.99, h*0.25, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( deploys, "UVFont5", w*0.99, h*0.35, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( tags, "UVFont5", w*0.99, h*0.45, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( wrecks, "UVFont5", w*0.99, h*0.55, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( roadblocksdodged, "UVFont5", w*0.99, h*0.65, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( spikestripsdodged, "UVFont5", w*0.99, h*0.75, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			
			-- Time remaining and closing
			draw.DrawText( "[ " .. input.LookupBinding("+jump") .. " ] " .. lang("uv.results.continue"), "UVFont5", w*0.01, h*0.85, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT )
			
			draw.DrawText( string.format( language.GetPhrase("uv.results.autoclose"), timeremaining ), "UVFont5", w*0.99, h*0.85, Color( 255, 255, 255 ), TEXT_ALIGN_RIGHT )
			if timeremaining < 1 then
				hook.Remove("Think", "CheckJumpKeyForDebrief")
				self:Close()
			end
			
		end
		
		function OK:DoClick() 
			hook.Remove("Think", "CheckJumpKeyForDebrief")
			ResultPanel:Close()
		end
		
		local wasJumping = false
		hook.Add("Think", "CheckJumpKeyForDebrief", function()
			local ply = LocalPlayer()
			if not IsValid(ply) then return end
			
			if ply:KeyDown(IN_JUMP) then
				if not wasJumping then
					wasJumping = true
					if IsValid(ResultPanel) then
						ResultPanel:Close()
						hook.Remove("Think", "CheckJumpKeyForDebrief")
					end
				end
			else
				wasJumping = false
			end
		end)
    end,
    onRacerEscapedDebrief = function(...)
        if UVHUDRace then return end
		
		local w = ScrW()
		local h = ScrH()

        local escapedtable = select( 1, ... )

        --------------------------------------

        local time = UVDisplayTime(UVTimerProgress)
		local deploys = escapedtable["Deploys"]
		local roadblocksdodged = escapedtable["Roadblocks"]
		local spikestripsdodged = escapedtable["Spikestrips"]
		local bounty = UVBounty
		local tags = UVTags
		local wrecks = UVWrecks
		
		local ResultPanel = vgui.Create("DFrame")
		local OK = vgui.Create("DButton")
		
		ResultPanel:Add(OK)
		ResultPanel:SetSize(math.Round(w*0.5208333333), math.Round(h*0.5555555556))
		ResultPanel:SetBackgroundBlur(true)
		ResultPanel:ShowCloseButton(false)
		ResultPanel:Center()
		ResultPanel:SetTitle("")
		ResultPanel:SetDraggable(false)
		ResultPanel:MakePopup()
		ResultPanel:SetKeyboardInputEnabled(false)
		
		OK:SetText("#addons.confirm")
		OK:SetSize(ResultPanel:GetWide() * 5 / 16, 22)
		OK:Dock(BOTTOM)
		
		local timetotal = 30
		local timestart = CurTime()
		
		ResultPanel.Paint = function(self, w, h)
			local timeremaining = math.ceil(timetotal - (CurTime() - timestart))
			local lang = language.GetPhrase

			draw.RoundedBox(2, 0, 0, w, h, Color(0,0,0,225))
			draw.SimpleText("--- " .. lang("uv.chase.evade") .. " ---", "UVFont", w*0.5, h*0.01, Color(0, 255, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText( lang("uv.results.escapedfrom"), "UVFont5", w*0.5, h*0.075, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.bounty", "UVFont5", w*0.01, h*0.15, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.time", "UVFont5", w*0.01, h*0.25, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.units.deployed", "UVFont5", w*0.01, h*0.35, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.units.damaged", "UVFont5", w*0.01, h*0.45, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.units.destroyed", "UVFont5", w*0.01, h*0.55, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.dodged.blocks", "UVFont5", w*0.01, h*0.65, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.dodged.spikes", "UVFont5", w*0.01, h*0.75, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			
			draw.SimpleText( bounty, "UVFont5", w*0.99, h*0.15, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( time, "UVFont5", w*0.99, h*0.25, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( deploys, "UVFont5", w*0.99, h*0.35, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( tags, "UVFont5", w*0.99, h*0.45, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( wrecks, "UVFont5", w*0.99, h*0.55, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( roadblocksdodged, "UVFont5", w*0.99, h*0.65, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( spikestripsdodged, "UVFont5", w*0.99, h*0.75, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			
			-- Time remaining and closing
			
			draw.DrawText( "[ " .. input.LookupBinding("+jump") .. " ] " .. lang("uv.results.continue"), "UVFont5", w*0.01, h*0.85, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT )
			
			draw.DrawText( string.format( language.GetPhrase("uv.results.autoclose"), timeremaining ), "UVFont5", w*0.99, h*0.85, Color( 255, 255, 255 ), TEXT_ALIGN_RIGHT )
			if timeremaining < 1 then
				hook.Remove("Think", "CheckJumpKeyForDebrief")
				self:Close()
			end
			
		end
		
		function OK:DoClick() 
			hook.Remove("Think", "CheckJumpKeyForDebrief")
			ResultPanel:Close()
		end
		
		local wasJumping = false
		hook.Add("Think", "CheckJumpKeyForDebrief", function()
			local ply = LocalPlayer()
			if not IsValid(ply) then return end
			
			if ply:KeyDown(IN_JUMP) then
				if not wasJumping then
					wasJumping = true
					if IsValid(ResultPanel) then
						ResultPanel:Close()
						hook.Remove("Think", "CheckJumpKeyForDebrief")
					end
				end
			else
				wasJumping = false
			end
		end)
    end,
    onRacerBustedDebrief = function(...)
        local w = ScrW()
		local h = ScrH()

        local bustedtable = select( 1, ... )

        --------------------------------------

        local time = UVDisplayTime(UVTimerProgress)
		local unit = bustedtable["Unit"]
		local deploys = bustedtable["Deploys"]
		local roadblocksdodged = bustedtable["Roadblocks"]
		local spikestripsdodged = bustedtable["Spikestrips"]
		local bounty = UVBounty
		local tags = UVTags
		local wrecks = UVWrecks
		
		local ResultPanel = vgui.Create("DFrame")
		local OK = vgui.Create("DButton")
		
		ResultPanel:Add(OK)
		ResultPanel:SetSize(math.Round(w*0.5208333333), math.Round(h*0.5555555556))
		ResultPanel:SetBackgroundBlur(true)
		ResultPanel:ShowCloseButton(false)
		ResultPanel:Center()
		ResultPanel:SetTitle("")
		ResultPanel:SetDraggable(false)
		ResultPanel:MakePopup()
		ResultPanel:SetKeyboardInputEnabled(false)
		
		OK:SetText("#addons.confirm")
		OK:SetSize(ResultPanel:GetWide() * 5 / 16, 22)
		OK:Dock(BOTTOM)
		
		local timetotal = 30
		local timestart = CurTime()
		
		ResultPanel.Paint = function(self, w, h)
			local timeremaining = math.ceil(timetotal - (CurTime() - timestart))
			local lang = language.GetPhrase

			draw.RoundedBox(2, 0, 0, w, h, Color(0,0,0,225))
			draw.SimpleText("/// " .. lang("uv.chase.busted") .. " ///", "UVFont", w*0.5, h*0.01, Color(255, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText(string.format( lang("uv.results.bustedby"), unit ), "UVFont5", w*0.5, h*0.075, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.bounty", "UVFont5", w*0.01, h*0.15, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.time", "UVFont5", w*0.01, h*0.25, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.units.deployed", "UVFont5", w*0.01, h*0.35, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.units.damaged", "UVFont5", w*0.01, h*0.45, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.units.destroyed", "UVFont5", w*0.01, h*0.55, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.dodged.blocks", "UVFont5", w*0.01, h*0.65, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText( "#uv.results.chase.dodged.spikes", "UVFont5", w*0.01, h*0.75, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			
			draw.SimpleText( bounty, "UVFont5", w*0.99, h*0.15, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( time, "UVFont5", w*0.99, h*0.25, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( deploys, "UVFont5", w*0.99, h*0.35, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( tags, "UVFont5", w*0.99, h*0.45, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( wrecks, "UVFont5", w*0.99, h*0.55, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( roadblocksdodged, "UVFont5", w*0.99, h*0.65, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			draw.SimpleText( spikestripsdodged, "UVFont5", w*0.99, h*0.75, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			
			-- Time remaining and closing
			
			draw.DrawText( "[ " .. input.LookupBinding("+jump") .. " ] " .. lang("uv.results.continue"), "UVFont5", w*0.01, h*0.85, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT )
			
			draw.DrawText( string.format( language.GetPhrase("uv.results.autoclose"), timeremaining ), "UVFont5", w*0.99, h*0.85, Color( 255, 255, 255 ), TEXT_ALIGN_RIGHT )
			if timeremaining < 1 then
				hook.Remove("Think", "CheckJumpKeyForDebrief")
				self:Close()
			end
			
		end
		
		function OK:DoClick() 
			hook.Remove("Think", "CheckJumpKeyForDebrief")
			ResultPanel:Close()
		end
		
		local wasJumping = false
		hook.Add("Think", "CheckJumpKeyForDebrief", function()
			local ply = LocalPlayer()
			if not IsValid(ply) then return end
			
			if ply:KeyDown(IN_JUMP) then
				if not wasJumping then
					wasJumping = true
					if IsValid(ResultPanel) then
						ResultPanel:Close()
						hook.Remove("Think", "CheckJumpKeyForDebrief")
					end
				end
			else
				wasJumping = false
			end
		end)
    end,
}

local function original_racing_main( ... )
    local w = ScrW()
    local h = ScrH()
    
    local my_vehicle = select(1, ...)
    local my_array = select(2, ...)
    local string_array = select(3, ...)
    
    local racer_count = #string_array
    local lang = language.GetPhrase
    
    local checkpoint_count = #my_array["Checkpoints"]
    
    ------------------------------------
    
    local element1 = {}
    if UVHUDRaceInfo.Info.Laps > 1 then
        element1 = {
            {x = 0, y = h / 7},
            {x = w * 0.35, y = h / 7},
            {x = w * 0.25, y = h / 3},
            {x = 0, y = h / 3}
        }
    else
        element1 = {
            {x = 0, y = h / 7},
            {x = w * 0.35, y = h / 7},
            {x = w * 0.25, y = h / 3.5},
            {x = 0, y = h / 3.5}
        }
    end
    -- HUD Background
    surface.SetDrawColor(0, 0, 0, 200)
    draw.NoTexture()
    surface.DrawPoly(element1)
    
    -- All HUD Text (I mean, it *works*...)
    draw.DrawText(lang("uv.race.orig.time") ..UVDisplayTimeRace((UVHUDRaceInfo.Info.Started and (CurTime() - UVHUDRaceInfo.Info.Time)) or 0) .."\n"
    ..lang("uv.race.orig.check") ..checkpoint_count .."/"
    ..GetGlobalInt("uvrace_checkpoints") .."\n" 
    ..(UVHUDRaceInfo.Info.Laps > 1 and lang("uv.race.orig.lap") 
    ..my_array.Lap .. "/" .. UVHUDRaceInfo.Info.Laps .. "\n" or "") 
    ..lang("uv.race.orig.pos") 
    .. UVHUDRaceCurrentPos 
    .. "/" 
    .. UVHUDRaceCurrentParticipants, "UVFont", 10, h / 7, Color(255, 255, 255), TEXT_ALIGN_LEFT)
    
    -- Racer List
    for i = 1, racer_count, 1 do
        local entry = string_array[i]
        
        local racer_name = entry[1]
        local is_local_player = entry[2]
        local mode = entry[3]
        local diff = entry[4]
        -- local racercount = i * (racer_count > 8 and w*0.0135 or w*0.0115)
        local racerpos = 3.75
        
        if UVHUDRaceInfo.Info.Laps > 1 then
            racerpos = 3.25
        end
        
        local color = nil
        
        if is_local_player then
            color = Colors.Original_LocalPlayer
        elseif entry[3] == "Disqualified" or entry[3] == "Busted" then
            color = Colors.Original_Disqualified
        else
            color = Colors.Original_Others
        end
        
        local text = alt and (status_text) or (i .. ". " .. racer_name)
        
        draw.DrawText(text,"UVFont4",10,(h / racerpos) + i * ((racer_count > 5 and 20) or 28),color,TEXT_ALIGN_LEFT)
    end
end

local function original_pursuit_main( ... )
    local hudyes = GetConVar("cl_drawhud"):GetBool()
    
    if not hudyes then return end
    if not UVHUDDisplayPursuit then return end
    
    local vehicle = LocalPlayer():GetVehicle()
    
    local w = ScrW()
    local h = ScrH()
    local lang = language.GetPhrase
    
    local UnitsChasing = tonumber(UVUnitsChasing)
    local UVBustTimer = BustedTimer:GetFloat()
	local UVBustingProgress = 0
    
    local states = UV_UI.pursuit.original.states
    
    local UVWrecksColor = states.WrecksColor
    local UVTagsColor = states.TagsColor
    local UVUnitsColor = states.UnitsColor
    
    if vehicle == NULL then return end
    
    if UVHUDCopMode and not UVHUDDisplayNotification then
        UVHUDDisplayBusting = false
    end
    
    if UVHUDCopMode and next(UVHUDWantedSuspects) ~= nil then
        local ply = LocalPlayer()
        
        UVClosestSuspect = nil
        UVHUDDisplayBusting = false
        
        local closestDistance = math.huge
        
        for _, suspect in pairs(UVHUDWantedSuspects) do
            if not IsValid(suspect) then continue end
            local dist = ply:GetPos():DistToSqr(suspect:GetPos())
            
            if (#UVHUDWantedSuspects == 1 or dist < 250000) and dist < closestDistance then
                closestDistance = dist
                UVClosestSuspect = suspect
            end
        end
        
        if UVClosestSuspect then
            if UVClosestSuspect.beingbusted then
                UVHUDDisplayBusting = true
                UVBustingProgress = UVClosestSuspect.uvbustingprogress
                
                local blink = 255 * math.abs(math.sin(RealTime() * 8))
                states.BustedColor = Color(255, blink, blink)
            end
        end
    end
    
		if UVHUDDisplayPursuit and hudyes and vehicle ~= NULL then
			outofpursuit = CurTime()

			local UVHeatBountyMin
			local UVHeatBountyMax
			local element1 = {
				{ x = w/1.35, y = h/20 },
				{ x = w/1.155, y = 0 },
				{ x = w, y = 0 },
				{ x = w, y = h/7 },
				{ x = w/1.35, y = h/7 },
			}
			surface.SetDrawColor( 0, 0, 0, 200)
			draw.NoTexture()
			surface.DrawPoly( element1 )
			local element2 = {
				{ x = w/3, y = h/1.1+28+12 },
				{ x = w/3+12+w/3, y = h/1.1+28+12 },
				{ x = w/3+12+w/3-25, y = h/1 },
				{ x = w/3+25, y = h/1 },
			}
			draw.NoTexture()
			surface.DrawPoly( element2 )
			surface.SetDrawColor( 0, 0, 0, 200)

			DrawIcon(UVMaterials['CLOCK'], w/1.135, h*0.07, .05, Color(255,255,255))

			draw.DrawText( UVTimer, "UVFont5",w/1.005, h/20, Color( 255, 255, 255), TEXT_ALIGN_RIGHT )
			surface.SetFont( "UVFont5" )
			surface.SetTextColor(255,255,255)
			surface.SetTextPos( w/1.35, h/10 ) 
			surface.DrawText( "#uv.hud.bounty" )
			draw.DrawText( UVBounty, "UVFont5",w/1.005, h/10, Color( 255, 255, 255), TEXT_ALIGN_RIGHT )

			if UVHeatLevel == 1 then
				UVHeatBountyMin = UVUHeatMinimumBounty1:GetInt()
				UVHeatBountyMax = UVUHeatMinimumBounty2:GetInt()
			elseif UVHeatLevel == 2 then
				UVHeatBountyMin = UVUHeatMinimumBounty2:GetInt()
				UVHeatBountyMax = UVUHeatMinimumBounty3:GetInt()
			elseif UVHeatLevel == 3 then
				UVHeatBountyMin = UVUHeatMinimumBounty3:GetInt()
				UVHeatBountyMax = UVUHeatMinimumBounty4:GetInt()
			elseif UVHeatLevel == 4 then
				UVHeatBountyMin = UVUHeatMinimumBounty4:GetInt()
				UVHeatBountyMax = UVUHeatMinimumBounty5:GetInt()
			elseif UVHeatLevel == 5 then
				UVHeatBountyMin = UVUHeatMinimumBounty5:GetInt()
				UVHeatBountyMax = UVUHeatMinimumBounty6:GetInt()
			elseif UVHeatLevel == 6 then
				UVHeatBountyMin = UVUHeatMinimumBounty6:GetInt()
				UVHeatBountyMax = math.huge
			end

			draw.DrawText( UVHeatLevel.." ", "UVFont5", w/1.099, h/120, Color( 255, 255, 255), TEXT_ALIGN_RIGHT )

			DrawIcon(UVMaterials['HEAT'], w/1.135, h*0.027, .05, Color(255,255,255))

			surface.SetDrawColor(Color(109,109,109,200))
			surface.DrawRect(w/1.099,h/120,w/20+60,39)
			surface.SetDrawColor(Color(255,255,255))
			local HeatProgress = 0
			if MaxHeatLevel:GetInt() != UVHeatLevel then
				if UVUTimeTillNextHeatEnabled:GetInt() == 1 and UVTimeTillNextHeat then --Time till next heat level
					if UVHeatLevel == 1 then
						local maxtime = UVUTimeTillNextHeat1:GetInt()
						HeatProgress = (maxtime-UVTimeTillNextHeat)/maxtime
					elseif UVHeatLevel == 2 then
						local maxtime = UVUTimeTillNextHeat2:GetInt()
						HeatProgress = (maxtime-UVTimeTillNextHeat)/maxtime
					elseif UVHeatLevel == 3 then
						local maxtime = UVUTimeTillNextHeat3:GetInt()
						HeatProgress = (maxtime-UVTimeTillNextHeat)/maxtime
					elseif UVHeatLevel == 4 then
						local maxtime = UVUTimeTillNextHeat4:GetInt()
						HeatProgress = (maxtime-UVTimeTillNextHeat)/maxtime
					elseif UVHeatLevel == 5 then
						local maxtime = UVUTimeTillNextHeat5:GetInt()
						HeatProgress = (maxtime-UVTimeTillNextHeat)/maxtime
					elseif UVHeatLevel == 6 then
						HeatProgress = 0
					end
				else
					HeatProgress = ((UVBountyNo-UVHeatBountyMin)/(UVHeatBountyMax-UVHeatBountyMin))
				end
			end
			local B = math.Clamp((HeatProgress)*(w/20+60),0,w/20+60)
			local blink = 255 * math.abs(math.sin(RealTime() * 4))
			local blink2 = 255 * math.abs(math.sin(RealTime() * 6))
			local blink3 = 255 * math.abs(math.sin(RealTime() * 8))

			if HeatProgress >= 0.6 and HeatProgress < 0.75 then
				surface.SetDrawColor(Color(255,blink,blink))
			elseif HeatProgress >= 0.75 and HeatProgress < 0.9 then
				surface.SetDrawColor(Color(255,blink2,blink2))
			elseif HeatProgress >= 0.9 and HeatProgress < 1 then
				surface.SetDrawColor(Color(255, blink3, blink3))
			elseif HeatProgress >= 1 then
				surface.SetDrawColor(Color(255,0,0))
			end

			surface.DrawRect(w/1.099,h/120,B,39)
			local ResourceText = UVResourcePoints
			if UVOneCommanderActive then
				if !UVHUDCommanderLastHealth or !UVHUDCommanderLastMaxHealth then
					UVHUDCommanderLastHealth = 0
					UVHUDCommanderLastMaxHealth = 0
				end
				if IsValid(UVHUDCommander) then
					if UVHUDCommander.IsSimfphyscar then
						UVHUDCommanderLastHealth = UVHUDCommander:GetCurHealth()
						UVHUDCommanderLastMaxHealth = UVUOneCommanderHealth:GetInt()-(UVHUDCommander:GetMaxHealth()*0.3)
					elseif UVHUDCommander.IsGlideVehicle then
						local enginehealth = UVHUDCommander:GetEngineHealth()
						UVHUDCommanderLastHealth = UVHUDCommander:GetChassisHealth()*enginehealth
						UVHUDCommanderLastMaxHealth = UVUOneCommanderHealth:GetInt()
					elseif vcmod_main then
						UVHUDCommanderLastHealth = UVUOneCommanderHealth:GetInt()*(UVHUDCommander:VC_getHealth()/100) --vcmod returns % health clientside
						UVHUDCommanderLastMaxHealth = UVUOneCommanderHealth:GetInt()
					else
						UVHUDCommanderLastHealth = UVHUDCommander:Health()
						UVHUDCommanderLastMaxHealth = UVUOneCommanderHealth:GetInt()
					end
					UVRenderCommander(UVHUDCommander)
				end
				local healthratio = UVHUDCommanderLastHealth/UVHUDCommanderLastMaxHealth
				local healthcolor
				if healthratio >= 0.5 then
					healthcolor = Color(255,255,255,200)
				elseif healthratio >= 0.25 then
					if math.floor(RealTime()*2)==math.Round(RealTime()*2) then
						healthcolor = Color( 255, 0, 0)
					else
						healthcolor = Color( 255, 255, 255)
					end
				else
					if math.floor(RealTime()*4)==math.Round(RealTime()*4) then
						healthcolor = Color( 255, 0, 0)
					else
						healthcolor = Color( 255, 255, 255)
					end
				end
				ResourceText = "⛊\n∞"
				local element3 = {
					{ x = w/3, y = 0 },
					{ x = w/3+12+w/3, y = 0 },
					{ x = w/3+12+w/3-25, y = h/20 },
					{ x = w/3+25, y = h/20 },
				}
				surface.SetDrawColor( 0, 0, 0, 200)
				draw.NoTexture()
				surface.DrawPoly( element3 )
				if healthratio > 0 then
					surface.SetDrawColor(Color(109,109,109,200))
					surface.DrawRect(w/3+25,h/20,w/3-38,8)
					surface.SetDrawColor(healthcolor)
					local T = math.Clamp((healthratio)*(w/3-38),0,w/3-38)
					surface.DrawRect(w/3+25,h/20,T,8)
				end
				draw.DrawText( "⛊ " .. lang("uv.unit.commander") .. " ⛊", "UVFont2",w/2,0, Color(0, 161, 255), TEXT_ALIGN_CENTER )
			end
			if !UVHUDDisplayNotification then
				if (UnitsChasing > 0 or NeverEvade:GetBool()) and !UVHUDDisplayCooldown then
					EvadingProgress = 0
					local iconhigh = 0
					local busttime = math.Round((BustedTimer:GetFloat()-UVBustingProgress),3)
					if BustingProgress > 0 then iconhigh = h*0.035 end

					DrawIcon(UVMaterials['UNITS'], w / 2, h / 1.14 - iconhigh, .06, UVUnitsColor)
					draw.DrawText( ResourceText, "UVFont5WeightShadow",w/2,h/1.115 - iconhigh, UVUnitsColor, TEXT_ALIGN_CENTER )

					draw.DrawText( UVWrecks, "UVFont5WeightShadow",w/3.28+w/3+12,h/1.115 - iconhigh, UVWrecksColor, TEXT_ALIGN_RIGHT )
					DrawIcon(UVMaterials['UNITS_DISABLED'], w/3.1+w/3+12, h/1.09 - iconhigh, 0.06, UVWrecksColor)

					DrawIcon(UVMaterials['UNITS_DAMAGED'], w/2.9, h/1.09 - iconhigh, 0.06, UVTagsColor)
					draw.DrawText( UVTags, "UVFont5WeightShadow", w/2.79, h/1.115 - iconhigh, UVTagsColor, TEXT_ALIGN_LEFT )
					
					if BustingProgress == 0 then
						if !UVHUDDisplayBackupTimer then
							local uloc, utype = "uv.chase.unit", UnitsChasing
							if !UVHUDCopMode then
								if UnitsChasing != 1 then 
									uloc = "uv.chase.units"
								end
							else
								utype = UVHUDWantedSuspectsNumber
								uloc = "uv.chase.suspects"
							end

							draw.DrawText( string.format( lang(uloc), utype ), "UVFont-Smaller",w/2,h/1.05, UVResourcePointsColor, TEXT_ALIGN_CENTER )
						else
							draw.DrawText( string.format( lang("uv.chase.backupin"), UVBackupTimer ), "UVFont-Smaller",w/2,h/1.05, UVResourcePointsColor, TEXT_ALIGN_CENTER )
						end
					else
						if busttime >= 3 then
							busttext = lang("uv.chase.busting")
							bustcol = Color( 255, 255, 255)
						elseif busttime >= 2 then
							busttext = "! " .. lang("uv.chase.busting") .. " !"
							bustcol = Color( 255, blink, blink)
						elseif busttime >= 1 then
							busttext = "!! " .. lang("uv.chase.busting") .. " !!"
							bustcol = Color( 255, blink2, blink2)
						elseif busttime >= 0 then
							busttext = "!!! " .. lang("uv.chase.busting") .. " !!!"
							bustcol = Color( 255, blink3, blink3)
						end
						draw.DrawText( busttext, "UVFont-Smaller",w/2,h/1.05, bustcol, TEXT_ALIGN_CENTER )
					end
					UVSoundHeat(UVHeatLevel)
				elseif !UVHUDDisplayCooldown then
					if !EvadingProgress or EvadingProgress == 0 then
						EvadingProgress = CurTime()
						UVEvadingProgress = EvadingProgress
					end

					draw.DrawText( UVWrecks, "UVFont5WeightShadow",w/3.28+w/3+12,h/1.16, UVWrecksColor, TEXT_ALIGN_RIGHT )
					DrawIcon(UVMaterials['UNITS_DISABLED'], w/3.1+w/3+12, h/1.13, 0.06, UVWrecksColor)

					draw.DrawText( UVTags, "UVFont5WeightShadow", w/2.79, h/1.16, UVTagsColor, TEXT_ALIGN_LEFT )
					DrawIcon(UVMaterials['UNITS_DAMAGED'], w/2.9, h/1.13, 0.06, UVTagsColor)

					draw.DrawText( ResourceText, "UVFont5WeightShadow",w/2,h/1.17, UVUnitsColor, TEXT_ALIGN_CENTER )
					DrawIcon(UVMaterials['UNITS'], w / 2, h / 1.2, .06, UVUnitsColor)

					local blink = 255 * math.abs(math.sin(RealTime() * 6))
					color = Color( blink, 255, blink)

					draw.DrawText( lang("uv.chase.evading"), "UVFont-Smaller",w/2,h/1.05, color, TEXT_ALIGN_CENTER )

					surface.SetDrawColor( 0, 0, 0, 200)
					surface.DrawRect( w/3,h/1.1,w/3+12, 40 )
					surface.SetDrawColor(Color( 0, 255, 0))
					surface.DrawRect(w/3,h/1.1,12,40)
					surface.DrawRect(w*2/3,h/1.1,12,40)
					surface.DrawRect(w/3+12,h/1.1,w/3-12,12)
					surface.DrawRect(w/3+12,h/1.1+28,w/3-12,12)
					surface.SetDrawColor(Color( 0, 255, 0))
					local T = math.Clamp((UVEvadingProgress)*(w/3-20),0,w/3-20)
					surface.DrawRect(w/3+16,h/1.1+16,T,8)
					UVSoundHeat(UVHeatLevel)
				else
					EvadingProgress = 0

					if UVHUDCopMode then
						draw.DrawText( UVWrecks, "UVFont5",w/3.28+w/3+12,h/1.115, UVWrecksColor, TEXT_ALIGN_RIGHT )
						DrawIcon(UVMaterials['UNITS_DISABLED'], w/3.1+w/3+12, h/1.09, 0.06, UVWrecksColor)

						DrawIcon(UVMaterials['UNITS_DAMAGED'], w/2.9, h/1.09, 0.06, UVTagsColor)
						draw.DrawText( UVTags, "UVFont5WeightShadow", w/2.79, h/1.115, UVTagsColor, TEXT_ALIGN_LEFT )

						DrawIcon(UVMaterials['UNITS'], w / 2, h / 1.14, .06, UVUnitsColor)
						draw.DrawText( ResourceText, "UVFont5WeightShadow",w/2,h/1.115, UVUnitsColor, TEXT_ALIGN_CENTER )
					else
						draw.DrawText( UVWrecks, "UVFont5WeightShadow",w/3.28+w/3+12,h/1.16, UVWrecksColor, TEXT_ALIGN_RIGHT )
						DrawIcon(UVMaterials['UNITS_DISABLED'], w/3.1+w/3+12, h/1.13, 0.06, UVWrecksColor)

						draw.DrawText( UVTags, "UVFont5WeightShadow", w/2.79, h/1.16, UVTagsColor, TEXT_ALIGN_LEFT )
						DrawIcon(UVMaterials['UNITS_DAMAGED'], w/2.9, h/1.13, 0.06, UVTagsColor)

						draw.DrawText( ResourceText, "UVFont5WeightShadow",w/2,h/1.17, UVUnitsColor, TEXT_ALIGN_CENTER )
						DrawIcon(UVMaterials['UNITS'], w / 2, h / 1.2, .06, UVUnitsColor)
					end

					local color = Color(255,255,255)

					if UVHUDCopMode then
						local blink = 255 * math.abs(math.sin(RealTime() * 6))
						color = Color( blink, blink, 255)
					end

					local text = (UVHUDCopMode and "/// "..lang("uv.chase.cooldown").." ///") or lang("uv.chase.cooldown")

					draw.DrawText( text, "UVFont-Smaller",w/2,h/1.05, color, TEXT_ALIGN_CENTER )
				end
			else
				EvadingProgress = 0
				if UVHUDDisplayBusting or UVHUDDisplayCooldown then
					if UVHUDCopMode then
						draw.DrawText( UVWrecks, "UVFont5WeightShadow",w/3.28+w/3+12,h/1.115, UVWrecksColor, TEXT_ALIGN_RIGHT )
						DrawIcon(UVMaterials['UNITS_DISABLED'], w/3.1+w/3+12, h/1.09, 0.06, UVWrecksColor)

						DrawIcon(UVMaterials['UNITS_DAMAGED'], w/2.9, h/1.09, 0.06, UVTagsColor)
						draw.DrawText( UVTags, "UVFont5WeightShadow", w/2.79, h/1.115, UVTagsColor, TEXT_ALIGN_LEFT )

						DrawIcon(UVMaterials['UNITS'], w / 2, h / 1.14, .06, UVUnitsColor)
						draw.DrawText( ResourceText, "UVFont5WeightShadow",w/2,h/1.115, UVUnitsColor, TEXT_ALIGN_CENTER )
					else
						draw.DrawText( UVWrecks, "UVFont5WeightShadow",w/3.28+w/3+12,h/1.16, UVWrecksColor, TEXT_ALIGN_RIGHT )
						DrawIcon(UVMaterials['UNITS_DISABLED'], w/3.1+w/3+12, h/1.13, 0.06, UVWrecksColor)

						draw.DrawText( UVTags, "UVFont5WeightShadow", w/2.79, h/1.16, UVTagsColor, TEXT_ALIGN_LEFT )
						DrawIcon(UVMaterials['UNITS_DAMAGED'], w/2.9, h/1.13, 0.06, UVTagsColor)

						draw.DrawText( ResourceText, "UVFont5WeightShadow",w/2,h/1.17, UVUnitsColor, TEXT_ALIGN_CENTER )
						DrawIcon(UVMaterials['UNITS'], w / 2, h / 1.2, .06, UVUnitsColor)
					end
				else
					draw.DrawText( UVWrecks, "UVFont5WeightShadow",w/3.28+w/3+12,h/1.115, UVWrecksColor, TEXT_ALIGN_RIGHT )
					DrawIcon(UVMaterials['UNITS_DISABLED'], w/3.1+w/3+12, h/1.09, 0.06, UVWrecksColor)

					DrawIcon(UVMaterials['UNITS_DAMAGED'], w/2.9, h/1.09, 0.06, UVUnitsColor)
					draw.DrawText( UVTags, "UVFont5WeightShadow", w/2.79, h/1.115, UVUnitsColor, TEXT_ALIGN_LEFT )

					DrawIcon(UVMaterials['UNITS'], w / 2, h / 1.14, .06, UVUnitsColor)
					draw.DrawText( ResourceText, "UVFont5WeightShadow",w/2,h/1.115, UVUnitsColor, TEXT_ALIGN_CENTER )
				end
				draw.DrawText( UVNotification, "UVFont-Smaller",w/2,h/1.05, UVNotificationColor, TEXT_ALIGN_CENTER )
			end
			-- elseif not UVPlayingRace then
			-- 	--UVStopSound()
			-- 	if UVSoundLoop then
			-- 		UVSoundLoop:Stop()
			-- 		UVSoundLoop = nil
			-- 	end
		end

		-- if (not UVHUDDisplayPursuit) and ((not UVHUDDisplayRacing) or (not UVHUDRace)) then
		-- 	UVStopSound()

		-- 	if UVSoundLoop then
		-- 		UVSoundLoop:Stop()
		-- 		UVSoundLoop = nil
		-- 	end
		-- end

		if vehicle == NULL then 
			UVHUDPursuitTech = nil
			return 
		end

		if UVHUDDisplayBusting and !UVHUDDisplayCooldown and hudyes then
			if !BustingProgress or BustingProgress == 0 then
				BustingProgress = CurTime()
			end
			surface.SetDrawColor( 0, 0, 0, 200)
			surface.DrawRect( w/3,h/1.1,w/3+12, 40 )
			surface.SetDrawColor(Color(255,0,0))
			surface.DrawRect(w/3,h/1.1,12,40)
			surface.DrawRect(w*2/3,h/1.1,12,40)
			surface.DrawRect(w/3+12,h/1.1,w/3-12,12)
			surface.DrawRect(w/3+12,h/1.1+28,w/3-12,12)
			surface.SetDrawColor(Color(255,0,0))
			local T = math.Clamp((UVBustingProgress/UVBustTimer)*(w/3-20),0,w/3-20)
			surface.DrawRect(w/3+16,h/1.1+16,T,8)
		else
			BustingProgress = 0
		end

		if UVHUDDisplayCooldown and hudyes then
			if !CooldownProgress or CooldownProgress == 0 then
				CooldownProgress = CurTime()
			end
			UVSoundCooldown()
			if !UVHUDCopMode then
				surface.SetDrawColor( 0, 0, 0, 200)
				surface.DrawRect( w/3,h/1.1,w/3+12, 40 )
				surface.SetDrawColor(Color(0,0,255))
				surface.DrawRect(w/3,h/1.1,12,40)
				surface.DrawRect(w*2/3,h/1.1,12,40)
				surface.DrawRect(w/3+12,h/1.1,w/3-12,12)
				surface.DrawRect(w/3+12,h/1.1+28,w/3-12,12)
				surface.SetDrawColor(Color(0,0,255))
				local T = math.Clamp((UVCooldownTimer)*(w/3-20),0,w/3-20)
				surface.DrawRect(w/3+16,h/1.1+16,T,8)
			end
			EvadingProgress = 0
		else
			CooldownProgress = 0
		end
end

UV_UI.racing.original.main = original_racing_main
UV_UI.pursuit.original.main = original_pursuit_main

-- Pro Street

UV_UI.racing.prostreet = {}
UV_UI.pursuit.prostreet = {}

local function prostreet_racing_main( ... )
    local w = ScrW()
    local h = ScrH()
    
    local my_vehicle = select(1, ...)
    local my_array = select(2, ...)
    local string_array = select(3, ...)
    
    local racer_count = #string_array
    local lang = language.GetPhrase
    
    local checkpoint_count = #my_array["Checkpoints"]
    
    ------------------------------------
    
    -- Timer
    surface.SetDrawColor(0, 0, 0, 200)
    surface.DrawRect(w * 0.425, h * 0.075, w * 0.15, h * 0.05)
    
    draw.DrawText( -- Shadow
    "#uv.race.hud.time.ps",
    "UVFont5",
    w * 0.5 + 2.5,
    h * 0.035 + 2.5,
    Color(0, 0, 0),
    TEXT_ALIGN_CENTER)
    
    draw.DrawText(
    "#uv.race.hud.time.ps",
    "UVFont5",
    w * 0.5,
    h * 0.035,
    Color(255, 255, 255, 150),
    TEXT_ALIGN_CENTER)
    
    draw.DrawText(
	Carbon_FormatRaceTime((UVHUDRaceInfo.Info.Started and (CurTime() - UVHUDRaceInfo.Info.Time)) or 0),
	"UVFont5",
    w * 0.5,
    h * 0.0775,
    Color(255, 255, 255),
    TEXT_ALIGN_CENTER)
    
    -- Lap & Checkpoint Counter
    if UVHUDRaceInfo.Info.Laps > 1 then
        draw.DrawText( -- Shadow
        "#uv.race.hud.lap.ps",
        "UVFont5",
        w * 0.9 + 2.5,
        h * 0.075 + 2.5,
        Color(0, 0, 0),
        TEXT_ALIGN_RIGHT)
        draw.DrawText(
        "#uv.race.hud.lap.ps",
        "UVFont5",
        w * 0.9,
        h * 0.075,
        Color(255, 255, 255, 150),
        TEXT_ALIGN_RIGHT)
        
        draw.DrawText(
        my_array.Lap .. "/" .. UVHUDRaceInfo.Info.Laps,
        "UVFont5",
        w * 0.97 + 2.5,
        h * 0.075 + 2.5,
        Color(0, 0, 0),
        TEXT_ALIGN_RIGHT) -- Lap Counter
        draw.DrawText(
        my_array.Lap .. "/" .. UVHUDRaceInfo.Info.Laps,
        "UVFont5",
        w * 0.97,
        h * 0.075,
        Color(200,255,100),
        TEXT_ALIGN_RIGHT) -- Lap Counter
    else
        draw.DrawText( -- Shadow
        "#uv.race.hud.complete.ps",
        "UVFont5UI",
        w * 0.9 + 2.5,
        h * 0.075 + 2.5,
        Color(0, 0, 0),
        TEXT_ALIGN_RIGHT)
        draw.DrawText(
        "#uv.race.hud.complete.ps",
        "UVFont5UI",
        w * 0.9,
        h * 0.075,
        Color(255, 255, 255, 150),
        TEXT_ALIGN_RIGHT)
        
        draw.DrawText( -- Shadow
        math.floor(((checkpoint_count / GetGlobalInt("uvrace_checkpoints")) * 100)) .. "%",
        "UVFont5",
        w * 0.97 + 2.5,
        h * 0.075 + 2.5,
        Color(0, 0, 0),
        TEXT_ALIGN_RIGHT)
        draw.DrawText(
        math.floor(((checkpoint_count / GetGlobalInt("uvrace_checkpoints")) * 100)) .. "%",
        "UVFont5",
        w * 0.97,
        h * 0.075,
        Color(200,255,100),
        TEXT_ALIGN_RIGHT)
    end
    
    local racer_count = #string_array
    local lang = language.GetPhrase
    
    -- Racer List
    local alt = math.floor(CurTime() / 5) % 2 == 1 -- toggles every 5 seconds
    local boxyes = false
    for i = 1, racer_count, 1 do
        --if racer_count == 1 then return end
        local entry = string_array[i]
        
        local racer_name = entry[1]
        local is_local_player = entry[2]
        local mode = entry[3]
        local diff = entry[4]
        local racercount = i * w * 0.0135
        local racercountbox = i * w * 0.0135 * racer_count
        
        local Strings = {
            ["Time"] = "%s",
            ["Lap"] = lang("uv.race.suffix.lap"),
            -- ["Laps"] = lang("uv.race.suffix.laps"),
            ["Finished"] = lang("uv.race.suffix.finished"),
            ["Disqualified"] = lang("uv.race.suffix.dnf"),
            ["Busted"] = lang("uv.race.suffix.busted"),
        }
        
        local status_text = "-----"
        
        if entry[3] then
            local status_string = Strings[entry[3]]
            
            if status_string then
                local args = {}
                
                if entry[4] then
                    local num = tonumber(entry[4])
                    num =
                    ((num > 0 and "+") or "-") ..
                    string.format((entry[3] == "Lap" and "%s") or "%.2f", math.abs(num))
                    
                    table.insert(args, num)
                end
                
                status_text = #args <= 0 and status_string or string.format(status_string, unpack(args))
            end
        end
        
        local color = nil
        
        if is_local_player then
            color = Color(200, 255, 100)
        elseif entry[3] == "Disqualified" or entry[3] == "Busted" then
            color = Colors.MW_Disqualified
        else
            color = Colors.MW_Others
        end
        
        local text = alt and (status_text) or (racer_name)
        
        if !boxyes then
            surface.SetDrawColor(0, 0, 0, 200)
            draw.NoTexture()
            surface.DrawRect(w * 0.025, h * 0.1, w * 0.15, h * 0.04 + racercountbox)
            boxyes = true
        end
        
        draw.DrawText(i .. "      " .. text, "UVFont4", w * 0.0275, (h * 0.1) + racercount, color, TEXT_ALIGN_LEFT)
    end
end

UV_UI.racing.prostreet.main = prostreet_racing_main

-- Underground

UV_UI.racing.underground = {}
UV_UI.pursuit.underground = {}

UV_UI.racing.underground.states = {
    FrozenTime = false,
    FrozenTimeValue = 0
}

UV_UI.racing.underground.events = {
    onLapComplete = function( ... )
        local participant  = select( 1, ... )
        local new_lap      = select( 2, ... )
        local old_lap      = select( 3, ... )
        local lap_time     = select( 4, ... )
        local lap_time_cur = select( 5, ... )
        
        if participant:GetDriver() ~= LocalPlayer() then return end
        
        UV_UI.racing.underground.states.FrozenTime = true
        UV_UI.racing.underground.states.FrozenTimeValue = lap_time
        
        if timer.Exists( "_UG_TIME_FROZEN_DELAY" ) then timer.Remove( "_UG_TIME_FROZEN_DELAY" ) end
        timer.Create("_UG_TIME_FROZEN_DELAY", 3, 1, function()
            UV_UI.racing.underground.states.FrozenTime = false
        end)
    end
}

local function underground_racing_main( ... )
    local w = ScrW()
    local h = ScrH()
    
    local my_vehicle = select(1, ...)
    local my_array = select(2, ...)
    local string_array = select(3, ...)
    
    local racer_count = #string_array
    local lang = language.GetPhrase
    
    local checkpoint_count = #my_array["Checkpoints"]
    
    ------------------------------------
    
    -- Timer
    surface.SetDrawColor(0, 0, 0, 200)
    surface.DrawRect(w * 0.02, h * 0.175, w * 0.175, h * 0.0225)
    draw.DrawText(
    "#uv.race.hud.time.ug",
    "UVFont4",
    w * 0.022,
    h * 0.175,
    Color(255, 255, 255),
    TEXT_ALIGN_LEFT)
    
    local current_time = nil 
    
    if UV_UI.racing.underground.states.FrozenTime then
        current_time = UVDisplayTimeRace( UV_UI.racing.underground.states.FrozenTimeValue )
    elseif not my_array.LastLapTime then
        current_time = UVDisplayTimeRace( (UVHUDRaceInfo.Info.Started and (CurTime() - UVHUDRaceInfo.Info.Time)) or 0 )
    else
        current_time = UVDisplayTimeRace( CurTime() - my_array.LastLapCurTime )
    end
    
    draw.DrawText(
    current_time or UVDisplayTimeRace( 0 ),
    "UVFont4",
    w * 0.1925,
    h * 0.175,
    Color(255, 255, 255),
    TEXT_ALIGN_RIGHT)
    
    surface.SetDrawColor(0, 0, 0, 200)
    surface.DrawRect(w * 0.02, h * 0.2, w * 0.175, h * 0.0225)
    draw.DrawText(
    "#uv.race.hud.best.ug",
    "UVFont4",
    w * 0.022,
    h * 0.2,
    Color(255, 255, 255),
    TEXT_ALIGN_LEFT)
    
    draw.DrawText(
    UVDisplayTimeRace(my_array.BestLapTime or 0),
    "UVFont4",
    w * 0.1925,
    h * 0.2,
    Color(255, 255, 255),
    TEXT_ALIGN_RIGHT)
    
    -- Best Time
    -- surface.SetDrawColor(0, 0, 0, 200)
    -- surface.DrawRect(w * 0.02, h * 0.2, w * 0.175, h * 0.0225)
    -- draw.DrawText(
    -- "#uv.race.hud.best.ug",
    -- "UVFont4",
    -- w * 0.022,
    -- h * 0.2,
    -- Color(255, 255, 255),
    -- TEXT_ALIGN_LEFT
    -- )
    
    -- draw.DrawText(
    -- Carbon_FormatRaceTime(UVHUDBestLapTime) or "0:00.00",
    -- "UVFont4",
    -- w * 0.1925,
    -- h * 0.2,
    -- Color(255, 255, 255),
    -- TEXT_ALIGN_RIGHT
    -- )
    
    -- Lap & Checkpoint Counter
    surface.SetDrawColor(0, 0, 0, 200)
    surface.DrawRect(w * 0.02, h * 0.075, w * 0.175, h * 0.095)
    
    -- if UVHUDRaceInfo.Info.Laps > 1 then
    draw.DrawText(
    "#uv.race.hud.lap.ug",
    "UVFont5",
    w * 0.1,
    h * 0.125,
    Color(125, 125, 255),
    TEXT_ALIGN_LEFT) -- Lap Counter
    draw.DrawText(
    my_array.Lap,
    "UVFont3Big",
    w * 0.1,
    h * 0.0675,
    Color(255, 255, 255),
    TEXT_ALIGN_RIGHT) -- Lap Counter
    draw.DrawText(
    "/ " .. UVHUDRaceInfo.Info.Laps,
    "UVFont3",
    w * 0.1025,
    h * 0.08,
    Color(125, 125, 255),
    TEXT_ALIGN_LEFT) -- Lap Counter
    -- else
    -- draw.DrawText(
    -- "#uv.race.hud.complete",
    -- "UVFont5UI",
    -- w * 0.805,
    -- h * 0.1575,
    -- Color(255, 255, 255),
    -- TEXT_ALIGN_LEFT
    -- )
    -- draw.DrawText(
    -- math.floor(((checkpoint_count / GetGlobalInt("uvrace_checkpoints")) * 100)) .. "%",
    -- "UVFont5",
    -- w * 0.97,
    -- h * 0.1575,
    -- Color(255, 255, 255),
    -- TEXT_ALIGN_RIGHT
    -- )
    -- end
    
    local racer_count = #string_array
    local lang = language.GetPhrase
    
    -- Position Counter
	surface.SetDrawColor(0, 0, 0, 200)
	surface.DrawRect(w * 0.8, h * 0.075, w * 0.175, h * 0.105)
	
	draw.DrawText(
	UVHUDRaceCurrentPos,
	"UVFont3Big",
	w * 0.88,
	h * 0.0675,
	Color(255, 255, 255),
	TEXT_ALIGN_RIGHT) -- Upper, Your Position
	draw.DrawText(
	lang("uv.race.pos." .. UVHUDRaceCurrentPos),
	"UVFont5",
	w * 0.8825,
	h * 0.08,
	Color(255, 255, 255),
	TEXT_ALIGN_LEFT) -- Upper, Your Position Suffix
	draw.DrawText(
	"/" .. UVHUDRaceCurrentParticipants,
	"UVFont5",
	w * 0.88,
	h * 0.12,
	Color(125, 125, 255),
	TEXT_ALIGN_LEFT) -- Lower, Total Positions
    
    -- Racer List
    local alt = math.floor(CurTime() / 5) % 2 == 1 -- toggles every 5 seconds
    for i = 1, racer_count, 1 do
        --if racer_count == 1 then return end
        local entry = string_array[i]
        
        local racer_name = entry[1]
        local is_local_player = entry[2]
        local mode = entry[3]
        local diff = entry[4]
        -- local racercount = i * (racer_count > 8 and w*0.0135 or w*0.0115)
        local racercount = i * w * 0.0155
        -- local text = alt and (entry[3] .. "  " .. i) or (entry[2] .. "  " .. i)
        
        local Strings = {
            ["Time"] = "%s",
            ["Lap"] = lang("uv.race.suffix.lap"),
            -- ["Laps"] = lang("uv.race.suffix.laps"),
            ["Finished"] = lang("uv.race.suffix.finished"),
            ["Disqualified"] = lang("uv.race.suffix.dnf"),
            ["Busted"] = lang("uv.race.suffix.busted"),
        }
        
        local status_text = "-----"
        
        if entry[3] then
            local status_string = Strings[entry[3]]
            
            if status_string then
                local args = {}
                
                if entry[4] then
                    local num = tonumber(entry[4])
                    num =
                    ((num > 0 and "+") or "-") ..
                    string.format((entry[3] == "Lap" and "%s") or "%.2f", math.abs(num))
                    
                    table.insert(args, num)
                end
                
                status_text = #args <= 0 and status_string or string.format(status_string, unpack(args))
            end
        end
        
        local color = nil
        
        if is_local_player then
            color = Colors.MW_Others
            surface.SetDrawColor(150, 150, 255, 200)
        elseif entry[3] == "Disqualified" or entry[3] == "Busted" then
            color = Colors.MW_Disqualified
            surface.SetDrawColor(0, 0, 0, 200)
        else
            color = Colors.MW_Others
            surface.SetDrawColor(0, 0, 0, 200)
        end
        
        local text = alt and (status_text) or (racer_name)
        
        -- surface.SetDrawColor(0, 0, 0, 200)
        draw.NoTexture()
        surface.DrawRect(w * 0.82, h * 0.16 + racercount, w * 0.155, h * 0.025)
        
        surface.SetDrawColor(0, 0, 0, 200)
        draw.NoTexture()
        surface.DrawRect(w * 0.8, h * 0.16 + racercount, w * 0.0175, h * 0.025)
        
        draw.DrawText(i .. ":", "UVFont4", w * 0.8075, (h * 0.16) + racercount, color, TEXT_ALIGN_CENTER)
        draw.DrawText(text, "UVFont4", w * 0.97, (h * 0.16) + racercount, color, TEXT_ALIGN_RIGHT)
    end
end

UV_UI.racing.underground.main = underground_racing_main

-- Underground 2

UV_UI.racing.underground2 = {}
UV_UI.pursuit.underground2 = {}

UV_UI.racing.underground2.states = {
    FrozenTime = false,
    FrozenTimeValue = 0
}

UV_UI.racing.underground2.events = {
    onLapComplete = function( ... )
        local participant  = select( 1, ... )
        local new_lap      = select( 2, ... )
        local old_lap      = select( 3, ... )
        local lap_time     = select( 4, ... )
        local lap_time_cur = select( 5, ... )
        
        if participant:GetDriver() ~= LocalPlayer() then return end
        
        UV_UI.racing.underground2.states.FrozenTime = true
        UV_UI.racing.underground2.states.FrozenTimeValue = lap_time
        
        if timer.Exists( "_UG_TIME_FROZEN_DELAY" ) then timer.Remove( "_UG_TIME_FROZEN_DELAY" ) end
        timer.Create("_UG_TIME_FROZEN_DELAY", 3, 1, function()
            UV_UI.racing.underground2.states.FrozenTime = false
        end)
    end
}

local function underground2_racing_main( ... )
    local w = ScrW()
    local h = ScrH()
    
    local my_vehicle = select(1, ...)
    local my_array = select(2, ...)
    local string_array = select(3, ...)
    
    local racer_count = #string_array
    local lang = language.GetPhrase
    
    local checkpoint_count = #my_array["Checkpoints"]
    
    ------------------------------------
    
    -- Timer
    surface.SetDrawColor(0, 0, 0, 125)
    surface.DrawRect(w * 0.72, h * 0.375, w * 0.255, h * 0.03)
    
    draw.DrawText(
    "#uv.race.orig.time",
    "UVFont5UI",
    w * 0.722,
    h * 0.371,
    Color(255, 255, 255),
    TEXT_ALIGN_LEFT)
    
    local current_time = nil 
    
    if UV_UI.racing.underground2.states.FrozenTime then
        current_time = Carbon_FormatRaceTime( UV_UI.racing.underground2.states.FrozenTimeValue )
    elseif not my_array.LastLapTime then
        current_time = Carbon_FormatRaceTime( (UVHUDRaceInfo.Info.Started and (CurTime() - UVHUDRaceInfo.Info.Time)) or 0 )
    else
        current_time = Carbon_FormatRaceTime( CurTime() - my_array.LastLapCurTime )
    end
    
    draw.DrawText(
    current_time,
    "UVFont5UI",
    w * 0.97,
    h * 0.371,
    Color(255, 255, 255),
    TEXT_ALIGN_RIGHT)
    
    -- Lap & Checkpoint Counter
    surface.SetDrawColor(0, 0, 0, 125)
    surface.DrawRect(w * 0.72, h * 0.2075, w * 0.255, h * 0.05)
    
    if UVHUDRaceInfo.Info.Laps > 1 then
        draw.DrawText(
        "#uv.race.hud.lap.ug",
        "UVFont5",
        w * 0.722,
        h * 0.2075,
        Color(255, 255, 255),
        TEXT_ALIGN_LEFT) -- Lap Counter
        draw.DrawText(
        my_array.Lap .. "/" .. UVHUDRaceInfo.Info.Laps,
        "UVFont5",
        w * 0.97,
        h * 0.2075,
        Color(255, 255, 255),
        TEXT_ALIGN_RIGHT) -- Lap Counter
    else
        draw.DrawText(
        "#uv.race.hud.complete.ug2",
        "UVFont",
        w * 0.722,
        h * 0.2075,
        Color(255, 255, 255),
        TEXT_ALIGN_LEFT)
        draw.DrawText(
        math.floor(((checkpoint_count / GetGlobalInt("uvrace_checkpoints")) * 100)) .. "%",
        "UVFont",
        w * 0.97,
        h * 0.2075,
        Color(255, 255, 255),
        TEXT_ALIGN_RIGHT)
    end
    
    local racer_count = #string_array
    
    -- Position Counter
	surface.SetDrawColor(0, 0, 0, 200)
	surface.DrawRect(w * 0.72, h * 0.1, w * 0.255, h * 0.105)
	
	draw.NoTexture()
	surface.SetDrawColor(255, 255, 255, 255)
	surface.DrawTexturedRectRotated(w * 0.825, h * 0.15, w * 0.05, h * 0.005, 70) -- Divider
	
	draw.DrawText(
	UVHUDRaceCurrentPos,
	"UVFont3Big",
	w * 0.785,
	h * 0.095,
	Color(255, 255, 255),
	TEXT_ALIGN_RIGHT) -- Upper, Your Position
	draw.DrawText(
	lang("uv.race.pos." .. UVHUDRaceCurrentPos),
	"UVFont",
	w * 0.785,
	h * 0.15,
	Color(255, 255, 255),
	TEXT_ALIGN_LEFT) -- Upper, Your Position
	draw.DrawText(
	UVHUDRaceCurrentParticipants,
	"UVFont3Big",
	w * 0.835,
	h * 0.095,
	Color(255, 255, 255),
	TEXT_ALIGN_LEFT) -- Lower, Total Positions
    
    -- Racer List
    local alt = math.floor(CurTime() / 5) % 2 == 1 -- toggles every 5 seconds
    for i = 1, math.Clamp(racer_count, 1, 4), 1 do
        --if racer_count == 1 then return end
        local entry = string_array[i]
        
        local racer_name = entry[1]
        local is_local_player = entry[2]
        local mode = entry[3]
        local diff = entry[4]
        -- local racercount = i * (racer_count > 8 and w*0.0135 or w*0.0115)
        local racercount = i * w * 0.0155
        -- local text = alt and (entry[3] .. "  " .. i) or (entry[2] .. "  " .. i)
        
        local Strings = {
            ["Time"] = "%s",
            ["Lap"] = lang("uv.race.suffix.lap"),
            -- ["Laps"] = lang("uv.race.suffix.laps"),
            ["Finished"] = lang("uv.race.suffix.finished"),
            ["Disqualified"] = lang("uv.race.suffix.dnf"),
            ["Busted"] = lang("uv.race.suffix.busted"),
        }
        
        local status_text = "-----"
        
        if entry[3] then
            local status_string = Strings[entry[3]]
            
            if status_string then
                local args = {}
                
                if entry[4] then
                    local num = tonumber(entry[4])
                    num =
                    ((num > 0 and "+") or "-") ..
                    string.format((entry[3] == "Lap" and "%s") or "%.2f", math.abs(num))
                    
                    table.insert(args, num)
                end
                
                status_text = #args <= 0 and status_string or string.format(status_string, unpack(args))
            end
        end
        
        local color = nil
        
        if is_local_player then
            color = Color(200, 255, 200)
            surface.SetDrawColor(0, 0, 0, 200)
        elseif entry[3] == "Disqualified" or entry[3] == "Busted" then
            color = Colors.MW_Disqualified
            surface.SetDrawColor(0, 0, 0, 125)
        else
            color = Colors.MW_Others
            surface.SetDrawColor(0, 0, 0, 125)
        end
        
        local text = alt and (status_text) or (racer_name)
        
        -- surface.SetDrawColor(0, 0, 0, 200)
        draw.NoTexture()
        surface.DrawRect(w * 0.74, h * 0.235 + racercount, w * 0.235, h * 0.025)
        
        surface.SetDrawColor(0, 0, 0, 125)
        draw.NoTexture()
        surface.DrawRect(w * 0.72, h * 0.235 + racercount, w * 0.0175, h * 0.025)
        
        draw.DrawText(i .. ":", "UVFont4", w * 0.725, (h * 0.235) + racercount, Color(255, 255, 255), TEXT_ALIGN_LEFT)
        draw.DrawText(text, "UVFont4", w * 0.97, (h * 0.235) + racercount, color, TEXT_ALIGN_RIGHT)
    end
end

UV_UI.racing.underground2.main = underground2_racing_main

-- Hooks

-- Only used by pursuits for the time being ( underground current/best time and lap display made me change my mind ;) )
local function onEvent( type, event, ... )
    -- local data_type = select( 1, ... )
    -- local data_name = select( 2, ... )
    -- local new_data = select( 3, ... )
    -- local old_data = select( 4, ... )
    
    --if type == 'pursuit' then
    -- if new_data == old_data then return end
    
    local ui_type = nil
    
    if type == 'racing' then
        ui_type = UVHUDTypeRacing:GetString()
    else
        ui_type = UVHUDTypePursuit:GetString()
    end
    
    local event = UV_UI[type] and UV_UI[type][ui_type] and UV_UI[type][ui_type].events and UV_UI[type][ui_type].events[event]
    if event then event ( ... ) end
    --end
end

hook.Add( "UIEventHook", "UI_Event", onEvent )