TOOL.Category		=	"Unit Vehicles"
TOOL.Name			=	"#Racer Pursuit Tech"
TOOL.Command		=	nil
TOOL.ConfigName		=	""

local pttable = {
	--"EMP",
	"Repair Kit",
	"ESF",
	"Jammer",
	"Shockwave",
	"Spikestrip",
	"Stunmine",
}

-- local pursuit_tech_list = {
-- 	["ESF"] = "Electromagnetic Field",
-- 	["Repair Kit"] = "Electromagnetic Field",
-- 	["Jammer"] = "Jammer",
-- 	["Shockwave"] = "Shockwave",
-- 	["Spikestrip"] = "Spike Strip",
-- 	["Stunmine"] = "Stun Mine",
-- }

local slots = 2

TOOL.ClientConVar[ "pursuittech" ] = pttable[1]
TOOL.ClientConVar[ "slot" ] = 1

TOOL.ClientConVar["ptduration"] = 60

-- ammo
TOOL.ClientConVar['maxammo_esf'] = 5
TOOL.ClientConVar['maxammo_jammer'] = 5
TOOL.ClientConVar['maxammo_shockwave'] = 5
TOOL.ClientConVar['maxammo_spikestrip'] = 5
TOOL.ClientConVar['maxammo_stunmine'] = 5
TOOL.ClientConVar['maxammo_repairkit'] = 5

-- cooldowns
TOOL.ClientConVar['cooldown_esf'] = 5
TOOL.ClientConVar['cooldown_jammer'] = 5
TOOL.ClientConVar['cooldown_shockwave'] = 5
TOOL.ClientConVar['cooldown_spikestrip'] = 5
TOOL.ClientConVar['cooldown_stunmine'] = 5
TOOL.ClientConVar['cooldown_repairkit'] = 5

TOOL.ClientConVar["esfduration"] = 10
TOOL.ClientConVar["esfpower"] = 2000000
TOOL.ClientConVar["jammerduration"] = 10
TOOL.ClientConVar["shockwavepower"] = 2000000
TOOL.ClientConVar["spikestripduration"] = 60
TOOL.ClientConVar["stunminepower"] = 2000000

local conVarsDefault = TOOL:BuildConVarList()

if CLIENT then

	TOOL.Information = {
		{ name = "info"},
		{ name = "left" },
		{ name = "right" },
	}

	language.Add("tool.uvpursuittech.name", "Racer Pursuit Tech")
	language.Add("tool.uvpursuittech.desc", "Apply Pursuit Tech to your vehicles! Use it to fight against the Unit Vehicles!")
	language.Add("tool.uvpursuittech.0", "Looking for more options? Find it under the options tab" )
	language.Add("tool.uvpursuittech.left", "Apply the Pursuit Tech to the your vehicle. Dosen't work on Unit Vehicles, use the Unit Pursuit Tech Tool for that!" )
	language.Add("tool.uvpursuittech.right", "Change Pursuit Tech" )

end

