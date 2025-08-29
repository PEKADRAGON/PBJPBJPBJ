local screenWidth, screenHeight = guiGetScreenSize()
local screenScale = math.max(screenHeight / 1080, 0.65)

local _dxDrawText = dxDrawText
function dxDrawText(t, x, y, w, h, ...)
    return _dxDrawText(t, x, y, w + x, h + y, ...)
end

local _dxCreateFont = dxCreateFont
function dxCreateFont(path, size)
    local newSize = (size + 3) * (72 / 96)
    return _dxCreateFont(path, newSize)
end

function respc(value)
    return value * screenScale
end

function getResponsiveValues()
    return screenWidth, screenHeight, screenScale
end