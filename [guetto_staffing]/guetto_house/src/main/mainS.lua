local database = dbConnect("sqlite", "src/database/database.db")
local id = 0

local exit_marker = {}
local house_marker = {}
local blips = {}
local timer_oferter = {}
local marker_data = {}

function onHitMarkerHouse (player, dimension)
    if player and isElement(player) and getElementType(player) == 'player' and not isPedInVehicle(player) and dimension then 
        if house_marker[source] then 
            local query = dbPoll(dbQuery(database, 'SELECT * FROM `Houses` WHERE `id` = ?', house_marker[source]), -1)
            if query and #query ~= 0 then 
                triggerClientEvent(player, "onPlayerHouseToggle", resourceRoot, true, query[1])
            end
        end
    end
end

function onHitMarkerHouseExit (player, dimension)
    if player and isElement(player) and getElementType(player) == 'player' and not isPedInVehicle(player) and dimension then 
        if exit_marker[source] then 
            local query = dbPoll(dbQuery(database, 'SELECT * FROM `Houses` WHERE `id` = ?', exit_marker[source]), -1)
            if query and #query ~= 0 then 
                local pos = fromJSON(query[1].marker_house)
                fadeCamera(player, false, 1.0, 0, 0, 0)
                setElementFrozen(player, true)

                setTimer(function(player)
                    fadeCamera(player, true, 0.5)
                    setElementInterior(player, 0)
                    setElementDimension(player, 0)
                    setElementFrozen(player, false)
                end, 1000, 1, player)
                setElementPosition(player, pos[1], pos[2], pos[3])
            end
        end
    end
end

function createHouse(player, model, price, peso, senha)
    if (price and model) then 
        local settings = config.types_house[model]
        if settings then 
            local x, y, z = getElementPosition(player)

            id = id + 1

            marker_data[id] = createMarker(x, y, z - 0.9, 'cylinder', 1.5, 139, 100, 255, 0)
            local marker_exit = createMarker(settings.pos.enter[1], settings.pos.enter[2], settings.pos.enter[3] - 0.9, 'cylinder', 1.5, 139, 100, 255, 0)
            
            setElementData(marker_data[id] , 'markerData', {title = 'Residência', desc = 'Gerencie essa residência!', icon = 'house'})
            setElementData(marker_exit , 'markerData', {title = 'Residência', desc = 'Saia dessa residência!', icon = 'saida'})

            house_marker[marker_data[id]] = id;
            exit_marker[marker_exit] = id;
            blips[id] = createBlip(x, y, z, 31)
            
            setElementVisibleTo(blips[id], root, false)
            setElementDimension(marker_exit, id)
            setElementInterior(marker_exit, settings.int)

            config.sendMessageServer(player, 'Você criou uma residência com sucesso!', 'success')
            dbExec(database, "INSERT INTO Houses (accountName, model, price, marker_house, marker_exit, state, int, iptu, free) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)", 'nil', model, tonumber(price), toJSON({x, y, z}), toJSON(settings.pos.enter), 'locked', settings.int, (getRealTime().timestamp + 604800),  'true' )

            addEventHandler('onMarkerHit', marker_data[id], onHitMarkerHouse)
            addEventHandler('onMarkerHit', marker_exit, onHitMarkerHouseExit)
            --exports["guetto_bau"]:createChestHouse(settings.bau[1], settings.bau[2], settings.bau[3], settings.bau[4], settings.bau[5], settings.bau[6], id, settings.int, tonumber(peso), senha)
        else
            config.sendMessageServer(player, "Modelo da casa não encontrado!", "error")
        end
    end
end

function getHouseDistance ( player )
    if not player then 
        return false 
    end;

    local x, y, z = getElementPosition(player);
    local result = false;
     
    for i, v in pairs ( blips ) do 
        local x1, y1, z1 = getElementPosition(v);
        local distance = getDistanceBetweenPoints3D (x, y, z, x1, y1, z1)
        
        if distance <= 3 then 
            result = i
        end

    end

    return result
