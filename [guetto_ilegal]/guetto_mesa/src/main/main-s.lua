local craft = {}

function createEvent(event, ...)
    addEvent(event, true)
    addEventHandler(event, ...)
end

function setTablePosition (player)
    if not (player) then 
        return false 
    end

    if not (craft[player]) then 
        return false
    end

    if isElementAttached(craft[player].object) then 

        if (exports["guetto_inventory"]:getItem(player, config["id_mesa"]) < 1) then
            sendMessageServer(player, "Voce precisa de uma mesa para isso!", "error")
            return false
        end

        toggleControl(player, "sprint", true)
    	toggleControl(player, "jump", true)
    	toggleControl(player, "crouch", true)
        
        local x, y, z = getElementPosition (player)
        local _, _, rot = getElementRotation(player)

        setElementCollisionsEnabled(craft[player].object, true)
        detachElements(craft[player].object, player)

        setElementRotation(craft[player].object, -0.5, _, rot)
        setElementAlpha(craft[player].object, 255)

        setElementVisibleTo(craft[player].object, root, true)

        unbindKey(player, "e", "down", setTablePosition)

        craft[player].timer = setTimer ( function (element) 
            if (isElement(element)) then 
                triggerClientEvent ( root, "createPedTable", root, player, craft[player].object, craft[player], isPlayerAcl(player, config["acls_booster"]) )
            end
        end, 100000, 1, player) 

        exports["guetto_inventory"]:takeItem(player, config["id_mesa"], 1)
    end

end

function destroyPlayerTable (player)
    if not (player) then
        return false 
    end

    if not (craft[player]) then
        return false
    end

    if not isElement(craft[player].object) then
        return false
    end

    if isTimer(craft[player].timer) then
        killTimer(craft[player].timer)
    end

    toggleControl(player, "sprint", true)
    toggleControl(player, "jump", true)
    toggleControl(player, "crouch", true)
    toggleControl(player, "enter_exit", true)

    setElementCollisionsEnabled(craft[player].object, false)
    destroyElement(craft[player].object)

    unbindKey(player, "e", "down", setTablePosition)

    craft[player] = nil

    return true
end 

function isHavePlayerTable (player)
    if not (player) then
        return false
    end

    if not (craft[player]) then
        return false
    end

    if not isElement(craft[player].object) then
        return false
    end

    return true
end

function createTable (player)
    if not (player) then 
        return false 
    end

    if not (craft[player]) then 
        craft[player] = {object = false, timer = false, itens = {}}
    end

    if not isElement(craft[player].object) then 
        toggleControl(player, "sprint", false)
        toggleControl(player, "jump", false)
        toggleControl(player, "crouch", false)
        toggleControl(player, "enter_exit", false)

        craft[player].object = createObject(config["object"], 0, 0, 0)

        setElementData(craft[player].object, "table", true)

        setElementVisibleTo(craft[player].object, root, false)
        setElementVisibleTo(craft[player].object, player, true)

        attachElements(craft[player].object, player, 1-0.9, 2, -0.5, 0, 0, 0, 0)
        setElementAlpha(craft[player].object, 200)

        bindKey(player, "e", "down", setTablePosition)
        return true 
    end
    return false
end

function getTableItem (mesa, item)
    
    if not (mesa or item) then
        return 0
    end

    if not isElement(mesa) then
        return 0
    end

    local itens = getElementData(mesa, "table.itens") or {}

    for i, v in ipairs(itens) do
        if v.item == item then
            return v.amount, i
        end
    end

    return 0
end

function giveTableItem (mesa, item, quantidade)
    if not (mesa or item or quantidade) then 
        return false 
    end

    if not isElement(mesa) then 
        return false
    end

    local itens = getElementData(mesa, "table.itens") or {}
    local amount, index = getTableItem (mesa, item)

    if (amount == 0) then 
        itens[#itens+1] = {
            item = item,
            amount = quantidade            
        }
        setElementData(mesa, "table.itens", itens)
    else
        itens[index].amount = itens[index].amount + quantidade
        setElementData(mesa, "table.itens", itens)
    end

    return true
end 

function takeTableItem (mesa, item, quantidade)
    if not (mesa or item or quantidade) then 
        return false 
    end

    if not isElement(mesa) then
        return false
    end

    local itens = getElementData(mesa, "table.itens") or {}
    local amount, index = getTableItem (mesa, item)

    if (amount - quantidade < 0) then
        table.remove(itens, index)
        setElementData(mesa, "table.itens", itens)
    else
        itens[index].amount = itens[index].amount - quantidade
        setElementData(mesa, "table.itens", itens)
    end

    return true
end

function isHaveItemTable (mesa)
    if not (mesa or item or quantidade) then 
        return false 
    end

    if not isElement(mesa) then
        return false
    end

    local itens = getElementData(mesa, "table.itens") or {}

    for i = 1, #itens do 
        if itens[i].amount > 0 then
            return true, i, itens[i].item
        end
    end

    return false
end

