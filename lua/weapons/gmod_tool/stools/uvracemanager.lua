TOOL.Category = "uv.settings.unitvehicles"
TOOL.Name = "#tool.uvracemanager.name"
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
	
	local function KillCheckpoints(ply)
		if not ply:IsSuperAdmin() then return end
		for _, ent in ipairs(ents.FindByClass("uvrace_checkpoint")) do
			ent:Remove()
		end
	end
	concommand.Add("uvrace_killcps", KillCheckpoints)
	
	local function KillSpawns(ply)
		if not ply:IsSuperAdmin() then return end
		for _, ent in ipairs(ents.FindByClass("uvrace_spawn")) do
			ent:Remove()
		end
	end
	concommand.Add("uvrace_killspawns", KillSpawns)
	
	local function KillAll(ply)
		if not ply:IsSuperAdmin() then return end
		for _, ent in ipairs(ents.FindByClass("uvrace_*")) do
			ent:Remove()
		end
	end
	concommand.Add("uvrace_killall", KillAll)
	
	local function StopRace(ply, cmd, args)
		if not ply:IsSuperAdmin() then return end
		UVRaceEnd()
		UVCounterActive = false
		
		net.Start( "uvrace_end" )
		net.Broadcast()
		
	end
	concommand.Add("uvrace_stop", StopRace)
	
	local function AddHooks()
		
	end
	
	-- local function StartRaceSolo(ply, cmd, args)
	
	-- 	if not IsValid( UVMoveToGridSlot( ply ) ) then return end
	
	-- 	UVRaceMakeCheckpoints()
	
	-- 	AddHooks()
	-- end
	-- concommand.Add("uvrace_startsolo", StartRaceSolo)
	
	local function StartRace(ply, cmd, args)
		if not ply:IsSuperAdmin() then return end
		-- if not IsValid( UVMoveToGridSlot( ply ) ) then return end
		if UVRaceInEffect then return end

		if UVCounterActive then
			net.Start("uvrace_decline")
			net.WriteString("uv.race.start.error.startingpursuit")
			net.Send(ply)
			return
		end
		
		if UVTargeting then
			net.Start("uvrace_decline")
			net.WriteString("uv.race.start.error.chased")
			net.Send(ply)
			return
		end

		//RunConsoleCommand("uv_stoppursuit")
		RunConsoleCommand("uv_despawnvehicles")
		
		for _, v in ents.Iterator() do
			if not table.HasValue(UVRaceCurrentParticipants, v) then
				if (v.IsGlideVehicle or v.IsSimfphyscar or v:GetClass() == "prop_vehicle_jeep") and not v.wrecked and not v.UnitVehicle then
					local driver = v:GetDriver()
					local is_player = IsValid(driver) and driver:IsPlayer()
					
					if is_player and driver == ply then
						UVRaceAddParticipant(v, nil, true)
					end
					
					-- local id = v:EntIndex()
					-- if (is_player and driver == ply) or v.RacerVehicle then
						-- if not UVRaceInvites[id] or UVRaceInvites[id].status ~= "Accepted" then
							-- UVRaceAddParticipant(v, driver, true)
						-- end
					-- end
				end
			end
		end
		
		table.Shuffle( UVRaceCurrentParticipants )
		local ready_drivers = 0
		
		for _, v in pairs(table.Copy(UVRaceCurrentParticipants)) do
			local driver = v:GetDriver()
			
			local ent = UVMoveToGridSlot(v, not (driver and driver:IsPlayer()))
			
			if (ent) then ready_drivers = ready_drivers + 1 
			else UVRaceRemoveParticipant( v ) end
		end
		
		if ready_drivers <= 0 then return end
		
		UVRacePrep = true
		UVRaceInEffect = true
		
		UVRaceMakeCheckpoints( tonumber( args[1] ) ) -- args[1] is the number of laps
		
		net.Start("UVRace_HideRacersList")
		net.Broadcast()

		timer.Simple(2, function()
			//UVRaceMakeCheckpoints()
			UVRacePrep = false
		end)
		
		--UVRacePrep = false
	end
	concommand.Add("uvrace_startrace", StartRace)
	
	local function StartRaceInvite(ply, cmd, args)
		if not ply:IsSuperAdmin() then return end
		if UVRaceInEffect then return end
		
		if UVTargeting then
			net.Start("uvrace_decline")
			net.WriteString("uv.race.invite.error.chased")
			net.Send(ply)
			return
		end
		
		local invited_racers = {}
		
		for _, v in ents.Iterator() do
			if not table.HasValue(UVRaceCurrentParticipants, v) then
				if v:IsVehicle() and (v.IsGlideVehicle or v.IsSimfphyscar or v:GetClass() == "prop_vehicle_jeep") and not v.wrecked and not v.UnitVehicle and not v.uvbusted then

					local driver = v:GetDriver()
					local is_player = IsValid(driver) and driver:IsPlayer()
					
					if not v.raceinvited and (v.RacerVehicle or (is_player and driver ~= ply)) then
						-- PrintMessage(HUD_PRINTTALK, "Sent race invite to "..((is_player and driver:GetName()) or (v.racer or "Racer "..v:EntIndex())))
						
						table.insert(invited_racers, (is_player and driver:GetName()) or (v.racer or "Racer "..v:EntIndex()))
						
						-- if is_player then
						-- 	v.racer = driver
						-- else
						-- 	v.racer = nil
						-- end
						
						v.raceinvited = true
						v.lastraceinv = CurTime()
						
						local name = (is_player and driver:Nick()) or (v.racer or "Racer " .. v:EntIndex())

						UVSetInviteByVehicle(v, name, "Invited")

						if is_player then
							net.Start("uvrace_invite")
							net.Send(driver)
						end
						
						timer.Create("RaceInviteExpire" .. v:EntIndex(), 10.25, 1, function()
							-- if UVRaceInvites[v:EntIndex()] and UVRaceInvites[v:EntIndex()].status == "Invited" then
								-- UVRaceInvites[v:EntIndex()].status = "Declined"
								-- UVBroadcastRacerList()
							-- end
							-- v.racer = nil
							v.raceinvited = false
						end)
					end
				end
			end
		end
		
		
		if #invited_racers > 0 then
			net.Start("uvrace_racerinvited")
			net.WriteTable(invited_racers)
			net.Send(ply)
		end
	end
	concommand.Add("uvrace_startinvite", StartRaceInvite)
	concommand.Add("uvrace_spawnai", function()
		UVAutoSpawnRacer()
	end)
	
	local function ImportExportText(name, export, ply)
		local nick = ply:Nick():lower():Replace(" ", "_")
				
		local racename = name
		
		local filename = "unitvehicles/races/" .. game.GetMap() .. "/" .. nick .. "." .. name .. ".txt"

		local str = export and "Exported UV Race to " .. filename or "Imported UV Race from " .. filename
		-- ply:ChatPrint(str)
		if export then
			ply:ChatPrint(str)
		end
	end
	
	local function Import(ply, cmd, args)
		if not ply:IsSuperAdmin() then return end
		local filename = "unitvehicles/races/" .. game.GetMap() .. "/" .. args[1]
		if not file.Exists(filename, "DATA") then return end

		local jsonfilename = string.Replace( "unitvehicles/races/" .. game.GetMap() .. "/" .. args[1], ".txt", ".json" )
		if file.Exists(jsonfilename, "DATA") then 
			gmsave.LoadMap( file.Read(jsonfilename) )
		end
		
		timer.Simple(0.2, function() --wait for gmsave.LoadMap to finish executing(0.1 seconds)
			local entList = file.Read(filename, "DATA"):Split("\n")

			local metaLine = entList[1]
			local trackName, author = "UNKNOWN", "UNKNOWN"

			if metaLine then
				local nameExtracted, authorExtracted = metaLine:match("^name%s+(.+)%s+'(.+)'$")
				if nameExtracted then trackName = nameExtracted end
				if authorExtracted then author = authorExtracted end
			end

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

					--print(posx, posy, posz, mx, my, mz)

					local localposx, localposy, localposz = tonumber(params[9]), tonumber(params[10]), tonumber(params[11])
					local localmx, localmy, localmz = tonumber(params[12]), tonumber(params[13]), tonumber(params[14])
					local chunkx, chunky, chunkz = tonumber(params[15]), tonumber(params[16]), tonumber(params[17])
					local chunkmx, chunkmy, chunkmz = tonumber(params[18]), tonumber(params[19]), tonumber(params[20])

					local pos = Vector(posx, posy, posz)
					check:SetPos(pos)
					check:SetMaxPos(Vector(mx, my, mz))
					check:SetID(cid)
					check:SetSpeedLimit(speedlimit)
					if InfMap then
						check:SetLocalPos(Vector(localposx, localposy, localposz))
						check:SetLocalMaxPos(Vector(localmx, localmy, localmz))
						check:SetChunk(Vector(chunkx, chunky, chunkz))
						check:SetChunkMax(Vector(chunkmx, chunkmy, chunkmz))
					end
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
				
				undo.AddFunction(function(undoTable, ent)
					net.Start("UVRace_TrackReady")
						net.WriteString("?")
						net.WriteString("?")
					net.Broadcast()
				end)
			end

			undo.Finish()

			local tname = args[1]:Split(".")[2]

			net.Start("UVRace_TrackReady")
			net.WriteString(trackName:Replace("_", " "))
			net.WriteString(author)
			net.WriteString(ply:Nick())
			net.Broadcast()
			
			-- local hostID = ply:EntIndex()
			-- UVRaceInvites[hostID] = { ent = ply:GetVehicle(), name = ply:Nick(), status = "Host" }

			ImportExportText(tname, false, ply)
		end)
	end
	concommand.Add("uvrace_import", Import)
	
	local blacklist = {
		["uvrace_checkpoint"] = true,
		["uvrace_brushpoint"] = true,
		["uvrace_spawn"] = true,
	}
	
	local function Export(ply, cmd, args)
		if not ply:IsSuperAdmin() then return end
		local plynick = Entity(1):Nick()
		
		local str = "name " .. args[1] .. " '" .. plynick .. "'\n"
		
		local nick = plynick:lower():Replace(" ", "_")
		local name = args[1]:lower():Replace(" ", "_")
		
		local filename = "unitvehicles/races/" .. game.GetMap() .. "/" .. nick .. "." .. name .. ".txt"
		
		for _, ent in ipairs(ents.FindByClass("uvrace_checkpoint")) do
			ent.DoNotDuplicate = true
			local strinfmap = InfMap and " " .. tostring(ent:GetLocalPos()) .. " " .. tostring(ent:GetLocalMaxPos()) .. " " .. tostring(ent:GetChunk()) .. " " .. tostring(ent:GetChunkMax()) or ""
			str = str .. tostring(ent:GetID()) .. " " .. tostring(ent:GetPos()) .. " " .. tostring(ent:GetMaxPos()) .. " " .. tostring(ent:GetSpeedLimit()) .. strinfmap .. "\n"
		end
		
		for _, ent in ipairs(ents.FindByClass("uvrace_spawn")) do
			ent.DoNotDuplicate = true
			str = str .. "spawn " .. tostring(ent:GetPos()) .. " " .. tostring(ent:GetAngles().y) .. " " .. tostring(ent:GetGridSlot()) .. "\n"
		end
		
		file.CreateDir("unitvehicles/races/" .. game.GetMap())
		file.Write(filename, str)

		if args[2] then --Save props option
			local jsonfilename = "unitvehicles/races/" .. game.GetMap() .. "/" .. nick .. "." .. name .. ".json"
			local jsonstr = gmsave.SaveMap( ply )

			file.Write(jsonfilename, jsonstr)
		end
		
		ImportExportText(name, true, ply)
	end
	concommand.Add("uvrace_export", Export)
	
	local function SetID(len, ply)
		if not ply:IsSuperAdmin() then return end
		local ent = net.ReadEntity()
		local id = net.ReadUInt(16)
		local speedlimit = net.ReadUInt(16)
		
		ent:SetID(id)
		ent:SetSpeedLimit(speedlimit)
		if id == 65535 then
			ent:Remove()
			return
		end
		UVRaceCheckFinishLine()
	end
	net.Receive("UVRace_SetID", SetID)
