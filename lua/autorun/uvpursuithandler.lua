AddCSLuaFile()

local dvd = DecentVehicleDestination

--Sound--
local UVSoundSource
local UVSoundLoop
local UVSoundMiscSource
local UVLoadedSounds
local _last_backup_pulse_second = 0

local showhud = GetConVar("cl_drawhud")

PT_Slots_Replacement_Strings = {
	[1] = "#uv.ptech.slot1",
	[2] = "#uv.ptech.slot2"
}

local Control_Strings = {
	[1] = "#uv.ptech.slot1",
	[2] = "#uv.ptech.slot2",
	[3] = "#uv.settings.music.skipsong",
	[4] = "#uv.settings.race.resetposition"
}

local Colors = {
	['Yellow'] = Color(255, 255, 0),
	['White'] = Color(255, 255, 255),
	['RacerTheme'] = Color(255, 221, 142, 107),
	['RacerThemeShade'] = Color(166, 142, 85, 107),
	['CopTheme'] = Color(61, 184, 255, 107),--Color(148, 142, 255, 107),
	['CopThemeShade'] = Color(41, 149, 212, 107)--Color(93, 85, 166, 107)
}

function UVGetDriver(vehicle)
	if !IsValid(vehicle) then return false end
	
	if vehicle.IsSimfphyscar or vehicle:GetClass() == "prop_vehicle_jeep" then
		return vehicle:GetDriver()
	elseif vehicle.IsGlideVehicle then
		if not vehicle.seats or next(vehicle.seats) == nil then return false end
		
		local seat = vehicle.seats[1]
		
		if IsValid( seat ) then
			return seat:GetDriver()
		end
	end
	
	return false
end

--Sound spam check--

function UVDelaySound()
	if UVSoundDelayed then return end
	UVSoundDelayed = true
	timer.Simple(1, function()
		UVSoundDelayed = false
	end)
end

