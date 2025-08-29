config = {
    
    ["Timers"] = {
        ["Salario Vip"] = 30 * 60000 -- Tempo do salario vip (30 minutos)
    };

    ["Vips"] = {
        {
            acl = "Visionário", -- Acl do vip
            money = 30000, -- Dinheiro que recebe a cada x tempo
            xp  = 2 -- Quantidade de xp que vai mutiplicar nos empregos
        }
    };

}

sendMessageServer = function (player, msg, type)
    return exports['guetto_notify']:showInfobox(player, type, msg)
end;
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