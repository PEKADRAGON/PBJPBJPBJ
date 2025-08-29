function getPlayerPermissionCard(player)
    if player and isElement(player) then
        local accountName = getAccountName(getPlayerAccount(player))
        for i, v in ipairs(config.banners) do
            if v.type == "acl" and aclGetGroup(v.group) then
                if isObjectInACLGroup("user." .. accountName, aclGetGroup(v.group)) then
                    return i
                end
            end
        end
    end
    return false
end

function getPlayerDataCard(player)
    if player and isElement(player) then
        for i, v in ipairs(config.banners) do
            if v.type == "elementData" and getElementData(player, v.group) then
                return i
            end
        end
    end
    return false
end