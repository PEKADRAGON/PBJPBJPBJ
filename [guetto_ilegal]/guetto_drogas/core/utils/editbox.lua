local editbox = {}
local editboxFocus
local editboxSelection

function isMouseInPosition(x, y, width, height)
    if (not isCursorShowing()) then return false end
    local screenWidth, screenHeight = guiGetScreenSize()
    local mx, my = getCursorPosition()
    local cursorX, cursorY = mx * screenWidth, my * screenHeight
    return (cursorX >= x and cursorX <= x + width and cursorY >= y and cursorY <= y + height)
end

function dxCreateEditbox(identify, placeholder, absX, absY, width, height, colors, positions, font, maxCharacters, number, password, block)
    if not editbox[identify] then
        editbox[identify] = {
            textDrawing = "";
            placeholder = placeholder,
            absX = absX,
            absY = absY,
            width = width,
            height = height,
            colors = colors,
            positions = positions,
            font = font or "default",
            maxCharacters = maxCharacters or 9999,
            number = number,
            password = password,
            block = block,
            deleteTick = 0
        }
    end

    editbox[identify].absX = absX
    editbox[identify].absY = absY
    editbox[identify]["colors"] = colors
    editbox[identify]["positions"] = positions

    local editboxValues = editbox[identify]
    local labelDrawing = (editboxFocus == identify or editboxValues.textDrawing:len() > 0) and editboxValues.textDrawing or editboxValues.placeholder
    local labelColor = (editboxFocus == identify or editboxValues.textDrawing:len() > 0) and editboxValues.colors.text_focus or editboxValues.colors.text

    local labelWidth = dxGetTextWidth(labelDrawing, 1.00, editboxValues.font)
    local alignX = (editboxValues.positions.alignX == "left" and (labelWidth >= editboxValues.width and "right" or "left")) or (editboxValues.positions.alignX == "center" and "center") or (editboxValues.positions.alignX == "right" and (labelWidth >= editboxValues.width and "left" or "right"))

    labelDrawing = (editboxValues.textDrawing:len() > 0 and editboxValues.password and string.rep("*", editboxValues.textDrawing:len())) or labelDrawing

    dxDrawText(
        labelDrawing,
        absX,
        ((editboxValues.password and editboxValues.textDrawing:len() > 0) and absY + 3 or absY),
        width, height,
        labelColor,
        1, editboxValues.font, alignX, editboxValues.positions.alignY, true
    )

    local textWidth = dxGetTextWidth(labelDrawing, 1, editboxValues.font)
    local textHeight = dxGetFontHeight(1, editboxValues.font)
    
    if (editboxFocus == identify and not editboxSelection) then
        local cursorX = (editboxValues.positions.alignX == "left" and absX + textWidth or editboxValues.positions.alignX == "center" and absX + ((editboxValues.width + textWidth) / 2) or editboxValues.positions.alignX == "right" and absX + editboxValues.width)
        local cursorY = (editboxValues.positions.alignY == "top" and absY) or (editboxValues.positions.alignY == "center" and (absY + ((editboxValues.height - textHeight) / 2)) or (editboxValues.positions.alignY == "bottom" and absY + editboxValues.height - textHeight))

        local alphaLine = math.abs(math.sin(getTickCount() / 300) * (editboxValues.colors.line_alpha or 255))

        cursorX = ((labelWidth >= editboxValues.width) and (absX + editboxValues.width) or cursorX) + 1

        dxDrawLine(cursorX, cursorY, cursorX, cursorY + textHeight, tocolor(94, 103, 127, alphaLine), 1)
    end
    if ((editboxValues.deleteTick > 0) and (getTickCount() - editboxValues.deleteTick) > 300) then
        editboxValues.textDrawing = editboxValues.textDrawing:sub(0, -2)
    end
    if (editboxSelection and editboxSelection == identify) then
        local width = (textWidth >= editboxValues.width) and editboxValues.width or textWidth
        local offsetAbsX = (editboxValues.positions.alignX == "left" and absX) or (editboxValues.positions.alignX == "center" and absX + (editboxValues.width / 2) - (textWidth / 2)) or (editboxValues.positions.alignX == "right" and (absX + editboxValues.width - textWidth))

        dxDrawRectangle(offsetAbsX, absY, width, editboxValues.height, tocolor(94, 103, 127, 125))
    end
