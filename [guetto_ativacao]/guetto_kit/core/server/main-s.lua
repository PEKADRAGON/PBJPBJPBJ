local instance = {}

instance.db = dbConnect('sqlite', 'core/database/database.db')

addEventHandler('onResourceStart', resourceRoot, function ( )
    if instance.db and isElement(instance.db) then 
        dbExec(instance.db, 'CREATE TABLE IF NOT EXISTS `Pills` (`accountName` TEXT NOT NULL)')
    end

    print ('Database is connected!')
end)

function getPlayerReciverKit (player)
    if not (player or not isElement(player) or getElementType(player) ~= 'player') then
        return false 
    end
    local account = getAccountName (getPlayerAccount(player))
    local query = dbQuery(instance.db, 'SELECT * FROM `Pills` WHERE `accountName` = ?', account)
    local result = dbPoll(query, -1)
    if #result > 0 then
        return true 
    end
    return false 
end

createEvent("onPlayerRequestPill", resourceRoot, function ( player, select )

    if not (client or (source ~= resourceRoot)) then 
        return false
    end

    if client ~= player then 
        return false
    end

    if type(select) ~= 'string' then 
        return false 
    end
    
    local data = config["Itens"][select]

    if not data or type(data) ~= 'table' then 
        return false 
    end

    triggerClientEvent (player, "onClientSendPill", resourceRoot, data)
end)

createEvent("onPlayerRedeemPill", resourceRoot, function (player, select)
    if not (client or (source ~= resourceRoot)) then 
        return false
    end

    if client ~= player then 
        return false
    end

    if type(select) ~= 'string' then 
        return false 
    end

    local isPlayerRescued = getPlayerReciverKit(player)

    if (isPlayerRescued) then 
        return false 
    end

    local data = config["Itens"][select]

    if not data or type(data) ~= 'table' then 
        return false 
    end

    for index, value in ipairs (data) do 

        if value.title == 'BÔNUS' then 
            value.func(player, value.amount)
        elseif value.title == 'Pop 100' or value.title == 'Hornet' then
            value.func(player, value.name, value.brand, value.model)
        elseif value.title == 'ACESSORIO' then 
            value.func(player, value.id, 1)
        end

    end

 --   local name = removeHex(getPlayerName (player))

    dbExec(instance.db, 'INSERT INTO `Pills` (`accountName`) VALUES (?)', getAccountName(getPlayerAccount(player)))
   -- outputChatBox("#CAFC03[KIT INICIAL] #FFFFFF"..(name).." ACABOU DE COLETAR SEU KIT INICIAL!", root, 255, 255, 255, true)
    sendMessageServer(player, 'Você coletou seu kit!', 'info')
    
end)

createEvent("onPlayerKitLogin", root, function ( player )
    if not (player or not isElement(player) or getElementType(player) ~= 'player') then
        return false 
    end

    local isPlayerRescued = getPlayerReciverKit(player)

    if not (isPlayerRescued) then 
        triggerClientEvent(player, "onClientDrawKit", resourceRoot)
    end
end)
