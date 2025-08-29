function getPlayerByID ( id )
    local result = false;

    for i, v in ipairs(getElementsByType('player')) do 
        if (getElementData(v, 'ID') == tonumber(id)) then 
            result = v 
        end
    end;

    return result
end;


function getPlayerAcl ( player, acl )
    if player and isElement(player) then 
        if acl and aclGetGroup(acl) then 
            local account = getAccountName (getPlayerAccount(player))
            if isObjectInACLGroup('user.'..account, aclGetGroup(acl)) then 
                return true 
            end
        end
    end
    return false
end