--------------------------------------------------
-- HARDCOREBOUND - UI
--------------------------------------------------

HardcoreBound = HardcoreBound or {}
HardcoreBound.UI = HardcoreBound.UI or {}
HardcoreBoundDB = HardcoreBoundDB or {}

--------------------------------------------------
-- CONSTANTS
--------------------------------------------------
local PANEL_WIDTH  = 560
local PANEL_HEIGHT = 400
local ROW_HEIGHT   = 20
local MAX_ROWS     = 20

-- Column centers
local COL_STATUS     = 20
local COL_NAME       = 120
local COL_LEVEL      = 260
local COL_ZONE       = 350
local COL_LASTONLINE = 470

--------------------------------------------------
-- MAIN FRAME
--------------------------------------------------
HardcoreBound.UI.MainFrame =
    CreateFrame("Frame", "HardcoreBound_MainFrame", UIParent, "BackdropTemplate")

HardcoreBound.UI.MainFrame:SetSize(PANEL_WIDTH, PANEL_HEIGHT)
HardcoreBound.UI.MainFrame:SetPoint("CENTER")
HardcoreBound.UI.MainFrame:SetBackdrop({
    bgFile   = "Interface/Tooltips/UI-Tooltip-Background",
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    edgeSize = 16,
})
HardcoreBound.UI.MainFrame:SetBackdropColor(0, 0, 0, 0.95)
HardcoreBound.UI.MainFrame:Hide()

--------------------------------------------------
-- CLOSE BUTTON
--------------------------------------------------
local closeButton =
    CreateFrame("Button", nil, HardcoreBound.UI.MainFrame, "UIPanelCloseButton")
closeButton:SetPoint("TOPRIGHT", -6, -6)

--------------------------------------------------
-- TITLE
--------------------------------------------------
local title =
    HardcoreBound.UI.MainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("TOP", 0, -12)
title:SetText("HardcoreBound")

--------------------------------------------------
-- CONTENT FRAME
--------------------------------------------------
local content = CreateFrame("Frame", nil, HardcoreBound.UI.MainFrame)
content:SetSize(PANEL_WIDTH - 30, PANEL_HEIGHT - 90)
content:SetPoint("TOP", 0, -40)

--------------------------------------------------
-- RULES FRAME
--------------------------------------------------
HardcoreBound.UI.RulesFrame = CreateFrame("Frame", nil, content)
HardcoreBound.UI.RulesFrame:SetAllPoints()

local rulesText =
    HardcoreBound.UI.RulesFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
rulesText:SetPoint("TOPLEFT", 10, -10)
rulesText:SetWidth(PANEL_WIDTH - 60)
rulesText:SetJustifyH("LEFT")
rulesText:SetText([[
This character is bound to the HardcoreBound ruleset. 
The addon is based on trust!

|cffff4444If the addon is turned off, you will be considered DEAD.|r

|cffaaaaaa• One death = character is finished
• Resurrection is NOT allowed
• Spirit healer is NOT allowed|r

|cffaaaaaaThis cannot be undone.|r


But what can you do:

|cffaaaaaa• Mail and Auction House is allowed
• Play solo or with friends
• If you want to track your friends progress under the Players tab,
  you all need to be in the same guild.|r
]])

--------------------------------------------------
-- PLAYERS FRAME
--------------------------------------------------
HardcoreBound.UI.PlayersFrame = CreateFrame("Frame", nil, content)
HardcoreBound.UI.PlayersFrame:SetAllPoints()
HardcoreBound.UI.PlayersFrame:Hide()

HardcoreBound.UI.PreviewText =
    HardcoreBound.UI.PlayersFrame:CreateFontString(nil, "OVERLAY", "GameFontDisable")
HardcoreBound.UI.PreviewText:SetPoint("BOTTOM", HardcoreBound.UI.PlayersFrame, "BOTTOM", 0, 0)
HardcoreBound.UI.PreviewText:SetWidth(420)
HardcoreBound.UI.PreviewText:SetJustifyH("CENTER")
HardcoreBound.UI.PreviewText:Hide()

--------------------------------------------------
-- HEADERS
--------------------------------------------------
HardcoreBound.UI.Headers = {}

local function CreateHeader(text, x)
    local h =
        HardcoreBound.UI.PlayersFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    h:SetPoint("TOP", HardcoreBound.UI.PlayersFrame, "TOPLEFT", x, -10)
    h:SetJustifyH("CENTER")
    h:SetText(text)
    return h
end