addEventHandler("onElementClicked", root, function(button, state, player)
    if button == "left" and state == "down" and player and isElement(player) and getElementType(player) == "player" then
        if getElementData(source, "table") then
            local x, y, z = getElementPosition(source)
            local x2, y2, z2 = getElementPosition(player)
            if getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) < 2 then
                if not (craft[player]) then 
                    return sendMessageServer(player, "Essa mesa não é sua!", "info")
                end
                if craft[player].object and isElement(craft[player].object) then
                    triggerClientEvent(player, "drawTable", resourceRoot, source)
                end
            end
        end
    end
end)

createEvent("onPlayerGiveMesaItem", resourceRoot, function (element, amount, index)
    if not (client or ( source ~= resourceRoot ) ) then 
        return false 
    end
    if not isElement(element) then 
        return false 
    end
    if not (element or not amount or not index) then 
        return false 
    end
    if (amount <= 0) then 
        return false 
    end
    local data = config["itens"][index]
    if not (data) then
        return false 
    end
    local hasBoolean, hasIndex, hasItem = isHaveItemTable(element)
    if (hasBoolean and hasItem ~= data["id"]) then 
        return sendMessageServer(client, "Você já está vendendo uma droga nessa mesa!", "info")
    end
    if (exports["guetto_inventory"]:getItem(client, data["id"]) < amount) then 
        return sendMessageServer(client, "Você não possui essa quantidade em sua mochila!", "error")
    end
    if (giveTableItem(element, data["id"], amount)) then
        exports["guetto_inventory"]:takeItem(client, data["id"], amount)
        sendMessageServer(client, "Droga adicionado com sucesso!", "success")
        triggerClientEvent(getElementsByType("player"), "createPed", resourceRoot, client, element)
    end
end)

createEvent("onPlayerTakeMesaItem", resourceRoot, function (element, amount, index)
    if not (client or ( source ~= resourceRoot ) ) then 
        return false 
    end
    if not isElement(element) then 
        return false 
    end
    if (amount <= 0) then 
        return false 
    end
    local data = config["itens"][index]
    if not (data) then
        return false 
    end
    
    if (getTableItem(element, data["id"]) < amount) then
        return sendMessageServer(client, "Você não possui essa quantidade na mesa!", "error")
    end

    if (takeTableItem(element, data["id"], amount)) then
        exports["guetto_inventory"]:giveItem(client, data["id"], amount)
        sendMessageServer(client, "Droga retirado com sucesso!", "success")
    end
end)

createEvent("onPlayerSaveTable", resourceRoot, function()
    if not (client or ( source ~= resourceRoot ) ) then 
        return false 
    end
    if not (isHavePlayerTable(client)) then
        return sendMessageServer(client, "Você não possui uma mesa!", "error")
    end
    local mesa = craft[client].object
  
    if not (isElement(mesa)) then
        return sendMessageServer(client, "Essa mesa não existe mais!", "error")
    end

    local itens = getElementData(mesa, "table.itens") or {}
    for i = 1, #itens do 
        if itens[i].amount > 0 then
            exports["guetto_inventory"]:giveItem(client, itens[i].item, itens[i].amount)
        end
    end

    destroyPlayerTable(client)
    exports["guetto_inventory"]:giveItem(client, config["id_mesa"], 1)
end)

createEvent("onPlayerAcceptProposal", resourceRoot, function (item, quantidade, mesa)
    if not (client or ( source ~= resourceRoot ) ) then 
        return false 
    end
    if not isElement(mesa) then
        return false
    end
    if (getTableItem(mesa, item["item"]) < quantidade) then 
        triggerClientEvent(client, "destroyPed", resourceRoot, client)
        return sendMessageServer(client, "Você não possui essa quantidade na sua mesa!", "error")
    end
    if (takeTableItem(mesa, item["item"], quantidade)) then
        local value = math.random(config["values"][item["item"]][1], config["values"][item["item"]][2])
        local random = math.random(#config["times"])

        setTimer(function(player)
            triggerClientEvent(getElementsByType("player"), "createPed", resourceRoot, player, mesa)
        end, config["times"][random], 1, client)

        exports["guetto_inventory"]:giveItem(client, config["id_dinheiro_sujo"], value * tonumber(quantidade))
        sendMessageServer(client, "Você vendeu a droga e recebeu R$ "..(formatNumber(value * tonumber(quantidade), '.')).." de dinheiro sujo!", "info")
    end
end)

createEvent("onPlayerCallServerRender", resourceRoot, function(player)
    if (player and isElement(player)) then 
        if (isHavePlayerTable(player)) then
            triggerClientEvent(player, "onDrawDialogue", resourceRoot, source)
        end
    end
end)

createEvent("onPlayerLeaveMesa", resourceRoot, function (player)
    if not (client or ( source ~= resourceRoot ) ) then 
        return false 
    end

    destroyPlayerTable(player)
    sendMessageServer(player, "Sua mesa foi destruida!", "info")
end)

createEvent("onPlayerServerNotification", resourceRoot, function (player, msg, type_message)

    if not (client or ( source ~= resourceRoot ) ) then 
        return false 
    end

    return sendMessageServer(player, msg, type_message)
end)