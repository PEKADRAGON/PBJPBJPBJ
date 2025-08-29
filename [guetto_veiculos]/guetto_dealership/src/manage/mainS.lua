local blip_attached = {}
local timer_attached = {}
local player_oferter = {}
local oferter_reciver = {}

addEvent('select_player_vehicles', true)
addEventHandler('select_player_vehicles', resourceRoot,
    function ( )
        if not client then 
            return false 
        end

        if source ~= resourceRoot then 
            return false 
        end

        triggerClientEvent(client, 'send_vehicles_client', resourceRoot, getPlayerVehicles(client))
    end
)

addEvent('onPlayerLocalizeVehicle', true)
addEventHandler('onPlayerLocalizeVehicle', resourceRoot,
    function (dados)
    
        if not client then 
            return false 
        end

        if source ~= getResourceDynamicElementRoot(getThisResource()) then 
            return outputDebugString( " Resource | ".. (getResourceName(getThisResource())).." | ".. (getPlayerName(client)).." # "..(getElementData(client, 'ID') or "N/A").." | Serial | "..getPlayerSerial(client).."  | IP | "..(getPlayerIP(client)).."", 1 )
        end

        if not dados then 
            return false 
        end

        local vehicle = isVehicleSpawned ( dados.ID )

        if not vehicle then 
            return config.sendMessageServer(client, 'Esse veículo não está spawnado!', 'error')
        end

        if blip_attached[vehicle] then 
            return config.sendMessageServer(client, 'Você já está localizando um veículo!', 'error')
        end

        if getRealTime().timestamp > tonumber(dados.IPVA) then 
            return config.sendMessageServer(client, 'Pague seu IPVA para poder localizar o veículo!', 'error')
        end

        if not blip_attached[vehicle] then 
            blip_attached[vehicle] = createBlipAttachedTo(vehicle, config["Manage-Vehicle"]["blip"])
        end

        if not timer_attached[vehicle] and not isTimer(timer_attached[vehicle]) then  
            timer_attached[vehicle] = setTimer(function(vehicle)
                if vehicle and isElement(vehicle) then 
                    if blip_attached[vehicle] and isElement(blip_attached[vehicle]) then 
                        destroyElement(blip_attached[vehicle])
                        blip_attached[vehicle] = nil 
                    end
                end
            end, config["Manage-Vehicle"]["timer"] * 60000, 1, vehicle)
        end

        config.sendMessageServer(client, 'Você localizou seu veículo com sucesso!', 'success')
    end
)


addEvent("onPlayerSellVehicleConce", true)
addEventHandler("onPlayerSellVehicleConce", resourceRoot,
    function (data)
        if not client then 
            return false 
        end

        if source ~= getResourceDynamicElementRoot(getThisResource()) then 
            return outputDebugString( " Resource | ".. (getResourceName(getThisResource())).." | ".. (getPlayerName(client)).." # "..(getElementData(client, 'ID') or "N/A").." | Serial | "..getPlayerSerial(client).."  | IP | "..(getPlayerIP(client)).."", 1 )
        end

        local query = dbPoll(dbQuery(database, "SELECT * FROM `Garagem` WHERE `model` = ? AND `accountName` = ? ", tonumber(data.model), getAccountName(getPlayerAccount(client))), - 1)
        if #query == 0 then return config.sendMessageServer(client, 'Você não possui esse veículo na sua garagem!', 'error') end 

        local data = fromJSON(query[1].infos)
        
        if data then 
            local vehicle = isVehicleSpawned ( query[1].ID )
            
            if vehicle and isElement(vehicle) then 
                return config.sendMessageServer(client, 'Guarde seu veículo para poder vende-lo!', 'error')
            end

            if data[4] == "coins" then 
                return config.sendMessageServer(client, 'Você não pode vender veículo premium!', 'error')
            end
            
            local percent = tonumber(data[2]) * 0.5

            givePlayerMoney(client, percent)

            dbExec(database, 'DELETE FROM `Garagem` WHERE `model` = ? AND `accountName` = ? ', tonumber(query[1].model), getAccountName(getPlayerAccount(client)))
            config.sendMessageServer(client, 'Você vendeu seu veículo para a concessionária por R$ '..formatNumber(percent, '.')..'!', 'info')
        else
            config.sendMessageServer(client, 'Houve um falha ao tentar vender seu veículo!', 'error')
        end

    end
)

