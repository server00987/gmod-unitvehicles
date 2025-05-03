AddCSLuaFile()

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

if SERVER then
    UVRaceLaps = CreateConVar( "unitvehicle_racelaps", 1, FCVAR_ARCHIVE, "Number of laps to complete. Set to 1 to have sprint races." )

    UVRaceCurrentParticipants = {}
    UVRaceStartTime = CurTime()

    util.AddNetworkString( "uvrace_start" )
    util.AddNetworkString( "uvrace_end" )
    util.AddNetworkString( "uvrace_participants" )
    util.AddNetworkString( "uvrace_checkpointcomplete" )
    util.AddNetworkString( "uvrace_lapcomplete" )
    util.AddNetworkString( "uvrace_info" )
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
			check:SetFinishLine(ent:GetFinishLine())
			check:Spawn()
		end

        timer.Simple(1, function()
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

        vehicle.uvraceparticipant = true
        vehicle.racedriver = driver

        if sendmsg then
            PrintMessage( HUD_PRINTTALK, ((IsValid(driver) and driver:GetName()) or "Racer "..vehicle:EntIndex()).. " has joined the race!" )
        end
        
        vehicle:CallOnRemove( "uvrace_participantremoved", function( ent )
            local driver = UVGetDriver( vehicle )
            UVRaceRemoveParticipant( ent, driver )
        end )
    end

    function UVRaceRemoveParticipant( vehicle, ply )
        if table.HasValue( UVRaceCurrentParticipants, vehicle ) then
            table.RemoveByValue( UVRaceCurrentParticipants, vehicle )
            local driver = UVGetDriver( vehicle ) or ply
            if driver:IsPlayer() then
                net.Start( "uvrace_end" )             
                net.Send( driver )
            end
        end

        vehicle.uvraceparticipant = false
        vehicle.racedriver = nil
        vehicle.currentcheckpoint = nil
        vehicle.currentlap = nil
        vehicle.lastlaptime = nil
        vehicle.bestlaptime = nil
    end

    function UVRaceStart() --Start procedure
        if #UVRaceCurrentParticipants == 0 then
            PrintMessage( HUD_PRINTTALK, "No participants found!" )
            return 
        end

        local checkpoints = ents.FindByClass( "uvrace_brushpoint" )
        if #checkpoints == 0 then
            PrintMessage( HUD_PRINTTALK, "No checkpoints found!" )
            return 
        end

        local spawns = ents.FindByClass( "uvrace_spawn" )
        if #spawns == 0 then
            PrintMessage( HUD_PRINTTALK, "No spawns found!" )
            return 
        end

        local time = 7
        for _, vehicle in pairs( UVRaceCurrentParticipants ) do
            local driver = UVGetDriver( vehicle )
            net.Start( "uvrace_start" )
                net.WriteInt( time, 11 )
            net.Send( driver )
        end

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
            vehicle.lastlaptime = CurTime()
        end

        --unclaim all spawns
        for _, spawn in pairs( ents.FindByClass( "uvrace_spawn" ) ) do
            spawn.claimed = nil
        end

        UVRaceStartTime = CurTime()
        UVRaceInProgress = true

    end
    
    function UVRaceEnd()
        uvbestlaptime = nil
        UVRaceInEffect = nil
        UVRaceInProgress = nil
        UVRaceCurrentParticipants = {}
        for _, ent in ipairs(ents.FindByClass("uvrace_brush*")) do
			ent:Remove()
		end
    end

    function UVCheckLapTime( vehicle, time )
        if !uvbestlaptime then
            uvbestlaptime = time
            local timedifference = 0

            local driver = UVGetDriver(vehicle)
            local name = (IsValid(driver) and driver:GetName())

            -- if driver:IsPlayer() then
            --     net.Start( "uvrace_announcebestlaptime" )
            --         net.WriteFloat( time )
            --         net.WriteString( driver:Nick() )
            --         net.WriteFloat( timedifference )
            --     net.Broadcast()
            -- elseif driver:IsNPC() then
            --     net.Start( "uvrace_announcebestlaptime" )
            --         net.WriteFloat( time )
            --         net.WriteString( "Racer ".. driver:EntIndex() )
            --         net.WriteFloat( timedifference )
            --     net.Broadcast()
            -- end

            net.Start("uvrace_announcebestlaptime")
            net.WriteFloat( time )
            net.WriteString( ((IsValid(driver) and driver:GetName()) or "Racer " .. vehicle:EntIndex()) )
            net.WriteFloat( timedifference )
            net.Broadcast()

        else
            if time < uvbestlaptime then
                local timedifference = uvbestlaptime - time
                uvbestlaptime = time
                -- if driver:IsPlayer() then
                --     net.Start( "uvrace_announcebestlaptime" )
                --         net.WriteFloat( time )
                --         net.WriteString( driver:Nick() )
                --         net.WriteFloat( timedifference )
                --     net.Broadcast()
                -- elseif driver:IsNPC() then
                --     net.Start( "uvrace_announcebestlaptime" )
                --         net.WriteFloat( time )
                --         net.WriteString( "Racer ".. driver:EntIndex() )
                --         net.WriteFloat( timedifference )
                --     net.Broadcast()
                -- end

                net.Start("uvrace_announcebestlaptime")
                net.WriteFloat( time )
                net.WriteString( ((IsValid(driver) and driver:GetName()) or "Racer " .. vehicle:EntIndex()) )
                net.WriteFloat( timedifference )
                net.Broadcast()
            end
        end
    end

    hook.Add("PostCleanupMap", "UVRaceCleanup", function()
        UVRaceEnd()
        net.Start( "uvrace_end" )
        net.Broadcast()
    end)

    hook.Add( "Think", "UVRacing", function( ply )

        if !UVRaceInProgress then 
            UVRaceTime = 0
        else 
            UVRaceTime = CurTime() - UVRaceStartTime
        end

        if UVRacePrep then return end

        if next( UVRaceCurrentParticipants ) != nil then
            local pos = 0
            for _, vehicle in pairs( UVRaceCurrentParticipants ) do
                pos = pos + 1
                if IsValid( vehicle ) then
                    if !vehicle.currentcheckpoint then
                        vehicle.currentcheckpoint = 1
                    end
                    if !vehicle.currentlap then
                        vehicle.currentlap = 1
                    end
                    if !vehicle.lastlaptime then
                        vehicle.lastlaptime = CurTime()
                    end
                    if !vehicle.bestlaptime then
                        vehicle.bestlaptime = CurTime()
                    end

                    local driver = UVGetDriver( vehicle )
                    if IsValid( driver ) then
                        net.Start( "uvrace_info" )
                            net.WriteInt( vehicle.currentcheckpoint, 11 )
                            net.WriteInt( vehicle.currentlap, 11 )
                            net.WriteInt( pos, 11 )
                            net.WriteInt( UVRaceLaps:GetInt(), 11 )
                            net.WriteFloat( UVRaceTime )
                            net.WriteInt( #UVRaceCurrentParticipants, 11 )
                        net.Send( driver )
                    end

                    if vehicle.wrecked or vehicle.uvbusted then
                        UVRaceRemoveParticipant( vehicle )
                    end

                end
            end
        elseif !UVRacePrep then
            UVRaceEnd()
            net.Start( "uvrace_end" )
            net.Broadcast()
        end

    end)

else

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
        timer.Simple( 3, function()
            UVHUDNotification = false
        end)
    end

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

    net.Receive( "uvrace_info", function()
        UVHUDRaceCurrentCheckpoint = net.ReadInt( 11 )
        UVHUDRaceCurrentLap = net.ReadInt( 11 )
        UVHUDRaceCurrentPos = net.ReadInt( 11 )
        UVHUDRaceLaps = net.ReadInt( 11 )
        UVHUDRaceTime = UVDisplayTimeRace( net.ReadFloat() )
        UVHUDRaceCurrentParticipants = net.ReadInt( 11 )
        if !UVHUDRace then
            UVHUDRace = true
            UVHUDRaceCheckpoints = GetGlobalInt( "uvrace_checkpoints" )

            local theme = GetConVar("unitvehicle_racetheme"):GetString()
            local soundfiles = file.Find( "sound/uvracemusic/".. theme .."/racestart/*", "GAME" )
            surface.PlaySound( "uvracemusic/".. theme .."/racestart/".. soundfiles[math.random(1, #soundfiles)] )
        end
    end)

    net.Receive( "uvrace_end", function()
        if UVHUDRace then 
            local theme = GetConVar("unitvehicle_racetheme"):GetString()
            local soundfiles = file.Find( "sound/uvracemusic/".. theme .."/raceend/*", "GAME" )
            surface.PlaySound( "uvracemusic/".. theme .."/raceend/".. soundfiles[math.random(1, #soundfiles)] ) 
        end

        UVHUDRace = false
        UVHUDRaceCurrentCheckpoint = 1
        UVHUDRaceCurrentLap = 1
        UVHUDRaceCurrentPos = 1
        UVHUDRaceLaps = 1
        UVHUDLastLapTime = nil
        UVHUDBestLapTime = nil
        UVHUDRaceTime = UVDisplayTimeRace(0)
    end)

    net.Receive( "uvrace_checkpointcomplete", function()
        local theme = GetConVar("unitvehicle_racetheme"):GetString()
        local soundfiles = file.Find( "sound/uvracemusic/".. theme .."/checkpointpass/*", "GAME" )
        surface.PlaySound( "uvracemusic/".. theme .."/checkpointpass/".. soundfiles[math.random(1, #soundfiles)] )
    end)

    net.Receive( "uvrace_lapcomplete", function()
        local time = net.ReadFloat()
        local driver = LocalPlayer()
        if UVHUDLastLapTime == nil then
            chat.AddText(Color(255, 255, 255), "Your first lap: ", Color(0, 255, 0), UVDisplayTimeRace(time))
            UVHUDLastLapTime = time
            UVHUDBestLapTime = time
        else
            if time < UVHUDBestLapTime then
                local timedifference = UVHUDBestLapTime - time
                chat.AddText(Color(255, 255, 255), "Your best lap: ", Color(0, 255, 0), UVDisplayTimeRace(time), Color(255, 255, 255), " (-"..math.Round(timedifference, 3)..")")
                UVHUDLastLapTime = time
                UVHUDBestLapTime = time
            else
                local timedifference = time - UVHUDBestLapTime
                chat.AddText(Color(255, 255, 255), "Your last lap: ", Color(255, 255, 0), UVDisplayTimeRace(time), Color(255, 255, 255), " (+"..math.Round(timedifference, 3)..")")
                UVHUDLastLapTime = time
            end
        end
    end)

    net.Receive( "uvrace_start", function()
        local time = net.ReadInt( 11 )
        local theme = GetConVar("unitvehicle_racetheme"):GetString()
        local starttable = {
            "GO!",
            "1",
            "2",
            "3",
            "GET READY",
            "GET READY",
            "GET READY",
        }

        local soundfilescount3 = file.Find( "sound/uvracemusic/".. theme .."/count3/*", "GAME" )
        local soundfilecount3 = "uvracemusic/".. theme .."/count3/".. soundfilescount3[math.random(1, #soundfilescount3)]
        local soundfilescount2 = file.Find( "sound/uvracemusic/".. theme .."/count2/*", "GAME" )
        local soundfilecount2 = "uvracemusic/".. theme .."/count2/".. soundfilescount2[math.random(1, #soundfilescount2)]
        local soundfilescount1 = file.Find( "sound/uvracemusic/".. theme .."/count1/*", "GAME" )
        local soundfilecount1 = "uvracemusic/".. theme .."/count1/".. soundfilescount1[math.random(1, #soundfilescount1)]
        local soundfilescountgo = file.Find( "sound/uvracemusic/".. theme .."/countgo/*", "GAME" )
        local soundfilecountgo = "uvracemusic/".. theme .."/countgo/".. soundfilescountgo[math.random(1, #soundfilescountgo)]
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
            draw.DrawText( UVHUDNotificationString, "UVFont7", ScrW()/2, ScrH()/4, Color( 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        end

        if !UVHUDRace then return end

        if UVHUDRaceStart then
            draw.DrawText( UVHUDRaceStart, "UVFont7", ScrW()/2, ScrH()/3, Color( 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        end

        local element1 = {
            { x = 0, y = h/7 },
            { x = w*0.2, y = h/7 },
            { x = w*0.125, y = h/3 },
            { x = 0, y = h/3 },
        }
        surface.SetDrawColor( 0, 0, 0, 200)
        draw.NoTexture()
        surface.DrawPoly( element1 )

        draw.DrawText( 
            "Time: " .. UVHUDRaceTime .. "\nCheck: " .. UVHUDRaceCurrentCheckpoint .. "/" .. UVHUDRaceCheckpoints .. (UVHUDRaceLaps > 1 and "\nLap: ".. UVHUDRaceCurrentLap .. "/" .. UVHUDRaceLaps or "") .. "\nPos: " .. UVHUDRaceCurrentPos .. "/" .. UVHUDRaceCurrentParticipants, 
            "UVFont", 
            0, 
            h/7, 
            Color( 255, 255, 255), 
            TEXT_ALIGN_LEFT 
        )

    end)

end