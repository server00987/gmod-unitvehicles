TOOL.Category = "uv.unitvehicles"
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

	local dvd = DecentVehicleDestination
	
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
			
			if cffunctions then 
				CFtoggleNitrous(v, false)
				CFtoggleSpeedbreaker(v, false)
			end
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

	UVRace_LoadedEntities = {}
	UVRace_LoadedConstraints = {}

	function UVLoadRace( jsonString )
		if type( jsonString ) ~= "string" then return end

		local startchar = string.find( jsonString, '' )
		if ( startchar != nil ) then
			jsonString = string.sub( jsonString, startchar )
		end

		jsonString = jsonString:reverse()
		local startchar = string.find( jsonString, '' )
		if ( startchar != nil ) then
			jsonString = string.sub( jsonString, startchar )
		end
		jsonString = jsonString:reverse()

		local saveArray = util.JSONToTable( jsonString )
		if not saveArray then return end

		if saveArray.Waypoints then
			UVRace_LoadedWaypoints = true
			dvd.Waypoints = table.Copy( saveArray.Waypoints )
			net.Start("Decent Vehicle: Clear waypoints")
			net.Broadcast()
			net.Start("Decent Vehicle: Retrive waypoints")
			dvd.WriteWaypoint(1)
			net.Broadcast()
		end

		for entityId, entityObject in pairs( UVRace_LoadedEntities ) do
			if IsValid( entityObject ) then entityObject:Remove() end
			UVRace_LoadedEntities[entityId] = nil
		end
 
		for entityId, entityObject in pairs( UVRace_LoadedConstraints ) do
			if IsValid( entityObject ) then entityObject:Remove() end
			UVRace_LoadedConstraints[entityId] = nil
		end

		local Entities = table.Copy( saveArray.Entities )
		local Constraints = table.Copy( saveArray.Constraints )

		UVRace_LoadedEntities = UVCreateEntitiesFromTable( Entities )

		for _k, Constraint in pairs( Constraints ) do
			local constraintEnt = nil

			ProtectedCall(function()
				constraintEnt = UVCreateConstraintsFromTable( Constraint, UVRace_LoadedEntities )
			end)

			if IsValid( constraintEnt ) then
				table.insert( UVRace_LoadedConstraints, constraintEnt )
			end
		end
	end

	function UVSaveRace( saveProps, saveDV )
		local AllowedEntities = ents.GetAll()

		for index, entity in ipairs( AllowedEntities ) do
			local shouldBeSaved = gmsave.ShouldSaveEntity( entity, entity:GetSaveTable() )
			local createdByMap = entity:CreatedByMap()
			local isConstraint = entity:IsConstraint()
			local isPursuitBreaker = entity.PursuitBreaker
			local isRoadblock = entity.UVRoadblock
			local isInvalid = not shouldBeSaved or createdByMap or isConstraint or isPursuitBreaker or isRoadblock or not saveProps

			if isInvalid then AllowedEntities[index] = nil end
		end

		table.insert( AllowedEntities, game.GetWorld() )

		local saveArray = duplicator.CopyEnts( AllowedEntities )
		if not saveArray then return end
		--print(saveDV, dvd)
		if saveDV and dvd then
			saveArray.Waypoints = table.Copy( dvd.Waypoints )
		end

		duplicator.FigureOutRequiredAddons( saveArray )
		return util.TableToJSON( saveArray, true )
	end
	
	local function Import(ply, cmd, args)
		if not ply:IsSuperAdmin() then return end
		local filename = "unitvehicles/races/" .. game.GetMap() .. "/" .. args[1]
		if not file.Exists(filename, "DATA") then return end

		if UVRace_LoadedWaypoints then
			--dvd.Waypoints = {}
			--concommand.Run("dv_route_load")
			dvd.LoadWaypoints( 'decentvehicle/' .. game.GetMap() )
			UVRace_LoadedWaypoints = false
		end

		for entityId, entityObject in pairs( UVRace_LoadedEntities ) do
			if IsValid( entityObject ) then entityObject:Remove() end
			UVRace_LoadedEntities[entityId] = nil
		end

		for entityId, entityObject in pairs( UVRace_LoadedConstraints ) do
			if IsValid( entityObject ) then entityObject:Remove() end
			UVRace_LoadedConstraints[entityId] = nil
		end

		local jsonfilename = string.Replace( "unitvehicles/races/" .. game.GetMap() .. "/" .. args[1], ".txt", ".json" )
		if file.Exists(jsonfilename, "DATA") then 
			UVLoadRace( file.Read(jsonfilename) )
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
			end

			undo.AddFunction(function(undoTable, ent)
				if UVRace_LoadedWaypoints then
					--concommand.Run()
					dvd.LoadWaypoints( 'decentvehicle/' .. game.GetMap() )
					UVRace_LoadedWaypoints = false
				end

				for entityId, entityObject in pairs( UVRace_LoadedEntities ) do
					if IsValid( entityObject ) then entityObject:Remove() end
					UVRace_LoadedEntities[entityId] = nil
				end
		
				for entityId, entityObject in pairs( UVRace_LoadedConstraints ) do
					if IsValid( entityObject ) then entityObject:Remove() end
					UVRace_LoadedConstraints[entityId] = nil
				end

				net.Start("UVRace_TrackReady")
					net.WriteString("?")
					net.WriteString("?")
				net.Broadcast()
			end)

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

		--if args[2] then --Save props option
		local jsonfilename = "unitvehicles/races/" .. game.GetMap() .. "/" .. nick .. "." .. name .. ".json"
		local jsonstr = UVSaveRace( args[2] == "true", args[3] == "true" )

		file.Write(jsonfilename, jsonstr)
		--end
		
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

	local files, folders = file.Find( "sound/uvracemusic/*", "GAME" )
	if folders ~= nil then
		if not table.HasValue( folders, GetConVar("unitvehicle_racetheme"):GetString() ) then
			GetConVar("unitvehicle_racetheme"):SetString("default")
		end	
	end
	
	
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
	
	local function QuerySaveProps(txt, exportDv)
		Derma_Query(
			"#tool.uvracemanager.export.props.desc",
			"#tool.uvracemanager.export.props",
			"#openurl.yes",
			function()
				chat.AddText("Exporting UV Race...")
				print(txt, "true", exportDv)
				RunConsoleCommand("uvrace_export", txt, "true", exportDv) 
			end,
			"#openurl.nope",
			function()
				chat.AddText("Exporting UV Race...")
				print(txt, "false", exportDv)
				RunConsoleCommand("uvrace_export", txt, "false", exportDv) 
			end
		)
	end

	local function QueryExport()
		Derma_StringRequest("#uv.tool.export.settings", "#tool.uvracemanager.export.desc", "", function(txt)
			Derma_Query("#tool.uvracemanager.export.dv.desc", "#tool.uvracemanager.export.dv", "#openurl.yes", function()
				QuerySaveProps(txt, "true")
			end, "#openurl.nope", function()
				QuerySaveProps(txt, "false")
			end)
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
	
	panel:AddControl("Label", {Text = "#uv.rm.startrace", Description = "Race"})
	-- panel:AddControl("Button", {Label = "#uv.rm.startrace", Command = "uvrace_startrace"})
	-- panel:Button("#uv.rm.startrace").DoClick = function()
		-- RunConsoleCommand("uvrace_startrace", GetConVar("uvracemanager_laps"):GetString())
	-- end
	panel:AddControl("Button", {Label = "#uv.rm.startrace", Command = "uvrace_racemenu"})
	panel:AddControl("Button", {Label = "#uv.rm.stoprace", Command = "uvrace_stop"})
	panel:AddControl("Button", {Label = "#uv.rm.sendinvite", Command = "uvrace_startinvite"})
	
	panel:AddControl("Label", {Text = "#tool.uvracemanager.settings.saveloadrace", Description = "Race"})
	panel:AddControl("Button",  { Label	= "#uv.rm.loadrace", Command = "uvrace_queryimport" })
	panel:AddControl("Button",  { Label	= "#tool.uvracemanager.settings.saverace", Command = "uvrace_queryexport" })

	panel:AddControl("Label", {Text = "#uv.rm.options"})
	local last_lap_value
	local lap_slider = panel:NumSlider("#uv.rm.options.laps", "uvracemanager_laps", 1, 100, 0)

	local sfxtheme, label = panel:ComboBox( "#uv.rm.options.sfx", "unitvehicle_sfxtheme" )
	local files, folders = file.Find( "sound/uvracesfx/*", "GAME" )
	if folders ~= nil then
		for k, v in pairs(folders) do
			sfxtheme:AddChoice( v )
		end
	end
	
	local last_dnftimer_value
	local dnftimer_slider = panel:NumSlider("#uv.rm.options.dnftimer", "uvracemanager_dnftimer", 0, 90, 0)
	dnftimer_slider.OnValueChanged = function(self, value)
		local value = GetConVar("uvracemanager_dnftimer"):GetInt()
		
		if last_dnftimer_value ~= value then
			RunConsoleCommand("uvrace_updatevars", "unitvehicle_racednftimer", value)
			last_dnftimer_value = value
		end
	end
	panel:AddControl("Label",  { Text	= "#uv.rm.options.dnftimer.desc" })
	
	panel:AddControl("Label", {Text = "#uv.rm.startracereate"})
	local speed_slider = panel:NumSlider("#uv.rm.startracereate.speedlimit", "uvracemanager_speedlimit", 1, 500, 0)
	local cpheight_slider = panel:NumSlider("#uv.rm.startracereate.cpheight", "unitvehicle_cpheight", 1, 500, 0)
	
	panel:AddControl("Label", {Text = "#tool.uvracemanager.settings.clearassets"})
	panel:AddControl("Button", {Label = "#tool.uvracemanager.settings.clearassets.cp", Command = "uvrace_killcps"})
	panel:AddControl("Button", {Label = "#tool.uvracemanager.settings.clearassets.startpos", Command = "uvrace_killspawns"})
	panel:AddControl("Button", {Label = "#tool.uvracemanager.settings.clearassets.all", Command = "uvrace_killall"})
	panel:AddControl("Label", {Text = " "})
	panel:AddControl("Button", {Label = "#tool.uvracemanager.settings.getraceinfo", Command = "uvrace_count" })
	
end

if CLIENT then
	concommand.Add("uvrace_queryimport", function()
		UVMenu.OpenMenu(UVMenu.RaceManagerTrackSelect, true)
	end)
	
	concommand.Add("uvrace_racemenu", function()
		UVMenu.OpenMenu(UVMenu.RaceManagerStartRace, true)
	end)
end