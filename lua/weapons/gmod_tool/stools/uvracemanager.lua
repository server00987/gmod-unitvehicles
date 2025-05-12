TOOL.Category = "Unit Vehicles"
TOOL.Name = "#Race Manager"
TOOL.Command = nil
TOOL.ConfigName = ""

TOOL.ClientConVar["speedlimit"] = 50
TOOL.ClientConVar["laps"] = 1

cleanup.Register("uvrace_ents")

local MAX_TRACE_LENGTH = math.sqrt(3) * 2 * 16384
local checkpointTable = {}
local pos1, selectedCP
local secondClick = false

if SERVER then
	if game.SinglePlayer() then
		util.AddNetworkString("UVRace_UpdatePos")
		util.AddNetworkString("UVRace_SelectID")
		util.AddNetworkString("UVRace_SetID")
		util.AddNetworkString("UVRace_SetSpeedLimit")
	end

	util.AddNetworkString("UVStartRace")

	local function KillCheckpoints(ply)
		if !ply:IsSuperAdmin() then return end
		for _, ent in ipairs(ents.FindByClass("uvrace_checkpoint")) do
			ent:Remove()
		end
	end
	concommand.Add("uvrace_killcps", KillCheckpoints)

	local function KillSpawns(ply)
		if !ply:IsSuperAdmin() then return end
		for _, ent in ipairs(ents.FindByClass("uvrace_spawn")) do
			ent:Remove()
		end
	end
	concommand.Add("uvrace_killspawns", KillSpawns)

	local function KillAll(ply)
		if !ply:IsSuperAdmin() then return end
		for _, ent in ipairs(ents.FindByClass("uvrace_*")) do
			ent:Remove()
		end
	end
	concommand.Add("uvrace_killall", KillAll)

	local function StopRace(ply, cmd, args)
		if !ply:IsSuperAdmin() then return end
		UVRaceEnd()
        net.Start( "uvrace_end" )
        net.Broadcast()

	end
	concommand.Add("uvrace_stop", StopRace)

	local function AddHooks()

	end

	-- local function StartRaceSolo(ply, cmd, args)

	-- 	if !IsValid( UVMoveToGridSlot( ply ) ) then return end

	-- 	UVRaceMakeCheckpoints()

	-- 	AddHooks()
	-- end
	-- concommand.Add("uvrace_startsolo", StartRaceSolo)

	local function StartRace(ply, cmd, args)
		if !ply:IsSuperAdmin() then return end
		-- if !IsValid( UVMoveToGridSlot( ply ) ) then return end
		if UVRaceInEffect then return end

		if uvtargeting then
			net.Start("uvrace_decline")
			net.WriteString("You cannot start a race now, lose the cops first!")
			net.Send(ply)
			return
		end

		//RunConsoleCommand("uv_stoppursuit")
		RunConsoleCommand("uv_despawnvehicles")

		for _, v in ents.Iterator() do
			if table.HasValue(UVRaceCurrentParticipants, v) then continue end
			if (!v.IsGlideVehicle and !v.IsSimfphyscar and v:GetClass() ~= 'prop_vehicle_jeep') or v.wrecked or v.UnitVehicle then continue end

			local driver = v:GetDriver()
			local is_player = IsValid(driver) and driver:IsPlayer()

			if is_player and driver == ply then
				UVRaceAddParticipant( v, nil, true )
			end
		end

		local ready_drivers = 0
		
		for _, v in pairs(table.Copy(UVRaceCurrentParticipants)) do
			local driver = v:GetDriver()

			local ent = UVMoveToGridSlot(v, !(driver and driver:IsPlayer()))

			if (ent) then ready_drivers = ready_drivers + 1 
			else UVRaceRemoveParticipant( v ) end
		end

		if ready_drivers <= 0 then return end

		UVRacePrep = true
		UVRaceInEffect = true

		UVRaceMakeCheckpoints()
		
		timer.Simple(2, function()
			//UVRaceMakeCheckpoints()
			UVRacePrep = false
		end)

		--UVRacePrep = false
	end
	concommand.Add("uvrace_startrace", StartRace)

	local function StartRaceInvite(ply, cmd, args)
		if !ply:IsSuperAdmin() then return end
		if UVRaceInEffect then return end

		if uvtargeting then
			net.Start("uvrace_decline")
			net.WriteString("You cannot invite others to race while being pursued!")
			net.Send(ply)
			return
		end

		local invited_racers = {}

		for _, v in ents.Iterator() do
			if table.HasValue(UVRaceCurrentParticipants, v) then continue end
			if (!v.IsGlideVehicle and !v.IsSimfphyscar and v:GetClass() ~= 'prop_vehicle_jeep') or v.wrecked or v.UnitVehicle or v.uvbusted then continue end

			local driver = v:GetDriver()
			local is_player = IsValid(driver) and driver:IsPlayer()

			if !v.raceinvited and (v.RacerVehicle or (is_player and driver ~= ply)) then
				//PrintMessage( HUD_PRINTTALK, "Sent race invite to "..((is_player and driver:GetName()) or (v.racer or "Racer "..v:EntIndex())) )

				table.insert(invited_racers, ((is_player and driver:GetName()) or (v.racer or "Racer "..v:EntIndex())))
				-- if is_player then
				-- 	v.racer = driver
				-- else
				-- 	v.racer = nil
				-- end

				v.raceinvited = true
				v.lastraceinv = CurTime()

				if is_player then
					net.Start( 'uvrace_invite' )
					net.Send(driver)
				end

				timer.Create('RaceInviteExpire'..v:EntIndex(), 10, 1, function()
					//v.racer = nil
					v.raceinvited = false
				end)
			end
		end	
		
		if #invited_racers > 0 then
			net.Start("uvrace_racerinvited")
			net.WriteTable(invited_racers)
			net.Send(ply)
		end
	end
	concommand.Add("uvrace_startinvite", StartRaceInvite)

	local function ImportExportText(name, export, ply)
		local nick = ply:Nick():lower():Replace(" ", "_")

		local filename = "unitvehicles/races/" .. game.GetMap() .. "/" .. nick .. "." .. name .. ".txt"

		local str = export and "Exported UV Race positions to " .. filename or "Imported UV Race positions from " .. filename
		ply:ChatPrint(str)
	end

	local function Import(ply, cmd, args)
		if !ply:IsSuperAdmin() then return end
		local filename = "unitvehicles/races/" .. game.GetMap() .. "/" .. args[1]
		if !file.Exists(filename, "DATA") then return end

		local entList = file.Read(filename, "DATA"):Split("\n")
	
		if UVRaceInEffect then
			UVRaceEnd()
		end

		--Delete all checkpoints and spawns
		for _, ent in ipairs(ents.FindByClass("uvrace_brush*")) do
			ent:Remove()
		end
		for _, ent in ipairs(ents.FindByClass("uvrace_checkpoint")) do
			ent:Remove()
		end
		for _, ent in ipairs(ents.FindByClass("uvrace_spawn")) do
			ent:Remove()
		end

		undo.Create("UVRaceEnt")
		undo.SetPlayer(ply)

		for _, data in ipairs(entList) do
			local params = data:Split(" ")

			local cid = tonumber(params[1])
			if cid then
				local check = ents.Create("uvrace_checkpoint")

				local speedlimit = tonumber(params[8]) or 0
				local posx, posy, posz = tonumber(params[2]), tonumber(params[3]), tonumber(params[4])
				local mx, my, mz = tonumber(params[5]), tonumber(params[6]), tonumber(params[7])

				local pos = Vector(posx, posy, posz)
				check:SetPos(pos)
				check:SetMaxPos(Vector(mx, my, mz))
				check:SetID(cid)
				check:SetSpeedLimit(speedlimit)
				check:Spawn()

				undo.AddEntity(check)
				ply:AddCleanup("uvrace_ents", check)
			elseif params[1] == "spawn" then
				local spawn = ents.Create("uvrace_spawn")

				local posx, posy, posz = tonumber(params[2]), tonumber(params[3]), tonumber(params[4])
				spawn:SetPos(Vector(posx, posy, posz))

				local angy = tonumber(params[5])
				spawn:SetAngles(Angle(0, angy, 0))

				spawn:SetGridSlot(tonumber(params[6]))

				spawn:Spawn()

				undo.AddEntity(spawn)
				ply:AddCleanup("uvrace_ents", spawn)
			end

		end

		undo.Finish()

		local tname = args[1]:Split(".")[2]

		ImportExportText(tname, false, ply)
	end
	concommand.Add("uvrace_import", Import)

	local blacklist = {
		["uvrace_checkpoint"] = true,
		["uvrace_brushpoint"] = true,
		["uvrace_spawn"] = true,
	}

	local function Export(ply, cmd, args)
		if !ply:IsSuperAdmin() then return end
		local plynick = Entity(1):Nick()

		local str = "name " .. args[1] .. " '" .. plynick .. "'\n"

		local nick = plynick:lower():Replace(" ", "_")
		local name = args[1]:lower():Replace(" ", "_")

		local filename = "unitvehicles/races/" .. game.GetMap() .. "/" .. nick .. "." .. name .. ".txt"

		for _, ent in ipairs(ents.FindByClass("uvrace_checkpoint")) do
			str = str .. tostring(ent:GetID()) .. " " .. tostring(ent:GetPos()) .. " " .. tostring(ent:GetMaxPos()) .. " " .. tostring(ent:GetSpeedLimit()) .."\n"
		end

		for _, ent in ipairs(ents.FindByClass("uvrace_spawn")) do
			str = str .. "spawn " .. tostring(ent:GetPos()) .. " " .. tostring(ent:GetAngles().y) .. " " .. tostring(ent:GetGridSlot()) .. "\n"
		end

		file.CreateDir("unitvehicles/races/" .. game.GetMap())
		file.Write(filename, str)

		ImportExportText(name, true, ply)
	end
	concommand.Add("uvrace_export", Export)

	local function SetID(len, ply)
		if !ply:IsSuperAdmin() then return end
		local ent = net.ReadEntity()
		local id = net.ReadUInt(16)
		local speedlimit = net.ReadUInt(16)

		ent:SetID(id)
		ent:SetSpeedLimit(speedlimit)
		UVRaceCheckFinishLine()
	end
	net.Receive("UVRace_SetID", SetID)
