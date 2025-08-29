local functions = {};
local player_infos = {};

local events = {
    int = 0,
    dim = 1,
    event = false,
    freeze = true,
    locked = true,
    player = {},
    vehicle = {},
    position = {},
};

----        ---- ----        ---- ----        ----
---- Evento ---- ---- Evento ---- ---- Evento ----
----        ---- ----        ---- ----        ----

addEvent("Eventos >> Change options", true);
addEventHandler("Eventos >> Change options", resourceRoot,
    function(event, info)

        if not client then
            return;
        end

        local player = client;

        if (not events.event) then
            geral.sNotify(player, "Não tem nenhum evento ativo no momento.", "warning");
            return;
        end

        if (event == "vehicle") then
            if (not info or not tonumber(info)) then
                geral.sNotify(player, "Você não inseriu o ID correto!", "warning");
                return;
            end

            for k, v in pairs(events.player) do 
                if (events['player'][k]) then
                    if (events['vehicle'][k] and isElement(events['vehicle'][k])) then
                        destroyElement(events['vehicle'][k]);
                        events['vehicle'][k] = nil;
                    end

                    local pX, pY, pZ = getElementPosition(k);
                    local rX, rY, rZ = getElementRotation(k);
                    outputChatBox("#C19F72[GCRP]#FFFFFF O(A) Admintrador(A) #C19F72"..(getPlayerName(player)).." #FFFFFF(#C19F72"..(others.getPlayerID(player)).."#FFFFFF) deu um veículo para todos jogadores do evento.", k, 255, 255, 255, true);
                    events['vehicle'][k] = createVehicle(tonumber(info), pX, pY, (pZ + 1), rX, rY, rZ);
                    setElementDimension(events['vehicle'][k], events.dim);
                    setElementInterior(events['vehicle'][k], events.int);
                    warpPedIntoVehicle(k, events['vehicle'][k]);
                end
            end

        elseif (event == "fix") then
            for k, v in pairs(events.player) do
                if (events['player'][k]) then
                    if (events['vehicle'][k] and isElement(events['vehicle'][k])) then
                        outputChatBox("#C19F72[GCRP]#FFFFFF O(A) Admintrador(A) #C19F72"..(getPlayerName(player)).." #FFFFFF(#C19F72"..(others.getPlayerID(player)).."#FFFFFF) fixou o veículo de todos os jogadores do evento.", k, 255, 255, 255, true);
                        fixVehicle(events['vehicle'][k]);
                    end
                end
            end

        elseif (event == "trash") then
            for k, v in pairs(events.player) do
                if (events['player'][k]) then
                    if (events['vehicle'][k] and isElement(events['vehicle'][k])) then
                        outputChatBox("#C19F72[GCRP]#FFFFFF O(A) Admintrador(A) #C19F72"..(getPlayerName(player)).." #FFFFFF(#C19F72"..(others.getPlayerID(player)).."#FFFFFF) deletou o veículo de todos os jogadores do evento.", k, 255, 255, 255, true);
                        destroyElement(events['vehicle'][k]);
                        events['vehicle'][k] = nil;
                    end
                end
            end

        elseif (event == "health") then
            if (not info or not tonumber(info)) then
                geral.sNotify(player, "Você não inseriu o ID correto!", "warning");
                return;
            end

            for k, v in pairs(events.player) do 
                if (events['player'][k]) then
                    outputChatBox("#C19F72[GCRP]#FFFFFF O(A) Admintrador(A) #C19F72"..(getPlayerName(player)).." #FFFFFF(#C19F72"..(others.getPlayerID(player)).."#FFFFFF) deu vida para todos jogadores do evento.", k, 255, 255, 255, true);
                    setElementHealth(k, tonumber(info));
                end
            end

        elseif (event == "weapon") then
            if (not info or not tonumber(info)) then
                geral.sNotify(player, "Você não inseriu o ID correto!", "warning");
                return;
            end

            for k, v in pairs(events.player) do 
                if (events['player'][k]) then
                    takeAllWeapons(k)
                    outputChatBox("#C19F72[GCRP]#FFFFFF O(A) Admintrador(A) #C19F72"..(getPlayerName(player)).." #FFFFFF(#C19F72"..(others.getPlayerID(player)).."#FFFFFF) deu arma para todos jogadores do evento.", k, 255, 255, 255, true);
                    giveWeapon(k, tonumber(info), 9999, true);
                    setElementData(k, 'JOAO.MUNI556', 9999)
                    setElementData(k, 'JOAO.MUNI762', 9999)
                    setElementData(k, 'JOAO.MUNI9MM', 9999)
                    setElementData(k, 'JOAO.MUNI12MM', 9999)
                end
            end

        elseif (event == "armor") then
            if (not info or not tonumber(info)) then
                geral.sNotify(player, "Você não inseriu o ID correto!", "warning");
                return;
            end

            for k, v in pairs(events.player) do 
                if (events['player'][k]) then
                    outputChatBox("#C19F72[GCRP]#FFFFFF O(A) Admintrador(A) #C19F72"..(getPlayerName(player)).." #FFFFFF(#C19F72"..(others.getPlayerID(player)).."#FFFFFF) deu colete para todos jogadores do evento.", k, 255, 255, 255, true);
                    setPedArmor(k, tonumber(info));
                end
            end

        elseif (event == "dimension") then
            if (not info or not tonumber(info)) then
                geral.sNotify(player, "Você não inseriu o ID correto!", "warning");
                return;
            end

            for k, v in pairs(events.player) do 
                if (events['player'][k]) then
                    outputChatBox("#C19F72[GCRP]#FFFFFF O(A) Admintrador(A) #C19F72"..(getPlayerName(player)).." #FFFFFF(#C19F72"..(others.getPlayerID(player)).."#FFFFFF) mudou a dimensão dos jogadores do evento.", k, 255, 255, 255, true);
                    setElementDimension(k, tonumber(info));
                    events.dim = tonumber(info);
                end
            end

        elseif (event == "interior") then
            if (not info or not tonumber(info)) then
                geral.sNotify(player, "Você não inseriu o ID correto!", "warning");
                return;
            end

            for k, v in pairs(events.player) do 
                if (events['player'][k]) then
                    outputChatBox("#C19F72[GCRP]#FFFFFF O(A) Admintrador(A) #C19F72"..(getPlayerName(player)).." #FFFFFF(#C19F72"..(others.getPlayerID(player)).."#FFFFFF) mudou o interior dos jogadores do evento.", k, 255, 255, 255, true);
                    setElementPosition(k, Vector3(getElementPosition(player)));
                    setElementInterior(k, tonumber(info));
                    events.int = tonumber(info);
                end
            end

        elseif (event == "lock") then
            outputChatBox("#C19F72[GCRP]#FFFFFF O(A) Admintrador(A) #C19F72"..(getPlayerName(player)).." #FFFFFF(#C19F72"..(others.getPlayerID(player)).."#FFFFFF) "..(info and "trancou" or "destrancou").." o evento.", root, 255, 255, 255, true);
            events.locked = info;

        elseif (event == "freeze") then
            for k, v in pairs(events.player) do 
                if (events['player'][k]) then
                    outputChatBox("#C19F72[GCRP]#FFFFFF O(A) Admintrador(A) #C19F72"..(getPlayerName(player)).." #FFFFFF(#C19F72"..(others.getPlayerID(player)).."#FFFFFF) "..(info and "congelou" or "descongelou").." todos jogadores do evento.", k, 255, 255, 255, true);
                    setElementFrozen(k, info);
                end
            end
            events.freeze = info;
        end
    end
);

