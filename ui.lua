--------------------------------------------------
-- HARDCOREBOUND - MAIN UI
-- Classic / TBC Safe
--------------------------------------------------

HardcoreBound = HardcoreBound or {}

--------------------------------------------------
-- BLIZZARD ICONS (NAMESPACED)
--------------------------------------------------

HardcoreBound.ICONS = {
    ALIVE   = "Interface\\Buttons\\UI-CheckBox-Check",
    DEAD    = "Interface\\TargetingFrame\\UI-TargetingFrame-Skull",
    WARNING = "Interface\\DialogFrame\\UI-Dialog-Icon-AlertNew",
    DUNGEON = "Interface\\LFGFrame\\UI-LFG-ICON-DUNGEON",
    GOLD    = "Interface\\MoneyFrame\\UI-GoldIcon",
    GROUP   = "Interface\\FriendsFrame\\UI-Toast-FriendOnlineIcon",
    ADDON   = "Interface\\OptionsFrame\\UI-OptionsFrame-NewFeatureIcon",
    PROFILE = "Interface\\PaperDollInfoFrame\\UI-EquipmentManager-Toggle",
}

--------------------------------------------------
-- SLASH COMMAND
--------------------------------------------------

SLASH_HARDCOREBOUND1 = "/hcb"
SlashCmdList["HARDCOREBOUND"] = function()
    if HardcoreBound and HardcoreBound.ToggleUI then
        HardcoreBound:ToggleUI()
    else
        print("|cffff0000HardcoreBound UI failed to load.|r")
    end
end

--------------------------------------------------
-- MAIN WINDOW
--------------------------------------------------

function HardcoreBound:ToggleUI()
    if not self.UI then
        self:CreateUI()
    end

    if self.UI:IsShown() then
        HideUIPanel(self.UI)
    else
        ShowUIPanel(self.UI)
    end
end

function HardcoreBound:CreateUI()
    local f = CreateFrame("Frame", "HardcoreBound_UI", UIParent, "PortraitFrameTemplate")
    f:SetHeight(420)
    f:SetPoint("CENTER")
    f:SetFrameStrata("DIALOG")

    f.TitleText:SetText("HardcoreBound")
    SetPortraitTexture(f.portrait, "player")

    self.UI = f

    self:CreateTabs()
    self:CreatePanels()
    self:ShowTab(1)
end

--------------------------------------------------
-- TABS
--------------------------------------------------

function HardcoreBound:CreateTabs()
    self.Tabs = {}
    local names = { "Player", "Guild", "Rules", "Fallen" }

    for i, name in ipairs(names) do
        local tab = CreateFrame(
            "CheckButton",
            "HardcoreBoundTab"..i,
            self.UI,
            "CharacterFrameTabButtonTemplate"
        )

        tab:SetID(i)
        tab:SetText(name)

        tab:SetScript("OnClick", function()
            HardcoreBound:ShowTab(i)
        end)

        if i == 1 then
            tab:SetPoint("TOPLEFT", self.UI, "TOPLEFT", 70, -28)
        else
            tab:SetPoint("LEFT", self.Tabs[i - 1], "RIGHT", -15, 0)
        end

        self.Tabs[i] = tab
    end

    --------------------------------------------------
    -- RESIZE MAIN FRAME TO END AT FALLEN TAB
    --------------------------------------------------
    C_Timer.After(0, function()
        local lastTab = self.Tabs[4]
        if not lastTab then return end

        local left = self.UI:GetLeft()
        local right = lastTab:GetRight()

        if left and right then
            -- +28 = padding for frame border / close button
            self.UI:SetWidth((right - left) + 28)
        end
    end)
end


--------------------------------------------------
-- PANELS (RIGHT EDGE ALIGNED TO FALLEN TAB)
--------------------------------------------------

function HardcoreBound:CreatePanels()
    self.Panels = {}

    for i = 1, 4 do
        local p = CreateFrame("Frame", nil, self.UI)
        p:SetPoint("TOPLEFT", self.UI, "TOPLEFT", 20, -70)
        p:SetPoint("BOTTOMLEFT", self.UI, "BOTTOMLEFT", 20, 20)
        p:SetPoint("RIGHT", self.Tabs[4], "RIGHT", -6, 0)
        p:Hide()
        self.Panels[i] = p
    end

    self:BuildPlayerPanel(self.Panels[1])
    self:BuildGuildPanel(self.Panels[2])
    self:BuildRulesPanel(self.Panels[3])
    self:BuildFallenPanel(self.Panels[4])
