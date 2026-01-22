local UI = HardcoreBound.UI

function HardcoreBound:CreatePlayerView()
    if self.playerFrame then return end

    local frame = UI:CreateMainFrame(
        "HardcoreBound_PlayerView",
        "HardcoreBound – Player View",
        520,
        420
    )

    local content = UI:CreateScrollContent(frame)

    -- Eksempel spillerkort
    local section = UI:CreateSection(content, 50)
    section:SetPoint("TOPLEFT", 0, 0)

    UI:CreateStatusIcon(section, "VERIFIED")

    local name = section:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    name:SetPoint("LEFT", 30, 0)
    name:SetText("Funderskov – Level 10")

    content:SetHeight(60)

    self.playerFrame = frame
end
