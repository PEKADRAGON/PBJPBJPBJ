local screen = Vector2(guiGetScreenSize());
local x, y = (screen.x - respc(1015)) / 2, (screen.y - respc(626)) / 2
local instance = {}

local function createEvent ( event, ... )
    addEvent( event, true )
    addEventHandler(event, ...)
end

instance['slots-window'] = {
    {x = respc(603), y = respc(165), width = respc(53), height = respc(13), text = 'Luxuria'};
    {x = respc(681), y = respc(165), width = respc(71), height = respc(13), text = 'Criminoso'};
    {x = respc(777), y = respc(165), width = respc(71), height = respc(13), text = 'Visionário'};
    {x = respc(873), y = respc(165), width = respc(65), height = respc(13), text = 'Marginal de grife'};
}

instance['slots_items'] = {
    {x = respc(501), y = respc(276), width = respc(451), height = respc(39)};
    {x = respc(501), y = respc(319), width = respc(451), height = respc(39)};
    {x = respc(501), y = respc(362), width = respc(451), height = respc(39)};
    {x = respc(501), y = respc(405), width = respc(451), height = respc(39)};
}

instance['slots_vehicles'] = {
    {x = respc(501), y = respc(530), width = respc(451), height = respc(39)};
}

function render ( )
    CreateThread(function()
        while (instance.visible) do 
            local alpha = getAnimation('alpha')

            cursorUpdate()

            dxDrawRoundedRectangle('background', x, y, respc(1015), respc(626), tocolor(19, 19, 20, alpha), 4, false)
            dxDrawRoundedRectangle('background:main', x + respc(13), y + respc(45), respc(990), respc(561), tocolor(24, 24, 24, alpha), 4, false)
            
            dxDrawText('GUETTO RECURSOS', x + respc(21), y + respc(17), respc(138), respc(16), tocolor(159, 159, 159, alpha), 1, exports['guetto_assets']:dxCreateFont('bold', 15), 'left', 'top')

            dxDrawImage(x + respc(43), y + respc(58), respc(82), respc(68), 'core/assets/rectangle.png', 0, 0, 0, tocolor(67, 67, 67, alpha))
            dxDrawImage(x + respc(43), y + respc(58), respc(82), respc(68), 'core/assets/rectangle-stroke.png', 0, 0, 0, tocolor(105, 105, 105, alpha))

            dxDrawRoundedRectangle('navbar', x + respc(43), y + respc(141), respc(930), respc(60), tocolor(42, 42, 42, alpha), 2, false)
            dxDrawImage(x + respc(64), y + respc(156), respc(30), respc(30), images['icon-box'], 0, 0, 0, tocolor(255, 255, 255, alpha))

            for i, v in ipairs (instance['slots-window']) do 
                dxDrawText(v.text, x + v.x, y + v.y, v.width, v.height, instance.window == v['text'] and tocolor(193, 159, 114, alpha) or isCursorOnElement(x + v.x, y + v.y, v.width, v.height) and tocolor(193, 159, 114, alpha) or tocolor(159, 159, 159, alpha), 1, exports['guetto_assets']:dxCreateFont('medium', 13), 'center', 'center')
            end

            dxDrawImage(x + respc(60), y + respc(72), respc(48), respc(40), 'core/assets/icon-vip.png', 0, 0, 0, tocolor(255, 255, 255, alpha))
            
            dxDrawText('PULSEIRA | '..instance.window..'', x + respc(150), y + respc(64), respc(129), respc(13), tocolor(255, 255, 255, alpha), 1, exports['guetto_assets']:dxCreateFont('bold', 15), 'left', 'top')
            dxDrawText('Seja bem vindo(a), abaixo você pode ver todos os\nbeneficios dessa pulseira.', x + respc(150), y + respc(85), respc(396), respc(36), tocolor(143, 143, 143, alpha), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'left', 'top')
            
            dxDrawText('CATEGORIAS', x + respc(110), y + respc(165), respc(80), respc(13), tocolor(255, 255, 255, alpha), 1, exports['guetto_assets']:dxCreateFont('bold', 15), 'left', 'center')
            
            dxDrawRoundedRectangle('background:salario', x + respc(43), y + respc(209), respc(249), respc(159), tocolor(16, 16, 16, alpha), 4, false)
            dxDrawRoundedRectangle('background:bonus', x + respc(297), y + respc(209), respc(172), respc(159), tocolor(16, 16, 16, alpha), 4, false)
            dxDrawRoundedRectangle('background:pulseira-salario', x + respc(43), y + respc(376), respc(426), respc(215), tocolor(16, 16, 16, alpha), 4, false)
            dxDrawRoundedRectangle('background:recursos', x + respc(479), y + respc(209), respc(494), respc(44), tocolor(16, 16, 16, alpha), 4, false)
            dxDrawRoundedRectangle('background:grid', x + respc(479), y + respc(258), respc(494), respc(208), tocolor(16, 16, 16, alpha), 4, false)
            dxDrawRoundedRectangle('background:vehicle', x + respc(479), y + respc(476), respc(494), respc(115), tocolor(16, 16, 16, alpha), 4, false)

            dxDrawText('Recursos', x + respc(508), y + respc(224), respc(61), respc(15), tocolor(144, 144, 144, alpha), 1, exports['guetto_assets']:dxCreateFont('medium', 15), 'left', 'center')
            dxDrawImage(x + respc(938), y + respc(219), respc(24), respc(24), images['icon-info'], 0, 0, 0, tocolor(255, 255, 255, alpha))
          
            for i, v in ipairs(instance['slots_items']) do 
                if config['Vips'][instance.window]['Itens'][i + instance['ScrollItens']] then 
                    local data = config['Vips'][instance.window]['Itens'][i + instance['ScrollItens']]
                    dxDrawRoundedRectangle('rectangle:'..i + instance['ScrollItens'], x + v.x, y + v.y, v.width, v.height, isCursorOnElement(x + v.x, y + v.y, v.width, v.height) and tocolor(34, 34, 34, alpha) or tocolor(21, 21, 21, alpha), 2, false)
                    dxDrawText(data['Name'], x + v.x + respc(17), y + v.y, respc(89), v.height, tocolor(144, 144, 144, alpha), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'left', 'center')
                end
            end

            for i, v in ipairs(instance['slots_vehicles']) do 
                if config['Vips'][instance.window]['Veículos'][i + instance['ScrollVehicle']] then
                    local data = config['Vips'][instance.window]['Veículos'][i + instance['ScrollVehicle']]
                    dxDrawRoundedRectangle('rectangle:vehicles:'..i + instance['ScrollVehicle'], x + v.x, y + v.y, v.width, v.height, isCursorOnElement(x + v.x, y + v.y, v.width, v.height) and tocolor(34, 34, 34, alpha) or tocolor(21, 21, 21, alpha), 2, false)
                    dxDrawText(data['Name'], x + v.x + respc(17), y + v.y, respc(89), v.height, tocolor(144, 144, 144, alpha), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'left', 'center')
                end
            end 

            dxDrawText('Veículos exclusivos', x + respc(501), y + respc(496), respc(118), respc(15), tocolor(144, 144, 144, alpha), 1, exports['guetto_assets']:dxCreateFont('medium', 15), 'left', 'top')
            dxDrawImage(x + respc(938), y + respc(491), respc(24), respc(24), images['icon-info'], 0, 0, 0, tocolor(255, 255, 255, alpha))

            dxDrawRoundedRectangle('salario:bg', x + respc(70), y + respc(235), respc(40), respc(45), tocolor(40, 40, 40, alpha), 1, false)
            dxDrawRoundedRectangle('salario:vencimento', x + respc(70), y + respc(297), respc(40), respc(45), tocolor(40, 40, 40, alpha), 1, false)

            dxDrawText("Salário:", x + respc(121), y + respc(240), respc(49), respc(15), tocolor(144, 144, 144, alpha), 1, exports["guetto_assets"]:dxCreateFont("medium", 15), "left", "top")
            dxDrawText("Vencimento:", x + respc(121), y + respc(302), respc(49), respc(15), tocolor(144, 144, 144, alpha), 1, exports["guetto_assets"]:dxCreateFont("medium", 15), "left", "top")
            dxDrawText("Bonus na ativação:", x + respc(324), y + respc(285), respc(118), respc(18), tocolor(143, 143, 143, alpha), 1, exports["guetto_assets"]:dxCreateFont("medium", 15), "center", "center")
           
            dxDrawText("Salário da pulseira.", x + respc(61), y + respc(394), respc(122), respc(15), tocolor(144, 144, 144, alpha), 1, exports["guetto_assets"]:dxCreateFont("medium", 15), "left", "center")
            
            dxDrawImage(x + respc(61), y + respc(428), respc(36), respc(36), images['icon-alert'], 0, 0, 0, tocolor(255, 255, 255, alpha))
            dxDrawImage(x + respc(362), y + respc(228), respc(36), respc(36), images['icon-alert'], 0, 0, 0, tocolor(255, 255, 255, alpha))
            
            dxDrawText("Salário da pulseira.", x + respc(61), y + respc(394), respc(122), respc(15), tocolor(144, 144, 144, alpha), 1, exports["guetto_assets"]:dxCreateFont("medium", 15), "left", "center")
            dxDrawText('Resgate seu salario vip, mas aguarde o\ntempo, clique abaixo para resgatar.', x + respc(112), y + respc(426), respc(290), respc(40), tocolor(143, 143, 143, alpha), 1, exports['guetto_assets']:dxCreateFont('regular', 16), 'left', 'top')

            dxDrawText('X', x + respc(982), y + respc(12), respc(20), respc(20), isCursorOnElement(x + respc(982), y + respc(12), respc(20), respc(20)) and tocolor(253, 65, 77, alpha) or tocolor(109, 109, 109, alpha), 1, exports['guetto_assets']:dxCreateFont('regular', 16), 'left', 'top')

            dxDrawText(getPlayerVipRestant(localPlayer), x + respc(121), y + respc(323), respc(25), respc(15), tocolor(144, 144, 144, alpha), 1, exports["guetto_assets"]:dxCreateFont("medium", 15), "left", "top")
           
            dxDrawText("R$ "..formatNumber(config["Vips"][instance.window]["Salario"], "."), x + respc(121), y + respc(261), respc(82), respc(15), tocolor(144, 144, 144, alpha), 1, exports["guetto_assets"]:dxCreateFont("medium", 15), "left", "top")
            dxDrawText("R$ "..formatNumber(config["Vips"][instance.window]["Bonus_Ativação"], "."), x + respc(324), y + respc(308), respc(118), respc(18), tocolor(144, 144, 144, alpha), 1, exports["guetto_assets"]:dxCreateFont("regular", 15), "center", "center")

            dxDrawImage(x + respc(80), y + respc(245), respc(21), respc(26), 'core/assets/icon-money.png', 0, 0, 0, tocolor(255, 255, 255, alpha))
            dxDrawImage(x + respc(79), y + respc(309), respc(22), respc(22), 'core/assets/icon-data.png', 0, 0, 0, tocolor(255, 255, 255, alpha))


            local total_time = 20 * 60000
            local current_time = getTickCount() - instance['salary_cooldown']
            local remaining_time  = total_time - current_time

            local minutes = math.floor(remaining_time / 60000)
            local seconds = math.floor((remaining_time % 60000) / 1000)
            
            dxDrawRoundedRectangle('rectangle:time', x + respc(61), y + respc(512), respc(183), respc(51), tocolor(21, 21, 21, alpha), 4)
            dxDrawRoundedRectangle('rectangle:resgatar', x + respc(255), y + respc(512), respc(183), respc(51), isCursorOnElement(x + respc(255), y + respc(512), respc(183), respc(51)) and tocolor(42, 42, 42, alpha) or tocolor(21, 21, 21, alpha), 4)
            
            dxDrawImage(x + respc(80), y + respc(524), respc(28), respc(28), 'core/assets/icon-time.png', 0, 0, 0,  tocolor(232, 231, 231, alpha))
            dxDrawText('RESGATAR', x + respc(255), y + respc(512), respc(183), respc(51), tocolor(144, 144, 144, alpha), 1, exports['guetto_assets']:dxCreateFont('regular', 16), 'center', 'center')

            if (remaining_time <= 0) then 
                dxDrawText('00:00', x + respc(61), y + respc(512), respc(183), respc(51), tocolor(144, 144, 144, alpha), 1, exports['guetto_assets']:dxCreateFont('regular', 16), 'center', 'center')
            else
                dxDrawText(minutes..':'..seconds, x + respc(61), y + respc(512), respc(183), respc(51), tocolor(144, 144, 144, alpha), 1, exports['guetto_assets']:dxCreateFont('regular', 16), 'center', 'center')
            end

            coroutine.yield()
        end
    end)
