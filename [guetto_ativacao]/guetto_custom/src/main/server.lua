local database = dbConnect('sqlite', 'database.db');

local function createEvent(eventname, ...)
    addEvent(eventname, true)
    addEventHandler(eventname, ...)
end

local function loadAllPlayers()
    for i,v in pairs(getElementsByType("player")) do
        local account = getAccountName(getPlayerAccount(v))
        local result = dbPoll(dbQuery(database, 'SELECT * FROM `guetto_characters` WHERE `accountName` = ?', account), - 1)
        if #result == 0 then 
            setTimer(function()
                triggerClientEvent(v, "onPlayerCreateCharacter", resourceRoot)
            end, 1000, 1)
        end
        carregarPersonagem(v)
    end
end

function carregarPersonagem ( player )
    if not (player) then 
        return false 
    end
    
    if (isGuestAccount(getPlayerAccount(player))) then 
        return false 
    end

    local account = getAccountName(getPlayerAccount(player));
    local result = dbPoll(dbQuery(database, "SELECT * FROM `guetto_characters` WHERE `accountName` = ?", account), - 1)

    local clothings = getElementData(player, "characterClothes") or {}
    local gender = getElementData(player, "characterGenre")
    local tone = getElementData(player, "characterSkinColor")

    if #result == 0 then 
        dbExec(database, "INSERT INTO `guetto_characters` VALUES (?, ?, ?, ?)", account, toJSON(clothings), tone, gender)
    else
        setElementData(player, "characterClothes", fromJSON(result[1].characters))
        setElementData(player, "characterGenre", tonumber(result[1].gender))
        setElementData(player, "characterSkinColor", tonumber(result[1].color))
    end

    setTimer(function()
        triggerLatentClientEvent("loadCharacter", 1000, false, player, player)
    end, 1000, 1)
    return true
end


addEvent("carregarPersonagem", true)
addEventHandler("carregarPersonagem", getRootElement(), carregarPersonagem)

function saveCharacterPlayer ( player )
    if not (player) then 
        return false 
    end

    if (isGuestAccount(getPlayerAccount(player))) then 
        return false 
    end

    local account = getAccountName(getPlayerAccount(player))
    local result = dbPoll(dbQuery(database, "SELECT * FROM `guetto_characters` WHERE `accountName` = ?", account), - 1)

    if #result ~= 0 then 
        local character = getElementData(player, "characterClothes")
        dbExec(database, "UPDATE `guetto_characters` SET `characters` = ? WHERE `accountName` = ?", toJSON(character), account)
    end

end

createEvent("saveCharacterPlayer", getRootElement(), saveCharacterPlayer)

createEvent("payCharacterClothes", getRootElement(), function(state, data, price)

    if not ( client or ( source ~= resourceRoot ) ) then 
        return false 
    end;

    if not state then 
        return false 
    end;

    if (tonumber(price) <= 0) then 
        return false 
    end

    if (getPlayerMoney(client) < tonumber(price)) then
        return sendMessageServer(client, 'Você não possui dinheiro suficiente!', 'info')
    end

    local products = data[1]
    local type = data[2]

    for i, v in pairs(products) do
        setNewCharacterData(client, type, v[2], v[1])
    end

    saveCharacterPlayer(client)
    triggerClientEvent("reloadCharacter", resourceRoot, client, 600)
    triggerClientEvent(client, "paymentClothes", resourceRoot, state)

    takePlayerMoney(client, tonumber(price))
end)

