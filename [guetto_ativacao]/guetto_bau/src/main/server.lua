local db = dbConnect("sqlite", "src/database/dados.db");

local weapons = {
    [5] = 22;
    [6] = 24;
    [7] = 31;
    [8] = 30;
    [9] = 29;
    [10] = 34;
    [11] = 25
}

local chests = {}
local id_chest = {}

addEventHandler('onResourceStart', resourceRoot,
function ( )
        if (db and isElement(db)) then 
            dbExec(db, 'CREATE TABLE IF NOT EXISTS `chests` (id INTEGER PRIMARY KEY AUTOINCREMENT, `acl` TEXT NOT NULL, `senha` TEXT NOT NULL, `pos` JSON NOT NULL, `hook` TEXT NOT NULL, `peso` JSON NOT NULL, `itens` JSON NOT NULL, `leader` TEXT NOT NULL )')
            print(" "..getResourceName(getThisResource()).." iniciado!")
        end
    end
)

local text_key_input = [[--------------------
**ENVIO**
**Jogador:** ${nome}
**ID Jogador: ${id} **
**ACL:** ${acl}
**Item Enviado:** ${item} 
--------------------]]

local text_key_take = [[--------------------
**RETIRADA**
**Jogador:** ${nome}
**ID Jogador: ${id} **
**ACL:** ${acl}
**Item Retirado:** ${item} 
--------------------]]

function createChestHouse (x, y, z, rx, ry, rz, int, dim, capacity, senha)
    dbExec(db, 'INSERT INTO chests (acl, senha, pos, hook, peso, itens) VALUES(?, ?, ?, ?, ?, ?)', 'Everyone', senha, toJSON({x, y, z, rx, ry, rz, int, dim}), 'https://discord.com/api/webhooks/1245529886152724550/M-IqnceeKWqoj2_wjGHgzsgp33Dgc3uCXSr9eCQUDNhYA47atnJeCp8d2zkuQoP29JlO', toJSON({actual = 0, capacity = capacity}), toJSON({}))
    local resquested_id = dbPoll(dbQuery(db, 'Select * from chests ORDER BY id DESC'), - 1)
    createChest({x, y, z, rx, ry, rz, int, dim}, resquested_id[1]['id'], tonumber(capacity), {})
    return resquested_id[1]['id'] or false 
end

addCommandHandler('createbau', 
    function ( player, cmd, acl, senha, peso, hook, leader )
        if getPlayerAcl(player, 'Console') then 
            
            if not acl then 
                return sendMessageServer(player, 'Digite um acl!', 'error')
            end
            
            if not senha then 
                return sendMessageServer(player, 'Digite uma senha!', 'error')
            end
            
            if not peso then 
                return sendMessageServer(player, 'Digite um peso!', 'error')
            end

            if not hook then 
                return sendMessageServer(player, 'Digite um webhook!', 'error')
            end

            if not leader then 
                return sendMessageServer(player, '1 Para bau de lider ou 0 para bau de membros!', 'error')
            end

            addChest(player, acl, senha, peso, hook, tostring(leader))
        end
        
    end
)

addCommandHandler('mudarhook',
    function ( player, cmd, id, hook )
        if getPlayerAcl(player, 'Console') then 
            
            if not id then 
                return sendMessageServer(player, 'Digite o id do baú!', 'error')
            end

            if not hook then 
                return sendMessageServer(player, 'Digite um webhook!', 'error')
            end

            local chest = getChestByID(tonumber(id))
            
            if (isElement(chest)) then 
                dbExec(db, 'Update chests set hook = ? where id = ?', hook, tonumber(id))
                sendMessageServer(player, 'Você alterou a webhook!', 'info')
            else 
                sendMessageServer(player, 'Bau não encontrado!', 'error')
            end

        end

    end
)

