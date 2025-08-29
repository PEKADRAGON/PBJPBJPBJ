local instance = {}

instance.svgs = {
    ['background'] = svgCreate(919, 698, [[
        <svg width="919" height="698" viewBox="0 0 919 698" fill="none" xmlns="http://www.w3.org/2000/svg">
            <rect width="919" height="698" rx="20" fill="#121212" fill-opacity="0.95"/>
        </svg>
    ]]);
    ['button'] = svgCreate(214, 58, [[
        <svg width="214" height="58" viewBox="0 0 214 58" fill="none" xmlns="http://www.w3.org/2000/svg">
            <rect width="214" height="58" rx="4" fill="white"/>
        </svg>
    ]]);
    ['button-service'] = svgCreate(331, 58, [[
        <svg width="331" height="58" viewBox="0 0 331 58" fill="none" xmlns="http://www.w3.org/2000/svg">
            <rect width="331" height="58" rx="4" fill="white"/>
        </svg>
    ]]);
    ['button-slot'] = svgCreate(817, 76, [[
        <svg width="817" height="76" viewBox="0 0 817 76" fill="none" xmlns="http://www.w3.org/2000/svg">
            <rect width="817" height="76" rx="5" fill="white"/>
        </svg>
    ]]);
    ['rectangle-footer'] = svgCreate(817, 57, [[
        <svg width="817" height="57" viewBox="0 0 817 57" fill="none" xmlns="http://www.w3.org/2000/svg">
            <rect width="817" height="57" rx="4" fill="white"/>
        </svg>
    ]]);
    ['icon-info'] = svgCreate(24, 24, [[
        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M12 2C6.48 2 2 6.48 2 12C2 17.52 6.48 22 12 22C17.52 22 22 17.52 22 12C22 6.48 17.52 2 12 2ZM12 17C11.45 17 11 16.55 11 16V12C11 11.45 11.45 11 12 11C12.55 11 13 11.45 13 12V16C13 16.55 12.55 17 12 17ZM13 9H11V7H13V9Z" fill="#C19F72"/>
        </svg>
    ]]);
    ['icon-vehicle'] = svgCreate(36, 36, [[
        <svg width="36" height="36" viewBox="0 0 36 36" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M9.75 7.5C8.76 7.5 7.92 8.13 7.62 9L4.5 18V30C4.5 30.3978 4.65804 30.7794 4.93934 31.0607C5.22064 31.342 5.60218 31.5 6 31.5H7.5C7.89782 31.5 8.27936 31.342 8.56066 31.0607C8.84196 30.7794 9 30.3978 9 30V28.5H16.95C16.6556 27.5271 16.504 26.5165 16.5 25.5C16.5024 23.6858 16.9749 21.9031 17.8713 20.3258C18.7677 18.7485 20.0575 17.4304 21.615 16.5H7.5L9.75 9.75H26.25L28.02 15.045C28.9395 15.1409 29.8423 15.3577 30.705 15.69L28.38 9C28.08 8.13 27.24 7.5 26.25 7.5H9.75ZM25.5 18C25.4083 17.9983 25.319 18.0289 25.2477 18.0865C25.1764 18.1441 25.1276 18.225 25.11 18.315L24.825 20.295C24.375 20.49 23.94 20.73 23.55 21L21.69 20.25C21.525 20.25 21.33 20.25 21.225 20.445L19.725 23.04C19.635 23.205 19.665 23.4 19.815 23.52L21.405 24.75C21.3453 25.2482 21.3453 25.7518 21.405 26.25L19.815 27.48C19.7476 27.5378 19.7019 27.6169 19.6856 27.7042C19.6692 27.7914 19.6831 27.8817 19.725 27.96L21.225 30.555C21.315 30.75 21.51 30.75 21.69 30.75L23.55 30C23.94 30.27 24.36 30.525 24.825 30.705L25.11 32.685C25.14 32.865 25.29 33 25.5 33H28.5C28.665 33 28.83 32.865 28.86 32.685L29.145 30.705C29.595 30.51 30 30.27 30.405 30L32.25 30.75C32.445 30.75 32.64 30.75 32.745 30.555L34.245 27.96C34.2869 27.8817 34.3008 27.7914 34.2844 27.7042C34.2681 27.6169 34.2224 27.5378 34.155 27.48L32.55 26.25C32.58 25.995 32.61 25.755 32.61 25.5C32.61 25.245 32.595 25.005 32.55 24.75L34.14 23.52C34.2074 23.4622 34.2531 23.3831 34.2694 23.2958C34.2858 23.2086 34.2719 23.1183 34.23 23.04L32.73 20.445C32.64 20.25 32.445 20.25 32.25 20.25L30.405 21C30 20.73 29.595 20.475 29.13 20.295L28.845 18.315C28.8355 18.2296 28.7953 18.1505 28.7318 18.0925C28.6684 18.0345 28.5859 18.0017 28.5 18H25.5ZM9.75 19.5C10.3467 19.5 10.919 19.7371 11.341 20.159C11.7629 20.581 12 21.1533 12 21.75C12 22.3467 11.7629 22.919 11.341 23.341C10.919 23.7629 10.3467 24 9.75 24C9.15326 24 8.58097 23.7629 8.15901 23.341C7.73705 22.919 7.5 22.3467 7.5 21.75C7.5 21.1533 7.73705 20.581 8.15901 20.159C8.58097 19.7371 9.15326 19.5 9.75 19.5ZM27 23.25C28.245 23.25 29.25 24.255 29.25 25.5C29.25 26.745 28.245 27.75 27 27.75C25.74 27.75 24.75 26.745 24.75 25.5C24.75 24.255 25.755 23.25 27 23.25Z" fill="#DCDCDC"/>
        </svg>
    ]]);
    ['icon-skins'] = svgCreate(36, 30, [[
        <svg width="36" height="30" viewBox="0 0 36 30" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M35.5045 5.6543L24.5526 0C23.422 1.62891 20.9189 2.76562 17.9995 2.76562C15.0801 2.76562 12.577 1.62891 11.4464 0L0.494482 5.6543C0.0501069 5.88867 -0.129893 6.45117 0.0894819 6.91406L3.30698 13.623C3.53198 14.0859 4.07198 14.2734 4.51636 14.0449L7.70011 12.4219C8.29636 12.1172 8.99386 12.5684 8.99386 13.2656V28.125C8.99386 29.1621 9.79823 30 10.7939 30H25.1939C26.1895 30 26.9939 29.1621 26.9939 28.125V13.2598C26.9939 12.5684 27.6914 12.1113 28.2876 12.416L31.4714 14.0391C31.9157 14.2734 32.4557 14.0859 32.6807 13.6172L35.9039 6.91406C36.1289 6.45117 35.9489 5.88281 35.5045 5.6543Z" fill="#DCDCDC"/>
        </svg>
    ]]);
    ['button-reset-custom'] = svgCreate(246, 43, [[
        <svg width="246" height="43" viewBox="0 0 246 43" fill="none" xmlns="http://www.w3.org/2000/svg">
            <rect width="246" height="43" rx="3" fill="white"/>
        </svg>
    ]]);
    ['icon-garagem'] = svgCreate(42, 42, [[
        <svg width="42" height="42" viewBox="0 0 42 42" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M33.25 35H29.75V19.25H12.25V35H8.75V15.75L21 8.75L33.25 15.75V35ZM14 21H28V24.5H14V21ZM14 26.25H28V29.75H14V26.25ZM28 31.5V35H14V31.5H28Z" fill="white"/>
        </svg>
    ]]);
}

