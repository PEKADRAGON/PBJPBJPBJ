functions = {};

--[[
    Rendering calculations
--]]

screenW, screenH = guiGetScreenSize();
local screenScale = math.min(math.max(screenH / 1080, 0.70), 2); -- Caso o painel seja muito grande, retirar o limite e deixar apenas o (screenH / 768).

local parentW, parentH = (1207 * screenScale), (800 * screenScale); -- Comprimento e Largura do painel.
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

local _dxDrawText = dxDrawText;
function dxDrawText(text, x, y, width, height, ...)
    return _dxDrawText(text, functions.respX(x), functions.respY(y), (functions.respX(x) + functions.respC(width)), (functions.respY(y) + functions.respC(height)), ...);
end

local _dxDrawRectangle = dxDrawRectangle;
function dxDrawRectangle(x, y, width, height, ...)
    return _dxDrawRectangle(functions.respX(x), functions.respY(y), functions.respC(width), functions.respC(height), ...);
end

local _dxDrawLine = dxDrawLine
function dxDrawLine(x1, y1, x2, y2, ...)
    return _dxDrawLine(functions.respX(x1), functions.respY(y1), functions.respX(x2), functions.respY(y2), ...)
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

local _dxDrawImage = dxDrawImage;
function dxDrawImage(x, y, width, height, ...)
    return _dxDrawImage(functions.respX(x), functions.respY(y), functions.respC(width), functions.respC(height), ...);
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
        fonts[index] = dxCreateFont('assets/fonts/' .. font .. '.ttf', size, false, "cleartype_natural")
    end

    return fonts[index]
end

local color_animation = {};

function colorAnimation(id, duration, r2, g2, b2, alpha, verify)
    if not color_animation[id] then
        color_animation[id] = {id = id, duration = duration, alpha = alpha, r = r2, g = g2, b = b2, lastR = r2, lastG = g2, lastB = b2, lastA = alpha, tick = nil}
    end
    if r2 ~= color_animation[id].lastR or g2 ~= color_animation[id].lastG or b2 ~= color_animation[id].lastB or alpha ~= color_animation[id].lastA then
        color_animation[id].tick = getTickCount()
        color_animation[id].lastR = r2
        color_animation[id].lastG = g2
        color_animation[id].lastB = b2
        color_animation[id].lastA = alpha
    elseif color_animation[id].r == r2 and color_animation[id].g == g2 and color_animation[id].b == b2 and color_animation[id].alpha == alpha then
        color_animation[id].tick = nil
    end
    if color_animation[id].tick then
        local interpolate = {interpolateBetween(color_animation[id].r, color_animation[id].g, color_animation[id].b, r2, g2, b2, (getTickCount() - color_animation[id].tick) / color_animation[id].duration, 'Linear')}
        local interpolateAlpha = interpolateBetween(color_animation[id].alpha, 0, 0, alpha, 0, 0, (getTickCount() - color_animation[id].tick) / color_animation[id].duration, 'Linear')

        color_animation[id].r = interpolate[1]
        color_animation[id].g = interpolate[2]
        color_animation[id].b = interpolate[3]
        color_animation[id].alpha = interpolateAlpha
    end
    if (verify and ((verify > 0 and verify < 1) and true or false) or false) then
        color_animation[id].alpha = alpha
    end
    return tocolor(color_animation[id].r, color_animation[id].g, color_animation[id].b, color_animation[id].alpha)
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

function createScrollBar (total, max, inicial, final, type)
    if string.lower(type) == 'y' then 
        screen2 = guiGetScreenSize()
        _,cy = getCursorPosition()
        inicial = (inicial*(screen2/1080)) / screen2
        final = (final*(screen2/1080)) / screen2 
    end  
    if cy >= (final) then 
        cy = (final)
    elseif cy <= (inicial) then 
        cy = (inicial)
    end             
    g = (screen2 *  (final)) - (screen2 * (inicial))   
    a = (screen2 *  cy) - (screen2 * (inicial))
    cursorYProgress = screen2 * (cy / (screen2/1080)) 
    proxPag = (total-max)/g*(a)
    return cursorYProgress, proxPag
end

function scrollBarMove(total, max, inicial, final, type, prox)
    if string.lower(type) == 'y' then 
    	screen2 = guiGetScreenSize()
        inicial = (inicial*(screen2/1080)) / screen2
        final = (final*(screen2/1080)) / screen2 
    end     
    cy = (((final-inicial)/(total-max))*prox)+inicial
    g = math.floor((screen2 *  (final)) - (screen2 * (inicial)))    
    a = math.floor((screen2 *  cy) - (screen2 * (inicial)))
    cursorYProgress = screen2 * (cy / (screen2/1080)) 
    return cursorYProgress
end

function getCountServices (service)
    if (not service) then
        return false;
    end
    if (not config.datas.services[service]) then
        return false;
    end
    local count = 0;
    for _, v in ipairs (getElementsByType ('player')) do
        if (getElementData (v, config.datas.services[service])) then
            count = count + 1;
        end
    end
    return count
end

function destroyElements ( )
    for _, value in pairs ( fonts ) do 
        if value and isElement(value) then 
            destroyElement(value)
        end
    end

    for index, value in pairs ( svgsRectangle ) do 
        if value and isElement(value) then 
            destroyElement(value)
        end
    end

    svgsRectangle = {}
    fonts = {}
end;