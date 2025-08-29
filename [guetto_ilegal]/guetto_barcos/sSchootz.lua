marker = {}
localAlugue = {}

function Markers()
	for i,v in ipairs(config['Locais']) do 
		marker[i] = createMarker(v[1], v[2], v[3]-0.9, "cylinder", 1.1, 139, 0, 255, 0)
		setElementData(marker[i], "markerData", {title = "Aluguel", desc = "Alugue seu barco!", icon = "shop"})
		addEventHandler('onMarkerHit', marker[i], 
        function(player)
            if getElementType(player) == 'player' then
                triggerClientEvent(player, 'Schootz.openBarcos', player)
                localAlugue[player] = i
            end
        end)
	end
end
addEventHandler('onResourceStart', resourceRoot, Markers)

vehicle = {}
timer = {}
proAtivo = 'Desativado'

function alugarVehicle(player, index)
    if (index) then 
        if getPlayerMoney(player) < config['Veiculos'][index][3] then 
            notifyS(player, 'Você não possue dinheiro suficiente!', 'error')
        else
            takePlayerMoney(player, config['Veiculos'][index][3])
            notifyS(player, 'Você alugou um barco por '..config['Geral'].TimeAlugue..'m com sucesso!', 'success')
            local pro = getElementData(player, 'onProt')
            if pro then 
                proAtivo = 'Ativado'
            else
                proAtivo = 'Desativado'
            end
            exports['guetto_util']:messageDiscord('O jogador(a) '..puxarNome(player)..'('..puxarID(player)..') alugou um barco por '..config['Geral'].TimeAlugue..'m  (PRO: '..proAtivo..') ', 'sdadada')
            vehicle[player] = createVehicle(config['Veiculos'][index][2], config['Locais'][localAlugue[player]][4][1], config['Locais'][localAlugue[player]][4][2], config['Locais'][localAlugue[player]][4][3])
            warpPedIntoVehicle(player, vehicle[player])
            setElementRotation(vehicle[player], config['Locais'][localAlugue[player]][4][4], config['Locais'][localAlugue[player]][4][5], config['Locais'][localAlugue[player]][4][6])
            setElementData(vehicle[player], 'Owner', player)
            setElementData(vehicle[player], 'VehicleSmuggling', true)
        
            local x, y, z = exports["guetto_contrabando"]:getContainerPosition (player)

            if (x and y and z) then 
                triggerClientEvent(player, "togglePoint", player, x, y, z, 0, 0)
            end

            timer[player] = setTimer(function()
                local attached = getElementAttachedTo(vehicle[player])
                if attached then
                    setElementData(attached, "JOAO.stringActive", false)
                    if isElement(vehicle[player]) then
                        destroyElement(vehicle[player])
                    end
                    if isTimer(timer[player]) then
                        killTimer(timer[player])
                    end
                end
                notifyS(player, 'O alugel do seu barco acabou!', 'info')
            end, config['Geral'].TimeAlugue*60000, 1)
        end
    end
end
addEvent('Schootz.alugarVehicle', true)
addEventHandler('Schootz.alugarVehicle', root, alugarVehicle)

function getTestSmuggling(player)
    if (player) then 
        if vehicle[player] then
            local attached = getElementAttachedTo(vehicle[player])
            if attached then
                iprint(attached)
            end
        end
    end
end
addCommandHandler('teste', getTestSmuggling)

function quitPlayer(player)
    if isElement(vehicle[player]) then
        local attached = getElementAttachedTo(vehicle[player])
        if attached then
            destroyElement(vehicle[player])
            setElementData(attached, "JOAO.stringActive", false)
        end
    end
end
addEventHandler('onPlayerQuit', root, quitPlayer)

-- Funções uteis -- 
notifyS = function (player, msg, type)
    return exports['guetto_notify']:showInfobox(player, type, msg)
end;


function puxarNome(player)
    return removeHex(getPlayerName(player))
end

function puxarID(player)
    return (getElementData(player, "ID") or 0)
end

function removeHex(message)
    if type(message) == 'string' then
        while message ~= message:gsub('#%x%x%x%x%x%x', '') do
            message = message:gsub('#%x%x%x%x%x%x', '')
        end
    end
    return message or false
end