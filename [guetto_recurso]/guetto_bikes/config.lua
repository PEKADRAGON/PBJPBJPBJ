config = {
    others = {
        expire_time = 5;
        description = {"Após alugar a bicicleta ela", "sumirá em 5 minutos."};
    };

    companies = {
        {1740.439, -1144.931, 24.005 - 0.9};
        {1863.505, -1386.345, 13.477 - 0.9};
        {1184.276, -1540.305, 13.585 - 0.9};
        {776.468, -1303.567, 13.473 - 0.9};
        {1429.016, -1774.446, 13.547 - 0.9};
        {311.571, -1809.499, 4.471 - 0.9};
        {2538.343, 2334.486, 10.82 - 0.9};
        {1636.956, 97.196, 37.729- 0.9};
    };

    bikes = {
        {title = "BICICLETA BMX", model = 481, price = 200, directory = "assets/images/bmx.png"};
        {title = "MOUNTAIN BIKE", model = 510, price = 500, directory = "assets/images/mountainbike.png"};
        {title = "BIKE", model = 509, price = 1000, directory = "assets/images/bike.png"};
    };
}

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