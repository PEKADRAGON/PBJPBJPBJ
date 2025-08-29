local pS = {guiGetScreenSize()};
local x, y = (pS[1]/1920), (pS[2]/1080);

local backgroundX, backgroundY = 714, 398

local resource = { }

function isCursorOnElement(posX, posY, width, height)
    if (isCursorShowing()) then
        local posX, posY, width, height = x * posX, y * posY, x * width, y * height;
        local MouseX, MouseY = getCursorPosition();
        local clientW, clientH = guiGetScreenSize();
        local MouseX, MouseY = MouseX * clientW, MouseY * clientH
        if (MouseX > posX and MouseX < (posX + width) and MouseY > posY and MouseY < (posY + height)) then
            return true;
        end
    end
    return false;
end
local _dxDrawText = dxDrawText;
function dxDrawText(text, pX, pY, w, h, color, size, ...)
    local pX, pY, w, h = pX, pY, (pX + w), (pY + h);
    return _dxDrawText(text, x * pX, y * pY, x * w, y * h, color, x * size, ...);
end

local _dxDrawRectangle = dxDrawRectangle;
function dxDrawRectangle(pX, pY, w, h, ...)
    return _dxDrawRectangle(x * pX, y * pY, x * w, y * h, ...);
end

local textures = {}
local _dxDrawImage = dxDrawImage;
function dxDrawImage(pX, pY, w, h, ...)
    return _dxDrawImage(x * pX, y * pY, x * w, y * h, ...);
end

resource.vetores = {
    background = svgCreate(491, 317, "public/svgs/background.svg"),
    close = svgCreate(33, 33, "public/svgs/close.svg"),
    button = svgCreate(448, 65, "public/svgs/button.svg"),
    icon_ammo = svgCreate(41, 42, "public/svgs/ammo-icon.svg"),
    icon_weapon = svgCreate(35, 34, "public/svgs/weapon-icon.svg"),
    button_start = svgCreate(448, 46, "public/svgs/button_start.svg"),
}

resource.fonts = {
    Akrobat_Regular_18 = dxCreateFont("public/fonts/Akrobat-Regular.ttf", 18),
    Akrobat_Regular_15 = dxCreateFont("public/fonts/Akrobat-Regular.ttf", 15),
    Arkobat_Light_15 = dxCreateFont("public/fonts/Akrobat-Light.ttf", 14),
    Arkobat_Light_12 = dxCreateFont("public/fonts/Akrobat-Light.ttf", 12),
}

resource.select = 0
resource.window = "home"
resource.index = 0

resource.sendMessageClient = config.sendMessageClient

resource.sounds = {
    bip = false;
}

