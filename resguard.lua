--------------------------------------------------
-- HARDCOREBOUND - RES GUARD
--------------------------------------------------

HardcoreBound = HardcoreBound or {}

local resBlocked = false

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_DEAD")
frame:RegisterEvent("PLAYER_ALIVE")
frame:RegisterEvent("PLAYER_UNGHOST")

frame:SetScript("OnEvent", function(_, event)
    if event == "PLAYER_DEAD" then
        resBlocked = true
        return
    end

    if resBlocked and event ~= "PLAYER_DEAD" then
        if not UnitIsDeadOrGhost("player") then
            RepopMe()
        end
    end
end)

hooksecurefunc("AcceptResurrect", function()
    if resBlocked then return end
end)
