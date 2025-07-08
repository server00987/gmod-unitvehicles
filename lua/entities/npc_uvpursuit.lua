list.Set("NPC", "npc_uvpursuit", {
	Name = "3: Pursuit",
	Class = "npc_uvpursuit",
	Category = "Unit Vehicles"
})
AddCSLuaFile("npc_uvpursuit.lua")
include("entities/uvapi.lua")

ENT.Base = "base_entity"
ENT.Type = "ai"

ENT.PrintName = "UVPursuit"
ENT.Author = "Cross"
ENT.Contact = "Uniform"
ENT.Purpose = "To use proper pursuit tactics against drivers. Yeah, 'proper pursuit tactics'."
ENT.Instruction = "Spawn on/under the vehicle until it shows a spawn effect."
ENT.Spawnable = false
ENT.Modelname = "models/props_lab/huladoll.mdl"

local dvd = DecentVehicleDestination

if SERVER then	
	--Setting ConVars.
	local TargetAllVehicle = GetConVar("unitvehicle_targetallvehicle")
	local TargetDecentVehicle = GetConVar("unitvehicle_targetdecentvehicle")
	local TargetOtherVehicle = GetConVar("unitvehicle_targetothervehicle")
	local DetectionRange = GetConVar("unitvehicle_detectionrange")
	local NeverEvade = GetConVar("unitvehicle_neverevade")
	local BustedTimer = GetConVar("unitvehicle_bustedtimer")
	local EvadeTimer = GetConVar("unitvehicle_evadetimer")
	local CanWreck = GetConVar("unitvehicle_canwreck")
	local Chatter = GetConVar("unitvehicle_chatter")
	local SpeedLimit = GetConVar("unitvehicle_speedlimit")
	local AutoHealth = GetConVar("unitvehicle_autohealth")
	local MinHeatLevel = GetConVar("unitvehicle_minheatlevel")
	local MaxHeatLevel = GetConVar("unitvehicle_maxheatlevel")
	local HeatLevels = GetConVar("unitvehicle_heatlevels")
	local Relentless = GetConVar("unitvehicle_relentless")
	local PursuitTech = GetConVar("unitvehicle_unit_pursuittech")
	local DVWaypointsPriority = GetConVar("unitvehicle_dvwaypointspriority")
	
	function ENT:OnRemove()
		if table.HasValue(UVUnitsChasing, self) then
			table.RemoveByValue(UVUnitsChasing, self)
		end
		if Chatter:GetBool() and IsValid(self.v) and not self.wrecked and not UVTargeting then
			UVChatterOnRemove(self)
		end
		--By undoing, driving, diving in water, or getting stuck, and the vehicle is remaining.
		if IsValid(self.v) and self.v:IsVehicle() then
			self.v.UVPursuit = nil
			self.v.UnitVehicle = nil
			if self.v.IsScar then --If the vehicle is SCAR.
				self.v.HasDriver = self.v.BaseClass.HasDriver --Restore some functions.
				self.v.SpecialThink = self.v.BaseClass.SpecialThink
				if not self.v:HasDriver() then --If there's no driver, stop the engine.
					self.v:TurnOffCar()
					self.v:HandBrakeOn()
					self.v:GoNeutral()
					self.v:NotTurning()
				end
			elseif self.v.IsSimfphyscar then --The vehicle is Simfphys Vehicle.
				self.v.GetDriver = self.v.OldGetDriver or self.v.GetDriver
				if not IsValid(self.v:GetDriver()) then --If there's no driver, stop the engine.
					self.v:StopEngine()
				end
				self.v.PressedKeys = self.v.PressedKeys or {} --Reset key states.
				self.v.PressedKeys["Shift"] = false
				if self.v.wrecked then
					local randomno = math.random(1, 3)
					if randomno == 1 then
						self.v.PressedKeys["Space"] = false
					elseif randomno == 2 then
						self.v.PressedKeys["Space"] = true
					elseif randomno == 3 then
						self.v:SetActive(false)
					end
				end
			elseif not IsValid(self.v:GetDriver()) and --The vehicle is normal vehicle.
			isfunction(self.v.StartEngine) and isfunction(self.v.SetHandbrake) and 
			isfunction(self.v.SetThrottle) and isfunction(self.v.SetSteering) and not self.v.IsGlideVehicle then
				self.v.GetDriver = self.v.OldGetDriver or self.v.GetDriver
				--self.v:StartEngine(false) --Reset states.
				--self.v:SetHandbrake(true)
				self.v:SetThrottle(0)
				--self.v:SetSteering(0, 0)
			elseif self.v.IsGlideVehicle then
				self.v:TurnOff()
				self.v:TriggerInput("Throttle", 0)
				if self.v.wrecked then
					local randomno = math.random(1, 4)
					if randomno == 1 then
						self.v:TriggerInput("Handbrake", 0)
						self.v:TriggerInput("Brake", 0)
					elseif randomno == 2 then
						self.v:TriggerInput("Handbrake", 1)
						self.v:TriggerInput("Brake", 0)
					elseif randomno == 3 then
						self.v:TriggerInput("Handbrake", 0)
						self.v:TriggerInput("Brake", 1)
					elseif randomno == 4 then
						self.v:TriggerInput("Handbrake", 1)
						self.v:TriggerInput("Brake", 1)
					end
				else
					self.v:TriggerInput("Handbrake", 1)
					self.v:TriggerInput("Brake", 0)
				end
			end
			
			self:SetELS(false)
			self:SetELSSound(false)
			self:SetHorn(false)
			
			local e = EffectData()
			e:SetEntity(self.v)
			util.Effect("entity_remove", e) --Perform an effect.
			net.Start("UVHUDRemoveUV")
			net.WriteInt(self.v:EntIndex(), 32)
			net.Broadcast()
			if (self.uvscripted and not self.wrecked) then
				SafeRemoveEntity(self.v)
			end
			
		end
		
		if self.metwithenemy and not UVResourcePointsRefreshing and UVResourcePoints > 1 and not UVOneCommanderActive then
			UVResourcePoints = (UVResourcePoints - 1)
		end	
		
	end
	
	--Find an enemy around.
	function ENT:TargetEnemy()
		if UVEnemyBusted or UVEnemyEscaped then return end
		local t = ents.FindInSphere(self.v:WorldSpaceCenter(), 2500)
		local distance, nearest = math.huge, nil --The nearest enemy is the target.
		for k, v in pairs(t) do
			if self:Validate(v) and ((SpeedLimit:GetFloat() > 0 and v:GetVelocity():LengthSqr() > (self.Speeding+30976)) or self.v.rammed or v.UVWanted or v.uvraceparticipant) and self:StraightToTarget(v) then --Target conditions
				local d = v:WorldSpaceCenter():DistToSqr(self.v:WorldSpaceCenter())
				if distance > d then
					distance = d
					nearest = v
				end
			end
		end
		
		return nearest
	end
	
	function ENT:TargetEnemyAdvanced()
		local t = ents.FindInSphere(self.v:WorldSpaceCenter(), math.huge)
		local distance, nearest = math.huge, nil --The nearest enemy is the target.
		for k, v in pairs(t) do
			if self:Validate(v) then --Target conditions
				local d = v:WorldSpaceCenter():DistToSqr(self.v:WorldSpaceCenter())
				if distance > d then
					distance = d
					nearest = v
				end
			end
		end
		
		return nearest
	end
	
	function ENT:ForgetEnemy()
		UVEnemyEscaping = nil
		if IsValid(self.e) then
			if table.HasValue(UVWantedTableVehicle, self.e) and not UVEnemyEscaped then
				table.RemoveByValue(UVWantedTableVehicle, self.e)
			end
			net.Start( "UV_RemoveWantedVehicle" )
			net.WriteEntity( self.e )
			net.Broadcast()
			self.e = nil
		end
		if self.edriver then
			if table.HasValue(UVWantedTableDriver, self.edriver) and not UVEnemyEscaped then
				table.RemoveByValue(UVWantedTableDriver, self.edriver)
			end
			self.edriver = nil
		end
	end
	
	--Validate the given enemy.
	function ENT:Validate(v)
		local valid = 
		IsValid(v) and --Has existence
		IsValid(v:GetPhysicsObject()) and --Has physics
		v:GetClass() ~= "npc_uvpatrol" and v:GetClass() ~= "npc_uvsupport" and v:GetClass() ~= "npc_uvpursuit" and v:GetClass() ~= "npc_uvinterceptor" and v:GetClass() ~= "npc_uvcommander" and v:GetClass() ~= "npc_uvspecial" and --Friendly
		(v:IsVehicle() and not GetConVar("ai_ignoreplayers"):GetBool()) 
		if not valid then return false end
		
		return UVPassConVarFilter(v)
	end
	
	function ENT:IsWrecked()
		if not self.v then return end
		if self.v:IsFlagSet(FL_DISSOLVING) then return true end
		if self.v.IsScar then
			return self.v:IsDestroyed()
		elseif self.v.IsSimfphyscar then
			return self.v:GetCurHealth() <= 0 or self.v:OnFire() or self.v.destroyed
		elseif self.v.IsGlideVehicle then
			return self.v:GetEngineHealth() <= 0 or self.v:GetIsEngineOnFire()
		elseif isfunction(self.v.VC_GetHealth) then
			local health = self.v:VC_GetHealth(false)
			return isnumber(health) and health <= 0
		end
	end
	
	function ENT:Wreck()
		if IsValid(self.v) and not self.v.wrecked then
			self.wrecked = true
			self.v.wrecked = true
			local despawntime = 60
			if #UVWantedTableVehicle > 1 then
				despawntime = 10
			end
			table.insert(UVWreckedVehicles, self.v)
			self.v:CallOnRemove("UVWreckedVehicleRemoved", function()
				if table.HasValue(UVWreckedVehicles, self.v) then
					table.RemoveByValue(UVWreckedVehicles, self.v)
				end
			end)
			UVDeactivateESF(self.v)
			UVDeactivateKillSwitch(self.v)
			if not timer.Exists("uvcombotime") then
				timer.Create("uvcombotime", 5, 1, function() 
					UVComboBounty = 1 
					timer.Remove("uvcombotime")
				end)
			else --Multiple units down
				timer.Remove("uvcombotime")
				timer.Create("uvcombotime", 5, 1, function() 
					if next(ents.FindByClass("npc_uv*")) ~= nil and Chatter:GetBool() and UVComboBounty >= 3 then
						local units = ents.FindByClass("npc_uv*")
						local random_entry = math.random(#units)	
						local unit = units[random_entry]
						UVChatterMultipleUnitsDown(unit)
					end
					UVComboBounty = 1
					timer.Remove("uvcombotime")
				end)
			end
			local v = UVGetVehicleMakeAndModel(self.v)
			local bountyplus = (UVUBountyPursuit:GetInt())*(UVComboBounty)
			local bounty = string.Comma(bountyplus)
			if IsValid(self.e) and isfunction(self.e.GetDriver) and IsValid(UVGetDriver(self.e)) then 
				UVNotifyCenter({UVGetDriver(self.e)}, "uv.hud.combo", "UNITS_DISABLED", "uv.unit.pursuit", v, bountyplus, UVComboBounty, UVGetDriver(self.e):IsPlayer())
			end
			UVWrecks = UVWrecks + 1
			if self.v.IsGlideVehicle then
				local wreck = self.v
				timer.Simple(despawntime, function()
					if IsValid(wreck) then
						SafeRemoveEntity(wreck)
					end
				end)
				wreck:SetEngineHealth(0)
				wreck:UpdateHealthOutputs()
				wreck.UnflipForce = 0
				wreck.AngularDrag = vector_origin
				if wreck.CanSwitchHeadlights then
					wreck:SetHeadlightState(0)
				end
				if wreck:GetVelocity():LengthSqr() > 250000 then
					UVGlideDetachWheels(wreck)
				end
			elseif self.v.IsSimfphyscar then
				local wreck = self.v
				timer.Simple(despawntime, function()
					if IsValid(wreck) then
						SafeRemoveEntity(wreck)
					end
				end)
				if wreck:GetVelocity():LengthSqr() > 250000 then
					for i = 1, #wreck.Wheels do
						local wheelmathchance = math.random(1,2)
						local Wheel = wreck.Wheels[math.random(1, #wreck.Wheels)]
						if wheelmathchance == 1 then
							constraint.RemoveAll(Wheel)
						end
					end
				end
				wreck:SetCurHealth(0)
				wreck:SetLightsEnabled(false)
			elseif self.v:GetClass() == "prop_vehicle_jeep" then
				local wreck = self.v
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
			if self.v:IsVehicle() then
				UVBounty = (UVBounty+bountyplus)
			end
			if Chatter:GetBool() and IsValid(self.v) then
				UVChatterWreck(self)
			end
			SafeRemoveEntity(self)
			UVComboBounty = UVComboBounty + 1
		end
	end
	
	function ENT:Stop()
		self.moving = CurTime()
		self.tableroutetoenemy = {}
		self.PatrolWaypoint = nil
		self:SetELS(false)
		self:SetELSSound(false)
		self:SetHorn(false)
		if self.v.IsScar then
			self.v:GoNeutral()
			self.v:NotTurning()
			self.v:HandBrakeOn()
		elseif self.v.IsSimfphyscar then
			self.v:SetActive(true)
			self.v:StartEngine()
			self.v.PressedKeys = self.v.PressedKeys or {}
			self.v.PressedKeys["W"] = false
			self.v.PressedKeys["A"] = false
			self.v.PressedKeys["S"] = false
			self.v.PressedKeys["D"] = false
			self.v.PressedKeys["Shift"] = false
			self.v.PressedKeys["Space"] = true
			self.v.PressedKeys["joystick_throttle"] = 0
			self.v.PressedKeys["joystick_brake"] = 0
		elseif isfunction(self.v.SetThrottle) and isfunction(self.v.SetSteering) and isfunction(self.v.SetHandbrake) and not self.v.IsGlideVehicle then
			self.v:SetThrottle(0)
			self.v:SetSteering(0, 0)
			self.v:SetHandbrake(true)
		elseif self.v.IsGlideVehicle then
			self.v:TriggerInput("Handbrake", 1)
			self.v:TriggerInput("Throttle", 0)
			self.v:TriggerInput("Brake", 0)
			self.v:TriggerInput("Steer", 0)
		end
	end
	
	function ENT:StraightToTarget(target)
		if not self.v or not target then
			return
		end
		local tr = util.TraceLine({start = self.v:WorldSpaceCenter(), endpos = target:WorldSpaceCenter(), mask = MASK_NPCWORLDSTATIC, filter = {self, self.v, target, uvenemylocation}}).Fraction==1
		return tobool(tr)
	end
	
	function ENT:VisualOnTarget(target)
		if not self.v or not target then
			return
		end
		local tr = util.TraceLine({start = self.v:WorldSpaceCenter(), endpos = target:WorldSpaceCenter(), mask = MASK_OPAQUE, filter = {self, self.v, target, uvenemylocation}}).Fraction==1
		return tobool(tr)
	end
	
	function ENT:ObstaclesNearby()
		if not self.v then
			return
		end
		local tr = util.TraceLine({start = self.v:WorldSpaceCenter(), endpos = (self.v:WorldSpaceCenter()+(self.v:GetVelocity()*2)), mask = MASK_NPCWORLDSTATIC}).Fraction ~= 1
		return tobool(tr)
	end
	
	function ENT:ObstaclesNearbySide()
		if not self.v or not self.v.width then
			return
		end
		
		local width = self.v.width/2
		local turnleft = -1
		local turnright = 1
		
		local speed = self.v:GetVelocity():LengthSqr()
		speed = math.sqrt(speed)
		
		local left = Vector(-width,math.Clamp(speed, width, math.huge),0)
		local right = Vector(width,math.Clamp(speed, width, math.huge),0)
		local leftstart = Vector(-width,0,0)
		local rightstart = Vector(width,0,0)
		
		if self.v.IsSimfphyscar then
			left:Rotate(Angle(0, (self.v.VehicleData.LocalAngForward.y-90), 0))
			right:Rotate(Angle(0, (self.v.VehicleData.LocalAngForward.y-90), 0))
			leftstart:Rotate(Angle(0, (self.v.VehicleData.LocalAngForward.y-90), 0))
			rightstart:Rotate(Angle(0, (self.v.VehicleData.LocalAngForward.y-90), 0))
		elseif self.v.IsGlideVehicle then
			left:Rotate(Angle(0, -90, 0))
			right:Rotate(Angle(0, -90, 0))
			leftstart:Rotate(Angle(0, -90, 0))
			rightstart:Rotate(Angle(0, -90, 0))
		end
		
		local trleft = util.TraceLine({start = self.v:LocalToWorld(leftstart), endpos = (self.v:LocalToWorld(left)+Vector(0,0,50)), mask = MASK_NPCWORLDSTATIC}).Fraction
		local trright = util.TraceLine({start = self.v:LocalToWorld(rightstart), endpos = (self.v:LocalToWorld(right)+Vector(0,0,50)), mask = MASK_NPCWORLDSTATIC}).Fraction
		
		if trleft > trright then
			return turnleft
		end
		if trleft < trright then
			return turnright
		end
		
		return false
		
	end
	
	function ENT:PathFindToEnemy(vectors)
		
		if not vectors or not isvector(vectors) or self.NavigateBlind or not GetConVar("unitvehicle_pathfinding"):GetBool() or self.NavigateCooldown or self.v.roadblocking then
			return
		end
		
		self.NavigateCooldown = true
		timer.Simple(1, function()
			self.NavigateCooldown = nil 
		end)
		
		if DVWaypointsPriority:GetBool() then
			if UVNavigateDVWaypoint(self, vectors) then
				return
			elseif UVNavigateNavmesh(self, vectors) then
				return
			end
		else
			if UVNavigateNavmesh(self, vectors) then
				return
			elseif UVNavigateDVWaypoint(self, vectors) then
				return
			end
		end
		
		if next(self.tableroutetoenemy) == nil and not self.NavigateBlind then
			self.NavigateBlind = true
			if self.returningtopatrol then
				self.returningtopatrol = nil
			end
		end
		
	end
	
	function ENT:DriveOnPath()
		
		if next(self.tableroutetoenemy) == nil then 
			return self.v:WorldSpaceCenter()
		end
		
		local closestwaypoint
		local closestdistancetowaypoint
		local closestwaypointid
		local waypoints = self.tableroutetoenemy
		local r = math.huge
		local closestdistancetowaypoint, closestwaypoint = r^2
		
		for i, w in pairs(waypoints) do
			local unitpos = self.v:WorldSpaceCenter()
			local distance = unitpos:DistToSqr(w)
			if distance < closestdistancetowaypoint then
				closestdistancetowaypoint, closestwaypoint = distance, w
				closestwaypointid = i
			end
		end
		
		if closestwaypointid == 1 then
			if closestdistancetowaypoint < 250000 and UVStraightToWaypoint(self.v:WorldSpaceCenter(), closestwaypoint) then
				self.tableroutetoenemy = {}
			end
			return closestwaypoint
		else
			local closestwaypointinsight
			for i = 1, closestwaypointid do
				local waypoint = self.tableroutetoenemy[i]
				if UVStraightToWaypoint(self.v:WorldSpaceCenter(), waypoint) then
					closestwaypointinsight = waypoint
					break
				end
			end
			return closestwaypointinsight or closestwaypoint
		end
		
	end
	
	function ENT:FindPatrol()
		
		if next(dvd.Waypoints) == nil then
			return
		end
		
		local Waypoint = dvd.GetNearestWaypoint(self.v:WorldSpaceCenter())
		if UVTargeting and Waypoint.Neighbors then --Keep going straight whilst in pursuit
			self.PatrolWaypoint = dvd.Waypoints[Waypoint.Neighbors[math.random(#Waypoint.Neighbors)]]
		else
			self.PatrolWaypoint = Waypoint
		end
		
	end
	
	function ENT:Patrol()
		
		if next(dvd.Waypoints) == nil then
			return
		end
		
		if self.PatrolWaypoint then
			
			if not self.patrolling then
				self.patrolling = true
			end
			
			--Set handbrake
			if self.v.IsScar then
				self.v:HandBrakeOff()
			elseif self.v.IsSimfphyscar then
				self.v:SetActive(true)
				self.v:StartEngine()
				self.v.PressedKeys = self.v.PressedKeys or {}
				self.v.PressedKeys["Space"] = false
			elseif isfunction(self.v.SetHandbrake) and not self.v.IsGlideVehicle then
				self.v:SetHandbrake(false)
			elseif self.v.IsGlideVehicle then
				self.v:TriggerInput("Handbrake", 0)
			end
			
			--Determine patrol standards
			if not uvcalllocation then
				if self.respondingtocall then
					self.respondingtocall = nil
				end
				if self.returningtopatrol then
					self.returningtopatrol = true
				end
			else
				if not self.respondingtocall or not self.returningtopatrol then --Respond to call when not busy
					self.respondingtocall = true
				end
			end
			
			if not self.respondingtocall and not self.returningtopatrol then
				self.tableroutetoenemy = {}
				self.waypointPos = self.PatrolWaypoint["Target"]+Vector(0,0,50)
				self:SetELS(false)
				self:SetELSSound(false)
				self:SetHorn(false)
			elseif not self.returningtopatrol then
				if self.tableroutetoenemy and next(self.tableroutetoenemy) ~= nil then
					local Waypoint = self.tableroutetoenemy[#self.tableroutetoenemy]
					local Neighbor = self.tableroutetoenemy[(#self.tableroutetoenemy-1)]
					self.waypointPos = self:DriveOnPath()
				else
					self:PathFindToEnemy(uvcalllocation)
					self:SetELS(true)
					self:SetELSSound(true)
					self:SetELSSiren(true)
					return
				end
			else
				if self.tableroutetoenemy and next(self.tableroutetoenemy) ~= nil then
					local Waypoint = self.tableroutetoenemy[#self.tableroutetoenemy]
					local Neighbor = self.tableroutetoenemy[(#self.tableroutetoenemy-1)]
					self.waypointPos = self:DriveOnPath()
				else
					self:PathFindToEnemy(self.PatrolWaypoint["Target"])
					self:SetELS(false)
					self:SetELSSound(false)
					self:SetHorn(false)
					return
				end
			end
			
			--Patrolling techniques
			local forward = self.v.IsSimfphyscar and self.v:LocalToWorldAngles(self.v.VehicleData.LocalAngForward):Forward() or self.v:GetForward()
			local dist = self.waypointPos - self.v:WorldSpaceCenter()
			local vect = dist:GetNormalized()
			local vectdot = vect:Dot(self.v:GetVelocity())
			local throttle = dist:Dot(forward) > 0 and 1 or -1
			local right = vect:Cross(forward)
			local steer_amount = right:Length()
			local steer = right.z > 0 and steer_amount or -steer_amount
			local speedlimitmph = self.PatrolWaypoint["SpeedLimit"]
			self.Speeding = speedlimitmph^2
			
			--Unique patrolling techniques
			if self.stuck then
				if right.z > 0 then 
					steer = -1 
				else 
					steer = 1 
				end
				throttle = throttle * -1
			end --Getting unstuck
			if not self.respondingtocall and (self.v:GetVelocity():LengthSqr() > self.Speeding or self.v:GetVelocity():LengthSqr() > 1115136) then
				throttle = 0
			end
			if self.v:GetVelocity():LengthSqr() > 10000 and not self.stuck then
				if self.v.IsSimfphyscar then
					if istable(self.v.Wheels) then
						for i = 1, table.Count( self.v.Wheels ) do
							local Wheel = self.v.Wheels[ i ]
							if not Wheel then return end
							if Wheel:GetGripLoss() > 0 then
								throttle = throttle * Wheel:GetGripLoss() --Simfphys traction control
							end
						end
					end
				elseif self.v.IsGlideVehicle then
					local EntityMeta = FindMetaTable( "Entity" )
					local getTable = EntityMeta.GetTable
					local selfvTbl = getTable( self.v )
					local wheelslip = selfvTbl.avgForwardSlip > 0 and selfvTbl.avgForwardSlip or selfvTbl.avgForwardSlip < 0 and selfvTbl.avgForwardSlip * -1
					if wheelslip ~= false then
						throttle = throttle - (wheelslip/10) --Glide traction control
					end
				else
					local maththrottle = throttle - math.abs(steer)
					if maththrottle >= 0 then
						throttle = maththrottle
					end --Cornering
				end
			end
			if dist:Dot(forward) < 0 and not self.stuck then
				if vectdot > 0 then
					if right.z > 0 then 
						steer = -1 
					else 
						steer = 1 
					end
				else
					if right.z < 0 then 
						steer = -1 
					else 
						steer = 1 
					end
				end
			end --K turn
			if self:ObstaclesNearby() or vectdot > 0 and dist:LengthSqr() < (self.v:GetVelocity():LengthSqr()*2) and self.v:GetVelocity():LengthSqr() > 774400 then
				if self.v:GetClass() == "prop_vehicle_jeep" then
					throttle = 0
				else
					throttle = -1
				end
			end --Slow down
			local turn = self:ObstaclesNearbySide()
			if turn then
				if turn == -1 then
					if vectdot > 0 then
						steer = -1
					else
						steer = 1
					end
				end
				if turn == 1 then
					if vectdot > 0 then
						steer = 1
					else
						steer = -1
					end
				end
			end
			
			--When there
			if dist:LengthSqr() < 250000 and UVStraightToWaypoint(self.v:WorldSpaceCenter(), self.waypointPos) then
				if not self.respondingtocall and not self.returningtopatrol then
					if self.PatrolWaypoint.Neighbors then
						local WaypointTable = {}
						for k, v in pairs(self.PatrolWaypoint.Neighbors) do
							if not self.PreviousPatrolWaypoint or self.PreviousPatrolWaypoint["Target"] ~= dvd.Waypoints[v]["Target"] then
								table.insert(WaypointTable, v)
							end
						end --Don't turn around
						self.PreviousPatrolWaypoint = self.PatrolWaypoint
						self.PatrolWaypoint = dvd.Waypoints[WaypointTable[math.random(#WaypointTable)]]
					else
						self.PatrolWaypoint = nil
					end
				elseif not self.returningtopatrol then
					if self.tableroutetoenemy then
						if next(self.tableroutetoenemy) == nil then
							self.PatrolWaypoint = nil
							self.respondingtocall = false
							self.returningtopatrol = true
							uvcalllocation = nil --Remove the call, allow for new calls to come in
							UVChatterCallResponded(self)
						end
					end --When there
				else
					if self.tableroutetoenemy then
						if next(self.tableroutetoenemy) == nil then
							self.returningtopatrol = false
						end
					end --When there
				end
			end
			
			--Set throttle
			if self.v.IsScar then
				if throttle > 0 then
					self.v:GoForward(throttle)
				else
					self.v:GoBack(-throttle)
				end
			elseif self.v.IsSimfphyscar then
				self.v:SetActive(true)
				self.v:StartEngine()
				self.v.PressedKeys = self.v.PressedKeys or {}
				self.v.PressedKeys["Shift"] = false
				self.v.PressedKeys["joystick_throttle"] = throttle
				self.v.PressedKeys["joystick_brake"] = throttle * -1
			elseif self.v.IsGlideVehicle then
				self.v:TriggerInput("Throttle", throttle)
				self.v:TriggerInput("Brake", throttle * -1)
			elseif isfunction(self.v.SetThrottle) and not self.v.IsGlideVehicle then
				self.v:SetThrottle(throttle)
			end
			if self.v.IsScar then
				if steer > 0 then
					self.v:TurnRight(steer)
				elseif steer < 0 then
					self.v:TurnLeft(-steer)
				else
					self.v:NotTurning()
				end
			elseif self.v.IsSimfphyscar then
				self.v:SetActive(true)
				self.v:StartEngine()
				self.v:PlayerSteerVehicle(self, steer < 0 and -steer or 0, steer > 0 and steer or 0)
			elseif self.v.IsGlideVehicle then
				steer = steer * 2 --Attempt to make steering more sensitive.
				self.v:TriggerInput("Steer", steer)
			elseif isfunction(self.v.SetSteering) and not self.v.IsGlideVehicle then
				self.v:SetSteering(steer, 0)
			end
			
			--Resetting
			if not (self.v:GetVelocity():LengthSqr() < 10000 and (throttle > 0 or throttle < 0)) then 
				self.moving = CurTime()
			end
			if self.stuck then 
				self.moving = CurTime()
				if self.v:GetVelocity():LengthSqr() > 100000 and vectdot > 0 and not UVEnemyEscaping then
					self.stuck = nil
				end
			end
			
			local timeout = 1
			if timeout and timeout > 0 then
				if CurTime() > self.moving + timeout and not UVTargeting then --If it has got stuck for enough time.
					self.invincible = true
					self.stuck = true
					self.moving = CurTime()
					timer.Simple(1, function() if IsValid(self.v) then self.invincible = nil end end)
					timer.Simple(1, function() if IsValid(self.v) then self.stuck = nil self.PatrolWaypoint = nil end end)
					if not self.respondingtocall then
						self.returningtopatrol = true
					end
				end
			end
			
		else
			if self.patrolling then
				self.patrolling = nil
				self.Speeding = (SpeedLimit:GetFloat()*17.6)^2
			end
			self:Stop()
			self:FindPatrol()
		end
		
	end
	
	function ENT:UVHandbrakeOff()
		if self.v.IsScar then
			self.v:HandBrakeOff()
		elseif self.v.IsSimfphyscar then
			self.v:SetActive(true)
			self.v:StartEngine()
			self.v.PressedKeys = self.v.PressedKeys or {}
			self.v.PressedKeys["Space"] = false
		elseif isfunction(self.v.SetHandbrake) and not self.v.IsGlideVehicle then
			self.v:SetHandbrake(false)
		end
	end
	
	function ENT:UVHandbrakeOn()
		if self.v.IsScar then
			self.v:HandBrakeOn()
		elseif self.v.IsSimfphyscar then
			self.v.PressedKeys = self.v.PressedKeys or {}
			self.v.PressedKeys["Space"] = true
		elseif isfunction(self.v.SetHandbrake) and not self.v.IsGlideVehicle then
			self.v:SetHandbrake(true)
		elseif self.v.IsGlideVehicle then
			self.v:TriggerInput("Handbrake", 1)
		end
	end
	
	function ENT:Think()
		-- if UVTargeting then return end
		self:SetPos(self.v:GetPos() + Vector(0,0,50))
		self:SetAngles(self.v:GetPhysicsObject():GetAngles()+Angle(0,180,0))
		if not IsValid(uvenemylocation) then
			uvenemylocation = ents.Create("prop_physics") --Enemy location
			uvenemylocation:SetModel("models/props_lab/huladoll.mdl")
			uvenemylocation:SetPos(self.v:GetPos() + Vector(0,0,50))
			uvenemylocation:Spawn()
			uvenemylocation:SetCollisionGroup(10)
			uvenemylocation:SetNoDraw(true)
			uvenemylocation:SetMoveType(MOVETYPE_NONE)
		end
		
		if not self.spawned and not self.damaged then
			if self.v.IsGlideVehicle then
				if self.v:GetEngineHealth() <= 0.5 then
					self.damaged = true
					if Chatter:GetBool() and self.v.rammed then
						UVChatterDamaged(self)
					end
				end
			elseif self.v.IsSimfphyscar then
				if self.v:GetCurHealth() <= self.v:GetMaxHealth()/2 then
					self.damaged = true
					if Chatter:GetBool() and self.v.rammed then
						UVChatterDamaged(self)
					end
				end
			elseif not vcmod_main then
				if self.v:Health() <= self.v:GetMaxHealth()/4 then 
					self.damaged = true
					if Chatter:GetBool() and self.v.rammed then
						UVChatterDamaged(self)
					end
				end
			else
				if self.v:GetClass() == "prop_vehicle_jeep" and self.v:VC_GetHealth(true) < 25 then
					self.damaged = true
					if Chatter:GetBool() and self.v.rammed then
						UVChatterDamaged(self)
					end
				end
			end
		end
		
		--Flipping/crash
		if self.v and not self.wrecked and not self.spawned and
		(self.v:Health() < 0 and self.v:GetClass() == "prop_vehicle_jeep" or --No health 
		self.v:GetPhysicsObject():GetAngles().z > 90 and self.v:GetPhysicsObject():GetAngles().z < 270 and (self.v.rammed or self.v:GetVelocity():LengthSqr() < 10000 and self.stuck) or --Flipped
		self.v:WaterLevel() > 2 or --Underwater
		self:IsOnFire()) or --On fire
		self:IsWrecked() then --Other parameters
			self:Wreck()
		end
		
		if not IsValid(self.v) or --The tied vehicle goes NULL.
		not self.v:IsVehicle() or --Somehow it become non-vehicle entity.
		IsValid(self.v:GetDriver()) then --It has an driver.
			self:Wreck()
			return
		end
		
		if not UVTargeting then
			self.bountytimer = CurTime() --Bounty parameters
		end
		
		--Target nearest enemy/remove when marked for deletion
		if IsValid(self.e) then
			local closestsuspect
			local closestdistancetosuspect
			local suspects = UVWantedTableVehicle
			local r = math.huge
			local closestdistancetosuspect, closestsuspect = r^2
			for i, w in pairs(suspects) do
				local unitpos = self.v:WorldSpaceCenter()
				local distance = unitpos:DistToSqr(w:WorldSpaceCenter())
				if distance < closestdistancetosuspect then
					closestdistancetosuspect, closestsuspect = distance, w
				end
			end
			if closestsuspect ~= self.e and self:StraightToTarget(closestsuspect) then
				self.e = closestsuspect
				UVAddToWantedListVehicle(self.e)
				if not closestsuspect.UVWanted then
					closestsuspect.UVWanted = closestsuspect
				end
				if isfunction(self.e.GetDriver) and IsValid(UVGetDriver(self.e)) and UVGetDriver(self.e):IsPlayer() then 
					self.edriver = UVGetDriver(self.e)
					UVAddToWantedListDriver(self.edriver)
				else
					self.edriver = nil
				end
				if not self.spawncooldown then
					self.v:SetNoDraw(false)
					self.v:SetCollisionGroup(0)
				end
				UVCalm = nil
				local chatterchance = math.random(1,10)
				if chatterchance == 1 and Chatter:GetBool() and IsValid(self.v) then
					UVChatterFoundMultipleEnemies(self) 
				end
			end
			if UVTargeting and closestdistancetosuspect > 100000000 and not self:StraightToTarget(closestsuspect) and 
			not UVEnemyBusted and not UVEnemyEscaped and self.uvmarkedfordeletion and (not UVRacerPresenceMode or self.stuck) then
				SafeRemoveEntity(self)
				if Chatter:GetBool() and IsValid(self.v) and not UVEnemyEscaping and not self.invincible and not UVEnemyBusted then
					UVChatterLeftPursuit(self) 
				end
			end
		end
		
		if not self:Validate(self.e) then --If it doesn't have an enemy.
			--Stop moving (or patrol).
			if UVEnemyBusted and #UVWantedTableVehicle == 0 or GetConVar("ai_ignoreplayers"):GetBool() then --Stop moving
				self:Stop()
			else --Patrol
				self:Patrol()
				if self.v.roadblocking and not self.spawned then
					self.v.roadblocking = nil
				end
			end
			
			if UVEnemyBusted then
				self.moving = CurTime()
			end
			self.rdeploying = CurTime()
			--self.bountytimer = CurTime()
			
			if UVTargeting and not IsValid(self.e) then 
				local enemy = self:TargetEnemyAdvanced() --Find an ongoing pursuit.
				if IsValid(enemy) then
					self.idle = nil
					self.e = enemy
					UVAddToWantedListVehicle(self.e)
					if not enemy.UVWanted then
						enemy.UVWanted = enemy
					end
					if not UVEnemyEscaping then uverespawn = self.e:GetPos() end
					if isfunction(self.e.GetDriver) and IsValid(UVGetDriver(self.e)) and UVGetDriver(self.e):IsPlayer() then 
						self.edriver = UVGetDriver(self.e)
						UVAddToWantedListDriver(self.edriver)
					else
						self.edriver = nil
					end
					self.moving = CurTime()
					self.kscooldown = true
					timer.Simple((math.random(30,120)), function() self.kscooldown = nil end)
					self.toofar = nil
					if Chatter:GetBool() and IsValid(self) then
						UVChatterResponding(self)
					end
				end
			end
			
			if not UVTargeting and not IsValid(self.e) then
				local enemy = self:TargetEnemy() --Find an enemy.			
				if IsValid(enemy) then
					self.e = enemy
					UVAddToWantedListVehicle(self.e)
					if not enemy.UVWanted then
						enemy.UVWanted = enemy
					end
					if not UVEnemyEscaping then uverespawn = self.e:GetPos() end
					if isfunction(self.e.GetDriver) and IsValid(UVGetDriver(self.e)) and UVGetDriver(self.e):IsPlayer() then 
						self.edriver = UVGetDriver(self.e)
						UVAddToWantedListDriver(self.edriver)
					else
						self.edriver = nil
					end
					self.moving = CurTime()
					UVLosing = CurTime()
					self.idle = nil
					self.kscooldown = true
					timer.Simple((math.random(30,120)), function() self.kscooldown = nil end)
					timer.Simple(15, function() 
						if UVCalm and IsValid(self.e) and not UVHUDBusting then
							UVRestoreResourcePoints()
							UVTargeting = true
							if IsValid(self) then
								UVChatterPursuitStartRanAway(self)
							end
							UVLosing = CurTime()
							if Photon and isfunction(self.v.ELS_ManualSiren) then
								self.v:ELS_ManualSiren(false)
							end
							self:SetELSSiren(true)
						end
					end)
					self.toofar = nil
					self.aggressive = nil
					if (UVBounty >= GetConVar( 'unitvehicle_unit_heatminimumbounty1' ):GetInt() or self.e.uvraceparticipant) and not UVTargeting and not UVEnemyBusted then
						timer.Simple(0.1, function()
							UVTargeting = true
							if Chatter:GetBool() and IsValid(self) then
								UVChatterPursuitStartWanted(self)
							end
						end)
						return
					end
					if isfunction(self.e.GetDriver) and IsValid(UVGetDriver(self.e)) and UVGetDriver(self.e):IsPlayer() then 
						UVGetDriver(self.e):PrintMessage( HUD_PRINTCENTER, "PULL OVER TO PAY A FINE!")
					end
					if not UVCalm then
						UVCalm = true
					end
					if not self.v.rammed then
						if Chatter:GetBool() and IsValid(self.v) then
							UVChatterTrafficStopSpeeding(self)
						end
					else
						if Chatter:GetBool() and IsValid(self.v) then
							UVChatterTrafficStopRammed(self) 
						end
					end
				end
			end 
			
			self.idle = true
			
			if self.chasing and IsValid(self.e) then
				self.chasing = nil
			end
			
			if not self.toofar then
				self.toofar = true
			end
			
			if table.HasValue(UVUnitsChasing, self) then
				table.RemoveByValue(UVUnitsChasing, self)
			end
			
		else --It does.
			
			uvenemylocation:SetPos(self.e:GetPos() + Vector(0,0,50))
			uvenemylocation:SetAngles(self.e:GetPhysicsObject():GetAngles()+Angle(0,180,0))
			
			self.chasing = true
			
			if self.idle then
				self.idle = nil
				if not UVEnemyEscaping then 
					uverespawn = self.e:GetPos() 
				end
			end
			
			--Drive the vehicle.
			--Set handbrake off.		
			
			if self.v.IsScar then
				self.v:HandBrakeOff()
			elseif self.v.IsSimfphyscar then
				self.v:SetActive(true)
				self.v:StartEngine()
				self.v.PressedKeys = self.v.PressedKeys or {}
				self.v.PressedKeys["Space"] = false
			elseif isfunction(self.v.SetHandbrake) and not self.v.IsGlideVehicle then
				self.v:SetHandbrake(false)
			elseif self.v.IsGlideVehicle then
				self.v:TriggerInput("Handbrake", 0)
			end
			
			--Figures
			local edist --Fixed/Varied distance between the vehicle and the enemy.
			if not self.formationpoint then
				edist = self.e:WorldSpaceCenter() - self.v:WorldSpaceCenter()
			else
				edist = self.e:LocalToWorld(self.formationpoint) - self.v:WorldSpaceCenter()
			end
			
			local eedist = self.e:WorldSpaceCenter() - self.v:WorldSpaceCenter() --Fixed distance between the vehicle and the enemy.
			
			--Determine pursuit standards
			if not UVEnemyEscaping and self:StraightToTarget(self.e) then
				self.tableroutetoenemy = {}
				if self.NavigateBlind then 
					self.NavigateBlind = nil 
				end
				if (not self.formationpoint or self.e:GetVelocity():LengthSqr() <= UVBustSpeed or eedist:LengthSqr() >= 6250000) 
				or not self:StraightToTarget(self.e) or UVCalm or UVEnemyEscaping or 
				self:ObstaclesNearbySide() then
					if not self.driveinfront or self:ObstaclesNearbySide() then
						self.targetpos = self.e:WorldSpaceCenter() --Drive towards the enemy
					else
						self.targetpos = (self.e:WorldSpaceCenter()+self.e:GetVelocity()) --Drive infront of the enemy
					end
				else
					self.targetpos = (self.e:LocalToWorld(self.formationpoint)+self.e:GetVelocity()) --Drive in formation
				end
			else
				if self.tableroutetoenemy and next(self.tableroutetoenemy) ~= nil then
					local Waypoint = self.tableroutetoenemy[#self.tableroutetoenemy]
					local Neighbor = self.tableroutetoenemy[(#self.tableroutetoenemy-1)]
					self.targetpos = self:DriveOnPath()
				else
					self:PathFindToEnemy(self.e:WorldSpaceCenter()) --Find the enemy
					self.targetpos = self.e:WorldSpaceCenter()
				end
			end
			
			--Driving techniques
			local forward = self.v.IsSimfphyscar and self.v:LocalToWorldAngles(self.v.VehicleData.LocalAngForward):Forward() or self.v:GetForward() --Forward vector.
			local dist = self.targetpos - self.v:WorldSpaceCenter() --Varied distance between the vehicle and the enemy.
			local vect = dist:GetNormalized() --Enemy direction vector.
			local vectdot = vect:Dot(self.v:GetVelocity()) --Dot product, velocity and direction.
			local throttle = dist:Dot(forward) > 0 and 1 or -1 --Throttle depends on their positional relationship.
			local right = vect:Cross(forward) --The enemy is right side or not.
			local steer_amount = right:Length() --Steering parameter/sensitivity.
			local steer = right.z > 0 and steer_amount or -steer_amount --Actual steering parameter.
			local evect = edist:GetNormalized() --Fixed enemy direction vector.
			local eevectdot = evect:Dot(self.v:GetVelocity()) --Fixed dot product, velocity and direction.
			local eeright = evect:Cross(forward) --Fixed value for when enemy is right side or not.
			local evectdot = vect:Dot(self.e:GetVelocity()) --Enemy's dot product, velocity and direction.
			local eeevectdot = evect:Dot(self.e:GetVelocity()) --Fixed enemy's dot product, velocity and direction.
			local eforward = self.e.IsSimfphyscar and --Forward vector.
			self.e:LocalToWorldAngles(self.e.VehicleData.LocalAngForward):Forward() or self.e:GetForward() --Enemy foward vector
			local eright = vect:Cross(eforward) --The pursuer is right side or not
			local eevect = eedist:GetNormalized() --Fixed enemy direction vector.
			local eeeright = eevect:Cross(forward) --Fixed value for when enemy is right side or not.
			local ph = self.v:GetPhysicsObject() --Get pursuer's physics
			if not (ph and IsValid(ph)) then return end
			local eph = self.e:GetPhysicsObject() --Get enemy's physics
			if not (eph and IsValid(eph)) then return end
			
			--Unique driving techniques
			if (UVEnemyEscaping or not self:StraightToTarget(self.e)) and not self.stuck then
				if dist:Dot(forward) < 0 and not self.stuck then
					if vectdot > 0 then
						if right.z > 0 then 
							steer = -1 
						else 
							steer = 1 
						end
					else
						if right.z < 0 then 
							steer = -1 
						else 
							steer = 1 
						end
					end
				end --K turn
				if not self.invincible then
					self.invincible = true
				end
				local turn = self:ObstaclesNearbySide()
				if turn then
					if turn == -1 then
						if vectdot > 0 then
							steer = -1
						else
							steer = 1
						end
					end
					if turn == 1 then
						if vectdot > 0 then
							steer = 1
						else
							steer = -1
						end
					end
				end
				if self.v.IsSimfphyscar then
					if self:ObstaclesNearby() then
						if self.v:GetGear() >= 3 then
							throttle = -1
						else
							throttle = 1
						end
					end
				elseif self.v.IsGlideVehicle then
					if self:ObstaclesNearby() then
						if self.v:GetGear() >= 1 then
							throttle = -1
						else
							throttle = 1
						end
					end
				end --Slow down
			elseif (dist:LengthSqr() > 250000 or dist:LengthSqr() < 250000 and not self:StraightToTarget(self.e)) and self.stuck then --No eyes on the target
				if right.z > 0 then steer = -1 else steer = 1 end
				if UVEnemyEscaping then throttle = -1 else throttle = throttle * -1 end
			else --Getting unstuck
				if edist:Dot(forward) < 0 and (edist:Length2DSqr() > 100000 or self.formationpoint) and eevectdot < 0 then
					if eeevectdot > 0 or self.e:GetVelocity():LengthSqr() < 100000 then
						throttle = 0
						if self.v.IsSimfphyscar or self.v.IsGlideVehicle then
							self:UVHandbrakeOn()
						end
						if right.z < 0 then steer = -1 else steer = 1 end 
					else 
						if (self.e:GetVelocity():LengthSqr()/1.25) > self.v:GetVelocity():LengthSqr() then 
							throttle = 1 
						else
							if self.v.IsSimfphyscar or self.v.IsGlideVehicle then
								throttle = throttle * -1
							else
								throttle = 0
							end
						end
						if self:ObstaclesNearby() then
							throttle = -1
						end --Slow down
					end
				end --U turn/rolling roadblock
				if dist:Dot(forward) < 0 and dist:Length2DSqr() > 250000 and vectdot > 0 and not self.stuck then
					if eeevectdot > 0 or self.e:GetVelocity():LengthSqr() < 100000 then
						if right.z > 0 then steer = -1 else steer = 1 end
					else
						throttle = throttle * -1
					end
				end --K/J turn
				if eeeright.z > -0.2 and eeeright.z < 0.2 and eeevectdot < 0 and eedist:Dot(forward) < 0 and eedist:Length2DSqr() < 100000 and self.aggressive then
					self:UVHandbrakeOn() 
				end --Brake checking
				if self.v:GetVelocity():LengthSqr() > self.e:GetVelocity():LengthSqr() and edist:Dot(forward) > 0 and edist:Dot(eforward) > 0 and eevectdot > 0 and eeevectdot > 0 and edist:Length2DSqr() < 100000 and self.e:GetVelocity():LengthSqr() > 250000 and not UVCalm then
					if self.aggressive and not self.formationpoint and eright.z > -0.25 and eright.z < 0.25 then steer = 0 end
				end --PIT technique/get infront
				if self.e:GetVelocity():LengthSqr() < 100000 and dist:Length2DSqr() < self.v:GetVelocity():LengthSqr() then
					if self.v.IsSimfphyscar or self.v.IsGlideVehicle then
						throttle = throttle * -1
					else
						self:UVHandbrakeOn()
					end
				end --Slow down when enemy's stopped
				if evectdot < 0 and self.e:GetVelocity():LengthSqr() > 100000 and dist:Dot(forward) > 0 and throttle > 0 and (self:StraightToTarget(self.e) or not self.aggressive) then
					if not Relentless:GetBool() or (self.v:GetVelocity():LengthSqr()+self.e:GetVelocity():LengthSqr()) > eedist:Length2DSqr() then
						if self.v:GetVelocity():LengthSqr() > 123904 then throttle = 0 end
						if dist:Dot(eforward) < 0 then
							if eright.z < 0 then steer = 1 else steer = -1 end
						else
							if eright.z < 0 then steer = -1 else steer = 1 end
						end
					end
					if self.aggressive then self:SetHorn(true) end
				elseif not self.ramming then
					self:SetHorn(false)
				end --Head-on slam
				if dist:Dot(forward) < 0 and vectdot < 0 and evectdot < 0 and dist:Dot(eforward) < 0 and self.e:GetVelocity():LengthSqr() > 100000 then 
					steer = eright.z 
					if dist:Length2DSqr() > 100000 and eright.z < 0.5 and eright.z > -0.5 then if right.z > 0.75 then steer = -1 elseif right.z < -0.75 then steer = 1 end end
				end --Herding
				if UVCalm and edist:Length2DSqr() < 250000 then
					throttle = 0
				end --No ramming
				if self.v.IsSimfphyscar or self.v.IsGlideVehicle and not Relentless:GetBool() then
					if not self.formationpoint and eedist:LengthSqr() < 6250000 and (self.v:GetVelocity():LengthSqr()/2) > self.e:GetVelocity():LengthSqr() and self.e:GetVelocity():LengthSqr() > 100000 then
						throttle = -1
					end --Slow down when enemy slows down
				end
				
				--If the vehicle is too close to the enemy...  
				if (edist:Length2DSqr() < 100000 and eevectdot < 0 and self.e:GetVelocity():LengthSqr() > 100000 and eeevectdot < 0) and not self.formationpoint and not self:ObstaclesNearbySide() then 
					if not self.driveinfront and not self.formationpoint then
						if self.v:GetVelocity():LengthSqr() > self.e:GetVelocity():LengthSqr() then
							throttle = 0
						else
							throttle = 1
						end
					else
						if self.v:GetVelocity():LengthSqr() < self.e:GetVelocity():LengthSqr() then 
							throttle = 1 
						else
							throttle = 0
						end
					end
				end --Herding technique
				if self.e:GetVelocity():LengthSqr() < 30976 and dist:Length2DSqr() < 100000 and not (self.v:GetNoDraw(true) and self.v:GetCollisionGroup(20)) and self:StraightToTarget(self.e) then
					throttle = 0 
					if vectdot < 0 or eright.z > -0.2 and eright.z < 0.2 or UVCalm then self:UVHandbrakeOn() end
				end --Pinning/boxing in
				if self.invincible then
					self.invincible = nil
				end
			end
			
			--Roadblocking
			if self.v.roadblocking then
				self:UVHandbrakeOn()
				if eeevectdot > 0 and self.v.roadblocking and self.v.disperse and self:StraightToTarget(self.e) then
					self.v.roadblocking = nil
					if Chatter:GetBool() then
						UVChatterRoadblockMissed(self)
					end
				end
			end
			
			--Awareness to world
			--[[if self.v.IsSimfphyscar then
			if !UVStraightToWaypoint(self.v:WorldSpaceCenter(), (self.v:WorldSpaceCenter()+self.v:GetVelocity())) then
				throttle = throttle * -1
			end
		end]]
		
		--Awareness to friendly vehicles
		local t = ents.FindInSphere(self.v:WorldSpaceCenter(), 5000)
		local distance, nearest = math.huge, nil --The nearest friendly.
		for k, f in pairs(t) do
			if f ~= self and (f:GetClass() == "npc_uvpatrol" or f:GetClass() == "npc_uvsupport" or f:GetClass() == "npc_uvpursuit" or f:GetClass() == "npc_uvinterceptor" or f:GetClass() == "npc_uvcommander" or f:GetClass() == "npc_uvspecial") then --Friendly conditions
				local d = f:WorldSpaceCenter():DistToSqr(self.v:WorldSpaceCenter())
				if distance > d then
					distance = d
					nearest = f --Friendly
					local fforward = f.v.IsSimfphyscar and f.v:LocalToWorldAngles(f.v.VehicleData.LocalAngForward):Forward() or f.v:GetForward() --Forward vector.
					local fdist = f:WorldSpaceCenter() - self.v:WorldSpaceCenter() --Distance between the vehicle and the friendly.
					local fedist = self.e:WorldSpaceCenter() - f:WorldSpaceCenter() --Distance between the enemy and the friendly.
					local fvect = fdist:GetNormalized() --Friendly direction vector.
					local fvectdot = fvect:Dot(self.v:GetVelocity()) --Dot product, velocity and direction.
					local fright = fvect:Cross(forward) --The friendly is right side or not.
					if dist:LengthSqr() > fedist:LengthSqr() then
						if fvectdot > 0 then
							if UVCalm and fdist:LengthSqr() < 100000 then
								throttle = 0
							elseif fdist:LengthSqr() < 100000 and self.e:GetVelocity():LengthSqr() > 200000 and not self.formationpoint then
								if self.v:GetVelocity():LengthSqr() > f.v:GetVelocity():LengthSqr() and fdist:Dot(forward) > 0 then
									steer = steer * 0
								end
							end
						end
					end -- Follow behind
					if fvectdot > 0 and f.v:GetVelocity():LengthSqr() < 250000 and dist:LengthSqr() < 2500000 and self.v:GetVelocity():LengthSqr() > fdist:LengthSqr() and self.e:GetVelocity():LengthSqr() < 250000 and not self.formationpoint then
						if fright.z < 0.1 and fright.z > -0.9 then
							steer = 1
						end
						if fright.z > -0.1 and fright.z < 0.9 then 
							steer = -1
						end
					end -- Surronding target vehicles
				end
			end
		end
		
		if self.v.PursuitTech then
			for i, v in pairs(self.v.PursuitTech) do
				if v.Tech == 'Spikestrip' then
					if UVCalm or UVEnemyEscaping then
						self.deploying = CurTime() 
					end
					if UVEnemyEscaping then 
						self.deploying = CurTime() 
					end
					if not (eeevectdot < 0 and eedist:Length2DSqr() < 25000000 and eedist:Length2DSqr() > 100000) then
						self.deploying = CurTime()
					end
					if self.e:GetVelocity():LengthSqr() < 100000 then self.deploying = CurTime() end
					if self.v:GetNoDraw(true) and self.v:GetCollisionGroup(20) and eedist:Length2DSqr() < 25000000 then
						self.deploying = CurTime()
					end
					local stimeout = 0.5
					if stimeout and stimeout > 0 then
						if CurTime() > self.deploying + stimeout and self.aggressive and PursuitTech:GetBool() and not self.v.roadblocking then
							UVDeployWeapon(self.v, i)
							self.deploying = CurTime()
						end
					end
				elseif v.Tech == 'ESF' then
					local kstimeout = 0.5
					if self.e.IsSimfphyscar then
						if not (eedist:LengthSqr() < 6250000 and self.e:EngineActive()) then
							self.esf = CurTime()
						end
					elseif self.e:GetClass() == "prop_vehicle_jeep" then
						if not (eedist:LengthSqr() < 6250000 and self.e:IsEngineStarted(false)) then
							self.esf = CurTime()
						end
					end
					if UVCalm or self.e:GetVelocity():LengthSqr() < 100000 or UVEnemyEscaping or not self.aggressive or self.v.rhino then
						self.esf = CurTime() 
					end
					if self.esf ~= CurTime() and kstimeout > 0 and PursuitTech:GetBool() and not self.v.roadblocking then
						UVDeployWeapon(self.v, i)
						self.esf = CurTime()
					end
				elseif v.Tech == 'Killswitch' then
					local kstimeout = 0.5
					if self.e.IsSimfphyscar then
						if not (eedist:LengthSqr() < 250000 and self.e:EngineActive()) then
							self.ks = CurTime()
						end
					elseif self.e:GetClass() == "prop_vehicle_jeep" then
						if not (eedist:LengthSqr() < 250000 and self.e:IsEngineStarted(false)) then
							self.ks = CurTime()
						end
					end
					if UVCalm or self.e:GetVelocity():LengthSqr() < 123904 or UVEnemyEscaping or not self.aggressive or self.v.rhino then
						self.ks = CurTime() 
					end
					if self.ks ~= CurTime() and kstimeout > 0 and PursuitTech:GetBool() and not self.v.roadblocking then
						UVDeployWeapon(self.v, i)
						self.ks = CurTime()
					end
					if self.v.uvkillswitching then
						UVKillSwitchCheck(self.v)
					end
				elseif v.Tech == 'Repair Kit' then
					if self.v.IsGlideVehicle then
						if self.v:GetChassisHealth() <= (self.v.MaxChassisHealth / 3) then
							UVDeployWeapon(self.v, k)
						else
							for _, v in pairs(self.v.wheels) do
								if IsValid(v) and v.bursted and not self.repairtimer then
									local id = "tire_repair"..self.v:EntIndex()
									self.repairtimer = true
									
									timer.Create(id, 1, 1, function()
										UVDeployWeapon(self.v, k)
										timer.Simple(5, function() self.repairtimer = false; end)
									end)
									break
								end
							end
						end
					elseif self.v.IsSimfphyscar then
						if self.v:GetCurHealth() <= (self.v:GetMaxHealth() / 3) then
							UVDeployWeapon(self.v, k)
						else
							for _, wheel in pairs(self.v.Wheels) do
								if IsValid(wheel) and wheel:GetDamaged() and not self.repairtimer then
									local id = "tire_repair"..self.v:EntIndex()
									self.repairtimer = true
									
									timer.Create(id, 1, 1, function()
										UVDeployWeapon(self.v, k)
										timer.Simple(5, function() self.repairtimer = false; end)
									end)
									break
								end
							end
						end
					elseif vcmod_main and self.v:GetClass() == "prop_vehicle_jeep" then
						if self.v:VC_getHealth() <= (self.v:VC_getHealthMax() / 3) then
							UVDeployWeapon(self.v, k)
						end
					end
				end
			end
		end
		
		--Busting 
		local btimeout = GetConVar("unitvehicle_bustedtimer"):GetFloat()
		
		--Resetting
		if not (self.v:GetVelocity():LengthSqr() < 10000 and (throttle > 0 or throttle < 0)) then --Reset conditions.
			self.moving = CurTime()
		end
		if self.displaybusting then
			self.moving = CurTime()
		end
		if self.stuck then 
			self.moving = CurTime()
			if self.v:GetVelocity():LengthSqr() > 100000 and vectdot > 0 and not UVEnemyEscaping then
				self.stuck = nil
			end
		end
		
		local timeout = 1
		if timeout and timeout > 0 then
			if CurTime() > self.moving + timeout then --If it has got stuck for enough time.
				self.invincible = true
				self.stuck = true
				self.moving = CurTime()
				timer.Simple(2, function() if IsValid(self.v) then self.invincible = nil end end)
				timer.Simple(1, function() if IsValid(self.e) then self.stuck = nil self:PathFindToEnemy(self.e:WorldSpaceCenter()) end end)
			end
		end
		
		--First encounter with enemy
		if not self.metwithenemy and edist:LengthSqr() < 25000000 and self:StraightToTarget(self.e) then
			self.metwithenemy = true
			if Chatter:GetBool() and IsValid(self.v) and UVTargeting and not UVEnemyEscaping then
				UVChatterOnScene(self) 
			end
		end
		
		--Spawning
		if self.toofar and edist:LengthSqr() < 25000000 and self:StraightToTarget(self.e) then
			if not self.spawncooldown then
				timer.Simple(1, function() if IsValid(self.v) then self.invincible = nil end end)
				self.invincible = true
				self.toofar = nil
				if not UVEnemyEscaping then uverespawn = self.e:GetPos() end
				self:SetELSSiren(true)
				--if ph:GetAngles().z > 90 and ph:GetAngles().z < 270 then self.v:PointAtEntity(self.e) end
			end	end
			
			--Bounty
			local botimeout = 10
			if botimeout then
				if CurTime() > self.bountytimer + botimeout then
					self.bountytimer = CurTime()
					local aggressive = math.random(0,1)
					if aggressive == 0 then
						self.driveinfront = nil
					else
						self.driveinfront = true
					end
					local MathAggressive = math.random(1,10) 
					if MathAggressive == 1 then
						if not self.aggressive and UVTargeting then
							self.aggressive = true
							if Chatter:GetBool() and IsValid(self.v) and self:StraightToTarget(self.e) and not UVCalm then
								UVChatterAggressive(self) 
							end
						else
							self.aggressive = nil
							if Chatter:GetBool() and IsValid(self.v) and self:StraightToTarget(self.e) and not UVCalm then
								UVChatterPassive(self) 
							end
						end
					elseif MathAggressive == 2 then
						if Chatter:GetBool() and HeatLevels:GetBool() and IsValid(self.v) and not UVCalm and #UVUnitsChasing == 1 then
							UVChatterRequestBackup(self)
						end
					elseif MathAggressive == 3 then
						if Chatter:GetBool() and IsValid(self.v) and not UVCalm then
							UVChatterRequestSitrep(self)
						end
					else
						local MathAggressive2 = math.random(1,10)
						if Chatter:GetBool() and MathAggressive2 == 1 then
							UVChatterRequestDisengage(self)
						end
					end
					if isfunction(self.e.GetDriver) and IsValid(UVGetDriver(self.e)) and UVGetDriver(self.e):IsPlayer() then 
						self.edriver = UVGetDriver(self.e)
						UVAddToWantedListDriver(self.edriver)
					else
						self.edriver = nil
					end
					local MathSiren = math.random(1,100)
					if MathSiren < 30 then
						self:SetELSSiren(true)
					end
					if Chatter:GetBool() and IsValid(self.v) and self.e:GetVelocity():LengthSqr() > 100000 and self:StraightToTarget(self.e) and MathAggressive ~= 1 then
						UVChatterCloseToEnemy(self) 
					end
				end
			end
			
			if self.v:GetVelocity():LengthSqr() > 10000 and not self.stuck then
				if self.v.IsSimfphyscar then
					if istable(self.v.Wheels) then
						for i = 1, table.Count( self.v.Wheels ) do
							local Wheel = self.v.Wheels[ i ]
							if not Wheel then return end
							if Wheel:GetGripLoss() > 0 then
								throttle = throttle * Wheel:GetGripLoss() --Simfphys traction control
							end
						end
					end
					if not UVEnemyEscaping and self:StraightToTarget(self.e) and self.metwithenemy and not self.stuck then
						if (math.abs(steer) > 0.5 or (self:ObstaclesNearby() and not Relentless:GetBool())) and self.v:GetVelocity():LengthSqr() > 100000 and self.e:GetVelocity():LengthSqr() < self.v:GetVelocity():LengthSqr() then
							if self.v:GetGear() >= 3 then
								throttle = -1
							else
								throttle = 1
							end
						end --Cornering
					end
				elseif self.v.IsGlideVehicle then
					local EntityMeta = FindMetaTable( "Entity" )
					local getTable = EntityMeta.GetTable
					local selfvTbl = getTable( self.v )
					local wheelslip = selfvTbl.avgForwardSlip > 0 and selfvTbl.avgForwardSlip or selfvTbl.avgForwardSlip < 0 and selfvTbl.avgForwardSlip * -1
					if wheelslip ~= false then
						throttle = throttle - (wheelslip/10) --Glide traction control
					end
					if dist:Length2DSqr() > 250000 and vectdot < 0 and dist:Dot(forward) > 0 and (right.z > 0.75 or right.z < -0.75) and not self.stuck then
						steer = 0
						throttle = 1
					end --Straighten out
					if not UVEnemyEscaping and self:StraightToTarget(self.e) and self.metwithenemy and not self.stuck then
						if (math.abs(steer) > 0.5 or (self:ObstaclesNearby() and not Relentless:GetBool())) and self.v:GetVelocity():LengthSqr() > 100000 and self.e:GetVelocity():LengthSqr() < self.v:GetVelocity():LengthSqr() then
							if self.v:GetGear() >= 1 then
								throttle = -1
							else
								throttle = 1
							end
						end --Cornering
					end
				else
					if vectdot > 0 and evectdot > 0 and dist:Dot(forward) > 0 and dist:Length2DSqr() > 250000 and self:StraightToTarget(self.e) then 
						local maththrottle = throttle - math.abs(steer)
						if maththrottle >= 0 then
							throttle = maththrottle
						end
					end --Cornering
				end
			end
			
			if self.v.roadblocking then
				throttle = 0
				steer = 0
			end
			
			--Set throttle.
			if self.v.IsScar then
				if throttle > 0 then
					self.v:GoForward(throttle)
				else
					self.v:GoBack(-throttle)
				end
			elseif self.v.IsSimfphyscar then
				self.v:SetActive(true)
				self.v:StartEngine()
				self.v.PressedKeys = self.v.PressedKeys or {}
				self.v.PressedKeys["Shift"] = false
				self.v.PressedKeys["joystick_throttle"] = throttle
				self.v.PressedKeys["joystick_brake"] = throttle * -1
			elseif isfunction(self.v.SetThrottle) and not self.v.IsGlideVehicle then
				self.v:SetThrottle(throttle)
			elseif self.v.IsGlideVehicle then
				self.v:TriggerInput("Throttle", throttle)
				self.v:TriggerInput("Brake", throttle * -1)
			end
			
			--Set steering parameter.
			if ph:GetAngleVelocity().y > 120 then return end --If the vehicle is spinning, don't change.
			--if math.abs(steer) < 0.25 and dist:Dot(forward) > 0 and dist:LengthSqr() < 6250000 and dist:Length2DSqr() > 250000 and vectdot > 0 and self.e:GetVelocity():LengthSqr() > 250000 then steer = 0 end --If direction is almost straight, set 0.		
			if dist:Dot(forward) > 0 and dist:Dot(eforward) > 0 and vectdot > 0 and evectdot > 0 and self.v:GetVelocity():LengthSqr() > self.e:GetVelocity():LengthSqr() and dist:Length2DSqr() < 5000000 and self.e:GetVelocity():LengthSqr() > 250000 then
				--if eph:GetAngleVelocity().z < -45 then steer = 1 end
				--if eph:GetAngleVelocity().z > 45 then steer = -1 end
				if eph:GetAngleVelocity().z < -22.5 or eph:GetAngleVelocity().z > 22.5 then throttle = 0 end
			end --Mimic enemy's cornering (chasing)
			if dist:Dot(forward) > 0 and dist:Dot(eforward) < 0 and vectdot > 0 and evectdot < 0 and dist:Length2DSqr() > 250000 and self.e:GetVelocity():LengthSqr() > 250000 then
				--if eph:GetAngleVelocity().z < -45 then steer = -1 end
				--if eph:GetAngleVelocity().z > 45 then steer = 1 end
				if eph:GetAngleVelocity().z < -22.5 or eph:GetAngleVelocity().z > 22.5 then throttle = 0 end
			end --Mimic enemy's cornering (head-on)
			
			if self.v.IsScar then
				if steer > 0 then
					self.v:TurnRight(steer)
				elseif steer < 0 then
					self.v:TurnLeft(-steer)
				else
					self.v:NotTurning()
				end
			elseif self.v.IsGlideVehicle then
				steer = steer * 2 --Attempt to make steering more sensitive.
				self.v:TriggerInput("Steer", steer)
			elseif self.v.IsSimfphyscar then
				self.v:SetActive(true)
				self.v:StartEngine()
				self.v:PlayerSteerVehicle(self, steer < 0 and -steer or 0, steer > 0 and steer or 0)
			elseif isfunction(self.v.SetSteering) and not self.v.IsGlideVehicle then
				self.v:SetSteering(steer, 0)
			end
			
			--Losing conditions
			local visualrange = 25000000
			if UVHiding then
				visualrange = 1000000
			end
			if self:VisualOnTarget(self.e) and eedist:LengthSqr() < visualrange then
				UVLosing = CurTime()
				if not table.HasValue(UVUnitsChasing, self) then
					table.insert(UVUnitsChasing, self)
				end
			else
				if table.HasValue(UVUnitsChasing, self) then
					table.RemoveByValue(UVUnitsChasing, self)
				end
			end
			
			--Set ELS
			self:SetELS(true)
			self:SetELSSound(true)
			
			--When too far to chase enemy
			if edist:LengthSqr() > 25000000 and not self.toofar and not self:VisualOnTarget(self.e) then
				if not UVEnemyEscaping then uverespawn = self.e:GetPos() end
				self.toofar = true
			end
			
		end --if not self:Validate(self.e)
		
		--Targeting
		--if IsValid(self.e) and not UVTargeting and not UVCalm then
		--	UVTargeting = true
		--end
		
	end
	
	function ENT:Initialize()
		self:SetNoDraw(true)
		self:SetMoveType(MOVETYPE_NONE)
		self:SetModel(self.Modelname)
		self:SetHealth(-1)
		self.bountytimer = CurTime()
		self.callsign = "Pursuit "..self:EntIndex()
		self.moving = CurTime()
		self.deploying = CurTime()
		self.rdeploying = CurTime()
		self.ks = CurTime()
		self.heli = CurTime()
		self.stuck = nil
		self.spawned = true
		self.toofar = true
		self.voice = math.random(13,18)
		UVCalm = nil
		UVEnemyBusted = nil
		UVEnemyEscaped = nil
		UVRCooldown = nil
		local aggressive = math.random(0,1)
		if aggressive == 0 then
			self.driveinfront = nil
		else
			self.driveinfront = true
		end
		local MathAggressive = math.random(0,1)
		if MathAggressive == 1 then
			self.aggressive = true
		end
		self.respawn = self:GetPos()
		--uverespawn = self:GetPos()
		self.Speeding = (SpeedLimit:GetFloat()*17.6)^2 --MPH to in/s^2
		timer.Simple(1, function() 
			if IsValid(self.v) then
				timer.Simple(2, function()
					if IsValid(self.v) then
						if vcmod_main and self.v:GetClass() == "prop_vehicle_jeep" and GetConVar("unitvehicle_enableheadlights"):GetBool() then 
							self.v:VC_setRunningLights(true)
						end
					end
				end)
				self.spawned = nil
			end 
		end)
		
		--Pick up a vehicle in the given sphere.
		if self.vehicle then
			local v = self.vehicle
			if v.UnitVehicle then return end --If it's already a Unit Vehicle, don't pick it up.
			if v.IsScar then --If it's a SCAR.
				if not v:HasDriver() then --If driver's seat is empty.
					self.v = v
					v.UVPursuit = self
					v.UnitVehicle = self
					v.HasDriver = function() return true end --SCAR script assumes there's a driver.
					v.SpecialThink = function() end --Tanks or something sometimes make errors so disable thinking.
					v:StartCar()
				end
			elseif v.IsSimfphyscar and v:IsInitialized() then --If it's a Simfphys Vehicle.
				if not IsValid(v:GetDriver()) then --Fortunately, Simfphys Vehicles can use GetDriver()
					self.v = v
					v.UVPursuit = self
					v.UnitVehicle = self
					v:SetActive(true)
					v:StartEngine()
					if GetConVar("unitvehicle_enableheadlights"):GetBool() then
						v:SetLightsEnabled(true)
					end
					v:SetBulletProofTires(true)
				end
			elseif isfunction(v.EnableEngine) and isfunction(v.StartEngine) and not v.IsGlideVehicle then --Normal vehicles should use these functions. (SCAR and Simfphys cannot.)
				if isfunction(v.GetWheelCount) and v:GetWheelCount() and not IsValid(v:GetDriver()) then
					self.v = v
					v.UVPursuit = self
					v.UnitVehicle = self
					v:EnableEngine(true)
					v:StartEngine(true)
				end
			elseif v.IsGlideVehicle then --Glide
				if not IsValid(v:GetDriver()) then
					self.v = v
					v.UVPursuit = self
					v.UnitVehicle = self
					v:SetEngineState(2)
					if GetConVar("unitvehicle_enableheadlights"):GetBool() and v.CanSwitchHeadlights then
						v:SetHeadlightState(1)
					end
				end
			end
		else
			local distance = DetectionRange:GetFloat()
			for k, v in pairs(ents.FindInSphere(self:GetPos(), distance)) do
				if v:GetClass() == 'prop_vehicle_prisoner_pod' then continue end
				if v.UnitVehicle then continue end
				if v:IsVehicle() then
					if v.IsScar then --If it's a SCAR.
						if not v:HasDriver() then --If driver's seat is empty.
							self.v = v
							v.UVPursuit = self
							v.UnitVehicle = self
							v.HasDriver = function() return true end --SCAR script assumes there's a driver.
							v.SpecialThink = function() end --Tanks or something sometimes make errors so disable thinking.
							v:StartCar()
						end
					elseif v.IsSimfphyscar and v:IsInitialized() then --If it's a Simfphys Vehicle.
						if not IsValid(v:GetDriver()) then --Fortunately, Simfphys Vehicles can use GetDriver()
							self.v = v
							v.UVPursuit = self
							v.UnitVehicle = self
							v:SetActive(true)
							v:StartEngine()
							if GetConVar("unitvehicle_enableheadlights"):GetBool() then
								v:SetLightsEnabled(true)
							end
							v:SetBulletProofTires(true)
						end
					elseif isfunction(v.EnableEngine) and isfunction(v.StartEngine) and not v.IsGlideVehicle then --Normal vehicles should use these functions. (SCAR and Simfphys cannot.)
						if isfunction(v.GetWheelCount) and v:GetWheelCount() and not IsValid(v:GetDriver()) then
							self.v = v
							v.UVPursuit = self
							v.UnitVehicle = self
							v:EnableEngine(true)
							v:StartEngine(true)
						end
					elseif v.IsGlideVehicle then --Glide
						if not IsValid(v:GetDriver()) then
							self.v = v
							v.UVPursuit = self
							v.UnitVehicle = self
							v:TurnOn()
							if GetConVar("unitvehicle_enableheadlights"):GetBool() and v.CanSwitchHeadlights then
								v:SetHeadlightState(1)
							end
						end
					end
				end
			end
		end
		
		if not IsValid(self.v) or not IsValid(self.v:GetPhysicsObject()) then SafeRemoveEntity(self) return end --When there's no vehicle, remove Unit Vehicle.
		UVDeploys = UVDeploys + 1
		
		local deletiontime = self.v.roadblocking and 10 or 1
		if self.uvscripted then
			timer.Simple(deletiontime, function()
				if IsValid(self) then
					self.uvmarkedfordeletion = true
				end
			end)
		end
		
		if not self.uvscripted then
			local e = EffectData()
			e:SetEntity(self.v)
			util.Effect("propspawn", e) --Perform a spawn effect.
		end
		if not UVTargeting then self.v:EmitSound( "doors/metal_stop1.wav" ) end
		self.mass = math.Round(self.v:GetPhysicsObject():GetMass())
		if Chatter:GetBool() and IsValid(self.v) and not UVTargeting then
			UVChatterInitialize(self) 
		end
		
		local collisionmin, collisionmax = self.v:GetCollisionBounds()
		if isvector(collisionmin) and isvector(collisionmax) then
			if self.v.IsSimfphyscar or self.v.IsGlideVehicle then
				self.v.width = ((collisionmax.y)-(collisionmin.y))
				self.v.length = ((collisionmax.x)-(collisionmin.x))
			else
				self.v.width = ((collisionmax.x)-(collisionmin.x))
				self.v.length = ((collisionmax.y)-(collisionmin.y))
			end
		end
		
		local min, max = self.v:GetHitBoxBounds(0, 0) --NPCs aim at the top of the vehicle referred by hit box.
		if not isvector(max) then min, max = self.v:GetModelBounds() end --If getting hit box bounds is failed, get model bounds instead.
		if not isvector(max) then max = vector_up * math.random(80, 200) end --If even getting model bounds is failed, set a random value.
		
		local tr = util.TraceHull({start = self.v:GetPos() + vector_up * max.z, 
		endpos = self.v:GetPos(), ignoreworld = true,
		mins = Vector(-16, -16, -1), maxs = Vector(16, 16, 1)})
		self.CollisionHeight = tr.HitPos.z - self.v:GetPos().z
		if self.CollisionHeight < 10 then self.CollisionHeight = max.z end
		self.v:DeleteOnRemove(self)
		
		net.Start("UVHUDAddUV")
		net.WriteInt(self.v:EntIndex(), 32)
		net.WriteString("unit")
		net.Broadcast()
		
	end
else --if CLIENT
	function ENT:Initialize()
		self:SetNoDraw(true)
		self:SetMoveType(MOVETYPE_NONE)
		self:SetModel(self.Modelname)
	end
end --if SERVER

--For Half Life Renaissance Reconstructed
function ENT:GetNoTarget()
	return false
end

--For Simfphys Vehicles
function ENT:GetInfoNum(key, default)
	if key == "cl_simfphys_ctenable" then return 1 --returns the default value
	elseif key == "cl_simfphys_ctmul" then return 0.7 --because there's a little weird code in
	elseif key == "cl_simfphys_ctang" then return 15 --Simfphys:PlayerSteerVehicle()
	elseif isnumber(default) then return default end
	return 0
end
