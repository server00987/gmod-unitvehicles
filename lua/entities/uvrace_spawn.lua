AddCSLuaFile()

ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.Model = "models/unitvehiclesprops/uvarrow/uvarrow2.mdl"

function ENT:SetupDataTables()
	self:NetworkVar("Vector", 0, "MaxPos")
	self:NetworkVar("Int", 0, "GridSlot", {KeyName = "UVRace_GridSlot", Edit = {type = "Generic", order = 1}})
end

if SERVER then
	function ENT:Initialize()
		self:SetSolid(SOLID_NONE)
		self:SetModel(self.Model)
		self:DrawShadow(false)
		
		local spawns = self:GetGridSlot() > 0 or ents.FindByClass("uvrace_spawn")
		if istable(spawns) then
			self:SetGridSlot(#spawns)
		end

	end
end

if CLIENT then
	function ENT:Draw()
		if !IsValid(LocalPlayer():GetActiveWeapon()) or LocalPlayer():GetActiveWeapon():GetClass() != "gmod_tool" or UVHUDRace then return end

		self:DrawModel()

		local id = self:GetGridSlot() or 0
		local pos = self:GetPos()

		cam.Start2D()

			local point = pos + self:OBBCenter()
			local data2D = point:ToScreen()
			
			draw.SimpleText( id, "UVFont4", data2D.x, data2D.y, Color( 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		cam.End2D()
	end
end