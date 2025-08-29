addCommandHandler(config["system"]["command"], function(player)
    if isPlayerInACL(player) then 
        triggerClientEvent(player, "squady.openMoneyLaundry", player)
    end
end)

local lastOfferTime = {} 
 
addEvent("squady.sendOffer", true)
addEventHandler("squady.sendOffer", getRootElement(), function(player, qntd, receiverId, percentage)
    if qntd and receiverId and percentage then 
        local receiver = getPlayerByID(tonumber(receiverId))

        if (tonumber(percentage) < 0) then 
            return sendMessage("server", player, "Insira uma valor maior que 0!", "error")
        end

        if (tonumber(percentage) < 10) then 
            return sendMessage("server", player, "Insira uma valor maior ou igual a 10!", "error")
        end

        if tonumber(qntd) <= 0 then return false end

        local currentTime = getTickCount()
        local lastTime = lastOfferTime[source] or 0
        local cooldowTime = 60000

        if currentTime - lastTime >= cooldowTime then
            lastOfferTime[source] = currentTime

            if receiver and isElement(receiver) then 
                local playerX, playerY, playerZ = getElementPosition(player)
                local receiverX, receiverY, receiverZ = getElementPosition(receiver)
                local distance = getDistanceBetweenPoints3D(playerX, playerY, playerZ, receiverX, receiverY, receiverZ)

                for i,v in ipairs(getElementsByType("vehicle")) do 
                    local x, y, z = getElementPosition(v)
                    local distance = getDistanceBetweenPoints3D(playerX, playerY, playerZ, x, y, z)
                    if distance <= 10 then 
                        sendMessage("server", player, "Você não pode lavar dinheiro perto de um veículo.", "error")
                        return
                    end
                end

                if distance <= 5 then 
                    local dirtyMoney = exports["guetto_inventory"]:getItem(receiver, 100)

                    if tonumber(dirtyMoney) >= tonumber(qntd) then
                        if config["system"]["percentage.limit"] and config["system"]["percentage.limit"] ~= nil then
                            if percentage and percentage ~= nil and tonumber(percentage) <= (tonumber(config["system"]["percentage.limit"]) or 0) then 
                                triggerClientEvent(receiver, "squady.openDrawOffer", receiver, (getElementData(player, "ID") or 0), getPlayerName(player), tonumber(qntd), tonumber(percentage))
                                sendMessage("server", player, "Oferta de lavagem enviada para o jogador.", "success")
                            else
                                sendMessage("server", player, "O valor de porcentagem não pode ser maior que "..config["system"]["percentage.limit"].."%", "error")
                            end
                        end
                    else
                        sendMessage("server", player, "O jogador não possui essa quantidade de dinheiro sujo.", "error")
                    end
                else
                    sendMessage("server", player, "Você precisa estar a pelo menos 5 metros do jogador para lavar o dinheiro.", "error")
                end
            else
                sendMessage("server", player, "Jogador não encontrado.", "error")
            end
        else
            sendMessage("server", player, "Você precisa esperar "..math.ceil((cooldowTime - (currentTime - lastTime)) / 1000).." segundos para enviar outra oferta.", "error")
        end
    end
end)

sendMonying = {}

addEvent("squady.responseOffer", true)
addEventHandler("squady.responseOffer", resourceRoot, function(player, action, senderID, quantity, percentage)
    
    if action == "accept" then
        sendMonying[player] = true
        senderID = tonumber(senderID)
        local receiver = getPlayerByID(senderID)

        if quantity <= 0 then
            sendMessage("server", player, "Quantidade inválida.", "error")
            sendMonying[player] = false
            return
        end

        if receiver and isElement(receiver) then
            triggerClientEvent(receiver, "squady.changeStateMoneyLaundry", receiver)
            setTimer(function()
                local remainingAmount = quantity * (1 - percentage / 100)
                local removedAmount = quantity - remainingAmount

                if sendMonying[player] == false then return end
                local dirtyMoney = exports["guetto_inventory"]:getItem(player, 100)
                if dirtyMoney >= quantity then
                    exports["guetto_inventory"]:takeItem(player, 100, quantity)
                    givePlayerMoney(receiver, removedAmount)
                    givePlayerMoney(player, remainingAmount)
                    sendMessage("server", receiver, "Você lavou R$"..quantity.." e recebeu R$"..removedAmount.." por isso.", "success")
                    sendMessage("server", player, ""..getPlayerName(receiver).." ("..(getElementData(receiver, "ID") or "N/A")..") lavou seu dinheiro e você recebeu R$"..remainingAmount..".", "success")
                    --exports["[BVR]Util"]:messageDiscord("O jogador(a) "..getPlayerName(receiver).."("..(getElementData(receiver, 'ID') or 0)..") lavou R$"..quantity.." do jogador "..getPlayerName(player).."("..(getElementData(player, 'ID') or 0)..") ", "https://discord.com/api/webhooks/1198498204346482718/qpo6RbivCUdJD-sp7vRaes2Vy815EPI2ixx57IEcqIAEKJYkc6HC2Us-aIxG5YcrgyoZ")        
                    triggerClientEvent(receiver, "squady.closeMoneyLaundry", receiver)
                    sendMonying[player] = false
                else
                    sendMessage("server", player, "Erro ao lavar dinheiro. Tente novamente.", "error")
                    sendMonying[player] = false
                end
            end, 5000, 1)
        else
            sendMessage("server", player, "Jogador não encontrado.", "error")
            sendMonying[player] = false
        end
    end
end)