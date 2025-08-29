local marker_data = {}
local player_data = {}
local chest = {}
local blip = {}

addEventHandler('onResourceStart', resourceRoot, function()
    for _, v in ipairs(config.Start) do 
        local marker = createMarker(v[1], v[2], v[3] - 0.9, 'cylinder', 1.5, 139, 100, 255, 0)
        setElementData(marker, "markerData", {title = "Rotas", desc = "Inicie sua rota ilegal.", icon = "map"})
        marker_data[marker] = v
    end
    print(#config.Start .. ' Markers das rotas foram carregados!')
end)

addEventHandler('onMarkerHit', resourceRoot, function(player, dimension)
    if player and isElement(player) and getElementType(player) == 'player' and dimension and not isPedInVehicle(player) then 
        if marker_data[source] then 
            if getPlayerAcl(player, marker_data[source].acl) then 
                triggerClientEvent(player, 'onPlayerToggleRouter', resourceRoot, marker_data[source])
            else
                config.sendMessageServer(player, 'Você não possui permissão!', 'error')
            end
        end
    end
end)

function isPlayerInRouter(player)
    return player and isElement(player) and getElementType(player) == 'player' and player_data[player]
end

function stopPlayerRouter(player)
    if player and isElement(player) and getElementType(player) == 'player' then 
        if player_data[player] then
            if player_data[player].marker and isElement(player_data[player].marker) then 
                destroyElement(player_data[player].marker)
            end
            if chest[player] and isElement(chest[player]) then 
                destroyElement(chest[player])
            end
            if blip[player] and isElement(blip[player]) then 
                destroyElement(blip[player])
            end
            player_data[player] = nil
            triggerClientEvent(player, "removePoint", player)
        end
    end
end

function giveItem(player, _type, index)
    if player and isElement(player) and getElementType(player) == 'player' then 
        if config.Positions[_type][index] then 
            for i = 1, #config.Positions[_type][index].itens do 
                exports['guetto_inventory']:giveItem(player, config.Positions[_type][index].itens[i], config.Positions[_type][index].quantidade)
            end
        end
    end
end

function onPlayerStartRouter(player, _type)
    if player and isElement(player) and getElementType(player) == 'player' then 
        if not player_data[player] then 
            player_data[player] = {
                count = 0,
                owner = player,
                type = _type
            }

            local pos = config.Positions[_type][1]
            player_data[player].marker = createMarker(pos[1], pos[2], pos[3] - 0.9, 'cylinder', 2, 139, 100, 255, 0, player)
            chest[player] = createObject(config.Others.object, pos[1], pos[2], pos[3] - 0.9)
            blip[player] = createBlip(pos[1], pos[2], pos[3], 41)

            triggerClientEvent(player, "togglePoint", player, pos[1], pos[2], pos[3], 0, 0)
            setElementVisibleTo(chest[player], root, false)
            setElementVisibleTo(chest[player], player, true)
            setElementVisibleTo(blip[player], root, false)
            setElementVisibleTo(blip[player], player, true)

            triggerClientEvent(player, "OnPlayerRouterDraw", resourceRoot, 0, #config.Positions[_type], _type)
            setObjectScale(chest[player], 0.8)
        end

        if player_data[player].marker and isElement(player_data[player].marker) then 
            local function onMarkerHit(element, dimension)
                if element and isElement(element) and getElementType(element) == 'player' and dimension then 
                    if player_data[player] and player_data[player].owner == element then 
                        setElementFrozen(element, true)
                        toggleAllControls(element, false)
                        setPedAnimation(element, 'BOMBER', 'BOM_Plant', -1, true)

                        setTimer(function()
                            if player and isElement(player) and getElementType(player) == 'player' then 
                                if player_data[player] then 
                                    setPedAnimation(player)
                                    setElementFrozen(player, false)
                                    toggleAllControls(player, true)

                                    if player_data[player].count >= #config.Positions[player_data[player].type] then 
                                        stopPlayerRouter(player)
                                        triggerClientEvent(player, "onPlayerRouterFinish", resourceRoot)
                                        config.sendMessageServer(player, 'Você finalizou todas suas rotas com sucesso!', 'success')
                                    else
                                        if player_data[player].marker and isElement(player_data[player].marker) then 
                                            destroyElement(player_data[player].marker)
                                        end

                                        local next_router = math.random(#config.Positions[player_data[player].type])
                                        if chest[player] and isElement(chest[player]) then 
                                            destroyElement(chest[player])
                                        end
                                        if blip[player] and isElement(blip[player]) then 
                                            destroyElement(blip[player])
                                            blip[player] = nil 
                                        end

                                        player_data[player].count = player_data[player].count + 1
                                        local pos = config.Positions[player_data[player].type][next_router]
                                        player_data[player].marker = createMarker(pos[1], pos[2], pos[3] - 0.9, 'cylinder', 2, 139, 100, 255, 0, player)
                                        chest[player] = createObject(config.Others.object, pos[1], pos[2], pos[3] - 0.9)
                                        blip[player] = createBlip(pos[1], pos[2], pos[3], 20)

                                        triggerClientEvent(player, "togglePoint", player, pos[1], pos[2], pos[3], 0, 0)
                                        setElementVisibleTo(chest[player], root, false)
                                        setElementVisibleTo(chest[player], player, true)

                                        local xp = (getElementData(player, 'XP') or 0)
                                        config.sendMessageServer(player, 'Você coletou ' .. player_data[player].count .. '/' .. #config.Positions[player_data[player].type] .. ' e recebeu 800 de XP.', 'info')
                                        setElementData(player, 'XP', xp + 800)

                                        setObjectScale(chest[player], 0.8)
                                        triggerClientEvent(player, "OnPlayerRouterDraw", resourceRoot, player_data[player].count, #config.Positions[player_data[player].type], _type)
                                        giveItem(player, player_data[player].type, next_router)
                                        addEventHandler('onMarkerHit', player_data[player].marker, onMarkerHit)
                                    end
                                end
                            end
                        end, 5000, 1)
                    end
                end
            end

            addEventHandler('onMarkerHit', player_data[player].marker, onMarkerHit)
        end
    end
end

addEvent('onPlayerStartRouter', true)
addEventHandler('onPlayerStartRouter', resourceRoot, function(_type)
    if not (client or (source ~= resourceRoot)) then 
        return false 
    end
    if not isPlayerInRouter(client) then 
        onPlayerStartRouter(client, _type)
        config.sendMessageServer(client, 'Você iniciou uma rota de ' .. _type .. ', siga as marcações em seu radar!', 'info')
    else
        config.sendMessageServer(client, 'Você já está em uma rota!', 'error')
    end
end)

addEvent('onPlayerTimerFinish', true)
addEventHandler('onPlayerTimerFinish', resourceRoot, function()
    if not (client or (source ~= resourceRoot)) then 
        return false 
    end
    stopPlayerRouter(client)
    triggerClientEvent(client, "onPlayerRouterFinish", resourceRoot)
    config.sendMessageServer(client, 'Seu tempo esgotou e sua rota foi finalizada!', 'info')
end)

addEventHandler('onPlayerWasted', root, function()
    if isPlayerInRouter(source) then 
        config.sendMessageServer(source, 'Você morreu e sua rota foi finalizada!', 'info')
        triggerClientEvent(source, "onPlayerRouterFinish", resourceRoot)
        stopPlayerRouter(source)
    end
end)

addEventHandler('onPlayerQuit', root, function()
    if isPlayerInRouter(source) then 
        stopPlayerRouter(source)
    end
end)

addCommandHandler("cancelarrota", function(player)
    if isPlayerInRouter(player) then 
        stopPlayerRouter(player)
        triggerClientEvent(player, "onPlayerRouterFinish", resourceRoot)
        config.sendMessageServer(player, "Você cancelou sua rota!", "info")
    end
end)
