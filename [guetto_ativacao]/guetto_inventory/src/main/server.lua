local inventoryData = {}
local instance = {}

instance.connection = dbConnect('sqlite', 'assets/database/database.db');

instance["logs"] = {
    ["giveitem"] = "https://media.guilded.gg/webhooks/58481d12-85f2-444a-bbef-022da6a1c5c1/l3HqizNkzI2iaeSAKoKESMccWUwqYqQMwUEY20A4ueeKU2cQc8UygoqiKoMAYUks4ku0IiQSC8AsOCwmk0KmyM";
    ["takeitem"] = "https://media.guilded.gg/webhooks/7d2fcfdc-6144-4c86-93b1-efdd26a5b1e1/E7pXL4buSGW8kYsiQY6g0Mmac0MGeyQgsUY4akQcK84UKge2Aaqq2K6GK8QcO80I8iOyAssmWyUYwQK8gWCCMm";
}

-- \\ Command´s //

addCommandHandler("giveitem", function (player, cmd, id, item, amount)
    if not isPlayerHavePermission(player, config["commands_permissions"]["giveitem"]) then 
        return false
    end

    if not (id) then 
        return sendMessageServer(player, "Digite o id do jogador!", "error")
    end 

    if not (item) then 
        return sendMessageServer(player, "Digite o id do item!", "error")
    end

    if not (config["itens"][tonumber(item)]) then 
        return sendMessageServer(player, "Item não encontrado!", "error")
    end

    if not (amount) then 
        return sendMessageServer(player, "Digite a quantidade!", "error")
    end

    local target = getPlayerFromID (tonumber(id));
    
    if not target then 
        return sendMessageServer(player, 'Jogador não encontrado!', 'error')
    end

    if not (getPlayerSpaceItem(target, item, amount)) then 
        return sendMessageServer(player, 'O jogador não possui espaço suficiente para esse item!', 'error')
    end

    if (giveItem(target, item, amount)) then 

        sendMessageServer(player, 'Você givou o item '.. ( config["itens"][tonumber(item)].name ) ..' para o jogador '.. (getPlayerName(target)) ..' # '..(getElementData(target, 'ID') or 'N/A')..' ', 'info')
        sendMessageServer(target, 'Você recebeu o item '.. ( config["itens"][tonumber(item)].name ) ..' do jogador '.. (getPlayerName(player)) ..' # '..(getElementData(player, 'ID') or 'N/A')..' ', 'info')
    
        refreshClientInventory(target)
    end
end)

addCommandHandler("takeitem", function (player, cmd, id, item, amount)
    if not isPlayerHavePermission(player, config["commands_permissions"]["takeitem"]) then 
        return false
    end

    if not (id) then 
        return sendMessageServer(player, "Digite o id do jogador!", "error")
    end 

    if not (item) then 
        return sendMessageServer(player, "Digite o id do item!", "error")
    end

    if not (config["itens"][tonumber(item)]) then 
        return sendMessageServer(player, "Item não encontrado!", "error")
    end

    if not (amount) then 
        return sendMessageServer(player, "Digite a quantidade!", "error")
    end

    local target = getPlayerFromID (tonumber(id));
    
    if not target then 
        return sendMessageServer(player, 'Jogador não encontrado!', 'error')
    end

    if (getItem(target, item) == 0) then 
        return sendMessageServer(player, "Esse jogador não possui esse item!", "error")
    end

    if (takeItem(target, item, amount)) then 
        sendMessageServer(player, 'Você retirou o item '.. ( config["itens"][tonumber(item)].name ) ..' do jogador '.. (getPlayerName(target)) ..' # '..(getElementData(target, 'ID') or 'N/A')..' ', 'info')
        refreshClientInventory(target)
    end
end)

