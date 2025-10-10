AddCSLuaFile()

local dvd = DecentVehicleDestination

local temp_keybinds = {
    [KEY_T] = 1,
    [KEY_P] = 2,
}

local keybind_requests = {}

hook.Add( "PlayerButtonDown", "PlayerButtonDownHandler", function( ply, button )
    if CLIENT and not IsFirstTimePredicted() then
        return
    end
    
    -- if button == KEY_M then
    --     local car = UVGetVehicle( ply )
    
    --     if car then
    --         if not table.HasValue( UVRaceCurrentParticipants, car ) then return end
    --         if not UVRaceInProgress then return end
    
    --         local key = "VehicleReset_"..car:EntIndex()
    --         if timer.Exists( key ) then return end
    
    --         if car.hasreset then
    --             net.Start("uvrace_resetfailed")
    --             net.WriteString("uv.race.resetcooldown")
    --             net.Send(ply)
    --             return
    --         end
    
    --         if car:GetVelocity():LengthSqr() > 5000 then
    --             net.Start("uvrace_resetfailed")
    --             net.WriteString("uv.race.resetstationary")
    --             net.Send(ply)
    --             return
    --         end
    
    --         if car.UVBustingProgress and car.UVBustingProgress > 0 then
    --             timer.Remove(key)
    --             net.Start("uvrace_resetfailed")
    --             net.WriteString("uv.race.resetbusting")
    --             net.Send(ply)
    --             return
    --         end
    
    --         net.Start( "uvrace_resetcountdown" )
    --         net.WriteInt(2, 4)
    --         net.Send(ply)
    
    --         timer.Create( key, 1, 2, function()
    --             local remaining_reps = timer.RepsLeft( key )
    
    --             if not IsValid(car) or car:GetDriver() ~= ply then
    --                 timer.Remove(key)
    --             end
    
    --             if car:GetVelocity():LengthSqr() > 5000 then
    --                 net.Start("uvrace_resetfailed")
    --                 net.WriteString("uv.race.resetstationary")
    --                 net.Send(ply)
    --                 return
    --             end
    
    --             if car.UVBustingProgress and car.UVBustingProgress > 0 then
    --                 timer.Remove(key)
    --                 net.Start("uvrace_resetfailed")
    --                 net.WriteString("uv.race.resetbusting")
    --                 net.Send(ply)
    --                 return
    --             end
    
    --             if remaining_reps > 0 then
    --                 net.Start( "uvrace_resetcountdown" )
    --                 net.WriteInt(remaining_reps, 4)
    --                 net.Send(ply)
    --             else
    --                 if IsValid(car) and car:GetDriver() == ply then
    --                     UVResetPosition(car)
    --                 end
    --             end
    --         end)
    --         --UVResetPosition(car)
    --     end
    -- end
    
    if keybind_requests[ply] then
        local slot = keybind_requests[ply]
        keybind_requests[ply] = nil
        
        net.Start("UVGetNewKeybind")
        net.WriteInt(slot, 16)
        net.WriteInt(button, 16)
        net.Send(ply)
    end
end)

function UVIsVehicleInCone( source, target, radius, distance )
    local posSource = source:GetPos()
    local posTarget = target:GetPos()

    local dirSource = source:GetForward()

    local dirNormal = ( posTarget - posSource ):GetNormalized()
    local dot = dirSource:Dot( dirNormal )

    local checkAngle = math.cos( math.rad( radius / 2 ) )

    return dot >= checkAngle and posSource:DistToSqr( posTarget ) <= distance
end

