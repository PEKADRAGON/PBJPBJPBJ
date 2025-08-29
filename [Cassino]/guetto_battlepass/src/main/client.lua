local instance = {}
local maxProgressWidth = 1247 

instance.animations = {}
instance.animations.move = {}

instance.slots = {
    ['standart'] = {
        {75, 302, 244, 262},
        {325, 302, 244, 262},
        {575, 302, 244, 262},
        {826, 302, 244, 262},
        {1077, 302, 244, 262},
    },

    ['premium'] = {
        {75, 660, 244, 262},
        {325, 660, 244, 262},
        {575, 660, 244, 262},
        {826, 660, 244, 262},
        {1077, 660, 244, 262},
    },
}

instance.leveis = {
    ['standart'] = {
        {162, 587, 70, 40};
        {412, 587, 70, 40};
        {663, 587, 70, 40};
        {914, 587, 70, 40};
        {1165, 587, 70, 40};
    };
    ['premium'] = {
        {162, 982, 70, 40};
        {412, 982, 70, 40};
        {663, 982, 70, 40};
        {914, 982, 70, 40};
        {1165, 982, 70, 40};
    };
}

instance.scroll = {
    ['standart'] = 0;
    ['premium'] = 0;
}

function isClientCollectedItem (type, index)
    for i, v in pairs (instance.data.data[type]) do 
        if v == index then 
            return true, i 
        end
    end
    return false
end 

