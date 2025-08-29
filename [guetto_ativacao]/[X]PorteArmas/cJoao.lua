local screen = {guiGetScreenSize()}
local sx, sy = (screen[1]/1366), (screen[2]/768)

function isMouseInPosition(x,y,w,h)
    if isCursorShowing() then
        local sx,sy = guiGetScreenSize()
        local cx,cy = getCursorPosition()
        local cx,cy = (cx*sx),(cy*sy)
        if (cx >= x and cx <= x+w) and (cy >= y and cy <= y+h) then
            return true
        end
    end
end

_dxDrawImage = dxDrawImage
function dxDrawImage (x, y, w, h, ...)
    local x, y, w, h = sx * x, sy * y, sx * w, sy * h
    return _dxDrawImage (x, y, w, h, ...)
end

_dxDrawImageSection = dxDrawImageSection
function dxDrawImageSection (x, y, w, h, ...)
    local x, y, w, h = sx * x, sy * y, sx * w, sy * h
    return _dxDrawImageSection (x, y, w, h, ...)
end

_isMouseInPosition = isMouseInPosition
function isMouseInPosition (x, y, w, h)
    local x, y, w, h = sx * x, sy * y, sx * w, sy * h
    return _isMouseInPosition (x, y, w, h)
end

_dxCreateFont = dxCreateFont
function dxCreateFont (file, tamanho)
    local tamanho = sx * tamanho
    return _dxCreateFont (file, tamanho)
end

_dxDrawRectangle = dxDrawRectangle
function dxDrawRectangle (x, y, w, h, ...)
    local x, y, w, h = sx * x, sy * y, sx * w, sy * h
    return _dxDrawRectangle (x, y, w, h, ...)
end

_dxDrawText = dxDrawText
function dxDrawText (text, x, y, w, h, ...)
    local x, y, w, h = sx * x, sy * y, sx * w, sy * h
    return _dxDrawText (text, x, y, w, h, ...)
end

local font = dxCreateFont("files/fonts/Roboto-Medium.ttf", 10)
local font2 = dxCreateFont("files/fonts/Roboto-Bold.ttf", 11)
local font3 = dxCreateFont("files/fonts/Roboto-Regular.ttf", 10)
local font4 = dxCreateFont("files/fonts/Roboto-Medium.ttf", 11)

edits = {}

