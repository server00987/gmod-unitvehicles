AddCSLuaFile()

local UVRacePlayIntro = true
local UVRacePlayMusic = false 
local UVRacePlayTransition = false

local showhud = GetConVar("cl_drawhud")

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
    util.AddNetworkString( "uvrace_sendmessage" )

    util.AddNetworkString( "uvrace_resetcountdown" )
    util.AddNetworkString( "uvrace_resetfailed" )
    
    util.AddNetworkString( "uvrace_replace" )
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
        vehicle.isresetting = false
        
        if sendmsg then
            PrintMessage( HUD_PRINTTALK, ((IsValid(driver) and driver:GetName()) or (vehicle.racer or "Racer "..vehicle:EntIndex())).. " has joined the race!" )
        end
        
        vehicle:CallOnRemove( "uvrace_participantremoved", function( ent )
            local driver = UVGetDriver( vehicle )

            if vehicle.isresetting then return end
            UVRaceRemoveParticipant( ent, 'Disqualified' )
        end )
    end

    function UVRaceReplaceParticipant( old_vehicle, new_vehicle )
        if UVRaceTable.Participants then
            if UVRaceTable.Participants and UVRaceTable.Participants[ old_vehicle ] then
               UVRaceTable.Participants[ new_vehicle ] = UVRaceTable.Participants[ old_vehicle ]
               UVRaceTable.Participants[ old_vehicle ] = nil
                -- if reason then
                --     net.Start( "uvrace_disqualify" )
                --     net.WriteEntity(vehicle)
                --     net.WriteString(reason)
                --     net.Broadcast()
                    
                --     UVRaceTable.Participants [vehicle][reason] = true
                -- end
            end
        end

        old_vehicle.isresetting = true
        new_vehicle.hasreset = CurTime()

        UVRaceAddParticipant(new_vehicle)
        UVRaceRemoveParticipant(old_vehicle)

        timer.Simple(10, function()
            new_vehicle.hasreset = false
        end)

        net.Start( "uvrace_replace" )
        net.WriteEntity(old_vehicle)
        net.WriteEntity(new_vehicle)
        net.Broadcast()
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
                --['LastLapTime'] = CurTime(),
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
            if vehicle.PursuitTech then
                for i, v in pairs(vehicle.PursuitTech) do
                    v.LastUsed = CurTime()
                    UVReplicatePT( vehicle, i )
                end
            end
            
            -- if UVRaceTable['Participants'] and UVRaceTable['Participants'][vehicle] then
            --     UVRaceTable['Participants'][vehicle]['LastLapTime'] = CurTime()
            -- end
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

        -- timer.Simple(3, function()
        --     UVNotifyCenter( {ply}, "uv.test" , 'Hi', 'uv.unit.racer')
        -- end)
        
        if UVRaceInProgress then
            net.Start( "uvrace_info" )
            net.WriteTable( UVRaceTable )
            net.Send( ply )
        end
    end)
    
    hook.Add("PostCleanupMap", "UVRaceCleanup", function()
        if not UVRaceInEffect then return end
        
        UVRaceEnd()
        
        net.Start( "uvrace_end" )
        net.Broadcast()
    end)
    
    hook.Add( "Think", "UVRacing", function( ply )
        
        if !UVRaceInEffect then return end
        if UVRacePrep then return end
        
        if next( UVRaceCurrentParticipants ) != nil then
            local pos = 0
            --local player_table = {}
            
            for _, vehicle in pairs( UVRaceCurrentParticipants ) do
                if IsValid( vehicle ) then
                    -- local driver = UVGetDriver( vehicle )
                    -- if IsValid( driver ) then
                    --     table.insert(player_table, driver)
                    -- end
                    
                    if vehicle.uvbusted then
                        UVRaceRemoveParticipant( vehicle, 'Busted' )
                        continue
                    end
                    
                    -- Damage check
                    if UVCheckIfWrecked(vehicle) and !vehicle.hasreset then
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
        UVPlayingRace = false
        -- if UVPlayingRace then
        --     if timer.Exists("UVRaceMusicTransition") then
        --         timer.Remove("UVRaceMusicTransition")
        --     end
            
        --     UVPlayingRace = false
        -- end
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

	local musicMetadata = {}

	local function loadMusicMetadata()
		local files = file.Find("data_static/music_*.json", "GAME")
		for _, filename in ipairs(files) do
			local path = "data_static/" .. filename
			local data = file.Read(path, "GAME")

			if data then
				local ok, tbl = pcall(util.JSONToTable, data)
				if ok and tbl then
					musicMetadata[filename] = tbl
				end
			end
		end
	end

	-- Call once at script load or addon init:
	loadMusicMetadata()

	local function escape_pattern(text)
		return text:gsub("([^%w])", "%%%1")
	end

	local function normalizePath(path)
		return string.lower(path):gsub("\\", "/")
	end

	local function caseInsensitiveLookup(metaTable, path)
		for key, value in pairs(metaTable) do
		  if key:lower() == path:lower() then
			return value
		  end
		end
		return nil
	end

	local function lookupTrackInMetadata(norm_path)
		for _, metaTable in pairs(musicMetadata) do
			local entry = caseInsensitiveLookup(metaTable, norm_path)
			if entry then
				return entry.artist, entry.title, entry.folder
			end
		end
		return nil
	end

    local function PlayRaceMusic(theme, my_vehicle)
        local track = UVGetRaceMusicPath(theme, my_vehicle)
		local jsonFiles = file.Find("data_static/music_*.json", "GAME")

        if track then
            UVPlaySound(track, true)
        end

		local placeholder_map = { -- Used for Official UV Trax Packs
			[",,"] = ".",
			[";;"] = "?",
			["-;-"] = "/",
			["=="] = ":",
			["-!-"] = "\"",
		}

		if not string.find(track, "/race/") then return end
		track = track:gsub("uvracemusic/" .. theme .. "/race/", ""):gsub("%.mp3", ""):gsub("%.wav", ""):gsub("%.ogg", "")

		-- Rebuild the full normalized path for lookup (lowercase, forward slash)
		local full_path = normalizePath("sound/uvracemusic/" .. theme .. "/race/" .. track .. ".mp3")

		-- Lookup metadata in JSON tables

		local artist, title, folder = lookupTrackInMetadata(full_path)
		local notificationText

		if artist and title and folder then -- Use metadata from JSON (original casing)
			 notificationText = "<color=255,126,126>" .. language.GetPhrase("uv.race.radio") .. "</color>\n" .. title .. "\n" .. "<color=200,200,200>" .. artist .. "\n" .. folder .. "</color>"
		else
			for placeholder, char in pairs(placeholder_map) do
				track = string.gsub(track, escape_pattern(placeholder), char)
			end
			if string.find(track, " - ", 1, true) then -- Fallback to parsing track name or showing raw track/folder
				local parts = string.Explode(" - ", track)
				notificationText = "<color=255,126,126>*" .. language.GetPhrase("uv.race.radio") .. "</color>\n"  .. parts[2] .. "\n" .. "<color=200,200,200>" .. parts[1] .. "\n" .. theme .. "</color>"
			else
				notificationText = "<color=255,126,126>*" .. language.GetPhrase("uv.race.radio") .. "</color>\n"  .. track .. "\n" .. "<color=200,200,200>" .. theme .. "</color>"
			end
		end

		if Glide then
			Glide.Notify({
				text = notificationText,
				icon = "unitvehicles/icons/ICON_EA_TRAX.png",
				lifetime = 3,
				immediate = true,
			})
		else
			chat.AddText( Color(255, 255, 255), "[", Color(255, 126, 126), language.GetPhrase("uv.race.radio"), Color(255, 255, 255), "] ", Color(255, 255, 0), (artist and title) and (title .. " - " .. artist) or track, Color(255, 255, 255), " (", Color(200, 200, 200), theme, Color(255, 255, 255), ")")
		end
	end

    function UVSoundRacing(my_vehicle)
        if !RacingThemeOutsideRace:GetBool() then
            if !RacingMusic:GetBool() or (!RacingMusicPriority:GetBool() and UVHUDDisplayPursuit) then return end
            if (not UVHUDRace) then return end 
        end

        if UVPlayingRace or UVSoundDelayed then return end
        
        if timer.Exists("UVRaceMusicTransition") then
            timer.Remove("UVRaceMusicTransition")
        end

        if timer.Exists("UVPursuitThemeReplay") then
		    timer.Remove("UVPursuitThemeReplay")
	    end
        
        local theme = GetConVar("unitvehicle_racetheme"):GetString()
        
        if UVRacePlayIntro then
            UVRacePlayIntro = false
            UVPlayingRace = true
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
            UVPlayingRace = true
            
            local transitionTrack = UVGetRandomSound("uvracemusic/" .. theme .. "/transition")
            
            if transitionTrack then
                UVPlaySound(transitionTrack, true)
            else
                PlayRaceMusic(theme, my_vehicle)
                UVRacePlayTransition = true
            end
        elseif UVRacePlayMusic then
            UVPlayingRace = true
            UVRacePlayTransition = true
            //UVRacePlayMusic = false 
            
            PlayRaceMusic(theme, my_vehicle)
        end
        
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
                --local line = string.format("%d. %s", i, v.array.Name)
                --local str = ''
                local mode = nil
                
                if v.array.Finished then
                    --str = lang("uv.race.suffix.finished")
                    mode = 'Finished'
                elseif v.array.Busted then
                    --str = lang("uv.race.suffix.busted")
                    mode = 'Busted'
                else
                    --str = lang("uv.race.suffix.dnf")
                    mode = 'Disqualified'
                end
                
                --line = line .. str
                
                --local selected_color = LBColors.Disqualified
                
                table.insert(leaderboardLines, {v.array.Name or "Racer", nil, mode})
                continue
            end
            
            local array = v.array
            local driver = vehicle:GetDriver()
            local is_local_player = IsValid(driver) and driver == lPr
            local name = array.Name or "Racer"

            local diff = nil -- Display mode (Lap, Time, Finished, DNF/Busted)
            local mode = nil
            
            -- local line = string.format("%d. %s", i, name)
            -- local line = name
            
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
                    mode = 'Finished'
                    --str = lang("uv.race.suffix.finished")
                elseif v.array.Busted then
                    mode = 'Busted'
                    --str = lang("uv.race.suffix.busted")
                elseif v.array.Disqualified then
                    mode = 'Disqualified'
                    --str = lang("uv.race.suffix.dnf")
                elseif v.array.Lap ~= lArray.Lap then
                    mode = 'Lap'
                    local difference = v.array.Lap - lArray.Lap
					local ltext = "uv.race.suffix.lap"
					if math.abs( difference ) != 1 then ltext = "uv.race.suffix.laps" end
                    --diff = ((difference > 0 and '+') or '-') ..math.abs( difference )
                    diff = difference
                    --str = string.format( lang(ltext), ((difference > 0 and '+') or '-') ..math.abs( difference ) )
                else
                    mode = 'Time'
                    --str = string.format("  (%s%.3f)", sign, math.abs(totalTimeDiff))
                    diff = totalTimeDiff
                end
                
                --line = line .. str
            end
            
            local selected_color = nil
            
            -- if is_local_player then
            --     selected_color = LBColors.LocalPlayer
            -- elseif array.Disqualified or array.Busted then
            --     selected_color = LBColors.Disqualified
            -- else
            --     selected_color = LBColors.Others
            -- end
            
            table.insert(leaderboardLines, {name, is_local_player, mode, diff})
        end
        
        //UVSortedRacers = sorted_table
        
        return sorted_table, leaderboardLines
    end

    function UVStopRacing()
        UVSoundRacingStop()

        --UVHUDRaceCurrentCheckpoint = nil;
        UVHUDDisplayRacing = false;
        --UVHUDRace = false;

        if _UVCurrentCheckpoint and _UVCurrentCheckpoint.blip then
            _UVCurrentCheckpoint.blip.alpha = 0
        end
        if _UVNextCheckpoint and _UVNextCheckpoint.blip then
            _UVNextCheckpoint.blip.alpha = 0
        end
    end

    --
    
    if not UVHUDRaceInfo then
        UVHUDRaceInfo = {}
    end
    
    if not UVHUDRaceTime or not UVHUDRace then
        UVHUDRaceTime = UVDisplayTimeRace(0)
    end
    
    if not UVHUDRaceLaps then
        UVHUDRaceLaps = 1
    end
    
    if not UVHUDRaceCurrentLap then
        UVHUDRaceCurrentLap = 1
    end
    
    if not UVHUDRaceCurrentParticipants then
        UVHUDRaceCurrentParticipants = 1
    end

    if not UVHUDDisplayRacing then
        UVHUDDisplayRacing = false
    end
    
    function UVRaceNotify( message, duration ) --, duration
        local duration = duration or 5

        UVHUDNotificationString = message
        UVHUDNotification = true 
        timer.Simple( duration, function()
            UVHUDNotification = false
        end)
    end

    concommand.Add( "uvrace_resetposition", function()
        if (not UVResetDelay) or (CurTime() - UVResetDelay > 1) then
            UVResetDelay = CurTime()
        else return end

        net.Start("UVResetPosition"); net.SendToServer()
    end)

    concommand.Add( "uv_skipsong", function()
        if (not UVSkipDelay) or (CurTime() - UVSkipDelay > 1) then
            UVSkipDelay = CurTime()
        else return end

        UVStopSound()
    end)
    
    net.Receive( "uvrace_notification", function()
        UVRaceNotify( net.ReadString(), net.ReadFloat() )
    end)
    
    net.Receive( "uvrace_decline", function() 
	    local lang = language.GetPhrase
	
	    chat.AddText(Color(255, 126, 126),lang( net.ReadString() ))
    end)
    
    net.Receive( "uvrace_announcebestlaptime", function()
        local time = net.ReadFloat()
        local driver = net.ReadString()
        local timedifference = net.ReadFloat()
		local lang = language.GetPhrase
		
        if timedifference != 0 then
            chat.AddText(Color(255, 255, 255), string.format(lang("uv.race.newbestlap.new"), driver), Color(0, 255, 255), UVDisplayTimeRace(time), Color(255, 255, 255), " (-"..math.Round(timedifference, 3)..")")
        else
            chat.AddText(Color(255, 255, 255), string.format(lang("uv.race.newbestlap"), driver), Color(0, 255, 255), UVDisplayTimeRace(time))
        end
    end)
    
    net.Receive( "uvrace_racerinvited", function() 
        local racers = net.ReadTable()
        
        for _, v in pairs(racers) do
            chat.AddText(Color(255, 255, 255), language.GetPhrase("uv.race.invite.sentto"), Color(0,255,0), v)
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
        
        if not UVHUDRace then
            UVHUDRace = true
            UVHUDRaceCheckpoints = GetGlobalInt( "uvrace_checkpoints" )
            
            local theme = GetConVar("unitvehicle_sfxtheme"):GetString()
            local soundfiles = file.Find( "sound/uvracesfx/".. theme .."/start/*", "GAME" )
			if #soundfiles > 0 then
				surface.PlaySound( "uvracesfx/".. theme .."/start/".. soundfiles[math.random(1, #soundfiles)] )
			end
        end
    end)

    net.Receive( "uvrace_resetfailed", function()
        local lang = language.GetPhrase
        
        chat.AddText(
            Color(255, 126, 126),
            lang( net.ReadString() )
        )
    end)

    net.Receive( "uvrace_resetcountdown", function()
        local lang = language.GetPhrase
        local time_left = net.ReadInt(4)
        
        chat.AddText(
            Color(255, 255, 255),
            string.format( lang("uv.race.resetcountdown"), tostring(time_left) ), 
            time_left 
        )
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
        
        Yes:SetText("#openurl.yes")
        Yes:SetSize(ResultPanel:GetWide() * 5 / 16, 22)
        Yes:SetPos(ResultPanel:GetWide() / 8, ResultPanel:GetTall() - 22 - Yes:GetTall())
        No:SetText("#openurl.nope")
        No:SetSize(ResultPanel:GetWide() * 5 / 16, 22)
        No:SetPos(ResultPanel:GetWide() * 7 / 8 - No:GetWide(), ResultPanel:GetTall() - 22 - No:GetTall())
        
        ResultPanel.Paint = function(self, w, h)
            draw.RoundedBox(2, 0, 0, w, h, faded_black)
            draw.SimpleText("#uv.race.invite", "UVFont", 500, 5, Color(30, 255, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
            draw.SimpleText("#uv.race.invite.desc", "UVFont5", 500, 60, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
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
			if #soundfiles > 0 then
				surface.PlaySound( "uvracesfx/".. theme .."/end/".. soundfiles[math.random(1, #soundfiles)] )
			end
        end

        for vehicle, array in pairs( UVHUDRaceInfo.Participants ) do
            if not IsValid( vehicle ) then continue end
            if vehicle:GetDriver() == LocalPlayer() then array.LocalPlayer = true end
        end

        hook.Run( 'UIEventHook', 'racing', 'onRaceEnd', UVFormLeaderboard( UVHUDRaceInfo.Participants ) )
        
        UVHUDRace = false
        UVHUDRaceInfo = nil
		UVRaceCountdown = nil
        
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
				if #soundfiles > 0 then
					surface.PlaySound( "uvracesfx/".. theme .."/checkpointpass/".. soundfiles[math.random(1, #soundfiles)] )
				end
            end
        end
    end)
    
    net.Receive( "uvrace_racecomplete", function()
        local participant = net.ReadEntity()
        local place = net.ReadInt(32)
        local time = net.ReadFloat()
        
        if UVHUDRaceInfo then
            if UVHUDRaceInfo['Participants'] and UVHUDRaceInfo['Participants'][participant] then
                local participantInfo = UVHUDRaceInfo['Participants'][participant]

                UVHUDRaceInfo['Participants'][participant].Finished = true
                UVHUDRaceInfo['Participants'][participant].TotalTime = time
                
                if IsValid(participant) and participant:GetDriver() == LocalPlayer() and RacingMusic:GetBool() then
                    UVHUDRaceInfo['Participants'][participant].LocalPlayer = true
                    
                    local theme = GetConVar("unitvehicle_sfxtheme"):GetString()
                    local soundfiles = file.Find( "sound/uvracesfx/".. theme .."/"..((place == 1 and "win") or "loss").."/*", "GAME" )
                    if soundfiles and #soundfiles > 0 then
                        local audio_path = "uvracesfx/".. theme .."/"..((place == 1 and "win") or "loss").."/".. soundfiles[math.random(1, #soundfiles)]
                        surface.PlaySound(audio_path)
                    end
                end
                
                local lang = language.GetPhrase
                local PlaceStrings = {
                    [1] = { Color(240,203,122) },
                    [2] = { Color(183,201,210) },
                    [3] = { Color(179,128,41) },
                    [4] = { Color(27,147,0) },
                }
                
                local place_array = PlaceStrings[place] or PlaceStrings[4]
                chat.AddText(Color(255,255,255), UVHUDRaceInfo['Participants'][participant].Name, lang("uv.race.finishtext.1"), place_array[1], lang("uv.race.pos.num." .. place), Color(255,255,255), lang("uv.race.finishtext.2"), Color(0,255,0), UVDisplayTimeRace(time))

                local driver = participant:GetDriver()
                local is_local_player = IsValid(driver) and driver == LocalPlayer()
                
                hook.Run( 'UIEventHook', 'racing', 'onParticipantFinished', {
                    ['Participant'] = participant,
                    ['is_local_player'] = is_local_player,
                    ['Place'] = place,
                    ['TotalTime'] = time,
                    ['BestTime'] = participantInfo.BestLapTime
                } )
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

    net.Receive( "uvrace_replace", function() 
        local old_entity = net.ReadEntity()
        local new_entity = net.ReadEntity()

        if UVHUDRaceInfo and UVHUDRaceInfo ['Participants'] then
            if UVHUDRaceInfo ['Participants'][old_entity] then
                UVHUDRaceInfo ['Participants'][new_entity] = UVHUDRaceInfo ['Participants'][old_entity]
                UVHUDRaceInfo ['Participants'][old_entity] = nil
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
        local timecur = net.ReadFloat()
        local lang = language.GetPhrase

        local old_lap = UVHUDRaceInfo['Participants'][participant].Lap
        local new_lap = old_lap + 1

        local lap_time = nil
        local lap_time_cur = nil
        
        if UVHUDRaceInfo then
            if UVHUDRaceInfo['Participants'] and UVHUDRaceInfo['Participants'][participant] then
                UVHUDRaceInfo['Participants'][participant].Lap = UVHUDRaceInfo['Participants'][participant].Lap +1

                -- if not UVHUDRaceInfo['Participants'][participant].LastLapTime then
                --     UVHUDRaceInfo['Participants'][participant].LastLapTime = time
                --     UVHUDRaceInfo['Participants'][participant].BestLapTime = time
                -- elseif time < UVHUDRaceInfo['Participants'][participant].BestLapTime then
                --     UVHUDRaceInfo['Participants'][participant].BestLapTime = time
                -- end
                if not UVHUDRaceInfo['Participants'][participant].BestLapTime or UVHUDRaceInfo['Participants'][participant].LastLapTime > time then
                    UVHUDRaceInfo['Participants'][participant].BestLapTime = time
                end

                UVHUDRaceInfo['Participants'][participant].LastLapTime = time
                UVHUDRaceInfo['Participants'][participant].LastLapCurTime = timecur

                lap_time = time
                lap_time_cur = timecur
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

        hook.Run( 'UIEventHook', 'racing', 'onLapComplete', participant, new_lap, old_lap, lap_time, lap_time_cur )
    end)
    
    net.Receive( "uvrace_start", function()
        local time = net.ReadInt( 11 )
        local theme = GetConVar("unitvehicle_sfxtheme"):GetString()

        local startTable = {
            "#uv.race.go",
            "1",
            "2",
            "3",
            "#uv.race.getready",
        }

		-- Pick correct sound
		local sound = nil
		if time == 1 then
			local files = file.Find("sound/uvracesfx/" .. theme .. "/countgo/*", "GAME")
			if #files > 0 then
				sound = "uvracesfx/" .. theme .. "/countgo/" .. files[math.random(#files)]
			end
		elseif time == 2 then
			local files = file.Find("sound/uvracesfx/" .. theme .. "/count1/*", "GAME")
			if #files > 0 then
				sound = "uvracesfx/" .. theme .. "/count1/" .. files[math.random(#files)]
			end
		elseif time == 3 then
			local files = file.Find("sound/uvracesfx/" .. theme .. "/count2/*", "GAME")
			if #files > 0 then
				sound = "uvracesfx/" .. theme .. "/count2/" .. files[math.random(#files)]
			end
		elseif time == 4 then
			local files = file.Find("sound/uvracesfx/" .. theme .. "/count3/*", "GAME")
			if #files > 0 then
				sound = "uvracesfx/" .. theme .. "/count3/" .. files[math.random(#files)]
			end
		end

		-- Play sound
		if sound then
			surface.PlaySound(sound)
		end

		local label = startTable[time] or "#uv.race.getready"

		-- Setup countdown display state
		UVRaceCountdown = {
			startTime = CurTime(),        -- When this label appeared
			label = label,               -- The current label ("3", "2", etc.)
			stage = time,                -- Numeric stage to identify what’s next
			alpha = 255,                 -- Current alpha
		}
    end)
    
    hook.Add( "HUDPaint", "UVHUDRace", function() --HUD
        
        local w = ScrW()
        local h = ScrH()
		local hudyes = showhud:GetBool()
		local hudtype = GetConVar("unitvehicle_hudtype_racing"):GetString()

		-- RACE COUNTDOWN LOGIC
		if UVRaceCountdown then
			local elapsed = CurTime() - UVRaceCountdown.startTime
			local fullDuration = 1.0
			local alpha, alphabg = 255, 150

			-- Only fade for countdown numbers (stage 4 and lower)
			if UVRaceCountdown.stage <= 4 then
				local fadeOutStart = 0.7
				local fadeOutEnd = 0.85

				if UVRaceCountdown.stage == 1 then
					fadeOutStart = 0.85
					fadeOutEnd = 0.975
				end

				if elapsed >= fadeOutStart and elapsed < fadeOutEnd then
					local fadeFrac = (elapsed - fadeOutStart) / (fadeOutEnd - fadeOutStart)
					alpha = Lerp(fadeFrac, 255, 0)
					alphabg = Lerp(fadeFrac, 255, 0)
				elseif elapsed >= fadeOutEnd then
					alpha = 0
					alphabg = 0
				end
				
				if UVRaceCountdown.stage <= 0 then
					alpha = 0
					alphabg = 0
				end
			end

			-- HUD Type differences
			local bgcol = Color(0, 0, 0, alphabg)
			local textcol = Color(255, 255, 255, alpha)
			
			if hudtype == "mostwanted" then
				bgcol = Color(0, 0, 0, alphabg)
				textcol = Color(50, 255, 50, alpha)
			elseif hudtype == "carbon" then
				bgcol = Color(86, 214, 205, alphabg)
				textcol = Color(255, 217, 0, alpha)
			elseif hudtype == "undercover" then
				bgcol = Color(187, 226, 220, alphabg)
				textcol = Color(255, 255, 255, alpha)
			elseif hudtype == "prostreet" then
				bgcol = Color(0, 0, 0, alphabg)
				if UVRaceCountdown.stage <= 1 then
					textcol = Color(50, 255, 50, alpha)
				else
					textcol = Color(255, 217, 0, alpha)
				end
			end

			-- Text and BG
			surface.SetMaterial(UVMaterials["RACE_COUNTDOWN_BG"])
			surface.SetDrawColor(bgcol)
			surface.DrawTexturedRect(0, h / 3, w, h * 0.1)
    
			draw.DrawText(
				language.GetPhrase(UVRaceCountdown.label),
				"UVFont5ShadowBig",
				w / 2 + 2.5,
				h / 3 + 2.5,
				Color(0, 0, 0, alpha),
				TEXT_ALIGN_CENTER,
				TEXT_ALIGN_CENTER
			)
    
			draw.DrawText(
				language.GetPhrase(UVRaceCountdown.label),
				"UVFont5ShadowBig",
				w / 2,
				h / 3,
				textcol,
				TEXT_ALIGN_CENTER,
				TEXT_ALIGN_CENTER
			)

			-- Clean up after full duration
			if elapsed >= fullDuration then
				UVRaceCountdown = nil
			end
		end

        if UVHUDNotification and hudyes then
            draw.DrawText( UVHUDNotificationString, "UVFont5ShadowBig", ScrW()/2, ScrH()/4, Color( 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        end
        
        if not UVHUDRace then return end
        if not UVHUDRaceInfo then return end
        if not (UVHUDRaceInfo.Info and UVHUDRaceInfo.Info.Started) then return end
        
        local my_vehicle, my_array = nil, nil
        
        for vehicle, array in pairs(UVHUDRaceInfo['Participants']) do
            if IsValid(vehicle) and vehicle:GetDriver() == LocalPlayer() then
                my_vehicle, my_array = vehicle, array
                break
            end
        end
        
        if !my_vehicle then UVStopRacing() return end
        if my_array.Finished or (my_array.Disqualified or my_array.Busted) then
            -- clean up
            UVStopRacing()
            return
        end

        UVHUDDisplayRacing = true
        
        if not UVHUDDisplayBusting then
            UVSoundRacing( my_vehicle )
        end

        local var = UVKeybindResetPosition:GetInt()
						
		if input.IsKeyDown(var) and !gui.IsGameUIVisible() and vgui.GetKeyboardFocus() == nil then
			LocalPlayer():ConCommand('uvrace_resetposition')
		end
        
        UVHUDRace = true;
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

        for _, v in pairs( ents.FindByClass("uvrace_checkpoint") ) do
            if v:GetID() == checkpoint_count +1 then
                _UVCurrentCheckpoint = v
                if GMinimap then
                    v.blip.alpha = 255
                    v.blip.color = Color(0,255,0)
                end
            elseif v:GetID() == checkpoint_count +2 then
                _UVNextCheckpoint = v
                if GMinimap then
                    v.blip.alpha = 255
                    v.blip.color = Color(255,204,0)
                end
            else
                if GMinimap then
                    v.blip.alpha = 0
                end
            end
        end
        
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
            
            if CurTime() - LastWrongWayCheckTime > 3 then
                if !UVHUDNotification and !UVRaceCountdown then
                    local theme = GetConVar("unitvehicle_sfxtheme"):GetString()
                    local soundfiles = file.Find( "sound/uvracesfx/".. theme .."/wrongway/*", "GAME" )
                    if soundfiles and #soundfiles > 0 then
                        local audio_path = "uvracesfx/".. theme .."/wrongway/".. soundfiles[math.random(1, #soundfiles)]
                        surface.PlaySound(audio_path)
                    end
					if hudyes then UVRaceNotify("#uv.race.wrongway", 1.5) end
                end
            end
        end
            
        local racer_count = #string_array
    
        local lang = language.GetPhrase

		if hudyes and UV_UI.racing[hudtype] then
            UV_UI.racing[hudtype].main( my_vehicle, my_array, string_array )
		end
    end)
end