
if not WireLib then return end
AddCSLuaFile()
DEFINE_BASECLASS "base_wire_entity"

---@class ENT.UVWireManager : Structure.ENT, Entity, ENTITY
---@field BaseClass ENTITY
---@field Inputs table
---@field Outputs table
---@field SetOverlayText fun(self: ENT.UVWireManager, value: string)
local ENT = ENT

ENT.WireDebugName = "[UV] Waypoint Manager"
ENT.PrintName = "[UV] Waypoint Manager"
ENT.Author = "Author"
ENT.IsUVWireManager = true

local uvws = UnitVehiclesWaypointsSystem
function ENT:OnRemove()
    uvws.WireManagers[self] = nil
end

if CLIENT then
    function ENT:Initialize()
        uvws.WireManagers[self] = true
    end

    return
end

local IOList = {
    "Group #",
    "Speed limit",
    "Use turn lights",
}
function ENT:Initialize()
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:DrawShadow(false)
    self:SetNWInt("WaypointID", -1)
    self.Inputs = Wire_CreateInputs(self, IOList)
    self.Outputs = Wire_CreateOutputs(self, IOList)
    uvws.WireManagers[self] = true
end

function ENT:LinkEnt(e)
    if not isnumber(e) then return false end
    local w = uvws.Waypoints[e]
    if not w then return false end
    self:SetNWInt("WaypointID", e)
    self.waypointid = e
    self:ShowOutput()
    return true
end

function ENT:UnlinkEnt()
    self:SetNWInt("WaypointID", -1)
    self.waypointid = nil
    self:ShowOutput()
end

function ENT:Setup(waypointid)
    self:ShowOutput()
    if not isnumber(waypointid) then return end
    self.waypointid = waypointid
    self:SetNWInt("WaypointID", waypointid)
end

function ENT:OnRestore()
    self.BaseClass.OnRestore(self)
    self:SetNWInt("WaypointID", self.waypointid)
    self:ShowOutput()
end

function ENT:TriggerInput(iname, value)
    local id = self:GetNWInt "WaypointID"
    if not isnumber(id) or id < 0 then return end
    local w = uvws.Waypoints[id]
    if not w then return end
    if iname == "Group #" then
        w.Group = math.floor(value)
    elseif iname == "Speed limit" then
        w.SpeedLimit = value * uvws.KphToHUps
    else
        return
    end

    self:ShowOutput()
    if player.GetCount() == 0 then return end
    net.Start "Unit Vehicles: Send waypoint info"
    net.WriteUInt(id, 24)
    net.WriteUInt(w.Group, 16)
    net.WriteFloat(w.SpeedLimit)
    net.Broadcast()
end

local Output = [[Linked to: #%d
Group = %d
Speed limit = %.2f km/s
Use turn lights = %s]]
function ENT:ShowOutput()
    local i = self:GetNWInt "WaypointID"
    if not isnumber(i) or i < 0 then
        self:SetOverlayText "Not linked yet"
        return
    end

    local w = uvws.Waypoints[i]
    if not w then
        self:SetOverlayText "Linked to an invalid waypoint"
        return
    end

    self:SetOverlayText(Output:format(i, w.Group, w.SpeedLimit / uvws.KphToHUps))
    Wire_TriggerOutput(self, "Group #", w.Group)
    Wire_TriggerOutput(self, "Speed limit", w.SpeedLimit / uvws.KphToHUps)
end

duplicator.RegisterEntityClass("gmod_wire_uvmanager", WireLib.MakeWireEnt, "Data", "waypointid")

