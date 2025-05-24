local Colors = {
    ["MW_LocalPlayer"] = Color(223, 184, 127),
    --Color(255, 187, 0),
    ["MW_Accent"] = Color(223, 184, 127),
    ["MW_Others"] = Color(255, 255, 255),
    ["MW_Disqualified"] = Color(255, 50, 50, 133),
    ["Carbon_Accent"] = Color(86, 214, 205),
    ["Carbon_AccentTransparent"] = Color(86, 214, 205, 50),
    ["Carbon_Accent2"] = Color(168, 168, 168),
    ["Carbon_Accent2Bright"] = Color(189, 189, 189),
    ["Carbon_Accent2Transparent"] = Color(168, 168, 168, 100),
    ["Carbon_LocalPlayer"] = Color(86, 214, 205),
    ["Carbon_Others"] = Color(255, 255, 255),
    ["Carbon_OthersDark"] = Color(255, 255, 255, 121),
    ["Carbon_Disqualified"] = Color(255, 50, 50, 133),
    ["Original_LocalPlayer"] = Color(255, 217, 0),
    ["Original_Others"] = Color(255, 255, 255),
    ["Original_Disqualified"] = Color(255, 50, 50, 133),
    ["Undercover_Accent1"] = Color(255, 255, 255),
    ["Undercover_Accent2"] = Color(187, 226, 220),
    ["Undercover_Accent2Transparent"] = Color(187, 226, 220, 150)
}

UVMaterials = {
    ["UNITS_DAMAGED"] = Material("hud/COPS_DAMAGED_ICON.png"),
    ["UNITS_DISABLED"] = Material("hud/COPS_TAKENOUT_ICON.png"),
    ["UNITS"] = Material("hud/COPS_ICON.png"),
    ["HEAT"] = Material("hud/HEAT_ICON.png"),
    ["CLOCK"] = Material("hud/TIMER_ICON.png"),
    ["CLOCK_BG"] = Material("hud/TIMER_ICON_BG.png", "smooth mips"),
    ["CHECK"] = Material("hud/MINIMAP_ICON_CIRCUIT.png"),
    ["BACKGROUND"] = Material("hud/NFSMW_BACKGROUND.png"),
    ["BACKGROUND_BIG"] = Material("hud/NFSMW_BACKGROUND_BIG.png"),
    ["BACKGROUND_BIGGER"] = Material("hud/NFSMW_BACKGROUND_BIGGER.png"),
    ["RESULTCOP"] = Material("hud/(9)T_UI_PlayerCop_Large_Icon.png"),
    ["RESULTRACER"] = Material("hud/(9)(9)T_UI_PlayerRacer_Large_Icon.png"),
    ["BACKGROUND_CARBON"] = Material("unitvehicles/hud/NFSC_GRADIENT.png"),
    ["BACKGROUND_CARBON_INVERTED"] = Material("unitvehicles/hud/NFSC_GRADIENT_INV.png"),
    ["ARROW_CARBON"] = Material("unitvehicles/hud/NFSC_ARROWRIGHT.png")
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

-- Carbon
UV_UI.racing.carbon = {}
UV_UI.pursuit.carbon = {}

local function carbon_racing_main( ... )
    local w = ScrW()
    local h = ScrH()
    
    local my_vehicle = select(1, ...)
    local my_array = select(2, ...)
    local string_array = select(3, ...)
    
    local racer_count = #string_array
    
    local checkpoint_count = #my_array["Checkpoints"]
    
    ------------------------------------
    
    -- Timer
    --surface.SetMaterial(UVMaterials["ARROW_CARBON"])
    -- surface.SetDrawColor( 89, 255, 255, 200)
    -- surface.DrawTexturedRect( w*0.7175, h*0.1, w*0.03, h*0.05)
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
        draw.DrawText("#uv.race.mw.lap","UVCarbonFont",w * 0.875,h * 0.155,Colors.Carbon_Accent2Bright,TEXT_ALIGN_RIGHT) -- Lap Counter
    else
        draw.DrawText("#uv.race.completepercent","UVCarbonFont",w * 0.875,h * 0.155,Colors.Carbon_Accent2Bright,TEXT_ALIGN_RIGHT) -- Checkpoint Text
        laptext = math.floor(((checkpoint_count / GetGlobalInt("uvrace_checkpoints")) * 100)) .. "%"
    end
    
    markup.Parse("<font=UVCarbonFont>" .. laptext):Draw(w * 0.97,h * 0.155,TEXT_ALIGN_RIGHT,TEXT_ALIGN_RIGHT)
    
    -- Racer List
    local alt = math.floor(CurTime() / 10) % 2 == 1
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
            ["Lap"] = "%s LAPS",
            ["Finished"] = "FINISHED",
            ["Disqualified"] = "DNF",
            ["Busted"] = "BUSTED"
        }
        
        if entry[3] then
            local status_string = Strings[entry[3]]
            
            if status_string then
                local args = {}
                
                if entry[4] then
                    local num = tonumber(entry[4])
                    num =
                    ((num > 0 and "+ ") or "- ") ..
                    string.format((entry[3] == "Lap" and "%s") or "%.2fs", math.abs(num))
                    
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
        
        local text = alt and (status_text) or (racer_name .. "   " .. i)
        
        if is_local_player then
            surface.SetMaterial(UVMaterials["BACKGROUND_CARBON_INVERTED"])
            surface.SetDrawColor(89, 255, 255, 100)
            surface.DrawTexturedRect(w * 0.72, h * 0.185 + racercount, w * 0.255, h * 0.025)
        end
        
        draw.DrawText("UVCarbonLeaderboardFont", w * 0.97, (h * 0.185) + racercount, color, TEXT_ALIGN_RIGHT)
    end
end

UV_UI.racing.carbon.main = carbon_racing_main

-- Most Wanted

UV_UI.racing.mostwanted = {}
UV_UI.pursuit.mostwanted = {}

