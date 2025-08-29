for i, v in ipairs ( config.positions["detran"] ) do
    local marker_detran = createMarker(v[1], v[2], v[3] - 0.9, 'cylinder', 1.5, 139, 100, 255, 0)
    setElementData(marker_detran, 'markerData', {title = 'Detran', desc = 'Configra aqui pendências dos seus veíuclos!', icon = 'towtruck'})
    addEventHandler('onMarkerHit', marker_detran,  
        function ( player, dim )
            if player and isElement(player) and getElementType(player) == 'player' and dim then 
                local query = dbPoll(dbQuery(database, 'SELECT * FROM `Garagem` WHERE `accountName` = ?', getAccountName(getPlayerAccount(player))), - 1)
                if #query == 0 then return config.sendMessageServer(player, 'Você não possui veículos em sua garagem!', 'error') end 
                triggerClientEvent(player, 'onPlayerDrawDetran', resourceRoot, query)
            end
        end
    )
end

function createVehiclePlate ( )
    local str = ""
    local letters = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "A", "a", "B", "b", "C", "c", "D", "d", "E", "e", "f", "F", "g", "G", "h", "H", "i", "I", "j", "J", "k", "K", "l", "L"}

    for i = 1, 3 do 
        local random = math.random(#letters)
        str = str..random
    end

    return "GCR"..str
end


addEvent("onPlayerRegisterVehicle", true)
addEventHandler("onPlayerRegisterVehicle", resourceRoot,
    function ( dados )
    
        if not client then 
            return false 
        end

        if source ~= getResourceDynamicElementRoot(getThisResource()) then 
            return outputDebugString( " Resource | ".. (getResourceName(getThisResource())).." | ".. (getPlayerName(client)).." # "..(getElementData(client, 'ID') or "N/A").." | Serial | "..getPlayerSerial(client).."  | IP | "..(getPlayerIP(client)).."", 1 )
        end

        local qh = dbPoll(dbQuery(database, 'SELECT * FROM `Garagem` WHERE `accountName` = ? AND `model` = ?', getAccountName(getPlayerAccount(client)), tonumber(dados.model)), - 1)
        if #qh == 0 then return config.sendMessageServer(client, 'Esse veículo não foi encontrado na sua garagem!', 'error') end 

        if qh[1].plate ~= 'SEM PLACA' then 
            return config.sendMessageServer(client, 'Seu veículo já está emplacado!', 'error')
        end

        local data = fromJSON(qh[1].infos);
        local percent = tonumber(data[2]) * 0.3
        local money = getPlayerMoney(client)

        if money < percent then 
            return config.sendMessageServer(client, 'Você não possui dinheiro suficiente para emplacar seu veículo!', 'error')
        end
        
        local vehicle = isVehicleSpawned(tonumber(qh[1].ID))
        local plate = createVehiclePlate()

        if (vehicle) then 
            setVehiclePlateText(vehicle, plate)
        end

        dbExec(database, "UPDATE `Garagem` SET `plate` = ? WHERE `model` = ? AND `accountName` = ?", plate, tonumber(dados.model), getAccountName(getPlayerAccount(client)))
        config.sendMessageServer(client, 'Você emplacou seu veículo com sucesso!', 'success')
    end
)

addEvent("onPlayerRecoverVehicle", true)
addEventHandler("onPlayerRecoverVehicle", resourceRoot,
    function ( dados, price )
        if not client then 
            return false 
        end

        if source ~= getResourceDynamicElementRoot(getThisResource()) then 
            return outputDebugString( " Resource | ".. (getResourceName(getThisResource())).." | ".. (getPlayerName(client)).." # "..(getElementData(client, 'ID') or "N/A").." | Serial | "..getPlayerSerial(client).."  | IP | "..(getPlayerIP(client)).."", 1 )
        end
        
        if tonumber(price) <= 0 then 
            return false 
        end

        local qh = dbPoll(dbQuery(database, 'SELECT * FROM `Garagem` WHERE `accountName` = ? AND `model` = ?', getAccountName(getPlayerAccount(client)), tonumber(dados.model)), - 1)
        if #qh == 0 then return config.sendMessageServer(client, 'Esse veículo não foi encontrado na sua garagem!', 'error') end 

        if qh[1].state == "apreendido" then 
            if (getPlayerMoney(client) < tonumber(price)) then return config.sendMessageServer(client, "Você não possui dinheiro suficiente para recuperar seu veículo!", "error") end 
            takePlayerMoney(client, tonumber(price))
            dbExec(database, "UPDATE `Garagem` SET `state` = ? WHERE `model` = ? AND `accountName` = ?", 'guardado', tonumber(dados.model), getAccountName(getPlayerAccount(client)))
            config.sendMessageServer(client, "Seu veículo foi enviado para a garagem!", "success")
        else
            config.sendMessageServer(client, "Seu veículo não precisa ser recuperado!", "error")
        end

    end
)

addEvent("onPlayerVehicleIPVA", true)
addEventHandler("onPlayerVehicleIPVA", resourceRoot,
    function ( dados, price )
        if not client then 
            return false 
        end

        if source ~= getResourceDynamicElementRoot(getThisResource()) then 
            return outputDebugString( " Resource | ".. (getResourceName(getThisResource())).." | ".. (getPlayerName(client)).." # "..(getElementData(client, 'ID') or "N/A").." | Serial | "..getPlayerSerial(client).."  | IP | "..(getPlayerIP(client)).."", 1 )
        end

        if tonumber(price) <= 0 then 
            return false 
        end

        local qh = dbPoll(dbQuery(database, 'SELECT * FROM `Garagem` WHERE `accountName` = ? AND `model` = ?', getAccountName(getPlayerAccount(client)), tonumber(dados.model)), - 1)
        if #qh == 0 then return config.sendMessageServer(client, 'Esse veículo não foi encontrado na sua garagem!', 'error') end 
        
        if getRealTime().timestamp >= tonumber(qh[1].IPVA) then 
            if (getPlayerMoney(client) < tonumber(price)) then return config.sendMessageServer(client, "Você não possui dinheiro suficiente para pagar o IPVA do seu veículo!", "error") end 
            takePlayerMoney(client, tonumber(price))
            dbExec(database, "UPDATE `Garagem` SET `IPVA` = ? WHERE `model` = ? AND `accountName` = ?", (getRealTime().timestamp)+604800, tonumber(dados.model), getAccountName(getPlayerAccount(client)))
            config.sendMessageServer(client, "Você pagou o ipva do seu veículo com sucesso!", "success")
        else
            config.sendMessageServer(client, "O IPVA do seu veículo está em dia!", "error")
        end

    end
)