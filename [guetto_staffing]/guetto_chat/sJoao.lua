function AntiFlood(source)
    if not isObjectInACLGroup("user."..getAccountName(getPlayerAccount(source)), aclGetGroup("Console")) then
        setElementData(source, "JOAO.antiFlood", true)
        setTimer(function()
            if isElement(source) and getElementType(source) == "player" then 
              setElementData(source, "JOAO.antiFlood", false)
            end 
        end, 3000, 1)
    end
end

addEventHandler("onResourceStart", resourceRoot,
function()
    for i, v in ipairs(getElementsByType("player")) do
        if (getElementData(v, "JOAO.antiFlood") or false) then
            setElementData(v, "JOAO.antiFlood", false)
        end
    end
    for i,v in ipairs(config["Custom Chats"]) do 
        addCommandHandler(v.chatCommand,
        function(player, cmd, ...)
            if player and isElement(player) and getElementType(player) == "player" and not isGuestAccount(getPlayerAccount(player)) then
                if aclGetGroup(v.chatAcl) and isObjectInACLGroup("user."..getAccountName(getPlayerAccount(player)), aclGetGroup(v.chatAcl)) then
                    local msg = table.concat({ ... }, " ")
                    if getElementData(player, "JOAO.antiFlood") then outputChatBox("Aguarde 3 segundos para enviar outra mensagem.", player, 255, 0, 0, false) return end
                    if isPlayerMuted(player) then outputChatBox("Você está mutado", player, 255, 0, 0, false) return end
                    AntiFlood(player)
                    local ID = getElementData(player, "ID") or "N/A"
                    local time = getRealTime()
                    local formattedTime = ((time.hour < 10 and "0"..(time.hour) or time.hour)..":"..(time.minute < 10 and "0"..(time.minute) or time.minute))
                    local msgSemCor = string.gsub(msg, "#%x%x%x%x%x%x", "")
                    Async:foreach(getElementsByType('player'), true, function(thePlayer) 
                        if thePlayer and isElement(thePlayer) and getElementType(thePlayer) == "player" then
                            if aclGetGroup(v.chatAcl) and isObjectInACLGroup("user."..getAccountName(getPlayerAccount(thePlayer)), aclGetGroup(v.chatAcl)) then
                                outputChatBox("("..formattedTime..") "..v.chatColor.."* ["..v.chatName.."] #FFFFFF» "..string.gsub(removeHex(getPlayerName(player)), '_', ' ').." ("..ID..")#FFFFFF: "..v.chatColor..""..msgSemCor, thePlayer, 255, 255, 255, true)
                            end
                        end 
                    end) 
                    exports["guetto_util"]:messageDiscord("O jogador(a) "..(exports["guetto_util"]:puxarNome(player)).." ("..(exports["guetto_util"]:puxarID(player))..") enviou no **"..v.chatName.."**: "..msgSemCor.."", v.chatWebhook)
                end
            end
        end)
    end
end)