end

--------------------------------------------------
-- PLAYER TAB
--------------------------------------------------

function HardcoreBound:BuildPlayerPanel(panel)
    local ICONS = HardcoreBound.ICONS
    local status = HardcoreBound:GetStatus()

    local rulesAccepted = HardcoreBoundDB and HardcoreBoundDB.rulesAccepted == true
    local resurrectionDetected = HardcoreBoundDB and HardcoreBoundDB.resurrectionDetected == true

    local function ColorGoodBad(isGood)
        return isGood and "|cff00ff00YES|r" or "|cffff0000NO|r"
    end

    local function ColorResurrection(resDetected)
        return resDetected and "|cffff0000YES|r" or "|cff00ff00NO|r"
    end

    --------------------------------------------------
    -- HEADER
    --------------------------------------------------

    local statusIcon = panel:CreateTexture(nil, "ARTWORK")
    statusIcon:SetSize(22, 22)
    statusIcon:SetPoint("TOPLEFT", 0, -2)
    statusIcon:SetTexture(
        resurrectionDetected and ICONS.WARNING
        or (status == "DEAD" and ICONS.DEAD or ICONS.ALIVE)
    )

    local nameText = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    nameText:SetPoint("LEFT", statusIcon, "RIGHT", 8, 4)
    nameText:SetText(UnitName("player"))

    local statusText = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    statusText:SetPoint("LEFT", statusIcon, "RIGHT", 8, -12)
    statusText:SetText("Status: " .. status)

    --------------------------------------------------
    -- DIVIDER
    --------------------------------------------------

    local divider1 = panel:CreateTexture(nil, "ARTWORK")
    divider1:SetColorTexture(1, 1, 1, 0.25)
    divider1:SetHeight(1)
    divider1:SetPoint("TOPLEFT", statusIcon, "BOTTOMLEFT", 0, -12)
    divider1:SetPoint("RIGHT", panel, "RIGHT", 0, 0)

    --------------------------------------------------
    -- INFO ROW HELPER
    --------------------------------------------------

    local function InfoRow(y, label, value, tooltip)
        local l = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        l:SetPoint("TOPLEFT", 0, y)
        l:SetText(label)

        local v = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        v:SetPoint("LEFT", l, "RIGHT", 12, 0)
        v:SetText(value)

        if tooltip then
            local hit = CreateFrame("Frame", nil, panel)
            hit:SetAllPoints(v)
            hit:EnableMouse(true)

            hit:SetScript("OnEnter", function()
                GameTooltip:SetOwner(hit, "ANCHOR_RIGHT")
                GameTooltip:SetText("Resurrection Detection", 1, 0.82, 0)
                GameTooltip:AddLine(tooltip, 1, 1, 1, true)
                GameTooltip:Show()
            end)

            hit:SetScript("OnLeave", function()
                GameTooltip:Hide()
            end)
        end
    end

    InfoRow(-50,  "Level:", UnitLevel("player"))
    InfoRow(-68,  "Zone:", GetRealZoneText())
    InfoRow(-86,  "Playtime:", SecondsToTime(GetTime()))
    InfoRow(-104, "Rules Accepted:", ColorGoodBad(rulesAccepted))
    InfoRow(
        -122,
        "Resurrection Detected:",
        ColorResurrection(resurrectionDetected),
        "Any resurrection, spirit healer interaction,\nor exploit that restores life\ninvalidates the run permanently."
    )

    --------------------------------------------------
    -- DIVIDER
    --------------------------------------------------

    local divider2 = panel:CreateTexture(nil, "ARTWORK")
    divider2:SetColorTexture(1, 1, 1, 0.25)
    divider2:SetHeight(1)
    divider2:SetPoint("TOPLEFT", 0, -140)
    divider2:SetPoint("RIGHT", panel, "RIGHT", 0, 0)

    --------------------------------------------------
    -- GUILD SECTION
    --------------------------------------------------

    local guildTitle = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    guildTitle:SetPoint("TOPLEFT", 0, -156)
    guildTitle:SetText("Guild Hardcore Status")

    local guildValue = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    guildValue:SetPoint("TOPLEFT", guildTitle, "BOTTOMLEFT", 0, -6)

    if IsInGuild() then
        guildValue:SetText("Alive\nLast Update: Today")
    else
        guildValue:SetText("Not in a guild")
    end
