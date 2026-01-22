local UI = HardcoreBound.UI

function HardcoreBound:CreateRulesView(parent)
    local content = UI:CreateScrollContent(parent)

    local rules = content:CreateFontString(
        nil,
        "OVERLAY",
        "GameFontHighlight"
    )
    rules:SetPoint("TOPLEFT", 10, -10)
    rules:SetWidth(480)
    rules:SetJustifyH("LEFT")
    rules:SetText(
[[1. No trading
2. No mailbox
3. No grouping
4. Death = delete]]
    )

    content:SetHeight(300)
    return content
end
