db = dbConnect("sqlite", "assets/database/database.sqlite")
dbExec(db, "CREATE TABLE IF NOT EXISTS vips (ID INTEGER PRIMARY KEY AUTOINCREMENT, account, id_account, vip, expiry_date)")
dbExec(db, "CREATE TABLE IF NOT EXISTS keys (key, target, type, vip, quantity, timestamp)")
dbExec(db, "CREATE TABLE IF NOT EXISTS coins (ID INTEGER PRIMARY KEY AUTOINCREMENT, account, quantity)")
dbExec(db, "CREATE TABLE IF NOT EXISTS last_activies (activator, id_activator, proprietary, id_proprietary, date, type, quantity, timestamp, value)")

addEventHandler("onResourceStart", resourceRoot, function()
    
    if db then 
        outputDebugString("SQUADY [SISTEMA DE GERENCIADOR VIP] BANCO DE DADOS CONECTADO COM SUCESSO.", 4, 14, 158, 247)
    else
        outputDebugString("SQUADY [SISTEMA DE GERENCIADOR VIP] HOUVE UM ERRO AO CONECTAR O BANCO DE DADOS.", 4, 255, 0, 0)
    end

end)

setTimer(function()
    local result = dbPoll(dbQuery(db, "SELECT * FROM vips"), -1)
    for i, v in ipairs(result) do 
        if v.expiry_date then 
            if getRealTime().timestamp >= v.expiry_date then 
                if aclGetGroup(v.vip) then aclGroupRemoveObject(aclGetGroup(v.vip), "user."..(v.account)) end 
                dbExec(db, "DELETE FROM vips WHERE account = ? AND vip = ?", v.account, v.vip)
            end
        end
    end
end, 60000, 0)

addCommandHandler(config.panel.command, function(player)
    if isPlayerInACL(player, "Console") or isPlayerInACL(player, "Gerenciador") then 
        triggerClientEvent(player, "squady.openManagerVIP", player)
        attPanel(player)
    end
end)

addCommandHandler("setplayervip", function(player)
    if isPlayerInACL(player, "Console") then 
        local query = dbPoll(dbQuery(db, 'SELECT * FROM `vips`'), - 1)
        if #query ~= 0 then 
            for i = 1, #query do 
                local v = query[i]
                local account = v.account;
                if not (isObjectInACLGroup('user.'..account, aclGetGroup(v.vip))) then 
                    aclGroupAddObject(aclGetGroup(v.vip), 'user.'..account)
                    print (v.account..'Setado na acl '..v.vip)
                end
            end 
        end
    end
end)

function getTimeVip (player, vip)

    if not player or not isElement(player) then 
        return false;
    end;

    if not vip then 
        return false;
    end;

    local accountName = getAccountName(getPlayerAccount(player))
    local result = dbPoll(dbQuery(db, "SELECT * FROM vips WHERE account = ? AND vip = ?", accountName, vip), -1)

    if result and #result <= 0 then 
        return false;
    end;

    return result[1].expiry_date
end

function activeVIP(receiver_id, vip, time)
    if receiver_id and vip and time then 
        local _, account = exports["guetto_id2"]:getSerialByID(tonumber(receiver_id))
        if account then 
            if aclGetGroup(vip) then 
                local calculate_days = time * 86400
                local expiry_date = getRealTime().timestamp + calculate_days
                local result = dbPoll(dbQuery(db, "SELECT * FROM vips WHERE account = ? AND vip = ?", account, vip), -1)
                local receiver = getPlayerFromID(receiver_id)

                if #result == 0 then 
                    if receiver and isElement(receiver) then 
                        sendMessage("server", receiver, "Foi ativado um VIP "..vip.." de "..time.." dia(s) na sua conta.", "info")
                    end

                    aclGroupAddObject(aclGetGroup(vip), "user."..account)
                    dbExec(db, "INSERT INTO vips (account, id_account, vip, expiry_date) VALUES (?, ?, ?, ?)", account, (getElementData(receiver, "ID") or 0), vip, expiry_date)
                    
                    --[[
                                        for i, v in ipairs(getElementsByType("player")) do 
                        triggerClientEvent(v, "squady.onDrawnActive", v, account, receiver_id, vip)
                    end
]]
                    iprint(receiver, config["ativação"][vip])
                    
                    givePlayerMoney(receiver, config["ativação"][vip])

                    if config.logs.log then
                        messageDiscord("O(A) "..getPlayerName(receiver).." ("..pullID(receiver)..") ativou um VIP "..vip.." de "..time.." dia(s)", config.logs.web_hook)
                    end
                else
                    sendMessage("server", receiver, "Você já possui esse VIP.", "error")
                end
            else
                sendMessage("server", receiver, "Esse VIP não existe.", "error")
            end
        else
            sendMessage("server", receiver, "Houve um Erro", "error")
        end
    end
