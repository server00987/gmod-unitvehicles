UV = UV or {}
UVMenu = UVMenu or {}
UV.SettingsTable = UV.SettingsTable or {}

-- Patch Notes & Current Version -- Change this whenever a new update is releasing!
UV.CurVersion = "v0.40.0" --MAJOR.MINOR.PATCH
UV.PNotes = [[
# -- [ Update v0.40.0 ] --

**The final stretch!**
We're now preparing Unit Vehicles for its v1.0 release. There's lots to do still, and we hope to keep receiving feedback until then.

**New Features**
- Added the *UVPD Chevrolet Corvette Grand Sport (C7) Police Cruiser*
- Added the ability to reset in freeroam and in pursuits
- AI Racers and Units will no longer rotate while mid-air
  |-- Only applies to Glide vehicles
- The UV Menu and all fonts will now scale properly on all resolutions
- Added the ability for the community to create custom HUDs
 |-- These are automatically added to the UV Menu Settings
- Added Polish translations
  
**UV Menu**
- Added new *AI Racer Manager*, *Traffic Manager* and *Credits* tabs
  |-- Moved all of the "Manager: AI Racers" and "Manager: Traffic" settings to these tabs
- Added new *Keybinds* tab inside the Settings instance
- Added a *Timer* variable in the UV Menu, applied to the *Totaled* and *Race Invite* menus
- Added a custom dropdown menu in the UV Menu, used by the *UVTrax Profile* and *HUD Types*
- Texts on all options will now scale and split properly
- Rewrote the entire *FAQ* section

**Changes**
- Pursuit Breakers will now always trigger a call response
- The *Vehicle Override* feature from the "Manager: AI Racers" tool (now present in the UV Menu) now supports infinite amount of racers
- The Air Unit will now create dust effects depending on what surface it hovers over
- Relentless AI Units will no longer know player hiding spots
- UV Menu: The *FAQ* tab now sends you to a separate menu instance with categorized information
- UV Menu: The *Addons* tab was moved to UV Settings
- UV Menu: The *Freeze Cam* option no longer appears in the UV Menu while in a Multiplayer session
- Updated various default Cop Chatter lines
- Updated localizations

**Fixes**
- Fixed that AI Racers sometimes steered weirdly after entering another lap
- Fixed that the Air Unit's spotlight wasn't always active
- Fixed that Units still respawned when the Backup timer was active
- Fixed that roadblocks sometimes spawned when a call response was triggered
- Fixed that the EMP Pursuit Tech did not have a localized string on the HUD
- Fixed that the Busted debrief did not always trigger if multiple racers were busted in a short time
- Fixed that the Race Options caused errors in Multiplayer
- Fixed that the Race Invite caused an error when clicking outside of its window, causing it to close prematurely
- Fixed that invalid Subtitles sent the Pursuit Tech notification upwards
- Fixed that clicking on a dropdown option outside the UV Menu, the menu would close if it was set to "Close on Unfocus"
- Fixed a lag spike when pursuit music plays for the first time
- Fixed that Pursuit Breakers sometimes did not wreck Units
]]

-- Sounds Table
UVMenu.Sounds = {
    ["MW"] = {
        menuopen = "uvui/mw/fe_common_mb [8].wav",
        menuclose = "uvui/mw/fe_common_mb [9].wav",
        hover = "uvui/mw/fe_common_mb [1].wav",
        hovertab = "uvui/mw/fe_common_mb [2].wav",
        click = "uvui/mw/fe_common_mb [8].wav",
        clickopen = "uvui/mw/fe_common_mb [3].wav",
        clickback = "uvui/mw/fe_common_mb [4].wav",
        confirm = "uvui/mw/fe_common_mb [5].wav"
    },
    ["Carbon"] = {
        menuopen = "uvui/carbon/fe_mb [1].wav",
        menuclose = "uvui/carbon/fe_common_mb [10].wav",
        hover = "uvui/carbon/fe_common_mb [1].wav",
        hovertab = "uvui/carbon/fe_common_mb [2].wav",
        click = "uvui/carbon/fe_common_mb [8].wav",
        clickopen = "uvui/carbon/fe_common_mb [5].wav",
        clickback = "uvui/carbon/fe_common_mb [6].wav",
        confirm = "uvui/carbon/fe_common_mb [5].wav"
    },
}

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

-- Store all menus globally
UVMenu.Menus = UVMenu.Menus or {}

-- [[ Start of Menu ConVars ]] --
-- Sounds
CreateClientConVar("uvmenu_sound_enabled", 1, true, false)
CreateClientConVar("uvmenu_sound_set", "MW", true, false)

-- Background
CreateClientConVar("uvmenu_hide_description", 0, true, false)

CreateClientConVar("uvmenu_open_speed", 0.25, true, false)
CreateClientConVar("uvmenu_close_speed", 0.25, true, false)

-- Background colour
CreateClientConVar("uvmenu_col_bg_r", 25, true, false)
CreateClientConVar("uvmenu_col_bg_g", 25, true, false)
CreateClientConVar("uvmenu_col_bg_b", 25, true, false)
CreateClientConVar("uvmenu_col_bg_a", 245, true, false)

-- Description panel colour
CreateClientConVar("uvmenu_col_desc_r", 28, true, false)
CreateClientConVar("uvmenu_col_desc_g", 28, true, false)
CreateClientConVar("uvmenu_col_desc_b", 28, true, false)
CreateClientConVar("uvmenu_col_desc_a", 150, true, false)

-- Tabs sidebar colour
CreateClientConVar("uvmenu_col_tabs_r", 0, true, false)
CreateClientConVar("uvmenu_col_tabs_g", 0, true, false)
CreateClientConVar("uvmenu_col_tabs_b", 0, true, false)
CreateClientConVar("uvmenu_col_tabs_a", 0,  true, false)

-- Tab button (active/hover/default)
CreateClientConVar("uvmenu_col_tab_default_r", 125, true, false)
CreateClientConVar("uvmenu_col_tab_default_g", 125, true, false)
CreateClientConVar("uvmenu_col_tab_default_b", 125, true, false)

CreateClientConVar("uvmenu_col_tab_active_r", 255, true, false)
CreateClientConVar("uvmenu_col_tab_active_g", 255, true, false)
CreateClientConVar("uvmenu_col_tab_active_b", 255, true, false)

CreateClientConVar("uvmenu_col_tab_hover_r", 255, true, false)
CreateClientConVar("uvmenu_col_tab_hover_g", 255, true, false)
CreateClientConVar("uvmenu_col_tab_hover_b", 255, true, false)

-- Label colour
CreateClientConVar("uvmenu_col_label_r", 100, true, false)
CreateClientConVar("uvmenu_col_label_g", 100, true, false)
CreateClientConVar("uvmenu_col_label_b", 100, true, false)
CreateClientConVar("uvmenu_col_label_a", 75,  true, false)

-- Bool colour
CreateClientConVar("uvmenu_col_bool_r", 125, true, false)
CreateClientConVar("uvmenu_col_bool_g", 125, true, false)
CreateClientConVar("uvmenu_col_bool_b", 125, true, false)
CreateClientConVar("uvmenu_col_bool_a", 200, true, false)

CreateClientConVar("uvmenu_col_bool_active_r", 58, true, false)
CreateClientConVar("uvmenu_col_bool_active_g", 193, true, false)
CreateClientConVar("uvmenu_col_bool_active_b", 0, true, false)

-- Bool colour
CreateClientConVar("uvmenu_col_button_r", 125, true, false)
CreateClientConVar("uvmenu_col_button_g", 125, true, false)
CreateClientConVar("uvmenu_col_button_b", 125, true, false)
CreateClientConVar("uvmenu_col_button_a", 125, true, false)

CreateClientConVar("uvmenu_col_button_hover_r", 125, true, false)
CreateClientConVar("uvmenu_col_button_hover_g", 125, true, false)
CreateClientConVar("uvmenu_col_button_hover_b", 125, true, false)
CreateClientConVar("uvmenu_col_button_hover_a", 200, true, false)
-- [[ End of Color ConVars ]] --

function UV.PlayerCanSeeSetting(st)
	if st.sp and not game.SinglePlayer() then
		return false
	end
	
	if st.sv or st.admin then
		local ply = LocalPlayer()
		if not IsValid(ply) then return false end
		if not ply:IsAdmin() and not ply:IsSuperAdmin() then
		-- if ply:IsAdmin() and ply:IsSuperAdmin() then -- Reverse for debugging
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
	
	if st.cond and st.cond() == false then return false end

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

-- Custom Dropdown panel
local UVDropdown = {}

