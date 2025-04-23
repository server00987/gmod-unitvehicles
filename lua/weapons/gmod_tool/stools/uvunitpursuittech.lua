TOOL.Category		=	"Unit Vehicles"
TOOL.Name			=	"#Unit Pursuit Tech"
TOOL.Command		=	nil
TOOL.ConfigName		=	""

local pttable = {
	"ESF",
	"Spikestrip",
	"Killswitch",
}

local slots = 2

TOOL.ClientConVar[ "pursuittech" ] = pttable[1]
TOOL.ClientConVar[ "slot" ] = 1

TOOL.ClientConVar["ptduration"] = 20

TOOL.ClientConVar["esfduration"] = 10
TOOL.ClientConVar["esfpower"] = 2000000
TOOL.ClientConVar["spikestripduration"] = 60
TOOL.ClientConVar["killswitchlockontime"] = 3
TOOL.ClientConVar["killswitchdisableduration"] = 2.5

local conVarsDefault = TOOL:BuildConVarList()

if CLIENT then

	TOOL.Information = {
		{ name = "info"},
		{ name = "left" },
		{ name = "right" },
	}

	language.Add("tool.uvunitpursuittech.name", "Unit Pursuit Tech")
	language.Add("tool.uvunitpursuittech.desc", "Apply Pursuit Tech to your Unit vehicles! Use it to fight against street racers!")
	language.Add("tool.uvunitpursuittech.0", "Looking for more options? Find it under the options tab" )
	language.Add("tool.uvunitpursuittech.left", "Apply the Pursuit Tech to the your Unit vehicle. Don't have a Unit vehicle? Create one using the Unit Manager!" )
	language.Add("tool.uvunitpursuittech.right", "Change Pursuit Tech" )

end

function TOOL:LeftClick( trace )

	local car = trace.Entity

	if car.UnitVehicle and (car.IsGlideVehicle or car.IsSimfphyscar or car:GetClass() == "prop_vehicle_jeep") then

		if ( !CLIENT ) then
			local ptselected = self:GetClientInfo("pursuittech")
			local slot = self:GetClientNumber("slot") or 1
			
			if !car.PursuitTech then
				car.PursuitTech = {}
			end

			local sel_k, sel_v

			for k,v in pairs(car.PursuitTech) do
				if v.Tech == ptselected then
					sel_k, sel_v = k, v
					break
				end
			end

			self:GetOwner():ChatPrint(
				sel_v
				and "Replacing "..sel_v.Tech.." with " ..ptselected.." (Slot "..slot..")"
				or "Placing "..ptselected.." on "..UVGetVehicleMakeAndModel(car).." (Slot "..slot..")"
			)

			car.PursuitTech[slot] = {
				Tech = ptselected,
				Ammo = GetConVar("unitvehicle_unitpursuittech_maxammo_"..string.lower(ptselected)):GetInt(),
				Upgraded = false
			}

			local effect = EffectData()
			effect:SetEntity(car)
			util.Effect("phys_freeze", effect)

			table.insert(uvrvwithpursuittech, car)

			car:CallOnRemove( "UVRVWithPursuitTechRemoved", function(car)
				if table.HasValue(uvrvwithpursuittech, car) then
					table.RemoveByValue(uvrvwithpursuittech, car)
				end
			end)

			return true

			-- local ptselected = self:GetClientInfo("pursuittech")
			-- if car.PursuitTech then
			-- 	if car.PursuitTech == ptselected then
			-- 		self:GetOwner():ChatPrint(ptselected.." has ALREADY been applied to your "..UVGetVehicleMakeAndModel(car).."!")
			-- 		return false
			-- 	end
			-- 	self:GetOwner():ChatPrint(car.PursuitTech.." applied to your "..UVGetVehicleMakeAndModel(car).." has been changed to "..ptselected.."!")
			-- else
			-- 	self:GetOwner():ChatPrint(ptselected.." applied to your "..UVGetVehicleMakeAndModel(car).."!")
			-- end
			-- car.PursuitTech = ptselected
			-- local effect = EffectData()
			-- effect:SetEntity(car)
			-- util.Effect("phys_freeze", effect)
			-- table.insert(uvrvwithpursuittech, car)
			-- car:CallOnRemove( "UVRVWithPursuitTechRemoved", function(car)
			-- 	if table.HasValue(uvrvwithpursuittech, car) then
			-- 		table.RemoveByValue(uvrvwithpursuittech, car)
			-- 	end
			-- end)
			-- return true
		end

	end

	return false

