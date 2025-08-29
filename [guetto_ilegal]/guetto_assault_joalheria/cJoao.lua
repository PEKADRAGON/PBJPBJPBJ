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

CageTable = {
    {547, 332},
    {602, 332},
    {657, 332},
    {712, 332},
    {767, 332},
    
    {547, 387},
    {602, 387},
    {657, 387},
    {712, 387},
    {767, 387},
    
    {547, 442},
    {602, 442},
    {657, 442},
    {712, 442},
    {767, 442},
}

local font = dxCreateFont("files/fonts/Roboto-Regular.ttf", 10)
local font2 = dxCreateFont("files/fonts/Roboto-Medium.ttf", 10)

function dx()
    if window == "index" then
        dxDrawImage(535, 229, 296, 309, "files/imgs/base_hack.png")
        if isMouseInPosition(547, 497, 105, 25) then
            dxDrawImage(547, 497, 105, 25, "files/imgs/cancelar_select.png")
        else
            dxDrawImage(547, 497, 105, 25, "files/imgs/cancelar.png")
        end
        if not liberado[localPlayer] then
            if isMouseInPosition(657, 497, 105, 25) then
                dxDrawImage(657, 497, 105, 25, "files/imgs/invadir_select.png")
            else
                dxDrawImage(657, 497, 105, 25, "files/imgs/invadir.png")
            end
        end
        if tableAcertar[localPlayer] then
            for i, v in ipairs(tableAcertar[localPlayer]) do
                if not v.explodido then
                    if isMouseInPosition(CageTable[i][1], CageTable[i][2], 50, 50) then
                        dxDrawImage(CageTable[i][1], CageTable[i][2], 50, 50, "files/imgs/button.png", 0, 0, 0, tocolor(21, 21, 21, 255))
                    else
                        dxDrawImage(CageTable[i][1], CageTable[i][2], 50, 50, "files/imgs/button.png", 0, 0, 0, tocolor(32, 32, 32, 255))
                    end
                else
                    dxDrawImage(CageTable[i][1], CageTable[i][2], 50, 50, v.explodido == "star" and "files/imgs/star.png" or "files/imgs/bomb.png")
                end
            end
        end
        if tableCadeado[localPlayer] then
            for i, v in ipairs(tableCadeado[localPlayer]) do
                if v.status == "acertou" then
                    dxDrawImage((585 + 26 * i), 306, 14, 13, "files/imgs/cadeadoliberado.png", 0, 0, 0, tocolor(255, 255, 255, 255))
                else
                    dxDrawImage((585 + 26 * i), 306, 11, 13, "files/imgs/cadeado.png", 0, 0, 0, v.status == false and tocolor(126, 126, 126, 255) or v.status == "errou" and tocolor(133, 51, 51, 255) or v.status == "acertou" and tocolor(105, 173, 52, 255) or tocolor(255, 255, 255, 255))
                end
            end
        end
        dxDrawImageSection(547, 291, (270/6*points[localPlayer]), 10, 0, 0, (270/6*points[localPlayer]), 10, "files/imgs/bar.png")
    elseif window == "coletar" then
        dxDrawImage(572, 299, 222, 169, "files/imgs/base_coletar.png")
        if isMouseInPosition(630, 430, 105, 25) then
            dxDrawImage(630, 430, 105, 25, "files/imgs/coletar_select.png")
        else
            dxDrawImage(630, 430, 105, 25, "files/imgs/coletar.png")
        end
        dxDrawImage(config["Joias"][randomItem[localPlayer]][2][1], config["Joias"][randomItem[localPlayer]][2][2], config["Joias"][randomItem[localPlayer]][2][3], config["Joias"][randomItem[localPlayer]][2][4], config["Joias"][randomItem[localPlayer]][3])
        dxDrawText("Parabéns, você acabou de achar "..quantia[localPlayer].."x "..config["Joias"][randomItem[localPlayer]][1]..".", 587, 313, 707, 370, tocolor(255, 255, 255, 255), 1.00, font, "left", "center", false, true, true, false, false)
    elseif window == "vender" then
        dxDrawImage(438, 247, 489, 274, "files/imgs/base_venda.png")
        if isMouseInPosition(459, 458, 174, 42) then
            dxDrawImage(459, 458, 174, 42, "files/imgs/fechar_select.png")
        else
            dxDrawImage(459, 458, 174, 42, "files/imgs/fechar.png")
        end
        if isMouseInPosition(645, 458, 261, 42) then
            dxDrawImage(645, 458, 261, 42, "files/imgs/vender_select.png")
        else
            dxDrawImage(645, 458, 261, 42, "files/imgs/vender.png")
        end
        linha = 0
        for i, v in ipairs(config["Joias"]) do
            if (i > proxPage and linha < 4) then
                linha = linha + 1
                if isMouseInPosition(459, (263 + 38 * linha), 447, 33) or joiaSelect == i then
                    dxDrawImage(459, (263 + 38 * linha), 447, 33, "files/imgs/cage_select.png")
                else
                    dxDrawImage(459, (263 + 38 * linha), 447, 33, "files/imgs/cage.png")
                end
                dxDrawImage(668, (273 + 38 * linha), 10, 13, "files/imgs/bag.png")
                dxDrawText(v[1], 500, (271 + 38 * linha), 612, (289 + 38 * linha), tocolor(255, 255, 255, 127), 1.00, font2, "left", "center", false, false, true, false, false)
                dxDrawImage(469, (270 + 38 * linha), 15, 23, v[3])
                dxDrawText(v[5], 685, (272 + 38 * linha), 736, (290 + 38 * linha), tocolor(255, 255, 255, 127), 1.00, font2, "left", "center", false, false, true, false, false)
                dxDrawText("R$ "..formatNumber(v[6])..",00", 837, (272 + 38 * linha), 888, (290 + 38 * linha), tocolor(255, 255, 255, 255), 1.00, font2, "right", "center", false, false, true, false, false)
            end
        end
    end
