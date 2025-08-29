local instance = {}
local position = Vector2((screen.x - 1068 * scale) / 2, (screen.y - 707 * scale) / 2)

local svgs = {
    ['line-factory'] = svgCreate(322, 560, [[
        <svg width="322" height="560" viewBox="0 0 322 560" fill="none" xmlns="http://www.w3.org/2000/svg">
            <rect x="0.5" y="0.5" width="321" height="559" rx="17.5" stroke="white"/>
        </svg>
    ]]);

    ['slot-line'] = svgCreate(121, 119, [[
      <svg width="121" height="119" viewBox="0 0 121 119" fill="none" xmlns="http://www.w3.org/2000/svg">
            <rect x="0.75" y="0.75" width="119.5" height="117.5" rx="3.25" stroke="white" stroke-width="1.5"/>
       </svg>
    ]])

}

function draw ( )
    getCursorPosition ()
    
    y = animation.get('moviment')
    local alpha = animation.get('alpha')

    instance.buttons = {}

    dxDrawImage(position.x, y, 1068 * scale, 707 * scale, 'assets/images/background.png', 0, 0, 0, tocolor(13, 14, 18, 0.98 * alpha))
    dxDrawImage(position.x + 58 * scale, y + 26 * scale, 36 * scale, 36 * scale, 'assets/images/icon-hammer.png', 0, 0, 0, tocolor(212, 214, 225, alpha))

    dxDrawText('FABRICAÇÃO', position.x + 112 * scale, y + 31 * scale, 0, 0, tocolor(212, 214, 225, alpha), 1, exports['guetto_assets']:dxCreateFont('regular', 18), 'left', 'top')

    dxSetBlendMode('add')
        dxDrawImage(position.x + 44 * scale, y + 90 * scale, 322 * scale, 560 * scale, svgs['line-factory'], 0, 0, 0, tocolor(48, 50, 56, alpha))
    dxSetBlendMode('blend')

    dxDrawText('Fabricação', position.x + 120 * scale, y + 101 * scale, 159 * scale, 26 * scale, tocolor(212, 214, 225, alpha), 1, exports['guetto_assets']:dxCreateFont('medium', 15), 'center', 'top')

    if instance.data and type(instance.data) == 'table' then 
        local offSetY = y + 170 * scale

        for index, value in ipairs (instance.data.factory) do 
            local color = tocolor(156, 156, 156, alpha)

            if isCursorOnElement(position.x + 111 * scale, offSetY, 105 * scale, 26 * scale) then 
                color = tocolor(243, 182, 125, fade)
            elseif instance.select == index then 
                color = tocolor(243, 182, 125, fade)
            end

            dxDrawImage(position.x + 76 * scale, offSetY, 24 * scale, 24 * scale, 'assets/images/icon-craft.png', 0, 0, 0, color )
            dxDrawText(value, position.x + 111 * scale, offSetY, 105 * scale, 26 * scale, color, 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'left', 'center')
        
            instance.buttons['button:itens:'..index] = {position.x + 111 * scale, offSetY, 105 * scale, 26 * scale}
            offSetY = offSetY + 26 * scale + 19 * scale
        end
    end

    dxDrawImage(position.x + 406 * scale, y + 173 * scale, 621 * scale, 259 * scale, 'assets/images/line.png', 0, 0, 0, tocolor(255, 255, 255, alpha))
    dxDrawText('Itens necessários', position.x + 407 * scale, y + 396 * scale, 122 * scale, 26 * scale, tocolor(156, 156, 156, alpha), 1, exports['guetto_assets']:dxCreateFont('regular', 16), 'left', 'top')
   
    dxDrawImage(position.x + 407 * scale, y + 573 * scale, 301 * scale, 55 * scale, 'assets/images/rectangle-qnt.png', 0, 0, 0, tocolor(23, 24, 30, alpha))
    dxDrawImage(position.x + 407 * scale, y + 573 * scale, 301 * scale, 55 * scale, 'assets/images/rectangle-stroke.png', 0, 0, 0, tocolor(60, 61, 67, alpha))
    
    dxDrawImage(position.x + 726 * scale, y + 573 * scale, 301 * scale, 55 * scale, 'assets/images/rectangle-qnt.png', 0, 0, 0, isCursorOnElement(position.x + 726 * scale, y + 573 * scale, 301 * scale, 55 * scale) and button.exec('qnt', 500, 32, 34, 43, alpha, alpha) or button.exec('qnt', 500, 23,  24, 30, alpha, alpha))
    dxDrawText('FABRICAR', position.x + 726 * scale, y + 575 * scale, 301 * scale, 55 * scale, tocolor(212, 214, 225, 0.32 * alpha), 1, exports['guetto_assets']:dxCreateFont('regular', 16), 'center', 'center')
   
    instance.buttons['button:factory'] = {position.x + 726 * scale, y + 573 * scale, 301 * scale, 55 * scale}

    dxCreateEditbox("EditBox:Amount", {position.x + 407 * scale, y + 575 * scale, 301 * scale, 55 * scale}, 4, {212, 214, 225, 0.32 * alpha}, exports['guetto_assets']:dxCreateFont('regular', 16), 'Quantidade', true, false, true, false, false)
    local editbox = dxEditboxGetText("EditBox:Amount").content == "" and 1 or dxEditboxGetText("EditBox:Amount").content;

    if instance.select and instance.select ~= 0 then 
        if instance.data.factory[instance.select] then 
            dxDrawText(instance.data.factory[instance.select], position.x + 406 * scale, y + 92 * scale, 190 * scale, 26 * scale, tocolor(212, 214, 225, alpha), 1, exports['guetto_assets']:dxCreateFont('medium', 20), 'left', 'top')
            dxDrawText(config.labels[instance.data.factory[instance.select]].description, position.x + 406 * scale, y + 122 * scale, 621 * scale, 26 * scale, tocolor(89, 89, 89, alpha), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'left', 'top', false, true, false)
        end

        local x = position.x + 406 * scale
        for index = 1,5 do 
            local value = config.factory[instance.data.factory[instance.select]][index]
            
            if not (instance.animations[index]) then 
                instance.animations[index] = animation.new(index, y, y + 433 * scale, 100, 'OutQuad', false)
            end
            
            local current = animation.get(index)
            local targetY = isCursorOnElement(x, current, 121 * scale, 119 * scale) and y + 425 * scale or y + 433 * scale
         
            animation.exec(index, current, targetY, 100, 'OutQuad')
            
            if (value) then 
                local settings = exports['guetto_inventory']:getConfigItem(value.item)
                local amount = exports['guetto_inventory']:getClientItem(value.item)
                
                dxDrawImage(x, current, 121 * scale, 119 * scale, 'assets/images/slot.png', 0, 0, 0, tocolor(255, 255, 255, alpha))

                dxDrawText(amount..'/'..value.amount * tonumber(editbox), x + 65 * scale, current + 94 * scale, 44 * scale, 26 * scale, amount >= value.amount and tocolor(172, 205, 132, alpha) or tocolor(205, 132, 132, alpha), 1, exports['guetto_assets']:dxCreateFont('regular', 13), 'right', 'top', false, false, true)
                dxDrawImage(x + 121 * scale / 2 - 66 * scale / 2, current + 119 * scale / 2 - 66 * scale / 2, 66 * scale, 66 * scale, ':guetto_inventory/assets/itens/'..(value.item)..'.png', 0, 0, 0, tocolor(255, 255, 255, alpha))
                
                if isCursorOnElement(x, current, 121 * scale, 119 * scale) then 
                    local cx, cy = getCursorPosition()

                    dxSetBlendMode('add')
                    dxDrawImage(x, current, 121 * scale, 119 * scale, svgs['slot-line'], 0, 0, 0, tocolor(243, 182, 125, alpha))
                    dxSetBlendMode('blend')

                    --dxDrawText(settings.item, cx + 20 * scale, cy - 20 * scale, 44 * scale, 26 * scale, tocolor(255, 255, 255, alpha), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'left', 'top', false, false, true)
                end

            else
                dxDrawImage(x, current, 121 * scale, 119 * scale, 'assets/images/slot-info.png', 0, 0, 0, tocolor(255, 255, 255, alpha))
            end
           
            instance.buttons['button:craft:'..index] = {x, current, 121 * scale, 119 * scale}

            x = x + 121 * scale + 4 * scale
        end

        if instance.select_item and instance.select_item ~= 0 then 
            dxDrawImage(position.x + 640 * scale, y + 215 * scale, 151 * scale, 151 * scale, ':guetto_inventory/assets/itens/'..config.itens[instance.data.factory[instance.select]]..'.png', 0, 0, 0, tocolor(255, 255, 255, alpha))
        end

    end

    if not instance.visible and alpha <= 0 then 
        removeEventHandler('onClientRender', root, draw) 
        showChat(true)
        showCursor(false)
    end

