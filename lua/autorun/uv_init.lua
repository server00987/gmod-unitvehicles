local files, _ = file.Find("unitvehicles/*.lua", "LUA")

for _, f in ipairs(files) do
    local path = "unitvehicles/" .. f

    if SERVER then
        -- Send every file to the client
        AddCSLuaFile(path)
    end

    -- Include depending on prefix (same behavior as autorun)
    if SERVER and f:StartWith("sv_") then
        include(path)
    elseif CLIENT and f:StartWith("cl_") then
        include(path)
    elseif f:StartWith("sh_") then
        include(path)
    end
end