function UVDropdown:Init()
	self:SetTall(UV.ScaleH(26))
	self:SetCursor("hand")

	self.Open = false
	self.Value = nil
	self.Choices = {}

	self.Button = vgui.Create("DButton", self)
	self.Button:Dock(FILL)
	self.Button:SetText("")
	self.Button.DoClick = function()
		self:Toggle()
	end

	self.Button.Paint = function(btn, w, h)
		draw.SimpleText( self.Value or "???", "UVMostWantedLeaderboardFont2", 12, h * 0.45, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		draw.SimpleText( self.Open and "▲" or "▼", "UVMostWantedLeaderboardFont2", w - 14, h * 0.45, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
end

function UVDropdown:AddChoice(text, data)
	table.insert(self.Choices, {text = text, data = data})
end

function UVDropdown:SetValue(text, data)
	self.Value = text
	self.Data = data
end

function UVDropdown:Toggle()
	if self.Open then
		self:CloseList()
	else
		self:OpenList()
	end
end

function UVDropdown:OpenList()
	if IsValid(self.List) then return end
	self.Open = true

	-- Create dropdown panel
	self.List = vgui.Create("DPanel", self:GetParent())
	self.List:SetWide(self:GetWide())
	self.List:MakePopup()
	self.List:SetKeyboardInputEnabled(false)

	-- Track globally
	UVMenu.OpenDropdowns = UVMenu.OpenDropdowns or {}
	table.insert(UVMenu.OpenDropdowns, self.List)

	self.List.OnRemove = function(pnl)
		for i, v in ipairs(UVMenu.OpenDropdowns) do
			if v == pnl then
				table.remove(UVMenu.OpenDropdowns, i)
				break
			end
		end
	end

	local x, y = self:LocalToScreen(0, self:GetTall() + 2)

	-- Determine menu boundaries
	local menu = self:GetParent()
	while IsValid(menu:GetParent()) do
		menu = menu:GetParent()
	end
	local mx, my = menu:LocalToScreen(0, 0)
	local mw, mh = menu:GetSize()

	local maxHeight = #self.Choices * 26 + 6
	local spaceBelow = (my + mh) - y
	local spaceAbove = y - my
	local listHeight = math.min(maxHeight, 260)

	-- Flip dropdown if not enough space below
	if listHeight > spaceBelow and spaceAbove > spaceBelow then
		listHeight = math.min(listHeight, spaceAbove - 4)
		y = y - listHeight - 2
	else
		listHeight = math.min(listHeight, spaceBelow - 4)
	end

	self.List:SetSize(self:GetWide(), listHeight)
	self.List:SetPos(x, y)

	-- Close on click outside dropdown
	self.List._wasMouseDown = false
	self.List.Think = function(pnl)
		if not IsValid(self) then pnl:Remove() return end

		local mouseDown = input.IsMouseDown(MOUSE_LEFT)
		if pnl._wasMouseDown and not mouseDown then
			local mx, my = gui.MousePos()
			local bx, by = self:LocalToScreen(0, 0)
			local bw, bh = self:GetSize()

			-- Check if inside dropdown
			local inList = false
			for _, pnl2 in ipairs(UVMenu.OpenDropdowns or {}) do
				if IsValid(pnl2) then
					local px, py = pnl2:LocalToScreen(0, 0)
					local pw, ph = pnl2:GetSize()
					if mx >= px and mx <= px + pw and my >= py and my <= py + ph then
						inList = true
						break
					end
				end
			end

			local inButton = mx >= bx and mx <= bx + bw and my >= by and my <= by + bh

			if not inList and not inButton then
				self:CloseList()
			end
		end

		pnl._wasMouseDown = mouseDown
	end

	-- Background
	self.List.Paint = function(p, w, h)
		draw.RoundedBox(10, 0, 0, w, h, Color(30, 30, 30, 240))
	end

	-- Scroll panel
	local scroll = vgui.Create("DScrollPanel", self.List)
	scroll:Dock(FILL)
	scroll:DockMargin(4, 4, 4, 4)
	scroll.OnMouseWheeled = function(pnl, delta)
		pnl:GetVBar():AddScroll(-delta * 1)
		return true
	end

	-- Options
	for _, v in ipairs(self.Choices) do
		local opt = scroll:Add("DButton")
		opt:SetTall(UV.ScaleH(24))
		opt:Dock(TOP)
		opt:DockMargin(0, 0, 0, 2)
		opt:SetText("")

		opt.Paint = function(btn, w, h)
			local hovered = btn:IsHovered()
			draw.RoundedBox(6, 0, 0, w, h, hovered and Color(80, 80, 80, 220) or Color(60, 60, 60, 200))
			draw.SimpleText(v.text, "UVMostWantedLeaderboardFont2", 10, h * 0.5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end

		opt.DoClick = function()
			self:SetValue(v.text, v.data)
			if self.OnSelect then
				self:OnSelect(v.text, v.data)
			end
			self:CloseList()
		end
	end

	-- Fix default display text if not set
	if not self.Value and #self.Choices > 0 then
		self:SetValue(self.Choices[1].text, self.Choices[1].data)
	end
end

function UVDropdown:CloseList()
	self.Open = false
	if IsValid(self.List) then
		self.List:Remove()
	end
end

vgui.Register("UVCombo", UVDropdown, "DPanel")

-- Returns a table of lines and the font used based on the text and max width
function UVTextSplit(text, maxWidth, baseFont, altFont)
    baseFont = baseFont or "UVMostWantedLeaderboardFont"
    altFont = altFont or "UVMostWantedLeaderboardFont2"
    
    local paragraphs = string.Split(text, "\n")
    local wrappedLines = {}

    for _, paragraph in ipairs(paragraphs) do
        if paragraph == "" then
            table.insert(wrappedLines, "")
        else
            for _, line in ipairs(UV_WrapText(paragraph, baseFont, maxWidth)) do
                table.insert(wrappedLines, line)
            end
        end
    end

    local chosenFont = #wrappedLines >= 3 and altFont or baseFont
    return wrappedLines, chosenFont
end

-- Helper to draw wrapped text inside a panel
local function DrawWrappedText(panel, text, maxWidth, x, y, center, altfont)
    local wrappedLines, font = UVTextSplit(text, maxWidth, altfont or nil)
    surface.SetFont(font)
    local _, lineHeight = surface.GetTextSize("A")
    local totalHeight = lineHeight * #wrappedLines
    local startY = y or (panel:GetTall() - totalHeight) / 2
    local color = Color(255, 255, 255, panel:GetAlpha() or 255)
	local center = center and TEXT_ALIGN_CENTER or TEXT_ALIGN_LEFT

    for i, line in ipairs(wrappedLines) do
        draw.DrawText(line, font, x or 10, startY + (i-1)*lineHeight, color, center)
    end
end

-- Returns required height for given text and max width
local function GetDynamicTall(text, maxWidth, baseFont, altFont)
    local lines, font = UVTextSplit(text, maxWidth, baseFont, altFont)
    surface.SetFont(font)
    local _, lineHeight = surface.GetTextSize("A")
    local padding = 0 -- optional padding
    return (#lines * lineHeight) + padding
end

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
		local function ResolveKeybind(token)
			if token:sub(1, 1) == "+" then
				local key = input.LookupBinding(token, true)
				return key and string.upper(key) or "???"
			end

			local cv = GetConVar(token)
			if cv then
				return string.upper(input.GetKeyName(cv:GetInt()) or "???")
			end

			return "???"
		end

		local function ReplaceKeybinds(str)
			str = str:gsub("%[(%+[%w_]+)%]", function(cmd) -- [+use]
				return "<color=255,255,0>" .. ResolveKeybind(cmd) .. "</color>"
			end)

			str = str:gsub("%[key:([%w_]+)%]", function(cvar) -- [key:convar_name]
				return "<color=255,255,0>" .. ResolveKeybind(cvar) .. "</color>"
			end)

			return str
		end

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
		rawText = ReplaceKeybinds(rawText)
		rawText = ConvertDiscordFormatting(rawText)

		local mk
		local lastWidth = 0
		local padding = 10

		function p:Rebuild()
			local w = self:GetWide()
			if w <= 0 then return end

			local text = rawText

			mk = markup.Parse(
				"<font=UVSettingsFontSmall>" .. text .. "</font>",
				w - 20
			)

			self:SetTall(mk:GetHeight() + 20)
		end

		function p:PerformLayout()
			local w = self:GetWide()
			if w ~= lastWidth then
				lastWidth = w
				self:Rebuild()
			end
		end

		function p:Paint(w, h)
			surface.SetDrawColor(28, 28, 28, 150)
			surface.DrawRect(0, 0, w, h)

			if mk then
				mk:Draw(10, 10)
			end
		end

		return p
	end

	-- if st is a header label
	if st.type == "infosimple" then
		local p = vgui.Create("DPanel", parent)
		p:Dock(TOP)
		p:SetTall(UV.ScaleH(46))
		p:DockMargin(6, 6, 6, 2)
		p.Paint = function(self, w, h)
			local text = language.GetPhrase(st.text) or "???"
			DrawWrappedText(self, text, w - 20, w * 0.5, nil, true)
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

	-- if st is an information panel, but now with flags
	if st.type == "info_flags" then
		local p = vgui.Create("DPanel", parent)
		p:Dock(TOP)
		p:DockMargin(6, 6, 6, 2)
		p:SetPaintBackground(false)

		local padding = 10
		local y = padding

		for _, entry in ipairs(st.entries or {}) do
			local row = vgui.Create("DPanel", p)
			row:SetTall(20)
			row:Dock(TOP)
			row:DockMargin(padding, 0, padding, 4)
			row:SetPaintBackground(false)

			local img = vgui.Create("DImage", row)
			img:SetImage("flags16/" .. entry.flag .. ".png")
			img:SetSize(16, 8)
			img:SetPos(0, UV.ScaleW(8))
			img:SetMouseInputEnabled(true)
			img:SetTooltip(entry.desc or "Tooltip")

			local lbl = vgui.Create("DLabel", row)
			lbl:SetFont("UVSettingsFontSmall-Bold")
			lbl:SetText(entry.name)
			lbl:SetTextColor(color_white)
			lbl:SizeToContents()
			lbl:SetPos(20, 0)
		end

		function p:PerformLayout()
			p:SetTall(padding * 2 + (#st.entries * 24))
		end

		function p:Paint(w, h)
			surface.SetDrawColor(28, 28, 28, 150)
			surface.DrawRect(0, 0, w, h)
		end

		return p
	end

	-- if st is a singular image
	if st.type == "image" then
		local p = vgui.Create("DPanel", parent)
		p:Dock(TOP)
		p:DockMargin(60, 6, 60, 2)

		local mat = Material(st.image or "", "smooth")

		if not mat or mat:IsError() then
			p.Paint = function(self, w, h)
				draw.SimpleText("/// Missing image /// ", "UVSettingsFontSmall", w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
			return p
		end

		-- Force 16:9 height based on available width
		p.PerformLayout = function(self, w, h)
			local newH = math.floor((w / 16) * 9)
			self:SetTall(newH)
		end

		p.Paint = function(self, w, h)
			surface.SetDrawColor(0, 0, 0, 200)
			surface.DrawRect(0, 0, w, h)

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
		function p:PerformLayout()
			local text = GetDisplayText()
			local w = self:GetWide()
			if w <= 0 then return end
			local newTall = math.max(UV.ScaleH(36), GetDynamicTall(text, w*0.8))
			if self:GetTall() ~= newTall then self:SetTall(newTall) end
		end
		p:DockMargin(6, 6, 6, 2)
		p.Paint = function(self, w, h)
			local bg = Color( GetConVar("uvmenu_col_label_r"):GetInt(), GetConVar("uvmenu_col_label_g"):GetInt(), GetConVar("uvmenu_col_label_b"):GetInt(), GetConVar("uvmenu_col_label_a"):GetInt() )
			
			draw.RoundedBox(4, 0, 0, w, h, bg)
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
		function wrap:PerformLayout()
			local text = GetDisplayText()
			local w = self:GetWide()
			if w <= 0 then return end
			local newTall = math.max(UV.ScaleH(30), GetDynamicTall(text, w - 44))
			if self:GetTall() ~= newTall then self:SetTall(newTall) end
		end
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
			UVMenu.PlaySFX("confirm")
			if descPanel and st.convar then
				descPanel.SelectedCurrent = new
			end
		end

		wrap.OnCursorEntered = function()
			-- UVMenu.PlaySFX("hover")
			if descPanel then
				descPanel.Text = st.text
				descPanel.Desc = st.desc or ""
				if st.convar then
					descPanel.SelectedDefault = GetConVar(st.convar):GetDefault() or "?"
					descPanel.SelectedCurrent = GetConVar(st.convar):GetInt() or "?"
					descPanel.SelectedConVar = st.convar or "?"
				end
			end
		end

		wrap.OnCursorExited = function()
			if descPanel then
				descPanel.Text = ""
				descPanel.Desc = ""
				if st.convar then
					descPanel.SelectedDefault = ""
					descPanel.SelectedCurrent = ""
					descPanel.SelectedConVar = ""
				end
			end
		end

		wrap.Paint = function(self, w, h)
			local enabled = getBool()
			local hovered = self:IsHovered()

			local bga = hovered and 
			GetConVar("uvmenu_col_bool_a"):GetInt() * math.abs(math.sin(RealTime()*4)) 
			or GetConVar("uvmenu_col_bool_a"):GetInt() * 0.75
			local bg

			local default = Color( 
				GetConVar("uvmenu_col_bool_r"):GetInt(),
				GetConVar("uvmenu_col_bool_g"):GetInt(),
				GetConVar("uvmenu_col_bool_b"):GetInt(),
				bga
			)
			local active = Color(
				GetConVar("uvmenu_col_bool_active_r"):GetInt(),
				GetConVar("uvmenu_col_bool_active_g"):GetInt(),
				GetConVar("uvmenu_col_bool_active_b"):GetInt(),
				bga
			)

			bg = enabled and active or default

			-- background & text
			draw.RoundedBox(6, w - 34, 0, 30, h, bg)
			DrawWrappedText(self, GetDisplayText(), w - 44, 10, nil)
		end

		-- dynamic update when convar changes - simple timer check
		wrap.Think = function(self)
			-- nothing heavy; updates on click via convar toggle
		end
		
		wrap.OnMousePressed = function(self, mc)
			if mc == MOUSE_MIDDLE and st.convar then
				local cv = GetConVar(st.convar)
				if cv then
					RunConsoleCommand(st.convar, cv:GetDefault())
					UVMenu.PlaySFX("confirm")
				end
				return
			end
			-- existing left-click handling:
			if mc == MOUSE_LEFT then
				self:DoClick()
			end
		end

		return wrap
	end

	---- slider: label left, slider right ----
	if st.type == "slider" then
		local wrap = vgui.Create("DPanel", parent)
		wrap:Dock(TOP)
		wrap:DockMargin(6, 4, 6, 4)
		function wrap:PerformLayout()
			local text = GetDisplayText()
			local w = self:GetWide()
			if w <= 0 then return end
			local newTall = math.max(UV.ScaleH(30), GetDynamicTall(text, w * 0.4))
			if self:GetTall() ~= newTall then self:SetTall(newTall) end
		end
		wrap.Paint = function(self, w, h)
			local text = language.GetPhrase(GetDisplayText()) or "???"
			DrawWrappedText(self, text, w * 0.4, 10)
		end

		local function PushDesc()
			if descPanel then
				descPanel.Text = st.text
				descPanel.Desc = st.desc or ""
				if st.convar then
					descPanel.SelectedDefault = GetConVar(st.convar):GetDefault() or "?"
					descPanel.SelectedCurrent = GetConVar(st.convar):GetFloat() or "?"
					descPanel.SelectedConVar = st.convar or st.command or "?"
				elseif st.command then
					descPanel.SelectedConVar = st.command or "?"
				end
			end
		end
		local function PopDesc()
			if descPanel then
				descPanel.Text = ""
				descPanel.Desc = ""
				if st.convar then
					descPanel.SelectedDefault = ""
					descPanel.SelectedCurrent = ""
					descPanel.SelectedConVar = ""
				elseif st.command then
					descPanel.SelectedConVar = ""
				end
			end
		end
		wrap.OnCursorEntered = PushDesc
		wrap.OnCursorExited  = PopDesc

		local slider = vgui.Create("DNumSlider", wrap)
		slider:Dock(RIGHT)
		slider:SetWide(UV.ScaleW(220))
		slider:DockMargin(8, 0, 6, 0)
		slider:SetContentAlignment(5)
		slider:SetMin(st.min or 0)
		slider:SetMax(st.max or 100)
		slider:SetDecimals(st.decimals or 0)
		slider:SetValue(st.min or 0)
		slider.Label:SetVisible(false)
		slider.TextArea:SetVisible(false)
		slider.OnCursorEntered = PushDesc
		slider.OnCursorExited  = PopDesc

		local valPanel = vgui.Create("DPanel", wrap)
		valPanel:SetWide(UV.ScaleW(84))
		valPanel:Dock(RIGHT)
		valPanel.Paint = function() end

		local valBox = vgui.Create("DTextEntry", valPanel)
		valBox:SetWide(UV.ScaleW(40))
		valBox:SetFont("UVMostWantedLeaderboardFont2")
		valBox:SetTextColor(color_white)
		valBox:SetHighlightColor(Color(58,193,0))
		valBox:SetCursorColor(Color(58,193,0))
		valBox.Paint = function(self2, w, h)
			draw.RoundedBox(4, 0, 0, w, h, Color(30,30,30,200))
			self2:DrawTextEntryText(color_white, Color(58,193,0), color_white)
		end
		valBox.OnCursorEntered = PushDesc
		valBox.OnCursorExited  = PopDesc

		-- Only validate on enter/apply, allow free typing
		valBox.OnTextChanged = function(self2)
			local v = tonumber(self2:GetValue())
			if v then
				-- store as pending value but don't overwrite with applied yet
				pendingValue = v
				applyBtn:SetVisible(math.abs(pendingValue - appliedValue) > 0)
			end
		end

		local applyBtn = vgui.Create("DButton", valPanel)
		applyBtn:SetSize(UV.ScaleW(25), UV.ScaleH(25))
		applyBtn:SetText(" ")
		applyBtn:SetVisible(false)
		applyBtn.Paint = function(self2, w, h)
			draw.RoundedBox(4,0,0,w,h,self2:IsHovered() and Color(60,180,60) or Color(45,140,45))
			draw.SimpleText("✔", "UVMostWantedLeaderboardFont2", w/2,h/2,color_white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		end
		applyBtn.OnCursorEntered = PushDesc
		applyBtn.OnCursorExited  = PopDesc

		-- Vertically center value box and button
		local function LayoutValPanel()
			if not (IsValid(valBox) and IsValid(applyBtn)) then return end
			local offsetY = (wrap:GetTall() - valBox:GetTall()) / 2
			valBox:SetPos(0, offsetY)
			applyBtn:SetPos(valBox:GetWide() + 2, offsetY)
		end
		wrap.OnSizeChanged = LayoutValPanel

		local appliedValue = st.min or 0
		local pendingValue = appliedValue

		local function RoundValue(val)
			if st.decimals then
				local factor = 10 ^ st.decimals
				return math.floor(val * factor + 0.5) / factor
			end
			return val
		end

		local function ApplyPendingValue()
			local val = RoundValue(pendingValue)
			appliedValue = val
			if st.convar and GetConVar(st.convar) then
				RunConsoleCommand(st.convar, tostring(val))
			elseif st.command then
				RunConsoleCommand(st.command, tostring(val))
			end
			if st.func then pcall(st.func, val) end
			valBox:SetText(string.format("%."..(st.decimals or 2).."f", val))
			applyBtn:SetVisible(false)
			UVMenu.PlaySFX("confirm")
		end

		valBox:SetText(string.format("%."..slider:GetDecimals().."f", appliedValue))
		slider:SetValue(appliedValue)

		local typing = false

		valBox.OnGetFocus = function()
			typing = true
			if IsValid(UV.SettingsFrame) then
				UV.SettingsFrame:SetKeyboardInputEnabled(true)
			end
		end

		valBox.OnLoseFocus = function()
			typing = false
			if IsValid(UV.SettingsFrame) then
				UV.SettingsFrame:SetKeyboardInputEnabled(false)
			end
		end

		slider.OnValueChanged = function(_, val)
			pendingValue = val
			applyBtn:SetVisible(math.abs(pendingValue - appliedValue) > 0)

			if not typing and IsValid(valBox) then
				valBox:SetText(string.format("%."..slider:GetDecimals().."f", val))
			end
		end

		valBox.OnEnter = function(self2)
			local v = tonumber(self2:GetValue()) or st.max
			if st.min then v = math.max(st.min, v) end
			if st.max then v = math.min(st.max, v) end

			pendingValue = v
			slider:SetValue(v)
			ApplyPendingValue()
		end

		valBox.OnTextChanged = function(self2)
			local v = tonumber(self2:GetValue())
			if not v then return end
			pendingValue = v
			slider:SetValue(v)
			applyBtn:SetVisible(math.abs(pendingValue - appliedValue) > 0)
		end

		applyBtn.DoClick = function()
			local v = tonumber(valBox:GetValue()) or st.max
			if st.min then v = math.max(st.min, v) end
			if st.max then v = math.min(st.max, v) end

			pendingValue = v
			slider:SetValue(v)
			ApplyPendingValue()
		end

		if st.convar then
			local cv = GetConVar(st.convar)
			if cv then
				appliedValue = cv:GetFloat()
				pendingValue = appliedValue
				slider:SetValue(appliedValue)
				valBox:SetText(string.format("%."..slider:GetDecimals().."f", appliedValue))
			end
		end

		wrap.OnMousePressed = function(self, mc)
			if mc == MOUSE_MIDDLE and st.convar then
				local cv = GetConVar(st.convar)
				if cv then
					local def = tonumber(cv:GetDefault()) or st.min or 0
					slider:SetValue(def)
					valBox:SetText(tostring(def))
					pendingValue = def
					applyBtn:SetVisible(math.abs(pendingValue - appliedValue) > 0)
				end
			end
		end

		return wrap
	end

	---- combo: label left, dropdown right ----
	if st.type == "combo" then
		local wrap = vgui.Create("DPanel", parent)
		wrap:Dock(TOP)
		wrap:DockMargin(6, 4, 6, 4)
		wrap.OnCursorEntered = function()
			if descPanel then
				descPanel.Text = st.text
				descPanel.Desc = st.desc or ""
				if st.convar then
					descPanel.SelectedDefault = GetConVar(st.convar):GetDefault() or "?"
					descPanel.SelectedCurrent = GetConVar(st.convar):GetString() or "?"
					descPanel.SelectedConVar = st.convar or "?"
				end
			end
		end

		wrap.OnCursorExited = function()
			if descPanel then
				descPanel.Text = ""
				descPanel.Desc = ""
				if st.convar then
					descPanel.SelectedDefault = ""
					descPanel.SelectedCurrent = ""
					descPanel.SelectedConVar = ""
				end
			end
		end

		local combo = vgui.Create("UVCombo", wrap)
		combo:Dock(RIGHT)
		combo:SetWide(UV.ScaleW(330))
		combo:DockMargin(6, 3, 6, 3)
		combo.Paint = function(self, w, h)
			local hovered = self.Button:IsHovered()
			local default = Color( 
				GetConVar("uvmenu_col_button_r"):GetInt(),
				GetConVar("uvmenu_col_button_g"):GetInt(),
				GetConVar("uvmenu_col_button_b"):GetInt(),
				GetConVar("uvmenu_col_button_a"):GetInt()
				)
			local hover = Color( 
				GetConVar("uvmenu_col_button_hover_r"):GetInt(),
				GetConVar("uvmenu_col_button_hover_g"):GetInt(),
				GetConVar("uvmenu_col_button_hover_b"):GetInt(),
				GetConVar("uvmenu_col_button_hover_a"):GetInt() * math.abs(math.sin(RealTime()*4))
				)

			-- background & text
			draw.RoundedBox(12, 0, 0, w, h, default)
			if hovered then draw.RoundedBox(12, 0, 0, w, h, hover) end
		end
		
		function wrap:PerformLayout()
			local text = GetDisplayText()
			local w = self:GetWide()
			if w <= 0 then return end
			local newTall = math.max(UV.ScaleH(30), GetDynamicTall(text, w - combo:GetWide() - 20))
			if self:GetTall() ~= newTall then self:SetTall(newTall) end
		end
		wrap.Paint = function(self, w, h)
			local hovered = self:IsHovered()
			local bga = hovered and 200 or 125
			local bg = Color( 125, 125, 125, 0 )
			
			if enabled then
				bg = Color( 58, 193, 0, bga )
			end
			
			draw.RoundedBox(6, 0, 0, w, h, bg)
			DrawWrappedText(self, GetDisplayText(), w - combo:GetWide() - 20, 10)
		end

		for _, entry in ipairs(st.content or {}) do
			combo:AddChoice(entry[1], entry[2])
		end

		-- Default value
		if st.convar then
			local cv = GetConVar(st.convar)
			if cv then
				local val = cv:GetString() -- ConVar value as string
				local matched = false

				for _, v in ipairs(st.content or {}) do
					-- Detect numeric vs string
					if type(v[2]) == "number" then
						if tonumber(val) == v[2] then
							combo:SetValue(v[1], v[2])
							matched = true
							break
						end
					else
						if val == tostring(v[2]) then
							combo:SetValue(v[1], v[2])
							matched = true
							break
						end
					end
				end

				if not matched and #st.content > 0 then
					combo:SetValue(st.content[1][1], st.content[1][2])
				end
			end
		elseif st.text then
			combo:SetValue(st.text, nil)
		end

		combo.OnSelect = function(_, val, data)
			if st.convar then
				RunConsoleCommand(st.convar, data)
			end
			if st.func then
				st.func(combo)
			end
		end

		combo.Button.OnCursorEntered = function()
			if descPanel then
				descPanel.Text = st.text
				descPanel.Desc = st.desc or ""
				if st.convar then
					local cv = GetConVar(st.convar)
					descPanel.SelectedDefault = cv and cv:GetDefault() or "?"
					descPanel.SelectedCurrent = cv and cv:GetString() or "?"
					descPanel.SelectedConVar = st.convar or "?"
				end
			end
		end

		combo.Button.OnCursorExited = function()
			if descPanel then
				descPanel.Text = ""
				descPanel.Desc = ""
				if st.convar then
					descPanel.SelectedDefault = ""
					descPanel.SelectedCurrent = ""
					descPanel.SelectedConVar = ""
				end
			end
		end

		wrap.OnMousePressed = function(self, mc)
			if mc == MOUSE_MIDDLE and st.convar then
				local cv = GetConVar(st.convar)
				if not cv then return end

				local def = cv:GetDefault() -- default value as string
				local matched = false

				-- find matching display text
				for _, v in ipairs(st.content or {}) do
					if tostring(v[2]) == tostring(def) then
						combo:SetValue(v[1], v[2])   -- set both text and data
						UVMenu.PlaySFX("hover")
						matched = true
						break
					end
				end

				-- fallback if no match found
				if not matched and #st.content > 0 then
					combo:SetValue(st.content[1][1], st.content[1][2])
				end

				RunConsoleCommand(st.convar, def)
			end
		end

		return wrap
	end

	---- button ----
	if st.type == "button" then
		local btn = vgui.Create("DButton", parent)
		btn:Dock(TOP)
		btn:DockMargin(6, 6, 6, 6)
		function btn:PerformLayout()
			local text = GetDisplayText()
			local w = self:GetWide()
			if w <= 0 then return end
			local newTall = math.max(UV.ScaleH(30), GetDynamicTall(text, w * 0.95))
			if self:GetTall() ~= newTall then self:SetTall(newTall) end
		end
		btn:SetText("")
		btn.Paint = function(self, w, h)
			local hovered = self:IsHovered()
			local default = Color( 
				GetConVar("uvmenu_col_button_r"):GetInt(),
				GetConVar("uvmenu_col_button_g"):GetInt(),
				GetConVar("uvmenu_col_button_b"):GetInt(),
				GetConVar("uvmenu_col_button_a"):GetInt()
				)
			local hover = Color( 
				GetConVar("uvmenu_col_button_hover_r"):GetInt(),
				GetConVar("uvmenu_col_button_hover_g"):GetInt(),
				GetConVar("uvmenu_col_button_hover_b"):GetInt(),
				GetConVar("uvmenu_col_button_hover_a"):GetInt() * math.abs(math.sin(RealTime()*4))
				)

			-- background & text
			draw.RoundedBox(12, w*0.0125, 0, w*0.9875, h, default)
			if hovered then draw.RoundedBox(12, w*0.0125, 0, w*0.9875, h, hover) end
			-- draw.SimpleText(GetDisplayText(), "UVMostWantedLeaderboardFont", w*0.5, h*0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			DrawWrappedText(self, GetDisplayText(), w * 0.95, w*0.5, nil, true)
		end
		
		btn.DoClick = function(self)
			if st.playsfx then UVMenu.PlaySFX(st.playsfx) end
			if st.func then st.func(self) end
			if st.convar and not st.func then
				RunConsoleCommand(st.convar)
			end
		end
		btn.OnCursorEntered = function()
			if descPanel then
				descPanel.Text = st.text
				descPanel.Desc = st.desc or ""
				if st.convar then
					descPanel.SelectedConVar = st.convar or "?"
				end
			end
		end
		btn.OnCursorExited = function()
			if descPanel then
				descPanel.Text = ""
				descPanel.Desc = ""
				if st.convar then
					descPanel.SelectedConVar = ""
				end
			end
		end

		return btn
	end

	---- button with scroll wheel functionality ----
	if st.type == "buttonsw" then
		local val = st.start or st.min or 1
		local min = st.min or 0
		local max = st.max or 10

		local btn = vgui.Create("DButton", parent)
		btn:Dock(TOP)
		btn:DockMargin(6, 6, 6, 6)
		function btn:PerformLayout()
			local w = self:GetWide()
			if w <= 0 then return end
			local text = st.text:find("%%s") and string.format(GetDisplayText(), val) or GetDisplayText()
			local newTall = math.max(UV.ScaleH(30), GetDynamicTall(text, w*0.95))
			if self:GetTall() ~= newTall then self:SetTall(newTall) end
		end
		btn:SetText("")

		btn.Paint = function(self, w, h)
			local hovered = self:IsHovered()
			local default = Color( 
				GetConVar("uvmenu_col_button_r"):GetInt(),
				GetConVar("uvmenu_col_button_g"):GetInt(),
				GetConVar("uvmenu_col_button_b"):GetInt(),
				GetConVar("uvmenu_col_button_a"):GetInt()
				)
			local hover = Color( 
				GetConVar("uvmenu_col_button_hover_r"):GetInt(),
				GetConVar("uvmenu_col_button_hover_g"):GetInt(),
				GetConVar("uvmenu_col_button_hover_b"):GetInt(),
				GetConVar("uvmenu_col_button_hover_a"):GetInt() * math.abs(math.sin(RealTime()*4))
				)

			draw.RoundedBox(12, w*0.0125, 0, w*0.9875, h, default)
			if hovered then draw.RoundedBox(12, w*0.0125, 0, w*0.9875, h, hover) end

			local display = language.GetPhrase(st.text)
			if st.text:find("%%s") then
				display = string.format(GetDisplayText(), val)
			end

			DrawWrappedText(self, display, w * 0.95, w*0.5, nil, true)
		end

		-- Adjust value with mouse wheel
		btn.OnMouseWheeled = function(self, delta)
			val = math.Clamp(val + delta, min, max)
			return true
		end

		btn.DoClick = function(self)
			if st.func then st.func(self, val) end
		end

		btn.OnCursorEntered = function()
			if descPanel then
				descPanel.Text = st.text
				descPanel.Desc = st.desc or ""
				if st.convar then
					descPanel.SelectedConVar = st.convar or "?"
				end
			end
		end

		btn.OnCursorExited = function()
			if descPanel then
				descPanel.Text = ""
				descPanel.Desc = ""
				if st.convar then
					descPanel.SelectedConVar = ""
				end
			end
		end

		return btn
	end

	---- color remains as basic DColorMixer or DColorButton (user requested keep as-is) ----
	if st.type == "color" or st.type == "coloralpha" then
		local p = vgui.Create("DPanel", parent)
		p:Dock(TOP)
		p:DockMargin(6, 4, 6, 4)
		function p:PerformLayout()
			local text = GetDisplayText()
			local w = self:GetWide()
			if w <= 0 then return end
			local newTall = math.max(UV.ScaleH(120), GetDynamicTall(text, w - UV.ScaleW(440)))
			if self:GetTall() ~= newTall then self:SetTall(newTall) end
		end

		-- Check for existence of color convars
		local base = st.convar
		local cv_r = GetConVar(base .. "_r")
		local cv_g = GetConVar(base .. "_g")
		local cv_b = GetConVar(base .. "_b")
		local cv_a = GetConVar(base .. "_a") -- optional
		local invalidtext = " "

		if not cv_r or not cv_g or not cv_b then
			invalidtext = "INVALID COL. CONVAR"
		end
		
		p.Paint = function(self, w, h)
			draw.SimpleText(GetDisplayText(), "UVMostWantedLeaderboardFont", 0, h/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			
			draw.SimpleText(invalidtext, "UVMostWantedLeaderboardFont", w * 0.99, h/2, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		end

		local allowAlpha = st.type == "coloralpha" and cv_a ~= nil

		-- Initial color
		local initial = Color(cv_r:GetInt(), cv_g:GetInt(), cv_b:GetInt(), allowAlpha and cv_a:GetInt() or 255)

		local mixer = vgui.Create("DColorMixer", p)
		mixer:Dock(RIGHT)
		mixer:SetWide(UV.ScaleW(440))
		mixer:DockMargin(6, 6, 6, 6)
		mixer:SetColor(initial)
		mixer:SetPalette(false)
		mixer:SetAlphaBar(allowAlpha)
		mixer:SetWangs(true)
		mixer:SetConVarR(base .. "_r")
		mixer:SetConVarG(base .. "_g")
		mixer:SetConVarB(base .. "_b")
		if allowAlpha then
			mixer:SetConVarA(base .. "_a")
		end

		p.OnCursorEntered = function()
			-- UVMenu.PlaySFX("hover")
			if descPanel then
				descPanel.Text = st.text
				descPanel.Desc = st.desc or ""
				if st.convar then
					descPanel.SelectedConVar = st.convar .. "_r/" .. "_g/" .. "_b/" .. (allowAlpha and "_a/" or "")
					descPanel.SelectedCurrent = cv_r:GetInt() .. ", " .. cv_g:GetInt() .. ", " .. cv_b:GetInt() .. (allowAlpha and ", " .. cv_r:GetInt() or "")
					descPanel.SelectedDefault = cv_r:GetDefault() .. ", " .. cv_g:GetDefault() .. ", " .. cv_b:GetDefault() .. (allowAlpha and ", " .. cv_r:GetDefault() or "")
				end
			end
		end

		p.OnCursorExited = function()
			if descPanel then
				descPanel.Text = ""
				descPanel.Desc = ""
				if st.convar then
					descPanel.SelectedConVar = ""
					descPanel.SelectedCurrent = ""
					descPanel.SelectedDefault = ""
				end
			end
		end

		mixer.OnCursorEntered = function()
			if descPanel then
				descPanel.Text = st.text
				descPanel.Desc = st.desc or ""
				if st.convar then
					descPanel.SelectedConVar = st.convar .. "_r/" .. "_g/" .. "_b/" .. (allowAlpha and "_a/" or "")
					descPanel.SelectedCurrent = cv_r:GetInt() .. ", " .. cv_g:GetInt() .. ", " .. cv_b:GetInt() .. (allowAlpha and ", " .. cv_r:GetInt() or "")
					descPanel.SelectedDefault = cv_r:GetDefault() .. ", " .. cv_g:GetDefault() .. ", " .. cv_b:GetDefault() .. (allowAlpha and ", " .. cv_r:GetDefault() or "")
				end
			end
		end

		mixer.OnCursorExited = function()
			if descPanel then
				descPanel.Text = ""
				descPanel.Desc = ""
				if st.convar then
					descPanel.SelectedConVar = ""
					descPanel.SelectedCurrent = ""
					descPanel.SelectedDefault = ""
				end
			end
		end
		
		p.OnMousePressed = function(self, mc)
			if mc == MOUSE_MIDDLE then
				if cv_r and cv_g and cv_b then
					local r = tonumber(cv_r:GetDefault())
					local g = tonumber(cv_g:GetDefault())
					local b = tonumber(cv_b:GetDefault())
					local a = cv_a and tonumber(cv_a:GetDefault()) or 255
					
					mixer:SetColor(Color(r, g, b, a))

					-- Push to convars
					RunConsoleCommand(base .. "_r", r)
					RunConsoleCommand(base .. "_g", g)
					RunConsoleCommand(base .. "_b", b)
					if cv_a then RunConsoleCommand(base .. "_a", a) end

					UVMenu.PlaySFX("hover")
				end
			end
		end

		return p
	end

	---- keybind button ----
	if st.type == "keybind" then
		local wrap = vgui.Create("DButton", parent)
		wrap:Dock(TOP)
		wrap:DockMargin(6, 4, 6, 4)
		function wrap:PerformLayout()
			local text = GetDisplayText()
			local w = self:GetWide()
			if w <= 0 then return end
			local newTall = math.max(UV.ScaleH(30), GetDynamicTall(text, w * 0.5))
			if self:GetTall() ~= newTall then self:SetTall(newTall) end
		end

		wrap:SetText("")
		wrap:SetCursor("hand")

		local cv = GetConVar(st.convar)
		local function GetKeyName()
			if not cv then return "Invalid ConVar!" end
			return string.upper(input.GetKeyName(cv:GetInt()) or "-")
		end

		local function GetDefaultKeyName()
			if not cv then return "Invalid ConVar!" end
			return string.upper(input.GetKeyName(cv:GetDefault()) or "-")
		end

		-- Register with your existing keybind system
		KeyBindButtons[st.slot] = { st.convar, wrap }

		wrap.Paint = function(self, w, h)
			local hovered = self:IsHovered()
			local default = Color( 
				GetConVar("uvmenu_col_button_r"):GetInt(),
				GetConVar("uvmenu_col_button_g"):GetInt(),
				GetConVar("uvmenu_col_button_b"):GetInt(),
				GetConVar("uvmenu_col_button_a"):GetInt()
				)
			local hover = Color( 
				GetConVar("uvmenu_col_button_hover_r"):GetInt(),
				GetConVar("uvmenu_col_button_hover_g"):GetInt(),
				GetConVar("uvmenu_col_button_hover_b"):GetInt(),
				GetConVar("uvmenu_col_button_hover_a"):GetInt() * math.abs(math.sin(RealTime()*4))
				)

			-- background & text
			draw.RoundedBox(6, w*0.5, 0, w*0.5, h, default)
			if hovered then draw.RoundedBox(6, w*0.5, 0, w*0.5, h, hover) end
			
			DrawWrappedText(self, GetDisplayText(), w * 0.45, 10, nil)
			draw.SimpleText( IsSettingKeybind and "#uv.keybinds.anybutton" or GetKeyName(), "UVMostWantedLeaderboardFont", w * 0.75, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end

		wrap.DoClick = function()
			if IsSettingKeybind then return end

			-- Temporarily allow keyboard input just like slider text entry
			if IsValid(UV.SettingsFrame) then
				UV.SettingsFrame:SetKeyboardInputEnabled(true)
			end

			RunConsoleCommand("uv_keybinds", tostring(st.slot))
		end

		-- When keybind finishes, keyboard input is released in your existing net.Receive
		wrap.Think = function()
			if not IsSettingKeybind and IsValid(UV.SettingsFrame) then
				UV.SettingsFrame:SetKeyboardInputEnabled(false)
			end
		end

		wrap.OnCursorEntered = function()
			if descPanel then
				descPanel.Text = st.text
				descPanel.Desc = st.desc or ""
				if cv then
					descPanel.SelectedDefault = GetDefaultKeyName()
					descPanel.SelectedCurrent = GetKeyName()
					descPanel.SelectedConVar = st.convar
				end
			end
		end

		wrap.OnCursorExited = function()
			if descPanel then
				descPanel.Text = ""
				descPanel.Desc = ""
				descPanel.SelectedDefault = ""
				descPanel.SelectedCurrent = ""
				descPanel.SelectedConVar = ""
			end
		end

		return wrap
	end

	if st.type == "timer" then
		local p = vgui.Create("DPanel", parent)
		p:Dock(TOP)
		p:SetTall(36)
		p:DockMargin(6, 6, 6, 2)

		local duration = tonumber(st.duration) or 0
		p._endTime = CurTime() + duration
		p._fired = false

		p.Paint = function(self, w, h)
			local bg = Color(
				GetConVar("uvmenu_col_label_r"):GetInt(),
				GetConVar("uvmenu_col_label_g"):GetInt(),
				GetConVar("uvmenu_col_label_b"):GetInt(),
				GetConVar("uvmenu_col_label_a"):GetInt()
			)

			draw.RoundedBox(4, 0, 0, w, h, bg)

			local remaining = math.max(0, self._endTime - CurTime())

			-- Optional precision (default = integer)
			local precision = st.precision or 0
			local displayTime = precision > 0
				and string.format("%." .. precision .. "f", remaining)
				or tostring(math.ceil(remaining))

			-- Allow formatted text
			local text
			if st.format then
				text = string.format(st.format, displayTime)
			else
				-- st.text may be localized
				local base = language.GetPhrase(st.text)
				text = string.format(base, displayTime)
			end

			draw.SimpleText(
				text,
				"UVMostWantedLeaderboardFont",
				w * 0.5,
				h * 0.5,
				color_white,
				TEXT_ALIGN_CENTER,
				TEXT_ALIGN_CENTER
			)
		end

		p.Think = function(self)
			if self._fired then return end

			if CurTime() >= self._endTime then
				self._fired = true

				if st.func then
					st.func(self)
				end
			end
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

	if st.type == "ai_overridelist" then
		local p = vgui.Create("DPanel", parent)
		p:Dock(TOP)
		p:SetTall(UV.ScaleH(220))
		p:DockMargin(0, 8, 0, 8)

		p.Paint = function(self, w, h)
			local cv = GetConVar(st.convar)
			local vehnum = 0
			for _, veh in string.gmatch(cv:GetString(), "%S+") do
				vehnum = vehnum + 1
			end
			
			draw.SimpleText( string.format( language.GetPhrase(st.text), vehnum ), "UVMostWantedLeaderboardFont", w * 0.5, h * 0.05, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end

		-- Vehicle tree belongs to THIS panel
		local vehicleTree = vgui.Create("DTree", p)
		vehicleTree:Dock(BOTTOM)
		vehicleTree:SetTall(UV.ScaleH(160))
		vehicleTree:DockMargin(80, 4, 80, 4)
		
		-- vehicleTree.Paint = function(self, w, h)
			-- local bg = Color( GetConVar("uvmenu_col_label_r"):GetInt(), GetConVar("uvmenu_col_label_g"):GetInt(), GetConVar("uvmenu_col_label_b"):GetInt(), GetConVar("uvmenu_col_label_a"):GetInt() )
			
			-- draw.RoundedBox(4, 0, 0, w, h, bg)
			-- draw.SimpleText(st.text, "UVMostWantedLeaderboardFont", 10, h/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		-- end

		-- /// Vehicle Override Code /// --
		local selectedRacers = {}
		
		local glideNode
		local glideDataRequested = false
		local racerconvar = GetConVar("uvracermanager_racers")

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
			-- RunConsoleCommand("uvracermanager_racers", str)
			racerconvar:SetString( str )
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

				node:SetTooltip("#uv.airacer.overridelist.desc")

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

		local function BuildVehicleTree()
			vehicleTree:Clear()
			classToNode = {}
			selectedRacers = ParseConvar()

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

			-- Glide placeholder
			glideNode = vehicleTree:AddNode("Glide - Select to load")
			glideNode:SetExpanded(false)
			glideDataRequested = false
		end

		BuildVehicleTree()

		print(parent, st, descPanel)

		-- Request server data when Glide node is selected
		function glideNode:OnNodeSelected()
			if glideDataRequested then return end
			glideDataRequested = true

			net.Start("RequestGlideVehicles")
			net.SendToServer()
		end

		-- if glideDataRequested then return end
		-- glideDataRequested = true

		-- net.Start("RequestGlideVehicles")
		-- net.SendToServer()

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

		-- /// End of Vehicle Override Code /// --
		
		p.OnMousePressed = function(self, mouse)
			if mouse == MOUSE_MIDDLE then
				-- RunConsoleCommand("uvracermanager_racers", "")
				racerconvar:SetString( "" )
				
				selectedRacers = {}

				vehicleTree:Clear()
				classToNode = {}

				-- Rebuild nodes (call a function instead of duplicating)
				BuildVehicleTree()
				
				glideDataRequested = true
				net.Start("RequestGlideVehicles")
				net.SendToServer()

				UVMenu.PlaySFX("confirm")
				-- notification.AddLegacy("#uv.overrides.cleared", NOTIFY_UNDO, 3)
			end
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
			
			vehicleTree.OnCursorEntered = function()
				if descPanel then
					descPanel.Text = st.text
					descPanel.Desc = st.desc or ""
				end
			end

			vehicleTree.OnCursorExited = function()
				if descPanel then
					descPanel.Text = ""
					descPanel.Desc = ""
				end
			end
		end

		return p
	end

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

-- Plays Sound SFX for the menu
function UVMenu.PlaySFX(name, overrideSet)
    if not GetConVar("uvmenu_sound_enabled"):GetBool() then return end
    name = tostring(name or "")
    local setName = overrideSet or GetConVar("uvmenu_sound_set"):GetString() or "MW"
    local setTbl = UVMenu.Sounds[setName] or UVMenu.Sounds["MW"]
    if not setTbl then return end
    local snd = setTbl[name]
    if not snd or snd == "" then return end
	
    surface.PlaySound(snd)
end

-- Helper to open menus safely
function UVMenu.OpenMenu(menuFunc, dontsave)
    if not dontsave and menuFunc then
        UVMenu.LastMenu = menuFunc
    end

    if UVMenu.CurrentMenu and IsValid(UVMenu.CurrentMenu) then
        -- Close current menu first
        UVMenu.CloseCurrentMenu(true)
        -- Delay opening new menu to allow closing animation to start
        timer.Simple(tonumber(GetConVar("uvmenu_close_speed"):GetString()) or 0.2, function()
            if menuFunc then
                menuFunc()
                -- Update CurrentMenu to the newly created frame
                UVMenu.CurrentMenu = UV.SettingsFrame
				UVMenu.PlaySFX("menuopen")
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
function UVMenu.CloseCurrentMenu(noCloseSound)
    local frame = UVMenu.CurrentMenu or UV.SettingsFrame
    if not IsValid(frame) or frame._closing then return end

    -- Play close sound unless explicitly disabled OR convars disallow
    if not noCloseSound and GetConVar("uvmenu_sound_enabled"):GetBool() then UVMenu.PlaySFX("menuclose") end

    frame._closing = true
    frame._closeStart = CurTime()

    local closeSpeed = tonumber(GetConVar("uvmenu_close_speed"):GetString()) or 0.2
    frame._closeFadeDur = closeSpeed * 0.5
    frame._closeShrinkDur = closeSpeed
    frame._closeShrinkStart = frame._closeStart + frame._closeFadeDur * 0.5

    UVMenu.CurrentMenu = nil
end

-- Opens a UVMenu menu
function UVMenu:Open(menu)
    local CurrentMenu = menu or {}
    local Name = CurrentMenu.Name or "#uv.unitvehicles"
	
	local BaseMenuW = 1400
	local BaseMenuH = 900
	local Width = CurrentMenu.Width or math.min( UV.ScaleW(BaseMenuW), ScrW() * 0.92 )
	local Height = CurrentMenu.Height or math.min( UV.ScaleH(BaseMenuH), ScrH() * 0.92 )

    local ShowDesc = CurrentMenu.Description == true and not GetConVar("uvmenu_hide_description"):GetBool()
    local Tabs = CurrentMenu.Tabs or {}
    local UnfocusClose = CurrentMenu.UnfocusClose == true
	local HideCloseButton = CurrentMenu.HideCloseButton == true
	
	if CurrentMenu.Description == true and GetConVar("uvmenu_hide_description"):GetBool() then
		Width = math.max(
			UV.ScaleW(1000),
			Width * 0.75
		)
	end

    if IsValid(UV.SettingsFrame) then UV.SettingsFrame:Remove() end
    gui.EnableScreenClicker(true)

    local sw, sh = ScrW(), ScrH()
    local fw, fh = Width, Height
    local fx, fy = (sw - fw) * 0.5, (sh - fh) * 0.5
    local watchedConvars = {}

    local frame = vgui.Create("DFrame")
    UV.SettingsFrame = frame
    frame:SetSize(0, 0)
	frame:Center()
    frame:SetPos(fx + fw * 0.5, fy + fh * 0.5)
    frame:SetTitle("")
    frame:ShowCloseButton(false)
    frame:SetDraggable(false)
    frame:MakePopup()
    frame:SetKeyboardInputEnabled(false)
	
	frame.Tabs = CurrentMenu.Tabs or {}

    frame.TargetWidth = fw
    frame.TargetHeight = fh

    local animStart = CurTime()
    local animDur = tonumber(GetConVar("uvmenu_open_speed"):GetString()) or 0.2
    local primaryFadeStart = animStart + animDur * 0.5
    local primaryFadeDur = animDur * 1.25
    local secondaryFadeStart = animStart + animDur * 0.5
    local secondaryFadeDur = animDur * 1.25

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
        descPanel:SetWide(math.Clamp(fw * 0.25, UV.ScaleW(220), UV.ScaleW(380)))
        descPanel.Paint = function(self, w, h)
            local a = self:GetAlpha()
            surface.SetDrawColor( GetConVar("uvmenu_col_desc_r"):GetInt(), GetConVar("uvmenu_col_desc_g"):GetInt(), GetConVar("uvmenu_col_desc_b"):GetInt(), math.floor(GetConVar("uvmenu_col_desc_a"):GetInt() * (a / 255)) )
            surface.DrawRect(0, 0, w, h)

            if self.Text and a > 5 then
                local font = "UVMostWantedLeaderboardFont2"
                local color = Color(255, 255, 255, a)
                local xPadding, yPadding = UV.ScaleW(10), UV.ScaleH(10)
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
			if self.SelectedConVar then
				draw.SimpleText(self.SelectedConVar, "UVMostWantedLeaderboardFont2", w * 0.5, h * 0.98 - 40, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
			if self.SelectedDefault and self.SelectedDefault ~= "" then
				-- draw.SimpleText( "#uv.settings.resetbind", "UVMostWantedLeaderboardFont2", w * 0.5, h * 0.98 - 40, Color(255, 255, 255, a), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText( string.format( language.GetPhrase("uv.settings.default"), self.SelectedDefault ), "UVMostWantedLeaderboardFont2", 10, h * 0.98 - 20, Color(175, 175, 175, a), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end
			if self.SelectedCurrent and self.SelectedCurrent ~= ""then
				draw.SimpleText(string.format( language.GetPhrase("uv.settings.current"), self.SelectedCurrent ), "UVMostWantedLeaderboardFont2", 10, h * 0.98, Color(175, 175, 175, a), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end
        end

        descPanel.Text = ""
        descPanel.Desc = ""
        descPanel.SelectedConVar = ""
        descPanel.SelectedDefault = ""
        descPanel.SelectedCurrent = ""
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
        tabsPanel = vgui.Create("DScrollPanel", frame)
        tabsPanel:Dock(LEFT)
        tabsPanel:SetWide(UV.ScaleW(300))
		tabsPanel:Dock(LEFT)
        tabsPanel.Paint = function(self, w, h)
			surface.SetDrawColor(
				GetConVar("uvmenu_col_tabs_r"):GetInt(),
				GetConVar("uvmenu_col_tabs_g"):GetInt(),
				GetConVar("uvmenu_col_tabs_b"):GetInt(),
				GetConVar("uvmenu_col_tabs_a"):GetInt()
			)
			surface.DrawRect(0, 0, w, h)
		end
        tabsPanel:SetAlpha(0)
    end

    local closeBtn = vgui.Create("DButton", frame)
    closeBtn:SetSize(20, 20)
    closeBtn:SetText("")
    closeBtn:SetFont("DermaDefaultBold")
	if HideCloseButton then
		closeBtn:SetVisible(false)
		closeBtn:SetMouseInputEnabled(false)
		closeBtn:SetKeyboardInputEnabled(false)
	end

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

	local primaryGroup = {}

	if not HideCloseButton then
		table.insert(primaryGroup, closeBtn)
	end

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
        -- title:SetTall(UV.ScaleH(48))
		function title:PerformLayout()
			local text = language.GetPhrase(tab.TabName)
			local w = self:GetWide()
			if w <= 0 then return end
			local newTall = math.max(UV.ScaleH(48), GetDynamicTall(text, w - 44, "UVFont5"))
			if self:GetTall() ~= newTall then self:SetTall(newTall) end
		end

        title.Paint = function(self, w, h)
            -- draw.SimpleText(tab.TabName or ("Tab " .. tostring(tabIndex)), "UVFont5", w * 0.5, h * 0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			
			DrawWrappedText(self, language.GetPhrase(tab.TabName) or ("Tab " .. tostring(tabIndex)), w - 44, w*0.5, nil, true, "UVFont5")
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

            if not HideCloseButton and IsValid(closeBtn) then
				closeBtn:SetPos(math.max(self:GetWide() - 24, 8), 4)
			end

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

					local clickedInsideDropdown = false
					for _, pnl in ipairs(UVMenu.OpenDropdowns or {}) do
						if IsValid(pnl) then
							local px, py = pnl:LocalToScreen(0, 0)
							local pw, ph = pnl:GetSize()
							if mx >= px and mx <= px + pw and my >= py and my <= py + ph then
								clickedInsideDropdown = true
								break
							end
						end
					end

					if not clickedInsideDropdown and (mx < fx2 or mx > fx2 + fw2 or my < fy2 or my > fy2 + fh2) then
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
		local bg = Color( GetConVar("uvmenu_col_bg_r"):GetInt(), GetConVar("uvmenu_col_bg_g"):GetInt(), GetConVar("uvmenu_col_bg_b"):GetInt(), GetConVar("uvmenu_col_bg_a"):GetInt() )
		draw.RoundedBox(0, 0, 0, w, h, bg)

        local titleColor = Color(255, 255, 255, math.Clamp(math.floor(self.TitleAlpha), 0, 255))
        draw.SimpleText(Name, "UVMostWantedLeaderboardFont", w * 0.01, h * 0.02, titleColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    -- Build tabs if more than 1
    local TAB_START_OFFSET = 15
    local TAB_BUTTON_HEIGHT = UV.ScaleH(64)
    local TAB_BUTTON_PADDING = 0
    local TAB_SIDE_PADDING = 6
    local TAB_CORNER_RADIUS = 4

    if tabsPanel then
        tabsPanel:DockPadding(0, TAB_START_OFFSET, 0, 0)
		local uv_tab_hover_last = uv_tab_hover_last or 0
        for i, tab in ipairs(Tabs) do
            if not UV.PlayerCanSeeSetting(tab) then continue end

            local btn = vgui.Create("DButton", tabsPanel)
            btn:Dock(TOP)
            btn:DockMargin(0, 0, 0, TAB_BUTTON_PADDING)
            btn:SetTall(TAB_BUTTON_HEIGHT)
            btn:SetText("")

            btn.Paint = function(self, w, h)
				local a = self:GetAlpha()
				local isSelected = (CURRENT_TAB == i)
				local hovered = self:IsHovered()

				local pulse = math.abs(math.sin(RealTime() * 4))

				local baseAlpha  = 75
				local hoverAlpha = 175 * pulse

				local default = Color(
					GetConVar("uvmenu_col_tab_default_r"):GetInt(),
					GetConVar("uvmenu_col_tab_default_g"):GetInt(),
					GetConVar("uvmenu_col_tab_default_b"):GetInt(),
					baseAlpha
				)

				local active = Color(
					GetConVar("uvmenu_col_tab_active_r"):GetInt(),
					GetConVar("uvmenu_col_tab_active_g"):GetInt(),
					GetConVar("uvmenu_col_tab_active_b"):GetInt(),
					baseAlpha
				)

				local hoverCol = Color(
					GetConVar("uvmenu_col_tab_hover_r"):GetInt(),
					GetConVar("uvmenu_col_tab_hover_g"):GetInt(),
					GetConVar("uvmenu_col_tab_hover_b"):GetInt(),
					hoverAlpha
				)
				local bg = isSelected and active or default

				draw.RoundedBox( TAB_CORNER_RADIUS, TAB_SIDE_PADDING, 4, w - TAB_SIDE_PADDING * 2, h - 8, bg )

				if hovered then
					draw.RoundedBox( TAB_CORNER_RADIUS, TAB_SIDE_PADDING, 4, w - TAB_SIDE_PADDING * 2, h - 8, hoverCol )
				end

                if tab.Icon then
                    local mat = Material(tab.Icon, "smooth")
                    local iconSize = UV.ScaleW(40)
                    local iconX = TAB_SIDE_PADDING + 2
                    local iconY = (h - iconSize) / 2
                    surface.SetDrawColor(255, 255, 255, self:GetAlpha())
                    surface.SetMaterial(mat)
                    surface.DrawTexturedRect(iconX, iconY, iconSize, iconSize)
                end
				
				if a > 5 then
					local baseFont = "UVMostWantedLeaderboardFont"
					local multiFont = baseFont
					local desc = language.GetPhrase(tab.TabName) or "Tab"

					-- First, pre-wrap all text to count lines
					local paragraphs = string.Split(desc, "\n")
					local wrappedLines = {}

					for _, paragraph in ipairs(paragraphs) do
						if paragraph == "" then
							table.insert(wrappedLines, "")
						else
							local wrapped = UV_WrapText(paragraph, baseFont, w - (w * 0.15) * 2)
							for _, line in ipairs(wrapped) do
								table.insert(wrappedLines, line)
							end
						end
					end

					-- Total line count
					local lineCount = #wrappedLines

					-- Rule 3: If 3+ lines, switch font
					if lineCount >= 3 then
						multiFont = "UVMostWantedLeaderboardFont2"
					end

					surface.SetFont(multiFont)
					local _, lineHeight = surface.GetTextSize("A")

					local totalHeight = lineHeight * lineCount
					local centerY = h * 0.5
					local xPadding = tab.Icon and UV.ScaleW(60) or UV.ScaleW(20)

					-- Center vertically depending on line count
					local startY = centerY - (totalHeight / 2)

					local color = Color(255, 255, 255, a)

					-- Draw wrapped text
					local yOffset = startY
					for _, line in ipairs(wrappedLines) do
						draw.DrawText(line, multiFont, xPadding, yOffset, color, TEXT_ALIGN_LEFT)
						yOffset = yOffset + lineHeight
					end
				end
            end

			-- btn.OnCursorEntered = function(self)
				-- if not IsValid(self) then return end
				-- if not GetConVar("uvmenu_sound_enabled"):GetBool() then return end

				-- local now = CurTime()
				-- local key = tostring(self) -- unique-ish key per panel
				-- local last = uv_tab_hover_last or 0
				-- if now - last >= 0.025 then           -- 120ms debounce; tweak if needed
					-- uv_tab_hover_last = now
					-- UVMenu.PlaySFX("hovertab")
				-- end
			-- end

            btn.DoClick = function()
				if tab.playsfx then UVMenu.PlaySFX(tab.playsfx) end
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