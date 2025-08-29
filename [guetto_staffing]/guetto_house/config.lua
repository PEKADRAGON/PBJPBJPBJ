config = {
    others = {
        commands = {
            ['createHouse'] = {command = "criarcasa", permission = "Console"};
            ['deleteHouse'] = {command = "deletarcasa", permission = "Console"};
        };
    };

    types_house = { -- ['Tipo de Casa'] = {Interior, Pos (entrada & saida), Bau (pos, rot, capacidade)};
        ['Mansão 4'] = {pesoBau = 1000, int = 9, pos = {enter = {2317.73706, -1026.75684, 1050.21777}}, bau = {2262.156, -1221.847, 1049.023 - 1, 0, 0, 90, 100}},
        ['Mansão 1'] = {pesoBau = 1000, int = 9, pos = {enter = {82.95, 1322.44, 1083.866}}, bau = {75.377, 1343.907, 1088.367 - 1, 0, 0, 0.003, 100}},
        ['Mansão 2'] = {pesoBau = 1000, int = 4, pos = {enter = {-260.63, 1456.591, 1084.367}}, bau = {-272.61, 1447.053, 1088.867 - 1, 0, 0, 92.671, 100}},
        ['Mansão 3'] = {pesoBau = 1000, int = 15, pos = {enter = {-283.439, 1471.073, 1084.375}}, bau = {-288.166, 1479.023, 1088.882 - 1, 0, 0, 88.696, 100}},
        ['Simples 1'] = {pesoBau = 1000, int = 6, pos = {enter = {2333.278, -1076.931, 1049.023}}, bau = {2344.409, -1063.464, 1049.023 - 1, 0, 0, 2.882, 100}},
        ['Simples 2'] = {pesoBau = 1000, int = 6, pos = {enter = {-68.849, 1351.579, 1080.211}}, bau = {-71.637, 1365.508, 1080.219 - 1, 0, 0, 359.796, 100}},
        ['Simples 3'] = {pesoBau = 1000, int = 8, pos = {enter = {-42.494, 1405.779, 1084.43}}, bau = {-45.697, 1412.031, 1084.43 - 1, 0, 0, 356.191, 100}},
        ['Normal 1'] = {pesoBau = 1000, int = 4, pos = {enter = {261.092, 1284.555, 1080.258}}, bau = {263.386, 1294.874, 1080.258 - 1, 0, 0, 0, 100}},
        ['Normal 2'] = {pesoBau = 1000, int = 10, pos = {enter = {2270.099, -1210.35, 1047.563}}, bau = {2262.156, -1221.847, 1049.023 - 1, 0, 0, 90, 100}},
        ['Normal 3'] = {pesoBau = 1000, int = 6, pos = {enter = {2196.85083, -1204.34924, 1049.02344}}, bau = {2262.156, -1221.847, 1049.023 - 1, 0, 0, 90, 100}},
        ['Normal 4'] = {pesoBau = 1000, int = 8, pos = {enter = {2365.30005, -1134.92004, 1050.87500}}, bau = {2262.156, -1221.847, 1049.023 - 1, 0, 0, 90, 100}},
        -- especiais
        ['Maddog 1'] = {pesoBau = 1000, int = 5, pos = {enter = {1261.16052, -785.38519, 1091.90625}}, bau = {2262.156, -1221.847, 1049.023 - 1, 0, 0, 90, 100}},
        ['CJ 1'] = {pesoBau = 1000, int = 3, pos = {enter = {2496.03271, -1692.45679, 1014.74219}}, bau = {2262.156, -1221.847, 1049.023 - 1, 0, 0, 90, 100}},
        ['Gang 1'] = {pesoBau = 1000, int = 5, pos = {enter = {2351.59009, -1181.08081, 1027.97656}}, bau = {2262.156, -1221.847, 1049.023 - 1, 0, 0, 90, 100}}, -- dim = 200
        ['Gang 2'] = {pesoBau = 1000, int = 5, pos = {enter = {318.57324, 1114.80823, 1083.88281}}, bau = {2262.156, -1221.847, 1049.023 - 1, 0, 0, 90, 100}},

    };

    sendMessageServer = function (player, msg, type)
        return exports['guetto_notify']:showInfobox(player, type, msg)
    end;
    
    sendMessageClient = function (msg, type)
        return exports['guetto_notify']:showInfobox(type, msg)
    end;
    
};



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

