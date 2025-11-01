AddCSLuaFile()

local function ImportData(folder)
    local datafiles, datafolders = file.Find("data_static/uv_import/"..folder.."/uvdata/*", "GAME")
    
    for _, dataFld in ipairs(datafolders) do
        print(dataFld)
        local path = "unitvehicles/" .. dataFld
        
        if not file.IsDir(path, "DATA") then
            file.CreateDir(path)
        end
        
        local datafiles2, datafolders2 = file.Find("data_static/uv_import/"..folder.."/uvdata/"..dataFld.."/*", "GAME")
        
        if datafiles2 then
            for _, filename in ipairs(datafiles2) do
                local source = "data_static/uv_import/" .. folder .. "/uvdata/" .. dataFld .. "/" .. filename
                local destination = "unitvehicles/" .. dataFld .. "/" .. filename
                
                if file.Exists(source, "GAME") then
                    file.Write(destination, file.Read(source, "GAME"))
                end
            end
            
        end
        
        for _, folder2 in ipairs(datafolders2) do
            local subpath = path .. "/" .. folder2
            
            if not file.IsDir(subpath, "DATA") then
                file.CreateDir(subpath)
            end
            
            local datafiles3, datafolders3 = file.Find("data_static/uv_import/"..folder.."/uvdata/"..dataFld.."/"..folder2.."/*", "GAME")
            
            if datafiles3 then
                for _, filename in ipairs(datafiles3) do
                    local source = "data_static/uv_import/" .. folder .. "/uvdata/" .. dataFld .. "/" .. folder2 .. "/" .. filename
                    local destination = "unitvehicles/" .. dataFld .. "/" .. folder2 .. "/" .. filename
                    
                    if file.Exists(source, "GAME") then
                        file.Write(destination, file.Read(source, "GAME"))
                    end
                    
                end
                
            end
            
        end
    end
    
    -- DECENT VEHICLE WAYPOINTS --
    local dvfiles, dvfolders = file.Find("data_static/uv_import/"..folder.."/uvdvwaypoints/*", "GAME")
    
    for _, filename in ipairs(dvfiles) do
        local source = "data_static/uvdvwaypoints/" .. filename
        local destination = "decentvehicle/" .. filename
        
        if !file.IsDir("decentvehicle", "DATA") then
            file.CreateDir("decentvehicle")
        end
        
        if file.Exists(source, "GAME") then
            file.Write(destination, file.Read(source, "GAME"))
        end
        
    end
end

local _, folders = file.Find("data_static/uv_import/*", "GAME")

for _, folder in ipairs(folders) do
    ImportData(folder)
    if CLIENT then
        chat.AddText(Color(0, 255, 0), "[Unit Vehicles] Imported data from: " .. folder)
    end
end