TOOL.Category		=	"uv.settings.unitvehicles"
TOOL.Name			=	"#tool.uvunitpursuittech.name"
TOOL.Command		=	nil
TOOL.ConfigName		=	""

local pttable = {
	"ESF",
	"Spikestrip",
	"Killswitch",
	"Repair Kit"
}

local slots = 2

TOOL.ClientConVar[ "pursuittech" ] = pttable[1]
TOOL.ClientConVar[ "slot" ] = 1

TOOL.ClientConVar["ptduration"] = 20

--ammo
TOOL.ClientConVar["maxammo_esf"] = 5
TOOL.ClientConVar["maxammo_spikestrip"] = 5
TOOL.ClientConVar["maxammo_killswitch"] = 5
TOOL.ClientConVar["maxammo_repairkit"] = 5

--cooldowns
TOOL.ClientConVar["cooldown_esf"] = 5
TOOL.ClientConVar["cooldown_spikestrip"] = 5
TOOL.ClientConVar["cooldown_killswitch"] = 5
TOOL.ClientConVar["cooldown_repairkit"] = 5

TOOL.ClientConVar["esfduration"] = 10
TOOL.ClientConVar["esfpower"] = 2000000
TOOL.ClientConVar["esfdamage"] = 0.2
TOOL.ClientConVar["spikestripduration"] = 60
TOOL.ClientConVar["killswitchlockontime"] = 3
TOOL.ClientConVar["killswitchdisableduration"] = 2.5

local conVarsDefault = TOOL:BuildConVarList()

if CLIENT then

	TOOL.Information = {
		{ name = "info"},
		{ name = "left" },
		{ name = "right" },
		{ name = "reload" }
	}

	-- language.Add("tool.uvunitpursuittech.name", "Unit Pursuit Tech")
	-- language.Add("tool.uvunitpursuittech.desc", "Apply Pursuit Tech to your Unit vehicles! Use it to fight against street racers!")
	-- language.Add("tool.uvunitpursuittech.0", "Looking for more options? Find it under the options tab" )
	-- language.Add("tool.uvunitpursuittech.left", "Apply the Pursuit Tech to the your Unit vehicle. Don't have a Unit vehicle? Create one using the Unit Manager!" )
	-- language.Add("tool.uvunitpursuittech.right", "Change Pursuit Tech" )
	-- language.Add("tool.uvunitpursuittech.reload", "Select Pursuit Tech slot" )

end

