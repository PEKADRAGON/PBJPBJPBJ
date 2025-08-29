local server = {marker_dismantle = {}, marker_part = {}, cooldown_dismantle = {}, vehicle_dismantle = {}, disassembled_parts = {}, dismantled_vehicle = {}}

setTimer(function()
    for i, v in ipairs(config["dismantles"]) do 
        server["marker_dismantle"][i] = createMarker(v["pos"][1], v["pos"][2], v["pos"][3], "cylinder", 2.7, 255, 255, 255, 0)
        setElementData(server["marker_dismantle"][i], "markerData", {tittle = "Desmanche", desc = "", icon = "mechanic"})
        triggerClientEvent("squady.insertDismantle", getRootElement(), server["marker_dismantle"][i])
    end
end, 1000, 1)

addEventHandler("onPlayerLogin", getRootElement(), function()
    for i, v in ipairs(server["marker_dismantle"]) do 
        triggerClientEvent(source, "squady.insertDismantle", source, v)

        if server["cooldown_dismantle"][v] and isTimer(server["cooldown_dismantle"][v]) then 
            triggerClientEvent(source, "squady.insertCooldown", source, v, getTimerDetails(server["cooldown_dismantle"][v]))
        end
    end

    for i, v in pairs(server["vehicle_dismantle"]) do 
        if i and isElement(i) then 
            triggerClientEvent(source, "squady.insertVehicleDismantle", source, i)

            if server["disassembled_parts"][i] then 
                for index, content in ipairs(server["disassembled_parts"][i]) do 
                    triggerClientEvent(source, "squady.insertVehicleDismantleParts", source, i, index)
                end
            end
        else
            server["vehicle_dismantle"][i] = nil
        end
    end
end)

function setElementCooldown(marker)
    server["cooldown_dismantle"][marker] = setTimer(function()
        if marker and isElement(marker) then 
            triggerClientEvent(root, "squady.removeCooldown", getRootElement(), marker)
        end
    end, config["settings"]["cooldownNextDismantling"] * 60000, 1, marker)
    triggerClientEvent("squady.insertCooldown", getRootElement(), marker, config["settings"]["cooldownNextDismantling"] * 60000)
end

