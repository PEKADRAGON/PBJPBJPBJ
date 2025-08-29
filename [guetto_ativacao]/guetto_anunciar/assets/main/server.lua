addCommandHandler(config["gerais"]["command.announce"], function(player)
    if isPlayerInACL(player) then 
        triggerClientEvent(player, "squady.openAnnouncement", player)
    end
end)

addEvent("squady.sendAnnounce", true)
addEventHandler("squady.sendAnnounce", getRootElement(), function(hash, iv)

    if not client then 
        return
    end

    local player = client
    
    decodeString('aes128', hash, {key = getPlayerSerial(player):sub(17), iv = iv}, function(decoded)
        local dados = fromJSON(decoded)

        local description = dados.description
        local receiver = dados.receiver
        local button = dados.button

        if button == "global" then 
            triggerClientEvent(root, "squady.openAnnounce", player, description)
            sendMessage("server", player, "Você enviou um anúncio global.", "success")
    
            if config["logs"]["log"] then 
                messageDiscord(""..getPlayerName(player).." ("..(getElementData(player, config["gerais"]["element.data-id"]) or "N/A")..") enviou um anúncio global | Anuncio: "..description.."", config["logs"]["web-hook"])
            end
    
        elseif button == "private" then 
            local targetPlayer = getPlayerFromID(receiver)
            
            if targetPlayer then 
                triggerClientEvent(targetPlayer, "squady.openAnnounce", player, description)
                sendMessage("server", player, "Você enviou um anúncio privado para "..getPlayerName(targetPlayer).." ("..(getElementData(targetPlayer, config["gerais"]["element.data-id"]) or "N/A")..").", "success")
            
                if config["logs"]["log"] then 
                    messageDiscord(""..getPlayerName(player).." ("..(getElementData(player, config["gerais"]["element.data-id"]) or "N/A")..") enviou um anúncio privado para "..getPlayerName(targetPlayer).." ("..(getElementData(targetPlayer, config["gerais"]["element.data-id"]) or "N/A")..") | Anuncio: "..description.."", config["logs"]["web-hook"])
                end
            else
                sendMessage("server", player, "Jogador não encontrado.", "error")
            end
        end
    end)
end)

setTimer(function()
    triggerClientEvent(root, "squady.openAnnounce", root, "Deseja adquirir um vip? Entre em nosso discord utilizado /dc.")
end, 30 * 60000, 0)