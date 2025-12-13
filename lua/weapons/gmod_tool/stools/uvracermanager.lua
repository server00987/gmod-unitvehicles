TOOL.Category		=	"uv.unitvehicles"
TOOL.Name			=	"#tool.uvracermanager.name"
TOOL.Command		=	nil
TOOL.ConfigName		=	""

TOOL.ClientConVar["vehiclebase"] = 1
TOOL.ClientConVar["assignracers"] = 0
TOOL.ClientConVar["racers"] = ""
TOOL.ClientConVar["spawncondition"] = 1
TOOL.ClientConVar["maxracer"] = 3

local conVarsDefault = TOOL:BuildConVarList()

UVRacerManagerTool = UVRacerManagerTool or {}

if SERVER then
	
	net.Receive("UVRacerManagerGetRacerInfo", function( length, ply )
		ply.UVRacerTOOLMemory = net.ReadTable()
		ply:SelectWeapon( "gmod_tool" )
	end)

end

if CLIENT then
	
	TOOL.Information = {
		{ name = "info"},
		{ name = "left" },
		{ name = "right" },
	}
	
	local selecteditem = nil
	local UVRacerTOOLMemory = {}
	
	net.Receive("UVRacerManagerGetRacerInfo", function( length )
		UVRacerTOOLMemory = net.ReadTable()
		--PrintTable(UVRacerTOOLMemory)
	end)
	
	net.Receive("UVRacerManagerAdjustRacer", function()
		local RacerAdjust = vgui.Create("DFrame")
		local OK = vgui.Create("DButton")
		local lang = language.GetPhrase
		
		RacerAdjust:Add(OK)
		RacerAdjust:SetSize(600, 300)
		RacerAdjust:SetBackgroundBlur(true)
		RacerAdjust:Center()
		RacerAdjust:SetTitle("#tool.uvracermanager.create")
		RacerAdjust:SetDraggable(false)
		RacerAdjust:MakePopup()
		
		local Intro = vgui.Create( "DLabel", RacerAdjust )
		Intro:SetPos( 20, 40 )
		Intro:SetText( string.format( lang("uv.tool.create.base"), UVRacerTOOLMemory.VehicleBase ) )
		Intro:SizeToContents()
		
		local Intro2 = vgui.Create( "DLabel", RacerAdjust )
		Intro2:SetPos( 20, 60 )
		Intro2:SetText( string.format( lang("uv.tool.create.rawname"), UVRacerTOOLMemory.SpawnName ) )
		Intro2:SizeToContents()
		
		local Intro3 = vgui.Create( "DLabel", RacerAdjust )
		Intro3:SetPos( 20, 100 )
		Intro3:SetText( "#uv.tool.create.uniquename" )
		Intro3:SizeToContents()
		
		local RacerNameEntry = vgui.Create( "DTextEntry", RacerAdjust )
		RacerNameEntry:SetPos( 20, 120 )
		RacerNameEntry:SetPlaceholderText( "#tool.uvracermanager.create.name" )
		RacerNameEntry:SetSize(RacerAdjust:GetWide() / 2, 22)
		
		local SaveColour = vgui.Create("DCheckBoxLabel", RacerAdjust )
		SaveColour:SetPos( 20, 160 )
		SaveColour:SetText("#uv.tool.savecol")
		SaveColour:SetSize(RacerAdjust:GetWide(), 22)
		
		OK:SetText("#uv.tool.create")
		OK:SetSize(RacerAdjust:GetWide() * 5 / 16, 22)
		OK:Dock(BOTTOM)
		
		function OK:DoClick()
			
			local Name = RacerNameEntry:GetValue()
			local Color = SaveColour:GetChecked() == true or nil

			if Color then
				UVRacerTOOLMemory.SaveColor = true
			end
			
			if Name ~= "" then
				if UVRacerTOOLMemory.VehicleBase == "gmod_sent_vehicle_fphysics_base" then
					local DataString = ""
					
					for k,v in pairs(UVRacerTOOLMemory) do
						if k == "SubMaterials" then
							local mats = ""
							local first = true
							for k, v in pairs( v ) do
								if first then
									first = false
									mats = mats..v
								else
									mats = mats..","..v
								end
							end
							DataString = DataString..k.."="..mats.."#"
						else
							DataString = DataString..k.."="..tostring( v ).."#"
						end
					end
					
					local words = string.Explode( "", DataString )
					local shit = {}
					
					for k, v in pairs( words ) do
						shit[k] =  string.char( string.byte( v ) + 20 )
					end
					
					file.Write("unitvehicles/simfphys/racers/"..Name..".txt", string.Implode("",shit) )
				elseif UVRacerTOOLMemory.VehicleBase == "base_glide_car" or UVRacerTOOLMemory.VehicleBase == "base_glide_motorcycle" then
					local jsondata = util.TableToJSON(UVRacerTOOLMemory)
					file.Write("unitvehicles/glide/racers/"..Name..".json", jsondata )
				elseif UVRacerTOOLMemory.VehicleBase == "prop_vehicle_jeep" then
					local DataString = ""
					
					for k,v in pairs(UVRacerTOOLMemory) do
						if k == "SubMaterials" then
							local mats = ""
							local first = true
							for k, v in pairs( v ) do
								if first then
									first = false
									mats = mats..v
								else
									mats = mats..","..v
								end
							end
							DataString = DataString..k.."="..mats.."#"
						else
							DataString = DataString..k.."="..tostring( v ).."#"
						end
					end
					
					local words = string.Explode( "", DataString )
					local shit = {}
					
					for k, v in pairs( words ) do
						shit[k] =  string.char( string.byte( v ) + 20 )
					end
					
					file.Write("unitvehicles/prop_vehicle_jeep/racers/"..Name..".txt", string.Implode("",shit) )
				end

				local baseId = GetConVar("uvracermanager_vehiclebase"):GetInt()
				if IsValid(UVRacerManagerTool.ScrollPanel) and UVRacerManagerTool.PopulateVehicleList then
					UVRacerManagerTool.PopulateVehicleList(baseId)
				end
				RacerAdjust:Close()
				
				notification.AddLegacy( string.format( lang("uv.tool.saved"), Name ), NOTIFY_UNDO, 5 )
				-- Msg( "Saved "..Name.." as a Racer!\n" )
				
				surface.PlaySound( "buttons/button15.wav" )
				
			else
				RacerNameEntry:SetPlaceholderText( "!!! FILL ME UP !!!" )
				surface.PlaySound( "buttons/button10.wav" )
			end
			
		end
	end)
	
	function UVRacerManagerGetSaves( panel )
		local saved_vehicles = file.Find("unitvehicles/simfphys/racers/*.txt", "DATA")
		local index = 0
		local highlight = false
		local offset = 22
		
		for k,v in pairs(saved_vehicles) do
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
					
					SetClipboardText(selecteditem)
					
					local DataString = file.Read( "unitvehicles/simfphys/racers/"..selecteditem, "DATA" )
					
					local words = string.Explode( "", DataString )
					local shit = {}
					
					for k, v in pairs( words ) do
						shit[k] =  string.char( string.byte( v ) - 20 )
					end
					
					local Data = string.Explode( "#", string.Implode("",shit) )
					
					table.Empty( UVRacerTOOLMemory )
					
					for _,v in pairs(Data) do
						local Var = string.Explode( "=", v )
						local name = Var[1]
						local variable = Var[2]
						
						if name and variable then
							if name == "SubMaterials" then
								UVRacerTOOLMemory[name] = {}
								
								local submats = string.Explode( ",", variable )
								for i = 0, (table.Count( submats ) - 1) do
									UVRacerTOOLMemory[name][i] = submats[i+1]
								end
							else
								UVRacerTOOLMemory[name] = variable
							end
						end
					end
					
					net.Start("UVRacerManagerGetRacerInfo")
					net.WriteTable( UVRacerTOOLMemory )
					net.SendToServer()
				end
			end
			
			index = index + 1
			highlight = not highlight
		end
	end
	
	function UVRacerManagerGetSavesGlide( panel )
		local saved_vehicles = file.Find("unitvehicles/glide/racers/*.json", "DATA")
		local index = 0
		local highlight = false
		local offset = 22
		
		for k,v in pairs(saved_vehicles) do
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
					
					SetClipboardText(selecteditem)
					
					local JSONData = file.Read( "unitvehicles/glide/racers/"..selecteditem, "DATA" )
					if not JSONData then return end
					
					UVRacerTOOLMemory = util.JSONToTable(JSONData, true)
					
					net.Start("UVRacerManagerGetRacerInfo")
					net.WriteTable( UVRacerTOOLMemory )
					net.SendToServer()
				end
			end
			
			index = index + 1
			highlight = not highlight
		end
	end
	
	function UVRacerManagerGetSavesJeep( panel )
		local saved_vehicles = file.Find("unitvehicles/prop_vehicle_jeep/racers/*.txt", "DATA")
		local index = 0
		local highlight = false
		local offset = 22
		
		for k,v in pairs(saved_vehicles) do
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
					
					SetClipboardText(selecteditem)
					
					local DataString = file.Read( "unitvehicles/prop_vehicle_jeep/racers/"..selecteditem, "DATA" )
					
					local words = string.Explode( "", DataString )
					local shit = {}
					
					for k, v in pairs( words ) do
						shit[k] =  string.char( string.byte( v ) - 20 )
					end
					
					local Data = string.Explode( "#", string.Implode("",shit) )
					
					table.Empty( UVRacerTOOLMemory )
					
					for _,v in pairs(Data) do
						local Var = string.Explode( "=", v )
						local name = Var[1]
						local variable = Var[2]
						
						if name and variable then
							if name == "SubMaterials" then
								UVRacerTOOLMemory[name] = {}
								
								local submats = string.Explode( ",", variable )
								for i = 0, (table.Count( submats ) - 1) do
									UVRacerTOOLMemory[name][i] = submats[i+1]
								end
							else
								UVRacerTOOLMemory[name] = variable
							end
						end
					end
					
					net.Start("UVRacerManagerGetRacerInfo")
					net.WriteTable( UVRacerTOOLMemory )
					net.SendToServer()
				end
			end
			
			index = index + 1
			highlight = not highlight
		end
	end
	
	function TOOL.BuildCPanel(CPanel)
		local lang = language.GetPhrase
		
		if not file.Exists( "unitvehicles/glide/racers", "DATA" ) then
			file.CreateDir( "unitvehicles/glide/racers" )
			print("Created a Glide data file for the Racer Vehicles!")
		end
		
		if not file.Exists( "unitvehicles/simfphys/racers", "DATA" ) then
			file.CreateDir( "unitvehicles/simfphys/racers" )
			print("Created a simfphys data file for the Racer Vehicles!")
		end
		
		if not file.Exists( "unitvehicles/prop_vehicle_jeep/racers", "DATA" ) then
			file.CreateDir( "unitvehicles/prop_vehicle_jeep/racers" )
			print("Created a Default Vehicle Base data file for the Racer Vehicles!")
		end
		
		CPanel:AddControl("ComboBox", {
			MenuButton = 1,
			Folder = "racers",
			Options = {
				["#preset.default"] = conVarsDefault
			},
			CVars = table.GetKeys(conVarsDefault)
		})
		
		local applysettings = vgui.Create("DButton")
		applysettings:SetText("#spawnmenu.savechanges")
		applysettings.DoClick = function()
			if not LocalPlayer():IsSuperAdmin() then
				notification.AddLegacy( "#uv.superadmin.settings", NOTIFY_ERROR, 5 )
				surface.PlaySound( "buttons/button10.wav" )
				return
			end
			
			local convar_table = {}
			
			convar_table['unitvehicle_racer_vehiclebase'] = GetConVar('uvracermanager_vehiclebase'):GetInt()
			convar_table['unitvehicle_racer_assignracers'] = GetConVar('uvracermanager_assignracers'):GetInt()
			convar_table['unitvehicle_racer_racers'] = GetConVar('uvracermanager_racers'):GetString()
			convar_table['unitvehicle_racer_spawncondition'] = GetConVar('uvracermanager_spawncondition'):GetInt()
			convar_table['unitvehicle_racer_maxracer'] = GetConVar('uvracermanager_maxracer'):GetInt()

			net.Start("UVUpdateSettings")
			net.WriteTable(convar_table)
			net.SendToServer()
			
			notification.AddLegacy( "#uv.tool.applied", NOTIFY_UNDO, 5 )
			surface.PlaySound( "buttons/button15.wav" )
			-- Msg( "#tool.uvracermanager.applied" )
			
		end
		CPanel:AddItem(applysettings)

		CPanel:AddControl("Button", {
			Text = "#tool.uvracermanager.clear",
			Command = "uv_clearracers"
		})
		
		-- Unified Vehicle Base UI
		local vehicleBases = {
			{ id = 1, name = "HL2 Jeep", func = uvracermanagerGetSavesJeep, path = "unitvehicles/prop_vehicle_jeep/racers/", type = "txt" },
			{ id = 2, name = "Simfphys", func = uvracermanagerGetSaves, path = "unitvehicles/simfphys/racers/", type = "txt" },
			{ id = 3, name = "Glide", func = uvracermanagerGetSavesGlide, path = "unitvehicles/glide/racers/", type = "json" }
		}

		local vehicleBaseCombo = vgui.Create("DComboBox")
		vehicleBaseCombo:SetSize(280, 20)
		vehicleBaseCombo:SetTooltip("#uv.tool.base.desc")
		local currentBaseId = GetConVar("uvracermanager_vehiclebase"):GetInt()
		vehicleBaseCombo:SetValue(vehicleBases[currentBaseId].name)
		for _, base in ipairs(vehicleBases) do
			vehicleBaseCombo:AddChoice(base.name, base.id)
		end
		
		-- Scroll Panel
		local FrameListPanel = vgui.Create("DFrame")
		FrameListPanel:SetSize(280, 200)
		FrameListPanel:SetTitle("")
		FrameListPanel:SetVisible(true)
		FrameListPanel:ShowCloseButton(false)
		FrameListPanel:SetDraggable(false)
		FrameListPanel.Paint = function(self, w, h)
			draw.RoundedBox(5, 0, 0, w, h, Color(115, 115, 115, 255))
			draw.RoundedBox(5, 1, 1, w - 2, h - 2, Color(0, 0, 0))
		end
		CPanel:AddItem(FrameListPanel)

		local ScrollPanel = vgui.Create("DScrollPanel", FrameListPanel)
		ScrollPanel:DockMargin(0, -25, 0, 0)
		ScrollPanel:Dock(FILL)

		-- Save this for later access by net.Receive
		UVRacerManagerTool.ScrollPanel = ScrollPanel

		-- Also store the population function, so we can call it from net.Receive
		UVRacerManagerTool.PopulateVehicleList = function(baseId)
			ScrollPanel:Clear()
			selecteditem = nil

			for _, base in ipairs(vehicleBases) do
				if base.id == baseId then
					local savedVehicles = file.Find(base.path .. "*." .. base.type, "DATA")
					local index, highlight, offset = 0, false, 22

					if #savedVehicles == 0 then
						local emptyLabel = vgui.Create("DLabel", ScrollPanel)
						emptyLabel:SetText("#uv.tool.novehicle")
						emptyLabel:SetTextColor(Color(200, 200, 200))
						emptyLabel:SetFont("DermaDefaultBold")
						emptyLabel:SetContentAlignment(5)
						emptyLabel:Dock(TOP)
						emptyLabel:SetTall(offset)
						return
					end

					for _, v in ipairs(savedVehicles) do
						local printname = v
						if not selecteditem then selecteditem = v end

						local Button = vgui.Create("DButton", ScrollPanel)
						Button:SetText(printname)
						Button:SetTextColor(Color(255, 255, 255))
						Button:Dock(TOP)
						Button:SetTall(offset)
						Button:DockMargin(0, 0, 0, 2)

						Button.highlight = highlight
						Button.printname = v

						Button.Paint = function(self, w, h)
							local c_selected = Color(128, 185, 128, 255)
							local c_normal = self.highlight and Color(108, 111, 114, 200) or Color(77, 80, 82, 200)
							local c_hovered = Color(41, 128, 185, 255)
							local c_ = (selecteditem == self.printname) and c_selected or (self:IsHovered() and c_hovered or c_normal)
							draw.RoundedBox(5, 1, 1, w - 2, h - 1, c_)
						end

						Button.DoClick = function(self)
							selecteditem = self.printname
							SetClipboardText(selecteditem)

							if base.type == "json" then
								UVTOOLMemory = util.JSONToTable(file.Read(base.path .. selecteditem, "DATA"), true)
							else
								local DataString = file.Read(base.path .. selecteditem, "DATA")
								local words, decoded = string.Explode("", DataString), {}
								for k, v in pairs(words) do decoded[k] = string.char(string.byte(v) - 20) end
								local Data = string.Explode("#", string.Implode("", decoded))
								table.Empty(UVTOOLMemory)
								for _, v in pairs(Data) do
									local Var = string.Explode("=", v)
									local name, variable = Var[1], Var[2]
									if name and variable then
										if name == "SubMaterials" then
											UVTOOLMemory[name] = {}
											local submats = string.Explode(",", variable)
											for i = 0, (table.Count(submats) - 1) do
												UVTOOLMemory[name][i] = submats[i + 1]
											end
										else
											UVTOOLMemory[name] = variable
										end
									end
								end
							end

							net.Start("UVRacerManagerGetRacerInfo")
							net.WriteTable(UVTOOLMemory)
							net.SendToServer()
						end

						index = index + 1
						highlight = not highlight
					end
					break
				end
			end
		end

		-- Initialize
		UVRacerManagerTool.PopulateVehicleList(GetConVar("uvracermanager_vehiclebase"):GetInt())

		if not LocalPlayer():IsSuperAdmin() then return end -- Show settings only if you have permissions.
		
		-- Refresh Button
		local RefreshBtn = vgui.Create("DButton")
		RefreshBtn:SetText("#refresh")
		RefreshBtn:SetSize(280, 20)
		RefreshBtn.DoClick = function()
			UVRacerManagerTool.PopulateVehicleList(GetConVar("uvracermanager_vehiclebase"):GetInt())
			notification.AddLegacy("#tool.uvunitmanager.refreshed", NOTIFY_UNDO, 5)
			surface.PlaySound("buttons/button15.wav")
		end
		CPanel:AddItem(RefreshBtn)

		-- Delete Button
		local DeleteBtn = vgui.Create("DButton")
		DeleteBtn:SetText("#spawnmenu.menu.delete")
		DeleteBtn:SetSize(280, 20)
		DeleteBtn.DoClick = function()
			local baseId = GetConVar("uvracermanager_vehiclebase"):GetInt()
			local basePath, baseType
			for _, base in ipairs(vehicleBases) do
				if base.id == baseId then
					basePath, baseType = base.path, base.type
					break
				end
			end
			if isstring(selecteditem) and basePath then
				if file.Delete(basePath .. selecteditem) then
					notification.AddLegacy(string.format(language.GetPhrase("uv.tool.deleted"), selecteditem), NOTIFY_UNDO, 5)
					surface.PlaySound("buttons/button15.wav")
					-- Msg(string.format(language.GetPhrase("tool.uvunitmanager.deleted"), selecteditem))
				end
			end
			UVRacerManagerTool.PopulateVehicleList(baseId)
		end
		CPanel:AddItem(DeleteBtn)
				
		-- Dropdown for vehicle base selection
		CPanel:AddControl("Label", { Text = "#uv.tool.base.title" })
		CPanel:AddItem(vehicleBaseCombo)

		CPanel:AddControl("Label", { Text = "" }) -- General Settings
		CPanel:AddControl("Label", { Text = "#tool.uvracermanager.settings.assignracers.title" })

		CPanel:AddControl("Button", {
			Label = "#tool.uvracermanager.settings.spawnai",
			Tooltip = "#tool.uvracermanager.settings.spawnai.desc",
			Command = "uvrace_spawnai"
		})

		local assignracers = vgui.Create("DCheckBoxLabel")
		assignracers:SetText("#tool.uvracermanager.settings.assignracers")
		assignracers:SetConVar("uvracermanager_assignracers")
		assignracers:SetTooltip("#tool.uvracermanager.settings.assignracers.desc")
		assignracers:SetValue(GetConVar("uvracermanager_assignracers"):GetInt())
		CPanel:AddItem(assignracers)

		-- /// Vehicle Override Code /// --
		local vehicleTree = vgui.Create("DTree", CPanel)
		vehicleTree:SetSize(CPanel:GetWide(), 200)
		vehicleTree:Dock(FILL)
		CPanel:AddItem(vehicleTree)

		local clearButton = vgui.Create("DButton", CPanel)
		clearButton:SetText("Clear All")
		clearButton:Dock(TOP)
		CPanel:AddItem(clearButton)

		local selectedRacers = {}

		local function ParseConvar()
			local t = {}
			for class in string.gmatch(GetConVar("uvracermanager_racers"):GetString(), "%S+") do
				t[class] = true
			end
			return t
		end

		local function UpdateRacersConvar()
			local out = {}

			for class, _ in pairs(selectedRacers) do
				table.insert(out, class)
			end
			table.sort(out)

			local str = table.concat(out, " ")
			RunConsoleCommand("uvracermanager_racers", str)
		end

		local classToNode = {} -- lookup so textbox edits update icons

		local function RefreshNodeIcons()
			for class, node in pairs(classToNode) do
				if IsValid(node) then
					if selectedRacers[class] then
						node:SetIcon("icon16/tick.png")
					else
						node:SetIcon("icon16/car.png")
					end
				end
			end
		end

		local function UpdateFolderIcon(folderNode)
			if not IsValid(folderNode) then return end

			local hasSelectedChild = false
			for _, child in ipairs(folderNode:GetChildren() or {}) do
				if child.ClassName and selectedRacers[child.ClassName] then
					hasSelectedChild = true
					break
				end
				for _, gc in ipairs(child.GetChildren and child:GetChildren() or {}) do
					if gc.ClassName and selectedRacers[gc.ClassName] then
						hasSelectedChild = true
						break
					end
				end
			end

			if folderNode.SetIcon then
				if hasSelectedChild then
					folderNode:SetIcon("icon16/folder_add.png")
				else
					local expanded = folderNode.Expander and folderNode.Expander.IsExpanded and folderNode.Expander:IsExpanded()
					if expanded then
						folderNode:SetIcon("icon16/folder_add.png")
					else
						folderNode:SetIcon("icon16/folder.png")
					end
				end
			end
		end

		-- ADD VEHICLE NODES
		local function AddVehicleNodes(parentNode, vehicles)
			table.sort(vehicles, function(a, b) return (a.name or "") < (b.name or "") end)

			selectedRacers = ParseConvar()

			for _, veh in ipairs(vehicles) do
				local class = veh.class
				local node = parentNode:AddNode(veh.name or class)
				node.ClassName = class

				classToNode[class] = node

				if selectedRacers[class] then
					node:SetIcon("icon16/tick.png")
				else
					node:SetIcon("icon16/car.png")
				end

				node:SetTooltip("#tool.uvracermanager.settings.racers.desc")

				function node:DoRightClick()
					if selectedRacers[class] then
						selectedRacers[class] = nil
						self:SetIcon("icon16/car.png")
					else
						selectedRacers[class] = true
						self:SetIcon("icon16/tick.png")
					end

					UpdateRacersConvar()
					UpdateFolderIcon(parentNode)
				end
			end

			UpdateFolderIcon(parentNode)
		end

		-- HL2 Jeeps
		local baseVehicles = list.Get("Vehicles") or {}
		local baseCategories = {}
		for class, data in pairs(baseVehicles) do
			local cat = data.Category or "Other"
			baseCategories[cat] = baseCategories[cat] or {}
			table.insert(baseCategories[cat], {name = data.PrintName or class, class = class})
		end
		for catName, vehs in SortedPairs(baseCategories) do
			local catNode = vehicleTree:AddNode(catName)
			AddVehicleNodes(catNode, vehs)
		end

		-- Simfphys
		local simfphysVehicles = list.Get("simfphys_vehicles") or {}
		if next(simfphysVehicles) then
			local simNode = vehicleTree:AddNode("[simfphys]")
			local simCategories = {}
			for class, data in pairs(simfphysVehicles) do
				local cat = data.Category or "Other"
				simCategories[cat] = simCategories[cat] or {}
				table.insert(simCategories[cat], {name = data.Name or class, class = class})
			end
			for catName, vehs in SortedPairs(simCategories) do
				local catNode = simNode:AddNode(catName)
				AddVehicleNodes(catNode, vehs)
			end
		end

		-- Glide
		local glideNode = vehicleTree:AddNode("Glide - Select to load")
		glideNode:SetExpanded(false)
		local glideDataRequested = false

		-- Request server data when Glide node is selected
		function glideNode:OnNodeSelected()
			if glideDataRequested then return end
			glideDataRequested = true

			net.Start("RequestGlideVehicles")
			net.SendToServer()
		end

		-- Receive Glide vehicle data
		net.Receive("GlideVehiclesTable", function()
			local glideVehicles = net.ReadTable()
			local glideCategories = list.Get("GlideCategories") or {}

			if IsValid(glideNode) then
				glideNode:SetText("Glide")
			end

			-- Always show Default first
			if glideVehicles["Default"] then
				local defaultNode = glideNode:AddNode("Default")
				AddVehicleNodes(defaultNode, glideVehicles["Default"])
			end

			-- Populate Glide categories
			for catID, catData in SortedPairs(glideCategories) do
				local vehicles = glideVehicles[catID] or {}
				if #vehicles > 0 then
					local catNode = glideNode:AddNode(catData.name or catID)
					AddVehicleNodes(catNode, vehicles)
				end
			end
		end)
		
		clearButton.DoClick = function()
			-- Clear the convar
			RunConsoleCommand("uvracermanager_racers", "")
			selectedRacers = {}

			-- Remove all nodes
			vehicleTree:Clear()
			classToNode = {}

			-- Rebuild HL2 Jeeps
			local baseVehicles = list.Get("Vehicles") or {}
			local baseCategories = {}
			for class, data in pairs(baseVehicles) do
				local cat = data.Category or "Other"
				baseCategories[cat] = baseCategories[cat] or {}
				table.insert(baseCategories[cat], {name = data.PrintName or class, class = class})
			end
			for catName, vehs in SortedPairs(baseCategories) do
				local catNode = vehicleTree:AddNode(catName)
				AddVehicleNodes(catNode, vehs)
			end

			-- Rebuild Simfphys
			local simfphysVehicles = list.Get("simfphys_vehicles") or {}
			if next(simfphysVehicles) then
				local simNode = vehicleTree:AddNode("[simfphys]")
				local simCategories = {}
				for class, data in pairs(simfphysVehicles) do
					local cat = data.Category or "Other"
					simCategories[cat] = simCategories[cat] or {}
					table.insert(simCategories[cat], {name = data.Name or class, class = class})
				end
				for catName, vehs in SortedPairs(simCategories) do
					local catNode = simNode:AddNode(catName)
					AddVehicleNodes(catNode, vehs)
				end
			end

			-- Rebuild Glide node
			local glideNode = vehicleTree:AddNode("Glide - Select to load")
			glideNode:SetExpanded(false)
			local glideDataRequested = false

			function glideNode:OnNodeSelected()
				if glideDataRequested then return end
				glideDataRequested = true

				net.Start("RequestGlideVehicles")
				net.SendToServer()
			end

			net.Receive("GlideVehiclesTable", function()
				local glideVehicles = net.ReadTable()
				local glideCategories = list.Get("GlideCategories") or {}

				if IsValid(glideNode) then
					glideNode:SetText("Glide")
				end

				if glideVehicles["Default"] then
					local defaultNode = glideNode:AddNode("Default")
					AddVehicleNodes(defaultNode, glideVehicles["Default"])
				end

				for catID, catData in SortedPairs(glideCategories) do
					local vehicles = glideVehicles[catID] or {}
					if #vehicles > 0 then
						local catNode = glideNode:AddNode(catData.name or catID)
						AddVehicleNodes(catNode, vehicles)
					end
				end
			end)
		end

		-- /// End of Vehicle Override Code /// --
		
		CPanel:AddControl("Label", { Text = "" }) -- General Settings
		CPanel:AddControl("Label", { Text = "#tool.uvracermanager.settings.general.title" })

		local spawncondition = vgui.Create("DNumSlider")
		spawncondition:SetText("#tool.uvracermanager.settings.spawncondition")
		spawncondition:SetTooltip("#tool.uvracermanager.settings.spawncondition.desc")
		spawncondition:SetMinMax(1, 3)
		spawncondition:SetDecimals(0)
		spawncondition:SetValue(GetConVar("uvracermanager_spawncondition"))
		spawncondition:SetConVar("uvracermanager_spawncondition")
		CPanel:AddItem(spawncondition)

		local maxracer = vgui.Create("DNumSlider")
		maxracer:SetText("#tool.uvracermanager.settings.maxracer")
		maxracer:SetTooltip("#tool.uvracermanager.settings.maxracer.desc")
		maxracer:SetMinMax(0, 20)
		maxracer:SetDecimals(0)
		maxracer:SetValue(GetConVar("uvracermanager_maxracer"))
		maxracer:SetConVar("uvracermanager_maxracer")
		CPanel:AddItem(maxracer)

		-- Sync dropdown and slider
		vehicleBaseCombo.OnSelect = function(self, index, value, data)
			local baseId = tonumber(data)
			if not baseId then return end
			RunConsoleCommand("uvracermanager_vehiclebase", baseId)
			UVRacerManagerTool.PopulateVehicleList(baseId)
		end
	end