addCommandHandler('mudarleaderbau', 
    function (player, cmd, id, state)
        if getPlayerAcl(player, 'Console') then 
            
            if not id then 
                return sendMessageServer(player, 'Digite o id do baú!', 'error')
            end

            if not state then 
                return sendMessageServer(player, 'Digite 0 para baú de membro, 1 para baú de lider!', 'info')
            end

            local chest = getChestByID(tonumber(id))

            if (isElement(chest)) then 
                dbExec(db, 'Update chests set leader = ? where id = ?', state, tonumber(id))
                sendMessageServer(player, 'Você alterou a liderança do baú!', 'info')
            else 
                sendMessageServer(player, 'Bau não encontrado!', 'error')
            end

        end
    end
)

addCommandHandler('mudaraclbau', 
    function ( player, cmd, id, acl )
        if getPlayerAcl(player, 'Console') then 
            if not (id) then return sendMessageServer(player, 'Digite o id do baú!', 'error') end 
            if not (acl) then return sendMessageServer(player, 'Digite a nova acl do baú!', 'error') end 
            local chest = getChestByID(tonumber(id))
            if (isElement(chest)) then 
                dbExec(db, 'Update chests set acl = ? where id = ?', acl, tonumber(id))
                sendMessageServer(player, 'Você alterou a acl do baú!', 'info')
            end
        end
    end
)

addCommandHandler('moverbau', 
    function(player, _, id)
        if getPlayerAcl(player, 'Console') then 
            if (tonumber(id)) then 
                local chest = getChestByID(tonumber(id))
                if (isElement(chest)) then 
                    local x, y, z = getElementPosition(player)
                    local rx, ry, rz = getElementRotation(player)
                    local position = {x, y, z - 1, rx, ry, rz, getElementInterior(player), getElementDimension(player)}   
                    setElementPosition(chest, position[1], position[2], position[3])
                    setElementRotation(chest, position[4], position[5], position[6])
                    setElementInterior(chest, position[7])
                    setElementDimension(chest, position[8])
                    dbExec(db, 'Update chests set pos = ? where id = ?', toJSON(position), tonumber(id))
                    sendMessageServer(player, 'Posição do bau alterada!', 'success')
                else 
                    sendMessageServer(player, 'Bau não encontrado!', 'error')
                end
            else
                sendMessageServer(player, 'Sintax: /moverbau id')
            end
        end
    end
)

addCommandHandler('veridbau', 
    function(player)
        if getPlayerAcl(player, 'Console') then 
            local chest = getNearChest(player)
            if (isElement(chest)) then 
                sendMessageServer(player, 'ID do baú proximo: '..id_chest[chest], 'info')
            else 
                sendMessageServer(player, 'Nenhum bau perto de você!', 'error')
            end
        end
    end
)

addCommandHandler('givebauitem',
    function ( player, _, id, item, quantidade )
        if getPlayerAcl(player, 'Console') then 
            if not id then return sendMessageServer(player, 'Digite o id do baú!', 'error') end 
            if not item then return sendMessageServer(player, 'Digite o id do item!', 'error') end 
            local chest = getChestByID(tonumber(id))
            if (isElement(chest)) then 
                if (giveItem(id, item, quantidade)) then 
                    sendMessageServer(player, 'Você colocou o item no baú!', 'success')
                else
                    sendMessageServer(player, 'O baú não tem espaço para essa capacidade de itens!', 'error') 
                end
            end
            if not quantidade then return sendMessageServer(player, 'Digite a quantidade do item!', 'error') end 
        end 
    end
)

addCommandHandler('takebauitem',
    function ( player, _, id, item, quantidade )
        if getPlayerAcl(player, 'Console') then 
            if not id then return sendMessageServer(player, 'Digite o id do baú!', 'error') end 
            if not item then return sendMessageServer(player, 'Digite o id do item!', 'error') end 
            local chest = getChestByID(tonumber(id))
            if (isElement(chest)) then 
                if (takeItem(id, item, quantidade)) then 
                    sendMessageServer(player, 'Você retirou o item no baú!', 'success')
                else
                    sendMessageServer(player, 'Houve uma falha!', 'error') 
                end
            end
            if not quantidade then return sendMessageServer(player, 'Digite a quantidade do item!', 'error') end 
        end 
    end
)

