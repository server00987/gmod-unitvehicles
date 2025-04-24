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
	
	if !ply then
		ply = Entity(1)
	end
	
	local uvnextclasstospawn
	
	local enemylocation
	local suspect = ply
	if next(uvwantedtablevehicle) ~= nil then
		local suspects = uvwantedtablevehicle
		local random_entry = math.random(#suspects)	
		suspect = suspects[random_entry]
		enemylocation = (suspect:GetPos()+Vector(0,0,50))
	else
		enemylocation = (suspect:GetPos()+Vector(0,0,50))
	end
	
	local suspectvelocity = suspect:GetVelocity()
	
	if next(dvd.Waypoints) == nil then
		PrintMessage( HUD_PRINTTALK, "There's no Decent Vehicle waypoints to spawn vehicles! Download Decent Vehicle (if you haven't) and place some waypoints!")
		return
	else
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
	end
	
	if uvtargeting then
		if !rhinoattack then
			local mathangle = math.random(1,2)
			if mathangle == 2 then
				uvspawnpointangles = uvspawnpointangles+Angle(0,180,0)
			end
		else
			uvspawnpointangles = suspect:GetVelocity():Angle()
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
	
	if uvheatlevel < 1 then
		uvheatlevel = 1
	elseif uvheatlevel > 6 then
		uvheatlevel = 6
	end
	
	local appliedunits
	if rhinoattack then
		if uvheatlevel == 1 then
			appliedunits = string.Trim(UVURhinos1:GetString())
		elseif uvheatlevel == 2 then
			appliedunits = string.Trim(UVURhinos2:GetString())
		elseif uvheatlevel == 3 then
			appliedunits = string.Trim(UVURhinos3:GetString())
		elseif uvheatlevel == 4 then
			appliedunits = string.Trim(UVURhinos4:GetString())
		elseif uvheatlevel == 5 then
			appliedunits = string.Trim(UVURhinos5:GetString())
		elseif uvheatlevel == 6 then
			appliedunits = string.Trim(UVURhinos6:GetString())
		end
	else
		if uvheatlevel == 1 then
			local UnitsPatrol = string.Trim(UVUUnitsPatrol1:GetString())
			local UnitsSupport = string.Trim(UVUUnitsSupport1:GetString())
			local UnitsPursuit = string.Trim(UVUUnitsPursuit1:GetString())
			local UnitsInterceptor = string.Trim(UVUUnitsInterceptor1:GetString())
			local UnitsSpecial = string.Trim(UVUUnitsSpecial1:GetString())
			local UnitsCommander = string.Trim(UVUUnitsCommander1:GetString())
			if uvonecommanderactive or uvonecommanderdeployed or posspecified then
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
				if !string.match(v, "^%s*$") then --not an empty string
					table.insert(availableunitstable, givenunitstable[k])
					table.insert(availableclasses, givenclasses[k])
				end
			end				
			local randomclassunit = math.random(1, #availableclasses)
			appliedunits = availableunitstable[randomclassunit]
			uvnextclasstospawn = availableclasses[randomclassunit]
		elseif uvheatlevel == 2 then
			local UnitsPatrol = string.Trim(UVUUnitsPatrol2:GetString())
			local UnitsSupport = string.Trim(UVUUnitsSupport2:GetString())
			local UnitsPursuit = string.Trim(UVUUnitsPursuit2:GetString())
			local UnitsInterceptor = string.Trim(UVUUnitsInterceptor2:GetString())
			local UnitsSpecial = string.Trim(UVUUnitsSpecial2:GetString())
			local UnitsCommander = string.Trim(UVUUnitsCommander2:GetString())
			if uvonecommanderactive or uvonecommanderdeployed or posspecified then
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
				if !string.match(v, "^%s*$") then --not an empty string
					table.insert(availableunitstable, givenunitstable[k])
					table.insert(availableclasses, givenclasses[k])
				end
			end
			local randomclassunit = math.random(1, #availableclasses)
			appliedunits = availableunitstable[randomclassunit]
			uvnextclasstospawn = availableclasses[randomclassunit]
		elseif uvheatlevel == 3 then
			local UnitsPatrol = string.Trim(UVUUnitsPatrol3:GetString())
			local UnitsSupport = string.Trim(UVUUnitsSupport3:GetString())
			local UnitsPursuit = string.Trim(UVUUnitsPursuit3:GetString())
			local UnitsInterceptor = string.Trim(UVUUnitsInterceptor3:GetString())
			local UnitsSpecial = string.Trim(UVUUnitsSpecial3:GetString())
			local UnitsCommander = string.Trim(UVUUnitsCommander3:GetString())
			if uvonecommanderactive or uvonecommanderdeployed or posspecified then
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
				if !string.match(v, "^%s*$") then --not an empty string
					table.insert(availableunitstable, givenunitstable[k])
					table.insert(availableclasses, givenclasses[k])
				end
			end
			local randomclassunit = math.random(1, #availableclasses)
			appliedunits = availableunitstable[randomclassunit]
			uvnextclasstospawn = availableclasses[randomclassunit]
		elseif uvheatlevel == 4 then
			local UnitsPatrol = string.Trim(UVUUnitsPatrol4:GetString())
			local UnitsSupport = string.Trim(UVUUnitsSupport4:GetString())
			local UnitsPursuit = string.Trim(UVUUnitsPursuit4:GetString())
			local UnitsInterceptor = string.Trim(UVUUnitsInterceptor4:GetString())
			local UnitsSpecial = string.Trim(UVUUnitsSpecial4:GetString())
			local UnitsCommander = string.Trim(UVUUnitsCommander4:GetString())
			if uvonecommanderactive or uvonecommanderdeployed or posspecified then
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
				if !string.match(v, "^%s*$") then --not an empty string
					table.insert(availableunitstable, givenunitstable[k])
					table.insert(availableclasses, givenclasses[k])
				end
			end
			local randomclassunit = math.random(1, #availableclasses)
			appliedunits = availableunitstable[randomclassunit]
			uvnextclasstospawn = availableclasses[randomclassunit]
		elseif uvheatlevel == 5 then
			local UnitsPatrol = string.Trim(UVUUnitsPatrol5:GetString())
			local UnitsSupport = string.Trim(UVUUnitsSupport5:GetString())
			local UnitsPursuit = string.Trim(UVUUnitsPursuit5:GetString())
			local UnitsInterceptor = string.Trim(UVUUnitsInterceptor5:GetString())
			local UnitsSpecial = string.Trim(UVUUnitsSpecial5:GetString())
			local UnitsCommander = string.Trim(UVUUnitsCommander5:GetString())
			if uvonecommanderactive or uvonecommanderdeployed or posspecified then
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
				if !string.match(v, "^%s*$") then --not an empty string
					table.insert(availableunitstable, givenunitstable[k])
					table.insert(availableclasses, givenclasses[k])
				end
			end
			local randomclassunit = math.random(1, #availableclasses)
			appliedunits = availableunitstable[randomclassunit]
			uvnextclasstospawn = availableclasses[randomclassunit]
		elseif uvheatlevel == 6 then
			local UnitsPatrol = string.Trim(UVUUnitsPatrol6:GetString())
			local UnitsSupport = string.Trim(UVUUnitsSupport6:GetString())
			local UnitsPursuit = string.Trim(UVUUnitsPursuit6:GetString())
			local UnitsInterceptor = string.Trim(UVUUnitsInterceptor6:GetString())
			local UnitsSpecial = string.Trim(UVUUnitsSpecial6:GetString())
			local UnitsCommander = string.Trim(UVUUnitsCommander6:GetString())
			if uvonecommanderactive or uvonecommanderdeployed or posspecified then
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
				if !string.match(v, "^%s*$") then --not an empty string
					table.insert(availableunitstable, givenunitstable[k])
					table.insert(availableclasses, givenclasses[k])
				end
			end
			local randomclassunit = math.random(1, #availableclasses)
			appliedunits = availableunitstable[randomclassunit]
			uvnextclasstospawn = availableclasses[randomclassunit]
		end
	end
	
	if !isstring(appliedunits) then
		PrintMessage( HUD_PRINTTALK, "There's currently no assigned Units to spawn. Use the Unit Manager tool to assign Units at that particular Heat Level!")
		return
	end
	
	local availableunits = {}
	local availableunit
	local UNITMEMORY = {}
	
	if vehiclebase == 3 then --Glide
		local saved_vehicles = file.Find("unitvehicles/glide/units/*.json", "DATA")
		
		for k, v in pairs(saved_vehicles) do
			local match = string.find( appliedunits, v )
			if match then
				table.insert(availableunits, v)
			end
		end
		
		if next(availableunits) == nil then
			if !string.match(appliedunits, "^%s*$") then
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
		
		UVTOOLMemory = util.JSONToTable(JSONData, true)
		
		local pos = uvspawnpoint+Vector( 0, 0, 50 )
		local ang = uvspawnpointangles
		
		duplicator.SetLocalPos( pos )
		duplicator.SetLocalAng( ang )
		
		local Ents = duplicator.Paste( ply, UVTOOLMemory.Entities, UVTOOLMemory.Constraints )
		local Ent = Ents[next(Ents)]
		
		duplicator.SetLocalPos( vector_origin )
		duplicator.SetLocalAng( angle_zero )
		
		Ent.uvclasstospawnon = uvnextclasstospawn
		if rhinoattack then
			Ent.uvclasstospawnon = "npc_uvspecial"
			Ent.rhino = true
		elseif Ent.uvclasstospawnon != "npc_uvpatrol" and Ent.uvclasstospawnon != "npc_uvsupport" then
			
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
							LastUsed = 0,
							Upgraded = (Ent.uvclasstospawnon == "npc_uvspecial" or Ent.uvclasstospawnon == "npc_uvcommander")
						}
	
						for i, v in pairs(pool) do
							if v == selected_pt then
								table.remove(pool, i)
							end
						end
					end
				end
				--Ent.PursuitTech = (#pool > 0 and pool[math.random(1, #pool)]) or nil
			end
			
			-- if Ent.uvclasstospawnon == "npc_uvspecial" or Ent.uvclasstospawnon == "npc_uvcommander" then
			-- 	Ent.uvupgraded = true
			-- end
		end
		
		if Ent.uvclasstospawnon == "npc_uvcommander" and UVUOneCommander:GetInt() == 1 then
			uvonecommanderdeployed = true
			table.insert(uvcommanders, Ent)
			Ent.unitscript = availableunit
			Ent.uvlasthealth = uvcommanderlasthealth
			Ent.uvlastenginehealth = uvcommanderlastenginehealth
		end
		
		Ent:CallOnRemove( "UVGlideVehicleRemoved", function(car)
			if table.HasValue(uvcommanders, car) then
				table.RemoveByValue(uvcommanders, car)
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
				table.insert(uvsimfphysvehicleinitializing, Ent)
			end)
		else
			table.insert(uvsimfphysvehicleinitializing, Ent)
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
			if !string.match(appliedunits, "^%s*$") then
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
					UNITMEMORY[name] = {}
					
					local submats = string.Explode( ",", variable )
					for i = 0, (table.Count( submats ) - 1) do
						UNITMEMORY[name][i] = submats[i+1]
					end
				else
					UNITMEMORY[name] = variable
				end
			end
		end
		
		if not istable(UNITMEMORY) then return end
		
		local Ent
		
		local vname = UNITMEMORY.SpawnName
		local VehicleList = list.Get( "simfphys_vehicles" )
		local vehicle = VehicleList[ vname ]
		
		if not vehicle then 
			PrintMessage( HUD_PRINTTALK, "The vehicle class '"..vname.."' dosen't seem to be installed!")
			return false 
		end
		
		local SpawnPos = uvspawnpoint + Vector(0,0,50) + (vehicle.SpawnOffset or Vector(0,0,0))
		
		local SpawnAng = uvspawnpointangles
		SpawnAng.pitch = 0
		SpawnAng.yaw = SpawnAng.yaw + 180 + (vehicle.SpawnAngleOffset and vehicle.SpawnAngleOffset or 0)
		SpawnAng.roll = 0
		
		Ent = simfphys.SpawnVehicle( ply, SpawnPos, SpawnAng, vehicle.Model, vehicle.Class, vname, vehicle )
		
		if not IsValid( Ent ) then return end
		
		timer.Simple( 0.5, function()
			if not IsValid(Ent) then return end
			
			local tsc = string.Explode( ",", UNITMEMORY.TireSmokeColor )
			Ent:SetTireSmokeColor( Vector( tonumber(tsc[1]), tonumber(tsc[2]), tonumber(tsc[3]) ) )
			
			Ent.Turbocharged = tobool( UNITMEMORY.HasTurbo )
			Ent.Supercharged = tobool( UNITMEMORY.HasBlower )
			
			Ent:SetEngineSoundPreset( math.Clamp( tonumber( UNITMEMORY.SoundPreset ), -1, 23) )
			Ent:SetMaxTorque( math.Clamp( tonumber( UNITMEMORY.PeakTorque ), 20, 1000) )
			Ent:SetDifferentialGear( math.Clamp( tonumber( UNITMEMORY.FinalGear ),0.2, 6 ) )
			
			Ent:SetSteerSpeed( math.Clamp( tonumber( UNITMEMORY.SteerSpeed ), 1, 16 ) )
			Ent:SetFastSteerAngle( math.Clamp( tonumber( UNITMEMORY.SteerAngFast ), 0, 1) )
			Ent:SetFastSteerConeFadeSpeed( math.Clamp( tonumber( UNITMEMORY.SteerFadeSpeed ), 1, 5000 ) )
			
			Ent:SetEfficiency( math.Clamp( tonumber( UNITMEMORY.Efficiency ) ,0.2,4) )
			Ent:SetMaxTraction( math.Clamp( tonumber( UNITMEMORY.MaxTraction ) , 5,1000) )
			Ent:SetTractionBias( math.Clamp( tonumber( UNITMEMORY.GripOffset ),-0.99,0.99) )
			Ent:SetPowerDistribution( math.Clamp( tonumber( UNITMEMORY.PowerDistribution ) ,-1,1) )
			
			Ent:SetBackFire( tobool( UNITMEMORY.HasBackfire ) )
			Ent:SetDoNotStall( tobool( UNITMEMORY.DoesntStall ) )
			
			Ent:SetIdleRPM( math.Clamp( tonumber( UNITMEMORY.IdleRPM ),1,25000) )
			Ent:SetLimitRPM( math.Clamp( tonumber( UNITMEMORY.MaxRPM ),4,25000) )
			Ent:SetRevlimiter( tobool( UNITMEMORY.HasRevLimiter ) )
			Ent:SetPowerBandEnd( math.Clamp( tonumber( UNITMEMORY.PowerEnd ), 3, 25000) )
			Ent:SetPowerBandStart( math.Clamp( tonumber( UNITMEMORY.PowerStart ) ,2 ,25000) )
			
			Ent:SetTurboCharged( Ent.Turbocharged )
			Ent:SetSuperCharged( Ent.Supercharged )
			Ent:SetBrakePower( math.Clamp( tonumber( UNITMEMORY.BrakePower ), 0.1, 500) )
			
			Ent:SetSoundoverride( UNITMEMORY.SoundOverride or "" )
			
			Ent:SetLights_List( Ent.LightsTable or "no_lights" )
			
			Ent:SetBulletProofTires(true)
			
			Ent.snd_horn = UNITMEMORY.HornSound
			
			Ent.snd_blowoff = UNITMEMORY.snd_blowoff
			Ent.snd_spool = UNITMEMORY.snd_spool
			Ent.snd_bloweron = UNITMEMORY.snd_bloweron
			Ent.snd_bloweroff = UNITMEMORY.snd_bloweroff
			
			Ent:SetBackfireSound( UNITMEMORY.backfiresound or "" )
			
			local Gears = {}
			local Data = string.Explode( ",", UNITMEMORY.Gears  )
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
			
			if istable( UNITMEMORY.SubMaterials ) then
				for i = 0, table.Count( UNITMEMORY.SubMaterials ) do
					Ent:SetSubMaterial( i, UNITMEMORY.SubMaterials[i] )
				end
			end
			
			if UNITMEMORY.FrontDampingOverride and UNITMEMORY.FrontConstantOverride and UNITMEMORY.RearDampingOverride and UNITMEMORY.RearConstantOverride then
				Ent.FrontDampingOverride = tonumber( UNITMEMORY.FrontDampingOverride )
				Ent.FrontConstantOverride = tonumber( UNITMEMORY.FrontConstantOverride )
				Ent.RearDampingOverride = tonumber( UNITMEMORY.RearDampingOverride )
				Ent.RearConstantOverride = tonumber( UNITMEMORY.RearConstantOverride )
				
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
			
			Ent:SetFrontSuspensionHeight( tonumber( UNITMEMORY.FrontHeight ) )
			Ent:SetRearSuspensionHeight( tonumber( UNITMEMORY.RearHeight ) )
			
			local groups = string.Explode( ",", UNITMEMORY.BodyGroups)
			for i = 1, table.Count( groups ) do
				Ent:SetBodygroup(i, tonumber(groups[i]) )
			end
			
			Ent:SetSkin( UNITMEMORY.Skin )
			
			local c = string.Explode( ",", UNITMEMORY.Color )
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
					if UNITMEMORY.WheelTool_Foffset and UNITMEMORY.WheelTool_Roffset then
						SetWheelOffset( Ent, UNITMEMORY.WheelTool_Foffset, UNITMEMORY.WheelTool_Roffset )
					end
					
					if not UNITMEMORY.FrontWheelOverride and not UNITMEMORY.RearWheelOverride then return end
					
					local front_model = UNITMEMORY.FrontWheelOverride or vehicle.Members.CustomWheelModel
					local front_angle = GetAngleFromSpawnlist(front_model)
					
					local camber = UNITMEMORY.Camber or 0
					local rear_model = UNITMEMORY.RearWheelOverride or (vehicle.Members.CustomWheelModel_R and vehicle.Members.CustomWheelModel_R or front_model)
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
		elseif Ent.uvclasstospawnon != "npc_uvpatrol" and Ent.uvclasstospawnon != "npc_uvsupport" then
			
			if UVUPursuitTech:GetBool() then
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
				
				Ent.PursuitTech = (#pool > 0 and pool[math.random(1, #pool)]) or nil
			end
			if Ent.uvclasstospawnon == "npc_uvspecial" or Ent.uvclasstospawnon == "npc_uvcommander" then
				Ent.uvupgraded = true
			end
		end
		
		if Ent.uvclasstospawnon == "npc_uvcommander" and UVUOneCommander:GetInt() == 1 then
			uvonecommanderdeployed = true
			table.insert(uvcommanders, Ent)
			Ent.unitscript = availableunit
			Ent.uvlasthealth = uvcommanderlasthealth
		end
		
		if playercontrolled then
			timer.Simple(0.5, function()
				Ent.UnitVehicle = ply
				Ent.callsign = ply:GetName()
				UVAddToPlayerUnitListVehicle(Ent)
				table.insert(uvsimfphysvehicleinitializing, Ent)
			end)
		else
			table.insert(uvsimfphysvehicleinitializing, Ent)
		end
		
		Ent:CallOnRemove( "UVSimfphysVehicleRemoved", function(car)
			if table.HasValue(uvsimfphysvehicleinitializing, car) then
				table.RemoveByValue(uvsimfphysvehicleinitializing, car)
			end
			if table.HasValue(uvcommanders, car) then
				table.RemoveByValue(uvcommanders, car)
			end
		end)
		
		timer.Simple(2, function() 
			if IsValid(Ent) and !Ent.UnitVehicle then
				Ent:Remove()
			end
		end)
		
		if posspecified then
			Ent.roadblocking = true
		end
		if disperse then
			Ent.disperse = true
		end
		
	elseif vehiclebase == 1 then --Default Vehicle Base
		
		if !class then
			PrintMessage( HUD_PRINTTALK, "Please set the Vehicle Base to simfphys or Glide in the Unit Manager Tool settings!")
			return
		end
		
		local vehicles = list.Get("Vehicles")
		local lst = vehicles[class]
		if !lst then
			PrintMessage( HUD_PRINTTALK, "The vehicle '"..class.."' is missing!")
			return
		end
		
		car = ents.Create("prop_vehicle_jeep")
		car.VehicleTable = lst
		car:SetModel(lst.Model) 
		car:SetPos(uvspawnpoint+Vector(0,0,50))
		car:SetAngles(uvspawnpointangles)
		car:SetKeyValue("vehiclescript", lst.KeyValues.vehiclescript)
		car:SetVehicleClass( class )
		car:Spawn()
		car:Activate()
		local vehicle = car
		gamemode.Call( "PlayerSpawnedVehicle", ply, vehicle ) --Some vehicles has different models implanted together, so do that.
		
		if rhinoattack then
			car.rhino = true
		end
		
		uv = ents.Create(uvnextclasstospawn) 
		uv:SetPos(car:GetPos())
		uv.uvscripted = true
		uv.vehicle = car
		uv:Spawn()
		uv:Activate()
		
		timer.Simple(1, function() 
			if IsValid(car) and !IsValid(uv) then
				car:Remove()
			end
		end)
		
		if posspecified then
			car.roadblocking = true
		end
		if disperse then
			car.disperse = true
		end
	else
		PrintMessage( HUD_PRINTTALK, "Invalid Vehicle Base! Reverting to Default Vehicle Base! Please set the Vehicle Base in the Unit Manager Tool settings!")
		RunConsoleCommand("unitvehicle_unit_vehiclebase", 1)
	end
	
end

function UVAutoSpawnRacer(ply)
	
	if !ply then
		ply = Entity(1)
	end
	
	local uvnextclasstospawn
	
	local enemylocation
	local suspect = ply
	enemylocation = (suspect:GetPos()+Vector(0,0,50))
	
	if next(dvd.Waypoints) == nil then
		PrintMessage( HUD_PRINTTALK, "There's no Decent Vehicle waypoints to spawn vehicles! Download Decent Vehicle (if you haven't) and place some waypoints!")
		return
	else
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
		local pos = uvspawnpoint+Vector( 0, 0, 50 )
		local ang = uvspawnpointangles
		
		local Ent = Glide.VehicleFactory( ply, {
			Pos = pos,
			Angle = ang,
			Class = "gtav_police_cruiser",
		} )
		
		timer.Simple(0.5, function() 
			if IsValid(Ent) then
				local uv = ents.Create("npc_uvpatrol") 
				uv:SetPos(Ent:GetPos())
				uv.uvscripted = true
				uv.vehicle = Ent
				uv:Spawn()
				uv:Activate()
			else
				Ent:Remove()
			end
		end)
	elseif vehiclebase == 2 then --simfphys
		
		local RACERMEMORY = {}
		local racertable = file.Find("saved_vehicles/*.txt", "DATA")
		
		if !racertable then
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
		
		local SpawnPos = uvspawnpoint + Vector(0,0,50) + (vehicle.SpawnOffset or Vector(0,0,0))
		
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
		
		table.insert(uvsimfphysvehicleinitializing, Ent)
		
		Ent:CallOnRemove( "UVSimfphysVehicleRemoved", function(car)
			if table.HasValue(uvsimfphysvehicleinitializing, car) then
				table.RemoveByValue(uvsimfphysvehicleinitializing, car)
			end
			if table.HasValue(uvcommanders, car) then
				table.RemoveByValue(uvcommanders, car)
			end
		end)
		
		timer.Simple(2, function() 
			if IsValid(Ent) and !Ent.RacerVehicle then
				Ent:Remove()
			else
				UVAddToWantedListVehicle(Ent)
			end
		end)
		
	elseif vehiclebase == 1 then --Default Vehicle Base
		
		if !class then
			PrintMessage( HUD_PRINTTALK, "Please set the Vehicle Base to simfphys or Glide in the Unit Manager Tool settings!")
			return
		end
		
		local vehicles = list.Get("Vehicles")
		local lst = vehicles[class]
		if !lst then
			PrintMessage( HUD_PRINTTALK, "The vehicle '"..class.."' is missing!")
			return
		end
		
		car = ents.Create("prop_vehicle_jeep")
		car.VehicleTable = lst
		car:SetModel(lst.Model) 
		car:SetPos(uvspawnpoint+Vector(0,0,50))
		car:SetAngles(uvspawnpointangles)
		car:SetKeyValue("vehiclescript", lst.KeyValues.vehiclescript)
		car:SetVehicleClass( class )
		car:Spawn()
		car:Activate()
		local vehicle = car
		gamemode.Call( "PlayerSpawnedVehicle", ply, vehicle ) --Some vehicles has different models implanted together, so do that.
		
		if rhinoattack then
			car.rhino = true
		end
		
		uv = ents.Create(uvnextclasstospawn) 
		uv:SetPos(car:GetPos())
		uv.uvscripted = true
		uv.vehicle = car
		uv:Spawn()
		uv:Activate()
		
		timer.Simple(1, function() 
			if IsValid(car) and !IsValid(uv) then
				car:Remove()
			end
		end)
		
		if posspecified then
			car.roadblocking = true
		end
		if disperse then
			car.disperse = true
		end
	else
		PrintMessage( HUD_PRINTTALK, "Invalid Vehicle Base! Reverting to Default Vehicle Base! Please set the Vehicle Base in the Unit Manager Tool settings!")
		RunConsoleCommand("unitvehicle_unit_vehiclebase", 1)
	end
end