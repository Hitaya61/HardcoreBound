local UI = HardcoreBound.UI

function HardcoreBound:CreatePlayerView(parent)
    local content = UI:CreateScrollContent(parent)

    local section = UI:CreateSection(content, 50)
    section:SetPoint("TOPLEFT", 0, 0)

    UI:CreateStatusIcon(section, "VERIFIED")

    local text = section:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    text:SetPoint("LEFT", 30, 0)
    text:SetText("Funderskov – Level 10 – Elwynn Forest")

    content:SetHeight(60)
    return content
end
