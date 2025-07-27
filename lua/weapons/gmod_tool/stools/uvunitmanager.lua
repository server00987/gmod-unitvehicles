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
local rhinos = {}
local heatlevel = {}
local heatminimumbounty = {}
local maxunits = {}
local unitsavailable = {}
local backuptimer = {}
local cooldowntimer = {}
local roadblocks = {}
local helicopters = {}

-- For ConVars, append the heat to the end of the ConVar string
local UnitSettings = {
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
		ToolText = '#tool.uvunitmanager.settings.heatlevel.maxunits',
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

TOOL.ClientConVar["vehiclebase"] = 1
TOOL.ClientConVar["onecommander"] = 1
TOOL.ClientConVar["onecommanderevading"] = 0
TOOL.ClientConVar["onecommanderhealth"] = 5000
TOOL.ClientConVar["helicoptermodel"] = 1
TOOL.ClientConVar["helicopterbarrels"] = 1
TOOL.ClientConVar["helicopterspikestrip"] = 1
TOOL.ClientConVar["helicopterbusting"] = 1

TOOL.ClientConVar["pursuittech"] = 1
TOOL.ClientConVar["pursuittech_esf"] = 1
TOOL.ClientConVar["pursuittech_spikestrip"] = 1
TOOL.ClientConVar["pursuittech_killswitch"] = 1
TOOL.ClientConVar["pursuittech_repairkit"] = 1

TOOL.ClientConVar["bountypatrol"] = 1000
TOOL.ClientConVar["bountysupport"] = 5000
TOOL.ClientConVar["bountypursuit"] = 10000
TOOL.ClientConVar["bountyinterceptor"] = 20000
TOOL.ClientConVar["bountyair"] = 75000
TOOL.ClientConVar["bountyspecial"] = 25000
TOOL.ClientConVar["bountycommander"] = 100000
TOOL.ClientConVar["bountyrhino"] = 50000

-- TOOL.ClientConVar["bountytime1"] = 1000
-- TOOL.ClientConVar["bountytime2"] = 5000
-- TOOL.ClientConVar["bountytime3"] = 10000
-- TOOL.ClientConVar["bountytime4"] = 50000
-- TOOL.ClientConVar["bountytime5"] = 100000
-- TOOL.ClientConVar["bountytime6"] = 500000

-- TOOL.ClientConVar["timetillnextheatenabled"] = 0
-- TOOL.ClientConVar["timetillnextheat1"] = 120
-- TOOL.ClientConVar["timetillnextheat2"] = 120
-- TOOL.ClientConVar["timetillnextheat3"] = 180
-- TOOL.ClientConVar["timetillnextheat4"] = 180
-- TOOL.ClientConVar["timetillnextheat5"] = 600
-- TOOL.ClientConVar["timetillnextheat6"] = 600
-- TOOL.ClientConVar["timetillnextheat7"] = 600
-- TOOL.ClientConVar["timetillnextheat8"] = 600
-- TOOL.ClientConVar["timetillnextheat9"] = 600

-- for i = 1, 6 do
-- 	TOOL.ClientConVar["unitspatrol" .. i] = " "
-- 	TOOL.ClientConVar["unitssupport" .. i] = " "
-- 	TOOL.ClientConVar["unitspursuit" .. i] = " "
-- 	TOOL.ClientConVar["unitsinterceptor" .. i] = " "
-- 	TOOL.ClientConVar["unitsspecial" .. i] = " "
-- 	TOOL.ClientConVar["unitscommander" .. i] = " "
-- 	TOOL.ClientConVar["rhinos" .. i] = " "
-- end

for i = 1, MAX_HEAT_LEVEL do
	local prevIterator = i - 1
	
	local timeTillNextHeatId = ((prevIterator == 0 and 'enabled') or prevIterator)
	
	-- TOOL.ClientConVar['bountytime' .. i] = HeatDefaults['bountytime'][tostring( i )] or 0
	-- TOOL.ClientConVar['timetillnextheat' .. timeTillNextHeatId] = HeatDefaults['timetillnextheat'][tostring( timeTillNextHeatId )] or 0
	
	for _, v in pairs( {'Patrol', 'Support', 'Pursuit', 'Interceptor', 'Special', 'Commander'} ) do
		local lowercaseUnit = string.lower( v )
		local conVarKey = string.format( 'units%s%s', lowercaseUnit, i )
		
		-------------------------------------------
		
		TOOL.ClientConVar[conVarKey] = " "
	end
	
	for _, conVar in pairs( HEAT_SETTINGS ) do
		local conVarKey = conVar .. ((conVar == 'timetillnextheat' and timeTillNextHeatId) or i)
		local check = (conVar == "timetillnextheat")
		
		TOOL.ClientConVar[conVarKey] = HEAT_DEFAULTS[conVar][tostring( ( check and timeTillNextHeatId ) or i )] or 0
	end
	
	-- roboboy hated him, so he decided to not assign him a "units" at the start of his key...
	-- poor guy, now he's lonely outside of the for loop : (
	TOOL.ClientConVar["rhinos" .. i] = " "
end

-- for key, array in pairs( HeatDefaultSettings ) do

-- 	for heat_i, heat_value in pairs( value ) do

-- 	end
-- end

-- --Heat Level 1
-- TOOL.ClientConVar["heatminimumbounty1"] = 1000
-- TOOL.ClientConVar["maxunits1"] = 2
-- TOOL.ClientConVar["unitsavailable1"] = 10
-- TOOL.ClientConVar["backuptimer1"] = 180
-- TOOL.ClientConVar["cooldowntimer1"] = 20
-- TOOL.ClientConVar["roadblocks1"] = 0
-- TOOL.ClientConVar["helicopters1"] = 0

-- --Heat Level 2
-- TOOL.ClientConVar["heatminimumbounty2"] = 10000
-- TOOL.ClientConVar["maxunits2"] = 4
-- TOOL.ClientConVar["unitsavailable2"] = 20
-- TOOL.ClientConVar["backuptimer2"] = 120
-- TOOL.ClientConVar["cooldowntimer2"] = 45
-- TOOL.ClientConVar["roadblocks2"] = 1
-- TOOL.ClientConVar["helicopters2"] = 0

-- --Heat Level 3
-- TOOL.ClientConVar["heatminimumbounty3"] = 100000
-- TOOL.ClientConVar["maxunits3"] = 6
-- TOOL.ClientConVar["unitsavailable3"] = 30
-- TOOL.ClientConVar["backuptimer3"] = 120
-- TOOL.ClientConVar["cooldowntimer3"] = 75
-- TOOL.ClientConVar["roadblocks3"] = 1
-- TOOL.ClientConVar["helicopters3"] = 0

-- --Heat Level 4
-- TOOL.ClientConVar["heatminimumbounty4"] = 500000
-- TOOL.ClientConVar["maxunits4"] = 8
-- TOOL.ClientConVar["unitsavailable4"] = 40
-- TOOL.ClientConVar["backuptimer4"] = 120
-- TOOL.ClientConVar["cooldowntimer4"] = 90
-- TOOL.ClientConVar["roadblocks4"] = 1
-- TOOL.ClientConVar["helicopters4"] = 1

-- --Heat Level 5
-- TOOL.ClientConVar["heatminimumbounty5"] = 1000000
-- TOOL.ClientConVar["maxunits5"] = 10
-- TOOL.ClientConVar["unitsavailable5"] = 50
-- TOOL.ClientConVar["backuptimer5"] = 90
-- TOOL.ClientConVar["cooldowntimer5"] = 120
-- TOOL.ClientConVar["roadblocks5"] = 1
-- TOOL.ClientConVar["helicopters5"] = 1

-- --Heat Level 6
-- TOOL.ClientConVar["heatminimumbounty6"] = 5000000
-- TOOL.ClientConVar["maxunits6"] = 12
-- TOOL.ClientConVar["unitsavailable6"] = 60
-- TOOL.ClientConVar["backuptimer6"] = 90
-- TOOL.ClientConVar["cooldowntimer6"] = 120
-- TOOL.ClientConVar["roadblocks6"] = 1
-- TOOL.ClientConVar["helicopters6"] = 1

local conVarsDefault = TOOL:BuildConVarList()

if SERVER then
	
	net.Receive("UVUnitManagerGetUnitInfo", function( length, ply )
		ply.UVTOOLMemory = net.ReadTable()
		ply:SelectWeapon( "gmod_tool" )
	end)
	
	net.Receive("UVUnitManagerGetUnitAssignment", function()
		local unit = net.ReadString()
		local unitassigned
		
		local UnitsPatrol1 = string.Trim(UVUUnitsPatrol1:GetString())
		if string.find( UnitsPatrol1, unit ) then
			unitassigned = true
			PrintMessage( HUD_PRINTTALK, "'"..unit.."' is assigned as a Patrol Unit at Heat Level 1")
		end
		local UnitsSupport1 = string.Trim(UVUUnitsSupport1:GetString())
		if string.find( UnitsSupport1, unit ) then
			unitassigned = true
			PrintMessage( HUD_PRINTTALK, "'"..unit.."' is assigned as a Support Unit at Heat Level 1")
		end
		local UnitsPursuit1 = string.Trim(UVUUnitsPursuit1:GetString())
		if string.find( UnitsPursuit1, unit ) then
			unitassigned = true
			PrintMessage( HUD_PRINTTALK, "'"..unit.."' is assigned as a Pursuit Unit at Heat Level 1")
		end
		local UnitsInterceptor1 = string.Trim(UVUUnitsInterceptor1:GetString())
		if string.find( UnitsInterceptor1, unit ) then
			unitassigned = true
			PrintMessage( HUD_PRINTTALK, "'"..unit.."' is assigned as an Interceptor Unit at Heat Level 1")
		end
		local UnitsSpecial1 = string.Trim(UVUUnitsSpecial1:GetString())
		if string.find( UnitsSpecial1, unit ) then
			unitassigned = true
			PrintMessage( HUD_PRINTTALK, "'"..unit.."' is assigned as a Special Unit at Heat Level 1")
		end
		local UnitsCommander1 = string.Trim(UVUUnitsCommander1:GetString())
		if string.find( UnitsCommander1, unit ) then
			unitassigned = true
			PrintMessage( HUD_PRINTTALK, "'"..unit.."' is assigned as a Commander Unit at Heat Level 1")
		end
		local UnitsRhino1 = string.Trim(UVURhinos1:GetString())
		if string.find( UnitsRhino1, unit ) then
			unitassigned = true
			PrintMessage( HUD_PRINTTALK, "'"..unit.."' is assigned as a Rhino Unit at Heat Level 1")
		end
		
		local UnitsPatrol2 = string.Trim(UVUUnitsPatrol2:GetString())
		if string.find( UnitsPatrol2, unit ) then
			unitassigned = true
			PrintMessage( HUD_PRINTTALK, "'"..unit.."' is assigned as a Patrol Unit at Heat Level 2")
		end
		local UnitsSupport2 = string.Trim(UVUUnitsSupport2:GetString())
		if string.find( UnitsSupport2, unit ) then
			unitassigned = true
			PrintMessage( HUD_PRINTTALK, "'"..unit.."' is assigned as a Support Unit at Heat Level 2")
		end
		local UnitsPursuit2 = string.Trim(UVUUnitsPursuit2:GetString())
		if string.find( UnitsPursuit2, unit ) then
			unitassigned = true
			PrintMessage( HUD_PRINTTALK, "'"..unit.."' is assigned as a Pursuit Unit at Heat Level 2")
		end
		local UnitsInterceptor2 = string.Trim(UVUUnitsInterceptor2:GetString())
		if string.find( UnitsInterceptor2, unit ) then
			unitassigned = true
			PrintMessage( HUD_PRINTTALK, "'"..unit.."' is assigned as an Interceptor Unit at Heat Level 2")
		end
		local UnitsSpecial2 = string.Trim(UVUUnitsSpecial2:GetString())
		if string.find( UnitsSpecial2, unit ) then
			unitassigned = true
			PrintMessage( HUD_PRINTTALK, "'"..unit.."' is assigned as a Special Unit at Heat Level 2")
		end
		local UnitsCommander2 = string.Trim(UVUUnitsCommander2:GetString())
		if string.find( UnitsCommander2, unit ) then
			unitassigned = true
			PrintMessage( HUD_PRINTTALK, "'"..unit.."' is assigned as a Commander Unit at Heat Level 2")
		end
		local UnitsRhino2 = string.Trim(UVURhinos2:GetString())
		if string.find( UnitsRhino2, unit ) then
			unitassigned = true
			PrintMessage( HUD_PRINTTALK, "'"..unit.."' is assigned as a Rhino Unit at Heat Level 2")
		end
		
		local UnitsPatrol3 = string.Trim(UVUUnitsPatrol3:GetString())
		if string.find( UnitsPatrol3, unit ) then
			unitassigned = true
			PrintMessage( HUD_PRINTTALK, "'"..unit.."' is assigned as a Patrol Unit at Heat Level 3")
		end
		local UnitsSupport3 = string.Trim(UVUUnitsSupport3:GetString())
		if string.find( UnitsSupport3, unit ) then
			unitassigned = true
			PrintMessage( HUD_PRINTTALK, "'"..unit.."' is assigned as a Support Unit at Heat Level 3")
		end
		local UnitsPursuit3 = string.Trim(UVUUnitsPursuit3:GetString())
		if string.find( UnitsPursuit3, unit ) then
			unitassigned = true
			PrintMessage( HUD_PRINTTALK, "'"..unit.."' is assigned as a Pursuit Unit at Heat Level 3")
		end
		local UnitsInterceptor3 = string.Trim(UVUUnitsInterceptor3:GetString())
		if string.find( UnitsInterceptor3, unit ) then
			unitassigned = true
			PrintMessage( HUD_PRINTTALK, "'"..unit.."' is assigned as an Interceptor Unit at Heat Level 3")
		end
		local UnitsSpecial3 = string.Trim(UVUUnitsSpecial3:GetString())
		if string.find( UnitsSpecial3, unit ) then
			unitassigned = true
			PrintMessage( HUD_PRINTTALK, "'"..unit.."' is assigned as a Special Unit at Heat Level 3")
		end
		local UnitsCommander3 = string.Trim(UVUUnitsCommander3:GetString())
		if string.find( UnitsCommander3, unit ) then
			unitassigned = true
			PrintMessage( HUD_PRINTTALK, "'"..unit.."' is assigned as a Commander Unit at Heat Level 3")
		end
		local UnitsRhino3 = string.Trim(UVURhinos3:GetString())
		if string.find( UnitsRhino3, unit ) then
			unitassigned = true
			PrintMessage( HUD_PRINTTALK, "'"..unit.."' is assigned as a Rhino Unit at Heat Level 3")
		end
		
		local UnitsPatrol4 = string.Trim(UVUUnitsPatrol4:GetString())
		if string.find( UnitsPatrol4, unit ) then
			unitassigned = true
			PrintMessage( HUD_PRINTTALK, "'"..unit.."' is assigned as a Patrol Unit at Heat Level 4")
		end
		local UnitsSupport4 = string.Trim(UVUUnitsSupport4:GetString())
		if string.find( UnitsSupport4, unit ) then
			unitassigned = true
			PrintMessage( HUD_PRINTTALK, "'"..unit.."' is assigned as a Support Unit at Heat Level 4")
		end
		local UnitsPursuit4 = string.Trim(UVUUnitsPursuit4:GetString())
		if string.find( UnitsPursuit4, unit ) then
			unitassigned = true
			PrintMessage( HUD_PRINTTALK, "'"..unit.."' is assigned as a Pursuit Unit at Heat Level 4")
		end
		local UnitsInterceptor4 = string.Trim(UVUUnitsInterceptor4:GetString())
		if string.find( UnitsInterceptor4, unit ) then
			unitassigned = true
			PrintMessage( HUD_PRINTTALK, "'"..unit.."' is assigned as an Interceptor Unit at Heat Level 4")
		end
		local UnitsSpecial4 = string.Trim(UVUUnitsSpecial4:GetString())
		if string.find( UnitsSpecial4, unit ) then
			unitassigned = true
			PrintMessage( HUD_PRINTTALK, "'"..unit.."' is assigned as a Special Unit at Heat Level 4")
		end
		local UnitsCommander4 = string.Trim(UVUUnitsCommander4:GetString())
		if string.find( UnitsCommander4, unit ) then
			unitassigned = true
			PrintMessage( HUD_PRINTTALK, "'"..unit.."' is assigned as a Commander Unit at Heat Level 4")
		end
		local UnitsRhino4 = string.Trim(UVURhinos4:GetString())
		if string.find( UnitsRhino4, unit ) then
			unitassigned = true
			PrintMessage( HUD_PRINTTALK, "'"..unit.."' is assigned as a Rhino Unit at Heat Level 4")
		end
		
		local UnitsPatrol5 = string.Trim(UVUUnitsPatrol5:GetString())
		if string.find( UnitsPatrol5, unit ) then
			unitassigned = true
			PrintMessage( HUD_PRINTTALK, "'"..unit.."' is assigned as a Patrol Unit at Heat Level 5")
		end
		local UnitsSupport5 = string.Trim(UVUUnitsSupport5:GetString())
		if string.find( UnitsSupport5, unit ) then
			unitassigned = true
			PrintMessage( HUD_PRINTTALK, "'"..unit.."' is assigned as a Support Unit at Heat Level 5")
		end
		local UnitsPursuit5 = string.Trim(UVUUnitsPursuit5:GetString())
		if string.find( UnitsPursuit5, unit ) then
			unitassigned = true
			PrintMessage( HUD_PRINTTALK, "'"..unit.."' is assigned as a Pursuit Unit at Heat Level 5")
		end
		local UnitsInterceptor5 = string.Trim(UVUUnitsInterceptor5:GetString())
		if string.find( UnitsInterceptor5, unit ) then
			unitassigned = true
			PrintMessage( HUD_PRINTTALK, "'"..unit.."' is assigned as an Interceptor Unit at Heat Level 5")
		end
		local UnitsSpecial5 = string.Trim(UVUUnitsSpecial5:GetString())
		if string.find( UnitsSpecial5, unit ) then
			unitassigned = true
			PrintMessage( HUD_PRINTTALK, "'"..unit.."' is assigned as a Special Unit at Heat Level 5")
		end
		local UnitsCommander5 = string.Trim(UVUUnitsCommander5:GetString())
		if string.find( UnitsCommander5, unit ) then
			unitassigned = true
			PrintMessage( HUD_PRINTTALK, "'"..unit.."' is assigned as a Commander Unit at Heat Level 5")
		end
		local UnitsRhino5 = string.Trim(UVURhinos5:GetString())
		if string.find( UnitsRhino5, unit ) then
			unitassigned = true
			PrintMessage( HUD_PRINTTALK, "'"..unit.."' is assigned as a Rhino Unit at Heat Level 5")
		end
		
		local UnitsPatrol6 = string.Trim(UVUUnitsPatrol6:GetString())
		if string.find( UnitsPatrol6, unit ) then
			unitassigned = true
			PrintMessage( HUD_PRINTTALK, "'"..unit.."' is assigned as a Patrol Unit at Heat Level 6")
		end
		local UnitsSupport6 = string.Trim(UVUUnitsSupport6:GetString())
		if string.find( UnitsSupport6, unit ) then
			unitassigned = true
			PrintMessage( HUD_PRINTTALK, "'"..unit.."' is assigned as a Support Unit at Heat Level 6")
		end
		local UnitsPursuit6 = string.Trim(UVUUnitsPursuit6:GetString())
		if string.find( UnitsPursuit6, unit ) then
			unitassigned = true
			PrintMessage( HUD_PRINTTALK, "'"..unit.."' is assigned as a Pursuit Unit at Heat Level 6")
		end
		local UnitsInterceptor6 = string.Trim(UVUUnitsInterceptor6:GetString())
		if string.find( UnitsInterceptor6, unit ) then
			unitassigned = true
			PrintMessage( HUD_PRINTTALK, "'"..unit.."' is assigned as an Interceptor Unit at Heat Level 6")
		end
		local UnitsSpecial6 = string.Trim(UVUUnitsSpecial6:GetString())
		if string.find( UnitsSpecial6, unit ) then
			unitassigned = true
			PrintMessage( HUD_PRINTTALK, "'"..unit.."' is assigned as a Special Unit at Heat Level 6")
		end
		local UnitsCommander6 = string.Trim(UVUUnitsCommander6:GetString())
		if string.find( UnitsCommander6, unit ) then
			unitassigned = true
			PrintMessage( HUD_PRINTTALK, "'"..unit.."' is assigned as a Commander Unit at Heat Level 6")
		end
		local UnitsRhino6 = string.Trim(UVURhinos6:GetString())
		if string.find( UnitsRhino6, unit ) then
			unitassigned = true
			PrintMessage( HUD_PRINTTALK, "'"..unit.."' is assigned as a Rhino Unit at Heat Level 6")
		end
		
		if unitassigned then
			Entity(1):EmitSound("buttons/button15.wav", 0, 100, 0.5, CHAN_STATIC)
		else
			PrintMessage( HUD_PRINTTALK, "'"..unit.."' is currently NOT assigned to anything!")
			Entity(1):EmitSound("buttons/button10.wav", 0, 100, 0.5, CHAN_STATIC)
		end
		
	end)
end

if CLIENT then
	
	TOOL.Information = {
		{ name = "info"},
		{ name = "left" },
		{ name = "right" },
	}
	
	-- language.Add("tool.uvunitmanager.name", "Unit Manager")
	-- language.Add("tool.uvunitmanager.desc", "Create and manage your own Unit Vehicles!")
	-- language.Add("tool.uvunitmanager.0", "Looking for more options? Find it under the options tab" )
	-- language.Add("tool.uvunitmanager.left", "Spawns the currently selected Unit, incase if you wanna make adjustments" )
	-- language.Add("tool.uvunitmanager.right", "Select the vehicle you would like to be added to the Unit" )
	
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
		HeatLevelEntry:SetMinMax(1, 6)
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
				
				UVUnitManagerScrollPanel:Clear()
				UVUnitManagerScrollPanelGlide:Clear()
				UVUnitManagerScrollPanelJeep:Clear()
				UVUnitManagerGetSaves( UVUnitManagerScrollPanel )
				UVUnitManagerGetSavesGlide( UVUnitManagerScrollPanelGlide )
				UVUnitManagerGetSavesJeep( UVUnitManagerScrollPanelJeep )
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
						local availableunits = GetConVar("uvunitmanager_rhinos"..HeatLevel):GetString()
						if availableunits == "" or availableunits == " " then --blank
							RunConsoleCommand("uvunitmanager_rhinos"..HeatLevel, Name.."."..file_ext)
						else
							RunConsoleCommand("uvunitmanager_rhinos"..HeatLevel, availableunits.." "..Name.."."..file_ext)
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
		
		local applysettings = vgui.Create("DButton")
		applysettings:SetText("#spawnmenu.savechanges")
		applysettings.DoClick = function()
			if not LocalPlayer():IsSuperAdmin() then
				notification.AddLegacy( "#tool.settings.superadmin.settings", NOTIFY_ERROR, 5 )
				surface.PlaySound( "buttons/button10.wav" )
				return
			end
			
			local convar_table = {}
			
			convar_table['unitvehicle_unit_vehiclebase'] = GetConVar('uvunitmanager_vehiclebase'):GetInt()
			convar_table['unitvehicle_unit_onecommander'] = GetConVar('uvunitmanager_onecommander'):GetInt()
			convar_table['unitvehicle_unit_onecommanderhealth'] = GetConVar('uvunitmanager_onecommanderhealth'):GetInt()
			convar_table['unitvehicle_unit_onecommanderevading'] = GetConVar('uvunitmanager_onecommanderevading'):GetInt()
			
			convar_table['unitvehicle_unit_pursuittech'] = GetConVar('uvunitmanager_pursuittech'):GetInt()
			convar_table['unitvehicle_unit_pursuittech_esf'] = GetConVar('uvunitmanager_pursuittech_esf'):GetInt()
			convar_table['unitvehicle_unit_pursuittech_spikestrip'] = GetConVar('uvunitmanager_pursuittech_spikestrip'):GetInt()
			convar_table['unitvehicle_unit_pursuittech_killswitch'] = GetConVar('uvunitmanager_pursuittech_killswitch'):GetInt()
			convar_table['unitvehicle_unit_pursuittech_repairkit'] = GetConVar('uvunitmanager_pursuittech_repairkit'):GetInt()
			
			
			
			convar_table['unitvehicle_unit_helicoptermodel'] = GetConVar('uvunitmanager_helicoptermodel'):GetString()
			convar_table['unitvehicle_unit_helicopterspikestrip'] = GetConVar('uvunitmanager_helicopterspikestrip'):GetInt()
			convar_table['unitvehicle_unit_helicopterbarrels'] = GetConVar('uvunitmanager_helicopterbarrels'):GetInt()
			convar_table['unitvehicle_unit_helicopterbusting'] = GetConVar('uvunitmanager_helicopterbusting'):GetInt()
			
			convar_table['unitvehicle_unit_bountypatrol'] = GetConVar('uvunitmanager_bountypatrol'):GetString()
			convar_table['unitvehicle_unit_bountysupport'] = GetConVar('uvunitmanager_bountysupport'):GetString()
			convar_table['unitvehicle_unit_bountypursuit'] = GetConVar('uvunitmanager_bountypursuit'):GetString()
			convar_table['unitvehicle_unit_bountyinterceptor'] = GetConVar('uvunitmanager_bountyinterceptor'):GetString()
			convar_table['unitvehicle_unit_bountyair'] = GetConVar('uvunitmanager_bountyair'):GetString()
			convar_table['unitvehicle_unit_bountyspecial'] = GetConVar('uvunitmanager_bountyspecial'):GetString()
			convar_table['unitvehicle_unit_bountycommander'] = GetConVar('uvunitmanager_bountycommander'):GetString()
			convar_table['unitvehicle_unit_bountyrhino'] = GetConVar('uvunitmanager_bountyrhino'):GetString()
			
			convar_table['unitvehicle_unit_timetillnextheatenabled'] = GetConVar('uvunitmanager_timetillnextheatenabled'):GetInt()
			
			for i = 1, MAX_HEAT_LEVEL - 1 do
				convar_table['unitvehicle_unit_timetillnextheat' .. i] = GetConVar('uvunitmanager_timetillnextheat' .. i):GetInt()
			end
			
			for i = 1, MAX_HEAT_LEVEL do
				convar_table['unitvehicle_unit_bountytime' .. i] = GetConVar('uvunitmanager_bountytime' .. i):GetInt()
				convar_table['unitvehicle_unit_unitspatrol' .. i] = GetConVar('uvunitmanager_unitspatrol' .. i):GetString()
				convar_table['unitvehicle_unit_unitssupport' .. i] = GetConVar('uvunitmanager_unitssupport' .. i):GetString()
				convar_table['unitvehicle_unit_unitspursuit' .. i] = GetConVar('uvunitmanager_unitspursuit' .. i):GetString()
				convar_table['unitvehicle_unit_unitsinterceptor' .. i] = GetConVar('uvunitmanager_unitsinterceptor' .. i):GetString()
				convar_table['unitvehicle_unit_unitsspecial' .. i] = GetConVar('uvunitmanager_unitsspecial' .. i):GetString()
				convar_table['unitvehicle_unit_unitscommander' .. i] = GetConVar('uvunitmanager_unitscommander' .. i):GetString()
				convar_table['unitvehicle_unit_rhinos' .. i] = GetConVar('uvunitmanager_rhinos' .. i):GetString()
				convar_table['unitvehicle_unit_heatminimumbounty' .. i] = GetConVar('uvunitmanager_heatminimumbounty' .. i):GetInt()
				convar_table['unitvehicle_unit_maxunits' .. i] = GetConVar('uvunitmanager_maxunits' .. i):GetInt()
				convar_table['unitvehicle_unit_unitsavailable' .. i] = GetConVar('uvunitmanager_unitsavailable' .. i):GetInt()
				convar_table['unitvehicle_unit_backuptimer' .. i] = GetConVar('uvunitmanager_backuptimer' .. i):GetInt()
				convar_table['unitvehicle_unit_cooldowntimer' .. i] = GetConVar('uvunitmanager_cooldowntimer' .. i):GetInt()
				convar_table['unitvehicle_unit_roadblocks' .. i] = GetConVar('uvunitmanager_roadblocks' .. i):GetInt()
				convar_table['unitvehicle_unit_helicopters' .. i] = GetConVar('uvunitmanager_helicopters' .. i):GetInt()
			end
			
			net.Start("UVUpdateSettings")
			net.WriteTable(convar_table)
			net.SendToServer()
			
			-- RunConsoleCommand("unitvehicle_unit_vehiclebase", GetConVar("uvunitmanager_vehiclebase"):GetInt())
			-- RunConsoleCommand("unitvehicle_unit_pursuittech", GetConVar("uvunitmanager_pursuittech"):GetInt())
			-- RunConsoleCommand("unitvehicle_unit_pursuittech_esf", GetConVar("uvunitmanager_pursuittech_esf"):GetInt())
			-- RunConsoleCommand("unitvehicle_unit_pursuittech_spikestrip", GetConVar("uvunitmanager_pursuittech_spikestrip"):GetInt())
			-- RunConsoleCommand("unitvehicle_unit_pursuittech_killswitch", GetConVar("uvunitmanager_pursuittech_killswitch"):GetInt())
			-- RunConsoleCommand("unitvehicle_unit_pursuittech_repairkit", GetConVar("uvunitmanager_pursuittech_repairkit"):GetInt())
			-- RunConsoleCommand("unitvehicle_unit_onecommander", GetConVar("uvunitmanager_onecommander"):GetInt())
			-- RunConsoleCommand("unitvehicle_unit_onecommanderhealth", GetConVar("uvunitmanager_onecommanderhealth"):GetInt())
			-- RunConsoleCommand("unitvehicle_unit_onecommanderevading", GetConVar("uvunitmanager_onecommanderevading"):GetInt())
			-- RunConsoleCommand("unitvehicle_unit_helicoptermodel", GetConVar("uvunitmanager_helicoptermodel"):GetString())
			
			-- RunConsoleCommand("unitvehicle_unit_bountypatrol", GetConVar("uvunitmanager_bountypatrol"):GetString())
			-- RunConsoleCommand("unitvehicle_unit_bountysupport", GetConVar("uvunitmanager_bountysupport"):GetString())
			-- RunConsoleCommand("unitvehicle_unit_bountypursuit", GetConVar("uvunitmanager_bountypursuit"):GetString())
			-- RunConsoleCommand("unitvehicle_unit_bountyinterceptor", GetConVar("uvunitmanager_bountyinterceptor"):GetString())
			-- RunConsoleCommand("unitvehicle_unit_bountyair", GetConVar("uvunitmanager_bountyair"):GetString())
			-- RunConsoleCommand("unitvehicle_unit_bountyspecial", GetConVar("uvunitmanager_bountyspecial"):GetString())
			-- RunConsoleCommand("unitvehicle_unit_bountycommander", GetConVar("uvunitmanager_bountycommander"):GetString())
			-- RunConsoleCommand("unitvehicle_unit_bountyrhino", GetConVar("uvunitmanager_bountyrhino"):GetString())
			
			-- RunConsoleCommand("unitvehicle_unit_timetillnextheatenabled", GetConVar("uvunitmanager_timetillnextheatenabled"):GetInt())
			-- for i = 1, MAX_HEAT_LEVEL - 1 do
			-- 	RunConsoleCommand("unitvehicle_unit_timetillnextheat" .. i, GetConVar("uvunitmanager_timetillnextheat" .. i):GetInt())
			-- end
			
			-- for i = 1, MAX_HEAT_LEVEL do
			-- 	RunConsoleCommand("unitvehicle_unit_bountytime" .. i, GetConVar("uvunitmanager_bountytime" .. i):GetInt())
			-- 	RunConsoleCommand("unitvehicle_unit_unitspatrol" .. i, GetConVar("uvunitmanager_unitspatrol" .. i):GetString())
			-- 	RunConsoleCommand("unitvehicle_unit_unitssupport" .. i, GetConVar("uvunitmanager_unitssupport" .. i):GetString())
			-- 	RunConsoleCommand("unitvehicle_unit_unitspursuit" .. i, GetConVar("uvunitmanager_unitspursuit" .. i):GetString())
			-- 	RunConsoleCommand("unitvehicle_unit_unitsinterceptor" .. i, GetConVar("uvunitmanager_unitsinterceptor" .. i):GetString())
			-- 	RunConsoleCommand("unitvehicle_unit_unitsspecial" .. i, GetConVar("uvunitmanager_unitsspecial" .. i):GetString())
			-- 	RunConsoleCommand("unitvehicle_unit_unitscommander" .. i, GetConVar("uvunitmanager_unitscommander" .. i):GetString())
			-- 	RunConsoleCommand("unitvehicle_unit_rhinos" .. i, GetConVar("uvunitmanager_rhinos" .. i):GetString())
			-- 	RunConsoleCommand("unitvehicle_unit_heatminimumbounty" .. i, GetConVar("uvunitmanager_heatminimumbounty" .. i):GetInt())
			-- 	RunConsoleCommand("unitvehicle_unit_maxunits" .. i, GetConVar("uvunitmanager_maxunits" .. i):GetInt())
			-- 	RunConsoleCommand("unitvehicle_unit_unitsavailable" .. i, GetConVar("uvunitmanager_unitsavailable" .. i):GetInt())
			-- 	RunConsoleCommand("unitvehicle_unit_backuptimer" .. i, GetConVar("uvunitmanager_backuptimer" .. i):GetInt())
			-- 	RunConsoleCommand("unitvehicle_unit_cooldowntimer" .. i, GetConVar("uvunitmanager_cooldowntimer" .. i):GetInt())
			-- 	RunConsoleCommand("unitvehicle_unit_roadblocks" .. i, GetConVar("uvunitmanager_roadblocks" .. i):GetInt())
			-- 	RunConsoleCommand("unitvehicle_unit_helicopters" .. i, GetConVar("uvunitmanager_helicopters" .. i):GetInt())
			-- end
			
			notification.AddLegacy( "#tool.uvunitmanager.applied", NOTIFY_UNDO, 5 )
			surface.PlaySound( "buttons/button15.wav" )
			Msg( "#tool.uvunitmanager.applied" )
			
		end
		CPanel:AddItem(applysettings)
		
		CPanel:AddControl("ComboBox", {
			MenuButton = 1,
			Folder = "units",
			Options = {
				["#preset.default"] = conVarsDefault
			},
			CVars = table.GetKeys(conVarsDefault)
		})
		
		CPanel:AddControl("Label", {
			Text = "#tool.settings.clickapply",
		})
		
		CPanel:AddControl("Label", {
			Text = "#tool.uvunitmanager.settings.note",
		})
		
		CPanel:AddControl("Label", {
			Text = "#tool.uvunitmanager.settings.global.simphys",
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
		
		UVUnitManagerScrollPanel = vgui.Create( "DScrollPanel", Frame )
		UVUnitManagerScrollPanel:SetSize( 280, 320 )
		UVUnitManagerScrollPanel:SetPos( 0, 0 )
		
		UVUnitManagerGetSaves( UVUnitManagerScrollPanel )
		
		local Assignment = vgui.Create( "DButton", CPanel )
		Assignment:SetText( "#tool.uvunitmanager.settings.getunitassign" )
		Assignment:SetSize( 280, 20 )
		Assignment.DoClick = function( self )
			if isstring(selecteditem) then
				net.Start("UVUnitManagerGetUnitAssignment")
				net.WriteString(selecteditem)
				net.SendToServer()
			end
		end
		CPanel:AddItem(Assignment)
		
		local Refresh = vgui.Create( "DButton", CPanel )
		Refresh:SetText( "#refresh" )
		Refresh:SetSize( 280, 20 )
		Refresh.DoClick = function( self )
			UVUnitManagerScrollPanel:Clear()
			selecteditem = nil
			UVUnitManagerGetSaves( UVUnitManagerScrollPanel )
			notification.AddLegacy( "#tool.uvunitmanager.refreshed", NOTIFY_UNDO, 5 )
			surface.PlaySound( "buttons/button15.wav" )
		end
		CPanel:AddItem(Refresh)
		
		local Delete = vgui.Create( "DButton", CPanel )
		Delete:SetText( "#spawnmenu.menu.delete" )
		Delete:SetSize( 280, 20 )
		Delete.DoClick = function( self )
			
			if isstring(selecteditem) then
				if file.Delete( "unitvehicles/simfphys/units/"..selecteditem ) then
					notification.AddLegacy( string.format( lang("tool.uvunitmanager.deleted"), selecteditem ), NOTIFY_UNDO, 5 )
					surface.PlaySound( "buttons/button15.wav" )
					Msg( string.format( lang("tool.uvunitmanager.deleted"), selecteditem ) )
				end
			end
			
			UVUnitManagerScrollPanel:Clear()
			selecteditem = nil
			UVUnitManagerGetSaves( UVUnitManagerScrollPanel )
		end
		CPanel:AddItem(Delete)
		
		CPanel:AddControl("Label", {
			Text = "#tool.uvunitmanager.settings.global.glide",
		})
		
		local FrameGlide = vgui.Create( "DFrame" )
		FrameGlide:SetSize( 280, 320 )
		FrameGlide:SetTitle( "" )
		FrameGlide:SetVisible( true )
		FrameGlide:ShowCloseButton( false )
		FrameGlide:SetDraggable( false )
		FrameGlide.Paint = function( self, w, h )
			draw.RoundedBox( 5, 0, 0, w, h, Color( 115, 115, 115, 255 ) )
			draw.RoundedBox( 5, 1, 1, w - 2, h - 2, Color( 0, 0, 0) )
		end
		CPanel:AddItem(FrameGlide)
		
		UVUnitManagerScrollPanelGlide = vgui.Create( "DScrollPanel", FrameGlide )
		UVUnitManagerScrollPanelGlide:SetSize( 280, 320 )
		UVUnitManagerScrollPanelGlide:SetPos( 0, 0 )
		
		UVUnitManagerGetSavesGlide( UVUnitManagerScrollPanelGlide )
		
		local AssignmentGlide = vgui.Create( "DButton", CPanel )
		AssignmentGlide:SetText( "#tool.uvunitmanager.settings.getunitassign" )
		AssignmentGlide:SetSize( 280, 20 )
		AssignmentGlide.DoClick = function( self )
			if isstring(selecteditem) then
				net.Start("UVUnitManagerGetUnitAssignment")
				net.WriteString(selecteditem)
				net.SendToServer()
			end
		end
		CPanel:AddItem(AssignmentGlide)
		
		local RefreshGlide = vgui.Create( "DButton", CPanel )
		RefreshGlide:SetText( "#refresh" )
		RefreshGlide:SetSize( 280, 20 )
		RefreshGlide.DoClick = function( self )
			UVUnitManagerScrollPanelGlide:Clear()
			selecteditem = nil
			UVUnitManagerGetSavesGlide( UVUnitManagerScrollPanelGlide )
			notification.AddLegacy( "#tool.uvunitmanager.refreshed", NOTIFY_UNDO, 5 )
			surface.PlaySound( "buttons/button15.wav" )
		end
		CPanel:AddItem(RefreshGlide)
		
		local DeleteGlide = vgui.Create( "DButton", CPanel )
		DeleteGlide:SetText( "#spawnmenu.menu.delete" )
		DeleteGlide:SetSize( 280, 20 )
		DeleteGlide.DoClick = function( self )
			
			if isstring(selecteditem) then
				if file.Delete( "unitvehicles/glide/units/"..selecteditem ) then
					notification.AddLegacy( string.format( lang("tool.uvunitmanager.deleted"), selecteditem ), NOTIFY_UNDO, 5 )
					surface.PlaySound( "buttons/button15.wav" )
					Msg( string.format( lang("tool.uvunitmanager.deleted"), selecteditem ) )
				end
			end
			
			UVUnitManagerScrollPanelGlide:Clear()
			selecteditem = nil
			UVUnitManagerGetSavesGlide( UVUnitManagerScrollPanelGlide )
		end
		CPanel:AddItem(DeleteGlide)
		
		CPanel:AddControl("Label", {
			Text = "#tool.uvunitmanager.settings.global.hl2",
		})
		
		local FrameJeep = vgui.Create( "DFrame" )
		FrameJeep:SetSize( 280, 320 )
		FrameJeep:SetTitle( "" )
		FrameJeep:SetVisible( true )
		FrameJeep:ShowCloseButton( false )
		FrameJeep:SetDraggable( false )
		FrameJeep.Paint = function( self, w, h )
			draw.RoundedBox( 5, 0, 0, w, h, Color( 115, 115, 115, 255 ) )
			draw.RoundedBox( 5, 1, 1, w - 2, h - 2, Color( 0, 0, 0) )
		end
		CPanel:AddItem(FrameJeep)
		
		UVUnitManagerScrollPanelJeep = vgui.Create( "DScrollPanel", FrameJeep )
		UVUnitManagerScrollPanelJeep:SetSize( 280, 320 )
		UVUnitManagerScrollPanelJeep:SetPos( 0, 0 )
		
		UVUnitManagerGetSavesJeep( UVUnitManagerScrollPanelJeep )
		
		local AssignmentJeep = vgui.Create( "DButton", CPanel )
		AssignmentJeep:SetText( "#tool.uvunitmanager.settings.getunitassign" )
		AssignmentJeep:SetSize( 280, 20 )
		AssignmentJeep.DoClick = function( self )
			if isstring(selecteditem) then
				net.Start("UVUnitManagerGetUnitAssignment")
				net.WriteString(selecteditem)
				net.SendToServer()
			end
		end
		CPanel:AddItem(AssignmentJeep)
		
		local RefreshJeep = vgui.Create( "DButton", CPanel )
		RefreshJeep:SetText( "#refresh" )
		RefreshJeep:SetSize( 280, 20 )
		RefreshJeep.DoClick = function( self )
			UVUnitManagerScrollPanelJeep:Clear()
			selecteditem = nil
			UVUnitManagerGetSavesJeep( UVUnitManagerScrollPanelJeep )
			notification.AddLegacy( "#tool.uvunitmanager.refreshed", NOTIFY_UNDO, 5 )
			surface.PlaySound( "buttons/button15.wav" )
		end
		CPanel:AddItem(RefreshJeep)
		
		local DeleteJeep = vgui.Create( "DButton", CPanel )
		DeleteJeep:SetText( "#spawnmenu.menu.delete" )
		DeleteJeep:SetSize( 280, 20 )
		DeleteJeep.DoClick = function( self )
			
			if isstring(selecteditem) then
				if file.Delete( "unitvehicles/prop_vehicle_jeep/units/"..selecteditem ) then
					notification.AddLegacy( string.format( lang("tool.uvunitmanager.deleted"), selecteditem ), NOTIFY_UNDO, 5 )
					surface.PlaySound( "buttons/button15.wav" )
					Msg( string.format( lang("tool.uvunitmanager.deleted"), selecteditem ) )
				end
			end
			
			UVUnitManagerScrollPanelJeep:Clear()
			selecteditem = nil
			UVUnitManagerGetSavesJeep( UVUnitManagerScrollPanelJeep )
		end
		CPanel:AddItem(DeleteJeep)
		
		CPanel:AddControl("Label", {
			Text = "#tool.uvunitmanager.settings.base.title",
		})
		
		CPanel:AddControl("Label", {
			Text = "#tool.uvunitmanager.settings.base.desc",
		})
		
		local vehiclebase = vgui.Create("DNumSlider")
		vehiclebase:SetText("#tool.uvunitmanager.settings.base")
		vehiclebase:SetTooltip("#tool.uvunitmanager.settings.base.type")
		vehiclebase:SetMinMax(1, 3)
		vehiclebase:SetDecimals(0)
		vehiclebase:SetValue(GetConVar("uvunitmanager_vehiclebase"))
		vehiclebase:SetConVar("uvunitmanager_vehiclebase")
		CPanel:AddItem(vehiclebase)
		
		-- CPanel:AddControl("Label", {
		-- Text = "1 = Default Vehicle Base (prop_vehicle_jeep)\n2 = simfphys\n3 = Glide",
		-- })
		
		CPanel:AddControl("Label", {
			Text = "#uv.settings.ptech",
		})
		
		CPanel:AddControl("Label", {
			Text = "#tool.uvunitmanager.settings.ptech.desc",
		})
		
		local pursuittech = vgui.Create("DCheckBoxLabel")
		pursuittech:SetText("#tool.uvunitpursuittech.name")
		pursuittech:SetConVar("uvunitmanager_pursuittech")
		pursuittech:SetTooltip("#tool.uvunitmanager.settings.ptech.enable.desc")
		pursuittech:SetValue(GetConVar("uvunitmanager_pursuittech"):GetInt())
		CPanel:AddItem(pursuittech)
		
		CPanel:AddControl("Label", {
			Text = "#tool.uvunitmanager.settings.ptech.spawnwith",
		})
		
		local pursuittech_esf = vgui.Create("DCheckBoxLabel")
		pursuittech_esf:SetText("#uv.ptech.esf")
		pursuittech_esf:SetConVar("uvunitmanager_pursuittech_esf")
		pursuittech_esf:SetTooltip("#tool.uvunitmanager.settings.ptech.spawnwith.desc")
		pursuittech_esf:SetValue(GetConVar("uvunitmanager_pursuittech_esf"):GetInt())
		CPanel:AddItem(pursuittech_esf)
		
		local pursuittech_spikes = vgui.Create("DCheckBoxLabel")
		pursuittech_spikes:SetText("#uv.ptech.spikes")
		pursuittech_spikes:SetConVar("uvunitmanager_pursuittech_spikestrip")
		pursuittech_spikes:SetTooltip("#tool.uvunitmanager.settings.ptech.spawnwith.desc")
		pursuittech_spikes:SetValue(GetConVar("uvunitmanager_pursuittech_spikestrip"):GetInt())
		CPanel:AddItem(pursuittech_spikes)
		
		local pursuittech_killswitch = vgui.Create("DCheckBoxLabel")
		pursuittech_killswitch:SetText("#uv.ptech.killswitch")
		pursuittech_killswitch:SetConVar("uvunitmanager_pursuittech_killswitch")
		pursuittech_killswitch:SetTooltip("#tool.uvunitmanager.settings.ptech.spawnwith.desc")
		pursuittech_killswitch:SetValue(GetConVar("uvunitmanager_pursuittech_killswitch"):GetInt())
		CPanel:AddItem(pursuittech_killswitch)
		
		local pursuittech_repairkit = vgui.Create("DCheckBoxLabel")
		pursuittech_repairkit:SetText("#uv.ptech.repairkit")
		pursuittech_repairkit:SetConVar("uvunitmanager_pursuittech_repairkit")
		pursuittech_repairkit:SetTooltip("#tool.uvunitmanager.settings.ptech.spawnwith.desc")
		pursuittech_repairkit:SetValue(GetConVar("uvunitmanager_pursuittech_repairkit"):GetInt())
		CPanel:AddItem(pursuittech_repairkit)
		
		CPanel:AddControl("Label", {
			Text = "#tool.uvunitmanager.settings.commander",
		})
		
		-- CPanel:AddControl("Label", {
		-- Text = "With One Commander enabled, the Commander will be made as a BOSS! There will be an endless horde of Units until the Commander is taken out!",
		-- })
		
		local onecommander = vgui.Create("DCheckBoxLabel")
		onecommander:SetText("#tool.uvunitmanager.settings.commander.solo")
		onecommander:SetConVar("uvunitmanager_onecommander")
		onecommander:SetTooltip("#tool.uvunitmanager.settings.commander.solo.desc")
		onecommander:SetValue(GetConVar("uvunitmanager_onecommander"):GetInt())
		CPanel:AddItem(onecommander)
		
		local onecommanderevade = vgui.Create("DCheckBoxLabel")
		onecommanderevade:SetText("#tool.uvunitmanager.settings.commander.evading")
		onecommanderevade:SetConVar("uvunitmanager_onecommanderevading")
		onecommanderevade:SetTooltip("#tool.uvunitmanager.settings.commander.evading.desc")
		onecommanderevade:SetValue(GetConVar("uvunitmanager_onecommanderevading"):GetInt())
		CPanel:AddItem(onecommanderevade)
				
		local commanderrepair = vgui.Create("DCheckBoxLabel")
		commanderrepair:SetText("#tool.uvunitmanager.settings.commander.norepair")
		commanderrepair:SetConVar("unitvehicle_unit_commanderrepair")
		commanderrepair:SetTooltip("#tool.uvunitmanager.settings.commander.norepair.desc")
		commanderrepair:SetValue(GetConVar("unitvehicle_unit_commanderrepair"):GetInt())
		CPanel:AddItem(commanderrepair)
		
		local onecommanderhealth = vgui.Create("DNumSlider")
		onecommanderhealth:SetText("#tool.uvunitmanager.settings.commander.health")
		onecommanderhealth:SetMinMax(1000, 10000)
		onecommanderhealth:SetDecimals(0)
		onecommanderhealth:SetValue(GetConVar("uvunitmanager_onecommanderhealth"))
		onecommanderhealth:SetConVar("uvunitmanager_onecommanderhealth")
		onecommanderhealth:SetTooltip("#tool.uvunitmanager.settings.commander.health")
		CPanel:AddItem(onecommanderhealth)
		
		CPanel:AddControl("Label", {
			Text = "#tool.uvunitmanager.settings.heli",
		})
		
		local helicoptermodel = vgui.Create("DNumSlider")
		helicoptermodel:SetText("#tool.uvunitmanager.settings.heli.model")
		helicoptermodel:SetTooltip("#tool.uvunitmanager.settings.heli.model.desc")
		helicoptermodel:SetMinMax(1, 5)
		helicoptermodel:SetDecimals(0)
		helicoptermodel:SetValue(GetConVar("uvunitmanager_helicoptermodel"))
		helicoptermodel:SetConVar("uvunitmanager_helicoptermodel")
		CPanel:AddItem(helicoptermodel)
		
		local helicopterbustracer = vgui.Create("DCheckBoxLabel")
		helicopterbustracer:SetText("#tool.uvunitmanager.settings.heli.canbust")
		helicopterbustracer:SetConVar("uvunitmanager_helicopterbusting")
		helicopterbustracer:SetTooltip("#tool.uvunitmanager.settings.heli.canbust.desc")
		helicopterbustracer:SetValue(GetConVar("uvunitmanager_helicopterbusting"):GetInt())
		CPanel:AddItem(helicopterbustracer)
		
		CPanel:AddControl("Label", {
			Text = "#tool.uvunitpursuittech.name",
		})
		
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
		
		-- CPanel:AddControl("Label", {
		-- Text = "——— SPAWNING ———\n\n- Spawn in a random assigned Unit to test out the Unit Vehicles!\n- Your Unit will be EQUIPPED with Pursuit Tech if its assigned to Pursuit, Interceptor, Special or Commander!",
		-- })
		
		-- local Respawn = vgui.Create( "DButton", CPanel )
		-- Respawn:SetText( "Spawn in a random assigned Unit" )
		-- Respawn:SetSize( 280, 20 )
		-- Respawn.DoClick = function( self )
		-- local redeploysound = {
		-- "ui/redeploy/redeploy1.wav",
		-- "ui/redeploy/redeploy2.wav",
		-- "ui/redeploy/redeploy3.wav",
		-- "ui/redeploy/redeploy4.wav",
		-- }
		-- surface.PlaySound( redeploysound[math.random(1, #redeploysound)] )
		-- net.Start("UVHUDRespawnInUV")
		-- net.SendToServer()
		-- end
		-- CPanel:AddItem(Respawn)
		
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
		
		CPanel:AddControl("Label", {
			Text = "#tool.uvunitmanager.settings.bounty.10s",
		})
		
		for i = 1, 6 do
			bountytime[i] = vgui.Create("DNumSlider")
			bountytime[i]:SetText( string.format( lang("uv.hud.heatlvl"), i ) )
			bountytime[i]:SetTooltip("#tool.uvunitmanager.settings.bounty.10s.desc")
			bountytime[i]:SetMinMax(0, 1000000)
			bountytime[i]:SetDecimals(0)
			bountytime[i]:SetValue(GetConVar("uvunitmanager_bountytime" .. i))
			bountytime[i]:SetConVar("uvunitmanager_bountytime" .. i)
			CPanel:AddItem(bountytime[i])
		end
		
		CPanel:AddControl("Label", {
			Text = "Timed Heat",
		})
		
		local TimeTillNextHeatEnabled = vgui.Create("DCheckBoxLabel")
		TimeTillNextHeatEnabled:SetText("#tool.uvunitmanager.settings.heatlvl.timed")
		TimeTillNextHeatEnabled:SetConVar("uvunitmanager_timetillnextheatenabled")
		TimeTillNextHeatEnabled:SetTooltip("#tool.uvunitmanager.settings.heatlvl.timed.desc")
		TimeTillNextHeatEnabled:SetValue(GetConVar("uvunitmanager_timetillnextheatenabled"):GetInt())
		CPanel:AddItem(TimeTillNextHeatEnabled)
		
		-- for i = 1, 5 do
		-- 	timetillnextheat[i] = vgui.Create("DNumSlider")
		-- 	timetillnextheat[i]:SetText( string.format( lang("uv.hud.heatlvl"), i .. " > " .. i+1 ) )
		-- 	timetillnextheat[i]:SetTooltip("#tool.uvunitmanager.settings.heatlvl.time")
		-- 	timetillnextheat[i]:SetMinMax(10, 600)
		-- 	timetillnextheat[i]:SetDecimals(0)
		-- 	timetillnextheat[i]:SetValue(GetConVar("uvunitmanager_timetillnextheat" .. i))
		-- 	timetillnextheat[i]:SetConVar("uvunitmanager_timetillnextheat" .. i)
		-- 	CPanel:AddItem(timetillnextheat[i])
		-- end
		
		local emptydefault = " "
		
		CPanel:AddControl("Label", {
			Text = "#tool.uvunitmanager.settings.assunits.title",
		})
		
		local cBox = CPanel:ComboBox("Selected Heat", "uvunitmanager_selected_heat")
		
		for i = 1, MAX_HEAT_LEVEL do
			cBox:AddChoice( i, i )
		end
		
		-- CPanel:AddControl("Label", {
		-- 	Text = "#uv.unit.patrol"
		-- })
		
		local selectedHeatConVar = GetConVar( 'uvunitmanager_selected_heat' )
		local selectedHeat = selectedHeatConVar:GetInt()
		
		for _, v in pairs( {'Patrol', 'Support', 'Pursuit', 'Interceptor', 'Special', 'Commander'} ) do
			local undercaseName = string.lower( v )
			local locString = "#uv.unit." .. undercaseName
			local unitKey = 'Units' .. v
			local unitConvarString = string.format( "uvunitmanager_units%s%s", undercaseName, selectedHeat )
			local heatChangeCallbackId = unitKey
			
			local unitConvar = GetConVar( unitConvarString )
			
			---------------------------------------
			
			local function _onChange( self )
				local text = self:GetText()
				local unitConvarString = string.format( "uvunitmanager_units%s%s", undercaseName, GetConVar( 'uvunitmanager_selected_heat' ):GetInt() )
				
				if ( text == "" ) then self:SetText( emptydefault ) end
				RunConsoleCommand( unitConvarString, text )
			end
			
			CPanel:AddControl("Label", {
				Text = locString
			})
			
			local textBox = vgui.Create( 'DTextEntry' )
			UIElements[unitKey] = textBox
			
			textBox:SetPlaceholderText( " " )
			textBox:SetText( unitConvar:GetString() )
			textBox:SetTooltip( "#tool.uvunitmanager.settings.heatlvl" .. selectedHeat .. ".desc" )
			textBox.OnLoseFocus = _onChange
			
			CPanel:AddItem( textBox )
			
			cvars.RemoveChangeCallback( "uvunitmanager_selected_heat", unitKey )
			cvars.AddChangeCallback( "uvunitmanager_selected_heat", function(_, o_v, n_v)
				textBox:SetText( GetConVar( string.format( "uvunitmanager_units%s%s", undercaseName, n_v ) ):GetString() )
				_onChange( textBox )
			end, unitKey )
		end
		
		-- Rhino is very lonely... : (
		-- Come on Roboboy...
		local locString = "#uv.unit.rhino"
		local unitConvarString = string.format( "uvunitmanager_rhinos%s", selectedHeat )
		local heatChangeCallbackId = 'UnitsRhinos'
		
		local unitConvar = GetConVar( unitConvarString )
		
		---------------------------------------
		
		local function _onChange( self )
			local text = self:GetText()
			local unitConvarString = string.format( "uvunitmanager_rhinos%s", GetConVar( 'uvunitmanager_selected_heat' ):GetInt() )
			
			if ( text == "" ) then self:SetText( emptydefault ) end
			RunConsoleCommand( unitConvarString, text )
		end
		
		CPanel:AddControl("Label", {
			Text = locString
		})
		
		local textBox = vgui.Create( 'DTextEntry' )
		UIElements[heatChangeCallbackId] = textBox
		
		textBox:SetPlaceholderText( " " )
		textBox:SetText( unitConvar:GetString() )
		textBox:SetTooltip( "#tool.uvunitmanager.settings.heatlvl" .. selectedHeat .. ".desc" )
		textBox.OnLoseFocus = _onChange
		
		CPanel:AddItem( textBox )
		
		cvars.RemoveChangeCallback( "uvunitmanager_selected_heat", heatChangeCallbackId )
		cvars.AddChangeCallback( "uvunitmanager_selected_heat", function(_, o_v, n_v)
			textBox:SetText( GetConVar( string.format( "uvunitmanager_rhinos%s", n_v ) ):GetString() )
			_onChange( textBox )
		end, heatChangeCallbackId )
		
		-- 	{
		-- 	Class = 'DNumSlider',
		-- 	MinMax = {1, 10000000},
		-- 	Decimals = 0,
		-- 	ConVar = 'uvunitmanager_heatminimumbounty',
		-- 	ToolText = '#tool.uvunitmanager.settings.heatlevel.minbounty'
		-- 	ToolTip = '#tool.uvunitmanager.settings.heatlevel.minbounty.desc'
		-- },
		
		for _, setting_name in pairs( HEAT_SETTINGS ) do
			local array = UnitSettings[setting_name]
			
			if array then
				local element = vgui.Create( array.Class )
				local settingKey = 'Setting' .. setting_name
				
				if array.MinMax then element:SetMinMax( array.MinMax[1], array.MinMax[2] ) end
				if array.Decimals then element:SetDecimals( array.Decimals ) end
				if array.ToolTip then element:SetTooltip( array.ToolTip ) end
				if array.ToolText then element:SetText( array.ToolText ) end
				
				if setting_name == 'timetillnextheat' then
					element:SetText( string.format( lang("uv.hud.heatlvl"), selectedHeat .. " > " .. selectedHeat + 1 ) )	
				end
				
				if array.ConVar then 
					element:SetValue( GetConVar( array.ConVar .. selectedHeat ) ) 
					element:SetConVar( array.ConVar )
					--element:SetValue( GetConVar( array.ConVar .. selectedHeat ) ) 
					
					cvars.RemoveChangeCallback( "uvunitmanager_selected_heat", settingKey )
					cvars.AddChangeCallback( "uvunitmanager_selected_heat", function(_, o_v, n_v)
						local conVarString = array.ConVar .. n_v
						local conVar = GetConVar( conVarString )
						
						if setting_name == 'timetillnextheat' then
							element:SetText( string.format( lang("uv.hud.heatlvl"), n_v .. " > " .. n_v + 1 ) )	
						end
						
						element:SetConVar( conVarString )
					end, settingKey )
				end
				
				CPanel:AddItem( element )
			end
		end
		
		-- UIElements['SettingsMinBounty'] = 
		
		-- heatminimumbounty[i] = vgui.Create("DNumSlider")
		-- heatminimumbounty[i]:SetText("#tool.uvunitmanager.settings.heatlevel.minbounty")
		-- heatminimumbounty[i]:SetMinMax(1, 10000000)
		-- heatminimumbounty[i]:SetDecimals(0)
		-- heatminimumbounty[i]:SetValue(GetConVar("uvunitmanager_heatminimumbounty" .. i))
		-- heatminimumbounty[i]:SetConVar("uvunitmanager_heatminimumbounty" .. i)
		-- heatminimumbounty[i]:SetTooltip("#tool.uvunitmanager.settings.heatlevel.minbounty.desc")
		-- CPanel:AddItem(heatminimumbounty[i])
		
		-- maxunits[i] = vgui.Create("DNumSlider")
		-- maxunits[i]:SetText("#tool.uvunitmanager.settings.heatlevel.maxunits")
		-- maxunits[i]:SetMinMax(1, 20)
		-- maxunits[i]:SetDecimals(0)
		-- maxunits[i]:SetValue(GetConVar("uvunitmanager_maxunits" .. i))
		-- maxunits[i]:SetConVar("uvunitmanager_maxunits" .. i)
		-- maxunits[i]:SetTooltip("#tool.uvunitmanager.settings.heatlevel.maxunits.desc")
		-- CPanel:AddItem(maxunits[i])
		
		-- unitsavailable[i] = vgui.Create("DNumSlider")
		-- unitsavailable[i]:SetText("#tool.uvunitmanager.settings.heatlevel.avaunits")
		-- unitsavailable[i]:SetMinMax(1, 100)
		-- unitsavailable[i]:SetDecimals(0)
		-- unitsavailable[i]:SetValue(GetConVar("uvunitmanager_unitsavailable" .. i))
		-- unitsavailable[i]:SetConVar("uvunitmanager_unitsavailable" .. i)
		-- unitsavailable[i]:SetTooltip("#tool.uvunitmanager.settings.heatlevel.avaunits.desc")
		-- CPanel:AddItem(unitsavailable[i])
		
		-- backuptimer[i] = vgui.Create("DNumSlider")
		-- backuptimer[i]:SetText("#tool.uvunitmanager.settings.heatlevel.backuptime")
		-- backuptimer[i]:SetMinMax(10, 1000)
		-- backuptimer[i]:SetDecimals(0)
		-- backuptimer[i]:SetValue(GetConVar("uvunitmanager_backuptimer" .. i))
		-- backuptimer[i]:SetConVar("uvunitmanager_backuptimer" .. i)
		-- backuptimer[i]:SetTooltip("#tool.uvunitmanager.settings.heatlevel.backuptime.desc")
		-- CPanel:AddItem(backuptimer[i])
		
		-- cooldowntimer[i] = vgui.Create("DNumSlider")
		-- cooldowntimer[i]:SetText("#tool.uvunitmanager.settings.heatlevel.cooldowntime")
		-- cooldowntimer[i]:SetMinMax(0, 1000)
		-- cooldowntimer[i]:SetDecimals(0)
		-- cooldowntimer[i]:SetValue(GetConVar("uvunitmanager_cooldowntimer" .. i))
		-- cooldowntimer[i]:SetConVar("uvunitmanager_cooldowntimer" .. i)
		-- cooldowntimer[i]:SetTooltip("#tool.uvunitmanager.settings.heatlevel.cooldowntime.desc")
		-- CPanel:AddItem(cooldowntimer[i])
		
		-- roadblocks[i] = vgui.Create("DCheckBoxLabel")
		-- roadblocks[i]:SetText("#tool.uvunitmanager.settings.heatlevel.roadblocks")
		-- roadblocks[i]:SetConVar("uvunitmanager_roadblocks" .. i)
		-- roadblocks[i]:SetTooltip("#tool.uvunitmanager.settings.heatlevel.roadblocks.desc")
		-- roadblocks[i]:SetValue(GetConVar("uvunitmanager_roadblocks" .. i):GetInt())
		-- CPanel:AddItem(roadblocks[i])
		
		-- helicopters[i] = vgui.Create("DCheckBoxLabel")
		-- helicopters[i]:SetText("#tool.uvunitmanager.settings.heatlevel.helicopter")
		-- helicopters[i]:SetConVar("uvunitmanager_helicopters" .. i)
		-- helicopters[i]:SetTooltip("#tool.uvunitmanager.settings.heatlevel.helicopter.desc")
		-- helicopters[i]:SetValue(GetConVar("uvunitmanager_helicopters" .. i):GetInt())
		-- CPanel:AddItem(helicopters[i])
		
		-- patrolUnit:SetPlaceholderText( " " )
		-- patrolUnit:SetText( GetConVar( "uvunitmanager_unitspatrol" .. selectedHeat ) )
		-- patrolUnit:SetTooltip( "#tool.uvunitmanager.settings.heatlvl" .. selectedHeat .. ".desc" )
		-- patrolUnit.OnLoseFocus = function( self )
		-- 	if ( self:GetText() == "" ) then
		-- 		self:SetText( emptydefault )
		-- 	end
		
		-- 	RunConsoleCommand( "uvunitmanager" )
		-- end
		
		-- heatlevel[i] = CPanel:AddControl("Label", {
		-- 		Text = string.format( lang("tool.uvunitmanager.settings.heatlvl.title"), i ),
		-- 	})
		-- for i=1, 1 do
		-- 	CPanel:AddControl("Label", {
		-- 		Text = "#uv.unit.patrol",
		-- 	})
		
		-- 	unitspatrol[i] = vgui.Create( "DTextEntry" )
		-- 	unitspatrol[i]:SetPlaceholderText( " " )
		-- 	unitspatrol[i]:SetText(GetConVar("uvunitmanager_unitspatrol" .. i):GetString())
		-- 	unitspatrol[i]:SetConVar("uvunitmanager_unitspatrol" .. i)
		-- 	unitspatrol[i]:SetTooltip("#tool.uvunitmanager.settings.heatlvl1.desc")
		-- 	unitspatrol[i].OnLoseFocus = function( self )
		-- 		if ( self:GetText() == "" ) then
		-- 			self:SetText( emptydefault )
		-- 		end
		-- 		RunConsoleCommand("uvunitmanager_unitspatrol" .. i, self:GetText())
		-- 	end
		-- 	unitspatrol[i].OnEnter = function( self )
		-- 		if ( self:GetText() == "" ) then
		-- 			self:SetText( emptydefault )
		-- 		end
		-- 		RunConsoleCommand("uvunitmanager_unitspatrol" .. i, self:GetText())
		-- 	end
		-- 	CPanel:AddItem(unitspatrol[i])
		
		-- 	CPanel:AddControl("Label", {
		-- 		Text = "#uv.unit.support",
		-- 	})
		
		-- 	unitssupport[i] = vgui.Create( "DTextEntry" )
		-- 	unitssupport[i]:SetPlaceholderText( " " )
		-- 	unitssupport[i]:SetText(GetConVar("uvunitmanager_unitssupport" .. i):GetString())
		-- 	unitssupport[i]:SetConVar("uvunitmanager_unitssupport" .. i)
		-- 	unitssupport[i]:SetTooltip("#tool.uvunitmanager.settings.heatlvl2.desc")
		-- 	unitssupport[i].OnLoseFocus = function( self )
		-- 		if ( self:GetText() == "" ) then
		-- 			self:SetText( emptydefault )
		-- 		end
		-- 		RunConsoleCommand("uvunitmanager_unitssupport" .. i, self:GetText())
		-- 	end
		-- 	unitssupport[i].OnEnter = function( self )
		-- 		if ( self:GetText() == "" ) then
		-- 			self:SetText( emptydefault )
		-- 		end
		-- 		RunConsoleCommand("uvunitmanager_unitssupport" .. i, self:GetText())
		-- 	end
		-- 	CPanel:AddItem(unitssupport[i])
		
		-- 	CPanel:AddControl("Label", {
		-- 		Text = "#uv.unit.pursuit",
		-- 	})
		
		-- 	unitspursuit[i] = vgui.Create( "DTextEntry" )
		-- 	unitspursuit[i]:SetPlaceholderText( " " )
		-- 	unitspursuit[i]:SetText(GetConVar("uvunitmanager_unitspursuit" .. i):GetString())
		-- 	unitspursuit[i]:SetConVar("uvunitmanager_unitspursuit" .. i)
		-- 	unitspursuit[i]:SetTooltip("#tool.uvunitmanager.settings.heatlvl3.desc")
		-- 	unitspursuit[i].OnLoseFocus = function( self )
		-- 		if ( self:GetText() == "" ) then
		-- 			self:SetText( emptydefault )
		-- 		end
		-- 		RunConsoleCommand("uvunitmanager_unitspursuit" .. i, self:GetText())
		-- 	end
		-- 	unitspursuit[i].OnEnter = function( self )
		-- 		if ( self:GetText() == "" ) then
		-- 			self:SetText( emptydefault )
		-- 		end
		-- 		RunConsoleCommand("uvunitmanager_unitspursuit" .. i, self:GetText())
		-- 	end
		-- 	CPanel:AddItem(unitspursuit[i])
		
		-- 	CPanel:AddControl("Label", {
		-- 		Text = "#uv.unit.interceptor",
		-- 	})
		
		-- 	unitsinterceptor[i] = vgui.Create( "DTextEntry" )
		-- 	unitsinterceptor[i]:SetPlaceholderText( " " )
		-- 	unitsinterceptor[i]:SetText(GetConVar("uvunitmanager_unitsinterceptor" .. i):GetString())
		-- 	unitsinterceptor[i]:SetConVar("uvunitmanager_unitsinterceptor" .. i)
		-- 	unitsinterceptor[i]:SetTooltip("#tool.uvunitmanager.settings.heatlvl4.desc")
		-- 	unitsinterceptor[i].OnLoseFocus = function( self )
		-- 		if ( self:GetText() == "" ) then
		-- 			self:SetText( emptydefault )
		-- 		end
		-- 		RunConsoleCommand("uvunitmanager_unitsinterceptor" .. i, self:GetText())
		-- 	end
		-- 	unitsinterceptor[i].OnEnter = function( self )
		-- 		if ( self:GetText() == "" ) then
		-- 			self:SetText( emptydefault )
		-- 		end
		-- 		RunConsoleCommand("uvunitmanager_unitsinterceptor" .. i, self:GetText())
		-- 	end
		-- 	CPanel:AddItem(unitsinterceptor[i])
		
		-- 	CPanel:AddControl("Label", {
		-- 		Text = "#uv.unit.special",
		-- 	})
		
		-- 	unitsspecial[i] = vgui.Create( "DTextEntry" )
		-- 	unitsspecial[i]:SetPlaceholderText( " " )
		-- 	unitsspecial[i]:SetText(GetConVar("uvunitmanager_unitsspecial" .. i):GetString())
		-- 	unitsspecial[i]:SetConVar("uvunitmanager_unitsspecial" .. i)
		-- 	unitsspecial[i]:SetTooltip("#tool.uvunitmanager.settings.heatlvl5.desc")
		-- 	unitsspecial[i].OnLoseFocus = function( self )
		-- 		if ( self:GetText() == "" ) then
		-- 			self:SetText( emptydefault )
		-- 		end
		-- 		RunConsoleCommand("uvunitmanager_unitsspecial" .. i, self:GetText())
		-- 	end
		-- 	unitsspecial[i].OnEnter = function( self )
		-- 		if ( self:GetText() == "" ) then
		-- 			self:SetText( emptydefault )
		-- 		end
		-- 		RunConsoleCommand("uvunitmanager_unitsspecial" .. i, self:GetText())
		-- 	end
		-- 	CPanel:AddItem(unitsspecial[i])
		
		-- 	CPanel:AddControl("Label", {
		-- 		Text = "#uv.unit.commander",
		-- 	})
		
		-- 	unitscommander[i] = vgui.Create( "DTextEntry" )
		-- 	unitscommander[i]:SetPlaceholderText( " " )
		-- 	unitscommander[i]:SetText(GetConVar("uvunitmanager_unitscommander" .. i):GetString())
		-- 	unitscommander[i]:SetConVar("uvunitmanager_unitscommander" .. i)
		-- 	unitscommander[i]:SetTooltip("#tool.uvunitmanager.settings.heatlvl6.desc")
		-- 	unitscommander[i].OnLoseFocus = function( self )
		-- 		if ( self:GetText() == "" ) then
		-- 			self:SetText( emptydefault )
		-- 		end
		-- 		RunConsoleCommand("uvunitmanager_unitscommander" .. i, self:GetText())
		-- 	end
		-- 	unitscommander[i].OnEnter = function( self )
		-- 		if ( self:GetText() == "" ) then
		-- 			self:SetText( emptydefault )
		-- 		end
		-- 		RunConsoleCommand("uvunitmanager_unitscommander" .. i, self:GetText())
		-- 	end
		-- 	CPanel:AddItem(unitscommander[i])
		
		-- 	CPanel:AddControl("Label", {
		-- 		Text = "#uv.unit.rhino",
		-- 	})
		
		-- 	rhinos[i] = vgui.Create( "DTextEntry" )
		-- 	rhinos[i]:SetPlaceholderText( " " )
		-- 	rhinos[i]:SetText(GetConVar("uvunitmanager_rhinos" .. i):GetString())
		-- 	rhinos[i]:SetConVar("uvunitmanager_rhinos" .. i)
		-- 	rhinos[i]:SetTooltip("#tool.uvunitmanager.settings.heatlvl5.desc")
		-- 	rhinos[i].OnLoseFocus = function( self )
		-- 		if ( self:GetText() == "" ) then
		-- 			self:SetText( emptydefault )
		-- 		end
		-- 		RunConsoleCommand("uvunitmanager_rhinos" .. i, self:GetText())
		-- 	end
		-- 	rhinos[i].OnEnter = function( self )
		-- 		if ( self:GetText() == "" ) then
		-- 			self:SetText( emptydefault )
		-- 		end
		-- 		RunConsoleCommand("uvunitmanager_rhinos" .. i, self:GetText())
		-- 	end
		-- 	CPanel:AddItem(rhinos[i])
		
		-- 	heatminimumbounty[i] = vgui.Create("DNumSlider")
		-- 	heatminimumbounty[i]:SetText("#tool.uvunitmanager.settings.heatlevel.minbounty")
		-- 	heatminimumbounty[i]:SetMinMax(1, 10000000)
		-- 	heatminimumbounty[i]:SetDecimals(0)
		-- 	heatminimumbounty[i]:SetValue(GetConVar("uvunitmanager_heatminimumbounty" .. i))
		-- 	heatminimumbounty[i]:SetConVar("uvunitmanager_heatminimumbounty" .. i)
		-- 	heatminimumbounty[i]:SetTooltip("#tool.uvunitmanager.settings.heatlevel.minbounty.desc")
		-- 	CPanel:AddItem(heatminimumbounty[i])
		
		-- 	maxunits[i] = vgui.Create("DNumSlider")
		-- 	maxunits[i]:SetText("#tool.uvunitmanager.settings.heatlevel.maxunits")
		-- 	maxunits[i]:SetMinMax(1, 20)
		-- 	maxunits[i]:SetDecimals(0)
		-- 	maxunits[i]:SetValue(GetConVar("uvunitmanager_maxunits" .. i))
		-- 	maxunits[i]:SetConVar("uvunitmanager_maxunits" .. i)
		-- 	maxunits[i]:SetTooltip("#tool.uvunitmanager.settings.heatlevel.maxunits.desc")
		-- 	CPanel:AddItem(maxunits[i])
		
		-- 	unitsavailable[i] = vgui.Create("DNumSlider")
		-- 	unitsavailable[i]:SetText("#tool.uvunitmanager.settings.heatlevel.avaunits")
		-- 	unitsavailable[i]:SetMinMax(1, 100)
		-- 	unitsavailable[i]:SetDecimals(0)
		-- 	unitsavailable[i]:SetValue(GetConVar("uvunitmanager_unitsavailable" .. i))
		-- 	unitsavailable[i]:SetConVar("uvunitmanager_unitsavailable" .. i)
		-- 	unitsavailable[i]:SetTooltip("#tool.uvunitmanager.settings.heatlevel.avaunits.desc")
		-- 	CPanel:AddItem(unitsavailable[i])
		
		-- 	backuptimer[i] = vgui.Create("DNumSlider")
		-- 	backuptimer[i]:SetText("#tool.uvunitmanager.settings.heatlevel.backuptime")
		-- 	backuptimer[i]:SetMinMax(10, 1000)
		-- 	backuptimer[i]:SetDecimals(0)
		-- 	backuptimer[i]:SetValue(GetConVar("uvunitmanager_backuptimer" .. i))
		-- 	backuptimer[i]:SetConVar("uvunitmanager_backuptimer" .. i)
		-- 	backuptimer[i]:SetTooltip("#tool.uvunitmanager.settings.heatlevel.backuptime.desc")
		-- 	CPanel:AddItem(backuptimer[i])
		
		-- 	cooldowntimer[i] = vgui.Create("DNumSlider")
		-- 	cooldowntimer[i]:SetText("#tool.uvunitmanager.settings.heatlevel.cooldowntime")
		-- 	cooldowntimer[i]:SetMinMax(0, 1000)
		-- 	cooldowntimer[i]:SetDecimals(0)
		-- 	cooldowntimer[i]:SetValue(GetConVar("uvunitmanager_cooldowntimer" .. i))
		-- 	cooldowntimer[i]:SetConVar("uvunitmanager_cooldowntimer" .. i)
		-- 	cooldowntimer[i]:SetTooltip("#tool.uvunitmanager.settings.heatlevel.cooldowntime.desc")
		-- 	CPanel:AddItem(cooldowntimer[i])
		
		-- 	roadblocks[i] = vgui.Create("DCheckBoxLabel")
		-- 	roadblocks[i]:SetText("#tool.uvunitmanager.settings.heatlevel.roadblocks")
		-- 	roadblocks[i]:SetConVar("uvunitmanager_roadblocks" .. i)
		-- 	roadblocks[i]:SetTooltip("#tool.uvunitmanager.settings.heatlevel.roadblocks.desc")
		-- 	roadblocks[i]:SetValue(GetConVar("uvunitmanager_roadblocks" .. i):GetInt())
		-- 	CPanel:AddItem(roadblocks[i])
		
		-- 	helicopters[i] = vgui.Create("DCheckBoxLabel")
		-- 	helicopters[i]:SetText("#tool.uvunitmanager.settings.heatlevel.helicopter")
		-- 	helicopters[i]:SetConVar("uvunitmanager_helicopters" .. i)
		-- 	helicopters[i]:SetTooltip("#tool.uvunitmanager.settings.heatlevel.helicopter.desc")
		-- 	helicopters[i]:SetValue(GetConVar("uvunitmanager_helicopters" .. i):GetInt())
		-- 	CPanel:AddItem(helicopters[i])
		-- end
		
		
		
		-- for i = 1, 6 do
		
		-- 	heatlevel[i] = CPanel:AddControl("Label", {
		-- 		Text = string.format( lang("tool.uvunitmanager.settings.heatlvl.title"), i ),
		-- 	})
		
		-- 	CPanel:AddControl("Label", {
		-- 		Text = "#uv.unit.patrol",
		-- 	})
		
		-- 	unitspatrol[i] = vgui.Create( "DTextEntry" )
		-- 	unitspatrol[i]:SetPlaceholderText( " " )
		-- 	unitspatrol[i]:SetText(GetConVar("uvunitmanager_unitspatrol" .. i):GetString())
		-- 	unitspatrol[i]:SetConVar("uvunitmanager_unitspatrol" .. i)
		-- 	unitspatrol[i]:SetTooltip("#tool.uvunitmanager.settings.heatlvl1.desc")
		-- 	unitspatrol[i].OnLoseFocus = function( self )
		-- 		if ( self:GetText() == "" ) then
		-- 			self:SetText( emptydefault )
		-- 		end
		-- 		RunConsoleCommand("uvunitmanager_unitspatrol" .. i, self:GetText())
		-- 	end
		-- 	unitspatrol[i].OnEnter = function( self )
		-- 		if ( self:GetText() == "" ) then
		-- 			self:SetText( emptydefault )
		-- 		end
		-- 		RunConsoleCommand("uvunitmanager_unitspatrol" .. i, self:GetText())
		-- 	end
		-- 	CPanel:AddItem(unitspatrol[i])
		
		-- 	CPanel:AddControl("Label", {
		-- 		Text = "#uv.unit.support",
		-- 	})
		
		-- 	unitssupport[i] = vgui.Create( "DTextEntry" )
		-- 	unitssupport[i]:SetPlaceholderText( " " )
		-- 	unitssupport[i]:SetText(GetConVar("uvunitmanager_unitssupport" .. i):GetString())
		-- 	unitssupport[i]:SetConVar("uvunitmanager_unitssupport" .. i)
		-- 	unitssupport[i]:SetTooltip("#tool.uvunitmanager.settings.heatlvl2.desc")
		-- 	unitssupport[i].OnLoseFocus = function( self )
		-- 		if ( self:GetText() == "" ) then
		-- 			self:SetText( emptydefault )
		-- 		end
		-- 		RunConsoleCommand("uvunitmanager_unitssupport" .. i, self:GetText())
		-- 	end
		-- 	unitssupport[i].OnEnter = function( self )
		-- 		if ( self:GetText() == "" ) then
		-- 			self:SetText( emptydefault )
		-- 		end
		-- 		RunConsoleCommand("uvunitmanager_unitssupport" .. i, self:GetText())
		-- 	end
		-- 	CPanel:AddItem(unitssupport[i])
		
		-- 	CPanel:AddControl("Label", {
		-- 		Text = "#uv.unit.pursuit",
		-- 	})
		
		-- 	unitspursuit[i] = vgui.Create( "DTextEntry" )
		-- 	unitspursuit[i]:SetPlaceholderText( " " )
		-- 	unitspursuit[i]:SetText(GetConVar("uvunitmanager_unitspursuit" .. i):GetString())
		-- 	unitspursuit[i]:SetConVar("uvunitmanager_unitspursuit" .. i)
		-- 	unitspursuit[i]:SetTooltip("#tool.uvunitmanager.settings.heatlvl3.desc")
		-- 	unitspursuit[i].OnLoseFocus = function( self )
		-- 		if ( self:GetText() == "" ) then
		-- 			self:SetText( emptydefault )
		-- 		end
		-- 		RunConsoleCommand("uvunitmanager_unitspursuit" .. i, self:GetText())
		-- 	end
		-- 	unitspursuit[i].OnEnter = function( self )
		-- 		if ( self:GetText() == "" ) then
		-- 			self:SetText( emptydefault )
		-- 		end
		-- 		RunConsoleCommand("uvunitmanager_unitspursuit" .. i, self:GetText())
		-- 	end
		-- 	CPanel:AddItem(unitspursuit[i])
		
		-- 	CPanel:AddControl("Label", {
		-- 		Text = "#uv.unit.interceptor",
		-- 	})
		
		-- 	unitsinterceptor[i] = vgui.Create( "DTextEntry" )
		-- 	unitsinterceptor[i]:SetPlaceholderText( " " )
		-- 	unitsinterceptor[i]:SetText(GetConVar("uvunitmanager_unitsinterceptor" .. i):GetString())
		-- 	unitsinterceptor[i]:SetConVar("uvunitmanager_unitsinterceptor" .. i)
		-- 	unitsinterceptor[i]:SetTooltip("#tool.uvunitmanager.settings.heatlvl4.desc")
		-- 	unitsinterceptor[i].OnLoseFocus = function( self )
		-- 		if ( self:GetText() == "" ) then
		-- 			self:SetText( emptydefault )
		-- 		end
		-- 		RunConsoleCommand("uvunitmanager_unitsinterceptor" .. i, self:GetText())
		-- 	end
		-- 	unitsinterceptor[i].OnEnter = function( self )
		-- 		if ( self:GetText() == "" ) then
		-- 			self:SetText( emptydefault )
		-- 		end
		-- 		RunConsoleCommand("uvunitmanager_unitsinterceptor" .. i, self:GetText())
		-- 	end
		-- 	CPanel:AddItem(unitsinterceptor[i])
		
		-- 	CPanel:AddControl("Label", {
		-- 		Text = "#uv.unit.special",
		-- 	})
		
		-- 	unitsspecial[i] = vgui.Create( "DTextEntry" )
		-- 	unitsspecial[i]:SetPlaceholderText( " " )
		-- 	unitsspecial[i]:SetText(GetConVar("uvunitmanager_unitsspecial" .. i):GetString())
		-- 	unitsspecial[i]:SetConVar("uvunitmanager_unitsspecial" .. i)
		-- 	unitsspecial[i]:SetTooltip("#tool.uvunitmanager.settings.heatlvl5.desc")
		-- 	unitsspecial[i].OnLoseFocus = function( self )
		-- 		if ( self:GetText() == "" ) then
		-- 			self:SetText( emptydefault )
		-- 		end
		-- 		RunConsoleCommand("uvunitmanager_unitsspecial" .. i, self:GetText())
		-- 	end
		-- 	unitsspecial[i].OnEnter = function( self )
		-- 		if ( self:GetText() == "" ) then
		-- 			self:SetText( emptydefault )
		-- 		end
		-- 		RunConsoleCommand("uvunitmanager_unitsspecial" .. i, self:GetText())
		-- 	end
		-- 	CPanel:AddItem(unitsspecial[i])
		
		-- 	CPanel:AddControl("Label", {
		-- 		Text = "#uv.unit.commander",
		-- 	})
		
		-- 	unitscommander[i] = vgui.Create( "DTextEntry" )
		-- 	unitscommander[i]:SetPlaceholderText( " " )
		-- 	unitscommander[i]:SetText(GetConVar("uvunitmanager_unitscommander" .. i):GetString())
		-- 	unitscommander[i]:SetConVar("uvunitmanager_unitscommander" .. i)
		-- 	unitscommander[i]:SetTooltip("#tool.uvunitmanager.settings.heatlvl6.desc")
		-- 	unitscommander[i].OnLoseFocus = function( self )
		-- 		if ( self:GetText() == "" ) then
		-- 			self:SetText( emptydefault )
		-- 		end
		-- 		RunConsoleCommand("uvunitmanager_unitscommander" .. i, self:GetText())
		-- 	end
		-- 	unitscommander[i].OnEnter = function( self )
		-- 		if ( self:GetText() == "" ) then
		-- 			self:SetText( emptydefault )
		-- 		end
		-- 		RunConsoleCommand("uvunitmanager_unitscommander" .. i, self:GetText())
		-- 	end
		-- 	CPanel:AddItem(unitscommander[i])
		
		-- 	CPanel:AddControl("Label", {
		-- 		Text = "#uv.unit.rhino",
		-- 	})
		
		-- 	rhinos[i] = vgui.Create( "DTextEntry" )
		-- 	rhinos[i]:SetPlaceholderText( " " )
		-- 	rhinos[i]:SetText(GetConVar("uvunitmanager_rhinos" .. i):GetString())
		-- 	rhinos[i]:SetConVar("uvunitmanager_rhinos" .. i)
		-- 	rhinos[i]:SetTooltip("#tool.uvunitmanager.settings.heatlvl5.desc")
		-- 	rhinos[i].OnLoseFocus = function( self )
		-- 		if ( self:GetText() == "" ) then
		-- 			self:SetText( emptydefault )
		-- 		end
		-- 		RunConsoleCommand("uvunitmanager_rhinos" .. i, self:GetText())
		-- 	end
		-- 	rhinos[i].OnEnter = function( self )
		-- 		if ( self:GetText() == "" ) then
		-- 			self:SetText( emptydefault )
		-- 		end
		-- 		RunConsoleCommand("uvunitmanager_rhinos" .. i, self:GetText())
		-- 	end
		-- 	CPanel:AddItem(rhinos[i])
		
		-- 	heatminimumbounty[i] = vgui.Create("DNumSlider")
		-- 	heatminimumbounty[i]:SetText("#tool.uvunitmanager.settings.heatlevel.minbounty")
		-- 	heatminimumbounty[i]:SetMinMax(1, 10000000)
		-- 	heatminimumbounty[i]:SetDecimals(0)
		-- 	heatminimumbounty[i]:SetValue(GetConVar("uvunitmanager_heatminimumbounty" .. i))
		-- 	heatminimumbounty[i]:SetConVar("uvunitmanager_heatminimumbounty" .. i)
		-- 	heatminimumbounty[i]:SetTooltip("#tool.uvunitmanager.settings.heatlevel.minbounty.desc")
		-- 	CPanel:AddItem(heatminimumbounty[i])
		
		-- 	maxunits[i] = vgui.Create("DNumSlider")
		-- 	maxunits[i]:SetText("#tool.uvunitmanager.settings.heatlevel.maxunits")
		-- 	maxunits[i]:SetMinMax(1, 20)
		-- 	maxunits[i]:SetDecimals(0)
		-- 	maxunits[i]:SetValue(GetConVar("uvunitmanager_maxunits" .. i))
		-- 	maxunits[i]:SetConVar("uvunitmanager_maxunits" .. i)
		-- 	maxunits[i]:SetTooltip("#tool.uvunitmanager.settings.heatlevel.maxunits.desc")
		-- 	CPanel:AddItem(maxunits[i])
		
		-- 	unitsavailable[i] = vgui.Create("DNumSlider")
		-- 	unitsavailable[i]:SetText("#tool.uvunitmanager.settings.heatlevel.avaunits")
		-- 	unitsavailable[i]:SetMinMax(1, 100)
		-- 	unitsavailable[i]:SetDecimals(0)
		-- 	unitsavailable[i]:SetValue(GetConVar("uvunitmanager_unitsavailable" .. i))
		-- 	unitsavailable[i]:SetConVar("uvunitmanager_unitsavailable" .. i)
		-- 	unitsavailable[i]:SetTooltip("#tool.uvunitmanager.settings.heatlevel.avaunits.desc")
		-- 	CPanel:AddItem(unitsavailable[i])
		
		-- 	backuptimer[i] = vgui.Create("DNumSlider")
		-- 	backuptimer[i]:SetText("#tool.uvunitmanager.settings.heatlevel.backuptime")
		-- 	backuptimer[i]:SetMinMax(10, 1000)
		-- 	backuptimer[i]:SetDecimals(0)
		-- 	backuptimer[i]:SetValue(GetConVar("uvunitmanager_backuptimer" .. i))
		-- 	backuptimer[i]:SetConVar("uvunitmanager_backuptimer" .. i)
		-- 	backuptimer[i]:SetTooltip("#tool.uvunitmanager.settings.heatlevel.backuptime.desc")
		-- 	CPanel:AddItem(backuptimer[i])
		
		-- 	cooldowntimer[i] = vgui.Create("DNumSlider")
		-- 	cooldowntimer[i]:SetText("#tool.uvunitmanager.settings.heatlevel.cooldowntime")
		-- 	cooldowntimer[i]:SetMinMax(0, 1000)
		-- 	cooldowntimer[i]:SetDecimals(0)
		-- 	cooldowntimer[i]:SetValue(GetConVar("uvunitmanager_cooldowntimer" .. i))
		-- 	cooldowntimer[i]:SetConVar("uvunitmanager_cooldowntimer" .. i)
		-- 	cooldowntimer[i]:SetTooltip("#tool.uvunitmanager.settings.heatlevel.cooldowntime.desc")
		-- 	CPanel:AddItem(cooldowntimer[i])
		
		-- 	roadblocks[i] = vgui.Create("DCheckBoxLabel")
		-- 	roadblocks[i]:SetText("#tool.uvunitmanager.settings.heatlevel.roadblocks")
		-- 	roadblocks[i]:SetConVar("uvunitmanager_roadblocks" .. i)
		-- 	roadblocks[i]:SetTooltip("#tool.uvunitmanager.settings.heatlevel.roadblocks.desc")
		-- 	roadblocks[i]:SetValue(GetConVar("uvunitmanager_roadblocks" .. i):GetInt())
		-- 	CPanel:AddItem(roadblocks[i])
		
		-- 	helicopters[i] = vgui.Create("DCheckBoxLabel")
		-- 	helicopters[i]:SetText("#tool.uvunitmanager.settings.heatlevel.helicopter")
		-- 	helicopters[i]:SetConVar("uvunitmanager_helicopters" .. i)
		-- 	helicopters[i]:SetTooltip("#tool.uvunitmanager.settings.heatlevel.helicopter.desc")
		-- 	helicopters[i]:SetValue(GetConVar("uvunitmanager_helicopters" .. i):GetInt())
		-- 	CPanel:AddItem(helicopters[i])
		
		-- end
		
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
		local Ent = Ents[next(Ents)]
		
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
		ply.UVTOOLMemory.Entities[next(ply.UVTOOLMemory.Entities)].PhysicsObjects[0].Angle = Angle(0,180,0)

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
	
	net.Start("UVUnitManagerGetUnitInfo")
	net.WriteTable( ply.UVTOOLMemory )
	net.Send( ply )
	
end