function dx()
    if window == "index" then
        dxDrawImage(422, 194, 522, 380, "files/imgs/base.png")
        dxDrawImage(607, 409, 151, 43, "files/imgs/button.png")
        dxDrawImage(622, 517, 122, 40, "files/imgs/cancelar.png")
        if isMouseInPosition(607, 409, 151, 43) then
            dxDrawText("Iniciar teste", 607, 409, 758, 454, tocolor(255, 255, 255, 255), 1.00, font, "center", "center", false, false, false, false, false)
        else
            dxDrawText("Iniciar teste", 607, 409, 758, 454, tocolor(255, 255, 255, 114), 1.00, font, "center", "center", false, false, false, false, false)
        end
        if isMouseInPosition(622, 517, 122, 40) then
            dxDrawText("Cancelar", 617, 518, 748, 557, tocolor(255, 255, 255, 255), 1.00, font, "center", "center", false, false, false, false, false)
        else
            dxDrawText("Cancelar", 617, 518, 748, 557, tocolor(255, 255, 255, 114), 1.00, font, "center", "center", false, false, false, false, false)
        end
        dxDrawText("Você tem certeza que deseja iniciar a prova teórica do porte de armas?\n\nÉ necessário level "..config["Minimo"].Level.." e custa R$ "..formatNumber(config["Minimo"].Dinheiro)..",00", 518, 291, 862, 393, tocolor(255, 255, 255, 114), 1.00, font, "center", "center", false, true, true, false, false)
    elseif window == "questions" then
        dxDrawImage(422, 194, 522, 380, "files/imgs/base.png")
        dxDrawImage(446, 334, 484, 208, "files/imgs/base_questions.png")
        dxDrawText(config["Questions"][selectQuestion].Title, 442, 272, 907, 314, tocolor(241, 241, 241, 165), 1.00, font4, "left", "center", false, true, true, false, false)
        for i, v in ipairs(config["Questions"][selectQuestion]["Questions"]) do
            if isMouseInPosition(446, (327 + 43 * i), 484, 43) then
                dxDrawImage(446, (327 + 43 * i), 484, 43, "files/imgs/select.png")
                dxDrawText(v[1], 458, (327 + 43 * i), 475, (369 + 43 * i), tocolor(255, 255, 255, 242), 1.00, font2, "left", "center", false, false, true, false, false)
                dxDrawText(v[2], 485, (327 + 43 * i), 925, (369 + 43 * i), tocolor(255, 255, 255, 242), 1.00, font3, "left", "center", false, false, true, false, false)
            else
                dxDrawText(v[1], 458, (327 + 43 * i), 475, (369 + 43 * i), tocolor(255, 255, 255, 165), 1.00, font2, "left", "center", false, false, true, false, false)
                dxDrawText(v[2], 485, (327 + 43 * i), 925, (369 + 43 * i), tocolor(255, 255, 255, 89), 1.00, font3, "left", "center", false, false, true, false, false)
            end
        end
    elseif window == "success" then
        dxDrawImage(422, 194, 522, 380, "files/imgs/base.png")
        dxDrawImage(514, 295, 338, 178, "files/imgs/success.png")
        if isMouseInPosition(900, 232, 14, 14) then
            dxDrawImage(900, 232, 14, 14, "files/imgs/close.png", 0, 0, 0, tocolor(198, 58, 58, 255))
        else
            dxDrawImage(900, 232, 14, 14, "files/imgs/close.png", 0, 0, 0, tocolor(56, 56, 56))
        end
    elseif window == "giveporte" then
        dxDrawImage(422, 202, 522, 364, "files/imgs/giveporte/base.png")
        dxDrawText("Selecione o ID e o tempo do civil que deseja ter o porte de armas:", 478, 292, 766, 340, tocolor(241, 241, 241, 165), 1.00, font, "left", "center", false, true, false, false, false)
        dxDrawText(select == 1 and guiGetText(edits[1])..'|' or guiGetText(edits[1]), 496, 355, 882, 400, tocolor(241, 241, 241, 165), 1.00, font3, "left", "center", false, false, false, false, false)
        dxDrawText(select == 2 and guiGetText(edits[2])..'|' or guiGetText(edits[2]), 496, 411, 882, 456, tocolor(241, 241, 241, 165), 1.00, font3, "left", "center", false, false, false, false, false)
        if isMouseInPosition(606, 491, 153, 43) then
            dxDrawImage(606, 491, 153, 43, "files/imgs/giveporte/enviar_select.png")
        else
            dxDrawImage(606, 491, 153, 43, "files/imgs/giveporte/enviar.png")
        end
        if isMouseInPosition(900, 232, 14, 14) then
            dxDrawImage(900, 232, 14, 14, "files/imgs/giveporte/close.png", 0, 0, 0, tocolor(198, 58, 58, 255))
        else
            dxDrawImage(900, 232, 14, 14, "files/imgs/giveporte/close.png", 0, 0, 0, tocolor(56, 56, 56))
        end
    elseif window == "removeporte" then
        dxDrawImage(422, 238, 522, 292, "files/imgs/removeporte/base.png")
        dxDrawText("Selecione o ID do civil que deseja remover o porte de armas:", 478, 323, 814, 374, tocolor(241, 241, 241, 165), 1.00, font, "left", "center", false, true, true, false, false)
        dxDrawText(select == 1 and guiGetText(edits[1])..'|' or guiGetText(edits[1]), 496, 391, 882, 436, tocolor(241, 241, 241, 165), 1.00, font3, "left", "center", false, false, true, false, false)
        if isMouseInPosition(605, 458, 172, 43) then
            dxDrawImage(605, 458, 172, 43, "files/imgs/removeporte/remover_select.png")
        else
            dxDrawImage(605, 458, 172, 43, "files/imgs/removeporte/remover.png")
        end
        if isMouseInPosition(900, 268, 14, 14) then
            dxDrawImage(900, 268, 14, 14, "files/imgs/giveporte/close.png", 0, 0, 0, tocolor(198, 58, 58, 255))
        else
            dxDrawImage(900, 268, 14, 14, "files/imgs/giveporte/close.png", 0, 0, 0, tocolor(56, 56, 56))
        end
    end
end

addEvent("JOAO.openPorte", true)
addEventHandler("JOAO.openPorte", root,
function(window_)
    if not isEventHandlerAdded("onClientRender", root, dx) then
        addEventHandler("onClientRender", root, dx)
        aprovados = 0
        select = 0
        reprovados = 0
        EditBox("add")
        selectQuestion = 1
        window = window_
        showCursor(true)
    end
end)

