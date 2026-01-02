
AddCSLuaFile()

---@class uv.Waypoint
---@field Group         integer
---@field Neighbors     integer[]
---@field Owner         Player?
---@field SpeedLimit    number
---@field Target        Vector
---@field Time          number

if not UnitVehiclesWaypointsSystem then
    ---@class uvws
    ---@field SaveEntity Entity
    UnitVehiclesWaypointsSystem = {
        DriverAnimation = {
            ["Source_models/airboat.mdl"] = "drive_airboat",
            ["Source_models/sligwolf/motorbike/motorbike.mdl"] = "drive_airboat",
            ["Source_models/sligwolf/tank/sw_tank_leo.mdl"] = "sit_rollercoaster",
            ["SCAR_sent_sakarias_car_yamahayfz450"] = "drive_airboat",
            ["Simfphys_models/monowheel.mdl"] = "drive_airboat",
        },
        DefaultDriverModel = {
            "models/player/group01/female_01.mdl",
            "models/player/group01/female_02.mdl",
            "models/player/group01/female_03.mdl",
            "models/player/group01/female_04.mdl",
            "models/player/group01/female_05.mdl",
            "models/player/group01/female_06.mdl",
            "models/player/group01/male_01.mdl",
            "models/player/group01/male_02.mdl",
            "models/player/group01/male_03.mdl",
            "models/player/group01/male_04.mdl",
            "models/player/group01/male_05.mdl",
            "models/player/group01/male_06.mdl",
            "models/player/group01/male_07.mdl",
            "models/player/group01/male_08.mdl",
            "models/player/group01/male_09.mdl",
            "models/player/group02/male_02.mdl",
            "models/player/group02/male_04.mdl",
            "models/player/group02/male_06.mdl",
            "models/player/group02/male_08.mdl",
            "models/player/group03/female_01.mdl",
            "models/player/group03/female_02.mdl",
            "models/player/group03/female_03.mdl",
            "models/player/group03/female_04.mdl",
            "models/player/group03/female_05.mdl",
            "models/player/group03/female_06.mdl",
            "models/player/group03/male_01.mdl",
            "models/player/group03/male_02.mdl",
            "models/player/group03/male_03.mdl",
            "models/player/group03/male_04.mdl",
            "models/player/group03/male_05.mdl",
            "models/player/group03/male_06.mdl",
            "models/player/group03/male_07.mdl",
            "models/player/group03/male_08.mdl",
            "models/player/group03/male_09.mdl",
        },
        FakeCUserCmd = nil,
        KphToHUps = 1000 * 3.2808399 * 16 / 3600,
        KmToHU = 1000 * 3.2808399 * 16,
        PID = {
            Throttle = {},
            Steering = {},
        },
        POPUPWINDOW = {
            BITS = 2,
            SAVE = 0,
            LOAD = 1,
            DELETE = 2,
            GENERATE = 3,
        },
        SeatPos = {
            ["Source_models/airboat.mdl"] = Vector(0, 0, -29),
            ["Source_models/vehicle.mdl"] = Vector(-8, 0, -31),
            ["Source_models/sligwolf/motorbike/motorbike.mdl"] = Vector(2, 0, -30),
            ["Glide_"] = Vector(0, 0, -26),
            ["LVS_"] = Vector(0, 0, -24),
            ["Simfphys_"] = Vector(2, 0, -28),
        },
        Waypoints = {}, ---@type uv.Waypoint[]
        WaypointSize = 32,
        WireManagers = {}, ---@type table<ENT.UVWireManager, true>
    }
end

---@class uvws
local uvws = UnitVehiclesWaypointsSystem
local CVarFlags = {FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED}

-- Model list for wiremod support
local WireModels = {
    "models/props_c17/lampShade001a.mdl",
    "models/hunter/blocks/cube025x025x025.mdl",
    "models/props_wasteland/controlroom_filecabinet001a.mdl",
    "models/props_lab/powerbox02d.mdl",
    "models/jaanus/wiretool/wiretool_siren.mdl",
    "models/jaanus/wiretool/wiretool_range.mdl",
}
for k, v in pairs(WireModels) do
    if file.Exists(v, "GAME") then
        list.Set("[UV] WireManager Model List", v, true)
    end
end

---Gets direction vector from v1 to v2.
---@param v1 Vector The beginning point.
---@param v2 Vector The ending point.
---@return Vector # Normalized vector of v2 - v1.
function uvws.GetDir(v1, v2)
    return (v2 - v1):GetNormalized()
end

---Gets angle between vector A and B.
---@param A Vector The first vector.
---@param B Vector The second vector.
---@return number ang The angle of two vectors.  The actual angle is math.acos(ang).
function uvws.GetAng(A, B)
    return A:GetNormalized():Dot(B:GetNormalized())
end

---Gets angle between vector AB and BC.
---@param A Vector The beginning point.
---@param B Vector The middle point.
---@param C Vector The ending point.
---@return number ang The same as uv.GetAng()
function uvws.GetAng3(A, B, C)
    return uvws.GetAng(B - A, C - B)
end

---Retrives the nearest waypoint to the given position.
---@param pos    Vector  The position to find.
---@param filter (number|fun(index: integer, id: integer?, distance: number?): boolean)? Optional.  The maximum radius.  Can also be a function.
---@return uv.Waypoint?  waypoint   The found waypoint.  Can be nil.
---@return number? waypointID The ID of found waypoint.
function uvws.GetNearestWaypoint(pos, filter)
    if not isvector(pos) then return end
    local r = not isfunction(filter) and filter or math.huge
    local mindistance, waypoint, waypointID = r^2, nil, nil
    for i, w in ipairs(uvws.Waypoints) do
        local distance = w.Target:DistToSqr(pos)
        if distance < mindistance and (
            not isfunction(filter) ---@cast filter -?
            or filter(i, waypointID, mindistance)) then
            mindistance, waypoint, waypointID = distance, w, i
        end
    end

    return waypoint, waypointID
end

local lang = GetConVar "gmod_language":GetString()

---@param convar string
---@param old string
---@param new string
local function ReadTexts(convar, old, new)
    ---@class uv.RecursiveString : string
    ---@field [string] uv.RecursiveString
    uvws.Texts = {} ---@type table<string, uv.RecursiveString>

    ---@type string[]
    local directories = select(2, file.Find("unitvehicles/*", "LUA")) or {}
    for _, dir in ipairs(directories) do
        if SERVER then -- We need to run AddCSLuaFile() for all languages.
            local path = string.format("unitvehicles/%s/", dir)
            local files = file.Find(path .. "*.lua", "LUA") or {}
            for _, f in ipairs(files) do
                AddCSLuaFile(path .. f)
            end
        end

        local path = string.format("unitvehicles/%s/en.lua", dir)
        if file.Exists(path, "LUA") then table.Merge(uvws.Texts, include(path)) end
        path = string.format("unitvehicles/%s/%s.lua", dir, new)
        if file.Exists(path, "LUA") then table.Merge(uvws.Texts, include(path)) end
    end
end

ReadTexts("gmod_language", lang, lang)
cvars.AddChangeCallback("gmod_language", ReadTexts, "Unit Vehicles: OnLanguageChanged")

hook.Add("StartCommand", "Unit Vehicles: Get a fake CUserCmd", function(ply, cmd)
    uvws.FakeCUserCmd = cmd
    hook.Remove("StartCommand", "Unit Vehicles: Get a fake CUserCmd")
end)
