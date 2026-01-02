
AddCSLuaFile()

---@class TOOL.UVRoute : Structure.TOOL, TOOL
local TOOL = TOOL
local uvws = UnitVehiclesWaypointsSystem
local texts = uvws.Texts.Tools

TOOL.IsUnitVehiclesTool = true
TOOL.Category = texts.Category
TOOL.Name = texts.Name
TOOL.Information = {
    {name = "info", stage = 0},
    {name = "left", stage = 0},
    {name = "left_1", stage = 1},
    {name = "right"},
}

TOOL.WaypointID = -1
TOOL.ClientConVar["bidirectional"] = 0
TOOL.ClientConVar["drawdistance"] = 6000
TOOL.ClientConVar["group"] = 0
TOOL.ClientConVar["shouldblink"] = 0
TOOL.ClientConVar["showalways"] = 0
TOOL.ClientConVar["showpoints"] = 1
TOOL.ClientConVar["speed"] = 40
TOOL.ClientConVar["updateradius"] = 100

if CLIENT then
    language.Add("tool.uv_route.name", texts.PrintName)
    language.Add("tool.uv_route.desc", texts.Description)
    language.Add("tool.uv_route.0", texts.Instructions)
    language.Add("tool.uv_route.left", texts.Left[1])
    language.Add("tool.uv_route.left_1", texts.Left[2])
    language.Add("tool.uv_route.right", texts.Right[1])
end

function TOOL:LeftClick(trace)
    if CLIENT then return true end
    local bidirectional = self:GetClientNumber "bidirectional" > 0
    local group = self:GetClientNumber "group"
    local shouldblink = self:GetClientNumber "shouldblink" > 0
    local speed = self:GetClientNumber "speed"
    local pos = trace.HitPos
    local waypoint, waypointID = uvws.GetNearestWaypoint(pos, uvws.WaypointSize)
    local ent = trace.Entity
    if IsValid(ent) and ent.UnitVehicles then
        ent.UnitVehicles.Group = group
        return true
    end

    if not waypoint then
        local oldpointID = self.WaypointID
        local newpoint = uvws.AddWaypoint(pos)
        self.WaypointID = #uvws.Waypoints
        newpoint.Owner = self:GetOwner()
        newpoint.Time = CurTime()
        newpoint.SpeedLimit = speed * uvws.KphToHUps
        newpoint.Group = group
        if uvws.Waypoints[oldpointID] then
            uvws.AddNeighbor(oldpointID, self.WaypointID)
            if bidirectional then
                uvws.AddNeighbor(self.WaypointID, oldpointID)
            end
        end

        undo.Create "Unit Vehicles Waypoint"
        undo.SetCustomUndoText(uvws.Texts.UndoText)
        undo.AddFunction(uvws.UndoWaypoint)
        undo.SetPlayer(self:GetOwner())
        undo.Finish()
    elseif self:GetStage() == 0 or not (uvws.Waypoints[self.WaypointID]) then
        self.WaypointID = waypointID
        self:SetStage(1)
        return true
    elseif self.WaypointID ~= waypointID then

        if self.WaypointID > -1 then
            if table.HasValue(uvws.Waypoints[self.WaypointID].Neighbors, waypointID) then
                uvws.RemoveNeighbor(self.WaypointID, waypointID)
                if bidirectional then
                    uvws.RemoveNeighbor(waypointID, self.WaypointID)
                end
            else
                uvws.AddNeighbor(self.WaypointID, waypointID)
                if bidirectional then
                    uvws.AddNeighbor(waypointID, self.WaypointID)
                end
            end
        end

        self.WaypointID = -1
    elseif self.WaypointID > -1 then
        uvws.RemoveWaypoint(self.WaypointID)
        self.WaypointID = -1
        local removed = false
        for id, undolist in pairs(undo.GetTable()) do
            for i, undotable in pairs(undolist) do
                if undotable.Name ~= "Unit Vehicles Waypoint" then continue end
                if undotable.Owner ~= self:GetOwner() then continue end
                undolist[i] = nil
                removed = true
                break
            end

            if removed then break end
        end
    end

    self:SetStage(0)
    return true
end

