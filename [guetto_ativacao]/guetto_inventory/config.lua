config = {

    ['others'] = {

    };

    ['acls_slots_free'] = { -- Lista de acl´s que vão liberar slots 
        'Console', 'Visionário', 'Marginal de grife'
    };

    ['commands_permissions'] = {
        ['giveitem'] = {'Console', 'Admin'},
        ['takeitem'] = {'Console', 'Admin'},
        ['getitem'] = {'Console', 'Admin'},
        ['resetinv'] = {'Console', 'Admin'},
    };

    ["weapons"] = { -- Lista de armas do inventário
        ["weapons_primary"] = { -- Lista de armas primárias
            [59] = 30; -- [59] = ID DO ITEM NO INV | 30 = Id da arma do mta
            [57] = 31; -- [59] = ID DO ITEM NO INV | 30 = Id da arma do mta
            [65] = 28; -- [59] = ID DO ITEM NO INV | 30 = Id da arma do mta
            [145] = 32; -- [59] = ID DO ITEM NO INV | 30 = Id da arma do mta
        };
        ["weapons_secondarys"] = {
            [63] = 24;
            [58] = 29;
            [62] = 22
        };
    };

    ["ammunition"] = { -- Lista dos id´s das muniçoes e id das armas
        [54] = {59};
        [55] = {57};
        [53] = {58, 62, 63, 145, 65}
    };

    ['itens'] = {

        -- Comidas
        [1] = { name = 'Hamburguer', weight = 0.3, category = 'food',  fome = 30, others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [2] = { name = 'Batata-frita', weight = 0.2, category = 'food', fome = 30, others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [3] = { name = 'Crepe', weight = 0.3, category = 'food', fome = 30, others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [4] = { name = 'Pão-de-sal', weight = 0.3, category = 'food', fome = 30, others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [5] = { name = 'Sushi', weight = 0.3, category = 'food', fome = 20, others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [6] = { name = 'Lasanha', weight = 0.2, category = 'food', fome = 30, others = { usar = faltruese, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [7] = { name = 'Nestlé chocolate', weight = 0.2, category = 'food', fome = 10, others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [8] = { name = 'Tiras-crocantes', weight = 0.3, category = 'food', fome = 15, others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [9] = { name = 'Mini-Frangos', weight = 0.2, category = 'food', fome = 25, others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [10] = { name = 'Hot-dog', weight = 0.2, category = 'food', fome = 35, others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
         
        -- Bebidas 
        [11] = { name = 'Heineken', weight = 0.1, category = 'food', sede = 30, others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [12] = { name = 'Bebida-cluck', weight = 0.1, category = 'food', sede = 40, others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [13] = { name = 'Redbull', weight = 0.1, category = 'food', sede = 30, others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [14] = { name = 'Coca-cola', weight = 0.2, category = 'food', sede = 40, others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [15] = { name = 'jack-daniels', weight = 0.2, category = 'food', sede = 30, others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [16] = { name = 'Água', weight = 0.2, category = 'food', sede = 30, others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [17] = { name = 'Sprite', weight = 0.2, category = 'food', sede = 40, others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [18] = { name = 'White-pay', weight = 0.2, category = 'food', sede = 30, others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [19] = { name = 'Cerveja', weight = 0.5, category = 'food', sede = 30, others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [20] = { name = 'Suco-de-laranja', weight = 0.5, category = 'food', sede = 30, others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };

        -- Mochila
        [21] = { name = 'Passaporte', weight = 0.1, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [22] = { name = 'RG', weight = 0.5, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [23] = { name = 'CNH', weight = 0.5, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [24] = { name = 'Kit-médico-50%', weight = 0.5, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [25] = { name = 'Kit-médico-100%', weight = 0.5, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
      
        [26] = { name = 'Presente-do-Matteo', weight = 0, category = 'bag',  others = { usar = true, dropar = false, enviar = false, portamalas = true, bau = false, perder = true, revistar = false } };
        [27] = { name = 'Presente-do-Guh', weight = 0, category = 'bag',  others = { usar = true, dropar = false, enviar = true, portamalas = true, bau = false, perder = true, revistar = false } };
      
        [28] = { name = 'Binoculo', weight = 0.5, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [29] = { name = 'Bateria', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [30] = { name = 'Doc-guarda', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [31] = { name = 'Carvão', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [32] = { name = 'Petróleo', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [33] = { name = 'JBL', weight = 1, category = 'bag',  others = { usar = true, dropar = false, enviar = false, portamalas = false, bau = false, perder = false, revistar = false } };
        [34] = { name = 'Celular', weight = 0.5, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [35] = { name = 'Radinho', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [36] = { name = 'Faca', weight = 0.6, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [37] = { name = 'Doc-policia', weight = 0.6, category = 'bag',  others = { usar = false, dropar = false, enviar = false, portamalas = false, bau = false, perder = false, revistar = true } };
        [38] = { name = 'Colete balistico', weight = 0.6, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [39] = { name = 'Gasolina', weight = 0.6, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [40] = { name = 'Vaso', weight = 0.6, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [41] = { name = 'Taser', weight = 0.6, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [42] = { name = 'Fertilizante', weight = 0.6, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [43] = { name = 'Taco-de-baseboll', weight = 0.6, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [44] = { name = 'Pen-drive', weight = 0.6, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [45] = { name = 'Alicate', weight = 0.6, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [46] = { name = 'Corda', weight = 0.6, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [47] = { name = 'Survivo coins', weight = 0, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [48] = { name = 'Linha-agulha', weight = 0.6, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [49] = { name = 'Lock-pick', weight = 0.6, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [50] = { name = 'Furadeira', weight = 0.6, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
   
        -- Munições e armas
        [51] = { name = '.40mm', weight = 0.2, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [52] = { name = '.12mm', weight = 0.2, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [53] = { name = '.9mm', weight = 0.2, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [54] = { name = '.762x39mm', weight = 0.2, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [55] = { name = '.762x45mm', weight = 0.2, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [56] = { name = '.762x51mm', weight = 0.2, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [57] = { name = 'PARAFAL', weight = 25, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [58] = { name = 'MP5', weight = 10, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [59] = { name = 'AK47', weight = 10, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [60] = { name = 'Doze', weight = 10, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [61] = { name = 'Minigun', weight = 80, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [62] = { name = 'Glock', weight = 5, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [63] = { name = 'Deagle', weight = 5, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [64] = { name = 'HK-UMP45', weight = 10, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [65] = { name = 'Glock PL', weight = 5, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [66] = { name = 'Cacetete', weight = 0.5, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
       
        -- Outros
        [67] = { name = 'Key-Red', weight = 1, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [68] = { name = 'Key-Yellow', weight = 1, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [69] = { name = 'Key-Green', weight = 1, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [70] = { name = 'Bomba-caseira', weight = 15, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [71] = { name = 'Kit-de-reparo', weight = 1, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [72] = { name = 'Turbo-4X', weight = 1, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [73] = { name = 'Cafeteira', weight = 1, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [74] = { name = 'Gabinete', weight = 1, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [75] = { name = 'Micro-ondas', weight = 1, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [76] = { name = 'Som-booster', weight = 1, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [77] = { name = 'Televisão', weight = 1, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [78] = { name = 'Notedark', weight = 1, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [79] = { name = 'ModemNET', weight = 1, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [80] = { name = 'Rubi', weight = 1, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [81] = { name = 'Diamante', weight = 1, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [82] = { name = 'Bronze', weight = 1, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [83] = { name = 'Ferro', weight = 1, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [84] = { name = 'Corrente-BOSS', weight = 1, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [85] = { name = 'Tiara-de-Ouro', weight = 1, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [86] = { name = 'Corrente-de-Ouro', weight = 1, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [87] = { name = 'Correntinha-Falsa', weight = 0.5, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [88] = { name = 'Flores', weight = 1, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [89] = { name = 'Aliança', weight = 5, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [90] = { name = 'Anel-Maçon', weight = 8, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [91] = { name = 'Golden-ticket', weight = 1, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [92] = { name = 'Cupom 25%', weight = 0.1, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [93] = { name = 'Cupom 15%', weight = 0.1, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [94] = { name = 'Cupom 10%', weight = 0.1, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [95] = { name = 'Maço-de-Cigarro', weight = 0.3, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [96] = { name = 'Maconha-bolada', weight = 0.2, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
      
        [97] = { name = 'Papel de Seda', weight = 0.2, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [98] = { name = 'Seda-Canela', weight = 0.2, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [99] = { name = 'Seda-Los-Santos', weight = 0.2, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
      
        [100] = { name = 'Dinheiro-sujo', weight = 0, category = 'ilegal',  others = { usar = false, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [101] = { name = 'Dedo-Amputado', weight = 0.5, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [102] = { name = 'Braço-Amputado', weight = 0.5, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [103] = { name = 'Cabeça-Amputado', weight = 0.5, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [104] = { name = 'Coração-Amputado', weight = 0.5, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [105] = { name = 'Intestino', weight = 0.5, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [106] = { name = 'Figado', weight = 0.5, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [107] = { name = 'Perna-Amputada', weight = 0.5, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [108] = { name = 'Rim', weight = 0.5, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [109] = { name = 'Pulmão', weight = 0.5, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [110] = { name = 'Unha-Amputado', weight = 0.5, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [111] = { name = 'Estomago', weight = 0.5, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [112] = { name = 'Cranio-velho', weight = 0.5, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [113] = { name = 'Lingua-Amputado', weight = 0.5, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [114] = { name = 'Dente-Amputado', weight = 0.5, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [115] = { name = 'Corpo-Amputado', weight = 0.5, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
   
        [116] = { name = 'Pact.(Cocaina)', weight = 0.5, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [117] = { name = 'Pact.(Cannabis)', weight = 0.5, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [118] = { name = 'Cocaina-solta', weight = 0.5, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [119] = { name = 'Maconha-prens.', weight = 0.5, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [120] = { name = 'Pé-de-Maconha', weight = 0.5, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [121] = { name = 'Moconha-Embalada', weight = 0.5, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [122] = { name = 'Embalagem-Plastica', weight = 0.1, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [123] = { name = 'Pé-de-Cocaina', weight = 0.5, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [124] = { name = 'Cocaina-Embalada', weight = 0.5, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [125] = { name = 'Prensa-Artificial', weight = 0.5, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [126] = { name = 'Mesa-de-Drogas', weight = 20, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [127] = { name = 'Boné Preto', weight = 1, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [128] = { name = 'Dinheiro', weight = 0, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
  
        -- Fabrica armas
        [129] = { name = 'Attachs pistolas', weight = 1, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [130] = { name = 'Corpo deagle', weight = 0.5, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [131] = { name = 'Corpo glock', weight = 0.5, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [132] = { name = 'Folha de craft', weight = 0.3, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [133] = { name = 'Corpo parafal', weight = 0.5, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [134] = { name = 'Attachs parafal', weight = 0.5, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [135] = { name = 'Corpo AK47', weight = 0.5, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [136] = { name = 'Attachs AK47', weight = 0.5, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [137] = { name = 'Corpo Tec-9', weight = 0.5, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [138] = { name = 'Attachs Tec-9', weight = 0.5, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [139] = { name = 'Pente-longo glock', weight = 0.2, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [140] = { name = 'Solvente', weight = 0.2, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [141] = { name = 'Cetila+', weight = 0.2, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [142] = { name = 'Lança vazio', weight = 0.5, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [143] = { name = 'Safrol+', weight = 0.5, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [144] = { name = 'Metileno+', weight = 0.5, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [145] = { name = 'Tec-9', weight = 5, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        
        [146] = { name = 'Capsula 762mm', weight = 0.1, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [147] = { name = 'Capsula 9mm', weight = 0.1, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [148] = { name = 'Capsula 40mm', weight = 0.1, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [149] = { name = 'Capsula 12mm', weight = 0.1, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [150] = { name = 'Polvora', weight = 0.2, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [151] = { name = 'Tecido', weight = 0.2, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [152] = { name = 'Nylon 25mm', weight = 0.5, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [153] = { name = 'Nokia', weight = 0.5, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [154] = { name = 'Pasta explosiva', weight = 0.5, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [155] = { name = 'Fita', weight = 0.5, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [156] = { name = 'Cannabis seca', weight = 0.5, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [157] = { name = 'Madeira', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };

        [157] = { name = 'Acessorio 1', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [158] = { name = 'Acessorio 2', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [159] = { name = 'Acessorio 3', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [160] = { name = 'Acessorio 4', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [161] = { name = 'Acessorio 5', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [162] = { name = 'Acessorio 6', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [163] = { name = 'Acessorio 7', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [164] = { name = 'Acessorio 8', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [165] = { name = 'Acessorio 9', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [166] = { name = 'Acessorio 10', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [167] = { name = 'Acessorio 11', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [168] = { name = 'Acessorio 12', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [169] = { name = 'Acessorio 13', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [170] = { name = 'Acessorio 14', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [171] = { name = 'Acessorio 15', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [172] = { name = 'Acessorio 16', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [173] = { name = 'Acessorio 17', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [174] = { name = 'Acessorio 18', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [175] = { name = 'Acessorio 19', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [176] = { name = 'Acessorio 20', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [177] = { name = 'Acessorio 21', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [178] = { name = 'Acessorio 22', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [179] = { name = 'Acessorio 23', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [180] = { name = 'Acessorio 24', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [181] = { name = 'Acessorio 25', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [182] = { name = 'Acessorio 26', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [183] = { name = 'Acessorio 27', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [184] = { name = 'Acessorio 28', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [185] = { name = 'Acessorio 29', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [186] = { name = 'Acessorio 30', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [187] = { name = 'Acessorio 31', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [188] = { name = 'Acessorio 32', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [189] = { name = 'Acessorio 33', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [190] = { name = 'Acessorio 34', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [191] = { name = 'Acessorio 35', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [192] = { name = 'Acessorio 36', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [193] = { name = 'Acessorio 37', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [194] = { name = 'Acessorio 38', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [195] = { name = 'Acessorio 39', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [196] = { name = 'Acessorio 40', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [197] = { name = 'Acessorio 41', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [198] = { name = 'Acessorio 42', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [199] = { name = 'Acessorio 43', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [200] = { name = 'Acessorio 44', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [201] = { name = 'Acessorio 45', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [202] = { name = 'Acessorio 46', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [203] = { name = 'Acessorio 47', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [204] = { name = 'Acessorio 48', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [205] = { name = 'Acessorio 49', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [206] = { name = 'Acessorio 50', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [207] = { name = 'Acessorio 51', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [208] = { name = 'Acessorio 52', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [209] = { name = 'Acessorio 53', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [210] = { name = 'Acessorio 54', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [211] = { name = 'Acessorio 55', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [212] = { name = 'Acessorio 56', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [213] = { name = 'Acessorio 57', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [214] = { name = 'Acessorio 58', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [215] = { name = 'Acessorio 59', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [216] = { name = 'Acessorio 60', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [217] = { name = 'Acessorio 61', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [218] = { name = 'Acessorio 62', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [219] = { name = 'Acessorio 63', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [220] = { name = 'Acessorio 64', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [221] = { name = 'Acessorio 65', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [222] = { name = 'Acessorio 66', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [223] = { name = 'Acessorio 67', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [224] = { name = 'TDO', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = false, revistar = true } };
        [225] = { name = 'Acessorio 69', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [226] = { name = 'Acessorio 70', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [227] = { name = 'Acessorio 71', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [228] = { name = 'Acessorio 72', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [229] = { name = 'Acessorio 73', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [230] = { name = 'Acessorio 74', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [231] = { name = 'Acessorio 75', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [232] = { name = 'Acessorio 76', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [233] = { name = 'Acessorio 77', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [234] = { name = 'Acessorio 78', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [235] = { name = 'Acessorio 79', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [236] = { name = 'Acessorio 80', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [237] = { name = 'Acessorio 81', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [238] = { name = 'Acessorio 82', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [239] = { name = 'Acessorio 83', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [240] = { name = 'Acessorio 84', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [241] = { name = 'Acessorio 85', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [242] = { name = 'Acessorio 86', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [243] = { name = 'Acessorio 87', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [244] = { name = 'Acessorio 88', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [245] = { name = 'Acessorio 89', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [246] = { name = 'Acessorio 90', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [247] = { name = 'Acessorio 91', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [248] = { name = 'Acessorio 92', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [249] = { name = 'Acessorio 93', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [250] = { name = 'Acessorio 94', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [251] = { name = 'Acessorio 95', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [252] = { name = 'Acessorio 96', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [253] = { name = 'Acessorio 97', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [254] = { name = 'Acessorio 98', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [255] = { name = 'Acessorio 99', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [256] = { name = 'Acessorio 100', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [257] = { name = 'Acessorio 101', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [258] = { name = 'Acessorio 102', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [259] = { name = 'Acessorio 103', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [260] = { name = 'Acessorio 104', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [261] = { name = 'Acessorio 105', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [262] = { name = 'Acessorio 106', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [263] = { name = 'Acessorio 107', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [264] = { name = 'Acessorio 108', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [265] = { name = 'Acessorio 109', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [266] = { name = 'Acessorio 110', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [267] = { name = 'Acessorio 111', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [268] = { name = 'Acessorio 112', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [269] = { name = 'Acessorio 113', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [270] = { name = 'Acessorio 114', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [271] = { name = 'Acessorio 115', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [272] = { name = 'Acessorio 116', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [273] = { name = 'Acessorio 117', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [274] = { name = 'Acessorio 118', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [275] = { name = 'Acessorio 119', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [276] = { name = 'Acessorio 120', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [277] = { name = 'Acessorio 121', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [278] = { name = 'Acessorio 122', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [279] = { name = 'Acessorio 123', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [280] = { name = 'Acessorio 124', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [281] = { name = 'Acessorio 125', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [282] = { name = 'Acessorio 126', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [283] = { name = 'Acessorio 127', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [284] = { name = 'Acessorio 128', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [285] = { name = 'Acessorio 129', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [286] = { name = 'Acessorio 130', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [287] = { name = 'Acessorio 131', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [288] = { name = 'Acessorio 132', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [289] = { name = 'Acessorio 133', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [290] = { name = 'Acessorio 134', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [291] = { name = 'Acessorio 135', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [292] = { name = 'Acessorio 136', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [293] = { name = 'Acessorio 137', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [294] = { name = 'Acessorio 138', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [295] = { name = 'Acessorio 139', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [296] = { name = 'Acessorio 140', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [297] = { name = 'Acessorio 141', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [298] = { name = 'Acessorio 142', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [299] = { name = 'Acessorio 143', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [300] = { name = 'Acessorio 144', weight = 0.2, category = 'bag',  others = { usar = true, dropar = false, enviar = false, portamalas = false, bau = false, perder = false, revistar = false } };
        [301] = { name = 'Acessorio 145', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [302] = { name = 'Acessorio 146', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [303] = { name = 'Acessorio 147', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [304] = { name = 'Acessorio 148', weight = 0.2, category = 'bag',  others = { usar = true, dropar = false, enviar = false, portamalas = false, bau = false, perder = false, revistar = false } };
        [305] = { name = 'Acessorio 149', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [306] = { name = 'Acessorio 150', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [307] = { name = 'Acessorio 151', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [308] = { name = 'Acessorio 152', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };
        [309] = { name = 'Acessorio 153', weight = 0.2, category = 'bag',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = false } };

        [310] = { name = 'Semente de maconha', weight = 0.5, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [311] = { name = 'Semente de coca', weight = 0.5, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [312] = { name = 'Regador', weight = 0.5, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
       
        [313] = { name = 'Couro', weight = 0.5, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        [314] = { name = 'Chave de lock', weight = 0.5, category = 'ilegal',  others = { usar = true, dropar = true, enviar = true, portamalas = false, bau = false, perder = true, revistar = true } };
        
        --Mochilas facções
        [315] = { name = 'Jamaica', weight = 0.1, category = 'bag',  others = { usar = true, dropar = false, enviar = true, portamalas = false, bau = false, perder = false, revistar = true } };
        [316] = { name = 'Brasil', weight = 0.1, category = 'bag',  others = { usar = true, dropar = false, enviar = true, portamalas = false, bau = false, perder = false, revistar = true } };
        [317] = { name = 'Turquia', weight = 0.1, category = 'bag',  others = { usar = true, dropar = false, enviar = true, portamalas = false, bau = false, perder = false, revistar = true } };
        [318] = { name = 'Yakuza', weight = 0.1, category = 'bag',  others = { usar = true, dropar = false, enviar = true, portamalas = false, bau = false, perder = false, revistar = true } };
        [319] = { name = 'PCC', weight = 0.1, category = 'bag',  others = { usar = true, dropar = false, enviar = true, portamalas = false, bau = false, perder = false, revistar = true } };
        [320] = { name = 'Japão', weight = 0.1, category = 'bag',  others = { usar = true, dropar = false, enviar = true, portamalas = false, bau = false, perder = false, revistar = true } };
        [321] = { name = 'TCP', weight = 0.1, category = 'bag',  others = { usar = true, dropar = false, enviar = true, portamalas = false, bau = false, perder = false, revistar = true } };
        [322] = { name = 'CV', weight = 0.1, category = 'bag',  others = { usar = true, dropar = false, enviar = true, portamalas = false, bau = false, perder = false, revistar = true } };
        [323] = { name = 'Milicia', weight = 0.1, category = 'bag',  others = { usar = true, dropar = false, enviar = true, portamalas = false, bau = false, perder = false, revistar = true } };
        [324] = { name = 'Laranjas', weight = 0.1, category = 'bag',  others = { usar = true, dropar = false, enviar = true, portamalas = false, bau = false, perder = false, revistar = true } };
        [325] = { name = 'Uniao-Terrorista', weight = 0.1, category = 'bag',  others = { usar = true, dropar = false, enviar = true, portamalas = false, bau = false, perder = false, revistar = true } };
        [326] = { name = 'Croacia', weight = 0.1, category = 'bag',  others = { usar = true, dropar = false, enviar = true, portamalas = false, bau = false, perder = false, revistar = true } };
    
        [327] = { name = 'Escocia', weight = 0.1, category = 'bag',  others = { usar = true, dropar = false, enviar = true, portamalas = false, bau = false, perder = false, revistar = false } };
        [328] = { name = 'França', weight = 0.1, category = 'bag',  others = { usar = true, dropar = false, enviar = true, portamalas = false, bau = false, perder = false, revistar = false } };
        [329] = { name = 'Argentina', weight = 0.1, category = 'bag',  others = { usar = true, dropar = false, enviar = true, portamalas = false, bau = false, perder = false, revistar = false } };
        [330] = { name = 'Suiça', weight = 0.1, category = 'bag',  others = { usar = true, dropar = false, enviar = true, portamalas = false, bau = false, perder = false, revistar = false } };
        [331] = { name = 'FXP', weight = 0.1, category = 'bag',  others = { usar = true, dropar = false, enviar = true, portamalas = false, bau = false, perder = false, revistar = false } };
        [332] = { name = 'R7', weight = 0.1, category = 'bag',  others = { usar = true, dropar = false, enviar = true, portamalas = false, bau = false, perder = false, revistar = false } };
        [333] = { name = 'Haran', weight = 0.1, category = 'bag',  others = { usar = true, dropar = false, enviar = true, portamalas = false, bau = false, perder = false, revistar = false } };
        [334] = { name = 'Ballas', weight = 0.1, category = 'bag',  others = { usar = true, dropar = false, enviar = true, portamalas = false, bau = false, perder = false, revistar = false } };


        --  [2] = { name = 'Glock', weight = 1, category = 'ilegal', others = { enviar = true, portamalas = false, bau = false, perder = true, revistar = false } }
    };

}

function removeHex (s)  
    return s:gsub ("#%x%x%x%x%x%x", "") or false
end

_getPlayerName = getPlayerName

function getPlayerName ( player )
    return removeHex (_getPlayerName(player))  
   end

function getConfigItem (item)
    return config["itens"][item] or false 
end

sendMessageServer = function (player, msg, type)
    return exports['guetto_notify']:showInfobox(player, type, msg)
end;

sendMessageClient = function (msg, type)
    return exports['guetto_notify']:showInfobox(type, msg)
end;

function createEventHandler(event, ...)
    addEvent(event, true)
    addEventHandler(event, ...)
end

function sendLogs(title, description, fields, webhook)
    local data = {
        embeds = {
            {
                title = title,
                description = description,
                color = 0x00000000,
                fields = {},

                author = {
                    name = 'GCRP | AntiCheat',
                    icon_url = 'https://imgur.com/tTzPVPi.png'
                },

                footer = {
                    text = 'Pegasus AC © Todos os direitos reservados.',
                    icon_url = 'https://imgur.com/tTzPVPi.png',
                },

                thumbnail = {
                    url = 'https://imgur.com/tTzPVPi.png'
                },
            }
        }
    }

    for i, v in ipairs(fields) do
        if not v.id then
            v.id = i
        end

        table.insert(data.embeds[1].fields, fields[i])
    end

    data = toJSON(data)
    data = data:sub(2, -2)

    local post = {
        connectionAttempts = 5,
        connectTimeout = 7000,
        headers = {
            ['Content-Type'] = 'application/json'
        },
        postData = data
    }

    fetchRemote(webhook, post, function() end)
end