elseif CLIENT then

	TOOL.Information = {
		{ name = "info"},
		{ name = "left" },
		{ name = "right" },
		{ name = "reload" }
	}

	//CreateClientConVar("unitvehicle_racelaps", "3")
	CreateClientConVar("unitvehicle_racetheme", "carbon - bending light")
	CreateClientConVar("unitvehicle_sfxtheme", "unbound")

	local ang0 = Angle(0, 0, 0)
	local vec0 = Vector(0, 0, 0)

	local col_white = Color(255, 255, 255)
	local col_blue = Color(0, 0, 255, 200)

	function TOOL:DrawHUD()
		local ply = self:GetOwner()

		local startpos = ply:EyePos()

		local tr = util.TraceLine({
			start = startpos,
			endpos = startpos + (ply:GetAimVector() * MAX_TRACE_LENGTH),
			filter = ply
		})

		if !tr.Hit then return end

		local hp = tr.HitPos

		cam.Start3D()
		render.SetColorMaterial()

		if pos1 then
			render.DrawBox(pos1, ang0, vec0, hp - pos1, col_blue)
		end

		render.DrawLine(hp + Vector(0, 10, 0), hp - Vector(0, 10, 0), col_white)
		render.DrawLine(hp + Vector(10, 0, 0), hp - Vector(10, 0, 0), col_white)
		render.DrawLine(hp + Vector(0, 0, 10), hp - Vector(0, 0, 10), col_white)

		cam.End3D()
	end

	local function Count()
		local cpIDTbl = {}
		local lang = language.GetPhrase

		for _, ent in ipairs(ents.FindByClass("uvrace_checkpoint")) do
			local index = cpIDTbl[ent:GetID()]
			if !index then cpIDTbl[ent:GetID()] = 1 continue end

			cpIDTbl[ent:GetID()] = index + 1
		end

		for id, count in pairs(cpIDTbl) do
			local str = count > 1 and "tool.uvracemanager.count.checkpoints" or "tool.uvracemanager.count.checkpoint"
			chat.AddText(string.format(lang(str), count, id))
		end

		chat.AddText(string.format(lang("tool.uvracemanager.count.startpoint"),#ents.FindByClass("uvrace_spawn") ) )
	end
	concommand.Add("uvrace_count", Count)

	local function UpdatePos()
		local ispos2 = net.ReadBool()
		local pos = net.ReadVector()

		if ispos2 then
			table.insert(checkpointTable, {pos1 = pos1, pos2 = pos, id = #checkpointTable})
			pos1 = nil
		else
			pos1 = pos
		end
	end
	net.Receive("UVRace_UpdatePos", UpdatePos)

	local function SelectID()
		local ent = net.ReadEntity()

		selectedCP = ent

		local cpID = ent:GetID()

		Derma_StringRequest("#tool.uvracemanager.checkpoint.setid", "#tool.uvracemanager.checkpoint.setid.desc", cpID, function(text)
			local id = tonumber(text)
			selectedCP:SetID(id)
			selectedCP:SetSpeedLimit(GetConVar("uvracemanager_speedlimit"):GetInt())

			net.Start("UVRace_SetID")
				net.WriteEntity(selectedCP)
				net.WriteUInt(id, 16)
				net.WriteUInt(GetConVar("uvracemanager_speedlimit"):GetInt(), 16)
			net.SendToServer()

		end, nil, "#addons.confirm", "#addons.cancel")
	end
	net.Receive("UVRace_SelectID", SelectID)

	local function QueryImport()
		local w = ScrW()
		local h = ScrH()

		local dframe = vgui.Create("DFrame")
		dframe:SetSize(w / 8, h / 4)
		dframe:SetPos((w / 2) - ((w / 8) / 2), (h / 2) - ((h / 4) / 2))
		dframe:SetTitle("Import")
		dframe:MakePopup()

		local dlist = vgui.Create("DScrollPanel", dframe)
		dlist:Dock(FILL)

		for _, item in ipairs(file.Find("unitvehicles/races/" .. game.GetMap() .. "/*", "DATA")) do
			local dbutton = dlist:Add("DButton")

			local name = file.Read("unitvehicles/races/" .. game.GetMap() .. "/" .. item, "DATA"):Split("\n")[1]
			local params = name:Split(" ")
			local nick = name:match("'.*$"):Replace("'", "")

			dbutton:SetText(params[2] .. " | " .. nick)
			dbutton:Dock(TOP)
			dbutton:DockMargin(0, 0, 0, 5)

			function dbutton:DoClick()
				RunConsoleCommand("uvrace_import", item)
				dframe:Close()
			end
		end
	end
	concommand.Add("uvrace_queryimport", QueryImport)

	local function UpdateVars( ply, cmd, args )
		local convar = args[1]
		local value = args[2]

		net.Start( "UVUpdateSettings" )

		net.WriteTable({
			[convar] = value
		})

		net.SendToServer()
	end
	concommand.Add("uvrace_updatevars", UpdateVars)

	local function QueryExport()
		Derma_StringRequest("#tool.uvracemanager.export", "#tool.uvracemanager.export.desc", cpID, function(txt)
			RunConsoleCommand("uvrace_export", txt)
		end, nil, "#addons.confirm", "#addons.cancel")
	end
	concommand.Add("uvrace_queryexport", QueryExport)
end


function TOOL:LeftClick(trace)
	if !trace.Hit then return end
	local ply = self:GetOwner()
	if !ply:IsSuperAdmin() then return end

	local pos

	if secondClick then
		pos = trace.HitPos

		if game.SinglePlayer() or SERVER then
			local cPoint = ents.Create("uvrace_checkpoint")
			cPoint:SetPos(pos1)
			cPoint:SetMaxPos(pos)
			cPoint:SetSpeedLimit(GetConVar('uvracemanager_speedlimit'):GetInt())
			cPoint:Spawn()

			undo.Create("UVRaceEnt")
			undo.AddEntity(cPoint)
			undo.SetPlayer(ply)
			undo.Finish()

			ply:AddCleanup("uvrace_ents", cPoint)
		end

		-- table.insert(checkpointTable, {pos1 = pos1, pos2 = pos, id = #checkpointTable})
		pos1 = nil
	else
		pos1 = trace.HitPos
		pos = pos1
	end

	if game.SinglePlayer() then
		net.Start("UVRace_UpdatePos")
			net.WriteBool(secondClick)
			net.WriteVector(pos)
		net.Send(ply)
	end

	pos = nil
	secondClick = !secondClick

	return true
end

function TOOL:RightClick()
	local ply = self:GetOwner()
	local startpos = ply:EyePos()
	if !ply:IsSuperAdmin() then return end

	local tr = util.TraceLine({
		start = startpos,
		endpos = startpos + (ply:GetAimVector() * MAX_TRACE_LENGTH),
		filter = ply
	})

	local ent = tr.Entity
	if ent:GetClass() != "uvrace_checkpoint" then return end

	selectedCP = ent

	if game.SinglePlayer() then
		net.Start("UVRace_SelectID")
			net.WriteEntity(ent)
		net.Send(self:GetOwner())
	elseif CLIENT then
		Derma_StringRequest("#tool.uvracemanager.checkpoint.setid", "#tool.uvracemanager.checkpoint.setid.desc", ent:GetID(), function(text)
			ent:SetID(tonumber(text))
		end, nil, "Set", "Cancel")
	end

	return true
end

function TOOL:Reload( trace )
	if !trace.Hit then return end
	local hp = trace.HitPos
	local ply = self:GetOwner()
	if !ply:IsSuperAdmin() then return end

	if game.SinglePlayer() or SERVER then
		local spawn = ents.Create("uvrace_spawn")
		spawn:SetPos(hp)
		spawn:SetAngles(Angle(0, ply:EyeAngles().y, 0))
		spawn:Spawn()

		undo.Create("UVRaceEnt")
		undo.AddEntity(spawn)
		undo.SetPlayer(ply)
		undo.Finish()

		ply:AddCleanup("uvrace_ents", spawn)
	end

	return true
end

function TOOL.BuildCPanel(panel)
	-- panel:AddControl("Header", { Text = "tool.uvracemanager.name", Description = "#tool.uvracemanager.desc"})
	panel:AddControl("Header", { Text = "tool.uvracemanager.name"})
	
	panel:AddControl("Label", {Text = "#tool.uvracemanager.settings.racec", Description = "Race"})
	-- panel:AddControl("Button", {Label = "#tool.uvracemanager.settings.racec.start", Command = "uvrace_startrace"})
	panel:Button("#tool.uvracemanager.settings.racec.start", "uvrace_startrace")
	panel:AddControl("Button", {Label = "#tool.uvracemanager.settings.racec.stop", Command = "uvrace_stop"})
	panel:AddControl("Button", {Label = "#tool.uvracemanager.settings.racec.invite", Command = "uvrace_startinvite"})
	
	panel:AddControl("Label", {Text = "#tool.uvracemanager.settings.saveloadrace", Description = "Race"})
	panel:AddControl("Button",  { Label	= "#tool.uvracemanager.settings.loadrace", Command = "uvrace_queryimport" })
	panel:AddControl("Button",  { Label	= "#tool.uvracemanager.settings.saverace", Command = "uvrace_queryexport" })


	panel:AddControl("Label", {Text = "#tool.uvracemanager.settings.raceo"})
	local last_lap_value
	local lap_slider = panel:NumSlider("#tool.uvracemanager.settings.raceo.laps", "uvracemanager_laps", 1, 100, 0)
	function lap_slider:Think()
		local value = GetConVar("uvracemanager_laps"):GetInt()

		if last_lap_value ~= value then
			RunConsoleCommand("uvrace_updatevars", "unitvehicle_racelaps", value)
			last_lap_value = value
		end
	end

	local speed_slider = panel:NumSlider("#tool.uvracemanager.settings.raceo.speedlimit", "uvracemanager_speedlimit", 1, 500, 0)

	local racetheme, label = panel:ComboBox( "#tool.uvracemanager.settings.raceo.music", "unitvehicle_racetheme" )
	local files, folders = file.Find( "sound/uvracemusic/*", "GAME" )
	if folders != nil then
		for k, v in pairs(folders) do
			racetheme:AddChoice( v )
		end
	end

	local sfxtheme, label = panel:ComboBox( "#tool.uvracemanager.settings.raceo.sfx", "unitvehicle_sfxtheme" )
	local files, folders = file.Find( "sound/uvracesfx/*", "GAME" )
	if folders != nil then
		for k, v in pairs(folders) do
			sfxtheme:AddChoice( v )
		end
	end
	
	panel:AddControl("Label", {Text = "#tool.uvracemanager.settings.clearassets"})
	panel:AddControl("Button", {Label = "#tool.uvracemanager.settings.clearassets.cp", Command = "uvrace_killcps"})
	panel:AddControl("Button", {Label = "#tool.uvracemanager.settings.clearassets.startpos", Command = "uvrace_killspawns"})
	panel:AddControl("Button", {Label = "#tool.uvracemanager.settings.clearassets.all", Command = "uvrace_killall"})
	panel:AddControl("Label", {Text = " "})
	panel:AddControl("Button", {Label = "#tool.uvracemanager.settings.getraceinfo", Command = "uvrace_count" })

end

