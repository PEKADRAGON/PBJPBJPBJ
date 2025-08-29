-- Var´s 

local acess = { }
local fic_id = 0;

local database = dbConnect("sqlite", "src/database/database.db");
dbExec(database, 'CREATE TABLE IF NOT EXISTS PortaMalas(ID INTEGER, Itens JSON NOT NULL)')

for i, v in ipairs(getElementsByType('vehicle')) do 
    setElementData(v, 'Matteo.OccupiedVehicle', false)
end

local select_new_id = dbPoll(dbQuery(database, 'SELECT * FROM `PortaMalas` '), -1)
if #select_new_id ~= 0 then 
    fic_id = #select_new_id
end

-- Func´s 

giveItem = function (element, item, amount, player)
    if element and item and amount and player then 
        local item, amount = tonumber(item), tonumber(amount)
        if amount <= 0 then return config.sendMessageServer(player, "Coloque apenas quantidades positivas!", "error") end 
        if exports["guetto_inventory"]:getConfigItem(item) then 
            local id = getElementData(element, "Guh.VehicleID") or false 
            if not id then return false end

            if not (isVehicleFreeSpaceFromItem(element, item, amount)) then 
                return config.sendMessageServer(player, 'Esse veículo não possui espaço suficiente!', 'error') 
            end

            local malas_query = dbPoll(dbQuery(database, "SELECT * FROM `PortaMalas` WHERE `ID` = ?", id), -1)
            if #malas_query == 0 then 
                dbExec(database, "INSERT INTO `PortaMalas` VALUES (?, ?)", getElementData(element, "Guh.VehicleID"), toJSON({itens = {}, data = {actualWeight = 0, maxWeight = 150}}))
                malas_query = dbPoll(dbQuery(database, "SELECT * FROM `PortaMalas` WHERE `ID` = ?", id), -1)
            end
            local Itens = fromJSON(malas_query[1].Itens)
            local data = Itens.data
            local itens = Itens.itens
            local qnt, index = getItem(element, tonumber(item))
            local dataItem = exports["guetto_inventory"]:getConfigItem(item)
            if dataItem.others.enviar == false then return config.sendMessageServer(player, 'Você não pode guardar esse item no porta-malas!', 'error') end
            if qnt == 0 then 
                table.insert(itens, {
                    item = item, 
                    amount = amount,
                    slot = createInventorySlot(element, item),
                })
            else 
                itens[index].amount = itens[index].amount + amount
            end
            data.actualWeight = data.actualWeight + (dataItem.weight * amount)
            dbExec(database, "UPDATE `PortaMalas` SET `Itens` = ? WHERE `ID` = ?", toJSON({itens = itens, data = data}), id)
            refreshClientInventory(player, element)
        end
    end
end

takeItem = function (element, item, quantity, player)
    if not element or not isElement(element) or not item or not quantity then
        return false
    end

    local id = getElementData(element, "Guh.VehicleID") or false

    if tonumber(quantity) <= 0 then return config.sendMessageServer(player, "Coloque apenas quantidades positivas!", "error") end 

    if not id then 
        return false
    end

    local malas_query = dbPoll(dbQuery(database, "SELECT * FROM `PortaMalas` WHERE `ID` = ?", id), -1)
    if #malas_query == 0 then 
        return false
    end

    local Itens = fromJSON(malas_query[1].Itens)
    local data = Itens.data
    local itens = Itens.itens
    local amount, index = getItem(element, tonumber(item))

    local dataItem = exports["guetto_inventory"]:getConfigItem(item)
    local newAmount = amount - tonumber(quantity)

    if dataItem.others.enviar == false then 
        return config.sendMessageServer(player, 'Você não pode guardar esse item no porta-malas!', 'error') 
    end

    if newAmount <= 0 then 
        table.remove(itens, index)
    else
        itens[index].amount = newAmount
    end
    
    data.actualWeight = math.max(0, data.actualWeight - dataItem.weight * quantity)
    dbExec(database, "UPDATE `PortaMalas` SET `Itens` = ? WHERE `ID` = ?", toJSON({itens = itens, data = data}), id)
    refreshClientInventory(player, element)
