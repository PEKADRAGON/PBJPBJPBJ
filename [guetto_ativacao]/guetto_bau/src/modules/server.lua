function getPlayerAcl ( player, acl )
    if player and isElement(player) and getElementType(player) == 'player' then 
        local account = getAccountName(getPlayerAccount(player))
        if (aclGetGroup(acl)) then 
            if (isObjectInACLGroup("user."..account, aclGetGroup(acl))) then 
                return true 
            end
        end
    end
    return false
end