local function mw_racing_main( ... )
    local w = ScrW()
    local h = ScrH()
    
    local my_vehicle = select(1, ...)
    local my_array = select(2, ...)
    local string_array = select(3, ...)
    
    local racer_count = #string_array
    
    local checkpoint_count = #my_array["Checkpoints"]
    
    ------------------------------------
    
    -- Timer
    surface.SetDrawColor(0, 0, 0, 200)
    surface.DrawRect(w * 0.8, h * 0.1, w * 0.175, h * 0.05)
    
    surface.SetMaterial(UVMaterials["BACKGROUND_BIG"])
    surface.SetDrawColor(0, 0, 0, 50)
    surface.DrawTexturedRect(w * 0.8, h * 0.1, w * 0.175, h * 0.05)
    
    DrawIcon(UVMaterials["CLOCK"], w * 0.815, h * 0.124, .05, Colors.MW_Accent) -- Icon
    draw.DrawText(Carbon_FormatRaceTime((UVHUDRaceInfo.Info.Started and (CurTime() - UVHUDRaceInfo.Info.Time)) or 0),"UVFont5",w * 0.97,h * 0.103,Colors.MW_Accent,TEXT_ALIGN_RIGHT)
    
    -- Lap & Checkpoint Counter
    surface.SetDrawColor(0, 0, 0, 200)
    surface.DrawRect(w * 0.8, h * 0.155, w * 0.175, h * 0.05)
    
    if UVHUDRaceInfo.Info.Laps > 1 then
        draw.DrawText("#uv.race.mw.lap","UVFont5",w * 0.805,h * 0.155,Color(255, 255, 255),TEXT_ALIGN_LEFT) -- Lap Counter
        draw.DrawText(my_array.Lap .. "/" .. UVHUDRaceInfo.Info.Laps,"UVFont5",w * 0.97,h * 0.155,Color(255, 255, 255),TEXT_ALIGN_RIGHT) -- Lap Counter
    else
        --DrawIcon(UVMaterials["CHECK"], w * 0.815, h * 0.18, .04, Color(255, 255, 255)) -- Icon
        draw.DrawText("#uv.race.completepercent","UVFont5",w * 0.805,h * 0.155,Color(255, 255, 255),TEXT_ALIGN_LEFT)
        draw.DrawText(math.floor(((checkpoint_count / GetGlobalInt("uvrace_checkpoints")) * 100)) .. "%","UVFont5",w * 0.97,h * 0.155,Color(255, 255, 255),TEXT_ALIGN_RIGHT)
    end
    
    local racer_count = #string_array
    
    -- Position Counter
    if racer_count > 1 then
        surface.SetDrawColor(0, 0, 0, 200)
        surface.DrawRect(w * 0.72, h * 0.1, w * 0.075, h * 0.105)
        
        surface.SetMaterial(UVMaterials["BACKGROUND"])
        surface.SetDrawColor(0, 0, 0, 50)
        surface.DrawTexturedRect(w * 0.72, h * 0.1, w * 0.075, h * 0.105)
        
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawRect(w * 0.73, h * 0.15, w * 0.05, h * 0.005) -- Divider
        
        draw.DrawText(UVHUDRaceCurrentPos,"UVFont5",w * 0.755,h * 0.107,Colors.MW_Accent,TEXT_ALIGN_CENTER) -- Upper, Your Position
        draw.DrawText(UVHUDRaceCurrentParticipants,"UVFont5",w * 0.755,h * 0.155,Color(255, 255, 255), TEXT_ALIGN_CENTER) -- Lower, Total Positions
    end
    
    -- Racer List
    local alt = math.floor(CurTime() / 10) % 2 == 1 -- toggles every 10 seconds
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
        local racercount = i * w * 0.0135
        -- local text = alt and (entry[3] .. "  " .. i) or (entry[2] .. "  " .. i)
        
        local Strings = {
            ["Time"] = "%s",
            ["Lap"] = "%s LAPS",
            ["Finished"] = "FINISHED",
            ["Disqualified"] = "DNF",
            ["Busted"] = "BUSTED"
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
                    string.format((entry[3] == "Lap" and "%s") or "%.2fs", math.abs(num))
                    
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
        surface.DrawRect(w * 0.72, h * 0.185 + racercount, w * 0.255, h * 0.025)
        
        draw.DrawText(i,"UVMostWantedLeaderboardFont",w * 0.725,(h * 0.185) + racercount,color,TEXT_ALIGN_LEFT)
        draw.DrawText(text,"UVMostWantedLeaderboardFont",w * 0.97,(h * 0.185) + racercount,color,TEXT_ALIGN_RIGHT)
    end
end

local function mw_pursuit_main( ... )
    local hudyes = showhud:GetBool()
    if not hudyes then return end
    
    outofpursuit = CurTime()
    
    local UVHeatBountyMin
    local UVHeatBountyMax
    -- local element1 = {
    -- { x = w/1.35, y = h/20 },
    -- { x = w/1.155, y = 0 },
    -- { x = w, y = 0 },
    -- { x = w, y = h/7 },
    -- { x = w/1.35, y = h/7 },
    -- }
    -- surface.SetDrawColor( 0, 0, 0, 200)
    -- draw.NoTexture()
    -- surface.DrawPoly( element1 )
    if UVHUDCopMode then
        UVBustedColor = Color(255, 255, 255, 50)
        UVHUDDisplayBusting = false
    end
    
    if UVHUDCopMode and next(UVHUDWantedSuspects) ~= nil then
        local ply = LocalPlayer()
        
        UVClosestSuspect = nil
        UVHUDDisplayBusting = false
        
        local closestDistance = math.huge
        
        for _, suspect in pairs(UVHUDWantedSuspects) do
            local dist = ply:GetPos():DistToSqr(suspect:GetPos())
            
            if dist < 250000 and dist < closestDistance then
                closestDistance = dist
                UVClosestSuspect = suspect
            end
        end
        
        if UVClosestSuspect then
            if UVClosestSuspect.beingbusted then
                UVHUDDisplayBusting = true
                UVBustingProgress = UVClosestSuspect.uvbustingprogress
                
                local blink = 255 * math.abs(math.sin(RealTime() * 8))
                UVBustedColor = Color(255, blink, blink)
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
        surface.SetDrawColor(0, 0, 0, 200)
        surface.DrawRect(w * 0.7, h * 0.1, w * 0.275, h * 0.05)
        DrawIcon(UVMaterials["CLOCK"], w * 0.71, h * 0.1225, .05, Color(255, 255, 255)) -- Icon
        draw.DrawText(UVTimer, "UVFont5", w * 0.97, h * 0.105, Color(255, 255, 255), TEXT_ALIGN_RIGHT)
        
        -- Bounty
        surface.SetDrawColor(0, 0, 0, 200)
        surface.DrawRect(w * 0.7, h * 0.155, w * 0.275, h * 0.05)
        draw.DrawText("#uv.hud.bounty","UVFont5",w * 0.7025,h * 0.157,Color(255, 255, 255),TEXT_ALIGN_LEFT) -- Lap Counter
        draw.DrawText(UVBounty, "UVFont5", w * 0.97, h * 0.157, Color(255, 255, 255), TEXT_ALIGN_RIGHT) -- Bounty Counter
        
        -- Heat Level
        surface.SetDrawColor(0, 0, 0, 200)
        surface.DrawRect(w * 0.7, h * 0.21, w * 0.275, h * 0.05)
        
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
        
        DrawIcon(UVMaterials["HEAT"], w * 0.71, h * 0.235, .05, Color(255, 255, 255)) -- Icon
        draw.DrawText(UVHeatLevel, "UVFont5", w * 0.74, h * 0.2125, Color(255, 255, 255), TEXT_ALIGN_RIGHT)
        
        surface.SetDrawColor(Color(109, 109, 109, 200))
        surface.DrawRect(w * 0.745, h * 0.2175, w * 0.225, h * 0.035)
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
        local B = math.Clamp((HeatProgress) * w * 0.225, 0, w * 0.225)
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
        local UVEvasionColor = Color(255, 255, 255, 50)
        local bottomy = h * 0.86
        local bottomy2 = h * 0.9
        local bottomy3 = h * 0.91
        local bottomy4 = h * 0.81
        local bottomy5 = h * 0.83
        local bottomy6 = h * 0.79
        
        if not UVHUDDisplayCooldown then
            -- General Icons
            draw.DrawText(
            UVWrecks,
            "UVFont5WeightShadow",
            w * 0.64,
            bottomy4,
            UVWrecksColor,
            TEXT_ALIGN_RIGHT)
            DrawIcon(UVMaterials["UNITS_DISABLED"], w * 0.66, bottomy5, 0.06, UVWrecksColor)
            
            draw.DrawText(UVTags, "UVFont5WeightShadow", w * 0.36, bottomy4, UVTagsColor, TEXT_ALIGN_LEFT)
            DrawIcon(UVMaterials["UNITS_DAMAGED"], w * 0.345, bottomy5, 0.06, UVTagsColor)
            
            draw.DrawText(ResourceText,"UVFont5WeightShadow",w * 0.5,bottomy4,UVUnitsColor,TEXT_ALIGN_CENTER)
            DrawIcon(UVMaterials["UNITS"], w * 0.5, bottomy6, .07, UVUnitsColor)
            
            -- Evade Box, All BG
            surface.SetDrawColor(200, 200, 200, 100)
            surface.DrawRect(w * 0.333, bottomy2, w * 0.34, h * 0.01)
            
            -- Evade Box, Busted Meter
            if UVHUDDisplayBusting and not UVHUDDisplayCooldown then
                if not BustingProgress or BustingProgress == 0 then
                    BustingProgress = CurTime()
                end
                
                local T = math.Clamp((UVBustingProgress / UVBustTimer) * (w * 0.1515), 0, w * 0.1515)
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
                
                local T = math.Clamp((UVEvadingProgress) * (w * 0.165), 0, w * 0.165)
                surface.SetDrawColor(155, 207, 0)
                surface.DrawRect(w * 0.51, bottomy2, T, h * 0.01)
                middlergb = {
                    r = 155,
                    g = 207,
                    b = 0,
                    a = 255
                }
                UVEvasionColor = Color(blink, 255, blink)
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
            surface.SetDrawColor(0, 0, 0, 200)
            surface.DrawRect(w * 0.333, bottomy, w * 0.34, h * 0.04)
            draw.DrawText("#uv.chase.busted","UVFont5UI",w * 0.34,bottomy,UVBustedColor,TEXT_ALIGN_LEFT)
            draw.DrawText("#uv.chase.evade","UVFont5UI",w * 0.66,bottomy,UVEvasionColor,TEXT_ALIGN_RIGHT)
            
            -- Lower Box
            
            local shade_theme_color =
            (UVHUDCopMode and table.Copy(Colors.CopThemeShade)) or table.Copy(Colors.RacerThemeShade)
            local theme_color =
            (UVHUDCopMode and table.Copy(Colors.CopTheme)) or table.Copy(Colors.RacerTheme)
            
            shade_theme_color.a = shade_theme_color.a - 35
            theme_color.a = theme_color.a - 35
            
            surface.SetDrawColor(shade_theme_color:Unpack())
            surface.DrawRect(w * 0.333, bottomy3, w * 0.34, h * 0.05)
            
            surface.SetDrawColor(theme_color:Unpack())
            --DrawIcon( UVMaterials['CLOCK'], w*0.71, h*0.1225, .05, Color(255,255,255) ) -- Icon
            surface.SetMaterial(UVMaterials["BACKGROUND"])
            surface.DrawTexturedRect(w * 0.333, bottomy3, w * 0.34, h * 0.05)
            
            -- surface.SetDrawColor( 0, 0, 0, 200)
            -- surface.DrawRect( w*0.333, bottomy3, w*0.34, h*0.05)
            
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
            
            draw.DrawText(lbtext,"UVFont5UI-BottomBar",w * 0.5,bottomy3 * 1.001,UVBackupColor,TEXT_ALIGN_CENTER)
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
                        -- surface.SetMaterial(UVMaterials['BACKGROUND'])
                        surface.SetMaterial(Material("unitvehicles/hud/bg_anim"))
                        surface.SetDrawColor(0, 175, 0, 200)
                        surface.DrawTexturedRect(w * 0.333, bottomy, w * 0.34, h * 0.05)
                        
                        local blink = 255 * math.Clamp(math.abs(math.sin(RealTime() * 2)), .7, 1)
                        color = Color(blink, 255, blink)
                        
                        surface.SetDrawColor(130, 199, 74, 124)
                        surface.DrawRect(w * 0.333, bottomy, w * 0.34, h * 0.05)
                        draw.DrawText(
                        "#uv.chase.hiding",
                        "UVFont5UI-BottomBar",
                        w * 0.5,
                        bottomy,
                        color,
                        TEXT_ALIGN_CENTER)
                    end
                    
                    surface.SetDrawColor(200, 200, 200)
                    surface.DrawRect(w * 0.333, bottomy2, w * 0.34, h * 0.01)
                    
                    local T = math.Clamp((UVCooldownTimer) * (w * 0.34), 0, w * 0.34)
                    surface.SetDrawColor(75, 75, 255)
                    surface.DrawRect(w * 0.333, bottomy2, T, h * 0.01)
                    
                    surface.SetDrawColor(0, 0, 0, 200)
                    surface.DrawRect(w * 0.333, bottomy3, w * 0.34, h * 0.05)
                    draw.DrawText("#uv.chase.cooldown","UVFont5UI-BottomBar",w * 0.5,bottomy3,Color(255, 255, 255),TEXT_ALIGN_CENTER)
                else
                    local shade_theme_color =(UVHUDCopMode and table.Copy(Colors.CopThemeShade)) or table.Copy(Colors.RacerThemeShade)
                    local theme_color =(UVHUDCopMode and table.Copy(Colors.CopTheme)) or table.Copy(Colors.RacerTheme)
                    
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

UV_UI.pursuit.mostwanted.main = mw_racing_main
UV_UI.racing.mostwanted.main = mw_racing_main

-- Undercover

UV_UI.racing.undercover = {}
UV_UI.pursuit.undercover = {}

local function undercover_racing_main( ... )
    local w = ScrW()
    local h = ScrH()
    
    local my_vehicle = select(1, ...)
    local my_array = select(2, ...)
    local string_array = select(3, ...)
    
    local racer_count = #string_array
    
    local checkpoint_count = #my_array["Checkpoints"]
    
    ------------------------------------
    
    -- Timer
    --surface.SetMaterial(UVMaterials["ARROW_CARBON"])
    -- surface.SetDrawColor( 89, 255, 255, 200)
    -- surface.DrawTexturedRect( w*0.7175, h*0.1, w*0.03, h*0.05)
    -- surface.SetMaterial(UVMaterials["ARROW_CARBON"])
    -- surface.SetDrawColor(Colors.Carbon_AccentTransparent)
    -- surface.DrawTexturedRect(w * 0.815, h * 0.111, w * 0.025, h * 0.033)
    
    draw.DrawText("#uv.race.time","UVUndercoverAccentFont",w * 0.75,h * 0.123,Colors.Undercover_Accent2,TEXT_ALIGN_LEFT)
    
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
        draw.DrawText("#uv.race.mw.lap","UVUndercoverAccentFont",w * 0.94,h * 0.123,Colors.Undercover_Accent2,TEXT_ALIGN_RIGHT)
        draw.DrawText(my_array.Lap .. "/" .. UVHUDRaceInfo.Info.Laps,"UVUndercoverWhiteFont",w * 0.94,h * 0.15,Colors.Undercover_Accent1,TEXT_ALIGN_RIGHT)
    else
        --DrawIcon(UVMaterials["CHECK"], w * 0.815, h * 0.18, .04, Color(255, 255, 255)) -- Icon
        draw.DrawText("#uv.race.completepercent","UVUndercoverAccentFont",w * 0.94,h * 0.123,Colors.Undercover_Accent2,TEXT_ALIGN_RIGHT)
        draw.DrawText(math.floor(((checkpoint_count / GetGlobalInt("uvrace_checkpoints")) * 100)) .. "%","UVUndercoverWhiteFont",w * 0.94,h * 0.15,Colors.Undercover_Accent1,TEXT_ALIGN_RIGHT)
    end
    
    surface.SetDrawColor(Colors.Undercover_Accent2:Unpack())
    surface.DrawRect(w * 0.75, h * 0.195, w * 0.19, h * 0.005) -- Divider
    
    -- -- Racer List
    local alt = math.floor(CurTime() / 10) % 2 == 1 -- toggles every 10 seconds
    
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
            ["Lap"] = "%s LAPS",
            ["Finished"] = "FINISHED",
            ["Disqualified"] = "DNF",
            ["Busted"] = "BUSTED"
        }
        
        if entry[3] then
            local status_string = Strings[entry[3]]
            
            if status_string then
                local args = {}
                
                if entry[4] then
                    local num = tonumber(entry[4])
                    num =
                    ((num > 0 and "+") or "-") ..
                    string.format((entry[3] == "Lap" and "%s") or "%.2fs", math.abs(num))
                    
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

