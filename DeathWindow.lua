--------------------------------------------------
-- HARDCOREBOUND - DEATH WINDOW
-- Classic / TBC
--------------------------------------------------

HardcoreBound = HardcoreBound or {}
HardcoreBound.DeathWindow = HardcoreBound.DeathWindow or {}

--------------------------------------------------
-- CONFIG (CurseForge required opt-out)
--------------------------------------------------

HardcoreBound.Config = HardcoreBound.Config or {
    lockESC = true,      -- allow user to disable ESC lock
}

local deathFrame
local overlay

--------------------------------------------------
-- ESC LOCK (OPTIONAL)
--------------------------------------------------

local escLocked = false
local originalToggleGameMenu = ToggleGameMenu

local function LockESC()
    if not HardcoreBound.Config.lockESC then return end
    if escLocked then return end

    escLocked = true
    ToggleGameMenu = function()
        -- ESC intentionally disabled during death window
    end
end


--------------------------------------------------
-- HARDCORE SOUND
--------------------------------------------------

local HARDCORE_SOUND = "Sound\\Interface\\RaidWarning.ogg"
-- Custom example:
-- local HARDCORE_SOUND = "Interface\\AddOns\\HardcoreBoundTest\\Sounds\\death.ogg"

local function PlayHardcoreSound()
    PlaySoundFile(HARDCORE_SOUND, "Master")
end

--------------------------------------------------
-- FADE HELPER
--------------------------------------------------

local function FadeIn(frame, duration)
    frame:SetAlpha(0)
    frame:Show()
    UIFrameFadeIn(frame, duration or 0.35, 0, 1)
end

--------------------------------------------------
-- DEATH COMMENTS (RANDOM PER 10 LEVELS)
--------------------------------------------------

local DeathComments = {
    [60] = {
        "You made it to the end. Still died.",
        "Few reach this far. Fewer survive.",
    },
    [50] = {
        "So close. Yet not close enough.",
        "One mistake away from glory.",
    },
    [40] = {
        "You had time. You wasted it.",
        "Confidence killed you.",
    },
    [30] = {
        "This was supposed to get easier.",
        "Plenty of time. None of it mattered.",
    },
    [20] = {
        "Ambitious. Reckless. Dead.",
        "Hardcore noticed your haste.",
    },
    [10] = {
        "You barely began.",
        "Early confidence. Early grave.",
    },
    [0] = {
        "That didn't take long.",
        "Hardcore says hello.",
    },
}

local function GetDeathComment(level)
    local bracket = math.floor((level or 0) / 10) * 10
    if bracket > 60 then bracket = 60 end
    if bracket < 0 then bracket = 0 end

    local pool = DeathComments[bracket]
    if not pool then
        return "Death comes for everyone."
    end

    return pool[math.random(#pool)]
end

--------------------------------------------------
-- SHOW DEATH WINDOW
--------------------------------------------------

function HardcoreBound.DeathWindow.Show(level)

    --------------------------------------------------
    -- LOCK ESC
    --------------------------------------------------
    LockESC()

    --------------------------------------------------
    -- OVERLAY
    --------------------------------------------------
    if not overlay then
        overlay = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
        overlay:SetAllPoints(UIParent)
        overlay:SetFrameStrata("FULLSCREEN")
        overlay:SetFrameLevel(900)
        overlay:EnableMouse(true)

        HardcoreBound.Media.ApplyBackdrop(overlay, HardcoreBound.Backdrops.Overlay)
        overlay:SetBackdropColor(0, 0, 0, 0.85)
    end

    --------------------------------------------------
    -- MAIN FRAME
    --------------------------------------------------
    if not deathFrame then
        deathFrame = CreateFrame("Frame", "HardcoreBound_DeathFrame", UIParent, "BackdropTemplate")
        deathFrame:SetSize(640, 420)
        deathFrame:SetPoint("CENTER")
        deathFrame:SetFrameStrata("FULLSCREEN_DIALOG")
        deathFrame:SetFrameLevel(1000)
        deathFrame:EnableMouse(true)

        HardcoreBound.Media.ApplyBackdrop(deathFrame, HardcoreBound.Backdrops.MainPanel)

        --------------------------------------------------
        -- TITLE
        --------------------------------------------------
        deathFrame.title = deathFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
        deathFrame.title:SetPoint("TOP", deathFrame, "TOP", 0, -55)
        deathFrame.title:SetText("|cffff0000YOU HAVE DIED|r")

        --------------------------------------------------
        -- SKULL ICON (SQUARE)
        --------------------------------------------------
        deathFrame.skull = deathFrame:CreateTexture(nil, "ARTWORK")
        deathFrame.skull:SetTexture(HardcoreBound.Media.Textures.ICON_DEAD)
        deathFrame.skull:SetSize(64, 64)
        deathFrame.skull:SetPoint("TOP", deathFrame.title, "BOTTOM", 0, -19)

        --------------------------------------------------
        -- LEVEL TEXT
        --------------------------------------------------
        deathFrame.levelText = deathFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        deathFrame.levelText:SetPoint("TOP", deathFrame.skull, "BOTTOM", 0, -15)
        deathFrame.levelText:SetTextColor(1, 0.85, 0)

        --------------------------------------------------
        -- COMMENT
        --------------------------------------------------
        deathFrame.commentText = deathFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        deathFrame.commentText:SetPoint("TOP", deathFrame.levelText, "BOTTOM", 0, -17)
        deathFrame.commentText:SetWidth(520)
        deathFrame.commentText:SetJustifyH("CENTER")
        deathFrame.commentText:SetTextColor(0.7, 0.7, 0.7)

        --------------------------------------------------
        -- INFO TEXT
        --------------------------------------------------
        deathFrame.infoText = deathFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
        deathFrame.infoText:SetPoint("TOP", deathFrame.commentText, "BOTTOM", 0, -25)
        deathFrame.infoText:SetWidth(520)
        deathFrame.infoText:SetJustifyH("CENTER")
        deathFrame.infoText:SetText(
            "|cffffff00This character is permanently dead.|r\n" ..
            "|cffffff00No resurrection is allowed.|r"
        )

        --------------------------------------------------
        -- DIVIDER
        --------------------------------------------------
        deathFrame.divider = HardcoreBound.Media.CreateDivider(deathFrame, 520, 45)
        deathFrame.divider:SetPoint("TOP", deathFrame.infoText, "BOTTOM", 0, -5)

        --------------------------------------------------
        -- FINAL INSTRUCTION
        --------------------------------------------------
        deathFrame.instruction = deathFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
        deathFrame.instruction:SetPoint("TOP", deathFrame.divider, "BOTTOM", 0, -5)
        deathFrame.instruction:SetWidth(520)
        deathFrame.instruction:SetJustifyH("CENTER")
        deathFrame.instruction:SetText(
            "|cffff0000Press ALT+F4 to close HardcoreBound and try again|r"
        )
    end

    --------------------------------------------------
    -- UPDATE TEXT
    --------------------------------------------------
    deathFrame.levelText:SetText("Level " .. (level or "?"))
    deathFrame.commentText:SetText(GetDeathComment(level))

    --------------------------------------------------
    -- FADE + SOUND (SYNCED)
    --------------------------------------------------
    overlay:SetAlpha(0)
    deathFrame:SetAlpha(0)

    local overlayFade = 0.55

    FadeIn(overlay, overlayFade)

    -- Play sound at overlay midpoint
    C_Timer.After(overlayFade * 0.5, function()
        PlayHardcoreSound()
    end)

    -- Fade window after darkness settles
    C_Timer.After(0.25, function()
        FadeIn(deathFrame, 0.35)
    end)
end
