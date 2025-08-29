

local interface = {
    -- Var´s 
    animations = {
        alpha = { 0, 0, 0 };
        offSetY = { 0, 0, 0 };
        posX = {0, 0, 0};
    };

    panel = {
        window = "Utilidades";
        modal = false 
    };
    
    slots = {
        {443, 199, 193, 233};
        {648, 199, 193, 233};
        {854, 199, 193, 233};
        {1059, 199, 193, 233};
        {1265, 199, 193, 233};

        {443, 453, 193, 233};
        {648, 453, 193, 233};
        {854, 453, 193, 233};
        {1059, 453, 193, 233};
        {1265, 453, 193, 233};
    };

    categories = {

        {469, 744, 18, 18, "assets/images/martelo.png"};
        {642, 744, 19, 19, "assets/images/comida.png"};
        {816, 744, 20, 20, "assets/images/martelo.png"};

    };

}


-- Function´s 

local function draw ( )
    cursorUpdate()

    local fade = interpolateBetween ( interface.animations.alpha[1], 0, 0, interface.animations.alpha[2], 0, 0, ( getTickCount ( ) - interface.animations.alpha[3] ) / 400, 'Linear' )
    y = interpolateBetween ( interface.animations.offSetY[1], 0, 0, interface.animations.offSetY[2], 0, 0, ( getTickCount ( ) - interface.animations.offSetY[3] ) / 400, 'Linear' )
    local slider = interpolateBetween ( interface.animations.posX[1], 0, 0, interface.animations.posX[2], 0, 0, ( getTickCount ( ) - interface.animations.posX[3] ) / 200, 'Linear' )

    if (interface.panel.modal) then 
        local amount = slidebar.getSlidePercent("amount")
        slidebar.create("amount", {709, 630, 504, 6}, tocolor(60, 60, 60, fade), tocolor(193, 159, 114, fade), 100)
        local settings = exports['guetto_inventory']:getConfigItem(interface.panel.modal.item)


        dxDrawImage(401, y, 1118, 852, "assets/images/blur.png", 0, 0, 0, tocolor(255, 255, 255, fade))
        dxDrawImage(630, 317, 661, 471, "assets/images/modal.png", 0, 0, 0, tocolor(255, 255, 255, fade))
        dxDrawImage(711, 362, 54, 50, "assets/images/cart.png", 0, 0, 0, tocolor(255, 255, 255, fade))
        dxDrawText("Confirme sua compra", 783, 362, 182, 16, tocolor(193, 159, 114, fade), 1, exports['guetto_assets']:dxCreateFont("regular", 16), "left", "top", false, false)
        dxDrawText("Reveja sua compra antes de confirmar, não haverá\nextorno.", 783, 382, 338, 40, tocolor(100, 100, 100, fade), 1, exports['guetto_assets']:dxCreateFont("light", 14), "left", "top", false, false)
        
        if (settings) then 
            dxDrawText(settings['name'], 842, 476, 39, 16, tocolor(193, 159, 114, fade), 1, exports["guetto_assets"]:dxCreateFont("regular", 15), "left", "top", false, false)
        end

        dxDrawText("Abaixo veja os produtos\nda loja.", 842, 494, 166, 42, tocolor(166, 166, 166, fade), 1, exports["guetto_assets"]:dxCreateFont("light", 15), "left", "top", false, false)
        dxDrawText("$"..formatNumber(interface.panel.modal.value*amount, "."), 1141, 498, 63, 16, tocolor(114, 164, 90, fade), 1, exports["guetto_assets"]:dxCreateFont("regular", 16), "left", "top", false, false)
        dxDrawText("Quantidade", 709, 594, 96, 16, tocolor(208, 208, 208, fade), 1, exports["guetto_assets"]:dxCreateFont("medium", 16), "left", "top", false, false)