----         ---- ----         ---- ----         ----
---- Manager ---- ---- Manager ---- ---- Manager ----
----         ---- ----         ---- ----         ----

functions.joinPlayerEvent = function(element, state)
    if (not state and events.locked) then
        geral.sNotify(element, "O evento está trancado!", "warning");
        return;
    end

    if (events['player'][element]) then
        geral.sNotify(element, "Você já está em um evento!", "warning");
        return;
    end

    outputChatBox("#C19F72[GCRP]#FFFFFF O(A) #C19F72"..(getPlayerName(element)).." #FFFFFF(#C19F72"..(others.getPlayerID(element)).."#FFFFFF) entrou no evento (#C19F72/eir#FFFFFF).", root, 255, 255, 255, true);
    spawnPlayer(element, events['position'][1], events['position'][2], events['position'][3], 0, getElementModel(element), events.int, events.dim);
    setElementData(element, 'evento', true)
    if (events.freeze) then setElementFrozen(element, true); end
    events['vehicle'][element] = false;
    events['player'][element] = true;
    takeAllWeapons(element);
    return;
end

addEvent("Eventos >> Destroy event", true);
addEventHandler("Eventos >> Destroy event", resourceRoot,
    function()

        if (not client) then
            return;
        end

        local player = client;

        if (not events.event) then
            geral.sNotify(player, "Não tem nenhum evento ativo no momento.", "warning");
            return;
        end

        for k, v in pairs(events.player) do
            if (events.player[k] and isElementPlayer(k)) then
                spawnPlayer(k, player_infos[k]['pos'][1], player_infos[k]['pos'][2], player_infos[k]['pos'][3], 0, player_infos[k].skin, player_infos[k].interior, player_infos[k].dimension);
                outputChatBox("#C19F72[GCRP]#FFFFFF O evento foi destruído pelo(a) Admintrador(A) #C19F72"..(getPlayerName(player)).." #FFFFFF(#C19F72"..(others.getPlayerID(player)).."#FFFFFF).", k, 255, 255, 255, true);
                if (events['vehicle'][k] and isElement(events['vehicle'][k])) then destroyElement(events['vehicle'][k]); events['vehicle'][k] = false; end
                if (events['player'][k]) then events['player'][k] = false; end
                setElementWeapons(k, player_infos[k].weapons);
                setElementHealth(k, player_infos[k].health);
                setPedArmor(k, player_infos[k].armor);
                setElementData(k, 'JOAO.MUNI556', 0)
                setElementData(k, 'JOAO.MUNI762', 0)
                setElementData(k, 'JOAO.MUNI9MM', 0)
                setElementData(k, 'JOAO.MUNI12MM', 0)
                setElementFrozen(k, false);
                setElementData(k, 'evento', false)

            end
        end 
        
        geral.sNotify(player, "Você destruiu o evento!", "success");
        removeCommandHandler("eventosair");
        removeCommandHandler("eir");
        events.locked = true;
        events.freeze = true;
        events.event = false;
        events.vehicle = {};
        events.player = {};
        return;
    end
);

