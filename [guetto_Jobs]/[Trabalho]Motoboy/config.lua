
config = {
    startService = {
        marker = Vector3(1374.79, -1431.975, 13.545);

        vehicle = {
            model = 448;

            position = Vector3(2087.84595, -1805.82275, 13.54688);
            rotation = Vector3(0, 0, 270);
        };
    };

    peds = {
        {{0, 51, 52, 53}, Vector3(1924.577, -1659.096, 13.57), Vector3(-0, 0, 266.105)};
        {{0, 51, 52, 53}, Vector3(1851.758, -2062.194, 13.547), Vector3(-0, 0, 267.356)};
        {{0, 51, 52, 53}, Vector3(1838.412, -1720.333, 13.588), Vector3(-0, 0, 89.506)};
        {{0, 51, 52, 53}, Vector3(651.886, -1619.938, 15), Vector3(-0, 0, 356.511)};
        {{0, 51, 52, 53}, Vector3(1936.222, -1922.604, 13.547), Vector3(-0, 0, 177.273)};
        {{0, 51, 52, 53}, Vector3(2284.166, -1903.468, 13.559), Vector3(-0, 0, 308.798)};
        {{0, 51, 52, 53}, Vector3(2438.051, -2020.157, 13.903), Vector3(-0, 0, 0.483)};
        {{0, 51, 52, 53}, Vector3(2702.222, -1979.471, 13.725), Vector3(-0, 0, 177.977)};
        {{0, 51, 52, 53}, Vector3(2514.312, -1724.955, 13.547), Vector3(-0, 0, 1.907)};
        {{0, 51, 52, 53}, Vector3(2386.926, -1715.622, 13.591), Vector3(-0, 0, 180.19)};
        {{0, 51, 52, 53}, Vector3(1334.246, -1087.75, 24.615), Vector3(-0, 0, 2.997)};
        {{0, 51, 52, 53}, Vector3(2207.428, -2632.537, 13.547), Vector3(-0, 0, 90.847)};
        {{0, 51, 52, 53}, Vector3(1982.631, -1666.999, 13.495), Vector3(-0, 0, 242.232)};
        {{0, 51, 52, 53}, Vector3(164.471, -1769.538, 4.457), Vector3(-0, 0, 267.823)};
        {{0, 51, 52, 53}, Vector3(521.292, -1812.705, 6.578), Vector3(-0, 0, 269.733)};
        {{0, 51, 52, 53}, Vector3(951.422, -1261.95, 15.701 ), Vector3(-0, 0, 194.418)};
        {{0, 51, 52, 53}, Vector3(352.384, -1197.956, 76.516), Vector3(-0, 0, 40.973)};
        {{0, 51, 52, 53}, Vector3(254.282, -1366.984, 53.109), Vector3(-0, 0, 313.792)};
        {{0, 51, 52, 53}, Vector3(2488.731, 0.994, 26.484), Vector3(-0, 0, 180.81)};
        {{0, 51, 52, 53}, Vector3(2416.174, -39.184, 26.56), Vector3(-0, 0, 356.427)};
        {{0, 51, 52, 53}, Vector3(2292.885, -108.807, 26.519), Vector3(-0, 0, 355.874)};
        {{0, 51, 52, 53}, Vector3(2334.039, 131.566, 26.484), Vector3(-0, 0, 269.281)};
        {{0, 51, 52, 53}, Vector3(2080.949, -1202.442, 23.916), Vector3(-0, 0, 179.52)};
        {{0, 51, 52, 53}, Vector3(2082.052, -1085.871, 25.044), Vector3(-0, 0, 180.727)};
        {{0, 51, 52, 53}, Vector3(2233.05, -1333.611, 23.982), Vector3(-0, 0, 178.263)};
        {{0, 51, 52, 53}, Vector3(2481.625, -1494.879, 24), Vector3(-0, 0, 178.448)};
        {{0, 51, 52, 53}, Vector3(2071.146, -1793.566, 13.553), Vector3(-0, 0, 4.055)};
    };

    requestProducts = {
        ['foods'] = {
            ['XTUDO PEQUENA '] = 100,
            ['XFRANGO GRANDE '] = 150,
            ['XCATUPIRY PEQUENA DE FRANGO '] = 125,
            ['XSALADA GRANDE'] = 150,
            ['XBURGER PEQUENA DE PICLES'] = 130,
            ['XBURGER GRANDE DE FRANGO'] = 150,
            ['XDACASA PEQUENA DE PICLES '] = 130,
            ['XDACASA GRANDE DE PICLES'] = 150,
            ['XSRRP GRANDE DE CENOURA'] = 150,
            ['XPIZZA PEQUENA DE CENOURA'] = 140,
            ['XRATAO GRANDE '] = 250,
        };

        ['drinks'] = {
            ['COCA COLA 1,5L'] = 18;
            ['COCA COLA 2L'] = 20;
            ['MINEIRO 1,5L'] = 17;
            ['MINEIRO 2L'] = 19;
            ['KUAT 2L'] = 19;
            ['FANTA UVA 2L'] = 20;
            ['LATA FANTA UVA 2L'] = 15;
            ['KITUBAINA 1,5L'] = 17;
            ['ENERGETICO 1,5L'] = 35;
            ['SUCO DE LARANHA 1,5L'] = 25;
        };
    },
}

function addNotification(player,message, type)
    exports['guetto_notify']:showInfobox(player, type, message)
end

function giveMoneyForPlayer(player, quanty)
    if (isElement(player) and getElementType(player) == 'player' and tonumber(quanty)) then
        givePlayerMoney(player, quanty)
    end
end

function createCustomMarker(pos)
    --return exports["srrp_marker"]:createMarker("market", Vector3 {pos.x, pos.y, (pos.z - 1)})
    return createMarker(pos.x, pos.y, (pos.z - 1), 'cylinder', 1.2, 255, 255, 255, 50)
end