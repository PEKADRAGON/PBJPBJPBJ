--| Vars

local screenW, screenH = guiGetScreenSize()
local sx, sy = (screenW/1920), (screenH/1080)

local cache = {};
cache.font = {};
cache.image = {};
cache.svg = {};
cache.interpolates = {};
local animations = {}

--/ Ator

function aToR(X, Y, sX, sY)
    local xd = X/1920 or X
    local yd = Y/1080 or Y
    local xsd = sX/1920 or sX
    local ysd = sY/1080 or sY
    return xd * screenW, yd * screenH, xsd * screenW, ysd * screenH
end

_dxDrawCircle = dxDrawCircle
function dxDrawCircle(x, y, w, h, ...)
    local x, y, w, h = aToR(x, y, w, h)
    return _dxDrawCircle(x, y, w, h, ...)
end

_dxDrawRectangle = dxDrawRectangle
function dxDrawRectangle(x, y, w, h, ...)
    local x, y, w, h = aToR(x, y, w, h)
    return _dxDrawRectangle(x, y, w, h, ...)
end

_dxDrawText = dxDrawText
function dxDrawText(text, x, y, w, h, ...)
    local x, y, w, h = aToR(x, y, w + x, h + y)
    return _dxDrawText(text, x, y, w, h, ...)
end


_dxDrawImage = dxDrawImage
function dxDrawImage(x, y, w, h, ...)
    local x, y, w, h = aToR(x, y, w, h)
    return _dxDrawImage(x, y, w, h, ...)
end

_dxDrawImageSection = dxDrawImageSection
function dxDrawImageSection(x, y, w, h, ...)
    local x, y, w, h = aToR(x, y, w, h)
    return _dxDrawImageSection(x, y, w, h, ...)
end

function isCursorOnElement (x, y, w, h)
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

--| SVG Rectangles

local svgRectangles = {}

function dxDrawRoundedRectangle(x, y, w, h, color, radius, post)
    if not svgRectangles[radius] then
        local Path = string.format([[
            <svg width="%s" height="%s" viewBox="0 0 %s %s" fill="none" xmlns="http://www.w3.org/2000/svg">
            <rect opacity="1" width="%s" height="%s" rx="%s" fill="#FFFFFF"/>
            </svg>
        ]], w, h, w, h, w, h, radius)
        svgRectangles[radius] = svgCreate(sx*w, sy*h, Path)
    end
    if svgRectangles[radius] then
        dxSetBlendMode("modulate_add")
        dxDrawImage(x, y, w, h, svgRectangles[radius], 0, 0, 0, color, post)
        dxSetBlendMode("blend")
    end
end

-- Animation:
animation = {
    new = function (identify, initial, finish, duration, easing, capture)
        if (animations[identify]) then
            error ('Animation "' .. identify .. '" already exists.');

            return animations[identify];
        end

        animations[identify] = {
            initial = initial;
            finish = finish;
            duration = duration;
            easing = easing;
            tick = 0;
            capture = capture;
        };

        return true;
    end;

    exec = function (identify, initial, finish, duration, easing)
        if not (animations[identify]) then
            error ('Animation "' .. identify .. '" does not exists.');

            return false;
        end

        animations[identify].initial = initial;
        animations[identify].finish = finish;
        animations[identify].duration = duration or animations[identify].duration;
        animations[identify].easing = easing or animations[identify].easing;
        animations[identify].tick = getTickCount ();

        return true
    end;

    get = function (identify)
        if not (animations[identify]) then
            error ('Animation "' .. identify .. '" does not exists.');

            return false;
        end

        local animation = animations[identify];
        local progress = (getTickCount () - animation.tick) / animation.duration;

        if (progress >= 1) then
            if (animation.capture) then
                hasAnimationRunning = false;
            end

            return animation.finish;
        end

        if (animation.capture) then
            hasAnimationRunning = true;
        end

        return interpolateBetween (animation.initial, 0, 0, animation.finish, 0, 0, progress, animation.easing);
    end;

    isRunning = function (identify)
        if not (animations[identify]) then
            error ('Animation "' .. identify .. '" does not exists.');

            return false;
        end

        local animation = animations[identify];
        local progress = (getTickCount () - animation.tick) / animation.duration;

        if not (progress >= 1) then
            return true;
        end

        return false;
    end;
};

