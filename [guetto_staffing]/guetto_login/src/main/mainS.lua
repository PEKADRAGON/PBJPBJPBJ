
local database = dbConnect("sqlite", "src/database/dados.db");

addEventHandler("onResourceStart", resourceRoot, function ( )

    if (database and isElement(database)) then 
        print("["..getResourceName(getThisResource()).."] Database conectada!")
    else
        print("["..getResourceName(getThisResource()).."] Database não conectada!")
    end;
    
    dbExec(database, "CREATE TABLE IF NOT EXISTS `Login` (`accountName` TEXT NOT NULL, `password` TEXT NOT NULL, `serial` TEXT NOT NULL, `search` TEXT NOT NULL)")

end)

registerEventHandler('guetto.login', resourceRoot, function ( player, hash, iv )
    decodeString('aes128', hash, {key = getPlayerSerial(player):sub(17), iv = iv}, function (decode)
        local data = fromJSON(decode);
        local account = getAccount(data.user, data.password)
        
        if not account then
            return config.sendMessageServer(player, "Usuário ou senha incorretos!", "error")
        end; 

        local query = dbPoll(dbQuery(database, "SELECT * FROM `Login` WHERE `accountName` = ?", data.user), -1)

        if #query == 0 then 
            return config.sendMessageServer(player, "Usuário ou senha incorretos!", "error") 
        end

        local logged = logIn(player, account, data.password)

        if not logged then
            return config.sendMessageServer(player, "Você já está logado!", "error")
        end;

        config.sendMessageServer(player, "Bem vindo (a) ao Guetto City!", "successs")
        triggerEvent("guetto.onPlayerOpenCharacters", player)
        triggerClientEvent(player, "guetto.hidden.login", resourceRoot)
        messageDiscord("[LOGIN] Usuário: "..data.user.."\nSenha: "..md5(data.password), config["logs"]["login"])
    end)
end)

registerEventHandler("guetto.register", resourceRoot, function ( player, hash, iv )

    decodeString('aes128', hash, {key = getPlayerSerial(player):sub(17), iv = iv}, function (decode)
        local data = fromJSON(decode);
        local account = getAccount(data.user)

        if account then
            return config.sendMessageServer(player, "Usuário já existe!", "error")
        end;

        local query = dbPoll(dbQuery(database, "SELECT * FROM `Login` WHERE `accountName` = ?", data.user), -1)
        
        if query and #query ~= 0 then 
            return config.sendMessageServer(player, "Usuário já existe!", "error")
        end;

        local serial = getPlayerSerial(player)
        local query = dbPoll(dbQuery(database, "SELECT * FROM `Login` WHERE `serial` = ?", serial), -1)

        if query and #query >= config["Others"]["max.accounts"] then 
            return config.sendMessageServer(player, "Limite máximo de contas atingido!", "error")
        end;

        if addAccount(data.user, data.password) then 
            local AccountAdded = getAccount(data.user)

            if not AccountAdded then 
                return config.sendMessageServer(player, "Não foi possível cadastar sua conta!", "error")
            end;

            dbExec(database, "INSERT INTO `Login` VALUES (?, ?, ?, ?)", data.user, md5(data.password), serial, data.search)
            config.sendMessageServer(player, "Conta cadastrada!, Bem-vindo(a).", "success")

            triggerClientEvent(player, "guetto.hidden.register", resourceRoot)
            messageDiscord(" [NOVA CONTA] Usuário: "..data.user.."\nSenha: "..md5(data.password), config["logs"]["register"])
        else
            return config.sendMessageServer(player, "Não foi possível cadastar sua conta!", "error")
        end
    end)
end)

registerEventHandler("guetto.recover.accounts", resourceRoot, function ( player )

    local serial = getPlayerSerial(player)
    local query = dbPoll(dbQuery(database, "SELECT * FROM `Login` WHERE `serial` = ?", serial), -1)

    if query and #query ~= 0 then 
        triggerClientEvent(player, "guetto.send.client.accounts", resourceRoot, query)
    end;

end)

registerEventHandler('guetto.recover', resourceRoot, function  ( player, hash, iv )
    decodeString('aes128', hash, {key = getPlayerSerial(player):sub(17), iv = iv}, function (decode)
        local data = fromJSON(decode);
        local account = getAccount(data.user)

        if not account then
            return config.sendMessageServer(player, "Conta não encontrada!", "error")
        end; 

        local query = dbPoll(dbQuery(database, "SELECT * FROM `Login` WHERE `accountName` = ?", data.user), -1)

        if query and #query == 0 then 
            return config.sendMessageServer(player, "Conta não encontrada!", "error")
        end;

        setAccountPassword(getAccount(data.user), data.password)

        dbExec(database, "UPDATE `Login` SET `password` = ? WHERE `accountName` = ?", md5(data.password), data.user)
        config.sendMessageServer(player, "Senha da conta alterada com sucesso!", "successs")
        triggerClientEvent(player, "guetto.update.password", resourceRoot, data.user, data.password)
    end)
end)


registerEventHandler('guetto.request.login', resourceRoot, function ( player, hash, iv )

    if source ~= resourceRoot then 
        return false;
    end

    if client ~= player then 
        return 
    end

    if isGuestAccount(getPlayerAccount(player)) then 
        triggerClientEvent(player, 'guetto.open.login', resourceRoot)
    end

end)

addCommandHandler('changeserial', function(player, cmd, account, serial)
    local accountName = getAccountName ( getPlayerAccount ( player ) )
    if not isObjectInACLGroup('user.'..accountName, aclGetGroup('Console')) then 
        return 
    end

    if not account then 
        return config.sendMessageServer(player, 'Digite a conta do jogador!', 'error')
    end

    if not serial then 
        return config.sendMessageServer(player, 'Digite o novo serial do jogador!', 'error')
    end

    local query = dbPoll(dbQuery(database, "SELECT * FROM `Login` WHERE `accountName` = ?", account), -1)
    
    if #query == 0 then 
        return config.sendMessageServer(player, 'Conta não encontrada!', 'error')
    end

    dbExec(database, "UPDATE `Login` SET `serial` = ? WHERE `accountName` = ?", serial, account)
    
    config.sendMessageServer(player, 'Serial atualizado com sucesso!', 'info')
end)

addEventHandler('onPlayerJoin', root, function()
    setElementFrozen(source, true)
    toggleAllControls(source, false)
end)

addEventHandler("onPlayerLogin", root, function ( )
    setElementFrozen(source, false)
    toggleAllControls(source, true)
end)