end

--------------------------------------------------
-- GUILD TAB
--------------------------------------------------

function HardcoreBound:BuildGuildPanel(panel)
    local title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 0, 0)
    title:SetText("Guild Hardcore Status")

    local msg = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    msg:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -10)

    if not IsInGuild() then
        msg:SetText("You are not in a guild.")
        return
    end

    msg:SetText("Guild tracking coming soon.")
end

--------------------------------------------------
-- RULES TAB
--------------------------------------------------

function HardcoreBound:BuildRulesPanel(panel)
    local ICONS = HardcoreBound.ICONS

    local scroll = CreateFrame("ScrollFrame", nil, panel, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", 0, 0)
    scroll:SetPoint("BOTTOMRIGHT", -18, 0)

    local content = CreateFrame("Frame", nil, scroll)
    content:SetSize(1, 1)
    scroll:SetScrollChild(content)

    local title = content:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 0, 0)
    title:SetText("|cffff0000HardcoreBound Ruleset|r")

    local subtitle = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -6)
    subtitle:SetText("|cffffff00All rules are automatically tracked. Breaking a rule is permanent.|r")

    local y = -50

    local function Section(icon, header, lines)
        local tex = content:CreateTexture(nil, "ARTWORK")
        tex:SetSize(18, 18)
        tex:SetPoint("TOPLEFT", 0, y)
        tex:SetTexture(icon)

        local h = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        h:SetPoint("LEFT", tex, "RIGHT", 8, 0)
        h:SetText(header)

        y = y - 22

        for _, line in ipairs(lines) do
            local fs = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
            fs:SetPoint("TOPLEFT", 28, y)
            fs:SetWidth(520)
            fs:SetJustifyH("LEFT")
            fs:SetText("• " .. line)
            y = y - 16
        end

        y = y - 10
    end

    Section(ICONS.DEAD, "Death", {
        "One life only",
        "Death ends the run",
        "Character is marked Fallen",
    })

    Section(ICONS.WARNING, "Combat Logout", {
        "Logging out or disconnecting in combat is forbidden",
        "Logged as a violation",
        "May end the run",
    })

    Section(ICONS.GROUP, "Grouping", {
        "Grouping allowed only within level range (±5)",
        "No dead or invalid characters",
        "Raid groups forbidden outside your guild",
    })

    Section(ICONS.DUNGEON, "Dungeons & Raids", {
        "Each dungeon allowed once",
        "Re-entering a dungeon is a violation",
        "Raids forbidden unless all members are guildmates",
    })

    Section(ICONS.GOLD, "Economy", {
        "Trading, mail, and Auction House are allowed",
        "All interactions are logged",
    })

    Section(ICONS.ADDON, "Gear & Addons", {
        "No heirlooms",
        "No items above your level",
        "Certain addons may be forbidden",
        "Detection causes violations or run failure",
    })

    Section(ICONS.WARNING, "Violations", {
        "Minor – Logged",
        "Major – Run becomes Tainted",
        "Critical – Run ends",
    })

    Section(ICONS.PROFILE, "Rule Profiles", {
        "Rules are locked per character",
        "Changing rules invalidates the run",
        "Profile is visible to others",
    })

    content:SetHeight(-y + 10)
end

--------------------------------------------------
-- FALLEN TAB
--------------------------------------------------

function HardcoreBound:BuildFallenPanel(panel)
    local title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 0, 0)
    title:SetText("Hall of the Fallen")

    local fallen = HardcoreBoundDB and HardcoreBoundDB.fallen or {}

    local msg = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    msg:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -10)

    if #fallen == 0 then
        msg:SetText("No recorded deaths.")
        return
    end

    local y = -30
    for _, entry in ipairs(fallen) do
        local fs = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        fs:SetPoint("TOPLEFT", 0, y)
        fs:SetText(string.format("☠ Level %d — %s (%s)", entry.level, entry.zone, entry.time))
        y = y - 16
    end
end

--------------------------------------------------
-- TAB SWITCH
--------------------------------------------------

function HardcoreBound:ShowTab(index)
    for i, tab in ipairs(self.Tabs) do
        if i == index then
            tab:SetChecked(true)
            self.Panels[i]:Show()
        else
            tab:SetChecked(false)
            self.Panels[i]:Hide()
        end
    end
end
