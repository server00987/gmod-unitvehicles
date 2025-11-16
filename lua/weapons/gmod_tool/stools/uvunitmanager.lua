TOOL.Category		=	"uv.settings.unitvehicles"
TOOL.Name			=	"#tool.uvunitmanager.name"
TOOL.Command		=	nil
TOOL.ConfigName		=	""

local bountytime = {}
local timetillnextheat = {}
local unitspatrol = {}
local unitssupport = {}
local unitspursuit = {}
local unitsinterceptor = {}
local unitsspecial = {}
local unitscommander = {}
local unitsrhino = {}
local heatlevel = {}
local heatminimumbounty = {}
local maxunits = {}
local unitsavailable = {}
local backuptimer = {}
local cooldowntimer = {}
local roadblocks = {}
local helicopters = {}
local bustspeed = {}

-- For ConVars, append the heat to the end of the ConVar string
local UnitSettings = {
	['bountytime'] = {
		Class = 'DNumSlider',
		MinMax = {1, 10000000},
		Decimals = 0,
		ConVar = 'uvunitmanager_bountytime',
		ToolText = '#tool.uvunitmanager.settings.bounty.10s',
		ToolTip = '#tool.uvunitmanager.settings.bounty.10s.desc'
	},
	['heatminimumbounty'] = {
		Class = 'DNumSlider',
		MinMax = {1, 10000000},
		Decimals = 0,
		ConVar = 'uvunitmanager_heatminimumbounty',
		ToolText = '#tool.uvunitmanager.settings.heatlevel.minbounty',
		ToolTip = '#tool.uvunitmanager.settings.heatlevel.minbounty.desc'
	},
	['maxunits'] = {
		Class = 'DNumSlider',
		MinMax = {1, 20},
		Decimals = 0,
		ConVar = 'uvunitmanager_maxunits',
		ToolText = '#tool.uvunitmanager.settings.heatlevel.maxunits',
		ToolTip = '#tool.uvunitmanager.settings.heatlevel.maxunits.desc'
	},
	['timetillnextheat'] = {
		Class = 'DNumSlider',
		MinMax = {20, 600},
		Decimals = 0,
		ConVar = 'uvunitmanager_timetillnextheat',
		ToolText = '#tool.uvunitmanager.settings.heatlvl.timed',
		ToolTip = '#tool.uvunitmanager.settings.heatlvl.timed.desc'
	},
	['unitsavailable'] = {
		Class = 'DNumSlider',
		MinMax = {1, 150},
		Decimals = 0,
		ConVar = 'uvunitmanager_unitsavailable',
		ToolText = '#tool.uvunitmanager.settings.heatlevel.avaunits',
		ToolTip = '#tool.uvunitmanager.settings.heatlevel.avaunits.desc'
	},
	['bustspeed'] = {
		Class = 'DNumSlider',
		MinMax = {1, 100},
		Decimals = 0,
		ConVar = 'uvunitmanager_bustspeed',
		ToolText = '#tool.uvunitmanager.settings.heatlevel.bustspeed',
		ToolTip = '#tool.uvunitmanager.settings.heatlevel.bustspeed.desc'
	},
	['backuptimer'] = {
		Class = 'DNumSlider',
		MinMax = {1, 600},
		Decimals = 0,
		ConVar = 'uvunitmanager_backuptimer',
		ToolText = '#tool.uvunitmanager.settings.heatlevel.backuptime',
		ToolTip = '#tool.uvunitmanager.settings.heatlevel.backuptime.desc'
	},
	['cooldowntimer'] = {
		Class = 'DNumSlider',
		MinMax = {1, 600},
		Decimals = 0,
		ConVar = 'uvunitmanager_cooldowntimer',
		ToolText = '#tool.uvunitmanager.settings.heatlevel.cooldowntime',
		ToolTip = '#tool.uvunitmanager.settings.heatlevel.cooldowntime.desc'
	},
	['roadblocks'] = {
		Class = 'DCheckBoxLabel',
		ConVar = 'uvunitmanager_roadblocks',
		ToolText = '#tool.uvunitmanager.settings.heatlevel.roadblocks',
		ToolTip = '#tool.uvunitmanager.settings.heatlevel.roadblocks.desc'
	},
	['helicopters'] = {
		Class = 'DCheckBoxLabel',
		ConVar = 'uvunitmanager_helicopters',
		ToolText = '#tool.uvunitmanager.settings.heatlevel.helicopter',
		ToolTip = '#tool.uvunitmanager.settings.heatlevel.helicopter.desc'
	}
}

local UIElements = {}

TOOL.ClientConVar["selected_heat"] = 1

TOOL.ClientConVar["vehiclebase"] = 3
TOOL.ClientConVar["onecommander"] = 1
TOOL.ClientConVar["onecommanderevading"] = 0
TOOL.ClientConVar["onecommanderhealth"] = 5000
TOOL.ClientConVar["helicoptermodel"] = "Default"
TOOL.ClientConVar["helicopterbarrels"] = 1
TOOL.ClientConVar["helicopterspikestrip"] = 1
TOOL.ClientConVar["helicopterbusting"] = 1

TOOL.ClientConVar["pursuittech"] = 1
TOOL.ClientConVar["pursuittech_esf"] = 1
TOOL.ClientConVar["pursuittech_emp"] = 1
TOOL.ClientConVar["pursuittech_spikestrip"] = 1
TOOL.ClientConVar["pursuittech_killswitch"] = 1
TOOL.ClientConVar["pursuittech_repairkit"] = 1
TOOL.ClientConVar["pursuittech_shockram"] = 1
TOOL.ClientConVar["pursuittech_gpsdart"] = 1

TOOL.ClientConVar["minheat"] = 1
TOOL.ClientConVar["maxheat"] = 6

TOOL.ClientConVar["bountypatrol"] = 1000
TOOL.ClientConVar["bountysupport"] = 5000
TOOL.ClientConVar["bountypursuit"] = 10000
TOOL.ClientConVar["bountyinterceptor"] = 20000
TOOL.ClientConVar["bountyair"] = 75000
TOOL.ClientConVar["bountyspecial"] = 25000
TOOL.ClientConVar["bountycommander"] = 100000
TOOL.ClientConVar["bountyrhino"] = 50000



local defaultvoicetable = {
	"cop1, cop2, cop3, cop4, cop5", --Patrol
	"cop1, cop2, cop3, cop4, cop5", --Support
	"cop1, cop2, cop3, cop4, cop5", --Pursuit
	"cop1, cop2, cop3, cop4, cop5", --Interceptor
	"cop1, cop2, cop3, cop4, cop5", --Special
	"cop1, cop2, cop3, cop4, cop5", --Commander
	"cop1", --Rhino
	"air", --Air
}

for index, v in pairs( {'Patrol', 'Support', 'Pursuit', 'Interceptor', 'Special', 'Commander', 'Rhino', 'Air'} ) do
	local lowercaseUnit = string.lower( v )
	local conVarKey = string.format( '%s_voice', lowercaseUnit )
	local conVarKeyVoiceProfile = string.format( '%s_voiceprofile', lowercaseUnit )
	TOOL.ClientConVar[conVarKey] = defaultvoicetable[index]
	TOOL.ClientConVar[conVarKeyVoiceProfile] = "default"
end

for _, v in pairs( {'Misc', 'Dispatch'} ) do
	local lowercaseType = string.lower( v )
	local conVarKey = string.format( '%s_voiceprofile', lowercaseType )
	TOOL.ClientConVar[conVarKey] = "default"
end

local unitsheat1 = {
	"default_crownvic.json", --Patrol
	"", --Support
	"", --Pursuit
	"", --Interceptor
	"", --Special
	"", --Commander
	"" --Rhino
}

local unitsheat2 = {
	"default_crownvic.json", --Patrol
	"default_explorer.json", --Support
	"", --Pursuit
	"", --Interceptor
	"", --Special
	"", --Commander
	"" --Rhino
}

local unitsheat3 = {
	"default_crownvic.json", --Patrol
	"default_explorer.json", --Support
	"", --Pursuit
	"", --Interceptor
	"", --Special
	"", --Commander
	"" --Rhino
}

local unitsheat4 = {
	"default_crownvic.json", --Patrol
	"default_explorer.json", --Support
	"", --Pursuit
	"", --Interceptor
	"", --Special
	"", --Commander
	"" --Rhino
}

local unitsheat5 = {
	"default_crownvic.json", --Patrol
	"default_explorer.json", --Support
	"", --Pursuit
	"", --Interceptor
	"", --Special
	"", --Commander
	"" --Rhino
}

local unitsheat6 = {
	"default_crownvic.json", --Patrol
	"default_explorer.json", --Support
	"", --Pursuit
	"", --Interceptor
	"", --Special
	"", --Commander
	"" --Rhino
}

for i = 1, MAX_HEAT_LEVEL do
	local prevIterator = i - 1
	
	local timeTillNextHeatId = ((prevIterator == 0 and 'enabled') or prevIterator)

	for index, v in pairs( {'Patrol', 'Support', 'Pursuit', 'Interceptor', 'Special', 'Commander', 'Rhino'} ) do
		local lowercaseUnit = string.lower( v )
		local conVarKey = string.format( 'units%s%s', lowercaseUnit, i )
		local chanceConVarKey = string.format( 'units%s%s_chance', lowercaseUnit, i )
		
		-------------------------------------------
		if i == 1 then
			TOOL.ClientConVar[conVarKey] = unitsheat1[index]
		elseif i == 2 then
			TOOL.ClientConVar[conVarKey] = unitsheat2[index]
		elseif i == 3 then
			TOOL.ClientConVar[conVarKey] = unitsheat3[index]
		elseif i == 4 then
			TOOL.ClientConVar[conVarKey] = unitsheat4[index]
		elseif i == 5 then
			TOOL.ClientConVar[conVarKey] = unitsheat5[index]
		elseif i == 6 then
			TOOL.ClientConVar[conVarKey] = unitsheat6[index]
		else
			TOOL.ClientConVar[conVarKey] = ""
		end

		TOOL.ClientConVar[chanceConVarKey] = 100
	end
	
	for _, conVar in pairs( HEAT_SETTINGS ) do
		local conVarKey = conVar .. ((conVar == 'timetillnextheat' and timeTillNextHeatId) or i)
		local check = (conVar == "timetillnextheat")
		
		TOOL.ClientConVar[conVarKey] = HEAT_DEFAULTS[conVar][tostring( ( check and timeTillNextHeatId ) or i )] or 0
	end
end

local conVarsDefault = TOOL:BuildConVarList()

local conVarList = table.GetKeys(conVarsDefault)

local LEGACY_CONVARS = {
	["uvunitmanager_rhinos"] = {
		Replacement = "uvunitmanager_unitsrhino",
		HasNumber = true,
	},
}

local PROTECTED_CONVARS = {
	['uvunitmanager_selected_heat'] = true,
}

local DEFAULTS = {
	['uvunitmanager_selected_heat'] = 1,
	['uvunitmanager_minheat'] = 1,
	['uvunitmanager_maxheat'] = 6
}

local function _setConVar( cvar, value )
	local valueType = type( value )
	local cvarClass = GetConVar( cvar )

	if valueType == 'number' then
		cvarClass:SetFloat( value )
	else
		cvarClass:SetString( value )
	end
end

UVUnitManagerTool = UVUnitManagerTool or {}

if SERVER then
	
	net.Receive("UVUnitManagerGetUnitInfo", function( length, ply )
		ply.UVTOOLMemory = net.ReadTable()
		ply:SelectWeapon( "gmod_tool" )
	end)

end

