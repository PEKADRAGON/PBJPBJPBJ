local config = getConfig ();
local instance = {};
instance.connection = nil;
instance.call = {};
instance.colshape = {};

-- function's resource.
function startDB ()
    if not (instance.connection) then
        instance.connection = dbConnect ('sqlite', 'assets/database/database.db');

        if not (instance.connection) then
            outputDebugString (Resource.getThis ().name..': Failed connection.', 4, 255, 50, 50);
            cancelEvent ();
            return false;
        end

        dbExec (instance.connection, [[CREATE TABLE IF NOT EXISTS `avaliation` (
            accountName VARCHAR(255),
            stars INTEGER
        )]]);

        outputDebugString (Resource.getThis ().name..': Connected.', 4, 50, 255, 50);
    end
end

function insertCall (tbl)
    if not tbl or type (tbl) ~= 'table' then
        return false;
    end

    table.insert (instance.call, tbl);
end

function getCallFromID (id)
    if not (id and tonumber (id)) then
        return false;
    end

    for i, v in ipairs (instance.call) do
        if (v.id == id) then
            return i;
        end
    end

    return false;
end

function deleteCallFromID (id)
    if not (id and tonumber (id)) then
        return false;
    end

    local index = getCallFromID (id);

    if not (index) then
        return false;
    end

    instance.call[index].status = true;

    setTimer (function ()
        table.remove (instance.call, index);
    end, 5000, 1);
end

function getOwnerSphere (sphere)
    if not (sphere) then
        return false;
    end

    for i, v in ipairs (instance.call) do
        if (v.sphere == sphere) then
            return i;
        end
    end

    return false;
end

function sendMessageStaffs ( )
    for _, player in ipairs (getElementsByType('player')) do 
        if (getElementData(player, 'onProt')) then 
            message('server', player, 'Você tem um chamado em aberto. Para visualizar os detalhes, digite /chamados', 'info')
        end
    end
end

-- event's resource.
addEventHandler ('onResourceStart', resourceRoot, function ()

       
    if (config.Geral.panel.manager.type == 'bind') then
        for _, player in ipairs (getElementsByType ('player')) do
            if (isGuestAccount (getPlayerAccount (player))) then
                return false;
            end

            bindKey (player, config.Geral.panel.manager.key_bind, 'down', function ()
                if not (player and isElement (player) and getElementType (player) == 'player') then
                    return false;
                end
                
                if not (player:getType () == 'player' and player) then
                    return false;
                end

                if (config.Geral.panel.manager.requiresService) then
                    if not (getElementData (player, config.Datas.staff)) then
                        return false;
                    end
                end

                if not (isElementHavePermission (player, config.Geral.panel.manager.acl)) then
                    return false;
                end
    
                triggerClientEvent (player, 'atlas_resources.clientManagerPanel', resourceRoot, 'show-manager', instance.call);
            end);
        end
    end

    startDB ();
    return outputDebugString (Resource.getThis ().name..': Started.', 4, 50, 255, 50);
end);


