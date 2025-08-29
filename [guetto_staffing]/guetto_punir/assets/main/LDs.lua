--[[
    --» sᴄʀɪᴘᴛ ғᴇɪᴛᴏ ᴘᴏʀ » Pedro Developer
--]]

outputDebugString('[PEDRO DEVELOPER] RESOURCE '..getResourceName(getThisResource())..' ATIVADA COM SUCESSO', 4, 204, 82, 82)

local db = dbConnect('sqlite', 'assets/database/prison.sqlite')
dbExec(db, 'Create table if not exists banimentos(user TEXT, serial TEXT, id INTEGER, staff TEXT, id_staff INTEGER, time REAL, reason TEXT)')

local area = createColSphere(unpack(config.banimento.area))
local timer = {}

addEventHandler('onColShapeHit', area, 

    function(player) 

        if isElement(player) and getElementType(player) == 'player' then 

            if not isBanned(player) then 

                if (isPedInVehicle(player)) then 

                    removePedFromVehicle(player)

                    setTimer(function(player)
                    
                        if (isElement(player)) then 

                            setElementPosition(player, -2262.36, 2324.364, 4.812)
                        
                        end
                        
                    end, 100, 1, player)

                else

                    setElementPosition(player, -2262.36, 2324.364, 4.812)
                
                end


            end

        end

    end

)

addEventHandler('onColShapeLeave', area, 

    function(player) 

        if isElement(player) and getElementType(player) == 'player' then 

            if isBanned(player) then 

                if (isPedInVehicle(player)) then 

                    removePedFromVehicle(player)

                    setTimer(function(player)
                    
                        if (isElement(player)) then 

                            setElementPosition(player, config.banimento.spawn_punido[1], config.banimento.spawn_punido[2], config.banimento.spawn_punido[3])
                        
                        end
                        
                    end, 100, 1, player)

                else

                    setElementPosition(player, config.banimento.spawn_punido[1], config.banimento.spawn_punido[2], config.banimento.spawn_punido[3])
                
                end


            end

        end

    end

)

addCommandHandler(config.command, 

    function(player) 

        if isPlayerHasPermission(player) then 

            triggerClientEvent(player, 'onClientPainelPunir', player)

        end

    end

)

addCommandHandler(config.command2, 

    function(player, _, id) 

        if isPlayerHasPermission(player) then 

            if tonumber(id) then 

                local receiver = getPlayerFromID(id) 
                if isElement(receiver) then 

                    if isBanned(receiver) then 

                        liberPlayerBanimento(receiver)
                        sendDiscordMessage('O STAFF '..getPlayerName(player)..'('..(getElementData(player, 'ID') or 'N/A')..') LIBEROU O JOGADOR '..getPlayerName(receiver)..'('..id..') DA PUNIÇÃO.')
                        config.notify(player, 'Jogador liberado!', 'success')

                    end

                else

                    config.notify(player, 'Dados do jogador não encontrados!', 'error')

                end

            end
        end
    end
)

addEvent('onPlayerBaned', true)
addEventHandler('onPlayerBaned', root, 

    function(hash, iv) 

        if not client then 
            return false; 
        end

        local serial = getPlayerSerial ( client )
        local player = client;
        
        decodeString("aes128", hash, { key = serial:sub(17), iv = iv }, function ( decode )
            
            local data = fromJSON(decode);

            local id = data[1];
            local time = data[2];
            local type_time = data[3];
            local motivo = data[4];

            if tonumber(id) then

                if tonumber(time) then 
    
                    local time_correct = formatTime(time, type_time) 
                    if time_correct then 
                        if #motivo > 0 then 
    
                            local serial, accountName = exports["guetto_id2"]:getSerialByID(tonumber(id))

                            if not serial then 
                                return config.notify(player, 'Conta não encontrada!', 'info') 
                            end
                            
                            local receiver = getPlayerFromID(id) 

                            sendDiscordMessage('O(A) STAFF '..getPlayerName(player)..'('..(getElementData(player, 'ID') or 'N/A')..') puniu o jogador '..accountName..'('..id..') por '..time..' '..type_time..'.')
                            outputChatBox("#C19F72* O(A) STAFF #ffffff"..getPlayerName(player).." #C19F72puniu o(a) jogador(a) #ffffff"..accountName.."#FFFFFF("..id..")!" , root, 255, 255, 255, true)
                            outputChatBox("#C19F72* Pelo tempo de #ffffff"..time.." Minutos." , root, 255, 255, 255, true)
                            outputChatBox("#C19F72* #C19F72Motivo da punição: #ffffff"..motivo.." !" , root, 255, 255, 255, true)

                            
                            dbExec(db, 'Delete from banimentos where id = ?', tonumber(id)) 
                            dbExec(db, 'Insert into banimentos(user, serial, id, staff, id_staff, time, reason) Values(?, ?, ?, ?, ?, ?, ?)', accountName, serial, tonumber(id), getPlayerName(player), tonumber((getElementData(player, 'ID') or -1000)), tonumber(time_correct), motivo)
                            
                            if receiver and isElement(receiver) then 
                                setPlayerOnBanimento(receiver)
                            end

                            config.notify(player, 'Jogador punido!', 'success')
                            config.notify(receiver, 'Você foi punido!', 'info') 

    
                        else
    
                            config.notify(player, 'Insira um motivo maior!', 'error')
    
                        end
    
                    else
    
                        config.notify(player, 'Selecione uma categoria de tempo!', 'error')
    
                    end
    
                else
    
                    config.notify(player, 'Digite um tempo válido!', 'error')
    
                end    
    
            else
    
                config.notify(player, 'Digite algum id válido!', 'error')
    
            end  

            
        end)

    end

)


