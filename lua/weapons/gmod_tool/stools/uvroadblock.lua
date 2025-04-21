TOOL.Category		=	"Unit Vehicles"
TOOL.Name			=	"#Roadblocks"
TOOL.Command		=	nil
TOOL.ConfigName		=	""

local rbtable = {
	"Vehicle",
	"Concrete Barrier",
	"Barricade",
	"Sawhorse Barricade",
	"Barrel",
	"Cone",
	"Spikestrip",
}

TOOL.ClientConVar["maxrb"] = 1
TOOL.ClientConVar["type"] = rbtable[1]
TOOL.ClientConVar["override"] = 0

local conVarsDefault = TOOL:BuildConVarList()

if SERVER then
	util.AddNetworkString( "UVRoadblocksAdjust" )
	util.AddNetworkString( "UVRoadblocksRetrieve" )
	util.AddNetworkString( "UVRoadblocksCreate" )
	util.AddNetworkString( "UVRoadblocksRefresh" )
	util.AddNetworkString( "UVRoadblocksLoad" )
	util.AddNetworkString( "UVRoadblocksLoadAll" )

	net.Receive("UVRoadblocksRetrieve", function( length, ply )
		ply.UVRBTOOLMemory = net.ReadTable()
		ply:SelectWeapon( "gmod_tool" )
	end)

	net.Receive("UVRoadblocksCreate", function( length, ply )
		if next(ply.UVRBTOOLMemory) == nil then return end

		local name = net.ReadString()
		local angle = net.ReadAngle()
		local heatlevel = net.ReadInt(8)
		local disperse = net.ReadBool()

		local keyangle = "Angle"
		local keyheat = "HeatLevel"
		local keydisperse = "DisperseAfterPassing"

		ply.UVRBTOOLMemory[keyangle] = angle
		ply.UVRBTOOLMemory[keyheat] = heatlevel
		ply.UVRBTOOLMemory[keydisperse] = disperse

		local jsondata = util.TableToJSON(ply.UVRBTOOLMemory)
		file.Write("unitvehicles/roadblocks/"..game.GetMap().."/"..name..".json", jsondata)
		PrintMessage( HUD_PRINTTALK, "Roadblock "..name.." has been created for "..game.GetMap().."!" )
		net.Start("UVRoadblocksRefresh")
		net.Send(ply)

	end)

	net.Receive("UVRoadblocksLoad", function( length, ply )
		local jsonfile = net.ReadString()
		UVLoadRoadblock(jsonfile, true)
	end)

	net.Receive("UVRoadblocksLoadAll", function( length, ply )
		local saved_roadblocks = file.Find("unitvehicles/roadblocks/"..game.GetMap().."/*.json", "DATA")
		for k,v in pairs(saved_roadblocks) do
			UVLoadRoadblock(v, true)
		end
	end)
	
end