instance.slots = {
    {569, 269, 817, 76};
    {569, 349, 817, 76};
    {569, 429, 817, 76};
    {569, 509, 817, 76};
}

function instance.render ()
    local alpha = interpolateBetween(instance.alpha[1], 0, 0, instance.alpha[2], 0, 0, ( getTickCount ( ) - instance.alpha[3] ) / 400, 'OutQuad')
    y = interpolateBetween(instance.move[1], 0, 0, instance.move[2], 0, 0, ( getTickCount ( ) - instance.move[3] ) / 400, 'OutQuad')

    dxDrawImage(518, y, 919, 698, instance.svgs.background, 0, 0, 0, tocolor(255, 255, 255, alpha))

    dxDrawText('Gerenciador', 573, y + 39, 141, 25, tocolor(193, 159, 114, alpha), 1, exports['guetto_assets']:dxCreateFont('bold', 25), 'left', 'top')
    dxDrawText('Pegue seu equipamento em nosso gerenciador.', 573, y + 67, 416, 24, tocolor(173, 173, 173, alpha), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'left', 'top')

    dxDrawImage(569, y + 118, 214, 58,  instance['svgs']['button'], 0, 0, 0, instance.window == 'Skins' and tocolor(193, 159, 114, alpha) or isCursorOnElement(569, y + 118, 214, 58) and tocolor(193, 159, 114, alpha) or tocolor(34, 35, 35, alpha) )
    dxDrawImage(788, y + 118, 214, 58,  instance['svgs']['button'], 0, 0, 0, instance.window == 'Veiculos' and tocolor(193, 159, 114, alpha) or isCursorOnElement(788, y + 118, 214, 58) and tocolor(193, 159, 114, alpha) or tocolor(34, 35, 35, alpha) )
    
    dxDrawText('ROUPA', 569, y + 118, 214, 58, tocolor(255, 255, 255, alpha), 1, exports['guetto_assets']:dxCreateFont('medium', 15), 'center', 'center')
    dxDrawText('VEÍCULOS', 788, y + 118, 214, 58, tocolor(255, 255, 255, alpha), 1, exports['guetto_assets']:dxCreateFont('medium', 15), 'center', 'center')

    local service = (getElementData(localPlayer, config["ElementsData"][config["Gerenciador"][instance.acl]["Type"]]) or false)

    dxDrawImage(1055, y + 118, 331, 58,  instance['svgs']['button-service'], 0, 0, 0, isCursorOnElement(1055, y + 118, 331, 58) and tocolor(193, 159, 114, alpha) or tocolor(34, 35, 35, alpha) )
    dxDrawText(not service and 'ENTRAR EM SERVIÇO' or 'SAIR DE SERVIÇO', 1055, y + 118, 331, 58, tocolor(255, 255, 255, alpha), 1, exports['guetto_assets']:dxCreateFont('bold', 15), 'center', 'center')

    dxDrawRectangle(569, y + 192, 817, 1, tocolor(34, 35, 35, alpha))

    if (instance.acl) then 
        for i = 1, #instance.slots do 
            local v = instance.slots[i]
            if instance.config[instance.window][i] then 
                local data = instance.config[instance.window][i + instance.scroll]
                dxDrawImage(v[1], y + v[2], v[3], v[4], instance.svgs['button-slot'], 0, 0, 0, isCursorOnElement(v[1], y + v[2], v[3], v[4]) and tocolor(128, 128, 128, 0.51 * alpha) or tocolor(217, 217, 217, 0.12 * alpha))
                dxDrawText(data.name, v[1] + 80, y + v[2] + 19, 126, 14, tocolor(255, 255, 255, alpha), 1, exports['guetto_assets']:dxCreateFont('bold', 17), 'left', 'top')
                dxDrawText(data.description, v[1] + 80, y + v[2] + 39, 73, 18, tocolor(173, 173, 173, alpha), 1, exports['guetto_assets']:dxCreateFont('medium', 14), 'left', 'top')
                if instance.window == "Veiculos" then
                    dxDrawImage(1221, v[2] + y + 17, 42, 42, instance.svgs['icon-garagem'], 0, 0, 0, tocolor(255, 255, 255, alpha))
                    dxDrawText("GARAGEM", 1271, v[2] + y + 19, 69, 14, tocolor(255, 255, 255, alpha), 1, exports['guetto_assets']:dxCreateFont('bold', 16), 'left', 'top')
                    dxDrawText(data.space..'/'..(config['Gerenciador'][instance.acl][instance.window][i + instance.scroll]["space"])..'', 1271, v[2] + y + 39, 71, 18, tocolor(173, 173, 173, alpha), 1, exports['guetto_assets']:dxCreateFont('medium', 14), 'left', 'top')
                    dxDrawImage(597, v[2] + y + 26, 30, 30, instance['svgs']['icon-vehicle'], 0, 0, 0, tocolor(255, 255, 255, alpha))
                elseif instance.window == 'Skins' then 
                    dxDrawImage(597, v[2] + y + 26, 28, 23, instance['svgs']['icon-skins'], 0, 0, 0, tocolor(255, 255, 255, alpha))
                end
            end
        end
        local Text = config["Ui"][instance.window]["Text"]
        local Description = config["Ui"][instance.window]["Description"]

        dxDrawText(Text, 625, y + 210, 133, 14, tocolor(193, 159, 114, alpha), 1, exports['guetto_assets']:dxCreateFont('bold', 17), 'left', 'top')
        dxDrawText(Description, 625, y + 229, 133, 14, tocolor(173, 173, 173, alpha), 1, exports['guetto_assets']:dxCreateFont('regular', 14), 'left', 'top')

        if instance.window == "Skins" then 
            dxDrawImage(1140, y + 206, 246, 43, instance['svgs']['button-reset-custom'], 0, 0, 0, isCursorOnElement(1140, y + 206, 246, 43) and tocolor(193, 159, 114, alpha) or tocolor(43, 44, 44, alpha))
            dxDrawText('GUARDAR ROUPA', 1140, y + 206, 246, 43, tocolor(255, 255, 255, alpha), 1, exports['guetto_assets']:dxCreateFont('bold', 16), 'center', 'center')
            dxDrawImage(574, y + 213, 36, 30, instance['svgs']['icon-skins'], 0, 0, 0, tocolor(255, 255, 255, alpha))
        elseif instance.window == "Veiculos" then
            dxDrawImage(574, y + 210, 36, 36, instance.svgs['icon-vehicle'], 0, 0, 0, tocolor(255, 255, 255, alpha))
        end
    end

    dxDrawImage(569, y + 601, 817, 57, instance.svgs['rectangle-footer'], 0, 0, 0, tocolor(217, 217, 217, 0.12 * alpha))
    dxDrawImage(588, y + 618, 24, 24, instance.svgs['icon-info'], 0, 0, 0, tocolor(255, 255, 255, alpha))

    dxDrawText('Clique duas vezes sobre a seleção para spawnar/utilizar.', 621, y + 621, 366, 18, tocolor(173, 173, 173, alpha), 1, exports['guetto_assets']:dxCreateFont('medium', 15), 'left', 'center')
    dxDrawText('[BACKSPACE] PARA SAIR.', 1190, y + 621, 366, 18, tocolor(173, 173, 173, alpha), 1, exports['guetto_assets']:dxCreateFont('medium', 15), 'left', 'center')

    if not instance.visible and alpha <= 0 then 
        removeEventHandler('onClientRender', root, instance.render)
    end
