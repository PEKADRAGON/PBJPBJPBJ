animations = {};
fadeAnimation = {};

-- resolution's code.
screen = Vector2 (guiGetScreenSize ());
middle = Vector2 (screen.x / 2, screen.y / 2);
scale = math.min (1.2, math.max (0.8, (screen.y / 1080)));

_dxCreateFont = dxCreateFont;
_dxDrawText = dxDrawText;
_dxDrawImage = dxDrawImage;
_dxDrawImageSection = dxDrawImageSection;
_dxSetBlendMode = dxSetBlendMode;

local cache = {};
cache.font = {};
cache.image = {};
cache.svg = {};
cache.interpolates = {};

function dxDrawText (text, x, y, w, h, ...)
    return _dxDrawText (text, x, y, w + x, h + y, ...);
end

function dxCreateFont (directory, size, ...)
    if not (cache.font[directory]) then
        cache.font[directory] = {};
    end

    if not (cache.font[directory][size]) then
        cache.font[directory][size] = _dxCreateFont (directory, (size * scale) * (72 / 96), ...);
    end

    return cache.font[directory][size];
end

function dxDrawImage (x, y, width, height, directory, ...)
    if (isElement (directory) or cache.image[directory]) then
        return _dxDrawImage (x, y, width, height, (cache.image[directory] and cache.image[directory] or directory), ...)
    end

    if not (cache.image[directory]) then
        cache.image[directory] = dxCreateTexture (directory, 'argb', false, 'wrap')
    end

    return _dxDrawImage (x, y, width, height, cache.image[directory], ...)
end

function dxDrawImageSection (x, y, width, height, u, v, uWidth, vHeight, directory, ...)
    if (isElement (directory) or cache.image[directory]) then
        return _dxDrawImageSection (x, y, width, height, u, v, uWidth, vHeight, (cache.image[directory] and cache.image[directory] or directory), ...)
    end

    if not (cache.image[directory]) then
        cache.image[directory] = dxCreateTexture (directory, 'argb', false, 'wrap')
    end

    return _dxDrawImageSection (x, y, width, height, u, v, uWidth, vHeight, cache.image[directory], ...)
end

function dxSetBlendMode (mode)
    if (hasAnimationRunning) then
        return false;
    end

    _dxSetBlendMode (mode);
end

function isCursorOnElement (x, y, width, height)
    if not (isCursorShowing ()) then
        return false;
    end
    
    local cursor = {getCursorPosition ()};
    local cursorx, cursory = (cursor[1] * screen.x), (cursor[2] * screen.y);
    
    return (cursorx >= x and cursorx <= (x + width) and cursory >= y and cursory <= (y + height));
end

-- interpolate's code.
function lerp (a, b, t)
    return a + (b - a) * t;
end

function interpolate (start, finish, time, index)
    if not (cache.interpolates[index]) then
        cache.interpolates[index] = start;
    end

    cache.interpolates[index] = lerp (cache.interpolates[index], finish, time);
    return cache.interpolates[index];
end

-- animation's code.
animation = {
    new = function (identify, initial, finish, duration, easing, capture)
        if (animations[identify]) then
            error ('Animation "' .. identify .. '" already exists.');

            return false;
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

-- button's code.
button = {
    exec = function (id, duration, r2, g2, b2, alpha, verify)
        if not (fadeAnimation[id]) then
            fadeAnimation[id] = {id = id, duration = duration, alpha = alpha, r = r2, g = g2, b = b2, lastR = r2, lastG = g2, lastB = b2, lastA = alpha, tick = nil};
        end
    
        if (r2 ~= fadeAnimation[id].lastR or g2 ~= fadeAnimation[id].lastG or b2 ~= fadeAnimation[id].lastB or alpha ~= fadeAnimation[id].lastA) then
            fadeAnimation[id].tick = getTickCount ();
            fadeAnimation[id].lastR = r2;
            fadeAnimation[id].lastG = g2;
            fadeAnimation[id].lastB = b2;
            fadeAnimation[id].lastA = alpha;
    
        elseif (fadeAnimation[id].r == r2 and fadeAnimation[id].g == g2 and fadeAnimation[id].b == b2 and fadeAnimation[id].alpha == alpha) then
            fadeAnimation[id].tick = nil;
        end
    
        if (fadeAnimation[id].tick) then
            local interpolate = {interpolateBetween (fadeAnimation[id].r, fadeAnimation[id].g, fadeAnimation[id].b, r2, g2, b2, (getTickCount () - fadeAnimation[id].tick) / fadeAnimation[id].duration, 'Linear')};
            local interpolateAlpha = interpolateBetween (fadeAnimation[id].alpha, 0, 0, alpha, 0, 0, (getTickCount () - fadeAnimation[id].tick) / fadeAnimation[id].duration, 'Linear');
    
            fadeAnimation[id].r = interpolate[1];
            fadeAnimation[id].g = interpolate[2];
            fadeAnimation[id].b = interpolate[3];
            fadeAnimation[id].alpha = interpolateAlpha;
        end
    
        if (verify and ((verify > 0 and verify < 255) and true or false) or false) then
            fadeAnimation[id].alpha = alpha;
        end
    
        return tocolor (fadeAnimation[id].r, fadeAnimation[id].g, fadeAnimation[id].b, fadeAnimation[id].alpha);
    end;
};