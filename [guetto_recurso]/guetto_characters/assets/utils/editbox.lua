local editbox = {focus = false, selection = false, isEventsAdded = false}

function editbox:removeEventsAdded ( )
    if not editbox.isEventsAdded then
        return false
    end

    removeEventHandler ("onClientKey", getRootElement ( ), onEditboxKey)
    removeEventHandler ("onClientPaste", getRootElement ( ), onEditboxPaste)
    removeEventHandler ("onClientClick", getRootElement ( ), onEditboxClick)
    removeEventHandler ("onClientCharacter", getRootElement ( ), onEditboxCharacter)

    editbox.isEventsAdded = false
end

function editbox:tableGetSize ( )
    local size = 0

    for _, values in pairs (self) do
        if (type (values) == "table") then
            size = size + 1
        end
    end

    return size
end

function editbox:formatNumber (number, separator)
    local formatted = number

    while true do
        formatted, k = string.gsub (formatted, "^(-?%d+)(%d%d%d)", '%1' .. (separator or ".") .. '%2')
        if (k == 0) then
            break
        end
    end

    return formatted
end

function dxDrawEditbox (id, placeholder, x, y, width, height, colors, positions, font, attributes)
    if not editbox[id] then
        editbox[id] = {
            text = "";
            placeholder = placeholder;
            offsets = {x, y, width, height};
            colors = colors;
            font = (isElement (font) and font) or "default";
            attributes = attributes;
            tick = 0
        }

        if not editbox.isEventsAdded then
            editbox.isEventsAdded = true

            addEventHandler ("onClientKey", getRootElement ( ), onEditboxKey)
            addEventHandler ("onClientPaste", getRootElement ( ), onEditboxPaste)
            addEventHandler ("onClientClick", getRootElement ( ), onEditboxClick)
            addEventHandler ("onClientCharacter", getRootElement ( ), onEditboxCharacter)
        end
    end

    editbox[id].offsets = {x, y, width, height}
    editbox[id].colors = colors

    local values = editbox[id]

    local text = ((editbox.focus == id or #values.text ~= 0) and (values.attributes.password and string.rep ("*", #values.text) or values.text)) or placeholder
    local text_color = (editbox.focus == id and values.colors.focus) or values.colors.normal
    
    local width = dxGetTextWidth (text, 1.00, values.font)
    local height = dxGetFontHeight (1.00, values.font)

    dxDrawText (text, values.offsets[1], values.offsets[2] + (((editbox.focus == id or #values.text ~= 0) and values.attributes.password) and 4 or 0), values.offsets[3], values.offsets[4], text_color, 1.00, values.font, positions[1], positions[2], false, false, true)

    if (editbox.focus == id and not editbox.selection) then
        local cx = ((positions[1] == "left" and values.offsets[1] + width) or (positions[1] == "center" and values.offsets[1] + (values.offsets[3] / 2) + width/1.4) or (positions[1] == "right" and values.offsets[1] + values.offsets[3] - width))
        local cy = ((positions[2] == "top" and values.offsets[2]) or (positions[2] == "center" and values.offsets[2] + (values.offsets[4] / 2) - (height / 2)) or (positions[2] == "bottom" and values.offsets[2] + values.offsets[4] - height))

        dxDrawLine (cx, cy-2, cx, cy + height+2, tocolor (255, 255, 255, math.abs (math.sin (getTickCount() / 400) * 255)), 1.00, false)
    end

    if (values.tick ~= 0 and (getTickCount () - values.tick) >= 300) then
        values.text = values.text:sub (0, #values.text - 1)
    end
end

-- function's event's
function onEditboxClick (button, state)
    if not (button == "left" and state == "up") then
        return false
    end

    for identify, values in pairs (editbox) do
        if (type (values) == "table" and isCursorOnElement (unpack (values.offsets))) then
            if values.attributes.block then
                return false
            end

            editbox.focus = identify
            guiSetInputMode ("no_binds")
            return true
        end
    end

    if editbox.focus then
        editbox[editbox.focus].tick = 0
        editbox.selection = false
        editbox.focus = false

        guiSetInputMode ("allow_binds")
        return true
    end
end

function onEditboxCharacter (character)
    local values = editbox[editbox.focus]

    if not values or values.attributes.block then
        return false
    end

    if (values.attributes.number and not tonumber (character)) then
        return false
    end

    if (values.attributes.max_characters and #values.text + 1 > values.attributes.max_characters) then
        if editbox.selection and editbox.selection == editbox.focus then
            values.text = ""
            editbox.selection = false
        end

        return false
    end

    if (editbox.selection and editbox.selection == editbox.focus) then
        values.text = ""
        editbox.selection = false
    end

    values.text = values.text .. character
    return true
end

function onEditboxKey (key, press)
    if not (editbox.focus or editbox.selection) then
        return false
    end

    local values = editbox[editbox.focus]

    if not (key ~= "backspace") then
        if not press then
            values.tick = 0

            return true
        end

        if (editbox.selection and editbox.selection == editbox.focus) then
            values.text = ""
            editbox.selection = false
        
            return true
        end

        values.tick = getTickCount ( ) + 100
        values.text = values.text:sub (0, #values.text - 1)
        return true
    end

    if (key == "a" and getKeyState ("lctrl")) then
        if not editbox.focus then
            return false
        end

        editbox.selection = editbox.focus
        return true
    end

    if (key == "x" and getKeyState ("lctrl")) then
        if not editbox.focus then
            return false
        end

        if #values.text == 0 then
            return false
        end

        setClipboard (values.text)

        values.text = ""
        editbox.selection = false
        return true
    end

    if (key == "c" and getKeyState ("lctrl")) then
        if not editbox.focus then
            return false
        end

        if #values.text == 0 then
            return false
        end

        setClipboard (values.text)
        return true
    end
end

function onEditboxPaste (text)
    if not editbox.focus then
        return false
    end

    local values = editbox[editbox.focus]

    if values.attributes.block then
        return false
    end

    if (values.attributes.number and not tonumber (text)) then
        return false
    end

    if (editbox.selection and editbox.selection == editbox.focus) then
        values.text = ""
        editbox.selection = false
    end

    if (#values.text == values.attributes.max_characters) then
        return false
    end

    values.text = values.text .. string.sub (text, 1, values.attributes.max_characters - #values.text)
    return true
end

-- function's util's
function dxEditboxSetText (id, text)
    editbox[id].text = text
end

function dxEditboxGetText (id)
    if not id then
        return false
    end

    if not editbox[id] then
        return false
    end

    return editbox[id].text
end

function dxEditboxDestroy (id)
    if not id then
        return false
    end

    if (id == "all") then
        for identify, values in pairs (editbox) do
            if (type (values) == "table") then
                editbox[identify] = nil
            end
        end

        editbox:removeEventsAdded ( )
        return true
    end

    if not editbox[id] then
        return false
    end

    if editbox.focus then
        editbox[editbox.focus].tick = 0
        editbox.selection = false
        editbox.focus = false
        guiSetInputMode ("allow_binds")
        showCursor (false)
    end

    editbox[id] = nil
    editbox:removeEventsAdded ( )
    return true
end

function dxEditboxPassword (id, state)
    editbox[id].attributes.password = state
end