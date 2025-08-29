local motosIDS = {
    
    [468] = true;
    [462] = true;
    [586] = true;
    [522] = true;
    [461] = true;

}

function sendMessageServer ( player, msg, type )
	return exports['guetto_notify']:showInfobox(player, type, msg)
end

class 's_route' {
    constructor = function(self)
        self.marker = createMarker(2105.099, -1806.484, 13.555-0.9, "cylinder", 2.5, 32, 103, 246, 0)
        self.markerVehicle = createMarker(2095.723, -1817.092, 13.383-0.9, "cylinder", 2.5, 32, 103, 246, 0)
        --self.marker = cmarker:createCustomMarkerServer(2094.238, -1771.533, 13.552, 2.5, 32, 103, 246, 255, "ifood") 
       -- self.markerVehicle = cmarker:createCustomMarkerServer(2101.865, -1773.832, 13.393, 5.0, 32, 103, 246, 255, "ifood")
        setElementData( self.marker, 'markerData', {title = 'Rotas', desc = 'Inicie suas entregas', icon = 'pizza'})
        setElementData( self.markerVehicle, 'markerData', {title = 'Rotas', desc = 'Estacione seu veículo aqui', icon = 'checkpoint'})
       --createCustomMarker(config.startService.marker)
        self.service = {}
        self.motosInMarker = { }
    end,

    start = function(self, player)
        if (not getElementData(player, 'player > emp')) then
            if (self.motosInMarker[player]) then 
                if (isElementWithinMarker(self.motosInMarker[player], self.markerVehicle)) then 
                    if (getElementData(self.motosInMarker[player], "Owner") == getAccountName(getPlayerAccount(player))) then 
                        setElementData(player, 'player > emp', 'motoboy')
                    
