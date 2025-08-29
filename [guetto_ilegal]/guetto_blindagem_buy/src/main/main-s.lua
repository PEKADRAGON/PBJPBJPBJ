for i, v in ipairs(config["Posicoes"]) do 
    local marker = createMarker(v[1], v[2], v[3] - 1, 'cylinder', 2, 139, 100, 255, 50)
    addEventHandler("onMarkerHit", marker, function(player, dimension)
        if (player and isElement(player) and getElementType(player) == "player" and dimension) then 
            if getPedOccupiedVehicle(player) then 
                if isPlayerHavePermission(player, v[4]) then 
                    triggerClientEvent(player, 'guetto_blindagem:open', resourceRoot, getElementModel(getPedOccupiedVehicle(player)))
                else
                    sendMessageServer(player, "Você não possui permissão!", "error")
                end
            else
                sendMessageServer(player, "Você não está em um veículo!", "error")
            end
        end
    end)
end

createEvent("guetto_blindagem:buy", resourceRoot, function ()
    if not (source or ( source ~= resourceRoot ) ) then
        return false
    end
    if getPedOccupiedVehicle(client) then 
        local price = config["Modelos"][getPedOccupiedVehicle(client)] or config["Modelos"]["Default"]
        if (getPlayerMoney(client) < price) then 
            return sendMessageServer(client, "Dinheiro insuficiente!", "error")
        end
        takePlayerMoney(client, price)
        setElementData(getPedOccupiedVehicle(client), "VehBlindagem", config["Blindagem"])
        sendMessageServer(client, "Você blindou o veículo com sucesso!", "success")
    else
        sendMessageServer(client, "Você não está em um veículo!", "error")
    end

end)