local isEventHandlerAdded = false 
local alpha = { }
local player_vehicles = {}

local slots = {
    {494, 419, 622, 68};
    {494, 492, 622, 68};
    {494, 565, 622, 68};
    {494, 638, 622, 68};
}

local function draw ( )
    local fade = interpolateBetween(alpha[1], 0, 0, alpha[2], 0, 0, ( getTickCount ( ) - alpha[3] ) / 400, 'Linear' )
    local arrow_info = interpolateBetween(1359, 0, 0, 1355, 0, 0, (getTickCount () - alpha[3]) / 1000, 'SineCurve')

    dxDrawImage(468, 322, 674, 435, 'assets/images/fundo-garagem.png', 0, 0, 0, tocolor(255, 255, 255, fade))
    dxDrawImage(1153, 687, 299, 70, 'assets/images/rectangle-specs.png', 0, 0, 0, isCursorOnElement(1153, 687, 299, 70) and tocolor(130, 112, 89, 0.94 * fade) or tocolor(18, 18, 18, 0.94 * fade))
    
    dxDrawImage(1153, 322, 299, 184, 'assets/images/specs-fundo.png', 0, 0, 0, tocolor(18, 18, 18, 0.94 * fade))
    dxDrawImage(1153, 518, 299, 157, 'assets/images/specs-fundo.png', 0, 0, 0, tocolor(18, 18, 18, 0.94 * fade))
    dxDrawImage(708, 322, 194, 88, 'assets/images/icon-garagem.png', 0, 0 ,0 , tocolor(255, 255, 255, fade))

    for i, v in ipairs (slots) do 
        local dados = player_vehicles[i + pag]
        
        if (player_slots < i + pag) then 
            dxDrawImage(v[1], v[2], v[3], v[4], 'assets/images/rectangle-vehicle.png', 0, 0, 0, tocolor(31, 31, 31, 0.94 * fade))
            dxDrawImage(v[1] + 473, v[2] + 18, 32, 32, 'assets/images/icon-coins.png', 0, 0, 0, tocolor(255, 255, 255, fade))
            dxDrawText('COMPRAR', v[1] + 518, v[2] + 23, 86, 19, isCursorOnElement(v[1] + 518, v[2] + 23, 86, 19) and tocolor(193, 159, 114, fade) or tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'left', 'top')
            dxDrawText('GARAGEM  |  Bloqueada ➠ GP '..config["Shop"]["slot"] * ((i + pag) - player_slots), v[1] + 27, v[2] + 21, 567, 26, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('medium', 15), 'left', 'center')
        else
            if not dados then 
                dxDrawImage(v[1], v[2], v[3], v[4], 'assets/images/rectangle-vehicle.png', 0, 0, 0, tocolor(31, 31, 31, 0.94 * fade))
                dxDrawText('Sem info.', v[1] + 518, v[2] + 23, 86, 19, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('medium', 15), 'left', 'top')
                dxDrawText('GARAGEM  |  Desbloqueada', v[1] + 27, v[2] + 21, 567, 26, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('medium', 15), 'left', 'center')
            end
        end
        
        if dados then 
            dxDrawImage(v[1], v[2], v[3], v[4], 'assets/images/rectangle-vehicle.png', 0, 0, 0, select_vehicle == i + pag and tocolor(130, 112, 89, 0.94 * fade) or isCursorOnElement(v[1], v[2], v[3], v[4]) and tocolor(130, 112, 89, 0.94 * fade) or tocolor(31, 31, 31, 0.94 * fade))
            local infos = fromJSON(dados.infos)
            dxDrawText(infos[3]..' | '..infos[1], v[1] + 27, v[2] + 21, 567, 26, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('medium', 15), 'left', 'center')
            dxDrawText(string.upper(dados.state), v[1] + 508, v[2] + 21, 567, 26, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'left', 'center')
        end
    end

    dxDrawRectangle(1170, 404, 265, 5, tocolor(217, 217, 217, 0.15 * fade))
    dxDrawRectangle(1170, 460, 265, 5, tocolor(217, 217, 217, 0.15 * fade))
    dxDrawText('Placa', 1170, 604, 88, 19, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('medium', 15), 'left', 'top')

    if select_slot then 
        local alpha = fade
        dxDrawImage(468, 322, 674, 435, 'assets/images/blur.png', 0, 0, 0, tocolor(255, 255, 255, alpha))
        dxDrawImage(668, 412, 273, 255, 'assets/images/bg-infos.png', 0, 0, 0, tocolor(24, 24, 24, alpha))

        dxDrawText("LIBERAR ESPAÇO", 706, 429, 197, 26, tocolor(255, 255, 255, alpha), 1, exports['guetto_assets']:dxCreateFont("medium", 15), "center", "center")
        dxDrawText("Compre mais um espaço em sua garagem permanentemente.", 694, 457, 220, 45, tocolor(155, 155, 155, alpha), 1, exports['guetto_assets']:dxCreateFont("light", 13), "center", "center", false, true)
        dxDrawText("GP "..formatNumber(tonumber(config["Shop"]["slot"] * (select_slot - player_slots)), ".").."", 750, 532, 116, 31, tocolor(193, 159, 114, alpha), 1, exports['guetto_assets']:dxCreateFont("medium", 18), "center", "center", false, true)

        dxDrawImage(694, 596, 221, 42, 'assets/images/input-text.png', 0, 0, 0, tocolor(32, 32, 32, alpha))
        dxDrawText("CONFIRMAR", 694, 597, 221, 42, isCursorOnElement(694, 596, 221, 42) and tocolor(255, 255, 255, alpha) or tocolor(155, 155, 155, alpha), 1, exports['guetto_assets']:dxCreateFont("light", 15), "center", "center")
    
        dxDrawText("[BACKSPACE] PARA SAIR", 668, 677, 273, 42, tocolor(255, 255, 255, alpha), 1, exports['guetto_assets']:dxCreateFont("light", 15), "center", "center")
    end

    if select_vehicle then 
        if (player_vehicles[select_vehicle]) then 
            local dados = player_vehicles[select_vehicle]

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
    
                dxDrawRectangle(1170, 404, vida_bar_width, 5, tocolor(130, 112, 89, 0.94 * fade))
                dxDrawRectangle(1170, 460, gasolina_bar_width, 5, tocolor(130, 112, 89, 0.94 * fade))
    
                dxDrawText(math.floor(vida)..'%', 1387, 376, 124, 19, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'left', 'top')
                dxDrawText(math.floor(gasolina)..'%', 1387, 432, 58, 13, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'left', 'top')
    
                dxDrawText(timestampToDateString(dados.IPVA), 1170, 562, 299, 70, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('light', 13), 'left', 'top')
                dxDrawText(dados.plate, 1170, 630, 88, 19, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('medium', 15), 'left', 'top')
    
                dxDrawImage(arrow_info, 562, 10, 16, 'assets/images/icon-arrow.png', 0, 0, 0, tocolor(30, 161, 111, fade))
    
                if dados.state == 'guardado' then 
                    dxDrawText('RETIRAR', 1153, 689, 299, 70, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('light', 20), 'center', 'center')
                elseif dados.state == "spawnado" then 
                    dxDrawText('GUARDAR', 1153, 689, 299, 70, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('light', 20), 'center', 'center')
                elseif dados.state == "apreendido" then 
                    dxDrawText('RECUPERAR', 1153, 689, 299, 70, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('light', 20), 'center', 'center')
                end
    
                dxDrawText('$ '..formatNumber(percent, '.'), 1127, 537, 299, 70, tocolor(30, 161, 111, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'right', 'center')
            end
        end
    end

    dxDrawImage(1170, 380, 15, 16, 'assets/images/engine-icon.png', 0, 0, 0, tocolor(255, 255, 255, fade))
    dxDrawImage(1170, 436, 16, 16, 'assets/images/icon-gas.png', 0, 0, 0, tocolor(255, 255, 255, fade))

    dxDrawText('Danos ao motor', 1196, 375, 124, 19, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'left', 'top')
    dxDrawText('Gasolina', 1196, 432, 58, 13, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'left', 'top')

    dxDrawText('Especificações', 1169, 340, 99, 13, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'left', 'center')
    dxDrawText('Seguro/IPVA', 1170, 536, 99, 13, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('medium', 15), 'left', 'center')
end 

local function toggle ( state )
    if (state and not isEventHandlerAdded) then 

        isEventHandlerAdded = true 
        select_vehicle = 1
        pag = 0
        select_slot = false
        alpha = {0, 255, getTickCount()}
        showCursor(true)
        showChat(false)
        addEventHandler('onClientRender', root, draw)
    elseif not (state and isEventHandlerAdded) then 
        isEventHandlerAdded = false 
        alpha = {255, 0, getTickCount()}
        showChat(true)
        showCursor(false)
        setTimer(function()
            removeEventHandler('onClientRender', root, draw)
        end, 400, 1)
    end
end

addEventHandler('onClientClick', root,
    function ( button, state )
        if button == 'left' and state == 'down' then 
            if isEventHandlerAdded then 
                for i, v in ipairs (slots) do 
                    if isCursorOnElement(v[1], v[2], v[3], v[4]) then 
                        if (player_slots >= i + pag) then 
                            local dados = player_vehicles[i +pag]
                            if dados then 
                                if select_vehicle ~= i + pag then 
                                    local infos = fromJSON(dados.infos)
                                    select_vehicle = i + pag
                                    interpolateDestroy()
                                    break 
                                end
                            end
                        else
                            if isCursorOnElement(v[1] + 518, v[2] + 23, 86, 19) then 
                                if not (select_slot) then 
                                    select_slot = i + pag
                                end
                                break 
                            end
                        end
                    end
                end
                if isCursorOnElement(1153, 687, 299, 70) then 
                    if select_vehicle then 
                        if tick_spam and getTickCount ( ) - tick_spam <= 1000 then return config.sendMessageClient('Aguarde um momento!', 'error') end
                        local dados = player_vehicles[select_vehicle]
                        local res_element = getResourceDynamicElementRoot(getResourceFromName('guetto_dealership'))
                        triggerServerEvent('onPlayerGarageSpawnVehicle', res_element, dados, marker_i)
                        tick_spam = getTickCount()
                    end
                elseif isCursorOnElement(694, 596, 221, 42) then 
                    if select_slot then 
                        local res_element = getResourceDynamicElementRoot(getResourceFromName('guetto_dealership'))
                        triggerServerEvent("onPlayerBuySlot", res_element, select_slot, tonumber(config["Shop"]["slot"] * (select_slot - player_slots)))
                        toggle(false)
                    end
                end
            end
        end
    end
)

addEvent('onPlayerDrawGaragem', true)
addEventHandler('onPlayerDrawGaragem', resourceRoot,
    function (vehicles, slots, index)
        toggle(not isEventHandlerAdded and true or false)
        player_vehicles = vehicles;
        player_slots = slots
        marker_i = index
    end
)

addEvent('onPlayerCloseGaragem', true)
addEventHandler('onPlayerCloseGaragem', resourceRoot,
    function ( )
        if isEventHandlerAdded then 
            toggle(false)
        end
    end
)

local function closeKey ( )
    if isEventHandlerAdded then 
        if select_slot then 
            select_slot = false 
        else
            toggle(false)
        end
    end
end

bindKey('backspace', 'down',closeKey)

addEventHandler('onClientKey', root, 
    function(key, press) 
        if isEventHandlerAdded then 
            if (press) then 
                if (key == 'mouse_wheel_down') then
                    if isCursorOnElement(468, 322, 674, 435) then 
                        if (pag + 4 < 20) then 
                            pag = pag + 1
                        end
                    end 
                elseif (key == 'mouse_wheel_up') then 
                    if isCursorOnElement(468, 322, 674, 435) then 
                        if (pag - 1 >= 0) then 
                            pag = pag - 1
                        end
                    end
                end
            end
        end
    end
)