addEvent("Eventos >> Join event", true);
addEventHandler("Eventos >> Join event", resourceRoot,
    function()

        if (not client) then
            return;
        end

        local player = client;

        if (not events.event) then
            geral.sNotify(player, "Não tem nenhum evento ativo no momento.", "warning");
            return;
        end

        if (events['player'][player]) then
            geral.sNotify(player, "Você já está em um evento!", "warning");
            return;
        end

        player_infos[player] = {pos = {getElementPosition(player)}, skin = getElementModel(player), armor = getPedArmor(player), money = 0, health = getElementHealth(player), weapons = getElementWeapons(player), interior = getElementInterior(player), dimension = getElementDimension(player)};
        geral.sNotify(player, "Você entrou no evento!", "success");
        functions.joinPlayerEvent(player, true);
        setElementData(player, 'evento', true)
        return;
    end
);

addEvent("Eventos >> Create event", true);
addEventHandler("Eventos >> Create event", resourceRoot,
    function()

        if (not client) then
            return;
        end

        local player = client;
        
        if (events.event) then
            geral.sNotify(player, "Já tem um evento ativo no momento.", "warning");
            return;
        end

        player_infos[player] = {pos = {getElementPosition(player)}, skin = getElementModel(player), armor = getPedArmor(player), money = 0, health = getElementHealth(player), weapons = getElementWeapons(player), interior = getElementInterior(player), dimension = getElementDimension(player)};
        outputChatBox("\n\n#C19F72[GCRP] #FFFFFFO(A) Admintrador(A) #C19F72"..(getPlayerName(player)).." #FFFFFF(#C19F72"..(others.getPlayerID(player)).."#FFFFFF) acabou de criar um evento! Para entrar, digite o comando \"#C19F72/eir#FFFFFF\".\n\n", root, 255, 255, 255, true);
        triggerClientEvent(player, "Eventos >> Manager render", resourceRoot, false);
        geral.sNotify(player, "O evento foi criado!", "success");
        events.position = {getElementPosition(player)};
        events.dim = getElementDimension(player);
        events.int = getElementInterior(player);
        functions.joinPlayerEvent(player, true);
        events.event = true;

        addCommandHandler("eir", 
            function(element)
                player_infos[element] = {pos = {getElementPosition(element)}, skin = getElementModel(element), armor = getPedArmor(element), money = 0, health = getElementHealth(element), weapons = getElementWeapons(element), interior = getElementInterior(element), dimension = getElementDimension(element)};
                functions.joinPlayerEvent(element, false);
            end
        );

        addCommandHandler("eventosair", 
            function(element)
                if (not events['player'][element]) then
                    geral.sNotify(element, "Você não está em um evento!", "warning");
                    return;
                end

                spawnPlayer(element, player_infos[element]['pos'][1], player_infos[element]['pos'][2], player_infos[element]['pos'][3], 0, player_infos[element].skin, player_infos[element].interior, player_infos[element].dimension);
                if (events['vehicle'][element] and isElement(events['vehicle'][element])) then destroyElement(events['vehicle'][element]); events['vehicle'][element] = false; end
                if (events['player'][element]) then events['player'][element] = false; end
                geral.sNotify(element, "Você saiu do evento!", "success");
                setElementWeapons(element, player_infos[element].weapons);
                setElementHealth(element, player_infos[element].health);
                setPedArmor(element, player_infos[element].armor);
                setElementFrozen(element, false);
                setElementData(element, 'evento', false)

                return;
            end
        );
    end
);

