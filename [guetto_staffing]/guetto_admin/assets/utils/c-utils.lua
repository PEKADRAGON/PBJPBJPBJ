functions = {};

--[[
    Rendering calculations
--]]

local screenW, screenH = guiGetScreenSize();
local screenScale = math.min(math.max(screenH / 1080, 0.70), 2); -- Caso o painel seja muito grande, retirar o limite e deixar apenas o (screenH / 768).

local parentW, parentH = (1357 * screenScale), (900 * screenScale); -- Comprimento e Largura do painel.
local parentX, parentY = ((screenW - parentW) / 2), ((screenH - parentH) / 2); -- Posição X e Y do painel.

--[[
    Useful rendering functions
--]]

functions.isCursorOnElement = function(x, y, width, height)
    x, y, width, height = functions.respX(x), functions.respY(y), functions.respC(width), functions.respC(height);
    if (not isCursorShowing()) then
        return false
    end

    local cX, cY = getCursorPosition();
    local cX, cY = (cX * screenW), (cY * screenH);
    local cursorX, cursorY = cX, cY;
    return (
        (cX >= x and cX <= x + width) and 
        (cY >= y and cY <= y + height)
    );
end

local _dxDrawImageSection = dxDrawImageSection;
function dxDrawImageSection(x, y, width, height, u, v, uSize, vSize, ...)
    return _dxDrawImageSection(functions.respX(x), functions.respY(y), functions.respC(width), functions.respC(height), 0, 0, uSize, vSize, ...);
end

_dxDrawText = dxDrawText;
function dxDrawText(text, x, y, width, height, ...)
    return _dxDrawText(text, functions.respX(x), functions.respY(y), (functions.respX(x) + functions.respC(width)), (functions.respY(y) + functions.respC(height)), ...);
end

local _dxDrawRectangle = dxDrawRectangle;
function dxDrawRectangle(x, y, width, height, ...)
    return _dxDrawRectangle(functions.respX(x), functions.respY(y), functions.respC(width), functions.respC(height), ...);
end

local _dxDrawImage = dxDrawImage;
function dxDrawImage(x, y, width, height, ...)
    return _dxDrawImage(functions.respX(x), functions.respY(y), functions.respC(width), functions.respC(height), ...);
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

local _dxDrawImageSpacing = dxDrawImageSpacing;
function dxDrawImageSpacing(x, y, width, height, spacing, ...)
	local padding = spacing * 2

	return dxDrawImage(x - spacing, y - spacing, width + padding, height + padding, ...)
end

local fonts = {}
function getFont(font, size)
    local index = font .. size

    if not fonts[index] then
        fonts[index] = dxCreateFont('assets/fonts/' .. font .. '.ttf', size)
    end

    return fonts[index]
end

functions.respX = function(x)
    return (parentX + (x * screenScale));
end

functions.respY = function(y)
    return (parentY + (y * screenScale));
end

functions.respC = function(scale)
    return (scale * screenScale);
end

function convertNumber(amount)
    local left, center, right = string.match(math.floor(amount), '^([^%d]*%d)(%d*)(.-)$')
    return left .. string.reverse(string.gsub(string.reverse(center), '(%d%d%d)', '%1.')) .. right
end

function formatSeconds (segundos)
    local minutos = math.floor(segundos / 60)
    local segundosRestantes = segundos % 60
    return string.format("%02d:%02d", minutos, segundosRestantes)
end

function mathfloorcustom(valor)
    if string.len(valor) >= 1 then 
        local part1 = string.sub(valor, 1, 1)
        local part2 = string.sub(valor, 2, 6)
        if string.len(valor) == 1 then
            return ("0."..part1)
        else
            return (part1..part2)
        end
    end
    return tonumber(valor)
end

function timestampToDateString(timestamp)
    local timeData = getRealTime(timestamp)
    local day = string.format("%02d", timeData.monthday)
    local month = string.format("%02d", timeData.month + 1)
    local year = timeData.year + 1900

    return day .. "/" .. month .. "/" .. year
end

function registerEvent(event, element, callback)
    addEvent(event, true)
    addEventHandler(event, element, callback)
end