end


local function onPlayerClick (button, state)
    if button == 'left' then 
        if state == 'down' then 
            instance.separate = false;
            for i, v in pairs (instance.buttons) do 
                if isCursorOnElement(unpack(v)) then 
                    instance.separate = i;
                    break
                end
            end
        elseif state == 'up' then 
            if instance.separate then 
                local separate = split(instance.separate, ':')
                instance.separate = false;
                if separate[1] == 'button' then 
                    if separate[2] == 'itens' then 
                        instance.select = tonumber(separate[3])
                        instance.select_item = tonumber(separate[3]);
                    elseif separate[2] == 'factory' then 
                        local editbox = dxEditboxGetText("EditBox:Amount").content == "" and 1 or dxEditboxGetText("EditBox:Amount").content;
                        instance.resource = getResourceDynamicElementRoot(getResourceFromName(getResourceName(getThisResource())))

                        triggerServerEvent("onPlayerStartCraft", instance.resource, {
                            item = instance.data.factory[instance.select],
                            amount = editbox
                        })
                    end
                end
            end
        end
    end
end

local function toggle (state)
    if state and not instance.visible then 
        instance.visible = true;
        instance.select = 1;

        instance.buttons = false;
        instance.select_item = 0;

        animation.exec('alpha', 0, 255, 500, 'Linear')
        animation.exec('moviment', 0, position.y, 500, 'OutQuad')

        instance.select_item = 1;

        showCursor(true)
        showChat(false)

        addEventHandler('onClientRender', root, draw)
        addEventHandler('onClientClick', root, onPlayerClick)
    else
        instance.visible = false;

        animation.exec('alpha', 255, 0, 500, 'Linear')
        animation.exec('moviment', position.y, 0, 500, 'OutQuad')

        dxEditboxDestroy("EditBox:Amount")
        removeEventHandler('onClientClick', root, onPlayerClick)
    end
end

addEventHandler('onClientResourceStart', resourceRoot, function ( )
    instance.moviment = animation.new('moviment', 0, position.y, 500, 'OutQuad', false)
    instance.alpha = animation.new('alpha', 0, 255, 500, 'OutQuad', false)
    instance.animations = {}
end)

createEventHandler('onPlayerToggleCraft', resourceRoot, function (data)
    instance.data = data;
    toggle(not instance.visible and true)
end)

createEventHandler('onPlayerShowCraft', resourceRoot, function()
    toggle(false)
end)



bindKey('backspace', 'down', function ( )
    if not (isEdtiSelected("EditBox:Amount")) then 
        if instance.visible then 
            toggle(false)
        end
    end
end)