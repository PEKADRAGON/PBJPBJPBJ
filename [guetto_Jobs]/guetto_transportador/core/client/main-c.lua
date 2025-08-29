local instance = {}

local x, y = (screen.x - respc(695)) / 2, (screen.y - respc(458)) / 2

instance.svgs = {
    ['icon-truck'] = svgCreate(respc(24), respc(18), [[
        <svg width="24" height="18" viewBox="0 0 24 18" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M18 15.5C17.6022 15.5 17.2206 15.342 16.9393 15.0607C16.658 14.7794 16.5 14.3978 16.5 14C16.5 13.6022 16.658 13.2206 16.9393 12.9393C17.2206 12.658 17.6022 12.5 18 12.5C18.3978 12.5 18.7794 12.658 19.0607 12.9393C19.342 13.2206 19.5 13.6022 19.5 14C19.5 14.3978 19.342 14.7794 19.0607 15.0607C18.7794 15.342 18.3978 15.5 18 15.5ZM19.5 6.5L21.46 9H17V6.5M6 15.5C5.60218 15.5 5.22064 15.342 4.93934 15.0607C4.65804 14.7794 4.5 14.3978 4.5 14C4.5 13.6022 4.65804 13.2206 4.93934 12.9393C5.22064 12.658 5.60218 12.5 6 12.5C6.39782 12.5 6.77936 12.658 7.06066 12.9393C7.34196 13.2206 7.5 13.6022 7.5 14C7.5 14.3978 7.34196 14.7794 7.06066 15.0607C6.77936 15.342 6.39782 15.5 6 15.5ZM20 5H17V1H3C1.89 1 1 1.89 1 3V14H3C3 14.7956 3.31607 15.5587 3.87868 16.1213C4.44129 16.6839 5.20435 17 6 17C6.79565 17 7.55871 16.6839 8.12132 16.1213C8.68393 15.5587 9 14.7956 9 14H15C15 14.7956 15.3161 15.5587 15.8787 16.1213C16.4413 16.6839 17.2044 17 18 17C18.7956 17 19.5587 16.6839 20.1213 16.1213C20.6839 15.5587 21 14.7956 21 14H23V9L20 5Z" fill="white"/>
        </svg>
    ]]);

    ['icon-close'] = svgCreate(respc(16), respc(16), [[
        <svg width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path fill-rule="evenodd" clip-rule="evenodd" d="M7.99956 8.94244L11.7709 12.7138C11.8966 12.8352 12.065 12.9024 12.2398 12.9009C12.4146 12.8994 12.5818 12.8293 12.7054 12.7057C12.829 12.582 12.8992 12.4148 12.9007 12.24C12.9022 12.0652 12.835 11.8968 12.7136 11.7711L8.94222 7.99977L12.7136 4.22844C12.835 4.10271 12.9022 3.9343 12.9007 3.75951C12.8992 3.58471 12.829 3.4175 12.7054 3.2939C12.5818 3.17029 12.4146 3.10018 12.2398 3.09866C12.065 3.09714 11.8966 3.16434 11.7709 3.28577L7.99956 7.05711L4.22822 3.28577C4.10192 3.16734 3.9345 3.10268 3.76138 3.1055C3.58825 3.10831 3.42302 3.17836 3.30063 3.30084C3.17824 3.42331 3.1083 3.5886 3.10561 3.76172C3.10293 3.93485 3.1677 4.10222 3.28622 4.22844L7.05689 7.99977L3.28556 11.7711C3.22188 11.8326 3.1711 11.9062 3.13616 11.9875C3.10122 12.0688 3.08283 12.1563 3.08206 12.2448C3.08129 12.3334 3.09815 12.4211 3.13168 12.5031C3.1652 12.585 3.2147 12.6594 3.27729 12.722C3.33989 12.7846 3.41432 12.8341 3.49625 12.8677C3.57818 12.9012 3.66597 12.918 3.75449 12.9173C3.84301 12.9165 3.93049 12.8981 4.01183 12.8632C4.09316 12.8282 4.16673 12.7774 4.22822 12.7138L7.99956 8.94244Z" fill="white"/>
        </svg>
    ]]);
}