end

function TOOL:RightClick(trace)
	if CLIENT then return true end
	
	local ent = trace.Entity
	local ply = self:GetOwner()
	
	if not istable(ply.UVRacerTOOLMemory) then 
		ply.UVRacerTOOLMemory = {}
	end
	
	if ent.IsSimfphyscar or ent.IsGlideVehicle or ent:GetClass() == "prop_vehicle_jeep" then
		if not IsValid(ent) then 
			table.Empty( ply.UVRacerTOOLMemory )
			
			net.Start("UVRacerManagerGetRacerInfo")
			net.WriteTable( ply.UVRacerTOOLMemory )
			net.Send( ply )
			
			return false
		end
		
		self:GetVehicleData( ent, ply )
		
	end
	
	net.Start("UVRacerManagerAdjustRacer")
	net.Send(ply)
	
	return true
end

local function ValidateModel( model )
	local v_list = list.Get( "simfphys_vehicles" )
	for listname, _ in pairs( v_list ) do
		if v_list[listname].Members.CustomWheels then
			local FrontWheel = v_list[listname].Members.CustomWheelModel
			local RearWheel = v_list[listname].Members.CustomWheelModel_R
			
			if FrontWheel then 
				FrontWheel = string.lower( FrontWheel )
			end
			
			if RearWheel then 
				RearWheel = string.lower( RearWheel )
			end
			
			if model == FrontWheel or model == RearWheel then
				return true
			end
		end
	end
	
	local list = list.Get( "simfphys_Wheels" )[model]
	
	if list then 
		return true
	end
	
	return false