end

function activeVipByID(hash, iv)

    if not client then
        return
    end

    local player = client

    local account = getAccountName(getPlayerAccount(player));
    
    if not isObjectInACLGroup("user."..account, aclGetGroup("Console")) then 
        local ip = getPlayerIP (player); 
        local serail = getPlayerSerial(player)
        return addBan(ip, nil, serail, "Guetto - AC", "Tentativa de fraude de um sistema! Banido Globalemente do MTA.", 0 )
    end

    decodeString('aes128', hash, {key = getPlayerSerial(player):sub(17), iv = iv}, function(decoded)
        local dados = fromJSON(decoded)
        local receiver_id = dados.receiver_id
        local vip = dados.vip
        local time = dados.time
        if player and receiver_id and vip and time then 
            local _, account = exports["guetto_id2"]:getSerialByID(tonumber(receiver_id))
            
            if account then 
                if aclGetGroup(vip) then 
                    local calculate_days = time * 86400
                    local expiry_date = getRealTime().timestamp + calculate_days
                    local result = dbPoll(dbQuery(db, "SELECT * FROM vips WHERE account = ? AND vip = ?", account, vip), -1)
                    local receiver = getPlayerFromID(receiver_id)
    
                    if #result == 0 then 
                        if receiver and isElement(receiver) then 
                            sendMessage("server", receiver, "Foi ativado um VIP "..vip.." de "..time.." dia(s) na sua conta.", "info")
                        end
    
                        aclGroupAddObject(aclGetGroup(vip), "user."..account)
                        dbExec(db, "INSERT INTO vips (account, id_account, vip, expiry_date) VALUES (?, ?, ?, ?)", account, (getElementData(receiver, "ID") or 0), vip, expiry_date)
                        dbExec(db, "INSERT INTO last_activies (activator, id_activator, proprietary, id_proprietary, date, type, quantity, timestamp, value) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)", getPlayerName(player), pullID(player), account, pullID(receiver), getRealTime().timestamp, vip, time, "Ativado", config.prices[vip])
                        sendMessage("server", player, "Você setou o VIP no jogador(a) com sucesso.", "success")
                        for i, v in ipairs(getElementsByType("player")) do 
                            triggerClientEvent(v, "squady.onDrawnActive", v, account, receiver_id, vip)
                        end

                        givePlayerMoney(receiver, config["ativação"][vip])

                        if config.logs.log then
                            messageDiscord("O(A) "..getPlayerName(player).." ("..pullID(player)..") setou um VIP "..vip.." de "..time.." dia(s) no jogador "..account.." ("..receiver_id..").", config.logs.web_hook)
                        end
                        attPanel(player)
                    else
                        sendMessage("server", player, "Esse jogador já possui esse VIP.", "error")
                    end
                else
                    sendMessage("server", player, "Esse VIP não existe.", "error")
                end
            else
                sendMessage("server", player, "Jogador não encontrado.", "error")
            end
        end
    end)
end
registerEvent("squady.activeVipByID", resourceRoot, activeVipByID)