end

function click (button, state)
    if (button == 'left' and state == 'down') then
        for i, v in ipairs (instance['slots-window']) do 
            if isCursorOnElement(x + v.x, y + v.y, v.width, v.height) then
                instance.window = v['text']
                break
            end
        end
        for i, v in ipairs(instance['slots_items']) do 
            if config['Vips'][instance.window]['Itens'][i] then 
                local data = config['Vips'][instance.window]['Itens'][i]
                if isCursorOnElement(x + v.x, y + v.y, v.width, v.height) then 

                    if not instance.vips[instance.window] then 
                        return sendMessageClient("Você não possui esse benéficio!", "error")
                    end

                    if not (instance['CoolDownItens']["Itens"]) then 
                        instance['CoolDownItens']["Itens"] = {}
                    end

                    if (instance['CoolDownItens']["Itens"][i] and getTickCount ( ) - instance['CoolDownItens']["Itens"][i] < config["Delay_Itens"]) then
                        return sendMessageClient("Aguarde "..math.floor((config["Delay_Itens"] / 1000 - (getTickCount ( ) - instance['CoolDownItens']["Itens"][i]) / 1000)).." segundos para reutilizar o item!", 'error')
                    end

                    local key = encrypt ()
                    local encode = teaEncode(data['Name'], key)

                    triggerServerEvent('onPlayerRedeemItem', resourceRoot, localPlayer, {
                        window = instance.window, 
                        key = key,
                        encode = encode,
                        index = i + instance['ScrollItens'],
                        category = 'Itens'
                    })

                    instance['CoolDownItens']["Itens"][i] = getTickCount()
                    break 
                end
            end
        end

        for i, v in ipairs(instance['slots_vehicles']) do 
            if config['Vips'][instance.window]['Veículos'][i] then
                local data = config['Vips'][instance.window]['Veículos'][i]
                if isCursorOnElement(x + v.x, y + v.y, v.width, v.height) then 
                    
                    if not instance.vips[instance.window] then 
                        return sendMessageClient("Você não possui esse benéficio!", "error")
                    end

                    if not (instance['CoolDownItens']["Veículos"]) then 
                        instance['CoolDownItens']["Veículos"] = {}
                    end

                    if instance['CoolDownItens']["Veículos"][i] and getTickCount() - instance['CoolDownItens']["Veículos"][i] < config["Delay_Itens"] then
                        local tempo_passado_ms = getTickCount() - instance['CoolDownItens']["Veículos"][i]
                        local cooldown_total_ms = config["Delay_Itens"] -- 10 minutos em milissegundos
                        local tempo_restante_s = (cooldown_total_ms - tempo_passado_ms) / 1000
                        if tempo_restante_s < 0 then
                            tempo_restante_s = 0
                        end
                    
                        local minutos = math.floor(tempo_restante_s / 60)
                        local segundos = math.floor(tempo_restante_s % 60)

                        return sendMessageClient(string.format("Aguarde %d minutos e %d segundos para reutilizar o item!", minutos, segundos), 'error')
                    end
                    

                    local key = encrypt ()
                    local encode = teaEncode(data['Name'], key)

                    triggerServerEvent('onPlayerRedeemVehicle', resourceRoot, localPlayer, {
                        window = instance.window, 
                        key = key,
                        encode = encode,
                        index = i + instance['ScrollVehicle'],
                        category = 'Veículos'
                    })

                    instance['CoolDownItens']["Veículos"][i] = getTickCount()
                end
            end
        end

        if isCursorOnElement(x + respc(982), y + respc(12), respc(20), respc(20)) then 
    
            toggle(false)
     
        elseif isCursorOnElement(x + respc(255), y + respc(512), respc(183), respc(51)) then 
     
            local total_time = 20 * 60000
            local current_time = getTickCount() - instance['salary_cooldown']

            if not instance.vips[instance.window] then 
                return sendMessageClient("Você não possui esse benéficio!", "error")
            end

            if (current_time < total_time) then
                return sendMessageClient("Aguarde o tempo para coletar seu salário novamente!", 'error')
            end

            local key = encrypt ()
            local encode = teaEncode('Salario', key)

            triggerServerEvent('onPlayerRedeemSalary', resourceRoot, localPlayer, {
                window = instance.window, 
                key = key,
                encode = encode,
                category = 'Vips'
            })

            instance['salary_cooldown'] = getTickCount()
        end
    end
