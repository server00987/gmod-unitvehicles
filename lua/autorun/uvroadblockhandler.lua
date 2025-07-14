AddCSLuaFile()

if SERVER then
	
	local function UVSetPhysicsCollisions( ent, collisions )
		
		if ( not IsValid( ent ) or not IsValid( ent:GetPhysicsObject() ) ) then return end
		
		ent:GetPhysicsObject():EnableCollisions( collisions )
		
	end
	
	local function UVRemoveConstraints( ent, const_type )
		if ( not ent.Constraints ) then return end
		
		local c = ent.Constraints
		local i = 0
		
		for k, v in pairs( c ) do
			
			if ( not IsValid( v ) ) then
				
				c[ k ] = nil
				
			elseif ( v.Type == const_type ) then
				
				if v.Ent1:GetClass() == "gmod_thruster" or v.Ent2:GetClass() == "gmod_thruster" then --Ignore thrusters
					c[ k ] = nil
				else
					UVSetPhysicsCollisions( v.Ent1, true )
					UVSetPhysicsCollisions( v.Ent2, true )
					
					c[ k ] = nil
					v:Remove()
					
					i = i + 1
				end
			end
			
		end
		
		if ( table.IsEmpty( c ) ) then
			ent:IsConstrained()
		end
		
		local bool = i ~= 0
		return bool, i
		
	end
	
	local function RemoveRoadblock(ent)
		
		if not IsValid( ent ) then return end
		
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
	
	function UVLoadRoadblock(jsonfile, manual)
		local JSONData = file.Read( "unitvehicles/roadblocks/"..game.GetMap().."/"..jsonfile, "DATA" )
		if not JSONData then return end
		
		local rbdata = util.JSONToTable(JSONData, true) --Load Roadblock
		
		local location = rbdata.Location or rbdata.Maxs
		local angles = rbdata.Angle or angle_zero
		local disperse = rbdata.DisperseAfterPassing
		
		if UVRBOverride:GetInt() == 1 then
			disperse = true
		elseif UVRBOverride:GetInt() >= 2 then
			disperse = false
		end
		
		if not manual then
			if UVHeatLevel < rbdata.HeatLevel then return end
			if #UVLoadedRoadblocks >= UVRBMax:GetInt() then return end
		end
		
		local gib
		if not manual then
			gib = ents.Create("prop_physics") --Cooldown
			gib:SetModel("models/props_phx/misc/gibs/egg_piece1.mdl")
			gib:SetPos(location)
			gib:SetAngles(angles)
			gib:Spawn()
			gib.PhysgunDisabled = false
			gib:GetPhysicsObject():EnableMotion(false)
			gib:SetCollisionGroup(10)
			gib:SetColor(Color(255,255,255,0))

			net.Start("UVHUDAddUV")
			net.WriteInt(gib:EntIndex(), 32)
			net.WriteInt(gib:GetCreationID(), 32)
			net.WriteString("roadblock")
			net.Broadcast()
			
			timer.Simple(10, function()
				local Index = gib:EntIndex()
				timer.Create("uvroadblockmarkedfordeletion"..Index, 1, 0, function() 
					if IsValid(gib) then
						local distance = math.huge
						if IsValid(uvenemylocation) then
							distance = gib:GetPos():DistToSqr(uvenemylocation:GetPos())
						end
						if distance > 100000000 and IsValid(gib) or not UVTargeting then
							gib:Remove()
							timer.Remove("uvroadblockmarkedfordeletion"..Index)
							UVRoadblocksDodged = UVRoadblocksDodged + 1
							if table.HasValue(UVLoadedRoadblocks, jsonfile) then
								table.RemoveByValue(UVLoadedRoadblocks, jsonfile)
							end
							if table.HasValue(UVLoadedRoadblocksLoc, location) then
								table.RemoveByValue(UVLoadedRoadblocksLoc, location)
							end
						end
					end
				end) 
			end)
			table.insert(UVLoadedRoadblocks, jsonfile)
			table.insert(UVLoadedRoadblocksLoc, location)
		end
		
		local entities, constraints = duplicator.Paste( Entity(1), rbdata.Entities, rbdata.Constraints )
		
		for k, ent in pairs( entities ) do
			ent.UVRoadblock = ent
			ent.RoadblockLoc = location
			ent.Disperse = disperse
			UVRemoveConstraints( ent, "Weld" )
			if ent:GetClass() ~= "entity_uvroadblockcar" then
				ent:GetPhysicsObject():EnableMotion( true )
			end
			if not manual then
				timer.Simple(10, function()
					local Index = ent:EntIndex()
					timer.Create("uvroadblockmarkedfordeletion"..Index, 1, 0, function() 
						if not IsValid(gib) or not UVTargeting then
							if IsValid(ent) then
								ent:Remove()
								if ent:GetClass() == "entity_uvspikestrip" then
									UVSpikestripsDodged = UVSpikestripsDodged + 1
								end
							end
							timer.Remove("uvroadblockmarkedfordeletion"..Index)
						end
					end)
				end)
			end
		end
		
		return jsonfile
		
	end
	
	function UVAutoLoadRoadblock()
		local roadblocks = file.Find( "unitvehicles/roadblocks/"..game.GetMap().."/*.json", "DATA" )
		
		if not roadblocks then return end
		if next(roadblocks) == nil then return end
		
		local availableroadblocks = {}
		for k, v in pairs(roadblocks) do
			if not table.HasValue(UVLoadedRoadblocks, v) then
				table.insert(availableroadblocks, v)
			end
		end
		
		if next(availableroadblocks) == nil then return end
		table.Shuffle(availableroadblocks)
		
		for k, jsonfile in pairs(availableroadblocks) do
			local JSONData = file.Read( "unitvehicles/roadblocks/"..game.GetMap().."/"..jsonfile, "DATA" )

			if JSONData then
				
				local rbdata = util.JSONToTable(JSONData, true) --Load Roadblock
				
				local location = rbdata.Location or rbdata.Maxs
				
				local ply = Entity(1)
				local enemylocation
				local suspect = ply
				if next(UVWantedTableVehicle) ~= nil then
					local suspects = UVWantedTableVehicle
					local random_entry = math.random(#suspects)	
					suspect = suspects[random_entry]
					enemylocation = (suspect:GetPos()+Vector(0,0,50))
				else
					enemylocation = (suspect:GetPos()+Vector(0,0,50))
				end
				local suspectvelocity = suspect:GetVelocity()
				local distance = enemylocation - location
				local vect = distance:GetNormalized()
				local evectdot = vect:Dot(suspectvelocity)
				if not (distance:LengthSqr() < 25000000 or distance:LengthSqr() > 100000000 or evectdot > 0) then
					UVLoadRoadblock(jsonfile)
					break
				end
			end
		end
		
	end
	
else
	
end