function removeVipByID(player, receiver_id, vip)
    if client == player then
        if player and receiver_id and vip then 

            local account = getAccountName(getPlayerAccount(player));
    
            if not isObjectInACLGroup("user."..account, aclGetGroup("Console")) then 
                local ip = getPlayerIP (player); 
                local serail = getPlayerSerial(player)
                return addBan(ip, nil, serail, "Guetto - AC", "Tentativa de fraude de um sistema! Banido Globalemente do MTA.", 0 )
            end

            local _, account = exports["guetto_id2"]:getSerialByID(tonumber(receiver_id))
            
            if account then 
                if aclGetGroup(vip) then 
                    local result = dbPoll(dbQuery(db, "SELECT * FROM vips WHERE account = ? AND vip = ?", account, vip), -1)
                    local receiver = getPlayerFromID(receiver_id)

                    if #result ~= 0 then 
                        if receiver and isElement(receiver) then 
                            sendMessage("server", receiver, "Foi removido o VIP "..vip.." da sua conta.", "info")
                        end

                        aclGroupRemoveObject(aclGetGroup(vip), "user."..account)
                        dbExec(db, "DELETE FROM vips WHERE account = ? AND vip = ?", account, vip)
                        dbExec(db, "INSERT INTO last_activies (activator, id_activator, proprietary, id_proprietary, date, type, quantity, timestamp, value) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)", getPlayerName(player), pullID(player), account, pullID(receiver), getRealTime().timestamp, vip, nil, "Removido", 0)
                        sendMessage("server", player, "Você removeu o VIP do jogador(a) com sucesso.", "success")
                        if config.logs.log then
                            messageDiscord("O(A) "..getPlayerName(player).." ("..pullID(player)..") removeu o VIP "..vip.." do jogador "..account.." ("..receiver_id..").", config.logs.web_hook)
                        end
                        attPanel(player)
                        
                    else
                        sendMessage("server", player, "Esse jogador não possui esse VIP.", "error")
                    end
                else
                    sendMessage("server", player, "Esse VIP não existe.", "error")
                end
            else
                sendMessage("server", player, "Jogador não encontrado.", "error")
            end
        end
    end
end
registerEvent("squady.removeVipByID", resourceRoot, removeVipByID)

registerEvent("squady.removeVIP", resourceRoot, function(hash, iv)

    if not client then
        return
    end

    local player = client

    local account = getAccountName(getPlayerAccount(player));
    
    if not isObjectInACLGroup("user."..account, aclGetGroup("Console")) then 
        local ip = getPlayerIP (player); 
        local serail = getPlayerSerial(player)
        return addBan(ip, nil, serail, "Guetto - AC", "Tentativa de fraude de um sistema! Bandio Globalemente do MTA.", 0 )
    end

    decodeString('aes128', hash, {key = getPlayerSerial(player):sub(17), iv = iv}, function(decoded)
        local dados = fromJSON(decoded)
        local data = dados.vip
        if player and data then 
            local result = dbPoll(dbQuery(db, "SELECT * FROM vips WHERE account = ? AND vip = ?", data.player, data.product), -1)
            
            if #result ~= 0 then 
                aclGroupRemoveObject(aclGetGroup(data.product), "user."..data.player)
                dbExec(db, "DELETE FROM vips WHERE account = ? AND vip = ?", data.player, data.product)
                dbExec(db, "INSERT INTO last_activies (activator, id_activator, proprietary, id_proprietary, date, type, quantity, timestamp, value) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)", getPlayerName(player), pullID(player), data.player, "N/A", getRealTime().timestamp, data.product, nil, "Removido", 0)
                sendMessage("server", player, "Você removeu o VIP do jogador com sucesso.", "success")
                if config.logs.log then
                    messageDiscord("O(A) "..getPlayerName(player).." ("..pullID(player)..") removeu o VIP "..data.product.." do jogador "..data.player..".", config.logs.web_hook)
                end
                attPanel(player)
            else
                sendMessage("server", player, "Esse jogador não possui esse VIP.", "error")
            end
        end
    end)
end)

