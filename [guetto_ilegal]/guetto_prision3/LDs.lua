---
    --» sᴄʀɪᴘᴛ ғᴇɪᴛᴏ ᴘᴏʀ » Pedrooooo#1554
--]]

local db = dbConnect('sqlite', 'prision.sqlite') 
dbExec(db, 'Create table if not exists prisons(id INTEGER, remain_time REAL, organization TEXT, articles TEXT)')

local peds = {}
local sphere = createColSphere(193.501, 1412.166, 12.008, 60)

for i, v in ipairs(config.peds) do 
    peds[i] = createPed(204, v[1], v[2], v[3], v[4])
    setElementFrozen(peds[i], true)

    addEventHandler('onElementClicked', peds[i], 
    function(b, s, player) 
        if (b == 'left' and s == 'down') then 
            if (isElement(player) and getElementType(player) == 'player' and not isPedInVehicle(player) and getPlayerPermission(player, config.prison.acls)) then 
                local pos_player = {getElementPosition(player)}
                local pos_receiver = {getElementPosition(source)}
                if (getDistanceBetweenPoints3D(pos_player[1], pos_player[2], pos_player[3], pos_receiver[1], pos_receiver[2], pos_receiver[3]) <= 8) then 
                    triggerClientEvent(player, 'onClientDrawPrison', player)
                end 
            end 
        end 
    end
)
end


addEventHandler('onColShapeLeave', sphere,
    function (player, dimension)
        if player and isElement(player) and getElementType(player) == 'player' and dimension then 
            if getElementData(player, "guetto:punido") then 
                setElementPosition(player, unpack(config.prison.prisoner_pos)) 
            end
        end
    end
)

addEventHandler('onResourceStart', getResourceRootElement(getThisResource()), 
    function()
        setTimer(function()
            for _, player in ipairs(getElementsByType('player')) do 
                setElementData(player, 'guetto:punido', false)
                if (isPlayerStuck(player)) then 
                    setPlayerInPrison(player)
                end    
            end
        end, 5000, 1)
    end
)

addEventHandler('onPlayerLogin', root,
    function()
        setTimer(function(player)
            setElementData(player, 'guetto:punido', false)
            if (isPlayerStuck(player)) then 
                setPlayerInPrison(player)
            end  
        end, 5000, 1, source)
    end
)


function getPrisioners ( )
    local data = dbPoll(dbQuery(db, 'Select * from prisons'), -1)
    return data 
end

addEvent('onPlayerArrestReceiver', true) 
addEventHandler('onPlayerArrestReceiver', root, 
    function(player, receiver, years, organization, articles) 
        if (getPlayerPermission(player, config.prison.acls)) then 

            if not (config.prison.arrest_police) then 
                if (getPlayerPermission(receiver, config.prison.acls)) then 
                    return message(player, 'Você não pode prender um policial!', 'error') 
                end 
            end 

            if not (isPlayerStuck(receiver)) then 

                if (getPlayerPermission(receiver, config.vips_acls)) then 
                    dbExec(db, 'Insert into prisons (id, remain_time, organization, articles) Values(?, ?, ?, ?)', (getElementData(receiver, 'ID') or 'N/A'), (tonumber(years) * 60000) * 0.8, organization, articles) 
                else 
                    dbExec(db, 'Insert into prisons (id, remain_time, organization, articles) Values(?, ?, ?, ?)', (getElementData(receiver, 'ID') or 'N/A'), (tonumber(years) * 60000), organization, articles) 
                end
                --triggerEvent("MeloSCR:addLogsGroup", player, player, "O jogador(a) "..getPlayerName(player).." Fez uma prisão.", "Apreendidos", 1, 0)
                setPlayerInPrison(receiver)
                message(player, 'Cidadão foi preso e enviado para o presidio!', 'success')
                exports['guetto_interaction']:setPlayerCuffed(receiver, false)
            else
                message(player, 'Cidadão já está preso!', 'error') 
            end

        else 
            message(player, 'Você não é policial e não pode prender ninguém!', 'error')
        end
    end
)
local years_timer = {}
function setPlayerInPrison(player) 
    if (isPlayerStuck(player)) then 
        local time, organization, articles = getPrisonData(player)
        setElementData(player, "guetto:punido", true)
        setElementPosition(player, unpack(config.prison.prisoner_pos))
        triggerClientEvent(player, 'onClientDrawYearsTimer', player, time, organization, articles)
        if (isTimer(years_timer[player])) then killTimer(years_timer[player]) end 
        years_timer[player] = setTimer(function(player)
            if (isElement(player) and isPlayerStuck(player)) then
                local time = getPrisonData(player)     
                if (time - 1000) > 0 then 
                    dbExec(db, 'Update prisons set remain_time = ? where id = ?', (time - 1000), (getElementData(player, 'ID') or 'N/A'))
                else 
                    removePlayerFromPrison(player)
                    setElementData(player, "guetto:punido", false)
                    message(player, 'Você cumpriu sua pena e foi liberado da prisão!', 'success')
                end
            else
                if (isTimer(years_timer[player])) then killTimer(years_timer[player]) end 
            end
        end, 1000, 0, player)
    end