function draw()
    instance.buttons = {}

    local fade = animation.get('alpha')

    local arrow_right = interpolateBetween(1376, 0, 0, 1387, 0, 0, (getTickCount() - instance.tick) / 1000, 'SineCurve')
    local arrow_left = interpolateBetween(21, 0, 0, 11, 0, 0, (getTickCount() - instance.tick) / 1000, 'SineCurve')

    dxDrawImage(0, 0, 1920, 1080, 'assets/images/background.png', 0, 0, 0, tocolor(255, 255, 255, fade))
    dxDrawImage(0, 0, 1920, 1080, 'assets/images/effect.png', 0, 0, 0, tocolor(255, 255, 255, fade))

    dxDrawText("Prepare-se para mergulhar nas profundezas sombrias da cidade e competir pelo controle do submundo com o Passe de Batalha: Gangster's Streets. Dominar esse ambiente exigirá não apenas habilidades de combate, mas também astúcia e estratégia para sobreviver e prosperar nas ruas impiedosas da metrópole. Ganhe itens exclusivos, desbloqueie novas skins e muito mais.", 75, 125, 797, 135, tocolor(199, 199, 199, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 18), 'left', 'top', false, true)

    dxDrawRoundedRectangle(1011, 143, 311, 83, isCursorOnElement(1011, 143, 311, 83) and tocolor(193, 159, 114, 0.25 * fade) or tocolor(235, 235, 235, 0.10 * fade), 3)
    dxDrawText("COMPRAR", 1011, 145, 311, 83, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 20), 'center', 'center')

    dxDrawImage(1399, 143, 438, 825, 'assets/images/banner.png', 0, 0, 0, tocolor(255, 255, 255, fade))

    local slotIndex = 1

    dxDrawImage(arrow_right, 409, 32, 36, 'assets/images/arrow.png', 0, 0, 0, isCursorOnElement(arrow_right, 409, 32, 36) and tocolor(193, 159, 114, fade) or tocolor(217, 217, 217, fade))
    dxDrawImage(arrow_right, 767, 32, 36, 'assets/images/arrow.png', 0, 0, 0, isCursorOnElement(arrow_right, 767, 32, 36) and tocolor(193, 159, 114, fade) or tocolor(217, 217, 217, fade))

    if instance.scroll['standart'] > 0 then
        dxDrawImage(arrow_left, 409, 32, 36, 'assets/images/arrow.png', 180, 0, 0, isCursorOnElement(arrow_left, 409, 32, 36) and tocolor(193, 159, 114, fade) or tocolor(217, 217, 217, fade))
        instance.buttons['button:arrow-left:standart'] = {arrow_left, 409, 32, 36}
    end

    if instance.scroll['premium'] > 0 then
        dxDrawImage(arrow_left, 767, 32, 36, 'assets/images/arrow.png', 180, 0, 0, isCursorOnElement(arrow_left, 767, 32, 36) and tocolor(193, 159, 114, fade) or tocolor(217, 217, 217, fade))
        instance.buttons['button:arrow-left:premium'] = {arrow_left, 767, 32, 36}
    end

    instance.buttons['button:arrow-right:standart'] = {arrow_right, 409, 32, 36}
    instance.buttons['button:arrow-right:premium'] = {arrow_right, 767, 32, 36}
    instance.buttons['button:modal'] = {1011, 143, 311, 83}

    local level = (getElementData(localPlayer, config['others'].level) or 0)

    dxDrawImage(75, 600, 1247, 14, 'assets/images/rectangle-progress.png', 0, 0, 0, tocolor(255, 255, 255, fade))
    dxDrawImage(75, 995, 1247, 14, 'assets/images/rectangle-progress.png', 0, 0, 0, tocolor(255, 255, 255, fade))
    
    for index, value in ipairs(config.types) do
        if instance.leveis[value] then
            for i = 1, #instance.leveis[value] do
                local data = instance.leveis[value][i]
                local target = config.levels[value] * (i + instance.scroll[value])

                local progressWidth = math.max(0, (level / target) * maxProgressWidth - 70)

                if progressWidth > maxProgressWidth then
                    progressWidth = maxProgressWidth
                end

                local color
                if level >= target then
                    color = tocolor(193, 159, 114, fade)
                else
                    color = tocolor(84, 84, 84, fade)
                end

                instance.level = instance.level or {}
                instance.level[value] = progressWidth

                dxDrawImage(data[1], data[2], data[3], data[4], 'assets/images/rectangle-level.png', 0, 0, 0, color)
                if not instance.modal then 
                    dxDrawText(target, data[1], data[2], data[3], data[4], tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 20), 'center', 'center', false, false, true)
                end
            end
        end
    end
    
    for _, v in ipairs(config.types) do
        if instance.slots[v] then
            for i = 1, 5 do
                local x, y, w, h = instance.slots[v][i][1], instance.slots[v][i][2], instance.slots[v][i][3], instance.slots[v][i][4]
                local data = config['itens'][v][i + instance.scroll[v]]

                if data then
                    
                    if not instance.animations.move[slotIndex] then
                        instance.animations.move[slotIndex] = animation.new(slotIndex, y, y, 100, 'OutQuad', false)
                    end

                    local current = animation.get(slotIndex)
                    local targetY = v == 'premium' and instance.data.premium == 'nil' and y or isClientCollectedItem(v, i + instance.scroll[v]) and y or isCursorOnElement(x, y, w, h) and y - 3 or y

                    animation.exec(slotIndex, current, targetY, 100, 'OutQuad')
                    dxDrawImage(x, current, w, h, 'assets/images/slot.png', 0, 0, 0, tocolor(255, 255, 255, fade))
                    
                    if v == 'premium' and instance.data.premium == 'nil' then
                        dxDrawImage(x + w / 2 - 86 / 2, y + h / 2 - 86 / 2, 86, 86, 'assets/images/icon-lock.png', 0, 0, 0, tocolor(255, 255, 255, fade))
                        dxDrawImage(x + w / 2 - 124 / 2, current + h / 2 - 108 / 2, 124, 108, 'assets/itens/'..(v)..'.png', 0, 0, 0, tocolor(255, 255, 255, 0.14 * fade))
                    else
                        if isClientCollectedItem(v, i + instance.scroll[v]) then 
                            dxDrawImage(x, current, w, h, 'assets/images/blur.png', 0, 0, 0, tocolor(255, 255, 255, fade))
                            dxDrawImage(x + w / 2 - 124 / 2, current + h / 2 - 108 / 2, 124, 108, 'assets/itens/'..(v)..'.png', 0, 0, 0, tocolor(255, 255, 255, 0.14 * fade))
                            dxDrawText("COLETADO", x, current, w, h, tocolor(172, 205, 132, fade), 1, exports['guetto_assets']:dxCreateFont('bold', 20), 'center', 'center')
                        else
                            dxDrawImage(x + w / 2 - 124 / 2, current + h / 2 - 108 / 2, 124, 108, 'assets/itens/'..(v)..'.png', 0, 0, 0, tocolor(255, 255, 255, fade))
                        end
                    end

                    dxDrawText(data.item, x, current + 32, w, 30, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 18), 'center', 'top')

                    if isCursorOnElement(x, y, w, h) then
                        if v == 'premium' and instance.data.premium == 'nil' then
                        else
                            dxDrawImage(x, current, w, h, 'assets/images/line.png', 0, 0, 0, tocolor(193, 159, 114, fade))
                        end
                    end

                    instance.buttons['button:items:'..v..':'..i + instance.scroll[v]] = {x, current, w, h}
                    slotIndex = slotIndex + 1
                end
            end
        end
    end

    if instance.level then
        dxDrawRectangle(80, 605, instance.level['standart'], 4, tocolor(193, 159, 114, fade))
        dxDrawRectangle(80, 1000, instance.level['premium'], 4, tocolor(193, 159, 114, fade))
    end

    dxDrawText("Faltam", 1520, 172, 182, 63, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('uni-regular', 61), 'center', 'top')
    dxDrawText(instance.days, 1399 + 150, 268, 125, 63, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('medium', 60), 'center', 'top')
    dxDrawText("Dias", 1520, 368, 182, 63, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('uni-regular', 50), 'center', 'top')
    
    if instance.scroll['standart'] <= 0 then
        dxDrawImage(31, 329, 31, 194, 'assets/images/standart-pass.png', 0, 0, 0, tocolor(255, 255, 255, fade))
    end

    if instance.scroll['premium'] <= 0 then
        dxDrawImage(31, 685, 26, 221, 'assets/images/premium-pass.png', 0, 0, 0, tocolor(255, 255, 255, fade))
    end

    local modal = animation.get('modal');
    if instance.modal then 
        local y = animation.get('modal-move');
        dxDrawImage(0, 0, 1920, 1080, 'assets/images/rectangle-blur.png', 0, 0, 0, tocolor(255, 255, 255, modal))
        dxDrawImage(544, y, 832, 454, 'assets/images/modal-background.png', 0, 0, 0, tocolor(255, 255, 255, fade))

        dxDrawText('Passe Premium', 759, y + 42, 380, 63, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('uni-regular', 30), 'center', 'center')
        dxDrawText('Você deseja adquirir nosso passe premium, saiba que depois da confirmação não haverá reembolso dos Guetto points gastos.', 637, y + 130, 647, 104, tocolor(89, 89, 89, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 19), 'center', 'center', false, true)

        dxDrawImage(901, y + 262, 43, 43, 'assets/images/icon-fire.png', 0, 0, 0, tocolor(255, 255, 255, fade))
        dxDrawText(config.others.price, 944, y + 250, 62, 68, tocolor(193, 159, 114, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 25), 'center', 'center')
 
        dxDrawText('COMPRAR', 864, y + 358, 193, 36, isCursorOnElement(864, y + 358, 193, 36) and tocolor(193, 159, 114, fade) or tocolor(217, 217, 217, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 20), 'center', 'center')
        instance.buttons['button:buy'] = {864, y + 358, 193, 36}
    end
    
    if not instance.visible and fade <= 0 then
        removeEventHandler('onClientRender', root, draw)
    end

