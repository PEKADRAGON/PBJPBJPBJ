function createEvent(event, ...)
    addEvent(event, true)
    addEventHandler(event, ...)
end

element = {}
ui = {}
ui.visible = false 
ui.data = {}
ui.ped_cache = {}
ui.sphere = {}
ui.timer = {}

ui.allowedSkins = {
    10, 11, 12, 20, 21, 15
}

ui.svgs = {
    ['rectangle'] = svgCreate(529, 1027, [[
        <svg width="529" height="1027" viewBox="0 0 529 1027" fill="none" xmlns="http://www.w3.org/2000/svg">
            <rect width="529" height="1027" rx="20" fill="#121212" fill-opacity="0.95"/>
        </svg>
    ]]),
    ['slot'] = svgCreate(229, 268, [[
        <svg width="229" height="268" viewBox="0 0 229 268" fill="none" xmlns="http://www.w3.org/2000/svg">
            <rect width="229" height="268" rx="6" fill="white"/>
        </svg>
    ]]);
    ['button-actions'] = svgCreate(150, 58, [[
        <svg width="150" height="58" viewBox="0 0 150 58" fill="none" xmlns="http://www.w3.org/2000/svg">
        <rect width="150" height="58" rx="7" fill="white"/>
        </svg>
    ]]);
    ['rectangle-modal'] = svgCreate(516, 293, [[
        <svg width="516" height="293" viewBox="0 0 516 293" fill="none" xmlns="http://www.w3.org/2000/svg">
        <rect width="516" height="293" rx="20" fill="#121212" fill-opacity="0.95"/>
        </svg>
    ]]);
    ['input'] = svgCreate(422, 80, [[
        <svg width="422" height="80" viewBox="0 0 422 80" fill="none" xmlns="http://www.w3.org/2000/svg">
            <g opacity="0.22">
            <rect width="422" height="80" rx="7" fill="#222323"/>
            </g>
        </svg>
    ]]);
    ['button-action'] = svgCreate(422, 68, [[
        <svg width="422" height="68" viewBox="0 0 422 68" fill="none" xmlns="http://www.w3.org/2000/svg">
            <rect width="422" height="68" rx="2" fill="white"/>
        </svg>
    ]])
}

ui.slots = {
    {74, 124, 229, 268};
    {310, 124, 229, 268};
    
    {74, 402, 229, 268};
    {310, 402, 229, 268};

    {74, 680, 229, 268};
    {310, 680, 229, 268};
}

function getTableAmountItem (mesa, item)
    if not (mesa or item) then
        return 0
    end
    if not isElement(mesa) then 
        return 0 
    end
    local itens = getElementData(mesa, "table.itens") or {}
    for i = 1, #itens do 
        if itens[i].item == item then 
            return itens[i].amount, i 
        end
    end
    return amount
end

function isHaveItemTable (mesa)
    if not (mesa) then
        return false
    end
    if not (isElement(mesa)) then 
        return false 
    end
    local itens = getElementData(mesa, "table.itens") or {}
    for i = 1, #itens do 
        if itens[i].amount > 0 then
            return true, i
        end
    end
    return false 
end

