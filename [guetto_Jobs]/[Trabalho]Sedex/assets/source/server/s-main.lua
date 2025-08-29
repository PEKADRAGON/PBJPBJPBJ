local data = {};
local player = {};
local routes = {};
local orders = {};

local function savePlayerData(element)
    if (isElementPlayer(element)) then
        player[element] = getElementModel(element);
        return true;
    end
    return false;
end

local function loadPlayerData(element)
    if (isElementPlayer(element)) then
        setElementModel(element, player[element]);
        return true;
    end
    return false;
end

local function onRoutesHitted(element)
    if (isElementPlayer(element)) then
        if (not isPedInVehicle(element)) then
            if (data[element]) then
                if (routes[element] == source) then
                    if (data[element].obj and isElement(data[element].obj)) then
                        setPedAnimation(element, "CARRY", "putdwn", 1.0, false, false, false, true);
                        destroyElement(data[element].obj);
                        data[element].obj = false;

                        setTimer(
                            function()
                                local valor = math.random(system['routes']['payment'].min, system['routes']['payment'].max);

                                geral.sNotify(element, "Você entregou uma encomenda e recebeu R$ "..(formatNumber(valor))..",00.", "info");
                                setPedAnimation(element, "CARRY", "liftup", 1.0, false, false, false, false);	
                                removeEventHandler("onMarkerHit", routes[element], onRoutesHitted);
                                toggleControl(element, "aim_weapon", true);
                                toggleControl(element, "fire", true);
                                toggleControl(element, "jump", true);
                                givePlayerMoney(element, valor);
                                destroyElement(routes[element]);

                                local expp = (getElementData(element, 'XP') or 0)
                                local isVip = exports["guetto_util"]:isPlayerVip(element)

                                if (isVip) then 
                                    setElementData(element, "XP", expp+200)
                                else
                                    setElementData(element, "XP", expp+100)
                                end
      
                                routes[element] = false;

                                if ((orders[element] + 1) < 15) then
                                    orders[element] = (orders[element] + 1);
                                    local index = math.random(1, #system['routes'].spawns);
                                    routes[element] = createMarker(system['routes']['spawns'][index][1], system['routes']['spawns'][index][2], system['routes']['spawns'][index][3] - 0.9, "cylinder", 1.5, system['attributes']['marker']['color'][1], system['attributes']['marker']['color'][2], system['attributes']['marker']['color'][3], 0, element);
                                    setElementData(routes[element], 'markerData', {title = 'Entrega', desc = 'Entregue a caixa aqui!', icon = 'courier'})
                                    triggerClientEvent(element, "togglePoint", element, system['routes']['spawns'][index][1], system['routes']['spawns'][index][2], system['routes']['spawns'][index][3], 0, 0)
                                    triggerClientEvent(element, "Sedex >> Update Orders", element, {orders[element], 15});
                                    addEventHandler("onMarkerHit", routes[element], onRoutesHitted);	
                                else
                                    geral.sNotify(element, "Você completou as suas entregas! Volte para sua a base de seu trabalho.", "info");
                                    triggerClientEvent(element, "Sedex >> Show Orders", element, false);
            						--triggerClientEvent(element, "removePoint", element)
                                    orders[element] = (orders[element] + 1);
                                end
                            end
                        , 1200, 1);
                    else
                        geral.sNotify(element, "Você não possui uma encomenda em mãos!", "warning");
                    end
                end
            end
        else
            geral.sNotify(element, "Saía do veículo e tente novamente.", "warning");
        end
    end
    return false;
end

local function onBoxHitted(element)
    if (isElementPlayer(element)) then
        if (not isPedInVehicle(element)) then
            if (not data[element].obj) then
                if (orders[element] < 15) then
                    if (data[element].marker == source) then
                        local pX, pY, pZ = getElementPosition(element);
                        setPedAnimation(element, "CARRY", "liftup", 1.0, false);

                        setTimer(
                            function()
                                setPedAnimation(element);
                                toggleControl(element, "jump", false);
                                toggleControl(element, "fire", false);
                                toggleControl(element, "aim_weapon", false);
                                geral.sNotify(element, "Entregue a caixa no local marcado.", "info");
                                setPedAnimation(element, "CARRY", "crry_prtial", 4.1, true, true, true);
                                data[element].obj = createObject(system['attributes'].object, pX, pY, pZ);
                                others.attachElement(data[element].obj, element, 4, -0.07, 0.5, -0.5, -90, 0, 0);
                                setObjectScale(data[element].obj, 0.8);
                            end
                        , 1000, 1);
                        removeEventHandler("onMarkerHit", data[element].marker, onBoxHitted);
                        destroyElement(data[element].marker);
                        data[element].marker = false;
                    end
                end
            else
                geral.sNotify(element, "Você já possui uma entrega em mãos!", "warning");
            end
        else
            geral.sNotify(element, "Saía do veículo e tente novamente.", "warning");
        end
    end
    return false;
end

local function onCreateRoutes(element)
    if (isElementPlayer(element)) then
        if (not routes[element]) then
            local index = math.random(1, #system['routes'].spawns);
            routes[element] = createMarker(system['routes']['spawns'][index][1], system['routes']['spawns'][index][2], system['routes']['spawns'][index][3] - 0.9, "cylinder", 1.5, system['attributes']['marker']['color'][1], system['attributes']['marker']['color'][2], system['attributes']['marker']['color'][3], 0, element);
            setElementData(routes[element], 'markerData', {title = 'Entrega', desc = 'Entregue a caixa aqui!', icon = 'courier'})
            triggerClientEvent(element, "togglePoint", element, system['routes']['spawns'][index][1], system['routes']['spawns'][index][2], system['routes']['spawns'][index][3], 0, 0)
            addEventHandler("onMarkerHit", routes[element], onRoutesHitted);
        end
    end
    return false;
end

local function onDestroyRoutes(element)
    if (isElementPlayer(element)) then
        if (routes[element]) then
            removeEventHandler("onMarkerHit", routes[element], onRoutesHitted);
            destroyElement(routes[element]);
            routes[element] = false;
        end
    end
    return false;
end

addEvent("Sedex >> Ped interaction", true);
addEventHandler("Sedex >> Ped interaction", root, 
    function(player, index)
        if (others.getPlayerJob(player)) then
            if (not data[player]) then
                savePlayerData(player);

                data[player] = {
                    i = index,
                    obj = false,
                    marker = false,
                    vehicle = createVehicle(system['attributes'].vehicle, system['attributes']['positions'][index]['veh'][1], system['attributes']['positions'][index]['veh'][2], system['attributes']['positions'][index]['veh'][3], 0, 0, system['attributes']['positions'][index]['veh'][4]),
                }

                geral.sNotify(player, "Você iniciou o trabalho de SEDEX.", "success");
                triggerClientEvent(player, "Sedex >> Update Orders", player, {0, 15});
                triggerClientEvent(player, "Sedex >> Show Orders", player, true);
                warpPedIntoVehicle(player, data[player].vehicle);
                onCreateRoutes(player);
                orders[player] = 0;
            else
                if (data[player]) then
                    if (data[player].vehicle and isElement(data[player].vehicle)) then destroyElement(data[player].vehicle); data[player].vehicle = false; end
                    if (data[player].marker and isElement(data[player].marker)) then destroyElement(data[player].marker); data[player].marker = false; end
                    if (data[player].obj and isElement(data[player].obj)) then destroyElement(data[player].obj); data[player].obj = false; end
                    geral.sNotify(player, "Você saiu do seu trabalho de SEDEX!", "info");
                    triggerClientEvent(player, "Sedex >> Show Orders", player, false);
                    toggleControl(player, "aim_weapon", true);
                    toggleControl(player, "jump", true);
                    toggleControl(player, "fire", true);
                    onDestroyRoutes(player);
                    setPedAnimation(player);
                    loadPlayerData(player);
                    triggerClientEvent(player, "removePoint", player)
                    data[player] = false;
                end
            end
        else
            geral.sNotify(player, "Você não faz parte do SEDEX!", "warning");
        end
    end
);

addEventHandler("onVehicleStartEnter", root, 
    function(player)
        if (data[player]) then
            if (orders[player] < 15) then
                if (data[player].obj) then
                    geral.sNotify(player, "Você não pode entrar em um veículo com uma encomenda em mãos!", "warning");
                    cancelEvent();
                    return;
                end

                if (data[player].marker) then
                    if (getElementModel(source) == system['attributes'].vehicle) then
                        removeEventHandler("onMarkerHit", data[player].marker, onBoxHitted);
                        destroyElement(data[player].marker);
                        data[player].marker = false;
                    end
                end
            end
        end
    end
);

addEventHandler("onVehicleStartExit", root, 
    function(player)
        if (data[player] and not data[player].marker) then
            if (orders[player] < 15) then
                if (getElementModel(source) == system['attributes'].vehicle) then
                    data[player].marker = createMarker(system['attributes']['positions'][data[player].i]['veh'][1], system['attributes']['positions'][data[player].i]['veh'][2], system['attributes']['positions'][data[player].i]['veh'][3] - 0.9, "cylinder", 1.5, system['attributes']['marker']['color'][1], system['attributes']['marker']['color'][2], system['attributes']['marker']['color'][3], 0, player);
	                setElementData(data[player].marker , 'markerData', {title = 'Caixa', desc = 'Pegue a encomenda aqui!', icon = 'magazineBox'})
                    attachElements(data[player].marker, data[player].vehicle, 0, -4, -1, 0, 0, 0);
                    addEventHandler("onMarkerHit", data[player].marker, onBoxHitted);
                end
            end
        end
    end
);

addEventHandler("onPlayerWasted", root, 
    function()
        if (data[source]) then
            if (data[source].vehicle and isElement(data[source].vehicle)) then destroyElement(data[source].vehicle); data[source].vehicle = false; end
            if (data[source].marker and isElement(data[source].marker)) then destroyElement(data[source].marker); data[source].marker = false; end
            if (data[source].obj and isElement(data[source].obj)) then destroyElement(data[source].obj); data[source].obj = false; end
            if (routes[source] and isElement(routes[source])) then destroyElement(routes[source]); end
            loadPlayerData(source);
        end
    end
);

addEventHandler("onPlayerQuit", root, 
    function()
        if (data[source]) then
            if (data[source].vehicle and isElement(data[source].vehicle)) then destroyElement(data[source].vehicle); data[source].vehicle = false; end
            if (data[source].marker and isElement(data[source].marker)) then destroyElement(data[source].marker); data[source].marker = false; end
            if (data[source].obj and isElement(data[source].obj)) then destroyElement(data[source].obj); data[source].obj = false; end
            if (routes[source] and isElement(routes[source])) then destroyElement(routes[source]); end
        end
    end
);

addEventHandler("onResourceStart", resourceRoot, 
    function()
        for _, v in ipairs(system['attributes'].positions) do
            if (v['blip'].use) then
                others.createRadarBlip(v['pos'][1], v['pos'][2], v['pos'][3], v['blip'].icon, 4);
            end
        end
    end
);