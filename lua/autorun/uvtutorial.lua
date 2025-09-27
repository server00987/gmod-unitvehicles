-- AddCSLuaFile()

-- if SERVER then return end

-- local script_path = debug.getinfo(1).source

-- if string.sub(script_path, 1, 1) == "@" then
--     script_path = string.sub(script_path, 2)
-- end

-- local addon_name = string.match(script_path, "addons/([^/]+)/")

-- local function openPlayer(assetUrl)
--     local frame = vgui.Create("DFrame")
--     frame:SetSize(ScrW(), ScrH())
--     frame:SetPos(0, 0)
--     frame:SetTitle("")
--     frame:ShowCloseButton(true)
--     frame:SetDraggable(false)
--     frame:MakePopup()
--     frame:SetKeyboardInputEnabled(false)
--     frame:SetMouseInputEnabled(true)

--     local html = vgui.Create("DHTML", frame)
--     html:Dock(FILL)
--     html:SetHTML(string.format([[
--         <html>
--         <body style="margin:0;background:black;overflow:hidden;">
--             <video width="100%%" height="100%%" autoplay controls>
--                 <source src="%s" type="video/webm">
--             </video>
--         </body>
--         </html>
--     ]], assetUrl))
-- end

-- local function playContextualVideo(folder)
--     local path = "data_static/tutorials/" .. folder .. "/"
--     local files = file.Find(path .. "*.webm", "GAME")
--     if not files or next(files) == nil then return end

--     local pick = files[math.random(1, #files)]
--     local assetUrl = "asset://garrysmod/addons/" .. addon_name .. "/" .. path .. pick
--     openPlayer(assetUrl)
-- end

-- concommand.Add("uv_tutorial_pursuit", function( ply )
--     playContextualVideo("pursuit")
-- end)

-- hook.Add("PopulateToolMenu", "UVMenuTutorial", function()
-- 	spawnmenu.AddToolMenuOption("Options", "uv.settings.unitvehicles", "UVTutorial", "#uv.settings.tutorial", "", "", function(panel)
-- 		panel:Clear()

--         panel:Help("#uv.settings.tutorial.help")

-- 		panel:Button("#uv.settings.tutorial.video.pursuit", "uv_tutorial_pursuit")
--     end)
-- end)
