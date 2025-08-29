config = {
    ['mensagem'] = '#FFB84E[EVENTO] #FFFFFFFoi iniciado um evento de carro!',
    ['blip'] = 52,
    ['markerPos'] = {-2378.729, 2429.324, 8.867 - 1, 'cylinder', 1.5, 139, 100, 255, 100 };
    ['vehiclePos'] = {
        {411, -2355.517, 2411.716, 6.785, 0, 0, 90};
        {411, -2358.411, 2416.508, 7.171, 0, 0, 90};
    };
    ["dinheiroSujo"] = {
        ["id"] = 100,
        ["quantidade"] = {1000, 2000}
    }
}

sendMessageServer = function (player, msg, type)
    return exports['guetto_notify']:showInfobox(player, type, msg)
end;
