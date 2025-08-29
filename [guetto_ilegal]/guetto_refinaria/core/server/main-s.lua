local timer = {}
local marker = {}

addEventHandler('onResourceStart', resourceRoot, function ()
    
    for index, value in ipairs(config["Markers"]) do 
        local marker = createMarker(value[1], value[2], value[3] - 1, 'cylinder', 1.5, 139, 100, 255, 20)
        addEventHandler('onMarkerHit', marker, function (player, dim)
            if (player and isElement(player) and getElementType(player) == 'player' and dim) then 
                if not isPedInVehicle(player) then 
                    local account = getAccountName(getPlayerAccount(player))
                    if (isObjectInACLGroup("user."..account, aclGetGroup(value[4]) )) then 
                        triggerClientEvent(player, "onPlayerControllerInterface", resourceRoot, 'add')
                    end
                end
            end
        end)
    end

end)

addEvent("onPlayerStartFactory", true)
addEventHandler("onPlayerStartFactory", resourceRoot, function ( player, ... )

    if not (client or (source ~= resourceRoot)) then 
        return false 
    end

    if client ~= player then 
        return false 
    end

    local ARGS = ...

    if not ARGS or type(ARGS) ~= 'table' then 
        return false 
    end

    local data = config["Drogas"][ARGS.drug]

    if not (data) then 
        return false 
    end

    local amount = exports["guetto_inventory"]:getItem(player, data["DrogaNecessaria"])

    if (amount < ARGS.amount) then 
        return sendMessageServer(player, "Você não tem drogas suficientes", "error")
    end

    setElementFrozen(player, true)
    setPedAnimation(player, "BD_FIRE", "wash_up", config["Others"]["TimeFactory"] * ARGS.amount)
    toggleAllControls(player, false)

    timer[player] = setTimer(function (player)
        if (player and isElement(player)) then 
            
            setPedAnimation(player)
            setElementFrozen(player, false)
            toggleAllControls(player, true)
            
            exports["guetto_inventory"]:giveItem(player, data["DrogaRecebe"], ARGS.amount)
            sendMessageServer(player, "Voce refinou a droga com sucesso!", "success")
 
        end 
    end, config["Others"]["TimeFactory"] * ARGS.amount, 1, player)

    exports["guetto_inventory"]:takeItem(player, data["DrogaNecessaria"], ARGS.amount)

    sendMessageServer(player, "Voce começou a refinar a droga", "success")
    triggerClientEvent(player, "onPlayerControllerInterface", resourceRoot, 'remove')
end) 