end

function TOOL:RightClick(trace)
	if CLIENT then return false end

	local ptselected = self:GetClientInfo("pursuittech")
	
	if ptselected == pttable[#pttable] then
		self:GetOwner():ChatPrint("Pursuit Tech changed to "..pttable[1])
		self:GetOwner():ConCommand("uvunitpursuittech_pursuittech "..pttable[1])
	else
		for k,v in pairs(pttable) do
			if v == ptselected then
				self:GetOwner():ChatPrint("Pursuit Tech changed to "..pttable[k+1])
				self:GetOwner():ConCommand("uvunitpursuittech_pursuittech "..pttable[k+1])
			end
		end
	end

	return false
end

function TOOL:Reload()
	if CLIENT then return end
	
	local old_slot = self:GetClientNumber("slot")
	local new_slot = old_slot + 1
	if new_slot > slots then new_slot = 1 end

	self:GetOwner():ConCommand("uvunitpursuittech_slot "..new_slot)
	self:GetOwner():ChatPrint("Selected slot: "..new_slot)
end

if CLIENT then

	function TOOL.BuildCPanel(CPanel)

		local applysettings = vgui.Create("DButton")
		applysettings:SetText("Apply Settings")
		applysettings.DoClick = function()
			if !LocalPlayer():IsSuperAdmin() then
				notification.AddLegacy( "You need to be a super admin to apply settings!", NOTIFY_ERROR, 5 )
				surface.PlaySound( "buttons/button10.wav" )
				return
			end

			local convar_table = {}

			convar_table['unitvehicle_unitpursuittech_ptduration'] = GetConVar("uvunitpursuittech_ptduration"):GetInt()
			convar_table['unitvehicle_unitpursuittech_esfduration'] = GetConVar("uvunitpursuittech_esfduration"):GetInt()
			convar_table['unitvehicle_unitpursuittech_esfpower'] = GetConVar("uvunitpursuittech_esfpower"):GetInt()
			convar_table['unitvehicle_unitpursuittech_spikestripduration'] = GetConVar("uvunitpursuittech_spikestripduration"):GetInt()
			convar_table['unitvehicle_unitpursuittech_killswitchlockontime'] = GetConVar("uvunitpursuittech_killswitchlockontime"):GetInt()
			convar_table['unitvehicle_unitpursuittech_killswitchdisableduration'] = GetConVar("uvunitpursuittech_killswitchdisableduration"):GetInt()

			RunConsoleCommand("unitvehicle_unitpursuittech_ptduration", GetConVar("uvunitpursuittech_ptduration"):GetInt())
			RunConsoleCommand("unitvehicle_unitpursuittech_esfduration", GetConVar("uvunitpursuittech_esfduration"):GetInt())
			RunConsoleCommand("unitvehicle_unitpursuittech_esfpower", GetConVar("uvunitpursuittech_esfpower"):GetInt())
			RunConsoleCommand("unitvehicle_unitpursuittech_spikestripduration", GetConVar("uvunitpursuittech_spikestripduration"):GetInt())
			RunConsoleCommand("unitvehicle_unitpursuittech_killswitchlockontime", GetConVar("uvunitpursuittech_killswitchlockontime"):GetInt())
			RunConsoleCommand("unitvehicle_unitpursuittech_killswitchdisableduration", GetConVar("uvunitpursuittech_killswitchdisableduration"):GetInt())

			net.Start("UVUpdateSettings")
			net.WriteTable(convar_table)
			net.SendToServer()

			notification.AddLegacy( "Pursuit Tech Settings Applied!", NOTIFY_UNDO, 5 )
			surface.PlaySound( "buttons/button15.wav" )
			Msg( "Pursuit Tech Settings Applied!\n" )
		end
		CPanel:AddItem(applysettings)
	
		CPanel:AddControl("ComboBox", {
			MenuButton = 1,
			Folder = "unitpursuittech",
			Options = {
				["#preset.default"] = conVarsDefault
			},
			CVars = table.GetKeys(conVarsDefault)
		})

		CPanel:AddControl("Label", {
			Text = "/// Only ONE Pursuit Tech can be equipped to a single vehicle at any point! ///\n/// Special and Commander Units have UPGRADED Pursuit Tech! ///\n",
		})

		local ptduration = vgui.Create("DNumSlider")
		ptduration:SetMin(1)
		ptduration:SetMax(100)
		ptduration:SetDecimals(0)
		ptduration:SetText("PT Cooldown Duration")
		ptduration:SetConVar("uvunitpursuittech_ptduration")
		CPanel:AddItem(ptduration)

		--[[CPanel:AddControl("Label", {
			Text = "——— EMP ———",
		})

		CPanel:AddControl("Label", {
			Text = "- The Electromagnetic Pulse (EMP) targets and locks onto cars in front before delivering a huge electrostatic pulse that temporarily shuts down their electrical systems. Stronger than an ESF, but it takes time to lock on.",
		})]]

		CPanel:AddControl("Label", {
			Text = "——— ESF ———",
		})

		CPanel:AddControl("Label", {
			Text = "- The Electrostatic Field (ESF) charges your car's body with a powerful static field that protects it against Stun Mines, and deals a powerful shock to anyone that touches it.",
		})

		local esfduration = vgui.Create("DNumSlider")
		esfduration:SetMin(1)
		esfduration:SetMax(30)
		esfduration:SetDecimals(0)
		esfduration:SetText("ESF Duration")
		esfduration:SetConVar("uvunitpursuittech_esfduration")
		CPanel:AddItem(esfduration)

		local esfpower = vgui.Create("DNumSlider")
		esfpower:SetMin(100000)
		esfpower:SetMax(10000000)
		esfpower:SetDecimals(0)
		esfpower:SetText("ESF Power")
		esfpower:SetConVar("uvunitpursuittech_esfpower")
		CPanel:AddItem(esfpower)

		CPanel:AddControl("Label", {
			Text = "——— Spikes Strips ———",
		})

		CPanel:AddControl("Label", {
			Text = "- Deployed from the rear of the vehicle, Spike Strips expand to damage the tires of any car travelling over them.",
		})

		local spikestripduration = vgui.Create("DNumSlider")
		spikestripduration:SetMin(5)
		spikestripduration:SetMax(120)
		spikestripduration:SetDecimals(0)
		spikestripduration:SetText("Spike Strip Duration")
		spikestripduration:SetConVar("uvunitpursuittech_spikestripduration")
		CPanel:AddItem(spikestripduration)

		CPanel:AddControl("Label", {
			Text = "——— Killswitch ———",
		})

		CPanel:AddControl("Label", {
			Text = "- The Killswitch locks onto a target vehicle before delivering a powerful electromagnetic pulse that temporarily disables the engine.",
		})

		local killswitchlockontime = vgui.Create("DNumSlider")
		killswitchlockontime:SetMin(1)
		killswitchlockontime:SetMax(10)
		killswitchlockontime:SetDecimals(1)
		killswitchlockontime:SetText("KS Lock-On Time")
		killswitchlockontime:SetConVar("uvunitpursuittech_killswitchlockontime")
		CPanel:AddItem(killswitchlockontime)

		local killswitchdisableduration = vgui.Create("DNumSlider")
		killswitchdisableduration:SetMin(1)
		killswitchdisableduration:SetMax(10)
		killswitchdisableduration:SetDecimals(1)
		killswitchdisableduration:SetText("KS Disable Duration")
		killswitchdisableduration:SetConVar("uvunitpursuittech_killswitchdisableduration")
		CPanel:AddItem(killswitchdisableduration)

	end
	
	local toolicon = Material( "hud/(9)T_UI_PlayerCop_Large_Icon.png", "ignorez" )

	function TOOL:DrawToolScreen(width, height)

		local ptselected = self:GetClientInfo("pursuittech")
		local slot = self:GetClientNumber("slot")

		surface.SetDrawColor( Color( 0, 0, 0) )
		surface.DrawRect( 0, 0, width, height )
	
		surface.SetDrawColor( 0, 0, 255, 25)
		surface.SetMaterial( toolicon )
		surface.DrawTexturedRect( 0, 0, width, height )
		
		draw.SimpleText( ptselected, "DermaLarge", width / 2, height / 2, Color( 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText( 'Slot: '..slot, "DermaLarge", width / 2, height / 4, Color( 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	
	end

end