end

addCommandHandler("criarcasa",
    function(player, cmd, price, ...)
        if isObjectInACLGroup("user."..getAccountName(getPlayerAccount(player)), aclGetGroup("Console")) then
            local name = table.concat({...}, ' ')

            if not config.types_house[name] then
                return config.sendMessageServer(player, "Esse modelo de casa não está configurado!", "error")
            end
           
            createHouse(player, name, price)
        end
    end
)

addCommandHandler('veridcasa',
    function ( player )
        if isObjectInACLGroup("user."..getAccountName(getPlayerAccount(player)), aclGetGroup("Console")) then
            local index = getHouseDistance (player);
            if not (index) then 
                return config.sendMessageServer(player, 'Residência não encontrada!', 'error')
            end
            config.sendMessageServer(player, 'O Id da residência é '..(index)..'', 'info')
        end
    end
)

addCommandHandler('deletarcasa', 
    function (player, cmd, id)
        if isObjectInACLGroup("user."..getAccountName(getPlayerAccount(player)), aclGetGroup("Console")) then
            if not id then 
                return config.sendMessageServer(player, 'Você não digitou o id da casa!', 'error')
            end
            local query = dbPoll(dbQuery(database, 'SELECT * FROM `Houses` WHERE `id` = ?', id), -1)
            if #query == 0 then return config.sendMessageServer(player, 'Residência não encontrada!', 'error') end 
            if blips[id] and isElement(blips[id]) then 
                destroyElement(blips[id])
                blips[id] = nil
            end
            if marker_data[id] and isElement(marker_data[id]) then 
                destroyElement(marker_data[id])
                marker_data[id] = nil 
            end
            dbExec(database, 'DELETE FROM `Houses` WHERE `id` = ?', id)
            config.sendMessageServer(player, 'Você deletou a casa com sucesso!', 'info')
        end
    end
)

addCommandHandler('casas',
    function (player)
        for i, v in pairs (blips) do 
            if isElementVisibleTo(v, player) then 
                setElementVisibleTo(v, player, false)
            else
                setElementVisibleTo(v, player, true)
            end
        end
    end
)

addEvent("onPlayerBuyHouse", true)
addEventHandler("onPlayerBuyHouse", resourceRoot,
    function(dados)
        if not client then return false end

        if source ~= getResourceDynamicElementRoot(getThisResource()) then
            return outputDebugString("Resource | ".. getResourceName(getThisResource()) .." | ".. getPlayerName(client) .." # ".. (getElementData(client, 'ID') or "N/A") .." | Serial | ".. getPlayerSerial(client) .."  | IP | ".. getPlayerIP(client), 1)
        end

        local qh = dbPoll(dbQuery(database, 'SELECT * FROM `Houses` WHERE `id` = ?', dados.id), -1)
        if #qh == 0 then return config.sendMessageServer(client, "Essa casa não existe!", "error") end 

        local price = tonumber(qh[1].price)

        if price <= 0 then return false end 
        if getPlayerMoney(client) < price then return config.sendMessageServer(client, "Esse jogador não possui dinheiro suficiente!", "error") end 
        if not qh[1].accountName then return config.sendMessageServer(client, "Essa casa já possui um dono!", "error") end        

        takePlayerMoney(client, price)
        dbExec(database, 'UPDATE Houses SET free = ?, accountName = ? WHERE id = ?', 'false', getAccountName(getPlayerAccount(client)), qh[1].id)

        config.sendMessageServer(client, 'Você comprou a residência com sucesso!', 'success')
    end
)

