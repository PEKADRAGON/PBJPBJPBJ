local drops = {}

createEventHandler("onPlayerDropItem", resourceRoot, function (data, quantidade)
    if not (client or ( source ~= resourceRoot ) ) then 
        return false 
    end
    if not (data or (type(data) ~= 'table')) then 
        return false 
    end
    if not (quantidade or (type(quantidade) ~= 'number' or quantidade <= 0)) then 
        return false 
    end
    if tonumber(quantidade) <= 0 then 
        return false 
    end
    if (getItem(client, data.item) < tonumber(quantidade)) then 
        return sendMessageServer(client, "Você não possui essa quantidade!", "error")
    end
    if (getPlayerSendItem(client)) then 
        return sendMessageServer(client, "Você não pode dropar um item enquanto está enviando um item!", "error")
    end
    if (isElement(getVehicleNearest(client))) then 
        return sendMessageServer(client, "Você não pode dropar um item proximo de um veículo!", "error")
    end
    local settings = config["itens"][data.item]
    if settings["others"]["dropar"] == false then 
        return sendMessageServer(client, "Você não pode dropar esse item!", "error")
    end
    if (takeItem(client, data.item, tonumber(quantidade))) then 
        local x, y, z = getElementPosition(client);        
        setPedAnimation(client, 'BOMBER', 'BOM_Plant', -1, false, false, false, false)
        toggleAllControls(client, false)
        setTimer(function(player)
            if (player and isElement(player)) then 
                setPedAnimation(player)
                toggleAllControls(player, true)    
                local object = createObject(928, x + 1, y, z - 0.8)
                drops[object] = {
                    owner = player,
                    item = data.item,
                    amount = tonumber(quantidade)
                }
                sendMessageServer(player, "Você dropou "..tonumber(quantidade).."x do item"..config["itens"][data.item].name, "success")
            end
        end, 2000, 1, client)
    else
        sendMessageServer(client, "Houve uma falha ao tentar dropar seu item!", "error")
    end
end)

addEventHandler("onElementClicked", root, function (button, state, player)
    if (button == "left" and state == "down" and player and isElement(player) and getElementType(player) == "player") then 
        if not (drops[source]) then 
            return false 
        end
        local x, y, z = getElementPosition(player);
        local x2, y2, z2 = getElementPosition(source);
        if (getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) <= 3) then 
            if not (getElementData(source, "element>clicked") or false) then 
                setElementData(source, "element>clicked", true)
                setPedAnimation(player, 'BOMBER', 'BOM_Plant', -1, false, false, false, false)
                toggleAllControls(player, false)
                setTimer(function(player, object)
                    if (player and isElement(player)) then 
                        setPedAnimation(player)
                        toggleAllControls(player, true)
                        if isElement(object) then 
                            destroyElement(object)
                        end
                        giveItem(player, drops[object].item, drops[object].amount)
                        sendMessageServer(player, "Você coletou "..tonumber(drops[object].amount).."x do item"..config["itens"][drops[object].item].name, "success")
                        drops[object] = nil
                    end
                end, 2000, 1, player, source)
            else
                sendMessageServer(player, "Esse item já está sendo coletado!", "info")
            end
        end
    end
end)