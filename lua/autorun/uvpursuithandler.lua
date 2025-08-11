AddCSLuaFile()

MAX_HEAT_LEVEL = 10 -- You could theoretically change this :)

local dvd = DecentVehicleDestination

-- wait a few seconds :^)
timer.Simple(5, function()
	physenv.SetPerformanceSettings(
		{
			['MaxVelocity'] = 99999, ['MaxAngularVelocity'] = 99999
		}
	)
	RunConsoleCommand("sv_crazyphysics_defuse", 0)
	RunConsoleCommand("sv_crazyphysics_remove", 0)
end)

--Sound--
local UVSoundSource
local UVSoundLoop
local UVSoundMiscSource
local UVLoadedSounds

local PURSUIT_MUSIC_FILEPATH = "uvpursuitmusic"

local showhud = GetConVar("cl_drawhud")

local SpawnCooldownTable = {}

PT_Slots_Replacement_Strings = {
	[1] = "#uv.ptech.slot.right",
	[2] = "#uv.ptech.slot.left"
}

local Control_Strings = {
	[1] = "#uv.ptech.slot.left",
	[2] = "#uv.ptech.slot.right",
	[3] = "#uv.settings.music.skipsong",
	[4] = "#uv.settings.race.resetposition",
	[5] = "#uv.settings.race.showresults"
}

local Colors = {
	['Yellow'] = Color(255, 255, 0),
	['White'] = Color(255, 255, 255),
	['RacerTheme'] = Color(255, 221, 142, 107),
	['RacerThemeShade'] = Color(166, 142, 85, 107),
	['CopTheme'] = Color(61, 184, 255, 107),--Color(148, 142, 255, 107),
	['CopThemeShade'] = Color(41, 149, 212, 107)--Color(93, 85, 166, 107)
}

PursuitTable = {
	['InPursuit'] = false,
	['InCooldown'] = false,
	['IsEvading'] = false,
	['PursuitStart'] = 0,
	['Heat'] = 1,
	['UnitsChasing'] = 0,
	['ResourcePoints'] = 0,
	['Deploys'] = 0,
	['PursuitLength'] = 0,
	['Wrecks'] = 0,
	['Tags'] = 0,
	['Bounty'] = 0,
	['CommanderActive'] = false,
	['CommanderEntity'] = nil
	--['ChasedVehicles'] = {},
}

function UVGetDriver(vehicle)
	if not IsValid(vehicle) then return nil end

	if vehicle.IsSimfphyscar or vehicle:GetClass() == "prop_vehicle_jeep" then
		return vehicle:GetDriver()
	elseif vehicle.IsGlideVehicle then
		if not vehicle.seats or next(vehicle.seats) == nil then return nil end

		local seat = vehicle.seats[1]

		if IsValid( seat ) then
			local driver = seat:GetDriver()
			return (IsValid(driver) and driver) or nil
		end
	end

	return nil
end

function UVGetDriverName(vehicle)
	local driver = UVGetDriver(vehicle)
    local driverName = IsValid(driver) and driver:GetName()

    if not driverName then
        driverName = (vehicle.UnitVehicle and vehicle.UnitVehicle.callsign) or vehicle.racer or 'Racer ' .. vehicle:EntIndex()
    end

	return driverName
end

--Sound spam check--

function UVDelaySound()
	if UVSoundDelayed then return end
	UVSoundDelayed = true
	timer.Simple(1, function()
		UVSoundDelayed = false
	end)
end

local PursuitFilePathsTable = {}

