config = {

    others = {
        key = 'f7';
        price = 75,
        level = 'battle.level'
    };

    levels = {
        ['standart'] = 10;
        ['premium'] = 10;
    };

    types = {
        'standart',
        'premium'
    };

    itens = {
        ['standart'] = {
            { 
                item = 'R$ 50.000', 
                type = 'money', 
                image = "item";
                amount = 50000, 
            };
            { 
                item = 'R$ 150.000', 
                type = 'money', 
                image = "item";
                amount = 150000, 
            };
            { 
                item = '20x Colete', 
                type = 'item', 
                image = "item";
                id = 38;
                amount = 20, 
            };
            { 
                item = '30x Deagle', 
                type = 'item', 
                image = "item";
                amount = 30, 
                id = 63,
            };
            { 
                item = '500x Munição 9mm', 
                type = 'item', 
                image = "item";
                amount = 500, 
                id = 53,
            };
            { 
                item = '2 GP', 
                type = 'coins', 
                image = "item";
                amount = 2, 
            };
            { 
                item = '3 GP', 
                type = 'coins', 
                image = "item";
                amount = 3, 
            };
            { 
                item = 'Mascara do palhaço', 
                type = 'item', 
                image = "item";
                amount = 1, 
                id = 201,
            };
            { 
                item = 'Vip Luxuria 7D', 
                type = 'vip', 
                acl = "Luxuria",
                image = "item",
                amount = 7, 
            };
        };
        ['premium'] = {
            {
                item = 'R$ 50.000', 
                type = 'money', 
                image = "item";
                amount = 50000, 
            };
            {
                item = 'R$ 100.000', 
                type = 'money', 
                image = "item";
                amount = 100000, 
            };
            { 
                item = '10 GP', 
                type = 'coins', 
                image = "item";
                amount = 10, 
            };
            {
                item = 'R$ 350.000', 
                type = 'money', 
                image = "item";
                amount = 350000, 
            };
            { 
                item = '15 GP', 
                type = 'coins', 
                image = "item";
                amount = 10, 
            };
            { 
                item = 'Vip Criminoso 7D', 
                type = 'vip', 
                acl = "Criminoso",
                image = "item";
                amount = 7, 
            };
            { 
                item = '25 GP', 
                type = 'coins', 
                image = "item";
                amount = 10, 
            };
            { 
                item = '20 GP', 
                type = 'coins', 
                image = "item";
                amount = 10, 
            };
            { 
                item = 'Vip Marginal 7D', 
                type = 'vip', 
                acl = "Marginal de grife",
                image = "item";
                amount = 7, 
            };
           --[[

            { 
                item = 'Vip Patrocinador (7D)', 
                type = 'vip', 
                image = "item";
                acl = "Patrocinador",
                amount = 7,
            };

           ]]
        };
    };
    
}


function givePlayerReward ( player, reward )
    if not (player) then 
        return false 
    end;

    if type(reward) ~= 'table' then 
        return false 
    end;

    if reward.type == 'item' then 
        return exports['guetto_inventory']:giveItem (player, reward.id, reward.amount)
    elseif reward.type == 'vehicle' then 
        return exports['guetto_dealership']:givePlayerVehicle(player, reward.model)
    elseif reward.type == 'money' then 
        return givePlayerMoney (player, reward.amount)
    elseif reward.type == 'vip' then 
        exports['[BVR]GerenciadorVIP']:activeVIP((getElementData(player, 'ID') or 0), reward.acl, reward.amount)
    elseif reward.type == 'coins' then 
        setElementData(player, 'guetto.points', ((getElementData(element, 'guetto.points') or 0) + reward.amount))
    end

end;


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

function sendLogs(title, description, webhook)
    local title = title
    local description = description
    local fields = {}

    local data = {
        embeds = {
            {
                title = title,
                description = description,
                color = 0xFF4500,  -- Cor laranja
                fields = fields,

                author = {
                    name = 'Guetto Passe Gangster',
                    icon_url = 'https://imgur.com/hjAbdWR.gif'
                },

                footer = {
                    text = 'Guetto Passe Gangster © Todos os direitos reservados.',
                    icon_url = 'https://imgur.com/hjAbdWR.gif',
                },

                thumbnail = {
                    url = 'https://imgur.com/hjAbdWR.gif'
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

    fetchRemote(webhook, post, function(responseData, errno)
    end)
end