end

getItem = function (element, item)
    local id = getElementData(element, "Guh.VehicleID") or false
    if not id then 
        return 0
    end

    local malas_query = dbPoll(dbQuery(database, "SELECT * FROM `PortaMalas` WHERE `ID` = ?", id), -1)
    if #malas_query == 0 then 
        return 0
    end

    local Itens = fromJSON(malas_query[1].Itens)
    local itens = Itens.itens

    for i, v in ipairs(itens) do 
        if v.item == item then 
            return v.amount, i
        end
    end

    return 0
end

function isVehicleFreeSpaceFromItem (vehicle, item, amount)
    if not vehicle or not isElement(vehicle) or not item or not amount then
        return false 
    end

    if getElementType(vehicle) ~= 'vehicle' then 
        return false 
    end

    local id = getElementData(vehicle, "Guh.VehicleID") or false
    
    if not id then 
        return false 
    end

    local malas_query = dbPoll(dbQuery(database, "SELECT * FROM `PortaMalas` WHERE `ID` = ?", id), -1)

    if #malas_query == 0 then 
        return false 
    end

    local Itens = fromJSON(malas_query[1].Itens)
    local data = Itens.data
    local amount = tonumber(amount);
    local dataItem = exports["guetto_inventory"]:getConfigItem(item)
    
    if data.actualWeight + (dataItem.weight * amount) > data.maxWeight then
        return false 
    end

    return true
end

createInventorySlot = function (element, item)
    local id = getElementData(element, "Guh.VehicleID") or false
    if not id then 
        return false
    end

    local malas_query = dbPoll(dbQuery(database, "SELECT * FROM `PortaMalas` WHERE `ID` = ?", id), -1)
    if #malas_query == 0 then 
        return false
    end

    local Itens = fromJSON(malas_query[1].Itens)
    local itens = Itens.itens

    for i = 1, 20 do 
        local slotFree = true 
        for _, v in ipairs(itens) do 
            if v.slot == i then 
                slotFree = false
                break
            end
        end
        if slotFree then 
            return i 
        end
    end
end

refreshClientInventory = function (player, element)
    local id = getElementData(element, "Guh.VehicleID") or false
    if not id then 
        return false
    end

    local malas_query = dbPoll(dbQuery(database, "SELECT * FROM `PortaMalas` WHERE `ID` = ?", id), -1)
    if #malas_query == 0 then 
        return false
    end

    local inventory = exports["guetto_inventory"]:getPlayerInventory(player)
    triggerClientEvent(player, "guetto.client.update.malas", resourceRoot, fromJSON(malas_query[1].Itens), inventory, element)
end

-- Event´s 

registerEventHandler("guetto.moveItem", resourceRoot, function (player, type, item, qnt, veh)
    if player and isElement(player) then 
        if type == "inv" then 
            if exports['guetto_inventory']:getItem(player, item) == 0 then 
                return config.sendMessageServer(player, 'Você não possui esse item em seu inventário!', 'error')
            end

            if not tonumber(qnt) then 
                return false 
            end

            if (tonumber(qnt) <= 0) then 
                return false 
            end

            local dataItem = exports["guetto_inventory"]:getConfigItem(item)
            if dataItem.others.enviar == false then return config.sendMessageServer(player, 'Você não pode guardar esse item no porta-malas!', 'error') end

            if not (isVehicleFreeSpaceFromItem(veh, item, qnt)) then 
                return config.sendMessageServer(player, 'Esse veículo não possui espaço suficiente!', 'error') 
            end

            exports["guetto_inventory"]:takeItem(player, item, qnt)
            giveItem(veh, item, qnt, player)
        elseif type == "malas" then 
            if getItem(veh, item) == 0 then 
                return config.sendMessageServer(player, 'O porta-malas não possui essa quantidade!', 'error')
            end

            if not tonumber(qnt) then 
                return false 
            end
            
            if (tonumber(qnt) <= 0) then 
                return false 
            end

            local dataItem = exports["guetto_inventory"]:getConfigItem(item)
            if dataItem.others.enviar == false then return config.sendMessageServer(player, 'Você não pode retirar esse item do porta-malas!', 'error') end

            local actual = exports['guetto_inventory']:getPlayerSpaceItem(player, item, tonumber(qnt))

            if not actual then 
                return config.sendMessageServer(player, 'Você não possui espaço para esse item!', 'error')
            end

            exports["guetto_inventory"]:giveItem(player, item, qnt)
            takeItem(veh, item, qnt, player)
        end
    end
end)

