local cache = {
    ped = {}
}

local ROUTE_DELAY = {}
local playerData = {}

for i, v in ipairs(config["Peds"]) do 
    local element = createPed(v["Skin"], v["Posição"][1], v["Posição"][2], v["Posição"][3])

    createBlipAttachedTo(element, 42)
    cache.ped[element] = i


    setElementData(element, "onPedTransporter", true)
    setElementRotation(element, v["Rotação"][1], v["Rotação"][2], v["Rotação"][3])
end


createEvent("onPlayerRequestTransporter", resourceRoot, function(player, element)
    if not (client or (source ~= resourceRoot)) then 
        return false 
    end

    if player ~= client then 
        return false 
    end

    if not isElement(element) then 
        return false 
    end

    local index = cache.ped[element];

    return triggerClientEvent(player, "onClientSendIndex", resourceRoot, index)
end)

createEvent("onPlayerFinishTransporter", resourceRoot, function(player)
    if not (client or (source ~= resourceRoot)) then 
        return false 
    end

    if player ~= client then 
        return false 
    end

    if not isElement(player) then 
        return false 
    end

    if not (isPlayerTransporter(player)) then 
        return false 
    end
    
    local account = getAccountName(getPlayerAccount(player));

    if (playerData[account].byPass) then 
        return 
    end

    if not playerData[account] then 
        return false 
    end

    if playerData[account].box and isElement(playerData[account].box) then 
        destroyElement(playerData[account].box)
        playerData[account].box = nil 
    end
    if playerData[account].marker and isElement(playerData[account].marker) then 
        destroyElement(playerData[account].marker)
        playerData[account].marker = nil 
    end
    if playerData[account].marker_caixa and isElement(playerData[account].marker_caixa) then 
        destroyElement(playerData[account].marker_caixa)
        playerData[account].marker_caixa = nil
    end
    if playerData[account].blip and isElement(playerData[account].blip) then 
        destroyElement(playerData[account].blip)
        playerData[account].blip = nil
    end

    playerData[account].marker_back = createMarker(config["Peds"][1]["Devolver"][1], config["Peds"][1]["Devolver"][2], config["Peds"][1]["Devolver"][3] - 0.9, 'cylinder', 4, 139, 100, 255, 0)
    playerData[account].blip = createBlip(config["Peds"][1]["Devolver"][1], config["Peds"][1]["Devolver"][2], config["Peds"][1]["Devolver"][3], 19)

    setElementData(playerData[account].marker_back , 'markerData', {title = 'Transportadora', desc = 'Devolva o caminhão aqui!', icon = 'checkpoint'})

    setElementVisibleTo(playerData[account].marker_back, root, false)
    setElementVisibleTo(playerData[account].marker_back, player, true)

    setElementVisibleTo(playerData[account].blip, root, false)
    setElementVisibleTo(playerData[account].blip, player, true)

    addEventHandler('onMarkerHit', playerData[account].marker_back, function(player, dimension)
        if player and isElement(player) and getElementType(player) == 'player' and dimension then 
            local vehicle = getPedOccupiedVehicle(player)
            if vehicle then 
                if vehicle == playerData[account].vehicle then
                    if (stopPlayerTransporter(player)) then 
                        sendMessageServer(player, 'Caminhão devolvido com sucesso!', 'info')
                    else
                        sendMessageServer(player, 'Não foi possível encerrar seu trabalho!', 'info')
                    end
                else
                    sendMessageServer(player, 'Veículo inválido!', 'error')
                end
            else
                sendMessageServer(player, 'Você não está com um caminhão!', 'error')
            end
        end
    end)
    sendMessageServer(player, 'Devolva o caminhão no local marcado em seu radar!', 'info')
end)

function isPlayerTransporter(player)
    return playerData[getAccountName(getPlayerAccount(player))] or false
end

