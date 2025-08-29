function math.round(number, decimals, method)
    decimals = decimals or 0;
    local factor = 10 ^ decimals;
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor;
    else return tonumber(("%."..decimals.."f"):format(number)); end
end

function formatNumber(number) 
    while true do      
        number, k = string.gsub(number, "^(-?%d+)(%d%d%d)", '%1.%2');
        if (k == 0) then      
            break;
        end  
    end  
    return number;
end

_getPlayerName = getPlayerName;
function getPlayerName(element)
    return _getPlayerName(element):gsub("#%x%x%x%x%x%x", "") or _getPlayerName(element);
end

-- Render functions;

local pS = {guiGetScreenSize()};
local x, y = (pS[1]/1360), (pS[2]/768);

local _dxDrawText = dxDrawText;
function dxDrawText(text, pX, pY, w, h, color, size, ...)
    local pX, pY, w, h = pX, pY, (pX + w), (pY + h);
    return _dxDrawText(text, x * pX, y * pY, x * w, y * h, color, x * size, ...);
end

local _dxDrawRectangle = dxDrawRectangle;
function dxDrawRectangle(pX, pY, w, h, ...)
    return _dxDrawRectangle(x * pX, y * pY, x * w, y * h, ...);
end

local _dxDrawImage = dxDrawImage;
function dxDrawImage(pX, pY, w, h, ...)
    return _dxDrawImage(x * pX, y * pY, x * w, y * h, ...);
end

local _guiCreateEdit = guiCreateEdit;
function guiCreateEdit(pX, pY, w, h, ...)
    return _guiCreateEdit(x - pX, y - pY, w, h, ...);
end

function isCursorOnElement(posX, posY, width, height)
    if (isCursorShowing()) then
        local posX, posY, width, height = x * posX, y * posY, x * width, y * height;
        local MouseX, MouseY = getCursorPosition();
        local clientW, clientH = guiGetScreenSize();
        local MouseX, MouseY = MouseX * clientW, MouseY * clientH
        if (MouseX > posX and MouseX < (posX + width) and MouseY > posY and MouseY < (posY + height)) then
            return true;
        end
    end
    return false;
end