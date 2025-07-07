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
    
    ["GLOW_ICON"] = Material("unitvehicles/icons/CIRCLE_GLOW_LIGHT.png"),
    ["UNITS_DAMAGED"] = Material("unitvehicles/icons/COPS_DAMAGED_ICON.png"),
    ["UNITS_DISABLED"] = Material("unitvehicles/icons/COPS_TAKENOUT_ICON.png"),
    ["UNITS"] = Material("unitvehicles/icons/COPS_ICON.png"),
    ["HEAT"] = Material("unitvehicles/icons/HEAT_ICON.png"),
    ["CLOCK"] = Material("unitvehicles/icons/TIMER_ICON.png"),
    ["CLOCK_BG"] = Material("unitvehicles/icons/TIMER_ICON_BG.png", "smooth mips"),
    ["CHECK"] = Material("unitvehicles/icons/MINIMAP_ICON_CIRCUIT.png"),
    ["RESULTCOP"] = Material("unitvehicles/icons/(9)T_UI_PlayerCop_Large_Icon.png"),
    ["RESULTRACE"] = Material("unitvehicles/icons/INGAME_ICON_LEADERBOARD.png"),
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
    ["TAKEDOWN_CIRCLE_CARBON"] = Material("unitvehicles/icons_carbon/FULL_CIRCLE.png"),
    ["TAKEDOWN_RING_CARBON"] = Material("unitvehicles/icons_carbon/FULL_CIRCLE_RING.png"),
	
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
    
    ["BG_BIG_CARBON"] = Material("unitvehicles/hud_carbon/NFSC_BG_BIG.png"),
    
    -- Undercover
    ["ARREST_BG_UC"] = Material("unitvehicles/hud_undercover/BUSTED_HEADER.png"),
    ["ARREST_LIGHT_UC"] = Material("unitvehicles/hud_undercover/BUSTED_COPLIGHT_BG.png"),
    
    ["UNITS_DISABLED_UC"] = Material("unitvehicles/icons_undercover/HUD_COP_TAKEDOWN_ICON.png"),
    ["CTS_UC"] = Material("unitvehicles/icons_undercover/HUD_CTS_ICON.png"),
    
    ["BUSTED_ICON_UC"] = Material("unitvehicles/icons_undercover/BUST_COP_ICON.png", "smooth mips"),
    ["BUSTED_ICON_UC_GLOW"] = Material("unitvehicles/icons_undercover/BUSTED_ICON_GLOW.png", "smooth mips"),
    ["EVADE_ICON_UC"] = Material("unitvehicles/icons_undercover/EVADE_CAR_ICON.png", "smooth mips"),
    ["EVADE_ICON_UC_GLOW"] = Material("unitvehicles/icons_undercover/EVADE_ICON_GLOW.png", "smooth mips"),
	
	-- Underground 2
    ["RACE_BG_UPPER_UG2"] = Material("unitvehicles/hud_underground2/3RDPERSON_BOXCORNER.png"),
    ["RACE_BG_LAP_UG2"] = Material("unitvehicles/hud_underground2/3RDPERSON_BOXLAPS.png"),
    ["RACE_BG_TIME_UG2"] = Material("unitvehicles/hud_underground2/3RDPERSON_BOXTIME.png"),
    ["RACE_BG_TIME_UG2_ALT"] = Material("unitvehicles/hud_underground2/3RDPERSON_BOXTIME2.png"),
	
    ["RESULTS_UG2_BG"] = Material("unitvehicles/hud_underground2/results_bg_bg.png"),
    ["RESULTS_UG2_SHINE"] = Material("unitvehicles/hud_underground2/results_bg_shine.png"),
    ["RESULTS_UG2_LP"] = Material("unitvehicles/hud_underground2/results_bg_lp.png"),
    ["RESULTS_UG2_BUTTON"] = Material("unitvehicles/hud_underground2/UI_PC_GENERIC_BUTTON.png"),
		
	-- ProStreet
    ["RESULTS_PS_CURVES"] = Material("unitvehicles/icons_prostreet/curves.png"),
    ["RESULTS_PS_HUB"] = Material("unitvehicles/icons_prostreet/hub_44.png"),
    ["RESULTS_PS_WING"] = Material("unitvehicles/icons_prostreet/flixfx_wing.png"),
    ["RESULTS_PS_WING_INV"] = Material("unitvehicles/icons_prostreet/flixfx_wing_inv.png"),
    ["RESULTS_PS_SP8"] = Material("unitvehicles/icons_prostreet/flixfx_sp8.png"),
	
}

UV_UI_Events = {
    ['Wrecks'] = 'onUnitWreck',
    ['Deploys'] = 'onUnitDeploy',
    ['Tags'] = 'onUnitTag',
    ['ResourcePoints'] = 'onResourceChange',
    ['UnitsChasing'] = 'onChasingUnitsChange',
    ['Heat'] = 'onHeatLevelUpdate',
}

if CLIENT then
	surface.CreateFont("UVFont", {
		font = "Arial",
		size = (math.Round(ScrH()*0.0462962963)),
		weight = 500,
		italic = true,
	})
	
	surface.CreateFont("UVFont-Shadow", {
		font = "Arial",
		size = (math.Round(ScrH()*0.0462962963)),
		weight = 500,
		italic = true,
		shadow = true
	})
	
	surface.CreateFont("UVFont-Smaller", {
		font = "Arial",
		size = (math.Round(ScrH()*0.0425)),
		weight = 500,
		italic = true,
	})
	
	surface.CreateFont("UVFont-Bolder", {
		font = "Arial",
		size = (math.Round(ScrH()*0.0425)),
		weight = 1000,
		italic = false,
		shadow = true
	})
	
	surface.CreateFont("UVFont2", {
		font = "Arial",
		size = (math.Round(ScrH()*0.0462962963)),
		weight = 500,
	})
	
	surface.CreateFont("UVFont3", {
		font = "Arial",
		size = (math.Round(ScrH()*0.0462962963)),
		weight = 500,
		shadow = true,
	})
	
	surface.CreateFont("UVFont3Big", {
		font = "Arial",
		size = (math.Round(ScrH()*0.085)),
		weight = 500,
		-- italic = true,
	})
		
	surface.CreateFont("UVFont3Bigger", {
		font = "Arial",
		size = (math.Round(ScrH()*0.12)),
		weight = 500,
		-- italic = true,
	})
	
	surface.CreateFont("UVFont4", {
		font = "Arial",
		size = (math.Round(ScrH()*0.02314814815)),
		weight = 1100,
		shadow = true,
	})
	
	surface.CreateFont("UVCarbonFont", {
		font = "HelveticaNeue LT 57 Cn",
		size = (math.Round(ScrH()*0.043)),
		shadow = true,
		weight = 1000,
	})
		
	surface.CreateFont("UVCarbonFont-Smaller", {
		font = "HelveticaNeue LT 57 Cn",
		size = (math.Round(ScrH()*0.035)),
		shadow = true,
		weight = 1000,
	})
	
	surface.CreateFont("UVUndercoverAccentFont", {
		font = "HelveticaNeue LT 57 Cn",
		size = (math.Round(ScrH()*0.033)),
		shadow = true,
		weight = 1000,
	})
	
	surface.CreateFont("UVUndercoverLeaderboardFont", {
		font = "HelveticaNeue LT 57 Cn",
		size = (math.Round(ScrH()*0.03)),
		shadow = true,
		weight = 1000,
	})
	
	surface.CreateFont("UVUndercoverWhiteFont", {
		font = "Aquarius Six",
		size = (math.Round(ScrH()*0.047)),
		shadow = true,
		weight = 1,
	})
	
	surface.CreateFont("UVCarbonLeaderboardFont", {
		font = "HelveticaNeue LT 57 Cn",
		size = (math.Round(ScrH()*0.02314814815)),
		shadow = true,
		weight = 1000,
	})
	
	surface.CreateFont("UVFont5", {
		font = "EurostileBold",
		size = (math.Round(ScrH()*0.043)),
		weight = 500,
	})
	
	surface.CreateFont("UVFont5UI", {
		font = "EurostileBold",
		size = (math.Round(ScrH()*0.035)),
		weight = 500,
	})
	
	surface.CreateFont("UVFont5UI-BottomBar", {
		font = "EurostileBold",
		size = (math.Round(ScrH()*0.041)),
		weight = 500,
	})
	
	surface.CreateFont("UVFont5WeightShadow", {
		font = "EurostileBold",
		size = (math.Round(ScrH()*0.043)),
		weight = 500,
		shadow = true
	})
	
	surface.CreateFont("UVFont5Shadow", {
		font = "EurostileBold",
		size = (math.Round(ScrH()*0.03)),
		weight = 350,
		shadow = true
	})
	
	surface.CreateFont("UVMostWantedLeaderboardFont", {
		font = "EurostileBold",
		size = (math.Round(ScrH()*0.02314814815)),
		weight = 1000,
		shadow = true
	})
	
	surface.CreateFont("UVFont5ShadowBig", {
		font = "EurostileBold",
		size = (math.Round(ScrH()*0.1)),
		weight = 500,
		shadow = true,
	})
end

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

function UV_FormatRaceEndTime(seconds)
	if not seconds then return nil end
	if type(seconds) == "string" then
		return seconds
	elseif type(seconds) == "number" then
		local minutes = math.floor(seconds / 60)
		local secs = seconds % 60
		return string.format("%d:%05.2f", minutes, secs)
	else
		return "NIL"
	end
end

UV_UI = {}

for _, v in pairs( {'racing', 'pursuit'} ) do
    UV_UI[v] = {}
end

-- Universal
function DrawIcon(material, x, y, height_ratio, color, args)
    local tex = material:GetTexture("$basetexture")

    if tex then
        local texW, texH = tex:Width(), tex:Height()
        local aspect = texW / texH

        local desiredHeight = ScrH() * height_ratio
        local desiredWidth = desiredHeight * aspect

        -- Center coords for DrawTexturedRectRotated
        local centerX = x
        local centerY = y

        if color then
            surface.SetDrawColor(color:Unpack())
        else
            surface.SetDrawColor(255, 255, 255)
        end

        surface.SetMaterial(material, args)

        -- Check if 'args' table contains 'rotation' key
        if args and args.rotation then
            surface.DrawTexturedRectRotated(centerX, centerY, desiredWidth, desiredHeight, args.rotation)
        else
            -- Adjust x,y for non-rotated draw (top-left corner)
            local drawX = x - desiredWidth / 2
            local drawY = y - desiredHeight / 2
            surface.DrawTexturedRect(drawX, drawY, desiredWidth, desiredHeight)
        end
    end
end

function UVRenderCommander(ent)
    local localPlayer = LocalPlayer()
    local box_color = Color(0, 161, 255)
    local lang = language.GetPhrase
    
    if IsValid(ent) then
        if !UVHUDDisplayPursuit then return end
        
        local callsign = lang("uv.unit.commander")
        local driver = UVGetDriver(ent)
		local notitext = "uv.unit.commander.noti"
        
        -- if driver and driver:IsPlayer() then
        if driver then
            callsign = driver:IsPlayer() and driver:GetName() or lang("uv.unit.commander")
			if not ent.lplayernotified then
				ent.lplayernotified = true
				if localPlayer == driver then
					notitext = "uv.unit.commander.noti.you"
                end
					if Glide then
						Glide.Notify( {
							text = "<color=61,183,255>" .. language.GetPhrase(notitext),
							icon = "unitvehicles/icons/MINIMAP_ICON_EVENT_RIVAL.png",
							lifetime = 5,
							immediate = true
						} )
					else
						chat.AddText(
						Color(0, 81, 161), "[Unit Vehicles] ",
						Color(61, 183, 255), language.GetPhrase(notitext) )
					end
                return
            end
        end
		
		if localPlayer == driver then return end
		
		-- Anchor point at vehicle origin (or lightly above)
		local anchorPos = ent:GetPos() + Vector(0, 0, 70) -- Light lift to target roof

		-- Convert to 2D screen space
		local screenPos = anchorPos:ToScreen()
		if not screenPos.visible then return end

		-- Fixed screen offset (so it doesn’t drift with distance)
		local textX = screenPos.x
		local textY = screenPos.y - 120 -- This is in pixels and stays consistent
		
        local w = ScrW()
        local h = ScrH()
        
        local dist = localPlayer:GetPos():Distance(ent:GetPos())
        local distInMeters = dist * 0.01905

        -- Distance in meters
        local fadeAlpha = 255
        local fadeDist = 200
        
        if distInMeters <= fadeDist then
            fadeAlpha = 255 * ((fadeDist - distInMeters) / 25)
        elseif distInMeters > fadeDist then
            fadeAlpha = 0
        end
        
        cam.Start2D()
        local bustdist = math.Round(distInMeters) .. " m"
        
        local cname = lang("uv.unit.commander")
        if IsValid(UVHUDCommander) then
            local driver = UVHUDCommander:GetDriver()
            if IsValid(driver) and driver:IsPlayer() then
                cname = driver:Nick()
            end
        end
        
        local rectlen = string.len(cname) + 2
        local rectxpos = textX - (w * (0.00375 * rectlen))
        local rectypos = textY + (w * 0.0125)
        
        surface.SetDrawColor( 0, 161, 255, fadeAlpha )
        surface.DrawRect( rectxpos - 3, rectypos - 2, w * 0.002, h*0.054) -- Left
        surface.DrawRect( rectxpos + (w * (0.0075 * rectlen) - 1), rectypos - 2, w * 0.002, h*0.054) -- Right
        surface.DrawRect( rectxpos, rectypos - 2, (w * (0.0075 * rectlen)), h*0.002) -- Up
        surface.DrawRect( rectxpos, rectypos + h*0.05, (w * (0.0075 * rectlen)), h*0.002) -- Down
        
        surface.SetMaterial(UVMaterials["ARROW_CARBON"])
        surface.DrawTexturedRectRotated( textX, textY + (w * 0.0475), w * 0.0075 + 5, h * 0.0175 + 5, -90)
        
        surface.SetDrawColor( 0, 0, 0, math.min(200, fadeAlpha) )
        surface.DrawRect( rectxpos, rectypos, (w * (0.0075 * rectlen)), h*0.05)

        draw.DrawText("\n" .. cname .. "\n" .. bustdist, "UVFont4", textX, textY, Color(255, 255, 255, fadeAlpha), TEXT_ALIGN_CENTER)
        cam.End2D()
    end
end

function UVRenderEnemySquare(ent)
    local localPlayer = LocalPlayer()
    local box_color = (!UVHUDCopMode and Color(255, 255, 255)) or Color( 255, 132, 0 )
    local blink = 255 * math.abs(math.sin(RealTime() * 4))
    local blink2 = 255 * math.abs(math.sin(RealTime() * 6))
    local blink3 = 255 * math.abs(math.sin(RealTime() * 8))
    
    local lang = language.GetPhrase
    
    local entbustedtimeleft = math.Round((BustedTimer:GetFloat()-(ent.uvbustingprogress or 0)),3)
    
    if ent.beingbusted then
        if (entbustedtimeleft > 2 and entbustedtimeleft < 3) then
            box_color = Color( 255, blink, blink)
        elseif entbustedtimeleft < 2 then
            box_color = Color( 255, blink2, blink2)
        elseif entbustedtimeleft < 1 then
            box_color = Color( 255, blink3, blink3)
        end
    end
    
	if IsValid(ent) then
		if not (UVHUDDisplayPursuit or UVHUDDisplayRacing) then return end

		if (UVHUDCopMode and UVHUDDisplayCooldown) or
		   (UVHUDCopMode and (tonumber(UVUnitsChasing) <= 0 or not ent.inunitview) and 
		   not ((not GetConVar("unitvehicle_unit_onecommanderevading"):GetBool()) and UVOneCommanderActive))
		then return end

		if UVHUDRaceInfo and UVHUDRaceInfo.Participants and UVHUDRaceInfo.Participants[ent] then
			local pdata = UVHUDRaceInfo.Participants[ent]
			if pdata.Finished or pdata.Disqualified or pdata.Busted then
				return
			end
		end
		
		local function GetRacerPositionForEntity(ent)
			if not UVHUDRaceInfo or not UVHUDRaceInfo.Participants then return nil end
			local sorted_table, string_array = UVFormLeaderboard(UVHUDRaceInfo.Participants)
			for i, entry in ipairs(string_array) do
				local participant_ent = nil
				if sorted_table and sorted_table[i] then
					participant_ent = sorted_table[i].vehicle
				end

				if participant_ent == ent then
					return i
				end
			end
			return nil
		end

		local enemycallsign = ent.racer or "Racer "..ent:EntIndex()
		local enemydriver = ent:GetDriver()
		local enemypos = "?"

		-- Prefer player name if valid
		if IsValid(enemydriver) and enemydriver:IsPlayer() then
			if localPlayer == enemydriver then return end
			enemycallsign = enemydriver:GetName()
		end

		-- Fallback: use name from leaderboard data
		if UVHUDRaceInfo and UVHUDRaceInfo.Participants then
			local racerInfo = UVHUDRaceInfo.Participants[ent]
			if racerInfo then
				enemypos = "#uv.race.pos.num." .. GetRacerPositionForEntity(ent)
				if racerInfo.Name then
					enemycallsign = racerInfo.Name
				end
			end
		end

		-- Anchor point at vehicle origin (or lightly above)
		local anchorPos = ent:GetPos() + Vector(0, 0, 70) -- Light lift to target roof

		-- Convert to 2D screen space
		local screenPos = anchorPos:ToScreen()
		if not screenPos.visible then return end

		-- Fixed screen offset (so it doesn’t drift with distance)
		local textX = screenPos.x
		local textY = screenPos.y - 120 -- This is in pixels and stays consistent

        local w = ScrW()
        local h = ScrH()
        
        -- Distance in meters
        local fadeAlpha = 255
        local fadeDist = 100

        local dist = localPlayer:GetPos():Distance(ent:GetPos())
        local distInMeters = dist * 0.01905
        
        if not UVHUDCopMode then
            if distInMeters <= fadeDist then
                fadeAlpha = 255 * ((fadeDist - distInMeters) / 25)
            elseif distInMeters > fadeDist then
                fadeAlpha = 0
            end
        end
		
		-- Edge fade (screen position based)
		local edgeFadeAlpha = 255

		local edgeStartX = w * 0.2
		local edgeEndX = w * 0.8
		local edgeStartY = h * 0.2
		local edgeEndY = h * 0.8

		-- Horizontal fade
		if textX < w * 0.05 or textX > w * 0.95 then
			edgeFadeAlpha = 0
		elseif textX < edgeStartX then
			edgeFadeAlpha = 255 * ((textX - w * 0.05) / (edgeStartX - w * 0.05))
		elseif textX > edgeEndX then
			edgeFadeAlpha = 255 * ((w * 0.95 - textX) / (w * 0.95 - edgeEndX))
		end

		-- Vertical fade
		if textY < h * 0.05 or textY > h * 0.95 then
			edgeFadeAlpha = math.min(edgeFadeAlpha, 0)
		elseif textY < edgeStartY then
			edgeFadeAlpha = math.min(edgeFadeAlpha, 255 * ((textY - h * 0.05) / (edgeStartY - h * 0.05)))
		elseif textY > edgeEndY then
			edgeFadeAlpha = math.min(edgeFadeAlpha, 255 * ((h * 0.95 - textY) / (h * 0.95 - edgeEndY)))
		end

		-- Combine with distance fade
		fadeAlpha = math.min(fadeAlpha, edgeFadeAlpha)

		local xheight = 0
		-- if !UVHUDCopMode then xheight = h * 0 end

		-- if #enemycallsign > 20 then -- If too long
			-- enemycallsign = string.sub(enemycallsign, 1, 20 - 3) .. "..."
		-- end

        cam.Start2D()
			local pos = ent:GetPos() + Vector(0, 0, 80)
			local bustpro = math.Clamp(math.floor((((ent.uvbustingprogress or 0) / BustedTimer:GetInt()) * 100) + .5), 0, 100)
			local bustdist = math.Round(distInMeters) .. " m"
			
			local rectlen = string.len(enemycallsign)
			local rectxpos = textX - (w * (0.00375 * rectlen))
			local rectypos = textY + (w * 0.01)
			
			surface.SetDrawColor( box_color.r, box_color.g, box_color.b, fadeAlpha )
			surface.DrawRect( rectxpos - 3, rectypos - 2, w * 0.002, h*0.054 + xheight) -- Left
			surface.DrawRect( rectxpos + (w * (0.0075 * rectlen) - 1), rectypos - 2, w * 0.002, h*0.054 + xheight) -- Right
			surface.DrawRect( rectxpos, rectypos - 2, (w * (0.0075 * rectlen)), h*0.002) -- Up
			surface.DrawRect( rectxpos, rectypos + h*0.05 + xheight, (w * (0.0075 * rectlen)), h*0.002) -- Down
			
			surface.SetMaterial(UVMaterials["ARROW_CARBON"])
			surface.DrawTexturedRectRotated( textX, textY + (w * 0.0475) + xheight, w * 0.0075 + 5, h * 0.0175 + 5, -90)
			
			surface.SetDrawColor( 0, 0, 0, math.min(200, fadeAlpha) )
			surface.DrawRect( rectxpos, rectypos, (w * (0.0075 * rectlen)), h*0.05 + xheight)
			
			if UVHUDCopMode then
				draw.DrawText(enemycallsign, "UVFont4", textX, textY + (h * 0.02), Color(255, 255, 255, fadeAlpha), TEXT_ALIGN_CENTER)
				draw.DrawText(bustdist, "UVFont4", textX, textY + (h * 0.04), Color(255, 255, 255, fadeAlpha), TEXT_ALIGN_CENTER)
			else
				draw.DrawText(enemycallsign, "UVFont4", textX, textY + (h * 0.02), Color(255, 255, 255, fadeAlpha), TEXT_ALIGN_CENTER)
				draw.DrawText(enemypos, "UVFont4", textX, textY + (h * 0.04), Color(255, 255, 255, fadeAlpha), TEXT_ALIGN_CENTER)
			end
			
			draw.DrawText((ent.beingbusted and string.format(lang("uv.chase.busting.other"), bustpro) or "") , "UVFont4", textX, textY - (h * 0.01), Color(box_color.r, box_color.g, box_color.b, fadeAlpha), TEXT_ALIGN_CENTER)
        cam.End2D()
    end
end

