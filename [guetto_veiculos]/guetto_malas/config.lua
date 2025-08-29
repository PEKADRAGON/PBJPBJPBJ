config = {

    ["Blacklist"] = {
        [522] = true;
    };

    ["Pesos"] = {
        ["default"] = 50;

       ["custom"] = {
            [411] = 100;
        };

    };

    sendMessageServer = function (player, msg, type)
        return exports['guetto_notify']:showInfobox(player, type, msg)
    end;

    sendMessageClient = function (msg, type)
        return exports['guetto_notify']:showInfobox(type, msg)
    end;

}

function removeHex (s)
    return s:gsub ("#%x%x%x%x%x%x", "") or false
end

function registerEventHandler ( event, ... )
    addEvent( event, true )
    addEventHandler( event, ... )
end;

function formatNumber(number, sep)
	assert(type(tonumber(number))=="number", "Bad argument @'formatNumber' [Expected number at argument 1 got "..type(number).."]")
	assert(not sep or type(sep)=="string", "Bad argument @'formatNumber' [Expected string at argument 2 got "..type(sep).."]")
	local money = number
	for i = 1, tostring(money):len()/3 do
		money = string.gsub(money, "^(-?%d+)(%d%d%d)", "%1"..sep.."%2")
	end
	return money
end