local vase = {}
local cache = {}
local timer = {}
local plant = {}
local waterTimer = {}
local drugTimer = {}

function destroyPlantation (player)
    if not (player or not isElement(player) or getElementType(player) ~= 'player') then
        return false 
    end
    if vase[player] then 
        for index, value in pairs (vase[player]) do 
            if value and isElement(value) then 
                destroyElement(value)
            end
            cache[value] = nil 
            if timer[value] and isTimer(timer[value]) then 
                killTimer(timer[value])
                timer[value] = nil 
            end
            if drugTimer[plant[value]] and isTimer(drugTimer[plant[value]]) then 
                killTimer(drugTimer[plant[value]])
                drugTimer[plant[value]] = nil 
            end
            if waterTimer[plant[value]] and isTimer(waterTimer[plant[value]]) then 
                killTimer(waterTimer[plant[value]])
                waterTimer[plant[value]] = nil 
            end
            if plant[value] and isElement(plant[value]) then 
                destroyElement(plant[value])
                planta[value] = nil 
            end
        end
        vase[player] = nil 
    end
end

createEvent("guetto>>create>>vase", root, function (player)

    if not (player or not isElement(player) or getElementType(player) ~= 'player' or isGuestAccount(getPlayerAccount(player))) then
        return false 
    end

    if isPedInVehicle(player) then
        return sendMessageServer(player, "Não pode criar um vaso dentro de um veículo!", "error")
    end

    if not vase[player] then 
        vase[player] = {}
    end

    if #vase[player] >= config["Others"]["Limit"] then 
        return sendMessageServer(player, "Você não pode ter mais de".. config["Others"]["Limit"] .."vasos!", "error")
    end

    local x, y, z = getFrontPosition(player)
    local index = #vase[player] + 1;
    
    vase[player][index] = createObject(1574, x, y, z - 1)
    cache[vase[player][index]] = index;

    setElementData(vase[player][index], "Guetto.VaseDeatails", {
        plant = false,
        type = false, 
        shower = false,
        account = getAccountName(getPlayerAccount(player)),
        owner = (getElementData(player, 'ID') or 0),
        spopon = false,
    })


    exports["guetto_inventory"]:takeItem(player, 40, 1)
end)

createEvent("onPlayerDestroyPlantation", root, function (player, object)

    if not (player or not isElement(player) or getElementType(player) ~= 'player' or isGuestAccount(getPlayerAccount(player))) then
        return false 
    end

    if isPedInVehicle(player) then
        return sendMessageServer(player, "Você não pode mostrar detalhes de uma plantação dentro de um veículo!", "error")
    end

    setElementFrozen(player, true)
    toggleAllControls(player, false)
    setPedAnimation(player, 'BOMBER', 'bom_plant', 5000, true)

    setTimer(function(player)
        if player and isElement(player) then 
            
            setElementFrozen(player, false)
            toggleAllControls(player, true)
            setPedAnimation(player)
            
            if waterTimer[plant[object]] and isTimer(waterTimer[plant[object]]) then 
                killTimer(waterTimer[plant[object]])
                waterTimer[plant[object]] = nil 
            end

            if plant[object] and isElement(plant[object]) then 
                destroyElement(plant[object])
                plant[object] = nil 
            end

            destroyElement(object)
        end
    end, 5000, 1, player, object)

    sendMessageServer(player, "Você começou a destruir a plantação!", "info")
end)

createEvent("onPlayerCollectVase", root, function(player, object)
    if not (player or not isElement(player) or getElementType(player) ~= 'player' or isGuestAccount(getPlayerAccount(player))) then
        return false 
    end
    
    if isPedInVehicle(player) then
        return sendMessageServer(player, "Não pode coletar um vaso dentro de um veículo!", "error")
    end

    if not vase[player] then 
        return false 
    end

    local index = cache[object]
    
    if plant[object] then
        return sendMessageServer(player, "Não é possível coletar o vaso com a planta!", "error")
    end

    if vase[player][index] and isElement(vase[player][index]) then
        destroyElement(vase[player][index])
        vase[player][index] = nil 
        exports["guetto_inventory"]:giveItem(player, 40, 1)
    end

    sendMessageServer(player, "Você pegou o vaso com sucesso!", "success")
end)