function stopPlayerTransporter (player)
    if isPlayerTransporter(player) then
        local account = getAccountName(getPlayerAccount(player))

        if playerData[account].box and isElement(playerData[account].box) then
            destroyElement(playerData[account].box)
            playerData[account].box = nil
        end

        if playerData[account].marker and isElement(playerData[account].marker) then
            destroyElement(playerData[account].marker)
            playerData[account].marker = nil
        end

        if playerData[account].marker_back and isElement(playerData[account].marker_back) then
            destroyElement(playerData[account].marker_back)
            playerData[account].marker_back = nil
        end

        if playerData[account].marker_caixa and isElement(playerData[account].marker_caixa) then
            destroyElement(playerData[account].marker_caixa)
            playerData[account].marker_caixa = nil
        end

        if playerData[account].vehicle and isElement(playerData[account].vehicle) then
            destroyElement(playerData[account].vehicle)
            playerData[account].vehicle = nil
        end

        if playerData[account].blip and isElement(playerData[account].blip) then 
            destroyElement(playerData[account].blip)
            playerData[account].blip = nil
        end

        playerData[account] = nil
        return true 
    end
    return false
end


createEvent("onPlayerTransport", resourceRoot, function(player, index_transporter, index_route)
    if not (client or (source ~= resourceRoot)) then 
        return false 
    end

    if player ~= client then 
        return false 
    end

    if not index_transporter then
        return false
    end

    local account = getAccountName(getPlayerAccount(player))
    local x, y, z = getElementPosition(source)

    if ROUTE_DELAY[account] and ROUTE_DELAY[account].i == index_route and ROUTE_DELAY[account].delay and getTickCount( ) - ROUTE_DELAY[account].delay <= 30 * 60000 then 
        return sendMessageServer(player, 'Você já utilizou essa rota recentemente. Aguarde 30 minutos para utilizá-la novamente.', 'info')
    end


    if isPlayerTransporter(player) then
        if playerData[account].marker and isElement(playerData[account].marker) then 
            destroyElement(playerData[account].marker)
            playerData[account].marker = nil 
        end

        if playerData[account].blip and isElement(playerData[account].blip) then 
            destroyElement(playerData[account].blip)
            playerData[account].blip = nil 
        end
        
        if playerData[account].box and isElement(playerData[account].box) then 
            destroyElement(playerData[account].box)
            playerData[account].box = nil 
        end

        if playerData[account].marker_caixa and isElement(playerData[account].marker_caixa) then 
            destroyElement(playerData[account].marker_caixa)
            playerData[account].marker_caixa = nil 
        end

        if not (ROUTE_DELAY[account]) then 
            ROUTE_DELAY[account] = {delay = getTickCount(), i = index_route}
        end

        playerData[account].count = 0
        playerData[account].marker_caixa = createMarker(x, y, z - 0.9, "cylinder", 2, 255, 0, 0, 0)

        playerData[account].blip = createBlip(config["Destinos"][index_route]["Posição"][1], config["Destinos"][index_route]["Posição"][2], config["Destinos"][index_route]["Posição"][3], 19)
        playerData[account].marker = createMarker(config["Destinos"][index_route]["Posição"][1], config["Destinos"][index_route]["Posição"][2], config["Destinos"][index_route]["Posição"][3] - 0.9, "cylinder", 2, 255, 0, 0, 0)
        
        setElementVisibleTo(playerData[account].blip, root, false)
        setElementVisibleTo(playerData[account].blip, player, true)
    
        setElementVisibleTo(playerData[account].marker, root, false)
        setElementVisibleTo(playerData[account].marker, player, true)

        setElementData(playerData[account].marker , 'markerData', {title = 'Transportadora', desc = 'Enregue as encomendas aqui!', icon = 'courier'})
        setElementData(playerData[account].marker_caixa , 'markerData', {title = 'Transportadora', desc = 'Pegue as caixas aqui!', icon = 'magazineBox'})

        attachElements(playerData[account].marker_caixa, playerData[account].vehicle, 0, -4, -1, 0, 0, 0);
        setElementVisibleTo(playerData[account].marker_caixa, root, false)

        setElementData(playerData[account].vehicle, 'upcodes > map route', {config["Destinos"][index_route]["Posição"][1], config["Destinos"][index_route]["Posição"][2], 0})
        sendMessageServer(player, "Siga para sua proxima entrega!", "info")
    else
        playerData[account] = {
            index = index_route,
            vehicle = createVehicle(config["Peds"][1].Veiculo[1], config["Peds"][1].Veiculo[2], config["Peds"][1].Veiculo[3], config["Peds"][1].Veiculo[4], config["Peds"][1].Veiculo[5], config["Peds"][1].Veiculo[6], config["Peds"][1].Veiculo[7])
        }
    
        playerData[account].marker = createMarker(config["Destinos"][index_route]["Posição"][1], config["Destinos"][index_route]["Posição"][2], config["Destinos"][index_route]["Posição"][3] - 0.9, "cylinder", 2, 255, 0, 0, 0)
        playerData[account].blip = createBlip(config["Destinos"][index_route]["Posição"][1], config["Destinos"][index_route]["Posição"][2], config["Destinos"][index_route]["Posição"][3], 19)
        playerData[account].box = false
    
        playerData[account].count = 0
        playerData[account].marker_caixa = createMarker(x, y, z - 0.9, "cylinder", 2, 255, 0, 0, 0)
    
        if not (ROUTE_DELAY[account]) then 
            ROUTE_DELAY[account] = {delay = getTickCount(), i = index_route}
        end
    
        setElementData(playerData[account].marker , 'markerData', {title = 'Transportadora', desc = 'Enregue as encomendas aqui!', icon = 'courier'})
        setElementData(playerData[account].marker_caixa , 'markerData', {title = 'Transportadora', desc = 'Pegue as caixas aqui!', icon = 'magazineBox'})
    
        attachElements(playerData[account].marker_caixa, playerData[account].vehicle, 0, -4, -1, 0, 0, 0);
        setElementVisibleTo(playerData[account].marker_caixa, root, false)
    
        setElementVisibleTo(playerData[account].blip, root, false)
        setElementVisibleTo(playerData[account].blip, player, true)
    
        setElementVisibleTo(playerData[account].marker, root, false)
        setElementVisibleTo(playerData[account].marker, player, true)
    
        triggerClientEvent(player, 'onPlayerTogglePanelTransporter', resourceRoot)
        setElementData(playerData[account].vehicle, 'upcodes > map route', {config["Destinos"][index_route]["Posição"][1], config["Destinos"][index_route]["Posição"][2], 0})
        sendMessageServer(player, "Você iniciou a carga com sucesso, pegue o caminhão e vamos para o destino!", "info")
    end

    playerData[account].byPass = true

    addEventHandler('onMarkerHit', playerData[account].marker, function (player, dimension)
        if player and isElement(player) and getElementType(player) == 'player' and dimension then 
            if isPlayerTransporter(player) then
                if isElement(playerData[account].box) then 
                    local pX, pY, pZ = getElementPosition(player);

                    toggleControl(player, "jump", true)
                    toggleControl(player, "fire", true)
                    toggleControl(player, "aim_weapon", true)
                    setPedAnimation(player, "CARRY", "putdwn", 1000, false, true)

                    setTimer(
                        function(player)
                            if ( playerData[account].count >= 5 ) then 
                                if playerData[account].box and isElement(playerData[account].box) then 
                                    destroyElement(playerData[account].box)
                                    playerData[account].box = nil 
                                end

                                setElementFrozen(player, false)
                                setPedAnimation(player, nil);

                                sendMessageServer(player, "Você entregou todas as caixas!", "success")

                                local account = getAccountName(getPlayerAccount(player))
                                if playerData[account].box and isElement(playerData[account].box) then 
                                    destroyElement(playerData[account].box)
                                    playerData[account].box = nil 
                                end
                                if playerData[account].marker and isElement(playerData[account].marker) then 
                                    destroyElement(playerData[account].marker)
                                    playerData[account].marker = nil 
                                end
                                if playerData[account].marker_caixa and isElement(playerData[account].marker_caixa) then 
                                    destroyElement(playerData[account].marker_caixa)
                                    playerData[account].marker_caixa = nil
                                end
                                                          
                                givePlayerMoney(player, config["Destinos"][index_route]["Pagamento"])
                                triggerClientEvent(player, "onClientSendIndex", resourceRoot, playerData[account].index)

                                playerData[account].byPass = false 

                                setVehicleDoorOpenRatio(playerData[account].vehicle, 5, 0, 1000)
                                setVehicleDoorOpenRatio(playerData[account].vehicle, 4, 0, 1000)

                                sendMessageServer(player, 'Você entregou todas as caixas e recebeu R$ '..formatNumber(config["Destinos"][index_route]["Pagamento"], '.')..'.', 'success')
                            else

                                if playerData[account].box and isElement(playerData[account].box) then 
                                    destroyElement(playerData[account].box)
                                    playerData[account].box = nil 
                                end

                                setElementFrozen(player, false)
                                setPedAnimation(player, nil)

                                playerData[account].count = playerData[account].count + 1
                                sendMessageServer(player, "Você entregou "..(playerData[account].count).."/5 volte para pegar mais caixas no caminhão!", "info");
                            end

                        end
                    , 1000, 1, player);
                else
                    sendMessageServer(player, "Você não está com uma caixa em mãos!", "error")
                end
            end
        end
    end)


end)

