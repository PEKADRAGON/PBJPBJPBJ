addEvent("kumar:server", true)

addEventHandler("onResourceStart", resourceRoot, function()
    db = dbConnect( "sqlite", "database.db" )
    dbExec(db, "CREATE TABLE IF NOT EXISTS `kumarlog` (characterid INTEGER, win INTEGER, gametype TEXT, tarih TEXT)")
    dbExec(db, "CREATE TABLE IF NOT EXISTS `kumarslots` (x, y, z, rx, ry, rz, interior, dim, creator)")
    if db then
        loadSlots()
    end
end)

addEventHandler("kumar:server", root, function(state, ...)

    if not client then 
        client = source 
    end

    if not client or not isElement(client) then 
        return false 
    end
    
    if not (getElementData(client, "validateMoney")) then 
        return false 
    end

    if state == "addlog" then
        addLog(client, ...)
    elseif state == "addmoney" then
        addMoney(client, ...)
    elseif state == "takemoney" then
        takeMoney(client, ...)
    end

    setElementData(client, "validateMoney", false)
end)

function addMoney ( player, money )
    givePlayerMoney(player, money)
end

function takeMoney ( player, money )
    if getPlayerMoney(player) >= money then 
        takePlayerMoney(player, money)
    end
end

function addLog (player, out_m, in_m, gametype)
    local dbid = getElementData(player, "ID") or "N/A"
    local win = (in_m - out_m)
    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    dbExec(db, "INSERT INTO kumarlog (characterid, win, gametype, tarih) VALUES(?, ?, ?, ?)", dbid, win, gametype, currentTime)
    dbExec(db, "DELETE FROM kumarlog WHERE DATE(tarih) <= DATE('now', '-30 days')")
end


function loadSlots ( )
    dbQuery(function(qh)
        local results = dbPoll(qh, 0)
        for k, v in pairs(results) do
            local elm = slotCreate ( v.x, v.y, v.z, v.rx, v.ry, v.rz, v.interior, v.dim, v.id )
        end
    end, db, "SELECT * FROM kumarslots")
end

function adm_slot_cmd ( player, cmd, state, ... )
   -- if not checkAdmin(player) then return end
    if state == "criar" then
        local x, y, z = getElementPosition(player)
        local z = z + 0.875
        local rx, ry, rz = getElementRotation(player)
        local int, dim = getElementInterior(player), getElementDimension(player)
        local elm = slotCreate(x, y, z, rx, ry, rz, int, dim)
        local creatorid = getElementData(player, "dbid") or 0
        -- db
        local tick = getTickCount()
        if dbExec(db, "INSERT INTO kumarslots (x, y, z, rx, ry, rz, interior, dim, creator) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)", x, y, z, rx, ry, rz, int, dim, tick) then
            dbQuery(function(qh)
                local result = dbPoll(qh, 0)
                if result then
                    local id = result[1]
                    if id then
                        local id = id.id
                        setElementData(elm, "kumar-slot", id)
                        dbExec(db, "UPDATE kumarslots SET creator = ? WHERE id = ?", creatorid, id)
                        outputChatBox("Você criou um slot com sucesso, slotid: "..id, player, 255, 255, 255)
                        return
                    end
                end
                outputDebugString("Ocorreu um erro, entre em contato com a Cyem", 1, 255, 0, 0)
            end, db, "SELECT id FROM kumarslots WHERE creator = ?", tick)
        end
    elseif state == "remover" then
        local id = unpack({...})
        local id = tonumber(id)
        if id then
            slotRemove(player, id)
        end
    elseif state == "list" then
        local px, py, pz = getElementPosition(player)
        for _, elm in ipairs(getElementsByType("kumar-slot")) do
            local id = getElementData(elm, "kumar-slot") or -1
            local x, y, z = getElementPosition(elm)
            local dist = getDistanceBetweenPoints3D(x, y, z, px, py, pz)
            outputChatBox("Slot ID: "..id..", para você "..math.ceil(dist).." metros de distância.", player, 255, 255, 255)
        end
    elseif state == "proximos" then
        local id = unpack({...})
        local id = tonumber(id)
        if id then
            local elm, obje = getSlotFromID(id)
            if elm then
                local x, y, z = getPositionFromElementOffset(obje, 0, -2, 1)
                local dim, int = getElementDimension(elm), getElementInterior(elm)
                setElementPosition(player, x, y, z)
                setElementDimension(player, dim)
                setElementInterior(player, int)
            else
                outputChatBox("Nenhum slot encontrado com este ID!", player, 255, 255, 255)
            end
        end
    end
end
addCommandHandler("slot", adm_slot_cmd)

function slotCreate ( x, y, z, rx, ry, rz, int, dim, id )
    local z = z - 1
    local obje = createObject(2640, x, y, z - 1, rx, ry, rz - 90)
    setElementData(obje, "slotmachine:texture", "dede")
    setElementCollisionsEnabled(obje, false)
    setTimer(setElementCollisionsEnabled, 3000, 1, obje, true)
    local elm = createElement("kumar-slot")
    setElementPosition(elm, x, y, z)
    setElementData(elm, "kumar-obje", obje)
    setElementDimension(obje, dim)
    setElementInterior(obje, int)
    attachElements(elm, obje)
    if id then
        setElementData(elm, "kumar-slot", id)
    end
    return elm
end

function slotRemove ( player, id )
    dbQuery(function(qh)
        local results = dbPoll(qh, 0)
        local result = results[1]
        if result then
            local elm, obje = getSlotFromID(id)
            if elm then destroyElement(elm) end
            if obje then destroyElement(obje) end
            outputChatBox("slot id com sucesso: "..id.." excluído.", player, 255, 255, 255)
            dbExec(db, "DELETE FROM kumarslots WHERE id = ?", id)
        else
            outputChatBox("Nenhum slot encontrado!", player, 255, 255, 255)
        end
    end, db, "SELECT id FROM kumarslots WHERE id = ?", id)
end

function getSlotFromID ( id )
    for _, elm in ipairs(getElementsByType("kumar-slot")) do
        local id_ = getElementData(elm, "kumar-slot")
        if id_ == id then
            local obje = getElementData(elm, "kumar-obje")
            return elm, obje
        end
    end
    return false
end


--
function getPositionFromElementOffset(element,offX,offY,offZ)
    local m = getElementMatrix ( element )  -- Get the matrix
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z                               -- Return the transformed point
end