end

function instance.key (button, state)
    if button == 'backspace' and state then 
        instance.toggle(false)
    elseif button == 'mouse_wheel_down' and state then
        if instance.scroll and  instance.scroll + 4 < #instance.config[instance.window] then 
            instance.scroll = instance.scroll + 1
        end
    elseif button == 'mouse_wheel_up' and state then 
        if instance.scroll > 0 then 
            instance.scroll = instance.scroll - 1
        end
    end 
end

function instance.double(button, state)
    if button == 'left' then 
        if (instance.acl) then 
            for i = 1, #instance.slots do 
                local v = instance.slots[i]
                if isCursorOnElement(v[1], y + v[2], v[3], v[4]) then 
                    if instance.config[instance.window][i] then 
                        local data = instance.config[instance.window][i + instance.scroll]
                        if (instance.delay and getTickCount ( ) - instance.delay <= 5000) then 
                            return sendMessageClient("Você está fazendo isso rápido demais!", "info")
                        end
                        triggerServerEvent("onPlayerExecuteAction", resourceRoot, {
                            acl = instance.acl,
                            window = instance.window,
                            data = data,
                            i = i + instance.scroll
                        })
                        instance.delay = getTickCount()
                        instance.toggle(false)
                    end
                end
            end
        end
    end
end

