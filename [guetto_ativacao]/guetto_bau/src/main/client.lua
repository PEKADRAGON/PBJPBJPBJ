local isEventHandleerAdded = false 
local alpha = {}

local assets = exports['guetto_assets']

local slots = {
    password = {
        {854, 426, 59, 66, '1'};
        {921, 426, 59, 66, '2'};
        {989, 426, 59, 66, '3'};

        {854, 501, 59, 66, '4'};
        {921, 501, 59, 66, '5'};
        {989, 501, 59, 66, '6'};

        {854, 576, 59, 66, '7'};
        {921, 576, 59, 66, '8'};
        {989, 576, 59, 66, '9'};

        {921, 651, 59, 66, '0'};
    },
    
    chest = {
        {1003, 324, 101, 117};
        {1108, 324, 101, 117};
        {1213, 324, 101, 117};
        {1318, 324, 101, 117};
        {1423, 324, 101, 117};

        {1003, 445, 101, 117};
        {1108, 445, 101, 117};
        {1213, 445, 101, 117};
        {1318, 445, 101, 117};
        {1423, 445, 101, 117};

        {1003, 566, 101, 117};
        {1108, 566, 101, 117};
        {1213, 566, 101, 117};
        {1318, 566, 101, 117};
        {1423, 566, 101, 117};

        {1003, 687, 101, 117};
        {1108, 687, 101, 117};
        {1213, 687, 101, 117};
        {1318, 687, 101, 117};
        {1423, 687, 101, 117};
    };

    inventory = {
        {397, 324, 101, 117};
        {502, 324, 101, 117};
        {607, 324, 101, 117};
        {712, 324, 101, 117};
        {817, 324, 101, 117};

        {397, 445, 101, 117};
        {502, 445, 101, 117};
        {607, 445, 101, 117};
        {712, 445, 101, 117};
        {817, 445, 101, 117};

        {397, 566, 101, 117};
        {502, 566, 101, 117};
        {607, 566, 101, 117};
        {712, 566, 101, 117};
        {817, 566, 101, 117};

        {397, 687, 101, 117};
        {502, 687, 101, 117};
        {607, 687, 101, 117};
        {712, 687, 101, 117};
        {817, 687, 101, 117};
    };

}

