local timer = {}

weapons = { -- Lista das armas com seus respectivos id´s!
    [57] = true;
    [58] = true;
    [59] = true;
    [60] = true;
    [61] = true;
    [62] = true;
    [63] = true;
    [64] = true;
    [65] = true;
    [145] = true;
}

local accessories = {
    [157] = true;
    [158] = true;
    [159] = true;
    [160] = true;
    [161] = true;
    [162] = true;
    [163] = true;
    [164] = true;
    [165] = true;
    [166] = true;
    [167] = true;
    [168] = true;
    [169] = true;
    [170] = true;
    [171] = true;
    [172] = true;
    [173] = true;
    [174] = true;
    [175] = true;
    [176] = true;
    [177] = true;
    [178] = true;
    [179] = true;
    [180] = true;
    [181] = true;
    [182] = true;
    [183] = true;
    [184] = true;
    [185] = true;
    [186] = true;
    [187] = true;
    [188] = true;
    [189] = true;
    [190] = true;
    [191] = true;
    [192] = true;
    [193] = true;
    [194] = true;
    [195] = true;
    [196] = true;
    [197] = true;
    [198] = true;
    [199] = true;
    [200] = true;
    [201] = true;
    [202] = true;
    [203] = true;
    [204] = true;
    [205] = true;
    [206] = true;
    [207] = true;
    [208] = true;
    [209] = true;
    [210] = true;
    [211] = true;
    [212] = true;
    [213] = true;
    [214] = true;
    [215] = true;
    [216] = true;
    [217] = true;
    [218] = true;
    [219] = true;
    [220] = true;
    [221] = true;
    [222] = true;
    [223] = true;
    [224] = true;
    [225] = true;
    [226] = true;
    [227] = true;
    [228] = true;
    [229] = true;
    [230] = true;
    [231] = true;
    [232] = true;
    [233] = true;
    [234] = true;
    [235] = true;
    [236] = true;
    [237] = true;
    [238] = true;
    [239] = true;
    [240] = true;
    [241] = true;
    [242] = true;
    [243] = true;
    [244] = true;
    [245] = true;
    [246] = true;
    [247] = true;
    [248] = true;
    [249] = true;
    [250] = true;
    [251] = true;
    [252] = true;
    [253] = true;
    [254] = true;
    [255] = true;
    [256] = true;
    [257] = true;
    [258] = true;
    [259] = true;
    [260] = true;
    [261] = true;
    [262] = true;
    [263] = true;
    [264] = true;
    [265] = true;
    [266] = true;
    [267] = true;
    [268] = true;
    [269] = true;
    [270] = true;
    [271] = true;
    [272] = true;
    [273] = true;
    [274] = true;
    [275] = true;
    [276] = true;
    [277] = true;
    [278] = true;
    [279] = true;
    [280] = true;
    [281] = true;
    [282] = true;
    [283] = true;
    [284] = true;
    [285] = true;
    [286] = true;
    [287] = true;
    [288] = true;
    [289] = true;
    [290] = true;
    [291] = true;
    [292] = true;
    [293] = true;
    [294] = true;
    [295] = true;
    [296] = true;
    [297] = true;
    [298] = true;
    [299] = true;
    [300] = true;
    [301] = true;
    [302] = true;
    [303] = true;
    [304] = true;
    [305] = true;
    [306] = true;
    [307] = true;
    [308] = true;
    [309] = true;

    [315] = true;
    [316] = true;
    [317] = true;
    [318] = true;
    [319] = true;
    [320] = true;
    [321] = true;
    [322] = true;
    [323] = true;
    [324] = true;
    [325] = true;
    [326] = true;

    [327] = true;
    [328] = true;
    [329] = true;
    [330] = true;
    [331] = true;
    [332] = true;

    [333] = true;
    [334] = true;

}

