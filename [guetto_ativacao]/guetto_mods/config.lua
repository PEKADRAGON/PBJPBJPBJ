--[[

    ___      ___ ___  ________  ___  ________  ________           ________  ________  ________  _______   ________      
    |\  \    /  /|\  \|\   ____\|\  \|\   __  \|\   ___  \        |\   ____\|\   __  \|\   ___ \|\  ___ \ |\   ____\     
    \ \  \  /  / | \  \ \  \___|\ \  \ \  \|\  \ \  \\ \  \       \ \  \___|\ \  \|\  \ \  \_|\ \ \   __/|\ \  \___|_    
     \ \  \/  / / \ \  \ \_____  \ \  \ \  \\\  \ \  \\ \  \       \ \  \    \ \  \\\  \ \  \ \\ \ \  \_|/_\ \_____  \   
      \ \    / /   \ \  \|____|\  \ \  \ \  \\\  \ \  \\ \  \       \ \  \____\ \  \\\  \ \  \_\\ \ \  \_|\ \|____|\  \  
       \ \__/ /     \ \__\____\_\  \ \__\ \_______\ \__\\ \__\       \ \_______\ \_______\ \_______\ \_______\____\_\  \ 
        \|__|/       \|__|\_________\|__|\|_______|\|__| \|__|        \|_______|\|_______|\|_______|\|_______|\_________\
                     \|_________|                                                                        \|_________|

    Script desenvolvido por: guh.dev 
    Desing desenvolvido por: matteo.ui
    Acesse nossa loja: https://discord.gg/usV3Y5kEvH

]]

