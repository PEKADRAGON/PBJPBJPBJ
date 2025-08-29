local resource = {}

resource.markers = {
    entrega = {
        index = {},
        element = {},
    },
    destino = { },
}

resource.blips = { }
resource.playerData = { }

resource.sendMessageServer = config.sendMessageServer

for i = 1, #config.locations.iniciar do 
    local v = config.locations.iniciar[i]
    resource.markers.entrega.element[i] = createMarker(v.pos[1], v.pos[2], v.pos[3]- 1, 'cylinder', 2, 139, 100, 255, 50)
    resource.markers.entrega.index[resource.markers.entrega.element[i]] = i
    addEventHandler("onMarkerHit", resource.markers.entrega.element[i], function (player, dimension)
        if (player and isElement(player) and getElementType(player) == "player" and dimension) then 
            local accountName = getAccountName(getPlayerAccount(player))
            local markerIndex = resource.markers.entrega.index[source]
            if (markerIndex) then 
                if not (getPedOccupiedVehicle(player)) then 
                    if (aclGetGroup(config.others.acl)) then 
                        if (isObjectInACLGroup("user."..accountName, aclGetGroup(config.others.acl))) then 
                            triggerClientEvent(player, "Guh > Drawning", resourceRoot, markerIndex)
                        end
                    end
                end
            end
        end 
    end)
end


