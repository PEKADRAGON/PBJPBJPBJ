local server = {
    vehicle = {};
    verification = false;
    timer = {};

    databases = {
      --  conce = {db = dbConnect('sqlite', ':[BVR]Conce/src/database/database.db'), tbl = 'Garagem'};
      --  login = {db = dbConnect('sqlite', ':[BVR]Login/src/database/dados.db'), tbl = 'Login'};
        save = {db = dbConnect('sqlite', ':guetto_savesystem/dados.db'), tbl = 'SaveSystem'};
        --bank = {db = dbConnect('sqlite', ':[BVR]Bank/src/database/database.db'), tbl = 'Bank'};
        inv = {db = dbConnect('sqlite', ':guetto_inventory/src/database/dados.db'), tbl = 'Inventory'};
       -- group = {db = dbConnect('sqlite', ':[BVR]GroupPanel/assets/database/database.db'), tbl = 'Membros'};
        id = {db = dbConnect('sqlite', ':guetto_id2/assets/database/IDs.sqlite'), tbl = 'setId'}
    };
}

local timeDesc = {
    ["minutes"] = 60;
    ["hours"] = 3600;
    ["days"] = 86400;
    ["permanent"] = 0;
}

local db = dbConnect("sqlite", "assets/database/database.sqlite")
dbExec(db, "CREATE TABLE IF NOT EXISTS punishs (account, id, time, author, reason)")
dbExec(db, "CREATE TABLE IF NOT EXISTS last_actions (data, timestamp)")

