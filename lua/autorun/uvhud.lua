local Colors = {
    ["MW_LocalPlayer"] = Color(255, 187, 0),
    ["MW_Accent"] = Color(223, 184, 127),
    ["MW_Others"] = Color(255, 255, 255),
    ["MW_Disqualified"] = Color(255, 50, 50, 133),

    ['Carbon_Accent'] = Color(86, 214, 205),
    ['Carbon_LocalPlayer'] = Color(86, 214, 205),
    ["Carbon_Others"] = Color(255, 255, 255),
    ["Carbon_Disqualified"] = Color(255, 50, 50, 133),

}

UVMaterials = {
    ["UNITS_DAMAGED"] = Material("hud/COPS_DAMAGED_ICON.png"),
    ["UNITS_DISABLED"] = Material("hud/COPS_TAKENOUT_ICON.png"),
    ["UNITS"] = Material("hud/COPS_ICON.png"),
    ["HEAT"] = Material("hud/HEAT_ICON.png"),
    ["CLOCK"] = Material("hud/TIMER_ICON.png"),
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

UV_UI = {
    ["mostwanted"] = {
        main = function(...)
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
            draw.DrawText(
                UVDisplayTimeRace((UVHUDRaceInfo.Info.Started and (CurTime() - UVHUDRaceInfo.Info.Time)) or 0),
                "UVFont5",
                w * 0.97,
                h * 0.103,
                Colors.MW_Accent,
                TEXT_ALIGN_RIGHT
            )

            -- Lap & Checkpoint Counter
            surface.SetDrawColor(0, 0, 0, 200)
            surface.DrawRect(w * 0.8, h * 0.155, w * 0.175, h * 0.05)

            if UVHUDRaceInfo.Info.Laps > 1 then
                draw.DrawText("#uv.race.mw.lap", "UVFont5", w * 0.805, h * 0.155, Color(255, 255, 255), TEXT_ALIGN_LEFT) -- Lap Counter
                draw.DrawText(
                    my_array.Lap .. "/" .. UVHUDRaceInfo.Info.Laps,
                    "UVFont5",
                    w * 0.97,
                    h * 0.155,
                    Color(255, 255, 255),
                    TEXT_ALIGN_RIGHT
                ) -- Lap Counter
            else
                DrawIcon(UVMaterials["CHECK"], w * 0.815, h * 0.18, .04, Color(255, 255, 255)) -- Icon
                draw.DrawText(
                    checkpoint_count .. "/" .. GetGlobalInt("uvrace_checkpoints"),
                    "UVFont5",
                    w * 0.97,
                    h * 0.155,
                    Color(255, 255, 255),
                    TEXT_ALIGN_RIGHT
                )
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

                draw.DrawText(
                    UVHUDRaceCurrentPos,
                    "UVFont5",
                    w * 0.755,
                    h * 0.107,
                    Colors.MW_Accent,
                    TEXT_ALIGN_CENTER
                ) -- Upper, Your Position
                draw.DrawText(
                    UVHUDRaceCurrentParticipants,
                    "UVFont5",
                    w * 0.755,
                    h * 0.155,
                    Color(255, 255, 255),
                    TEXT_ALIGN_CENTER
                ) -- Lower, Total Positions
            end

            -- Racer List
            local alt = math.floor(CurTime() / 10) % 2 == 1 -- toggles every 10 seconds
            for i = 1, racer_count, 1 do
                --if racer_count == 1 then return end
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

                local status_text = "-----"

                if entry[3] then
                    local status_string = Strings[entry[3]]

                    if status_string then
                        local args = {}

                        if entry[4] then
                            local num = tonumber(entry[4])
                            num = ((num > 0 and "+") or "-") .. string.format("%.2fs", math.abs(num))

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

                draw.DrawText(i, "UVFont4", w * 0.725, (h * 0.185) + racercount, color, TEXT_ALIGN_LEFT)
                draw.DrawText(text, "UVFont4", w * 0.97, (h * 0.185) + racercount, color, TEXT_ALIGN_RIGHT)
            end
        end
    },
    ["carbon"] = {
        main = function(...)
            local w = ScrW()
            local h = ScrH()

            local my_vehicle = select(1, ...)
            local my_array = select(2, ...)
            local string_array = select(3, ...)

            local racer_count = #string_array

            local checkpoint_count = #my_array["Checkpoints"]

            ------------------------------------

            -- Timer
            surface.SetMaterial(UVMaterials["ARROW_CARBON"])
            -- surface.SetDrawColor( 89, 255, 255, 200)
            -- surface.DrawTexturedRect( w*0.7175, h*0.1, w*0.03, h*0.05)
            DrawIcon(UVMaterials["CLOCK"], w * 0.815, h * 0.1225, .0625, Colors.Carbon_Accent) -- Icon

            surface.SetMaterial(UVMaterials["BACKGROUND_CARBON"])
            surface.SetDrawColor(Colors.Carbon_Accent)
            surface.DrawTexturedRect(w * 0.825, h * 0.1115, w * 0.03, h * 0.025)
            
            draw.DrawText(
                UVDisplayTimeRace((UVHUDRaceInfo.Info.Started and (CurTime() - UVHUDRaceInfo.Info.Time)) or 0),
                "UVFont5",
                w * 0.97,
                h * 0.1,
                Colors.Carbon_Accent,
                TEXT_ALIGN_RIGHT
            )

            -- Lap & Checkpoint Counter
            surface.SetMaterial(UVMaterials["BACKGROUND_CARBON"])
            surface.SetDrawColor(255, 255, 255, 100)
            surface.DrawTexturedRect(w * 0.69, h * 0.155, w * 0.2, h * 0.05)
            local laptext = "<color="..Colors.Carbon_Accent:Unpack()..">" .. my_array.Lap .. ":  </color>" .. UVHUDRaceInfo.Info.Laps
            if UVHUDRaceInfo.Info.Laps > 1 then
                draw.DrawText(
                    "#uv.race.mw.lap",
                    "UVFont5",
                    w * 0.875,
                    h * 0.155,
                    Color(255, 255, 255, 175),
                    TEXT_ALIGN_RIGHT
                ) -- Lap Counter
            else
                draw.DrawText(
                    "#uv.race.carbon.check",
                    "UVFont5",
                    w * 0.875,
                    h * 0.155,
                    Color(255, 255, 255, 175),
                    TEXT_ALIGN_RIGHT
                ) -- Checkpoint Text
                laptext =
                    "<color="..Colors.Carbon_Accent:Unpack()..">".. checkpoint_count .. ":  </color>" .. GetGlobalInt("uvrace_checkpoints")
            end
            markup.Parse("<font=UVFont5>" .. laptext):Draw(w * 0.97, h * 0.155, TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT)

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
                            num = ((num > 0 and "+") or "-") .. string.format("%.2f", math.abs(num))

                            table.insert(args, num)
                        end

                        status_text = #args <= 0 and status_string or string.format(status_string, unpack(args))
                    end
                end
                -- local text = alt and (entry[3] .. "  " .. i) or (entry[2] .. "  " .. i)
                local color = nil

                if is_local_player then
                    color = Colors.Carbon_LocalPlayer
                elseif entry[3] == "Disqualified" or entry[3] == "Busted" then
                    color = Colors.Carbon_Disqualified
                else
                    color = Colors.Carbon_Others
                end

                local text = alt and (status_text) or (racer_name .. "   " .. i)

                -- This should only draw on LocalPlayer() but couldn't figure it out
                if is_local_player then
                    surface.SetMaterial(UVMaterials["BACKGROUND_CARBON_INVERTED"])
                    surface.SetDrawColor(89, 255, 255, 100)
                    surface.DrawTexturedRect(w * 0.72, h * 0.185 + racercount, w * 0.255, h * 0.025)
                end

                draw.DrawText(text, "UVFont4", w * 0.97, (h * 0.185) + racercount, color, TEXT_ALIGN_RIGHT)
            end
        end
    }
}

-- function UVRender(name, func, ...)

-- end