function ChatTwitter(source, cmd, ...) 
    if not isGuestAccount(getPlayerAccount(source)) then
        local msg = table.concat({ ... }, " ")
        if getElementData(source, "JOAO.antiFlood") then outputChatBox("Aguarde 3 segundos para enviar outra mensagem.", source, 255, 0, 0, false) return end
        if (getElementData(source, "MutadoChat") or false) then outputChatBox("Você está mutado", source, 255, 0, 0, false) return end
        AntiFlood(source)
        local ID = getElementData(source, "ID") or "N/A"
        local time = getRealTime()
        local formattedTime = ((time.hour < 10 and "0"..(time.hour) or time.hour)..":"..(time.minute < 10 and "0"..(time.minute) or time.minute))
        local msgSemCor = string.gsub(msg, "#%x%x%x%x%x%x", "")
        Async:foreach(config["Tags"], true, function(k) 
            if aclGetGroup(k[2]) and isObjectInACLGroup("user."..getAccountName(getPlayerAccount(source)), aclGetGroup(k[2])) then
                aclSource = k 
            end 
		end) 
        Async:foreach(getElementsByType('player'), true, function(v) 
            if v and isElement(v) and getElementType(v) == "player" then
                local tag = (getElementData(source, 'JOAO.myTag') or false)
                if tag ~= false then
                    outputChatBox("("..formattedTime..") "..config["Cores"].Twitter.."*TWITTER » #ffffff"..aclSource[1].." "..config["Cores"].Twitter.."["..tag.."] #FFFFFF"..string.gsub(removeHex(getPlayerName(source)), '_', ' ').." ("..ID..")#FFFFFF: "..config["Cores"].Twitter..""..msgSemCor, v, 255, 255, 255, true)
                else
                    outputChatBox("("..formattedTime..") "..config["Cores"].Twitter.."*TWITTER » #ffffff"..aclSource[1].." #FFFFFF"..string.gsub(removeHex(getPlayerName(source)), '_', ' ').." ("..ID..")#FFFFFF: "..config["Cores"].Twitter..""..msgSemCor, v, 255, 255, 255, true)
                end
            end 
		end) 
        exports["guetto_util"]:messageDiscord("("..formattedTime..") O jogador(a) "..(exports["guetto_util"]:puxarNome(source)).." ("..(exports["guetto_util"]:puxarID(source))..") enviou no **TWITTER**: "..msgSemCor.."", "https://discord.com/api/webhooks/1240193682855039016/GuPDFOzls1AIovSb1ieSbf2pfrRm3PN2uDkgvKnS7IgCuDJnoj6N01FVYhPvoJM-bwey")
    end
end
addCommandHandler("Twitter", ChatTwitter)

