local cache = {
    ped = {}
}

local instance = {}

instance.database = dbConnect('sqlite', 'core/database/database.db')

addEventHandler('onResourceStart', resourceRoot, 
    function ( )

        if not (instance.database) then 
            return print ( 'Database is not connected' )
        end

        dbExec(instance.database, 'CREATE TABLE IF NOT EXISTS `Agency` (`accountName` TEXT NOT NULL, `Emprego` TEXT NOT NULL)')
        print('Database connected successfully')

        for _, player in ipairs(getElementsByType('player')) do 
            instance.setJob(player)
        end
    end
)


function instance.saveJob ( player )
    if not (player) then 
        return false 
    end

    local emprego = (getElementData(player, 'Emprego') or 'Desempregado')
    local query = dbPoll(dbQuery(instance.database, 'SELECT * FROM `Agency` WHERE `accountName` = ?', getAccountName(getPlayerAccount(player))), -1)

    if #query == 0 then 
        dbExec(instance.database, 'INSERT INTO `Agency` (`accountName`, `Emprego`) VALUES (?, ?)', getAccountName(getPlayerAccount(player)), emprego)
    else
        dbExec(instance.database, 'UPDATE `Agency` SET `Emprego` = ? WHERE `accountName` = ?', emprego, getAccountName(getPlayerAccount(player)))
    end

    return true
end

function instance.setJob (player)
    if not (player) then
        return false 
    end

    local query = dbPoll(dbQuery(instance.database, 'SELECT * FROM `Agency` WHERE `accountName` = ?', getAccountName(getPlayerAccount(player))), -1)

    if #query == 0 then
        setElementData(player, 'Emprego', 'Desempregado')
    else
        setElementData(player, 'Emprego', query[1].Emprego)
    end

    return true
end


createEvent("onPlayerRequestJob", resourceRoot, function (player, index, encode, key)
    if not (client or (source ~= resourceRoot)) then 
        return false 
    end;

    if client ~= player then 
        return false 
    end;

    local decode = teaDecode (encode, key)
    local find = string.find(decode, config["Empregos"][index]["Nome"])

    if find ~= 1 then 

        local name = getPlayerName (player)
        local id = (getElementData(player, 'ID') or 'N/A')
        local ip = getPlayerIP(player)
        local serial = getPlayerSerial(player)

        return error("["..(getResourceName(getThisResource())).."] Tentativa de acesso ilegal, ID: "..id.." | Serial: "..serial.." | IP: "..ip.." | Nome: "..name)
    end

    local level = (getElementData(player, 'Level') or 0)

    if level < config["Empregos"][index]["Level"] then
        return sendMessageServer(player, 'Voce precisa ser level '..config["Empregos"][index]["Level"]..' para pegar este emprego', 'error')
    end

    setElementData(player, 'Emprego', config["Empregos"][index]["Nome"])
   
    if instance.saveJob (player) then 
        sendMessageServer(player, 'Você pegou o emprego '..config["Empregos"][index]["Nome"].. ' com sucesso!', 'success')
    else
        sendMessageServer(player, 'Falha ao pegar o emprego '..config["Empregos"][index]["Nome"], 'error')
    end

    triggerClientEvent(player, 'togglePoint', player, config["Empregos"][index]["Posição"][1], config["Empregos"][index]["Posição"][2], config["Empregos"][index]["Posição"][3])
end)

addEventHandler('onPlayerQuit', root, function()
    instance.saveJob(source)
end)

addEventHandler('onPlayerLogin', root, function()
    instance.setJob(source)
end)


for i, v in ipairs(config["Peds"]) do 
    local element = createPed(v["Skin"], v["Posição"][1], v["Posição"][2], v["Posição"][3])
    local blip = createBlip (v["Skin"], v["Posição"][1], v["Posição"][2], v["Posição"][3], 23)

    cache.ped[element] = i

    setElementFrozen(element, true)
    setElementData(element, "onPedAgency", true)
    setElementRotation(element, v["Rotação"][1], v["Rotação"][2], v["Rotação"][3])
end