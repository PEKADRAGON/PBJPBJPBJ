
-------- CLIENT ----------
screen = { guiGetScreenSize() }

resW, resH = 1365, 767

sx, sy = screen[1]/resW, screen[2]/resH

function aToR(X, Y, sX, sY)

    local xd = X/resW or X

    local yd = Y/resH or Y

    local xsd = sX/resW or sX

    local ysd = sY/resH or sY

    return xd * screen[1], yd * screen[2], xsd * screen[1], ysd * screen[2]
    
end

_dxDrawRectangle = dxDrawRectangle

function dxDrawRectangle(x, y, w, h, ...)

    local x, y, w, h = aToR(x, y, w, h)

    return _dxDrawRectangle(x, y, w, h, ...)

end

_dxDrawText = dxDrawText

function dxDrawText(text, x, y, w, h, ...)

    local x, y, w, h = aToR(x, y, w, h)

    return _dxDrawText(text, x, y, w + x, h + y, ...)

end

_dxDrawImage = dxDrawImage

function dxDrawImage(x, y, w, h, ...)

    local x, y, w, h = aToR(x, y, w, h)

    return _dxDrawImage(x, y, w, h, ...)

end

_dxCreateFont = dxCreateFont

function dxCreateFont( filePath, size, ... )

    return _dxCreateFont( filePath, ( sx * size ), ... )

end



Event =
function( sEventName, pElementAttachedTo, func )
    if type( sEventName ) == 'string' and isElement( pElementAttachedTo ) and type( func ) == 'function' then
        local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
        if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
            for i, v in ipairs( aAttachedFunctions ) do
                if v == func then
                    return true
                end
            end
        end
    end
    return false
end

Cursor = 
function(x,y,w,h)
    local x, y, w, h = aToR(x, y, w, h)
    if isCursorShowing() then
        local mx, my = getCursorPosition()
        local resx, resy = guiGetScreenSize()
        mousex, mousey = mx * resx, my * resy
        if mousex > x and mousex < x + w and mousey > y and mousey < y + h then
            return true
        else
            return false
        end
    end
end

dxTextCenter =
function(text, x, y, w, h, color, scale, font)
    local Width = dxGetTextWidth(text, scale, font)
    local Height = dxGetFontHeight(scale, font)
    local PosX = (x + (w/2)) - (Width/2)
    local PosY = (y + (h/2)) - (Height/2)
    dxDrawText(text, PosX, PosY, 0, 0, color, scale, font)
end

--
local buttons = {}

function drawRect(x, y, width, height, radius, color, colorStroke, sizeStroke, postGUI)
    colorStroke = tostring(colorStroke)
    sizeStroke = tostring(sizeStroke)

    if (not buttons[radius]) then
        local raw = string.format([[
            <svg width='%s' height='%s' fill='none' xmlns='http://www.w3.org/2000/svg'>
                <mask id='path_inside' fill='#FFFFFF' >
                    <rect width='%s' height='%s' rx='%s' />
                </mask>
                <rect opacity='1' width='%s' height='%s' rx='%s' fill='#FFFFFF' stroke='%s' stroke-width='%s' mask='url(#path_inside)'/>
            </svg>
        ]], width, height, width, height, radius, width, height, radius, colorStroke, sizeStroke)
        buttons[radius] = svgCreate(width, height, raw)
    end
    if (buttons[radius]) then -- Se já existir um botão com o mesmo Radius, reaproveitaremos o mesmo, para não criar outro.
        dxDrawImage(x, y, width, height, buttons[radius], 0, 0, 0, color, postGUI)
    end
end

getFont = function(dir, size, ...)
    if fileExists(dir) and tonumber(size) then
        if not fonts[dir] then
            fonts[dir] = {};
        end

        if fonts[dir][size] then
            return fonts[dir][size]
        else
            fonts[dir][size] = dxCreateFont(dir, size, false, "cleartype_natural");
            return fonts[dir][size];
        end
    end
    return "default";
end

convertNumber = function ( number )   
    local formatted = number   
    while true do       
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2')     
        if ( k==0 ) then       
            break   
        end   
    end   
    return formatted 
end

getTimeLeft = function(timer)
    if isTimer(timer) then
        local ms = getTimerDetails(timer)
        local m = math.floor(ms/60000)
        local s = math.floor((ms-m*60000)/1000)
        if m < 10 then m = "0"..m end
        if s < 10 then s = "0"..s end
        return m..":"..s
    end
end