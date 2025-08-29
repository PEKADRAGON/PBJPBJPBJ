---[[
    --» sᴄʀɪᴘᴛ ғᴇɪᴛᴏ ᴘᴏʀ » Pedrooooo#1554
--]]

local blip = {}
local marker, vehicle = {}, {}
for i, v in ipairs(config.markers) do 
    marker[i] = createMarker(Vector3(unpack(v.marker_position)), 'cylinder', 1.5, r, g, b, a) 
    setElementData(marker[i] , 'markerData', {title = 'Bombeiro', desc = 'Equipamentos!', icon = 'checkpoint'})

    addEventHandler('onMarkerHit', marker[i],
        function(player) 
            if (isElement(player) and getElementType(player) == 'player' and not isPedInVehicle(player)) then 
                if (getPlayerPermissions(player, config.acls)) then 
                    triggerClientEvent(player, 'onClientDrawFirefighter', player, i)
                end
            end
        end
    )
end

local oldSkin = {}
addEvent('onPlayerColectFirefighterSkin', true)
addEventHandler('onPlayerColectFirefighterSkin', root, 
    function(player)
        if (getElementModel(player) ~= config.infosPanel.skin) then 
            oldSkin[player] = getElementModel(player)
            setElementModel(player, config.infosPanel.skin)
            message(player, 'Você coletou a roupa de bombeiros!', 'success')
        else 
            message(player, 'Você já está usando a skin de bombeiros!', 'error')
        end
    end
)

addEvent('onPlayerGetFirefighterItens', true)
addEventHandler('onPlayerGetFirefighterItens', root, 
    function(player)
        for i, v in ipairs(config.infosPanel.itens) do 
            if ((getItem(player, v[1]) or 0) < v[2]) then 
                giveItem(player, v[1], v[2])
            end
        end
        giveWeapon(player, 42, 1000)
        giveWeapon(player, 9, 1)
        message(player, 'Você pegou todos os itens necesarios!', 'success')
    end
)

addEvent('onPlayerGetVehicleFirefighterVehicle', true)
addEventHandler('onPlayerGetVehicleFirefighterVehicle', root, 
    function(player, index) 
        if (isElement(vehicle[player])) then 
            destroyElement(vehicle[player])
        end 

        vehicle[player] = createVehicle(config.infosPanel.vehicle, unpack(config.markers[index].vehicle_position))
        message(player, 'Você pegou um carro de bombeiros!', 'success')
    end
)

addEvent('onPlayerGiveBackFirefighterItens', true)
addEventHandler('onPlayerGiveBackFirefighterItens', root, 
    function(player)
        if (oldSkin[player]) then 
            setElementModel(player, oldSkin[player])
            oldSkin[player] = nil 
        end

        if (isElement(vehicle[player])) then 
            destroyElement(vehicle[player])
        end

        for i, v in ipairs(config.infosPanel.itens) do 
            takeItem(player, v[1], (getItem(player, v[1]) or 0))
        end
        takeWeapon(player, 42)
        takeWeapon(player, 9)

        message(player, 'Você devolveu todos seus equipamentos!', 'success')
    end
)

addEventHandler('onPlayerLogin', root,
    function()
        if (isElement(vehicle[source])) then 
            destroyElement(vehicle[source])
        end
    end
)

addEventHandler('onPlayerWasted', root,
    function()
        if (isElement(vehicle[source])) then 
            destroyElement(vehicle[source])
        end
    end
)

--addEventHandler('onVehicleDamage', root, 
--    function()
--        if (getElementHealth(source) <= config.healthVehicle) then 
--            if not (getElementData(source, 'onFireVehicle')) then 
--                startVehicleFire(source)
--            end
--        end
--    end
--)

--addEventHandler('onVehicleStartEnter', root, 
--    function(player, _, jacked)
--        if (getElementData(source, 'firefighterDoor')) then 
--            
--            if (isElement(player)) then 
--                message(player, 'A porta do veiculo está emperrada!', 'error')
--            end
--
--            if (isElement(jacked)) then 
--                message(jacked, 'A porta do veiculo está emperrada!', 'error')
--            end
--        
--            cancelEvent()
--        end    
--    end
--)

--addEventHandler('onVehicleStartExit', root, 
--    function(player, _, jacked)
--        if (getElementData(source, 'firefighterDoor')) then 
--            
--            if (isElement(player)) then 
--                message(player, 'A porta do veiculo está emperrada!', 'error')
--            end
--
--            if (isElement(jacked)) then 
--                message(jacked, 'A porta do veiculo está emperrada!', 'error')
--            end
--            
--            cancelEvent()
--        end    
--    end
--)

--addEvent('onPlayerReceiveFirefighterSuccessReport', true)
--addEventHandler('onPlayerReceiveFirefighterSuccessReport', root, 
--    function(player)
--        message(player, 'Você apagou o fogo do veiculo, vá até lá e serre a porta!', 'success')
--    end
--)

