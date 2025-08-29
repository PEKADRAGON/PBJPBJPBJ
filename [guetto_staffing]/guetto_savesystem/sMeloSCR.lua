db = dbConnect("sqlite", "dados.db")
dbExec(db, "CREATE TABLE IF NOT EXISTS SaveSystem(Conta, Skin, Vida, Colete, NivelProcurado, Dinheiro, Pos, Rot, Dim, Int)")

local spawns_death = {
    {1509.212, -1748.174, 13.547, 0, 0, 134.906};
    {1428.55, -1765.382, 13.547, 0, 0, 134.906};
}

config = {
    Roles = {
        ['adminRoles'] = {
            { acl = "Creator", role = "creator" },
            { acl = "Staff", role = "staff" },
           -- { acl = "Developer", role = "developer" },
            { acl = "Influencer", role = "influencer" },
            { acl = "Patrocinador", role = "patrocinador" },
            { acl = "Marginal de grife", role = "marginal de grife" },
            { acl = "Criminoso", role = "criminoso" },
            { acl = "Visionário", role = "Visionário" },
            { acl = "Luxuria", role = "luxuria" },
        },
    },
}

addEvent("onPlayerSpawnSave", true)
addEventHandler("onPlayerSpawnSave", root, function(player) 
    if player and isElement(player) and getElementType(player) == "player" then 
        local result = dbPoll(dbQuery(db, "SELECT * FROM SaveSystem WHERE Conta = ?", getAccountName(getPlayerAccount(player))), -1)
        local genero = getElementData(player,"characterGenre")

        if #result == 0 then 
            spawnPlayer(player, 824.563, -1360.938, -0.508, 0, 0, 0, 0)
            setElementDimension(player, 0)
            setCameraTarget(player, player)
            setPlayerMoney(player, 500)
            fadeCamera(player, true, 2.0) 
            setElementData(player, "MeloSCR:Logado", true)
        else
            local posPlayer = fromJSON(result[1].Pos)
            local posRot = fromJSON(result[1].Rot)
            
            spawnPlayer(player, posPlayer[1], posPlayer[2], posPlayer[3], posRot[3], result[1].Skin, result[1].Int, result[1].Dim)
            setCameraTarget(player, player)
            
            fadeCamera(player, true, 2.0)  
            setPedArmor(player, result[1].Colete)
    
            setElementHealth(player, result[1].Vida)
            setElementDimension(player, 0)
            setPlayerWantedLevel(player, result[1].NivelProcurado)
            setPlayerMoney(player, result[1].Dinheiro)
            setElementData(player, "MeloSCR:Logado", true)
        end

        local playerRole = isPlayerInACLs(player, config["Roles"]["adminRoles"])

        setElementModel(player, genero == 1 and 1 or 2)

        if playerRole then
            setElementData(player, "FS:adminDuty", playerRole["role"])
        end

        triggerEvent("onPlayerKitLogin", resourceRoot, player)
    end
end)

function resourceStart()
    for _, player in ipairs(getElementsByType('player')) do
        local playerRole = isPlayerInACLs(player, config["Roles"]["adminRoles"])
        if playerRole then
            setElementData(player, "FS:adminDuty", playerRole["role"])
        end
    end
end
addEventHandler('onResourceStart', root, resourceStart)

function saveDate(account, pos, rot, int, dim)
    local select = dbQuery(db, "SELECT * FROM SaveSystem WHERE Conta=?", account)
    local sql = dbPoll(select, -1)
    setTimer(function()
        if #sql > 0 then 
            dbExec(db, "UPDATE SaveSystem SET Pos=?, Rot=?, Dim=?, Int=? WHERE Conta=?", toJSON(pos), toJSON(rot), dim, int, account)
        end
    end, 2000, 1)
end

function quitPlayer()
    if getElementData(source, "MeloSCR:Logado") then 
        local select = dbQuery(db, "SELECT * FROM SaveSystem WHERE Conta=?", getAccountName(getPlayerAccount(source)))
        local sql = dbPoll(select, -1)
        local pos = {getElementPosition(source)}
        local rot = {getElementRotation(source)}
        if #sql == 0 then 
            dbExec(db, "INSERT INTO SaveSystem(Conta, Skin, Vida, Colete, NivelProcurado, Dinheiro, Pos, Rot, Dim, Int) VALUES(?,?,?,?,?,?,?,?,?,?)", getAccountName(getPlayerAccount(source)), getElementModel(source), getElementHealth(source), getPedArmor(source), getPlayerWantedLevel(source), getPlayerMoney(source), toJSON(pos), toJSON(rot), getElementDimension(source), getElementInterior(source))
        else 
            dbExec(db, "UPDATE SaveSystem SET Skin=?, Vida=?, Colete=?, NivelProcurado=?, Dinheiro=?, Pos=?, Rot=?, Dim=?, Int=? WHERE Conta = ?", getElementModel(source), getElementHealth(source), getPedArmor(source), getPlayerWantedLevel(source), getPlayerMoney(source), toJSON(pos), toJSON(rot), getElementDimension(source), getElementInterior(source), getAccountName(getPlayerAccount(source)))
        end 
    end 
end
addEventHandler("onPlayerQuit", root, quitPlayer)

function onDeathPlayer(ammo, attacker, weapon, bodypart)

    local random = math.random(#spawns_death)
    spawnPlayer(source, spawns_death[random][1], spawns_death[random][2], spawns_death[random][3], 0, getElementModel(source))
    setElementRotation(source, spawns_death[random][4], spawns_death[random][5], spawns_death[random][6])
    setElementFrozen(source, false)
    toggleAllControls(source, true)

end
addEventHandler("onPlayerWasted", root, onDeathPlayer)

function getMoneyPlayer(accountName)
    local result = dbPoll(dbQuery(db, "SELECT * FROM SaveSystem WHERE Conta=?", accountName), -1)
    if #result > 0 then
        return result[1]["Dinheiro"]
    end
    return 0
end

function getLastPosition(accountName)
    local result = dbPoll(dbQuery(db, "SELECT * FROM SaveSystem WHERE Conta=?", accountName), -1)
    if #result > 0 then
        return fromJSON(result[1]["Pos"])
    end
    return 0, 0, 0
end

function getPlayerFromAccountName(name) 
    local acc = getAccount(name)
    if not acc or isGuestAccount(acc) then
        return false
    end
    return getAccountPlayer(acc)
end

function isPlayerInACLs(player, table)
    local playerRole
    if player and isElement(player) and (getElementType(player) == "player") then

        if isGuestAccount(getPlayerAccount(player)) then
            return false
        end

        local accName = getAccountName(getPlayerAccount(player))
        for i = 1, #table do
            if aclGetGroup(table[i]["acl"]) and isObjectInACLGroup("user." ..accName, aclGetGroup(table[i]["acl"])) then 
                playerRole = table[i]
                break
            end
        end

    end
    return playerRole
end

addCommandHandler("resetardinheiro", function(player, cmd, account)
    if (player) then 
        if isObjectInACLGroup("user."..getAccountName(getPlayerAccount(player)), aclGetGroup("Console")) then 
            if not account then 
                return config.sendMessageServer(player, "Digite a conta do cidadão!", "error")
            end
            local result = dbPoll(dbQuery(db, "SELECT * FROM SaveSystem WHERE Conta=?", account), -1)
            if #result == 0 then return config.sendMessageServer(player, "Cidadão não encontrado!", "error") end 
            dbExec(db, "UPDATE `SaveSystem` SET `Dinheiro` = ? WHERE `Conta` = ?", 0, account)
            iprint("Você resetou a conta com sucesso.")
        end
    end
end)