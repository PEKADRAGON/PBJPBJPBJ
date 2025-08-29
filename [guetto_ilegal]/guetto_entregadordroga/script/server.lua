local entregas = {
    functions = {},
    markers = {},
    rote = {},
    markerEntrega = {},
    type = {},
}

local blipPM = {};
local defaultBlip = {};

function notifyPM(element)
    for k, player in ipairs(getElementsByType("player")) do
        if (isObjectInACLGroup("user."..(getAccountName(getPlayerAccount(player))), aclGetGroup(config['ACL-PM']))) then
            local x, y, z = getElementPosition(element);

            if (blipPM[element] and isElement(blipPM[element])) then destroyElement(blipPM[element]); blipPM[element] = nil; end
            outputChatBox("Foi denunciada movimentação de vendas de drogas. Reforçar patrulhamento!", player, 255, 255, 255, true); 
            blipPM[element] = createBlip(x, y, z, 48);
            setElementVisibleTo(blipPM[element], root, false)
            setElementVisibleTo(blipPM[element], player, true)
            setTimer(
                function()
                    if (blipPM[element] and isElement(blipPM[element])) then
                        destroyElement(blipPM[element]);
                    end 
                end,
            15 * 1000, 1);
        end
    end
end

addEventHandler("onResourceStart", resourceRoot, function(resource)
    if resource == getThisResource() then
        for i, v in ipairs(config["Configurações"]) do
            local x,y,z,rx,ry,rz,name,droga,itemID, modelID = v.x, v.y, v.z, rx, ry, rz, v.name, v.droga, v.itemID, v.modelID
            local ped = createPed(modelID, x, y, z, rx, ry, rz)
            defaultBlip[i] = createBlip(x, y, z, 62)
            setElementData(ped, "TS.Ped", true)
            setElementData(ped, "MT.Pedinfo", config["Configurações"][i])
            entregas.markers[ped] = {name, itemID}
        end
    end
end)


entregas.functions["server:clickedElement"] = function( button, state, player ) 
    if button == "left" and state == "down" then
        local thePlayer = player
        if isElement( player ) and isElement( source ) then
            if getElementType( source ) == "ped" and entregas.markers[source] then 
                local x, y, z = getElementPosition( player )
                local x1, y1, z1 = getElementPosition( source ) 
                local distance = getDistanceBetweenPoints3D( x, y, z, x1, y1, z1 ) 
                if distance <= 2 then 
                    entregas.functions["server:startRote"](thePlayer, entregas.markers[source])
                end
            end
        end
    end
end
addEventHandler( "onElementClicked", root, entregas.functions["server:clickedElement"] ) 

entregas.functions["server:startRote"] = function(thePlayer, tab)
    local name = tab[1]
    local itemID = tab[2]
    --local getDrugs = exports[config.nameInv]:getPlayerItem(thePlayer, itemID)
    local amount = exports[config.nameInv]:getItem(thePlayer, itemID)
    if amount == 0 then return triggerClientEvent(thePlayer, 'showInfobox', thePlayer, 'error', "Você não possui drogas!")  end
    if not entregas.rote[thePlayer] then
        local randomRote = math.random(#config[name])
        local x,y,z = config[name][randomRote][1], config[name][randomRote][2], config[name][randomRote][3]
        entregas.rote[thePlayer] = true
        entregas.markerEntrega[thePlayer] = createMarker( x,y,z-1, "cylinder", 1.5, 193, 159, 114, 100)
        iprint(entregas.markerEntrega[thePlayer])
        setElementVisibleTo(entregas.markerEntrega[thePlayer], root, false)
        setElementVisibleTo(entregas.markerEntrega[thePlayer], thePlayer, true)
        entregas.type[thePlayer] = tab
        triggerClientEvent(thePlayer,"togglePoint", thePlayer, config[name][randomRote][1], config[name][randomRote][2], config[name][randomRote][3])
        --exports[config.radarName]:SetPath(thePlayer, x, y)
        triggerClientEvent(thePlayer, 'showInfobox', thePlayer, 'info', "Siga a rota para fazer a entrega!")
       -- exports.FR_DxMessages:addBox(thePlayer, "Siga a rota para fazer a entrega!", "info")
    else
        entregas.rote[thePlayer] = nil
        if isElement(entregas.markerEntrega[thePlayer]) then
            destroyElement(entregas.markerEntrega[thePlayer])
            entregas.markerEntrega[thePlayer] = nil
            triggerClientEvent(thePlayer,"removePoint", thePlayer)
        end
        entregas.type[thePlayer] = nil
        triggerClientEvent(thePlayer, 'showInfobox', thePlayer, 'error', "Entrega Cancelada!")
       -- exports.FR_DxMessages:addBox(thePlayer, "Entrega Cancelada!", "error")
    end
end

addEventHandler("onMarkerHit", resourceRoot, function(thePlayer)
    if isElement(thePlayer) and isElement(source) then
        if getElementType(thePlayer) == "player" and not isPedInVehicle(thePlayer) and isElement(entregas.markerEntrega[thePlayer]) then
            if source == entregas.markerEntrega[thePlayer] then
                local itemID = entregas.type[thePlayer][2]
                local price = config["Prices"][itemID]
                local amount = exports[config.nameInv]:getItem(thePlayer, itemID)
                print (amount)
                if tonumber(amount) >= 1 then
                    exports["guetto_inventory"]:takeItem(thePlayer, itemID, 1)
                    exports["guetto_inventory"]:giveItem(thePlayer, 100, price)
                   -- triggerEvent("TS:takeItem", thePlayer, thePlayer, itemID, 1)
                   -- triggerEvent("TS:addItem", thePlayer, thePlayer, 14, price)
                   triggerClientEvent(thePlayer, 'showInfobox', thePlayer, 'success', "Você recebeu R$ "..price.." em dinheiro sujo!")
                   -- exports.FR_DxMessages:addBox(thePlayer, "Você recebeu R$ "..price.." em dinheiro sujo!", "success")
                    notifyPM(thePlayer);
                    entregas.rote[thePlayer] = nil
                    if isElement(entregas.markerEntrega[thePlayer]) then
                        destroyElement(entregas.markerEntrega[thePlayer])
                        entregas.markerEntrega[thePlayer] = nil
                    end
                    entregas.functions["server:startRote"](thePlayer, entregas.type[thePlayer])
                else
                    triggerClientEvent(thePlayer, 'showInfobox', thePlayer, 'error', "Você não tem essa droga!")
                    --exports.FR_DxMessages:addBox(thePlayer, "Você não tem essa droga!", "error")
                    entregas.rote[thePlayer] = nil
                    if isElement(entregas.markerEntrega[thePlayer]) then
                        destroyElement(entregas.markerEntrega[thePlayer])
                        entregas.markerEntrega[thePlayer] = nil
                    end
                    entregas.type[thePlayer] = nil
                end
            end
        end
    end
end)