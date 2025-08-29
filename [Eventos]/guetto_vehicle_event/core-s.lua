local vehicle = false;
local marker = false;
local state = false;

addCommandHandler('eventocar', function(player, cmd)
    local account = getAccountName(getPlayerAccount(player));

    if not isObjectInACLGroup("user."..account, aclGetGroup("Console")) then
        return false 
    end

    if state then 
        return sendMessageServer(player, "O evento já foi iniciado!", "info")
    end;

    if marker and isElement(marker) then 
        destroyElement(marker)
    end

    if vehicle and isElement(vehicle) then 
        destroyElement(vehicle)
    end

    local i = #config['vehiclePos']

    vehicle = createVehicle(config.vehiclePos[i][1], config.vehiclePos[i][2], config.vehiclePos[i][3], config.vehiclePos[i][4], config.vehiclePos[i][5], config.vehiclePos[i][6])
    marker = createMarker(unpack(config.markerPos))
    
    createBlipAttachedTo(vehicle, config['blip'])
    
    state = true 

    setElementData(vehicle, "EventVehicle", true)
    sendMessageServer(player, "Você iniciou o evento!", "info")
    outputChatBox(config["mensagem"], root, 255, 255, 255, true)
end)


addCommandHandler("finalizarevento", function(player)
    local account = getAccountName(getPlayerAccount(player));

    if not isObjectInACLGroup("user."..account, aclGetGroup("Console")) then
        return false 
    end

    if not state then 
        return sendMessageServer(player, "Não foram encontrados eventos em andamento!", "info")
    end;

    if marker and isElement(marker) then 
        destroyElement(marker)
    end

    if vehicle and isElement(vehicle) then 
        destroyElement(vehicle)
    end

    state = false 
    sendMessageServer(player, "Você finalizou o evento!", "info")
end)

addEventHandler('onMarkerHit', resourceRoot, function(player, dimension)
    if player and isElement(player) and getElementType(player) == 'player' and dimension then 
        if marker and isElement(marker) and source == marker then 
            if vehicle and isElement(vehicle) and getPedOccupiedVehicle(player) and getPedOccupiedVehicle(player)  == vehicle then 
                destroyElement(vehicle)
                destroyElement(marker)
                local random = math.random(config["dinheiroSujo"].quantidade[1], config["dinheiroSujo"].quantidade[2])
                exports["guetto_inventory"]:giveItem(player, config["dinheiroSujo"].id, random)
                outputChatBox("O Jogador #FFB84E"..(getPlayerName(player)).." #FFFFFFentregou o veículo e ganhou o evento!", root, 255, 255, 255, true)
                sendMessageServer(player, "Você ganhou o evento e recebeu R$ ".. (random).." de dinheiro sujo!", "info")
                state = false
            end
        end
    end 
end)