registerEvent("squady.activeCoinsByID", resourceRoot, function(hash, iv)

    if not client then
        return
    end

    local player = client
    local account = getAccountName(getPlayerAccount(player));
    
    if not isObjectInACLGroup("user."..account, aclGetGroup("Console")) then 
        local ip = getPlayerIP (player); 
        local serail = getPlayerSerial(player)
        return addBan(ip, nil, serail, "Guetto - AC", "Tentativa de fraude de um sistema! Bandio Globalemente do MTA.", 0 )
    end

    decodeString('aes128', hash, {key = getPlayerSerial(player):sub(17), iv = iv}, function(decoded)
        local dados = fromJSON(decoded)
        local quantity = dados.amount
        local receiver_id = dados.target

        if player and quantity and receiver_id then 
            local _, account = exports["guetto_id2"]:getSerialByID(tonumber(receiver_id))

            if account then 
                local receiver = getPlayerFromID(receiver_id)

                if receiver and isElement(receiver) then
                    local current_coins = (getElementData(receiver, config.panel.datacoins) or 0)
                    setElementData(receiver, config.panel.datacoins, current_coins + quantity)
                    sendMessage("server", receiver, "Foi ativo "..quantity.." coins na sua conta.", "success")
                end

                local result = dbPoll(dbQuery(db, "SELECT * FROM coins WHERE account = ?", account), -1)

                if #result > 0 then 
                    dbExec(db, "UPDATE coins SET quantity = ? WHERE account = ?", (result[1]["quantity"] + quantity), account)
                else
                    dbExec(db, "INSERT INTO coins (account, quantity) VALUES (?, ?)", account, quantity)
                end
                
                dbExec(db, "INSERT INTO last_activies (activator, id_activator, proprietary, id_proprietary, date, type, quantity, timestamp, value) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)", getPlayerName(player), pullID(player), account, pullID(receiver), getRealTime().timestamp, config.panel.datacoins, quantity, "Ativado", 1 * quantity)
                sendMessage("server", player, "Você ativou "..quantity.." coins na conta do jogador(a) "..account.." ("..receiver_id..").", "success")
                if config.logs.log then
                    messageDiscord("O(A) "..getPlayerName(player).." ("..pullID(player)..") setou "..quantity.." coins na conta do jogador(a) "..account.." ("..receiver_id..")", config.logs.web_hook)
                end
                for i, v in ipairs(getElementsByType("player")) do 
                    triggerClientEvent(v, "squady.onDrawnActive", v, account, receiver_id, quantity, "Pontos")
                end
                attPanel(player)
            else
                sendMessage("server", player, "Esse jogador não foi encontrado.", "error")
            end
        end
    end)
end)

registerEvent("squady.removeCoinsByID", root, function(quantity, receiver_id)

    if not client then
        return
    end

    local player = client
    
    local account = getAccountName(getPlayerAccount(player));
    
    if not isObjectInACLGroup("user."..account, aclGetGroup("Console")) then 
        local ip = getPlayerIP (player); 
        local serail = getPlayerSerial(player)
        return addBan(ip, nil, serail, "Guetto - AC", "Tentativa de fraude de um sistema! Banido Globalemente do MTA.", 0 )
    end

    if client == player then 
        if player and quantity and receiver_id then 
            local _, account = exports["guetto_id2"]:getSerialByID(tonumber(receiver_id))

            if account then 
                local receiver = getPlayerFromID(receiver_id)

                if receiver and isElement(receiver) then
                    local current_coins = (getElementData(receiver, config.panel.datacoins) or 0)
                    setElementData(receiver, config.panel.datacoins, current_coins - quantity)
                    sendMessage("server", receiver, "Foi removido "..quantity.." coins da sua conta.", "success")
                end

                local result = dbPoll(dbQuery(db, "SELECT * FROM coins WHERE account = ?", account), -1)

                if #result > 0 then 
                    dbExec(db, "UPDATE coins SET quantity = ? WHERE account = ?", (result[1]["quantity"] - quantity), account)
                else
                    dbExec(db, "INSERT INTO coins (account, quantity) VALUES (?, ?)", account, quantity)
                end
                
                dbExec(db, "INSERT INTO last_activies (activator, id_activator, proprietary, id_proprietary, date, type, quantity, timestamp, value) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)", getPlayerName(player), pullID(player), account, pullID(receiver), getRealTime().timestamp, config.panel.datacoins, quantity, "Removido", 0)
                sendMessage("server", player, "Você removeu "..quantity.." coins da conta do jogador(a) "..account.." ("..receiver_id..").", "success")
                if config.logs.log then
                    messageDiscord("O(A) "..getPlayerName(player).." ("..pullID(player)..") removeu "..quantity.." coins da conta do jogador(a) "..getPlayerName(receiver).." ("..pullID(receiver)..").", config.logs.web_hook)
                end
                attPanel(player)
            else
                sendMessage("server", player, "Esse jogador não foi encontrado.", "error")
            end
        end
    end
end)