if CLIENT then

	local function Export( name )
		local jsonArray = {
			['Name'] = name,
			['Data'] = {}
		}

		for _, cVarKey in pairs( conVarList ) do
			if table.HasValue( PROTECTED_CONVARS, cVarKey ) then continue end

			local cVar = GetConVar( cVarKey )
			if cVar then
				jsonArray.Data[cVarKey] = cVar:GetString()
			end
		end

		if not file.IsDir( 'unitvehicles/preset_export', 'DATA' ) then
			file.CreateDir( 'unitvehicles/preset_export' )
		end

		if not file.IsDir( 'unitvehicles/preset_export/uvunitmanager', 'DATA' ) then
			file.CreateDir( 'unitvehicles/preset_export/uvunitmanager' )
		end

		file.Write( 'unitvehicles/preset_export/uvunitmanager/' .. name .. '.json', util.TableToJSON( jsonArray ) )
		chat.AddText( Color( 0, 150, 0 ), "Your preset has been exported!\nDestination: data/unitvehicles/preset_export/uvunitmanager/" .. name .. ".json" )
	end

	if not file.IsDir( 'data/unitvehicles/preset_import', 'GAME' ) then
		file.CreateDir( 'unitvehicles/preset_import' )
	end

	if not file.IsDir( 'data/unitvehicles/preset_import/uvunitmanager', 'GAME' ) then
		file.CreateDir( 'unitvehicles/preset_import/uvunitmanager' )
	end

	timer.Simple(1, function()
		local importFiles, _ = file.Find( 'data/unitvehicles/preset_import/uvunitmanager/*', 'GAME' )
		
		for _, impFile in pairs( importFiles ) do
			local success = ProtectedCall(function()
				local data = util.JSONToTable( file.Read( 'data/unitvehicles/preset_import/uvunitmanager/' .. impFile, 'GAME' ) )
				
				if type(data) == 'table' and (data.Name and data.Data) then
					presets.Add( 
						'units', 
						data.Name, 
						data.Data 
					)
				else
					error('Malformed JSON data!')
				end
			end)

			if success then
				chat.AddText( Color(0, 255, 0), "[Unit Vehicles (uvunitmanager)]: Added \"" .. string.Split( impFile, '.json' )[1] .. "\" to the presets!" )
			else
				chat.AddText( Color(255, 0, 0), "[Unit Vehicles (uvunitmanager)]: Failed to add \"" .. string.Split( impFile, '.json' )[1] .. "\" to the presets!" )
			end
		end
	end)
	
	TOOL.Information = {
		{ name = "info"},
		{ name = "left" },
		{ name = "right" },
	}

	local selecteditem	= nil
	local UVTOOLMemory	= {}
	
	net.Receive("UVUnitManagerGetUnitInfo", function( length )
		UVTOOLMemory = net.ReadTable()
	end)
	
	net.Receive("UVUnitManagerAdjustUnit", function()
		local UnitAdjust = vgui.Create("DFrame")
		local OK = vgui.Create("DButton")
		local lang = language.GetPhrase
		
		UnitAdjust:Add(OK)
		UnitAdjust:SetSize(600, 400)
		UnitAdjust:SetBackgroundBlur(true)
		UnitAdjust:Center()
		UnitAdjust:SetTitle("#tool.uvunitmanager.create")
		UnitAdjust:SetDraggable(false)
		UnitAdjust:MakePopup()
		
		local Intro = vgui.Create( "DLabel", UnitAdjust )
		Intro:SetPos( 20, 40 )
		Intro:SetText( string.format( lang("tool.uvunitmanager.create.base"), UVTOOLMemory.VehicleBase ) )
		Intro:SizeToContents()
		
		local Intro2 = vgui.Create( "DLabel", UnitAdjust )
		Intro2:SetPos( 20, 60 )
		Intro2:SetText( string.format( lang("tool.uvunitmanager.create.rawname"), UVTOOLMemory.SpawnName ) )
		Intro2:SizeToContents()
		
		local Intro3 = vgui.Create( "DLabel", UnitAdjust )
		Intro3:SetPos( 20, 100 )
		Intro3:SetText( "#tool.uvunitmanager.create.uniquename" )
		Intro3:SizeToContents()
		
		local UnitNameEntry = vgui.Create( "DTextEntry", UnitAdjust )
		UnitNameEntry:SetPos( 20, 120 )
		UnitNameEntry:SetPlaceholderText( "#tool.uvunitmanager.create.name" )
		UnitNameEntry:SetSize(UnitAdjust:GetWide() / 2, 22)
		
		local Intro5 = vgui.Create( "DLabel", UnitAdjust )
		Intro5:SetPos( 20, 160 )
		Intro5:SetText( "#tool.uvunitmanager.create.optional")
		Intro5:SizeToContents()
		
		local AssignToHeatLevelEntry = vgui.Create("DCheckBoxLabel", UnitAdjust )
		AssignToHeatLevelEntry:SetPos( 20, 200 )
		AssignToHeatLevelEntry:SetText("#tool.uvunitmanager.create.optional.assignheatlevel")
		AssignToHeatLevelEntry:SetSize(UnitAdjust:GetWide(), 22)
		
		local Intro4 = vgui.Create( "DLabel", UnitAdjust )
		Intro4:SetPos( 20, 240 )
		Intro4:SetText( "#tool.uvunitmanager.create.optional.class" )
		Intro4:SizeToContents()
		
		local UnitClassEntry = vgui.Create( "DComboBox", UnitAdjust )
		UnitClassEntry:SetPos( 20, 260 )
		UnitClassEntry:SetValue( "1: " .. lang("uv.unit.patrol") )
		UnitClassEntry:AddChoice( "1: " .. lang("uv.unit.patrol") )
		UnitClassEntry:AddChoice( "2: " .. lang("uv.unit.support") )
		UnitClassEntry:AddChoice( "3: " .. lang("uv.unit.pursuit") )
		UnitClassEntry:AddChoice( "4: " .. lang("uv.unit.interceptor") )
		UnitClassEntry:AddChoice( "5: " .. lang("uv.unit.special") )
		UnitClassEntry:AddChoice( "6: " .. lang("uv.unit.commander") )
		UnitClassEntry:AddChoice( "7: " .. lang("uv.unit.rhino") )
		UnitClassEntry:SetSize(UnitAdjust:GetWide() / 2, 22)
		
		local HeatLevelEntry = vgui.Create( "DNumSlider", UnitAdjust )
		HeatLevelEntry:SetPos( 20, 300 )
		HeatLevelEntry:SetText("#tool.uvunitmanager.create.optional.heatlevel")
		HeatLevelEntry:SetValue(1)
		HeatLevelEntry:SetMinMax(1, MAX_HEAT_LEVEL)
		HeatLevelEntry:SetDecimals(0)
		HeatLevelEntry:SetSize(UnitAdjust:GetWide() / 2, 22)
		
		OK:SetText("#tool.uvunitmanager.create.create")
		OK:SetSize(UnitAdjust:GetWide() * 5 / 16, 22)
		OK:Dock(BOTTOM)
		
		function OK:DoClick()
			
			local Name = UnitNameEntry:GetValue()
			local HeatLevel = math.floor(HeatLevelEntry:GetValue())
			local AssignToHeatLevel = AssignToHeatLevelEntry:GetChecked()
			local UnitClass = UnitClassEntry:GetValue()

			if Name ~= "" then
				local charArray = string.Explode( "", string.Trim( Name ) )
				for k, v in pairs(charArray) do
					if v == string.char( 32 ) then
						charArray[k] = string.char( 95 )
					end
				end

				Name = table.concat( charArray )

				if UVTOOLMemory.VehicleBase == "gmod_sent_vehicle_fphysics_base" then
					local DataString = ""
					
					for k,v in pairs(UVTOOLMemory) do
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
					
					file.Write("unitvehicles/simfphys/units/"..Name..".txt", string.Implode("",shit) )
				elseif UVTOOLMemory.VehicleBase == "base_glide_car" or UVTOOLMemory.VehicleBase == "base_glide_motorcycle" then
					local jsondata = util.TableToJSON(UVTOOLMemory)
					file.Write("unitvehicles/glide/units/"..Name..".json", jsondata )
				elseif UVTOOLMemory.VehicleBase == "prop_vehicle_jeep" then
					local DataString = ""
					
					for k,v in pairs(UVTOOLMemory) do
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
					
					file.Write("unitvehicles/prop_vehicle_jeep/units/"..Name..".txt", string.Implode("",shit) )
				end
				
				-- UVUnitManagerScrollPanel:Clear()
				-- UVUnitManagerScrollPanelGlide:Clear()
				-- UVUnitManagerScrollPanelJeep:Clear()
				-- UVUnitManagerGetSaves( UVUnitManagerScrollPanel )
				-- UVUnitManagerGetSavesGlide( UVUnitManagerScrollPanelGlide )
				-- UVUnitManagerGetSavesJeep( UVUnitManagerScrollPanelJeep )
				-- UnitAdjust:Close()
				
				local baseId = GetConVar("uvunitmanager_vehiclebase"):GetInt()
				if IsValid(UVUnitManagerTool.ScrollPanel) and UVUnitManagerTool.PopulateVehicleList then
					UVUnitManagerTool.PopulateVehicleList(baseId)
				end
				UnitAdjust:Close()
				
				local file_ext = (((UVTOOLMemory.VehicleBase == 'base_glide_car' or UVTOOLMemory.VehicleBase == "base_glide_motorcycle") and "json") or "txt")
				
				if AssignToHeatLevel then
					if string.StartsWith(UnitClass, "1") then
						local availableunits = GetConVar("uvunitmanager_unitspatrol"..HeatLevel):GetString()
						if availableunits == "" or availableunits == " " then --blank
							RunConsoleCommand("uvunitmanager_unitspatrol"..HeatLevel, Name.."."..file_ext)
						else
							RunConsoleCommand("uvunitmanager_unitspatrol"..HeatLevel, availableunits.." "..Name.."."..file_ext)
						end
					elseif string.StartsWith(UnitClass, "2") then
						local availableunits = GetConVar("uvunitmanager_unitssupport"..HeatLevel):GetString()
						if availableunits == "" or availableunits == " " then --blank
							RunConsoleCommand("uvunitmanager_unitssupport"..HeatLevel, Name.."."..file_ext)
						else
							RunConsoleCommand("uvunitmanager_unitssupport"..HeatLevel, availableunits.." "..Name.."."..file_ext)
						end
					elseif string.StartsWith(UnitClass, "3") then
						local availableunits = GetConVar("uvunitmanager_unitspursuit"..HeatLevel):GetString()
						if availableunits == "" or availableunits == " " then --blank
							RunConsoleCommand("uvunitmanager_unitspursuit"..HeatLevel, Name.."."..file_ext)
						else
							RunConsoleCommand("uvunitmanager_unitspursuit"..HeatLevel, availableunits.." "..Name.."."..file_ext)
						end
					elseif string.StartsWith(UnitClass, "4") then
						local availableunits = GetConVar("uvunitmanager_unitsinterceptor"..HeatLevel):GetString()
						if availableunits == "" or availableunits == " " then --blank
							RunConsoleCommand("uvunitmanager_unitsinterceptor"..HeatLevel, Name.."."..file_ext)
						else
							RunConsoleCommand("uvunitmanager_unitsinterceptor"..HeatLevel, availableunits.." "..Name.."."..file_ext)
						end
					elseif string.StartsWith(UnitClass, "5") then
						local availableunits = GetConVar("uvunitmanager_unitsspecial"..HeatLevel):GetString()
						if availableunits == "" or availableunits == " " then --blank
							RunConsoleCommand("uvunitmanager_unitsspecial"..HeatLevel, Name.."."..file_ext)
						else
							RunConsoleCommand("uvunitmanager_unitsspecial"..HeatLevel, availableunits.." "..Name.."."..file_ext)
						end
					elseif string.StartsWith(UnitClass, "6") then
						local availableunits = GetConVar("uvunitmanager_unitscommander"..HeatLevel):GetString()
						if availableunits == "" or availableunits == " " then --blank
							RunConsoleCommand("uvunitmanager_unitscommander"..HeatLevel, Name.."."..file_ext)
						else
							RunConsoleCommand("uvunitmanager_unitscommander"..HeatLevel, availableunits.." "..Name.."."..file_ext)
						end
					elseif string.StartsWith(UnitClass, "7") then
						local availableunits = GetConVar("uvunitmanager_unitsrhino"..HeatLevel):GetString()
						if availableunits == "" or availableunits == " " then --blank
							RunConsoleCommand("uvunitmanager_unitsrhino"..HeatLevel, Name.."."..file_ext)
						else
							RunConsoleCommand("uvunitmanager_unitsrhino"..HeatLevel, availableunits.." "..Name.."."..file_ext)
						end
					end
					notification.AddLegacy( string.format( lang("tool.uvunitmanager.saved.heatlevel"), Name, HeatLevel ), NOTIFY_UNDO, 5 )
					Msg( "Saved "..Name.." as a Unit at Heat Level "..HeatLevel.."!\n" )
				else
					notification.AddLegacy( string.format( lang("tool.uvunitmanager.saved"), Name ), NOTIFY_UNDO, 5 )
					Msg( "Saved "..Name.." as a Unit!\n" )
				end
				
				surface.PlaySound( "buttons/button15.wav" )
				
			else
				UnitNameEntry:SetPlaceholderText( "!!! FILL ME UP !!!" )
				surface.PlaySound( "buttons/button10.wav" )
			end
			
		end
	end)
	
	function UVUnitManagerGetSaves( panel )
		local saved_vehicles = file.Find("unitvehicles/simfphys/units/*.txt", "DATA")
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
					
					local DataString = file.Read( "unitvehicles/simfphys/units/"..selecteditem, "DATA" )
					
					local words = string.Explode( "", DataString )
					local shit = {}
					
					for k, v in pairs( words ) do
						shit[k] =  string.char( string.byte( v ) - 20 )
					end
					
					local Data = string.Explode( "#", string.Implode("",shit) )
					
					table.Empty( UVTOOLMemory )
					
					for _,v in pairs(Data) do
						local Var = string.Explode( "=", v )
						local name = Var[1]
						local variable = Var[2]
						
						if name and variable then
							if name == "SubMaterials" then
								UVTOOLMemory[name] = {}
								
								local submats = string.Explode( ",", variable )
								for i = 0, (table.Count( submats ) - 1) do
									UVTOOLMemory[name][i] = submats[i+1]
								end
							else
								UVTOOLMemory[name] = variable
							end
						end
					end
					
					net.Start("UVUnitManagerGetUnitInfo")
					net.WriteTable( UVTOOLMemory )
					net.SendToServer()
				end
			end
			
			index = index + 1
			highlight = not highlight
		end
	end
	
	function UVUnitManagerGetSavesGlide( panel )
		local saved_vehicles = file.Find("unitvehicles/glide/units/*.json", "DATA")
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
					
					local JSONData = file.Read( "unitvehicles/glide/units/"..selecteditem, "DATA" )
					if not JSONData then return end
					
					UVTOOLMemory = util.JSONToTable(JSONData, true)
					
					net.Start("UVUnitManagerGetUnitInfo")
					net.WriteTable( UVTOOLMemory )
					net.SendToServer()
				end
			end
			
			index = index + 1
			highlight = not highlight
		end
	end
	
	function UVUnitManagerGetSavesJeep( panel )
		local saved_vehicles = file.Find("unitvehicles/prop_vehicle_jeep/units/*.txt", "DATA")
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
					
					local DataString = file.Read( "unitvehicles/prop_vehicle_jeep/units/"..selecteditem, "DATA" )
					
					local words = string.Explode( "", DataString )
					local shit = {}
					
					for k, v in pairs( words ) do
						shit[k] =  string.char( string.byte( v ) - 20 )
					end
					
					local Data = string.Explode( "#", string.Implode("",shit) )
					
					table.Empty( UVTOOLMemory )
					
					for _,v in pairs(Data) do
						local Var = string.Explode( "=", v )
						local name = Var[1]
						local variable = Var[2]
						
						if name and variable then
							if name == "SubMaterials" then
								UVTOOLMemory[name] = {}
								
								local submats = string.Explode( ",", variable )
								for i = 0, (table.Count( submats ) - 1) do
									UVTOOLMemory[name][i] = submats[i+1]
								end
							else
								UVTOOLMemory[name] = variable
							end
						end
					end
					
					net.Start("UVUnitManagerGetUnitInfo")
					net.WriteTable( UVTOOLMemory )
					net.SendToServer()
				end
			end
			
			index = index + 1
			highlight = not highlight
		end
	end
	
	function TOOL.BuildCPanel(CPanel)
		local lang = language.GetPhrase
		
		if not file.Exists( "unitvehicles/glide", "DATA" ) then
			file.CreateDir( "unitvehicles/glide/units" )
			print("Created a Glide data file for the Unit Vehicles!")
		end
		
		if not file.Exists( "unitvehicles/simfphys", "DATA" ) then
			file.CreateDir( "unitvehicles/simfphys/units" )
			print("Created a simfphys data file for the Unit Vehicles!")
		end
		
		if not file.Exists( "unitvehicles/prop_vehicle_jeep", "DATA" ) then
			file.CreateDir( "unitvehicles/prop_vehicle_jeep/units" )
			print("Created a Default Vehicle Base data file for the Unit Vehicles!")
		end

		local presetComboBox = CPanel:AddControl("ComboBox", { -- Preset List
			MenuButton = 1,
			Folder = "units",
			Options = {
				["#preset.default"] = conVarsDefault
			},
			CVars = conVarList
		})

		function presetComboBox:OnSelect(index, value, data)
			--print(#data)
			local warned = false
			local count = 0
			local count1 = 0

			for _, newCV in pairs(conVarList) do
				if string.match(newCV, "_chance") and not data[newCV] then 
					_setConVar( newCV, 100 )
					continue
				end -- Backwards compatibility, a little hacky but it works
				if not data[newCV] and GetConVar(newCV) and not PROTECTED_CONVARS[newCV] then _setConVar( newCV, DEFAULTS[newCV] or "" ) end--RunConsoleCommand(newCV, DEFAULTS[newCV] or "") end
			end

			for incomingCV, incomingValue in pairs(data) do
				count1 = count1 + 1
				--local cvNoNumber = string.sub( incomingCV, 1, string.len(incomingCV) - 1 )

				local cvNoNumber = nil
				local number = nil

				local _incomingCV = incomingCV

				while string.match( _incomingCV:sub(-1), "%d" ) and _incomingCV ~= "" do
					number = _incomingCV:sub( -1 )
					cvNoNumber = _incomingCV:sub( 1, -2 )
					_incomingCV = cvNoNumber
				end

				local numberIterator = 0

				if LEGACY_CONVARS[_incomingCV] then
					if not warned then
						warned = true
						local warning = string.format( lang "tool.uvunitmanager.presets.legacy.warning", value )
						notification.AddLegacy( warning, NOTIFY_UNDO, 5 )
					end

					if LEGACY_CONVARS[_incomingCV].HasNumber then
						_setConVar( LEGACY_CONVARS[_incomingCV].Replacement .. number, incomingValue  )
					else
						_setConVar( LEGACY_CONVARS[_incomingCV].Replacement, incomingValue )
					end
				elseif not PROTECTED_CONVARS[incomingCV] then
					_setConVar( incomingCV, incomingValue )
				end
			end
		end

		local applysettings = vgui.Create("DButton") -- Apply Button
		applysettings:SetText("#spawnmenu.savechanges")

		local cooldown = -math.huge

		applysettings.DoClick = function()
			if not LocalPlayer():IsSuperAdmin() then
				notification.AddLegacy( "#tool.settings.superadmin.settings", NOTIFY_ERROR, 5 )
				surface.PlaySound( "buttons/button10.wav" )
				return
			end

			if CurTime() - cooldown < 5 then 
				notification.AddLegacy( "COOLDOWN!", NOTIFY_ERROR, 5 )
				surface.PlaySound( "buttons/button10.wav" )
				return
			end

			cooldown = CurTime()
			
			local convar_table = {}
			
			convar_table['unitvehicle_unit_vehiclebase'] = GetConVar('uvunitmanager_vehiclebase'):GetInt()
			convar_table['unitvehicle_unit_onecommander'] = GetConVar('uvunitmanager_onecommander'):GetInt()
			convar_table['unitvehicle_unit_onecommanderhealth'] = GetConVar('uvunitmanager_onecommanderhealth'):GetInt()
			convar_table['unitvehicle_unit_onecommanderevading'] = GetConVar('uvunitmanager_onecommanderevading'):GetInt()
			
			convar_table['unitvehicle_unit_pursuittech'] = GetConVar('uvunitmanager_pursuittech'):GetInt()
			convar_table['unitvehicle_unit_pursuittech_esf'] = GetConVar('uvunitmanager_pursuittech_esf'):GetInt()
			convar_table['unitvehicle_unit_pursuittech_emp'] = GetConVar('uvunitmanager_pursuittech_emp'):GetInt()
			convar_table['unitvehicle_unit_pursuittech_spikestrip'] = GetConVar('uvunitmanager_pursuittech_spikestrip'):GetInt()
			convar_table['unitvehicle_unit_pursuittech_killswitch'] = GetConVar('uvunitmanager_pursuittech_killswitch'):GetInt()
			convar_table['unitvehicle_unit_pursuittech_repairkit'] = GetConVar('uvunitmanager_pursuittech_repairkit'):GetInt()
			convar_table['unitvehicle_unit_pursuittech_shockram'] = GetConVar('uvunitmanager_pursuittech_shockram'):GetInt()
			convar_table['unitvehicle_unit_pursuittech_gpsdart'] = GetConVar('uvunitmanager_pursuittech_gpsdart'):GetInt()
			
			convar_table['unitvehicle_minheatlevel'] = GetConVar('uvunitmanager_minheat'):GetInt()
			convar_table['unitvehicle_maxheatlevel'] = GetConVar('uvunitmanager_maxheat'):GetInt()
			
			convar_table['unitvehicle_unit_helicoptermodel'] = GetConVar('uvunitmanager_helicoptermodel'):GetString()
			convar_table['unitvehicle_unit_helicopterspikestrip'] = GetConVar('uvunitmanager_helicopterspikestrip'):GetInt()
			convar_table['unitvehicle_unit_helicopterbarrels'] = GetConVar('uvunitmanager_helicopterbarrels'):GetInt()
			convar_table['unitvehicle_unit_helicopterbusting'] = GetConVar('uvunitmanager_helicopterbusting'):GetInt()
			
			convar_table['unitvehicle_unit_bountypatrol'] = GetConVar('uvunitmanager_bountypatrol'):GetInt()
			convar_table['unitvehicle_unit_bountysupport'] = GetConVar('uvunitmanager_bountysupport'):GetInt()
			convar_table['unitvehicle_unit_bountypursuit'] = GetConVar('uvunitmanager_bountypursuit'):GetInt()
			convar_table['unitvehicle_unit_bountyinterceptor'] = GetConVar('uvunitmanager_bountyinterceptor'):GetInt()
			convar_table['unitvehicle_unit_bountyair'] = GetConVar('uvunitmanager_bountyair'):GetInt()
			convar_table['unitvehicle_unit_bountyspecial'] = GetConVar('uvunitmanager_bountyspecial'):GetInt()
			convar_table['unitvehicle_unit_bountycommander'] = GetConVar('uvunitmanager_bountycommander'):GetInt()
			convar_table['unitvehicle_unit_bountyrhino'] = GetConVar('uvunitmanager_bountyrhino'):GetInt()

			convar_table['unitvehicle_unit_timetillnextheatenabled'] = GetConVar('uvunitmanager_timetillnextheatenabled'):GetInt()

			for i = 1, MAX_HEAT_LEVEL - 1 do
				convar_table['unitvehicle_unit_timetillnextheat' .. i] = GetConVar('uvunitmanager_timetillnextheat' .. i):GetInt()
			end

			for _, v in pairs( {'Patrol', 'Support', 'Pursuit', 'Interceptor', 'Special', 'Commander', 'Rhino', 'Air'} ) do
				local lowercaseUnit = string.lower( v )
				convar_table['unitvehicle_unit_' .. lowercaseUnit .. '_voice'] = GetConVar('uvunitmanager_' .. lowercaseUnit .. '_voice'):GetString()
				convar_table['unitvehicle_unit_' .. lowercaseUnit .. '_voiceprofile'] = GetConVar('uvunitmanager_' .. lowercaseUnit .. '_voiceprofile'):GetString()
			end

			for _, v in pairs( {'Misc', 'Dispatch'} ) do
				local lowercaseType = string.lower( v )
				convar_table['unitvehicle_unit_' .. lowercaseType .. '_voiceprofile'] = GetConVar('uvunitmanager_' .. lowercaseType .. '_voiceprofile'):GetString()
			end

			net.Start("UVUpdateSettings")
			net.WriteTable(convar_table)
			net.SendToServer()

			local function ReturnValidString(cVar)
				cVar = GetConVar(cVar)
				local str = cVar:GetString()
				return string.len( str ) > 0 and str or " "
			end
			
			for i = 1, MAX_HEAT_LEVEL do
				table.Empty(convar_table)

				convar_table['unitvehicle_unit_bountytime' .. i] = GetConVar('uvunitmanager_bountytime' .. i):GetInt()

				convar_table['unitvehicle_unit_unitspatrol' .. i .. '_chance'] = GetConVar('uvunitmanager_unitspatrol' .. i .. '_chance'):GetInt()
				convar_table['unitvehicle_unit_unitssupport' .. i .. '_chance'] = GetConVar('uvunitmanager_unitssupport' .. i .. '_chance'):GetInt()
				convar_table['unitvehicle_unit_unitspursuit' .. i .. '_chance'] = GetConVar('uvunitmanager_unitspursuit' .. i .. '_chance'):GetInt()
				convar_table['unitvehicle_unit_unitsinterceptor' .. i .. '_chance'] = GetConVar('uvunitmanager_unitsinterceptor' .. i .. '_chance'):GetInt()
				convar_table['unitvehicle_unit_unitsspecial' .. i .. '_chance'] = GetConVar('uvunitmanager_unitsspecial' .. i .. '_chance'):GetInt()
				convar_table['unitvehicle_unit_unitscommander' .. i .. '_chance'] = GetConVar('uvunitmanager_unitscommander' .. i .. '_chance'):GetInt()
				convar_table['unitvehicle_unit_unitsrhino' .. i .. '_chance'] = GetConVar('uvunitmanager_unitsrhino' .. i .. '_chance'):GetInt()

				convar_table['unitvehicle_unit_unitspatrol' .. i] = ReturnValidString('uvunitmanager_unitspatrol' .. i)
				convar_table['unitvehicle_unit_unitssupport' .. i] = ReturnValidString('uvunitmanager_unitssupport' .. i)
				convar_table['unitvehicle_unit_unitspursuit' .. i] = ReturnValidString('uvunitmanager_unitspursuit' .. i)
				convar_table['unitvehicle_unit_unitsinterceptor' .. i] = ReturnValidString('uvunitmanager_unitsinterceptor' .. i)
				convar_table['unitvehicle_unit_unitsspecial' .. i] = ReturnValidString('uvunitmanager_unitsspecial' .. i)
				convar_table['unitvehicle_unit_unitscommander' .. i] = ReturnValidString('uvunitmanager_unitscommander' .. i)
				convar_table['unitvehicle_unit_unitsrhino' .. i] = ReturnValidString('uvunitmanager_unitsrhino' .. i)

				convar_table['unitvehicle_unit_heatminimumbounty' .. i] = GetConVar('uvunitmanager_heatminimumbounty' .. i):GetInt()
				convar_table['unitvehicle_unit_maxunits' .. i] = GetConVar('uvunitmanager_maxunits' .. i):GetInt()
				convar_table['unitvehicle_unit_unitsavailable' .. i] = GetConVar('uvunitmanager_unitsavailable' .. i):GetInt()
				convar_table['unitvehicle_unit_bustspeed' .. i] = GetConVar('uvunitmanager_bustspeed' .. i):GetInt()
				convar_table['unitvehicle_unit_backuptimer' .. i] = GetConVar('uvunitmanager_backuptimer' .. i):GetInt()
				convar_table['unitvehicle_unit_cooldowntimer' .. i] = GetConVar('uvunitmanager_cooldowntimer' .. i):GetInt()
				convar_table['unitvehicle_unit_roadblocks' .. i] = GetConVar('uvunitmanager_roadblocks' .. i):GetInt()
				convar_table['unitvehicle_unit_helicopters' .. i] = GetConVar('uvunitmanager_helicopters' .. i):GetInt()

				net.Start("UVUpdateSettings")
				net.WriteTable(convar_table)
				net.SendToServer()
			end
			
			notification.AddLegacy( "#tool.uvunitmanager.applied", NOTIFY_UNDO, 5 )
			surface.PlaySound( "buttons/button15.wav" )
			Msg( "#tool.uvunitmanager.applied" )
			
		end
		CPanel:AddItem(applysettings)

		local exportsettings = vgui.Create("DButton")
		exportsettings:SetText("Export Settings")
		exportsettings.DoClick = function()
			Derma_StringRequest("#tool.uvracemanager.export", "What should the preset be named?", cpID, function(txt)
				chat.AddText("Exporting preset...")
				Export( txt )
			end, nil, "#addons.confirm", "#addons.cancel")
		end
		CPanel:AddItem(exportsettings)

		CPanel:AddControl("Label", {
			Text = "#tool.uvunitmanager.settings.desc",
		})
		
		-- Unified Vehicle Base UI
		local vehicleBases = {
			{ id = 1, name = "HL2 Jeep", func = UVUnitManagerGetSavesJeep, path = "unitvehicles/prop_vehicle_jeep/units/", type = "txt" },
			{ id = 2, name = "Simfphys", func = UVUnitManagerGetSaves, path = "unitvehicles/simfphys/units/", type = "txt" },
			{ id = 3, name = "Glide", func = UVUnitManagerGetSavesGlide, path = "unitvehicles/glide/units/", type = "json" }
		}

		local vehicleBaseCombo = vgui.Create("DComboBox")
		vehicleBaseCombo:SetSize(280, 20)
		vehicleBaseCombo:SetTooltip("#tool.uvunitmanager.settings.base.desc")
		local currentBaseId = GetConVar("uvunitmanager_vehiclebase"):GetInt()
		vehicleBaseCombo:SetValue(vehicleBases[currentBaseId].name)
		for _, base in ipairs(vehicleBases) do
			vehicleBaseCombo:AddChoice(base.name, base.id)
		end
		
		-- Scroll Panel
		local FrameListPanel = vgui.Create("DFrame")
		FrameListPanel:SetSize(280, 320)
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
		UVUnitManagerTool.ScrollPanel = ScrollPanel

		-- Also store the population function, so we can call it from net.Receive
		UVUnitManagerTool.PopulateVehicleList = function(baseId)
			ScrollPanel:Clear()
			selecteditem = nil

			for _, base in ipairs(vehicleBases) do
				if base.id == baseId then
					local savedVehicles = file.Find(base.path .. "*." .. base.type, "DATA")
					local index, highlight, offset = 0, false, 22

					if #savedVehicles == 0 then
						local emptyLabel = vgui.Create("DLabel", ScrollPanel)
						emptyLabel:SetText("#tool.uvunitmanager.settings.novehicle")
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

							net.Start("UVUnitManagerGetUnitInfo")
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
		UVUnitManagerTool.PopulateVehicleList(GetConVar("uvunitmanager_vehiclebase"):GetInt())

		if not LocalPlayer():IsSuperAdmin() then return end -- Show settings only if you have permissions.
		
		-- Refresh Button
		local RefreshBtn = vgui.Create("DButton")
		RefreshBtn:SetText("#refresh")
		RefreshBtn:SetSize(280, 20)
		RefreshBtn.DoClick = function()
			UVUnitManagerTool.PopulateVehicleList(GetConVar("uvunitmanager_vehiclebase"):GetInt())
			notification.AddLegacy("#tool.uvunitmanager.refreshed", NOTIFY_UNDO, 5)
			surface.PlaySound("buttons/button15.wav")
		end
		CPanel:AddItem(RefreshBtn)

		-- Delete Button
		local DeleteBtn = vgui.Create("DButton")
		DeleteBtn:SetText("#spawnmenu.menu.delete")
		DeleteBtn:SetSize(280, 20)
		DeleteBtn.DoClick = function()
			local baseId = GetConVar("uvunitmanager_vehiclebase"):GetInt()
			local basePath, baseType
			for _, base in ipairs(vehicleBases) do
				if base.id == baseId then
					basePath, baseType = base.path, base.type
					break
				end
			end
			if isstring(selecteditem) and basePath then
				if file.Delete(basePath .. selecteditem) then
					notification.AddLegacy(string.format(language.GetPhrase("tool.uvunitmanager.deleted"), selecteditem), NOTIFY_UNDO, 5)
					surface.PlaySound("buttons/button15.wav")
					Msg(string.format(language.GetPhrase("tool.uvunitmanager.deleted"), selecteditem))
				end
			end
			UVUnitManagerTool.PopulateVehicleList(baseId)
		end
		CPanel:AddItem(DeleteBtn)
		
		-- Dropdown for vehicle base selection
		CPanel:AddControl("Label", { Text = "#tool.uvunitmanager.settings.base.title" })
		CPanel:AddItem(vehicleBaseCombo)

		CPanel:AddControl("Label", { Text = "" }) -- General Heat Settings
		CPanel:AddControl("Label", { Text = "#tool.uvunitmanager.settings.heatlvlgeneral.title" })

		local TimeTillNextHeatEnabled = vgui.Create("DCheckBoxLabel") -- Timed Heat
		TimeTillNextHeatEnabled:SetText("#tool.uvunitmanager.settings.heatlvl.timed")
		TimeTillNextHeatEnabled:SetConVar("uvunitmanager_timetillnextheatenabled")
		TimeTillNextHeatEnabled:SetTooltip("#tool.uvunitmanager.settings.heatlvl.timed.desc")
		TimeTillNextHeatEnabled:SetValue(GetConVar("uvunitmanager_timetillnextheatenabled"):GetInt())
		TimeTillNextHeatEnabled:SetTextColor(Color(0,0,0))
		CPanel:AddItem(TimeTillNextHeatEnabled)

		local MinHeat = vgui.Create("DNumSlider") -- Min. Heat
		MinHeat:SetText("#tool.uvunitmanager.settings.minmaxheatlvl.min")
		MinHeat:SetTooltip("#tool.uvunitmanager.settings.minmaxheatlvl.min.desc")
		MinHeat:SetMinMax(1, MAX_HEAT_LEVEL)
		MinHeat:SetDecimals(0)
		MinHeat:SetValue(GetConVar("uvunitmanager_minheat"))
		MinHeat:SetConVar("uvunitmanager_minheat")
		CPanel:AddItem(MinHeat)

		local MaxHeat = vgui.Create("DNumSlider") -- Max Heat
		MaxHeat:SetText("#tool.uvunitmanager.settings.minmaxheatlvl.max")
		MaxHeat:SetTooltip("#tool.uvunitmanager.settings.minmaxheatlvl.max.desc")
		MaxHeat:SetMinMax(1, MAX_HEAT_LEVEL)
		MaxHeat:SetDecimals(0)
		MaxHeat:SetValue(GetConVar("uvunitmanager_maxheat"))
		MaxHeat:SetConVar("uvunitmanager_maxheat")
		CPanel:AddItem(MaxHeat)

		CPanel:AddControl("Label", { Text = "" }) -- General Heat Settings
		CPanel:AddControl("Label", { Text = "#tool.uvunitmanager.settings.heatlvl.title" })
		CPanel:AddControl("Label", { Text = "#tool.uvunitmanager.settings.heatlvl.desc" })

		-- Heat Selection Row
		local heatCombo = CPanel:ComboBox("#tool.uvunitmanager.settings.heatlvl")
		heatCombo:SetValue(language.GetPhrase("#tool.uvunitmanager.settings.heatlvl.select"))
		for i = 1, MAX_HEAT_LEVEL do
			heatCombo:AddChoice(i, i)
		end

		-- Settings panel
		local settingsPanel = {}
		for _, setting_name in pairs(HEAT_SETTINGS) do
			local array = UnitSettings[setting_name]
			if not array then continue end

			local element = vgui.Create(array.Class)
			if array.MinMax then element:SetMinMax(array.MinMax[1], array.MinMax[2]) end
			if array.Decimals then element:SetDecimals(array.Decimals) end
			if array.ToolText then element:SetText(array.ToolText) end
			if array.ToolTip then element:SetTooltip(array.ToolTip) end
			if array.ConVar then element.ConVar = array.ConVar end

			element:SetVisible(false)
			settingsPanel[setting_name] = element
			CPanel:AddItem(element)
		end

		-- Unit Dropdown
		-- local unitLabel = vgui.Create("DLabel", CPanel)
		-- unitLabel:SetText(language.GetPhrase("#tool.uvunitmanager.settings.assunits.title"))
		-- unitLabel:SetTextColor(Color(0,0,0))
		-- unitLabel:SetVisible(false)
		-- CPanel:AddItem(unitLabel)

		local unitDesc = vgui.Create("DLabel", CPanel)
		unitDesc:SetText(language.GetPhrase("#tool.uvunitmanager.settings.assunits.desc"))
		unitDesc:SetTextColor(Color(0,0,0))
		unitDesc:SetVisible(false)
		CPanel:AddItem(unitDesc)

		local unitCombo = vgui.Create("DComboBox")
		unitCombo:SetWide(280)
		unitCombo:SetValue(language.GetPhrase("#tool.uvunitmanager.settings.voiceunit.select"))
		unitCombo:SetVisible(false)
		CPanel:AddItem(unitCombo)

		local unitTypes = { "Patrol", "Support", "Pursuit", "Interceptor", "Special", "Commander", "Rhino" }
		for _, v in ipairs(unitTypes) do
			local loc = "#uv.unit." .. string.lower(v)
			unitCombo:AddChoice(language.GetPhrase(loc), v)
		end

		local chanceSlider = vgui.Create("DNumSlider")
		chanceSlider:SetVisible(false)
		chanceSlider:SetText("#tool.uvunitmanager.settings.assunits.chance")
		chanceSlider:SetTooltip("#tool.uvunitmanager.settings.assunits.chance.desc")
		chanceSlider:SetMinMax(0, 100)
		chanceSlider:SetDecimals(0)
		chanceSlider:SetValue(100)
		CPanel:AddItem(chanceSlider)

		-- Vehicle Multi-Choice Panel for Heat/Unit
		local vehiclePanelHeat = vgui.Create("DScrollPanel", CPanel)
		vehiclePanelHeat:SetVisible(false)
		vehiclePanelHeat.Paint = function(self, w, h)
			draw.RoundedBox(5,0,0,w,h,Color(115,115,115,255))
			draw.RoundedBox(5,1,1,w-2,h-2,Color(0,0,0))
		end
		CPanel:AddItem(vehiclePanelHeat)

		local selectedLabel = CPanel:AddControl("Label", { Text = "#tool.uvunitmanager.settings.assunits.selected" })
		selectedLabel:SetVisible(false)

		local selectedVehiclesPanelHeat = vgui.Create("DScrollPanel", CPanel)
		selectedVehiclesPanelHeat:SetVisible(false)
		selectedVehiclesPanelHeat.Paint = function(self, w, h)
			draw.RoundedBox(5,0,0,w,h,Color(115,115,115,255))
			draw.RoundedBox(5,1,1,w-2,h-2,Color(0,0,0))
		end
		CPanel:AddItem(selectedVehiclesPanelHeat)

		-- local buffer = vgui.Create("DPanel", vehiclePanelHeat)
		-- buffer:SetTall(25)
		-- buffer:Dock(BOTTOM)

		-- Populate multi-choice list for selected heat/unit

		local function PopulateSelectedVehiclesPanelHeat(selected, activeButtons, unitName, heatLevel)
			selectedVehiclesPanelHeat:Clear()
			selectedVehiclesPanelHeat:SetVisible(true)
			chanceSlider:SetVisible(true)
			selectedLabel:SetVisible(true)

			local chanceConVar = string.format("uvunitmanager_units%s%s_chance", string.lower(unitName), heatLevel)
			chanceSlider:SetConVar(chanceConVar)
			chanceSlider:SetValue(GetConVar(chanceConVar):GetInt())

			local count = 0
			local entryHeight = 25
			local maxVisible = 12
			
			for unit, isSelected in pairs(selected) do
				if not isSelected then continue end
				count = count + 1
				local btn = vgui.Create("DButton", selectedVehiclesPanelHeat)
				btn:SetText(unit)
				btn:SetTextColor(Color(255,255,255))
				btn:SetTall(22)
				btn:Dock(TOP)
				btn:DockMargin(5,3,5,0)
				
				btn.Paint = function(self,w,h)
					local col = self:IsHovered() and Color(150,0,0) or Color(60,60,60)
					draw.RoundedBox(4,0,0,w,h,col)
				end

				btn.DoClick = function(self)
					selected[unit] = nil
					activeButtons[unit].isActive = false
					btn:Remove()

					count = count - 1
					selectedVehiclesPanelHeat:SetTall(math.min(count, maxVisible) * entryHeight + 5)

					if count == 0 then
						local lbl = vgui.Create("DLabel", selectedVehiclesPanelHeat)
						lbl:SetText("#tool.uvunitmanager.settings.novehicle")
						lbl:SetTextColor(Color(200,200,200))
						lbl:Dock(TOP)
						lbl:DockMargin(5,5,5,5)
						selectedVehiclesPanelHeat:SetTall(25)
					end

					local newList = {}
					for k,v in pairs(selected) do if v then table.insert(newList,k) end end
					RunConsoleCommand(string.format("uvunitmanager_units%s%s", string.lower(unitName), heatLevel), table.concat(newList," "))
				end
			end

			if count == 0 then
				local lbl = vgui.Create("DLabel", selectedVehiclesPanelHeat)
				lbl:SetText("#tool.uvunitmanager.settings.novehicle")
				lbl:SetTextColor(Color(200,200,200))
				lbl:Dock(TOP)
				lbl:DockMargin(5,5,5,5)
				selectedVehiclesPanelHeat:SetTall(25)
				return
			end

			selectedVehiclesPanelHeat:SetTall(math.min(count, maxVisible) * entryHeight + 5)
		end

		local function PopulateVehicleListHeatLvl(baseId, unitName, heatLevel)
			vehiclePanelHeat:Clear()
			--selectedVehiclesPanelHeat:Clear()
			-- vehiclePanelHeat:AddItem(buffer)
			if not unitName or not heatLevel then
				vehiclePanelHeat:SetVisible(false)
				--selectedVehiclesPanelHeat:SetVisible(false)
				return
			end
			vehiclePanelHeat:SetVisible(true)
			--selectedVehiclesPanelHeat:SetVisible(true)

			local base = vehicleBases[baseId]
			if not base then return end
			local savedVehicles = file.Find(base.path .. "*." .. base.type, "DATA")
			if not savedVehicles or #savedVehicles == 0 then
				local lbl = vgui.Create("DLabel", vehiclePanelHeat)
				lbl:SetText("#tool.uvunitmanager.settings.novehicle")
				lbl:SetTextColor(Color(200,200,200))
				lbl:Dock(TOP)
				lbl:DockMargin(5,5,5,5)
				return
			end

			local selectedConVar = GetConVar(string.format("uvunitmanager_units%s%s", string.lower(unitName), heatLevel))
			local selectedStr = selectedConVar:GetString() or ""
			local selected = {}
			for entry in string.gmatch(selectedStr, "([^%s]+)") do
				selected[entry] = true
			end

			local entryHeight = 25
			local maxVisible = 12
			vehiclePanelHeat:SetTall(math.min(#savedVehicles, maxVisible) * entryHeight + 5)

			local activeButtons = {}

			for _, v in ipairs(savedVehicles) do
				local isNotAllowed = string.match(v, string.char( 32 ))

				local btn = vgui.Create("DButton", vehiclePanelHeat)
				btn:SetText(v)
				btn:SetTextColor(Color(255,255,255))
				btn:SetTall(22)
				btn:Dock(TOP)
				btn:DockMargin(5,3,5,0)

				btn.isActive = selected[v] or false
				btn.Paint = function(self,w,h)
					local col = isNotAllowed and Color(150,0,0) or self.isActive and Color(0,150,0) or self:IsHovered() and Color(41,128,185) or Color(60,60,60)
					draw.RoundedBox(4,0,0,w,h,col)
				end

				btn.DoClick = function(self)
					if isNotAllowed then return end
					self.isActive = not self.isActive
					selected[v] = self.isActive

					local newList = {}
					for k,v in pairs(selected) do if v then table.insert(newList,k) end end
					RunConsoleCommand(string.format("uvunitmanager_units%s%s", string.lower(unitName), heatLevel), table.concat(newList," "))

					PopulateSelectedVehiclesPanelHeat(selected, activeButtons, unitName, heatLevel)
				end

				activeButtons[v] = btn
			end

			PopulateSelectedVehiclesPanelHeat(selected, activeButtons, unitName, heatLevel)
		end

		-- Heat selection callback
		local selectedHeat
		heatCombo.OnSelect = function(_, _, display, value)
			selectedHeat = tonumber(value)
			if not selectedHeat then return end

			-- show settings sliders
			for _, el in pairs(settingsPanel) do
				el:SetVisible(true)
				if el.ConVar then
					local conVarName = el.ConVar .. selectedHeat
					el:SetConVar(conVarName)
					local conVar = GetConVar(conVarName)
					if conVar then el:SetValue(conVar:GetFloat()) end
				end
			end

			-- show unit selection
			-- unitLabel:SetVisible(true)
			unitDesc:SetVisible(true)
			unitCombo:SetVisible(true)

			-- read the current selected unit from the combo box if not set
			if not selectedUnit then
				selectedUnit = unitCombo:GetOptionData(unitCombo:GetSelectedID())
			end

			-- refresh vehicle list if unit is selected
			if selectedUnit then
				local baseId = GetConVar("uvunitmanager_vehiclebase"):GetInt()
				PopulateVehicleListHeatLvl(baseId, selectedUnit, selectedHeat)
			end
		end

		-- Unit selection callback
		local selectedUnit
		unitCombo.OnSelect = function(_, _, display, value)
			selectedUnit = value
			if not selectedUnit or not selectedHeat then
				vehiclePanelHeat:SetVisible(false)
				return
			end

			local baseId = GetConVar("uvunitmanager_vehiclebase"):GetInt()
			PopulateVehicleListHeatLvl(baseId, selectedUnit, selectedHeat)
		end

		-- Sync dropdown and slider
		vehicleBaseCombo.OnSelect = function(self, index, value, data)
			local baseId = tonumber(data)
			if not baseId then return end
			RunConsoleCommand("uvunitmanager_vehiclebase", baseId)
			UVUnitManagerTool.PopulateVehicleList(baseId)
			PopulateVehicleListHeatLvl(baseId, selectedUnit, selectedHeat)
		end

		CPanel:AddControl("Label", { Text = "" })
		CPanel:AddControl("Label", { Text = "#tool.uvunitmanager.settings.voiceprofile.title" })
		CPanel:AddControl("Label", { Text = "#tool.uvunitmanager.settings.voiceprofile.desc" })

		-- collect all available voice profiles
		local availableVoiceProfiles = {}
		local _, folders = file.Find("sound/chatter2/*", "GAME")
		if folders then
			for _, v in ipairs(folders) do
				table.insert(availableVoiceProfiles, v)
			end
		end

		-- all valid units
		local unitTypes = { "Patrol", "Support", "Pursuit", "Interceptor", "Special", "Commander", "Rhino", "Air" }

		-- UI refs
		local selectedUnit
		local selectedProfile
		local profileCombo
		local subfolderPanel

		-- unit dropdown
		local unitCombo = CPanel:ComboBox("#tool.uvunitmanager.settings.voiceunit")
		unitCombo:SetWide(280)
		unitCombo:SetValue(language.GetPhrase("#tool.uvunitmanager.settings.voiceunit.select"))
		for _, v in ipairs(unitTypes) do
			local localized
			if v == "Air" then
				localized = "#uv.unit.helicopter"
			else
				localized = "#uv.unit." .. string.lower(v)
			end
			unitCombo:AddChoice(language.GetPhrase(localized), v)
		end

		-- profile dropdown (initially hidden)
		profileCombo = CPanel:ComboBox("#tool.uvunitmanager.settings.voiceprofile", "uvunitmanager_voice_profileselector")
		profileCombo:SetVisible(false)

		-- container for subfolder buttons (initially hidden)
		subfolderPanel = vgui.Create("DScrollPanel", CPanel)
		subfolderPanel:SetVisible(false)
		subfolderPanel.Paint = function(self, w, h)
			draw.RoundedBox(5, 0, 0, w, h, Color(115, 115, 115, 255))
			draw.RoundedBox(5, 1, 1, w - 2, h - 2, Color(0, 0, 0))
		end
		CPanel:AddItem(subfolderPanel)

		-- rebuild subfolder buttons dynamically
		local function RefreshVoiceSubfolders(unit, profile)
			subfolderPanel:Clear()
			if not unit or not profile then
				subfolderPanel:SetVisible(false)
				return
			end

			local voiceCVar = GetConVar("uvunitmanager_" .. string.lower(unit) .. "_voice")
			if not voiceCVar then
				subfolderPanel:SetVisible(false)
				return
			end

			-- parse comma-separated convar into table
			local current = voiceCVar:GetString() or ""
			local selected = {}
			for entry in string.gmatch(current, "([^,]+)") do
				selected[string.Trim(entry)] = true
			end

			-- find subfolders inside chatter2/<profile>/
			local _, subfolders = file.Find("sound/chatter2/" .. profile .. "/*", "GAME")
			if not subfolders then subfolders = {} end

			-- filter out excluded folders
			local displayFolders = {}
			for _, folder in ipairs(subfolders) do
				if folder ~= "dispatch" and folder ~= "misc" then
					table.insert(displayFolders, folder)
				end
			end

			-- no subfolders
			if #displayFolders == 0 then
				subfolderPanel:SetVisible(false)
				return
			end

			-- show the panel
			subfolderPanel:SetVisible(true)

			-- dynamic height: one button = 24px + margin
			local entryHeight = 25
			local maxVisible = 6
			local panelHeight = math.min(#displayFolders, maxVisible) * entryHeight + 5
			subfolderPanel:SetTall(panelHeight)

			for _, folder in ipairs(displayFolders) do
				local btn = vgui.Create("DButton", subfolderPanel)
				btn:SetText(folder)
				btn:SetTextColor(Color(255, 255, 255))
				btn:SetTall(22)
				btn:Dock(TOP)
				btn:DockMargin(5, 3, 5, 0)

				local active = selected[folder] or false
				btn.isActive = active

				btn.Paint = function(self, w, h)
					local col = self.isActive and Color(128, 185, 128) or self:IsHovered() and Color(41, 128, 185, 255) or Color(77, 80, 82, 200)
					draw.RoundedBox(4, 0, 0, w, h, col)
					-- draw.SimpleText(self:GetText(), "DermaDefault", w / 2, h / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end

				btn.DoClick = function(self)
					self.isActive = not self.isActive
					selected[folder] = self.isActive

					local newList = {}
					for k, v in pairs(selected) do
						if v then table.insert(newList, k) end
					end

					RunConsoleCommand("uvunitmanager_" .. string.lower(unit) .. "_voice", table.concat(newList, ","))
				end
			end
		end
		
		for _, unit in ipairs(unitTypes) do
			local profileCVar = GetConVar("uvunitmanager_" .. string.lower(unit) .. "_voiceprofile")
			if profileCVar then
				local currentProfile = profileCVar:GetString() or ""
				if currentProfile ~= "" then
					profileCombo:AddChoice(currentProfile)
				end
			end
		end

		-- when selecting unit
		unitCombo.OnSelect = function(_, _, display, value)
			selectedUnit = value
			if not selectedUnit then
				profileCombo:SetVisible(false)
				subfolderPanel:SetVisible(false)
				return
			end

			-- Repopulate profile list
			profileCombo:SetVisible(true)
			profileCombo:Clear()
			for _, prof in ipairs(availableVoiceProfiles) do
				profileCombo:AddChoice(prof)
			end

			-- Set saved profile
			local profileCVar = GetConVar("uvunitmanager_" .. string.lower(selectedUnit) .. "_voiceprofile")
			if profileCVar then
				local currentProfile = profileCVar:GetString() or ""
				if currentProfile ~= "" then
					profileCombo:SetValue(currentProfile)
					selectedProfile = currentProfile
				else
					selectedProfile = nil
				end
			end

			RefreshVoiceSubfolders(selectedUnit, selectedProfile)
		end

		-- when selecting profile
		profileCombo.OnSelect = function(_, _, value)
			selectedProfile = value
			if not selectedUnit then return end

			RunConsoleCommand("uvunitmanager_" .. string.lower(selectedUnit) .. "_voiceprofile", value)
			RefreshVoiceSubfolders(selectedUnit, selectedProfile)
		end

		-- Dispatch / Misc (simple handling, no per-voice subfolders)
		for _, v in ipairs({ "Dispatch", "Misc" }) do
			local langKey = (v == "Misc") and "#uv.misc" or "#uv.unit." .. string.lower(v)
			local localized = language.GetPhrase(langKey)
			CPanel:AddControl("Label", { Text = localized })

			local key = string.format("uvunitmanager_%s_voiceprofile", string.lower(v))
			local combo = CPanel:ComboBox("#tool.uvunitmanager.settings.voiceprofile", key)
			combo:SetConVar(key)
			for _, prof in ipairs(availableVoiceProfiles) do
				combo:AddChoice(prof)
			end
		end

		CPanel:AddControl("Label", { Text = "" })
		CPanel:AddControl("Label", { Text = "#uv.settings.ptech" })		
		local pursuittech = vgui.Create("DCheckBoxLabel")
		pursuittech:SetText("#tool.uvunitmanager.settings.ptech")
		pursuittech:SetConVar("uvunitmanager_pursuittech")
		pursuittech:SetTooltip("#tool.uvunitmanager.settings.ptech.enable.desc")
		pursuittech:SetValue(GetConVar("uvunitmanager_pursuittech"):GetInt())
		pursuittech:SetTextColor(Color(0,0,0))
		CPanel:AddItem(pursuittech)
		
		CPanel:AddControl("Label", { Text = "#tool.uvunitmanager.settings.ptech.desc" })
		CPanel:AddControl("Label", { Text = "#tool.uvunitmanager.settings.ptech.spawnwith" })
		
		local pursuittech_esf = vgui.Create("DCheckBoxLabel")
		pursuittech_esf:SetText("#uv.ptech.esf")
		pursuittech_esf:SetConVar("uvunitmanager_pursuittech_esf")
		pursuittech_esf:SetTooltip("#tool.uvunitmanager.settings.ptech.spawnwith.desc")
		pursuittech_esf:SetValue(GetConVar("uvunitmanager_pursuittech_esf"):GetInt())
		pursuittech_esf:SetTextColor(Color(0,0,0))
		CPanel:AddItem(pursuittech_esf)

		local pursuittech_emp = vgui.Create("DCheckBoxLabel")
		pursuittech_emp:SetText("#uv.ptech.emp")
		pursuittech_emp:SetConVar("uvunitmanager_pursuittech_emp")
		pursuittech_emp:SetTooltip("#tool.uvunitmanager.settings.ptech.spawnwith.desc")
		pursuittech_emp:SetValue(GetConVar("uvunitmanager_pursuittech_emp"):GetInt())
		pursuittech_emp:SetTextColor(Color(0,0,0))
		CPanel:AddItem(pursuittech_emp)
		
		local pursuittech_spikes = vgui.Create("DCheckBoxLabel")
		pursuittech_spikes:SetText("#uv.ptech.spikes")
		pursuittech_spikes:SetConVar("uvunitmanager_pursuittech_spikestrip")
		pursuittech_spikes:SetTooltip("#tool.uvunitmanager.settings.ptech.spawnwith.desc")
		pursuittech_spikes:SetValue(GetConVar("uvunitmanager_pursuittech_spikestrip"):GetInt())
		pursuittech_spikes:SetTextColor(Color(0,0,0))
		CPanel:AddItem(pursuittech_spikes)
		
		local pursuittech_killswitch = vgui.Create("DCheckBoxLabel")
		pursuittech_killswitch:SetText("#uv.ptech.killswitch")
		pursuittech_killswitch:SetConVar("uvunitmanager_pursuittech_killswitch")
		pursuittech_killswitch:SetTooltip("#tool.uvunitmanager.settings.ptech.spawnwith.desc")
		pursuittech_killswitch:SetValue(GetConVar("uvunitmanager_pursuittech_killswitch"):GetInt())
		pursuittech_killswitch:SetTextColor(Color(0,0,0))
		CPanel:AddItem(pursuittech_killswitch)
		
		local pursuittech_repairkit = vgui.Create("DCheckBoxLabel")
		pursuittech_repairkit:SetText("#uv.ptech.repairkit")
		pursuittech_repairkit:SetConVar("uvunitmanager_pursuittech_repairkit")
		pursuittech_repairkit:SetTooltip("#tool.uvunitmanager.settings.ptech.spawnwith.desc")
		pursuittech_repairkit:SetValue(GetConVar("uvunitmanager_pursuittech_repairkit"):GetInt())
		pursuittech_repairkit:SetTextColor(Color(0,0,0))
		CPanel:AddItem(pursuittech_repairkit)

		local pursuittech_shockram = vgui.Create("DCheckBoxLabel")
		pursuittech_shockram:SetText("#uv.ptech.shockram")
		pursuittech_shockram:SetConVar("uvunitmanager_pursuittech_shockram")
		pursuittech_shockram:SetTooltip("#tool.uvunitmanager.settings.ptech.spawnwith.desc")
		pursuittech_shockram:SetValue(GetConVar("uvunitmanager_pursuittech_shockram"):GetInt())
		pursuittech_shockram:SetTextColor(Color(0,0,0))
		CPanel:AddItem(pursuittech_shockram)

		local pursuittech_gpsdart = vgui.Create("DCheckBoxLabel")
		pursuittech_gpsdart:SetText("#uv.ptech.gpsdart")
		pursuittech_gpsdart:SetConVar("uvunitmanager_pursuittech_gpsdart")
		pursuittech_gpsdart:SetTooltip("#tool.uvunitmanager.settings.ptech.spawnwith.desc")
		pursuittech_gpsdart:SetValue(GetConVar("uvunitmanager_pursuittech_gpsdart"):GetInt())
		pursuittech_gpsdart:SetTextColor(Color(0,0,0))
		CPanel:AddItem(pursuittech_gpsdart)
		
		CPanel:AddControl("Label", { Text = "" })
		CPanel:AddControl("Label", { Text = "#tool.uvunitmanager.settings.commander", })

		local onecommander = vgui.Create("DCheckBoxLabel")
		onecommander:SetText("#tool.uvunitmanager.settings.commander.solo")
		onecommander:SetConVar("uvunitmanager_onecommander")
		onecommander:SetTooltip("#tool.uvunitmanager.settings.commander.solo.desc")
		onecommander:SetValue(GetConVar("uvunitmanager_onecommander"):GetInt())
		onecommander:SetTextColor(Color(0,0,0))
		CPanel:AddItem(onecommander)
		
		local onecommanderevade = vgui.Create("DCheckBoxLabel")
		onecommanderevade:SetText("#tool.uvunitmanager.settings.commander.evading")
		onecommanderevade:SetConVar("uvunitmanager_onecommanderevading")
		onecommanderevade:SetTooltip("#tool.uvunitmanager.settings.commander.evading.desc")
		onecommanderevade:SetValue(GetConVar("uvunitmanager_onecommanderevading"):GetInt())
		onecommanderevade:SetTextColor(Color(0,0,0))
		CPanel:AddItem(onecommanderevade)
				
		local commanderrepair = vgui.Create("DCheckBoxLabel")
		commanderrepair:SetText("#tool.uvunitmanager.settings.commander.norepair")
		commanderrepair:SetConVar("unitvehicle_unit_commanderrepair")
		commanderrepair:SetTooltip("#tool.uvunitmanager.settings.commander.norepair.desc")
		commanderrepair:SetValue(GetConVar("unitvehicle_unit_commanderrepair"):GetInt())
		commanderrepair:SetTextColor(Color(0,0,0))
		CPanel:AddItem(commanderrepair)
		
		local onecommanderhealth = vgui.Create("DNumSlider")
		onecommanderhealth:SetText("#tool.uvunitmanager.settings.commander.health")
		onecommanderhealth:SetMinMax(1000, 10000)
		onecommanderhealth:SetDecimals(0)
		onecommanderhealth:SetValue(GetConVar("uvunitmanager_onecommanderhealth"))
		onecommanderhealth:SetConVar("uvunitmanager_onecommanderhealth")
		onecommanderhealth:SetTooltip("#tool.uvunitmanager.settings.commander.health")
		CPanel:AddItem(onecommanderhealth)
		
		CPanel:AddControl("Label", { Text = "" })
		CPanel:AddControl("Label", { Text = "#tool.uvunitmanager.settings.heli", })
		
		local helicoptermodeltable = {
			"Default",
			"NFS Hot Pursuit 2",
			"NFS Most Wanted",
			"NFS Undercover",
			"NFS Hot Pursuit 2010",
			"NFS No Limits",
			"NFS Rivals, Payback & Heat",
			"NFS Unbound",
			"The Crew"
		}

		local helicoptermodel = CPanel:ComboBox( "#tool.uvunitmanager.settings.heli.model", "uvunitmanager_helicoptermodel" )
		for _, v in pairs( helicoptermodeltable ) do
			helicoptermodel:AddChoice( v )
		end
		helicoptermodel:SetValue( GetConVar("uvunitmanager_helicoptermodel"):GetString() )
		helicoptermodel:SetConVar( "uvunitmanager_helicoptermodel" )
		
		local helicopterbustracer = vgui.Create("DCheckBoxLabel")
		helicopterbustracer:SetText("#tool.uvunitmanager.settings.heli.canbust")
		helicopterbustracer:SetConVar("uvunitmanager_helicopterbusting")
		helicopterbustracer:SetTooltip("#tool.uvunitmanager.settings.heli.canbust.desc")
		helicopterbustracer:SetValue(GetConVar("uvunitmanager_helicopterbusting"):GetInt())
		CPanel:AddItem(helicopterbustracer)
		
		-- CPanel:AddControl("Label", {
			-- Text = "#tool.uvpursuittech.name",
		-- })
		
		CPanel:AddControl("Label", {
			Text = "#tool.uvunitmanager.settings.heli.ptech.note",
		})
		
		local helibarrels = vgui.Create("DCheckBoxLabel")
		helibarrels:SetText("#uv.ptech.expbarrel")
		helibarrels:SetConVar("uvunitmanager_helicopterbarrels")
		helibarrels:SetTooltip("#tool.uvunitmanager.settings.heli.ptech.canuse")
		helibarrels:SetValue(GetConVar("uvunitmanager_helicopterbarrels"):GetInt())
		CPanel:AddItem(helibarrels)
		
		local helispikes = vgui.Create("DCheckBoxLabel")
		helispikes:SetText("#uv.ptech.spikes")
		helispikes:SetConVar("uvunitmanager_helicopterspikestrip")
		helispikes:SetTooltip("#tool.uvunitmanager.settings.heli.ptech.canuse")
		helispikes:SetValue(GetConVar("uvunitmanager_helicopterspikestrip"):GetInt())
		CPanel:AddItem(helispikes)

		CPanel:AddControl("Label", {
			Text = "#tool.uvunitmanager.settings.bounty.disable",
		})
		
		local BountyPatrol = vgui.Create("DNumSlider")
		BountyPatrol:SetText("#uv.unit.patrol")
		BountyPatrol:SetTooltip("#tool.uvunitmanager.settings.bounty.disable.desc")
		BountyPatrol:SetMinMax(0, 1000000)
		BountyPatrol:SetDecimals(0)
		BountyPatrol:SetValue(GetConVar("uvunitmanager_bountypatrol"))
		BountyPatrol:SetConVar("uvunitmanager_bountypatrol")
		CPanel:AddItem(BountyPatrol)
		
		local BountySupport = vgui.Create("DNumSlider")
		BountySupport:SetText("#uv.unit.support")
		BountySupport:SetTooltip("#tool.uvunitmanager.settings.bounty.disable.desc")
		BountySupport:SetMinMax(0, 1000000)
		BountySupport:SetDecimals(0)
		BountySupport:SetValue(GetConVar("uvunitmanager_bountysupport"))
		BountySupport:SetConVar("uvunitmanager_bountysupport")
		CPanel:AddItem(BountySupport)
		
		local BountyPursuit = vgui.Create("DNumSlider")
		BountyPursuit:SetText("#uv.unit.pursuit")
		BountyPursuit:SetTooltip("#tool.uvunitmanager.settings.bounty.disable.desc")
		BountyPursuit:SetMinMax(0, 1000000)
		BountyPursuit:SetDecimals(0)
		BountyPursuit:SetValue(GetConVar("uvunitmanager_bountypursuit"))
		BountyPursuit:SetConVar("uvunitmanager_bountypursuit")
		CPanel:AddItem(BountyPursuit)
		
		local BountyInterceptor = vgui.Create("DNumSlider")
		BountyInterceptor:SetText("#uv.unit.interceptor")
		BountyInterceptor:SetTooltip("#tool.uvunitmanager.settings.bounty.disable.desc")
		BountyInterceptor:SetMinMax(0, 1000000)
		BountyInterceptor:SetDecimals(0)
		BountyInterceptor:SetValue(GetConVar("uvunitmanager_bountyinterceptor"))
		BountyInterceptor:SetConVar("uvunitmanager_bountyinterceptor")
		CPanel:AddItem(BountyInterceptor)
		
		local BountyAir = vgui.Create("DNumSlider")
		BountyAir:SetText("#uv.unit.helicopter")
		BountyAir:SetTooltip("#tool.uvunitmanager.settings.bounty.disable.desc")
		BountyAir:SetMinMax(0, 1000000)
		BountyAir:SetDecimals(0)
		BountyAir:SetValue(GetConVar("uvunitmanager_bountyair"))
		BountyAir:SetConVar("uvunitmanager_bountyair")
		CPanel:AddItem(BountyAir)
		
		local BountySpecial = vgui.Create("DNumSlider")
		BountySpecial:SetText("#uv.unit.special")
		BountySpecial:SetTooltip("#tool.uvunitmanager.settings.bounty.disable.desc")
		BountySpecial:SetMinMax(0, 1000000)
		BountySpecial:SetDecimals(0)
		BountySpecial:SetValue(GetConVar("uvunitmanager_bountyspecial"))
		BountySpecial:SetConVar("uvunitmanager_bountyspecial")
		CPanel:AddItem(BountySpecial)
		
		local BountyCommander = vgui.Create("DNumSlider")
		BountyCommander:SetText("#uv.unit.commander")
		BountyCommander:SetTooltip("#tool.uvunitmanager.settings.bounty.disable.desc")
		BountyCommander:SetMinMax(0, 1000000)
		BountyCommander:SetDecimals(0)
		BountyCommander:SetValue(GetConVar("uvunitmanager_bountycommander"))
		BountyCommander:SetConVar("uvunitmanager_bountycommander")
		CPanel:AddItem(BountyCommander)
		
		local BountyRhino = vgui.Create("DNumSlider")
		BountyRhino:SetText("#uv.unit.rhino")
		BountyRhino:SetTooltip("#tool.uvunitmanager.settings.bounty.disable.desc")
		BountyRhino:SetMinMax(0, 1000000)
		BountyRhino:SetDecimals(0)
		BountyRhino:SetValue(GetConVar("uvunitmanager_bountyrhino"))
		BountyRhino:SetConVar("uvunitmanager_bountyrhino")
		CPanel:AddItem(BountyRhino)

		CPanel:AddControl("Label", { Text = "" })
	end
end

function TOOL:RightClick(trace)
	if CLIENT then return true end
	
	local ent = trace.Entity
	local ply = self:GetOwner()
	
	if not istable(ply.UVTOOLMemory) then 
		ply.UVTOOLMemory = {}
	end
	
	if ent.IsSimfphyscar or ent.IsGlideVehicle or ent:GetClass() == "prop_vehicle_jeep" then
		if not IsValid(ent) then 
			table.Empty( ply.UVTOOLMemory )
			
			net.Start("UVUnitManagerGetUnitInfo")
			net.WriteTable( ply.UVTOOLMemory )
			net.Send( ply )
			
			return false
		end
		
		self:GetVehicleData( ent, ply )
		
	end
	
	net.Start("UVUnitManagerAdjustUnit")
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
	
	if not istable(ply.UVTOOLMemory) then
		ply:PrintMessage( HUD_PRINTTALK, "Select a Unit" )
		return 
	end
	
	if ply.UVTOOLMemory.VehicleBase == "base_glide_car" or ply.UVTOOLMemory.VehicleBase == "base_glide_motorcycle" then
		local SpawnCenter = trace.HitPos
		SpawnCenter.z = SpawnCenter.z - ply.UVTOOLMemory.Mins.z
		
		duplicator.SetLocalPos( SpawnCenter+Vector( 0, 0, 50 ) )
		duplicator.SetLocalAng( Angle( 0, ply:EyeAngles().yaw, 0 ) )
		
		local Ents = duplicator.Paste( self:GetOwner(), ply.UVTOOLMemory.Entities, ply.UVTOOLMemory.Constraints )

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
			PrintMessage( HUD_PRINTTALK, "The vehicle ".. ply.UVTOOLMemory.SpawnName .." dosen't seem to be installed!" )
			return 
		end

		if ply.UVTOOLMemory.SubMaterials then
			if istable( ply.UVTOOLMemory.SubMaterials ) then
				for i = 0, table.Count( ply.UVTOOLMemory.SubMaterials ) do
					Ent:SetSubMaterial( i, ply.UVTOOLMemory.SubMaterials[i] )
				end
			end

			local groups = string.Explode( ",", ply.UVTOOLMemory.BodyGroups)
			for i = 1, table.Count( groups ) do
				Ent:SetBodygroup(i, tonumber(groups[i]) )
			end

			Ent:SetSkin( ply.UVTOOLMemory.Skin )

			local c = string.Explode( ",", ply.UVTOOLMemory.Color )
			local Color =  Color( tonumber(c[1]), tonumber(c[2]), tonumber(c[3]), tonumber(c[4]) )

			local dot = Color.r * Color.g * Color.b * Color.a
			Ent.OldColor = dot
			Ent:SetColor( Color )

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
		undo.SetCustomUndoText( "Undone Glide Unit" )
		
		undo.Finish( "Undo (" .. tostring( table.Count( Ents ) ) ..  ")" )

		if cffunctions then
			for k, v in pairs(Ents) do
				if cffunctions then
					v.NitrousPower = ply.UVTOOLMemory.Entities[k].NitrousPower
					v.NitrousDepletionRate = ply.UVTOOLMemory.Entities[k].NitrousDepletionRate
					v.NitrousRegenRate = ply.UVTOOLMemory.Entities[k].NitrousRegenRate
					v.NitrousRegenDelay = ply.UVTOOLMemory.Entities[k].NitrousRegenDelay
					v.NitrousPitchChangeFrequency = ply.UVTOOLMemory.Entities[k].NitrousPitchChangeFrequency
					v.NitrousPitchMultiplier = ply.UVTOOLMemory.Entities[k].NitrousPitchMultiplier
					v.NitrousBurst = ply.UVTOOLMemory.Entities[k].NitrousBurst
					v.NitrousColor = ply.UVTOOLMemory.Entities[k].NitrousColor
					v.NitrousStartSound = ply.UVTOOLMemory.Entities[k].NitrousStartSound
					v.NitrousLoopingSound = ply.UVTOOLMemory.Entities[k].NitrousLoopingSound
					v.NitrousEndSound = ply.UVTOOLMemory.Entities[k].NitrousEndSound
					v.NitrousEmptySound = ply.UVTOOLMemory.Entities[k].NitrousEmptySound
					v.NitrousReadyBurstSound = ply.UVTOOLMemory.Entities[k].NitrousReadyBurstSound
					v.NitrousStartBurstSound = ply.UVTOOLMemory.Entities[k].NitrousStartBurstSound
					v.NitrousStartBurstAnnotationSound = ply.UVTOOLMemory.Entities[k].NitrousStartBurstAnnotationSound
					v.CriticalDamageSound = ply.UVTOOLMemory.Entities[k].CriticalDamageSound
					v.NitrousEnabled = ply.UVTOOLMemory.Entities[k].NitrousEnabled

					v:SetNWBool( 'NitrousEnabled', ply.UVTOOLMemory.Entities[k].NitrousEnabled == nil and true or ply.UVTOOLMemory.Entities[k].NitrousEnabled )

					if ply.UVTOOLMemory.Entities[k].NitrousColor then
						local r = ply.UVTOOLMemory.Entities[k].NitrousColor.r
						local g = ply.UVTOOLMemory.Entities[k].NitrousColor.g
						local b = ply.UVTOOLMemory.Entities[k].NitrousColor.b
					
						net.Start( "cfnitrouscolor" )
							net.WriteEntity(v)
							net.WriteInt(r, 9)
							net.WriteInt(g, 9)
							net.WriteInt(b, 9)
							net.WriteBool(v.NitrousBurst)
							net.WriteBool(v.NitrousEnabled)
						net.Broadcast()
					end
				end
			end
		end
		
		Ent.UnitVehicle = ply
		Ent.callsign = ply:Nick()
		UVAddToPlayerUnitListVehicle(Ent)
		
		return true
		
	elseif ply.UVTOOLMemory.VehicleBase == "prop_vehicle_jeep" then
		local class = ply.UVTOOLMemory.SpawnName
		local vehicles = list.Get("Vehicles")
		local lst = vehicles[class]
		if not lst then
			PrintMessage( HUD_PRINTTALK, "The vehicle '"..class.."' is missing!")
			return
		end
		
		local Ent = ents.Create("prop_vehicle_jeep")
		Ent.VehicleTable = lst
		Ent.VehicleName = ply.UVTOOLMemory.VehicleName
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
		
		if istable( ply.UVTOOLMemory.SubMaterials ) then
			for i = 0, table.Count( ply.UVTOOLMemory.SubMaterials ) do
				Ent:SetSubMaterial( i, ply.UVTOOLMemory.SubMaterials[i] )
			end
		end
		
		timer.Simple(0.5, function()
			if not IsValid(Ent) then return end
			local groups = string.Explode( ",", ply.UVTOOLMemory.BodyGroups)
			for i = 1, table.Count( groups ) do
				Ent:SetBodygroup(i, tonumber(groups[i]) )
			end
			
			Ent:SetSkin( ply.UVTOOLMemory.Skin )
			
			local c = string.Explode( ",", ply.UVTOOLMemory.Color )
			local Color =  Color( tonumber(c[1]), tonumber(c[2]), tonumber(c[3]), tonumber(c[4]) )
			
			local dot = Color.r * Color.g * Color.b * Color.a
			Ent.OldColor = dot
			Ent:SetColor( Color )
			
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
		
		Ent.UnitVehicle = ply
		Ent.callsign = ply:Nick()
		UVAddToPlayerUnitListVehicle(Ent)
		
		return true
		
	end
	
	local vname = ply.UVTOOLMemory.SpawnName
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
		
		local tsc = string.Explode( ",", ply.UVTOOLMemory.TireSmokeColor )
		Ent:SetTireSmokeColor( Vector( tonumber(tsc[1]), tonumber(tsc[2]), tonumber(tsc[3]) ) )
		
		Ent.Turbocharged = tobool( ply.UVTOOLMemory.HasTurbo )
		Ent.Supercharged = tobool( ply.UVTOOLMemory.HasBlower )
		
		Ent:SetEngineSoundPreset( math.Clamp( tonumber( ply.UVTOOLMemory.SoundPreset ), -1, 23) )
		Ent:SetMaxTorque( math.Clamp( tonumber( ply.UVTOOLMemory.PeakTorque ), 20, 1000) )
		Ent:SetDifferentialGear( math.Clamp( tonumber( ply.UVTOOLMemory.FinalGear ),0.2, 6 ) )
		
		Ent:SetSteerSpeed( math.Clamp( tonumber( ply.UVTOOLMemory.SteerSpeed ), 1, 16 ) )
		Ent:SetFastSteerAngle( math.Clamp( tonumber( ply.UVTOOLMemory.SteerAngFast ), 0, 1) )
		Ent:SetFastSteerConeFadeSpeed( math.Clamp( tonumber( ply.UVTOOLMemory.SteerFadeSpeed ), 1, 5000 ) )
		
		Ent:SetEfficiency( math.Clamp( tonumber( ply.UVTOOLMemory.Efficiency ) ,0.2,4) )
		Ent:SetMaxTraction( math.Clamp( tonumber( ply.UVTOOLMemory.MaxTraction ) , 5,1000) )
		Ent:SetTractionBias( math.Clamp( tonumber( ply.UVTOOLMemory.GripOffset ),-0.99,0.99) )
		Ent:SetPowerDistribution( math.Clamp( tonumber( ply.UVTOOLMemory.PowerDistribution ) ,-1,1) )
		
		Ent:SetBackFire( tobool( ply.UVTOOLMemory.HasBackfire ) )
		Ent:SetDoNotStall( tobool( ply.UVTOOLMemory.DoesntStall ) )
		
		Ent:SetIdleRPM( math.Clamp( tonumber( ply.UVTOOLMemory.IdleRPM ),1,25000) )
		Ent:SetLimitRPM( math.Clamp( tonumber( ply.UVTOOLMemory.MaxRPM ),4,25000) )
		Ent:SetRevlimiter( tobool( ply.UVTOOLMemory.HasRevLimiter ) )
		Ent:SetPowerBandEnd( math.Clamp( tonumber( ply.UVTOOLMemory.PowerEnd ), 3, 25000) )
		Ent:SetPowerBandStart( math.Clamp( tonumber( ply.UVTOOLMemory.PowerStart ) ,2 ,25000) )
		
		Ent:SetTurboCharged( Ent.Turbocharged )
		Ent:SetSuperCharged( Ent.Supercharged )
		Ent:SetBrakePower( math.Clamp( tonumber( ply.UVTOOLMemory.BrakePower ), 0.1, 500) )
		
		Ent:SetSoundoverride( ply.UVTOOLMemory.SoundOverride or "" )
		
		Ent:SetLights_List( Ent.LightsTable or "no_lights" )
		
		Ent:SetBulletProofTires(true)
		
		Ent.snd_horn = ply.UVTOOLMemory.HornSound
		
		Ent.snd_blowoff = ply.UVTOOLMemory.snd_blowoff
		Ent.snd_spool = ply.UVTOOLMemory.snd_spool
		Ent.snd_bloweron = ply.UVTOOLMemory.snd_bloweron
		Ent.snd_bloweroff = ply.UVTOOLMemory.snd_bloweroff
		
		Ent:SetBackfireSound( ply.UVTOOLMemory.backfiresound or "" )
		
		local Gears = {}
		local Data = string.Explode( ",", ply.UVTOOLMemory.Gears  )
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
		
		if istable( ply.UVTOOLMemory.SubMaterials ) then
			for i = 0, table.Count( ply.UVTOOLMemory.SubMaterials ) do
				Ent:SetSubMaterial( i, ply.UVTOOLMemory.SubMaterials[i] )
			end
		end
		
		if ply.UVTOOLMemory.FrontDampingOverride and ply.UVTOOLMemory.FrontConstantOverride and ply.UVTOOLMemory.RearDampingOverride and ply.UVTOOLMemory.RearConstantOverride then
			Ent.FrontDampingOverride = tonumber( ply.UVTOOLMemory.FrontDampingOverride )
			Ent.FrontConstantOverride = tonumber( ply.UVTOOLMemory.FrontConstantOverride )
			Ent.RearDampingOverride = tonumber( ply.UVTOOLMemory.RearDampingOverride )
			Ent.RearConstantOverride = tonumber( ply.UVTOOLMemory.RearConstantOverride )
			
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
		
		Ent:SetFrontSuspensionHeight( tonumber( ply.UVTOOLMemory.FrontHeight ) )
		Ent:SetRearSuspensionHeight( tonumber( ply.UVTOOLMemory.RearHeight ) )
		
		local groups = string.Explode( ",", ply.UVTOOLMemory.BodyGroups)
		for i = 1, table.Count( groups ) do
			Ent:SetBodygroup(i, tonumber(groups[i]) )
		end
		
		Ent:SetSkin( ply.UVTOOLMemory.Skin )
		
		local c = string.Explode( ",", ply.UVTOOLMemory.Color )
		local Color =  Color( tonumber(c[1]), tonumber(c[2]), tonumber(c[3]), tonumber(c[4]) )
		
		local dot = Color.r * Color.g * Color.b * Color.a
		Ent.OldColor = dot
		Ent:SetColor( Color )
		
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
					if ply.UVTOOLMemory.WheelTool_Foffset and ply.UVTOOLMemory.WheelTool_Roffset then
						SetWheelOffset( Ent, ply.UVTOOLMemory.WheelTool_Foffset, ply.UVTOOLMemory.WheelTool_Roffset )
					end
					
					if not ply.UVTOOLMemory.FrontWheelOverride and not ply.UVTOOLMemory.RearWheelOverride then return end
					
					local front_model = ply.UVTOOLMemory.FrontWheelOverride or vehicle.Members.CustomWheelModel
					local front_angle = GetAngleFromSpawnlist(front_model)
					
					local camber = ply.UVTOOLMemory.Camber or 0
					local rear_model = ply.UVTOOLMemory.RearWheelOverride or (vehicle.Members.CustomWheelModel_R and vehicle.Members.CustomWheelModel_R or front_model)
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
		
		Ent.UnitVehicle = ply
		Ent.callsign = ply:Nick()
		UVAddToPlayerUnitListVehicle(Ent)
		
	end)
	
	return true
end

function TOOL:GetVehicleData( ent, ply )
	if not IsValid(ent) then return end
	if not istable(ply.UVTOOLMemory) then ply.UVTOOLMemory = {} end
	
	table.Empty( ply.UVTOOLMemory )
	
	if ent.IsSimfphyscar then
		ply.UVTOOLMemory.VehicleBase = ent:GetClass()
		ply.UVTOOLMemory.SpawnName = ent:GetSpawn_List()
		ply.UVTOOLMemory.SteerSpeed = ent:GetSteerSpeed()
		ply.UVTOOLMemory.SteerFadeSpeed = ent:GetFastSteerConeFadeSpeed()
		ply.UVTOOLMemory.SteerAngFast = ent:GetFastSteerAngle()
		ply.UVTOOLMemory.SoundPreset = ent:GetEngineSoundPreset()
		ply.UVTOOLMemory.IdleRPM = ent:GetIdleRPM()
		ply.UVTOOLMemory.MaxRPM = ent:GetLimitRPM()
		ply.UVTOOLMemory.PowerStart = ent:GetPowerBandStart()
		ply.UVTOOLMemory.PowerEnd = ent:GetPowerBandEnd()
		ply.UVTOOLMemory.PeakTorque = ent:GetMaxTorque()
		ply.UVTOOLMemory.HasTurbo = ent:GetTurboCharged()
		ply.UVTOOLMemory.HasBlower = ent:GetSuperCharged()
		ply.UVTOOLMemory.HasRevLimiter = ent:GetRevlimiter()
		ply.UVTOOLMemory.HasBulletProofTires = ent:GetBulletProofTires()
		ply.UVTOOLMemory.MaxTraction = ent:GetMaxTraction()
		ply.UVTOOLMemory.GripOffset = ent:GetTractionBias()
		ply.UVTOOLMemory.BrakePower = ent:GetBrakePower()
		ply.UVTOOLMemory.PowerDistribution = ent:GetPowerDistribution()
		ply.UVTOOLMemory.Efficiency = ent:GetEfficiency()
		ply.UVTOOLMemory.HornSound = ent.snd_horn
		ply.UVTOOLMemory.HasBackfire = ent:GetBackFire()
		ply.UVTOOLMemory.DoesntStall = ent:GetDoNotStall()
		ply.UVTOOLMemory.SoundOverride = ent:GetSoundoverride()
		
		ply.UVTOOLMemory.FrontHeight = ent:GetFrontSuspensionHeight()
		ply.UVTOOLMemory.RearHeight = ent:GetRearSuspensionHeight()
		
		ply.UVTOOLMemory.Camber = ent.Camber or 0
		
		if ent.FrontDampingOverride and ent.FrontConstantOverride and ent.RearDampingOverride and ent.RearConstantOverride then
			ply.UVTOOLMemory.FrontDampingOverride = ent.FrontDampingOverride
			ply.UVTOOLMemory.FrontConstantOverride = ent.FrontConstantOverride
			ply.UVTOOLMemory.RearDampingOverride = ent.RearDampingOverride
			ply.UVTOOLMemory.RearConstantOverride = ent.RearConstantOverride
		end
		
		if ent.CustomWheels then
			if ent.GhostWheels then
				if IsValid(ent.GhostWheels[1]) then
					ply.UVTOOLMemory.FrontWheelOverride = ent.GhostWheels[1]:GetModel()
				elseif IsValid(ent.GhostWheels[2]) then
					ply.UVTOOLMemory.FrontWheelOverride = ent.GhostWheels[2]:GetModel()
				end
				
				if IsValid(ent.GhostWheels[3]) then
					ply.UVTOOLMemory.RearWheelOverride = ent.GhostWheels[3]:GetModel()
				elseif IsValid(ent.GhostWheels[4]) then
					ply.UVTOOLMemory.RearWheelOverride = ent.GhostWheels[4]:GetModel()
				end
			end
		end
		
		local tsc = ent:GetTireSmokeColor()
		ply.UVTOOLMemory.TireSmokeColor = tsc.r..","..tsc.g..","..tsc.b
		
		local Gears = ""
		for _,v in pairs(ent.Gears) do
			Gears = Gears..v..","
		end
		
		local c = ent:GetColor()
		ply.UVTOOLMemory.Color = c.r..","..c.g..","..c.b..","..c.a
		
		local bodygroups = {}
		for k,v in pairs(ent:GetBodyGroups()) do
			bodygroups[k] = ent:GetBodygroup( k ) 
		end
		
		ply.UVTOOLMemory.BodyGroups = string.Implode( ",", bodygroups)
		
		ply.UVTOOLMemory.Skin = ent:GetSkin()
		
		ply.UVTOOLMemory.Gears = Gears
		ply.UVTOOLMemory.FinalGear = ent:GetDifferentialGear()
		
		if ent.WheelTool_Foffset then
			ply.UVTOOLMemory.WheelTool_Foffset = ent.WheelTool_Foffset
		end
		
		if ent.WheelTool_Roffset then
			ply.UVTOOLMemory.WheelTool_Roffset = ent.WheelTool_Roffset
		end
		
		if ent.snd_blowoff then
			ply.UVTOOLMemory.snd_blowoff = ent.snd_blowoff
		end
		
		if ent.snd_spool then
			ply.UVTOOLMemory.snd_spool = ent.snd_spool
		end
		
		if ent.snd_bloweron then
			ply.UVTOOLMemory.snd_bloweron = ent.snd_bloweron
		end
		
		if ent.snd_bloweroff then
			ply.UVTOOLMemory.snd_bloweroff = ent.snd_bloweroff
		end
		
		ply.UVTOOLMemory.backfiresound = ent:GetBackfireSound()
		
		ply.UVTOOLMemory.SubMaterials = {}
		for i = 0, (table.Count( ent:GetMaterials() ) - 1) do
			ply.UVTOOLMemory.SubMaterials[i] = ent:GetSubMaterial( i )
		end
	elseif ent.IsGlideVehicle then
		local pos = ent:GetPos()
		duplicator.SetLocalPos( pos )
		
		ply.UVTOOLMemory = duplicator.Copy( ent )
		
		duplicator.SetLocalPos( vector_origin )
		duplicator.SetLocalAng( angle_zero )
		
		if ( not ply.UVTOOLMemory ) then return false end
		
		local Key = "VehicleBase"
		ply.UVTOOLMemory[Key] = ent.Base
		local Key2 = "SpawnName"
		ply.UVTOOLMemory[Key2] = ent:GetClass()
		ply.UVTOOLMemory.Mins = Vector(ply.UVTOOLMemory.Mins.x,ply.UVTOOLMemory.Mins.y,0)
		
		ply.UVTOOLMemory.Entities[next(ply.UVTOOLMemory.Entities)].Angle = Angle(0,180,0)
		--ply.UVTOOLMemory.Entities[next(ply.UVTOOLMemory.Entities)].PhysicsObjects[0].Angle = Angle(0,180,0)

		local c = ent:GetColor()
		ply.UVTOOLMemory.Color = c.r..","..c.g..","..c.b..","..c.a
		
		local bodygroups = {}
		for k,v in pairs(ent:GetBodyGroups()) do
			bodygroups[k] = ent:GetBodygroup( k ) 
		end
		
		ply.UVTOOLMemory.BodyGroups = string.Implode( ",", bodygroups)
		
		ply.UVTOOLMemory.Skin = ent:GetSkin()
		
		ply.UVTOOLMemory.SubMaterials = {}
		for i = 0, (table.Count( ent:GetMaterials() ) - 1) do
			ply.UVTOOLMemory.SubMaterials[i] = ent:GetSubMaterial( i )
		end

		for _, v in pairs(ply.UVTOOLMemory.Entities) do
			if cffunctions then
				v.NitrousPower = ent.NitrousPower or 2
				v.NitrousDepletionRate = ent.NitrousDepletionRate or 0.5
				v.NitrousRegenRate = ent.NitrousRegenRate or 0.1
				v.NitrousRegenDelay = ent.NitrousRegenDelay or 2
				v.NitrousPitchChangeFrequency = ent.NitrousPitchChangeFrequency or 1 
				v.NitrousPitchMultiplier = ent.NitrousPitchMultiplier or 0.2
				v.NitrousBurst = ent.NitrousBurst or false
				v.NitrousColor = ent.NitrousColor or Color(35, 204, 255)
				v.NitrousStartSound = ent.NitrousStartSound or "glide_nitrous/nitrous_burst.wav"
				v.NitrousLoopingSound = ent.NitrousLoopingSound or "glide_nitrous/nitrous_burst.wav"
				v.NitrousEndSound = ent.NitrousEndSound or "glide_nitrous/nitrous_activation_whine.wav"
				v.NitrousEmptySound = ent.NitrousEmptySound or "glide_nitrous/nitrous_empty.wav"
				v.NitrousReadyBurstSound = ent.NitrousReadyBurstSound or "glide_nitrous/nitrous_burst/ready/ready.wav"
				v.NitrousStartBurstSound = ent.NitrousStartBurstSound or file.Find("sound/glide_nitrous/nitrous_burst/*", "GAME")
				v.NitrousStartBurstAnnotationSound = ent.NitrousStartBurstAnnotationSound or file.Find("sound/glide_nitrous/nitrous_burst/annotation/*", "GAME")
				v.CriticalDamageSound = ent.CriticalDamageSound or "glide_healthbar/criticaldamage.wav"
				v.NitrousEnabled = ent:GetNWBool( 'NitrousEnabled' )
			end
		end
		
	elseif ent:GetClass() == "prop_vehicle_jeep" then
		ply.UVTOOLMemory.VehicleBase = ent:GetClass()
		ply.UVTOOLMemory.SpawnName = ent:GetVehicleClass()
		ply.UVTOOLMemory.VehicleName = ent.VehicleName
		
		if not ply.UVTOOLMemory.SpawnName then 
			print("This vehicle dosen't have a vehicle class set" )
			return 
		end
		
		local c = ent:GetColor()
		ply.UVTOOLMemory.Color = c.r..","..c.g..","..c.b..","..c.a
		
		local bodygroups = {}
		for k,v in pairs(ent:GetBodyGroups()) do
			bodygroups[k] = ent:GetBodygroup( k ) 
		end
		
		ply.UVTOOLMemory.BodyGroups = string.Implode( ",", bodygroups)
		
		ply.UVTOOLMemory.Skin = ent:GetSkin()
		
		ply.UVTOOLMemory.SubMaterials = {}
		for i = 0, (table.Count( ent:GetMaterials() ) - 1) do
			ply.UVTOOLMemory.SubMaterials[i] = ent:GetSubMaterial( i )
		end
	end
	
	if not IsValid( ply ) then return end

	if ply.UVTOOLMemory.Entities then
		for _, v in pairs(ply.UVTOOLMemory.Entities) do
			v.OnDieFunctions = nil
			v.AutomaticFrameAdvance = nil
			v.BaseClass = nil
		end
	end

	if ply.UVTOOLMemory.Constraints then
		for _, v in pairs(ply.UVTOOLMemory.Constraints) do
			v.OnDieFunctions = nil
		end
	end
	
	net.Start("UVUnitManagerGetUnitInfo")
	net.WriteTable( ply.UVTOOLMemory )
	net.Send( ply )
	
end