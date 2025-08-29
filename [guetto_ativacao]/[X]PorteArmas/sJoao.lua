marker = {}
timer = {}

addEventHandler("onResourceStart", resourceRoot,
function()
    db = dbConnect("sqlite", "dados.sqlite")
    dbExec(db, "CREATE TABLE IF NOT EXISTS PorteArmas(account, porte, tempo)")
    if config["Mensagem Start"] then
        outputDebugString("["..getResourceName(getThisResource()).."] Startado com sucesso!")
    end
    for i, v in ipairs(config["Markers"]) do
        marker[i] = createMarker(v[1], v[2], v[3]-0.9, 'cylinder', 1.3, r, g, b, 100) 
        setElementData(marker[i], 'marker_custom', 5)
        setElementDimension(marker[i], v[4]) 
        setElementInterior(marker[i], v[5])

        addEventHandler("onMarkerHit", marker[i],
        function(player, dim)
            if getElementType(player) == "player" then
                if dim then
                    local result = dbPoll(dbQuery(db, "SELECT * FROM PorteArmas WHERE account = ?", puxarConta(player)), -1)
                    if v[4] == "questions" then
                        if #result > 0 then
                            notifyS(player, "Você já tem o teste teórico!", "error")
                        else
                            triggerClientEvent(player, "JOAO.openPorte", player, v[6])
                        end
                    else
                        if aclGetGroup("Everyone") and isObjectInACLGroup("user."..puxarConta(player), aclGetGroup("Everyone")) then
                            triggerClientEvent(player, "JOAO.openPorte", player, v[6])
                        else
                            notifyS(player, "Você não tem acesso!", "error")
                        end
                    end
                end
            end
        end)
    end
    for i, v in ipairs(getElementsByType("player")) do
        timer[v] = setTimer(TimerPorte, 5000, 0, v)
    end
end)

addEvent("JOAO.startTestePorte", true)
addEventHandler("JOAO.startTestePorte", resourceRoot,
function()
    if not (client or (source ~= resourceRoot)) then 
        return false 
    end
    local player = client;
    local level = (getElementData(player, "Level") or 0)
    if level >= config["Minimo"].Level then
        if getPlayerMoney(player) >= config["Minimo"].Dinheiro then
            takePlayerMoney(player, config["Minimo"].Dinheiro)
            triggerClientEvent(player, "JOAO.changeWindowPORTE", player, "questions")
            notifyS(player, "Você comprou o porte com sucesso!", "success")
        else
            notifyS(player, "Você não tem dinheiro suficiente!", "error")
        end
    else
        notifyS(player, "Você não tem level suficiente!", "error")
    end
end)

addEvent("JOAO.pegarPorteTeorico", true)
addEventHandler("JOAO.pegarPorteTeorico", resourceRoot,
function()

    if not (client or (source ~= resourceRoot)) then 
        return false 
    end

    local player = client; 

    local result = dbPoll(dbQuery(db, "SELECT * FROM PorteArmas WHERE account = ?", puxarConta(player)), -1)
    if #result > 0 then
        notifyS(player, "Você já tem o teste teórico!", "error")
    else
        dbExec(db, "INSERT INTO PorteArmas(account, porte, tempo) VALUES(?,?,?)", puxarConta(player), "false", "false")
        notifyS(player, "Você passou no teste teórico!", "success")
    end
end)

addEvent("JOAO.setarPorte", true)
addEventHandler("JOAO.setarPorte", resourceRoot,
function(id, tempo)

    if not (client or (source ~= resourceRoot)) then 
        return false 
    end

    local player = client;

    local _, account = exports["guetto_id2"]:getSerialByID(id)
    if account then
        local result = dbPoll(dbQuery(db, "SELECT * FROM PorteArmas WHERE account = ?", account), -1)
        if #result > 0 then
            local receiver = getPlayerFromID(id)
            if isElement(receiver) then
                if not isTimer(timer[receiver]) then timer[receiver] = setTimer(TimerPorte, 5000, 0, receiver) end
                setElementData(receiver, "JOAO.porte", true)
            end
            dbExec(db, "UPDATE PorteArmas SET porte = ?, tempo = ? WHERE account = ?", "true", (tempo*86400000), account)
            notifyS(player, "Você deu o porte de armas para "..account.." #"..id.." com sucesso!", "success")
        else
            notifyS(player, "Esse jogador não tem o teste teórico!", "error")
        end
    else
        notifyS(player, "Essa conta não existe!", "error")
    end
end)

addEvent("JOAO.removerPorte", true)
addEventHandler("JOAO.removerPorte", root,
function(id)

    if not (client or (source ~= resourceRoot)) then 
        return false 
    end

    local player = client;

    local _, account = exports["guetto_id2"]:getSerialByID(id)
    if account then
        local result = dbPoll(dbQuery(db, "SELECT * FROM PorteArmas WHERE account = ? AND porte = ?", account, "true"), -1)
        if #result > 0 then
            local receiver = getPlayerFromID(id)
            if isElement(receiver) then
                if isTimer(timer[receiver]) then killTimer(timer[receiver]) end
                setElementData(receiver, "JOAO.porte", false)
            end
            dbExec(db, "UPDATE PorteArmas SET porte = ?, tempo = ? WHERE account = ?", "false", "false", account)
            notifyS(player, "Você removeu o porte de armas de "..account.." #"..id.." com sucesso!", "success")
        else
            notifyS(player, "Esse jogador não tem o porte de armas!", "error")
        end
    else
        notifyS(player, "Essa conta não existe!", "error")
    end
end)

function TimerPorte(player)
    if isElement(player) then
        if getElementType(player) ~= "player" then return end
        local result = dbPoll(dbQuery(db, "SELECT * FROM PorteArmas WHERE account = ? AND porte = ?", puxarConta(player), "true"), -1)
        if (#result ~= 0) and (type(result) == "table") then
            if (result[1]["tempo"] > 0) then
                dbExec(db, "UPDATE PorteArmas SET tempo = ? WHERE account = ?", (tonumber(result[1]["tempo"]) - 5000), puxarConta(player))
            else
                dbExec(db, "UPDATE PorteArmas SET tempo = ?, porte = ? WHERE account = ?", "false", "false", puxarConta(player))
            end
        end
    end
end

function getPlayerFromID(id)
    if tonumber(id) then
        for _, player in ipairs(getElementsByType("player")) do
            if getElementData(player, "ID") and (getElementData(player, "ID") == tonumber(id)) then
                return player
            end
        end
    end
    return false
end