resource.drawning = function ()

    if (resource.window == "home") then 

        dxDrawImage(backgroundX, backgroundY, 491, 317, resource.vetores.background);
        dxDrawImage(backgroundX + 431, backgroundY + 23, 33, 33, resource.vetores.close, 0, 0, 0, isCursorOnElement(backgroundX + 431, backgroundY + 23, 33, 33) and tocolor(181, 106, 106, 255) or tocolor(178, 177, 182, 255));
        dxDrawImage(backgroundX + 21, backgroundY + 238, 447, 45, resource.vetores.button_start, 0, 0, 0, isCursorOnElement(backgroundX + 21, backgroundY + 238, 447, 45) and tocolor(130, 156, 126, 255) or tocolor(99, 98, 109, 255));
    
        dxDrawText("ENTREGA DE ILEGAIS", backgroundX + 21, backgroundY + 19, 229, 29, tocolor(255, 255, 255, 255), 1, resource.fonts.Akrobat_Regular_18, "left", "top")

        dxDrawText("ESCOLHA QUE TIPO DE ROTA VOCÊ DESEJA FAZER.", backgroundX + 21, backgroundY + 50, 326, 23, tocolor(163, 163, 163, 255), 1, resource.fonts.Arkobat_Light_15, "left", "top")
        
        dxSetBlendMode("add")
    
        dxDrawImage(backgroundX + 21, backgroundY + 90, 448, 65, resource.vetores.button, 0, 0, 0,  resource.select == 1 and tocolor(126, 149, 156, 255) or isCursorOnElement(backgroundX + 21, backgroundY + 90, 448, 65, resource.vetores.button) and tocolor(126, 149, 156, 255) or tocolor(52, 51, 60, 255));
        dxDrawImage(backgroundX + 21, backgroundY + 157, 448, 65, resource.vetores.button, 0, 0, 0, resource.select == 2 and tocolor(126, 149, 156, 255) or isCursorOnElement(backgroundX + 21, backgroundY + 157, 448, 65) and tocolor(126, 149, 156, 255) or  tocolor(52, 51, 60, 255));
    
        dxDrawImage(backgroundX + 36, backgroundY + 105, 35, 34, resource.vetores.icon_weapon);
        dxDrawImage(backgroundX + 34, backgroundY + 170, 41, 42, resource.vetores.icon_ammo);
    
        dxSetBlendMode("blend")
    
        dxDrawText("ENTREGA DE ARMAS", backgroundX + 87, backgroundY + 106, 169, 29, tocolor(218, 218, 218, 255), 1, resource.fonts.Akrobat_Regular_18, "left", "top")
        dxDrawText("ENTREGA DE DROGAS", backgroundX + 87, backgroundY + 175, 189, 29, tocolor(218, 218, 218, 255), 1, resource.fonts.Akrobat_Regular_18, "left", "top")
    
        dxDrawText("COMEÇAR", backgroundX + 21, backgroundY + 238, 447, 45, tocolor(218, 218, 218, 255), 1, resource.fonts.Akrobat_Regular_18, "center", "center")
        
    elseif (resource.window == "confirm") then 
        
        dxDrawImage(backgroundX, backgroundY, 491, 256, resource.vetores.background);
        dxDrawImage(backgroundX + 430, backgroundY + 21, 33, 33, resource.vetores.close, 0, 0, 0, isCursorOnElement(backgroundX + 430, backgroundY + 21, 33, 33) and tocolor(181, 106, 106, 255) or tocolor(178, 177, 182, 255));

        dxDrawText("ENTREGA DE ILEGAIS", backgroundX + 21, backgroundY + 27, 229, 29, tocolor(255, 255, 255, 255), 1, resource.fonts.Akrobat_Regular_18, "left", "top")
        dxDrawText("VOCÊ SÓ PODERÁ VOAR Á UMA ALTURA DETERMINADA PARA NÃO\nSER PEGO PELO RADAR. ENTREGUE NO LOCAL MARCADO!", backgroundX + 21, backgroundY + 78, 326, 23, tocolor(163, 163, 163, 255), 1, resource.fonts.Arkobat_Light_12, "left", "top")

        dxDrawImage(backgroundX + 21, backgroundY + 180, 447, 45, resource.vetores.button_start, 0, 0, 0, isCursorOnElement(backgroundX + 21, backgroundY + 180, 447, 45) and tocolor(130, 156, 126, 255) or tocolor(99, 98, 109, 255));
        dxDrawText("ME RESPONSABILIZO, PELA ENTREGA.", backgroundX + 21, backgroundY + 180, 447, 45, tocolor(218, 218, 218, 255), 1, resource.fonts.Akrobat_Regular_15, "center", "center")

    end

end;

addEventHandler("onClientRender", root, function()
    local data = getElementData(localPlayer, "Guh > Service > Drugs") or false
    if data and data.airplane and isElement(data.airplane) then
        local vehicleInGround = isVehicleOnGround (data.airplane)
        if not (vehicleInGround) then 
            if (getPedOccupiedVehicle(localPlayer) and getPedOccupiedVehicle(localPlayer) == data.airplane) then 
                local vehicle_position = Vector3(getElementPosition(data.airplane))
                local vehicle_altitude = math.floor(vehicle_position.z)
                dxDrawText("Altura: ".. (vehicle_altitude) .."\nALTURA PERMITIDA: 120 ", 851.5, 1000.45, 100, 20, tocolor(255, 255, 255, 255), 1, resource.fonts.Akrobat_Regular_15, "left", "top")
            end
        end
    end
end)

