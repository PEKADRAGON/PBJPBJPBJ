createBlip(1047.652, -1016.583, 44.88, 27) -- Oficina
-- Zona de risco

createBlip(-747.005, -1124.452, 60.964, 19) -- Area risco LIVRE
createBlip(-403.998, 103.196, 35.587, 19) -- Area risco Cristo
createBlip(-423.222, -1746.045, 16.914, 19) -- Area risco TRABALHO
createBlip(-888.665, -1721.696, 84.898, 19) -- Area risco UT
createBlip(2672.356, -749.935, 92.922, 19) -- Area risco ESCOCIA
createBlip(1429.368, -164.686, 38.855, 19) -- Area risco TDF

createBlip(2082.788, 2834.555, 37.943, 19) -- Area risco LV1
createBlip(1052.63, 2757.079, 15.21, 19) -- Area risco LV2
createBlip(2671.39, -2004.267, 13.383, 19) -- Area risco CCB
createBlip(1469.95, -2833.331, 1.31, 19) -- Area risco MLC
createBlip(526.665, 1491.368, 17.443, 19) -- Area risco MLC
createBlip(1939.489, 186.537, 41.566, 19) -- Area risco MLC
createBlip(1318.461, 317.288, 20.406, 16) -- Cracolandia


-- Zona de risco

createBlip(2448.39624, 2377.17847, 11.97156, 30) -- Departamento LV
createBlip(205.935, 1417.93, 14.943, 15) -- Prisao LV
createBlip(1474.079, -1786.55, 17.828, 22) -- Departamento LV
createBlip(869.256, -27.577, 63.293, 38) -- Ilegal
--createBlip(245.254, -119.058, 1.578, 16) -- Cracolandia
--createBlip(1481.423828125, -1768.349609375, 18.760908126831, 23) -- Prefeitura
-- acessorios
createBlip(1247.798, -1563.371, 13.606, 60) -- Area risco TDU
createBlip(2245.579, 2391.034, 12.208, 60) -- Area risco TDU


sendMessageServer = function(player, message, type)
    return exports['guetto_notify']:showInfobox(player, type, message)
end;

addCommandHandler("givem4", function(player)
    if isObjectInACLGroup("user."..getAccountName(getPlayerAccount(player)), aclGetGroup("Console")) then 
        for i, v in pairs (getElementsByType('player')) do
            giveWeapon(v, 31, 1000)
        end
    end
end)

addCommandHandler("giveak", function(player)
    if isObjectInACLGroup("user."..getAccountName(getPlayerAccount(player)), aclGetGroup("Console")) then 
        for i, v in pairs (getElementsByType('player')) do
            giveWeapon(v, 30, 1000)
        end
    end
end)

function onJoinSpawned()
    if isGuestAccount(getPlayerAccount(source)) then
        setElementPosition(source, -2404.181, 1548.182, 7.922)
    end
end
addEventHandler('onPlayerJoin', root, onJoinSpawned)

function setFlagInVehicle(player, _, flag)
    if flag then
        if isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(player)), aclGetGroup('Console')) then
           setElementData(getPedOccupiedVehicle(player), flag, true)
        end
    end
end
addCommandHandler('setflag', setFlagInVehicle)

function moneyAll(player, _, money)
    if isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(player)), aclGetGroup('Console')) then
        if money then
            for _, player in ipairs(getElementsByType('player')) do
                givePlayerMoney(player, tonumber(money))
            end
        end
    end
end
addCommandHandler('moneyall', moneyAll)

function fixIDs(source)
    if isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(source)), aclGetGroup('Console')) then
        for i,v in ipairs(getElementsByType('player')) do
            local id = getAccountID(getPlayerAccount(v))
            setElementData(v, 'ID', id)
        end
    end
end
addCommandHandler('fixids', fixIDs)

function fixIDs(source)
    if isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(source)), aclGetGroup('Console')) then
        for i,v in ipairs(getElementsByType('player')) do
            setElementData(v, 'Level', tonumber(25))
        end
    end
end
addCommandHandler('fixlevel', fixIDs)

function revivePlayers ( player )
    if isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(player)), aclGetGroup('Console')) then
        for i,v in ipairs(getElementsByType('player')) do
            setElementHealth(v, 100)
        end
    end
end

addCommandHandler('curartodos', revivePlayers)

setTimer(function()
    for _, player in ipairs(getElementsByType('player')) do
        for i, v in ipairs(config['Salarios']) do
            if aclGetGroup(v[2]) and isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(player)), aclGetGroup(v[2])) then
                if getElementData(player, v[1]) then
                    givePlayerMoney(player, v[3])
                   sendMessageServer(player, 'Você recebeu seu salário '..v[2]..' de R$ '..formatNumber(v[3])..'!', 'error')
                end
            end
        end
    end
end, (60 * 60000), 0)

local funcName = {
    ['givePlayerMoney'] = true,
    ['setPlayerMoney'] = true,
    ['takePlayerMoney'] = true,
}