function TOOL:LeftClick( trace )

	local car = trace.Entity

	if !car.UnitVehicle and (car.IsGlideVehicle or car.IsSimfphyscar or car:GetClass() == "prop_vehicle_jeep") then

		if ( !CLIENT ) then
			local ptselected = self:GetClientInfo("pursuittech")
			local sanitized_pt = string.lower(string.gsub(ptselected, " ", ""))
			local slot = self:GetClientNumber("slot") or 1
			
			if !car.PursuitTech then
				car.PursuitTech = {}
			end

			local sel_k, sel_v

			for k,v in pairs(car.PursuitTech) do
				if v.Tech == ptselected then
					sel_k, sel_v = k, v
					car.PursuitTech[k] = nil
					break
				end
			end

			self:GetOwner():ChatPrint(
				sel_v
				and "Replacing "..sel_v.Tech.." with " ..ptselected.." (Slot "..slot..")"
				or "Placing "..ptselected.." on "..UVGetVehicleMakeAndModel(car).." (Slot "..slot..")"
			)

			local ammo_count = GetConVar("unitvehicle_pursuittech_maxammo_"..sanitized_pt):GetInt()
			ammo_count = ammo_count > 0 and ammo_count or math.huge

			car.PursuitTech[slot] = {
				Tech = ptselected,
				Ammo = ammo_count,
				Cooldown = GetConVar("unitvehicle_pursuittech_cooldown_"..sanitized_pt):GetInt(),
				LastUsed = 0,
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

		return false

	end

	return false

end

function TOOL:RightClick(trace)
	if CLIENT then return false end

	local ptselected = self:GetClientInfo("pursuittech")
	
	if ptselected == pttable[#pttable] then
		self:GetOwner():ChatPrint("Pursuit Tech changed to "..pttable[1])
		self:GetOwner():ConCommand("uvpursuittech_pursuittech "..pttable[1])
	else
		for k,v in pairs(pttable) do
			if v == ptselected then
				self:GetOwner():ChatPrint("Pursuit Tech changed to "..pttable[k+1])
				self:GetOwner():ConCommand("uvpursuittech_pursuittech "..pttable[k+1])
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

	self:GetOwner():ConCommand("uvpursuittech_slot "..new_slot)
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

			convar_table['unitvehicle_pursuittech_ptduration'] = GetConVar("uvpursuittech_ptduration"):GetInt()
			convar_table['unitvehicle_pursuittech_esfduration'] = GetConVar("uvpursuittech_esfduration"):GetInt()
			convar_table['unitvehicle_pursuittech_esfpower'] = GetConVar("uvpursuittech_esfpower"):GetInt()
			convar_table['unitvehicle_pursuittech_jammerduration'] = GetConVar("uvpursuittech_jammerduration"):GetInt()
			convar_table['unitvehicle_pursuittech_shockwavepower'] = GetConVar("uvpursuittech_shockwavepower"):GetInt()
			convar_table['unitvehicle_pursuittech_spikestripduration'] = GetConVar("uvpursuittech_spikestripduration"):GetInt()
			convar_table['unitvehicle_pursuittech_stunminepower'] = GetConVar("uvpursuittech_stunminepower"):GetInt()

			RunConsoleCommand("unitvehicle_pursuittech_ptduration", GetConVar("uvpursuittech_ptduration"):GetInt())
			RunConsoleCommand("unitvehicle_pursuittech_esfduration", GetConVar("uvpursuittech_esfduration"):GetInt())
			RunConsoleCommand("unitvehicle_pursuittech_esfpower", GetConVar("uvpursuittech_esfpower"):GetInt())
			RunConsoleCommand("unitvehicle_pursuittech_jammerduration", GetConVar("uvpursuittech_jammerduration"):GetInt())
			RunConsoleCommand("unitvehicle_pursuittech_shockwavepower", GetConVar("uvpursuittech_shockwavepower"):GetInt())
			RunConsoleCommand("unitvehicle_pursuittech_spikestripduration", GetConVar("uvpursuittech_spikestripduration"):GetInt())
			RunConsoleCommand("unitvehicle_pursuittech_stunminepower", GetConVar("uvpursuittech_stunminepower"):GetInt())

			for _, v in pairs(pttable) do
				local sanitized_pt = string.lower(string.gsub(v, " ", ""))
				convar_table['unitvehicle_pursuittech_maxammo_'..sanitized_pt] = GetConVar("uvpursuittech_maxammo_"..sanitized_pt):GetInt()
				convar_table['unitvehicle_pursuittech_cooldown_'..sanitized_pt] = GetConVar("uvpursuittech_cooldown_"..sanitized_pt):GetInt()
				RunConsoleCommand("unitvehicle_pursuittech_maxammo_"..sanitized_pt, GetConVar("uvpursuittech_maxammo_"..sanitized_pt):GetInt())
				RunConsoleCommand("unitvehicle_pursuittech_cooldown_"..sanitized_pt, GetConVar("uvpursuittech_cooldown_"..sanitized_pt):GetInt())
			end

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
			Folder = "pursuittech",
			Options = {
				["#preset.default"] = conVarsDefault
			},
			CVars = table.GetKeys(conVarsDefault)
		})

		CPanel:AddControl("Label", {
			Text = "/// Only ONE Pursuit Tech can be equipped to a single vehicle at any point! ///\n",
		})

		local ptduration = vgui.Create("DNumSlider")
		ptduration:SetMin(1)
		ptduration:SetMax(100)
		ptduration:SetDecimals(0)
		ptduration:SetText("PT Cooldown Duration")
		ptduration:SetConVar("uvpursuittech_ptduration")
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
		esfduration:SetConVar("uvpursuittech_esfduration")
		CPanel:AddItem(esfduration)

		local esfpower = vgui.Create("DNumSlider")
		esfpower:SetMin(100000)
		esfpower:SetMax(10000000)
		esfpower:SetDecimals(0)
		esfpower:SetText("ESF Power")
		esfpower:SetConVar("uvpursuittech_esfpower")
		CPanel:AddItem(esfpower)

		local esfcooldown = vgui.Create("DNumSlider")
		esfcooldown:SetMin(0)
		esfcooldown:SetMax(120)
		esfcooldown:SetDecimals(0)
		esfcooldown:SetText("ESF Cooldown")
		esfcooldown:SetConVar("uvpursuittech_cooldown_esf")
		CPanel:AddItem(esfcooldown)

		local esfammo = vgui.Create("DNumSlider")
		esfammo:SetMin(0)
		esfammo:SetMax(120)
		esfammo:SetDecimals(0)
		esfammo:SetText("ESF Ammo")
		esfammo:SetConVar("uvpursuittech_maxammo_esf")
		CPanel:AddItem(esfammo)

		esfduration.OnValueChanged = function(self, value)
			local cooldown_value = GetConVar("uvpursuittech_cooldown_esf"):GetInt()

			if value > cooldown_value then
				esfcooldown:SetValue(value)
			end

			esfcooldown:SetMin(value)
		end

		CPanel:AddControl("Label", {
			Text = "——— Jammer ———",
		})

		CPanel:AddControl("Label", {
			Text = "- The Jammer interferes with radar guidance and communications within the entire server, removing all existing Pursuit Tech deployments, and prevents others from using their Pursuit Tech.",
		})

		local jammerduration = vgui.Create("DNumSlider")
		jammerduration:SetMin(1)
		jammerduration:SetMax(30)
		jammerduration:SetDecimals(0)
		jammerduration:SetText("Jammer Duration")
		jammerduration:SetConVar("uvpursuittech_jammerduration")
		CPanel:AddItem(jammerduration)

		local jammercooldown = vgui.Create("DNumSlider")
		jammercooldown:SetMin(0)
		jammercooldown:SetMax(120)
		jammercooldown:SetDecimals(0)
		jammercooldown:SetText("Jammer Cooldown")
		jammercooldown:SetConVar("uvpursuittech_cooldown_jammer")
		CPanel:AddItem(jammercooldown)

		local jammerammo = vgui.Create("DNumSlider")
		jammerammo:SetMin(0)
		jammerammo:SetMax(120)
		jammerammo:SetDecimals(0)
		jammerammo:SetText("Jammer Ammo")
		jammerammo:SetConVar("uvpursuittech_maxammo_jammer")
		CPanel:AddItem(jammerammo)

		jammerduration.OnValueChanged = function(self, value)
			local cooldown_value = GetConVar("uvpursuittech_cooldown_jammer"):GetInt()

			if value > cooldown_value then
				jammercooldown:SetValue(value)
			end

			jammercooldown:SetMin(value)
		end

		CPanel:AddControl("Label", {
			Text = "——— Shockwave ———",
		})
		
		CPanel:AddControl("Label", {
			Text = "- The Shockwave creates a sonic shock blast from the center of the car that damages and pushes away nearby vehicles.",
		})

		local shockwavepower = vgui.Create("DNumSlider")
		shockwavepower:SetMin(100000)
		shockwavepower:SetMax(10000000)
		shockwavepower:SetDecimals(0)
		shockwavepower:SetText("Shockwave Power")
		shockwavepower:SetConVar("uvpursuittech_shockwavepower")
		CPanel:AddItem(shockwavepower)

		local shockwavecooldown = vgui.Create("DNumSlider")
		shockwavecooldown:SetMin(0)
		shockwavecooldown:SetMax(120)
		shockwavecooldown:SetDecimals(0)
		shockwavecooldown:SetText("Shockwave Cooldown")
		shockwavecooldown:SetConVar("uvpursuittech_cooldown_shockwave")
		CPanel:AddItem(shockwavecooldown)

		local shockwaveammo = vgui.Create("DNumSlider")
		shockwaveammo:SetMin(0)
		shockwaveammo:SetMax(120)
		shockwaveammo:SetDecimals(0)
		shockwaveammo:SetText("Shockwave Ammo")
		shockwaveammo:SetConVar("uvpursuittech_maxammo_shockwave")
		CPanel:AddItem(shockwaveammo)

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
		spikestripduration:SetConVar("uvpursuittech_spikestripduration")
		CPanel:AddItem(spikestripduration)

		local spikestripcooldown = vgui.Create("DNumSlider")
		spikestripcooldown:SetMin(0)
		spikestripcooldown:SetMax(120)
		spikestripcooldown:SetDecimals(0)
		spikestripcooldown:SetText("Spike Strip Cooldown")
		spikestripcooldown:SetConVar("uvpursuittech_cooldown_spikestrip")
		CPanel:AddItem(spikestripcooldown)

		local spikestripammo = vgui.Create("DNumSlider")
		spikestripammo:SetMin(0)
		spikestripammo:SetMax(120)
		spikestripammo:SetDecimals(0)
		spikestripammo:SetText("Spike Strip Ammo")
		spikestripammo:SetConVar("uvpursuittech_maxammo_spikestrip")
		CPanel:AddItem(spikestripammo)

		CPanel:AddControl("Label", {
			Text = "——— Stun Mine ———",
		})

		CPanel:AddControl("Label", {
			Text = "- Stun Mines are deployed behind your car. When contacted by other cars they will overload the vehicle's electrical system causing damage and loss of control.",
		})

		local stunminepower = vgui.Create("DNumSlider")
		stunminepower:SetMin(100000)
		stunminepower:SetMax(10000000)
		stunminepower:SetDecimals(0)
		stunminepower:SetText("Stun Mine Power")
		stunminepower:SetConVar("uvpursuittech_stunminepower")
		CPanel:AddItem(stunminepower)

		local stunminecooldown = vgui.Create("DNumSlider")
		stunminecooldown:SetMin(0)
		stunminecooldown:SetMax(120)
		stunminecooldown:SetDecimals(0)
		stunminecooldown:SetText("Stun Mine Cooldown")
		stunminecooldown:SetConVar("uvpursuittech_cooldown_stunmine")
		CPanel:AddItem(stunminecooldown)

		local stunmineammo = vgui.Create("DNumSlider")
		stunmineammo:SetMin(0)
		stunmineammo:SetMax(120)
		stunmineammo:SetDecimals(0)
		stunmineammo:SetText("Stun Mine Ammo")
		stunmineammo:SetConVar("uvpursuittech_maxammo_stunmine")
		CPanel:AddItem(stunmineammo)
		

		CPanel:AddControl("Label", {
			Text = "——— Repair Kit ———",
		})

		CPanel:AddControl("Label", {
			Text = "- Repair Kit deploys an onboard repair system that activates a rapid field-fix for your vehicle. Designed with emergency response and tactical mobility in mind, the Auto-Repair Module restores your vehicle’s structural integrity using built-in self-sealing components and reinforced hydraulic systems.",
		})

		local repairkitcooldown = vgui.Create("DNumSlider")
		repairkitcooldown:SetMin(0)
		repairkitcooldown:SetMax(120)
		repairkitcooldown:SetDecimals(0)
		repairkitcooldown:SetText("Repair Kit Cooldown")
		repairkitcooldown:SetConVar("uvpursuittech_cooldown_repairkit")
		CPanel:AddItem(repairkitcooldown)

		local repairkitammo = vgui.Create("DNumSlider")
		repairkitammo:SetMin(0)
		repairkitammo:SetMax(120)
		repairkitammo:SetDecimals(0)
		repairkitammo:SetText("Repair Kit Ammo")
		repairkitammo:SetConVar("uvpursuittech_maxammo_repairkit")
		CPanel:AddItem(repairkitammo)
	end
	
	local toolicon = Material( "hud/(9)T_UI_PlayerRacer_Large_Icon.png", "ignorez" )

	function TOOL:DrawToolScreen(width, height)

		local ptselected = self:GetClientInfo("pursuittech")
		local slot = self:GetClientNumber("slot")

		surface.SetDrawColor( Color( 0, 0, 0) )
		surface.DrawRect( 0, 0, width, height )
	
		surface.SetDrawColor( 255, 132, 0, 25)
		surface.SetMaterial( toolicon )
		surface.DrawTexturedRect( 0, 0, width, height )
		
		draw.SimpleText( ptselected, "DermaLarge", width / 2, height / 2, Color( 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText( 'Slot: '..slot, "DermaLarge", width / 2, height / 4, Color( 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	
	end

end