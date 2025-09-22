AddCSLuaFile()

local UVRacePlayIntro = true
local UVRacePlayMusic = false 
local UVRacePlayTransition = false

local showhud = GetConVar("cl_drawhud")
local UVRace_CurrentTrackName = UVRace_CurrentTrackName or nil
local UVRace_CurrentTrackAuthor = UVRace_CurrentTrackAuthor or nil
local UVRace_CurrentTrackHost = UVRace_CurrentTrackHost or nil

local UVHUDRaceFinishCountdownStarted = false
local UVHUDRaceFinishEndTime = nil
local UVHUDRaceFinishStartTime = nil
local UVHUDRaceAnimTriggered = false

if SERVER then
	UVRaceLaps = CreateConVar( "unitvehicle_racelaps", 1, FCVAR_ARCHIVE, "Number of laps to complete. Set to 1 to have sprint races." )
	UVRaceDNFTimer = CreateConVar( "unitvehicle_racednftimer", 30, FCVAR_ARCHIVE, "How long, once one racer crosses the line, the rest have to finish before DNF'ing." )

	UVRaceTable = {}
	UVRaceCurrentParticipants = {}
	UVRaceStartTime = CurTime()
	
	UVRaceInvites = UVRaceInvites or {}

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

	function UVRaceMakeCheckpoints( laps )
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
			UVRaceStart( laps )
		end)
	end

	function UVRaceRemoveCheckpoints()
		for _, ent in ipairs(ents.FindByClass("uvrace_brush*")) do
			ent:Remove()
		end
	end

	function UVBroadcastRacerList()
		local list = {}
		local seen = {}

		for id, data in pairs(UVRaceInvites) do
			if not IsValid(data.ent) then
				UVRaceInvites[id] = nil
			end
		end

		for id, data in pairs(UVRaceInvites) do
			if IsValid(data.ent) and not seen[data.ent:EntIndex()] then
				table.insert(list, { id = data.ent:EntIndex(), name = data.name, status = data.status, isAI = data.isAI, vehiclename = data.vehiclename })
				seen[data.ent:EntIndex()] = true
			end
		end

		net.Start("UVRace_RacersList")
		net.WriteTable(list)
		net.Broadcast()
	end

	function UVSetInviteByVehicle(vehicle, name, status)
		if not IsValid(vehicle) then return end
		local id = vehicle:EntIndex()
		local entry = UVRaceInvites[id]
		local isAI = not (IsValid(vehicle:GetDriver()) and vehicle:GetDriver():IsPlayer())
		local vehname = vehicle.PrintName 
		or vehicle.VehicleName 
		or vehicle:GetClass()

		if not entry then
			UVRaceInvites[id] = { ent = vehicle, name = name or ("Racer "..id), status = status, isAI = isAI, vehiclename = vehname }
		else
			-- Only update the status, never duplicate
			entry.status = status
			entry.name = name or entry.name
			entry.ent = vehicle
			entry.isAI = isAI
			entry.vehiclename = vehname
		end

		UVBroadcastRacerList()
	end

	-- Use vehicles as participants
	function UVRaceAddParticipant( vehicle, driver, sendmsg )
		if not IsValid(vehicle) then return end

		local id = vehicle:EntIndex()
		local name = (IsValid(driver) and driver:IsPlayer() and driver:Nick()) 
			or (vehicle.racer or "Racer " .. id)

		if UVRaceInvites[id] and UVRaceInvites[id].status == "Accepted" then
			return
		end

		table.insert( UVRaceCurrentParticipants, vehicle )
		UVSetInviteByVehicle(vehicle, (IsValid(driver) and driver:IsPlayer() and driver:Nick()) or vehicle.racer, "Accepted")

		vehicle.raceinvited = false
		timer.Remove('RaceInviteExpire'..vehicle:EntIndex())

		local driver = UVGetDriver(vehicle)
		local is_player 

		vehicle.racefinished = false
		vehicle.uvraceparticipant = true
		vehicle.racedriver = driver
		vehicle.isresetting = false

		if sendmsg then
			-- PrintMessage( HUD_PRINTTALK, name .. " has joined the race!" )
		end

		vehicle:CallOnRemove( "uvrace_participantremoved", function( ent )
			local driver = UVGetDriver( vehicle )

			if vehicle.isresetting then return end
			UVSetInviteByVehicle(ent, nil, "Disqualified")
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

	function UVRaceStart( laps ) --Start procedure
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
			['Laps'] = laps or UVRaceLaps:GetInt(),
			['Racers'] = 0,
			['Time'] = 0
		}

		local starttimer = 8
		for i, vehicle in pairs( UVRaceCurrentParticipants ) do
			local driver = vehicle:GetDriver()
			local vehiclename = vehicle.PrintName 
			or vehicle.VehicleName 
			or vehicle:GetClass()

			UVRaceTable['Participants'][vehicle] = {
				['Lap'] = 1,
				['Position'] = i,
				['Name'] = ((IsValid(driver) and driver:GetName()) or (vehicle.racer or "Racer "..vehicle:EntIndex())),
				['IsAI'] = (not IsValid(driver) or not driver:IsPlayer()),
				--['Laps'] = {},
				--['BestLapTime'] = CurTime(),
				--['LastLapTime'] = CurTime(),
				['Finished'] = false,
				['Disqualified'] = false,
				['Busted'] = false,
				['Checkpoints'] = {},
				['Vehicle'] = vehicle,
				['VehicleName'] = vehiclename,
			}

			if IsValid(driver) and driver:IsPlayer() then
				net.Start( "uvrace_start" )
				net.WriteInt( starttimer, 11 )
				net.Send( driver )
			end
		end

		net.Start( "uvrace_info" )
		net.WriteTable( UVRaceTable )
		net.Broadcast()

		timer.Create( "uvrace_start", 1, starttimer, function()
			local time = timer.RepsLeft( "uvrace_start" )
			for _, vehicle in pairs( UVRaceCurrentParticipants ) do
				local driver = UVGetDriver( vehicle )
				if driver then
					net.Start( "uvrace_start" )
					net.WriteInt( time, 11 )
					net.Send( driver )
				end
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
		
		net.Start("UVRace_TrackReady")
			net.WriteString("?")
			net.WriteString("?")
			net.WriteString("?")
		net.Broadcast()
		
		UVRaceInvites = {}
		UVBroadcastRacerList()

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
		if not uvbestlaptime then
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

	function UVCheckRaceDisqualification( vehicle )
		if vehicle.uvbusted then
			UVRaceRemoveParticipant( vehicle, 'Busted' )
			return
		end

		-- Damage check
		if UVCheckIfWrecked(vehicle) and not vehicle.hasreset then
			UVRaceRemoveParticipant( vehicle, 'Disqualified' )
			return
		end
	end

	local function UVRaceEndCountdown()
		if UVHUDRaceFinishCountdownStarted then return end
		timer.Create("UVRaceFinishCountdown", GetConVar("unitvehicle_racednftimer"):GetInt(), 1, function()
			UVRaceEnd()
			
			timer.Simple(0, function() -- Delay slightly to avoid conflict
				net.Start("uvrace_end")
				net.Broadcast()
			end)
		end)
	end

	net.Receive("UVRace_BeginEndCountdown", function(len, ply)
		UVRaceEndCountdown()
	end)
	
	net.Receive("UVRace_StopEndCountdown", function(len, ply)
		if timer.Exists("UVRaceFinishCountdown") then
			timer.Remove("UVRaceFinishCountdown")
		end
	end)

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

		if not UVRaceInEffect then return end
		if UVRacePrep then return end

		if next( UVRaceCurrentParticipants ) ~= nil then
			local pos = 0
			--local player_table = {}

			for _, vehicle in pairs( UVRaceCurrentParticipants ) do
				if IsValid( vehicle ) then
					UVCheckRaceDisqualification( vehicle )
				end
			end

		elseif not UVRacePrep then
			UVRaceEnd()
			net.Start( "uvrace_end" )
			net.Broadcast()
		end

	end)

	net.Receive( "uvrace_invite", function( len, ply ) 
		local bool = net.ReadBool()
		local car = UVGetVehicle( ply )

		if not car then return end
		if not car.raceinvited then return end

		local id = car:EntIndex()
		local entry = UVRaceInvites[id]
		if not entry then return end

		if bool then
			UVRaceAddParticipant( car, ply, true )
			entry.status = "Accepted"
			entry.vehiclename = car.PrintName or car.VehicleName or car:GetClass()
		else
			car.raceinvited = false;
			timer.Remove( 'RaceInviteExpire'..car:EntIndex() )
			entry.status = "Declined"
		end

		UVBroadcastRacerList()
	end)