addEvent("onPlayerEnterHouse", true)
addEventHandler("onPlayerEnterHouse", resourceRoot, 
    function(dados)
        if not client then return false end

        if source ~= getResourceDynamicElementRoot(getThisResource()) then
            return outputDebugString("Resource | ".. getResourceName(getThisResource()) .." | ".. getPlayerName(client) .." # ".. (getElementData(client, 'ID') or "N/A") .." | Serial | ".. getPlayerSerial(client) .."  | IP | ".. getPlayerIP(client), 1)
        end

        local qh = dbPoll(dbQuery(database, 'SELECT * FROM `Houses` WHERE `id` = ?', dados.id), -1)
        if #qh == 0 then return config.sendMessageServer(client, "Essa casa não existe!", "error") end 

        if (getRealTime().timestamp > tonumber(qh[1].iptu)) then
            return config.sendMessageServer(client, 'Pague o IPTU da sua residência!', 'error')
        end;

        if isPedInVehicle(client) then 
            return false 
        end

        if qh[1].state == 'locked' then 
            return config.sendMessageServer(client, "Essa casa está trancada!", "error")
        end

        local x, y, z = unpack(fromJSON(qh[1].marker_exit))
        fadeCamera(client, false, 1.0, 0, 0, 0)
        
        setTimer(function(player)
            setElementDimension(player, tonumber(qh[1].id))
            setElementPosition(player, x, y + 1, z)
            setElementInterior(player, tonumber(qh[1].int))
            fadeCamera(player, true, 0.5)
        end, 1000, 1, client)
    end
)

function updateClient (player, tbl)
    if not player then 
        return false;
    end
    if not tbl or type(tbl) ~= 'table' then 
        return false 
    end
    return triggerClientEvent(player, "updateClientInfos", resourceRoot, tbl[1])
end

addEvent("onPlayerUnlockedHouse", true)
addEventHandler("onPlayerUnlockedHouse", resourceRoot,
    function ( dados )
        if not client then return false end

        if source ~= getResourceDynamicElementRoot(getThisResource()) then
            return outputDebugString("Resource | ".. getResourceName(getThisResource()) .." | ".. getPlayerName(client) .." # ".. (getElementData(client, 'ID') or "N/A") .." | Serial | ".. getPlayerSerial(client) .."  | IP | ".. getPlayerIP(client), 1)
        end

        local qh = dbPoll(dbQuery(database, 'SELECT * FROM `Houses` WHERE `id` = ?', dados.id), -1)
        if #qh == 0 then return config.sendMessageServer(client, "Essa casa não existe!", "error") end 

        if (qh[1].accountName == getAccountName(getPlayerAccount(client)) or isPlayerSubOwnerHouse(client, dados.id)) then 
            local price = tonumber(qh[1].price)

            if price <= 0 then return false end 
    
            if qh[1].state == 'locked' then 
                dbExec(database, "UPDATE Houses SET state = ? WHERE id = ?", 'open', qh[1].id)
                config.sendMessageServer(client, 'Você destrancou a casa com sucesso!', 'info')
            elseif qh[1].state == 'open' then 
                dbExec(database, "UPDATE Houses SET state = ? WHERE id = ?", 'locked', qh[1].id)
                config.sendMessageServer(client, 'Você trancou a casa com sucesso!', 'info')
            end
    
            updateClient(client, dbPoll(dbQuery(database, 'SELECT * FROM `Houses` WHERE `id` = ?', dados.id), -1))
        else
            config.sendMessageServer(client, 'Você não possui permissão para trancar/destrancar essa residência!', 'error')
        end
      
    end
)

addEvent("onPlayerHouseSellingGov", true)
addEventHandler("onPlayerHouseSellingGov", resourceRoot,
    function (dados)
        if not client then return false end

        if source ~= getResourceDynamicElementRoot(getThisResource()) then
            return outputDebugString("Resource | ".. getResourceName(getThisResource()) .." | ".. getPlayerName(client) .." # ".. (getElementData(client, 'ID') or "N/A") .." | Serial | ".. getPlayerSerial(client) .."  | IP | ".. getPlayerIP(client), 1)
        end

        local qh = dbPoll(dbQuery(database, "SELECT * FROM `Houses` WHERE `id` = ? AND `accountName` = ?", dados.id, getAccountName(getPlayerAccount(client))), -1)
        if #qh == 0 then return config.sendMessageServer(client, "Você não é dono dessa residência!", "error") end 
        if qh[1].status == 'true' then return false end
        if getRealTime().timestamp > qh[1].iptu then return config.sendMessageServer(client, "Você não pode vender a casa com o IPTU atrasado!", "error") end  

        local percent = tonumber(qh[1].price) * 0.5

        givePlayerMoney(client, percent)
        config.sendMessageServer(client, 'Você vendeu sua casa com sucesso!', 'info')

        dbExec(database, 'UPDATE `Houses` SET `accountName` = ?, `free` = ? WHERE `id` = ?', 'false', 'true', dados.id)
        dbExec(database, 'DELETE FROM `SubOwner` WHERE `id` = ?', dados.id)
    end
)

