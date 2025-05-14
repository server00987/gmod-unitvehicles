AddCSLuaFile()

local LBColors = {
    ["LocalPlayer"] = Color(255,221,0),
    ["Others"] = Color(255,255,255),
    ["Disqualified"] = Color(255,255,255,133)
}

local UVRacePlayIntro = false
local UVRacePlayMusic = false 
local UVRacePlayTransition = false

if SERVER then
    UVRaceLaps = CreateConVar( "unitvehicle_racelaps", 1, FCVAR_ARCHIVE, "Number of laps to complete. Set to 1 to have sprint races." )
    
    UVRaceTable = {}
    UVRaceCurrentParticipants = {}
    UVRaceStartTime = CurTime()
    
    util.AddNetworkString( "uvrace_begin" )
    util.AddNetworkString( "uvrace_start" )
    util.AddNetworkString( "uvrace_end" )
    util.AddNetworkString( "uvrace_participants" )
    util.AddNetworkString( "uvrace_notification" )
    util.AddNetworkString( "uvrace_decline" )
    
    util.AddNetworkString( "uvrace_disqualify" )
    
    util.AddNetworkString( "uvrace_checkpointcomplete" )
    util.AddNetworkString( "uvrace_lapcomplete" )
    util.AddNetworkString( "uvrace_racecomplete" )
    
    util.AddNetworkString( "uvrace_info" )
    util.AddNetworkString( "uvrace_invite" )
    
    util.AddNetworkString( "uvrace_racerinvited" )
    
    util.AddNetworkString( "uvrace_announcebestlaptime" )
    
    function UVRaceCheckFinishLine()
        local checkpoints = ents.FindByClass( "uvrace_checkpoint" )
        local highestid = 0
        
        
        for _, checkpoint in pairs( checkpoints ) do
            local id = checkpoint:GetID() or 0
            if id > highestid then
                highestid = id --Highest ID is the finish line
            end
        end
        
        for _, checkpoint in pairs( checkpoints ) do --Recheck all checkpoints just to be sure
            local id = checkpoint:GetID() or 0
            if id == highestid then
                checkpoint:SetFinishLine( true )
            else
                checkpoint:SetFinishLine( false )
            end
        end
        
        SetGlobalInt( "uvrace_checkpoints", highestid )
        
        return highestid
    end
    
    function UVRaceMakeCheckpoints()
        UVRaceRemoveCheckpoints() --Remove old checkpoints
        
        for _, ent in ipairs(ents.FindByClass("uvrace_checkpoint")) do
            local pos = ent:GetPos()
            local mpos = ent:GetMaxPos()
            
            local check = ents.Create("uvrace_brushpoint")
            check:SetPos(pos)
            check:SetPos1(pos)
            check:SetPos2(mpos)
            check:SetID(ent:GetID())
            check:SetSpeedLimit(ent:GetSpeedLimit())
            check:SetFinishLine(ent:GetFinishLine())
            check:Spawn()
        end
        
        timer.Simple(2, function()
            UVRaceStart()
        end)
    end
    
    function UVRaceRemoveCheckpoints()
        for _, ent in ipairs(ents.FindByClass("uvrace_brush*")) do
            ent:Remove()
        end
    end
    
    -- Use vehicles as participants
    function UVRaceAddParticipant( vehicle, driver, sendmsg )
        table.insert( UVRaceCurrentParticipants, vehicle )
        
        vehicle.raceinvited = false
        timer.Remove('RaceInviteExpire'..vehicle:EntIndex())
        
        local driver = UVGetDriver(vehicle)
        local is_player 
        
        vehicle.racefinished = false
        vehicle.uvraceparticipant = true
        vehicle.racedriver = driver
        
        if sendmsg then
            PrintMessage( HUD_PRINTTALK, ((IsValid(driver) and driver:GetName()) or (vehicle.racer or "Racer "..vehicle:EntIndex())).. " has joined the race!" )
        end
        
        vehicle:CallOnRemove( "uvrace_participantremoved", function( ent )
            local driver = UVGetDriver( vehicle )
            UVRaceRemoveParticipant( ent, 'Disqualified' )
        end )
    end
    
    function UVRaceRemoveParticipant( vehicle, reason )
        if UVRaceTable.Participants then
            if UVRaceTable.Participants and UVRaceTable.Participants[ vehicle ] then
                if reason then
                    net.Start( "uvrace_disqualify" )
                    net.WriteEntity(vehicle)
                    net.WriteString(reason)
                    net.Broadcast()
                    
                    UVRaceTable.Participants [vehicle][reason] = true
                end
            end
        end
        
        if table.HasValue( UVRaceCurrentParticipants, vehicle ) then
            table.RemoveByValue( UVRaceCurrentParticipants, vehicle )
            local driver = UVGetDriver( vehicle )
            -- if IsValid(driver) and driver:IsPlayer() then
            --     net.Start( "uvrace_end" )             
            --     net.Send( driver )
            -- end
        end
        
        vehicle:GetPhysicsObject():EnableMotion( true )
        
        vehicle.uvraceparticipant = false
        vehicle.racedriver = nil
        vehicle.currentcheckpoint = nil
        vehicle.currentlap = nil
        vehicle.lastlaptime = nil
        vehicle.bestlaptime = nil
    end
    
    function UVRaceStart() --Start procedure
        if #UVRaceCurrentParticipants == 0 then
            UVRaceEnd()
            PrintMessage( HUD_PRINTTALK, "No participants found!" )
            return 
        end
        
        local checkpoints = ents.FindByClass( "uvrace_brushpoint" )
        if #checkpoints == 0 then
            UVRaceEnd()
            PrintMessage( HUD_PRINTTALK, "No checkpoints found!" )
            return
        elseif #checkpoints == 1 then --If theres only 1 checkpoint, assume its a drag race
            UVRaceLaps:SetInt( 1 )
        end
        
        local spawns = ents.FindByClass( "uvrace_spawn" )
        if #spawns == 0 then
            UVRaceEnd()
            PrintMessage( HUD_PRINTTALK, "No spawns found!" )
            return 
        end
        
        RunConsoleCommand("ai_ignoreplayers", "0") --AI Racers don't move when this is enabled
        
        table.Empty(UVRaceTable)
        
        UVRaceTable['Participants'] = {}
        UVRaceTable['Info'] = {
            ['Started'] = false,
            ['Laps'] = UVRaceLaps:GetInt(),
            ['Racers'] = 0,
            ['Time'] = 0
        }
        
        local time = 7
        for i, vehicle in pairs( UVRaceCurrentParticipants ) do
            local driver = vehicle:GetDriver()
            
            UVRaceTable['Participants'][vehicle] = {
                ['Lap'] = 1,
                ['Position'] = i,
                ['Name'] = ((IsValid(driver) and driver:GetName()) or (vehicle.racer or "Racer "..vehicle:EntIndex())),
                --['Laps'] = {},
                --['BestLapTime'] = CurTime(),
                ['LastLapTime'] = CurTime(),
                ['Finished'] = false,
                ['Disqualified'] = false,
                ['Busted'] = false,
                ['Checkpoints'] = {}
            }
            
            if IsValid(driver) and driver:IsPlayer() then
                net.Start( "uvrace_start" )
                net.WriteInt( time, 11 )
                net.Send( driver )
            end
        end
        
        net.Start( "uvrace_info" )
        net.WriteTable( UVRaceTable )
        net.Broadcast()
        
        timer.Create( "uvrace_start", 1, 7, function()
            local time = timer.RepsLeft( "uvrace_start" )
            for _, vehicle in pairs( UVRaceCurrentParticipants ) do
                local driver = UVGetDriver( vehicle )
                net.Start( "uvrace_start" )
                net.WriteInt( time, 11 )
                net.Send( driver )
            end
            if time == 1 then
                UVRaceBegin()
            end
        end)
        
    end
    
    function UVRaceBegin()
        --Unfreeze all participants
        for _, vehicle in pairs( UVRaceCurrentParticipants ) do
            vehicle:GetPhysicsObject():EnableMotion( true )
            vehicle.racestart = CurTime()
            
            if UVRaceTable['Participants'] and UVRaceTable['Participants'][vehicle] then
                UVRaceTable['Participants'][vehicle]['LastLapTime'] = CurTime()
            end
        end
        
        --unclaim all spawns
        for _, spawn in pairs( ents.FindByClass( "uvrace_spawn" ) ) do
            spawn.claimed = nil
        end
        
        UVRaceStartTime = CurTime()
        UVRaceInProgress = true
        
        UVRaceTable['Info']['Time'] = UVRaceStartTime
        
        net.Start( "uvrace_begin" )
        net.WriteFloat(UVRaceStartTime)
        net.Broadcast()
        
    end
    
    function UVRaceEnd()
        uvbestlaptime = nil
        UVRaceInEffect = nil
        UVRaceInProgress = nil
        
        table.Empty(UVRaceTable)
        
        for _, vehicle in pairs(UVRaceCurrentParticipants) do
            UVRaceRemoveParticipant(vehicle)
        end
        
        if timer.Exists("uvrace_start") then
            timer.Remove("uvrace_start")
        end
        
        table.Empty(UVRaceCurrentParticipants)
        
        for _, ent in ipairs(ents.FindByClass("uvrace_brush*")) do
            ent:Remove()
        end
        
        for _, ent in ipairs(ents.FindByClass("uvrace_checkpoint")) do
            ent:Remove()
        end
        
        for _, ent in ipairs(ents.FindByClass("uvrace_spawn")) do
            ent:Remove()
        end
    end
    
    function UVCheckLapTime( vehicle, name, time )
        if !uvbestlaptime then
            uvbestlaptime = time
            local timedifference = 0
            
            net.Start("uvrace_announcebestlaptime")
            net.WriteFloat( time )
            net.WriteString( name )
            net.WriteFloat( timedifference )
            net.Broadcast()
            
        else
            if time < uvbestlaptime then
                local timedifference = uvbestlaptime - time
                uvbestlaptime = time
                
                net.Start("uvrace_announcebestlaptime")
                net.WriteFloat( time )
                net.WriteString( name )
                net.WriteFloat( timedifference )
                net.Broadcast()
            end
        end
    end
    
    hook.Add("player_activate", "UVRaceArrayInit", function( data )
        local id = data.userid
        local ply = Player(id)
        
        if UVRaceInProgress then
            net.Start( "uvrace_info" )
            net.WriteTable( UVRaceTable )
            net.Send( ply )
        end
    end)
    
    hook.Add("PostCleanupMap", "UVRaceCleanup", function()
        UVRaceEnd()
        
        net.Start( "uvrace_end" )
        net.Broadcast()
    end)
    
    hook.Add( "Think", "UVRacing", function( ply )
        
        if !UVRaceInEffect then return end
        if UVRacePrep then return end
        
        if next( UVRaceCurrentParticipants ) != nil then
            local pos = 0
            local player_table = {}
            
            for _, vehicle in pairs( UVRaceCurrentParticipants ) do
                if IsValid( vehicle ) then
                    local driver = UVGetDriver( vehicle )
                    if IsValid( driver ) then
                        table.insert(player_table, driver)
                    end
                    
                    if vehicle.uvbusted then
                        UVRaceRemoveParticipant( vehicle, 'Busted' )
                        continue
                    end
                    
                    -- Damage check
                    if UVCheckIfWrecked(vehicle) then
                        UVRaceRemoveParticipant( vehicle, 'Disqualified' )
                        continue
                    end
                    
                end
            end
            
        elseif !UVRacePrep then
            UVRaceEnd()
            net.Start( "uvrace_end" )
            net.Broadcast()
        end
        
    end)
    
    net.Receive( "uvrace_invite", function( len, ply ) 
        local bool = net.ReadBool()
        local car = UVGetVehicle( ply )
        
        if !car then return end
        if !car.raceinvited then return end
        
        if bool then
            UVRaceAddParticipant( car, ply, true )
        else
            car.raceinvited = false;
            timer.Remove( 'RaceInviteExpire'..car:EntIndex() )
        end
    end)
