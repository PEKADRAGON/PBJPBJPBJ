config = {
    ['Geral'] = {
        TimeAlugue = 60, -- em minutos
    },
    ['Locais'] = {
        {2955.229, -1487.478, 1.624, {2967.12, -1488.07, -0.55, 0, 0, 0}}, -- Primero Localização / Segunda Posição do barco
        {4207.985, -1559.94, 11.074, {4163.005, -1537.134, -0.55, 0, 0, 0}}, -- Primero Localização / Segunda Posição do barco
    },
    ['Veiculos'] = {
        {'Speeder', 473, 500},
    },
}

sendMessageServer = function (player, msg, type)
    return exports['guetto_notify']:showInfobox(player, type, msg)
end;

sendMessageClient = function (msg, type)
    return exports['guetto_notify']:showInfobox(type, msg)
end;