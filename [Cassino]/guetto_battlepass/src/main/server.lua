local database = dbConnect('sqlite', 'src/database/database.db');
local instance = {}
instance.player = {}
instance.days = 0;

local notify = {
    season = "https://discord.com/api/webhooks/1245310235200192512/BsuYULFJZQv9Z97JYmWGLML1DNiK0-_4L3F0kqf2XoJU9lik079owDg-f0Y4Xl3XcVk_";
    collected = "https://discord.com/api/webhooks/1256630789819338812/2r9kYP9Dd29P9-vOvDnJMa8dWNwXoIvxL6DYbCTg07sokSyYZbdKs2tYYDAoXIr97XcG";
    buy = "https://discord.com/api/webhooks/1245310235200192512/BsuYULFJZQv9Z97JYmWGLML1DNiK0-_4L3F0kqf2XoJU9lik079owDg-f0Y4Xl3XcVk_",
}



function loadPlayerDados ( player )
    if not (player) then 
        return false;
    end

    local accountName = getAccountName (getPlayerAccount(player))
    local result = dbPoll(dbQuery(database, 'select * from `Itens_Collected` where `accountName` = ?', accountName), -1)

    if #result ~= 0 then 
        instance.player[accountName] = {
            data = fromJSON(result[1].Itens);
            premium = result[1].Premium;
        };
    else
        instance.player[accountName] = {
            data = {
                standart = {};
                premium = {};
            };
            premium = 'nil'
        }
        dbExec(database, 'insert into `Itens_Collected` VALUES (?, ?, ?)', accountName, 'nil', toJSON(instance.player[accountName].data))
    end
end

function loadPlayerLevel ( player )
    if not (player) then 
        return false 
    end;
    local accountName = getAccountName(getPlayerAccount(player));
    local result = dbPoll(dbQuery(database, 'SELECT * FROM `Level` WHERE `accountName` = ?', accountName), - 1)
    if #result ~= 0 then 
        setElementData(player, config['others'].level, tonumber(result[1].Level))
    else
        setElementData(player, config['others'].level, 0)
        dbExec(database, 'INSERT INTO `Level` VALUES ( ?, ? ) ', accountName, 0)
    end
end

function savePlayerLevel ( player )
    if not (player) then 
        return false 
    end;
    local accountName = getAccountName(getPlayerAccount(player));
    local result = dbPoll(dbQuery(database, 'SELECT * FROM `Level` WHERE `accountName` = ?', accountName), - 1)
    if #result == 0 then 
        dbExec(database, 'INSERT INTO `Level` VALUES ( ?, ? ) ', accountName, 0)
    else
        local level = (getElementData(player, config['others'].level) or 0)
        dbExec(database, 'UPDATE `Level` SET `Level` = ? WHERE `accountName` = ? ', level, accountName) 
    end
end

function getPlayerData ( player )
    if not (player) then 
        return false;
    end

    local accountName = getAccountName (getPlayerAccount(player))

    return instance.player[accountName] or {
        data = {
            standart = {};
            premium = {};
        };

        premium = 'nil'
    }
end

function isPlayerCollectedItem (player, type, index)
    if not (getPlayerData(player)) then 
        return false 
    end
    for i, v in pairs (getPlayerData(player).data[type]) do 
        if v == index then 
            return true, i 
        end
    end
    return false
end

function updateClient (player)
    if not ( player or getPlayerData(player)) then 
        return false 
    end
    return triggerClientEvent(player, "onClientUpdateInfos", resourceRoot, getPlayerData(player))
end

function getDaysRemaining ( )
    local current = getRealTime().timestamp;
    local timeRemaining = instance.days - current
    local endTime = math.floor ( timeRemaining / 86400 )
    return endTime;
end

function resetPlayerData ( player )
    if not player then 
        return false 
    end

    local accountName = getAccountName(getPlayerAccount(player));

    if not instance.player[accountName] then 
        return false 
    end

    instance.player[accountName] = {
        data = {
            standart = {};
            premium = {};
        };
        premium = 'nil'
    }

    dbExec(database, 'UPDATE `Itens_Collected` SET `Itens` = ?, `Premium` = ? WHERE `accountName` = ?', toJSON(instance.player[accountName].data), 'nil', accountName)
end

