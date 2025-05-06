AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

local AutoHealth = GetConVar("unitvehicle_autohealth")
local RepairCooldown = GetConVar("unitvehicle_repaircooldown")
local RepairRange = GetConVar("unitvehicle_repairrange")
local AutoHealth = GetConVar("unitvehicle_autohealth")

function ENT:Initialize()
	self.Entity:SetModel("models/unitvehiclesprops/uvrepairstation/uvrepairstation.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Entity:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self.Entity:GetPhysicsObject():EnableMotion(false)
	net.Start("UVHUDAddUV")
	net.WriteInt(self.Entity:EntIndex(), 32)
	net.WriteString("repairshop")
	net.Broadcast()
end

function ENT:Think()
	local vehicles = ents.FindInSphere(self.Entity:WorldSpaceCenter(), RepairRange:GetInt())
	for k, v in pairs(vehicles) do
		if !IsValid(v) or 
		v.uvrepairdelayed or 
		v.wrecked or 
		(!v:GetClass() == "prop_vehicle_jeep" and !v.IsSimfphyscar and !v.IsGlideVehicle) then 
			continue 
		end
		self:Repair(v)
	end
end

function ENT:Repair(vehicle)
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

	if vehicle.uvrepaircooldown then
		UVRepairCooldown()
		return
	end

	local ptrefilled = false

	if vehicle.PursuitTech then
		for k, v in pairs(vehicle.PursuitTech) do
			local max_ammo = GetConVar('unitvehicle_'..((vehicle.UnitVehicle and 'unitpursuittech') or 'pursuittech')..'_maxammo_'..string.lower(string.gsub(v.Tech, " ", ""))):GetInt()
			if v.Ammo < max_ammo then
				if vehicle.uvrepaircooldown then
					UVRepairCooldown()
					return
				end
				ptrefilled = true
				v.Ammo = max_ammo
			end
		end
	end

	if vehicle:GetClass() == "prop_vehicle_jeep" then
		if vcmod_main then
			if !ptrefilled and vehicle:VC_getHealthMax() == vehicle:VC_getHealth() then return end

			-- if vehicle.uvrepaircooldown then
			-- 	UVRepairCooldown()
			-- 	return
			-- end

			vehicle:VC_repairFull_Admin()
		else
			if !ptrefilled and vehicle:GetMaxHealth() == vehicle:Health() then return end

			-- if vehicle.uvrepaircooldown then
			-- 	UVRepairCooldown()
			-- 	return
			-- end

			local mass = vehicle:GetPhysicsObject():GetMass()
			vehicle:SetMaxHealth(mass)
			vehicle:SetHealth(mass)
			vehicle:StopParticles()
		end
	end
	if vehicle.IsSimfphyscar then	
		-- if vehicle.uvrepaircooldown then
		-- 	UVRepairCooldown()
		-- 	return
		-- end

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

		if !ptrefilled and !repaired_tires and vehicle:GetCurHealth() == vehicle:GetMaxHealth() then return end

		vehicle.simfphysoldhealth = vehicle:GetMaxHealth()
		vehicle:SetCurHealth(vehicle:GetMaxHealth())
		vehicle:SetOnFire( false )
		vehicle:SetOnSmoke( false )

		net.Start( "simfphys_lightsfixall" )
			net.WriteEntity( vehicle )
		net.Broadcast()

		net.Start( "uvrepairsimfphys" )
			net.WriteEntity( vehicle )
		net.Broadcast()
		
		vehicle:OnRepaired()
				
		-- if istable(vehicle.Wheels) then
		-- 	for i = 1, table.Count( vehicle.Wheels ) do
		-- 		local Wheel = vehicle.Wheels[ i ]
		-- 		if IsValid(Wheel) then
		-- 			Wheel:SetDamaged( false )
		-- 		end
		-- 	end
		-- end
	end
	if vehicle.IsGlideVehicle then
		-- if vehicle.uvrepaircooldown then
		-- 	UVRepairCooldown()
		-- 	return
		-- end

		local repaired = false

		for _, v in pairs(vehicle.wheels) do
			if IsValid(v) and v.bursted then
				repaired = true
				v:_restore()
			end
		end

		if !ptrefilled and !repaired and vehicle:GetChassisHealth() >= vehicle.MaxChassisHealth then return end
		vehicle:Repair()
	end

	if UVGetDriver(vehicle) then
		if UVGetDriver(vehicle):IsPlayer() then
			if UVGetDriver(vehicle):GetMaxHealth() == 100 then
				UVGetDriver(vehicle):SetHealth(vehicle:GetPhysicsObject():GetMass())
				UVGetDriver(vehicle):SetMaxHealth(vehicle:GetPhysicsObject():GetMass())
			end
			net.Start("UVHUDRepair")
			net.Send(UVGetDriver(vehicle))
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