registerEvent("squady.createKeys", resourceRoot, function(hash, iv)

    if not client then
        return
    end

    local player = client

    local account = getAccountName(getPlayerAccount(player));
    
    if not isObjectInACLGroup("user."..account, aclGetGroup("Console")) then 
        local ip = getPlayerIP (player); 
        local serail = getPlayerSerial(player)
        return addBan(ip, nil, serail, "Guetto - AC", "Tentativa de fraude de um sistema! Banido Globalemente do MTA.", 0 )
    end
    
    decodeString('aes128', hash, {key = getPlayerSerial(player):sub(17), iv = iv}, function(decoded)
        local dados = fromJSON(decoded)
        local key = dados.key
        local type = dados.type
        local quantity = dados.amount
        
        if player then 
            if key == "vPoints" then 
                local genKey = generateCode(12)
                dbExec(db, "INSERT INTO keys (key, target, type, vip, quantity, timestamp) VALUES (?, ?, ?, ?, ?, ?)", genKey, getAccountName(getPlayerAccount(player)), "vPoints", nil, tonumber(quantity), getRealTime().timestamp)
                sendMessage("server", player, "Você criou um código de "..quantity.." vPoints com sucesso. [CTRL + V]", "success")
                triggerClientEvent(player, "squady.pasteKey", player, genKey)
                if config.logs.log then
                    messageDiscord("O(A) "..getPlayerName(player).." ("..pullID(player)..") criou um código de "..quantity.." vPoints", config.logs.web_hook)
                end
                attPanel(player)
            elseif key == "Vip" then 
                if not config.prices[type] then 
                    sendMessage("server", player, "Esse VIP não existe.", "error")
                else
                    local genKey = generateCode(12)
                    dbExec(db, "INSERT INTO keys (key, target, type, vip, quantity, timestamp) VALUES (?, ?, ?, ?, ?, ?)", genKey, getAccountName(getPlayerAccount(player)), "Vip", tostring(type), tonumber(quantity), getRealTime().timestamp)
                    sendMessage("server", player, "Você criou um código de "..quantity.." dia(s) do VIP "..type.." com sucesso. [CTRL + V]", "success")
                    triggerClientEvent(player, "squady.pasteKey", player, genKey)
                    if config.logs.log then
                        messageDiscord("O(A) "..getPlayerName(player).." ("..pullID(player)..") criou um código de "..quantity.." dia(s) do VIP "..type..".", config.logs.web_hook)
                    end
                    attPanel(player)
                end
            end
        end
    end)
end)

registerEvent("squady.deleteKeys", root, function(player, key)
    if player and key then 
        local result = dbPoll(dbQuery(db, "SELECT * FROM keys WHERE key = ?", key), -1)

        local account = getAccountName(getPlayerAccount(player));
    
        if not isObjectInACLGroup("user."..account, aclGetGroup("Console")) then 
            local ip = getPlayerIP (player); 
            local serail = getPlayerSerial(player)
            return addBan(ip, nil, serail, "Guetto - AC", "Tentativa de fraude de um sistema! Bandio Globalemente do MTA.", 0 )
        end
        
        if #result <= 0 then 
            sendMessage("server", player, "Esse código não existe.", "error")
        else
            dbExec(db, "DELETE FROM keys WHERE key = ?", key)
            sendMessage("server", player, "Você deletou o código com sucesso.", "success")
            if config.logs.log then
                messageDiscord("O(A) "..getPlayerName(player).." ("..pullID(player)..") deletou um código. ["..key.."]", config.logs.web_hook)
            end
            attPanel(player)
        end
    end
end)