function draw ( )
    local fade = interpolateBetween(alpha[1], 0, 0, alpha[2], 0, 0, (getTickCount() - alpha[3]) / 400, 'Linear')
    
    if window == 'password' then 
        
        dxDrawRoundedRectangle(796, 294, 311, 505, tocolor(18, 18, 18, fade), 8, false)
        dxDrawRoundedRectangle(854, 354, 195, 50, tocolor(50, 50, 50, 0.30 * fade), 3, false)
        dxDrawImage(1055, 280, 69, 66, 'assets/images/icon-weapon.png', 0, 0, 0, tocolor(255, 255, 255, fade))

        for i, v in ipairs ( slots.password ) do 
            dxDrawRoundedRectangle(v[1], v[2], v[3], v[4], isCursorOnElement(v[1], v[2], v[3], v[4]) and tocolor(102, 102, 102, fade) or tocolor(61, 61, 61, fade), 5, false)
            dxDrawText(v[5], v[1], v[2] + 5, v[3], v[4], tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 40), 'center', 'center')
        end

        dxDrawImage(854, 652, 59, 66, 'assets/images/button-acessar.png', 0, 0, 0, tocolor(255, 255, 255, fade))
        dxDrawImage(990, 652, 59, 66, 'assets/images/button-close.png', 0, 0, 0, tocolor(255, 255, 255, fade))
    
        dxDrawText('[BACKSPACE] PARA FECHAR', 841, 750, 232, 16, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 16), 'center', 'center')
        dxDrawText(string.gsub(tostring(number), '.', '*'), 930, 375, 44, 15, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'center', 'center')

    elseif window == 'chest' then 

        dxDrawRoundedRectangle(360, 209, 593, 662, tocolor(18, 18, 18, 0.96 * fade), 17)
        dxDrawRoundedRectangle(966, 209, 593, 662, tocolor(18, 18, 18, 0.96 * fade), 17)

        dxDrawText('bag', 397, 243, 93, 30, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('medium', 20), 'left', 'top')
        dxDrawText('Sua bag com itens.', 397, 271, 93, 30, tocolor(116, 116, 116, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'left', 'top')

        dxDrawText('Baú de itens', 1004, 243, 93, 30, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('medium', 20), 'left', 'top')
        dxDrawText('Usado para guardar itens', 1004, 271, 93, 30, tocolor(116, 116, 116, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'left', 'top')

        for i, v in ipairs ( slots.inventory ) do 
            local index, slot, amount, item = getItensByIndex ( inventory_player.itens[select_aba], i )

            dxDrawRoundedRectangle(v[1], v[2], v[3], v[4], not select_qnt and isCursorOnElement(v[1], v[2], v[3], v[4]) and tocolor(217, 217, 217, 0.08 * fade) or tocolor(217, 217, 217, 0.05 * fade), 3)

            if slot == i then 
                local image = ":guetto_inventory/assets/itens/"..item..".png"
                
                dxDrawImage ( v[1] + v[3] / 2 - 48 / 2, v[2] + v[4] / 2 - 48 / 2, 48, 48, image, 0, 0, 0, tocolor(255, 255, 255, fade))
                dxDrawText(amount, v[1] + 9, v[2] + 7, 43, 23, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'left', 'top')
            end

        end

        local line = 0
        for i, v in ipairs ( slots.chest ) do 
                line = (line + 1)
                local data = inventory_chest[i + page]
                if (data) then 
                    local image = ":guetto_inventory/assets/itens/"..(tonumber(data.id))..".png"
                    local amount = tonumber(data.ammount)
                    dxDrawImage ( v[1] + v[3] / 2 - 48 / 2, v[2] + v[4] / 2 - 48 / 2, 48, 48, image, 0, 0, 0, tocolor(255, 255, 255, fade))
                    dxDrawText(amount, v[1] + 9, v[2] + 7, 43, 23, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'left', 'top')
                end
            dxDrawRoundedRectangle(v[1], v[2], v[3], v[4], not select_qnt and isCursorOnElement(v[1], v[2], v[3], v[4]) and tocolor(217, 217, 217, 0.08 * fade) or tocolor(217, 217, 217, 0.05 * fade), 3)
        end

        dxDrawImage(1270, 255, 24, 24, svg['mouse-icon'], 0, 0, 0, tocolor(193, 159, 144, fade))
        dxDrawText('Arraste os itens para guardar.', 1302, 255, 222, 23, tocolor(116, 116, 116, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'left', 'top')

        dxDrawImage(754, 248, 36, 43, svg['bag-icon'], 0, 0, 0, select_aba == 'bag' and tocolor(193, 159, 114, fade) or isCursorOnElement(754, 248, 36, 43) and tocolor(193, 159, 114, fade) or tocolor(36, 36, 36, fade))
        dxDrawImage(809, 248, 47, 47, svg['ilegal-icon'], 0, 0, 0, select_aba == 'ilegal' and tocolor(193, 159, 114, fade) or isCursorOnElement(809, 248, 47, 47) and tocolor(193, 159, 114, fade) or tocolor(36, 36, 36, fade))
        dxDrawImage(875, 248, 43, 43, svg['food-icon'], 0, 0, 0, select_aba == 'food' and tocolor(193, 159, 114, fade) or isCursorOnElement(875, 248, 43, 43) and tocolor(193, 159, 114, fade) or tocolor(36, 36, 36, fade))

        dxDrawText('Peso', 398, 818, 36, 23, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'left', 'top')
        dxDrawText('Peso', 1004, 818, 36, 23, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'left', 'top')

        dxDrawText(string.format('%.1f', math.floor(inventory_weight[1]))..'/'..string.format('%.1f', inventory_weight[2]), 842+30, 818, 36, 23, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'right', 'top')
        dxDrawText(string.format('%.1f', math.floor(chest_weight[1]))..'/'..string.format('%.1f', chest_weight[2]), 1448+30, 818, 36, 23, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'right', 'top')

        dxDrawRectangle(449, 826, 310, 9, tocolor(31, 30, 30, fade))
        dxDrawRectangle(1055, 826, 310, 9, tocolor(31, 30, 30, fade))
        
        local width_inventory = 200 * (inventory_weight[1] / inventory_weight[2])
        local width_chest = 200 * (chest_weight[1] / chest_weight[2])

        dxDrawRectangle(449, 826, width_inventory, 9, tocolor(193, 159, 114, fade))
        dxDrawRectangle(1055, 826, width_chest, 9, tocolor(193, 159, 114, fade))

        if select_inventory and select_inventory ~= 0 then 
            local image = ":guetto_inventory/assets/itens/"..select_inventory..".png"
            local cx, cy = getCursorPosition ( );
            local tx, ty = cx * 1920, cy * 1080;

            dxDrawImage ( tx - 48 / 2, ty - 48 / 2, 48, 48, image, 0, 0, 0, tocolor(255, 255, 255, fade))
            dxDrawRoundedRectangle(tx - 101 / 2, ty - 117 /2, 101, 117, tocolor(217, 217, 217, 0.05 * fade), 3)
        end

        if select_qnt then 
            dxDrawImage(360, 209, 1199, 662, 'assets/images/blur.png', 0, 0, 0, tocolor(255, 255, 255, fade))
            dxDrawRoundedRectangle(775, 382, 370, 288, tocolor(25, 25, 25, 0.96 * fade), 20)
            
            dxDrawText('Quantidade', 813, 421, 99, 16, tocolor(193, 159, 114, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 16), 'left', 'top')
            dxDrawText('Escolha a quantidade de itens que deseja.', 814, 441, 242, 17, tocolor(121, 121, 121, fade), 1, exports['guetto_assets']:dxCreateFont('light', 14), 'left', 'top')

            dxDrawRoundedRectangle(814, 489, 296, 57, tocolor(128, 128, 128, 0.04 * fade), 4)
            dxDrawRoundedRectangle(815, 566, 296, 59, isCursorOnElement(815, 568, 296, 59) and tocolor(255, 255, 255, 0.08 * fade) or tocolor(255, 255, 255, 0.06 * fade), 4)

            dxDrawEditbox(814, 489, 296, 57, 10, "Quantidade")

            dxDrawText('[BACKSPACE] PARA FECHAR', 849, 683, 222, 16, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'center', 'center')
            dxDrawText('CONFIRMAR', 815, 568, 296, 59, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'center', 'center')
     
            if isBoxActive("Quantidade") then 
                dxDrawText(getEditboxText("Quantidade").."|", 814, 491, 296, 57, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("regular", 15), "center", "center")
            else
                dxDrawText((#getEditboxText("Quantidade") ~= 0) and getEditboxText("Quantidade") or "Quantidade", 814, 491, 296, 57, tocolor(94, 94, 94, fade), 1, exports['guetto_assets']:dxCreateFont("regular", 15), "center", "center")
            end

        end


        if select_chest then 
            local image = ":guetto_inventory/assets/itens/"..select_chest..".png"
            local cx, cy = getCursorPosition ( );
            local tx, ty = cx * 1920, cy * 1080;

            dxDrawImage ( tx - 48 / 2, ty - 48 / 2, 48, 48, image, 0, 0, 0, tocolor(255, 255, 255, fade))
            dxDrawRoundedRectangle(tx - 101 / 2, ty - 117 /2, 101, 117, tocolor(217, 217, 217, 0.05 * fade), 3)
        end
   
    end

end

function toggleChest (state)
    if spam and getTickCount() - spam <= 400 then return false end 
    if (state and not isEventHandleerAdded) then 
        isEventHandleerAdded = true 
        select_chest = false
        page = 0
        select_inventory = false
        select_qnt = false
        window = 'password'
        select_aba = 'ilegal'
        number = ''
        alpha = {0, 255, getTickCount()}
        showCursor(true)
        showChat(false)
        setElementData(localPlayer, 'chest.open', true)
        addEventHandler('onClientRender', root, draw)
    elseif not (state and isEventHandleerAdded) then 
        isEventHandleerAdded = false 
        alpha = {255, 0, getTickCount()}
        showCursor(false)
        showChat(true)
        setElementData(localPlayer, 'chest.open', false)
        if (chest_element and isElement(chest_element)) then 
            triggerServerEvent('chest.used', resourceRoot, chest_element)
        end
        setTimer(function()
            removeEventHandler('onClientRender', root, draw)
        end, 400, 1)
    end
    spam = getTickCount()
end

registerEventHandler("onClientDrawChest", resourceRoot,
    function ( ...  )
        local args = { ... }
        id = args[1]
        password = args[2]
        inventory_player = args[3]
        inventory_weight = args[4]
        inventory_chest = args[5]
        chest_weight = args[6]
        chest_element = args[7]
        toggleChest(true, password)
    end
)

registerEventHandler("onPlayerToggleChest", root, function ( )
    toggleChest(false)
end)

addEventHandler('onClientClick', root, function ( button, state )
    if isEventHandleerAdded then 
        if button == 'left' then 
            if state == 'down' then 
                if window == 'password' then 
                    for i, v in ipairs ( slots.password ) do 
                        if isCursorOnElement(v[1], v[2], v[3], v[4]) then 
                            number = number..v[5]
                            break 
                        end
                    end
                    if isCursorOnElement(990, 652, 59, 66) then 
                        number = tostring(number):sub(1, -2)
                    elseif isCursorOnElement(854, 652, 59, 66) then 
                        if number == password then 
                            window = 'chest'
                        else
                            sendMessageClient('Senha incorreta!', 'error')
                        end
                    end
                elseif window == 'chest' then 
                    for i, v in ipairs ( slots.inventory ) do 
                        local index, slot, amount, item = getItensByIndex ( inventory_player.itens[select_aba], i )
                        if isCursorOnElement(v[1], v[2], v[3], v[4]) then 
                            select_inventory = item
                            break 
                        end
                    end
                    for i, v in ipairs ( slots.chest ) do 
                        if isCursorOnElement(v[1], v[2], v[3], v[4]) then 
                            local data = inventory_chest[i + page]
                            if (data) then 
                                select_chest = tonumber(data.id)
                                break
                            end
                        end
                    end
                    if select_qnt then 
                        if isCursorOnElement(815, 566, 296, 59) then 
                            local qnt = getEditboxText("Quantidade")
                            if (#qnt == 0 or qnt == '' or qnt == 'Quantidade') then 
                                return sendMessageClient('Digite a quantidade!',' error')
                            end
                            
                            if qnt == 0 then 
                                return sendMessageClient('Tente novamente!', 'error')
                            end

                            if move_type == 'chest' then 
                                triggerServerEvent('onPlayerGiveChestItem', resourceRoot, item_cache, qnt, id)
                            elseif move_type == 'inventory' then 
                                triggerServerEvent('onPlayerGiveInventoryItem', resourceRoot, item_cache, qnt, id)
                            end
                        end
                    end
                    if isCursorOnElement(754, 248, 36, 43) then 
                        select_aba = 'bag'
                    elseif isCursorOnElement(809, 248, 47, 47) then 
                        select_aba = 'ilegal'
                    elseif isCursorOnElement(875, 248, 43, 43) then 
                        select_aba = 'food'
                    end
                end
            elseif state == 'up' then
                if select_inventory then
                    for i, v in ipairs ( slots.chest ) do 
                        if isCursorOnElement(v[1], v[2], v[3], v[4]) then 
                            select_qnt = true
                            break 
                        end
                    end
                    item_cache = select_inventory
                    move_type = 'chest'
                    select_inventory = false
                end
                if select_chest then
                    for i, v in ipairs ( slots.inventory ) do 
                        if isCursorOnElement(v[1], v[2], v[3], v[4]) then 
                            select_qnt = true
                            break 
                        end
                    end
                    item_cache = select_chest
                    move_type = 'inventory'
                    select_chest = false
                end
            end
        end
    end
end)

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

bindKey('backspace', 'down', 
    function ( )
        if (select_qnt) then 
            select_qnt = false 
        else
            toggleChest(false)
        end
    end
)

addEvent('onClientUpateChestInventory', true)
addEventHandler('onClientUpateChestInventory', root, 
    function(inventory_player_, weights_player_, inventory_chest_, weights_chest_)
        inventory_player = inventory_player_
        inventory_weight = weights_player_
        inventory_chest = inventory_chest_
        chest_weight = weights_chest_
        select_qnt = false
    end
)

setElementData(localPlayer, 'chest.open', false)


addEventHandler('onClientKey', root, 
    function(key, press) 
        if (isEventHandleerAdded and press) then 
            if (key == 'mouse_wheel_down') then 
                if (isCursorOnElement(966, 209, 593, 662)) then 
                    if (page < 20) then 
                        page = page + 5
                    end
                end
            elseif (key == 'mouse_wheel_up') then 
                if (isCursorOnElement(966, 209, 593, 662)) then 
                    if (page > 0) then
                        page = page - 5
                    end
                end
            end
        end 
    end
)