function PopulatePursuitFilePaths( theme )
	if PursuitFilePathsTable[theme] then return end
	PursuitFilePathsTable[theme] = {}

	local path = PURSUIT_MUSIC_FILEPATH .. "/" .. theme .. "/"
	
	local function scanFolderRecursive(basePath, tbl)
		local _, folders = file.Find( "sound/" .. basePath .. "*", "GAME")
		for _, folder in pairs(folders) do
			if folder ~= "." and folder ~= ".." then
				local subfolderPath = basePath .. folder .. "/"
				local files2, folders2 = file.Find("sound/" .. subfolderPath .. "*", "GAME")

				if not tbl[folder] then
					tbl[folder] = {}
				end

				if #folders2 == 0 then
					for _, v in pairs( files2 ) do
						table.insert(tbl[folder], subfolderPath .. v)
					end
				else
					for _, v in pairs( folders2 ) do
						tbl[folder][v] = {}
					end
				end

				-- for _, folderName in pairs(folders) do
				-- 	local filePath = subfolderPath .. fileName
				-- 	if not file.IsDir(filePath, "GAME") then
				-- 		table.insert(tbl[folder], filePath)
				-- 	end
				-- end

				-- Recursively scan subfolders
				scanFolderRecursive(subfolderPath, tbl[folder])
			end
		end
	end

	scanFolderRecursive(path, PursuitFilePathsTable[theme])
	-- local introFiles = file.Find(path .. "intro/*", "GAME")
	-- if introFiles and #introFiles > 0 then
	-- 	PursuitFilePathsTable[theme].intro = {}
	-- 	for _, v in ipairs(introFiles) do
	-- 		PursuitFilePathsTable[theme].intro[#PursuitFilePathsTable[theme].intro + 1] = path .. "intro/" .. v	
	-- 	end
	-- end

	-- local transitionFiles = file.Find(path .. "transition/*", "GAME")
	-- if transitionFiles and #transitionFiles > 0 then
	-- 	PursuitFilePathsTable[theme].transition = {}
	-- 	for _, v in ipairs(transitionFiles) do
	-- 		PursuitFilePathsTable[theme].transition[#PursuitFilePathsTable[theme].transition + 1] = path .. "transition/" .. v	
	-- 	end
	-- end

	-- local heatFiles = file.Find(path .. "heat/*", "GAME")
	-- if heatFiles and #heatFiles > 0 then
	-- 	PursuitFilePathsTable[theme].heat = {}
	-- 	for _, v in ipairs(heatFiles) do
	-- 		PursuitFilePathsTable[theme].heat[#PursuitFilePathsTable[theme].heat + 1] = path .. "heat/" .. v	
	-- 	end
	-- end

	-- local bustedFiles = file.Find(path .. "busted/*", "GAME")
	-- if bustedFiles and #bustedFiles > 0 then
	-- 	PursuitFilePathsTable[theme].busted = {}
	-- 	for _, v in ipairs(bustedFiles) do
	-- 		PursuitFilePathsTable[theme].busted[#PursuitFilePathsTable[theme].busted + 1] = path .. "busted/" .. v	
	-- 	end
	-- end

	-- local escapedFiles = file.Find(path .. "escaped/*", "GAME")
	-- if escapedFiles and #escapedFiles > 0 then
	-- 	PursuitFilePathsTable[theme].escaped = {}
	-- 	for _, v in ipairs(escapedFiles) do
	-- 		PursuitFilePathsTable[theme].escaped[#PursuitFilePathsTable[theme].escaped + 1] = path .. "escaped/" .. v	
	-- 	end
	-- end

	return PursuitFilePathsTable[theme]
end
--print("hhahahaha")

function UVSoundHeat(heatlevel)
	if not PlayMusic:GetBool() then return end
	if RacingMusicPriority:GetBool() and RacingMusic:GetBool() and UVHUDDisplayRacing then return end
	if RacingThemeOutsideRace:GetBool() then UVSoundRacing() return end	
	if UVPlayingHeat or UVSoundDelayed then return end

	if timer.Exists("UVPursuitThemeReplay") then
		timer.Remove("UVPursuitThemeReplay")
	end

	heatlevel = heatlevel or 1

	if PursuitThemePlayRandomHeat:GetBool() then
		heatlevel = math.random( 1, MAX_HEAT_LEVEL )
	end

	heatlevel = tostring(heatlevel)

	local theme = PursuitTheme:GetString()

	local soundtable

	-- if UVHeatLevelIncrease then
	-- 	UVPlayingHeat = false
	-- 	soundtable = file.Find("sound/uvpursuitmusic/" .. theme .. "/transition/*", "GAME")

	-- 	-- Only play if folder exists and has sound files
	-- 	if soundtable and #soundtable > 0 then
	-- 		UVPlaySound("uvpursuitmusic/" .. theme .. "/transition/" .. soundtable[math.random(1, #soundtable)], false)
	-- 	end
	-- else
	-- 	UVPlayingHeat = true
	-- 	soundtable = file.Find("sound/uvpursuitmusic/" .. theme .. "/" .. heat .. "/*", "GAME")

	-- 	-- Fallback to heat1 if the desired heat folder is missing or empty
	-- 	if not soundtable or #soundtable == 0 then
	-- 		soundtable = file.Find("sound/uvpursuitmusic/" .. theme .. "/heat1/*", "GAME")
	-- 		if soundtable and #soundtable > 0 then
	-- 			UVPlaySound("uvpursuitmusic/" .. theme .. "/heat1/" .. soundtable[math.random(1, #soundtable)], true)
	-- 		end
	-- 	else
	-- 		UVPlaySound("uvpursuitmusic/" .. theme .. "/" .. heat .. "/" .. soundtable[math.random(1, #soundtable)], true)
	-- 	end
	-- end

	if not PursuitFilePathsTable[theme] then
		PopulatePursuitFilePaths(theme)
	end

	if UVHeatLevelIncrease then
		UVHeatPlayIntro = true
	end

	if UVHeatPlayIntro then
		UVHeatPlayIntro = false
		UVHeatPlayMusic = true

		--local introArray = (PursuitFilePathsTable[theme].intro and PursuitFilePathsTable[theme].intro[heatlevel]) or {}
		local introArray = (PursuitFilePathsTable[theme].intro and (PursuitFilePathsTable[theme].intro[heatlevel] or PursuitFilePathsTable[theme].intro["6"]))

		if introArray and #introArray > 0 then
			local introTrack = introArray[math.random(1, #introArray)]

			if introTrack then
				UVPlaySound(introTrack, true)
				UVPlayingHeat = true
			end
		end

		-- local introTrack = UVGetRandomSound( PURSUIT_MUSIC_FILEPATH .. "/" .. theme .. "/intro/" .. heatlevel )
		-- if introTrack then
		-- 	UVPlaySound(introTrack, true)
		-- 	UVPlayingHeat = true
		-- end
	elseif UVHeatPlayTransition then
		UVHeatPlayTransition = false

		--local transitionArray = (PursuitFilePathsTable[theme].transition and PursuitFilePathsTable[theme].transition[heatlevel]) or {}
		local transitionArray = PursuitFilePathsTable[theme].transition and (PursuitFilePathsTable[theme].transition[heatlevel] or PursuitFilePathsTable[theme].transition["6"]) or {}

		if transitionArray and #transitionArray > 0 then
			local transitionTrack = transitionArray[math.random(1, #transitionArray)]

			if transitionTrack then
				UVPlaySound(transitionTrack, true)
				UVPlayingHeat = true
			end
		end
		-- local transitionTrack = UVGetRandomSound( PURSUIT_MUSIC_FILEPATH .. "/" .. theme .. "/transition/" .. heatlevel )
		-- if transitionTrack then
		-- 	UVPlaySound(transitionTrack, true)
		-- 	UVPlayingHeat = true
		-- end
	elseif UVHeatPlayMusic then
		-- local musicTrack = UVGetRandomSound( PURSUIT_MUSIC_FILEPATH .. "/" .. theme .. "/heat/" .. heatlevel ) or UVGetRandomSound( PURSUIT_MUSIC_FILEPATH .. "/" .. theme .. "/heat/5" )
		-- if musicTrack then
		-- 	UVPlaySound(musicTrack, true)
		-- 	UVPlayingHeat = true
		-- end

		--local heatArray = (PursuitFilePathsTable[theme].heat and PursuitFilePathsTable[theme].heat[heatlevel]) or {}
		local heatArray = PursuitFilePathsTable[theme].heat and (PursuitFilePathsTable[theme].heat[heatlevel] or PursuitFilePathsTable[theme].heat["6"]) or {}

		if heatArray and #heatArray > 0 then
			local heatTrack = heatArray[math.random(1, #heatArray)]

			if heatTrack then
				UVPlaySound(heatTrack, true)
				UVPlayingHeat = true
			end
		end
	end

	UVPlayingRace = false
	-- UVPlayingHeat is handled above
	UVPlayingBusting = false
	UVPlayingCooldown = false
	UVPlayingBusted = false
	UVPlayingEscaped = false
end

function UVSoundBusting(heatlevel)
	if not PlayMusic:GetBool() then return end
	if RacingMusicPriority:GetBool() and RacingMusic:GetBool() and UVHUDDisplayRacing then return end
	if RacingThemeOutsideRace:GetBool() then UVSoundRacing() return end	
	if UVPlayingBusting or UVSoundDelayed then return end

	if timer.Exists("UVPursuitThemeReplay") then
		timer.Remove("UVPursuitThemeReplay")
	end

	local theme = PursuitTheme:GetString()
	--local soundtable = file.Find("sound/uvpursuitmusic/" .. theme .. "/busting/*", "GAME")

	-- if not soundtable or #soundtable == 0 then UVSoundHeat( UVHeatLevel ) return end

	-- UVPlaySound("uvpursuitmusic/" .. theme .. "/busting/" .. soundtable[math.random(1, #soundtable)], true)

	heatlevel = heatlevel or 1

	if not PursuitFilePathsTable[theme] then
		PopulatePursuitFilePaths(theme)
	end

	if PursuitThemePlayRandomHeat:GetBool() then
		heatlevel = math.random( 1, MAX_HEAT_LEVEL )
	end

	heatlevel = tostring(heatlevel)


	-- local bustingSound = UVGetRandomSound( PURSUIT_MUSIC_FILEPATH .. "/" .. theme .. "/busting/" .. heatlevel ) or UVGetRandomSound( PURSUIT_MUSIC_FILEPATH .. "/" .. theme .. "/busting/5" )
	-- if bustingSound then
	-- 	UVPlaySound(bustingSound, true)
	-- else
	-- 	UVSoundHeat( UVHeatLevel )
	-- 	return
	-- end
	
	--local bustingArray = (PursuitFilePathsTable[theme].busting and PursuitFilePathsTable[theme].busting[heatlevel]) or {}
	local bustingArray = PursuitFilePathsTable[theme].busting and (PursuitFilePathsTable[theme].busting[heatlevel] or PursuitFilePathsTable[theme].busting["6"]) or {}

	if bustingArray and #bustingArray > 0 then
		local bustingTrack = bustingArray[math.random(1, #bustingArray)]

		if bustingTrack then
			UVPlaySound(bustingTrack, true)
		else
			UVSoundHeat( UVHeatLevel )
			return
		end
	else
		UVSoundHeat( UVHeatLevel )
		return
	end

	UVPlayingRace = false
	UVPlayingHeat = false
	UVPlayingBusting = true
	UVPlayingCooldown = false
	UVPlayingBusted = false
	UVPlayingEscaped = false
end

function UVSoundCooldown(heatlevel)
	if not PlayMusic:GetBool() then return end
	if RacingMusicPriority:GetBool() and RacingMusic:GetBool() and UVHUDDisplayRacing then return end
	if RacingThemeOutsideRace:GetBool() then UVSoundRacing() return end	
	if UVPlayingCooldown or UVSoundDelayed then return end

	if timer.Exists("UVPursuitThemeReplay") then
		timer.Remove("UVPursuitThemeReplay")
	end

	local theme = PursuitTheme:GetString()
	-- local soundtable = file.Find("sound/uvpursuitmusic/" .. theme .. "/cooldown/*", "GAME")

	-- if not soundtable or #soundtable == 0 then UVSoundHeat( UVHeatLevel ) return end

	-- UVPlaySound("uvpursuitmusic/" .. theme .. "/cooldown/" .. soundtable[math.random(1, #soundtable)], true)

	heatlevel = heatlevel or 1

	if not PursuitFilePathsTable[theme] then
		PopulatePursuitFilePaths(theme)
	end

	if PursuitThemePlayRandomHeat:GetBool() then
		heatlevel = math.random( 1, MAX_HEAT_LEVEL )
	end

	heatlevel = tostring(heatlevel)

	local appendingString = "low"

	local vehicle = LocalPlayer():GetVehicle()
	if vehicle then
		vehicle = vehicle:GetParent() or vehicle
	end

	appendingString = (vehicle and vehicle:GetVelocity():LengthSqr() > 500000) and "high" or "low"

	-- local cooldownSound = UVGetRandomSound( PURSUIT_MUSIC_FILEPATH .. "/" .. theme .. "/cooldown/" .. heatlevel .. appendingString ) or UVGetRandomSound( PURSUIT_MUSIC_FILEPATH .. "/" .. theme .. "/cooldown/5" .. appendingString )
	-- if cooldownSound then
	-- 	UVPlaySound(cooldownSound, true)
	-- else
	-- 	UVSoundHeat( UVHeatLevel )
	-- 	return
	-- end
	local cooldownArray = PursuitFilePathsTable[theme].cooldown and (PursuitFilePathsTable[theme].cooldown[heatlevel] or PursuitFilePathsTable[theme].cooldown["6"])
	cooldownArray = cooldownArray and cooldownArray[appendingString or 'low'] or {}

	if cooldownArray and #cooldownArray > 0 then
		local cooldownTrack = cooldownArray[math.random(1, #cooldownArray)]

		if cooldownTrack then
			UVPlaySound(cooldownTrack, true)
		else
			UVSoundHeat( UVHeatLevel )
			return
		end
	else
		UVSoundHeat( UVHeatLevel )
		return
	end

	UVPlayingRace = false
	UVPlayingHeat = false
	UVPlayingBusting = false
	UVPlayingCooldown = true
	UVPlayingBusted = false
	UVPlayingEscaped = false
end

function UVSoundBusted(heatlevel)
	if not PlayMusic:GetBool() then return end
	if UVPlayingBusted or UVSoundDelayed then return end

	if timer.Exists("UVPursuitThemeReplay") then
		timer.Remove("UVPursuitThemeReplay")
	end

	if UVSoundLoop then
		UVStopSound()
		UVLoadedSounds = nil
		UVSoundLoop:Stop()
		UVSoundLoop = nil
	end

	local theme = PursuitTheme:GetString()
	-- local soundtable = file.Find("sound/uvpursuitmusic/" .. theme .. "/busted/*", "GAME")

	-- if not soundtable or #soundtable == 0 then return end

	-- UVPlaySound("uvpursuitmusic/" .. theme .. "/busted/" .. soundtable[math.random(1, #soundtable)], false, true)

	heatlevel = heatlevel or 1

	if PursuitThemePlayRandomHeat:GetBool() then
		heatlevel = math.random( 1, MAX_HEAT_LEVEL )
	end

	heatlevel = tostring(heatlevel)

	if not PursuitFilePathsTable[theme] then
		PopulatePursuitFilePaths(theme)
	end

	-- local escapedSound = UVGetRandomSound( PURSUIT_MUSIC_FILEPATH .. "/" .. theme .. "/busted/" .. heatlevel ) or UVGetRandomSound( PURSUIT_MUSIC_FILEPATH .. "/" .. theme .. "/busted/1" )
	-- if escapedSound then
	-- 	UVPlaySound(escapedSound, false, true)
	-- else
	-- 	UVSoundHeat( UVHeatLevel )
	-- 	return
	-- end

	local bustedArray = PursuitFilePathsTable[theme].busted and (PursuitFilePathsTable[theme].busted[heatlevel] or PursuitFilePathsTable[theme].busted["6"]) or {}

	if bustedArray and #bustedArray > 0 then
		local bustedTrack = bustedArray[math.random(1, #bustedArray)]

		if bustedTrack then
			UVPlaySound(bustedTrack, false, true)
		else
			UVSoundHeat( UVHeatLevel )
			return
		end
	else
		UVSoundHeat( UVHeatLevel )
		return
	end

	UVPlayingRace = false
	UVPlayingHeat = false
	UVPlayingBusting = false
	UVPlayingCooldown = false
	UVPlayingBusted = true
	UVPlayingEscaped = true
end

function UVSoundEscaped(heatlevel)
	if not PlayMusic:GetBool() then return end
	if RacingMusicPriority:GetBool() and RacingMusic:GetBool() and UVHUDDisplayRacing then return end
	if RacingThemeOutsideRace:GetBool() then UVSoundRacing() return end	
	if UVPlayingEscaped or UVSoundDelayed then return end

	if timer.Exists("UVPursuitThemeReplay") then
		timer.Remove("UVPursuitThemeReplay")
	end

	if UVSoundLoop then
		UVSoundLoop:Stop()
		UVSoundLoop = nil
	end

	local theme = PursuitTheme:GetString()
	-- local soundtable = file.Find("sound/uvpursuitmusic/" .. theme .. "/escaped/*", "GAME")

	-- if not soundtable or #soundtable == 0 then return end

	-- UVPlaySound("uvpursuitmusic/" .. theme .. "/escaped/" .. soundtable[math.random(1, #soundtable)], false)
	heatlevel = heatlevel or 1

	if PursuitThemePlayRandomHeat:GetBool() then
		heatlevel = math.random( 1, MAX_HEAT_LEVEL )
	end

	heatlevel = tostring(heatlevel)

	if not PursuitFilePathsTable[theme] then
		PopulatePursuitFilePaths(theme)
	end

	-- local escapedSound = UVGetRandomSound( PURSUIT_MUSIC_FILEPATH .. "/" .. theme .. "/escaped/" .. heatlevel ) or UVGetRandomSound( PURSUIT_MUSIC_FILEPATH .. "/" .. theme .. "/escaped/1" )
	-- if escapedSound then
	-- 	UVPlaySound(escapedSound, false)
	-- else
	-- 	UVSoundHeat( UVHeatLevel )
	-- 	return
	-- end

	local escapedArray = PursuitFilePathsTable[theme].escaped and (PursuitFilePathsTable[theme].escaped[heatlevel] or PursuitFilePathsTable[theme].escaped["6"]) or {}

	if escapedArray and #escapedArray > 0 then
		local escapedTrack = escapedArray[math.random(1, #escapedArray)]

		if escapedTrack then
			UVPlaySound(escapedTrack, false)
		else
			UVSoundHeat( UVHeatLevel )
			return
		end
	else
		UVSoundHeat( UVHeatLevel )
		return
	end

	UVPlayingRace = false
	UVPlayingHeat = false
	UVPlayingBusting = false
	UVPlayingCooldown = false
	UVPlayingBusted = true
	UVPlayingEscaped = true
end

function UVPlaySound( FileName, Loop, StopLoop )
	if UVLoadedSounds ~= FileName then
		if Loop or StopLoop then
			if UVSoundLoop then
				UVSoundLoop:Stop()
				UVSoundLoop = nil
			end
		else
			if UVSoundSource then
				UVSoundSource:Stop()
				UVSoundSource = nil
			end
		end
	end 

	-- print(FileName)

	local snd
	local expectedEndTime

	if UVLoadedSounds ~= FileName or (not UVSoundLoop) then
		sound.PlayFile("sound/"..FileName, "noblock", function(source, err, errname)
			if IsValid(source) then
				if Loop then
					UVSoundLoop = source
					source:SetVolume(PursuitVolume:GetFloat())
				else
					UVSoundSource = source
				end

				source:EnableLooping(Loop)
				source:Play()

				local duration = source:GetLength()

				if duration > 0 then
					expectedEndTime = RealTime() + duration
				end

				snd = source
			end
		end)
	end

	local source = (Loop and UVSoundLoop) or UVSoundSource

	if source then
		expectedEndTime = expectedEndTime or RealTime() + source:GetLength()
	end

	UVLoadedSounds = FileName

	UVDelaySound()
	hook.Remove("Think", "CheckSoundFinished")

	hook.Add("Think", "CheckSoundFinished", function()
		if expectedEndTime then
			if RealTime() >= expectedEndTime then
				hook.Remove("Think", "CheckSoundFinished")

				-- if UVHUDDisplayBusting then
				-- 	UVSoundBusting(UVHeatLevel)
				-- 	return
				-- end

				UVStopSound()
			end
		end
	end)

	-- timer.Create("UVPursuitThemeReplay", duration, 1, function()
	-- 	if UVHUDDisplayBusting then
	-- 		UVSoundBusting()
	-- 		return
	-- 	end
	-- 	UVStopSound()
	-- end)
end

function UVStopSound()
	UVPlayingRace = false
	UVPlayingHeat = false
	UVPlayingBusting = false
	UVPlayingCooldown = false
	UVPlayingBusted = false
	UVPlayingEscaped = false
	UVSoundDelayed = false
end

function UVDisplayTime(time)
	time = time or 0
	local formattedtime
	local hours = math.floor( time / 3600 )
	if hours < 1 then
		formattedtime = string.FormattedTime( time, "%02i:%02i.%02i" )
	else --1 hour pursuit challenge completed
		formattedtime = hours..":"..string.FormattedTime( time, "%02i:%02i.%02i" )
	end
	return formattedtime
end

LOCAL_CONVARS = {
	["unitvehicle_heatlevels"] = 'integer',
	--["unitvehicle_pursuittheme"] = 'string',
	["unitvehicle_targetvehicletype"] = 'integer',
	["unitvehicle_detectionrange"] = 'integer',
	--["unitvehicle_playmusic"] = 'integer',
	["unitvehicle_neverevade"] = 'integer',
	["unitvehicle_bustedtimer"] = 'integer',
	["unitvehicle_canwreck"] = 'integer',
	["unitvehicle_chatter"] = 'integer',
	["unitvehicle_speedlimit"] = 'integer',
	["unitvehicle_autohealth"] = 'integer',
	["unitvehicle_minheatlevel"] = 'integer',
	["unitvehicle_maxheatlevel"] = 'integer',
	["unitvehicle_spikestripduration"] = 'integer',
	["unitvehicle_pathfinding"] = 'integer',
	["unitvehicle_vcmodelspriority"] = 'integer',
	["unitvehicle_callresponse"] = 'integer',
	["unitvehicle_chattertext"] = 'integer',
	["unitvehicle_enableheadlights"] = 'integer',
	["unitvehicle_relentless"] = 'integer',
	["unitvehicle_spawnmainunits"] = 'integer',
	["unitvehicle_dvwaypointspriority"] = 'integer',
	--["unitvehicle_pursuitthemeplayrandomheat"] = 'integer',
	["unitvehicle_repaircooldown"] = 'integer',
	["unitvehicle_repairrange"] = 'integer',
	["unitvehicle_racertags"] = 'integer',
	["unitvehicle_racerpursuittech"] = 'integer',
	["unitvehicle_racerfriendlyfire"] = 'integer',
	['unitvehicle_spawncooldown'] = 'integer'
}

HEAT_SETTINGS = {
	'bountytime',
	'timetillnextheat',
	'heatminimumbounty',
	'maxunits',
	'unitsavailable',
	'backuptimer',
	'cooldowntimer',
	'roadblocks',
	'helicopters'
}

HEAT_DEFAULTS = {
	['maxunits'] = {
		['1'] = 2,
		['2'] = 4,
		['3'] = 6,
		['4'] = 8,
		['5'] = 10,
		['6'] = 12
	},
	['bountytime'] = {
		['1'] = 1000,
		['2'] = 5000,
		['3'] = 10000,
		['4'] = 50000,
		['5'] = 100000,
		['6'] = 500000
	},
	['timetillnextheat'] = {
		['Enabled'] = 0,
		['1'] = 120,
		['2'] = 120,
		['3'] = 180,
		['4'] = 180,
		['5'] = 600
	},
	['heatminimumbounty'] = {
		['1'] = 120,
		['2'] = 120,
		['3'] = 120,
		['4'] = 120,
		['5'] = 120,
		['6'] = 120,
	},
	['unitsavailable'] = {
		['1'] = 120,
		['2'] = 120,
		['3'] = 120,
		['4'] = 120,
		['5'] = 120,
		['6'] = 120,
	},
	['backuptimer'] = {
		['1'] = 120,
		['2'] = 120,
		['3'] = 120,
		['4'] = 120,
		['5'] = 120,
		['6'] = 120,
	},
	['cooldowntimer'] = {
		['1'] = 120,
		['2'] = 120,
		['3'] = 120,
		['4'] = 120,
		['5'] = 120,
		['6'] = 120,
	},
	['roadblocks'] = {
		['1'] = 0,
		['2'] = 1,
		['3'] = 1,
		['4'] = 1,
		['5'] = 1,
		['6'] = 1,
	},
	['helicopters'] = {
		['1'] = 0,
		['2'] = 0,
		['3'] = 0,
		['4'] = 1,
		['5'] = 1,
		['6'] = 1,
	}
}

NETWORK_STRINGS = {
	"UV_SendPursuitTech"
}

if SERVER then

	--convars--
	HeatLevels = CreateConVar("unitvehicle_heatlevels", 1, {FCVAR_ARCHIVE}, "If set to 1, Heat Levels will increase from its minimum value to its maximum value during a pursuit." )
	TargetVehicleType = CreateConVar("unitvehicle_targetvehicletype", 1, {FCVAR_ARCHIVE}, "Unit Vehicles: 1 = All vehicles are targeted. 2 = Decent Vehicles are targeted only. 3 = Other vehicles besides Decent Vehicles are targeted.")
	DetectionRange = CreateConVar("unitvehicle_detectionrange", 30, {FCVAR_ARCHIVE}, "Unit Vehicles: Minimum spawning distance to the vehicle in studs when manually spawning Units. Use greater values if you have trouble spawning Units.")
	NeverEvade = CreateConVar("unitvehicle_neverevade", 0, {FCVAR_ARCHIVE}, "Unit Vehicles: If set to 1, you won't be able to evade the Unit Vehicles. Good luck.")
	BustedTimer = CreateConVar("unitvehicle_bustedtimer", 5, {FCVAR_ARCHIVE}, "Unit Vehicles: Time in seconds before the enemy gets busted. Set this to 0 to disable.")
	SpawnCooldown = CreateConVar("unitvehicle_spawncooldown", 30, {FCVAR_ARCHIVE}, "Unit Vehicles: Time in seconds before player units can spawn again. Set this to 0 to disable.")
	CanWreck = CreateConVar("unitvehicle_canwreck", 1, {FCVAR_ARCHIVE}, "Unit Vehicles: If set to 1, Unit Vehicles can crash out. Set this to 0 to disable.")
	Chatter = CreateConVar("unitvehicle_chatter", 1, {FCVAR_ARCHIVE}, "Unit Vehicles: If set to 1, Units' radio chatter can be heard.")
	SpeedLimit = CreateConVar("unitvehicle_speedlimit", 60, {FCVAR_ARCHIVE}, "Unit Vehicles: Speed limit in MPH for idle Units to enforce. Patrolling Units still enforces speed limits set on DV Waypoints. Set this to 0 to disable.")
	AutoHealth = CreateConVar("unitvehicle_autohealth", 0, {FCVAR_ARCHIVE}, "Unit Vehicles: If set to 1, all suspects will have unlimited vehicle health and your health as a suspect will be set according to your vehicle's mass.")
	MinHeatLevel = CreateConVar("unitvehicle_minheatlevel", 1, {FCVAR_ARCHIVE}, "Unit Vehicles: Sets the minimum Heat Level achievable during pursuits (1-6). Use high Heat Levels for more aggressive Units on your tail and vice versa.")
	MaxHeatLevel = CreateConVar("unitvehicle_maxheatlevel", 6, {FCVAR_ARCHIVE}, "Unit Vehicles: Sets the maximum Heat Level achievable during pursuits (1-6). Use low Heat Levels for less aggressive Units on your tail and vice versa.")
	SpikeStripDuration = CreateConVar("unitvehicle_spikestripduration", 20, {FCVAR_ARCHIVE}, "Unit Vehicle: Time in seconds before the tires gets reinflated after hitting the spikes. Set this to 0 to disable reinflating tires.")
	Pathfinding = CreateConVar("unitvehicle_pathfinding", 1, {FCVAR_ARCHIVE}, "Unit Vehicles: If set to 1, Units uses A* pathfinding algorithm on navmesh/Decent Vehicle Waypoints to navigate. Impacts computer performance.")
	VCModELSPriority = CreateConVar("unitvehicle_vcmodelspriority", 0, {FCVAR_ARCHIVE}, "Unit Vehicles: If set to 1, Units using base HL2 vehicles will attempt to use VCMod ELS over Photon if both are installed.")
	CallResponse = CreateConVar("unitvehicle_callresponse", 1, {FCVAR_ARCHIVE}, "Unit Vehicles: If set to 1, Units will spawn and respond to the location regarding various calls.")
	ChatterText = CreateConVar("unitvehicle_chattertext", 0, {FCVAR_ARCHIVE}, "Unit Vehicles: If set to 1, Units' radio chatter will be displayed in the chatbox instead.")
	Headlights = CreateConVar("unitvehicle_enableheadlights", 0, {FCVAR_ARCHIVE}, "Unit Vehicles: If set to 1, Units and Racer Vehicles will shine their headlights.")
	Relentless = CreateConVar("unitvehicle_relentless", 0, {FCVAR_ARCHIVE}, "Unit Vehicles: If set to 1, Units will ram the target more frequently.")
	SpawnMainUnits = CreateConVar("unitvehicle_spawnmainunits", 1, {FCVAR_ARCHIVE}, "Unit Vehicles: If set to 1, main AI Units (Patrol, Support, etc.) will spawn to patrol/chase.")
	DVWaypointsPriority = CreateConVar("unitvehicle_dvwaypointspriority", 0, {FCVAR_ARCHIVE}, "Unit Vehicles: If set to 1, Units will attempt to navigate on Decent Vehicle Waypoints FIRST instead of navmesh (if both are installed).")
	RepairCooldown = CreateConVar("unitvehicle_repaircooldown", 60, {FCVAR_ARCHIVE}, "Unit Vehicle: Time in seconds between each repair. Set this to 0 to make all repair shops a one-time use.")
	RepairRange = CreateConVar("unitvehicle_repairrange", 100, {FCVAR_ARCHIVE}, "Unit Vehicle: Distance in studs between the repair shop and the vehicle to repair.")
	RacerTags = CreateConVar("unitvehicle_racertags", 1, {FCVAR_ARCHIVE}, "Unit Vehicles: If set to 1, Racers and Commander Units will have name tags above their vehicles.")
	RacerPursuitTech = CreateConVar("unitvehicle_racerpursuittech", 1, {FCVAR_ARCHIVE}, "Unit Vehicles: If set to 1, Racers will spawn with pursuit tech (spike strips, ESF, etc.).")
	RacerFriendlyFire = CreateConVar("unitvehicle_racerfriendlyfire", 1, {FCVAR_ARCHIVE}, "Unit Vehicles: If set to 1, Racers will be able to attack eachother with Pursuit Tech.")	
	--unit convars
	UVUVehicleBase = CreateConVar("unitvehicle_unit_vehiclebase", 1, {FCVAR_ARCHIVE}, "\n1 = Default Vehicle Base (prop_vehicle_jeep)\n2 = simfphys\n3 = Glide")

	UVUCommanderEvade = CreateConVar("unitvehicle_unit_onecommanderevading", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "If enabled, will allow racers to escape while commander is on scene.")
	UVUOneCommander = CreateConVar("unitvehicle_unit_onecommander", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUOneCommanderHealth = CreateConVar("unitvehicle_unit_onecommanderhealth", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUCommanderRepair = CreateConVar("unitvehicle_unit_commanderrepair", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED},"Unit Vehicles: If set to 1, Commander Units can utilize the Repair Shop to repair themselves.")

	UVUPursuitTech = CreateConVar("unitvehicle_unit_pursuittech", 1, {FCVAR_ARCHIVE}, "Unit Vehicles: If set to 1, AI and player-controlled Unit Vehicles can use weapons (spike strips, ESF, EMP, etc.).")
	UVUPursuitTech_ESF = CreateConVar("unitvehicle_unit_pursuittech_esf", 1, {FCVAR_ARCHIVE}, "Unit Vehicles: If set to 1, AI and player-controlled Unit Vehicles can spawn with ESF.")
	UVUPursuitTech_Spikestrip = CreateConVar("unitvehicle_unit_pursuittech_spikestrip", 1, {FCVAR_ARCHIVE}, "Unit Vehicles: If set to 1, AI and player-controlled Unit Vehicles can spawn with spike strips.")
	UVUPursuitTech_Killswitch = CreateConVar("unitvehicle_unit_pursuittech_killswitch", 1, {FCVAR_ARCHIVE}, "Unit Vehicles: If set to 1, AI and player-controlled Unit Vehicles can spawn with killswitch.")
	UVUPursuitTech_RepairKit = CreateConVar("unitvehicle_unit_pursuittech_repairkit", 1, {FCVAR_ARCHIVE}, "Unit Vehicles: If set to 1, AI and player-controlled Unit Vehicles can spawn with repair kits.")


	UVUHelicopterModel = CreateConVar("unitvehicle_unit_helicoptermodel", 1, {FCVAR_ARCHIVE}, "\n1 = Most Wanted\n2 = Undercover\n3 = Hot Pursuit\n4 = No Limits\n5 = Payback")
	UVUHelicopterBarrels = CreateConVar("unitvehicle_unit_helicopterbarrels", 1, {FCVAR_ARCHIVE}, "1 = Barrels\n0 = No Barrels")
	UVUHelicopterSpikeStrip = CreateConVar("unitvehicle_unit_helicopterspikestrip", 1, {FCVAR_ARCHIVE}, "1 = Spike Strips\n0 = No Spike Strips")
	UVUHelicopterBusting = CreateConVar("unitvehicle_unit_helicopterbusting", 1, {FCVAR_ARCHIVE}, "1 = Helicopter can bust racers\n0 = Helicopter cannot bust racers")

	UVUBountyPatrol = CreateConVar("unitvehicle_unit_bountypatrol", 1000, {FCVAR_ARCHIVE})
	UVUBountySupport = CreateConVar("unitvehicle_unit_bountysupport", 5000, {FCVAR_ARCHIVE})
	UVUBountyPursuit = CreateConVar("unitvehicle_unit_bountypursuit", 10000, {FCVAR_ARCHIVE})
	UVUBountyInterceptor = CreateConVar("unitvehicle_unit_bountyinterceptor", 20000, {FCVAR_ARCHIVE})
	UVUBountyAir = CreateConVar("unitvehicle_unit_bountyair", 75000, {FCVAR_ARCHIVE})
	UVUBountySpecial = CreateConVar("unitvehicle_unit_bountyspecial", 25000, {FCVAR_ARCHIVE})
	UVUBountyCommander = CreateConVar("unitvehicle_unit_bountycommander", 100000, {FCVAR_ARCHIVE})
	UVUBountyRhino = CreateConVar("unitvehicle_unit_bountyrhino", 50000, {FCVAR_ARCHIVE})


	for i = 1, MAX_HEAT_LEVEL do
		local prevIterator = i - 1

		local timeTillNextHeatId = ((prevIterator == 0 and 'enabled') or prevIterator)

		for _, v in pairs( {'Patrol', 'Support', 'Pursuit', 'Interceptor', 'Special', 'Commander'} ) do
			local lowercaseUnit = string.lower( v )
			local conVarKey = string.format( 'units%s%s', lowercaseUnit, i )

			-------------------------------------------

			CreateConVar( "unitvehicle_unit_" .. conVarKey, "", {FCVAR_ARCHIVE})
		end

		-- roboboy hated him, so he decided to not assign him a "units" at the start of his key...
		-- poor guy, now he's lonely outside of the for loop : (
		CreateConVar( "unitvehicle_unit_rhinos" .. i, "", {FCVAR_ARCHIVE})

		for _, conVar in pairs( HEAT_SETTINGS ) do
			local conVarKey = conVar .. ((conVar == 'timetillnextheat' and timeTillNextHeatId) or i)
			local check = (conVar == "timetillnextheat")

			CreateConVar( "unitvehicle_unit_" .. conVarKey, HEAT_DEFAULTS[conVar][tostring( ( check and timeTillNextHeatId ) or i )] or 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
		end
	end

	UVUTimeTillNextHeatEnabled = GetConVar('unitvehicle_unit_timetillnextheatenabled')

	UVPTPTDuration = CreateConVar("unitvehicle_pursuittech_ptduration", 60, {FCVAR_ARCHIVE})
	UVPTESFDuration = CreateConVar("unitvehicle_pursuittech_esfduration", 10, {FCVAR_ARCHIVE})
	UVPTESFPower = CreateConVar("unitvehicle_pursuittech_esfpower", 2000000, {FCVAR_ARCHIVE})
	UVPTESFDamage = CreateConVar("unitvehicle_pursuittech_esfdamage", 0.2, {FCVAR_ARCHIVE})
	UVPTESFCommanderDamage = CreateConVar("unitvehicle_pursuittech_esfcommanderdamage", 0.1, {FCVAR_ARCHIVE})
	UVPTJammerDuration = CreateConVar("unitvehicle_pursuittech_jammerduration", 10, {FCVAR_ARCHIVE})
	UVPTShockwavePower = CreateConVar("unitvehicle_pursuittech_shockwavepower", 2000000, {FCVAR_ARCHIVE})
	UVPTShockwaveDamage = CreateConVar("unitvehicle_pursuittech_shockwavedamage", 0.1, {FCVAR_ARCHIVE})
	UVPTShockwaveCommanderDamage = CreateConVar("unitvehicle_pursuittech_shockwavecommanderdamage", 0.1, {FCVAR_ARCHIVE})
	UVPTSpikeStripDuration = CreateConVar("unitvehicle_pursuittech_spikestripduration", 60, {FCVAR_ARCHIVE})
	UVPTStunMinePower = CreateConVar("unitvehicle_pursuittech_stunminepower", 2000000, {FCVAR_ARCHIVE})
	UVPTStunMineCommanderDamage = CreateConVar("unitvehicle_pursuittech_stunminecommanderdamage", 0.1, {FCVAR_ARCHIVE})
	UVPTStunMineDamage = CreateConVar("unitvehicle_pursuittech_stunminedamage", 0.1, {FCVAR_ARCHIVE})


	UVPTESFMaxAmmo = CreateConVar("unitvehicle_pursuittech_maxammo_esf", 5, {FCVAR_ARCHIVE}, "Pursuit Tech Max Ammo")
	UVPTJammerMaxAmmo = CreateConVar("unitvehicle_pursuittech_maxammo_jammer", 5, {FCVAR_ARCHIVE}, "Pursuit Tech Max Ammo")
	UVPTShockwaveMaxAmmo = CreateConVar("unitvehicle_pursuittech_maxammo_shockwave", 5, {FCVAR_ARCHIVE}, "Pursuit Tech Max Ammo")
	UVPTSpikeStripMaxAmmo = CreateConVar("unitvehicle_pursuittech_maxammo_spikestrip", 5, {FCVAR_ARCHIVE}, "Pursuit Tech Max Ammo")
	UVPTStunMineMaxAmmo = CreateConVar("unitvehicle_pursuittech_maxammo_stunmine", 5, {FCVAR_ARCHIVE}, "Pursuit Tech Max Ammo")
	UVPTRepairKitMaxAmmo = CreateConVar("unitvehicle_pursuittech_maxammo_repairkit", 5, {FCVAR_ARCHIVE}, "Pursuit Tech Max Ammo")

	UVPTESFCooldown = CreateConVar("unitvehicle_pursuittech_cooldown_esf", 5, {FCVAR_ARCHIVE}, "Pursuit Tech Cooldown")
	UVPTJammerCooldown = CreateConVar("unitvehicle_pursuittech_cooldown_jammer", 5, {FCVAR_ARCHIVE}, "Pursuit Tech Cooldown")
	UVPTShockwaveCooldown = CreateConVar("unitvehicle_pursuittech_cooldown_shockwave", 5, {FCVAR_ARCHIVE}, "Pursuit Tech Cooldown")
	UVPTSpikeStripCooldown = CreateConVar("unitvehicle_pursuittech_cooldown_spikestrip", 5, {FCVAR_ARCHIVE}, "Pursuit Tech Cooldown")
	UVPTStunMineCooldown = CreateConVar("unitvehicle_pursuittech_cooldown_stunmine", 5, {FCVAR_ARCHIVE}, "Pursuit Tech Cooldown")
	UVPTRepairKitCooldown = CreateConVar("unitvehicle_pursuittech_cooldown_repairkit", 5, {FCVAR_ARCHIVE}, "Pursuit Tech Cooldown")

	UVUnitPTDuration = CreateConVar("unitvehicle_unitpursuittech_ptduration", 20, {FCVAR_ARCHIVE})
	UVUnitPTESFDuration = CreateConVar("unitvehicle_unitpursuittech_esfduration", 10, {FCVAR_ARCHIVE})
	UVUnitPTESFPower = CreateConVar("unitvehicle_unitpursuittech_esfpower", 2000000, {FCVAR_ARCHIVE})
	UVUnitPTESFDamage = CreateConVar("unitvehicle_unitpursuittech_esfdamage", 0.2, {FCVAR_ARCHIVE})
	UVUnitPTSpikeStripDuration = CreateConVar("unitvehicle_unitpursuittech_spikestripduration", 60, {FCVAR_ARCHIVE})
	UVUnitPTKillSwitchLockOnTime = CreateConVar("unitvehicle_unitpursuittech_killswitchlockontime", 3, {FCVAR_ARCHIVE})
	UVUnitPTKillSwitchDisableDuration = CreateConVar("unitvehicle_unitpursuittech_killswitchdisableduration", 2.5, {FCVAR_ARCHIVE})

	UVUnitPTESFMaxAmmo = CreateConVar("unitvehicle_unitpursuittech_maxammo_esf", 5, {FCVAR_ARCHIVE}, "Unit Pursuit Tech Max Ammo")
	UVUnitPTSpikeStripMaxAmmo = CreateConVar("unitvehicle_unitpursuittech_maxammo_spikestrip", 5, {FCVAR_ARCHIVE}, "Unit Pursuit Tech Max Ammo")
	UVUnitPTKillSwitchMaxAmmo = CreateConVar("unitvehicle_unitpursuittech_maxammo_killswitch", 5, {FCVAR_ARCHIVE}, "Unit Pursuit Tech Max Ammo")
	UVUnitPTRepairKitMaxAmmo = CreateConVar("unitvehicle_unitpursuittech_maxammo_repairkit", 5, {FCVAR_ARCHIVE}, "Unit Pursuit Tech Max Ammo")

	UVUnitPTESFCooldown = CreateConVar("unitvehicle_unitpursuittech_cooldown_esf", 5, {FCVAR_ARCHIVE}, "Unit Pursuit Tech Cooldown")
	UVUnitPTSpikeStripCooldown = CreateConVar("unitvehicle_unitpursuittech_cooldown_spikestrip", 5, {FCVAR_ARCHIVE}, "Unit Pursuit Tech Cooldown")
	UVUnitPTRepairKitCooldown = CreateConVar("unitvehicle_unitpursuittech_cooldown_repairkit", 5, {FCVAR_ARCHIVE}, "Unit Pursuit Tech Cooldown")
	UVUnitPTKillSwitchCooldown = CreateConVar("unitvehicle_unitpursuittech_cooldown_killswitch", 5, {FCVAR_ARCHIVE}, "Unit Pursuit Tech Cooldown")

	UVPBMax = CreateConVar("unitvehicle_pursuitbreaker_maxpb", 2, {FCVAR_ARCHIVE})
	UVPBCooldown = CreateConVar("unitvehicle_pursuitbreaker_pbcooldown", 60, {FCVAR_ARCHIVE})

	UVRBMax = CreateConVar("unitvehicle_roadblock_maxrb", 1, {FCVAR_ARCHIVE})
	UVRBOverride = CreateConVar("unitvehicle_roadblock_override", 0, {FCVAR_ARCHIVE})

	unitvehicles = true

	UVHUDPursuit = nil
	UVHUDBusting = nil
	UVHUDCooldown = nil

	PursuitTable = {
		['InPursuit'] = false,
		['InCooldown'] = false,
		['IsEvading'] = false,
		['PursuitStart'] = 0,
		['Heat'] = 1,
		['UnitsChasing'] = 0,
		['ResourcePoints'] = 0,
		['Deploys'] = 0,
		['PursuitLength'] = 0,
		['Wrecks'] = 0,
		['Tags'] = 0,
		['Bounty'] = 0,
		['CommanderActive'] = false,
		['CommanderEntity'] = nil
		--['ChasedVehicles'] = {},
	}

	--Enemies can't exit the vehicle during pursuits or races
	hook.Add("CanExitVehicle", "UVExitingVehicleWhlistInPursuit", function( veh, ply)
		local vehicle_entity = veh:GetParent()

		if UVTargeting then return false end
		if (IsValid(vehicle_entity) and vehicle_entity.uvraceparticipant) or veh.uvraceparticipant then return false end
		--return (not UVTargeting)
	end)

	--Damage to UVs
	hook.Add( "EntityTakeDamage", "UVDamage", function( target, dmginfo )
		if VC then return end
		if target.UVPatrol or target.UVSupport or target.UVPursuit or target.UVInterceptor or target.UVSpecial or target.UVCommander then
			local damage = (dmginfo:GetDamage()*10)
			target:SetHealth(target:Health()-damage)
		end
	end )

	hook.Add("PostCleanupMap", "UVCleanup", function()
		UVTargeting = nil
		UVResetStats()
		UVPresenceMode = false
		UVRacerPresenceMode = false
		UVCallLocation = nil
		uvcallexists = nil
		UVHiding = nil
		UVCommanderLastHealth = nil
		UVCommanderLastEngineHealth = nil
		UVCommanders = {}
		UVWantedTableDriver = {}
		UVPlayerUnitTablePlayers = {}
		UVJammerDeployed = nil
		UVPreInfractionCount = 0
		if next(UVLoadedPursuitBreakers) ~= nil then
			for k, v in pairs(UVLoadedPursuitBreakers) do
				net.Start("UVTriggerPursuitBreaker")
				net.WriteString(v)
				net.Broadcast()
			end
		end
		UVLoadedPursuitBreakers = {}
		UVLoadedPursuitBreakersLoc = {}
		UVLoadedRoadblocks = {}
		UVLoadedRoadblocksLoc = {}
		net.Start( "UVHUDStopCopMode" )
		net.Broadcast()
	end)

	function UpdatePursuitTable( key, value )
		-- done so serialization works
		if value == nil then value = false end

		if PursuitTable[key] ~= value then
			PursuitTable[key] = value

			-- We will be using WriteData as it seems more performant and optimized

			local serializedJson = util.TableToJSON( {[key] = value} )
			local compressedJson = util.Compress( serializedJson )
			local messageSize = #compressedJson

			net.Start( "UVSet_PursuitTable" )
			net.WriteUInt( messageSize, 16 )
			net.WriteData( compressedJson, messageSize )
			net.Broadcast()
		end
	end

	UVHeliCooldown = -math.huge
	UVCooldownTimer = 20
	UVCooldownTimerProgress = 0
	UVCooldownProgressTimeout = CurTime()
	UVBounty = 0
	UVHeatLevel = 1
	UVWrecks = 0
	UVDeploys = 0
	UVTags = 0
	UVRoadblocksDodged = 0
	UVSpikestripsDodged = 0
	UVComboBounty = 1
	UVBountyTimer = CurTime()
	UVBountyTimerProgress = 0
	UVBusting = CurTime()
	UVBustingProgress = CurTime()
	UVBustingLastProgress = CurTime()
	UVBustingLastProgress2 = 0
	UVLosing = CurTime()
	UVBackupTimer = CurTime()
	UVPreInfractionCount = 0
	UVPreInfractionCountCooldown = CurTime()
	UVUnitsChasing = {}
	UVWantedTableVehicle = {}
	UVWantedTableDriver = {}
	UVPotentialSuspects = {}
	UVResourcePoints = 10
	UVMaxUnits = 3
	UVTacticFormationNo = 1
	UVSimfphysVehicleInitializing = {}
	UVPlayerUnitTableVehicle = {}
	UVPlayerUnitTablePlayers = {}
	UVCommanders = {}
	UVRVWithPursuitTech = {}
	UVLoadedPursuitBreakers = {}
	UVLoadedPursuitBreakersLoc = {}
	UVLoadedRoadblocks = {}
	UVLoadedRoadblocksLoc = {}
	UVWreckedVehicles = {}
	UVUnitVehicles = {}

	--Think
	hook.Add("Think", "UVServerThink", function()
		--One Commander Active
		if UVOneCommanderActive then
			if not UVCommanderRespawning and (UVUOneCommander:GetInt() ~= 1 or next(UVCommanders) == nil) then
				UVOneCommanderActive = nil
				UVCommanderLastHealth = nil
				UVCommanderLastEngineHealth = nil
				net.Start("UVHUDStopOneCommander")
				net.Broadcast()
			end
			for k, v in pairs(UVCommanders) do
				if not IsValid(v) then
					table.RemoveByValue(UVCommanders, v)
				end
			end
		end

		if UVUOneCommander:GetInt() == 1 and next(UVCommanders) ~= nil then
			UVOneCommanderActive = true
			net.Start("UVHUDOneCommander")
			net.WriteEntity(UVCommanders[1])
			net.Broadcast()
		end

		--Bounty
		if not UVTargeting then
			UVBountyTimer = CurTime()
			UVHiding = nil
			if UVOneCommanderDeployed then
				if not UVOneCommanderActive then
					UVOneCommanderDeployed = nil
				end
			end
			if UVCommanderRespawning then
				UVCommanderRespawning = nil
			end
			if UVCommanderLastHealth then
				UVCommanderLastHealth = nil
				UVCommanderLastEngineHealth = nil
			end
		else
			if not UVEnemyEscaping then
				UVBountyTimerProgress = CurTime() - UVBountyTimer
				UVHiding = nil
			else
				UVBountyTimer = CurTime() - UVBountyTimerProgress
			end
		end

		local botimeout = 10
		if UVBountyTimerProgress >= botimeout then
			UVBounty = UVBounty+uvBountyTime
			UVBountyTimer = CurTime()
			if #UVLoadedPursuitBreakers < UVPBMax:GetInt() then
				UVAutoLoadPursuitBreaker()
			end
		end

		local ltimeout = (UVCooldownTimer+5)

		--Idle presence
		if not UVTargeting and (UVPresenceMode or UVRacerPresenceMode) and #ents.FindByClass("npc_uv*") < UVHeatLevel then
			local ply = Entity(1)

			if not ply then 
				return 
			end

			if uvIdleSpawning - CurTime() + 5 <= 0 then
				if SpawnMainUnits:GetBool() and UVPresenceMode then
					UVAutoSpawn(nil)
				end
				if UVRacerPresenceMode and #ents.FindByClass("npc_racervehicle") < UVHeatLevel then
					UVAutoSpawnRacer(ply)
				end
				uvIdleSpawning = CurTime()
			end
		end

		--Deploying backup
		if not UVTargeting or UVEnemyBusted or UVEnemyEscaped then
			UVBackupTimer = CurTime()
		end

		local backupTimeout = 2

		if backupTimeout then
			if CurTime() > UVBackupTimer + backupTimeout then
				if HeatLevels:GetBool() then
					UVUpdateHeatLevel()
				end
				if #UVUnitsChasing < 2 then
					UVTacticFormationNo = math.random(0,6)
				end
				UVChangeTactics(UVTacticFormationNo)
				UVBackupTimer = CurTime()
			end
		end

		--Actual backup timer
		if UVTargeting then
			if UVResourcePoints < UVMaxUnits then
				if not UVBackupUnderway then
					UVResourcePointsTimer = CurTime()
					UVResourcePointsTimerMax = UVBackupTimerMax
					UVBackupUnderway = true
					timer.Simple(1, function()
						local units = ents.FindByClass("npc_uv*")
						local random_entry = math.random(#units)
						local unit = units[random_entry]
						local uvchatter = math.random(1,10)
						if unit and Chatter:GetBool() and IsValid(unit.v) then
							UVChatterBackupOnTheWay(unit)
						end
					end)
				else
					net.Start( "UVHUDBackuptimer" )
					net.WriteString(UVResourcePointsTimerLeft)
					net.Broadcast()
				end

				if not UVResourcePointsTimerMax then
					UVResourcePointsTimerMax = UVBackupTimerMax
				end

				UVResourcePointsTimerLeft = (UVResourcePointsTimer - CurTime() + UVResourcePointsTimerMax)
				if UVResourcePointsTimerLeft <= 10 then
					if not UVBackupTenSeconds then
						UVBackupTenSeconds = true
						--Entity(1):EmitSound("ui/pursuit/backup/countdown_start.wav", 0, 100, 0.5, CHAN_STATIC)
						--Entity(1):EmitSound("ui/pursuit/backup/countdown_tick.wav", 0, 100, 0.5, CHAN_STATIC)
						UVRelaySoundToClients("ui/pursuit/backup/countdown_start.wav", false)
						UVRelaySoundToClients("ui/pursuit/backup/countdown_tick.wav", false)
						timer.Create( "UVBackupTenSecondsTick", 1, 9, function() 
							--Entity(1):EmitSound("ui/pursuit/backup/countdown_tick.wav", 0, 100, 0.5, CHAN_STATIC)
							UVRelaySoundToClients("ui/pursuit/backup/countdown_tick.wav", false)
						end)
						for i=6,9 do
							timer.Simple( i + 1, function()
								if i == 9 then
									UVRelaySoundToClients("ui/pursuit/backup/countdown_end.wav", false)
								else
									UVRelaySoundToClients("ui/pursuit/backup/countdown_".. 9 - i ..".wav", false)
								end
							end)
						end
					end
				else
					if UVBackupTenSeconds then
						UVBackupTenSeconds = nil
					end
				end
				if UVResourcePointsTimerLeft <= 0 and UVBackupUnderway then
					net.Start( "UVHUDStopBackupTimer" )
					net.Broadcast()
					UVResourcePointsTimer = CurTime()
					UVRestoreResourcePoints()
					--PrintMessage( HUD_PRINTCENTER, "REINFORCEMENTS INCOMING!")
					if next(ents.FindByClass("npc_uv*")) ~= nil then
						local units = ents.FindByClass("npc_uv*")
						local random_entry = math.random(#units)
						local unit = units[random_entry]
						local uvchatter = math.random(1,10)
						if Chatter:GetBool() and IsValid(unit.v) then
							UVChatterBackupOnScene(unit)
						end
					end
				end
			else
				if UVBackupUnderway then
					UVBackupUnderway = nil
					-- net.Start( "UVHUDStopBackupTimer" )
					-- net.Broadcast()
				end
				UVResourcePointsTimer = CurTime()
				-- net.Start( "UVHUDStopBackupTimer" )
				-- net.Broadcast()
			end
		end

		--Check if busting/hiding
		if next(UVWantedTableVehicle) ~= nil then
			for k, v in pairs(UVWantedTableVehicle) do
				if not v.UVBustingProgress then
					v.UVBustingProgress = 0
				end

				if not v.UVBustingLastProgress then 
					v.UVBustingLastProgress = CurTime()
				end

				if not v.UVBustingLastProgress2 then 
					v.UVBustingLastProgress2 = CurTime()
				end

				UVCheckIfBeingBusted(v)
			end
			if #UVWantedTableVehicle == 1 and UVEnemyEscaping then
				UVHiding = UVCheckIfHiding(UVWantedTableVehicle[1])
			end
		end

		if next(UVPotentialSuspects) ~= nil then
			for k, v in pairs(UVPotentialSuspects) do
				if UVTargeting and not table.HasValue(UVWantedTableVehicle, v) then
					UVAddToWantedListVehicle(v)
				end
			end
		end

		if next(UVSimfphysVehicleInitializing) ~= nil then
			for k, car in pairs(UVSimfphysVehicleInitializing) do
				if IsValid(car) and ((isfunction(car.IsInitialized) and car:IsInitialized()) or car.IsGlideVehicle or car:GetClass() == "prop_vehicle_jeep") then
					if car.uvclasstospawnon == "npc_uvpatrol" then
						car.playerbounty = UVUBountyPatrol:GetInt()
					elseif car.uvclasstospawnon == "npc_uvsupport" then
						car.playerbounty = UVUBountySupport:GetInt()
					elseif car.uvclasstospawnon == "npc_uvpursuit" then
						car.playerbounty = UVUBountyPursuit:GetInt()
					elseif car.uvclasstospawnon == "npc_uvinterceptor" then
						car.playerbounty = UVUBountyInterceptor:GetInt()
					elseif car.uvclasstospawnon == "npc_uvspecial" then
						car.playerbounty = UVUBountySpecial:GetInt()
					elseif car.uvclasstospawnon == "npc_uvcommander" then
						car.playerbounty = UVUBountyCommander:GetInt()
						local health = car.uvlasthealth or UVUOneCommanderHealth:GetInt()
						local enginehealth = car.uvlastenginehealth or 1.0
						if car.IsSimfphyscar then
							car:SetCurHealth(health)
						elseif car.IsGlideVehicle then
							car.MaxChassisHealth = UVUOneCommanderHealth:GetInt()
							car:SetChassisHealth( health )
							car:SetEngineHealth( enginehealth )
							car:UpdateHealthOutputs()
						elseif car:GetClass() == "prop_vehicle_jeep" then
							if vcmod_main then
								car:VC_setHealthMax(UVUOneCommanderHealth:GetInt())
								car:VC_setHealth(health)
							else
								car:SetMaxHealth(UVUOneCommanderHealth:GetInt())
								car:SetHealth(health)
							end
						end
						table.insert(UVCommanders, car)
						UVCommanderRespawning = nil
					end
					if not car.UnitVehicle then 
						local uv = ents.Create(car.uvclasstospawnon) 
						uv:SetPos(car:GetPos())
						uv.uvscripted = true
						uv.vehicle = car
						uv:Spawn()
						uv:Activate()
					else
						car.UnitVehicle.uvplayerlastvehicle = car
						if car.IsSimfphyscar then
							car.UnitVehicle:EnterVehicle( car.DriverSeat )
						elseif car.IsGlideVehicle then
							local seat = car.seats[1]
							if IsValid(seat) then
								car.UnitVehicle:EnterVehicle(seat)
							end
						elseif car:GetClass() == "prop_vehicle_jeep" then
							car.UnitVehicle:EnterVehicle(car)
						end
					end
					table.RemoveByValue(UVSimfphysVehicleInitializing, car)
				end
			end
		end

		local playerUnitActive = false

		--Player-controlled Unit Vehicles
		if next(UVPlayerUnitTableVehicle) ~= nil then
			for k, car in pairs(UVPlayerUnitTableVehicle) do

				if not table.HasValue(UVUnitVehicles, car) and car.UnitVehicle then
					table.insert(UVUnitVehicles, car)
				end

				if IsValid(car) and not car.wrecked and
					(car:Health() <= 0 and car:GetClass() == "prop_vehicle_jeep" or --No health 
						car.uvclasstospawnon ~= "npc_uvcommander" and CanWreck:GetBool() and car:GetPhysicsObject():GetAngles().z > 90 and car:GetPhysicsObject():GetAngles().z < 270 and car.rammed --[[or car:GetVelocity():LengthSqr() < 10000)]] or --Flipped
						car:WaterLevel() > 2 or --Underwater
						car:IsOnFire() or --On fire
						UVPlayerIsWrecked(car)) then --Other parameters
					UVPlayerWreck(car)
				end

				if UVGetDriver(car) and UVGetDriver(car):IsPlayer() then
					local driver = UVGetDriver(car)
					if car.PursuitTech then
						-- local status = car.PursuitTechStatus or "Ready"
						-- net.Start( "UVHUDPursuitTech" )
						-- net.WriteString(car.PursuitTech)
						-- net.WriteString(status)
						-- net.Send(driver)
						-- net.Start("UVHUDPursuitTech")
						-- net.WriteTable(car.PursuitTech)
						-- net.Broadcast()
					end

					playerUnitActive = true

					if not table.HasValue(UVPlayerUnitTablePlayers, driver) then
						table.insert(UVPlayerUnitTablePlayers, driver)
						driver.uvplayerlastvehicle = car
						hook.Add("CanExitVehicle", "UVPlayerExitUnitVehicle", function(vehicle, driver)
							if UVTargeting then return end
							if table.HasValue(UVPlayerUnitTablePlayers, driver) then
								table.RemoveByValue(UVPlayerUnitTablePlayers, driver)
								hook.Remove( "simfphysOnDestroyed", "UVExplosion"..car:EntIndex())
								UVDeactivateESF(car)
								net.Start( "UVHUDStopCopMode" )
								net.Send(driver)
							end
						end)
						hook.Add("PostPlayerDeath", "UVPlayerKilled", function(driver)
							if table.HasValue(UVPlayerUnitTablePlayers, driver) then
								table.RemoveByValue(UVPlayerUnitTablePlayers, driver)
								hook.Remove( "simfphysOnDestroyed", "UVExplosion"..car:EntIndex())
								UVDeactivateESF(car)
								net.Start( "UVHUDStopCopMode" )
								net.Send(driver)
							end
						end)
						hook.Add( "simfphysOnDestroyed", "UVExplosion"..car:EntIndex(), function(car, gib) 
							if table.HasValue(UVPlayerUnitTablePlayers, driver) then
								table.RemoveByValue(UVPlayerUnitTablePlayers, driver)
								hook.Remove( "simfphysOnDestroyed", "UVExplosion"..car:EntIndex())
								UVDeactivateESF(car)
								net.Start( "UVHUDStopCopMode" )
								net.Send(driver)
							end
							if (not car.UnitVehicle) or car.wrecked then return end
							if car.UnitVehicle:IsPlayer() then
								UVPlayerWreck(car)
							end
						end)
						net.Start( "UVHUDCopMode" )
						net.Send(driver)
					end
				end

				if car.uvkillswitching then
					UVKillSwitchCheck(car)
				end

				local suspects = UVWantedTableVehicle
				local closestsuspect = nil
				local closestdistancetosuspect = math.huge

				local visualrange = UVHiding and 1000000 or 25000000
				local visible_suspects = visible_suspects or {}

				for _, w in pairs(suspects) do
					if IsValid(w) then
						local enemypos = w:WorldSpaceCenter()
						local distance = enemypos:DistToSqr(car:WorldSpaceCenter())

						if distance < closestdistancetosuspect then
							closestdistancetosuspect = distance
							closestsuspect = w
						end

						local last_visible = w.inunitview or false
						local in_view = UVVisualOnTarget(car, w) and (car.uvplayerdistancetoenemy or math.huge) < visualrange

						w.inunitview = in_view
						if in_view then
							if not table.HasValue(visible_suspects, w) then
								table.insert(visible_suspects, w)
							end
						else
							if table.HasValue(visible_suspects, w) then
								table.RemoveByValue(visible_suspects, w)
							end
						end

						if last_visible ~= w.inunitview then
							net.Start("UVUpdateSuspectVisibility")
							net.WriteEntity(w)
							net.WriteBool(w.inunitview)
							net.Broadcast()
						end
					end
				end

				if IsValid(closestsuspect) then
					local is_vehicle =
						closestsuspect.IsSimfphyscar or
						closestsuspect.IsGlideVehicle or
						closestsuspect:GetClass() == "prop_vehicle_jeep"

					if is_vehicle then
						if not IsValid(car.e) or car.e ~= closestsuspect then
							car.e = closestsuspect
							UVAddToWantedListVehicle(closestsuspect)
						end

						car.uvplayerdistancetoenemy = closestdistancetosuspect
					end
				end

				-- Tracking logic for chasing units
				if IsValid(car.e) and car.uvplayerdistancetoenemy then
					local in_view = UVVisualOnTarget(car, car.e) and car.uvplayerdistancetoenemy < visualrange

					if in_view then
						UVLosing = CurTime()
						if not table.HasValue(UVUnitsChasing, car) then
							table.insert(UVUnitsChasing, car)
						end
					else
						if table.HasValue(UVUnitsChasing, car) then
							table.RemoveByValue(UVUnitsChasing, car)
						end
					end
				else
					if table.HasValue(UVUnitsChasing, car) then
						table.RemoveByValue(UVUnitsChasing, car)
					end
				end
			end
		end

		UVUnitsHavePlayers = playerUnitActive

		if next(ents.FindByClass("npc_uv*")) ~= nil then
			for k, unit in pairs(ents.FindByClass("npc_uv*")) do
				if not unit.v then return end
				if not table.HasValue(UVUnitVehicles, unit.v) then
					table.insert(UVUnitVehicles, unit.v)
				end
			end
		end

		local visible_suspects = {}

		if next(UVUnitVehicles) ~= nil or (UVTargeting and not UVEnemyEscaping) then
			for k, unit in pairs(UVUnitVehicles) do
				if not IsValid(unit) or not unit.UnitVehicle then
					table.RemoveByValue(UVUnitVehicles, unit)
					table.RemoveByValue(UVUnitsChasing, unit)
				end
			end
			if next(UVWantedTableVehicle) ~= nil then
				for _, v in pairs(UVWantedTableVehicle) do
					local last_visible_value = v.inunitview

					local visualrange = 25000000
					if UVHiding then
						visualrange = 1000000
					end

					local check = false

					for _, j in pairs(ents.FindByClass("uvair")) do
						if (not (j.Downed and j.disengaging and j.crashing)) and j:GetTarget() == v then
							v.inunitview = true
							check = true
							table.insert(visible_suspects, v)
						end
					end

					if not check then
						for _, unit in pairs(UVUnitVehicles) do
							if IsValid(unit) then
								if UVVisualOnTarget(unit, v) then
									v.inunitview = true
									table.insert(visible_suspects, v)
								else
									if not table.HasValue(visible_suspects, v) then
										v.inunitview = false 
									end
								end
							end
						end
					end

					v._lastVisibilityChange = v._lastVisibilityChange or 0
					local now = CurTime()

					if last_visible_value ~= v.inunitview then
						v._lastVisibilityChange = now

						net.Start("UVUpdateSuspectVisibility")
						net.WriteEntity(v)
						net.WriteBool(v.inunitview)
						net.Broadcast()
					end
				end
			end
		end

		--Wrecked vehicles
		if next(UVWreckedVehicles) ~= nil then
			for k, car in pairs(UVWreckedVehicles) do
				if IsValid(car) then
					if #UVWantedTableVehicle == 1 and not UVRacerPresenceMode then
						local carPos = car:GetPos()
						local suspect = UVWantedTableVehicle[1]
						local enemylocation = (suspect:GetPos()+Vector(0,0,50))
						local distance = enemylocation - carPos
						if distance:LengthSqr() > 100000000 then
							car:Remove()
						end
					else
						break
					end
				else
					table.RemoveByValue(UVWreckedVehicles, car)
				end
			end
		end

		--Idle chatter
		if #ents.FindByClass("npc_uv*") > 0 and not UVTargeting then
			if not (timer.Exists("uvidletalk")) then
				timer.Create("uvidletalk", 10, 0, function()
					local units = ents.FindByClass("npc_uv*")
					local random_entry = math.random(#units)
					local unit = units[random_entry]
					local uvchatter = math.random(1,10)
					if Chatter:GetBool() and IsValid(unit.v) then
						if uvchatter == 1 then
							UVChatterDispatchIdleTalk(unit)
						elseif uvchatter == 2 then
							UVChatterIdleTalk(unit)
						end
					end
				end)
			end
		else
			if timer.Exists("uvidletalk") then
				timer.Remove("uvidletalk")
			end
		end

		-- if UVTargeting then
		-- 	if not UVTimer then
		-- 		UVTimer = CurTime()
		-- 	end
		-- end

		if #ents.FindByClass("npc_uv*") == 0 and IsValid(uvenemylocation) and not UVTargeting then 
			uvenemylocation:Remove() 
		end

		--Losing		
		local ltimeout = (UVCooldownTimer+5)

		if UVHUDPursuit then
			if #UVUnitsChasing <= 0 and not ((not UVUCommanderEvade:GetBool()) and UVOneCommanderActive) then
				if (not uvevadingprogress) or uvevadingprogress == 0 then
					uvevadingprogress = CurTime()
				end
				net.Start("UVHUDEvading")
				net.WriteBool(true)
				net.WriteString(math.Clamp((CurTime() - uvevadingprogress) / 5, 0, 1))
				net.Broadcast()
				--UpdatePursuitTable('IsEvading', true)
			else
				uvevadingprogress = 0
				net.Start("UVHUDEvading")
				net.WriteBool(false)
				net.WriteString(0)
				net.Broadcast()
				--UpdatePursuitTable('IsEvading', false)
			end
		end

		if not UVEnemyEscaped and UVTargeting and UVLosing ~= CurTime() and (UVLosing - CurTime() + ltimeout) < (ltimeout - 5) and #UVWantedTableVehicle > 0 then
			if not UVEnemyEscaping then
				UVEnemyEscaping = true
				UVCooldownProgressTimeout = CurTime()
				if timer.Exists("UVTimeTillNextHeat") then
					timer.Pause("UVTimeTillNextHeat")
				end
				if Chatter:GetBool() and not UVCalm and not UVEnemyBusted then
					if next(ents.FindByClass("npc_uv*")) ~= nil then
						local units = ents.FindByClass("npc_uv*")
						local random_entry = math.random(#units)	
						local unit = units[random_entry]
						UVChatterLosing(unit)
						timer.Simple(math.random(10,20), function()
							if UVEnemyEscaping and IsValid(unit) then
								UVChatterLosingUpdate(unit) 
							end
						end)
					end
				end
				--Entity(1):EmitSound("ui/pursuit/escaping.wav", 0, 100, 0.5)
				UVRelaySoundToClients("ui/pursuit/escaping.wav", false)
			end
			if UVEnemyEscaping then
				local cooldowntimer = UVCooldownTimer
				if UVHiding then
					cooldowntimer = cooldowntimer/4
				end
				local cooldownprogresstick = 0.01
				local cooldownprogress = ((1/cooldowntimer)*cooldownprogresstick)
				if CurTime() > UVCooldownProgressTimeout + cooldownprogresstick then
					UVCooldownTimerProgress = UVCooldownTimerProgress+cooldownprogress
					UVCooldownProgressTimeout = CurTime()
				end 
			end
		else
			if UVEnemyEscaping and not UVEnemyEscaped and not UVEnemyBusted then
				UVEnemyEscaping = nil
				UVCooldownTimerProgress = 0
				if timer.Exists("UVTimeTillNextHeat") then
					timer.UnPause("UVTimeTillNextHeat")
				end
				if UVTargeting then 
					--Entity(1):EmitSound("ui/pursuit/resume.wav", 0, 100, 0.5)
					UVRelaySoundToClients("ui/pursuit/resume.wav", false)
				end
				local function ChatterChopperUnavailable()
					if next(ents.FindByClass("npc_uv*")) ~= nil then
						local units = ents.FindByClass("npc_uv*")
						local random_entry = math.random(#units)	
						local unit = units[random_entry]
						UVChatterFoundEnemy(unit)
					end
				end
				if Chatter:GetBool() and not UVCalm and not UVEnemyBusted then
					local airUnits = ents.FindByClass("uvair")
					if next(airUnits) ~= nil then
						local random_entry = math.random(#airUnits)	
						local unit = airUnits[random_entry]
						if not (unit.crashing or unit.disengaging) then
							UVChatterAirFoundEnemy(unit)
						else
							ChatterChopperUnavailable()
						end
					else
						ChatterChopperUnavailable()
					end
				end
			end
		end

		--Call off the pursuit.
		if UVTargeting and not UVEnemyEscaped and UVCooldownTimer then
			if UVCooldownTimerProgress >= 1 then
				UVCooldownTimerProgress = 0
				UVTargeting = nil
				UVEnemyEscaped = true
				timer.Simple(10, function() if UVEnemyEscaped then UVEnemyEscaped = nil end end)
				for k, v in pairs(ents.FindByClass("npc_uv*")) do
					v:ForgetEnemy()
				end
				for k, v in pairs(player.GetAll()) do
					v:SetHealth(100)
					v:SetMaxHealth(100)
					if v:InVehicle() then
						local car = v:GetVehicle()
						if car:GetClass() == "prop_vehicle_jeep" and vcmod_main then
							car:VC_repairFull_Admin()
							if car:VC_hasGodMode() then
								car:VC_setGodMode(false)
							end
						elseif car.IsSimfphyscar then
							if car.simfphysoldhealth then
								car:SetMaxHealth(car.simfphysoldhealth)
								car:SetCurHealth(car.simfphysoldhealth)
								car.simfphysoldhealth = nil
							end
							if istable(car.Wheels) then
								for i = 1, table.Count( car.Wheels ) do
									local Wheel = car.Wheels[ i ]
									if IsValid(Wheel) then
										Wheel:SetDamaged( false )
										Wheel.UVTireDeflatable = nil
									end
								end
							end
						end
					end
				end
				for k, v in pairs(ents.FindByClass("uvair")) do
					v.disengaging = true 
				end
				if #ents.FindByClass("npc_uv*") > 0 then
					local units = ents.FindByClass("npc_uv*")
					local random_entry = math.random(#units)	
					local unit = units[random_entry]
					if Chatter:GetBool() and IsValid(unit.v) then
						UVChatterLost(unit) 
					end
				end
				--Entity(1):EmitSound("ui/pursuit/escaped.wav")
				UVRelaySoundToClients("ui/pursuit/escaped.wav", false)
			end

		end

		--Never evade option
		if (NeverEvade:GetBool() and UVTargeting) or (((not UVUCommanderEvade:GetBool()) and UVOneCommanderActive) and not UVEnemyEscaping) then
			UVLosing = CurTime()
		end

		if CurTime() > (uv_next_racer_name_check or 0) then 
			uv_next_racer_name_check = CurTime() + 5

			for _, v in pairs(UVWantedTableVehicle) do
				if v.racer then
					net.Start( "UVUpdateRacerName" )
					net.WriteEntity( v )
					net.WriteString( v.racer )
					net.Broadcast()
				end
			end
		end

		UpdatePursuitTable( 'InPursuit', UVTargeting )
		UpdatePursuitTable( 'Heat', UVHeatLevel )
		UpdatePursuitTable( 'UnitsChasing', #UVUnitsChasing )
		UpdatePursuitTable( 'ResourcePoints', UVResourcePoints )
		UpdatePursuitTable( 'Deploys', UVDeploys )
		UpdatePursuitTable( 'Wrecks', UVWrecks )
		UpdatePursuitTable( 'Tags', UVTags )
		UpdatePursuitTable( 'Bounty', UVBounty )

		--HUD Triggers
		if UVTargeting then
			if UVBounty < 100 and UVUTimeTillNextHeatEnabled:GetInt() ~= 1 then
				UVBounty = 100
			end

			if not UVHUDPursuit then
				UVLosing = CurTime()
				uvevadingprogress = CurTime()
				UVRestoreResourcePoints()
				for _, ent in ents.Iterator() do
					if UVPassConVarFilter(ent) then
						UVAddToWantedListVehicle(ent)
					end
				end
				if UVHeatLevel <= 3 then
					--Entity(1):EmitSound("ui/pursuit/start.wav", 0, 100, 0.5)
					UVRelaySoundToClients("ui/pursuit/start.wav", false)
				else
					--Entity(1):EmitSound("ui/pursuit/start_wanted_level_high.wav", 0, 100, 0.5)
					UVRelaySoundToClients("ui/pursuit/start_wanted_level_high.wav", false)
				end
				if timer.Exists("UVTimeTillNextHeat") then
					timer.UnPause("UVTimeTillNextHeat")
				end
			end

			if not UVHUDPursuit then
				UpdatePursuitTable( 'PursuitStart', CurTime() )
			end

			UVHUDPursuit = true

			if timer.Exists("UVTimeTillNextHeat") then
				if not _last_timed_heat_update then _last_timed_heat_update = 0 end				
				if timer.TimeLeft("UVTimeTillNextHeat") >= 0 and CurTime() - _last_timed_heat_update > 1 then
					net.Start( "UVHUDTimeTillNextHeat" )
					net.WriteFloat( timer.TimeLeft("UVTimeTillNextHeat") )
					net.Broadcast()
				end
			elseif UVUTimeTillNextHeatEnabled:GetInt() == 1 then
				local TimeTillNextHeat = 120

				local timeTillNextHeatConVar = GetConVar( 'unitvehicle_unit_timetillnextheat' .. UVHeatLevel )

				if timeTillNextHeatConVar then
					TimeTillNextHeat = timeTillNextHeatConVar:GetInt()

					timer.Create( "UVTimeTillNextHeat", TimeTillNextHeat, 0, function()
						if UVUTimeTillNextHeatEnabled:GetInt() ~= 1 then
							timer.Remove( "UVTimeTillNextHeat" )
							return
						end

						local nextHeat = UVHeatLevel + 1
						local timeTillNextHeatNew = GetConVar( 'unitvehicle_unit_timetillnextheat' .. nextHeat ) or TimeTillNextHeat

						if nextHeat <= MaxHeatLevel:GetInt() then
							UVHeatLevel = nextHeat

							timer.Adjust("UVTimeTillNextHeat", timeTillNextHeatNew:GetInt(), 0)

							-- PrintMessage( HUD_PRINTCENTER, string.format( lang("uv.hud.heatlvl"), 2 ) )
							if next(ents.FindByClass("npc_uv*")) ~= nil and Chatter:GetBool() then
								local units = ents.FindByClass("npc_uv*")
								local random_entry = math.random(#units)
								local unit = units[random_entry]
								if not UVTargeting then return end
								UVChatterHeatTwo(unit)
							end

							if UVTargeting then
								--Entity(1):EmitSound("ui/pursuit/heatlevelrise.wav", 0, 100, 0.5)
								UVRelaySoundToClients("ui/pursuit/heatlevelrise.wav", false)
							end

							net.Start("UVHUDHeatLevelIncrease")
							net.Broadcast()
							UVUpdateHeatLevel()
						end
					end )
				end
			end

		else	
			if UVHUDPursuit then
				UVHUDPursuit = nil
				net.Start( "UVHUDStopPursuit" )
				net.Broadcast()
				UVHUDBusting = nil
				net.Start( "UVHUDStopBusting" )
				net.Broadcast()
				UVRacerPresenceMode = false
				if timer.Exists("UVTimeTillNextHeat") then
					timer.Pause("UVTimeTillNextHeat")
				end

				if uvhudtimestopped then return end
				uvhudtimestopped = true

				local time = UVTimer--net.ReadString()
				local timeformatted = UVDisplayTime(time)
				if not UVEnemyEscaped then --busted
					print("The pursuit lasted with a time of "..timeformatted.."!")
					local bustedtable = {}
					bustedtable["Deploys"] = UVDeploys
					bustedtable["Roadblocks"] = UVRoadblocksDodged
					bustedtable["Spikestrips"] = UVSpikestripsDodged
					net.Start( "UVHUDCopModeBustedDebrief" )
					net.WriteTable(bustedtable)
					net.Send(UVPlayerUnitTablePlayers)
				else --escaped
					for k, v in pairs(player.GetAll()) do
						print(v:GetName().." Evaded!\n" .. 
							"Total Bounty - " .. string.Comma(UVBounty).."\n" .. 
							"Pursuit Duration - " .. timeformatted .. "\n" ..
							"Police Vehicles Involved - " .. UVDeploys .. "\n" ..
							"Damaged Police Vehicles - " .. UVTags .. "\n" ..
							"Immobilized Police Vehicles - " .. UVWrecks .. "\n" ..
							"Roadblocks Dodged - " .. UVRoadblocksDodged .. "\n" ..
							"Spike Strips Dodged - " .. UVSpikestripsDodged
						)
					end
					local escapedtable = {}
					escapedtable["Deploys"] = UVDeploys
					escapedtable["Roadblocks"] = UVRoadblocksDodged
					escapedtable["Spikestrips"] = UVSpikestripsDodged
					net.Start( "UVHUDEscapedDebrief" )
					net.WriteTable(escapedtable)
					net.Send(UVWantedTableDriver)
					net.Start( "UVHUDCopModeEscapedDebrief" )
					net.WriteTable(escapedtable)
					net.Send(UVPlayerUnitTablePlayers)
				end

				timer.Simple(1, function()
					uvhudtimestopped = nil
					if not UVTargeting then
						UVResetStats()
					end
				end)
			end

		end

		if UVEnemyBusted and next(UVWantedTableVehicle) == nil then
			net.Start( "UVHUDEnemyBusted" )
			net.Broadcast()
		end

		if not UVEnemyEscaped and UVTargeting and UVEnemyEscaping and not UVEnemyBusted then
			UVHUDCooldown = true
			net.Start( "UVHUDCooldown" )
			net.WriteString(UVCooldownTimerProgress)
			net.Broadcast()
		elseif UVHUDCooldown then
			UVHUDCooldown = nil
			net.Start( "UVHUDStopCooldown" )
			net.Broadcast()
		end

		if UVHiding and UVEnemyEscaping then
			if UVHiding and not UVHUDHiding then
				UVHUDHiding = true
			end
			net.Start( "UVHUDHiding" )
			net.Broadcast()
		else
			if UVHUDHiding then
				UVHUDHiding = nil
				net.Start( "UVHUDStopHiding" )
				net.Broadcast()
			end
		end

	end)

	net.Receive("UVHUDRespawnInUV", function( length, ply )
		if IsValid(ply.uvplayerlastvehicle) and ply.uvplayerlastvehicle.wrecked then
			SpawnCooldownTable[ply] = CurTime()

			ply:ExitVehicle()
			ply:Spawn()
			ply.uvplayerlastvehicle:Remove()
			UVAutoSpawn(ply, nil, nil, true)
		else
			if not SpawnCooldownTable[ply] then
				SpawnCooldownTable[ply] = 0
			else
				if CurTime() - SpawnCooldownTable[ply] < SpawnCooldown:GetInt() then
					ply:PrintMessage( HUD_PRINTTALK, "You must wait "..math.Round(SpawnCooldown:GetInt() - (CurTime() - SpawnCooldownTable[ply]), 1).." seconds before respawning." )
					return
				end
			end

			SpawnCooldownTable[ply] = CurTime()

			ply:ExitVehicle()
			ply:Spawn()

			if IsValid(ply.uvplayerlastvehicle) and not ply.uvplayerlastvehicle.wrecked then
				if table.HasValue(UVUnitsChasing, ply.uvplayerlastvehicle) then
					table.RemoveByValue(UVUnitsChasing, ply.uvplayerlastvehicle)
				end

				ply.uvplayerlastvehicle:Remove()
			end

			UVAutoSpawn(ply, nil, nil, true)
		end
	end)

	-- net.Receive("UVHUDReAddUV", function( length, ply )
	-- 	local unitindex = net.ReadInt(32)
	-- 	local typestring = net.ReadString()
	-- 	local unit = Entity(unitindex)
	-- 	if not IsValid(unit) then return end
	-- 	net.Start("UVHUDAddUV")
	-- 	net.WriteInt(unitindex, 32)
	-- 	net.WriteString(typestring)
	-- 	net.Send(ply)
	-- end)

	gameevent.Listen( "player_activate" )
	hook.Add( "player_activate", "player_activate_example", function( data ) 
		local id = data.userid				-- Same as Player:UserID() for the speaker
		local ply = Player(id)

		print('Unit Vehicles:', 'Initializing for -', ply)

		net.Start('UVGet_PursuitTable')
		net.WriteTable(PursuitTable)
		net.Send(ply)

		for _, v in pairs( UVUnitVehicles ) do
			net.Start( "UVHUDAddUV" )
			net.WriteInt( v:EntIndex(), 32 )
			net.WriteInt( v:GetCreationID(), 32 )
			net.WriteString( "unit" )
			net.Send( ply )
		end

		for _, v in pairs( UVWantedTableVehicle ) do
			net.Start( "UV_AddWantedVehicle" )
			net.WriteInt( v:EntIndex(), 32 )
			net.WriteInt( v:GetCreationID(), 32 )
			net.Send( ply )
		end

	end )	

	net.Receive("UVUpdateSettings", function(len, ply)
		if not ply:IsSuperAdmin() then return end
		local array = net.ReadTable()

		for key, value in pairs(array) do
			local valid = string.match(key, 'unitvehicle_')

			if valid then
				local convarType = type( value )
				local convar = GetConVar( key )

				if convar then
					if convarType == 'boolean' then
						convar:SetBool( value )
					elseif convarType == 'number' then
						convar:SetFloat( value )
					elseif convarType == 'string' then
						convar:SetString( value )
					end
				end
			end
		--[[
		So for some fucking reason unbeknownst to me, RunConsoleCommand convars refuse to work for certain strings, 
		yet it works if you set it using the ConVar::SetX functions, bullshit.
		]]

			--print(key, value)
			--RunConsoleCommand(key, value)
			--GetConVar( key ):SetString( value )
		end

		local convarTable = {}

		for convarName, convarType in pairs(LOCAL_CONVARS) do
			local convar = GetConVar(convarName)
			local value = nil

			if convarType == 'boolean' then
				value = convar:GetBool()
			elseif convarType == 'integer' then
				value = convar:GetInt()
			elseif convarType == 'string' then
				value = convar:GetString()
			end

			if value then
				convarTable[convarName] = value
			end

			--convar_name = string.gsub(convar_name, "_local", "")
		end

		net.Start("UVGetSettings_Local")
		net.WriteTable(array)
		net.Broadcast()
	end)

	concommand.Add( "uv_setbounty", function( ply, cmd, args )
		if not ply:IsSuperAdmin() then return end
		UVBounty = tonumber(args[1]) or 0
	end)

else --HUD/Options

	local displaying_busted = false 
	local IsSettingKeybind = false

	UVDeploys = 0
	UVUnitsChasing = 0
	UVBustingProgress = 0

	local UVClosestSuspect = nil

	local UVHUDBlipSoundTime = CurTime()
	UVHUDScannerPos = Vector(0,0,0)

	KeyBindButtons = {}
	PursuitTable = {}
	UnitTable = {}
	EntityQueue = {}
	CleanupTask = {}

	local unitBlipColors = {
		[1] = Color( 0, 0, 255 ),
		[2] = Color( 150, 0, 0),
		[3] = Color( 255, 255, 255 )
	}

	--hook.Run('HUDArrest')

	PursuitTheme = CreateClientConVar("unitvehicle_pursuittheme", "nfsmostwanted", true, false, "Unit Vehicles: Type either one of these two pursuit themes to play from 'nfsmostwanted' 'nfsundercover'.")
	HeatLevels = CreateClientConVar("unitvehicle_heatlevels", 1, true, false, "If set to 1, Heat Levels will increase from its minimum value to its maximum value during a pursuit.")
	TargetVehicleType = CreateClientConVar("unitvehicle_targetvehicletype", 1, true, false, "Unit Vehicles: 1 = All vehicles are targeted. 2 = Decent Vehicles are targeted only. 3 = Other vehicles besides Decent Vehicles are targeted.")
	DetectionRange = CreateClientConVar("unitvehicle_detectionrange", 30, true, false, "Unit Vehicles: Minimum spawning distance to the vehicle in studs when manually spawning Units. Use greater values if you have trouble spawning Units.")
	PlayMusic = CreateClientConVar("unitvehicle_playmusic", 1, true, false, "Unit Vehicles: If set to 1, Pursuit themes will play.")
	RacingMusic = CreateClientConVar("unitvehicle_racingmusic", 1, true, false, "Unit Vehicles: If set to 1, Racing music will play.")
	RacingMusicPriority = CreateClientConVar("unitvehicle_racingmusicpriority", 0, true, false, "Unit Vehicles: If set to 1, Racing music will play during pursuits while racing.")
	RacingThemeOutsideRace = CreateClientConVar("unitvehicle_racingmusicoutsideraces", 0, true, false, "Unit Vehicles: If set to 1, Racing music will play during pursuits even while not racing.")
	PursuitVolume = CreateClientConVar("unitvehicle_pursuitthemevolume", 1, true, false, "Unit Vehicles: Determines volume of the pursuit theme.")
	NeverEvade = CreateClientConVar("unitvehicle_neverevade", 0, true, false, "Unit Vehicles: If set to 1, you won't be able to evade the Unit Vehicles. Good luck.")
	BustedTimer = CreateClientConVar("unitvehicle_bustedtimer", 5, true, false, "Unit Vehicles: Time in seconds before the enemy gets busted. Set this to 0 to disable.")
	SpawnCooldown = CreateClientConVar("unitvehicle_spawncooldown", 30, true, false, "Unit Vehicles: Time in seconds before player units can spawn again. Set this to 0 to disable.")
	CanWreck = CreateClientConVar("unitvehicle_canwreck", 1, true, false, "Unit Vehicles: If set to 1, Unit Vehicles can crash out. Set this to 0 to disable.")
	Chatter = CreateClientConVar("unitvehicle_chatter", 1, true, false, "Unit Vehicles: If set to 1, Units' radio chatter can be heard.")
	SpeedLimit = CreateClientConVar("unitvehicle_speedlimit", 60, true, false, "Unit Vehicles: Speed limit in MPH for idle Units to enforce. Patrolling Units still enforces speed limits set on DV Waypoints. Set this to 0 to disable.")
	AutoHealth = CreateClientConVar("unitvehicle_autohealth", 0, true, false, "Unit Vehicles: If set to 1, all suspects will have unlimited vehicle health and your health as a suspect will be set according to your vehicle's mass.")
	MinHeatLevel = CreateClientConVar("unitvehicle_minheatlevel", 1, true, false, "Unit Vehicles: Sets the minimum Heat Level achievable during pursuits (1-6). Use high Heat Levels for more aggressive Units on your tail and vice versa.")
	MaxHeatLevel = CreateClientConVar("unitvehicle_maxheatlevel", 6, true, false, "Unit Vehicles: Sets the maximum Heat Level achievable during pursuits (1-6). Use low Heat Levels for less aggressive Units on your tail and vice versa.")
	SpikeStripDuration = CreateClientConVar("unitvehicle_spikestripduration", 20, true, false, "Unit Vehicle: Time in seconds before the tires gets reinflated after hitting the spikes. Set this to 0 to disable reinflating tires.")
	Pathfinding = CreateClientConVar("unitvehicle_pathfinding", 1, true, false, "Unit Vehicles: If set to 1, Units uses A* pathfinding algorithm on navmesh/Decent Vehicle Waypoints to navigate. Impacts computer performance.")
	VCModELSPriority = CreateClientConVar("unitvehicle_vcmodelspriority", 0, true, false, "Unit Vehicles: If set to 1, Units using base HL2 vehicles will attempt to use VCMod ELS over Photon if both are installed.")
	CallResponse = CreateClientConVar("unitvehicle_callresponse", 1, true, false, "Unit Vehicles: If set to 1, Units will spawn and respond to the location regarding various calls.")
	ChatterText = CreateClientConVar("unitvehicle_chattertext", 0, true, false, "Unit Vehicles: If set to 1, Units' radio chatter will be displayed in the chatbox instead.")
	Headlights = CreateClientConVar("unitvehicle_enableheadlights", 0, true, false, "Unit Vehicles: If set to 1, Units and Racer Vehicles will shine their headlights.")
	Relentless = CreateClientConVar("unitvehicle_relentless", 0, true, false, "Unit Vehicles: If set to 1, Units will ram the target more frequently.")
	SpawnMainUnits = CreateClientConVar("unitvehicle_spawnmainunits", 1, true, false, "Unit Vehicles: If set to 1, main AI Units (Patrol, Support, etc.) will spawn to patrol/chase.")
	DVWaypointsPriority = CreateClientConVar("unitvehicle_dvwaypointspriority", 0, true, false, "Unit Vehicles: If set to 1, Units will attempt to navigate on Decent Vehicle Waypoints FIRST instead of navmesh (if both are installed).")
	PursuitThemePlayRandomHeat = CreateClientConVar("unitvehicle_pursuitthemeplayrandomheat", 0, true, false, "Unit Vehicles: If set to 1, random Heat Level songs will play during pursuits.")
	RepairCooldown = CreateClientConVar("unitvehicle_repaircooldown", 60, true, false, "Unit Vehicle: Time in seconds between each repair. Set this to 0 to make all repair shops a one-time use.")
	RepairRange = CreateClientConVar("unitvehicle_repairrange", 100, true, false, "Unit Vehicle: Distance in studs between the repair shop and the vehicle to repair.")
	RacerTags = CreateClientConVar("unitvehicle_racertags", 1, true, false, "Unit Vehicles: If set to 1, Racers and Commander Units will have name tags above their vehicles.")
	RacerPursuitTech = CreateClientConVar("unitvehicle_racerpursuittech", 1, true, false, "Unit Vehicles: If set to 1, Racers will spawn with pursuit tech (spike strips, ESF, etc.).")
	RacerFriendlyFire = CreateClientConVar("unitvehicle_racerfriendlyfire", 1, true, false, "Unit Vehicles: If set to 1, Racers will be able to attack eachother with Pursuit Tech.")
	MuteCheckpointSFX = CreateClientConVar("unitvehicle_mutecheckpointsfx", 0, true, false, "Unit Vehicles: If set to 1, the SFX that plays when passing checkpoints will be silent.")
	UVTraxFreeroam = CreateClientConVar("unitvehicle_uvtraxinfreeroam", 0, true, false, "Unit Vehicles: If set to 1, UV TRAX™ will play in Freeroam whenever you're in a vehicle.")

	-- unit convars
	--UVUVehicleBase = CreateClientConVar("unitvehicle_unit_vehiclebase", 1, true, false, "\n1 = Default Vehicle Base (prop_vehicle_jeep)\n2 = simfphys\n3 = Glide")
	UVUOneCommander = CreateClientConVar("unitvehicle_unit_onecommander", 0, true, false)
	UVUOneCommanderHealth = CreateClientConVar("unitvehicle_unit_onecommanderhealth", 1, true, false)
	UVUCommanderEvade = CreateClientConVar("unitvehicle_unit_onecommanderevading", 0, true, false, "If enabled, will allow racers to escape while commander is on scene.")
	UVUCommanderRepair = CreateClientConVar("unitvehicle_unit_commanderrepair", 1, true, false,"Unit Vehicles: If set to 1, Commander Units can utilize the Repair Shop to repair themselves.")

	for i = 1, MAX_HEAT_LEVEL do
		local prevIterator = i - 1

		local timeTillNextHeatId = ((prevIterator == 0 and 'enabled') or prevIterator)

		for _, v in pairs( {'Patrol', 'Support', 'Pursuit', 'Interceptor', 'Special', 'Commander'} ) do
			local lowercaseUnit = string.lower( v )
			local conVarKey = string.format( 'units%s%s', lowercaseUnit, i )

			-------------------------------------------

			CreateClientConVar( "unitvehicle_unit_" .. conVarKey, "", true, false)
		end

		-- roboboy hated him, so he decided to not assign him a "units" at the start of his key...
		-- poor guy, now he's lonely outside of the for loop : (
		CreateClientConVar( "unitvehicle_unit_rhinos" .. i, "", true, false)

		for _, conVar in pairs( HEAT_SETTINGS ) do
			local conVarKey = conVar .. ((conVar == 'timetillnextheat' and timeTillNextHeatId) or i)
			local check = (conVar == "timetillnextheat")

			CreateClientConVar( "unitvehicle_unit_" .. conVarKey, HEAT_DEFAULTS[conVar][tostring( ( check and timeTillNextHeatId ) or i )] or 0, true, false)
		end
	end

	UVUTimeTillNextHeatEnabled = CreateClientConVar("unitvehicle_unit_timetillnextheatenabled", 0, true, false)

	UVPTKeybindSlot1 = CreateClientConVar("unitvehicle_pursuittech_keybindslot_1", KEY_T, true, false)
	UVPTKeybindSlot2 = CreateClientConVar("unitvehicle_pursuittech_keybindslot_2", KEY_P, true, false)

	UVKeybindResetPosition = CreateClientConVar("unitvehicle_keybind_resetposition", KEY_M, true, false)
	UVKeybindShowRaceResults = CreateClientConVar("unitvehicle_keybind_raceresults", KEY_N, true, false)

	UVKeybindSkipSong = CreateClientConVar("unitvehicle_keybind_skipsong", KEY_LBRACKET, true, false)

	UVPTPTDuration = CreateClientConVar("unitvehicle_pursuittech_ptduration", 60, true, false)
	UVPTESFDuration = CreateClientConVar("unitvehicle_pursuittech_esfduration", 10, true, false)
	UVPTESFPower = CreateClientConVar("unitvehicle_pursuittech_esfpower", 2000000, true, false)
	UVPTESFDamage = CreateClientConVar("unitvehicle_pursuittech_esfdamage", 0.2, true, false)
	UVPTESFCommanderDamage = CreateClientConVar("unitvehicle_pursuittech_esfcommanderdamage", 0.2, true, false)


	UVPTJammerDuration = CreateClientConVar("unitvehicle_pursuittech_jammerduration", 10, true, false)
	UVPTShockwavePower = CreateClientConVar("unitvehicle_pursuittech_shockwavepower", 2000000, true, false)
	UVPTShockwaveDamage = CreateClientConVar("unitvehicle_pursuittech_shockwavedamage", 0.1, true, false)
	UVPTShockwaveCommanderDamage = CreateClientConVar("unitvehicle_pursuittech_shockwavecommanderdamage", 0.1, true, false)
	UVPTSpikeStripDuration = CreateClientConVar("unitvehicle_pursuittech_spikestripduration", 60, true, false)
	UVPTStunMinePower = CreateClientConVar("unitvehicle_pursuittech_stunminepower", 2000000, true, false)
	UVPTStunMineDamage = CreateClientConVar("unitvehicle_pursuittech_stunminedamage", 0.1, true, false)
	UVPTStunMineCommanderDamage = CreateClientConVar("unitvehicle_pursuittech_stunminecommanderdamage", 0.1, true, false)

	UVUnitPTDuration = CreateClientConVar("unitvehicle_unitpursuittech_ptduration", 20, true, false)
	UVUnitPTESFDuration = CreateClientConVar("unitvehicle_unitpursuittech_esfduration", 10, true, false)
	UVUnitPTESFPower = CreateClientConVar("unitvehicle_unitpursuittech_esfpower", 2000000, true, false)
	UVUnitPTESFDamage = CreateClientConVar("unitvehicle_unitpursuittech_esfdamage", 0.2, true, false)
	UVUnitPTSpikeStripDuration = CreateClientConVar("unitvehicle_unitpursuittech_spikestripduration", 60, true, false)
	UVUnitPTKillSwitchLockOnTime = CreateClientConVar("unitvehicle_unitpursuittech_killswitchlockontime", 3, true, false)
	UVUnitPTKillSwitchDisableDuration = CreateClientConVar("unitvehicle_unitpursuittech_killswitchdisableduration", 2.5, true, false)

	UVPBMax = CreateClientConVar("unitvehicle_pursuitbreaker_maxpb", 2, true, false)
	UVPBCooldown = CreateClientConVar("unitvehicle_pursuitbreaker_pbcooldown", 60, true, false)

	UVRBMax = CreateClientConVar("unitvehicle_roadblock_maxrb", 1, true, false)
	UVRBOverride = CreateClientConVar("unitvehicle_roadblock_override", 0, true, false)

	UVHUDTypeMain = CreateClientConVar("unitvehicle_hudtype_main", "mostwanted", true, false, "Unit Vehicles: Which HUD type to use when in races and pursuits.")
	UVHUDTypeBackup = CreateClientConVar("unitvehicle_hudtype_backup", "mostwanted", true, false, "Unit Vehicles: Which HUD type to use if main does not have a Pursuit UI.")

	UVUnitsColor = Color(255,255,255)

	UVHUDWantedSuspects = {}

	PursuitTable = {
		['InPursuit'] = false,
		['InCooldown'] = false,
		['IsEvading'] = false,
		['PursuitStart'] = 0,
		['Heat'] = 1,
		['UnitsChasing'] = 0,
		['ResourcePoints'] = 0,
		['Deploys'] = 0,
		['PursuitLength'] = 0,
		['Wrecks'] = 0,
		['Tags'] = 0,
		['Bounty'] = 0,
		['CommanderActive'] = false,
		['CommanderEntity'] = nil
		--['ChasedVehicles'] = {},
	}

	local function InitEntity( entIndex, creationId, entType )
		local entity = Entity( entIndex )
		if not IsValid( entity ) then return end

		local localCreationId = entity:GetCreationID()

		if localCreationId ~= creationId then 
			return 
		end

		if entType == "unit" or entType == "air" then

			table.insert( UnitTable, entity )

			if GMinimap then
				local entClass = entity:GetClass()
				local unitIcon = (entType == "air" and "unitvehicles/icons/HELICOPTER_MINIMAP_ICON.png") or "unitvehicles/icons/MINIMAP_ICON_CAR.png"

				if entClass == "prop_vehicle_jeep" and entType ~= "air" then
					unitIcon = "unitvehicles/icons/MINIMAP_ICON_CAR_JEEP.png"
				end

				local blip, id = GMinimap:AddBlip({
					id = "UVBlip" .. entIndex,
					parent = entity,
					icon = unitIcon,
					scale = (entType == "air" and 2) or 1.4,
					color = Color( 150, 0, 0 ),
					alpha = 255
				})

				entity.flashIterator = 1

				timer.Create( "unit_blip_" .. id, 0.035, 0, function()
					if blip.disabled then
						blip.color = unitBlipColors[3]
						return
					end

					if not UVHUDDisplayPursuit then
						blip.color = unitBlipColors[2]
						return
					end

					-- entity.flashIterator = entity.flashIterator + 1
					local color = unitBlipColors[entity.flashIterator]
					entity.flashIterator = entity.flashIterator % #unitBlipColors + 1

					if color then
						blip.color = color
					end
				end)

				entity:CallOnRemove( "uv_entity_" .. entIndex, function()
					timer.Remove( "unit_blip_" .. id )
				end)
			end

		elseif entType == "roadblock" then

			if GMinimap then
				local blip, id = GMinimap:AddBlip( {
					id = "UVBlip" .. entIndex,
					parent = entity,
					icon = "unitvehicles/icons/MINIMAP_ICON_ROADBLOCK.png",
					scale = 1.4,
					color = Color( 255, 255, 0),
					alpha = 255
				} )
			end
			-- timer.Simple(0.1, function()
			-- 	blip.alpha = 255
			-- end)

		elseif entType == "repairshop" then

			if GMinimap then
				local blip, id = GMinimap:AddBlip( {
					id = "UVBlip" .. entIndex,
					parent = entity,
					icon = "unitvehicles/icons/repairshop.png",
					scale = 2,
					color = Color( 0, 255, 0),
					alpha = 255,
					lockIconAng = true
				} )
			end

		elseif entType == "racer" then
			table.insert( UVHUDWantedSuspects, entity )
		end

		return true
		--EntityQueue[entIndex] = nil
	end

	net.Receive('UVGetNewKeybind', function()
		--if IsSettingKeybind then return end
		local slot = net.ReadInt(16)
		local key = net.ReadInt(16)

		local entry = KeyBindButtons[slot]

		if entry then
			local convar = GetConVar( entry[1] )

			if convar then
				convar:SetInt( key )
				entry[2]:SetText( language.GetPhrase( Control_Strings [slot] ) .. " - " ..string.upper( input.GetKeyName(key) ) )
			end
		else
			warn("Invalid slot key; if you run into this please report it to a developer!")
		end

		IsSettingKeybind = false
	end)

	net.Receive("UV_SendPursuitTech", function()
		local car = net.ReadEntity()
		local slot = net.ReadUInt( 2 )
		local active = net.ReadBool()

		if not IsValid(car) then return end

		if active then

			if not car.PursuitTech then car.PursuitTech = {} end
			if not car.PursuitTech[slot] then car.PursuitTech[slot] = {} end

			car.PursuitTech[slot].Tech = net.ReadString()
			car.PursuitTech[slot].Ammo = net.ReadUInt( 8 )
			car.PursuitTech[slot].Cooldown = net.ReadUInt( 16 )
			car.PursuitTech[slot].LastUsed = net.ReadFloat()
			car.PursuitTech[slot].Upgraded = net.ReadBool()

		elseif car.PursuitTech then
			car.PursuitTech[slot] = nil
		end
	end)

	net.Receive('UVGet_PursuitTable', function()
		PursuitTable = net.ReadTable()
	end)

	net.Receive('UVSet_PursuitTable', function()
		local messageSize = net.ReadUInt( 16 )
		local recvData = net.ReadData( messageSize )

		local decompData = util.Decompress( recvData )
		local dataTable = util.JSONToTable( decompData )

		for key, value in pairs( dataTable ) do
			-- Found inside uvhud
			if UV_UI_Events[key] then 
				hook.Run( 'UIEventHook', 'pursuit', UV_UI_Events[key], value, PursuitTable[key] )
			end

			PursuitTable[key] = value
		end
	end)

	net.Receive('UVGetSettings_Local', function()
		local array = net.ReadTable()

		for key, value in pairs(array) do
			local valid = string.match(key, 'unitvehicle_')
			if valid then
				RunConsoleCommand(key, value)
			end
		end
	end)

	unitvehicles = true

	local UVHUDCopsDamaged = Material("unitvehicles/icons/COPS_DAMAGED_ICON.png")
	local UVHUDCopsWrecked = Material("unitvehicles/icons/COPS_TAKENOUT_ICON.png")
	local UVHUDMilestoneBounty = Material("unitvehicles/icons/MILESTONE_PURSUITBOUNTY.png")
	local UVHUDMilestoneInfractions = Material("unitvehicles/icons/MILESTONE_INFRACTIONS.png")
	local UVHUDMilestoneRoadblocks = Material("unitvehicles/icons/MILESTONE_ROADBLOCKS.png")
	local UVHUDMilestoneSpikestrips = Material("unitvehicles/icons/MILESTONE_SPIKESTRIPS.png")
	local UVHUDPursuitBreaker = Material("unitvehicles/icons/WORLD_PURSUITBREAKER.png")
	local UVHUDBlipSound = "ui/pursuit/spotting_blip.wav"

	concommand.Add("uv_keybinds", function( ply, cmd, slot )
		if IsSettingKeybind then
			notification.AddLegacy( "You are already setting a keybind!", NOTIFY_ERROR, 5 )
			return
		end

		local slot = slot[1]

		net.Start("UVPTKeybindRequest")
		net.WriteInt(slot, 16)
		net.SendToServer()

		IsSettingKeybind = slot
		KeyBindButtons[tonumber(slot)][2]:SetText('PRESS A KEY NOW!')
	end)

	concommand.Add("uv_local_update_settings", function( ply )
		if not ply:IsSuperAdmin() then
			notification.AddLegacy( "You need to be a super admin to apply settings on server!", NOTIFY_ERROR, 5 )
			return
		end

		local convar_table = {}

		for convar_name, convar_type in pairs(LOCAL_CONVARS) do
			local convar = GetConVar(convar_name)
			local value = nil

			if convar_type == 'boolean' then
				value = convar:GetBool()
			elseif convar_type == 'integer' then
				value = convar:GetInt()
			elseif convar_type == 'string' then
				value = convar:GetString()
			end

			if value then
				convar_table[convar_name] = value
			end
		end

		net.Start("UVUpdateSettings")
		net.WriteTable(convar_table)
		net.SendToServer()

		notification.AddLegacy('Pursuit Settings applied!', NOTIFY_GENERIC, 3)
	end)

	concommand.Add("uv_spawn_as_unit", function(ply)
		net.Start("UVHUDRespawnInUV")
		net.SendToServer()
	end)

	net.Receive("UVHUDPursuit", function()

		UVBountyString = net.ReadString()
		UVBountyNo = tonumber(UVBountyString)
		UVBounty = string.Comma(UVBountyString)

		UVHUDDisplayPursuit = true

	end)

	net.Receive("UVHUDHeatLevel", function()

		local HeatLevel = tonumber(net.ReadString())
		hook.Run( 'UIEventHook', 'pursuit', 'onHeatLevelUpdate', HeatLevel, UVHeatLevel )

		UVHeatLevel = HeatLevel

	end)

	net.Receive("UVHUDResourcePoints", function()

		local ResourcePoints = net.ReadString()
		local rp_num = tonumber(ResourcePoints)

		-- if rp_num ~= UVResourcePoints then
		-- 	hook.Remove("Think", "UVRPColorPulse")
		-- 	UVUnitsColor = (rp_num < (UVResourcePoints or 0) and Color(255,50,50, 150)) or Color(50,255,50, 150)
		-- 	--UVResourcePointsColor = (rp_num < UVResourcePoints and Color(255,50,50)) or Color(50,255,50)

		-- 	local clrs = {}

		-- 	for _, v in pairs( { 'r', 'g', 'b' } ) do
		-- 		if UVUnitsColor[v] ~= 255 then table.insert(clrs, v) end
		-- 	end 

		-- 	-- if timer.Exists("UVWrecksColor") then
		-- 	-- 	timer.Remove("UVWrecksColor")
		-- 	-- end
		-- 	local val = 50

		-- 	hook.Add("Think", "UVRPColorPulse", function()
		-- 		val = val + 200 * RealFrameTime()
		-- 		-- UVResourcePointsColor.b = val
		-- 		-- UVResourcePointsColor.g = val
		-- 		for _, v in pairs( clrs ) do
		-- 			UVUnitsColor[v] = val
		-- 		end

		-- 		if val >= 255 then hook.Remove("Think", "UVRPColorPulse") end
		-- 	end)
		-- end
		if rp_num ~= UVResourcePoints then
			hook.Run( 'UIEventHook', 'pursuit', 'onResourceChange', rp_num, UVResourcePoints )
		end

		UVResourcePoints = tonumber(ResourcePoints)
		-- UVResourcePointsColor = Color( 255, 255, 255, 200)

		-- if UVHUDDisplayBackupTimer then
		-- 	if UVBackupTimerSeconds > 10 then
		-- 		UVResourcePointsColor = Color( 255, 255, 255, 200)
		-- 	elseif math.floor(UVBackupTimerSeconds)==math.Round(UVBackupTimerSeconds) then
		-- 		UVResourcePointsColor = Color( 255, 255, 255, 200)
		-- 	else
		-- 		UVResourcePointsColor = Color( 255, 255, 0, 200)
		-- 	end
		-- end

	end)

	net.Receive("UVHUDBackupTimer", function()

		UVBackupProgress = net.ReadString()
		UVBackupTimerSeconds = tonumber(UVBackupProgress)
		UVBackupTimer = UVDisplayTime(UVBackupProgress)
		UVHUDDisplayBackupTimer = true

	end)

	net.Receive("UVHUDStopBackupTimer", function()

		UVHUDDisplayBackupTimer = nil

	end)

	net.Receive("UVHUDDeploys", function()

		local deploys = net.ReadString()

		if deploys ~= UVDeploys then
			hook.Run( 'UIEventHook', 'pursuit', 'onUnitDeploy', deploys, UVDeploys )
		end

		UVDeploys = deploys

	end)

	net.Receive("UVHUDWrecks", function()

		local wrecks = net.ReadString()

		-- if wrecks ~= UVWrecks then
		-- 	hook.Remove("Think", "UVWrecksColorPulse")
		-- 	if timer.Exists("UVWrecksColorPulseDelay") then timer.Remove("UVWrecksColorPulseDelay") end
		-- 	UVWrecksColor = Color(255,255,0, 150)

		-- 	-- if timer.Exists("UVWrecksColor") then
		-- 	-- 	timer.Remove("UVWrecksColor")
		-- 	-- end

		-- 	timer.Create("UVWrecksColorPulseDelay", 1, 1, function()
		-- 		hook.Add("Think", "UVWrecksColorPulse", function()
		-- 			UVWrecksColor.b = UVWrecksColor.b + 600 * RealFrameTime()
		-- 			if UVWrecksColor.b >= 255 then hook.Remove("Think", "UVWrecksColorPulse") end
		-- 		end)
		-- 	end)

		-- 	-- timer.Create("UVWrecksColor", .3, 1, function()
		-- 	-- 	UVWrecksColor = Colors['White']
		-- 	-- end)
		-- 	-- else
		-- 	-- 	UVTagsColor = Colors['White']
		-- end

		if wrecks ~= UVWrecks then
			hook.Run( 'UIEventHook', 'pursuit', 'onUnitWreck', wrecks, UVWrecks )
		end

		UVWrecks = wrecks

	end)

	net.Receive("UVHUDTags", function()

		local tags = net.ReadString()

		if tags ~= UVTags then
			hook.Run( 'UIEventHook', 'pursuit', 'onUnitTag', wrecks, UVTags )
		end

		UVTags = tags

	end)

	net.Receive("UVHUDTimer", function()

		UVTimerStart = net.ReadString()

		if not UVTimerWhenFroze then
			UVTimerWhenFroze = 0
		end
		if not UVCooldownProgress then
			UVCooldownProgress = 0
		end

		if not UVHUDDisplayCooldown and not UVBustedState then
			if UVTimerFroze then
				UVTimerFroze = nil
			end
		else
			if not UVTimerFroze then
				UVTimerWhenFroze = CurTime()-UVCooldownProgress
				UVTimerFroze = true
			end
		end

		if not UVTimerFroze then
			UVCooldownProgress = UVCooldownProgress
			UVTimerProgress = (CurTime() - tonumber(UVTimerStart)-UVCooldownProgress)
		else
			UVTimerProgress = UVTimerProgress
			UVCooldownProgress = (CurTime() - UVTimerWhenFroze)
		end

		UVTimer = UVDisplayTime(UVTimerProgress)

	end)

	net.Receive("UVHUDTimeTillNextHeat", function()

		local time = net.ReadFloat()
		if not time then return end
		UVTimeTillNextHeat = time

	end)

	net.Receive("UVHUDStopPursuit", function()

		-- net.Start("UVHUDTimeStopped")
		-- net.WriteString(UVTimerProgress)
		-- net.SendToServer()
		UVHUDDisplayPursuit = nil
		UVTimerWhenFroze = 0
		UVCooldownProgress = 0
		UVHUDRaceInProgress = nil

		UVSoundEscaped(UVHeatLevel)

	end)

	net.Receive("UVHUDUpdateBusting", function()
		local ent = net.ReadEntity()
		local progress = net.ReadFloat()

		ent.UVBustingProgress = progress
	end)


	net.Receive("UVHUDBusting", function()
		local lang = language.GetPhrase
		local blink = 255 * math.abs(math.sin(RealTime() * 4))
		local blink2 = 255 * math.abs(math.sin(RealTime() * 6))
		local blink3 = 255 * math.abs(math.sin(RealTime() * 8))
		UVBustingProgress = net.ReadString()
		UVHUDDisplayBusting = true
		UVBustedColor = Color( 255, 255, 255, 50 )
		UVNotification = lang("uv.chase.busting")
		UVBustingTimeLeft = math.Round((BustedTimer:GetFloat()-UVBustingProgress),3)

		if UVBustingTimeLeft <= 0 then
			UVNotification = true
		end

	end)

	net.Receive("UVHUDStopBusting", function()

		UVHUDDisplayBusting = nil
		UVHUDDisplayNotification = nil

	end)

	net.Receive("UVHUDStopBustingTimeLeft", function()

		if not UVHUDDisplayNotification and not UVEnemyBusted and UVBustingTimeLeft < 1 and UVBustingTimeLeft >= 0 then
			UVNotificationColor = Color( 0, 255, 0)
			UVNotification = string.format(language.GetPhrase("uv.chase.evadedtime"), UVBustingTimeLeft)
			UVHUDDisplayNotification = true
			timer.Simple(2, function()
				if not UVHUDDisplayBusting then
					UVHUDDisplayNotification = nil
				end
			end)
		end

	end)

	net.Receive("UVHUDEnemyBusted", function()
		local blink = 255 * math.abs(math.sin(RealTime() * 8))
		UVNotificationColor = Color(255, blink, blink)
		UVBustedColor = Color(255, 0, 0)
		local bustedtext = language.GetPhrase("uv.chase.busted")
		if not UVHUDDisplayNotification then
			if UVHUDRaceInProgress then
				if #UVHUDWantedSuspects <= 1 then
					bustedtext = language.GetPhrase("uv.race.shutdown")
				end
			end
			UVBustedState = true
			UVNotification = "/// " .. bustedtext .. " ///"
			UVHUDDisplayNotification = true
			timer.Simple(5.1, function()
				UVBustedState = false
				UVHUDDisplayNotification = nil
			end)
		end

		if UVHUDDisplayPursuit and not UVPlayingRace then
			UVSoundBusted( UVHeatLevel )
		end
	end)

	net.Receive("UVHUDEvading", function()
		UVHUDDisplayEvading = net.ReadBool()
		UVEvadingProgress = net.ReadString()
	end)

	net.Receive("UVHUDCooldown", function()

		UVCooldownTimer = net.ReadString()
		UVHUDDisplayCooldown = true

	end)

	net.Receive("UVHUDStopCooldown", function()

		UVHUDDisplayCooldown = nil

	end)

	net.Receive("UVHUDHiding", function()
		local blink = 255 * math.abs(math.sin(RealTime() * 6))
		if UVHUDCopMode then return end
		UVNotificationColor = Color( blink, blink, 255)
		UVNotification = "--- " .. language.GetPhrase("uv.chase.hiding") .. " ---"
		UVHUDDisplayNotification = true
		UVHUDDisplayHidingPrompt = true

	end)

	net.Receive("UVHUDStopHiding", function()

		UVHUDDisplayNotification = nil
		UVHUDDisplayHidingPrompt = nil

	end)

	-- net.Receive("UVHUDWantedSuspects", function()

	-- 	-- UVHUDWantedSuspects = net.ReadTable() or {}
	-- 	-- UVHUDWantedSuspectsNumber = #UVHUDWantedSuspects

	-- 	-- if UVHUDWantedSuspectsNumber > 1 then
	-- 	-- 	if not UVHUDRaceInProgress then
	-- 	-- 		UVHUDRaceInProgress = true
	-- 	-- 	end
	-- 	-- end

	-- end)

	net.Receive("UVHUDCopMode", function()
		UVHUDCopMode = true
	end)

	net.Receive("UVHUDStopCopMode", function()
		UVHUDCopMode = nil
	end)

	net.Receive("UVHUDCopModeBusting", function()
		local enemy = net.ReadEntity()
		enemy.beingbusted = true
	end)

	net.Receive("UVHUDStopCopModeBusting", function()
		local enemy = net.ReadEntity()
		enemy.beingbusted = nil
	end)

	net.Receive("UVHUDOneCommander", function()
		UVHUDCommander = net.ReadEntity()
		if UVHUDCommander.IsGlideVehicle then 
			if UVHUDCommander.MaxChassisHealth ~= UVUOneCommanderHealth:GetInt() then
				UVHUDCommander.MaxChassisHealth = UVUOneCommanderHealth:GetInt()
			end
		end
		if not UVOneCommanderActive and IsValid(UVHUDCommander) then
			UVOneCommanderActive = true
			local MathSound = math.random(1,6)
			surface.PlaySound("ui/pursuit/commanderonscene/commanderonscene"..MathSound..".wav")
		end
	end)

	net.Receive("UVHUDStopOneCommander", function()
		UVOneCommanderActive = nil
	end)

	net.Receive("UVHUDHeatLevelIncrease", function()
		UVHeatLevelIncrease = true

		if not UVPlayingRace then
			UVStopSound()
		end

		timer.Simple(0.1, function()
			UVHeatLevelIncrease = nil
		end)
	end)

	net.Receive("UVHUDPursuitTech", function()
		local PursuitTech = net.ReadTable()
		UVHUDPursuitTech = PursuitTech
	end)

	net.Receive("UVHUDScanner", function()
		local posx = net.ReadInt(32)
		local posy = net.ReadInt(32)
		local posz = net.ReadInt(32)

		UVHUDScanner = true
		UVHUDScannerPos.x = posx
		UVHUDScannerPos.y = posy
		UVHUDScannerPos.z = posz
	end)

	net.Receive("UVHUDAddUV", function()
		local entIndex = net.ReadInt( 32 )
		local creationId = net.ReadInt( 32 )

		table.insert( EntityQueue, {
			entIndex = entIndex,
			creationId = creationId,
			entType = net.ReadString()
		} )
		-- EntityQueue[entIndex] = {
		-- 	creationId,
		-- 	net.ReadString()
		-- }
		-- local unitindex = net.ReadInt(32)
		-- local typestring = net.ReadString()
		-- local unit = Entity(unitindex)

		-- if not GMinimap then return end

		-- if not IsValid(unit) then
		-- 	net.Start("UVHUDReAddUV")
		-- 	net.WriteInt(unitindex, 32)
		-- 	net.WriteString(typestring)
		-- 	net.SendToServer()
		-- 	return
		-- end

		-- if typestring == "unit" then
		-- 	local blip, id = GMinimap:AddBlip( {
		-- 		id = "UVBlip"..unit:EntIndex(),
		-- 		parent = unit,
		-- 		icon = "unitvehicles/icons/MINIMAP_ICON_CAR.png",
		-- 		scale = 1.4,
		-- 		color = Color( 150, 0, 0),
		-- 		alpha = 0
		-- 	} )
		-- 	if unit:GetClass() == "prop_vehicle_jeep" then
		-- 		blip.icon = "unitvehicles/icons/MINIMAP_ICON_CAR_JEEP.png" -- Icon points the other way
		-- 	end

		-- 	table.insert( UnitTable, unit )

		-- 	local created = false
		-- 	local flashwhite = false
		-- 	timer.Simple(0.1, function()
		-- 		blip.alpha = 255
		-- 		timer.Create( "flashingblip"..id, 0.05, 0, function()
		-- 			if flashwhite and UVHUDDisplayPursuit or blip.disabled then
		-- 				blip.color = Color( 255, 255, 255)
		-- 				flashwhite = false
		-- 			elseif created and UVHUDDisplayPursuit and not blip.disabled then
		-- 				blip.color = Color( 0, 0, 255)
		-- 				created = false
		-- 				flashwhite = true
		-- 			else
		-- 				blip.color = Color( 150, 0, 0)
		-- 				created = true
		-- 				if UVHUDDisplayPursuit then
		-- 					flashwhite = true
		-- 				end
		-- 			end
		-- 			if not IsValid(blip.parent) then
		-- 				timer.Remove("flashingblip"..id)
		-- 			end
		-- 		end )
		-- 	end)
		-- elseif typestring == "air" then
		-- 	local blip, id = GMinimap:AddBlip( {
		-- 		id = "UVBlip"..unit:EntIndex(),
		-- 		parent = unit,
		-- 		icon = "unitvehicles/icons/HELICOPTER_MINIMAP_ICON.png",
		-- 		scale = 2,
		-- 		color = Color( 150, 0, 0),
		-- 		alpha = 0
		-- 	} )
		-- 	local created = false
		-- 	local flashwhite = false
		-- 	blip.alpha = 255
		-- 	timer.Simple(0.1, function()
		-- 		blip.alpha = 255
		-- 		timer.Create( "flashingblip"..id, 0.05, 0, function()
		-- 			if flashwhite and UVHUDDisplayPursuit then
		-- 				blip.color = Color( 255, 255, 255)
		-- 				flashwhite = false
		-- 			elseif created and UVHUDDisplayPursuit then
		-- 				blip.color = Color( 0, 0, 255)
		-- 				created = false
		-- 				flashwhite = true
		-- 			else
		-- 				blip.color = Color( 150, 0, 0)
		-- 				created = true
		-- 				if UVHUDDisplayPursuit then
		-- 					flashwhite = true
		-- 				end
		-- 			end
		-- 			if not IsValid(blip.parent) then
		-- 				timer.Remove("flashingblip"..id)
		-- 			end
		-- 		end )
		-- 	end)
		-- elseif typestring == "roadblock" then
		-- 	local blip, id = GMinimap:AddBlip( {
		-- 		id = "UVBlip"..unit:EntIndex(),
		-- 		parent = unit,
		-- 		icon = "unitvehicles/icons/MINIMAP_ICON_ROADBLOCK.png",
		-- 		scale = 1.4,
		-- 		color = Color( 255, 255, 0),
		-- 		alpha = 0
		-- 	} )
		-- 	timer.Simple(0.1, function()
		-- 		blip.alpha = 255
		-- 	end)
		-- elseif typestring == "repairshop" then
		-- 	local blip, id = GMinimap:AddBlip( {
		-- 		id = "UVBlip"..unit:EntIndex(),
		-- 		parent = unit,
		-- 		icon = "unitvehicles/icons/repairshop.png",
		-- 		scale = 2,
		-- 		color = Color( 0, 255, 0),
		-- 		alpha = 0,
		-- 		lockIconAng = true
		-- 	} )
		-- 	timer.Simple(0.1, function()
		-- 		blip.alpha = 255
		-- 	end)
		-- end

	end)

	net.Receive("UVHUDRemoveUV", function()
		local entIndex = net.ReadInt(32)
		local creationId = net.ReadInt(32)

		table.insert(CleanupTask, {
			entIndex,
			creationId,
			function( entIndex, creationId )
				local entity = Entity( entIndex )

				if not IsValid(entity) then return true end
				if entity:GetCreationID() ~= creationId then return end

				if ent then
					table.RemoveByValue( UnitTable, ent )
				end

				if GMinimap then
					local blip = GMinimap:FindBlipByID("UVBlip" .. entIndex)
					if not blip then return end

					blip.color = Color( 255, 255, 255)
					blip.disabled = true
				end

				return true
			end
		})
	end)

	local corner8tex, corner32tex = surface.GetTextureID("gui/corner8"), surface.GetTextureID("gui/corner32")
	local function drawCircle(x, y, radius, seg)
		surface.SetTexture(radius <= 8 and corner8tex or corner32tex)
		surface.DrawTexturedRectUV( x-radius, y-radius, radius, radius, 0, 0, 1, 1 )
		surface.DrawTexturedRectUV( x, y-radius, radius, radius, 1, 0, 0, 1 )
		surface.DrawTexturedRectUV( x-radius, y, radius, radius, 0, 1, 1, 0 )
		surface.DrawTexturedRectUV( x, y, radius, radius, 1, 1, 0, 0 )
		draw.NoTexture()
	end

	hook.Add( "CanSeePlayerBlip", "RestrictPlayerBlipsExample", function( ply )
		if UVHUDCopMode then
			return false
		end
		return not UVHUDDisplayPursuit
	end )

	outofpursuit = 0

	hook.Add("Think", "UVThink", function()

		local localPlayer = LocalPlayer()
		local vehicle = localPlayer:GetVehicle()

		local var = UVKeybindSkipSong:GetInt()

		if input.IsKeyDown(var) and not gui.IsGameUIVisible() and vgui.GetKeyboardFocus() == nil then
			localPlayer:ConCommand('uv_skipsong')
		end

		for i, v in pairs( EntityQueue ) do
			if InitEntity( v.entIndex, v.creationId, v.entType ) then
				table.remove( EntityQueue, i )
			end
		end

		for i, array in pairs( CleanupTask ) do
			if array[3]( array[1], array[2] ) then
				table.remove( CleanupTask, i )
			end
		end

		if (not UVHUDDisplayPursuit) and ((not UVHUDDisplayRacing) or (not UVHUDRace)) then
			if not UVHUDRace and UVTraxFreeroam:GetBool() and vehicle ~= NULL then
				UVSoundRacing()
			else
				UVStopSound()

				UVHUDDisplayBackupTimer = nil
				UVLoadedSounds = nil

				if UVSoundLoop then
					UVSoundLoop:Stop()
					UVSoundLoop = nil
				end
			end
		elseif UVHUDDisplayPursuit and not PlayMusic:GetBool() and not RacingMusic:GetBool() then
			UVStopSound()
			if UVSoundLoop then
				UVSoundLoop:Stop()
				UVSoundLoop = nil
			end
		end

		if vehicle == NULL then 
			UVHUDDisplayBusting = false
			UVHUDPursuitTech = nil
			return 
		end

		if UVHUDDisplayPursuit then
			if not UVCooldownProgress then UVCooldownProgress = 0 end

			if UVHUDDisplayCooldown or UVBustedState then
				if not UVTimerFroze then
					UVTimerWhenFroze = CurTime() - UVCooldownProgress
					UVTimerFroze = true
				end
			else
				UVTimerFroze = false
			end

			if not UVTimerFroze and PursuitTable.PursuitStart then
				UVTimerProgress = CurTime() - tonumber( PursuitTable.PursuitStart ) - UVCooldownProgress
			else
				UVCooldownProgress = CurTime() - UVTimerWhenFroze
			end
		else
			UVHeatPlayIntro = true 
			-- UVHeatPlayTransition = false 
			-- UVHeatPlayMusic = false
		end

		UVHUDWantedSuspectsNumber = #UVHUDWantedSuspects

		UVHUDDisplayPursuit = PursuitTable.InPursuit
		--UVHUDDisplayCooldown = PursuitTable.InCooldown
		UVHeatLevel = PursuitTable.Heat
		UVUnitsChasing = PursuitTable.UnitsChasing
		UVResourcePoints = PursuitTable.ResourcePoints
		UVDeploys = PursuitTable.Deploys
		UVPursuitLength = PursuitTable.PursuitLength
		UVWrecks = PursuitTable.Wrecks
		UVTags = PursuitTable.Tags
		UVBounty = string.Comma( PursuitTable.Bounty )
		UVBountyNo = PursuitTable.Bounty
		UVTimer = (UVTimerProgress and UVDisplayTime( UVTimerProgress )) or UVDisplayTime( 0 )

		if not UVBustedState then
			if UVHUDDisplayPursuit then
				if not UVHUDDisplayBusting and not UVHUDDisplayCooldown and not UVHUDDisplayNotification then
					UVSoundHeat( UVHeatLevel )
				elseif UVHUDDisplayCooldown then
					UVSoundCooldown( UVHeatLevel )
				elseif UVHUDDisplayBusting and (UVHUDCopMode and UVHUDWantedSuspectsNumber == 1) or not UVHUDCopMode then
					local UVBustTimer = BustedTimer:GetFloat()
					local timeLeft = ((UVHUDDisplayNotification and -1) or (UVBustTimer - UVBustingProgress))

					if timeLeft <= UVBustTimer * 0.7 then
						UVSoundBusting( UVHeatLevel )
					end
				end
			elseif UVPlayingEvading or UVPlayingHiding or UVPlayingCooldown then
				UVStopSound()
			end
		end
	end)

	hook.Add( "HUDPaint", "UVHUDPursuit", function() --HUD

		local localPlayer = LocalPlayer()
		local vehicle = localPlayer:GetVehicle()

		local w = ScrW()
		local h = ScrH()

		local hudyes = showhud:GetBool()
		local lang = language.GetPhrase
		
		local main = UVHUDTypeMain:GetString()
		local backup = UVHUDTypeBackup:GetString()

		local hudHandler = UV_UI.pursuit[main] and UV_UI.pursuit[main].main

		if not hudHandler then
			hudHandler = UV_UI.pursuit[backup] and UV_UI.pursuit[backup].main
		end

		if hudHandler then
			hudHandler()
		end

		if UV_UI.general then
			UV_UI.general.main()
		end

		if UVHUDDisplayPursuit and vehicle ~= NULL then
			if UVOneCommanderActive and hudyes then
				if IsValid(UVHUDCommander) then
					UVRenderCommander(UVHUDCommander)
				end
			end
		end

		local entities = ents.GetAll()
		local box_color = Color(0, 255, 0)

		if not RacerTags:GetBool() or uvclientjammed then
			if GMinimap then
				for _, ent in pairs(UVHUDWantedSuspects) do
					if ent.displayedonhud then
						local curblip = GMinimap:FindBlipByID("UVBlip"..ent:EntIndex())

						if curblip then 
							curblip.alpha = 0
						end
					end
				end
			end
		end

		-- if RacerTags:GetBool() and UVHUDWantedSuspects and UVHUDCopMode and not uvclientjammed then
		if RacerTags:GetBool() and UVHUDWantedSuspects and not uvclientjammed and not UVHUDRace then
			if next(UVHUDWantedSuspects) ~= nil then
				local renderQueue = {}

				for _, ent in pairs(UVHUDWantedSuspects) do
					if not IsValid(ent) then continue end
					if ent:IsVehicle() and ent:GetDriver() == LocalPlayer() then continue end
					local dist = LocalPlayer():GetPos():Distance(ent:GetPos())
					table.insert(renderQueue, { vehicle = ent, dist = dist })
				end
				-- Sort so farther ones draw first, closer ones last (on top)
				table.sort(renderQueue, function(a, b)
					return a.dist < b.dist
				end)

				local maxSquares = 4
				local numToRender = math.min(#renderQueue, maxSquares)

				-- Render farthest first so closest overlays on top
				for i = numToRender, 1, -1 do
					local data = renderQueue[i]
					if data and IsValid(data.vehicle) then
						UVRenderEnemySquare(data.vehicle)
					end
				end

				-- Handle minimap blips *after* rendering
				-- if UVHUDCopMode then -- Only as a Cop
					for _, ent in pairs(UVHUDWantedSuspects) do
						if not IsValid(ent) then continue end

						if not GMinimap then continue end
						if not ent.displayedonhud then
							ent.displayedonhud = true
							local blip, id = GMinimap:AddBlip({
								id = "UVBlip" .. ent:EntIndex(),
								parent = ent,
								icon = "unitvehicles/icons/MINIMAP_ICON_CAR.png",
								scale = 1.4,
								color = Color(255, 191, 0),
							})
							if ent:GetClass() == "prop_vehicle_jeep" then
								blip.icon = "unitvehicles/icons/MINIMAP_ICON_CAR_JEEP.png" -- Icon points the other way
							end
						end
						
						if UVHUDCopMode and ent.displayedonhud then-- *This* only for Units
							local curblip = GMinimap:FindBlipByID("UVBlip" .. ent:EntIndex())
							if not curblip then continue end

							if UVHUDDisplayCooldown or 
								(UVHUDCopMode and 
									(tonumber(UVUnitsChasing) <= 0 or not ent.inunitview) and 
									not ((not GetConVar("unitvehicle_unit_onecommanderevading"):GetBool()) and UVOneCommanderActive)) 
							then
								curblip.alpha = 0
							else
								curblip.alpha = 255
							end
						end
					end
				-- end
			end
		end

		if UVHUDRoadblocks then
			if next(UVHUDRoadblocks) ~= nil then
				for _, roadblock in pairs(UVHUDRoadblocks) do
					if roadblock.location and roadblock.name then
						UVRenderRoadblock(roadblock.location, roadblock.name)
					end
				end
			end
		end

		if UVHUDPursuitBreakers then
			if next(UVHUDPursuitBreakers) ~= nil then
				for _, pos in pairs(UVHUDPursuitBreakers) do
					UVRenderPursuitBreaker(pos)
				end
			end
		end

		if UVHUDMarkedPursuitBreakers then
			if next(UVHUDMarkedPursuitBreakers) ~= nil then
				for _, pb in pairs(UVHUDMarkedPursuitBreakers) do
					if pb.location and pb.name then
						UVRenderMarkedPursuitBreaker(pb.location, pb.name)
					end
				end
			end
		end

		local areUnitsPresent = (#UnitTable > 0)

		--Police Scanner
		if (not UVHUDDisplayPursuit or UVHUDDisplayCooldown) and not UVHUDCopMode and not uvclientjammed and localPlayer:InVehicle() and areUnitsPresent then
			-- Get closest unit

			local enemypos = localPlayer:GetPos()
			local closestdistancetounit = math.huge
			local found = false

			for _, v in pairs(UnitTable) do
				if IsValid(v) then
					found = true
					local unitPos = v:GetPos()
					local dist = unitPos:DistToSqr(enemypos)

					if closestdistancetounit > dist then
						closestdistancetounit = dist
						UVHUDScannerPos = unitPos
					end
				end
			end

			if found then
				local closestdistancetounit = UVHUDScannerPos:DistToSqr(enemypos)
				surface.SetDrawColor( 0, 0, 0, 200)
				drawCircle( w/2, h/10, 30, 50 )
				local beepfrequency = math.Clamp(math.sqrt(closestdistancetounit/100000000),0.1,1)
				if beepfrequency >= 1 then
					surface.SetDrawColor( 0, 0, 0, 200)
					drawCircle( w/2, h/10, 14, 50 )
				else
					surface.SetDrawColor(255,255,255,255)
					drawCircle( w/2, h/10, 14, 50 )

					local angle = math.rad(math.AngleDifference(EyeAngles().y, (enemypos-UVHUDScannerPos):Angle().y)) + 1.57--(math.pi/2)
					local radius = 25
					local centerx = w/2
					local centery = h/10

					local triangle = {
						{ x = radius*math.cos(angle) + centerx, y = radius*math.sin(angle) + centery },
						{ x = (radius-12)*math.cos(angle-5.5) + centerx, y = (radius-12)*math.sin(angle-5.5) + centery },
						{ x = (radius-12)*math.cos(angle+5.5) + centerx, y = (radius-12)*math.sin(angle+5.5) + centery }
					}
					draw.NoTexture()
					surface.DrawPoly( triangle )
					local beepcolor
					local botimeout = 10
					if UVHUDBlipSoundTime < CurTime() and beepfrequency < 1 then
						UVHUDBlipSoundTime = CurTime() + beepfrequency
						surface.PlaySound(UVHUDBlipSound)
						UVHUDBeeping = true
						timer.Simple(beepfrequency/2, function()
							UVHUDBeeping = false
						end)
					end
					if UVHUDBeeping then
						beepcolor = Color(0,255,0)
					else
						beepcolor = Color(0,0,0)
					end
					surface.SetDrawColor(beepcolor)
					drawCircle( w/2, h/10, 8, 50 )
				end
			end
		elseif UVHUDDisplayCooldown and not UVHUDCopMode then
			surface.SetDrawColor( 0, 0, 0, 200)
			drawCircle( w/2, h/10, 30, 50 )
			drawCircle( w/2, h/10, 14, 50 )
		end

	end)

	function UVMarkAllLocationsPB()
		if not UVHUDMarkedPursuitBreakers then
			UVHUDMarkedPursuitBreakers = {}
		else
			if next(UVHUDMarkedPursuitBreakers) ~= nil then
				return
			end
		end

		local saved_pbs = file.Find("unitvehicles/pursuitbreakers/"..game.GetMap().."/*.json", "DATA")
		for k,jsonfile in pairs(saved_pbs) do
			local JSONData = file.Read( "unitvehicles/pursuitbreakers/"..game.GetMap().."/"..jsonfile, "DATA" )
			if not JSONData then return end

			local rbdata = util.JSONToTable(JSONData, true) --Load PB

			local name = jsonfile
			local location = rbdata.Location or rbdata.Maxs
			if not location then return end

			local tabletoinsert = {}
			tabletoinsert.location = location
			tabletoinsert.name = name

			table.insert(UVHUDMarkedPursuitBreakers, tabletoinsert)

			timer.Simple(10, function()
				if not UVHUDMarkedPursuitBreakers then return end
				UVHUDMarkedPursuitBreakers = {}
			end)

		end
	end

	function UVMarkAllLocations()
		if not UVHUDRoadblocks then
			UVHUDRoadblocks = {}
		else
			if next(UVHUDRoadblocks) ~= nil then
				return
			end
		end

		local saved_roadblocks = file.Find("unitvehicles/roadblocks/"..game.GetMap().."/*.json", "DATA")
		for k,jsonfile in pairs(saved_roadblocks) do
			local JSONData = file.Read( "unitvehicles/roadblocks/"..game.GetMap().."/"..jsonfile, "DATA" )
			if not JSONData then return end

			local rbdata = util.JSONToTable(JSONData, true) --Load Roadblock

			local name = jsonfile
			local location = rbdata.Location or rbdata.Maxs
			if not location then return end

			local tabletoinsert = {}
			tabletoinsert.location = location
			tabletoinsert.name = name

			table.insert(UVHUDRoadblocks, tabletoinsert)

			timer.Simple(10, function()
				if not UVHUDRoadblocks then return end
				UVHUDRoadblocks = {}
			end)

		end
	end

	function UVRenderRoadblock(pos, name)
		local localPlayer = LocalPlayer()
		local box_color = Color(255, 255, 0)

		if IsValid(localPlayer) then
			local pos = pos

			local MaxX, MinX, MaxY, MinY
			local isVisible = false

			local p = pos
			local screenPos = p:ToScreen()
			isVisible = screenPos.visible

			if MaxX ~= nil then
				MaxX, MaxY = math.max(MaxX, screenPos.x), math.max(MaxY, screenPos.y)
				MinX, MinY = math.min(MinX, screenPos.x), math.min(MinY, screenPos.y)
			else
				MaxX, MaxY = screenPos.x, screenPos.y
				MinX, MinY = screenPos.x, screenPos.y
			end

			local textX = (MinX + MaxX) / 2
			local textY = MinY - 20
			cam.Start2D()
			draw.DrawText(name.."\nv", "UVFont4", textX, textY - 30, box_color, TEXT_ALIGN_CENTER)
			cam.End2D()
		end
	end

	function UVRenderPursuitBreaker(pos)
		local localPlayer = LocalPlayer()
		local box_color = Color(255, 0, 0)

		if IsValid(localPlayer) then
			local pos = pos

			local MaxX, MinX, MaxY, MinY
			local isVisible = false

			local p = pos
			local screenPos = p:ToScreen()
			isVisible = screenPos.visible

			if MaxX ~= nil then
				MaxX, MaxY = math.max(MaxX, screenPos.x), math.max(MaxY, screenPos.y)
				MinX, MinY = math.min(MinX, screenPos.x), math.min(MinY, screenPos.y)
			else
				MaxX, MaxY = screenPos.x, screenPos.y
				MinX, MinY = screenPos.x, screenPos.y
			end

			local textX = (MinX + MaxX) / 2
			local textY = MinY - 20
			cam.Start2D()
			draw.DrawText("⛛", "UVFont4", textX, textY - 30, box_color, TEXT_ALIGN_CENTER)
			cam.End2D()
		end
	end

	function UVRenderMarkedPursuitBreaker(pos, name)
		local localPlayer = LocalPlayer()
		local box_color = Color(255, 0, 0)

		if IsValid(localPlayer) then
			local pos = pos

			local MaxX, MinX, MaxY, MinY
			local isVisible = false

			local p = pos
			local screenPos = p:ToScreen()
			isVisible = screenPos.visible

			if MaxX ~= nil then
				MaxX, MaxY = math.max(MaxX, screenPos.x), math.max(MaxY, screenPos.y)
				MinX, MinY = math.min(MinX, screenPos.x), math.min(MinY, screenPos.y)
			else
				MaxX, MaxY = screenPos.x, screenPos.y
				MinX, MinY = screenPos.x, screenPos.y
			end

			local textX = (MinX + MaxX) / 2
			local textY = MinY - 20
			cam.Start2D()
			draw.DrawText(name.."\nv", "UVFont4", textX, textY - 30, box_color, TEXT_ALIGN_CENTER)
			cam.End2D()
		end
	end

	net.Receive( "UV_AddWantedVehicle", function()
		local entIndex = net.ReadInt( 32 )
		local creationId = net.ReadInt( 32 )

		-- EntityQueue[entIndex] = {
		-- 	creationId,
		-- 	'racer'
		-- }
		table.insert( EntityQueue, {
			entIndex = entIndex,
			creationId = creationId,
			entType = "racer"
		} )
	end)

	net.Receive( "UV_RemoveWantedVehicle", function()
		local entIndex = net.ReadInt( 32 )
		local entity = Entity( entIndex )

		if entity then
			table.RemoveByValue( UVHUDWantedSuspects, entity )
		end
	end)

	net.Receive( "UVUpdateSuspectVisibility" , function()
		local car = net.ReadEntity()
		local in_view = net.ReadBool()

		car.inunitview = in_view
	end)

	net.Receive( "UVRacerJoin" , function()
		local message = net.ReadString()
		chat.AddText(Color(127, 255, 159), message)
	end)

	net.Receive("UVHUDBustedDebrief", function()
		local bustedtable = net.ReadTable()
		if UVHUDCopMode then return end
		hook.Run( 'UIEventHook', 'pursuit', 'onRacerBustedDebrief', bustedtable )

		timer.Simple(5, function()
			UVHUDDisplayBusting = false
			UVHUDDisplayNotification = false
		end)
	end)

	net.Receive("UVHUDEscapedDebrief", function()
		local escapedtable = net.ReadTable()
		if UVHUDCopMode then return end
		hook.Run( 'UIEventHook', 'pursuit', 'onRacerEscapedDebrief', escapedtable )
	end)

	net.Receive("UVHUDCopModeEscapedDebrief", function()
		local escapedtable = net.ReadTable()
		hook.Run( 'UIEventHook', 'pursuit', 'onCopEscapedDebrief', escapedtable )
	end)

	net.Receive("UVHUDCopModeBustedDebrief", function()
		local bustedtable = net.ReadTable()
		hook.Run( 'UIEventHook', 'pursuit', 'onCopBustedDebrief', bustedtable )
	end)

	net.Receive( "UVUpdateRacerName" , function()
		local racer_vehicle = net.ReadEntity()
		local racer_name = net.ReadString()

		racer_vehicle.racer = racer_name
	end)

	net.Receive('UV_Sound', function()
		local array = net.ReadTable()

		local audio_file = "sound/"..array.FileName
		local parameters = array.Parameter
		local can_skip = array.CanSkip

		if can_skip and IsValid(uvsoundplaying) and parameters ~= 2 then
			uvsoundplaying:Stop()
		end

		sound.PlayFile(audio_file, "", function(source, err, errname)
			if IsValid(source) then
				if not can_skip then
					uvsoundplaying = source
				end
				source:Play()
			end
		end)
	end)

	net.Receive('UV_Chatter', function()
		local array = net.ReadTable()

		local audio_file = "sound/"..array.FileName
		local can_skip = array.CanSkip

		if can_skip and IsValid(uvchatterplaying) and parameters ~= 2 then
			uvchatterplaying:Stop()
		end

		sound.PlayFile(audio_file, "", function(source, err, errname)
			if IsValid(source) then
				uvchatterplaying = source
				source:Play()
			end
		end)
	end)


	net.Receive('UVBusted', function()
		local array = net.ReadTable()

		local racer = array['Racer']
		local cop = array['Cop']
		local lp = false

		if racer == LocalPlayer():GetName() then lp = true end

		hook.Run( 'UIEventHook', 'pursuit', 'onRacerBusted', racer, cop, lp )
	end)

	net.Receive("UVHUDWreckedDebrief", function()
	    if IsValid(TotaledPanel) then TotaledPanel:Remove() end
        
		local w = ScrW()
		local h = ScrH()

		local Yes = vgui.Create("DButton")
		local No = vgui.Create("DButton")

		TotaledPanel = vgui.Create("DPanel", vgui.GetWorldPanel())
		TotaledPanel:Add(Yes)
		TotaledPanel:Add(No)
		TotaledPanel:SetSize(w, h)
        TotaledPanel:SetMouseInputEnabled(true)
        TotaledPanel:SetKeyboardInputEnabled(false)
        TotaledPanel:SetZPos(32767)

		Yes:SetText("")
		Yes:SetPos(w*0.3, h*0.6)
		Yes:SetSize(w*0.4, h*0.07)
        Yes.Paint = function() end
		
		No:SetText("")
		No:SetPos(w*0.3, h*0.7)
		No:SetSize(w*0.4, h*0.07)
        No.Paint = function() end
		
		surface.DrawTexturedRect( w*0.3, h*0.6, w * 0.4, h*0.07)
		surface.DrawTexturedRect( w*0.3, h*0.7, w * 0.4, h*0.07)

        local targetY = 0
        local overshootY = h * 0.1  -- drops 10% below target before bouncing back
        local startY = -h           -- start fully above the screen
        
        TotaledPanel:SetPos(0, startY)
        
        local animTime = 0.33
        local bounceTime = 0.1
        local startTime = CurTime()
        
        hook.Add("Think", "TotaledPanelEntranceAnim", function()
            local elapsed = CurTime() - startTime
            
            if elapsed < animTime then
                if elapsed < animTime - bounceTime then
                    local frac = elapsed / (animTime - bounceTime)
                    local y = Lerp(frac, startY, overshootY)
                    TotaledPanel:SetPos(0, y)
                else
                    local frac = (elapsed - (animTime - bounceTime)) / bounceTime
                    local y = Lerp(frac, overshootY, targetY)
                    TotaledPanel:SetPos(0, y)
                end
            else
                TotaledPanel:SetPos(0, targetY)
                hook.Remove("Think", "TotaledPanelEntranceAnim")
            end
        end)
        
        local function AnimateAndRemovePanel(panel)
            if not IsValid(panel) then return end
            
            local startY = panel:GetY()
            local endY = ScrH()  -- off-screen below
            local animTime = 0.33
            local startTime = CurTime()
            
            -- Play sounds ONCE at start
            -- surface.PlaySound("uvui/carbon/openmenu.wav")
            -- surface.PlaySound("uvui/carbon/exitmenu.wav")
            
            -- Disable interactivity
            panel:SetMouseInputEnabled(false)
            gui.EnableScreenClicker(false)
			Yes:SetEnabled(false)
			No:SetEnabled(false)
            
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

        local timetotal = 10
        local timestart = CurTime()
        local exitStarted = false -- prevent repeated trigger

		TotaledPanel.Paint = function(self, w, h)
			local timeremaining = math.ceil(timetotal - (CurTime() - timestart))
			local lang = language.GetPhrase

            -- Upper Background and Icons
            surface.SetDrawColor( 0, 0, 0, 200 )
            surface.DrawRect( w*0.25, h*0.185, w*0.5, h*0.075)

            DrawIcon( UVMaterials['UNITS_DISABLED'], w*0.275, h*0.22, 0.11, Color(255, 255, 255) ) -- Left Icon
            DrawIcon( UVMaterials['UNITS_DISABLED'], w*0.725, h*0.22, 0.11, Color(255, 255, 255) ) -- Right Icon
            draw.DrawText( "#uv.chase.wrecked", "UVFont5", w * 0.5, h * 0.2, Color(255, 255, 255), TEXT_ALIGN_CENTER)
			
			-- Main Background and Text
			surface.SetDrawColor( 0, 0, 0, 235 )
            surface.DrawRect( w*0.25, h*0.265, w*0.5, h*0.6)
            			
			draw.SimpleTextOutlined( "#uv.chase.wrecked.text1", "UVFont5", w * 0.5, h * 0.3, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1.25, Color( 0, 0, 0 ) )
			draw.SimpleTextOutlined( "#uv.chase.wrecked.text2", "UVFont5", w * 0.5, h * 0.375, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1.25, Color( 0, 0, 0 ) )
			draw.SimpleTextOutlined( "#uv.chase.wrecked.text3", "UVFont5", w * 0.5, h * 0.45, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1.25, Color( 0, 0, 0 ) )
						
            surface.SetDrawColor( 255, 255, 255 )
			surface.SetMaterial(UVMaterials["RESULTS_UG2_BUTTON"])
			surface.DrawTexturedRect( w*0.3, h*0.6, w * 0.4, h*0.07)
			surface.DrawTexturedRect( w*0.3, h*0.7, w * 0.4, h*0.07)
			
			draw.SimpleTextOutlined( "[ " .. UVBindButton("+jump") .. " ] " .. lang("uv.chase.wrecked.rejoin"), "UVFont5", w * 0.5, h * 0.61, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1.25, Color( 0, 0, 0 ) )

			draw.SimpleTextOutlined( "#uv.chase.wrecked.abandon", "UVFont5", w * 0.5, h * 0.71, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1.25, Color( 0, 0, 0 ) )

            draw.SimpleTextOutlined( string.format( language.GetPhrase("uv.results.autoclose"), math.max(0, timeremaining) ), "UVFont5", w*0.5, h*0.78, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1.25, Color(0, 0, 0) )

            if not exitStarted and timeremaining < 1 then
                exitStarted = true
                hook.Remove("CreateMove", "JumpKeyCloseTotaled")
                AnimateAndRemovePanel(TotaledPanel)
            end
            
		end

		function Yes:DoClick()
			hook.Remove("CreateMove", "JumpKeyCloseTotaled")
            AnimateAndRemovePanel(TotaledPanel)
			
			surface.PlaySound( "ui/redeploy/redeploy" .. math.random(1, 4) .. ".wav" )
			net.Start("UVHUDRespawnInUV")
			net.SendToServer()
		end
		
		function No:DoClick()
			hook.Remove("CreateMove", "JumpKeyCloseTotaled")
            AnimateAndRemovePanel(TotaledPanel)
		end
        
		hook.Add("CreateMove", "JumpKeyCloseTotaled", function()
			local ply = LocalPlayer()
			if not IsValid(ply) then return end

			if ply:KeyPressed(IN_JUMP) then
				if IsValid(TotaledPanel) then
					hook.Remove("CreateMove", "JumpKeyCloseTotaled")
					AnimateAndRemovePanel(TotaledPanel)

					surface.PlaySound("ui/redeploy/redeploy" .. math.random(1, 4) .. ".wav")
					net.Start("UVHUDRespawnInUV")
					net.SendToServer()
				end
			end
		end)

	end)

	hook.Add("PopulateToolMenu", "UVMenu", function()
		spawnmenu.AddToolMenuOption("Options", "uv.settings.unitvehicles", "UVServerOptions", "#uv.settings.server", "", "", function(panel)
			panel:Clear()

			panel:Button("#spawnmenu.savechanges", "uv_local_update_settings")

			panel:Help("#uv.settings.heatlevels")
			panel:CheckBox("#uv.settings.heatlevels.enable", "unitvehicle_heatlevels")
			panel:ControlHelp("#uv.settings.heatlevels.enable.desc")
			panel:CheckBox("#uv.settings.heatlevels.aiunits", "unitvehicle_spawnmainunits")
			panel:ControlHelp("#uv.settings.heatlevels.aiunits.desc")
			panel:NumSlider("#uv.settings.heatlevels.min", "unitvehicle_minheatlevel", 1, MAX_HEAT_LEVEL, 0)
			panel:ControlHelp("#uv.settings.heatlevels.min.desc")
			panel:NumSlider("#uv.settings.heatlevels.max", "unitvehicle_maxheatlevel", 1, MAX_HEAT_LEVEL, 0)
			panel:ControlHelp("#uv.settings.heatlevels.max.desc")

			panel:Help("#uv.settings.targetvehicle")
			panel:NumSlider("#uv.settings.targetvehicle.target", "unitvehicle_targetvehicletype", 1, 3, 0)
			panel:ControlHelp("#uv.settings.targetvehicle.target.desc")

			panel:Help("#uv.settings.pursuit")
			panel:CheckBox("#uv.settings.pursuit.autohealth", "unitvehicle_autohealth")
			panel:ControlHelp("#uv.settings.pursuit.autohealth.desc")
			panel:NumSlider("#uv.settings.pursuit.repaircooldown", "unitvehicle_repaircooldown", 5, 300, 0)
			panel:ControlHelp("#uv.settings.pursuit.repaircooldown.desc")
			panel:NumSlider("#uv.settings.pursuit.repairrange", "unitvehicle_repairrange", 10, 1000, 0)
			panel:ControlHelp("#uv.settings.pursuit.repairrange.desc")
			panel:CheckBox("#uv.settings.pursuit.noevade", "unitvehicle_neverevade")
			panel:ControlHelp("#uv.settings.pursuit.noevade.desc")
			panel:NumSlider("#uv.settings.pursuit.bustedtime", "unitvehicle_bustedtimer", 0, 10, 1)
			panel:ControlHelp("#uv.settings.pursuit.bustedtime.desc")
			panel:NumSlider("#uv.settings.pursuit.respawntime", "unitvehicle_spawncooldown", 0, 120, 1)
			panel:ControlHelp("#uv.settings.pursuit.respawntime.desc")
			panel:NumSlider("#uv.settings.pursuit.spikeduration", "unitvehicle_spikestripduration", 0, 100, 0)
			panel:ControlHelp("#uv.settings.pursuit.spikeduration.desc")

			panel:Help("#uv.settings.ptech")
			panel:ControlHelp("#uv.settings.ptech.desc")

			-- put slots in a row
			--local dpanel = panel:ControlPanel("uv_keybinds")

			panel:CheckBox("#uv.settings.ptech.racer", "unitvehicle_racerpursuittech")
			panel:ControlHelp("#uv.settings.ptech.racer.desc")
			panel:CheckBox("#uv.settings.ptech.friendlyfire", "unitvehicle_racerfriendlyfire")
			panel:ControlHelp("#uv.settings.ptech.friendlyfire.desc")

			panel:Help("#uv.settings.ailogic")
			panel:CheckBox("#uv.settings.ailogic.relentless", "unitvehicle_relentless")
			panel:ControlHelp("#uv.settings.ailogic.relentless.desc")
			panel:CheckBox("#uv.settings.ailogic.wrecking", "unitvehicle_canwreck")
			panel:ControlHelp("#uv.settings.ailogic.wrecking.desc")
			panel:NumSlider("#uv.settings.ailogic.detectionrange", "unitvehicle_detectionrange", 1, 100, 0)
			panel:ControlHelp("#uv.settings.ailogic.detectionrange.desc")
			panel:CheckBox("#uv.settings.ailogic.headlights", "unitvehicle_enableheadlights")
			panel:ControlHelp("#uv.settings.ailogic.headlights.desc")

			panel:Help("#uv.settings.ainav")
			panel:CheckBox("#uv.settings.ainav.pathfind", "unitvehicle_pathfinding")
			panel:ControlHelp("#uv.settings.ainav.pathfind.desc")
			panel:CheckBox("#uv.settings.ainav.dvpriority", "unitvehicle_dvwaypointspriority")
			panel:ControlHelp("#uv.settings.ainav.dvpriority.desc")

			panel:Help("#uv.settings.chatter")
			panel:CheckBox("#uv.settings.chatter.enable", "unitvehicle_chatter")
			panel:CheckBox("#uv.settings.chatter.text", "unitvehicle_chattertext")
			panel:ControlHelp("#uv.settings.chatter.text.desc")

			panel:Help("#uv.settings.response")
			panel:CheckBox("#uv.settings.response.enable", "unitvehicle_callresponse")
			panel:ControlHelp("#uv.settings.response.enable.desc")
			panel:NumSlider("#uv.settings.response.speedlimit", "unitvehicle_speedlimit", 0, 100, 0)
			panel:ControlHelp("#uv.settings.response.speedlimit.desc")

			panel:Help("#uv.settings.addon")
			panel:CheckBox("#uv.settings.addon.vcmod.els", "unitvehicle_vcmodelspriority")
			panel:ControlHelp("#uv.settings.addon.vcmod.els.desc")

			panel:Help("#uv.settings.reset")
			panel:Button( "#uv.settings.reset.all", "uv_resetallsettings")

		end)
		spawnmenu.AddToolMenuOption("Options", "uv.settings.unitvehicles", "UVClientOptions", "#uv.settings.client", "", "", function(panel)
			panel:Clear()

			panel:Help("#uv.settings.uistyle.title")
			panel:ControlHelp("#uv.settings.uistyle.desc")

			local uistylemain, label = panel:ComboBox( "#uv.settings.uistyle.main", "unitvehicle_hudtype_main" )
			uistylemain:AddChoice( "Most Wanted", "mostwanted")
			uistylemain:AddChoice( "Carbon", "carbon")
			uistylemain:AddChoice( "Underground", "underground")
			uistylemain:AddChoice( "Underground 2", "underground2")
			uistylemain:AddChoice( "Undercover", "undercover")
			uistylemain:AddChoice( "Pro Street", "prostreet")
			uistylemain:AddChoice( "#uv.uistyle.original", "original")
			uistylemain:AddChoice( "#uv.uistyle.none", "")

			local uistylebackup, label = panel:ComboBox( "#uv.settings.uistyle.backup", "unitvehicle_hudtype_backup" )
			uistylebackup:AddChoice( "Most Wanted", "mostwanted")
			uistylebackup:AddChoice( "Carbon", "carbon")
			uistylebackup:AddChoice( "Undercover", "undercover")
			uistylebackup:AddChoice( "#uv.uistyle.original", "original")

			panel:CheckBox("#uv.settings.ui.racertags", "unitvehicle_racertags")
			panel:ControlHelp("#uv.settings.ui.racertags.desc.racing")
			panel:ControlHelp("#uv.settings.ui.racertags.desc.pursuit")

			panel:CheckBox("#uv.settings.ui.preracepopup", "unitvehicle_preraceinfo")
			panel:ControlHelp("#uv.settings.ui.preracepopup.desc")

			panel:Help("#uv.settings.audio.title")
			panel:CheckBox("#uv.settings.audio.mutecp", "unitvehicle_mutecheckpointsfx")
			panel:ControlHelp("#uv.settings.audio.mutecp.desc")

			panel:Help("#uv.settings.music")

			local volume_theme = panel:NumSlider("#uv.settings.music.volume", "unitvehicle_pursuitthemevolume", 0, 2, 1)
			panel:ControlHelp("#uv.settings.music.volume.desc")

			volume_theme.OnValueChanged = function( self, value )
				if UVSoundLoop then
					UVSoundLoop:SetVolume( value )
				end
			end

			local racetheme, label = panel:ComboBox( "#uv.settings.music.uvtrax.profile", "unitvehicle_racetheme" )
			local files, folders = file.Find( "sound/uvracemusic/*", "GAME" )
			if folders ~= nil then
				for k, v in pairs(folders) do
					racetheme:AddChoice( v )
				end
			end


			local pursuittheme, label = panel:ComboBox( "#uv.settings.music.pursuittheme", "unitvehicle_pursuittheme" )
			local files, folders = file.Find( "sound/uvpursuitmusic/*", "GAME" )
			if folders ~= nil then
				for k, v in pairs(folders) do
					pursuittheme:AddChoice( v )
				end
			end

			panel:CheckBox("#uv.settings.music.uvtrax.freeroam", "unitvehicle_uvtraxinfreeroam")
			panel:ControlHelp("#uv.settings.music.uvtrax.freeroam.desc")
			panel:CheckBox("#uv.settings.music.pursuit", "unitvehicle_playmusic")
			panel:ControlHelp("#uv.settings.music.pursuit.desc")
			panel:CheckBox("#uv.settings.music.race", "unitvehicle_racingmusic")
			panel:ControlHelp("#uv.settings.music.race.desc")
			panel:CheckBox("#uv.settings.music.race.priority", "unitvehicle_racingmusicpriority")
			panel:ControlHelp("#uv.settings.music.race.priority.desc")
			panel:CheckBox("#uv.settings.music.race.racingpriority", "unitvehicle_racingmusicoutsideraces")
			panel:ControlHelp("#uv.settings.music.race.racingpriority.desc")
			panel:CheckBox("#uv.settings.music.pursuittheme.random", "unitvehicle_pursuitthemeplayrandomheat")
			panel:ControlHelp("#uv.settings.music.pursuittheme.random.desc")


			panel:Help("#uv.settings.ptech.keybinds")

			KeyBindButtons[3] = {
				UVKeybindSkipSong:GetName(),
				panel:Button(language.GetPhrase(Control_Strings[3]) .. " - "..string.upper(input.GetKeyName(UVKeybindSkipSong:GetInt())), "uv_keybinds", '3')
			}

			panel:Help("#uv.settings.race")
			panel:Help("#uv.settings.race.keybinds")

			KeyBindButtons[4] = {
				UVKeybindResetPosition:GetName(),
				panel:Button(language.GetPhrase(Control_Strings[4]) .. " - "..string.upper(input.GetKeyName(UVKeybindResetPosition:GetInt())), "uv_keybinds", '4')
			}

			KeyBindButtons[5] = {
				UVKeybindShowRaceResults:GetName(),
				panel:Button(language.GetPhrase(Control_Strings[5]) .. " - "..string.upper(input.GetKeyName(UVKeybindShowRaceResults:GetInt())), "uv_keybinds", '5')
			}

			panel:Help("#uv.settings.ptech")

			-- put slots in a row
			--local dpanel = panel:ControlPanel("uv_keybinds")
			panel:Help("#uv.settings.ptech.keybinds")

			KeyBindButtons[1] = {
				UVPTKeybindSlot1:GetName(), --Convar string, button
				panel:Button(language.GetPhrase(Control_Strings[1]) .. " - "..string.upper(input.GetKeyName(UVPTKeybindSlot1:GetInt())), "uv_keybinds", '1')
			}
			KeyBindButtons[2] = {
				UVPTKeybindSlot2:GetName(),
				panel:Button(language.GetPhrase(Control_Strings[2]) .. " - "..string.upper(input.GetKeyName(UVPTKeybindSlot2:GetInt())), "uv_keybinds", '2')
			}

		end)
		spawnmenu.AddToolMenuOption("Options", "uv.settings.unitvehicles", "UVPursuitManager", "#uv.settings.pm", "", "", function(panel)

			panel:SetContentAlignment(8)
			panel:Help("#uv.settings.pm.units")
			-- panel:AddControl("Header", {Description = "	——— Units ———"})
			panel:Button( "#uv.settings.pm.ai.spawn", "uv_spawnvehicles")
			panel:Button( "#uv.settings.pm.ai.despawn", "uv_despawnvehicles")
			panel:Button( "#uv.settings.pm.ai.spawnas", "uv_spawn_as_unit")

			panel:Help("#uv.settings.pm.pursuit")
			-- panel:AddControl("Header", {Description = "——— Pursuit ———"})
			panel:Button( "#uv.settings.pm.pursuit.start", "uv_startpursuit")
			panel:Button( "#uv.settings.pm.pursuit.stop", "uv_stoppursuit")

			panel:Help("#uv.settings.pm.racers")
			-- panel:AddControl("Header", {Description = "——— Racers ———"})
			panel:Button( "#uv.settings.hor.start", "uv_racershordestart")
			panel:Button( "#uv.settings.hor.stop", "uv_racershordestop")

			panel:Help("#uv.settings.pm.misc")
			-- panel:AddControl("Header", {Description = "——— Misc ———"})
			panel:Button( "#uv.settings.clearbounty", "uv_clearbounty")
			panel:Button( "#uv.settings.print.wantedtable", "uv_wantedtable")

			local heatLevelSlider = panel:NumSlider("#uv.settings.pm.heatlevel", nil, 1, MAX_HEAT_LEVEL, 0)
			heatLevelSlider:SetValue( 1 )
			heatLevelSlider.OnValueChanged = function( self, val )
				local roundedVal = math.Round( val - 0.5 )

				if roundedVal ~= UVHeatLevel then
					RunConsoleCommand( 'uv_setheat', roundedVal )
				end
			end
		end)
	end)
end