function deliverBox (player)
    if (player and isElement(player) and getElementType(player) == 'player') then 
        if (isPlayerTransporter(player)) then
            local account = getAccountName(getPlayerAccount(player))
            if not isElement(playerData[account].box) then 
                local x, y, z = getElementPosition(player);

                if playerData[account].box and isElement(playerData[account].box) then 
                    destroyElement(playerData[account].box)
                    playerData[account].box = nil 
                end

                setPedAnimation(player, "CARRY", "liftup", 1.0, false);

                setTimer(function(player)

                    setPedAnimation(player);
                    toggleControl(player, "jump", false);
                    toggleControl(player, "fire", false);
                    toggleControl(player, "aim_weapon", false);

                    sendMessageServer(player, "Entregue a caixa no local marcado.", "info");
                    setPedAnimation(player, "CARRY", "crry_prtial", 1.0);

                    playerData[account].box = createObject(1220, x, y, z);
                    exports['pattach']:attach(playerData[account].box, player, 4, 0.04,0.5,0.18,0,0,0);
               
                    setObjectScale(playerData[account].box, 0.8);
                end, 1000, 1, player)
            else
                sendMessageServer(player, "Entregue a caixa!", "success")
            end
        end
    end
end


addEventHandler('onVehicleStartExit', root, 
    function(player)
        local account = getAccountName(getPlayerAccount(player))
        if (isPlayerTransporter(player)) then 
            if playerData[account].marker and isElement(playerData[account].marker) then 
                local x, y, z = getElementPosition(player);
                local x2, y2, z2 = getElementPosition(playerData[account].marker)
                local distance = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2);
                if distance <= 10 then 
                    setElementVisibleTo(playerData[account].marker_caixa, player, true)
                    setVehicleDoorOpenRatio(playerData[account].vehicle, 5, 1, 1000)
                    setVehicleDoorOpenRatio(playerData[account].vehicle, 4, 1, 1000)
                    addEventHandler('onMarkerHit', playerData[account].marker_caixa, deliverBox)
                    sendMessageServer(player, 'Pegue as caixas no caminhão e entregue-as no local marcado.', 'info')
                else
                    sendMessageServer(player, "Caminhão está muito longe do destino!", "error")
                end
            end
        end
    end
)

addEventHandler('onPlayerQuit', root, function ( )
    stopPlayerTransporter(source)
end)