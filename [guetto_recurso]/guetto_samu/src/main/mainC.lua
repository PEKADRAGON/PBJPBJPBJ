 -- \\ Var´s //

local inteface = { }

inteface.animations = {}

inteface.animations.vetor = { 0, 0, 0 }
inteface.showning = false
inteface.animations.time = { 0, 0, 0 }
inteface.stretchers = { }

-- \\ Function´s //

function interfaceDraw ( )

    local animation = interpolateBetween ( inteface.animations.vetor[1], 0, 0, inteface.animations.vetor[2], 0, 0, (getTickCount ( ) - inteface.animations.vetor[3]) / 5000, 'SineCurve')
    local currentTime = interpolateBetween ( inteface.animations.time[1], 0, 0, inteface.animations.time[2], 0, 0, (getTickCount ( ) - inteface.animations.time[3]) / inteface.dados.time, 'Linear')

    local min, second = convertTime ( currentTime )

    dxDrawImage(0, 0, 1920, 1080, "assets/images/fundo.png", 0, 0, 0, tocolor(255, 255, 255, 255))

    dxDrawImageSection(179, 418, animation, 238, 0, 0, animation, 238, "assets/images/vetor.png", 0, 0, 0, tocolor(config["Ui"]["Cor"][1], config["Ui"]["Cor"][2], config["Ui"]["Cor"][3], 255))
    dxDrawImageSection(1285+inteface.animations.vetor[2], 418, -animation, 238, 0, 0, -animation, 238, "assets/images/vetor.png", 0, 0, 0, tocolor(config["Ui"]["Cor"][1], config["Ui"]["Cor"][2], config["Ui"]["Cor"][3], 255))

    dxDrawImageSection(179, 418, inteface.animations.vetor[2], 238, 0, 0, inteface.animations.vetor[2], 238, "assets/images/vetor.png", 0, 0, 0, tocolor(255, 255, 255, 0.05 * 255))
    dxDrawImageSection(1285+inteface.animations.vetor[2], 418, -inteface.animations.vetor[2], 238, 0, 0, -inteface.animations.vetor[2], 238, "assets/images/vetor.png", 0, 0, 0, tocolor(255, 255, 255, 0.05 * 255))

    dxDrawImage(56, 51, 42, 42, "assets/images/music.png", 0, 0, 0, tocolor(255, 255, 255, 255))

    dxDrawText("Quem matou?", 1480, 87, 147, 30, tocolor(config["Ui"]["Cor"][1], config["Ui"]["Cor"][2], config["Ui"]["Cor"][3], 255), 1, exports['guetto_assets']:dxCreateFont("bold", 20), "left", "top")
    dxDrawText("Arma utilizada", 1480, 180, 147, 30, tocolor(config["Ui"]["Cor"][1], config["Ui"]["Cor"][2], config["Ui"]["Cor"][3], 255), 1, exports['guetto_assets']:dxCreateFont("bold", 20), "left", "top")

    dxDrawText(config["Songs"][inteface.musicIndex]["title"], 141, 41, 262, 30, tocolor(255, 255, 255, 255), 1, exports['guetto_assets']:dxCreateFont("italic", 20), "left", "top")

    dxDrawText("Tempo de morte", 85, 931, 169, 30, tocolor(config["Ui"]["Cor"][1], config["Ui"]["Cor"][2], config["Ui"]["Cor"][3], 255), 1, exports['guetto_assets']:dxCreateFont("bold", 20), "left", "top")
    dxDrawText("Tempo caído:", 85, 973, 138, 30, tocolor(255, 255, 255, 255), 1, exports['guetto_assets']:dxCreateFont("italic", 20), "left", "top")
        
    dxDrawText(inteface.dados.attaker and isElement(inteface.dados.attaker) and getPlayerName(inteface.dados.attaker).."# "..(getElementData(inteface.dados.attaker, "ID") or "N/A") or "Não encontrado", 1480, 129, 139, 30, tocolor(255, 255, 255, 255), 1, exports['guetto_assets']:dxCreateFont('italic', 20), 'left', 'top')    
    dxDrawText(inteface.dados.causing and type(inteface.dados.causing) == "number" and config["Damages"][inteface.dados.causing] or inteface.dados.causing, 1480, 222, 49, 30, tocolor(255, 255, 255, 255), 1, exports['guetto_assets']:dxCreateFont('italic', 20), 'left', 'top')    

    dxDrawText(min..":"..second, 385, 973, 41, 30, tocolor(255, 255, 255, 255), 1, exports['guetto_assets']:dxCreateFont('italic', 20), 'left', 'top')

    slidebar.create("slidebar>soung", 176, 89, 116, 5, 13, 13, "assets/images/rectangle.png", "assets/images/circle.png", tocolor(80, 81, 91, 255), tocolor(193, 159, 115, 255), tocolor(255, 255, 255, 255), 100)
    
    local vol = slidebar.getValue("slidebar>soung") / 50
    setSoundVolume(inteface.sound, vol)

    dxDrawImage(141, 79, 24, 24, "assets/images/volume.png", 0, 0, 0, tocolor(255, 255, 255, 255))
    dxDrawText(math.floor(slidebar.getValue("slidebar>soung")).."%", 303, 80, 30, 15, tocolor(255, 255, 255, 255), 1, exports['guetto_assets']:dxCreateFont("medium", 15), "left", "top")
