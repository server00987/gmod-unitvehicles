TOOL.Category		=	"uv.settings.unitvehicles"
TOOL.Name			=	"#tool.uvpursuittech.name"
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
TOOL.ClientConVar["esfdamage"] = 0.2
TOOL.ClientConVar["jammerduration"] = 10
TOOL.ClientConVar["shockwavepower"] = 2000000
TOOL.ClientConVar["shockwavedamage"] = 0.1
TOOL.ClientConVar["spikestripduration"] = 60
TOOL.ClientConVar["stunminepower"] = 2000000
TOOL.ClientConVar["stunminedamage"] = 0.1

local conVarsDefault = TOOL:BuildConVarList()

if CLIENT then

	TOOL.Information = {
		{ name = "info"},
		{ name = "left" },
		{ name = "right" },
		{ name = "reload" }
	}

	-- language.Add("tool.uvpursuittech.name", "Racer Pursuit Tech")
	-- language.Add("tool.uvpursuittech.desc", "Apply Pursuit Tech to your vehicles! Use it to fight against the Unit Vehicles!")
	-- language.Add("tool.uvpursuittech.0", "Looking for more options? Find it under the options tab" )
	-- language.Add("tool.uvpursuittech.left", "Apply the Pursuit Tech to the your vehicle. Dosen't work on Unit Vehicles, use the Unit Pursuit Tech Tool for that!" )
	-- language.Add("tool.uvpursuittech.right", "Change Pursuit Tech" )
	-- language.Add("tool.uvpursuittech.reload", "Select Pursuit Tech slot" )

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

			-- self:GetOwner():ChatPrint(
				-- sel_v
				-- and string.format( language.GetPhrase("tool.uvpursuittech.popup.replace"), UVGetVehicleMakeAndModel(car), ptselected, (PT_Slots_Replacement_Strings[slot] or slot), sel_v.Tech )
				-- or string.format( language.GetPhrase("tool.uvpursuittech.popup.install"), UVGetVehicleMakeAndModel(car), ptselected, (PT_Slots_Replacement_Strings[slot] or slot) )
			-- )

			local ammo_count = GetConVar("unitvehicle_pursuittech_maxammo_"..sanitized_pt):GetInt()
			ammo_count = ammo_count > 0 and ammo_count or math.huge

			car.PursuitTech[slot] = {
				Tech = ptselected,
				Ammo = ammo_count,
				Cooldown = GetConVar("unitvehicle_pursuittech_cooldown_"..sanitized_pt):GetInt(),
				LastUsed = -math.huge,
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
		end

		return false

	end

	return false

end

function TOOL:RightClick(trace)
	if CLIENT then return false end

	local ptselected = self:GetClientInfo("pursuittech")
	
	if ptselected == pttable[#pttable] then
		-- self:GetOwner():ChatPrint("Pursuit Tech changed to "..pttable[1])
		self:GetOwner():ConCommand("uvpursuittech_pursuittech "..pttable[1])
	else
		for k,v in pairs(pttable) do
			if v == ptselected then
				-- self:GetOwner():ChatPrint("Pursuit Tech changed to "..pttable[k+1])
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
	-- self:GetOwner():ChatPrint("Slot ".. new_slot .. " selected.")
end

if CLIENT then

	function TOOL.BuildCPanel(CPanel)

		local applysettings = vgui.Create("DButton")
		applysettings:SetText("#spawnmenu.savechanges")
		applysettings.DoClick = function()
			if !LocalPlayer():IsSuperAdmin() then
				notification.AddLegacy( "#tool.uvpursuitbreaker.needsuperadmin", NOTIFY_ERROR, 5 )
				surface.PlaySound( "buttons/button10.wav" )
				return
			end

			local convar_table = {}

			convar_table['unitvehicle_pursuittech_ptduration'] = GetConVar("uvpursuittech_ptduration"):GetFloat()
			convar_table['unitvehicle_pursuittech_esfduration'] = GetConVar("uvpursuittech_esfduration"):GetFloat()
			convar_table['unitvehicle_pursuittech_esfpower'] = GetConVar("uvpursuittech_esfpower"):GetFloat()
			convar_table['unitvehicle_pursuittech_esfdamage'] = GetConVar("uvpursuittech_esfdamage"):GetFloat()
			convar_table['unitvehicle_pursuittech_jammerduration'] = GetConVar("uvpursuittech_jammerduration"):GetFloat()
			convar_table['unitvehicle_pursuittech_shockwavepower'] = GetConVar("uvpursuittech_shockwavepower"):GetFloat()
			convar_table['unitvehicle_pursuittech_shockwavedamage'] = GetConVar("uvpursuittech_shockwavedamage"):GetFloat()
			convar_table['unitvehicle_pursuittech_spikestripduration'] = GetConVar("uvpursuittech_spikestripduration"):GetFloat()
			convar_table['unitvehicle_pursuittech_stunminepower'] = GetConVar("uvpursuittech_stunminepower"):GetFloat()
			convar_table['unitvehicle_pursuittech_stunminedamage'] = GetConVar("uvpursuittech_stunminedamage"):GetFloat()

			RunConsoleCommand("unitvehicle_pursuittech_ptduration", GetConVar("uvpursuittech_ptduration"):GetFloat())
			RunConsoleCommand("unitvehicle_pursuittech_esfduration", GetConVar("uvpursuittech_esfduration"):GetFloat())
			RunConsoleCommand("unitvehicle_pursuittech_esfpower", GetConVar("uvpursuittech_esfpower"):GetFloat())
			RunConsoleCommand("unitvehicle_pursuittech_esfdamage", GetConVar("uvpursuittech_esfdamage"):GetFloat())
			RunConsoleCommand("unitvehicle_pursuittech_jammerduration", GetConVar("uvpursuittech_jammerduration"):GetFloat())
			RunConsoleCommand("unitvehicle_pursuittech_shockwavepower", GetConVar("uvpursuittech_shockwavepower"):GetFloat())
			RunConsoleCommand("unitvehicle_pursuittech_shockwavedamage", GetConVar("uvpursuittech_shockwavedamage"):GetFloat())
			RunConsoleCommand("unitvehicle_pursuittech_spikestripduration", GetConVar("uvpursuittech_spikestripduration"):GetFloat())
			RunConsoleCommand("unitvehicle_pursuittech_stunminepower", GetConVar("uvpursuittech_stunminepower"):GetFloat())
			RunConsoleCommand("unitvehicle_pursuittech_stunminedamage", GetConVar("uvpursuittech_stunminedamage"):GetFloat())
			

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

			notification.AddLegacy( "#tool.uvpursuittech.applied", NOTIFY_UNDO, 5 )
			surface.PlaySound( "buttons/button15.wav" )
			Msg( "#tool.uvpursuittech.applied" )
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

		--[[CPanel:AddControl("Label", {
			Text = "#uv.ptech.emp.title",
		})

		CPanel:AddControl("Label", {
			Text = "#uv.ptech.emp.desc",
		})]]

		CPanel:AddControl("Label", {
			Text = "#uv.ptech.esf.title",
		})

		CPanel:AddControl("Label", {
			Text = "#uv.ptech.esf.desc",
		})

		local esfduration = vgui.Create("DNumSlider")
		esfduration:SetMin(1)
		esfduration:SetMax(30)
		esfduration:SetDecimals(0)
		esfduration:SetText("#uv.ptech.duration")
		esfduration:SetTooltip("#uv.ptech.duration.desc")
		esfduration:SetConVar("uvpursuittech_esfduration")
		CPanel:AddItem(esfduration)

		local esfpower = vgui.Create("DNumSlider")
		esfpower:SetMin(100000)
		esfpower:SetMax(10000000)
		esfpower:SetDecimals(0)
		esfpower:SetText("#uv.ptech.power")
		esfpower:SetTooltip("#uv.ptech.power.desc")
		esfpower:SetConVar("uvpursuittech_esfpower")
		CPanel:AddItem(esfpower)

		local esfdamage = vgui.Create("DNumSlider")
		esfdamage:SetMin(0)
		esfdamage:SetMax(1)
		esfdamage:SetDecimals(1)
		esfdamage:SetText("#uv.ptech.damage")
		esfdamage:SetTooltip("#uv.ptech.damage.desc")
		esfdamage:SetConVar("uvpursuittech_esfdamage")
		CPanel:AddItem(esfdamage)

		local esfcooldown = vgui.Create("DNumSlider")
		esfcooldown:SetMin(0)
		esfcooldown:SetMax(120)
		esfcooldown:SetDecimals(0)
		esfcooldown:SetText("#uv.ptech.cooldown")
		esfcooldown:SetTooltip("#uv.ptech.cooldown.desc")
		esfcooldown:SetConVar("uvpursuittech_cooldown_esf")
		CPanel:AddItem(esfcooldown)

		local esfammo = vgui.Create("DNumSlider")
		esfammo:SetMin(0)
		esfammo:SetMax(120)
		esfammo:SetDecimals(0)
		esfammo:SetText("#uv.ptech.ammo")
		esfammo:SetTooltip("#uv.ptech.ammo.desc")
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
			Text = "#uv.ptech.jammer.title",
		})

		CPanel:AddControl("Label", {
			Text = "#uv.ptech.jammer.desc",
		})

		local jammerduration = vgui.Create("DNumSlider")
		jammerduration:SetMin(1)
		jammerduration:SetMax(30)
		jammerduration:SetDecimals(0)
		jammerduration:SetText("#uv.ptech.duration")
		jammerduration:SetTooltip("#uv.ptech.duration.desc")
		jammerduration:SetConVar("uvpursuittech_jammerduration")
		CPanel:AddItem(jammerduration)

		local jammercooldown = vgui.Create("DNumSlider")
		jammercooldown:SetMin(0)
		jammercooldown:SetMax(120)
		jammercooldown:SetDecimals(0)
		jammercooldown:SetText("#uv.ptech.cooldown")
		jammercooldown:SetTooltip("#uv.ptech.cooldown.desc")
		jammercooldown:SetConVar("uvpursuittech_cooldown_jammer")
		CPanel:AddItem(jammercooldown)

		local jammerammo = vgui.Create("DNumSlider")
		jammerammo:SetMin(0)
		jammerammo:SetMax(120)
		jammerammo:SetDecimals(0)
		jammerammo:SetText("#uv.ptech.ammo")
		jammerammo:SetTooltip("#uv.ptech.ammo.desc")
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
			Text = "#uv.ptech.shockwave.title",
		})
		
		CPanel:AddControl("Label", {
			Text = "#uv.ptech.shockwave.desc",
		})

		local shockwavepower = vgui.Create("DNumSlider")
		shockwavepower:SetMin(100000)
		shockwavepower:SetMax(10000000)
		shockwavepower:SetDecimals(0)
		shockwavepower:SetText("#uv.ptech.power")
		shockwavepower:SetTooltip("#uv.ptech.power.desc")
		shockwavepower:SetConVar("uvpursuittech_shockwavepower")
		CPanel:AddItem(shockwavepower)

		local shockwavedamage = vgui.Create("DNumSlider")
		shockwavedamage:SetMin(0)
		shockwavedamage:SetMax(1)
		shockwavedamage:SetDecimals(1)
		shockwavedamage:SetText("#uv.ptech.damage")
		shockwavedamage:SetTooltip("#uv.ptech.damage.desc")
		shockwavedamage:SetConVar("uvpursuittech_shockwavedamage")
		CPanel:AddItem(shockwavedamage)

		local shockwavecooldown = vgui.Create("DNumSlider")
		shockwavecooldown:SetMin(0)
		shockwavecooldown:SetMax(120)
		shockwavecooldown:SetDecimals(0)
		shockwavecooldown:SetText("#uv.ptech.cooldown")
		shockwavecooldown:SetText("#uv.ptech.cooldown")
		shockwavecooldown:SetConVar("uvpursuittech_cooldown_shockwave")
		CPanel:AddItem(shockwavecooldown)

		local shockwaveammo = vgui.Create("DNumSlider")
		shockwaveammo:SetMin(0)
		shockwaveammo:SetMax(120)
		shockwaveammo:SetDecimals(0)
		shockwaveammo:SetText("#uv.ptech.ammo")
		shockwaveammo:SetTooltip("#uv.ptech.ammo.desc")
		shockwaveammo:SetConVar("uvpursuittech_maxammo_shockwave")
		CPanel:AddItem(shockwaveammo)

		CPanel:AddControl("Label", {
			Text = "#uv.ptech.spikes.title",
		})

		CPanel:AddControl("Label", {
			Text = "#uv.ptech.spikes.desc",
		})

		local spikestripduration = vgui.Create("DNumSlider")
		spikestripduration:SetMin(5)
		spikestripduration:SetMax(120)
		spikestripduration:SetDecimals(0)
		spikestripduration:SetText("#uv.ptech.duration")
		spikestripduration:SetTooltip("#uv.ptech.duration.desc")
		spikestripduration:SetConVar("uvpursuittech_spikestripduration")
		CPanel:AddItem(spikestripduration)

		local spikestripcooldown = vgui.Create("DNumSlider")
		spikestripcooldown:SetMin(0)
		spikestripcooldown:SetMax(120)
		spikestripcooldown:SetDecimals(0)
		spikestripcooldown:SetText("#uv.ptech.cooldown")
		spikestripcooldown:SetTooltip("#uv.ptech.cooldown.desc")
		spikestripcooldown:SetConVar("uvpursuittech_cooldown_spikestrip")
		CPanel:AddItem(spikestripcooldown)

		local spikestripammo = vgui.Create("DNumSlider")
		spikestripammo:SetMin(0)
		spikestripammo:SetMax(120)
		spikestripammo:SetDecimals(0)
		spikestripammo:SetText("#uv.ptech.ammo")
		spikestripammo:SetTooltip("#uv.ptech.ammo.desc")
		spikestripammo:SetConVar("uvpursuittech_maxammo_spikestrip")
		CPanel:AddItem(spikestripammo)

		CPanel:AddControl("Label", {
			Text = "#uv.ptech.stunmine.title",
		})

		CPanel:AddControl("Label", {
			Text = "#uv.ptech.stunmine.desc",
		})

		local stunminepower = vgui.Create("DNumSlider")
		stunminepower:SetMin(100000)
		stunminepower:SetMax(10000000)
		stunminepower:SetDecimals(0)
		stunminepower:SetText("#uv.ptech.power")
		stunminepower:SetTooltip("#uv.ptech.power.desc")
		stunminepower:SetConVar("uvpursuittech_stunminepower")
		CPanel:AddItem(stunminepower)

		local stunminedamage = vgui.Create("DNumSlider")
		stunminedamage:SetMin(0)
		stunminedamage:SetMax(1)
		stunminedamage:SetDecimals(1)
		stunminedamage:SetText("#uv.ptech.damage")
		stunminedamage:SetTooltip("#uv.ptech.damage.desc")
		stunminedamage:SetConVar("uvpursuittech_stunminedamage")
		CPanel:AddItem(stunminedamage)

		local stunminecooldown = vgui.Create("DNumSlider")
		stunminecooldown:SetMin(0)
		stunminecooldown:SetMax(120)
		stunminecooldown:SetDecimals(0)
		stunminecooldown:SetText("#uv.ptech.cooldown")
		stunminecooldown:SetTooltip("#uv.ptech.cooldown.desc")
		stunminecooldown:SetConVar("uvpursuittech_cooldown_stunmine")
		CPanel:AddItem(stunminecooldown)

		local stunmineammo = vgui.Create("DNumSlider")
		stunmineammo:SetMin(0)
		stunmineammo:SetMax(120)
		stunmineammo:SetDecimals(0)
		stunmineammo:SetText("#uv.ptech.ammo")
		stunmineammo:SetTooltip("#uv.ptech.ammo.desc")
		stunmineammo:SetConVar("uvpursuittech_maxammo_stunmine")
		CPanel:AddItem(stunmineammo)
		

		CPanel:AddControl("Label", {
			Text = "#uv.ptech.repairkit.title",
		})

		CPanel:AddControl("Label", {
			Text = "#uv.ptech.repairkit.desc",
		})

		local repairkitcooldown = vgui.Create("DNumSlider")
		repairkitcooldown:SetMin(0)
		repairkitcooldown:SetMax(120)
		repairkitcooldown:SetDecimals(0)
		repairkitcooldown:SetText("#uv.ptech.cooldown")
		repairkitcooldown:SetTooltip("#uv.ptech.cooldown.desc")
		repairkitcooldown:SetConVar("uvpursuittech_cooldown_repairkit")
		CPanel:AddItem(repairkitcooldown)

		local repairkitammo = vgui.Create("DNumSlider")
		repairkitammo:SetMin(0)
		repairkitammo:SetMax(120)
		repairkitammo:SetDecimals(0)
		repairkitammo:SetText("#uv.ptech.ammo")
		repairkitammo:SetTooltip("#uv.ptech.ammo.desc")
		repairkitammo:SetConVar("uvpursuittech_maxammo_repairkit")
		CPanel:AddItem(repairkitammo)
	end
	
	local toolicon = Material( "hud/(9)T_UI_PlayerRacer_Large_Icon.png", "ignorez" )

	function TOOL:DrawToolScreen(width, height)

		local ptselected = self:GetClientInfo("pursuittech")
		local slot = self:GetClientNumber("slot")
		local PT_Replacement_Strings = {
			['ESF'] = '#uv.ptech.esf.short',
			['Jammer'] = '#uv.ptech.jammer',
			['Shockwave'] = '#uv.ptech.shockwave',
			['Stunmine'] = '#uv.ptech.stunmine',
			['Spikestrip'] = '#uv.ptech.spikes',
			['Repair Kit'] = '#uv.ptech.repairkit'
		}

		surface.SetDrawColor( Color( 0, 0, 0) )
		surface.DrawRect( 0, 0, width, height )
	
		surface.SetDrawColor( 255, 132, 0, 25)
		surface.SetMaterial( toolicon )
		surface.DrawTexturedRect( 0, 0, width, height )
		
		draw.SimpleText((PT_Replacement_Strings[ptselected] or ptselected), "DermaLarge", width / 2, height / 2, Color( 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText( slot == 1 and "#uv.ptech.slot1" or "#uv.ptech.slot2", "DermaLarge", width / 2, height / 4, Color( 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	
	end

end