addEventHandler("onMarkerHit", getRootElement(), function(player, dimension)
    for i, v in ipairs(server["marker_dismantle"]) do 
        if v == source then 
            if player and isElement(player) and getElementType(player) == "player" and not isGuestAccount(getPlayerAccount(player)) and isPedInVehicle(player) and dimension and not server["cooldown_dismantle"][v] or not isTimer(server["cooldown_dismantle"][v]) then 
                for i, v in ipairs(config["dismantles"]) do 
                    if aclGetGroup(v["acl"]) and player and isElement(player) and getElementType(player) == "player" and isObjectInACLGroup("user."..getAccountName(getPlayerAccount(player)), aclGetGroup(v["acl"])) then 
                        local vehicle = getPedOccupiedVehicle(player)

                        if vehicle and isElement(vehicle) and getVehicleType(vehicle) == "Automobile" then
                            local vehicleDealership = (getElementData(vehicle, 'Guh.VehicleID') or false)
                  
                            if not vehicleDealership then 
                                sendMessage('server', player, 'Esse veículo não pode ser desmanchando.', 'error')
                                return
                            end
                            
                            local price = exports["guetto_dealership"]:getVehicleConfigFromModel(getElementModel(vehicle)) 

                            if price then 

                                local value = price['money'] and price['money'] or price['coins'] and price['coins'] * 10000  
                                local default_value = math.floor(value * config["settings"]["percentages"]["percentageDismantle"] )
                                local value = math.floor(value - default_value)
    
    
                                if getElementData(vehicle, 'Owner') == getAccountName(getPlayerAccount(player)) then 
                                    return sendMessage('server', player, 'Você é o dono desse veículo e não pode desmancha-lo.', 'error')
                                end;
    
                                local pos = {getElementPosition(vehicle)}
                                triggerClientEvent(root, 'squady.moveUpVehicle', resourceRoot, vehicle, pos[3])
                           
                                for i, v in pairs(getVehicleOccupants(vehicle)) do 
                                    fadeCamera(v, false, 1.0, 0, 0, 0)
                                    setTimer(function()
                                        fadeCamera(player, true, 1.0)
                                        removePedFromVehicle(v)
                                        setElementPosition(v, pos[1]+1.8, pos[2]+0.5, pos[3]+0.5)
                                    end, 500, 1)
                                end
                                
                                if (getElementData(vehicle, 'Owner')) then
                                    exports['guetto_dealership']:setVehicleState(vehicle, 'apreendido')
                                   setElementData(vehicle, "vehicle.desmanche", true)
                                end
    
                                setElementCooldown(source)
    
                                server["vehicle_dismantle"][vehicle] = true
                                triggerClientEvent("squady.insertVehicleDismantle", root, vehicle)
                                setElementFrozen(vehicle, true)
                                setElementRotation(vehicle, v["rot"][1], v["rot"][2], v["rot"][3])
                                triggerClientEvent(player, "squady.startDismantle", player, vehicle)
    
                                local price = exports["guetto_dealership"]:getVehicleConfigFromModel(getElementModel(vehicle)) 

                                exports["guetto_util"]:messageDiscord("O jogador "..getPlayerName(player).." desmanchou o veículo "..price["name"].."", "https://media.guilded.gg/webhooks/ebca7600-5e57-4c12-9606-d0cc1ad3ee7b/H8cgVlrLCUkUOe0q86qaISEyMOck0kCooK0miy48QaIiWqgwiuG2GaeY0gCqeEgy8KEaKCWuA4squYe4UY28I2")
                            end

                        elseif vehicle and isElement(vehicle) and getVehicleType(vehicle) == "Bike" and getVehicleOccupant(vehicle) and getVehicleOccupant(vehicle) == player and not server["dismantled_vehicle"][vehicle] then 
                            local price = exports["guetto_dealership"]:getVehicleConfigFromModel(getElementModel(vehicle))
                            
                            if (price) then 
                                local value = price['money'] and price['money'] or price['coins'] and price['coins'] * 10000  
                                local default_value = math.floor(value * config["settings"]["percentages"]["percentageMotorcycle"] )
                                local value = math.floor(value - default_value)
                                local vehicleDealership = (getElementData(vehicle, 'Guh.VehicleID') or false)

                                if not vehicleDealership then 
                                    sendMessage('server', player, 'Esse veículo não pode ser desmanchando.', 'error')
                                    return
                                end
                                
                                if getElementData(vehicle, 'Owner') == getAccountName(getPlayerAccount(player)) then 
                                    return sendMessage('server', player, 'Você é o dono desse veículo e não pode desmancha-lo.', 'error')
                                end
    
                                server["dismantled_vehicle"][vehicle] = true
                                exports["guetto_inventory"]:giveItem(player, 100, value)
    
                                if (getElementData(vehicle, 'Owner')) then 
                                    exports['guetto_dealership']:setVehicleState(vehicle, 'apreendido')
                                    setElementData(vehicle, "vehicle.desmanche", true)
                                end
    
                                setElementCooldown(source)
    
                                sendMessage("server", player, "Você desmanchou esse veículo e recebeu R$"..value.." de dinheiro sujo.", "success")
                                exports["guetto_util"]:messageDiscord("O jogador "..getPlayerName(player).." desmanchou o veículo "..price["name"].." e recebeu R$"..value.." de dinheiro sujo.", "https://media.guilded.gg/webhooks/ebca7600-5e57-4c12-9606-d0cc1ad3ee7b/H8cgVlrLCUkUOe0q86qaISEyMOck0kCooK0miy48QaIiWqgwiuG2GaeY0gCqeEgy8KEaKCWuA4squYe4UY28I2")
    
                                setTimer(function()
                                    if vehicle and isElement(vehicle) then 
                                        server["dismantled_vehicle"][vehicle] = nil 
                                        destroyElement(vehicle)
                                        setElementData(player, 'Desmanchando', false)
                                    end
                                end, 1000, 1, vehicle)
                            end
    
                            setElementData(player, 'Desmanchando', true)
                            break
                        end
                    elseif i == #config["dismantles"] then 
                        sendMessage("server", player, "Você não tem permissão para desmanchar veículos aqui.", "error")
                    end
                end
            end
            break
        end
    end
end)

