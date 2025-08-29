--[[

██╗░░░██╗░█████╗░███╗░░██╗███████╗░██████╗░██████╗░█████╗░  ░██████╗░█████╗░██████╗░
██║░░░██║██╔══██╗████╗░██║██╔════╝██╔════╝██╔════╝██╔══██╗  ██╔════╝██╔══██╗██╔══██╗
╚██╗░██╔╝███████║██╔██╗██║█████╗░░╚█████╗░╚█████╗░███████║  ╚█████╗░██║░░╚═╝██████╔╝
░╚████╔╝░██╔══██║██║╚████║██╔══╝░░░╚═══██╗░╚═══██╗██╔══██║  ░╚═══██╗██║░░██╗██╔══██╗
░░╚██╔╝░░██║░░██║██║░╚███║███████╗██████╔╝██████╔╝██║░░██║  ██████╔╝╚█████╔╝██║░░██║
░░░╚═╝░░░╚═╝░░╚═╝╚═╝░░╚══╝╚══════╝╚═════╝░╚═════╝░╚═╝░░╚═╝  ╚═════╝░░╚════╝░╚═╝░░╚═╝

- Todos os direitos reservados a FiveShop.

- E tudo quanto fizerdes, seja por meio de palavras ou ações, fazei em o Nome do Senhor Jesus, oferecendo por intermédio dele graças a Deus Pai.
]]--

local registerEvent = function(eventName, element, func)
	addEvent(eventName, true)
	addEventHandler(eventName, element, func)
end

registerEvent("NS:Sminer", root, function()
    setPedAnimation(source, "baseball", "bat_4", -1, false)
    local x, y, z = getElementPosition(source)
    triggerClientEvent(root, "sarp_miningC:playMiningSound", source)
end)

registerEvent("NS:STminer", root, function()
  setPedAnimation(source)
end)

registerEvent("onStartMinerador", resourceRoot, function()
  if not client then 
    return false 
  end
  giveWeapon(client, 6)
end)

registerEvent("NS:Giveore", resourceRoot, function(itemID)

    if not (client) then 
        return false 
    end 

    if (source ~= resourceRoot) then 
        return false 
    end

    local player = client;

    if itemID == 56 then 
        givePlayerMoney(player,Confg["precos"]["Bronze"][1])
        sendMessageServer(source,"success","Você minerou um carvão e ganhou R$"..Confg["precos"]["Bronze"][1].."", "info")
    elseif itemID == 58 then 
        givePlayerMoney(player,Confg["precos"]["Ouro"][1])
        sendMessageServer(source,"success","Você minerou um ouro e ganhou R$"..Confg["precos"]["Ouro"][1].."", "info")
    elseif itemID == 55 then 
        givePlayerMoney(player,Confg["precos"]["Diamante"][1])
        sendMessageServer(source,"success","Você minerou um Diamante e ganhou R$"..Confg["precos"]["Diamante"][1].."", "info")
    end

    local xp = math.random(500, 700)
    local exp = (getElementData(player, "XP") or 0);
    local isVip = exports["guetto_util"]:isPlayerVip(player)

    if isVip then 
        setElementData(player, "XP", exp + (xp * 2))
        sendMessageServer(source,"success"," Você recebeu o dobro de XP por ser vip!", "info")
    else
        setElementData(player, "XP", exp + xp)
    end


end)

function InfoTrab(playerSource)
  local emprego = getElementData(playerSource, "Emprego") or "Desempregado"
  if emprego == "Mineirador" then
        message(playerSource, "Siga a marcação em sua tela para chegar no seu local de trabalho", "info")
        triggerClientEvent(playerSource, "togglePoint", playerSource, Confg["posped"][1],Confg["posped"][2],Confg["posped"][3])
    end
end
addCommandHandler("trabalho", InfoTrab)
