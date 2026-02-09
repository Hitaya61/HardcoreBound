--------------------------------------------------
-- HARDCOREBOUND - CORE LOGIC
-- Classic / TBC Safe
--------------------------------------------------

HardcoreBound = HardcoreBound or {}

--------------------------------------------------
-- DB INIT
--------------------------------------------------

local function InitDB()
    if not HardcoreBoundDB then
        HardcoreBoundDB = {}
    end
end

--------------------------------------------------
-- ACCEPTANCE STATE
--------------------------------------------------

function HardcoreBound:IsAccepted()
    return HardcoreBoundDB.acceptedRules == true
end

--------------------------------------------------
-- SESSION INTEGRITY
--------------------------------------------------

HardcoreBound.SessionAlive = false

--------------------------------------------------
-- START ACCEPTANCE POPUP
--------------------------------------------------

StaticPopupDialogs["HARDCOREBOUND_ACCEPT"] = {
    text =
        "|cffff2020HARDCOREBOUND RULESET|r\n\n" ..
        "This character is permanently bound to HardcoreBound.\n\n" ..
        "|cffff0000ONE LIFE ONLY|r\n\n" ..
        "• Death is permanent\n" ..
        "• No resurrection\n" ..
        "• Reloading does not save you\n" ..
        "• Disabling the addon invalidates the run\n\n" ..
        "|cffffff00This decision is final.|r",

    button1 = "I Accept",
    button2 = "Decline",

    timeout = 0,
    whileDead = true,
    hideOnEscape = false,

    OnAccept = function()
        HardcoreBoundDB.acceptedRules = true
        HardcoreBoundDB.acceptedTime = time()
        print("|cff00ff00HardcoreBound activated.|r")
    end,

    OnCancel = function()
        HardcoreBoundDB.acceptedRules = false
        print("|cffff0000HardcoreBound inactive.|r")
    end,
}

--------------------------------------------------
-- STATUS HELPERS
--------------------------------------------------

local function IsDead()
    return HardcoreBoundDB.isDead == true
end

function HardcoreBound:GetStatus()
    if HardcoreBoundDB.isDead then return "DEAD" end
    if HardcoreBoundDB.resurrected then return "INVALID" end
    return "ALIVE"
end

--------------------------------------------------
-- GUILD BROADCAST
--------------------------------------------------

function HardcoreBound:BroadcastDeath()
    if not IsInGuild() then return end
    if HardcoreBoundDB.deathBroadcasted then return end

    HardcoreBoundDB.deathBroadcasted = true

    SendChatMessage(
        string.format(
            "[HardcoreBound] ☠ %s died at level %d in %s.",
            UnitName("player"),
            HardcoreBoundDB.deathLevel or UnitLevel("player"),
            HardcoreBoundDB.deathZone or "Unknown"
        ),
        "GUILD"
    )
end

--------------------------------------------------
-- EVENT HANDLER
--------------------------------------------------

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("PLAYER_DEAD")
f:RegisterEvent("PLAYER_ALIVE")
f:RegisterEvent("PLAYER_UNGHOST")

f:SetScript("OnEvent", function(_, event, isLogin)
    InitDB()

    --------------------------------------------------
    -- LOGIN / RELOAD
    --------------------------------------------------
    if event == "PLAYER_ENTERING_WORLD" then

        if isLogin then
            HardcoreBound.SessionAlive = true
            HardcoreBoundDB.sessionStarted = time()

            if not HardcoreBoundDB.acceptedRules then
                StaticPopup_Show("HARDCOREBOUND_ACCEPT")
            end
        end

        -- Reload / relog protection
        if IsDead() then
            C_Timer.After(1, function()
                if HardcoreBound.DeathWindow then
                    HardcoreBound.DeathWindow.Show(HardcoreBoundDB.deathLevel)
                end
            end)
        end

        return
    end

    --------------------------------------------------
    -- DEATH
    --------------------------------------------------
    if event == "PLAYER_DEAD" then
        if IsDead() then return end
        if not HardcoreBound:IsAccepted() then return end

        HardcoreBoundDB.isDead = true
        HardcoreBoundDB.deathLevel = UnitLevel("player")
        HardcoreBoundDB.deathZone = GetRealZoneText()
        HardcoreBoundDB.deathTime = time()

        HardcoreBoundDB.fallen = HardcoreBoundDB.fallen or {}
        table.insert(HardcoreBoundDB.fallen, {
            level = HardcoreBoundDB.deathLevel,
            zone  = HardcoreBoundDB.deathZone,
            time  = date("%Y-%m-%d %H:%M"),
        })

        if HardcoreBound.DeathWindow then
            HardcoreBound.DeathWindow.Show(HardcoreBoundDB.deathLevel)
        end

        HardcoreBound:BroadcastDeath()
        return
    end

    --------------------------------------------------
    -- RESURRECTION DETECTED
    --------------------------------------------------
    if (event == "PLAYER_ALIVE" or event == "PLAYER_UNGHOST") and IsDead() then
        HardcoreBoundDB.resurrected = true

        if HardcoreBound.DeathWindow then
            HardcoreBound.DeathWindow.Show(HardcoreBoundDB.deathLevel)
        end
    end
end)