addEvent("squady.dismantlePartVehicle", true)
addEventHandler("squady.dismantlePartVehicle", getRootElement(), function(vehicle, type, namePart, namePartConfig)

    if not client then 
        return
    end

    setPedAnimation(client, "BOMBER", "BOM_Plant_Loop", config["settings"]["timeDismantlePart"], true, false, false)
    toggleAllControls(client, false)

    setTimer(function(player, vehicle, type)
        triggerClientEvent(player, "squady.getAllComponentsVehicleAndGiveMoney", player, player, vehicle, namePartConfig)
        setPedAnimation(player, "BOMBER","BOM_Plant_Loop", 0, false, false, false, false, 0)
        toggleAllControls(player, true)

        if tonumber(type) then 
            setVehicleDoorState(vehicle, type, 4)
        else
            setVehicleWheelStates(vehicle, type[1], type[2], type[3], type[4])
        end
    
        if not server["disassembled_parts"][vehicle] then
            server["disassembled_parts"][vehicle] = {}
        end
        
        server["disassembled_parts"][vehicle][namePart] = true
        triggerClientEvent(root, "squady.removePartFromVehicle", root, vehicle, namePart)
        triggerClientEvent(player, 'squady.getAllComponents', root, vehicle)
    end, config["settings"]["timeDismantlePart"] * 1000, 1, client, vehicle, type, source)
end)

addEvent("squady.finishDismantle", true)
addEventHandler("squady.finishDismantle", resourceRoot, function(vehicle)
    if not client then
        return
    end

    if server["marker_part"][vehicle] and isElement(server["marker_part"][vehicle]) then 
        destroyElement(server["marker_part"][vehicle]) 
    end

    setTimer(function(vehicle, player)
        if vehicle and isElement(vehicle) then 
            local price = exports["guetto_dealership"]:getVehicleConfigFromModel(getElementModel(vehicle))
                            
            local target_value = price['money'] and price['money'] or price['coins'] and price['coins'] * 10000  
            local default_value = math.floor(target_value * config["settings"]["percentages"]["percentageDismantle"] )
            local value = math.floor(target_value - default_value)

            server["vehicle_dismantle"][vehicle] = nil

            setElementData(player, 'Desmanchando', false)

            if (getElementData(vehicle, 'Owner') and isElement(getElementData(vehicle, 'Owner'))) then 
                --exports["guetto_dealership"]:setVehicleState(getElementData(vehicle, 'Owner'), getElementModel(vehicle), 'apreendido')
            end

            server["disassembled_parts"][vehicle] = nil

            exports["guetto_inventory"]:giveItem(player, 100, value)
            sendMessage("server", player, "Você desmanchou o veículo e ganhou R$"..(value).." de dinheiro sujo!", "success")
            destroyElement(vehicle)
        end
    end, 1000, 1, vehicle, client)
end)

addEvent("squady.giveMoneyFromPart", true)
addEventHandler("squady.giveMoneyFromPart", getRootElement(), function(vehicle, qntd, namePart)
    if not client then 
        return
    end

    if vehicle and isElement(vehicle) then 
        if aclGetGroup('Facção') and isObjectInACLGroup("user."..getAccountName(getPlayerAccount(client)), aclGetGroup('Facção')) then
            local price = exports["guetto_dealership"]:getVehicleConfigFromModel(getElementModel(vehicle))
            if price then
                local target_value = price['money'] and price['money'] or price['coins'] and price['coins'] * 10000  
                local value = math.floor(target_value/100*config["settings"]["percentages"]["percentageDismantle"])
                local valuePart = tonumber(math.floor(value/qntd))
                --exports["guetto_inventory"]:giveItem(client, 26, valuePart)
                sendMessage("server", client, "Você removeu a peça do veículo", "success")
            end
        end
    end
end)

addEventHandler("onPlayerQuit", root, function()
    local player = source 

    if getElementData(player, "desmanchando") then 
        if vehicle and isElement(vehicle) then 
            server["vehicle_dismantle"][vehicle] = nil
            if (getElementData(vehicle, 'Owner') and isElement(getElementData(vehicle, 'Owner'))) then 
                exports["guetto_dealership"]:setVehicleState(getElementData(vehicle, 'Owner'), getElementModel(vehicle), 'apreendido')
            end
            destroyElement(vehicle)
        end
    end
end)