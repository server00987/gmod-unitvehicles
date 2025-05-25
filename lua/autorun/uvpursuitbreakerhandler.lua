AddCSLuaFile()

if SERVER then

    util.AddNetworkString("UVAddPursuitBreaker")
    util.AddNetworkString("UVTriggerPursuitBreaker")

    local function RemovePursuitBreaker(ent)

        if !IsValid( ent ) then return end
    
        constraint.RemoveAll( ent )
    
        timer.Simple( 1, function() if (IsValid( ent )) then ent:Remove() end end )
    
        ent:SetNotSolid( true )
        ent:SetMoveType( MOVETYPE_NONE )
        ent:SetNoDraw( true )
    
        local ed = EffectData()
            ed:SetOrigin( ent:GetPos() )
            ed:SetEntity( ent )
        util.Effect( "entity_remove", ed, true, true )
    
    end

    function UVLoadPursuitBreaker(jsonfile, checkdistance)
        local JSONData = file.Read( "unitvehicles/pursuitbreakers/"..game.GetMap().."/"..jsonfile, "DATA" )
        if !JSONData then return end

        local pbdata = util.JSONToTable(JSONData, true) --Load Pursuit Breaker

        local location = pbdata.Location or pbdata.Maxs
        local activeduration = pbdata.ActiveDuration or 10
        local dontunweldprops = pbdata.DontUnweldProps or nil

        if checkdistance then
            local ply = Entity(1)
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
            local distance = enemylocation:DistToSqr(location)
            if distance < 25000000 then
                return
            end
        end

        if table.HasValue(uvloadedpursuitbreakers, jsonfile) then 
            for _, ent in ents.Iterator() do
                if ent.PursuitBreaker == jsonfile then 
                    local ConstrainedEntities = constraint.GetAllConstrainedEntities( ent )
	                for _, ent in pairs( ConstrainedEntities ) do
	                	RemovePursuitBreaker(ent)
	                end
                end
            end
            if table.HasValue(uvloadedpursuitbreakers, jsonfile) then
                table.RemoveByValue(uvloadedpursuitbreakers, jsonfile)
            end
            timer.Simple(1, function()
                if !table.HasValue(uvloadedpursuitbreakers, jsonfile) then
                    UVLoadPursuitBreaker(jsonfile) --Try again
                end
            end)
            return
        end
        table.insert(uvloadedpursuitbreakers, jsonfile)
        table.insert(uvloadedpursuitbreakersloc, location)

        net.Start("UVAddPursuitBreaker")
        net.WriteString(jsonfile)
        net.WriteInt(location.x, 32)
        net.WriteInt(location.y, 32)
        net.WriteInt(location.z, 32)
        net.Broadcast()

        local entities, constraints = duplicator.Paste( Entity(1), pbdata.Entities, pbdata.Constraints )

        for k, ent in pairs( entities ) do
            ent.PursuitBreaker = jsonfile
            ent.PursuitBreakerLoc = location
            ent.ActiveDuration = activeduration
            ent.DontUnweldProps = dontunweldprops
            ent:AddCallback("PhysicsCollide", function(ent, data)
                local object = data.HitEntity

                if data.Speed > 10 and !object:IsWorld() and !object.PursuitBreaker then
                    if ent.PursuitBreaker then
                        UVTriggerPursuitBreaker(ent, object, data.TheirOldVelocity)
                    elseif !ent.PursuitBreakerActive then
                        return
                    end

                    local car

                    if object:GetClass() == "gmod_sent_vehicle_fphysics_wheel" then
                        car = object:GetBaseEnt()
                    elseif object.IsSimfphyscar then
                        car = object
                    elseif object.IsGlideVehicle then
                        car = object
                    elseif object:GetClass() == "prop_vehicle_jeep" then
                        car = object
                    end

                    if !IsValid(car) then return end

                    if car.UnitVehicle then
                        if car.UnitVehicle:IsNPC() then
                            car.UnitVehicle:Wreck()
                        else
                            UVPlayerWreck(car)
                        end
                    end

                end
            end)
        end

    end

    local function UVSetPhysicsCollisions( ent, collisions )

        if ( !IsValid( ent ) or !IsValid( ent:GetPhysicsObject() ) ) then return end
    
        ent:GetPhysicsObject():EnableCollisions( collisions )
    
    end

    local function UVRemoveConstraints( ent, const_type )
        if ( !ent.Constraints ) then return end

    	local c = ent.Constraints
    	local i = 0

    	for k, v in pairs( c ) do

    		if ( !IsValid( v ) ) then

    			c[ k ] = nil

    		elseif ( v.Type == const_type ) then

                if v.Ent1:GetClass() == "gmod_thruster" or v.Ent2:GetClass() == "gmod_thruster" then --Ignore thrusters
                    c[ k ] = nil
                    continue
                end

    			UVSetPhysicsCollisions( v.Ent1, true )
    			UVSetPhysicsCollisions( v.Ent2, true )

    			c[ k ] = nil
    			v:Remove()

    			i = i + 1
    		end

    	end

    	if ( table.IsEmpty( c ) ) then
    		ent:IsConstrained()
    	end

    	local bool = i != 0
    	return bool, i

    end

    function UVTriggerPursuitBreaker(hitent, object, objectvelocity)
        if hitent.PursuitBreakerActive or !hitent.PursuitBreaker then return end

        local entities = {}
        local constraints = {}
        local jsonfile = hitent.PursuitBreaker
        local location = hitent.PursuitBreakerLoc
        local activeduration = hitent.ActiveDuration or 10
        local dontunweldprops = hitent.DontUnweldProps or nil

        hitent.PursuitBreaker = nil

        if table.HasValue(uvloadedpursuitbreakersloc, location) then
            table.RemoveByValue(uvloadedpursuitbreakersloc, location)
        end

        net.Start("UVTriggerPursuitBreaker")
        net.WriteString(jsonfile)
        net.Broadcast()

        duplicator.GetAllConstrainedEntitiesAndConstraints(hitent, entities, constraints)

        local r = math.huge
	    local closestdistance, closestbreakableent = r^2

        for k, ent in pairs(entities) do
            ent.PursuitBreaker = nil
            ent.PursuitBreakerActive = true

            timer.Simple(activeduration, function()
                if IsValid(ent) then
                    ent.PursuitBreakerActive = nil
                end
            end)

            timer.Simple(UVPBCooldown:GetInt(), function()
                if IsValid(ent) then
                    ent:Remove()
                    if table.HasValue(uvloadedpursuitbreakers, jsonfile) then
                        table.RemoveByValue(uvloadedpursuitbreakers, jsonfile)
                    end
                end
            end)

            if !dontunweldprops then
                UVRemoveConstraints(ent, "Weld") --Unweld everything but thrusters
            end

            if ent:GetClass() == "gmod_thruster" then
                ent:SetOn(true)
                ent:StartThrustSound()
            end

            if IsValid(ent:GetPhysicsObject()) then
                ent:GetPhysicsObject():EnableMotion(true)
            end

            if !(ent:Health() < 1) and ent:GetClass() == "prop_physics" then
                local hitentpos = hitent:WorldSpaceCenter()
	    	    local distance = hitentpos:DistToSqr(ent:WorldSpaceCenter())
	    	    if distance < closestdistance then
	    	    	closestdistance, closestbreakableent = distance, ent
	    	    end
            end

        end

        local hitentphys = hitent:GetPhysicsObject()
        local phys = object:GetPhysicsObject()
        if IsValid(phys) and IsValid(hitentphys) then
            hitentphys:SetVelocity(objectvelocity)
            phys:SetVelocity(objectvelocity)
        end

        if !IsValid(closestbreakableent) then return end
        closestbreakableent:Fire("Break")

        local Chatter = GetConVar("unitvehicle_chatter")
        local ChatterText = GetConVar("unitvehicle_chattertext")

        --Check if it's a gas station
        if uvtargeting then
            if string.find(jsonfile:lower(), "gas") then
                UVSoundChatter(hitent, 1, "pursuitbreakergas", 8)
            else
                if Chatter:GetBool() and !ChatterText:GetBool() then
                    local units = ents.FindByClass("npc_uv*")
	                local airunits = ents.FindByClass("uvair")
	                table.Add( units, airunits )
                    if next(units) == nil then return end
                    local randomunit = units[math.random(#units)]
                    UVSoundChatter(randomunit, randomunit.voice, "pursuitbreaker", 4)
                end
            end
        end

    end

    function UVAutoLoadPursuitBreaker()
        local pursuitbreakers = file.Find( "unitvehicles/pursuitbreakers/"..game.GetMap().."/*.json", "DATA" )

        if !pursuitbreakers then return end
        if next(pursuitbreakers) == nil then return end

        local availablepursuitbreakers = {}
        for k, v in pairs(pursuitbreakers) do
            if !table.HasValue(uvloadedpursuitbreakers, v) then
                table.insert(availablepursuitbreakers, v)
            end
        end

        if next(availablepursuitbreakers) == nil then return end
        local randompb = availablepursuitbreakers[math.random(#availablepursuitbreakers)]
        UVLoadPursuitBreaker(randompb, true)
    end

else
    
    net.Receive("UVAddPursuitBreaker", function()
        local jsonfile = net.ReadString()
        local location = Vector(net.ReadInt(32), net.ReadInt(32), net.ReadInt(32))
        if GMinimap then
            blip, id = GMinimap:AddBlip( {
                id = jsonfile,
                position = location,
                icon = "unitvehicles/icons/MINIMAP_ICON_PURSUIT_BREAKER.png",
                scale = 1.5,
                color = Color( 255, 127, 127, 255 ),
                lockIconAng = true
            } )
        end
    end)

    net.Receive("UVTriggerPursuitBreaker", function()
        local jsonfile = net.ReadString()
        if GMinimap then
            GMinimap:RemoveBlipById( jsonfile )
        end
    end)

end