createEventHandler("onPlayerCollectedItems", resourceRoot, function ( data )
    if not (client or ( source ~= resourceRoot ) ) then 
        return false;
    end

    if type(data) ~= 'table' then 
        return false 
    end

    if isGuestAccount (getPlayerAccount(client)) then 
        return false 
    end;

    local playerData = getPlayerData ( client );

    if not playerData then 
        return false
    end;

    local type, index = data[3], tonumber(data[4]);
    local settings = config.itens[type][index]

    if type == 'premium' and playerData.premium == 'nil' then 
        return sendMessageServer(client, 'Você não é premium!', 'error')
    end;

    local level = (getElementData(client, config['others'].level) or 0);
    local target = config.levels[type] * index;

    if level < target then 
        return sendMessageServer (client, 'Você não possui level suficiente para resgatar essa recompensa!', 'error')
    end;

    if not settings then 
        return false 
    end;

    local accountName = getAccountName(getPlayerAccount(client));

    if getDaysRemaining() <= 0 then 
        return sendMessageServer(client, "A Tempora foi finalizada!", "info")
    end

    if isPlayerCollectedItem(client, type, index) then
        return sendMessageServer(client, 'Você já coletou essa recompensa!', 'error')
    end;

    table.insert(instance.player[accountName].data[type], index)
    dbExec(database, 'UPDATE `Itens_Collected` SET `Itens` = ? WHERE `accountName` = ?', toJSON(instance.player[accountName].data), accountName)

    givePlayerReward(client, settings)
    sendMessageServer(client, 'Recompensa coletada com sucesso!', 'success')

    local playerName = getPlayerName(client)
    local playerID = getElementData(client, "ID") or "N/A"
    local reward = settings.item
 
    outputChatBox("#FF4500 ➥ [Passe Gangster] #FFFFFFJogador #FFD700" .. playerName .. " #FFFFFF(ID: #00BFFF" .. playerID .. "#FFFFFF) acabou de resgatar a recompensa: #32CD32" .. reward .. " #FFFFFFno Passe de Batalha!", root, 255, 255, 255, true)
    sendLogs("🎁 Recompensa Resgatada!", "**Jogador:** " .. playerName .. " (ID: " .. playerID .. ")\n**Recompensa:** " .. settings.item, notify.collected)
    updateClient(client)
end)

createEventHandler("onPlayerGetInfos", resourceRoot, function ( )
    if not (client or ( source ~= resourceRoot ) ) then 
        return false 
    end;
    local data = getPlayerData(client);
    triggerClientEvent(client, "onPlayerToggleInterface", resourceRoot, data, getDaysRemaining())
end)

createEventHandler('onPlayerBuyBattlePass', resourceRoot, function ( )
    if not (client or ( source ~= resourceRoot ) ) then 
        return false 
    end;

    local coins = (getElementData(client, 'guetto.points') or 0);
    
    if coins < config.others.price then 
        return sendMessageServer(client, 'Você não possui coins suficientes!', 'error')
    end

    local playerName = getPlayerName(client)
    local playerID = getElementData(client, "ID") or "N/A"

    local title = "💰 Nova Compra"
    local description = "🔍 Passe Gangster! **Jogador:** "..playerName.. " (ID: " .. playerID .. ") Comprou o passe de batalha!"

    local accountName = getAccountName(getPlayerAccount(client));
    local data = getPlayerData(client);
    
    if not data then 
        return sendMessageServer(client, 'Houve um erro ao prosseguir com sua compra, contate um administrador!', 'info')
    end;

    if data.premium ~= 'nil' then 
        return sendMessageServer(client, 'Você já possui o passe de batalha!', 'info')
    end;

    sendLogs(title, description, notify.buy)
    setElementData(client, "guetto.points", coins - config.others.price)
    outputChatBox("#FF4500 [Passe Gangster] #FFFFFFJogador #FFD700" .. playerName .. " #FFFFFF(ID: #00BFFF" .. playerID .. "#FFFFFF) acabou de adquirir o passa de batalha!", root, 255, 255, 255, true)
    sendMessageServer(client, 'Você comprou o passe de batalha com sucesso!', 'success')

    instance.player[accountName].premium = 'true'
    dbExec(database, 'UPDATE `Itens_Collected` SET `Premium` = ? WHERE `accountName` = ?', instance.player[accountName].premium, accountName)
    updateClient(client)
end)

