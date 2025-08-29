--> Resolution:
screen = Vector2 (guiGetScreenSize ())
screenBase = Vector2 (1920, 1080)

local textures = {image = {}, font = {}}

function setScreenPosition (x, y, w, h)
    local x, y, w, h = math.ceil (x), math.ceil (y), math.ceil (w), math.ceil (h)
    return (
        (x / screenBase.x) * screen.x),
        ((y / screenBase.y) * screen.y),
        ((w / screenBase.x) * screen.x),
        ((h / screenBase.y) * screen.y
    )
end;


addEventHandler("onClientRender", root,
	function()
		setPedControlState("walk", true)
	end  
)

_dxDrawRectangle = dxDrawRectangle
dxDrawRectangle = function (x, y, w, h, ...)
    if (not x or not y or not w or not h) then
        return false;
    end;
    local x, y, w, h = setScreenPosition (x, y, w, h);
    return _dxDrawRectangle (x, y, w, h, ...);
end;

_dxDrawImage = dxDrawImage
dxDrawImage = function (x, y, w, h, path, ...)
    if (not x or not y or not w or not h) then
        return false;
    end;
    if (type (path) == 'string') then
        if (not textures['image'][path]) then
            textures['image'][path] = dxCreateTexture (path, 'argb', false, 'clamp');
        end;
        path = textures['image'][path];
    end;
    local x, y, w, h = setScreenPosition (x, y, w, h);
    return _dxDrawImage (x, y, w, h, path, ...);
end;

_dxDrawText = dxDrawText
dxDrawText = function (text, x, y, w, h, ...)
    if (not text or not x or not y or not w or not h) then
        return false;
    end;
    local x, y, w, h = setScreenPosition (x, y, w, h);
    return _dxDrawText (text, x, y, (x + w), (y + h), ...)
end;

_dxDrawLine = dxDrawLine
dxDrawLine = function (x, y, w, h, ...)
    local x, y, w, h = setScreenPosition (x, y, w, h);
    return _dxDrawLine (x, y, w, h, ...);
end;

_dxCreateFont = dxCreateFont
dxCreateFont = function (path, size, ...)
    local _, scale, _, _ = setScreenPosition (0, size, 0, 0)

    if (not textures['font'][path]) then
        textures['font'][path] = {};
    end;
    if (not textures['font'][path][size]) then
        textures['font'][path][size] = _dxCreateFont (path, scale, ...);
    end;
    return textures['font'][path][size];
end;

_dxDrawImageSection = dxDrawImageSection
dxDrawImageSection = function (x, y, w, h, ...)
    local x, y, w, h = setScreenPosition (x, y, w, h)
    return _dxDrawImageSection (x, y, w, h, ...)
end;

_getCursorPosition = getCursorPosition
getCursorPosition = function ()
    local cursor = Vector2 (_getCursorPosition ());
    return (math.ceil (cursor.x * screenBase.x)), (math.ceil (cursor.y * screenBase.y));
end;

isCursorOnElement = function (x, y, w, h)
    if (not x or not y or not w or not h) then
        return false;
    end;

    local x, y, w, h = setScreenPosition (x, y, w, h);
    local mouse = Vector2 (_getCursorPosition ());
    local cx, cy = (mouse.x * screen.x), (mouse.y * screen.y);
    return (cx > x and cx < x + w and cy > y and cy < y + h);
end;

local interpolateData = {}

lerp = function (a, b, t) 
    return (a * (1 - t) + b * t)
end

interpolate = function (start, finish, duration, index)
    if (not interpolateData[index]) then
        interpolateData[index] = start;
    end;
    interpolateData[index] = lerp (interpolateData[index], finish, duration)
    return interpolateData[index];
end;

local RawData = {}

function dxDrawSVG (x, y, w, h, raw, ...)
    if not RawData[raw] then
        RawData[raw] = svgCreate (w, h, raw)
    end
    dxSetBlendMode ('add')
    dxDrawImage (x, y, w, h, RawData[raw], ...)
    dxSetBlendMode ('blend')
end

function destroyElementSVG ()
    for index, value in pairs(RawData) do 
        if value and isElement(value) then 
            destroyElement(value)
        end
    end
    RawData = { }
end