addCommandHandler('setbaupeso', function ( player, _, id, peso )
        if getPlayerAcl(player, 'Console') then 
            if not id then return sendMessageServer(player, 'Digite o id do baú!', 'error') end 
            if not peso then return sendMessageServer(player, 'Digite o novo peso do báu!', 'error') end 
            local chest = getChestByID(tonumber(id))
            if (isElement(chest)) then
                local data_chest = dbPoll(dbQuery(db, 'Select * from chests where id = ?', tonumber(id)), - 1)
                if #data_chest ~= 0 then 
                    local data = fromJSON(data_chest[1].peso)
                    dbExec(db, 'Update chests set peso = ? where id = ?', toJSON({actual = data.actual, capacity = data.capacity + tonumber(peso)}), id) 
                    sendMessageServer(player, 'Você alterou o peso do baú!', 'info') 
                end
            else
                sendMessageServer(player, 'Não foi possível achar o baú!', 'error') 
            end
        end
    end
)

addCommandHandler('limparbau', 
    function(player)
        if getPlayerAcl(player, 'Console') then 
            local chest = getNearChest(player)
            if (isElement(chest)) then 
                dbExec(db, 'Update chests set itens = ? where id = ?', toJSON({}), id_chest[chest]) 
                sendMessageServer(player, 'Baú limpo com sucesso!', 'success')
            else 
                sendMessageServer(player, 'Você não está perto de nenhum baú!', 'error')
            end
        end 
    end
)

addCommandHandler('mudarsenhabau', 
    function(player, _, password) 
        if getPlayerAcl(player, 'Console') then 
            local chest = getNearChest(player)
            if (isElement(chest)) then 
                if (password) then 
                    dbExec(db, 'Update chests set senha = ? where id = ?', password, id_chest[chest]) 
                    sendMessageServer(player, 'Senha do baú alterada com sucesso!', 'success')
                else
                    sendMessageServer(player, 'Digite uma senha!', 'error')
                end
            else 
                sendMessageServer(player, 'Você não está perto de nenhum baú!', 'error')
            end 
        end
    end
)


addCommandHandler('versenhabau', 
    function(player, _, id) 
        if getPlayerAcl(player, 'Console') then 
            local chest = getNearChest(player)
            if (isElement(chest)) then 
                if (id) then 
                    local query = dbPoll(dbQuery(db, 'select * from `chests` where `id` = ?', tonumber(id)), -1)
                    if #query ~= 0 then 
                        sendMessageServer(player, 'Senha do baú: '..(query[1]['senha'])..' !', 'success')
                    else
                        sendMessageServer(player, 'Baú não encontrado!', 'error')
                    end
                else
                    sendMessageServer(player, 'Digite uma o ID do bau!', 'error')
                end
            else 
                sendMessageServer(player, 'Você não está perto de nenhum baú!', 'error')
            end 
        end
    end
)


addCommandHandler('deletebau', 
    function(player)
        if getPlayerAcl(player, 'Console') then 
            local chest = getNearChest(player)
            if (isElement(chest)) then 
                dbExec(db, 'Delete from chests where id = ?', id_chest[chest]) 
                destroyElement(chest) 
                sendMessageServer(player, 'Baú destruido com sucesso!', 'success')
            else 
                sendMessageServer(player, 'Você não está perto de nenhum baú!', 'error')
            end 
        end
    end
)