HardcoreBound.UI.Headers.status     = CreateHeader("Status", COL_STATUS)
HardcoreBound.UI.Headers.name       = CreateHeader("Name", COL_NAME)
HardcoreBound.UI.Headers.level      = CreateHeader("Level", COL_LEVEL)
HardcoreBound.UI.Headers.zone       = CreateHeader("Zone", COL_ZONE)
HardcoreBound.UI.Headers.lastOnline = CreateHeader("Last online", COL_LASTONLINE)

--------------------------------------------------
-- PLAYER ROWS
--------------------------------------------------
HardcoreBound.UI.PlayerRows = {}

for i = 1, MAX_ROWS do
    local row = CreateFrame("Frame", nil, HardcoreBound.UI.PlayersFrame)
    row:SetSize(PANEL_WIDTH - 60, ROW_HEIGHT)
    row:SetPoint("TOPLEFT", 10, -30 - ((i - 1) * ROW_HEIGHT))

    row.status = row:CreateTexture(nil, "OVERLAY")
    row.status:SetSize(16, 16)
    row.status:SetPoint("CENTER", row, "LEFT", COL_STATUS, 0)
    row.status:Hide()

    row.skull = row:CreateTexture(nil, "OVERLAY")
    row.skull:SetSize(16, 16)
    row.skull:SetPoint("CENTER", row, "LEFT", COL_STATUS, 0)
    row.skull:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Skull")
    row.skull:Hide()

    row.name = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    row.name:SetPoint("CENTER", row, "LEFT", COL_NAME, 0)
    row.name:SetJustifyH("CENTER")

    row.level = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    row.level:SetPoint("CENTER", row, "LEFT", COL_LEVEL, 0)
    row.level:SetJustifyH("CENTER")

    row.zone = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    row.zone:SetPoint("CENTER", row, "LEFT", COL_ZONE, 0)
    row.zone:SetJustifyH("CENTER")

    row.lastOnline =
        row:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    row.lastOnline:SetPoint("CENTER", row, "LEFT", COL_LASTONLINE, 0)
    row.lastOnline:SetJustifyH("CENTER")

    row:Hide()
    HardcoreBound.UI.PlayerRows[i] = row
end

--------------------------------------------------
-- HELPERS
--------------------------------------------------
function HardcoreBound.UI.HideAllRows()
    for _, row in ipairs(HardcoreBound.UI.PlayerRows) do
        row:Hide()
    end
end

function HardcoreBound.UI.HideHeaders()
    for _, h in pairs(HardcoreBound.UI.Headers) do
        h:Hide()
    end
end

--------------------------------------------------
-- REFRESH PLAYERS
--------------------------------------------------
function HardcoreBound.UI.RefreshPlayers()
    HardcoreBound.UI.HideAllRows()
    for _, h in pairs(HardcoreBound.UI.Headers) do h:Show() end

    local index = 1

    -- SOLO MODE ONLY
    if not IsInGuild() then
        HardcoreBound.UI.PreviewText:SetText(
            "Local hardcore history\nJoin a hardcore guild for live tracking."
        )
        HardcoreBound.UI.PreviewText:Show()

        --------------------------------------------------
        -- BUILD SORTED LIST
        --------------------------------------------------
local sorted = {}

for name, data in pairs(HardcoreBoundDB.localRoster or {}) do
    if type(name) == "string" and type(data) == "table" then
        table.insert(sorted, {
            name = name,
            dead = data.dead == true,
            verified = data.verified == true,
            level = data.level or 0,
            zone = data.zone,
            lastSeen = data.lastSeen
        })
    end
end
        --------------------------------------------------
        -- SORT: VERIFIED → UNVERIFIED → DEAD
        --------------------------------------------------
       table.sort(sorted, function(a, b)
    -- 1. Dead always last
    if a.dead ~= b.dead then
        return not a.dead
    end

    -- 2. Verified before Unverified
    if a.verified ~= b.verified then
        return a.verified
    end

    -- 3. Alphabetical (ALWAYS defined)
    return a.name < b.name
end)


        --------------------------------------------------
        -- RENDER ROWS
        --------------------------------------------------
        for _, entry in ipairs(sorted) do
    local row = HardcoreBound.UI.PlayerRows[index]
    if not row then break end

    row.status:Hide()
    row.skull:Hide()

    if entry.dead then
        row.skull:Show()

    elseif not entry.verified then
        row.status:SetTexture("Interface\\RaidFrame\\ReadyCheck-Waiting")
        row.status:Show()

    else
        row.status:SetTexture("Interface\\RaidFrame\\ReadyCheck-Ready")
        row.status:Show()
    end

    row.name:SetText(entry.name)
    row.level:SetText(entry.level or "?")
    row.zone:SetText(entry.zone or "-")
    row.lastOnline:SetText(
        HardcoreBound.FormatLastOnline(entry.lastSeen)
    )

    row:Show()
    index = index + 1
