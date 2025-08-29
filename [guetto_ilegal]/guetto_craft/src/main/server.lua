local marker_data = {}
local timer = {}

addEventHandler('onMarkerHit', resourceRoot, function (player, dimension)
    if (player and isElement(player) and getElementType(player) == "player" and not isPedInVehicle(player) and dimension) then 
        if not (marker_data[source]) then 
            return false 
        end
        local data = marker_data[source];

        if getPlayerAcl(player, data.markerAcl) then 
            triggerClientEvent(player, 'onPlayerToggleCraft', resourceRoot, data)
        else
            sendMessageServer(player, 'Você não possui permissão para craftar itens aqui!', 'info')
        end
    end
end)

function getPlayerItens (player, tbl, multiply)
    if not player then 
        return false 
    end

    local result = false;

    for i = 1, #tbl do 
        local amount = exports['guetto_inventory']:getItem(player, tbl[i].item)
        if amount >= (tbl[i].amount * tonumber(multiply)) then 
            result = true 
        else
            result = false
        end
    end

    return result
end

function takeItens (player, tbl, multiply)
    if not player then 
        return false 
    end

    for i = 1, #tbl do 
        local amount = exports['guetto_inventory']:getItem(player, tbl[i].item)
        exports['guetto_inventory']:takeItem(player, tbl[i].item, tbl[i].amount * tonumber(multiply))
    end
end

createEventHandler("onPlayerStartCraft", resourceRoot, function(...)

    if source ~= getResourceDynamicElementRoot ( getResourceFromName ( getResourceName ( getThisResource() ) ) ) then 
        return outputDebugString(string.format(
            "Tentativa de Burlar o Trigger onPlayerExecuteInteraction Detectada! Infos: Client | %s | ID %s | IP %s",
            getPlayerName(client), (getElementData(client, 'ID') or 'N/A'), getPlayerIP(client)
        ), 1)
    end

    if timer[client] and isTimer(timer[client]) then 
        return sendMessageServer(client, "Você já está fabricando um item!", "error")
    end

    local args = ...;

    if tonumber(args.amount) <= 0 then 
        return false 
    end

    local data = config.factory[args.item]
    local getItens = getPlayerItens (client, data, args.amount)

    if not (getItens) then 
        return sendMessageServer(client, 'Você não possui todos os itens!', 'error')
    end

    takeItens(client, data, args.amount)
    sendMessageServer(client, "Você começou a fabricar o item "..(args.item).." com sucesso!", "success")
    setPedAnimation(client, "bd_fire", "wash_up", -1, true)

    timer[client] = setTimer(function(player, item, quantidade)
        if player and isElement(player) then 

            exports['guetto_inventory']:giveItem(player, config['itens'][item], tonumber(quantidade))
            exports['guetto_inventory']:giveItem(player, config['munis'][item], 300)
        
            local xp = (getElementData(player, "XP") or 0)
            local xp_qnt = 800 * tonumber(args.amount)
            

            setPedAnimation(player)
            setElementData(player, "XP", xp + xp_qnt )
            sendMessageServer(player, "Você fabricou "..(args.item).." e recebeu "..(xp_qnt).."XP com sucesso!", "success")
        end

    end, 5000 * args.amount, 1, client, args.item, args.amount)

    triggerClientEvent(client, 'onPlayerShowCraft', resourceRoot)
    exports["guetto_progress"]:callProgress(client, "Fabricando arma", "Você está fabricando uma arma!", "martelo", 10000 * args.amount)
end)

addEventHandler('onResourceStart', resourceRoot, function ()
    for i, v in ipairs (config.locations) do 
        local marker = createMarker(unpack(v.markerPos))
        setElementData(marker, 'markerData', {title = 'Fabricação', desc = 'Crie seus itens', icon = 'pickaxe'})
        marker_data[marker] = v;
    end
end)

