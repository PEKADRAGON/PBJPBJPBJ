local instance = {}

instance.pills = {
    {859, 573, 47, 146, 'Pilula Vermelha', 'core/assets/icons/red.png'};
    {1015, 573, 47, 146, 'Pilula Azul', 'core/assets/icons/blue.png'};
}

function render ( )
    CreateThread ( function ( )
        while (instance.visible) do
            local alpha = animation.get('alpha')

            -- Backgrounds
            dxDrawImage(0, 0, 1920, 1080, 'core/assets/fundos/background.png', 0, 0, 0, tocolor(255, 255, 255, alpha))
            dxDrawRectangle(0, 0, 1920, 1080, tocolor(19, 19, 20, 0.92 * alpha))

            if instance.window == 'inicial' then 

                dxDrawText("GUETTO CITY", 801, 133, 319, 50, tocolor(255, 255, 255, alpha), 1, exports["guetto_assets"]:dxCreateFont("bold", 50), "center", "center")
                dxDrawText("Seja bem-vindo (a) à nossa cidade!", (590), (150), (740), (144), tocolor(255, 255, 255, alpha), 1, exports["guetto_assets"]:dxCreateFont("regular", 15), "center", "center")
                dxDrawText("Estamos felizes em ter você conosco. Para começar sua jornada por aqui, oferecemos algumas opções iniciais que te ajudarão a explorar e conhecer melhor nossa cidade. Cada escolha vem com um benefício especial para facilitar sua adaptação e aproveitamento ao máximo do que temos a oferecer.", (590), (250), (740), (144), tocolor(143, 143, 143, alpha), 1, exports["guetto_assets"]:dxCreateFont("regular", 17), "center", "center", false, true)
                dxDrawText("A ESCOLHA É SUA", (819), (432), (282), (33), tocolor(255, 255, 255, alpha), 1, exports["guetto_assets"]:dxCreateFont("bold", 33), "center", "center")
    
                -- Pilulas
    
                for i, v in ipairs (instance.pills) do 
                    if not instance.animations[i] then 
                        instance.animations[i] = animation.new('pill:'..i, v[2], v[2], 200, 'OutQuad')
                    end;
    
                    local y = animation.get('pill:'..i);
    
                    if instance.select == i then 
                        dxDrawImage(v[1] - 100, y - 100, 250, 346, 'core/assets/icons/blur.png', 0, 0, 0, instance.pills[instance.select][5] == 'Pilula Vermelha' and tocolor(233, 72, 72, alpha) or tocolor(82, 141, 234, alpha))
                    end
    
                    if isCursorOnElement(v[1], y, v[3], v[4]) then 
                        animation.exec('pill:'..i, y, v[2] - 25, 200, 'OutQuad')
                        dxDrawImage(v[1] - 100, y - 100, 250, 346, 'core/assets/icons/blur.png', 0, 0, 0, v[5] == 'Pilula Vermelha' and tocolor(233, 72, 72, alpha) or tocolor(82, 141, 234, alpha))
                    else
                        animation.exec('pill:'..i, y, v[2], 200, 'OutQuad')
                    end
    
                    dxDrawImage(v[1], y, v[3], v[4], v[6], 0, 0, 0, tocolor(255, 255, 255, alpha))
                end
    
                --Buttons
    
                dxDrawImage(823, 887, 273, 59, 'core/assets/fundos/rectangle.png', 0, 0, 0, isCursorOnElement(823, 887, 273, 59) and tocolor(118, 118, 118, 0.19 * alpha) or tocolor(118, 118, 118, 0.12 * alpha))
                dxDrawText("CONFIRMAR ESCOLHA", 823, 887, 273, 59, tocolor(255, 255, 255, alpha), 1, exports["guetto_assets"]:dxCreateFont("medium", 15), "center", "center")
            
            elseif instance.window == "select-pill" then 
            
                dxDrawImage(935, 139, 50, 146, instance.pills[instance.select][6], 0, 0, 0, tocolor(255, 255, 255, alpha))
                dxDrawImage(935 - 100, 139 - 100, 250, 346, 'core/assets/icons/blur.png', 0, 0, 0, instance.pills[instance.select][5] == 'Pilula Vermelha' and tocolor(233, 72, 72, alpha) or tocolor(82, 141, 234, alpha))
                
                local pill = instance.pills[instance.select][5] == 'Pilula Vermelha' and 'Vermelha' or 'Azul'
                dxDrawText("Você escolheu a pílula "..pill, (590), (280), (740), (144), tocolor(255, 255, 255, alpha), 1, exports["guetto_assets"]:dxCreateFont("regular", 18), "center", "center")

                dxDrawText("Sua escolha determinou os itens que você recebe ao iniciar sua jornada em nossa cidade. Agora, você faz parte de um grupo seleto de pessoas que também optaram por esta mesma escolha. Em algum momento, a sua decisão revelará seu verdadeiro significado.", (590), (370), (740), (144), tocolor(143, 143, 143, alpha), 1, exports["guetto_assets"]:dxCreateFont("regular", 17), "center", "center", false, true)

                local x = 643;
                local width, height = 194, 226

                for index, value in ipairs (instance.data) do 

                    dxDrawImage(x, 540, width, height, 'core/assets/fundos/slot.png', 0, 0, 0, tocolor(255, 255, 255, alpha))
                    dxDrawImage(x, 540, width, height, 'core/assets/fundos/line.png', 0, 0, 0, tocolor(255, 255, 255, alpha))

                    dxDrawText(string.upper(value.title), x, 558, width, 15, tocolor(255, 255, 255, alpha), 1, exports["guetto_assets"]:dxCreateFont("medium", 15), "center", "top")
                    dxDrawText(string.upper(value.description), x, 724, width, 15, tocolor(255, 255, 255, alpha), 1, exports["guetto_assets"]:dxCreateFont("medium", 15), "center", "top")

                    dxDrawImage(x + width / 2 - value.size[1] / 2, 540 + height / 2 - value.size[2] / 2, value.size[1], value.size[2], value.icon, 0, 0, 0, tocolor(255, 255, 255, alpha))

                    x = x + width + 26
                end

                dxDrawImage(823, 887, 273, 59, 'core/assets/fundos/rectangle.png', 0, 0, 0, isCursorOnElement(823, 887, 273, 59) and tocolor(118, 118, 118, 0.19 * alpha) or tocolor(118, 118, 118, 0.12 * alpha))
                dxDrawText("CONFIRMAR JORNADA", 823, 887, 273, 59, tocolor(255, 255, 255, alpha), 1, exports["guetto_assets"]:dxCreateFont("medium", 15), "center", "center")

            end

            --Texts
          
            coroutine.yield()
        end
    end)
