list.Set("NPC", "npc_racervehicle", {
	Name = "Racer Vehicle",
	Class = "npc_racervehicle",
	Category = "Unit Vehicles (Hostile)"
})
AddCSLuaFile("npc_racervehicle.lua")
include("entities/uvapi.lua")

ENT.Base = "base_entity"
ENT.Type = "ai"

ENT.PrintName = "RacerVehicle"
ENT.Author = "Razor"
ENT.Contact = "Romeo"
ENT.Purpose = "It ain't over until I say it's over."
ENT.Instruction = "Spawn on/under the vehicle until it shows a spawn effect."
ENT.Spawnable = false
ENT.Modelname = "models/props_lab/huladoll.mdl"

local dvd = DecentVehicleDestination

if SERVER then	
	--Setting ConVars.
	local DetectionRange = GetConVar("unitvehicle_detectionrange")
	local RacerPursuitTech = GetConVar("unitvehicle_racerpursuittech")
	
	function ENT:OnRemove()
		--By undoing, driving, diving in water, or getting stuck, and the vehicle is remaining.
		if IsValid(self.v) and self.v:IsVehicle() then
			self.v.RacerVehicle = nil
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
				self.v.PressedKeys["Space"] = true
				if self.v.uvbusted then
					local randomno = math.random(1, 2)
					if randomno == 1 then
						self.v.PressedKeys["Space"] = false
					end
				end
			elseif not IsValid(self.v:GetDriver()) and --The vehicle is normal vehicle.
			isfunction(self.v.StartEngine) and isfunction(self.v.SetHandbrake) and 
			isfunction(self.v.SetThrottle) and isfunction(self.v.SetSteering) and !self.v.IsGlideVehicle then
				self.v.GetDriver = self.v.OldGetDriver or self.v.GetDriver
				self.v:SetThrottle(0)
				self:SetELS(false)
			elseif self.v.IsGlideVehicle then
				self.v:TurnOff()
				self.v:TriggerInput("Throttle", 0)
				if self.v.uvbusted then
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
			
			local e = EffectData()
			e:SetEntity(self.v)
			util.Effect("entity_remove", e) --Perform an effect.
			
		end
		
	end
	
	function ENT:StraightToRace(point)
		if !self.v or !self.e then
			return
		end
		local tr = util.TraceLine({start = self.v:WorldSpaceCenter(), endpos = point, mask = MASK_NPCWORLDSTATIC, filter = {self, self.v, self.e, uvenemylocation}}).Fraction==1
		return tobool(tr)
	end
	
	function ENT:Stop()
		if self.v.IsScar then
			self.v:GoNeutral()
			self.v:NotTurning()
			self.v:HandBrakeOn()
		elseif self.v.IsSimfphyscar then
			self.v.PressedKeys = self.v.PressedKeys or {}
			self.v.PressedKeys["W"] = false
			self.v.PressedKeys["A"] = false
			self.v.PressedKeys["S"] = false
			self.v.PressedKeys["D"] = false
			self.v.PressedKeys["Shift"] = false
			self.v.PressedKeys["Space"] = true
		elseif isfunction(self.v.SetThrottle) and isfunction(self.v.SetSteering) and isfunction(self.v.SetHandbrake) and !self.v.IsGlideVehicle then
			self.v:SetThrottle(0)
			self.v:SetSteering(0, 0)
			if self.v:GetVelocity():LengthSqr() < 10000 then 
				self.v:SetHandbrake(true)
			else 
				self.v:SetHandbrake(false)
			end
		elseif self.v.IsGlideVehicle then
			self.v:TriggerInput("Handbrake", 1)
			self.v:TriggerInput("Throttle", 0)
			self.v:TriggerInput("Brake", 0)
			self.v:TriggerInput("Steer", 0)
		end
		self.moving = CurTime()
	end

	function ENT:CanSeeGoal(target)
		if !self.v or !target then
			return
		end
		local tr = util.TraceLine({start = self.v:WorldSpaceCenter(), endpos = target, mask = MASK_OPAQUE, filter = {self, self.v}}).Fraction==1
		return tobool(tr)
	end
	
	function ENT:FindRace()
		if (self.v.uvraceparticipant and UVRaceInEffect) and (UVRaceTable['Participants'] and UVRaceTable['Participants'][self.v]) then
			if !UVRaceInProgress then return nil end
			
			local array = UVRaceTable['Participants'][self.v]

			local current_checkp = #array.Checkpoints + 1
			local selected_point = nil

			for _, v in ipairs(ents.FindByClass('uvrace_brush*')) do
				if v:GetID() == current_checkp then
					selected_point = v
					break
					-- self.PatrolWaypoint = {
					-- 	['Target'] = (v:GetPos1()+v:GetPos2())/2,
					-- 	['SpeedLimit'] = math.huge
					-- }
				end
			end

			if selected_point then
				-- local pos1 = selected_point:GetPos1()
				-- local pos2 = selected_point:GetPos2()

				-- local lowest_y = math.min(pos1.y, pos2.y)

				-- local target = (Vector(pos1.x, lowest_y, pos1.z) + Vector(pos2.x, lowest_y, pos2.z)) / 2
				-- Moved to brushpoint init function for better optimization, as creating Vector objects in a loop seems inefficient
				local target = selected_point.target_point
				local cansee = self:CanSeeGoal(target)

				local nearest_waypoint = dvd.GetNearestWaypoint(self.v:WorldSpaceCenter())
				
				-- Here we can either go full-DV, or just go straight towards checkpoint if there is nothing infront of the car.
				-- Further tests may be needed to determine which one is better
				if cansee then
					self.PatrolWaypoint = {
						['Target'] = target,
						['SpeedLimit'] = (nearest_waypoint and nearest_waypoint.SpeedLimit ^ 2) or math.huge
					}
					print(self.PatrolWaypoint.SpeedLimit)
				else
					-- Must utilize dvs
					local waypoints = dvd.GetRouteVector(self.v:WorldSpaceCenter(), target)
					
					if IsValid(waypoints) and waypoints > 0 then
						self.PatrolWaypoint = waypoints[1]
					else
						self.PatrolWaypoint = nearest_waypoint
					end
				end
			end


		else
			if next(dvd.Waypoints) == nil then
				return
			end
		
			local Waypoint = dvd.GetNearestWaypoint(self.v:WorldSpaceCenter())
			if Waypoint.Neighbors then --Keep going straight
				self.PatrolWaypoint = dvd.Waypoints[Waypoint.Neighbors[math.random(#Waypoint.Neighbors)]]
			else
				self.PatrolWaypoint = Waypoint
			end
		end

		-- if next(dvd.Waypoints) == nil then
		-- 	return
		-- end
		
		-- local Waypoint = dvd.GetNearestWaypoint(self.v:WorldSpaceCenter())
		-- if Waypoint.Neighbors then --Keep going straight
		-- 	self.PatrolWaypoint = dvd.Waypoints[Waypoint.Neighbors[math.random(#Waypoint.Neighbors)]]
		-- else
		-- 	self.PatrolWaypoint = Waypoint
		-- end

		-- self.PatrolWaypoint = {}
		-- self.PatrolWaypoint["Target"] = Entity(1):GetPos()
		-- self.PatrolWaypoint["SpeedLimit"] = math.huge
		
	end
	
	function ENT:Race()
		
		self:FindRace()
		
		if next(dvd.Waypoints) == nil then
			return
		end
		
		if self.PatrolWaypoint then
			
			if !self.racing then
				self.racing = true
			end
			
			--Set handbrake
			if self.v.IsScar then
				self.v:HandBrakeOff()
			elseif self.v.IsSimfphyscar then
				--self.v:SetActive(true)
				--self.v:StartEngine()
				self.v.PressedKeys = self.v.PressedKeys or {}
				self.v.PressedKeys["Space"] = false
			elseif isfunction(self.v.SetHandbrake) and !self.v.IsGlideVehicle then
				self.v:SetHandbrake(false)
			end
			
			--Racing techniques
			local WaypointPos = self.PatrolWaypoint["Target"]
			local forward = self.v.IsSimfphyscar and self.v:LocalToWorldAngles(self.v.VehicleData.LocalAngForward):Forward() or self.v:GetForward()
			local dist = WaypointPos - self.v:WorldSpaceCenter()
			local vect = dist:GetNormalized()
			local vectdot = vect:Dot(self.v:GetVelocity())
			local throttle = dist:Dot(forward) > 0 and 1 or -1
			local right = vect:Cross(forward)
			local steer_amount = right:Length()
			local steer = right.z > 0 and steer_amount or -steer_amount
			local speedlimitmph = self.PatrolWaypoint["SpeedLimit"]
			self.Speeding = speedlimitmph^2
			
			--Unique racing techniques
			if self.stuck then
				steer = 0
				throttle = throttle * -1
			end --Getting unstuck
			if self.v:GetVelocity():LengthSqr() > self.Speeding then 
				throttle = 0
			end --Slow down
			if self.v.IsSimfphyscar and self.v:GetVelocity():LengthSqr() > 10000 then
				if istable(self.v.Wheels) then
					for i = 1, table.Count( self.v.Wheels ) do
						local Wheel = self.v.Wheels[ i ]
						if !Wheel then return end
						if Wheel:GetGripLoss() > 0 then
							throttle = throttle * Wheel:GetGripLoss() --Simfphys traction control
						end
					end
				end
			end
			if dist:Dot(forward) < 0 and !self.stuck then
				if vectdot > 0 then
					if right.z > 0 then 
						steer = -1 
					else 
						steer = 1 
					end
				end
			end --K turn
			
			--Set throttle
			if self.v.IsScar then
				if throttle > 0 then
					self.v:GoForward(throttle)
				else
					self.v:GoBack(-throttle)
				end
			elseif self.v.IsSimfphyscar then
				self.v.PressedKeys = self.v.PressedKeys or {}
				self.v.PressedKeys["Shift"] = false
				self.v.PressedKeys["joystick_throttle"] = throttle
				self.v.PressedKeys["joystick_brake"] = throttle * -1
			elseif self.v.IsGlideVehicle then
				self.v:TriggerInput("Handbrake", 0)
				self.v:TriggerInput("Throttle", throttle)
				self.v:TriggerInput("Brake", throttle * -1)
			elseif isfunction(self.v.SetThrottle) and !self.v.IsGlideVehicle then
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
				self.v:PlayerSteerVehicle(self, steer < 0 and -steer or 0, steer > 0 and steer or 0)
			elseif self.v.IsGlideVehicle then
				steer = steer * 2 --Attempt to make steering more sensitive.
				self.v:TriggerInput("Steer", steer)
			elseif isfunction(self.v.SetSteering) and !self.v.IsGlideVehicle then
				self.v:SetSteering(steer, 0)
			end
			
			--Resetting
			if not (self.v:GetVelocity():LengthSqr() < 10000 and (throttle > 0 or throttle < 0)) then 
				self.moving = CurTime()
			end
			if self.stuck then 
				self.moving = CurTime()
			end
			
			local timeout = 1
			if timeout and timeout > 0 then
				if CurTime() > self.moving + timeout then --If it has got stuck for enough time.
					self.stuck = true
					self.moving = CurTime()
					timer.Simple(2, function() if IsValid(self.v) then self.stuck = nil self.PatrolWaypoint = nil end end)
				end
			end
			
		else
			self:Stop()
		end
		
		--Pursuit Tech
		if self.v.PursuitTech and uvtargeting then
			for k, v in pairs(self.v.PursuitTech) do
				if v.Tech ~= 'Shockwave' and v.Tech ~= 'Jammer' and v.Tech ~= 'Repair Kit' then
					UVDeployWeapon(self.v, k)
				end
				if v.Tech == "Repair Kit" then
					if self.v.IsGlideVehicle then
						if self.v:GetChassisHealth() <= (self.v.MaxChassisHealth / 3) then
							UVDeployWeapon(self.v, k)
							continue
						end
					elseif self.v.IsSimfphyscar then
						if self.v:GetCurHealth() <= (self.v:GetMaxHealth() / 3) then
							UVDeployWeapon(self.v, k)
							continue
						end
					elseif vcmod_main and self.v:GetClass() == "prop_vehicle_jeep" then
						if self.v:VC_getHealth() <= (self.v:VC_getHealthMax() / 3) then
							UVDeployWeapon(self.v, k)
							continue
						end
					end
				end
			end
		end	
	end
	
	function ENT:Think()
		self:SetPos(self.v:GetPos() + Vector(0,0,50))
		self:SetAngles(self.v:GetPhysicsObject():GetAngles()+Angle(0,180,0))

		if self.v then
			if self.v.raceinvited then
				if !table.HasValue(UVRaceCurrentParticipants, self.v) then
					UVRaceAddParticipant( self.v, nil, true )
					return
				end
				self.v.raceinvited = false
				timer.Remove('RaceInviteExpire'..v:EntIndex())
			end
		end

		if not GetConVar("ai_ignoreplayers"):GetBool() then
			self:Race()
		else
			self:Stop()
		end

		-- Make their computing rate higher ONLY if they are in a race
		if self.v.uvraceparticipant then
			self:NextThink( CurTime() )
			return true
		end
	end
	
	function ENT:Initialize()
		self:SetNoDraw(true)
		self:SetMoveType(MOVETYPE_NONE)
		self:SetModel(self.Modelname)
		self:SetHealth(-1)
		
		self.moving = CurTime()
		
		timer.Simple(3, function()
			if IsValid(self.v) then
				if vcmod_main and self.v:GetClass() == "prop_vehicle_jeep" and GetConVar("unitvehicle_enableheadlights"):GetBool() then 
					self.v:VC_setRunningLights(true)
				end
			end
		end)
		
		--Pick up a vehicle in the given sphere.
		if self.vehicle then
			local v = self.vehicle
			if v.RacerVehicle then return end --If it's already a Racer Vehicle, don't pick it up.
			if v.IsScar then --If it's a SCAR.
				if not v:HasDriver() then --If driver's seat is empty.
					self.v = v
					v.RacerVehicle = self
					v.HasDriver = function() return true end --SCAR script assumes there's a driver.
					v.SpecialThink = function() end --Tanks or something sometimes make errors so disable thinking.
					v:StartCar()
				end
			elseif v.IsSimfphyscar and v:IsInitialized() then --If it's a Simfphys Vehicle.
				if not IsValid(v:GetDriver()) then --Fortunately, Simfphys Vehicles can use GetDriver()
					self.v = v
					v.RacerVehicle = self
					v:SetActive(true)
					v:StartEngine()
					if GetConVar("unitvehicle_enableheadlights"):GetBool() then
						v:SetLightsEnabled(true)
					end
					if GetConVar("unitvehicle_autohealth"):GetBool() then
						v:SetMaxHealth(math.huge)
						v:SetCurHealth(math.huge)
					end
				end
			elseif isfunction(v.EnableEngine) and isfunction(v.StartEngine) and !v.IsGlideVehicle then --Normal vehicles should use these functions. (SCAR and Simfphys cannot.)
				if isfunction(v.GetWheelCount) and v:GetWheelCount() and not IsValid(v:GetDriver()) then
					self.v = v
					v.RacerVehicle = self
					v:EnableEngine(true)
					v:StartEngine(true)
					if GetConVar("unitvehicle_autohealth"):GetBool() then
						if vcmod_main and v:GetClass() == "prop_vehicle_jeep" then
							v:VC_repairFull_Admin()
							if !v:VC_hasGodMode() then
								v:VC_setGodMode(true)
							end
						end
					end
				end
			elseif v.IsGlideVehicle then --Glide
				if not IsValid(v:GetDriver()) then
					self.v = v
					v.RacerVehicle = self
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
				if v.RacerVehicle then continue end
				if v:IsVehicle() then
					if v.IsScar then --If it's a SCAR.
						if not v:HasDriver() then --If driver's seat is empty.
							self.v = v
							v.RacerVehicle = self
							v.HasDriver = function() return true end --SCAR script assumes there's a driver.
							v.SpecialThink = function() end --Tanks or something sometimes make errors so disable thinking.
							v:StartCar()
							break
						end
					elseif v.IsSimfphyscar and v:IsInitialized() then --If it's a Simfphys Vehicle.
						if not IsValid(v:GetDriver()) then --Fortunately, Simfphys Vehicles can use GetDriver()
							self.v = v
							v.RacerVehicle = self
							v:SetActive(true)
							v:StartEngine()
							if GetConVar("unitvehicle_enableheadlights"):GetBool() then
								v:SetLightsEnabled(true)
							end
							if GetConVar("unitvehicle_autohealth"):GetBool() then
								v:SetMaxHealth(math.huge)
								v:SetCurHealth(math.huge)
							end
							break
						end
					elseif isfunction(v.EnableEngine) and isfunction(v.StartEngine) and !v.IsGlideVehicle then --Normal vehicles should use these functions. (SCAR and Simfphys cannot.)
						if isfunction(v.GetWheelCount) and v:GetWheelCount() and not IsValid(v:GetDriver()) then
							self.v = v
							v.RacerVehicle = self
							v:EnableEngine(true)
							v:StartEngine(true)
							if GetConVar("unitvehicle_autohealth"):GetBool() then
								if vcmod_main and v:GetClass() == "prop_vehicle_jeep" then
									v:VC_repairFull_Admin()
									if !v:VC_hasGodMode() then
										v:VC_setGodMode(true)
									end
								end
							end
							break
						end
					elseif v.IsGlideVehicle then --Glide
						if not IsValid(v:GetDriver()) then
							self.v = v
							v.RacerVehicle = self
							v:TurnOn()
							if GetConVar("unitvehicle_enableheadlights"):GetBool() and v.CanSwitchHeadlights then
								v:SetHeadlightState(1)
							end
							break
						end
					end
				end
			end
		end
		
		if not IsValid(self.v) then SafeRemoveEntity(self) return end --When there's no vehicle, remove Racer Vehicle.
		local e = EffectData()
		e:SetEntity(self.v)
		util.Effect("propspawn", e) --Perform a spawn effect.
		self.v:EmitSound( "beams/beamstart5.wav" )
		
		local pttable = {
			--"EMP",
			"ESF",
			"Jammer",
			"Shockwave",
			"Spikestrip",
			"Stunmine",
			"Repair Kit",
		}
		
		if RacerPursuitTech:GetBool() then
			if not self.v.PursuitTech then
				self.v.PursuitTech = {}

				for i=1, 2, 1 do
					local selected_pt = pttable[math.random(#pttable)]
					local sanitized_pt = string.lower(string.gsub(selected_pt, " ", ""))
					local sel_k, sel_v
				
					for k,v in pairs(self.v.PursuitTech) do
						if v.Tech == selected_pt then
							sel_k, sel_v = k, v
							self.v.PursuitTech[k] = nil
							break
						end
					end

					local ammo_count = GetConVar("unitvehicle_pursuittech_maxammo_"..sanitized_pt):GetInt()
					ammo_count = ammo_count > 0 and ammo_count or math.huge
				
					self.v.PursuitTech[i] = {
						Tech = selected_pt,
						Ammo = ammo_count,
						Cooldown = GetConVar("unitvehicle_pursuittech_cooldown_"..sanitized_pt):GetInt(),
						LastUsed = -math.huge,
						Upgraded = false
					}
				end

				table.insert(uvrvwithpursuittech, self.v)

				self.v:CallOnRemove( "UVRVWithPursuitTechRemoved", function(car)
					if table.HasValue(uvrvwithpursuittech, car) then
						table.RemoveByValue(uvrvwithpursuittech, car)
					end
				end)
			end
		end
		
		if !self.uvscripted then
			if next(dvd.Waypoints) == nil then
				PrintMessage( HUD_PRINTCENTER, #ents.FindByClass("npc_racervehicle").." Racer(s) spawned!" )
			else
				PrintMessage( HUD_PRINTCENTER, #ents.FindByClass("npc_racervehicle").." Racer(s) spawned! (DV Waypoints detected!)" )
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
		
	end
else
	function ENT:Initialize()
		self:SetNoDraw(true)
		self:SetMoveType(MOVETYPE_NONE)
		self:SetModel(self.Modelname)
	end
end

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