function getTotalPrice (tbl)
    local c = 0;

    for i = 1, #tbl do 
        c = c + tonumber(tbl[i])
    end

    return c 
end

addEvent("onPlayerPaymentMult", true)
addEventHandler("onPlayerPaymentMult", resourceRoot,
    function (data)
        if not client then 
            return false 
        end

        if source ~= getResourceDynamicElementRoot(getThisResource()) then 
            return outputDebugString( " Resource | ".. (getResourceName(getThisResource())).." | ".. (getPlayerName(client)).." # "..(getElementData(client, 'ID') or "N/A").." | Serial | "..getPlayerSerial(client).."  | IP | "..(getPlayerIP(client)).."", 1 )
        end
        
        if not (data) then 
            return false 
        end

        local query = dbPoll(dbQuery(database, "SELECT * FROM `Garagem` WHERE `model` = ? AND `accountName` = ? ", tonumber(data.model), getAccountName(getPlayerAccount(client))), - 1)
        if #query == 0 then return config.sendMessageServer(client, 'Você não possui esse veículo na sua garagem!', 'error') end 

        local cache = fromJSON(query[1].dados)[1]
        
        if type(cache.multas) == "number" or type(cache.multas) == "table" and #cache.multas == 0 then 
            return config.sendMessageServer(client, 'Você não possui multas pendentes!', 'info')
        end

        local price = getTotalPrice(cache.multas)

        if getPlayerMoney(client) < price then 
            return config.sendMessageServer(client, 'Você não possui dinheiro suficiente para pagar suas multas!', 'error') 
        end 

        cache.multas = 0;

        takePlayerMoney(client, price)
        dbExec(database, "UPDATE `Garagem` SET `dados` = ? WHERE `ID` = ?", toJSON({cache}), query[1].ID )

        config.sendMessageServer(client, 'Você pagou suas multas!', 'success')
    end
)