function TOOL:RightClick(trace)
    local group = self:GetClientNumber "group"
    local shouldblink = self:GetClientNumber "shouldblink" > 0
    local speed = self:GetClientNumber "speed"
    local pos = trace.HitPos
    local waypoints = {}
    if self:GetOwner():KeyDown(IN_USE) then
        local RadiusSqr = self:GetClientNumber "updateradius"^2
        for i, w in ipairs(uvws.Waypoints) do
            if pos:DistToSqr(w.Target) > RadiusSqr then continue end
            table.insert(waypoints, i)
        end
    else
        waypoints = {select(2, uvws.GetNearestWaypoint(pos, uvws.WaypointSize))}
    end

    if #waypoints == 0 then return end
    for _, i in ipairs(waypoints) do
        local w = uvws.Waypoints[i]
        if not w then continue end
        w.SpeedLimit = speed * uvws.KphToHUps
        w.Group = group

        if SERVER and player.GetCount() > 0 then
            net.Start "Unit Vehicles: Send waypoint info"
            net.WriteUInt(i, 24)
            net.WriteUInt(w.Group, 16)
            net.WriteFloat(w.SpeedLimit)
            net.Broadcast()
        end
    end

    self:SetStage(0)
    return true
end

local ConVarsDefault = TOOL:BuildConVarList()
local ConVarsList = table.GetKeys(ConVarsDefault)
function TOOL.BuildCPanel(CPanel)
    local ControlPresets = vgui.Create("ControlPresets", CPanel)
    ControlPresets:SetPreset "unitvehicles"
    ControlPresets:AddOption("#preset.default", ConVarsDefault)
    for k, v in pairs(ConVarsList) do
        ControlPresets:AddConVar(v)
    end

    CPanel:AddItem(ControlPresets)

    CPanel:Help(texts.DescriptionInMenu)
    CPanel:CheckBox(texts.DrawWaypoints, "uv_route_showpoints")
    CPanel:CheckBox(texts.AlwaysDrawWaypoints, "uv_route_showalways")
    CPanel:CheckBox(texts.Bidirectional, "uv_route_bidirectional"):SetToolTip(texts.BidirectionalHelp)
    CPanel:NumSlider(texts.UpdateRadius, "uv_route_updateradius", 100, 400, 0):SetToolTip(texts.UpdateRadiusHelp)
    CPanel:NumSlider(texts.DrawDistance, "uv_route_drawdistance", 2000, 10000, 0):SetToolTip(texts.DrawDistanceHelp)
    CPanel:NumSlider(texts.WaypointGroup, "uv_route_group", 0, 20, 0):SetToolTip(texts.WaypointGroupHelp)
    CPanel:NumSlider(texts.MaxSpeed, "uv_route_speed", 5, 500, 0)

    if LocalPlayer():IsAdmin() then
        CPanel:Help ""
        local label = CPanel:Help(texts.ServerSettings)
        label:SetTextColor(CPanel:GetSkin().Colours.Tree.Hover)

        CPanel:AddItem(comboboxlabel, combobox)
        CPanel:Button(texts.Save, "uv_route_save")
        CPanel:Button(texts.Restore, "uv_route_load")
        CPanel:Button(texts.Delete, "uv_route_delete")
        CPanel:Button(texts.Generate, "uv_route_generate")
        hook.Run "Unit Vehicles: Sync CVar"
    end

    CPanel:InvalidateLayout()
end

if SERVER then return end
function TOOL:DrawHUD()
    if self:GetClientNumber "showpoints" == 0 then return end
    local pos = LocalPlayer():GetEyeTrace().HitPos
    local waypoint, waypointID = uvws.GetNearestWaypoint(pos, uvws.WaypointSize)
    if not waypoint then return end
    net.Start "Unit Vehicles: Send waypoint info"
    net.WriteUInt(waypointID, 24)
    net.SendToServer()

    if not waypoint.SpeedLimit then return end
    local textpos = pos:ToScreen()
    for _, text in ipairs {
        texts.ShowInfo.ID .. tostring(waypointID),
        texts.ShowInfo.Group .. tostring(waypoint.Group),
        texts.ShowInfo.SpeedLimit .. tostring(math.Round(waypoint.SpeedLimit / uvws.KphToHUps, 2)),
    } do
        textpos.y = textpos.y + select(2, draw.SimpleTextOutlined(
        text, "UVFont5", textpos.x, textpos.y, color_white,
        TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 2, color_black))
    end
end
