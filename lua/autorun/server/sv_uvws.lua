
include "autorun/uvws.lua"

-- Waypoints are held in normal table.
-- They're found by brute-force search.

---@class uvws
local uvws = UnitVehiclesWaypointsSystem
if not uvws then return end

local Exceptions = {Target = true}
local HULLS = 10
local MAX_NODES = 1500
local NODE_VERSION_NUMBER = 37
local function ClearUndoList()
    for id, undolist in pairs(undo.GetTable()) do
        for i, undotable in pairs(undolist) do
            if undotable.Name ~= "Unit Vehicles Waypoint" then continue end
            undolist[i] = nil
        end
    end
end

---@param ply Player
---@param save integer
local function ConfirmSaveRestore(ply, save)
    if not (IsValid(ply) and ply:IsPlayer()) then return end
    net.Start "Unit Vehicles: Save and restore"
    net.WriteUInt(save, uvws.POPUPWINDOW.BITS)
    net.Send(ply)
end

local function WriteWaypoint(id)
    local waypoint = uvws.Waypoints[id]
    net.WriteUInt(id, 24)
    net.WriteVector(waypoint.Target)
    net.WriteVector(waypoint.Chunk or Vector(0,0,0))
    net.WriteFloat(waypoint.SpeedLimit)
    net.WriteInt(waypoint.Group, 8)
    net.WriteUInt(#waypoint.Neighbors, 14)
    for i, n in ipairs(waypoint.Neighbors) do
        net.WriteUInt(n, 24)
    end
end

---@param source uv.Save
local function OverwriteWaypoints(source)
    if source == uvws then return end
    ClearUndoList()
    table.Empty(uvws.Waypoints)

    if player.GetCount() > 0 then
        net.Start "Unit Vehicles: Sync CVar"
        net.Broadcast()
        net.Start "Unit Vehicles: Clear waypoints"
        net.Broadcast()
    end

    for i, w in ipairs(source) do
        local new = uvws.AddWaypoint(w.Target) ---@type table<string, any>
        for key, value in pairs(w --[[@as table<string, any>]]) do
            if Exceptions[key] then continue end
            new[key] = value
        end
    end

    hook.Run("Unit Vehicles: OnLoadWaypoints", source)

    if #uvws.Waypoints * player.GetCount() == 0 then return end
    net.Start "Unit Vehicles: Retrive waypoints"
    WriteWaypoint(1)
    net.Broadcast()
end

---@param path string
function UVLoadWaypoints(path)
    local pngpath = string.format("data/%s.png", path)
    local txtpath = string.format("data/%s.txt", path)
    local scriptpath = string.format("scripts/vehicles/%s.txt", path)
    local p ---@type string?
    if file.Exists(txtpath, "GAME") then
        p = txtpath
    elseif file.Exists(scriptpath, "GAME") then
        p = scriptpath
    elseif file.Exists(pngpath, "GAME") then -- Backward compatibility
        p = pngpath
    end

    if p then
        local t = util.JSONToTable(util.Decompress(file.Read(p, "GAME") or "") or "")
        ---@cast t uv.Save
        OverwriteWaypoints(t)
    end
end

---@return uv.ParsedNodeGraph?
local function ParseAIN()
    local path = string.format("maps/graphs/%s.ain", game.GetMap())
    local f = file.Open(path, "rb", "GAME")
    if not f then return end

    local node_version = f:ReadLong()
    local map_version = f:ReadLong()
    local numNodes = f:ReadLong()

    assert(node_version == NODE_VERSION_NUMBER, "Unit Vehicles: Unknown graph file.")
    assert(0 <= numNodes and numNodes <= MAX_NODES, "Unit Vehicles: Graph file has an unexpected amount of nodes")

    ---@type uv.ParsedNode[]
    local nodes = {}
    for _ = 1, numNodes do
        local x = f:ReadFloat()
        local y = f:ReadFloat()
        local z = f:ReadFloat()
        local yaw = f:ReadFloat()
        local v = Vector(x, y, z)
        local flOffsets = {} ---@type number[]
        for i = 1, HULLS do
            flOffsets[i] = f:ReadFloat()
        end

        local nodetype = f:ReadByte()
        local nodeinfo = f:ReadUShort()
        local zone = f:ReadShort()
        ---@class uv.ParsedNode
        local node = {
            pos = v,
            yaw = yaw,
            offset = flOffsets,
            type = nodetype,
            info = nodeinfo,
            zone = zone,
            neighbor = {},
            numneighbors = 0,
            link = {},
            numlinks = 0
        }

        table.insert(nodes, node)
    end

    local numLinks = f:ReadLong()
    local links = {} ---@type uv.ParsedNodeLink[]
    for _ = 1, numLinks do
        local link = {} ---@class uv.ParsedNodeLink
        local srcID = f:ReadShort()
        local destID = f:ReadShort()
        local nodesrc = assert(nodes[srcID + 1], "Unit Vehicles: Unknown source node")
        local nodedest = assert(nodes[destID + 1], "Unit Vehicles: Unknown destination node")
        table.insert(nodesrc. neighbor, nodedest)
        nodesrc.numneighbors = nodesrc.numneighbors + 1

        table.insert(nodesrc.link, link)
        nodesrc.numlinks = nodesrc.numlinks + 1
        link.src, link.srcID = nodesrc, srcID + 1

        table.insert(nodedest.neighbor, nodesrc)
        nodedest.numneighbors = nodedest.numneighbors + 1

        table.insert(nodedest.link, link)
        nodedest.numlinks = nodedest.numlinks + 1
        link.dest, link.destID = nodedest, destID + 1

        link.move = {} ---@type integer[]
        for i = 1, HULLS do
            link.move[i] = f:ReadByte()
        end

        table.insert(links, link)
    end

    local lookup = {} ---@type integer[]
    for i = 1, numNodes do
        table.insert(lookup, f:ReadLong())
    end

    f:Close()

    ---@class uv.ParsedNodeGraph
    local nodegraph = {
        node_version = node_version,
        map_version  = map_version,
        nodes        = nodes,
        links        = links,
        lookup       = lookup,
    }
    return nodegraph
end

---@param ply Player
local function GenerateWaypoints(ply)
    uvws.Nodegraph = uvws.Nodegraph or ParseAIN()
    ClearUndoList()
    table.Empty(uvws.Waypoints)
    if player.GetCount() > 0 then
        net.Start "Unit Vehicles: Clear waypoints"
        net.Broadcast()
    end

    local speed = ply:GetInfoNum("uv_route_speed", 45) * uvws.KphToHUps
    local time = CurTime()
    local map = {} ---@type integer[]
    for i, n in ipairs(uvws.Nodegraph.nodes) do
        if n.type ~= 2 then continue end
        ---@type uv.Waypoint
        local waypoint = {
            Group = 0,
            Neighbors = {}, ---@type integer[]
            Owner = ply,
            SpeedLimit = speed,
            Target = util.QuickTrace(n.pos + vector_up * uvws.WaypointSize, -vector_up * 32768).HitPos,
            Time = time,
        }
        table.insert(uvws.Waypoints, waypoint)

        map[i] = #uvws.Waypoints
    end

    for i, link in ipairs(uvws.Nodegraph.links) do
        if link.move[HULL_LARGE_CENTERED + 1] ~= 1 then continue end
        local d, s = map[link.destID], map[link.srcID]
        if uvws.Waypoints[d] and uvws.Waypoints[s] then
            table.insert(uvws.Waypoints[s].Neighbors, d)
            table.insert(uvws.Waypoints[d].Neighbors, s)
        end
    end

    if #uvws.Waypoints * player.GetCount() == 0 then return end
    net.Start "Unit Vehicles: Retrive waypoints"
    WriteWaypoint(1)
    net.Broadcast()
end

util.AddNetworkString "Unit Vehicles: Add a waypoint"
util.AddNetworkString "Unit Vehicles: Remove a waypoint"
util.AddNetworkString "Unit Vehicles: Add a neighbor"
util.AddNetworkString "Unit Vehicles: Remove a neighbor"
util.AddNetworkString "Unit Vehicles: Traffic light"
util.AddNetworkString "Unit Vehicles: Retrive waypoints"
util.AddNetworkString "Unit Vehicles: Send waypoint info"
util.AddNetworkString "Unit Vehicles: Clear waypoints"
util.AddNetworkString "Unit Vehicles: Save and restore"
util.AddNetworkString "Unit Vehicles: Change serverside value"
util.AddNetworkString "Unit Vehicles: Sync CVar"
concommand.Add("uv_route_save", function(ply) ConfirmSaveRestore(ply, uvws.POPUPWINDOW.SAVE) end)
concommand.Add("uv_route_load", function(ply) ConfirmSaveRestore(ply, uvws.POPUPWINDOW.LOAD) end)
concommand.Add("uv_route_delete", function(ply) ConfirmSaveRestore(ply, uvws.POPUPWINDOW.DELETE) end)
concommand.Add("uv_route_generate", function(ply) ConfirmSaveRestore(ply, uvws.POPUPWINDOW.GENERATE) end)

duplicator.RegisterEntityModifier("Unit Vehicles: Save waypoints", function(ply, ent, data)
    OverwriteWaypoints(data)
    uvws.SaveEntity = ent
end)

saverestore.AddSaveHook("Unit Vehicles", function(save)
    saverestore.WriteTable(uvws.GetSaveTable(), save)
end)

saverestore.AddRestoreHook("Unit Vehicles", function(restore)
    OverwriteWaypoints(saverestore.ReadTable(restore))
    for id, undolist in pairs(undo.GetTable()) do
        for i, undotable in pairs(undolist) do
            if undotable.Name ~= "Unit Vehicles Waypoint" then continue end
            undolist[i].Functions[1] = {uvws.UndoWaypoint, {}}
        end
    end
end)

hook.Add("PostCleanupMap", "Unit Vehicles: Clean up waypoints", function()
    uvws.Waypoints = {}
    ClearUndoList()
end)

hook.Add("InitPostEntity", "Unit Vehicles: Load waypoints", function()
    uvws.SaveEntity = ents.Create "env_uv_save"
    uvws.SaveEntity:Spawn()
    UVLoadWaypoints("unitvehicles/waypoints/" .. game.GetMap())
end)

net.Receive("Unit Vehicles: Retrive waypoints", function(_, ply)
    local id = net.ReadUInt(24)
    net.Start "Unit Vehicles: Retrive waypoints"
    if id > #uvws.Waypoints then
        net.WriteUInt(0, 24)
        net.Send(ply)
        return
    end

    WriteWaypoint(id)
    net.Send(ply)
end)

net.Receive("Unit Vehicles: Send waypoint info", function(_, ply)
    local id = net.ReadUInt(24)
    local waypoint = uvws.Waypoints[id]
    if not waypoint then return end
    net.Start "Unit Vehicles: Send waypoint info"
    net.WriteUInt(id, 24)
    net.WriteUInt(waypoint.Group, 16)
    net.WriteFloat(waypoint.SpeedLimit)
    net.WriteVector(waypoint.Chunk or Vector(0,0,0))
    net.Send(ply)
end)

net.Receive("Unit Vehicles: Save and restore", function(_, ply)
    if not ply:IsAdmin() then return end
    local save = net.ReadUInt(uvws.POPUPWINDOW.BITS)
    local dir = "unitvehicles/waypoints/"
    local path = dir .. game.GetMap()
    if save == uvws.POPUPWINDOW.SAVE then
        if not file.Exists(dir, "DATA") then file.CreateDir(dir) end
        file.Write(path .. ".txt", util.Compress(util.TableToJSON(uvws.GetSaveTable())))
    elseif save == uvws.POPUPWINDOW.LOAD then
        UVLoadWaypoints(path)
    elseif save == uvws.POPUPWINDOW.DELETE then
        file.Delete(path .. ".png")
        file.Delete(path .. ".txt")
    elseif save == uvws.POPUPWINDOW.GENERATE then
        GenerateWaypoints(ply)
    end
end)

net.Receive("Unit Vehicles: Change serverside value", function(_, ply)
    if not ply:IsAdmin() then return end
    local cvar = GetConVar(net.ReadString())
    if not cvar then return end
    cvar:SetString(net.ReadString())
end)

---Gets a table that contains all waypoints information.
---@return uv.Save save A table for saving waypoints.
function uvws.GetSaveTable()
    local save = {}
    for i, w in ipairs(uvws.Waypoints) do
        save[i] = table.Copy(w)
        save[i].TrafficLight = nil
        if IsValid(w.TrafficLight) and w.TrafficLight.IsDVTrafficLight then
            local index = w.TrafficLight:EntIndex()
            TrafficLights[index] = table.ForceInsert(TrafficLights[index], i)
        end
    end

    hook.Run("Unit Vehicles: OnSaveWaypoints", save)
    return save
end

---Creates a new waypoint at given position.
---The new ID is always #uvws.Waypoints.
---@param pos Vector The position of new waypoint.
---@return uv.Waypoint waypoint Created waypoint.
function uvws.AddWaypoint(pos)
    local waypoint = {Target = pos, Neighbors = {}}
    local chunk = nil
    if InfMap then
        pos, chunk = InfMap.localize_vector(pos)
    end
    table.insert(uvws.Waypoints, waypoint)
    if player.GetCount() > 0 then
        net.Start "Unit Vehicles: Add a waypoint"
        net.WriteVector(pos)
        if chunk then net.WriteVector(chunk) end
        net.Broadcast()
    end

    return waypoint
end

---Removes a waypoint by ID.
---@param id number|Vector An unsigned number to remove.
function uvws.RemoveWaypoint(id)
    if isvector(id) then ---@cast id Vector
        id = select(2, uvws.GetNearestWaypoint(id))
    end
    if not id then return end ---@cast id number
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
    for m in pairs(uvws.WireManagers) do
        if IsValid(m) and m:GetNWInt "WaypointID" ~= id then continue end
        m:UnlinkEnt()
        break
    end

    if player.GetCount() == 0 then return end
    net.Start "Unit Vehicles: Remove a waypoint"
    net.WriteUInt(id, 24)
    net.Broadcast()
end

---Undo function that removes the most recent waypoint.
---@param undoinfo Structure.Undo
function uvws.UndoWaypoint(undoinfo)
    for i, w in SortedPairsByMemberValue(uvws.Waypoints, "Time", true) do
        if undoinfo.Owner == w.Owner then
            uvws.RemoveWaypoint(i)
            return
        end
    end
end

---Adds a link between two waypoints.
---The link is one-way, one to another.
---@param from number The waypoint ID the link starts from.
---@param to   number The waypoint ID connected to.
function uvws.AddNeighbor(from, to)
    local w = uvws.Waypoints[from]
    if not w then return end
    table.insert(w.Neighbors, to)
    if player.GetCount() == 0 then return end
    net.Start "Unit Vehicles: Add a neighbor"
    net.WriteUInt(from, 24)
    net.WriteUInt(to, 24)
    net.Broadcast()
end

---Removes an existing link between two waypoints.
---Does nothing if the given link is not found.
---@param from number The waypoint ID the link starts from.
---@param to   number The waypoint ID connected to.
function uvws.RemoveNeighbor(from, to)
    local w = uvws.Waypoints[from]
    if not w then return end
    table.RemoveByValue(w.Neighbors, to)
    if player.GetCount() == 0 then return end
    net.Start "Unit Vehicles: Remove a neighbor"
    net.WriteUInt(from, 24)
    net.WriteUInt(to, 24)
    net.Broadcast()
end

---Checks if the given waypoint is available for the specified group.
---@param id    number The waypoint ID.
---@param group number Waypoint group to check.
---@return boolean
function uvws.WaypointAvailable(id, group)
    local waypoint = uvws.Waypoints[id]
    if not waypoint then return false end
    return waypoint.Group == 0 or waypoint.Group == group
end

---Gets a waypoint connected from the given randomly.
-- Argument:
---@param waypoint uv.Waypoint The given waypoint.
---@param filter   fun(wp: uv.Waypoint, n: integer): boolean? If specified, removes waypoints which make it return false.
---@return uv.Waypoint? waypoint The connected waypoint.
function uvws.GetRandomNeighbor(waypoint, filter)
    if not waypoint.Neighbors then return end

    local suggestion = {}
    for i, n in ipairs(waypoint.Neighbors) do
        local w = uvws.Waypoints[n]
        if not w then continue end
        if not (isfunction(filter) and filter(waypoint, n)) then continue end
        table.insert(suggestion, w)
    end

    return suggestion[math.random(#suggestion)]
end

---Retrives a table of waypoints that represents the route
---from start to one of the destination in endpos.
---Using A* pathfinding algorithm.
---@param start  number The beginning waypoint ID.
---@param endpos table<integer, true>  A table of destination waypoint IDs. {[ID] = true}
---@param group  number? Optional, specify a waypoint group here.
---@return uv.Waypoint[]? route List of waypoints.  start is the last, endpos is the first.
function uvws.GetRoute(start, endpos, group)
    if not (isnumber(start) and istable(endpos)) then return end
    group = group or 0

    ---@type uv.RouteNode[], uv.RouteNode[]
    local nodes, opens = {}, {}

    ---@param id integer
    ---@return uv.RouteNode
    local function CreateNode(id)
        ---@class uv.RouteNode
        nodes[id] = {
            estimate = 0,
            closed = nil,
            cost = 0,
            id = id,
            parent = nil, ---@type uv.RouteNode?
            score = 0,
        }

        return nodes[id]
    end

    ---@param node uv.RouteNode
    ---@return number
    local function EstimateCost(node)
        local w = uvws.Waypoints[node.id]
        local cost = math.huge
        if not w then return cost end

        local target = w.Target
        for id in pairs(endpos) do
            local wi = uvws.Waypoints[id]
            if not wi then continue end
            cost = math.min(cost, target:Distance(wi.Target))
        end

        return cost
    end

    ---@param node uv.RouteNode
    ---@param parent uv.RouteNode?
    local function AddToOpenList(node, parent)
        if parent then
            local nodepos = uvws.Waypoints[node.id].Target
            local parentpos = uvws.Waypoints[parent.id].Target
            local cost = parentpos:Distance(nodepos)
            local grandpa = parent.parent
            if grandpa then -- Angle between waypoints is considered as cost
                local gppos = uvws.Waypoints[grandpa.id].Target
                cost = cost * (2 - uvws.GetAng3(gppos, parentpos, nodepos))
            end

            node.cost = parent.cost + cost
        end

        node.closed = false
        node.estimate = EstimateCost(node)
        node.parent = parent
        node.score = node.estimate + node.cost

        -- Open list is binary heap
        table.insert(opens, node.id)
        local i = #opens
        local p = math.floor(i / 2)
        while i > 0 and p > 0 and nodes[opens[i]].score < nodes[opens[p]].score do
            opens[i], opens[p] = opens[p], opens[i]
            i, p = p, math.floor(p / 2)
        end
    end

    local startNode = CreateNode(start)
    local endposNodes = {} ---@type uv.RouteNode[]
    for id in pairs(endpos) do
        endposNodes[id] = CreateNode(id)
    end

    AddToOpenList(startNode)
    while #opens > 0 do
        local current = opens[1] -- Pop a node which has minimum cost.
        opens[1] = opens[#opens]
        opens[#opens] = nil

        local i = 1 -- Down-heap on the open list
        while i <= #opens do
            local c = i * 2
            if not opens[c] then break end
            c = c + (opens[c + 1] and nodes[opens[c]].score > nodes[opens[c + 1]].score and 1 or 0)
            if nodes[opens[c]].score >= nodes[opens[i]].score then break end
            opens[i], opens[c] = opens[c], opens[i]
            i = c
        end

        if nodes[current].closed then continue end
        if endposNodes[current] then
            current = nodes[current]
            local route = {uvws.Waypoints[current.id]}
            while current and current.parent do
                debugoverlay.Sphere(uvws.Waypoints[current.id].Target, 30, 5, Color(0, 255, 0))
                debugoverlay.SweptBox(uvws.Waypoints[current.parent.id].Target, uvws.Waypoints[current.id].Target, Vector(-10, -10, -10), Vector(10, 10, 10), angle_zero, 5, Color(0, 255, 0))
                table.insert(route, uvws.Waypoints[current.id])
                current = current.parent
            end

            return route
        end

        nodes[current].closed = true
        for _, n in ipairs(uvws.Waypoints[nodes[current].id].Neighbors) do
            if nodes[n] and nodes[n].closed ~= nil then continue end
            if not uvws.WaypointAvailable(n, group) then continue end
            AddToOpenList(nodes[n] or CreateNode(n), nodes[current])
        end
    end
end

---Retrives a table of waypoints that represents the route
---from start to one of the destination in endpos.
---@param start Vector The beginning position.
---@param endpos table A table of Vectors that represent destinations.  Can also be a Vector.
---@param group number? Optional, specify a waypoint group here.
---@return uv.Waypoint[]? route The same as returning value of uv.GetRoute()
function uvws.GetRouteVector(start, endpos, group)
    if isvector(endpos) then endpos = {endpos} end
    if not (isvector(start) and istable(endpos)) then return end
    local endpostable = {} ---@type table<integer, true>
    for _, p in ipairs(endpos) do
        local id = select(2, uvws.GetNearestWaypoint(p))
        if not id then continue end
        endpostable[id] = true
    end

    return uvws.GetRoute(select(2, uvws.GetNearestWaypoint(start)), endpostable, group)
end

hook.Run "Unit Vehicles: PostInitialize"
