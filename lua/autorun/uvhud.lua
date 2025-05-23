local Colors = {
    ["MW_LocalPlayer"] = Color(255, 187, 0),
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

    ['Original_LocalPlayer'] = Color(255, 217, 0),
    ['Original_Others'] = Color(255, 255, 255),
    ["Original_Disqualified"] = Color(255, 50, 50, 133),

    ['Undercover_Accent1'] = Color(255, 255, 255),
    ['Undercover_Accent2'] = Color(187, 226, 220),
    ['Undercover_Accent2Transparent'] = Color(187, 226, 220, 150)
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
        return string.format("%02d.%02d", seconds, milliseconds)
    end
end

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
                --DrawIcon(UVMaterials["CHECK"], w * 0.815, h * 0.18, .04, Color(255, 255, 255)) -- Icon
                draw.DrawText(
                    "#uv.race.completepercent",
                    "UVFont5",
                    w * 0.805,
                    h * 0.155,
                    Color(255, 255, 255),
                    TEXT_ALIGN_LEFT
                )
                draw.DrawText(
                    math.floor(((checkpoint_count / GetGlobalInt("uvrace_checkpoints")) * 100)) .. "%",
                     --checkpoint_count .. "/" .. GetGlobalInt("uvrace_checkpoints"),
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

                draw.DrawText(UVHUDRaceCurrentPos, "UVFont5", w * 0.755, h * 0.107, Colors.MW_Accent, TEXT_ALIGN_CENTER) -- Upper, Your Position
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
            --surface.SetMaterial(UVMaterials["ARROW_CARBON"])
            -- surface.SetDrawColor( 89, 255, 255, 200)
            -- surface.DrawTexturedRect( w*0.7175, h*0.1, w*0.03, h*0.05)
            surface.SetMaterial(UVMaterials["ARROW_CARBON"])
            surface.SetDrawColor(Colors.Carbon_AccentTransparent)
            surface.DrawTexturedRect(w * 0.815, h * 0.111, w * 0.025, h * 0.033)

            DrawIcon(UVMaterials["CLOCK_BG"], w * 0.815, h * 0.124, .0625, Colors.Carbon_Accent) -- Icon

            draw.DrawText(
                Carbon_FormatRaceTime((UVHUDRaceInfo.Info.Started and (CurTime() - UVHUDRaceInfo.Info.Time)) or 0),
                "UVCarbonFont",
                w * 0.97,
                h * 0.105,
                Colors.Carbon_Accent,
                TEXT_ALIGN_RIGHT
            )

            -- Lap & Checkpoint Counter
            surface.SetMaterial(UVMaterials["BACKGROUND_CARBON"])
            surface.SetDrawColor(Colors.Carbon_Accent2Transparent:Unpack())
            surface.DrawTexturedRect(w * 0.69, h * 0.157, w * 0.2, h * 0.04)

            local laptext =
                "<color=" ..
                Colors.Carbon_Accent.r ..
                    ", " ..
                        Colors.Carbon_Accent.g ..
                            ", " ..
                                Colors.Carbon_Accent.b .. ">" .. my_array.Lap .. ": </color>" .. UVHUDRaceInfo.Info.Laps
            if UVHUDRaceInfo.Info.Laps > 1 then
                draw.DrawText(
                    "#uv.race.mw.lap",
                    "UVCarbonFont",
                    w * 0.875,
                    h * 0.155,
                    Colors.Carbon_Accent2Bright,
                    TEXT_ALIGN_RIGHT
                ) -- Lap Counter
            else
                -- laptext =
                --     "<color="..Colors.Carbon_Accent.r..", "..Colors.Carbon_Accent.g..", ".. Colors.Carbon_Accent.b..">".. checkpoint_count .. ": </color>" .. GetGlobalInt("uvrace_checkpoints")
                draw.DrawText(
                    "#uv.race.completepercent",
                    "UVCarbonFont",
                    w * 0.875,
                    h * 0.155,
                    Colors.Carbon_Accent2Bright,
                    TEXT_ALIGN_RIGHT
                ) -- Checkpoint Text
                laptext = math.floor(((checkpoint_count / GetGlobalInt("uvrace_checkpoints")) * 100)) .. "%"
            end
            markup.Parse("<font=UVCarbonFont>" .. laptext):Draw(w * 0.97, h * 0.155, TEXT_ALIGN_RIGHT, TEXT_ALIGN_RIGHT)

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
                            num = ((num > 0 and "+ ") or "- ") .. string.format("%.2f", math.abs(num))

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
                    color = (i > 4 and Colors.Carbon_OthersDark) or Colors.Carbon_Others
                end

                local text = alt and (status_text) or (racer_name .. "   " .. i)

                -- This should only draw on LocalPlayer() but couldn't figure it out
                if is_local_player then
                    surface.SetMaterial(UVMaterials["BACKGROUND_CARBON_INVERTED"])
                    surface.SetDrawColor(89, 255, 255, 100)
                    surface.DrawTexturedRect(w * 0.72, h * 0.185 + racercount, w * 0.255, h * 0.025)
                end

                draw.DrawText(
                    text,
                    "UVCarbonLeaderboardFont",
                    w * 0.97,
                    (h * 0.185) + racercount,
                    color,
                    TEXT_ALIGN_RIGHT
                )
            end
        end
    },
    ["undercover"] = {
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
            --surface.SetMaterial(UVMaterials["ARROW_CARBON"])
            -- surface.SetDrawColor( 89, 255, 255, 200)
            -- surface.DrawTexturedRect( w*0.7175, h*0.1, w*0.03, h*0.05)
            -- surface.SetMaterial(UVMaterials["ARROW_CARBON"])
            -- surface.SetDrawColor(Colors.Carbon_AccentTransparent)
            -- surface.DrawTexturedRect(w * 0.815, h * 0.111, w * 0.025, h * 0.033)
            
            draw.DrawText(
                "#uv.race.time",
                "UVUndercoverAccentFont",
                w * 0.75,
                h * 0.123,
                Colors.Undercover_Accent2,
                TEXT_ALIGN_LEFT
            )

            draw.DrawText(
                Carbon_FormatRaceTime((UVHUDRaceInfo.Info.Started and (CurTime() - UVHUDRaceInfo.Info.Time)) or 0),
                "UVUndercoverWhiteFont",
                w * 0.75,
                h * 0.15,
                Colors.Undercover_Accent1,
                TEXT_ALIGN_LEFT
            )

            if UVHUDRaceInfo.Info.Laps > 1 then
                
            draw.DrawText(
                "#uv.race.mw.lap",
                "UVUndercoverAccentFont",
                w * 0.94,
                h * 0.123,
                Colors.Undercover_Accent2,
                TEXT_ALIGN_RIGHT
            )
            draw.DrawText(
                my_array.Lap .. "/" .. UVHUDRaceInfo.Info.Laps,
                "UVUndercoverWhiteFont",
                w * 0.94,
                h * 0.15,
                Colors.Undercover_Accent1,
                TEXT_ALIGN_RIGHT
            )
                -- draw.DrawText("#uv.race.mw.lap", "UVFont5", w * 0.805, h * 0.155, Color(255, 255, 255), TEXT_ALIGN_LEFT) -- Lap Counter
                -- draw.DrawText(
                --     my_array.Lap .. "/" .. UVHUDRaceInfo.Info.Laps,
                --     "UVFont5",
                --     w * 0.97,
                --     h * 0.155,
                --     Color(255, 255, 255),
                --     TEXT_ALIGN_RIGHT
                -- ) -- Lap Counter
            else
                --DrawIcon(UVMaterials["CHECK"], w * 0.815, h * 0.18, .04, Color(255, 255, 255)) -- Icon
                draw.DrawText(
                "#uv.race.completepercent",
                "UVUndercoverAccentFont",
                w * 0.94,
                h * 0.123,
                Colors.Undercover_Accent2,
                TEXT_ALIGN_RIGHT
            )
            draw.DrawText(
                math.floor(((checkpoint_count / GetGlobalInt("uvrace_checkpoints")) * 100)) .. "%",
                "UVUndercoverWhiteFont",
                w * 0.94,
                h * 0.15,
                Colors.Undercover_Accent1,
                TEXT_ALIGN_RIGHT
            )
            end

            surface.SetDrawColor(Colors.Undercover_Accent2:Unpack())
            surface.DrawRect(w * 0.75, h * 0.195, w * 0.19, h * 0.005) -- Divider

            -- -- Racer List
            local alt = math.floor(CurTime() / 10) % 2 == 1 -- toggles every 10 seconds

            local baseY = h * 0.21                -- starting Y position of the list (adjust this freely)
            local spacing = h * 0.035             -- spacing between each racer (vertical gap)

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
                            num = ((num > 0 and "+") or "-") .. string.format("%.2f", math.abs(num))

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

                    draw.DrawText(
                        text,
                        "UVUndercoverLeaderboardFont",
                        w * 0.76,
                        baseY + racercount,
                        color,
                        TEXT_ALIGN_LEFT
                    )

                    draw.DrawText(
                        i,
                        "UVUndercoverLeaderboardFont",
                        w * 0.93,
                        baseY + racercount,
                        color,
                        TEXT_ALIGN_RIGHT
                    )
                else
                    draw.DrawText(
                    text,
                    "UVUndercoverLeaderboardFont",
                    w * 0.76,
                    baseY + racercount,
                    color,
                    TEXT_ALIGN_LEFT
                )

                draw.DrawText(
                    i,
                    "UVUndercoverLeaderboardFont",
                    w * 0.93,
                    baseY + racercount,
                    color,
                    TEXT_ALIGN_RIGHT
                )
                    
                -- draw.DrawText(
                --     text,
                --     "UVCarbonLeaderboardFont",
                --     w * 0.97,
                --     (h * 0.185) + racercount,
                --     color,
                --     TEXT_ALIGN_RIGHT
                -- )
                end
            end
        end
    },
    ["original"] = {
        main = function(...)
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
            draw.DrawText(
                lang("uv.race.orig.time") ..
                UVDisplayTimeRace((UVHUDRaceInfo.Info.Started and (CurTime() - UVHUDRaceInfo.Info.Time)) or 0) ..
                "\n" ..
                lang("uv.race.orig.check") ..
                checkpoint_count ..
                "/" ..
                GetGlobalInt("uvrace_checkpoints") ..
                "\n" ..
                (UVHUDRaceInfo.Info.Laps > 1 and
                lang("uv.race.orig.lap") ..
                my_array.Lap .. "/" .. UVHUDRaceInfo.Info.Laps .. "\n" or "") ..
                lang("uv.race.orig.pos") ..
                UVHUDRaceCurrentPos .. "/" .. UVHUDRaceCurrentParticipants,
                "UVFont",
                10,
                h / 7,
                Color(255, 255, 255),
                TEXT_ALIGN_LEFT
            )
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

                local text = alt and (status_text) or (i..". "..racer_name)

                draw.DrawText(
                    text,
                    "UVFont4",
                    10,
                    (h / racerpos) + i * ((racer_count > 5 and 20) or 28),
                    color,
                    TEXT_ALIGN_LEFT
                )
            end
        end
    }
}

-- function UVRender(name, func, ...)

-- end