function ChatForaRP(source, cmd, ...) 
    if not isGuestAccount(getPlayerAccount(source)) then
        if not (getElementData(source, "onProt") or false) then
            if getPlayerMoney(source) >= 150 then
                takePlayerMoney(source, 150)
                local msg = table.concat ( { ... }, " " )
                if getElementData(source, "JOAO.antiFlood") then outputChatBox("Aguarde 3 segundos para enviar outra mensagem.", source, 255, 0, 0, false) return end
                if (getElementData(source, "MutadoChat") or false) then outputChatBox("Você está mutado", source, 255, 0, 0, false) return end
                AntiFlood(source)
                local ID = getElementData(source, "ID") or "N/A"
                local time = getRealTime()
                local formattedTime = ((time.hour < 10 and "0"..(time.hour) or time.hour)..":"..(time.minute < 10 and "0"..(time.minute) or time.minute))
                local msgSemCor = string.gsub(msg, "#%x%x%x%x%x%x", "")
                Async:foreach(config["Tags"], true, function(k) 
                    if aclGetGroup(k[2]) and isObjectInACLGroup("user."..getAccountName(getPlayerAccount(source)), aclGetGroup(k[2])) then
                        aclSource = k 
                    end 
		        end) 
                Async:foreach(getElementsByType('player'), true, function(v) 
                    if v and isElement(v) and getElementType(v) == "player" then
                        local tag = (getElementData(source, 'JOAO.myTag') or false)
                        if tag ~= false then
                            outputChatBox("("..formattedTime..") "..config["Cores"].ForaRP.."*FORA RP » #ffffff"..aclSource[1].." "..config["Cores"].ForaRP.."["..tag.."] #FFFFFF"..string.gsub(removeHex(getPlayerName(source)), '_', ' ').." ("..ID..")#FFFFFF: "..config["Cores"].ForaRP..""..msgSemCor, v, 255, 255, 255, true)
                        else
                            outputChatBox("("..formattedTime..") "..config["Cores"].ForaRP.."*FORA RP » #ffffff"..aclSource[1].." #FFFFFF"..string.gsub(removeHex(getPlayerName(source)), '_', ' ').." ("..ID..")#FFFFFF: "..config["Cores"].ForaRP..""..msgSemCor, v, 255, 255, 255, true)
                        end
                    end 
		        end) 
                exports["guetto_util"]:messageDiscord("("..formattedTime..") O jogador(a) "..(exports["guetto_util"]:puxarNome(source)).." ("..(exports["guetto_util"]:puxarID(source))..") enviou no **FORA RP**: "..msgSemCor.."", "https://discord.com/api/webhooks/1240194044269957151/fyaqlm2vjWdzCzZyLQo_Dj4l7BFG8yoNxaL4TfXkqJGBKCHwIpk2pKL_Y90Ey6IweHOg")
            else
               --(source, "Você não tem dinheiro suficiente!", "error")
            end
        else
            local msg = table.concat ( { ... }, " " )
            if getElementData(source, "JOAO.antiFlood") then outputChatBox("Aguarde 3 segundos para enviar outra mensagem.", source, 255, 0, 0, false) return end
            if (getElementData(source, "MutadoChat") or false) then outputChatBox("Você está mutado", source, 255, 0, 0, false) return end
            AntiFlood(source)
            local ID = getElementData(source, "ID") or "N/A"
            local time = getRealTime()
            local formattedTime = ((time.hour < 10 and "0"..(time.hour) or time.hour)..":"..(time.minute < 10 and "0"..(time.minute) or time.minute))
            local msgSemCor = string.gsub(msg, "#%x%x%x%x%x%x", "")
            Async:foreach(config["Tags"], true, function(k) 
                if aclGetGroup(k[2]) and isObjectInACLGroup("user."..getAccountName(getPlayerAccount(source)), aclGetGroup(k[2])) then
                    aclSource = k 
                end 
		    end) 
            Async:foreach(getElementsByType('player'), true, function(v) 
                if v and isElement(v) and getElementType(v) == "player" then
                    local tag = (getElementData(source, 'JOAO.myTag') or false)
                    if tag ~= false then
                        outputChatBox("("..formattedTime..") "..config["Cores"].ForaRP.."*FORA RP » #ffffff"..aclSource[1].." "..config["Cores"].ForaRP.."["..tag.."] #FFFFFF"..string.gsub(removeHex(getPlayerName(source)), '_', ' ').." ("..ID..")#FFFFFF: "..config["Cores"].ForaRP..""..msgSemCor, v, 255, 255, 255, true)
                    else
                        outputChatBox("("..formattedTime..") "..config["Cores"].ForaRP.."*FORA RP » #ffffff"..aclSource[1].." #FFFFFF"..string.gsub(removeHex(getPlayerName(source)), '_', ' ').." ("..ID..")#FFFFFF: "..config["Cores"].ForaRP..""..msgSemCor, v, 255, 255, 255, true)
                    end
                end 
		    end) 
            exports["guetto_util"]:messageDiscord("("..formattedTime..") O jogador(a) "..(exports["guetto_util"]:puxarNome(source)).." ("..(exports["guetto_util"]:puxarID(source))..") enviou no **FORA RP**: "..msgSemCor.."", "https://discord.com/api/webhooks/1240194044269957151/fyaqlm2vjWdzCzZyLQo_Dj4l7BFG8yoNxaL4TfXkqJGBKCHwIpk2pKL_Y90Ey6IweHOg")
        end
    end
end
addCommandHandler("ForaRP", ChatForaRP)

function ChatAnonimo(source, cmd, ...)
    if not isGuestAccount(getPlayerAccount(source)) then
        local msg = table.concat({ ... }, " ")
        if getElementData(source, "JOAO.antiFlood") then outputChatBox("Aguarde 3 segundos para enviar outra mensagem.", source, 255, 0, 0, false) return end
        if (getElementData(source, "MutadoChat") or false) then outputChatBox("Você está mutado", source, 255, 0, 0, false) return end
        AntiFlood(source)
        local ID = getElementData(source, "ID") or "N/A"
        local msgSemCor = string.gsub(msg, "#%x%x%x%x%x%x", "")
        local time = getRealTime()
        local formattedTime = ((time.hour < 10 and "0"..(time.hour) or time.hour)..":"..(time.minute < 10 and "0"..(time.minute) or time.minute))
        Async:foreach(getElementsByType('player'), true, function(v) 
            if v and isElement(v) and getElementType(v) == "player" then
                if not isObjectInACLGroup ("user."..getAccountName(getPlayerAccount(v)), aclGetGroup ( "Corporação" ) ) then
                    if getElementData(v, 'onProt') then
                        outputChatBox("("..formattedTime..") "..config["Cores"].Anonimo.."*DEEP WEB » ("..ID..")#FFFFFF: "..config["Cores"].Anonimo..""..msgSemCor, v, 255, 255, 255, true)
                    else
                        outputChatBox("("..formattedTime..") "..config["Cores"].Anonimo.."*DEEP WEB#FFFFFF: "..config["Cores"].Anonimo..""..msgSemCor, v, 255, 255, 255, true)
                    end
                end
            end 
		end) 
        exports["guetto_util"]:messageDiscord("("..formattedTime..") O jogador(a) "..(exports["guetto_util"]:puxarNome(source)).." ("..(exports["guetto_util"]:puxarID(source))..") enviou na **DEEP WEB**: "..msgSemCor.."", "https://discord.com/api/webhooks/1240194399028252742/ac8wK4N4mX-dZyfLlf0jckOtQJpVmA6vm1ndvY5prmbk-A9xGVeReyp2Gma81hELqo7s")
    end
