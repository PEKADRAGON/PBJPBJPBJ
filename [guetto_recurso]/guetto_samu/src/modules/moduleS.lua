function getPlayerVip ( player )
    local r = false; 
    for i, v in ipairs(config["Vips"]) do 
        local account = getAccountName(getPlayerAccount(player))
        if isObjectInACLGroup("user."..account, aclGetGroup(v)) then 
            r = true 
        end
    end
    return r
end

function getPlayerSamu (  )
    local c = 0;

    for i, v in ipairs(getElementsByType('player')) do 
        if getElementData(v, config["Datas"]["Samu"]) then 
            c = c + 1
        end
    end

    return c
end;

function getPlayerByID ( id )

    local result = false 
    
    for i, v in ipairs(getElementsByType("player")) do 

        if getElementData(v, "ID") == tonumber(id) then 

            result = v 

        end

    end

    return result
end;