end

addEventHandler('onPlayerWasted', root, 
    function()
        setTimer(function(player)
            if (isElement(player)) then 
                if (isPlayerStuck(player)) then 
                    setPlayerInPrison(player)
                end    
            end
        end, 5000, 1, source)
    end
)

local bail = createMarker(Vector3(unpack(config.bail.marker_position)), 'cylinder', 1.1, r, g, b, 0)
setElementData(bail, 'markerData', {title = 'Fiança', desc = 'Libere algum dentento!', icon = 'jail'})

addEventHandler('onMarkerHit', bail, 
    function(player) 
        if (isElement(player) and getElementType(player) == 'player' and not isPedInVehicle(player) and getPlayerPermission(player, config.bail.acls)) then 
            triggerClientEvent(player, 'onClientDrawBail', player, getPrisioners())
        end 
    end
)

addEvent('onPlayerPayBail', true)
addEventHandler('onPlayerPayBail', root, 
    function(player, receiver, price) 
        if (isElement(receiver)) then 
            if (isPlayerStuck(receiver)) then 
                if (getPlayerMoney(player) >= tonumber(price)) then 
                    takePlayerMoney(player, tonumber(price)) 
                    removePlayerFromPrison(receiver) 
                    message(player, 'Você pagou a fiança!', 'success')
                    message(receiver, 'Sua fiança foi paga!', 'success')
                else 
                    message(player, 'Você não tem dinheiro suficiente!', 'error')
                end
            else 
                message(player, 'Cidadão não está preso!', 'error')
            end 
        else
            message(player, 'Algo deu errado, cidadão não encontrado!', 'error') 
        end
    end
)

local hacked = false
local entrance_principal = createObject(config.gates.id_object_principal, unpack(config.gates.position_principal))
local marker_principal = createMarker(config.gates.position_principal[1], config.gates.position_principal[2], config.gates.position_principal[3]-1, 'cylinder', 14, 255, 255, 255, 0)
setElementAlpha(entrance_principal, 0)


addEventHandler('onMarkerHit', marker_principal, 
    function(player)
        if (isElement(player) and getElementType(player) == 'player') then 
            if (getPlayerPermission(player, config.prison.acls)) then 
                if not (hacked) then 
                    moveObject(entrance_principal, 1000, 243.234, 1432.759, 12.008-10)
                else
                    if (isPlayerStuck(player)) then 
                        removeElementData(player, 'guetto:punido')
                        dbExec(db, 'Delete from prisons where id = ?', (getElementData(player, 'ID') or 'N/A'))
                        triggerClientEvent(player, 'onClientRemoveYearsTimer', player)
                        message(player, 'Você fugiu da prisão, saia correndo!', 'info')
                    end
                end
            end
        end
    end
)

addEventHandler('onMarkerLeave', marker_principal, 
    function(player)
        if (isElement(player) and getElementType(player) == 'player') then 
            if (getPlayerPermission(player, config.prison.acls)) then 
                if not (hacked) then 
                    moveObject(entrance_principal, 1000, config.gates.position_principal[1], config.gates.position_principal[2], config.gates.position_principal[3])
                end
            end
        end
    end
)

local gate_in_prison = createObject(config.gates.id_gate_in_prison, config.gates.position_in_prison[1], config.gates.position_in_prison[2], config.gates.position_in_prison[3], config.gates.position_in_prison[4], config.gates.position_in_prison[5], config.gates.position_in_prison[6])
local gate_in_prison2 = createObject(config.gates.id_gate_in_prison, config.gates.position_in_prison2[1], config.gates.position_in_prison2[2], config.gates.position_in_prison2[3], config.gates.position_in_prison2[4], config.gates.position_in_prison2[5], config.gates.position_in_prison2[6])

local hacking_gate = createObject(config.hacking.gate_id, unpack(config.hacking.gate_position))
local hacking_marker_open = createMarker(config.hacking.gate_position[1], config.hacking.gate_position[2], config.hacking.gate_position[3] - 2, 'cylinder', 5, 255, 255, 255, 0)

