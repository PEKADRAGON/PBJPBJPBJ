marker_dj = {}
aclMarker = {}

addEventHandler("onResourceStart", resourceRoot,
function()
    db = dbConnect("sqlite", "dados.sqlite")
    dbExec(db, "CREATE TABLE IF NOT EXISTS MusicsDJ(acl, musics)")
    if config["Mensagem Start"] then
        outputDebugString("["..getResourceName(getThisResource()).."] Startado com sucesso, qualquer bug contacte zJoaoFtw_#5562!")
    end
    for i, v in ipairs(config["Markers"]) do
        marker_dj[i] = createMarker(v[1], v[2], v[3]-1, "cylinder", 1.1, 0, 0, 0, 0)
        setElementInterior(marker_dj[i], v[5])
        setElementDimension(marker_dj[i], v[4])
        aclMarker[marker_dj[i]] = v[6]
        setElementData(marker_dj[i], 'markerData', {title = 'Painel DJ', desc = 'Coloque sua música aqui', icon = 'boate'})
        addEventHandler("onMarkerHit", marker_dj[i],
        function(player, dim)
            if getElementType(player) == "player" then
                if dim then
                    if aclGetGroup(v[6]) and isObjectInACLGroup("user."..puxarConta(player), aclGetGroup(v[6])) then
                        local result = dbPoll(dbQuery(db, "SELECT * FROM MusicsDJ WHERE acl = ?", v[4]), -1)
                        triggerClientEvent(player, "JOAO.openPanelDJ", player, result, i)
                    end
                end
            end
        end)
    end
end)

addEvent("JOAO.favoriteMusicDJ", true)
addEventHandler("JOAO.favoriteMusicDJ", root,
function(dataMusic, indexMarker, typeK)
    if not client then
        return
    end

    local player = client

    local result = dbPoll(dbQuery(db, "SELECT * FROM MusicsDJ WHERE acl = ?", aclMarker[marker_dj[indexMarker]]), -1)
    if #result > 0 then
        local verifyMusci = verifyMusicFavorite((typeK == "normal" and dataMusic[1] or dataMusic.idMusic), indexMarker)
        if verifyMusci then
            local musicsFavorites = fromJSON(result[1]["musics"])
            table.remove(musicsFavorites, verifyMusci)
            if dbExec(db, "UPDATE MusicsDJ SET musics = ? WHERE acl = ?", toJSON(musicsFavorites), aclMarker[marker_dj[indexMarker]]) then
                notifyS(player, "Você retirou do favorito essa música com sucesso!", "success")
            end
        else
            local musicsFavorites = fromJSON(result[1]["musics"])
            table.insert(musicsFavorites, {nameMusic = (typeK == "normal" and dataMusic[2] or dataMusic.nameMusic), idMusic = (typeK == "normal" and dataMusic[1] or dataMusic.idMusic)})
            if dbExec(db, "UPDATE MusicsDJ SET musics = ? WHERE acl = ?", toJSON(musicsFavorites), aclMarker[marker_dj[indexMarker]]) then
                notifyS(player, "Você favoritou essa música com sucesso!", "success")
            end
        end
    else
        dbExec(db, "INSERT INTO MusicsDJ(acl, musics) VALUES(?,?)", aclMarker[marker_dj[indexMarker]], toJSON({{nameMusic = (typeK == "normal" and dataMusic[2] or dataMusic.nameMusic), idMusic = (typeK == "normal" and dataMusic[1] or dataMusic.idMusic)}}))
        notifyS(player, "Você favoritou essa música com sucesso!", "success")
    end
    sendData(player, indexMarker)
end)

function verifyMusicFavorite(idMusic, indexMarker)
    local result = dbPoll(dbQuery(db, "SELECT * FROM MusicsDJ WHERE acl = ?", aclMarker[marker_dj[indexMarker]]), -1)
    if #result > 0 then
        local musicsFavorites = fromJSON(result[1]["musics"])
        for i, v in ipairs(musicsFavorites) do
            if v.idMusic == idMusic then
                return i
            end
        end
    end
    return false
end

function sendData(player, indexMarker)
    local result = dbPoll(dbQuery(db, "SELECT * FROM MusicsDJ WHERE acl = ?", aclMarker[marker_dj[indexMarker]]), -1)
    triggerClientEvent(player, "JOAO.attFavoritesMusicsDJ", player, result)
end

addEvent("JOAO.pesquisarMusicDJ", true)
addEventHandler("JOAO.pesquisarMusicDJ", root,
function(str)

    if not client and client ~= player then
        return
    end

    local player = client;

    local postData = {
        headers = {
            ["Content-Type"] = "application/json",
        },
        postData = toJSON({musica = str}),
        queueName = "POST"
    }

    fetchRemote("https://server1.mtabrasil.com.br/search?q="..removeAccents(str):gsub("%s", "%%20"), function(response, error)
        if (error == 0) then 
            triggerClientEvent(player, "JOAO.sendInfoMusicsDJ", resourceRoot, fromJSON(response))
        end
        --if (error.statusCode == 200) then
        --end
    end)
end)


--[[
addEvent("JOAO.pesquisarMusicDJ", true)
addEventHandler("JOAO.pesquisarMusicDJ", root,
function(str)

    if not client and client ~= player then
        return
    end

    local player = client;

    local postData = {
        headers = {
            ["Content-Type"] = "application/json",
        },
        postData = toJSON({musica = str}),
        queueName = "POST"
    }

    fetchRemote("https://music.pegasusac.xyz/search", postData, function(response, error)
        iprint(response, error)
        if (error.statusCode == 200) then
            triggerClientEvent(player, "JOAO.sendInfoMusicsDJ", resourceRoot, fromJSON(response))
        end
    end)
end)
]]
addEvent('JOAO.tocarMusicDJ', true)
addEventHandler('JOAO.tocarMusicDJ', root,
function(dataMusic, indexMarker, typeK)
    if not client then 
        return
    end

    local player = client

    local int = getElementInterior(marker_dj[indexMarker])
    local dim = getElementDimension(marker_dj[indexMarker])
    local pos = {getElementPosition(marker_dj[indexMarker])}
    for _, v in ipairs(getElementsByType('player')) do
        triggerClientEvent(v, 'JOAO.tocarMusicCDJ', v, indexMarker, pos[1], pos[2], pos[3], int, dim, dataMusic, typeK)
    end
end)

addEvent('JOAO.pararMusicDJS', true)
addEventHandler('JOAO.pararMusicDJS', root,
function(indexMarker)
    if not client then
        return
    end

    local player = client

    for _, v in ipairs(getElementsByType('player')) do
        triggerClientEvent(v, 'JOAO.pararMusicDJC', v, indexMarker)
    end
end)