setTimer(function ( )
    if getDaysRemaining() <= 0 then 
      
        local current = getRealTime().timestamp;
        local days = 30 * 86400

        local title = "🔥 Passe de Batalha: Nova Temporada! 🔥"
        local description = "A nova temporada do Passe de Batalha chegou com novidades imperdíveis e recompensas exclusivas! Entre agora e confira tudo o que preparamos para você!"

        dbExec(database, "UPDATE `New_Season` SET `days` = ?", current + days)
        sendLogs(title, description, notify.season)

        dbExec(database, 'DELETE FROM `Itens_Collected`')

        outputChatBox("#FF4500 [Passe Gangster] #FFFFFF Nova temporada do passe de batalha chegou! Confira agora as novidades.", root, 255, 255, 255, true)

        for i, v in ipairs (getElementsByType('player')) do 
            loadPlayerDados(v)
            updateClient(v)
        end

        instance.days = current + days;
    end

end, 60000, 0)

addEventHandler('onPlayerLogin', root, function()
    loadPlayerDados(source)
    loadPlayerLevel(source)
end)

addEventHandler('onPlayerQuit', root, function ( )
    savePlayerLevel(source)
end)

addCommandHandler('resetpass', function ( player, cmd, id )
    if isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(player)), aclGetGroup('Console')) then 
        if not id then 
            return sendMessageServer(player, 'Digite o id do jogador!', 'info')
        end
        local target = getPlayerFromID ( id )
        if not target then 
            return sendMessageServer(player, 'Jogador não encontrado!', 'error')
        end
        local accountName = getAccountName(getPlayerAccount(target));
        if resetPlayerData(target) then 
            sendMessageServer(player, 'Você resetou o passe de batalha do jogador com sucesso!', 'info')
        else
            sendMessageServer(player, 'Esse jogador não possui um passe de batalha!', 'error')
        end
    end
end)

addCommandHandler('setlevelpass', function (player, cmd, id, qnt)
    if isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(player)), aclGetGroup('Console')) then 
        if not id then 
            return sendMessageServer(player, 'Digite o id do jogador!', 'info')
        end
        if not qnt then 
            return sendMessageServer(player, 'Digite a quantidade de level!', 'error')
        end
        local target = getPlayerFromID ( id )
        if not target then 
            return sendMessageServer(player, 'Jogador não encontrado!', 'error')
        end
        setElementData(target, config['others'].level, tonumber(qnt))
        sendMessageServer(player, 'Você setou level com sucesso no jogador!', 'info')
    end
end)

setTimer(function()
    for i, player in ipairs ( getElementsByType ( 'player' ) ) do 
        local level = getElementData(player, config['others'].level) or 0
        setElementData(player, config['others'].level, level + 1)
    end
end, 60 * 60000, 0 )    


addEventHandler('onResourceStart', resourceRoot, function ( )
    if not (database or not isElement(database)) then 
        return print ((getResourceName(getThisResource()))..' Database is failed to conect.')
    end;

    dbExec(database, 'CREATE TABLE IF NOT EXISTS `Itens_Collected` (`accountName` TEXT NOT NULL, `Premium` TEXT NO NULL, `Itens` JSON NOT NULL) ')
    dbExec(database, 'CREATE TABLE IF NOT EXISTS `New_Season` (`days` TEXT NOT NULL) ')
    dbExec(database, 'CREATE TABLE IF NOT EXISTS `Level` (`accountName` TEXT NOT NULL, `Level` TEXT NOT NULL) ')
    
    local result = dbPoll(dbQuery(database, 'select * from `New_Season`'), -1)
    
    if #result ~= 0 then 
        instance.days = tonumber(result[1].days);
        if getRealTime().timestamp >= tonumber(result[1].days) then 
            local current = getRealTime().timestamp;
            local days = 30 * 86400

            local title = "🔥 Passe de Batalha: Nova Temporada! 🔥"
            local description = "A nova temporada do Passe de Batalha chegou com novidades imperdíveis e recompensas exclusivas! Entre agora e confira tudo o que preparamos para você!"

            dbExec(database, "UPDATE `New_Season` SET `days` = ?", current + days)
            sendLogs(title, description, {}, notify.season)

            instance.days = current + days;
        end
    else
        local current = getRealTime().timestamp;
        local days = 30 * 86400

        local title = "🔥 Passe de Batalha: Nova Temporada! 🔥"
        local description = "Uma nova temporada do Passe de Batalha acaba de começar na cidade! Entre agora e descubra todas as novidades e recompensas exclusivas!"

        dbExec(database, "INSERT INTO `New_Season` VALUES (?)", current + days)
        sendLogs(title, description, notify.season)

        instance.days = current + days;
    end

    for _, player in ipairs (getElementsByType('player')) do 
        loadPlayerDados(player)
        loadPlayerLevel(player)
    end
    
    print ((getResourceName(getThisResource()))..'Is database conected whit success')
end)