local function mw_noti_draw(text, font, x, y, color)
    surface.SetFont(font)
    local lines = string.Explode("\n", text)
    
    local lH = {}
    local mW = 0
    local tH = 0
    
    for _, line in ipairs(lines) do
        local w, h = surface.GetTextSize(line)
        table.insert( lH, h )
        mW = math.max( mW, w )
        tH = tH + h
    end
    
    local currentY = y - tH/2
    
    for i, line in ipairs(lines) do
        local w,h = surface.GetTextSize(line)
        draw.SimpleText(line, font, x - w/2, currentY, Color(color.r, color.g, color.b, color.a), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        currentY = currentY + h
    end
end

local function carbon_noti_draw(text, font, font2, x, y, color, color2)
    surface.SetFont(font)
    local lines = string.Explode("\n", text)
    
    local lH = {}
    local mW = 0
    local tH = 0
    
    for _, line in ipairs(lines) do
        local w, h = surface.GetTextSize(line)
        table.insert( lH, h )
        mW = math.max( mW, w )
        tH = tH + h
    end
    
    local currentY = y - tH/2
    
    for i, line in ipairs(lines) do
	    local drawFont = font
        local drawColor = color

        -- Customize second line
        if i == 2 then
            drawFont = font2
            drawColor = color2
        end

        local w,h = surface.GetTextSize(line)
        draw.SimpleText(line, drawFont, x, currentY, drawColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        currentY = currentY + h
    end
end

local function DrawScaledCenteredTextLines(text, font, x, y, color, scale)
    surface.SetFont(font)
    local lines = string.Explode("\n", text)
    local totalHeight = 0
    local lineHeights, lineWidths = {}, {}

    for _, line in ipairs(lines) do
        local w, h = surface.GetTextSize(line)
        table.insert(lineWidths, w)
        table.insert(lineHeights, h)
        totalHeight = totalHeight + h
    end

    local currentY = y - totalHeight * scale / 2

    for i, line in ipairs(lines) do
        local w, h = lineWidths[i], lineHeights[i]
        local mat = Matrix()
        mat:Scale(Vector(scale, scale, 1))
        mat:SetTranslation(Vector(x - w / 2 * scale, currentY, 0))

        cam.PushModelMatrix(mat)
            draw.SimpleText(line, font, 0, 0, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        cam.PopModelMatrix()

        currentY = currentY + h * scale
    end
end

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
    
    if vehicle == NULL then
        UVHUDPursuitTech = nil
    else
        UVHUDPursuitTech = vehicle.PursuitTech or (IsValid(vehicle:GetParent()) and vehicle:GetParent().PursuitTech) or nil
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
                    return BindTextReplace[upperKeyName] or upperKeyName
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
	
    TakedownText = nil,
}

UV_UI.racing.carbon.states = {
    LapCompleteText = nil,
}

UV_UI.racing.carbon.events = {
    ShowResults = function(sortedRacers) -- Carbon
        if UVHUDDisplayRacing then return end
        if IsValid(ResultPanel) then ResultPanel:Remove() end
        
        local w = ScrW()
        local h = ScrH()
        
        --------------------------------------

        OK = vgui.Create("DButton", vgui.GetWorldPanel())
        OK:SetText("")
        OK:SetPos(w*0.2565, h*0.9)
        OK:SetSize(w*0.15, h*0.035)
        OK.Paint = function() end

        ResultPanel = vgui.Create("DPanel", vgui.GetWorldPanel())
        ResultPanel:Add(OK)
        ResultPanel:SetSize(w, h)
        -- ResultPanel:SetPos(0, 0)
        ResultPanel:SetMouseInputEnabled(true)
        ResultPanel:SetKeyboardInputEnabled(false)
        ResultPanel:SetZPos(32767)

        local targetY = 0
        local overshootY = h * 0.1  -- drops 10% below target before bouncing back
        local startY = -h           -- start fully above the screen
        
        ResultPanel:SetPos(0, startY)
        
        local animTime = 0.33
        local bounceTime = 0.1
        local startTime = CurTime()
        
        hook.Add("Think", "ResultPanelEntranceAnim", function()
            local elapsed = CurTime() - startTime
            
            if elapsed < animTime then
                if elapsed < animTime - bounceTime then
                    local frac = elapsed / (animTime - bounceTime)
                    local y = Lerp(frac, startY, overshootY)
                    ResultPanel:SetPos(0, y)
                else
                    local frac = (elapsed - (animTime - bounceTime)) / bounceTime
                    local y = Lerp(frac, overshootY, targetY)
                    ResultPanel:SetPos(0, y)
                end
            else
                ResultPanel:SetPos(0, targetY)
                hook.Remove("Think", "ResultPanelEntranceAnim")
            end
        end)
        
        local function AnimateAndRemovePanel(panel)
            if not IsValid(panel) then return end
            
            local startY = panel:GetY()
            local endY = ScrH()  -- off-screen below
            local animTime = 0.33
            local startTime = CurTime()
            
            -- Play sounds ONCE at start
            surface.PlaySound("uvui/carbon/openmenu.wav")
            surface.PlaySound("uvui/carbon/exitmenu.wav")
            
            -- Disable interactivity
            panel:SetMouseInputEnabled(false)
            gui.EnableScreenClicker(false)
			OK:SetEnabled(false)
            
            hook.Add("Think", "ResultPanelExitAnim", function()
                if not IsValid(panel) then
                    hook.Remove("Think", "ResultPanelExitAnim")
                    return
                end
                
                local elapsed = CurTime() - startTime
                if elapsed < animTime then
                    local frac = elapsed / animTime
                    local y = Lerp(frac, startY, endY)
                    panel:SetPos(0, y)
                else
                    panel:Remove()
                    hook.Remove("Think", "ResultPanelExitAnim")
                end
            end)
        end
        
        gui.EnableScreenClicker(true)

        local timetotal = 30
        local timestart = CurTime()
        local exitStarted = false -- prevent repeated trigger
        
        local finalTitle = "★" .. language.GetPhrase("uv.results.standings") .. "★"
        local charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!@#$%^&*()[]{}<>,./?|"
        local revealSpeed = 0.05
        local displayStart = CurTime()
        local scrambleSound
        local isScrambling = true
        local revealedChars = 0
        
        sound.Add({
            name = "UV.Carbon.Scramble",
            channel = CHAN_STATIC,
            volume = 1.0,
            level = 70,
            pitch = { 100 },
            sound = "uvui/carbon/textfold.wav"
        })
        
        -- Start reveal timer
        timer.Create("ScrambleTextUpdate", revealSpeed, #finalTitle, function()
            revealedChars = revealedChars + 1
            
            -- Start the loop sound
            if isScrambling and not scrambleSound then
                scrambleSound = CreateSound(LocalPlayer(), "UV.Carbon.Scramble")
                if scrambleSound then
                    scrambleSound:Play()
                end
            end
            
            -- Stop when done
            if revealedChars >= #finalTitle then
                isScrambling = false
                if scrambleSound then
                    scrambleSound:FadeOut(0.2)
                    scrambleSound = nil
                end
            end
        end)
        
        local entriesToShow = 13
        local scrollOffset = 0
        
        ResultPanel.OnMouseWheeled = function(self, delta)
            local maxOffset = math.max(0, #sortedRacers - entriesToShow)
            scrollOffset = math.Clamp(scrollOffset - delta, 0, maxOffset)
        end
        
        -- Data and labels
        local racersArray = {}
        
        for _, dict in pairs(sortedRacers) do
            table.insert(racersArray, dict)
        end
        
        table.sort(racersArray, function(a, b)
            local timeA = a.array and a.array.TotalTime
            local timeB = b.array and b.array.TotalTime
            
            -- Treat missing or non-numeric TotalTime as a large number (DNF)
            local tA = (type(timeA) == "number") and timeA or math.huge
            local tB = (type(timeB) == "number") and timeB or math.huge
            
            return tA < tB
        end)
        
        ResultPanel.Paint = function(self, w, h)
			local alttext = math.floor(CurTime() / 5) % 2 == 1
            local timeremaining = math.ceil(timetotal - (CurTime() - timestart))
            local lang = language.GetPhrase
            
            -- Main black BG
            surface.SetMaterial(UVMaterials['BG_BIG_CARBON'])
            surface.SetDrawColor( 0, 0, 0, 225 )
            surface.DrawTexturedRect( 0, 0, w, h)
            
            -- Upper Results Tab
            surface.SetDrawColor( 0, 0, 0, 200 )
            surface.DrawRect( w*0.25, h*0.185, w*0.5, h*0.075)
            
            surface.SetMaterial(UVMaterials['EOC_FRAME_CARBON'])
            surface.SetDrawColor(86, 214, 205)
            surface.DrawTexturedRect( w*0.26, h*0.17825, w*0.485, h*0.09)
            
            DrawIcon( UVMaterials['X_OUTER_CARBON'], w*0.255, h*0.215, 0.2, Color(0,0,0) ) -- Icon
            DrawIcon( Material("unitvehicles/hud_carbon/x_anim"), w*0.255, h*0.215, 0.2, Color(255,255,255) ) -- Animated Icon; TBD
            
            local timePassed = CurTime() - displayStart
            local charsToReveal = math.min(#finalTitle, math.floor(timePassed / revealSpeed))
            
            local animatedTitle = ""
            
            for i = 1, #finalTitle do
                if i <= charsToReveal then
                    animatedTitle = animatedTitle .. finalTitle:sub(i, i)
                else
                    local randIndex = math.random(#charset)
                    local randChar = charset:sub(randIndex, randIndex)
                    animatedTitle = animatedTitle .. randChar
                end
            end
            
            draw.DrawText(animatedTitle, "UVCarbonFont", w * 0.3, h * 0.2, Color(255, 255, 255), TEXT_ALIGN_LEFT)
            
            -- Next Lower, results subtext
            -- surface.SetMaterial(UVMaterials['BACKGROUND_BIGGER'])
            surface.SetDrawColor( 0, 0, 0, 235 )
            surface.DrawRect( w*0.25, h*0.3, w*0.5, h*0.03)
            
            draw.DrawText( "#uv.results.race.pos.caps", "UVCarbonLeaderboardFont", w*0.2565, h*0.3025, Color( 255, 255, 255), TEXT_ALIGN_LEFT )
            draw.DrawText( "#uv.results.race.name.caps", "UVCarbonLeaderboardFont", w*0.4, h*0.3025, Color( 255, 255, 255), TEXT_ALIGN_LEFT )
            draw.DrawText( "#uv.results.race.time.caps", "UVCarbonLeaderboardFont", w*0.74, h*0.3025, Color( 255, 255, 255), TEXT_ALIGN_RIGHT )
            
            -- Draw visible racer entries
            local startIndex = scrollOffset + 1
            local endIndex = math.min(startIndex + entriesToShow - 1, #sortedRacers)
            
            local rowYStart = h * 0.34
            local rowHeight = h * 0.035
            
            for i = startIndex, endIndex do
                local racer = racersArray[i]
                local y = rowYStart + ((i - startIndex) * rowHeight)
                
                local info = racer.array or racer  -- fallback if 'array' doesn't exist
                
                local name = info["Name"] or "Unknown"
                local totalTime = info["TotalTime"] and info["TotalTime"] or "#uv.race.suffix.dnf"
                
                if info["Busted"] then totalTime = "#uv.race.suffix.busted" end
                
                -- Background for zebra striping
                local bgAlpha = (i % 2 == 0) and 100 or 50
                surface.SetMaterial(UVMaterials['BACKGROUND_CARBON_FILLED'])
                surface.SetDrawColor(86, 214, 205, bgAlpha)
                surface.DrawTexturedRect(w * 0.25, y, w * 0.485, rowHeight)
                
                surface.SetMaterial(UVMaterials['ARROW_CARBON'])
                surface.DrawTexturedRect( w * 0.735, y, w * 0.015, rowHeight)
                
                draw.SimpleText(tostring(i), "UVCarbonLeaderboardFont", w * 0.2565, y + h * 0.0025, Color(255, 255, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText(name, "UVCarbonLeaderboardFont", w * 0.4, y + h * 0.0025, Color(255, 255, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText(UV_FormatRaceEndTime(totalTime), "UVCarbonLeaderboardFont", w * 0.74, y + h * 0.0025, Color(255, 255, 255), TEXT_ALIGN_RIGHT)
            end
            
            -- Time remaining and closing
            local conttext = "( " .. input.LookupBinding("+jump") .. " ) " .. lang("uv.results.continue")
            local conttextl = string.len(conttext)
            
            local autotext = string.format( language.GetPhrase("uv.results.autoclose"), math.max(0, timeremaining) )
            local autotextl = string.len(autotext)
            local blink = 255 * math.abs(math.sin(RealTime() * 8))
            
            surface.SetDrawColor( 150, 150, 150, 175 )
            
            surface.DrawRect( w*0.2565, h*0.9, (w*0.00575 * conttextl), h*0.035)
            draw.DrawText( conttext, "UVCarbonLeaderboardFont", w*0.2585, h*0.9025, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT )
            
            surface.DrawRect( w*0.26 +  (w*0.00575 * conttextl), h*0.9, (w*0.00575 * autotextl), h*0.035)
            draw.DrawText( autotext, "UVCarbonLeaderboardFont", w*0.2625 + (w*0.00575 * conttextl), h*0.9025, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT )
            
            if scrollOffset > 0 then
                draw.SimpleText("▲", "UVFont5UI", w * 0.5, h * 0.3, Color(255,255,255,blink), TEXT_ALIGN_CENTER)
            end
            
            if scrollOffset < #sortedRacers - entriesToShow then
                draw.SimpleText("▼", "UVFont5UI", w * 0.5, h * 0.79, Color(255,255,255,blink), TEXT_ALIGN_CENTER)
            end
            
            if not exitStarted and timeremaining < 1 then
                exitStarted = true
                hook.Remove("Think", "CheckJumpKeyForResults")
                AnimateAndRemovePanel(ResultPanel)
            end
            
        end
        
        function OK:DoClick() 
            hook.Remove("Think", "CheckJumpKeyForResults")
            AnimateAndRemovePanel(ResultPanel)
        end
        
        local wasJumping = false
        hook.Add("Think", "CheckJumpKeyForResults", function()
            local ply = LocalPlayer()
            if not IsValid(ply) then return end
            
            if ply:KeyDown(IN_JUMP) then
                if not wasJumping then
                    wasJumping = true
                    if IsValid(ResultPanel) then
                        AnimateAndRemovePanel(ResultPanel)
                        hook.Remove("Think", "CheckJumpKeyForDebrief")
                    end
                end
            else
                wasJumping = false
            end
        end)
    end,

    onRaceEnd = function( sortedRacers, stringArray )
        local triggerTime = CurTime()
        local duration = 10
		local glidetext = string.format( language.GetPhrase("uv.race.finished.viewstats"), '<color=0,162,255>'.. string.upper( input.GetKeyName( UVKeybindShowRaceResults:GetInt() ) ) ..'<color=255,255,255>')
		local glideicon = "unitvehicles/icons/INGAME_ICON_LEADERBOARD.png"
        
        -----------------------------------------

		if Glide then
			if not istable(sortedRacers) or #sortedRacers == 0 then
				glidetext = "#uv.race.finished.statserror"
				glideicon = "unitvehicles/icons/GENERIC_ALERT.png"
			end
				Glide.Notify({
					text = glidetext,
					lifetime = duration,
					immediate = true,
					icon = glideicon,
				}) 
		end
        
        hook.Add( "Think", "RaceResultDisplay", function()
            if CurTime() - triggerTime > duration then
                hook.Remove( 'Think', 'RaceResultDisplay' )
                return
            end
            
            if input.IsKeyDown( UVKeybindShowRaceResults:GetInt() ) and !gui.IsGameUIVisible() and vgui.GetKeyboardFocus() == nil then
                hook.Remove( 'Think', 'RaceResultDisplay' )
                UV_UI.racing.carbon.events.ShowResults(sortedRacers)
            end
        end)
    end,

onLapComplete = function( participant, new_lap, old_lap, lap_time, lap_time_cur, is_local_player, is_global_best )
	local name = UVHUDRaceInfo.Participants[participant] and UVHUDRaceInfo.Participants[participant].Name or "Unknown"

	if is_global_best then
		UV_UI.racing.carbon.states.LapCompleteText = string.format(language.GetPhrase("uv.race.fastest.laptime"), name, Carbon_FormatRaceTime( lap_time ) )
	else
		if is_local_player then
			UV_UI.racing.carbon.states.LapCompleteText = string.format(language.GetPhrase("uv.race.laptime.carbon"), Carbon_FormatRaceTime( lap_time ) )
		else
			return
		end
	end
		local SID = 0.35

		local carbon_noti_animState = {
			active = false,
			startTime = 0,
			slideInDuration = SID,
			holdDuration = 3,
			slideDownDuration = 0.25,
			upper = {
				startX = ScrW() * 0.25,
				centerX = ScrW() / 2,
				y = ScrH() * 0.35,
				slideDownEndY = ScrH() * 0.6,
			},
			lower = {
				startX = ScrW() * 0.75,
				centerX = ScrW() / 2,
				y = ScrH() * 0.385,
				slideDownEndY = ScrH() * 0.635,
			},
			ring = {
				scaleStart = 0.5,
				scaleEnd = 0.09,
				alphaStart = 15,
				alphaEnd = 150,
				scale = 0.2,
				alpha = 15,
				
				shrinkStart = 0,
				shrinkDuration = SID,
				disappearTime = 0.03,
				reappearDelay = SID + 0.03,
				expandStartTime = nil,
				expanded = false,
				visible = true
			},
			ringClone = {
				createdTime = nil,
				blinkInterval = 0.125,
				blinkCount = 0,
				maxBlinks = 2,
				scale = 0.085,
				scaleDuration = 0.6,
				targetScale = 0.07,
				alpha = 175,
				visible = true,
				fadeAfterBlinkStart = nil,
			},
			icon = {
			  scale = 0.06,
			  baseScale = 0.06,
			  overshootScale = 0.07,
			  alpha = 255,
			  ExpandDuration = 0.125,
			},
			circle = {
				scaleStart = 0.4,
				scaleEnd = 0.0575,
				alphaStart = 15,
				alphaEnd = 100,

				scale = 0.2,
				alpha = 15,
				rotation = 0,

				spinStartTime = nil,
				spinDuration = 5,
				drawY = ScrH() / 3.35
			},
		}

        UV_UI.racing.carbon.events.carbon_noti_animState = carbon_noti_animState
        carbon_noti_animState.active = true
        carbon_noti_animState.startTime = CurTime()

        ----------------------------------------------------------------------------
        
        -- Remove any existing HUDPaint hook with the same name (avoid duplicates)
        if hook.GetTable().HUDPaint and hook.GetTable().HUDPaint.CARBON_NOTIFICATION_LAP then
            hook.Remove("HUDPaint", "CARBON_NOTIFICATION_LAP")
        end

        -- Add the HUDPaint hook freshly for this animation
        hook.Add("HUDPaint", "CARBON_NOTIFICATION_LAP", function()
            local elapsed = CurTime() - carbon_noti_animState.startTime

            local function calcPosAlpha(elapsed, elem)
                local x, y, alpha = elem.centerX, elem.y, 255
                if elapsed < carbon_noti_animState.slideInDuration then
                    local t = elapsed / carbon_noti_animState.slideInDuration
                    x = Lerp(t, elem.startX, elem.centerX)
                    alpha = Lerp(t, 0, 255)
                elseif elapsed < carbon_noti_animState.slideInDuration + carbon_noti_animState.holdDuration then
                    x = elem.centerX
                    alpha = 255
                elseif elapsed < carbon_noti_animState.slideInDuration + carbon_noti_animState.holdDuration + carbon_noti_animState.slideDownDuration then
                    local t = (elapsed - carbon_noti_animState.slideInDuration - carbon_noti_animState.holdDuration) / carbon_noti_animState.slideDownDuration
                    y = Lerp(t, elem.y, elem.slideDownEndY)
                    alpha = Lerp(t, 255, 0)
                else
                    alpha = 0
                end
                return x, y, alpha
            end

            local lines = string.Explode("\n", UV_UI.racing.carbon.states.LapCompleteText or "")
            if #lines < 1 then return end
			local upperLine = lines[1] or ""
			local lowerLine = lines[2] or ""

			-- Upper
            local ux, uy, ualpha = calcPosAlpha(elapsed, carbon_noti_animState.upper)
            carbon_noti_draw( upperLine, "UVCarbonFont", nil, ux + 2, uy + 2, Color(0, 0, 0, ualpha), nil)
            carbon_noti_draw( upperLine, "UVCarbonFont", nil, ux, uy, Color(255, 255, 255, ualpha), nil)

			-- Lower
            local lx, ly, lalpha = calcPosAlpha(elapsed, carbon_noti_animState.lower)
            carbon_noti_draw( lowerLine, "UVCarbonFont-Smaller", nil, lx + 2, ly + 2, Color(0, 0, 0, lalpha), nil)
            carbon_noti_draw( lowerLine, "UVCarbonFont-Smaller", nil, lx, ly, Color(175, 175, 175, lalpha), nil)

            -- Disable animation and remove hook when done
            if elapsed > carbon_noti_animState.slideInDuration + carbon_noti_animState.holdDuration + carbon_noti_animState.slideDownDuration then
                carbon_noti_animState.active = false
                hook.Remove("HUDPaint", "CARBON_NOTIFICATION_LAP")
            end

			-- Other Elements
			-- Outer Ring
			local ring = carbon_noti_animState.ring
			local elapsed = CurTime() - carbon_noti_animState.startTime

			local mergeEndTime = carbon_noti_animState.slideInDuration
			local blinkDuration = 0.1 -- total blink time (two blinks)
			local blinkInterval = blinkDuration / 2 -- one blink cycle (fade out + in)

			if elapsed < mergeEndTime then
				-- Shrinking phase: scale down & alpha up
				local t = math.Clamp(elapsed / mergeEndTime, 0, 1)
				ring.scale = Lerp(t, ring.scaleStart, ring.scaleEnd)
				ring.alpha = Lerp(t, ring.alphaStart, ring.alphaEnd)
			elseif elapsed < mergeEndTime + blinkDuration then
				-- Blink phase: fade ring out and back in twice

				local blinkElapsed = elapsed - mergeEndTime
				-- Calculate blink phase (0 to 1 to 0) twice in blinkDuration
				local phase = (blinkElapsed / blinkInterval) % 2
				-- Map phase to alpha (1->0->1) using triangle wave
				local alphaFactor = phase < 1 and (1 - phase) or (phase - 1)
				ring.alpha = Lerp(alphaFactor, ring.alphaEnd, 0)

				-- Keep scale steady during blinking
				ring.scale = ring.scaleEnd
			else
				-- Expansion + fade out phase
				local expandElapsed = elapsed - (mergeEndTime + blinkDuration)
				local expandDuration = 0.3
				local t = math.Clamp(expandElapsed / expandDuration, 0, 1)

				ring.scale = Lerp(t, ring.scaleEnd, ring.scaleStart) -- expand out
				ring.alpha = Lerp(t, ring.alphaEnd, 0)   -- fade out
			end

			DrawIcon(UVMaterials["TAKEDOWN_RING_CARBON"], ScrW() / 2, ScrH() / 3.35, ring.scale, Color(175, 175, 175, ring.alpha))

			-- Outer Ring Duplicate
			local clone = carbon_noti_animState.ringClone

			-- Spawn clone ring after main ring shrinks
			if not clone.createdTime and elapsed >= carbon_noti_animState.slideInDuration then
				clone.createdTime = CurTime()
				clone.blinkCount = 0
			end

			if clone.createdTime then
				local cloneElapsed = CurTime() - clone.createdTime
				local blinkCycle = clone.blinkInterval * 2

				-- Blinking logic
				if clone.blinkCount < clone.maxBlinks then
					local blinkCycle = clone.blinkInterval * 2
					local cloneElapsed = CurTime() - clone.createdTime
					local cycleTime = cloneElapsed % blinkCycle

					if cycleTime < clone.blinkInterval then
						-- Pop in (fully opaque)
						clone.alpha = 255
					else
						-- Fade out during second half of the cycle
						local fadeT = (cycleTime - clone.blinkInterval) / clone.blinkInterval
						clone.alpha = Lerp(fadeT, 255, 0)
					end

					-- Count completed full blink cycles
					local completedCycles = math.floor(cloneElapsed / blinkCycle)
					if completedCycles > clone.blinkCount then
						clone.blinkCount = completedCycles
					end

				else
					-- After blinking ends, fade from 255 to ring.alphaEnd
					if not clone.fadeAfterBlinkStart then
						clone.fadeAfterBlinkStart = CurTime()
					end

					local fadeT = math.Clamp((CurTime() - clone.fadeAfterBlinkStart) / 0.3, 0, 1)
					clone.alpha = Lerp(fadeT, 255, ring.alphaEnd)
				end

				-- Gradual scale-down over total blink duration
				local totalDuration = clone.scaleDuration
				local scaleT = math.min(cloneElapsed / totalDuration, 1)
				clone.scale = Lerp(scaleT, 0.085, clone.targetScale)

				-- Apply final slide down and fade for clone ring (matching text timing)
				local totalDuration = carbon_noti_animState.slideInDuration + carbon_noti_animState.holdDuration + carbon_noti_animState.slideDownDuration
				if CurTime() > carbon_noti_animState.startTime + carbon_noti_animState.slideInDuration + carbon_noti_animState.holdDuration then
					local slideElapsed = CurTime() - (carbon_noti_animState.startTime + carbon_noti_animState.slideInDuration + carbon_noti_animState.holdDuration)
					local t = math.Clamp(slideElapsed / carbon_noti_animState.slideDownDuration, 0, 1)

					-- Move the clone downward (same offset as text)
					local slideOffset = Lerp(t, 0, ScrH() * 0.2)
					clone.drawY = (ScrH() / 3.35) + slideOffset

					-- Fade out over time
					clone.alpha = Lerp(t, clone.alpha, 0)
				else
					clone.drawY = ScrH() / 3.35 -- stay at normal position
				end

				if clone.visible then
					DrawIcon(UVMaterials["TAKEDOWN_RING_CARBON"], ScrW() / 2, clone.drawY, clone.scale, Color(175, 175, 175, clone.alpha))
				end
			end

			-- Inner Circle
			local circle = carbon_noti_animState.circle
			local t = math.Clamp(elapsed / carbon_noti_animState.slideInDuration, 0, 1)

			-- Step 1: Animate scale + alpha like ring
			if elapsed < carbon_noti_animState.slideInDuration then
				circle.scale = Lerp(t, circle.scaleStart, circle.scaleEnd)
				circle.alpha = Lerp(t, circle.alphaStart, circle.alphaEnd)
			end

			-- Step 2: Start spinning after 4.1 is done blinking
			local clone = carbon_noti_animState.ringClone
			local blinkDoneTime = carbon_noti_animState.startTime + carbon_noti_animState.ring.reappearDelay + (clone.maxBlinks * clone.blinkInterval * 2)

			if CurTime() > blinkDoneTime and not circle.spinStartTime then
				circle.spinStartTime = CurTime()
			end

			if circle.spinStartTime then
				local spinElapsed = CurTime() - circle.spinStartTime
				local spinT = math.Clamp(spinElapsed / circle.spinDuration, 0, 1)
				circle.rotation = Lerp(spinT, 0, -360)
			end

			-- Step 3: Follow slide down like Element 4.1
			if elapsed > carbon_noti_animState.slideInDuration + carbon_noti_animState.holdDuration then
				local slideT = (elapsed - carbon_noti_animState.slideInDuration - carbon_noti_animState.holdDuration) / carbon_noti_animState.slideDownDuration
				local slideOffset = Lerp(slideT, 0, ScrH() * 0.2)
				circle.drawY = (ScrH() / 3.35) + slideOffset
				circle.alpha = Lerp(slideT, circle.alphaEnd, 0)
			end

			DrawIcon( UVMaterials["TAKEDOWN_CIRCLE_CARBON"], ScrW() / 2, circle.drawY, circle.scale, Color(175, 175, 175, circle.alpha), { rotation = circle.rotation } )

			-- Takedown Icon
			local icon = carbon_noti_animState.icon
			local elapsed = CurTime() - carbon_noti_animState.startTime

			local slideDownStart = carbon_noti_animState.slideInDuration + carbon_noti_animState.holdDuration
			local slideDownEnd = slideDownStart + carbon_noti_animState.slideDownDuration

			local slideOffset = 0
			if elapsed > slideDownStart and elapsed < slideDownEnd then
				local t = (elapsed - slideDownStart) / carbon_noti_animState.slideDownDuration
				slideOffset = Lerp(t, 0, ScrH() * 0.2)
			elseif elapsed >= slideDownEnd then
				slideOffset = ScrH() * 0.2
			end

			local currentY = (ScrH() / 3.35) + slideOffset
			local shrinkEnd = carbon_noti_animState.slideInDuration + carbon_noti_animState.ring.shrinkDuration
			local expandEnd = carbon_noti_animState.slideInDuration + carbon_noti_animState.holdDuration

			-- 1) Initial: fully visible
			if elapsed < carbon_noti_animState.slideInDuration then
				icon.scale = icon.baseScale
				icon.alpha = 255

			-- 2) Shrink to 0 instantly when Element 4 finishes shrinking
			elseif elapsed < shrinkEnd then
				icon.scale = 0  -- instant shrink
				icon.alpha = 255

			-- 3) Expand with overshoot during Element 4 expand
			elseif elapsed < expandEnd then
				local expandStart = carbon_noti_animState.slideInDuration + carbon_noti_animState.ring.shrinkDuration
				local expandElapsed = elapsed - expandStart
				local expandDuration = carbon_noti_animState.icon.ExpandDuration
				local t = math.Clamp(expandElapsed / expandDuration, 0, 1)

				if t < 0.8 then
					icon.scale = Lerp(t / 0.8, 0, icon.overshootScale)
				else
					icon.scale = icon.baseScale
				end

				icon.alpha = 255

			-- 4) Slide down with element 4.1, fade out alpha
			elseif elapsed < slideDownEnd then
				local fadeT = (elapsed - slideDownStart) / carbon_noti_animState.slideDownDuration
				icon.alpha = Lerp(fadeT, 255, 0)
			else
				icon.alpha = 0
			end

			DrawIcon(UVMaterials["CLOCK_BG"], ScrW() / 2, currentY, icon.scale, Color(255, 255, 255, icon.alpha))
        end)
    end
}

UV_UI.pursuit.carbon.events = {
	onUnitTakedown = function( unitType, name, bounty, bountyCombo, isPlayer )
		UV_UI.pursuit.carbon.states.TakedownText = string.format( language.GetPhrase( "uv.hud.carbon.takedown" ),
		isPlayer and language.GetPhrase( unitType .. ".caps" ) or name, bounty, bountyCombo )
		
		local SID = 0.35

		local carbon_noti_animState = {
			active = false,
			startTime = 0,
			slideInDuration = SID,
			holdDuration = 3,
			slideDownDuration = 0.25,
			upper = {
				startX = ScrW() * 0.25,
				centerX = ScrW() / 2,
				y = ScrH() * 0.35,
				slideDownEndY = ScrH() * 0.6,
			},
			lower = {
				startX = ScrW() * 0.75,
				centerX = ScrW() / 2,
				y = ScrH() * 0.385,
				slideDownEndY = ScrH() * 0.635,
			},
			ring = {
				scaleStart = 0.5,
				scaleEnd = 0.09,
				alphaStart = 15,
				alphaEnd = 150,
				scale = 0.2,
				alpha = 15,
				
				shrinkStart = 0,
				shrinkDuration = SID,
				disappearTime = 0.03,
				reappearDelay = SID + 0.03,
				expandStartTime = nil,
				expanded = false,
				visible = true
			},
			ringClone = {
				createdTime = nil,
				blinkInterval = 0.125,
				blinkCount = 0,
				maxBlinks = 2,
				scale = 0.085,
				scaleDuration = 0.6,
				targetScale = 0.07,
				alpha = 175,
				visible = true,
				fadeAfterBlinkStart = nil,
			},
			icon = {
			  scale = 0.06,
			  baseScale = 0.06,
			  overshootScale = 0.07,
			  alpha = 255,
			  ExpandDuration = 0.125,
			},
			circle = {
				scaleStart = 0.4,
				scaleEnd = 0.0575,
				alphaStart = 15,
				alphaEnd = 100,

				scale = 0.2,
				alpha = 15,
				rotation = 0,

				spinStartTime = nil,
				spinDuration = 5,
				drawY = ScrH() / 3.35
			},
		}

        UV_UI.pursuit.carbon.events.carbon_noti_animState = carbon_noti_animState
        carbon_noti_animState.active = true
        carbon_noti_animState.startTime = CurTime()

        ----------------------------------------------------------------------------
        
        -- Remove any existing HUDPaint hook with the same name (avoid duplicates)
        if hook.GetTable().HUDPaint and hook.GetTable().HUDPaint.CARBON_NOTIFICATION_TAKEDOWN then
            hook.Remove("HUDPaint", "CARBON_NOTIFICATION_TAKEDOWN")
        end

        -- Add the HUDPaint hook freshly for this animation
        hook.Add("HUDPaint", "CARBON_NOTIFICATION_TAKEDOWN", function()
            local elapsed = CurTime() - carbon_noti_animState.startTime

            local function calcPosAlpha(elapsed, elem)
                local x, y, alpha = elem.centerX, elem.y, 255
                if elapsed < carbon_noti_animState.slideInDuration then
                    local t = elapsed / carbon_noti_animState.slideInDuration
                    x = Lerp(t, elem.startX, elem.centerX)
                    alpha = Lerp(t, 0, 255)
                elseif elapsed < carbon_noti_animState.slideInDuration + carbon_noti_animState.holdDuration then
                    x = elem.centerX
                    alpha = 255
                elseif elapsed < carbon_noti_animState.slideInDuration + carbon_noti_animState.holdDuration + carbon_noti_animState.slideDownDuration then
                    local t = (elapsed - carbon_noti_animState.slideInDuration - carbon_noti_animState.holdDuration) / carbon_noti_animState.slideDownDuration
                    y = Lerp(t, elem.y, elem.slideDownEndY)
                    alpha = Lerp(t, 255, 0)
                else
                    alpha = 0
                end
                return x, y, alpha
            end

            local lines = string.Explode("\n", UV_UI.pursuit.carbon.states.TakedownText or "")
            if #lines < 1 then return end
			local upperLine = lines[1] or ""
			local lowerLine = lines[2] or ""

			-- Upper
            local ux, uy, ualpha = calcPosAlpha(elapsed, carbon_noti_animState.upper)
            carbon_noti_draw( upperLine, "UVCarbonFont", nil, ux + 2, uy + 2, Color(0, 0, 0, ualpha), nil)
            carbon_noti_draw( upperLine, "UVCarbonFont", nil, ux, uy, Color(255, 255, 255, ualpha), nil)

			-- Lower
            local lx, ly, lalpha = calcPosAlpha(elapsed, carbon_noti_animState.lower)
            carbon_noti_draw( lowerLine, "UVCarbonFont-Smaller", nil, lx + 2, ly + 2, Color(0, 0, 0, lalpha), nil)
            carbon_noti_draw( lowerLine, "UVCarbonFont-Smaller", nil, lx, ly, Color(175, 175, 175, lalpha), nil)

            -- Disable animation and remove hook when done
            if elapsed > carbon_noti_animState.slideInDuration + carbon_noti_animState.holdDuration + carbon_noti_animState.slideDownDuration then
                carbon_noti_animState.active = false
                hook.Remove("HUDPaint", "CARBON_NOTIFICATION_TAKEDOWN")
            end

			-- Other Elements
			-- Outer Ring
			local ring = carbon_noti_animState.ring
			local elapsed = CurTime() - carbon_noti_animState.startTime

			local mergeEndTime = carbon_noti_animState.slideInDuration
			local blinkDuration = 0.1 -- total blink time (two blinks)
			local blinkInterval = blinkDuration / 2 -- one blink cycle (fade out + in)

			if elapsed < mergeEndTime then
				-- Shrinking phase: scale down & alpha up
				local t = math.Clamp(elapsed / mergeEndTime, 0, 1)
				ring.scale = Lerp(t, ring.scaleStart, ring.scaleEnd)
				ring.alpha = Lerp(t, ring.alphaStart, ring.alphaEnd)
			elseif elapsed < mergeEndTime + blinkDuration then
				-- Blink phase: fade ring out and back in twice

				local blinkElapsed = elapsed - mergeEndTime
				-- Calculate blink phase (0 to 1 to 0) twice in blinkDuration
				local phase = (blinkElapsed / blinkInterval) % 2
				-- Map phase to alpha (1->0->1) using triangle wave
				local alphaFactor = phase < 1 and (1 - phase) or (phase - 1)
				ring.alpha = Lerp(alphaFactor, ring.alphaEnd, 0)

				-- Keep scale steady during blinking
				ring.scale = ring.scaleEnd
			else
				-- Expansion + fade out phase
				local expandElapsed = elapsed - (mergeEndTime + blinkDuration)
				local expandDuration = 0.3
				local t = math.Clamp(expandElapsed / expandDuration, 0, 1)

				ring.scale = Lerp(t, ring.scaleEnd, ring.scaleStart) -- expand out
				ring.alpha = Lerp(t, ring.alphaEnd, 0)   -- fade out
			end

			DrawIcon(UVMaterials["TAKEDOWN_RING_CARBON"], ScrW() / 2, ScrH() / 3.35, ring.scale, Color(175, 175, 175, ring.alpha))

			-- Outer Ring Duplicate
			local clone = carbon_noti_animState.ringClone

			-- Spawn clone ring after main ring shrinks
			if not clone.createdTime and elapsed >= carbon_noti_animState.slideInDuration then
				clone.createdTime = CurTime()
				clone.blinkCount = 0
			end

			if clone.createdTime then
				local cloneElapsed = CurTime() - clone.createdTime
				local blinkCycle = clone.blinkInterval * 2

				-- Blinking logic
				if clone.blinkCount < clone.maxBlinks then
					local blinkCycle = clone.blinkInterval * 2
					local cloneElapsed = CurTime() - clone.createdTime
					local cycleTime = cloneElapsed % blinkCycle

					if cycleTime < clone.blinkInterval then
						-- Pop in (fully opaque)
						clone.alpha = 255
					else
						-- Fade out during second half of the cycle
						local fadeT = (cycleTime - clone.blinkInterval) / clone.blinkInterval
						clone.alpha = Lerp(fadeT, 255, 0)
					end

					-- Count completed full blink cycles
					local completedCycles = math.floor(cloneElapsed / blinkCycle)
					if completedCycles > clone.blinkCount then
						clone.blinkCount = completedCycles
					end

				else
					-- After blinking ends, fade from 255 to ring.alphaEnd
					if not clone.fadeAfterBlinkStart then
						clone.fadeAfterBlinkStart = CurTime()
					end

					local fadeT = math.Clamp((CurTime() - clone.fadeAfterBlinkStart) / 0.3, 0, 1)
					clone.alpha = Lerp(fadeT, 255, ring.alphaEnd)
				end

				-- Gradual scale-down over total blink duration
				local totalDuration = clone.scaleDuration
				local scaleT = math.min(cloneElapsed / totalDuration, 1)
				clone.scale = Lerp(scaleT, 0.085, clone.targetScale)

				-- Apply final slide down and fade for clone ring (matching text timing)
				local totalDuration = carbon_noti_animState.slideInDuration + carbon_noti_animState.holdDuration + carbon_noti_animState.slideDownDuration
				if CurTime() > carbon_noti_animState.startTime + carbon_noti_animState.slideInDuration + carbon_noti_animState.holdDuration then
					local slideElapsed = CurTime() - (carbon_noti_animState.startTime + carbon_noti_animState.slideInDuration + carbon_noti_animState.holdDuration)
					local t = math.Clamp(slideElapsed / carbon_noti_animState.slideDownDuration, 0, 1)

					-- Move the clone downward (same offset as text)
					local slideOffset = Lerp(t, 0, ScrH() * 0.2)
					clone.drawY = (ScrH() / 3.35) + slideOffset

					-- Fade out over time
					clone.alpha = Lerp(t, clone.alpha, 0)
				else
					clone.drawY = ScrH() / 3.35 -- stay at normal position
				end

				if clone.visible then
					DrawIcon(UVMaterials["TAKEDOWN_RING_CARBON"], ScrW() / 2, clone.drawY, clone.scale, Color(175, 175, 175, clone.alpha))
				end
			end

			-- Inner Circle
			local circle = carbon_noti_animState.circle
			local t = math.Clamp(elapsed / carbon_noti_animState.slideInDuration, 0, 1)

			-- Step 1: Animate scale + alpha like ring
			if elapsed < carbon_noti_animState.slideInDuration then
				circle.scale = Lerp(t, circle.scaleStart, circle.scaleEnd)
				circle.alpha = Lerp(t, circle.alphaStart, circle.alphaEnd)
			end

			-- Step 2: Start spinning after 4.1 is done blinking
			local clone = carbon_noti_animState.ringClone
			local blinkDoneTime = carbon_noti_animState.startTime + carbon_noti_animState.ring.reappearDelay + (clone.maxBlinks * clone.blinkInterval * 2)

			if CurTime() > blinkDoneTime and not circle.spinStartTime then
				circle.spinStartTime = CurTime()
			end

			if circle.spinStartTime then
				local spinElapsed = CurTime() - circle.spinStartTime
				local spinT = math.Clamp(spinElapsed / circle.spinDuration, 0, 1)
				circle.rotation = Lerp(spinT, 0, -360)
			end

			-- Step 3: Follow slide down like Element 4.1
			if elapsed > carbon_noti_animState.slideInDuration + carbon_noti_animState.holdDuration then
				local slideT = (elapsed - carbon_noti_animState.slideInDuration - carbon_noti_animState.holdDuration) / carbon_noti_animState.slideDownDuration
				local slideOffset = Lerp(slideT, 0, ScrH() * 0.2)
				circle.drawY = (ScrH() / 3.35) + slideOffset
				circle.alpha = Lerp(slideT, circle.alphaEnd, 0)
			end

			DrawIcon( UVMaterials["TAKEDOWN_CIRCLE_CARBON"], ScrW() / 2, circle.drawY, circle.scale, Color(175, 175, 175, circle.alpha), { rotation = circle.rotation } )

			-- Takedown Icon
			local icon = carbon_noti_animState.icon
			local elapsed = CurTime() - carbon_noti_animState.startTime

			local slideDownStart = carbon_noti_animState.slideInDuration + carbon_noti_animState.holdDuration
			local slideDownEnd = slideDownStart + carbon_noti_animState.slideDownDuration

			local slideOffset = 0
			if elapsed > slideDownStart and elapsed < slideDownEnd then
				local t = (elapsed - slideDownStart) / carbon_noti_animState.slideDownDuration
				slideOffset = Lerp(t, 0, ScrH() * 0.2)
			elseif elapsed >= slideDownEnd then
				slideOffset = ScrH() * 0.2
			end

			local currentY = (ScrH() / 3.35) + slideOffset
			local shrinkEnd = carbon_noti_animState.slideInDuration + carbon_noti_animState.ring.shrinkDuration
			local expandEnd = carbon_noti_animState.slideInDuration + carbon_noti_animState.holdDuration

			-- 1) Initial: fully visible
			if elapsed < carbon_noti_animState.slideInDuration then
				icon.scale = icon.baseScale
				icon.alpha = 255

			-- 2) Shrink to 0 instantly when Element 4 finishes shrinking
			elseif elapsed < shrinkEnd then
				icon.scale = 0  -- instant shrink
				icon.alpha = 255

			-- 3) Expand with overshoot during Element 4 expand
			elseif elapsed < expandEnd then
				local expandStart = carbon_noti_animState.slideInDuration + carbon_noti_animState.ring.shrinkDuration
				local expandElapsed = elapsed - expandStart
				local expandDuration = carbon_noti_animState.icon.ExpandDuration
				local t = math.Clamp(expandElapsed / expandDuration, 0, 1)

				if t < 0.8 then
					icon.scale = Lerp(t / 0.8, 0, icon.overshootScale)
				else
					icon.scale = icon.baseScale
				end

				icon.alpha = 255

			-- 4) Slide down with element 4.1, fade out alpha
			elseif elapsed < slideDownEnd then
				local fadeT = (elapsed - slideDownStart) / carbon_noti_animState.slideDownDuration
				icon.alpha = Lerp(fadeT, 255, 0)
			else
				icon.alpha = 0
			end

			DrawIcon(UVMaterials["UNITS_DISABLED"], ScrW() / 2, currentY, icon.scale, Color(255, 255, 255, icon.alpha))
        end)
    end,
    onUnitDeploy = function(...)
        local new_value = select (1, ...)
        local old_value = select (2, ...)
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
    
    ShowDebrief = function(params) -- Carbon
        if UVHUDDisplayRacing then return end
        if IsValid(ResultPanel) then ResultPanel:Remove() end
        
        local debriefdata = params.dataTable or escapedtable
        local debrieftitletext = params.titleText or "Title Text"
        local debrieftitlevar = params.titleVar or " "
        
        local w = ScrW()
        local h = ScrH()
        
        --------------------------------------
        
        local time = UVDisplayTime(UVTimerProgress)
        local unit = debriefdata["Unit"] or "Officer Replace Me"
        local deploys = debriefdata["Deploys"]
        local roadblocksdodged = debriefdata["Roadblocks"]
        local spikestripsdodged = debriefdata["Spikestrips"]
        local bounty = UVBounty
        local tags = UVTags
        local wrecks = UVWrecks
        local suspects = UVHUDWantedSuspectsNumber
        
        OK = vgui.Create("DButton", vgui.GetWorldPanel())
        OK:SetText("")
        OK:SetPos(w*0.2565, h*0.675)
        OK:SetSize(w*0.15, h*0.035)
        OK.Paint = function() end

        ResultPanel = vgui.Create("DPanel", vgui.GetWorldPanel())
		ResultPanel:Add(OK)
        ResultPanel:SetSize(w, h)
        -- ResultPanel:SetPos(0, 0)
        ResultPanel:SetMouseInputEnabled(true)
        ResultPanel:SetKeyboardInputEnabled(false)
        ResultPanel:SetZPos(32767)
        
        local targetY = 0
        local overshootY = h * 0.1  -- drops 10% below target before bouncing back
        local startY = -h           -- start fully above the screen
        
        ResultPanel:SetPos(0, startY)
        
        local animTime = 0.33
        local bounceTime = 0.1
        local startTime = CurTime()
        
        hook.Add("Think", "ResultPanelEntranceAnim", function()
            local elapsed = CurTime() - startTime
            
            if elapsed < animTime then
                if elapsed < animTime - bounceTime then
                    local frac = elapsed / (animTime - bounceTime)
                    local y = Lerp(frac, startY, overshootY)
                    ResultPanel:SetPos(0, y)
                else
                    local frac = (elapsed - (animTime - bounceTime)) / bounceTime
                    local y = Lerp(frac, overshootY, targetY)
                    ResultPanel:SetPos(0, y)
                end
            else
                ResultPanel:SetPos(0, targetY)
                hook.Remove("Think", "ResultPanelEntranceAnim")
            end
        end)
        
        local function AnimateAndRemovePanel(panel)
            if not IsValid(panel) then return end
            
            local startY = panel:GetY()
            local endY = ScrH()  -- off-screen below
            local animTime = 0.33
            local startTime = CurTime()
            
            -- Play sounds ONCE at start
            surface.PlaySound("uvui/carbon/openmenu.wav")
            surface.PlaySound("uvui/carbon/exitmenu.wav")
            
            -- Disable interactivity
            panel:SetMouseInputEnabled(false)
            gui.EnableScreenClicker(false)
			OK:SetEnabled(false)
            
            hook.Add("Think", "ResultPanelExitAnim", function()
                if not IsValid(panel) then
                    hook.Remove("Think", "ResultPanelExitAnim")
                    return
                end
                
                local elapsed = CurTime() - startTime
                if elapsed < animTime then
                    local frac = elapsed / animTime
                    local y = Lerp(frac, startY, endY)
                    panel:SetPos(0, y)
                else
                    panel:Remove()
                    hook.Remove("Think", "ResultPanelExitAnim")
                end
            end)
        end
        
        gui.EnableScreenClicker(true)

        local timetotal = 30
        local timestart = CurTime()
        local exitStarted = false -- prevent repeated trigger
        
        local finalTitle = "★" .. language.GetPhrase("uv.results.pursuit.carbon") .. "★"
        local charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!@#$%^&*()[]{}<>,./?|"
        local revealSpeed = 0.05
        local displayStart = CurTime()
        local scrambleSound
        local isScrambling = true
        local revealedChars = 0
        
        sound.Add({
            name = "UV.Carbon.Scramble",
            channel = CHAN_STATIC,
            volume = 1.0,
            level = 70,
            pitch = { 100 },
            sound = "uvui/carbon/textfold.wav"
        })
        
        -- Start reveal timer
        timer.Create("ScrambleTextUpdate", revealSpeed, #finalTitle, function()
            revealedChars = revealedChars + 1
            
            -- Start the loop sound
            if isScrambling and not scrambleSound then
                scrambleSound = CreateSound(LocalPlayer(), "UV.Carbon.Scramble")
                if scrambleSound then
                    scrambleSound:Play()
                end
            end
            
            -- Stop when done
            if revealedChars >= #finalTitle then
                isScrambling = false
                if scrambleSound then
                    scrambleSound:FadeOut(0.2)
                    scrambleSound = nil
                end
            end
        end)
        
        ResultPanel.Paint = function(self, w, h)
            local timeremaining = math.ceil(timetotal - (CurTime() - timestart))
            local lang = language.GetPhrase
            
            -- Main black BG
            surface.SetMaterial(UVMaterials['BG_BIG_CARBON'])
            surface.SetDrawColor( 0, 0, 0, 225 )
            surface.DrawTexturedRect( 0, 0, w, h)
            
            -- Upper Results Tab
            surface.SetDrawColor( 0, 0, 0, 200 )
            surface.DrawRect( w*0.25, h*0.185, w*0.5, h*0.075)
            
            surface.SetMaterial(UVMaterials['EOC_FRAME_CARBON'])
            surface.SetDrawColor(86, 214, 205)
            surface.DrawTexturedRect( w*0.26, h*0.17825, w*0.485, h*0.09)
            
            DrawIcon( UVMaterials['X_OUTER_CARBON'], w*0.255, h*0.215, 0.2, Color(0,0,0) ) -- Icon
            DrawIcon( Material("unitvehicles/hud_carbon/x_anim"), w*0.255, h*0.215, 0.2, Color(255,255,255) ) -- Animated Icon; TBD
            
            local timePassed = CurTime() - displayStart
            local charsToReveal = math.min(#finalTitle, math.floor(timePassed / revealSpeed))
            
            local animatedTitle = ""
            
            for i = 1, #finalTitle do
                if i <= charsToReveal then
                    animatedTitle = animatedTitle .. finalTitle:sub(i, i)
                else
                    local randIndex = math.random(#charset)
                    local randChar = charset:sub(randIndex, randIndex)
                    animatedTitle = animatedTitle .. randChar
                end
            end
            
            draw.DrawText(animatedTitle, "UVCarbonFont", w * 0.3, h * 0.2, Color(255, 255, 255), TEXT_ALIGN_LEFT)
            
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
                surface.SetDrawColor( 86, 214, 205, 175 )
                surface.DrawTexturedRect( w*0.25, h*0.34 + yPos, w*0.485, h*0.035)
                
                surface.SetMaterial(UVMaterials['ARROW_CARBON'])
                surface.DrawTexturedRect( w*0.735, h*0.34 + yPos, w*0.015, h*0.035)
            end
            
            -- All middle tabs, dark ones
            local numRectsDark = 3
            for i=0, numRectsDark, 1 do
                local yPos = i * h * 0.08
                surface.SetMaterial(UVMaterials['BACKGROUND_CARBON_FILLED'])
                surface.SetDrawColor( 86, 214, 205, 75 )
                surface.DrawTexturedRect( w*0.25, h*0.38 + yPos, w*0.485, h*0.035)
                
                surface.SetMaterial(UVMaterials['ARROW_CARBON'])
                surface.DrawTexturedRect( w*0.735, h*0.38 + yPos, w*0.015, h*0.035)
            end
            
            local h1, h2 = h*0.3825, h*0.4225
            
            -- Text
            draw.DrawText( debrieftitletext, "UVCarbonLeaderboardFont", w*0.2565, h*0.3425, Color( 255, 255, 0), TEXT_ALIGN_LEFT )
            
            draw.SimpleText( "#uv.results.chase.bounty", "UVCarbonLeaderboardFont", w*0.2565, h1, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText( "#uv.results.chase.time", "UVCarbonLeaderboardFont", w*0.2565, h2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText( "#uv.results.chase.units.deployed", "UVCarbonLeaderboardFont", w*0.2565, h1 + h*0.08, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText( "#uv.results.chase.units.damaged", "UVCarbonLeaderboardFont", w*0.2565, h2 + h*0.08, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText( "#uv.results.chase.units.destroyed", "UVCarbonLeaderboardFont", w*0.2565, h1 + h*0.16, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText( "#uv.results.chase.dodged.blocks", "UVCarbonLeaderboardFont", w*0.2565, h2 + h*0.16, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText( "#uv.results.chase.dodged.spikes", "UVCarbonLeaderboardFont", w*0.2565, h1 + h*0.24, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            
            draw.SimpleText( debrieftitlevar, "UVCarbonLeaderboardFont", w*0.74, h*0.3425, Color( 255, 255, 0), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            
            draw.SimpleText( bounty, "UVCarbonLeaderboardFont", w*0.74, h1, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            draw.SimpleText( time, "UVCarbonLeaderboardFont", w*0.74, h2, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            draw.SimpleText( deploys, "UVCarbonLeaderboardFont", w*0.74, h1 + h*0.08, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            draw.SimpleText( tags, "UVCarbonLeaderboardFont", w*0.74, h2 + h*0.08, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            draw.SimpleText( wrecks, "UVCarbonLeaderboardFont", w*0.74, h1 + h*0.16, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            draw.SimpleText( roadblocksdodged, "UVCarbonLeaderboardFont", w*0.74, h2 + h*0.16, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            draw.SimpleText( spikestripsdodged, "UVCarbonLeaderboardFont", w*0.74, h1 + h*0.24, Color(255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            
            
            -- Time remaining and closing
            local conttext = "( " .. input.LookupBinding("+jump") .. " ) " .. lang("uv.results.continue")
            local conttextl = string.len(conttext)
            
            local autotext = string.format( language.GetPhrase("uv.results.autoclose"), math.max(0, timeremaining) )
            local autotextl = string.len(autotext)
            
            surface.SetDrawColor( 150, 150, 150, 175 )
            
            surface.DrawRect( w*0.2565, h*0.675, (w*0.00575 * conttextl), h*0.035)
            draw.DrawText( conttext, "UVCarbonLeaderboardFont", w*0.2585, h*0.6785, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT )
            
            surface.DrawRect( w*0.26 +  (w*0.00575 * conttextl), h*0.675, (w*0.00575 * autotextl), h*0.035)
            draw.DrawText( autotext, "UVCarbonLeaderboardFont", w*0.2625 + (w*0.00575 * conttextl), h*0.6785, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT )
            
            if not exitStarted and timeremaining < 1 then
                exitStarted = true
                hook.Remove("Think", "CheckJumpKeyForDebrief")
                AnimateAndRemovePanel(ResultPanel)
            end
        end
        
        function OK:DoClick() 
            hook.Remove("Think", "CheckJumpKeyForDebrief")
            AnimateAndRemovePanel(ResultPanel)
        end
        
        local wasJumping = false
        hook.Add("Think", "CheckJumpKeyForDebrief", function()
            local ply = LocalPlayer()
            if not IsValid(ply) then return end
            
            if ply:KeyDown(IN_JUMP) then
                if not wasJumping then
                    wasJumping = true
                    if IsValid(ResultPanel) then
                        AnimateAndRemovePanel(ResultPanel)
                        hook.Remove("Think", "CheckJumpKeyForDebrief")
                    end
                end
            else
                wasJumping = false
            end
        end)
    end,
    
    onRacerEscapedDebrief = function(escapedtable)
        local params = {
            dataTable = escapedtable,
            titleText = "#uv.results.escapedfrom",
        }
        UV_UI.pursuit.carbon.events.ShowDebrief(params)
    end,
    
    onRacerBustedDebrief = function(bustedtable)
        local params = {
            dataTable = bustedtable,
            titleText = "#uv.results.bustedby.carbon",
            titleVar = bustedtable["Unit"],
        }
        UV_UI.pursuit.carbon.events.ShowDebrief(params)
    end,
    
    onCopBustedDebrief = function(bustedtable)
        local params = {
            dataTable = bustedtable,
            titleText = "#uv.results.suspects.busted",
            titleVar = bustedtable["Unit"],
        }
        UV_UI.pursuit.carbon.events.ShowDebrief(params)
    end,
    
    onCopEscapedDebrief = function(escapedtable)
        local params = {
            dataTable = escapedtable,
            titleText = "#uv.results.suspects.escaped.num.carbon",
            titleVar = UVHUDWantedSuspectsNumber,
        }
        UV_UI.pursuit.carbon.events.ShowDebrief(params)
    end,
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
	if UVHUDDisplayRacing then return end
    
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
                UVBustingProgress = UVClosestSuspect.uvbustingprogress or 0
                
                local blink = 255 * math.abs(math.sin(RealTime() * 8))
                states.BustedColor = Color(255, blink, blink)
            end
        end
    end
    
    --if not UVHUDRace then
    local ResourceText = UVResourcePoints
    
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
    
    -- if UVHeatLevel == 1 then
    --     UVHeatBountyMin = UVUHeatMinimumBounty1:GetInt()
    --     UVHeatBountyMax = UVUHeatMinimumBounty2:GetInt()
    -- elseif UVHeatLevel == 2 then
    --     UVHeatBountyMin = UVUHeatMinimumBounty2:GetInt()
    --     UVHeatBountyMax = UVUHeatMinimumBounty3:GetInt()
    -- elseif UVHeatLevel == 3 then
    --     UVHeatBountyMin = UVUHeatMinimumBounty3:GetInt()
    --     UVHeatBountyMax = UVUHeatMinimumBounty4:GetInt()
    -- elseif UVHeatLevel == 4 then
    --     UVHeatBountyMin = UVUHeatMinimumBounty4:GetInt()
    --     UVHeatBountyMax = UVUHeatMinimumBounty5:GetInt()
    -- elseif UVHeatLevel == 5 then
    --     UVHeatBountyMin = UVUHeatMinimumBounty5:GetInt()
    --     UVHeatBountyMax = UVUHeatMinimumBounty6:GetInt()
    -- elseif UVHeatLevel == 6 then
    --     UVHeatBountyMin = UVUHeatMinimumBounty6:GetInt()
    --     UVHeatBountyMax = math.huge
    -- end
    
    local UVHeatMinConVar = GetConVar( 'unitvehicle_unit_heatminimumbounty' .. UVHeatLevel )
    local UVHeatMaxConVar = GetConVar( 'unitvehicle_unit_heatminimumbounty' .. UVHeatLevel + 1 )
    
    UVHeatBountyMin = ( UVHeatMinConVar and UVHeatMinConVar:GetInt() ) or math.huge
    UVHeatBountyMax = ( UVHeatMaxConVar and UVHeatMaxConVar:GetInt() ) or math.huge
    
    local hl10 = 0
	local hlcm = 0
    if UVHeatLevel > 9 then hl10 = w * 0.01 end
	if (UVHUDDisplayCooldown and UVHUDCopMode) then hlcm = h * 0.0475 end
	
    DrawIcon(UVMaterials["HEAT_CARBON"], w * 0.8 - hl10, h * 0.28 - hlcm, .045, Colors.Carbon_Accent) -- Icon
    
    draw.DrawText("x" .. UVHeatLevel, "UVCarbonFont", w * 0.83 + 2, h * 0.26 - hlcm + 2, Color(0,0,0), TEXT_ALIGN_RIGHT)
    draw.DrawText("x" .. UVHeatLevel, "UVCarbonFont", w * 0.83, h * 0.26 - hlcm, Colors.Carbon_Accent, TEXT_ALIGN_RIGHT)

    surface.SetDrawColor(Color(0,0,0))
    surface.DrawRect(w * 0.835 - 4, h * 0.275 - hlcm - 3, w * 0.145 + 8.5, h * 0.015 + 6)
    surface.SetDrawColor(Colors.Carbon_AccentDarker)
    surface.DrawRect(w * 0.835, h * 0.275 - hlcm, w * 0.145, h * 0.015)
    surface.SetDrawColor(Color(255, 255, 255))
    local HeatProgress = 0
    if MaxHeatLevel:GetInt() ~= UVHeatLevel then
        if UVUTimeTillNextHeatEnabled:GetInt() == 1 and UVTimeTillNextHeat then --Time till next heat level
            local timedHeatConVar = GetConVar( 'unitvehicle_unit_timetillnextheat' .. UVHeatLevel )
            
            local maxtime = timedHeatConVar:GetInt()
            HeatProgress = (maxtime - UVTimeTillNextHeat) / maxtime
            -- if UVHeatLevel == 1 then
            --     local maxtime = UVUTimeTillNextHeat1:GetInt()
            --     HeatProgress = (maxtime - UVTimeTillNextHeat) / maxtime
            -- elseif UVHeatLevel == 2 then
            --     local maxtime = UVUTimeTillNextHeat2:GetInt()
            --     HeatProgress = (maxtime - UVTimeTillNextHeat) / maxtime
            -- elseif UVHeatLevel == 3 then
            --     local maxtime = UVUTimeTillNextHeat3:GetInt()
            --     HeatProgress = (maxtime - UVTimeTillNextHeat) / maxtime
            -- elseif UVHeatLevel == 4 then
            --     local maxtime = UVUTimeTillNextHeat4:GetInt()
            --     HeatProgress = (maxtime - UVTimeTillNextHeat) / maxtime
            -- elseif UVHeatLevel == 5 then
            --     local maxtime = UVUTimeTillNextHeat5:GetInt()
            --     HeatProgress = (maxtime - UVTimeTillNextHeat) / maxtime
            -- elseif UVHeatLevel == 6 then
            --     HeatProgress = 0
            -- end
        else
            HeatProgress = ((UVBountyNo - UVHeatBountyMin) / (UVHeatBountyMax - UVHeatBountyMin))
        end
    end
    local B = math.Clamp((HeatProgress) * w * 0.145, 0, w * 0.145)
    local blink = 255 * math.abs(math.sin(RealTime() * 4))
    local blink2 = 255 * math.abs(math.sin(RealTime() * 6))
    local blink3 = 255 * math.abs(math.sin(RealTime() * 8))

    surface.SetDrawColor(Colors.Carbon_Accent)
    
    surface.DrawRect(w * 0.835, h * 0.275 - hlcm, B, h * 0.015)
    
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
    
    -- [[ Commander Stuff ]]
    if UVOneCommanderActive then
        ResourceText = "⛊"
        
        surface.SetDrawColor(0, 0, 0, 200) -- Milestone BG
        surface.DrawRect(w * 0.79, h * 0.35, w * 0.19, h * 0.03)
        
        draw.DrawText("⛊","UVCarbonFont",w * 0.7925, h * 0.3375, Colors.Carbon_Accent,TEXT_ALIGN_LEFT)
        draw.DrawText("⛊","UVCarbonFont",w * 0.975, h * 0.3375, Colors.Carbon_Accent,TEXT_ALIGN_RIGHT)
        
        local cname = "#uv.unit.commander"
        if IsValid(UVHUDCommander) then
            local driver = UVHUDCommander:GetDriver()
            if IsValid(driver) and driver:IsPlayer() then
                cname = driver:Nick()
            end
        end
        
        draw.DrawText(cname, "UVCarbonLeaderboardFont",w * 0.8825, h * 0.3515, Colors.Carbon_Accent,TEXT_ALIGN_CENTER)
        
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
        local blink = 255 * math.abs(math.sin(RealTime() * 4))
        local blink2 = 255 * math.abs(math.sin(RealTime() * 6))
        local blink3 = 255 * math.abs(math.sin(RealTime() * 8))
        
        if healthratio >= 0.5 then
            healthcolor = Colors.Carbon_Accent
        elseif healthratio >= 0.25 then
            healthcolor = Color(255, blink, blink, 200)
        else
            healthcolor = Color(255, blink2, blink2, 200)
        end
        if healthratio > 0 then
            surface.SetDrawColor(Color(0,0,0))
            surface.DrawRect(w * 0.79 - 4, h * 0.385 - 3, w * 0.19 + 8.5, h * 0.015 + 6)
            surface.SetDrawColor(Colors.Carbon_AccentDarker)
            surface.DrawRect(w * 0.79, h * 0.385, w * 0.19, h * 0.015)
            
            surface.SetDrawColor(healthcolor)
            local T = math.Clamp((healthratio) * (w * 0.19), 0, w * 0.19)
            surface.DrawRect(w * 0.79, h * 0.385, T, h * 0.015)
        end
    end
    
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
            surface.SetDrawColor(255, 0, 0)
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
                draw.DrawText("#uv.chase.cooldown","UVCarbonLeaderboardFont",w * 0.98 + 2,h * 0.2 + 2,Color(0,0,0),TEXT_ALIGN_RIGHT)
                draw.DrawText("#uv.chase.cooldown", "UVCarbonLeaderboardFont",w * 0.98,h * 0.2,Colors.Carbon_Accent,TEXT_ALIGN_RIGHT)
            end
        else
            CooldownProgress = 0
        end
    end
    --end
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
    
    TakedownText = nil,
}

UV_UI.racing.mostwanted.states = {
    LapCompleteText = nil,
}

UV_UI.racing.mostwanted.events = {
    ShowResults = function(sortedRacers) -- Most Wanted
        local debriefcolor = Color(255, 183, 61)
        
        local w = ScrW()
        local h = ScrH()
        
        --------------------------------------
        
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
        
        OK:SetText("")
        OK:SetPos(w*0.205, h*0.77)
        OK:SetSize(w*0.205, h*0.0425)
		OK.Paint = function() end
        
        local timestart = CurTime()
        
        local revealStartTime = CurTime()
        local displaySequence = {}
        
        -- Data and labels
        local racersArray = {}
        
        for _, dict in pairs(sortedRacers) do
            table.insert(racersArray, dict)
        end
        
        table.sort(racersArray, function(a, b)
            local timeA = a.array and a.array.TotalTime
            local timeB = b.array and b.array.TotalTime
            
            -- Treat missing or non-numeric TotalTime as a large number (DNF)
            local tA = (type(timeA) == "number") and timeA or math.huge
            local tB = (type(timeB) == "number") and timeB or math.huge
            
            return tA < tB
        end)
        
        local h1, h2 = h*0.2475, h*0.2875
        local xLeft = w * 0.205
        local xMiddle = w * 0.3
        local xRight = w * 0.795
        local revealInterval = 0.033
        
        local entriesToShow = 13
        local scrollOffset = 0
        
        local i = 0
        for place, dict in ipairs(racersArray) do
            local info = dict.array or {}
            i = i + 1
            
            local revealTime = revealStartTime + (i - 1) * revealInterval
            
            -- Staggered vertical layout
            local visibleIndex = i -- 1 to entriesToShow
            local yPos = (visibleIndex % 2 == 1) and h1 + math.floor(visibleIndex / 2) * h * 0.08
            or h2 + math.floor((visibleIndex - 1) / 2) * h * 0.08
            
            local name = info["Name"] or "Unknown"
            local totalTime = info["TotalTime"] and info["TotalTime"] or "#uv.race.suffix.dnf"

            if info["Busted"] then totalTime = "#uv.race.suffix.busted" end
            
            local entry = {
                y = yPos,
                leftText = tostring(i),
                middleText = name,
                rightText = UV_FormatRaceEndTime(totalTime),
                revealTime = revealTime
            }
            
            table.insert(displaySequence, entry)
        end
        
        local flashDuration = 0.2 -- total time for flash animation
        local flashStartTime = nil
        local allRevealed = false
        
        local closing = false
        local closeStartTime = 0
        
        local totalRevealTime = (revealInterval * entriesToShow) + flashDuration
        
        function ResultPanel:OnMouseWheeled(delta)
            if delta > 0 then
                scrollOffset = math.max(scrollOffset - 1, 0)
            elseif delta < 0 then
                local maxOffset = math.max(0, #displaySequence - entriesToShow)
                scrollOffset = math.min(scrollOffset + 1, maxOffset)
            end
            
            return true -- prevent further processing
        end
        
        ResultPanel.Paint = function(self, w, h)
            local curTime = CurTime()
            
            -- Check if all rows revealed
            local allEntriesRevealed = true
            for i, entry in ipairs(displaySequence) do
                if curTime < entry.revealTime then
                    allEntriesRevealed = false
                    break
                end
            end
            
            if allEntriesRevealed and not flashStartTime then
                flashStartTime = curTime
            end
            
            local flashProgress = flashStartTime and math.min((curTime - flashStartTime) / flashDuration, 1) or 0
            
            local textAlpha = 0
            local tabAlpha = 50
            
            if flashStartTime then
                if not closing then
                    textAlpha = Lerp(flashProgress, 0, 255)
                    if flashProgress < 0.5 then
                        tabAlpha = Lerp(flashProgress / 0.5, 0, 255)
                    else
                        tabAlpha = Lerp((flashProgress - 0.5) / 0.5, 255, 50)
                    end
                else
                    -- Reverse flash alpha during closing
                    textAlpha = Lerp(flashProgress, 255, 0)
                    if flashProgress < 0.5 then
                        tabAlpha = Lerp(flashProgress / 0.5, 50, 255)
                    else
                        tabAlpha = Lerp((flashProgress - 0.5) / 0.5, 255, 0)
                    end
                end
            end
            local blackBgAlpha = 0
            
            if not closing then
                -- Opening: ramp up to 235 in 0.05s
                local fadeInDuration = 0.05
                local elapsedSinceStart = curTime - timestart
                blackBgAlpha = Lerp(math.min(elapsedSinceStart / fadeInDuration, 1), 0, 235)
            else
                -- Closing: hold 235 until last 0.1s, then fade to 0
                local fadeOutDuration = 0.1
                local timeSinceCloseStart = curTime - closeStartTime
                local timeLeft = totalRevealTime - timeSinceCloseStart
                
                if timeLeft <= fadeOutDuration then
                    -- fade out from 235 to 0 in last 0.1 seconds
                    blackBgAlpha = Lerp(timeLeft / fadeOutDuration, 0, 235)
                else
                    blackBgAlpha = 235
                end
            end
            
            -- Main black background
            surface.SetDrawColor(0, 0, 0, blackBgAlpha)
            surface.DrawRect(0, 0, w, h)
            
            -- Draw rows and alternating backgrounds fully visible when revealed
            local xLeft = w * 0.2125
            local xRight = w * 0.7875
            local hStep = h * 0.04
            local elapsed, revealProgress, flashProgress
            local entriesCount = #displaySequence
            
            if closing then
                elapsed = curTime - closeStartTime
                revealProgress = math.Clamp(1 - (elapsed / totalRevealTime), 0, 1)
                flashProgress = math.Clamp(revealProgress * (flashDuration / totalRevealTime), 0, 1)
                
                -- Limit entriesToShow to the scrolling window
                entriesToShow = math.min(math.ceil(entriesCount * revealProgress), 13)
            else
                elapsed = curTime - revealStartTime
                revealProgress = math.Clamp(elapsed / (totalRevealTime - flashDuration), 0, 1)
                flashProgress = flashStartTime and math.min((curTime - flashStartTime) / flashDuration, 1) or 0
                
                -- Limit entriesToShow to the scrolling window
                entriesToShow = math.min(math.floor(entriesCount * revealProgress), 13)
            end
            
            local startIndex = scrollOffset + 1
            local endIndex = math.min(startIndex + entriesToShow - 1, #displaySequence)
            
            for i = startIndex, endIndex do
                local entry = displaySequence[i]
                local localIndex = i - startIndex + 1
                local yPos = (localIndex % 2 == 1)
                and h1 + math.floor(localIndex / 2) * h * 0.08
                or h2 + math.floor((localIndex - 1) / 2) * h * 0.08
                
                if localIndex % 2 == 0 then
                    surface.SetDrawColor(0, 0, 0, 50)
                else
                    surface.SetDrawColor(debriefcolor.r, debriefcolor.g, debriefcolor.b, 25)
                end
                surface.DrawRect(w * 0.2, yPos, w * 0.6, hStep)
                
                if entry.leftText then
                    draw.SimpleText(entry.leftText, "UVFont5UI", xLeft, yPos, Colors.MW_Racer, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                end
                if entry.middleText then
                    draw.SimpleText(entry.middleText, "UVFont5UI", xMiddle, yPos, Colors.MW_Racer, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                end
                if entry.rightText then
                    draw.SimpleText(entry.rightText, "UVFont5UI", xRight, yPos, Colors.MW_Racer, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
                end
            end
            
            if flashStartTime then
                -- Top tab background flash
                surface.SetDrawColor(debriefcolor.r, debriefcolor.g, debriefcolor.b, tabAlpha)
                surface.DrawRect(w * 0.2, h * 0.1225, w * 0.6, h * 0.075)
                
                -- Upper-middle background flash (same alpha as tabs)
                surface.SetMaterial(UVMaterials['BACKGROUND_BIGGER'])
                surface.SetDrawColor(debriefcolor.r, debriefcolor.g, debriefcolor.b, tabAlpha)
                surface.DrawTexturedRect(w * 0.2, h * 0.1975, w * 0.6, h * 0.05)
                
                -- Bottom tab background flash
                surface.SetDrawColor(debriefcolor.r, debriefcolor.g, debriefcolor.b, tabAlpha)
                surface.SetMaterial(Material("unitvehicles/hud/bg_anim"))
                surface.DrawTexturedRect(w * 0.2, h * 0.7725, w * 0.6, h * 0.04)
                
                -- Icon and texts fade in (stay full alpha after flash)
                DrawIcon(UVMaterials['RESULTRACE'], w * 0.225, h * 0.1575, .07, Color(debriefcolor.r, debriefcolor.g, debriefcolor.b, textAlpha))
                draw.DrawText("#uv.results.standings", "UVFont5", w * 0.25, h * 0.1375, Color(debriefcolor.r, debriefcolor.g, debriefcolor.b, textAlpha), TEXT_ALIGN_LEFT)
                
                draw.DrawText("#uv.results.race.pos", "UVFont5UI", w * 0.205, h * 0.2, Color(debriefcolor.r, debriefcolor.g, debriefcolor.b, textAlpha), TEXT_ALIGN_LEFT)
                draw.DrawText("#uv.results.race.name", "UVFont5UI", w * 0.3, h * 0.2, Color(debriefcolor.r, debriefcolor.g, debriefcolor.b, textAlpha), TEXT_ALIGN_LEFT)
                draw.DrawText("#uv.results.race.time", "UVFont5UI", w * 0.795, h * 0.2, Color(debriefcolor.r, debriefcolor.g, debriefcolor.b, textAlpha), TEXT_ALIGN_RIGHT)
                
				local blink = 255 * math.abs(math.sin(RealTime() * 8))
				
                if scrollOffset > 0 then
                    draw.SimpleText("▲", "UVFont5UI", w * 0.5, h * 0.2175, Color(255,255,255,blink), TEXT_ALIGN_CENTER)
                end
                
                if scrollOffset < #displaySequence - entriesToShow then
                    draw.SimpleText("▼", "UVFont5UI", w * 0.5, h * 0.7625, Color(255,255,255,blink), TEXT_ALIGN_CENTER)
                end
                
                draw.DrawText("[ " .. input.LookupBinding("+jump") .. " ] " .. language.GetPhrase("uv.results.continue"), "UVFont5UI", w * 0.205, h * 0.77, Color(debriefcolor.r, debriefcolor.g, debriefcolor.b, textAlpha), TEXT_ALIGN_LEFT)
            end
            
            -- Show/Hide OK button with fade
            if flashStartTime then
                if textAlpha > 0 then
                    OK:SetEnabled(true)
                end
            else
                OK:SetEnabled(false)
            end
            
            -- Time since panel was created
            local elapsed = CurTime() - timestart
            
            -- Only start auto-close countdown after reveal + flash
            local autoCloseStartDelay = totalRevealTime
            local autoCloseDuration = 30  -- 30 seconds countdown
            
            local autoCloseTimer = 0
            local autoCloseRemaining = autoCloseDuration
            
            if elapsed > autoCloseStartDelay then
                autoCloseTimer = elapsed - autoCloseStartDelay
                autoCloseRemaining = math.max(0, autoCloseDuration - autoCloseTimer)
                
                draw.DrawText(
                string.format(language.GetPhrase("uv.results.autoclose"), math.ceil(autoCloseRemaining)),
                "UVFont5UI", w * 0.795, h * 0.77,
                Color(debriefcolor.r, debriefcolor.g, debriefcolor.b, textAlpha),
                TEXT_ALIGN_RIGHT
            )
            
            if autoCloseRemaining <= 0 then
                hook.Remove("Think", "CheckJumpKeyForResults")
                if not closing then
                    surface.PlaySound( "uvui/mw/closemenu.wav" )
                    closing = true
                    closeStartTime = CurTime()
                end
            end
        else
            -- Before auto-close timer starts, show the text but no countdown
            draw.DrawText(
            string.format(language.GetPhrase("uv.results.autoclose"), autoCloseDuration),
            "UVFont5UI", w * 0.795, h * 0.77,
            Color(debriefcolor.r, debriefcolor.g, debriefcolor.b, textAlpha),
            TEXT_ALIGN_RIGHT
        )
    end
    if closing then
        local elapsed = curTime - closeStartTime
        if elapsed >= totalRevealTime then
            hook.Remove("Think", "CheckJumpKeyForResults")
            if IsValid(ResultPanel) then
                ResultPanel:Close()
            end
        end
    end
end

function OK:DoClick()
    if not closing then
        surface.PlaySound( "uvui/mw/closemenu.wav" )
        closing = true
        closeStartTime = CurTime()
    end
end

local wasJumping = false
hook.Add("Think", "CheckJumpKeyForDebrief", function()
    local ply = LocalPlayer()
    if not IsValid(ply) then return end
    
    if ply:KeyDown(IN_JUMP) then
        if not wasJumping and not closing then
            surface.PlaySound( "uvui/mw/closemenu.wav" )
            wasJumping = true
            closing = true
            closeStartTime = CurTime()
        end
    else
        wasJumping = false
    end
end)
end,

onRaceEnd = function( sortedRacers, stringArray )
    local triggerTime = CurTime()
    local duration = 10
	local glidetext = string.format( language.GetPhrase("uv.race.finished.viewstats"), '<color=0,162,255>'.. string.upper( input.GetKeyName( UVKeybindShowRaceResults:GetInt() ) ) ..'<color=255,255,255>')
	local glideicon = "unitvehicles/icons/INGAME_ICON_LEADERBOARD.png"
	
	-----------------------------------------

	if Glide then
		if not istable(sortedRacers) or #sortedRacers == 0 then
			glidetext = "#uv.race.finished.statserror"
			glideicon = "unitvehicles/icons/GENERIC_ALERT.png"
		end
			Glide.Notify({
				text = glidetext,
				lifetime = duration,
				immediate = true,
				icon = glideicon,
			}) 
	end
        
    hook.Add( "Think", "RaceResultDisplay", function()
        if CurTime() - triggerTime > duration then
            hook.Remove( 'Think', 'RaceResultDisplay' )
            return
        end
        
        if input.IsKeyDown( UVKeybindShowRaceResults:GetInt() ) and !gui.IsGameUIVisible() and vgui.GetKeyboardFocus() == nil then
            hook.Remove( 'Think', 'RaceResultDisplay' )
            -- _main()
            UV_UI.racing.mostwanted.events.ShowResults(sortedRacers)
        end
    end)
end,

notifState = {},
onLapComplete = function( participant, new_lap, old_lap, lap_time, lap_time_cur, is_local_player, is_global_best )
	local name = UVHUDRaceInfo.Participants[participant] and UVHUDRaceInfo.Participants[participant].Name or "Unknown"
	-- if is_local_player then
		-- name = "YOU"
	-- end

	if is_global_best then
		UV_UI.racing.mostwanted.states.LapCompleteText = string.format(language.GetPhrase("uv.race.fastest.laptime"), name, Carbon_FormatRaceTime( lap_time ) )
	else
		if is_local_player then
			UV_UI.racing.mostwanted.states.LapCompleteText = string.format(language.GetPhrase("uv.race.laptime"), Carbon_FormatRaceTime( lap_time ) )
		else
			return
		end
	end

	UV_UI.racing.mostwanted.events.notifState = {
		active = true,
		startTime = CurTime(),
		fadeStartTime = nil,

		phase1Duration = 2.5,
		fadeDuration = 0.3,
		startY = ScrH() * 0.325,
		midY = ScrH() * 0.4,
		finalY = ScrH() * 0.9,

		randomStart = Vector(math.Rand(ScrW() * 0.3, ScrW() * 0.6), math.Rand(ScrH() * 0.3, ScrH() * 0.5), 0),
		randomBurst1 = Vector(math.Rand(ScrW() * 0.3, ScrW() * 0.6), math.Rand(ScrH() * 0.3, ScrH() * 0.5), 0),
		randomBurst2 = Vector(math.Rand(ScrW() * 0.3, ScrW() * 0.6), math.Rand(ScrH() * 0.3, ScrH() * 0.5), 0),
		centerPos = Vector(ScrW() / 2, ScrH() * 0.275, 0),

		burstDuration = 0.025,
		burstDuration2 = 0.025,
		toCenterDuration = 0.1,
		holdDuration = 2.3,
	}


	local notifState = UV_UI.racing.mostwanted.events.notifState

	----------------------------------------------------------------------------

	if timer.Exists( 'MW_NOTIFICATION_LAP_TIMER' ) then timer.Remove( "MW_NOTIFICATION_LAP_TIMER" ) end 
	
	timer.Create( "MW_NOTIFICATION_LAP_TIMER", 3, 1, function()
		hook.Remove( "HUDPaint", "MW_NOTIFICATION_LAP" )
		notifState.active = false
	end)
	
	hook.Add("HUDPaint", "MW_NOTIFICATION_LAP", function()
		local now = CurTime()
		local elapsed = now - notifState.startTime
		local pos = Vector()
		local alpha = 255

		if elapsed < notifState.burstDuration then
			-- Phase 1: teleport at randomStart
			pos = notifState.randomStart

		elseif elapsed < notifState.burstDuration + notifState.burstDuration2 then
			-- Phase 2: teleport at randomBurst1
			pos = notifState.randomBurst1

		elseif elapsed < notifState.burstDuration + notifState.burstDuration2 + notifState.toCenterDuration then
			-- Phase 3: teleport at randomBurst2
			pos = notifState.randomBurst2

		elseif elapsed < notifState.burstDuration + notifState.burstDuration2 + notifState.toCenterDuration + notifState.holdDuration then
			-- Phase 4: gradual downward motion from midY to finalY (no fade)
			local holdElapsed = elapsed - (notifState.burstDuration + notifState.burstDuration2 + notifState.toCenterDuration)
			local t = math.Clamp(holdElapsed / notifState.holdDuration, 0, 1)
			pos = Vector(
				notifState.centerPos.x,
				Lerp(t, notifState.startY, notifState.midY),
				0
			)
			alpha = 255

		else
			-- Phase 5: smooth fall + fade (as before)
			if not notifState.fadeStartTime then
				notifState.fadeStartTime = now
			end

			local fadeElapsed = now - notifState.fadeStartTime
			local t = math.Clamp(fadeElapsed / notifState.fadeDuration, 0, 1)

			pos = Vector(
				notifState.centerPos.x,
				Lerp(t, notifState.midY, notifState.finalY),
				0
			)
			alpha = Lerp(t, 255, 0)
		end
		
		mw_noti_draw(UV_UI.racing.mostwanted.states.LapCompleteText, "UVFont5Shadow", pos.x, pos.y, Color(255, 255, 255, alpha))
		
		local baseAlphaFactor = alpha / 255  -- alpha is between 0 and 255, normalize to 0-1
		local iconblink = 150 * math.abs(math.sin(RealTime() * 8)) * baseAlphaFactor
		local iconDiffY = ScrH() * 0.055
		local iconStartY = notifState.startY - iconDiffY
		local iconY
		if not notifState.fadeStartTime then
			local t = math.Clamp(elapsed / notifState.phase1Duration, 0, 1)
			iconY = Lerp(t, iconStartY, notifState.midY - iconDiffY)
		else
			local fadeElapsed = now - notifState.fadeStartTime
			local fadeT = math.Clamp(fadeElapsed / notifState.fadeDuration, 0, 1)
			iconY = Lerp(fadeT, notifState.midY - iconDiffY, notifState.finalY - iconDiffY)
		end

		DrawIcon( UVMaterials['CLOCK'], ScrW() / 2, iconY, 0.06, Color(255, 255, 255, alpha) )
		DrawIcon( UVMaterials['GLOW_ICON'], ScrW() / 2, iconY, 0.1, Color(223, 184, 127, iconblink) )
	end)
end
}

UV_UI.pursuit.mostwanted.events = {
	notifState = {},
    onUnitTakedown = function( unitType, name, bounty, bountyCombo, isPlayer )
        UV_UI.pursuit.mostwanted.states.TakedownText = string.format( language.GetPhrase( "uv.hud.mw.takedown" ),
		isPlayer and language.GetPhrase( unitType ) or name, bounty, bountyCombo )

		UV_UI.pursuit.mostwanted.events.notifState = {
			active = true,
			startTime = CurTime(),
			fadeStartTime = nil,

			phase1Duration = 2.5,
			fadeDuration = 0.3,
			startY = ScrH() * 0.325,
			midY = ScrH() * 0.4,
			finalY = ScrH() * 0.9,

			randomStart = Vector(math.Rand(ScrW() * 0.3, ScrW() * 0.6), math.Rand(ScrH() * 0.3, ScrH() * 0.5), 0),
			randomBurst1 = Vector(math.Rand(ScrW() * 0.3, ScrW() * 0.6), math.Rand(ScrH() * 0.3, ScrH() * 0.5), 0),
			randomBurst2 = Vector(math.Rand(ScrW() * 0.3, ScrW() * 0.6), math.Rand(ScrH() * 0.3, ScrH() * 0.5), 0),
			centerPos = Vector(ScrW() / 2, ScrH() * 0.275, 0),

			burstDuration = 0.025,
			burstDuration2 = 0.025,
			toCenterDuration = 0.1,
			holdDuration = 2.3,
		}


		local notifState = UV_UI.pursuit.mostwanted.events.notifState

        ----------------------------------------------------------------------------

        if timer.Exists( 'MW_NOTIFICATION_TAKEDOWN_TIMER' ) then timer.Remove( "MW_NOTIFICATION_TAKEDOWN_TIMER" ) end 
        
        timer.Create( "MW_NOTIFICATION_TAKEDOWN_TIMER", 3, 1, function()
            hook.Remove( "HUDPaint", "MW_NOTIFICATION_TAKEDOWN" )
			notifState.active = false
        end)
        
		hook.Add("HUDPaint", "MW_NOTIFICATION_TAKEDOWN", function()
			local now = CurTime()
			local elapsed = now - notifState.startTime
			local pos = Vector()
			local alpha = 255

			if elapsed < notifState.burstDuration then
				-- Phase 1: teleport at randomStart
				pos = notifState.randomStart

			elseif elapsed < notifState.burstDuration + notifState.burstDuration2 then
				-- Phase 2: teleport at randomBurst1
				pos = notifState.randomBurst1

			elseif elapsed < notifState.burstDuration + notifState.burstDuration2 + notifState.toCenterDuration then
				-- Phase 3: teleport at randomBurst2
				pos = notifState.randomBurst2

			elseif elapsed < notifState.burstDuration + notifState.burstDuration2 + notifState.toCenterDuration + notifState.holdDuration then
				-- Phase 4: gradual downward motion from midY to finalY (no fade)
				local holdElapsed = elapsed - (notifState.burstDuration + notifState.burstDuration2 + notifState.toCenterDuration)
				local t = math.Clamp(holdElapsed / notifState.holdDuration, 0, 1)
				pos = Vector(
					notifState.centerPos.x,
					Lerp(t, notifState.startY, notifState.midY),
					0
				)
				alpha = 255

			else
				-- Phase 5: smooth fall + fade (as before)
				if not notifState.fadeStartTime then
					notifState.fadeStartTime = now
				end

				local fadeElapsed = now - notifState.fadeStartTime
				local t = math.Clamp(fadeElapsed / notifState.fadeDuration, 0, 1)

				pos = Vector(
					notifState.centerPos.x,
					Lerp(t, notifState.midY, notifState.finalY),
					0
				)
				alpha = Lerp(t, 255, 0)
			end

			mw_noti_draw(UV_UI.pursuit.mostwanted.states.TakedownText, "UVFont5Shadow", pos.x, pos.y, Color(255, 255, 255, alpha))
			
			local baseAlphaFactor = alpha / 255  -- alpha is between 0 and 255, normalize to 0-1
			local iconblink = 150 * math.abs(math.sin(RealTime() * 8)) * baseAlphaFactor
			local iconDiffY = ScrH() * 0.045
			local iconStartY = notifState.startY - iconDiffY
			local iconY
			if not notifState.fadeStartTime then
				local t = math.Clamp(elapsed / notifState.phase1Duration, 0, 1)
				iconY = Lerp(t, iconStartY, notifState.midY - iconDiffY)
			else
				local fadeElapsed = now - notifState.fadeStartTime
				local fadeT = math.Clamp(fadeElapsed / notifState.fadeDuration, 0, 1)
				iconY = Lerp(fadeT, notifState.midY - iconDiffY, notifState.finalY - iconDiffY)
			end

			DrawIcon( UVMaterials['UNITS_DISABLED'], ScrW() / 2, iconY, 0.06, Color(255, 255, 255, alpha) )
			DrawIcon( UVMaterials['GLOW_ICON'], ScrW() / 2, iconY, 0.1, Color(223, 184, 127, iconblink) )
		end)
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
    
    ShowDebrief = function(params) -- Most Wanted
        if UVHUDDisplayRacing then return end
        
        local debriefdata = params.dataTable or escapedtable
        local debriefcolor = params.color or Color(255, 183, 61)
        local debrieftextcolor = params.textcolor or Colors.MW_Racer
        local debrieficon = params.iconMaterial or UVMaterials['RESULTCOP']
        local debrieftitletext = params.titleText or "Title Text"
        
        local w = ScrW()
        local h = ScrH()
        
        --------------------------------------
        
        local time = UVDisplayTime(UVTimerProgress)
        local unit = debriefdata["Unit"] or "Officer Replace Me"
        local deploys = debriefdata["Deploys"]
        local roadblocksdodged = debriefdata["Roadblocks"]
        local spikestripsdodged = debriefdata["Spikestrips"]
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
        
        OK:SetText("")
        OK:SetPos(w*0.205, h*0.77)
        OK:SetSize(w*0.205, h*0.0425)
		OK.Paint = function() end
        
        local timestart = CurTime()
        
        local revealStartTime = CurTime()
        local displaySequence = {}
        
        -- Data and labels
        local infoLabels = {
            { label = "#uv.results.chase.bounty", value = bounty },
            { label = "#uv.results.chase.time", value = time },
            { label = "#uv.results.chase.units.deployed", value = deploys },
            { label = "#uv.results.chase.units.damaged", value = tags },
            { label = "#uv.results.chase.units.destroyed", value = wrecks },
            { label = "#uv.results.chase.dodged.blocks", value = roadblocksdodged },
            { label = "#uv.results.chase.dodged.spikes", value = spikestripsdodged }
        }
        
        -- Build the sequence including empty tabs to keep layout intact
        local h1, h2 = h*0.2475, h*0.2875
        local xLeft = w * 0.205
        local xRight = w * 0.795
        local revealInterval = 0.033
        
        for i = 1, 13 do -- Total of 13 tabs
            local revealTime = revealStartTime + (i - 1) * revealInterval
            
            -- Alternate h1 and h2 for staggered layout
            local yPos = (i % 2 == 1) and h1 + math.floor(i / 2) * h * 0.08 or h2 + math.floor((i - 1) / 2) * h * 0.08
            local entry = {
                y = yPos,
                leftText = infoLabels[i] and infoLabels[i].label or nil,
                rightText = infoLabels[i] and tostring(infoLabels[i].value) or nil,
                revealTime = revealTime
            }
            table.insert(displaySequence, entry)
        end
        
        local flashDuration = 0.2 -- total time for flash animation
        local flashStartTime = nil
        local allRevealed = false
        
        local closing = false
        local closeStartTime = 0
        
        local totalRevealTime = (revealInterval * 13) + flashDuration
        
        ResultPanel.Paint = function(self, w, h)
            local curTime = CurTime()
            
            -- Check if all rows revealed
            local allEntriesRevealed = true
            for i, entry in ipairs(displaySequence) do
                if curTime < entry.revealTime then
                    allEntriesRevealed = false
                    break
                end
            end
            
            if allEntriesRevealed and not flashStartTime then
                flashStartTime = curTime
            end
            
            local flashProgress = flashStartTime and math.min((curTime - flashStartTime) / flashDuration, 1) or 0
            
            local textAlpha = 0
            local tabAlpha = 50
            
            if flashStartTime then
                if not closing then
                    textAlpha = Lerp(flashProgress, 0, 255)
                    if flashProgress < 0.5 then
                        tabAlpha = Lerp(flashProgress / 0.5, 0, 255)
                    else
                        tabAlpha = Lerp((flashProgress - 0.5) / 0.5, 255, 50)
                    end
                else
                    -- Reverse flash alpha during closing
                    textAlpha = Lerp(flashProgress, 255, 0)
                    if flashProgress < 0.5 then
                        tabAlpha = Lerp(flashProgress / 0.5, 50, 255)
                    else
                        tabAlpha = Lerp((flashProgress - 0.5) / 0.5, 255, 0)
                    end
                end
            end
            local blackBgAlpha = 0
            
            if not closing then
                -- Opening: ramp up to 235 in 0.05s
                local fadeInDuration = 0.05
                local elapsedSinceStart = curTime - timestart
                blackBgAlpha = Lerp(math.min(elapsedSinceStart / fadeInDuration, 1), 0, 235)
            else
                -- Closing: hold 235 until last 0.1s, then fade to 0
                local fadeOutDuration = 0.1
                local timeSinceCloseStart = curTime - closeStartTime
                local timeLeft = totalRevealTime - timeSinceCloseStart
                
                if timeLeft <= fadeOutDuration then
                    -- fade out from 235 to 0 in last 0.1 seconds
                    blackBgAlpha = Lerp(timeLeft / fadeOutDuration, 0, 235)
                else
                    blackBgAlpha = 235
                end
            end
            
            -- Main black background
            surface.SetDrawColor(0, 0, 0, blackBgAlpha)
            surface.DrawRect(0, 0, w, h)
            
            -- Draw rows and alternating backgrounds fully visible when revealed
            local xLeft = w * 0.2125
            local xRight = w * 0.7875
            local hStep = h * 0.04
            local elapsed, revealProgress, flashProgress, entriesToShow
            local entriesCount = #displaySequence
            
            if closing then
                elapsed = curTime - closeStartTime
                revealProgress = math.Clamp(1 - (elapsed / totalRevealTime), 0, 1)
                flashProgress = math.Clamp(revealProgress * (flashDuration / totalRevealTime), 0, 1)
                
                -- Calculate how many entries should still be visible (from the start)
                entriesToShow = math.ceil(entriesCount * revealProgress)
            else
                elapsed = curTime - revealStartTime
                revealProgress = math.Clamp(elapsed / (totalRevealTime - flashDuration), 0, 1)
                flashProgress = flashStartTime and math.min((curTime - flashStartTime) / flashDuration, 1) or 0
                
                entriesToShow = math.floor(entriesCount * revealProgress)
            end
            
            for i = 1, entriesCount do
                local drawEntry = false
                
                if closing then
                    -- When closing, show only the first 'entriesToShow' entries (reverse reveal)
                    drawEntry = i <= entriesToShow
                else
                    -- When opening, show up to entriesToShow
                    drawEntry = i <= entriesToShow
                end
                
                if drawEntry then
                    local entry = displaySequence[i]
                    local isEven = i % 2 == 0
                    
                    if isEven then
                        surface.SetDrawColor(0, 0, 0, 50) -- black background
                    else
                        surface.SetDrawColor(debriefcolor.r, debriefcolor.g, debriefcolor.b, 25) -- orange background
                    end
                    surface.DrawRect(w * 0.2, entry.y, w * 0.6, hStep)
                    
                    if entry.leftText then
                        draw.SimpleText(entry.leftText, "UVFont5UI", xLeft, entry.y, Color(debrieftextcolor.r, debrieftextcolor.g, debrieftextcolor.b), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                    end
                    if entry.rightText then
                        draw.SimpleText(entry.rightText, "UVFont5UI", xRight, entry.y, Color(debrieftextcolor.r, debrieftextcolor.g, debrieftextcolor.b), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
                    end
                end
            end
            
            if flashStartTime then
                -- Top tab background flash
                surface.SetDrawColor(debriefcolor.r, debriefcolor.g, debriefcolor.b, tabAlpha)
                surface.DrawRect(w * 0.2, h * 0.1225, w * 0.6, h * 0.075)
                
                -- Upper-middle background flash (same alpha as tabs)
                surface.SetMaterial(UVMaterials['BACKGROUND_BIGGER'])
                surface.SetDrawColor(debriefcolor.r, debriefcolor.g, debriefcolor.b, tabAlpha)
                surface.DrawTexturedRect(w * 0.2, h * 0.1975, w * 0.6, h * 0.05)
                
                -- Bottom tab background flash
                surface.SetDrawColor(debriefcolor.r, debriefcolor.g, debriefcolor.b, tabAlpha)
                surface.SetMaterial(Material("unitvehicles/hud/bg_anim"))
                surface.DrawTexturedRect(w * 0.2, h * 0.7725, w * 0.6, h * 0.04)
                
                -- Icon and texts fade in (stay full alpha after flash)
                DrawIcon(debrieficon, w * 0.225, h * 0.1575, .05, Color(debriefcolor.r, debriefcolor.g, debriefcolor.b, textAlpha))
                draw.DrawText("#uv.results.pursuit", "UVFont5", w * 0.25, h * 0.1375, Color(debriefcolor.r, debriefcolor.g, debriefcolor.b, textAlpha), TEXT_ALIGN_LEFT)
                
                draw.DrawText(debrieftitletext, "UVFont5", w * 0.5, h * 0.2, Color(255, 255, 255, textAlpha), TEXT_ALIGN_CENTER)
                
                draw.DrawText("[ " .. input.LookupBinding("+jump") .. " ] " .. language.GetPhrase("uv.results.continue"), "UVFont5UI", w * 0.205, h * 0.77, Color(debriefcolor.r, debriefcolor.g, debriefcolor.b, textAlpha), TEXT_ALIGN_LEFT)
            end
            
            -- Show/Hide OK button with fade
            if flashStartTime then
                if textAlpha > 0 then
                    OK:SetEnabled(true)
                end
            else
                OK:SetEnabled(false)
            end
            
            -- Time since panel was created
            local elapsed = CurTime() - timestart
            
            -- Only start auto-close countdown after reveal + flash
            local autoCloseStartDelay = totalRevealTime
            local autoCloseDuration = 30  -- 30 seconds countdown
            
            local autoCloseTimer = 0
            local autoCloseRemaining = autoCloseDuration
            
            if elapsed > autoCloseStartDelay then
                autoCloseTimer = elapsed - autoCloseStartDelay
                autoCloseRemaining = math.max(0, autoCloseDuration - autoCloseTimer)
                
                draw.DrawText(
                string.format(language.GetPhrase("uv.results.autoclose"), math.ceil(autoCloseRemaining)),
                "UVFont5UI", w * 0.795, h * 0.77,
                Color(debriefcolor.r, debriefcolor.g, debriefcolor.b, textAlpha),
                TEXT_ALIGN_RIGHT
            )
            
            if autoCloseRemaining <= 0 then
                hook.Remove("Think", "CheckJumpKeyForDebrief")
                surface.PlaySound( "uvui/mw/closemenu.wav" )
                if not closing then
                    closing = true
                    closeStartTime = CurTime()
                end
            end
        else
            -- Before auto-close timer starts, show the text but no countdown
            draw.DrawText(
            string.format(language.GetPhrase("uv.results.autoclose"), autoCloseDuration),
            "UVFont5UI", w * 0.795, h * 0.77,
            Color(debriefcolor.r, debriefcolor.g, debriefcolor.b, textAlpha),
            TEXT_ALIGN_RIGHT
        )
    end
    if closing then
        local elapsed = curTime - closeStartTime
        if elapsed >= totalRevealTime then
            hook.Remove("Think", "CheckJumpKeyForDebrief")
            if IsValid(ResultPanel) then
                ResultPanel:Close()
            end
        end
    end
end

function OK:DoClick()
    surface.PlaySound( "uvui/mw/closemenu.wav" )
    if not closing then
        closing = true
        closeStartTime = CurTime()
    end
end

local wasJumping = false
hook.Add("Think", "CheckJumpKeyForDebrief", function()
    local ply = LocalPlayer()
    if not IsValid(ply) then return end
    
    if ply:KeyDown(IN_JUMP) then
        if not wasJumping and not closing then
            surface.PlaySound( "uvui/mw/closemenu.wav" )
            wasJumping = true
            closing = true
            closeStartTime = CurTime()
        end
    else
        wasJumping = false
    end
end)
end,

onRacerEscapedDebrief = function(escapedtable)
    local params = {
        dataTable = escapedtable,
        color = Color(255, 183, 61),
        iconMaterial = UVMaterials['RESULTCOP'],
        titleText = "#uv.results.escapedfrom",
    }
    UV_UI.pursuit.mostwanted.events.ShowDebrief(params)
end,

onRacerBustedDebrief = function(bustedtable)
    local params = {
        dataTable = bustedtable,
        color = Color(255, 183, 61),
        iconMaterial = UVMaterials['RESULTCOP'],
        titleText = string.format( language.GetPhrase("uv.results.bustedby"), bustedtable["Unit"] ),
    }
    UV_UI.pursuit.mostwanted.events.ShowDebrief(params)
end,

onCopBustedDebrief = function(bustedtable)
    local params = {
        dataTable = bustedtable,
        color = Color(61, 183, 255),
        textcolor = Color(142, 221, 255, 107),
        iconMaterial = UVMaterials['RESULTCOP'],
        titleText = string.format( language.GetPhrase("uv.results.suspects.busted"), bustedtable["Unit"] ),
    }
    UV_UI.pursuit.mostwanted.events.ShowDebrief(params)
end,

onCopEscapedDebrief = function(escapedtable)
    local params = {
        dataTable = escapedtable,
        color = Color(61, 183, 255),
        textcolor = Color(142, 221, 255, 107),
        iconMaterial = UVMaterials['RESULTCOP'],
        titleText = string.format(language.GetPhrase("uv.results.suspects.escaped.num"), UVHUDWantedSuspectsNumber)
    }
    UV_UI.pursuit.mostwanted.events.ShowDebrief(params)
end,
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
        local racercount = i * w * 0.01407
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
    if UVHUDDisplayRacing then return end
    
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
                UVBustingProgress = UVClosestSuspect.uvbustingprogress or 0
                
                local blink = 255 * math.abs(math.sin(RealTime() * 8))
                states.BustedColor = Color(255, blink, blink)
            end
        end
    end
    
    --if not UVHUDRace then
    local ResourceText = UVResourcePoints
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
    
    local milestoneamount = 0
    local milestoneh = 0
    
    if milestoneamount > 0 and not UVHUDCopMode then
        surface.SetDrawColor(0, 0, 0, 150) -- Milestone BG
        surface.DrawRect(w * 0.71, h * 0.215, w * 0.2575, h * 0.035)
        
        draw.DrawText("#uv.hud.milestones","UVFont5UI",w * 0.7125,h * 0.2125,Color(255, 255, 255),TEXT_ALIGN_LEFT) -- Bounty Text
        draw.DrawText(milestoneamount, "UVFont5UI", w * 0.965, h * 0.2125, Color(255, 255, 255), TEXT_ALIGN_RIGHT) -- Bounty Counter
        
        for i = 1, math.min(milestoneamount, 5) do
            surface.SetDrawColor(223, 184, 127, 150) -- Milestone Icon BG's
            surface.DrawRect(w * 0.71 + (i - 1) * (w * 0.05175), h * 0.25, w * 0.05075, h * 0.065)
            DrawIcon(UVMaterials["CLOCK_BG"], w * 0.735 + (i - 1) * (w * 0.05175), h * 0.28, .075, Color(255, 255, 255, 100))
        end
        milestoneh = h * 0.1025
    end
    
    -- Timer
    DrawIcon(UVMaterials["CLOCK"], w * 0.735, h * 0.1325, .0625, UVHUDCopMode and Colors.MW_Cop or Colors.MW_Accent) -- Icon
    draw.DrawText(UVTimer, "UVFont5UI", w * 0.965, h * 0.115, UVHUDCopMode and Colors.MW_Cop or Colors.MW_Accent, TEXT_ALIGN_RIGHT)
    
    -- Bounty
    draw.DrawText("#uv.hud.bounty","UVFont5UI",w * 0.7175,h * 0.1625,Color(255, 255, 255),TEXT_ALIGN_LEFT) -- Bounty Text
    draw.DrawText(UVBounty, "UVFont5UI", w * 0.965, h * 0.1625, Color(255, 255, 255), TEXT_ALIGN_RIGHT) -- Bounty Counter
    
    -- Heat Level
    surface.SetDrawColor(0, 0, 0, 200)
    surface.DrawRect(w * 0.71, h * 0.2175 + milestoneh, w * 0.036, h * 0.035)
    
    -- if UVHeatLevel == 1 then
    --     UVHeatBountyMin = UVUHeatMinimumBounty1:GetInt()
    --     UVHeatBountyMax = UVUHeatMinimumBounty2:GetInt()
    -- elseif UVHeatLevel == 2 then
    --     UVHeatBountyMin = UVUHeatMinimumBounty2:GetInt()
    --     UVHeatBountyMax = UVUHeatMinimumBounty3:GetInt()
    -- elseif UVHeatLevel == 3 then
    --     UVHeatBountyMin = UVUHeatMinimumBounty3:GetInt()
    --     UVHeatBountyMax = UVUHeatMinimumBounty4:GetInt()
    -- elseif UVHeatLevel == 4 then
    --     UVHeatBountyMin = UVUHeatMinimumBounty4:GetInt()
    --     UVHeatBountyMax = UVUHeatMinimumBounty5:GetInt()
    -- elseif UVHeatLevel == 5 then
    --     UVHeatBountyMin = UVUHeatMinimumBounty5:GetInt()
    --     UVHeatBountyMax = UVUHeatMinimumBounty6:GetInt()
    -- elseif UVHeatLevel == 6 then
    --     UVHeatBountyMin = UVUHeatMinimumBounty6:GetInt()
    --     UVHeatBountyMax = math.huge
    -- end
    
    local UVHeatMinConVar = GetConVar( 'unitvehicle_unit_heatminimumbounty' .. UVHeatLevel )
    local UVHeatMaxConVar = GetConVar( 'unitvehicle_unit_heatminimumbounty' .. UVHeatLevel + 1 )
    
    UVHeatBountyMin = ( UVHeatMinConVar and UVHeatMinConVar:GetInt() ) or math.huge
    UVHeatBountyMax = ( UVHeatMaxConVar and UVHeatMaxConVar:GetInt() ) or math.huge
    
    DrawIcon(UVMaterials["HEAT"], w * 0.7175, h * 0.2325 + milestoneh, .0375, Color(255, 255, 255)) -- Icon
    draw.DrawText(UVHeatLevel, "UVFont5UI", w * 0.733, h * 0.214 + milestoneh, Color(255, 255, 255), TEXT_ALIGN_CENTER)
    
    surface.SetDrawColor(Color(109, 109, 109, 200))
    surface.DrawRect(w * 0.7475, h * 0.2175 + milestoneh, w * 0.22, h * 0.035)
    surface.SetDrawColor(Color(255, 255, 255))
    local HeatProgress = 0
    if MaxHeatLevel:GetInt() ~= UVHeatLevel then
        if UVUTimeTillNextHeatEnabled:GetInt() == 1 and UVTimeTillNextHeat then --Time till next heat level
            local timedHeatConVar = GetConVar( 'unitvehicle_unit_timetillnextheat' .. UVHeatLevel )
            
            local maxtime = timedHeatConVar:GetInt()
            HeatProgress = (maxtime - UVTimeTillNextHeat) / maxtime
        else
            HeatProgress = ((UVBountyNo - UVHeatBountyMin) / (UVHeatBountyMax - UVHeatBountyMin))
        end
    end
    local B = math.Clamp((HeatProgress) * w * 0.22, 0, w * 0.22)
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
    
    surface.DrawRect(w * 0.7475, h * 0.2175 + milestoneh, B, h * 0.035)
    
    -- [[ Commander Stuff ]]
    if UVOneCommanderActive then
        ResourceText = "⛊"
        
        surface.SetDrawColor(0, 0, 0, 200) -- Milestone BG
        surface.DrawRect(w * 0.71, h * 0.26 + milestoneh, w * 0.2575, h * 0.035)
        
        draw.DrawText("⛊","UVFont5UI-BottomBar",w * 0.71, h * 0.2525 + milestoneh, UVHUDCopMode and Colors.MW_Cop or Colors.MW_Accent,TEXT_ALIGN_LEFT)
        draw.DrawText("⛊","UVFont5UI-BottomBar",w * 0.965, h * 0.2525 + milestoneh, UVHUDCopMode and Colors.MW_Cop or Colors.MW_Accent,TEXT_ALIGN_RIGHT)
        
        local cname = "#uv.unit.commander"
        if IsValid(UVHUDCommander) then
            local driver = UVHUDCommander:GetDriver()
            if IsValid(driver) and driver:IsPlayer() then
                cname = driver:Nick()
            end
        end
        
        draw.DrawText(cname,"UVFont5UI-BottomBar",w * 0.8375, h * 0.255 + milestoneh, UVHUDCopMode and Colors.MW_Cop or Colors.MW_Accent,TEXT_ALIGN_CENTER)
        
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
        local blink = 255 * math.abs(math.sin(RealTime() * 4))
        local blink2 = 255 * math.abs(math.sin(RealTime() * 6))
        local blink3 = 255 * math.abs(math.sin(RealTime() * 8))
        
        if healthratio >= 0.5 then
            healthcolor = Color(255, 255, 255, 200)
        elseif healthratio >= 0.25 then
            healthcolor = Color(255, blink, blink, 200)
        else
            healthcolor = Color(255, blink2, blink2, 200)
        end
        if healthratio > 0 then
            surface.SetDrawColor(Color(109, 109, 109, 200))
            surface.DrawRect(w * 0.71, h * 0.294 + milestoneh, w * 0.2575, h * 0.0125)
            surface.SetDrawColor(healthcolor)
            local T = math.Clamp((healthratio) * (w * 0.2575), 0, w * 0.2575)
            surface.DrawRect(w * 0.71, h * 0.294 + milestoneh, T, h * 0.0125)
        end
    end
    
    -- [ Bottom Info Box ] --
    local middlergb = {
        r = 255,
        g = 255,
        b = 255,
        a = 255 * math.abs(math.sin(RealTime() * 4))
    }
    
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
        surface.DrawRect(w * 0.333, h * 0.9, w * 0.34, h * 0.01)
        
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
            surface.DrawRect(w * 0.333 + (w * 0.1515 - T), h * 0.9, T, h * 0.01)
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
            surface.DrawRect(w * 0.51, h * 0.9, T, h * 0.01)
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
        surface.DrawRect(w * 0.49, h * 0.9, w * 0.021, h * 0.01)
        
        -- Evade Box, Dividers
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawRect(w * 0.485, h * 0.9, w * 0.005, h * 0.01)
        surface.DrawRect(w * 0.4, h * 0.9, w * 0.005, h * 0.01)
        
        surface.DrawRect(w * 0.51, h * 0.9, w * 0.005, h * 0.01)
        surface.DrawRect(w * 0.6, h * 0.9, w * 0.005, h * 0.01)
        
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
        
        draw.DrawText(lbtext,"UVFont5UI", w * 0.5, h * 0.91 * 1.001,UVBackupColor,TEXT_ALIGN_CENTER)
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
                local blink = 255 * math.Clamp(math.abs(math.sin(RealTime())), .7, 1)
                
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
    --end
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
	
    TakedownText = nil,
}

UV_UI.racing.undercover.states = {
    LapCompleteText = nil,
}

UV_UI.racing.undercover.events = {
    ShowResults = function(sortedRacers) -- Undercover
        if UVHUDDisplayRacing then return end
        
        local w = ScrW()
        local h = ScrH()
        
        --------------------------------------
        
        local debrieflinedata
        
        local BackgroundPanel = vgui.Create("DPanel")
        local ResultPanel = vgui.Create("DFrame")
        local OK = vgui.Create("DButton")
        
        BackgroundPanel:SetSize(w, h)
        BackgroundPanel:SetZPos(0)
        
        ResultPanel:Add(OK)
        ResultPanel:SetSize(w, h)
        ResultPanel:SetBackgroundBlur(true)
        ResultPanel:ShowCloseButton(false)
        ResultPanel:Center()
        ResultPanel:SetTitle("")
        ResultPanel:SetDraggable(false)
        ResultPanel:MakePopup()
        ResultPanel:SetKeyboardInputEnabled(false)
        ResultPanel:SetVisible(false)
        
        OK:SetText("")
        OK:SetPos(w*0.5, h*0.745)
        OK:SetSize(w*0.16, h*0.06)
		OK:SetEnabled(true)
        OK.Paint = function() end
        
        local fadeStart = CurTime()
        local backgroundAlpha = 0
        local backgroundFadeDuration = 0.5  -- seconds
        local fadeComplete = false
        
        local function CloseResults()
            if IsValid(ResultPanel) then ResultPanel:Close() end
            if IsValid(BackgroundPanel) then BackgroundPanel:Remove() end
            hook.Remove("Think", "CheckJumpKeyForResults")
        end
        
        local closing = false
        local closeStart = 0
        local closeDuration = 0.5
        
        local zoomStart = CurTime() + backgroundFadeDuration
        local zoomDuration = 0.5
        local rowDelay = 0.15
        local numTotalRows = 16
        
        local autoCloseDelay = 30
        local animationStartTime = CurTime()
        local autoCloseStartTime = animationStartTime + ((numTotalRows - 1) * rowDelay) + zoomDuration
        
        -- Then your timer start time:
        local timestart = autoCloseStartTime
        
        local function startCloseAnimation()
            if closing then return end
            closing = true
            closeStart = CurTime()
        end
        
        BackgroundPanel.Paint = function(self, w, h)
            local elapsed = CurTime() - fadeStart
            local alpha
            
            if not fadeComplete then
                alpha = math.min(175, (elapsed / backgroundFadeDuration) * 175)
                if alpha >= 175 then
                    fadeComplete = true
                    if IsValid(ResultPanel) then
                        ResultPanel:SetVisible(true)
                    end
                end
            elseif closing then
                local fadeOutElapsed = CurTime() - closeStart
                alpha = math.max(0, 175 * (1 - (fadeOutElapsed / closeDuration)))
            else
                alpha = 175
            end
            
            backgroundAlpha = alpha
            surface.SetDrawColor(5, 25, 150, backgroundAlpha)
            surface.DrawRect(0, 0, w, h)
        end
        
        local entriesToShow = 16
        local scrollOffset = 0
        
        ResultPanel.OnMouseWheeled = function(self, delta)
            local maxOffset = math.max(0, #sortedRacers - entriesToShow)
            scrollOffset = math.Clamp(scrollOffset - delta, 0, maxOffset)
        end
        
        local racersArray = {}
        
        -- Convert sortedRacers (whatever form) to a flat array if needed
        for _, racer in pairs(sortedRacers) do
            table.insert(racersArray, racer)
        end
        
        -- Sort by TotalTime (DNF = math.huge)
        table.sort(racersArray, function(a, b)
            local timeA = a.array and a.array.TotalTime
            local timeB = b.array and b.array.TotalTime
            
            -- Treat missing or non-numeric TotalTime as a large number (DNF)
            local tA = (type(timeA) == "number") and timeA or math.huge
            local tB = (type(timeB) == "number") and timeB or math.huge
            
            return tA < tB
        end)
        
        local racersDisplayData = {}
        
        for i = 1, #racersArray do
            local racer = racersArray[i]
            local info = racer.array or racer  -- fallback if 'array' doesn't exist
            local LBCol = Color(255, 255, 255)
            
            local name = info["Name"] or "Unknown"
            local totalTime = info["TotalTime"] and info["TotalTime"] or "#uv.race.suffix.dnf"
            
            if info["Busted"] then totalTime = "#uv.race.suffix.busted" end
            
            if info["LocalPlayer"] then
                LBCol = Color(255, 200, 50)
            end
            
            -- Combine pos and name for left column text
            local text = i .. "    " .. name
            
            table.insert(racersDisplayData, { text = text, value = UV_FormatRaceEndTime(totalTime), color = LBCol })
        end
        
        -- Now assign this to the data your paint function uses:
        debrieflinedata = {}
        
        -- Fill with racer data for existing racers
        for i = 1, math.min(#racersDisplayData, numTotalRows) do
            debrieflinedata[i] = racersDisplayData[i]
        end
        
        -- Fill remaining rows with empty placeholders
        for i = #racersDisplayData + 1, numTotalRows do
            debrieflinedata[i] = { text = "", value = "", color = Color(255,255,255) }
        end
        
        local statusString = "#uv.results.lost" -- default fallback
        
        local localIndex = nil
        local localTime = nil
        local secondPlaceTime = nil
        
        for i, info in ipairs(racersArray) do
            local racer = racersArray[i]
            local info = racer.array or racer  -- fallback if 'array' doesn't exist
            
            if info["LocalPlayer"] then
				localIndex = i
				localTime = tonumber(info["TotalTime"]) or math.huge
            elseif i == 2 then
                secondPlaceTime = tonumber(info["TotalTime"]) or math.huge
            end
        end
        
        if localIndex == 1 then
            local timeDiff = (secondPlaceTime or 0) - (localTime or 0)
            if timeDiff >= 10 then
                statusString = "#uv.results.dominated"
            else
                statusString = "#uv.results.won"
            end
        end
        
        ResultPanel.Paint = function(self, w, h)
            local now = CurTime()
            
            local zoomElapsed = closing and (now - closeStart) or (now - zoomStart)
            local zoomFrac = math.Clamp(zoomElapsed / zoomDuration, 0, 1)
            
            local function easeOutCubic(t) return 1 - (1 - t)^3 end
            local function easeInCubic(t) return t^3 end
            
            local easedFrac = closing and easeInCubic(zoomFrac) or easeOutCubic(zoomFrac)
            local zoomScale = Lerp(easedFrac, closing and 1.0 or 2.0, closing and 2.0 or 1.0)
            local panelAlpha = closing and (1 - easedFrac) or 1
            
            if closing and zoomFrac >= 1 then
                CloseResults()
                return
            end
            
            local mat = Matrix()
            mat:Translate(Vector(w*0.5, h*0.5, 0))
            mat:Scale(Vector(zoomScale, zoomScale, 1))
            mat:Translate(Vector(-(w*0.5), -(h*0.5), 0))
            
            local tabAlpha = math.floor(panelAlpha * 235)
            local textAlpha = math.floor(panelAlpha * 255)
            
            cam.Start2D()
            cam.PushModelMatrix(mat)
            local timeremaining = math.ceil(autoCloseDelay - (CurTime() - timestart))
            local lang = language.GetPhrase
            
            -- Upper Results Tab
            surface.SetDrawColor( 0, 0, 0, tabAlpha )
            surface.DrawRect( w*0.33, h*0.15, w*0.33, h*0.06)
            
            draw.DrawText(statusString, "UVUndercoverWhiteFont", w*0.332, h*0.155, Color( 255, 200, 50, textAlpha ), TEXT_ALIGN_LEFT )
            
            -- Text
            local rowYOffsetBase = h * 0.21
            local rowYOffsetBaseAlt = h * (0.21 + 0.0325)
            
            local labelStartX, valueStartX = w * 0.25, w * 0.75 -- Offscreen starting points
            local labelTargetX, valueTargetX = w * 0.332, w * 0.6575
            
            for i = 1, numTotalRows do
                local rowStartTime = zoomStart + zoomDuration + (i - 1) * rowDelay
                local rowEndTime = rowStartTime + rowDelay
                local rowProgress = math.Clamp((CurTime() - rowStartTime) / rowDelay, 0, 1)
                local ease = 1 - math.pow(1 - rowProgress, 2)
                
                local isDark = i % 2 == 0
                local baseAlpha = isDark and 150 or 75
                local rowColor = isDark and Color(50, 50, 50) or Color(150, 150, 150)
                
                local yOffset = ((i % 2 == 1) and rowYOffsetBase or rowYOffsetBaseAlt) + math.floor((i - 1) / 2) * h * 0.0675
                local rowHeight = h * 0.035
                local rowWidth = w * 0.33
                local rowX = w * 0.33
                local halfWidth = rowWidth / 2
                local alpha = ease * baseAlpha * panelAlpha
                
                -- Animate left half
                local leftX = Lerp(ease, labelStartX, rowX)
                surface.SetDrawColor(rowColor.r, rowColor.g, rowColor.b, alpha)
                surface.DrawRect(leftX, yOffset, halfWidth + (h * 0.001), rowHeight)
                
                -- Animate right half
                local rightX = Lerp(ease, valueStartX, rowX + halfWidth)
                surface.DrawRect(rightX, yOffset, halfWidth, rowHeight)
            end
            
            for i = 1, entriesToShow do
                local dataIndex = i + scrollOffset
                local line = debrieflinedata[dataIndex]
                if not line then continue end -- Skip if no data for this row
                
                local rowStartTime = zoomStart + zoomDuration + (dataIndex - 1) * rowDelay
                local rowProgress = math.Clamp((CurTime() - rowStartTime) / rowDelay, 0, 1)
                local alpha = rowProgress * 255
                local ease = 1 - math.pow(1 - rowProgress, 2) -- smooth end
                
                local yOffset = ((i % 2 == 1) and rowYOffsetBase or rowYOffsetBaseAlt) + math.floor((i - 1) / 2) * h * 0.0675
                
                local labelX = Lerp(ease, labelStartX, labelTargetX)
                local valueX = Lerp(ease, valueStartX, valueTargetX)
                
                draw.SimpleText(line.text, "UVUndercoverAccentFont", labelX, yOffset - (h * 0.0025),
                Color(line.color.r, line.color.g, line.color.b, alpha * panelAlpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                draw.SimpleText(tostring(line.value), "UVUndercoverAccentFont", valueX, yOffset - (h * 0.0025),
                Color(line.color.r, line.color.g, line.color.b, alpha * panelAlpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            end

            -- Time remaining and closing					
            surface.SetDrawColor( 0, 0, 0, tabAlpha )
            surface.DrawRect( w*0.33, h*0.745, w*0.33, h*0.06)
            
            if timeremaining > autoCloseDelay then
                timeremaining = autoCloseDelay
            end
            
            local blink = 255 * math.abs(math.sin(RealTime() * 8))
            
            if scrollOffset > 0 then
                draw.SimpleText("▲", "UVFont5UI", w * 0.5, h * 0.1775, Color(255,255,255,blink), TEXT_ALIGN_CENTER)
            end
            
            if scrollOffset < #sortedRacers - entriesToShow then
                draw.SimpleText("▼", "UVFont5UI", w * 0.5, h * 0.7375, Color(255,255,255,blink), TEXT_ALIGN_CENTER)
            end
            
            draw.DrawText( lang("uv.results.continue") .. " [" .. input.LookupBinding("+jump") .. "]", "UVUndercoverAccentFont", w*0.6575, h*0.755, Color( 255, 255, 255, textAlpha ), TEXT_ALIGN_RIGHT )
            draw.DrawText( string.format( lang("uv.results.autoclose"), math.max(0, timeremaining) ), "UVUndercoverLeaderboardFont", w*0.332, h*0.755, Color( 255, 255, 255, textAlpha ), TEXT_ALIGN_LEFT )
            
            if timeremaining < 1 then
                startCloseAnimation()
            end
            
            cam.PopModelMatrix()
            cam.End2D()
        end
        
        function OK:DoClick() 
			startCloseAnimation()
			OK:SetEnabled(false)
        end
        
        local wasJumping = false
        hook.Add("Think", "CheckJumpKeyForResults", function()
            local ply = LocalPlayer()
            if not IsValid(ply) then return end
            
            if ply:KeyDown(IN_JUMP) then
                if not wasJumping then
                    wasJumping = true
                    if IsValid(ResultPanel) then
                        startCloseAnimation()
                    end
                end
            else
                wasJumping = false
            end
        end)
    end,
    
    onRaceEnd = function( sortedRacers, stringArray )
        local triggerTime = CurTime()
        local duration = 10
		local glidetext = string.format( language.GetPhrase("uv.race.finished.viewstats"), '<color=0,162,255>'.. string.upper( input.GetKeyName( UVKeybindShowRaceResults:GetInt() ) ) ..'<color=255,255,255>')
		local glideicon = "unitvehicles/icons/INGAME_ICON_LEADERBOARD.png"
		
		-----------------------------------------

		if Glide then
			if not istable(sortedRacers) or #sortedRacers == 0 then
				glidetext = "#uv.race.finished.statserror"
				glideicon = "unitvehicles/icons/GENERIC_ALERT.png"
			end
				Glide.Notify({
					text = glidetext,
					lifetime = duration,
					immediate = true,
					icon = glideicon,
				}) 
		end
        
        hook.Add( "Think", "RaceResultDisplay", function()
            if CurTime() - triggerTime > duration then
                hook.Remove( 'Think', 'RaceResultDisplay' )
                return
            end
            
            if input.IsKeyDown( UVKeybindShowRaceResults:GetInt() ) and !gui.IsGameUIVisible() and vgui.GetKeyboardFocus() == nil then
                hook.Remove( 'Think', 'RaceResultDisplay' )
                -- _main()
                UV_UI.racing.undercover.events.ShowResults(sortedRacers)
            end
        end)
    end,

onLapComplete = function( participant, new_lap, old_lap, lap_time, lap_time_cur, is_local_player, is_global_best )
	local name = UVHUDRaceInfo.Participants[participant] and UVHUDRaceInfo.Participants[participant].Name or "Unknown"
	-- if is_local_player then
		-- name = "YOU"
	-- end
	
	if is_global_best then
		UV_UI.racing.undercover.states.LapCompleteText = string.format(language.GetPhrase("uv.race.fastest.laptime"), name, Carbon_FormatRaceTime( lap_time ) )
	else
		if is_local_player then
			UV_UI.racing.undercover.states.LapCompleteText = string.format(language.GetPhrase("uv.race.laptime.carbon"), Carbon_FormatRaceTime( lap_time ) )
		else
			return
		end
	end

        local anim = {
            startTime = CurTime(),
            duration = 3,
            endTime = CurTime() + 3,

			phase1Time = 0.1,
			phase2Time = 0.2,       -- ends at 0.2
			pulseDuration = 2.5,    -- from 0.2 to 1.4
			fadeDuration = 0.5,     -- from 1.4 to 1.9
			pulses = 3,

			scaleIn = 1.3,
			scaleMid = 1.0,
			scaleBreathIn = 0.95,
			scaleBreathOut = 1.05,
			scaleExit = 0.1
        }

        UV_UI.racing.undercover.states.LapCompleteAnim = anim

        ----------------------------------------------------------------------------

        hook.Add("HUDPaint", "UNDERCOVER_NOTIFICATION_LAPTIME", function()
            local a = UV_UI.racing.undercover.states.LapCompleteAnim
            if not a then return end

            local now = CurTime()
            local t = now - a.startTime
            if now >= a.endTime then
                UV_UI.racing.undercover.states.LapCompleteAnim = nil
                hook.Remove("HUDPaint", "UNDERCOVER_NOTIFICATION_LAPTIME")
                return
            end

            -- Phase logic
			local scale = scale or a.scaleMid
			local alpha = alpha or 255
			local offsetY = offsetY or 0
			local baseColor = Color(0,194,255)
			local t = CurTime() - a.startTime
			local phase3Start = a.phase2Time
			local phase3End = a.phase2Time + a.pulseDuration
			local phase4Start = phase3End
			local phase4End = a.endTime

			-- Phase 1: Initial white burst
			if t < a.phase1Time then
				scale = a.scaleIn
				alpha = 255
				baseColor = Color(255, 255, 255)

			-- Phase 2: Snap to green and shrink quickly
			elseif t < a.phase2Time then
				local p = (t - a.phase1Time) / (a.phase2Time - a.phase1Time)
				scale = Lerp(p, a.scaleIn, a.scaleMid)
				alpha = 255

			-- Phase 3: Breathing pulses
			elseif t < phase3End then
				local p = (t - phase3Start) / a.pulseDuration
				local pulseT = (p * a.pulses) % 1 -- [0,1] within a single pulse

				if pulseT < 0.6 then
					-- Inhale
					scale = Lerp(pulseT / 0.6, a.scaleMid, a.scaleBreathIn)
				else
					-- Exhale
					scale = Lerp((pulseT - 0.6) / 0.4, a.scaleBreathIn, a.scaleBreathOut)
				end
				alpha = 255

			-- Phase 4: Fade out, shrink, and move up
			elseif t < phase4End then
				local p = (t - phase4Start) / a.fadeDuration
				scale = Lerp(p, a.scaleBreathOut, a.scaleExit)
				alpha = Lerp(p, 255, 0)
				offsetY = Lerp(p, 0, -30)
			end

            local shadowColor = Color(0, 0, 0, alpha)
            local x, y = ScrW() / 2, ScrH() / 2.7 + offsetY

            DrawScaledCenteredTextLines(UV_UI.racing.undercover.states.LapCompleteText, "UVUndercoverWhiteFont", x + 2, y + 2, shadowColor, scale)
            DrawScaledCenteredTextLines(UV_UI.racing.undercover.states.LapCompleteText, "UVUndercoverWhiteFont", x, y, baseColor, scale)
        end)
    end
}

UV_UI.pursuit.undercover.events = {
	onUnitTakedown = function( unitType, name, bounty, bountyCombo, isPlayer )
        UV_UI.pursuit.undercover.states.TakedownText = string.format( language.GetPhrase( "uv.hud.undercover.takedown" ), isPlayer and language.GetPhrase( unitType .. ".caps" ) or name, bounty, bountyCombo )

        local anim = {
            startTime = CurTime(),
            duration = 3,
            endTime = CurTime() + 3,

			phase1Time = 0.1,
			phase2Time = 0.2,       -- ends at 0.2
			pulseDuration = 2.5,    -- from 0.2 to 1.4
			fadeDuration = 0.5,     -- from 1.4 to 1.9
			pulses = 3,

			scaleIn = 1.3,
			scaleMid = 1.0,
			scaleBreathIn = 0.95,
			scaleBreathOut = 1.05,
			scaleExit = 0.1
        }

        UV_UI.pursuit.undercover.states.TakedownAnim = anim

        ----------------------------------------------------------------------------

        hook.Add("HUDPaint", "UNDERCOVER_NOTIFICATION_TAKEDOWN", function()
            local a = UV_UI.pursuit.undercover.states.TakedownAnim
            if not a then return end

            local now = CurTime()
            local t = now - a.startTime
            if now >= a.endTime then
                UV_UI.pursuit.undercover.states.TakedownAnim = nil
                hook.Remove("HUDPaint", "UNDERCOVER_NOTIFICATION_TAKEDOWN")
                return
            end

            -- Phase logic
			local scale = scale or a.scaleMid
			local alpha = alpha or 255
			local offsetY = offsetY or 0
			local baseColor = Color(50, 255, 50)
			local t = CurTime() - a.startTime
			local phase3Start = a.phase2Time
			local phase3End = a.phase2Time + a.pulseDuration
			local phase4Start = phase3End
			local phase4End = a.endTime

			-- Phase 1: Initial white burst
			if t < a.phase1Time then
				scale = a.scaleIn
				alpha = 255
				baseColor = Color(255, 255, 255)

			-- Phase 2: Snap to green and shrink quickly
			elseif t < a.phase2Time then
				local p = (t - a.phase1Time) / (a.phase2Time - a.phase1Time)
				scale = Lerp(p, a.scaleIn, a.scaleMid)
				alpha = 255

			-- Phase 3: Breathing pulses
			elseif t < phase3End then
				local p = (t - phase3Start) / a.pulseDuration
				local pulseT = (p * a.pulses) % 1 -- [0,1] within a single pulse

				if pulseT < 0.6 then
					-- Inhale
					scale = Lerp(pulseT / 0.6, a.scaleMid, a.scaleBreathIn)
				else
					-- Exhale
					scale = Lerp((pulseT - 0.6) / 0.4, a.scaleBreathIn, a.scaleBreathOut)
				end
				alpha = 255

			-- Phase 4: Fade out, shrink, and move up
			elseif t < phase4End then
				local p = (t - phase4Start) / a.fadeDuration
				scale = Lerp(p, a.scaleBreathOut, a.scaleExit)
				alpha = Lerp(p, 255, 0)
				offsetY = Lerp(p, 0, -30)
			end

            local shadowColor = Color(0, 0, 0, alpha)
            local x, y = ScrW() / 2, ScrH() / 2.7 + offsetY

            DrawScaledCenteredTextLines(UV_UI.pursuit.undercover.states.TakedownText, "UVUndercoverWhiteFont", x + 2, y + 2, shadowColor, scale)
            DrawScaledCenteredTextLines(UV_UI.pursuit.undercover.states.TakedownText, "UVUndercoverWhiteFont", x, y, baseColor, scale)
        end)
    end,
    onUnitDeploy = function(...)
        local new_value = select (1, ...)
        local old_value = select (2, ...)
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
    
    ShowDebrief = function(params) -- Undercover
        if UVHUDDisplayRacing then return end
        
        local w = ScrW()
        local h = ScrH()
        
        --------------------------------------
        
        local debriefdata = params.dataTable or escapedtable
        local debrieftitletext = params.titleText or "Title Text"
        
        local time = UVDisplayTime(UVTimerProgress)
        local unit = debriefdata["Unit"] or "Officer Replace Me"
        local deploys = debriefdata["Deploys"]
        local roadblocksdodged = debriefdata["Roadblocks"]
        local spikestripsdodged = debriefdata["Spikestrips"]
        local bounty = UVBounty
        local tags = UVTags
        local wrecks = UVWrecks
        local suspects = UVHUDWantedSuspectsNumber
        
        local lineData = {
            { text = "#uv.results.chase.costtostate", value = "$" .. bounty },
            { text = "#uv.results.chase.time", value = time },
            { text = "#uv.results.chase.units.deployed", value = deploys },
            { text = "#uv.results.chase.units.damaged", value = tags },
            { text = "#uv.results.chase.units.destroyed", value = wrecks },
            { text = "#uv.results.chase.dodged.blocks", value = roadblocksdodged },
            { text = "#uv.results.chase.dodged.spikes", value = spikestripsdodged },
        }
        
        local debrieflinedata = params.lineData or lineData
        local debriefcop = params.isCop or false
        
        local BackgroundPanel = vgui.Create("DPanel")
        local ResultPanel = vgui.Create("DFrame")
        local OK = vgui.Create("DButton")
        
        BackgroundPanel:SetSize(w, h)
        BackgroundPanel:SetZPos(0)
        
        ResultPanel:Add(OK)
        ResultPanel:SetSize(w, h)
        ResultPanel:SetBackgroundBlur(true)
        ResultPanel:ShowCloseButton(false)
        ResultPanel:Center()
        ResultPanel:SetTitle("")
        ResultPanel:SetDraggable(false)
        ResultPanel:MakePopup()
        ResultPanel:SetKeyboardInputEnabled(false)
        ResultPanel:SetVisible(false)
        
        OK:SetText("")
        OK:SetPos(w*0.5, h*0.6425)
        OK:SetSize(w*0.16, h*0.06)
		OK:SetEnabled(true)
        OK.Paint = function() end

        local fadeStart = CurTime()
        local backgroundAlpha = 0
        local backgroundFadeDuration = 0.5  -- seconds
        local fadeComplete = false
        
        local function CloseResults()
            if IsValid(ResultPanel) then ResultPanel:Close() end
            if IsValid(BackgroundPanel) then BackgroundPanel:Remove() end
            hook.Remove("Think", "CheckJumpKeyForDebrief")
        end
        
        local closing = false
        local closeStart = 0
        local closeDuration = 0.5
        
        local zoomStart = CurTime() + backgroundFadeDuration
        local zoomDuration = 0.5
        local rowDelay = 0.15
        local numTotalRows = 11
        
        local autoCloseDelay = 30
        local animationStartTime = CurTime()
        local autoCloseStartTime = animationStartTime + ((numTotalRows - 1) * rowDelay) + zoomDuration
        
        -- Then your timer start time:
        local timestart = autoCloseStartTime
        
        local function startCloseAnimation()
            if closing then return end
            closing = true
            closeStart = CurTime()
        end
        
        BackgroundPanel.Paint = function(self, w, h)
            local elapsed = CurTime() - fadeStart
            local alpha
            
            if not fadeComplete then
                alpha = math.min(175, (elapsed / backgroundFadeDuration) * 175)
                if alpha >= 175 then
                    fadeComplete = true
                    if IsValid(ResultPanel) then
                        ResultPanel:SetVisible(true)
                    end
                end
            elseif closing then
                local fadeOutElapsed = CurTime() - closeStart
                alpha = math.max(0, 175 * (1 - (fadeOutElapsed / closeDuration)))
            else
                alpha = 175
            end
            
            backgroundAlpha = alpha
            surface.SetDrawColor(5, 25, 150, backgroundAlpha)
            surface.DrawRect(0, 0, w, h)
        end
        
        local bustedTabHeight = 0
        
        ResultPanel.Paint = function(self, w, h)
            local now = CurTime()
            
            local zoomElapsed = closing and (now - closeStart) or (now - zoomStart)
            local zoomFrac = math.Clamp(zoomElapsed / zoomDuration, 0, 1)
            
            local function easeOutCubic(t) return 1 - (1 - t)^3 end
            local function easeInCubic(t) return t^3 end
            
            local easedFrac = closing and easeInCubic(zoomFrac) or easeOutCubic(zoomFrac)
            local zoomScale = Lerp(easedFrac, closing and 1.0 or 2.0, closing and 2.0 or 1.0)
            local panelAlpha = closing and (1 - easedFrac) or 1
            
            if closing and zoomFrac >= 1 then
                CloseResults()
                return
            end
            
            local mat = Matrix()
            mat:Translate(Vector(w*0.5, h*0.5, 0))
            mat:Scale(Vector(zoomScale, zoomScale, 1))
            mat:Translate(Vector(-(w*0.5), -(h*0.5), 0))
            
            local tabAlpha = math.floor(panelAlpha * 235)
            local textAlpha = math.floor(panelAlpha * 255)
            
            cam.Start2D()
            cam.PushModelMatrix(mat)
            local timeremaining = math.ceil(autoCloseDelay - (CurTime() - timestart))
            local lang = language.GetPhrase
            
            -- Upper Results Tab
            surface.SetDrawColor( 0, 0, 0, tabAlpha )
            surface.DrawRect( w*0.33, h*0.215, w*0.33, h*0.06)
            
            if debriefcop then
                local blend = (math.sin(CurTime() * 6) + 1) / 2
                surface.SetMaterial(UVMaterials["ARREST_LIGHT_UC"])
                surface.SetDrawColor(255 * blend, 0, 255 * (1 - blend), 175)
                surface.DrawTexturedRect(w * 0.33, h * 0.215, w * 0.33, h * 0.06)
                
                surface.SetMaterial(UVMaterials["ARREST_BG_UC"])
                surface.SetDrawColor(255, 255, 255, textAlpha)
                local bustedTabY = h * 0.2735
                bustedTabHeight = h * 0.03
                surface.DrawTexturedRect(w * 0.25, bustedTabY, w * 0.5, h * 0.06)
                
                numTotalRows = 10
            end
            
            draw.DrawText(debrieftitletext, "UVUndercoverWhiteFont", w*0.332, h*0.22, Color( 255, 200, 50, textAlpha ), TEXT_ALIGN_LEFT )
            
            -- Text
            local rowYOffsetBase = debriefcop and (h * 0.275 + bustedTabHeight) or h * 0.275
            local rowYOffsetBaseAlt = debriefcop and (h * 0.3075 + bustedTabHeight) or h * 0.3075
            
            local labelStartX, valueStartX = w * 0.25, w * 0.75 -- Offscreen starting points
            local labelTargetX, valueTargetX = w * 0.332, w * 0.6575
            
            for i = 1, numTotalRows do
                local rowStartTime = zoomStart + zoomDuration + (i - 1) * rowDelay
                local rowEndTime = rowStartTime + rowDelay
                local rowProgress = math.Clamp((CurTime() - rowStartTime) / rowDelay, 0, 1)
                local ease = 1 - math.pow(1 - rowProgress, 2)
                
                local isDark = i % 2 == 0
                local baseAlpha = isDark and 150 or 75
                local rowColor = isDark and Color(50, 50, 50) or Color(150, 150, 150)
                
                local yOffset = ((i % 2 == 1) and rowYOffsetBase or rowYOffsetBaseAlt) + math.floor((i - 1) / 2) * h * 0.0675
                local rowHeight = h * 0.035
                local rowWidth = w * 0.33
                local rowX = w * 0.33
                local halfWidth = rowWidth / 2
                local alpha = ease * baseAlpha * panelAlpha
                
                -- Animate left half
                local leftX = Lerp(ease, labelStartX, rowX)
                surface.SetDrawColor(rowColor.r, rowColor.g, rowColor.b, alpha)
                surface.DrawRect(leftX, yOffset, halfWidth + (h * 0.001), rowHeight)
                
                -- Animate right half
                local rightX = Lerp(ease, valueStartX, rowX + halfWidth)
                surface.DrawRect(rightX, yOffset, halfWidth, rowHeight)
            end
            
            for i, line in ipairs(debrieflinedata) do
                local rowStartTime = zoomStart + zoomDuration + (i - 1) * rowDelay
                local rowEndTime = rowStartTime + rowDelay
                local rowProgress = math.Clamp((CurTime() - rowStartTime) / rowDelay, 0, 1)
                local alpha = rowProgress * 255
                local ease = 1 - math.pow(1 - rowProgress, 2) -- smooth end
                
                local yOffset = ((i % 2 == 1) and rowYOffsetBase or rowYOffsetBaseAlt) + math.floor((i - 1) / 2) * h * 0.0675
                
                local labelX = Lerp(ease, labelStartX, labelTargetX)
                local valueX = Lerp(ease, valueStartX, valueTargetX)
                
                draw.SimpleText(line.text, "UVUndercoverAccentFont", labelX, yOffset, Color(255, 255, 255, alpha * panelAlpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                draw.SimpleText(tostring(line.value), "UVUndercoverAccentFont", valueX, yOffset, Color(255, 255, 255, alpha * panelAlpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            end
            
            -- Time remaining and closing					
            surface.SetDrawColor( 0, 0, 0, tabAlpha )
            surface.DrawRect( w*0.33, h*0.6425, w*0.33, h*0.06)
            
            if timeremaining > autoCloseDelay then
                timeremaining = autoCloseDelay
            end
            
            draw.DrawText( lang("uv.results.continue") .. " [" .. input.LookupBinding("+jump") .. "]", "UVUndercoverAccentFont", w*0.6575, h*0.6525, Color( 255, 255, 255, textAlpha ), TEXT_ALIGN_RIGHT )
            draw.DrawText( string.format( lang("uv.results.autoclose"), math.max(0, timeremaining) ), "UVUndercoverLeaderboardFont", w*0.332, h*0.6525, Color( 255, 255, 255, textAlpha ), TEXT_ALIGN_LEFT )
            
            if timeremaining < 1 then
                startCloseAnimation()
            end
            
            cam.PopModelMatrix()
            cam.End2D()
        end
        
        function OK:DoClick() 
			startCloseAnimation()
			OK:SetEnabled(false)
        end
        
        local wasJumping = false
        hook.Add("Think", "CheckJumpKeyForDebrief", function()
            local ply = LocalPlayer()
            if not IsValid(ply) then return end
            
            if ply:KeyDown(IN_JUMP) then
                if not wasJumping then
                    wasJumping = true
                    if IsValid(ResultPanel) then
                        startCloseAnimation()
                    end
                end
            else
                wasJumping = false
            end
        end)
    end,
    
    onRacerEscapedDebrief = function(escapedtable)
        local params = {
            dataTable = escapedtable,
            titleText = "#uv.results.evaded",
        }
        UV_UI.pursuit.undercover.events.ShowDebrief(params)
    end,
    
    onRacerBustedDebrief = function(bustedtable)
        local unit = bustedtable["Unit"]
        local time = UVDisplayTime(UVTimerProgress)
        local deploys = bustedtable["Deploys"]
        local roadblocksdodged = bustedtable["Roadblocks"]
        local spikestripsdodged = bustedtable["Spikestrips"]
        local bounty = UVBounty
        local tags = UVTags
        local wrecks = UVWrecks
        
        local params = {
            isCop = true,
            dataTable = bustedtable,
            titleText = "#uv.results.busted",
            lineData = {
                { text = "#uv.results.bustedby.carbon", value = unit },
                { text = "#uv.results.chase.bounty", value = "$" .. bounty },
                { text = "#uv.results.chase.time", value = time },
                { text = "#uv.results.chase.units.deployed", value = deploys },
                { text = "#uv.results.chase.units.damaged", value = tags },
                { text = "#uv.results.chase.units.destroyed", value = wrecks },
                { text = "#uv.results.chase.dodged.blocks", value = roadblocksdodged },
                { text = "#uv.results.chase.dodged.spikes", value = spikestripsdodged },
            }
        }
        UV_UI.pursuit.undercover.events.ShowDebrief(params)
    end,
    
    onCopBustedDebrief = function(bustedtable)
        local time = UVDisplayTime(UVTimerProgress)
        local deploys = bustedtable["Deploys"]
        local roadblocksdodged = bustedtable["Roadblocks"]
        local spikestripsdodged = bustedtable["Spikestrips"]
        local bounty = UVBounty
        local tags = UVTags
        local wrecks = UVWrecks
        local suspects = UVHUDWantedSuspectsNumber
        
        local params = {
            isCop = true,
            dataTable = bustedtable,
            titleText = "#uv.results.won",
            lineData = {
                { text = "#uv.results.suspects.busted", value = " " },
                { text = "#uv.results.chase.bounty", value = "$" .. bounty },
                { text = "#uv.results.chase.time", value = time },
                { text = "#uv.results.chase.units.deployed", value = deploys },
                { text = "#uv.results.chase.units.damaged", value = tags },
                { text = "#uv.results.chase.units.destroyed", value = wrecks },
                { text = "#uv.results.chase.dodged.blocks", value = roadblocksdodged },
                { text = "#uv.results.chase.dodged.spikes", value = spikestripsdodged },
            }
        }
        UV_UI.pursuit.undercover.events.ShowDebrief(params)
    end,
    
    onCopEscapedDebrief = function(escapedtable)
        local time = UVDisplayTime(UVTimerProgress)
        local deploys = escapedtable["Deploys"]
        local roadblocksdodged = escapedtable["Roadblocks"]
        local spikestripsdodged = escapedtable["Spikestrips"]
        local bounty = UVBounty
        local tags = UVTags
        local wrecks = UVWrecks
        local suspects = UVHUDWantedSuspectsNumber
        
        local params = {
            isCop = true,
            dataTable = escapedtable,
            titleText = "#uv.results.lost",
            lineData = {
                { text = "#uv.results.suspects.escaped.num.carbon", value = suspects },
                { text = "#uv.results.chase.bounty", value = "$" .. bounty },
                { text = "#uv.results.chase.time", value = time },
                { text = "#uv.results.chase.units.deployed", value = deploys },
                { text = "#uv.results.chase.units.damaged", value = tags },
                { text = "#uv.results.chase.units.destroyed", value = wrecks },
                { text = "#uv.results.chase.dodged.blocks", value = roadblocksdodged },
                { text = "#uv.results.chase.dodged.spikes", value = spikestripsdodged },
            }
        }
        UV_UI.pursuit.undercover.events.ShowDebrief(params)
    end,
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

		if #text > 25 then
			text = string.sub(text, 1, 25 - 3) .. "..."
		end

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
    if UVHUDDisplayRacing then return end

    
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
                UVBustingProgress = UVClosestSuspect.uvbustingprogress or 0
                
                local blink = 255 * math.abs(math.sin(RealTime() * 8))
                states.BustedColor = Color(255, 100, 100, blink)
            end
        end
    end
    
    --if not UVHUDRace then
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
        local blink = 255 * math.abs(math.sin(RealTime() * 4))
        local blink2 = 255 * math.abs(math.sin(RealTime() * 6))
        local blink3 = 255 * math.abs(math.sin(RealTime() * 8))
        
        if healthratio >= 0.5 then
            healthcolor = Color(255, 255, 255, 200)
        elseif healthratio >= 0.25 then
            healthcolor = Color(255, blink, blink, 200)
        else
            healthcolor = Color(255, blink2, blink2, 200)
        end
        
        ResourceText = "⛊"
        local element3 = {
            {x = w / 3, y = 0},
            {x = w / 3 + 12 + w / 3, y = 0},
            {x = w / 3 + 12 + w / 3 - 25, y = h / 20},
            {x = w / 3 + 25, y = h / 20}
        }
        surface.SetDrawColor(0, 0, 0, 100)
        draw.NoTexture()
        -- surface.DrawPoly(element3)
        surface.DrawRect(w / 3 + 25, 0, w / 3 - 38, h * 0.05)
        if healthratio > 0 then
            surface.SetDrawColor(Color(109, 109, 109, 200))
            surface.DrawRect(w / 3 + 25, h / 20, w / 3 - 38, 8)
            surface.SetDrawColor(healthcolor)
            local T = math.Clamp((healthratio) * (w / 3 - 38), 0, w / 3 - 38)
            surface.DrawRect(w / 3 + 25, h / 20, T, 8)
        end
        draw.DrawText("⛊", "UVUndercoverWhiteFont", w * 0.35, 0, Colors.Undercover_Accent2, TEXT_ALIGN_LEFT)
        draw.DrawText("⛊", "UVUndercoverWhiteFont", w * 0.65, 0, Colors.Undercover_Accent2, TEXT_ALIGN_RIGHT)
        
        local cname = "#uv.unit.commander"
        if IsValid(UVHUDCommander) then
            local driver = UVHUDCommander:GetDriver()
            if IsValid(driver) and driver:IsPlayer() then
                cname = driver:Nick()
            end
        end
        
        draw.DrawText(cname,"UVUndercoverWhiteFont", w / 2, 0, Colors.Undercover_Accent2,TEXT_ALIGN_CENTER)
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
    draw.DrawText("x" .. UVHeatLevel, "UVUndercoverWhiteFont", w * 0.8, h * 0.275, Colors.Undercover_Accent1, TEXT_ALIGN_RIGHT)
    
    -- if UVHeatLevel == 1 then
    --     UVHeatBountyMin = UVUHeatMinimumBounty1:GetInt()
    --     UVHeatBountyMax = UVUHeatMinimumBounty2:GetInt()
    -- elseif UVHeatLevel == 2 then
    --     UVHeatBountyMin = UVUHeatMinimumBounty2:GetInt()
    --     UVHeatBountyMax = UVUHeatMinimumBounty3:GetInt()
    -- elseif UVHeatLevel == 3 then
    --     UVHeatBountyMin = UVUHeatMinimumBounty3:GetInt()
    --     UVHeatBountyMax = UVUHeatMinimumBounty4:GetInt()
    -- elseif UVHeatLevel == 4 then
    --     UVHeatBountyMin = UVUHeatMinimumBounty4:GetInt()
    --     UVHeatBountyMax = UVUHeatMinimumBounty5:GetInt()
    -- elseif UVHeatLevel == 5 then
    --     UVHeatBountyMin = UVUHeatMinimumBounty5:GetInt()
    --     UVHeatBountyMax = UVUHeatMinimumBounty6:GetInt()
    -- elseif UVHeatLevel == 6 then
    --     UVHeatBountyMin = UVUHeatMinimumBounty6:GetInt()
    --     UVHeatBountyMax = math.huge
    -- end
    
    local UVHeatMinConVar = GetConVar( 'unitvehicle_unit_heatminimumbounty' .. UVHeatLevel )
    local UVHeatMaxConVar = GetConVar( 'unitvehicle_unit_heatminimumbounty' .. UVHeatLevel + 1 )
    
    UVHeatBountyMin = ( UVHeatMinConVar and UVHeatMinConVar:GetInt() ) or math.huge
    UVHeatBountyMax = ( UVHeatMaxConVar and UVHeatMaxConVar:GetInt() ) or math.huge
    
    surface.SetDrawColor(Color(109, 109, 109, 200))
    surface.DrawRect(w * 0.805, h * 0.2815, w * 0.1375, h * 0.035)
    surface.SetDrawColor(Color(255, 255, 255))
    local HeatProgress = 0
    if MaxHeatLevel:GetInt() ~= UVHeatLevel then
        if UVUTimeTillNextHeatEnabled:GetInt() == 1 and UVTimeTillNextHeat then --Time till next heat level
            local timedHeatConVar = GetConVar( 'unitvehicle_unit_timetillnextheat' .. UVHeatLevel )
            
            local maxtime = timedHeatConVar:GetInt()
            HeatProgress = (maxtime - UVTimeTillNextHeat) / maxtime
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
                DrawIcon(UVMaterials["EVADE_ICON_UC_GLOW"], w * 0.6925, bottomy + (h*0.015), .05, Color(50, 214, 255, blink2)) -- Icon, Glow
                DrawIcon(UVMaterials["EVADE_ICON_UC"], w * 0.6925, bottomy + (h*0.015), .05, Color(50, 214, 255, 125)) -- Icon

                surface.SetDrawColor(200, 200, 200, 125)
                surface.DrawRect(w * 0.333, bottomy, w * 0.344, h * 0.03)
                
                local T = math.Clamp((UVCooldownTimer) * (w * 0.344), 0, w * 0.344)
                surface.SetDrawColor(50, 173, 255, 255)
                
                surface.DrawRect(w * 0.333, bottomy, T, h * 0.03)
            else
                DrawIcon(UVMaterials["EVADE_ICON_UC_GLOW"], w * 0.5, bottomy - (h*0.025), .05, Color(50, 214, 255, blink2)) -- Icon, Glow
                DrawIcon(UVMaterials["EVADE_ICON_UC"], w * 0.5, bottomy - (h*0.025), .05, Color(50, 214, 255, 125)) -- Icon

                surface.SetDrawColor(50, 214, 255, 50)
                surface.DrawRect(w * 0.333, bottomy, w * 0.344, h * 0.04)
                
                draw.DrawText("#uv.chase.cooldown", "UVUndercoverWhiteFont", w * 0.5, bottomy - (h * 0.005), Color(255, 255, 255), TEXT_ALIGN_CENTER)
            end
        else
            CooldownProgress = 0
        end
    end
    --end
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
	
    TakedownText = nil,
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
            
            draw.DrawText( string.format( language.GetPhrase("uv.results.autoclose"), math.max(0, timeremaining) ), "UVFont5", w*0.99, h*0.85, Color( 255, 255, 255 ), TEXT_ALIGN_RIGHT )
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
            
            draw.DrawText( string.format( language.GetPhrase("uv.results.autoclose"), math.max(0, timeremaining) ), "UVFont5", w*0.99, h*0.85, Color( 255, 255, 255 ), TEXT_ALIGN_RIGHT )
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
        if UVHUDDisplayRacing then return end
        
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
            
            draw.DrawText( string.format( language.GetPhrase("uv.results.autoclose"), math.max(0, timeremaining) ), "UVFont5", w*0.99, h*0.85, Color( 255, 255, 255 ), TEXT_ALIGN_RIGHT )
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
            
            draw.DrawText( string.format( language.GetPhrase("uv.results.autoclose"), math.max(0, timeremaining) ), "UVFont5", w*0.99, h*0.85, Color( 255, 255, 255 ), TEXT_ALIGN_RIGHT )
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
    if UVHUDDisplayRacing then return end

    
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
                UVBustingProgress = UVClosestSuspect.uvbustingprogress or 0
                
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
        
        -- DrawIcon(UVMaterials['CLOCK'], w/1.135, h*0.07, .05, Color(255,255,255))
        
        draw.DrawText( "⏰", "UVFont5",w/1.32, h/20, Color( 255, 255, 255), TEXT_ALIGN_RIGHT )
        
        draw.DrawText( UVTimer, "UVFont5",w/1.005, h/20, Color( 255, 255, 255), TEXT_ALIGN_RIGHT )
        surface.SetFont( "UVFont5" )
        surface.SetTextColor(255,255,255)
        surface.SetTextPos( w/1.35, h/10 ) 
        surface.DrawText( "#uv.hud.bounty" )
        draw.DrawText( UVBounty, "UVFont5",w/1.005, h/10, Color( 255, 255, 255), TEXT_ALIGN_RIGHT )
        
        -- if UVHeatLevel == 1 then
        --     UVHeatBountyMin = UVUHeatMinimumBounty1:GetInt()
        --     UVHeatBountyMax = UVUHeatMinimumBounty2:GetInt()
        -- elseif UVHeatLevel == 2 then
        --     UVHeatBountyMin = UVUHeatMinimumBounty2:GetInt()
        --     UVHeatBountyMax = UVUHeatMinimumBounty3:GetInt()
        -- elseif UVHeatLevel == 3 then
        --     UVHeatBountyMin = UVUHeatMinimumBounty3:GetInt()
        --     UVHeatBountyMax = UVUHeatMinimumBounty4:GetInt()
        -- elseif UVHeatLevel == 4 then
        --     UVHeatBountyMin = UVUHeatMinimumBounty4:GetInt()
        --     UVHeatBountyMax = UVUHeatMinimumBounty5:GetInt()
        -- elseif UVHeatLevel == 5 then
        --     UVHeatBountyMin = UVUHeatMinimumBounty5:GetInt()
        --     UVHeatBountyMax = UVUHeatMinimumBounty6:GetInt()
        -- elseif UVHeatLevel == 6 then
        --     UVHeatBountyMin = UVUHeatMinimumBounty6:GetInt()
        --     UVHeatBountyMax = math.huge
        -- end
        
        local UVHeatMinConVar = GetConVar( 'unitvehicle_unit_heatminimumbounty' .. UVHeatLevel )
        local UVHeatMaxConVar = GetConVar( 'unitvehicle_unit_heatminimumbounty' .. UVHeatLevel + 1 )
        
        UVHeatBountyMin = ( UVHeatMinConVar and UVHeatMinConVar:GetInt() ) or math.huge
        UVHeatBountyMax = ( UVHeatMaxConVar and UVHeatMaxConVar:GetInt() ) or math.huge
        
        draw.DrawText( "♨ " .. UVHeatLevel, "UVFont5", w/1.105, h/120, Color( 255, 255, 255), TEXT_ALIGN_RIGHT )
        
        -- local hl10 = 0
        -- if UVHeatLevel > 9 then hl10 = w * 0.01 end
        -- DrawIcon(UVMaterials['HEAT'], w/1.135 - hl10, h*0.027, .05, Color(255,255,255))
        
        surface.SetDrawColor(Color(109,109,109,200))
        surface.DrawRect(w/1.099,h/120,w/20+60,39)
        surface.SetDrawColor(Color(255,255,255))
        local HeatProgress = 0
        if MaxHeatLevel:GetInt() != UVHeatLevel then
            if UVUTimeTillNextHeatEnabled:GetInt() == 1 and UVTimeTillNextHeat then --Time till next heat level
                local timedHeatConVar = GetConVar( 'unitvehicle_unit_timetillnextheat' .. UVHeatLevel )
                
                local maxtime = timedHeatConVar:GetInt()
                HeatProgress = (maxtime - UVTimeTillNextHeat) / maxtime
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
        local ResourceText = "⛉\n"..UVResourcePoints
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
            local blink = 255 * math.abs(math.sin(RealTime() * 4))
            local blink2 = 255 * math.abs(math.sin(RealTime() * 6))
            local blink3 = 255 * math.abs(math.sin(RealTime() * 8))
            
            if healthratio >= 0.5 then
                healthcolor = Color(255, 255, 255, 200)
            elseif healthratio >= 0.25 then
                healthcolor = Color(255, blink, blink, 200)
            else
                healthcolor = Color(255, blink2, blink2, 200)
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
            
            local cname = lang("uv.unit.commander")
            if IsValid(UVHUDCommander) then
                local driver = UVHUDCommander:GetDriver()
                if IsValid(driver) and driver:IsPlayer() then
                    cname = driver:Nick()
                end
            end
            
            draw.DrawText( "⛊ " .. cname .. " ⛊", "UVFont2",w/2,0, Color(0, 161, 255), TEXT_ALIGN_CENTER )
        end
        
        local iconhigh = 0
        if (BustingProgress > 0 or EvadingProgress > 0 or UVHUDDisplayCooldown) then iconhigh = h*0.035 end
        -- DrawIcon(UVMaterials['UNITS_DISABLED'], w * 0.68, h * 0.975, 0.06, UVWrecksColor)
        draw.DrawText( "☠ " .. UVWrecks, "UVFont5WeightShadow", w * 0.67, h * 0.955, UVWrecksColor, TEXT_ALIGN_LEFT )
        
        -- DrawIcon(UVMaterials['UNITS_DAMAGED'], w * 0.3275, h * 0.975, 0.06, UVTagsColor)
        draw.DrawText( UVTags .. " ☄", "UVFont5WeightShadow", w * 0.335, h * 0.955, UVTagsColor, TEXT_ALIGN_RIGHT )
        
        -- DrawIcon(UVMaterials['UNITS'], w / 2, h * 0.885 - iconhigh, .06, UVUnitsColor)
        draw.DrawText( ResourceText, "UVFont5WeightShadow", w/2, h * 0.85 - iconhigh, UVUnitsColor, TEXT_ALIGN_CENTER )
        
        if !UVHUDDisplayNotification then
            if (UnitsChasing > 0 or NeverEvade:GetBool()) and !UVHUDDisplayCooldown then
                EvadingProgress = 0
                local busttime = math.Round((BustedTimer:GetFloat()-UVBustingProgress),3)
                
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
            draw.DrawText( UVNotification, "UVFont-Smaller",w/2,h/1.05, UVNotificationColor, TEXT_ALIGN_CENTER )
        end
    end
    
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
        
        local T = math.Clamp((UVBustingProgress / UVBustTimer) * (w * 0.1515), 0, w * 0.1515)
        T = math.floor(T)
        surface.SetDrawColor(255, 0, 0)
        surface.DrawRect(w * 0.333 + (w * 0.1515 - T), h * 0.9, T, h * 0.01)
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
        
		if #text > 20 then
			text = string.sub(text, 1, 20 - 3) .. "..."
		end

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

UV_UI.racing.prostreet.states = {
    LapCompleteText = nil,
}

UV_UI.racing.prostreet.events = {
    ShowResults = function(sortedRacers) -- ProStreet
        local w = ScrW()
        local h = ScrH()
        
        --------------------------------------
        
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
		
        OK:SetText("")
        OK:SetPos(w*0.2, h*0.9)
        OK:SetSize(w*0.15, h*0.035)
		OK:SetEnabled(true)
        OK.Paint = function() end
		
        local timestart = CurTime()
        local displaySequence = {}
        
        -- Data and labels
        local racersArray = {}
        
        for _, dict in pairs(sortedRacers) do
            table.insert(racersArray, dict)
        end
        
        table.sort(racersArray, function(a, b)
            local timeA = a.array and a.array.TotalTime
            local timeB = b.array and b.array.TotalTime
            
            -- Treat missing or non-numeric TotalTime as a large number (DNF)
            local tA = (type(timeA) == "number") and timeA or math.huge
            local tB = (type(timeB) == "number") and timeB or math.huge
            
            return tA < tB
        end)

        local entriesToShow = 8
        local scrollOffset = 0
        
        local i = 0
        for place, dict in ipairs(racersArray) do
            local info = dict.array or {}
            i = i + 1
            
            -- Staggered vertical layout
            local visibleIndex = i -- 1 to entriesToShow
            local rowHeight = h * 0.09
			local yPos = h*0.08 + (i - 1) * rowHeight
			local LP, LC = false, Color(100, 100, 100)

            local name = info["Name"] or "Unknown"
            local totalTime = info["TotalTime"] and info["TotalTime"] or "#uv.race.suffix.dnf"
            
            if info["Busted"] then totalTime = "#uv.race.suffix.busted" end
            
			if info["LocalPlayer"] then
				LP = true
				LC = Color(0, 0, 0)
			end
			
            local entry = {
                y = yPos,
                posText = tostring(i),
                nameText = name,
                timeText = UV_FormatRaceEndTime(totalTime),
				color = LC,
				localPlayer = LP
            }
            
            table.insert(displaySequence, entry)
        end

        local closing = false
        local closeStartTime = 0

        function ResultPanel:OnMouseWheeled(delta)
            if delta > 0 then
                scrollOffset = math.max(scrollOffset - 1, 0)
            elseif delta < 0 then
                local maxOffset = math.max(0, #displaySequence - entriesToShow)
                scrollOffset = math.min(scrollOffset + 1, maxOffset)
            end
            
            return true -- prevent further processing
        end
		
		local playedfadeSound = false
        
        ResultPanel.Paint = function(self, w, h)
            local curTime = CurTime()
			local fadeDuration = 0.125
			local fadeAlpha = 1
			local scaleX = 1

			if closing then
				OK:SetEnabled(false)
				local elapsedFade = curTime - closeStartTime
				local progress = math.Clamp(elapsedFade / fadeDuration, 0, 1)

				fadeAlpha = 1 - progress  -- fade out from 1 to 0
				scaleX = 1 + progress * 1  -- scale horizontally from 1 to 2 times
				
				if not playedfadeSound and elapsedFade >= 0.05 then
					 playedfadeSound = true
					 surface.PlaySound( "uvui/ps/closemenu2.wav" )
				end
				
				if elapsedFade >= fadeDuration then
					hook.Remove("Think", "CheckJumpKeyForResults")
					if IsValid(ResultPanel) then
						ResultPanel:Close()
					end
					return -- early exit, avoid drawing anymore
				end
			end
			-- Setup transformation matrix
			local matrix = Matrix()
			matrix:Translate(Vector(w * 0.5, 0, 0))         -- move origin to horizontal center
			matrix:Scale(Vector(scaleX, 1, 1))              -- scale horizontally
			matrix:Translate(Vector(-w * 0.5, 0, 0))        -- move origin back

			cam.PushModelMatrix(matrix)
			
            -- Draw rows and alternating backgrounds fully visible when revealed
            local startIndex = scrollOffset + 1
            local endIndex = math.min(startIndex + entriesToShow - 1, #displaySequence)
    			
			-- Black BG Textured Elements
			surface.SetDrawColor(0, 0, 0, 255 * fadeAlpha)
			surface.SetMaterial(UVMaterials["RESULTS_PS_CURVES"])
			surface.DrawTexturedRect(w * 0.31, h * 0.125, w * 0.125, h * 0.11)
			
			surface.SetMaterial(UVMaterials["RESULTS_PS_HUB"])
			surface.DrawTexturedRectRotated(w * 0.31, h * 0.185, w * 0.1, h * 0.09, -12.5)
			
			surface.SetMaterial(UVMaterials["RESULTS_PS_SP8"])
			surface.DrawTexturedRectRotated(w * 0.255, h * 0.2, w * 0.07, h * 0.125, -32.5)
			
			surface.SetMaterial(UVMaterials["RESULTS_PS_SP8"])
			surface.DrawTexturedRectRotated(w * 0.2035, h * 0.27, w * 0.07, h * 0.125, -130)
			
			surface.SetMaterial(UVMaterials["RESULTS_PS_WING_INV"])
			surface.DrawTexturedRect(w * 0.18, h * 0.26, w * 0.055, h * 0.25, 0)

			local baseHeight = 0.31
			local extraHeight = 0
			
			if #displaySequence > 4 then
				local extraEntries = math.min(#displaySequence, 8) - 4
				extraHeight = extraEntries * (h * 0.06)
			end

			-- Black BG Element
			surface.SetDrawColor(0, 0, 0, 255 * fadeAlpha)
			surface.DrawRect(w * 0.2, h * 0.2, w * (1 - 2 * 0.2), (h * baseHeight) + extraHeight)

			-- White BG Element
			surface.SetDrawColor(200, 200, 200, 255 * fadeAlpha)
			surface.DrawRect(w * 0.21, h * 0.25, w * (1 - 2 * 0.21), (h * (baseHeight - 0.06)) + extraHeight)

			draw.SimpleText("#uv.results.race.raceresults", "UVFont2", w * 0.205, h * 0.2025, Color(255, 255, 255, 255 * fadeAlpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

            for i = startIndex, endIndex do
				local entry = displaySequence[i]
				local localIndex = i - startIndex + 1
				local yPos = h * 0.255 + (localIndex - 1) * (h * 0.06)
				
				if entry.localPlayer then
					surface.SetDrawColor(255, 255, 0, 255 * fadeAlpha)
				else
					surface.SetDrawColor(175, 175, 175, 255 * fadeAlpha)
				end
				surface.DrawRect(w * 0.2175, yPos, w * (1 - 2 * 0.2175), h * 0.055)
				
                if entry.posText then
                    draw.SimpleText(entry.posText, "UVFont2", w * 0.22, yPos, Color(entry.color.r, entry.color.g, entry.color.b, 255 * fadeAlpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                end
                if entry.nameText then
                    draw.SimpleText(entry.nameText, "UVFont2", w * 0.25, yPos, Color(entry.color.r, entry.color.g, entry.color.b, 255 * fadeAlpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                end
                if entry.timeText then
                    draw.SimpleText(entry.timeText, "UVFont2", w * 0.775, yPos, Color(entry.color.r, entry.color.g, entry.color.b, 255 * fadeAlpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
                end
            end
			
            local blink = 255 * math.abs(math.sin(RealTime() * 8))

			if scrollOffset > 0 then
				draw.SimpleText("▲", "UVFont3", w * 0.5, h * 0.2, Color(255,255,255, math.floor(blink * fadeAlpha)), TEXT_ALIGN_CENTER)
			end
			
			if scrollOffset < #displaySequence - entriesToShow then
				draw.SimpleText("▼", "UVFont3", w * 0.5, h * 0.725, Color(255,255,255, math.floor(blink * fadeAlpha)), TEXT_ALIGN_CENTER)
			end

            -- Time since panel was created
            local elapsed = CurTime() - timestart
            
            -- Only start auto-close countdown after reveal + flash
            local autoCloseDuration = 30  -- 30 seconds countdown
            
            local autoCloseTimer = 0
            local autoCloseRemaining = autoCloseDuration
            
			autoCloseTimer = elapsed
			autoCloseRemaining = math.max(0, autoCloseDuration - autoCloseTimer)
			
            local conttext = "( " .. input.LookupBinding("+jump") .. " ) " .. language.GetPhrase("uv.results.continue")
            local conttextl = string.len(conttext)
            
            local autotext = string.format( language.GetPhrase("uv.results.autoclose"), math.ceil(autoCloseRemaining) )
            local autotextl = string.len(autotext)
            
            surface.SetDrawColor( 150, 150, 150, 175 * fadeAlpha )
            surface.DrawRect( w*0.1965, h*0.9, (w*0.00575 * conttextl), h*0.035)
            draw.DrawText( conttext, "UVCarbonLeaderboardFont", w*0.2085, h*0.9025, Color( 255, 255, 255, 255 * fadeAlpha ), TEXT_ALIGN_LEFT )
            
            surface.DrawRect( w*0.2 +  (w*0.00575 * conttextl), h*0.9, (w*0.00575 * autotextl), h*0.035)
            draw.DrawText( autotext, "UVCarbonLeaderboardFont", w*0.2125 + (w*0.00575 * conttextl), h*0.9025, Color( 255, 255, 255, 255 * fadeAlpha ), TEXT_ALIGN_LEFT )

			cam.PopModelMatrix()
			
            if autoCloseRemaining <= 0 then
                hook.Remove("Think", "CheckJumpKeyForResults")
                if not closing then
                    surface.PlaySound( "uvui/ps/closemenu.wav" )
                    closing = true
                    closeStartTime = CurTime()
                end
            end
		end

	function OK:DoClick()
		if not closing then
			surface.PlaySound( "uvui/ps/closemenu.wav" )
			closing = true
			closeStartTime = CurTime()
		end
	end

	local wasJumping = false
	hook.Add("Think", "CheckJumpKeyForResults", function()
		local ply = LocalPlayer()
		if not IsValid(ply) then return end
		
		if ply:KeyDown(IN_JUMP) then
			if not wasJumping and not closing then
				surface.PlaySound( "uvui/ps/closemenu.wav" )
				wasJumping = true
				closing = true
				closeStartTime = CurTime()
			end
		else
			wasJumping = false
		end
	end)
end,
    
    onRaceEnd = function( sortedRacers, stringArray )
        local triggerTime = CurTime()
        local duration = 10
		local glidetext = string.format( language.GetPhrase("uv.race.finished.viewstats"), '<color=0,162,255>'.. string.upper( input.GetKeyName( UVKeybindShowRaceResults:GetInt() ) ) ..'<color=255,255,255>')
		local glideicon = "unitvehicles/icons/INGAME_ICON_LEADERBOARD.png"
		
		-----------------------------------------

		if Glide then
			if not istable(sortedRacers) or #sortedRacers == 0 then
				glidetext = "#uv.race.finished.statserror"
				glideicon = "unitvehicles/icons/GENERIC_ALERT.png"
			end
				Glide.Notify({
					text = glidetext,
					lifetime = duration,
					immediate = true,
					icon = glideicon,
				}) 
		end
        
        hook.Add( "Think", "RaceResultDisplay", function()
            if CurTime() - triggerTime > duration then
                hook.Remove( 'Think', 'RaceResultDisplay' )
                return
            end
            
            if input.IsKeyDown( UVKeybindShowRaceResults:GetInt() ) and !gui.IsGameUIVisible() and vgui.GetKeyboardFocus() == nil then
                hook.Remove( 'Think', 'RaceResultDisplay' )
                -- _main()
                UV_UI.racing.prostreet.events.ShowResults(sortedRacers)
            end
        end)
    end,

onLapComplete = function( participant, new_lap, old_lap, lap_time, lap_time_cur, is_local_player, is_global_best, lap_final )
	local name = UVHUDRaceInfo.Participants[participant] and UVHUDRaceInfo.Participants[participant].Name or "Unknown"
	local llt = ""

	if lap_final then llt = language.GetPhrase("uv.race.finallap") .. " " end
	
	if is_global_best then
		UV_UI.racing.prostreet.states.LapCompleteText = llt .. string.format(language.GetPhrase("uv.race.fastest.laptime"), name, Carbon_FormatRaceTime( lap_time ) )
	else
		if is_local_player then
			UV_UI.racing.prostreet.states.LapCompleteText = llt .. string.format(language.GetPhrase("uv.race.laptime.carbon"), Carbon_FormatRaceTime( lap_time ) )
		else
			return
		end
	end
		local SID = 0.35

		local prostreet_noti_animState = {
			active = false,
			startTime = 0,
			slideInDuration = SID,
			holdDuration = 3,
			slideDownDuration = 0.25,
			upper = {
				startX = ScrW() * 0.25,
				centerX = ScrW() / 2,
				y = ScrH() * 0.35,
				slideDownEndY = ScrH() * 0.6,
			},
			lower = {
				startX = ScrW() * 0.75,
				centerX = ScrW() / 2,
				y = ScrH() * 0.385,
				slideDownEndY = ScrH() * 0.635,
			},
		}

        UV_UI.racing.prostreet.events.prostreet_noti_animState = prostreet_noti_animState
        prostreet_noti_animState.active = true
        prostreet_noti_animState.startTime = CurTime()

        ----------------------------------------------------------------------------
        
        -- Remove any existing HUDPaint hook with the same name (avoid duplicates)
        if hook.GetTable().HUDPaint and hook.GetTable().HUDPaint.PROSTREET_NOTIFICATION_LAP then
            hook.Remove("HUDPaint", "PROSTREET_NOTIFICATION_LAP")
        end

        -- Add the HUDPaint hook freshly for this animation
        hook.Add("HUDPaint", "PROSTREET_NOTIFICATION_LAP", function()
            local elapsed = CurTime() - prostreet_noti_animState.startTime

            local function calcPosAlpha(elapsed, elem)
                local x, y, alpha = elem.centerX, elem.y, 255
                if elapsed < prostreet_noti_animState.slideInDuration then
                    local t = elapsed / prostreet_noti_animState.slideInDuration
                    x = Lerp(t, elem.startX, elem.centerX)
                    alpha = Lerp(t, 0, 255)
                elseif elapsed < prostreet_noti_animState.slideInDuration + prostreet_noti_animState.holdDuration then
                    x = elem.centerX
                    alpha = 255
                elseif elapsed < prostreet_noti_animState.slideInDuration + prostreet_noti_animState.holdDuration + prostreet_noti_animState.slideDownDuration then
                    local t = (elapsed - prostreet_noti_animState.slideInDuration - prostreet_noti_animState.holdDuration) / prostreet_noti_animState.slideDownDuration
                    -- y = Lerp(t, elem.y, elem.slideDownEndY)
                    alpha = Lerp(t, 255, 0)
                else
                    alpha = 0
                end
                return x, y, alpha
            end

            local lines = string.Explode("\n", UV_UI.racing.prostreet.states.LapCompleteText or "")
            if #lines < 1 then return end
			local upperLine = lines[1] or ""
			local lowerLine = lines[2] or ""

			-- Upper
            local ux, uy, ualpha = calcPosAlpha(elapsed, prostreet_noti_animState.upper)
            carbon_noti_draw( upperLine, "UVCarbonFont", nil, ux + 2, uy + 2, Color(0, 0, 0, ualpha), nil)
            carbon_noti_draw( upperLine, "UVCarbonFont", nil, ux, uy, Color(255, 255, 255, ualpha), nil)

			-- Lower
            local lx, ly, lalpha = calcPosAlpha(elapsed, prostreet_noti_animState.lower)
            carbon_noti_draw( lowerLine, "UVCarbonFont", nil, lx + 2, ly + 2, Color(0, 0, 0, lalpha), nil)
            carbon_noti_draw( lowerLine, "UVCarbonFont", nil, lx, ly, Color(255, 255, 255, lalpha), nil)

            -- Disable animation and remove hook when done
            if elapsed > prostreet_noti_animState.slideInDuration + prostreet_noti_animState.holdDuration + prostreet_noti_animState.slideDownDuration then
                prostreet_noti_animState.active = false
                hook.Remove("HUDPaint", "PROSTREET_NOTIFICATION_LAP")
            end

        end)
    end
}

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
    end,

    ShowResults = function(sortedRacers) -- Underground 1
        local debriefcolor = Color(255, 183, 61)
        
        local w = ScrW()
        local h = ScrH()
        
        --------------------------------------
        
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
        
        OK:SetText("")
        OK:SetPos(w*0.5, h*0.9)
        OK:SetSize(w*0.2, h*0.025)
        OK:SetEnabled(true)
		OK.Paint = function() end
        
        local timestart = CurTime()
        local displaySequence = {}
        
        -- Data and labels
        local racersArray = {}
        
        for _, dict in pairs(sortedRacers) do
            table.insert(racersArray, dict)
        end
        
        table.sort(racersArray, function(a, b)
            local timeA = a.array and a.array.TotalTime
            local timeB = b.array and b.array.TotalTime
            
            -- Treat missing or non-numeric TotalTime as a large number (DNF)
            local tA = (type(timeA) == "number") and timeA or math.huge
            local tB = (type(timeB) == "number") and timeB or math.huge
            
            return tA < tB
        end)

        local entriesToShow = 9
        local scrollOffset = 0
        
        local i = 0
        for place, dict in ipairs(racersArray) do
            local info = dict.array or {}
            i = i + 1
            
            -- Staggered vertical layout
            local visibleIndex = i -- 1 to entriesToShow
            local rowHeight = h * 0.09
			local yPos = h*0.08 + (i - 1) * rowHeight

            local name = info["Name"] or "Unknown"
            local totalTime = info["TotalTime"] and info["TotalTime"] or "#uv.race.suffix.dnf"
            
            if info["Busted"] then totalTime = "#uv.race.suffix.busted" end
            
            local entry = {
                y = yPos,
                posText = tostring(i),
                nameText = name,
                timeText = UV_FormatRaceEndTime(totalTime)
            }
            
            table.insert(displaySequence, entry)
        end
        
        local closing = false
        local closeStartTime = 0

        function ResultPanel:OnMouseWheeled(delta)
            if delta > 0 then
                scrollOffset = math.max(scrollOffset - 1, 0)
            elseif delta < 0 then
                local maxOffset = math.max(0, #displaySequence - entriesToShow)
                scrollOffset = math.min(scrollOffset + 1, maxOffset)
            end
            
            return true -- prevent further processing
        end
        
        ResultPanel.Paint = function(self, w, h)
            local curTime = CurTime()
			local fadeDuration = 0.5 -- seconds
			local fadeAlpha = 1

			if closing then
				OK:SetEnabled(false)
				local elapsedFade = curTime - closeStartTime
				fadeAlpha = 1 - math.Clamp(elapsedFade / fadeDuration, 0, 1)
				
				if elapsedFade >= fadeDuration then
					hook.Remove("Think", "CheckJumpKeyForResults")
					if IsValid(ResultPanel) then
						ResultPanel:Close()
					end
					return -- early exit, avoid drawing anymore
				end
			end

            -- Main black background
            surface.SetDrawColor(0, 0, 0, 150)
            surface.DrawRect(0, 0, w, h)
            
            -- Draw rows and alternating backgrounds fully visible when revealed
            local startIndex = scrollOffset + 1
            local endIndex = math.min(startIndex + entriesToShow - 1, #displaySequence)
            				
			-- Upper blue BG
			surface.SetDrawColor(38, 93, 160, math.floor(200 * fadeAlpha))
			surface.DrawRect(w * 0.7, 0, w * 0.33, h * 0.075)

			-- Lower blue BG
			surface.DrawRect(w * 0.7, h * 0.9, w * 0.33, h * 0.125)

            for i = startIndex, endIndex do
				local entry = displaySequence[i]
				local localIndex = i - startIndex + 1
				local yPos = h * 0.08 + (localIndex - 1) * (h * 0.09)
				
				surface.SetDrawColor(38, 93, 160, math.floor(200 * fadeAlpha))
				surface.DrawRect(w * 0.7, yPos, w * 0.33, h * 0.085)
				
				surface.SetDrawColor(104, 172, 255, math.floor(200 * fadeAlpha))
				surface.DrawRect(w * 0.7025, yPos + (h * 0.005), w * 0.33, h * 0.0375)

                if entry.posText then
                    draw.SimpleText(entry.posText, "UVFont", w * 0.715, yPos + (h * 0.04), Color(255, 255, 255, math.floor(255 * fadeAlpha)), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                end
                if entry.nameText then
                    draw.SimpleText(entry.nameText, "UVFont", w * 0.99, yPos, Color(255, 255, 255, math.floor(255 * fadeAlpha)), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
                end
                if entry.timeText then
                    draw.SimpleText(entry.timeText, "UVFont4", w * 0.99, yPos + (h * 0.05), Color(255, 255, 255, math.floor(255 * fadeAlpha)), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
                end
            end
			
            local blink = 255 * math.abs(math.sin(RealTime() * 8))

			if scrollOffset > 0 then
				draw.SimpleText("▲", "UVFont3", w * 0.86, h * 0.0175, Color(255,255,255, math.floor(blink * fadeAlpha)), TEXT_ALIGN_CENTER)
			end
			
			if scrollOffset < #displaySequence - entriesToShow then
				draw.SimpleText("▼", "UVFont3", w * 0.86, h * 0.9, Color(255,255,255, math.floor(blink * fadeAlpha)), TEXT_ALIGN_CENTER)
			end

            -- Time since panel was created
            local elapsed = CurTime() - timestart
            
            -- Only start auto-close countdown after reveal + flash
            local autoCloseDuration = 30  -- 30 seconds countdown
            
            local autoCloseTimer = 0
            local autoCloseRemaining = autoCloseDuration
            
			autoCloseTimer = elapsed
			autoCloseRemaining = math.max(0, autoCloseDuration - autoCloseTimer)
						
            local conttext = "[" .. input.LookupBinding("+jump") .. "] " .. language.GetPhrase("uv.results.continue")
            local conttextl = string.len(conttext)
            local conttexts = (w * 0.0065 * conttextl)
            
            local autotext = string.format( language.GetPhrase("uv.results.autoclose"), math.ceil(autoCloseRemaining) )
            local autotextl = string.len(autotext)
			local autotexts = (w * 0.00575 * autotextl)
            
            surface.SetDrawColor(38, 93, 160, math.floor(200 * fadeAlpha) )
            
            surface.DrawRect( w*0.6975 - conttexts, h*0.9, conttexts, h*0.025)
            draw.DrawText( conttext, "UVFont4", w*0.6945, h*0.9005, Color( 104, 172, 255, math.floor(255 * fadeAlpha) ), TEXT_ALIGN_RIGHT )
            
            surface.DrawRect( w*0.6975 - autotexts, h*0.925, autotexts, h*0.025)
            draw.DrawText( autotext, "UVFont4", w*0.6945, h*0.9255, Color( 104, 172, 255, math.floor(255 * fadeAlpha) ), TEXT_ALIGN_RIGHT )

            if autoCloseRemaining <= 0 then
                hook.Remove("Think", "CheckJumpKeyForResults")
                if not closing then
                    surface.PlaySound( "uvui/ug/closemenu.wav" )
                    closing = true
                    closeStartTime = CurTime()
                end
            end
		end

	function OK:DoClick()
		if not closing then
			surface.PlaySound( "uvui/ug/closemenu.wav" )
			closing = true
			closeStartTime = CurTime()
		end
	end

	local wasJumping = false
	hook.Add("Think", "CheckJumpKeyForResults", function()
		local ply = LocalPlayer()
		if not IsValid(ply) then return end
		
		if ply:KeyDown(IN_JUMP) then
			if not wasJumping and not closing then
				surface.PlaySound( "uvui/ug/closemenu.wav" )
				wasJumping = true
				closing = true
				closeStartTime = CurTime()
			end
		else
			wasJumping = false
		end
	end)
end,

    onRaceEnd = function( sortedRacers, stringArray )
        local triggerTime = CurTime()
        local duration = 10
		local glidetext = string.format( language.GetPhrase("uv.race.finished.viewstats"), '<color=0,162,255>'.. string.upper( input.GetKeyName( UVKeybindShowRaceResults:GetInt() ) ) ..'<color=255,255,255>')
		local glideicon = "unitvehicles/icons/INGAME_ICON_LEADERBOARD.png"
		
		-----------------------------------------

		if Glide then
			if not istable(sortedRacers) or #sortedRacers == 0 then
				glidetext = "#uv.race.finished.statserror"
				glideicon = "unitvehicles/icons/GENERIC_ALERT.png"
			end
				Glide.Notify({
					text = glidetext,
					lifetime = duration,
					immediate = true,
					icon = glideicon,
				}) 
		end
        
        hook.Add( "Think", "RaceResultDisplay", function()
            if CurTime() - triggerTime > duration then
                hook.Remove( 'Think', 'RaceResultDisplay' )
                return
            end
            
            if input.IsKeyDown( UVKeybindShowRaceResults:GetInt() ) and !gui.IsGameUIVisible() and vgui.GetKeyboardFocus() == nil then
                hook.Remove( 'Think', 'RaceResultDisplay' )
                -- _main()
                UV_UI.racing.underground.events.ShowResults(sortedRacers)
            end
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
    
    -- Best Timer
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

    -- Lap & Checkpoint Counter
    surface.SetDrawColor(0, 0, 0, 200)
    surface.DrawRect(w * 0.02, h * 0.075, w * 0.175, h * 0.095)

    draw.DrawText(
    "#uv.race.hud.lap.ug",
    "UVFont5",
    w * 0.1,
    h * 0.125,
    Color(125, 125, 255),
    TEXT_ALIGN_LEFT) -- Lap Counter
    draw.DrawText(
    my_array.Lap,
    "UVFont3Bigger",
    w * 0.1,
    h * 0.065,
    Color(255, 255, 255),
    TEXT_ALIGN_RIGHT) -- Lap Counter
    draw.DrawText(
    "/ " .. UVHUDRaceInfo.Info.Laps,
    "UVFont3",
    w * 0.1025,
    h * 0.08,
    Color(125, 125, 255),
    TEXT_ALIGN_LEFT) -- Lap Counter

    local racer_count = #string_array
    local lang = language.GetPhrase
    
    -- Position Counter
    surface.SetDrawColor(0, 0, 0, 200)
    surface.DrawRect(w * 0.8, h * 0.075, w * 0.175, h * 0.105)
    
    draw.DrawText(
    UVHUDRaceCurrentPos,
    "UVFont3Bigger",
    w * 0.88,
    h * 0.065,
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
    end,

    ShowResults = function(sortedRacers) -- Underground 2
        local w = ScrW()
        local h = ScrH()
        
        --------------------------------------
        
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
        
        OK:SetText("")
        OK:SetPos(w*0.775, h*0.84)
        OK:SetSize(w*0.15, h*0.0425)
		OK:SetEnabled(true)
        OK.Paint = function() end
        
        local timestart = CurTime()
        local displaySequence = {}
        
        -- Data and labels
        local racersArray = {}
        
        for _, dict in pairs(sortedRacers) do
            table.insert(racersArray, dict)
        end
        
        table.sort(racersArray, function(a, b)
            local timeA = a.array and a.array.TotalTime
            local timeB = b.array and b.array.TotalTime
            
            -- Treat missing or non-numeric TotalTime as a large number (DNF)
            local tA = (type(timeA) == "number") and timeA or math.huge
            local tB = (type(timeB) == "number") and timeB or math.huge
            
            return tA < tB
        end)

        local entriesToShow = 9
        local scrollOffset = 0
        
        local i = 0
        for place, dict in ipairs(racersArray) do
            local info = dict.array or {}
            i = i + 1
            
            -- Staggered vertical layout
            local visibleIndex = i -- 1 to entriesToShow
            local rowHeight = h * 0.09
			local yPos = h*0.08 + (i - 1) * rowHeight
			local LP, LC = false, Color(255, 255, 255)

            local name = info["Name"] or "Unknown"
            local totalTime = info["TotalTime"] and info["TotalTime"] or "#uv.race.suffix.dnf"
            
            if info["Busted"] then totalTime = "#uv.race.suffix.busted" end
            
			if info["LocalPlayer"] then
				LP = true
				LC = Color(196, 208, 151)
			end
			
            local entry = {
                y = yPos,
                posText = tostring(i),
                nameText = name,
                timeText = UV_FormatRaceEndTime(totalTime),
				color = LC,
				localPlayer = LP
            }
            
            table.insert(displaySequence, entry)
        end
        
        local closing = false
        local closeStartTime = 0

        function ResultPanel:OnMouseWheeled(delta)
            if delta > 0 then
                scrollOffset = math.max(scrollOffset - 1, 0)
            elseif delta < 0 then
                local maxOffset = math.max(0, #displaySequence - entriesToShow)
                scrollOffset = math.min(scrollOffset + 1, maxOffset)
            end
            
            return true -- prevent further processing
        end
        
        ResultPanel.Paint = function(self, w, h)
            local curTime = CurTime()
			local fadeDuration = 0.2 -- seconds
			local fadeAlpha = 1

			if closing then
				OK:SetEnabled(false)
				local elapsedFade = curTime - closeStartTime
				fadeAlpha = 1 - math.Clamp(elapsedFade / fadeDuration, 0, 1)
				
				if elapsedFade >= fadeDuration then
					hook.Remove("Think", "CheckJumpKeyForResults")
					if IsValid(ResultPanel) then
						ResultPanel:Close()
					end
					return -- early exit, avoid drawing anymore
				end
			end

            -- Main black background
            -- surface.SetDrawColor(0, 0, 0, 150)
            -- surface.DrawRect(0, 0, w, h)
            
            -- Draw rows and alternating backgrounds fully visible when revealed
            local startIndex = scrollOffset + 1
            local endIndex = math.min(startIndex + entriesToShow - 1, #displaySequence)

			-- BG Element
			surface.SetDrawColor(255, 255, 255, math.floor(255 * fadeAlpha))
			surface.SetMaterial(UVMaterials["RESULTS_UG2_BG"])
			surface.DrawTexturedRect(0, 0, w, h) -- Upper

			-- Gray BG Elements
			surface.SetDrawColor(196, 208, 151, math.floor(255 * fadeAlpha))
			surface.SetMaterial(UVMaterials["RESULTS_UG2_SHINE"])
			surface.DrawTexturedRect(0, 0, w, h) -- Upper

			draw.SimpleText("#uv.results.race.eventresults", "UVFont", w * 0.05, h * 0.12, Color(196, 208, 151, math.floor(255 * fadeAlpha)), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText("#uv.results.race.name", "UVFont", w * 0.1, h * 0.2025, Color(255, 255, 255, math.floor(255 * fadeAlpha)), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText("#uv.results.race.time.finish", "UVFont", w * 0.9, h * 0.205, Color(255, 255, 255, math.floor(255 * fadeAlpha)), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)

            for i = startIndex, endIndex do
				local entry = displaySequence[i]
				local localIndex = i - startIndex + 1
				local yPos = h * 0.29 + (localIndex - 1) * (h * 0.06)
				
				if entry.localPlayer then
					surface.SetDrawColor(255, 255, 255, math.floor(200 * fadeAlpha))
					surface.SetMaterial(UVMaterials["RESULTS_UG2_LP"])
					surface.DrawTexturedRect(0, yPos, w, h * 0.055) -- Upper
				end
				
                if entry.posText then
                    draw.SimpleText(entry.posText, "UVFont", w * 0.085, yPos, Color(entry.color.r, entry.color.g, entry.color.b, math.floor(255 * fadeAlpha)), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
                end
                if entry.nameText then
                    draw.SimpleText(entry.nameText, "UVFont", w * 0.1, yPos, Color(entry.color.r, entry.color.g, entry.color.b, math.floor(255 * fadeAlpha)), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                end
                if entry.timeText then
                    draw.SimpleText(entry.timeText, "UVFont", w * 0.9, yPos, Color(entry.color.r, entry.color.g, entry.color.b, math.floor(255 * fadeAlpha)), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
                end
            end
			
            local blink = 255 * math.abs(math.sin(RealTime() * 8))

			if scrollOffset > 0 then
				draw.SimpleText("▲", "UVFont3", w * 0.5, h * 0.2425, Color(255,255,255, math.floor(blink * fadeAlpha)), TEXT_ALIGN_CENTER)
			end
			
			if scrollOffset < #displaySequence - entriesToShow then
				draw.SimpleText("▼", "UVFont3", w * 0.5, h * 0.815, Color(255,255,255, math.floor(blink * fadeAlpha)), TEXT_ALIGN_CENTER)
			end

            -- Time since panel was created
            local elapsed = CurTime() - timestart
            
            -- Only start auto-close countdown after reveal + flash
            local autoCloseDuration = 30  -- 30 seconds countdown
            
            local autoCloseTimer = 0
            local autoCloseRemaining = autoCloseDuration
            
			autoCloseTimer = elapsed
			autoCloseRemaining = math.max(0, autoCloseDuration - autoCloseTimer)
						
            local conttext = "[" .. input.LookupBinding("+jump") .. "] " .. language.GetPhrase("uv.results.continue")
            local conttextl = string.len(conttext)
            local conttexts = (w * 0.0065 * conttextl)

            surface.SetDrawColor(255, 255, 255, math.floor(200 * fadeAlpha) )
			surface.SetMaterial(UVMaterials["RESULTS_UG2_BUTTON"])
            surface.DrawTexturedRect( w*0.775, h*0.84, w * 0.15, h*0.0425)
            draw.DrawText( "[" .. input.LookupBinding("+jump") .. "] " .. language.GetPhrase("uv.results.continue"), "UVFont4", w*0.85, h*0.8475, Color( 255, 255, 255, math.floor(255 * fadeAlpha) ), TEXT_ALIGN_CENTER )

            draw.DrawText( string.format( language.GetPhrase("uv.results.autoclose"), math.ceil(autoCloseRemaining) ), "UVFont", w*0.05, h*0.85, Color( 196, 208, 151, math.floor(255 * fadeAlpha) ), TEXT_ALIGN_LEFT )

            if autoCloseRemaining <= 0 then
                hook.Remove("Think", "CheckJumpKeyForResults")
                if not closing then
                    surface.PlaySound( "uvui/ug/closemenu.wav" )
                    closing = true
                    closeStartTime = CurTime()
                end
            end
		end

	function OK:DoClick()
		if not closing then
			surface.PlaySound( "uvui/ug/closemenu.wav" )
			closing = true
			closeStartTime = CurTime()
		end
	end

	local wasJumping = false
	hook.Add("Think", "CheckJumpKeyForResults", function()
		local ply = LocalPlayer()
		if not IsValid(ply) then return end
		
		if ply:KeyDown(IN_JUMP) then
			if not wasJumping and not closing then
				surface.PlaySound( "uvui/ug/closemenu.wav" )
				wasJumping = true
				closing = true
				closeStartTime = CurTime()
			end
		else
			wasJumping = false
		end
	end)
end,

    onRaceEnd = function( sortedRacers, stringArray )
        local triggerTime = CurTime()
        local duration = 10
		local glidetext = string.format( language.GetPhrase("uv.race.finished.viewstats"), '<color=0,162,255>'.. string.upper( input.GetKeyName( UVKeybindShowRaceResults:GetInt() ) ) ..'<color=255,255,255>')
		local glideicon = "unitvehicles/icons/INGAME_ICON_LEADERBOARD.png"
		
		-----------------------------------------

		if Glide then
			if not istable(sortedRacers) or #sortedRacers == 0 then
				glidetext = "#uv.race.finished.statserror"
				glideicon = "unitvehicles/icons/GENERIC_ALERT.png"
			end
				Glide.Notify({
					text = glidetext,
					lifetime = duration,
					immediate = true,
					icon = glideicon,
				}) 
		end
        
        hook.Add( "Think", "RaceResultDisplay", function()
            if CurTime() - triggerTime > duration then
                hook.Remove( 'Think', 'RaceResultDisplay' )
                return
            end
            
            if input.IsKeyDown( UVKeybindShowRaceResults:GetInt() ) and !gui.IsGameUIVisible() and vgui.GetKeyboardFocus() == nil then
                hook.Remove( 'Think', 'RaceResultDisplay' )
                -- _main()
                UV_UI.racing.underground2.events.ShowResults(sortedRacers)
            end
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
    
    -- Position Counter
    surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(UVMaterials["RACE_BG_UPPER_UG2"])
    surface.DrawTexturedRect(w * 0.72, h * 0.075, w * 0.255, h * 0.15)

    draw.DrawText(
    UVHUDRaceCurrentPos,
    "UVFont3Big",
    w * 0.79,
    h * 0.11,
    Color(255, 255, 255),
    TEXT_ALIGN_RIGHT) -- Upper, Your Position
    draw.DrawText(
    lang("uv.race.pos." .. UVHUDRaceCurrentPos),
    "UVFont3",
    w * 0.7925,
    h * 0.14,
    Color(255, 255, 255),
    TEXT_ALIGN_LEFT) -- Upper, Your Position
    draw.DrawText(
    "/" .. UVHUDRaceCurrentParticipants,
    "UVFont3Big",
    w * 0.82,
    h * 0.11,
    Color(255, 255, 255),
    TEXT_ALIGN_LEFT) -- Lower, Total Positions
    
    -- Lap & Checkpoint Counter
    surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(UVMaterials["RACE_BG_LAP_UG2"])
    surface.DrawTexturedRect(w * 0.7135, h * 0.1525, w * 0.2655, h * 0.15)

    if UVHUDRaceInfo.Info.Laps > 1 then
        draw.DrawText(
        "#uv.race.hud.lap.ug",
        "UVFont5",
        w * 0.735,
        h * 0.205,
        Color(255, 255, 255),
        TEXT_ALIGN_LEFT) -- Lap Counter
        draw.DrawText(
        my_array.Lap .. "/" .. UVHUDRaceInfo.Info.Laps,
        "UVFont5",
        w * 0.945,
        h * 0.205,
        Color(255, 255, 255),
        TEXT_ALIGN_RIGHT) -- Lap Counter
    else
        draw.DrawText(
        "#uv.race.hud.complete.ug2",
        "UVFont",
        w * 0.735,
        h * 0.205,
        Color(255, 255, 255),
        TEXT_ALIGN_LEFT)
        draw.DrawText(
        math.floor(((checkpoint_count / GetGlobalInt("uvrace_checkpoints")) * 100)) .. "%",
        "UVFont",
        w * 0.945,
        h * 0.205,
        Color(255, 255, 255),
        TEXT_ALIGN_RIGHT)
    end

    -- Racer List
    local racer_count = #string_array
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

        draw.NoTexture()
        surface.DrawRect(w * 0.743, h * 0.235 + racercount, w * 0.227, h * 0.025)
        
        surface.SetDrawColor(0, 0, 0, 125)
        draw.NoTexture()
        surface.DrawRect(w * 0.725, h * 0.235 + racercount, w * 0.015, h * 0.025)
        
        draw.DrawText(i .. ":", "UVFont4", w * 0.738, (h * 0.235) + racercount, Color(255, 255, 255), TEXT_ALIGN_RIGHT)
        draw.DrawText(text, "UVFont4", w * 0.965, (h * 0.235) + racercount, color, TEXT_ALIGN_RIGHT)
    end
    
    -- Timer
	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(UVMaterials["RACE_BG_TIME_UG2"])
    surface.DrawTexturedRect(w * 0.708, h * 0.355, w * 0.276, h * 0.075)
    
    draw.DrawText(
    "#uv.race.orig.time",
    "UVFont5UI",
    w * 0.73,
    h * 0.375,
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
    w * 0.965,
    h * 0.375,
    Color(255, 255, 255),
    TEXT_ALIGN_RIGHT)

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