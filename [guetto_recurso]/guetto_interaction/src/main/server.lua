local webhook = {
    ["Enviar dinheiro"] = "https://media.guilded.gg/webhooks/01683681-2de6-4fed-a9e7-00087af5d720/r4f93lhhS06MWuqmKkwucIsYseMaeakAIUUU8cWasks2gygmiyAMgQyiE260iICGSUsWEAecsQemWQsYiCu6Wm";
    ["Enviar GP"] = "https://media.guilded.gg/webhooks/33064b8e-0796-4f45-b728-dd01fa6623c4/WeLVBNpPSU8a0SgMUwCoC028qSwAacQM4qiiAoEIIwgkSSum4SEgEQQOOEq2kC8ySuKiGAqMUKieGwMM0EYEyy";
}

local kiss = {}
local sexy = {}
local mask = {}
local hood = {}
local vehicle = {}
local saqueando = {}
local algemado = {}
local conducted = {}

local isPlayerCuffed = {}
local isGrabbed = {}
local isPlayerCarring = {}
local isPlayerInTrunk ={}
local playersInTrunk = {}

local controls = {"jump", "fire", "sprint", "crouch", "aim_weapon", "next_weapon", "previous_weapon"}
local function toggleControls(player, state)
    if player and isElement(player) and (getElementType(player) == "player") then 
        for i = 1, #controls do 
            toggleControl(player, controls[i], state)
        end 
    end
    return true
end

function setPlayerCuffed(player, state)
    if state then

        if isPlayerCuffed[player] then return end

        setPedAnimation(player, nil)
        triggerClientEvent(root, "FS:addAnim", resourceRoot, player, 'cuffed')
        toggleControls(player, false)
        isPlayerCuffed[player] = true

    else

        if (not isPlayerCuffed[player]) then return end

        toggleControls(player, true)
        triggerClientEvent(root, "FS:removeAnim", resourceRoot, player)
        isPlayerCuffed[player] = nil

    end
end


addEventHandler('onElementClicked', root, function (button, state, player)
    if (source and isElement(source) and getElementType(source) == 'player' and not isPedInVehicle(source) and source ~= player ) then 
        if getElementDimension(source) == getElementDimension(player) then 
            local x, y, z = getElementPosition(player);
            local x2, y2, z2 = getElementPosition(source);
            if getDistanceBetweenPoints3D (x, y, z, x2, y2, z2) <= 5 then 
                if isGuestAccount(getPlayerAccount(source)) then 
                    return sendMessageServer(player, "Você não pode interagir com um jogador que não está logado!", "error")
                end
                triggerClientEvent (player, "onPlayerToggleInteraction", resourceRoot, source, getPlayerInteraction(player), getElementType(source))
            end
        end
    elseif (source and isElement(source) and getElementType(source) == 'vehicle' and not isPedInVehicle(player)) then 
        if getElementDimension(source) == getElementDimension(player) then 
            local x, y, z = getElementPosition(player);
            local x2, y2, z2 = getElementPosition(source);
            if getDistanceBetweenPoints3D (x, y, z, x2, y2, z2) <= 5 then 
                if isGuestAccount(getPlayerAccount(player)) then 
                    return sendMessageServer(player, "Você não pode interagir com um veículo estando deslogado!", "error")
                end
                triggerClientEvent (player, "onPlayerToggleInteraction", resourceRoot, source, getPlayerInteraction(player), getElementType(source))
            end
        end
    elseif (source and isElement(source) and getElementType(source) == "object" and not isPedInVehicle(player)) then 
        if getElementDimension(source) == getElementDimension(player) then 
            local x, y, z = getElementPosition(player);
            local x2, y2, z2 = getElementPosition(source);
            if config.interaction[getElementType(source)][getElementModel(source)] then 
                if getDistanceBetweenPoints3D (x, y, z, x2, y2, z2) <= 5 then 
                    if isGuestAccount(getPlayerAccount(player)) then 
                        return sendMessageServer(player, "Você não pode interagir com um objeto estando deslogado!", "error")
                    end
                    triggerClientEvent (player, "onPlayerToggleInteraction", resourceRoot, source, getPlayerInteraction(player), getElementType(source))
                end
            end
        end
    end
end)