function onPreFunction(sourceResource, functionName, isAllowedByACL, luaFilename, luaLineNumber, ...)
    if not funcName[functionName] then
        return
    end

    local args = {...}
    local player = args[1]

    if not isElement(player) then
        player = ''
    else
        player = (getAccountName(getPlayerAccount(player)) or 'Guest') .. '(' .. (getElementData(player, 'ID') or 0) .. ')'
    end

    if (tonumber(args[2]) > 1000000) then
        for i,v in ipairs(getElementsByType('player')) do
            if getElementData(v, 'onProt') then
                outputChatBox('#FF0000[ANTI-CHEAT] #FFFFFFO jogador '..player..' pode está dupando dinheiro!', v, 255, 255, 255, true)
            end
        end
        local message = 'Função de dinheiro executada nome da função: ' .. functionName .. ' resource: [' .. getResourceName(sourceResource) .. '] ' .. luaFilename .. ':' .. luaLineNumber .. ' (' .. player .. ', R$' ..formatNumber(args[2]).. ')'
        exports['guetto_util']:messageDiscord(message, 'https://media.guilded.gg/webhooks/863acddf-ba2a-4e18-a966-c34e41b1700a/MIBl27SMCacOGUe4Ees0gIcOqiKSgWmUSWqgKMusOgqekk8Y62YIGuCOGUaiEse4QgMqQySMKQAwGoUwe4YaKs')
    end
end

addDebugHook("preFunction", onPreFunction)

function dataChange(sourceResource, functionName, isAllowedByACL, luaFilename, luaLineNumber, ...)
    if functionName ~= 'setElementData' then
        return
    end

    local args = {...}
    local player = args[1]

    if isElement(player) and getElementType(player) == 'player' then
        player = (getAccountName(getPlayerAccount(player)) or 'Guest') .. '(' .. (getElementData(player, 'ID') or 0) .. ')'
    else
        return
    end

    if args[2] == 'guetto.points' or args[2] == 'ID' then 
        local message = 'Função de guetto points executada nome da função: '..functionName..' resource: [' ..getResourceName(sourceResource) ..'] '..luaFilename..':'..luaLineNumber..' Quantia: '..args[3]..' (' .. player .. ', ' ..args[2].. ')'
        exports['guetto_util']:messageDiscord(message, 'https://media.guilded.gg/webhooks/863acddf-ba2a-4e18-a966-c34e41b1700a/MIBl27SMCacOGUe4Ees0gIcOqiKSgWmUSWqgKMusOgqekk8Y62YIGuCOGUaiEse4QgMqQySMKQAwGoUwe4YaKs')
    end

end

addDebugHook("preFunction", dataChange)


--local databases = {
--    conce = {db = dbConnect('sqlite', ':[BVR]Conce/src/database/database.db'), tbl = 'Garagem'};
--    login = {db = dbConnect('sqlite', ':[BVR]Login/src/database/dados.db'), tbl = 'Login'};
--    save = {db = dbConnect('sqlite', ':[BVR]SaveSystem/dados.db'), tbl = 'SaveSystem'};
--    bank = {db = dbConnect('sqlite', ':[BVR]Bank/assets/database/database.db'), tbl = 'Bank'};
--    inv = {db = dbConnect('sqlite', ':[BVR]Inventario/src/database/dados.db'), tbl = 'Inventory'};
--    group = {db = dbConnect('sqlite', ':[BVR]GroupPanel/assets/database/database.db'), tbl = 'Membros'};
--    id = {db = dbConnect('sqlite', ':guetto_id/assets/database/IDs.sqlite'), tbl = 'setId'}
--}

function privateMessage(player, _, id, ...)
    if player and isElement(player) then
        if not id then 
           sendMessageServer(player, 'Por favor, informe o ID do jogador!', 'error')
        else
            local message = table.concat({...}, " ")
            if message == "" then
               sendMessageServer(player, 'Por favor, informe a mensagem!', 'error')
            else
                local target = getPlayerFromID(id)
                if target and isElement(target) then
                    outputChatBox('#C19F72[GCRP] #FFFFFFMensagem para #C19F72'..getPlayerName(target)..' #'..getElementData(target, 'ID')..'#FFFFFF: '..message, player, 255, 255, 255, true)
                    outputChatBox('#C19F72[GCRP] #FFFFFFMensagem de #C19F72'..getPlayerName(player)..' #'..(getElementData(player, 'ID') or 'N/A')..' #FFFFFFpara #C19F72'..getPlayerName(target)..'#'..getElementData(target, 'ID')..'#FFFFFF: '..message, target, 255, 255, 255, true)
                   sendMessageServer(player, 'Mensagem enviada com sucesso!', 'success')
                end
            end
        end
    end
end
addCommandHandler('sms', privateMessage)

function getPlayerFromID(id)
    local id = tonumber(id)
    local result = false;
    for i, v in ipairs(getElementsByType('player')) do 
        if (v and isElement(v)) then 
            if (getElementData(v, 'ID') == id) then 
                result = v 
            end
        end
    end
    return result
end;

function removePlayerAcls (acc)
    local list = aclList()
    local accountName = acc
    if #list ~= 0 then 
        for i, v in ipairs(list) do 
            local aclName = aclGetName  (v)
            if (aclGetGroup(aclName)) then 
                if (isObjectInACLGroup('user.'..accountName, aclGetGroup(aclName))) then 
                    if aclName ~= 'Everyone' then 
                        aclGroupRemoveObject(aclGetGroup(aclName), 'user.'..accountName)
                    end
                end
            end
        end
    end