end


        return
    end
end


--------------------------------------------------
-- TABS
--------------------------------------------------
local function CreateTab(text, x)
    local b =
        CreateFrame("Button", nil, HardcoreBound.UI.MainFrame, "BackdropTemplate")
    b:SetSize(90, 22)
    b:SetPoint("BOTTOMLEFT", 12 + x, -30)
    b:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
    })

    b.text = b:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    b.text:SetPoint("CENTER")
    b.text:SetText(text)

    function b:SetActive(active)
        if active then
            b:SetBackdropColor(0.3, 0.3, 0.3, 1)
        else
            b:SetBackdropColor(0.1, 0.1, 0.1, 0.9)
        end
    end

    return b
end

local rulesTab   = CreateTab("Rules", 0)
local playersTab = CreateTab("Players", 100)

function HardcoreBound.UI.ShowRules()
    HardcoreBound.UI.PlayersFrame:Hide()
    HardcoreBound.UI.RulesFrame:Show()
    rulesTab:SetActive(true)
    playersTab:SetActive(false)
end

function HardcoreBound.UI.ShowPlayers()
    HardcoreBound.UI.RulesFrame:Hide()
    HardcoreBound.UI.PlayersFrame:Show()
    HardcoreBound.UI.RefreshPlayers()
    rulesTab:SetActive(false)
    playersTab:SetActive(true)
end

playersTab:SetScript("OnClick", HardcoreBound.UI.ShowPlayers)
rulesTab:SetScript("OnClick", HardcoreBound.UI.ShowRules)

--------------------------------------------------
-- SLASH COMMAND
--------------------------------------------------
SLASH_HARDCOREBOUND1 = "/hb"
SlashCmdList["HARDCOREBOUND"] = function()
    HardcoreBound.UI.MainFrame:SetShown(
        not HardcoreBound.UI.MainFrame:IsShown()
    )
    HardcoreBound.UI.ShowRules()
end

--------------------------------------------------
-- INTRO POPUP (UI)
--------------------------------------------------
function HardcoreBound.ShowIntroPopup()
    local name = UnitName("player")
    if not name then return end

    HardcoreBoundDB.players = HardcoreBoundDB.players or {}
    HardcoreBoundDB.players[name] = HardcoreBoundDB.players[name] or {}

    if HardcoreBoundDB.players[name].introSeen then return end

    local overlay = CreateFrame("Frame", nil, UIParent)
    overlay:SetAllPoints()
    overlay:SetFrameStrata("FULLSCREEN")
    overlay:EnableMouse(true)

    local bg = overlay:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetColorTexture(0, 0, 0, 0.75)

    local frame = CreateFrame("Frame", nil, overlay, "BackdropTemplate")
    frame:SetSize(600, 360)
    frame:SetPoint("CENTER")
    frame:SetBackdrop({
        bgFile   = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 16,
    })
    frame:SetBackdropColor(0, 0, 0, 0.95)

    local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
    title:SetPoint("TOP", 0, -20)
    title:SetText("|cffff0000HARDCORE CHALLENGE|r")

    local skull = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
    skull:SetPoint("TOP", title, "BOTTOM", 0, -10)
    skull:SetText("|TInterface\\TargetingFrame\\UI-TargetingFrame-Skull:48:48|t")

    local txt = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    txt:SetPoint("TOP", skull, "BOTTOM", 0, -16)
    txt:SetWidth(520)
    txt:SetJustifyH("CENTER")
    txt:SetText(
        "You are about to join the Hardcore experience.\n\n" ..
        "• One death = your journey has ended\n" ..
        "• No resurrection\n" ..
        "• Spirit healers are not allowed\n\n" ..
        "|cffaaaaaaThis cannot be undone|r"
    )

    local btn = CreateFrame("Button", nil, frame, "BackdropTemplate")
    btn:SetSize(260, 40)
    btn:SetPoint("BOTTOM", 0, 26)
    btn:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 14,
    })
    btn:SetBackdropColor(0.2, 0.2, 0.2, 1)

    btn.text = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
    btn.text:SetPoint("CENTER")
    btn.text:SetText("I understand – start hardcore")

    btn:SetScript("OnClick", function()
        HardcoreBoundDB.players[name].introSeen = true
        overlay:Hide()
    end)
end
