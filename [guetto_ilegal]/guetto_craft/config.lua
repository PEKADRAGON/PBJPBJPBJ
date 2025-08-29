config = {

    factory = {
        ["AK47"] = {
           
            {item = 135, amount = 1};
            {item = 136, amount = 1};
        };
        ["PARAFAL"] = {
            {item = 133, amount = 1};
            {item = 134, amount = 1};
        };
        ["DEAGLE"] = {
            {item = 130, amount = 1};
            {item = 129, amount = 1};
        };
        ["GLOCK"] = {
            {item = 131, amount = 1};
            {item = 129, amount = 1};
        };
        ["TEC-9"] = {
           
            {item = 137, amount = 1};
            {item = 138, amount = 1};
        };
        ["GLOCK PL"] = {
            {item = 131, amount = 1};
            {item = 129, amount = 1};
            {item = 139, amount = 1};
        };
        ["40MM"] = {
           
            {item = 148, amount = 1};
            {item = 150, amount = 1};
        };
        ["9MM"] = {
            {item = 147, amount = 1};
            {item = 150, amount = 1};
        };
        ["12MM"] = {
           
            {item = 149, amount = 1};
            {item = 150, amount = 1};
        };
        ["762x39MM"] = {
           
            {item = 146, amount = 1};
            {item = 150, amount = 1};
        };
        ["762x45MM"] = {
           
            {item = 146, amount = 1};
            {item = 150, amount = 1};
        };
        ["762x51MM"] = {
           
            {item = 146, amount = 1};
            {item = 150, amount = 1};
        };
        ["COLETE"] = {
           
            {item = 151, amount = 1};
            {item = 152, amount = 1};
        };
        ["EXPLOSIVO"] = {
            {item = 153, amount = 1};
            {item = 154, amount = 1};
            {item = 155, amount = 2};
        };
        ["MACONHA"] = {
           
            {item = 98, amount = 1};
            {item = 156, amount = 1};
        };
        ["COCAINA"] = {
           
            {item = 118, amount = 1};
            {item = 122, amount = 1};
        };
        ["LOCKPICK"] = {
           
            {item = 313, amount = 1};
            {item = 314, amount = 1};
        };
    };

    itens = {
        ["AK47"] = 59;
        ["PARAFAL"] = 57;
        ["DEAGLE"] = 63;
        ["GLOCK"] = 62;
        ["TEC-9"] = 145;
        ["GLOCK PL"] = 65;
        ["40MM"] = 51;
        ["12MM"] = 52;
        ["9MM"] = 53;
        ["762x39MM"] = 54;
        ["762x45MM"] = 55;
        ["762x51MM"] = 56;
        ["COLETE"] = 38;
        ["EXPLOSIVO"] = 70;
        ["MACONHA"] = 96;
        ["COCAINA"] = 124;
        ["LOCKPICK"] = 49;
    };

    munis = { -- I  DA MUNIÇÃO DE CADA ARMA

       -- ["TEC-9"] = 1; 
       -- ["GLOCK PL"] = 1; 
    };

    locations = {

        {markerPos = {1361.483, -154.431, 22.303 - 0.9, 'cylinder', 1.5, 139, 100, 255, 0}, markerAcl = 'KATIARA', factory = { 'LOCKPICK' } };
        {markerPos = {-432.463, -1766.732, 7.854 - 0.9, 'cylinder', 1.5, 139, 100, 255, 0}, markerAcl = 'CND', factory = { 'GLOCK', 'GLOCK PL', 'AK47' } };
        {markerPos = {2660.229, -761.836, 92.939 - 0.9, 'cylinder', 1.5, 139, 100, 255, 0}, markerAcl = 'TDF', factory = { '762x39MM', 'MACONHA' } };
        {markerPos = {-746.547, -1110.641, 60.97 - 0.9, 'cylinder', 1.5, 139, 100, 255, 0}, markerAcl = 'CV', factory = { '762x39MM', '9MM' } };
        {markerPos = {-1093.826, -1666.547, 76.389 - 0.9, 'cylinder', 1.5, 139, 100, 255, 0}, markerAcl = 'UT', factory = { 'AK47', '762x39MM' } };

        {markerPos = {1966.005, 174.963, 36.525 - 0.9, 'cylinder', 1.5, 139, 100, 255, 0}, markerAcl = 'YKZ', factory = { 'AK47', '762x39MM', 'LOCKPICK' } };

        {markerPos = {2513.699, -1235.864, 39.788 - 0.9, 'cylinder', 1.5, 139, 100, 255, 0}, markerAcl = 'TD7', factory = { 'GLOCK', 'GLOCK PL', 'AK47' } };
     --   {markerPos = {531.875, 1451.644, 13.789 - 0.9, 'cylinder', 1.5, 139, 100, 255, 0}, markerAcl = 'PJL', factory = { 'AK47' } };
        {markerPos = {1536.649, -2893.874, 8.589 - 0.9, 'cylinder', 1.5, 139, 100, 255, 0}, markerAcl = 'MLC', factory = { 'LOCKPICK' } };
        {markerPos = {-463.154, -10.585, 60.41 - 0.9, 'cylinder', 1.5, 139, 100, 255, 0}, markerAcl = 'TDC', factory = { '762x39MM', 'AK47' } };
        {markerPos = {531.866, 1451.602, 13.789 - 0.9, 'cylinder', 1.5, 139, 100, 255, 0}, markerAcl = 'PCC', factory = { 'GLOCK PL', 'GLOCK', 'AK47', '762x39MM', '9MM' } };

        {markerPos = {2674.188, -2030.148, 14.248 - 0.9, 'cylinder', 1.5, 139, 100, 255, 0}, markerAcl = 'R7', factory = { 'GLOCK', 'GLOCK PL' } };

        {markerPos = {1994.575, -787.689, 133.27 - 0.9, 'cylinder', 1.5, 139, 100, 255, 0}, markerAcl = 'Console', factory = { 'GLOCK', 'GLOCK PL', 'AK47' } };

    };

    labels = {
        ["AK47"] = {
            title = "Arma de combate",
            description = "O AK-47, ou AK como é oficialmente conhecida, também conhecida como Kalashnikov, é\num fuzil de assalto de calibre 7,62x39mm criado em 1947 por Mikhail Kalashnikov e produzido na União Soviética pela indústria estatal IZH."
        };
        ["MACONHA"] = {
            title = "Droga",
            description = "Cannabis sativa é uma planta herbácea da família das Canabiáceas\n amplamente cultivada em muitas partes do mundo."
        };
        ['GLOCK'] = {
            title = "Droga",
            description = "Cannabis sativa é uma planta herbácea da família das Canabiáceas\n amplamente cultivada em muitas partes do mundo."
        };
        ['GLOCK PL'] = {
            title = "Droga",
            description = "Cannabis sativa é uma planta herbácea da família das Canabiáceas\n amplamente cultivada em muitas partes do mundo."
        };
        ["BOMBA"] = {
            title = "Bomba",
            description = "Bomba caseira, normalmente usada e feita por bandidos para destruir estruturas fisicas\nmanipular este produto pode te levar a morte."
        };
        ["762x39MM"] = {
            title = "Munição",
            description = "Munição utilizada em armas de grosso calibre."
        };
        ["9MM"] = {
            title = "Munição",
            description = "Munição utilizada em armas de pequeno calibre."
        };
        ["LOCKPICK"] = {
            title = "Lockpick",
            description = "Arrombamento de fechadura é a prática de destravar uma fechadura manipulando os componentes do dispositivo de fechadura sem a chave original. Usado em veículos."
        };
        ["COCAINA"] = {
            title = "Droga",
            description = "A cocaína, benzoilmetilecgonina ou éster do ácido benzoico, também conhecida por coca, é\num alcaloide, estimulante, com efeitos anestésicos utilizada fundamentalmente como uma droga recreativa. Pode ser aspirada, fumada ou injectada."
        };
        ["LSD"] = {
            title = "Droga",
            description = "A dietilamida do ácido lisérgico é uma substância alucinógena. É uma droga cristalina, que ocorre naturalmente como resultado das reações metabólicas do fungo Claviceps purpurea."
        };
        ["CRISTAL"] = {
            title = "Metanfetamina",
            description = "A metanfetamina vendida como droga nas ruas é também conhecida como meth, cristal, Tina, ou ice. Cristal, como o nome diz, são uns cristais brancos ou incolores, como açúcar, que podem ser esmagados para virar pó."
        };
        ["COLETE"] = {
            title = "Colete",
            description = "Colete balístico são vestimentas protegem os utilizadores contra projéteis ou destroços de artefatos militares. Normalmente são feitos de Kevlar, uma fibra de aramida, material sintético semelhante ao náilon, leve e flexível mas cinco vezes mais resistente que o aço."
        };
    };

}


function getPlayerAcl ( player, acl )
    if not player then 
        return false
    end;

    if not acl then 
        return false 
    end;

    local account = getAccountName (getPlayerAccount(player));

    if isObjectInACLGroup('user.'..account, aclGetGroup(acl)) then 
        return true 
    end

    return false 
end

function createEventHandler (eventName, ...)
    addEvent (eventName, true)
    return addEventHandler (eventName, ...);
end

function removeHex (s)
    return s:gsub ("#%x%x%x%x%x%x", "") or false
end

_getPlayerName = getPlayerName

function getPlayerName ( player )
    return removeHex (_getPlayerName(player))
end

sendMessageServer = function (player, msg, type)
    return exports['guetto_notify']:showInfobox(player, type, msg)
end;

sendMessageClient = function (msg, type)
    return exports['guetto_notify']:showInfobox(type, msg)
end;

function formatNumber (number, stepper)
    local left, center, right = string.match (math.floor (number), '^([^%d]*%d)(%d*)(.-)$');
    return left .. string.reverse (string.gsub (string.reverse (center), '(%d%d%d)', '%1' .. (stepper or '.'))) .. right;
end