local killers = {}

addEventHandler('onPlayerWasted', root, function (_, killer)
    if killer and isElement(killer) then 
        if not (killers[getAccountName(getPlayerAccount(killer))]) then
            killers[getAccountName(getPlayerAccount(killer))] = {
                name = getPlayerName(killer);
                id = getElementData(killer, "ID") or "N/A";
                count = 0
            }
        end
    
        killers[getAccountName(getPlayerAccount(killer))].count = killers[getAccountName(getPlayerAccount(killer))].count + 1
    end
end)

addCommandHandler('vermortes', function ( player )
    local account = getAccountName(getPlayerAccount(player))
    if isObjectInACLGroup("user."..account, aclGetGroup("Console")) then 
        table.sort(killers, function(a, b) return a.count > b.count end)
        for k, v in pairs(killers) do
            local message = "O Jogador '" .. v.name .. "' com o ID '" .. v.id .. "' matou '" .. v.count .. "' vezes."
            outputChatBox(message, player, 255, 255, 255, true)
        end
    end
end)