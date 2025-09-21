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
	net.WriteInt(self.Entity:GetCreationID(), 32)
	net.WriteString("repairshop")
	net.Broadcast()
end

function ENT:Think()
	local vehicles = ents.FindInSphere(self.Entity:WorldSpaceCenter(), RepairRange:GetInt())
	for k, v in pairs(vehicles) do
		if not v.uvrepairdelayed and 
		not v.wrecked and 
		(v:GetClass() == "prop_vehicle_jeep" or v.IsSimfphyscar or v.IsGlideVehicle)
		then
		-- and not table.HasValue(UVCommanders, v) then
			UVRepair(v)
		end
	end
end