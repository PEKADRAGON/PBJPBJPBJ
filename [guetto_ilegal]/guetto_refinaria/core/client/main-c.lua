local instance = {}
local x, y = (screen.x - respc(608)) / 2, (screen.y - respc(402)) / 2

instance.visible = false

instance.svgs = {
    ['icon-drug'] = svgCreate(respc(28), respc(28), [[
        <svg width="28" height="28" viewBox="0 0 28 28" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M18.9001 4.08203C17.7335 2.91536 16.2168 2.33203 14.8168 2.33203C13.4168 2.33203 11.7835 2.91536 10.7335 4.08203L3.9668 10.6154C1.63346 12.9487 1.63346 16.5654 3.9668 18.8987C6.30013 21.232 9.9168 21.232 12.2501 18.8987L18.9001 12.2487C21.1168 10.032 21.1168 6.2987 18.9001 4.08203ZM17.2668 10.6154L14.0001 13.882L9.80013 9.7987L4.6668 14.932C4.6668 13.9987 4.90013 12.9487 5.7168 12.2487L12.3668 5.5987C12.9501 5.01536 13.8835 4.66536 14.7001 4.66536C15.5168 4.66536 16.4501 5.01536 17.1501 5.5987C18.5501 7.11537 18.5501 9.21537 17.2668 10.6154ZM22.8668 8.28203C22.8668 9.21536 22.6335 10.032 22.4001 10.9654C23.5668 12.3654 23.5668 14.4654 22.2835 15.7487L19.0168 19.0154L17.2668 17.2654L14.0001 20.532C12.4835 22.0487 10.3835 22.8654 8.40013 22.8654C8.63346 23.2154 8.8668 23.5654 9.2168 23.9154C11.5501 26.2487 15.1668 26.2487 17.5001 23.9154L24.1501 17.2654C26.4835 14.932 26.4835 11.3154 24.1501 8.98203C23.5668 8.7487 23.2168 8.51537 22.8668 8.28203Z" fill="#C19F72"/>
        </svg>
    ]])
}

instance.slots = {
    {x + respc(32), y + respc(132), respc(262), respc(104), 'Cannabis', 'Utilize processos para transformar o pé em brotos ressecados.', 'core/assets/icons/cannabis.png', 'marihuana'};
    {x + respc(305), y + respc(132), respc(262), respc(104), 'Erythroxylon coca', 'Utilize processos para transformar o pé em brotos ressecados.', 'core/assets/icons/coccaine.png', 'coccaine'};
}

function render ( )
    CreateThread ( function ( ) 
        while (instance.visible) do 
            local alpha = getAnimation('alpha')

            --Cursor 
            cursorUpdate ()
            
            dxDrawRoundedRectangle('background', x, y, respc(608), respc(402), tocolor(23, 23, 24, alpha), 9, false)
            dxDrawImage(x + respc(32), y + respc(34), respc(28), respc(28), instance.svgs['icon-drug'], 0, 0, 0, tocolor(255, 255, 255, alpha))

            dxDrawText("Fabrica de Drogas", x + respc(65), y + respc(39), respc(238), respc(18), tocolor(255, 255, 255, alpha), 1, exports["guetto_assets"]:dxCreateFont("medium", 15), "left", "top")

            -- Bckground´s Drug´s 

            for i, v in ipairs (instance.slots) do 
                dxDrawImage(v[1], v[2], v[3], v[4], "core/assets/fundos/rectangle-drugs.png", 0, 0, 0, instance.select == i and tocolor(120, 120, 120, 0.42 * alpha) or isCursorOnElement(v[1], v[2], v[3], v[4]) and tocolor(120, 120, 120, 0.42 * alpha) or tocolor(120, 120, 120, 0.12 * alpha))
                dxDrawImage(v[1] + respc(1), v[2] + v[4] / 2 - respc(60) / 2, respc(60), respc(60), v[7], 0, 0, 0, tocolor(255, 255, 255, alpha))
         
                dxDrawText(v[5], v[1] + respc(69), v[2] + respc(29), respc(185), respc(46), tocolor(255, 255, 255, alpha), 1, exports["guetto_assets"]:dxCreateFont("medium", 16), "left", "top")
                dxDrawText(v[6], v[1] + respc(69), v[2] + respc(48), respc(185), respc(46), tocolor(143, 143, 143, alpha), 1, exports["guetto_assets"]:dxCreateFont("regular", 13), "left", "top", false, true)
            end

            dxDrawRoundedRectangle('rectangle-amount', x + respc(35), y + respc(251), respc(535), respc(59), tocolor(128, 130, 127, 0.12 * alpha), 3, false)
            dxDrawRoundedRectangle('rectangle-factory', x + respc(35), y + respc(320), respc(535), respc(42), isCursorOnElement(x + respc(35), y + respc(320), respc(535), respc(42)) and tocolor(113, 189, 106, 0.80 * alpha) or tocolor(113, 189, 106, alpha), 3, false)

            dxDrawText("PROCESSAR PLANTA", x + respc(35), y + respc(320), respc(535), respc(42), tocolor(255, 255, 255, alpha), 1, exports["guetto_assets"]:dxCreateFont("medium", 15), "center", "center")
            dxDrawText("X", x + respc(535), y + respc(32), respc(32), respc(32), isCursorOnElement(x + respc(535), y + respc(32), respc(32), respc(32)) and tocolor(255, 0, 0, alpha) or tocolor(205, 205, 205, alpha), 1, exports["guetto_assets"]:dxCreateFont("medium", 18), "center", "center")

            dxCreateEditbox("Amount", "QUANTIDADE", x + respc(35), y + respc(251), respc(535), respc(59), {text = tocolor(68, 68, 68, alpha), text_focus = tocolor(255, 255, 255, alpha)}, {alignX = "center", alignY = "center"}, exports["guetto_assets"]:dxCreateFont("medium", 15), 15, true, false, false )
            coroutine.yield()
        end 
    end)
end

function onPlayerClick (button, state)
    if button == "left" and state == "down" then 
        if instance.visible then 
            for i, v in ipairs (instance.slots) do 
                if isCursorOnElement(v[1], v[2], v[3], v[4]) then 
                    instance.select = i
                    break 
                end
            end
            if isCursorOnElement(x + respc(535), y + respc(32), respc(32), respc(32)) then 
                toggle(false)
            elseif isCursorOnElement(x + respc(35), y + respc(320), respc(535), respc(42)) then 
                local amount = tonumber(dxEditboxGetText('Amount'))
                if not (amount or amount == 0) then 
                    return sendMessageClient("Digite a quantidade!", "error")
                end
                triggerServerEvent("onPlayerStartFactory", resourceRoot, localPlayer, {
                    drug = instance.slots[instance.select][8],
                    amount = amount
                })
            end
        end
    end
end

function toggle ( state )
    if state and not instance.visible then 
        instance.visible = true 
        instance.select = 1;

        showChat(false)
        showCursor(true)

        execAnimation('alpha', 0, 255, 400, 'Linear')
        render()
        addEventHandler('onClientClick', root, onPlayerClick)

    elseif not state and instance.visible then 

        showChat(true)
        showCursor(false)

        execAnimation('alpha', 255, 0, 400, 'Linear')
        removeEventHandler('onClientClick', root, onPlayerClick)

        setTimer(function()
            instance.visible = false 
        end, 400, 1)
    end
end

addEventHandler('onClientResourceStart', resourceRoot, function ( )
    createAnimation('alpha', 0, 255, 400, 'Linear')
end)

createEvent("onPlayerControllerInterface", resourceRoot, function (action)
    toggle(action == 'remove' and false or action == 'add' and true)
end)