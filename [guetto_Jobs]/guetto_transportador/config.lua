config = {
    
    ["Peds"] = {
        {
            ["Skin"] = 113;
            ["Posição"] = {2186.401, -2254.277, 13.42};
            ["Rotação"] = {0, 0, 220.447};
            ["Veiculo"] = {498, 2203.374, -2250.579, 13.547, 0, 0, 321.49};
            ["Devolver"] = {2508.68, -2116.152, 13.547};
        }
    };
    
    ["Destinos"] = {

        --=-=-=-=-=-=-=-=-=-=-Los Santos -=-=-=-=-=-=-=-=-=-=-
        {
            ["Posição"] = {2354.175, -1512.37, 24};
            ["Pagamento"] = 900;
        };


        {
            ["Posição"] = {1024.18, -982.958, 42.645};
            ["Pagamento"] = 1300;
        };

        {
            ["Posição"] = {952.673, -910.534, 45.766};
            ["Pagamento"] = 1300;
        };

        --=-=-=-=-=-=-=-=-=-=-Las Venturas -=-=-=-=-=-=-=-=-=-=-

        {
            ["Posição"] = {2396.729, 690.959, 11.453};
            ["Pagamento"] = 2300;
        };

        {
            ["Posição"] = {1912.002, 664.358, 10.82};
            ["Pagamento"] = 1900;
        };

        {
            ["Posição"] = {2019.764, 1913.28, 12.313};
            ["Pagamento"] = 2400;
        };
        
        --=-=-=-=-=-=-=-=-=-=-San Fierro -=-=-=-=-=-=-=-=-=-=-

        {
            ["Posição"] = {-2170.592, 252.084, 35.335};
            ["Pagamento"] = 2800;
        };

        {
            ["Posição"] = {-2461.559, 133.461, 35.172};
            ["Pagamento"] = 3200;
        };

        {
            ["Posição"] = {-2720.017, -317.944, 7.844};
            ["Pagamento"] = 4000;
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

function metrosParaMinutos(distancia, velocidade)
    if velocidade <= 0 then
        return 0
    end

    local tempoEmMinutos = distancia / velocidade
    return tempoEmMinutos
end