end
addCommandHandler("Anonimo", ChatAnonimo)

addCommandHandler("copom",
function(player, cmd, ...)
    if not isGuestAccount(getPlayerAccount(player)) then
        if aclGetGroup("Corporação") and isObjectInACLGroup("user."..getAccountName(getPlayerAccount(player)), aclGetGroup("Corporação")) then
            local msg = table.concat({ ... }, " ")
            if getElementData(player, "JOAO.antiFlood") then outputChatBox("Aguarde 3 segundos para enviar outra mensagem.", player, 255, 0, 0, false) return end
            if isPlayerMuted(player) then outputChatBox("Você está mutado", player, 255, 0, 0, false) return end
            AntiFlood(player)
            local ID = getElementData(player, "ID") or "N/A"
            local msgSemCor = string.gsub(msg, "#%x%x%x%x%x%x", "")
            Async:foreach(getElementsByType('player'), true, function(v) 
                if v and isElement(v) and getElementType(v) == "player" then
                    if aclGetGroup("Corporação") and isObjectInACLGroup("user."..getAccountName(getPlayerAccount(v)), aclGetGroup("Corporação")) then
                        outputChatBox(config["Cores"].Copom.."* [COPOM] #FFFFFF» "..string.gsub(removeHex(getPlayerName(player)), '_', ' ').." ("..ID..")#FFFFFF: "..config["Cores"].Copom..""..msgSemCor, v, 255, 255, 255, true)
                    end
                end 
		    end) 
            exports["guetto_util"]:messageDiscord("O jogador(a) "..(exports["guetto_util"]:puxarNome(player)).." ("..(exports["guetto_util"]:puxarID(player))..") enviou no **COPOM**: "..msgSemCor.."", "https://discord.com/api/webhooks/1240194574211747882/w0t4sG9xEFfjonfeBtCv_ws50BBZiJmy9yC5Tece-DkH8WQi7TQDICjlQPX4u1U50l9e")
        end
    end
end)

addCommandHandler("hp",
function(player, cmd, ...)
    if not isGuestAccount(getPlayerAccount(player)) then
        if aclGetGroup("SAMU") and isObjectInACLGroup("user."..getAccountName(getPlayerAccount(player)), aclGetGroup("SAMU")) or  aclGetGroup("SOS") and isObjectInACLGroup("user."..getAccountName(getPlayerAccount(player)), aclGetGroup("SOS")) then
            local msg = table.concat({ ... }, " ")
            if getElementData(player, "JOAO.antiFlood") then outputChatBox("Aguarde 3 segundos para enviar outra mensagem.", player, 255, 0, 0, false) return end
            if isPlayerMuted(player) then outputChatBox("Você está mutado", player, 255, 0, 0, false) return end
            AntiFlood(player)
            local ID = getElementData(player, "ID") or "N/A"
            local msgSemCor = string.gsub(msg, "#%x%x%x%x%x%x", "")
            Async:foreach(getElementsByType('player'), true, function(v) 
                if v and isElement(v) and getElementType(v) == "player" then
                    if aclGetGroup("SAMU") and isObjectInACLGroup("user."..getAccountName(getPlayerAccount(v)), aclGetGroup("SAMU")) or  aclGetGroup("SOS") and isObjectInACLGroup("user."..getAccountName(getPlayerAccount(v)), aclGetGroup("SOS")) then
                        outputChatBox(config["Cores"].Hospital.."* [HOSPITAL] #FFFFFF» "..string.gsub(removeHex(getPlayerName(player)), '_', ' ').." ("..ID..")#FFFFFF: "..config["Cores"].Hospital..""..msgSemCor, v, 255, 255, 255, true)
                    end
                end 
		    end) 
            exports["guetto_util"]:messageDiscord("O jogador(a) "..(exports["guetto_util"]:puxarNome(player)).." ("..(exports["guetto_util"]:puxarID(player))..") enviou no **HOSPITAL**: "..msgSemCor.."", "https://discord.com/api/webhooks/1240194752708739163/cq-6nUp1d98hJORdxBcDfGMAI4k3EYvn9ErNNG0fmg6-DsH-ftl2sK1pk1g3tqhwARih")
        end
    end
end)