addEventHandler('onMarkerHit', hacking_marker_open, 
    function(player)
        if (isElement(player) and getElementType(player) == 'player') then 
            if (getPlayerPermission(player, config.hacking.acls)) then 
            end
        end
    end
)

addEvent('onPlayerUseLockpickHack', true)
addEventHandler('onPlayerUseLockpickHack', root, 
    function()
        local pos, pos_gate = {getElementPosition(source)}, {getElementPosition(hacking_marker_open)}
        if (getDistanceBetweenPoints3D(pos[1], pos[2], pos[3], pos_gate[1], pos_gate[2], pos_gate[3]) <= 5) then 
            moveObject(hacking_gate, 4000, 240.524+0.5, 1409.632-0.3, 11.11-5)
        end
    end
)

local hacking = createObject(2972, unpack(config.hacking.marker_position))
setElementAlpha(hacking, 0)
addEventHandler('onElementClicked', hacking, 
    function(b, s, player) 
        if (b == 'left' and s == 'down') then 
            if (isElement(player) and getElementType(player) == 'player' and not isPedInVehicle(player) and getPlayerPermission(player, config.hacking.acls)) then 
                local pos_player = {getElementPosition(player)}
                local pos_receiver = {getElementPosition(source)}

                if (getDistanceBetweenPoints3D(pos_player[1], pos_player[2], pos_player[3], pos_receiver[1], pos_receiver[2], pos_receiver[3]) <= 5) then 
                    if not (isTimer(delay_hacking)) then 
                       local assault_run = false 
                      

                       for i, v in ipairs(getElementsByType('player')) do 
                           if (getElementData(v, 'service.police')) then 
                               assault_run = true 
                           end
                       end

                        if (assault_run) then 
                            triggerClientEvent(player, 'onClientDrawHacking', player)
                        else 
                            message(player, "Não existem policiais que ativos na cidade", 'error')
                        end
                    else
                        message(player, 'Prisão foi hackeada recentemente!', 'error')
                    end
                end
            end 
        end
    end
)

addEvent('onPlayerHackedPrison', true)
addEventHandler('onPlayerHackedPrison', root, 
    function() 
        message(root, 'O sistema penitenciário foi invadido, todos os presos estão sujeitos a sair!', 'info') 
        hacked = true 
        delay_hacking = setTimer(function() end, (config.hacking.delay * 60000), 1)
        moveObject(entrance_principal, 2000, -2228.029, 2343.176, -3.4)
        moveObject(gate_in_prison, 7000, 245.69999694824, 1415.3000488281, 11)
        moveObject(gate_in_prison2, 7000, 217.69999694824, 1415.4000244141, 11)
        triggerClientEvent(root, "DL.drawnSound3d", source, {246.124, 1415.711, 12.008})

        for i = 1, #getElementsByType("player") do 
            local v = getElementsByType("player")[i]
            if (getElementData(v, "guetto:punido") or false) then 
                setElementData(v, "guetto:punido", false)
            end
        end

        setTimer(function()
            hacked = false 
            moveObject(entrance_principal, 2000, config.gates.position_principal[1], config.gates.position_principal[2], config.gates.position_principal[3])
            moveObject(gate_in_prison, 9000, config.gates.position_in_prison[1], config.gates.position_in_prison[2], config.gates.position_in_prison[3])
            moveObject(gate_in_prison2, 9000, config.gates.position_in_prison2[1], config.gates.position_in_prison2[2], config.gates.position_in_prison2[3])
            moveObject(hacking_gate, 2000, config.hacking.gate_position[1], config.hacking.gate_position[2], config.hacking.gate_position[3])
            message(root, 'Os portões da prisão estão sendo fechados novamente!', 'info')
        end, config.hacking.time_open_prison * 60000, 1)
    end
)

addEvent('onPlayerCallCopsPrison', true)
addEventHandler('onPlayerCallCopsPrison', root, 
    function()
        for _, v in ipairs(getElementsByType('player')) do 
            if (getPlayerPermission(v, config.prison.acls)) then 
                message(v, 'ATENÇÃO: A penitenciaria está sendo invadida [Prioridade]!', 'info')
            end
        end
    end
)

local box, blip, marker, owner = {}, {}, {}, {}
local colect_box = createObject(2972, 194.091, 1441.957, 12.008)
local colect_marker = createMarker(175.165, 1369.897, 12.008, 'cylinder', 4, 0, 0, 0, 0)
setElementAlpha(colect_box, 0)