end

randomGerado = {}
tableAcertar = {}
tableCadeado = {}
liberado = {}
bloqueado = {}
points = {}
quantia = {}
bombas = {}
randomItem = {}

addEvent("JOAO.openJoalheria", true)
addEventHandler("JOAO.openJoalheria", root,
function(window_, tableJoia_)
    if not isEventHandlerAdded("onClientRender", root, dx) then
        window = window_
        joiaSelect = 0
        proxPage = 0
        if window_ == "index" then
            points[localPlayer] = 0
            tableAcertar[localPlayer] = {}
            tableCadeado[localPlayer] = {}
            for i=1, 15 do
                randomGerado[i] = math.random(1, 1)
                table.insert(tableAcertar[localPlayer], {bomba = (randomGerado[i] == 1 and true or false), explodido = false})
            end
            for i=1, 6 do
                table.insert(tableCadeado[localPlayer], {status = false})
            end
        elseif window_ == "coletar" then
            randomItem[localPlayer] = math.random(1, #config["Joias"])
            quantia[localPlayer] = math.random(1, 5)
        elseif window_ == "vender" then
            for i, v in ipairs(config["Joias"]) do
                for b, k in ipairs(tableJoia_) do
                    if v[4] == k.idJoia then
                        config["Joias"][i][5] = k.qntJoia
                    end
                end
            end
        end
        addEventHandler("onClientRender", root, dx)
        showCursor(true)
    end
end)

addEvent("JOAO.attJoia", true)
addEventHandler("JOAO.attJoia", root,
function(tableJoia_)
    for i, v in ipairs(config["Joias"]) do
        for b, k in ipairs(tableJoia_) do
            if v[4] == k.idJoia then
                config["Joias"][i][5] = k.qntJoia
            end
        end
    end
end)

addEventHandler("onClientClick", root,
function(_, state)
    if state == "up" then
        if isEventHandlerAdded("onClientRender", root, dx) then
            if window == "index" then
                if isMouseInPosition(547, 497, 105, 25) then
                    closeMenu()
                end
                if isMouseInPosition(657, 497, 105, 25) then
                    if not liberado[localPlayer] then
                        liberado[localPlayer] = true
                    end
                end
                if tableAcertar[localPlayer] then
                    for i, v in ipairs(tableAcertar[localPlayer]) do
                        if isMouseInPosition(CageTable[i][1], CageTable[i][2], 50, 50) then
                            if not v.explodido then
                                if not bloqueado[localPlayer] then
                                    if liberado[localPlayer] then
                                        if v.bomba then
                                            points[localPlayer] = points[localPlayer] + 1
                                            tableCadeado[localPlayer][points[localPlayer]].status = "errou"
                                            bloqueado[localPlayer] = true
                                            v.explodido = "bomb"
                                            notifyC("Você errou uma bomba, resetando sistema em 3 segundos!", "warning")
                                            setTimer(function()
                                                bloqueado[localPlayer] = false
                                                liberado[localPlayer] = false
                                                points[localPlayer] = 0
                                                tableAcertar[localPlayer] = {}
                                                tableCadeado[localPlayer] = {}
                                                for i=1, 15 do
                                                    randomGerado[i] = math.random(1, 2)
                                                    table.insert(tableAcertar[localPlayer], {bomba = (randomGerado[i] == 1 and true or false), explodido = false})
                                                end
                                                for i=1, 6 do
                                                    table.insert(tableCadeado[localPlayer], {status = false})
                                                end
                                            end, 8000, 1)
                                        else
                                            points[localPlayer] = points[localPlayer] + 1
                                            tableCadeado[localPlayer][points[localPlayer]].status = "acertou"
                                            v.explodido = "star"
                                            if points[localPlayer] >= 1 then
                                                bloqueado[localPlayer] = true
                                                notifyC("Você hackeou com sucesso, os vidros de demonstrações foram abertos!", "success")
                                                setTimer(function()
                                                    closeMenu()
                                                    triggerServerEvent("JOAO.startHackJOALHERIA", localPlayer, localPlayer)
                                                end, 3000, 1)
                                            else
                                                notifyC("Você acertou agora faltam "..(6-points[localPlayer]).." campos!", "info")
                                            end
                                        end
                                    else
                                        notifyC("Você não começou a invadir!", "error")
                                    end
                                end
                            end
                        end
                    end
                end
            elseif window == "coletar" then
                if isMouseInPosition(630, 430, 105, 25) then
                    triggerServerEvent("JOAO.coletarJoia", localPlayer, localPlayer, config["Joias"][randomItem[localPlayer]], quantia[localPlayer])
                    closeMenu()
                end
            elseif window == "vender" then
                if isMouseInPosition(459, 458, 174, 42) then
                    closeMenu()
                end
                if isMouseInPosition(645, 458, 261, 42) then
                    if joiaSelect ~= 0 then
                        triggerServerEvent("JOAO.venderJoia", localPlayer, localPlayer, config["Joias"][joiaSelect])
                    end
                end
                linha = 0
                for i, v in ipairs(config["Joias"]) do
                    if (i > proxPage and linha < 4) then
                        linha = linha + 1
                        if isMouseInPosition(459, (263 + 38 * linha), 447, 33) then
                            joiaSelect = i
                        end
                    end
                end
            end
        end
    end
end)

function closeMenu()
    if isEventHandlerAdded("onClientRender", root, dx) then
        removeEventHandler("onClientRender", root, dx)
        showCursor(false)
    end
end

addEventHandler("onClientKey", root,
function (button, press)
	if isEventHandlerAdded("onClientRender", root, dx) then
		if button == "mouse_wheel_up" and press then
            if (proxPage > 0) then
                proxPage = proxPage - 1
            end
		elseif button == "mouse_wheel_down" and press then
            proxPage = proxPage + 1
            if (proxPage > #config["Joias"] - 4) then
                proxPage = #config["Joias"] - 4
            end
		end
	end
end)

addEvent("JOAO.tocarSomJoalheria", true)
addEventHandler("JOAO.tocarSomJoalheria", root,
function()
    if isElement(sound) then destroyElement(sound) end
    sound = playSound3D("files/sounds/alarm.mp3", config["Marker Assaltar"][1], config["Marker Assaltar"][2], config["Marker Assaltar"][3], true)
    setSoundMaxDistance(sound, 50)
    setTimer(function()
        if isElement(sound) then destroyElement(sound) end
    end, 0.3*60000, 1)
end)

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