end

local function GetRight( ent, index, WheelPos )
	local Steer = ent:GetTransformedDirection()
	
	local Right = ent.Right
	
	if WheelPos.IsFrontWheel then
		Right = (IsValid( ent.SteerMaster ) and Steer.Right or ent.Right) * (WheelPos.IsRightWheel and 1 or -1)
	else
		Right = (IsValid( ent.SteerMaster ) and Steer.Right2 or ent.Right) * (WheelPos.IsRightWheel and 1 or -1)
	end
	
	return Right
end

local function SetWheelOffset( ent, offset_front, offset_rear )
	if not IsValid( ent ) then return end
	
	ent.WheelTool_Foffset = offset_front
	ent.WheelTool_Roffset = offset_rear
	
	if not istable( ent.Wheels ) or not istable( ent.GhostWheels ) then return end
	
	for i = 1, table.Count( ent.GhostWheels ) do
		local Wheel = ent.Wheels[ i ]
		local WheelModel = ent.GhostWheels[i]
		local WheelPos = ent:LogicWheelPos( i )
		
		if IsValid( Wheel ) and IsValid( WheelModel ) then
			local Pos = Wheel:GetPos()
			local Right = GetRight( ent, i, WheelPos )
			local offset = WheelPos.IsFrontWheel and offset_front or offset_rear
			
			WheelModel:SetParent( nil )
			
			local physObj = WheelModel:GetPhysicsObject()
			if IsValid( physObj ) then
				physObj:EnableMotion( false )
			end
			
			WheelModel:SetPos( Pos + Right * offset )
			WheelModel:SetParent( Wheel )
		end
	end
