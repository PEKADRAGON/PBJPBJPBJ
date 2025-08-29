local resource = {object = {}, spikeData = {}, limit = {}, cooldown = {}}

local function openPanelBlitz (player)
    if (player and isElement(player) and getElementType(player) == "player") then
        if isPlayerInACL(player, config.others.commands['open panel'].permission) then 
            triggerClientEvent(player, 'squady.togglePanelBlitz', resourceRoot, true)
        else
            sendMessage('server', player, 'Você não possui permissão para executar essa ação.', 'error')
        end
    end
end

local function createBlitz (id)
    if not client then 
        return
    end

    if isPlayerInACL(client, config.others.commands['open panel'].permission) then
        if (id and tonumber(id)) then 

            if resource.limit[client] and resource.limit[client] >= config.others.limit_objects then
                sendMessage('server', client, 'Limite de objetos atingido.', 'error')
                return
            end

            if resource.cooldown[client] and resource.cooldown[client] > getTickCount() then
                sendMessage('server', client, 'Cooldown de criação de objetos atingido! Espere ' .. math.floor((resource.cooldown[client] - getTickCount()) / 1000) .. ' segundos.', 'error')
                return
            end

            local pos = {getElementPosition(client)}
            local rot = {getElementRotation(client)}

            if id == 2892 then
                resource.object[client] = createObject(id, pos[1], pos[2], pos[3] - 1, rot[1], rot[2], rot[3] + 90)

                local rotation = {getElementRotation(resource.object[client])}
                setElementAlpha(resource.object[client], 150)
                triggerClientEvent(client, 'squady.createSpike', resourceRoot, client, resource.object, {pos[1], pos[2], pos[3]}, rotation[3])
            else
                resource.object[client] = createObject(id, pos[1], pos[2], pos[3])
            end
            
            resource.limit[client] = resource.limit[client] or 0
            resource.limit[client] = resource.limit[client] + 1

            resource.cooldown[client] = getTickCount() + config.others.cooldown_objects

            triggerClientEvent(client, 'squady.objectBreakble', resourceRoot, resource.object[client])

            setElementPosition(client, pos[1] + 1.5, pos[2], pos[3])
            setElementFrozen(resource.object[client], true)
            setElementCollisionsEnabled(resource.object[client], true)
            setElementData(resource.object[client], "element:blitz", true)
            setElementData(resource.object[client], "element:owner", client)
        end
    end
end

local function moveObjectPosition (object, x, y, z, rx, ry, rz)
    if not client then 
        return
    end

    setElementPosition(object, x, y, z)
    setElementRotation(object, rx, ry, rz)
end

local function deleteBlitz ()
    if not client then 
        return
    end

    for i, v in ipairs(getElementsByType('object')) do 
        if getElementType(v) == 'object' then 
            if getElementData(v, 'element:owner') == client then 
                triggerClientEvent(client, 'squady.deleteSpike', resourceRoot, client)
                resource.limit[client] = 0
                destroyElement(v)
            end
        end
    end
end

local function pierceWheel (object)
    if not client then 
        return
    end

    if (object[client] and isElement(object[client])) then 
        if getElementType(object[client]) == 'object' then
            if (getElementData(object[client], 'element:blitz') or false) ~= false then
                pos = {getElementPosition(object[client])}
            end
        end 
    end


    if client and isElement(client) and vehicle and isElement(vehicle) then 
        local vehicle = getPedOccupiedVehicle(client)
        local position = {getElementPosition(vehicle)}
        
        if pos[3] < position[3] then 
            setVehicleWheelStates(vehicle, 1, 1, 1, 1)
        end
    end
end

local destruided = false

local function destroyBlitzDistance (player)
    if not isPlayerInACL(player, config.others.commands['destroy blitz'].permission) then
        sendMessage('server', player, 'Não tem permissão para executar essa ação.', 'error')
        return 
    end

    for i, v in ipairs(getElementsByType('object')) do
        if getElementType(v) == 'object' then
            if getElementData(v, 'element:blitz') then
                local positionObject = {getElementPosition(v)}
                local positionPlayer = {getElementPosition(player)}

                if getDistanceBetweenPoints3D(positionObject[1], positionObject[2], positionObject[3], positionPlayer[1], positionPlayer[2], positionPlayer[3]) <= 20 then
                    destroyElement(v)
                    destruided = true
                end
            end
        end
    end
    
    if destruided then
        sendMessage('server', player, 'Blitz proxima destruida com sucesso.', 'success')
        triggerClientEvent(player, 'squady.deleteSpike', resourceRoot, player) 
    end
end

local function onPlayerQuit ()
    local player = source 

    for i, v in ipairs(getElementsByType('object')) do 
        if getElementType(v) == 'object' then 
            if getElementData(v, 'element:owner') == player then 
                triggerClientEvent(player, 'squady.deleteSpike', resourceRoot, player)
                resource.limit[player] = 0
                destroyElement(v)
            end
        end
    end
end

registerEvent('squady.createBlitz', resourceRoot, createBlitz)
registerEvent('squady.deleteBlitz', resourceRoot, deleteBlitz)
registerEvent('squady.moveObjectPosition', resourceRoot, moveObjectPosition)
registerEvent('squady.pierceWheel', resourceRoot, pierceWheel)

addEventHandler('onPlayerQuit', root, onPlayerQuit) 
addCommandHandler(config.others.commands['open panel'].command, openPanelBlitz)
addCommandHandler(config.others.commands['destroy blitz'].command, destroyBlitzDistance)