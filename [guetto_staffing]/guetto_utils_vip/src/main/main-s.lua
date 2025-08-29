function getPlayerVip (player)
    if not (player or not isElement(player)) then 
        return false 
    end;
    local account = getAccountName (getPlayerAccount(player))
    for i, v in ipairs(config["Vips"]) do 
        if aclGetGroup(v["acl"]) then 
            if (isObjectInACLGroup("user."..account, aclGetGroup(v["acl"]))) then 
                return true, i
            end
        else
            print ("Guetto Utils | Acl "..v["acl"].. " não está criada")
        end
    end
    return false
end

setTimer(function()
    for _, player in ipairs (getElementsByType("player")) do 
        local bool, index = getPlayerVip(player)
        if (bool) then 
            local data = config["Vips"][index]
            local message = "Você acaba de receber seu salário VIP no valor de R$ " .. formatNumber(tonumber(data["money"]), ".") .. ". Agradecemos imensamente por sua colaboração e dedicação."
            givePlayerMoney(player, data["money"])
            sendMessageServer(player, message, "info")
        end
    end
end, config["Timers"]["Salario Vip"], 0)