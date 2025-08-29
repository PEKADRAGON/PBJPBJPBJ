-- \\ Var´s //

local database = dbConnect("sqlite", "src/database/database.sqlite")
local invites = {}
local playerCache = {}

-- \\ Function´s //

function start( )

    if not database then 
        return error ("Erro ao conectar ao banco de dados")
    end

    dbExec(database, [[CREATE TABLE IF NOT EXISTS `Grupos` (`Name` TEXT NOT NULL, `Acl` TEXT NOT NULL, `Members` TEXT NOT NULL, `Capacity` TEXT NOT NULL, `Owner` TEXT NOT NULL, `Type` TEXT NOT NULL, `Cofre` TEXT NOT NULL, `Logs` JSON NOT NULL)]])
    dbExec(database, [[CREATE TABLE IF NOT EXISTS `Membros` (`Account` TEXT NOT NULL, `Grupo` TEXT NOT NULL, `Role` TEXT NOT NULL, `Type` TEXT NO NULL, `Contribution` TEXT NOT NULL)]])

    print ("Conectado ao banco de dados")
end

addEventHandler("onResourceStart", resourceRoot, start)

addCommandHandler('creategroups', function(player)
    if isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(player)), aclGetGroup('Console')) then 
        local query = dbPoll(dbQuery(database, 'SELECT * FROM `Grupos`'), -1)
        if #query ~= 0 then 
            for i, v in ipairs (query) do 
                if not aclGetGroup(v.Acl) then 
                    aclCreateGroup(v.Acl)
                    print ('Acl '..v['Acl']..' Criada com sucesso!') 
                end
            end
        end
    end
end)

addCommandHandler('addmembers', function(player)
    if isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(player)), aclGetGroup('Console')) then 
        local query = dbPoll(dbQuery(database, 'SELECT * FROM `Membros`'), -1)
        if #query ~= 0 then 
            for i, v in ipairs (query) do 
                if aclGetGroup(v.Grupo) then 
                    if not (isObjectInACLGroup('user.'..v['Account'], aclGetGroup(v['Grupo']))) then 
                        aclGroupAddObject(aclGetGroup(v.Grupo), 'user.'..v['Account'])
                        aclGroupAddObject(aclGetGroup(v.Type), 'user.'..v['Account'])
                        print (v['Account'].. 'Adicionado na acl '..v['Grupo'])
                    end
                end
            end
        end
    end
end)

function getClientInfos ( )

    if not (client or (source ~= resourceRoot)) then 
        return false 
    end

    if isGuestAccount(getPlayerAccount(client)) then 
        return false 
    end

    local account = getAccountName (getPlayerAccount (client) )
    local cache = dbPoll(dbQuery(database, "SELECT * FROM `Membros` WHERE `Account` = ?", account), -1)

    if not cache then 
        return false 
    end

    if #cache ~= 0 then 
        playerCache[client] = dbPoll(dbQuery(database, "SELECT * FROM `Grupos` WHERE `Name` = ?", cache[1].Grupo), -1)
    else
        playerCache[client] = { }
    end

    if not invites[account] then 
        invites[account] = { }
    end
    
    local cache_members = {}


    if #playerCache[client] ~= 0 then 
        local element_status = getPlayerFromAccountName ( getAccountName (getPlayerAccount (client) ) )
        members = dbPoll(dbQuery(database, "SELECT * FROM `Membros` WHERE `Grupo` = ?", playerCache[client][1].Name), -1)

        for i = 1, #members do 
            table.insert(cache_members, {
                Account = members[i].Account,
                Contribution = members[i].Contribution,
                Grupo = members[i].Grupo,
                Role = members[i].Role,
                Type = members[i].Type,
                Status = getPlayerFromAccountName(members[i].Account) and 'Online' or 'Offline',
                Id = exports["guetto_id2"]:getIdByAccount(members[i].Account)
            })
        
        end

    end

    return triggerClientEvent (client, "Guetto:Client:receiveInfos", resourceRoot, playerCache[client], invites[account], cache_members, cache)