addCommandHandler("resetinv", function(player, cmd, id)
    if not isPlayerHavePermission(player, config["commands_permissions"]["takeitem"]) then 
        return false
    end

    if not (id) then 
        return sendMessageServer(player, "Digite o id do jogador!", "error")
    end 

    local target = getPlayerFromID (tonumber(id));
    
    if not target then 
        return sendMessageServer(player, 'Jogador não encontrado!', 'error')
    end 

    local account = getAccountName(getPlayerAccount(target));

    inventoryData[account] = {
        itens = {
            food = {},
            bag = {},
            ilegal = {},
        },
        hotbar = {'nil', 'nil', 'nil', 'nil', 'nil'},
        player = {actualWeight = 0, maxWeight = 100},
        slots = 10,
        ['enable-hotbar'] = true,
    }

    for i, v in ipairs (config['acls_slots_free']) do 
        if isPlayerHavePermission (target, v) then 
            inventoryData[account].slots = 20;
            break 
        end
    end

    refreshClientInventory(target)
    sendMessageServer(player, 'O inventário foi resetado para o jogador '.. (getPlayerName(target)) ..' # '..(getElementData(target, 'ID') or 'N/A')..' ', 'info')
    sendMessageServer(target, 'O inventário foi resetado por '.. (getPlayerName(player)) ..' # '..(getElementData(player, 'ID') or 'N/A')..' ', 'info')
    dbExec(instance.connection, "UPDATE `Inventory` SET `Inventory` = ? WHERE `Account` = ?", toJSON(inventoryData[account].itens), account)
end)


-- \\ Function´s // 
function loadInventory ( player )
    if not (player) then 
        return false 
    end

    if isGuestAccount(getPlayerAccount(player)) then 
        return false 
    end

    local account = getAccountName ( getPlayerAccount (player) )
    local result = dbPoll(dbQuery(instance.connection, 'SELECT * FROM `Inventory` WHERE `Account` = ?', account), - 1)

    if #result ~= 0 then 
        inventoryData[account] = {
            itens = fromJSON(result[1].Inventory),
            slots = 10,
            hotbar = fromJSON(result[1]['Inventory-HotBar']),
            player = fromJSON(result[1]['Inventory-Player']),
            ['enable-hotbar'] = result[1]['Inventory-Enable-Hotbar'],
        }

    else
        inventoryData[account] = {
            itens = {
                food = {},
                bag = {},
                ilegal = {},
            },
            hotbar = {'nil', 'nil', 'nil', 'nil', 'nil'},
            player = {actualWeight = 0, maxWeight = 100},
            slots = 10,
            ['enable-hotbar'] = true,
        }
        dbExec(instance.connection, 'INSERT INTO `Inventory` VALUES ( ?, ?, ?, ?, ? )', account, 'true', toJSON(inventoryData[account].hotbar), toJSON(inventoryData[account].player), toJSON(inventoryData[account].itens))
    end

    for i, v in ipairs (config['acls_slots_free']) do 
        if isPlayerHavePermission (player, v) then 
            inventoryData[account].slots = 20;
            break 
        end
    end

end

addEventHandler('onPlayerQuit', root, function ( )
    givePlayerMuni(source)
end)

function getPlayerInventoryWeight (player)
    if not (player) then 
        return false 
    end

    local inventory = getPlayerInventory (player)
    local consumed, max_consumed = inventory.player.actualWeight, inventory.player.maxWeight

    return consumed, max_consumed
end

function savePlayerInventory (player)
    if not (player) then 
        return false 
    end

    local account = getAccountName ( getPlayerAccount (player) )
    local inventory = getPlayerInventory (player)

    if not ( inventory ) then 
        return false 
    end

    dbExec(instance.connection, 'UPDATE `Inventory` SET `Inventory` = ?, `Inventory-Enable-Hotbar` = ?, `Inventory-Player` = ?, `Inventory-HotBar` = ? WHERE `Account` = ?', toJSON(inventory.itens), inventory['enable-hotbar'], toJSON(inventory.player), toJSON(inventory.hotbar),  account)
end

function getPlayerSpaceItem (player, item, amount)
    if not (player) then 
        return print ('Inventory_System Error: Player is not defined!')
    end

    if not (item) then 
        return print ('Inventory_System Error: Item is not defined!')
    end

    if not (amount) then 
        return print ('Inventory_System Error: Amount is not defined!')
    end

    local inventory = getPlayerInventory (player)
    local settings = config.itens[tonumber(item)]
    local amount = tonumber(amount)
    local consumed, max_consumed = inventory.player.actualWeight, inventory.player.maxWeight
    
    if consumed + settings.weight * amount > max_consumed then 
        return false 
    end

    return true
end

