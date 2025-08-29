screenW, screenH = guiGetScreenSize()
sx, sy = (screenW/1920), (screenH/1080)

local cache = {}

cache.font = {}

_dxCreateFont = dxCreateFont;

function dxCreateFont (directory, size, ...)
    if not (cache.font[directory]) then
        cache.font[directory] = {};
    end

    if not (cache.font[directory][size]) then
        cache.font[directory][size] = _dxCreateFont ('fonts/'..(directory)..'.ttf', (size * sy) * (72 / 96), ...);
    end

    return cache.font[directory][size] or 'default';
end