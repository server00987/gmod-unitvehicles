ENT.Type = "anim"
ENT.PrintName = "4: Air"
ENT.Author = "Cross"
ENT.Purpose = "To ensure that dirtbags gets fucked by the long arm of the law."
ENT.Category = "Unit Vehicles"
ENT.Spawnable = true
ENT.AdminOnly = false

function ENT:SetupDataTables()
	self:NetworkVar("Entity",0,"Target")
	self:NetworkVar("Vector",0,"TarPos")
	self:NetworkVar("Bool",0,"TarMode")
end

function ENT:GetTargetPos()
	if IsValid(self:GetTarget()) then 
		return self:GetTarget():GetPos() 
	else
		return self:GetPos()
	end
end