addEventHandler("onClientClick", root,
function(_, state)
    if state == "up" then
        if isEventHandlerAdded("onClientRender", root, dx) then
            select = 0
            if guiGetText(edits[1]) == "" then guiSetText(edits[1], "ID") end
            if guiGetText(edits[2]) == "" then guiSetText(edits[2], "Tempo (dias)") end
            if window == "index" then
                if isMouseInPosition(607, 409, 151, 43) then
                    triggerServerEvent("JOAO.startTestePorte", resourceRoot)
                end
                if isMouseInPosition(622, 517, 122, 40) then
                    closeMenu()
                end
            elseif window == "success" then
                if isMouseInPosition(900, 232, 14, 14) then
                    closeMenu()
                end
            elseif window == "removeporte" then
                if isMouseInPosition(476, 391, 408, 45) then
                    select = 0
                    if guiEditSetCaretIndex(edits[1], string.len(guiGetText(edits[1]))) then
                        select = 1
                        guiBringToFront(edits[1])
                        guiSetInputMode('no_binds_when_editing') 
                        if (guiGetText(edits[1]) == "ID") then 
                            guiSetText(edits[1], '')
                        end
                    end
                end
                if isMouseInPosition(605, 458, 172, 43) then
                    if guiGetText(edits[1]) == "" or guiGetText(edits[1]) == "ID" then
                        notifyC("Digite o ID!", "error")
                    else
                        local id = tonumber(guiGetText(edits[1]))
                        if type(id) == "number" then
                            if id >= 1 then
                                triggerServerEvent("JOAO.removerPorte", resourceRoot, id)
                            else
                                notifyC("ID precisa ser acima de 1!", "error")
                            end
                        else
                            notifyC("O tipo do ID não é número!", "error")
                        end
                    end
                end
                if isMouseInPosition(900, 268, 14, 14) then
                    closeMenu()
                end
            elseif window == "giveporte" then
                if isMouseInPosition(476, 355, 408, 45) then
                    select = 0
                    if guiEditSetCaretIndex(edits[1], string.len(guiGetText(edits[1]))) then
                        select = 1
                        guiBringToFront(edits[1])
                        guiSetInputMode('no_binds_when_editing') 
                        if (guiGetText(edits[1]) == "ID") then 
                            guiSetText(edits[1], '')
                        end
                    end
                end
                if isMouseInPosition(476, 411, 408, 45) then
                    select = 0
                    if guiEditSetCaretIndex(edits[2], string.len(guiGetText(edits[2]))) then
                        select = 2
                        guiBringToFront(edits[2])
                        guiSetInputMode('no_binds_when_editing') 
                        if (guiGetText(edits[2]) == "Tempo (dias)") then 
                            guiSetText(edits[2], '')
                        end
                    end
                end
                if isMouseInPosition(606, 491, 153, 43) then
                    if guiGetText(edits[1]) == "" or guiGetText(edits[1]) == "ID" then
                        notifyC("Digite o ID!", "error")
                    else
                        if guiGetText(edits[2]) == "" or guiGetText(edits[2]) == "Tempo (dias)" then
                            notifyC("Digite o tempo em dias!", "error")
                        else
                            local id = tonumber(guiGetText(edits[1]))
                            local tempo = tonumber(guiGetText(edits[2]))
                            if type(id) == "number" then
                                if type(tempo) == "number" then
                                    if id >= 1 and tempo >= 1 then
                                        triggerServerEvent("JOAO.setarPorte", resourceRoot, id, tempo)
                                    else
                                        notifyC("Tempo e ID precisa ser acima de 1!", "error")
                                    end
                                else
                                    notifyC("O tipo do tempo não é número!", "error")
                                end
                            else
                                notifyC("O tipo do ID não é número!", "error")
                            end
                        end
                    end
                end
                if isMouseInPosition(900, 232, 14, 14) then
                    closeMenu()
                end
            elseif window == "questions" then
                for i, v in ipairs(config["Questions"][selectQuestion]["Questions"]) do
                    if isMouseInPosition(446, (327 + 43 * i), 484, 43) then
                        if selectQuestion == #config["Questions"] then
                            if i == config["Questions"][selectQuestion].Answer then
                                aprovados = aprovados + 1
                            else
                                reprovados = reprovados + 1
                            end
                            if aprovados >= config["Minimo"].Acertos then
                                window = "success"
                                triggerServerEvent("JOAO.pegarPorteTeorico", resourceRoot)
                            else
                                closeMenu()
                                notifyC("Você foi reprovado no teste teórico!", "error")
                            end
                        else
                            if i == config["Questions"][selectQuestion].Answer then
                                aprovados = aprovados + 1
                            else
                                reprovados = reprovados + 1
                            end
                            selectQuestion = selectQuestion + 1
                        end
                    end
                end
            end
        end
    end
end)

addEvent("JOAO.changeWindowPORTE", true)
addEventHandler("JOAO.changeWindowPORTE", root,
function(window_)
    window = window_
end)

function closeMenu()
    if isEventHandlerAdded("onClientRender", root, dx) then
        removeEventHandler("onClientRender", root, dx)
        showCursor(false)
        EditBox("destroy")
    end
end

function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
    if type( sEventName ) == "string" and isElement( pElementAttachedTo ) and type( func ) == "function" then
        local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
        if type( aAttachedFunctions ) == "table" and #aAttachedFunctions > 0 then
            for i, v in ipairs( aAttachedFunctions ) do
                if v == func then
                    return true
                end
            end
        end
    end
    return false
end

function EditBox(tipo)
    if tipo == 'destroy' then
        for i=1, #edits do
            if isElement(edits[i]) then 
                destroyElement(edits[i])
            end
        end
    elseif tipo == 'add' then
        edits[1] = guiCreateEdit(-1000, -1000, 325, 50, 'ID', false)
        guiEditSetMaxLength(edits[1], 12)
        guiSetProperty(edits[1], 'ValidationString', '[0-9]*')
        edits[2] = guiCreateEdit(-1000, -1000, 325, 50, 'Tempo (dias)', false)
        guiEditSetMaxLength(edits[2], 8)
        guiSetProperty(edits[2], 'ValidationString', '[0-9]*')
    end 
end