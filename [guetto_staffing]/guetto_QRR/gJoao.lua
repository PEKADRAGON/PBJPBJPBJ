--##################################
--## Script feito por zJoaoFtw_   ##
--## Design feito por JC          ##
--##################################

config = {
    ["Mensagem Start"] = true, --Caso esteja false ele não irá aparecer a mensagem!
    ["ElementData"] = "service.police", --Elementdata de serviço PM
    ["ID Blip"] = 1, --ID do Blip que cria
    ["ACL"] = "Corporação", --ACL para verificar quem está executando o comando
}

formatNumber = function(number)   
    local formatted = number   
    while true do       
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2')     
        if ( k==0 ) then       
            break   
        end   
    end   
    return formatted 
end 

notifyS = function(player, message, type)
   return exports['guetto_notify']:showInfobox(player, type, message)
end

notifyC = function(message, type)
    return exports['guetto_notify']:showInfobox(type, message)
end

function removeHex(message)
	if (type(message) == "string") then
		while (message ~= message:gsub("#%x%x%x%x%x%x", "")) do
			message = message:gsub("#%x%x%x%x%x%x", "")
		end
	end
	return message or false
end

function puxarNome(player)
    return removeHex(getPlayerName(player))
end

function puxarID(player)
    return (getElementData(player, "ID") or 0)
end