function instance.render ()
    CreateThread(function()
        while (instance.visible) do 

            --| Alpha 
            local in_alpha = getAnimation('in_alpha');
            local y = getAnimation('in_position');
            
            --Cursor
            cursorUpdate ()

            --Imagens Fundos
            dxDrawImage(x, y, respc(695), respc(458), 'core/assets/fundos/tablet.png', 0, 0, 0, tocolor(255, 255, 255, in_alpha))

            --Imagens Icons 
            dxDrawImage(x + respc(83), y + respc(66), respc(97), respc(18), 'core/assets/icons/logo.png', 0, 0, 0, tocolor(255, 255, 255, in_alpha))

            --Textos 
            dxDrawText("TRANSPORTADORA", x + respc(83), y + respc(84), respc(96), respc(10), tocolor(129, 129, 129, in_alpha), 1, exports['guetto_assets']:dxCreateFont('bold', 15), 'left', 'top')

            --Button | Viagem
            dxDrawRoundedRectangle('button:viagem', x + respc(470), y + respc(70), respc(111), respc(29), isCursorOnElement(x + respc(470), y + respc(70), respc(111), respc(29)) and tocolor(193, 159, 114, in_alpha) or tocolor(20, 21, 21, in_alpha), respc(7), false)
            dxDrawText("PEGAR VIAGEM", x + respc(470), y + respc(70), respc(111), respc(29), isCursorOnElement(x + respc(470), y + respc(70), respc(111), respc(29)) and tocolor(255, 255, 255, in_alpha) or tocolor(129, 129, 129, in_alpha), 1, exports['guetto_assets']:dxCreateFont('regular', 12), 'center', 'center')

            --Button | Close
            dxDrawRoundedRectangle('button:close', x + respc(587), y + respc(70), respc(27), respc(29), isCursorOnElement(x + respc(587), y + respc(70), respc(27), respc(29)) and tocolor (238, 59, 59, in_alpha) or tocolor(20, 21, 21, in_alpha), respc(7), false)
            dxDrawImage(x + respc(593), y + respc(77), respc(16), respc(16), instance.svgs['icon-close'], 0, 0, 0, tocolor(255, 255, 255, in_alpha))

            --Windows 
            dxDrawText('Destino', x + respc(92), y + respc(132), respc(39), respc(12), tocolor(129, 129, 129, in_alpha), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'left', 'center')
            dxDrawText('Tempo', x + respc(332), y + respc(132), respc(39), respc(12), tocolor(129, 129, 129, in_alpha), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'left', 'center')
            dxDrawText('Pagamento', x + respc(530), y + respc(132), respc(39), respc(12), tocolor(129, 129, 129, in_alpha), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'left', 'center')

            local player_position = {
                getElementPosition(localPlayer)
            }

            local offSetY = y + respc(152)
            local width, height = respc(541), respc(48)

            --GridList 
            for i = 1, 5 do 
                local v = config["Destinos"][i + instance.scroll]

                if v then 

                    local distance = getDistanceBetweenPoints3D(player_position[1], player_position[2], player_position[3], v["Posição"][1], v["Posição"][2], v["Posição"][3])
                    local time = metrosParaMinutos (distance, 100)
                    local city, zone = getZoneName(v["Posição"][1], v["Posição"][2], v["Posição"][3], true), getZoneName(v["Posição"][1], v["Posição"][2], v["Posição"][3])

                    dxDrawText(city, x + respc(131), offSetY + respc(10), respc(65), respc(14), tocolor(255, 255, 255, in_alpha), 1, exports['guetto_assets']:dxCreateFont('medium', 15), 'left', 'center')
                    dxDrawText(zone, x + respc(131), offSetY + respc(27), respc(44), respc(11), tocolor(184, 184, 184, in_alpha), 1, exports['guetto_assets']:dxCreateFont('regular', 14), 'left', 'center')
                    dxDrawText(math.floor(time)..' minutos', x + respc(332), offSetY + respc(19), respc(44), respc(11), tocolor(184, 184, 184, in_alpha), 1, exports['guetto_assets']:dxCreateFont('regular', 14), 'left', 'center')
                    dxDrawText('R$ '..formatNumber(v['Pagamento'], '.'), x + respc(551), offSetY + respc(19), respc(36), respc(11), tocolor(255, 255, 255, in_alpha), 1, exports['guetto_assets']:dxCreateFont('regular', 14), 'right', 'center')
    
                    dxDrawRoundedRectangle("button:"..i, x + respc(77), offSetY, width, height, instance.select == i and tocolor(255, 255, 255, 0.17 * in_alpha) or isCursorOnElement(x + respc(77), offSetY, width, height) and tocolor (255, 255, 255, 0.17 * in_alpha) or tocolor(49, 49, 49, 0.17 * in_alpha), respc(1), false)
                    dxDrawImage(x + respc(91), offSetY + height / 2 - respc(18) / 2, respc(24), respc(18), instance.svgs['icon-truck'], 0, 0, 0, tocolor(255, 255, 255, in_alpha))

                    offSetY = offSetY + height + respc(2)
                end

            end

            coroutine.yield()
        end
    end)