end

local function ApplyWheel(ent, data)
	ent.CustomWheelAngleOffset = data[2]
	ent.CustomWheelAngleOffset_R = data[4]
	
	timer.Simple( 0.05, function()
		if not IsValid( ent ) then return end
		for i = 1, table.Count( ent.GhostWheels ) do
			local Wheel = ent.GhostWheels[i]
			
			if IsValid( Wheel ) then
				local isfrontwheel = (i == 1 or i == 2)
				local swap_y = (i == 2 or i == 4 or i == 6)
				
				local angleoffset = isfrontwheel and ent.CustomWheelAngleOffset or ent.CustomWheelAngleOffset_R
				
				local model = isfrontwheel and data[1] or data[3]
				
				local fAng = ent:LocalToWorldAngles( ent.VehicleData.LocalAngForward )
				local rAng = ent:LocalToWorldAngles( ent.VehicleData.LocalAngRight )
				
				local Forward = fAng:Forward() 
				local Right = swap_y and -rAng:Forward() or rAng:Forward()
				local Up = ent:GetUp()
				
				local Camber = data[5] or 0
				
				local ghostAng = Right:Angle()
				local mirAng = swap_y and 1 or -1
				ghostAng:RotateAroundAxis(Forward,angleoffset.p * mirAng)
				ghostAng:RotateAroundAxis(Right,angleoffset.r * mirAng)
				ghostAng:RotateAroundAxis(Up,-angleoffset.y)
				
				ghostAng:RotateAroundAxis(Forward, Camber * mirAng)
				
				Wheel:SetModelScale( 1 )
				Wheel:SetModel( model )
				Wheel:SetAngles( ghostAng )
				
				timer.Simple( 0.05, function()
					if not IsValid(Wheel) or not IsValid( ent ) then return end
					local wheelsize = Wheel:OBBMaxs() - Wheel:OBBMins()
					local radius = isfrontwheel and ent.FrontWheelRadius or ent.RearWheelRadius
					local size = (radius * 2) / math.max(wheelsize.x,wheelsize.y,wheelsize.z)
					
					Wheel:SetModelScale( size )
				end)
			end
		end
	end)
end

local function GetAngleFromSpawnlist( model )
	if not model then print("invalid model") return Angle(0,0,0) end
	
	model = string.lower( model )
	
	local v_list = list.Get( "simfphys_vehicles" )
	for listname, _ in pairs( v_list ) do
		if v_list[listname].Members.CustomWheels then
			local FrontWheel = v_list[listname].Members.CustomWheelModel
			local RearWheel = v_list[listname].Members.CustomWheelModel_R
			
			if FrontWheel then 
				FrontWheel = string.lower( FrontWheel )
			end
			
			if RearWheel then 
				RearWheel = string.lower( RearWheel )
			end
			
			if model == FrontWheel or model == RearWheel then
				local Angleoffset = v_list[listname].Members.CustomWheelAngleOffset
				if (Angleoffset) then
					return Angleoffset
				end
			end
		end
	end
	
	local list = list.Get( "simfphys_Wheels" )[model]
	local output = list and list.Angle or Angle(0,0,0)
	
	return output
end