end


function toggle (state)
    if (state and not instance.visible) then
        instance.visible = true
        
        if not (instance["CoolDownItens"]) then 
            instance["CoolDownItens"] = { }
        end

        if not (instance['salary_cooldown']) then 
            instance['salary_cooldown'] = 0 
        end

        instance['ScrollItens'] = 0;
        instance['ScrollVehicle'] = 0;

        instance.window = 'Luxuria'
        
        showChat(false)
        showCursor(true)

        execAnimation('alpha', 0, 255, 400, 'Linear')
        addEventHandler('onClientClick', root, click)

        render()
    elseif (not state and instance.visible) then
        
        showChat(true)
        showCursor(false)

        execAnimation('alpha', 255, 0, 400, 'Linear')
        
        setTimer(function()
            instance.visible = false
        end, 400, 1)

        removeEventHandler('onClientClick', root, click)
    end
end

addEventHandler('onClientResourceStart', resourceRoot, function ( )
    createAnimation('alpha', 0, 255, 400, 'Linear')
end)

bindKey(config["Key"], "down", function ()
    if not (instance.visible) then 
        triggerServerEvent("onPlayerRequestVips", resourceRoot, localPlayer)
    else
        toggle(false)
    end
end)

createEvent("onClientSendPlayerVips", resourceRoot, function ( vips )
    instance.vips = vips;
    toggle(not instance.visible and true or false)
end)