addCommandHandler("usarkey", function(player, cmd, key)
    if player and key then 
        local result = dbPoll(dbQuery(db, "SELECT * FROM keys WHERE key = ?", key), -1)

        if #result <= 0 then 
            sendMessage("server", player, "Esse código não existe.", "error")
        else
            if result[1].type == "vPoints" then 
                local current_coins = (getElementData(player, config.panel.datacoins) or 0)
                setElementData(player, config.panel.datacoins, current_coins + result[1].quantity)
                sendMessage("server", player, "Você ativou "..result[1].quantity.." vPoints com sucesso.", "success")
                dbExec(db, "DELETE FROM keys WHERE key = ?", key)
                local resultc = dbPoll(dbQuery(db, "SELECT * FROM coins WHERE account = ?", account), -1)

                if #resultc > 0 then 
                    dbExec(db, "UPDATE coins SET quantity = ? WHERE account = ?", (resultc[1]["quantity"] + result[1].quantity), getAccountName(getPlayerAccount(player)))
                else
                    dbExec(db, "INSERT INTO coins (account, quantity) VALUES (?, ?)", getAccountName(getPlayerAccount(player)), result[1].quantity)
                end
                dbExec(db, "INSERT INTO last_activies (activator, id_activator, proprietary, id_proprietary, date, type, quantity, timestamp, value) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)", getPlayerName(player), pullID(player), getAccountName(getPlayerAccount(player)), pullID(player), getRealTime().timestamp, "vPoints", result[1].quantity, "Ativado", 1 * result[1].quantity)
                if config.logs.log then
                    messageDiscord("O(A) "..getPlayerName(player).." ("..pullID(player)..") ativou uma key de "..result[1].quantity.." vPoints.", config.logs.web_hook)
                end
                for i, v in ipairs(getElementsByType("player")) do 
                    triggerClientEvent(v, "squady.onDrawnActive", v, getAccountName(getPlayerAccount(player)), (getElementData(player, "ID") or "N/A"), result[1].quantity, "Pontos")
                end
                attPanel(player)
            elseif result[1].type == "Vip" then 
                local calculateDays = result[1]["quantity"] * 86400
                local result_vip = dbPoll(dbQuery(db, "SELECT * FROM vips WHERE account = ? AND vip = ?", getAccountName(getPlayerAccount(player)), result[1]["vip"]), -1)
            
                if #result_vip ~= 0 then 
                    sendMessage("server", player, "Você já possui esse VIP.", "error")
                else
                    dbExec(db, "DELETE FROM keys WHERE key = ?", key)
                    sendMessage("server", player, "Você ativou o VIP com sucesso.", "success")

                    aclGroupAddObject(aclGetGroup(result[1].vip), "user."..getAccountName(getPlayerAccount(player)))
                    dbExec(db, "INSERT INTO vips (account, id_account, vip, expiry_date) VALUES (?, ?, ?, ?)", getAccountName(getPlayerAccount(player)), (getElementData(player, "ID") or 0), result[1]["vip"], ((getRealTime().timestamp) + calculateDays))
                    dbExec(db, "INSERT INTO last_activies (activator, id_activator, proprietary, id_proprietary, date, type, quantity, timestamp, value) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)", getPlayerName(player), pullID(player), getAccountName(getPlayerAccount(player)), pullID(player), getRealTime().timestamp, result[1].vip, result[1]["quantity"], "Ativado", config.prices[result[1].vip])
                    if config.logs.log then
                        messageDiscord("O(A) "..getPlayerName(player).." ("..pullID(player)..") ativou uma key de "..result[1].quantity.." dia(s) do VIP "..result[1]["vip"]..".", config.logs.web_hook)
                    end
                    for i, v in ipairs(getElementsByType("player")) do 
                        triggerClientEvent(v, "squady.onDrawnActive", v, getAccountName(getPlayerAccount(player)), (getElementData(player, "ID") or "N/A"), result[1]["vip"])
                    end
                    attPanel(player)
                end
            end
        end
    end
end)

function attPanel(player)
    local result_vips = dbPoll(dbQuery(db, "SELECT * FROM vips"), -1)
    local result_last = dbPoll(dbQuery(db, "SELECT * FROM last_activies"), -1)
    local result_keys = dbPoll(dbQuery(db, "SELECT * FROM keys"), -1)

    if #result_vips >= 0 or #result_last >= 0 or #result_keys >= 0 then 
        triggerClientEvent(player, "squady.insertVipTable", player, result_vips)
        triggerClientEvent(player, "squady.insertLastTable", player, result_last)
        triggerClientEvent(player, "squady.insertKeysTable", player, result_keys)
    end
end