if CLIENT then

	TOOL.Information = {
		{ name = "info"},
		{ name = "left" },
		{ name = "right" },
		{ name = "reload" },
	}

	language.Add("tool.uvroadblock.name", "Roadblocks")
	language.Add("tool.uvroadblock.desc", "Create and manage custom Roadblocks for this map!")
	language.Add("tool.uvroadblock.0", "Build a roadblock anywhere on this map (make sure it's welded together)! When done, right-click it!" )
	language.Add("tool.uvroadblock.left", "Spawns the selected roadblock prop" )
	language.Add("tool.uvroadblock.right", "Saves the roadblock as a roadblock for this map. The Roadblock icon created is where you right-click it" )
	language.Add("tool.uvroadblock.reload", "Change the roadblock type" )

	local selecteditem	= nil
	local UVRBTOOLMemory = {}
	
	net.Receive("UVRoadblocksRetrieve", function( length )
		UVRBTOOLMemory = net.ReadTable()
	end)

	net.Receive("UVRoadblocksAdjust", function()
		local RoadblocksAdjust = vgui.Create("DFrame")
		local OK = vgui.Create("DButton")

		RoadblocksAdjust:Add(OK)
		RoadblocksAdjust:SetSize(500, 220)
		RoadblocksAdjust:SetBackgroundBlur(true)
		RoadblocksAdjust:Center()
		RoadblocksAdjust:SetTitle("Name Roadblock")
		RoadblocksAdjust:SetDraggable(false)
		RoadblocksAdjust:MakePopup()

		local Intro = vgui.Create( "DLabel", RoadblocksAdjust )
		Intro:SetPos( 20, 40 )
		Intro:SetText( "You've selected a roadblock with "..UVRBTOOLMemory.PropCount.." entities!\n- The Roadblock icon created is where you right-clicked just now and where you were facing." )
		Intro:SizeToContents()

		local RoadblocksNameEntry = vgui.Create( "DTextEntry", RoadblocksAdjust )
		RoadblocksNameEntry:SetPos( 20, 80 )
		RoadblocksNameEntry:SetPlaceholderText( "ex. bridge_tacticalroadblock" )
		RoadblocksNameEntry:SetSize(RoadblocksAdjust:GetWide() / 2, 22)

		local RoadblockHeatLevel = vgui.Create( "DNumSlider", RoadblocksAdjust )
		RoadblockHeatLevel:SetPos( 20, 120 )
		RoadblockHeatLevel:SetText( "Min Heat Level" )
		RoadblockHeatLevel:SetTooltip( "At which Heat Level does this roadblock start to appear (assuming roadblocks are enabled for that Heat Level)?" )
		RoadblockHeatLevel:SetMin( 1 )
		RoadblockHeatLevel:SetMax( 6 )
		RoadblockHeatLevel:SetDecimals( 0 )
		RoadblockHeatLevel:SetValue( 1 )
		RoadblockHeatLevel:SetSize(RoadblocksAdjust:GetWide(), 22)

		local DisperseAfterPassing = vgui.Create( "DCheckBoxLabel", RoadblocksAdjust )
		DisperseAfterPassing:SetPos( 20, 160 )
		DisperseAfterPassing:SetText( "Disperse after passing" )
		DisperseAfterPassing:SetTooltip( "If checked, roadblock units will disperse (join the pursuit) after being passed." )
		DisperseAfterPassing:SetValue( false )

		local RoadblockAngle = LocalPlayer():EyeAngles()

		OK:SetText("Create Roadblock")
		OK:SetSize(RoadblocksAdjust:GetWide() * 5 / 16, 22)
		OK:Dock(BOTTOM)

		function OK:DoClick()

			local Name = RoadblocksNameEntry:GetValue()
					
			if Name ~= "" then

				net.Start("UVRoadblocksCreate")
				net.WriteString(Name)
				net.WriteAngle(RoadblockAngle)
				net.WriteInt(RoadblockHeatLevel:GetValue(), 8)
				net.WriteBool(DisperseAfterPassing:GetChecked())
				net.SendToServer() --Create Roadblock
				
				UVRoadblocksScrollPanel:Clear() 
				UVRoadblocksGetSaves( UVRoadblocksScrollPanel )
				RoadblocksAdjust:Close()
				surface.PlaySound( "buttons/button15.wav" )

			else
				RoadblocksNameEntry:SetPlaceholderText( "!!! FILL ME UP !!!" )
				surface.PlaySound( "buttons/button10.wav" )
			end
			
		end
	end)

	net.Receive("UVRoadblocksRefresh", function( length )
		UVRoadblocksScrollPanel:Clear()
		UVRoadblocksGetSaves( UVRoadblocksScrollPanel )
	end)

	function UVRoadblocksGetSaves( panel )
		local saved_roadblocks = file.Find("unitvehicles/roadblocks/"..game.GetMap().."/*.json", "DATA")
		local index = 0
		local highlight = false
		local offset = 22
		
		for k,v in pairs(saved_roadblocks) do
			local printname = v

			if not selecteditem then
				selecteditem = printname
			end
			
			local Button = vgui.Create( "DButton", panel )
			Button:SetText( printname )
			Button:SetTextColor( Color( 255, 255, 255 ) )
			Button:SetPos( 0,index * offset)
			Button:SetSize( 280, offset )
			Button.highlight = highlight
			Button.printname = printname
			Button.Paint = function( self, w, h )
				
				local c_selected = Color( 128, 185, 128, 255 )
				local c_normal = self.highlight and Color( 108, 111, 114, 200 ) or Color( 77, 80, 82, 200 )
				local c_hovered = Color( 41, 128, 185, 255 )
				local c_ = (selecteditem == self.printname) and c_selected or (self:IsHovered() and c_hovered or c_normal)
				
				draw.RoundedBox( 5, 1, 1, w - 2, h - 1, c_ )
			end
			Button.DoClick = function( self )
				selecteditem = self.printname
				if isstring(selecteditem) then

					if !LocalPlayer():IsSuperAdmin() then
						notification.AddLegacy( "You need to be a super admin to apply settings!", NOTIFY_ERROR, 5 )
						surface.PlaySound( "buttons/button10.wav" )
						return
					end

					SetClipboardText(selecteditem)

					net.Start("UVRoadblocksLoad")
					net.WriteString(selecteditem)
					net.SendToServer()
					notification.AddLegacy( "Roadblock "..selecteditem.." loaded!", NOTIFY_UNDO, 5 )
					surface.PlaySound( "buttons/button15.wav" )
					
				end
			end
			
			index = index + 1
			highlight = not highlight
		end
	end

	function TOOL.BuildCPanel(CPanel)
		if not file.Exists( "unitvehicles/roadblocks/"..game.GetMap(), "DATA" ) then
			file.CreateDir( "unitvehicles/roadblocks/"..game.GetMap() )
			print("Created a Roadblock data file for "..game.GetMap().."!")
		end

		local applysettings = vgui.Create("DButton")
		applysettings:SetText("Apply Settings")
		applysettings.DoClick = function()
			if !LocalPlayer():IsSuperAdmin() then
				notification.AddLegacy( "You need to be a super admin!", NOTIFY_ERROR, 5 )
				surface.PlaySound( "buttons/button10.wav" )
				return
			end

			--Run Console Command
			RunConsoleCommand("unitvehicle_roadblock_maxrb", GetConVar("uvroadblock_maxrb"):GetInt())
			RunConsoleCommand("unitvehicle_roadblock_override", GetConVar("uvroadblock_override"):GetInt())

			local convar_table = {}

			convar_table['unitvehicle_roadblock_maxrb'] = GetConVar("uvroadblock_maxrb"):GetInt()
			convar_table['unitvehicle_roadblock_override'] = GetConVar("uvroadblock_override"):GetInt()

			net.Start("UVUpdateSettings")
			net.WriteTable(convar_table)
			net.SendToServer()

			notification.AddLegacy( "Roadblock Settings Applied!", NOTIFY_UNDO, 5 )
			surface.PlaySound( "buttons/button15.wav" )
			Msg( "Roadblock Settings Applied!\n" )
		end
		CPanel:AddItem(applysettings)
	
		CPanel:AddControl("ComboBox", {
			MenuButton = 1,
			Folder = "roadblocks",
			Options = {
				["#preset.default"] = conVarsDefault
			},
			CVars = table.GetKeys(conVarsDefault)
		})
	
		CPanel:AddControl("Label", {
			Text = "***PRESS 'APPLY SETTINGS' ABOVE FOR CHANGES TO TAKE EFFECT!***",
		})

		CPanel:AddControl("Label", {
			Text = "——— ROADBLOCKS FOR THIS MAP ———\n\n- Click on the Roadblock below to load it.\n- Empty? Build a roadblock and right-click it to save it as a Roadblock!",
		})

		local Frame = vgui.Create( "DFrame" )
		Frame:SetSize( 280, 320 )
		Frame:SetTitle( "" )
		Frame:SetVisible( true )
		Frame:ShowCloseButton( false )
		Frame:SetDraggable( false )
		Frame.Paint = function( self, w, h )
			draw.RoundedBox( 5, 0, 0, w, h, Color( 115, 115, 115, 255 ) )
			draw.RoundedBox( 5, 1, 1, w - 2, h - 2, Color( 0, 0, 0) )
		end
		CPanel:AddItem(Frame)

		UVRoadblocksScrollPanel = vgui.Create( "DScrollPanel", Frame )
		UVRoadblocksScrollPanel:SetSize( 280, 320 )
		UVRoadblocksScrollPanel:SetPos( 0, 0 )
		
		UVRoadblocksGetSaves( UVRoadblocksScrollPanel )

		local MarkAll = vgui.Create( "DButton", CPanel )
		MarkAll:SetText( "Mark All Locations (10 s)" )
		MarkAll:SetSize( 280, 20 )
		MarkAll.DoClick = function( self )
			UVMarkAllLocations()
			notification.AddLegacy( "Marked all roadblock locations!", NOTIFY_UNDO, 10 )
			surface.PlaySound( "buttons/button15.wav" )
		end
		CPanel:AddItem(MarkAll)

		local LoadAll = vgui.Create( "DButton", CPanel )
		LoadAll:SetText( "Load All (MIND THE LAG)" )
		LoadAll:SetSize( 280, 20 )
		LoadAll.DoClick = function( self )
			if !LocalPlayer():IsSuperAdmin() then
				notification.AddLegacy( "You need to be a super admin!", NOTIFY_ERROR, 5 )
				surface.PlaySound( "buttons/button10.wav" )
				return
			end
			net.Start("UVRoadblocksLoadAll")
			net.SendToServer()
			notification.AddLegacy( "Loaded all roadblocks!", NOTIFY_UNDO, 5 )
			surface.PlaySound( "buttons/button15.wav" )
		end
		CPanel:AddItem(LoadAll)

		local Refresh = vgui.Create( "DButton", CPanel )
		Refresh:SetText( "Refresh" )
		Refresh:SetSize( 280, 20 )
		Refresh.DoClick = function( self )
			UVRoadblocksScrollPanel:Clear()
			selecteditem = nil
			UVRoadblocksGetSaves( UVRoadblocksScrollPanel )
			notification.AddLegacy( "Roadblock(s) refreshed!", NOTIFY_UNDO, 5 )
			surface.PlaySound( "buttons/button15.wav" )
		end
		CPanel:AddItem(Refresh)

		local Delete = vgui.Create( "DButton", CPanel )
		Delete:SetText( "Delete" )
		Delete:SetSize( 280, 20 )
		Delete.DoClick = function( self )
			
			if isstring(selecteditem) then
				file.Delete( "unitvehicles/roadblocks/"..game.GetMap().."/"..selecteditem )
				notification.AddLegacy( "Deleted "..selecteditem.."!", NOTIFY_UNDO, 5 )
				surface.PlaySound( "buttons/button15.wav" )
				Msg( "Roadblock "..selecteditem.." has been deleted!\n" )
			end
			
			UVRoadblocksScrollPanel:Clear()
			selecteditem = nil
			UVRoadblocksGetSaves( UVRoadblocksScrollPanel )
		end
		CPanel:AddItem(Delete)

		CPanel:AddControl("Label", {
			Text = "——— SETTINGS ———",
		})

		local MaxRB = vgui.Create( "DNumSlider", CPanel )
		MaxRB:SetText( "Max Loaded RB(s)" )
		MaxRB:SetTooltip( "How many Roadblocks can be loaded at once? Set this to 0 to disable Roadblocks from spawning." )
		MaxRB:SetMin( 0 )
		MaxRB:SetMax( 10 )
		MaxRB:SetDecimals( 0 )
		MaxRB:SetConVar( "uvroadblock_maxrb" )
		CPanel:AddItem(MaxRB)

		local Override = vgui.Create( "DNumSlider", CPanel )
		Override:SetText( "Override Disperse" )
		Override:SetTooltip( "0 = Off\n1 = All roadblock units will disperse\n2 = All roadblock units will NOT disperse" )
		Override:SetMin( 0 )
		Override:SetMax( 2 )
		Override:SetDecimals( 0 )
		Override:SetConVar( "uvroadblock_override" )
		CPanel:AddItem(Override)

		CPanel:AddControl("Label", {
			Text = "0 = Off\n1 = All roadblock units will disperse\n2 = All roadblock units will NOT disperse",
		})
			
	end

	local toolicon = Material( "hud/(8)roadblock.png", "ignorez" )

	function TOOL:DrawToolScreen(width, height)

		local ptselected = self:GetClientInfo("type")
	
		surface.SetDrawColor( Color( 0, 0, 0) )
		surface.DrawRect( 0, 0, width, height )
	
		surface.SetDrawColor( 0, 0, 255, 25)
		surface.SetMaterial( toolicon )
		surface.DrawTexturedRect( 0, 0, width, height )
		
		draw.SimpleText( ptselected, "DermaLarge", width / 2, height / 2, Color( 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	
	end

end

function TOOL:RightClick(trace)
    if CLIENT then return true end
	
	local ent = trace.Entity
	local ply = self:GetOwner()
		
	if not istable(ply.UVRBTOOLMemory) then 
		ply.UVRBTOOLMemory = {}
	end
	
	if (ent:GetClass() != "prop_physics" and ent:GetClass() != "entity_uvspikestrip" and ent:GetClass() != "entity_uvroadblockcar") then return false end
	
	self:GetRoadblocksData( ent, ply, trace.HitPos )

	net.Start("UVRoadblocksAdjust")
	net.Send(ply)
	
	return true
end

function TOOL:LeftClick( trace )
	if CLIENT then return true end

	local rbselected = self:GetClientInfo("type")
	local ply = self:GetOwner()
	local tr = ply:GetEyeTrace()
	local ANGZ = ply:EyeAngles()

	local proptable = {
		["Vehicle"] = "entity_uvroadblockcar",
		["Concrete Barrier"] = "prop_physics",
		["Barricade"] = "prop_physics",
		["Sawhorse Barricade"] = "prop_physics",
		["Barrel"] = "prop_physics",
		["Cone"] = "prop_physics",
		["Spikestrip"] = "entity_uvspikestrip"
	}

	local modeltable = {
		["Concrete Barrier"] = "models/props_phx/construct/concrete_barrier01.mdl",
		["Barricade"] = "models/unitvehiclesprops/roadblock_gate/roadblock_gate.mdl",
		["Sawhorse Barricade"] = "models/unitvehiclesprops/woodenbarriers/prop_brk_sawhorse_01_cops_mesh.mdl",
		["Barrel"] = "models/unitvehiclesprops/policebigcone/prop_brk_cones_big_cops_mesh.mdl",
		["Cone"] = "models/unitvehiclesprops/policesmallcone/policesmallcone.mdl",
	}

	local modelangles = {
		["Vehicle"] = Angle(0,ANGZ.y,0),
		["Concrete Barrier"] = Angle(180,ANGZ.y+90,180),
		["Barricade"] = Angle(180,ANGZ.y,180),
		["Sawhorse Barricade"] = Angle(180,ANGZ.y-90,180),
		["Barrel"] = Angle(180,ANGZ.y,180),
		["Cone"] = Angle(180,ANGZ.y+90,180),
		["Spikestrip"] = Angle(180,ANGZ.y+90,180)
	}

	--Spawn a spikestrip
    local prop = ents.Create(proptable[rbselected])
	if prop:GetClass() != "entity_uvspikestrip" and prop:GetClass() != "entity_uvroadblockcar" then
		prop:SetModel(modeltable[rbselected])
	end
    prop:SetPos(tr.HitPos+Vector(0,0,1))
	prop:SetAngles(modelangles[rbselected])
	prop:Spawn()
	prop.PhysgunDisabled = false
	prop:GetPhysicsObject():EnableMotion(true)

	undo.Create(rbselected)
	 	undo.AddEntity(prop)
	 	undo.SetPlayer(ply)
	undo.Finish()
		
	return true
end

function TOOL:Reload( trace )
	if CLIENT then return false end

	local rbselected = self:GetClientInfo("type")
	
	if rbselected == rbtable[#rbtable] then
		self:GetOwner():ChatPrint("Roadblock type changed to "..rbtable[1])
		self:GetOwner():ConCommand("uvroadblock_type "..rbtable[1])
	else
		for k,v in pairs(rbtable) do
			if v == rbselected then
				self:GetOwner():ChatPrint("Roadblock type changed to "..rbtable[k+1])
				self:GetOwner():ConCommand("uvroadblock_type "..rbtable[k+1])
			end
		end
	end

	return false
end

function TOOL:GetRoadblocksData( ent, ply, location )
	if not IsValid(ent) then return end
	if not istable(ply.UVRBTOOLMemory) then ply.UVRBTOOLMemory = {} end

	ply.UVRBTOOLMemory = duplicator.Copy( ent )

	local Key = "Location"
	ply.UVRBTOOLMemory[Key] = location

	if not IsValid( ply ) then return end

	local clientrbtoolmemory = {
		PropCount = table.Count(ply.UVRBTOOLMemory.Entities),
		ConstraintCount = table.Count(ply.UVRBTOOLMemory.Constraints),
		VectorsMins = Vector(ply.UVRBTOOLMemory.Mins),
		VectorsMaxs = Vector(ply.UVRBTOOLMemory.Maxs),
	}
	
	net.Start("UVRoadblocksRetrieve")
	net.WriteTable( clientrbtoolmemory )
	net.Send( ply )

end