function instance.click (button, state)
    if button == 'left' and state == 'down' then 
        if instance.visible then 
            if isCursorOnElement(1140, y + 206, 246, 43) then 
                if (instance.delay and getTickCount ( ) - instance.delay <= 5000) then 
                    return sendMessageClient("Você está fazendo isso rápido demais!", "info")
                end
                triggerServerEvent("onPlayerExecuteAction", resourceRoot, {
                    window = 'TakeClothes',
                    acl = instance.acl
                })
                instance.delay = getTickCount()
                instance.toggle(false)
            end
            if isCursorOnElement(569, y + 118, 214, 58) then 
                if instance.window ~= 'Skins' then 
                    instance.window = 'Skins'
                end
            elseif isCursorOnElement(788, y + 118, 214, 58) then
                if instance.window ~= 'Veiculos' then
                    instance.window = 'Veiculos'
                end
            elseif isCursorOnElement(1055, y + 118, 331, 58) then
                triggerServerEvent("onPlayerEnterService", resourceRoot, {
                    acl = instance.acl,
                    window = instance.window
                })
                instance.delay = getTickCount()
            end
        end
    end
end

function instance.toggle (state)
    if state and not instance.visible then 
        instance.visible = true 
        instance.window = 'Skins'
        
        instance.alpha = {0, 255, getTickCount()}
        instance.move = {0, 191, getTickCount()}
        instance.delay = 0
        instance.scroll = 0;

        showCursor(true)
        showChat(false)

        addEventHandler('onClientRender', root, instance.render)
        addEventHandler('onClientKey', root, instance.key)
        addEventHandler('onClientClick', root, instance.click)
        addEventHandler('onClientDoubleClick', root, instance.double)

    elseif not state and instance.visible then

        showChat(true)
        showCursor(false)

        instance.visible = false 

        instance.move = {191, 0, getTickCount()}
        instance.alpha = {255, 0, getTickCount()}

        removeEventHandler('onClientKey', root, instance.key)
        removeEventHandler('onClientClick', root, instance.click)
        removeEventHandler('onClientDoubleClick', root, instance.double)
    end
end

createEvent("onPlayerDrawPanel", resourceRoot, function (acl, info)
    instance.acl = acl 
    instance.config = info
    instance.toggle(true)
end)