config = {                   

    ["Others"] = {
        comando = "mods",
        categorias = {"Veiculos", "Exclusivos", "Armamentos", "Corps", "Facs"}
    };

    ["Resources"] = {
        ["Veiculos"] = {

            {"Ferrari 1", 411, "Veiculos", false}; -- feito
            {"Uno Escadinha", 602, "Veiculos", false}; -- alterar <<<<<<<<<<<<
            {"Amarok", 458, "Veiculos", false}; -- feito
            {"Mercedes AMG", 527, "Veiculos", false}; -- feito
            {"Uno", 419, "Veiculos", false}; -- feito
            {"Audi A3", 550, "Veiculos", false}; -- feito
            {"Lamborghini_Gallardo_LP", 526, "Veiculos", false}; -- alterar <<<<<<<<<<<<
            {"Camaro", 474, "Veiculos", false}; -- feito
            {"Jeep Cherokee", 579, "Veiculos", false}; -- feito
            {"Civic", 507, "Veiculos", false}; -- feito
            {"Comodoro", 518, "Veiculos", false}; -- feito
            {"Corolla", 551, "Veiculos", false}; -- feito
            {"BMW I8", 541, "Veiculos", false}; -- feito
            {"Skyline R34", 562, "Veiculos", false}; -- feito
            {"Skyline R35", 415, "Veiculos", false}; -- feito
            {"ALTERAR", 540, "Veiculos", false}; -- ALTERAR
            {"AMG G63s", 405, "Veiculos", false}; -- feito
            {"Porshe Panamera", 529, "Veiculos", false}; -- feito
            {"Chevrolet Montana", 422, "Veiculos", false}; -- feito
            {"ALTERAR", 467, "Veiculos", false}; -- ALTERAR
            {"Jetta", 516, "Veiculos", false}; -- feito
            {"Chevrolet S10", 404, "Veiculos", false}; -- feito
            {"Mercedes G63", 400, "Veiculos", false}; -- feito
            {"Lexus LS", 547, "Veiculos", false}; -- feito
            {"Peugeot 308", 604, "Veiculos", false}; -- feito
            {"Chevette", 496, "Veiculos", false};  -- feito
            {"Volkswagen Fusca", 545, "Veiculos", false}; -- feito
            {"Honda civic", 580, "Veiculos", false};  -- feito
            {"Astra", 426, "Veiculos", false}; -- feito
            {"Caminhão", 456, "Veiculos", false}; -- feito
            {"Gallivanter", 479, "Veiculos", false}; -- feito

            {"Pop 100", 462, "Veiculos", false}; -- feito
            {"MT03", 521, "Veiculos", false}; -- feito
            {"1250", 522, "Veiculos", false}; -- feito
            {"HORNET", 461, "Veiculos", false}; -- feito
            {"XRE", 468, "Veiculos", false}; -- feito
            {"HARLEY DAVIDSON", 463, "Veiculos", false}; -- feito 
            {"BMWR1250", 586, "Veiculos", false}; -- feito 

        };

        ["Exclusivos"] = {       
           
           {"Helicóptero Volatus", 487, "Exclusivos", false}; 
           {"Barco", 453, "Exclusivos", false};     
    
        };

        ["Armamentos"] = { -- Nome, id, categoria, false
        
        {"AK47", 355, "Armamentos", false}; -- GRATIS
        {"M4", 356, "Armamentos", false}; -- GRATIS
        {"SHOTGUN", 349, "Armamentos", false}; -- GRATIS
        {"MP5", 353, "Armamentos", false}; -- GRATIS
        {"GLOCK", 346, "Armamentos", false}; -- GRATIS
        {"GLOCK PL", 352, "Armamentos", false}; -- GRATIS
        {"DEAGLE", 348, "Armamentos", false}; -- GRATIS
        {"USP", 347, "Armamentos", false}; -- GRATIS
        {"SNIPER1", 358, "Armamentos", false}; -- GRATIS
        {"SNIPER2", 357, "Armamentos", false}; -- GRATIS
        {"TEC9", 372, "Armamentos", false}; -- GRATIS


        };

        ["Corps"] = { -- Nome, id, categoria, false

            {"EB 1", 200, "Corps", false}; -- GRATIS
            {"EB 2", 201, "Corps", false}; 
            {"EB 3", 202, "Corps", false}; 
            {"EB 4", 203, "Corps", false};
            {"EB 5", 433, "Corps", false};
            {"EB 6", 489, "Corps", false};

            {"PF 1", 204, "Corps", false}; -- GRATIS
            {"PF 2", 205, "Corps", false}; 

            {"CORREGEDORIA 1", 285, "Corps", false}; -- GRATIS
            {"CORREGEDORIA 2", 286, "Corps", false}; 
            {"CORREGEDORIA 3", 287, "Corps", false}; -- GRATIS
            {"CORREGEDORIA 4", 288, "Corps", false}; 

            {"COT 1", 40, "Corps", false}; -- GRATIS
            {"COT 2", 41, "Corps", false}; 

            {"COE 1", 42, "Corps", false}; -- GRATIS


            {"DETRAN 1", 280, "Corps", false}; -- GRATIS
            {"DETRAN 2", 281, "Corps", false}; 

            {"PMMG 1", 86, "Corps", false}; 
            {"PMMG 2", 87, "Corps", false}; 
            {"PMMG 3", 88, "Corps", false}; 

            {"TOR 1", 206, "Corps", false}; -- GRATIS
            {"TOR 2", 207, "Corps", false}; -- GRATIS

            {"PMES 1", 100, "Corps", false};
            {"PMES 2", 101, "Corps", false}; 
           
            {"CORE 1", 84, "Corps", false}; 

            {"BOPE 1", 282, "Corps", false}; -- Grátis
            {"BOPE 2", 283, "Corps", false}; -- Grátis
            {"BOPE 3", 284, "Corps", false}; -- Grátis

            {"CHOQUE 1", 25, "Corps", false}; -- Grátis
            {"CHOQUE 2", 26, "Corps", false}; -- Grátis

            {"MARINHA 1", 27, "Corps", false}; -- Grátis
            {"MARINHA 2", 28, "Corps", false}; -- Grátis
            {"MARINHA 3", 35, "Corps", false}; -- Grátis
            {"MARINHA NAV", 430, "Corps", false}; -- 01/07

            {"ROTA 1", 29, "Corps", false}; -- Grátis
            {"ROTA 2", 30, "Corps", false}; -- Grátis
            {"ROTA 3", 85, "Corps", false}; -- GRÁTIS

            {"FT 1", 94, "Corps", false}; -- Grátis
            {"FT 2", 95, "Corps", false}; -- Grátis
            {"FT 3", 96, "Corps", false}; -- Grátis
            {"FT 4", 97, "Corps", false}; -- Grátis
            
            {"PRF 1", 20, "Corps", false}; -- Grátis
            {"PRF 2", 21, "Corps", false}; -- Grátis
            
            {"PMESP 1", 272, "Corps", false}; -- Grátis
            {"PMESP 2", 273, "Corps", false}; -- Grátis

            {"VTR SAMU", 416, "Corps", false};
            {"SAMU 1", 274, "Corps", false}; -- Grátis
            {"SAMU 2", 275, "Corps", false};
        
        
        },

        ["Facs"] = { -- Nome, id, categoria, false

            {"Veículo mec", 525, "Facs", false};
            {"Roupa mec", 50, "Facs", false};
            {"Roupa mec", 51, "Facs", false};

            {"Cupula 1", 33, "Facs", false};
            
            {"UT 1", 37, "Facs", false};
            {"UT 2", 38, "Facs", false};
            {"UT 3", 39, "Facs", false};
            {"UT 4", 36, "Facs", false};
            {"CARRO 1", 466, "Facs", false};

          
        };
    };

    sendMessageClient = function(message, type)
        return exports['guetto_notify']:showInfobox(type, message)
    end;
 
    sendMessageServer = function(player, message, type)
        return exports['guetto_notify']:showInfobox(player, type, message)
    end;
 
}

function registerEvent(event, element, callback)
    addEvent(event, true)
    addEventHandler(event, element, callback)
end

function removeHex (s)
    return s:gsub ("#%x%x%x%x%x%x", "") or false
end

function formatNumber(number, sep)
	assert(type(tonumber(number))=="number", "Bad argument @'formatNumber' [Expected number at argument 1 got "..type(number).."]")
	assert(not sep or type(sep)=="string", "Bad argument @'formatNumber' [Expected string at argument 2 got "..type(sep).."]")
	local money = number
	for i = 1, tostring(money):len()/3 do
		money = string.gsub(money, "^(-?%d+)(%d%d%d)", "%1"..sep.."%2")
	end
	return money
end

