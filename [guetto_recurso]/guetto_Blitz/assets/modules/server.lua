function isPlayerInACL(player, acl)
	if (isElement(player)) and (getElementType(player) == 'player') and (aclGetGroup(acl)) and (not isGuestAccount(getPlayerAccount(player))) then
		local account = getPlayerAccount(player)
		return isObjectInACLGroup('user.'..getAccountName(account), aclGetGroup(acl))
	end
	return false
end

function getPlayerFromID(id)
    if tonumber(id) then
        for _, player in ipairs(getElementsByType('player')) do
            if getElementData(player, 'ID') and (getElementData(player, 'ID') == tonumber(id)) then
                return player
            end
        end
    end
    return false
end

function registerEvent(event, element, callback)
    addEvent(event, true)
    addEventHandler(event, element, callback)
end