
include "autorun/uvws.lua"

local lPr = LocalPlayer()

local uvws = UnitVehiclesWaypointsSystem

net.Receive("Unit Vehicles: Add a waypoint", function()
    local pos = net.ReadVector()
    local chunk = net.ReadVector()
    local waypoint = {Target = pos, Neighbors = {}, Chunk = chunk}
    table.insert(uvws.Waypoints, waypoint)
end)

net.Receive("Unit Vehicles: Remove a waypoint", function()
    local id = net.ReadUInt(24)
    for _, w in ipairs(uvws.Waypoints) do
        local Neighbors = {}
        for _, n in ipairs(w.Neighbors) do
            if n > id then
                table.insert(Neighbors, n - 1)
            elseif n < id then
                table.insert(Neighbors, n)
            end
        end

        w.Neighbors = Neighbors
    end

    table.remove(uvws.Waypoints, id)
end)

net.Receive("Unit Vehicles: Add a neighbor", function()
    local from = net.ReadUInt(24)
    local to = net.ReadUInt(24)
    if not uvws.Waypoints[from] then return end
    table.insert(uvws.Waypoints[from].Neighbors, to)
end)

net.Receive("Unit Vehicles: Remove a neighbor", function()
    local from = net.ReadUInt(24)
    local to = net.ReadUInt(24)
    if not uvws.Waypoints[from] then return end
    table.RemoveByValue(uvws.Waypoints[from].Neighbors, to)
end)

local PopupTexts = {
    uvws.Texts.OnSave,
    uvws.Texts.OnLoad,
    uvws.Texts.OnDelete,
    uvws.Texts.OnGenerate,
}
local Notifications = {
    uvws.Texts.SavedWaypoints,
    uvws.Texts.LoadedWaypoints,
    uvws.Texts.DeletedWaypoints,
    uvws.Texts.GeneratedWaypoints,
}
net.Receive("Unit Vehicles: Save and restore", function()
    local save = net.ReadUInt(uvws.POPUPWINDOW.BITS)
    local Confirm = vgui.Create "DFrame"
    local Text = Label(PopupTexts[save + 1], Confirm)
    local Cancel = vgui.Create "DButton"
    local OK = vgui.Create "DButton"
    Confirm:Add(Cancel)
    Confirm:Add(OK)
    Confirm:SetSize(ScrW() / 5, ScrH() / 5)
    Confirm:SetTitle "Unit Vehicles"
    Confirm:SetBackgroundBlur(true)
    Confirm:ShowCloseButton(false)
    Confirm:Center()
    Cancel:SetText(uvws.Texts.SaveLoad_Cancel)
    Cancel:SetSize(Confirm:GetWide() * 5 / 16, 22)
    Cancel:SetPos(Confirm:GetWide() * 7 / 8 - Cancel:GetWide(), Confirm:GetTall() - 22 - Cancel:GetTall())
    OK:SetText(uvws.Texts.SaveLoad_OK)
    OK:SetSize(Confirm:GetWide() * 5 / 16, 22)
    OK:SetPos(Confirm:GetWide() / 8, Confirm:GetTall() - 22 - OK:GetTall())
    Text:SizeToContents()
    Text:Center()
    Confirm:MakePopup()

    function Cancel:DoClick() Confirm:Close() end
    function OK:DoClick()
        net.Start "Unit Vehicles: Save and restore"
        net.WriteUInt(save, uvws.POPUPWINDOW.BITS)
        net.SendToServer()
        notification.AddLegacy(Notifications[save + 1], NOTIFY_GENERIC, 5)

        Confirm:Close()
    end
end)

hook.Add("PostCleanupMap", "Unit Vehicles: Clean up waypoints", function()
    table.Empty(uvws.Waypoints)
end)

hook.Add("InitPostEntity", "Unit Vehicles: Load waypoints", function()
    net.Start "Unit Vehicles: Retrive waypoints"
    net.WriteUInt(1, 24)
    net.SendToServer()
end)

local function compared_vectors(v1, v2)
    return v1[1] == v2[1] and v1[2] == v2[2] and v1[3] == v2[3]
end

net.Receive("Unit Vehicles: Retrive waypoints", function()
    local id = net.ReadUInt(24)
    if id < 1 then return end
    local pos = net.ReadVector()
    local chunk = net.ReadVector()
    local speedlimit = net.ReadFloat()
    local group = net.ReadInt(8)
    local num = net.ReadUInt(14)
    local neighbors = {}
    for i = 1, num do
        table.insert(neighbors, net.ReadUInt(24))
    end

    uvws.Waypoints[id] = {
        Target = pos,
        SpeedLimit = speedlimit,
        Group = group,
        Neighbors = neighbors,
        Time = CurTime(),
        Chunk = chunk,
    }

    net.Start "Unit Vehicles: Retrive waypoints"
    net.WriteUInt(id + 1, 24)
    net.SendToServer()
end)

net.Receive("Unit Vehicles: Send waypoint info", function()
    local id = net.ReadUInt(24)
    local waypoint = uvws.Waypoints[id]
    if not waypoint then return end
    waypoint.Group = net.ReadUInt(16)
    waypoint.SpeedLimit = net.ReadFloat()
    waypoint.Chunk = net.ReadVector()
end)

