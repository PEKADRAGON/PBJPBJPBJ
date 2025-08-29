local cache = {}
local cache_destroy = {}
local playerData = {}

addEventHandler('onResourceStart', resourceRoot, function ()
    for i, v in ipairs (config['Positions']) do 
        local marker = createMarker(v[1], v[2], v[3] - 0.9, 'cylinder', 1.5, 139, 100, 255, 0)
        local marker_destroy = createMarker(config["Gerenciador"][v[4]]["DestroyVehicle"][1], config["Gerenciador"][v[4]]["DestroyVehicle"][2], config["Gerenciador"][v[4]]["DestroyVehicle"][3] - 0.9, 'cylinder', 1.5, 139, 100, 255, 0)
        
        setElementData(marker, 'markerData', {title = 'Gerenciador', desc = 'Gerencie seu dia.', icon = 'checkpoint'})
        setElementData(marker_destroy, 'markerData', {title = 'Guardar veículo', desc = 'Para voltar a garagem', icon = 'garage'})

        setElementInterior(marker, v.int)
        setElementDimension(marker, v.dim)

        addEventHandler('onMarkerHit', marker_destroy, function(player, dim)
            if (not player or not isElement(player) or getElementType(player) ~= 'player') then
                return false 
            end
            if isPlayerHavePermission(player, v[4]) then 
                triggerClientEvent(player, 'toggleDestroyVehicle', resourceRoot, v[4])
            else
                sendMessageServer(player, 'Você não possui permissão!', 'info')
            end
        end)

        cache[marker] = i
    end
end)

addEventHandler('onMarkerHit', resourceRoot, function (player, dimension)
    if (not player or not isElement(player) or getElementType(player) ~= 'player') then
        return false 
    end

    if (isPedInVehicle(player)) then
        return false 
    end

    local id = cache[source]

    if (not id) then
        return false
    end

    local acl = config['Positions'][id][4];

    if (not isPlayerHavePermission(player, acl)) then
        return sendMessageServer(player, 'Você não possui permissão!', 'info')
    end

    triggerClientEvent(player, 'onPlayerDrawPanel', resourceRoot, acl, config["Gerenciador"][acl])
end)

createEvent("onPlayerExecuteAction", resourceRoot, function ( ... ) 
    if not (client or ( source ~= resourceRoot ) ) then 
        return false 
    end

    local ARGS = ...
    
    if not playerData[getAccountName(getPlayerAccount(client))] then 
        playerData[getAccountName(getPlayerAccount(client))] = {}
    end

    if not (isPlayerHavePermission(client, ARGS.acl)) then 
        return sendMessageServer(client, 'Voce não possui permissão!', 'info')
    end

    local typeof = config["ElementsData"][config["Gerenciador"][ARGS.acl]["Type"]]

    if not (getElementData(client, typeof)) then 
        return sendMessageServer(client, "Entre em serviço!", "info")
    end

    if (ARGS.window == 'Skins') then
        playerData[getAccountName(getPlayerAccount(client))].skin = getElementModel(client)
        
        setElementModel(client, ARGS.data.id)
        sendMessageServer(client, 'Você pegou a skin com sucesso!', 'success')

    elseif (ARGS.window == 'Veiculos') then

        if (config["Gerenciador"][ARGS.acl][ARGS.window][ARGS.i].space <= 0) then 
            return sendMessageServer(client, 'Não possui mais espaço na garagem!', 'info')
        end

        if (playerData[getAccountName(getPlayerAccount(client))].vehicle and isElement(playerData[getAccountName(getPlayerAccount(client))].vehicle)) then 
            return sendMessageServer(client, 'Você já possui um veículo spawnado!', 'info')
        end
        
        config["Gerenciador"][ARGS.acl][ARGS.window][ARGS.i].space = config["Gerenciador"][ARGS.acl][ARGS.window][ARGS.i].space - 1
        playerData[getAccountName(getPlayerAccount(client))].vehicle = createVehicle(ARGS.data.id, unpack(ARGS.data.spawn))

        setElementInterior(playerData[getAccountName(getPlayerAccount(client))].vehicle, 0)
        setElementDimension(playerData[getAccountName(getPlayerAccount(client))].vehicle, 0)

        setElementInterior(client, 0)
        setElementDimension(client, 0)
      
        setElementData(playerData[getAccountName(getPlayerAccount(client))].vehicle, ARGS.data.plotagem, true )
        setElementData(playerData[getAccountName(getPlayerAccount(client))].vehicle, 'Owner', getAccountName(getPlayerAccount(client)))

        warpPedIntoVehicle(client, playerData[getAccountName(getPlayerAccount(client))].vehicle)

        sendMessageServer(client, 'Você retirou o veículo da garagem!', 'info')
        
    elseif (ARGS.window == 'TakeClothes') then 

        if playerData[getAccountName(getPlayerAccount(client))].skin then 
            setElementModel(client, playerData[getAccountName(getPlayerAccount(client))].skin)
            sendMessageServer(client, 'Você guardou sua roupa!', 'info')
        else
            sendMessageServer(client, 'Voce não possui skin!', 'info')  
        end
    end

end)    

createEvent("onPlayerEnterService", resourceRoot, function (...)
    if not (client or ( source ~= resourceRoot ) ) then
        return false 
    end

    local ARGS = ...

    if not (isPlayerHavePermission(client, ARGS.acl)) then
        sendMessageServer(client, 'Voce não possui permissão!', 'info')
    end

    local typeof = config["ElementsData"][config["Gerenciador"][ARGS.acl]["Type"]]

    if not (getElementData(client, typeof)) then 
        setElementData(client, typeof, true)
        sendMessageServer(client, "Você entrou em serviço!", "success")
    else
        removeElementData   (client, typeof)
        sendMessageServer(client, "Você saiu de serviço!", "success")
    end

end)

function getPlayerVehicle (player)

    if not player or not isElement(player) or getElementType(player) ~= 'player' then
        return false 
    end

    return playerData[getAccountName(getPlayerAccount(player))] and playerData[getAccountName(getPlayerAccount(player))].vehicle or false
end