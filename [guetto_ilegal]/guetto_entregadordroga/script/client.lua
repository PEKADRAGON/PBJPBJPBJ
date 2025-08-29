

-- Resolution:
local screen = Vector2 (guiGetScreenSize ())


function setScreenPosition (x, y, w, h)
    return (
        (x / 1920) * screen.x),
        ((y / 1080) * screen.y),
        ((w / 1920) * screen.x),
        ((h / 1080) * screen.y
    )
end

local textures = {
    image = {},
    font = {}
}

_dxDrawImage = dxDrawImage
_dxDrawRectangle = dxDrawRectangle
_dxDrawImageSection = dxDrawImageSection
_dxDrawText = dxDrawText
_dxCreateFont = dxCreateFont

function dxCreateFont (path, size, ...)
    local _, scale, _, _ = setScreenPosition(0, size, 0, 0)

    if not textures.font[path] then
        textures.font[path] = {}
    end

    if not textures.font[path][size] then
        textures.font[path][size] = _dxCreateFont(
            path,
            scale,
            ...
        )
    end

    return textures.font[path][size]
end

function dxDrawText (text, x, y, w, h, ...)
    local x, y, w, h = setScreenPosition(x, y, w, h)
    
    return _dxDrawText(tostring(text), x, y, (x + w), (y + h), ...)
end

local Inter_regular = dxCreateFont("font/Inter-Regular.ttf", 12)
local Inter_Medium = dxCreateFont("font/Inter-Medium.ttf", 12)

addEventHandler("onClientPedDamage", root, function()
    if getElementData(source, "TS.Ped") then
        cancelEvent()
    end
end)


addEventHandler('onClientRender', root, function()
    local x, y, z = getElementPosition(localPlayer)
    for i, vision in pairs(getElementsWithinRange(x, y, z, 5, 'ped')) do
        if (getElementData(vision, "TS.Ped")) then 
            local drugs = getElementData(vision, 'MT.Pedinfo') or {}

            if drugs then
                local px, py, pz = getElementPosition(vision)
                local sx, sy = getScreenFromWorldPosition(px, py, pz + 1.1)
                
                if sx and sy then
                    _dxDrawText("Entregas de", sx, sy - 5, nil, nil, tocolor(255, 255, 255), 1, Inter_regular, 'center', 'center')
                    _dxDrawText(drugs["droga"], sx, sy + 10, nil, nil, tocolor(255, 255, 255, 155), 1, Inter_Medium, 'center', 'center')
                end
            end
        end
    end
end)
