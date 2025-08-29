local Global = {
    ['Panel'] = {
        ['isEventHandlerAdded'] = false 
    }
}

local alpha = {}
local vehicles = {}
local slots = {
    {558, 419, 490, 68};
    {558, 492, 490, 68};
    {558, 565, 490, 68};
    {558, 638, 490, 68};
}

local function draw ( )
    local fade = interpolateBetween(alpha[1], 0, 0, alpha[2], 0, 0, ( getTickCount ( ) - alpha[3] ) / 400, 'Linear')

    dxDrawImage(530, 322, 545, 435, 'assets/images/fundo-garagem.png', 0, 0, 0, tocolor(255, 255, 255, fade))
    dxDrawImage(708, 322, 194, 88, 'assets/images/icon-garagem.png', 0, 0 ,0 , tocolor(255, 255, 255, fade))

    dxDrawImage(1091, 322, 299, 184, 'assets/images/specs-fundo.png', 0, 0, 0, tocolor(18, 18, 18, 0.94 * fade))
    dxDrawImage(1091, 518, 299, 244, 'assets/images/specs-fundo.png', 0, 0, 0, tocolor(18, 18, 18, 0.94 * fade))

    dxDrawImage(1108, 549, 22, 22, 'assets/images/icon-alarme.png', 0, 0, 0, isCursorOnElement(1141, 548, 131, 31) and tocolor(193, 159, 114, fade) or tocolor(147, 147, 147, fade))
    dxDrawText('Especificações', 1107, 336, 99, 23, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'left', 'top')
 
    dxDrawText('PAGAR MULTA', 1141, 546, 131, 31, isCursorOnElement(1141, 548, 131, 31) and tocolor(193, 159, 114, fade) or tocolor(208, 208, 208, fade), 1, exports['guetto_assets']:dxCreateFont('medium', 20), 'left', 'top')
    dxDrawText('LOCALIZAR', 1141, 620, 131, 31, isCursorOnElement(1141, 622, 131, 31) and tocolor(193, 159, 114, fade) or tocolor(208, 208, 208, fade), 1, exports['guetto_assets']:dxCreateFont('medium', 20), 'left', 'top')
    dxDrawText('VENDER', 1141, 698, 131, 31, isCursorOnElement(1141, 701, 131, 31) and tocolor(193, 159, 114, fade) or tocolor(208, 208, 208, fade), 1, exports['guetto_assets']:dxCreateFont('medium', 20), 'left', 'top')

    dxDrawImage(1110, 626, 22, 22, 'assets/images/icon-localizar.png', 0, 0, 0, isCursorOnElement(1141, 622, 131, 31) and tocolor(193, 159, 114, fade) or tocolor(147, 147, 147, fade))
    dxDrawImage(1110, 703, 22, 22, 'assets/images/icon-market.png', 0, 0, 0, isCursorOnElement(1141, 701, 131, 31) and tocolor(193, 159, 114, fade) or tocolor(147, 147, 147, fade))

    dxDrawImage(1108, 380, 15, 16, 'assets/images/engine-icon.png', 0, 0, 0, tocolor(255, 255, 255, fade))
    dxDrawImage(1108, 436, 16, 16, 'assets/images/icon-gas.png', 0, 0, 0, tocolor(255, 255, 255, fade))

    dxDrawText('Danos ao motor', 1134, 377, 124, 19, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'left', 'top')
    dxDrawText('Gasolina', 1134, 434, 58, 13, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'left', 'top')

    dxDrawRectangle(1110, 404, 265, 5, tocolor(217, 217, 217, 0.15 * fade))
    dxDrawRectangle(1110, 460, 265, 5, tocolor(217, 217, 217, 0.15 * fade))

    for i, v in ipairs ( slots ) do 
        local dados = vehicles[i + pag]
        if (dados) then 
            local infos = fromJSON(dados.infos)
            dxDrawImage(v[1], v[2], v[3], v[4], 'assets/images/rectangle-vehicle.png', 0, 0, 0, select_vehicle == i + pag and tocolor(130, 112, 89, 0.94 * fade) or not window_vehicle and isCursorOnElement(v[1], v[2], v[3], v[4]) and tocolor(130, 112, 89, 0.94 * fade) or tocolor(31, 31, 31, 0.94 * fade))
            dxDrawText(infos[3].. ' | '.. infos[1], v[1] + 22, v[2] + 21, 236, 26, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'left', 'center')
        end
    end

    if select_vehicle then 
        local dados = vehicles[select_vehicle]
        local infos = fromJSON(dados.dados)
        if infos then 
            local gasolina = interpolate(0, tonumber(infos[1].gasolina), 0.05, 'station')
            local vida = interpolate(0, tonumber(infos[1].vida), 0.05, 'vida')
            local data = fromJSON(dados.infos)
            local percent = tonumber(data[2]) * 0.5
        
            gasolina = math.min(gasolina, tonumber(100))
            vida = math.min(vida, tonumber(100))
        
            local gasolina_bar_width = 100 * (gasolina / tonumber(infos[1].gasolina))
            local vida_bar_width = 100 * (vida / tonumber(infos[1].vida))
        
            dxDrawRectangle(1108, 404, vida_bar_width, 5, tocolor(130, 112, 89, 0.94 * fade))
            dxDrawRectangle(1108, 460, gasolina_bar_width, 5, tocolor(130, 112, 89, 0.94 * fade))

            dxDrawText(math.floor(vida)..'%', 1330, 376, 124, 19, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'left', 'top')
            dxDrawText(math.floor(gasolina)..'%', 1330, 432, 58, 13, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'left', 'top')
        end
    end

    if window_vehicle == 'home' then 
        local alpha = fade

        dxDrawImage(530, 322, 545, 435, 'assets/images/blur.png', 0, 0, 0, tocolor(255, 255, 255, alpha))
        dxDrawImage(668, 412, 273, 255, 'assets/images/bg-infos.png', 0, 0, 0, tocolor(24, 24, 24, alpha))

        dxDrawText("VENDER VEÍCULO", 706, 429, 197, 26, tocolor(255, 255, 255, alpha), 1, exports['guetto_assets']:dxCreateFont("bold", 15), "center", "center")

        dxDrawImage(694, 480, 221, 42, 'assets/images/input-text.png', 0, 0, 0, select_type_window == 'player' and tocolor(193, 159, 114, 0.80 * alpha) or isCursorOnElement(694, 480, 221, 42) and tocolor(193, 159, 114, 0.80 * alpha) or tocolor(32, 32, 32, alpha))
        dxDrawImage(694, 529, 221, 42, 'assets/images/input-text.png', 0, 0, 0, select_type_window == 'conce' and tocolor(193, 159, 114, 0.80 * alpha) or isCursorOnElement(694, 529, 221, 42) and tocolor(193, 159, 114, 0.80 * alpha) or tocolor(32, 32, 32, alpha))
        dxDrawImage(694, 604, 221, 42, 'assets/images/input-text.png', 0, 0, 0, isCursorOnElement(694, 604, 221, 42) and tocolor(193, 159, 114, 0.80 * alpha) or tocolor(32, 32, 32, alpha))
        
        dxDrawText("JOGADOR", 694, 480+2, 221, 42, tocolor(255, 255, 255, alpha), 1, exports['guetto_assets']:dxCreateFont("regular", 15), "center", "center")
        dxDrawText("CONFIRMAR", 694, 608, 221, 42, isCursorOnElement(694, 608, 221, 42) and tocolor(255, 255, 255, alpha) or tocolor(155, 155, 155, alpha), 1, exports['guetto_assets']:dxCreateFont("light", 16), "center", "center")
        dxDrawText("CONCESSIONÁRIA", 694, 529+2, 221, 42, tocolor(255, 255, 255, alpha), 1, exports['guetto_assets']:dxCreateFont("regular", 15), "center", "center")
    end

    if select_window == 'player' then 
        local alpha = fade
        dxDrawImage(530, 322, 545, 435, 'assets/images/blur.png', 0, 0, 0, tocolor(255, 255, 255, alpha))
        dxDrawImage(668, 412, 273, 255, 'assets/images/bg-infos.png', 0, 0, 0, tocolor(24, 24, 24, alpha))

        dxDrawEditbox(694, 466, 221, 42, 20, "ID")
        dxDrawEditbox(694, 515, 221, 42, 20, "VALOR")

        dxDrawText("VENDER VEÍCULO", 706, 429, 197, 26, tocolor(255, 255, 255, alpha), 1, exports['guetto_assets']:dxCreateFont("bold", 15), "center", "center")
        
        dxDrawImage(694, 565, 106, 28, 'assets/images/rectangle-select.png', 0, 0, 0, select_type_oferter == 'money' and tocolor(193, 159, 114, 0.80 * alpha) or isCursorOnElement(694, 565, 106, 28) and tocolor(193, 159, 114, 0.80 * alpha) or tocolor(32, 32, 32, alpha))
        dxDrawImage(808, 565, 106, 28, 'assets/images/rectangle-select.png', 0, 0, 0, select_type_oferter == 'coins' and tocolor(193, 159, 114, 0.80 * alpha) or isCursorOnElement(808, 565, 106, 28) and tocolor(193, 159, 114, 0.80 * alpha) or tocolor(32, 32, 32, alpha))

        dxDrawText("DINHEIRO", 694, 567, 106, 28, tocolor(255, 255, 255, alpha), 1, exports['guetto_assets']:dxCreateFont("regular", 15), "center", "center")
        dxDrawText("Gemas", 808, 567, 106, 28, tocolor(255, 255, 255, alpha), 1, exports['guetto_assets']:dxCreateFont("regular", 15), "center", "center")

        dxDrawImage(694, 466, 221, 42, 'assets/images/input-text.png', 0, 0, 0, tocolor(32, 32, 32, alpha))
        dxDrawImage(694, 515, 221, 42, 'assets/images/input-text.png', 0, 0, 0, tocolor(32, 32, 32, alpha))
        dxDrawImage(694, 604, 221, 42, 'assets/images/input-text.png', 0, 0, 0, isCursorOnElement(694, 604, 221, 42) and tocolor(193, 159, 114, 0.80 * alpha) or tocolor(32, 32, 32, alpha))

        if isBoxActive("ID") then 
            dxDrawText(getEditboxText("ID").."|", 694, 468, 221, 42, tocolor(255, 255, 255, alpha), 1, exports['guetto_assets']:dxCreateFont('regular', 15), "center", "center")
        else
            dxDrawText((#getEditboxText("ID") ~= 0) and getEditboxText("ID") or "ID", 694, 468, 221, 42, tocolor(94, 94, 94, alpha), 1, exports['guetto_assets']:dxCreateFont('regular', 15), "center", "center")
        end

        if isBoxActive("VALOR") then 
            dxDrawText(getEditboxText("VALOR").."|", 694, 517, 221, 42, tocolor(255, 255, 255, alpha), 1, exports['guetto_assets']:dxCreateFont('regular', 15), "center", "center")
        else
            dxDrawText((#getEditboxText("VALOR") ~= 0) and getEditboxText("VALOR") or "VALOR", 694, 517, 221, 42, tocolor(94, 94, 94, alpha), 1, exports['guetto_assets']:dxCreateFont('regular', 15), "center", "center")
        end

        dxDrawText("VENDER", 694, 605, 221, 42, isCursorOnElement(694, 605, 221, 42) and tocolor(255, 255, 255, alpha) or tocolor(155, 155, 155, alpha), 1, exports['guetto_assets']:dxCreateFont('medium', 15), 'center', 'center') 
        dxDrawText("[BACKSPACE] PARA RETORNAR", 668, 677, 273, 26, tocolor(255, 255, 255, alpha), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'center', 'center') 
    elseif select_window == 'conce' then 
        local alpha = fade
        local dados = vehicles[select_vehicle]
        if dados then 
            local infos = fromJSON(dados.dados)
            if infos then 
                local data = fromJSON(dados.infos);
    
                dxDrawImage(530, 322, 545, 435, 'assets/images/blur.png', 0, 0, 0, tocolor(255, 255, 255, alpha))
                dxDrawImage(668, 412, 273, 255, 'assets/images/bg-infos.png', 0, 0, 0, tocolor(24, 24, 24, alpha))
                
                dxDrawText("VENDER VEÍCULO", 706, 429, 197, 26, tocolor(255, 255, 255, alpha), 1, exports['guetto_assets']:dxCreateFont("bold", 15), "center", "center")
                dxDrawText("Você escolheu vender para a concessionaria, o valor está abaixo:", 686, 485, 236, 26, tocolor(155, 155, 155, alpha), 1, exports['guetto_assets']:dxCreateFont("light", 15), "center", "center", false,  true)
                dxDrawText("$ "..formatNumber(tonumber(data[2] * 0.5), '.'), 755, 538, 100, 31, tocolor(30, 161, 111, alpha), 1, exports['guetto_assets']:dxCreateFont("bold", 20), "center", "center")
                
                dxDrawImage(694, 604, 221, 42, 'assets/images/input-text.png', 0, 0, 0, isCursorOnElement(694, 604, 221, 42) and tocolor(193, 159, 114, 0.80 * alpha) or tocolor(32, 32, 32, alpha))
                dxDrawText("VENDER", 694, 606, 221, 42, isCursorOnElement(694, 604, 221, 42) and tocolor(255, 255, 255, alpha) or tocolor(155, 155, 155, alpha), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'center', 'center')
            end
        end
    end
   
    dxDrawRectangle(1110, 598, 261, 1, tocolor(58, 58, 58, fade))
    dxDrawRectangle(1110, 675, 261, 1, tocolor(58, 58, 58, fade))
end

local function toggle ( state )
    if spam and getTickCount() - spam <= 400 then return end
    if state and not Global['Panel']['isEventHandlerAdded'] then 
        Global['Panel']['isEventHandlerAdded'] = true 
        alpha = {0, 255, getTickCount()}
        select_vehicle = false
        pag = 0
        select_type_window = false
        select_type_oferter = false
        window_vehicle = false
        select_window = false
        showCursor(true)
        triggerServerEvent("select_player_vehicles", resourceRoot)
        addEventHandler('onClientRender', root, draw)
    elseif not state and Global['Panel']['isEventHandlerAdded'] then
        Global['Panel']['isEventHandlerAdded'] = false
        alpha = {255, 0, getTickCount()}
        showCursor(false)
        setTimer(function()
            removeEventHandler('onClientRender', root, draw)
        end, 400, 1)
    end
    spam = getTickCount()
end

addEventHandler('onClientClick', root,
    function ( button, state )
        if button == 'left' and state == 'down' then 
            if Global['Panel']['isEventHandlerAdded'] then 
                if not window_vehicle then 
                    for i, v in ipairs ( slots ) do 
                        local dados = vehicles[i + pag]
                        if (dados) then 
                            if isCursorOnElement(unpack(v)) then
                                if not select_type_window and not window_vehicle then 
                                    if select_vehicle ~= i + pag then 
                                        select_vehicle = i + pag
                                        interpolateDestroy()
                                        break
                                    end 
                                end
                            end
                        end
                    end
                    if isCursorOnElement(1141, 548, 131, 31) and not window_vehicle then 
                        local res_element = getResourceDynamicElementRoot(getResourceFromName('guetto_dealership'))
                        triggerServerEvent("onPlayerPaymentMult", res_element, vehicles[select_vehicle])
                    elseif isCursorOnElement(1141, 622, 131, 31) and not window_vehicle then  
                        local res_element = getResourceDynamicElementRoot(getResourceFromName('guetto_dealership'))
                        triggerServerEvent("onPlayerLocalizeVehicle", res_element, vehicles[select_vehicle])
                    elseif isCursorOnElement(1141, 701, 131, 31) and not window_vehicle then 
                        if not select_vehicle then return config.sendMessageClient('Selecione um veículo!', 'error') end
                        window_vehicle = 'home'
                    end
                end
                if (window_vehicle == "home") then 
                    if isCursorOnElement(694, 480, 221, 42) then 
                        select_type_window = "player"
                    elseif isCursorOnElement(694, 529, 221, 42) then 
                        select_type_window = "conce"
                    elseif isCursorOnElement(694, 604, 221, 42) then 
                        if select_type_window == false then return config.sendMessageClient('Selecione um tipo!', 'error') end 
                        window_vehicle = false
                        select_window = select_type_window
                        return 
                    end
                end
                if (select_window == "player") then 
                    if isCursorOnElement(694, 604, 221, 42) then 
                        local id = getEditboxText("ID")
                        local value = getEditboxText("VALOR")
                        if (id == "" or #id == 0 or id == "ID") then 
                            return config.sendMessageClient('Digite o id do comprador!', 'error')
                        end
                        if (value == "" or #value == 0 or value == "VALOR") then 
                            return config.sendMessageClient('Digite o valor do veículo!', 'error') 
                        end
                        local res_element = getResourceDynamicElementRoot(getResourceFromName('guetto_dealership'))
                        if not (select_type_oferter) then return config.sendMessageServer("Selecione o tipo de venda!", "error") end
                        triggerServerEvent("onPlayerSellVehiclePlayer", res_element, vehicles[select_vehicle], id, value, select_type_oferter)
                        toggle(false)
                    elseif isCursorOnElement(694, 565, 106, 28) then 
                        select_type_oferter = "money"
                    elseif isCursorOnElement(808, 565, 106, 28) then 
                        select_type_oferter = "coins"
                    end
                elseif (select_window == "conce") then 
                    if isCursorOnElement(694, 604, 221, 42) then 
                        local res_element = getResourceDynamicElementRoot(getResourceFromName('guetto_dealership'))
                        triggerServerEvent("onPlayerSellVehicleConce", res_element, vehicles[select_vehicle])
                        toggle(false)
                    end
                end
            end
        end
    end
)


addEvent('send_vehicles_client', true)
addEventHandler('send_vehicles_client', resourceRoot,
    function ( _vehicles )
        vehicles = _vehicles
    end
)

bindKey(config["Manage-Vehicle"]["key"], "down",
    function ( )
        toggle(not Global['Panel']['isEventHandlerAdded'] and true or false)    
    end
)

bindKey('backspace', 'down',    
    function ( )
        if Global['Panel']['isEventHandlerAdded'] then
            if select_window == 'player' then
                select_window = false 
            elseif window_vehicle == 'home' then 
                window_vehicle = false 
            elseif select_window == "conce" then 
                select_window = false 
            end
        end
    end
)

local oferter_handler = false

function drawOferter ( )
    dxDrawImage(823, 404, 273, 255, "assets/images/bg-infos.png", 0, 0, 0, tocolor(24, 24, 24, 255))
    dxDrawText("VENDER VEÍCULO", 861, 421, 197, 26, tocolor(255, 255, 255, 255), 1, exports['guetto_assets']:dxCreateFont("medium", 15), "center", "center")
    dxDrawText("Você escolheu vender para a concessionaria, o valor está abaixo:", 841, 449, 236, 38, tocolor(1, 155, 155, 255), 1, exports['guetto_assets']:dxCreateFont("light", 13), "center", "center", false, true)

    if vehicle_infos then 
        if vehicle_infos.type == "money" then 
            dxDrawText("$ "..formatNumber(tonumber(vehicle_infos.price), "."), 910, 530, 100, 31, tocolor(30, 161, 11, fade), 1, exports['guetto_assets']:dxCreateFont("medium", 16), "center", "center")
        elseif vehicle_infos.type == "coins" then 
            dxDrawText("GP "..formatNumber(tonumber(vehicle_infos.price), "."), 910, 530, 100, 31, tocolor(193, 159, 114, fade), 1, exports['guetto_assets']:dxCreateFont("medium", 16), "center", "center")
        end
    end

    dxDrawImage(849, 596, 223, 42, 'assets/images/input-text.png', 0, 0, 0, tocolor(32, 32, 32, fade))
    dxDrawText("COMPRAR", 849, 598, 223, 42, isCursorOnElement(849, 596, 223, 42) and tocolor(255, 255, 255, fade) or tocolor(155, 155, 155, fade), 1, exports['guetto_assets']:dxCreateFont("medium", 15), "center", "center")
    dxDrawText("[BACKSPACE] PARA RETORNAR", 823, 669, 273, 26, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'center', 'center')
end

addEventHandler("onClientClick", root,
    function ( button, state )
        if button == "left" and state == "down" then 
            if oferter_handler then 
                if isCursorOnElement(849, 596, 223, 42) then 
                    if vehicle_infos then 
                        local res_element = getResourceDynamicElementRoot(getResourceFromName('guetto_dealership'))
                        triggerServerEvent("onPlayerBuyVehicleByOferter", res_element, vehicle_infos)
                        toggleOferter(false)
                    else
                        config.sendMessageClient("Houve uma falha ao tentar comprar o veículo! Por favor tente novamente.", "error")
                    end
                end
            end
        end
    end
)

function toggleOferter ( state )
    if not oferter_handler and state then 
        oferter_handler = true 
        showCursor(true)
        showChat(false)
        addEventHandler("onClientRender", root, drawOferter)
    elseif oferter_handler and not state then 
        oferter_handler = false
        showCursor(false)
        showChat(true)
        removeEventHandler("onClientRender", root, drawOferter)
    end
end

bindKey("backspace", "down",
    function ( )
        if oferter_handler then 
            toggleOferter(false)
            triggerServerEvent("onPlayerCancelOferter", resourceRoot, vehicle_infos)
            config.sendMessageClient("Você recusou a oferta!", "info")
        end
    end
)

addEvent("onPlayerVisibleOferter", true)
addEventHandler("onPlayerVisibleOferter", resourceRoot,
    function (state, data)
        if state then 
            toggleOferter(true)
            vehicle_infos = data
        else
            toggleOferter(false)
            vehicle_infos = nil
        end
    end
)

addEventHandler('onClientKey', root, 
    function(key, press) 
        if Global['Panel']['isEventHandlerAdded'] then 
            if (press) then 
                if (key == 'mouse_wheel_down') then
                    if isCursorOnElement(530, 322, 545, 435) then 
                        if (pag + 4 < #vehicles) then 
                            pag = pag + 1
                        end
                    end 
                elseif (key == 'mouse_wheel_up') then 
                    if isCursorOnElement(530, 322, 545, 435) then 
                        if (pag - 1 >= 0) then 
                            pag = pag - 1
                        end
                    end
                end
            end
        end
    end
)
