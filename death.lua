--------------------------------------------------
-- HARDCOREBOUND - DEATH HANDLER
--------------------------------------------------

HardcoreBound = HardcoreBound or {}

local deathHandled = false

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_DEAD")

frame:SetScript("OnEvent", function(_, event)
    if event ~= "PLAYER_DEAD" then return end
    if deathHandled then return end
    deathHandled = true

    local level = UnitLevel("player")

    if HardcoreBound.DeathWindow and HardcoreBound.DeathWindow.Show then
        C_Timer.After(0.3, function()
            HardcoreBound.DeathWindow.Show(level)
        end)
    end
end)