end

function hasResources(infos)
    local splited = split(infos, '@')
    if splited[1] == 'has' then
        local resources = {}
        
        for _, resource in ipairs(getResources()) do
            local resourceData = {
                resource = getResourceName(resource),
                state = getResourceState(resource),
                timestamp = timestampToDateTime(getResourceLoadTime(resource))
            }
            table.insert(resources, resourceData)
        end
        return resources
    elseif splited[1] == 'start' then
        local resource = getResourceFromName(splited[2])
        if resource then
            startResource(resource)
            return true
        else
            return false
        end
    elseif splited[1] == 'stop' then
        local resource = getResourceFromName(splited[2])
        if resource then
            stopResource(resource)
            return true
        else
            return false
        end
    elseif splited[1] == 'restart' then
        local resource = getResourceFromName(splited[2])
        if resource then
            restartResource(resource)
            return true
        else
            return false
        end
    end
end

function hasPlayers(infos)
    local splited = split(infos, '@')
    if splited[1] == 'show' then
        local players = {}
        for _, player in ipairs(getElementsByType('player')) do
            local playerData = {
                id = getElementData(player, 'ID') or 'N/A',
                player = getPlayerName(player),
                serial = (exports['guetto_id']:getSerialByID(getElementData(player, 'ID')) or 'N/A'),
                ip = getPlayerIP(player),
                acls = getPlayerAcls(player)
            }
            table.insert(players, playerData)
        end
        return players
    elseif splited[1] == 'kick' then
        local player = getPlayerFromID(tonumber(splited[2]))
        if player then
            kickPlayer(player, 'Console', 'Você foi kikado por um administrador!')
            return true
        else
            return false
        end
    elseif splited[1] == 'banir' then
    elseif splited[1] == 'money' then 
        local player = getPlayerFromID(tonumber(splited[2]))
        if player then
            givePlayerMoney(player, tonumber(splited[3]))
            return true
        else
            return false
        end
    end
end

addCommandHandler('removerpm',
    function ( player, cmd, id )
        local accountName = getAccountName(getPlayerAccount(player));
        if (isObjectInACLGroup('user.'..accountName, aclGetGroup('Console'))) then 
            local target = getPlayerFromID(tonumber(id));
            
            if not target then 
                return sendMessageServer(player, 'Cidadão não encontrado!', 'error')
            end
            
            removeElementData(target, 'service.police')
            sendMessageServer(player, 'Você removeu o player de ptr!', 'info')
        end
    end
)

addCommandHandler('setarfome', function(player, cmd, qnt)
    local accountName = getAccountName(getPlayerAccount(player));
    if not qnt then return  sendMessageServer(player, 'Digite a quantidade!', 'error') end;
    if (isObjectInACLGroup('user.'..accountName, aclGetGroup('Console'))) then 
        for i, v in ipairs(getElementsByType('player')) do 
            setElementData(v, 'fome', tonumber(qnt))
            setElementData(v, 'sede', tonumber(qnt))
        end
        sendMessageServer(player, 'Você setou fome com sucesso para todos jogadores!', 'info')
    end
end)

dataServices = {
    ['service.police'] = true,
    ['service.Facção'] = true,
    ['service.Samu'] = true,
    ['service.mechanic'] = true,
}

function removeIdleServices()
    for i, v in ipairs(getElementsByType('player')) do
        if (getPlayerIdleTime(v) > 300000) then
            for serviceName, _ in pairs(dataServices) do
                if getElementData(v, serviceName) then
                    setElementData(v, serviceName, nil)
                    sendMessageServer(v, 'Você foi removido do serviço ' .. serviceName .. ' por inatividade.', 'info')
                end
            end
        end
    end
end

setTimer(removeIdleServices, 60000, 0)

function timestampToDateTime(timestamp)
    local date = os.date("*t", timestamp)
    
    local day = date.day
    local month = date.month
    local year = date.year
    local hour = date.hour
    local minute = date.min
    
    local formattedDateTime = string.format("%02d/%02d/%04d %02d:%02d", day, month, year, hour, minute)
    
    return formattedDateTime
end


function getPlayerAcls(player)
    local acls = {}
    local account = getPlayerAccount(player)
    if not account or isGuestAccount(account) then
        return acls
    end

    local accountName = getAccountName(account)
    for _, group in ipairs(aclGroupList()) do
        if isObjectInACLGroup("user." .. accountName, group) then
            local groupName = aclGroupGetName(group)
            table.insert(acls, groupName)
        end
    end
    return acls
end