function addChest (player, acl, senha, peso, hook, leader)

    local x, y, z = getElementPosition(player)
    local rx, ry, rz = getElementRotation(player)
    local position = {x, y, z - 1, rx, ry, rz, getElementInterior(player), getElementDimension(player)}  
    
    setElementPosition(player, x + 1, y, z)
    dbExec(db, 'Insert into chests (acl, senha, pos, hook, peso, itens, leader) VALUES(?, ?, ?, ?, ?, ?, ?)', acl, senha, toJSON(position), hook, toJSON({actual = 0, capacity = tonumber(peso)}), toJSON({}), leader)

    local resquested_id = dbPoll(dbQuery(db, 'Select * from chests ORDER BY id DESC'), - 1)
    
    createChest(position, resquested_id[1]['id'], tonumber(peso), {})

    sendMessageServer(player, 'Você criou o bau da acl '.. (acl) ..'!', 'success')
end

local chests_opend = {}

function createChest(position, id, capacity, inventory_) 
    chests[id] = createObject(964, position[1], position[2], position[3], position[4], position[5], position[6])
    id_chest[chests[id]] = id 

    setElementInterior(chests[id], position[7])
    setElementDimension(chests[id], position[8])
    
    setElementData(chests[id], 'bag.capacity', capacity)

    addEventHandler('onElementClicked', chests[id], 
        function(b, s, player) 
            if (b == 'left' and s == 'down') then 
                local pos_player = {getElementPosition(player)} 
                local pos_chest = {getElementPosition(source)}
                if (getDistanceBetweenPoints3D(pos_player[1], pos_player[2], pos_player[3], pos_chest[1], pos_chest[2], pos_chest[3]) <= 4) then 
                    local data_chest = dbPoll(dbQuery(db, 'Select * from chests where id = ?', id), - 1)
                    if (not getElementData(player, 'weapon.equipped')) then 
                        if not (getElementData(player, 'chest.open')) then 
                            if (#data_chest == 0) then return end 
                            if data_chest[1]['acl'] and aclGetGroup(data_chest[1]['acl']) then 
                                if (isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(player)), aclGetGroup(data_chest[1]['acl']))) then
                                    if not (chests_opend[source]) then 
                                        local consummed, max = exports['guetto_inventory']:getPlayerInventoryWeight(player)
                                        local inventory_player = exports['guetto_inventory']:getPlayerInventory(player)
            
                                        local inventory_chest = getInventoryChest(tonumber(id))
                                        local consumed_chest, max_chest = getWeights(tonumber(id))
            
                                        triggerClientEvent(player, 'onClientDrawChest', resourceRoot, data_chest[1]['id'], data_chest[1]['senha'], inventory_player, {consummed, max}, inventory_chest, {consumed_chest, max_chest}, source)
                                        chests_opend[source] = player
                                    else
                                        sendMessageServer(player, 'Esse baú já está sendo acessado!', 'error')
                                    end
                                else
                                    sendMessageServer(player, 'Você não possui permissão!', 'error')
                                end
                            else
                                print("Acl: "..data_chest[1]['acl'].. " não está criada!")
                            end
                        else
                            sendMessageServer(player, 'Esse baú já está sendo acessado!', 'error')
                        end
                    else
                        sendMessageServer(player, 'Desequipe a arma para abrir o bau!', 'error') 
                    end
                end
            end
        end
    )
end 

for i, v in ipairs(dbPoll(dbQuery(db, 'Select * from chests'), -1)) do 
    createChest(fromJSON(v['pos']), v['id'], v['peso'], fromJSON(v['itens'])) 
end

addEvent('chest.used', true)
addEventHandler('chest.used', resourceRoot,
    function (element)
        if element and isElement(element) then 
            chests_opend[element] = nil 
        end
    end
)

addEventHandler('onPlayerWasted', root,
    function ( )
        for i, v in pairs ( chests_opend ) do 
            if v and isElement(v) then 
                if v == source then 
                    chests_opend[i] = nil
                end
            end
        end
    end
)

addEventHandler('onPlayerQuit', root,
    function ( )
        for i, v in pairs ( chests_opend ) do 
            if v and isElement(v) then 
                if v == source then 
                    chests_opend[i] = nil
                end
            end
        end
    end
)
    