UV_UI.racing.undercover.main = undercover_racing_main

-- OG

UV_UI.racing.original = {}
UV_UI.pursuit.original = {}

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

UV_UI.racing.original.main = original_racing_main

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
    local lang = language.GetPhrase
    
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
    UVDisplayTimeRace((UVHUDRaceInfo.Info.Started and (CurTime() - UVHUDRaceInfo.Info.Time)) or 0),
    "UVFont5",
    w * 0.5,
    h * 0.0775,
    Color(255, 255, 255),
    TEXT_ALIGN_CENTER)
    
    -- Lap & Checkpoint Counter
    -- surface.SetDrawColor(0, 0, 0, 200)
    -- surface.DrawRect(w * 0.8, h * 0.155, w * 0.175, h * 0.05)
    
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
                    num = ((num > 0 and "+") or "-") .. string.format("%.2f", math.abs(num))
                    
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

local function underground_racing_main( ... )
    local w = ScrW()
    local h = ScrH()
    
    local my_vehicle = select(1, ...)
    local my_array = select(2, ...)
    local string_array = select(3, ...)
    
    local racer_count = #string_array
    local lang = language.GetPhrase
    
    local checkpoint_count = #my_array["Checkpoints"]
    local lang = language.GetPhrase
    
    ------------------------------------
    
    -- Timer
    surface.SetDrawColor(0, 0, 0, 200)
    surface.DrawRect(w * 0.02, h * 0.175, w * 0.175, h * 0.0225)
    draw.DrawText(
    "#uv.race.orig.time",
    "UVFont4",
    w * 0.022,
    h * 0.175,
    Color(255, 255, 255),
    TEXT_ALIGN_LEFT)
    
    draw.DrawText(
    Carbon_FormatRaceTime((UVHUDRaceInfo.Info.Started and (CurTime() - UVHUDRaceInfo.Info.Time)) or 0),
    "UVFont4",
    w * 0.1925,
    h * 0.175,
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
    if racer_count > 1 then
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
    end
    
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
                    num = ((num > 0 and "+") or "-") .. string.format("%.2f", math.abs(num))
                    
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

local function underground2_racing_main( ... )
    local w = ScrW()
    local h = ScrH()
    
    local my_vehicle = select(1, ...)
    local my_array = select(2, ...)
    local string_array = select(3, ...)
    
    local racer_count = #string_array
    local lang = language.GetPhrase
    
    local checkpoint_count = #my_array["Checkpoints"]
    local lang = language.GetPhrase
    
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
    
    draw.DrawText(
    UVDisplayTimeRace((UVHUDRaceInfo.Info.Started and (CurTime() - UVHUDRaceInfo.Info.Time)) or 0),
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
        "#uv.race.hud.lap",
        "UVFont5",
        w * 0.722,
        h * 0.2075,
        Color(255, 255, 255),
        TEXT_ALIGN_LEFT) -- Lap Counter
        draw.DrawText(
        my_array.Lap .. "/" .. UVHUDRaceInfo.Info.Laps,
        "UVFont5",
        w * 0.97,
        h * 0.155,
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
    local lang = language.GetPhrase
    
    -- Position Counter
    if racer_count > 1 then
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
    end
    
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
                    num = ((num > 0 and "+") or "-") .. string.format("%.2f", math.abs(num))
                    
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

-- UV_Pursuit_UI = {
--     ["mostwanted"] = {
--         main = function(...)
--             if UVHUDDisplayPursuit then
--             end
--             outofpursuit = CurTime()

--             local UVHeatBountyMin
--             local UVHeatBountyMax
--             -- local element1 = {
--             -- { x = w/1.35, y = h/20 },
--             -- { x = w/1.155, y = 0 },
--             -- { x = w, y = 0 },
--             -- { x = w, y = h/7 },
--             -- { x = w/1.35, y = h/7 },
--             -- }
--             -- surface.SetDrawColor( 0, 0, 0, 200)
--             -- draw.NoTexture()
--             -- surface.DrawPoly( element1 )
--             if UVHUDCopMode then
--                 UVBustedColor = Color(255, 255, 255, 50)
--                 UVHUDDisplayBusting = false
--             end

--             if UVHUDCopMode and next(UVHUDWantedSuspects) ~= nil then
--                 local ply = LocalPlayer()

--                 UVClosestSuspect = nil
--                 UVHUDDisplayBusting = false

--                 local closestDistance = math.huge

--                 for _, suspect in pairs(UVHUDWantedSuspects) do
--                     local dist = ply:GetPos():DistToSqr(suspect:GetPos())

--                     if dist < 250000 and dist < closestDistance then
--                         closestDistance = dist
--                         UVClosestSuspect = suspect
--                     end
--                 end

--                 if UVClosestSuspect then
--                     if UVClosestSuspect.beingbusted then
--                         UVHUDDisplayBusting = true
--                         UVBustingProgress = UVClosestSuspect.uvbustingprogress

--                         local blink = 255 * math.abs(math.sin(RealTime() * 8))
--                         UVBustedColor = Color(255, blink, blink)
--                     end
--                 end
--             end

--             if not UVHUDRace then
--                 if hudyes then
--                     local ResourceText = UVResourcePoints

--                     -- [[ Commander Stuff ]]
--                     if UVOneCommanderActive then
--                         if not UVHUDCommanderLastHealth or not UVHUDCommanderLastMaxHealth then
--                             UVHUDCommanderLastHealth = 0
--                             UVHUDCommanderLastMaxHealth = 0
--                         end
--                         if IsValid(UVHUDCommander) then
--                             if UVHUDCommander.IsSimfphyscar then
--                                 UVHUDCommanderLastHealth = UVHUDCommander:GetCurHealth()
--                                 UVHUDCommanderLastMaxHealth =
--                                 UVUOneCommanderHealth:GetInt() - (UVHUDCommander:GetMaxHealth() * 0.3)
--                             elseif UVHUDCommander.IsGlideVehicle then
--                                 local enginehealth = UVHUDCommander:GetEngineHealth()
--                                 UVHUDCommanderLastHealth = UVHUDCommander:GetChassisHealth() * enginehealth
--                                 UVHUDCommanderLastMaxHealth = UVUOneCommanderHealth:GetInt()
--                             elseif vcmod_main then
--                                 UVHUDCommanderLastHealth =
--                                 UVUOneCommanderHealth:GetInt() * (UVHUDCommander:VC_getHealth() / 100) --vcmod returns % health clientside
--                                 UVHUDCommanderLastMaxHealth = UVUOneCommanderHealth:GetInt()
--                             else
--                                 UVHUDCommanderLastHealth = UVHUDCommander:Health()
--                                 UVHUDCommanderLastMaxHealth = UVUOneCommanderHealth:GetInt()
--                             end
--                         end
--                         local healthratio = UVHUDCommanderLastHealth / UVHUDCommanderLastMaxHealth
--                         local healthcolor
--                         if healthratio >= 0.5 then
--                             healthcolor = Color(255, 255, 255, 200)
--                         elseif healthratio >= 0.25 then
--                             if math.floor(RealTime() * 2) == math.Round(RealTime() * 2) then
--                                 healthcolor = Color(255, 0, 0)
--                             else
--                                 healthcolor = Color(255, 255, 255)
--                             end
--                         else
--                             if math.floor(RealTime() * 4) == math.Round(RealTime() * 4) then
--                                 healthcolor = Color(255, 0, 0)
--                             else
--                                 healthcolor = Color(255, 255, 255)
--                             end
--                         end
--                         ResourceText = "⛊"
--                         local element3 = {
--                             {x = w / 3, y = 0},
--                             {x = w / 3 + 12 + w / 3, y = 0},
--                             {x = w / 3 + 12 + w / 3 - 25, y = h / 20},
--                             {x = w / 3 + 25, y = h / 20}
--                         }
--                         surface.SetDrawColor(0, 0, 0, 200)
--                         draw.NoTexture()
--                         surface.DrawPoly(element3)
--                         if healthratio > 0 then
--                             surface.SetDrawColor(Color(109, 109, 109, 200))
--                             surface.DrawRect(w / 3 + 25, h / 20, w / 3 - 38, 8)
--                             surface.SetDrawColor(healthcolor)
--                             local T = math.Clamp((healthratio) * (w / 3 - 38), 0, w / 3 - 38)
--                             surface.DrawRect(w / 3 + 25, h / 20, T, 8)
--                         end
--                         draw.DrawText(
--                         "⛊ " .. lang("uv.unit.commander") .. " ⛊",
--                         "UVFont5UI-BottomBar",
--                         w / 2,
--                         0,
--                         Color(0, 161, 255),
--                         TEXT_ALIGN_CENTER
--                     )
--                 end

--                 -- [ Upper Right Info Box ] --
--                 -- Timer
--                 surface.SetDrawColor(0, 0, 0, 200)
--                 surface.DrawRect(w * 0.7, h * 0.1, w * 0.275, h * 0.05)
--                 DrawIcon(UVMaterials["CLOCK"], w * 0.71, h * 0.1225, .05, Color(255, 255, 255)) -- Icon
--                 draw.DrawText(UVTimer, "UVFont5", w * 0.97, h * 0.105, Color(255, 255, 255), TEXT_ALIGN_RIGHT)

--                 -- Bounty
--                 surface.SetDrawColor(0, 0, 0, 200)
--                 surface.DrawRect(w * 0.7, h * 0.155, w * 0.275, h * 0.05)
--                 draw.DrawText(
--                 "#uv.hud.bounty",
--                 "UVFont5",
--                 w * 0.7025,
--                 h * 0.157,
--                 Color(255, 255, 255),
--                 TEXT_ALIGN_LEFT
--             ) -- Lap Counter
--             draw.DrawText(UVBounty, "UVFont5", w * 0.97, h * 0.157, Color(255, 255, 255), TEXT_ALIGN_RIGHT) -- Bounty Counter

--             -- Heat Level
--             surface.SetDrawColor(0, 0, 0, 200)
--             surface.DrawRect(w * 0.7, h * 0.21, w * 0.275, h * 0.05)

--             if UVHeatLevel == 1 then
--                 UVHeatBountyMin = UVUHeatMinimumBounty1:GetInt()
--                 UVHeatBountyMax = UVUHeatMinimumBounty2:GetInt()
--             elseif UVHeatLevel == 2 then
--                 UVHeatBountyMin = UVUHeatMinimumBounty2:GetInt()
--                 UVHeatBountyMax = UVUHeatMinimumBounty3:GetInt()
--             elseif UVHeatLevel == 3 then
--                 UVHeatBountyMin = UVUHeatMinimumBounty3:GetInt()
--                 UVHeatBountyMax = UVUHeatMinimumBounty4:GetInt()
--             elseif UVHeatLevel == 4 then
--                 UVHeatBountyMin = UVUHeatMinimumBounty4:GetInt()
--                 UVHeatBountyMax = UVUHeatMinimumBounty5:GetInt()
--             elseif UVHeatLevel == 5 then
--                 UVHeatBountyMin = UVUHeatMinimumBounty5:GetInt()
--                 UVHeatBountyMax = UVUHeatMinimumBounty6:GetInt()
--             elseif UVHeatLevel == 6 then
--                 UVHeatBountyMin = UVUHeatMinimumBounty6:GetInt()
--                 UVHeatBountyMax = math.huge
--             end

--             DrawIcon(UVMaterials["HEAT"], w * 0.71, h * 0.235, .05, Color(255, 255, 255)) -- Icon
--             draw.DrawText(UVHeatLevel, "UVFont5", w * 0.74, h * 0.2125, Color(255, 255, 255), TEXT_ALIGN_RIGHT)

--             surface.SetDrawColor(Color(109, 109, 109, 200))
--             surface.DrawRect(w * 0.745, h * 0.2175, w * 0.225, h * 0.035)
--             surface.SetDrawColor(Color(255, 255, 255))
--             local HeatProgress = 0
--             if MaxHeatLevel:GetInt() ~= UVHeatLevel then
--                 if UVUTimeTillNextHeatEnabled:GetInt() == 1 and UVTimeTillNextHeat then --Time till next heat level
--                     if UVHeatLevel == 1 then
--                         local maxtime = UVUTimeTillNextHeat1:GetInt()
--                         HeatProgress = (maxtime - UVTimeTillNextHeat) / maxtime
--                     elseif UVHeatLevel == 2 then
--                         local maxtime = UVUTimeTillNextHeat2:GetInt()
--                         HeatProgress = (maxtime - UVTimeTillNextHeat) / maxtime
--                     elseif UVHeatLevel == 3 then
--                         local maxtime = UVUTimeTillNextHeat3:GetInt()
--                         HeatProgress = (maxtime - UVTimeTillNextHeat) / maxtime
--                     elseif UVHeatLevel == 4 then
--                         local maxtime = UVUTimeTillNextHeat4:GetInt()
--                         HeatProgress = (maxtime - UVTimeTillNextHeat) / maxtime
--                     elseif UVHeatLevel == 5 then
--                         local maxtime = UVUTimeTillNextHeat5:GetInt()
--                         HeatProgress = (maxtime - UVTimeTillNextHeat) / maxtime
--                     elseif UVHeatLevel == 6 then
--                         HeatProgress = 0
--                     end
--                 else
--                     HeatProgress = ((UVBountyNo - UVHeatBountyMin) / (UVHeatBountyMax - UVHeatBountyMin))
--                 end
--             end
--             local B = math.Clamp((HeatProgress) * w * 0.225, 0, w * 0.225)
--             local blink = 255 * math.abs(math.sin(RealTime() * 4))
--             local blink2 = 255 * math.abs(math.sin(RealTime() * 6))
--             local blink3 = 255 * math.abs(math.sin(RealTime() * 8))

--             if HeatProgress >= 0.6 and HeatProgress < 0.75 then
--                 surface.SetDrawColor(Color(255, blink, blink))
--             elseif HeatProgress >= 0.75 and HeatProgress < 0.9 then
--                 surface.SetDrawColor(Color(255, blink2, blink2))
--             elseif HeatProgress >= 0.9 and HeatProgress < 1 then
--                 surface.SetDrawColor(Color(255, blink3, blink3))
--             elseif HeatProgress >= 1 then
--                 surface.SetDrawColor(Color(255, 0, 0))
--             end

--             surface.DrawRect(w * 0.745, h * 0.2175, B, h * 0.035)

--             -- [ Bottom Info Box ] --
--             local middlergb = {
--                 r = 255,
--                 g = 255,
--                 b = 255,
--                 a = 255 * math.abs(math.sin(RealTime() * 4))
--             }
--             local UVEvasionColor = Color(255, 255, 255, 50)
--             local bottomy = h * 0.86
--             local bottomy2 = h * 0.9
--             local bottomy3 = h * 0.91
--             local bottomy4 = h * 0.81
--             local bottomy5 = h * 0.83
--             local bottomy6 = h * 0.79

--             if not UVHUDDisplayCooldown then
--                 -- General Icons
--                 draw.DrawText(
--                 UVWrecks,
--                 "UVFont5WeightShadow",
--                 w * 0.64,
--                 bottomy4,
--                 UVWrecksColor,
--                 TEXT_ALIGN_RIGHT
--             )
--             DrawIcon(UVMaterials["UNITS_DISABLED"], w * 0.66, bottomy5, 0.06, UVWrecksColor)

--             draw.DrawText(UVTags, "UVFont5WeightShadow", w * 0.36, bottomy4, UVTagsColor, TEXT_ALIGN_LEFT)
--             DrawIcon(UVMaterials["UNITS_DAMAGED"], w * 0.345, bottomy5, 0.06, UVTagsColor)

--             draw.DrawText(
--             ResourceText,
--             "UVFont5WeightShadow",
--             w * 0.5,
--             bottomy4,
--             UVUnitsColor,
--             TEXT_ALIGN_CENTER
--         )
--         DrawIcon(UVMaterials["UNITS"], w * 0.5, bottomy6, .07, UVUnitsColor)

--         -- Evade Box, All BG
--         surface.SetDrawColor(200, 200, 200, 100)
--         surface.DrawRect(w * 0.333, bottomy2, w * 0.34, h * 0.01)

--         -- Evade Box, Busted Meter
--         if UVHUDDisplayBusting and not UVHUDDisplayCooldown then
--             if not BustingProgress or BustingProgress == 0 then
--                 BustingProgress = CurTime()
--             end

--             local T = math.Clamp((UVBustingProgress / UVBustTimer) * (w * 0.1515), 0, w * 0.1515)
--             surface.SetDrawColor(255, 0, 0)
--             surface.DrawRect(w * 0.333 + (w * 0.1515 - T), bottomy2, T, h * 0.01)
--             middlergb = {
--                 r = 255,
--                 g = 0,
--                 b = 0,
--                 a = 255
--             }
--         else
--             UVBustedColor = Color(255, 255, 255, 50)
--             BustingProgress = 0
--         end

--         -- Evade Box, Evade Meter
--         if not UVHUDDisplayNotification and not UVHUDDisplayCooldown and UnitsChasing == 0 then
--             --UVSoundHeat(UVHeatLevel)
--             if not EvadingProgress or EvadingProgress == 0 then
--                 EvadingProgress = CurTime()
--                 UVEvadingProgress = EvadingProgress
--             end

--             local T = math.Clamp((UVEvadingProgress) * (w * 0.165), 0, w * 0.165)
--             surface.SetDrawColor(155, 207, 0)
--             surface.DrawRect(w * 0.51, bottomy2, T, h * 0.01)
--             middlergb = {
--                 r = 155,
--                 g = 207,
--                 b = 0,
--                 a = 255
--             }
--             UVEvasionColor = Color(blink, 255, blink)
--         else
--             EvadingProgress = 0
--         end

--         -- Evade Box, Middle
--         surface.SetDrawColor(middlergb.r, middlergb.g, middlergb.b, middlergb.a)
--         surface.DrawRect(w * 0.49, bottomy2, w * 0.021, h * 0.01)

--         -- Evade Box, Dividers
--         surface.SetDrawColor(255, 255, 255, 255)
--         surface.DrawRect(w * 0.485, bottomy2, w * 0.005, h * 0.01)
--         surface.DrawRect(w * 0.4, bottomy2, w * 0.005, h * 0.01)

--         surface.DrawRect(w * 0.51, bottomy2, w * 0.005, h * 0.01)
--         surface.DrawRect(w * 0.6, bottomy2, w * 0.005, h * 0.01)

--         -- Upper Box
--         surface.SetDrawColor(0, 0, 0, 200)
--         surface.DrawRect(w * 0.333, bottomy, w * 0.34, h * 0.04)
--         draw.DrawText(
--         "#uv.chase.busted",
--         "UVFont5UI",
--         w * 0.34,
--         bottomy,
--         UVBustedColor,
--         TEXT_ALIGN_LEFT
--     )
--     draw.DrawText(
--     "#uv.chase.evade",
--     "UVFont5UI",
--     w * 0.66,
--     bottomy,
--     UVEvasionColor,
--     TEXT_ALIGN_RIGHT
-- )

-- -- Lower Box

-- local shade_theme_color =
-- (UVHUDCopMode and table.Copy(Colors.CopThemeShade)) or table.Copy(Colors.RacerThemeShade)
-- local theme_color =
-- (UVHUDCopMode and table.Copy(Colors.CopTheme)) or table.Copy(Colors.RacerTheme)

-- shade_theme_color.a = shade_theme_color.a - 35
-- theme_color.a = theme_color.a - 35

-- surface.SetDrawColor(shade_theme_color:Unpack())
-- surface.DrawRect(w * 0.333, bottomy3, w * 0.34, h * 0.05)

-- surface.SetDrawColor(theme_color:Unpack())
-- --DrawIcon( UVMaterials['CLOCK'], w*0.71, h*0.1225, .05, Color(255,255,255) ) -- Icon
-- surface.SetMaterial(UVMaterials["BACKGROUND"])
-- surface.DrawTexturedRect(w * 0.333, bottomy3, w * 0.34, h * 0.05)

-- -- surface.SetDrawColor( 0, 0, 0, 200)
-- -- surface.DrawRect( w*0.333, bottomy3, w*0.34, h*0.05)

-- local lbtext = "REPLACEME"
-- local uloc, utype = "uv.chase.unit", UnitsChasing
-- if not UVHUDCopMode then
--     if UnitsChasing ~= 1 then
--         uloc = "uv.chase.units"
--     end
-- else
--     utype = UVHUDWantedSuspectsNumber
--     uloc = "uv.chase.suspects"
-- end

-- --local color = Color(255,255,255)
-- if not UVBackupColor then
--     UVBackupColor = Color(255, 255, 255)
-- end
-- local num = UVBackupTimerSeconds

-- if not UVHUDDisplayBackupTimer then
--     lbtext = string.format(lang(uloc), utype)
-- else
--     if num then
--         if num < 10 and _last_backup_pulse_second ~= math.floor(num) then
--             _last_backup_pulse_second = math.floor(num)

--             hook.Remove("Think", "UVBackupColorPulse")
--             UVBackupColor = Color(255, 255, 0)

--             hook.Add(
--             "Think",
--             "UVBackupColorPulse",
--             function()
--                 UVBackupColor.b = UVBackupColor.b + 600 * RealFrameTime()
--                 if UVBackupColor.b >= 255 then
--                     hook.Remove("Think", "UVBackupColorPulse")
--                 end
--             end
--         )
--     end
-- end

-- lbtext = string.format(lang("uv.chase.backupin"), UVBackupTimer)
-- end

-- draw.DrawText(
-- lbtext,
-- "UVFont5UI-BottomBar",
-- w * 0.5,
-- bottomy3 * 1.001,
-- UVBackupColor,
-- TEXT_ALIGN_CENTER
-- )
-- else
--     -- Lower Box
--     -- Evade Box, All BG (Moved to inner if clauses)

--     -- Evade Box, Cooldown Meter
--     if UVHUDDisplayCooldown then
--         if not CooldownProgress or CooldownProgress == 0 then
--             CooldownProgress = CurTime()
--         end

--         UVSoundCooldown()
--         EvadingProgress = 0

--         -- Upper Box
--         if not UVHUDCopMode then
--             if UVHUDDisplayHidingPrompt then
--                 -- surface.SetMaterial(UVMaterials['BACKGROUND'])
--                 surface.SetMaterial(Material("unitvehicles/hud/bg_anim"))
--                 surface.SetDrawColor(0, 175, 0, 200)
--                 surface.DrawTexturedRect(w * 0.333, bottomy, w * 0.34, h * 0.05)

--                 local blink = 255 * math.Clamp(math.abs(math.sin(RealTime() * 2)), .7, 1)
--                 color = Color(blink, 255, blink)

--                 surface.SetDrawColor(130, 199, 74, 124)
--                 surface.DrawRect(w * 0.333, bottomy, w * 0.34, h * 0.05)
--                 draw.DrawText(
--                 "#uv.chase.hiding",
--                 "UVFont5UI-BottomBar",
--                 w * 0.5,
--                 bottomy,
--                 color,
--                 TEXT_ALIGN_CENTER
--             )
--         end

--         surface.SetDrawColor(200, 200, 200)
--         surface.DrawRect(w * 0.333, bottomy2, w * 0.34, h * 0.01)

--         local T = math.Clamp((UVCooldownTimer) * (w * 0.34), 0, w * 0.34)
--         surface.SetDrawColor(75, 75, 255)
--         surface.DrawRect(w * 0.333, bottomy2, T, h * 0.01)

--         surface.SetDrawColor(0, 0, 0, 200)
--         surface.DrawRect(w * 0.333, bottomy3, w * 0.34, h * 0.05)
--         draw.DrawText(
--         "#uv.chase.cooldown",
--         "UVFont5UI-BottomBar",
--         w * 0.5,
--         bottomy3,
--         Color(255, 255, 255),
--         TEXT_ALIGN_CENTER
--     )
-- else
--     local shade_theme_color =
--     (UVHUDCopMode and table.Copy(Colors.CopThemeShade)) or
--     table.Copy(Colors.RacerThemeShade)
--     local theme_color =
--     (UVHUDCopMode and table.Copy(Colors.CopTheme)) or table.Copy(Colors.RacerTheme)

--     -- surface.SetDrawColor( shade_theme_color:Unpack() )
--     -- surface.DrawRect( w*0.333, bottomy2, w*0.34, h*0.01)

--     shade_theme_color.a = shade_theme_color.a - 35
--     theme_color.a = theme_color.a - 35

--     local blink = 255 * math.Clamp(math.abs(math.sin(RealTime())), .7, 1)
--     color = Color(blink, blink, 255)

--     surface.SetDrawColor(shade_theme_color:Unpack())
--     surface.DrawRect(w * 0.333, bottomy3, w * 0.34, h * 0.05)

--     surface.SetDrawColor(theme_color:Unpack())

--     surface.SetMaterial(UVMaterials["BACKGROUND"])
--     surface.DrawTexturedRect(w * 0.333, bottomy3, w * 0.34, h * 0.05)

--     local text = lang("uv.chase.cooldown")
--     draw.DrawText(text, "UVFont5UI-BottomBar", w / 2, bottomy3, color, TEXT_ALIGN_CENTER)
-- end
-- else
--     CooldownProgress = 0
-- end
-- end
-- end
-- end
-- end
-- }
-- }


-- function UVRender(name, func, ...)

-- end
