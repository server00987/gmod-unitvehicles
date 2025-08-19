AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
local CanWreck = GetConVar("unitvehicle_canwreck")
local Chatter = GetConVar("unitvehicle_chatter")
local ChatterText = GetConVar("unitvehicle_chattertext")
local PursuitTech = GetConVar("unitvehicle_unit_pursuittech")
local Relentless = GetConVar("unitvehicle_relentless")
local Barrels = GetConVar("unitvehicle_unit_helicopterbarrels")
local SpikeStrips = GetConVar("unitvehicle_unit_helicopterspikestrip")

local isenemyt = {
	["npc_combine_s"] = true,
	["npc_cscanner"] = true,
	["npc_manhack"] = true,
	["npc_hunter"] = true,
	["npc_antlion"] = true,
	["npc_antlionguard"] = true,
	["npc_antlion_worker"] = true,
	["npc_fastzombie_torso"] = true,
	["npc_fastzombie"] = true,
	["npc_headcrab"] = true,
	["npc_headcrab_fast"] = true,
	["npc_poisonzombie"] = true,
	["npc_headcrab_poison"] = true,
	["npc_zombie"] = true,
	["npc_zombie_torso"] = true,
	["npc_zombine"] = true,
	["npc_gman"] = true,
	["npc_breen"] = true,
}
local function isenemy(ent)
	return isenemyt[ent:GetClass()]
end

function ENT:SpawnFunction(ply, tr, cl)
	ent = ents.Create(cl)
	ent:SetPos(tr.HitPos)
	ent:SetAngles(Angle(0,ply:GetAngles().y+180,0))
	ent.Owner = ply
	ent:Spawn()
	ent:Activate()
	ent:SetTarget(ply)
	
	return ent
end