addEvent("onPlayerGiveChestItem", true)
addEventHandler("onPlayerGiveChestItem", resourceRoot, 
    function ( item, quantidade, id )
        if not (client or (source ~= resourceRoot)) then 
            return false 
        end

        if not (tonumber(quantidade)) then return sendMessageServer(client, 'Digite uma quantidade numérica!', 'error') end
        if tonumber(quantidade) <= 0 then return sendMessageServer(client, "Digite um valor positivo!", "error") end 

        local amount = exports['guetto_inventory']:getItem(client, item)

        if (tonumber(quantidade) > amount) then 
            return sendMessageServer(client, 'Você não possui essa quantidade!', 'error')
        end
        
        local dados = exports['guetto_inventory']:getConfigItem(item)

        if (weapons[item]) then 
            takeWeapon(client, weapons[item])
        end

        if (giveItem(id, item, quantidade)) then 

            exports['guetto_inventory']:takeItem(client, item, tonumber(quantidade))

            sendMessageServer(client, 'Você guardou o item com sucesso!', 'success')

            local consummed, max = exports['guetto_inventory']:getPlayerInventoryWeight(client)
            local inventory_player = exports['guetto_inventory']:getPlayerInventory(client)

            local inventory_chest = getInventoryChest(tonumber(id))
            local consumed_chest, max_chest = getWeights(tonumber(id))

            triggerClientEvent(client, 'onClientUpateChestInventory', resourceRoot, inventory_player, {consummed, max}, inventory_chest, {consumed_chest, max_chest})

            local data_chest = dbPoll(dbQuery(db, 'Select * from chests where id = ?', id), - 1)
            if (#data_chest ~= 0) then 
                acl_chest = data_chest[1]['acl']
                webhook = data_chest[1]['hook']
            else
                acl_chest = 'N/A'
                webhook = ''
            end

            local data_item = exports['guetto_inventory']:getConfigItem(item)
            if (data_item) then 
                item_text = data_item.name..' ('..quantidade..'x)'
            else
                item_text = id..' ('..quantidade..'x)'
            end

            local new_text = text_key_input 
            local new_text = string.gsub(new_text, '${nome}', getPlayerName(client))
            local new_text = string.gsub(new_text, '${id}', (getElementData(client, 'ID') or 'N/A'))
            local new_text = string.gsub(new_text, '${acl}', acl_chest)
            local new_text = string.gsub(new_text, '${item}', item_text)

            sendMessageServer(client, 'Você guardou os itens com sucesso!', 'success') 
            log(new_text, webhook)
        else
            sendMessageServer(client, 'O baú não tem espaço para essa capacidade de itens!', 'error') 
        end
    end
)

addEvent("onPlayerGiveInventoryItem", true)
addEventHandler("onPlayerGiveInventoryItem", resourceRoot,
    function ( item, quantidade, id )
        
        if not (client or (source ~= resourceRoot)) then 
            return false 
        end

        if not (tonumber(quantidade)) then return sendMessageServer(client, 'Digite uma quantidade numérica!', 'error') end
        if tonumber(quantidade) <= 0 then return sendMessageServer(client, "Digite um valor positivo!", "error") end 

        if not item then return false end 
        if not quantidade then return false end 
        if not id then return false end 
        
        local amount = exports['guetto_inventory']:getItem(client, item)

        if (tonumber(quantidade) > tonumber(getItem(id, item)))  then 
            return sendMessageServer(client, 'O Baú não possui essa quantidade!', 'error')
        end

        local inventory_chest = getInventoryChest(tonumber(id))
        local actual = exports['guetto_inventory']:getPlayerSpaceItem(client, item, tonumber(quantidade))

        if not actual then 
            return sendMessageServer(client, 'Você não possui espaço para esse item!', 'error')
        end

        exports['guetto_inventory']:giveItem(client, item, tonumber(quantidade))
        takeItem(id, item, quantidade) 
        sendMessageServer(client, 'Você pegou o item com sucesso!', 'success')

        local consummed, max = exports['guetto_inventory']:getPlayerInventoryWeight(client)
        local inventory_player = exports['guetto_inventory']:getPlayerInventory(client)

        local consumed_chest, max_chest = getWeights(tonumber(id))

        triggerClientEvent(client, 'onClientUpateChestInventory', resourceRoot, inventory_player, {consummed, max}, inventory_chest, {consumed_chest, max_chest})

        local data_chest = dbPoll(dbQuery(db, 'Select * from chests where id = ?', id), - 1)
        if (#data_chest ~= 0) then 
            acl_chest = data_chest[1]['acl']
            webhook = data_chest[1]['hook']
        else
            acl_chest = 'N/A'
            webhook = ''
        end

        local data_item = exports['guetto_inventory']:getConfigItem(item)
        if (data_item) then 
            item_text = data_item.name..' ('..quantidade..'x)'
        else
            item_text = id..' ('..quantidade..'x)'
        end

        local new_text = text_key_take 
        local new_text = string.gsub(new_text, '${nome}', getPlayerName(client))
        local new_text = string.gsub(new_text, '${id}', (getElementData(client, 'ID') or 'N/A'))
        local new_text = string.gsub(new_text, '${acl}', acl_chest)
        local new_text = string.gsub(new_text, '${item}', item_text)

        log(new_text, webhook)
    end
)

function getWeights(id) 
    local data = dbPoll(dbQuery(db, 'Select * from chests where id = ?', tonumber(id)), - 1)
    if (#data ~= 0) then 
        local inventory = getInventoryChest(id) 
        local max = fromJSON(data[1].peso).capacity
        local consumed = 0 
        for i, v in ipairs(inventory) do 
            local data = exports['guetto_inventory']:getConfigItem(v.id)
            consumed = consumed + (tonumber(data.weight) * tonumber(v.ammount))
        end 

        return consumed, max
    else
        return 0, 100
    end
end

function getInventoryChest(id)
    local data = dbPoll(dbQuery(db, 'Select * from chests where id = ?', tonumber(id)), - 1)
    if (#data ~= 0) then 
        return fromJSON(data[1]['itens'])
    else
        return {}
    end
end

function getItem(id, item) 
    local data = dbPoll(dbQuery(db, 'Select * from chests where id = ?', tonumber(id)), - 1)
    if (#data ~= 0) then 
        local inventory = fromJSON(data[1]['itens'])
        for i, v in ipairs(inventory) do 
            if (tonumber(v.id) == tonumber(item)) then 
                return v.ammount
            end
        end
    end
    return 0
end

dbExec(db, 'CREATE TABLE IF NOT EXISTS `chests` (id INTEGER PRIMARY KEY AUTOINCREMENT, `acl` TEXT NOT NULL, `senha` TEXT NOT NULL, `pos` JSON NOT NULL, `hook` TEXT NOT NULL, `peso` JSON NOT NULL, `itens` JSON NOT NULL, `leader` TEXT NOT NULL )')

function changePasswordChest (id, senha)
    if id and senha then 
        if (getChestByID(tonumber(id))) then 
            dbExec(db, 'UPDATE `chests` SET `senha` = ? WHERE `id` = ?', senha, tonumber(id))
            return true 
        end
    end
    return false 
end

function changeAclChest (id, acl)
    if id and acl then 
        iprint(id, acl, getChestByID(tonumber(id)))
        if (getChestByID(tonumber(id))) then 
            dbExec(db, 'UPDATE `chests` SET `acl` = ? WHERE `id` = ?', acl, tonumber(id))
            return true 
        end
    end
    return false
end

function getPasswordChest (id)
    if id then
        if (getChestByID(tonumber(id))) then 
            local query = dbPoll(dbQuery(db, 'SELECT * FROM `chests` WHERE `id` = ?', tonumber(id)), -1)
            if #query ~= 0 then 
                return query[1].senha 
            end
        end
    end
    return false
end

function getAclChest (id)
    if id then
        if (getChestByID(tonumber(id))) then 
            local query = dbPoll(dbQuery(db, 'SELECT * FROM `chests` WHERE `id` = ?', tonumber(id)), -1)
            if #query ~= 0 then 
                return query[1].acl 
            end
        end
    end
    return false
end

function giveItem(id_, item, amount)
    item = tonumber(item)
    if tonumber(amount) <= 0 then return false end
    local inventory = getInventoryChest(id_) 
    local consumed, max = getWeights(id_) 
    local dados = exports['guetto_inventory']:getConfigItem(item)
    if ((consumed + dados.weight * tonumber(amount)) <= tonumber(max))then 
        if (getItem(id_, item) ~= 0) then 
            for i, v in ipairs(inventory) do 
                if (tonumber(v.id) == tonumber(item)) then 
                    v.ammount = v.ammount + tonumber(amount)
                end
            end
        else
            local new_item_index = {
                id = item; 
                ammount = tonumber(amount);
            } 
            table.insert(inventory, new_item_index)
        end   
        dbExec(db, 'Update chests set itens = ? where id = ?', toJSON(inventory), tonumber(id_))
        return true 
    end 
end

function getBauLeaderPosition (acl)
    local data = dbPoll(dbQuery(db, 'Select * from chests where acl = ? AND leader = ?', acl, '1'), - 1)
    return data
end

function takeItem(id_, item, amount)
    if tonumber(amount) <= 0 then return false end
    local inventory = getInventoryChest(id_) 
    local consumed, max = getWeights(id_) 
    if (getItem(id_, item) ~= 0) then 
        for i, v in ipairs(inventory) do 
            if (tonumber(v.id) == tonumber(item)) then 
                v.ammount = v.ammount - tonumber(amount)
            end

            if (tonumber(v.ammount) <= 0) then 
                table.remove(inventory, i)
            end
        end

        dbExec(db, 'Update chests set itens = ? where id = ?', toJSON(inventory), tonumber(id_))
        return true 
    end   
    return false
end

function getNearChest(player) 
    local pos_player = {getElementPosition(player)}
    local near_chest = nil  
    local last_distance = 9999
    for i, v in ipairs(dbPoll(dbQuery(db, 'Select * from chests'), - 1)) do  
        if (chests[v['id']] and isElement(chests[v['id']])) then 
            local pos_chest = {getElementPosition(chests[v['id']])} 
            local distance = getDistanceBetweenPoints3D(pos_player[1], pos_player[2], pos_player[3], pos_chest[1], pos_chest[2], pos_chest[3])
            if (distance <= 10) then 
                if (last_distance > distance) then 
                    near_chest = chests[v['id']]
                    last_distance = distance    
                end
            end  
        end
    end

    return near_chest, id_chest[near_chest]
end

function getChestByID(id) 
    for i, v in ipairs(dbPoll(dbQuery(db, 'Select * from chests'), - 1)) do  
        if (chests[v['id']] and isElement(chests[v['id']])) then 
            if (tonumber(v['id']) == tonumber(id)) then 
                return chests[v['id']]
            end
        end
    end
end

for i, v in ipairs(config["comandos"]) do 
    addCommandHandler(v, function(player)
        if isObjectInACLGroup("user."..getAccountName(getPlayerAccount(player)), aclGetGroup("Console")) then 
            local chest = getNearChest(player)
            if isElement(chest) then 
                local id = id_chest[chest]
                local settings = config["items"][v]
                for k = 1, #settings do 
                    if (giveItem(id, settings[k].item, settings[k].quantidade)) then 
                        sendMessageServer(player, 'Você colocou o item no baú!', 'success')
                    end
                end
            end
        end
    end)
end

function log(message, webhook)
    sendOptions = {
        queueName = "dcq",
        connectionAttempts = 3,
        connectTimeout = 5000,
        formFields = {
            content=message
        },
    }

    fetchRemote (webhook, sendOptions, 
		function()
		end
	)
end

