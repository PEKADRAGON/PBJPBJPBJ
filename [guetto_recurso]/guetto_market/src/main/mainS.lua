local marker_data = {}
local data_player = {}

local function onResourceStart ( )
    
    for i, v in ipairs ( config.markers ) do 
        local marker = createMarker(v[1], v[2], v[3] - 0.9, "cylinder", 1.4, 255, 255, 255, 0)
        local blip = createBlip (v[1], v[2], v[3], v[5])

        setElementData(marker, 'markerData', {title = 'Loja de itens', desc = 'Compre seus itens aqui!.', icon = 'shop'})
        
        setElementDimension(marker, v.dimensao)
        setElementInterior(marker, v.interior)

        marker_data[marker] = i
    end

end;

addEventHandler("onResourceStart", resourceRoot, onResourceStart)

local function onMarkerHit ( player, dimension )

    if not player or not isElement (player) or getElementType (player) ~= "player" or not dimension then 
        return false 
    end

    if not marker_data[source] then 
        return false 
    end

    local i = marker_data[source]
    local cfg = config.markers[i]

    triggerClientEvent (player, "onPlayerToggleInterface", resourceRoot, {true, cfg[4]} )
end

addEventHandler("onMarkerHit", resourceRoot, onMarkerHit)

local function onPlayerBuyItem (data, amount)

    if not (client or (resourceRoot ~= source)) then 
        return false 
    end

    data_player[client] = false;

    local amount_finish = amount * data["value"]
    
    if tonumber(amount) <= 0 then 
        takePlayerMoney(client, getPlayerMoney(client))
        setElementData(client, 'guetto.points', 0)
        return print ( getPlayerName(client).. ' Está tentando burlar o guetto_market!' )
    end

    if tonumber(data["value"]) <= 0 then 
        takePlayerMoney(client, getPlayerMoney(client))
        setElementData(client, 'guetto.points', 0)
        return print ( getPlayerName(client).. ' Está tentando burlar o guetto_market!' )
    end

    if tonumber(amount_finish) <= 0 then 
        takePlayerMoney(client, getPlayerMoney(client))
        setElementData(client, 'guetto.points', 0)
        return print ( getPlayerName(client).. ' Está tentando burlar o guetto_market!' )
    end

    if data["type"] == "money" then 
        local money = getPlayerMoney(client)
    
        if money < amount_finish then 
            return config.sendMessageServer(client, "Dinheiro insuficiente!", "error")
        end
    
        data_player[client] = true 
        takePlayerMoney(client, amount_finish)
    elseif data["type"] == "coins" then
        local coins = (getElementData(client, "guetto.points") or 0)

        if coins < amount_finish then
            return config.sendMessageServer(client, "Coins insuficientes!", "error")
        end

        data_player[client] = true 
        setElementData(client, "guetto.points", coins - amount_finish)
    end

    if data_player[client] then 
        exports["guetto_inventory"]:giveItem (client, data.item, amount)
        config.sendMessageServer(client, "Item comprado com sucesso!", "success")
    else
        config.sendMessageServer(client, "Ocorreu um erro!", "error")
    end
end

addEvent("onPlayerBuyItem", true)
addEventHandler("onPlayerBuyItem", resourceRoot, onPlayerBuyItem)