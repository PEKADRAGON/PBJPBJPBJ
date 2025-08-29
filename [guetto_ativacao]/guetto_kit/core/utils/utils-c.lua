--| Vars

screenW, screenH = guiGetScreenSize()
sx, sy = (screenW/1920), (screenH/1080)

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


-- Interpolate:
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

local animations = {}

function CreateThread(callback)
    local thread = coroutine.create(callback)
    local function resume()
        local status, result = coroutine.resume(thread)
        if (not status) then error(result, 2) end
        if (coroutine.status(thread) ~= 'dead') then
            setTimer(resume, 0, 1)
        end
    end
    resume()
end

-- Animation:
animation = {
    new = function (identify, initial, finish, duration, easing, capture)
        if (animations[identify]) then

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

-- Button:
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

-- Editbox:
local editbox = {};

function dxCreateEditbox (Id, Position, MaxCharacters, Color, Font, Placeholder, hasLine, isPassword, isNumber, hasBlock, hasLeft)
    if (not editbox[Id]) then
        editbox[Id] = {
            Position = Position;
            MaxCharacters = MaxCharacters;
            Color = Color;
            Font = (Font or 'default');
            Placeholder = Placeholder;
            Text = '';
            isPassword = isPassword;
            isNumber = isNumber;
            hasLine = hasLine;
            hasSelect = false;
            hasPressed = nil;
            hasBlock = hasBlock;
        }
    end
    local values = editbox[Id];
    values['Color'] = Color
    values['Position'] = Position
    local x, y, w, h = unpack(values['Position']);
    local text = (values['isPassword'] and #values['Text'] > 0 and string.gsub(values['Text'], '.', '•') or (values['hasSelect'] and values['Text'] and values['Text'] or (#values['Text'] > 0 and values['Text'] or values['Placeholder'])));
    
    local colorText = (
        not values.hasSelect and values['Color'][2] or #values.Text==0 and values['Color'][2] or values['Color'][1]
    )

    dxDrawText(text, x, y, w, h, tocolor(212, 214, 225, 0.32 * 255), 1.00, values["Font"], "center", "center", true);
    -- if (values['hasLine']) then
        -- if (values['hasSelect'] and #values['Text'] > 0) then
            -- local width, heigth = dxGetTextSize(text, 0, 1.0, 1.0, values['Font'], false, false);
            -- dxDrawLine(x + (width) + (1), y + (heigth) - (8), x + (width) + (1), y + (heigth*2) - 2, _tocolor(255, 255, 255, math.abs(math.sin(getTickCount()/800) * 255)), 1, false);
        -- end
    -- end
    if (values['hasPressed'] and getTickCount() >= values['hasPressed'] + 500) then
        if ((#values['Text'] - 1) >= 0) then
            values['Text'] = string.sub(values['Text'], 1, (#values['Text'] - 1));
        end
    end
end

-- Click:
addEventHandler('onClientClick', getRootElement(), function(btn, state)
    if (not isCursorShowing()) then
        return false;
    end
    if (btn == 'left' and state == 'down') then
        dxDisableSelects();
        for Id, Value in pairs(editbox) do
            if (isCursorOnElement(unpack(Value['Position']))) then
                if (Value['hasBlock']) then return end;
                Value['hasSelect'] = true;
                return true;
            end
        end
    end
end)

function dxEditBoxEnable (identify)
    if editbox[identify] then 
        return editbox[identify].hasPressed
    end
    return false
end

-- Digitar:
addEventHandler('onClientCharacter', getRootElement(), function(character)
    if (not isCursorShowing()) then
        return false;
    end
    if (character) then
        for Id, Value in pairs(editbox) do
            if (Value['hasSelect']) then
                if (#Value['Text'] + 1 <= Value['MaxCharacters']) then
                    if (Value['isNumber']) then
                        if (tonumber(character)) then
                            if #Value.Text == 0 and character == '0' then
                                return
                            end
                            Value['Text'] = Value['Text']..character;
                            return
                        end
                    else
                        Value['Text'] = Value['Text']..character;
                        return  
                    end
                end
            end
        end
    end
end)

-- Disable Selects:
function dxDisableSelects()
    for Id, Value in pairs(editbox) do
        Value['hasSelect'] = false;
        Value['hasPressed'] = nil;
    end
    return true;
end

-- Backspace:
addEventHandler ('onClientKey', getRootElement(), function(key, press)
    if (key == 'backspace') then
        for Id, Value in pairs(editbox) do
            if (Value['hasSelect']) then
                if (press) then
                    if ((#Value['Text'] - 1) >= 0) then
                        Value['Text'] = string.sub(Value['Text'], 1, (#Value['Text'] - 1));
                        Value['hasPressed'] = getTickCount();
                    end
                else
                    Value['hasPressed'] = false;
                end
            end
        end
    end
end)

-- Editbox Functions:
function dxEditboxSetText (identify, newText) -- Função para alterar o texto da editbox.
    if (not identify or not editbox[identify]) then
        return false
    end
    if (not newText or type(newText) ~= 'string' or #newText == 0) then
        return false
    end
    editbox[identify]['Text'] = newText;
    return true;
end

function dxEditboxGetText (identify) -- Função para obter o texto da editbox.
    if (not identify or not editbox[identify]) then
        return
    end
    return {content = (editbox[identify]['isNumber'] and tonumber(editbox[identify]['Text']) or tostring(editbox[identify]['Text'])), type = type(editbox[identify]['Text']), len = string.len(tostring(editbox[identify]['Text']))};
end

function dxEditShowPassword(identify, toggle) -- Função para manipular a visualização da opção 'password' da editbox.
    if (not identify or not editbox[identify]) then
        return false
    end
    if (not toggle or type(toggle) ~= 'boolean') then
        return false
    end
    editbox[identify]['isPassword'] = toggle;
    return true;
end

function dxEditGetPasswordState (identify) -- Função para obter o valor 'boolean' da opção 'password' da editbox.
    if (not identify or not editbox[identify]) then
        return false
    end
    return editbox[identify]['isPassword'];
end

function dxEditboxForceSelect (identify) -- Função para forçar o client a selecionar a editbox prédefinida.
    if (not identify or not editbox[identify]) then
        return false
    end
    dxDisableSelects ();
    editbox[identify]['hasSelect'] = true;
    return true;
end

function dxEditboxDestroy (identify) -- Função para destroir a editbox.
    if (not identify or not editbox[identify]) then
        return false
    end
    dxDisableSelects();
    editbox[identify] = nil;
    return true;
end

function isEdtiSelected (identify)
    if (not identify or not editbox[identify]) then
        return false
    end
    return editbox[identify]['hasSelect']
end

function dxEditboxSetBlock (identify, toggle) -- Função para manipular o bloqueio da editbox.
    if (not identify or not editbox[identify]) then
        return false
    end
    if (not toggle or type (toggle) ~= 'boolean') then
        return false
    end
    dxDisableSelects();
    editbox[identify]['hasBlock'] = toggle;
    return true;
end

function dxEditboxGetBlock (identify) -- Função para obter o valor 'boolean' da opção 'hasBlock' da editbox.
    if (not identify or not editbox[identify]) then
        return false
    end
    return editbox[identify]['hasBlock'];
end

function dxEditboxDestroyAll ()
    for i, v in pairs (editbox) do
        dxEditboxDestroy(i)
    end
end

addEventHandler ('onClientPaste', root, function (...)
    for i, v in pairs (editbox) do
        if v.hasSelect then
            if v.Text:len ( ) + tostring (...):len ( ) <= v.MaxCharacters then
                v.Text = v.Text..tostring (...)
                return
            end
        end
    end
end)

-- Svg:
local vectors = {};
local svg = {};
local ITEMS_CACHE = {};

function createVector(width, height, rawData)
    local svg = svgCreate(width, height, rawData)
    local svgXML = svgGetDocumentXML(svg)
    local rect = xmlFindChild(svgXML, "rect", 0)

    return {
        svg = svg,
        xml = svgXML,
        rect = rect
    }
end

function createCircleStroke(id, width, height, sizeStroke)
    if (not id) then
        error('Defina um identificador para o elemento SVG.', 2)
    end

    if (not vectors[id]) then
        width = width or 1
        height = height or 1
        sizeStroke = sizeStroke or 2
    
        local radius = math.min(width, height) / 2
        local borderLenght = (2 * math.pi) * radius
        local newW, newH = width + (sizeStroke * 2), height + (sizeStroke * 2)
        local dashoffset = borderLenght - ((borderLenght / 100) * 0)
        
        local rawData = string.format([[
            <svg width="%s" height="%s" xmlns="http://www.w3.org/2000/svg">
                <rect x="%s" y="%s" rx="%s" width="%s" height="%s" fill="#FFFFFF" fill-opacity="0" stroke="#FFFFFF" 
                stroke-width="%s" stroke-dasharray="%s" stroke-dashoffset="%s" stroke-linejoin="round" stroke-linecap="round" />
            </svg>
        ]], newW, newH, sizeStroke, sizeStroke, radius, width, height, sizeStroke, borderLenght, dashoffset)
        local svg = createVector(width, height, rawData)

        local attributes = {
            type = 'rect-stroke',
            borderLenght = borderLenght,
            width = width,
            height = height,
            svgDetails = svg
        }

        if not ITEMS_CACHE[id] then
            ITEMS_CACHE[id] = {false, 0, getTickCount()}
        end
        vectors[id] = attributes
    end
    return vectors[id]
end

function createCircle(id, width, height)
    if (not id) then
        error('Defina um identificador para o elemento SVG.', 2)
    end

    if (not vectors[id]) then
        width = width or 1
        height = height or 1

        -- local radius = height / 2
        local radius = height / 2

        local rawData = string.format([[
            <svg width="%s" height="%s" xmlns="http://www.w3.org/2000/svg">
                <rect rx="%s" width="%s" height="%s" fill="#FFFFFF" />
            </svg>
        ]], width, height, radius, width, height)
        local svg = createVector(width, height, rawData)

        local attributes = {
            type = 'rect',
            borderLenght = borderLenght,
            width = width,
            height = height,
            svgDetails = svg
        }
        vectors[id] = attributes
    end
    return vectors[id]
end

function setOffset(id, value)
    local svg = vectors[id]
    if (not svg) then
        error("Nenhum elemento SVG foi encontrado.", 2)
    end
    if (svg.type ~= 'rect-stroke') then return end
    if (ITEMS_CACHE[id][2] ~= value) then
        if (not ITEMS_CACHE[id][1]) then
            ITEMS_CACHE[id][3] = getTickCount()
            ITEMS_CACHE[id][1] = true
        end

        local progress = (getTickCount() - ITEMS_CACHE[id][3]) / 1000
        ITEMS_CACHE[id][2] = interpolateBetween(ITEMS_CACHE[id][2], 0, 0, value, 0, 0, progress, "OutQuad")
        
        if (progress > 1) then
            ITEMS_CACHE[id][3] = nil
            ITEMS_CACHE[id][1] = false
        end

        local rect = svg.svgDetails.rect
        local newBorderLenght = svg.borderLenght - (svg.borderLenght/100 * ITEMS_CACHE[id][2])

        xmlNodeSetAttribute(rect, "stroke-dashoffset", newBorderLenght)
        svgSetDocumentXML(svg.svgDetails.svg, svg.svgDetails.xml)
    elseif (ITEMS_CACHE[id][1]) then
        ITEMS_CACHE[id][1] = false
    end
end

function drawItem(id, x, y, color, rot)
    local svg = vectors[id]
    if (not svg) then
        error("Nenhum elemento SVG foi encontrado.", 2)
    end

    postGUI = postGUI or false
    local width, height = vectors[id].width, vectors[id].height

    --dxSetBlendMode("add")
        dxDrawImage(x, y, width, height, svg.svgDetails.svg, (rot and rot or 215), 0, 0, color)
    --dxSetBlendMode("blend")
end