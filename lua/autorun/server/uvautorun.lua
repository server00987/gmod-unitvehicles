resource.AddSingleFile("resource/fonts/VCR_OSD_MONO_1.001.ttf")

--convars
local HeatLevels = GetConVar("unitvehicle_heatlevels")
local TargetVehicleType = GetConVar("unitvehicle_targetvehicletype")
local DetectionRange = GetConVar("unitvehicle_detectionrange")
local PlayMusic = GetConVar("unitvehicle_playmusic")
local NeverEvade = GetConVar("unitvehicle_neverevade")
local BustedTimer = GetConVar("unitvehicle_bustedtimer")
local CanWreck = GetConVar("unitvehicle_canwreck")
local Chatter = GetConVar("unitvehicle_chatter")
local SpeedLimit = GetConVar("unitvehicle_speedlimit")
local AutoHealth = GetConVar("unitvehicle_autohealth")
local MinHeatLevel = GetConVar("unitvehicle_minheatlevel")
local MaxHeatLevel = GetConVar("unitvehicle_maxheatlevel")
local SpikeStripDuration = GetConVar("unitvehicle_spikestripduration")
local Pathfinding = GetConVar("unitvehicle_pathfinding")
local VCModELSPriority = GetConVar("unitvehicle_vcmodelspriority")
local CallResponse = GetConVar("unitvehicle_callresponse")
local ChatterText = GetConVar("unitvehicle_chattertext")
local Headlights = GetConVar("unitvehicle_enableheadlights")
local Relentless = GetConVar("unitvehicle_relentless")
local SpawnMainUnits = GetConVar("unitvehicle_spawnmainunits")
local RepairCooldown = GetConVar("unitvehicle_repaircooldown")
local RepairRange = GetConVar("unitvehicle_repairrange")
local RacerTags = GetConVar("unitvehicle_racertags")

--unit convars
local UVUHelicopterBusting = GetConVar("unitvehicle_unit_helicopterbusting")

local UVUMaxUnits1 = GetConVar("unitvehicle_unit_maxunits1")
local UVUUnitsAvailable1 = GetConVar("unitvehicle_unit_unitsavailable1")
local UVUBackupTimer1 = GetConVar("unitvehicle_unit_backuptimer1")
local UVUCooldownTimer1 = GetConVar("unitvehicle_unit_cooldowntimer1")
local UVURoadblocks1 = GetConVar("unitvehicle_unit_roadblocks1")
local UVUHelicopters1 = GetConVar("unitvehicle_unit_helicopters1")

local UVUMaxUnits2 = GetConVar("unitvehicle_unit_maxunits2")
local UVUUnitsAvailable2 = GetConVar("unitvehicle_unit_unitsavailable2")
local UVUBackupTimer2 = GetConVar("unitvehicle_unit_backuptimer2")
local UVUCooldownTimer2 = GetConVar("unitvehicle_unit_cooldowntimer2")
local UVURoadblocks2 = GetConVar("unitvehicle_unit_roadblocks2")
local UVUHelicopters2 = GetConVar("unitvehicle_unit_helicopters2")

local UVUMaxUnits3 = GetConVar("unitvehicle_unit_maxunits3")
local UVUUnitsAvailable3 = GetConVar("unitvehicle_unit_unitsavailable3")
local UVUBackupTimer3 = GetConVar("unitvehicle_unit_backuptimer3")
local UVUCooldownTimer3 = GetConVar("unitvehicle_unit_cooldowntimer3")
local UVURoadblocks3 = GetConVar("unitvehicle_unit_roadblocks3")
local UVUHelicopters3 = GetConVar("unitvehicle_unit_helicopters3")

local UVUMaxUnits4 = GetConVar("unitvehicle_unit_maxunits4")
local UVUUnitsAvailable4 = GetConVar("unitvehicle_unit_unitsavailable4")
local UVUBackupTimer4 = GetConVar("unitvehicle_unit_backuptimer4")
local UVUCooldownTimer4 = GetConVar("unitvehicle_unit_cooldowntimer4")
local UVURoadblocks4 = GetConVar("unitvehicle_unit_roadblocks4")
local UVUHelicopters4 = GetConVar("unitvehicle_unit_helicopters4")

local UVUMaxUnits5 = GetConVar("unitvehicle_unit_maxunits5")
local UVUUnitsAvailable5 = GetConVar("unitvehicle_unit_unitsavailable5")
local UVUBackupTimer5 = GetConVar("unitvehicle_unit_backuptimer5")
local UVUCooldownTimer5 = GetConVar("unitvehicle_unit_cooldowntimer5")
local UVURoadblocks5 = GetConVar("unitvehicle_unit_roadblocks5")
local UVUHelicopters5 = GetConVar("unitvehicle_unit_helicopters5")

local UVUMaxUnits6 = GetConVar("unitvehicle_unit_maxunits6")
local UVUUnitsAvailable6 = GetConVar("unitvehicle_unit_unitsavailable6")
local UVUBackupTimer6 = GetConVar("unitvehicle_unit_backuptimer6")
local UVUCooldownTimer6 = GetConVar("unitvehicle_unit_cooldowntimer6")
local UVURoadblocks6 = GetConVar("unitvehicle_unit_roadblocks6")
local UVUHelicopters6 = GetConVar("unitvehicle_unit_helicopters6")

local dvd = DecentVehicleDestination

file.AsyncRead('unitvehicles/names/Names.json', 'DATA', function( _, _, status, data )
	UVNames = util.JSONToTable(data)
end, true)

timer.Simple(5, function()
	if !DecentVehicleDestination then
		PrintMessage( HUD_PRINTTALK, "/// Unit Vehicles requires Decent Vehicles to be installed! /// https://steamcommunity.com/sharedfiles/filedetails/?id=1587455087")
	end
	if !simfphys then
		PrintMessage( HUD_PRINTTALK, "/// Unit Vehicles recommends simfphys! Attempting to spawn a simfphys vehicle from the Unit Manager may cause errors! /// https://steamcommunity.com/sharedfiles/filedetails/?id=771487490")
	end
	if !Glide then
		PrintMessage( HUD_PRINTTALK, "/// Unit Vehicles recommends Glide! Attempting to spawn a Glide vehicle from the Unit Manager may cause errors! /// https://steamcommunity.com/sharedfiles/filedetails/?id=3389728250")
	end
end)

concommand.Add("uv_spawnvehicles", function(ply)
	if not ply:IsSuperAdmin() then return end
	PrintMessage( HUD_PRINTTALK, "Spawning Unit Vehicle(s)...")
	UVApplyHeatLevel()
	UVAutoSpawn(ply)
	uvidlespawning = CurTime()
	uvpresencemode = true
	UVRestoreResourcePoints()
end)

concommand.Add("uv_despawnvehicles", function(ply)
	if not ply:IsSuperAdmin() then return end
	uvpresencemode = false
	PrintMessage( HUD_PRINTTALK, "Despawning Unit Vehicle(s)!")
	for k, v in pairs(ents.FindByClass("npc_uv*")) do
		v:Remove()
	end
	UVRestoreResourcePoints()
end)

concommand.Add("uv_resetallsettings", function(ply)
	if not ply:IsSuperAdmin() then return end
	ply:EmitSound("buttons/button15.wav", 0, 100, 0.5, CHAN_STATIC)
	HeatLevels:Revert()
	TargetVehicleType:Revert()
	DetectionRange:Revert()
	PlayMusic:Revert()
	NeverEvade:Revert()
	BustedTimer:Revert()
	CanWreck:Revert()
	Chatter:Revert()
	SpeedLimit:Revert()
	AutoHealth:Revert()
	MinHeatLevel:Revert()
	MaxHeatLevel:Revert()
	SpikeStripDuration:Revert()
	Pathfinding:Revert()
	VCModELSPriority:Revert()
	CallResponse:Revert()
	ChatterText:Revert()
	Headlights:Revert()
	Relentless:Revert()
	SpawnMainUnits:Revert()
	RepairCooldown:Revert()
	RepairRange:Revert()
	RacerTags:Revert()
end)

