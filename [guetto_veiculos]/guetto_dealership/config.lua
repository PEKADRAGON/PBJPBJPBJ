config = {

    ["Others"] = {
        ["categorys"] = {"CARROS", "MOTOS", "ESPECIAIS", "EXCLUSIVO"};
        ["vips"] = {"Marginal de grife", "Visionário", "Criminoso", "Luxuria"};
    };

    ["Shop"] = {
        ["slot"] = 10;
    };

    ["Actions"] = {
        ["dealay"] = 500; -- Dealy em milesegundos 
    };

    ["Manage-Vehicle"] = { -- Configurações de localizar, vender 
        ["key"] = "f4", -- Tecla que o painel vai abrir
        ["blip"] = 19, -- BLip de localizar o veículo
        ["timer"] = 1; -- Tempo para o blip sumir 
    };

    ["Test-Drive"] = {
        ['time'] = 1;
        ["spawn"] = {1404.53, -2441.982, 13.555, 0, 0, 90};
        ["radius"] = 100;
    };  

    ["Matrix"] = {
        ["CARROS"] = { spawn = {-1238.21570, -2.07541, 14.14844}; camera = {-1248.2054443359, -12.88689994812, 14.94019985199, -1247.5279541016, -12.153643608093, 14.88304901123, 0, 50}; };
        ["MOTOS"] =  { spawn = {-1238.21570, -2.07541, 14.14844}; camera = {-1248.2054443359, -12.88689994812, 14.94019985199, -1247.5279541016, -12.153643608093, 14.88304901123, 0, 50}; };
        ["ESPECIAIS"] = { spawn = {1616.498, -2544.123, 13.547+1}; camera = {1601.2796630859, -2543.5400390625, 17.676399230957, 1602.2434082031, -2543.5747070312, 17.411624908447, 0, 70}; };
        ["EXCLUSIVO"] = { spawn = {1616.498, -2544.123, 13.547}; camera = {1601.2796630859, -2543.5400390625, 17.676399230957, 1602.2434082031, -2543.5747070312, 17.411624908447, 0, 70}; };
    };

    ["Description"] = {
        ["CARROS"] = "Véiculos 4 rodas";
        ["MOTOS"] = "Véiculos 2 rodas";
        ["ESPECIAIS"] = "Barcos e aeronaves";
        ["EXCLUSIVO"] = "Exclusivos";
    };

    positions = {

        ["dealership"] = {
            {1755.173, -1126.305, 24.198};
        };
        
        ["garage"] = {


            {marker = {2142.06, -75.794, 3.655}; spawm = {2138.383, -65.782, 2.87}, rotation = {0, 0, 18.01} }; -- Garagem TD7
            {marker = {4181.642, -712.362, 10.845}; spawm = {4193.09, -702.489, 10.89}, rotation = {0, 0, 18.01} }; -- Garagem TD7
            {marker = {4115.729, -575.302, 10.85}; spawm = {4106.547, -577.78, 10.85}, rotation = {0, 0, 18.01} }; -- Garagem TD7
            {marker = {4255.527, -526.948, 10.86}; spawm = {4249.818, -527.402, 10.86}, rotation = {0, 0, 18.01} }; -- Garagem TD7
            {marker = {4583.515, -953.027, 10.849}; spawm = {4588.751, -960.423, 10.849}, rotation = {0, 0, 18.01} }; -- Garagem TD7
            {marker = {1636.85, 93.747, 37.729}; spawm = {1630.075, 90.212, 37.72}, rotation = {0, 0, 18.01} }; -- Garagem TD7

            {marker = {1863.527, -1373.504, 13.477}; spawm = {1853.798, -1372.592, 13.391}, rotation = {0, 0, 18.01} }; -- Garagem TD7
            {marker = {1658.358, -1111.309, 23.906}; spawm = {1670.902, -1111.341, 23.906}, rotation = {0, 0, 18.01} }; -- Garagem TD7
            {marker = {1184.242, -1543.311, 13.578}; spawm = {1193.758, -1545.196, 13.383}, rotation = {0, 0, 1.025} }; -- Garagem TD7
            {marker = {315.111, -1809.449, 4.474}; spawm = {314.726, -1800.528, 4.571}, rotation = {0, 0, 1.025} }; -- Garagem TD7
            {marker = {1429.053, -1776.934, 13.547}; spawm = {1421.736, -1777.475, 13.547}, rotation = {0, 0, 1.025} }; -- Garagem TD7

            {marker = {2511.789, 2359.426, 10.815}; spawm = {2503.995, 2360.741, 10.815}, rotation = {0, 0, 1.025} }; -- Garagem TD7
            {marker = {270.763, 1401.373, 12.008}; spawm = {267.966, 1409.231, 12.008}, rotation = {0, 0, 1.025} }; -- Garagem TD7
            {marker = {773.124, -1303.762, 13.473}; spawm = {772.021, -1298.997, 13.473}, rotation = {0, 0, 1.025} }; -- Garagem TD7
            {marker = {1380.351, 492.529, 20.44}; spawm = {1378.384, 495.981, 20.444}, rotation = {0, 0, 154.896} }; -- Garagem PMSP

            {marker = {-1539.833, 311.494, 7.199}; spawm = {-1539.897, 316.054, 7.199}, rotation = {0, 0, 272.039} }; -- Garagem EB
            {marker = {-242.334, -234.232, 2.43}; spawm = {-235.177, -235.858, 1.422}, rotation = {0, 0, 182.604} }; -- Garagem Fabrica
            {marker = {-1113.241, -1635.506, 76.367}; spawm = {-1110.337, -1644.612, 76.367}, rotation = {0, 0, 182.604} }; -- Garagem UT
            {marker = {-742.404, -1122.806, 60.964}; spawm = {-746.764, -1124.174, 60.964}, rotation = {0, 0, 182.604} }; -- Garagem MLC

            {marker = {704.075, -1916.753, 1.523}; spawm = {714.897, -1922.051, -0.55}, rotation = {0, 0, 181.862} }; -- Garagem MLC
            {marker = {-461.801, -1747.141, 11.969}; spawm = {-453.653, -1734.237, 11.969}, rotation = {0, 0, 280.702} }; -- Garagem TDU
            {marker = {2435.769, -1240.584, 24.534}; spawm = {2430.582, -1236.242, 24.677}, rotation = {0, 0, 280.702} }; -- Garagem TDU
            {marker = {2698.28, -743.075, 80.097}; spawm = {2697.698, -736.993, 79.889}, rotation = {0, 0, 312.547} }; -- Garagem TDF

            {marker = {1516.433, -2700.466, 13.539}; spawm = {1515.984, -2711.821, 13.539}, rotation = {0, 0, 312.547} }; -- Garagem TDF
            {marker = {1923.332, 183.784, 36.51}; spawm = {1930.963, 170.569, 37.275}, rotation = {0, 0, 312.547} }; -- Garagem TDF
            {marker = {945.224, 477.94, 20.277}; spawm = {952.767, 474.013, 20.277}, rotation = {0, 0, 247.529} }; -- Garagem BASE ROTA

            {marker = {1041.552, -1053.714, 31.703}; spawm = {1044.568, -1045.727, 31.852}, rotation = {0, 0, 247.529} }; -- Garagem BASE ROTA
            {marker = {2100.704, -1783.758, 13.395}; spawm = {2103.862, -1779.053, 13.39}, rotation = {0, 0, 247.529} }; -- Garagem BASE ROTA
            {marker = {2256.835, -1363.285, 24.034}; spawm = {2248.191, -1360.314, 24.041}, rotation = {0, 0, 247.529} }; -- Garagem BASE ROTA

            {marker = {1698.954, -2094.286, 13.547}; spawm = {1698.253, -2110.171, 13.383}, rotation = {0, 0, 272.237} }; -- Garagem Guetto UT

            
        };

        ["detran"] = {
            {735.967, -1253.164, 13.639};
        };

    };

    ["Slots"] = {
        ["Console"] = 8;
        ["Marginal de grife"] = 5;
        ["Visionário"] = 5;
        ["Criminoso"] = 5;
        ["Everyone"] = 3;
    };

    vehicles = {
        ['CARROS'] = {

            {name = 'Fusca', brand = 'Volkswagen', model = 545, money = 19000, stock = 300};
            {name = 'Chevette', brand = 'Volkswagen', model = 496, money = 45000, stock = 300};
          --  {name = 'Chevette', brand = 'Volkswagen', model = 445, money = 20000, stock = 300};
            {name = 'Astra', brand = 'CHEVROLET', model = 426, money = 175000, stock = 300};
            {name = 'Chevrolet Montana', brand = 'Chevrolet', model = 422, money = 285000, stock = 300};
            {name = 'Uno', brand = 'Fiat', model = 419, money = 400000, stock = 300};
            {name = 'Ford Fusion', brand = 'Ford', model = 540, money = 430000, stock = 300};
            {name = 'Opala Comodoro', brand = 'Opala', model = 518, money = 1000000, stock = 300};
            {name = 'Peugeot 308', brand = 'Peugeot', model = 604, money = 3000000, stock = 300};
            {name = 'Honda Civic', brand = 'Honda', model = 507, money = 4000000, stock = 300};
            {name = 'Toyota Corolla', brand = 'Toyota', model = 551, money = 6000000, stock = 300};
            {name = 'Chevrolet S10', brand = 'Chevrolet', model = 404, money = 10000000, stock = 300};
            {name = 'Jeep Cherokee', brand = 'Jeep', model = 579, money = 30000000, stock = 300};
            {name = 'Volkswagen Jetta', brand = 'Volkswagen', model = 516, money = 40000000, stock = 300};
          --  {name = 'Audi A3', brand = 'Audi', model = 587, money = 1000000, stock = 300};
            {name = 'Camaro', brand = 'Chevrolet', model = 474, money = 80000000, stock = 300};
            {name = 'Mercedes G63', brand = 'Mercedes', model = 400, money = 90000000, stock = 300};
            {name = 'Gallivanter', brand = 'Mercedes', model = 479, money = 100000000, stock = 300};
 
        };
        

        ['MOTOS'] = {

            {name = 'Pop 100', brand = 'Honda', model = 462, money = 15000, stock = 100};
            {name = 'Hornet', brand = 'Honda', model = 461, money = 55000, stock = 100};
            {name = 'XRE', brand = 'Honda', model = 468, money = 100000, stock = 100};
            {name = 'GS-F800', brand = 'BMW', model = 522, money = 130000, stock = 100};
            {name = 'MT', brand = 'Honda', model = 521, money = 295000, stock = 100};
            {name = 'R1200', brand = 'BMW ', model = 586, money = 500000, stock = 100};
            {name = 'harley davidson', brand = 'Harley ', model = 463, money = 900000, stock = 100};

        };

        ['ESPECIAIS'] = {
            {name = 'Volatus', brand = 'Buckingham', model = 487, coins = 80, stock = 10};   
            {name = 'Barco', brand = 'Exclusivo', model = 453, coins = 80, stock = 10}; 
        };

        ['EXCLUSIVO'] = {

            {name = 'Lancer Evolution', brand = 'Mitsubishi', model = 467, coins = 50, stock = 100};
            {name = 'Uno Speed', brand = 'Fiat', model = 602, coins = 70, stock = 300};
            {name = 'Mercedes AMG GT 63s', brand = 'Mercedes', model = 405, coins = 65, stock = 300};
            {name = 'Lexus LS', brand = 'Lexus', model = 547, coins = 65, stock = 100};
            {name = 'Skyline R35', brand = 'Nissan', model = 415, coins = 65, stock = 100};
            {name = 'Skyline R34', brand = 'Nissan', model = 562, coins = 65, stock = 100};
            {name = 'Porshe Panamera', brand = 'Porshe', model = 529, coins = 65, stock = 100};
            {name = 'Ferrari', brand = 'Ferrari', model = 411, coins = 65, stock = 100};
            {name = 'BMW I8', brand = 'BMW', model = 541, coins = 65, stock = 100};
            {name = 'AMG GT', brand = 'Mercedes', model = 527, coins = 65, stock = 300};

        };

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

function getVehicleSpace (vehicle)
    if not vehicle or not isElement(vehicle) then 
        return false 
    end;

    return 150
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

function timestampToDateString(timestamp)
    local dateTable = os.date("*t", timestamp)
    local dateString = string.format("%02d/%02d/%04d", dateTable.day, dateTable.month, dateTable.year)
    return dateString
end

function getPlayerFromId ( id )
    local result = false 
    for i, v in ipairs (getElementsByType("player")) do 
        if (getElementData(v, "ID") == id) then 
            result = v 
        end
    end
    return result
end

function getVehicleConfigFromModel (model)
    if model then 
        for index, v in ipairs ( config['Others'].categorys ) do 
            for i, value in ipairs ( config.vehicles[v] ) do 
                if value.model == model then 
                    return value 
                end
            end
        end
    end
    return false
end
