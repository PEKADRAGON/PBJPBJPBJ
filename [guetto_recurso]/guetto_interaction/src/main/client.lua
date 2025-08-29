local interaction = {}

interaction.panel = {}
interaction.panel.animations = {}
interaction.panel.isEventHandlerAdded = false 
interaction.panel.song = false

instance = {}

position = Vector2(middle.x + 187 * scale, middle.y)

function draw()
    getCursorPosition()

    local x = animation.get('moviment')
    local alpha = animation.get('alpha')

    interaction.panel.buttons = {}

    dxDrawImage(x, position.y, 187 * scale, 39 * scale, 'images/rectangle.png', 0, 0, 0, tocolor(13, 14, 18, 0.60 * alpha))

    local y = position.y + 42 * scale
    local sound = false 

    for index = 1, 4 do 
        local value = false ;

        if instance.element_type == 'vehicle' then 
            value = config.interaction[instance.element_type][interaction.panel.window][index + interaction.panel.scroll]
        elseif instance.element_type == 'player' then 
            value = config.interaction[instance.element_type][interaction.panel.window][index + interaction.panel.scroll]
        elseif instance.element_type == 'object' then 
            value = config.interaction[instance.element_type][interaction.panel.window][index + interaction.panel.scroll]
        end
        
        if value then 
            if not interaction.panel.animations[interaction.panel.window] then
                interaction.panel.animations[interaction.panel.window] = {}
            end
    
            if not interaction.panel.animations[interaction.panel.window][index + interaction.panel.scroll] then
                interaction.panel.animations[interaction.panel.window][index + interaction.panel.scroll] = animation.new(value.name, x, x, 100, 'OutQuad', false)
            end

            local currentX = animation.get(value.name)
            local targetX = isCursorOnElement(currentX, y, 187 * scale, 39 * scale) and x + 8 or x

            animation.exec(value.name, animation.get(value.name), targetX, 100, 'OutQuad')

            dxDrawImage(currentX, y, 187 * scale, 39 * scale, 'images/rectangle.png', 0, 0, 0, isCursorOnElement(currentX, y, 187 * scale, 39 * scale) and button.exec(value.name, 500, 13, 14, 18, 0.60 * alpha, alpha) or button.exec(value.name, 500, 13, 14, 18, 0.40 * alpha, alpha))
            dxDrawText(value.name, currentX + 17 * scale, y, 187 * scale, 39 * scale, tocolor(211, 211, 211, alpha), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'left', 'center')

            interaction.panel.buttons['button:interaction:'..index + interaction.panel.scroll] = {currentX, y, 187 * scale, 39 * scale}

            y = y + 39 * scale + 3 * scale
        end
    end

    if instance.element_type == 'player' then 
        local IconX = x + 8 * scale
        for i = 1, #interaction.panel.data do 
            local v = interaction.panel.data[i]
            local data = config.interactions_settings[v]
            if data then 
                dxDrawImage(IconX, position.y + (39 * scale) / 2 - (data.size[2] * scale) / 2, data.size[1] * scale, data.size[2] * scale, data.icon, 0, 0, 0, interaction.panel.window == v and button.exec(i, 500, 243, 182, 125, alpha, alpha) or isCursorOnElement(IconX, position.y + (39 * scale) / 2 - (data.size[2] * scale) / 2, data.size[1] * scale, data.size[2] * scale) and button.exec(i, 500, 243, 182, 125, alpha, alpha) or button.exec(i, 500, 212, 214, 225, alpha, alpha))
                interaction.panel.buttons['button:category:'..i] = {IconX, position.y + (39 * scale) / 2 - (data.size[2] * scale) / 2, data.size[1] * scale, data.size[2] * scale}
                IconX = IconX + (data.size[1] * scale) + 11
            end
        end
    elseif instance.element_type == 'vehicle' then 

    end

    if not interaction.panel.isEventHandlerAdded and alpha <= 0 then 
        removeEventHandler('onClientRender', root, draw)
        showCursor(false)
    end
end

function toggle(state)
    if state then 
        if not interaction.panel.isEventHandlerAdded then
            if animation.isRunning('alpha') then 
                return false 
            end

            interaction.panel.isEventHandlerAdded = true
            interaction.panel.scroll = 0;

            interaction.panel.buttons = false;

            animation.exec('moviment', position.x - (187 * scale), position.x, 500, 'OutQuad')
            animation.exec('alpha', 0, 255, 500, 'Linear')

            showCursor(true)

            playSound('sfx/hover.mp3')
            addEventHandler('onClientRender', root, draw)
        end
    else 
        if interaction.panel.isEventHandlerAdded then
            if animation.isRunning('alpha') then 
                return false 
            end

            interaction.panel.isEventHandlerAdded = false

            animation.exec('moviment', position.x, position.x - (187 * scale), 500, 'OutQuad')
            animation.exec('alpha', 255, 0, 500, 'Linear')

            playSound('sfx/hover.mp3')
        end
    end
end

