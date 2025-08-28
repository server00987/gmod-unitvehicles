local dvd = DecentVehicleDestination

--SIMFPHYS ONLY--

local function ValidateModel( model )
	local v_list = list.Get( "simfphys_vehicles" )
	for listname, _ in pairs( v_list ) do
		if v_list[listname].Members.CustomWheels then
			local FrontWheel = v_list[listname].Members.CustomWheelModel
			local RearWheel = v_list[listname].Members.CustomWheelModel_R
			
			if FrontWheel then 
				FrontWheel = string.lower( FrontWheel )
			end
			
			if RearWheel then 
				RearWheel = string.lower( RearWheel )
			end
			
			if model == FrontWheel or model == RearWheel then
				return true
			end
		end
	end
	
	local list = list.Get( "simfphys_Wheels" )[model]
	
	if list then 
		return true
	end
	
	return false
end

local function GetRight( ent, index, WheelPos )
	local Steer = ent:GetTransformedDirection()
	
	local Right = ent.Right
	
	if WheelPos.IsFrontWheel then
		Right = (IsValid( ent.SteerMaster ) and Steer.Right or ent.Right) * (WheelPos.IsRightWheel and 1 or -1)
	else
		Right = (IsValid( ent.SteerMaster ) and Steer.Right2 or ent.Right) * (WheelPos.IsRightWheel and 1 or -1)
	end
	
	return Right
end

local function SetWheelOffset( ent, offset_front, offset_rear )
	if not IsValid( ent ) then return end
	
	ent.WheelTool_Foffset = offset_front
	ent.WheelTool_Roffset = offset_rear
	
	if not istable( ent.Wheels ) or not istable( ent.GhostWheels ) then return end
	
	for i = 1, table.Count( ent.GhostWheels ) do
		local Wheel = ent.Wheels[ i ]
		local WheelModel = ent.GhostWheels[i]
		local WheelPos = ent:LogicWheelPos( i )
		
		if IsValid( Wheel ) and IsValid( WheelModel ) then
			local Pos = Wheel:GetPos()
			local Right = GetRight( ent, i, WheelPos )
			local offset = WheelPos.IsFrontWheel and offset_front or offset_rear
			
			WheelModel:SetParent( nil )
			
			local physObj = WheelModel:GetPhysicsObject()
			if IsValid( physObj ) then
				physObj:EnableMotion( false )
			end
			
			WheelModel:SetPos( Pos + Right * offset )
			WheelModel:SetParent( Wheel )
		end
	end
end

local function ApplyWheel(ent, data)
	ent.CustomWheelAngleOffset = data[2]
	ent.CustomWheelAngleOffset_R = data[4]
	
	timer.Simple( 0.05, function()
		if not IsValid( ent ) then return end
		for i = 1, table.Count( ent.GhostWheels ) do
			local Wheel = ent.GhostWheels[i]
			
			if IsValid( Wheel ) then
				local isfrontwheel = (i == 1 or i == 2)
				local swap_y = (i == 2 or i == 4 or i == 6)
				
				local angleoffset = isfrontwheel and ent.CustomWheelAngleOffset or ent.CustomWheelAngleOffset_R
				
				local model = isfrontwheel and data[1] or data[3]
				
				local fAng = ent:LocalToWorldAngles( ent.VehicleData.LocalAngForward )
				local rAng = ent:LocalToWorldAngles( ent.VehicleData.LocalAngRight )
				
				local Forward = fAng:Forward() 
				local Right = swap_y and -rAng:Forward() or rAng:Forward()
				local Up = ent:GetUp()
				
				local Camber = data[5] or 0
				
				local ghostAng = Right:Angle()
				local mirAng = swap_y and 1 or -1
				ghostAng:RotateAroundAxis(Forward,angleoffset.p * mirAng)
				ghostAng:RotateAroundAxis(Right,angleoffset.r * mirAng)
				ghostAng:RotateAroundAxis(Up,-angleoffset.y)
				
				ghostAng:RotateAroundAxis(Forward, Camber * mirAng)
				
				Wheel:SetModelScale( 1 )
				Wheel:SetModel( model )
				Wheel:SetAngles( ghostAng )
				
				timer.Simple( 0.05, function()
					if not IsValid(Wheel) or not IsValid( ent ) then return end
					local wheelsize = Wheel:OBBMaxs() - Wheel:OBBMins()
					local radius = isfrontwheel and ent.FrontWheelRadius or ent.RearWheelRadius
					local size = (radius * 2) / math.max(wheelsize.x,wheelsize.y,wheelsize.z)
					
					Wheel:SetModelScale( size )
				end)
			end
		end
	end)
end

local function GetAngleFromSpawnlist( model )
	if not model then PrintMessage( HUD_PRINTTALK, "invalid model") return Angle(0,0,0) end
	
	model = string.lower( model )
	
	local v_list = list.Get( "simfphys_vehicles" )
	for listname, _ in pairs( v_list ) do
		if v_list[listname].Members.CustomWheels then
			local FrontWheel = v_list[listname].Members.CustomWheelModel
			local RearWheel = v_list[listname].Members.CustomWheelModel_R
			
			if FrontWheel then 
				FrontWheel = string.lower( FrontWheel )
			end
			
			if RearWheel then 
				RearWheel = string.lower( RearWheel )
			end
			
			if model == FrontWheel or model == RearWheel then
				local Angleoffset = v_list[listname].Members.CustomWheelAngleOffset
				if (Angleoffset) then
					return Angleoffset
				end
			end
		end
	end
	
	local list = list.Get( "simfphys_Wheels" )[model]
	local output = list and list.Angle or Angle(0,0,0)
	
	return output
end

