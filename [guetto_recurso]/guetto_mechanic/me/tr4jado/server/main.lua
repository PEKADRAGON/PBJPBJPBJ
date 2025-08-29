core = {
    start = function()
        repair.events.start()
        call.events.start()
        point.events.start()
    end
}

repair = {
    objects = {},

    events = {
        start = function()
            addEventHandler('onPlayerVehicleEnter', root, repair.events.vehicle.enter)
            addEventHandler('onPlayerVehicleExit', root, repair.events.vehicle.exit)

            registerEvent('repair:action', resourceRoot, repair.custom.action)

            addCommandHandler('soltarmaleta', repair.commands.soltarmaleta)
        end,

        quit = function()
            if isElement(repair.objects[source]) then
                repair.objects[source]:destroy()
            end
        end,

        vehicle = {
            enter = function()
                if isElement(repair.objects[source]) then
                    repair.objects[source]:destroy()
                end
            end,

            exit = function(vehicle)
                if not source:getData('service.mechanic') then
                    return
                end

                if vehicle.model ~= 525 then
                    return
                end

                if isElement(repair.objects[source]) then
                    repair.objects[source]:destroy()
                end

                repair.objects[source] = createObject(1210, 0, 0, 0)
                exports['bone_attach']:attachElementToBone(repair.objects[source], source, 11, 0, 0, 0, 0, -80, 0)
            end
        }
    },

    commands = {
        soltarmaleta = function(player)
            if not isElement(repair.objects[player]) then
                return notify.server(player, 'Você não está com a maleta.', 'error')
            end

            repair.objects[player]:destroy()
            repair.objects[player] = nil
        end
    },

    custom = {
        action = function(vehicle, data)
            data = decode(data)

            if not data then
                return
            end

            if not isElement(vehicle) or vehicle.type ~= 'vehicle' then
                return
            end

            if not isElement(repair.objects[client]) then
                return notify.server(client, 'Você não está com a maleta.', 'error')
            end

            client:setAnimation('BOMBER', 'BOM_Plant', -1, false, false, false, false)

            Timer(function(mechanic)
                if isElement(sourceTimer) then
                    sourceTimer:destroy()
                end

                if not isElement(mechanic) then
                    return
                end

                mechanic:setAnimation(false)

                if not isElement(vehicle) then
                    return
                end

                if data.type == 'engine' then
                    vehicle.health = 1000
                elseif data.type == 'panel' then
                    vehicle:setPanelState(data.id, 0)
                elseif data.type == 'light' then
                    vehicle:setLightState(data.id, 0)
                elseif data.type == 'door' then
                    vehicle:setDoorState(data.id, 0)
                elseif data.type == 'tire' then
                    local tires = {vehicle:getWheelStates()}
                    tires[data.id] = 0

                    vehicle:setWheelStates(unpack(tires))
                end

                if data.name then 
                    local xp = (getElementData(mechanic, 'XP') or 0)
                    setElementData(mechanic, 'XP', xp + 800)

                    notify.server(mechanic, 'Você consertou ' .. data.name .. ' e recebeu 800 de xp.', 'success')
                else
                    local xp = (getElementData(mechanic, 'XP') or 0)
                    setElementData(mechanic, 'XP', xp + 800)
                    notify.server(mechanic, 'Você consertou o veículo e recebeu 800 de XP.', 'success')
                end
                triggerClientEvent(mechanic, 'repair:update', resourceRoot, vehicle)
            end, 2000, 1, client)
        end
    }
}

call = {
    players = {},

    events = {
        start = function()
            registerEvent('mechanic:call', root, call.custom.action)
            registerEvent('call:accept', resourceRoot, call.custom.accept)

            addCommandHandler('chamados', call.commands.chamados)
        end
    },

    commands = {
        chamados = function(player)
            if not (player:isPermission('Mec') and player:getData('service.mechanic')) then
                return
            end

            call.system.update(player)
            triggerClientEvent(player, 'call:show', resourceRoot)
        end
    },

    custom = {
        action = function(player)
            player = player or source

            if call.players[source] then
                return notify.server(source, 'Você já está em uma chamada.', 'error')
            end

            local pos = Vector3(source:getPosition(player));

            call.players[source] = {
                player = source,
                location = source:getZoneName(),
                tick = getTickCount(),
                blip = createBlip(pos.x, pos.y, pos.z, 41),
                timer = false,
            }

            notify.server(source, 'Você chamou um mecânico.', 'success')
            setElementVisibleTo(call.players[source].blip, root, false)

            for _, mechanic in ipairs(getElementsByType('player')) do
                if mechanic:isPermission('Mec') and mechanic:getData('service.mechanic') then
                    mechanic:outputChat('#FF0000[MECÂNICO] #FFFFFF' .. source.name .. ' chamou um mecânico em ' .. source:getZoneName() .. '.', 255, 255, 255, true)
                    setElementVisibleTo(call.players[source].blip, root, true)
                end
            end

            call.players[source].timer = setTimer(function(player)
                
                if call.players[player] then 
                    if call.players[player].blip and isElement(call.players[player].blip) then 
                        destroyElement(call.players[player].blip)
                        killTimer(call.players[player].timer)
                       
                        call.players[player].blip = nil 
                        notify.server(player, 'Tempo do chamado encerrado!', 'info')
                    end
              
                end

            end, 3 * 60000, 1, call.players[source].player)

        end,

        accept = function(target)
            if not isElement(target) then
                return notify.server(source, 'Este jogador não existe.', 'error')
            end

            if not call.players[target] then
                return notify.server(source, 'Este jogador não chamou mecânico.', 'error')
            end

            call.players[target] = nil
            call.system.update(client)
            triggerClientEvent(client, 'point:create', resourceRoot, 'call', 'Chamado', target)

            notify.server(source, 'Você aceitou o chamado.', 'success')
            notify.server(target, 'Seu chamado foi aceito.', 'success')
        end
    },

    system = {
        update = function(player)
            player = player or client

            if not isElement(player) then
                return error('call.system.update: player is not element')
            end

            local cache = {}
            local index = 0

            for target, v in pairs(call.players) do
                if isElement(target) and getTickCount() - v.tick <= 60000 then
                    index = index + 1
                    cache[index] = v
                else
                    call.players[target] = nil
                end
            end

            triggerClientEvent(player, 'call:update', resourceRoot, cache)
        end
    }
}

point = {
    events = {
        start = function()
            registerEvent('point:hit', resourceRoot, point.custom.hit)
        end
    },

    custom = {
        hit = function(target, index)
            index = decode(index)

            if not index then
                return
            end

            if index == 'call' then
                notify.server(client, 'Você chegou ao chamado.', 'success')
            end
        end
    }
}

core.start()

addEventHandler('onElementClicked', root, function(button, state, player)
    if button == 'left' and state == 'down' and source.type == 'vehicle' then
        if isPlayerBag(player) then
            triggerClientEvent(player, 'repair:update', resourceRoot, source)
        end
    end
end)