addEvent('onPlayerReceiveNaturalFightSuccessMessage', true)
addEventHandler('onPlayerReceiveNaturalFightSuccessMessage', root, 
    function(player, index)
        givePlayerMoney(player, 5000)
        message(player, 'Você apagou o fogo da região!', 'success')
    end
)

--addEvent('onPlayerIntoxicationDeath', true)
--addEventHandler('onPlayerIntoxicationDeath', root, 
--    function(player)
--        killPed(player)
--        message(player, 'Você morreu de intoxicação!', 'info')
--    end
--)

--local areaDoor = {}
--addEvent('onFirefighterOpenDoor', true)
--addEventHandler('onFirefighterOpenDoor', root, 
--    function(player, vehicle)
--        if (isElement(vehicle)) then 
--            if (getElementData(vehicle, 'firefighterDoor')) then 
--                if (getPedWeapon(player) == 9) then 
--                    toggleAllControls(player, false)
--                    setElementFrozen(player, true) 
--                    setPedAnimation(player, 'BASEBALL', 'bat_block')
--                    setTimer(function(player, vehicle)
--    
--                        if (isElement(player)) then 
--                            toggleAllControls(player, true)
--                            setElementFrozen(player, false) 
--                            setPedAnimation(player, nil)
--    
--                            if (isElement(vehicle)) then 
--                                setVehicleDoorState(vehicle, 2, 4)
--                                setVehicleDoorState(vehicle, 3, 4)
--                                setVehicleDoorState(vehicle, 4, 4)
--                                setVehicleDoorState(vehicle, 5, 4)
--                                removeElementData(vehicle, 'firefighterDoor')
--
--                                if (isElement(areaDoor[vehicle])) then 
--                                    destroyElement(areaDoor[vehicle])
--                                end
--                            end
--                        end
--                    end, 8000, 1, player, vehicle)
--                else 
--                    message(player, 'Você precisa estar com a serra na mão!', 'error')
--                end
--            end
--        end
--    end
--)

--addEvent('onPlayerDestroyVehicleFire', true)
--addEventHandler('onPlayerDestroyVehicleFire', root,
--    function(vehicle)
--        triggerClientEvent(root, 'onClientDestroyVehicleFire', root, vehicle)
--    end
--)

addEvent('onPlayerDestroyNaturalFire', true)
addEventHandler('onPlayerDestroyNaturalFire', root,
    function(index)
        if blip[index] then 
            destroyElement(blip[index])
            blip[index] = nil
        end
        triggerClientEvent(root, 'onClientDestroyNaturalFire', root, index)
    end
)


setTimer(function()
    local randomFire = math.random(#config.randomFires)
    local pos = config.randomFires[randomFire]

    triggerClientEvent(root, 'onClientCreateFire', root, pos[1], pos[2], pos[3], randomFire)
    blip[randomFire] = createBlip(pos[1],pos[2],pos[3], 37)
    setElementVisibleTo(blip[randomFire], root, false)

    for _, player in ipairs(getElementsByType('player')) do 
        if (getPlayerPermissions(player, config.acls)) then 
            setElementVisibleTo(blip[randomFire], player, true)
            message(player, 'Relatos de um incêndio em '..getZoneName(pos[1], pos[2], pos[3])..' - '..getZoneName(pos[1], pos[2], pos[3], true), 'info')
        end
    end
end, (config.timeRandomFires * 60000), 0)

--unction startVehicleFire(vehicle) 
--  -- triggerClientEvent(root, 'onClientVehicleStartFire', root, vehicle)
--   setElementData(vehicle, 'onFireVehicle', 50)
--   setElementData(vehicle, 'firefighterDoor', true)
--
--   if (isElement(areaDoor[vehicle])) then 
--       destroyElement(areaDoor[vehicle])
--   end
--
--   local x, y, z = getElementPosition(vehicle)
--   areaDoor[vehicle] = createColSphere(x, y, z, 3) 
--   attachElements(areaDoor[vehicle], vehicle)
--
--   addEventHandler('onColShapeHit', areaDoor[vehicle], 
--       function(player)
--           if (isElement(player) and getElementType(player) == 'player' and not isPedInVehicle(player)) then 
--               if (isElement(vehicle)) then 
--                   if (getElementData(vehicle, 'firefighterDoor')) then 
--                       if not (getElementData(vehicle, 'onFireVehicle')) then 
--                           triggerClientEvent(player, 'onClientDrawFirefighterDoor', player, vehicle)
--                       end     
--                   end              
--               end
--           end
--       end
--   )
--
--   addEventHandler('onColShapeLeave', areaDoor[vehicle], 
--       function(player)
--           if (isElement(player) and getElementType(player) == 'player') then 
--               triggerClientEvent(player, 'onClientRemoveFirefighterDoor', player, vehicle)
--           end
--       end
--   )
--nd

function getPlayerPermissions(player, acls) 
    for i, v in ipairs(acls) do 
        if (isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(player)), aclGetGroup(v))) then 
            return true 
        end
    end
end