function registerEvent(event, element, callback)
    addEvent(event, true)
    addEventHandler(event, element, callback)
end

function convertNumber(amount)
    local left, center, right = string.match(math.floor(amount), '^([^%d]*%d)(%d*)(.-)$')
    return left .. string.reverse(string.gsub(string.reverse(center), '(%d%d%d)', '%1.')) .. right
end

_getPlayerName = getPlayerName;
function getPlayerName(element)
    return _getPlayerName(element):gsub("#%x%x%x%x%x%x", "") or _getPlayerName(element);
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

function isPlayerInACL(player, acl)
	if (isElement(player)) and (getElementType(player) == 'player') and (aclGetGroup(acl)) and (not isGuestAccount(getPlayerAccount(player))) then
		local account = getPlayerAccount(player)
		return isObjectInACLGroup('user.'..getAccountName(account), aclGetGroup(acl))
	end
	return false
end

function formatTime(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local remainingSeconds = seconds % 60

    return string.format("%02d horas %02d minutos %02d segundos", hours, minutes, remainingSeconds)
end

function pullName(player)
    return removeHex(getPlayerName(player))
end

function pullID(player)
    return (getElementData(player, "ID") or "N/A")
end

function pullAccount(player)
    return getAccountName(getPlayerAccount(player))
end

function messageDiscord(message, theWebhook)
	sendOptions = {
		queueName = "dcq",
		connectionAttempts = 3,
		connectTimeout = 5000,
		formFields = {
		  content="```"..message.."```"
		},
	}   
	fetchRemote(theWebhook, sendOptions, function()end)
end