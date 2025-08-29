function removeHex(s)
    local g, c = string.gsub, 0
    repeat
        s, c = g(s, '#%x%x%x%x%x%x', '')
    until c == 0
    return s
end

function getPlayerFromID (id)
    if not id then 
        return false 
    end
    
    local r = false 
    local id = tonumber(id)

    for _, player in ipairs(getElementsByType('player')) do 
        if getElementData(player, 'ID') == id then 
            r = player 
        end
    end
    
    return r 
end


function getPlayerAcl ( player, acl )
    if not (player or not isElement(player)) then 
        return false 
    end
    if not acl then 
        return false 
    end
    local account = getAccountName(getPlayerAccount(player))
    if type(acl) == 'string' then 
        if isObjectInACLGroup("user."..account, aclGetGroup(acl)) then
            return true, acl
        end
    elseif type(acl) == 'table' then 
        for _, group in ipairs(acl) do
            if isObjectInACLGroup("user."..account, aclGetGroup(group)) then
                return true, group
            end
        end
    end
    return false
end