addEventHandler('onClientKey', root, function(button, state)
    if instance.visible then 
        if isCursorOnElement(x + respc(479), y + respc(258), respc(494), respc(208)) then 
            if button == 'mouse_wheel_down' and state then
                if instance['ScrollItens'] >= 0 and instance['ScrollItens'] + 4 < #config['Vips'][instance.window]['Itens'] then
                    instance['ScrollItens'] = instance['ScrollItens'] + 1
                end
            elseif button == 'mouse_wheel_up' and state then
                if instance['ScrollItens'] > 0 and instance['ScrollItens'] <= #config['Vips'][instance.window]['Itens'] then
                    instance['ScrollItens'] = instance['ScrollItens'] - 1
                end
            end
        elseif isCursorOnElement(x + respc(479), y + respc(476), respc(494), respc(115)) then 
            if button == 'mouse_wheel_down' and state then
                if instance['ScrollVehicle'] >= 0 and instance['ScrollVehicle'] + 1 < #config['Vips'][instance.window]['Veículos'] then
                    instance['ScrollVehicle'] = instance['ScrollVehicle'] + 1
                end
            elseif button == 'mouse_wheel_up' and state then
                if instance['ScrollVehicle'] > 0 and instance['ScrollVehicle'] <= #config['Vips'][instance.window]['Veículos'] then
                    instance['ScrollVehicle'] = instance['ScrollVehicle'] - 1
                end
            end
        end
    end
end)