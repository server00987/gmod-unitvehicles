
AddCSLuaFile()

---@class ENT.UVSave : Structure.ENT, Entity, ENTITY
local ENT = ENT
ENT.Type = "point"
local uvws = UnitVehiclesWaypointsSystem
function ENT:Initialize()
    if #ents.FindByClass(self.ClassName) > 1 then self:Remove() return end
    uvws.SaveEntity = self
end

if CLIENT then return end
function ENT:PreEntityCopy()
    duplicator.StoreEntityModifier(self, "Unit Vehicles: Save waypoints", uvws.GetSaveTable())
end
