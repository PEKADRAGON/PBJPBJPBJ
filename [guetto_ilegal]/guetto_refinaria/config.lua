config = {
    ["Others"] = {
        ["TimeFactory"] = 10000;
    };
    ["Drogas"] = {
        ["coccaine"] = {
            ["DrogaNecessaria"] = 123;
            ["DrogaRecebe"] = 118;
        };
        ["marihuana"] = {
            ["DrogaNecessaria"] = 120;
            ["DrogaRecebe"] = 156;
        };
    };
    ["Markers"] = {
        {2526.594, -1673.897, 14.851, 'DPZ'};
        {2664.525, -768.185, 92.935, 'TDF'};
        {1913.569, 171.237, 37.228, 'YKZ'};
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

