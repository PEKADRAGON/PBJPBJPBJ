config = {

    blockers = {
        ['binds'] = {
            ['b'] = true, --| Teclas a serem bloqueadas quando o jogador está algemado.
            ['c'] = true, --| Teclas a serem bloqueadas quando o jogador está algemado.
            ['shift'] = true, --| Teclas a serem bloqueadas quando o jogador está algemado.
            ['f'] = true,
            ['f1'] = true
        },
    };

    interactions = {"player", "SAMU", "policial", "gang"},

    interactions_settings = {
        
        ["player"] = {
            type = "acl",
            elementData = false,
            icon = 'images/icon-user.png',
            size = {21, 21},
            acl = "Everyone"
        };

        ["SAMU"] = {
            type = "acl",
            elementData = "service.samu",
            icon = 'images/icon-samu.png',
            size = {21, 21},
            acl = "SAMU"
        };

        ["policial"] = {
            type = "acl",
            elementData = "service.police",
            icon = 'images/icon-police.png',
            size = {21, 21},
            acl = "Corporação"
        };

        ["gang"] = {
            type = "acl",
            elementData = "service.gang",
            icon = 'images/icon-gang.png',
            size = {21, 21},
            acl = "Facção"
        };

    };

    interaction = {
        
        ['player'] = {

            ["player"] = {
                {name = "Enviar dinheiro"};
                {name = "Enviar GP"};
                {name = "Solicitar beijo"};
                {name = "Propor Sexo"};
            };
    
            ["policial"] = {
                {name = "Checar CNH"};
                {name = "Algemar"};
                {name = "Carregar"};
                {name = "Revistar"};
                {name = "Ver Porte"};
            };
    
            ["gang"] = {
                {name = "Saquear"};
                {name = "Amarrar"};
                {name = "Encapuzar"};
                {name = "Carregar"};
            };
    
            ["SAMU"] = {
                {name = "Curar"};
                {name = "Carregar"};
            };

        };
        
        ['vehicle'] = {
            ['default'] = {
                {name = 'Porta Malas'};
                {name = 'Colocar no Porta-malas'};
                {name = 'Checar Porta-malas'};
                {name = 'Check-up'};
            };
        };

        ["object"] = {
            [1574] = {
                {name = "Plantação Detalhada"};
                {name = "Plantar Cocaina"};
                {name = "Plantar Maconha"};
                {name = "Pegar Vaso"};
                {name = "Destuir plantação"};
            };
        };


    };

    vehicles = { -- Lista de veículos bloqueados para conduzir
        
        [596] = true 

    };
    
}

function getPlayerInteraction(player)
    if not player or not isElement(player) then 
        return false 
    end

    local cache = {}
    local account = getAccountName(getPlayerAccount(player))

    for _, interaction in ipairs(config.interactions) do 
        local settings = config.interactions_settings[interaction]
        
        if settings.type == 'acl' then
            local aclGroup = aclGetGroup(settings.acl)
            if not aclGroup then 
                print('Interaction - Acl: '..settings.acl.. ' não está criada!')
            end
            if isObjectInACLGroup('user.'..account, aclGroup) then
                if not settings.elementData or getElementData(player, settings.elementData) then 
                    table.insert(cache, interaction)
                end
            end
        end
    end

    return cache
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
    if player and isElement(player) and getElementType(player) == 'player' then 
        return removeHex (_getPlayerName(player))
    end
    return 'Undefined'
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