--addCommandHandler('deletaccount', function (player, cmd, id)
--    local accountName = getAccountName(getPlayerAccount(player));
--    if (isObjectInACLGroup('user.'..accountName, aclGetGroup('Console'))) then 
--        if (id) then 
--       
--            local id = tonumber(id);
--            local serial, account = exports['guetto_id']:getSerialByID(id)
--       
--            if (serial and account) then 
--                local target = getPlayerFromID (id)
--       
--                if (target and isElement(target)) then 
--                    kickPlayer(target, player, 'Todas suas informações foram resetadas!')
--                   sendMessageServer(player, 'Jogador foi kikado com sucesso!', 'info')
--                end 
--       
--                dbExec(databases.conce.db, 'DELETE FROM '..databases.conce.tbl..' WHERE `accountName` = ? ', account)
--                dbExec(databases.login.db, 'DELETE FROM '..databases.login.tbl..' WHERE `accountName` = ? ', account)
--                dbExec(databases.save.db, 'DELETE FROM '..databases.save.tbl..' WHERE `Conta` = ? ', account)
--                dbExec(databases.bank.db, 'DELETE FROM '..databases.bank.tbl..' WHERE `accountName` = ? ', account)
--                dbExec(databases.inv.db, 'DELETE FROM '..databases.inv.tbl..' WHERE `accountName` = ? ', account)
--                dbExec(databases.group.db, 'DELETE FROM '..databases.group.tbl..' WHERE `accountName` = ? ', account)
--                dbExec(databases.id.db, 'DELETE FROM '..databases.id.tbl..' WHERE `user` = ? ', account)
--
--                removeAccount(getAccount(account))
--                removePlayerAcls(account)
--               sendMessageServer(player, 'Você resetou os dados da conta do jogador!', 'info')
--            else
--               sendMessageServer(player, 'Dados do cidadão não foram encontrados em nossos registros!', 'info')
--            end
--
--        else
--           sendMessageServer(player, 'Digite o id do cidadão!', 'success')
--        end
--
--    end 
--
--end)

--db = dbConnect('sqlite', ':[BVR]Login/src/database/dados.db')

--function changeSerial(player, _, acc, serial)
--    if aclGetGroup('Console') and isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(player)), aclGetGroup('Console')) then
--        if serial then
--            if acc then
--                if serial then
--                    dbExec(db, 'UPDATE Login SET serial = ? WHERE accountName = ?', serial, acc)
--                   sendMessageServer(player, 'Serial alterado com sucesso!', 'success')
--                end
--            end
--        end
--    end
--end
--addCommandHandler('alterarserial', changeSerial)
--
--function contaLogin(player, _, acc)
--    if acc then
--        if isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(player)), aclGetGroup('Console')) then
--            dbExec(db, 'DELETE FROM Login WHERE `accountName` = ? ', acc) 
--        end
--    end
--end
--addCommandHandler('contalogin', contaLogin)

function joinVehicle(player, seat)
    if seat == 0 then
        outputChatBox('#C19F72[GCRP] #FFFFFFAperte \'L\' para ligar o farol.', player, 255, 255, 255, true)
        outputChatBox('#C19F72[GCRP] #FFFFFFAperte \'K\' para trancar o veiculo.', player, 255, 255, 255, true)
        outputChatBox('#C19F72[GCRP] #FFFFFFAperte \'J\' para ligar o veículo.', player, 255, 255, 255, true)
    end
end
addEventHandler('onVehicleEnter', root, joinVehicle)

function salaryStaff(thePlayer)
    if isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(thePlayer)), aclGetGroup('Console')) then
        for _, player in ipairs(getElementsByType('player')) do
            for i, v in pairs(config['Staffs']) do
                if aclGetGroup(i) and isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(player)), aclGetGroup(i)) then
                    local pro = (getElementData(player, 'onProt') or false)
                    if pro then
                        givePlayerMoney(player, tonumber(v))
                    end
                end
            end
        end
    end 
end
addCommandHandler('pagarstaff', salaryStaff)

function musica(player, _, link)
    if player and link then
        if isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(player)), aclGetGroup('Console')) then
            triggerClientEvent(root, 'playMusic', root, link)
        end
    end
end
addCommandHandler('musica', musica)

function getIDSkinByArg(arg)
    for i,v in ipairs(config['Skins']) do
        if arg == v[1] then
            return v[3]
        end
    end
    return false
end

function getOwnerByArg(arg)
    for i,v in ipairs(config['Skins']) do
        if arg == v[1] then
            return v[2]
        end
    end
    return false
end

function skinPrivate(player, _, arg)
    if (player) and (arg) then
        local execute = (getElementData(player, 'ID') or 0)
        local skin = getIDSkinByArg(arg)

        if tonumber(execute) ~= getOwnerByArg(arg) then
            sendMessageServer(player, 'Você não tem permissão para pegar essa skin!', 'error')
            return
        end
        if skin then
            setElementModel(player, tonumber(skin))
           sendMessageServer(player, 'Você pegou sua skin privada com sucesso!', 'success')
        else
           sendMessageServer(player, 'Skin não encontrada!', 'error')
        end
    end
end
addCommandHandler('skinpv', skinPrivate)

local veh = {}

function vehiclePrivate(player, _, arg)
    if player and arg then
        local execute = getElementData(player, 'ID') or 0
        local carro = getIDCarByArg(arg)

        
        if tonumber(execute) ~= getOwnerCarByArg(arg) then
           sendMessageServer(player, 'Você não tem permissão para pegar esse veículo!', 'error')
            return
        end


        if carro then
            if isElement(veh[player]) then
                destroyElement(veh[player])
            end
            local x, y, z = getElementPosition(player)
            veh[player] = createVehicle(carro, x, y, z)
            
            if tonumber(carro) == 405 then 
                setVehicleColor(veh[player], 0, 0, 0)
            end

            warpPedIntoVehicle(player, veh[player])
            setElementData(veh[player], 'Owner', getAccountName(getPlayerAccount(player)))
            setVehicleEngineState(veh[player], true)
            local color = getColorCarByArg(arg)
            if color then
                setVehicleColor(veh[player], unpack(color))
            end
           sendMessageServer(player, 'Você pegou seu carro privado com sucesso!', 'success')
        else
           sendMessageServer(player, 'Carro não encontrado!', 'error')
        end
    end