createEvent("onPlayerDetailedPlantation", root, function(player, object)

    if not (player or not isElement(player) or getElementType(player) ~= 'player' or isGuestAccount(getPlayerAccount(player))) then
        return false 
    end

    if isPedInVehicle(player) then
        return sendMessageServer(player, "Você não pode mostrar detalhes de uma plantação dentro de um veículo!", "error")
    end

    local details = (getElementData(object, "Guetto.VaseDeatails") or false)
    
    if not details then 
        return false 
    end

    if not plant[object] then 
        return sendMessageServer(player, "Não possui plantação no vaso!", "error")
    end

    triggerClientEvent(player, "onPlayerShowDetailedPlantation", resourceRoot, object, plant[object])
end)

createEvent("onPlayerRequestIrrigation",  resourceRoot, function (object, plant)
    if not (client or ( source ~= resourceRoot ) ) then 
        return false 
    end

    if not isElement(object) or not isElement(plant) then 
        return false 
    end

    local details = (getElementData(object, "Guetto.VaseDeatails") or false)
    
    if not details then 
        return false 
    end

    local quantity = math.random(0, 30)

    if details.shower + quantity > 100 then 
        return sendMessageServer(client, "Essa planta não precisa de irrigação!", "error")
    end

    local amount = exports["guetto_inventory"]:getItem(client, config["Itens"]["Irrigation"])

    if (amount == 0) then 
        return sendMessageServer(client, "Você não possui um regador em seu inventário!", "error")
    end

    exports["guetto_inventory"]:takeItem(client, config["Itens"]["Irrigation"], 1)

    setElementData(object, "Guetto.VaseDeatails", {
        plant = details.plant,
        typePlant = details.typePlant,
        shower = details.shower + quantity,
        owner = details.owner,
        spoon = details.spoon,
        plantObject = details.plantObject,
    })
    sendMessageServer(client, "Você regou a planta com sucesso!", "success")
end)    

createEvent("onPlayerPlantDrug", root, function(player, object, type)
    if not (player or not isElement(player) or getElementType(player) ~= 'player' or isGuestAccount(getPlayerAccount(player))) then
        return false 
    end
    
    if isPedInVehicle(player) then
        return sendMessageServer(player, "Não pode plantar uma droga estando dentro de um veículo!", "error")
    end

    local amount = 0;

    if type == "cocaine" then 
        amount = exports["guetto_inventory"]:getItem(player, config["Seeds"]["cocaine"])
    elseif type == "marihuana" then 
        amount = exports["guetto_inventory"]:getItem(player, config["Seeds"]["marihuana"])
    end

    local text = type == "cocaine" and "cocaina" or "maconha"

    if amount <= 0 then 
        return sendMessageServer(player, "Você não possui semente de "..text.." para plantar!", "error")
    end

    if not vase[player] then
        return false 
    end;

    if plant[object] then 
        return sendMessageServer(player, "Já possui uma planta nesse vaso!", "error")
    end
    
    local index = cache[object]
    local x, y, z = getElementPosition(object);

    setElementFrozen(player, true)
    toggleAllControls(player, false)
    setPedAnimation(player, "BOMBER", "BOM_Plant_Loop", config["Timers"]["Plant"], true, false, false, false, _, true)

    exports["guetto_progress"]:callProgress(player, "Plantando Droga", "Você está plantando uma semente de "..text,  "martelo", config["Timers"]["Plant"])
  
    if type == "cocaine" then 
        exports["guetto_inventory"]:takeItem(player, config["Seeds"]["cocaine"], 1)
    elseif type == "marihuana" then 
        exports["guetto_inventory"]:takeItem(player, config["Seeds"]["marihuana"], 1)
    end
    
    setTimer(function(player)
        if player and isElement(player) then

            setPedAnimation(player)
            toggleAllControls(player, true)
            setElementFrozen(player, false)
                
            plant[object] = createObject(1549, x, y, z - 3)

            setElementDoubleSided(plant[object], true)
            setElementCollisionsEnabled(plant[object], false)

            setElementData(object, "Guetto.VaseDeatails", {
                plant = type,
                typePlant = type,
                account = getAccountName(getPlayerAccount(player)),
                owner = (getElementData(player, 'ID') or 0),
                shower = 100,
                spoon = false,
                plantObject = plant[object],
            })
            drugTimer[plant[object]] = setTimer(function()
                if object and isElement(object) and getElementType(object) == 'object' then 
                    local details = (getElementData(object, "Guetto.VaseDeatails") or false)
                    if details then 
                        if details.spoon then
                            if isTimer(drugTimer[plant[object]]) then killTimer(drugTimer[plant[object]]) end
                            if isTimer(waterTimer[plant[object]]) then killTimer(waterTimer[plant[object]]) end
                        end
                    end
                end
            end, 1000, 0)
            if not isTimer(waterTimer[plant[object]]) then 
                waterTimer[plant[object]] = setTimer(function(planta)
                    if isElement(object) then 
                        local element = (getElementData(object, "Guetto.VaseDeatails") or false)
                        if element then 
                            if element.shower and tonumber(element.shower) and element.shower > 0 then
                                if (element.shower-1) <= 0 then
                                    if isTimer(drugTimer[planta]) then killTimer(drugTimer[planta]) end
                                    if isTimer(waterTimer[planta]) then killTimer(waterTimer[planta]) end
                                    if isElement(planta) then destroyElement(planta) end
                                    plant[object] = nil 
                                    sendMessageServer(player, "A planta morreu, pois faltou água.", "error")
                                    setElementData(object, "Guetto.VaseDeatails", {
                                        plant = false,
                                        typePlant = false,
                                        shower = false,
                                        owner = element.owner,
                                        spoon = false,
                                    })
                                else
                                    setElementData(object, "Guetto.VaseDeatails", {
                                        plant = element.plant,
                                        typePlant = element.typePlant,
                                        owner = element.owner,
                                        shower = (element.shower-1),
                                        spoon = element.spoon,
                                        plantObject = element.plantObject,
                                    })
                                end
                            else
                                if isTimer(waterTimer[plant[object]]) then killTimer(waterTimer[plant[object]]) end
                            end
                        end
                    end
                end, config["Timers"]["Watering"], 0, plant[object])
            end

            moveObject(plant[object], config["Timers"]["Plant grow"], x, y, z)
            sendMessageServer(player, "Você plantou uma semente de "..text.." com sucesso!", "success")
        end
    end, config["Timers"]["Plant"], 1, player)
end)

