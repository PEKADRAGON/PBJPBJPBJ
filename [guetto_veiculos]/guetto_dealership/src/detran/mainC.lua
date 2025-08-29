local isEventHandlerAdded = false 
local alpha = { }
local vehicles = {}

local Global = {
    Panel = {

    }    
}
local slots = {
    {558, 419, 490, 68};
    {558, 492, 490, 68};
    {558, 565, 490, 68};
    {558, 638, 490, 68};
}

local function draw ( )
    local fade = interpolateBetween(alpha[1], 0, 0, alpha[2], 0, 0, ( getTickCount ( ) - alpha[3] ) / 400, 'Linear' )

    dxDrawImage(530, 322, 545, 435, 'assets/images/fundo-garagem.png', 0, 0, 0, tocolor(255, 255, 255, fade))
    dxDrawImage(708, 322, 194, 88, 'assets/images/icon-detran.png', 0, 0 ,0 , tocolor(255, 255, 255, fade))

    dxDrawImage(1091, 322, 299, 184, 'assets/images/specs-fundo.png', 0, 0, 0, tocolor(18, 18, 18, 0.94 * fade))
    dxDrawImage(1091, 518, 299, 244, 'assets/images/specs-fundo.png', 0, 0, 0, tocolor(18, 18, 18, 0.94 * fade))

    for i, v in ipairs ( slots ) do 
        local dados = vehicles[i + pag]
        if (dados) then 
            local infos = fromJSON(dados.infos)
            dxDrawImage(v[1], v[2], v[3], v[4], 'assets/images/rectangle-vehicle.png', 0, 0, 0, not window_vehicle and select_vehicle == i + pag and tocolor(130, 112, 89, 0.94 * fade) or isCursorOnElement(v[1], v[2], v[3], v[4]) and tocolor(130, 112, 89, 0.94 * fade) or tocolor(31, 31, 31, 0.94 * fade))
            dxDrawText(infos[3].. ' | '.. infos[1], v[1] + 22, v[2] + 21, 236, 26, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'left', 'center')
        end
    end

    dxDrawText('Taxas do detran', 1107, 336, 106, 19, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'left', 'top')
    dxDrawText('Recuperação', 1108, 367, 106, 19, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('bold', 15), 'left', 'top')
    dxDrawText('Veículos disponível', 560, 387, 224, 19, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'left', 'top')

    if select_vehicle then 
        local dados = vehicles[select_vehicle]
        local infos = fromJSON(dados.dados)
        if infos then 
            local data = fromJSON(dados.infos);
            if data then 
                local percent = tonumber(data[2]) * 0.5
                dxDrawText('$ '..formatNumber(percent, '.'), 1107, 392, 97, 23, tocolor(30, 161, 111, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'left', 'top')
                dxDrawText('Placa', 1107, 434, 97, 23, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('medium', 15), 'left', 'top')
                dxDrawText(dados.plate, 1107, 460, 97, 23, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'left', 'top')
            end
        end
    end

    dxDrawImage(1108, 549, 22, 22, 'assets/images/icon-alarme.png', 0, 0, 0, isCursorOnElement(1141, 548, 131, 31) and tocolor(193, 159, 114, fade) or tocolor(147, 147, 147, fade))
    dxDrawText('Emplacar', 1141, 549, 131, 31, isCursorOnElement(1141, 548, 131, 31) and tocolor(193, 159, 114, fade) or tocolor(208, 208, 208, fade), 1, exports['guetto_assets']:dxCreateFont('medium', 15), 'left', 'top')

    dxDrawImage(1107, 624, 22, 22, 'assets/images/icon-recuperar.png', 0, 0, 0, isCursorOnElement(1140, 619, 131, 31) and tocolor(193, 159, 114, fade) or tocolor(147, 147, 147, fade))
    dxDrawText('RECUPERAR', 1140, 623, 131, 31, isCursorOnElement(1140, 619, 131, 31) and tocolor(193, 159, 114, fade) or tocolor(208, 208, 208, fade), 1, exports['guetto_assets']:dxCreateFont('medium', 15), 'left', 'top')

    dxDrawImage(1108, 702, 24, 24, 'assets/images/icon-ipva.png', 0, 0, 0, isCursorOnElement(1141, 700, 131, 31) and tocolor(193, 159, 114, fade) or tocolor(147, 147, 147, fade))
    dxDrawText('IPVA/SEGURO', 1141, 700, 131, 31, isCursorOnElement(1141, 700, 131, 31) and tocolor(193, 159, 114, fade) or tocolor(208, 208, 208, fade), 1, exports['guetto_assets']:dxCreateFont('medium', 15), 'left', 'top')

    dxDrawRectangle(1110, 598, 261, 1, tocolor(58, 58, 58, fade))
    dxDrawRectangle(1110, 675, 261, 1, tocolor(58, 58, 58, fade))
end


addEventHandler('onClientClick', root,
    function ( button, state )
        if isEventHandlerAdded then 
            if button == 'left' then 
                if state == 'down' then 
                    for i, v in ipairs ( slots ) do 
                        local dados = vehicles[i+ pag]
                        if (dados) then 
                            if isCursorOnElement(unpack(v)) then
                                if select_vehicle ~= i + pag then 
                                    select_vehicle = i + pag
                                    break
                                end 
                            end
                        end
                    end
                    if isCursorOnElement(1141, 549, 131, 31) then 
                        local res_element = getResourceDynamicElementRoot(getResourceFromName('guetto_dealership'))
                        triggerServerEvent("onPlayerRegisterVehicle", res_element, vehicles[select_vehicle])
                    elseif isCursorOnElement(1140, 623, 131, 31) then 
                        local dados = vehicles[select_vehicle]
                        if dados then 
                            local data = fromJSON(dados.infos);
                            local res_element = getResourceDynamicElementRoot(getResourceFromName('guetto_dealership'))
                            triggerServerEvent("onPlayerRecoverVehicle", res_element, vehicles[select_vehicle], tonumber(data[2]) * 0.5)
                        end
                    elseif isCursorOnElement(1141, 700, 131, 31) then 
                        local dados = vehicles[select_vehicle]
                        if dados then 
                            local data = fromJSON(dados.infos);
                            local res_element = getResourceDynamicElementRoot(getResourceFromName('guetto_dealership'))
                            triggerServerEvent("onPlayerVehicleIPVA", res_element, vehicles[select_vehicle], tonumber(data[2]) * 0.5)
                        end
                    end 
                end
            end
        end
    end
)

local function toggle ( state )
    if (state and not isEventHandlerAdded) then 
        isEventHandlerAdded = true 
        select_vehicle = 1
        pag = 0
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

addEvent("onPlayerDrawDetran", true)
addEventHandler("onPlayerDrawDetran", resourceRoot,
    function ( _vehicles )
        vehicles = _vehicles
        toggle(true)
    end
)

bindKey("backspace", "down",
    function ( )
        toggle(false)
    end
)

addEventHandler('onClientKey', root, 
    function(key, press) 
        if isEventHandlerAdded then 
            if (press) then 
                if (key == 'mouse_wheel_down') then
                    if isCursorOnElement(468, 322, 674, 435) then 
                        if (pag + 4 < #vehicles) then 
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