addEvent("onPlayerHousePayIPTU", true)
addEventHandler("onPlayerHousePayIPTU", resourceRoot,
    function ( dados )
        if not client then return false end

        if source ~= getResourceDynamicElementRoot(getThisResource()) then
            return outputDebugString("Resource | ".. getResourceName(getThisResource()) .." | ".. getPlayerName(client) .." # ".. (getElementData(client, 'ID') or "N/A") .." | Serial | ".. getPlayerSerial(client) .."  | IP | ".. getPlayerIP(client), 1)
        end

        local qh = dbPoll(dbQuery(database, "SELECT * FROM `Houses` WHERE `id` = ?", dados.id), -1)
        if #qh == 0 then return config.sendMessageServer(client, "Você não possui essa residência!", "error") end 

        if getRealTime().timestamp < qh[1].iptu then return config.sendMessageServer(client, "O IPTU da sua residência não está atrasado!", "info") end 
        local price = tonumber(qh[1].price) * 0.5

        if getPlayerMoney(client) < price then return config.sendMessageServer(client, "Você não possui dinheiro suficiente para pagar o IPTU da sua residência!", "error") end 

        dbExec(database, "UPDATE `Houses` SET `iptu` = ? WHERE `id` = ?", (getRealTime().timestamp + 604800), qh[1].id)
        takePlayerMoney(client, price)
        config.sendMessageServer(client, "Você pagou o IPTU do seu veículo com sucesso!", "success")
    end
)

addEvent("onPlayerHouseSellingPlayer", true)
addEventHandler("onPlayerHouseSellingPlayer", resourceRoot, function(targetId, valor, dados)
    if not client then return false end

    if source ~= getResourceDynamicElementRoot(getThisResource()) then
        return outputDebugString("Resource | ".. getResourceName(getThisResource()) .." | ".. getPlayerName(client) .." # ".. (getElementData(client, 'ID') or "N/A") .." | Serial | ".. getPlayerSerial(client) .."  | IP | ".. getPlayerIP(client), 1)
    end
    
    local qh = dbPoll(dbQuery(database, "SELECT * FROM `Houses` WHERE `id` = ? AND `accountName` = ?", dados.id, getAccountName(getPlayerAccount(client))), -1)

    if #qh == 0 then 
        return config.sendMessageServer(client, "Você não é dono dessa residência!", "error") 
    end 

    if tonumber(valor) <= 0 then return config.sendMessageServer(client, "Valor inválido!", "error") end 

    local target = getPlayerFromId(tonumber(targetId))
    
    if target == client then 
        return config.sendMessageServer(client, 'Você não pode vender uma casa para si mesmo!', 'error')
    end

    if not target then return config.sendMessageServer(client, "Jogador não encontrado!", "error") end 

    if getElementData(client, "oferter") then return config.sendMessageServer(client, "Você já enviou uma oferta recentemente!", "error") end 

    setTimer(function(player, target)
        if getElementData(player, "oferter") then 
            removeElementData(player, "oferter")
        end
        if getElementData(target, "reciver_oferter") then 
            removeElementData(target, "reciver_oferter")
        end
    end, 1 * 60000, 1, client, target)

    setElementData(client, "oferter", target)
    setElementData(target, "reciver_oferter", client)

    config.sendMessageServer(client, "Você enviou uma proposta de venda para o jogador!", "info")
    config.sendMessageServer(target, "Você recebeu uma proposta de venda de casa!", "info")
    triggerClientEvent(target, 'onPlayerOferterToggle', resourceRoot, true, qh[1], valor)
end)

