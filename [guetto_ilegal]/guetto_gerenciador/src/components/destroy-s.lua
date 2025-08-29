createEvent("onPlayerDestroyVehicle", resourceRoot, function (acl)
    if not (client or ( source ~= resourceRoot ) ) then
        return false 
    end
    
    if not (isPlayerHavePermission(client, acl)) then
        return sendMessageServer(client, 'Voce não possui permissão!', 'info')
    end

    local vehicle = getPlayerVehicle(client)
   
    if not (vehicle) then 
        return sendMessageServer(client, "Você não possui nenhum veículo fora da garagem!", "info")
    end

    if vehicle and isElement(vehicle) and getElementType(vehicle) == 'vehicle' then 
        local x, y, z = getElementPosition(client);
        local x2, y2, z2 = getElementPosition (vehicle);

        if (getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) <= 50) then 
            local i = getVehicleByModel (acl, getElementModel(vehicle))

            if i and type(i) == 'number' then 
                destroyElement(vehicle)
                config["Gerenciador"][acl]["Veiculos"][i]["space"] = config["Gerenciador"][acl]["Veiculos"][i]["space"] + 1
                sendMessageServer(client, "Você guardou o veículo com sucesso!", "success")
            end
        else
            sendMessageServer(client, "Você está muito longe do veículo!", "error")
        end
    end


end)