else
    function UVSoundRacingStop()
        if UVPlayingRace then
            if timer.Exists("UVRaceMusicTransition") then
                timer.Remove("UVRaceMusicTransition")
            end
            
            UVPlayingRace = false
            
            if UVSoundLoop then
                UVSoundLoop:Stop()
                UVLoadedSounds = nil
                UVSoundLoop = nil
            end
            if UVSoundSource then
                UVSoundSource:Stop()
                UVLoadedSounds = nil
                UVSoundSource = nil
            end
        end
    end
    
    function UVGetRandomSound(folder)
        local files = file.Find("sound/" .. folder .. "/*", "GAME")
        if files and #files > 0 then
            return folder .. "/" .. files[math.random(1, #files)]
        end
        return nil
    end
    
    function UVGetRaceMusicPath(theme, my_vehicle)
        if !RacingMusic:GetBool() then return end
        local isFinalLap = IsValid(my_vehicle)
        and UVHUDRaceLaps > 1
        and UVHUDRaceLaps == UVHUDRaceInfo["Participants"][my_vehicle].Lap
        
        local endingPath = "uvracemusic/" .. theme .. "/ending"
        local racePath = "uvracemusic/" .. theme .. "/race"
        
        if isFinalLap then
            local endingTrack = UVGetRandomSound(endingPath)
            if endingTrack then return endingTrack end
        end
        
        return UVGetRandomSound(racePath)
    end
    
    
    local function PlayRaceMusic(theme, my_vehicle)
        local track = UVGetRaceMusicPath(theme, my_vehicle)
        if track then
            UVPlaySound(track, true)
        end
    end
    
    function UVSoundRacing(my_vehicle)
        if !RacingMusic:GetBool() or (!RacingMusicPriority:GetBool() and UVHUDDisplayPursuit) then return end
        if (not UVHUDRace) or UVPlayingRace or UVSoundDelayed then return end
        
        if timer.Exists("UVRaceMusicTransition") then
            timer.Remove("UVRaceMusicTransition")
        end

        if timer.Exists("UVPursuitThemeReplay") then
		    timer.Remove("UVPursuitThemeReplay")
	    end
        
        local theme = GetConVar("unitvehicle_racetheme"):GetString()
        
        if UVRacePlayIntro then
            UVRacePlayIntro = false
            //UVRacePlayMusic = true
            
            local introTrack = UVGetRandomSound("uvracemusic/" .. theme .. "/intro")
            if introTrack then
                UVPlaySound(introTrack, true)
            else
                PlayRaceMusic(theme, my_vehicle)
                UVRacePlayTransition = true
            end
        elseif UVRacePlayTransition then
            UVRacePlayTransition = false 
            
            local transitionTrack = UVGetRandomSound("uvracemusic/" .. theme .. "/transition")
            
            if transitionTrack then
                UVPlaySound(transitionTrack, true)
            else
                PlayRaceMusic(theme, my_vehicle)
                UVRacePlayTransition = true
            end
        elseif UVRacePlayMusic then
            UVRacePlayTransition = true
            //UVRacePlayMusic = false 
            
            PlayRaceMusic(theme, my_vehicle)
        end
        
        UVPlayingRace = true
        UVPlayingHeat = false
        UVPlayingBusting = false
        UVPlayingCooldown = false
        UVPlayingBusted = false
        UVPlayingEscaped = false
    end
    
    function UVDisplayTimeRace(time) -- include milliseconds in the string
        local formattedtime = string.FormattedTime( time )
        
        local hours = math.floor( time / 3600 )
        if hours < 1 then
            timestring = string.format( "%02d:%02d", formattedtime.m, formattedtime.s )
        else
            timestring = string.format( "%02d:%02d:%02d", formattedtime.h, formattedtime.m, formattedtime.s )
        end
        
        local milliseconds = math.floor( ( time - math.floor( time ) ) * 1000 )
        timestring = timestring .. string.format( ".%03d", milliseconds )
        
        return timestring
    end
    
    function UVFormLeaderboard(racers)
        local lPr = LocalPlayer()
        local sorted_table = {}
        local lVehicle, lArray = nil, nil
        
        for vehicle, array in pairs(racers) do
            if IsValid(vehicle) and vehicle:GetDriver() == lPr then
                lVehicle = vehicle
                lArray = array
            end
            
            table.insert(sorted_table, {
                vehicle = vehicle,
                array = array
            })
        end
        
        if not lArray then return "You are not in a race vehicle." end
        
        local lCheckpointCount = #lArray.Checkpoints
        local leaderboardLines = {}
        
        -- Sort by: lap > checkpoints > checkpoint time
        -- table.sort(sorted_table, function(a, b)
        --     local aData, bData = a.array, b.array
        --     if aData.Lap ~= bData.Lap then
        --         return aData.Lap > bData.Lap
        --     end
        
        --     local aCP, bCP = #aData.Checkpoints, #bData.Checkpoints
        --     if aCP ~= bCP then
        --         return aCP > bCP
        --     end
        
        --     local aTime = aData.Checkpoints[aCP] or 0
        --     local bTime = bData.Checkpoints[bCP] or 0
        --     return aTime < bTime
        -- end)
        table.sort(sorted_table, function(a, b)
            local aData, bData = a.array, b.array
            -- if aData.Finished and not bData.Finished then
            --     return true
            -- elseif not aData.Finished and bData.Finished then
            --     return false
            -- end
            local function getStatusPriority(data)
                if data.Disqualified or data.Busted then return 3 end
                if data.Finished then return 1 end
                return 2
            end
            
            local aPriority = getStatusPriority(aData)
            local bPriority = getStatusPriority(bData)
            
            if aPriority ~= bPriority then
                return aPriority < bPriority
            end
            
            if aData.Finished and bData.Finished then
                local aLTime = aData.LastLapTime or math.huge
                local bLTime = bData.LastLapTime or math.huge
                if aLTime ~= bLTime then
                    return aLTime < bLTime
                end
            end
            
            if aData.Lap ~= bData.Lap then
                return aData.Lap > bData.Lap
            end
            
            local aCP, bCP = #aData.Checkpoints, #bData.Checkpoints
            if aCP ~= bCP then
                return aCP > bCP
            end
            
            local aTime = aData.Checkpoints[aCP] or 0
            local bTime = bData.Checkpoints[bCP] or 0
            
            if aTime ~= bTime then
                return aTime < bTime
            end
            
            -- local aLTime = (aData.LastLapTime or math.huge) - UVHUDRaceInfo.Info.Time
            -- local bLTime = (bData.LastLapTime or math.huge) - UVHUDRaceInfo.Info.Time
            -- return aLTime < bLTime
        end)
        
        for i, v in ipairs(sorted_table) do
            local vehicle = v.vehicle
            local lang = language.GetPhrase
            
            if !IsValid(vehicle) then
                local line = string.format("%d. %s", i, v.array.Name)
                local str = ''
                
                if v.array.Finished then
                    str = lang("uv.race.suffix.finished")
                elseif v.array.Busted then
                    str = lang("uv.race.suffix.busted")
                elseif v.array.Disqualified then
                    str = lang("uv.race.suffix.dnf")
                end
                
                line = line .. str
                
                local selected_color = LBColors.Disqualified
                
                table.insert(leaderboardLines, {selected_color, line})
                continue
            end
            
            local array = v.array
            local driver = vehicle:GetDriver()
            local is_local_player = IsValid(driver) and driver == lPr
            local name = array.Name or "Racer"
            
            local line = string.format("%d. %s", i, name)
            
            if not is_local_player then
                local racerCPs = array.Checkpoints or {}
                local racerCount = #racerCPs
                local checkpointDiff = lCheckpointCount - racerCount
                local totalTimeDiff = 0
                
                if checkpointDiff ~= 0 then
                    local aheadCPs = (checkpointDiff > 0) and lArray.Checkpoints or racerCPs
                    local behindCPs = (aheadCPs == lArray.Checkpoints) and racerCPs or lArray.Checkpoints
                    local behindCount = #behindCPs
                    
                    for j = 1, math.abs(checkpointDiff) do
                        local idx = behindCount + j
                        local timeNow = aheadCPs[idx]
                        local timePrev = aheadCPs[idx - 1] or timeNow
                        if timeNow then
                            totalTimeDiff = totalTimeDiff + (timeNow - timePrev)
                        end
                    end
                    
                    if checkpointDiff > 0 then
                        totalTimeDiff = -totalTimeDiff
                    end
                else
                    local localTime = lArray.Checkpoints[lCheckpointCount] or 0
                    local otherTime = racerCPs[racerCount] or 0
                    totalTimeDiff = localTime - otherTime
                end
                
                local sign = (totalTimeDiff >= 0) and "+" or "-"
                
                local str = "???"
                
                if v.array.Finished then
                    str = lang("uv.race.suffix.finished")
                elseif v.array.Busted then
                    str = lang("uv.race.suffix.busted")
                elseif v.array.Disqualified then
                    str = lang("uv.race.suffix.dnf")
                elseif v.array.Lap ~= lArray.Lap then
                    local difference = v.array.Lap - lArray.Lap
                    str = string.format( lang("uv.race.suffix.lap"), ((difference > 0 and '+') or '-') ..math.abs( difference ) )
                else
                    str = string.format("  (%s%.3f)", sign, math.abs(totalTimeDiff))
                end
                
                line = line .. str
            end
            
            local selected_color = nil
            
            if is_local_player then
                selected_color = LBColors.LocalPlayer
            elseif array.Disqualified or array.Busted then
                selected_color = LBColors.Disqualified
            else
                selected_color = LBColors.Others
            end
            
            table.insert(leaderboardLines, {selected_color, line})
        end
        
        //UVSortedRacers = sorted_table
        
        return sorted_table, leaderboardLines
    end

    --
    
    if !UVHUDRaceInfo then
        UVHUDRaceInfo = {}
    end
    
    if !UVHUDRaceTime or !UVHUDRace then
        UVHUDRaceTime = UVDisplayTimeRace(0)
    end
    
    if !UVHUDRaceLaps then
        UVHUDRaceLaps = 1
    end
    
    if !UVHUDRaceCurrentLap then
        UVHUDRaceCurrentLap = 1
    end
    
    if !UVHUDRaceCurrentParticipants then
        UVHUDRaceCurrentParticipants = 1
    end
    
    function UVNotifyDriver( message, duration )
        duration = duration or 5
        UVHUDNotificationString = message
        UVHUDNotification = true 
        timer.Simple( duration, function()
            UVHUDNotification = false
        end)
    end
    
    net.Receive( "uvrace_notification", function()
        UVNotifyDriver( net.ReadString(), net.ReadFloat() )
    end)
    
    net.Receive( "uvrace_decline", function() 
        chat.AddText(Color(255, 126, 126), net.ReadString())
    end)
    
    net.Receive( "uvrace_announcebestlaptime", function()
        local time = net.ReadFloat()
        local driver = net.ReadString()
        local timedifference = net.ReadFloat()
        if timedifference != 0 then
            chat.AddText(Color(255, 255, 255), "New best lap by "..driver..": ", Color(0, 255, 255), UVDisplayTimeRace(time), Color(255, 255, 255), " (-"..math.Round(timedifference, 3)..")")
        else
            chat.AddText(Color(255, 255, 255), "Best lap by "..driver..": ", Color(0, 255, 255), UVDisplayTimeRace(time))
        end
    end)
    
    net.Receive( "uvrace_racerinvited", function() 
        local racers = net.ReadTable()
        
        for _, v in pairs(racers) do
            chat.AddText(Color(255, 255, 255), "Sent race invite to: ", Color(0,255,0), v)
        end
    end)
    
    -- Functions to edit racer attributes
    net.Receive( "uvrace_checkpointpassed", function() 
        local participant = net.ReadEntity()
        local checkpoint = net.ReadInt(11)
        local time = net.ReadInt(32)
        
        if UVRaceTable then
            if UVRaceTable['Participants'] and UVRaceTable['Participants'][participant] then
                UVRaceTable['Participants'][participant]['Checkpoints'][checkpoint] = time
            end
        end
    end)
    
    net.Receive( "uvrace_info", function()
        UVHUDRaceInfo = net.ReadTable()
        
        UVHUDRaceTime = UVDisplayTimeRace( UVHUDRaceInfo['Info']['Time'] )
        UVHUDRaceLaps = UVHUDRaceInfo['Info']['Laps']
        UVHUDRaceRacerCount = UVHUDRaceInfo['Info']['Racers']
        
        local my_vehicle, my_array
        
        for vehicle, array in pairs(UVHUDRaceInfo['Participants']) do
            if IsValid(vehicle) and vehicle:GetDriver() == LocalPlayer() then
                my_vehicle, my_array = vehicle, array
                break
            end
        end
        
        if my_array then
            UVHUDRaceCurrentCheckpoint = #my_array['Checkpoints']
            UVHUDRaceCurrentPos = my_array['Position']
        else
            UVHUDRaceCurrentCheckpoint = nil
        end
        
        if !UVHUDRace then
            UVHUDRace = true
            UVHUDRaceCheckpoints = GetGlobalInt( "uvrace_checkpoints" )
            
            local theme = GetConVar("unitvehicle_sfxtheme"):GetString()
            local soundfiles = file.Find( "sound/uvracesfx/".. theme .."/start/*", "GAME" )
            surface.PlaySound( "uvracesfx/".. theme .."/start/".. soundfiles[math.random(1, #soundfiles)] )
        end
    end)
    
    net.Receive( "uvrace_invite", function()
        local w = ScrW()
        local h = ScrH()
        
        local faded_black = Color(0, 0, 0, 225)
        
        local ResultPanel = vgui.Create("DFrame")
        local Yes = vgui.Create("DButton")
        local No = vgui.Create("DButton")
        
        ResultPanel:Add(Yes)
        ResultPanel:Add(No)
        ResultPanel:SetSize(math.Round(w*0.5208333333), math.Round(h*0.1777778))
        ResultPanel:SetBackgroundBlur(true)
        ResultPanel:ShowCloseButton(false)
        ResultPanel:Center()
        ResultPanel:SetTitle("")
        ResultPanel:SetDraggable(false)
        ResultPanel:MakePopup()
        
        Yes:SetText("Yes")
        Yes:SetSize(ResultPanel:GetWide() * 5 / 16, 22)
        Yes:SetPos(ResultPanel:GetWide() / 8, ResultPanel:GetTall() - 22 - Yes:GetTall())
        No:SetText("No")
        No:SetSize(ResultPanel:GetWide() * 5 / 16, 22)
        No:SetPos(ResultPanel:GetWide() * 7 / 8 - No:GetWide(), ResultPanel:GetTall() - 22 - No:GetTall())
        
        ResultPanel.Paint = function(self, w, h)
            draw.RoundedBox(2, 0, 0, w, h, faded_black)
            draw.SimpleText("RACE INVITE", "UVFont", 500, 5, Color(30, 255, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
            draw.SimpleText("You got invited to a race! Would you like to join?", "UVFont5", 500, 60, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        end
        
        function Yes:DoClick()
            ResultPanel:Close()
            timer.Remove("RaceInvite")
            
            net.Start("uvrace_invite")
            net.WriteBool(true)
            net.SendToServer()
        end
        
        function No:DoClick()
            ResultPanel:Close()
            timer.Remove("RaceInvite")
            
            net.Start("uvrace_invite")
            net.WriteBool(false)
            net.SendToServer()
        end
        
        timer.Create( "RaceInvite", 10, 1, function() ResultPanel:Close() end )
    end)
    
    net.Receive( "uvrace_end", function()
        if UVHUDRace and RacingMusic:GetBool() then 
            local theme = GetConVar("unitvehicle_sfxtheme"):GetString()
            local soundfiles = file.Find( "sound/uvracesfx/".. theme .."/end/*", "GAME" )
            surface.PlaySound( "uvracesfx/".. theme .."/end/".. soundfiles[math.random(1, #soundfiles)] ) 
        end
        
        UVHUDRace = false
        UVHUDRaceInfo = nil
        UVHUDRaceStart = nil
        
        if UVPlayingRace then
            UVPlayingRace = false
        end
    end)
    
    net.Receive( "uvrace_checkpointcomplete", function()
        local participant = net.ReadEntity()
        local checkpoint = net.ReadInt(11)
        local time = net.ReadFloat()
        
        if UVHUDRaceInfo then
            if UVHUDRaceInfo['Participants'] and UVHUDRaceInfo['Participants'][participant] then
                UVHUDRaceInfo['Participants'][participant]['Checkpoints'][checkpoint] = time
            end
        end
        
        if IsValid(participant) then
            local driver = participant:GetDriver()
            
            if driver == LocalPlayer() then
                local theme = GetConVar("unitvehicle_sfxtheme"):GetString()
                local soundfiles = file.Find( "sound/uvracesfx/".. theme .."/checkpointpass/*", "GAME" )
                surface.PlaySound( "uvracesfx/".. theme .."/checkpointpass/".. soundfiles[math.random(1, #soundfiles)] )
            end
        end
    end)
    
    net.Receive( "uvrace_racecomplete", function()
        local participant = net.ReadEntity()
        local place = net.ReadInt(32)
        local time = net.ReadFloat()
        
        if UVHUDRaceInfo then
            if UVHUDRaceInfo['Participants'] and UVHUDRaceInfo['Participants'][participant] then
                UVHUDRaceInfo['Participants'][participant].Finished = true 
                
                if IsValid(participant) and participant:GetDriver() == LocalPlayer() and RacingMusic:GetBool() then
                    local theme = GetConVar("unitvehicle_sfxtheme"):GetString()
                    local soundfiles = file.Find( "sound/uvracesfx/".. theme .."/"..((place <= 3 and "win") or "loss").."/*", "GAME" )
                    if soundfiles and #soundfiles > 0 then
                        local audio_path = "uvracesfx/".. theme .."/"..((place <= 3 and "win") or "loss").."/".. soundfiles[math.random(1, #soundfiles)]
                        surface.PlaySound(audio_path)
                    end
                end
                
                local lang = language.GetPhrase
                local PlaceStrings = {
                    [1] = {Color(240,203,122), lang("uv.race.place.1")},
                    [2] = {Color(183,201,210), lang("uv.race.place.2")},
                    [3] = {Color(179,128,41), lang("uv.race.place.3")},
                    [4] = {Color(27,147,0), lang("uv.race.place")},
                }
                
                local place_array = PlaceStrings[place] or PlaceStrings[4]
                chat.AddText(Color(255,255,255), UVHUDRaceInfo['Participants'][participant].Name, lang("uv.race.finishtext.1"), place_array[1], string.format(place_array[2], place), Color(255,255,255), lang("uv.race.finishtext.2"), Color(0,255,0), UVDisplayTimeRace(time))        
            end
        end        
    end)
    
    net.Receive( "uvrace_disqualify", function()
        local participant = net.ReadEntity()
        local reason = net.ReadString()
        
        if UVHUDRaceInfo then
            if UVHUDRaceInfo['Participants'] and UVHUDRaceInfo['Participants'][participant] then
                if reason == 'Busted' or reason == 'Disqualified' then
                    
                    if IsValid(participant) and participant:GetDriver() == LocalPlayer() and RacingMusic:GetBool() then
                        local theme = GetConVar("unitvehicle_sfxtheme"):GetString()
                        local soundfiles = file.Find( "sound/uvracesfx/".. theme .."/loss/*", "GAME" )
                        if soundfiles and #soundfiles > 0 then
                            local audio_path = "uvracesfx/".. theme .."/loss/".. soundfiles[math.random(1, #soundfiles)]
                            surface.PlaySound(audio_path)
                        end
                    end
                    
                    UVHUDRaceInfo['Participants'][participant][reason] = true
                end
            end
        end
    end)
    
    net.Receive( "uvrace_begin", function()
        local time = net.ReadFloat()
        
        UVRacePlayIntro = true
        UVRacePlayMusic = true 
        UVRacePlayTransition = false
        
        UVPlayingRace = false
        
        if UVHUDRaceInfo and UVHUDRaceInfo['Info'] then
            UVHUDRaceInfo['Info'].Started = true
            UVHUDRaceInfo['Info'].Time = time
        end
    end)
    
    net.Receive( "uvrace_lapcomplete", function()
        local participant = net.ReadEntity()
        local time = net.ReadFloat()
        local lang = language.GetPhrase
        
        if UVHUDRaceInfo then
            if UVHUDRaceInfo['Participants'] and UVHUDRaceInfo['Participants'][participant] then
                UVHUDRaceInfo['Participants'][participant].Lap = UVHUDRaceInfo['Participants'][participant].Lap +1
                UVHUDRaceInfo['Participants'][participant].LastLapTime = time
                table.Empty(UVHUDRaceInfo['Participants'][participant]['Checkpoints'])
            end
        end
        
        local address = ((IsValid(participant) and participant:GetDriver() == LocalPlayer() and lang("uv.race.you")) or (UVHUDRaceInfo['Participants'] and UVHUDRaceInfo['Participants'][participant] and UVHUDRaceInfo['Participants'][participant].Name))
        
        if UVHUDLastLapTime == nil then
            chat.AddText(Color(255, 255, 255), string.format(lang("uv.race.laptime"), address), Color(0, 255, 0), UVDisplayTimeRace(time))
            UVHUDLastLapTime = time
            UVHUDBestLapTime = time
        else
            if time < UVHUDBestLapTime then
                local timedifference = UVHUDBestLapTime - time
                chat.AddText(Color(255, 255, 255), string.format(lang("uv.race.bestlap"), address), Color(0, 255, 0), UVDisplayTimeRace(time), Color(255, 255, 255), " (-"..math.Round(timedifference, 3)..")")
                UVHUDLastLapTime = time
                UVHUDBestLapTime = time
            else
                local timedifference = time - UVHUDBestLapTime
                chat.AddText(Color(255, 255, 255), string.format(lang("uv.race.laptime"), address), Color(255, 255, 0), UVDisplayTimeRace(time), Color(255, 255, 255), " (+"..math.Round(timedifference, 3)..")")
                UVHUDLastLapTime = time
            end
        end
    end)
    
    net.Receive( "uvrace_start", function()
        local time = net.ReadInt( 11 )
        local theme = GetConVar("unitvehicle_sfxtheme"):GetString()
        local starttable = {
            "#uv.race.go",
            "1",
            "2",
            "3",
            "#uv.race.getready",
            "#uv.race.getready",
            "#uv.race.getready",
        }
        
        local soundfilescount3 = file.Find( "sound/uvracesfx/".. theme .."/count3/*", "GAME" )
        local soundfilecount3 = "uvracesfx/".. theme .."/count3/".. soundfilescount3[math.random(1, #soundfilescount3)]
        local soundfilescount2 = file.Find( "sound/uvracesfx/".. theme .."/count2/*", "GAME" )
        local soundfilecount2 = "uvracesfx/".. theme .."/count2/".. soundfilescount2[math.random(1, #soundfilescount2)]
        local soundfilescount1 = file.Find( "sound/uvracesfx/".. theme .."/count1/*", "GAME" )
        local soundfilecount1 = "uvracesfx/".. theme .."/count1/".. soundfilescount1[math.random(1, #soundfilescount1)]
        local soundfilescountgo = file.Find( "sound/uvracesfx/".. theme .."/countgo/*", "GAME" )
        local soundfilecountgo = "uvracesfx/".. theme .."/countgo/".. soundfilescountgo[math.random(1, #soundfilescountgo)]
        local startsound = {
            [1] = soundfilecountgo,
            [2] = soundfilecount1,
            [3] = soundfilecount2,
            [4] = soundfilecount3,
        }   
        
        UVHUDRaceStart = starttable[time]
        if startsound[time] then
            surface.PlaySound( startsound[time] )
        end
    end)
    
    hook.Add( "HUDPaint", "UVHUDRace", function() --HUD
        
        local w = ScrW()
        local h = ScrH()
        
        if UVHUDNotification then
            draw.DrawText( UVHUDNotificationString, "UVFont5", ScrW()/2, ScrH()/4, Color( 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        end
        
        if UVHUDRaceStart then
            draw.DrawText( UVHUDRaceStart, "UVFont5", ScrW()/2, ScrH()/3, Color( 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        end
        
        if !UVHUDRace then return end
        if !UVHUDRaceInfo then return end
        if !(UVHUDRaceInfo.Info and UVHUDRaceInfo.Info.Started) then return end
        
        local my_vehicle, my_array = nil, nil
        
        for vehicle, array in pairs(UVHUDRaceInfo['Participants']) do
            if IsValid(vehicle) and vehicle:GetDriver() == LocalPlayer() then
                my_vehicle, my_array = vehicle, array
                break
            end
        end
        
        if !my_vehicle then UVSoundRacingStop(); UVHUDRaceCurrentCheckpoint = nil; return end
        if my_array.Finished or (my_array.Disqualified or my_array.Busted) then
            -- clean up
            UVSoundRacingStop()
            UVHUDRaceCurrentCheckpoint = nil;
            UVHUDRace = false;
            return
        end
        
        if !UVHUDDisplayBusting then
            UVSoundRacing( my_vehicle )
        end
        
        UVHUDRace = true;
        
        local element1 = {}
        
        if UVHUDRaceInfo.Info.Laps > 1 then
            element1 = {
                { x = 0, y = h/7 },
                { x = w*0.35, y = h/7 },
                { x = w*0.25, y = h/3 },
                { x = 0, y = h/3 },
            }
        else
            element1 = {
                { x = 0, y = h/7 },
                { x = w*0.35, y = h/7 },
                { x = w*0.25, y = h/3.5 },
                { x = 0, y = h/3.5 },
            }
        end
        surface.SetDrawColor( 0, 0, 0, 200)
        draw.NoTexture()
        surface.DrawPoly( element1 )
        
        local sorted_table, string_array = UVFormLeaderboard(UVHUDRaceInfo['Participants'])
        
        UVHUDRaceCurrentParticipants = 0
        
        for i, v in ipairs(sorted_table) do
            UVHUDRaceCurrentParticipants = UVHUDRaceCurrentParticipants +1
            if v.vehicle == my_vehicle then
                UVHUDRaceCurrentPos = i
            end
        end
        
        local checkpoint_count = #my_array['Checkpoints']
        
        -- used by checkpoint entities
        UVHUDRaceCurrentCheckpoint = checkpoint_count
        
        -- check for wrong way
        if _UVCurrentCheckpoint and IsValid(_UVCurrentCheckpoint) then
            local vehicle_center = my_vehicle:WorldSpaceCenter()
            local vehicle_velocity = my_vehicle:GetVelocity() -- :Dot((_UVCurrentCheckpoint:GetPos() + _UVCurrentCheckpoint:GetMaxPos()) / 2)
            local check_center_pos = (_UVCurrentCheckpoint:GetPos() + _UVCurrentCheckpoint:GetMaxPos()) / 2
            
            local unit = ((check_center_pos - vehicle_center)):GetNormalized()
            local normalized_velo = vehicle_velocity:GetNormalized()
            
            local dot_product = normalized_velo:Dot(unit)
            
            if dot_product > - .8 then
                LastWrongWayCheckTime = CurTime()
            end
            
            if CurTime() - LastWrongWayCheckTime > 1 then
                if !UVHUDNotification then
                    local theme = GetConVar("unitvehicle_sfxtheme"):GetString()
                    local soundfiles = file.Find( "sound/uvracesfx/".. theme .."/wrongway/*", "GAME" )
                    if soundfiles and #soundfiles > 0 then
                        local audio_path = "uvracesfx/".. theme .."/wrongway/".. soundfiles[math.random(1, #soundfiles)]
                        surface.PlaySound(audio_path)
                    end
                    UVNotifyDriver("#uv.race.wrongway", 3)
                end
            end
        end
        
        local lang = language.GetPhrase
        draw.DrawText( 
            lang("uv.race.time") .. UVDisplayTimeRace( (UVHUDRaceInfo.Info.Started and (CurTime() - UVHUDRaceInfo.Info.Time)) or 0 ) .. "\n" ..
            lang("uv.race.check") .. checkpoint_count .. "/" .. GetGlobalInt( "uvrace_checkpoints" )  .. "\n" ..
            (UVHUDRaceInfo.Info.Laps > 1 and lang("uv.race.lap") .. my_array.Lap .. "/" .. UVHUDRaceInfo.Info.Laps .. "\n" or "") ..
            lang("uv.race.pos") .. UVHUDRaceCurrentPos .. "/" .. UVHUDRaceCurrentParticipants,
            "UVFont", 10, h/7, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT 
        )
    
        local racer_count = #string_array
    
        for i=1, racer_count, 1 do
            local entry = string_array[i]
            local racerpos = 3.75
        
            if UVHUDRaceInfo.Info.Laps > 1 then
                racerpos = 3.25
            end
        
            draw.DrawText( 
                entry[2], "UVFont4", 
                10, 
                (h/racerpos) + i * ((racer_count > 5 and 20) or 28), 
                entry[1], TEXT_ALIGN_LEFT 
            )
        end
    end)
end