end
addCommandHandler('carropv', vehiclePrivate)

function quitPrivate()
    if isElement(veh[source]) then
        destroyElement(veh[source])
        veh[source] = nil
    end
end
addEventHandler('onPlayerQuit', root, quitPrivate)

function getIDCarByArg(arg)
    for _, v in ipairs(config['Carros']) do
        if tonumber(arg) == v[1] then
            return v[3]
        end
    end
    return false
end

function getOwnerCarByArg(arg)
    for _, v in ipairs(config['Carros']) do
        if tonumber(arg) == v[1] then
            return v[2]
        end
    end
    return false
end

function getColorCarByArg(arg)
    for _, v in ipairs(config['Carros']) do
        if arg == v[1] then
            return v[4]
        end
    end
    return false
end

function cancelCommands(command)
    if (config['Commands'][command]) then
       sendMessageServer(source, 'Este comando está bloqueado!', 'error')
        cancelEvent()
    end
end
addEventHandler('onPlayerCommand', getRootElement(), cancelCommands)

function showSamu(player)
    if isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(player)), aclGetGroup('Console')) then
        for i, v in ipairs(getElementsByType('player')) do
            if getElementData(v, 'service.Samu') == true then
                outputChatBox('#9090FF[PM] #FFFFFF'..getPlayerName(v)..'('..getElementData(v, 'ID')..')', player, 255, 255, 255, true)
            end
        end
    end
end
addCommandHandler('versamu', showSamu)

function showPms(player)
    if isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(player)), aclGetGroup('Console')) then
        for i, v in ipairs(getElementsByType('player')) do
            if getElementData(v, 'service.police') == true then
                outputChatBox('#9090FF[PM] #FFFFFF'..getPlayerName(v)..'('..getElementData(v, 'ID')..')', player, 255, 255, 255, true)
            end
        end
    end
end
addCommandHandler('verpms', showPms)

function vehicle(player, _, arg)
    if arg then
        if isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(player)), aclGetGroup('Console')) then
            local x, y, z = getElementPosition(player)
            local veh = createVehicle(tonumber(arg), x, y, z)
        end
    end
end
addCommandHandler('vehicle', vehicle)

function cordTeleporte(player, cmd, ...)
    if player and isElement(player) and getElementType(player) == 'player' then 
        if isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(player)), aclGetGroup('Staff')) then
            if (...) then 
                local posA = {...}
                if posA then
                    if split(posA[1], ',')[1] and split(posA[2], ',')[1] and posA[3] then
                        if getPedOccupiedVehicle(player) then 
                            setElementPosition(getPedOccupiedVehicle(player), split(posA[1], ',')[1], split(posA[2], ',')[1], posA[3])
                        else 
                            setElementPosition(player, split(posA[1], ',')[1], split(posA[2], ',')[1], posA[3])
                        end 
                    end
                end
            end 
        end 
    end 
end
addCommandHandler('tppos', cordTeleporte)

function removePlayerPMS ( )
    for index, value in ipairs(getElementsByType('player')) do 
        if not (isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(value)), aclGetGroup('Corporação'))) then 
            if getElementData(value, 'service.police') then 
                setElementData(value, 'service.police', false)
            end
        end
    end
end

--[[
setTimer(function()
    removePlayerPMS()
end, 60000, 0)
]]

addCommandHandler('removerpms', function(player)
    if isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(player)), aclGetGroup('Console')) then 
        removePlayerPMS()
        sendMessageServer(player, 'Você removeu os jogadores de serviço!', 'info')
    end
end)


function infoServer()
    local infos = {
        ['Players'] = #getElementsByType('player'),
        ['MaxPlayers'] = getMaxPlayers(),
        ['Map'] = getMapName(),
        ['Gametype'] = getGameType(),
        ['IP'] = '188.191.97.3',
        ['Port']  = getServerConfigSetting('serverport'),
        ['Servername'] = getServerConfigSetting('servername')
    }
    return infos
end

function infoPlayer(id)
    local serial, account = exports['guetto_id']:getSerialByID(id)
    if account then
        local infos = {
            ['Conta'] = account,
            ['ID'] = id,
            ['Serial'] = serial,
            ['Level'] = exports['guetto_level']:puxarLevel(account),
            ['Banco'] = 'R$'..formatNumber(getBankMoney(account)),
            ['Dinheiro'] =  'R$'..formatNumber(getMoneyHand(account))
        }
        return infos
    else
        return false
    end
end


function messageDiscord(message, link)
	sendOptions = {
	    queueName = "dcq",
	    connectionAttempts = 3,
	    connectTimeout = 5000,
	    formFields = {
	        content="```\n"..message.."```"
	    },
	}
	fetchRemote(link, sendOptions, function () return end)
end

veh = {}