end;

function intefaceOpen ( )
    if not inteface.showning then 
        inteface.showning = true; 
        inteface.musicIndex = math.random(#config["Songs"])
        inteface.sound = playSound(config["Songs"][inteface.musicIndex]["url"])
        showChat(false)
        showCursor(true)
        inteface.animations.vetor[1], inteface.animations.vetor[2], inteface.animations.vetor[3] = 0, 399, getTickCount ( )
        addEventHandler("onClientRender", root, interfaceDraw)
    end
end;

function intefaceClose ( )
    if inteface.showning then 
        inteface.showning = false; 
        showChat(true)
        showCursor(false)
        inteface.animations.vetor[1], inteface.animations.vetor[2], inteface.animations.vetor[3] = 399, 0, getTickCount ( )
        slidebar.destroyAll()
        if inteface.sound and isElement(inteface.sound) then 
            destroyElement(inteface.sound)
            inteface.sound = nil 
        end
        removeEventHandler("onClientRender", root, interfaceDraw)
    end
end;


addEventHandler("onClientKey", root, 
function(key)
    if (getElementData(localPlayer, "Player.Fallen") or false) then
        if key == "control" or key == "space" or key == "alt" or key == "F2" or key == "F1" or key == "F10" or key == "F11"  or key == "backspace" or key == "F3" or key == "F4" or key == "F5" or key == "F6" or key == "F7" or key == "shift" or key == "a" or key == "space" or key == "b" or key == "o" or key == "c" or key == "d"   or key == "f6" or key == "F8" or key == "c"  or key == "F9" then 
            cancelEvent() 
        end
    end
end)

function headShotSamu(weapon, ammo, ammoInClip, hitX, hitY, hitZ, target, startX, startY, startZ)
    if not config['damages block'][weapon] and target ~= localPlayer and isElement(target) and getElementType(target) == 'player' then
        local bone = {getPedBonePosition(target, 6)}
        local bone2 = {getPedBonePosition(target, 7)}
        local dist = getDistanceBetweenPoints3D(hitX, hitY, hitZ, Vector3(unpack(bone)))
        local dist2 = getDistanceBetweenPoints3D(hitX, hitY, hitZ, Vector3(unpack(bone2)))
        if dist < (not isPedInVehicle(target) and 0.19 or (getVehicleType(getPedOccupiedVehicle(target)) == "Automobile" and 0.95 or 0.20)) and dist2 < (not isPedInVehicle(target) and 0.19 or (getVehicleType(getPedOccupiedVehicle(target)) == "Automobile" and 0.95 or 0.20)) then
            if not (getElementData(target, "Player.Fallen")) then 
                local causing = config["Damages"][tonumber(causing)]
                triggerServerEvent("fallen>player", resourceRoot, source, target, causing)
            end
        end
    end
end
addEventHandler('onClientPlayerWeaponFire', localPlayer, headShotSamu)

registerEventHandler("client.set.fallen", resourceRoot, function ( data )
    return triggerServerEvent("fallen>player", resourceRoot, localPlayer, data)
end)

registerEventHandler("client.inteface.toggle", resourceRoot, function ( state, dados )
    if not state then 
        intefaceClose ( )
    else
        intefaceOpen()
    end
    inteface.dados = dados;
    if inteface.dados then 
        inteface.animations.time[1], inteface.animations.time[2], inteface.animations.time[3] = inteface.dados.time, 0, getTickCount ( )
    end
end)

-- \\ Stretchers //

function interfaceStretcherDraw ( )

    if inteface.stretchers.cursor then 
        
        dxDrawImage(inteface.stretchers.cursor.x, inteface.stretchers.cursor.y, 259, 203, "assets/images/maca.png", 0, 0, 0, tocolor(255, 255, 255, 255))
        dxDrawImage(inteface.stretchers.cursor.x + 20, inteface.stretchers.cursor.y + 121, 14, 14, "assets/images/polygon.png", 0, 0, 0, isCursorOnElement(inteface.stretchers.cursor.x + 20, inteface.stretchers.cursor.y + 121, 156, 18) and tocolor(193, 159, 115, 255) or tocolor(214, 214, 214, 255))
        dxDrawImage(inteface.stretchers.cursor.x + 20, inteface.stretchers.cursor.y + 157, 14, 14, "assets/images/polygon.png", 0, 0, 0, isCursorOnElement(inteface.stretchers.cursor.x + 20, inteface.stretchers.cursor.y + 157, 156, 18) and tocolor(193, 159, 115, 255) or tocolor(214, 214, 214, 255))
   
        dxDrawText("Hospital geral", inteface.stretchers.cursor.x + 79, inteface.stretchers.cursor.y + 21, 101, 18, tocolor(255, 255, 255, 255), 1, exports['guetto_assets']:dxCreateFont("medium", 17), "left", "top")
        dxDrawText(getPlayerName(localPlayer).."#"..(getElementData(localPlayer, "ID") or "N/A"), inteface.stretchers.cursor.x + 79, inteface.stretchers.cursor.y + 45, 101, 18, tocolor(255, 255, 255, 255), 1, exports['guetto_assets']:dxCreateFont("regular", 15), "left", "top")

        dxDrawText((getElementData(localPlayer, "JOAO.lyingStretcher") and "Sair da maca") or "Deitar na maca", inteface.stretchers.cursor.x + 49, inteface.stretchers.cursor.y + 118, 108, 18, isCursorOnElement(inteface.stretchers.cursor.x + 20, inteface.stretchers.cursor.y + 121, 156, 18) and tocolor(193, 159, 115, 255) or tocolor(214, 214, 214, 255), 1, exports['guetto_assets']:dxCreateFont("medium", 15), "left", "top")
        dxDrawText("Iniciar tratamento", inteface.stretchers.cursor.x + 49, inteface.stretchers.cursor.y + 153, 108, 18, isCursorOnElement(inteface.stretchers.cursor.x + 20, inteface.stretchers.cursor.y + 157, 156, 18) and tocolor(193, 159, 115, 255) or tocolor(214, 214, 214, 255), 1, exports['guetto_assets']:dxCreateFont("medium", 15), "left", "top")
    end

end

function interfaceStretcherOpen ( )
    if not inteface.stretchers.state then 
        inteface.stretchers.state = true 
        showCursor(true)
        addEventHandler("onClientRender", root, interfaceStretcherDraw)
        addEventHandler("onClientClick", root, interfaceStretcherClick)
    end
end

function interfaceStretcherClose ( )
    if inteface.stretchers.state then 
        inteface.stretchers.state = false
        showCursor(false)
        removeEventHandler("onClientRender", root, interfaceStretcherDraw)
        removeEventHandler("onClientClick", root, interfaceStretcherClick)
    end
end

function interfaceStretcherClick ( button, state )
    if button == "left" and state == "down" then 
        if inteface.stretchers.cursor then 
            if isCursorOnElement(inteface.stretchers.cursor.x + 20, inteface.stretchers.cursor.y + 121, 156, 18) then 
                if not getElementData(localPlayer, "JOAO.lyingStretcher") then 
                    triggerServerEvent("manage>stretcher", resourceRoot, inteface.stretchers.maca, {getElementPosition(localPlayer)}, {getElementRotation(localPlayer)}, "deitar")
                else
                    triggerServerEvent("manage>stretcher", resourceRoot, inteface.stretchers.maca, {getElementPosition(localPlayer)}, {getElementRotation(localPlayer)}, "sair")
                end
            elseif isCursorOnElement(inteface.stretchers.cursor.x + 20, inteface.stretchers.cursor.y + 157, 156, 18) then 
                triggerServerEvent("manage>stretcher", resourceRoot, inteface.stretchers.maca, {getElementPosition(localPlayer)}, {getElementRotation(localPlayer)}, "tratamento")
            end
        end
    end
end;

registerEventHandler("Stretchers>Toggle", resourceRoot, function ( state, stretcher )
    local cx, cy = getCursorPosition()
    inteface.stretchers.maca = stretcher
    if state then 
        if not inteface.stretchers.state then 
            inteface.stretchers.cursor = {x = cx * 1920, y = cy * 1080}
            interfaceStretcherOpen()
        end
    else
        if inteface.stretchers.state then 
            interfaceStretcherClose ( )
        end
    end
end)

bindKey("backspace", "down", function ( )
    if inteface.stretchers.state then 
        interfaceStretcherClose ( )
    end
end)


bindKey("space", "down", function()
    if (getElementData(localPlayer, "JOAO.lyingStretcher") or false) then
        triggerServerEvent("manage>stretcher", resourceRoot, inteface.stretchers.maca, {getElementPosition(localPlayer)}, {getElementRotation(localPlayer)}, "sair")
    end
end)