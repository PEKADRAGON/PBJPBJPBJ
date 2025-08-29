
config = {

    ["Others"] = {
        ["item"] = 91;
        ["time"] = 5 * 60000;
        ["dinheiroSujo"] = 100;
    };

    ["BlackList"] = {
        [522] = true,
        [523] = true
    };

    ["Locations"] = { -- Posições para iniciar a corrida
        {2809.77686, 1313.17126, 10.75000 - 1, 'cylinder', 15, 139, 255, 100, 10, destiny = {1660.10852, -2684.80225, 5.86719 - 1, 'cylinder', 5, 139, 255, 100, 100}, reward = {25000, 100000}};
        {2600.63550, -2447.29712, 13.62408 - 1, 'cylinder', 15, 139, 255, 100, 10, destiny = {1593.80566, 1582.29419, 10.82031 - 1, 'cylinder', 5, 139, 255, 100, 100}, reward = {25000, 100000}};
    };

	sendMessageServer = function (player, msg, type)
        return exports['guetto_notify']:showInfobox(player, type, msg)
    end;

    sendMessageClient = function (msg, type)
        return exports['guetto_notify']:showInfobox(type, msg)
    end;

}

function registerEventHandler ( event, ... )
    addEvent( event, true )
    addEventHandler( event, ... )
end;

function removeHex (s)
    return s:gsub ("#%x%x%x%x%x%x", "") or false
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