----       ---- ----       ---- ----       ----
---- Panel ---- ---- Panel ---- ---- Panel ----
----       ---- ----       ---- ----       ----

addCommandHandler(config['attributes']['panel'].command,
    function(player)
        if (not isPlayerHavePermission(player, config['attributes']['panel'].permissions)) then
            return;
        end

        triggerClientEvent(player, "Eventos >> Manager render", resourceRoot, true);
        triggerClientEvent(player, "Eventos >> Manager data", resourceRoot, events.locked, events.freeze);
        return;
    end
);

----        ---- ----        ---- ----        ----
---- Outros ---- ---- Outros ---- ---- Outros ----
----        ---- ----        ---- ----        ----

addEventHandler("onElementDestroy", root, 
    function()
        if (events.event) then
            if (source and getElementType(source) == "vehicle") then
                local player = getVehicleController(source);
                if (player) then
                    if (events['player'][player] and events['vehicle'][player]) then 
                        events['vehicle'][player] = nil;
                        return;
                    end
                end
            end
        end
    end
);

addEventHandler("onVehicleStartExit", root, 
    function(player)
        if (events.event) then
            if (events['player'][player] and events['vehicle'][player] and isElement(events['vehicle'][player])) then 
                if (events['vehicle'][player] == source) then
                    cancelEvent();
                    return;
                end
            end
        end
    end
);

addEventHandler("onPlayerWasted", root, 
    function()
        if (events.event) then
            if (events['player'][source]) then 
                spawnPlayer(source, player_infos[source]['pos'][1], player_infos[source]['pos'][2], player_infos[source]['pos'][3], 0, player_infos[source].skin, player_infos[source].interior, player_infos[source].dimension);
                if (events['vehicle'][source] and isElement(events['vehicle'][source])) then destroyElement(events['vehicle'][source]); events['vehicle'][source] = false; end
                if (events['player'][source]) then events['player'][source] = false; end
                setElementData(source, 'evento', false)
                setElementWeapons(source, player_infos[source].weapons);
                setElementHealth(source, player_infos[source].health);
                setPedArmor(source, player_infos[source].armor);
                setElementData(source, 'JOAO.MUNI556', 0)
                setElementData(source, 'JOAO.MUNI762', 0)
                setElementData(source, 'JOAO.MUNI9MM', 0)
                setElementData(source, 'JOAO.MUNI12MM', 0)
                return;
            end 
        end
    end
);

addEventHandler("onPlayerQuit", root, 
    function()
        if (events.event) then
            if (events['player'][source]) then 
                spawnPlayer(source, player_infos[source]['pos'][1], player_infos[source]['pos'][2], player_infos[source]['pos'][3], 0, player_infos[source].skin, player_infos[source].dimension, player_infos[source].interior);
                if (events['vehicle'][source] and isElement(events['vehicle'][source])) then destroyElement(events['vehicle'][source]); events['vehicle'][source] = false; end
                if (events['player'][source]) then events['player'][source] = false; end
                setElementWeapons(source, player_infos[source].weapons);
                setElementHealth(source, player_infos[source].health);
                setPedArmor(source, player_infos[source].armor);
                setElementData(source, 'JOAO.MUNI556', 0)
                setElementData(source, 'JOAO.MUNI762', 0)
                setElementData(source, 'JOAO.MUNI9MM', 0)
                setElementData(source, 'JOAO.MUNI12MM', 0)
                return;
            end
        end 
    end
);