function TOOL:LeftClick( trace )
	local car = trace.Entity

	if car.UnitVehicle and (car.IsGlideVehicle or car.IsSimfphyscar or car:GetClass() == "prop_vehicle_jeep") then

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

			local ammo_count = GetConVar("unitvehicle_unitpursuittech_maxammo_"..sanitized_pt):GetInt()
			ammo_count = ammo_count > 0 and ammo_count or math.huge

			car.PursuitTech[slot] = {
				Tech = ptselected,
				Ammo = ammo_count,
				Cooldown = GetConVar("unitvehicle_unitpursuittech_cooldown_"..sanitized_pt):GetInt(),
				LastUsed = -math.huge,
				Upgraded = false
			}

			local effect = EffectData()
			effect:SetEntity(car)
			util.Effect("phys_freeze", effect)

			table.insert(uvrvwithpursuittech, car)

			car:CallOnRemove("UVRVWithPursuitTechRemoved", function(car)
				if table.HasValue(uvrvwithpursuittech, car) then
					table.RemoveByValue(uvrvwithpursuittech, car)
				end

				-- Clear PursuitTech on clients too
				-- net.Start("UV_SendPursuitTech")
				-- 	net.WriteEntity(car)
				-- 	net.WriteTable({})
				-- net.Broadcast()
			end)

            -- Network the PursuitTech to all clients
            -- net.Start("UV_SendPursuitTech")
            --     net.WriteEntity(car)
            --     net.WriteTable(car.PursuitTech)
            -- net.Broadcast()
			-- In case one pt is replaced
			for i=1,2 do
				UVReplicatePT( car, i )
			end

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
		self:GetOwner():ConCommand("uvunitpursuittech_pursuittech "..pttable[1])
	else
		for k,v in pairs(pttable) do
			if v == ptselected then
				-- self:GetOwner():ChatPrint("Pursuit Tech changed to "..pttable[k+1])
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
	-- self:GetOwner():ChatPrint("Slot: " .. new_slot .. " selected.")
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

			convar_table['unitvehicle_unitpursuittech_ptduration'] = GetConVar("uvunitpursuittech_ptduration"):GetFloat()
			convar_table['unitvehicle_unitpursuittech_esfduration'] = GetConVar("uvunitpursuittech_esfduration"):GetFloat()
			convar_table['unitvehicle_unitpursuittech_esfpower'] = GetConVar("uvunitpursuittech_esfpower"):GetFloat()
			convar_table['unitvehicle_unitpursuittech_esfdamage'] = GetConVar("uvunitpursuittech_esfdamage"):GetFloat()
			convar_table['unitvehicle_unitpursuittech_spikestripduration'] = GetConVar("uvunitpursuittech_spikestripduration"):GetFloat()
			convar_table['unitvehicle_unitpursuittech_killswitchlockontime'] = GetConVar("uvunitpursuittech_killswitchlockontime"):GetFloat()
			convar_table['unitvehicle_unitpursuittech_killswitchdisableduration'] = GetConVar("uvunitpursuittech_killswitchdisableduration"):GetFloat()

			-- RunConsoleCommand("unitvehicle_unitpursuittech_ptduration", GetConVar("uvunitpursuittech_ptduration"):GetFloat())
			-- RunConsoleCommand("unitvehicle_unitpursuittech_esfduration", GetConVar("uvunitpursuittech_esfduration"):GetFloat())
			-- RunConsoleCommand("unitvehicle_unitpursuittech_esfpower", GetConVar("uvunitpursuittech_esfpower"):GetFloat())
			-- RunConsoleCommand("unitvehicle_unitpursuittech_esfdamage", GetConVar("uvunitpursuittech_esfdamage"):GetFloat())
			-- RunConsoleCommand("unitvehicle_unitpursuittech_spikestripduration", GetConVar("uvunitpursuittech_spikestripduration"):GetFloat())
			-- RunConsoleCommand("unitvehicle_unitpursuittech_killswitchlockontime", GetConVar("uvunitpursuittech_killswitchlockontime"):GetFloat())
			-- RunConsoleCommand("unitvehicle_unitpursuittech_killswitchdisableduration", GetConVar("uvunitpursuittech_killswitchdisableduration"):GetFloat())

			for _, v in pairs(pttable) do
				local sanitized_pt = string.lower(string.gsub(v, " ", ""))
				convar_table['unitvehicle_unitpursuittech_maxammo_'..sanitized_pt] = GetConVar("uvunitpursuittech_maxammo_"..sanitized_pt):GetInt()
				convar_table['unitvehicle_unitpursuittech_cooldown_'..sanitized_pt] = GetConVar("uvunitpursuittech_cooldown_"..sanitized_pt):GetInt()
				-- RunConsoleCommand("unitvehicle_unitpursuittech_maxammo_"..sanitized_pt, GetConVar("uvunitpursuittech_maxammo_"..sanitized_pt):GetInt())
				-- RunConsoleCommand("unitvehicle_unitpursuittech_cooldown_"..sanitized_pt, GetConVar("uvunitpursuittech_cooldown_"..sanitized_pt):GetInt())
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
			Folder = "unitpursuittech",
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
		esfduration:SetConVar("uvunitpursuittech_esfduration")
		CPanel:AddItem(esfduration)

		local esfpower = vgui.Create("DNumSlider")
		esfpower:SetMin(100000)
		esfpower:SetMax(10000000)
		esfpower:SetDecimals(0)
		esfpower:SetText("#uv.ptech.power")
		esfpower:SetTooltip("#uv.ptech.power.desc")
		esfpower:SetConVar("uvunitpursuittech_esfpower")
		CPanel:AddItem(esfpower)

		local esfdamage = vgui.Create("DNumSlider")
		esfdamage:SetMin(0)
		esfdamage:SetMax(1)
		esfdamage:SetDecimals(1)
		esfdamage:SetText("#uv.ptech.damage")
		esfdamage:SetTooltip("#uv.ptech.damage.desc")
		esfdamage:SetConVar("uvunitpursuittech_esfdamage")
		CPanel:AddItem(esfdamage)

		local esfcooldown = vgui.Create("DNumSlider")
		esfcooldown:SetMin(0)
		esfcooldown:SetMax(120)
		esfcooldown:SetDecimals(0)
		esfcooldown:SetText("#uv.ptech.cooldown")
		esfcooldown:SetTooltip("#uv.ptech.cooldown.desc")
		esfcooldown:SetConVar("uvunitpursuittech_cooldown_esf")
		CPanel:AddItem(esfcooldown)

		local esfammo = vgui.Create("DNumSlider")
		esfammo:SetMin(0)
		esfammo:SetMax(120)
		esfammo:SetDecimals(0)
		esfammo:SetText("#uv.ptech.ammo")
		esfammo:SetTooltip("#uv.ptech.ammo.desc")
		esfammo:SetConVar("uvunitpursuittech_maxammo_esf")
		CPanel:AddItem(esfammo)

		esfduration.OnValueChanged = function(self, value)
			local cooldown_value = GetConVar("uvunitpursuittech_cooldown_esf"):GetInt()

			if value > cooldown_value then
				esfcooldown:SetValue(value)
			end

			esfcooldown:SetMin(value)
		end

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
		spikestripduration:SetConVar("uvunitpursuittech_spikestripduration")
		CPanel:AddItem(spikestripduration)

		local spikestripcooldown = vgui.Create("DNumSlider")
		spikestripcooldown:SetMin(0)
		spikestripcooldown:SetMax(120)
		spikestripcooldown:SetDecimals(0)
		spikestripcooldown:SetText("#uv.ptech.cooldown")
		spikestripcooldown:SetTooltip("#uv.ptech.cooldown.desc")
		spikestripcooldown:SetConVar("uvunitpursuittech_cooldown_spikestrip")
		CPanel:AddItem(spikestripcooldown)

		local spikestripammo = vgui.Create("DNumSlider")
		spikestripammo:SetMin(0)
		spikestripammo:SetMax(120)
		spikestripammo:SetDecimals(0)
		spikestripammo:SetText("#uv.ptech.ammo")
		spikestripammo:SetTooltip("#uv.ptech.ammo.desc")
		spikestripammo:SetConVar("uvunitpursuittech_maxammo_spikestrip")
		CPanel:AddItem(spikestripammo)

		CPanel:AddControl("Label", {
			Text = "#uv.ptech.killswitch.title",
		})

		CPanel:AddControl("Label", {
			Text = "#uv.ptech.killswitch.desc",
		})

		local killswitchlockontime = vgui.Create("DNumSlider")
		killswitchlockontime:SetMin(1)
		killswitchlockontime:SetMax(10)
		killswitchlockontime:SetDecimals(1)
		killswitchlockontime:SetText("#uv.ptech.disablelock")
		killswitchlockontime:SetTooltip("#uv.ptech.disablelock.desc")
		killswitchlockontime:SetConVar("uvunitpursuittech_killswitchlockontime")
		CPanel:AddItem(killswitchlockontime)

		local killswitchdisableduration = vgui.Create("DNumSlider")
		killswitchdisableduration:SetMin(1)
		killswitchdisableduration:SetMax(10)
		killswitchdisableduration:SetDecimals(1)
		killswitchdisableduration:SetText("#uv.ptech.disabletime")
		killswitchdisableduration:SetTooltip("#uv.ptech.disabletime.desc")
		killswitchdisableduration:SetConVar("uvunitpursuittech_killswitchdisableduration")
		CPanel:AddItem(killswitchdisableduration)

		local killswitchcooldown = vgui.Create("DNumSlider")
		killswitchcooldown:SetMin(0)
		killswitchcooldown:SetMax(120)
		killswitchcooldown:SetDecimals(0)
		killswitchcooldown:SetText("#uv.ptech.cooldown")
		killswitchcooldown:SetTooltip("#uv.ptech.cooldown.desc")
		killswitchcooldown:SetConVar("uvunitpursuittech_cooldown_killswitch")
		CPanel:AddItem(killswitchcooldown)

		local killswitchammo = vgui.Create("DNumSlider")
		killswitchammo:SetMin(0)
		killswitchammo:SetMax(120)
		killswitchammo:SetDecimals(0)
		killswitchammo:SetText("#uv.ptech.ammo")
		killswitchammo:SetTooltip("#uv.ptech.ammo.desc")
		killswitchammo:SetConVar("uvunitpursuittech_maxammo_killswitch")
		CPanel:AddItem(killswitchammo)

		killswitchlockontime.OnValueChanged = function(self, value)
			local cooldown_value = GetConVar("uvunitpursuittech_cooldown_killswitch"):GetInt()

			if value > cooldown_value then
				killswitchcooldown:SetValue(value)
			end

			killswitchcooldown:SetMin(value)
		end

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
		repairkitcooldown:SetConVar("uvunitpursuittech_cooldown_repairkit")
		CPanel:AddItem(repairkitcooldown)

		local repairkitammo = vgui.Create("DNumSlider")
		repairkitammo:SetMin(0)
		repairkitammo:SetMax(120)
		repairkitammo:SetDecimals(0)
		repairkitammo:SetText("#uv.ptech.ammo")
		repairkitammo:SetTooltip("#uv.ptech.ammo.desc")
		repairkitammo:SetConVar("uvunitpursuittech_maxammo_repairkit")
		CPanel:AddItem(repairkitammo)
	end
	
	local toolicon = Material( "unitvehicles/icons/(9)T_UI_PlayerCop_Large_Icon.png", "ignorez" )

	function TOOL:DrawToolScreen(width, height)

		local ptselected = self:GetClientInfo("pursuittech")
		local slot = self:GetClientNumber("slot")
		local PT_Replacement_Strings = {
			['ESF'] = '#uv.ptech.esf.short',
			['Killswitch'] = '#uv.ptech.killswitch',
			['Spikestrip'] = '#uv.ptech.spikes',
			['Repair Kit'] = '#uv.ptech.repairkit'
		}

		surface.SetDrawColor( Color( 0, 0, 0) )
		surface.DrawRect( 0, 0, width, height )
	
		surface.SetDrawColor( 0, 0, 255, 25)
		surface.SetMaterial( toolicon )
		surface.DrawTexturedRect( 0, 0, width, height )
		
		draw.SimpleText((PT_Replacement_Strings[ptselected] or ptselected), "DermaLarge", width / 2, height / 2, Color( 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText( slot == 1 and "#uv.ptech.slot.left" or "#uv.ptech.slot.right", "DermaLarge", width / 2, height / 4, Color( 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	
	end

end