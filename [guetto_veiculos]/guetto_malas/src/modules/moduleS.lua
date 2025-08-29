function getPlayerAcl (player, acl)
    
    if not player or not isElement(player) then 
        return false;
    end;

    if not acl then 
        return false;
    end;

    if not aclGetGroup(acl) then 
        return print ( "Error: Group not found" );
    end;

    local accountName = getAccountName(getPlayerAccount(player));

    if (isObjectInACLGroup('user.'..accountName, aclGetGroup(acl))) then 
        return true 
    end;

    return false
end;

function getPlayerByID (id)
    local result = false;
    if id then 
        for i, v in ipairs(getElementsByType('player')) do 
            if getElementData(v, 'ID') == tonumber(id) then 
                result = v
            end
        end
    end
    return result
end