addEventHandler('onResourceStart', getResourceRootElement(getThisResource()), 

    function()

        setTimer(function()

            for i, player in ipairs(getElementsByType('player')) do 

                if isBanned(player) then 

                    setPlayerOnBanimento(player)

                end     

            end

        end, 500, 1)

    end

)

addEventHandler('onPlayerLogin', root, 

    function()

        setTimer(function(player)

            if isBanned(player) then 

                setPlayerOnBanimento(player)

            end     

        end, 500, 1, source)

    end

)

function setPlayerOnBanimento(player) 

    if isPedInVehicle(player) then 

        removePedFromVehicle(player) 

        setTimer(function(player)

            if (isElement(player)) then 

                setElementPosition(player, config.banimento.spawn_punido[1], config.banimento.spawn_punido[2], config.banimento.spawn_punido[3])

            end

        end, 500, 1, player)

    else

        setElementPosition(player, config.banimento.spawn_punido[1], config.banimento.spawn_punido[2], config.banimento.spawn_punido[3])
    
    end 

    local data = dbPoll(dbQuery(db, 'Select * from banimentos where user = ?', getAccountName(getPlayerAccount(player))), -1) 
    if #data ~= 0 then 

        triggerClientEvent(player, 'addTimerPunir', player, data[1]['time'], data[1]['reason'])
        if isTimer(timer[player]) then 
            
            killTimer(timer[player]) 
        
        end 

        timer[player] = setTimer(function(player) 

            if isElement(player) then 

                local data = dbPoll(dbQuery(db, 'Select * from banimentos where user = ?', getAccountName(getPlayerAccount(player))), -1) 
                if #data ~= 0 then 

                    if (data[1]['time'] - (60 * 1000)) > 0 then

                        dbExec(db, 'Update banimentos set time = ? where user = ?', (data[1]['time'] - (60 * 1000)), data[1]['user'])

                    else 

                        liberPlayerBanimento(player)

                    end 

                else

                    liberPlayerBanimento(player)

                end

            else

                if isTimer(timer[player]) then 
                    
                    killTimer(timer[player]) 
                
                end 

            end

        end, 60 * 1000, 0, player)

    end

end


function liberPlayerBanimento(player)

    if isTimer(timer[player]) then 
        
        killTimer(timer[player]) 
    
    end 
    
    triggerClientEvent(player, 'removeTimerPunir', player)
    dbExec(db, 'Delete from banimentos where user = ?', getAccountName(getPlayerAccount(player))) 
    setElementPosition(player, config.banimento.spawn_liberado[1], config.banimento.spawn_liberado[2], config.banimento.spawn_liberado[3])
    config.notify(player, 'Você foi liberado!', 'info')

end


function formatTime(time, type) 
    if type == 'Minutos' then 
        return time * 60000 
    elseif type == 'Horas' then 
        return time * (60 * 60000) 
    elseif type == 'Dias' then 
        return time * (24 * (60 * 60000))
    elseif type == 'Semanas' then 
        return time * (7 * (24 * (60 * 60000)))
    elseif type == 'Meses' then 
        return time * (31 * (24 * (60 * 60000)))
    end 
end

function isPlayerHasPermission(player) 
    for i, v in ipairs(config.acls) do 
        if isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(player)), aclGetGroup(v)) then 
            return true 
        end 
    end
    return false 
end

function isBanned(player) 

    if (isElement(player)) then  

        local result = dbPoll(dbQuery(db, 'Select * from banimentos where user = ?', getAccountName(getPlayerAccount(player))), -1) 
        if #result ~= 0 then 
            return true 
        end 
        
    end 

    --local result = dbPoll(dbQuery(db, 'Select * from banimentos where serial = ?', getPlayerSerial(player)), -1) 
    --if #result ~= 0 then return true end 
end

-- // LOGS 
function sendDiscordMessage(mensagem)
    local data = {
        content = '',
        username = 'Pedro Developer',
        avatar_url = 'https://cdn.discordapp.com/attachments/791346490571882497/1091407435220144228/op_1.png',
        embeds = {
            {
                title = 'Pedro Developer - Punição',
                color = 15548997,
                description = mensagem,

                footer = {
                    text = 'Pedro Developer',
                    icon_url = 'https://cdn.discordapp.com/attachments/791346490571882497/1091407435220144228/op_1.png',
                },

                image = {
                    url = '',
                },

                thumbnail = { 
                    url = 'https://cdn.discordapp.com/attachments/791346490571882497/1091407435220144228/op_1.png',
                },
            }
        }
    }

    local jsonData = toJSON(data)
    jsonData = string.sub(jsonData, 3, #jsonData - 2)

    local sendOptions = {
        headers = {
            ['Content-Type'] = 'application/json',
        },
        postData = jsonData,
    }

    fetchRemote ( config['webhook'], sendOptions, function() end)
end
-- // LOGS 

function getPlayerFromID(id)
    for i, v in ipairs(getElementsByType('player')) do
        if not isGuestAccount(getPlayerAccount(v)) and tonumber(getElementData(v, 'ID') or -99999) == tonumber(id) then
            return v
        end
    end
    return false
end