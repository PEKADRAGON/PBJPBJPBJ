config = {
    
    ["Key"] = "f5";
    ["Delay_Itens"] = 10 * 60000;

    ["Vips"] = {
        ["Luxuria"] = {
            ["Salario"] = 500;
            ["Bonus_Ativação"] = 10000;

            ["Itens"] = {
                { ["Name"] = "Presente-do-Guh", ["Item"] = 27, ["Quantidade"] = 1 };
                { ["Name"] = "Kit-Medico 50%", ["Item"] = 24, ["Quantidade"] = 1 };
                { ["Name"] = "Deagle", ["Item"] = 63, ["Quantidade"] = 1 };
                { ["Name"] = "Munição 9mm", ["Item"] = 53, ["Quantidade"] = 200 };
            };

            ["Veículos"] = {
                { ["Name"] = "Hornet | Honda", ["Modelo"] = 461, ["Brand"] = "Honda" };  
            };

        };

        ["Criminoso"] = {
            ["Salario"] = 1000;
            ["Bonus_Ativação"] = 20000;
            
            ["Itens"] = {
                { ["Name"] = "Presente-do-Guh", ["Item"] = 27, ["Quantidade"] = 1 };
                { ["Name"] = "Kit-Medico 50%", ["Item"] = 24, ["Quantidade"] = 1 };
                { ["Name"] = "MP5", ["Item"] = 58, ["Quantidade"] = 1 };
                { ["Name"] = "Deagle", ["Item"] = 63, ["Quantidade"] = 1 };
                { ["Name"] = "Munição 9mm", ["Item"] = 53, ["Quantidade"] = 200 };
            };

            ["Veículos"] = {
                { ["Name"] = "XRE | Honda", ["Modelo"] = 468, ["Brand"] = "Honda" };  
            };
        };

        ["Visionário"] = {
            ["Salario"] = 2000;
            ["Bonus_Ativação"] = 30000;
            
            ["Itens"] = {
                { ["Name"] = "Presente-do-Matteo", ["Item"] = 26, ["Quantidade"] = 1 };
                { ["Name"] = "Kit-Medico 100%", ["Item"] = 25, ["Quantidade"] = 1 };
                { ["Name"] = "AK47", ["Item"] = 59, ["Quantidade"] = 1 };
                { ["Name"] = "Deagle", ["Item"] = 63, ["Quantidade"] = 1 };
                { ["Name"] = "Munição 9mm", ["Item"] = 53, ["Quantidade"] = 200 };
                { ["Name"] = "Munição 762", ["Item"] = 54, ["Quantidade"] = 200 };
            };

            ["Veículos"] = {

                { ["Name"] = "Lexus LS", ["Modelo"] = 547, ["Brand"] = "Toyota" }; 
                { ["Name"] = "R1200", ["Modelo"] = 586, ["Brand"] = "BMW" };  

            };
        };

        ["Marginal de grife"] = {
            ["Salario"] = 4000;
            ["Bonus_Ativação"] = 50000;
            
            ["Itens"] = {
                { ["Name"] = "Presente-do-Matteo", ["Item"] = 26, ["Quantidade"] = 1 };
                { ["Name"] = "Kit-Medico 100%", ["Item"] = 25, ["Quantidade"] = 1 };
                { ["Name"] = "AK47", ["Item"] = 59, ["Quantidade"] = 1 };
                { ["Name"] = "Deagle", ["Item"] = 63, ["Quantidade"] = 1 };
                { ["Name"] = "MP5", ["Item"] = 58, ["Quantidade"] = 1 };
                { ["Name"] = "Munição 9mm", ["Item"] = 53, ["Quantidade"] = 200 };
                { ["Name"] = "Munição 762", ["Item"] = 54, ["Quantidade"] = 200 };
                { ["Name"] = "JBL", ["Item"] = 33, ["Quantidade"] = 1 };
            };

            ["Veículos"] = {
                { ["Name"] = "Porshe panamera", ["Modelo"] = 529, ["Brand"] = "Porshe" }; 
                { ["Name"] = "R1200", ["Modelo"] = 586, ["Brand"] = "BMW" };   

            };
        };

    };
}

function encrypt ( )
    local str = ''
    local letters = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'}
    for i = 1, 10 do 
        local randonm = math.random(#letters)
        str = str..letters[randonm]
    end

    return str
end

sendMessageClient = function (msg, type)
    return exports['guetto_notify']:showInfobox(type, msg)
end;

sendMessageServer = function (player, msg, type)
    return exports['guetto_notify']:showInfobox(player, type, msg)
end;

function getPlayerVipRestant (player, vip)
    return "N/A"
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