elseif CLIENT then
	
	TOOL.Information = {
		{ name = "info", stage = 0},
		{ name = "left", stage = 0 },
		{ name = "right", stage = 0 },
		{ name = "reload", stage = 0 },
		
		{ name = "info", stage = 1},
		{ name = "left", stage = 1 },
		{ name = "use", stage = 1 },
	}
	
	//CreateClientConVar("unitvehicle_racelaps", "3")
	CreateClientConVar("unitvehicle_racetheme", "carbon - bending light")
	CreateClientConVar("unitvehicle_sfxtheme", "unbound")
	
	
	CreateClientConVar("uvracemanager_dnftimer", "30", true, false)
	
	CreateClientConVar("unitvehicle_cpheight", 64)
	
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
		
		if not tr.Hit then return end
		
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

			if index then
				cpIDTbl[ent:GetID()] = index + 1
			else
				cpIDTbl[ent:GetID()] = 1
			end
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
		local chunk = net.ReadBool()
		if chunk then
			chunk = net.ReadVector()
		end
		
		if ispos2 then
			table.insert(checkpointTable, {pos1 = pos1, pos2 = pos, id = #checkpointTable})
			pos1 = nil
		else
			--print(pos)
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
		if IsValid(ImportPanel) then ImportPanel:Remove() end

		local showPreview = false
		local sw, sh = ScrW(), ScrH()
		local pw, ph = sw * (showPreview and 0.45 or 0.25), sh * 0.6
		local px, py = (sw - pw) * 0.5, (sh - ph) * 0.5

		local files = file.Find("unitvehicles/races/" .. game.GetMap() .. "/*.txt", "DATA")

		ImportPanel = vgui.Create("DFrame")
		ImportPanel:SetSize(pw, ph)
		ImportPanel:SetPos(px, py)
		ImportPanel:SetTitle("")
		ImportPanel:ShowCloseButton(false)
		ImportPanel:SetDraggable(false)
		ImportPanel:SetKeyboardInputEnabled(false)
		ImportPanel:SetDeleteOnClose(true)
		ImportPanel:MakePopup()
		gui.EnableScreenClicker(true)

		local bgScale, bgAlpha, bgAnimStart = 0, 0, CurTime()
		local contentAlpha, contentStart = 0, CurTime()
		local closing, closeStartTime = false, 0

		local raceEntries, highlightedIndex, selectedIndex = {}, nil, nil

		-- === Parse a race file (improved multi-checkpoint + spawn parser) ===
		local function ParseRaceFile(path)
			local content = file.Read(path, "DATA")
			if not content then return nil end

			local lines = string.Split(content, "\n")
			local header = lines[1] or ""
			local params = string.Split(header, " ")
			local raceName = params[2] or "Unknown"
			local author = header:match("'(.-)'") or "Unknown"

			local checkpoints = {}     -- [id] = { {start=Vector(), endp=Vector()}, ... }
			local idList = {}           -- keeps numeric order of found IDs
			local spawns = {}

			for _, line in ipairs(lines) do
				if string.match(line, "^%d+%s") then
					local t = string.Explode(" ", line)
					local id = tonumber(t[1])
					if id and #t >= 8 then
						if not checkpoints[id] then
							checkpoints[id] = {}
							table.insert(idList, id)
						end
						table.insert(checkpoints[id], {
							start = Vector(tonumber(t[2]), tonumber(t[3]), tonumber(t[4])),
							endp  = Vector(tonumber(t[5]), tonumber(t[6]), tonumber(t[7]))
						})
					end
				elseif string.match(line, "^spawn") then
					local t = string.Explode(" ", line)
					if #t >= 6 then
						table.insert(spawns, Vector(tonumber(t[2]), tonumber(t[3]), tonumber(t[4])))
					end
				end
			end

			table.SortByMember(idList, nil, true)
			table.sort(idList, function(a,b) return a < b end)

			return {
				filename = string.GetFileFromFilename(path),
				name = raceName:Replace("_", " "),
				author = author,
				checkpoints = checkpoints,
				idList = idList,
				spawns = spawns,
			}
		end

		-- === Layout panels ===
		local leftW = showPreview and pw * 0.4 or pw
		local rightW = showPreview and pw - leftW or 0

		-- Left list + info container
		local leftContainer = vgui.Create("DPanel", ImportPanel)
		leftContainer:SetPos(4, ph * 0.1)
		leftContainer:SetSize(leftW - 8, ph - 12)
		leftContainer.Paint = nil

		-- Race list (top 70%)
		local listPanel = vgui.Create("DPanel", leftContainer)
		listPanel:Dock(TOP)
		listPanel:SetTall((ph - 12) * 0.8)
		listPanel.Paint = nil

		local scroll = vgui.Create("DScrollPanel", listPanel)
		scroll:Dock(FILL)

		-- Info panel (bottom 30%)
		local infoPanel = vgui.Create("DPanel", leftContainer)
		infoPanel:Dock(FILL)
		infoPanel.Paint = function(self, w, h)
			if highlightedIndex then
				local data = raceEntries[highlightedIndex]
				local a = math.Clamp(contentAlpha, 0, 255)
				draw.SimpleText(string.format(language.GetPhrase("tool.uvracemanager.import.author"), data.author), "UVMostWantedLeaderboardFont", w * 0.01, 0, Color(255,255,255,a))
				draw.SimpleText(string.format(language.GetPhrase("tool.uvracemanager.import.checkpoints"), #data.checkpoints), "UVMostWantedLeaderboardFont", w * 0.01, h * 0.175, Color(255,255,255,a))
				draw.SimpleText(string.format(language.GetPhrase("tool.uvracemanager.import.gridslot"), #data.spawns), "UVMostWantedLeaderboardFont", w * 0.01, h * 0.35, Color(255,255,255,a))
			end
		end

		-- Right preview area
		local previewPanel
		if showPreview then
			previewPanel = vgui.Create("DPanel", ImportPanel)
			previewPanel:SetPos(leftW, ph * 0.1)
			previewPanel:SetSize(rightW - 6, ph - 12)
	previewPanel.Paint = function(self, w, h)
		local a = math.Clamp(contentAlpha, 0, 255)
		surface.SetDrawColor(20, 20, 20, a)
		surface.DrawRect(0, 0, w, h)

		if not highlightedIndex then
			draw.SimpleText("Select a race to preview", "DermaLarge",
				w * 0.5, h * 0.5, Color(200,200,200,a), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			return
		end

		local race = raceEntries[highlightedIndex]
		local checkpoints, idList, spawns = race.checkpoints, race.idList, race.spawns

		-- === Collect all positions for bounding box ===
		local allPts = {}
		for _, group in pairs(checkpoints) do
			for _, cp in ipairs(group) do
				table.insert(allPts, cp.start)
				table.insert(allPts, cp.endp)
			end
		end
		for _, sp in ipairs(spawns) do table.insert(allPts, sp) end
		if #allPts == 0 then
			draw.SimpleText("No positional data", "DermaLarge", w*0.5, h*0.5,
				Color(255,180,180,a), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			return
		end

		local minx, miny, maxx, maxy = math.huge, math.huge, -math.huge, -math.huge
		for _, v in ipairs(allPts) do
			minx = math.min(minx, v.x)
			miny = math.min(miny, v.y)
			maxx = math.max(maxx, v.x)
			maxy = math.max(maxy, v.y)
		end

		local pad = 0.1  -- 10% padding
		local dx, dy = (maxx - minx), (maxy - miny)
		if dx == 0 then dx = 1 end
		if dy == 0 then dy = 1 end
		local scale = math.min(w / (dx * (1 + pad)), h / (dy * (1 + pad)))
		local ox = w * 0.5 - ((minx + maxx)/2 - minx) * scale
		local oy = h * 0.5 - ((miny + maxy)/2 - miny) * scale

		-- === Utility: convert 3D → 2D preview coords ===
		local function ToScreen(vec)
			return (vec.x - minx) * scale + ox, h - ((vec.y - miny) * scale + oy)
		end


		-- === Utility: draw dashed line ===
		local function DrawDashedLine(x1, y1, x2, y2, dashLen)
			local dx, dy = x2 - x1, y2 - y1
			local dist = math.sqrt(dx*dx + dy*dy)
			local nx, ny = dx / dist, dy / dist
			local drawn = 0
			while drawn < dist do
				local seg = math.min(dashLen, dist - drawn)
				local sx, sy = x1 + nx * drawn, y1 + ny * drawn
				local ex, ey = sx + nx * (seg * 0.5), sy + ny * (seg * 0.5)
				surface.DrawLine(sx, sy, ex, ey)
				drawn = drawn + dashLen
			end
		end

		-- === Draw checkpoint connections ===
		local mainColor = Color(100,180,255,a)
		local secColor  = Color(160,160,160,a)
		local ids = idList
		for i = 1, #ids - 1 do
			local thisID, nextID = ids[i], ids[i+1]
			local thisGroup, nextGroup = checkpoints[thisID], checkpoints[nextID]
			if not thisGroup or not nextGroup then continue end

			local main1 = thisGroup[1].start
			local main2 = nextGroup[1].start
			local x1,y1 = ToScreen(main1)
			local x2,y2 = ToScreen(main2)
			surface.SetDrawColor(mainColor)
			surface.DrawLine(x1, y1, x2, y2)

			-- draw secondary paths (dashed)
			local count = math.min(#thisGroup, #nextGroup)
			for j = 2, count do
				local c1, c2 = thisGroup[j].start, nextGroup[j].start
				local sx,sy = ToScreen(c1)
				local ex,ey = ToScreen(c2)
				surface.SetDrawColor(secColor)
				DrawDashedLine(sx, sy, ex, ey, 10)
			end

			-- if secondary branch has no partner, converge to next main
			if #thisGroup > #nextGroup then
				for j = #nextGroup + 1, #thisGroup do
					local c1 = thisGroup[j].start
					local sx,sy = ToScreen(c1)
					surface.SetDrawColor(secColor)
					DrawDashedLine(sx, sy, x2, y2, 10)
				end
			end
		end

		-- === Draw checkpoint markers ===
		for _, id in ipairs(ids) do
			local group = checkpoints[id]
			if group then
				for j, cp in ipairs(group) do
					local x, y = ToScreen(cp.start)
					local col = (j == 1) and mainColor or secColor
					surface.SetDrawColor(col)
					surface.DrawCircle(x, y, (j == 1) and 3 or 2)
				end
			end
		end

		-- === Draw spawns ===
		if #spawns > 0 then
			for i, sp in ipairs(spawns) do
				local x, y = ToScreen(sp)
				if i == 1 then
					surface.SetDrawColor(255,255,255,a)
					surface.DrawRect(x - 4, y - 4, 8, 8)
					surface.SetDrawColor(80,255,80,a)
					surface.DrawRect(x - 3, y - 3, 6, 6)
				else
					surface.SetDrawColor(80,255,80,a)
					surface.DrawRect(x - 3, y - 3, 6, 6)
				end
			end
		end

		-- === Single-checkpoint notice ===
		if #ids == 1 then
			draw.SimpleText("Single checkpoint track", "DermaLarge", w*0.5, h*0.9,
				Color(255,255,255,a), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
		end
	end

		end
		
		-- === Build race list ===
		local entryTall, entryPad = 35, 1
		if #files == 0 then
			local lbl = vgui.Create("DLabel", ImportPanel)
			lbl:SetText("No races found for this map.")
			lbl:SetFont("DermaLarge")
			lbl:SizeToContents()
			lbl:SetPos((pw - lbl:GetWide()) * 0.5, (ph - lbl:GetTall()) * 0.5)
		else
			for _, fname in ipairs(files) do
				local path = "unitvehicles/races/" .. game.GetMap() .. "/" .. fname
				local rec = ParseRaceFile(path)
				if not rec then continue end
				table.insert(raceEntries, rec)
				local entry = vgui.Create("DButton", scroll)
				entry:SetText("")
				entry:SetTall(entryTall)
				entry:Dock(TOP)
				entry:DockMargin(0,0,0,entryPad)
				entry.Index = #raceEntries

				entry.Paint = function(self, w, h)
					local hovered = self:IsHovered()
					local blink = math.abs(math.sin(RealTime()*3))
					local bg = hovered and Color(80*blink,120*blink,180*blink,contentAlpha) or Color(40,40,40,contentAlpha)
					draw.RoundedBox(4, 0, 0, w, h, bg)
					draw.SimpleText(rec.name, "UVMostWantedLeaderboardFont", w*0.5, h*0.5, Color(255,255,255,contentAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end

				entry.OnCursorEntered = function() highlightedIndex = entry.Index end
				entry.OnCursorExited = function() if selectedIndex ~= entry.Index then highlightedIndex = selectedIndex end end
				entry.DoClick = function()
					selectedIndex, highlightedIndex = entry.Index, entry.Index
					RunConsoleCommand("uvrace_import", rec.filename)
					if not closing then closing = true closeStartTime = CurTime() gui.EnableScreenClicker(false) end
				end
			end
		end

		-- === Cancel button ===
		local cancelBtn = vgui.Create("DButton", ImportPanel)
		cancelBtn:SetText("")
		cancelBtn:SetSize(28,28)
		cancelBtn:SetPos(pw - cancelBtn:GetWide() - 20, cancelBtn:GetTall()*0.25)
		cancelBtn.Paint = function(self,w,h)
			local a = math.Clamp(contentAlpha,0,255)
			draw.SimpleTextOutlined("x","UVMostWantedLeaderboardFont",w*0.5,0,Color(255,255,255,a),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,1,Color(0,0,0,a))
		end
		cancelBtn.DoClick = function()
			if not closing then closing = true closeStartTime = CurTime() gui.EnableScreenClicker(false) end
		end

		-- === Logic/animation (same as before) ===
		ImportPanel.Think = function(self)
			local curTime = CurTime()
			if not closing then
				local reveal = math.Clamp((curTime - contentStart)/0.6,0,1)
				contentAlpha = reveal*255
			end
			if not closing and input.IsMouseDown(MOUSE_LEFT) then
				local mx,my = gui.MousePos()
				local x,y = self:GetPos()
				local w2,h2 = self:GetSize()
				if mx and my and (mx < x or mx > x+w2 or my < y or my > y+h2) then
					closing = true closeStartTime = CurTime() gui.EnableScreenClicker(false)
				end
			end
			if closing then
				scroll:SetMouseInputEnabled(false)
				cancelBtn:SetEnabled(false)
				local elapsed = curTime - closeStartTime
				local fadeDur, shrinkDur = 0.125, 0.15
				local textP = math.Clamp(elapsed/fadeDur,0,1)
				contentAlpha = (1 - textP)*255
				local bgP = math.Clamp((elapsed - fadeDur)/shrinkDur,0,1)
				bgScale = 1 - bgP
				if elapsed >= fadeDur + shrinkDur and IsValid(ImportPanel) then ImportPanel:Close() end
			end
		end

		ImportPanel.Paint = function(self, w, h)
			local curTime = CurTime()
			local elapsed = curTime - bgAnimStart
			local openS = math.Clamp(elapsed/0.2,0,1)
			bgAlpha = math.Clamp((elapsed-0.1)/0.3,0,1)*255
			local shrink = (closing and bgScale) or openS
			local scaledH = h * shrink
			local yOff = (h - scaledH)*0.5
			surface.SetDrawColor(255,255,255,bgAlpha)
			surface.SetMaterial(UVMaterials["RESULTSBG_WORLD"])
			surface.DrawTexturedRect(0,yOff,w,scaledH)
			draw.SimpleTextOutlined("#tool.uvracemanager.import","UVFont5",w*0.5,yOff+scaledH*0.01,Color(225,255,255,contentAlpha),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,3,Color(0,0,0,contentAlpha))
		end

		function ImportPanel:OnClose()
			gui.EnableScreenClicker(false)
		end
	end
	concommand.Add("uvrace_queryimport", QueryImport)

local function RaceMenu()
    -- === Utility: calculate available AI slots ===
    local function GetAvailableAISlots()
        local racerList = UVRace_RacerList or {}
        local spawnCount = #ents.FindByClass("uvrace_spawn") or 0
        local existingAI = #ents.FindByClass("npc_racervehicle") or 0
        local hostAdjustment = 1
        return math.max(spawnCount - (#racerList + existingAI + hostAdjustment), 0)
    end
	
	local availableSlots = GetAvailableAISlots()
	if availableSlots <= 0 then
		-- No AI can be added, start race immediately
		RunConsoleCommand("uvrace_startrace", GetConVar("uvracemanager_laps"):GetString())
		return
	end

    if IsValid(RaceMenuPanel) then RaceMenuPanel:Remove() end

    local sw, sh = ScrW(), ScrH()
    local pw, ph = sw * 0.3, sh * 0.165
    local px, py = (sw - pw) * 0.5, (sh - ph) * 0.5

    RaceMenuPanel = vgui.Create("DFrame")
    RaceMenuPanel:SetSize(pw, ph)
    RaceMenuPanel:SetPos(px, py)
    RaceMenuPanel:SetTitle("")
    RaceMenuPanel:ShowCloseButton(false)
    RaceMenuPanel:SetDraggable(false)
    RaceMenuPanel:MakePopup()
    gui.EnableScreenClicker(true)

    -- Animation variables
    local bgScale, bgAlpha, bgAnimStart = 0, 0, CurTime()
    local contentAlpha, contentStart = 0, CurTime()
    local closing, closeStartTime = false, 0

    -- Current AI spawn count for button 2
    local spawnAmount = 1

    -- === Button creation utility ===
    local function CreateButton(baseText, yPos, callback)
        local btn = vgui.Create("DButton", RaceMenuPanel)
        btn:SetText("")
        btn:SetTall(35)
        btn:SetWide(pw - 16)
        btn:SetPos(8, yPos)
        btn.DoClick = callback

        -- Scroll wheel for spawn adjustment (only used for 2nd button)
        btn.OnMouseWheeled = function(self, delta)
            local maxAI = GetAvailableAISlots()
            spawnAmount = math.Clamp(spawnAmount + delta, 1, maxAI)
            return true
        end

        btn.Paint = function(self,w,h)
            local hovered = self:IsHovered()
            local blink = math.abs(math.sin(RealTime()*3))
            local bg = hovered and Color(80*blink,120*blink,180*blink,contentAlpha) or Color(40,40,40,contentAlpha)

            draw.RoundedBox(4, 0, 0, w, h, bg)

            local text = baseText
            if baseText:find("Add AI") then
                text = string.format(baseText, spawnAmount)
            end

            draw.SimpleText(text, "UVMostWantedLeaderboardFont", w*0.5, h*0.5, Color(255,255,255,contentAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        return btn
    end

    local startY = 55
    local spacing = 40

	-- Button 1: Start Race
	CreateButton("#tool.uvracemanager.settings.racec.start", startY, function()
		RunConsoleCommand("uvrace_startrace", GetConVar("uvracemanager_laps"):GetString())
		closing = true
		closeStartTime = CurTime()
		gui.EnableScreenClicker(false)
	end)

	-- Button 2: Add X AI & Start Race (dynamic)
	-- Current AI spawn amount
	local spawnAmount = 1

	-- Create the button
	local btn2 = vgui.Create("DButton", RaceMenuPanel)
	btn2:SetText("")
	btn2:SetTall(35)
	btn2:SetWide(pw - 16)
	btn2:SetPos(8, startY + spacing)
	
	-- Description panel (to the right of main panel)
	local descText = "#tool.uvracemanager.settings.racec.scrollwh"
	local descFont = "UVMostWantedLeaderboardFont"

	local descPanel = vgui.Create("DPanel")  -- NOTICE: no parent!
	descPanel:SetVisible(false)

	local descHeight = draw.GetFontHeight(descFont) + 12
	descPanel:SetTall(descHeight)
	descPanel:SetWide(RaceMenuPanel:GetWide())

	-- Position it under the menu
	local x, y = RaceMenuPanel:GetPos()
	descPanel:SetPos(x, y + RaceMenuPanel:GetTall() + 2)

	descPanel.Paint = function(self, w, h)
		surface.SetDrawColor(20, 20, 20, 220)
		surface.DrawRect(0, 0, w, h)

		draw.SimpleText(
			descText,
			descFont,
			w * 0.5,
			h * 0.5,
			Color(255,255,255,contentAlpha),
			TEXT_ALIGN_CENTER,
			TEXT_ALIGN_CENTER
		)
	end

	-- === SHOW when hover ===
	btn2.OnCursorEntered = function()
		local x, y = RaceMenuPanel:GetPos()
		descPanel:SetPos(x, y + RaceMenuPanel:GetTall() + 2)
		descPanel:SetWide(RaceMenuPanel:GetWide())
		descPanel:SetVisible(true)
	end

	-- === HIDE when leaving ===
	btn2.OnCursorExited = function()
		descPanel:SetVisible(false)
	end

	-- === HIDE on menu close ===
	local oldClose = RaceMenuPanel.OnClose
	RaceMenuPanel.OnClose = function(self, ...)
		if IsValid(descPanel) then descPanel:Remove() end
		if oldClose then oldClose(self, ...) end
	end

	-- Scroll wheel to adjust spawnAmount
	btn2.OnMouseWheeled = function(self, delta)
		local maxAI = GetAvailableAISlots()
		if maxAI <= 0 then return true end  -- can't scroll if no slots available
		spawnAmount = math.Clamp(spawnAmount + delta, 1, maxAI)
		return true
	end

	-- Button click
	btn2.DoClick = function()
		descPanel:SetVisible(false)
		local existingAI = #ents.FindByClass("npc_racervehicle") or 0
		local availableSlots = GetAvailableAISlots() - existingAI
		spawnAmount = math.Clamp(spawnAmount, 1, availableSlots)

		for i = 1, spawnAmount do
			RunConsoleCommand("uvrace_spawnai")
		end

		timer.Simple(0.5, function()
			RunConsoleCommand("uvrace_startinvite")
		end)

		timer.Simple(2, function()
			RunConsoleCommand("uvrace_startrace", GetConVar("uvracemanager_laps"):GetString())
		end)

		closing = true
		closeStartTime = CurTime()
		gui.EnableScreenClicker(false)
	end

	-- Dynamic text in Paint
	btn2.Paint = function(self, w, h)
		local hovered = self:IsHovered()
		local blink = math.abs(math.sin(RealTime() * 3))
		local bg = hovered and Color(80 * blink, 120 * blink, 180 * blink, contentAlpha) or
						 Color(40, 40, 40, contentAlpha)

		draw.RoundedBox(4, 0, 0, w, h, bg)

		-- Dynamically replace %s with the current spawnAmount
		local text = string.format(language.GetPhrase("tool.uvracemanager.settings.racec.addai"), spawnAmount)

		draw.SimpleText(text, "UVMostWantedLeaderboardFont", w * 0.5, h * 0.5,
			Color(255, 255, 255, contentAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	-- Button 3: Fill Grid with AI & Start Race
	CreateButton("#tool.uvracemanager.settings.racec.fillai", startY + spacing*2, function()
		local racerList = UVRace_RacerList or {}
		local spawnCount = #ents.FindByClass("uvrace_spawn") or 0
		local existingAI = #ents.FindByClass("npc_racervehicle") or 0
		local hostAdjustment = 1

		-- Invite current racers first
		RunConsoleCommand("uvrace_startinvite")

		-- Recalculate available slots
		local neededAI = math.max(spawnCount - (#racerList + existingAI + hostAdjustment), 0)
		for i = 1, neededAI do
			RunConsoleCommand("uvrace_spawnai")
		end

		-- Invite newly spawned AI
		timer.Simple(0.5, function()
			RunConsoleCommand("uvrace_startinvite")
		end)

		-- Start race after 2s
		timer.Simple(2, function()
			RunConsoleCommand("uvrace_startrace", GetConVar("uvracemanager_laps"):GetString())
		end)

		closing = true
		closeStartTime = CurTime()
		gui.EnableScreenClicker(false)
	end)

    -- === Cancel button ===
    local cancelBtn = vgui.Create("DButton", RaceMenuPanel)
    cancelBtn:SetText("")
    cancelBtn:SetSize(28,28)
    cancelBtn:SetPos(pw - 48, 4)
    cancelBtn.Paint = function(self,w,h)
        local a = math.Clamp(contentAlpha,0,255)
        draw.SimpleTextOutlined("x","UVMostWantedLeaderboardFont",w*0.5,0,Color(255,255,255,a),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,1,Color(0,0,0,a))
    end
    cancelBtn.DoClick = function()
        closing = true
        closeStartTime = CurTime()
        gui.EnableScreenClicker(false)
    end

    -- === Animation logic ===
    RaceMenuPanel.Think = function(self)
        local curTime = CurTime()
        if not closing then
            local reveal = math.Clamp((curTime - contentStart)/0.6,0,1)
            contentAlpha = reveal*255
        end
        if not closing and input.IsMouseDown(MOUSE_LEFT) then
            local mx,my = gui.MousePos()
            local x,y = self:GetPos()
            local w2,h2 = self:GetSize()
            if mx and my and (mx < x or mx > x+w2 or my < y or my > y+h2) then
                closing = true
                closeStartTime = CurTime()
                gui.EnableScreenClicker(false)
            end
        end
        if closing then
            contentAlpha = math.Clamp(contentAlpha - FrameTime()*255*8, 0, 255)
            bgScale = math.Clamp(bgScale - FrameTime()*6, 0, 1)
            if bgScale <= 0 and IsValid(RaceMenuPanel) then
                RaceMenuPanel:Close()
            end
        end
    end

    RaceMenuPanel.Paint = function(self, w, h)
        local curTime = CurTime()
        local elapsed = curTime - bgAnimStart
        local openS = math.Clamp(elapsed/0.2,0,1)
        bgAlpha = math.Clamp((elapsed-0.1)/0.3,0,1)*255
        local shrink = (closing and bgScale) or openS
        local scaledH = h * shrink
        local yOff = (h - scaledH)*0.5
        surface.SetDrawColor(255,255,255,bgAlpha)
        surface.SetMaterial(UVMaterials["RESULTSBG_WORLD"])
        surface.DrawTexturedRect(0,yOff,w,scaledH)
        draw.SimpleTextOutlined("#tool.uvracemanager.settings.racec.title","UVFont5",w*0.5,yOff+scaledH*0.01,Color(225,255,255,contentAlpha),TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,3,Color(0,0,0,contentAlpha))
    end

    function RaceMenuPanel:OnClose()
        gui.EnableScreenClicker(false)
    end
end

local function QuerySaveProps(txt)
	Derma_Query(
	    "#tool.uvracemanager.export.props.desc",
	    "#tool.uvracemanager.export.props",
	    "#openurl.yes",
	    function()
			chat.AddText("Exporting UV Race...")
			RunConsoleCommand("uvrace_export", txt, "true") 
		end,
		"#openurl.nope",
		function()
			chat.AddText("Exporting UV Race...")
			RunConsoleCommand("uvrace_export", txt) 
		end
	)
end

concommand.Add("uvrace_racemenu", RaceMenu)

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
		Derma_StringRequest("#tool.uvracemanager.export", "#tool.uvracemanager.export.desc", "", function(txt)
			QuerySaveProps(txt)
		end, nil, "#addons.confirm", "#addons.cancel")
	end
	concommand.Add("uvrace_queryexport", QueryExport)
end

function TOOL:LeftClick(trace)
	if not trace.Hit then return end
	if CLIENT then return end
	local ply = self:GetOwner()
	if not ply:IsSuperAdmin() then return end

	local trHit = trace.HitPos

	local unlocalizedPos, chunk

	if InfMap then
		unlocalizedPos, chunk = InfMap.localize_vector( trace.HitPos )
	end

	local pos = unlocalizedPos or trace.HitPos
	chunk = chunk or Vector()

	local keyPos = self.secondClick and "Pos1" or "Pos0"
	local keyChunk = self.secondClick and "Chunk1" or "Chunk0"

	self[keyPos] = pos
	self[keyChunk] = chunk

	if self.secondClick then
		if ply:KeyDown( IN_USE ) then
			self.Pos1.z = self.Pos1.z + (GetConVar("unitvehicle_cpheight"):GetInt() or 64)
		end

		local cPoint = ents.Create("uvrace_checkpoint")

		local svPos = ( InfMap and InfMap.unlocalize_vector( self.Pos0, self.Chunk0 ) ) or self.Pos0
		local svMaxPos = ( InfMap and InfMap.unlocalize_vector( self.Pos1, self.Chunk1 ) ) or self.Pos1

		cPoint:SetPos(svPos)
		cPoint:SetMaxPos(svMaxPos)

		cPoint:SetLocalPos(self.Pos0)
		cPoint:SetLocalMaxPos(self.Pos1)

		cPoint:SetChunk(self.Chunk0)
		cPoint:SetChunkMax(self.Chunk1)

		if game.SinglePlayer() then
			cPoint:SetSpeedLimit(GetConVar("uvracemanager_speedlimit"):GetInt())
		end

		cPoint:Spawn()

		undo.Create("UVRaceEnt")
		undo.AddEntity(cPoint)
		undo.SetPlayer(ply)
		undo.Finish()
			
		ply:AddCleanup("uvrace_ents", cPoint)
	end

	if self.secondClick then
		self.Pos0 = nil
		self.Chunk0 = nil
		self.Pos1 = nil
		self.Chunk1 = nil
	end

	self:SetStage( self.secondClick and 0 or 1 )
	net.Start("UVRace_UpdatePos")

	net.WriteBool(self.secondClick)
	net.WriteVector(pos)

	net.WriteBool(chunk ~= nil)
	net.WriteVector(chunk)

	net.Send(ply)

	self.secondClick = not self.secondClick

	return true
end

function TOOL:RightClick()
	local ply = self:GetOwner()
	local startpos = ply:EyePos()
	if not ply:IsSuperAdmin() then return end
	
	local tr = util.TraceLine({
		start = startpos,
		endpos = startpos + (ply:GetAimVector() * MAX_TRACE_LENGTH),
		filter = ply
	})
	
	local ent = tr.Entity
	if ent:GetClass() ~= "uvrace_checkpoint" then return end
	
	selectedCP = ent

	net.Start("UVRace_SelectID")
	net.WriteEntity(ent)
	net.Send(self:GetOwner())
	
	return true
end

function TOOL:Reload( trace )
	if not trace.Hit then return end
	local hp = trace.HitPos
	local ply = self:GetOwner()
	if not ply:IsSuperAdmin() then return end
	
	if game.SinglePlayer() or SERVER then
		local spawn = ents.Create("uvrace_spawn")
		spawn:SetAngles(Angle(0, ply:EyeAngles().y, 0))
		spawn:Spawn()

		spawn:SetPos(hp + spawn:LocalToWorld(Vector(spawn:BoundingRadius(), 0, 0)))
		
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
	-- panel:Button("#tool.uvracemanager.settings.racec.start").DoClick = function()
		-- RunConsoleCommand("uvrace_startrace", GetConVar("uvracemanager_laps"):GetString())
	-- end
	panel:AddControl("Button", {Label = "#tool.uvracemanager.settings.racec.start", Command = "uvrace_racemenu"})
	panel:AddControl("Button", {Label = "#tool.uvracemanager.settings.racec.stop", Command = "uvrace_stop"})
	panel:AddControl("Button", {Label = "#tool.uvracemanager.settings.racec.invite", Command = "uvrace_startinvite"})
	
	panel:AddControl("Label", {Text = "#tool.uvracemanager.settings.saveloadrace", Description = "Race"})
	panel:AddControl("Button",  { Label	= "#tool.uvracemanager.settings.loadrace", Command = "uvrace_queryimport" })
	panel:AddControl("Button",  { Label	= "#tool.uvracemanager.settings.saverace", Command = "uvrace_queryexport" })

	panel:AddControl("Label", {Text = "#tool.uvracemanager.settings.raceo"})
	local last_lap_value
	local lap_slider = panel:NumSlider("#tool.uvracemanager.settings.raceo.laps", "uvracemanager_laps", 1, 100, 0)

	local sfxtheme, label = panel:ComboBox( "#tool.uvracemanager.settings.raceo.sfx", "unitvehicle_sfxtheme" )
	local files, folders = file.Find( "sound/uvracesfx/*", "GAME" )
	if folders ~= nil then
		for k, v in pairs(folders) do
			sfxtheme:AddChoice( v )
		end
	end
	
	local last_dnftimer_value
	local dnftimer_slider = panel:NumSlider("#tool.uvracemanager.settings.raceo.dnftimer", "uvracemanager_dnftimer", 0, 90, 0)
	dnftimer_slider.OnValueChanged = function(self, value)
		local value = GetConVar("uvracemanager_dnftimer"):GetInt()
		
		if last_dnftimer_value ~= value then
			RunConsoleCommand("uvrace_updatevars", "unitvehicle_racednftimer", value)
			last_dnftimer_value = value
		end
	end
	panel:AddControl("Label",  { Text	= "#tool.uvracemanager.settings.raceo.dnftimer.desc" })
	
	panel:AddControl("Label", {Text = "#tool.uvracemanager.settings.racecreate"})
	local speed_slider = panel:NumSlider("#tool.uvracemanager.settings.racecreate.speedlimit", "uvracemanager_speedlimit", 1, 500, 0)
	local cpheight_slider = panel:NumSlider("#tool.uvracemanager.settings.racecreate.cpheight", "unitvehicle_cpheight", 1, 500, 0)
	
	panel:AddControl("Label", {Text = "#tool.uvracemanager.settings.clearassets"})
	panel:AddControl("Button", {Label = "#tool.uvracemanager.settings.clearassets.cp", Command = "uvrace_killcps"})
	panel:AddControl("Button", {Label = "#tool.uvracemanager.settings.clearassets.startpos", Command = "uvrace_killspawns"})
	panel:AddControl("Button", {Label = "#tool.uvracemanager.settings.clearassets.all", Command = "uvrace_killall"})
	panel:AddControl("Label", {Text = " "})
	panel:AddControl("Button", {Label = "#tool.uvracemanager.settings.getraceinfo", Command = "uvrace_count" })
	
end

