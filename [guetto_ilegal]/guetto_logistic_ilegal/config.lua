config = {
    others = {
        acl = "Console",
        altitude = 120,
        vehicle = 511,
    },
    datas = {
        id = "ID",
        ptr = "service.police"
    },
    entrega = {
        [1] = {id = 2, amount = 10},
        [2] = {id = 3, amount = 15},
    },
    recompensa = {
        money = {30000, 50000},
    },
    locations = {
        iniciar = {
            { pos = {420.028, 2532.144, 16.598}, spawn = {405.053, 2455.082, 16.5} },
        },
        destinos = {
            --{-1990.24231, -2402.76782, 30.62500},
            --{2890.81885, 2237.91968, 10.82031},

            {-2024.602, -2380.565, 30.7},
            {4357.83, 9.75, 10.85},
        },
    },
    sendMessageServer = function(player, message, type)
        return exports['guetto_notify']:showInfobox(player, message, type) 
    end;
    sendMessageClient = function(message, type)
        return exports['guetto_notify']:showInfobox(message, type) 
    end
}