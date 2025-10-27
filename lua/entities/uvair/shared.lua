ENT.Type = "anim"
ENT.PrintName = "#uv.unit.helicopter"
ENT.Author = "Cross"
ENT.Purpose = "To ensure that dirtbags gets fucked by the long arm of the law."
ENT.Category = "#uv.settings.unitvehicles"
ENT.Spawnable = true
ENT.AdminOnly = false

function ENT:SetupDataTables()
	self:NetworkVar("Entity",0,"Target")
	self:NetworkVar("Vector",0,"TarPos")
	self:NetworkVar("Bool",0,"TarMode")
end

function ENT:GetTargetPos()
	local suspect = self:GetTarget() or self.potentialtarget
	if IsValid(suspect) then 
		return suspect:GetPos() 
	else
		return self:GetPos()
	end
end