addCommandHandler("s",
function(player, cmd, ...)
    if not isGuestAccount(getPlayerAccount(player)) then
        if (getElementData(player, "onProt") or false) then
            local msg = table.concat({ ... }, " ")
            if getElementData(player, "JOAO.antiFlood") then outputChatBox("Aguarde 3 segundos para enviar outra mensagem.", player, 255, 0, 0, false) return end
            if isPlayerMuted(player) then outputChatBox("Você está mutado", player, 255, 0, 0, false) return end
            AntiFlood(player)
            local ID = getElementData(player, "ID") or "N/A"
            local msgSemCor = string.gsub(msg, "#%x%x%x%x%x%x", "")
            Async:foreach(getElementsByType('player'), true, function(v) 
                if v and isElement(v) and getElementType(v) == "player" then
                    if (getElementData(v, "onProt") or false) then
                        outputChatBox(config["Cores"].Staff.."* [STAFF] #FFFFFF» "..string.gsub(removeHex(getPlayerName(player)), '_', ' ').." ("..ID..")#FFFFFF: "..config["Cores"].Staff..""..msgSemCor, v, 255, 255, 255, true)
                    end
                end 
		    end) 
            exports["guetto_util"]:messageDiscord("O jogador(a) "..(exports["guetto_util"]:puxarNome(player)).." ("..(exports["guetto_util"]:puxarID(player))..") enviou no **STAFF**: "..msgSemCor.."", "https://discord.com/api/webhooks/1240194906329186316/QhWTkpdu_psl2BIko4YmHTK9RPb3iVTTPvfdObdfh1w6SPTdcMBXlyE-ZZ31ONLHPx03")
        end
    end
end)

