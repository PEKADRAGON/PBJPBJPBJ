addEvent('onPlayerChangeAnimation', true)
addEventHandler('onPlayerChangeAnimation', resourceRoot, function(state)
    if not client then 
        return
    end

    if (state) then 
        setPedAnimation(client, config.animation[1], config.animation[2], config.animation[3], config.animation[4], config.animation[5], config.animation[6], config.animation[7])
    else
        setPedAnimation(client)
    end
end)

addEvent('removeLockPick', true)
addEventHandler('removeLockPick', resourceRoot, function()
    if not client then 
        return
    end
end)

addEvent('onServerLockpick', true)
addEventHandler('onServerLockpick', resourceRoot, function(vehicle)
    if not client then 
        return
    end

    if vehicle then 
        if isVehicleLocked(vehicle) then
            setVehicleLocked(vehicle, false)
            sendMessage('server', client, 'Veículo destravado com sucesso', 'success')
        end
    end
end)