createEventHandler("onPlayerExecuteInteraction", resourceRoot, function (...)
    local args = ... 

    if source ~= getResourceDynamicElementRoot ( getResourceFromName ( getResourceName ( getThisResource() ) ) ) then 
        return outputDebugString(string.format(
            "Tentativa de Burlar o Trigger onPlayerExecuteInteraction Detectada! Infos: Client | %s | ID %s | IP %s",
            getPlayerName(client), (getElementData(client, 'ID') or 'N/A'), getPlayerIP(client)
        ), 1)
    end

    local data = args.data[args.index]

    if not data then 
        return sendMessageServer (client, "Houve um falha ao tentar executar a interação!", "error")
    end;

    if not args.element then 
        return sendMessageServer(client, "Cidadão não encontrado!", "error")
    end

    if args.element and getElementType(args.element) == 'player' then 
        if isGuestAccount(getPlayerAccount(args.element)) then 
            return print ( getPlayerName(client).. ' Está tentando interagir com um jogador não logado!' ) 
        end

        local TargetID = (getElementData(args.element, 'ID') or false )

        if not TargetID then 
            return false 
        end

    end

    if getElementType(args.element) == 'player' then 

        if data.name == 'Solicitar beijo' then 
            local client_pos = Vector3({getElementPosition(client)});
            local target_pos = Vector3({getElementPosition(args.element)});
    
            local distance = getDistanceBetweenPoints3D(client_pos.x, client_pos.y, client_pos.z, target_pos.x, target_pos.y, target_pos.z)
    
            if distance > 3 then
                return sendMessageServer(client, "Você está muito distânte do jogador!", "error")
            end 
    
            local target_id = (getElementData(args.element, 'ID') or false);
            
            if kiss[args.element] then 
                return sendMessageServer(client, "O jogador já possui uma solicitação de beijo.", "error") 
            end;
    
            outputChatBox("#DFAD7E[INTERAÇÃO] #FFFFFFVoce enviou uma solicitaçao de beijo para o jogador "..getPlayerName(args.element).."("..(getElementData(args.element, "ID") or "N/A")..").", client, 255, 255, 255, true)
            outputChatBox("#DFAD7E[INTERAÇÃO] #FFFFFFO jogador "..getPlayerName(client).."("..(getElementData(args.element, "ID") or "N/A")..") lhe enviou uma solicitação de beijo.", args.element, 255, 255, 255, true)
            outputChatBox("#DFAD7E[INTERAÇÃO] #FFFFFFPara aceitar digite '/aceitarbeijo' ou '/recusarbeijo'.", args.element, 255, 255, 255, true)
    
            kiss[args.element] = getElementData(client, 'ID') or 0;
    
            setTimer ( function ( ) 
                if isElement(args.element) then 
                    if kiss[args.element] then 
                        kiss[args.element] = nil 
                    end
                end
            end, 15000, 1)
    
        elseif data.name == "Algemar" or data.name == "Amarrar" then 

            local quantidade = 0;

            if (data.name == "Algemar") then 
                quantidade = 0
            end

            if (getElementData(args.element, 'guetto.handcuffed')) then 
                setElementData(args.element, 'guetto.handcuffed', nil)
                setPlayerCuffed(args.element, false)
                sendMessageServer(client, "O cidadão foi desalgemado!", "info")
            else
                setElementData(args.element, 'guetto.handcuffed', true)
                setPlayerCuffed(args.element, true)
                sendMessageServer(client, "Você desalgemou o cidadão!", "info")
            end
    
        elseif data.name == "Checar CNH" then 
    
            if getElementData ( args.element, "A" ) then 
                outputChatBox ("CNH A: Sim", client, 255, 255, 255, true )
            else
                outputChatBox ("CNH A: Não", client, 255, 255, 255, true )
            end
        
            if getElementData ( args.element, "B" ) then 
                outputChatBox ("CNH B: Sim", client, 255, 255, 255, true )
            else
                outputChatBox ("CNH B: Não", client, 255, 255, 255, true )
            end
        
            if getElementData ( args.element, "C" ) then 
                outputChatBox ("CNH C: Sim", client, 255, 255, 255, true )
            else
                outputChatBox ("CNH C: Não", client, 255, 255, 255, true )
            end
        
            if getElementData ( args.element, "D" ) then 
                outputChatBox ("CNH D: Sim", client, 255, 255, 255, true )
            else
                outputChatBox ("CNH D: Não", client, 255, 255, 255, true )
            end
    
        elseif data.name == "Ver Porte" then 

            if (getElementData(args.element, "JOAO.porte")) then 
                outputChatBox ("Esse cidadão possui porte de armas!", client, 255, 255, 255, true )
            else
                outputChatBox ("Esse cidadão não possui porte de armas!", client, 255, 255, 255, true )
            end

        elseif data.name == "Propor Sexo" then 
    
            local player_pos = Vector3({getElementPosition(client)});
            local element_pos = Vector3({getElementPosition(args.element)});
    
            local distance = getDistanceBetweenPoints3D(player_pos.x, player_pos.y, player_pos.z, element_pos.x, element_pos.y, element_pos.z)
    
            if distance > 3 then 
                return sendMessageServer(client, 'Você está muito distante do jogador!', 'error')
            end;
    
            if sexy[args.element] then
                return sendMessageServer(client, 'Esse jogador já possui um proposta de sexo em andamento!', 'info')
            end;
    
            sexy[args.element] = getElementData(client, 'ID') or 0;
            
            setTimer(function()
                if isElement(args.element) then 
                    if sexy[args.element] then 
                        sexy[args.element] = nil 
                    end
                end
            end, 15000, 1)
    
            outputChatBox("#DFAD7E[INTERAÇÃO] #FFFFFFVocê enviou uma proposta de sexo para "..(getPlayerName(args.element)).."!", client, 255, 255, 255, true)
            outputChatBox("#DFAD7E[INTERAÇÃO] #FFFFFFVocê recebeu uma proposta de sexo, digite /aceitarsexo para aceitar ou /recusarsexo para recusar a oferta.", args.element, 255, 255, 255, true)
       
        elseif data.name == "Encapuzar" then 
            
            local client_pos = Vector3({getElementPosition(client)});
            local target_pos = Vector3({getElementPosition(args.element)});
    
            local distance = getDistanceBetweenPoints3D(client_pos.x, client_pos.y, client_pos.z, target_pos.x, target_pos.y, target_pos.z)
    
            if distance > 3 then 
                return sendMessageServer(client, 'Você está muito distante do jogador!', 'error')
            end;
    
            if not hood[args.element] then 
    
                if mask[args.element] and isElement(mask[args.element]) then
                    destroyElement(mask[args.element])
                    mask[args.element] = nil
                end
                
                --mask[args.element] = createObject(1455, target_pos.x, target_pos.y, target_pos.z)
                --exports['bone_attach']:attachElementToBone(mask[args.element], args.element, 1, -0.0010, 0.03,-0.6,-90,0, 180)
    
                hood[args.element] = true 
                sendMessageServer(client, "Você encapuzou o jogador "..(getPlayerName(client)).."#"..((getElementData(client, "ID") or "N/A")).."!", "info")
                triggerClientEvent(args.element, "onPlayerToggleHood", resourceRoot, "Você foi encapuzado por " .. ( getPlayerName(client) ).. "")
            else
    
                if mask[args.element] and isElement(mask[args.element]) then
                    exports['bone_attach']:detachElementFromBone(mask[args.element])
                    destroyElement(mask[args.element])
                    mask[args.element] = nil
                end
                
                hood[args.element] = false
    
                triggerClientEvent(args.element, "onPlayerToggleHood", resourceRoot, client)
                sendMessageServer(client, "Você desencapuzou o jogador "..(getPlayerName(client)).."#"..((getElementData(client, "ID") or "N/A")).."!", "info")
            end
    
        elseif data.name == "Carregar" then 

            if (getElementData(args.element, "guetto.handcuffed")) then
                return sendMessageServer(client, "Você não pode carregar um jogador algemado!", "info")
            end

            if (hood[args.element]) then 
                return sendMessageServer(client, "Você não pode carregar um jogador encapuzado!", "info")
            end

            if (isGrabbed[args.element]) then 

                isPlayerCarring[client] = nil
                isGrabbed[args.element] = nil
    
                detachElements(args.element, getElementAttachedTo(args.element))
                setElementData(args.element, "guetto.carry", nil)
    
                triggerClientEvent(root, "FS:removeAnim", resourceRoot, client)
                triggerClientEvent(root, 'FS:removeIFPAnimation', resourceRoot, args.element)
                setElementCollisionsEnabled(args.element, true)
                toggleAllControls(args.element, true)
    
            else
                
                isPlayerCarring[client] = args.element
                isGrabbed[args.element] = client
    
                setElementCollisionsEnabled(args.element, true)
                attachElements(args.element, client, 0.19, 0.05, 0, 0, 0, 0)
                setElementData(args.element, "guetto.carry", true)
                toggleAllControls(args.element, false)
    
                triggerClientEvent(root, 'FS:setIFPAnimation', resourceRoot, args.element, 'carrying')
                triggerClientEvent(root, "FS:addAnim", resourceRoot, client, 'carrying')
    
            end

        elseif data.name == "Curar" then 
            
            triggerEvent("JOAO.curarPlayer", resourceRoot, client, args.element)
    
        elseif data.name == "Saquear" or data.name == "Revistar" then 
    
            local client_pos = Vector3({getElementPosition(client)});
            local target_pos = Vector3({getElementPosition(args.element)}); 
            local distance = getDistanceBetweenPoints3D(client_pos.x, client_pos.y, client_pos.z, target_pos.x, target_pos.y, target_pos.z)
    
            if distance > 3 then 
                return sendMessageServer(client, 'Você está muito distante do jogador!', 'error')
            end;
    
            if not args.element then 
                return sendMessageServer(client, 'Jogador não econtrado!', 'info')
            end
    
            if (getElementData(args.element, 'service.police')) then 
                return sendMessageServer(client, 'Você não pode saquear policial em serviço!', 'error')
            end
    
            if (getElementData(args.element, 'inv.open') or false) then 
                return sendMessageServer(client, 'Você não pode revistar o jogador com inventario aberto!', 'error')
            end
    
            local fallen = getElementData(args.element, "Player.Fallen") or false;
    
            if fallen then 
                local inventory = exports["guetto_inventory"]:getPlayerInventory(args.element);
                triggerClientEvent(client, "guetto.saquear.draw", resourceRoot, inventory, args.element, "police");
                sendMessageServer(client, "Você está "..(data.name == "Saquear" and "saqueando" or "revistando").." o jogador.", "info")
            else
                if (getElementData(client, "service.police") or false) then 
                    local inventory = exports["guetto_inventory"]:getPlayerInventory(args.element);
                    triggerClientEvent(client, "guetto.saquear.draw", resourceRoot, inventory, args.element, "police");
                    sendMessageServer(client, "Você está "..(data.name == "Saquear" and "saqueando" or "revistando").." o jogador.", "info")
                else
                    saqueando[args.element] = {player = client, type = "gang"};
                    outputChatBox("#DFAD7E[INTERAÇÃO] #FFFFFFVocê enviou a proposta para o jogador!", client, 255, 255, 255, true)
                    outputChatBox("#DFAD7E[INTERAÇÃO] #FFFFFFVocê recebeu uma proposta de saque! Digite /aceitarsaque para aceitar ou /recusarsaque para recusar.", args.element, 255, 255, 255, true)
                end
            end
        end

    elseif getElementType(args.element) == 'vehicle' then 

        if data.name == "Colocar no Porta-malas" then 

            local player = client;
            local element = args.element

            if isPedInVehicle(player) then 
                return sendMessageServer(player, 'Você não pode fazer isso dentro de um veículo.', 'info')
            end
    
            if (not isPlayerCarring[player]) then 
                return sendMessageServer(player, 'Você não está carregando ninguém.', 'info')
            end
    
            if isVehicleLocked(args.element) then 
                return sendMessageServer(player, 'O veículo está trancado.', 'info')
            end
    
            if not playersInTrunk[args.element] then 
                playersInTrunk[args.element] = {}
            end    
    
            local target = isPlayerCarring[player]

            detachElements(target, getElementAttachedTo(target))
            setElementData(target, 'FS:actionState > grab', nil)
    
            triggerClientEvent(root, "FS:removeAnim", resourceRoot, player)
            triggerClientEvent(root, 'FS:removeIFPAnimation', resourceRoot, target)
            setElementCollisionsEnabled(target, true)
            
            isPlayerCarring[player] = nil
            isGrabbed[target] = nil
    
            attachElements(target, element, 0.2, -2.5, 0, 0, 0, 90)
            setElementFrozen(target, true)
            toggleAllControls(target, false)
            setPedAnimation(target, "ped", "CAR_dead_LHS")
            
            local vrx, vry, vrz = getElementRotation(element)
            setElementRotation(target, vrx, vry, vrz + 83)
            setElementAlpha(target, 0)
            setElementCollisionsEnabled(target, false)
    
            table.insert(playersInTrunk[element], target)
    
            triggerClientEvent(target, "onPlayerToggleHood", resourceRoot, "Você está em um porta-malas!")

            isPlayerInTrunk[target] = element

        elseif data.name == "Checar Porta-malas" then 

            local player = client;
            local element = args.element

            if isVehicleLocked(element) then 
                return sendMessageServer(player, 'O veículo está trancado.', 'info')
            end
    
            if not playersInTrunk[element] then 
                return sendMessageServer(player, 'Não foi encontrado ningúem no porta-malas.', 'info')
            end
    
            if (#playersInTrunk[element] == 0) then 
                return sendMessageServer(player, 'Não foi encontrado ningúem no porta-malas.', 'info')
            end
    
            for i = 1, #playersInTrunk[element] do 
    
                local target = playersInTrunk[element][i]
                if target then 
                    if target and isElement(target) and element and isElement(element) then 
                        local px, py, pz = getElementPosition(target)
                        local rx, ry, rz = getElementRotation(element)

                        detachElements(target, getElementAttachedTo(target))
                        setElementFrozen(target, false)
                        toggleAllControls(target, true)
                        setElementAlpha(target, 255)
                        setElementCollisionsEnabled(target, true)
                        setElementPosition(target, px - 2, py + 0.5 , pz)
                        setElementRotation(target, rx, ry, rz)
                        setPedAnimation(target)
        
                        table.remove(playersInTrunk[ isPlayerInTrunk[target] ], playerIndexOnVeh(target, element))
                        isPlayerInTrunk[target] = nil
        
                        triggerClientEvent(target, "onPlayerToggleHood", resourceRoot, "")
                    end

                end
    
            end 
                
            playersInTrunk[element] = nil

        elseif data.name == "Porta Malas" then 
            triggerEvent("onPlayerOpenMalas", resourceRoot, client, args.element)
        end

    elseif getElementType(args.element) == 'object' then
        if data.name == "Pegar Vaso" then 
            triggerEvent("onPlayerCollectVase", resourceRoot, client, args.element)
        elseif data.name == "Plantar Cocaina" then 
            triggerEvent("onPlayerPlantDrug", resourceRoot, client, args.element, "cocaine")
        elseif data.name == "Plantar Maconha" then
            triggerEvent("onPlayerPlantDrug", resourceRoot, client, args.element, "marihuana")
        elseif data.name == "Plantação Detalhada" then 
            triggerEvent("onPlayerDetailedPlantation", resourceRoot, client, args.element)
        elseif data.name == "Destuir plantação" then
            local account = getAccountName(getPlayerAccount(client))
            if not isObjectInACLGroup("user."..account, aclGetGroup("Corporação")) then 
                return sendMessageServer(client, "Você não é um policial para destruir a plantação!", "error")
            end
            triggerEvent("onPlayerDestroyPlantation", resourceRoot, client, args.element)
        end
    end


end)

createEventHandler("onPlayerSendCash", resourceRoot, function( ... )
    local args = ... 

    if source ~= getResourceDynamicElementRoot ( getResourceFromName ( getResourceName ( getThisResource() ) ) ) then 
        return outputDebugString(string.format(
            "Tentativa de Burlar o Trigger onPlayerSendCash Detectada! Infos: Client | %s | ID %s | IP %s",
            getPlayerName(client), (getElementData(client, 'ID') or 'N/A'), getPlayerIP(client)
        ), 1)
    end

    if tonumber(args.amount) <= 0 then 
        return sendMessageServer(client, "Digite apenas valores positivos!", "error")
    end

    if not args.element then 
        return sendMessageServer(client, "Jogador não encontrado!", "error")
    end

    if args.type == "Enviar dinheiro" then 
        local money = getPlayerMoney (client);
        
        if client == args.element then 
            return false 
        end
        
        if money < tonumber(args.amount) then 
            return sendMessageServer(client, "Você não possui dinheiro suficiente para enviar para o jogador!", "error")
        end

        if tonumber(args.amount) >= 1000000 then 
            return print ( getPlayerName(client).. ' Está tentando enviar um valor acima de 10kk' )
        end

        local title = 'Interaction | Dinheiro Enviado'
        local description = 'Um jogador enviou dinheiro pelo painel de interação'
        local logs = {
            { name = '👤・Remetente | '..getPlayerName(client)..'#'..(getElementData(client, "ID") or "N/A"), value = 'Enviou R$ '..formatNumber(tonumber(args.amount), '.'), inline = false },
            { name = '🙋‍♂️・Recebedor | '..getPlayerName(args.element)..'#'..(getElementData(args.element, "ID") or "N/A"), value = 'Recebeu R$ '..formatNumber(tonumber(args.amount), '.'), inline = false },
        }

        takePlayerMoney(client, tonumber(args.amount))
        givePlayerMoney(args.element, tonumber(args.amount))
        
        sendMessageServer(client, "Você enviou R$ "..formatNumber(tonumber(args.amount), '.').." para o jogador "..(getPlayerName(args.element)).."#"..(getElementData(args.element, "ID") or "N/A").."!", "info")
        sendMessageServer(args.element, "Você recebeu R$ "..formatNumber(tonumber(args.amount)).." do jogador "..getPlayerName(client).."!", "info")
        
        sendLogs(title, description, logs, webhook[args.type])

    elseif args.type == "Enviar GP" then 
        local points = (getElementData(client, "guetto.points") or 0);

        if not args.element or not isElement(args.element) then 
            return sendMessageServer(client, 'Houve uma falha ao obter o elemento do jogador, tente novamente.', 'error')
        end

        if points < tonumber(args.amount) then 
            return sendMessageServer(client, "Você não possui guetto points suficiente para enviar para o jogador!", "error")
        end

        local title = 'Interaction | Guetto Pontos'
        local description = 'Um jogador enviou pontos pelo painel de interação'

        local logs = {
            { name = '👤・Remetente | '..getPlayerName(client)..'#'..(getElementData(client, "ID") or "N/A"), value = 'Enviou GP '..formatNumber(tonumber(args.amount), '.'), inline = false },
            { name = '🙋‍♂️・Recebedor | '..getPlayerName(args.element)..'#'..(getElementData(args.element, "ID") or "N/A"), value = 'Recebeu GP '..formatNumber(tonumber(args.amount), '.'), inline = false },
        }

        setElementData(client, "guetto.points", points - args.amount)
        setElementData(args.element, "guetto.points", (getElementData(args.element, "guetto.points") or 0) + args.amount)

        sendMessageServer(client, "Você enviou GP "..formatNumber(tonumber(args.amount), '.').." para o jogador "..(getPlayerName(args.element)).."#"..(getElementData(args.element, "ID") or "N/A").."!", "info")
        sendMessageServer(args.element, "Você recebeu GP "..formatNumber(tonumber(args.amount)).." do jogador "..getPlayerName(client).."!", "info")

        sendLogs(title, description, logs, webhook[args.type])
    end

end)

addCommandHandler("aceitarsaque", function (player, cmd)
    if not (saqueando[player]) then 
        return sendMessageServer(player, "Você não possui nenhuma proposta!", "error")
    end

    if not (isElement(saqueando[player].player)) then 
        return sendMessageServer(player, "Jogador não encontrado!", "error")
    end


    local player_pos = Vector3({getElementPosition(player)});
    local target_pos = Vector3({getElementPosition(saqueando[player].player)});

    if getDistanceBetweenPoints3D(player_pos.x, player_pos.y, player_pos.z, target_pos.x, target_pos.y, target_pos.z) > 3 then 
        return sendMessageServer(client, 'Você está muito distante do jogador!', 'error')
    end;

    local inventory = exports["guetto_inventory"]:getPlayerInventory(player);
    triggerClientEvent(saqueando[player].player, "guetto.saquear.draw", resourceRoot, inventory, player, "gang");
end)

addCommandHandler("aceitarsexo", function(player, cmd)

    if not sexy[player] then 
        return sendMessageServer(client, "Você não possui nenhuma proposta!", "info")
    end;

    local element = getPlayerFromID(tonumber(sexy[player]))

    if not element then 
        return sendMessageServer(player, "Jogador não encontrado!", "error")
    end

    if isPedInVehicle(player) then 
        return sendMessageServer(player, "Você não pode aceitar dentro de um veículo!", "error")    
    end

    local player_pos = Vector3({getElementPosition(player)});
    local element_pos = Vector3({getElementPosition(element)});

    local distance = getDistanceBetweenPoints3D(player_pos.x, player_pos.y, player_pos.z, element_pos.x, element_pos.y, element_pos.z)

    if distance > 3 then 
        return sendMessageServer(player, 'O Jogador está muito distante!', 'error')
    end;

    setElementPosition(element, player_pos.x, player_pos.y + 1, player_pos.z);

    setElementRotation(player, 0, 0, 0)
    setElementRotation(element, 0, 0, 180)		

    setPedAnimation ( player, "sex", "sex_1_cum_p", -1, true, false, false )
    setPedAnimation ( element, "sex", "sex_1_cum_w", true, false, false )

    setTimer(function ( player, element )
        
        if isElement(player) then 
            setPedAnimation(player)
        end

        if isElement(element) then 
            setPedAnimation(element)
        end

    end, 10000, 1, player, element)

    sendMessageServer(player, "Você começou a fazer sexo com "..getPlayerName(element).."!", "info")
    sendMessageServer(element, "Você está fazendo sexo com "..getPlayerName(player).."!", "info")
end)

addCommandHandler("aceitarbeijo", function (player)
    if not kiss[player] then 
        return sendMessageServer(player, "Você não tem nenhuma solicitação de beijo pendente!", "error") 
    end;

    local element = getPlayerFromID (tonumber(kiss[player]))
    
    if not element then 
        return sendMessageServer(player, "Jogador não encontrado!", "error")
    end

    local player_pos = Vector3({getElementPosition(player)});
    local element_pos = Vector3({getElementPosition(element)});
    local distance = getDistanceBetweenPoints3D(player_pos.x, player_pos.y, player_pos.z, element_pos.x, element_pos.y, element_pos.z)
    
    if distance > 3 then 
        return sendMessageServer(player, "Você está muito longe do jogador!", "error") 
    end

    kiss[player] = nil;
    
    setElementPosition(player, element_pos.x, element_pos.y-1, element_pos.z);

    setPedAnimation(player, "kissing", "grlfrd_kiss_02", -1, true, false, false, true)
    setPedAnimation(element, "kissing", "playa_kiss_02", -1, true, false, false, true)		

    setElementRotation(player, 0, 0, 0)
    setElementRotation(element, 0, 0, 180)		

    setTimer(function()
        if isElement(player) and isElement(element) then
            setPedAnimation(player, "kissing", "grlfrd_kiss_02", 0, false, false, false, false)
            setPedAnimation(element, "kissing", "grlfrd_kiss_02", 0, false, false, false, false)
        end
    end, 11000, 1)

    sendMessageServer(player, "Você aceitou o beijo do jogador!", "info")
    triggerClientEvent(player, "onPlayerStartSoundKiss", resourceRoot)
    triggerClientEvent(element, "onPlayerStartSoundKiss", resourceRoot)
end)


addCommandHandler("recusarbeijo", function (player)
    local element = getPlayerFromID (tonumber(kiss[player]))
    
    if not element then 
        return false 
    end;

    kiss[player] = nil;

    sendMessageServer(element, "O jogador recusou seu pedido de beijo!", "info")
    sendMessageServer(player, "Você recusou o pedido de beijo!", "info")
end)

addCommandHandler("desencapuzar", function(player, cmd, id)
    local account = getAccountName(getPlayerAccount(player))
    
    if not (isObjectInACLGroup("user."..account, aclGetGroup("Console"))) then 
        return false 
    end

    if not id then 
        return sendMessageServer(player, "Digite o id do jogador!", "error")
    end

    local element = getPlayerID (tonumber(id))

    if not element then 
        return sendMessageServer(player, "Jogador não encontrado!", "error")
    end
    
    if not hood[element] then 
        return sendMessageServer(player, 'Esse jogador não está encapuzado!', 'info')
    end

    if mask[element] and isElement(mask[element]) then
        exports['bone_attach']:detachElementFromBone(mask[element])
        destroyElement(mask[element])
        mask[element] = nil
    end
    
    hood[element] = false

    triggerClientEvent(element, "onPlayerToggleHood", resourceRoot, player)
end)

addEventHandler('onVehicleStartEnter', root, function(player)
    if getElementData(player, 'loaded') then 
        cancelEvent()
        sendMessageServer(player, 'Você não pode entrar em um veículo enquanto está sendo carregado!', 'error')
    end
end)


addEventHandler ('onPlayerVehicleEnter', root, function (veh)
    vehicle[source] = veh
end)

addEventHandler("onElementDestroy", root, function ()
    if getElementType(source) == "vehicle" then
        if (playersInTrunk[source]) then 
            for i = 1, #playersInTrunk[source] do 
                local target = playersInTrunk[source][i]

                local px, py, pz = getElementPosition(target)
                local rx, ry, rz = getElementRotation(source)

                detachElements(target, getElementAttachedTo(target))
                setElementFrozen(target, false)
                toggleAllControls(target, true)
                setElementAlpha(target, 255)
                setElementCollisionsEnabled(target, true)
                setElementPosition(target, px - 2, py + 0.5 , pz)
                setElementRotation(target, rx, ry, rz)
                setPedAnimation(target)

                table.remove(playersInTrunk[ isPlayerInTrunk[target] ], playerIndexOnVeh(target, source))
                isPlayerInTrunk[target] = nil

                triggerClientEvent(target, "onPlayerToggleHood", resourceRoot, "")
            end
            playersInTrunk[source] = nil
        end
    end
end)

function getPlayerID (id)
    local result = false 
    for i, v in ipairs(getElementsByType("player")) do 
        if (getElementData(v, "ID") == tonumber(id)) then 
            result = v 
        end
    end
    return result
end

function sendLogs(title, description, fields, webhook)
    local data = {
        embeds = {
            {
                title = title,
                description = description,
                color = 0x00000000,
                fields = {},

                author = {
                    name = 'Guetto Interaction',
                    icon_url = 'https://imgur.com/tTzPVPi.png'
                },

                footer = {
                    text = 'Guetto Interaction © Todos os direitos reservados.',
                    icon_url = 'https://imgur.com/tTzPVPi.png',
                },

                thumbnail = {
                    url = 'https://imgur.com/tTzPVPi.png'
                },
            }
        }
    }

    for i, v in ipairs(fields) do
        if not v.id then
            v.id = i
        end

        table.insert(data.embeds[1].fields, fields[i])
    end

    data = toJSON(data)
    data = data:sub(2, -2)

    local post = {
        connectionAttempts = 5,
        connectTimeout = 7000,
        headers = {
            ['Content-Type'] = 'application/json'
        },
        postData = data
    }

    fetchRemote(webhook, post, function() end)
end

function playerIndexOnVeh(player, veh)
    local playerIndex
    if playersInTrunk[veh] then 
        for i = 1, #playersInTrunk[veh] do 
            if player == playersInTrunk[veh][i] then 
                playerIndex = i
                break
            end
        end
    end
    return playerIndex
end