end

function onPlayerClick ( button, state )
    if button == 'left' then 
        if state == 'down' then 
            instance.select = false;
            for i, v in pairs ( instance.buttons ) do 
                if isCursorOnElement(unpack(v)) then 
                    instance.select = i
                    break 
                end
            end
        elseif state == 'up' then 
            if instance.select then 
                local separate = split(instance.select, ':')
                instance.select = false; 
                if separate[1] == 'button' then 
                    if separate[2] == 'arrow-right' and not instance.modal then 
                        local settings = config.itens[separate[3]]
                        if ( (instance.scroll[separate[3]] +5) < #settings ) then 
                            instance.scroll[separate[3]] = instance.scroll[separate[3]] + 1
                        end
                    elseif separate[2] == 'arrow-left' and not instance.modal then 
                        local settings = config.itens[separate[3]]
                        if ( (instance.scroll[separate[3]] >= 0) ) then 
                            instance.scroll[separate[3]] = instance.scroll[separate[3]] - 1
                        end
                    elseif separate[2] == 'items' and not instance.modal then 
                        if instance.delay and getTickCount ( ) - instance.delay <= 1000 then 
                            return false 
                        end

                        triggerServerEvent(
                            "onPlayerCollectedItems",
                            resourceRoot, 
                            separate
                        )

                        instance.delay = getTickCount()
                    elseif separate[2] == 'modal' and not instance.modal then 
                        animation.exec('modal', 0, 255, 400, 'OutQuad')
                        animation.exec('modal-move', 454, 331, 400, 'OutQuad')
                        instance.modal = true
                    elseif separate[2] == 'buy' and instance.modal then 
                        triggerServerEvent(
                            "onPlayerBuyBattlePass",
                            resourceRoot
                        )
                    end
                end
            end
        end
    end
end;

function toggle (state)

   
    if animation.isRunning('alpha') then 
        return false;
    end
    
    if not instance.visible and state then 
        instance.visible = true;
        instance.tick = getTickCount();

        instance.buttons = false;
        instance.level = {}

        instance.modal = false;

        showCursor(true)
        showChat(false)

        animation.exec('alpha', 0, 255, 400, 'OutQuad')
        triggerServerEvent("onPlayerGetInfos", resourceRoot)
        addEventHandler('onClientRender', root, draw)
        addEventHandler('onClientClick', root, onPlayerClick)
    elseif instance.visible and not state then 
        instance.visible = false;

        showCursor(false)
        showChat(true)

        animation.exec('alpha', 255, 0, 400, 'OutQuad')
        removeEventHandler('onClientClick', root, onPlayerClick)
    end
end

createEventHandler("onPlayerToggleInterface", resourceRoot, function (data, days)
    instance.data = data;
    instance.days = days;
end)

createEventHandler("onClientUpdateInfos", resourceRoot, function (data)
    instance.data = data;

    if instance.modal and instance.modal then 
        animation.exec('modal', 255, 0, 400, 'OutQuad')
        animation.exec('modal-move', 331, 1080, 400, 'OutQuad')
        setTimer(function()
            instance.modal = false
        end, 400, 1)
    end
end)

addEventHandler('onClientKey', root, function (button, state)
    if button == 'backspace' and state then 
        if instance.modal and instance.modal then 
            animation.exec('modal', 255, 0, 400, 'OutQuad')
            animation.exec('modal-move', 331, 1080, 400, 'OutQuad')
            setTimer(function()
                instance.modal = false
            end, 400, 1)
        end
    elseif button == string.upper(config.others.key) and state then 
        toggle(not instance.visible and true or false)
    end
end)

addEventHandler('onClientResourceStart', resourceRoot, function ( )
    instance.animations.alpha = animation.new('alpha', 0, 255, 400, 'OutQuad', false);
    instance.animations.modal = animation.new('modal', 0, 0, 400, 'OutQuad', false);
    instance.animations['modal-move'] = animation.new('modal-move', 0, 0, 400, 'OutQuad', false);
    triggerServerEvent("onPlayerGetInfos", resourceRoot)
end)
