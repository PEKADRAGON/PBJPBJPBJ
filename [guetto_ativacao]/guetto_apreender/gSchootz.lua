config = {
    ['Geral'] = {
        AclAbrir = {'Corporação', 'DETRAN'},
    },
    ['Markers'] = {
        {2256.096, -1340.214, 24.041},
        {1669.531, 53.202, 37.729},
        {2481.222, 2356.837, 10.815},
        {1215.795, -880.53, 42.907},
    },
}

notifyS = function(player, message, tipo)
    return exports['guetto_notify']:showInfobox(player, tipo, message) 
end

notifyC = function(message, tipo)
    exports['guetto_notify']:showInfobox(tipo, message) 
end