--------------------------------------------------
-- HARDCOREBOUND - MEDIA
--------------------------------------------------

HardcoreBound = HardcoreBound or {}
HardcoreBound.Media = {}
HardcoreBound.Backdrops = {}

local MediaPath = "Interface\\AddOns\\HardcoreBound\\Media\\"

HardcoreBound.Media.Textures = {
    BG_MAIN   = MediaPath .. "bg_main.tga",
    OVERLAY   = MediaPath .. "overlay_smoke.tga",
    DIVIDER   = MediaPath .. "divider.tga",
    ICON_DEAD = MediaPath .. "icon_dead.tga",
}

HardcoreBound.Backdrops.MainPanel = {
    bgFile = HardcoreBound.Media.Textures.BG_MAIN,
    tile = false,
}

HardcoreBound.Backdrops.Overlay = {
    bgFile = HardcoreBound.Media.Textures.OVERLAY,
    tile = false,
}

function HardcoreBound.Media.ApplyBackdrop(frame, backdrop)
    frame:SetBackdrop(backdrop)
end

function HardcoreBound.Media.CreateDivider(parent, width, height)
    local t = parent:CreateTexture(nil, "ARTWORK")
    t:SetTexture(HardcoreBound.Media.Textures.DIVIDER)
    t:SetSize(width, height or 45)
    return t
end
