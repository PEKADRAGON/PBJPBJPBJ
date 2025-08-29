-- Var´s 

local slots = {

    {697, 303, 101, 117};
    {801, 303, 101, 117};
    {905, 303, 101, 117};
    {1009, 303, 101, 117};
    {1113, 303, 101, 117};

    {697, 423, 101, 117};
    {801, 423, 101, 117};
    {905, 423, 101, 117};
    {1009, 423, 101, 117};
    {1113, 423, 101, 117};

    {697, 543, 101, 117};
    {801, 543, 101, 117};
    {905, 543, 101, 117};
    {1009, 543, 101, 117};
    {1113, 543, 101, 117};

    {697, 663, 101, 117};
    {801, 663, 101, 117};
    {905, 663, 101, 117};
    {1009, 663, 101, 117};
    {1113, 663, 101, 117};
}

local interface = {}
local itens = {}
local itens_selected = {}

local element;

-- Func´s 

function getItemByIndex ( index )
    for i, v in ipairs(itens) do 
        if i == index then 
            return i, v.item, v.amount
        end;
    end;
    return false;
end;

function interfaceDraw ( )

    dxDrawImage(665, 203, 589, 673, "assets/images/fundo.png", 0, 0, 0, tocolor(255, 255, 255, 255))

    for i, v in ipairs(slots) do 
        local index, item, amount = getItemByIndex ( i )
        local _, pos = getItemSelect ( item )

        if index then 
            local item = ":guetto_inventory/assets/itens/"..(item)..".png"

            dxDrawImage(v[1] + v[3] / 2 - 48 / 2, v[2] + v[4] / 2 - 48 / 2, 48, 48, item, 0, 0, 0, tocolor(255, 255, 255, 255) )
            dxDrawText(amount, v[1] + 8, v[2] + 8, 43, 23, tocolor(255, 255, 255, 255), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'left', 'top')
        end;

        dxDrawImage(v[1], v[2], v[3], v[4], "assets/images/slot.png", 0, 0, 0, pos == i and tocolor(217, 217, 217, 0.20 * 255) or isCursorOnElement(v[1], v[2], v[3], v[4]) and tocolor(217, 217, 217, 0.10 * 255) or tocolor(217, 217, 217, 0.02 * 255))
    end

    dxDrawText(tipo == "gang" and "SAQUEANDO" or "REVISTANDO", 697, 234, 126, 30, tocolor(255, 255, 255, 255), 1, exports['guetto_assets']:dxCreateFont('medium', 20), 'left', 'top')
    dxDrawText("Retire itens de jogadores caídos", 697, 264, 239, 23, tocolor(116, 116, 116, 255), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'left', 'top')

    dxDrawImage(699, 790, 203, 43, "assets/images/button-use.png", 0, 0, 0, tocolor(255, 255, 255, 255))

    dxDrawImage(910, 790, 174, 43, "assets/images/button-saquear.png", 0, 0, 0, isCursorOnElement(910, 790, 174, 43) and tocolor(217, 217, 217, 0.10 * 255) or tocolor(217, 217, 217, 0.20 * 255))
    dxDrawImage(1091, 790, 143, 43, "assets/images/button-pegar.png", 0, 0, 0, isCursorOnElement(1091, 790, 143, 43) and tocolor(217, 217, 217, 0.10 * 255) or tocolor(217, 217, 217, 0.20 * 255))

    dxDrawEditbox(699, 790, 203, 43, 10, "Quantidade")

    if isBoxActive("Quantidade") then 
        dxDrawText(getEditboxText("Quantidade").."|", 699, 791, 203, 43, tocolor(255, 255, 255, 255), 1, exports['guetto_assets']:dxCreateFont("light", 18), "center", "center")
    else
        dxDrawText((#getEditboxText("Quantidade") ~= 0) and getEditboxText("Quantidade") or "Quantidade", 699, 791, 203, 43, tocolor(115, 115, 115, 255), 1, exports['guetto_assets']:dxCreateFont("light", 18), "center", "center")
    end

    dxDrawText("SAQUEAR", 910, 792, 174, 43, tocolor(255, 255, 255, 255), 1, exports['guetto_assets']:dxCreateFont('regular', 17), 'center', 'center')
    dxDrawText("PEGAR TUDO", 1091, 792, 143, 43, tocolor(255, 255, 255, 255), 1, exports['guetto_assets']:dxCreateFont('regular', 17), 'center', 'center')
end;

function interfaceOpen ( )
    if not isEventHandlerAdded('onClientRender', root, interfaceDraw) then 
        showCursor(true)
        addEventHandler('onClientRender', root, interfaceDraw)
    end
end;

function interfaceClose ( )
    if isEventHandlerAdded('onClientRender', root, interfaceDraw) then 
        showCursor(false)
        removeEventHandler('onClientRender', root, interfaceDraw)
        triggerServerEvent("onPlayerCloseRevist", resourceRoot)
    end
end;

function descompTable (tbl)
    for i, v in pairs (tbl.itens) do 
        if v then 
            for _, value in ipairs(tbl.itens[i]) do 
                local selected, index = getItemInTable (value.item)
                if not selected then 
                    table.insert(itens, value)
                end
            end;
        end
    end;
    return itens
end;


function getItemInTable ( item )
    for i, v in ipairs(itens) do 
        if v.item == item then 
            return i
        end
    end
    return false;
end;

function getItemSelect (item)
   if itens_selected then 
        if itens_selected[2] == item then 
             return true, itens_selected[1]
        end
    end
    return false, 0
end;

-- Event´s 

addEventHandler("onClientClick", root, function(button, state)
    if isEventHandlerAdded('onClientRender', root, interfaceDraw) then 
        if (button == "left" and state == "down") then 
            for i, v in ipairs(slots) do 
                if isCursorOnElement(unpack(v)) then 
                    local index, item, amount = getItemByIndex ( i )
                    if index then 
                        if itens_selected then 
                            itens_selected = false;
                        else
                            local quantidade = getEditboxText("Quantidade")

                            if #quantidade == 0 then 
                                quantidade = 1
                            elseif quantidade == 'Quantidade' then
                                quantidade = 1 
                            end

                            if tonumber(quantidade) > amount then 
                                return config.sendMessageClient("Você não tem essa quantidade de item!", "error")
                            end

                            itens_selected = {index, item, amount}
                        end;
                    end
                end
            end
            if isCursorOnElement(910, 792, 174, 43) then 
                local quantidade = getEditboxText("Quantidade")

                if #quantidade == 0 then 
                    quantidade = 1
                elseif quantidade == 'Quantidade' then 
                    quantidade = 1 
                end

                if not itens_selected or #itens_selected == 0 then 
                    return config.sendMessageClient("Selecione um item para saquear!", "error")
                end;

                if tonumber(quantidade) > itens_selected[3] then 
                    return config.sendMessageClient("Você não tem essa quantidade de item!", "error")
                end;

                if (spam and getTickCount() - spam <= 1000) then 
                    return config.sendMessageClient('Aguarde!', 'info')
                end;

                local serial = getPlayerSerial(localPlayer);
                local encrypted = toJSON({item = itens_selected, amount = quantidade})

                encodeString("aes128", encrypted, {key = serial:sub(17)}, function (env, inc)
                    triggerServerEvent("guetto.saquear.saquear", resourceRoot, localPlayer, element, env, inc)
                end)
                    
                spam = getTickCount()
            elseif isCursorOnElement(1091, 792, 143, 43) then 
                local serial = getPlayerSerial(localPlayer);
                local encrypted = toJSON({item = itens})

                if (spam and getTickCount() - spam <= 1000) then 
                    return config.sendMessageClient('Aguarde!', 'info')
                end;

                encodeString("aes128", encrypted, {key = serial:sub(17)}, function (env, inc)
                    triggerServerEvent("guetto.saquear.all", resourceRoot, localPlayer, element, env, inc)
                end)
                spam = getTickCount()
            end
        end
    end
end)

registerEventHandler("guetto.saquear.draw", root, function (inventario, target, _type)
    element = target;
    tipo = _type
    descompTable(inventario)
    if isEventHandlerAdded('onClientRender', root, interfaceDraw) then 
        interfaceClose ( )
    else
        interfaceOpen ( )
    end

    setElementData(target, "guetto.sendoSaqueado", localPlayer)
    setElementData(localPlayer, "guetto.saquando", target)
end)

registerEventHandler("guetto.refreshInventory", resourceRoot, function (inventario)
    itens = {}
    itens_selected = {}
    descompTable(inventario)
end)

bindKey('backspace', 'down', function ( )
    if isEventHandlerAdded('onClientRender', root, interfaceDraw) then 
        interfaceClose ( )
    end
end)