end

registerEventHandler("Guetto:GetInfos", resourceRoot, getClientInfos)

function acceptClientInvite ( invite )

    if not (client or (source ~= resourceRoot)) then 
        return false 
    end

    if isGuestAccount(getPlayerAccount(client)) then 
        return false 
    end

    local account = getAccountName (getPlayerAccount (client) )
    local query = dbPoll(dbQuery(database, "SELECT * FROM `Membros` WHERE `Account` = ?", account), -1)

    if #query ~= 0 then 
        return config.sendMessageServer(client, "Você já está em um grupo!", "error")
    end

    local data = config["Cargos"][invite.Type]
    local cache = dbPoll(dbQuery(database, "SELECT * FROM `Grupos` WHERE `Name` = ?", invite.Grupo), -1)

    if #cache == 0 then 
        return config.sendMessageServer(client, "O grupo não existe!", "error")
    end


    dbExec(database, "INSERT INTO `Membros` (`Account`, `Grupo`, `Role`, `Type`, `Contribution`) VALUES (?, ?, ?, ?, ?)", account, invite.Grupo, data[#data].name, invite.Type, 0)
    dbExec(database, "UPDATE `Grupos` SET `Members` = ? WHERE `Name` =? ", tonumber(cache[1].Members) + 1, invite.Grupo)

    aclGroupAddObject(aclGetGroup(invite.Type), "user."..account)
    aclGroupAddObject(aclGetGroup(cache[1].Acl), "user."..account)

    if invites[account] then 
        invites[account] = {}
    end

    config.sendMessageServer(client, "Convite aceito com sucesso!", "success")
    
end

registerEventHandler("Guetto:Client:acceptInvite", resourceRoot, acceptClientInvite)

function refuseClientInvite ( invite )

    if not (client or (source ~= resourceRoot)) then 
        return false 
    end

    if isGuestAccount(getPlayerAccount(client)) then 
        return false 
    end

    local account = getAccountName (getPlayerAccount (client) )
    
    if invites[account] then 
        invites[account] = { }
    end

    config.sendMessageServer(client, "Convite rejeitado com sucesso!", "success")
end

registerEventHandler("Guetto:Client:refuseInvite", resourceRoot, refuseClientInvite)

function playerQuitGroup ( )

    if not (client or (source ~= resourceRoot)) then 
        return false 
    end

    if isGuestAccount(getPlayerAccount(client)) then 
        return false 
    end

    local account = getAccountName (getPlayerAccount (client) )
    local query = dbPoll(dbQuery(database, "SELECT * FROM `Membros` WHERE `Account` = ?", account), -1)

    if not query then 
        return false 
    end

    local cache = dbPoll(dbQuery(database, "SELECT * FROM `Grupos` WHERE `Name` = ?", query[1].Grupo), -1)

    if #cache ~= 0 then 
        local position = getRolePosition( query[1].Type, query[1].Role )

        if position == 1 then 
            if getAccountName(getPlayerAccount(client)) == query[1].Owner then 
                for i, v in ipairs (  dbPoll ( dbQuery (  database, "SELECT * FROM `Membros` WHERE `Grupo` = ?", cache[1].Name ) , -1) ) do 
                    dbExec(database, "DELETE FROM `Membros` WHERE `Account` = ?", v.Account)
                    if aclGetGroup(cache[1].Acl) then 
                        aclGroupRemoveObject(aclGetGroup(cache[1].Acl), "user."..v.Account) 
                        aclGroupRemoveObject(aclGetGroup(cache[1].Type), "user."..v.Account) 
                    end
                end
                dbExec(database, "DELETE FROM `Grupos` WHERE `Name` = ?")
            end
        else
            aclGroupRemoveObject(aclGetGroup(cache[1].Acl), "user."..account) 
            aclGroupRemoveObject(aclGetGroup(cache[1].Type), "user."..account) 
        end

        if (tonumber(cache[1].Members) > 0) then 
            dbExec(database, "UPDATE `Grupos` SET `Members` = ? WHERE `Name` = ?", tonumber( cache[1].Members ) - 1, cache[1].Name)
        end
        
        dbExec(database, "DELETE FROM `Membros` WHERE `Account` = ?", account)
        
        config.sendMessageServer(client, "Você saiu do grupo com sucesso!", "success")
    else
        config.sendMessageServer(client, "O grupo não existe!", "error")
    end

    if not invites[account] then 
        invites[account] = {}
    end

end

registerEventHandler("Guetto:Client:Quit", resourceRoot, playerQuitGroup)

function downgradeRole(accountTarget)
    if not (client or (source ~= resourceRoot)) then 
        return false 
    end

    if isGuestAccount(getPlayerAccount(client)) then 
        return false
    end

    local account = getAccountName(getPlayerAccount(client))
    local query = dbPoll(dbQuery(database, "SELECT * FROM `Membros` WHERE `Account` = ?", accountTarget), -1)

    if not query then 
        return false 
    end

    local position = getRolePosition(query[1].Type, query[1].Role)

    if position == #config["Cargos"][query[1].Type] then 
        config.sendMessageServer(client, "Cargo não pode ser rebaixado!", "error")
    else
        local newRole = config["Cargos"][query[1].Type][position + 1].name
        dbExec(database, "UPDATE `Membros` SET `Role` = ? WHERE `Account` = ?", newRole, accountTarget)
        config.sendMessageServer(client, "Cargo baixado com sucesso!", "success")
        setGrouLogs(query[1].Grupo, " " .. getAccountName(getPlayerAccount(client)) .. " rebaixou o cargo do membro (".. accountTarget .. ") para " .. newRole)
        updateClientInfos(client)
    end
end

registerEventHandler("Guetto:Client:downgradeRole", resourceRoot,  downgradeRole)

function expulsarPlayer (accountTarget)
    
    if not (client or (source ~= resourceRoot)) then 
        return false 
    end

    if isGuestAccount(getPlayerAccount(client)) then 
        return false
    end

    local account = getAccountName (getPlayerAccount (client) )
    local query = dbPoll(dbQuery(database, "SELECT * FROM `Membros` WHERE `Account` = ?", accountTarget), -1)

    if not query then 
        return false 
    end

    if #query == 0 then 
        return false 
    end

    local cache = dbPoll(dbQuery(database, "SELECT * FROM `Grupos` WHERE `Name` = ?", query[1].Grupo), -1)

    if #cache ~= 0 then 
        dbExec(database, "UPDATE `Grupos` SET `Members` = ? WHERE `Name` = ? ", (tonumber(cache[1].Members) -1), query[1]['Grupo'])
        dbExec(database, "DELETE FROM `Membros` WHERE `Account` = ?", accountTarget)

        if aclGetGroup(cache[1].Acl) then 
            aclGroupRemoveObject(aclGetGroup(cache[1].Acl), "user."..accountTarget) 
            aclGroupRemoveObject(aclGetGroup(query[1].Type), "user."..accountTarget) 
        end

        config.sendMessageServer(client, "Você expulsou o membro com sucesso!", "info")
        updateClientInfos(client)
    end

end

registerEventHandler("Guetto:Client:Expulsar", resourceRoot, expulsarPlayer)

function upgradeRole ( accountTarget )

    if not (client or (source ~= resourceRoot)) then 
        return false 
    end

    if isGuestAccount(getPlayerAccount(client)) then 
        return false
    end

    local account = getAccountName (getPlayerAccount (client) )
    local query = dbPoll(dbQuery(database, "SELECT * FROM `Membros` WHERE `Account` = ?", accountTarget), -1)

    if not query then 
        return false 
    end

    local position = getRolePosition( query[1].Type, query[1].Role )

    if position == 1 then 
        config.sendMessageServer(client, "Esse membro já é cargo máximo!", "error")
    else
        dbExec(database, "UPDATE `Membros` SET `Role` = ? WHERE `Account` = ?", config["Cargos"][query[1].Type][position - 1].name, accountTarget)
        config.sendMessageServer(client, "Cargo aumentado com sucesso!", "success")
        updateClientInfos(client)

        if getPlayerFromAccountName ( accountTarget ) then 
            updateClientInfos(getPlayerFromAccountName ( accountTarget ))
        end

        setGrouLogs(query[1].Grupo, " ".. ( getAccountName(getPlayerAccount(client)) ) .." Upou o cargo do membro ".. (accountTarget).. " para ".. (config["Cargos"][query[1].Type][position - 1].name) .. "")
        updateClientInfos(client)
    end

end

function getMoneyCofreFromName (acl)
    if not acl then 
        return 0 
    end

    local cache = dbPoll(dbQuery(database, "SELECT * FROM `Grupos` WHERE `Acl` = ?", acl), -1)

    if #cache == 0 then 
        return 0 
    end

    return tonumber(cache[1].Cofre)
end

function takeMoneyCofreFromName (acl, amount)
    if not acl or not amount then 
        return 0 
    end

    local cache = dbPoll(dbQuery(database, "SELECT * FROM `Grupos` WHERE `Acl` = ?", acl), -1)

    if #cache == 0 then 
        return 0 
    end

    dbExec(database, "UPDATE `Grupos` SET `Cofre` = ? WHERE `Acl` = ?", tonumber(cache[1].Cofre) - tonumber(amount), acl)
    return 
end

registerEventHandler("Guetto:Client:upgradeRole", resourceRoot,  upgradeRole)

function groupDeposit ( value )

    if not (client or (source ~= resourceRoot)) then 
        return false 
    end

    if isGuestAccount(getPlayerAccount(client)) then 
        return false
    end

    if (tonumber(value) <= 0) then 
        return false 
    end

    local account = getAccountName (getPlayerAccount (client) )
    local query = dbPoll(dbQuery(database, "SELECT * FROM `Membros` WHERE `Account` = ?", account), -1)

    if not query then 
        return false 
    end

    local cache = dbPoll(dbQuery(database, "SELECT * FROM `Grupos` WHERE `Name` = ?", query[1].Grupo), -1)

    if not cache then 
        return false 
    end

    if #cache == 0 then 
        return config.sendMessageServer(client, "O grupo não existe!", "error")
    end

    local money = getPlayerMoney ( client )

    if money < tonumber(value) then 
        return config.sendMessageServer(client, "Voce não tem dinheiro suficiente!", "error")
    end

    takePlayerMoney (client, tonumber(value))

    dbExec(database, "UPDATE `Grupos` SET `Cofre` = ? WHERE `Name` = ?", tonumber ( cache[1].Cofre + value ), query[1].Grupo)
    dbExec(database, "UPDATE `Membros` SET `Contribution` = ? WHERE `Account` = ?", tonumber ( query[1].Contribution + value ), account)

    setGrouLogs( query[1].Grupo, {content = ""..(account).." depositou o valor de ".. (formatNumber (value, ".")) .." no cofre do grupo!", date = os.time()} )
    config.sendMessageServer(client, "Você depositou ".. (formatNumber (value, ".")) .." no cofre do grupo!", "success")
    updateClientInfos(client)
end

registerEventHandler("Guetto:Client:deposit", resourceRoot, groupDeposit)

function groupSaque ( value )

    if not (client or (source ~= resourceRoot)) then 
        return false 
    end

    if isGuestAccount(getPlayerAccount(client)) then 
        return false
    end

    local account = getAccountName (getPlayerAccount (client) )
    local query = dbPoll(dbQuery(database, "SELECT * FROM `Membros` WHERE `Account` = ?", account), -1)

    if not query then 
        return false 
    end

    local cache = dbPoll(dbQuery(database, "SELECT * FROM `Grupos` WHERE `Name` = ?", query[1].Grupo), -1)

    if not cache then
        return false 
    end

    if tonumber(value) <= 0 then 
        return false 
    end

    if #cache == 0 then 
        return config.sendMessageServer(client, "O grupo não existe!", "error")
    end

    if tonumber ( cache[1].Cofre ) < tonumber ( value ) then 
        return config.sendMessageServer(client, "Cofre insuficiente!", "error")
    end

    givePlayerMoney (client, tonumber(value))

    dbExec(database, "UPDATE `Grupos` SET `Cofre` = ? WHERE `Name` = ?", tonumber ( cache[1].Cofre - value ), query[1].Grupo)
    dbExec(database, "UPDATE `Membros` SET `Contribution` = ? WHERE `Account` = ?", tonumber ( query[1].Contribution - value ), account)

    setGrouLogs( query[1].Grupo, {content = ""..(account).." sacou o valor de ".. (formatNumber (value, ".")) .." do cofre do grupo!", date = os.time()} )
        
    config.sendMessageServer(client, "Você retirou ".. (formatNumber (value, ".")) .." do cofre do grupo!", "success")
    updateClientInfos(client)
end

registerEventHandler("Guetto:Client:sacar", resourceRoot, groupSaque)

function createGroup ( name, type, acl, quantity, leader ) 

    if not name then 
        return false 
    end

    if not type then 
        return false 
    end

    if not acl then 
        return false 
    end

    if not quantity then 
        return false 
    end

    if not leader then 
        return false 
    end

    if (tonumber(quantity)) <= 0 then 
        return false 
    end

    local owner = getPlayerByID ( tonumber( leader ) )

    if not owner then 
        return config.sendMessageServer(client, "Lider do grupo não encontrado!", "error") 
    end

    local query = dbPoll(dbQuery(database, "SELECT * FROM `Grupos` WHERE `Name` = ?", name), -1)
    local account = getAccountName(getPlayerAccount(owner))
    
    if #query ~= 0 then 
        return config.sendMessageServer(client, "Esse grupo ja existe!", "error")
    end

    if #dbPoll(dbQuery(database, "SELECT * FROM `Membros` WHERE `Account` = ?", account), -1) ~= 0 then 
        return config.sendMessageServer(client, "Esse líder já está em uim grupo!", "error")
    end

    if not aclGetGroup(acl) then 
        aclCreateGroup(acl)
    end

    if not aclGetGroup(type) then 
        aclCreateGroup(type)
    end

    aclGroupAddObject(aclGetGroup(acl), "user."..account)
    aclGroupAddObject(aclGetGroup(type), "user."..account)

    local data = config["Cargos"][type]
    if data then 
        dbExec(database, "INSERT INTO `Grupos` (`Name`, `Acl`, `Members`, `Capacity`, `Owner`, `Type`, `Cofre`, `Logs`) VALUES (?, ?, ?, ?, ?, ?, ?, ?)", name, acl, 1, quantity, account, type, 0, toJSON({}))
        dbExec(database, "INSERT INTO `Membros` (`Account`, `Grupo`, `Role`, `Type`, `Contribution`) VALUES (?, ?, ?, ?, ?)", account, name, data[1].name, type, 0)
    end
    

    config.sendMessageServer(client, "Grupo criado com sucesso!", "success")
end

registerEventHandler("Guetto:createGroup", resourceRoot, createGroup)

function inviteMember (id)

    if not (client or (source ~= resourceRoot)) then 
        return false 
    end

    if isGuestAccount(getPlayerAccount(client)) then 
        return false
    end

    local account = getAccountName (getPlayerAccount (client) )
    local query = dbPoll(dbQuery(database, "SELECT * FROM `Membros` WHERE `Account` = ?", account), -1)

    if not query then 
        return false 
    end


    local position = getRolePosition( query[1].Type, query[1].Role )
    local settings = config["Cargos"][query[1].Type][position]

    if settings.permissoes.convidar == false then 
        return config.sendMessageServer(client, "Você não possui permissão para convidar membros!", "error")
    end

    local target = getPlayerByID(tonumber(id))

    if not target then 
        return config.sendMessageServer(client, "Jogador não encontrado!", "error")
    end

    if isGuestAccount(getPlayerAccount(target)) then 
        return config.sendMessageServer(client, "Jogador não encontrado!", "error")
    end

    if #dbPoll(dbQuery(database, "SELECT * FROM `Membros` WHERE `Account` = ?", getAccountName(getPlayerAccount(target))), -1) ~= 0 then 
        return config.sendMessageServer(client, "Esse jogador já está em um grupo!", "error")
    end


    local cache = dbPoll(dbQuery(database, "SELECT * FROM `Grupos` WHERE `Name` = ?", query[1].Grupo), -1)

    if not cache then 
        return false 
    end

    if #cache == 0 then
        return config.sendMessageServer(client, "Esse grupo não existe!", "error")
    end

    invites[ getAccountName(getPlayerAccount(target)) ] = {
        Type = query[1].Type,
        Grupo = query[1].Grupo,
        Owner = cache[1].Owner,
        Acl = cache[1].Acl,
        Members = cache[1].Members,
        Capacity = cache[1].Capacity,
        Dominacao = 0,
    }

    config.sendMessageServer(client, "Convite enviado com sucesso!", "success")
    config.sendMessageServer(target, "Você recebeu um convite de ".. getAccountName(getPlayerAccount(client)) .."!", "success")
end

registerEventHandler("Guetto:Client:invite", resourceRoot, inviteMember)


addCommandHandler("criargrupo", function (player, cmd)

    local account  = getAccountName(getPlayerAccount(player))

    if not isObjectInACLGroup("user."..account, aclGetGroup("Console")) then 
        return false 
    end

    triggerClientEvent(player, "Guetto:Client:createGroup", resourceRoot)
end)

function updateClientInfos ( player )
    if not player then 
        return false 
    end

    if isGuestAccount(getPlayerAccount(player)) then 
        return false 
    end

    local account = getAccountName (getPlayerAccount (player) )
    local cache = dbPoll(dbQuery(database, "SELECT * FROM `Membros` WHERE `Account` = ?", account), -1)

    if not cache then 
        return false 
    end

    if #cache ~= 0 then 
        playerCache[player] = dbPoll(dbQuery(database, "SELECT * FROM `Grupos` WHERE `Name` = ?", cache[1].Grupo), -1)
    else
        playerCache[player] = { }
    end

    local cache_members = {}

    if #playerCache[player] ~= 0 then 
        local element_status = getPlayerFromAccountName ( getAccountName (getPlayerAccount (client) ) )
        members = dbPoll(dbQuery(database, "SELECT * FROM `Membros` WHERE `Grupo` = ?", playerCache[player][1].Name), -1)

        for i = 1, #members do 
            table.insert(cache_members, {
                Account = members[i].Account,
                Contribution = members[i].Contribution,
                Grupo = members[i].Grupo,
                Role = members[i].Role,
                Type = members[i].Type,
                Status = getPlayerFromAccountName(members[i].Account) and 'Online' or 'Offline',
                Id = exports["guetto_id2"]:getIdByAccount(members[i].Account)
            })
        
        end
    end

    return triggerClientEvent (player, "Guetto:Client:UpdateDados", resourceRoot, playerCache[player], cache_members, cache)
end


function setGrouLogs ( Group, Text )

    if not Group then 
        return false 
    end

    if not Text then 
        return false 
    end

    local cache = { }
    local query = dbPoll(dbQuery(database, "SELECT * FROM `Grupos` WHERE `Name` = ?", Group), -1)

    if #query == 0 then 
        return false 
    end
    
    cache[Group] = fromJSON(query[1].Logs)
    table.insert(cache[Group], Text)
    dbExec(database, "UPDATE `Grupos` SET `Logs` = ? WHERE `Name` = ?", toJSON(cache[Group]), Group)
end

addCommandHandler("deletargrupo", function ( player, cmd, acl)
    
    if isGuestAccount(getPlayerAccount(player)) then 
        return false 
    end

    local account = getAccountName (getPlayerAccount (player) )

    if not isObjectInACLGroup("user."..account, aclGetGroup("Console")) then 
        return false 
    end
    
    if not acl then 
        return config.sendMessageServer(player, "Digite a acl do grupo!", "error")
    end;

    local query = dbPoll(dbQuery(database, "SELECT * FROM `Grupos` WHERE `Acl` = ?", acl), -1)

    if #query == 0 then 
        return config.sendMessageServer(player, "Grupo não encontrado!", "error")
    end

    for i, v in ipairs (  dbPoll ( dbQuery (  database, "SELECT * FROM `Membros` WHERE `Grupo` = ?", query[1].Name ) , -1) ) do 
        dbExec(database, "DELETE FROM `Membros` WHERE `Account` = ?", v.Account)
        if aclGetGroup(acl) then 
            aclGroupRemoveObject(aclGetGroup(acl), "user."..v.Account) 
            aclGroupRemoveObject(aclGetGroup(query[1].Type), "user."..v.Account) 
        end
    end

    if aclGetGroup(acl) then 
        aclDestroyGroup(aclGetGroup(acl))
    end
    dbExec(database, "DELETE FROM `Grupos` WHERE `Acl` = ?", acl)

    config.sendMessageServer(player, "Grupo deletado com sucesso!", "info")
end)

function getPlayerGroup(player)
    if not isElement(player) or getElementType(player) ~= "player" then
        return false
    end

    local account = getPlayerAccount(player)
    if not account or isGuestAccount(account) then
        return false
    end

    local playerName = getAccountName(account)
    local query = dbPoll(dbQuery(database, "SELECT `Grupo` FROM `Membros` WHERE `Account` = ?", playerName), -1)

    if not query then
        return false
    end

    if #query == 0 then
        return false
    end

    return query[1].Grupo
end

function getPlayerGroupData (player)
    if not isElement(player) or getElementType(player) ~= "player" then
        return false
    end

    local account = getPlayerAccount(player)
    if not account or isGuestAccount(account) then
        return false
    end

    local playerName = getAccountName(account)
    local query = dbPoll(dbQuery(database, "SELECT `Grupo` FROM `Membros` WHERE `Account` = ?", playerName), -1)

    if not query then
        return false
    end

    if #query == 0 then
        return false
    end

    local result = dbPoll(dbQuery(database, 'SELECT * FROM `Grupos` WHERE `Name` = ?', query[1].Grupo), -1)

    return result
end

function getPlayerRoleInGroup(player)
    if not isElement(player) or getElementType(player) ~= "player" then
        return false
    end

    local account = getPlayerAccount(player)
    if not account or isGuestAccount(account) then
        return false
    end

    local playerName = getAccountName(account)
    local query = dbPoll(dbQuery(database, "SELECT `Role` FROM `Membros` WHERE `Account` = ?", playerName), -1)

    if not query then
        return resetFarClipDistance
    end

    if #query == 0 then
        return false
    end

    return query[1].Role
end

function getPlayerFromAccountName(name) 
    local acc = getAccount(name)
    if (not acc) or (isGuestAccount(acc)) then
        return false
    end
    return getAccountPlayer(acc)
end


local model = [[
    Grupo = %s - Membros = %s;
]]

function sendDiscordMessage(message, theWebhook)
	sendOptions = {
		queueName = "dcq",
		connectionAttempts = 3,
		connectTimeout = 5000,
		formFields = {
		  content="```"..message.."```"
		},
	}   
		fetchRemote(theWebhook, sendOptions, function()end)
end 

function getTotalPlayersGroup ( Grupo )
    local query = dbPoll(dbQuery(database, 'select * from `Membros` WHERE `Grupo` = ?', Grupo), - 1)
    if #query == 0 then 
        return 0
    end
    local c = 0;
    for i, v in ipairs ( query ) do 
        local element = getPlayerFromAccountName (v.Account);
        if (element and isElement(element)) then 
            c = c + 1
        end
    end
    return c
end

function sendControllerGroup ( )
    local query = dbPoll(dbQuery(database, 'select * from `Membros`'), - 1)
    local logs = {}
    local count = 0;

    for i, v in ipairs ( query ) do 
        local element = getPlayerFromAccountName (v.Account);
        if not logs[v.Grupo] then 
            logs[v.Grupo] = {membros = 0}
        end
        if logs[v.Grupo] then 
            if (element and isElement(element)) then 
                logs[v.Grupo].membros = logs[v.Grupo].membros + 1
                count = count + 1
            end
        end
    end

    local allowMessage = ""

    for i, v in pairs ( logs ) do 
        logMessage = model:format(i, v.membros)
        allowMessage = allowMessage..logMessage
    end
    
    allowMessage = allowMessage..'\nTotal de Membros:'..count

    sendDiscordMessage(allowMessage, "https://media.guilded.gg/webhooks/d09ec40d-30a2-4462-bfee-a97c86847667/HQz8B1GiS4uMC4cAWiO204Cy4O84C04U6gAIs4Oo6YQcAMs6kU0W4QgYS8CsIg0mmSy6gMIWGcwg0YqwGk4Wu4")
end

setTimer(function()
    sendControllerGroup()
end, 3600000, 0)

addCommandHandler('controller', function(player, cmd)
    if isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(player)), aclGetGroup('Console')) then 
        sendControllerGroup()
        sendMessageServer(player, "Lista de grupos enviadas com sucesso para o guilded!", "info")
    end
end)