createEvent("payCharacterBarber", resourceRoot, function(state, price, data)
    if not ( client or ( source ~= resourceRoot ) ) then 
        return false 
    end;

    if not state then 
        return false 
    end

    if (tonumber(price) <= 0) then 
        return false 
    end
   
    if (getPlayerMoney(client) < tonumber(price)) then
        return sendMessageServer(client, 'Você não possui dinheiro suficiente!', 'info')
    end

    for i, v in pairs(data) do
        if v[2] == "hair" then
            setNewCharacterData(client, "hair", "id", v[1])
            setNewCharacterData(client, "hair", "color", v[3] or 1)
        else
            setNewCharacterData(client, "face", v[2], v[1])
        end
    end

    triggerClientEvent("reloadCharacter", resourceRoot, client, 600)
    triggerClientEvent(client, "paymentBarber", resourceRoot, state)
    takePlayerMoney(client, tonumber(price))
    saveCharacterPlayer(client)
end)

createEvent("Conner.sairTatuagem", getRootElement(), function(player)
    local id = getElementData(player, "natatuagem:id")
    if not id then return end
    local pos = lojas["Tatuagem"]["saida"]
    setElementPosition(player, pos[id][1], pos[id][2], pos[id][3])
    setElementData(player, "natatuagem:id",nil)

    setCameraTarget(player)
    setElementFrozen(player, false)
    toggleAllControls(player,true)
    
    setElementInterior(player, 0)
    setElementDimension(player, 0)
end)

createEvent("Conner.pagarTatuagem", getRootElement(), function(player, id, categoria)
    if (diretorio) and (tipoRoupa) and (categoriaRoupa) then
        local genero = getElementData(player,"characterGenre")
		triggerClientEvent("Conner.applyTatoo", player, player, id, categoria)
		setNewCharacterData(player, "tatoo", categoria, id)
        saveCharacterPlayer(player)
    end
end)

createEvent("Conner.finalizarPersonagem", root, function(data, genre, skincolor)
    setElementFrozen(client, false)
    toggleAllControls(client, true)

    setElementData(client, "characterClothes", data)
    setElementData(client, "characterGenre", genre)
    setElementData(client, "characterSkinColor", skincolor)

    setElementModel(client, genre == 1 and 1 or 2)

    carregarPersonagem(client)
    setElementAlpha(client, 255)
    triggerEvent("onPlayerSpawnSave", resourceRoot, client)
end)

createEvent("Conner.applyShader", getRootElement(), function(...)
    triggerClientEvent("Conner.applyShader", resourceRoot, ...) 
end)

createEvent("loadCharacter", getRootElement(), function(...)
    triggerClientEvent("loadCharacter", resourceRoot, ...)
end)

createEvent("reloadCharacter", getRootElement(), function(...)
    triggerClientEvent("reloadCharacter", resourceRoot, ...)
end)

addEventHandler('onResourceStart', resourceRoot, 
    function ( )
        if not database then
            return print ('guetto_characters failed to connect with database!')
        end

        dbExec(database, [[
            CREATE TABLE IF NOT EXISTS `guetto_characters` (`accountName` TEXT NOT NULL, `characters` JSON NOT NULL, `color` TEXT NOT NULL, `gender` TEXT NOT NULL)
        ]])

        print('guetto_characters database is connected with success!')
        loadAllPlayers()
    end
)

createEvent("onPlayerCharacterLogin", root, function (player)

    if not (player or not isElement(player) or getElementsByType(player) ~= 'player') then 
        return false 
    end

    if isGuestAccount(getPlayerAccount(player)) then
        return false 
    end

    local account = getAccountName(getPlayerAccount(player))
    local result = dbPoll(dbQuery(database, 'SELECT * FROM `guetto_characters` WHERE `accountName` = ?', account), - 1)

    if #result == 0 then 
        triggerClientEvent(player, "onPlayerCreateCharacter", resourceRoot)
    else
        carregarPersonagem(player)
        triggerEvent("onPlayerSpawnSave", resourceRoot, player)
    end
end)

function getPlayerClothes (account)
    if not account then 
        return false 
    end

    local result = dbPoll(dbQuery(database, 'SELECT * FROM `guetto_characters` WHERE `accountName` = ?', account), - 1)

    if #result == 0 then 
        return false 
    end

    return result
end