addEventHandler("onPlayerChat", root,
function(mensagem, msgtype)
    if msgtype == 0 then
        cancelEvent()
        if not isGuestAccount(getPlayerAccount(source)) then
            local pos = {getElementPosition(source)}
            if getElementData(source, "JOAO.antiFlood") then outputChatBox("Aguarde 3 segundos para enviar outra mensagem.", source, 255, 0, 0, false) return end
            if (getElementData(source, "MutadoChat") or false) then outputChatBox("Você está mutado", source, 255, 0, 0, false) return end
            AntiFlood(source)
            local ID = getElementData(source, "ID") or "N/A"
            local int = getElementInterior(source)
            local dim = getElementDimension(source)
            local time = getRealTime()
            local formattedTime = ((time.hour < 10 and "0"..(time.hour) or time.hour)..":"..(time.minute < 10 and "0"..(time.minute) or time.minute))
            local msgSemCor = string.gsub(mensagem, "#%x%x%x%x%x%x", "")
            Async:foreach(config["Tags"], true, function(k, i) 
                if source and isElement(source) and getElementType(source) == "player" then
                    if aclGetGroup(k[2]) and isObjectInACLGroup("user."..getAccountName(getPlayerAccount(source)), aclGetGroup(k[2])) then
                        aclSource = k 
                    end 
                    if i == #config["Tags"] then 
                        for i,v in ipairs(getElementsByType("player")) do 
                            if v and isElement(v) and getElementType(v) == "player" then
                                if v and isElement(v) then 
                                    local posReceiver = {getElementPosition(v)}
                                    if getDistanceBetweenPoints3D(pos[1], pos[2], pos[3], posReceiver[1], posReceiver[2], posReceiver[3]) <= config["Distancia_Chat_Local"] then
                                        local int2 = getElementInterior(v)
                                        local dim2 = getElementDimension(v)
                                        if int == int2 and dim == dim2 then
                                            if source and isElement(source) and getElementType(source) == "player" then
                                                local tag = (getElementData(source, 'JOAO.myTag') or false)
                                                if tag ~= false then
                                                    outputChatBox("("..formattedTime..") "..config["Cores"].Local.."*LOCAL » #ffffff"..aclSource[1].." "..config["Cores"].Local.."["..tag.."] #FFFFFF"..string.gsub(removeHex(getPlayerName(source)), '_', ' ').." ("..ID..")#FFFFFF: "..config["Cores"].Local..""..msgSemCor, v, 255, 255, 255, true) 
                                                else
                                                    outputChatBox("("..formattedTime..") "..config["Cores"].Local.."*LOCAL » #ffffff"..aclSource[1].." #FFFFFF"..string.gsub(removeHex(getPlayerName(source)), '_', ' ').." ("..ID..")#FFFFFF: "..config["Cores"].Local..""..msgSemCor, v, 255, 255, 255, true) 
                                                end
                                            end 
                                        end
                                    end
                                end 
                            end 
                        end 
                        exports["guetto_util"]:messageDiscord("("..formattedTime..") O jogador(a) "..(exports["guetto_util"]:puxarNome(source)).." ("..(exports["guetto_util"]:puxarID(source))..") enviou no **LOCAL**: "..msgSemCor.."", "https://discord.com/api/webhooks/1240195077653925889/xHMXWSb0mP_KrVAgChXevVsD3uM0BTlm3NiOPGxqC1Z_Ne0PQ3BpLRy-76qc48k5qI50")
                    end 
                end 
            end) 
        end
    end
end)

addCommandHandler("chat",
function(player)
    if (getElementData(player, "onProt") or false) then
        if isObjectInACLGroup("user."..getAccountName(getPlayerAccount(player)), aclGetGroup(config["ACL Limpar Chat"])) then
            for _, v in ipairs(getElementsByType("player")) do
                if v and isElement(v) and getElementType(v) == "player" then
                    clearChatBox()
                    setTimer(function(v)
                        if v and isElement(v) and getElementType(v) == "player" and player and isElement(player) and getElementType(player) == "player" then
                            outputChatBox("#C19F72[GUETTO] #FFFFFFChat limpo com sucesso por: "..getPlayerName(player), v, 255, 255, 255, true)
                        end 
                    end, 300, 1, v)
                    exports["guetto_util"]:messageDiscord("O jogador(a) "..(exports["guetto_util"]:puxarNome(player)).." ("..(exports["guetto_util"]:puxarID(player))..") Limpou o chat da cidade!", "https://discord.com/api/webhooks/1240195264178950245/JLrVQ9rW3sZDC1ee19zMkngToaumbzqcQUgHMbO7nHwKOFGI_OoYz8aQiCG9-OqKcKhN")
                end 
            end
        end
    end 
end)

addEventHandler("onPlayerLogin", root,  
function() 
    bindKey(source, config["Binds"].Twitter, "down", "chatbox", "Twitter")
    bindKey(source, config["Binds"].ForaRP, "down", "chatbox", "ForaRP")
    bindKey(source, config["Binds"].Anonimo, "down", "chatbox", "Anonimo")
end)

addEventHandler("onResourceStart", getResourceRootElement(getThisResource()),
function()
    Async:foreach(getElementsByType('player'), true, function(v) 
        if v and isElement(v) and getElementType(v) == "player" then
            local contaJogador = getPlayerAccount(v)
            if not isGuestAccount(contaJogador) then
                bindKey(v, config["Binds"].Twitter, "down", "chatbox", "Twitter")
                bindKey(v, config["Binds"].ForaRP, "down", "chatbox", "ForaRP")
                bindKey(v, config["Binds"].Anonimo, "down", "chatbox", "Anonimo")
            end
        end 
    end) 
end)