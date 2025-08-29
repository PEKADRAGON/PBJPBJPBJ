local resource = {time = {}, bike = {}}

local function onResourceStart ()
    for i, v in ipairs(config.companies) do 
        local markers = createMarker(v[1], v[2], v[3], "cylinder", 1.5, 255, 255, 255, 0)
        setElementData(markers, "markerData", {title = "Alugar bicicleta", desc = "Pegue uma bicicleta da seguradora", icon = "race"})
    end
end

local function onMarkerHit (player, dimension)
    if player and isElement(player) and getElementType(player) == "player" and not isGuestAccount(getPlayerAccount(player)) and not isPedInVehicle(player) and dimension then 
        triggerClientEvent(player, "squady.showBikePanel", resourceRoot)
    end
end

local function onPlayerBuyBike (index)

    if not (client or (source ~= resourceRoot)) then 
        return false 
    end;

    if not config.bikes[index] then 
        return false 
    end;

    if resource.bike[client] and isElement(resource.bike[client]) then 
        destroyElement(resource.bike[client])
        resource.bike[client] = nil 
    end;

    if tonumber(config.bikes[index].price) <= 0 then 
        return false 
    end;

    if getPlayerMoney(client) <= config.bikes[index].price then 
        return  sendMessage("server", client, "Saldo insuficiente.", "error")
    end;

    local pos = {getElementPosition(client)}

    takePlayerMoney(client, config.bikes[index].price)
    resource.bike[client] = createVehicle(config.bikes[index].model, pos[1], pos[2], pos[3] + 1)

    warpPedIntoVehicle(client, resource.bike[client])
    triggerClientEvent(client, "squady.hideBikePanel", resourceRoot)

    resource.time[client] = setTimer(function()
        if resource.bike[client] and isElement(resource.bike[client]) then
            destroyElement(resource.bike[client])
            resource.bike[client] = nil
            sendMessage("server", client, "O tempo de aluguel da bicicleta acabou.", "info")
        end
    end, config.others.expire_time * 60000, 1)
    
    sendMessage("server", client, "Você alugou a bicicleta com sucesso!", "info")
end

local function onPlayerQuit ()
    if resource.bike[source] and isElement(resource.bike[source]) then
        destroyElement(resource.bike[source])
    end
end

local function onPlayerWasted ()
    if resource.bike[source] and isElement(resource.bike[source]) then
        destroyElement(resource.bike[source])
    end
end

registerEvent("squady.onPlayerBuyBike", resourceRoot, onPlayerBuyBike)

addEventHandler("onResourceStart", resourceRoot, onResourceStart)
addEventHandler("onMarkerHit", resourceRoot, onMarkerHit)
addEventHandler("onPlayerQuit", root, onPlayerQuit)
addEventHandler("onPlayerWasted", root, onPlayerWasted)