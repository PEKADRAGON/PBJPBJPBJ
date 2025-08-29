local config = getConfig ();
local instance = {};

-- table's resource.
instance.animations = {};
instance.fadeButton = {};
instance.font = {};
instance.image = {};
instance.interpolates = {};

-- util's client.
screen = Vector2 (guiGetScreenSize ());
middle = Vector2 (screen.x / 2, screen.y / 2);
scale = math.min (1.2, math.max (0.8, (screen.y / 1080)));

_dxCreateFont = dxCreateFont;
_dxDrawText = dxDrawText;
_dxDrawImage = dxDrawImage;
_dxDrawImageSection = dxDrawImageSection;
_dxSetBlendMode = dxSetBlendMode;

function respc (value)
    return value * scale;
end

function dxDrawText (text, x, y, w, h, ...)
    return _dxDrawText (text, x, y, w + x, h + y, ...);
end

function dxCreateFont (directory, size, ...)
    if not (instance.font[directory]) then
        instance.font[directory] = {};
    end

    if not (instance.font[directory][size]) then
        instance.font[directory][size] = _dxCreateFont (directory, respc (size) * (72 / 96), ...);
    end

    return instance.font[directory][size];
end

function dxDrawImage (x, y, width, height, directory, ...)
    if (isElement (directory) or instance.image[directory]) then
        return _dxDrawImage (x, y, width, height, (instance.image[directory] and instance.image[directory] or directory), ...);
    end

    if not (instance.image[directory]) then
        instance.image[directory] = dxCreateTexture (directory, 'argb', false, 'wrap');
    end

    return _dxDrawImage (x, y, width, height, instance.image[directory], ...);
end

function dxDrawImageSection (x, y, width, height, u, v, uwidth, vheight, directory, ...)
    if (isElement (directory) or instance.image[directory]) then
        return _dxDrawImageSection (x, y, width, height, u, v, uwidth, vheight, (instance.image[directory] and instance.image[directory] or directory), ...);
    end

    if not (instance.image[directory]) then
        instance.image[directory] = dxCreateTexture (directory, 'argb', false, 'wrap');
    end

    return _dxDrawImageSection (x, y, width, height, u, v, uwidth, vheight, instance.image[directory], ...);
end

function dxSetBlendMode (...)
    if (hasAnimationRunning) then
        return false;
    end

    return _dxSetBlendMode (...);
end

function isCursorOnElement (x, y, width, height)
    if not (isCursorShowing ()) then
        return false;
    end

    local cursor = {getCursorPosition ()};
    local cursorx, cursory = (cursor[1] * screen.x), (cursor[2] * screen.y);

    return (cursorx >= x and cursorx <= (x + width) and cursory >= y and cursory <= (y + height));
end

function lerp (a, b, t)
    return a + (b - a) * t;
end

function interpolate (start, finish, time, index)
    if not (instance.interpolates[index]) then
        instance.interpolates[index] = start;
    end

    instance.interpolates[index] = lerp (instance.interpolates[index], finish, time);
    return instance.interpolates[index];
end