concommand.Add("uv_startpursuit", function(ply)
	if not ply:IsSuperAdmin() then return end
	PrintMessage( HUD_PRINTTALK, "Starting a pursuit ... get ready!" )
	UVApplyHeatLevel()
	if SpawnMainUnits:GetBool() then
		UVAutoSpawn(ply)
		uvidlespawning = CurTime()
		uvpresencemode = true
	end
	UVRestoreResourcePoints()
	ply:EmitSound("ui/pursuit/startingpursuit/chaseresuming_start.wav", 0, 100, 0.5, CHAN_STATIC)
	timer.Create( "UVStartPursuit3", 2, 1, function()
		PrintMessage( HUD_PRINTTALK, "Starting a pursuit in 3!" )
		ply:EmitSound("ui/pursuit/startingpursuit/chaseresuming_2.wav", 0, 100, 0.5, CHAN_STATIC)
	end)
	timer.Create( "UVStartPursuit2", 3, 1, function()
		PrintMessage( HUD_PRINTTALK, "Starting a pursuit in 2!" )
		ply:EmitSound("ui/pursuit/startingpursuit/chaseresuming_3.wav", 0, 100, 0.5, CHAN_STATIC)
	end)
	timer.Create( "UVStartPursuit1", 4, 1, function() 
		PrintMessage( HUD_PRINTTALK, "Starting a pursuit in 1!" )
		ply:EmitSound("ui/pursuit/startingpursuit/chaseresuming_1.wav", 0, 100, 0.5, CHAN_STATIC)
	end)
	timer.Create( "UVStartPursuitGo", 5, 1, function()
		PrintMessage( HUD_PRINTTALK, "GO!" )
		ply:EmitSound("ui/pursuit/startingpursuit/chaseresuming_go.wav", 0, 100, 0.5, CHAN_STATIC)
		if next(ents.FindByClass("npc_uv*")) ~= nil then
			local units = ents.FindByClass("npc_uv*")
			local random_entry = math.random(#units)	
			local unit = units[random_entry]
			UVSoundChatter(unit, unit.voice, "pursuitstartacknowledge", 8)
		end
		RunConsoleCommand("ai_ignoreplayers", "0")
		uvlosing = CurTime()
		uvtargeting = true
	end)
end)

concommand.Add("uv_stoppursuit", function(ply)
	uvcooldowntimerprogress = 1
end)

concommand.Add("uv_racershordestart", function(ply)
	if not ply:IsSuperAdmin() then return end
	PrintMessage( HUD_PRINTTALK, "Starting a horde of Racers!" )
	UVApplyHeatLevel()
	UVAutoSpawnRacer(ply)
	uvidlespawning = CurTime()
	uvracerpresencemode = true
	UVRestoreResourcePoints()
	ply:EmitSound("ui/pursuit/startingpursuit/chaseresuming_go.wav", 0, 100, 0.5, CHAN_STATIC)
	RunConsoleCommand("ai_ignoreplayers", "0")
end)

concommand.Add("uv_racershordestop", function(ply)
	if not ply:IsSuperAdmin() then return end
	PrintMessage( HUD_PRINTTALK, "Stopping the horde of Racers!" )
	uvracerpresencemode = false
end)

concommand.Add("uv_wantedtable", function(ply)
	print("Bounty: "..string.Comma(uvbounty))
	print("/// Wanted Vehicles ///")
	PrintTable(uvwantedtablevehicle)
	print("/// Wanted Drivers ///")
	PrintTable(uvwantedtabledriver)
	print("/// Potential Suspects ///")
	PrintTable(uvpotentialsuspects)
end)

function UVApplyHeatLevel()
	if MinHeatLevel:GetInt() <= 1 then
		PrintMessage( HUD_PRINTTALK, "You are currently at Heat Level 1!")
		uvheatlevel = 1
	elseif !(MaxHeatLevel:GetInt() < 2) and MinHeatLevel:GetInt() <= 2 then
		PrintMessage( HUD_PRINTTALK, "You are currently at Heat Level 2!")
		uvheatlevel = 2
	elseif !(MaxHeatLevel:GetInt() < 3) and MinHeatLevel:GetInt() <= 3 then
		PrintMessage( HUD_PRINTTALK, "You are currently at Heat Level 3!")
		uvheatlevel = 3
	elseif !(MaxHeatLevel:GetInt() < 4) and MinHeatLevel:GetInt() <= 4 then
		PrintMessage( HUD_PRINTTALK, "You are currently at Heat Level 4!")
		uvheatlevel = 4
	elseif !(MaxHeatLevel:GetInt() < 5) and MinHeatLevel:GetInt() <= 5 then
		PrintMessage( HUD_PRINTTALK, "You are currently at Heat Level 5!")
		uvheatlevel = 5
	elseif !(MaxHeatLevel:GetInt() < 6) and MinHeatLevel:GetInt() <= 6 then
		PrintMessage( HUD_PRINTTALK, "You are currently at Heat Level 6!")
		uvheatlevel = 6
	end
end

function UVUpdateHeatLevel()

	local bounty = uvbounty
	
	if UVUTimeTillNextHeatEnabled:GetInt() != 1 then
		if bounty < UVUHeatMinimumBounty2:GetInt() and !(MaxHeatLevel:GetInt() < 1) and MinHeatLevel:GetInt() <= 1 then
		elseif bounty < UVUHeatMinimumBounty3:GetInt() and !(MaxHeatLevel:GetInt() < 2) and MinHeatLevel:GetInt() <= 2 then
			if uvheatlevel < 2 then 
				uvheatlevel = 2
				PrintMessage( HUD_PRINTCENTER, "HEAT LEVEL 2!")
				if next(ents.FindByClass("npc_uv*")) ~= nil and Chatter:GetBool() then
					local units = ents.FindByClass("npc_uv*")
					local random_entry = math.random(#units)	
					local unit = units[random_entry]
					if !uvtargeting then return end
					UVChatterHeatTwo(unit)
				end
				if uvtargeting then
					UVRelaySoundToClients("ui/pursuit/heatlevelrise.wav", false)
					--Entity(1):EmitSound("ui/pursuit/heatlevelrise.wav", 0, 100, 0.5)
				end
				net.Start("UVHUDHeatLevelIncrease")
				net.Broadcast()
			end
		elseif bounty < UVUHeatMinimumBounty4:GetInt() and !(MaxHeatLevel:GetInt() < 3) and MinHeatLevel:GetInt() <= 3 then
			if uvheatlevel < 3 then 
				uvheatlevel = 3
				PrintMessage( HUD_PRINTCENTER, "HEAT LEVEL 3!")
				if next(ents.FindByClass("npc_uv*")) ~= nil and Chatter:GetBool() then
					local units = ents.FindByClass("npc_uv*")
					local random_entry = math.random(#units)	
					local unit = units[random_entry]
					if !uvtargeting then return end
					UVChatterHeatThree(unit)
				end
				if uvtargeting then
					UVRelaySoundToClients("ui/pursuit/heatlevelrise.wav", false)
					--Entity(1):EmitSound("ui/pursuit/heatlevelrise.wav", 0, 100, 0.5)
				end
				net.Start("UVHUDHeatLevelIncrease")
				net.Broadcast()
			end
		elseif bounty < UVUHeatMinimumBounty5:GetInt() and !(MaxHeatLevel:GetInt() < 4) and MinHeatLevel:GetInt() <= 4 then
			if uvheatlevel < 4 then 
				uvheatlevel = 4
				PrintMessage( HUD_PRINTCENTER, "HEAT LEVEL 4!")
				if next(ents.FindByClass("npc_uv*")) ~= nil and Chatter:GetBool() then
					local units = ents.FindByClass("npc_uv*")
					local random_entry = math.random(#units)	
					local unit = units[random_entry]
					if !uvtargeting then return end
					UVChatterHeatFour(unit)
				end
				if uvtargeting then
					UVRelaySoundToClients("ui/pursuit/heatlevelrise.wav", false)
					--Entity(1):EmitSound("ui/pursuit/heatlevelrise.wav", 0, 100, 0.5)
				end
				net.Start("UVHUDHeatLevelIncrease")
				net.Broadcast()
			end
		elseif bounty < UVUHeatMinimumBounty6:GetInt() and !(MaxHeatLevel:GetInt() < 5) and MinHeatLevel:GetInt() <= 5 then
			if uvheatlevel < 5 then 
				uvheatlevel = 5
				PrintMessage( HUD_PRINTCENTER, "HEAT LEVEL 5!")
				if next(ents.FindByClass("npc_uv*")) ~= nil and Chatter:GetBool() then
					local units = ents.FindByClass("npc_uv*")
					local random_entry = math.random(#units)	
					local unit = units[random_entry]
					if !uvtargeting then return end
					UVChatterHeatFive(unit)
				end
				if uvtargeting then
					UVRelaySoundToClients("ui/pursuit/heatlevelrise.wav", false)
					--Entity(1):EmitSound("ui/pursuit/heatlevelrise.wav", 0, 100, 0.5)
				end
				net.Start("UVHUDHeatLevelIncrease")
				net.Broadcast()
			end
		elseif !(MaxHeatLevel:GetInt() < 6) and MinHeatLevel:GetInt() <= 6 then
			if uvheatlevel < 6 then 
				uvheatlevel = 6
				PrintMessage( HUD_PRINTCENTER, "HEAT LEVEL 6!")
				if next(ents.FindByClass("npc_uv*")) ~= nil and Chatter:GetBool() then
					local units = ents.FindByClass("npc_uv*")
					local random_entry = math.random(#units)	
					local unit = units[random_entry]
					if !uvtargeting then return end
					UVChatterHeatSix(unit)
				end
				if uvtargeting then
					UVRelaySoundToClients("ui/pursuit/heatlevelrise.wav", false)
					--Entity(1):EmitSound("ui/pursuit/heatlevelrise.wav", 0, 100, 0.5)
				end
				net.Start("UVHUDHeatLevelIncrease")
				net.Broadcast()
			end
		end
	end

	local ply = Entity(1)
	if !ply then 
		return 
	end

	if uvheatlevel == 1 then --Heat Level 1
		uvmaxunits = UVUMaxUnits1:GetInt()
		uvbountymultiplier = 1
		uvbountytime = UVUBountyTime1:GetInt()
		uvroadblockcount = 2
		uvbustspeed = 30976
		uvcooldowntimer = UVUCooldownTimer1:GetInt()
		uvbackuptimermax = UVUBackupTimer1:GetInt()
		if UVURoadblocks1:GetInt() == 1 then
			uvroadblockdeployable = true
		else
			uvroadblockdeployable = nil
		end
		if UVUHelicopters1:GetInt() == 1 then
			uvhelicopterdeployable = true
		else
			uvhelicopterdeployable = nil
		end
	elseif uvheatlevel == 2 then --Heat Level 2
		uvmaxunits = UVUMaxUnits2:GetInt()
		uvbountymultiplier = 2
		uvbountytime = UVUBountyTime2:GetInt()
		uvroadblockcount = 4
		uvbustspeed = 30976
		uvcooldowntimer = UVUCooldownTimer2:GetInt()
		uvbackuptimermax = UVUBackupTimer2:GetInt()
		if UVURoadblocks2:GetInt() == 1 then
			uvroadblockdeployable = true
		else
			uvroadblockdeployable = nil
		end
		if UVUHelicopters2:GetInt() == 1 then
			uvhelicopterdeployable = true
		else
			uvhelicopterdeployable = nil
		end
	elseif uvheatlevel == 3 then --Heat Level 3
		uvmaxunits = UVUMaxUnits3:GetInt()
		uvbountymultiplier = 3
		uvbountytime = UVUBountyTime3:GetInt()
		uvroadblockcount = 6
		uvbustspeed = 69696
		uvcooldowntimer = UVUCooldownTimer3:GetInt()
		uvbackuptimermax = UVUBackupTimer3:GetInt()
		if UVURoadblocks3:GetInt() == 1 then
			uvroadblockdeployable = true
		else
			uvroadblockdeployable = nil
		end
		if UVUHelicopters3:GetInt() == 1 then
			uvhelicopterdeployable = true
		else
			uvhelicopterdeployable = nil
		end
	elseif uvheatlevel == 4 then --Heat Level 4
		uvmaxunits = UVUMaxUnits4:GetInt()
		uvbountymultiplier = 4
		uvbountytime = UVUBountyTime4:GetInt()
		uvroadblockcount = 8
		uvbustspeed = 69696
		uvcooldowntimer = UVUCooldownTimer4:GetInt()
		uvbackuptimermax = UVUBackupTimer4:GetInt()
		if UVURoadblocks4:GetInt() == 1 then
			uvroadblockdeployable = true
		else
			uvroadblockdeployable = nil
		end
		if UVUHelicopters4:GetInt() == 1 then
			uvhelicopterdeployable = true
		else
			uvhelicopterdeployable = nil
		end
	elseif uvheatlevel == 5 then --Heat Level 5
		uvmaxunits = UVUMaxUnits5:GetInt()
		uvbountymultiplier = 5
		uvbountytime = UVUBountyTime5:GetInt()
		uvroadblockcount = 10
		uvbustspeed = 123904
		uvcooldowntimer = UVUCooldownTimer5:GetInt()
		uvbackuptimermax = UVUBackupTimer5:GetInt()
		if UVURoadblocks5:GetInt() == 1 then
			uvroadblockdeployable = true
		else
			uvroadblockdeployable = nil
		end
		if UVUHelicopters5:GetInt() == 1 then
			uvhelicopterdeployable = true
		else
			uvhelicopterdeployable = nil
		end
	else --Heat Level 6
		uvmaxunits = UVUMaxUnits6:GetInt()
		uvbountymultiplier = 6
		uvbountytime = UVUBountyTime6:GetInt()
		uvroadblockcount = 12
		uvbustspeed = 123904
		uvcooldowntimer = UVUCooldownTimer6:GetInt()
		uvbackuptimermax = UVUBackupTimer6:GetInt()
		if UVURoadblocks6:GetInt() == 1 then
			uvroadblockdeployable = true
		else
			uvroadblockdeployable = nil
		end
		if UVUHelicopters6:GetInt() == 1 then
			uvhelicopterdeployable = true
		else
			uvhelicopterdeployable = nil
		end
	end

	local function CheckVehicleLimit()
		return (#ents.FindByClass("npc_uv*") + #uvwreckedvehicles) < uvmaxunits or #ents.FindByClass("npc_uv*") < 1
	end

	if uvtargeting and uvresourcepoints > (#ents.FindByClass("npc_uv*")) and !uvjammerdeployed then
		if CheckVehicleLimit() then
			if uvracerpresencemode then
				local racerchance = math.random(1,2)
				if racerchance == 1 and #ents.FindByClass("npc_racervehicle") < uvheatlevel then
					UVAutoSpawnRacer(ply)
					return
				end
			end
			local specialchance = math.random(1,10)
			if uvcommanderrespawning then
				UVAutoSpawn(nil, nil, nil, nil, uvcommanderrespawning) --COMMANDER RESPAWN
			elseif specialchance == 1 and !uvenemyescaping then
				UVAutoSpawn(ply, true) --RHINO
			elseif specialchance >= 2 and specialchance <= 5 and next(ents.FindByClass("npc_uv*")) ~= nil and uvroadblockdeployable then
				local units = ents.FindByClass("npc_uv*")
				local random_entry = math.random(#units)	
				local unit = units[random_entry]
				UVDeployRoadblock(unit) --ROADBLOCK
			elseif specialchance == 6 and #ents.FindByClass("uvair") < 1 and uvhelicopterdeployable and CurTime() - uvhelicooldown > 120 then
				UVAutoSpawn(ply, nil, true) --HELICOPTER
			elseif SpawnMainUnits:GetBool() then
				UVAutoSpawn(ply) --NORMAL
			end
		end
	end

end

function UVResetStats()
	if next(uvwantedtablevehicle) == nil and next(uvwantedtabledriver) == nil then
		uvbounty = 0
		if timer.Exists("UVTimeTillNextHeat") then
			timer.Remove("UVTimeTillNextHeat")
		end
	end
	uvdeploys = 0
	uvwrecks = 0
	uvtags = 0
	uvroadblocksdodged = 0
	uvspikestripsdodged = 0
	if uvbounty == 0 then
		if MinHeatLevel:GetInt() <= 1 then 
			uvheatlevel = 1
		elseif MinHeatLevel:GetInt() <= 2 then
			uvheatlevel = 2
		elseif MinHeatLevel:GetInt() <= 3 then
			uvheatlevel = 3
		elseif MinHeatLevel:GetInt() <= 4 then
			uvheatlevel = 4
		elseif MinHeatLevel:GetInt() <= 5 then
			uvheatlevel = 5
		else
			uvheatlevel = 6
		end
	end
	if uvenemyescaping then
		uvenemyescaping = nil
	end
	if UVTimer then
		UVTimer = nil
	end
end

function UVRestoreResourcePoints()
	uvresourcepointsrefreshing = true
	if !uvonecommanderactive then
		uvonecommanderdeployed = nil
	else
		uvonecommanderdeployed = true
	end
	timer.Simple(1, function()
		if uvresourcepointsrefreshing then
			uvresourcepointsrefreshing = false
		end
	end)
	if uvheatlevel == 1 then --Heat Level 1
		uvresourcepoints = UVUUnitsAvailable1:GetInt()
	elseif uvheatlevel == 2 then --Heat Level 2
		uvresourcepoints = UVUUnitsAvailable2:GetInt()
	elseif uvheatlevel == 3 then --Heat Level 3
		uvresourcepoints = UVUUnitsAvailable3:GetInt()
	elseif uvheatlevel == 4 then --Heat Level 4
		uvresourcepoints = UVUUnitsAvailable4:GetInt()
	elseif uvheatlevel == 5 then --Heat Level 5
		uvresourcepoints = UVUUnitsAvailable5:GetInt()
	else --Heat Level 6
		uvresourcepoints = UVUUnitsAvailable6:GetInt()
	end
	uvbackupontheway = nil
end

function UVRequestVectorsnavmesh( start, goal, carwidth )
	local startArea = navmesh.GetNearestNavArea( start )
	local goalArea = navmesh.GetNearestNavArea( goal )
	if uvenemyescaping then
		local navmeshtable = navmesh.GetAllNavAreas()
		if next(navmeshtable) ~= nil then
			goalArea = navmeshtable[math.random(#navmeshtable)] --Go to a random spot when searching
		end
	end
	if !carwidth then
		carwidth = 0
	end
	return UVEstablishVectorsnavmesh( startArea, goalArea, carwidth )
end

function UVEstablishVectorsnavmesh( start, goal, carwidth )
	if ( !IsValid( start ) || !IsValid( goal ) ) then return nil end
	if ( start == goal ) then return true end

	start:ClearSearchLists()

	start:AddToOpenList()

	local cameFrom = {}

	start:SetCostSoFar( 0 )

	start:SetTotalCost( UVheuristic_cost_estimate( start, goal ) )
	start:UpdateOnOpenList()

	while ( !start:IsOpenListEmpty() ) do
		local current = start:PopOpenList()
		if ( current == goal ) then
			return UVreconstruct_path( cameFrom, current )
		end

		current:AddToClosedList()

		for k, neighbor in pairs( current:GetAdjacentAreas() ) do
			local newCostSoFar = current:GetCostSoFar() + UVheuristic_cost_estimate( current, neighbor )

			if ( neighbor:IsUnderwater() or 
			current:ComputeAdjacentConnectionHeightChange(neighbor) > 1 ) then
				continue
			end
			
			if ( ( neighbor:IsOpen() || neighbor:IsClosed() ) && neighbor:GetCostSoFar() <= newCostSoFar ) then
				continue
			else
				neighbor:SetCostSoFar( newCostSoFar );
				neighbor:SetTotalCost( newCostSoFar + UVheuristic_cost_estimate( neighbor, goal ) )

				if ( neighbor:IsClosed() ) then
				
					neighbor:RemoveFromClosedList()
				end

				if ( neighbor:IsOpen() ) then
					neighbor:UpdateOnOpenList()
				else
					neighbor:AddToOpenList()
				end

				cameFrom[ neighbor:GetID() ] = current:GetID()
			end
		end
	end

	return false
end

function UVheuristic_cost_estimate( start, goal )
	return start:GetCenter():Distance( goal:GetCenter() )
end

function UVreconstruct_path( cameFrom, current )
	local total_path = { current }

	current = current:GetID()
	while ( cameFrom[ current ] ) do
		current = cameFrom[ current ]
		table.insert( total_path, navmesh.GetNavAreaByID( current ) )
	end
	return total_path
end

function UVdrawThePath( path, time )
	local prevArea
	for _, area in pairs( path ) do
		debugoverlay.Sphere( area:GetCenter(), 8, time or 9, color_white, true  )
		if ( prevArea ) then
			debugoverlay.Line( area:GetCenter(), prevArea:GetCenter(), time or 9, color_white, true )
		end

		area:Draw()
		prevArea = area
	end
end

function UVPassConVarFilter(v)

	if !IsValid(v) or v.uvbusted or UVGetDriver(v) == false then
		return false
	end

	if v:GetClass() == "prop_vehicle_prisoner_pod" then 
		return false 
	end

	if (v:GetClass() == "prop_vehicle_jeep" or v.IsSimfphyscar or v.IsGlideVehicle) and TargetVehicleType:GetInt() == 1 then
		return (IsValid(v.MadVehicle) or UVGetDriver(v):IsPlayer() or IsValid(v.DecentVehicle) or IsValid(v.RacerVehicle) or IsValid(v.UVWanted)) and !IsValid(v.UnitVehicle)
	elseif v:IsVehicle() and TargetVehicleType:GetInt() == 2 then
		return IsValid(v.DecentVehicle) and !IsValid(v.UnitVehicle)
	elseif v:IsVehicle() and TargetVehicleType:GetInt() == 3 then
		return (IsValid(v.MadVehicle) or UVGetDriver(v):IsPlayer() or IsValid(v.RacerVehicle) or IsValid(v.UVWanted)) and !IsValid(v.DecentVehicle) and !IsValid(v.UnitVehicle)
	end
	
	return false
end

function UVStraightToWaypoint(origin, waypoint)
	if !origin or !waypoint then
		return
	end

	--local originpos = util.TraceLine({start = origin, endpos = (origin+Vector(0,0,-1000)), mask = MASK_NPCWORLDSTATIC}).HitPos
	--local waypointpos = util.TraceLine({start = waypoint, endpos = (waypoint+Vector(0,0,-1000)), mask = MASK_NPCWORLDSTATIC}).HitPos

	local tr = util.TraceLine({start = origin, endpos = waypoint, mask = MASK_NPCWORLDSTATIC}).Fraction==1
	return tobool(tr)
end

hook.Add("OnEntityCreated", "UVCollisionGlide", function(glidevehicle) --Override Glide collisions for the time being 
	if !Glide then return end
	
	local RealTime = RealTime
	local DamageInfo = DamageInfo
	local GetWorld = game.GetWorld

	local Clamp = math.Clamp
	local RandomInt = math.random
	local PlaySoundSet = Glide.PlaySoundSet

	local cvarCollision = GetConVar( "glide_physics_damage_multiplier" )
	local cvarWorldCollision = GetConVar( "glide_world_physics_damage_multiplier" )

	local cvarCollision = GetConVar( "glide_physics_damage_multiplier" )
	if ( glidevehicle.IsGlideVehicle ) then
		glidevehicle.PhysicsCollide = function( car, coldata, ent )
			if isfunction(car.UVPhysicsCollide) then
				car:UVPhysicsCollide(coldata)
			end
			local object = coldata.HitEntity
			if car.esfon and object:IsVehicle() and !(object.UnitVehicle and car.UnitVehicle) then --ESF
				local enemyvehicle = object
				local enemycallsign
				if object.UnitVehicle then
					enemycallsign = object.UnitVehicle.callsign or "Unit "..object:EntIndex()
				else
					enemycallsign = object.racer or "Racer "..enemyvehicle:EntIndex()
				end
				local enemydriver = UVGetDriver(enemyvehicle)
				local power
				local damage
				if car.UnitVehicle then
					power = UVUnitPTESFPower:GetInt()
					damage = UVUnitPTESFDamage:GetFloat()
				else
					power = UVPTESFPower:GetInt()
					damage = UVPTESFDamage:GetFloat()
				end
				local carpos = car:WorldSpaceCenter()
				local enemyvehiclephys = enemyvehicle:GetPhysicsObject()
				local vectordifference = enemyvehicle:WorldSpaceCenter() - carpos
				local angle = vectordifference:Angle()
				local force = power * (1 - (vectordifference:Length()/1000))
				enemyvehiclephys:ApplyForceCenter(angle:Forward()*force)
				enemyvehicle.rammed = true
				timer.Simple(5, function()
					if IsValid(enemyvehicle) then
						enemyvehicle.rammed = nil
					end
				end)
				if enemydriver then
					if enemydriver:IsPlayer() then
						enemycallsign = enemydriver:GetName()
					end
				end
				if object.UnitVehicle or (object.UVWanted and !AutoHealth:GetBool()) or !(object.UnitVehicle and object.UVWanted) then
					if object.IsSimfphyscar then
						local MaxHealth = object:GetMaxHealth()
						local damage = MaxHealth * damage--0.4
						object:ApplyDamage( damage, DMG_GENERIC )
					elseif object.IsGlideVehicle then
						object:SetEngineHealth( object:GetEngineHealth() - damage )--0.4
    					object:UpdateHealthOutputs()
					elseif object:GetClass() == "prop_vehicle_jeep" then
					
					end
				end
				if isfunction(enemyvehicle.GetDriver) and IsValid(UVGetDriver(enemyvehicle)) and UVGetDriver(enemyvehicle):IsPlayer() then 
					UVGetDriver(enemyvehicle):PrintMessage( HUD_PRINTCENTER, "YOU HAVE BEEN HIT BY AN ESF!")
				end
				if isfunction(car.GetDriver) and IsValid(UVGetDriver(car)) and UVGetDriver(car):IsPlayer() then 
					UVGetDriver(car):PrintMessage( HUD_PRINTCENTER, "ESF HIT ON "..enemycallsign.."!")
				end
				local e = EffectData()
				e:SetEntity(enemyvehicle)
				util.Effect("entity_remove", e)
				enemyvehicle:EmitSound("gadgets/esf/impact.wav")
				car.uvesfhit = true
				UVDeactivateESF(car)
				if car.UnitVehicle then
					UVChatterKillswitchHit(car.UnitVehicle)
				end
			end
			if car.UVWanted then --SUSPECT
				if object:IsWorld() or object.DecentVehicle then --Crashed into world
					local ouroldvel = coldata.OurOldVelocity:Length()
					local ournewvel = coldata.OurNewVelocity:Length()
					local resultvel = ouroldvel
					if ouroldvel > ournewvel then --slowed
						resultvel = ouroldvel - ournewvel
					else --sped up
						resultvel = ournewvel - ouroldvel
					end
					local dot = coldata.OurOldVelocity:GetNormalized():Dot(coldata.HitNormal)
					dot = math.abs(dot) / 2
					local dmg = resultvel * dot
					if dmg >= 100 and !uvenemyescaping and uvtargeting then
						if object:IsWorld() then
							if Chatter:GetBool() and uvtargeting and next(ents.FindByClass("npc_uv*")) ~= nil then
								local units = ents.FindByClass("npc_uv*")
								local random_entry = math.random(#units)	
								local unit = units[random_entry]
								if IsValid(unit.e) then 
									UVChatterEnemyCrashed(unit) 
								end
							end
						elseif object.DecentVehicle then
							if Chatter:GetBool() and uvtargeting and next(ents.FindByClass("npc_uv*")) ~= nil then
								local units = ents.FindByClass("npc_uv*")
								local random_entry = math.random(#units)	
								local unit = units[random_entry]
								if IsValid(unit.e) then 
									UVChatterHitTraffic(unit) 
								end
							end
						end
					end
				end
				if object.UVRoadblock and !object.UVRoadblock.RoadBlockHit then --Crashed into roadblock
					object.UVRoadblock.RoadBlockHit = true
					if Chatter:GetBool() and uvtargeting and next(ents.FindByClass("npc_uv*")) ~= nil then
						local units = ents.FindByClass("npc_uv*")
						local random_entry = math.random(#units)	
						local unit = units[random_entry]
						if IsValid(unit.e) then 
							UVChatterRoadblockHit(unit) 
						end
					end
				end
			elseif car.UnitVehicle then --UNIT NPC
				local classmultiplier = 1
				local NPC = car.UnitVehicle
				if NPC:IsNPC() then
					if car.uvclasstospawnon == "npc_uvsupport" then
						classmultiplier = 2
					elseif car.uvclasstospawnon == "npc_uvpursuit" then
						classmultiplier = 3
					elseif car.uvclasstospawnon == "npc_uvinterceptor" then
						classmultiplier = 4
					elseif car.uvclasstospawnon == "npc_uvspecial" then
						classmultiplier = 5
					elseif car.uvclasstospawnon == "npc_uvcommander" then
						classmultiplier = 6
					end
					if (!uvtargeting and UVPassConVarFilter(object) or uvtargeting and object.UVWanted) then
						if car.rammed then
							car.rammed = nil
						end
						car.rammed = true
						timer.Simple(5, function() 
							if IsValid(NPC) then 
								car.rammed = nil
							end 
						end)
					end
					if object.UVWanted and !car.tagged then
						car.tagged = true
						uvtags = uvtags + 1
						if car.rhino and !car.rhinohit then
							car.rhinohit = true
							if Chatter:GetBool() and uvtargeting then
								UVSoundChatter(NPC, NPC.voice, "rhinohit", 1)
							end
						end
					end
					local ouroldvel = coldata.OurOldVelocity:Length()
					local ournewvel = coldata.OurNewVelocity:Length()
					local resultvel = ouroldvel
					if ouroldvel > ournewvel then --slowed
						resultvel = ouroldvel - ournewvel
					else --sped up
						resultvel = ournewvel - ouroldvel
					end
					local dot = coldata.OurOldVelocity:GetNormalized():Dot(coldata.HitNormal)
					dot = math.abs(dot) / 2
					local dmg = resultvel * dot
					if dmg >= 100 and object.UVWanted then
						if Chatter:GetBool() then
							if coldata.TheirOldVelocity:Length() > ouroldvel then
								UVChatterRammed(NPC)
								UVDeactivateKillSwitch(car)
							else
								UVChatterRammedEnemy(NPC)
							end
						end
						if !NPC.ramming then
							NPC.ramming = true
							NPC:SetHorn(true)
						end
						timer.Simple(math.random(1,5), function()
							if NPC then
								if NPC.ramming then
									NPC.ramming = nil
									NPC:SetHorn(false)
									NPC:SetELSSiren(true)
								end
							end
						end)
					end
				elseif !uvtargeting and !uvenemyescaped and !uvenemybusted and table.HasValue(uvpotentialsuspects, object) then
					uvtargeting = true
				end
			end
    		if !object.UnitVehicle then --CALL HANDLER
    		    if !object:IsWorld() then
					local ctimeout = 1
    		        if object:IsVehicle() then --Hit And Run
    		            if CurTime() > uvpreinfractioncountcooldown + ctimeout then
    		                uvpreinfractioncount = uvpreinfractioncount + 1
    		                uvpreinfractioncountcooldown = CurTime()
    		                if uvpreinfractioncount >= 10 then
    		                    if UVPassConVarFilter(car) then
    		                        UVCallInitiate(car, 3)
    		                    end
    		                end
    		            end
    		        else --Damage to Property
    		            if CurTime() > uvpreinfractioncountcooldown + ctimeout then
    		                uvpreinfractioncount = uvpreinfractioncount + 1
    		                uvpreinfractioncountcooldown = CurTime()
    		                if uvpreinfractioncount >= 10 then
    		                    if UVPassConVarFilter(car) then
    		                        UVCallInitiate(car, 2)
    		                    end
    		                end
    		            end
    		        end
    		    end
    		end

			if coldata.TheirSurfaceProps == 76 then -- default_silent
				return
			end
		
			local velocityChange = coldata.OurNewVelocity - coldata.OurOldVelocity
			local surfaceNormal = coldata.HitNormal
		
			local speed = velocityChange:Length()
			if speed < 30 then return end
		
			if car.FallOnCollision then
				car:PhysicsCollideFall( speed, coldata )
			end
		
			local ent = coldata.HitEntity
			local isPlayer = IsValid( ent ) and ent:IsPlayer()
			local t = RealTime()
		
			if isPlayer then
				-- Don't let players make loud sounds
				speed = 100
		
			elseif t > car.collisionShakeCooldown then
				car.collisionShakeCooldown = t + 0.5
				Glide.SendViewPunch( car:GetAllPlayers(), Clamp( speed / 1000, 0, 1 ) * 3 )
			end
		
			local eff = EffectData()
			eff:SetOrigin( coldata.HitPos )
			eff:SetScale( math.min( speed * 0.02, 6 ) * car.CollisionParticleSize )
			eff:SetNormal( surfaceNormal )
			util.Effect( "glide_metal_impact", eff )
		
			local isHardHit = speed > 300
		
			PlaySoundSet( "Glide.Collision.VehicleHard", car, speed / 400, nil, isHardHit and 80 or 75 )
		
			if isHardHit then
				PlaySoundSet( "Glide.Collision.VehicleSoft", car, speed / 400, nil, isHardHit and 80 or 75 )
		
				if car.IsHeavyVehicle then
					car:EmitSound( "physics/metal/metal_barrel_impact_hard5.wav", 90, RandomInt( 70, 90 ), 1 )
				end
		
			elseif isPlayer then
				PlaySoundSet( "Glide.Collision.VehicleHard", ent, speed / 1000, RandomInt( 90, 130 ) )
		
			elseif surfaceNormal:Dot( -coldata.HitSpeed:GetNormalized() ) < 0.5 then
				PlaySoundSet( "Glide.Collision.VehicleScrape", car, 0.4 )
			end
		
			if not isPlayer and isHardHit then
				-- `ent:IsWorld` is returning `false` on "Entity [0][worldspawn]",
				-- so I'm comparing against `game.GetWorld` instead.
				local multiplier = ent == GetWorld() and cvarWorldCollision:GetFloat() or cvarCollision:GetFloat()
		
				local dmg = DamageInfo()
				dmg:SetAttacker( ent )
				dmg:SetInflictor( car )
				dmg:SetDamage( ( speed / 10 ) * car.CollisionDamageMultiplier * multiplier )
				dmg:SetDamageType( 1 ) -- DMG_CRUSH
				dmg:SetDamagePosition( coldata.HitPos )
				car:TakeDamageInfo( dmg )
			end
		end
	end

end)

hook.Add("simfphysPhysicsCollide", "UVCollisionSimfphys", function(car, coldata, ent)
	if !IsValid(car) or car:GetClass() != "gmod_sent_vehicle_fphysics_base" then return end
	local object = coldata.HitEntity
	if car.esfon and object:IsVehicle() and !(object.UnitVehicle and car.UnitVehicle) then --ESF
		local enemyvehicle = object
		local enemycallsign
		if object.UnitVehicle then
			enemycallsign = object.UnitVehicle.callsign or "Unit "..object:EntIndex()
		else
			enemycallsign = enemyvehicle.racer or "Racer "..enemyvehicle:EntIndex()
		end
		local enemydriver = UVGetDriver(enemyvehicle)
		local power
		local damage
		if car.UnitVehicle then
			power = UVUnitPTESFPower:GetInt()
			damage = UVUnitPTESFDamage:GetFloat()
		else
			power = UVPTESFPower:GetInt()
			damage = UVPTESFDamage:GetFloat()
		end
		local carpos = car:WorldSpaceCenter()
		local enemyvehiclephys = enemyvehicle:GetPhysicsObject()
		local vectordifference = enemyvehicle:WorldSpaceCenter() - carpos
		local angle = vectordifference:Angle()
		local force = power * (1 - (vectordifference:Length()/1000))
		enemyvehiclephys:ApplyForceCenter(angle:Forward()*force)
		enemyvehicle.rammed = true
		timer.Simple(5, function()
			if IsValid(enemyvehicle) then
				enemyvehicle.rammed = nil
			end
		end)
		if enemydriver then
			if enemydriver:IsPlayer() then
				enemycallsign = enemydriver:GetName()
			end
		end
		if object.UnitVehicle or (object.UVWanted and !AutoHealth:GetBool()) or !(object.UnitVehicle and object.UVWanted) then
			if object.IsSimfphyscar then
				local MaxHealth = object:GetMaxHealth()
				local damage = MaxHealth*damage
				object:ApplyDamage( damage, DMG_GENERIC )
			elseif object.IsGlideVehicle then
				object:SetEngineHealth( object:GetEngineHealth() - damage )
    			object:UpdateHealthOutputs()
			elseif object:GetClass() == "prop_vehicle_jeep" then

			end
		end
		if isfunction(enemyvehicle.GetDriver) and IsValid(UVGetDriver(enemyvehicle)) and UVGetDriver(enemyvehicle):IsPlayer() then 
			UVGetDriver(enemyvehicle):PrintMessage( HUD_PRINTCENTER, "YOU HAVE BEEN HIT BY AN ESF!")
		end
		if isfunction(car.GetDriver) and IsValid(UVGetDriver(car)) and UVGetDriver(car):IsPlayer() then 
			UVGetDriver(car):PrintMessage( HUD_PRINTCENTER, "ESF HIT ON "..enemycallsign.."!")
		end
		local e = EffectData()
		e:SetEntity(enemyvehicle)
		util.Effect("entity_remove", e)
		enemyvehicle:EmitSound("gadgets/esf/impact.wav")
		car.uvesfhit = true
		UVDeactivateESF(car)
		if car.UnitVehicle then
			UVChatterKillswitchHit(car.UnitVehicle)
		end
	end
	if car.UVWanted then --SUSPECT
		if object:IsWorld() or object.DecentVehicle then --Crashed into world
			local ouroldvel = coldata.OurOldVelocity:Length()
			local ournewvel = coldata.OurNewVelocity:Length()
			local resultvel = ouroldvel
			if ouroldvel > ournewvel then --slowed
				resultvel = ouroldvel - ournewvel
			else --sped up
				resultvel = ournewvel - ouroldvel
			end
			local dot = coldata.OurOldVelocity:GetNormalized():Dot(coldata.HitNormal)
			dot = math.abs(dot) / 2
			local dmg = resultvel * dot
			if dmg >= 100 and !uvenemyescaping and uvtargeting then
				if object:IsWorld() then
					if Chatter:GetBool() and uvtargeting and next(ents.FindByClass("npc_uv*")) ~= nil then
						local units = ents.FindByClass("npc_uv*")
						local random_entry = math.random(#units)	
						local unit = units[random_entry]
						if !IsValid(unit.e) then return end
						UVChatterEnemyCrashed(unit)
					end
				elseif object.DecentVehicle then
					if Chatter:GetBool() and uvtargeting and next(ents.FindByClass("npc_uv*")) ~= nil then
						local units = ents.FindByClass("npc_uv*")
						local random_entry = math.random(#units)	
						local unit = units[random_entry]
						if !IsValid(unit.e) then return end
						UVChatterHitTraffic(unit)
					end
				end
			end
		end
		if object.UVRoadblock and !object.UVRoadblock.RoadBlockHit then --Crashed into roadblock
			object.UVRoadblock.RoadBlockHit = true
			if Chatter:GetBool() and uvtargeting and next(ents.FindByClass("npc_uv*")) ~= nil then
				local units = ents.FindByClass("npc_uv*")
				local random_entry = math.random(#units)	
				local unit = units[random_entry]
				if IsValid(unit.e) then 
					UVChatterRoadblockHit(unit) 
				end
			end
		end
	elseif car.UnitVehicle then --UNIT NPC
		local classmultiplier = 1
		local NPC = car.UnitVehicle
		if NPC:IsNPC() then
			if car.uvclasstospawnon == "npc_uvsupport" then
				classmultiplier = 2
			elseif car.uvclasstospawnon == "npc_uvpursuit" then
				classmultiplier = 3
			elseif car.uvclasstospawnon == "npc_uvinterceptor" then
				classmultiplier = 4
			elseif car.uvclasstospawnon == "npc_uvspecial" then
				classmultiplier = 5
			elseif car.uvclasstospawnon == "npc_uvcommander" then
				classmultiplier = 6
			end
			if (!uvtargeting and UVPassConVarFilter(object) or uvtargeting and object.UVWanted) then
				if car.rammed then
					car.rammed = nil
				end
				car.rammed = true
				timer.Simple(5, function() 
					if IsValid(NPC) then 
						car.rammed = nil
					end 
				end)
			end
			if object.UVWanted and !car.tagged then
				car.tagged = true
				uvtags = uvtags + 1
				if car.rhino and !car.rhinohit then
					car.rhinohit = true
					if Chatter:GetBool() and uvtargeting then
						UVSoundChatter(NPC, NPC.voice, "rhinohit", 1)
					end
				end
			end
			local ouroldvel = coldata.OurOldVelocity:Length()
			local ournewvel = coldata.OurNewVelocity:Length()
			local resultvel = ouroldvel
			if ouroldvel > ournewvel then --slowed
				resultvel = ouroldvel - ournewvel
			else --sped up
				resultvel = ournewvel - ouroldvel
			end
			if coldata.HitEntity:IsNPC() or coldata.HitEntity:IsPlayer() then return end
			local dot = coldata.OurOldVelocity:GetNormalized():Dot(coldata.HitNormal)
			dot = math.abs(dot) / 2
			local dmg = resultvel * dot
			if dmg >= 100 and object.UVWanted then
				if Chatter:GetBool() then
					if coldata.TheirOldVelocity:Length() > ouroldvel then
						UVChatterRammed(NPC)
						UVDeactivateKillSwitch(car)
					else
						UVChatterRammedEnemy(NPC)
					end
				end
				if !NPC.ramming then
					NPC.ramming = true
					NPC:SetHorn(true)
				end
				timer.Simple(math.random(1,5), function()
					if !NPC then return end
					if NPC.ramming then
						NPC.ramming = nil
						NPC:SetHorn(false)
						NPC:SetELSSiren(true)
					end
				end)
			end
		elseif !uvtargeting and !uvenemyescaped and !uvenemybusted and table.HasValue(uvpotentialsuspects, object) then
			uvtargeting = true
		end
	end
    if !object.UnitVehicle then --CALL HANDLER
        if !object:IsWorld() then
			local ctimeout = 1
            if object:IsVehicle() then --Hit And Run
                if CurTime() > uvpreinfractioncountcooldown + ctimeout then
                    uvpreinfractioncount = uvpreinfractioncount + 1
                    uvpreinfractioncountcooldown = CurTime()
                    if uvpreinfractioncount >= 10 then
                        if UVPassConVarFilter(car) then
                            UVCallInitiate(car, 3)
                        end
                    end
                end
            else --Damage to Property
                if CurTime() > uvpreinfractioncountcooldown + ctimeout then
                    uvpreinfractioncount = uvpreinfractioncount + 1
                    uvpreinfractioncountcooldown = CurTime()
                    if uvpreinfractioncount >= 10 then
                        if UVPassConVarFilter(car) then
                            UVCallInitiate(car, 2)
                        end
                    end
                end
            end
        end
    end
end)

hook.Add( "simfphysOnDestroyed", "UVExplosionSimfphys", function(car, gib) 
	if !car.UnitVehicle or car.wrecked then return end
	if car.UnitVehicle:IsNPC() then
		car.UnitVehicle:Wreck()
	else
		UVPlayerWreck(car)
	end
end)

hook.Add("OnEntityCreated", "UVCollisionJeep", function(vehicle)
	if !vehicle:GetClass() == "prop_vehicle_jeep" then return end
	vehicle:AddCallback("PhysicsCollide", function(car, coldata)
		if !IsValid(car) or car:GetClass() != "prop_vehicle_jeep" then return end
		local object = coldata.HitEntity
		local ouroldvel = coldata.OurOldVelocity:Length()
		local ournewvel = coldata.OurNewVelocity:Length()
		local resultvel = ouroldvel
		if ouroldvel > ournewvel then --slowed
			resultvel = ouroldvel - ournewvel
		else --sped up
			resultvel = ournewvel - ouroldvel
		end
		local dot = coldata.OurOldVelocity:GetNormalized():Dot(coldata.HitNormal)
		dot = math.abs(dot) / 2
		local dmg = resultvel * dot
		if car.UnitVehicle or (car.UVWanted and !AutoHealth:GetBool()) then --DAMAGE
			if !car.healthset then
				if car.uvclasstospawnon == "npc_uvcommander" or car.UVCommander then
					local health = car.uvlasthealth or UVUOneCommanderHealth:GetInt()
					car:SetMaxHealth(UVUOneCommanderHealth:GetInt())
					car:SetHealth(health)
				else
					local mass = vehicle:GetPhysicsObject():GetMass()
					vehicle:SetMaxHealth(mass)
					vehicle:SetHealth(mass)
				end
				car.healthset = true
			end
			if !vcmod_main and dmg >= 10 then
				car:SetHealth(car:Health()-dmg)
				local e = EffectData()
				e:SetOrigin(coldata.HitPos)
				if car:Health() <= (car:GetMaxHealth()/4) then
					util.Effect("cball_explode", e)
				else
					util.Effect("StunstickImpact", e)
				end
				if car:Health() <= car:GetMaxHealth()/4 and !car.jeepdamaged then 
					car.jeepdamaged = true
					if car:LookupAttachment("vehicle_engine") > 0 then
						ParticleEffectAttach("smoke_burning_engine_01", PATTACH_POINT_FOLLOW, car, car:LookupAttachment("vehicle_engine"))
					end
				end
			end
		end
		if car.esfon and object:IsVehicle() and !(object.UnitVehicle and car.UnitVehicle) then --ESF
			local enemyvehicle = object
			local enemycallsign
			if object.UnitVehicle then
				enemycallsign = object.UnitVehicle.callsign or "Unit "..object:EntIndex()
			else
				enemycallsign = object.racer or "Racer "..enemyvehicle:EntIndex()
			end
			local enemydriver = UVGetDriver(enemyvehicle)
			local power
			local damage
			if car.UnitVehicle then
				power = UVUnitPTESFPower:GetInt()
				damage = UVUnitPTESFDamage:GetFloat()
			else
				power = UVPTESFPower:GetInt()
				damage = UVPTESFDamage:GetFloat()
			end
			local carpos = car:WorldSpaceCenter()
			local enemyvehiclephys = enemyvehicle:GetPhysicsObject()
			local vectordifference = enemyvehicle:WorldSpaceCenter() - carpos
			local angle = vectordifference:Angle()
			local force = power * (1 - (vectordifference:Length()/1000))
			enemyvehiclephys:ApplyForceCenter(angle:Forward()*force)
			enemyvehicle.rammed = true
			timer.Simple(5, function()
				if IsValid(enemyvehicle) then
					enemyvehicle.rammed = nil
				end
			end)
			if enemydriver then
				if enemydriver:IsPlayer() then
					enemycallsign = enemydriver:GetName()
				end
			end
			if object.UnitVehicle or (object.UVWanted and !AutoHealth:GetBool()) or !(object.UnitVehicle and object.UVWanted) then
				if object.IsSimfphyscar then
					local MaxHealth = object:GetMaxHealth()
					local damage = MaxHealth*damage
					object:ApplyDamage( damage, DMG_GENERIC )
				elseif object.IsGlideVehicle then
					object:SetEngineHealth( object:GetEngineHealth() - damage )
    				object:UpdateHealthOutputs()
				elseif object:GetClass() == "prop_vehicle_jeep" then

				end
			end
			if isfunction(enemyvehicle.GetDriver) and IsValid(UVGetDriver(enemyvehicle)) and UVGetDriver(enemyvehicle):IsPlayer() then 
				UVGetDriver(enemyvehicle):PrintMessage( HUD_PRINTCENTER, "YOU HAVE BEEN HIT BY AN ESF!")
			end
			if isfunction(car.GetDriver) and IsValid(UVGetDriver(car)) and UVGetDriver(car):IsPlayer() then 
				UVGetDriver(car):PrintMessage( HUD_PRINTCENTER, "ESF HIT ON "..enemycallsign.."!")
			end
			local e = EffectData()
			e:SetEntity(enemyvehicle)
			util.Effect("entity_remove", e)
			enemyvehicle:EmitSound("gadgets/esf/impact.wav")
			car.uvesfhit = true
			UVDeactivateESF(car)
			if car.UnitVehicle then
				UVChatterKillswitchHit(car.UnitVehicle)
			end
		end
		if car.UVWanted then --SUSPECT
			if object:IsWorld() or object.DecentVehicle then --Crashed into world
				if dmg >= 100 and !uvenemyescaping and uvtargeting then
					if object:IsWorld() then
						if Chatter:GetBool() and uvtargeting and next(ents.FindByClass("npc_uv*")) ~= nil then
							local units = ents.FindByClass("npc_uv*")
							local random_entry = math.random(#units)	
							local unit = units[random_entry]
							if !IsValid(unit.e) then return end
							UVChatterEnemyCrashed(unit)
						end
					elseif object.DecentVehicle then
						if Chatter:GetBool() and uvtargeting and next(ents.FindByClass("npc_uv*")) ~= nil then
							local units = ents.FindByClass("npc_uv*")
							local random_entry = math.random(#units)	
							local unit = units[random_entry]
							if !IsValid(unit.e) then return end
							UVChatterHitTraffic(unit)
						end
					end
				end
			end
			if object.UVRoadblock and !object.UVRoadblock.RoadBlockHit then --Crashed into roadblock
				object.UVRoadblock.RoadBlockHit = true
				if Chatter:GetBool() and uvtargeting and next(ents.FindByClass("npc_uv*")) ~= nil then
					local units = ents.FindByClass("npc_uv*")
					local random_entry = math.random(#units)	
					local unit = units[random_entry]
					if IsValid(unit.e) then 
						UVChatterRoadblockHit(unit) 
					end
				end
			end
		elseif car.UnitVehicle then --UNIT NPC
			local classmultiplier = 1
			local NPC = car.UnitVehicle
			if NPC:IsNPC() then
				if car.uvclasstospawnon == "npc_uvsupport" then
					classmultiplier = 2
				elseif car.uvclasstospawnon == "npc_uvpursuit" then
					classmultiplier = 3
				elseif car.uvclasstospawnon == "npc_uvinterceptor" then
					classmultiplier = 4
				elseif car.uvclasstospawnon == "npc_uvspecial" then
					classmultiplier = 5
				elseif car.uvclasstospawnon == "npc_uvcommander" then
					classmultiplier = 6
				end
				if (!uvtargeting and UVPassConVarFilter(object) or uvtargeting and object.UVWanted) then
					if car.rammed then
						car.rammed = nil
					end
					car.rammed = true
					timer.Simple(5, function() 
						if IsValid(NPC) then 
							car.rammed = nil
						end 
					end)
				end
				if object.UVWanted and !car.tagged then
					car.tagged = true
					uvtags = uvtags + 1
					if car.rhino and !car.rhinohit then
						car.rhinohit = true
						if Chatter:GetBool() and uvtargeting then
							UVSoundChatter(NPC, NPC.voice, "rhinohit", 1)
						end
					end
				end
				if dmg >= 100 and object.UVWanted then
					if Chatter:GetBool() then
						if coldata.TheirOldVelocity:Length() > ouroldvel then
							UVChatterRammed(NPC)
							UVDeactivateKillSwitch(car)
						else
							UVChatterRammedEnemy(NPC)
						end
					end
					if !NPC.ramming then
						NPC.ramming = true
						NPC:SetHorn(true)
					end
					timer.Simple(math.random(1,5), function()
						if !NPC then return end
						if NPC.ramming then
							NPC.ramming = nil
							NPC:SetHorn(false)
							NPC:SetELSSiren(true)
						end
					end)
				end
			elseif !uvtargeting and !uvenemyescaped and !uvenemybusted and table.HasValue(uvpotentialsuspects, object) then
				uvtargeting = true
			end
		end
		if !object.UnitVehicle and !object:IsWorld() then --CALL HANDLER
			local ctimeout = 1
			if object:IsVehicle() then --Hit And Run
				if CurTime() > uvpreinfractioncountcooldown + ctimeout then
					uvpreinfractioncount = uvpreinfractioncount + 1
					uvpreinfractioncountcooldown = CurTime()
					if uvpreinfractioncount >= 10 then
						if UVPassConVarFilter(car) then
							UVCallInitiate(car, 3)
						end
					end
				end
			else --Damage to Property
				if CurTime() > uvpreinfractioncountcooldown + ctimeout then
					uvpreinfractioncount = uvpreinfractioncount + 1
					uvpreinfractioncountcooldown = CurTime()
					if uvpreinfractioncount >= 10 then
						if UVPassConVarFilter(car) then
							UVCallInitiate(car, 2)
						end
					end
				end
			end
		end
	end)
end)

function UVAddToWantedListVehicle(vehicle)
	if !vehicle.UVWanted then
		vehicle.UVWanted = vehicle
	end
	local driver = UVGetDriver(vehicle)
	if !table.HasValue(uvwantedtablevehicle, vehicle) then
		table.insert(uvwantedtablevehicle, vehicle)
		if driver:IsPlayer() and !table.HasValue(uvwantedtabledriver, driver) then
			UVAddToWantedListDriver(driver)
		end
		if driver:IsPlayer() then
			if driver:GetMaxHealth() == 100 then
				driver:SetHealth(vehicle:GetPhysicsObject():GetMass())
				driver:SetMaxHealth(vehicle:GetPhysicsObject():GetMass())
			end
		end
		if AutoHealth:GetBool() then
			if vcmod_main and vehicle:GetClass() == "prop_vehicle_jeep" then
				vehicle:VC_repairFull_Admin()
				if !vehicle:VC_hasGodMode() then
					vehicle:VC_setGodMode(true)
				end
			end
			if vehicle.IsSimfphyscar then
				vehicle.simfphysoldhealth = vehicle:GetMaxHealth()
				vehicle:SetBulletProofTires(true)
				vehicle:SetMaxHealth(math.huge)
				vehicle:SetCurHealth(math.huge)
				vehicle:SetOnFire( false )
				vehicle:SetOnSmoke( false )
				net.Start( "simfphys_lightsfixall" )
				net.WriteEntity( vehicle )
				net.Broadcast()

				net.Start( "uvrepairsimfphys" )
					net.WriteEntity( vehicle )
				net.Broadcast()
			end
			if vehicle.IsGlideVehicle then
				vehicle:SetChassisHealth(math.huge)
    			vehicle:SetEngineHealth(math.huge)
				vehicle:UpdateHealthOutputs()
				vehicle.FallOnCollision = nil
			end
		end
		vehicle:CallOnRemove( "UVWantedVehicleRemoved", function(ent)
			if table.HasValue(uvwantedtablevehicle, ent) then
				table.RemoveByValue(uvwantedtablevehicle, ent)
			end
		end)
	end
end

function UVAddToWantedListDriver(driver)
	if !IsValid(driver) or !driver:IsPlayer() then return end
	if table.HasValue(uvplayerunittableplayers, driver) then
		table.RemoveByValue(uvplayerunittableplayers, driver)
		net.Start( "UVHUDStopCopMode" )
		net.Send(driver)
	end
	if !table.HasValue(uvwantedtabledriver, driver) then
		table.insert(uvwantedtabledriver, driver)
		hook.Add( "PlayerDisconnected", "UVWantedDriverDisconnect", function(driver)
			if table.HasValue(uvwantedtabledriver, driver) then
				table.RemoveByValue(uvwantedtabledriver, driver)
			end
		end)
		net.Start( "UVHUDWanted" )
		net.Send(driver)
	end
end

function UVAddToPlayerUnitListVehicle(vehicle, ply)
	net.Start("UVHUDAddUV")
	net.WriteInt(vehicle:EntIndex(), 32)
	net.WriteString("unit")
	net.Broadcast()

	if !table.HasValue(uvplayerunittablevehicle, vehicle) then
		if vehicle.IsSimfphyscar then
			vehicle:SetBulletProofTires(true)
		end
		if vehicle:GetClass() == "prop_vehicle_jeep" then
			local mass = vehicle:GetPhysicsObject():GetMass()
			vehicle:SetMaxHealth(mass)
			vehicle:SetHealth(mass)
		end
		table.insert(uvplayerunittablevehicle, vehicle)
		vehicle:CallOnRemove( "UVPlayerUnitVehicleRemoved", function(ent)
			if table.HasValue(uvplayerunittablevehicle, ent) then
				table.RemoveByValue(uvplayerunittablevehicle, ent)
			end
			if table.HasValue(uvunitschasing, ent) then
				table.RemoveByValue(uvunitschasing, ent)
			end
		end)
	end
end

function UVChangeTactics(tactic)
	if !tactic or next(uvunitschasing) == nil then return end

	local AvailableUnits = {}
	for k, v in pairs(uvunitschasing) do
		if v.formationpoint then
			v.formationpoint = nil
		end
		table.insert(AvailableUnits, v)
	end

	if #uvunitschasing == 1 then --One unit remaining
		local FormationPoints = {
			Vector(0,-300,0), --Rear
		}
		for i = 1, #uvunitschasing do
			if next(FormationPoints) == nil or next(AvailableUnits) == nil then break end
			local unit = AvailableUnits[1]
			local point = FormationPoints[1]
			if unit.e then
				if unit.e.IsSimfphyscar then
					point:Rotate(Angle(0, (unit.e.VehicleData.LocalAngForward.y-90), 0))
				elseif unit.e.IsGlideVehicle then
					point:Rotate(Angle(0, (unit.e:GetForward().y-90), 0))
				end
			end
			unit.formationpoint = point
			table.RemoveByValue(AvailableUnits, unit)
			table.RemoveByValue(FormationPoints, point)
		end
	elseif tactic == 0 then --No formation
		return
	elseif tactic == 1 then --Box formation
		local FormationPoints = {
			Vector(0,300,0), --Front
			Vector(0,-300,0), --Rear
			Vector(-200,0,0), --Left
			Vector(200,0,0), --Right
			Vector(-200,300,0), --Left Front
			Vector(200,300,0),	--Right Front
			Vector(-200,-300,0), --Left Rear
			Vector(200,-300,0), --Right Rear
			Vector(0,-600,0), --Rear Rear
			Vector(0,-900,0), --Rear Rear Rear
		}
		for i = 1, #uvunitschasing do
			if next(FormationPoints) == nil or next(AvailableUnits) == nil then break end
			local unit = AvailableUnits[1]
			local point = FormationPoints[1]
			if unit.e then
				if unit.e.IsSimfphyscar then
					point:Rotate(Angle(0, (unit.e.VehicleData.LocalAngForward.y-90), 0))
				elseif unit.e.IsGlideVehicle then
					point:Rotate(Angle(0, (unit.e:GetForward().y-90), 0))
				end
			end
			unit.formationpoint = point
			table.RemoveByValue(AvailableUnits, unit)
			table.RemoveByValue(FormationPoints, point)
		end
	elseif tactic == 2 then --Rolling Roadblock formation
		local FormationPoints = {
			Vector(0,300,0), --Front
			Vector(0,-300,0), --Rear
			Vector(-200,300,0), --Left Front
			Vector(200,300,0), --Right Front
			Vector(-400,300,0), --Left Left Front
			Vector(400,300,0), --Right Right Front
			Vector(-200,-300,0), --Left Rear
			Vector(200,-300,0), --Right Rear
			Vector(-400,-300,0), --Left Left Rear
			Vector(400,-300,0), --Right Right Rear
		}
		for i = 1, #uvunitschasing do
			if next(FormationPoints) == nil or next(AvailableUnits) == nil then break end
			local unit = AvailableUnits[1]
			local point = FormationPoints[1]
			if unit.e then
				if unit.e.IsSimfphyscar then
					point:Rotate(Angle(0, (unit.e.VehicleData.LocalAngForward.y-90), 0))
				elseif unit.e.IsGlideVehicle then
					point:Rotate(Angle(0, (unit.e:GetForward().y-90), 0))
				end
			end
			unit.formationpoint = point
			table.RemoveByValue(AvailableUnits, unit)
			table.RemoveByValue(FormationPoints, point)
		end
	elseif tactic == 3 then --Spearhead formation
		local FormationPoints = {
			Vector(0,600,0), --Front Front
			Vector(0,-300,0), --Rear
			Vector(-200,300,0), --Left Front
			Vector(200,300,0), --Right Front
			Vector(-400,0,0), --Left Left
			Vector(400,0,0), --Right Right
			Vector(-200,-600,0), --Left Rear Rear
			Vector(200,-600,0), --Right Rear Rear
			Vector(-400,-900,0), --Left Left Rear Rear Rear
			Vector(400,-900,0), --Right Right Rear Rear Rear
		}
		for i = 1, #uvunitschasing do
			if next(FormationPoints) == nil or next(AvailableUnits) == nil then break end
			local unit = AvailableUnits[1]
			local point = FormationPoints[1]
			if unit.e then
				if unit.e.IsSimfphyscar then
					point:Rotate(Angle(0, (unit.e.VehicleData.LocalAngForward.y-90), 0))
				elseif unit.e.IsGlideVehicle then
					point:Rotate(Angle(0, (unit.e:GetForward().y-90), 0))
				end
			end
			unit.formationpoint = point
			table.RemoveByValue(AvailableUnits, unit)
			table.RemoveByValue(FormationPoints, point)
		end
	elseif tactic == 4 then --Box formation (right priority)
		local FormationPoints = {
			Vector(0,300,0), --Front
			Vector(0,-300,0), --Rear
			Vector(200,0,0), --Right
			Vector(-200,0,0), --Left
			Vector(200,300,0),	--Right Front
			Vector(-200,300,0), --Left Front
			Vector(200,-300,0), --Right Rear
			Vector(-200,-300,0), --Left Rear
			Vector(0,-600,0), --Rear Rear
			Vector(0,-900,0), --Rear Rear Rear
		}
		for i = 1, #uvunitschasing do
			if next(FormationPoints) == nil or next(AvailableUnits) == nil then break end
			local unit = AvailableUnits[1]
			local point = FormationPoints[1]
			if unit.e then
				if unit.e.IsSimfphyscar then
					point:Rotate(Angle(0, (unit.e.VehicleData.LocalAngForward.y-90), 0))
				elseif unit.e.IsGlideVehicle then
					point:Rotate(Angle(0, (unit.e:GetForward().y-90), 0))
				end
			end
			unit.formationpoint = point
			table.RemoveByValue(AvailableUnits, unit)
			table.RemoveByValue(FormationPoints, point)
		end
	elseif tactic == 5 then --Rolling Roadblock formation (right priority)
		local FormationPoints = {
			Vector(0,300,0), --Front
			Vector(0,-300,0), --Rear
			Vector(200,300,0), --Right Front
			Vector(-200,300,0), --Left Front
			Vector(400,300,0), --Right Right Front
			Vector(-400,300,0), --Left Left Front
			Vector(200,-300,0), --Right Rear
			Vector(-200,-300,0), --Left Rear
			Vector(400,-300,0), --Right Right Rear
			Vector(-400,-300,0), --Left Left Rear
		}
		for i = 1, #uvunitschasing do
			if next(FormationPoints) == nil or next(AvailableUnits) == nil then break end
			local unit = AvailableUnits[1]
			local point = FormationPoints[1]
			if unit.e then
				if unit.e.IsSimfphyscar then
					point:Rotate(Angle(0, (unit.e.VehicleData.LocalAngForward.y-90), 0))
				elseif unit.e.IsGlideVehicle then
					point:Rotate(Angle(0, (unit.e:GetForward().y-90), 0))
				end
			end
			unit.formationpoint = point
			table.RemoveByValue(AvailableUnits, unit)
			table.RemoveByValue(FormationPoints, point)
		end
	elseif tactic == 6 then --Spearhead formation (right priority)
		local FormationPoints = {
			Vector(0,600,0), --Front Front
			Vector(0,-300,0), --Rear
			Vector(200,300,0), --Right Front
			Vector(-200,300,0), --Left Front
			Vector(400,0,0), --Right Right
			Vector(-400,0,0), --Left Left
			Vector(200,-600,0), --Right Rear Rear
			Vector(-200,-600,0), --Left Rear Rear
			Vector(400,-900,0), --Right Right Rear Rear Rear
			Vector(-400,-900,0), --Left Left Rear Rear Rear
		}
		for i = 1, #uvunitschasing do
			if next(FormationPoints) == nil or next(AvailableUnits) == nil then break end
			local unit = AvailableUnits[1]
			local point = FormationPoints[1]
			if unit.e then
				if unit.e.IsSimfphyscar then
					point:Rotate(Angle(0, (unit.e.VehicleData.LocalAngForward.y-90), 0))
				elseif unit.e.IsGlideVehicle then
					point:Rotate(Angle(0, (unit.e:GetForward().y-90), 0))
				end
			end
			unit.formationpoint = point
			table.RemoveByValue(AvailableUnits, unit)
			table.RemoveByValue(FormationPoints, point)
		end
	end
end

function UVBustEnemy(self, enemy)
	if !IsValid(self) or !IsValid(enemy) or enemy.uvbusted then return end
	if !self.callsign then
		self.callsign = "the Unit Vehicles"
	end
	enemy.uvbusted = true
	enemy.uvbustingprogress = 0
	-- if UVRaceTable['Participants'] then
	-- 	if UVRaceTable['Participants'][enemy] then
	-- 		UVRaceTable['Participants'][enemy].Busted = true
	-- 	end
	-- end
	if enemy.RacerVehicle then
		enemy.RacerVehicle:Remove()
	end
	if enemy.DecentVehicle then
		enemy.DecentVehicle:Remove()
	end
	if enemy.MadVehicle then
		enemy.MadVehicle:Remove()
	end
	if enemy.UVWanted then
		enemy.UVWanted = nil
	end
	net.Start("UVHUDRemoveUV")
	net.WriteInt(enemy:EntIndex(), 32)
	net.Broadcast()
	if table.HasValue(uvwantedtablevehicle, enemy) then
		table.RemoveByValue(uvwantedtablevehicle, enemy)
	end
	if table.HasValue(uvpotentialsuspects, enemy) then
		table.RemoveByValue(uvpotentialsuspects, enemy)
	end
	local timeacknowledge = 5
	local enemydriver = self.edriver or UVGetDriver(enemy)

	if uvtargeting or self.UVAir then --Arrest
		if enemy:IsVehicle() then
			local e = UVGetVehicleMakeAndModel(enemy)
			if enemydriver:IsPlayer() then 
				print(enemydriver:GetName().." ("..uvbounty.." Bounty, "..uvwrecks.." Wreck(s), "..uvtags.." Tags(s)) has been busted by "..self.callsign.."!")
			else
				print("The "..e.." has been busted by "..self.callsign.."!")
			end
			if Chatter:GetBool() and IsValid(self) then
				if !self.UVAir then
					timeacknowledge = UVChatterArrest(self) or 5
				else
					timeacknowledge = UVChatterAirArrest(self) or 5
				end
			end
			if next(uvplayerunittableplayers) != nil then
				for _, uvdriver in pairs(uvplayerunittableplayers) do
					if !IsValid(uvdriver) or !IsValid(self) then continue end
					--if enemydriver:IsPlayer() then
						--uvdriver:PrintMessage( HUD_PRINTTALK, enemydriver:GetName().." has been busted by "..self.callsign.."!")
					--else
						--uvdriver:PrintMessage( HUD_PRINTTALK, "Racer "..enemy:EntIndex().." has been busted by "..self.callsign.."!")
					--end
					uvdriver:EmitSound("ui/pursuit/busted.wav", 0, 100, 0.5)
				end
			end
			if IsValid(enemydriver) and enemydriver:IsPlayer() then
				net.Start('UVBusted')
				net.WriteTable({
					['Racer'] = enemydriver:GetName(),
					['Cop'] = self.callsign
				})
				net.Broadcast()
				--chat.AddText(Color(0, 51, 102), "[Unit Vehicles]: ", Color(139, 0, 0), enemydriver:GetName(), Color(190, 190, 190), " has been ", Color(255,0,0), 'bu', Color(255, 255, 255), 'st', Color(0, 68, 255), 'ed', Color(190, 190, 190), ' by ', Color(54, 108, 255), self.callsign, Color(190, 190, 190), '!')
				--uvdriver:PrintMessage( HUD_PRINTTALK, enemydriver:GetName().." has been busted by "..self.callsign.."!")
			else
				net.Start('UVBusted')
				net.WriteTable({
					['Racer'] = enemy.racer or "Racer "..enemy:EntIndex(),
					['Cop'] = self.callsign
				})
				net.Broadcast()
				--uvdriver:PrintMessage( HUD_PRINTTALK, "Racer "..enemy:EntIndex().." has been busted by "..self.callsign.."!")
			end
			--chat.AddText(Color(0, 51, 102), "[Unit Vehicles]: ")
		end
		local v = EffectData()
		v:SetEntity(enemy)
		util.Effect("phys_freeze", v)
		local despawntime = 60
		table.insert(uvwreckedvehicles, vehicle)
		if enemy.IsGlideVehicle then
			local wreck = enemy
			timer.Simple(despawntime, function()
				if IsValid(wreck) then
					SafeRemoveEntity(wreck)
				end
			end)
			wreck:SetEngineHealth(0)
			wreck.UnflipForce = 0
			wreck.AngularDrag = vector_origin
			if wreck:GetVelocity():LengthSqr() > 250000 then
				UVGlideDetachWheels(wreck)
			end
		elseif enemy.IsSimfphyscar then
			local wreck = enemy
			timer.Simple(despawntime, function()
				if IsValid(wreck) then
					SafeRemoveEntity(wreck)
				end
			end)
			if enemy:GetVelocity():LengthSqr() > 250000 then
				for i = 1, #wreck.Wheels do
					local wheelmathchance = math.random(1,2)
					local Wheel = wreck.Wheels[math.random(1, #wreck.Wheels)]
					if wheelmathchance == 1 then
						constraint.RemoveAll(Wheel)
					end
				end
			end
			wreck:SetActive(false)
			--wreck:SetCurHealth(0) -- removed to prevent explosions
			wreck:SetLightsEnabled(false)
			wreck.emson = false
			wreck:SetEMSEnabled( false )
		elseif enemy:GetClass() == "prop_vehicle_jeep" then
			local wreck = enemy
			wreck:StartEngine(false)
			wreck:EmitSound( "vehicles/v8/vehicle_rollover"..math.random(1,2)..".wav" )
			wreck:AddCallback("PhysicsCollide", function(ent, coldata)
				local ouroldvel = coldata.OurOldVelocity:Length()
				local dot = coldata.OurOldVelocity:GetNormalized():Dot(coldata.HitNormal)
				dot = math.abs(dot) / 2
				local dmg = ouroldvel * dot
				if dmg < 10 then return end
				local e = EffectData()
				e:SetOrigin(coldata.HitPos)
				util.Effect("cball_explode", e)
			end)
			if wreck:LookupAttachment("vehicle_engine") > 0 then
				ParticleEffectAttach("smoke_burning_engine_01", PATTACH_POINT_FOLLOW, wreck, wreck:LookupAttachment("vehicle_engine"))
			end
			local e = EffectData()
			e:SetEntity(wreck)
			util.Effect("entity_remove", e)
			timer.Simple(despawntime, function()
				if IsValid(wreck) then
					wreck:Remove()
				end
			end)
		end
		timer.Simple(timeacknowledge, function()
			if Chatter:GetBool() and IsValid(self) then
				if !self.UVAir then
					UVChatterArrestAcknowledge(self)
				else
					UVChatterAirArrestAcknowledge(self)
				end
			end
		end)
		if enemydriver:IsPlayer() and !enemy.DecentVehicle then
			local driver = enemydriver
			local bustedtable = {}
			bustedtable["Unit"] = self.callsign
			bustedtable["Deploys"] = uvdeploys
			bustedtable["Roadblocks"] = uvroadblocksdodged
			bustedtable["Spikestrips"] = uvspikestripsdodged
			timer.Create('MakeArrest', 3, 1, function()
				net.Start( "UVHUDBustedDebrief" )
				net.WriteTable(bustedtable)
				net.Send(driver)
				driver:KillSilent()
				driver:SetNoDraw(true)
				driver:Spectate(OBS_MODE_DEATHCAM)
				driver:SpectateEntity(driver)
				driver:SetFrags(0)
			end)
			net.Start( "UVHUDEnemyBusted" )
			net.Send(driver)
			if table.HasValue(uvwantedtabledriver, enemydriver) then
				table.RemoveByValue(uvwantedtabledriver, enemydriver)
			end
			driver:EmitSound("ui/pursuit/busted.wav", 0, 100, 0.5)
		end
		self.chasing = nil
		if self.UVAir then
			self.disengaging = true
		end
		uvenemybusted = true
		self.aggressive = nil
		timer.Simple(timeacknowledge, function()
			if #uvwantedtablevehicle == 0 then
				uvtargeting = nil
			end
			uvenemybusted = nil
		end)
		self.displaybusting = nil
	else --Fine
		if enemy:IsVehicle() then
			local e = UVGetVehicleMakeAndModel(enemy)
			if enemydriver:IsPlayer() then 
				print(enemydriver:GetName().." ("..uvbounty.." Bounty, "..uvwrecks.." Wreck(s), "..uvtags.." Tags(s)) has been fined by "..self.callsign.."!")
			else
				print("The "..e.." has been fined by "..self.callsign.."!")
			end
			if Chatter:GetBool() and IsValid(self.v) then
				UVChatterFine(self)
			end 
		end
		timer.Simple(0.01, function()
			uvtargeting = nil
			self.chasing = nil
			if IsValid(self.v) then
				if self.v.UVPatrol then
					self.v:EmitSound( "npc/metropolice/vo/allrightyoucango.wav" )
				elseif self.v.UVSupport then
					self.v:EmitSound( "npc/metropolice/vo/clearno647no10-107.wav" )
				elseif self.v.UVPursuit then
					self.v:EmitSound( "npc/combine_soldier/vo/affirmativewegothimnow.wav" )
				elseif self.v.UVInterceptor then
					self.v:EmitSound( "npc/combine_soldier/vo/thatsitwrapitup.wav" )
				elseif self.v.UVSpecial then
					self.v:EmitSound( "npc/combine_soldier/vo/prison_soldier_bunker3.wav" )
				elseif self.v.UVCommander then
					self.v:EmitSound( "npc/combine_soldier/vo/off2.wav" )
				end
			end
			for k, v in pairs(ents.FindByClass("npc_uv*")) do
				v:ForgetEnemy()
			end
			net.Start( "UVHUDStopBusting" )
			net.Broadcast()
		end)
		if enemydriver:IsPlayer() then 
			local driver = enemydriver
			timer.Simple(0.1, function()
				driver:SetFrags(0)
				driver:PrintMessage( HUD_PRINTCENTER, "You have been fined! You have 10 seconds to drive away.")
			end)
			driver:EmitSound("ui/pursuit/fined.wav", 0, 100, 0.5)
		end
		uvenemybusted = true
		self.aggressive = nil
		timer.Simple(10, function()
			uvenemybusted = nil
			enemy.uvbusted = nil
		end)
	end
end

function UVDelayRoadblock()
	if UVRoadblockDelayed then return end
	UVRoadblockDelayed = true
	timer.Simple(0.5, function()
		UVRoadblockDelayed = false
	end)
end

function UVColorName(ent)

	if !IsValid(ent) then return end

	if ent:GetSkin() != 0 then
		return "a custom"
	end

	local color = ent:GetColor()
	local rgba = color:ToTable()
	local alpha = table.remove(rgba)

	local rgbtable = {
		{255, 0, 0},
		{255, 0, 97},
		{255, 0, 191},
		{255, 0, 255},
		{220, 0, 255},
		{127, 0, 255},
		{29, 0, 255},
		{0, 63, 255},
		{0, 161, 255},
		{0, 255, 255},
		{0, 255, 157},
		{0, 255, 63},
		{33, 255, 0},
		{127, 255, 0},
		{225, 255, 0},
		{255, 255, 0},
		{255, 191, 0},
		{255, 170, 0},
		{255, 93, 0},
		{127, 0, 0},
		{127, 0, 95},
		{63, 0, 127},
		{0, 31, 127},
		{0, 127, 127},
		{0, 127, 31},
		{63, 127, 0},
		{127, 95, 0},
		{127, 63, 63},
		{127, 63, 111},
		{95, 63, 127},
		{63, 79, 127},
		{63, 127, 127},
		{63, 127, 79},
		{95, 127, 63},
		{127, 111, 63},
		{255, 127, 127},
		{255, 127, 223},
		{191, 127, 255},
		{127, 159, 255},
		{127, 255, 255},
		{0, 255, 255},
		{127, 255, 159},
		{191, 255, 127},
		{255, 223, 127},
		{255, 255, 255},
		{218, 218, 218},
		{182, 182, 182},
		{145, 145, 145},
		{109, 109, 109},
		{72, 72, 72},
		{36, 36, 36},
		{0, 0, 0},
	}

	local colornametable = {
		"a red",
		"a razzmatazz",
		"a hot magenta",
		"a magenta",
		"a psychedelic purple",
		"an electric indigo",
		"a blue",
		"a blue",
		"a deep sky blue",
		"an aqua",
		"a medium spring green",
		"a free speech green",
		"a harlequin",
		"a chartreuse",
		"a chartreuse yellow",
		"a yellow",
		"an amber",
		"an orange",
		"a safety orange",
		"a maroon",
		"an eggplant",
		"an indigo",
		"a navy",
		"a teal",
		"a green",
		"a green",
		"an olive",
		"a stiletto",
		"a cadillac",
		"a gigas",
		"a jacksons purple",
		"a ming",
		"an amazon",
		"a dingley",
		"a yellow metal",
		"a vivid tangerine",
		"a neon pink",
		"a heliotrope",
		"a maya blue",
		"an electric blue",
		"a cyan",
		"a mint green",
		"a mint green",
		"a salomie",
		"a white",
		"a gainsboro",
		"a silver",
		"a suva gray",
		"a dim gray",
		"a charcoal",
		"a nero",
		"a black",
	}

	local index = 0

	for k, v in pairs(rgbtable) do
		index = index + 1
		if rgba[1] == v[1] and rgba[2] == v[2] and rgba[3] == v[3] then
			return colornametable[index]
		end
	end

	return "a"

end

function UVCheckIfBeingBusted(enemy)

	local enemydriver = UVGetDriver(enemy)
	local btimeout = BustedTimer:GetFloat()
	local closestunit
	local closestdistancetounit

	local units = ents.FindByClass("npc_uv*")
	local airunits = ents.FindByClass("uvair")
	local playerunits = uvplayerunittablevehicle
	table.Add( units, airunits )
	table.Add( units, playerunits )

	local r = math.huge
	local closestdistancetounit, closestunit = r^2
	for i, w in pairs(units) do
		local enemypos = enemy:WorldSpaceCenter()
		local distance = enemypos:DistToSqr(w:WorldSpaceCenter())
		if distance < closestdistancetounit then
			-- check the unit is uvair, then do not count it
			if !UVUHelicopterBusting:GetBool() and w:GetClass() == 'uvair' then continue end
			closestdistancetounit, closestunit = distance, w
		end
	end

	if !closestunit then closestunit = enemy end
	
	if !enemy.uvbusted and btimeout and btimeout > 0 and enemy:GetVelocity():LengthSqr() < uvbustspeed and !uvenemyescaping and next(uvunitschasing) != nil and
	(closestdistancetounit < 250000 or closestunit.CloseToTarget) and 
	(IsValid(closestunit.e) or (isfunction(closestunit.GetTarget)) and IsValid(closestunit:GetTarget())) then
		if !enemy.UVHUDBusting and !enemy.UVHUDBustingDelayed then
			enemy.UVHUDBusting = true
			enemy.UVHUDBustingDelayed = true
			timer.Simple(1, function()
				enemy.UVHUDBustingDelayed = nil
			end)
			if Chatter:GetBool() and IsValid(closestunit) and not uvcalm then
				local randomno = math.random(1,2)
				local airunits = ents.FindByClass("uvair")
				if next(airunits) ~= nil and randomno == 1 then
					local random_entry = math.random(#airunits)	
					local unit = airunits[random_entry]
					if unit:GetTarget() == enemy then
						UVChatterAirBusting(unit)
					else
						UVChatterBusting(closestunit)
					end
				else
					UVChatterBusting(closestunit)
				end
			end
			if IsValid(enemydriver) then
				enemydriver:EmitSound("ui/pursuit/busting_start.wav", 0, 100, 0.5)
			end
			net.Start( "UVHUDCopModeBusting" )
			net.WriteEntity(enemy)
			net.Broadcast()
		end
		if !enemy.uvbustingincrease then
			enemy.uvbustingincrease = true
			enemy.randomptuse = math.random(1, BustedTimer:GetFloat() * .7)
			enemy.uvbustinglastprogress = CurTime()
			enemy.uvbustinglastprogress2 = enemy.uvbustingprogress
		end
		enemy.uvbustingprogress = enemy.uvbustinglastprogress2 + (CurTime() - enemy.uvbustinglastprogress)
		if enemy.uvbustingprogress >= (btimeout-1) and !enemy.nearbust then
			enemy.nearbust = true
			-- if enemy.PursuitTech == "Shockwave" then --SHOCKWAVE
			-- 	if !enemy.shockwavecooldown then
			-- 		UVAIRacerDeployWeapon(enemy)
			-- 	end
			-- end

			if Chatter:GetBool() and IsValid(closestunit) and uvtargeting then
				local randomno = math.random(1,2)
				local airunits = ents.FindByClass("uvair")
				if next(airunits) ~= nil and randomno == 1 then
					local random_entry = math.random(#airunits)	
					local unit = airunits[random_entry]
					UVSoundChatter(unit, unit.voice, "airarrest", 2)
				else
					UVSoundChatter(closestunit, closestunit.voice, "arrest", 2)
				end
			end
		end

		if enemy.PursuitTech and !(enemy:GetDriver() and enemy:GetDriver():IsPlayer()) and enemy.randomptuse < enemy.uvbustingprogress then
			for k, v in pairs(enemy.PursuitTech) do
				if v.Tech == 'Shockwave' then
					UVDeployWeapon( enemy, k )
				end
			end
		end
	else
		if enemy.UVHUDBusting then
			if enemy.uvbustingincrease then
				enemy.uvbustingincrease = false
				enemy.uvbustinglastprogress = CurTime()
				enemy.uvbustinglastprogress2 = enemy.uvbustingprogress
			end
			if (enemy.uvbustingprogress <= 0 or enemy.uvbusted) and !enemy.UVHUDBustingDelayed then
				enemy.UVHUDBusting = nil
				enemy.UVHUDBustingDelayed = true
				timer.Simple(1, function()
					enemy.UVHUDBustingDelayed = nil
				end)
				net.Start( "UVHUDStopBusting" )
				net.Broadcast()
				if !uvtargeting and !enemy.uvbusted then
					uvtargeting = true
					if next(ents.FindByClass("npc_uv*")) ~= nil and Chatter:GetBool() then
						local units = ents.FindByClass("npc_uv*")
						local random_entry = math.random(#units)	
						local unit = units[random_entry]
						if !IsValid(unit.e) then return end
						UVChatterPursuitStartRanAway(unit)
					end
				end
				if Chatter:GetBool() and IsValid(closestunit) and not uvcalm then
					local randomno = math.random(1,2)
					local airunits = ents.FindByClass("uvair")
					if next(airunits) ~= nil and randomno == 1 then
						local random_entry = math.random(#airunits)	
						local unit = airunits[random_entry]
						if unit:GetTarget() == enemy then
							UVChatterAirBustEvaded(unit)
						else
							UVChatterBustEvaded(closestunit)
						end
					else
						UVChatterBustEvaded(closestunit)
					end
				end
				if IsValid(enemydriver) then
					enemydriver:EmitSound("ui/pursuit/busting_whoosh_high.wav", 0, 100, 0.5)
				end
				if enemy.nearbust then
					enemy.nearbust = nil
				end
				net.Start( "UVHUDStopCopModeBusting" )
				net.WriteEntity(enemy)
				net.Broadcast()
			end
			enemy.uvbustingprogress = enemy.uvbustinglastprogress2 - (CurTime() - enemy.uvbustinglastprogress)
		end 
		enemy.UVStartBustingEnemy = false
	end

	--Display busting
	if enemy.UVHUDBusting then
		net.Start( "UVHUDBusting" )
		net.WriteString(enemy.uvbustingprogress)
		net.Send(enemydriver)
		if btimeout and btimeout > 0 and !enemy.uvbusted and enemy.uvbustingprogress >= btimeout then --Bust conditions.
			UVBustEnemy(closestunit, enemy)
		end
		uvlosing = CurTime()
	else
		uvbusting = CurTime()
		enemy.uvbustingprogress = 0
		enemy.uvbustinglastprogress = CurTime()
		enemy.uvbustinglastprogress2 = enemy.uvbustingprogress
	end

	net.Start('UVHUDUpdateBusting')
	net.WriteEntity(enemy)
	net.WriteFloat(enemy.uvbustingprogress)
	net.Broadcast()


	if UVCheckIfWrecked(enemy) or !enemy.uvbusted and enemy:WaterLevel() > 2 or IsValid(UVGetDriver(enemy)) and UVGetDriver(enemy):Health() <= 0 then --Bust conditions.
		UVBustEnemy(closestunit, enemy)
	end

	local enemyph = enemy:GetPhysicsObject()
	if !enemyph then return end

	--Stunt jump
	if !uvenemyescaping and uvtargeting then
		if !enemy.UVStuntJump then
			local onground = util.QuickTrace(enemy:WorldSpaceCenter(), -vector_up * 500, {enemy})
			if !onground.Hit then
				enemy.UVStuntJump = true
				timer.Simple(10, function()
					enemy.UVStuntJump = nil
				end)
				local randomno = math.random(1,2)
				local airunits = ents.FindByClass("uvair")
				if next(airunits) ~= nil and randomno == 1 then
					local random_entry = math.random(#airunits)	
					local unit = airunits[random_entry]
					UVChatterStuntJump(unit)
				else
					UVChatterStuntJump(closestunit)
				end
			end
		end
	
		--Stunt roll
		if !enemy.UVStuntRoll then
			if enemyph:GetAngles().z > 90 and enemyph:GetAngles().z < 270 and enemy:GetVelocity():LengthSqr() < 10000 then
				enemy.UVStuntRoll = true
				timer.Simple(10, function()
					enemy.UVStuntRoll = nil
				end)
				local randomno = math.random(1,2)
				local airunits = ents.FindByClass("uvair")
				if next(airunits) ~= nil and randomno == 1 then
					local random_entry = math.random(#airunits)	
					local unit = airunits[random_entry]
					UVChatterStuntRoll(unit)
				else
					UVChatterStuntRoll(closestunit)
				end
			end
		end
		
		--Stunt roll
		if !enemy.UVStuntSpin then
			if enemyph:GetAngleVelocity().y > 180 then
				enemy.UVStuntSpin = true
				timer.Simple(10, function()
					enemy.UVStuntSpin = nil
				end)
				local randomno = math.random(1,2)
				local airunits = ents.FindByClass("uvair")
				if next(airunits) ~= nil and randomno == 1 then
					local random_entry = math.random(#airunits)	
					local unit = airunits[random_entry]
					UVChatterStuntSpin(unit)
				else
					UVChatterStuntSpin(closestunit)
				end
			end
		end
	end

end

function UVCheckIfWrecked(enemy)
	if !IsValid(enemy) then return end //or AutoHealth:GetBool()
	if enemy:IsFlagSet(FL_DISSOLVING) then return true end
	if enemy.IsScar then
		return enemy:IsDestroyed()
	elseif enemy.IsSimfphyscar then
		return enemy:GetCurHealth() <= 0 or enemy:OnFire() or enemy.destroyed or enemy:WaterLevel() > 2
	elseif enemy.IsGlideVehicle then
		return enemy:GetEngineHealth() <= 0 or enemy:GetIsEngineOnFire()
	elseif vcmod_main and isfunction(enemy.VC_GetHealth) then
		local health = enemy:VC_GetHealth(false)
		return (isnumber(health) and health <= 0) or enemy:WaterLevel() > 2
	elseif enemy:GetClass() == "prop_vehicle_jeep" then
		local health = enemy:Health()
		return health < 0 or enemy:WaterLevel() > 2 --Unless set, health is 0
	end
end

function UVCheckIfHiding(enemy)
	if enemy:GetVelocity():LengthSqr() < 10000 then
		if !uvhiding then
			uvhiding = true
		end
	else
		if uvhiding then
			uvhiding = nil
		end
	end
end

function UVVisualOnTarget(unit, target)
	if !unit or !target then
		return
	end
	local tr = util.TraceLine({start = unit:WorldSpaceCenter(), endpos = target:WorldSpaceCenter(), mask = MASK_OPAQUE, filter = {unit, target, uvenemylocation}}).Fraction==1
	return tobool(tr)
end

function UVGetDir(v1, v2)
	return (v2 - v1):GetNormalized()
end

function UVGetAng(A, B)
	return A:GetNormalized():Dot(B:GetNormalized())
end

function UVGetAng3(A, B, C)
	return UVGetAng(B - A, C - B)
end

function UVGetVehicleMakeAndModel(vehicle)
	if !IsValid(vehicle) then return end
	if vehicle.IsSimfphyscar then
		local c = vehicle:GetSpawn_List()
		if ( !list.Get( "simfphys_vehicles" )[ c ] ) then return "Vehicle" end
		local t = list.Get( "simfphys_vehicles" )[ c ]
		local v = t.Name
		return v or "Vehicle"
	elseif vehicle.IsGlideVehicle then
		return vehicle.PrintName or "Vehicle"
	elseif vehicle:GetClass() == "prop_vehicle_jeep" then
		local c = vehicle:GetVehicleClass()
		if ( !list.Get( "Vehicles" )[ c ] ) then return "Vehicle" end
		local t = list.Get( "Vehicles" )[ c ]
		local v = t.Name
		return v or "Vehicle"
	end
	return "Vehicle"
end

function UVDeployRoadblock(self)
	if UVAutoLoadRoadblock() then
		if Chatter:GetBool() and IsValid(self.v) then
			UVChatterRoadblockDeployed(self)
		end
	end
end

function UVPlayerIsWrecked(vehicle)
	if !vehicle then return end
	if vehicle:IsFlagSet(FL_DISSOLVING) then return true end
	if vehicle.IsScar then
		return vehicle:IsDestroyed()
	elseif vehicle.IsSimfphyscar then
		return vehicle:GetCurHealth() <= 0 or vehicle:OnFire() or vehicle.destroyed
	elseif vehicle.IsGlideVehicle then
		return vehicle:GetEngineHealth() <= 0 or vehicle:GetIsEngineOnFire()
	elseif isfunction(vehicle.VC_GetHealth) then
		local health = vehicle:VC_GetHealth(false)
		return isnumber(health) and health <= 0
	end
end

function UVPlayerWreck(vehicle)
	if IsValid(vehicle) and vehicle.wrecked then return end
	if table.HasValue(uvcommanders, vehicle) then
		uvcommanders = {}
	end
	if table.HasValue(uvplayerunittablevehicle, vehicle) then
		table.RemoveByValue(uvplayerunittablevehicle, vehicle)
	end
	vehicle.mass = math.Round(vehicle:GetPhysicsObject():GetMass())
	if !vehicle.playerbounty then
		vehicle.playerbounty = 500
	end
	if !timer.Exists("uvcombotime") then
		timer.Create("uvcombotime", 5, 1, function() 
			uvcombobounty = 1 
			timer.Remove("uvcombotime")
		end)
	else
		timer.Remove("uvcombotime")
		timer.Create("uvcombotime", 5, 1, function() 
			if next(ents.FindByClass("npc_uv*")) ~= nil and Chatter:GetBool() and uvcombobounty >= 3 then
				local units = ents.FindByClass("npc_uv*")
				local random_entry = math.random(#units)	
				local unit = units[random_entry]
				UVChatterMultipleUnitsDown(unit)
			end
			uvcombobounty = 1
			timer.Remove("uvcombotime")
		end)
	end
	vehicle.wrecked = true
	local despawntime = 60
	table.insert(uvwreckedvehicles, vehicle)
	local name = vehicle.callsign or UVGetDriver(vehicle):GetName() or "Player"
	local bountyplus = (vehicle.playerbounty)*(uvcombobounty)
	local bounty = string.Comma(bountyplus)
	if IsValid(vehicle.e) and isfunction(vehicle.e.GetDriver) and IsValid(UVGetDriver(vehicle.e)) and UVGetDriver(vehicle.e):IsPlayer() then 
		UVGetDriver(vehicle.e):PrintMessage( HUD_PRINTCENTER, name.." ☠ Combo Bounty x"..uvcombobounty..": "..bounty)
	end
	uvwrecks = uvwrecks + 1
	local driver = UVGetDriver(vehicle)
	if driver:IsPlayer() then
		local bustedtable = {}
		net.Start( "UVHUDWreckedDebrief" )
		net.Send(driver)
		driver:KillSilent()
		driver:SetNoDraw(true)
		driver:Spectate(OBS_MODE_DEATHCAM)
		driver:SpectateEntity(driver)
	end
	if vehicle.IsGlideVehicle then
		local wreck = vehicle
		timer.Simple(despawntime, function()
			if IsValid(wreck) then
				SafeRemoveEntity(wreck)
			end
		end)
		wreck:SetEngineHealth(0)
		wreck:UpdateHealthOutputs()
		wreck.UnflipForce = 0
		wreck.AngularDrag = vector_origin
		if wreck:GetVelocity():LengthSqr() > 250000 then
			UVGlideDetachWheels(wreck)
		end
	elseif vehicle.IsSimfphyscar then
		local wreck = vehicle
		timer.Simple(despawntime, function()
			if IsValid(wreck) then
				SafeRemoveEntity(wreck)
			end
		end)
		if vehicle:GetVelocity():LengthSqr() > 250000 then
			for i = 1, #wreck.Wheels do
				local wheelmathchance = math.random(1,2)
				local Wheel = wreck.Wheels[math.random(1, #wreck.Wheels)]
				if wheelmathchance == 1 then
					constraint.RemoveAll(Wheel)
				end
			end
		end
		wreck:SetActive(false)
		wreck:SetCurHealth(0)
		wreck:SetLightsEnabled(false)
		wreck.emson = false
		wreck:SetEMSEnabled( false )
	elseif vehicle:GetClass() == "prop_vehicle_jeep" then
		local wreck = vehicle
		wreck:EmitSound( "vehicles/v8/vehicle_rollover"..math.random(1,2)..".wav" )
		wreck:AddCallback("PhysicsCollide", function(ent, coldata)
			local ouroldvel = coldata.OurOldVelocity:Length()
			local dot = coldata.OurOldVelocity:GetNormalized():Dot(coldata.HitNormal)
			dot = math.abs(dot) / 2
			local dmg = ouroldvel * dot
			if dmg < 10 then return end
			local e = EffectData()
			e:SetOrigin(coldata.HitPos)
			util.Effect("cball_explode", e)
		end)
		if wreck:LookupAttachment("vehicle_engine") > 0 then
			ParticleEffectAttach("smoke_burning_engine_01", PATTACH_POINT_FOLLOW, wreck, wreck:LookupAttachment("vehicle_engine"))
		end
		local e = EffectData()
		e:SetEntity(wreck)
		util.Effect("entity_remove", e)
		timer.Simple(despawntime, function()
			if IsValid(wreck) then
				wreck:Remove()
			end
		end)
	end
	if vehicle:IsVehicle() then
		uvbounty = uvbounty+bountyplus
	end
	uvcombobounty = uvcombobounty + 1
end

function UVGetVehicle(driver)
	if !IsValid(driver) then return false end

	local seat = driver:GetVehicle()
	if !IsValid(seat) then return false end

	if seat.IsSimfphyscar or seat:GetClass() == "prop_vehicle_jeep" then
		return seat
	else
		return seat:GetParent()
	end

end

function UVGetDriver(vehicle)
	if !IsValid(vehicle) then return false end

	if vehicle.IsSimfphyscar or vehicle:GetClass() == "prop_vehicle_jeep" then
		return vehicle:GetDriver()
	elseif vehicle.IsGlideVehicle then
		local seat = vehicle.seats[1]

		if IsValid( seat ) then
            return seat:GetDriver()
        end
	end

	return false
end

function UVNavigateDVWaypoint(self, vectors)

	if uvenemyescaping then
		vectors = dvd.Waypoints[math.random(#dvd.Waypoints)].Target
	end

	local FromSelfToEnemy = dvd.GetRouteVector(self.v:WorldSpaceCenter(), vectors)
	local FromEnemyToSelf = dvd.GetRouteVector(vectors, self.v:WorldSpaceCenter())

	if !FromSelfToEnemy or !FromEnemyToSelf then
		self.NavigateBlind = true
		return --Unable to get route
	end

	if #FromEnemyToSelf >= #FromSelfToEnemy then --Get the shortest route
		for k, v in pairs(FromSelfToEnemy) do
			table.insert(self.tableroutetoenemy, v["Target"]+Vector(0,0,50))
		end
		return self.tableroutetoenemy
	else
		local FromEnemyToSelfReversed = table.Reverse(FromEnemyToSelf)
		for k, v in pairs(FromEnemyToSelfReversed) do
			table.insert(self.tableroutetoenemy, v["Target"]+Vector(0,0,50))
		end
		return self.tableroutetoenemy
	end
end

function UVNavigateNavmesh(self, vectors)
	local CNavAreaFromSelfToEnemy = UVRequestVectorsnavmesh(self.v:WorldSpaceCenter(), vectors, self.v.width)

	if istable(CNavAreaFromSelfToEnemy) then --Get the route
		local closestpoint = self.v:WorldSpaceCenter()
		for k, v in pairs(CNavAreaFromSelfToEnemy) do
			table.insert(self.tableroutetoenemy, v:GetClosestPointOnArea(closestpoint))
			closestpoint = v:GetCenter()
		end
		return self.tableroutetoenemy
	else
		self.NavigateBlind = true
		return --Unable to get route
	end
end

function UVGlideDetachWheels(vehicle)
	timer.Simple(0, function()
		if !IsValid(vehicle) or !vehicle.wheels then return end

		for i = 1, #vehicle.wheels do
			local wheelmathchance = math.random(1,2)
			local wheel = vehicle.wheels[math.random(1, #vehicle.wheels)]

			if wheelmathchance == 1 then
				local wheelphys = vehicle:GetPhysicsObject() --Wheels don't have a physics object

				local wheelmodel = wheel:GetModel()
				local wheelpos = wheel:GetPos()
				local wheelang = wheel:GetAngles()
				local wheelcolor = wheel:GetColor()
				local wheelmat = wheel:GetMaterial()

				local wheelvelocity = wheelphys:GetVelocity()
				local wheelangvel = wheelphys:GetAngleVelocity()

				table.RemoveByValue(vehicle.wheels, wheel)
				wheel:Remove()

				local wreckedwheel = ents.Create("prop_physics")
				wreckedwheel:SetModel(wheelmodel)
				wreckedwheel:SetPos(wheelpos)
				wreckedwheel:SetAngles(wheelang)
				wreckedwheel:SetColor(wheelcolor)
				wreckedwheel:SetMaterial(wheelmat)
				wreckedwheel:SetVelocity(wheelvelocity)
				wreckedwheel:Spawn()

				local wreckedwheelphys = wreckedwheel:GetPhysicsObject()
				wreckedwheelphys:SetVelocity(wheelvelocity)
				wreckedwheelphys:SetAngleVelocity(wheelangvel)

				timer.Simple(60, function()
					if IsValid(wreckedwheel) then
						wreckedwheel:Remove()
					end
				end)

				continue

			else
				
				break

			end

		end

	end)
	
end