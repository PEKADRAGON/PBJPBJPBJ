local Blip = {}
local TimerBlip = {}
local TimerProposta = {}
local timermoney = {}
local qntdademoney = {}
--local blip_radar = createBlip( 2349.576, 25.352, 26.484, 16 )
Noieiros = {}

setTimer(function()
    for i, v in ipairs(config['Peds']) do
        Noieiros[i] = createPed(v[4], v[1], v[2], v[3], v[5])
        setElementFrozen(Noieiros[i], true)
    end
    triggerClientEvent("MeloSCR:CancelDamage", getRootElement(), Noieiros)
end, 2000, 1)

addEventHandler("onPlayerLogin", root, 
function ()
    triggerClientEvent(source, "MeloSCR:CancelDamage", source, Noieiros)
end)

function sellDrugs(player, ped)
    local Maconha = exports['guetto_inventory']:getItem(player, 96)
    local Cocaina = exports['guetto_inventory']:getItem(player, 124)
    if Maconha == 0 and Cocaina == 0 then  
        message(player, 'Você não possui drogas para ser vendidas!', 'error')
    else
        if not TimerProposta[ped] or not isTimer(TimerProposta[ped]) then 
            TimerProposta[ped] = setTimer(function () end, 2000, 1)
            local chance = math.random(1, 3)
            ContagemPM = 0
            for i,v in ipairs(getElementsByType("player")) do 
                if getElementData(v, "service.police") then 
                    ContagemPM = ContagemPM + 1 
                end 
            end  
            if chance == 2 then
                if ContagemPM < 2 then 
                    message(player, 'Precisa de policais online para vender drogas!', 'error')
                else
                    message(player, 'Proposta feita, aguardando resposta.', 'info')
                    setTimer(function()
                        local Maconha = exports['guetto_inventory']:getItem(player, 96)
                        local Cocaina = exports['guetto_inventory']:getItem(player, 124)
                        ContagemPM = 0 
                        ValorDrogaAtual = 0   
                        if ContagemPM <= 2 then
                            ValorDrogaAtual = math.random(2000, 6000)
                        else 
                            for i,v in ipairs(config['Geral'].ValoresDroga) do 
                                if ContagemPM >= v[2] then 
                                    ValorDrogaAtual = math.random(2000, 6000)
                                end 
                            end 
                        end 
                        
                       --[[
                        if lsd > 0 then 
                            --exports['guetto_inventory']:giveItem(player, 100, ValorDrogaAtual)
                            --exports['guetto_inventory']:takeItem(player, 25, 1)
                            messageDiscord("O jogador(a) "..getPlayerName(player).."("..(getElementData(player, 'ID') or 'N/A')..") vendeu 1x maconha para a cracolândia!", "https://discord.com/api/webhooks/1051781020233506826/E4s6wnhY4swN3sNp2vGeGB73p3CAqWT9zRf8XqrpmNMKtXdy4NWWeoGwMaIX8Pdir7rx")
                            message(player, 'Você acabou de vender um pacote de lsd por R$'..formatNumber(ValorDrogaAtual)..' para este Noieiro.', 'success')
                            triggerEvent("MeloSCR:addLogsGroup", player, player, "O jogador(a) "..getPlayerName(player).." vendeu um pacote de lsd ", "Drogas", 1, 0)
                            local exp = (getElementData(player, "XP") or 0)
                            setElementData(player, "XP", exp+5)
                        end 
                        if Cristal > 0 then 
                            exports['guetto_inventory']:giveItem(player, 100, ValorDrogaAtual)
                            exports['guetto_inventory']:takeItem(player, 24, 1)
                            messageDiscord("O jogador(a) "..getPlayerName(player).."("..(getElementData(player, 'ID') or 'N/A')..") vendeu 1x cocaina para a cracolândia!", "https://discord.com/api/webhooks/1051781020233506826/E4s6wnhY4swN3sNp2vGeGB73p3CAqWT9zRf8XqrpmNMKtXdy4NWWeoGwMaIX8Pdir7rx")
                            message(player, 'Você acabou de vender um pacote de cristal por R$'..formatNumber(ValorDrogaAtual)..' para este Noieiro.', 'success')
                            triggerEvent("MeloSCR:addLogsGroup", player, player, "O jogador(a) "..getPlayerName(player).." vendeu um pacote de cristal ", "Drogas", 1, 0)
                            local exp = (getElementData(player, "XP") or 0)
                            setElementData(player, "XP", exp+5)
                        end
                       ]]
                        if Maconha > 0 then 
                            exports['guetto_inventory']:giveItem(player, 100, ValorDrogaAtual)
                            exports['guetto_inventory']:takeItem(player, 96, 1)
                            messageDiscord("O jogador(a) "..getPlayerName(player).."("..(getElementData(player, 'ID') or 'N/A')..") vendeu 1x maconha para a cracolândia!", "https://discord.com/api/webhooks/1051781020233506826/E4s6wnhY4swN3sNp2vGeGB73p3CAqWT9zRf8XqrpmNMKtXdy4NWWeoGwMaIX8Pdir7rx")
                            message(player, 'Você acabou de vender um pacote de maconha por R$'..formatNumber(ValorDrogaAtual)..' para este Noieiro.', 'success')
                            triggerEvent("MeloSCR:addLogsGroup", player, player, "O jogador(a) "..getPlayerName(player).." vendeu um pacote de maconha ", "Drogas", 1, 0)
                            local exp = (getElementData(player, "XP") or 0)
                            setElementData(player, "XP", exp+5)
                        end 
                        if Cocaina > 0 then 
                            exports['guetto_inventory']:giveItem(player, 100, ValorDrogaAtual)
                            exports['guetto_inventory']:takeItem(player, 124, 1)
                            messageDiscord("O jogador(a) "..getPlayerName(player).."("..(getElementData(player, 'ID') or 'N/A')..") vendeu 1x maconha para a cracolândia!", "https://discord.com/api/webhooks/1051781020233506826/E4s6wnhY4swN3sNp2vGeGB73p3CAqWT9zRf8XqrpmNMKtXdy4NWWeoGwMaIX8Pdir7rx")
                            message(player, 'Você acabou de vender um pacote de cocaina por R$'..formatNumber(ValorDrogaAtual)..' para este Noieiro.', 'success')
                            triggerEvent("MeloSCR:addLogsGroup", player, player, "O jogador(a) "..getPlayerName(player).." vendeu um pacote de cocaina ", "Drogas", 1, 0)
                            local exp = (getElementData(player, "XP") or 0)
                            setElementData(player, "XP", exp+5)
                        end 

                        timermoney[player] = setTimer(function() message(player, 'Agora você pode se desconectar da cidade sem perder seu dinheiro sujo.', 'info') end, 5*60000, 1)
                        qntdademoney[player] = ValorDrogaAtual
                        setElementData(ped, "MeloSCR:DelayVenderDrogas", true)
                        setTimer(setElementData, config['Geral'].DelayVender*1000, 1, ped, "MeloSCR:DelayVenderDrogas", false)
                        setPedAnimation(ped, "crack", "crckidle4", -1)

                        setTimer(function(ped)
                            setPedAnimation(ped, nil)
                        end, config['Geral'].Levantar*1000, 1, ped)


                    end, 2000, 1) 
                end
            else
                ContagemPM = 0
                for i,v in ipairs(getElementsByType("player")) do 
                    if getElementData(v, "service.police") then 
                        ContagemPM = ContagemPM + 1 
                    end 
                end    
                    if ContagemPM < 2 then 
                        message(player, 'Precisa de +1 policais online para vender drogas!', 'error')
                    else
                        message(player, 'Proposta feita, aguardando resposta.', 'info')
                        setTimer(function()
                        message(player, 'Este Noieiro não aceitou a sua ofeta e acabou de chamar a polícia.', 'error')
                        Blip[player] = createBlipAttachedTo(ped, config['Geral'].Blip)
                        exports["guetto_util"]:messageDiscord("O jogador(a) "..(exports["guetto_util"]:puxarNome(player)).." ("..(exports["guetto_util"]:puxarID(player))..") está vendendo drogas na cracolandia!", "https://discord.com/api/webhooks/1051781020233506826/E4s6wnhY4swN3sNp2vGeGB73p3CAqWT9zRf8XqrpmNMKtXdy4NWWeoGwMaIX8Pdir7rx")
                        setElementVisibleTo(Blip[player], root, false)
                        for _, policial in ipairs(getElementsByType('player')) do 
                            if isPlayerPm(policial) then 
                                outputChatBox('Um jogador está vendendo drogas na cracolandia! (Marcado no mapa em roxo)', policial, 255, 255, 255, true)
                                setElementVisibleTo(Blip[player], policial, true)
                                TimerBlip[player] = setTimer(function(blip2)
                                    if isElement(blip2) then
                                        destroyElement(blip2)
                                    end
                                end, 3*60000, 1, Blip[player])
                            end
                        end
                    end, 2000, 1)
                end
            end
        else 
            message(player, 'Este ped ja está em uma negociação.', 'error')
        end 
	end
end
addEvent('Schootz.venderDrogas', true)
addEventHandler('Schootz.venderDrogas', getRootElement(), sellDrugs)


addEventHandler('onPlayerQuit', root, function ()
    if isTimer(timermoney[source]) then
        local sujo = exports['guetto_inventory']:getItem(source, 100)
        if qntdademoney[source] and sujo >= tonumber(qntdademoney[source]) then
            exports['guetto_inventory']:takeItem(source, 100, qntdademoney[source])
        else
            exports['guetto_inventory']:takeItem(source, 100, sujo)
        end
    end
end)

-- Funçoes uteis --

function onQuit(player)
    if isElement(Blip[player]) then destroyElement(Blip[player]) end
end
addEventHandler('onPlayerQuit', root, onQuit)

function isPlayerPm(player) 
    for _, acl in ipairs(config['ACLs']) do 
        if isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(player)), aclGetGroup(acl)) then 
            return true 
        end
    end
    return false
end

function formatNumber(number)
	return string.gsub(number, '^(-?%d+)(%d%d%d)', '%1.%2')
end

function message(player, text, type)
   return exports['guetto_notify']:showInfobox(player, type, text)
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