createEvent("onPlayerRequestPlantation", resourceRoot, function (object, planta)
    if not (client or ( source ~= resourceRoot ) ) then 
        return false 
    end

    if not isElement(object) or not isElement(planta) then 
        return false 
    end

    local details = (getElementData(object, "Guetto.VaseDeatails") or false)
    
    if not details then 
        return false 
    end

    local x, y, z = getElementPosition(object);
    local x2, y2, z2 = getElementPosition(planta);
    
    local floorPositions = (z-z2)
    local calcPositions = math.floor((100-((floorPositions*10)/30*100)));

    if (calcPositions < 100) then 
        return sendMessageServer(client, "Essa planta ainda não está pronta para ser coletada!", "error")
    end
    
    setElementFrozen(client, true)
    toggleAllControls(client, false)

    setPedAnimation(client, "BOMBER", "BOM_Plant_Loop", config["Timers"]["Colet"], true, false, false, false, _, true)
    exports["guetto_progress"]:callProgress(client, "Colhendo Droga", "Você está coletando uma droga",  "martelo", config["Timers"]["Colet"])

    setTimer(function(player, vaso)
        if isElement(player) and isElement(vaso) then 

            setPedAnimation(player, false)
            toggleAllControls(player, true)
            setElementFrozen(player, false)

            setElementData(vaso, "Guetto.VaseDeatails", {
                plant = false,
                typePlant = false,
                owner = details.owner,
                shower = false,
                spoon = false,
                plantObject = false,
            })
        
            if isTimer(drugTimer[plant[object]]) then killTimer(drugTimer[plant[object]]) end
            if isTimer(waterTimer[plant[object]]) then killTimer(waterTimer[plant[object]]) end
            if isElement(plant[object]) then destroyElement(plant[object]) end
            
            plant[object] = nil 

            exports["guetto_inventory"]:giveItem(player, config["Itens"][details.typePlant], 1)
            sendMessageServer(player, "Você colheu a droga com sucesso!", "success")   
        end
    end, config["Timers"]["Colet"], 1, client, object)

    sendMessageServer(client, "Você está coletando uma droga!", "success")    
end)

