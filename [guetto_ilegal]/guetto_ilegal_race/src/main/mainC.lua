local interface = {
    panel = {
        isEventHandlerAdded = false,
        window = "start"
    },
    animations = {
        alpha = {0, 0, 0},
        money = {0, 0, 0},
    },
    race = {
        time = {0, 0, 0},
        marker = false,
    }
}

function draw ( )
    local fade = interpolateBetween (interface.animations.alpha[1], 0, 0, interface.animations.alpha[2], 0, 0, (getTickCount() - interface.animations.alpha[3]) / 400, 'Linear')
    local x, y = 1920, 1080
    
    if (interface.panel.window == "start") then 

        local money = interpolateBetween(interface.animations.money[1], 0, 0, interface.animations.money[2], 0, 0, (getTickCount() - interface.animations.money[3]) / 10000, 'Linear')
        local screenWidth, screenHeight = 1920, 1080
        local iconWidth, iconHeight = 396, 243
        local iconX = (screenWidth - iconWidth) / 2
        local iconY = 350
    
        dxDrawImage(iconX, iconY, iconWidth, iconHeight, "assets/images/icon.png", 0, 0, 0, tocolor(255, 255, 255, fade))
        dxDrawText("Finalize o checkpoints para receber dinheiro sujo, mas não abandone o veículo, instalamos uma bomba ao sair vai explodir.", 725, 570, 454, 40, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("light", 15), "center", "center", false, true)
        dxDrawText("PRESSIONE [H] PARA COMEÇAR", 817, 894, 254, 16, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('bold', 18), 'center', 'center')
    
    elseif (interface.panel.window == "current") then 

        local timer = interpolateBetween(interface.race.time[1], 0, 0, 0, 0, 0, ((getTickCount() - interface.race.time[3]) / interface.race.time[1]), 'Linear')
        local minutes, seconds = convertTime(timer)

        dxDrawImage(1609, 497, 292, 71, "assets/images/rectangle.png", 0, 0, 0, tocolor(255, 255, 255, fade))
        dxDrawText("Tempo total:", 1634, 526, 95, 15, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'left', 'center')
        dxDrawText(minutes..":"..seconds, 1812, 526, 95, 15, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'left', 'center')

        dxDrawImage(1764, 521, 24, 24, "assets/images/icon-time.png", 0, 0, 0, tocolor(255, 255, 255, fade))
    end

end

function onPlayerKey ( )
    triggerServerEvent("onPlayerGetItens", resourceRoot)
end

function interfaceToggle ( state, index )
    if state then 
        if not (interface.panel.isEventHandlerAdded) then 
            interface.panel.isEventHandlerAdded = true 
            interface.panel.window = "start"
            interface.panel.index = index;
            interface.animations.alpha = {0, 255, getTickCount()}
            showChat(false)
            bindKey("H", "down", onPlayerKey)
            addEventHandler("onClientRender", root, draw)
        end
    else
        if (interface.panel.isEventHandlerAdded) then 
            
            interface.panel.isEventHandlerAdded = false
            interface.animations.alpha = {255, 0, getTickCount()}
            
            showChat(true)
            unbindKey("H", "down", onPlayerKey)
            
            if (interface.race.marker and isElement(interface.race.marker)) then
                destroyElement(interface.race.marker)
                interface.race.marker = nil 
            end
            
            if interface.race.timer and isTimer(interface.race.timer) then 
                killTimer(interface.race.timer)
                interface.race.timer = nil 
            end
            
            setTimer(function()
                removeEventHandler("onClientRender", root, draw)
            end, 400, 1)
        end
    end
end

addEvent("ToggleInterface", true)
addEventHandler("ToggleInterface", resourceRoot, function ( state, index )
    if (state) then 
        interfaceToggle(true, index)
    else
        interfaceToggle(false)
    end
end)


addEvent("onPlayerStartRace", true)
addEventHandler("onPlayerStartRace", resourceRoot, 
    function ( )
        local data = config["Locations"][interface.panel.index]
        interface.panel.window = "current"
        interface.race.time = {config["Others"]["time"], 0, getTickCount()}

        interface.race.timer = setTimer(
            function() 
                triggerServerEvent("onVehicleExplosion", resourceRoot)
            end, config["Others"]["time"], 1
        )

        interface.race.vehicle = getPedOccupiedVehicle(localPlayer)
        interface.race.marker = createMarker(data.destiny[1], data.destiny[2], data.destiny[3], data.destiny[4], data.destiny[5], data.destiny[6], data.destiny[7], data.destiny[8], data.destiny[9])
        interface.animations.alpha = {0, 255, getTickCount()}
        setElementData(getPedOccupiedVehicle(localPlayer), 'upcodes > map route', {data.destiny[1], data.destiny[2]})
        triggerEvent('togglePoint', localPlayer,  data.destiny[1], data.destiny[2], data.destiny[3] )

        unbindKey("E", "down", onPlayerKey)
        config.sendMessageClient("Você iniciou a corrida ilegal!", "info")
    end
)

addEventHandler("onClientMarkerHit", resourceRoot, function (player, dimension)
    if (player and isElement(player) and getElementType(player) == "player" and dimension) then 
        local vehicle = getPedOccupiedVehicle(player)
        if (interface.race.marker and interface.race.marker == source) then 

            if not (vehicle) then 
                return config.sendMessageClient("Você não está em um veículo!", "error")
            end
            
            if (vehicle ~= interface.race.vehicle) then 
                return config.sendMessageClient("Esse veículo não é o mesmo que você iniciou a corrida!", "error")
            end

            if interface.race.timer and isTimer(interface.race.timer) then 
                killTimer(interface.race.timer)
                interface.race.timer = nil 
            end

            interfaceToggle(false)
            triggerServerEvent("onPlayerFinishRace", resourceRoot, interface.panel.index)
        end
    end
end)

local speed = 5000

function renderReward()
    local money = interpolateBetween(interface.animations.money[1], 0, 0, interface.animations.money[2], 0, 0, (getTickCount() - interface.animations.money[3]) / speed, 'Linear')
    local screenWidth, screenHeight = 1920, 1080
    local imageWidth, imageHeight = 396, 242
    local x = (screenWidth - imageWidth) / 2 
    local y = 235

    dxDrawImage(x, y, imageWidth, imageHeight, "assets/images/icon-reward.png", 0, 0, 0, tocolor(255, 255, 255, fade))
    dxDrawText("CHECKPOINTS", 891, 413, 122, 16, tocolor(146, 251, 97, fade), 1, exports['guetto_assets']:dxCreateFont("bold", 16), "center", "center")
    dxDrawText("CONCLUÍDO", 891, 431, 122, 16, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("bold", 16), "center", "center")
    dxDrawText("+"..formatNumber(math.floor(money), "."), 848, 453, 217, 37, tocolor(146, 251, 97, fade), 1, exports['guetto_assets']:dxCreateFont("bold", 37), "center", "center")

    if (getTickCount() - interface.animations.money[3]) >= speed then 
        renderToggleReward(false)
    end
end

local isEventHandlerAdded = false 
function renderToggleReward ( state )
    if state and not isEventHandlerAdded then
        isEventHandlerAdded = true  
        addEventHandler("onClientRender", root, renderReward)
    else
        isEventHandlerAdded = false
        removeEventHandler("onClientRender", root, renderReward)
    end
end

addEvent("onClientFinish", true)
addEventHandler("onClientFinish", resourceRoot, function ( money )
    interface.animations.money = {0, money, getTickCount()}
    renderToggleReward(true)
end)
