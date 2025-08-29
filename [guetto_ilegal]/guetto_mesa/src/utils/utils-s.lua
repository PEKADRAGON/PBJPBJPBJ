function isPlayerAcl (player, acl)
    if not (player) or not (acl) then
        return false
    end

    local account = getAccountName(getPlayerAccount(player))
    if type(acl) == 'string' then 
        if isObjectInACLGroup('user.' .. account, aclGetGroup(acl)) then
            return true
        end
    elseif type(acl) == 'table' then
        for i, v in ipairs(acl) do
            if isObjectInACLGroup('user.' .. account, aclGetGroup(v)) then
                return true
            end
        end
    end
    return false
end