animation = {
    new = function (identify, initial, finish, duration, easing, capture)
        if (instance.animations[identify]) then
            error ('Animation "' .. identify .. '" already exists.');            

            return false;
        end

        instance.animations[identify] = {
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
        if not (instance.animations[identify]) then
            error ('Animation "' .. identify .. '" does not exist.');

            return false;
        end

        instance.animations[identify].initial = initial;
        instance.animations[identify].finish = finish;
        instance.animations[identify].duration = duration or instance.animations[identify].duration;
        instance.animations[identify].easing = easing or instance.animations[identify].easing;
        instance.animations[identify].tick = getTickCount ();

        return true;
    end;

    get = function (identify)
        if not (instance.animations[identify]) then
            error ('Animation "' .. identify .. '" does not exist.');

            return false;
        end

        local animation = instance.animations[identify];
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
        if not (instance.animations[identify]) then
            error ('Animation "' .. identify .. '" does not exist.');

            return false;
        end

        local animation = instance.animations[identify];
        local progress = (getTickCount () - animation.tick) / animation.duration;

        if not (progress >= 1) then
            return true;
        end

        return false;
    end;
};

button = {
    exec = function (identify, duration, color, alpha)
        if not (instance.fadeButton[identify]) then
            instance.fadeButton[identify] = {
                identify = identify;
                duration = duration;
                alpha = alpha;
                color = color;
                lastR = color[1];
                lastG = color[2];
                lastB = color[3];
                lastA = alpha;
                tick = nil;
            };
        end

        if (color[1] ~= instance.fadeButton[identify].lastR or color[2] ~= instance.fadeButton[identify].lastG or alpha ~= instance.fadeButton[identify].lastA) then
            instance.fadeButton[identify].tick = getTickCount ();
            instance.fadeButton[identify].lastR = color[1];
            instance.fadeButton[identify].lastG = color[2];
            instance.fadeButton[identify].lastB = color[3];
            instance.fadeButton[identify].lastA = alpha;
        elseif (instance.fadeButton[identify].color[1] == color[1] and instance.fadeButton[identify].color[2] == color[2] and instance.fadeButton[identify].alpha == alpha) then
            instance.fadeButton[identify].tick = nil;
        end

        if (instance.fadeButton[identify].tick) then
            local interpolate = {interpolateBetween (instance.fadeButton[identify].color[1], instance.fadeButton[identify].color[2], instance.fadeButton[identify].color[3], color[1], color[2], color[3], (getTickCount () - instance.fadeButton[identify].tick) / duration, 'Linear')};
            local interpolateAlpha = interpolateBetween (instance.fadeButton[identify].alpha, 0, 0, alpha, 0, 0, (getTickCount () - instance.fadeButton[identify].tick) / duration, 'Linear');

            instance.fadeButton[identify].color = interpolate;
            instance.fadeButton[identify].alpha = interpolateAlpha;
        end

        if (alpha and ((alpha > 0 and alpha < 255) and true or false) or false) then
            instance.fadeButton[identify].alpha = alpha;
        end

        return tocolor (instance.fadeButton[identify].color[1], instance.fadeButton[identify].color[2], instance.fadeButton[identify].color[3], instance.fadeButton[identify].alpha);
    end;
};

local editbox = {};
local inputFocus = false

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
    --if (values['Color'][2]) then
    --    dxDrawRectangle(x, y, w, h, values['Color'][2]);
    --end
    local text = (values['isPassword'] and #values['Text'] > 0 and string.gsub(values['Text'], '.', '•') or (inputFocus == Id and values['Text'] and values['Text'] or (#values['Text'] > 0 and values['Text'] or values['Placeholder'])));
    dxDrawText(text, x, y, w, h, values["Color"][1], 1.00, values["Font"], (not hasLeft and "center" or 'left'), "top", false, true);
    if (values['hasLine']) then
        if (inputFocus == Id and #values['Text'] > 0) then
            local width, heigth = dxGetTextSize(text, 0, 1.0, 1.0, values['Font'], false, false);
            dxDrawLine(x + (width) + (1), y + (heigth) - (11), x + (width) + (1), y + (heigth*2) - 3, tocolor(255, 255, 255, math.abs(math.sin(getTickCount()/800) * 255)), 1, false);
        end
    end
    if (values['hasPressed'] and getTickCount() >= values['hasPressed'] + 500) then
        if ((#values['Text'] - 1) >= 0) then
            values['Text'] = string.sub(values['Text'], 1, (#values['Text'] - 1));
        end
    end
end

addEventHandler ("onClientClick", root, function (button, state)
    if (not isCursorShowing ()) then
        return false
    end
    if button == "left" and state == "down" then
        for identify, value in pairs (editbox) do
            if isCursorOnElement (value["Position"][1], value["Position"][2], value["Position"][3], value["Position"][4]) then
                inputFocus = identify
                break
            else
                if inputFocus then
                    inputFocus = false
                end 
            end
        end
    end
end)

-- Digitar:
addEventHandler('onClientCharacter', getRootElement(), function(character)
    if (not isCursorShowing()) then
        return false;
    end
    if (character) then
        local Value = editbox[inputFocus]
        if not Value then
            return
        end
        if (#Value['Text'] + 1 <= Value['MaxCharacters']) then
            if (Value['isNumber']) then
                if (tonumber(character)) then
                    Value['Text'] = Value['Text']..character;
                    return
                end
            else
                Value['Text'] = Value['Text']..character;
                return  
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
end

-- Backspace:
addEventHandler ('onClientKey', getRootElement(), function(key, press)
    if (key == 'backspace') then
        local Value = editbox[inputFocus]
        if not Value then
            return
        end
        if (press) then
            if ((#Value['Text'] - 1) >= 0) then
                Value['Text'] = string.sub(Value['Text'], 1, (#Value['Text'] - 1));
                Value['hasPressed'] = getTickCount();
            end
        else
            Value['hasPressed'] = false;
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