local presentes = {
    [27] = {
        {item = 71, amount = 2}, -- Kit de Reparo,
        {item = 71, amount = 2}, -- Kit de Reparo,
        {item = 62, amount = 1}, -- Glock,
        {item = 65, amount = 1}, -- GlockPL,
        {item = 63, amount = 1}, -- Desert,
        {item = 9, amount = 4}, -- Mini-Frangos,
        {item = 9, amount = 4}, -- Mini-Frangos,
        {item = 8, amount = 15}, -- Tiras-crocantes,
        {item = 3, amount = 5}, -- Crepe,
        {item = 1, amount = 4}, -- Hamburguer,
        {item = 14, amount = 4}, -- Coca-cola,
        {item = 16, amount = 4}, -- Agua,
        {item = 16, amount = 4}, -- Agua,
        {item = 256, amount = 1}, -- Bone Preto,
        {item = 217, amount = 1}, -- Lupa,
        {item = 53, amount = 30}, -- Munição 9MM
        {item = 54, amount = 50}, -- Munição 762
    };
    [26] = {
        {item = 71, amount = 2}, -- Kit de Reparo,
        {item = 71, amount = 2}, -- Kit de Reparo,
        {item = 62, amount = 1}, -- Glock,
        {item = 65, amount = 1}, -- GlockPL,
        {item = 63, amount = 1}, -- Desert,
        {item = 9, amount = 4}, -- Mini-Frangos,
        {item = 8, amount = 5}, -- Tiras-crocantes,
        {item = 3, amount = 6}, -- Crepe,
        {item = 14, amount = 4}, -- Coca-cola,
        {item = 16, amount = 4}, -- Agua,
        {item = 16, amount = 4}, -- Agua,
        {item = 1, amount = 4}, -- Hamburguer,
        {item = 256, amount = 1}, -- Bone Preto,
        {item = 217, amount = 1}, -- Lupa,
        {item = 53, amount = 30}, -- Munição 9MM
        {item = 54, amount = 50},-- Munição 762
    };
}

