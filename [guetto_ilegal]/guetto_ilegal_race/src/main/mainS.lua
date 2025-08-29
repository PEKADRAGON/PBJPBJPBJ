local marker_cache = {}
local player_vehicle = {}
local timer_data = {}
local blip = {}

addEventHandler('onResourceStart', resourceRoot, function ( )
    for i, v in ipairs ( config["Locations"] ) do 
        local marker = createMarker(v[1], v[2], v[3], v[4], v[5], v[6], v[7], v[8], v[9])
        createBlipAttachedTo(marker, 53)
        marker_cache[marker] = i
    end
end)

addEventHandler('onMarkerHit', resourceRoot, function ( player, dimension )
    if (player and isElement(player) and getElementType(player) == "player" and dimension) then 
        local vehicle = getPedOccupiedVehicle(player)
    
        if not (marker_cache[source]) then 
            return false 
        end
        
        if not (vehicle) then 
            return config.sendMessageServer(player, "Entre em um veículo para participar da corrida!", "error")
        end

        if (config["BlackList"][getElementModel(vehicle)]) then 
            return config.sendMessageServer(player, "Modelo do veículo bloqueado!", "error")
        end

        if (getElementData(player, "player.race")) then 
            return config.sendMessageServer(player, "Você já está participando de uma corrida!", "error")
        end

        triggerClientEvent(player, "ToggleInterface", resourceRoot, true, marker_cache[source])
    end
end)

addEventHandler("onMarkerLeave", resourceRoot, function(player, dimension)
    if (player and isElement(player) and getElementType(player) == "player" and dimension) then 
        if not (marker_cache[source]) then 
            return false 
        end
        if not (getElementData(player, "player.race")) then 
            triggerClientEvent(player, "ToggleInterface", resourceRoot, false)
        end
    end
end)

function sendMessagePolice (player)
    for i, v in ipairs(getElementsByType("player")) do 
        if (getElementData(v, "service.police")) then 
            outputChatBox("#ff0000[Denuncia] #FFFFFFCorrida ilegal em andamento! Verifique a marcação no seu mapa", v, 255, 255, 255, true)
            setElementVisibleTo(blip[player], v, true)
        end
    end
end

local vehicle_owner = {}

addEvent("onPlayerGetItens", true)
addEventHandler("onPlayerGetItens", resourceRoot, 
    function ( )
        if not (client or (source ~= resourceRoot)) then 
            return false 
        end
        local amount = exports["guetto_inventory"]:getItem(client, config["Others"]["item"])
        
        if amount <= 0 then 
            return config.sendMessageServer(client, "Você não possui um ticket de corrida. Visite o mercado negro para adquirir um!", "info")
        end
        
        player_vehicle[client] = getPedOccupiedVehicle(client)
        vehicle_owner[player_vehicle[client]] = client;
        blip[client] = createBlipAttachedTo(player_vehicle[client], 41)

        setElementVisibleTo(blip[client], root, false)

        triggerClientEvent(client, "onPlayerStartRace", resourceRoot)
        setElementData(client, "player.race", true)
        
        sendMessagePolice(client)
    
        exports["guetto_inventory"]:takeItem(client, config["Others"]["item"], 1)
    end
)

addEvent("onVehicleExplosion", true)
addEventHandler("onVehicleExplosion", resourceRoot, 
    function ( )

        if not (client or (source ~= resourceRoot)) then 
            return false 
        end

        local x, y, z = getElementPosition(client)

        if blip[client] then 
            destroyElement(blip[client])
            blip[client] = nil 
        end

        createExplosion(x, y, z, 4, client)
        removeElementData(client, "player.race")
        config.sendMessageServer(client, "Você não concluiu a corrida no tempo e a bomba explodiu!", "error")
    end
)

addEvent("onPlayerFinishRace", true)
addEventHandler("onPlayerFinishRace", resourceRoot, 
    function (index)
        
        if not (client or (source ~= resourceRoot)) then 
            return false 
        end

        local random = math.random(#config["Locations"][index]["reward"])
        local money = config["Locations"][index]["reward"][random]

        exports["guetto_inventory"]:giveItem(client, config["Others"]["dinheiroSujo"], money)

        if blip[client] then 
            destroyElement(blip[client])
            blip[client] = nil 
        end

        triggerClientEvent(client, "onClientFinish", resourceRoot, money)

        config.sendMessageServer(client, "Você concluiu a corrida e recebeu R$"..formatNumber(money).." de dinheiro sujo!", "info")
        removeElementData(client, "player.race")
    end
)

addEventHandler("onPlayerWasted", root, function ( )
    if not (getElementData(source, "player.race")) then 
        return false 
    end

    if blip[source] then 
        destroyElement(blip[source])
        blip[source] = nil 
    end

    triggerClientEvent(source, "ToggleInterface", resourceRoot, false)
    removeElementData(source, "player.race")
    config.sendMessageServer(source, "Você morreu e a corrida foi finalizada!", "info")
end)

addEventHandler("onVehicleExit", root, function(player)
    if ((getElementData(player, "player.race"))) then 
        if (source == player_vehicle[player]) then 
            local x, y, z = getElementPosition(source)
            if blip[player] then 
                destroyElement(blip[player])
                blip[player] = nil 
            end
            timer_data[player] = setTimer(function(player)
                createExplosion(x, y, z, 4, player)
                removeElementData(player, "player.race")
            end, 5000, 1, player)
            config.sendMessageServer(player, "Você saiu do veículo e a bomba será detonada em 5 segundos!", "error")
            triggerClientEvent(player, "ToggleInterface", resourceRoot, false)
        end
    end
end)

addEventHandler("onResourceStart", resourceRoot, function ( )
    for _, player in ipairs (getElementsByType('player')) do 
        if ((getElementData(player, "player.race"))) then 
            removeElementData(player, "player.race")
        end
    end
end)

addEventHandler('onElementDestroy', root, function ( )
    if source and isElement(source) and getElementType(source) == 'vehicle' then 
        if vehicle_owner[source] then 
            if source == player_vehicle[vehicle_owner[source]] then 
                if blip[vehicle_owner[source]] then 
                    destroyElement(blip[vehicle_owner[source]])
                    blip[vehicle_owner[source]] = nil 
                end
                removeElementData(vehicle_owner[source], "player.race")
                config.sendMessageServer(vehicle_owner[source], "Seu veículo foi destruido e sua corrida foi cancelada!", "error")
                triggerClientEvent(vehicle_owner[source], "ToggleInterface", resourceRoot, false)
                player_vehicle[vehicle_owner[source]] = nil ;
                vehicle_owner[source] = nil
            end
        end
    end
end)