function ui.draw()
    
    if ui.window == "home" then 

        dxDrawImage(42, 26, 529, 1027, ui.svgs['rectangle'], 0, 0, 0, tocolor(255, 255, 255, 255))
        
        dxDrawText("MESA DE DROGAS", 73, 56, 154, 18, tocolor(193, 159, 114, 255), 1, exports["guetto_assets"]:dxCreateFont("bold", 18), "left", "top")
        dxDrawText("Uma nova forma de vender drogas.", 73, 79, 336, 24, tocolor(121, 121, 121, 255), 1, exports["guetto_assets"]:dxCreateFont("regular", 16), "left", "top")

        for i, v in ipairs (ui.slots) do 
            local data = config["itens"][i]
            if data then 
                local InventoryAmount = exports["guetto_inventory"]:getClientItem(data["id"])
                local TableAmount = getTableAmountItem (ui.mesa, data["id"])

                dxDrawImage(v[1], v[2], v[3], v[4], ui.svgs['slot'], 0, 0, 0, ui.select == i and tocolor(53, 53, 53, 255) or isCursorOnElement(v[1], v[2], v[3], v[4]) and tocolor(53, 53, 53, 255) or tocolor(36, 37, 38, 255))
                dxDrawImage(v[1] + v[3] / 2 - 128 / 2, v[2] + 22, 128, 128, data["imagem"], 0, 0, 0, tocolor(255, 255, 255, 255))
                
                dxDrawText("Qtd atual:", v[1] + 22, v[2] + 167, 82, 24, tocolor(255, 255, 255, 255), 1, exports["guetto_assets"]:dxCreateFont("regular", 15), "left", "top")
                dxDrawText("Qtd no inventario:", v[1] + 22, v[2] + 194, 82, 24, tocolor(255, 255, 255, 255), 1, exports["guetto_assets"]:dxCreateFont("regular", 15), "left", "top")
                dxDrawText("Boost:", v[1] + 22, v[2] + 221, 82, 24, tocolor(255, 255, 255, 255), 1, exports["guetto_assets"]:dxCreateFont("regular", 15), "left", "top")
            
                dxDrawText(TableAmount or "0", v[1] + 110, v[2] + 167, 82, 24, tocolor(193, 159, 114, 255), 1, exports["guetto_assets"]:dxCreateFont("regular", 15), "left", "top")
                dxDrawText(InventoryAmount, v[1] + 150, v[2] + 194, 82, 24, tocolor(193, 159, 114, 255), 1, exports["guetto_assets"]:dxCreateFont("regular", 15), "left", "top")
                dxDrawText(ui.booster and "Ativo" or "Desativado", v[1] + 70, v[2] + 221, 78, 18, tocolor(193, 159, 114, 255), 1, exports["guetto_assets"]:dxCreateFont("medium", 15), "left", "top")
            end
        end

        dxDrawImage(74, 968, 150, 58, ui.svgs['button-actions'], 0, 0, 0, isCursorOnElement(74, 968, 150, 58) and tocolor(53, 53, 53, 255) or tocolor(36, 37, 38, 255))
        dxDrawImage(232, 968, 150, 58, ui.svgs['button-actions'], 0, 0, 0, isCursorOnElement(232, 968, 150, 58) and tocolor(53, 53, 53, 255) or tocolor(36, 37, 38, 255))
        dxDrawImage(390, 968, 150, 58, ui.svgs['button-actions'], 0, 0, 0, isCursorOnElement(390, 968, 150, 58) and tocolor(53, 53, 53, 255) or tocolor(36, 37, 38, 255))
    
        dxDrawText("ADICIONAR", 74, 968, 150, 58, tocolor(255, 255, 255, 255), 1, exports["guetto_assets"]:dxCreateFont("regular", 15), "center", "center")
        dxDrawText("REMOVER", 232, 968, 150, 58, tocolor(255, 255, 255, 255), 1, exports["guetto_assets"]:dxCreateFont("regular", 15), "center", "center")
        dxDrawText("GUARDAR MESA", 390, 968, 150, 58, tocolor(255, 255, 255, 255), 1, exports["guetto_assets"]:dxCreateFont("regular", 15), "center", "center")
   
        if ui.modal and ui.modal == "add" or ui.modal == "remove" then 
            dxDrawImage(720, 393, 516, 293, ui.svgs['rectangle-modal'], 0, 0, 0, tocolor(255, 255, 255, 255))
            dxDrawText(ui.modal == "add" and "ADICIONE A DROGA" or "REMOVER A DROGA", 767, 424, 153, 16, tocolor(193, 159, 114, 114), 1, exports["guetto_assets"]:dxCreateFont("bold", 15), "left", "center")
            dxDrawText("Escolha a quantidade que deseja.", 767, 447, 153, 16, tocolor(121, 121, 121, 114), 1, exports["guetto_assets"]:dxCreateFont("regular", 15), "left", "center")
      
            dxDrawImage(767, 492, 422, 80, ui.svgs['input'], 0, 0, 0, tocolor(255, 255, 255, 255))
            dxDrawImage(767, 591, 422, 68, ui.svgs['button-action'], 0, 0, 0, isCursorOnElement(767, 591, 422, 68) and tocolor(53, 53, 53, 255) or tocolor(34, 35, 35, 255))

            dxDrawText("CONFIRMAR", 767, 591, 422, 68, tocolor(255, 255, 255, 255), 1, exports["guetto_assets"]:dxCreateFont("bold", 15), "center", "center")

            dxCreateEditbox("EditBox:Amount", {767, 492, 422, 80}, 10, {211, 211, 211, alpha}, exports["guetto_assets"]:dxCreateFont("medium", 15), 'Quantidade', true, false, true, false, false)
        
        end

    end