createEventHandler("onPlayerUseItem", resourceRoot, function (data, quantidade)

    -- =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= Proteções não alterar! =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= 
    if not (client or (source ~= resourceRoot)) then 
        return false;
    end;

    if (quantidade <= 0) then 
        return false 
    end

    if not (data or type(data) ~= "table") then 
        return false 
    end

    -- =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= Armazenar informações do item em variavies! =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= 

    local item = tonumber(data["item"]); -- Id do item
    local quantidade = tonumber(quantidade) -- Quantidade que vai usar do item
    local settings = config["itens"][item] -- Salva as informações do item da config

    -- =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= Verificações do item ! =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= 

    if not settings then -- Se o item não estiver configurado na config retorna false
        return false 
    end;

    if settings["others"]["usar"] == false then -- Verifica se o item é usavel
        return sendMessageServer(client, "Você não pode utilizar esse item!", "error")
    end;

    -- =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= Verificação da categoria do item ! =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= 

    if settings["category"] == "food" then -- Verifica se a categoria do item é de comida
        if settings["sede"] then 
            local sede = (getElementData(client, "sede") or 0);
            
            if sede >= 90 then 
                return sendMessageServer(client, "Você não está com sede!", "info")
            end

            if quantidade > 1 then 
                return sendMessageServer(client, "Você so pode beber uma por vez!", "info")
            end

            if (timer[client] and isTimer(timer[client])) then 
                return sendMessageServer(client, "Você está fazendo isso rápido demais!", "info")
            end

            local x, y, z = getElementPosition(client)
            local drink = createObject(2601, x, y, z)
            local dim = getElementDimension(client)
            local int = getElementInterior(client)
            local enche = settings["sede"]

            setElementDimension(drink, dim)
            setElementInterior(drink, int)

            exports['pAttach']:attach(drink, client, 36, 0.04,0.01,0.01,10.8,-169.2,0)

            setPedAnimation(client, 'vending', 'vend_drink_p', 2000, false, false, false, false)
            takeItem(client, item, quantidade)

            timer[client] = setTimer(function(player)
                if (player and isElement(player)) then 
                    setElementData(player, "sede", sede + enche)
                    setPedAnimation(player)
                    timer[player] = false 
                end
                if isElement(drink) then 
                    destroyElement(drink)
                end
            end, 2000, 1, client)

            sendMessageServer(client, "Você está bebendo um "..(settings["name"]).."!", "info")
        elseif settings["fome"] then 

            local fome = (getElementData(client, "fome") or 0);
            
            if fome >= 90 then 
                return sendMessageServer(client, "Você não está com fome!", "info")
            end

            if quantidade > 1 then 
                return sendMessageServer(client, "Você so pode comer uma por vez!", "info")
            end

            if (timer[client] and isTimer(timer[client])) then 
                return sendMessageServer(client, "Você está fazendo isso rápido demais!", "info")
            end

            local x, y, z = getElementPosition(client)
            local food = createObject(2703, x, y, z)
            local dim = getElementDimension(client)
            local int = getElementInterior(client)
            local enche = settings["fome"]

            setElementDimension(food, dim)
            setElementInterior(food, int)

            exports['pAttach']:attach(food, client, 26, 0, 0, 0, 18, 0,-100)
            setPedAnimation(client, "food", "eat_burger", 5000, false, false, false, false)
            takeItem(client, item, quantidade)
        
            timer[client] = setTimer(function(player)
                if (player and isElement(player)) then 
                    setElementData(player, "fome", fome + enche)
                    setPedAnimation(player)
                    timer[player] = false 
                end
                if isElement(food) then 
                    destroyElement(food)
                end
            end, 2000, 1, client)

            sendMessageServer(client, "Você está comendo um "..(settings["name"]).."!", "info")
        end

    elseif settings["category"] == "bag" then -- Verifica se a categoria do item é de mochila

        if (accessories[item]) then -- Verifica se o item é um acessório 

            triggerEvent("accessoriesCreateObject", resourceRoot, client, item)
            sendMessageServer(client, "Você equipou o item com sucesso!", "success")

        elseif item == 72 then
             
            if not isPedInVehicle(client) then 
                return sendMessageServer(client, 'Entre em um veículo!', 'error')
            end

            setTimer(function(client)
                if client and isElement(client) then 
                    if isPedInVehicle(client) then 
                        exports['guetto_nitro']:setVehicleBooster(client, 4)
                        sendMessageServer(client, 'Você instalou o nitro em seu veículo com sucesso!', 'success')
                        setElementFrozen(getPedOccupiedVehicle(client), false)
                    else
                        sendMessageServer(client, 'Não foi possível concluir a instalação do nitro!', 'error')
                    end
                end
            end, 10000, 1, client)

            sendMessageServer(client, 'Você está instalando um nitro no seu veículo!', 'info')
            exports["guetto_progress"]:callProgress(client, "Instalando nitro!", "Você está instalando um nitro em seu veículo!", "martelo", 10000)
            setElementFrozen(getPedOccupiedVehicle(client), true)

            takeItem(client, item, 1)

        elseif item == 33 then 
           
          --  triggerEvent("server->applyJBL", resourceRoot, client, item)
           -- sendMessageServer(client, "Você equipou uma JBL!", "success")
        elseif item == 40 then 
           
            triggerEvent("guetto>>create>>vase", client, client)
             -- sendMessageServer(client, "Você equipou uma JBL!", "success")

        elseif item == 35 then 
            
            triggerClientEvent(client, "Radio Comunicador >> Manager render", resourceRoot);

        elseif item == 34 then 
            
            triggerEvent("174.OpenCell", resourceRoot, client);

        elseif item == 38 then 

            if getPedArmor(client) >= 50 then 
                return sendMessageServer(client, 'Seu colete ainda está em um bom estado!', 'error')
            end

            setPedArmor(client, 100)
            sendMessageServer(client, 'Você equipou o colete!', 'info')
            takeItem(client, item, 1)

        elseif item == 26 then 
            local random = math.random(#presentes[item])

            giveItem(client, presentes[item][random].item, presentes[item][random].amount)
            sendMessageServer(client, 'Você abriu o presente e recebeu o item '..(config['itens'][presentes[item][random].item].name)..'!', 'info')
            takeItem(client, 26, 1)

        elseif item == 27 then 
            local random = math.random(#presentes[item])

            giveItem(client, presentes[item][random].item, presentes[item][random].amount)
            sendMessageServer(client, 'Você abriu o presente e recebeu o item '..(config['itens'][presentes[item][random].item].name)..'!', 'info')
            takeItem(client, 27, 1)

        elseif item == 41 then 

            local weapons = getPedWeapons(client) 
            local level = getElementData(client, "Level") or 0;
            
            if level < 3 then 
                return sendMessageServer(client, "Você precisar ser level igual ou superior a 3 para equipar arma!", "info")
            end
            
            if #weapons ~= 0 then 
                for i = 1, #weapons do 
                    if weapons[i] == 23 then 
                        takeWeapon(client, 23)
                        sendMessageServer(client, 'Você desequipou o taser!', 'info')
                        return 
                    end
                end
            end

            giveWeapon(client, 23)
            sendMessageServer(client, 'Você equipou o taser!', 'info')

        elseif item ==  71 then 

            if timer[client] and isTimer ( timer[client] ) then 
                return sendMessageServer(client, "Você já está reparando um veículo!", "error")
            end

            if isPedInVehicle(client) then 
                return sendMessageServer(client, "Saia do veículo!", "error")
            end

            local vehicle = getNearestVehicle ( client, 5 )

            if not vehicle then 
                return sendMessageServer(client, "Não há nenhum veículo próximo a você!", "error")
            end

            local life = getElementHealth(vehicle)
            
            if (life >= 800) then 
                return sendMessageServer(client, "Seu veículo não precisa de reparos!", "error")
            end

            setPedAnimation(client, "bd_fire", "wash_up", -1, false)

            timer[client] = setTimer(function(player)

                if vehicle and isElement(vehicle) then 
                    fixVehicle(vehicle) 
                end
                
                if (timer[player] and isElement(timer[player])) then 
                    destroyElement(timer[player])
                    timer[player] = nil 
                end

                timer[player] = false
                setPedAnimation(player)
                
            end, 5000, 1, client)

            takeItem(client, item, quantidade)
            sendMessageServer(client, "Você está concertando o veiculo!", "info")
            
        elseif item == 39 then 
            
            if timer[player] and isTimer ( timer[client] ) then 
                return sendMessageServer(client, "Você já está reabastecendo o veículo!", "error")
            end

            if isPedInVehicle(client) then 
                return sendMessageServer(client, "Saia do veículo!", "error")
            end

            local vehicle = getNearestVehicle ( client, 5 )

            if not vehicle then 
                return sendMessageServer(client, "Não há nenhum veículo próximo a você!", "error")
            end

            local atual = getElementData(vehicle, "Gasolina") or 0;
            
            if (atual > 50) then 
                return sendMessageServer(client, "Seu veículo está com o tanque cheio!", "error")
            end

            setPedAnimation(client, "bd_fire", "wash_up", -1, false)

            timer[player] = setTimer(function (player)
                timer[player] = false
                setPedAnimation(player)
                setElementData(vehicle, "Gasolina", 100)
            end, 5000, 1, client)

            sendMessageServer(player, "Você está reabastecendo seu ve´ciulo!", "error")

        elseif item == 24 then 
            if (getElementHealth(client) >= 50) then 
                return sendMessageServer(client, "Você não está precisando de cura!", "info")
            end

            setElementHealth(client, 50 )
            takeItem(client, item, 1)

            sendMessageServer(client, "Você recuperou 50% da vida!", "info")

        elseif item == 25 then 
            if (getElementHealth(client) >= 50) then 
                return sendMessageServer(client, "Você não está precisando de cura!", "info")
            end

            setElementHealth(client, 100 )
            takeItem(client, item, 1)

            sendMessageServer(client, "Você recuperou 100% da vida!", "info")
        end

    elseif settings["category"] == "ilegal" then -- Verifica se a categoria do item é ilegal

        if (weapons[item]) then  -- Verifica se é uma arma que está sendo usada
            local level = (getElementData(client, "Level") or 0);
            
            if level < 3 then 
                return sendMessageServer(client, "Você precisar ser level igual ou superior a 3 para equipar arma!", "info")
            end
            

            local armaPrimaria = config["weapons"]["weapons_primary"][item] 
            local armaSecundaria = config["weapons"]["weapons_secondarys"][item] 

            local primaria = getElementData(client, "guetto.arma.primaria") or false;
            local secundaria = getElementData(client, "guetto.arma.secundaria") or false; 

            if armaPrimaria then 
                if not primaria then 
                    for index, value in pairs(config["ammunition"]) do 
                        for i, v in pairs(value) do 
                            if v == item then 
                                local qnt = getItem(client, index)
                                if qnt == 0 then 
                                    return sendMessageServer(client, "Você não possui munição!", "error")
                                end
                                giveWeapon(client, armaPrimaria, qnt)
                                takeItem(client, index, qnt)
                                sendMessageServer(client, "Você equipou sua arma primária!", "info")
                                setElementData(client, "guetto.arma.primaria", {item, index})
                                break
                            end
                        end
                    end 
                else
                    if getElementData(client, "guetto.arma.primaria")[1] == item then 
                        local slot = getSlotFromWeapon(config["weapons"]["weapons_primary"][getElementData(client, "guetto.arma.primaria")[1]])
                        local ammu = getPedTotalAmmo(client, slot)
                        if (ammu-1) > 0  then
                            giveItem(client, getElementData(client, "guetto.arma.primaria")[2], ammu)
                        end
                        takeWeapon(client, armaPrimaria)
                        sendMessageServer(client, "Você desequipou sua arma primária!", "info")
                        setElementData(client, "guetto.arma.primaria", false)
                    end
                end
            elseif armaSecundaria then 
                if not secundaria then 
                    for index, value in pairs(config["ammunition"]) do 
                        for i, v in pairs(value) do 
                            if v == item then 
                                local qnt = getItem(client, index)
                                if qnt == 0 then 
                                    return sendMessageServer(client, "Você não possui munição!", "error")
                                end
                                giveWeapon(client, armaSecundaria,  qnt)
                                takeItem(client, index, qnt)
                                sendMessageServer(client, "Você equipou sua arma secundária!", "info")
                                setElementData(client, "guetto.arma.secundaria", {item, index})
                                break
                            end
                        end
                    end
                else
                    if getElementData(client, "guetto.arma.secundaria")[1] == item then 
                        local slot = getSlotFromWeapon(config["weapons"]["weapons_secondarys"][getElementData(client, "guetto.arma.secundaria")[1]])
                        local ammu = getPedTotalAmmo(client, slot)
                        if (ammu-1) > 0  then
                            giveItem(client, getElementData(client, "guetto.arma.secundaria")[2], ammu)
                        end
                        takeWeapon(client, armaSecundaria)
                        sendMessageServer(client, "Você desequipou sua arma primária!", "info")
                        setElementData(client, "guetto.arma.secundaria", false)
                    end
                end
            end
        elseif item == 126 then 
            if (quantidade > 1) then 
                return sendMessageServer(client, "Você pode usar apenas uma vez!", "info")
            end
            if not (exports["guetto_mesa"]:isHavePlayerTable(client)) then 
                exports["guetto_mesa"]:createTable(client)
                sendMessageServer(client, "Você usou a mesa com sucesso!", "info")
            else
                exports["guetto_mesa"]:destroyPlayerTable(client)
                sendMessageServer(client, "Você guardou sua mesa!", "info")
            end
        elseif item == 49 then 
            triggerClientEvent(client, "useLockPick", resourceRoot) 
            takeItem(client, item, 1)
        elseif item == 69 then 
           -- triggerEvent(client, "onPlayerUseLockpickHack", resourceRoot) 
            --takeItem(client, item, quantidade)
        elseif item == 98 or item == 99 then -- Sedas para ganhar o papel de seda
            local uni = 10;
            
            giveItem(client, 97, quantidade * uni)
            takeItem(client, item, quantidade)

            sendMessageServer(client, "Você abriu uma caixa de seda e ganhou "..(quantidade * uni).."x papel de seda!", "info")

        elseif item == 122  then -- Sedas para ganhar o papel de seda
           local uni = 1;

            if (getItem(client, 118) < quantidade) then 
                return sendMessageServer(client, "Você não possui tudo isso de cocaina!", "info")
            end

            takeItem(client, item, quantidade)
            takeItem(client, 118, 1)
            giveItem(client, 124, quantidade * uni)

            sendMessageServer(client, "Você ganhou "..(quantidade * uni).."x cocaina!", "info")

        elseif item == 97 then 
            local uni = 1;

            if (getItem(client, 156) < quantidade) then 
                return sendMessageServer(client, "Você não possui tudo isso de cannabis seco!", "info")
            end

            takeItem(client, item, quantidade)
            takeItem(client, 156, 1)
            giveItem(client, 96, quantidade * uni)

            sendMessageServer(client, "Você bolou e ganhou "..(quantidade * uni).."x maconha!", "info")
        elseif item == 124 then 
            player = client
            local armor = getPedArmor(player)

            if (armor == 100) then 
                return sendMessageServer(client, "Você não precisa cheirar a cocaína!", "info")
            end

            if (timer[client] and isElement(timer[client])) then 
                killTimer(timer[client])
                timer[client] = nil 
            end

            timer[client] = setTimer(function ( player) 
                local armor = getPedArmor(player)
                if armor < 100 then
                    setPedArmor(player, armor + 5)
                end
            end, 1000, 5, client )
            takeItem(client, item, quantidade)
            sendMessageServer(client, "Você cheirou a cocaína!", "info")
        elseif item == 96 then 
            player = client
            local health = getElementHealth(player)

            if (health == 100) then 
                return sendMessageServer(client, "Você não precisa fumar o baseado!", "info")
            end

            if (timer[client] and isElement(timer[client])) then 
                killTimer(timer[client])
                timer[client] = nil 
            end

            timer[client] = setTimer(function ( player) 
                local health = getElementHealth(player)
                if health < 100 then
                    setElementHealth(player, health + 5)
                end
            end, 1000, 5, client )
            takeItem(client, item, quantidade)
            sendMessageServer(client, "Você fumou o baseado!", "info")
        end
    end
end)

function givePlayerMuni (player)
    if getElementData(player, 'guetto.arma.primaria') then 
        local armaPrimaria = getElementData(player, 'guetto.arma.primaria')
        local slotPrimario = getSlotFromWeapon(config["weapons"]["weapons_primary"][armaPrimaria[1]])
        local municoesPrimaria = getPedTotalAmmo(player, slotPrimario)
        if municoesPrimaria > 0 then
            giveItem(player, armaPrimaria[2], municoesPrimaria)
        end
        setElementData(player, 'guetto.arma.primaria', false)
    end
     if getElementData(player, 'guetto.arma.secundaria') then 
        local armaSecundaria = getElementData(player, 'guetto.arma.secundaria')
        local slotSecundario = getSlotFromWeapon(config["weapons"]["weapons_secondarys"][armaSecundaria[1]])
        local municoesSecundaria = getPedTotalAmmo(player, slotSecundario)
        if municoesSecundaria > 0 then
            giveItem(player, armaSecundaria[2], municoesSecundaria)
        end
        setElementData(player, 'guetto.arma.secundaria', false)
    end
end

function getNearestVehicle (player, distance)
    local player_position = Vector3(getElementPosition(player))
    local elementReturn = false
    for index = 1, table.getn(getElementsByType("vehicle")) do 
        local value = getElementsByType("vehicle")[index]
        local vehicle_position = Vector3(getElementPosition(value))
        if (getDistanceBetweenPoints3D(player_position.x, player_position.y, player_position.z, vehicle_position.x, vehicle_position.y, vehicle_position.z) <= distance) then 
            elementReturn = value
        end
    end
    return elementReturn
end

function getPedWeapons(ped)
	local playerWeapons = {}
	if ped and isElement(ped) and getElementType(ped) == "ped" or getElementType(ped) == "player" then
		for i=2,9 do
			local wep = getPedWeapon(ped,i)
			if wep and wep ~= 0 then
				table.insert(playerWeapons,wep)
			end
		end
	else
		return false
	end
	return playerWeapons
end