function UVSoundHeat(heatlevel)
	if RacingMusicPriority:GetBool() and RacingMusic:GetBool() and UVHUDDisplayRacing then return end
	if RacingThemeOutsideRace:GetBool() then UVSoundRacing() return end	
	if UVPlayingHeat or UVSoundDelayed then return end
	
	if timer.Exists("UVPursuitThemeReplay") then
		timer.Remove("UVPursuitThemeReplay")
	end
	
	local theme = PursuitTheme:GetString()
	local heat
	
	if PursuitThemePlayRandomHeat:GetBool() then
		heat = "heat" .. math.random(1, 6)
	else
		heat = "heat" .. heatlevel
	end
	
	local soundtable
	
	if UVHeatLevelIncrease then
		UVPlayingHeat = false
		soundtable = file.Find("sound/uvpursuitmusic/" .. theme .. "/transition/*", "GAME")
		
		-- Only play if folder exists and has sound files
		if soundtable and #soundtable > 0 then
			UVPlaySound("uvpursuitmusic/" .. theme .. "/transition/" .. soundtable[math.random(1, #soundtable)], false)
		end
	else
		UVPlayingHeat = true
		soundtable = file.Find("sound/uvpursuitmusic/" .. theme .. "/" .. heat .. "/*", "GAME")
		
		-- Fallback to heat1 if the desired heat folder is missing or empty
		if not soundtable or #soundtable == 0 then
			soundtable = file.Find("sound/uvpursuitmusic/" .. theme .. "/heat1/*", "GAME")
			if soundtable and #soundtable > 0 then
				UVPlaySound("uvpursuitmusic/" .. theme .. "/heat1/" .. soundtable[math.random(1, #soundtable)], true)
			end
		else
			UVPlaySound("uvpursuitmusic/" .. theme .. "/" .. heat .. "/" .. soundtable[math.random(1, #soundtable)], true)
		end
	end
	
	UVPlayingRace = false
	-- UVPlayingHeat is handled above
	UVPlayingBusting = false
	UVPlayingCooldown = false
	UVPlayingBusted = false
	UVPlayingEscaped = false
end

function UVSoundBusting()
	if RacingMusicPriority:GetBool() and RacingMusic:GetBool() and UVHUDDisplayRacing then return end
	if RacingThemeOutsideRace:GetBool() then UVSoundRacing() return end	
	if UVPlayingBusting or UVSoundDelayed then return end
	
	if timer.Exists("UVPursuitThemeReplay") then
		timer.Remove("UVPursuitThemeReplay")
	end
	
	local theme = PursuitTheme:GetString()
	local soundtable = file.Find("sound/uvpursuitmusic/" .. theme .. "/busting/*", "GAME")
	
	if not soundtable or #soundtable == 0 then UVSoundHeat() return end
	
	UVPlaySound("uvpursuitmusic/" .. theme .. "/busting/" .. soundtable[math.random(1, #soundtable)], true)
	
	UVPlayingRace = false
	UVPlayingHeat = false
	UVPlayingBusting = true
	UVPlayingCooldown = false
	UVPlayingBusted = false
	UVPlayingEscaped = false
end

function UVSoundCooldown()
	if RacingMusicPriority:GetBool() and RacingMusic:GetBool() and UVHUDDisplayRacing then return end
	if RacingThemeOutsideRace:GetBool() then UVSoundRacing() return end	
	if UVPlayingCooldown or UVSoundDelayed then return end
	
	if timer.Exists("UVPursuitThemeReplay") then
		timer.Remove("UVPursuitThemeReplay")
	end
	
	local theme = PursuitTheme:GetString()
	local soundtable = file.Find("sound/uvpursuitmusic/" .. theme .. "/cooldown/*", "GAME")
	
	if not soundtable or #soundtable == 0 then UVSoundHeat() return end
	
	UVPlaySound("uvpursuitmusic/" .. theme .. "/cooldown/" .. soundtable[math.random(1, #soundtable)], true)
	
	UVPlayingRace = false
	UVPlayingHeat = false
	UVPlayingBusting = false
	UVPlayingCooldown = true
	UVPlayingBusted = false
	UVPlayingEscaped = false
end

function UVSoundBusted()
	if UVPlayingBusted or UVSoundDelayed then return end
	
	if timer.Exists("UVPursuitThemeReplay") then
		timer.Remove("UVPursuitThemeReplay")
	end
	
	if UVSoundLoop then
		UVStopSound()
		UVSoundLoop:Stop()
		UVSoundLoop = nil
	end
	
	local theme = PursuitTheme:GetString()
	local soundtable = file.Find("sound/uvpursuitmusic/" .. theme .. "/busted/*", "GAME")
	
	if not soundtable or #soundtable == 0 then return end
	
	UVPlaySound("uvpursuitmusic/" .. theme .. "/busted/" .. soundtable[math.random(1, #soundtable)], false, true)
	
	UVPlayingRace = false
	UVPlayingHeat = false
	UVPlayingBusting = false
	UVPlayingCooldown = false
	UVPlayingBusted = true
	UVPlayingEscaped = true
end

function UVSoundEscaped()
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
	local soundtable = file.Find("sound/uvpursuitmusic/" .. theme .. "/escaped/*", "GAME")
	
	if not soundtable or #soundtable == 0 then return end
	
	UVPlaySound("uvpursuitmusic/" .. theme .. "/escaped/" .. soundtable[math.random(1, #soundtable)], false)
	
	UVPlayingRace = false
	UVPlayingHeat = false
	UVPlayingBusting = false
	UVPlayingCooldown = false
	UVPlayingBusted = true
	UVPlayingEscaped = true
end

-- function UVPlaySound( FileName )
-- 	if !PlayMusic:GetBool() then return end
-- 	if UVLoadedSounds then
-- 		if UVLoadedSounds == FileName then return end
-- 		Entity(1):StopSound(UVLoadedSounds)
-- 	end
-- 	UVLoadedSounds = FileName
-- 	Entity(1):EmitSound(FileName, 0, 100, 1, CHAN_STATIC)
-- 	local duration = SoundDuration(FileName)
-- 	UVDelaySound()
-- 	timer.Create("UVPursuitThemeReplay", duration, 1, function()
-- 		if UVHUDDisplayBusting then
-- 			UVSoundBusting()
-- 			return
-- 		end
-- 		UVStopSound()
-- 	end)
-- end
function UVPlaySound( FileName, Loop, StopLoop )
	//if !PlayMusic:GetBool() then return end
	if UVLoadedSounds ~= FileName then
		//if UVLoadedSounds == FileName then print('Ended') return end
		--Entity(1):StopSound(UVLoadedSounds)
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
	--Entity(1):EmitSound(FileName, 0, 100, 1, CHAN_STATIC)
	
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
	
	UVLoadedSounds = FileName
	
	-- local duration = SoundDuration(FileName)
	UVDelaySound()
	hook.Add("Think", "CheckSoundFinished", function()
		if IsValid(snd) and expectedEndTime then
			if RealTime() >= expectedEndTime then
				--print("Sound finished (pause-safe check)!")
				hook.Remove("Think", "CheckSoundFinished")
				
				if UVHUDDisplayBusting then
					UVSoundBusting()
					return
				end
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
	local formattedtime
	local hours = math.floor( time / 3600 )
	if hours < 1 then
		formattedtime = string.FormattedTime( time, "%02i:%02i.%02i" )
	else --1 hour pursuit challenge completed
		formattedtime = hours..":"..string.FormattedTime( time, "%02i:%02i.%02i" )
	end
	return formattedtime
end

local local_convars = {
	["unitvehicle_heatlevels"] = 'integer',
	//["unitvehicle_pursuittheme"] = 'string',
	["unitvehicle_targetvehicletype"] = 'integer',
	["unitvehicle_detectionrange"] = 'integer',
	//["unitvehicle_playmusic"] = 'integer',
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
	//["unitvehicle_pursuitthemeplayrandomheat"] = 'integer',
	["unitvehicle_repaircooldown"] = 'integer',
	["unitvehicle_repairrange"] = 'integer',
	["unitvehicle_racertags"] = 'integer',
	["unitvehicle_racerpursuittech"] = 'integer'
}

if SERVER then
	
	--convars--
	//PursuitTheme = CreateConVar("unitvehicle_pursuittheme", "nfsmostwanted", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: Type either one of these two pursuit themes to play from 'nfsmostwanted' 'nfsundercover'.")
	HeatLevels = CreateConVar("unitvehicle_heatlevels", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "If set to 1, Heat Levels will increase from its minimum value to its maximum value during a pursuit." )
	TargetVehicleType = CreateConVar("unitvehicle_targetvehicletype", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: 1 = All vehicles are targeted. 2 = Decent Vehicles are targeted only. 3 = Other vehicles besides Decent Vehicles are targeted.")
	DetectionRange = CreateConVar("unitvehicle_detectionrange", 30, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: Minimum spawning distance to the vehicle in studs when manually spawning Units. Use greater values if you have trouble spawning Units.")
	//PlayMusic = CreateConVar("unitvehicle_playmusic", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, Pursuit themes will play.")
	NeverEvade = CreateConVar("unitvehicle_neverevade", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, you won't be able to evade the Unit Vehicles. Good luck.")
	BustedTimer = CreateConVar("unitvehicle_bustedtimer", 5, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: Time in seconds before the enemy gets busted. Set this to 0 to disable.")
	SpawnCooldown = CreateConVar("unitvehicle_spawncooldown", 30, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: Time in seconds before player units can spawn again. Set this to 0 to disable.")
	CanWreck = CreateConVar("unitvehicle_canwreck", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, Unit Vehicles can crash out. Set this to 0 to disable.")
	Chatter = CreateConVar("unitvehicle_chatter", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, Units' radio chatter can be heard.")
	SpeedLimit = CreateConVar("unitvehicle_speedlimit", 60, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: Speed limit in MPH for idle Units to enforce. Patrolling Units still enforces speed limits set on DV Waypoints. Set this to 0 to disable.")
	AutoHealth = CreateConVar("unitvehicle_autohealth", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, all suspects will have unlimited vehicle health and your health as a suspect will be set according to your vehicle's mass.")
	MinHeatLevel = CreateConVar("unitvehicle_minheatlevel", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: Sets the minimum Heat Level achievable during pursuits (1-6). Use high Heat Levels for more aggressive Units on your tail and vice versa.")
	MaxHeatLevel = CreateConVar("unitvehicle_maxheatlevel", 6, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: Sets the maximum Heat Level achievable during pursuits (1-6). Use low Heat Levels for less aggressive Units on your tail and vice versa.")
	SpikeStripDuration = CreateConVar("unitvehicle_spikestripduration", 20, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicle: Time in seconds before the tires gets reinflated after hitting the spikes. Set this to 0 to disable reinflating tires.")
	Pathfinding = CreateConVar("unitvehicle_pathfinding", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, Units uses A* pathfinding algorithm on navmesh/Decent Vehicle Waypoints to navigate. Impacts computer performance.")
	VCModELSPriority = CreateConVar("unitvehicle_vcmodelspriority", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, Units using base HL2 vehicles will attempt to use VCMod ELS over Photon if both are installed.")
	CallResponse = CreateConVar("unitvehicle_callresponse", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, Units will spawn and respond to the location regarding various calls.")
	ChatterText = CreateConVar("unitvehicle_chattertext", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, Units' radio chatter will be displayed in the chatbox instead.")
	Headlights = CreateConVar("unitvehicle_enableheadlights", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, Units and Racer Vehicles will shine their headlights.")
	Relentless = CreateConVar("unitvehicle_relentless", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, Units will ram the target more frequently.")
	SpawnMainUnits = CreateConVar("unitvehicle_spawnmainunits", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, main AI Units (Patrol, Support, etc.) will spawn to patrol/chase.")
	DVWaypointsPriority = CreateConVar("unitvehicle_dvwaypointspriority", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, Units will attempt to navigate on Decent Vehicle Waypoints FIRST instead of navmesh (if both are installed).")
	//PursuitThemePlayRandomHeat = CreateConVar("unitvehicle_pursuitthemeplayrandomheat", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, random Heat Level songs will play during pursuits.")
	RepairCooldown = CreateConVar("unitvehicle_repaircooldown", 60, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicle: Time in seconds between each repair. Set this to 0 to make all repair shops a one-time use.")
	RepairRange = CreateConVar("unitvehicle_repairrange", 100, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicle: Distance in studs between the repair shop and the vehicle to repair.")
	RacerTags = CreateConVar("unitvehicle_racertags", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, Racers will have their own tags which you can see as a cop during pursuits.")
	RacerPursuitTech = CreateConVar("unitvehicle_racerpursuittech", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, Racers will spawn with pursuit tech (spike strips, ESF, etc.).")
	RacerFriendlyFire = CreateConVar("unitvehicle_racerfriendlyfire", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, Racers will be able to attack eachother with Pursuit Tech.")
	
	
	--unit convars
	UVUVehicleBase = CreateConVar("unitvehicle_unit_vehiclebase", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "\n1 = Default Vehicle Base (prop_vehicle_jeep)\n2 = simfphys\n3 = Glide")
	
	UVUCommanderEvade = CreateConVar("unitvehicle_unit_onecommanderevading", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "If enabled, will allow racers to escape while commander is on scene.")
	UVUOneCommander = CreateConVar("unitvehicle_unit_onecommander", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUOneCommanderHealth = CreateConVar("unitvehicle_unit_onecommanderhealth", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	
	UVUPursuitTech = CreateConVar("unitvehicle_unit_pursuittech", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, AI and player-controlled Unit Vehicles can use weapons (spike strips, ESF, EMP, etc.).")
	UVUPursuitTech_ESF = CreateConVar("unitvehicle_unit_pursuittech_esf", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, AI and player-controlled Unit Vehicles can spawn with ESF.")
	UVUPursuitTech_Spikestrip = CreateConVar("unitvehicle_unit_pursuittech_spikestrip", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, AI and player-controlled Unit Vehicles can spawn with spike strips.")
	UVUPursuitTech_Killswitch = CreateConVar("unitvehicle_unit_pursuittech_killswitch", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, AI and player-controlled Unit Vehicles can spawn with killswitch.")
	UVUPursuitTech_RepairKit = CreateConVar("unitvehicle_unit_pursuittech_repairkit", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Vehicles: If set to 1, AI and player-controlled Unit Vehicles can spawn with repair kits.")
	
	
	UVUHelicopterModel = CreateConVar("unitvehicle_unit_helicoptermodel", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "\n1 = Most Wanted\n2 = Undercover\n3 = Hot Pursuit\n4 = No Limits\n5 = Payback")
	UVUHelicopterBarrels = CreateConVar("unitvehicle_unit_helicopterbarrels", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "1 = Barrels\n0 = No Barrels")
	UVUHelicopterSpikeStrip = CreateConVar("unitvehicle_unit_helicopterspikestrip", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "1 = Spike Strips\n0 = No Spike Strips")
	UVUHelicopterBusting = CreateConVar("unitvehicle_unit_helicopterbusting", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "1 = Helicopter can bust racers\n0 = Helicopter cannot bust racers")
	
	UVUBountyPatrol = CreateConVar("unitvehicle_unit_bountypatrol", 1000, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUBountySupport = CreateConVar("unitvehicle_unit_bountysupport", 5000, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUBountyPursuit = CreateConVar("unitvehicle_unit_bountypursuit", 10000, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUBountyInterceptor = CreateConVar("unitvehicle_unit_bountyinterceptor", 20000, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUBountyAir = CreateConVar("unitvehicle_unit_bountyair", 75000, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUBountySpecial = CreateConVar("unitvehicle_unit_bountyspecial", 25000, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUBountyCommander = CreateConVar("unitvehicle_unit_bountycommander", 100000, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUBountyRhino = CreateConVar("unitvehicle_unit_bountyrhino", 50000, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	
	UVUBountyTime1 = CreateConVar("unitvehicle_unit_bountytime1", 1000, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUBountyTime2 = CreateConVar("unitvehicle_unit_bountytime2", 5000, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUBountyTime3 = CreateConVar("unitvehicle_unit_bountytime3", 10000, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUBountyTime4 = CreateConVar("unitvehicle_unit_bountytime4", 50000, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUBountyTime5 = CreateConVar("unitvehicle_unit_bountytime5", 100000, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUBountyTime6 = CreateConVar("unitvehicle_unit_bountytime6", 500000, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	
	UVUTimeTillNextHeatEnabled = CreateConVar("unitvehicle_unit_timetillnextheatenabled", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUTimeTillNextHeat1 = CreateConVar("unitvehicle_unit_timetillnextheat1", 120, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUTimeTillNextHeat2 = CreateConVar("unitvehicle_unit_timetillnextheat2", 120, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUTimeTillNextHeat3 = CreateConVar("unitvehicle_unit_timetillnextheat3", 180, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUTimeTillNextHeat4 = CreateConVar("unitvehicle_unit_timetillnextheat4", 180, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUTimeTillNextHeat5 = CreateConVar("unitvehicle_unit_timetillnextheat5", 600, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	
	UVUUnitsPatrol1 = CreateConVar("unitvehicle_unit_unitspatrol1", "", {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUUnitsSupport1 = CreateConVar("unitvehicle_unit_unitssupport1", "", {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUUnitsPursuit1 = CreateConVar("unitvehicle_unit_unitspursuit1", "", {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUUnitsInterceptor1 = CreateConVar("unitvehicle_unit_unitsinterceptor1", "", {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUUnitsSpecial1 = CreateConVar("unitvehicle_unit_unitsspecial1", "", {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUUnitsCommander1 = CreateConVar("unitvehicle_unit_unitscommander1", "", {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVURhinos1 = CreateConVar("unitvehicle_unit_rhinos1", "", {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUHeatMinimumBounty1 = CreateConVar("unitvehicle_unit_heatminimumbounty1", 1000, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUMaxUnits1 = CreateConVar("unitvehicle_unit_maxunits1", 2, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUUnitsAvailable1 = CreateConVar("unitvehicle_unit_unitsavailable1", 10, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUBackupTimer1 = CreateConVar("unitvehicle_unit_backuptimer1", 180, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUCooldownTimer1 = CreateConVar("unitvehicle_unit_cooldowntimer1", 20, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVURoadblocks1 = CreateConVar("unitvehicle_unit_roadblocks1", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUHelicopters1 = CreateConVar("unitvehicle_unit_helicopters1", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	
	UVUUnitsPatrol2 = CreateConVar("unitvehicle_unit_unitspatrol2", "", {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUUnitsSupport2 = CreateConVar("unitvehicle_unit_unitssupport2", "", {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUUnitsPursuit2 = CreateConVar("unitvehicle_unit_unitspursuit2", "", {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUUnitsInterceptor2 = CreateConVar("unitvehicle_unit_unitsinterceptor2", "", {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUUnitsSpecial2 = CreateConVar("unitvehicle_unit_unitsspecial2", "", {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUUnitsCommander2 = CreateConVar("unitvehicle_unit_unitscommander2", "", {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVURhinos2 = CreateConVar("unitvehicle_unit_rhinos2", "", {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUHeatMinimumBounty2 = CreateConVar("unitvehicle_unit_heatminimumbounty2", 10000, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUMaxUnits2 = CreateConVar("unitvehicle_unit_maxunits2", 2, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUUnitsAvailable2 = CreateConVar("unitvehicle_unit_unitsavailable2", 10, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUBackupTimer2 = CreateConVar("unitvehicle_unit_backuptimer2", 180, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUCooldownTimer2 = CreateConVar("unitvehicle_unit_cooldowntimer2", 20, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVURoadblocks2 = CreateConVar("unitvehicle_unit_roadblocks2", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUHelicopters2 = CreateConVar("unitvehicle_unit_helicopters2", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	
	UVUUnitsPatrol3 = CreateConVar("unitvehicle_unit_unitspatrol3", "", {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUUnitsSupport3 = CreateConVar("unitvehicle_unit_unitssupport3", "", {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUUnitsPursuit3 = CreateConVar("unitvehicle_unit_unitspursuit3", "", {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUUnitsInterceptor3 = CreateConVar("unitvehicle_unit_unitsinterceptor3", "", {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUUnitsSpecial3 = CreateConVar("unitvehicle_unit_unitsspecial3", "", {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUUnitsCommander3 = CreateConVar("unitvehicle_unit_unitscommander3", "", {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVURhinos3 = CreateConVar("unitvehicle_unit_rhinos3", "", {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUHeatMinimumBounty3 = CreateConVar("unitvehicle_unit_heatminimumbounty3", 100000, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUMaxUnits3 = CreateConVar("unitvehicle_unit_maxunits3", 2, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUUnitsAvailable3 = CreateConVar("unitvehicle_unit_unitsavailable3", 10, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUBackupTimer3 = CreateConVar("unitvehicle_unit_backuptimer3", 180, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUCooldownTimer3 = CreateConVar("unitvehicle_unit_cooldowntimer3", 20, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVURoadblocks3 = CreateConVar("unitvehicle_unit_roadblocks3", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUHelicopters3 = CreateConVar("unitvehicle_unit_helicopters3", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	
	UVUUnitsPatrol4 = CreateConVar("unitvehicle_unit_unitspatrol4", "", {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUUnitsSupport4 = CreateConVar("unitvehicle_unit_unitssupport4", "", {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUUnitsPursuit4 = CreateConVar("unitvehicle_unit_unitspursuit4", "", {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUUnitsInterceptor4 = CreateConVar("unitvehicle_unit_unitsinterceptor4", "", {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUUnitsSpecial4 = CreateConVar("unitvehicle_unit_unitsspecial4", "", {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUUnitsCommander4 = CreateConVar("unitvehicle_unit_unitscommander4", "", {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVURhinos4 = CreateConVar("unitvehicle_unit_rhinos4", "", {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUHeatMinimumBounty4 = CreateConVar("unitvehicle_unit_heatminimumbounty4", 500000, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUMaxUnits4 = CreateConVar("unitvehicle_unit_maxunits4", 2, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUUnitsAvailable4 = CreateConVar("unitvehicle_unit_unitsavailable4", 10, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUBackupTimer4 = CreateConVar("unitvehicle_unit_backuptimer4", 180, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUCooldownTimer4 = CreateConVar("unitvehicle_unit_cooldowntimer4", 20, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVURoadblocks4 = CreateConVar("unitvehicle_unit_roadblocks4", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUHelicopters4 = CreateConVar("unitvehicle_unit_helicopters4", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	
	UVUUnitsPatrol5 = CreateConVar("unitvehicle_unit_unitspatrol5", "", {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUUnitsSupport5 = CreateConVar("unitvehicle_unit_unitssupport5", "", {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUUnitsPursuit5 = CreateConVar("unitvehicle_unit_unitspursuit5", "", {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUUnitsInterceptor5 = CreateConVar("unitvehicle_unit_unitsinterceptor5", "", {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUUnitsSpecial5 = CreateConVar("unitvehicle_unit_unitsspecial5", "", {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUUnitsCommander5 = CreateConVar("unitvehicle_unit_unitscommander5", "", {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVURhinos5 = CreateConVar("unitvehicle_unit_rhinos5", "", {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUHeatMinimumBounty5 = CreateConVar("unitvehicle_unit_heatminimumbounty5", 1000000, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUMaxUnits5 = CreateConVar("unitvehicle_unit_maxunits5", 2, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUUnitsAvailable5 = CreateConVar("unitvehicle_unit_unitsavailable5", 10, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUBackupTimer5 = CreateConVar("unitvehicle_unit_backuptimer5", 180, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUCooldownTimer5 = CreateConVar("unitvehicle_unit_cooldowntimer5", 20, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVURoadblocks5 = CreateConVar("unitvehicle_unit_roadblocks5", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUHelicopters5 = CreateConVar("unitvehicle_unit_helicopters5", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	
	UVUUnitsPatrol6 = CreateConVar("unitvehicle_unit_unitspatrol6", "", {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUUnitsSupport6 = CreateConVar("unitvehicle_unit_unitssupport6", "", {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUUnitsPursuit6 = CreateConVar("unitvehicle_unit_unitspursuit6", "", {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUUnitsInterceptor6 = CreateConVar("unitvehicle_unit_unitsinterceptor6", "", {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUUnitsSpecial6 = CreateConVar("unitvehicle_unit_unitsspecial6", "", {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUUnitsCommander6 = CreateConVar("unitvehicle_unit_unitscommander6", "", {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVURhinos6 = CreateConVar("unitvehicle_unit_rhinos6", "", {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUHeatMinimumBounty6 = CreateConVar("unitvehicle_unit_heatminimumbounty6", 5000000, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUMaxUnits6 = CreateConVar("unitvehicle_unit_maxunits6", 2, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUUnitsAvailable6 = CreateConVar("unitvehicle_unit_unitsavailable6", 10, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUBackupTimer6 = CreateConVar("unitvehicle_unit_backuptimer6", 180, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUCooldownTimer6 = CreateConVar("unitvehicle_unit_cooldowntimer6", 20, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVURoadblocks6 = CreateConVar("unitvehicle_unit_roadblocks6", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUHelicopters6 = CreateConVar("unitvehicle_unit_helicopters6", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	
	UVPTPTDuration = CreateConVar("unitvehicle_pursuittech_ptduration", 60, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVPTESFDuration = CreateConVar("unitvehicle_pursuittech_esfduration", 10, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVPTESFPower = CreateConVar("unitvehicle_pursuittech_esfpower", 2000000, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVPTESFDamage = CreateConVar("unitvehicle_pursuittech_esfdamage", 0.2, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVPTESFCommanderDamage = CreateConVar("unitvehicle_pursuittech_esfcommanderdamage", 0.1, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVPTJammerDuration = CreateConVar("unitvehicle_pursuittech_jammerduration", 10, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVPTShockwavePower = CreateConVar("unitvehicle_pursuittech_shockwavepower", 2000000, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVPTShockwaveDamage = CreateConVar("unitvehicle_pursuittech_shockwavedamage", 0.1, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVPTShockwaveCommanderDamage = CreateConVar("unitvehicle_pursuittech_shockwavecommanderdamage", 0.1, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVPTSpikeStripDuration = CreateConVar("unitvehicle_pursuittech_spikestripduration", 60, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVPTStunMinePower = CreateConVar("unitvehicle_pursuittech_stunminepower", 2000000, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVPTStunMineCommanderDamage = CreateConVar("unitvehicle_pursuittech_stunminecommanderdamage", 0.1, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVPTStunMineDamage = CreateConVar("unitvehicle_pursuittech_stunminedamage", 0.1, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	
	
	UVPTESFMaxAmmo = CreateConVar("unitvehicle_pursuittech_maxammo_esf", 5, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Pursuit Tech Max Ammo")
	UVPTJammerMaxAmmo = CreateConVar("unitvehicle_pursuittech_maxammo_jammer", 5, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Pursuit Tech Max Ammo")
	UVPTShockwaveMaxAmmo = CreateConVar("unitvehicle_pursuittech_maxammo_shockwave", 5, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Pursuit Tech Max Ammo")
	UVPTSpikeStripMaxAmmo = CreateConVar("unitvehicle_pursuittech_maxammo_spikestrip", 5, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Pursuit Tech Max Ammo")
	UVPTStunMineMaxAmmo = CreateConVar("unitvehicle_pursuittech_maxammo_stunmine", 5, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Pursuit Tech Max Ammo")
	UVPTRepairKitMaxAmmo = CreateConVar("unitvehicle_pursuittech_maxammo_repairkit", 5, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Pursuit Tech Max Ammo")
	
	UVPTESFCooldown = CreateConVar("unitvehicle_pursuittech_cooldown_esf", 5, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Pursuit Tech Cooldown")
	UVPTJammerCooldown = CreateConVar("unitvehicle_pursuittech_cooldown_jammer", 5, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Pursuit Tech Cooldown")
	UVPTShockwaveCooldown = CreateConVar("unitvehicle_pursuittech_cooldown_shockwave", 5, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Pursuit Tech Cooldown")
	UVPTSpikeStripCooldown = CreateConVar("unitvehicle_pursuittech_cooldown_spikestrip", 5, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Pursuit Tech Cooldown")
	UVPTStunMineCooldown = CreateConVar("unitvehicle_pursuittech_cooldown_stunmine", 5, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Pursuit Tech Cooldown")
	UVPTRepairKitCooldown = CreateConVar("unitvehicle_pursuittech_cooldown_repairkit", 5, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Pursuit Tech Cooldown")
	
	UVUnitPTDuration = CreateConVar("unitvehicle_unitpursuittech_ptduration", 20, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUnitPTESFDuration = CreateConVar("unitvehicle_unitpursuittech_esfduration", 10, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUnitPTESFPower = CreateConVar("unitvehicle_unitpursuittech_esfpower", 2000000, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUnitPTESFDamage = CreateConVar("unitvehicle_unitpursuittech_esfdamage", 0.2, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUnitPTSpikeStripDuration = CreateConVar("unitvehicle_unitpursuittech_spikestripduration", 60, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUnitPTKillSwitchLockOnTime = CreateConVar("unitvehicle_unitpursuittech_killswitchlockontime", 3, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVUnitPTKillSwitchDisableDuration = CreateConVar("unitvehicle_unitpursuittech_killswitchdisableduration", 2.5, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	
	UVUnitPTESFMaxAmmo = CreateConVar("unitvehicle_unitpursuittech_maxammo_esf", 5, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Pursuit Tech Max Ammo")
	UVUnitPTSpikeStripMaxAmmo = CreateConVar("unitvehicle_unitpursuittech_maxammo_spikestrip", 5, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Pursuit Tech Max Ammo")
	UVUnitPTKillSwitchMaxAmmo = CreateConVar("unitvehicle_unitpursuittech_maxammo_killswitch", 5, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Pursuit Tech Max Ammo")
	UVUnitPTRepairKitMaxAmmo = CreateConVar("unitvehicle_unitpursuittech_maxammo_repairkit", 5, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Pursuit Tech Max Ammo")
	
	UVUnitPTESFCooldown = CreateConVar("unitvehicle_unitpursuittech_cooldown_esf", 5, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Pursuit Tech Cooldown")
	UVUnitPTSpikeStripCooldown = CreateConVar("unitvehicle_unitpursuittech_cooldown_spikestrip", 5, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Pursuit Tech Cooldown")
	UVUnitPTRepairKitCooldown = CreateConVar("unitvehicle_unitpursuittech_cooldown_repairkit", 5, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Pursuit Tech Cooldown")
	UVUnitPTKillSwitchCooldown = CreateConVar("unitvehicle_unitpursuittech_cooldown_killswitch", 5, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Unit Pursuit Tech Cooldown")
	
	UVPBMax = CreateConVar("unitvehicle_pursuitbreaker_maxpb", 2, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVPBCooldown = CreateConVar("unitvehicle_pursuitbreaker_pbcooldown", 60, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	
	UVRBMax = CreateConVar("unitvehicle_roadblock_maxrb", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	UVRBOverride = CreateConVar("unitvehicle_roadblock_override", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED})
	
	unitvehicles = true
	
	UVHUDPursuit = nil
	UVHUDBusting = nil
	UVHUDCooldown = nil
	
	local SpawnCooldownTable = {}
	
	util.AddNetworkString("UVGetSettings_Local")
	util.AddNetworkString("UVUpdateSettings")
	util.AddNetworkString("UVBusted")
	
	for i = 1, 6 do
		util.AddNetworkString( "UVUMmaxunits" )
		util.AddNetworkString( "UVUMunitsavailable" )
		util.AddNetworkString( "UVUMbackuptimer" )
		util.AddNetworkString( "UVUMcooldowntimer" )
		util.AddNetworkString( "UVUMroadblocks" )
		util.AddNetworkString( "UVUMhelicopters" )
	end
	
	util.AddNetworkString( "UVHUDPursuit" )
	
	util.AddNetworkString( "UVHUDHeatLevel" )
	util.AddNetworkString( "UVHUDUnitsChasing" )
	util.AddNetworkString( "UVHUDResourcePoints" )
	util.AddNetworkString( "UVHUDBackupTimer" )
	util.AddNetworkString( "UVHUDStopBackupTimer" )
	util.AddNetworkString( "UVHUDWrecks" )
	util.AddNetworkString( "UVHUDTags" )
	util.AddNetworkString( "UVHUDTimer" )
	
	util.AddNetworkString( "UVHUDTimeStopped" )
	util.AddNetworkString( "UVHUDStopPursuit" )
	
	util.AddNetworkString( "UVHUDUpdateBusting" )
	util.AddNetworkString( "UVHUDBusting" )
	util.AddNetworkString( "UVHUDStopBusting" )
	util.AddNetworkString( "UVHUDStopBustingTimeLeft" )
	util.AddNetworkString( "UVHUDEnemyBusted" )
	
	util.AddNetworkString( "UVHUDEvading" )
	
	util.AddNetworkString( "UVHUDCooldown" )
	util.AddNetworkString( "UVHUDStopCooldown" )
	util.AddNetworkString( "UVHUDHiding" )
	util.AddNetworkString( "UVHUDStopHiding" )
	
	util.AddNetworkString( "UVHUDWantedSuspects" )
	
	util.AddNetworkString( "UVHUDCopMode" )
	util.AddNetworkString( "UVHUDStopCopMode" )
	
	util.AddNetworkString( "UVHUDCopModeBusting" )
	util.AddNetworkString( "UVHUDStopCopModeBusting" )
	
	util.AddNetworkString( "UVHUDBustedDebrief" )
	util.AddNetworkString( "UVHUDEscapedDebrief" )
	util.AddNetworkString( "UVHUDCopModeEscapedDebrief" )
	util.AddNetworkString( "UVHUDCopModeBustedDebrief" )
	
	util.AddNetworkString( "UVHUDWreckedDebrief" )
	util.AddNetworkString( "UVHUDRespawnInUV" )
	
	util.AddNetworkString( "UVHUDOneCommander" )
	util.AddNetworkString( "UVHUDStopOneCommander" )
	
	util.AddNetworkString( "UVHUDHeatLevelIncrease" )
	
	util.AddNetworkString( "UVHUDPursuitBreakers" )
	
	util.AddNetworkString( "UVHUDPursuitTech" )
	
	util.AddNetworkString( "UVHUDScanner" )
	util.AddNetworkString( "UVHUDStopScanner" )
	
	util.AddNetworkString( "UVHUDAddUV" )
	util.AddNetworkString( "UVHUDReAddUV" )
	util.AddNetworkString( "UVHUDRemoveUV" )
	
	util.AddNetworkString( "UVHUDTimeTillNextHeat" )
	
	util.AddNetworkString( "UVUpdateRacerName" )
	
	util.AddNetworkString( "UVUpdateSuspectVisibility" )
	
	util.AddNetworkString( "UVRacerJoin" )
	
	--Enemies can't exit the vehicle during pursuits or races
	hook.Add("CanExitVehicle", "UVExitingVehicleWhlistInPursuit", function( veh, ply)
		local vehicle_entity = veh:GetParent()
		
		if uvtargeting then return false end
		if (IsValid(vehicle_entity) and vehicle_entity.uvraceparticipant) or veh.uvraceparticipant then return false end
		//return (!uvtargeting)
	end)
	
	-- hook.Add("CanExitVehicle", "UVExitingVehicleWhlistInRace", function( veh, ply)
	-- 	return (!veh.uvraceparticipant)
	-- end)
	
	--Damage to UVs
	hook.Add( "EntityTakeDamage", "UVDamage", function( target, dmginfo )
		if VC then return end
		if target.UVPatrol or target.UVSupport or target.UVPursuit or target.UVInterceptor or target.UVSpecial or target.UVCommander then
			local damage = (dmginfo:GetDamage()*10)
			target:SetHealth(target:Health()-damage)
		end
	end )
	
	hook.Add("PostCleanupMap", "UVCleanup", function()
		uvtargeting = nil
		UVResetStats()
		uvpresencemode = false
		uvracerpresencemode = false
		uvcalllocation = nil
		uvcallexists = nil
		uvhiding = nil
		uvcommanderlasthealth = nil
		uvcommanderlastenginehealth = nil
		uvcommanders = {}
		uvwantedtabledriver = {}
		uvplayerunittableplayers = {}
		uvjammerdeployed = nil
		uvpreinfractioncount = 0
		if next(uvloadedpursuitbreakers) != nil then
			for k, v in pairs(uvloadedpursuitbreakers) do
				net.Start("UVTriggerPursuitBreaker")
				net.WriteString(v)
				net.Broadcast()
			end
		end
		uvloadedpursuitbreakers = {}
		uvloadedpursuitbreakersloc = {}
		uvloadedroadblocks = {}
		uvloadedroadblocksloc = {}
		net.Start( "UVHUDStopCopMode" )
		net.Broadcast()
	end)
	
	--Think
	hook.Add("Think", "UVServerThink", function()
		
		--Some figures
		if !uvhelicooldown then
			uvhelicooldown = -math.huge
		end
		if !uvcooldowntimer then
			uvcooldowntimer = 20
		end
		if !uvcooldowntimerprogress then
			uvcooldowntimerprogress = 0
		end
		if !uvcooldownprogresstimeout then
			uvcooldownprogresstimeout = CurTime()
		end
		if !uvbounty then
			uvbounty = 0
		end
		if !uvheatlevel then
			uvheatlevel = 1
		end
		if !uvwrecks then
			uvwrecks = 0
		end
		if !uvdeploys then
			uvdeploys = 0
		end
		if !uvtags then
			uvtags = 0
		end
		if !uvroadblocksdodged then
			uvroadblocksdodged = 0
		end
		if !uvspikestripsdodged then
			uvspikestripsdodged = 0
		end
		if !uvcombobounty then
			uvcombobounty = 1
		end
		if !uvbountytimer then 
			uvbountytimer = CurTime()
		end
		if !uvbountytimerprogress then
			uvbountytimerprogress = 0
		end
		if !uvbusting then 
			uvbusting = CurTime()
		end
		if !uvbustingprogress then
			uvbustingprogress = CurTime()
		end
		if !uvbustinglastprogress then 
			uvbustinglastprogress = CurTime()
		end
		if !uvbustinglastprogress2 then 
			uvbustinglastprogress2 = 0
		end
		if !uvlosing then 
			uvlosing = CurTime() 
		end
		if !uvbackuptimer then 
			uvbackuptimer = CurTime() 
		end
		if !uvpreinfractioncount then
			uvpreinfractioncount = 0
		end
		if !uvpreinfractioncountcooldown then
			uvpreinfractioncountcooldown = CurTime()
		end
		if !uvbustspeed or !uvcooldowntimer or !uvbackuptimermax then 
			UVUpdateHeatLevel() 
		end
		if !uvevading then
			uvevading = false
		end
		if !uvevadingtimer then
			uvevadingtimer = 0
		end
		if !uvunitschasing then
			uvunitschasing = {}
		end
		if !uvunitsbusting then
			uvunitsbusting = {}
		end
		if !uvwantedtablevehicle then
			uvwantedtablevehicle = {}
		end
		if !uvwantedtabledriver then
			uvwantedtabledriver = {}
		end
		if !uvpotentialsuspects then
			uvpotentialsuspects = {}
		end
		if !uvresourcepoints then
			uvresourcepoints = 10
		end
		if !uvmaxunits then
			uvmaxunits = 3
		end
		if !uvtacticformationno then
			uvtacticformationno = 1
		end
		if !uvsimfphysvehicleinitializing then
			uvsimfphysvehicleinitializing = {}
		end
		if !uvplayerunittablevehicle then
			uvplayerunittablevehicle = {}
		end
		if !uvplayerunittableplayers then
			uvplayerunittableplayers = {}
		end
		if !uvcommanders then
			uvcommanders = {}
		end
		if !uvrvwithpursuittech then
			uvrvwithpursuittech = {}
		end
		if !uvloadedpursuitbreakers then
			uvloadedpursuitbreakers = {}
		end
		if !uvloadedpursuitbreakersloc then
			uvloadedpursuitbreakersloc = {}
		end
		if !uvloadedroadblocks then
			uvloadedroadblocks = {}
		end
		if !uvloadedroadblocksloc then
			uvloadedroadblocksloc = {}
		end
		if !uvwreckedvehicles then
			uvwreckedvehicles = {}
		end
		if !uvunitvehicles then
			uvunitvehicles = {}
		end
		
		--One Commander Active
		if uvonecommanderactive then
			if !uvcommanderrespawning and (UVUOneCommander:GetInt() != 1 or next(uvcommanders) == nil) then
				uvonecommanderactive = nil
				uvcommanderlasthealth = nil
				uvcommanderlastenginehealth = nil
				net.Start("UVHUDStopOneCommander")
				net.Broadcast()
			end
			for k, v in pairs(uvcommanders) do
				if !IsValid(v) then
					table.RemoveByValue(uvcommanders, v)
				end
			end
		end
		
		if UVUOneCommander:GetInt() == 1 and next(uvcommanders) != nil then
			uvonecommanderactive = true
			net.Start("UVHUDOneCommander")
			net.WriteEntity(uvcommanders[1])
			net.Broadcast()
		end
		
		--Bounty
		if !uvtargeting then
			uvbountytimer = CurTime()
			uvhiding = nil
			if uvonecommanderdeployed then
				if !uvonecommanderactive then
					uvonecommanderdeployed = nil
				end
			end
			if uvcommanderrespawning then
				uvcommanderrespawning = nil
			end
			if uvcommanderlasthealth then
				uvcommanderlasthealth = nil
				uvcommanderlastenginehealth = nil
			end
		else
			if !uvenemyescaping then
				uvbountytimerprogress = CurTime() - uvbountytimer
				uvhiding = nil
			else
				uvbountytimer = CurTime() - uvbountytimerprogress
			end
		end
		
		local botimeout = 10
		if uvbountytimerprogress >= botimeout then
			uvbounty = uvbounty+uvbountytime
			uvbountytimer = CurTime()
			if #uvloadedpursuitbreakers < UVPBMax:GetInt() then
				UVAutoLoadPursuitBreaker()
			end
		end
		
		local ltimeout = (uvcooldowntimer+5)
		
		--Idle presence
		if !uvtargeting and (uvpresencemode or uvracerpresencemode) and #ents.FindByClass("npc_uv*") < uvheatlevel then
			local ply = Entity(1)
			if !ply then 
				return 
			end
			if uvidlespawning - CurTime() + 5 <= 0 then
				if SpawnMainUnits:GetBool() and uvpresencemode then
					UVAutoSpawn(ply)
				end
				if uvracerpresencemode and #ents.FindByClass("npc_racervehicle") < uvheatlevel then
					UVAutoSpawnRacer(ply)
				end
				uvidlespawning = CurTime()
			end
		end
		
		--Deploying backup
		if !uvtargeting or uvenemybusted or uvenemyescaped then
			uvbackuptimer = CurTime()
		end
		
		local backuptimeout = 2
		
		if backuptimeout then
			if CurTime() > uvbackuptimer + backuptimeout then
				if HeatLevels:GetBool() then
					UVUpdateHeatLevel()
				end
				if #uvunitschasing < 2 then
					uvtacticformationno = math.random(0,6)
				end
				UVChangeTactics(uvtacticformationno)
				uvbackuptimer = CurTime()
			end
		end
		
		--Actual backup timer
		if uvtargeting then
			if uvresourcepoints < uvmaxunits then
				if !uvbackupontheway then
					uvresourcepointstimer = CurTime()
					uvresourcepointstimermax = uvbackuptimermax
					uvbackupontheway = true
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
					net.WriteString(uvresourcepointstimerleft)
					net.Broadcast()
				end
				if !uvresourcepointstimermax then
					uvresourcepointstimermax = uvbackuptimermax
				end
				uvresourcepointstimerleft = (uvresourcepointstimer - CurTime() + uvresourcepointstimermax)
				if uvresourcepointstimerleft <= 10 then
					if !uvbackuptenseconds then
						uvbackuptenseconds = true
						--Entity(1):EmitSound("ui/pursuit/backup/countdown_start.wav", 0, 100, 0.5, CHAN_STATIC)
						--Entity(1):EmitSound("ui/pursuit/backup/countdown_tick.wav", 0, 100, 0.5, CHAN_STATIC)
						UVRelaySoundToClients("ui/pursuit/backup/countdown_start.wav", false)
						UVRelaySoundToClients("ui/pursuit/backup/countdown_tick.wav", false)
						timer.Create( "UVBackupTenSecondsTick", 1, 9, function() 
							--Entity(1):EmitSound("ui/pursuit/backup/countdown_tick.wav", 0, 100, 0.5, CHAN_STATIC)
							UVRelaySoundToClients("ui/pursuit/backup/countdown_tick.wav", false)
						end)
						timer.Create( "UVBackupTenSeconds3", 7, 1, function() 
							--Entity(1):EmitSound("ui/pursuit/backup/countdown_3.wav", 0, 100, 0.5, CHAN_STATIC)
							UVRelaySoundToClients("ui/pursuit/backup/countdown_3.wav", false)
						end)
						timer.Create( "UVBackupTenSeconds2", 8, 1, function() 
							--Entity(1):EmitSound("ui/pursuit/backup/countdown_2.wav", 0, 100, 0.5, CHAN_STATIC)
							UVRelaySoundToClients("ui/pursuit/backup/countdown_2.wav", false)
						end)
						timer.Create( "UVBackupTenSeconds1", 9, 1, function() 
							--Entity(1):EmitSound("ui/pursuit/backup/countdown_1.wav", 0, 100, 0.5, CHAN_STATIC)
							UVRelaySoundToClients("ui/pursuit/backup/countdown_1.wav", false)
						end)
						timer.Create( "UVBackupTenSecondsEnd", 10, 1, function() 
							--Entity(1):EmitSound("ui/pursuit/backup/countdown_end.wav", 0, 100, 0.5, CHAN_STATIC)
							UVRelaySoundToClients("ui/pursuit/backup/countdown_end.wav", false)
						end)
					end
				else
					if uvbackuptenseconds then
						uvbackuptenseconds = nil
					end
				end
				if uvresourcepointstimerleft <= 0 and uvbackupontheway then
					uvresourcepointstimer = CurTime()
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
				if uvbackupontheway then
					uvbackupontheway = nil
				end
				uvresourcepointstimer = CurTime()
				net.Start( "UVHUDStopBackupTimer" )
				net.Broadcast()
			end
		end
		
		--Check if busting/hiding
		if next(uvwantedtablevehicle) != nil then
			for k, v in pairs(uvwantedtablevehicle) do
				if !v.uvbustingprogress then
					v.uvbustingprogress = 0
				end
				if !v.uvbustinglastprogress then 
					v.uvbustinglastprogress = CurTime()
				end
				if !v.uvbustinglastprogress2 then 
					v.uvbustinglastprogress2 = CurTime()
				end
				UVCheckIfBeingBusted(v)
			end
			if #uvwantedtablevehicle == 1 and uvenemyescaping then
				UVCheckIfHiding(uvwantedtablevehicle[1])
			end
		end
		
		if next(uvpotentialsuspects) != nil then
			for k, v in pairs(uvpotentialsuspects) do
				if uvtargeting and !table.HasValue(uvwantedtablevehicle, v) then
					UVAddToWantedListVehicle(v)
				end
			end
		end
		
		if next(uvsimfphysvehicleinitializing) != nil then
			for k, car in pairs(uvsimfphysvehicleinitializing) do
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
						table.insert(uvcommanders, car)
						uvcommanderrespawning = nil
					end
					if !car.UnitVehicle then 
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
					table.RemoveByValue(uvsimfphysvehicleinitializing, car)
				end
			end
		end
		
		local player_unit_active = false
		
		--Player-controlled Unit Vehicles
		if next(uvplayerunittablevehicle) != nil then
			for k, car in pairs(uvplayerunittablevehicle) do
				
				if !table.HasValue(uvunitvehicles, car) and car.UnitVehicle then
					table.insert(uvunitvehicles, car)
				end
				
				if IsValid(car) and !car.wrecked and
				(car:Health() <= 0 and car:GetClass() == "prop_vehicle_jeep" or --No health 
				car.uvclasstospawnon != "npc_uvcommander" and car:GetPhysicsObject():GetAngles().z > 90 and car:GetPhysicsObject():GetAngles().z < 270 and car.rammed --[[or car:GetVelocity():LengthSqr() < 10000)]] or --Flipped
				car:WaterLevel() > 2 or --Underwater
				car:IsOnFire() or --On fire
				UVPlayerIsWrecked(car)) then --Other parameters
					UVPlayerWreck(car)
				end
				
				if UVGetDriver(car):IsPlayer() then
					local driver = UVGetDriver(car)
					if car.PursuitTech then
						-- local status = car.PursuitTechStatus or "Ready"
						-- net.Start( "UVHUDPursuitTech" )
						-- net.WriteString(car.PursuitTech)
						-- net.WriteString(status)
						-- net.Send(driver)
						net.Start("UVHUDPursuitTech")
						net.WriteTable(car.PursuitTech)
						net.Send(driver)
					end
					
					player_unit_active = true
					
					if !table.HasValue(uvplayerunittableplayers, driver) then
						table.insert(uvplayerunittableplayers, driver)
						driver.uvplayerlastvehicle = car
						hook.Add("CanExitVehicle", "UVPlayerExitUnitVehicle", function(vehicle, driver)
							if uvtargeting then return end
							if table.HasValue(uvplayerunittableplayers, driver) then
								table.RemoveByValue(uvplayerunittableplayers, driver)
								hook.Remove( "simfphysOnDestroyed", "UVExplosion"..car:EntIndex())
								UVDeactivateESF(car)
								net.Start( "UVHUDStopCopMode" )
								net.Send(driver)
							end
						end)
						hook.Add("PostPlayerDeath", "UVPlayerKilled", function(driver)
							if table.HasValue(uvplayerunittableplayers, driver) then
								table.RemoveByValue(uvplayerunittableplayers, driver)
								hook.Remove( "simfphysOnDestroyed", "UVExplosion"..car:EntIndex())
								UVDeactivateESF(car)
								net.Start( "UVHUDStopCopMode" )
								net.Send(driver)
							end
						end)
						hook.Add( "simfphysOnDestroyed", "UVExplosion"..car:EntIndex(), function(car, gib) 
							if table.HasValue(uvplayerunittableplayers, driver) then
								table.RemoveByValue(uvplayerunittableplayers, driver)
								hook.Remove( "simfphysOnDestroyed", "UVExplosion"..car:EntIndex())
								UVDeactivateESF(car)
								net.Start( "UVHUDStopCopMode" )
								net.Send(driver)
							end
							if !car.UnitVehicle or car.wrecked then return end
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
				
				local closestsuspect
				local closestdistancetosuspect
				
				local suspects = uvwantedtablevehicle
				
				local r = math.huge
				local closestdistancetosuspect, closestsuspect = r^2
				for i, w in pairs(suspects) do
					local enemypos = w:WorldSpaceCenter()
					local distance = enemypos:DistToSqr(car:WorldSpaceCenter())
					if distance < closestdistancetosuspect then
						closestdistancetosuspect, closestsuspect = distance, w
					end
					
					--local last_visible_value = w.inunitview
					
					-- local visualrange = 25000000
					-- if uvhiding then
					-- 	visualrange = 1000000
					-- end
					
					-- if UVVisualOnTarget(car, w) and car.uvplayerdistancetoenemy < visualrange then
					-- 	w.inunitview = true
					-- 	table.insert(visible_suspects, w)
					-- else
					-- 	if !table.HasValue(visible_suspects, w) then
					-- 		w.inunitview = false 
					-- 	end
					-- end
					
					-- if last_visible_value ~= w.inunitview then
					-- 	net.Start( "UVUpdateSuspectVisibility" )
					
					-- 	net.WriteEntity(w)
					-- 	net.WriteBool(w.inunitview)
					
					-- 	net.Broadcast()
					-- end
				end
				
				if IsValid(closestsuspect) then
					if closestsuspect.IsSimfphyscar or closestsuspect.IsGlideVehicle or closestsuspect:GetClass() == "prop_vehicle_jeep" then
						if !IsValid(car.e) then
							car.e = closestsuspect
							UVAddToWantedListVehicle(closestsuspect)
						elseif car.e != closestsuspect then
							car.e = closestsuspect
							UVAddToWantedListVehicle(closestsuspect)
						end
						car.uvplayerdistancetoenemy = closestdistancetosuspect
					end
				end
				
				if IsValid(car.e) and car.uvplayerdistancetoenemy then
					local visualrange = 25000000
					if uvhiding then
						visualrange = 1000000
					end
					if UVVisualOnTarget(car, car.e) and car.uvplayerdistancetoenemy < visualrange then
						uvlosing = CurTime()
						if !table.HasValue(uvunitschasing, car) then
							table.insert(uvunitschasing, car)
						end
					else
						if table.HasValue(uvunitschasing, car) then
							table.RemoveByValue(uvunitschasing, car)
						end
					end
				else
					if table.HasValue(uvunitschasing, car) then
						table.RemoveByValue(uvunitschasing, car)
					end
				end
			end
		end
		
		UVUnitsHavePlayers = player_unit_active
		
		if next(ents.FindByClass("npc_uv*")) != nil then
			for k, unit in pairs(ents.FindByClass("npc_uv*")) do
				if !unit.v then return end
				if !table.HasValue(uvunitvehicles, unit.v) then
					table.insert(uvunitvehicles, unit.v)
				end
			end
		end
		
		local visible_suspects = {}
		
		if next(uvunitvehicles) != nil or (uvtargeting and !uvenemyescaping) then
			for k, unit in pairs(uvunitvehicles) do
				if !IsValid(unit) or !unit.UnitVehicle then
					table.RemoveByValue(uvunitvehicles, unit)
					continue
				end
				for _, v in pairs(uvwantedtablevehicle) do
					local last_visible_value = v.inunitview
					
					local visualrange = 25000000
					if uvhiding then
						visualrange = 1000000
					end
					
					local check = false
					
					for _, j in pairs(ents.FindByClass("uvair")) do
						if !(j.Downed and j.disengaging and j.crashing) and j:GetTarget() == v then
							v.inunitview = true
							check = true
							table.insert(visible_suspects, v)
						end
					end
					
					if !check then
						if UVVisualOnTarget(unit, v) then
							v.inunitview = true
							table.insert(visible_suspects, v)
						else
							if !table.HasValue(visible_suspects, v) then
								v.inunitview = false 
							end
						end
					end
					
					if last_visible_value ~= v.inunitview then
						net.Start( "UVUpdateSuspectVisibility" )
						
						net.WriteEntity(v)
						net.WriteBool(v.inunitview)
						
						net.Broadcast()
					end
				end
			end
			if !uvhudscanner then
				uvhudscanner = true
			end
			for k, players in ipairs(player.GetAll()) do
				if !IsValid(players) then continue end
				local enemypos = players:GetPos()
				local r = math.huge
				local closestdistancetounit, closestunit = r^2
				for i, w in pairs(uvunitvehicles) do
					if !IsValid(w) then continue end
					local distance = enemypos:DistToSqr(w:GetPos())
					if distance < closestdistancetounit then
						closestdistancetounit, closestunit = distance, w
					end
				end
				if IsValid(closestunit) then
					local posx = closestunit:GetPos().x
					local posy = closestunit:GetPos().y
					local posz = closestunit:GetPos().z
					net.Start( "UVHUDScanner" )
					net.WriteInt(posx, 32)
					net.WriteInt(posy, 32)
					net.WriteInt(posz, 32)
					net.Send(players)
				end
			end
		else
			if uvhudscanner then
				uvhudscanner = nil
				for k, players in ipairs(player.GetAll()) do
					net.Start( "UVHUDStopScanner" )
					net.Send(players)
				end
			end
		end
		
		--Player-controlled Racers
		if next(uvrvwithpursuittech) != nil then
			for k, car in pairs(uvrvwithpursuittech) do
				local driver = UVGetDriver(car)
				if !driver or !driver:IsPlayer() then continue end
				if car.PursuitTech then
					net.Start( 'UVHUDPursuitTech' )
					net.WriteTable(car.PursuitTech)
					-- local status = car.PursuitTechStatus or "Ready"
					-- net.Start( "UVHUDPursuitTech" )
					-- net.WriteString(car.PursuitTech)
					-- net.WriteString(status)
					net.Send(driver)
				end
			end
		end
		
		--Wrecked vehicles
		if next(uvwreckedvehicles) != nil then
			for k, car in pairs(uvwreckedvehicles) do
				if IsValid(car) then
					if #uvwantedtablevehicle == 1 and !uvracerpresencemode then
						local carpos = car:GetPos()
						local suspect = uvwantedtablevehicle[1]
						local enemylocation = (suspect:GetPos()+Vector(0,0,50))
						local distance = enemylocation - carpos
						if distance:LengthSqr() > 100000000 then
							car:Remove()
						end
					else
						break
					end
				else
					table.RemoveByValue(uvwreckedvehicles, car)
				end
			end
		end
		
		--Idle chatter
		if #ents.FindByClass("npc_uv*") > 0 and !uvtargeting then
			if !(timer.Exists("uvidletalk")) then
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
		
		if uvtargeting then
			if !UVTimer then
				UVTimer = CurTime()
			end
		end
		
		if #ents.FindByClass("npc_uv*") == 0 and IsValid(uvenemylocation) and !uvtargeting then 
			uvenemylocation:Remove() 
		end
		
		--Losing		
		local ltimeout = (uvcooldowntimer+5)
		
		if UVHUDPursuit then
			if #uvunitschasing <= 0 and not ((not UVUCommanderEvade:GetBool()) and uvonecommanderactive) then
				if !uvevadingprogress or uvevadingprogress == 0 then
					uvevadingprogress = CurTime()
				end
				net.Start("UVHUDEvading")
				net.WriteBool(true)
				net.WriteString(math.Clamp((CurTime() - uvevadingprogress) / 5, 0, 1))
				net.Broadcast()
			else
				uvevadingprogress = 0
				net.Start("UVHUDEvading")
				net.WriteBool(false)
				net.WriteString(0)
				net.Broadcast()
			end
		end
		
		if not uvenemyescaped and uvtargeting and uvlosing != CurTime() and (uvlosing - CurTime() + ltimeout) < (ltimeout - 5) and #uvwantedtablevehicle > 0 then
			if not uvenemyescaping then
				uvenemyescaping = true
				uvcooldownprogresstimeout = CurTime()
				if timer.Exists("UVTimeTillNextHeat") then
					timer.Pause("UVTimeTillNextHeat")
				end
				if Chatter:GetBool() and not uvcalm and not uvenemybusted then
					if next(ents.FindByClass("npc_uv*")) ~= nil then
						local units = ents.FindByClass("npc_uv*")
						local random_entry = math.random(#units)	
						local unit = units[random_entry]
						UVChatterLosing(unit)
						timer.Simple(math.random(10,20), function()
							if uvenemyescaping and IsValid(unit) then
								UVChatterLosingUpdate(unit) 
							end
						end)
					end
				end
				--Entity(1):EmitSound("ui/pursuit/escaping.wav", 0, 100, 0.5)
				UVRelaySoundToClients("ui/pursuit/escaping.wav", false)
			end
			if uvenemyescaping then
				local cooldowntimer = uvcooldowntimer
				if uvhiding then
					cooldowntimer = cooldowntimer/4
				end
				local cooldownprogresstick = 0.01
				local cooldownprogress = ((1/cooldowntimer)*cooldownprogresstick)
				if CurTime() > uvcooldownprogresstimeout + cooldownprogresstick then
					uvcooldowntimerprogress = uvcooldowntimerprogress+cooldownprogress
					uvcooldownprogresstimeout = CurTime()
				end 
			end
		else
			if uvenemyescaping and !uvenemyescaped and !uvenemybusted then
				uvenemyescaping = nil
				uvcooldowntimerprogress = 0
				if timer.Exists("UVTimeTillNextHeat") then
					timer.UnPause("UVTimeTillNextHeat")
				end
				if uvtargeting then 
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
				if Chatter:GetBool() and not uvcalm and not uvenemybusted then
					local airunits = ents.FindByClass("uvair")
					if next(airunits) ~= nil then
						local random_entry = math.random(#airunits)	
						local unit = airunits[random_entry]
						if !(unit.crashing or unit.disengaging) then
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
		if uvtargeting and !uvenemyescaped and uvcooldowntimer then
			if uvcooldowntimerprogress >= 1 then
				uvcooldowntimerprogress = 0
				uvtargeting = nil
				uvenemyescaped = true
				timer.Simple(10, function() if uvenemyescaped then uvenemyescaped = nil end end)
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
		if (NeverEvade:GetBool() and uvtargeting) or (((not UVUCommanderEvade:GetBool()) and uvonecommanderactive) and not uvenemyescaping) then
			uvlosing = CurTime()
		end
		
		for _, v in pairs(uvwantedtablevehicle) do
			if v.racer then
				net.Start( "UVUpdateRacerName" )
				net.WriteEntity( v )
				net.WriteString( v.racer )
				net.Broadcast()
			end
		end
		
		net.Start( "UVHUDWantedSuspects" )
		net.WriteTable(uvwantedtablevehicle)
		net.Broadcast()
		
		--HUD Triggers
		if uvtargeting then
			if uvbounty < UVUHeatMinimumBounty1:GetInt() and UVUTimeTillNextHeatEnabled:GetInt() != 1 then
				uvbounty = UVUHeatMinimumBounty1:GetInt()
			end
			
			if !UVHUDPursuit then
				uvlosing = CurTime()
				uvevadingprogress = CurTime()
				UVRestoreResourcePoints()
				for _, ent in ents.Iterator() do
					if !IsValid(ent) then continue end
					if UVPassConVarFilter(ent) then
						UVAddToWantedListVehicle(ent)
					end
				end
				if uvheatlevel <= 3 then
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
			
			UVHUDPursuit = true
			net.Start( "UVHUDPursuit" )
			net.WriteString(uvbounty)
			net.Broadcast()
			net.Start( "UVHUDHeatLevel" )
			net.WriteString(uvheatlevel)
			net.Broadcast()
			net.Start( "UVHUDUnitsChasing" )
			net.WriteString(#uvunitschasing)
			net.Broadcast()
			net.Start( "UVHUDResourcePoints" )
			net.WriteString(uvresourcepoints)
			net.Broadcast()
			net.Start( "UVHUDTimer" )
			net.WriteString(UVTimer)
			net.Broadcast()
			net.Start( "UVHUDWrecks" )
			net.WriteString(uvwrecks)
			net.Broadcast()
			net.Start( "UVHUDTags" )
			net.WriteString(uvtags)
			net.Broadcast()
			
			if timer.Exists("UVTimeTillNextHeat") then
				if timer.TimeLeft("UVTimeTillNextHeat") >= 0 then
					net.Start( "UVHUDTimeTillNextHeat" )
					net.WriteString(timer.TimeLeft("UVTimeTillNextHeat"))
					net.Broadcast()
				end
			elseif UVUTimeTillNextHeatEnabled:GetInt() == 1 then
				local TimeTillNextHeat = 120
				
				if uvheatlevel == 1 then
					TimeTillNextHeat = UVUTimeTillNextHeat1:GetInt()
				elseif uvheatlevel == 2 then
					TimeTillNextHeat = UVUTimeTillNextHeat2:GetInt()
				elseif uvheatlevel == 3 then
					TimeTillNextHeat = UVUTimeTillNextHeat3:GetInt()
				elseif uvheatlevel == 4 then
					TimeTillNextHeat = UVUTimeTillNextHeat4:GetInt()
				elseif uvheatlevel == 5 then
					TimeTillNextHeat = UVUTimeTillNextHeat5:GetInt()
				end
				
				-- local lang = language.GetPhrase
				
				timer.Create("UVTimeTillNextHeat", TimeTillNextHeat, 0, function()
					if UVUTimeTillNextHeatEnabled:GetInt() != 1 then
						timer.Remove("UVTimeTillNextHeat")
						return
					end
					if uvheatlevel < 2  and !(MaxHeatLevel:GetInt() < 2) and MinHeatLevel:GetInt() <= 2 then 
						uvheatlevel = 2
						timer.Adjust("UVTimeTillNextHeat", UVUTimeTillNextHeat2:GetInt(), 0)
						-- PrintMessage( HUD_PRINTCENTER, string.format( lang("uv.hud.heatlvl"), 2 ) )
						if next(ents.FindByClass("npc_uv*")) ~= nil and Chatter:GetBool() then
							local units = ents.FindByClass("npc_uv*")
							local random_entry = math.random(#units)	
							local unit = units[random_entry]
							if !uvtargeting then return end
							UVChatterHeatTwo(unit)
						end
						if uvtargeting then
							--Entity(1):EmitSound("ui/pursuit/heatlevelrise.wav", 0, 100, 0.5)
							UVRelaySoundToClients("ui/pursuit/heatlevelrise.wav", false)
						end
						net.Start("UVHUDHeatLevelIncrease")
						net.Broadcast()
						UVUpdateHeatLevel()
					elseif uvheatlevel < 3 and !(MaxHeatLevel:GetInt() < 3) and MinHeatLevel:GetInt() <= 3 then
						uvheatlevel = 3
						timer.Adjust("UVTimeTillNextHeat", UVUTimeTillNextHeat3:GetInt(), 0)
						-- PrintMessage( HUD_PRINTCENTER, string.format( lang("uv.hud.heatlvl"), 3 ) )
						if next(ents.FindByClass("npc_uv*")) ~= nil and Chatter:GetBool() then
							local units = ents.FindByClass("npc_uv*")
							local random_entry = math.random(#units)	
							local unit = units[random_entry]
							if !uvtargeting then return end
							UVChatterHeatThree(unit)
						end
						if uvtargeting then
							--Entity(1):EmitSound("ui/pursuit/heatlevelrise.wav", 0, 100, 0.5)
							UVRelaySoundToClients("ui/pursuit/heatlevelrise.wav", false)
						end
						net.Start("UVHUDHeatLevelIncrease")
						net.Broadcast()
						UVUpdateHeatLevel()
					elseif uvheatlevel < 4 and !(MaxHeatLevel:GetInt() < 4) and MinHeatLevel:GetInt() <= 4 then
						uvheatlevel = 4
						timer.Adjust("UVTimeTillNextHeat", UVUTimeTillNextHeat4:GetInt(), 0)
						-- PrintMessage( HUD_PRINTCENTER, string.format( lang("uv.hud.heatlvl"), 4 ) )
						if next(ents.FindByClass("npc_uv*")) ~= nil and Chatter:GetBool() then
							local units = ents.FindByClass("npc_uv*")
							local random_entry = math.random(#units)	
							local unit = units[random_entry]
							if !uvtargeting then return end
							UVChatterHeatFour(unit)
						end
						if uvtargeting then
							--Entity(1):EmitSound("ui/pursuit/heatlevelrise.wav", 0, 100, 0.5)
							UVRelaySoundToClients("ui/pursuit/heatlevelrise.wav", false)
						end
						net.Start("UVHUDHeatLevelIncrease")
						net.Broadcast()
						UVUpdateHeatLevel()
					elseif uvheatlevel < 5 and !(MaxHeatLevel:GetInt() < 5) and MinHeatLevel:GetInt() <= 5 then
						uvheatlevel = 5
						timer.Adjust("UVTimeTillNextHeat", UVUTimeTillNextHeat5:GetInt(), 0)
						-- PrintMessage( HUD_PRINTCENTER, string.format( lang("uv.hud.heatlvl"), 5 ) )
						if next(ents.FindByClass("npc_uv*")) ~= nil and Chatter:GetBool() then
							local units = ents.FindByClass("npc_uv*")
							local random_entry = math.random(#units)	
							local unit = units[random_entry]
							if !uvtargeting then return end
							UVChatterHeatFive(unit)
						end
						if uvtargeting then
							--Entity(1):EmitSound("ui/pursuit/heatlevelrise.wav", 0, 100, 0.5)
							UVRelaySoundToClients("ui/pursuit/heatlevelrise.wav", false)
						end
						net.Start("UVHUDHeatLevelIncrease")
						net.Broadcast()
						UVUpdateHeatLevel()
					elseif uvheatlevel < 6 and !(MaxHeatLevel:GetInt() < 6) and MinHeatLevel:GetInt() <= 6 then
						uvheatlevel = 6
						timer.Adjust("UVTimeTillNextHeat", UVUTimeTillNextHeat5:GetInt(), 0)
						-- PrintMessage( HUD_PRINTCENTER, string.format( lang("uv.hud.heatlvl"), 6 ) )
						if next(ents.FindByClass("npc_uv*")) ~= nil and Chatter:GetBool() then
							local units = ents.FindByClass("npc_uv*")
							local random_entry = math.random(#units)	
							local unit = units[random_entry]
							if !uvtargeting then return end
							UVChatterHeatSix(unit)
						end
						if uvtargeting then
							--Entity(1):EmitSound("ui/pursuit/heatlevelrise.wav", 0, 100, 0.5)
							UVRelaySoundToClients("ui/pursuit/heatlevelrise.wav", false)
						end
						net.Start("UVHUDHeatLevelIncrease")
						net.Broadcast()
						UVUpdateHeatLevel()
					end
					
				end)
			end
			
		else	
			if UVHUDPursuit then
				UVHUDPursuit = nil
				net.Start( "UVHUDStopPursuit" )
				net.Broadcast()
				UVHUDBusting = nil
				net.Start( "UVHUDStopBusting" )
				net.Broadcast()
				uvracerpresencemode = false
				if timer.Exists("UVTimeTillNextHeat") then
					timer.Pause("UVTimeTillNextHeat")
				end
			end
			
		end
		
		net.Start("UVHUDPursuitBreakers")
		net.WriteTable(uvloadedpursuitbreakersloc)
		net.Broadcast()
		
		if uvenemybusted and next(uvwantedtablevehicle) == nil then
			net.Start( "UVHUDEnemyBusted" )
			net.Broadcast()
		end
		
		if not uvenemyescaped and uvtargeting and uvenemyescaping and !uvenemybusted then
			UVHUDCooldown = true
			net.Start( "UVHUDCooldown" )
			net.WriteString(uvcooldowntimerprogress)
			net.Broadcast()
		elseif UVHUDCooldown then
			UVHUDCooldown = nil
			net.Start( "UVHUDStopCooldown" )
			net.Broadcast()
		end
		
		if uvhiding and uvenemyescaping then
			if uvhiding and !UVHUDHiding then
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
	
	--Print results
	net.Receive("UVHUDTimeStopped", function()
		if uvhudtimestopped then return end
		uvhudtimestopped = true
		local time = net.ReadString()
		local timeformatted = UVDisplayTime(time)
		if !uvenemyescaped then --busted
			print("The pursuit lasted with a time of "..timeformatted.."!")
			local bustedtable = {}
			bustedtable["Deploys"] = uvdeploys
			bustedtable["Roadblocks"] = uvroadblocksdodged
			bustedtable["Spikestrips"] = uvspikestripsdodged
			net.Start( "UVHUDCopModeBustedDebrief" )
			net.WriteTable(bustedtable)
			net.Send(uvplayerunittableplayers)
		else --escaped
			for k, v in pairs(player.GetAll()) do
				print(v:GetName().." ("..string.Comma(uvbounty).." Bounty, "..uvwrecks.." Wreck(s), "..uvtags.." Tags(s)) has escaped from the Unit Vehicles with a time of "..timeformatted.."!")
			end
			local escapedtable = {}
			escapedtable["Deploys"] = uvdeploys
			escapedtable["Roadblocks"] = uvroadblocksdodged
			escapedtable["Spikestrips"] = uvspikestripsdodged
			net.Start( "UVHUDEscapedDebrief" )
			net.WriteTable(escapedtable)
			net.Send(uvwantedtabledriver)
			net.Start( "UVHUDCopModeEscapedDebrief" )
			net.WriteTable(escapedtable)
			net.Send(uvplayerunittableplayers)
		end
		
		timer.Simple(1, function()
			uvhudtimestopped = nil
			if !uvtargeting then
				UVResetStats()
			end
		end)
	end)
	
	net.Receive("UVHUDRespawnInUV", function( length, ply )
		if IsValid(ply.uvplayerlastvehicle) and ply.uvplayerlastvehicle.wrecked then
			SpawnCooldownTable[ply] = CurTime()
			
			ply:ExitVehicle()
			ply:Spawn()
			ply.uvplayerlastvehicle:Remove()
			UVAutoSpawn(ply, nil, nil, true)
		else
			if !SpawnCooldownTable[ply] then
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
			if IsValid(ply.uvplayerlastvehicle) and !ply.uvplayerlastvehicle.wrecked then
				ply.uvplayerlastvehicle:Remove()
			end
			UVAutoSpawn(ply, nil, nil, true)
		end
	end)
	
	net.Receive("UVHUDReAddUV", function( length, ply )
		local unitindex = net.ReadInt(32)
		local typestring = net.ReadString()
		local unit = Entity(unitindex)
		if !IsValid(unit) then return end
		net.Start("UVHUDAddUV")
		net.WriteInt(unitindex, 32)
		net.WriteString(typestring)
		net.Send(ply)
	end)
	
	-- net.Receive("UVGetSettings", function( len, ply )
	-- 	local convar_table = {}
	
	-- 	for convar_name, convar_type in pairs(local_convars) do
	-- 		local convar = GetConVar(convar_name)
	-- 		local value = nil
	
	-- 		if convar_type == 'boolean' then
	-- 			value = convar:GetBool()
	-- 		elseif convar_type == 'integer' then
	-- 			value = convar:GetInt()
	-- 		elseif convar_type == 'string' then
	-- 			value = convar:GetString()
	-- 		end
	
	-- 		if not value then continue end
	
	-- 		--convar_name = string.gsub(convar_name, "_local", "")
	-- 		convar_table[convar_name] = value
	-- 	end
	
	-- 	net.Start("UVGetSettings_Local")
	-- 	net.WriteTable(convar_table)
	-- 	net.Send(ply)
	-- end)
	
	gameevent.Listen( "player_activate" )
	hook.Add( "player_activate", "player_activate_example", function( data ) 
		local id = data.userid				// Same as Player:UserID() for the speaker
		local ply = Player(id)
		
		print('Unit Vehicles:', 'Initializing for -', ply)
		// Called when a player is fully connected and loaded
		
		for _, v in pairs(uvwantedtablevehicle) do
			net.Start( "UVUpdateSuspectVisibility" )
			
			net.WriteEntity(v)
			net.WriteBool(v.inunitview)
			
			net.Send(ply)
		end
		
		local convar_table = {}
		
		for convar_name, convar_type in pairs(local_convars) do
			local convar = GetConVar(convar_name)
			local value = nil
			
			if convar_type == 'boolean' then
				value = convar:GetBool()
			elseif convar_type == 'integer' then
				value = convar:GetInt()
			elseif convar_type == 'string' then
				value = convar:GetString()
			end
			
			if not value then continue end
			
			--convar_name = string.gsub(convar_name, "_local", "")
			convar_table[convar_name] = value
		end
		
		net.Start("UVGetSettings_Local")
		net.WriteTable(convar_table)
		net.Send(ply)
		
	end )	
	
	net.Receive("UVUpdateSettings", function(len, ply)
		if !ply:IsSuperAdmin() then return end
		local array = net.ReadTable()
		
		for key, value in pairs(array) do
			local valid = string.match(key, 'unitvehicle_')
			if not valid then continue end
			RunConsoleCommand(key, value)
		end
		
		local convar_table = {}
		
		-- for convar_name, convar_type in pairs(local_convars) do
		-- 	local convar = GetConVar(convar_name)
		-- 	local value = nil
		
		-- 	if convar_type == 'boolean' then
		-- 		value = convar:GetBool()
		-- 	elseif convar_type == 'integer' then
		-- 		value = convar:GetInt()
		-- 	elseif convar_type == 'string' then
		-- 		value = convar:GetString()
		-- 	end
		
		-- 	if not value then continue end
		
		-- 	--convar_name = string.gsub(convar_name, "_local", "")
		-- 	convar_table[convar_name] = value
		-- end
		
		net.Start("UVGetSettings_Local")
		net.WriteTable(array)
		net.Broadcast()
	end)
	
else --HUD/Options
	local displaying_busted = false 
	local IsSettingKeybind = false
	
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
	RacerTags = CreateClientConVar("unitvehicle_racertags", 1, true, false, "Unit Vehicles: If set to 1, Racers will have their own tags which you can see as a cop during pursuits.")
	RacerPursuitTech = CreateClientConVar("unitvehicle_racerpursuittech", 1, true, false, "Unit Vehicles: If set to 1, Racers will spawn with pursuit tech (spike strips, ESF, etc.).")
	RacerFriendlyFire = CreateClientConVar("unitvehicle_racerfriendlyfire", 1, true, false, "Unit Vehicles: If set to 1, Racers will be able to attack eachother with Pursuit Tech.")
	
	-- unit convars
	UVUVehicleBase = CreateClientConVar("unitvehicle_unit_vehiclebase", 1, true, false, "\n1 = Default Vehicle Base (prop_vehicle_jeep)\n2 = simfphys\n3 = Glide")
	UVUOneCommander = CreateClientConVar("unitvehicle_unit_onecommander", 0, true, false)
	UVUOneCommanderHealth = CreateClientConVar("unitvehicle_unit_onecommanderhealth", 1, true, false)
	
	UVUPursuitTech = CreateClientConVar("unitvehicle_unit_pursuittech", 1, true, false, "Unit Vehicles: If set to 1, AI and player-controlled Unit Vehicles can use weapons (spike strips, ESF, EMP, etc.).")
	UVUPursuitTech_ESF = CreateClientConVar("unitvehicle_unit_pursuittech_esf", 1, true, false, "Unit Vehicles: If set to 1, AI and player-controlled Unit Vehicles can spawn with ESF.")
	UVUPursuitTech_Spikestrip = CreateClientConVar("unitvehicle_unit_pursuittech_spikestrip", 1, true, false, "Unit Vehicles: If set to 1, AI and player-controlled Unit Vehicles can spawn with spike strips.")
	UVUPursuitTech_Killswitch = CreateClientConVar("unitvehicle_unit_pursuittech_killswitch", 1, true, false, "Unit Vehicles: If set to 1, AI and player-controlled Unit Vehicles can spawn with killswitch.")
	UVUPursuitTech_RepairKit = CreateClientConVar("unitvehicle_unit_pursuittech_repairkit", 1, true, false, "Unit Vehicles: If set to 1, AI and player-controlled Unit Vehicles can spawn with repair kits.")
	
	UVUHelicopterModel = CreateClientConVar("unitvehicle_unit_helicoptermodel", 1, true, false, "\n1 = Most Wanted\n2 = Undercover\n3 = Hot Pursuit\n4 = No Limits\n5 = Payback")
	UVUHelicopterBarrels = CreateClientConVar("unitvehicle_unit_helicopterbarrels", 1, true, false, "1 = Barrels\n0 = No Barrels")
	UVUHelicopterSpikeStrips = CreateClientConVar("unitvehicle_unit_helicopterspikestrip", 1, true, false, "1 = Spike Strips\n0 = No Spike Strips")
	UVUHelicopterBusting = CreateClientConVar("unitvehicle_unit_helicopterbusting", 1, true, false, "1 = Helicopter can bust racers\n0 = Helicopter cannot bust racers")
	
	UVUBountyPatrol = CreateClientConVar("unitvehicle_unit_bountypatrol", 1000, true, false)
	UVUBountySupport = CreateClientConVar("unitvehicle_unit_bountysupport", 5000, true, false)
	UVUBountyPursuit = CreateClientConVar("unitvehicle_unit_bountypursuit", 10000, true, false)
	UVUBountyInterceptor = CreateClientConVar("unitvehicle_unit_bountyinterceptor", 20000, true, false)
	UVUBountyAir = CreateClientConVar("unitvehicle_unit_bountyair", 75000, true, false)
	UVUBountySpecial = CreateClientConVar("unitvehicle_unit_bountyspecial", 25000, true, false)
	UVUBountyCommander = CreateClientConVar("unitvehicle_unit_bountycommander", 100000, true, false)
	UVUBountyRhino = CreateClientConVar("unitvehicle_unit_bountyrhino", 50000, true, false)
	
	UVUBountyTime1 = CreateClientConVar("unitvehicle_unit_bountytime1", 1000, true, false)
	UVUBountyTime2 = CreateClientConVar("unitvehicle_unit_bountytime2", 5000, true, false)
	UVUBountyTime3 = CreateClientConVar("unitvehicle_unit_bountytime3", 10000, true, false)
	UVUBountyTime4 = CreateClientConVar("unitvehicle_unit_bountytime4", 50000, true, false)
	UVUBountyTime5 = CreateClientConVar("unitvehicle_unit_bountytime5", 100000, true, false)
	UVUBountyTime6 = CreateClientConVar("unitvehicle_unit_bountytime6", 500000, true, false)
	
	UVUTimeTillNextHeatEnabled = CreateClientConVar("unitvehicle_unit_timetillnextheatenabled", 0, true, false)
	UVUTimeTillNextHeat1 = CreateClientConVar("unitvehicle_unit_timetillnextheat1", 120, true, false)
	UVUTimeTillNextHeat2 = CreateClientConVar("unitvehicle_unit_timetillnextheat2", 120, true, false)
	UVUTimeTillNextHeat3 = CreateClientConVar("unitvehicle_unit_timetillnextheat3", 180, true, false)
	UVUTimeTillNextHeat4 = CreateClientConVar("unitvehicle_unit_timetillnextheat4", 180, true, false)
	UVUTimeTillNextHeat5 = CreateClientConVar("unitvehicle_unit_timetillnextheat5", 600, true, false)
	
	UVUUnitsPatrol1 = CreateClientConVar("unitvehicle_unit_unitspatrol1", "", true, false)
	UVUUnitsSupport1 = CreateClientConVar("unitvehicle_unit_unitssupport1", "", true, false)
	UVUUnitsPursuit1 = CreateClientConVar("unitvehicle_unit_unitspursuit1", "", true, false)
	UVUUnitsInterceptor1 = CreateClientConVar("unitvehicle_unit_unitsinterceptor1", "", true, false)
	UVUUnitsSpecial1 = CreateClientConVar("unitvehicle_unit_unitsspecial1", "", true, false)
	UVUUnitsCommander1 = CreateClientConVar("unitvehicle_unit_unitscommander1", "", true, false)
	UVURhinos1 = CreateClientConVar("unitvehicle_unit_rhinos1", "", true, false)
	UVUHeatMinimumBounty1 = CreateClientConVar("unitvehicle_unit_heatminimumbounty1", 1000, true, false)
	UVUMaxUnits1 = CreateClientConVar("unitvehicle_unit_maxunits1", 2, true, false)
	UVUUnitsAvailable1 = CreateClientConVar("unitvehicle_unit_unitsavailable1", 10, true, false)
	UVUBackupTimer1 = CreateClientConVar("unitvehicle_unit_backuptimer1", 180, true, false)
	UVUCooldownTimer1 = CreateClientConVar("unitvehicle_unit_cooldowntimer1", 20, true, false)
	UVURoadblocks1 = CreateClientConVar("unitvehicle_unit_roadblocks1", 0, true, false)
	UVUHelicopters1 = CreateClientConVar("unitvehicle_unit_helicopters1", 0, true, false)
	
	UVUUnitsPatrol2 = CreateClientConVar("unitvehicle_unit_unitspatrol2", "", true, false)
	UVUUnitsSupport2 = CreateClientConVar("unitvehicle_unit_unitssupport2", "", true, false)
	UVUUnitsPursuit2 = CreateClientConVar("unitvehicle_unit_unitspursuit2", "", true, false)
	UVUUnitsInterceptor2 = CreateClientConVar("unitvehicle_unit_unitsinterceptor2", "", true, false)
	UVUUnitsSpecial2 = CreateClientConVar("unitvehicle_unit_unitsspecial2", "", true, false)
	UVUUnitsCommander2 = CreateClientConVar("unitvehicle_unit_unitscommander2", "", true, false)
	UVURhinos2 = CreateClientConVar("unitvehicle_unit_rhinos2", "", true, false)
	UVUHeatMinimumBounty2 = CreateClientConVar("unitvehicle_unit_heatminimumbounty2", 10000, true, false)
	UVUMaxUnits2 = CreateClientConVar("unitvehicle_unit_maxunits2", 2, true, false)
	UVUUnitsAvailable2 = CreateClientConVar("unitvehicle_unit_unitsavailable2", 10, true, false)
	UVUBackupTimer2 = CreateClientConVar("unitvehicle_unit_backuptimer2", 180, true, false)
	UVUCooldownTimer2 = CreateClientConVar("unitvehicle_unit_cooldowntimer2", 20, true, false)
	UVURoadblocks2 = CreateClientConVar("unitvehicle_unit_roadblocks2", 0, true, false)
	UVUHelicopters2 = CreateClientConVar("unitvehicle_unit_helicopters2", 0, true, false)
	
	UVUUnitsPatrol3 = CreateClientConVar("unitvehicle_unit_unitspatrol3", "", true, false)
	UVUUnitsSupport3 = CreateClientConVar("unitvehicle_unit_unitssupport3", "", true, false)
	UVUUnitsPursuit3 = CreateClientConVar("unitvehicle_unit_unitspursuit3", "", true, false)
	UVUUnitsInterceptor3 = CreateClientConVar("unitvehicle_unit_unitsinterceptor3", "", true, false)
	UVUUnitsSpecial3 = CreateClientConVar("unitvehicle_unit_unitsspecial3", "", true, false)
	UVUUnitsCommander3 = CreateClientConVar("unitvehicle_unit_unitscommander3", "", true, false)
	UVURhinos3 = CreateClientConVar("unitvehicle_unit_rhinos3", "", true, false)
	UVUHeatMinimumBounty3 = CreateClientConVar("unitvehicle_unit_heatminimumbounty3", 100000, true, false)
	UVUMaxUnits3 = CreateClientConVar("unitvehicle_unit_maxunits3", 2, true, false)
	UVUUnitsAvailable3 = CreateClientConVar("unitvehicle_unit_unitsavailable3", 10, true, false)
	UVUBackupTimer3 = CreateClientConVar("unitvehicle_unit_backuptimer3", 180, true, false)
	UVUCooldownTimer3 = CreateClientConVar("unitvehicle_unit_cooldowntimer3", 20, true, false)
	UVURoadblocks3 = CreateClientConVar("unitvehicle_unit_roadblocks3", 0, true, false)
	UVUHelicopters3 = CreateClientConVar("unitvehicle_unit_helicopters3", 0, true, false)
	
	UVUUnitsPatrol4 = CreateClientConVar("unitvehicle_unit_unitspatrol4", "", true, false)
	UVUUnitsSupport4 = CreateClientConVar("unitvehicle_unit_unitssupport4", "", true, false)
	UVUUnitsPursuit4 = CreateClientConVar("unitvehicle_unit_unitspursuit4", "", true, false)
	UVUUnitsInterceptor4 = CreateClientConVar("unitvehicle_unit_unitsinterceptor4", "", true, false)
	UVUUnitsSpecial4 = CreateClientConVar("unitvehicle_unit_unitsspecial4", "", true, false)
	UVUUnitsCommander4 = CreateClientConVar("unitvehicle_unit_unitscommander4", "", true, false)
	UVURhinos4 = CreateClientConVar("unitvehicle_unit_rhinos4", "", true, false)
	UVUHeatMinimumBounty4 = CreateClientConVar("unitvehicle_unit_heatminimumbounty4", 500000, true, false)
	UVUMaxUnits4 = CreateClientConVar("unitvehicle_unit_maxunits4", 2, true, false)
	UVUUnitsAvailable4 = CreateClientConVar("unitvehicle_unit_unitsavailable4", 10, true, false)
	UVUBackupTimer4 = CreateClientConVar("unitvehicle_unit_backuptimer4", 180, true, false)
	UVUCooldownTimer4 = CreateClientConVar("unitvehicle_unit_cooldowntimer4", 20, true, false)
	UVURoadblocks4 = CreateClientConVar("unitvehicle_unit_roadblocks4", 0, true, false)
	UVUHelicopters4 = CreateClientConVar("unitvehicle_unit_helicopters4", 0, true, false)
	
	UVUUnitsPatrol5 = CreateClientConVar("unitvehicle_unit_unitspatrol5", "", true, false)
	UVUUnitsSupport5 = CreateClientConVar("unitvehicle_unit_unitssupport5", "", true, false)
	UVUUnitsPursuit5 = CreateClientConVar("unitvehicle_unit_unitspursuit5", "", true, false)
	UVUUnitsInterceptor5 = CreateClientConVar("unitvehicle_unit_unitsinterceptor5", "", true, false)
	UVUUnitsSpecial5 = CreateClientConVar("unitvehicle_unit_unitsspecial5", "", true, false)
	UVUUnitsCommander5 = CreateClientConVar("unitvehicle_unit_unitscommander5", "", true, false)
	UVURhinos5 = CreateClientConVar("unitvehicle_unit_rhinos5", "", true, false)
	UVUHeatMinimumBounty5 = CreateClientConVar("unitvehicle_unit_heatminimumbounty5", 1000000, true, false)
	UVUMaxUnits5 = CreateClientConVar("unitvehicle_unit_maxunits5", 2, true, false)
	UVUUnitsAvailable5 = CreateClientConVar("unitvehicle_unit_unitsavailable5", 10, true, false)
	UVUBackupTimer5 = CreateClientConVar("unitvehicle_unit_backuptimer5", 180, true, false)
	UVUCooldownTimer5 = CreateClientConVar("unitvehicle_unit_cooldowntimer5", 20, true, false)
	UVURoadblocks5 = CreateClientConVar("unitvehicle_unit_roadblocks5", 0, true, false)
	UVUHelicopters5 = CreateClientConVar("unitvehicle_unit_helicopters5", 0, true, false)
	
	UVUUnitsPatrol6 = CreateClientConVar("unitvehicle_unit_unitspatrol6", "", true, false)
	UVUUnitsSupport6 = CreateClientConVar("unitvehicle_unit_unitssupport6", "", true, false)
	UVUUnitsPursuit6 = CreateClientConVar("unitvehicle_unit_unitspursuit6", "", true, false)
	UVUUnitsInterceptor6 = CreateClientConVar("unitvehicle_unit_unitsinterceptor6", "", true, false)
	UVUUnitsSpecial6 = CreateClientConVar("unitvehicle_unit_unitsspecial6", "", true, false)
	UVUUnitsCommander6 = CreateClientConVar("unitvehicle_unit_unitscommander6", "", true, false)
	UVURhinos6 = CreateClientConVar("unitvehicle_unit_rhinos6", "", true, false)
	UVUHeatMinimumBounty6 = CreateClientConVar("unitvehicle_unit_heatminimumbounty6", 5000000, true, false)
	UVUMaxUnits6 = CreateClientConVar("unitvehicle_unit_maxunits6", 2, true, false)
	UVUUnitsAvailable6 = CreateClientConVar("unitvehicle_unit_unitsavailable6", 10, true, false)
	UVUBackupTimer6 = CreateClientConVar("unitvehicle_unit_backuptimer6", 180, true, false)
	UVUCooldownTimer6 = CreateClientConVar("unitvehicle_unit_cooldowntimer6", 20, true, false)
	UVURoadblocks6 = CreateClientConVar("unitvehicle_unit_roadblocks6", 0, true, false)
	UVUHelicopters6 = CreateClientConVar("unitvehicle_unit_helicopters6", 0, true, false)
	
	UVPTKeybindSlot1 = CreateClientConVar("unitvehicle_pursuittech_keybindslot_1", KEY_T, true, false)
	UVPTKeybindSlot2 = CreateClientConVar("unitvehicle_pursuittech_keybindslot_2", KEY_P, true, false)
	
	UVKeybindResetPosition = CreateClientConVar("unitvehicle_keybind_resetposition", KEY_M, true, false)
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
	
	UVHUDTypeRacing = CreateClientConVar("unitvehicle_hudtype_racing", "mostwanted", true, false, "Which HUD type to use when in a race.")
	UVHUDTypePursuit = CreateClientConVar("unitvehicle_hudtype_pursuit", "mostwanted", true, false, "Which HUD type to use when in a pursuit.")
	
	UVUnitsColor = Color(255,255,255)
	
	local local_convars = {
		["unitvehicle_heatlevels"] = 'integer',
		["unitvehicle_pursuittheme"] = 'string',
		["unitvehicle_targetvehicletype"] = 'integer',
		["unitvehicle_detectionrange"] = 'integer',
		//["unitvehicle_playmusic"] = 'integer',
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
		["unitvehicle_pursuitthemeplayrandomheat"] = 'integer',
		["unitvehicle_repaircooldown"] = 'integer',
		["unitvehicle_repairrange"] = 'integer',
		["unitvehicle_racertags"] = 'integer',
		["unitvehicle_racerpursuittech"] = 'integer',
		["unitvehicle_racerfriendlyfire"] = 'integer',
		['unitvehicle_spawncooldown'] = 'integer'
	}
	
	net.Receive('UVGetNewKeybind', function()
		--if IsSettingKeybind then return end
		local slot = net.ReadInt(16)
		local key = net.ReadInt(16)
		
		local entry = KeyBindButtons[slot]
		
		if entry then
			local convar = GetConVar( entry[1] )
			
			if convar then
				convar :SetInt( key )
				entry[2] :SetText( language.GetPhrase( Control_Strings [slot] ) .. " - " ..string.upper(input.GetKeyName(key)) )
			end
		else
			warn("Invalid slot key; if you run into this please report it to a developer!")
		end
		
		IsSettingKeybind = false
	end)
	
	net.Receive('UVGetSettings_Local', function()
		local array = net.ReadTable()
		
		for key, value in pairs(array) do
			local valid = string.match(key, 'unitvehicle_')
			if not valid then continue end
			RunConsoleCommand(key, value)
		end
	end)
	
	unitvehicles = true
	
	local UVHUDCopsDamaged = Material("hud/COPS_DAMAGED_ICON.png")
	local UVHUDCopsWrecked = Material("hud/COPS_TAKENOUT_ICON.png")
	local UVHUDMilestoneBounty = Material("hud/MILESTONE_PURSUITBOUNTY.png")
	local UVHUDMilestoneInfractions = Material("hud/MILESTONE_INFRACTIONS.png")
	local UVHUDMilestoneRoadblocks = Material("hud/MILESTONE_ROADBLOCKS.png")
	local UVHUDMilestoneSpikestrips = Material("hud/MILESTONE_SPIKESTRIPS.png")
	local UVHUDPursuitBreaker = Material("hud/WORLD_PURSUITBREAKER.png")
	local UVHUDBlipSound = "ui/pursuit/spotting_blip.wav"
	
	local UVClosestSuspect = nil
	
	if not KeyBindButtons then
		KeyBindButtons = {}
	end
	
	local UVHUDBlipSoundTime = CurTime()
	UVHUDScannerPos = Vector(0,0,0)
	
	function DrawIcon(material, x, y, height_ratio, color, args)
		local tex = material :GetTexture("$basetexture")
		
		if tex then
			local texW, texH = tex:Width(), tex:Height()
			local aspect = texW / texH
			
			local desiredHeight = ScrH() * height_ratio
			local desiredWidth = desiredHeight * aspect
			
			local x = x - desiredWidth / 2
			local y = y - desiredHeight / 2
			
			if color then
				surface.SetDrawColor(color:Unpack())
			else
				surface.SetDrawColor(255,255,255)
			end
			
			surface.SetMaterial(material, args)
			surface.DrawTexturedRect(x, y, desiredWidth, desiredHeight)
		end
	end
	
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
		KeyBindButtons[tonumber(slot)][2] :SetText('PRESS A KEY NOW!')
	end)
	
	concommand.Add("uv_local_update_settings", function( ply )
		if !ply:IsSuperAdmin() then
			notification.AddLegacy( "You need to be a super admin to apply settings on server!", NOTIFY_ERROR, 5 )
			return
		end
		
		local convar_table = {}
		
		for convar_name, convar_type in pairs(local_convars) do
			local convar = GetConVar(convar_name)
			local value = nil
			
			if convar_type == 'boolean' then
				value = convar:GetBool()
			elseif convar_type == 'integer' then
				value = convar:GetInt()
			elseif convar_type == 'string' then
				value = convar:GetString()
			end
			
			if not value then continue end
			
			--convar_name = string.gsub(convar_name, "_local", "")
			convar_table[convar_name] = value
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
		size = (math.Round(ScrH()*0.115)),
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
	
	net.Receive("UVHUDUnitsChasing", function()
		
		local chasing = net.ReadString()
		hook.Run( 'UIEventHook', 'pursuit', 'onChasingUnitsChange', chasing, UVUnitsChasing )

		UVUnitsChasing = chasing
		
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
		
		-- if tags ~= UVTags then
		-- 	hook.Remove("Think", "UVTagsColorPulse")
		-- 	if timer.Exists("UVTagsColorPulseDelay") then timer.Remove("UVTagsColorPulseDelay") end
			
		-- 	UVTagsColor = Color(255,255,0, 150)
			
		-- 	-- if timer.Exists("UVWrecksColor") then
		-- 	-- 	timer.Remove("UVWrecksColor")
		-- 	-- end
			
		-- 	timer.Create("UVTagsColorPulseDelay", 1, 1, function()
		-- 		hook.Add("Think", "UVTagsColorPulse", function()
		-- 			UVTagsColor.b = UVTagsColor.b + 600 * RealFrameTime()
		-- 			if UVTagsColor.b >= 255 then hook.Remove("Think", "UVTagsColorPulse") end
		-- 		end)
		-- 	end)
			
		-- 	-- timer.Create("UVWrecksColor", .3, 1, function()
		-- 	-- 	UVWrecksColor = Colors['White']
		-- 	-- end)
		-- 	-- else
		-- 	-- 	UVTagsColor = Colors['White']
		-- end

		if tags ~= UVTags then
			hook.Run( 'UIEventHook', 'pursuit', 'onUnitTag', wrecks, UVTags )
		end
		
		UVTags = tags

	end)
	
	net.Receive("UVHUDTimer", function()
		
		UVTimerStart = net.ReadString()
		
		if !UVTimerWhenFroze then
			UVTimerWhenFroze = 0
		end
		if !UVCooldownProgress then
			UVCooldownProgress = 0
		end
		
		if !UVHUDDisplayCooldown then
			if UVTimerFroze then
				UVTimerFroze = nil
			end
		else
			if !UVTimerFroze then
				UVTimerWhenFroze = CurTime()-UVCooldownProgress
				UVTimerFroze = true
			end
		end
		
		if !UVTimerFroze then
			UVCooldownProgress = UVCooldownProgress
			UVTimerProgress = (CurTime() - tonumber(UVTimerStart)-UVCooldownProgress)
		else
			UVTimerProgress = UVTimerProgress
			UVCooldownProgress = (CurTime() - UVTimerWhenFroze)
		end
		
		UVTimer = UVDisplayTime(UVTimerProgress)
		
	end)
	
	net.Receive("UVHUDTimeTillNextHeat", function()
		
		local timestring = net.ReadString()
		if !timestring then return end
		UVTimeTillNextHeat = tonumber(timestring)
		
	end)
	
	net.Receive("UVHUDStopPursuit", function()
		
		net.Start("UVHUDTimeStopped")
		net.WriteString(UVTimerProgress)
		net.SendToServer()
		UVHUDDisplayPursuit = nil
		UVTimerWhenFroze = 0
		UVCooldownProgress = 0
		UVHUDRaceInProgress = nil
		
		UVSoundEscaped()
		
	end)
	net.Receive("UVHUDUpdateBusting", function()
		local ent = net.ReadEntity()
		local progress = net.ReadFloat()
		
		ent.uvbustingprogress = progress
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
		-- if UVHUDDisplayPursuit then
		-- 	if UVBustingTimeLeft >= 3 then
		-- 		-- UVNotification = lang("uv.chase.busting")
		-- 	elseif UVBustingTimeLeft >= 2 then
		-- 		UVBustedColor = Color( 255, blink, blink)
		-- 		-- UVNotification = "! " .. lang("uv.chase.busting") .. " !"
		-- 		UVSoundBusting()
		-- 	elseif UVBustingTimeLeft >= 1 then
		-- 		UVBustedColor = Color( 255, blink2, blink2)
		-- 		-- UVNotification = "!! " .. lang("uv.chase.busting") .. " !!"
		-- 		UVSoundBusting()
		-- 	elseif UVBustingTimeLeft >= 0 then
		-- 		UVBustedColor = Color( 255, blink3, blink3)
		-- 		-- UVNotification = "!!! " .. lang("uv.chase.busting") .. " !!!"
		-- 		UVSoundBusting()
		-- 	else
		-- 		UVBustedColor = Color( 255, 0, 0)
		-- 		-- UVBustedColor = Color( 255, 255, 255, 50)
		-- 		UVNotification = "/// " .. lang("uv.chase.busted") .. " ///"
		-- 	end
		-- end
		-- if not UVHUDDisplayNotification then
		-- 	UVHUDDisplayNotification = true
		-- end
		if UVBustingTimeLeft <= 0 then
			UVNotification = true
		end
		
	end)
	
	net.Receive("UVHUDStopBusting", function()
		
		UVHUDDisplayBusting = nil
		UVHUDDisplayNotification = nil
		
	end)
	
	net.Receive("UVHUDStopBustingTimeLeft", function()
		
		if not UVHUDDisplayNotification and !uvenemybusted and UVBustingTimeLeft < 1 and UVBustingTimeLeft >= 0 then
			UVNotificationColor = Color( 0, 255, 0)
			UVNotification = string.format(language.GetPhrase("uv.chase.evadedtime"), UVBustingTimeLeft)
			UVHUDDisplayNotification = true
			timer.Simple(2, function()
				if !UVHUDDisplayBusting then
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
		if !UVHUDDisplayNotification then
			if UVHUDRaceInProgress then
				if #UVHUDWantedSuspects <= 1 then
					bustedtext = language.GetPhrase("uv.race.shutdown")
				end
			end
			UVNotification = "/// " .. bustedtext .. " ///"
			UVHUDDisplayNotification = true
			timer.Simple(5.1, function()
				UVHUDDisplayNotification = nil
			end)
		end
		
		if UVHUDDisplayPursuit then
			UVSoundBusted()
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
	
	net.Receive("UVHUDWantedSuspects", function()
		
		UVHUDWantedSuspects = net.ReadTable() or {}
		UVHUDWantedSuspectsNumber = #UVHUDWantedSuspects
		
		if UVHUDWantedSuspectsNumber > 1 then
			if !UVHUDRaceInProgress then
				UVHUDRaceInProgress = true
			end
		end
		
	end)
	
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
			if UVHUDCommander.MaxChassisHealth != UVUOneCommanderHealth:GetInt() then
				UVHUDCommander.MaxChassisHealth = UVUOneCommanderHealth:GetInt()
			end
		end
		if !UVOneCommanderActive and IsValid(UVHUDCommander) then
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
		UVStopSound()
		timer.Simple(0.1, function()
			UVHeatLevelIncrease = nil
		end)
	end)
	
	net.Receive("UVHUDPursuitBreakers", function()
		UVHUDPursuitBreakers = net.ReadTable() or {}
	end)
	
	net.Receive("UVHUDPursuitTech", function()
		local PursuitTable = net.ReadTable()
		UVHUDPursuitTech = PursuitTable
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
	
	net.Receive("UVHUDStopScanner", function()
		UVHUDScanner = nil
		UVHUDScannerPos = Vector(0,0,0)
	end)
	
	net.Receive("UVHUDAddUV", function()
		local unitindex = net.ReadInt(32)
		local typestring = net.ReadString()
		local unit = Entity(unitindex)
		
		if !GMinimap then return end
		
		if !IsValid(unit) then
			net.Start("UVHUDReAddUV")
			net.WriteInt(unitindex, 32)
			net.WriteString(typestring)
			net.SendToServer()
			return
		end
		
		if typestring == "unit" then
			local blip, id = GMinimap:AddBlip( {
				id = "UVBlip"..unit:EntIndex(),
				parent = unit,
				icon = "hud/MINIMAP_ICON_CAR.png",
				scale = 1.4,
				color = Color( 150, 0, 0),
				alpha = 0
			} )
			if unit:GetClass() == "prop_vehicle_jeep" then
				blip.icon = "hud/MINIMAP_ICON_CAR_JEEP.png" -- Icon points the other way
			end
			local created = false
			local flashwhite = false
			timer.Simple(0.1, function()
				blip.alpha = 255
				timer.Create( "flashingblip"..id, 0.05, 0, function()
					if flashwhite and UVHUDDisplayPursuit or blip.disabled then
						blip.color = Color( 255, 255, 255)
						flashwhite = false
					elseif created and UVHUDDisplayPursuit and !blip.disabled then
						blip.color = Color( 0, 0, 255)
						created = false
						flashwhite = true
					else
						blip.color = Color( 150, 0, 0)
						created = true
						if UVHUDDisplayPursuit then
							flashwhite = true
						end
					end
					if !IsValid(blip.parent) then
						timer.Remove("flashingblip"..id)
					end
				end )
			end)
		elseif typestring == "air" then
			local blip, id = GMinimap:AddBlip( {
				id = "UVBlip"..unit:EntIndex(),
				parent = unit,
				icon = "hud/HELICOPTER_MINIMAP_ICON.png",
				scale = 2,
				color = Color( 150, 0, 0),
				alpha = 0
			} )
			local created = false
			local flashwhite = false
			blip.alpha = 255
			timer.Simple(0.1, function()
				blip.alpha = 255
				timer.Create( "flashingblip"..id, 0.05, 0, function()
					if flashwhite and UVHUDDisplayPursuit then
						blip.color = Color( 255, 255, 255)
						flashwhite = false
					elseif created and UVHUDDisplayPursuit then
						blip.color = Color( 0, 0, 255)
						created = false
						flashwhite = true
					else
						blip.color = Color( 150, 0, 0)
						created = true
						if UVHUDDisplayPursuit then
							flashwhite = true
						end
					end
					if !IsValid(blip.parent) then
						timer.Remove("flashingblip"..id)
					end
				end )
			end)
		elseif typestring == "roadblock" then
			local blip, id = GMinimap:AddBlip( {
				id = "UVBlip"..unit:EntIndex(),
				parent = unit,
				icon = "hud/MINIMAP_ICON_ROADBLOCK.png",
				scale = 1.4,
				color = Color( 255, 255, 0),
				alpha = 0
			} )
			timer.Simple(0.1, function()
				blip.alpha = 255
			end)
		elseif typestring == "repairshop" then
			local blip, id = GMinimap:AddBlip( {
				id = "UVBlip"..unit:EntIndex(),
				parent = unit,
				icon = "hud/repairshop.png",
				scale = 2,
				color = Color( 0, 255, 0),
				alpha = 0,
				lockIconAng = true
			} )
			timer.Simple(0.1, function()
				blip.alpha = 255
			end)
		end
		
	end)
	
	net.Receive("UVHUDRemoveUV", function()
		local id = net.ReadInt(32)
		if GMinimap then
			local blip = GMinimap:FindBlipByID("UVBlip"..id)
			if !blip then return end
			blip.color = Color( 255, 255, 255)
			local key = "disabled"
			blip[key] = true
		end
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
		return !UVHUDDisplayPursuit
	end )
	
	outofpursuit = 0
	
	hook.Add( "HUDPaint", "UVHUD", function() --HUD
		
		local vehicle = LocalPlayer():GetVehicle()
		
		local w = ScrW()
		local h = ScrH()
		local hudyes = showhud:GetBool()
		local hudtype = UVHUDTypePursuit:GetString()
		local lang = language.GetPhrase
		
		-- local UnitsChasing = tonumber(UVUnitsChasing)
		-- local UVBustTimer = BustedTimer:GetFloat()
		
		-- TEST VARS, REMOVE AFTER FINISHING
		-- hudyes = true 
		-- UVHUDDisplayPursuit = true
		-- UVHUDCopMode = false
		-- UVHUDDisplayCooldown = true
		-- UVHUDDisplayNotification = false
		-- UVHUDDisplayBusting = false
		-- UVHUDDisplayEvading = false
		-- UVHUDDisplayHidingPrompt = true
		-- UVWrecks = 1
		-- UVTags = 1
		-- UVTimer = CurTime()
		-- UVBounty = 0
		-- UVHeatLevel = 5
		-- UVBountyNo = 589328
		-- UVCooldownTimer = .5
		-- ResourceText = 30
		-- UVUnitsChasing = 2
		-- UnitsChasing = 1v
		
		if UV_UI.pursuit[hudtype] then
			UV_UI.pursuit[hudtype].main()
		end

		if UVHUDDisplayPursuit and vehicle ~= NULL then
			if not UVHUDDisplayBusting and not UVHUDDisplayCooldown and not UVHUDDisplayNotification then
				UVSoundHeat( UVHeatLevel )
			end

			if UVOneCommanderActive and hudyes then
				if IsValid(UVHUDCommander) then
					UVRenderCommander(UVHUDCommander)
				end
			end
		end
		
		if (not UVHUDDisplayPursuit) and ((not UVHUDDisplayRacing) or (not UVHUDRace)) then
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
		
		local var = UVKeybindSkipSong:GetInt()
		
		if input.IsKeyDown(var) and !gui.IsGameUIVisible() and vgui.GetKeyboardFocus() == nil then
			LocalPlayer():ConCommand('uv_skipsong')
		end
		
		-- if UVHUDDisplayBusting and !UVHUDDisplayCooldown and hudyes then
		-- if !BustingProgress or BustingProgress == 0 then
		-- BustingProgress = CurTime()
		-- end
		-- surface.SetDrawColor( 0, 0, 0, 200)
		-- surface.DrawRect( w/3,h/1.1,w/3+12, 40 )
		-- surface.SetDrawColor(Color(255,0,0))
		-- surface.DrawRect(w/3,h/1.1,12,40)
		-- surface.DrawRect(w*2/3,h/1.1,12,40)
		-- surface.DrawRect(w/3+12,h/1.1,w/3-12,12)
		-- surface.DrawRect(w/3+12,h/1.1+28,w/3-12,12)
		-- surface.SetDrawColor(Color(255,0,0))
		-- local T = math.Clamp((UVBustingProgress/UVBustTimer)*(w/3-20),0,w/3-20)
		-- surface.DrawRect(w/3+16,h/1.1+16,T,8)
		-- else
		-- BustingProgress = 0
		-- end
		
		-- if UVHUDDisplayCooldown and hudyes then
		-- if !CooldownProgress or CooldownProgress == 0 then
		-- CooldownProgress = CurTime()
		-- end
		-- UVSoundCooldown()
		-- if !UVHUDCopMode then
		-- surface.SetDrawColor( 0, 0, 0, 200)
		-- surface.DrawRect( w/3,h/1.1,w/3+12, 40 )
		-- surface.SetDrawColor(Color(0,0,255))
		-- surface.DrawRect(w/3,h/1.1,12,40)
		-- surface.DrawRect(w*2/3,h/1.1,12,40)
		-- surface.DrawRect(w/3+12,h/1.1,w/3-12,12)
		-- surface.DrawRect(w/3+12,h/1.1+28,w/3-12,12)
		-- surface.SetDrawColor(Color(0,0,255))
		-- local T = math.Clamp((UVCooldownTimer)*(w/3-20),0,w/3-20)
		-- surface.DrawRect(w/3+16,h/1.1+16,T,8)
		-- end
		-- EvadingProgress = 0
		-- else
		-- CooldownProgress = 0
		-- end
		
		local localPlayer = LocalPlayer()
		local entities = ents.GetAll()
		local box_color = Color(0, 255, 0)
		
		if UVHUDWantedSuspects and !uvclientjammed and RacerTags:GetBool() then
			if next(UVHUDWantedSuspects) != nil then
				for _, ent in pairs(UVHUDWantedSuspects) do
					UVRenderEnemySquare(ent)
					if !GMinimap then continue end
					if IsValid(ent) and !ent.displayedonhud then
						ent.displayedonhud = true
						local blip, id = GMinimap:AddBlip( {
							id = "UVBlip"..ent:EntIndex(),
							parent = ent,
							icon = "hud/MINIMAP_ICON_CAR.png",
							scale = 1.4,
							color = Color( 255, 191, 0),
						} )
						if ent:GetClass() == "prop_vehicle_jeep" then
							blip.icon = "hud/MINIMAP_ICON_CAR_JEEP.png" -- Icon points the other way
						end
					end
					if ent.displayedonhud then
						local curblip = GMinimap:FindBlipByID("UVBlip"..ent:EntIndex())
						if !curblip then continue end
						if UVHUDDisplayCooldown or (UVHUDCopMode and (tonumber(UVUnitsChasing) <= 0 or not ent.inunitview) and not ((not GetConVar("unitvehicle_unit_onecommanderevading"):GetBool()) and UVOneCommanderActive)) then
							curblip.alpha = 0
						else
							curblip.alpha = 255
						end
					end
				end
			end
		end
		
		if UVHUDRoadblocks then
			if next(UVHUDRoadblocks) != nil then
				for _, roadblock in pairs(UVHUDRoadblocks) do
					if roadblock.location and roadblock.name then
						UVRenderRoadblock(roadblock.location, roadblock.name)
					end
				end
			end
		end
		
		if UVHUDPursuitBreakers then
			if next(UVHUDPursuitBreakers) != nil then
				for _, pos in pairs(UVHUDPursuitBreakers) do
					UVRenderPursuitBreaker(pos)
				end
			end
		end
		
		
		--Police Scanner
		if (!UVHUDDisplayPursuit or UVHUDDisplayCooldown) and UVHUDScanner and !UVHUDCopMode and !uvclientjammed and localPlayer:InVehicle() then
			local enemypos = localPlayer:GetPos()
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
		elseif UVHUDDisplayCooldown and !UVHUDCopMode then
			surface.SetDrawColor( 0, 0, 0, 200)
			drawCircle( w/2, h/10, 30, 50 )
			drawCircle( w/2, h/10, 14, 50 )
		end
		--Pursuit Tech
		-- if !localPlayer:InVehicle() then
		-- 	UVHUDPursuitTech = nil
		-- end
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
			if !uvclientjammed then
				for i=1, 2, 1 do
					if UVHUDPursuitTech[i] then
						local var = GetConVar('unitvehicle_pursuittech_keybindslot_'..i):GetInt()
						
						if input.IsKeyDown(var) and !gui.IsGameUIVisible() and vgui.GetKeyboardFocus() == nil then
							net.Start("UVPTUse")
							net.WriteInt(i, 16)
							net.SendToServer()
						end
						
						if UVHUDPursuitTech[i].Ammo > 0 and CurTime() - UVHUDPursuitTech[i].LastUsed <= UVHUDPursuitTech[i].Cooldown then
							local sanitized_cooldown = math.Round((UVHUDPursuitTech[i].Cooldown - (CurTime() - UVHUDPursuitTech[i].LastUsed)), 1)
							draw.DrawText( (PT_Replacement_Strings[UVHUDPursuitTech[i].Tech] or UVHUDPursuitTech[i].Tech).."\n"..UVHUDPursuitTech[i].Ammo.." ("..sanitized_cooldown.."s)", "UVFont4",w/(1.05+((i -1)*.06)), h/1.7, Color( 255, 255, 0), TEXT_ALIGN_CENTER )
						else
							draw.DrawText( (PT_Replacement_Strings[UVHUDPursuitTech[i].Tech] or UVHUDPursuitTech[i].Tech).."\n"..UVHUDPursuitTech[i].Ammo, "UVFont4",w/(1.05+((i -1)*.06)), h/1.7, (UVHUDPursuitTech[i].Ammo > 0 and Color( 255, 255, 255)) or Color(255,0,0), TEXT_ALIGN_CENTER )
						end
					else
						draw.DrawText( "-", "UVFont4",w/(1.05+((i -1)*.06)), h/1.7, Color( 255, 255, 255, 166), TEXT_ALIGN_CENTER )
					end
				end
			else
				draw.DrawText( lang("uv.pt.jammed"), "UVFont4",w/1.05, h/1.7, Color( 255, 0, 0), TEXT_ALIGN_CENTER )
			end
		end
		
	end)
	
	function UVMarkAllLocations()
		if !UVHUDRoadblocks then
			UVHUDRoadblocks = {}
		else
			if next(UVHUDRoadblocks) != nil then
				return
			end
		end
		
		local saved_roadblocks = file.Find("unitvehicles/roadblocks/"..game.GetMap().."/*.json", "DATA")
		for k,jsonfile in pairs(saved_roadblocks) do
			local JSONData = file.Read( "unitvehicles/roadblocks/"..game.GetMap().."/"..jsonfile, "DATA" )
			if !JSONData then return end
			
			local rbdata = util.JSONToTable(JSONData, true) --Load Roadblock
			
			local name = jsonfile
			local location = rbdata.Location or rbdata.Maxs
			if !location then return end
			
			local tabletoinsert = {}
			tabletoinsert.location = location
			tabletoinsert.name = name
			
			table.insert(UVHUDRoadblocks, tabletoinsert)
			
			timer.Simple(10, function()
				if !UVHUDRoadblocks then return end
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
	
	function UVRenderCommander(ent)
		local localPlayer = LocalPlayer()
		local box_color = Color(0, 161, 255)
		local lang = language.GetPhrase
		
		if IsValid(ent) then
			if !UVHUDDisplayPursuit then return end
			
			local callsign = lang("uv.unit.commander") .. "\n⛊"
			local driver = UVGetDriver(ent)
			
			if driver and driver:IsPlayer() then
				callsign = driver:GetName() .. "\n⛊"
				if localPlayer == driver then
					if not ent.lplayernotified then
						ent.lplayernotified = true
						if Glide then
							Glide.Notify( {
								text = "<color=61, 183, 255>" .. language.GetPhrase("uv.unit.commander.notification"),
								icon = "hud/MINIMAP_ICON_EVENT_RIVAL.png",
								lifetime = 5
							} )
						else
							chat.AddText(
							Color(0, 81, 161), "[Unit Vehicles] ",
							Color(61, 183, 255),
							language.GetPhrase("uv.unit.commander.notification"))
						end
					end
					return
				end
			end
			
			local pos = ent:GetPos()
			
			local mins, maxs = ent:GetCollisionBounds()
			local points = {
				Vector(maxs.x, maxs.y, maxs.z),
				Vector(maxs.x, maxs.y, mins.z),
				Vector(maxs.x, mins.y, mins.z),
				Vector(maxs.x, mins.y, maxs.z),
				Vector(mins.x, mins.y, mins.z),
				Vector(mins.x, mins.y, maxs.z),
				Vector(mins.x, maxs.y, mins.z),
				Vector(mins.x, maxs.y, maxs.z)
			}
			
			local MaxX, MinX, MaxY, MinY
			local isVisible = false
			
			for i = 1, #points do
				local v = points[i]
				local p = pos + v
				local screenPos = p:ToScreen()
				isVisible = screenPos.visible
				
				if MaxX ~= nil then
					MaxX, MaxY = math.max(MaxX, screenPos.x), math.max(MaxY, screenPos.y)
					MinX, MinY = math.min(MinX, screenPos.x), math.min(MinY, screenPos.y)
				else
					MaxX, MaxY = screenPos.x, screenPos.y
					MinX, MinY = screenPos.x, screenPos.y
				end
			end
			
			local textX = (MinX + MaxX) / 2
			local textY = MinY - 20
			cam.Start2D()
			draw.DrawText(callsign, "UVFont4", textX, textY - 30, box_color, TEXT_ALIGN_CENTER)
			cam.End2D()
		end
	end
	
	function UVRenderEnemySquare(ent)
		local localPlayer = LocalPlayer()
		local box_color = (!UVHUDCopMode and Color(60, 255, 0)) or Color( 255, 0, 0)
		local blink = 255 * math.abs(math.sin(RealTime() * 4))
		local blink2 = 255 * math.abs(math.sin(RealTime() * 6))
		local blink3 = 255 * math.abs(math.sin(RealTime() * 8))
		
		local lang = language.GetPhrase
		
		local entbustedtimeleft = math.Round((BustedTimer:GetFloat()-(ent.uvbustingprogress or 0)),3)
		
		if ent.beingbusted then
			if entbustedtimeleft >= 2 then
				box_color = Color( 255, blink, blink)
			elseif entbustedtimeleft >= 1 then
				box_color = Color( 255, blink2, blink2)
			elseif entbustedtimeleft >= 0 then
				box_color = Color( 255, blink3, blink3)
			end
		end
		
		if IsValid(ent) then
			if !UVHUDDisplayPursuit then return end
			-- if UVHUDCopMode and (UVHUDDisplayCooldown or tonumber(UVUnitsChasing) <= 0 or !ent.inunitview) and not UVOneCommanderActive then return end
			if UVHUDDisplayCooldown or (UVHUDCopMode and (tonumber(UVUnitsChasing) <= 0 or not ent.inunitview) and not ((not GetConVar("unitvehicle_unit_onecommanderevading"):GetBool()) and UVOneCommanderActive)) then return end
			
			local enemycallsign = ent.racer or "Racer "..ent:EntIndex()
			local enemydriver = ent:GetDriver()
			if enemydriver:IsPlayer() then
				enemycallsign = enemydriver:GetName()
				if localPlayer == enemydriver then
					return
				end
			end
			
			local pos = ent:GetPos()
			
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
			
			local dist = localPlayer:GetPos():Distance(ent:GetPos())
			local distInMeters = dist * 0.01905
			
			local textX = (MinX + MaxX) / 2
			local textY = MinY - 20
			cam.Start2D()
			local bustpro = math.Clamp(math.floor((((ent.uvbustingprogress or 0) / BustedTimer:GetInt()) * 100) + .5), 0, 100)
			local bustdist = math.Round(distInMeters) .. " m"
			draw.DrawText((ent.beingbusted and string.format(lang("uv.chase.busting.other"), bustpro) or "") .. "\n" .. enemycallsign .. "\n" .. bustdist, "UVFont4", textX, textY - 30, box_color, TEXT_ALIGN_CENTER)
			cam.End2D()
		end
	end
	
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
		
		local w = ScrW()
		local h = ScrH()
		
		local time = UVDisplayTime(UVTimerProgress)
		local bustedtable = net.ReadTable()
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
		
		local timetotal = 10
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
		
		timer.Simple(5, function()
			UVHUDDisplayBusting = false
			UVHUDDisplayNotification = false
		end)
		
	end)
	
	net.Receive("UVHUDEscapedDebrief", function()
		
		if UVHUDRace then return end
		
		local w = ScrW()
		local h = ScrH()
		
		local time = UVDisplayTime(UVTimerProgress)
		local escapedtable = net.ReadTable()
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
		
		local timetotal = 10
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
	end)
	
	net.Receive("UVHUDCopModeEscapedDebrief", function()
		
		local w = ScrW()
		local h = ScrH()
		
		local time = UVDisplayTime(UVTimerProgress)
		local escapedtable = net.ReadTable()
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
		
		local timetotal = 10
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
	end)
	
	net.Receive("UVHUDCopModeBustedDebrief", function()
		
		local w = ScrW()
		local h = ScrH()
		
		local time = UVDisplayTime(UVTimerProgress)
		local bustedtable = net.ReadTable()
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
		
		local timetotal = 10
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
		
		if can_skip and IsValid(uvsoundplaying) and parameters != 2 then
			uvsoundplaying:Stop()
		end
		
		sound.PlayFile(audio_file, "", function(source, err, errname)
			if IsValid(source) then
				if !can_skip then
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
		
		if can_skip and IsValid(uvchatterplaying) and parameters != 2 then
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
		local col = {
			w = Color(255,255,255),
			r = Color(255,54,54),
			b = Color(53,134,255),
			uv = Color(0,81,161),
		}
		
		chat.AddText(Color(0, 81, 161), "[Unit Vehicles] ", Color(255, 54, 54), racer, Color(255, 255, 255), language.GetPhrase("uv.hud.racer.arrested"), Color(53, 134, 255), cop, Color(255, 255, 255), '!')
	end)
	
	net.Receive("UVHUDWreckedDebrief", function()
		
		local w = ScrW()
		local h = ScrH()
		
		local ResultPanel = vgui.Create("DFrame")
		local Yes = vgui.Create("DButton")
		local No = vgui.Create("DButton")
		
		ResultPanel:Add(Yes)
		ResultPanel:Add(No)
		ResultPanel:SetSize(math.Round(w*0.5208333333), math.Round(h*0.2777777778))
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
			draw.RoundedBox(2, 0, 0, w, h, Color( 0, 0, 0, 225 ) )
			draw.SimpleText("/// " .. language.GetPhrase("uv.chase.wrecked") .. " ///", "UVFont", w*0.5, h*0.01, Color(255, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText("#uv.chase.wrecked.takenout", "UVFont5", w*0.5, h*0.15, Color(255, 255, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText("#uv.chase.wrecked.rejoin", "UVFont5", w*0.5, h*0.35, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText("#uv.chase.wrecked.respawn", "UVFont5", w*0.5, h*0.55, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		end
		
		function Yes:DoClick()
			ResultPanel:Close()
			local redeploysound = {
				"ui/redeploy/redeploy1.wav",
				"ui/redeploy/redeploy2.wav",
				"ui/redeploy/redeploy3.wav",
				"ui/redeploy/redeploy4.wav",
			}
			surface.PlaySound( redeploysound[math.random(1, #redeploysound)] )
			net.Start("UVHUDRespawnInUV")
			net.SendToServer()
		end
		function No:DoClick()
			ResultPanel:Close()
		end
		
	end)
	
	hook.Add("PopulateToolMenu", "UVMenu", function()
		spawnmenu.AddToolMenuOption("Options", "Unit Vehicles", "UVOptions", "Settings", "", "", function(panel)
			panel:Clear()
			
			panel:Button("#spawnmenu.savechanges", "uv_local_update_settings")
			panel:Help("#uv.settings.uistyle.title")
			local uistyleracing, label = panel:ComboBox( "#uv.settings.uistyle.racing", "unitvehicle_hudtype_racing" )
			uistyleracing:AddChoice( "Most Wanted", "mostwanted")
			uistyleracing:AddChoice( "Carbon", "carbon")
			uistyleracing:AddChoice( "Underground", "underground")
			uistyleracing:AddChoice( "Underground 2", "underground2")
			uistyleracing:AddChoice( "Undercover", "undercover")
			uistyleracing:AddChoice( "Pro Street", "prostreet")
			uistyleracing:AddChoice( "#uv.uistyle.original", "original")
			uistyleracing:AddChoice( "#uv.uistyle.none", "")
			
			panel:ControlHelp("#uv.settings.uistyle.racing.desc")
			
			panel:Help("#uv.settings.heatlevels")
			panel:CheckBox("#uv.settings.heatlevels.enable", "unitvehicle_heatlevels")
			panel:ControlHelp("#uv.settings.heatlevels.enable.desc")
			panel:CheckBox("#uv.settings.heatlevels.aiunits", "unitvehicle_spawnmainunits")
			panel:ControlHelp("#uv.settings.heatlevels.aiunits.desc")
			panel:NumSlider("#uv.settings.heatlevels.min", "unitvehicle_minheatlevel", 1, 6, 0)
			panel:ControlHelp("#uv.settings.heatlevels.min.desc")
			panel:NumSlider("#uv.settings.heatlevels.max", "unitvehicle_maxheatlevel", 1, 6, 0)
			panel:ControlHelp("#uv.settings.heatlevels.max.desc")
			
			panel:Help("#uv.settings.targetvehicle")
			panel:NumSlider("#uv.settings.targetvehicle.target", "unitvehicle_targetvehicletype", 1, 3, 0)
			panel:ControlHelp("#uv.settings.targetvehicle.target.desc")
			
			panel:Help("#uv.settings.music")
			panel:Help("#uv.settings.ptech.keybinds")
			
			KeyBindButtons[3] = {
				UVKeybindSkipSong:GetName(),
				panel:Button(language.GetPhrase(Control_Strings[3]) .. " - "..string.upper(input.GetKeyName(UVKeybindSkipSong:GetInt())), "uv_keybinds", '3')
			}
			
			panel:CheckBox("#uv.settings.music.pursuit", "unitvehicle_playmusic")
			panel:ControlHelp("#uv.settings.music.pursuit.desc")
			panel:CheckBox("#uv.settings.music.race", "unitvehicle_racingmusic")
			panel:ControlHelp("#uv.settings.music.race.desc")
			panel:CheckBox("#uv.settings.music.race.priority", "unitvehicle_racingmusicpriority")
			panel:ControlHelp("#uv.settings.music.race.priority.desc")
			panel:CheckBox("#uv.settings.music.race.racingpriority", "unitvehicle_racingmusicoutsideraces")
			panel:ControlHelp("#uv.settings.music.race.racingpriority.desc")
			local pursuittheme, label = panel:ComboBox( "#uv.settings.music.pursuittheme", "unitvehicle_pursuittheme" )
			local files, folders = file.Find( "sound/uvpursuitmusic/*", "GAME" )
			if folders != nil then
				for k, v in pairs(folders) do
					pursuittheme:AddChoice( v )
				end
			end
			panel:CheckBox("#uv.settings.music.pursuittheme.random", "unitvehicle_pursuitthemeplayrandomheat")
			panel:ControlHelp("#uv.settings.music.pursuittheme.random.desc")
			local volume_theme = panel:NumSlider("#uv.settings.music.volume", "unitvehicle_pursuitthemevolume", 0, 2, 1)
			panel:ControlHelp("#uv.settings.music.volume.desc")
			
			volume_theme.OnValueChanged = function( self, value )
				-- if value == 0 then
				-- volume_theme:SetText("Volume: MUTE")
				-- elseif value == 2 then
				-- volume_theme:SetText("Volume: MAX")
				-- else
				-- volume_theme:SetText("Volume: "..math.floor(math.Round(value*100) + .5).."%")
				-- end
				
				if UVSoundLoop then
					UVSoundLoop:SetVolume( value )
				end
			end
			
			panel:Help("#uv.settings.race")
			panel:Help("#uv.settings.race.keybinds")
			
			KeyBindButtons[4] = {
				UVKeybindResetPosition:GetName(),
				panel:Button(language.GetPhrase(Control_Strings[4]) .. " - "..string.upper(input.GetKeyName(UVKeybindResetPosition:GetInt())), "uv_keybinds", '4')
			}
			
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
			panel:CheckBox("#uv.settings.pursuit.racertags", "unitvehicle_racertags")
			panel:ControlHelp("#uv.settings.pursuit.racertags.desc")
			
			panel:Help("#uv.settings.ptech")
			panel:ControlHelp("#uv.settings.ptech.desc")
			
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
		spawnmenu.AddToolMenuOption("Options", "Unit Vehicles", "UVPursuitManager", "#uv.settings.pm", "", "", function(panel)
			
			panel:SetContentAlignment(8)
			panel:AddControl("Header", {Description = "	——— Units ———"})
			panel:Button( "#uv.settings.pm.ai.spawn", "uv_spawnvehicles")
			panel:Button( "#uv.settings.pm.ai.despawn", "uv_despawnvehicles")
			panel:Button( "#uv.settings.pm.ai.spawnas", "uv_spawn_as_unit")
			
			panel:AddControl("Header", {Description = "——— Pursuit ———"})
			panel:Button( "#uv.settings.pm.pursuit.start", "uv_startpursuit")
			panel:Button( "#uv.settings.pm.pursuit.stop", "uv_stoppursuit")
			
			panel:AddControl("Header", {Description = "——— Racers ———"})
			panel:Button( "#uv.settings.hor.start", "uv_racershordestart")
			panel:Button( "#uv.settings.hor.stop", "uv_racershordestop")
			
			panel:AddControl("Header", {Description = "——— Misc ———"})
			panel:Button( "#uv.settings.clearbounty", "uv_clearbounty")
			panel:Button( "#uv.settings.print.wantedtable", "uv_wantedtable")
			
		end)
	end)
end