function TOOL:LeftClick( trace )
	if CLIENT then return true end
	
	local Ent = trace.Entity
	
	local ply = self:GetOwner()
	
	if not istable(ply.UVRacerTOOLMemory) then
		ply:PrintMessage( HUD_PRINTTALK, "Select a Racer" )
		return 
	end
	
	if ply.UVRacerTOOLMemory.VehicleBase == "base_glide_car" or ply.UVRacerTOOLMemory.VehicleBase == "base_glide_motorcycle" then
		local SpawnCenter = trace.HitPos
		SpawnCenter.z = SpawnCenter.z - ply.UVRacerTOOLMemory.Mins.z
		
		duplicator.SetLocalPos( SpawnCenter+Vector( 0, 0, 50 ) )
		duplicator.SetLocalAng( Angle( 0, ply:EyeAngles().yaw, 0 ) )
		
		local Ents = duplicator.Paste( self:GetOwner(), ply.UVRacerTOOLMemory.Entities, ply.UVRacerTOOLMemory.Constraints )
		
		local Ent = nil
		if next(Ents) ~= nil then
			for _, v in pairs(Ents) do
				if v.IsGlideVehicle and v.GetIsHonking then
					Ent = v
					break
				end
			end
		end
		
		if not IsValid( Ent ) then 
			PrintMessage( HUD_PRINTTALK, "The vehicle ".. ply.UVRacerTOOLMemory.SpawnName .." dosen't seem to be installed!" )
			return 
		end

		if ply.UVRacerTOOLMemory.SubMaterials then
			if istable( ply.UVRacerTOOLMemory.SubMaterials ) then
				for i = 0, table.Count( ply.UVRacerTOOLMemory.SubMaterials ) do
					Ent:SetSubMaterial( i, ply.UVRacerTOOLMemory.SubMaterials[i] )
				end
			end

			local groups = string.Explode( ",", ply.UVRacerTOOLMemory.BodyGroups)
			for i = 1, table.Count( groups ) do
				Ent:SetBodygroup(i, tonumber(groups[i]) )
			end

			Ent:SetSkin( ply.UVRacerTOOLMemory.Skin )

			local c = string.Explode( ",", ply.UVRacerTOOLMemory.Color )
			local Color =  Color( tonumber(c[1]), tonumber(c[2]), tonumber(c[3]), tonumber(c[4]) )

			local dot = Color.r * Color.g * Color.b * Color.a
			Ent.OldColor = dot

			if ply.UVRacerTOOLMemory.SaveColor then
				Ent:SetColor( Color )
			else
				if isfunction(Ent.GetSpawnColor) then
					Color = Ent:GetSpawnColor()
					Ent:SetColor( Color )
				else
					Color.r = math.random(0, 255)
					Color.g = math.random(0, 255)
					Color.b = math.random(0, 255)
					Ent:SetColor( Color )
				end
			end

			local data = {
				Color = Color,
				RenderMode = 0,
				RenderFX = 0
			}
			duplicator.StoreEntityModifier( Ent, "colour", data )
		end
		
		duplicator.SetLocalPos( vector_origin )
		duplicator.SetLocalAng( angle_zero )
		
		undo.Create( "Duplicator" )
		
		for k, ent in pairs( Ents ) do
			undo.AddEntity( ent )
		end
		
		for k, ent in pairs( Ents )	do
			self:GetOwner():AddCleanup( "duplicates", ent )
		end
		
		undo.SetPlayer( self:GetOwner() )
		undo.SetCustomUndoText( "Undone Glide Racer" )
		
		undo.Finish( "Undo (" .. tostring( table.Count( Ents ) ) ..  ")" )

		if cffunctions then
			Ent.NitrousPower = ply.UVRacerTOOLMemory.NitrousPower
			Ent.NitrousDepletionRate = ply.UVRacerTOOLMemory.NitrousDepletionRate
			Ent.NitrousRegenRate = ply.UVRacerTOOLMemory.NitrousRegenRate
			Ent.NitrousRegenDelay = ply.UVRacerTOOLMemory.NitrousRegenDelay
			Ent.NitrousPitchChangeFrequency = ply.UVRacerTOOLMemory.NitrousPitchChangeFrequency
			Ent.NitrousPitchMultiplier = ply.UVRacerTOOLMemory.NitrousPitchMultiplier
			Ent.NitrousBurst = ply.UVRacerTOOLMemory.NitrousBurst
			Ent.NitrousColor = ply.UVRacerTOOLMemory.NitrousColor
			Ent.NitrousStartSound = ply.UVRacerTOOLMemory.NitrousStartSound
			Ent.NitrousLoopingSound = ply.UVRacerTOOLMemory.NitrousLoopingSound
			Ent.NitrousEndSound = ply.UVRacerTOOLMemory.NitrousEndSound
			Ent.NitrousEmptySound = ply.UVRacerTOOLMemory.NitrousEmptySound
			Ent.NitrousReadyBurstSound = ply.UVRacerTOOLMemory.NitrousReadyBurstSound
			Ent.NitrousStartBurstSound = ply.UVRacerTOOLMemory.NitrousStartBurstSound
			Ent.NitrousStartBurstAnnotationSound = ply.UVRacerTOOLMemory.NitrousStartBurstAnnotationSound
			Ent.CriticalDamageSound = ply.UVRacerTOOLMemory.CriticalDamageSound
			Ent:SetNWBool( 'NitrousEnabled', ply.UVRacerTOOLMemory.NitrousEnabled == nil and true or ply.UVRacerTOOLMemory.NitrousEnabled )
			
			if Ent.NitrousColor then
				local r = Ent.NitrousColor.r
    			local g = Ent.NitrousColor.g
    			local b = Ent.NitrousColor.b
			
    			net.Start( "cfnitrouscolor" )
    			    net.WriteEntity(Ent)
    			    net.WriteInt(r, 9)
    			    net.WriteInt(g, 9)
    			    net.WriteInt(b, 9)
					net.WriteBool(Ent.NitrousBurst)
					net.WriteBool(Ent.NitrousEnabled)
    			net.Broadcast()
			end
		end
		
		Ent.RacerVehicle = ply
		
		return true
		
	elseif ply.UVRacerTOOLMemory.VehicleBase == "prop_vehicle_jeep" then
		local class = ply.UVRacerTOOLMemory.SpawnName
		local vehicles = list.Get("Vehicles")
		local lst = vehicles[class]
		if not lst then
			PrintMessage( HUD_PRINTTALK, "The vehicle '"..class.."' is missing!")
			return
		end
		
		local Ent = ents.Create("prop_vehicle_jeep")
		Ent.VehicleTable = lst
		Ent.VehicleName = ply.UVRacerTOOLMemory.VehicleName
		Ent:SetModel(lst.Model) 
		Ent:SetPos(trace.HitPos)
		
		local SpawnAng = self:GetOwner():EyeAngles()
		SpawnAng.pitch = 0
		SpawnAng.yaw = SpawnAng.yaw + 90
		SpawnAng.roll = 0
		Ent:SetAngles(SpawnAng)
		
		Ent:SetKeyValue("vehiclescript", lst.KeyValues.vehiclescript)
		Ent:SetVehicleClass( class )
		Ent:Spawn()
		Ent:Activate()
		
		local vehicle = Ent
		gamemode.Call( "PlayerSpawnedVehicle", ply, vehicle ) --Some vehicles has different models implanted together, so do that.
		
		if istable( ply.UVRacerTOOLMemory.SubMaterials ) then
			for i = 0, table.Count( ply.UVRacerTOOLMemory.SubMaterials ) do
				Ent:SetSubMaterial( i, ply.UVRacerTOOLMemory.SubMaterials[i] )
			end
		end
		
		timer.Simple(0.5, function()
			if not IsValid(Ent) then return end
			local groups = string.Explode( ",", ply.UVRacerTOOLMemory.BodyGroups)
			for i = 1, table.Count( groups ) do
				Ent:SetBodygroup(i, tonumber(groups[i]) )
			end
			
			Ent:SetSkin( ply.UVRacerTOOLMemory.Skin )
			
			local c = string.Explode( ",", ply.UVRacerTOOLMemory.Color )
			local Color =  Color( tonumber(c[1]), tonumber(c[2]), tonumber(c[3]), tonumber(c[4]) )
			
			local dot = Color.r * Color.g * Color.b * Color.a
			Ent.OldColor = dot
			
			if ply.UVRacerTOOLMemory.SaveColor then
				Ent:SetColor( Color )
			else
				Color.r = math.random(0, 255)
				Color.g = math.random(0, 255)
				Color.b = math.random(0, 255)
				Ent:SetColor( Color )
			end
			
			local data = {
				Color = Color,
				RenderMode = 0,
				RenderFX = 0
			}
			duplicator.StoreEntityModifier( Ent, "colour", data )
		end)
		
		undo.Create( "Vehicle" )
		undo.SetPlayer( ply )
		undo.AddEntity( Ent )
		undo.SetCustomUndoText( "Undone " .. class )
		undo.Finish( "Vehicle (" .. tostring( class ) .. ")" )
		
		Ent.RacerVehicle = ply
		
		return true
		
	end
	
	local vname = ply.UVRacerTOOLMemory.SpawnName
	local Update = false
	local VehicleList = list.Get( "simfphys_vehicles" )
	local vehicle = VehicleList[ vname ]
	
	if not vehicle then return false end
	
	ply.LockRightClick = true
	timer.Simple( 0.6, function() if IsValid( ply ) then ply.LockRightClick = false end end )
	
	local SpawnPos = trace.HitPos + Vector(0,0,25) + (vehicle.SpawnOffset or Vector(0,0,0))
	
	local SpawnAng = self:GetOwner():EyeAngles()
	SpawnAng.pitch = 0
	SpawnAng.yaw = SpawnAng.yaw + 180 + (vehicle.SpawnAngleOffset and vehicle.SpawnAngleOffset or 0)
	SpawnAng.roll = 0
	
	if Ent.IsSimfphyscar then
		if vname ~= Ent:GetSpawn_List() then 
			ply:PrintMessage( HUD_PRINTTALK, vname.." is not compatible with "..Ent:GetSpawn_List() )
			return
		end
		Update = true
	else
		Ent = simfphys.SpawnVehicle( ply, SpawnPos, SpawnAng, vehicle.Model, vehicle.Class, vname, vehicle )
	end
	
	if not IsValid( Ent ) then return end
	
	undo.Create( "Vehicle" )
	undo.SetPlayer( ply )
	undo.AddEntity( Ent )
	undo.SetCustomUndoText( "Undone " .. vehicle.Name )
	undo.Finish( "Vehicle (" .. tostring( vehicle.Name ) .. ")" )
	
	ply:AddCleanup( "vehicles", Ent )
	
	timer.Simple( 0.5, function()
		if not IsValid(Ent) then return end
		
		local tsc = string.Explode( ",", ply.UVRacerTOOLMemory.TireSmokeColor )
		Ent:SetTireSmokeColor( Vector( tonumber(tsc[1]), tonumber(tsc[2]), tonumber(tsc[3]) ) )
		
		Ent.Turbocharged = tobool( ply.UVRacerTOOLMemory.HasTurbo )
		Ent.Supercharged = tobool( ply.UVRacerTOOLMemory.HasBlower )
		
		Ent:SetEngineSoundPreset( math.Clamp( tonumber( ply.UVRacerTOOLMemory.SoundPreset ), -1, 23) )
		Ent:SetMaxTorque( math.Clamp( tonumber( ply.UVRacerTOOLMemory.PeakTorque ), 20, 1000) )
		Ent:SetDifferentialGear( math.Clamp( tonumber( ply.UVRacerTOOLMemory.FinalGear ),0.2, 6 ) )
		
		Ent:SetSteerSpeed( math.Clamp( tonumber( ply.UVRacerTOOLMemory.SteerSpeed ), 1, 16 ) )
		Ent:SetFastSteerAngle( math.Clamp( tonumber( ply.UVRacerTOOLMemory.SteerAngFast ), 0, 1) )
		Ent:SetFastSteerConeFadeSpeed( math.Clamp( tonumber( ply.UVRacerTOOLMemory.SteerFadeSpeed ), 1, 5000 ) )
		
		Ent:SetEfficiency( math.Clamp( tonumber( ply.UVRacerTOOLMemory.Efficiency ) ,0.2,4) )
		Ent:SetMaxTraction( math.Clamp( tonumber( ply.UVRacerTOOLMemory.MaxTraction ) , 5,1000) )
		Ent:SetTractionBias( math.Clamp( tonumber( ply.UVRacerTOOLMemory.GripOffset ),-0.99,0.99) )
		Ent:SetPowerDistribution( math.Clamp( tonumber( ply.UVRacerTOOLMemory.PowerDistribution ) ,-1,1) )
		
		Ent:SetBackFire( tobool( ply.UVRacerTOOLMemory.HasBackfire ) )
		Ent:SetDoNotStall( tobool( ply.UVRacerTOOLMemory.DoesntStall ) )
		
		Ent:SetIdleRPM( math.Clamp( tonumber( ply.UVRacerTOOLMemory.IdleRPM ),1,25000) )
		Ent:SetLimitRPM( math.Clamp( tonumber( ply.UVRacerTOOLMemory.MaxRPM ),4,25000) )
		Ent:SetRevlimiter( tobool( ply.UVRacerTOOLMemory.HasRevLimiter ) )
		Ent:SetPowerBandEnd( math.Clamp( tonumber( ply.UVRacerTOOLMemory.PowerEnd ), 3, 25000) )
		Ent:SetPowerBandStart( math.Clamp( tonumber( ply.UVRacerTOOLMemory.PowerStart ) ,2 ,25000) )
		
		Ent:SetTurboCharged( Ent.Turbocharged )
		Ent:SetSuperCharged( Ent.Supercharged )
		Ent:SetBrakePower( math.Clamp( tonumber( ply.UVRacerTOOLMemory.BrakePower ), 0.1, 500) )
		
		Ent:SetSoundoverride( ply.UVRacerTOOLMemory.SoundOverride or "" )
		
		Ent:SetLights_List( Ent.LightsTable or "no_lights" )
				
		Ent.snd_horn = ply.UVRacerTOOLMemory.HornSound
		
		Ent.snd_blowoff = ply.UVRacerTOOLMemory.snd_blowoff
		Ent.snd_spool = ply.UVRacerTOOLMemory.snd_spool
		Ent.snd_bloweron = ply.UVRacerTOOLMemory.snd_bloweron
		Ent.snd_bloweroff = ply.UVRacerTOOLMemory.snd_bloweroff
		
		Ent:SetBackfireSound( ply.UVRacerTOOLMemory.backfiresound or "" )
		
		local Gears = {}
		local Data = string.Explode( ",", ply.UVRacerTOOLMemory.Gears  )
		for i = 1, table.Count( Data ) do 
			local gRatio = tonumber( Data[i] )
			
			if isnumber( gRatio ) then
				if i == 1 then
					Gears[i] = math.Clamp( gRatio, -5, -0.001)
					
				elseif i == 2 then
					Gears[i] = 0
					
				else
					Gears[i] = math.Clamp( gRatio, 0.001, 5)
				end
			end
		end
		Ent.Gears = Gears
		
		if istable( ply.UVRacerTOOLMemory.SubMaterials ) then
			for i = 0, table.Count( ply.UVRacerTOOLMemory.SubMaterials ) do
				Ent:SetSubMaterial( i, ply.UVRacerTOOLMemory.SubMaterials[i] )
			end
		end
		
		if ply.UVRacerTOOLMemory.FrontDampingOverride and ply.UVRacerTOOLMemory.FrontConstantOverride and ply.UVRacerTOOLMemory.RearDampingOverride and ply.UVRacerTOOLMemory.RearConstantOverride then
			Ent.FrontDampingOverride = tonumber( ply.UVRacerTOOLMemory.FrontDampingOverride )
			Ent.FrontConstantOverride = tonumber( ply.UVRacerTOOLMemory.FrontConstantOverride )
			Ent.RearDampingOverride = tonumber( ply.UVRacerTOOLMemory.RearDampingOverride )
			Ent.RearConstantOverride = tonumber( ply.UVRacerTOOLMemory.RearConstantOverride )
			
			local data = {
				[1] = {Ent.FrontConstantOverride,Ent.FrontDampingOverride},
				[2] = {Ent.FrontConstantOverride,Ent.FrontDampingOverride},
				[3] = {Ent.RearConstantOverride,Ent.RearDampingOverride},
				[4] = {Ent.RearConstantOverride,Ent.RearDampingOverride},
				[5] = {Ent.RearConstantOverride,Ent.RearDampingOverride},
				[6] = {Ent.RearConstantOverride,Ent.RearDampingOverride}
			}
			
			local elastics = Ent.Elastics
			if elastics then
				for i = 1, table.Count( elastics ) do
					local elastic = elastics[i]
					if Ent.StrengthenSuspension == true then
						if IsValid( elastic ) then
							elastic:Fire( "SetSpringConstant", data[i][1] * 0.5, 0 )
							elastic:Fire( "SetSpringDamping", data[i][2] * 0.5, 0 )
						end
						local elastic2 = elastics[i * 10]
						if IsValid( elastic2 ) then
							elastic2:Fire( "SetSpringConstant", data[i][1] * 0.5, 0 )
							elastic2:Fire( "SetSpringDamping", data[i][2] * 0.5, 0 )
						end
					else
						if IsValid( elastic ) then
							elastic:Fire( "SetSpringConstant", data[i][1], 0 )
							elastic:Fire( "SetSpringDamping", data[i][2], 0 )
						end
					end
				end
			end
		end
		
		Ent:SetFrontSuspensionHeight( tonumber( ply.UVRacerTOOLMemory.FrontHeight ) )
		Ent:SetRearSuspensionHeight( tonumber( ply.UVRacerTOOLMemory.RearHeight ) )
		
		local groups = string.Explode( ",", ply.UVRacerTOOLMemory.BodyGroups)
		for i = 1, table.Count( groups ) do
			Ent:SetBodygroup(i, tonumber(groups[i]) )
		end
		
		Ent:SetSkin( ply.UVRacerTOOLMemory.Skin )
		
		local c = string.Explode( ",", ply.UVRacerTOOLMemory.Color )
		local Color =  Color( tonumber(c[1]), tonumber(c[2]), tonumber(c[3]), tonumber(c[4]) )
		
		local dot = Color.r * Color.g * Color.b * Color.a
		Ent.OldColor = dot
		
		if ply.UVRacerTOOLMemory.SaveColor then
			Ent:SetColor( Color )
		else
			Color.r = math.random(0, 255)
			Color.g = math.random(0, 255)
			Color.b = math.random(0, 255)
			Ent:SetColor( Color )
		end
		
		local data = {
			Color = Color,
			RenderMode = 0,
			RenderFX = 0
		}
		duplicator.StoreEntityModifier( Ent, "colour", data )
		
		if Update then
			local PhysObj = Ent:GetPhysicsObject()
			if not IsValid( PhysObj ) then return end
			
			local freezeWhenDone = PhysObj:IsMotionEnabled()
			local freezeWheels = {}
			PhysObj:EnableMotion( false )
			Ent:SetNotSolid( true )
			
			local ResetPos = Ent:GetPos()
			local ResetAng = Ent:GetAngles()
			
			Ent:SetPos( ResetPos + Vector(0,0,30) )
			Ent:SetAngles( Angle(0,ResetAng.y,0) )
			
			for i = 1, table.Count( Ent.Wheels ) do
				local Wheel = Ent.Wheels[ i ]
				if IsValid( Wheel ) then
					local wPObj = Wheel:GetPhysicsObject()
					
					if IsValid( wPObj ) then
						freezeWheels[ i ] = {}
						freezeWheels[ i ].dofreeze = wPObj:IsMotionEnabled()
						freezeWheels[ i ].pos = Wheel:GetPos()
						freezeWheels[ i ].ang = Wheel:GetAngles()
						Wheel:SetNotSolid( true )
						wPObj:EnableMotion( true ) 
						wPObj:Wake() 
					end
				end
			end
			
			timer.Simple( 0.5, function()
				if not IsValid( Ent ) then return end
				if not IsValid( PhysObj ) then return end
				
				PhysObj:EnableMotion( freezeWhenDone )
				Ent:SetNotSolid( false )
				Ent:SetPos( ResetPos )
				Ent:SetAngles( ResetAng )
				
				for i = 1, table.Count( freezeWheels ) do
					local Wheel = Ent.Wheels[ i ]
					if IsValid( Wheel ) then
						local wPObj = Wheel:GetPhysicsObject()
						
						Wheel:SetNotSolid( false )
						
						if IsValid( wPObj ) then
							wPObj:EnableMotion( freezeWheels[i].dofreeze ) 
						end
						
						Wheel:SetPos( freezeWheels[ i ].pos )
						Wheel:SetAngles( freezeWheels[ i ].ang )
					end
				end
			end)
		end
		
		if Ent.CustomWheels then
			if Ent.GhostWheels then
				timer.Simple( Update and 0.25 or 0, function()
					if not IsValid( Ent ) then return end
					if ply.UVRacerTOOLMemory.WheelTool_Foffset and ply.UVRacerTOOLMemory.WheelTool_Roffset then
						SetWheelOffset( Ent, ply.UVRacerTOOLMemory.WheelTool_Foffset, ply.UVRacerTOOLMemory.WheelTool_Roffset )
					end
					
					if not ply.UVRacerTOOLMemory.FrontWheelOverride and not ply.UVRacerTOOLMemory.RearWheelOverride then return end
					
					local front_model = ply.UVRacerTOOLMemory.FrontWheelOverride or vehicle.Members.CustomWheelModel
					local front_angle = GetAngleFromSpawnlist(front_model)
					
					local camber = ply.UVRacerTOOLMemory.Camber or 0
					local rear_model = ply.UVRacerTOOLMemory.RearWheelOverride or (vehicle.Members.CustomWheelModel_R and vehicle.Members.CustomWheelModel_R or front_model)
					local rear_angle = GetAngleFromSpawnlist(rear_model)
					
					if not front_model or not rear_model or not front_angle or not rear_angle then return end
					
					if ValidateModel( front_model ) and ValidateModel( rear_model ) then 
						Ent.Camber = camber
						ApplyWheel(Ent, {front_model,front_angle,rear_model,rear_angle,camber})
					else
						ply:PrintMessage( HUD_PRINTTALK, "selected wheel does not exist on the server")
					end
				end)
			end
		end
		
		Ent.RacerVehicle = ply
		
	end)
	
	return true
