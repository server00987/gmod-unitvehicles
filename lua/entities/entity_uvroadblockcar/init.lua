AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

local SpawnMainUnits = GetConVar("unitvehicle_spawnmainunits")

function ENT:Initialize()
	self.Entity:SetModel("models/unitvehiclesprops/uvarrow/uvarrow.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
end

function ENT:Think()
	
	if UVTargeting and not self.deployed then
		self:DeployRoadBlock()
	end
	
end

function ENT:DeployRoadBlock()
	self.deployed = true

	local pos = self.Entity:GetPos()
	local Angles = self.Entity:GetAngles()

	if SpawnMainUnits:GetBool() then
		if self.Entity.Disperse == true then
			UVAutoSpawn(nil, nil, nil, nil, nil, pos, Angles, true)
		else
			UVAutoSpawn(nil, nil, nil, nil, nil, pos, Angles)
		end
	end

	self.Entity:Remove()
end