end

function onPlayerClick (button, state)
    if button == "left" and state == "down" then 
        if instance.window == 'inicial' then 
            for i, v in ipairs (instance.pills) do 
                local y = animation.get('pill:'..i);
                if isCursorOnElement(v[1], y, v[3], v[4]) then 
                    instance.select = i 
                    break
                end
            end
            if isCursorOnElement(823, 887, 273, 59) then 
                if instance.select ~= false then 
                    triggerServerEvent("onPlayerRequestPill", resourceRoot, localPlayer, instance.pills[instance.select][5])
                else
                    sendMessageClient("Selecione uma pílula!", "error")
                end
            end
        elseif instance.window == "select-pill" then 
            if isCursorOnElement(823, 887, 273, 59) then 
                if instance.data then 
                    triggerServerEvent("onPlayerRedeemPill", resourceRoot, localPlayer, instance.pills[instance.select][5])
                    toggle(false)
                else
                    sendMessageClient("Houve uma falha", "error")
                end
            end
        end
    end
end

function toggle (state)
    if state and not instance.visible then 
        instance.visible = true 
        instance.select = false;
        
        instance.window = "inicial"
        instance.animations = {}

        animation.exec('alpha', 0, 255, 400, 'Linear')

        showChat(false)
        showCursor(true)

        addEventHandler("onClientClick", root, onPlayerClick)
        render ()

    elseif not state and instance.visible then 
        
        showChat(true)
        showCursor(false)
        
        setTimer(function()
            instance.visible = false 
        end, 400, 1)

        removeEventHandler("onClientClick", root, onPlayerClick)
    end
end

addEventHandler('onClientResourceStart', resourceRoot, function ( )
    animation.new('alpha', 0, 255, 400, 'Linear')
end)

createEvent("onClientSendPill", resourceRoot, function (data)
    instance.window = 'select-pill'
    instance.data = data;
end)

createEvent("onClientDrawKit", resourceRoot, function ( )
    toggle(true)
end)

