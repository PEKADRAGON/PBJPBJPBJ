config = {
    
    ["Peds"] = {
        {
            ["Skin"] = 258;
            ["Posição"] = {735.782, -1259.674, 13.639};
            ["Rotação"] = {0, 0, 180.434}
        }
    };
    
    ["Empregos"] = {
        {
            ["Nome"] = "Transportador",
            ["Level"] = 0;
            ["Posição"] = {2187.029, -2253.757, 13.431};
        };
        {
            ["Nome"] = "Ifood",
            ["Level"] = 0;
            ["Posição"] = {2103.431, -1807.171, 13.555};
        };
        {
            ["Nome"] = "Pedreiro",  
            ["Level"] = 5;
            ["Posição"] = {1268.638, -1269.426, 13.492};
        };
        {
            ["Nome"] = "Sedex",
            ["Level"] = 10;
            ["Posição"] = {919.453, -1251.859, 16.211};
        };
        {
            ["Nome"] = "Pescador",
            ["Level"] = 15;
            ["Posição"] = {154.212, -1942.274, 3.773};
        };
        {
            ["Nome"] = "Cortador de grama",
            ["Level"] = 20;
            ["Posição"] = {-112.383, 53.109, 3.117};
        };
        {
            ["Nome"] = "Montadora",
            ["Level"] = 30;
            ["Posição"] = {1833.016, -1125.637, 24.68};
        };
        {
            ["Nome"] = "Lenhador",
            ["Level"] = 35;
            ["Posição"] = {-1061.057, -1192.168, 129.219};
        };
        {
            ["Nome"] = "Minerador",
            ["Level"] = 50;
            ["Posição"] = {-826.30041503906, -1898.1466064453, 11.811317443848};
        };
        
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


function generateKeyEncrypt ( )
    local letters = {"A", "a", "B", "c", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"}
    local str = ''

    for index = 1, 10 do  
        local random = math.random(1, #letters)
        str = str..letters[random]
    end

    return str
end
