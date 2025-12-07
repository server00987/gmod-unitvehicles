--[[ 
UVMenu Framework
Single-file menu system for Garry's Mod
Author: Adapted from UnitVehicles Settings menu
]]

--[[ UVMenu:Open
    config = {
        Title = "Menu title",
        Width = 800,
        Height = 600,
        MainColor = Color(...),
        PanelColor = Color(...),
        AccentColor = Color(...),
        TitleFont = "fontname",
        ItemFont = "fontname",
        Description = true/false,
        Tabs = { {name="tab1", items={...}}, ... }
    }
--]]

UVMenu = UVMenu or {}

-- Store all menus globally
UVMenu.Menus = UVMenu.Menus or {}

function UV.PlayerCanSeeSetting(st)
	if st.sv or st.admin then
		local ply = LocalPlayer()
		if not IsValid(ply) then return false end
		if not ply:IsAdmin() and not ply:IsSuperAdmin() then
		-- if ply:IsAdmin() and ply:IsSuperAdmin() then
			return false
		end
	end
	return true
end

-- Filtering logic similar to ARC9
function UV.ShouldDrawSetting(st)
		if not UV.PlayerCanSeeSetting(st) then
			return false
		end

		if st.showfunc and st.showfunc() == false then return false end

		if st.requireparentconvar then
			local c = GetConVar(st.requireparentconvar)
			if c then
				local v = c:GetBool()
				if st.parentinvert then v = not v end
				if not v then return false end
			end
		elseif st.parentconvar then
			local c = GetConVar(st.parentconvar)
			if c then
				local v = c:GetBool()
				if st.parentinvert then v = not v end
				if not v then return false end
			end
		end

		if st.requireconvar then
			local c = GetConVar(st.requireconvar)
			if c and not c:GetBool() then return false end
		end

		if st.requireconvaroff then
			local c = GetConVar(st.requireconvaroff)
			if c and c:GetBool() then return false end
		end

		return true
	end

-- small materials for on/off indicators
local matTick = Material("unitvehicles/icons/generic_check.png", "mips")
local matCross = Material("unitvehicles/icons/generic_uncheck.png", "mips")