net.Receive("Unit Vehicles: Clear waypoints", function()
    table.Empty(uvws.Waypoints)
end)

net.Receive("Unit Vehicles: Sync CVar", function()
    hook.Run "Unit Vehicles: Sync CVar"
end)



local SelectedColor = Color(96, 192, 0)
local Height = vector_up * uvws.WaypointSize / 4
local WaypointMaterial = Material "unitvehicles/icons/MINIMAP_ICON_CIRCUIT.png"
local LinkMaterial = Material "cable/crystal_beam1"
local TrafficMaterial = Material "cable/redlaser"
local SelectRadiusMaterial = Material "cable/new_cable_lit"
local NumPolys = 192
local AngleStep = 360 / NumPolys
hook.Add("Think", "Unit Vehicles: Think", function()
    if not InfMap then return end
    if not UV_LocalPlayer then UV_LocalPlayer = LocalPlayer() end
    if not IsValid(UV_LocalPlayer) then return end

    for _, w in ipairs(uvws.Waypoints) do
        if w.Chunk and compared_vectors(w.Chunk, UV_LocalPlayer.CHUNK_OFFSET) then
            w.NotVisible = false
        else
            w.NotVisible = true
        end
    end
end)
hook.Add("PostDrawTranslucentRenderables", "Unit Vehicles: Draw waypoints",
function(bDrawingDepth, bDrawingSkybox)
    local weapon = LocalPlayer():GetActiveWeapon()
    if not IsValid(weapon) then return end
    if not isfunction(LocalPlayer().GetTool) then return end

    local always = GetConVar "uv_route_showalways"
    local showpoints = GetConVar "uv_route_showpoints"
    local drawdistance = GetConVar "uv_route_drawdistance"
    local distsqr = drawdistance and drawdistance:GetFloat()^2 or 1000^2
    local size = uvws.WaypointSize
    local TOOL = LocalPlayer():GetTool()
    local ToolEquipped = weapon:GetClass() == "gmod_tool" and TOOL and TOOL.IsUnitVehiclesTool
    local MultiEdit = ToolEquipped and LocalPlayer():KeyDown(IN_USE)
    local Trace = LocalPlayer():GetEyeTrace()
    local UpdateRadius = GetConVar "uv_route_updateradius"
    local Radius = UpdateRadius and UpdateRadius:GetInt() or 0
    local RadiusSqr = Radius^2
    if not (always:GetBool() or ToolEquipped) then return end

    if bDrawingSkybox or not (showpoints and showpoints:GetBool()) then return end
    if MultiEdit then
        render.SetMaterial(SelectRadiusMaterial)
        render.StartBeam(NumPolys + 1)
        local filter = player.GetAll()
        local BaseNormal = Trace.HitNormal:Dot(vector_up) > .7 and Trace.HitNormal or vector_up
        local TraceVector = BaseNormal * 32768
        local BaseAngle = BaseNormal:Angle()
        for i = 0, NumPolys do
            local pos = Vector(0, Radius, 0)
            pos:Rotate(Angle(0, 0, AngleStep * i))

            local start = LocalToWorld(pos, angle_zero, Trace.HitPos, BaseAngle)
            local tr = util.TraceLine {start = start, endpos = start + TraceVector, mask = MASK_SOLID_BRUSHONLY}
            tr = util.TraceLine {start = tr.HitPos, endpos = tr.HitPos - TraceVector, mask = MASK_SOLID, filter = filter}

            render.AddBeam(tr.HitPos + BaseNormal, 10, i, SelectedColor)
        end

        render.EndBeam()
    end

    for _, w in ipairs(uvws.Waypoints) do
        -- print(w.NotVisible)
        if w.NotVisible then continue end
        if w.Target:DistToSqr(EyePos()) > distsqr then continue end
        local visible = EyeAngles():Forward():Dot(w.Target - EyePos()) > 0
        if visible then
            local color = color_white
            if MultiEdit and Trace.HitPos:DistToSqr(w.Target) < RadiusSqr then
                color = SelectedColor
            end

            render.SetMaterial(WaypointMaterial)
            render.DrawSprite(w.Target + Height, size, size, color)
        end

        render.SetMaterial(LinkMaterial)
        for _, link in ipairs(w.Neighbors) do
            local n = uvws.Waypoints[link]
            if n and (visible or EyeAngles():Forward():Dot(n.Target - EyePos()) > 0) and n.NotVisible ~= true then
                local pos = n.Target
                local tex = w.Target:Distance(pos) / 100
                local texbase = 1 - CurTime() % 1
                render.DrawBeam(w.Target + Height, pos + Height, 20, texbase, texbase + tex, color_white)
            end
        end
    end

    render.SetMaterial(TrafficMaterial)
    for m in pairs(uvws.WireManagers) do
        local i = m:GetNWInt "WaypointID"
        if i < 0 then continue end
        local w = uvws.Waypoints[i]
        if not w or w.NotVisible then continue end
        local pos = w.Target + Height
        local tex = m:GetPos():Distance(pos) / 100
        render.DrawBeam(m:GetPos(), pos, 20, 0, tex, color_white)
    end
end)

hook.Run "Unit Vehicles: PostInitialize"