addEventHandler("onMarkerHit", resourceRoot, function(player, dimension)
    if (player and isElement(player) and getElementType(player) == "player" and dimension) then 
        local data = getElementData(player, "Guh > Service > Drugs") or false;
        if (data) then 
            if (data.destiny == source) then
                if (player and isElement(player) and getElementType(player) == "player" and dimension) then 
                    local vehicle = getPedOccupiedVehicle(player)
                    iprint(vehicle, data.airplane, vehicle == data.airplane)
                    if (vehicle and vehicle == data.airplane) then 
                        local vehicleInGround = isVehicleOnGround (data.airplane)
                        if (vehicleInGround) then 
                            triggerClientEvent(player, 'showInfobox', player, 'info',"Aguarde enquanto descarregamos os pacotes!")
                            --resource.sendMessageServer(player, "Aguarde enquanto descarregamos os pacotes!", "info")
                            setElementFrozen(vehicle, true)
                            toggleAllControls(player, false)
                            setTimer(function()
                                setElementFrozen(vehicle, false)
                                toggleAllControls(player, true)
                                if (resource.playerData[player].markerIndex >= #config.locations.destinos) then 
                                    local money = math.random(config.recompensa.money[1], config.recompensa.money[2])
                                    finishRoutes (player)
                                    exports["guetto_inventory"]:giveItem(player, 100, money)
                                    triggerClientEvent(player, 'showInfobox', player, 'success',"Entregas finalizadas! Valor recebido: R$".. (formatNumber(money, ".")) .."Sujo. ")
                                   -- resource.sendMessageServer(player, "Entregas finalizadas! Valor recebido: R$".. (formatNumber(money, ".")) .." ", "info")
                                    return 
                                end;
                                if (resource.playerData[player].destiny and isElement(resource.playerData[player].destiny)) then 
                                    destroyElement(resource.playerData[player].destiny)
                                    resource.playerData[player].destiny = nil 
                                end
                                resource.playerData[player].markerIndex = resource.playerData[player].markerIndex + 1
                                local position = config.locations.destinos[resource.playerData[player].markerIndex]
                                resource.playerData[player].destiny = createMarker(position[1], position[2], position[3] - 1, "checkpoint", 2.5, 255, 255, 255, 50, player)
                                triggerClientEvent(player,"togglePoint", player, position[1], position[2], position[3])
                                setElementData(player, "Guh > Service > Drugs", resource.playerData[player])
                                triggerClientEvent(player, 'showInfobox', player, 'info',"Marcamos a próxima entrega!")
                                --resource.sendMessageServer(player, "Siga para a próxima entrega!", "info")
                            end, 5000, 1)
                        else
                            triggerClientEvent(player, 'showInfobox', player, 'warning',"Você precisa pousar para entregar a carga!")
                            --resource.sendMessageServer(player, "Pouse a aeronave!", "error")
                        end
                    end
                end
            end
        end
    end
end)    

function formatNumber(number, sep)
	assert(type(tonumber(number))=="number", "Bad argument @'formatNumber' [Expected number at argument 1 got "..type(number).."]")
	assert(not sep or type(sep)=="string", "Bad argument @'formatNumber' [Expected string at argument 2 got "..type(sep).."]")
	local money = number
	for i = 1, tostring(money):len()/3 do
		money = string.gsub(money, "^(-?%d+)(%d%d%d)", "%1"..sep.."%2")
	end
	return money
end

addEvent("Guh > Start > Entrega", true)
addEventHandler("Guh > Start > Entrega", resourceRoot, function (player, type, index)
    if (player and isElement(player) and getElementType(player) == "player") then 
        local data = getElementData(player, "Guh > Service > Drugs") or false;
        if not (data) then 
            resource.playerData[player] = {
                markerIndex = 1,
                airplane = createVehicle(config.others.vehicle, config.locations.iniciar[index].spawn[1], config.locations.iniciar[index].spawn[2], config.locations.iniciar[index].spawn[3]),
                destiny = createMarker(config.locations.destinos[index][1], config.locations.destinos[index][2], config.locations.destinos[index][3] - 1, "checkpoint", 2.5, 255, 255, 255, 50)
            }
            setElementData(resource.playerData[player].airplane, "fuel", 100)
            setElementVisibleTo(resource.playerData[player].destiny, root, false)
            setElementVisibleTo(resource.playerData[player].destiny, player, true)
            triggerClientEvent(player,"togglePoint", player, config.locations.destinos[index][1], config.locations.destinos[index][2], config.locations.destinos[index][3])
            setElementData(player, "Guh > Service > Drugs", resource.playerData[player])
            triggerClientEvent(player, 'showInfobox', player, 'info',"Entregue a carga na localização marcada!")
           -- resource.sendMessageServer(player, "Entregue o bimotor na localização marcada!", "info")
            triggerClientEvent(player, "Guh > Start > Service > Client", resourceRoot)
        else
            triggerClientEvent(player, 'showInfobox', player, 'warning',"Você já esta em uma entrega!")
        end
    end
end)

addEvent("Guh > Alerta", true)
addEventHandler("Guh > Alerta", resourceRoot, function(player)
    if (player and isElement(player) and getElementType(player) == "player") then 
        local x, y, w = getElementPosition(player)
        setPlayerWantedLevel(player, 6)
        notifactionPolices("ALERTA DE SEGURANÇA: Operadores de radar identificaram a presença de uma aeronave desconhecida em nosso espaço aéreo!", {x, y, w})
    end
end)

function notifactionPolices (message, position)
    if (message and position) then 
        for k = 1, #getElementsByType("player") do 
            if (getElementData(getElementsByType("player")[k], config.datas.ptr) == true) then 
                triggerClientEvent(getElementsByType("player")[k], 'showInfobox', getElementsByType("player")[k], 'info', message)
                --resource.sendMessageServer(getElementsByType("player")[k], message, "info")
            end
        end
    end
end

function finishRoutes (player)
    if (player and isElement(player) and getElementType(player) == "player") then 
        local data = getElementData(player, "Guh > Service > Drugs") or false;
        if (data and resource.playerData[player]) then 
            if (data.airplane and isElement(data.airplane)) then 
                destroyElement(data.airplane)
            end
            if (data.destiny and isElement(data.destiny)) then 
                destroyElement(data.destiny)
            end
            removeElementData(player, "Guh > Service > Drugs")
            resource.playerData[player] = nil
            triggerClientEvent(player, "removePoint", player)
        end
    end
end

addEventHandler("onVehicleExit", root, function(player)
    if (source and isElement(source)) then 
        local data = getElementData(player, "Guh > Service > Drugs") or false;
        if (data) then 
            finishRoutes (player)
            triggerClientEvent(player, 'showInfobox', player, 'warning',"Você fracassou na entrega!")
        end
    end
end)

addEventHandler("onPlayerWasted", root, function()
    if (source and isElement(source)) then 
        local data = getElementData(source, "Guh > Service > Drugs") or false;
        if (data) then 
            if (data.airplane and isElement(data.airplane) and source == data.airplane) then 
                finishRoutes (source)
                triggerClientEvent(player, 'showInfobox', player, 'warning',"Você fracassou na entrega!")
               -- resource.sendMessageServer(source, "Você fracassou na entrega!", "info")
            end
        end
    end
end)