-- Build one setting (label / bool / slider / combo / button)
function UV.BuildSetting(parent, st, descPanel)
	local function GetDisplayText()
		local prefix = ""

		-- If parentconvar or requireparentconvar is active, show prefix
		local parentName = st.parentconvar or st.requireparentconvar
		if parentName then
			local cv = GetConVar(parentName)
			if cv and cv:GetBool() then
				prefix = "|--- "
			end
		end

		return prefix .. language.GetPhrase(st.text)
	end
		
	-- if st is an information panel
	if st.type == "info" then
		local function ConvertDiscordFormatting(str)
			str = str:gsub("%*%*(.-)%*%*", "<font=UVSettingsFontSmall-Bold>%1</font>")
			str = str:gsub("(%s)%*(.-)%*", "<font=UVSettingsFontSmall-Italic> %2 </font>")
			str = str:gsub("^%*(.-)%*", "[i]%1[/i]")
			str = str:gsub("__(.-)__", "[u]%1[/u]")
			str = str:gsub("^#%s*(.-)\n", "<font=UVSettingsFontBig>%1</font>\n")
			str = str:gsub("\n#%s*(.-)\n", "\n<font=UVSettingsFontBig>%1</font>\n")
			return str
		end

		local p = vgui.Create("DPanel", parent)
		p:Dock(TOP)
		p:DockMargin(6, 6, 6, 2)
		p:SetPaintBackground(false)

		local rawText = language.GetPhrase(st.text or "") or ""
		rawText = ConvertDiscordFormatting(rawText)

		local mk = nil
		local lastWidth = 0

		-- function to rebuild markup when width changes
		function p:Rebuild()
			local w = self:GetWide()
			if w <= 0 then return end

			mk = markup.Parse("<font=UVSettingsFontSmall>" .. rawText .. "</font>", w - 20)

			self:SetTall(mk:GetHeight() + 20)
		end

		-- Called every time the panel is laid out
		function p:PerformLayout()
			local w = self:GetWide()
			if w ~= lastWidth then
				lastWidth = w
				self:Rebuild()
			end
		end

		p.Paint = function(self, w, h)
			surface.SetDrawColor(28, 28, 28, 150)
			surface.DrawRect(0, 0, w, h)

			if mk then
				mk:Draw(10, 10)
			end
		end

		return p
	end
	
	-- if st is a singular image
	if st.type == "image" then
		local p = vgui.Create("DPanel", parent)
		p:Dock(TOP)
		p:DockMargin(6, 6, 6, 2)

		-- Force 16:9 height based on available width
		p.PerformLayout = function(self, w, h)
			local newH = math.floor((w / 16) * 9)
			self:SetTall(newH)
		end

		local mat = Material(st.image or "", "smooth")

		p.Paint = function(self, w, h)
			surface.SetDrawColor(0, 0, 0, 200)
			surface.DrawRect(0, 0, w, h)

			if not mat or mat:IsError() then
				draw.SimpleText("Missing image", "DermaLarge", w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				return
			end

			-- Draw image fully scaled to panel (letterboxed)
			local iw, ih = mat:Width(), mat:Height()
			if iw == 0 or ih == 0 then return end

			local ratio = math.min(w / iw, h / ih)
			local fw, fh = iw * ratio, ih * ratio
			local x = (w - fw) * 0.5
			local y = (h - fh) * 0.5

			surface.SetMaterial(mat)
			surface.SetDrawColor(255, 255, 255)
			surface.DrawTexturedRect(x, y, fw, fh)
		end
		return p
	end


	-- if st is a header label
	if st.type == "label" then
		local p = vgui.Create("DPanel", parent)
		p:Dock(TOP)
		p:SetTall(36)
		p:DockMargin(6, 6, 6, 2)
		p.Paint = function(self, w, h)
			draw.RoundedBox(4, 0, 0, w, h, Color(100, 100, 100, 75))
			draw.SimpleText(st.text, "UVFont5UI", w*0.5, h*0.4, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		
		if st.desc then
			p.OnCursorEntered = function()
				if descPanel then
					descPanel.Text = st.text
					descPanel.Desc = st.desc or ""
				end
			end

			p.OnCursorExited = function()
				if descPanel then
					descPanel.Text = ""
					descPanel.Desc = ""
				end
			end
		end
		
		return p
	end

	---- boolean custom button ----
	if st.type == "bool" then
		local wrap = vgui.Create("DButton", parent)
		wrap:Dock(TOP)
		wrap:DockMargin(6, 4, 6, 4)
		wrap:SetTall(30)
		wrap:SetText("")
		wrap:SetCursor("hand")

		local cv = GetConVar(st.convar)
		local function getBool()
			if cv then return cv:GetBool() end
			return false
		end

		wrap.DoClick = function()
			if not cv then return end
			local new = getBool() and "0" or "1"
			RunConsoleCommand(st.convar, new)
		end

		wrap.OnCursorEntered = function()
			if descPanel then
				descPanel.Text = st.text
				descPanel.Desc = st.desc or ""
			end
		end

		wrap.OnCursorExited = function()
			if descPanel then
				descPanel.Text = ""
				descPanel.Desc = ""
			end
		end

		wrap.Paint = function(self, w, h)
			local enabled = getBool()
			local hovered = self:IsHovered()
			local bga = hovered and 200 * math.abs(math.sin(RealTime()*4)) or 125
			local bg = Color( 125, 125, 125, bga )
			
			if enabled then
				bg = Color( 58, 193, 0, bga )
			end
			
			-- background & text
			draw.RoundedBox(6, w - 34, 0, 30, h, bg)
			draw.SimpleText(GetDisplayText(), "UVMostWantedLeaderboardFont", 10, h/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

			-- icon right
			if enabled then
				surface.SetDrawColor(255,255,255, enabled and 255 or 200)
				surface.SetMaterial(enabled and matTick or matCross)
				surface.DrawTexturedRect(w - 34, 0, 30, 30)
			end
		end

		-- dynamic update when convar changes - simple timer check
		wrap.Think = function(self)
			-- nothing heavy; updates on click via convar toggle
		end

		return wrap
	end

	---- slider: label left, slider right ----
	if st.type == "slider" then
		local wrap = vgui.Create("DPanel", parent)
		wrap:Dock(TOP)
		wrap:DockMargin(6, 4, 6, 4)
		wrap:SetTall(36)
		wrap.Paint = function(self, w, h)
			draw.RoundedBox(6, w*0.675, 0, w*0.325, h, Color(0,0,0,120))
			draw.SimpleText(GetDisplayText(), "UVMostWantedLeaderboardFont", 10, h/2,
				color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end

		-------------------------------------------------------------
		-- Hover description functions
		-------------------------------------------------------------
		local function PushDesc()
			if descPanel then
				descPanel.Text = st.text
				descPanel.Desc = st.desc or ""
			end
		end
		local function PopDesc()
			if descPanel then
				descPanel.Text = ""
				descPanel.Desc = ""
			end
		end
		wrap.OnCursorEntered = PushDesc
		wrap.OnCursorExited  = PopDesc

		-------------------------------------------------------------
		-- Slider
		-------------------------------------------------------------
		local slider = vgui.Create("DNumSlider", wrap)
		slider:Dock(RIGHT)
		slider:SetWide(220)
		slider:DockMargin(8, 8, 6, 8)
		slider:SetMin(st.min or 0)
		slider:SetMax(st.max or 100)
		slider:SetDecimals(st.decimals or 0)
		slider:SetValue(st.min or 0)
		slider.Label:SetVisible(false)
		slider.TextArea:SetVisible(false)
		slider.OnCursorEntered = PushDesc
		slider.OnCursorExited  = PopDesc

		-------------------------------------------------------------
		-- Value box and confirm button container
		-------------------------------------------------------------
		local valPanel = vgui.Create("DPanel", wrap)
		valPanel:SetWide(84)
		valPanel:Dock(RIGHT)
		valPanel:DockMargin(4, 8, 4, 8)
		valPanel:SetPaintBackground(false)

		local valBox = vgui.Create("DTextEntry", valPanel)
		valBox:SetWide(60)
		valBox:SetPos(0,0)
		valBox:SetFont("UVMostWantedLeaderboardFont")
		valBox:SetTextColor(color_white)
		valBox:SetHighlightColor(Color(58,193,0))
		valBox:SetCursorColor(Color(58,193,0))
		valBox.Paint = function(self2, w, h)
			draw.RoundedBox(4, 0, 0, w, h, Color(30,30,30,200))
			self2:DrawTextEntryText(color_white, Color(58,193,0), color_white)
		end
		valBox.OnCursorEntered = PushDesc
		valBox.OnCursorExited  = PopDesc

		valBox.OnGetFocus = function()
			if IsValid(UV.SettingsFrame) then
				UV.SettingsFrame:SetKeyboardInputEnabled(true)
			end
		end

		valBox.OnLoseFocus = function()
			if IsValid(UV.SettingsFrame) then
				UV.SettingsFrame:SetKeyboardInputEnabled(false)
			end
		end

		local applyBtn = vgui.Create("DButton", valPanel)
		applyBtn:SetSize(20, valBox:GetTall())
		applyBtn:SetPos(valBox:GetWide() + 2,0)
		applyBtn:SetText("✔")
		applyBtn:SetVisible(false)
		applyBtn.Paint = function(self2, w, h)
			draw.RoundedBox(4,0,0,w,h,self2:IsHovered() and Color(60,180,60) or Color(45,140,45))
			draw.SimpleText("✔", "UVMostWantedLeaderboardFont", w/2,h/2,color_white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		end
		applyBtn.OnCursorEntered = PushDesc
		applyBtn.OnCursorExited  = PopDesc

		-------------------------------------------------------------
		-- Value tracking
		-------------------------------------------------------------
		local appliedValue = st.min or 0
		local pendingValue = appliedValue

		local function RoundValue(val)
			if st.decimals ~= nil then
				local factor = 10 ^ st.decimals
				return math.floor(val * factor + 0.5) / factor
			end
			return val
		end

		local function ApplyPendingValue()
			local val = RoundValue(pendingValue)
			appliedValue = val
			if st.convar then RunConsoleCommand(st.convar, tostring(val)) end
			if st.func then pcall(st.func, val) end
			valBox:SetText(string.format("%."..(st.decimals or 2).."f", val))
			applyBtn:SetVisible(false)
		end

		valBox:SetText(string.format("%."..slider:GetDecimals().."f", appliedValue))
		slider:SetValue(appliedValue)

		-------------------------------------------------------------
		-- Slider -> valBox sync
		-------------------------------------------------------------
		slider.OnValueChanged = function(_, val)
			pendingValue = val
			if IsValid(valBox) then
				valBox:SetText(string.format("%."..slider:GetDecimals().."f", val))
			end
			applyBtn:SetVisible(math.abs(pendingValue - appliedValue) > 0)
		end

		-------------------------------------------------------------
		-- valBox -> slider sync
		-------------------------------------------------------------
		valBox.OnTextChanged = function(self2)
			local v = tonumber(self2:GetValue())
			if not v then return end
			pendingValue = v
			slider:SetValue(v)
			applyBtn:SetVisible(math.abs(pendingValue - appliedValue) > 0)
		end

		valBox.OnEnter = ApplyPendingValue
		applyBtn.DoClick = ApplyPendingValue

		-------------------------------------------------------------
		-- Initialize from convar
		-------------------------------------------------------------
		if st.convar then
			local cv = GetConVar(st.convar)
			if cv then
				appliedValue = cv:GetFloat()
				pendingValue = appliedValue
				slider:SetValue(appliedValue)
				valBox:SetText(string.format("%."..slider:GetDecimals().."f", appliedValue))
			end
		end

		return wrap
	end

	---- combo: label left, dropdown right ----
	if st.type == "combo" then
		local wrap = vgui.Create("DPanel", parent)
		wrap:Dock(TOP)
		wrap:DockMargin(6, 4, 6, 4)
		wrap:SetTall(30)
		wrap.Paint = function(self, w, h)
			local hovered = self:IsHovered()
			local bga = hovered and 200 or 125
			local bg = Color( 125, 125, 125, 0 )
			
			if enabled then
				bg = Color( 58, 193, 0, bga )
			end
			
			draw.RoundedBox(6, 0, 0, w, h, bg)
			draw.SimpleText(GetDisplayText(), "UVMostWantedLeaderboardFont", 10, h/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end

		wrap.OnCursorEntered = function()
			if descPanel then
				descPanel.Text = st.text
				descPanel.Desc = st.desc or ""
			end
		end

		wrap.OnCursorExited = function()
			if descPanel then
				descPanel.Text = ""
				descPanel.Desc = ""
			end
		end

		local combo = vgui.Create("DComboBox", wrap)
		combo:Dock(RIGHT)
		combo:SetWide(220)
		combo:DockMargin(6, 6, 6, 6)

		-- Add choices first
		for _, entry in ipairs(st.content or {}) do
			combo:AddChoice(entry[1], entry[2])
		end

		-- Set selected value based on convar
		if st.convar then
			local cv = GetConVar(st.convar)
			if cv then
				local cur = cv:GetString()
				local found = false
				for _, v in ipairs(st.content or {}) do
					if tostring(v[2]) == tostring(cur) then
						combo:SetText(v[1])
						found = true
						break
					end
				end
				if not found then
					combo:SetText(st.text)
				end
			end
		else
			combo:SetText(st.text)
		end

		combo.OnSelect = function(_, _, val, data)
			if st.convar then
				RunConsoleCommand(st.convar, tostring(data))
				combo:SetText(val)
			end
			if st.func then st.func(combo) end
		end

		combo.OnCursorEntered = function()
			if descPanel then
				descPanel.Text = st.text
				descPanel.Desc = st.desc or ""
			end
		end

		combo.OnCursorExited = function()
			if descPanel then
				descPanel.Text = ""
				descPanel.Desc = ""
			end
		end

		return wrap
	end

	---- button ----
	if st.type == "button" then
		local btn = vgui.Create("DButton", parent)
		btn:Dock(TOP)
		btn:DockMargin(6, 6, 6, 6)
		btn:SetTall(30)
		btn:SetText("")
		btn.Paint = function(self, w, h)
			local hovered = self:IsHovered()
			local bga = hovered and 200 * math.abs(math.sin(RealTime()*4)) or 125
			local bg = Color( 125, 125, 125, bga )

			-- background & text
			draw.RoundedBox(12, w*0.1, 0, w*0.8, h, bg)
			draw.SimpleText(GetDisplayText(), "UVMostWantedLeaderboardFont", w*0.5, h*0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		btn.DoClick = function(self)
			if st.func then st.func(self) end
			if st.convar and not st.func then
				RunConsoleCommand(st.convar)
			end
		end
		btn.OnCursorEntered = function()
			if descPanel then
				descPanel.Text = st.text
				descPanel.Desc = st.desc or ""
			end
		end
		btn.OnCursorExited = function()
			if descPanel then
				descPanel.Text = ""
				descPanel.Desc = ""
			end
		end

		return btn
	end

	---- color remains as basic DColorMixer or DColorButton (user requested keep as-is) ----
	if st.type == "color" or st.type == "coloralpha" then
		local p = vgui.Create("DPanel", parent)
		p:Dock(TOP)
		p:DockMargin(6, 6, 6, 6)
		p:SetTall(120)

		local mixer = vgui.Create("DColorMixer", p)
		mixer:Dock(FILL)
		-- hooking into convars for colors is left as an exercise for your addon specifics
		mixer.OnCursorEntered = function()
			if descPanel then
				descPanel.Text = st.text
				descPanel.Desc = st.desc or ""
			end
		end

		mixer.OnCursorExited = function()
			if descPanel then
				descPanel.Text = ""
				descPanel.Desc = ""
			end
		end

		return p
	end

	---- keybind button ----
	-- if st.type == "keybind" then
		-- local wrap = vgui.Create("DButton", parent)
		-- wrap:Dock(TOP)
		-- wrap:DockMargin(6, 4, 6, 4)
		-- wrap:SetTall(30)
		-- wrap:SetText("")
		-- wrap:SetCursor("hand")
		-- wrap:SetKeyboardInputEnabled(true)
		-- wrap:SetMouseInputEnabled(true)

		-- local data = KeybindManager.keybinds[st.slot]
		-- local cv = GetConVar(data.convar)
		-- wrap.DisplayText = cv and string.upper(input.GetKeyName(cv:GetInt()) or "NONE") or "NONE"

		-- KeyBindButtons[st.slot] = { data.convar, wrap }

		-- wrap.Paint = function(self, w, h)
			-- local hovered = self:IsHovered()
			-- local bga = hovered and 200 * math.abs(math.sin(RealTime()*4)) or 125
			-- local bg = Color(125, 125, 125, bga)

			-- draw.RoundedBox(6, w*0.955, 0, w*0.045, h, bg)
			-- draw.SimpleText(st.text, "UVMostWantedLeaderboardFont", 10, h/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			-- draw.SimpleText(self.DisplayText, "UVMostWantedLeaderboardFont", w - 10, h/2, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		-- end

		-- wrap.OnCursorEntered = function()
			-- if descPanel then
				-- descPanel.Text = st.text
				-- descPanel.Desc = st.desc or ""
			-- end
		-- end
		-- wrap.OnCursorExited = function()
			-- if descPanel then
				-- descPanel.Text = ""
				-- descPanel.Desc = ""
			-- end
		-- end

		-- wrap.DoClick = function()
			-- if KeybindManager.waitingForInput then return end
			-- KeybindManager.waitingForInput = st.slot
			-- wrap.DisplayText = "PRESS ANY BUTTON"
			-- wrap:MakePopup()
		-- end

		-- wrap.OnKeyCodePressed = function(self, key)
			-- if KeybindManager.waitingForInput ~= st.slot then return end
			-- self.DisplayText = string.upper(input.GetKeyName(key))
			-- net.Start("UVPTKeybindRequest")
			-- net.WriteInt(st.slot, 16)
			-- net.WriteInt(key, 16)
			-- net.SendToServer()
			-- KeybindManager.waitingForInput = false
		-- end

		-- wrap.OnMousePressed = function(self, mouseCode)
			-- if KeybindManager.waitingForInput ~= st.slot then return end
			-- self.DisplayText = string.upper(input.GetKeyName(mouseCode))
			-- net.Start("UVPTKeybindRequest")
			-- net.WriteInt(st.slot, 16)
			-- net.WriteInt(mouseCode, 16)
			-- net.SendToServer()
			-- KeybindManager.waitingForInput = false
		-- end

		-- return wrap
	-- end

	-- fallback: do nothing
	return nil
end

UV_WrapCache = UV_WrapCache or {}

function UV_WrapText(text, font, maxwidth)
	local cacheKey = font .. "|" .. tostring(maxwidth) .. "|" .. text

	-- return cached result if it exists
	local cached = UV_WrapCache[cacheKey]
	if cached then
		return cached
	end

	-- compute wrapped lines
	surface.SetFont(font)

	local lines = {}
	local curline = ""

	local words = string.Explode(" ", text)

	local function utf8_chars(str)
		return string.gmatch(str, "[%z\1-\127\194-\244][\128-\191]*")
	end

	for _, word in ipairs(words) do
		local test = (curline == "" and word) or (curline .. " " .. word)
		local w = surface.GetTextSize(test)

		if w > maxwidth then
			if surface.GetTextSize(word) > maxwidth then
				for char in utf8_chars(word) do
					local test2 = curline .. char
					if surface.GetTextSize(test2) > maxwidth then
						if curline ~= "" then
							table.insert(lines, curline)
						end
						curline = char
					else
						curline = test2
					end
				end
			else
				if curline ~= "" then
					table.insert(lines, curline)
				end
				curline = word
			end
		else
			curline = test
		end
	end

	if curline ~= "" then
		table.insert(lines, curline)
	end

	-- store result
	UV_WrapCache[cacheKey] = lines
	return lines
end

-- Helper to open menus safely
function UVMenu.OpenMenu(menuFunc)
    if UVMenu.CurrentMenu and IsValid(UVMenu.CurrentMenu) then
        -- Close current menu first
        UVMenu.CloseCurrentMenu()
        -- Delay opening new menu to allow closing animation to start
        timer.Simple(0.25, function()
            if menuFunc then
                menuFunc()
                -- Update CurrentMenu to the newly created frame
                UVMenu.CurrentMenu = UV.SettingsFrame
            end
        end)
        return
    end

    -- Open menu immediately if nothing is open
    if menuFunc then
        menuFunc()
        UVMenu.CurrentMenu = UV.SettingsFrame
    end
end

-- Close the currently open menu with animation
function UVMenu.CloseCurrentMenu()
    local frame = UVMenu.CurrentMenu or UV.SettingsFrame
    if not IsValid(frame) or frame._closing then return end

    frame._closing = true
    frame._closeStart = CurTime()
    frame._closeFadeDur = 0.1
    frame._closeShrinkDur = 0.2
    frame._closeShrinkStart = frame._closeStart + frame._closeFadeDur * 0.5

    UVMenu.CurrentMenu = nil
end

-- Opens a UVMenu menu
function UVMenu:Open(menu)
    local CurrentMenu = menu or {}
    local Name = CurrentMenu.Name or "#uv.settings.unitvehicles"
    local Width = CurrentMenu.Width or math.max(800, ScrW() * 0.9)
    local Height = CurrentMenu.Height or math.max(480, ScrH() * 0.66)
    local ShowDesc = CurrentMenu.Description == true
    local Tabs = CurrentMenu.Tabs or {}
    local UnfocusClose = CurrentMenu.UnfocusClose == true

    if IsValid(UV.SettingsFrame) then UV.SettingsFrame:Remove() end
    gui.EnableScreenClicker(true)

    local sw, sh = ScrW(), ScrH()
    local fw, fh = Width, Height
    local fx, fy = (sw - fw) * 0.5, (sh - fh) * 0.5
    local watchedConvars = {}

    local frame = vgui.Create("DFrame")
    UV.SettingsFrame = frame
    frame:SetSize(0, 0)
    frame:SetPos(fx + fw * 0.5, fy + fh * 0.5)
    frame:SetTitle("")
    frame:ShowCloseButton(false)
    frame:SetDraggable(false)
    frame:MakePopup()
    frame:SetKeyboardInputEnabled(false)

    frame.TargetWidth = fw
    frame.TargetHeight = fh

    local animStart = CurTime()
    local animDur = 0.2
    local primaryFadeStart = animStart + animDur * 0.5
    local primaryFadeDur = 0.25
    local secondaryFadeStart = animStart + animDur * 0.5
    local secondaryFadeDur = 0.25

    frame._open_animStart = animStart
    frame._open_animDur = animDur
    frame._open_primaryFadeStart = primaryFadeStart
    frame._open_primaryFadeEnd = primaryFadeStart + primaryFadeDur
    frame._open_secondaryFadeStart = secondaryFadeStart
    frame._open_secondaryFadeEnd = secondaryFadeStart + secondaryFadeDur
    frame._closing = false

    frame.TitleAlpha = 0

    -- Right description panel
    local descPanel
    if ShowDesc then
        descPanel = vgui.Create("DPanel", frame)
        descPanel:Dock(RIGHT)
        descPanel:SetWide(math.Clamp(fw * 0.25, 220, 380))
        descPanel.Paint = function(self, w, h)
            local a = self:GetAlpha()
            surface.SetDrawColor(28, 28, 28, math.floor(150 * (a / 255)))
            surface.DrawRect(0, 0, w, h)

            if self.Text and a > 5 then
                local font = "UVMostWantedLeaderboardFont2"
                local color = Color(255, 255, 255, a)
                local xPadding, yPadding = 10, 10
                local wrapWidth = w - xPadding * 2
                local yOffset = yPadding

                surface.SetFont(font)
                local desc = language.GetPhrase(self.Desc or "") or ""

                local paragraphs = string.Split(desc, "\n")
                for _, paragraph in ipairs(paragraphs) do
                    if paragraph == "" then
                        local _, th = surface.GetTextSize("A")
                        yOffset = yOffset + th
                    else
                        local wrapped = UV_WrapText(paragraph, font, wrapWidth)
                        for _, line in ipairs(wrapped) do
                            draw.DrawText(line, font, xPadding, yOffset, color, TEXT_ALIGN_LEFT)
                            local _, th = surface.GetTextSize(line)
                            yOffset = yOffset + th
                        end
                    end
                end
            end
        end
        descPanel.Text = ""
        descPanel.Desc = ""
        descPanel:SetAlpha(0)
    end

    -- Center scroll panel
    local center = vgui.Create("DScrollPanel", frame)
    center:Dock(FILL)
    center:DockMargin(8, 8, 8, 8)
    center:SetAlpha(0)

    -- Left tabs panel (only if >1 tab)
    local tabsPanel
    if #Tabs > 1 then
        tabsPanel = vgui.Create("DPanel", frame)
        tabsPanel:Dock(LEFT)
        tabsPanel:SetWide(ScrW()*0.15)
        tabsPanel.Paint = function() end
        tabsPanel:SetAlpha(0)
    end

    local closeBtn = vgui.Create("DButton", frame)
    closeBtn:SetSize(20, 20)
    closeBtn:SetText("")
    closeBtn:SetFont("DermaDefaultBold")
    closeBtn.DoClick = function()
        UVMenu.CloseCurrentMenu()
    end
    closeBtn.Paint = function(self, w, h)
        local hovered = self:IsHovered()
        local bg = hovered and Color(200, 60, 60, self:GetAlpha()) or Color(140, 50, 50, self:GetAlpha())
        draw.RoundedBox(4, 0, 0, w, h, bg)
        draw.SimpleText("X", "DermaDefaultBold", w / 2, h / 2, Color(255, 255, 255, self:GetAlpha()), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    closeBtn:SetAlpha(0)

    local primaryGroup = {closeBtn}
    local secondaryGroup = {center}
    if tabsPanel then table.insert(secondaryGroup, tabsPanel) end
    if descPanel then table.insert(secondaryGroup, descPanel) end

    local CURRENT_TAB = 1

    -- Build tab content
    local function BuildTab(tabIndex)
        center.CurrentTabIndex = tabIndex
        center:Clear()
        if descPanel then
            descPanel.Text = ""
            descPanel.Desc = ""
        end

        local tab = Tabs[tabIndex]
        if not tab then return end

        local title = vgui.Create("DLabel", center)
        title:SetText("")
        title:Dock(TOP)
        title:DockMargin(6, 6, 6, 12)
        title:SetTall(36)

        title.Paint = function(self, w, h)
            draw.SimpleText(tab.TabName or ("Tab " .. tostring(tabIndex)), "UVFont5UI", w * 0.5, h * 0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        watchedConvars = {} -- reset
        for k2, entry in ipairs(tab) do
            if istable(entry) and entry.type then
                if entry.parentconvar then watchedConvars[entry.parentconvar] = true end
                if entry.requireparentconvar then watchedConvars[entry.requireparentconvar] = true end
            end
        end

        for k2, entry in ipairs(tab) do
            if istable(entry) and entry.type then
                local pnl = UV.BuildSetting(center, entry, descPanel)
                if IsValid(pnl) then
                    pnl:SetVisible(UV.ShouldDrawSetting(entry))
                    pnl:SetAlpha(0)
                end
            end
        end
    end

    local lastValues = {}

    local function SetGroupAlpha(group, a)
        for _, pnl in ipairs(group) do
            if IsValid(pnl) and pnl.SetAlpha then pnl:SetAlpha(a) end
        end
    end

    local function SetCenterChildrenAlpha(a)
        for _, child in ipairs(center:GetChildren()) do
            if IsValid(child) and child.SetAlpha then
                child:SetAlpha(a)
            end
        end
    end

    local function SetAlphaRecursive(panel, a)
        if not IsValid(panel) then return end
        if panel.SetAlpha then panel:SetAlpha(a) end
        for _, child in ipairs(panel:GetChildren()) do
            SetAlphaRecursive(child, a)
        end
    end

    frame.Think = function(self)
        if not self._closing then
            local elapsed = CurTime() - self._open_animStart
            local p = math.Clamp(elapsed / self._open_animDur, 0, 1)

            local w = Lerp(p, 0, self.TargetWidth)
            local h = Lerp(p, 0, self.TargetHeight)
            local x = fx + (fw * 0.5) - (w * 0.5)
            local y = fy + (fh * 0.5) - (h * 0.5)
            self:SetSize(w, h)
            self:SetPos(x, y)

            closeBtn:SetPos(math.max(self:GetWide() - 36, 8), 8)

            local primaryA = 0
            if CurTime() >= self._open_primaryFadeStart then
                primaryA = math.Clamp((CurTime() - self._open_primaryFadeStart) / (self._open_primaryFadeEnd - self._open_primaryFadeStart), 0, 1) * 255
            end
            self.TitleAlpha = primaryA
            SetGroupAlpha(primaryGroup, primaryA)

            local secondaryA = 0
            if CurTime() >= self._open_secondaryFadeStart then
                secondaryA = math.Clamp((CurTime() - self._open_secondaryFadeStart) / (self._open_secondaryFadeEnd - self._open_secondaryFadeStart), 0, 1) * 255
            end
            SetGroupAlpha(secondaryGroup, secondaryA)
            SetAlphaRecursive(center, secondaryA)

            -- unfocus auto-close
            if UnfocusClose and input.IsMouseDown(MOUSE_LEFT) then
                local mx, my = gui.MousePos()
                if mx and my then
                    local fx2, fy2 = self:GetPos()
                    local fw2, fh2 = self:GetSize()
                    if mx < fx2 or mx > fx2 + fw2 or my < fy2 or my > fy2 + fh2 then
                        timer.Simple(0, function()
                            if IsValid(self) then UVMenu.CloseCurrentMenu() end
                        end)
                    end
                end
            end

            local shouldRefresh = false
            for cvName in pairs(watchedConvars) do
                local cv = GetConVar(cvName)
                if cv then
                    local val = cv:GetBool()
                    if lastValues[cvName] ~= val then
                        lastValues[cvName] = val
                        shouldRefresh = true
                    end
                end
            end

            if shouldRefresh then
                BuildTab(center.CurrentTabIndex)
            end
        else
            local now = CurTime()
            local fadeStart = self._closeStart
            local fadeEnd = fadeStart + self._closeFadeDur
            local shrinkStart = self._closeShrinkStart
            local shrinkEnd = shrinkStart + self._closeShrinkDur

            local fadeT = 0
            if now <= fadeStart then
                fadeT = 0
            elseif now >= fadeEnd then
                fadeT = 1
            else
                fadeT = (now - fadeStart) / (fadeEnd - fadeStart)
            end
            local invFade = 1 - fadeT
            local fadeA = math.floor(invFade * 255)

            self.TitleAlpha = fadeA
            SetGroupAlpha(primaryGroup, fadeA)
            SetGroupAlpha(secondaryGroup, fadeA)
            SetCenterChildrenAlpha(fadeA)

            local shrinkT = 0
            if now <= shrinkStart then
                shrinkT = 0
            elseif now >= shrinkEnd then
                shrinkT = 1
            else
                shrinkT = (now - shrinkStart) / (shrinkEnd - shrinkStart)
            end
            local w = Lerp(shrinkT, self.TargetWidth, 0)
            local h = Lerp(shrinkT, self.TargetHeight, 0)
            local x = fx + (fw * 0.5) - (w * 0.5)
            local y = fy + (fh * 0.5) - (h * 0.5)
            self:SetSize(w, h)
            self:SetPos(x, y)

            if now >= math.max(fadeEnd, shrinkEnd) then
                if IsValid(self) then
                    self:Remove()
                end
                gui.EnableScreenClicker(false)
                UV.SettingsFrame = nil
            end
        end
    end

    frame.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 25, 245))
        local titleColor = Color(255, 255, 255, math.Clamp(math.floor(self.TitleAlpha), 0, 255))
        draw.SimpleText(Name, "UVFont5UI", w * 0.01, h * 0.025, titleColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    -- Build tabs if more than 1
    local TAB_START_OFFSET = 15
    local TAB_BUTTON_HEIGHT = 64
    local TAB_BUTTON_PADDING = 0
    local TAB_SIDE_PADDING = 6
    local TAB_CORNER_RADIUS = 4

    if tabsPanel then
        tabsPanel:DockPadding(0, TAB_START_OFFSET, 0, 0)
        for i, tab in ipairs(Tabs) do
            if not UV.PlayerCanSeeSetting(tab) then continue end

            local btn = vgui.Create("DButton", tabsPanel)
            btn:Dock(TOP)
            btn:DockMargin(0, 0, 0, TAB_BUTTON_PADDING)
            btn:SetTall(TAB_BUTTON_HEIGHT)
            btn:SetText("")

            btn.Paint = function(self, w, h)
                local isSelected = (CURRENT_TAB == i)
                local hovered = self:IsHovered()
                local bga = hovered and 175 or 75
                local bg = isSelected and Color(255, 255, 255, bga) or Color(125, 125, 125, bga)
                draw.RoundedBox(TAB_CORNER_RADIUS, TAB_SIDE_PADDING, 4, w - TAB_SIDE_PADDING * 2, h - 8, bg)

                draw.SimpleText(tab.TabName or "Tab", "UVMostWantedLeaderboardFont", w * 0.21, h*0.5, Color(255, 255, 255, self:GetAlpha()), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

                if tab.Icon then
                    local mat = Material(tab.Icon, "smooth")
                    local iconSize = h * 0.75
                    local iconX = TAB_SIDE_PADDING + 2
                    local iconY = (h - iconSize) / 2
                    surface.SetDrawColor(255, 255, 255, self:GetAlpha())
                    surface.SetMaterial(mat)
                    surface.DrawTexturedRect(iconX, iconY, iconSize, iconSize)
                end
            end

            btn.DoClick = function()
				if tab.func then tab.func(self) return end
                CURRENT_TAB = i
                BuildTab(i)
                tabsPanel:InvalidateLayout(true)
            end

            if i == 1 then BuildTab(1) end
        end
    else
        -- Only 1 tab → just build that tab directly
        BuildTab(1)
    end

    frame.OnRemove = function()
        gui.EnableScreenClicker(false)
        if UV.SettingsFrame == frame then UV.SettingsFrame = nil end
    end
end

-- Main Menu
 -- { type = "button", text = "Open Menu 2", func = function()
		-- UVMenu.OpenMenu(UVMenu.Test2)
	-- end },

UVMenu.Main = function()
	UVMenu.CurrentMenu = UVMenu:Open({
		Name = "#uv.settings.unitvehicles",
		Width = ScrW() * 0.8,
		Height = ScrH() * 0.7,
		Description = true,
		UnfocusClose = true,
		Tabs = {
			{ TabName = "#uv.settings.tab.welcome", Icon = "unitvehicles/icons_settings/info.png",
				{ type = "label", text = "#uv.settings.quick", desc = "#uv.settings.quick.desc" },
				{ type = "combo", text = "#uv.settings.uistyle.main", desc = "uv.settings.uistyle.main.desc", convar = "unitvehicle_hudtype_main", content = {
						{ "Crash Time - Undercover", "ctu"} ,
						{ "NFS Most Wanted", "mostwanted"} ,
						{ "NFS Carbon", "carbon"} ,
						{ "NFS Underground", "underground"} ,
						{ "NFS Underground 2", "underground2"} ,
						{ "NFS Undercover", "undercover"} ,
						{ "NFS ProStreet", "prostreet"} ,
						{ "NFS World", "world"} ,
						{ "#uv.uistyle.original", "original"} ,
						{ "#uv.uistyle.none", "" }
					},
				},
				{ type = "combo", text = "#uv.settings.audio.uvtrax.profile", desc = "uv.settings.audio.uvtrax.profile.desc", convar = "unitvehicle_racetheme", content = uvtraxcontent },
				{ type = "button", text = "#uv.settings.pm.ai.spawnas", convar = "uv_spawn_as_unit", func = 
				function(self2)
					RunConsoleCommand("uv_spawn_as_unit")
					UVMenu.CloseCurrentMenu()
				end
				},
				
				{ type = "label", text = "#uv.settings.pnotes" },
				{ type = "info", text = UV.PNotes },
				{ type = "image", image = "unitvehicles/icons_settings/latestpatch.png" },
			},
			{ TabName = "#uv.settings.pm", Icon = "unitvehicles/icons/cops_icon.png",
				{ type = "button", text = "#uv.settings.pm.ai.spawnas", convar = "uv_spawn_as_unit", func = 
				function(self2)
					RunConsoleCommand("uv_spawn_as_unit")
					UVMenu.CloseCurrentMenu()
				end
				},

				{ type = "label", text = "#uv.settings.server", sv = true },
				-- { type = "button", text = "#uv.settings.pm.pursuit.toggle", desc = "uv.settings.pm.pursuit.toggle.desc", convar = "uv_startpursuit", sv = true },
				{ type = "button", text = "#uv.settings.pm.pursuit.start", desc = "uv.settings.pm.pursuit.start.desc", convar = "uv_startpursuit", sv = true },
				{ type = "button", text = "#uv.settings.pm.pursuit.stop", desc = "uv.settings.pm.pursuit.stop.desc", convar = "uv_stoppursuit", sv = true },
				{ type = "slider", text = "#uv.settings.pm.heatlevel", desc = "uv.settings.pm.heatlevel.desc", convar = "uv_setheat", min = 1, max = MAX_HEAT_LEVEL, decimals = 0, sv = true },
				
				{ type = "button", text = "#uv.settings.pm.ai.spawn", convar = "uv_spawnvehicles", sv = true },
				{ type = "button", text = "#uv.settings.pm.ai.despawn", convar = "uv_despawnvehicles", sv = true },
				
				{ type = "label", text = "#uv.settings.pm.misc", sv = true },
				{ type = "button", text = "#uv.settings.clearbounty", convar = "uv_clearbounty", sv = true },
				{ type = "button", text = "#uv.settings.print.wantedtable", convar = "uv_wantedtable", sv = true },
			},
			{ TabName = "#uv.settings.tab.addons", Icon = "unitvehicles/icons/(9)T_UI_PlayerRacer_Large_Icon.png", sv = true,
				{ type = "label", text = "#uv.settings.addon.builtin", desc = "uv.settings.addon.builtin.desc", sv = true },
				{ type = "bool", text = "#uv.settings.addon.vcmod.els", desc = "uv.settings.addon.vcmod.els.desc", convar = "unitvehicle_vcmodelspriority", sv = true },
			},
			{ TabName = "#uv.settings.tab.faq", Icon = "unitvehicles/icons_settings/question.png",
				{ type = "info", text = UV.FAQ[1] },
				{ type = "info", text = UV.FAQ[2] },
				{ type = "info", text = UV.FAQ[3] },
				{ type = "info", text = UV.FAQ[4] },
				{ type = "info", text = UV.FAQ[5] },
				{ type = "info", text = UV.FAQ[6] },
				{ type = "info", text = UV.FAQ[7] },
				{ type = "info", text = UV.FAQ[8] },
				{ type = "info", text = UV.FAQ[9] },
				{ type = "info", text = UV.FAQ[10] },
				{ type = "info", text = UV.FAQ[11] },
				{ type = "info", text = UV.FAQ[12] },
				{ type = "info", text = UV.FAQ[13] },
				{ type = "info", text = UV.FAQ[14] },
				{ type = "info", text = UV.FAQ[15] },
				{ type = "info", text = UV.FAQ[16] },
				{ type = "info", text = UV.FAQ[17] },
				{ type = "info", text = UV.FAQ[18] },
				{ type = "info", text = UV.FAQ[19] },
			},
			{ TabName = "#uv.settings.tab.settings", Icon = "unitvehicles/icons_settings/options.png", func = function()
					UVMenu.OpenMenu(UVMenu.Settings)
				end,
				{ type = "label", text = "#uv.settings.addon.builtin" },
			},
		}
	})
end

if CLIENT then
	-- Create the desktop icon entry (clicking it runs console command which opens our menu)
	list.Set("DesktopWindows", "UnitVehiclesMenu", {
		title = "#uv.settings.unitvehicles",
		icon  = "unitvehicles/icons/MILESTONE_OUTRUN_PURSUITS_WON.png",
		init = function(icon, window)
			RunConsoleCommand("unitvehicles_menu")
		end
	})
end

concommand.Add("unitvehicles_menu", function()
	UVMenu.OpenMenu(UVMenu.Main)
end)