addEvent("onPlayerOpenMalas", true)
addEventHandler("onPlayerOpenMalas", root, function ( player, vehicle ) 
    if vehicle and isElement(vehicle) and getElementType(vehicle) == 'vehicle' then 
        local x, y, z = getElementPosition(player)
        local ox, oy, oz = getElementPosition(vehicle)
        if getDistanceBetweenPoints3D(x, y, z, ox, oy, oz) <= 5 then 
            if isPedInVehicle(player) then 
                return config.sendMessageServer(player, "Você não pode abrir o porta malas dentro de um veículo!", "error")
            end

            if config["Blacklist"][getElementModel(vehicle)] then 
                return config.sendMessageServer(player, "Esse veículo não possui porta-malas!", "error")
            end

            if not getElementData(vehicle, "Guh.VehicleID") then 
                local select_new_id = dbPoll(dbQuery(database, 'SELECT * FROM `PortaMalas` '), -1)
                if #select_new_id ~= 0 then 
                    fic_id = #select_new_id + 1
                    setElementData(vehicle, "Guh.VehicleID", fic_id)
                end

            end

            if getElementData(vehicle, "Matteo.OccupiedVehicle") then 
                return config.sendMessageServer(player, "Esse veículo já está sendo acessado!", "error")
            end

            if isVehicleLocked(vehicle) then 
                return config.sendMessageServer(player, "Você não pode abrir o porta malas com o veículo trancado!", "error")
            end

            if getElementData(player, "guetto.open.inventory") == true then 
                return config.sendMessageServer(player, "Você não pode abrir o porta malas com o inventário aberto!", "error")
            end

            setElementData(vehicle, "Matteo.OccupiedVehicle", player)

            local malas_query = dbPoll(dbQuery(database, "SELECT * FROM `PortaMalas` WHERE `ID` = ?", getElementData(vehicle, "Guh.VehicleID")), -1)
            if #malas_query == 0 then 
                local peso = getElementModel(vehicle) == 456 and 2000 or 150
                dbExec(database, "INSERT INTO `PortaMalas` VALUES (?, ?)", getElementData(vehicle, "Guh.VehicleID"), toJSON({itens = {}, data = {actualWeight = 0, maxWeight = peso}}))
                malas_query = dbPoll(dbQuery(database, "SELECT * FROM `PortaMalas` WHERE `ID` = ?", getElementData(vehicle, "Guh.VehicleID")), -1)
            end

            local inventory = exports["guetto_inventory"]:getPlayerInventory(player)
            triggerClientEvent(player, "guetto.draw.malas", resourceRoot, fromJSON(malas_query[1].Itens), inventory, vehicle)
        end
    end
end)


registerEventHandler("guetto.malas.close", resourceRoot, function (player, vehicle)
    setElementData(vehicle, "Matteo.OccupiedVehicle", false)
end)

function getPlayerFromID(id)
    if not id then 
        return false 
    end
    local result = false 
    for i = 1, #getElementsByType('player') do 
        local v = getElementsByType('player')[i]
        if getElementData(v, 'ID') == tonumber(id) then 
            result = v 
        end
    end
    return result
end