addEvent("onPlayerRefuseOferter", true)
addEventHandler("onPlayerRefuseOferter", resourceRoot, function()
    if not client then return false end

    if source ~= getResourceDynamicElementRoot(getThisResource()) then
        return outputDebugString("Resource | ".. getResourceName(getThisResource()) .." | ".. getPlayerName(client) .." # ".. (getElementData(client, 'ID') or "N/A") .." | Serial | ".. getPlayerSerial(client) .."  | IP | ".. getPlayerIP(client), 1)
    end

    local target = getElementData(client, 'reciver_oferter')

    if target then 
        config.sendMessageServer(target, "A oferta foi recusada!", "info")
        removeElementData(target, "oferter")
    end

    triggerClientEvent(client, 'onPlayerOferterToggle', resourceRoot, false, nil, nil)
    removeElementData(client, 'reciver_oferter')

    config.sendMessageServer(client, "Você recusou a oferta!", "info")
    config.sendMessageServer(target, "O Jogador recusou a oferta!", "info")
end)

addEvent("onPlayerAcceptOferter", true)
addEventHandler("onPlayerAcceptOferter", resourceRoot, function(dados, money)
   
    if not (client) then 
        return false;
    end

    if source ~= getResourceDynamicElementRoot(getThisResource()) then
        return outputDebugString("Resource | ".. getResourceName(getThisResource()) .." | ".. getPlayerName(client) .." # ".. (getElementData(client, 'ID') or "N/A") .." | Serial | ".. getPlayerSerial(client) .."  | IP | ".. getPlayerIP(client), 1)
    end

    if tonumber(money) <= 0 then 
        return config.sendMessageServer(client, 'Digite apenas valores positivos!', 'info') 
    end;

    local sender = getElementData(client, 'reciver_oferter') or false;
    
    if not (sender and isElement(sender)) then 
        return config.sendMessageServer(client, 'O cidadão que ofertou a residência não se encontra online!', 'error')
    end;

    local account = getAccountName(getPlayerAccount(sender));

    local qh = dbPoll(dbQuery(database, "SELECT * FROM `Houses` WHERE `id` = ? AND `accountName` = ?", dados.id, account), -1)
    
    if (#qh == 0) then 
        return config.sendMessageServer(client, "A casa não foi encontrada ou não pertence ao jogador!", "error") 
    end;

    if getPlayerMoney(client) < tonumber(money) then return config.sendMessageServer(client, "Você não possui dinheiro suficiente para comprar essa residência!", "error") end 

    if (isPlayerSubOwnerHouse(client, dados.id)) then 
        dbExec(database, 'DELETE FROM `SubOwner` WHERE `id` = ? AND `accountName` = ?', dados.id, getAccountName(getPlayerAccount(client)))
    end

    takePlayerMoney(client, tonumber(money))
    givePlayerMoney(sender, tonumber(money))

    dbExec(database, "UPDATE `Houses` SET `accountName` = ?, `free` = ? WHERE `id` = ?", getAccountName(getPlayerAccount(client)), 'false', dados.id)
    triggerClientEvent(client, 'onPlayerOferterToggle', resourceRoot, false, nil, nil)

    removeElementData(client, "reciver_oferter")
    removeElementData(sender, "oferter")

    config.sendMessageServer(client, 'Você comprou a residência com sucesso!', 'success')
    config.sendMessageServer(client, 'Você vendeu a residência com sucesso!', 'success')
end)

--[[
    if not sender then return config.sendMessageServer(client, "O jogador que te enviou a oferta não se encontra!", "error") end 

    local qh = dbPoll(dbQuery(database, "SELECT * FROM `Houses` WHERE `id` = ? AND `accountName` = ?", dados.id, getAccountName(getPlayerAccount(sender))), -1)
    if #qh == 0 then return config.sendMessageServer(client, "A casa não foi encontrada ou não pertence ao jogador!", "error") end 
    
    local query = dbPoll(dbQuery(database, 'SELECT * FROM `SubOwner` WHERE `id` AND `accountName` = ?'), dados.id, getAccountName(getPlayerAccount(client)))

    if (#query ~= 0) then 
        dbExec(database, 'DELETE FROM `SubOwner` WHERE `id` = ? AND `accountName` = ?', dados.id, getAccountName(getPlayerAccount(client)))
    end
    
    if getPlayerMoney(client) < tonumber(money) then return config.sendMessageServer(client, "Você não possui dinheiro suficiente para comprar essa residência!", "error") end 

    takePlayerMoney(client, tonumber(money))
    givePlayerMoney(sender, tonumber(money))
    
    dbExec(database, "UPDATE `Houses` SET `accountName` = ?, `free` = ? WHERE `id` = ?", getAccountName(getPlayerAccount(client)), 'false', dados.id)

    config.sendMessageServer(client, "Você comprou a residência com sucesso!", "success")
    config.sendMessageServer(sender, "Você vendeu a residência com sucesso!", "success")

    removeElementData(client, "reciver_oferter")
    removeElementData(sender, "oferter")]]

function isPlayerSubOwnerHouse (player, id)
    if not player then return false end;
    if not id then return false end;
    local accountName = getAccountName(getPlayerAccount(player));
    local id = tonumber(id);
    local qh = dbPoll(dbQuery(database, 'SELECT * FROM `SubOwner` WHERE `id` = ? AND  `accountName` = ?', id, accountName), - 1)
    if #qh == 0 then return false end 
    return true
end

addEvent("setPlayerOwnerHouse", true)
addEventHandler("setPlayerOwnerHouse", resourceRoot, 
    function ( dados, id )
        if not client then return false end

        if source ~= getResourceDynamicElementRoot(getThisResource()) then
            return outputDebugString("Resource | ".. getResourceName(getThisResource()) .." | ".. getPlayerName(client) .." # ".. (getElementData(client, 'ID') or "N/A") .." | Serial | ".. getPlayerSerial(client) .."  | IP | ".. getPlayerIP(client), 1)
        end

        local qh = dbPoll(dbQuery(database, "SELECT * FROM `Houses` WHERE `id` = ? AND `accountName` = ?", dados.id, getAccountName(getPlayerAccount(client))), -1)
        if #qh == 0 then return config.sendMessageServer(client, "Você não é dono dessa residência!", "error") end 
        local target = getPlayerFromId(tonumber(id));
       
        if not target then 
            return config.sendMessageServer(client, 'Jogador não encontrado!', 'error') 
        end; 

        if (target == client) then 
            return config.sendMessageServer(client, 'Você não pode alugar uma residência para você mesmo!', 'error')
        end;

        if isPlayerSubOwnerHouse(target, dados.id) then 
            dbExec(database, 'DELETE FROM `SubOwner` WHERE `id` = ? AND `accountName` = ?', dados.id, getAccountName(getPlayerAccount(target)))
            config.sendMessageServer(client, 'Você removeu o jogador '..(removeHex(getPlayerName(target)))..'#'..(getElementData(target, 'ID') or 'N/A')..' da residência!', 'success')
            config.sendMessageServer(target, 'O Jogador '..removeHex(getPlayerName(client))..'#'..(getElementData(client, 'ID') or 'N/A')..' removeu você da residência!', 'success')
        else
            dbExec(database, 'INSERT INTO `SubOwner` VALUES (?, ?)', dados.id, getAccountName(getPlayerAccount(target)))
            config.sendMessageServer(client, 'Você alugou a residência para o jogador '..(removeHex(getPlayerName(target)))..'#'..(getElementData(target, 'ID') or 'N/A')..' ', 'success')
            config.sendMessageServer(target, 'O Jogador '..removeHex(getPlayerName(client))..'#'..(getElementData(client, 'ID') or 'N/A')..' alugou uma residência para você!', 'success')
        end

    end
)

addEventHandler("onResourceStart", resourceRoot,
    function()
        if database and isElement(database) then
            dbExec(database, 'CREATE TABLE IF NOT EXISTS Houses (`id` INTEGER PRIMARY KEY AUTOINCREMENT, accountName TEXT, model TEXT, price INTEGER, marker_house TEXT, marker_exit TEXT, state TEXT, int INTEGER, iptu INTEGER, free TEXT)')
            dbExec(database, 'CREATE TABLE IF NOT EXISTS SubOwner (id TEXT, accountName TEXT);')

            local qh = dbPoll(dbQuery(database, 'SELECT * FROM `Houses`'), -1)
            local result_sequence = dbPoll(dbQuery(database, "SELECT * FROM `sqlite_sequence` WHERE `name` = 'Houses'"), -1)
            if result_sequence and #result_sequence ~= 0 then 
                id = tonumber(result_sequence[1].seq)
            end
            if #qh ~= 0 then 
                for i, v in ipairs (qh) do 
                    local x, y, z = unpack(fromJSON(v.marker_house))
                    marker_data[v.id] = createMarker(x, y, z - 0.9, 'cylinder', 1.5, 139, 100, 255, 0)
                    local marker_exit = createMarker(config.types_house[v.model].pos.enter[1], config.types_house[v.model].pos.enter[2], config.types_house[v.model].pos.enter[3] - 0.9, 'cylinder', 1.5, 139, 100, 255, 0)
                                
                    setElementData(marker_data[v.id] , 'markerData', {title = 'Residência', desc = 'Gerencie essa residência!', icon = 'house'})
                    setElementData(marker_exit , 'markerData', {title = 'Residência', desc = 'Saia dessa residência!', icon = 'saida'})

                    house_marker[marker_data[v.id]] = v.id;
                    exit_marker[marker_exit] = v.id;
                    setElementDimension(marker_exit, v.id)
                    setElementInterior(marker_exit, v.int)
                    addEventHandler('onMarkerHit', marker_data[v.id], onHitMarkerHouse)
                    addEventHandler('onMarkerHit', marker_exit, onHitMarkerHouseExit)
                    if v.free == 'false' then 
                        blips[v.id] = createBlip(x, y, z, 32)
                    else
                        blips[v.id] = createBlip(x, y, z, 31)
                    end

                    setElementVisibleTo(blips[v.id], root, false)
                end
            end
        end
    end
)

addCommandHandler('resetcasa', function(player, cmd, account)
    if isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(player)), aclGetGroup('Console')) then 
        if not account then return config.sendMessageServer(player, 'Digite a conta do jogador!', 'error') end 
        local query = dbPoll(dbQuery(database, 'SELECT * FROM `Houses` WHERE `accountName` = ?', account), - 1)
        if #query == 0 then return config.sendMessageServer(player, 'Esse jogador não possui nenhuma residência!', 'error') end 
        dbExec(database, 'UPDATE `Houses` SET `accountName` = ?, `free` = ? WHERE `accountName` = ?', 'nil', 'true', account)
        config.sendMessageServer(player, 'Você resetou todas as casas do jogador!', 'info') 
    end
end)

function getPlayerFromId (id)
    local result = false;
    for i, v in ipairs (getElementsByType('player')) do 
        if getElementData(v, 'ID') == id then 
            result = v 
        end
    end
    return result
end

function getPlayerOferter (player, data)
    local result = false;
    for i, v in ipairs (getElementsByType('player')) do 
        if getElementData(v, data) == player then 
            result = v 
        end
    end
    return result
end

for i, v in ipairs(getElementsByType('player')) do 
    setElementData(v, 'reciver_oferter', false)
    setElementData(v, "oferter", false)
end
