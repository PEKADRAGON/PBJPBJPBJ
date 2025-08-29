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

    dxDrawText(text, x, y, w, h, tocolor(211, 211, 211, 255), 1.00, values["Font"], "center", "center", true);
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