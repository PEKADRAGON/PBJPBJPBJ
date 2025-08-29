config = {
    others = {
        max_characters = 5;
        price_characters = {0, 20, 30, 40, 50};
        camera_matrix = {1589.4653320312, -1212.4840087891, 278.60440063477, 1589.4915771484, -1213.4830322266, 278.56716918945, 0, 70};
        position = {1588.534, -1220.481, 277.874, 0};
    };

    datas = {
        coins = "guetto.points";
        level = "Level";
    };

    panel = {
        citys = {
            {"Los Santos"};
            {"Las Venturas"};
            {"San Fierro"};
        };

        genres = {
            {"Masculino"};
            {"Feminino"};
        };
    };
};

function sendMessage (action, element, message, type)
    if action == "client" then
        return exports['guetto_notify']:showInfobox(type, message)
    elseif action == "server" then
        return exports['guetto_notify']:showInfobox(element, type, message)
    end
end

function registerEvent(event, element, callback)
    addEvent(event, true)
    addEventHandler(event, element, callback)
end

function convertNumber(amount)
    local left, center, right = string.match(math.floor(amount), '^([^%d]*%d)(%d*)(.-)$')
    return left .. string.reverse(string.gsub(string.reverse(center), '(%d%d%d)', '%1.')) .. right
end

_getPlayerName = getPlayerName;
function getPlayerName(element)
    return _getPlayerName(element):gsub("#%x%x%x%x%x%x", "") or _getPlayerName(element);
end