function giveItem (player, item, amount)
    if not (player) then 
        return print ('Inventory_System Error: Player is not defined!')
    end

    if not (item) then 
        return print ('Inventory_System Error: Item is not defined!')
    end

    if not (amount) then 
        return print ('Inventory_System Error: Amount is not defined!')
    end

    local quantidade, index = getItem (player, item)
    local account = getAccountName(getPlayerAccount(player));
    local settings = config.itens[tonumber(item)]
    
    if not (settings) then 
        return print ('guetto_inventory item not exists!')
    end

    if not (getPlayerSpaceItem(player, tonumber(item), tonumber(amount))) then 
        return sendMessageServer(player, "Você não possui espaço suficiente na mochila para esse item!", "error")
    end

    if ( quantidade == 0 ) then 
        inventoryData[account].itens[settings.category][#inventoryData[account].itens[settings.category] + 1] = {
            item = tonumber(item), 
            slot = createInventorySlot(player, item),
            amount = tonumber(amount)
        }
    else
        inventoryData[account].itens[settings.category][index].amount = inventoryData[account].itens[settings.category][index].amount + tonumber(amount)
    end

    inventoryData[account].player.actualWeight = math.floor(inventoryData[account].player.actualWeight + (settings.weight * tonumber(amount)))
 
    local title = 'Guetto Inventory | Novo Item Givado'
    local description = 'Um jogador recebeu um item em seu inventário'

    local logs = {
        { name = '👩‍💻・Jogador', value = getPlayerName(player).."#"..(getElementData(player, "ID") or "N/A"), inline = false },
        { name = '⚙️・Serial', value = getPlayerSerial(player), inline = false },
        { name = '🔮・IP', value = getPlayerIP(player), inline = false },
        { name = '🎁・Item', value = config["itens"][tonumber(item)]["name"].."📦・ID:"..tonumber(item), inline = false },
        { name = '📌・Quantidade', value = amount, inline = false },

    }

    sendLogs (title, description, logs, instance["logs"]["giveitem"])

    savePlayerInventory(player)
    refreshClientInventory(player)
    return true
end

function takeItem (player, item, amount)
    if not (player) then 
        return print ('Inventory_System Error: Player is not defined!')
    end

    if not (item) then 
        return print ('Inventory_System Error: Item is not defined!')
    end

    if not (amount) then 
        return print ('Inventory_System Error: Amount is not defined!')
    end

    local quantidade, index = getItem (player, item)
    local account = getAccountName(getPlayerAccount(player));
    local settings = config.itens[tonumber(item)]

    if not (settings) then 
        return false
    end

    if weapons[tonumber(item)] then 
        local player_weapons = getPedWeapons(player) 
        if #player_weapons ~= 0 then 
            for i = 1, #player_weapons do 
                local v = player_weapons[i]
                if config["weapons"]["weapons_primary"][tonumber(item)] == v then 
                    givePlayerMuni(player)
                    takeWeapon(player, config["weapons"]["weapons_primary"][tonumber(item)])
                    break
                end
                if config["weapons"]["weapons_secondarys"][tonumber(item)] == v then 
                    givePlayerMuni(player)
                    takeWeapon(player, config["weapons"]["weapons_secondarys"][tonumber(item)])
                    break 
                end
            end
        end
    end

    if (quantidade == 0) then 
        return false 
    end

    if (quantidade - amount <= 0) then 
        table.remove(inventoryData[account].itens[settings.category], index)
    else
        inventoryData[account].itens[settings.category][index].amount = inventoryData[account].itens[settings.category][index].amount - tonumber(amount)
    end

    inventoryData[account].player.actualWeight = math.floor(inventoryData[account].player.actualWeight - (settings.weight * tonumber(amount)))

    if (inventoryData[account].player.actualWeight < 0) then 
        inventoryData[account].player.actualWeight = 0 
    end

    local bool, index = getItemHotBar (player, tonumber(item))

    if bool then 
        if (quantidade - amount <= 0) then 
            inventoryData[account]['hotbar'][index] = 'nil'
        end
    end
     
    local title = 'Guetto Inventory | Novo Item Retirado'
    local description = 'Um item do inventário do jogador foi removido'

    local logs = {
        { name = '👩‍💻・Jogador', value = getPlayerName(player).."#"..(getElementData(player, "ID") or "N/A"), inline = false },
        { name = '⚙️・Serial', value = getPlayerSerial(player), inline = false },
        { name = '🔮・IP', value = getPlayerIP(player), inline = false },
        { name = '🎁・Item', value = config["itens"][tonumber(item)]["name"].."📦・ID:"..tonumber(item), inline = false },
        { name = '📌・Quantidade', value = amount, inline = false },

    }

    sendLogs (title, description, logs, instance["logs"]["takeitem"])

    savePlayerInventory(player)
    refreshClientInventory(player)
    return true
