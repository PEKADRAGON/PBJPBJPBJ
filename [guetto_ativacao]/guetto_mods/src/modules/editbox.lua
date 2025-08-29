editbox = {
    identificador = {};

    events = {
        start = function ( )
            addEventHandler('onClientCharacter', root, editbox.utils.character)
            addEventHandler('onClientClick', root, editbox.utils.click)
            addEventHandler("onClientPaste", root, editbox.utils.paste)
            addEventHandler('onClientKey', root, editbox.utils.key)
        end;
    };

    utils = {
        
        getValue = function (id)
            if editbox.identificador[id] then 
                return editbox.identificador[id].content
            end
            return false;
        end;

        character = function (char)
            for i, v in pairs(editbox.identificador) do
                if v.state == true then
                    if (#v.content >= v.length) then 
                        return 
                    end
                    if char == '+' or char == '-' then 
                        return false;
                    end;
                    v.content = v.content .. char
                    guiSetInputMode("no_binds") 
                end
            end
        end;

        click = function (button, state)
            if button == "left" and state == "down" then
                for i, v in pairs(editbox.identificador) do
                    if v.state == true then
                        v.state = false
                        guiSetInputMode("allow_binds") 
                        if (string.len(v.content) == 0) then 
                            v.content = v.textInicial
                            v.isEnabledArea = false;
                        end
                    end
                    if isCursorInBox(v.x, v.y, v.w, v.h) and not v.state then
                        if string.len(v.content) ~= 0 and v.textInicial == v.content then
                            v.content = ""
                        end
                        v.state = true
                        v.isEnabledArea = false;
                        tick = getTickCount()
                        guiSetInputMode("no_binds") 
                    end
                end
            end
        end;

        paste = function(text)
            for i, v in pairs(editbox.identificador) do
                if v.state == true then
                    v.content = text
                    v.state = false
                    guiSetInputMode('allow_binds')
                end
            end
        end;

        getSelectEdit = function ()
            for i, v in pairs(editbox.identificador) do
                if v.state == true then
                    return v
                end
            end
            return false
        end;
        
        key = function (button, state)
            if (getKeyState('lctrl') and getKeyState('a') and state) then
                local edit = editbox.utils.getSelectEdit ()
                if edit then 
                    edit.isEnabledArea = true
                end
            end
        end;


        destroyAllEdits = function ( )
            for i, v in pairs(editbox.identificador) do 
                v = nil 
            end
            editbox.identificador = {}
            guiSetInputMode('allow_binds')
        end;

    };

    create = function (text, id, x, y, w, h, rw, rh, maxCaracters, fade, font)
        if not editbox.identificador[id] then
            editbox.identificador[id] = {
                content = text,
                textInicial = text,
                state = false,
                isEnabledArea = false,
                x = x,
                y = y,
                w = w,
                tick = 0,
                area = 0,
                h = h,
                rw = rw,
                length = maxCaracters,
                font = font
            }
        end

        editbox.identificador[id].y = y 
        editbox.identificador[id].x = x

        if editbox.identificador[id].state == true then
            local alpha = interpolateBetween(0, 0, 0, 1, 0, 0, (getTickCount() - tick) / 1000, "OutQuad")
            local textWidth = dxGetTextWidth(editbox.identificador[id].content, 1, editbox.identificador[id].font)
            local textHeight = dxGetFontHeight(1, editbox.identificador[id].font)
    
            local textX = editbox.identificador[id].x + textWidth
            dxDrawRectangle(textX, editbox.identificador[id].y, 1, textHeight, tocolor(255, 255, 255, alpha * math.min(getEasingValue((getTickCount() - tick) / 1500, "CosineCurve"), 1)))
        end

        if getKeyState ("backspace") then
            if getTickCount() - editbox.identificador[id].tick > 100 then
                if (editbox.identificador[id].state == true) then 
                    if editbox.identificador[id].isEnabledArea then 
                        editbox.identificador[id].content = ''
                        editbox.identificador[id].isEnabledArea = false;
                    else
                        editbox.identificador[id].content = utf8.sub (editbox.identificador[id].content, 1, utf8.len(editbox.identificador[id].content) - 1)
                        editbox.identificador[id].tick = getTickCount()
                    end
                end
            end
        end
    
        if editbox.identificador[id] and editbox.identificador[id].isEnabledArea then 
            local textWidth = dxGetTextWidth(editbox.identificador[id].content, 1, editbox.identificador[id].font)
            local width, height = dxGetTextSize(editbox.identificador[id].content, textWidth, 1, editbox.identificador[id].font)
            local textX = editbox.identificador[id].x + textWidth
            
            editbox.identificador[id].area = textWidth
            dxDrawRectangle(editbox.identificador[id].x, editbox.identificador[id].y, editbox.identificador[id].area, height, tocolor(51, 103, 209, fade))
        end

        dxDrawText(editbox.identificador[id].content, editbox.identificador[id].x, editbox.identificador[id].y, editbox.identificador[id].w, editbox.identificador[id].h, tocolor(255, 255, 255, fade), 1, editbox.identificador[id].font, "left", "top")
    end;

}