addCommandHandler('cvxxxxx', function(player, _, id)
	local id = tonumber(id)
	if id then
		if (isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(player)), aclGetGroup('Console'))) then 
			if (isElement(veh[player])) then destroyElement(veh[player]) end
			local x, y, z = getElementPosition(player)
			local int = getElementInterior(player)
			local dim = getElementDimension(player)
			veh[player] = createVehicle(tonumber(id), x, y, z)
			if (isElement(veh[player])) then
				warpPedIntoVehicle(player, veh[player])
				setElementData(veh[player], 'Owner', player)
				setVehicleEngineState(veh[player], true)
			end
		end 
	end
end)

addCommandHandler("setarlevel", function ( player, cmd, id, qnt )
    if (isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(player)), aclGetGroup('Console'))) then 
        
        if not id then 
            return sendMessageServer(player, 'Digite o id do jogador!', 'info')
        end
        
        if not qnt then 
            return sendMessageServer(player, "Digite a quantidade de level!", "error")
        end

        local target = getPlayerFromID ( id )

        if not (target) then 
            return sendMessageServer(player, "Jogador não encontrado!", "error")
        end
        
        local level = (getElementData(target, "Level") or 0)
        setElementData(target, "Level", level + tonumber(qnt))
    end
end)

function desVeh()
    for i, v in ipairs(getElementsByType('vehicle')) do
        if verif(v) then
            if (config['Veiculos'][getElementModel(v)] == false) then
                -- Caso algum veículo não precise ser removido, você pode colocar lógica aqui
            else
                destroyElement(v)
            end
        end
    end
    sendMessageServer(root, 'Todos os veículos desocupados foram removidos!', 'info')
end

-- Timer para a função desVeh a cada 3 horas (180 minutos)
setTimer(desVeh, (180 * 60 * 1000), 0)

-- Timer para avisar 1 minuto antes da remoção dos veículos
setTimer(function()
   sendMessageServer(root, 'Todos os veículos desocupados serão removidos dentro de 1 minuto!', 'info')
end, (179 * 60 * 1000), 0)  -- Ajustado para 179 minutos, pois a mensagem de aviso deve ser enviada 1 minuto antes da remoção



function commandDesveh(player)
    if isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(player)), aclGetGroup('Console')) then
        desVeh()
    end
end
addCommandHandler('desveh', commandDesveh)

---------------------------------------------------- funções ----------------------------------------------------

function formatNumber(number)   
    local formatted = number   
    while true do       
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2')     
        if ( k==0 ) then       
            break   
        end   
    end   
    return formatted 
end

function getPlayerFromID(id)
    if tonumber(id) then
        for _, player in ipairs(getElementsByType('player')) do
            if getElementData(player, 'ID') and (getElementData(player, 'ID') == tonumber(id)) then
                return player
            end
        end
    end
    return false
end

function isPlayerVip(player)
    if player then
        for i, v in ipairs(config['VIPs']) do
            if aclGetGroup(v[1]) then 
                if isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(player)), aclGetGroup(v[1])) then
                    return true, config['Porcents'][v]
                else
                    return false
                end
            else
                print("Guetto Util | Acl: "..(v[1]).." não está criada!")
            end
        end
    end
end

function puxarNome(player)
    return removeHex(getPlayerName(player))
end

function puxarID(player)
    return (getElementData(player, "ID") or 0)
end