if SERVER then
    function UVNotifyCenter( ply_array, frmt, icon_name, ... )
        for _, v in pairs( ply_array ) do
            
            net.Start('UVUnitTakedown')

            net.WriteString( select( 1, ... ) ) -- Unit Type
            net.WriteString( select( 2, ... ) ) -- Name
            net.WriteUInt( select( 3, ... ), 32 ) -- Bounty
            net.WriteUInt( select( 4, ... ), 7 ) -- Combo
            net.WriteBool( select( 5, ... ) ) -- Player
            
            net.Send( v )
            
        end
    end

    function UVGetHeadlight(vehicle)
        if vehicle.IsGlideVehicle then
            return vehicle:GetHeadlightState()
        elseif vcmod_main and vehicle:GetClass() == "prop_vehicle_jeep" then
            return vehicle:VC_getRunningLights()
        end
    end

    function UVSetHeadlight(vehicle, state)
        if vehicle.IsGlideVehicle then
            vehicle:SetHeadlightState( state )
        elseif vcmod_main and vehicle:GetClass() == "prop_vehicle_jeep" then
            vehicle:VC_setRunningLights( state >= 1 )
        end
    end

    function UVDamage(vehicle, damage)
        if vehicle.IsSimfphyscar then

            local MaxHealth = vehicle:GetMaxHealth()
            local damage = MaxHealth*damage
            vehicle:ApplyDamage( damage, DMG_GENERIC )

        elseif vehicle.IsGlideVehicle then

            vehicle:SetEngineHealth( vehicle:GetEngineHealth() - damage )
            vehicle:UpdateHealthOutputs()
            
        elseif vehicle:GetClass() == "prop_vehicle_jeep" then
            
        end
    end

    function UVRepair(vehicle, forcerepair)
		local cooldown = 5
		local cooldown2 = RepairCooldown:GetInt()
		
		vehicle.uvrepairdelayed = true
		timer.Simple(cooldown, function()
			if IsValid(vehicle) then
				vehicle.uvrepairdelayed = false
			end
		end)
		
		local function UVRepairCooldown()
			local cooldowntimeleft = cooldown2 - (CurTime() - vehicle.uvrepaircooldown)
			if UVGetDriver(vehicle) then
				if UVGetDriver(vehicle):IsPlayer() then
					net.Start("UVHUDRepairCooldown")
					net.WriteInt(cooldowntimeleft, 32)
					net.Send(UVGetDriver(vehicle))
				end
			end
			return
		end
		
		if vehicle.uvrepaircooldown and not forcerepair then
			UVRepairCooldown()
			return
		end
		
		local ptrefilled = false
		
		if vehicle.PursuitTech then
			for k, v in pairs(vehicle.PursuitTech) do
				local max_ammo = GetConVar('unitvehicle_'..((vehicle.UnitVehicle and 'unitpursuittech') or 'pursuittech')..'_maxammo_'..string.lower(string.gsub(v.Tech, " ", ""))):GetInt()
				if v.Ammo < max_ammo then
					ptrefilled = true
					v.Ammo = max_ammo
				end
			end
		end
		
		if ptrefilled then
			for i=1, 2 do
				UVReplicatePT( vehicle, i )
			end
		end
	
		local repairnet = "UVHUDRepair"
		local comcanrep = GetConVar("unitvehicle_unit_commanderrepair"):GetBool()
		local canrepair = true
	
		if comcanrep then
			if table.HasValue(UVCommanders, vehicle) then
				if UVGetDriver(vehicle) and UVGetDriver(vehicle):IsPlayer() then
					repairnet = "UVHUDRepairCommander"
					canrepair = false
				end
			end
		end
	
		if canrepair then
			if vehicle:GetClass() == "prop_vehicle_jeep" then
				if vcmod_main then
					if not ptrefilled and vehicle:VC_getHealthMax() == vehicle:VC_getHealth() then return end
				
					vehicle:VC_repairFull_Admin()
				else
					if not ptrefilled and vehicle:GetMaxHealth() == vehicle:Health() then return end
				
					local mass = vehicle:GetPhysicsObject():GetMass()
					vehicle:SetMaxHealth(mass)
					vehicle:SetHealth(mass)
					vehicle:StopParticles()
				end
			end
			if vehicle.IsSimfphyscar then	
				local repaired_tires = false 
				
				if istable(vehicle.Wheels) then
					for i = 1, table.Count( vehicle.Wheels ) do
						local Wheel = vehicle.Wheels[ i ]
						if IsValid(Wheel) and Wheel:GetDamaged() then
							repaired_tires = true
							Wheel:SetDamaged( false )
						end
					end
				end
				
				if not ptrefilled and not repaired_tires and vehicle:GetCurHealth() == vehicle:GetMaxHealth() then return end
				
				--vehicle.simfphysoldhealth = vehicle:GetMaxHealth()
				vehicle:SetCurHealth((AutoHealth:GetBool() and math.huge) or (vehicle.simfphysoldhealth or vehicle:GetMaxHealth()))
				vehicle:SetOnFire( false )
				vehicle:SetOnSmoke( false )
				
				net.Start( "simfphys_lightsfixall" )
				net.WriteEntity( vehicle )
				net.Broadcast()
				
				net.Start( "uvrepairsimfphys" )
				net.WriteEntity( vehicle )
				net.Broadcast()
				
				vehicle:OnRepaired()
			
			end
			if vehicle.IsGlideVehicle then
				local repaired = false
				
				for _, v in pairs(vehicle.wheels) do
					if IsValid(v) and v.bursted then
						repaired = true
						v:_restore()
					end
				end
				
				if not ptrefilled and not repaired and vehicle:GetChassisHealth() >= vehicle.MaxChassisHealth then return end
				vehicle:Repair()
				
				if cffunctions then
					CFRefillNitrous(vehicle)
				end
			end
		end
	
		if UVGetDriver(vehicle) then
			if UVGetDriver(vehicle):IsPlayer() then
				if UVGetDriver(vehicle):GetMaxHealth() == 100 then
					UVGetDriver(vehicle):SetHealth(vehicle:GetPhysicsObject():GetMass())
					UVGetDriver(vehicle):SetMaxHealth(vehicle:GetPhysicsObject():GetMass())
				end
				net.Start(repairnet)
				net.Send(UVGetDriver(vehicle))
				if ptrefilled then
					net.Start("UVHUDRefilledPT")
					net.Send(UVGetDriver(vehicle))
				end
			end
		end
		
		vehicle.uvrepaircooldown = CurTime()
		if cooldown2 > 0 then
			timer.Simple(cooldown2, function()
				if IsValid(vehicle) then
					vehicle.uvrepaircooldown = nil
					if UVGetDriver(vehicle) then
						if UVGetDriver(vehicle):IsPlayer() then
							net.Start("UVHUDRepairAvailable")
							net.Send(UVGetDriver(vehicle))
						end
					end
				end
			end)
		end
	end

    function UVGetRaceLeader()
        if not UVRaceTable or not UVRaceTable['Participants'] then return end

        local Participants = UVRaceTable['Participants']
        local TotalCheckpoints = GetGlobalInt("uvrace_checkpoints", 0)
        local LeadersCurrentCheckpoint = 0
        local Time = math.huge
        local Leaders = {}
        local Leader

        --Look for any racer(s) with most checkpoints passed
        for entity, racer in pairs(Participants) do
            local CheckpointsPassed = #racer['Checkpoints'] + (TotalCheckpoints * (racer['Lap'] - 1))

            if CheckpointsPassed > LeadersCurrentCheckpoint then
                LeadersCurrentCheckpoint = CheckpointsPassed
            end
        end

        --If there are at least 2 racers who did the above, look for the one with the least amount of time
        for entity, racer in pairs(Participants) do
            local CheckpointsPassed = #racer['Checkpoints'] + (TotalCheckpoints * (racer['Lap'] - 1))

            if CheckpointsPassed == LeadersCurrentCheckpoint then
                table.insert( Leaders, racer )
            end
        end

        for entity, racer in pairs(Leaders) do
            local CurrentTime = next(racer['Checkpoints']) ~= nil and racer['Checkpoints'][#racer['Checkpoints']] or racer['LastLapCurTime'] or racer['Position']
            if CurrentTime < Time then
                Time = racer['Checkpoints'][#racer['Checkpoints']] or racer['Position']
                Leader = racer.Vehicle
            end
        end

        return IsValid(Leader) and Leader
    end

    function UVOptimizeRespawn( vehicle, rhino )
        if UVOptimizeRespawnDelayed then return end

        UVOptimizeRespawnDelayed = true
        timer.Simple(1, function()
            UVOptimizeRespawnDelayed = nil
        end)

        local NPC = vehicle.UnitVehicle
        if not NPC then return end

        local vehicle_class = vehicle:GetClass()
        
        if vehicle_class == "gmod_sent_vehicle_fphysics_base" then
            SafeRemoveEntity(NPC) --yeahhh
            return
        end

        NPC.uvmarkedfordeletion = nil
        timer.Simple(1, function()
            NPC.uvmarkedfordeletion = true
        end)
        
        local phys = vehicle:GetPhysicsObject()
        phys:SetVelocity(vector_origin)
        
        local uvnextclasstospawn
	    local enemylocation
	    local suspect
	    local suspectvelocity = Vector(0,0,0)
        local uvspawnpoint
        local uvspawnpointwaypoint
        local uvspawnpointangles
        
	    if next(dvd.Waypoints) == nil then
	    	PrintMessage( HUD_PRINTTALK, "There's no Decent Vehicle waypoints to spawn vehicles! Download Decent Vehicle (if you haven't) and place some waypoints!")
	    	return
	    end
    
	    if next(UVWantedTableVehicle) ~= nil then
	    	local suspects = UVWantedTableVehicle
	    	local random_entry = math.random(#suspects)
	    	suspect = UVGetRaceLeader() or suspects[random_entry]
        
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
	    	if not rhino then
	    		local mathangle = math.random(1,2)
	    		if mathangle == 2 then
	    			uvspawnpointangles = uvspawnpointangles+Angle(0,180,0)
	    		end
	    	else
	    		uvspawnpointangles = suspectvelocity:Angle() + Angle(0,180,0)
	    	end
	    end

        if vehicle.IsGlideVehicle then
            local pos = uvspawnpoint+(vector_up * 50)
		    local ang = uvspawnpointangles

            UVRepair(vehicle, true)

            vehicle:SetPos( pos )
            vehicle:SetAngles( ang )
            vehicle:PhysWake()
        else
            local physObj = vehicle:GetPhysicsObject()
            physObj:EnableMotion(false)

            local pos = uvspawnpoint+(vector_up * 50)
		    local ang = uvspawnpointangles
            
            ang.yaw = ang.yaw - 90
            
            vehicle:SetPos( pos )
            vehicle:SetAngles( ang )
            vehicle:SetVelocity(Vector(0,0,0))

            UVRepair(vehicle, true)
            
            timer.Simple(.5, function()
                physObj:EnableMotion(true)
                physObj:Wake()
            end)
        end

        if NPC.metwithenemy and not UVResourcePointsRefreshing and UVResourcePoints > 1 and not UVOneCommanderActive and not vehicle.roadblocking then
			UVResourcePoints = (UVResourcePoints - 1)
		end

        if vehicle.roadblocking then
            vehicle.roadblocking = nil
        end

        NPC.metwithenemy = nil
        NPC.rhinohit = nil
    end
    
    function UVResetPosition( vehicle )
        -- Check if vehicle is a race participant
        if not table.HasValue( UVRaceCurrentParticipants, vehicle ) then return end
        if not UVRaceInProgress then return end
        
        local entry = UVRaceTable.Participants [vehicle]
        if not entry then return end
        
        if vehicle.hasreset then return end
        
        local vehicle_class = vehicle:GetClass()
        
        local look_up_needle = # entry.Checkpoints
        local checkpoint = nil
        local next_checkpoint = nil
        
        -- Get last passed checkpoint
        for _, v in pairs(ents.FindByClass("uvrace_checkpoint")) do
            local id = v:GetID()
            
            if id == look_up_needle then
                checkpoint = v
            elseif id == look_up_needle +1 then
                next_checkpoint = v
            end
        end
        
        if not checkpoint then return end
        
        -- Teleport to the checkpoint
        --PrintMessage( HUD_PRINTTALK, "Resetting position..." )
        
        local pos = checkpoint:GetPos() + checkpoint:OBBCenter()
        local ground_trace = util.TraceLine({start = pos, endpos = pos +- (checkpoint:GetUp() * 1000), mask = MASK_NPCWORLDSTATIC, filter = {checkpoint}})
        
        local next_pos = nil
        local next_dir = nil
        
        local ang = Angle(0, 0, 0) 
        
        if next_checkpoint then
            next_pos = next_checkpoint:GetPos() + next_checkpoint:OBBCenter()
            next_dir = (next_pos - pos):GetNormalized()
            
            ang = next_dir:Angle()
        end
        
        if vehicle_class == "gmod_sent_vehicle_fphysics_base" then
            vehicle = UVTeleportSimfphysVehicle( vehicle, (ground_trace.Hit and ground_trace.HitPos) or pos, ang )
        elseif vehicle.IsGlideVehicle then
            vehicle:SetPos( (ground_trace.Hit and (ground_trace.HitPos + (Vector(0,0,1) * 25))) or pos )
            vehicle:SetAngles( ang )
            vehicle:PhysWake()
        else
            local physObj = vehicle:GetPhysicsObject()
            physObj:EnableMotion(false)
            
            ang.yaw = ang.yaw - 90
            
            vehicle:SetPos( (ground_trace.Hit and (ground_trace.HitPos + (Vector(0,0,1) * 50))) or pos )
            vehicle:SetAngles( ang )
            vehicle:SetVelocity(Vector(0,0,0))
            
            timer.Simple(.5, function()
                physObj:EnableMotion(true)
                physObj:Wake()
            end)
        end
        
        vehicle.hasreset = CurTime()
        timer.Simple(10, function()
            vehicle.hasreset = nil
        end)
    end
    
    net.Receive("UVResetPosition", function(len, ply)
        local car = UVGetVehicle( ply )
        
        if car then
            if car.UnitVehicle then
                ply:ConCommand( "uv_spawn_as_unit" )
                return
            end
            
            if not table.HasValue( UVRaceCurrentParticipants, car ) then return end
            if not UVRaceInProgress then return end
            
            local key = "VehicleReset_"..car:EntIndex()
            if timer.Exists( key ) then return end
            
            if car.hasreset then
                net.Start("uvrace_resetfailed")
                net.WriteString("uv.race.resetcooldown")
                net.Send(ply)
                return
            end
            
            if car:GetVelocity():LengthSqr() > 5000 then
                net.Start("uvrace_resetfailed")
                net.WriteString("uv.race.resetstationary")
                net.Send(ply)
                return
            end
            
            if car.UVBustingProgress and car.UVBustingProgress > 0 then
                timer.Remove(key)
                net.Start("uvrace_resetfailed")
                net.WriteString("uv.race.resetbusting")
                net.Send(ply)
                return
            end
            
            net.Start( "uvrace_resetcountdown" )
            net.WriteInt(2, 4)
            net.Send(ply)
            
            timer.Create( key, 1, 2, function()
                local remaining_reps = timer.RepsLeft( key )
                
                if not IsValid(car) or car:GetDriver() ~= ply then
                    timer.Remove(key)
                end
                
                if car:GetVelocity():LengthSqr() > 5000 then
                    net.Start("uvrace_resetfailed")
                    net.WriteString("uv.race.resetstationary")
                    net.Send(ply)
                    return
                end
                
                if car.UVBustingProgress and car.UVBustingProgress > 0 then
                    timer.Remove(key)
                    net.Start("uvrace_resetfailed")
                    net.WriteString("uv.race.resetbusting")
                    net.Send(ply)
                    return
                end
                
                if remaining_reps > 0 then
                    net.Start( "uvrace_resetcountdown" )
                    net.WriteInt(remaining_reps, 4)
                    net.Send(ply)
                else
                    if IsValid(car) and car:GetDriver() == ply then
                        UVResetPosition(car)
                    end
                end
            end)
            --UVResetPosition(car)
        end
    end)
    
    net.Receive( "UVPTKeybindRequest", function( len, ply )
        local slot = net.ReadInt( 16 )
        
        if not slot then return end
        keybind_requests[ply] = slot
    end)
    
    net.Receive( "UVPTUse", function( len, ply )
        local slot = net.ReadInt( 16 )
        
        if table.HasValue(UVPlayerUnitTablePlayers, ply) then --UNIT VEHICLES
            for k, car in pairs(UVPlayerUnitTableVehicle) do
                if UVGetDriver(car) == ply and not car.wrecked then
                    UVDeployWeapon( car, slot ) 
                end
            end
        elseif next(UVRVWithPursuitTech) ~= nil then --RACER VEHICLES
            for k, car in pairs(UVRVWithPursuitTech) do
                if UVGetDriver(car) == ply and not car.wrecked and not car.uvbusted then
                    UVDeployWeapon( car, slot ) 
                end
            end
        end
        
    end)

    function UVReplicatePT( car, slot )
        if not car.PursuitTech then return end

        local ptSlot = car.PursuitTech[slot]

        if ptSlot then
            local isPtActive = false 

            if ptSlot.Tech then
                isPtActive = true
            end

            net.Start( "UV_SendPursuitTech" )

            net.WriteEntity( car )
            net.WriteUInt( slot, 2 )
            net.WriteBool( isPtActive )

            if isPtActive then
                net.WriteString( ptSlot.Tech )
                net.WriteUInt( ptSlot.Ammo, 8 )
                net.WriteUInt( ptSlot.Cooldown, 16 )
                net.WriteFloat( ptSlot.LastUsed )
                net.WriteBool( ptSlot.Upgraded )
            end

            net.Broadcast()
            -- net.Start("UV_SendPursuitTech")
            --     net.WriteEntity(car)
            --     net.WriteTable(car.PursuitTech)
            -- net.Broadcast()
        else
            net.Start( "UV_SendPursuitTech" )
            
            net.WriteEntity( car )
            net.WriteUInt( slot, 2 )
            net.WriteBool( false )

            net.Broadcast()
        end
    end

    --[[
        EXPECTED DATA:
        - EventType (STRING)
            1 = Message
            2 = Event
        - Args (ARRAY)
    ]]
    function UVPTEvent( players, pt, eventType, args )
        local playersType = type( players )

        if playersType == 'table' then
            if #players < 1 then return end
        end

        net.Start( 'UVPTEvent' )
        --net.WriteUInt( eventType, 15 )
        net.WriteString( pt )
        net.WriteString( eventType )

        if args then
            local message = ( type( args ) == 'table' and util.TableToJSON( args ) ) or args
            local compressedMessage = util.Compress( message )
            local dataSize = #compressedMessage

            net.WriteBool( true )
            net.WriteUInt( dataSize, 16 )
            net.WriteData( compressedMessage, dataSize )
        else
            net.WriteBool( false )
        end

        if playersType == 'string' and string.lower( players ) == 'all' then
            net.Broadcast()
        else
            net.Send( table.ClearKeys( players ) )
        end
    end

    function ReportPTEvent( user, target, pt, event, args )
        if not IsValid( user ) then return end
        local attacker = UVGetDriver(user)
		local attackerName = UVGetDriverName(user)

        local victimNames = nil
        local playerTargets = {}

        if type( target ) == 'table' then
            victimNames = {}

            for _, v in pairs( target ) do
                local victim = UVGetDriver( v )
                local victimName = UVGetDriverName( v )

                if victim then
                    table.insert( playerTargets, victim )
                end

                table.insert( victimNames, victimName )
            end

        elseif isentity( target ) then
            local _target = UVGetDriver( target ) or nil

            if _target then
                table.insert( playerTargets, _target )
            end

            victimNames = UVGetDriverName( target )
        end

        if not attacker then attacker = nil end

        local message = {
            User = attackerName,
            Target = victimNames,
        }

        if args then
            for i, v in pairs( args ) do
                message[i] = v
            end
        end

        UVPTEvent( {attacker, unpack( playerTargets )}, pt, event, message )
    end
    
    function UVDeployWeapon(car, slot)
        if UVJammerDeployed and not car.jammerexempt then return end
        if not car.PursuitTech then return end
        
        if car.uvraceparticipant then
            if UVRaceInEffect and not UVRaceInProgress then return end
        end
        
        local pursuit_tech = car.PursuitTech[slot]
        if not pursuit_tech then return end
        
        if pursuit_tech.Ammo <= 0 then return end
        
        local driver = car:GetDriver()

        local used = false
        
        if pursuit_tech.Tech == "Shockwave" then --SHOCKWAVE
            local Cooldown = pursuit_tech.Cooldown
            if CurTime() - pursuit_tech.LastUsed < Cooldown then return end
            
            if IsValid(driver) then
                UVPTEvent({driver}, 'Shockwave', 'Use', {['Test'] = 'Hello world!'})
            end
            
            UVDeployShockwave(car)
            
            used = true
            pursuit_tech.LastUsed = CurTime()
            pursuit_tech.Ammo = pursuit_tech.Ammo - 1
        elseif pursuit_tech.Tech == "ESF" then --ESF
            local Cooldown = pursuit_tech.Cooldown
            if CurTime() - pursuit_tech.LastUsed < Cooldown then return end
            car:RemoveCallOnRemove("uvesf"..car:EntIndex())
            
            UVDeployESF(car)
            
            pursuit_tech.LastUsed = CurTime()
            pursuit_tech.Ammo = pursuit_tech.Ammo - 1
            used = true

            -- if IsValid(driver) then
            --     driver:PrintMessage( HUD_PRINTCENTER, "ESF deployed!")
            -- end
            if IsValid(driver) then
                UVPTEvent({driver}, 'ESF', 'Use')
            end
            
            car:EmitSound("gadgets/esf/start.wav")
            car:EmitSound("gadgets/esf/onloop.wav")
            
            timer.Simple(UVPTESFDuration:GetInt(), function()
                UVDeactivateESF(car)
            end)
            
            car:CallOnRemove("uvesf"..car:EntIndex(), function()
                UVDeactivateESF(car)
            end)
        elseif pursuit_tech.Tech == "Stunmine" then --MINE
            local Cooldown = pursuit_tech.Cooldown
            if CurTime() - pursuit_tech.LastUsed < Cooldown then return end
            
            UVDeployStunmine(car)
            
            if IsValid(driver) then
                UVPTEvent({driver}, 'StunMine', 'Use')
            end
            
            pursuit_tech.LastUsed = CurTime()
            pursuit_tech.Ammo = pursuit_tech.Ammo - 1
            used = true

        elseif pursuit_tech.Tech == "Jammer" then --JAMMER
            local Cooldown = pursuit_tech.Cooldown
            if CurTime() - pursuit_tech.LastUsed < Cooldown then return end
            
            UVDeployJammer(car)
            
            if IsValid(driver) then
                UVPTEvent('all', 'Jammer', 'Use', {['User'] = UVGetDriverName(car)})
            end
            
            pursuit_tech.LastUsed = CurTime()
            pursuit_tech.Ammo = pursuit_tech.Ammo - 1
            used = true

        elseif pursuit_tech.Tech == "Spikestrip" then --SPIKESTRIP
            local Cooldown = pursuit_tech.Cooldown
            if CurTime() - pursuit_tech.LastUsed < Cooldown then return end

            if car.UnitVehicle then
                UVChatterSpikeStripDeployed(car)
            end

            UVDeploySpikeStrip(car, not car.UnitVehicle)

            timer.Simple( .5, function()
                if IsValid(car) and (not UVJammerDeployed or car.exemptfromjammer) then
                    if (car.UnitVehicle and pursuit_tech.Upgraded) or (car.RacerVehicle) then
                        UVDeploySpikeStrip(car, not car.UnitVehicle)
                    end
                end
            end)
            
            pursuit_tech.LastUsed = CurTime()
            pursuit_tech.Ammo = pursuit_tech.Ammo - 1
            used = true

            if IsValid(driver) then
                UVPTEvent({driver}, 'Spikestrip', 'Use')
            end
        elseif pursuit_tech.Tech == 'Repair Kit' then
            local Cooldown = pursuit_tech.Cooldown
            if CurTime() - pursuit_tech.LastUsed < Cooldown then return end

            if car.UnitVehicle then
                UVChatterRepairKitDeployed(car)
            end
            
            local repaired = UVDeployRepairKit(car)

            if repaired then
                pursuit_tech.LastUsed = CurTime()
                pursuit_tech.Ammo = pursuit_tech.Ammo - 1
                used = true

                if IsValid(driver) then
                    UVPTEvent({driver}, 'RepairKit', 'Use')
                end
            end
        elseif pursuit_tech.Tech == 'Killswitch' then
            local Cooldown = pursuit_tech.Cooldown
            if CurTime() - pursuit_tech.LastUsed < Cooldown then return end
            
            local result = UVDeployKillSwitch(car)
            
            if result then
                used = true
                pursuit_tech.LastUsed = CurTime()
                pursuit_tech.Ammo = pursuit_tech.Ammo - 1
            end
        elseif pursuit_tech.Tech == 'Power Play' then
            local Cooldown = pursuit_tech.Cooldown
            if CurTime() - pursuit_tech.LastUsed < Cooldown then return end
            
            local result = UVPowerPlay(car)
            
            if result then
                used = true
                pursuit_tech.LastUsed = CurTime()
                pursuit_tech.Ammo = pursuit_tech.Ammo - 1

                if IsValid(driver) then
                    UVPTEvent({driver}, 'PowerPlay', 'Use')
                end
            end
        elseif pursuit_tech.Tech == 'EMP' then
            local Cooldown = pursuit_tech.Cooldown
            if CurTime() - pursuit_tech.LastUsed < Cooldown then return end
            
            local result = UVDeployEMP(car)
            
            if result then
                used = true
                pursuit_tech.LastUsed = CurTime()
                pursuit_tech.Ammo = pursuit_tech.Ammo - 1
            end
        end

        if used then
            UVReplicatePT( car, slot )
        end

        return used
    end
    
    --SPIKESTRIP
    function UVDeploySpikeStrip(unit, racer)
        local spikes = ents.Create("entity_uvspikestrip")
        spikes.uvdeployed = true
        local timecheck
        if racer then
            timecheck = UVPTSpikeStripDuration:GetInt()
            spikes.racerdeployed = unit
        else
            timecheck = UVUnitPTSpikeStripDuration:GetInt()
            spikes.unitdeployed = unit
        end
        local ph = unit:GetPhysicsObject()
        spikes:SetPos(unit:WorldSpaceCenter())
        if unit:GetClass() == "prop_vehicle_jeep" then
            spikes:SetAngles(ph:GetAngles())
        else
            spikes:SetAngles(ph:GetAngles()+Angle(0,90,0))
        end
        spikes:Spawn()
        spikes.PhysgunDisabled = false
        local phspikes = spikes:GetPhysicsObject()
        phspikes:EnableMotion(true)
        phspikes:SetVelocity(ph:GetVelocity())
        timer.Simple(timecheck, function() 
            if IsValid(spikes) then 
                if UVTargeting and not racer then
                    UVSpikestripsDodged = UVSpikestripsDodged + 1
                end
                spikes:Remove()
            end
        end)
    end

    -- EMP
    function UVDeployEMP(car)
        if car.empTarget then return false end
        
        local vehiclePool = {}
        local isUnit = car.UnitVehicle
        local carCreationID = car:GetCreationID()
        local carEntityIndex = car:EntIndex()
        local carPos = car:WorldSpaceCenter()
        local carDriver = UVGetDriver( car )
        local hookIdentifier = "UVEMP_"..carEntityIndex

        local useCooldown = 5

        local target, targetDriver, targetCreationID, targetEntityIndex = nil

        table.Add( vehiclePool, UVPotentialSuspects )
        if not isUnit then table.Add( vehiclePool, UVPotentialSuspects ) end

        local shortestTargetDistance = math.huge

        for _, v in pairs( vehiclePool ) do
            local vehicleDistance = v:WorldSpaceCenter():DistToSqr(carPos)
            if UVIsVehicleInCone( car, v, 90, 1000000 ) and vehicleDistance < shortestTargetDistance and not v.LockedOnBy then
                target = v
                shortestTargetDistance = vehicleDistance
                break
            end
        end

        local lastUse = car.lastEMPUse or 0

        if not target then
            if CurTime() - lastUse >= useCooldown then 
                car.lastEMPUse = CurTime()

                UVPTEvent(
                    {carDriver}, 
                    'EMP', 
                    'NoTarget'
                )
            end

            return false
        end

        targetDriver = UVGetDriver( target )
        targetCreationID = target:GetCreationID()
        targetEntityIndex = target:EntIndex()

        car.empTarget = target
        car.startLock = CurTime()

        target.LockedOnBy = car
        
        local function cleanup()
            car.empTarget = nil
            car.startLock = nil
            target.LockedOnBy = nil

            hook.Remove( "Think", hookIdentifier )
        end

        hook.Add( "Think", hookIdentifier, function()
            if not IsValid( car ) or not IsValid( target ) then return cleanup() end

            if CurTime() - car.startLock >= 5 then
                cleanup()

                if not UVIsVehicleInCone( car, target, 90, 1000000 ) then 
                    UVPTEvent( 
                        {
                            carDriver,
                            targetDriver
                        }, 
                        'EMP', 
                        'Missed'
                    )

                    return false
                end

                local effData = EffectData()
                effData:SetEntity(target)
                util.Effect( "entity_remove", effData )

                local damage = ( isUnit and UVUnitPTEMPDamage:GetFloat() ) or UVPTEMPDamage:GetFloat()
                local force = ( isUnit and UVUnitPTEMPForce:GetInt() ) or UVPTEMPForce:GetInt()
                local lastHeadlightState = UVGetHeadlight( target )
                
                UVDamage( 
                    target, 
                    damage
                )

                hook.Add( "Think", hookIdentifier .. "headlight", function() 
                    UVSetHeadlight( 
                        target, 
                        math.random( 0, 2 ) 
                    ) 
                end)

                timer.Simple( 1, function()
                    hook.Remove( "Think", hookIdentifier .. "headlight" )
                    UVSetHeadlight( 
                        target, 
                        lastHeadlightState 
                    )
                end)

                local targetPhysObj = target:GetPhysicsObject()
                local targetForward = target:GetForward()
                local targetRight = target:GetRight()

                local targetPos = target:WorldSpaceCenter()

                targetPhysObj:ApplyForceOffset( 
                    ( math.Rand( -1, 1 ) * targetRight ) * ( targetPhysObj:GetMass() * force ), -- ( force / 100 )
                    targetPos - ( targetForward * 100 )
                )

                --

                UVPTEvent( 
                    {
                        carDriver,
                        targetDriver
                    }, 
                    'EMP', 
                    'Hit',
                    {
                        targetEntityIndex, 
                        targetCreationID
                    }
                )
            end
        end )

        car:CallOnRemove("UVEMP_"..carEntityIndex, function() cleanup() end)

        UVPTEvent( 
            {
                carDriver, 
                targetDriver
            }, 
            'EMP', 
            'Locking',
            {
                targetEntityIndex, 
                targetCreationID
            }
        )

        return true
    end
    
    --REPAIR KIT
    function UVDeployRepairKit(car)
        local is_repaired = false
        
        if car:GetClass() == "prop_vehicle_jeep" then
            if vcmod_main then
                if car:VC_getHealthMax() == car:VC_getHealth() then return end
                is_repaired = true
                car:EmitSound('ui/pursuit/repair.wav')
                car:VC_repairFull_Admin()
            else
                local mass = vehicle:GetPhysicsObject():GetMass()
                vehicle:SetMaxHealth(mass)
                vehicle:SetHealth(mass)
                vehicle:StopParticles()
            end
        end
        if car.IsSimfphyscar then
            local repaired_tires = false 
            
            if istable(car.Wheels) then
                for i = 1, table.Count( car.Wheels ) do
                    local Wheel = car.Wheels[ i ]
                    if IsValid(Wheel) and Wheel:GetDamaged() then
                        repaired_tires = true
                        Wheel:SetDamaged( false )
                    end
                end
            end
            
            if not repaired_tires and car:GetCurHealth() == car:GetMaxHealth() then return end
            
            is_repaired = true
            car:EmitSound('ui/pursuit/repair.wav')
            
            -- TODO: There is some bug when AI is using a simfphys car, GetMaxHealth for some reason returns -inf...
            if IsValid(car:GetDriver()) then
                car.simfphysoldhealth = car:GetMaxHealth()
                car:SetCurHealth(car:GetMaxHealth())
            end
            
            car:SetOnFire( false )
            car:SetOnSmoke( false )
            
            net.Start( "simfphys_lightsfixall" )
            net.WriteEntity( car )
            net.Broadcast()
            
            net.Start( "uvrepairsimfphys" )
            net.WriteEntity( car )
            net.Broadcast()
            
            car:OnRepaired()
        end
        if car.IsGlideVehicle then
            local repaired = false
            
            for _, v in pairs(car.wheels) do
                if IsValid(v) and v.bursted then
                    repaired = true
                    v:_restore()
                end
            end

            if not repaired and car:GetChassisHealth() >= car.MaxChassisHealth then return end
            is_repaired = true
            car:EmitSound('ui/pursuit/repair.wav')
            car:Repair()
        end
        
        local driver = UVGetDriver(car)
        
        if driver then
            if driver:IsPlayer() then
                if driver:GetMaxHealth() == 100 then
                    driver:SetHealth(car:GetPhysicsObject():GetMass())
                    driver:SetMaxHealth(car:GetPhysicsObject():GetMass())
                end
            end
        end
        
        return is_repaired
    end
    
    --STUNMINE
    function UVDeployStunmine(unit)
        local mine = ents.Create("entity_uvstunmine")
        mine.uvdeployed = true
        mine.racerdeployed = unit
        mine.deployedby = UVGetDriverName(unit)
        local ph = unit:GetPhysicsObject()
        mine:SetPos(unit:WorldSpaceCenter())
        mine:SetAngles(ph:GetAngles())
        mine:Spawn()
        mine.PhysgunDisabled = false
        local phmine = mine:GetPhysicsObject()
        phmine:EnableMotion(true)
        phmine:SetVelocity(Vector(0,0,0))
        timer.Simple(60, function() 
            if IsValid(mine) then 
                mine:Remove()
            end
        end)
    end
    
    --ESF
    function UVDeployESF(car)
        local driver = UVGetDriver(car)

        car.esfon = true
        local e = EffectData()
        e:SetEntity(car)
        util.Effect("entity_remove", e)
        net.Start("UVWeaponESFEnable")
        net.WriteEntity(car)
        net.Broadcast()
    end
    
    function UVDeactivateESF(car)
        if not car.esfon then return end

        if IsValid(car) then
            car.esfon = nil

            net.Start("UVWeaponESFDisable")
            net.WriteEntity(car)
            net.Broadcast()

            car:StopSound("gadgets/esf/onloop.wav")

            local e = EffectData()
            e:SetEntity(car)
            util.Effect("entity_remove", e)
            car:EmitSound("gadgets/esf/off.wav")

            if not car.uvesfhit and car.uvesfdeployed and car.esfon then
                -- if isfunction(car.GetDriver) and IsValid(UVGetDriver(car)) and UVGetDriver(car):IsPlayer() then 
                --     UVGetDriver(car):PrintMessage( HUD_PRINTCENTER, "ESF deactivated!")
                -- end
                UVPTEvent( {UVGetDriver(car)}, 'ESF', 'Deactivate' )
            end

            car.uvesfhit = nil
        end
    end
    
    function UVDeployKillSwitch(car)
        if next(UVWantedTableVehicle) ~= nil then
            car.uvkillswitchingtarget = nil
            
            local suspects = UVWantedTableVehicle
            local r = math.huge
            local closestdistancetosuspect, closestsuspect = r^2
            for i, w in pairs(suspects) do
                local carPos = car:WorldSpaceCenter()
                local distance = carPos:DistToSqr(w:WorldSpaceCenter())
                if distance < closestdistancetosuspect then
                    closestdistancetosuspect, closestsuspect = distance, w
                end
            end
            
            if closestdistancetosuspect < 250000 then
                car.uvkillswitchingtarget = closestsuspect
                car.uvkillswitching = true
                local MathSound = math.random(1,2)
                car:EmitSound("gadgets/killswitch/start"..MathSound..".wav")
                closestsuspect:EmitSound("gadgets/killswitch/startloop.wav")
				
                ReportPTEvent( car, closestsuspect, 'Killswitch', 'Locking' )
                timer.Simple(UVUnitPTKillSwitchLockOnTime:GetInt(), function() --HIT
                    if IsValid(car) and IsValid(car.uvkillswitchingtarget) then
                        if car.uvkillswitching and not car.uvkillswitchingtarget.enginedisabledbyuv then
                            car.uvkillswitching = nil
                            local kstime = UVUnitPTKillSwitchDisableDuration:GetInt()
                            local enemyVehicle = car.uvkillswitchingtarget
                            local enemyCallsign = enemyVehicle.racer or "Racer "..enemyVehicle:EntIndex()
                            local enemyDriver = UVGetDriver(enemyVehicle)
                            
                            if enemyDriver and enemyDriver:IsPlayer() then
                                enemyCallsign = enemyDriver:GetName()
                            end
                            if enemyVehicle.IsSimfphyscar then
                                enemyVehicle:SetActive(false)
                            elseif enemyVehicle.IsGlideVehicle then
                                enemyVehicle:TurnOff()
                            elseif enemyVehicle:GetClass() == "prop_vehicle_jeep" then
                                enemyVehicle:StartEngine(false)
                            end
                            -- if isfunction(enemyVehicle.GetDriver) and IsValid(UVGetDriver(enemyVehicle)) and UVGetDriver(enemyVehicle):IsPlayer() then 
                            --     UVGetDriver(enemyVehicle):PrintMessage( HUD_PRINTCENTER, "YOU HAVE BEEN KILLSWITCHED!")
                            -- end
                            -- if isfunction(car.GetDriver) and IsValid(UVGetDriver(car)) and UVGetDriver(car):IsPlayer() then 
                            --     UVGetDriver(car):PrintMessage( HUD_PRINTCENTER, "KILLSWITCHED "..enemyCallsign.."!")
                            -- end
                            ReportPTEvent( car, closestsuspect, 'Killswitch', 'Hit' )
                            enemyVehicle.enginedisabledbyuv = true
                            car:StopSound("gadgets/killswitch/start1.wav")
                            car:StopSound("gadgets/killswitch/start2.wav")
                            enemyVehicle:StopSound("gadgets/killswitch/startloop.wav")
                            enemyVehicle:EmitSound("gadgets/killswitch/hit.wav")
                            timer.Simple(kstime, function() 
                                if IsValid(enemyVehicle) then
                                    if enemyVehicle.IsSimfphyscar then
                                        enemyVehicle:SetActive(true)
                                        enemyVehicle:StartEngine()
                                    elseif enemyVehicle.IsGlideVehicle then
                                        enemyVehicle:TurnOn()
                                    elseif enemyVehicle:GetClass() == "prop_vehicle_jeep" then
                                        enemyVehicle:StartEngine(true)
                                    end
                                    -- if isfunction(enemyVehicle.GetDriver) and IsValid(UVGetDriver(enemyVehicle)) and UVGetDriver(enemyVehicle):IsPlayer() then 
                                    --     UVGetDriver(enemyVehicle):PrintMessage( HUD_PRINTCENTER, "Engine restarted!")
                                    -- end
                                    UVPTEvent( {UVGetDriver( enemyVehicle )}, 'Killswitch', 'EngineRestarting' )
                                    enemyVehicle.enginedisabledbyuv = nil
                                end
                            end)
                            car.PursuitTechStatus = "Reloading"
                            timer.Simple(UVUnitPTDuration:GetInt(), function()
                                if IsValid(car) and car.uvkillswitchdeployed and not car.wrecked then
                                    car.uvkillswitchdeployed = nil
                                    car:EmitSound("buttons/button4.wav")
                                    car.PursuitTechStatus = "Ready"
                                end
                            end)
                            car.uvkillswitchingtarget = nil
                            if car.UnitVehicle then
                                UVChatterKillswitchHit(car.UnitVehicle)
                            end
                        end
                    end
                end)
                return true
            else
                car.uvkillswitchdeployed = nil
                car.uvkillswitchingtarget = nil
                if isfunction(car.GetDriver) and IsValid(UVGetDriver(car)) and UVGetDriver(car):IsPlayer() then 
					if not car.uvNextTooFarTime or car.uvNextTooFarTime < CurTime() then
						UVPTEvent({UVGetDriver(car)}, 'Killswitch', 'TooFar')
						car.uvNextTooFarTime = CurTime() + 3
					end
                end
                
                return false
            end
            
        else
            car.uvkillswitchdeployed = nil
            car.uvkillswitchingtarget = nil
            if isfunction(car.GetDriver) and IsValid(UVGetDriver(car)) and UVGetDriver(car):IsPlayer() then 
				if not car.uvNextNoTargetTime or car.uvNextNoTargetTime < CurTime() then
					UVPTEvent({UVGetDriver(car)}, 'Killswitch', 'NoTarget')
					car.uvNextNoTargetTime = CurTime() + 3
				end
            end
            
            return false
        end
    end
    
    function UVKillSwitchCheck(car)
        local enemy = car.uvkillswitchingtarget
        local AI = car.UnitVehicle
        
        if not IsValid(enemy) or (UVJammerDeployed and not car.exemptfromjammer) then
            UVDeactivateKillSwitch(car)
            return
        end
        
        local carPos = car:WorldSpaceCenter()
        local distance = carPos:DistToSqr(enemy:WorldSpaceCenter())
        
        if distance > 250000 then
            UVDeactivateKillSwitch(car)
        end
    end
    
    function UVDeactivateKillSwitch(car)
        if not car.uvkillswitching then return end

        car.uvkillswitching = nil
        local enemyVehicle = car.uvkillswitchingtarget
        if IsValid(enemyVehicle) then
            enemyVehicle:StopSound("gadgets/killswitch/startloop.wav")
            enemyVehicle:EmitSound("gadgets/killswitch/miss.wav")
            -- if isfunction(enemyVehicle.GetDriver) and IsValid(UVGetDriver(enemyVehicle)) and UVGetDriver(enemyVehicle):IsPlayer() then 
            --     UVGetDriver(enemyVehicle):PrintMessage( HUD_PRINTCENTER, "Killswitch countered!")
            -- end
        end

        car:StopSound("gadgets/killswitch/start1.wav")
        car:StopSound("gadgets/killswitch/start2.wav")

        -- if isfunction(car.GetDriver) and IsValid(UVGetDriver(car)) and UVGetDriver(car):IsPlayer() then 
        --     UVGetDriver(car):PrintMessage( HUD_PRINTCENTER, "Killswitch missed!")
        -- end

        ReportPTEvent( car, enemyVehicle, 'Killswitch', 'Counter' )

        -- car.PursuitTechStatus = "Reloading"
        -- timer.Simple(UVUnitPTDuration:GetInt(), function()
        --     if IsValid(car) and car.uvkillswitchdeployed and not car.wrecked then
        --         car.uvkillswitchdeployed = nil
        --         car:EmitSound("buttons/button4.wav")
        --         car.PursuitTechStatus = "Ready"
        --     end
        -- end)

        -- car.uvkillswitchingtarget = nil
        if car.UnitVehicle then
            UVChatterKillswitchMissed(car.UnitVehicle)
        end

    end
    
    --SHOCKWAVE
    function UVDeployShockwave(car)
        local carchildren = car:GetChildren()
        local carconstraints = constraint.GetAllConstrainedEntities(car)
        local carPos = car:WorldSpaceCenter()
        local objects = ents.FindInSphere(carPos, 1000)

        -- local attacker = UVGetDriver(car)
        -- local attackerName = UVGetDriverName(car)

        -- local playersToSendTo = {}
        -- local args = {
        --     ['User'] = attackerName,
        --     ['Hit'] = {}
        -- }

        -- if attacker then
        --     table.insert( playersToSendTo, attacker )
        -- end

        local affectedTargets = {}

        for k, object in pairs(objects) do
            if not object.UnitVehicle and not car.UnitVehicle and not RacerFriendlyFire:GetBool() then
			elseif object ~= car and (not table.HasValue(carchildren, object) and not table.HasValue(carconstraints, object) and IsValid(object:GetPhysicsObject()) or object.UnitVehicle or object.UVWanted or object:GetClass() == "entity_uv*" or object.uvdeployed) then

                local objectphys = object:GetPhysicsObject()
                local vectorDifference = object:WorldSpaceCenter() - carPos

                local angle = vectorDifference:Angle()
                local power = UVPTShockwavePower:GetFloat()
                local damage = UVPTShockwaveDamage:GetFloat()
                local force = power * (1 - (vectorDifference:Length()/1000))

                objectphys:ApplyForceCenter(angle:Forward()*force)
                object.rammed = true

                timer.Simple(3, function()
                    if IsValid(object) then
                        object.rammed = nil
                    end
                end)

                --local victim = UVGetDriver(object)
                --local victimName = UVGetDriverName(object)

                --table.insert( args.Hit, victimName )

                -- if victim then
                --     table.insert( playersToSendTo, victim )
                -- end
                
                local attachVictim = false
                --if object.UnitVehicle then
                    damage = (table.HasValue(UVCommanders, object) and UVPTShockwaveCommanderDamage:GetFloat()) or damage
                    local phmass = math.Round(objectphys:GetMass())
                    UVBounty = UVBounty+phmass
                    if object.IsSimfphyscar then
                        if object.UnitVehicle or object.UVWanted and not GetConVar("unitvehicle_autohealth"):GetBool() then
                            local MaxHealth = object:GetMaxHealth()
                            local damage = MaxHealth*damage
                            object:ApplyDamage( damage, DMG_GENERIC )
                        end
                        --local victim = UVGetDriver(object)
                        attachVictim = true
                    elseif object.IsGlideVehicle then
                        if object.UnitVehicle or (object.UVWanted and not GetConVar("unitvehicle_autohealth"):GetBool()) or not (object.UnitVehicle and object.UVWanted) then
                            object:SetEngineHealth( object:GetEngineHealth() - damage )
                            object:UpdateHealthOutputs()
                        end
                        
                        attachVictim = true
                    elseif object:GetClass() == "prop_vehicle_jeep" then
                        attachVictim = true
                    end
                --end

                if attachVictim then
                    -- local victimName = UVGetDriverName(object)
                    -- table.insert( args.Hit, victimName )
                    table.insert( affectedTargets, object )
                end
            end
        end

        local MathSound = math.random(1,4)
        car:EmitSound( "gadgets/shockwave/"..MathSound..".wav" )

        local effect = EffectData()
        effect:SetEntity(car)
        util.Effect("entity_remove", effect)
        util.ScreenShake( carPos, 5, 5, 1, 1000 )

        if #affectedTargets > 0 then
            ReportPTEvent( car, affectedTargets, 'Shockwave', 'Hit' )
        end
    end

    --JAMMER
    function UVDeployJammer(car)
        if UVJammerDeployed then return end
        
        UVJammerDeployed = true
        car.jammerdeployed = true
        car.jammerexempt = true
        
        if UVBackupUnderway and not UVBackupTenSeconds and UVResourcePointsTimerMax then
            UVResourcePointsTimerMax = UVResourcePointsTimerMax + 10
        end
        
        net.Start("UVWeaponJammerEnable")
        if (UVGetDriver(car) and UVGetDriver(car):IsPlayer()) then
            net.WriteEntity(UVGetDriver(car))
        end
        net.Broadcast()
        
        car:EmitSound( "gadgets/jammer/loop2.wav" )
        
        car:CallOnRemove("UVJammerRemove", function()
            UVEndJammer(car)
        end)
        
        timer.Simple(UVPTJammerDuration:GetInt(), function()
            if IsValid(car) then
                UVEndJammer(car)
                car:RemoveCallOnRemove("UVJammerRemove")
            end
        end)
        
        for k, unit in pairs(ents.FindByClass("npc_uv*")) do
            if unit.v then
                UVDeactivateESF(unit.v)
                UVDeactivateKillSwitch(unit.v)
            end
        end
        
        for k, unitplayers in pairs(UVPlayerUnitTableVehicle) do
            if IsValid(unitplayers) then
                UVDeactivateESF(UVPlayerUnitTableVehicle)
                UVDeactivateKillSwitch(UVPlayerUnitTableVehicle)
            end
        end
        
        for k, weapon in pairs(ents.FindByClass("entity_uv*")) do
            if weapon:GetClass() ~= "entity_uvrepairshop" and weapon:GetClass() ~= "entity_uvbombstrip" then
                local f = EffectData()
                f:SetEntity(weapon)
                util.Effect("entity_remove", f)
                weapon:Remove()
            end
            if weapon:GetClass() == "entity_uvbombstrip" then
                weapon:BombExplode()
            end
        end
        
        UVSoundChatter(car, 1, "", 3)
        
    end
    
    function UVEndJammer(car)
        UVJammerDeployed = nil
        car.jammerexempt = nil
        net.Start("UVWeaponJammerDisable")
        if IsValid(UVGetDriver(car)) then
            net.WriteEntity(UVGetDriver(car))
        end
        net.Broadcast()
        car:StopSound( "gadgets/jammer/loop2.wav" )
        car:EmitSound( "gadgets/jammer/deactivate1.wav" )
        
        if UVTargeting then
            UVSoundChatter(car, 1, "dispatchjammerend", 8)
        end
    end

    --POWER PLAY
    function UVPowerPlay(car)
        local pos = car:WorldSpaceCenter()

        local function WreckClosestUnit(car)
            local closest_unit
            local shortest_distanceunit = math.huge
            
            for _, ent in ents.Iterator() do
                if IsValid(ent) then
                    if ent.UnitVehicle then
                        local distunit = pos:Distance(ent:GetPos())
                    
                        if distunit < shortest_distanceunit then
                            shortest_distanceunit = distunit
                            closest_unit = ent
                        end
                    end
                end
            end

            if IsValid(closest_unit) then
                if closest_unit.UnitVehicle then
                    if closest_unit.UnitVehicle:IsNPC() then
                        closest_unit.UnitVehicle:Wreck()
                    else
                        UVPlayerWreck(closest_unit)
                    end
                    return closest_unit
                end
            else
                if isfunction(car.GetDriver) and IsValid(UVGetDriver(car)) and UVGetDriver(car):IsPlayer() then 
		            if not car.uvNextNoPBTime or car.uvNextNoPBTime < CurTime() then
		            	UVPTEvent({UVGetDriver(car)}, 'PowerPlay', 'NoPB')
		            	car.uvNextNoPBTime = CurTime() + 3
		            end
                end

                return false
            end
        end

        if next(UVLoadedPursuitBreakers) == nil then --No PB
            return WreckClosestUnit(car)
        end

        local closest_ent
        local shortest_distance = math.huge
        local maximum_distance = 75000000

        for _, ent in ents.Iterator() do
            if IsValid(ent) then
                if ent.PursuitBreaker then
                    local dist = pos:DistToSqr(ent:GetPos())

                    if dist < shortest_distance and dist <= maximum_distance then
                        shortest_distance = dist
                        closest_ent = ent
                    end
                end
            end
        end
        
        if IsValid(closest_ent) then
            return UVTriggerPursuitBreaker(closest_ent, car)
        -- else --It can happen :3
        --     return WreckClosestUnit(car)
        else
            if isfunction(car.GetDriver) and IsValid(UVGetDriver(car)) and UVGetDriver(car):IsPlayer() then 
                if not car.uvNextNoPBTime or car.uvNextNoPBTime < CurTime() then
                    UVPTEvent({UVGetDriver(car)}, 'PowerPlay', 'NoPB')
                    car.uvNextNoPBTime = CurTime() + 3
                end
            end

            return false
        end
    end
    
else

    UVWithESF = {}
    
    net.Receive("UVUnitTakedown", function()
		if UVHUDCopMode then return end
		if UVHUDDisplayRacing then return end
		
		local unitType = net.ReadString()
        local name = net.ReadString()
        local bounty = net.ReadUInt( 32 )
        local bountyCombo = net.ReadUInt( 7 )
        local isPlayer = net.ReadBool()
        hook.Run( 'UIEventHook', 'pursuit', 'onUnitTakedown', unitType, name, string.Comma( bounty ), bountyCombo, isPlayer)
    end)
    
    net.Receive("UVWeaponJammerEnable", function()
        local ply = net.ReadEntity()
        if ply ~= LocalPlayer() then --VICTIM
            uvclientjammed = true
            surface.PlaySound( "gadgets/jammer/activate2.wav" )
            LocalPlayer():EmitSound("gadgets/jammer/loop1.wav", 100, 100, 1, CHAN_STATIC)
            hook.Add("RenderScreenspaceEffects", "UVJammedScreen", function()
                DrawMaterialOverlay( "effects/tvscreen_noise003a", 1 )
            end )
            -- notification.AddLegacy( "YOU'RE BEING JAMMED!", NOTIFY_ERROR, 10 )
        else --ATTACKER
            surface.PlaySound( "gadgets/jammer/activate1.wav" )
            -- notification.AddLegacy( "Jammer is now active!", NOTIFY_GENERIC, 10 )
        end
    end)
    
    net.Receive("UVWeaponJammerDisable", function()
        local ply = net.ReadEntity()
        if ply ~= LocalPlayer() then --VICTIM
            uvclientjammed = nil
            LocalPlayer():StopSound( "gadgets/jammer/loop1.wav" )
            surface.PlaySound( "gadgets/jammer/deactivate1.wav" )
        else --ATTACKER
            surface.PlaySound( "gadgets/jammer/deactivate2.wav" )
        end
        hook.Remove("RenderScreenspaceEffects", "UVJammedScreen")
    end)

    --[[
        EXPECTED DATA:
        - EventType (UINT, 15)
            1 = Message
            2 = Event
        - Args (DATA)
    ]]
    net.Receive("UVPTEvent", function()
        local pt = net.ReadString()
        local eventType = net.ReadString() --net.ReadUInt( 15 )
        local isArgsSent = net.ReadBool()

        local args = nil

        if isArgsSent then
            args = util.JSONToTable( util.Decompress( net.ReadData( net.ReadUInt( 16 ) ) ) )
        end
        hook.Run( 'onPTEvent', pt, eventType, args )
    end)
    
    hook.Add("Think", "UVClientWeaponThink", function()
        if not UVWithESF then
            UVWithESF = {}
        end
    end)
    
    net.Receive("UVWeaponESFEnable", function()
        local unit = net.ReadEntity()
        table.insert(UVWithESF, unit)
    end)
    
    net.Receive("UVWeaponESFDisable", function()
        local unit = net.ReadEntity()
        table.RemoveByValue(UVWithESF, unit)
    end)
    
    hook.Add("PreDrawHalos", "UVWeaponESFShow", function()
        if next(UVWithESF) == nil then return end
        halo.Add( UVWithESF, Color(255,255,255), 10, 10, 1 )
    end)
    
    -- hook.Add( "HUDPaint", "UVNotifications", function()
    --     if UVCenterNotification then 
    --         local h = ScrH()/2.7
    --         local w = ScrW()/2
            
    --         --noti_draw (UVCenterNotification, "UVFont5", ScrW() / 2, ScrH() / 2.7, Color(158, 215, 0, 255 - math.abs( math.sin(CurTime() * 3) * 120)))
    --         noti_draw (UVCenterNotification, "UVFont5Shadow", ScrW() / 2, ScrH() / 2.7, Color(255, 255, 255, 255 - math.abs( math.sin(CurTime() * 3) * 120)))
            
    --         if UVCenterNotificationIcon then
    --             DrawIcon( UVMaterials[UVCenterNotificationIcon], ScrW() / 2, ScrH() / 3.2, 0.06, Color(255, 255, 255, 255 - math.abs( math.sin(CurTime() * 3) * 120)))
    --         end
    --     end
    -- end)
end