createEventHandler("onPlayerToggleInteraction", resourceRoot, function(player, data, type_element)
    if not interaction.panel.isEventHandlerAdded then
        interaction.panel.data = data
        
        instance.element = player;
        instance.element_type = type_element
        
        if (instance.element_type == 'player') then 
            interaction.panel.window = 'player'
        elseif (instance.element_type == 'vehicle') then 
            interaction.panel.window = 'default'
        elseif  (instance.element_type == "object") then 
            interaction.panel.window = getElementModel(instance.element)
        end

        toggle(true)
    end
end)

createEventHandler("onPlayerStartSoundKiss", resourceRoot, function ( )
    
    if instance.kiss and isElement(instance.kiss) then 
        destroyElement(instance.kiss)
    end

    instance.kiss = playSound("sfx/kiss.mp3")
    setSoundVolume(instance.kiss, 0.5)
    
    setTimer ( function ( ) 
        if instance.kiss and isElement(instance.kiss) then 
            destroyElement(instance.kiss)
        end
    end, 11000, 1)
end)

addEventHandler('onClientClick', root, function(button, state)
    if button == 'left' then
        if interaction.panel.isEventHandlerAdded then 
            if state == 'down' then 
                for index, value in pairs ( interaction.panel.buttons ) do 
                    if isCursorOnElement(unpack(value)) then 
                        interaction.panel.select = index
                    end
                end

            elseif state == 'up' then 
                if interaction.panel.select then
                    
                    if isModalEnable() then 
                        return false
                    end;

                    local separate = split(interaction.panel.select, ':')
                    interaction.panel.select = false

                    if separate[1] == 'button' then 
                        
                        if separate[2] == 'category' then 

                            interaction.panel.window = interaction.panel.data[tonumber(separate[3])]
                            interaction.panel.scroll = 0

                        elseif separate[2] == 'interaction' then 
                            local value = false ;

                            if instance.element_type == 'vehicle' then 
                                value = config.interaction[instance.element_type][interaction.panel.window]
                            elseif instance.element_type == 'player' then 
                                value = config.interaction[instance.element_type][interaction.panel.window]
                            elseif instance.element_type == 'object' then
                                value = config.interaction[instance.element_type][interaction.panel.window]
                            end
                            
                            if (value) then 

                                if value[tonumber(separate[3])].name == 'Enviar dinheiro' then 
                                    toggleModal(true)
                                elseif value[tonumber(separate[3])].name == 'Enviar GP' then 
                                    toggleModal(true)
                                end

                                instance.modal = value[tonumber(separate[3])].name
                                instance.resource = getResourceDynamicElementRoot(getResourceFromName(getResourceName(getThisResource())))

                                triggerServerEvent("onPlayerExecuteInteraction", instance.resource, {
                                    index = tonumber(separate[3]);
                                    window = interaction.panel.window,
                                    element = instance.element,
                                    data = value
                                })

                                toggle(false)
                                playSound('sfx/click.mp3')
                            end
                        end
                    end
                end
            end
        end
    end
end)


function drawHood ( )
    local alpha = animation.get('hood-alpha')

    dxDrawRectangle(0, 0, 1920 * scale, 1080 * scale, tocolor(0, 0, 0, alpha))

    local width = dxGetTextWidth(instance.hood_message, 1, exports['guetto_assets']:dxCreateFont('regular', 20), false )
    dxDrawText(instance.hood_message, 1920 * scale / 2 - width, 0, width, 1080 * scale, tocolor(255, 255, 255, alpha), 1, exports['guetto_assets']:dxCreateFont('regular', 20), "center", "center" )

    if not instance.hood_visible and alpha <= 0 then 
        removeEventHandler('onClientRender', root, drawHood)
    end
end;

createEventHandler("onPlayerToggleHood", resourceRoot, function ( message )
    if not instance.hood then 
        instance.hood = animation.new('hood-alpha', 0, 255, 500, 'Linear', false)
    end

    if not instance.hood_visible then 
        instance.hood_visible = true 

        instance.hood_message = message;

        animation.exec('hood-alpha', 0, 255, 500, 'Linear')
        addEventHandler('onClientRender', root, drawHood)
    else
        instance.hood_visible = false 

        animation.exec('hood-alpha', 255, 0, 500, 'Linear')
    end
end)

addEventHandler('onClientKey', root, function(button, state)
    if interaction.panel.isEventHandlerAdded then 
        if button == 'mouse_wheel_up' and state then 
            if interaction.panel.scroll > 0 then 
                interaction.panel.scroll = interaction.panel.scroll - 1
            end
        elseif button == 'mouse_wheel_down' and state then 
            if interaction.panel.scroll >= 0 then 
                if interaction.panel.scroll + 4 < #config.interaction[instance.element_type][interaction.panel.window] then 
                    interaction.panel.scroll = interaction.panel.scroll + 1
                end
            end
        end
    end
end)

bindKey('backspace', 'down', function()
    if not (isModalEnable()) then 
        toggle(false)
    end
end)

addEventHandler('onClientResourceStart', resourceRoot, function()
    interaction.panel.moviment = animation.new('moviment', 0, 1000, 500, 'OutQuad', false)
    interaction.panel.alpha = animation.new('alpha', 0, 255, 500, 'Linear', false)
end)

