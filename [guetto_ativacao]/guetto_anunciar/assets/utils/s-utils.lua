_getPlayerName = getPlayerName;
function getPlayerName(element)
    return _getPlayerName(element):gsub("#%x%x%x%x%x%x", "") or _getPlayerName(element);
end

function isPlayerInACL(player)
    for i, v in ipairs(config["gerais"]["permissions"]) do
        if aclGetGroup(v) and isObjectInACLGroup("user."..getAccountName(getPlayerAccount(player)), aclGetGroup(v)) then
            return true
        end
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