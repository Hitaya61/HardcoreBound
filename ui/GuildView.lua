local UI = HardcoreBound.UI

function HardcoreBound:CreateGuildView(parent)
    local content = UI:CreateScrollContent(parent)

    local text = content:CreateFontString(
        nil,
        "OVERLAY",
        "GameFontDisable"
    )
    text:SetPoint("CENTER")
    text:SetText("No guild detected")

    content:SetHeight(200)
    return content
end
