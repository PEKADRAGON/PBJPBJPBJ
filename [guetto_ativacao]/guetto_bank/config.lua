RANDOM_QUANT = {20000, 25000}

config = {

    ["assault"] = {
        ["time"] = 5; -- tempo da quest
        ["item"] = 70; -- Id do item necessiaro para roubar
        ["dinheiroSujo"] = 26; -- Id do dinheiro sujo no inv 
        ["recuperar"] = 10; -- tempo pro caixa recuperar
        ["letters"] = {"3", "H", "A", "Z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"}

    };

    ["positions"] = {

        {1796.412, -1646.081, 14.49 - 0.30, -0, 0, 90};
        {2404.431, -1984.835, 13.547 - 0.30, -0, 0, 90};
        {1486.898, -1582.611, 13.547 - 0.30, -0, 0, 0};
        {544.68, -1296.604, 17.256 - 0.30, -0, 0, 0};
        
    };

    sendMessageClient = function (msg, type)
        return exports['guetto_notify']:showInfobox(type, msg)
    end;
 
    sendMessageServer = function (player, msg, type)
        return exports['guetto_notify']:showInfobox(player, type, msg)
    end;

}

function removeHex (s)
    return s:gsub ("#%x%x%x%x%x%x", "") or false
end

_getPlayerName = getPlayerName

function getPlayerName (player)
    if not player or not isElement(player) then 
        return false;
    end;
    return removeHex(_getPlayerName(player))
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