addEventHandler("onResourceStart", resourceRoot, function()
    if db then 
        outputDebugString("Admin System database connected")
    else
        outputDebugString("Admin System database not connected")
    end
    
    setTimer(function()
        for _, player in ipairs(getElementsByType("player")) do 
            if (not isGuestAccount(getPlayerAccount(player))) then 
                local cache = dbPoll(dbQuery(db, "SELECT * FROM punishs WHERE account = ?", getAccountName(getPlayerAccount(player))), -1)

                if (cache and #cache > 0) then 
                    executePrison(player, cache[1].time, cache[1].author, cache[1].reason)
                end
            end
        end
    end, 1000, 1)
end)

registerEvent("squady.verifyAdminPanel", resourceRoot, function()
    if client and isElement(client) then 
        player = client
    end

    if (source ~= resourceRoot) then 
        return
    end

    if isPlayerInACL(player, config.adminPanel.permissions) then 
        sendData(player)
        triggerClientEvent(player, "squady.openAdminPanel", player, server.verification)
    end
end)

resource_states = {
    ["loaded"] = "Carregado";
    ["running"] = "Ligado";
    ["starting"] = "Ligando";
    ["stopping"] = "Parando";
    ["failed to load"] = "Falha ao carregar";
};

function sendData(player)
    data_resources = {}
    data_players = {}
    group_list = {}

    for i, v in ipairs(getResources()) do
        local author = getResourceInfo(v, "author")
        local version = getResourceInfo(v, "version")

        table.insert (data_resources, {name = getResourceName(v), state = resource_states[getResourceState(v)], author = author and author or "Não especificado", version = version and version or "Não especificado"})
    end

    for i, v in ipairs(getElementsByType("player")) do 
        table.insert(data_players, {
            account = getAccountName(getPlayerAccount(v)),
            acls = getPlayerAcls(v),
            element = v,
            money = getPlayerMoney(v),
        })
    end

    for i, v in ipairs(aclGroupList()) do 
        table.insert (group_list, {aclGroupGetName(v), aclGroupListObjects(v)})
    end

    local data_config = {fps_limit = getFPSLimit(), gravity = getGravity(), hour = getRealTime().hour..":"..getRealTime().minute, gamespeed = getGameSpeed(), wave_height = getWaveHeight(), time = getWeather()}
    local verify_acl = verifyACL(player, config.adminPanel.permissions)

    local result_bans = dbPoll(dbQuery(db, "SELECT * FROM punishs"), -1)
    local result_register = dbPoll(dbQuery(db, "SELECT * FROM last_actions"), -1)

    if #result_bans >= 0 then 
        result_bans = result_bans
    end

    if #result_register >= 0 then 
        result_register = result_register
    end

    local key = getPlayerSerial(player)    
    local hashtoKey = toJSON({resources = data_resources, groups = group_list, config = data_config, verify_acl = verify_acl, bans = result_bans, logs = result_register})
    encodeString('aes128', hashtoKey, {key = key:sub(17)}, function(enc, iv)
        triggerClientEvent(player, "squady.receiveDataAdminPanel", resourceRoot, player, enc, iv)
    end)
    
    triggerClientEvent(player, "squady.receiveDataPlayersPanel", player, data_players)
end

registerEvent("squady.manageResources", resourceRoot, function(hash, iv)
    if not client then
        return
    end

    local player = client

    decodeString('aes128', hash, {key = getPlayerSerial(player):sub(17), iv = iv}, function(decoded)
		if decoded then 
			local data = fromJSON(decoded)

            if data then 
                if data.type then 
                    local verify_acl = verifyACL(player, config.adminPanel.permissions)
            
                    if not verify_acl then 
                        sendMessage("server", player, "Erro na acl.", "error")
                        return
                    end

                    if not config.permissionsFunctions[verify_acl][data.type] then 
                        sendMessage("server", player, "Você não possui permissão para realizar essa ação.", "error")
                        return
                    end
            
                    if data.type == "start" then 
                        if data.name then 
                            local resource = getResourceFromName(data.name)
            
                            if getResourceState(resource) == "running" then 
                                sendMessage("server", player, "O recurso já está ligado.", "error")
            
                            elseif getResourceState(resource) == "loaded" then 
                                startResource(resource)
                                sendMessage("server", player, "Recurso ligado com sucesso.", "success")
                                registerLogs(""..getPlayerName(player).." ("..(getElementData(player, "ID") or "N/A")..") ligou o resource "..data.name..".")
                                if config.logs.log then
                                    messageDiscord(""..getPlayerName(player).." ("..pullID(player)..") ligou o resource "..data.name.."!", config.logs.web_hook)
                                end
                                local verify_acl = verifyACL(player, config.adminPanel.permissions)
            
                                if verify_acl then 
                                    sendData(player)
                                end
                            elseif getResourceState(resource) == "failed to load" then 
                                sendMessage("server", player, "Recurso aprenseta erros e não pode ser ligado.", "error")
                            end
                        end
            
                    elseif data.type == "stop" then 
                        if data.name then 
                            local resource = getResourceFromName(data.name)
            
                            if getResourceState(resource) == "running" then 
                                stopResource(resource)
                                sendMessage("server", player, "Recurso desligado com sucesso.", "success")
                                registerLogs(""..getPlayerName(player).." ("..(getElementData(player, "ID") or "N/A")..") desligou o resource "..data.name..".")
                                if config.logs.log then
                                    messageDiscord(""..getPlayerName(player).." ("..pullID(player)..") parou o resource "..data.name.."!", config.logs.web_hook)
                                end
                                local verify_acl = verifyACL(player, config.adminPanel.permissions)
            
                                if verify_acl then 
                                    setTimer(function()
                                        sendData(player)
                                    end, 1000, 1)
                                end
            
                            elseif getResourceState(resource) == "loaded" then 
                                sendMessage("server", player, "O recurso já está parado.", "error")
            
                            elseif getResourceState(resource) == "failed to load" then 
                                sendMessage("server", player, "Recurso aprenseta erros e não pode ser parado.", "error")
                            end
                        end
            
                    elseif data.type == "restart" then 
                        if data.name then 
                            local resource = getResourceFromName(data.name)
            
                            if getResourceState(resource) == "running" then 
                                restartResource(resource)
                                sendMessage("server", player, "Recurso reiniciado com sucesso.", "success")
                                registerLogs(""..getPlayerName(player).." ("..(getElementData(player, "ID") or "N/A")..") reiniciou o resource "..data.name..".")
                                if config.logs.log then
                                    messageDiscord(""..getPlayerName(player).." ("..pullID(player)..") reiniciou o resource "..data.name.."!", config.logs.web_hook)
                                end
            
                                local verify_acl = verifyACL(player, config.adminPanel.permissions)
            
                                if verify_acl then 
                                    setTimer(function()
                                        sendData(player)
                                    end, 1000, 1)
                                end
            
                            elseif getResourceState(resource) == "loaded" then 
                                sendMessage("server", player, "O recurso não está ligado, então não pode ser reiniciado.", "error")
            
                            elseif  getResourceState(resource) == "failed to load" then 
                                sendMessage("server", player, "Recurso aprenseta erros e não pode ser reiniciado.", "error")
                            end
                        end
                    end
                end
            end
		else
			outputDebugString("Decoding failed")
		end
	end)
end)

registerEvent("squady.executeCommandSerer", resourceRoot, function(hash, iv)

    if not client then
        return
    end

    local player = client

    decodeString('aes128', hash, {key = getPlayerSerial(player):sub(17), iv = iv}, function(decoded)
        if decoded then 
            local data = fromJSON(decoded)

            if data then 
                if data.command then 
                    local verify_acl = verifyACL(player, config.adminPanel.permissions)
            
                    if not verify_acl then 
                        sendMessage("server", player, "Erro na acl.", "error")
                        return
                    end

                    if not config.permissionsFunctions[verify_acl][data.type] then 
                        sendMessage("server", player, "Você não possui permissão para realizar essa ação.", "error")
                        return
                    end

                    local command_executed, msgError = loadstring("return "..data.command)

                    if msgError then 
                        command_executed, msgError = loadstring(data.command)
                    end

                    if msgError then 
                        sendMessage("server", player, "Falha ao executar o comando.", "error")
                        return
                    end

                    local results = {pcall(command_executed)}

                    if not results[1] then 
                        sendMessage("server", player, "Falha ao executar o comando.", "error")
                        return
                    end

                    local result_string = ""
                    local first = true

                    for i = 2, #results do 
                        if first then 
                            first = false
                        else
                            result_string = result_string..", "
                        end

                        local result_type = type(results[i])

                        if isElement(results[i]) then 
                            result_type = "element:"..getElementType(results[i])
                        end

                        result_string = result_string..tostring(results[i])
                    end

                    if #results > 1 then 
                        outputDebugString("Result command line: "..result_string)
                        sendMessage("server", player, "Comando executado com sucesso.", "success")
                        registerLogs(""..getPlayerName(player).." ("..(getElementData(player, "ID") or "N/A")..") executou um comando server. ["..data.command.."].")
                        return
                    end

                    sendMessage("server", player, "Comando executado com sucesso.", "success")
                end
            end
        else
            outputDebugString("Decoding failed")
        end
    end)
end)

registerEvent("squady.manageServerConfig", resourceRoot, function(hash, iv)

    if not client then
        return
    end

    local player = client

    decodeString('aes128', hash, {key = getPlayerSerial(player):sub(17), iv = iv}, function(decoded)
		if decoded then 
			local data = fromJSON(decoded)

            iprint(data)
            if data then
                if data.type and data.table then 
                    local verify_acl = verifyACL(player, config.adminPanel.permissions)

                    if not verify_acl then 
                        sendMessage("server", player, "Erro na acl.", "error")
                        return
                    end

                    if not config.permissionsFunctions[verify_acl][data.type] then 
                        sendMessage("server", player, "Você não possui permissão para realizar essa ação.", "error")
                        return
                    end

                    if data.type == "weather" then 
                        setWeather(data.table[1])
                        sendMessage("server", player, "Você alterou o clima para "..config.weatherTemp[data.table[1]]..".", "success")
                        registerLogs(""..getPlayerName(player).." ("..(getElementData(player, "ID") or "N/A")..") alterou o clima para "..config.weatherTemp[data.table[1]]..".")

                    elseif data.type == "time" then 
                        setTime(data.table[1], data.table[2])
                        sendMessage("server", player, "Você alterou o horário para "..data.table[1]..":"..data.table[2]..".", "success")
                        registerLogs(""..getPlayerName(player).." ("..(getElementData(player, "ID") or "N/A")..") alterou o horário para "..data.table[1]..":"..data.table[2]..".")

                    elseif data.type == "gamespeed" then 
                        setGameSpeed(data.table[1])
                        sendMessage("server", player, "Você alterou a velocidade do jogo para "..data.table[1]..".", "success")
                        registerLogs(""..getPlayerName(player).." ("..(getElementData(player, "ID") or "N/A")..") alterou a velocidade do jogo para "..data.table[1]..".")

                    elseif data.type == "waveheight" then
                        setWaveHeight(data.table[1])
                        sendMessage("server", player, "Você alterou a altura das ondas para "..data.table[1]..".", "success")
                        registerLogs(""..getPlayerName(player).." ("..(getElementData(player, "ID") or "N/A")..") alterou a altura das ondas para "..data.table[1]..".")

                    elseif data.type == "fpslimit" then
                        setFPSLimit(data.table[1])
                        --sendMessage("server", player, "Você alterou o limite de fps para "..data.table[1]..".", "success")
                        registerLogs(""..getPlayerName(player).." ("..(getElementData(player, "ID") or "N/A")..") alterou o limite de fps para "..data.table[1]..".")

                    elseif data.type == "gravitation" then 
                        setGravity(data.table[1])
                        sendMessage("server", player, "Você alterou a gravidade para "..data.table[1]..".", "success")
                        registerLogs(""..getPlayerName(player).." ("..(getElementData(player, "ID") or "N/A")..") alterou a gravidade para "..data.table[1]..".")

                    elseif data.type == "clear_chat" then 
                        clearChatBox()
                        outputChatBox("#C19F72[Guetto] #FFFFFFO jogador(a) #8d6af0"..getPlayerName(player).." #"..pullID(player).." #FFFFFFlimpou o chat com sucesso!", root, 255, 255, 255, true)
                        sendMessage("server", player, "Você limpou o chat com sucesso.", "success")
                        registerLogs(""..getPlayerName(player).." ("..(getElementData(player, "ID") or "N/A")..") limpou o chat.")

                        if config.logs.log then
                            messageDiscord(""..getPlayerName(player).." ("..pullID(player)..") limpou o chat do servidor.", config.logs.web_hook)
                        end

                    elseif data.type == "on_going_maintenance" then 
                        setGameType("|| SERVIDOR EM MANUTENÇÃO ||")
                        sendMessage("server", player, "Você alterou o gametype do servidor para manutenção.", "success")
                        registerLogs(""..getPlayerName(player).." ("..(getElementData(player, "ID") or "N/A")..") alterou o gametype do servidor para manutenção.")

                    elseif data.type == "set_password_automatic" then 
                        setServerPassword(config.adminPanel.automatic_password)
                        sendMessage("server", player, "Você alterou a senha do servidor para "..config.adminPanel.automatic_password..".", "success")
                        registerLogs(""..getPlayerName(player).." ("..(getElementData(player, "ID") or "N/A")..") alterou a senha do servidor para "..config.adminPanel.automatic_password..".")

                    elseif data.type == "start_maintenance" then 
                        setServerPassword(config.adminPanel.automatic_password)
                        setGameType("|| SERVIDOR EM MANUTENÇÃO ||")
                        
                        for i, v in ipairs(getElementsByType("player")) do
                            if aclGetGroup("Console") then 
                                if not isObjectInACLGroup("user."..pullAccount(v), aclGetGroup("Console")) then 
                                    kickPlayer(v, getPlayerName(player).." #"..pullID(player), "Servidor em manutenção, tente novamente mais tarde.")
                                end
                            end
                        end

                        sendMessage("server", player, "Você iniciou a manutenção do servidor.", "success")
                        registerLogs(""..getPlayerName(player).." ("..(getElementData(player, "ID") or "N/A")..") iniciou a manutenção do servidor.")

                    elseif data.type == "kick_all_players" then 
                        for i, v in ipairs(getElementsByType("player")) do
                            if aclGetGroup("STAFF") then 
                                if not isObjectInACLGroup("user."..pullAccount(v), aclGetGroup("STAFF")) then 
                                    kickPlayer(v, getPlayerName(player).." #"..pullID(player), "Servidor em manutenção, tente novamente mais tarde.")
                                end
                            end
                        end

                        sendMessage("server", player, "Você expulsou todos os jogadores do servidor.", "success")
                        registerLogs(""..getPlayerName(player).." ("..(getElementData(player, "ID") or "N/A")..") expulsou todos os jogadores do servidor.")

                    elseif data.type == "reset_password" then 
                        setServerPassword()
                        sendMessage("server", player, "Você removeu a senha do servidor.", "success")
                        registerLogs(""..getPlayerName(player).." ("..(getElementData(player, "ID") or "N/A")..") removeu a senha do servidor.")

                    elseif data.type == "set_password" then 
                        setServerPassword(data.table[1])
                        sendMessage("server", player, "Você alterou a senha do servidor para "..data.table[1]..".", "success")
                        registerLogs(""..getPlayerName(player).." ("..(getElementData(player, "ID") or "N/A")..") alterou a senha do servidor para "..data.table[1]..".")

                    elseif data.type == "set_gametype" then 
                        setGameType(data.table[1])
                        sendMessage("server", player, "Você alterou o gametype do servidor para "..data.table[1]..".", "success")
                        registerLogs(""..getPlayerName(player).." ("..(getElementData(player, "ID") or "N/A")..") alterou o gametype do servidor para "..data.table[1]..".")
                    end

                    local verify_acl = verifyACL(player, config.adminPanel.permissions)

                    if verify_acl then 
                        sendData(player)
                    end
                end
            end
		else
			outputDebugString("Decoding failed")
		end
	end)
end)

registerEvent("squady.manageGroups", resourceRoot, function(hash, iv)
    if not client then
        return
    end

    local player = client

    decodeString('aes128', hash, {key = getPlayerSerial(player):sub(17), iv = iv}, function(decoded)
		if decoded then 
			local data = fromJSON(decoded)

            if data then 

                if data.id and data.acl then 
                    local _, accountName = exports["guetto_id2"]:getSerialByID(data.id)

                    if not accountName then 
                        sendMessage("server", player, "Conta não encontrada.", "error")
                        return
                    end

                    local verify_acl = verifyACL(player, config.adminPanel.permissions)

                    if not verify_acl then 
                        sendMessage("server", player, "Erro na acl.", "error")
                        return
                    end

                    if config.permissionsFunctions[verify_acl]["manage_acl"] == false then 
                        sendMessage("server", player, "Você não possui permissão para realizar essa ação.", "error")
                        return
                    end
                    
                    if data.type == "add" then 
                        if aclGetGroup(data.acl) then 
                            if isObjectInACLGroup("user."..accountName, aclGetGroup(data.acl)) then
                                sendMessage("server", player, "O jogador já está nessa acl.", "error")
                            else
                                aclGroupAddObject(aclGetGroup(data.acl), "user."..accountName)
                                sendMessage("server", player, "Você adicionou o jogador na acl com sucesso.", "success")
                                registerLogs(""..getPlayerName(player).." ("..(getElementData(player, "ID") or "N/A")..") adicionou o jogador "..accountName.." na acl "..data.acl..".")
                                if config.logs.log then
                                    messageDiscord(""..getPlayerName(player).." ("..pullID(player)..") adicionou o jogador "..accountName.." na acl "..data.acl.."!", config.logs.web_hook)
                                end

                                local verify_acl = verifyACL(player, config.adminPanel.permissions)
                                if verify_acl then 
                                    sendData(player)
                                end
                            end
                        else
                            sendMessage("server", player, "A acl não existe.", "error")
                        end

                    elseif data.type == "remove" then 
                        if aclGetGroup(data.acl) then 
                            if isObjectInACLGroup("user."..accountName, aclGetGroup(data.acl)) then 
                                aclGroupRemoveObject(aclGetGroup(data.acl), "user."..accountName)
                                sendMessage("server", player, "Você removeu o jogador da acl com sucesso.", "success")
                                registerLogs(""..getPlayerName(player).." ("..(getElementData(player, "ID") or "N/A")..") removeu o jogador "..accountName.." da acl "..data.acl..".")
                                if config.logs.log then
                                    messageDiscord(""..getPlayerName(player).." ("..pullID(player)..") removeu o jogador "..accountName.." da acl "..data.acl.."!", config.logs.web_hook)
                                end
                                local verify_acl = verifyACL(player, config.adminPanel.permissions)
                                if verify_acl then 
                                    sendData(player)
                                end
                            else
                                sendMessage("server", player, "O jogador não está nessa acl.", "error")
                            end
                        else
                            sendMessage("server", player, "A acl não existe.", "error")
                        end
                    end
                elseif data.acl then 
                    if data.type == "destroy" then  
                        if aclGetGroup(data.acl) then 
                            aclDestroyGroup(aclGetGroup(data.acl))
                            sendMessage("server", player, "Você excluiu a acl com sucesso.", "success")
                            registerLogs(""..getPlayerName(player).." ("..(getElementData(player, "ID") or "N/A")..") excluiu a acl "..data.acl..".")
                            if config.logs.log then
                                messageDiscord(""..getPlayerName(player).." ("..pullID(player)..") excluiu a acl "..data.acl.."!", config.logs.web_hook)
                            end
                            local verify_acl = verifyACL(player, config.adminPanel.permissions)
                            if verify_acl then 
                                sendData(player)
                            end
                        else
                            sendMessage("server", player, "A acl não existe.", "error")
                        end

                    elseif data.type == "create" then 
                        if aclGetGroup(data.acl) then 
                            sendMessage("server", player, "A acl já existe.", "error")
                        else
                            aclCreateGroup(data.acl)
                            local verify_acl = verifyACL(player, config.adminPanel.permissions)
                            if verify_acl then 
                                sendData(player)
                            end
                            sendMessage("server", player, "Você criou a acl com sucesso.", "success")
                            registerLogs(""..getPlayerName(player).." ("..(getElementData(player, "ID") or "N/A")..") criou a acl "..data.acl..".")
                            if config.logs.log then
                                messageDiscord(""..getPlayerName(player).." ("..pullID(player)..") criou a acl "..data.acl.."!", config.logs.web_hook)
                            end
                        end
                    end
                end
            end
		else
			outputDebugString("Decoding failed")
		end
	end)
end)

registerEvent("squady.manageUser", resourceRoot, function(hash, iv)

    if not client then
        return
    end

    local player = client

    decodeString('aes128', hash, {key = getPlayerSerial(player):sub(17), iv = iv}, function(decoded)
		if decoded then 
			local data = fromJSON(decoded)

            if data then
                
                local receiver = getPlayerFromID(tonumber(data.id))

                if player and receiver then 
                    if data.type and data.edit then 
                        if isElement(receiver) then 
                            local verify_acl = verifyACL(player, config.adminPanel.permissions)

                            if not verify_acl then 
                                sendMessage("server", player, "Erro na acl.", "error")
                                return
                            end

                            if not config.permissionsFunctions[verify_acl][data.type] then 
                                sendMessage("server", player, "Você não possui permissão para realizar essa ação.", "error")
                                return
                            end

                            if data.type == "tphere" then 
                                if player ~= receiver then 
                                    local pos = {getElementPosition(player)}

                                    setElementPosition(receiver, pos[1], pos[2], pos[3]+1)
                                    sendMessage("server", player, "Você teleportou o jogador até você com sucesso.", "success")
                                    registerLogs(""..getPlayerName(player).." ("..(getElementData(player, "ID") or "N/A")..") teleportou o jogador "..getPlayerName(receiver).." ("..(getElementData(receiver, "ID") or "N/A")..") até ele.")
                                    if config.logs.log then
                                        messageDiscord(""..getPlayerName(player).." ("..pullID(player)..") teleportou o jogador "..getPlayerName(receiver).." ("..pullID(receiver)..") até ele!", config.logs.web_hook)
                                    end
                                else
                                    sendMessage("server", player, "Você não pode se teleportar para você mesmo.", "error")
                                end

                            elseif data.type == "tp" then 
                                if player ~= receiver then 
                                    local pos = {getElementPosition(receiver)}

                                    setElementPosition(player, pos[1], pos[2], pos[3]+1)
                                    sendMessage("server", player, "Você teleportou até o jogador com sucesso.", "success")
                                    registerLogs(""..getPlayerName(player).." ("..(getElementData(player, "ID") or "N/A")..") teleportou até o jogador "..getPlayerName(receiver).." ("..(getElementData(receiver, "ID") or "N/A")..").")
                                    if config.logs.log then
                                        messageDiscord(""..getPlayerName(player).." ("..pullID(player)..") teleportou até o jogador "..getPlayerName(receiver).." ("..pullID(receiver)..")!", config.logs.web_hook)
                                    end
                                else
                                    sendMessage("server", player, "Você não pode se teleportar para você mesmo.", "error")
                                end

                            elseif data.type == "spect" then 
                                local inTarget = getCameraTarget(player)
                                if inTarget == receiver then 
                                    if player ~= receiver then 
                                        setCameraTarget(player, player)
                                        sendMessage("server", player, "Você parou de spectar o jogador com sucesso.", "success")
                                    else
                                        sendMessage("server", player, "Você não pode parar de spectar você mesmo.", "error")
                                    end
                                else
                                    if player ~= receiver then 
                                        setCameraTarget(player, receiver)
                                        sendMessage("server", player, "Você começou a spectar o jogador com sucesso.", "success")
                                        registerLogs(""..getPlayerName(player).." ("..(getElementData(player, "ID") or "N/A")..") começou a spectar o jogador "..getPlayerName(receiver).." ("..(getElementData(receiver, "ID") or "N/A")..").")
                                        if config.logs.log then
                                            messageDiscord(""..getPlayerName(player).." ("..pullID(player)..") começou a spectar o jogador "..getPlayerName(receiver).." ("..pullID(receiver)..")!", config.logs.web_hook)
                                        end
                                    else
                                        sendMessage("server", player, "Você não pode spectar você mesmo.", "error")
                                    end
                                end

                            elseif data.type == "kick" then 
                                if player ~= receiver then 
                                    sendMessage("server", player, "Você expulsou o jogador com sucesso.", "success")
                                    registerLogs(""..getPlayerName(player).." ("..(getElementData(player, "ID") or "N/A")..") expulsou o jogador "..getPlayerName(receiver).." ("..(getElementData(receiver, "ID") or "N/A")..") com o seguinte motivo: "..data.edit..".")
                                    if config.logs.log then
                                        messageDiscord(""..getPlayerName(player).." ("..pullID(player)..") expulsou o jogador "..getPlayerName(receiver).." ("..pullID(receiver)..") com o seguinte motivo: "..data.edit..".", config.logs.web_hook)
                                    end
                                    kickPlayer(receiver, player, data.edit)
                                else
                                    sendMessage("server", player, "Você não pode se expulsar.", "error")
                                end

                            elseif data.type == "mute" then 
                                if player ~= receiver then 
                                    if (getElementData(receiver, "JOAO.muted") or false) then 
                                        setElementData(receiver, "JOAO.muted", false)
                                        sendMessage("server", player, "Você desmutou o jogador com sucesso.", "success")
                                        registerLogs(""..getPlayerName(player).." ("..(getElementData(player, "ID") or "N/A")..") desmutou o jogador "..getPlayerName(receiver).." ("..(getElementData(receiver, "ID") or "N/A")..").")
                                        if config.logs.log then
                                            messageDiscord(""..getPlayerName(player).." ("..pullID(player)..") desmutou o jogador "..getPlayerName(receiver).." ("..pullID(receiver)..")!", config.logs.web_hook)
                                        end
                                    else
                                        setElementData(receiver, "JOAO.muted", {
                                            ownerMuted = getPlayerName(player).." #"..(getElementData(player, "ID") or "N/A");
                                            reasonMuted = data.edit
                                        })
                                        sendMessage("server", player, "Você mutou o jogador com sucesso.", "success")
                                        registerLogs(""..getPlayerName(player).." ("..(getElementData(player, "ID") or "N/A")..") mutou o jogador "..getPlayerName(receiver).." ("..(getElementData(receiver, "ID") or "N/A")..") com o seguinte motivo: "..data.edit..".")
                                        if config.logs.log then
                                            messageDiscord(""..getPlayerName(player).." ("..pullID(player)..") mutou o jogador "..getPlayerName(receiver).." ("..pullID(receiver)..") com o seguinte motivo: "..data.edit..".", config.logs.web_hook)
                                        end
                                    end
                                else
                                    sendMessage("server", player, "Você não pode se mutar.", "error")
                                end

                            elseif data.type == "resetaccount" then 
                                if player ~= receiver then 
                                    local serial, account = exports['guetto_id2']:getSerialByID(tonumber(data.id))

                                    if serial and account then 
                                        if receiver and isElement(receiver) then 
                                            kickPlayer(receiver, player, "Todas as suas informações foram resetadas.")
                                            sendMessage("server", player, "Jogador expulso com sucesso.", "success")
                                        end

                                        dbExec(databases.conce.db, 'DELETE FROM '..databases.conce.tbl..' WHERE `accountName` = ? ', account)
                                        dbExec(databases.login.db, 'DELETE FROM '..databases.login.tbl..' WHERE `accountName` = ? ', account)
                                        dbExec(databases.save.db, 'DELETE FROM '..databases.save.tbl..' WHERE `Conta` = ? ', account)
                                        dbExec(databases.bank.db, 'DELETE FROM '..databases.bank.tbl..' WHERE `accountName` = ? ', account)
                                        dbExec(databases.inv.db, 'DELETE FROM '..databases.inv.tbl..' WHERE `accountName` = ? ', account)
                                        dbExec(databases.group.db, 'DELETE FROM '..databases.group.tbl..' WHERE `accountName` = ? ', account)
                                        dbExec(databases.id.db, 'DELETE FROM '..databases.id.tbl..' WHERE `user` = ? ', account)

                                        removeAccount(getAccount(account))
                                        removePlayerAcls(account)
                                        sendMessage("server", player, "Conta resetada com sucesso.", "success")
                                        registerLogs(""..getPlayerName(player).." ("..(getElementData(player, "ID") or "N/A")..") resetou a conta "..account..".")
                                        if config.logs.log then
                                            messageDiscord(""..getPlayerName(player).." ("..pullID(player)..") resetou a conta "..account.."!", config.logs.web_hook)
                                        end
                                    else
                                        sendMessage("server", player, "Dados do cidadão não foram encontrados em nossos registros.", "error")
                                    end
                                else
                                    sendMessage("server", player, "Você não pode resetar sua própria conta.", "error")
                                end

                            elseif data.type == "setnick" then 
                                if string.len(data.edit) > 16 then 
                                    sendMessage("server", player, "O nick não pode ter mais de 16 caracteres.", "error")
                                else
                                    setPlayerName(receiver, data.edit)
                                    sendMessage("server", player, "Você alterou o nick do jogador com sucesso.", "success")
                                    registerLogs(""..getPlayerName(player).." ("..(getElementData(player, "ID") or "N/A")..") alterou o nick do jogador "..getPlayerName(receiver).." ("..(getElementData(receiver, "ID") or "N/A")..") para "..data.edit..".")
                                    if config.logs.log then
                                        messageDiscord(""..getPlayerName(player).." ("..pullID(player)..") alterou o nick do jogador "..getPlayerName(receiver).." ("..pullID(receiver)..") para "..data.edit..".", config.logs.web_hook)
                                    end
                                end

                            elseif data.type == "setvida" then 
                                local quantity = tonumber(data.edit)

                                if not quantity then 
                                    sendMessage("server", player, "Valor inválido.", "error")
                                    return
                                end

                                if quantity > 100 then 
                                    sendMessage("server", player, "Não é possível setar mais que 100% de vida.", "error")
                                else
                                    setElementHealth(receiver, quantity)
                                    sendMessage("server", player, "Você alterou a vida do jogador com sucesso.", "success")
                                    registerLogs(""..getPlayerName(player).." ("..(getElementData(player, "ID") or "N/A")..") alterou a vida do jogador "..getPlayerName(receiver).." ("..(getElementData(receiver, "ID") or "N/A")..") para "..quantity..".")
                                    if config.logs.log then
                                        messageDiscord(""..getPlayerName(player).." ("..pullID(player)..") alterou a vida do jogador "..getPlayerName(receiver).." ("..pullID(receiver)..") para "..quantity..".", config.logs.web_hook)
                                    end
                                end
                                
                            elseif data.type == "setcolete" then 
                                local quantity = tonumber(data.edit)

                                if not quantity then 
                                    sendMessage("server", player, "Valor inválido.", "error")
                                    return
                                end

                                if quantity > 100 then 
                                    sendMessage("server", player, "Não é possível setar mais que 100% de colete.", "error")
                                else
                                    setPedArmor(receiver, quantity)
                                    sendMessage("server", player, "Você alterou o colete do jogador com sucesso.", "success")
                                    registerLogs(""..getPlayerName(player).." ("..(getElementData(player, "ID") or "N/A")..") alterou o colete do jogador "..getPlayerName(receiver).." ("..(getElementData(receiver, "ID") or "N/A")..") para "..quantity..".")
                                    if config.logs.log then
                                        messageDiscord(""..getPlayerName(player).." ("..pullID(player)..") alterou o colete do jogador "..getPlayerName(receiver).." ("..pullID(receiver)..") para "..quantity..".", config.logs.web_hook)
                                    end
                                end

                            elseif data.type == "setweapons" then 
                                exports["guetto_inventory"]:giveItem(receiver, data.edit[2], 1)
                                exports["guetto_inventory"]:giveItem(receiver, data.edit[3], data.edit[4])
                                sendMessage("server", player, "Você setou a arma para o jogador com sucesso.", "success")
                                registerLogs(""..getPlayerName(player).." ("..(getElementData(player, "ID") or "N/A")..") setou a arma "..data.edit[1].." para o jogador "..getPlayerName(receiver).." ("..(getElementData(receiver, "ID") or "N/A")..").")

                            elseif data.type == "setvehicle" then 
                                local quantity = tonumber(data.edit)

                                if not quantity then 
                                    sendMessage("server", player, "Valor inválido.", "error")
                                    return
                                end
                                
                                if string.len(quantity) > 3 then 
                                    sendMessage("server", player, "Valor inválido.", "error")
                                    return
                                end

                                if quantity >= 400 and quantity <= 611 then 
                                    if isElement(server.vehicle[receiver]) then 
                                        destroyElement(server.vehicle[receiver])
                                    end

                                    local pos = {getElementPosition(receiver)}
                                    server.vehicle[receiver] = createVehicle(quantity, pos[1], pos[2], pos[3])
                                    setElementData(server.vehicle[receiver], "Owner", player)
                                    if isElement(server.vehicle[receiver]) then 
                                        warpPedIntoVehicle(receiver, server.vehicle[receiver])
                                        sendMessage("server", player, "Você criou o veículo para o jogador com sucesso.", "success")
                                        registerLogs(""..getPlayerName(player).." ("..(getElementData(player, "ID") or "N/A")..") criou o veículo "..getVehicleNameFromModel(quantity).." para o jogador "..getPlayerName(receiver).." ("..(getElementData(receiver, "ID") or "N/A")..").")
                                        if config.logs.log then
                                            messageDiscord(""..getPlayerName(player).." ("..pullID(player)..") criou o veículo "..getVehicleNameFromModel(quantity).." para o jogador "..getPlayerName(receiver).." ("..pullID(receiver)..").", config.logs.web_hook)
                                        end
                                    end
                                else
                                    sendMessage("server", player, "Valor inválido.", "error")
                                end

                            elseif data.type == "setdimension" then 
                                local quantity = tonumber(data.edit)

                                if not quantity then 
                                    sendMessage("server", player, "Valor inválido.", "error")
                                    return
                                end

                                if string.len(quantity) > 65535 then 
                                    sendMessage("server", player, "Valor inválido.", "error")
                                    return
                                end

                                setElementDimension(receiver, quantity)
                                sendMessage("server", player, "Você setou a dimensão do jogador com sucesso.", "success")
                                registerLogs(""..getPlayerName(player).." ("..(getElementData(player, "ID") or "N/A")..") setou a dimensão do jogador "..getPlayerName(receiver).." ("..(getElementData(receiver, "ID") or "N/A")..") para "..quantity..".")
                                if config.logs.log then
                                    messageDiscord(""..getPlayerName(player).." ("..pullID(player)..") setou a dimensão do jogador "..getPlayerName(receiver).." ("..pullID(receiver)..") para "..quantity..".", config.logs.web_hook)
                                end

                            elseif data.type == "setinterior" then 
                                local quantity = tonumber(data.edit)

                                if not quantity then 
                                    sendMessage("server", player, "Valor inválido.", "error")
                                    return
                                end

                                setElementInterior(receiver, quantity)
                                sendMessage("server", player, "Você setou o interior do jogador com sucesso.", "success")
                                registerLogs(""..getPlayerName(player).." ("..(getElementData(player, "ID") or "N/A")..") setou o interior do jogador "..getPlayerName(receiver).." ("..(getElementData(receiver, "ID") or "N/A")..") para "..quantity..".")
                                if config.logs.log then
                                    messageDiscord(""..getPlayerName(player).." ("..pullID(player)..") setou o interior do jogador "..getPlayerName(receiver).." ("..pullID(receiver)..") para "..quantity..".", config.logs.web_hook)
                                end

                            elseif data.type == "repair" then 
                                local vehicle = getPedOccupiedVehicle(receiver)
                                
                                if vehicle then 
                                    fixVehicle(vehicle)
                                    sendMessage("server", player, "Você reparou o veículo do jogador com sucesso.", "success")
                                    registerLogs(""..getPlayerName(player).." ("..(getElementData(player, "ID") or "N/A")..") reparou o veículo do jogador "..getPlayerName(receiver).." ("..(getElementData(receiver, "ID") or "N/A")..").")
                                    if config.logs.log then
                                        messageDiscord(""..getPlayerName(player).." ("..pullID(player)..") reparou o veículo do jogador "..getPlayerName(receiver).." ("..pullID(receiver)..")!", config.logs.web_hook)
                                    end
                                else
                                    sendMessage("server", player, "O jogador não está em um veículo.", "error")
                                end

                            elseif data.type == "destroy" then 
                                local vehicle = getPedOccupiedVehicle(receiver)

                                if vehicle then 
                                    destroyElement(vehicle)
                                    sendMessage("server", player, "Você destruiu o veículo do jogador com sucesso.", "success")
                                    registerLogs(""..getPlayerName(player).." ("..(getElementData(player, "ID") or "N/A")..") destruiu o veículo do jogador "..getPlayerName(receiver).." ("..(getElementData(receiver, "ID") or "N/A")..").")
                                    if config.logs.log then
                                        messageDiscord(""..getPlayerName(player).." ("..pullID(player)..") destruiu o veículo do jogador "..getPlayerName(receiver).." ("..pullID(receiver)..")!", config.logs.web_hook)
                                    end
                                else
                                    sendMessage("server", player, "O jogador não está em um veículo.", "error")
                                end
                            end
                            sendData(player)
                        else
                            sendMessage("server", player, "Jogador não encontrado.", "error")
                        end
                    end
                end
            end
        end
	end)
end)

registerEvent("squady.setMoney", resourceRoot, function(hash, iv)

    if not client then
        return
    end

    local player = client

    decodeString('aes128', hash, {key = getPlayerSerial(player):sub(17), iv = iv}, function(decoded)
        if decoded then 
            local data = fromJSON(decoded)

            if data then
                local receiver = getPlayerFromID(tonumber(data.id))

                if player and receiver then
                    if data.type and data.edit then 
                        if isElement(receiver) then 
                            local verify_acl = verifyACL(player, config.adminPanel.permissions)

                            if not verify_acl then 
                                sendMessage("server", player, "Erro na acl.", "error")
                                return
                            end

                            if config.permissionsFunctions[verify_acl]["setmoney"] == false then 
                                sendMessage("server", player, "Você não possui permissão para realizar essa ação.", "error")
                                return
                            end

                            if data.type == "money" then 
                                local quantity = tonumber(data.edit)

                                if not quantity then 
                                    sendMessage("server", player, "Valor inválido.", "error")
                                    return
                                end

                                if quantity < 0 then 
                                    sendMessage("server", player, "Não é possível setar um valor negativo.", "error")
                                else
                                    setPlayerMoney(receiver, quantity)
                                    sendMessage("server", player, "Você setou o dinheiro do jogador para R$ "..convertNumber(quantity)..".", "success")
                                    registerLogs(""..getPlayerName(player).." ("..(getElementData(player, "ID") or "N/A")..") setou o dinheiro do jogador "..getPlayerName(receiver).." ("..(getElementData(receiver, "ID") or "N/A")..") para R$ "..convertNumber(quantity)..".")
                                    if config.logs.log then
                                        messageDiscord(""..getPlayerName(player).." ("..pullID(player)..") setou o dinheiro do jogador "..getPlayerName(receiver).." ("..pullID(receiver)..") para R$ "..convertNumber(quantity)..".", config.logs.web_hook)
                                    end
                                end
                            elseif data.type == "bank" then
                                local quantity = tonumber(data.edit)

                                if not quantity then 
                                    sendMessage("server", player, "Valor inválido.", "error")
                                    return
                                end

                                if quantity < 0 then 
                                    sendMessage("server", player, "Não é possível setar um valor negativo.", "error")
                                else
                                    setElementData(receiver, "guetto.bank.balance", quantity)
                                    sendMessage("server", player, "Você setou o dinheiro do banco do jogador para R$ "..convertNumber(quantity)..".", "success")
                                    registerLogs(""..getPlayerName(player).." ("..(getElementData(player, "ID") or "N/A")..") setou o dinheiro do banco do jogador "..getPlayerName(receiver).." ("..(getElementData(receiver, "ID") or "N/A")..") para R$ "..convertNumber(quantity)..".")
                                    if config.logs.log then
                                        messageDiscord(""..getPlayerName(player).." ("..pullID(player)..") setou o dinheiro do banco do jogador "..getPlayerName(receiver).." ("..pullID(receiver)..") para R$ "..convertNumber(quantity)..".", config.logs.web_hook)
                                    end
                                end

                            elseif data.type == "pontos" then 
                                local quantity = tonumber(data.edit)

                                if not quantity then 
                                    sendMessage("server", player, "Valor inválido.", "error")
                                    return
                                end

                                if quantity < 0 then 
                                    sendMessage("server", player, "Não é possível setar um valor negativo.", "error")
                                else
                                    setElementData(receiver, "vPoints", quantity)
                                    sendMessage("server", player, "Você setou os pontos do jogador para "..convertNumber(quantity)..".", "success")
                                    registerLogs(""..getPlayerName(player).." ("..(getElementData(player, "ID") or "N/A")..") setou os pontos do jogador "..getPlayerName(receiver).." ("..(getElementData(receiver, "ID") or "N/A")..") para "..convertNumber(quantity)..".")
                                    if config.logs.log then
                                        messageDiscord(""..getPlayerName(player).." ("..pullID(player)..") setou os pontos do jogador "..getPlayerName(receiver).." ("..pullID(receiver)..") para "..convertNumber(quantity)..".", config.logs.web_hook)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end)

--[[
    useful functions punishment system
]]

function getPlayerPunished ( player )
    local cache = dbPoll(dbQuery(db, "SELECT * FROM punishs WHERE account=?", getAccountName(getPlayerAccount(player))), -1)
    if cache and #cache ~= 0 then 
        return true 
    end
    return false;
end

function executePrison(element)
    local cache = dbPoll(dbQuery(db, "SELECT * FROM punishs WHERE account=?", getAccountName(getPlayerAccount(element))), -1)

    if #cache ~= 0 then 
        if isPedInVehicle(element) then 
            removePedFromVehicle(element)
        end
        setElementData(element, "vanish.punido", cache[1].author)
        setElementPosition(element, config.punishment.prison.pos[1], config.punishment.prison.pos[2], config.punishment.prison.pos[3])
        setElementDimension(element, config.punishment.prison.pos[4])
        triggerClientEvent(element, "squady.punishRender", element, cache[1].time, cache[1].reason)
    end
end

function removePlayerFromPrison(element)
    if element and isElement(element) then
        local cache = dbPoll(dbQuery(db, "SELECT * FROM punishs WHERE account=?", getAccountName(getPlayerAccount(element))), -1)

        if #cache ~= 0 then 
            setElementData(element, "vanish.punido", false)
            setElementPosition(element, config.punishment.prison.pos_exit[1], config.punishment.prison.pos_exit[2], config.punishment.prison.pos_exit[3])
            setElementDimension(element, config.punishment.prison.pos_exit[4])
            dbExec(db, "DELETE FROM punishs WHERE account=?", getAccountName(getPlayerAccount(element)))
            triggerClientEvent(element, "squady.punishRender", element)
            sendMessage("server", element, "Você foi liberado da prisão staff.", "success")
            sendData(element)
        end
    end
end
registerEvent("squady.removePlayerFromPrison", root, removePlayerFromPrison)

addEventHandler("onPlayerSpawn", root, function()
    if getElementData(source, "vanish.punido") then 
        setElementPosition(source, config.punishment.prison.pos[1], config.punishment.prison.pos[2], config.punishment.prison.pos[3])
    end
end)

addEventHandler("onResourceStart", resourceRoot, function()
    setTimer(function()
        for i, player in ipairs(getElementsByType("player")) do 
            executePrison(player)
        end
    end, 1000, 1)
end)

addEventHandler("onResourceStop", resourceRoot, function()
    db = dbConnect("sqlite", "assets/database/database.sqlite")

    for i, v in ipairs(getElementsByType("player")) do 
        if getElementData(v, "vanish.punido") then 
            local realTime = getElementData(v, "time.left.punish") or 0

            if realTime and realTime > 0 then 
                dbExec(db, "UPDATE punishs SET time = ? WHERE account = ?", realTime, getAccountName(getPlayerAccount(v)))
            end
        end
    end
end)

registerEvent("squady.applyPunishment", resourceRoot, function(hash, iv)

    if not (client or (source ~= resourceRoot)) then 
        return false 
    end;

    local player = client
    
    decodeString('aes128', hash, {key = getPlayerSerial(player):sub(17), iv = iv}, function(decoded)
		if decoded then 
			local data = fromJSON(decoded)

            if data then 
                local target = data.target
                local reason = data.reason
                local time = data.time
                local punishType = data.type

                local serial, account = exports["guetto_id2"]:getSerialByID(target)

                if not (serial) then 
                    return sendMessage("server", player, "Dados do jogador não foram encontrados!", "error")
                end

                local state = getStatePunish(account)
                local receiver = getPlayerFromID(tonumber(target))
                
                local punishTime = tonumber(time) * timeDesc[punishType]

                local verify_acl = verifyACL(player, config.adminPanel.permissions)

                if not verify_acl then 
                    sendMessage("server", player, "Erro na acl.", "error")
                    return
                end

                if not config.permissionsFunctions[verify_acl]["punishment"] then 
                    sendMessage("server", player, "Você não possui permissão para realizar essa ação.", "error")
                    return
                end

                if state == "Banido" then 
                    return sendMessage("server", player, "O jogador já está banido.", "error")
                end

                if punishType == "permanent" then 
                    outputChatBox('#C19F72[Guetto] #FFFFFFO Moderador(a) #8D6AF0'..getPlayerName(player)..' #'..(getElementData(player, 'ID') or 0)..' #FFFFFFpuniu o jogador(a) #8D6AF0'..account..' #'..target..' #FFFFFFPermanentemente com o seguinte motivo: #8D6AF0'..reason, root, 255, 255, 255, true)
              
                    sendMessage("server", player, "Você baniu o jogador "..account.." ("..target..") permanentemente com sucesso.", "success")
                    registerLogs(""..getPlayerName(player).." ("..(getElementData(player, "ID") or "N/A")..") baniu o jogador "..account.." ("..target..") permanentemente.")
              
                    if config.logs.log then 
                        messageDiscord("O(A) " .. getPlayerName(player) .. " (" .. getElementData(player, "ID" or 0) .. ") baniu o jogador " .. account .. " (" .. target .. ") PERMANENTEMENTE com o seguinte motivo "..reason.."", config.logs.web_hook)
                    end

                    addBan(nil, nil, serial, getPlayerName(player), reason, 0)
                    dbExec(db, "INSERT INTO punishs (account, id, time, author, reason) VALUES (?, ?, ?, ?, ?)", account, target, 0, getAccountName(getPlayerAccount(player)), reason)

                else
                    if receiver and isElement(receiver) then 
                        dbExec(db, "INSERT INTO punishs (account, id, time, author, reason) VALUES (?, ?, ?, ?, ?)", account, target, punishTime, getAccountName(getPlayerAccount(player)), reason)
                        executePrison(receiver)
                    else
                        dbExec(db, "INSERT INTO punishs (account, id, time, author, reason) VALUES (?, ?, ?, ?, ?)", account, target, 1, getAccountName(getPlayerAccount(player)), reason)
                        addBan(nil, nil, serial, getPlayerName(player), reason, punishTime)
                    end

                    if isElement(receiver) then 
                        outputChatBox('#C19F72[Guetto] #FFFFFFO Moderador(a) #8D6AF0'..getPlayerName(player)..' #'..(getElementData(player, 'ID') or 0)..' #FFFFFFpuniu o jogador(a) #8D6AF0'..getPlayerName(receiver)..' #'..(getElementData(receiver, 'ID') or 0)..' #FFFFFFpor #8D6AF0'..math.floor(punishTime / 60)..' minutos #FFFFFFcom o seguinte motivo: #8D6AF0'..reason, root, 255, 255, 255, true)
                        if config.logs.log then 
                            messageDiscord('O Moderador(a) '..getPlayerName(player)..' #'..(getElementData(player, 'ID') or 0)..' puniu o jogador(a) '..getPlayerName(receiver)..' #'..(getElementData(receiver, 'ID') or 0)..' por '..math.floor(punishTime / 60)..' minutos com o seguinte motivo: #8D6AF0'..reason, config.logs.web_hook)
                        end
                    else
                        outputChatBox('#C19F72[Guetto] #FFFFFFO Moderador(a) #8D6AF0'..getPlayerName(player)..' #'..(getElementData(player, 'ID') or 0)..' #FFFFFFpuniu o jogador(a) #8D6AF0'..account..' #'..target..' #FFFFFFpor #8D6AF0'..math.floor(punishTime / 60)..' minutos #FFFFFFcom o seguinte motivo: #8D6AF0'..reason, root, 255, 255, 255, true)
                        if config.logs.log then 
                            messageDiscord('O Moderador(a) '..getPlayerName(player)..' #'..(getElementData(player, 'ID') or 0)..' puniu o jogador(a) '..account..' #'..target..' por '..math.floor(punishTime / 60)..' minutos com o seguinte motivo:'..reason, config.logs.web_hook)
                        end
                    end

                    sendMessage("server", player, "Você baniu o jogador "..account.." ("..target..") por "..math.floor(punishTime / 60).." minutos com sucesso.", "success")
                    registerLogs(""..getPlayerName(player).." ("..(getElementData(player, "ID") or "N/A")..") baniu o jogador "..account.." ("..target..") por "..math.floor(punishTime / 60).." minutos.")
                end
                sendData(player)
            end
		else
			outputDebugString("Decoding failed")
		end
	end)
end)

function unpunishmentPlayer(player, _, target)
    if isPlayerInACL(player, config.punishment.others.permissions) then
        local playerID = getElementData(player, "ID") or 0

        if not playerID then 
            return
        end

        if not target then 
            return sendMessage("server", player, "Por favor, especifique o ID do jogador a ser desbanido.", "error")
        end

        local serial, account = exports["guetto_id2"]:getSerialByID(tonumber(target))
        local state = getStatePunish(account)

        local bans = getBans()
        
        for _, ban in ipairs(bans) do 
            if getBanSerial(ban) == serial then 
                removeBan(ban)
                sendMessage("server", player, "Você desbaniu o jogador "..account.." ("..target..") com sucesso", "success")
                break
            end
        end

        if state ~= "Desbanido" then
            local receiver = getPlayerFromID(tonumber(target))
            local bans = getBans()
            local isBanned = false

            for _, ban in ipairs(bans) do 
                if getBanSerial(ban) == serial then 
                    isBanned = true
                    removeBan(ban)
                    break
                end
            end

            if receiver and getElementData(receiver, "vanish.punido") then 
                removePlayerFromPrison(receiver)
                setElementData(receiver, "vanish.punido", false)
            end

            dbExec(db, "DELETE FROM punishs WHERE account = ?", account)

            sendMessage("server", player, "Você desbaniu o jogador "..account.." ("..target..") com sucesso.", "success")
            registerLogs(""..getPlayerName(player).." ("..(getElementData(player, "ID") or "N/A")..") desbaniu o jogador "..account.." ("..target..").")
            sendData(player)
        end

        if config.logs.log then 
            if account then
                messageDiscord("O Moderador(a) "..getPlayerName(player).." ("..playerID..") desbaniu o jogador "..account.." ("..target..")", config.logs.web_hook)
            end
        end
    else
        sendMessage("server", player, "Você não possui permissão para utilizar esse comando.", "error")
    end
end

addCommandHandler(config.punishment.others.command, unpunishmentPlayer)
registerEvent("squady.unpunishmentPlayer", resourceRoot, unpunishmentPlayer)

function getStatePunish(account)
    local rows = dbPoll(dbQuery(db, "SELECT * FROM punishs WHERE account = ?", account), -1)
    if (rows and #rows > 0) then
        return "Banido"
    else
        return "Desbanido"
    end
end

addEventHandler("onVehicleEnter", root, function(player)
    if getElementData(player, "vanish.punido") then
        if isPedInVehicle(player) then 
            removePedFromVehicle(player)
            setElementPosition(player, config.punishment.prison.pos[1], config.punishment.prison.pos[2], config.punishment.prison.pos[3])
        end
    end
end)

function registerLogs(data)
    if data then
        dbExec(db, "INSERT INTO last_actions (data, timestamp) VALUES (?, ?)", data, getRealTime().timestamp)
    end
end

--[[
    useful events staff login
]]

addEventHandler("onPlayerLogin", root, function()
    local player = source
    executePrison(player)
end)

addEventHandler("onPlayerQuit", root, function()
    local player = source
    if getElementData(player, "vanish.punido") then 
        local realTime = (getElementData(player, "time.left.punish") or 0)
        
        if realTime and realTime > 0 then 
            iprint(realTime)
            dbExec(db, "UPDATE punishs SET time=? WHERE account=?", realTime, getAccountName(getPlayerAccount(player)))
        end
    end

    if isTimer(server.timer[player]) then 
        killTimer(server.timer[player])
        server.timer[player] = {}
    end
end)