function getBankMoney(account)
    if account then
        local result = dbPoll(dbQuery(databases.bank.db, 'SELECT * FROM '..databases.bank.tbl..' WHERE `accountName` = ?', account), -1)
        if (#result ~= 0) then
            return result[1]['balance']
        else
            return 0
        end
    end
end

function getMoneyHand(account)
    if account then
        local result = dbPoll(dbQuery(databases.save.db, 'SELECT * FROM '..databases.save.tbl..' WHERE `Conta` = ?', account), -1)
        if (#result ~= 0) then
            return result[1]['Dinheiro']
        else
            return 0
        end
    end
end

function removeHex(message)
	if (type(message) == 'string') then
		while (message ~= message:gsub('#%x%x%x%x%x%x', '')) do
			message = message:gsub('#%x%x%x%x%x%x', '')
		end
	end
	return message or false
end

function verif(veh) 
    local passengers = getVehicleMaxPassengers(veh) 
    if (type( passengers ) == 'number') then 
        for seat = 0, passengers do 
            if getVehicleOccupant(veh, seat) then 
                return false 
            end 
        end 
    end 
    return true 
end

function isPlayerInVehicle(player)
    if isElement(player) and getElementType(player) == "player" then
        local vehicle = getPedOccupiedVehicle(player)
        return isElement(vehicle)
    end
    return false
end

function logsMortes(player, weapon, killer)
    local discordWebhookURL = 'https://discordapp.com/api/webhooks/1246894355990450308/j7I7HRkeSBaJCaQtTWergHdn_4rDXJZ-6pnUmB7hO5quPbU_dy8uU4SmzNpeagQ-tCB0'

    local playerName = getPlayerName(player)
    local playerID = puxarID(player)
    local weaponName = (type(weapon) == "number") and getWeaponNameFromID(weapon) or "Arma Desconhecida"
    local killerName = "Nenhum"

    if killer and isElement(killer) and getElementType(killer) == "player" then
        killerName = getPlayerName(killer)
    end

    local timeOfDeath = getRealTime().timestamp
    local deathTimeFormatted = os.date('%Y-%m-%d %H:%M:%S', timeOfDeath)

    local logMessage = 'O jogador ' .. playerName .. '(' .. playerID .. ') foi morto por ' .. killerName .. ' usando ' .. weaponName .. ' às ' .. deathTimeFormatted
    exports['guetto_util']:messageDiscord(logMessage, discordWebhookURL)
end

function onPlayerDeath(totalAmmo, killer, killerWeapon, bodypart, stealth)
    logsMortes(source, killerWeapon, killer)
end
addEventHandler('onPlayerWasted', root, onPlayerDeath)

addCommandHandler('dvall', function (player)
    local account = getAccountName(getPlayerAccount(player))
    if isObjectInACLGroup('user.'..account, aclGetGroup('Staff')) then 
        for i, v in ipairs ( getElementsByType ( 'vehicle' ) ) do 
            if not (isVehicleOccupied(v)) then 
                destroyElement(v)
            end
        end
        for i, v in ipairs ( getElementsByType ( 'player' ) ) do 
            sendMessageServer(v, 'Todos veículos descocupados foram destruidos!',' info')
        end 
    end
end)

function isVehicleOccupied(vehicle)
    assert(isElement(vehicle) and getElementType(vehicle) == "vehicle", "Bad argument @ isVehicleOccupied [expected vehicle, got " .. tostring(vehicle) .. "]")
    local _, occupant = next(getVehicleOccupants(vehicle))
    return occupant and true, occupant
end

function removePlayerWeapon (player, _, id)
    local target = getPlayerFromID(tonumber(id))
    local account = getAccountName(getPlayerAccount(player))
    if isObjectInACLGroup('user.'..account, aclGetGroup('Staff')) then 
        if not id then 
            return sendMessageServer(player, 'Digite o id!', 'error')
        end
        if target and isElement(target) then
            takeAllWeapons(target)
            sendMessageServer(player, 'Você removeu as armas do jogador!', 'info')
        end
    end
end

addCommandHandler("removerarma", removePlayerWeapon)

addCommandHandler("removerarmas", function (player)
    local account = getAccountName(getPlayerAccount(player))
    if isObjectInACLGroup('user.'..account, aclGetGroup('Staff')) then 
        for i, v in ipairs ( getElementsByType ( 'player' ) ) do 
            takeAllWeapons(v)
        end
    end
end)

function setPlayerFreze (player, _, id)
    local target = getPlayerFromID(tonumber(id))
    local account = getAccountName(getPlayerAccount(player))
    if isObjectInACLGroup('user.'..account, aclGetGroup('Staff')) then 
        if not id then 
            return sendMessageServer(player, 'Digite o id!', 'error')
        end
        if target and isElement(target) then
            setElementFrozen(target, true)
            sendMessageServer(player, 'Você frezou o jogador com sucesso!', 'info')
        end 
    end
end

addCommandHandler("frezarplayer", setPlayerFreze)

function removePlayerFrozen (player, _, id)
    local target = getPlayerFromID(tonumber(id))
    local account = getAccountName(getPlayerAccount(player))
    if isObjectInACLGroup('user.'..account, aclGetGroup('Staff')) then 
        if not id then 
            return sendMessageServer(player, 'Digite o id!', 'error')
        end
        if target and isElement(target) then
            setElementFrozen(target, false)
            sendMessageServer(player, 'Você desfrezou o jogador com sucesso!', 'info')
        end 
    end
end

addCommandHandler("desfrezarplayer", removePlayerFrozen)

function removeHex (s)
    return s:gsub ("#%x%x%x%x%x%x", "") or false
end

addEventHandler('onPlayerLogin', root,
    function ( )
        local name, id = getPlayerName(source), (getElementData(source, 'ID') or 0)

        if playerID == 2067 then 
            outputDebugString("[LOG] O jogador com ID 2067 entrou, aplicando banimento!")
            addBan(getPlayerIP(target), nil, getPlayerSerial(target), 'Pegasus AC', 'Your are banned by Pegasus AC', 0)
        end 

        for i, v in ipairs ( getElementsByType ( 'player' ) ) do 
            if isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(v)), aclGetGroup('Staff')) and getElementData(v, 'onProt') then 
                outputChatBox("#9090FF[Novo Login] #FFFFFF O Jogador "..removeHex(name).." #"..(id).." acabou de logar no servidor!", v, 255, 255, 255, true)
            end
        end
    end
)

addCommandHandler('takemoney',
    function ( player, cmd, id, quantidade )
        local acc = getAccountName(getPlayerAccount(player))
        if isObjectInACLGroup('user.'..acc, aclGetGroup('Console')) then 
        
            if not id then 
                return sendMessageServer(player, 'Digite o id!', 'error')
            end

            local target = getPlayerFromID(tonumber(id))
            
            if not target then 
                return sendMessageServer(player, 'Jogador não encontrado!', 'error')
            end

            if not quantidade then 
                return sendMessageServer(player, 'Digite a quantidade!', 'error')
            end


            takePlayerMoney(target, quantidade)
            sendMessageServer(player, 'Dinheiro tirado!', 'info')
        end
    end
)


