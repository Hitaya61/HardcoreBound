HardcoreBound = HardcoreBound or {}
HardcoreBound.UI = HardcoreBound.UI or {}

local UI = HardcoreBound.UI

-- =========================
-- Main Frame
-- =========================
function UI:CreateMainFrame(name, title, width, height)
    local frame = CreateFrame(
        "Frame",
        name,
        UIParent,
        "BasicFrameTemplateWithInset"
    )

    frame:SetSize(width or 560, height or 460)
    frame:SetPoint("CENTER")
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    frame:Hide()

    frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
    frame.title:SetPoint("TOP", 0, -8)
    frame.title:SetText(title or "HardcoreBound")

    return frame
end

-- =========================
-- Scroll Content
-- =========================
function UI:CreateScrollContent(parent)
    local scroll = CreateFrame(
        "ScrollFrame",
        nil,
        parent,
        "UIPanelScrollFrameTemplate"
    )

    scroll:SetPoint("TOPLEFT", 10, -30)
    scroll:SetPoint("BOTTOMRIGHT", -30, 10)

    local content = CreateFrame("Frame", nil, scroll)
    content:SetSize(1, 1)
    scroll:SetScrollChild(content)

    return content
end

-- =========================
-- Section (Inset box)
-- =========================
function UI:CreateSection(parent, height)
    local section = CreateFrame(
        "Frame",
        nil,
        parent,
        "InsetFrameTemplate"
    )

    section:SetHeight(height or 50)
    section:SetPoint("LEFT", 0, 0)
    section:SetPoint("RIGHT", 0, 0)

    return section
end

-- =========================
-- Status Icon
-- =========================
function UI:CreateStatusIcon(parent, status)
    local icon = parent:CreateTexture(nil, "ARTWORK")
    icon:SetSize(16, 16)
    icon:SetPoint("LEFT", 8, 0)

    if status == "VERIFIED" then
        icon:SetTexture("Interface\\RaidFrame\\ReadyCheck-Ready")
    elseif status == "UNVERIFIED" then
        icon:SetTexture("Interface\\RaidFrame\\ReadyCheck-NotReady")
    else
        icon:SetTexture("Interface\\RaidFrame\\ReadyCheck-Waiting")
    end

    return icon
end

-- =========================
-- Tabs
-- =========================
function UI:CreateTabs(parent, tabs)
    parent.tabs = {}
    parent.tabFrames = {}

    for i, tab in ipairs(tabs) do
        local button = CreateFrame(
            "Button",
            parent:GetName().."Tab"..i,
            parent,
            "CharacterFrameTabButtonTemplate"
        )

        button:SetID(i)
        button:SetText(tab.text)
        button:SetPoint("TOPLEFT", parent, "BOTTOMLEFT", (i - 1) * 70, 7)

        PanelTemplates_TabResize(button, 0)

        button:SetScript("OnClick", function()
            UI:SelectTab(parent, i)
        end)

        parent.tabs[i] = button
        parent.tabFrames[i] = tab.frame
    end

    PanelTemplates_SetNumTabs(parent, #tabs)
    UI:SelectTab(parent, 1)
end

function UI:SelectTab(parent, id)
    for i, frame in ipairs(parent.tabFrames) do
        frame:SetShown(i == id)
    end

    PanelTemplates_SetTab(parent, id)
end