function getRestantTime(player, vip)
    if vip then 
        local result = dbPoll(dbQuery(db, "SELECT * FROM vips WHERE account = ? AND vip = ?", getAccountName(getPlayerAccount(player)), vip), -1)

        if not result then
            outputDebugString("Erro ao consultar o banco de dados.")
            return
        end

        if #result > 0 then
            local expirationTimestamp = tonumber(result[1]["expiry_date"])
            local currentTime = getRealTime().timestamp

            if not expirationTimestamp or not currentTime then
                outputDebugString("Erro ao obter timestamps.")
                return
            end

            local remainingTime = expirationTimestamp - currentTime

            if remainingTime > 0 then
                local remainingDays = math.floor(remainingTime / (24 * 60 * 60))

                return remainingDays
            end
        end
    end
end

function giveVIPByDiscord(infos)
    local splitInfos = split(infos, "@")
    local target = tonumber(splitInfos[1])
    local vip = splitInfos[2]
    local time = tonumber(splitInfos[3])
    if target and vip and time then 
        local _, account = exports["guetto_id2"]:getSerialByID(tonumber(target))
        if account then 
            if aclGetGroup(vip) then 
                local receiver = getPlayerFromID(target)
                local calculate_days = time * 86400
                local expiry_date = getRealTime().timestamp + calculate_days
                local result = dbPoll(dbQuery(db, "SELECT * FROM vips WHERE account = ? AND vip = ?", account, vip), -1)
                if #result == 0 then 
                    if receiver and isElement(receiver) then 
                        sendMessage("server", receiver, "Foi ativado um VIP "..vip.." de "..time.." dia(s) na sua conta.", "info")
                    end
                    aclGroupAddObject(aclGetGroup(vip), "user."..account)
                    dbExec(db, "INSERT INTO vips (account, id_account, vip, expiry_date) VALUES (?, ?, ?, ?)", account, tonumber(target), vip, expiry_date)
                    dbExec(db, "INSERT INTO last_activies (activator, id_activator, proprietary, id_proprietary, date, type, quantity, timestamp, value) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)", 'Discord', '0', account, target, getRealTime().timestamp, vip, time, "Ativado", config.prices[vip])
                    sendMessage("server", player, "Você setou o VIP no jogador(a) com sucesso.", "success")
                    for i, v in ipairs(getElementsByType("player")) do 
                        triggerClientEvent(v, "squady.onDrawnActive", v, account, target, vip)
                    end
                    if config.logs.log then
                        messageDiscord("Discord setou um VIP "..vip.." de "..time.." dia(s) no jogador "..account.." ("..target..").", config.logs.web_hook)
                    end
                    return '🤖 Vip ativado com sucesso!'
                else
                    return '🤖 Esse Jogador já possui esse vip!'
                end
            else
                return '🤖 Acl não encontrada!'
            end
        else
            return '🤖 Não foram encontrado dados desse jogador!'
        end
    end
end

function activeVPDiscord(infos)
    local splitInfos = split(infos, "@")
    local target = tonumber(splitInfos[1])
    local quantity = splitInfos[2]
    if target and quantity then 
        local _, account = exports["guetto_id2"]:getSerialByID(tonumber(target))
        if account then 
            local receiver = getPlayerFromID(target)
            if receiver and isElement(receiver) then
                local current_coins = (getElementData(receiver, config.panel.datacoins) or 0)
                setElementData(receiver, config.panel.datacoins, current_coins + quantity)
                sendMessage("server", receiver, "Foi ativo "..quantity.." coins na sua conta.", "success")
            end
            local result = dbPoll(dbQuery(db, "SELECT * FROM coins WHERE account = ?", account), -1)
            if #result > 0 then 
                dbExec(db, "UPDATE coins SET quantity = ? WHERE account = ?", (result[1]["quantity"] + quantity), account)
            else
                dbExec(db, "INSERT INTO coins (account, quantity) VALUES (?, ?)", account, quantity)
            end
            
            dbExec(db, "INSERT INTO last_activies (activator, id_activator, proprietary, id_proprietary, date, type, quantity, timestamp, value) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)", 'Discord', '0', account, target, getRealTime().timestamp, config.panel.datacoins, quantity, "Ativado", 1 * quantity)
            if config.logs.log then
                messageDiscord("Discord setou "..tonumber(quantity).." coins na conta do jogador(a) "..account.." ("..target.."", config.logs.web_hook)
            end
            for i, v in ipairs(getElementsByType("player")) do 
                triggerClientEvent(v, "squady.onDrawnActive", v, account, target, quantity, "Pontos")
            end
        end
    end