createEventHandler ('atlas_resources.managerCall', resourceRoot, function (...)
    local player = client;

    if not (player and player == client and source == resourceRoot) then
        return false;
    end
    if not (player and player:getType () == 'player' and client) then
        return false;
    end

    local ARGS = {...};

    if not (#ARGS >= 1) then
        return false;
    end

    if not ARGS or type (ARGS) ~= 'table' then
        return false;
    end

    local actionName = ARGS[1].actionName;
    
    if not (actionName and tostring (actionName)) then
        return false;
    end

    if not (actionName ~= 'call') then
        local callReason, callDescription = ARGS[1].args.reason, ARGS[1].args.description;
        local id = (getElementData (player, 'ID') or 'N/A');

        if not (id) then
            return false;
        end

        if (getCallFromID (id)) then
            message ('server', player, 'Você já possui um chamado aberto.', 'error');
            return false;
        end

        message ('server', player, 'Chamado aberto com sucesso.', 'success');
        local x, y, z = getElementPosition(player);

        insertCall (
            {
                player = player;
                name = string.gsub (getPlayerName (player), '#%x%x%x%x%x%x', '');
                reason = callReason;
                description = callDescription;
                id = id;
                idCall = math.random (1, 999);
                hourCalled = getRealTime ().timestamp;
                timeWaited = getTickCount ();
                status = false;
                sphere = createColSphere (x, y, z, 10);
            }
        );

        setTimer(function(player, id)
            if player and isElement(player) then 
                message('server', player, 'Seu chamado expirou. Por favor, abra um novo chamado para que possamos continuar ajudando você.', 'info')
            end

            deleteCallFromID (id);
        end, 5 * 60000, 1, player, #instance.call)

        sendMessageStaffs()

    elseif not (actionName ~= 'accept-call') then
        local id = ARGS[1].args.id;
        
        if not (id and tonumber (id)) then
            return false;
        end

        local index = getCallFromID (id);

        if not (index and tonumber (index)) then
            return false;
        end

        local position = {getElementPosition (instance.call[index].player)};
        
        setElementPosition (player, position[1], position[2], position[3]);
    elseif not (actionName ~= 'stars') then
        local stars = ARGS[1].args.quantity;
        local staff = ARGS[1].args.staff;

        if not (stars and tonumber (stars)) then
            return false;
        end

        if not (staff and isElement (staff)) then
            return false;
        end

        local query = dbPoll (dbQuery (instance.connection, [[SELECT * FROM `avaliation` WHERE `accountName` = ?]], getAccountName (getPlayerAccount (staff))), -1);

        if (query and #query == 0) then
            dbExec (instance.connection, [[INSERT INTO `avaliation` (`accountName`, `stars`) VALUES (?, ?)]], getAccountName (getPlayerAccount (staff)), stars);
        else
            dbExec (instance.connection, [[UPDATE `avaliation` SET `stars` = ? WHERE `accountName` = ?]], query[1].stars + stars, getAccountName (getPlayerAccount (staff)));
        end
        
        local logs = {
            { name = '👨‍💻・Staff', value = getPlayerName(staff).." # "..(getElementData(staff, "ID") or "N/A"), inline = false },
            { name = '⭐・Estrelas', value = stars, inline = false },
            { name = '🌟・Total de estrelas', value = query[1].stars + stars, inline = false },
        }

        message ('server', player, 'Avaliação enviada com sucesso.', 'success');
        sendLogs("Avaliação Staff! ", "Segue abaixo as informações da nova avaliação:", logs, "https://discord.com/api/webhooks/1261663404012339270/3XluQXy-SuYl2ML4kLMzfi0UPk5YN8dA5SMxn6NxmN65Lqfqi70lAlbqE2OjLr969OmV")
    end
end);

addEventHandler ('onColShapeLeave', resourceRoot, function (player, dim)
    if (player and isElement (player) and player:getType () == 'player' and dim) then
        local index = getOwnerSphere (source);
        
        if not (index) then
            return false;
        end
        if (getElementData (player, config.Datas.staff) and isElementHavePermission (player, 'Staff')) then
            local data = instance.call[index];
            if (data.player and isElement (data.player) and data.player:getType () == 'player' and data.player ~= player) then
                deleteCallFromID (data.id);
                triggerClientEvent (data.player, 'atlas_resources.clientManagerPanel', resourceRoot, 'show-avaliation', player);
            end
        end
    end
end);

addCommandHandler (config.Geral.panel.manager.command, function (player)

    if not (player and isElement (player) and getElementType (player) == 'player') then
        return false;
    end

    if not (player:getType () == 'player' and player) then
        return false;
    end

    if (config.Geral.panel.manager.requiresService) then
        if not (getElementData (player, config.Datas.staff)) then
            return false;
        end
    end

    if not (isElementHavePermission (player, config.Geral.panel.manager.acl)) then
        return false;
    end

    triggerClientEvent (player, 'atlas_resources.clientManagerPanel', resourceRoot, 'show-manager', instance.call, getTickCount());
end);

for _, player in ipairs (getElementsByType ('player')) do
    bindKey (player, config.Geral.panel.call.key_bind, 'down', function ()
        if not (player and isElement (player) and getElementType (player) == 'player') then
            return false;
        end
        triggerClientEvent (player, 'atlas_resources.clientManagerPanel', resourceRoot, 'show');
    end);
end

function openPanel ( player )
    bindKey (player, 'f9', 'down', function ()
        triggerClientEvent (player, 'atlas_resources.clientManagerPanel', resourceRoot, 'show');
    end);
end

addEventHandler('onPlayerLogin', root, function ( )
    openPanel(source)
end)

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
                    text = 'Guetto Avaliações © Todos os direitos reservados.',
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