HardcoreBound = HardcoreBound or {}
HardcoreBound.UI = {}

function HardcoreBound.UI:CreateMainFrame(name, title, width, height)
    local frame = CreateFrame(
        "Frame",
        name,
        UIParent,
        "BasicFrameTemplateWithInset"
    )

    frame:SetSize(width or 500, height or 400)
    frame:SetPoint("CENTER")
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    frame:Hide()

    -- Title
    frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
    frame.title:SetPoint("TOP", 0, -8)
    frame.title:SetText(title or "HardcoreBound")

    return frame
end

function HardcoreBound.UI:CreateScrollContent(parent)
    local scrollFrame = CreateFrame(
        "ScrollFrame",
        nil,
        parent,
        "UIPanelScrollFrameTemplate"
    )
    scrollFrame:SetPoint("TOPLEFT", 12, -30)
    scrollFrame:SetPoint("BOTTOMRIGHT", -30, 12)

    local content = CreateFrame("Frame", nil, scrollFrame)
    content:SetSize(1, 1)

    scrollFrame:SetScrollChild(content)

    parent.scrollFrame = scrollFrame
    parent.content = content

    return content
end

function HardcoreBound.UI:CreateSection(parent, height)
    local section = CreateFrame(
        "Frame",
        nil,
        parent,
        "InsetFrameTemplate"
    )

    section:SetHeight(height or 60)
    section:SetPoint("LEFT", 0, 0)
    section:SetPoint("RIGHT", 0, 0)

    return section
end

function HardcoreBound.UI:CreateStatusIcon(parent, status)
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