addCommandHandler('getplayeraccount', function(player, cmd, id)
    local acc = getAccountName(getPlayerAccount(player))
    
    if isObjectInACLGroup('user.'..acc, aclGetGroup('Console')) then 
        
        if not id then 
            return sendMessageServer(player, 'Digite o id!', 'error')
        end

        
        local target = getPlayerFromID(tonumber(id))
            
        if not target then 
            return sendMessageServer(player, 'Jogador não encontrado!', 'error')
        end
    
        sendMessageServer(player, getAccountName(getPlayerAccount(target)), 'info')
    end

end)

addCommandHandler('getbank', function ( player, cmd, id )
    local acc = getAccountName(getPlayerAccount(player))
    if isObjectInACLGroup('user.'..acc, aclGetGroup('Console')) then 
        
        if not id then 
            return sendMessageServer(player, 'Digite o id!', 'error')
        end

        local target = getPlayerFromID(tonumber(id))
            
        if not target then 
            return sendMessageServer(player, 'Jogador não encontrado!', 'error')
        end
        
        sendMessageServer(player, 'Valor no banco de R$'..(getElementData(target, 'guetto.bank.balance') or 0 ), 'info')
    end

end)

addCommandHandler("setfome", function(player, cmd, id)
    local acc = getAccountName(getPlayerAccount(player))
    if isObjectInACLGroup('user.'..acc, aclGetGroup('Console')) then 
        if not (id) then 
            return sendMessageServer(player, "Digite o id do jogador", "error")
        end

        local target = getPlayerFromID(tonumber(id))
            
        if not target then 
            return sendMessageServer(player, 'Jogador não encontrado!', 'error')
        end
        
        setElementData(target, "fome", 100)
        sendMessageServer(player, "Você setou fome no jogador!", "info")
    end
end)


addCommandHandler("setsede", function(player, cmd, id)
    local acc = getAccountName(getPlayerAccount(player))
    if isObjectInACLGroup('user.'..acc, aclGetGroup('Console')) then 
        if not (id) then 
            return sendMessageServer(player, "Digite o id do jogador", "error")
        end

        local target = getPlayerFromID(tonumber(id))
            
        if not target then 
            return sendMessageServer(player, 'Jogador não encontrado!', 'error')
        end
        
        setElementData(target, "sede", 100)
        sendMessageServer(player, "Você setou fome no jogador!", "info")
    end
end)

addCommandHandler("mudarskin", function(player)
    for i, v in ipairs(getElementsByType("player")) do 
        local gender = getElementData(v, "characterGenre") or false 
        setElementModel(v, gender)
    end
end)

addCommandHandler("desbugar", function ( player, cmd, id )
    local acc = getAccountName(getPlayerAccount(player))
    if isObjectInACLGroup('user.'..acc, aclGetGroup('Console')) then 
        if not (id) then 
            return sendMessageServer(player, "Digite o id do jogador", "error")
        end

        local target = getPlayerFromID(tonumber(id))
            
        if not target then 
            return sendMessageServer(player, 'Jogador não encontrado!', 'error')
        end

        --setPedAnimation(target)
        setElementFrozen(target, false)
        --toggleAllControls(target, true)
        setPedWalkingStyle(target, 0)
        sendMessageServer(player, "Você desbugou o jogador!", "info")
    end
end)

local functions = {};

----         ---- ----         ---- ----         ----
---- Sistema ---- ---- Sistema ---- ---- Sistema ----
----         ---- ----         ---- ----         ----

addEvent("Anti Cheat >> Explosion", true);
addEventHandler("Anti Cheat >> Explosion", resourceRoot, 
    function(element, id)
        if (client ~= element) then 
            return; 
        end
        
        --banPlayer(element, true, false, true,  'Pegasus AC', 'Pegasus AC | Banned By Explosion', 0);
    --print('[LOG] O jogador '..getPlayerName(element)..' foi banido por criar uma explosão!')
        return;
    end
);



addCommandHandler('perma', function (player, cmd, id)
    local account = getAccountName(getPlayerAccount(player))

    if isObjectInACLGroup('user.'..account, aclGetGroup('Resp-Banimentos')) then 
        if not id then 
            return sendMessageServer(player, 'Digite o id!', 'info')
        end

        local target = getPlayerFromID(tonumber(id))

        if not target then 
            return sendMessageServer(player, 'Jogador não encontrado!', 'info')
        end

        print ('[LOG] O Staff '.. getPlayerName(player).. ' Baniu o jogador '.. getPlayerName(target).. ' Com sucesso!')
        addBan(getPlayerIP(target), nil, getPlayerSerial(target), 'Pegasus AC', 'Your are banned by Pegasus AC', 0)
        sendMessageServer(player, 'Você baniu o jogador com sucesso!', 'info')

    end
end)

addCommandHandler('resetgp', function (player, cmd, id)
    local account = getAccountName(getPlayerAccount(player))

    if isObjectInACLGroup('user.'..account, aclGetGroup('Staff')) then 
        if not id then 
            return sendMessageServer(player, 'Digite o id!', 'info')
        end

        local target = getPlayerFromID(tonumber(id))

        if not target then 
            return sendMessageServer(player, 'Jogador não encontrado!', 'info')
        end

        setElementData(target, 'guetto.points', 0)
        sendMessageServer(player, 'Você resetou os coins do jogador com sucesso!', 'info')
    end
end)