addEventHandler('onMarkerHit', colect_marker, 
    function(player)
        if (isElement(player) and getElementType(player) == 'player' and not isPedInVehicle(player) and isPlayerStuck(player)) then 
            executeJob(player)
        end 
    end
)

addEventHandler("onClientKey", root, 
function(key)
    if (isElement(player) and getElementType(player) == 'player' and not isPedInVehicle(player) and isPlayerStuck(player)) then 
        if key == "control" or key == "F4" then 
            cancelEvent()
        end
    end
end)

function executeJob(player) 
    local x, y, z = getElementPosition(player)
    box[player] = createObject(2912, x, y, z)
    setObjectScale(box[player], 0.5)
    setElementCollisionsEnabled(box[player], false)
    
    exports['pAttach']:attach(box[player], player, 24, 0.08, 0.4, -0.02, 0, 120, 10)
    triggerClientEvent(root, 'onClientPickupPrisonBox', root, player)
    toggleControl(player, 'sprint', false)

    if (isElement(marker[player])) then destroyElement(marker[player]) end 
    if (isElement(blip[player])) then destroyElement(blip[player]) end 

    local random = math.random(#config.job.delivery_box_markers)
    marker[player] = createMarker(Vector3(config.job.delivery_box_markers[random]), 'checkpoint', 4, r, g, b, 0, player) 
    --blip[player] = createBlipAttachedTo(marker[player], 0, _, _, _, _, _, _, 999, player)
    owner[marker[player]] = player
    addEventHandler('onMarkerHit', marker[player], refreshJob)
end

function refreshJob(player) 
    if (isElement(player) and getElementType(player) == 'player' and not isPedInVehicle(player)) then 
        if (isPlayerStuck(player)) then 
            if (isElement(box[player])) then 
                if (owner[source] == player) then 
                    destroyElement(box[player])
                    if (isElement(blip[player])) then destroyElement(blip[player]) end 
                    if (isElement(marker[player])) then destroyElement(marker[player]) end 
                    toggleControl(player, 'sprint', true)
                    setPedAnimation(player, 'CARRY', 'putdwn')
                    triggerClientEvent(root, 'onClientLeavePrisonBox', root, player)

                    setTimer(function(player)
                        if (isElement(player)) then 
                            setPedAnimation(player, nil)
                        end 
                    end, 1000, 1, player)
                    
                    local time, organization, articles = getPrisonData(player)
                    if (time - 20000) > 0 then 
                        triggerClientEvent(player, 'onClientDrawYearsTimer', player, time, organization, articles)   
                        dbExec(db, 'Update prisons set remain_time = ? where id = ?', (time - 20000), (getElementData(player, 'ID') or 'N/A'))
                    else 
                        removePlayerFromPrison(player)
                        message(player, 'Você cumpriu sua pena e foi liberado da prisão!', 'success')
                    end
                end
            end
        end
    end
end

addEventHandler('onPlayerQuit', root, 
    function()
        if (isElement(box[source])) then destroyElement(box[source]) end
        if (isElement(blip[source])) then destroyElement(blip[source]) end 
        if (isElement(marker[source])) then destroyElement(marker[source]) end 
    end
)

function removePlayerFromPrison(player)
    setElementData(player, 'guetto:punido', false)
    setElementPosition(player, unpack(config.prison.free_pos))
    dbExec(db, 'Delete from prisons where id = ?', (getElementData(player, 'ID') or 'N/A'))
    triggerClientEvent(player, 'onClientRemoveYearsTimer', player)
end

function getPrisonData(player) 
    local data = dbPoll(dbQuery(db, 'Select * from prisons where id = ?', (getElementData(player, 'ID') or 'N/A')), -1)
    if (#data ~= 0) then 
        return data[1]['remain_time'], data[1]['organization'], data[1]['articles']
    else
        return false 
    end 
end

function getPrisioners()
    local prisioners = {}
    for i, v in ipairs(getElementsByType('player')) do 
        if (isPlayerStuck(v)) then 
            local time = getPrisonData(v)
            local price = (time / 1000) * config.bail.price_per_second
            table.insert(prisioners, {v, time, price})
        end 
    end

    return prisioners
end

function isPlayerStuck(player) 
    if (#dbPoll(dbQuery(db, 'Select * from prisons where id = ?', (getElementData(player, 'ID') or 'N/A')), -1) ~= 0) then 
        return true 
    else
        return false 
    end  
end

function getPlayerPermission(player, acls) 
    for i, v in ipairs(acls) do 
        if (isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(player)), aclGetGroup(v))) then 
            return true 
        end 
    end
end