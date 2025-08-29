config = {

    ["Blindagem"] = 40;

    ["Posicoes"] = {
        {848.633, -1697.937, 13.617, 'MOTOCLUB'};
        {1014.765, -1014.559, 32.105, 'MEC'};
       -- {-480.062, -514.841, 25.523, 'Console'};
    };

    ["Modelos"] = {
        ["Default"] = 250000;
        --[411] = 1000;
    };

}

sendMessageServer = function (player, msg, type)
    return exports['guetto_notify']:showInfobox(player, type, msg)
end;

sendMessageClient = function (msg, type)
    return exports['guetto_notify']:showInfobox(type, msg)
end;

function createEvent(event, ...)
    addEvent(event, true)
    addEventHandler(event, ...)
end

function isPlayerHavePermission (player, acl)
    if not (player) then 
        return false 
    end

    local result = false;
    local account = getAccountName(getPlayerAccount(player))

    if (type(acl) == 'table') then 
        for i, v in pairs (acl) do 
            if (isObjectInACLGroup('user.'..account, aclGetGroup(v))) then 
                result = true 
            end
        end 
    elseif (type(acl) == 'string') then 
        if (isObjectInACLGroup('user.'..account, aclGetGroup(acl))) then 
            result = true 
        end
    end

    return result
end

function formatNumber(number, sep)
	assert(type(tonumber(number))=="number", "Bad argument @'formatNumber' [Expected number at argument 1 got "..type(number).."]")
	assert(not sep or type(sep)=="string", "Bad argument @'formatNumber' [Expected string at argument 2 got "..type(sep).."]")
	sep = sep or '.'
	local money = number
	for i = 1, tostring(money):len()/3 do
		money = string.gsub(money, "^(-?%d+)(%d%d%d)", "%1"..sep.."%2")
	end
	return money
end