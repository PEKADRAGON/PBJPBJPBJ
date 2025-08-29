local salary_collected = {}
local vehicle = {}

local function createEvent ( event, ... )
    addEvent( event, true )
    addEventHandler(event, ...)
end

createEvent('onPlayerRedeemItem', resourceRoot, function ( player, ... )
    if not (client or ( source ~= resourceRoot) ) then 
        return false 
    end

    if client ~= player then 
        return false 
    end
    
    local ARGS = ...
    local decode = teaDecode(ARGS['encode'], ARGS['key'])
    local settings = config["Vips"][ARGS['window']][ARGS['category']][ARGS['index']]
    local bool, acl = getPlayerAcl(player, ARGS['window'])
    
    exports["guetto_inventory"]:giveItem(player, settings['Item'], settings['Quantidade'])
    sendMessageServer(player, 'Voce recebeu '..settings['Quantidade']..'x '..settings['Name']..'.', 'success')
end)

createEvent("onPlayerRedeemVehicle", resourceRoot, function ( player, ... )
    if not (client or ( source ~= resourceRoot) ) then 
        return false 
    end

    if client ~= player then 
        return false 
    end

    local ARGS = ...
    local decode = teaDecode(ARGS['encode'], ARGS['key'])
    local settings = config["Vips"][ARGS['window']][ARGS['category']][ARGS['index']]
    local bool, acl = getPlayerAcl(player, ARGS['window'])

    
    if vehicle[player] and isElement(vehicle[player]) then 
        destroyElement(vehicle[player])
        vehicle[player] = nil 
    end
    
    local x, y, z = getElementPosition(player);
    vehicle[player] = createVehicle(settings['Modelo'], x, y, z)

    sendMessageServer(player, 'Voce recebeu o veículo '..settings['Name']..' na sua garagem.', 'success')
end)

createEvent("onPlayerRequestVips", resourceRoot, function ( player )
    if not (client or ( source ~= resourceRoot) ) then 
        return false 
    end

    if client ~= player then 
        return false 
    end

    local account = getAccountName (getPlayerAccount(player));
    local temp = {}

    for index, value in pairs (config['Vips']) do
        local bool, acl = getPlayerAcl(player, index)
        if bool then 
            temp[acl] = {
                remaining = getPlayerVipRestant(player)
            }
        end
    end

    triggerClientEvent(player, "onClientSendPlayerVips", resourceRoot, temp)
end)

createEvent("onPlayerRedeemSalary", resourceRoot, function (player, ...)
    if not (client or ( source ~= resourceRoot) ) then 
        return false 
    end

    if client ~= player then 
        return false 
    end

    local ARGS = ...

    local ARGS = ...
    local decode = teaDecode(ARGS['encode'], ARGS['key'])
    local bool, acl = getPlayerAcl(player, ARGS['window'])
    
    local account = getAccountName (getPlayerAccount(player));

    if not salary_collected[account] then 
        salary_collected[account] = {}
    end

    if salary_collected[account][ARGS['window']] and getTickCount ( ) - salary_collected[account][ARGS['window']] < (20 * 60000) then
        return sendMessageServer(player, 'Aguarde 20 minutos para coletar seu salário novamente!', 'error')
    end

    givePlayerMoney(player, config["Vips"][ARGS["window"]]["Salario"])
    sendMessageServer(player, 'Seu salário foi coletado com sucesso!', 'success')
end)