end

local function dxEditboxClick(button, state)
    if button == "left" and state == "down" then
        for key, value in pairs(editbox) do
            if isMouseInPosition(value.absX, value.absY, value.width, value.height) and not value.block then
                editboxFocus = key
                guiSetInputMode("no_binds")
                break
            else
                if editboxFocus then
                    editbox[editboxFocus].deleteTick = 0

                    editboxFocus = nil
                    editboxSelection = nil
                    guiSetInputMode("allow_binds")
                end
            end
        end
    end
end
addEventHandler("onClientClick", root, dxEditboxClick)

local function dxEditboxCharacter(character)
    if not editboxFocus then
        return false
    end

    if editbox[editboxFocus].block then
        return false
    end

    if editbox[editboxFocus].number then
        if not tonumber(character) then
            return false
        end
    end

    if editbox[editboxFocus].maxCharacters then
        if editbox[editboxFocus].textDrawing:len() >= editbox[editboxFocus].maxCharacters then
            return false
        end
    end

    if (editboxSelection) then
        editbox[editboxFocus].textDrawing = character
        editboxSelection = nil
        return
    end

    editbox[editboxFocus].textDrawing = editbox[editboxFocus].textDrawing..character
end
addEventHandler("onClientCharacter", root, dxEditboxCharacter)

local function dxEditboxKey(key, press)
    if not editboxFocus then
        return false
    end
    if key == "backspace" then
        if press then
            if (editboxSelection) then
                editbox[editboxFocus].textDrawing = ""
                editboxSelection = nil
                return
            end
            editbox[editboxFocus].deleteTick = getTickCount() + 100
            editbox[editboxFocus].textDrawing = editbox[editboxFocus].textDrawing:sub(1, -2)
        else
            editbox[editboxFocus].deleteTick = 0
        end
    elseif key == "a" and getKeyState("lctrl") and not editboxSelection then
        local editboxValues = editbox[editboxFocus]
        if editboxValues.textDrawing:len() == 0 then return end

        editboxSelection = editboxFocus
    elseif key == "c" and getKeyState("lctrl") and editboxSelection then
        local editboxValues = editbox[editboxFocus]
        if editboxValues.textDrawing:len() == 0 then return end

        setClipboard(editboxValues.textDrawing)
    elseif key == "x" and getKeyState("lctrl") and editboxSelection then
        local editboxValues = editbox[editboxFocus]
        if editboxValues.textDrawing:len() == 0 then return end

        setClipboard(editboxValues.textDrawing)
        editboxValues.textDrawing = ""
        editboxSelection = nil
    end
end
addEventHandler("onClientKey", root, dxEditboxKey)