--
        dxDrawImage(709, 452, 107, 107, ":guetto_inventory/assets/itens/".. ( interface.panel.modal.item ) ..".png", 0, 0, 0, tocolor(255, 255, 255, fade))
        dxDrawImage(709, 674, 504, 70, "assets/images/rectangle-button.png", 0, 0, 0, isCursorOnElement(709, 674, 504, 70) and tocolor(217, 217, 217, 0.10 * fade) or tocolor(217, 217, 217, 0.04 * fade))
        dxDrawText(amount, 1189, 594, 6, 16, tocolor(208, 208, 208, fade), 1, exports["guetto_assets"]:dxCreateFont("medium", 16), "left", "center", false, false)
        dxDrawText("CONFIRMAR", 709, 677, 504, 70, tocolor(255, 255, 255, fade), 1, exports["guetto_assets"]:dxCreateFont("regular", 17), "center", "center", false, false)
    else

        dxDrawImage (401, y, 1118, 852, "assets/images/fundo.png", 0, 0, 0, tocolor(255, 255, 255, fade))
        dxDrawText("Produtos", 508, y + 126, 156, 16, tocolor(193, 159, 114, fade), 1, exports["guetto_assets"]:dxCreateFont("regular", 16), "left", "top")
        dxDrawText("Temos diversos produtos, navegue pela abas abaixo.", 508, y + 146, 205, 20, tocolor(100, 100, 100, fade), 1, exports["guetto_assets"]:dxCreateFont("light", 14), "left", "top")
    
        dxDrawImage(443, y + 120, 54, 50, "assets/images/cart.png", 0, 0, 0, tocolor(255, 255, 255, fade))
        dxDrawText(interface.panel.window, 868, y + 58, 184, 42, tocolor(193, 159, 114, fade), 1, exports["guetto_assets"]:dxCreateFont("light", 41), "center", "top")
        
        scroll.draw("items", 1469, y + 199, 4, 488, tocolor(217, 217, 217, 0.04 * fade), tocolor(193, 159, 114, fade), 10, #config["shop"][interface.panel.window])
        scroll.buttons["scroll:items"] = {401, y, 1128, 852}
    
        for i, v in ipairs (interface.slots) do
            local data = config["shop"][interface.panel.window][i + scroll.getValue("items")]
            if data then 
                local x, _y, w, h = v[1], v[2], v[3], v[4] 
                local width, height = 107, 107
                local image = ":guetto_inventory/assets/itens/".. ( data.item ) ..".png"
                local settings = exports['guetto_inventory']:getConfigItem(data.item)
    
                dxDrawImage (x, y + _y, w, h, "assets/images/slot.png", 0, 0, 0, isCursorOnElement(x, y + _y, w, h) and tocolor(53, 53, 53, fade) or tocolor(40, 40, 40, fade))
                dxDrawImage (x, y + _y, w, h, "assets/images/detail.png", 0, 0, 0, tocolor(255, 255, 255, fade))
            
                dxDrawImage(x + 140, y + _y + 180, 39, 39, "assets/images/circle.png", 0, 0, 0, isCursorOnElement(x + 140, y + _y + 180, 39, 39) and tocolor(193, 159, 114, fade) or tocolor(65, 65, 65, fade))
                dxDrawImage(x + 140 + 39 / 2 - 18 / 2, y + _y + 180 + 39 / 2 - 18 / 2, 18, 18, "assets/images/+.png", 0, 0, 0, tocolor(255, 255, 255, fade))
    
                dxDrawImage(x + w / 2 - width / 2, y + _y + 5, width, height, image, 0, 0, 0, tocolor(255, 255, 255, fade))
                dxDrawText(string.upper(settings.name), x + 14, y + _y + 110, 39, 16, tocolor(193, 159, 114, fade), 1, exports["guetto_assets"]:dxCreateFont("regular", 16), "left", "top")
                dxDrawText(data.description, x + 14, y + _y + 129, 166, 42, tocolor(166, 166, 166, fade), 1, exports["guetto_assets"]:dxCreateFont("light", 13), "left", "top")
                if data.type == "money" then 
                    dxDrawText("$ "..formatNumber(data.value, "."), x + 16, y + _y + 191, 63, 16, tocolor(114, 164, 90, fade), 1, exports["guetto_assets"]:dxCreateFont("regular", 16), "left", "top")
                else
                    dxDrawText("GP "..formatNumber(data.value, "."), x + 16, y + _y + 191, 63, 16, tocolor(193, 159, 114, fade), 1, exports["guetto_assets"]:dxCreateFont("regular", 16), "left", "top")
                end
            end
            
        end
    
        for i, v in ipairs ( interface.panel.table_categories ) do 
            if interface.categories[i] then 
                local x, _y, w, h, icon = interface.categories[i][1], interface.categories[i][2], interface.categories[i][3], interface.categories[i][4], interface.categories[i][5]
             
                if interface.panel.window == v then 
                    dxDrawRectangle(slider, y + 773, 116, 1, tocolor(193, 159, 114, fade))
                end
                
                dxDrawImage(x, y + _y, w, h, icon, 0, 0, 0, interface.panel.window == v and tocolor(193, 159, 114, fade) or isCursorOnElement(x, y + _y, 116, 18) and tocolor(193, 159, 114, fade) or tocolor(255, 255, 255, fade))
                dxDrawText(v, x + w + 16, y + _y, 83, 16, interface.panel.window == v and tocolor(193, 159, 114, fade) or isCursorOnElement(x, y + _y, 116, 18) and tocolor(193, 159, 114, fade) or tocolor(159, 159, 159, fade), 1, exports["guetto_assets"]:dxCreateFont("regular", 16), "left", "top")
            end
        end
    
        dxDrawImage(1035, y + 729, 54, 50, "assets/images/money.png", 0, 0, 0, tocolor(255, 255, 255, fade))
        dxDrawImage(1251, y + 729, 54, 50, "assets/images/coin.png", 0, 0, 0, tocolor(255, 255, 255, fade))
    
        dxDrawText("Dinheiro", 1100, y + 735, 68, 16, tocolor(114, 164, 90, fade), 1, exports["guetto_assets"]:dxCreateFont("regular", 17), "left", "top")
        dxDrawText("Guetto Points", 1316, y + 735, 68, 16, tocolor(193, 159, 114, fade), 1, exports["guetto_assets"]:dxCreateFont("regular", 17), "left", "top")
        
        local money = getPlayerMoney (localPlayer)
        local gp = (getElementData(localPlayer, "guetto.points") or 0)
    
        dxDrawText("$ "..formatNumber(money, "."), 1100, y + 755, 92, 16, tocolor(192, 192, 192, fade), 1, exports["guetto_assets"]:dxCreateFont("light", 14), "left", "top")
        dxDrawText("$ "..formatNumber(gp, "."), 1316, y + 755, 92, 16, tocolor(192, 192, 192, fade), 1, exports["guetto_assets"]:dxCreateFont("light", 14), "left", "top")

    end


end

local function onClientClick ( button, state )
    if button == "left" and state == "down" then 
        for i, v in ipairs ( interface.panel.table_categories ) do 
            if interface.categories[i] then 
                local x, _y, w, h, icon = interface.categories[i][1], interface.categories[i][2], interface.categories[i][3], interface.categories[i][4], interface.categories[i][5]
                if isCursorOnElement(x, y + _y, 116, 18) then 
                    interface.animations.posX[1] =  interface.animations.posX[2];
                    interface.animations.posX[2] = x;
                    interface.animations.posX[3] = getTickCount();
                    interface.panel.window = v
                    scroll.setValue("items", 0)
                end
            end
        end
        if not (interface.panel.modal) then 
            for i, v in ipairs (interface.slots) do
                local data = config["shop"][interface.panel.window][i + scroll.getValue("items")]
                if data then 
                    local x, _y, w, h = v[1], v[2], v[3], v[4] 
                    if isCursorOnElement(x + 140, y + _y + 180, 39, 39) then
                        slidebar.events.start()
                        interface.panel.modal = data 
                        break 
                   end
                end
            end
        else
            if isCursorOnElement(709, 674, 504, 70) then 
                local amount = slidebar.getSlidePercent("amount")
                if (amount > 0) then
                    triggerServerEvent("onPlayerBuyItem", resourceRoot, interface.panel.modal, amount)
                    interfaceManagment({state = false})
                else
                    config.sendMessageClient("Por favor, insira um valor maior que 0!", "error")
                end
            elseif isCursorOnElement(1228, 307, 73, 73) then 
                interface.panel.modal = false 
                slidebar.destroyAllSlid()
            end
        end
    end
end

function interfaceManagment ( ... )
    local arguments = ... 
    if interface.animations.alpha[3] and getTickCount( ) - interface.animations.alpha[3] <= 400 then 
        return false 
    end
    if arguments["state"] == true then 
        if not isEventHandlerAdded("onClientRender", root, draw) then 
            interface.animations.alpha[1], interface.animations.alpha[2], interface.animations.alpha[3] = 0, 255, getTickCount ()
            interface.animations.offSetY[1], interface.animations.offSetY[2], interface.animations.offSetY[3] = 200, 126, getTickCount ()
            interface.animations.posX[1], interface.animations.posX[2], interface.animations.posX[3] = 469, 469, getTickCount ()
            interface.panel.modal = false
            showChat(false)
            showCursor(true)
            addEventHandler("onClientRender", root, draw)
            addEventHandler("onClientClick", root, onClientClick)
            slidebar.events.start()
            scroll.setValue("items", 0)
        end
    elseif arguments["state"] == false then 
        if isEventHandlerAdded("onClientRender", root, draw) then 
            interface.animations.alpha[1], interface.animations.alpha[2], interface.animations.alpha[3] = 255, 0, getTickCount ()
            interface.animations.offSetY[1], interface.animations.offSetY[2], interface.animations.offSetY[3] = 126, 200, getTickCount ()
            showChat(true)
            showCursor(false)
            removeEventHandler("onClientClick", root, onClientClick)
            setTimer(function()
                removeEventHandler("onClientRender", root, draw)
                slidebar.destroyAllSlid()
            end, 400, 1)
        end
    end
end


addEvent("onPlayerToggleInterface", true)
addEventHandler("onPlayerToggleInterface", resourceRoot, function ( ... )
    local arguments = ... 
    interface.panel.table_categories = arguments[2]
    interface.panel.window = arguments[2][1]
    interfaceManagment({state = arguments[1]})
end)

bindKey("backspace", "down", function ( )
    if isEventHandlerAdded("onClientRender", root, draw) then 
        interfaceManagment({state = false})
    end
end)

scroll.start()