function ENT:Initialize()

	local modeltable = {
		"models/nfs_mwpolhel/nfs_mwpolhel.mdl",
		"models/nfs_ucpolhel/nfs_ucpolhel.mdl",
		"models/nfs_hppolhel/nfs_hppolhel.mdl",
		"models/nfs_nlpolhel/nfs_nlpolhel.mdl",
		"models/nfs_paybackpolhel/nfs_paybackpolhel.mdl",
		"models/hp2heliai/hp2heliai.mdl",
		"models/unboundheli/unboundheli.mdl"
	}

	self.Model = modeltable[UVUHelicopterModel:GetInt()] or modeltable[1]

	self:SetModel(self.Model)
	self:SetSkin(math.random(0,self:SkinCount()-1))
	self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
	
	self.phys = self:GetPhysicsObject()
	self.phys:EnableGravity(false)
	self.phys:SetMass(5000)
	self.phys:Wake()

	--Compensation for the model's volume
	if self.Model == "models/nfs_mwpolhel/nfs_mwpolhel.mdl" then
		self.phys:SetMass(5026)
	elseif self.Model == "models/nfs_ucpolhel/nfs_ucpolhel.mdl" then
		self.phys:SetMass(45556)
	elseif self.Model == "models/nfs_hppolhel/nfs_hppolhel.mdl" then
		self.phys:SetMass(45154)
	elseif self.Model == "models/nfs_nlpolhel/nfs_nlpolhel.mdl" then
		self.phys:SetMass(42382)
	elseif self.Model == "models/nfs_paybackpolhel/nfs_paybackpolhel.mdl" then
		self.phys:SetMass(85322)
	elseif self.Model == "models/hp2heliai/hp2heliai.mdl" then
		self.phys:SetMass(30830)
	elseif self.Model == "models/unboundheli/unboundheli.mdl" then
		self.phys:SetMass(123078)
	end
	
	self.bountytimer = CurTime()
	self.callsign = "Air "..self:EntIndex()
	local selfvoicetable = {2, 19}
	self.voice = selfvoicetable[math.random(1,2)]
	self.deployingspikes = CurTime()
	self.LastUpdate = CurTime()
	self.ReplicTime = CurTime()
	--UVLosing = CurTime()
	self.Downed = false
	self:SetHealth(500)
	self:SetCustomCollisionCheck(true)
	
	self.isBusting = nil
	self.disengaging = nil
	self.crashing = nil
	self.spotted = nil
	self.cooldown = true
	UVEnemyBusted = nil
	UVEnemyEscaped = nil
	
	self.RotateVelocity = 0
	
	self.Owner = self.Owner or game.GetWorld()

	self.UVAir = self
	self.UnitVehicle = self

	local weaponchoices = {}

	if Barrels:GetBool() then
		table.insert(weaponchoices, "barrels")
	end
	if SpikeStrips:GetBool() then
		table.insert(weaponchoices, "spikestrips")
	end

	self.WeaponChoice = (#weaponchoices > 0 and weaponchoices[math.random(1, #weaponchoices)]) or nil

	local MathAggressive = math.random(0,1)
	if MathAggressive == 1 then
		self.aggressive = true
	end
		
	timer.Simple((math.random(60,180)), function() 
		if IsValid(self) then --Fuel is randomized 
			if Chatter:GetBool() and not (self.crashing or self.disengaging) then
				UVChatterAirLowOnFuel(self)
			end
			self.disengaging = true
		end
	end)
	
	if Chatter:GetBool() and not (self.crashing or self.disengaging) and IsValid(self) then
		UVChatterAirInitialize(self) 
	end

	UVDeploys = UVDeploys + 1

	net.Start("UVHUDAddUV")
	net.WriteInt(self:EntIndex(), 32)
	net.WriteInt(self:GetCreationID(), 32)
	net.WriteString("air")
	net.Broadcast()
	
end

function ENT:OnRemove()
	if self.displaybusting then
		UVHUDBusting = nil
		net.Start( "UVHUDStopBusting" )
		net.Broadcast()
		for k, v in pairs(ents.FindByClass("npc_uv*")) do
			v.busting = CurTime()
			v.displaybusting = nil
		end
		for k, v in pairs(ents.FindByClass("uvair")) do
			v.busting = CurTime()
			v.displaybusting = nil
		end
	end
	if table.HasValue(UVUnitsChasing, self) then
		table.RemoveByValue(UVUnitsChasing, self)
	end
end

function ENT:Think()

	if IsValid(self:GetTarget()) and self:IsSeeTarget() and not self.Downed and not self.disengaging then
		if not table.HasValue(UVUnitsChasing, self) then
			table.insert(UVUnitsChasing, self)
		end
	else
		if table.HasValue(UVUnitsChasing, self) then
			table.RemoveByValue(UVUnitsChasing, self)
		end
	end

	if IsValid(self:GetTarget()) then
		
		if self.CloseToTarget and self:IsSeeTarget() and not self.spotted then
			self.spotted = true
			UVLosing = CurTime()
			timer.Simple(20, function() self.cooldown = nil end)
			if Chatter:GetBool() and not (self.crashing or self.disengaging) and IsValid(self) then
				UVChatterAirSpottedEnemy(self) 
			end
		end

		--Busting
		local btimeout = GetConVar("unitvehicle_bustedtimer"):GetFloat()
		
		if self.CloseToTarget and self:IsSeeTarget() and not self.Downed then
			
			if not self.cooldown and self.aggressive and PursuitTech:GetBool() then


				self.cooldown = true
				self.deployingspikes = CurTime()
				if self.WeaponChoice == 'spikestrips' then
					local spikes = ents.Create("entity_uvspikestrip")
					spikes.uvdeployed = true
					spikes:SetPos(self:GetPos())
					spikes:SetAngles(self.phys:GetAngles() +Angle(0,90,0))
					spikes:Spawn()
					spikes.PhysgunDisabled = false
					spikes:GetPhysicsObject():EnableMotion(true)
					constraint.NoCollide(self,spikes,0,0)
					local phspikes = spikes:GetPhysicsObject()
					phspikes:SetVelocity(self:GetTarget():GetPhysicsObject():GetVelocity()*10)
					phspikes:SetMass(100)
					timer.Simple((math.random(5,10)), function() self.cooldown = nil end)
					timer.Simple(10, function() if IsValid(spikes) then 
					spikes:Remove() 
					if Chatter:GetBool() and not (self.crashing or self.disengaging) and IsValid(self) then
						UVChatterAirSpikeStripMiss(self) 
					end
					end end)
					if Chatter:GetBool() and not (self.crashing or self.disengaging) and IsValid(self) then
						UVChatterAirSpikeStripDeployed(self) 
					end
				elseif self.WeaponChoice == 'barrels' then
					local bomb = ents.Create("entity_uvbombstrip")
					constraint.NoCollide(self,bomb,0,0)
					bomb:SetPos(self:GetPos())
					bomb:SetAngles(self.phys:GetAngles() +Angle(0,90,0))
					bomb:Spawn()
					bomb:Ignite(10)
					bomb.PhysgunDisabled = false
					bomb:GetPhysicsObject():EnableMotion(true)
					local phbomb = bomb:GetPhysicsObject()
					phbomb:SetVelocity(self:GetTarget():GetPhysicsObject():GetVelocity()*10)
					phbomb:SetMass(100)
					self:EmitSound( "npc/attack_helicopter/aheli_mine_drop1.wav" )
					timer.Simple((math.random(1,5)), function() self.cooldown = nil end)
					timer.Simple(10, function() if IsValid(bomb) then 
					bomb:BombExplode()
					end end)
					if Chatter:GetBool() and not (self.crashing or self.disengaging) and IsValid(self) then
						UVChatterAirExplosiveBarrelDeployed(self) 
					end
				end
			end

		end
	end

	uvHeliCooldown = CurTime()
	
	if self.Downed then
		if table.HasValue(UVUnitsChasing, self) then
			table.RemoveByValue(UVUnitsChasing, self)
		end
		if not self.DownState and CurTime()-self.DownTime>2.5 then
			self.DownState = true
			self.DownTime = CurTime()
			
			--self:SetColor(Color(25,25,25))
			self:PhysicsInit(SOLID_VPHYSICS)
			self.phys = self:GetPhysicsObject()
			self:Ignite(30)
			
			self.phys:EnableGravity(true)
			self.phys:AddVelocity(Vector(math.Rand(-1,1),math.Rand(-1,1),math.Rand(0,1))*500)
			
			local eff = EffectData()
			eff:SetOrigin(self:GetPos())
			util.Effect("Explosion",eff)
			util.BlastDamage(self,self,self:GetPos(),1000,10)
		elseif self.DownState and CurTime()-self.DownTime>5 then
			self:Explode()
		end
		
		self.disengaging = nil
		self.CloseToTarget = false
		if self.displaybusting then
			UVHUDBusting = nil
			net.Start( "UVHUDStopBusting" )
			net.Broadcast()
			for k, v in pairs(ents.FindByClass("npc_uv*")) do
				v.busting = CurTime()
				v.displaybusting = nil
			end
			for k, v in pairs(ents.FindByClass("uvair")) do
				v.busting = CurTime()
				v.displaybusting = nil
			end
		end
	end
	
	local p = self:GetPos()
	if math.abs(p.x)>16384 or math.abs(p.y)>16384 or math.abs(p.z)>16384 then
		self:SetPos(Vector(math.Clamp(p.x,-16384,16384),math.Clamp(p.y,-16384,16384),math.Clamp(p.z,-16384,16384)))
	end
	
	self:NextThink(CurTime()+0.25)
	return true
end

function ENT:PhysicsUpdate()
	if self.disengaging then
		if table.HasValue(UVUnitsChasing, self) then
			table.RemoveByValue(UVUnitsChasing, self)
		end
		self:ApplyAngles()
		self:ApplyHeight("up")
		self:StopRotating()
		
		timer.Simple(30, function() if IsValid(self) then self:Remove() end end)
		
		self.LastUpdate = CurTime()
		self.CloseToTarget = false
		if self.displaybusting and not UVEnemyBusted then
			UVHUDBusting = nil
			net.Start( "UVHUDStopBusting" )
			net.Broadcast()
			for k, v in pairs(ents.FindByClass("npc_uv*")) do
				v.busting = CurTime()
				v.displaybusting = nil
			end
			for k, v in pairs(ents.FindByClass("uvair")) do
				v.busting = CurTime()
				v.displaybusting = nil
			end
		end
		return
	end
	if not self.Downed and not self.disengaging then

		if self:Health()<=0 then
			self:StartCrush()
		end
		
		if IsValid(self:GetTarget()) and self:IsSeeTarget() and UVTargeting then
			UVLosing = CurTime()
		end
		
		--Bounty
		local botimeout = 10
		if CurTime() > self.bountytimer + botimeout and IsValid(self:GetTarget()) and self:IsSeeTarget() and UVTargeting then
			UVBounty = UVBounty+uvBountyTime
			self.bountytimer = CurTime()
			local MathAggressive = math.random(1,10) 
			if MathAggressive == 1 then
				if not self.aggressive and UVTargeting then
					if Relentless:GetBool() then
						self.engaging = true
					end
					self.aggressive = true
					if Chatter:GetBool() and not (self.crashing or self.disengaging) and IsValid(self) and self:IsSeeTarget() and not UVCalm then
						UVChatterAirAggressive(self) 
					end
				else
					self.engaging = nil
					self.aggressive = nil
					if Chatter:GetBool() and not (self.crashing or self.disengaging) and IsValid(self) and self:IsSeeTarget() and not UVCalm then
						UVChatterAirPassive(self) 
					end
				end
			end
			if isfunction(self:GetTarget().GetDriver) and IsValid(self:GetTarget():GetDriver()) and self:GetTarget():GetDriver():IsPlayer() then 
				self:GetTarget()driver = self:GetTarget():GetDriver()
				else
				self:GetTarget()driver = nil
			end
			if IsValid(self:GetTarget()) and Chatter:GetBool() and not (self.crashing or self.disengaging) and self:GetTarget():GetVelocity():LengthSqr() > 100000 and self:IsSeeTarget() and MathAggressive ~= 1 then
				UVChatterAirCloseToEnemy(self)
			end
		end
		
		if not IsValid(self:GetTarget()) and self.Owner~=game.GetWorld() then self:SetTarget(self.Owner) end
		
		local closetotar = self.CloseToTarget
		self.CloseToTarget = false
		
		self:ApplyAngles()
		self:ApplyHeight()
		
		if GetConVar("ai_ignoreplayers"):GetBool() then
			self:SlowDown()
			self:StopRotating()
			
			self.LastUpdate = CurTime()
			return
		end
		
		if not IsValid(self:GetTarget()) or self:GetTarget().uvbusted then
			if next(UVWantedTableVehicle) == nil then
				self.disengaging = true
				if Chatter:GetBool() and not (self.crashing or self.disengaging) and IsValid(self) then
					UVChatterAirDisengaging(self)
				end
			else
				local suspecttable = UVWantedTableVehicle
				for k, v in pairs(suspecttable) do
					if v.uvbusted then
						table.remove(suspecttable, k)
					end
				end
				local randomsuspect = suspecttable[math.random(1, #suspecttable)]
				self:SetTarget(randomsuspect)
			end
		else
			self:RotateToTarget(self:GetTargetPos())
		end
		
		if IsValid(self:GetTarget()) and not UVEnemyEscaping and not uvJammerDeployed then
			if self:GetVelocity():LengthSqr() <= (self:DistIgnoreZ((self:GetTargetPos()+self:GetTarget():GetVelocity()))^2) and not (self:DistIgnoreZ(self:GetTargetPos()) <= 500 and self:IsSeeTarget()) then
				self:FlyTo(self:GetTargetPos())
			else
				if self.engaging then
					self:FlyTo(self:GetTargetPos())
				else
					self:SlowDown()
				end
				self.CloseToTarget = true
			end
		else
			if not UVEnemyBusted then 
				self:RotateAround(uverespawn)
			end
			self:ApplyHeight("up")
			self:StopRotating()
			self.LastUpdate = CurTime()
		end
	else
		local time = CurTime()-self.LastUpdate
		
		local vel = self.phys:GetVelocity()
		self.DownedRotate = self.DownedRotate+(not self.DownState and 90*time or (CurTime()-self.DownTime)*2/2)
		self.phys:SetAngles(select(2,LocalToWorld(Vector(),Angle(0,self.DownedRotate,0),Vector(),self.DownedAng)))
		self.phys:AddAngleVelocity(-self.phys:GetAngleVelocity())
		self.phys:SetVelocity(vel)
		if self.DownState and vel.z<-200 then self.phys:AddVelocity(Vector(0,0,9.8)) end
	end
	
	self.LastUpdate = CurTime()
end

function ENT:ApplyAngles()
	local time = CurTime()-self.LastUpdate
	local ang = self:GetAngles()
	local absvel = self.phys:GetVelocity()
	local vel = WorldToLocal(absvel,Angle(),Vector(),Angle(0,ang.y,0))
	local speed = vel:Length2D()
	
	ang.p = math.Clamp(vel.x/2000*30,-30,30)*(speed==0 and 1 or math.abs(vel.x)/speed)
	ang.y = ang.y+self.RotateVelocity*time
	ang.r = math.Clamp(-vel.y/2000*30,-30,30)*(speed==0 and 1 or math.abs(vel.y)/speed)
	
	self.phys:SetAngles(ang)
	self.phys:AddAngleVelocity(-self.phys:GetAngleVelocity())
	self.phys:SetVelocity(absvel)
end

function ENT:ApplyHeight(height)
	height = height or self:CheckWorldHeight()
	
	if (not height or height=="stop") and IsValid(self:GetTarget()) then
		local d = self:GetPos().z-self:GetTargetPos().z
		
		height = d<(self.StayInAir and 250 or 300) and "up" or d>(self.StayInAir and 1000 or 950) and height~="stop" and "down" or false
	end
	
	local vel = self.phys:GetVelocity()
	local time = CurTime()-self.LastUpdate
	local max = 400
	
	if height and height~="stop" then
		self.StayInAir = false
	
		if height=="up" then
			if vel.z<max then
				vel.z = math.min(vel.z+200*time,max)
			end
		else
			if vel.z>-max then
				vel.z = math.max(vel.z-200*time,-max)
			end
		end
	elseif math.Round(vel.z)~=0 and not self.StayInAir then
		if vel.z>0 then
			vel.z = math.max(vel.z-200*vel.z/30*time,0)
		else
			vel.z = math.min(vel.z+200*-vel.z/30*time,0)
		end
	elseif math.Round(vel.x)==0 and math.Round(vel.y)==0 and (math.Round(vel.z)==0 or self.StayInAir) then
		self.StayInAir = true
		
		local dir = math.floor(CurTime()/2)==math.Round(CurTime()/2) and 1 or -1
		vel.z = 25*dir
	else
		self.StayInAir = false
	end
	
	self.phys:SetVelocity(vel)
end

function ENT:StopRotating()
	local time = CurTime()-self.LastUpdate
	local vel = self.RotateVelocity
	self.RotateVelocity = math.Clamp(vel>0 and math.max(vel-90*time,0) or math.min(vel+90*time,0),-60,60)
end

function ENT:RotateToTarget(pos)
	if not pos then
		self:StopRotating()
		return 
	end
	local time = CurTime()-self.LastUpdate
	local vel = self.RotateVelocity
	local _,ang = WorldToLocal(Vector(),(pos-Vector(self:GetPos().x,self:GetPos().y,pos.z)):Angle(),Vector(),Angle(0,self:GetAngles().y,0))
	local side = ang.y>0 and 1 or -1
	
	local mv = WorldToLocal(self.phys:GetVelocity(),Angle(),Vector(),(pos-Vector(self:GetPos().x,self:GetPos().y,pos.z)):Angle())
	local spd = mv:Length2D()
	
	if math.abs(ang.y)>(spd>1000 and (spd==0 and 1 or math.abs(mv.x/mv.y)>3) and 10 or 10) then
		if math.abs(vel)<60 then
			self.RotateVelocity = math.Clamp(self.RotateVelocity+90*side*time,-60,60)
		end
	elseif math.abs(vel)>0 then
		self:StopRotating()
	end
end

function ENT:RotateAround(pos)
	if not pos then return end
	local time = CurTime()-self.LastUpdate
	local ang = (Vector(pos.x,pos.y,self:GetPos().z)-self:GetPos()):Angle()
	local vel1 = WorldToLocal(self.phys:GetVelocity(),Angle(),Vector(),ang)
	self:SlowDown(pos)
	local vel2 = WorldToLocal(self.phys:GetVelocity(),Angle(),Vector(),ang)
	
	local dist = self:DistIgnoreZ(pos) or 0
	local spd = math.min(100/750*dist,300)
	
	if vel1.y>spd or dist<50 then return end
	
	local vel = Vector(math.max(math.abs(vel2.x),dist>50 and 20 or 0)*(vel2.x~=0 and vel2.x/math.abs(vel2.x) or 1),vel1.y>spd and vel1.y or spd,vel2.z)
	vel = LocalToWorld(vel,Angle(),Vector(),ang)
	self.phys:SetVelocity(vel)

	if uvJammerDeployed then
		self.RotateVelocity = -45
	end
end

function ENT:FlyTo(pos)
	local time = CurTime()-self.LastUpdate
	local dist = self:DistIgnoreZ(pos)
	local vel = WorldToLocal(self.phys:GetVelocity(),Angle(),Vector(),(Vector(pos.x,pos.y,self:GetPos().z)-self:GetPos()):Angle())
	
	vel.x = math.min(5000,vel.x+(dist-100)/1*time)
	vel.y = math.min(5000,vel.y-vel.y/1*time)
	
	vel = LocalToWorld(vel,Angle(),Vector(),(Vector(pos.x,pos.y,self:GetPos().z)-self:GetPos()):Angle())
	self.phys:SetVelocity(vel)
end

function ENT:SlowDown(pos)
	pos = pos or self:GetPos()+self.phys:GetVelocity():GetNormalized()
	
	local time = CurTime()-self.LastUpdate
	local vel = WorldToLocal(self.phys:GetVelocity(),Angle(),Vector(),(Vector(pos.x,pos.y,self:GetPos().z)-self:GetPos()):Angle())
	
	vel.x = vel.x>0 and math.max(vel.x-1000*time,0) or math.min(vel.x+1000*time,0)
	vel.y = vel.y>0 and math.max(vel.y-1000*time,0) or math.min(vel.y+1000*time,0)
	
	vel = LocalToWorld(vel,Angle(),Vector(),(Vector(pos.x,pos.y,self:GetPos().z)-self:GetPos()):Angle())
	self.phys:SetVelocity(vel)
end

function ENT:DistIgnoreZ(pos)
	if IsValid(self:GetTarget()) then
	return self:GetPos():Distance(Vector(pos.x,pos.y,self:GetPos().z))
	end
end

function ENT:CheckWorldHeight()

	if self.engaging and IsValid(self:GetTarget()) then
		local d = self:GetPos().z-(self:GetTargetPos()).z
		local velocityz = (self.phys:GetVelocity().z * -1)
		if velocityz<d then
			return "down"
		elseif d>0 then
			return "stop"
		else
			self.engaging = nil
			return "up"
		end
	end

	local floor = util.TraceLine({start = self:GetPos(),endpos = self:GetPos()-Vector(0,0,self.StayInAir and 1000 or 950),filter = self,mask = MASK_ALL})
	if floor.Hit then
		if self:GetPos().z-floor.HitPos.z>(self.StayInAir and 250 or 300) then
			return "stop"
		else
			return "up"
		end
	end
	
	if util.TraceLine({start = self:GetPos(),endpos = self:GetPos(),mask = MASK_NPCWORLDSTATIC}).StartSolid then
		if util.TraceLine({start = self:GetPos(),endpos = self:GetPos()+Vector(0,0,48000),mask = MASK_NPCWORLDSTATIC}).Hit then
			return "up"
		elseif util.TraceLine({start = self:GetPos(),endpos = self:GetPos()-Vector(0,0,48000),mask = MASK_NPCWORLDSTATIC}).Hit then
			return "down"
		end
	else
		local tr = util.TraceLine({start = self:GetPos(),endpos = self:GetPos()+Vector(0,0,48000),mask = MASK_NPCWORLDSTATIC})
		if tr.Hit then
			local tr = util.TraceLine({start = tr.HitPos,endpos = self:GetPos(),mask = MASK_NPCWORLDSTATIC})
			if tr.HitTexture=="**displacement**" then
				return "up"
			end
		end
	end
	
	return false
end

function ENT:IsSeeTarget()
	if not util.IsInWorld(self:WorldSpaceCenter()) then return end
	local tr = util.TraceLine({start = self:WorldSpaceCenter(), endpos = self:GetTarget():WorldSpaceCenter(), mask = MASK_OPAQUE, filter = {self, self:GetTarget()}}).Fraction==1
	if UVHiding then
		return tobool(tr) and self:DistIgnoreZ(self:GetTargetPos()) <= 2000
	else
		return tobool(tr) and self:DistIgnoreZ(self:GetTargetPos()) <= 10000
	end
end

function ENT:OnTakeDamage(dmg)
	if GetConVar("unitvehicle_canwreck"):GetBool() and not self.Downed then
		self:SetHealth(self:Health()-dmg:GetDamage())
	end
end

function ENT:StartCrush()
	self.Downed = true
	
	local r = self:GetAngles().r
	r = r>0 and math.max(r,30) or math.min(r,-30)
	
	self.DownedAng = Angle(self:GetAngles().p,self:GetAngles().y,r)
	self.DownedRotate = 0
	
	self.phys:SetAngles(self.DownedAng)
	self.phys:AddVelocity(LocalToWorld(Vector(0,-r*5,0),Angle(),Vector(),Angle(0,self:GetAngles().y,0)))
	
	self.DownTime = CurTime()
	self.DownState = false
	
	if not self.crashing then
		if not timer.Exists("uvcombotime") then
			timer.Create("uvcombotime", 5, 1, function() 
				UVComboBounty = 1 
				timer.Remove("uvcombotime")
			end)
		else
			timer.Remove("uvcombotime")
			timer.Create("uvcombotime", 5, 1, function() 
				if next(ents.FindByClass("npc_uv*")) ~= nil and Chatter:GetBool() and not (self.crashing or self.disengaging) and UVComboBounty >= 3 then
					local units = ents.FindByClass("npc_uv*")
					local random_entry = math.random(#units)	
					local unit = units[random_entry]
					UVChatterMultipleUnitsDown(unit)
				end
				UVComboBounty = 1
				timer.Remove("uvcombotime")
			end)
		end
		local eff = EffectData()
		eff:SetOrigin(self:GetPos())
		util.Effect("Explosion",eff)
		util.BlastDamage(self,self,self:GetPos(),1000,10)
		if Chatter:GetBool() and IsValid(self) then
			UVChatterAirWreck(self)
		end
		local bountyplus = (UVUBountyAir:GetInt())*(UVComboBounty)
		local bounty = string.Comma(bountyplus)
		if self:GetTarget():IsVehicle() then if self:GetTarget():GetDriver():IsPlayer() then 
			-- self:GetTarget():GetDriver():PrintMessage( HUD_PRINTCENTER, "Air Support Helicopter ☠ Combo Bounty x"..UVComboBounty..": "..bounty)
			UVNotifyCenter({self:GetTarget():GetDriver()}, "uv.hud.combo", "UNITS_DISABLED", "uv.unit.helicopter", '', bountyplus, UVComboBounty)
		end end
		UVWrecks = UVWrecks + 1
		self.crashing = true
		self:EmitSound( "npc/attack_helicopter/aheli_damaged_alarm1.wav" )
		self:EmitSound( "npc/combine_gunship/gunship_crashing1.wav" )
		UVBounty = (UVBounty+bountyplus)
		UVComboBounty = UVComboBounty + 1
	end
	
end

function ENT:Explode()
	local effect = EffectData()
	effect:SetOrigin(self:GetPos())
	effect:SetScale(2)
	util.Effect("Explosion",effect)
	util.BlastDamage(self,self,self:GetPos(),1000,50)
	self:Remove()
	local wreck = ents.Create("prop_physics")
	wreck:SetModel(self:GetModel())
	wreck:SetPos(self:GetPos())
	wreck:SetAngles(self.phys:GetAngles())
	for k,v in pairs(wreck:GetBodyGroups()) do
		wreck:SetBodygroup(k, wreck:GetBodygroup(k)+1)
	end
	wreck:SetSkin(self:GetSkin())
	for k, v in pairs(self:GetMaterials()) do
		wreck:SetSubMaterial( k, self:GetSubMaterial( k ) )
	end
	wreck:Spawn()
	wreck:GetPhysicsObject():EnableMotion(true)
	ParticleEffectAttach("smoke_burning_engine_01", PATTACH_ABSORIGIN_FOLLOW, wreck, 0)
	wreck:Ignite(30)
	local phwreck = wreck:GetPhysicsObject()
	phwreck:SetVelocity(self.phys:GetVelocity())
	phwreck:SetMass(self.phys:GetMass())
	phwreck:AddAngleVelocity(self.phys:GetAngleVelocity())
	local e = EffectData()
	e:SetEntity(wreck)
	util.Effect("entity_remove", e)
	timer.Simple(60, function() if IsValid(wreck) then wreck:Remove() end end)
	timer.Simple(math.random(1,3), function()
		if next(ents.FindByClass("npc_uv*")) ~= nil and Chatter:GetBool() and not (self.crashing or self.disengaging) then
			local units = ents.FindByClass("npc_uv*")
			local random_entry = math.random(#units)	
			local unit = units[random_entry]
			if unit == self then return end
			UVChatterAirDown(unit)
		end
	end)
	if not self.crashing then
		if not timer.Exists("uvcombotime") then
			timer.Create("uvcombotime", 5, 1, function() 
				UVComboBounty = 1 
				timer.Remove("uvcombotime")
			end)
		else
			timer.Remove("uvcombotime")
			timer.Create("uvcombotime", 5, 1, function() 
				if next(ents.FindByClass("npc_uv*")) ~= nil and Chatter:GetBool() and not (self.crashing or self.disengaging) and UVComboBounty >= 3 then
					local units = ents.FindByClass("npc_uv*")
					local random_entry = math.random(#units)	
					local unit = units[random_entry]
					UVChatterMultipleUnitsDown(unit)
				end
				UVComboBounty = 1
				timer.Remove("uvcombotime")
			end)
		end
		if Chatter:GetBool() and not (self.crashing or self.disengaging) and IsValid(self) then
			UVChatterAirOnRemove(self)
		end
		local bountyplus = (UVUBountyAir:GetInt())*(UVComboBounty)
		local bounty = string.Comma(bountyplus)
		if self:GetTarget():IsVehicle() then if self:GetTarget():GetDriver():IsPlayer() then 
			--self:GetTarget():GetDriver():PrintMessage( HUD_PRINTCENTER, "Air Support Helicopter ☠ Combo Bounty x"..UVComboBounty..": "..bounty)
			UVNotifyCenter({self:GetTarget():GetDriver()}, "uv.hud.combo", "UNITS_DISABLED", "uv.unit.helicopter", ' ', bountyplus, UVComboBounty)
		end end
		UVWrecks = UVWrecks + 1
		self.crashing = true
		UVBounty = (UVBounty+bountyplus)
		UVComboBounty = UVComboBounty + 1
	end
end

function ENT:StartTouch(prop)
	if self.damagecooldown or self.engaging or self.crashing or self.disengaging then return end

	self.damagecooldown = true

	timer.Simple(1, function() self.damagecooldown = nil end)

	if prop:GetClass() == "prop_physics" or prop:IsVehicle() then
		if not self.damaged then
			self.damaged = true
			self:SetHealth(self:Health()/2)
			ParticleEffectAttach("smoke_burning_engine_01", PATTACH_ABSORIGIN_FOLLOW, self, 0)
			if Chatter:GetBool() and not ChatterText:GetBool() then
				UVSoundChatter(self, self.voice, "airhit")
			end
		else
			MathCrash = math.random(1,2)
			if MathCrash == 1 then
				self:StartCrush()
			else
				self:Explode()
			end
		end
	end

end

local function check(ent1,ent2)
	if (ent1:GetClass()=="uvair" or ent1.Base=="uvair") and not ent1.Downed and (ent2==game.GetWorld() or (ent2:GetClass() ~= "prop_physics" and not ent2:IsVehicle())) then
		return false
	end
end

hook.Add("ShouldCollide","uvair",function(ent1,ent2)
	local ret = check(ent1,ent2)==false or check(ent2,ent1)==false
	if ret then return false end
end)