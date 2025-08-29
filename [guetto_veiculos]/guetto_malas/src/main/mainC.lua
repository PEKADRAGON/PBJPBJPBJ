-- Var´s 

local interface = {
    animations = {
        alpha = {0, 0, 0}
    }
}

local window = "bag"
local assets = exports['guetto_assets']

local slots = {
    
    ["inv"] = {
        {387, 303, 101, 117};
        {491, 303, 101, 117};
        {595, 303, 101, 117};
        {699, 303, 101, 117};
        {803, 303, 101, 117};

        {387, 423, 101, 117};
        {491, 423, 101, 117};
        {595, 423, 101, 117};
        {699, 423, 101, 117};
        {803, 423, 101, 117};


        {387, 543, 101, 117};
        {491, 543, 101, 117};
        {595, 543, 101, 117};
        {699, 543, 101, 117};
        {803, 543, 101, 117};

        {387, 663, 101, 117};
        {491, 663, 101, 117};
        {595, 663, 101, 117};
        {699, 663, 101, 117};
        {803, 663, 101, 117};
    };

    ["malas"] = {


        {1008, 303, 101, 117};
        {1112, 303, 101, 117};
        {1216, 303, 101, 117};
        {1320, 303, 101, 117};
        {1424, 303, 101, 117};

        {1008, 423, 101, 117};
        {1112, 423, 101, 117};
        {1216, 423, 101, 117};
        {1320, 423, 101, 117};
        {1424, 423, 101, 117};


        {1008, 543, 101, 117};
        {1112, 543, 101, 117};
        {1216, 543, 101, 117};
        {1320, 543, 101, 117};
        {1424, 543, 101, 117};

        {1008, 663, 101, 117};
        {1112, 663, 101, 117};
        {1216, 663, 101, 117};
        {1320, 663, 101, 117};
        {1424, 663, 101, 117};

    };

}

local categorias = {
    {744, 241, 36, 41, "assets/images/bag.png", "bag"};
    {799, 239, 47, 47, "assets/images/ilegal.png", "ilegal"};
    {865, 241, 43, 43, "assets/images/food.png", "food"};
}

-- Func´s 

function getItensByIndex (tbl, index)
    if tbl then 
        for i, v in ipairs(tbl) do 
            if v.slot == index then 
                return i, v.slot, v.amount, v.item
            end
        end;
    end;
    return false;
end;