end

function ui.click (button, state)
    if button == 'left' and state == 'down' then 
        for i, v in ipairs (ui.slots) do 
            local data = config["itens"][i]
            if data then 
                if isCursorOnElement(v[1], v[2], v[3], v[4]) then 
                    ui.select = i
                    break 
                end
            end
        end
        if isCursorOnElement(74, 968, 150, 58) then 
            if ui.select ~= 0 then 
                local data = config["itens"][ui.select]
                if data then 
                    ui.modal = "add"
                end
            else
                sendMessageClient('Selecione uma droga!', 'info')
            end
        elseif isCursorOnElement(232, 968, 150, 58) then 
            if ui.select ~= 0 then 
                local data = config["itens"][ui.select]
                if data then 
                    ui.modal = "remove"
                end
            else
                sendMessageClient('Selecione uma droga!', 'info')
            end
        elseif isCursorOnElement(390, 968, 150, 58) then 
            triggerServerEvent("onPlayerSaveTable", resourceRoot)
            element.destroyPed(localPlayer)
            dialogue.functions.toggle(false)
            ui.toggle(false)
        end
        if ui.modal and ui.modal == "add" then 
            if isCursorOnElement(767, 591, 422, 68) then 
                local amount = dxEditboxGetText("EditBox:Amount").content
                if amount == 0  then 
                    return sendMessageClient('Quantidade inválida!', 'error')
                end
                triggerServerEvent("onPlayerGiveMesaItem", resourceRoot, ui.mesa, amount, ui.select)
                ui.modal = false
                ui.toggle(false)
                dialogue.functions.toggle(false)
            end
        elseif ui.modal and ui.modal == "remove" then 
            if isCursorOnElement(767, 591, 422, 68) then 
                local amount = dxEditboxGetText("EditBox:Amount").content
                if amount == 0  then 
                    return sendMessageClient('Quantidade inválida!', 'error')
                end
                triggerServerEvent("onPlayerTakeMesaItem", resourceRoot, ui.mesa, amount, ui.select)
                ui.modal = false
                ui.toggle(false)
                dialogue.functions.toggle(false)
            end
        end
    end
end

function ui.key (button, state)
    if button == "backspace" and state then 
        if not (ui.modal) then 
            if not (dxEditBoxEnable("EditBox:Amount")) then
                ui.toggle(false)
            end
        else
            ui.modal = false 
        end
    end
end

function ui.toggle (state)
    if state and not ui.visible then
        
        ui.visible = true
        ui.window = "home"

        ui.modal = false;
        ui.select = 0;

        showCursor(true)
        showChat(false)

        addEventHandler("onClientRender", root, ui.draw)
        addEventHandler("onClientClick", root, ui.click)
        addEventHandler("onClientKey", root, ui.key)

    elseif not state and ui.visible then
        ui.visible = false

        showCursor(false)
        showChat(true)

        dxEditboxDestroy("EditBox:Amount")

        removeEventHandler("onClientRender", root, ui.draw)
        removeEventHandler("onClientClick", root, ui.click)
        removeEventHandler("onClientKey", root, ui.key)
    end
end 

function element.destroyPed ( owner )
    if ui.data[owner].ped and isElement(ui.data[owner].ped) then 
        destroyElement(ui.data[owner].ped)
        ui.data[owner].ped = nil
    end

    if ui.sphere[owner] and isElement(ui.sphere[owner]) then 
        destroyElement(ui.sphere[owner])
        ui.sphere[owner] = nil 
    end
end