addEvent("onPlayerSellVehiclePlayer", true)
addEventHandler("onPlayerSellVehiclePlayer", resourceRoot,
    function (data, id, price, type_ofert)
        if not client then 
            return false 
        end

        if source ~= getResourceDynamicElementRoot(getThisResource()) then 
            return outputDebugString( " Resource | ".. (getResourceName(getThisResource())).." | ".. (getPlayerName(client)).." # "..(getElementData(client, 'ID') or "N/A").." | Serial | "..getPlayerSerial(client).."  | IP | "..(getPlayerIP(client)).."", 1 )
        end
        
        if not id then return false end 
        if not price then return false end 
        if tonumber(price) <= 0 then return config.sendMessageServer(client, "Insira um valor positivo!", "error") end 

        if type_ofert == "coins" then 
            return config.sendMessageServer(client, "Tipo da oferta em desenvolvimento!", "error") 
        end

        local index_client = getIdOferterByPlayer (client)

        if index_client then 
            return config.sendMessageServer(client, "Você já enviou uma proposta recentemente!", "error")
        end

        local target = getPlayerFromId (tonumber(id))
        if not target then return config.sendMessageServer(client, "Jogador não encontrado!", "error") end 

        if target == client then 
            return config.sendMessageServer(client, 'Você não pode enviar a oferta para você mesmo!', 'error')
        end
        
        local index_target = getIdOferterByPlayer (target)

        if index_target then 
            return config.sendMessageServer(client, "Esse jogador já possui uma oferta em andamento!", "error")
        end
        
        local query = dbPoll(dbQuery(database, "SELECT * FROM `Garagem` WHERE `model` = ? AND `accountName` = ? ", tonumber(data.model), getAccountName(getPlayerAccount(client))), - 1)
        if #query == 0 then return config.sendMessageServer(client, 'Você não possui esse veículo na sua garagem!', 'error') end 

        local data = fromJSON(query[1].infos)
        
        if data[4] == 'coins' then 
            return config.sendMessageServer(client, 'Esse veículo não pode ser vendido!', 'error')
        end

        player_oferter[#player_oferter + 1] = {
            sender = client;
            target = target;
            price = tonumber(price);
            type = type_ofert,
            vehicle = tonumber(query[1].model)
        };

        oferter_reciver[target] = client;

        config.sendMessageServer(client, "Você enviou a proposta ao jogador!", "info")
        config.sendMessageServer(target, "Você recebeu uma proposta de um veículo!", "info")

        triggerClientEvent(target, "onPlayerVisibleOferter", resourceRoot, true, player_oferter[#player_oferter])
    end
)

addEvent("onPlayerCancelOferter", true)
addEventHandler("onPlayerCancelOferter", resourceRoot,
    function ( data )

        if not client then return false end
        if not data then return false end 

        if data.sender and isElement(data.sender) then 
            config.sendMessageServer(data.sender, "O jogador recusou a oferta!", "info")
        end

        local index = getIdOferterByPlayer (client)
        
        if index then 
            player_oferter[index] = nil 
        end

    end
)


addEvent("onPlayerBuyVehicleByOferter", true)
addEventHandler("onPlayerBuyVehicleByOferter", resourceRoot,
    function (data)

        if not client then return false end
        if not data then return false end 

        if source ~= getResourceDynamicElementRoot(getThisResource()) then 
            return outputDebugString( " Resource | ".. (getResourceName(getThisResource())).." | ".. (getPlayerName(client)).." # "..(getElementData(client, 'ID') or "N/A").." | Serial | "..getPlayerSerial(client).."  | IP | "..(getPlayerIP(client)).."", 1 )
        end

        local index = getIdOferterByPlayer (client)
        if not index then return config.sendMessageServer(client, "Você não possui uma proposta pendente!", "error") end 
       
        if not player_oferter[index].sender or not isElement(player_oferter[index].sender) then 
            player_oferter[index] = nil 
            triggerClientEvent(client, "onPlayerVisibleOferter", resourceRoot, false)
            return config.sendMessageServer(client, "O Jogador que enviou a proposta não foi encontrado!", "error")
        end 

        local query = dbPoll(dbQuery(database, "SELECT * FROM `Garagem` WHERE `model` = ? AND `accountName` = ? ", tonumber(data.vehicle), getAccountName(getPlayerAccount(player_oferter[index].sender))), - 1)

        if #query == 0 then return config.sendMessageServer(client, 'A pessoa que enviou a oferta não possui esse veículo na garagem!', 'error') end 

        if (getPlayerVehicle(client, tonumber(query[1].model))) then 
            triggerClientEvent(client, "onPlayerVisibleOferter", resourceRoot, false)
            return config.sendMessageServer(client, "Você já possui esse veículo em sua garagem!", "error") 
        end
   
        local vehicle = isVehicleSpawned ( query[1].ID )
        
        if vehicle and isElement(vehicle) then 
            return config.sendMessageServer(client, 'Guarde seu veículo para poder vende-lo!', 'error')
        end

        if getPlayerMoney(client) < data.price then 
            return config.sendMessageServer(client, 'Você não possui dinheiro suficiente!', 'error')
        end

        if (getPlayerTotalVehicles(client) + 1 > getCountSlots(client)) then 
            return config.sendMessageServer(client, 'Você não possui mais espaço na sua garagem!', 'error')
        end

        dbExec(database, 'INSERT INTO Garagem (accountName, model, state, seguro, IPVA, infos, dados, plate) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', getAccountName(getPlayerAccount(client)), query[1].model, query[1].state, query[1].seguro, query[1].IPVA, query[1].infos, query[1].dados, query[1].plate)
        dbExec(database, 'DELETE FROM `Garagem` WHERE `model` = ? AND `accountName` = ? ', tonumber(query[1].model), getAccountName(getPlayerAccount(player_oferter[index].sender)))
        
        takePlayerMoney(client, data.price)
        givePlayerMoney(player_oferter[index].sender, data.price)

        config.sendMessageServer(client, "Você comprou o veículo com sucesso!", "info")
        config.sendMessageServer(player_oferter[index].sender, "Você vendeu o veículo com sucesso!", "info")
    end
)

function getIdOferterByPlayer ( player )
    if not player then return false end
    local result = false;
    for i = 1, #player_oferter do 
        if player_oferter[i].sender and isElement(player_oferter[i].sender) then 
            if player_oferter[i].sender == player then 
                result = i
            elseif player_oferter[i].target == player then 
                result = i
            end
        end
    end
    return result
end