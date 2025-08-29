local sender_proposal = {}
local reciver_proposal = {}
local delay_proposal = {}

function getPlayerSendItem (player)
    if not (player) then 
        return false 
    end
    return sender_proposal[player] or false
end

function getPlayerReciverItem (player)
    if not (player) then 
        return false 
    end
    return reciver_proposal[player] or false 
end

createEventHandler("onPlayerSendItem", resourceRoot, function (data, quantidade)

    -- =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= Proteções não alterar! =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= 
    if not (client or (source ~= resourceRoot)) then 
        return false;
    end;

    if (quantidade <= 0) then 
        return false 
    end

    if not (data or type(data) ~= "table") then 
        return false 
    end 

    if (getPlayerSendItem(client)) then 
        return sendMessageServer(client, "Você está fazendo isso rápido demais!", "info")
    end

    -- =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= Armazenar informações do item em variavies! =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= 

    local item = tonumber(data["item"]); -- Id do item
    local quantidade = tonumber(quantidade) -- Quantidade que vai usar do item
    local settings = config["itens"][item] -- Salva as informações do item da config

    if (settings["others"]["enviar"] == false) then 
        return sendMessageServer(client, "Você não pode enviar esse item!", "error")
    end

    if (isElement(getVehicleNearest(client))) then 
        return sendMessageServer(client, "Você não pode enviar um item proximo de um veículo!", "error")
    end

    if (getItem(client, item) < quantidade) then 
        return sendMessageServer(client, "Você não possui essa quantidade!", "info")
    end

    if delay_proposal[client] and (getTickCount() - delay_proposal[client]) < 5000 then
        return sendMessageServer(client, "Aguarde 5 segundos para enviar um item novamente!", "error")
    end

    local target = getPlayerNearest (client);

    if not (target) then 
        return sendMessageServer(client, "Você não está próximo a nenhum jogador!", "info")
    end

    if not (getPlayerSpaceItem(target, item, quantidade)) then 
        sendMessageServer(client, "O jogador não possui espaço suficiente na mochila!", "info")
        return sendMessageServer(target, "Você não é o superman para carregar tudo isso!", "info")
    end

    sender_proposal[client] = target;
    reciver_proposal[target] = client;

    triggerClientEvent(target, "TogglePlayerProposal", resourceRoot, item, quantidade)

    sendMessageServer(client, "Você enviou a proposta  para o jogador "..(getPlayerName(target)).." !", "info")
    sendMessageServer(target, "Você recebeu uma proposta para o jogador "..(getPlayerName(client)).."!", "info")

end)

createEventHandler("onPlayerAccpetProposal", resourceRoot, function (item, quantidade)

    -- =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= Proteções não alterar! =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= 
    if not (client or (source ~= resourceRoot)) then 
        return false;
    end;

    if (quantidade <= 0) then 
        return false 
    end

    local item = tonumber(item); -- Id do item
    local quantidade = tonumber(quantidade) -- Quantidade que vai usar do item
    local settings = config["itens"][item] -- Salva as informações do item da config
    
    if (settings["others"]["enviar"] == false) then 
        return sendMessageServer(client, "Você não pode aceitar esse item!", "error")
    end

    if not (isElement(reciver_proposal[client])) then 
        return sendMessageServer(client, "Jogador não encontrado!", "error")
    end

    local sender = reciver_proposal[client];

    if (getItem(sender, item) < quantidade) then 
        return sendMessageServer(client, "O jogador não possui essa quantidade de item!", "info")
    end

    if not (getPlayerSpaceItem(client, item, quantidade)) then 
        return sendMessageServer(client, "Você não possui espaço suficiente na mochila!", "info")
    end

    setPedAnimation(client, 'DEALER','DEALER_DEAL', 2000, false, false, false, false)
    setPedAnimation(sender, 'DEALER','DEALER_DEAL', 2000, false, false, false, false)
    
    takeItem(sender, item, quantidade)

    sender_proposal[sender] = nil;
    reciver_proposal[client] = nil;

    setTimer ( function (player, sender)
        
        if isElement(player) then 
            setPedAnimation(player, false)
            setPedAnimation(sender, false)
        end

        giveItem(player, item, quantidade)

        sendMessageServer(player, 'Você recebeu o item com sucesso!', 'success')
        sendMessageServer(sender, 'Você enviou o item com sucesso!', 'success')

        delay_proposal[sender] = getTickCount()

    end, 2000, 1, client, sender)

end)

createEventHandler("onPlayerDeclineProposal", resourceRoot, function (item, quantidade)

    -- =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= Proteções não alterar! =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= 
    if not (client or (source ~= resourceRoot)) then 
        return false;
    end;

    if (quantidade <= 0) then 
        return false 
    end

    local item = tonumber(item); -- Id do item
    local quantidade = tonumber(quantidade) -- Quantidade que vai usar do item
    local settings = config["itens"][item] -- Salva as informações do item da config

    local sender = reciver_proposal[client];

    sender_proposal[sender] = nil;
    reciver_proposal[client] = nil;

    sendMessageServer(client, "Voce recusou a proposta!", "info")
    sendMessageServer(sender, "Jogador recusou a proposta!", "info")
end)