function element.createPed ( owner, mesa )
    if not ui.data[owner] then 
        ui.data[owner] = {}
    end

    if ui.data[owner].ped and isElement(ui.data[owner].ped) then 
        destroyElement(ui.data[owner].ped)
    end

    if ui.sphere[owner] and isElement(ui.sphere[owner]) then 
        destroyElement(ui.sphere[owner])
    end

    local player_pos = {getElementPosition(owner)}
    local player_rot = {getElementRotation(owner)}
    local mesa_pos = {getElementPosition(mesa)}

    local x, y, z = getFrontPosition ( owner );
    local random = math.random(#ui.allowedSkins)

    ui.data[owner].ped = createPed(ui.allowedSkins[random], x, y, z)
    ui.owner = owner;

    ui.item = math.random(1, #config["itens"])
    ui.amount = math.random(1, 5)

    ui.ped_cache[ui.data[owner].ped] = owner;
    ui.sphere[owner] = createColSphere(mesa_pos[1], mesa_pos[2], mesa_pos[3], 2.5)

    setElementRotation(ui.data[owner].ped, player_rot[1], player_rot[2], player_rot[3])

    local distX = x - player_pos[1]
    local distY = y - player_pos[2]
    local angle = -math.deg(math.atan2(distX, distY)) + 180 

    setPedRotation(ui.data[owner].ped, angle)

    setPedControlState(ui.data[owner].ped, "forwards", true)
    setPedControlState(ui.data[owner].ped, "walk", true)

    addEventHandler("onClientColShapeHit", ui.sphere[owner], onShapeHit)
    addEventHandler("onClientColShapeLeave", ui.sphere[owner], onShapeLeave)
end

function onShapeHit (element, dim)
    if element and isElement(element) and getElementType(element) == 'ped' and dim then 
        if ui.ped_cache[element] and isElement(ui.ped_cache[element]) then 

            if ui.timer[ui.ped_cache[element]] and isTimer(ui.timer[ui.ped_cache[element]]) then 
                killTimer(ui.timer[ui.ped_cache[element]])
                ui.timer[ui.ped_cache[element]] = nil 
            end


            setTimer(function(ped)
                if isElement(ped) then 
                    setPedControlState(ped, "forwards", false)
                    setPedControlState(ped, "walk", false)
                    setTimer(function(ped)
                        if isElement(ped) then 
                            setPedAnimation(ped, "GANGS", "prtial_gngtlkb", -1, true, false, false, false)
                        end
                    end, 1000, 1, ped)
                    triggerServerEvent("onPlayerCallServerRender", resourceRoot, ui.ped_cache[element])
                end
            end, 1000, 1, element)
        end
    end
end

function onShapeLeave (player, dim)
    if player and isElement(player) and getElementType(player) == 'player' and dim then


        if ui.sphere[player] and isElement(ui.sphere[player]) and ui.sphere[player] == source then 
            
            if ui.timer[player] and isElement(ui.timer[player]) then 
                killTimer(ui.timer[player])
                ui.timer[player] = nil 
            end

            triggerServerEvent("onPlayerServerNotification", resourceRoot, player, "Você saiu de perto da mesa. Volte em 10 segundos ou sua mesa será destruída.", "info")

            ui.timer[player] = setTimer(function(player)

                if ui.sphere[player] and isElement(ui.sphere[player]) then 
                    destroyElement(ui.sphere[player])
                    ui.sphere[player] = nil 
                end

                triggerServerEvent("onPlayerLeaveMesa", resourceRoot, player)
                element.destroyPed(player)
                ui.toggle(false)
                dialogue.functions.toggle(false)
            end, 10000, 1, player)
        end
    end
end

createEvent("createPedTable", resourceRoot, function(owner, mesa, data, booster)
    ui.mesaData = data;
    ui.booster = booster
end)

createEvent("destroyPed", resourceRoot, function (owner)
    if isElement(owner) then 
        element.destroyPed(owner)
    end
end)

createEvent("createPed", resourceRoot, function (owner, mesa)
    if (isElement(owner) and isElement(mesa)) then
        element.createPed(owner, mesa)
    end
end)

createEvent("drawTable", resourceRoot, function ( object )
    if (object and isElement(object)) then 
        if not (dialogue.ui.visible) then 
            ui.toggle(true)
        end
        ui.mesa = object
    end
end)