end

function TOOL:GetVehicleData( ent, ply )
	if not IsValid(ent) then return end
	if not istable(ply.UVRacerTOOLMemory) then ply.UVRacerTOOLMemory = {} end
	
	table.Empty( ply.UVRacerTOOLMemory )
	
	if ent.IsSimfphyscar then
		ply.UVRacerTOOLMemory.VehicleBase = ent:GetClass()
		ply.UVRacerTOOLMemory.SpawnName = ent:GetSpawn_List()
		ply.UVRacerTOOLMemory.SteerSpeed = ent:GetSteerSpeed()
		ply.UVRacerTOOLMemory.SteerFadeSpeed = ent:GetFastSteerConeFadeSpeed()
		ply.UVRacerTOOLMemory.SteerAngFast = ent:GetFastSteerAngle()
		ply.UVRacerTOOLMemory.SoundPreset = ent:GetEngineSoundPreset()
		ply.UVRacerTOOLMemory.IdleRPM = ent:GetIdleRPM()
		ply.UVRacerTOOLMemory.MaxRPM = ent:GetLimitRPM()
		ply.UVRacerTOOLMemory.PowerStart = ent:GetPowerBandStart()
		ply.UVRacerTOOLMemory.PowerEnd = ent:GetPowerBandEnd()
		ply.UVRacerTOOLMemory.PeakTorque = ent:GetMaxTorque()
		ply.UVRacerTOOLMemory.HasTurbo = ent:GetTurboCharged()
		ply.UVRacerTOOLMemory.HasBlower = ent:GetSuperCharged()
		ply.UVRacerTOOLMemory.HasRevLimiter = ent:GetRevlimiter()
		ply.UVRacerTOOLMemory.HasBulletProofTires = ent:GetBulletProofTires()
		ply.UVRacerTOOLMemory.MaxTraction = ent:GetMaxTraction()
		ply.UVRacerTOOLMemory.GripOffset = ent:GetTractionBias()
		ply.UVRacerTOOLMemory.BrakePower = ent:GetBrakePower()
		ply.UVRacerTOOLMemory.PowerDistribution = ent:GetPowerDistribution()
		ply.UVRacerTOOLMemory.Efficiency = ent:GetEfficiency()
		ply.UVRacerTOOLMemory.HornSound = ent.snd_horn
		ply.UVRacerTOOLMemory.HasBackfire = ent:GetBackFire()
		ply.UVRacerTOOLMemory.DoesntStall = ent:GetDoNotStall()
		ply.UVRacerTOOLMemory.SoundOverride = ent:GetSoundoverride()
		
		ply.UVRacerTOOLMemory.FrontHeight = ent:GetFrontSuspensionHeight()
		ply.UVRacerTOOLMemory.RearHeight = ent:GetRearSuspensionHeight()
		
		ply.UVRacerTOOLMemory.Camber = ent.Camber or 0
		
		if ent.FrontDampingOverride and ent.FrontConstantOverride and ent.RearDampingOverride and ent.RearConstantOverride then
			ply.UVRacerTOOLMemory.FrontDampingOverride = ent.FrontDampingOverride
			ply.UVRacerTOOLMemory.FrontConstantOverride = ent.FrontConstantOverride
			ply.UVRacerTOOLMemory.RearDampingOverride = ent.RearDampingOverride
			ply.UVRacerTOOLMemory.RearConstantOverride = ent.RearConstantOverride
		end
		
		if ent.CustomWheels then
			if ent.GhostWheels then
				if IsValid(ent.GhostWheels[1]) then
					ply.UVRacerTOOLMemory.FrontWheelOverride = ent.GhostWheels[1]:GetModel()
				elseif IsValid(ent.GhostWheels[2]) then
					ply.UVRacerTOOLMemory.FrontWheelOverride = ent.GhostWheels[2]:GetModel()
				end
				
				if IsValid(ent.GhostWheels[3]) then
					ply.UVRacerTOOLMemory.RearWheelOverride = ent.GhostWheels[3]:GetModel()
				elseif IsValid(ent.GhostWheels[4]) then
					ply.UVRacerTOOLMemory.RearWheelOverride = ent.GhostWheels[4]:GetModel()
				end
			end
		end
		
		local tsc = ent:GetTireSmokeColor()
		ply.UVRacerTOOLMemory.TireSmokeColor = tsc.r..","..tsc.g..","..tsc.b
		
		local Gears = ""
		for _,v in pairs(ent.Gears) do
			Gears = Gears..v..","
		end
		
		local c = ent:GetColor()
		ply.UVRacerTOOLMemory.Color = c.r..","..c.g..","..c.b..","..c.a
		
		local bodygroups = {}
		for k,v in pairs(ent:GetBodyGroups()) do
			bodygroups[k] = ent:GetBodygroup( k ) 
		end
		
		ply.UVRacerTOOLMemory.BodyGroups = string.Implode( ",", bodygroups)
		
		ply.UVRacerTOOLMemory.Skin = ent:GetSkin()
		
		ply.UVRacerTOOLMemory.Gears = Gears
		ply.UVRacerTOOLMemory.FinalGear = ent:GetDifferentialGear()
		
		if ent.WheelTool_Foffset then
			ply.UVRacerTOOLMemory.WheelTool_Foffset = ent.WheelTool_Foffset
		end
		
		if ent.WheelTool_Roffset then
			ply.UVRacerTOOLMemory.WheelTool_Roffset = ent.WheelTool_Roffset
		end
		
		if ent.snd_blowoff then
			ply.UVRacerTOOLMemory.snd_blowoff = ent.snd_blowoff
		end
		
		if ent.snd_spool then
			ply.UVRacerTOOLMemory.snd_spool = ent.snd_spool
		end
		
		if ent.snd_bloweron then
			ply.UVRacerTOOLMemory.snd_bloweron = ent.snd_bloweron
		end
		
		if ent.snd_bloweroff then
			ply.UVRacerTOOLMemory.snd_bloweroff = ent.snd_bloweroff
		end
		
		ply.UVRacerTOOLMemory.backfiresound = ent:GetBackfireSound()
		
		ply.UVRacerTOOLMemory.SubMaterials = {}
		for i = 0, (table.Count( ent:GetMaterials() ) - 1) do
			ply.UVRacerTOOLMemory.SubMaterials[i] = ent:GetSubMaterial( i )
		end
	elseif ent.IsGlideVehicle then
		local pos = ent:GetPos()
		duplicator.SetLocalPos( pos )
		
		ply.UVRacerTOOLMemory = duplicator.Copy( ent )

		PrintTable(ply.UVRacerTOOLMemory)
		
		duplicator.SetLocalPos( vector_origin )
		duplicator.SetLocalAng( angle_zero )
		
		if ( not ply.UVRacerTOOLMemory ) then return false end

		for _, v in pairs(ply.UVRacerTOOLMemory.Constraints) do
			if v.OnDieFunctions then
				v.OnDieFunctions = nil
			end
		end
		
		local Key = "VehicleBase"
		ply.UVRacerTOOLMemory[Key] = ent.Base
		local Key2 = "SpawnName"
		ply.UVRacerTOOLMemory[Key2] = ent:GetClass()
		ply.UVRacerTOOLMemory.Mins = Vector(ply.UVRacerTOOLMemory.Mins.x,ply.UVRacerTOOLMemory.Mins.y,0)

		-- for _,v in pairs(ply.UVRacerTOOLMemory.Entities) do
		-- 	v.Angle = 0
		-- 	v.PhysicsObjects[0].Angle = 0
		-- end
		
		if not ent.Sockets or next(ent.Sockets) == nil then --Not a semi
			ply.UVRacerTOOLMemory.Entities[next(ply.UVRacerTOOLMemory.Entities)].Angle = Angle(0,180,0)
		end
		-- ply.UVRacerTOOLMemory.Entities[next(ply.UVRacerTOOLMemory.Entities)].PhysicsObjects[0].Angle = Angle(0,180,0)

		local c = ent:GetColor()
		ply.UVRacerTOOLMemory.Color = c.r..","..c.g..","..c.b..","..c.a
		
		local bodygroups = {}
		for k,v in pairs(ent:GetBodyGroups()) do
			bodygroups[k] = ent:GetBodygroup( k ) 
		end
		
		ply.UVRacerTOOLMemory.BodyGroups = string.Implode( ",", bodygroups)
		
		ply.UVRacerTOOLMemory.Skin = ent:GetSkin()
		
		ply.UVRacerTOOLMemory.SubMaterials = {}
		for i = 0, (table.Count( ent:GetMaterials() ) - 1) do
			ply.UVRacerTOOLMemory.SubMaterials[i] = ent:GetSubMaterial( i )
		end

		if cffunctions then
			ply.UVRacerTOOLMemory.NitrousPower = ent.NitrousPower or 2
			ply.UVRacerTOOLMemory.NitrousDepletionRate = ent.NitrousDepletionRate or 0.5
			ply.UVRacerTOOLMemory.NitrousRegenRate = ent.NitrousRegenRate or 0.1
			ply.UVRacerTOOLMemory.NitrousRegenDelay = ent.NitrousRegenDelay or 2
			ply.UVRacerTOOLMemory.NitrousPitchChangeFrequency = ent.NitrousPitchChangeFrequency or 1 
			ply.UVRacerTOOLMemory.NitrousPitchMultiplier = ent.NitrousPitchMultiplier or 0.2
			ply.UVRacerTOOLMemory.NitrousBurst = ent.NitrousBurst or false
			ply.UVRacerTOOLMemory.NitrousColor = ent.NitrousColor or Color(35, 204, 255)
			ply.UVRacerTOOLMemory.NitrousStartSound = ent.NitrousStartSound or "glide_nitrous/nitrous_burst.wav"
			ply.UVRacerTOOLMemory.NitrousLoopingSound = ent.NitrousLoopingSound or "glide_nitrous/nitrous_burst.wav"
			ply.UVRacerTOOLMemory.NitrousEndSound = ent.NitrousEndSound or "glide_nitrous/nitrous_activation_whine.wav"
			ply.UVRacerTOOLMemory.NitrousEmptySound = ent.NitrousEmptySound or "glide_nitrous/nitrous_empty.wav"
			ply.UVRacerTOOLMemory.NitrousReadyBurstSound = ent.NitrousReadyBurstSound or "glide_nitrous/nitrous_burst/ready/ready.wav"
			ply.UVRacerTOOLMemory.NitrousStartBurstSound = ent.NitrousStartBurstSound or file.Find("sound/glide_nitrous/nitrous_burst/*", "GAME")
			ply.UVRacerTOOLMemory.NitrousStartBurstAnnotationSound = ent.NitrousStartBurstAnnotationSound or file.Find("sound/glide_nitrous/nitrous_burst/annotation/*", "GAME")
			ply.UVRacerTOOLMemory.CriticalDamageSound = ent.CriticalDamageSound or "glide_healthbar/criticaldamage.wav"
			ply.UVRacerTOOLMemory.NitrousEnabled = ent:GetNWBool( 'NitrousEnabled' )
		end
		
	elseif ent:GetClass() == "prop_vehicle_jeep" then
		ply.UVRacerTOOLMemory.VehicleBase = ent:GetClass()
		ply.UVRacerTOOLMemory.SpawnName = ent:GetVehicleClass()
		ply.UVRacerTOOLMemory.VehicleName = ent.VehicleName
		
		if not ply.UVRacerTOOLMemory.SpawnName then 
			print("This vehicle dosen't have a vehicle class set" )
			return 
		end
		
		local c = ent:GetColor()
		ply.UVRacerTOOLMemory.Color = c.r..","..c.g..","..c.b..","..c.a
		
		local bodygroups = {}
		for k,v in pairs(ent:GetBodyGroups()) do
			bodygroups[k] = ent:GetBodygroup( k ) 
		end
		
		ply.UVRacerTOOLMemory.BodyGroups = string.Implode( ",", bodygroups)
		
		ply.UVRacerTOOLMemory.Skin = ent:GetSkin()
		
		ply.UVRacerTOOLMemory.SubMaterials = {}
		for i = 0, (table.Count( ent:GetMaterials() ) - 1) do
			ply.UVRacerTOOLMemory.SubMaterials[i] = ent:GetSubMaterial( i )
		end
	end
	
	if not IsValid( ply ) then return end

	if ply.UVRacerTOOLMemory.Entities then
		for _, v in pairs(ply.UVRacerTOOLMemory.Entities) do
			v.OnDieFunctions = nil
			v.AutomaticFrameAdvance = nil
			v.BaseClass = nil
		end
	end

	if ply.UVRacerTOOLMemory.Constraints then
		for _, v in pairs(ply.UVRacerTOOLMemory.Constraints) do
			v.OnDieFunctions = nil
		end
	end
	
	net.Start("UVRacerManagerGetRacerInfo")
	net.WriteTable( ply.UVRacerTOOLMemory )
	net.Send( ply )
	
end

if SERVER then
    util.AddNetworkString("RequestGlideVehicles")
    util.AddNetworkString("GlideVehiclesTable")

    net.Receive("RequestGlideVehicles", function(len, ply)
        if not ply:IsSuperAdmin() then return end

        local glideVehicles = {}

        for className, scripted in pairs(scripted_ents.GetList() or {}) do
            if scripted.Base == "base_glide_car" and istable(scripted.t) and scripted.t.GlideCategory then
                local cat = scripted.t.GlideCategory or "Default"
                glideVehicles[cat] = glideVehicles[cat] or {}
                table.insert(glideVehicles[cat], {
                    name  = scripted.t.PrintName or className,
                    class = className -- Use key directly, guaranteed valid
                })
            end
        end

        local totalCategories = table.Count(glideVehicles)

        net.Start("GlideVehiclesTable")
        net.WriteTable(glideVehicles)
        net.Send(ply)
    end)
end