addCommandHandler('grupo', function(player, cmd)
    local client = player;

    if isGuestAccount(getPlayerAccount(client)) then 
        return false 
    end

    local account = getAccountName (getPlayerAccount (client) )
    local cache = dbPoll(dbQuery(database, "SELECT * FROM `Membros` WHERE `Account` = ?", account), -1)

    if not cache then 
        return false 
    end

    if #cache ~= 0 then 
        playerCache[client] = dbPoll(dbQuery(database, "SELECT * FROM `Grupos` WHERE `Name` = ?", cache[1].Grupo), -1)
    else
        playerCache[client] = { }
    end

    if not invites[account] then 
        invites[account] = { }
    end
    
    local cache_members = {}

    if #playerCache[client] ~= 0 then 
        local element_status = getPlayerFromAccountName ( getAccountName (getPlayerAccount (client) ) )
        members = dbPoll(dbQuery(database, "SELECT * FROM `Membros` WHERE `Grupo` = ?", playerCache[client][1].Name), -1)

        for i = 1, #members do 
            table.insert(cache_members, {
                Account = members[i].Account,
                Contribution = members[i].Contribution,
                Grupo = members[i].Grupo,
                Role = members[i].Role,
                Type = members[i].Type,
                Status = getPlayerFromAccountName(members[i].Account) and 'Online' or 'Offline',
                Id = exports["guetto_id2"]:getIdByAccount(members[i].Account)
            })
        end

    end

    return triggerClientEvent (client, "Guetto:Client:receiveInfos", resourceRoot, playerCache[client], invites[account], cache_members, cache)
end)

addCommandHandler('resetmoneygroup', function(player, cmd, group)
    if isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(player)), aclGetGroup('Console')) then 
        if not group then 
            return config.sendMessageServer(player, 'Digite a acl do grupo!', 'error')
        end
        local cache = dbPoll(dbQuery(database, "SELECT * FROM `Grupos` WHERE `Acl` = ?", group), -1)
        if #cache == 0 then return config.sendMessageServer(player, 'Grupo não encontrado!', 'error') end 
        dbExec(database, 'UPDATE `Grupos` SET `Cofre` = ? WHERE `Acl` = ?', 0, group)
        config.sendMessageServer(player, 'Você resetou o cofre do grupo!', 'info')
    end
end)

addCommandHandler('uparportuga', function(player, cmd)
    if isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(player)), aclGetGroup('Console')) then 
        dbExec(database, 'UPDATE `Membros` SET `Role` = ? WHERE `Account` = ?', 'COMANDANTE GERAL', 'Portugaxitapouco')
        print('cargo atualizado')
    end
end)