end

function generateCode(number)
    letters = {'a', 'A', 'b', 'B', 'c', 'C', 'd', 'D', 'e', 'E', 'f', 'F', 'g', 'G', 'h', 'H', 'i', 'I', 'j', 'J', 'k', 'K', 'l', 'L', 'm', 'M', 'n', 'N', 'o', 'O', 'p', 'P', 'q', 'Q', 'r', 'R', 's', 'S', 't', 'T', 'u', 'U', 'v', 'V', 'w', 'W', 'x', 'X', 'y', 'Y', 'z', 'Z', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0'}
    sas = ''
    for i = 1, number do 
        sas = sas ..letters[math.random(#letters)]
    end
    return sas
end

registerEvent("squady.getAllInfos", root, function(player)
    local accountName = getAccountName(getPlayerAccount(player))
    local result = dbPoll(dbQuery(db, "SELECT * FROM vips WHERE account = ?", accountName), -1)

    if not result then
        outputDebugString("Erro ao consultar o banco de dados.")
        return
    end

    local vipInfo = {}

    for _, vipData in ipairs(result) do
        local vip = vipData["vip"]
        local expirationTimestamp = tonumber(vipData["expiry_date"])
        local currentTime = getRealTime().timestamp

        if expirationTimestamp and currentTime then
            local remainingTime = expirationTimestamp - currentTime

            if remainingTime > 0 then
                local remainingDays = math.floor(remainingTime / (24 * 60 * 60))

                local vipInfoEntry = {
                    vip = vip,
                    remainingDays = remainingDays
                }

                table.insert(vipInfo, vipInfoEntry)
            end
        end
    end

    triggerClientEvent(player, "squady.onServerSendVipInfo", player, vipInfo)
end)

addEventHandler("onPlayerLogin", getRootElement(), function()
    if source and isElement(source) then 
        local result = dbPoll(dbQuery(db, "SELECT * FROM coins WHERE account = ?", getAccountName(getPlayerAccount(source))), -1)

        if result and #result > 0 then 
            setElementData(source, config.panel.datacoins, tonumber(result[1]["quantity"]))
        else
            setElementData(source, config.panel.datacoins, 0)
        end
    end
end)

addEventHandler("onPlayerQuit", getRootElement(), function()
    local result = dbPoll(dbQuery(db, "SELECT * FROM coins WHERE account = ?", getAccountName(getPlayerAccount(source))), -1)

    if result and #result > 0 then 
        dbExec(db, "UPDATE coins SET quantity = ? WHERE account = ?", (getElementData(source, config.panel.datacoins) or 0), getAccountName(getPlayerAccount(source)))
    else
        dbExec(db, "INSERT INTO coins (account, quantity) VALUES (?, ?)", getAccountName(getPlayerAccount(source)), (getElementData(source, config.panel.datacoins) or 0))
    end
end)

addEventHandler("onPlayerLogout", getRootElement(), function()
    local result = dbPoll(dbQuery(db, "SELECT * FROM coins WHERE account = ?", getAccountName(getPlayerAccount(source))), -1)

    if result and #result > 0 then 
        dbExec(db, "UPDATE coins SET quantity = ? WHERE account = ?", (getElementData(source, config.panel.datacoins) or 0), getAccountName(getPlayerAccount(source)))
    else
        dbExec(db, "INSERT INTO coins (account, quantity) VALUES (?, ?)", getAccountName(getPlayerAccount(source)), (getElementData(source, config.panel.datacoins) or 0))
    end
end)

function updatePoints(account, quantity)
    if account and quantity then
        local result = dbPoll(dbQuery(db, "SELECT * FROM coins WHERE account = ?", account), -1)
        if #result > 0 then 
            dbExec(db, "UPDATE coins SET quantity = ? WHERE account = ?", tonumber(quantity), account)
        else
            dbExec(db, "INSERT INTO coins (account, quantity) VALUES (?, ?)", account, tonumber(quantity))
        end
    end
end