end

function refreshClientInventory (player)
    if not (player) then 
        return false 
    end
    local account = getAccountName ( getPlayerAccount (player) )
    return triggerClientEvent(player, "inventoryClientUpdate", resourceRoot, inventoryData[account] or {
        itens = {},
        slots = 10
    })
end

function getPlayerInventory (player)
    if not (player) then 
        return false 
    end

    local account = getAccountName ( getPlayerAccount (player) )

    return inventoryData[account] or {
        itens = {},
        slots = 10
    }
end

function getItemHotBar (player, item)

    if not (player) then 
        return print ('Inventory_System Error: Player is not defined!')
    end

    if not (item) then 
        return print ('Inventory_System Error: Item is not defined!')
    end

    local inventory = getPlayerInventory (player)
    
    if not inventory then 
        return false 
    end

    for i, v in ipairs (inventory.hotbar) do 
        if (v ~= 'nil' and tonumber(item) == tonumber(v)) then 
            return true, i 
        end
    end

    return false
end

function getItem (player, item)

    if not (player or item) then 
        return 0 
    end

    local inventory = getPlayerInventory (player)
    
    if not (inventory) then 
        return 0 
    end

    local settings = config.itens[tonumber(item)]

    for index = 1,  #inventory.itens[settings.category] do 
        if inventory.itens[settings.category][index].item == tonumber(item) then 
            return inventory.itens[settings.category][index].amount, index 
        end
    end

    return 0
end

createInventorySlot = function (player, item)
    if not player or not item then 
        return 0
    end;
    local account = getAccountName(getPlayerAccount(player));
    local inventory = getPlayerInventory (player)
    local settings = config.itens[tonumber(item)]
    for i = 1, inventory.slots+20 do 
        local slotFree = true 
        for key = 1, table.getn(inventory.itens[settings.category]) do 
            local v = inventory.itens[settings.category][key];
            if v.slot == i then 
                slotFree = false 
            end
        end
        if slotFree == true then 
            return i 
        end
    end
end;

-- \\ Event´s //

createEventHandler("inventoryRequestItens", resourceRoot, function ( )  

    if not (client or ( source ~= resourceRoot ) ) then 
        return false 
    end;

    if (isGuestAccount(getPlayerAccount(client))) then 
        return false 
    end

    refreshClientInventory (client)
end)

addEventHandler('onResourceStop', resourceRoot, function()
    for index, value in ipairs (getElementsByType('player')) do 
        savePlayerInventory(value)
    end
end)

createEventHandler("inventoryUpdateClient", resourceRoot, function (inv)
    if not (client or ( source ~= resourceRoot )) then 
        return false 
    end

    local account = getAccountName(getPlayerAccount(client));
    inventoryData[account] = inv;
end)


addEventHandler('onPlayerLogin', root, function ( )
    loadInventory(source)
end)

addEventHandler("onPlayerWasted", root, function()
    if not source or not isElement(source) then 
        return false;
    end;

    if isGuestAccount(getPlayerAccount(source)) then 
        return false;
    end;

    local inventory = getPlayerInventory(source);

    for i, v in pairs(inventory.itens) do 
        for index = #inventory.itens[i], 1, - 1 do 
            if inventory.itens[i] and inventory.itens[i][index] and config["itens"][inventory.itens[i][index].item] then 
                if config["itens"][inventory.itens[i][index].item].others.perder == true then 
                    takeItem(source, inventory.itens[i][index].item, inventory.itens[i][index].amount)
                end
            end
        end
    end
end)


-- \\ Resource starter // 

addEventHandler('onResourceStart', resourceRoot, 
    function ( )

        if not instance.connection then 
            return print ( 'Houve uma falha ao tentar se conectar com o banco de dados!')
        end

        dbExec(instance.connection, [[CREATE TABLE IF NOT EXISTS `Inventory` (`Account` TEXT NOT NULL, `Inventory-Enable-Hotbar` TEXT, `Inventory-HotBar` JSON NOT NULL, `Inventory-Player` JSON NOT NULL, `Inventory` JSON NOT NULL) ]])
        
        for index, value in ipairs (getElementsByType('player')) do 
            loadInventory (value)
        end

        print ('Database is connected!')
    end
)