else -- CLIENT stuff
	UVHUDGlobalBestLapTime = UVHUDGlobalBestLapTime or nil
	UVHUDGlobalBestLapHolder = UVHUDGlobalBestLapHolder or nil
	UVPreRaceInfo = CreateClientConVar( "unitvehicle_preraceinfo", 0, true, false, "Set to 1 to have a cinematic-like race details list when a race begins." )
	UVRaceDNFTimer = CreateClientConVar( "unitvehicle_racednftimer", 30, true, false, "How long, once one racer crosses the line, the rest have to finish before DNF'ing." )

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
		if not UVTraxFreeroam:GetBool() and not RacingThemeOutsideRace:GetBool() then
			if not RacingMusic:GetBool() or (RacingMusicPriority:GetBool() and UVHUDDisplayPursuit) then return end
			if (not UVHUDRace) then return end 
		end

		if UVHUDDisplayRacing and not RacingMusic:GetBool() then return end

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
			--UVRacePlayMusic = true

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
			--UVRacePlayMusic = false 

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

		if not lArray then 
			return sorted_table
		end

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

			if not IsValid(vehicle) then
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
			else
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
						if math.abs( difference ) ~= 1 then ltext = "uv.race.suffix.laps" end
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
		end

		--UVSortedRacers = sorted_table

		return sorted_table, leaderboardLines
	end

	function UVStopRacing()
		if not UVHUDDisplayRacing then return end

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

		if timedifference ~= 0 then
			-- chat.AddText(Color(255, 255, 255), string.format(lang("uv.race.newbestlap.new"), driver), Color(0, 255, 255), UVDisplayTimeRace(time), Color(255, 255, 255), " (-"..math.Round(timedifference, 3)..")")
		else
			-- chat.AddText(Color(255, 255, 255), string.format(lang("uv.race.newbestlap"), driver), Color(0, 255, 255), UVDisplayTimeRace(time))
		end
	end)

	net.Receive( "uvrace_racerinvited", function() 
		local racers = net.ReadTable()

		for _, v in pairs(racers) do
			-- chat.AddText(Color(255, 255, 255), language.GetPhrase("uv.race.invite.sentto"), Color(0,255,0), v)
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

		-- chat.AddText(
			-- Color(255, 126, 126),
			-- lang( net.ReadString() )
		-- )
		-- UVRaceNotify( lang( net.ReadString() ), 2  )

		UV_UI.general.events.CenterNotification({
            text = lang( net.ReadString() ),
		})
	end)

	net.Receive( "uvrace_resetcountdown", function()
		local lang = language.GetPhrase
		local time_left = net.ReadInt(4)

		-- chat.AddText(
			-- Color(255, 255, 255),
			-- string.format( lang("uv.race.resetcountdown"), tostring(time_left) ), 
			-- time_left 
		-- )
		
		-- UVRaceNotify( string.format( lang("uv.race.resetcountdown"), tostring(time_left) ), 2  )
		
		UV_UI.general.events.CenterNotification({
            text = string.format( lang("uv.race.resetcountdown"), tostring(time_left) ), 
		})
	end)

	net.Receive( "uvrace_invite", function()
		if IsValid(InvitePanel) then InvitePanel:Remove() end
        
		local w = ScrW()
		local h = ScrH()

		InvitePanel = vgui.Create("DFrame")
		local Yes = vgui.Create("DButton")
		local No = vgui.Create("DButton")

		InvitePanel:Add(Yes)
		InvitePanel:Add(No)
		InvitePanel:SetSize(w, h)
		InvitePanel:SetBackgroundBlur(true)
		InvitePanel:ShowCloseButton(false)
		InvitePanel:Center()
		InvitePanel:SetTitle("")
		InvitePanel:SetDraggable(false)
		InvitePanel:SetKeyboardInputEnabled(false)
		gui.EnableScreenClicker(true)

		Yes:SetText("")
		Yes:SetPos(w*0.33, h*0.475)
		Yes:SetSize(w - (w * 0.66), h*0.05)
        Yes.Paint = function() end
		
		No:SetText("")
		No:SetPos(w*0.33, h*0.525)
		No:SetSize(w - (w * 0.66), h*0.05)
        No.Paint = function() end

        local timetotal = 10
		local timestart = CurTime()

		local bgScale, bgAlpha, bgAnimStart = 0, 0, CurTime()
		local contentAlpha, contentStart = 0, CurTime()

		local closing = false
		local closeStartTime = 0
		local playedfadeSound = false

		InvitePanel.Paint = function(self, w, h)
			local timeremaining = math.ceil(timetotal - (CurTime() - timestart))
			local curTime = CurTime()
			local elapsedAnim = curTime - bgAnimStart
			local effectiveAlpha = contentAlpha
			local headerAlpha = 0

			-- Opening background animation
			bgScale = math.Clamp(elapsedAnim / 0.2, 0, 1)
			bgAlpha = math.Clamp((elapsedAnim - 0.1)/0.3, 0, 1)*255

			local shrinkFactor = 1
			local baseHeight = h - h*0.75
			local scaledHeight = baseHeight * bgScale * shrinkFactor
			local yOffset = (baseHeight - scaledHeight) * 0.5

			-- Closing two-phase logic
			if closing then
				gui.EnableScreenClicker(false)
				Yes:SetEnabled(false)
				No:SetEnabled(false)
				
				local elapsedFade = curTime - closeStartTime
				local textFadeDuration, bgShrinkDuration = 0.125, 0.15

				-- Phase 1: fade out texts/buttons
				local textProgress = math.Clamp(elapsedFade / textFadeDuration, 0, 1)
				effectiveAlpha = contentAlpha * (1 - textProgress)
				headerAlpha = 255 * (1 - textProgress)

				-- Phase 2: shrink background vertically
				local bgProgress = math.Clamp((elapsedFade - textFadeDuration) / bgShrinkDuration, 0, 1)
				shrinkFactor = 1 - bgProgress

				scaledHeight = baseHeight * bgScale * shrinkFactor
				yOffset = (baseHeight - scaledHeight) * 0.5

				-- if not playedfadeSound and elapsedFade >= 0.05 then
					-- playedfadeSound = true
					-- surface.PlaySound("uvui/world/close.wav")
				-- end

				if elapsedFade >= textFadeDuration + bgShrinkDuration then
					if IsValid(InvitePanel) then InvitePanel:Close() end
					return
				end
			end
			
			if not closing then
				Yes:SetEnabled(true)
				No:SetEnabled(true)
				local revealProgress = math.Clamp((curTime - contentStart) / 0.6, 0, 1)
				contentAlpha = revealProgress * 255
			end
			
			-- Draw background
			surface.SetDrawColor( 255, 255, 255, bgAlpha)
			surface.SetMaterial(UVMaterials["RESULTSBG_WORLD"])
			surface.DrawTexturedRect( w*0.33, h*0.35 + yOffset, w - w*0.66, scaledHeight )

			-- Header
			surface.SetDrawColor(255, 255, 255, effectiveAlpha)
			surface.SetMaterial(UVMaterials["RESULTS_SHEEN_ESCAPED"])
			surface.DrawTexturedRect(w * 0.33, h * 0.355, w - ( w * 0.66 ), h * 0.1)

			draw.SimpleTextOutlined( "#uv.race.invite", "UVFont5", w * 0.5, h * 0.36, Color( 225, 255, 255, effectiveAlpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 3, Color( 0, 0, 0, effectiveAlpha) )
			draw.SimpleTextOutlined( "#uv.race.invite.desc", "UVMostWantedLeaderboardFont", w * 0.5, h * 0.4, Color( 225, 255, 255, effectiveAlpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, Color( 0, 0, 0, effectiveAlpha) )
			
			
			draw.SimpleTextOutlined( string.format( language.GetPhrase("uv.race.invite.host"), UVRace_CurrentTrackHost ), "UVMostWantedLeaderboardFont", w * 0.5, h * 0.425, Color( 225, 255, 255, effectiveAlpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, Color( 0, 0, 0, effectiveAlpha) )
			
			draw.SimpleTextOutlined( string.format( language.GetPhrase("uv.prerace.name"), UVRace_CurrentTrackName ), "UVMostWantedLeaderboardFont", w * 0.5, h * 0.45, Color( 225, 255, 255, effectiveAlpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, Color( 0, 0, 0, effectiveAlpha) )

			-- Yes / Rejoin
			surface.SetDrawColor(255, 255, 255, effectiveAlpha)
			surface.SetMaterial(UVMaterials["RESULTS_NEXTBTN_INACTIVE_WORLD"])
			surface.DrawTexturedRect(w * 0.33, h * 0.475, w - ( w * 0.66 ), h * 0.05 )
			
			if IsValid(Yes) and Yes:IsHovered() then
				surface.SetDrawColor(255, 255, 255, effectiveAlpha * math.abs(math.sin(RealTime() * 3)))
				surface.SetMaterial(UVMaterials["RESULTS_NEXTBTN_GLOW_WORLD"])
				surface.DrawTexturedRect(Yes:GetX(), Yes:GetY(), Yes:GetWide(), Yes:GetTall())
				
				surface.SetDrawColor(255, 255, 255, effectiveAlpha)
				surface.SetMaterial(UVMaterials["RESULTS_NEXTBTN_WORLD"])
				surface.DrawTexturedRect(Yes:GetX(), Yes:GetY(), Yes:GetWide(), Yes:GetTall())
			end

			draw.SimpleTextOutlined( "#uv.race.invite.accept", "UVMostWantedLeaderboardFont",w * 0.5, h * 0.486, Color( 225, 255, 255, effectiveAlpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, effectiveAlpha ) )
			
			-- No / Abandon
			surface.SetDrawColor(255, 255, 255, effectiveAlpha)
			surface.SetMaterial(UVMaterials["RESULTS_NEXTBTN_INACTIVE_WORLD"])
			surface.DrawTexturedRect(w * 0.33, h * 0.525, w - ( w * 0.66 ), h * 0.05 )
			
			if IsValid(No) and No:IsHovered() then
				surface.SetDrawColor(255, 255, 255, effectiveAlpha * math.abs(math.sin(RealTime() * 3)))
				surface.SetMaterial(UVMaterials["RESULTS_NEXTBTN_GLOW_WORLD"])
				surface.DrawTexturedRect(No:GetX(), No:GetY(), No:GetWide(), No:GetTall())
				
				surface.SetDrawColor(255, 255, 255, effectiveAlpha)
				surface.SetMaterial(UVMaterials["RESULTS_NEXTBTN_WORLD"])
				surface.DrawTexturedRect(No:GetX(), No:GetY(), No:GetWide(), No:GetTall())
			end

			draw.SimpleTextOutlined( "#uv.race.invite.decline", "UVMostWantedLeaderboardFont",w * 0.5, h * 0.536, Color( 225, 255, 255, effectiveAlpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, effectiveAlpha ) )

			-- Auto-Close Timer
			local autotext = string.format(language.GetPhrase("uv.results.autoclose"), math.max(0, timeremaining))
			
			draw.SimpleTextOutlined( autotext, "UVMostWantedLeaderboardFont",w * 0.5, h * 0.5725, Color( 225, 255, 255, effectiveAlpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, effectiveAlpha ) )

            if timeremaining < 1 and not closing then
				net.Start("uvrace_invite")
				net.WriteBool(false)
				net.SendToServer()
				
                exitStarted = true
                closing = true
				closeStartTime = CurTime()
            end
		end

		function Yes:DoClick()
            closing = true
			closeStartTime = CurTime()

			net.Start("uvrace_invite")
			net.WriteBool(true)
			net.SendToServer()
		end
		
		function No:DoClick()
            closing = true
			closeStartTime = CurTime()

			net.Start("uvrace_invite")
			net.WriteBool(false)
			net.SendToServer()
		end
	end)

	local UVRaceStarting = false

	net.Receive( "uvrace_end", function()
		if not UVHUDRace then return end
		if UVHUDRace and RacingMusic:GetBool() then 
			local theme = GetConVar("unitvehicle_sfxtheme"):GetString()
			local soundfiles = file.Find( "sound/uvracesfx/".. theme .."/end/*", "GAME" )
			if #soundfiles > 0 then
				surface.PlaySound( "uvracesfx/".. theme .."/end/".. soundfiles[math.random(1, #soundfiles)] )
			end
		end

		for vehicle, array in pairs( UVHUDRaceInfo.Participants ) do
			if IsValid( vehicle ) and vehicle:GetDriver() == LocalPlayer() then array.LocalPlayer = true end
		end

		hook.Run( 'UIEventHook', 'racing', 'onRaceEnd', UVFormLeaderboard( UVHUDRaceInfo.Participants ) )

		UVHUDRace = false
		UVHUDRaceInfo = nil
		UVRaceCountdown = nil
		UVRaceCinematicOverlay = nil

		UVHUDRaceFinishCountdownStarted = false
		UVHUDRaceFinishEndTime = nil

		UVRaceStarting = false
		
		UVWorldCountdown = nil
		hook.Remove("HUDPaint", "UV_Countdown_World")

		net.Start("UVRace_StopEndCountdown")
		net.SendToServer()

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
				local mutesfx = GetConVar("unitvehicle_mutecheckpointsfx"):GetBool()
				local soundfiles = file.Find( "sound/uvracesfx/".. theme .."/checkpointpass/*", "GAME" )
				if not mutesfx and #soundfiles > 0 then
					surface.PlaySound( "uvracesfx/".. theme .."/checkpointpass/".. soundfiles[math.random(1, #soundfiles)] )
				end
			end
		end
	end)

	net.Receive( "uvrace_checkpointsplit", function()
		local participant = net.ReadEntity()
		local checkpoint = net.ReadInt(11)
		local numParticipants = net.ReadUInt(8)

		if not IsValid(participant) then return end

		local driver = participant:GetDriver()
		local is_local_player = (driver == LocalPlayer())

		hook.Run( "UIEventHook", "racing", "onLapSplit", participant, checkpoint, is_local_player, numParticipants )
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

				if not UVHUDRaceFinishCountdownStarted and (GetConVar("unitvehicle_racednftimer"):GetInt() > 0) then -- DNF Timer
					net.Start("UVRace_BeginEndCountdown")
					net.SendToServer()
					
					UVHUDRaceFinishCountdownStarted = true
					UVHUDRaceFinishEndTime = CurTime() + GetConVar("unitvehicle_racednftimer"):GetInt()
				end

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
				-- chat.AddText(Color(255,255,255), UVHUDRaceInfo['Participants'][participant].Name, lang("uv.race.finishtext.1"), place_array[1], lang("uv.race.pos.num." .. place), Color(255,255,255), lang("uv.race.finishtext.2"), Color(0,255,0), UVDisplayTimeRace(time))

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
		local driver = IsValid(participant) and participant:GetDriver()
		local is_local_player = IsValid(driver) and driver == LocalPlayer()

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
			if reason == 'Disqualified' and #UVHUDWantedSuspects < 1 then
				hook.Run( 'UIEventHook', 'racing', 'onParticipantDisqualified', {
					['Participant'] = participant,
					['is_local_player'] = is_local_player,
				} )
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

		-- Reset best lap times and other lap data on race start
		if CLIENT then
			UVHUDGlobalBestLapTime = nil
			UVHUDGlobalBestLapHolder = nil
		end

		if UVHUDRaceInfo and UVHUDRaceInfo['Participants'] then
			for participant, data in pairs(UVHUDRaceInfo['Participants']) do
				data.BestLapTime = nil
				data.LastLapTime = nil
				data.LastLapCurTime = nil
			end
		end
	end)

	net.Receive( "uvrace_lapcomplete", function()
		local participant = net.ReadEntity()
		local time = net.ReadFloat()
		local timecur = net.ReadFloat()
		local lang = language.GetPhrase

		if not UVHUDRaceInfo then return end
		if not UVHUDRaceInfo.Participants[participant] then return end

		local old_lap = UVHUDRaceInfo['Participants'][participant].Lap
		local new_lap = old_lap + 1

		local lap_time = nil
		local lap_time_cur = nil

		if UVHUDRaceInfo then
			if UVHUDRaceInfo['Participants'] and UVHUDRaceInfo['Participants'][participant] then
				UVHUDRaceInfo['Participants'][participant].Lap = UVHUDRaceInfo['Participants'][participant].Lap +1

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

		local is_global_best = false

		-- Per-player best lap update (no chat)
		if UVHUDLastLapTime == nil then
			UVHUDLastLapTime = time
			UVHUDBestLapTime = time
		else
			if time < UVHUDBestLapTime then
				UVHUDLastLapTime = time
				UVHUDBestLapTime = time
			else
				UVHUDLastLapTime = time
			end
		end

		-- Global best lap update and flag set
		if UVHUDGlobalBestLapTime == nil or time < UVHUDGlobalBestLapTime then
			UVHUDGlobalBestLapTime = time
			UVHUDGlobalBestLapHolder = participant
			is_global_best = true
		end

		local is_local_player = IsValid(participant) and participant:GetDriver() == LocalPlayer()

		local total_laps = UVHUDRaceInfo['Info'] and UVHUDRaceInfo['Info'].Laps or 0

		if (total_laps <= 1 or new_lap > total_laps) and not is_global_best then
			return
		end

		local lap_final = false
		if (total_laps > 1 and new_lap == total_laps) then 
			lap_final = true
		end

		hook.Run( 'UIEventHook', 'racing', 'onLapComplete', participant, new_lap, old_lap, lap_time, lap_time_cur, is_local_player, is_global_best, lap_final )
	end)
	
	net.Receive("UVRace_HideRacersList", function()
		UVRaceStarting = true
	end)

	net.Receive( "uvrace_start", function()
		local time = net.ReadInt( 11 )
		local theme = GetConVar("unitvehicle_sfxtheme"):GetString()

		local startTable = {}
		for i = 0, time do
			startTable[i] = i
		end
	
		-- Pick correct sound
		local sound = nil
		if time == 1 then
			local files = file.Find("sound/uvracesfx/" .. theme .. "/countgo/*", "GAME")
			if #files > 0 then
				sound = "uvracesfx/" .. theme .. "/countgo/" .. files[math.random(#files)]
			end
			UVRaceCinematicOverlay = nil
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

		local label = startTable[time] - 1 or "#uv.race.getready"

		if time == 1 then label = "#uv.race.go" end

		if time > 4 and not UVRaceCinematicOverlay then
			UVRaceCinematicOverlay = {
				startTime = CurTime(),
				slideInDuration = 0.5,
				slideOutDuration = 0.5,
				state = "slidingIn",  -- can be "slidingIn", "holding", or "slidingOut"
				holdStartTime = nil,
			}
		end
		
		-- Play sound
		if sound then
			surface.PlaySound(sound)
		end

		-- Setup countdown display state
		UVRaceCountdown = {
			startTime = CurTime(),        -- When this label appeared
			label = label,               -- The current label ("3", "2", etc.)
			stage = time,                -- Numeric stage to identify what’s next
			alpha = 255,                 -- Current alpha
		}
		
		-- For the UI
		hook.Run("UIEventHook", "racing", "onRaceStartTimer", { starttime = time })
	end)

	hook.Add( "HUDPaint", "UVHUDRace", function() --HUD
		local w = ScrW()
		local h = ScrH()
		local hudyes = GetConVar("cl_drawhud"):GetBool()
		local hudtype = GetConVar("unitvehicle_hudtype_main"):GetString()
				
		-- if hudyes and UVHUDDisplayRacing and UVHUDRaceFinishCountdownStarted then
		if hudyes and UVHUDRaceFinishCountdownStarted and not UVHUDCopMode then
			local now = CurTime()
			local realTime = RealTime()
			local startTime = UVHUDRaceFinishStartTime or now
			local animTime = now - startTime

			-- Phase durations
			local delay = 0.1
			local expandDuration = 0.25
			local whiteFadeInDuration = 0.025
			local blackFadeOutDuration = 1

			local expandStart = delay
			local whiteStart = expandStart + expandDuration
			local blackStart = whiteStart + whiteFadeInDuration
			local endAnim = blackStart + blackFadeOutDuration

			-- Compute bar width
			local barProgress = 0
			if animTime >= expandStart then
				barProgress = math.Clamp((animTime - expandStart) / expandDuration, 0, 1)
			end

			local currentWidth = Lerp(barProgress, 0, w)
			local barHeight = h * 0.1
			local barX = (w - currentWidth) / 2
			local barY = h - barHeight

			-- Compute bar color
			local colorVal = 0
			if animTime >= whiteStart and animTime < blackStart then
				-- black → white
				local p = (animTime - whiteStart) / whiteFadeInDuration
				colorVal = Lerp(math.Clamp(p, 0, 1), 0, 255)
			elseif animTime >= blackStart then
				-- white → black
				local p = (animTime - blackStart) / blackFadeOutDuration
				colorVal = Lerp(math.Clamp(p, 0, 1), 255, 0)
			end

			-- Draw bar
			surface.SetMaterial(UVMaterials["RACE_COUNTDOWN_BG"])
			surface.SetDrawColor(Color(colorVal, colorVal, colorVal, 255))
			surface.DrawTexturedRect(barX, barY, currentWidth, barHeight)

			-- Display text only after bar is white or fading
			if animTime >= whiteStart then
				local timeLeft = math.max(0, math.floor(UVHUDRaceFinishEndTime - now + 0.999))

				-- Blink red depending on time left
				local blink = 255 * math.abs(math.sin(realTime * 4))
				local blink2 = 255 * math.abs(math.sin(realTime * 6))
				local blink3 = 255 * math.abs(math.sin(realTime * 8))
				local redblink = 255

				if timeLeft >= 10 then
					redblink = redblink
				elseif timeLeft >= 5 then
					redblink = blink
				elseif timeLeft >= 3 then
					redblink = blink2
				else
					redblink = blink3
				end

				-- Outline alpha fades in as colorVal returns to black
				local outlineAlpha = math.Clamp(255 - colorVal, 0, 255)

				draw.SimpleTextOutlined( "#uv.race.endsin", "UVFont5", w * 0.5, h * 0.9, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1.25, Color(0, 0, 0, outlineAlpha) )
				draw.SimpleTextOutlined( timeLeft, "UVFont5", w * 0.5, h * 0.95, Color(255, redblink, redblink), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1.25, Color(0, 0, 0, outlineAlpha) )
			end
		end

		-- RACE COUNTDOWN LOGIC
		if UVRaceCountdown and hudyes and UVRaceCountdown.stage <= 4 and not UV_UI.racing[hudtype].events.onRaceStartTimer then
			local elapsed = CurTime() - UVRaceCountdown.startTime
			local fullDuration = 1.0
			local alpha, alphabg = 255, 150

			if UVRaceCountdown.stage <= 4 then -- Only fade for countdown numbers (stage 4 and lower)
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

			local bgcol = Color(0, 0, 0, alphabg) -- HUD Type differences
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

			surface.SetMaterial(UVMaterials["RACE_COUNTDOWN_BG"]) -- Text and BG
			surface.SetDrawColor(bgcol)
			surface.DrawTexturedRect(0, h * 0.3475, w, h * 0.05)

			draw.SimpleTextOutlined(UVRaceCountdown.label, "UVFont5", w * 0.5, h * 0.35, textcol, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1.25, Color( 0, 0, 0, alpha ) )

			if elapsed >= fullDuration then -- Clean up after full duration
				UVRaceCountdown = nil
			end
		end

		if UVRaceCountdown and hudyes and UVRaceCountdown.stage > 4 and not GetConVar("unitvehicle_preraceinfo"):GetBool() and not UV_UI.racing[hudtype].events.onRaceStartTimer then
			local elapsed = CurTime() - UVRaceCountdown.startTime
			local fullDuration = 1.0
			local alpha, alphabg = 255, 150

			local bgcol = Color(0, 0, 0, alphabg) -- HUD Type differences
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

			surface.SetMaterial(UVMaterials["RACE_COUNTDOWN_BG"]) -- Text and BG
			surface.SetDrawColor(bgcol)
			surface.DrawTexturedRect(0, h * 0.3475, w, h * 0.05)

			draw.SimpleTextOutlined("#uv.race.getready", "UVFont5", w * 0.5, h * 0.35, textcol, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1.25, Color( 0, 0, 0, alpha ) )
		end

		if not UVHUDRace then UVHUDDisplayRacing = false; return end
		if not UVHUDRaceInfo then UVHUDDisplayRacing = false; return end
		if not (UVHUDRaceInfo.Info and UVHUDRaceInfo.Info.Started) then UVHUDDisplayRacing = false; return end

		if UVHUDRaceFinishCountdownStarted and not UVHUDRaceAnimTriggered then
			UVHUDRaceAnimTriggered = true
			UVHUDRaceFinishStartTime = CurTime()
		end

		if not UVHUDRaceFinishCountdownStarted then
			UVHUDRaceAnimTriggered = false
		end

		local my_vehicle, my_array = nil, nil

		for vehicle, array in pairs(UVHUDRaceInfo['Participants']) do
			if IsValid(vehicle) and vehicle:GetDriver() == LocalPlayer() then
				my_vehicle, my_array = vehicle, array
				break
			end
		end

		if not my_vehicle then UVStopRacing() return end
		if my_array.Finished or (my_array.Disqualified or my_array.Busted) then
			-- clean up
			UVStopRacing()
			return
		end

		UVHUDDisplayRacing = true
		if not UVHUDDisplayPursuit or (UVHUDDisplayPursuit and not RacingMusicPriority:GetBool()) then
			UVSoundRacing( my_vehicle )
		end

		local var = UVKeybindResetPosition:GetInt()

		if input.IsKeyDown(var) and not gui.IsGameUIVisible() and vgui.GetKeyboardFocus() == nil then
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
		UVLastWrongWayCheckTime = UVLastWrongWayCheckTime or CurTime()

		if _UVCurrentCheckpoint and IsValid(_UVCurrentCheckpoint) then
			local vehicle_center = my_vehicle:WorldSpaceCenter()
			local vehicle_velocity = my_vehicle:GetVelocity()
			local check_center_pos = (_UVCurrentCheckpoint:GetPos() + _UVCurrentCheckpoint:GetMaxPos()) / 2

			local speed = vehicle_velocity:Length()
			local min_speed = 50 -- units/sec threshold to consider movement

			if speed >= min_speed then
				local to_checkpoint = (check_center_pos - vehicle_center):GetNormalized()
				local normalized_velo = vehicle_velocity:GetNormalized()

				local dot_product = normalized_velo:Dot(to_checkpoint)

				-- If moving more than 90° away from checkpoint
				if dot_product < 0 then
					-- moving away
					if CurTime() - UVLastWrongWayCheckTime > 3 then
						if not UVHUDNotification and not UVRaceCountdown then
							local theme = GetConVar("unitvehicle_sfxtheme"):GetString()
							local soundfiles = file.Find("sound/uvracesfx/" .. theme .. "/wrongway/*", "GAME")
							if soundfiles and #soundfiles > 0 then
								local audio_path = "uvracesfx/" .. theme .. "/wrongway/" .. soundfiles[math.random(1, #soundfiles)]
								surface.PlaySound(audio_path)
							end
							if hudyes then UVRaceNotify("#uv.race.wrongway", 1.5) end
						end
					end
				else
					-- moving toward or not too far off-course
					UVLastWrongWayCheckTime = CurTime()
				end
			else
				-- If stationary, don't trigger wrong way
				UVLastWrongWayCheckTime = CurTime()
			end
		end

		-- Racer nametags
		if RacerTags:GetBool() and IsValid( my_vehicle ) then
			local localPlayer = LocalPlayer()
			local myVehicle = localPlayer:GetVehicle()

			local renderQueue = {}

			for vehicle, info in pairs(UVHUDRaceInfo.Participants or {}) do
				if not IsValid(vehicle) or UVGetDriver(vehicle) == LocalPlayer() then continue end
				if info.Status == "Disqualified" or info.Status == "Busted" then continue end

				local dist = localPlayer:GetPos():DistToSqr(vehicle:GetPos())
				table.insert(renderQueue, { vehicle = vehicle, dist = dist })
			end

			-- Sort so farther ones draw first, closer ones last (on top)
			table.sort(renderQueue, function(a, b)
				return a.dist < b.dist
			end)

			local maxSquares = 4
			local count = math.min(#renderQueue, maxSquares)

			for i = count, 1, -1 do
				local data = renderQueue[i]
				if data then
					UVRenderEnemySquare(data.vehicle)
				end
			end
		end
		
		-- Racer Map Icons
		for vehicle, info in pairs(UVHUDRaceInfo.Participants or {}) do
			if not IsValid(vehicle) or UVGetDriver(vehicle) == LocalPlayer() then continue end

			if not GMinimap then continue end
			if not vehicle.displayedonhud then
				vehicle.displayedonhud = true
				local blip, id = GMinimap:AddBlip({
					id = "UVBlip" .. vehicle:EntIndex(),
					parent = vehicle,
					icon = "unitvehicles/icons/MINIMAP_ICON_CAR.png",
					scale = 1.4,
					color = Color(255, 191, 0),
				})
				if vehicle:GetClass() == "prop_vehicle_jeep" then
					blip.icon = "unitvehicles/icons/MINIMAP_ICON_CAR_JEEP.png" -- Icon points the other way
				end
			end

			if vehicle.displayedonhud then
				local curblip = GMinimap:FindBlipByID("UVBlip" .. vehicle:EntIndex())
				if not curblip then continue end

				if UVHUDCopMode and ((UVHUDCopMode and UVHUDDisplayCooldown) or 
					(tonumber(UVUnitsChasing) <= 0 or not vehicle.inunitview) and 
					not ((not GetConVar("unitvehicle_unit_onecommanderevading"):GetBool()) and UVOneCommanderActive)) 
				then
					curblip.alpha = 0
				else
					curblip.alpha = 255
				end
			end
		end
		local racer_count = #string_array

		local lang = language.GetPhrase

		if hudyes and UV_UI.general.racing then
			UV_UI.general.racing.main( my_vehicle, my_array, string_array )
		end
		
		if hudyes and UV_UI.racing[hudtype] then
			UV_UI.racing[hudtype].main( my_vehicle, my_array, string_array )
		end
	end)
	
	local UVRace_RacerList = {}

	net.Receive("UVRace_RacersList", function()
		local list = net.ReadTable() or {}
		UVRace_RacerList = list

		local seen, dedup = {}, {}
		for _, r in ipairs(UVRace_RacerList) do
			if r.id and not seen[r.id] then
				seen[r.id] = true
				dedup[#dedup+1] = r
			end
		end
		UVRace_RacerList = dedup
	end)

	net.Receive("UVRace_TrackReady", function()
		local name = net.ReadString()
		local author = net.ReadString()
		local hostedby = net.ReadString()

		if name == "?" and author == "?" then
			UVRace_CurrentTrackName = nil
			UVRace_CurrentTrackAuthor = nil
			UVRace_CurrentTrackHost = nil
		else
			UVRace_CurrentTrackName = name
			UVRace_CurrentTrackAuthor = author
			UVRace_CurrentTrackHost = hostedby
		end
	end)

	hook.Add("HUDPaint", "UVRace_DisplayTrackInfo", function()
		if not IsValid(LocalPlayer()) then return end -- Am I invalid? Tough shit
		if not UVRace_CurrentTrackName then return end -- No track
		if not UVRace_RacerList then return false end -- No invite, no accepted invite, not host
		if UVRaceStarting then return end -- Race is starting; hide it

		local function ShouldShowRacerHUD()
			if not UVRace_RacerList or not istable(UVRace_RacerList) then return false end

			local ply = LocalPlayer()
			if not IsValid(ply) then return false end

			-- Host always sees it
			if UVRace_CurrentTrackHost and ply:Nick() == UVRace_CurrentTrackHost then
				return true
			end

			-- Try to resolve the player's "main" vehicle on the client
			local car
			do
				local veh = ply:GetVehicle()
				if IsValid(veh) then
					-- If they're in a seat, prefer the parent as the main vehicle
					local parent = veh:GetParent()
					car = IsValid(parent) and parent or veh
				end
			end

			-- Primary check: compare vehicle EntIndex against the list's id (which is a vehicle EntIndex)
			if IsValid(car) then
				local carId = car:EntIndex()
				for _, r in ipairs(UVRace_RacerList) do
					-- if r.id == carId and (r.status == "Invited" or r.status == "Accepted") then
					if r.id == carId and r.status == "Accepted" then
						return true
					end
				end
			end

			-- Fallback: compare by player name if not currently in vehicle
			for _, r in ipairs(UVRace_RacerList) do
				-- if r.name == ply:Nick() and (r.status == "Invited" or r.status == "Accepted") then
				if r.name == ply:Nick() and r.status == "Accepted" then
					return true
				end
			end

			return false
		end

		if not ShouldShowRacerHUD() then return end

		local h, w = ScrH(), ScrW()

		local alpha = 255

		surface.SetDrawColor(0, 0, 0, alpha)
		surface.SetMaterial( UVMaterials["BACKGROUND_CARBON_FILLED"] )
		surface.DrawTexturedRect(w - w * 0.3, h * 0.05, w * 0.3, h * (0.03 * 3))

		draw.SimpleTextOutlined( "#uv.prerace.details", "UVFont5UI", w * 0.99, h * 0.065, Color(255, 255, 0, alpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, alpha) )

		draw.SimpleTextOutlined( UVRace_CurrentTrackName, "UVFont5Shadow", w * 0.99, h * 0.095, Color(255, 255, 255, alpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, alpha) )
		
		draw.SimpleTextOutlined( string.format( language.GetPhrase("uv.race.invite.host"), UVRace_CurrentTrackHost ), "UVFont5Shadow", w * 0.99, h * 0.1225, Color(255, 255, 255, alpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, alpha) )

		local debuglineamount = 24
		local cardW, cardH = w * 0.15, h * 0.0325
		local cardsPerColumn = 12
		local spacing = 2
		
		if UVRace_RacerList and #UVRace_RacerList > 0 then
			for i, racer in ipairs(UVRace_RacerList) do
				local statusstr = "#uv.race.invite.status.invited"
				local clr = Color(200,200,200, alpha)
				local racername = racer.name
				local vehname = racer.vehiclename or "NIL"

				vehname = vehname and string.Trim(language.GetPhrase(vehname), "#") or nil

				if racer.status == "Host" then 
					clr = Color(255,255,0, alpha)
					statusstr = "#uv.race.invite.status.host"
				elseif racer.status == "Accepted" then 
					clr = Color(100,255,100, alpha)
					statusstr = "#uv.race.invite.status.accepted"
				elseif racer.status == "Declined" or racer.status == "Disqualified" then 
					clr = Color(255,100,100, alpha)
					statusstr = "#uv.race.invite.status.declined"
				end
				
				local col = math.floor((i - 1) / cardsPerColumn)
				local row = (i - 1) % cardsPerColumn

				local x = w - (cardW + spacing) * (col + 1)
				local y = h * 0.145 + (cardH + spacing) * row

				surface.SetDrawColor(0, 0, 0, 200)
				surface.DrawRect(x, y, cardW, cardH)
				
				if #racername > 20 then -- If standard racer name is too long, shorten it
					racername = string.sub(racername, 1, 23 - 3) .. "..."
				end

				if racer.isAI then -- AI gets a tag regardless
					racername = racername .. " (AI)"
				end

				if #vehname > 35 then -- If vehicle name is too long, shorten it
					vehname = string.sub(vehname, 1, 37 - 3) .. "..."
				end
					
				draw.SimpleText(statusstr, "UVMostWantedLeaderboardFont2", x + (w * 0.145), y, clr, TEXT_ALIGN_RIGHT)
				draw.SimpleText(racername, "UVMostWantedLeaderboardFont2", x + (w * 0.001), y, Color(255,255,255), TEXT_ALIGN_LEFT)
				draw.SimpleText(vehname or "...", "UVMostWantedLeaderboardFont2", x + (w * 0.001), y + 15, Color(200,200,200), TEXT_ALIGN_LEFT)
			end
		end
	end)

	hook.Add("PostRenderVGUI", "UVRaceCinematicOverlayTop", function()
		if not UVRaceCinematicOverlay then return end -- If the overlay isn't active
		if gui.IsGameUIVisible() then return end -- If game ESC menu is opened
		if not GetConVar("cl_drawhud"):GetBool() then return end
		if not GetConVar("unitvehicle_preraceinfo"):GetBool() then return end
		
		local now = CurTime()
		local w, h = ScrW(), ScrH()
		local totalHeight = h * 0.125
		local totalWidth = w * 0.5
		local barHeight, barWidth, alpha = 0, 0, 0

		local state = UVRaceCinematicOverlay.state
		local elapsed = now - UVRaceCinematicOverlay.startTime

		local squarePadding = 8
		local squareHeight = 32
		local extendTime = 0.3
		local retractTime = 0.2
		local font = "UVFont5"

		surface.SetFont(font)

		local squareTexts = {}

		-- Static title
		-- table.insert(squareTexts, language.GetPhrase("uv.prerace.details"))

		-- Track name and author
		if UVRace_CurrentTrackName then
			table.insert(squareTexts, string.format(
				language.GetPhrase("uv.prerace.name"),
				-- UVRace_CurrentTrackName .. " | " .. UVRace_CurrentTrackAuthor
				UVRace_CurrentTrackName
			))
		end

		-- Conditionally add "laps"
		local laps = UVHUDRaceInfo and UVHUDRaceInfo['Info'].Laps
		if laps and tonumber(laps) and laps >= 2 then
			table.insert(squareTexts, string.format(
				language.GetPhrase("uv.prerace.laps"),
				laps
			))
		end

		-- Checkpoints
		table.insert(squareTexts, string.format(
			language.GetPhrase("uv.prerace.checks"),
			GetGlobalInt("uvrace_checkpoints") or "???"
		))

		-- Starting position
		table.insert(squareTexts, string.format(
			language.GetPhrase("uv.prerace.startpos"),
			language.GetPhrase("uv.race.pos.num." .. UVHUDRaceCurrentPos)
		))
		
		-- Participant List (NOT WORKING)
		-- table.insert(squareTexts, string.format(
			-- language.GetPhrase("uv.prerace.participants"),
			-- "UNKNOWN"
		-- ))
		
		-- Best Lap (NOT WORKING)
		-- table.insert(squareTexts, string.format(
			-- language.GetPhrase("uv.prerace.bestlap"),
			-- "--:--.---", -- Time
			-- "---" -- Holder
		-- ))

		if not UVRaceCinematicOverlay.squares then
			UVRaceCinematicOverlay.squares = {}
			for i, text in ipairs(squareTexts) do
				local textW, _ = surface.GetTextSize(text)
				table.insert(UVRaceCinematicOverlay.squares, {
					text = text,
					width = textW + 24, -- padding inside
					startTime = UVRaceCinematicOverlay.startTime + UVRaceCinematicOverlay.slideInDuration + (i - 1) * extendTime,
					progress = 0,
					done = false
				})
			end
		end

		-- Bar Animations
		if state == "slidingIn" then
			local frac = math.Clamp(elapsed / UVRaceCinematicOverlay.slideInDuration, 0, 1)
			barHeight = Lerp(frac, 0, totalHeight)
			barWidth = Lerp(frac, 0, totalWidth)
			alpha = Lerp(frac, 0, 255)

			if frac >= 1 then
				UVRaceCinematicOverlay.state = "holding"
				UVRaceCinematicOverlay.holdStartTime = now
			end

		elseif state == "holding" then
			barHeight = totalHeight
			barWidth = totalWidth
			alpha = 255

			if UVRaceCountdown and UVRaceCountdown.stage == 4 then
				UVRaceCinematicOverlay.state = "slidingOut"
				UVRaceCinematicOverlay.outStartTime = now
				UVRaceCinematicOverlay.retractStart = now
			end

		elseif state == "slidingOut" then
			local frac = math.Clamp((now - UVRaceCinematicOverlay.outStartTime) / UVRaceCinematicOverlay.slideOutDuration, 0, 1)
			barHeight = Lerp(frac, totalHeight, 0)
			barWidth = Lerp(frac, totalWidth, 0)
			alpha = Lerp(frac, 255, 0)

			if frac >= 1 then
				UVRaceCinematicOverlay = nil
				return
			end
		end

		-- Draw black bars
		surface.SetDrawColor(0, 0, 0, alpha)
		
		surface.DrawRect(0, 0, w, barHeight)
		surface.DrawRect(0, h - barHeight, w, barHeight)
		
		surface.SetMaterial( UVMaterials["BACKGROUND_CARBON_FILLED_INVERTED"] )
		surface.DrawTexturedRect(0, h * 0.15, barWidth, h * 0.05 + ((h * 0.04) * #UVRaceCinematicOverlay.squares))
				
		if UVHUDRaceInfo and UVHUDRaceInfo.Participants and table.Count(UVHUDRaceInfo.Participants) > 1 then
			local participants = UVHUDRaceInfo.Participants
			local numParticipants = table.Count(participants)
			local numParticipantsCapped = math.min(numParticipants, 16)
			local partX = w * 0.455
			local partY = h * 0.215
			local partlineSpacing = h * 0.04

			surface.SetMaterial( UVMaterials["BACKGROUND_CARBON_FILLED"] )
			surface.DrawTexturedRect(w - barWidth, h * 0.15, barWidth, h * 0.05 + ((h * 0.04) * numParticipantsCapped))
			
			draw.SimpleTextOutlined( string.format( language.GetPhrase("uv.prerace.participants"), numParticipants ), font, w - barWidth + partX, h * 0.175, Color(255, 255, 0, alpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, alpha) )

			local i = 1
			local sorted, leaderboard = UVFormLeaderboard(UVHUDRaceInfo.Participants)
			for i, v in ipairs(sorted) do
				if i > 15 then 
					draw.SimpleTextOutlined( " ... ", font, w - barWidth + partX - (w * 0.025), partY, Color(255, 255, 255, alpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, alpha) )
					break
				end

				local array = v.array
				local displayName = array.Name
				if array.IsAI then
					displayName = displayName .. " (AI)"
				end

				draw.SimpleTextOutlined( displayName .. " | ", font, w - barWidth + partX, partY, Color(255, 255, 255, alpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, alpha) )
				
				draw.SimpleTextOutlined(i, font, w - barWidth + partX, partY, Color(255, 255, 255, alpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, alpha) )
				partY = partY + partlineSpacing
				i = i + 1
			end
		end
		
		-- Draw Detail Text
		if state ~= "slidingOut" and UVRaceCinematicOverlay.squares then
			draw.SimpleTextOutlined( game.GetMap(), font, w * 0.95, barHeight - (h * 0.05), Color(255, 255, 255, alpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1.25, Color(0, 0, 0, alpha) )
		end

		-- Draw "Starts in" Text + Timer
		if state ~= "slidingOut" and UVRaceCinematicOverlay.squares then
			draw.SimpleTextOutlined( "#uv.race.startsin", font, w * 0.5, h - barHeight + (h * 0.025), Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1.25, Color(0, 0, 0, alpha) )
			if UVRaceCountdown then
				draw.SimpleTextOutlined(UVRaceCountdown.label, font, w * 0.5, h - barHeight + (h * 0.065), Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1.25, Color( 0, 0, 0, alpha ) )
			end
		end

		-- Draw Square Info, simplified version
		if UVRaceCinematicOverlay.squares then
			local baseX = w * 0.485
			local baseY = h * 0.215
			local lineSpacing = h * 0.04
			
			draw.SimpleTextOutlined( "#uv.prerace.details", font, barWidth - baseX, h * 0.175, Color(255, 255, 0, alpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, alpha) )

			for i, square in ipairs(UVRaceCinematicOverlay.squares) do
				draw.SimpleTextOutlined( square.text, font, barWidth - baseX, baseY, Color(255, 255, 255, alpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, alpha) )
				baseY = baseY + lineSpacing
			end
		end
		
		-- Draw Square Info
		-- if UVRaceCinematicOverlay.squares then
			-- local baseX = w * 0.05
			-- local baseY = h - barHeight - (h * 0.035)
			
			-- local totalHeight = (#UVRaceCinematicOverlay.squares * (squareHeight + squarePadding)) - squarePadding
			-- local adjustedBaseY = baseY - (h*0.03 * #UVRaceCinematicOverlay.squares)

			-- for i, square in ipairs(UVRaceCinematicOverlay.squares) do
				-- draw.SimpleTextOutlined( square.text, font, baseX, adjustedBaseY + squareHeight / 2, Color(255, 255, 255, alpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, alpha) )
				-- adjustedBaseY = adjustedBaseY + squareHeight + squarePadding
			-- end

			-- local adjustedBaseY = baseY - (h*0.03 * #UVRaceCinematicOverlay.squares)
			
			-- for i, square in ipairs(UVRaceCinematicOverlay.squares) do
				-- local sqAlpha = alpha
				-- local sqProgress

				-- if state == "holding" then
					-- local timeSinceStart = now - square.startTime
					-- sqProgress = math.Clamp(timeSinceStart / extendTime, 0, 1)

					-- if sqProgress >= 1 then
						-- square.done = true
					-- end

				-- elseif state == "slidingOut" then
					-- local retractElapsed = now - (UVRaceCinematicOverlay.retractStart or now)
					-- sqProgress = 1 - math.Clamp(retractElapsed / retractTime, 0, 1)
				-- else
					-- sqProgress = square.done and 1 or 0
				-- end

				-- local drawWidth = square.width * sqProgress

				-- surface.SetDrawColor(0, 0, 0, sqAlpha)
				-- surface.DrawRect(baseX, adjustedBaseY, drawWidth, squareHeight + (h * 0.0075))

				-- local clippedText = string.sub(square.text, 1, math.floor(#square.text * sqProgress)) -- Draw text with clipping based on progress
				-- draw.SimpleTextOutlined( clippedText, font, baseX, adjustedBaseY + squareHeight / 2, Color(255, 255, 255, sqAlpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, sqAlpha) )

				-- adjustedBaseY = adjustedBaseY + squareHeight + squarePadding
			-- end
		-- end
	end)
end