local function dxEditboxPaste(content)
    if not editboxFocus then
        return false
    end

    if editbox[editboxFocus].block then
        return false
    end

    if editbox[editboxFocus].number then
        if not tonumber(content) then
            return false
        end
    end

    if editbox[editboxFocus].maxCharacters then
        if (editbox[editboxFocus].textDrawing:len() + #content) >= editbox[editboxFocus].maxCharacters then
            content = content:sub(1, editbox[editboxFocus].maxCharacters - editbox[editboxFocus].textDrawing:len())
        end
    end

    if (editboxSelection) then
        editbox[editboxFocus].textDrawing = content:sub(1, editbox[editboxFocus].maxCharacters - editbox[editboxFocus].textDrawing:len())
        editboxSelection = false
        return
    end

    editbox[editboxFocus].textDrawing = editbox[editboxFocus].textDrawing .. content
end
addEventHandler("onClientPaste", root, dxEditboxPaste)

-- EDITBOX's FUNCTION's
function dxEditboxSetText(editboxIdentify, text)
    assert(type(editboxIdentify) == "string", "Bad argument @dxEditboxSetText at argument 1, expect string got "..type(editboxIdentify))
    assert(type(text) == "string", "Bad argument @dxEditboxSetText at argument 2, expect string got "..type(text))

    local editboxValues = editbox[editboxIdentify]
    if (not editboxValues) then
        return false
    end
    if (editboxValues.textDrawing:len() + #text) >= editboxValues.maxCharacters then
        text = text:sub(1, editboxValues.maxCharacters - editboxValues.textDrawing:len())
    end

    editboxValues.textDrawing = text
    return true
end

function dxEditboxGetText(editboxIdentify)
    assert(type(editboxIdentify) == "string", "Bad argument @dxEditboxGetText at argument 1, expect string got "..type(editboxIdentify))

    local editboxValues = editbox[editboxIdentify]
    if (not editboxValues) then
        return false
    end

    return editboxValues.textDrawing
end

function dxEditboxSetBlock(editboxIdentify, block)
    assert(type(editboxIdentify) == "string", "Bad argument @dxEditboxSetBlock at argument 1, expect string got "..type(editboxIdentify))
    assert(type(block) == "boolean", "Bad argument @dxEditboxSetBlock at argument 2, expect boolean got "..type(block))

    local editboxValues = editbox[editboxIdentify]
    if (not editboxValues) then
        return false
    end

    editboxValues.block = block
    return true
end

function dxEditboxGetBlock(editboxIdentify)
    assert(type(editboxIdentify) == "string", "Bad argument @dxEditboxGetBlock at argument 1, expect string got "..type(editboxIdentify))

    local editboxValues = editbox[editboxIdentify]
    if (not editboxValues) then
        return false
    end

    return editboxValues.block
end

function dxEditboxSetNumber(editboxIdentify, number)
    assert(type(editboxIdentify) == "string", "Bad argument @dxEditboxSetNumber at argument 1, expect string got "..type(editboxIdentify))
    assert(type(number) == "boolean", "Bad argument @dxEditboxSetNumber at argument 2, expect boolean got "..type(number))

    local editboxValues = editbox[editboxIdentify]
    if (not editboxValues) then
        return false
    end

    editboxValues.number = number
    return true
end

function dxEditboxSetMaxCharacters(editboxIdentify, maxCharacters)
    assert(type(editboxIdentify) == "string", "Bad argument @dxEditboxSetMaxCharacters at argument 1, expect string got "..type(editboxIdentify))
    assert(type(maxCharacters) == "number", "Bad argument @dxEditboxSetMaxCharacters at argument 2, expect number got "..type(maxCharacters))

    local editboxValues = editbox[editboxIdentify]
    if (not editboxValues) then
        return false
    end

    editboxValues.maxCharacters = maxCharacters
    return true
end

function dxEditboxSetPassword(editboxIdentify, password)
    assert(type(editboxIdentify) == "string", "Bad argument @dxEditboxSetPassword at argument 1, expect string got "..type(editboxIdentify))
    assert(type(password) == "boolean", "Bad argument @dxEditboxSetPassword at argument 2, expect boolean got "..type(password))

    local editboxValues = editbox[editboxIdentify]
    if (not editboxValues) then
        return false
    end

    editboxValues.password = password
    return true
end

function dxEditboxGetPassword(editboxIdentify)
    assert(type(editboxIdentify) == "string", "Bad argument @dxEditboxGetPassword at argument 1, expect string got "..type(editboxIdentify))

    local editboxValues = editbox[editboxIdentify]
    if (not editboxValues) then
        return false
    end

    return editboxValues.password
end

function dxEditboxDestroy(editboxIdentify)
    assert(type(editboxIdentify) == "string", "Bad argument @dxEditboxDestroy at argument 1, expect string got "..type(editboxIdentify))

    if (editboxIdentify == "all") then
        editbox = {}
        editboxSelection = false
        editboxFocus = false
        return true
    end

    if (not editbox[editboxIdentify]) then
        return false
    end

    if (editboxFocus == editboxIdentify) then
        editboxFocus = nil
        editboxSelection = nil
        guiSetInputMode("allow_binds")
    end
    editbox[editboxIdentify] = nil
    return true
end

function dxEditboxGetFocused()
    return editboxFocus
end

addEventHandler('onClientResourceStop', resourceRoot, function()
    guiSetInputMode('allow_binds')
end)