function draw ( )
    local fade = interpolateBetween ( interface.animations.alpha[1], 0, 0, interface.animations.alpha[2], 0, 0, (getTickCount ( ) - interface.animations.alpha[3]) / 400, "Linear" )

    interface.buttons = {}

    dxDrawImage(355,  203, 1210, 673, "assets/images/fundo.png", 0, 0, 0, tocolor(255, 255, 255, fade))

    for i, v in ipairs(slots.inv) do 
        local x, y, w, h = v[1], v[2], v[3], v[4]
        local index, slot, amount, item = getItensByIndex(interface.inventory.itens[window], i)
        
        if index then 
            local image = ":guetto_inventory/assets/itens/"..interface.inventory.itens[window][index].item..".png"
            
            dxDrawImage ( x + w / 2 - 48 / 2, y + h / 2 - 48 / 2, 48, 48, image, 0, 0, 0, tocolor(255, 255, 255, fade))
            dxDrawText(amount, x + 8, y + 8, 43, 23, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'left', 'top')
        end;

        dxDrawImage ( x, y, w, h, "assets/images/slot.png", 0, 0, 0, isCursorOnElement(x, y, w, h) and tocolor(217, 217, 217, 0.10 * fade) or tocolor(217, 217, 217, 0.02 * fade))
        interface.buttons["slots_inv:"..i] = {x, y, w, h}
    end;

    for i, v in ipairs(slots.malas) do 
        local x, y, w, h = v[1], v[2], v[3], v[4]
        local index, slot, amount, item = getItensByIndex(interface.malas.itens, i)
        
        if index then 
            local image = ":guetto_inventory/assets/itens/"..interface.malas.itens[index].item..".png"
            
            dxDrawImage ( x + w / 2 - 48 / 2, y + h / 2 - 48 / 2, 48, 48, image, 0, 0, 0, tocolor(255, 255, 255, fade))
            dxDrawText(amount, x + 8, y + 8, 43, 23, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'left', 'top')
        end;

        dxDrawImage ( x, y, w, h, "assets/images/slot.png", 0, 0, 0, isCursorOnElement(x, y, w, h) and tocolor(217, 217, 217, 0.10 * fade) or tocolor(217, 217, 217, 0.02 * fade))
        interface.buttons["slots_malas:"..i] = {x, y, w, h}
    end;

    for i, v in ipairs(categorias) do 
        local x, y, w, h, img = unpack(v)

        dxDrawImage(x, y, w, h, img, 0, 0, 0, isCursorOnElement(x, y, w, h) and tocolor(193, 159, 114, fade) or window == v[6] and tocolor(193, 159, 114, fade) or tocolor(36, 36, 36, fade))
    end;

    if interface.moveItem then 

        if interface.moveType == "malas" then 
            data = interface.malas.itens[interface.moveItem]
        else
            data = interface.inventory.itens[window][interface.moveItem]
        end
        
        local cx, cy = getCursorPosition ( );
        local tx, ty = cx * 1920, cy * 1080;
        
        local image = ":guetto_inventory/assets/itens/"..data.item..".png"

        dxDrawImage ( tx - 101 / 2, ty - 117 / 2, 101, 117, "assets/images/slot.png", 0, 0, 0,  tocolor(217, 217, 217, 0.02 * fade))
        dxDrawImage ( tx - 48 / 2, ty - 48 / 2, 48, 48, image, 0, 0, 0, tocolor(255, 255, 255, fade))
    end;


    dxDrawText("Porta Malas", 387, 234, 93, 30, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('medium', 20), 'left', 'top')
    dxDrawText("Usado para guardar itens", 387, 262, 192, 23, tocolor(116, 116, 116, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'left', 'top')

    
    dxDrawText("Porta Malas", 1007, 234, 93, 30, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('medium', 20), 'left', 'top')
    dxDrawText("Usado para guardar itens", 1008, 262, 192, 23, tocolor(116, 116, 116, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'left', 'top')

    dxDrawText("Peso total", 387, 800, 77, 23, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'left', 'top')
    dxDrawText(""..string.format('%.1f',interface.inventory['player'].actualWeight).."/"..(interface.inventory['player'].maxWeight).."KG", 828, 800, 77, 23, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'left', 'top')

    dxDrawImage(1010, 790, 203, 43, "assets/images/input-qnt.png", 0, 0, 0, tocolor(255, 255, 255, 0.02 * fade))
    dxDrawText(""..string.format('%.1f',interface.malas.data.actualWeight).."/"..(interface.malas.data.maxWeight).."KG", 1449, 800, 77, 23, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'left', 'top')

    dxDrawEditbox(1010, 790, 203, 43, 10, "quantidade")

    if isBoxActive("quantidade") then 
        dxDrawText(getEditboxText("quantidade").."|", 1010, 792, 203, 43, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("light", 18), "center", "center")
    else
        dxDrawText((#getEditboxText("quantidade") ~= 0) and getEditboxText("quantidade") or "Quantidade", 1010, 792, 203, 43, tocolor(94, 94, 94, fade), 1, exports['guetto_assets']:dxCreateFont("light", 18), "center", "center")
    end

end;


function interfaceOpen ( )
    if not isEventHandlerAdded("onClientRender", root, draw) then 
        interface.animations.alpha[1],interface.animations.alpha[2], interface.animations.alpha[3] = 0, 255, getTickCount ( )
        interface.buttons = false;
        interface.moveItem = false;
        interface.moveType = false;
        showCursor(true)
        showChat(false)
        setElementData(localPlayer, "guetto.open.malas", true)
        addEventHandler("onClientRender", root, draw)
    end
end;

function interfaceClose ( )
    if isEventHandlerAdded("onClientRender", root, draw) then
        interface.animations.alpha[1],interface.animations.alpha[2], interface.animations.alpha[3] = 255, 0, getTickCount ( )
        showCursor(false)
        showChat(true)
        setTimer (function()
            removeEventHandler("onClientRender", root, draw)
            setElementData(localPlayer, "guetto.open.malas", false)
            destroyElements()
        end, 400, 1)
        triggerServerEvent("guetto.malas.close", resourceRoot, localPlayer, interface.vehicle)
    end
end;

-- Event´s 

addEventHandler("onClientClick", root, function(button, state)
    if isEventHandlerAdded("onClientRender", root, draw) then
        if (button == "left") then
            if (state == "down") then 
                for i, v in pairs(interface.buttons) do 
                    
                    if (isCursorOnElement(unpack(v))) then 
                        local separate = split(i, ":")
                       
                        if separate[1] == "slots_inv" then 
                            local index, slot, amount, item = getItensByIndex(interface.inventory.itens[window], tonumber(separate[2]))
                       
                            if index then 
                                interface.moveItem = index
                                interface.moveType = "inv"
                            end
                            
                        elseif separate[1] == "slots_malas" then 
                        
                            local index, slot, amount, item = getItensByIndex(interface.malas.itens, tonumber(separate[2]))
                       
                            if index then 
                                interface.moveItem = index
                                interface.moveType = "malas"
                            end
                        end
                    end
                end

                for i, v in ipairs(categorias) do 
                    local x, y, w, h = unpack(v)
                    if isCursorOnElement(x, y, w, h) then 
                        window = v[6]
                        break
                    end
                end
            elseif (state == "up") then 
                if (interface.moveItem) then 
                    if interface.moveType == "inv" then 
                        for i, v in ipairs(slots.malas) do 
                            if isCursorOnElement(unpack(v)) then 
                                local qnt = getEditboxText("quantidade")
                                
                                if #qnt == 0 then 
                                    interface.moveType = false;
                                    interface.moveItem = false; 
                                    return config.sendMessageClient("Digite a quantidade!", "error")
                                end;
                                
                                if qnt == "Quantidade" then 
                                    interface.moveType = false;
                                    interface.moveItem = false; 
                                    return config.sendMessageClient("Digite a quantidade!", "error")
                                end;
                                
                                if tonumber(qnt) > interface.inventory.itens[window][interface.moveItem].amount then 
                                    interface.moveType = false;
                                    interface.moveItem = false; 
                                    return config.sendMessageClient("Você não tem essa quantidade!", "error")
                                end;

                                triggerServerEvent("guetto.moveItem", resourceRoot, localPlayer, interface.moveType, interface.inventory.itens[window][interface.moveItem].item, tonumber(qnt), interface.vehicle)
                                break
                            end
                        end;

                    elseif interface.moveType == "malas" then 
                        for i, v in ipairs(slots.inv) do 
                            if isCursorOnElement(unpack(v)) then 
                                local qnt = getEditboxText("quantidade")
                                
                                if #qnt == 0 then 
                                    return config.sendMessageClient("Digite a quantidade!", "error")
                                end;
                                
                                if qnt == "Quantidade" then 
                                    return config.sendMessageClient("Digite a quantidade!", "error")
                                end;
                                
                                if tonumber(qnt) > interface.malas.itens[interface.moveItem].amount then 
                                    return config.sendMessageClient("Você não tem essa quantidade!", "error")
                                end;

                                triggerServerEvent("guetto.moveItem", resourceRoot, localPlayer, interface.moveType, interface.malas.itens[interface.moveItem].item, qnt, interface.vehicle)
                                break
                            end
                        end;
                    end
                    interface.moveType = false;
                    interface.moveItem = false; 
                end
            end;    
        end
    end
end)

registerEventHandler("guetto.draw.malas", resourceRoot, function (malas, inventory, vehicle)
    interface.malas = malas;
    interface.inventory = inventory;
    interface.vehicle = vehicle;
    interfaceOpen()
end)

registerEventHandler("guetto.client.update.malas", resourceRoot, function (malas, inventory, vehicle)
    interface.malas = malas;
    interface.inventory = inventory;
    interface.vehicle = vehicle;
end)

bindKey("backspace", "down", function ( )
    interfaceClose()
end)