                        self.service[player] = {
                            actuallyRoute = math.random(#config.peds);
                            marker = createMarker(0, 0, 0, 'cylinder', 1, 0, 0, 0, 0)
                        }
  
                       -- local position = config.peds[ self.service[player].actuallyRoute][1][math.random(#config.peds[ self.service[player].actuallyRoute][1])], config.peds[ self.service[player].actuallyRoute][2], config.peds[ self.service[player].actuallyRoute][3]

                        attachElements(self.service[player].marker, self.motosInMarker[player], 0, -1.5, -0.2)
                        triggerClientEvent(player, 'receptTrigger_ped_c', player, 'new', self.service[player].actuallyRoute)
                        triggerClientEvent(player, 'togglePoint', player, config.peds[ self.service[player].actuallyRoute][2].x, config.peds[ self.service[player].actuallyRoute][2].y, config.peds[ self.service[player].actuallyRoute][2].z)
                       -- s_route.service[source].object1 = createObject(2036, 0, 0, 0)
                        exports['bone_attach']:attachElementToBone(s_route.service[source].object1, source, 3, 0, -0.14, 0.22, -1, 0, 0)
            
                        sendMessageServer(source, 'Você iniciou seu emprego de Motoboy, pegue sua moto e siga o destino.','success')
                    else
                        sendMessageServer(source, 'Essa moto não é sua!.','error')
                    end
                else
                    sendMessageServer(source, 'Sua moto não está em cima do marker!.','error')
                end
            else
                sendMessageServer(source, 'Você não possui uma moto!','error')
            end
        else
            sendMessageServer(source, 'Você já está trabalhando.','error')
        end
    end
}

s_route = new 's_route'()

addCustomEventHandler('receptTrigger_route_s', function(...)
    local type, quanty = ...
    
    if (type == 'start') then
        s_route:start(source)
    elseif (type == 'stop') then
        if (s_route.service[source]) then
            if (s_route.service[source].vehicleTimer) then
                killTimer(s_route.service[source].vehicleTimer)
            end
            
            if (isElement(s_route.service[source].object)) then
                destroyElement(s_route.service[source].object)
            end

            if isElement (s_route.service[source].object1) then 
                destroyElement(s_route.service[source].object1)   
            end


            if (s_route.service[source].marker and isElement(s_route.service[source].marker)) then 
                destroyElement(s_route.service[source].marker)
            end

            triggerClientEvent(source, 'receptTrigger_cardMachine_c', source, 'delete')
            triggerClientEvent(source, 'receptTrigger_ped_c', source, 'delete')
        end

        setElementData(source, 'player > emp', nil)

        sendMessageServer(source, 'Seu serviço foi cancelado com successo.','error')
      
    elseif (type == 'regenerate') then
        local count = 0

        local function generateOtherRoute(actual)
            if (actual) then
                local index = math.random(math.random(#config.peds))

                if (index ~= actual) then
                    return index
                else
                    if (count <= 10) then
                        count = count + 1

                        return generateOtherRoute(actual)
                    else
                        return actual
                    end
                end
            end
        end
        
        destroyElement(s_route.service[source].object)
        s_route.service[source].object = nil

        local xp = (getElementData(source, "XP") or 0)
        local randomXP = math.random(500, 1000);

        giveMoneyForPlayer(source, quanty)
        setElementData(client, "XP", xp + randomXP)

        s_route.service[source].actuallyRoute = generateOtherRoute(s_route.service[source].actuallyRoute)

        --local x, y, z = config.peds[s_route.service[source].actuallyRoute][1][math.random(#config.peds[s_route.service[source].actuallyRoute][1])], config.peds[s_route.service[source].actuallyRoute][2], config.peds[s_route.service[source].actuallyRoute][3]

        triggerClientEvent(source, "togglePoint", source, config.peds[s_route.service[source].actuallyRoute][2].x, config.peds[s_route.service[source].actuallyRoute][2].y, config.peds[s_route.service[source].actuallyRoute][2].z)
        --iprint(s_route.service[source].actuallyRoute)


        triggerClientEvent(source, 'receptTrigger_ped_c', source, 'new', s_route.service[source].actuallyRoute)
    elseif (type == 'getBag') then
        s_route.service[source].object = true
        
        setPedAnimation(source, 'CARRY', 'liftup', 1, false)
        setTimer(function(source)

        
            s_route.service[source].object = createObject(1582, 0, 0, 0)
            setObjectScale(s_route.service[source].object, 0.65)

            exports['bone_attach']:attachElementToBone(s_route.service[source].object, source, 11, -0.18, 0.13, 0.1, 90, 0, 8)

            setPedAnimation(source, 'GANGS', 'DEALER_idle', -1)
            setTimer(function(source)
                setPedAnimation(source)
                sendMessageServer(source, 'Entregue o pedido para o cliente.', 'success')
            end, 100, 1, source)
        end, 1100, 1, source)
    elseif (type == 'cameraInPed') then
        if (s_route.service[source].object) then
            triggerClientEvent(source, 'receptTrigger_cardMachine_c', source, 'new')

            triggerClientEvent(source, 'receptTrigger_ped_c', source, 'cameraInPed')
            triggerClientEvent(source, 'receptTrigger_ped_c', source, 'animation', 'MISC', 'Idle_Chat_02', -1)
        else
            sendMessageServer(source, 'Pegue a bolsa dos pedidos na bolsa da moto.', 'error')
           --- addNotification(source, 'erro', 'Pegue a bolsa dos pedidos na bolsa da moto.')
        end
    end
end)

addEventHandler('onPlayerMarkerHit', root, function(marker, dim)
    if (dim) then
        if (marker == s_route.marker) then
            triggerClientEvent(source, 'receptTrigger_route_c', source, 'new', getElementData(source, 'player > emp'))
        elseif (marker == s_route.markerVehicle) then 
            if (source and isElement(source) and getElementType(source) == "player" and getPedOccupiedVehicle(source)) then 
                if not (s_route.motosInMarker[source]) then 
                    local model = getElementModel(getPedOccupiedVehicle(source))
                    if (motosIDS[model] == true) then
                        s_route.motosInMarker[source] = getPedOccupiedVehicle(source)
                        sendMessageServer(source, 'Você colocou sua moto em cima do marker!', 'success')
                    else
                        sendMessageServer(source, 'Você não pode trabalhar com esse veiculo!', 'error')
                    end
                else
                    sendMessageServer(source, 'Você já possui uma moto em cima do marker!', 'error')
                end
            end
        elseif (s_route.service[source] and marker == s_route.service[source].marker) then
            if (not s_route.service[source].object) then
                triggerClientEvent(source, 'receptTrigger_ped_c', source, 'checkDistance')
            end
        end
    end
end)

addEventHandler("onPlayerMarkerLeave", root, function (marker, dim)
    if (dim) then 
        if (marker == s_route.markerVehicle) then 
            if (source and isElement(source) and getElementType(source) == "player" and getPedOccupiedVehicle(source) and getPedOccupiedVehicle(source) == s_route.motosInMarker[source]) then 
                if (s_route.motosInMarker[source]) then 
                    s_route.motosInMarker[source] = nil
                end
            end
        end
    end
end)

--[[
    addEventHandler('onVehicleEnter', root, function(player, seat)
    if (seat == 0) then
        if (s_route.service[player] and s_route.motosInMarker[source] == source) then
            if (s_route.service[player].vehicleTimer) then
                killTimer(s_route.service[player].vehicleTimer)
                s_route.service[player].vehicleTimer = nil
            end
        end
    end
end)

addEventHandler('onVehicleStartEnter', root, function(player, seat)
    if (seat == 0) then
        if (getElementModel(source) == config.startService.vehicle.model) then
            if (not s_route.service[player] or s_route.service[player].vehicle ~= source) then
                sendMessageServer(source, 'Está moto de entrega não é sua.', 'error')
 --               addNotification(player, 'erro', 'Está moto de entrega não é sua.')

                cancelEvent()
            end
        end
    end
end)
]]

addEventHandler('onVehicleStartExit', root, function(player, seat)
    if (seat == 0) then
        if (s_route.service[player] and s_route.service[player].vehicle == source) then
            sendMessageServer(source, 'Você tem 5 minutos para retornar a moto.', 'info')
            
           --addNotification(player, 'info', 'Você tem 5 minutos para retornar a moto.')

            s_route.service[player].vehicleTimer = setTimer(function(player)
                if (isElement(s_route.service[player].object)) then
                    destroyElement(s_route.service[player].object)
                end
                destroyElement(s_route.service[player].marker)
                destroyElement(s_route.service[player].vehicle)

                triggerClientEvent(player, 'receptTrigger_cardMachine_c', player, 'delete')
                triggerClientEvent(player, 'receptTrigger_ped_c', player, 'delete')    

                setElementData(player, 'player > emp', nil)
                
                sendMessageServer(source, 'Seu serviço foi cancelado por abandonar a moto.', 'info')
               -- addNotification(player, 'info', 'Seu serviço foi cancelado por abandonar a moto.')
            end, 1000 * 60 * 5, 1, player)
        end
    end
end)

addEventHandler('onPlayerQuit', root, function()
    if (s_route.service[source]) then
        if (s_route.service[source].vehicleTimer) then
            killTimer(s_route.service[source].vehicleTimer)
        end

        if (isElement(s_route.service[source].object)) then
            destroyElement(s_route.service[source].object)
        end
        destroyElement(s_route.service[source].marker)
        destroyElement(s_route.service[source].vehicle)

        setElementData(source, 'player > emp', nil)
    end
end)