end

function instance.click (button, state)
    if button == 'left' and state == 'down' then 
        local offSetY = y + respc(152)
        local width, height = respc(541), respc(48)
        for i = 1, 5 do 
            local v = config["Destinos"][i]
            if v then 
                if isCursorOnElement(x + respc(77), offSetY, width, height) then 
                    instance.select = i 
                    print(instance.select)
                    break 
                end
                offSetY = offSetY + height + respc(2)
            end
        end
        if isCursorOnElement(x + respc(587), y + respc(70), respc(27), respc(29)) then 
            instance.toggle(false)
            triggerServerEvent("onPlayerFinishTransporter", resourceRoot, localPlayer)
        elseif isCursorOnElement(x + respc(470), y + respc(70), respc(111), respc(29)) then 
            if (instance.select and instance.select ~= 0) then
                triggerServerEvent('onPlayerTransport', resourceRoot, localPlayer, instance.index, instance.select + instance.scroll)
            else
                sendMessageClient('Selecione um destino!', 'error')
            end
        end
    end
end

function instance.toggle (state)
    if (state and not instance.visible) then 

        createAnimation('in_alpha', 0, 255, 400, 'OutQuad');
        createAnimation('in_position', 0, y, 400, 'OutQuad');

        showChat(false)
        showCursor(true)

        instance.visible = true 
        instance.select = 0;

        instance.scroll = 0;
        
        execAnimation('in_alpha', 0, 255, 400, 'OutQuad')
        execAnimation('in_position', 0, y, 400, 'OutQuad')

        addEventHandler('onClientClick', root, instance.click)
        instance.render()
    elseif (not state and instance.visible) then

        showChat(true)
        showCursor(false)

        execAnimation('in_alpha', 255, 0, 400, 'OutQuad')
        execAnimation('in_position', y, 0, 400, 'OutQuad')

        removeEventHandler('onClientClick', root, instance.click)

        setTimer(function()
            instance.visible = false
        end, 400, 1)
    end
end

createEvent("onClientSendIndex", resourceRoot, function(index)
    instance.index = index;
    instance.toggle(true)
end)

addEventHandler('onClientKey', root, function(button, state)
    if instance.visible then 
        if button == 'backspace' and state then 
            instance.toggle(false)
        elseif button == 'mouse_wheel_up' and  state then 
            if (instance.scroll > 0) then 
                instance.scroll = instance.scroll - 1
            end
    
        elseif button == 'mouse_wheel_down' and state then 
            if (instance.scroll >= 0 and instance.scroll < #config.Destinos - 5) then
                instance.scroll = instance.scroll + 1
            end
        end
    end
end)

addEventHandler ( "onClientPedDamage", root, function() 
    if (getElementData(source, "onPedTransporter") or false) then 
        cancelEvent()
    end
end)

addEventHandler('onClientClick', root, function(button, state, _, _, _, _, _, element)
    if button == 'left' and state == 'down' then 
        if element and isElement(element) and getElementType(element) == 'ped' and getElementData(element, 'onPedTransporter') then 
            local x, y, z = getElementPosition(localPlayer);
            local x2, y2, z2 = getElementPosition(element);
            local distance = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2);
            if distance <= 3 then 
                if (getElementData(localPlayer, "Emprego") == "Transportador") then 
                    triggerServerEvent('onPlayerRequestTransporter', resourceRoot, localPlayer, element)
                else
                    sendMessageClient("Você não trabalha aqui!", "info")
                end
            end
        end
    end
end)

createEvent("onPlayerTogglePanelTransporter", resourceRoot, function()
    instance.toggle(false)
end)