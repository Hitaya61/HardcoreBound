local UI = HardcoreBound.UI

function HardcoreBound:CreateMainWindow()
    if self.mainFrame then return end

    local frame = UI:CreateMainFrame(
        "HardcoreBound_Main",
        "HardcoreBound",
        560,
        460
    )

    local playerView = self:CreatePlayerView(frame)
    local rulesView  = self:CreateRulesView(frame)
    local guildView  = self:CreateGuildView(frame)

    UI:CreateTabs(frame, {
        { text = "Players", frame = playerView },
        { text = "Rules",   frame = rulesView },
        { text = "Guild",   frame = guildView },
    })

    self.mainFrame = frame
end
