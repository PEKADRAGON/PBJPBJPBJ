local resolutionConfig = {1920, 1080}
screen = Vector2 (guiGetScreenSize ())
local screenScale = math.min(math.max(0.80, screen.y / resolutionConfig[2]), 2)

function setScreenPosition (resolution, x, y, w, h)
    return (
        screen.x/resolution[1]*x),
        (screen.y/resolution[2]*y),
        (screen.x/resolution[1]*w),
        (screen.y/resolution[2]*h
    )
end

local textures = {
    image = {},
}

_dxDrawImageSpacing = dxDrawImageSpacing
_dxDrawImage = dxDrawImage
_dxDrawRectangle = dxDrawRectangle
_dxDrawLine = dxDrawLine
_dxDrawImageSection = dxDrawImageSection
_dxDrawText = dxDrawText
_dxCreateFont = dxCreateFont

function dxDrawImage (x, y, w, h, path, ...)
    local x, y, w, h = setScreenPosition(resolutionConfig, x, y, w, h)
    return _dxDrawImage(x, y, w, h, path, ...)
end

function dxDrawImageSpacing(x, y, width, height, spacing, ...)
	local padding = spacing * 2

	return dxDrawImage(x - spacing, y - spacing, width + padding, height + padding, ...)
end

function dxDrawImageSection(x, y, w, h, ...)
    local x, y, w, h = setScreenPosition(resolutionConfig, x, y, w, h)
    return _dxDrawImageSection (x, y, w, h, ...)
end

function dxDrawRectangle (x, y, w, h, ...)
    local x, y, w, h = setScreenPosition(resolutionConfig, x, y, w, h)

    return _dxDrawRectangle(x, y, w, h, ...)
end

function dxDrawLine(x, y, w, h, ...)
    local x, y, w, h = setScreenPosition(resolutionConfig, x, y, w, h)

    return _dxDrawLine(x, y, w, h, ...)
end

function dxDrawText (text, x, y, w, h, ...)
    local x, y, w, h = setScreenPosition(resolutionConfig, x, y, w, h)
    
    return _dxDrawText(tostring(text), x, y, (x + w), (y + h), ...)
end

function isCursorOnElement (x, y, w, h)
    local x, y, w, h = screen.x/resolutionConfig[1]*x, screen.y/resolutionConfig[2]*y, screen.x/resolutionConfig[1]*w, screen.y/resolutionConfig[2]*h  

    local mouse = Vector2(getCursorPosition())
    local cx, cy = (mouse.x * screen.x), (mouse.y * screen.y) 

    return (cx > x and cx < x + w and cy > y and cy < y + h)
end

svgsRectangle = {};
function dxDrawRoundedRectangle(x, y, w, h, radius, color, post)
    if not svgsRectangle[radius] then
        svgsRectangle[radius] = {}
    end
    if not svgsRectangle[radius][w] then
        svgsRectangle[radius][w] = {}
    end
    if not svgsRectangle[radius][w][h] then
        local Path = string.format([[
        <svg width="%s" height="%s" viewBox="0 0 %s %s" fill="none" xmlns="http://www.w3.org/2000/svg">
        <rect opacity="1" width="%s" height="%s" rx="%s" fill="#FFFFFF"/>
        </svg>
        ]], w, h, w, h, w, h, radius)
        svgsRectangle[radius][w][h] = svgCreate(w, h, Path)
    end
    if svgsRectangle[radius][w][h] then
        dxDrawImage(x, y, w, h, svgsRectangle[radius][w][h], 0, 0, 0, color, post or false)
    end
end