--(Player, boolean)
function UVAutoSpawn(ply, rhinoattack, helicopter, playercontrolled, commanderrespawn, posspecified, angles, disperse)
	
	if playercontrolled then
		if not ply then
			ply = Entity(1)
		end
	end
	
	local uvnextclasstospawn
	local enemylocation
	local suspect
	local suspectvelocity = Vector(0,0,0)
	-- local suspect = ply
	-- if next(UVWantedTableVehicle) ~= nil then
	-- 	local suspects = UVWantedTableVehicle
	-- 	local random_entry = math.random(#suspects)	
	-- 	suspect = suspects[random_entry]
	-- 	enemylocation = (suspect:GetPos()+ (vector_up * 50))
	-- else
	-- 	enemylocation = (suspect:GetPos()+ (vector_up * 50))
	-- end
	
	if next(dvd.Waypoints) == nil then
		if not UVNoDVWaypointsNotify then
			UVNoDVWaypointsNotify = true
			PrintMessage( HUD_PRINTTALK, "There's no Decent Vehicle waypoints to spawn vehicles! Download Decent Vehicle (if you haven't) and place some waypoints!")
		end
		return
	end
	UVNoDVWaypointsNotify = nil
	
	if next(UVWantedTableVehicle) ~= nil then
		local suspects = UVWantedTableVehicle
		local random_entry = math.random(#suspects)
		suspect = suspects[random_entry]
		
		enemylocation = (suspect:GetPos() + Vector(0, 0, 50))
		suspectvelocity = suspect:GetVelocity()
	elseif not playercontrolled then
		enemylocation = dvd.Waypoints[math.random(#dvd.Waypoints)]["Target"] + Vector(0, 0, 50)
	else
		enemylocation = ply:GetPos() + Vector(0, 0, 50)
	end
	
	local enemywaypoint = dvd.GetNearestWaypoint(enemylocation)
	local enemywaypointgroup = enemywaypoint["Group"]
	local waypointtable = {}
	local prioritywaypointtable = {}
	local prioritywaypointtable2 = {}
	local prioritywaypointtable3 = {}
	for k, v in ipairs(dvd.Waypoints) do
		local Waypoint = v["Target"]
		local distance = enemylocation - Waypoint
		local vect = distance:GetNormalized()
		local evectdot = vect:Dot(suspectvelocity)
		if distance:LengthSqr() > 25000000 then
			if enemywaypointgroup == v["Group"] then
				if UVStraightToWaypoint(enemylocation, Waypoint) then
					if evectdot < 0 then
						table.insert(prioritywaypointtable, v)
					elseif distance:LengthSqr() < 25000000 then
						table.insert(prioritywaypointtable2, v)
					end
				elseif distance:LengthSqr() < 100000000 then
					table.insert(prioritywaypointtable3, v)
				end
			elseif distance:LengthSqr() < 100000000 then
				table.insert(waypointtable, v)
			end
		end
	end

	if not UVTargeting and (rhinoattack or helicopter) then return end

	if next(prioritywaypointtable) ~= nil then
		uvspawnpointwaypoint = prioritywaypointtable[math.random(#prioritywaypointtable)]
		uvspawnpoint = uvspawnpointwaypoint["Target"]
	elseif next(prioritywaypointtable2) ~= nil then
		uvspawnpointwaypoint = prioritywaypointtable2[math.random(#prioritywaypointtable2)]
		uvspawnpoint = uvspawnpointwaypoint["Target"]
	elseif next(prioritywaypointtable3) ~= nil then
		uvspawnpointwaypoint = prioritywaypointtable3[math.random(#prioritywaypointtable3)]
		uvspawnpoint = uvspawnpointwaypoint["Target"]
	elseif next(waypointtable) ~= nil then
		uvspawnpointwaypoint = waypointtable[math.random(#waypointtable)]
		uvspawnpoint = uvspawnpointwaypoint["Target"]
	else
		uvspawnpointwaypoint = dvd.Waypoints[math.random(#dvd.Waypoints)]
		uvspawnpoint = uvspawnpointwaypoint["Target"]
	end

	local neighbor = dvd.Waypoints[uvspawnpointwaypoint.Neighbors[math.random(#uvspawnpointwaypoint.Neighbors)]]

	if neighbor then
		local neighborpoint = neighbor["Target"]
		local neighbordistance = neighborpoint - uvspawnpoint
		uvspawnpointangles = neighbordistance:Angle()+Angle(0,180,0)
	else
		uvspawnpointangles = Angle(0,math.random(0,360),0)
	end
	
	if UVTargeting then
		if not rhinoattack then
			local mathangle = math.random(1,2)
			if mathangle == 2 then
				uvspawnpointangles = uvspawnpointangles+Angle(0,180,0)
			end
		else
			uvspawnpointangles = suspect:GetVelocity():Angle() + Angle(0,180,0)
		end
	end
	
	if posspecified then
		uvspawnpoint = posspecified
	end
	if angles then
		uvspawnpointangles = angles
	end
	
	if helicopter then
		local modeltable = {
			"models/nfs_mwpolhel/nfs_mwpolhel.mdl",
			"models/nfs_ucpolhel/nfs_ucpolhel.mdl",
			"models/nfs_hppolhel/nfs_hppolhel.mdl",
			"models/nfs_nlpolhel/nfs_nlpolhel.mdl",
			"models/nfs_paybackpolhel/nfs_paybackpolhel.mdl",
		}
		
		local heli = ents.Create("uvair")
		heli.Model = modeltable[math.random(#modeltable)]
		heli:SetPos(uvspawnpoint +Vector(0,0,1000))
		heli:Spawn()
		heli:Activate()
		heli:SetTarget(suspect)
		return
	end
	
	local vehiclebase = UVUVehicleBase:GetInt()
	
	--FIND UNITS
	local givenunitstable
	local givenclasses = {
		"npc_uvpatrol",
		"npc_uvsupport",
		"npc_uvpursuit",
		"npc_uvinterceptor",
		"npc_uvspecial",
		"npc_uvcommander",
	}
	
	local availableunitstable = {}
	local availableclasses = {}
	
	if UVHeatLevel <= 1 then
		UVHeatLevel = 1
	elseif UVHeatLevel > MAX_HEAT_LEVEL then
		UVHeatLevel = MAX_HEAT_LEVEL
	end
	
	local appliedUnits = nil
	
	local UnitsPatrol = string.Trim( GetConVar( 'unitvehicle_unit_unitspatrol' .. UVHeatLevel ):GetString() )
	local UnitsSupport = string.Trim( GetConVar( 'unitvehicle_unit_unitssupport' .. UVHeatLevel ):GetString() )
	local UnitsPursuit = string.Trim( GetConVar( 'unitvehicle_unit_unitspursuit' .. UVHeatLevel ):GetString() )
	local UnitsInterceptor = string.Trim( GetConVar( 'unitvehicle_unit_unitsinterceptor' .. UVHeatLevel ):GetString() )
	local UnitsSpecial = string.Trim( GetConVar( 'unitvehicle_unit_unitsspecial' .. UVHeatLevel ):GetString() )
	local UnitsCommander = string.Trim( GetConVar( 'unitvehicle_unit_unitscommander' .. UVHeatLevel ):GetString() )
	local UnitsRhino = string.Trim( GetConVar( 'unitvehicle_unit_unitsrhino' .. UVHeatLevel ):GetString() )
	
	if UVOneCommanderActive or UVOneCommanderDeployed or posspecified or (UVUnitsHavePlayers and not playercontrolled) then
		UnitsCommander = ""
	end
	
	givenunitstable = {
		UnitsPatrol,
		UnitsSupport,
		UnitsPursuit,
		UnitsInterceptor,
		UnitsSpecial,
		UnitsCommander,
	}
	
	for k, v in pairs(givenunitstable) do
		if not string.match(v, "^%s*$") then --not an empty string
			table.insert(availableunitstable, givenunitstable[k])
			table.insert(availableclasses, givenclasses[k])
		end
	end
	
	local randomclassunit = math.random(1, #availableclasses)
	
	if rhinoattack and not string.match(UnitsRhino, "^%s*$") then
		appliedunits = UnitsRhino
	else
		rhinoattack = nil
		appliedunits = availableunitstable[randomclassunit]
	end

	uvnextclasstospawn = availableclasses[randomclassunit]
	
	if not isstring(appliedunits) then
		PrintMessage( HUD_PRINTTALK, "There's currently no assigned Units to spawn. Use the Unit Manager tool to assign Units at that particular Heat Level!")
		return
	end
	
	local availableunits = {}
	local availableunit
	local MEMORY = {}
	
	if vehiclebase == 3 then --Glide
		local saved_vehicles = file.Find("unitvehicles/glide/units/*.json", "DATA")
		
		for k, v in pairs(saved_vehicles) do
			local match = string.find( appliedunits, v )
			if match then
				table.insert(availableunits, v)
			end
		end
		
		if next(availableunits) == nil then
			if not string.match(appliedunits, "^%s*$") then
				PrintMessage( HUD_PRINTTALK, "Unit Manager attempted to spawn a Unit that is NOT in the database. Unit name(s) to cross-check: "..appliedunits)
			end
			return
		end
		
		availableunit = availableunits[math.random(1, #availableunits)]
		
		if commanderrespawn then
			availableunit = commanderrespawn
			uvnextclasstospawn = "npc_uvcommander"
		end
		
		local JSONData = file.Read( "unitvehicles/glide/units/"..availableunit, "DATA" )
		
		MEMORY = util.JSONToTable(JSONData, true)
		
		local pos = uvspawnpoint+Vector( 0, 0, 50 )
		local ang = uvspawnpointangles
		ang.yaw = rhinoattack and not posspecified and ang.yaw or ang.yaw + 180 --Points the other way when spawning based on player
		
		--duplicator.SetLocalPos( pos )
		--duplicator.SetLocalAng( ang )
		
		-- local Ents = duplicator.Paste( nil, MEMORY.Entities, MEMORY.Constraints )
		-- --print(type(Ents), "a", PrintTable(Ents))
		-- local Ent = Ents[next(Ents)]
		local entArray = MEMORY.Entities[next(MEMORY.Entities)]

		local Ent = ents.Create( entArray.Class )
		duplicator.DoGeneric( Ent, entArray )
		
		Ent:SetPos( pos )
		Ent:SetAngles( ang )

		Ent:Spawn()
		Ent:Activate()

		table.Merge( Ent:GetTable(), MEMORY.Entities[next(MEMORY.Entities)] )
		
		-- duplicator.SetLocalPos( vector_origin )
		-- duplicator.SetLocalAng( angle_zero )

		-- local Ent = duplicator.CreateEntityFromTable( nil, MEMORY.Entities )
		-- print(Ent, "b")
		
		if not IsValid(Ent) then PrintMessage( HUD_PRINTTALK, "The vehicle '"..availableunit.."' is missing!") return end
		
		if MEMORY.SubMaterials then
			if istable( MEMORY.SubMaterials ) then
				for i = 0, table.Count( MEMORY.SubMaterials ) do
					Ent:SetSubMaterial( i, MEMORY.SubMaterials[i] )
				end
			end
			
			local groups = string.Explode( ",", MEMORY.BodyGroups)
			for i = 1, table.Count( groups ) do
				Ent:SetBodygroup(i, tonumber(groups[i]) )
			end
			
			Ent:SetSkin( MEMORY.Skin )
			
			local c = string.Explode( ",", MEMORY.Color )
			local Color =  Color( tonumber(c[1]), tonumber(c[2]), tonumber(c[3]), tonumber(c[4]) )
			
			local dot = Color.r * Color.g * Color.b * Color.a
			Ent.OldColor = dot
			Ent:SetColor( Color )
			
			local data = {
				Color = Color,
				RenderMode = 0,
				RenderFX = 0
			}
			duplicator.StoreEntityModifier( Ent, "colour", data )
		end
		
		Ent.uvclasstospawnon = uvnextclasstospawn
		
		if rhinoattack then
			Ent.uvclasstospawnon = "npc_uvspecial"
			Ent.rhino = true
		elseif Ent.uvclasstospawnon ~= "npc_uvpatrol" and Ent.uvclasstospawnon ~= "npc_uvsupport" then
			
			if UVUPursuitTech:GetBool() then
				Ent.PursuitTech = {}
				
				local pool = {}
				
				if UVUPursuitTech_ESF:GetBool() then
					table.insert(pool, "ESF")
				end
				if UVUPursuitTech_Spikestrip:GetBool() then
					table.insert(pool, "Spikestrip")
				end
				if UVUPursuitTech_Killswitch:GetBool() then
					table.insert(pool, "Killswitch")
				end
				if UVUPursuitTech_RepairKit:GetBool() then
					table.insert(pool, "Repair Kit")
				end
				
				for i=1,2,1 do
					if #pool > 0 then
						local selected_pt = pool[math.random(1, #pool)]
						local sanitized_pt = string.lower(string.gsub(selected_pt, " ", ""))
						
						local ammo_count = GetConVar("unitvehicle_unitpursuittech_maxammo_"..sanitized_pt):GetInt()
						ammo_count = ammo_count > 0 and ammo_count or math.huge
						
						Ent.PursuitTech[i] = {
							Tech = selected_pt,
							Ammo = ammo_count,
							Cooldown = GetConVar("unitvehicle_unitpursuittech_cooldown_"..sanitized_pt):GetInt(),
							LastUsed = -math.huge,
							Upgraded = (Ent.uvclasstospawnon == "npc_uvspecial" or Ent.uvclasstospawnon == "npc_uvcommander")
						}
						
						for i, v in pairs(pool) do
							if v == selected_pt then
								table.remove(pool, i)
							end
						end
						--UVReplicatePT( Ent, i )
					end
				end
			end
		end
		
		if Ent.uvclasstospawnon == "npc_uvcommander" and UVUOneCommander:GetInt() == 1 then
			UVOneCommanderDeployed = true
			table.insert(UVCommanders, Ent)
			Ent.unitscript = availableunit
			Ent.uvlasthealth = UVCommanderLastHealth
			Ent.uvlastenginehealth = UVCommanderLastEngineHealth
		end
		
		Ent:CallOnRemove( "UVGlideVehicleRemoved", function(car)
			if table.HasValue(UVCommanders, car) then
				table.RemoveByValue(UVCommanders, car)
			end
		end)
		
		if posspecified then
			Ent.roadblocking = true
		end
		if disperse then
			Ent.disperse = true
		end
		
		if playercontrolled then
			timer.Simple(0.5, function()
				Ent.UnitVehicle = ply
				Ent.callsign = ply:GetName()
				UVAddToPlayerUnitListVehicle(Ent)
				table.insert(UVSimfphysVehicleInitializing, Ent)
			end)
		else
			table.insert(UVSimfphysVehicleInitializing, Ent)
		end
		
		if Ent.PursuitTech then
			timer.Simple(1, function()
				for i=1,2 do
					UVReplicatePT( Ent, i )
				end
			end)
		end
		
	elseif vehiclebase == 2 then --simfphys
		
		local saved_vehicles = file.Find("unitvehicles/simfphys/units/*.txt", "DATA")
		
		for k, v in pairs(saved_vehicles) do
			local match = string.find( appliedunits, v )
			if match then
				table.insert(availableunits, v)
			end
		end
		
		if next(availableunits) == nil then
			if not string.match(appliedunits, "^%s*$") then
				PrintMessage( HUD_PRINTTALK, "Unit Manager attempted to spawn a Unit that is NOT in the database. Unit name(s) to cross-check: "..appliedunits)
			end
			return
		end
		
		availableunit = availableunits[math.random(1, #availableunits)]
		
		if commanderrespawn then
			availableunit = commanderrespawn
			uvnextclasstospawn = "npc_uvcommander"
		end
		
		local DataString = file.Read( "unitvehicles/simfphys/units/"..availableunit, "DATA" )
		
		local words = string.Explode( "", DataString )
		local shit = {}
		
		for k, v in pairs( words ) do
			shit[k] =  string.char( string.byte( v ) - 20 )
		end
		
		local Data = string.Explode( "#", string.Implode("",shit) )
		
		for _,v in pairs(Data) do
			local Var = string.Explode( "=", v )
			local name = Var[1]
			local variable = Var[2]
			
			if name and variable then
				if name == "SubMaterials" then
					MEMORY[name] = {}
					
					local submats = string.Explode( ",", variable )
					for i = 0, (table.Count( submats ) - 1) do
						MEMORY[name][i] = submats[i+1]
					end
				else
					MEMORY[name] = variable
				end
			end
		end
		
		if not istable(MEMORY) then return end
		
		local Ent
		
		local vname = MEMORY.SpawnName
		local VehicleList = list.Get( "simfphys_vehicles" )
		local vehicle = VehicleList[ vname ]
		
		if not vehicle then 
			PrintMessage( HUD_PRINTTALK, "The vehicle class '"..vname.."' dosen't seem to be installed!")
			return false 
		end
		
		local SpawnPos = uvspawnpoint + (vector_up * 50) + (vehicle.SpawnOffset or vector_origin)
		
		local SpawnAng = uvspawnpointangles
		SpawnAng.pitch = 0
		SpawnAng.yaw = rhinoattack and not posspecified and SpawnAng.yaw or SpawnAng.yaw + 180
		SpawnAng.yaw = SpawnAng.yaw + (vehicle.SpawnAngleOffset and vehicle.SpawnAngleOffset or 0)
		SpawnAng.roll = 0
		
		Ent = simfphys.SpawnVehicle( ply, SpawnPos, SpawnAng, vehicle.Model, vehicle.Class, vname, vehicle )
		
		if not IsValid( Ent ) then return end
		
		timer.Simple( 0.5, function()
			if not IsValid(Ent) then return end
			
			local tsc = string.Explode( ",", MEMORY.TireSmokeColor )
			Ent:SetTireSmokeColor( Vector( tonumber(tsc[1]), tonumber(tsc[2]), tonumber(tsc[3]) ) )
			
			Ent.Turbocharged = tobool( MEMORY.HasTurbo )
			Ent.Supercharged = tobool( MEMORY.HasBlower )
			
			Ent:SetEngineSoundPreset( math.Clamp( tonumber( MEMORY.SoundPreset ), -1, 23) )
			Ent:SetMaxTorque( math.Clamp( tonumber( MEMORY.PeakTorque ), 20, 1000) )
			Ent:SetDifferentialGear( math.Clamp( tonumber( MEMORY.FinalGear ),0.2, 6 ) )
			
			Ent:SetSteerSpeed( math.Clamp( tonumber( MEMORY.SteerSpeed ), 1, 16 ) )
			Ent:SetFastSteerAngle( math.Clamp( tonumber( MEMORY.SteerAngFast ), 0, 1) )
			Ent:SetFastSteerConeFadeSpeed( math.Clamp( tonumber( MEMORY.SteerFadeSpeed ), 1, 5000 ) )
			
			Ent:SetEfficiency( math.Clamp( tonumber( MEMORY.Efficiency ) ,0.2,4) )
			Ent:SetMaxTraction( math.Clamp( tonumber( MEMORY.MaxTraction ) , 5,1000) )
			Ent:SetTractionBias( math.Clamp( tonumber( MEMORY.GripOffset ),-0.99,0.99) )
			Ent:SetPowerDistribution( math.Clamp( tonumber( MEMORY.PowerDistribution ) ,-1,1) )
			
			Ent:SetBackFire( tobool( MEMORY.HasBackfire ) )
			Ent:SetDoNotStall( tobool( MEMORY.DoesntStall ) )
			
			Ent:SetIdleRPM( math.Clamp( tonumber( MEMORY.IdleRPM ),1,25000) )
			Ent:SetLimitRPM( math.Clamp( tonumber( MEMORY.MaxRPM ),4,25000) )
			Ent:SetRevlimiter( tobool( MEMORY.HasRevLimiter ) )
			Ent:SetPowerBandEnd( math.Clamp( tonumber( MEMORY.PowerEnd ), 3, 25000) )
			Ent:SetPowerBandStart( math.Clamp( tonumber( MEMORY.PowerStart ) ,2 ,25000) )
			
			Ent:SetTurboCharged( Ent.Turbocharged )
			Ent:SetSuperCharged( Ent.Supercharged )
			Ent:SetBrakePower( math.Clamp( tonumber( MEMORY.BrakePower ), 0.1, 500) )
			
			Ent:SetSoundoverride( MEMORY.SoundOverride or "" )
			
			Ent:SetLights_List( Ent.LightsTable or "no_lights" )
			
			Ent:SetBulletProofTires(true)
			
			Ent.snd_horn = MEMORY.HornSound
			
			Ent.snd_blowoff = MEMORY.snd_blowoff
			Ent.snd_spool = MEMORY.snd_spool
			Ent.snd_bloweron = MEMORY.snd_bloweron
			Ent.snd_bloweroff = MEMORY.snd_bloweroff
			
			Ent:SetBackfireSound( MEMORY.backfiresound or "" )
			
			local Gears = {}
			local Data = string.Explode( ",", MEMORY.Gears  )
			for i = 1, table.Count( Data ) do 
				local gRatio = tonumber( Data[i] )
				
				if isnumber( gRatio ) then
					if i == 1 then
						Gears[i] = math.Clamp( gRatio, -5, -0.001)
						
					elseif i == 2 then
						Gears[i] = 0
						
					else
						Gears[i] = math.Clamp( gRatio, 0.001, 5)
					end
				end
			end
			Ent.Gears = Gears
			
			if istable( MEMORY.SubMaterials ) then
				for i = 0, table.Count( MEMORY.SubMaterials ) do
					Ent:SetSubMaterial( i, MEMORY.SubMaterials[i] )
				end
			end
			
			if MEMORY.FrontDampingOverride and MEMORY.FrontConstantOverride and MEMORY.RearDampingOverride and MEMORY.RearConstantOverride then
				Ent.FrontDampingOverride = tonumber( MEMORY.FrontDampingOverride )
				Ent.FrontConstantOverride = tonumber( MEMORY.FrontConstantOverride )
				Ent.RearDampingOverride = tonumber( MEMORY.RearDampingOverride )
				Ent.RearConstantOverride = tonumber( MEMORY.RearConstantOverride )
				
				local data = {
					[1] = {Ent.FrontConstantOverride,Ent.FrontDampingOverride},
					[2] = {Ent.FrontConstantOverride,Ent.FrontDampingOverride},
					[3] = {Ent.RearConstantOverride,Ent.RearDampingOverride},
					[4] = {Ent.RearConstantOverride,Ent.RearDampingOverride},
					[5] = {Ent.RearConstantOverride,Ent.RearDampingOverride},
					[6] = {Ent.RearConstantOverride,Ent.RearDampingOverride}
				}
				
				local elastics = Ent.Elastics
				if elastics then
					for i = 1, table.Count( elastics ) do
						local elastic = elastics[i]
						if Ent.StrengthenSuspension == true then
							if IsValid( elastic ) then
								elastic:Fire( "SetSpringConstant", data[i][1] * 0.5, 0 )
								elastic:Fire( "SetSpringDamping", data[i][2] * 0.5, 0 )
							end
							local elastic2 = elastics[i * 10]
							if IsValid( elastic2 ) then
								elastic2:Fire( "SetSpringConstant", data[i][1] * 0.5, 0 )
								elastic2:Fire( "SetSpringDamping", data[i][2] * 0.5, 0 )
							end
						else
							if IsValid( elastic ) then
								elastic:Fire( "SetSpringConstant", data[i][1], 0 )
								elastic:Fire( "SetSpringDamping", data[i][2], 0 )
							end
						end
					end
				end
			end
			
			Ent:SetFrontSuspensionHeight( tonumber( MEMORY.FrontHeight ) )
			Ent:SetRearSuspensionHeight( tonumber( MEMORY.RearHeight ) )
			
			local groups = string.Explode( ",", MEMORY.BodyGroups)
			for i = 1, table.Count( groups ) do
				Ent:SetBodygroup(i, tonumber(groups[i]) )
			end
			
			Ent:SetSkin( MEMORY.Skin )
			
			local c = string.Explode( ",", MEMORY.Color )
			local Color =  Color( tonumber(c[1]), tonumber(c[2]), tonumber(c[3]), tonumber(c[4]) )
			
			local dot = Color.r * Color.g * Color.b * Color.a
			Ent.OldColor = dot
			Ent:SetColor( Color )
			
			local data = {
				Color = Color,
				RenderMode = 0,
				RenderFX = 0
			}
			duplicator.StoreEntityModifier( Ent, "colour", data )
			
			if Ent.CustomWheels then
				if Ent.GhostWheels then
					if not IsValid( Ent ) then return end
					if MEMORY.WheelTool_Foffset and MEMORY.WheelTool_Roffset then
						SetWheelOffset( Ent, MEMORY.WheelTool_Foffset, MEMORY.WheelTool_Roffset )
					end
					
					if not MEMORY.FrontWheelOverride and not MEMORY.RearWheelOverride then return end
					
					local front_model = MEMORY.FrontWheelOverride or vehicle.Members.CustomWheelModel
					local front_angle = GetAngleFromSpawnlist(front_model)
					
					local camber = MEMORY.Camber or 0
					local rear_model = MEMORY.RearWheelOverride or (vehicle.Members.CustomWheelModel_R and vehicle.Members.CustomWheelModel_R or front_model)
					local rear_angle = GetAngleFromSpawnlist(rear_model)
					
					if not front_model or not rear_model or not front_angle or not rear_angle then return end
					
					if ValidateModel( front_model ) and ValidateModel( rear_model ) then 
						Ent.Camber = camber
						ApplyWheel(Ent, {front_model,front_angle,rear_model,rear_angle,camber})
					else
						ply:PrintMessage( HUD_PRINTTALK, "selected wheel does not exist on the server")
					end
				end
			end
		end)
		
		
		Ent.uvclasstospawnon = uvnextclasstospawn
		if rhinoattack then
			Ent.uvclasstospawnon = "npc_uvspecial"
			Ent.rhino = true
		elseif Ent.uvclasstospawnon ~= "npc_uvpatrol" and Ent.uvclasstospawnon ~= "npc_uvsupport" then
			
			if UVUPursuitTech:GetBool() then
				Ent.PursuitTech = {}
				
				local pool = {}
				
				if UVUPursuitTech_ESF:GetBool() then
					table.insert(pool, "ESF")
				end
				if UVUPursuitTech_Spikestrip:GetBool() then
					table.insert(pool, "Spikestrip")
				end
				if UVUPursuitTech_Killswitch:GetBool() then
					table.insert(pool, "Killswitch")
				end
				if UVUPursuitTech_RepairKit:GetBool() then
					table.insert(pool, "Repair Kit")
				end
				
				for i=1,2,1 do
					if #pool > 0 then
						local selected_pt = pool[math.random(1, #pool)]
						local sanitized_pt = string.lower(string.gsub(selected_pt, " ", ""))
						
						local ammo_count = GetConVar("unitvehicle_unitpursuittech_maxammo_"..sanitized_pt):GetInt()
						ammo_count = ammo_count > 0 and ammo_count or math.huge
						
						Ent.PursuitTech[i] = {
							Tech = selected_pt,
							Ammo = ammo_count,
							Cooldown = GetConVar("unitvehicle_unitpursuittech_cooldown_"..sanitized_pt):GetInt(),
							LastUsed = -math.huge,
							Upgraded = (Ent.uvclasstospawnon == "npc_uvspecial" or Ent.uvclasstospawnon == "npc_uvcommander")
						}
						
						for i, v in pairs(pool) do
							if v == selected_pt then
								table.remove(pool, i)
							end
						end
						
						--UVReplicatePT( Ent, i )
					end
				end
			end
		end
		
		if Ent.uvclasstospawnon == "npc_uvcommander" and UVUOneCommander:GetInt() == 1 then
			UVOneCommanderDeployed = true
			table.insert(UVCommanders, Ent)
			Ent.unitscript = availableunit
			Ent.uvlasthealth = UVCommanderLastHealth
		end
		
		if playercontrolled then
			timer.Simple(0.5, function()
				Ent.UnitVehicle = ply
				Ent.callsign = ply:GetName()
				UVAddToPlayerUnitListVehicle(Ent)
				table.insert(UVSimfphysVehicleInitializing, Ent)
			end)
		else
			table.insert(UVSimfphysVehicleInitializing, Ent)
		end
		
		Ent:CallOnRemove( "UVSimfphysVehicleRemoved", function(car)
			if table.HasValue(UVSimfphysVehicleInitializing, car) then
				table.RemoveByValue(UVSimfphysVehicleInitializing, car)
			end
			if table.HasValue(UVCommanders, car) then
				table.RemoveByValue(UVCommanders, car)
			end
		end)
		
		timer.Simple(2, function() 
			if IsValid(Ent) and not Ent.UnitVehicle then
				Ent:Remove()
			end
		end)
		
		if posspecified then
			Ent.roadblocking = true
		end
		if disperse then
			Ent.disperse = true
		end
		
		if Ent.PursuitTech then
			timer.Simple(1, function()
				for i=1,2 do
					UVReplicatePT( Ent, i )
				end
			end)
		end	
		
	elseif vehiclebase == 1 then --Default Vehicle Base
		local saved_vehicles = file.Find("unitvehicles/prop_vehicle_jeep/units/*.txt", "DATA")
		
		for k, v in pairs(saved_vehicles) do
			local match = string.find( appliedunits, v )
			if match then
				table.insert(availableunits, v)
			end
		end
		
		if next(availableunits) == nil then
			if not string.match(appliedunits, "^%s*$") then
				PrintMessage( HUD_PRINTTALK, "Unit Manager attempted to spawn a Unit that is NOT in the database. Unit name(s) to cross-check: "..appliedunits)
			end
			return
		end
		
		availableunit = availableunits[math.random(1, #availableunits)]
		
		if commanderrespawn then
			availableunit = commanderrespawn
			uvnextclasstospawn = "npc_uvcommander"
		end
		
		local DataString = file.Read( "unitvehicles/prop_vehicle_jeep/units/"..availableunit, "DATA" )
		
		local words = string.Explode( "", DataString )
		local shit = {}
		
		for k, v in pairs( words ) do
			shit[k] =  string.char( string.byte( v ) - 20 )
		end
		
		local Data = string.Explode( "#", string.Implode("",shit) )
		
		for _,v in pairs(Data) do
			local Var = string.Explode( "=", v )
			local name = Var[1]
			local variable = Var[2]
			
			if name and variable then
				if name == "SubMaterials" then
					MEMORY[name] = {}
					
					local submats = string.Explode( ",", variable )
					for i = 0, (table.Count( submats ) - 1) do
						MEMORY[name][i] = submats[i+1]
					end
				else
					MEMORY[name] = variable
				end
			end
		end
		
		if not istable(MEMORY) then return end
		
		local class = MEMORY.SpawnName
		
		local vehicles = list.Get("Vehicles")
		local lst = vehicles[class]
		if not lst then
			PrintMessage( HUD_PRINTTALK, "The vehicle '"..class.."' is missing!")
			return
		end
		
		uvspawnpointangles.yaw = uvspawnpointangles.yaw + 90
		uvspawnpointangles.yaw = rhinoattack and not posspecified and uvspawnpointangles.yaw or uvspawnpointangles.yaw + 180
		
		local Ent = ents.Create("prop_vehicle_jeep")
		Ent.VehicleTable = lst
		Ent.VehicleName = MEMORY.VehicleName
		Ent:SetModel(lst.Model) 
		Ent:SetPos(uvspawnpoint+ (vector_up * 50))
		Ent:SetAngles(uvspawnpointangles)
		Ent:SetKeyValue("vehiclescript", lst.KeyValues.vehiclescript)
		Ent:SetVehicleClass( class )
		Ent:Spawn()
		Ent:Activate()
		
		local vehicle = Ent
		if IsValid(Entity(1)) then
			gamemode.Call( "PlayerSpawnedVehicle", Entity(1), vehicle ) --Some vehicles has different models implanted together, so do that.
		end
		
		if istable( MEMORY.SubMaterials ) then
			for i = 0, table.Count( MEMORY.SubMaterials ) do
				Ent:SetSubMaterial( i, MEMORY.SubMaterials[i] )
			end
		end
		
		timer.Simple(0.5, function()
			if not IsValid(Ent) then return end
			local groups = string.Explode( ",", MEMORY.BodyGroups)
			for i = 1, table.Count( groups ) do
				Ent:SetBodygroup(i, tonumber(groups[i]) )
			end
			
			Ent:SetSkin( MEMORY.Skin )
			
			local c = string.Explode( ",", MEMORY.Color )
			local Color =  Color( tonumber(c[1]), tonumber(c[2]), tonumber(c[3]), tonumber(c[4]) )
			
			local dot = Color.r * Color.g * Color.b * Color.a
			Ent.OldColor = dot
			Ent:SetColor( Color )
			
			local data = {
				Color = Color,
				RenderMode = 0,
				RenderFX = 0
			}
			duplicator.StoreEntityModifier( Ent, "colour", data )
		end)
		
		Ent.uvclasstospawnon = uvnextclasstospawn
		if rhinoattack then
			Ent.uvclasstospawnon = "npc_uvspecial"
			Ent.rhino = true
		elseif Ent.uvclasstospawnon ~= "npc_uvpatrol" and Ent.uvclasstospawnon ~= "npc_uvsupport" then
			
			if UVUPursuitTech:GetBool() then
				Ent.PursuitTech = {}
				
				local pool = {}
				
				if UVUPursuitTech_ESF:GetBool() then
					table.insert(pool, "ESF")
				end
				if UVUPursuitTech_Spikestrip:GetBool() then
					table.insert(pool, "Spikestrip")
				end
				if UVUPursuitTech_Killswitch:GetBool() then
					table.insert(pool, "Killswitch")
				end
				if UVUPursuitTech_RepairKit:GetBool() then
					table.insert(pool, "Repair Kit")
				end
				
				for i=1,2,1 do
					if #pool > 0 then
						local selected_pt = pool[math.random(1, #pool)]
						local sanitized_pt = string.lower(string.gsub(selected_pt, " ", ""))
						
						local ammo_count = GetConVar("unitvehicle_unitpursuittech_maxammo_"..sanitized_pt):GetInt()
						ammo_count = ammo_count > 0 and ammo_count or math.huge
						
						Ent.PursuitTech[i] = {
							Tech = selected_pt,
							Ammo = ammo_count,
							Cooldown = GetConVar("unitvehicle_unitpursuittech_cooldown_"..sanitized_pt):GetInt(),
							LastUsed = -math.huge,
							Upgraded = (Ent.uvclasstospawnon == "npc_uvspecial" or Ent.uvclasstospawnon == "npc_uvcommander")
						}
						
						for i, v in pairs(pool) do
							if v == selected_pt then
								table.remove(pool, i)
							end
						end
						
						--UVReplicatePT( Ent, i )
					end
				end
			end
		end
		
		if Ent.uvclasstospawnon == "npc_uvcommander" and UVUOneCommander:GetInt() == 1 then
			UVOneCommanderDeployed = true
			table.insert(UVCommanders, Ent)
			Ent.unitscript = availableunit
			Ent.uvlasthealth = UVCommanderLastHealth
		end
		
		Ent:CallOnRemove( "UVGlideVehicleRemoved", function(car)
			if table.HasValue(UVCommanders, car) then
				table.RemoveByValue(UVCommanders, car)
			end
		end)
		
		if posspecified then
			Ent.roadblocking = true
		end
		if disperse then
			Ent.disperse = true
		end
		
		if playercontrolled then
			timer.Simple(0.5, function()
				Ent.UnitVehicle = ply
				Ent.callsign = ply:GetName()
				UVAddToPlayerUnitListVehicle(Ent)
				table.insert(UVSimfphysVehicleInitializing, Ent)
			end)
		else
			table.insert(UVSimfphysVehicleInitializing, Ent)
		end
		
		if Ent.PursuitTech then
			timer.Simple(1, function()
				for i=1,2 do
					UVReplicatePT( Ent, i )
				end
			end)
		end
		
	else
		PrintMessage( HUD_PRINTTALK, "Invalid Vehicle Base! Reverting to Default Vehicle Base! Please set the Vehicle Base in the Unit Manager Tool settings!")
		RunConsoleCommand("unitvehicle_unit_vehiclebase", 1)
	end
	
end

function UVAutoSpawnTraffic()
	
	local ply = Entity(1)
	
	local uvnextclasstospawn = "npc_trafficvehicle"
	local enemylocation
	local suspect
	local suspectvelocity = Vector(0,0,0)
	
	if next(dvd.Waypoints) == nil then
		if not UVNoDVWaypointsNotify then
			UVNoDVWaypointsNotify = true
			PrintMessage( HUD_PRINTTALK, "There's no Decent Vehicle waypoints to spawn vehicles! Download Decent Vehicle (if you haven't) and place some waypoints!")
		end
		return
	end
	UVNoDVWaypointsNotify = nil
	
	if next(UVWantedTableVehicle) ~= nil then
		local suspects = UVWantedTableVehicle
		local random_entry = math.random(#suspects)
		suspect = suspects[random_entry]
		
		enemylocation = (suspect:GetPos() + Vector(0, 0, 50))
		suspectvelocity = suspect:GetVelocity()
	elseif not playercontrolled then
		enemylocation = dvd.Waypoints[math.random(#dvd.Waypoints)]["Target"] + Vector(0, 0, 50)
	else
		enemylocation = ply:GetPos() + Vector(0, 0, 50)
	end
	
	local enemywaypoint = dvd.GetNearestWaypoint(enemylocation)
	local waypointtable = {}
	for k, v in ipairs(dvd.Waypoints) do
		local Waypoint = v["Target"]
		local distance = enemylocation - Waypoint
		local vect = distance:GetNormalized()
		local evectdot = vect:Dot(suspectvelocity)
		if distance:LengthSqr() > 25000000 and v["Group"] == 0 then
			table.insert(waypointtable, v)
		end
	end
	
	if next(waypointtable) ~= nil then
		uvspawnpointwaypoint = waypointtable[math.random(#waypointtable)]
		uvspawnpoint = uvspawnpointwaypoint["Target"]
	else
		uvspawnpointwaypoint = dvd.Waypoints[math.random(#dvd.Waypoints)]
		uvspawnpoint = uvspawnpointwaypoint["Target"]
	end

	local neighbor = dvd.Waypoints[uvspawnpointwaypoint.Neighbors[math.random(#uvspawnpointwaypoint.Neighbors)]]

	if neighbor then
		local neighborpoint = neighbor["Target"]
		local neighbordistance = neighborpoint - uvspawnpoint
		uvspawnpointangles = neighbordistance:Angle()+Angle(0,180,0)
	else
		uvspawnpointangles = Angle(0,math.random(0,360),0)
	end
	
	if posspecified then
		uvspawnpoint = posspecified
	end
	if angles then
		uvspawnpointangles = angles
	end
	
	local vehiclebase = UVTVehicleBase:GetInt()
	local availabletraffic = {}
	local MEMORY = {}
	
	if vehiclebase == 3 then --Glide
		local saved_vehicles = file.Find("unitvehicles/glide/traffic/*.json", "DATA")
		
		for k, v in pairs(saved_vehicles) do
			table.insert(availabletraffic, v)
		end
		
		if saved_vehicles == nil or next(saved_vehicles) == nil then
			if not UVNoTrafficNotify then
				UVNoTrafficNotify = true
				PrintMessage( HUD_PRINTTALK, "There's currently no Traffic to spawn. Use the Traffic Manager tool to add Traffic!")
			end
			return
		end

		UVNoTrafficNotify = nil
		
		availabletraffic = saved_vehicles[math.random(1, #saved_vehicles)]
		
		local JSONData = file.Read( "unitvehicles/glide/traffic/"..availabletraffic, "DATA" )
		
		MEMORY = util.JSONToTable(JSONData, true)
		
		local pos = uvspawnpoint+Vector( 0, 0, 50 )
		local ang = uvspawnpointangles
		ang.yaw = rhinoattack and not posspecified and ang.yaw or ang.yaw + 180 --Points the other way when spawning based on player
	
		local entArray = MEMORY.Entities[next(MEMORY.Entities)]

		local Ent = ents.Create( entArray.Class )
		duplicator.DoGeneric( Ent, entArray )
		
		Ent:SetPos( pos )
		Ent:SetAngles( ang )

		Ent:Spawn()
		Ent:Activate()

		table.Merge( Ent:GetTable(), MEMORY.Entities[next(MEMORY.Entities)] )
		
		if not IsValid(Ent) then PrintMessage( HUD_PRINTTALK, "The vehicle '"..availabletraffic.."' is missing!") return end
		
		if MEMORY.SubMaterials then
			if istable( MEMORY.SubMaterials ) then
				for i = 0, table.Count( MEMORY.SubMaterials ) do
					Ent:SetSubMaterial( i, MEMORY.SubMaterials[i] )
				end
			end
			
			local groups = string.Explode( ",", MEMORY.BodyGroups)
			for i = 1, table.Count( groups ) do
				Ent:SetBodygroup(i, tonumber(groups[i]) )
			end
			
			Ent:SetSkin( MEMORY.Skin )
			
			local c = string.Explode( ",", MEMORY.Color )
			local Color =  Color( tonumber(c[1]), tonumber(c[2]), tonumber(c[3]), tonumber(c[4]) )
			
			local dot = Color.r * Color.g * Color.b * Color.a
			Ent.OldColor = dot

			if MEMORY.SaveColor then
				Ent:SetColor( Color )
			else
				if isfunction(Ent.GetSpawnColor) then
					Color = Ent:GetSpawnColor()
					Ent:SetColor( Color )
				else
					Color.r = math.random(0, 255)
					Color.g = math.random(0, 255)
					Color.b = math.random(0, 255)
					Ent:SetColor( Color )
				end
			end
			
			local data = {
				Color = Color,
				RenderMode = 0,
				RenderFX = 0
			}
			duplicator.StoreEntityModifier( Ent, "colour", data )
		end
		
		Ent.uvclasstospawnon = uvnextclasstospawn
		
		table.insert(UVSimfphysVehicleInitializing, Ent)
		
	elseif vehiclebase == 2 then --simfphys
		
		local saved_vehicles = file.Find("unitvehicles/simfphys/traffic/*.txt", "DATA")
		
		for k, v in pairs(saved_vehicles) do
			table.insert(availabletraffic, v)
		end
		
		if saved_vehicles == nil or next(saved_vehicles) == nil then
			if not UVNoTrafficNotify then
				UVNoTrafficNotify = true
				PrintMessage( HUD_PRINTTALK, "There's currently no Traffic to spawn. Use the Traffic Manager tool to add Traffic!")
			end
			return
		end

		UVNoTrafficNotify = nil
		
		availabletraffic = saved_vehicles[math.random(1, #saved_vehicles)]
		
		if commanderrespawn then
			availabletraffic = commanderrespawn
			uvnextclasstospawn = "npc_uvcommander"
		end
		
		local DataString = file.Read( "unitvehicles/simfphys/traffic/"..availabletraffic, "DATA" )
		
		local words = string.Explode( "", DataString )
		local shit = {}
		
		for k, v in pairs( words ) do
			shit[k] =  string.char( string.byte( v ) - 20 )
		end
		
		local Data = string.Explode( "#", string.Implode("",shit) )
		
		for _,v in pairs(Data) do
			local Var = string.Explode( "=", v )
			local name = Var[1]
			local variable = Var[2]
			
			if name and variable then
				if name == "SubMaterials" then
					MEMORY[name] = {}
					
					local submats = string.Explode( ",", variable )
					for i = 0, (table.Count( submats ) - 1) do
						MEMORY[name][i] = submats[i+1]
					end
				else
					MEMORY[name] = variable
				end
			end
		end
		
		if not istable(MEMORY) then return end
		
		local Ent
		
		local vname = MEMORY.SpawnName
		local VehicleList = list.Get( "simfphys_vehicles" )
		local vehicle = VehicleList[ vname ]
		
		if not vehicle then 
			PrintMessage( HUD_PRINTTALK, "The vehicle class '"..vname.."' dosen't seem to be installed!")
			return false 
		end
		
		local SpawnPos = uvspawnpoint + (vector_up * 50) + (vehicle.SpawnOffset or vector_origin)
		
		local SpawnAng = uvspawnpointangles
		SpawnAng.pitch = 0
		SpawnAng.yaw = rhinoattack and not posspecified and SpawnAng.yaw or SpawnAng.yaw + 180
		SpawnAng.yaw = SpawnAng.yaw + (vehicle.SpawnAngleOffset and vehicle.SpawnAngleOffset or 0)
		SpawnAng.roll = 0
		
		Ent = simfphys.SpawnVehicle( ply, SpawnPos, SpawnAng, vehicle.Model, vehicle.Class, vname, vehicle )
		
		if not IsValid( Ent ) then return end
		
		timer.Simple( 0.5, function()
			if not IsValid(Ent) then return end
			
			local tsc = string.Explode( ",", MEMORY.TireSmokeColor )
			Ent:SetTireSmokeColor( Vector( tonumber(tsc[1]), tonumber(tsc[2]), tonumber(tsc[3]) ) )
			
			Ent.Turbocharged = tobool( MEMORY.HasTurbo )
			Ent.Supercharged = tobool( MEMORY.HasBlower )
			
			Ent:SetEngineSoundPreset( math.Clamp( tonumber( MEMORY.SoundPreset ), -1, 23) )
			Ent:SetMaxTorque( math.Clamp( tonumber( MEMORY.PeakTorque ), 20, 1000) )
			Ent:SetDifferentialGear( math.Clamp( tonumber( MEMORY.FinalGear ),0.2, 6 ) )
			
			Ent:SetSteerSpeed( math.Clamp( tonumber( MEMORY.SteerSpeed ), 1, 16 ) )
			Ent:SetFastSteerAngle( math.Clamp( tonumber( MEMORY.SteerAngFast ), 0, 1) )
			Ent:SetFastSteerConeFadeSpeed( math.Clamp( tonumber( MEMORY.SteerFadeSpeed ), 1, 5000 ) )
			
			Ent:SetEfficiency( math.Clamp( tonumber( MEMORY.Efficiency ) ,0.2,4) )
			Ent:SetMaxTraction( math.Clamp( tonumber( MEMORY.MaxTraction ) , 5,1000) )
			Ent:SetTractionBias( math.Clamp( tonumber( MEMORY.GripOffset ),-0.99,0.99) )
			Ent:SetPowerDistribution( math.Clamp( tonumber( MEMORY.PowerDistribution ) ,-1,1) )
			
			Ent:SetBackFire( tobool( MEMORY.HasBackfire ) )
			Ent:SetDoNotStall( tobool( MEMORY.DoesntStall ) )
			
			Ent:SetIdleRPM( math.Clamp( tonumber( MEMORY.IdleRPM ),1,25000) )
			Ent:SetLimitRPM( math.Clamp( tonumber( MEMORY.MaxRPM ),4,25000) )
			Ent:SetRevlimiter( tobool( MEMORY.HasRevLimiter ) )
			Ent:SetPowerBandEnd( math.Clamp( tonumber( MEMORY.PowerEnd ), 3, 25000) )
			Ent:SetPowerBandStart( math.Clamp( tonumber( MEMORY.PowerStart ) ,2 ,25000) )
			
			Ent:SetTurboCharged( Ent.Turbocharged )
			Ent:SetSuperCharged( Ent.Supercharged )
			Ent:SetBrakePower( math.Clamp( tonumber( MEMORY.BrakePower ), 0.1, 500) )
			
			Ent:SetSoundoverride( MEMORY.SoundOverride or "" )
			
			Ent:SetLights_List( Ent.LightsTable or "no_lights" )
			
			Ent:SetBulletProofTires(true)
			
			Ent.snd_horn = MEMORY.HornSound
			
			Ent.snd_blowoff = MEMORY.snd_blowoff
			Ent.snd_spool = MEMORY.snd_spool
			Ent.snd_bloweron = MEMORY.snd_bloweron
			Ent.snd_bloweroff = MEMORY.snd_bloweroff
			
			Ent:SetBackfireSound( MEMORY.backfiresound or "" )
			
			local Gears = {}
			local Data = string.Explode( ",", MEMORY.Gears  )
			for i = 1, table.Count( Data ) do 
				local gRatio = tonumber( Data[i] )
				
				if isnumber( gRatio ) then
					if i == 1 then
						Gears[i] = math.Clamp( gRatio, -5, -0.001)
						
					elseif i == 2 then
						Gears[i] = 0
						
					else
						Gears[i] = math.Clamp( gRatio, 0.001, 5)
					end
				end
			end
			Ent.Gears = Gears
			
			if istable( MEMORY.SubMaterials ) then
				for i = 0, table.Count( MEMORY.SubMaterials ) do
					Ent:SetSubMaterial( i, MEMORY.SubMaterials[i] )
				end
			end
			
			if MEMORY.FrontDampingOverride and MEMORY.FrontConstantOverride and MEMORY.RearDampingOverride and MEMORY.RearConstantOverride then
				Ent.FrontDampingOverride = tonumber( MEMORY.FrontDampingOverride )
				Ent.FrontConstantOverride = tonumber( MEMORY.FrontConstantOverride )
				Ent.RearDampingOverride = tonumber( MEMORY.RearDampingOverride )
				Ent.RearConstantOverride = tonumber( MEMORY.RearConstantOverride )
				
				local data = {
					[1] = {Ent.FrontConstantOverride,Ent.FrontDampingOverride},
					[2] = {Ent.FrontConstantOverride,Ent.FrontDampingOverride},
					[3] = {Ent.RearConstantOverride,Ent.RearDampingOverride},
					[4] = {Ent.RearConstantOverride,Ent.RearDampingOverride},
					[5] = {Ent.RearConstantOverride,Ent.RearDampingOverride},
					[6] = {Ent.RearConstantOverride,Ent.RearDampingOverride}
				}
				
				local elastics = Ent.Elastics
				if elastics then
					for i = 1, table.Count( elastics ) do
						local elastic = elastics[i]
						if Ent.StrengthenSuspension == true then
							if IsValid( elastic ) then
								elastic:Fire( "SetSpringConstant", data[i][1] * 0.5, 0 )
								elastic:Fire( "SetSpringDamping", data[i][2] * 0.5, 0 )
							end
							local elastic2 = elastics[i * 10]
							if IsValid( elastic2 ) then
								elastic2:Fire( "SetSpringConstant", data[i][1] * 0.5, 0 )
								elastic2:Fire( "SetSpringDamping", data[i][2] * 0.5, 0 )
							end
						else
							if IsValid( elastic ) then
								elastic:Fire( "SetSpringConstant", data[i][1], 0 )
								elastic:Fire( "SetSpringDamping", data[i][2], 0 )
							end
						end
					end
				end
			end
			
			Ent:SetFrontSuspensionHeight( tonumber( MEMORY.FrontHeight ) )
			Ent:SetRearSuspensionHeight( tonumber( MEMORY.RearHeight ) )
			
			local groups = string.Explode( ",", MEMORY.BodyGroups)
			for i = 1, table.Count( groups ) do
				Ent:SetBodygroup(i, tonumber(groups[i]) )
			end
			
			Ent:SetSkin( MEMORY.Skin )
			
			local c = string.Explode( ",", MEMORY.Color )
			local Color =  Color( tonumber(c[1]), tonumber(c[2]), tonumber(c[3]), tonumber(c[4]) )
			
			local dot = Color.r * Color.g * Color.b * Color.a
			Ent.OldColor = dot
			Ent:SetColor( Color )
			
			local data = {
				Color = Color,
				RenderMode = 0,
				RenderFX = 0
			}
			duplicator.StoreEntityModifier( Ent, "colour", data )
			
			if Ent.CustomWheels then
				if Ent.GhostWheels then
					if not IsValid( Ent ) then return end
					if MEMORY.WheelTool_Foffset and MEMORY.WheelTool_Roffset then
						SetWheelOffset( Ent, MEMORY.WheelTool_Foffset, MEMORY.WheelTool_Roffset )
					end
					
					if not MEMORY.FrontWheelOverride and not MEMORY.RearWheelOverride then return end
					
					local front_model = MEMORY.FrontWheelOverride or vehicle.Members.CustomWheelModel
					local front_angle = GetAngleFromSpawnlist(front_model)
					
					local camber = MEMORY.Camber or 0
					local rear_model = MEMORY.RearWheelOverride or (vehicle.Members.CustomWheelModel_R and vehicle.Members.CustomWheelModel_R or front_model)
					local rear_angle = GetAngleFromSpawnlist(rear_model)
					
					if not front_model or not rear_model or not front_angle or not rear_angle then return end
					
					if ValidateModel( front_model ) and ValidateModel( rear_model ) then 
						Ent.Camber = camber
						ApplyWheel(Ent, {front_model,front_angle,rear_model,rear_angle,camber})
					else
						ply:PrintMessage( HUD_PRINTTALK, "selected wheel does not exist on the server")
					end
				end
			end
		end)
		
		
		Ent.uvclasstospawnon = uvnextclasstospawn

		table.insert(UVSimfphysVehicleInitializing, Ent)
		
	elseif vehiclebase == 1 then --Default Vehicle Base
		local saved_vehicles = file.Find("unitvehicles/prop_vehicle_jeep/traffic/*.txt", "DATA")
		
		for k, v in pairs(saved_vehicles) do
			table.insert(availabletraffic, v)
		end
		
		if saved_vehicles == nil or next(saved_vehicles) == nil then
			if not UVNoTrafficNotify then
				UVNoTrafficNotify = true
				PrintMessage( HUD_PRINTTALK, "There's currently no Traffic to spawn. Use the Traffic Manager tool to add Traffic!")
			end
			return
		end

		UVNoTrafficNotify = nil
		
		availabletraffic = saved_vehicles[math.random(1, #saved_vehicles)]
		
		if commanderrespawn then
			availabletraffic = commanderrespawn
			uvnextclasstospawn = "npc_uvcommander"
		end
		
		local DataString = file.Read( "unitvehicles/prop_vehicle_jeep/traffic/"..availabletraffic, "DATA" )
		
		local words = string.Explode( "", DataString )
		local shit = {}
		
		for k, v in pairs( words ) do
			shit[k] =  string.char( string.byte( v ) - 20 )
		end
		
		local Data = string.Explode( "#", string.Implode("",shit) )
		
		for _,v in pairs(Data) do
			local Var = string.Explode( "=", v )
			local name = Var[1]
			local variable = Var[2]
			
			if name and variable then
				if name == "SubMaterials" then
					MEMORY[name] = {}
					
					local submats = string.Explode( ",", variable )
					for i = 0, (table.Count( submats ) - 1) do
						MEMORY[name][i] = submats[i+1]
					end
				else
					MEMORY[name] = variable
				end
			end
		end
		
		if not istable(MEMORY) then return end
		
		local class = MEMORY.SpawnName
		
		local vehicles = list.Get("Vehicles")
		local lst = vehicles[class]
		if not lst then
			PrintMessage( HUD_PRINTTALK, "The vehicle '"..class.."' is missing!")
			return
		end
		
		uvspawnpointangles.yaw = uvspawnpointangles.yaw + 90
		uvspawnpointangles.yaw = rhinoattack and not posspecified and uvspawnpointangles.yaw or uvspawnpointangles.yaw + 180
		
		local Ent = ents.Create("prop_vehicle_jeep")
		Ent.VehicleTable = lst
		Ent.VehicleName = MEMORY.VehicleName
		Ent:SetModel(lst.Model) 
		Ent:SetPos(uvspawnpoint+ (vector_up * 50))
		Ent:SetAngles(uvspawnpointangles)
		Ent:SetKeyValue("vehiclescript", lst.KeyValues.vehiclescript)
		Ent:SetVehicleClass( class )
		Ent:Spawn()
		Ent:Activate()
		
		local vehicle = Ent
		if IsValid(Entity(1)) then
			gamemode.Call( "PlayerSpawnedVehicle", Entity(1), vehicle ) --Some vehicles has different models implanted together, so do that.
		end
		
		if istable( MEMORY.SubMaterials ) then
			for i = 0, table.Count( MEMORY.SubMaterials ) do
				Ent:SetSubMaterial( i, MEMORY.SubMaterials[i] )
			end
		end
		
		timer.Simple(0.5, function()
			if not IsValid(Ent) then return end
			local groups = string.Explode( ",", MEMORY.BodyGroups)
			for i = 1, table.Count( groups ) do
				Ent:SetBodygroup(i, tonumber(groups[i]) )
			end
			
			Ent:SetSkin( MEMORY.Skin )
			
			local c = string.Explode( ",", MEMORY.Color )
			local Color =  Color( tonumber(c[1]), tonumber(c[2]), tonumber(c[3]), tonumber(c[4]) )
			
			local dot = Color.r * Color.g * Color.b * Color.a
			Ent.OldColor = dot
			Ent:SetColor( Color )
			
			local data = {
				Color = Color,
				RenderMode = 0,
				RenderFX = 0
			}
			duplicator.StoreEntityModifier( Ent, "colour", data )
		end)
		
		Ent.uvclasstospawnon = uvnextclasstospawn

		table.insert(UVSimfphysVehicleInitializing, Ent)
		
	else
		PrintMessage( HUD_PRINTTALK, "Invalid Vehicle Base! Reverting to Default Vehicle Base! Please set the Vehicle Base in the Unit Manager Tool settings!")
		RunConsoleCommand("unitvehicle_traffic_vehiclebase", 1)
	end
	
end

function UVAutoSpawnRacer(ply)
	
	if not ply then
		ply = Entity(1)
	end
	
	local uvnextclasstospawn
	
	local enemylocation
	local suspect = ply
	enemylocation = (suspect:GetPos()+ (vector_up * 50))
	
	if next(dvd.Waypoints) == nil then
		if not UVNoDVWaypointsNotify then
			UVNoDVWaypointsNotify = true
			PrintMessage( HUD_PRINTTALK, "There's no Decent Vehicle waypoints to spawn vehicles! Download Decent Vehicle (if you haven't) and place some waypoints!")
		end
		return
	else

		UVNoDVWaypointsNotify = nil

		local waypointtable = {}
		local prioritywaypointtable = {}
		local prioritywaypointtable2 = {}
		for k, v in ipairs(dvd.Waypoints) do
			local Waypoint = v["Target"]
			local distance = enemylocation - Waypoint
			if distance:LengthSqr() > 25000000 and v["Group"] == 0 then
				table.insert(prioritywaypointtable, v)
			end
		end
		if next(prioritywaypointtable) ~= nil then
			uvspawnpointwaypoint = prioritywaypointtable[math.random(#prioritywaypointtable)]
			uvspawnpoint = uvspawnpointwaypoint["Target"]
		else
			uvspawnpointwaypoint = dvd.Waypoints[math.random(#dvd.Waypoints)]
			uvspawnpoint = uvspawnpointwaypoint["Target"]
		end
		local neighbor = dvd.Waypoints[uvspawnpointwaypoint.Neighbors[math.random(#uvspawnpointwaypoint.Neighbors)]]
		if neighbor then
			local neighborpoint = neighbor["Target"]
			local neighbordistance = neighborpoint - uvspawnpoint
			uvspawnpointangles = neighbordistance:Angle()+Angle(0,180,0)
		else
			uvspawnpointangles = Angle(0,math.random(0,360),0)
		end
	end
	
	local vehiclebase = 2
	
	if vehiclebase == 3 then --Glide
		
	elseif vehiclebase == 2 then --simfphys
		
		local RACERMEMORY = {}
		local racertable = file.Find("saved_vehicles/*.txt", "DATA")
		
		if not racertable then
			PrintMessage( HUD_PRINTTALK, "There's no saved vehicles on the simfphys duplicator to spawn!")
			return
		end
		
		local DataString = file.Read( "saved_vehicles/"..racertable[math.random(#racertable)], "DATA" )
		
		local words = string.Explode( "", DataString )
		local shit = {}
		
		for k, v in pairs( words ) do
			shit[k] =  string.char( string.byte( v ) - 20 )
		end
		
		local Data = string.Explode( "#", string.Implode("",shit) )
		
		for _,v in pairs(Data) do
			local Var = string.Explode( "=", v )
			local name = Var[1]
			local variable = Var[2]
			
			if name and variable then
				if name == "SubMaterials" then
					RACERMEMORY[name] = {}
					
					local submats = string.Explode( ",", variable )
					for i = 0, (table.Count( submats ) - 1) do
						RACERMEMORY[name][i] = submats[i+1]
					end
				else
					RACERMEMORY[name] = variable
				end
			end
		end
		
		if not istable(RACERMEMORY) then return end
		
		local Ent
		
		local vname = RACERMEMORY.SpawnName
		local VehicleList = list.Get( "simfphys_vehicles" )
		local vehicle = VehicleList[ vname ]
		
		if not vehicle then 
			PrintMessage( HUD_PRINTTALK, "The vehicle class '"..vname.."' dosen't seem to be installed!")
			return false 
		end
		
		local SpawnPos = uvspawnpoint + (vector_up * 50) + (vehicle.SpawnOffset or vector_origin)
		
		local SpawnAng = uvspawnpointangles
		SpawnAng.pitch = 0
		SpawnAng.yaw = SpawnAng.yaw + 180 + (vehicle.SpawnAngleOffset and vehicle.SpawnAngleOffset or 0)
		SpawnAng.roll = 0
		
		Ent = simfphys.SpawnVehicle( ply, SpawnPos, SpawnAng, vehicle.Model, vehicle.Class, vname, vehicle )
		
		if not IsValid( Ent ) then return end
		
		timer.Simple( 0.5, function()
			if not IsValid(Ent) then return end
			
			local tsc = string.Explode( ",", RACERMEMORY.TireSmokeColor )
			Ent:SetTireSmokeColor( Vector( tonumber(tsc[1]), tonumber(tsc[2]), tonumber(tsc[3]) ) )
			
			Ent.Turbocharged = tobool( RACERMEMORY.HasTurbo )
			Ent.Supercharged = tobool( RACERMEMORY.HasBlower )
			
			Ent:SetEngineSoundPreset( math.Clamp( tonumber( RACERMEMORY.SoundPreset ), -1, 23) )
			Ent:SetMaxTorque( math.Clamp( tonumber( RACERMEMORY.PeakTorque ), 20, 1000) )
			Ent:SetDifferentialGear( math.Clamp( tonumber( RACERMEMORY.FinalGear ),0.2, 6 ) )
			
			Ent:SetSteerSpeed( math.Clamp( tonumber( RACERMEMORY.SteerSpeed ), 1, 16 ) )
			Ent:SetFastSteerAngle( math.Clamp( tonumber( RACERMEMORY.SteerAngFast ), 0, 1) )
			Ent:SetFastSteerConeFadeSpeed( math.Clamp( tonumber( RACERMEMORY.SteerFadeSpeed ), 1, 5000 ) )
			
			Ent:SetEfficiency( math.Clamp( tonumber( RACERMEMORY.Efficiency ) ,0.2,4) )
			Ent:SetMaxTraction( math.Clamp( tonumber( RACERMEMORY.MaxTraction ) , 5,1000) )
			Ent:SetTractionBias( math.Clamp( tonumber( RACERMEMORY.GripOffset ),-0.99,0.99) )
			Ent:SetPowerDistribution( math.Clamp( tonumber( RACERMEMORY.PowerDistribution ) ,-1,1) )
			
			Ent:SetBackFire( tobool( RACERMEMORY.HasBackfire ) )
			Ent:SetDoNotStall( tobool( RACERMEMORY.DoesntStall ) )
			
			Ent:SetIdleRPM( math.Clamp( tonumber( RACERMEMORY.IdleRPM ),1,25000) )
			Ent:SetLimitRPM( math.Clamp( tonumber( RACERMEMORY.MaxRPM ),4,25000) )
			Ent:SetRevlimiter( tobool( RACERMEMORY.HasRevLimiter ) )
			Ent:SetPowerBandEnd( math.Clamp( tonumber( RACERMEMORY.PowerEnd ), 3, 25000) )
			Ent:SetPowerBandStart( math.Clamp( tonumber( RACERMEMORY.PowerStart ) ,2 ,25000) )
			
			Ent:SetTurboCharged( Ent.Turbocharged )
			Ent:SetSuperCharged( Ent.Supercharged )
			Ent:SetBrakePower( math.Clamp( tonumber( RACERMEMORY.BrakePower ), 0.1, 500) )
			
			Ent:SetSoundoverride( RACERMEMORY.SoundOverride or "" )
			
			Ent:SetLights_List( Ent.LightsTable or "no_lights" )
			
			Ent:SetBulletProofTires(true)
			
			Ent.snd_horn = RACERMEMORY.HornSound
			
			Ent.snd_blowoff = RACERMEMORY.snd_blowoff
			Ent.snd_spool = RACERMEMORY.snd_spool
			Ent.snd_bloweron = RACERMEMORY.snd_bloweron
			Ent.snd_bloweroff = RACERMEMORY.snd_bloweroff
			
			Ent:SetBackfireSound( RACERMEMORY.backfiresound or "" )
			
			local Gears = {}
			local Data = string.Explode( ",", RACERMEMORY.Gears  )
			for i = 1, table.Count( Data ) do 
				local gRatio = tonumber( Data[i] )
				
				if isnumber( gRatio ) then
					if i == 1 then
						Gears[i] = math.Clamp( gRatio, -5, -0.001)
						
					elseif i == 2 then
						Gears[i] = 0
						
					else
						Gears[i] = math.Clamp( gRatio, 0.001, 5)
					end
				end
			end
			Ent.Gears = Gears
			
			if istable( RACERMEMORY.SubMaterials ) then
				for i = 0, table.Count( RACERMEMORY.SubMaterials ) do
					Ent:SetSubMaterial( i, RACERMEMORY.SubMaterials[i] )
				end
			end
			
			if RACERMEMORY.FrontDampingOverride and RACERMEMORY.FrontConstantOverride and RACERMEMORY.RearDampingOverride and RACERMEMORY.RearConstantOverride then
				Ent.FrontDampingOverride = tonumber( RACERMEMORY.FrontDampingOverride )
				Ent.FrontConstantOverride = tonumber( RACERMEMORY.FrontConstantOverride )
				Ent.RearDampingOverride = tonumber( RACERMEMORY.RearDampingOverride )
				Ent.RearConstantOverride = tonumber( RACERMEMORY.RearConstantOverride )
				
				local data = {
					[1] = {Ent.FrontConstantOverride,Ent.FrontDampingOverride},
					[2] = {Ent.FrontConstantOverride,Ent.FrontDampingOverride},
					[3] = {Ent.RearConstantOverride,Ent.RearDampingOverride},
					[4] = {Ent.RearConstantOverride,Ent.RearDampingOverride},
					[5] = {Ent.RearConstantOverride,Ent.RearDampingOverride},
					[6] = {Ent.RearConstantOverride,Ent.RearDampingOverride}
				}
				
				local elastics = Ent.Elastics
				if elastics then
					for i = 1, table.Count( elastics ) do
						local elastic = elastics[i]
						if Ent.StrengthenSuspension == true then
							if IsValid( elastic ) then
								elastic:Fire( "SetSpringConstant", data[i][1] * 0.5, 0 )
								elastic:Fire( "SetSpringDamping", data[i][2] * 0.5, 0 )
							end
							local elastic2 = elastics[i * 10]
							if IsValid( elastic2 ) then
								elastic2:Fire( "SetSpringConstant", data[i][1] * 0.5, 0 )
								elastic2:Fire( "SetSpringDamping", data[i][2] * 0.5, 0 )
							end
						else
							if IsValid( elastic ) then
								elastic:Fire( "SetSpringConstant", data[i][1], 0 )
								elastic:Fire( "SetSpringDamping", data[i][2], 0 )
							end
						end
					end
				end
			end
			
			Ent:SetFrontSuspensionHeight( tonumber( RACERMEMORY.FrontHeight ) )
			Ent:SetRearSuspensionHeight( tonumber( RACERMEMORY.RearHeight ) )
			
			local groups = string.Explode( ",", RACERMEMORY.BodyGroups)
			for i = 1, table.Count( groups ) do
				Ent:SetBodygroup(i, tonumber(groups[i]) )
			end
			
			Ent:SetSkin( RACERMEMORY.Skin )
			
			local c = string.Explode( ",", RACERMEMORY.Color )
			local Color =  Color( tonumber(c[1]), tonumber(c[2]), tonumber(c[3]), tonumber(c[4]) )
			
			local dot = Color.r * Color.g * Color.b * Color.a
			Ent.OldColor = dot
			Ent:SetColor( Color )
			
			local data = {
				Color = Color,
				RenderMode = 0,
				RenderFX = 0
			}
			duplicator.StoreEntityModifier( Ent, "colour", data )
			
			if Ent.CustomWheels then
				if Ent.GhostWheels then
					if not IsValid( Ent ) then return end
					if RACERMEMORY.WheelTool_Foffset and RACERMEMORY.WheelTool_Roffset then
						SetWheelOffset( Ent, RACERMEMORY.WheelTool_Foffset, RACERMEMORY.WheelTool_Roffset )
					end
					
					if not RACERMEMORY.FrontWheelOverride and not RACERMEMORY.RearWheelOverride then return end
					
					local front_model = RACERMEMORY.FrontWheelOverride or vehicle.Members.CustomWheelModel
					local front_angle = GetAngleFromSpawnlist(front_model)
					
					local camber = RACERMEMORY.Camber or 0
					local rear_model = RACERMEMORY.RearWheelOverride or (vehicle.Members.CustomWheelModel_R and vehicle.Members.CustomWheelModel_R or front_model)
					local rear_angle = GetAngleFromSpawnlist(rear_model)
					
					if not front_model or not rear_model or not front_angle or not rear_angle then return end
					
					if ValidateModel( front_model ) and ValidateModel( rear_model ) then 
						Ent.Camber = camber
						ApplyWheel(Ent, {front_model,front_angle,rear_model,rear_angle,camber})
					else
						ply:PrintMessage( HUD_PRINTTALK, "selected wheel does not exist on the server")
					end
				end
			end
		end)
		
		
		Ent.uvclasstospawnon = "npc_racervehicle"
		
		table.insert(UVSimfphysVehicleInitializing, Ent)
		
		Ent:CallOnRemove( "UVSimfphysVehicleRemoved", function(car)
			if table.HasValue(UVSimfphysVehicleInitializing, car) then
				table.RemoveByValue(UVSimfphysVehicleInitializing, car)
			end
			if table.HasValue(UVCommanders, car) then
				table.RemoveByValue(UVCommanders, car)
			end
		end)
		
		timer.Simple(2, function() 
			if IsValid(Ent) and not Ent.RacerVehicle then
				Ent:Remove()
			else
				UVAddToWantedListVehicle(Ent)
			end
		end)
		
	elseif vehiclebase == 1 then --Default Vehicle Base
		
	else
		PrintMessage( HUD_PRINTTALK, "Invalid Vehicle Base! Reverting to Default Vehicle Base! Please set the Vehicle Base in the Unit Manager Tool settings!")
		RunConsoleCommand("unitvehicle_unit_vehiclebase", 1)
	end
end

--RACE FUNCTIONS

local function GetVehicleData( ent )
	if not ent:IsValid() then return end
	local Memory = {}
	
	if ent.IsSimfphyscar then
		Memory.VehicleBase = ent:GetClass()
		Memory.SpawnName = ent:GetSpawn_List()
		Memory.SteerSpeed = ent:GetSteerSpeed()
		Memory.SteerFadeSpeed = ent:GetFastSteerConeFadeSpeed()
		Memory.SteerAngFast = ent:GetFastSteerAngle()
		Memory.SoundPreset = ent:GetEngineSoundPreset()
		Memory.IdleRPM = ent:GetIdleRPM()
		Memory.MaxRPM = ent:GetLimitRPM()
		Memory.PowerStart = ent:GetPowerBandStart()
		Memory.PowerEnd = ent:GetPowerBandEnd()
		Memory.PeakTorque = ent:GetMaxTorque()
		Memory.HasTurbo = ent:GetTurboCharged()
		Memory.HasBlower = ent:GetSuperCharged()
		Memory.HasRevLimiter = ent:GetRevlimiter()
		Memory.HasBulletProofTires = ent:GetBulletProofTires()
		Memory.MaxTraction = ent:GetMaxTraction()
		Memory.GripOffset = ent:GetTractionBias()
		Memory.BrakePower = ent:GetBrakePower()
		Memory.PowerDistribution = ent:GetPowerDistribution()
		Memory.Efficiency = ent:GetEfficiency()
		Memory.HornSound = ent.snd_horn
		Memory.HasBackfire = ent:GetBackFire()
		Memory.DoesntStall = ent:GetDoNotStall()
		Memory.SoundOverride = ent:GetSoundoverride()
		Memory.AddedYaw = UVCheckIfRedlineSimfphys(ent) and 180 or 90
		
		Memory.FrontHeight = ent:GetFrontSuspensionHeight()
		Memory.RearHeight = ent:GetRearSuspensionHeight()
		
		Memory.Camber = ent.Camber or 0
		
		if ent.FrontDampingOverride and ent.FrontConstantOverride and ent.RearDampingOverride and ent.RearConstantOverride then
			Memory.FrontDampingOverride = ent.FrontDampingOverride
			Memory.FrontConstantOverride = ent.FrontConstantOverride
			Memory.RearDampingOverride = ent.RearDampingOverride
			Memory.RearConstantOverride = ent.RearConstantOverride
		end
		
		if ent.CustomWheels then
			if ent.GhostWheels then
				if IsValid(ent.GhostWheels[1]) then
					Memory.FrontWheelOverride = ent.GhostWheels[1]:GetModel()
				elseif IsValid(ent.GhostWheels[2]) then
					Memory.FrontWheelOverride = ent.GhostWheels[2]:GetModel()
				end
				
				if IsValid(ent.GhostWheels[3]) then
					Memory.RearWheelOverride = ent.GhostWheels[3]:GetModel()
				elseif IsValid(ent.GhostWheels[4]) then
					Memory.RearWheelOverride = ent.GhostWheels[4]:GetModel()
				end
			end
		end
		
		local tsc = ent:GetTireSmokeColor()
		Memory.TireSmokeColor = tsc.r..","..tsc.g..","..tsc.b
		
		local Gears = ""
		for _,v in pairs(ent.Gears) do
			Gears = Gears..v..","
		end
		
		local c = ent:GetColor()
		Memory.Color = c.r..","..c.g..","..c.b..","..c.a
		
		local bodygroups = {}
		for k,v in pairs(ent:GetBodyGroups()) do
			bodygroups[k] = ent:GetBodygroup( k ) 
		end
		
		Memory.BodyGroups = string.Implode( ",", bodygroups)
		
		Memory.Skin = ent:GetSkin()
		
		Memory.Gears = Gears
		Memory.FinalGear = ent:GetDifferentialGear()
		
		if ent.WheelTool_Foffset then
			Memory.WheelTool_Foffset = ent.WheelTool_Foffset
		end
		
		if ent.WheelTool_Roffset then
			Memory.WheelTool_Roffset = ent.WheelTool_Roffset
		end
		
		if ent.snd_blowoff then
			Memory.snd_blowoff = ent.snd_blowoff
		end
		
		if ent.snd_spool then
			Memory.snd_spool = ent.snd_spool
		end
		
		if ent.snd_bloweron then
			Memory.snd_bloweron = ent.snd_bloweron
		end
		
		if ent.snd_bloweroff then
			Memory.snd_bloweroff = ent.snd_bloweroff
		end
		
		Memory.backfiresound = ent:GetBackfireSound()
		
		Memory.SubMaterials = {}
		for i = 0, (table.Count( ent:GetMaterials() ) - 1) do
			Memory.SubMaterials[i] = ent:GetSubMaterial( i )
		end
	elseif ent.IsGlideVehicle then
		local pos = ent:GetPos()
		duplicator.SetLocalPos( pos )
		
		Memory = duplicator.Copy( ent )
		
		duplicator.SetLocalPos( vector_origin )
		duplicator.SetLocalAng( angle_zero )
		
		if ( not Memory ) then return false end
		
		local Key = "VehicleBase"
		Memory[Key] = ent.Base
		local Key2 = "SpawnName"
		Memory[Key2] = ent:GetClass()
		Memory.Mins = Vector(Memory.Mins.x,Memory.Mins.y,0)

		-- TODO: 
		-- Vehicles with spoilers attached via Bonemerge are currently not supported and will result in an error due to the code below.
		
		Memory.Entities[next(Memory.Entities)].Angle = Angle(0,180,0)
		Memory.Entities[next(Memory.Entities)].PhysicsObjects[0].Angle = Angle(0,180,0)
		
		local c = ent:GetColor()
		Memory.Color = c.r..","..c.g..","..c.b..","..c.a
		
		local bodygroups = {}
		for k,v in pairs(ent:GetBodyGroups()) do
			bodygroups[k] = ent:GetBodygroup( k ) 
		end
		
		Memory.BodyGroups = string.Implode( ",", bodygroups)
		
		Memory.Skin = ent:GetSkin()
		
		Memory.SubMaterials = {}
		for i = 0, (table.Count( ent:GetMaterials() ) - 1) do
			Memory.SubMaterials[i] = ent:GetSubMaterial( i )
		end

		if cffunctions then
			Memory.NitrousPower = ent.NitrousPower or 2
			Memory.NitrousDepletionRate = ent.NitrousDepletionRate or 0.5
			Memory.NitrousRegenRate = ent.NitrousRegenRate or 0.1
			Memory.NitrousRegenDelay = ent.NitrousRegenDelay or 2
			Memory.NitrousPitchChangeFrequency = ent.NitrousPitchChangeFrequency or 1 
			Memory.NitrousPitchMultiplier = ent.NitrousPitchMultiplier or 0.2
			Memory.NitrousBurst = ent.NitrousBurst or false
			Memory.NitrousColor = ent.NitrousColor or Color(35, 204, 255)
			Memory.NitrousStartSound = ent.NitrousStartSound or "glide_nitrous/nitrous_burst.wav"
			Memory.NitrousLoopingSound = ent.NitrousLoopingSound or "glide_nitrous/nitrous_burst.wav"
			Memory.NitrousEndSound = ent.NitrousEndSound or "glide_nitrous/nitrous_activation_whine.wav"
			Memory.NitrousEmptySound = ent.NitrousEmptySound or "glide_nitrous/nitrous_empty.wav"
			Memory.NitrousReadyBurstSound = ent.NitrousReadyBurstSound or "glide_nitrous/nitrous_burst/ready/ready.wav"
			Memory.NitrousStartBurstSound = ent.NitrousStartBurstSound or file.Find("sound/glide_nitrous/nitrous_burst/*", "GAME")
			Memory.NitrousStartBurstAnnotationSound = ent.NitrousStartBurstAnnotationSound or file.Find("sound/glide_nitrous/nitrous_burst/annotation/*", "GAME")
			Memory.CriticalDamageSound = ent.CriticalDamageSound or "glide_healthbar/criticaldamage.wav"
		end
		
	elseif ent:GetClass() == "prop_vehicle_jeep" then
		Memory.VehicleBase = ent:GetClass()
		Memory.SpawnName = ent:GetVehicleClass()
		
		if not Memory.SpawnName then 
			print("This vehicle dosen't have a vehicle class set" )
			return 
		end
		
		local c = ent:GetColor()
		Memory.Color = c.r..","..c.g..","..c.b..","..c.a
		
		local bodygroups = {}
		for k,v in pairs(ent:GetBodyGroups()) do
			bodygroups[k] = ent:GetBodygroup( k ) 
		end
		
		Memory.BodyGroups = string.Implode( ",", bodygroups)
		
		Memory.Skin = ent:GetSkin()
		
		Memory.SubMaterials = {}
		for i = 0, (table.Count( ent:GetMaterials() ) - 1) do
			Memory.SubMaterials[i] = ent:GetSubMaterial( i )
		end
	end
	
	return Memory
	
end

function UVTeleportSimfphysVehicle( vehicle, pos, ang )
	local entrantvehicle = vehicle
	local PT = (vehicle.PursuitTech and table.Copy(vehicle.PursuitTech))
	
	local Memory = GetVehicleData( vehicle )
	
	local driver = vehicle:GetDriver()
	local ply = (IsValid(driver) and driver)
	
	local aienabled = not (driver and driver:IsPlayer())
	
	local racer_name = (ply and ply:GetName()) or (vehicle.racer or "Racer "..vehicle:EntIndex())
	
	ply = ply or Entity(1)
	
	local vname = Memory.SpawnName
	local Update = false
	local VehicleList = list.Get( "simfphys_vehicles" )
	local vehicle = VehicleList[ vname ]
	
	if not vehicle then return false end
	
	local SpawnPos = pos + (vector_up * 25) + (vehicle.SpawnOffset or vector_origin)
	
	local SpawnAng = ang
	SpawnAng.pitch = 0
	SpawnAng.yaw = SpawnAng.yaw  + 270 + (vehicle.SpawnAngleOffset and vehicle.SpawnAngleOffset or 0)
	SpawnAng.roll = 0
	
	Ent = simfphys.SpawnVehicle( ply, SpawnPos, SpawnAng, vehicle.Model, vehicle.Class, vname, vehicle )
	
	if not IsValid( Ent ) then return end
	
	undo.Create( "Vehicle" )
	undo.SetPlayer( ply )
	undo.AddEntity( Ent )
	undo.SetCustomUndoText( "Undone " .. vehicle.Name )
	undo.Finish( "Vehicle (" .. tostring( vehicle.Name ) .. ")" )
	
	ply:AddCleanup( "vehicles", Ent )
	
	timer.Simple( 0.5, function()
		if not IsValid(Ent) then return end
		
		local tsc = string.Explode( ",", Memory.TireSmokeColor )
		Ent:SetTireSmokeColor( Vector( tonumber(tsc[1]), tonumber(tsc[2]), tonumber(tsc[3]) ) )
		
		Ent.Turbocharged = tobool( Memory.HasTurbo )
		Ent.Supercharged = tobool( Memory.HasBlower )
		
		Ent:SetEngineSoundPreset( math.Clamp( tonumber( Memory.SoundPreset ), -1, 23) )
		Ent:SetMaxTorque( math.Clamp( tonumber( Memory.PeakTorque ), 20, 1000) )
		Ent:SetDifferentialGear( math.Clamp( tonumber( Memory.FinalGear ),0.2, 6 ) )
		
		Ent:SetSteerSpeed( math.Clamp( tonumber( Memory.SteerSpeed ), 1, 16 ) )
		Ent:SetFastSteerAngle( math.Clamp( tonumber( Memory.SteerAngFast ), 0, 1) )
		Ent:SetFastSteerConeFadeSpeed( math.Clamp( tonumber( Memory.SteerFadeSpeed ), 1, 5000 ) )
		
		Ent:SetEfficiency( math.Clamp( tonumber( Memory.Efficiency ) ,0.2,4) )
		Ent:SetMaxTraction( math.Clamp( tonumber( Memory.MaxTraction ) , 5,1000) )
		Ent:SetTractionBias( math.Clamp( tonumber( Memory.GripOffset ),-0.99,0.99) )
		Ent:SetPowerDistribution( math.Clamp( tonumber( Memory.PowerDistribution ) ,-1,1) )
		
		Ent:SetBackFire( tobool( Memory.HasBackfire ) )
		Ent:SetDoNotStall( tobool( Memory.DoesntStall ) )
		
		Ent:SetIdleRPM( math.Clamp( tonumber( Memory.IdleRPM ),1,25000) )
		Ent:SetLimitRPM( math.Clamp( tonumber( Memory.MaxRPM ),4,25000) )
		Ent:SetRevlimiter( tobool( Memory.HasRevLimiter ) )
		Ent:SetPowerBandEnd( math.Clamp( tonumber( Memory.PowerEnd ), 3, 25000) )
		Ent:SetPowerBandStart( math.Clamp( tonumber( Memory.PowerStart ) ,2 ,25000) )
		
		Ent:SetTurboCharged( Ent.Turbocharged )
		Ent:SetSuperCharged( Ent.Supercharged )
		Ent:SetBrakePower( math.Clamp( tonumber( Memory.BrakePower ), 0.1, 500) )
		
		Ent:SetSoundoverride( Memory.SoundOverride or "" )
		
		Ent:SetLights_List( Ent.LightsTable or "no_lights" )
		
		Ent:SetBulletProofTires(true)
		
		Ent.snd_horn = Memory.HornSound
		
		Ent.snd_blowoff = Memory.snd_blowoff
		Ent.snd_spool = Memory.snd_spool
		Ent.snd_bloweron = Memory.snd_bloweron
		Ent.snd_bloweroff = Memory.snd_bloweroff
		
		Ent:SetBackfireSound( Memory.backfiresound or "" )
		
		local Gears = {}
		local Data = string.Explode( ",", Memory.Gears  )
		for i = 1, table.Count( Data ) do 
			local gRatio = tonumber( Data[i] )
			
			if isnumber( gRatio ) then
				if i == 1 then
					Gears[i] = math.Clamp( gRatio, -5, -0.001)
					
				elseif i == 2 then
					Gears[i] = 0
					
				else
					Gears[i] = math.Clamp( gRatio, 0.001, 5)
				end
			end
		end
		Ent.Gears = Gears
		
		if istable( Memory.SubMaterials ) then
			for i = 0, table.Count( Memory.SubMaterials ) do
				Ent:SetSubMaterial( i, Memory.SubMaterials[i] )
			end
		end
		
		if Memory.FrontDampingOverride and Memory.FrontConstantOverride and Memory.RearDampingOverride and Memory.RearConstantOverride then
			Ent.FrontDampingOverride = tonumber( Memory.FrontDampingOverride )
			Ent.FrontConstantOverride = tonumber( Memory.FrontConstantOverride )
			Ent.RearDampingOverride = tonumber( Memory.RearDampingOverride )
			Ent.RearConstantOverride = tonumber( Memory.RearConstantOverride )
			
			local data = {
				[1] = {Ent.FrontConstantOverride,Ent.FrontDampingOverride},
				[2] = {Ent.FrontConstantOverride,Ent.FrontDampingOverride},
				[3] = {Ent.RearConstantOverride,Ent.RearDampingOverride},
				[4] = {Ent.RearConstantOverride,Ent.RearDampingOverride},
				[5] = {Ent.RearConstantOverride,Ent.RearDampingOverride},
				[6] = {Ent.RearConstantOverride,Ent.RearDampingOverride}
			}
			
			local elastics = Ent.Elastics
			if elastics then
				for i = 1, table.Count( elastics ) do
					local elastic = elastics[i]
					if Ent.StrengthenSuspension == true then
						if IsValid( elastic ) then
							elastic:Fire( "SetSpringConstant", data[i][1] * 0.5, 0 )
							elastic:Fire( "SetSpringDamping", data[i][2] * 0.5, 0 )
						end
						local elastic2 = elastics[i * 10]
						if IsValid( elastic2 ) then
							elastic2:Fire( "SetSpringConstant", data[i][1] * 0.5, 0 )
							elastic2:Fire( "SetSpringDamping", data[i][2] * 0.5, 0 )
						end
					else
						if IsValid( elastic ) then
							elastic:Fire( "SetSpringConstant", data[i][1], 0 )
							elastic:Fire( "SetSpringDamping", data[i][2], 0 )
						end
					end
				end
			end
		end
		
		Ent:SetFrontSuspensionHeight( tonumber( Memory.FrontHeight ) )
		Ent:SetRearSuspensionHeight( tonumber( Memory.RearHeight ) )
		
		local groups = string.Explode( ",", Memory.BodyGroups)
		for i = 1, table.Count( groups ) do
			Ent:SetBodygroup(i, tonumber(groups[i]) )
		end
		
		Ent:SetSkin( Memory.Skin )
		
		local c = string.Explode( ",", Memory.Color )
		local Color =  Color( tonumber(c[1]), tonumber(c[2]), tonumber(c[3]), tonumber(c[4]) )
		
		local dot = Color.r * Color.g * Color.b * Color.a
		Ent.OldColor = dot
		Ent:SetColor( Color )
		
		local data = {
			Color = Color,
			RenderMode = 0,
			RenderFX = 0
		}
		duplicator.StoreEntityModifier( Ent, "colour", data )
		
		if Update then
			local PhysObj = Ent:GetPhysicsObject()
			if not IsValid( PhysObj ) then return end
			
			local freezeWhenDone = PhysObj:IsMotionEnabled()
			local freezeWheels = {}
			PhysObj:EnableMotion( false )
			Ent:SetNotSolid( true )
			
			local ResetPos = Ent:GetPos()
			local ResetAng = Ent:GetAngles()
			
			Ent:SetPos( ResetPos + Vector(0,0,30) )
			Ent:SetAngles( Angle(0,ResetAng.y,0) )
			
			for i = 1, table.Count( Ent.Wheels ) do
				local Wheel = Ent.Wheels[ i ]
				if IsValid( Wheel ) then
					local wPObj = Wheel:GetPhysicsObject()
					
					if IsValid( wPObj ) then
						freezeWheels[ i ] = {}
						freezeWheels[ i ].dofreeze = wPObj:IsMotionEnabled()
						freezeWheels[ i ].pos = Wheel:GetPos()
						freezeWheels[ i ].ang = Wheel:GetAngles()
						Wheel:SetNotSolid( true )
						wPObj:EnableMotion( true ) 
						wPObj:Wake() 
					end
				end
			end
			
			timer.Simple( 0.5, function()
				if not IsValid( Ent ) then return end
				if not IsValid( PhysObj ) then return end
				
				PhysObj:EnableMotion( freezeWhenDone )
				Ent:SetNotSolid( false )
				Ent:SetPos( ResetPos )
				Ent:SetAngles( ResetAng )
				
				for i = 1, table.Count( freezeWheels ) do
					local Wheel = Ent.Wheels[ i ]
					if IsValid( Wheel ) then
						local wPObj = Wheel:GetPhysicsObject()
						
						Wheel:SetNotSolid( false )
						
						if IsValid( wPObj ) then
							wPObj:EnableMotion( freezeWheels[i].dofreeze ) 
						end
						
						Wheel:SetPos( freezeWheels[ i ].pos )
						Wheel:SetAngles( freezeWheels[ i ].ang )
					end
				end
			end)
		end
		
		if Ent.CustomWheels then
			if Ent.GhostWheels then
				timer.Simple( Update and 0.25 or 0, function()
					if not IsValid( Ent ) then return end
					if Memory.WheelTool_Foffset and Memory.WheelTool_Roffset then
						SetWheelOffset( Ent, Memory.WheelTool_Foffset, Memory.WheelTool_Roffset )
					end
					
					if not Memory.FrontWheelOverride and not Memory.RearWheelOverride then return end
					
					local front_model = Memory.FrontWheelOverride or vehicle.Members.CustomWheelModel
					local front_angle = GetAngleFromSpawnlist(front_model)
					
					local camber = Memory.Camber or 0
					local rear_model = Memory.RearWheelOverride or (vehicle.Members.CustomWheelModel_R and vehicle.Members.CustomWheelModel_R or front_model)
					local rear_angle = GetAngleFromSpawnlist(rear_model)
					
					if not front_model or not rear_model or not front_angle or not rear_angle then return end
					
					if ValidateModel( front_model ) and ValidateModel( rear_model ) then 
						Ent.Camber = camber
						ApplyWheel(Ent, {front_model,front_angle,rear_model,rear_angle,camber})
					else
						ply:PrintMessage( HUD_PRINTTALK, "selected wheel does not exist on the server")
					end
				end)
			end
		end
	end)
	
	UVRaceReplaceParticipant( entrantvehicle, Ent )
	
	timer.Simple(1, function()
		entrantvehicle:Remove()
	end)
	
	Ent.racer = racer_name
	
	if aienabled then 
		Ent.uvclasstospawnon = "npc_racervehicle"
	end
	
	if PT then
		Ent.PursuitTech = PT
	end
	
	if Ent.PursuitTech then
		table.insert(UVRVWithPursuitTech, Ent)
		
		for i=1,2 do
			UVReplicatePT( Ent, i )
		end
	end
	
	Ent:CallOnRemove( "UVRVWithPursuitTechRemoved", function(Ent)
		if table.HasValue(UVRVWithPursuitTech, Ent) then
			table.RemoveByValue(UVRVWithPursuitTech, Ent)
		end
	end)
	
	timer.Simple( .5, function()
		if IsValid(Ent) then
			if aienabled then 
				
				local uv = ents.Create(Ent.uvclasstospawnon)
				uv:SetPos(Ent:GetPos())
				uv.uvscripted = true
				uv.vehicle = Ent
				uv:Spawn()
				uv:Activate()
				ply = uv
				
			else
				if Ent.IsSimfphyscar then
					ply:EnterVehicle( Ent.DriverSeat )
				elseif Ent.IsGlideVehicle then
					local seat = Ent.seats[1]
					if IsValid(seat) then
						ply:EnterVehicle(seat)
					end
				elseif Ent:GetClass() == "prop_vehicle_jeep" then
					ply:EnterVehicle(Ent)
				end
			end
		end
	end)
	
	return Ent
end

function UVMoveToGridSlot( vehicle, aienabled )
	local entrantvehicle = vehicle
	local PT = (vehicle.PursuitTech and table.Copy(vehicle.PursuitTech))
	
	local Memory = GetVehicleData( vehicle )
	
	local driver = vehicle:GetDriver()
	local ply = (IsValid(driver) and driver)
	
	local racer_name = (ply and ply:GetName()) or (vehicle.racer or "Racer "..vehicle:EntIndex())
	
	ply = ply or Entity(1)
	
	local spawns = ents.FindByClass("uvrace_spawn")
	local spawn
	if next(spawns) == nil then
		PrintMessage( HUD_PRINTTALK, "No race spawn points found!")
		return nil
	else
		--Look for a spawn point that has the lowest GridSlot value and claim it
		local lowestGridSlot = math.huge
		for k, v in pairs(spawns) do
			if v:GetGridSlot() < lowestGridSlot and not v.claimed then
				lowestGridSlot = v:GetGridSlot()
				spawn = v
			end
		end
	end
	
	if not spawn then
		PrintMessage( HUD_PRINTTALK, "No positions left for "..racer_name)
		return nil
	end
	
	local pos = spawn:GetPos()
	local ang = spawn:GetAngles()
	
	local Ent
	
	if Memory.VehicleBase == "gmod_sent_vehicle_fphysics_base" then
		local vname = Memory.SpawnName
		local Update = false
		local VehicleList = list.Get( "simfphys_vehicles" )
		local vehicle = VehicleList[ vname ]
		
		if not vehicle then return false end
		
		local SpawnPos = pos + (vector_up * 25) + (vehicle.SpawnOffset or vector_origin)
		
		local SpawnAng = ang
		SpawnAng.pitch = 0
		SpawnAng.yaw = SpawnAng.yaw + Memory.AddedYaw + (vehicle.SpawnAngleOffset and vehicle.SpawnAngleOffset or 0)
		SpawnAng.roll = 0
		
		Ent = simfphys.SpawnVehicle( ply, SpawnPos, SpawnAng, vehicle.Model, vehicle.Class, vname, vehicle )
		
		if not IsValid( Ent ) then return end
		
		undo.Create( "Vehicle" )
		undo.SetPlayer( ply )
		undo.AddEntity( Ent )
		undo.SetCustomUndoText( "Undone " .. vehicle.Name )
		undo.Finish( "Vehicle (" .. tostring( vehicle.Name ) .. ")" )
		
		ply:AddCleanup( "vehicles", Ent )
		
		timer.Simple( 0.5, function()
			if not IsValid(Ent) then return end
			
			local tsc = string.Explode( ",", Memory.TireSmokeColor )
			Ent:SetTireSmokeColor( Vector( tonumber(tsc[1]), tonumber(tsc[2]), tonumber(tsc[3]) ) )
			
			Ent.Turbocharged = tobool( Memory.HasTurbo )
			Ent.Supercharged = tobool( Memory.HasBlower )
			
			Ent:SetEngineSoundPreset( math.Clamp( tonumber( Memory.SoundPreset ), -1, 23) )
			Ent:SetMaxTorque( math.Clamp( tonumber( Memory.PeakTorque ), 20, 1000) )
			Ent:SetDifferentialGear( math.Clamp( tonumber( Memory.FinalGear ),0.2, 6 ) )
			
			Ent:SetSteerSpeed( math.Clamp( tonumber( Memory.SteerSpeed ), 1, 16 ) )
			Ent:SetFastSteerAngle( math.Clamp( tonumber( Memory.SteerAngFast ), 0, 1) )
			Ent:SetFastSteerConeFadeSpeed( math.Clamp( tonumber( Memory.SteerFadeSpeed ), 1, 5000 ) )
			
			Ent:SetEfficiency( math.Clamp( tonumber( Memory.Efficiency ) ,0.2,4) )
			Ent:SetMaxTraction( math.Clamp( tonumber( Memory.MaxTraction ) , 5,1000) )
			Ent:SetTractionBias( math.Clamp( tonumber( Memory.GripOffset ),-0.99,0.99) )
			Ent:SetPowerDistribution( math.Clamp( tonumber( Memory.PowerDistribution ) ,-1,1) )
			
			Ent:SetBackFire( tobool( Memory.HasBackfire ) )
			Ent:SetDoNotStall( tobool( Memory.DoesntStall ) )
			
			Ent:SetIdleRPM( math.Clamp( tonumber( Memory.IdleRPM ),1,25000) )
			Ent:SetLimitRPM( math.Clamp( tonumber( Memory.MaxRPM ),4,25000) )
			Ent:SetRevlimiter( tobool( Memory.HasRevLimiter ) )
			Ent:SetPowerBandEnd( math.Clamp( tonumber( Memory.PowerEnd ), 3, 25000) )
			Ent:SetPowerBandStart( math.Clamp( tonumber( Memory.PowerStart ) ,2 ,25000) )
			
			Ent:SetTurboCharged( Ent.Turbocharged )
			Ent:SetSuperCharged( Ent.Supercharged )
			Ent:SetBrakePower( math.Clamp( tonumber( Memory.BrakePower ), 0.1, 500) )
			
			Ent:SetSoundoverride( Memory.SoundOverride or "" )
			
			Ent:SetLights_List( Ent.LightsTable or "no_lights" )
			
			Ent:SetBulletProofTires(true)
			
			Ent.snd_horn = Memory.HornSound
			
			Ent.snd_blowoff = Memory.snd_blowoff
			Ent.snd_spool = Memory.snd_spool
			Ent.snd_bloweron = Memory.snd_bloweron
			Ent.snd_bloweroff = Memory.snd_bloweroff
			
			Ent:SetBackfireSound( Memory.backfiresound or "" )
			
			local Gears = {}
			local Data = string.Explode( ",", Memory.Gears  )
			for i = 1, table.Count( Data ) do 
				local gRatio = tonumber( Data[i] )
				
				if isnumber( gRatio ) then
					if i == 1 then
						Gears[i] = math.Clamp( gRatio, -5, -0.001)
						
					elseif i == 2 then
						Gears[i] = 0
						
					else
						Gears[i] = math.Clamp( gRatio, 0.001, 5)
					end
				end
			end
			Ent.Gears = Gears
			
			if istable( Memory.SubMaterials ) then
				for i = 0, table.Count( Memory.SubMaterials ) do
					Ent:SetSubMaterial( i, Memory.SubMaterials[i] )
				end
			end
			
			if Memory.FrontDampingOverride and Memory.FrontConstantOverride and Memory.RearDampingOverride and Memory.RearConstantOverride then
				Ent.FrontDampingOverride = tonumber( Memory.FrontDampingOverride )
				Ent.FrontConstantOverride = tonumber( Memory.FrontConstantOverride )
				Ent.RearDampingOverride = tonumber( Memory.RearDampingOverride )
				Ent.RearConstantOverride = tonumber( Memory.RearConstantOverride )
				
				local data = {
					[1] = {Ent.FrontConstantOverride,Ent.FrontDampingOverride},
					[2] = {Ent.FrontConstantOverride,Ent.FrontDampingOverride},
					[3] = {Ent.RearConstantOverride,Ent.RearDampingOverride},
					[4] = {Ent.RearConstantOverride,Ent.RearDampingOverride},
					[5] = {Ent.RearConstantOverride,Ent.RearDampingOverride},
					[6] = {Ent.RearConstantOverride,Ent.RearDampingOverride}
				}
				
				local elastics = Ent.Elastics
				if elastics then
					for i = 1, table.Count( elastics ) do
						local elastic = elastics[i]
						if Ent.StrengthenSuspension == true then
							if IsValid( elastic ) then
								elastic:Fire( "SetSpringConstant", data[i][1] * 0.5, 0 )
								elastic:Fire( "SetSpringDamping", data[i][2] * 0.5, 0 )
							end
							local elastic2 = elastics[i * 10]
							if IsValid( elastic2 ) then
								elastic2:Fire( "SetSpringConstant", data[i][1] * 0.5, 0 )
								elastic2:Fire( "SetSpringDamping", data[i][2] * 0.5, 0 )
							end
						else
							if IsValid( elastic ) then
								elastic:Fire( "SetSpringConstant", data[i][1], 0 )
								elastic:Fire( "SetSpringDamping", data[i][2], 0 )
							end
						end
					end
				end
			end
			
			Ent:SetFrontSuspensionHeight( tonumber( Memory.FrontHeight ) )
			Ent:SetRearSuspensionHeight( tonumber( Memory.RearHeight ) )
			
			local groups = string.Explode( ",", Memory.BodyGroups)
			for i = 1, table.Count( groups ) do
				Ent:SetBodygroup(i, tonumber(groups[i]) )
			end
			
			Ent:SetSkin( Memory.Skin )
			
			local c = string.Explode( ",", Memory.Color )
			local Color =  Color( tonumber(c[1]), tonumber(c[2]), tonumber(c[3]), tonumber(c[4]) )
			
			local dot = Color.r * Color.g * Color.b * Color.a
			Ent.OldColor = dot
			Ent:SetColor( Color )
			
			local data = {
				Color = Color,
				RenderMode = 0,
				RenderFX = 0
			}
			duplicator.StoreEntityModifier( Ent, "colour", data )
			
			if Update then
				local PhysObj = Ent:GetPhysicsObject()
				if not IsValid( PhysObj ) then return end
				
				local freezeWhenDone = PhysObj:IsMotionEnabled()
				local freezeWheels = {}
				PhysObj:EnableMotion( false )
				Ent:SetNotSolid( true )
				
				local ResetPos = Ent:GetPos()
				local ResetAng = Ent:GetAngles()
				
				Ent:SetPos( ResetPos + Vector(0,0,30) )
				Ent:SetAngles( Angle(0,ResetAng.y,0) )
				
				for i = 1, table.Count( Ent.Wheels ) do
					local Wheel = Ent.Wheels[ i ]
					if IsValid( Wheel ) then
						local wPObj = Wheel:GetPhysicsObject()
						
						if IsValid( wPObj ) then
							freezeWheels[ i ] = {}
							freezeWheels[ i ].dofreeze = wPObj:IsMotionEnabled()
							freezeWheels[ i ].pos = Wheel:GetPos()
							freezeWheels[ i ].ang = Wheel:GetAngles()
							Wheel:SetNotSolid( true )
							wPObj:EnableMotion( true ) 
							wPObj:Wake() 
						end
					end
				end
				
				timer.Simple( 0.5, function()
					if not IsValid( Ent ) then return end
					if not IsValid( PhysObj ) then return end
					
					PhysObj:EnableMotion( freezeWhenDone )
					Ent:SetNotSolid( false )
					Ent:SetPos( ResetPos )
					Ent:SetAngles( ResetAng )
					
					for i = 1, table.Count( freezeWheels ) do
						local Wheel = Ent.Wheels[ i ]
						if IsValid( Wheel ) then
							local wPObj = Wheel:GetPhysicsObject()
							
							Wheel:SetNotSolid( false )
							
							if IsValid( wPObj ) then
								wPObj:EnableMotion( freezeWheels[i].dofreeze ) 
							end
							
							Wheel:SetPos( freezeWheels[ i ].pos )
							Wheel:SetAngles( freezeWheels[ i ].ang )
						end
					end
				end)
			end
			
			if Ent.CustomWheels then
				if Ent.GhostWheels then
					timer.Simple( Update and 0.25 or 0, function()
						if not IsValid( Ent ) then return end
						if Memory.WheelTool_Foffset and Memory.WheelTool_Roffset then
							SetWheelOffset( Ent, Memory.WheelTool_Foffset, Memory.WheelTool_Roffset )
						end
						
						if not Memory.FrontWheelOverride and not Memory.RearWheelOverride then return end
						
						local front_model = Memory.FrontWheelOverride or vehicle.Members.CustomWheelModel
						local front_angle = GetAngleFromSpawnlist(front_model)
						
						local camber = Memory.Camber or 0
						local rear_model = Memory.RearWheelOverride or (vehicle.Members.CustomWheelModel_R and vehicle.Members.CustomWheelModel_R or front_model)
						local rear_angle = GetAngleFromSpawnlist(rear_model)
						
						if not front_model or not rear_model or not front_angle or not rear_angle then return end
						
						if ValidateModel( front_model ) and ValidateModel( rear_model ) then 
							Ent.Camber = camber
							ApplyWheel(Ent, {front_model,front_angle,rear_model,rear_angle,camber})
						else
							ply:PrintMessage( HUD_PRINTTALK, "selected wheel does not exist on the server")
						end
					end)
				end
			end
		end)
		
	elseif Memory.VehicleBase == "base_glide_car" or Memory.VehicleBase == "base_glide_motorcycle" or Memory.VehicleBase == "base_glide_boat" or Memory.VehicleBase == "base_glide_aircraft" or Memory.VehicleBase == "base_glide_heli" or Memory.VehicleBase == "base_glide_plane" then
		local SpawnCenter = pos + (vector_up * 25)
		SpawnCenter.z = SpawnCenter.z - Memory.Mins.z
		
		duplicator.SetLocalPos( SpawnCenter )
		duplicator.SetLocalAng( Angle( 0, ang.yaw, 0 ) )
		
		local Ents = duplicator.Paste( ply, Memory.Entities, Memory.Constraints )
		Ent = Ents[next(Ents)]
		
		if not IsValid( Ent ) then 
			PrintMessage( HUD_PRINTTALK, "The vehicle ".. Memory.SpawnName .." dosen't seem to be installed!" )
			return 
		end
		
		duplicator.SetLocalPos( vector_origin )
		duplicator.SetLocalAng( angle_zero )
		
		undo.Create( "Duplicator" )
		
		if Memory.SubMaterials then
			if istable( Memory.SubMaterials ) then
				for i = 0, table.Count( Memory.SubMaterials ) do
					Ent:SetSubMaterial( i, Memory.SubMaterials[i] )
				end
			end
			
			local groups = string.Explode( ",", Memory.BodyGroups)
			for i = 1, table.Count( groups ) do
				Ent:SetBodygroup(i, tonumber(groups[i]) )
			end
			
			Ent:SetSkin( Memory.Skin )
			
			local c = string.Explode( ",", Memory.Color )
			local Color =  Color( tonumber(c[1]), tonumber(c[2]), tonumber(c[3]), tonumber(c[4]) )
			
			local dot = Color.r * Color.g * Color.b * Color.a
			Ent.OldColor = dot
			Ent:SetColor( Color )
			
			local data = {
				Color = Color,
				RenderMode = 0,
				RenderFX = 0
			}
			duplicator.StoreEntityModifier( Ent, "colour", data )
			
			if isfunction(Ent.Repair) then
				Ent:Repair()
			end
		end
		
		for k, ent in pairs( Ents ) do
			undo.AddEntity( ent )
		end
		
		for k, ent in pairs( Ents )	do
			ply:AddCleanup( "duplicates", ent )
		end
		
		undo.SetPlayer( ply )
		undo.SetCustomUndoText( "Undone Glide" )
		
		undo.Finish( "Undo (" .. tostring( table.Count( Ents ) ) ..  ")" )

		if cffunctions then
			Ent.NitrousPower = Memory.NitrousPower
			Ent.NitrousDepletionRate = Memory.NitrousDepletionRate
			Ent.NitrousRegenRate = Memory.NitrousRegenRate
			Ent.NitrousRegenDelay = Memory.NitrousRegenDelay
			Ent.NitrousPitchChangeFrequency = Memory.NitrousPitchChangeFrequency
			Ent.NitrousPitchMultiplier = Memory.NitrousPitchMultiplier
			Ent.NitrousBurst = Memory.NitrousBurst
			Ent.NitrousColor = Memory.NitrousColor
			Ent.NitrousStartSound = Memory.NitrousStartSound
			Ent.NitrousLoopingSound = Memory.NitrousLoopingSound
			Ent.NitrousEndSound = Memory.NitrousEndSound
			Ent.NitrousEmptySound = Memory.NitrousEmptySound
			Ent.NitrousReadyBurstSound = Memory.NitrousReadyBurstSound
			Ent.NitrousStartBurstSound = Memory.NitrousStartBurstSound
			Ent.NitrousStartBurstAnnotationSound = Memory.NitrousStartBurstAnnotationSound
			Ent.CriticalDamageSound = Memory.CriticalDamageSound
			
			if Ent.NitrousColor then
				local r = Ent.NitrousColor.r
    			local g = Ent.NitrousColor.g
    			local b = Ent.NitrousColor.b
			
    			net.Start( "cfnitrouscolor" )
    			    net.WriteEntity(Ent)
    			    net.WriteInt(r, 9)
    			    net.WriteInt(g, 9)
    			    net.WriteInt(b, 9)
					net.WriteBool(Ent.NitrousBurst)
    			net.Broadcast()
			end
		end
		
		
	elseif Memory.VehicleBase == "prop_vehicle_jeep" then
		local class = Memory.SpawnName
		local vehicles = list.Get("Vehicles")
		local lst = vehicles[class]
		if not lst then
			PrintMessage( HUD_PRINTTALK, "The vehicle '"..class.."' is missing!")
			return
		end
		
		Ent = ents.Create("prop_vehicle_jeep")
		Ent.VehicleTable = lst
		Ent:SetModel(lst.Model) 
		Ent:SetPos(pos + (vector_up * 25))
		
		local SpawnAng = ang
		SpawnAng.pitch = 0
		SpawnAng.yaw = SpawnAng.yaw + 90
		SpawnAng.roll = 0
		Ent:SetAngles(SpawnAng)
		
		Ent:SetKeyValue("vehiclescript", lst.KeyValues.vehiclescript)
		Ent:SetVehicleClass( class )
		Ent:Spawn()
		Ent:Activate()
		
		local vehicle = Ent
		if IsValid(Entity(1)) then
			gamemode.Call( "PlayerSpawnedVehicle", Entity(1), vehicle ) --Some vehicles has different models implanted together, so do that.
		end
		
		if istable( Memory.SubMaterials ) then
			for i = 0, table.Count( Memory.SubMaterials ) do
				Ent:SetSubMaterial( i, Memory.SubMaterials[i] )
			end
		end
		
		local groups = string.Explode( ",", Memory.BodyGroups)
		for i = 1, table.Count( groups ) do
			Ent:SetBodygroup(i, tonumber(groups[i]) )
		end
		
		Ent:SetSkin( Memory.Skin )
		
		local c = string.Explode( ",", Memory.Color )
		local Color =  Color( tonumber(c[1]), tonumber(c[2]), tonumber(c[3]), tonumber(c[4]) )
		
		local dot = Color.r * Color.g * Color.b * Color.a
		Ent.OldColor = dot
		Ent:SetColor( Color )
		
		local data = {
			Color = Color,
			RenderMode = 0,
			RenderFX = 0
		}
		duplicator.StoreEntityModifier( Ent, "colour", data )
		
		undo.Create( "Vehicle" )
		undo.SetPlayer( ply )
		undo.AddEntity( Ent )
		undo.SetCustomUndoText( "Undone " .. class )
		undo.Finish( "Vehicle (" .. tostring( class ) .. ")" )
		
	end
	
	spawn.claimed = true
	entrantvehicle:Remove()
	
	Ent.racer = racer_name
	
	if aienabled then 
		Ent.uvclasstospawnon = "npc_racervehicle"
		-- else
		-- ply:PrintMessage( HUD_PRINTTALK, "Moving your vehicle to the grid slot..." ) 
	end
	
	if PT then
		Ent.PursuitTech = PT
	end
	
	if Ent.PursuitTech then
		table.insert(UVRVWithPursuitTech, Ent)
		
		for i=1,2 do
			UVReplicatePT( Ent, i )
		end
	end
	
	Ent:CallOnRemove( "UVRVWithPursuitTechRemoved", function(Ent)
		if table.HasValue(UVRVWithPursuitTech, Ent) then
			table.RemoveByValue(UVRVWithPursuitTech, Ent)
		end
	end)
	
	UVRaceAddParticipant( Ent )
	
	timer.Simple( 1, function()
		if IsValid(Ent) then
			Ent:GetPhysicsObject():EnableMotion( false )
			if aienabled then 
				local uv = ents.Create(Ent.uvclasstospawnon)
				uv:SetPos(Ent:GetPos())
				uv.uvscripted = true
				uv.vehicle = Ent
				uv:Spawn()
				uv:Activate()
				ply = uv
			else
				if Ent.IsSimfphyscar then
					ply:EnterVehicle( Ent.DriverSeat )
				elseif Ent.IsGlideVehicle then
					local seat = Ent.seats[1]
					if IsValid(seat) then
						ply:EnterVehicle(seat)
					end
				elseif Ent:GetClass() == "prop_vehicle_jeep" then
					ply:EnterVehicle(Ent)
				end
			end
		end
	end)
	
	return Ent
	
end