local switch = {
    ["showning"] = function ( )
        if not (resource.showning) then 
            resource.showning = true 
            resource.window = "home"
            showCursor(true)
            addEventHandler("onClientRender", root, resource.drawning)
        end
    end;
    ["hide"] = function ( )
        if (resource.showning) then 
            resource.showning = false;
            resource.select = 0
            resource.index = 0
            showCursor(false)
            removeEventHandler("onClientRender", root, resource.drawning)
        end
    end;
}

addEventHandler("onClientClick", root, function (button, state)
    if (button == "left" and state == "down") then 
        if (resource.showning) then 
            if (resource.window == "home") then 
                if (isCursorOnElement(backgroundX + 431, backgroundY + 23, 33, 33)) then 
                    switch["hide"]()
                elseif (isCursorOnElement(backgroundX + 21, backgroundY + 90, 448, 65)) then 
                    resource.select = 1
                elseif (isCursorOnElement(backgroundX + 21, backgroundY + 157, 448, 65)) then 
                    resource.select = 2
                elseif (isCursorOnElement(backgroundX + 21, backgroundY + 238, 447, 45)) then 
                    if (resource.select ~= 0) then 
                        resource.window = "confirm"
                    else
                        resource.sendMessageClient("Selecione uma rota!", "error")
                    end
                end
            elseif (resource.window == "confirm") then 
                if (isCursorOnElement(backgroundX + 430, backgroundY + 21, 33, 33)) then 
                    switch["hide"]()
                elseif (isCursorOnElement(backgroundX + 21, backgroundY + 180, 447, 45)) then 
                    triggerServerEvent("Guh > Start > Entrega", resourceRoot, localPlayer, resource.select, resource.index)
                    switch["hide"]()
                end
            end
        end
    end
end)

addEvent("Guh > Drawning", true)
addEventHandler("Guh > Drawning", resourceRoot, function (index)
    switch["showning"]()
    resource.index = index
end)

setElementData(localPlayer, "Guh > Service > Drugs", false)

--[[
    
addEvent("Guh > Sound", true)
addEventHandler("Guh > Sound", resourceRoot, function(ped)
    if (ped and isElement(ped) and getElementType(ped) == "ped") then 
        local x, y, z = getElementPosition(ped)
        resource.sound = playSound3D(config.desmanche.audio, x, y, z)
        setSoundVolume(resource.sound, 2)
        setTimer(function ( )
            if (resource.sound and isElement(resource.sound)) then 
                destroyElement(resource.sound)
                resource.sound = nil 
            end
        end, 8000, 1)
    end
end)

]]

resource.sounds = {}
resource.timers = false;
resource.alertaEnviado = false;

local function checkAltitude()
    local data = getElementData(localPlayer, "Guh > Service > Drugs") or false
    if data and data.airplane and isElement(data.airplane) then
        local vehicleInGround = isVehicleOnGround (data.airplane)
        if not (vehicleInGround) then 
            if (getPedOccupiedVehicle(localPlayer) and getPedOccupiedVehicle(localPlayer) == data.airplane) then 
                local vehicle_position = Vector3(getElementPosition(data.airplane))
                local vehicle_altitude = math.floor(vehicle_position.z)

                if vehicle_altitude >= config.others.altitude then
                    if not (resource.timers) then 
                        resource.timers = setTimer(function()
                            if (resource.alertaEnviado == false) then 
                                resource.alertaEnviado = true
                                triggerServerEvent("Guh > Alerta", resourceRoot, localPlayer)
                            end
                        end, 10000, 1)
                    end
                    if not (resource.sounds.bip and isElement(resource.sounds.bip)) then
                        resource.sounds.bip = playSound("public/sfx/bip.wav", false)
                        setSoundVolume(resource.sounds.bip, 0.1)
                    end
                else
                    if resource.sounds.bip and isElement(resource.sounds.bip) then
                        stopSound(resource.sounds.bip)
                        resource.alertaEnviado = false;
                    end
                    if resource.timers then 
                        killTimer(resource.timers)
                        resource.timers = false
                    end
                end
            end
        end
    end
end

addEvent("Guh > Start > Service > Client", true)
addEventHandler("Guh > Start > Service > Client", resourceRoot, function ()
    setTimer(checkAltitude, 1000, 0)
end)
