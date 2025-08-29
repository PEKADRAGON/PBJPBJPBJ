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
    if not element or not isElement(element) or getElementType(element) ~= 'player' then 
        return false 
    end
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

function isPlayerInACL(player, table)
    for i, v in ipairs(table) do
        if aclGetGroup(v) and isObjectInACLGroup("user."..getAccountName(getPlayerAccount(player)), aclGetGroup(v)) then
            return true
        end
    end
    return false
end

function verifyACL(player, table)
    for i, v in ipairs(table) do
        if aclGetGroup(v) and isObjectInACLGroup("user."..getAccountName(getPlayerAccount(player)), aclGetGroup(v)) then
            return v
        end
    end
    return false
end

function getPlayerAcls(player)
    local acls = {}
    local account = getPlayerAccount(player)
    if not account or isGuestAccount(account) then
        return acls
    end

    local accountName = getAccountName(account)
    for _, group in ipairs(aclGroupList()) do
        if isObjectInACLGroup("user." .. accountName, group) then
            local groupName = aclGroupGetName(group)
            table.insert(acls, groupName)
        end
    end
    return acls
end

function removePlayerAcls (acc)
    local list = aclList()
    local accountName = acc
    if #list ~= 0 then 
        for i, v in ipairs(list) do 
            local aclName = aclGetName  (v)
            if (aclGetGroup(aclName)) then 
                if (isObjectInACLGroup('user.'..accountName, aclGetGroup(aclName))) then 
                    if aclName ~= 'Everyone' then 
                        aclGroupRemoveObject(aclGetGroup(aclName), 'user.'..accountName)
                    end
                end
            end
        end
    end
end

function formatTime(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local remainingSeconds = seconds % 60

    return string.format("%02d horas %02d minutos %02d segundos", hours, minutes, remainingSeconds)
end

function generateCode()
    local code = ""
    math.randomseed(os.time())

    for i = 1, 6 do 
        code = code ..tostring(math.random(0, 9))
    end
    
    return code
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