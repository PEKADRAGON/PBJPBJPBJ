--[[
    --» sᴄʀɪᴘᴛ ғᴇɪᴛᴏ ᴘᴏʀ » Pedro Developer
--]]

outputDebugString('[PEDRO DEVELOPER] RESOURCE '..getResourceName(getThisResource())..' ATIVADA COM SUCESSO', 4, 204, 82, 82)

function vehicleInteractions(player, key)

    if (key == config.lockKey) then 

        local vehicle = getPedOccupiedVehicle(player)
        if not (isElement(vehicle)) then 
            vehicle = getNearestVehicle(player, 5)
        end 
        if (isElement(vehicle)) then 
            local owner = exports["guetto_dealership"]:getVehicleOwner(vehicle)
            if (getElementData(vehicle, "Owner") == getAccountName(getPlayerAccount(player))) then 

                if (isVehicleLocked(vehicle)) then 

                    setVehicleLocked(vehicle, false)
                    config.notify(player, 'Você destrancou o veículo com sucesso.', 'success')

                    local x, y, z = getElementPosition(vehicle)
                    triggerClientEvent(player, 'onClientPlaySoundVehicle', player, 'assets/sounds/unlocked.mp3', x, y, z)

                else

                    setVehicleLocked(vehicle, true)
                    config.notify(player, 'Você trancou o veículo com sucesso.', 'success')

                    local x, y, z = getElementPosition(vehicle)
                    triggerClientEvent(player, 'onClientPlaySoundVehicle', player, 'assets/sounds/locked.mp3', x, y, z)

                end

            else

                config.notify(player, 'Você não tem permissão para trancar esse veículo.', 'error')

            end
            
        end

    else 

        local vehicle = getPedOccupiedVehicle(player)
        if (isElement(vehicle)) then 

            if (key == config.engineKey) then 
                
                if (getVehicleController(vehicle) ~= player) then 

                    return 

                end

                if (getElementHealth(vehicle) <= config.minimunVehicleEngine) then 
            
                    return config.notify(player, 'O motor está prejudicado, e não é possivel realizar essa operação!', 'error') 
        
                end
        
        
                if (getVehicleEngineState(vehicle)) then 
                
                    setVehicleEngineState(vehicle, false)
                    config.notify(player, 'Você desligou o veiculo com sucesso.', 'success')
                
                else
                
                    local x, y, z = getElementPosition(vehicle)
                    setVehicleEngineState(vehicle, true)
                    triggerClientEvent(player, 'onClientPlaySoundVehicle', player, 'assets/sounds/starter.mp3', x, y, z)
                    config.notify(player, 'Você ligou o veículo com sucesso.', 'success')
                
                end

            elseif (key == config.lightsKey) then 

                if (getVehicleController(vehicle) ~= player) then 

                    return 

                end

                if (getVehicleOverrideLights(vehicle) == 2) then 

                    setVehicleOverrideLights(vehicle, 1) 
                    config.notify(player, 'Você desligou os faróis desse veiculo.', 'info')
        
                else
        
                    setVehicleOverrideLights(vehicle, 2) 
                    config.notify(player, 'Você ligou os faróis desse veiculo.', 'info')
        
                end
        
                local x, y, z = getElementPosition(vehicle)
                triggerClientEvent(player, 'onClientPlaySoundVehicle', player, 'assets/sounds/lightswitch.mp3', x, y, z)

            elseif (key == config.beltKey) then 

                if (getElementData(player, 'belt')) then 

                    config.notify(player, 'Você retirou o cinto de segurança.', 'success')
                    removeElementData(player, 'belt')
                    local x, y, z = getElementPosition(vehicle)
                    triggerClientEvent(player, 'onClientPlaySoundVehicle', player, 'assets/sounds/takebelt.mp3', x, y, z)

                else

                    config.notify(player, 'Você colocou o cinto de segurança.', 'success')
                    setElementData(player, 'belt', true)
                    local x, y, z = getElementPosition(vehicle)
                    triggerClientEvent(player, 'onClientPlaySoundVehicle', player, 'assets/sounds/putbelt.mp3', x, y, z)

                end
        
            end

        end

    end

end

addEventHandler('onPlayerLogin', root, 

    function()

        if not (isKeyBound(source, config.lockKey, 'down', vehicleInteractions)) then 
            
            bindKey(source, config.lockKey, 'down', vehicleInteractions)

        end 

        if not (isKeyBound(source, config.lightsKey, 'down', vehicleInteractions)) then 
            
            bindKey(source, config.lightsKey, 'down', vehicleInteractions)

        end 

        if not (isKeyBound(source, config.beltKey, 'down', vehicleInteractions)) then 
            
            bindKey(source, config.beltKey, 'down', vehicleInteractions)

        end 

        if not (isKeyBound(source, config.engineKey, 'down', vehicleInteractions)) then 
            
            bindKey(source, config.engineKey, 'down', vehicleInteractions)

        end 

    end

)

addEventHandler('onResourceStart', getResourceRootElement(getThisResource()), 

    function()

        for _, player in ipairs(getElementsByType('player')) do 

            if not (isKeyBound(player, config.lockKey, 'down', vehicleInteractions)) then 
            
                bindKey(player, config.lockKey, 'down', vehicleInteractions)
    
            end 
    
            if not (isKeyBound(player, config.lightsKey, 'down', vehicleInteractions)) then 
                
                bindKey(player, config.lightsKey, 'down', vehicleInteractions)
    
            end 
    
            if not (isKeyBound(player, config.beltKey, 'down', vehicleInteractions)) then 
                
                bindKey(player, config.beltKey, 'down', vehicleInteractions)
    
            end 
    
            if not (isKeyBound(player, config.engineKey, 'down', vehicleInteractions)) then 
                
                bindKey(player, config.engineKey, 'down', vehicleInteractions)
    
            end 

        end

    end

)

addEventHandler('onVehicleStartEnter', root, 
    function(player, _, theJacker)
        if (isVehicleLocked(source)) then
            cancelEvent() 
            config.notify(theJacker, 'Esse veículo está trancado.', 'error') 
            if theJacker and isElement(theJacker) then 
                config.notify(theJacker, 'Um jogador está tentando roubar seu veículo!', 'error')
            end

        end 

    end

)

addEventHandler('onVehicleStartExit', root, 

    function(player, _, theJacker)
        if type(player) == 'userdata' then return end
        if not player and getElementType(player) ~= 'player' then return end

        if theJacker and isElement(theJacker) then 

            if isVehicleLocked(source) then 

                cancelEvent()
                config.notify(theJacker, 'Esse veículo está trancado.', 'error') 
                config.notify(player, 'Um jogador está tentando roubar seu veículo.', 'info')

            else 

                setElementData(player, 'belt', false)

            end 

        else 

            if player and isElement(player) and (getElementData(player, 'belt')) then 

                setElementData(player, 'belt', false)
                
            end

        end 

    end 

)

function getNearestVehicle(player,distance)
	local lastMinDis = distance-0.0001
	local nearestVeh = false
	local px,py,pz = getElementPosition(player)
	local pint = getElementInterior(player)
	local pdim = getElementDimension(player)

	for _,v in pairs(getElementsByType("vehicle")) do
		local vint,vdim = getElementInterior(v),getElementDimension(v)
		if vint == pint and vdim == pdim then
			local vx,vy,vz = getElementPosition(v)
			local dis = getDistanceBetweenPoints3D(px,py,pz,vx,vy,vz)
			if dis < distance then
				if dis < lastMinDis then 
					lastMinDis = dis
					nearestVeh = v
				end
			end
		end
	end
	return nearestVeh
end

