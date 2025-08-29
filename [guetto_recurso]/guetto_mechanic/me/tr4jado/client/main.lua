core = {
    start = function()
        engineImportTXD(engineLoadTXD(package .. '/assets/models/1210.txd') , 1210)
        engineReplaceModel(engineLoadDFF(package .. '/assets/models/1210.dff'), 1210)

        repair.events.start()
        call.events.start()
        point.events.start()

        scroll.start()
    end
}

repair = {
    events = {
        start = function()
            registerEvent('repair:update', resourceRoot, repair.system.update)
        end
    },

    panel = {
        state = false,

        activeButton = false,
        buttons = {},

        vehicle = false,
        list = {},

        render = function()
            cursorUpdate()

            repair.panel.buttons = {}
            scroll.buttons = {}

            if not isElement(repair.panel.vehicle) then
                repair.panel.hide()
                return
            else
                local playerX, playerY, playerZ = getElementPosition(localPlayer)
                local vehicleX, vehicleY, vehicleZ = getElementPosition(repair.panel.vehicle)

                if getDistanceBetweenPoints3D(playerX, playerY, playerZ, vehicleX, vehicleY, vehicleZ) > 10 then
                    repair.panel.hide()
                    return
                end
            end

            local w, h = 495 * scale, 538 * scale
            local x, y = 38 * scale, (screen.y - h) / 2

            local fade = 1

            dxDrawRectangleRounded(x, y, w, h, 11, tocolor(65, 66, 77, 0.96 * fade))

            dxDrawImageBlend(x + 24 * scale, y + 29 * scale, 28 * scale, 28 * scale, icon['repair'], tocolor(255, 255, 255, fade))
            dxDrawText('Peças', x + 63 * scale, y + 31 * scale, 0, 0, tocolor(255, 255, 255, fade), 1, getFont('medium', 26))
            dxDrawText('Danificadas', x + 158 * scale, y + 32 * scale, 0, 0, tocolor(187, 187, 187, fade), 1, getFont('light', 24))

            scroll.draw('repair', screen.x, screen.y, 1, 1, 0x000000, 0x000000, 7, #repair.panel.list)
            scroll.buttons['scroll:repair'] = {x + 18 * scale, y + 78 * scale, 459 * scale, 422 * scale}

            for i = 1, 7 do
                local index = i + scroll.getValue('repair')
                local v = repair.panel.list[index]

                if v then
                    dxDrawRectangleRounded(x + 18 * scale, y + (78 + (61 * (i - 1))) * scale, 459 * scale, 56 * scale, 1, tocolor(87, 88, 100, 0.5 * fade))
                    dxDrawText(v.name, x + 44 * scale, y + (95 + (61 * (i - 1))) * scale, 0, 0, tocolor(255, 255, 255, 0.8 * fade), 1, getFont('medium', 24))
                    dxDrawText('Consertar', x + 449 * scale, y + (95 + (61 * (i - 1))) * scale, 0, 0, tocolor(255, 255, 255, 0.8 * fade), 1, getFont('light', 24), 'right')
                    repair.panel.buttons['repair:' .. index] = {x + 18 * scale, y + (78 + (61 * (i - 1))) * scale, 459 * scale, 56 * scale}
                end
            end
        end,

        click = function(button, state)
            if button == 'left' then
                if state == 'down' then
                    repair.panel.activeButton = false

                    for i, v in pairs(repair.panel.buttons) do
                        if isCursorInBox(unpack(v)) then
                            repair.panel.activeButton = i
                            break
                        end
                    end
                elseif state == 'up' then
                    if repair.panel.activeButton and isCursorInBox(unpack(repair.panel.buttons[repair.panel.activeButton])) then
                        local buttonDetails = split(repair.panel.activeButton, ':')

                        if buttonDetails[1] == 'repair' then
                            local _, anim = localPlayer:getAnimation()

                            if not (anim and anim == 'BOM_Plant') then
                                triggerServerEvent('repair:action', resourceRoot, repair.panel.vehicle, encode(repair.panel.list[tonumber(buttonDetails[2])]))
                            end
                        end
                    end
                end
            end
        end,

        show = function()
            if repair.panel.state then
                return
            end

            repair.panel.toggle(true)
        end,

        hide = function()
            if not repair.panel.state then
                return
            end

            repair.panel.toggle(false)
        end,

        toggle = function(state)
            if state then
                if not repair.panel.state then
                    createIcons()

                    addEventHandler('onClientRender', root, repair.panel.render)
                    addEventHandler('onClientClick', root, repair.panel.click)
                end
            else
                if repair.panel.state then
                    removeEventHandler('onClientRender', root, repair.panel.render)
                    removeEventHandler('onClientClick', root, repair.panel.click)
                end
            end

            repair.panel.state = state
        end
    },

    system = {
        update = function(vehicle)
            local cache = {}

            if vehicle:getHealth() < 1000 then
                cache[#cache + 1] = {
                    name = 'Motor',
                    type = 'engine'
                }
            end

            for i = 0, #DOORS do
                local v = DOORS[i]

                if v then
                    if vehicle:getDoorState(i) >= 2 then
                        cache[#cache + 1] = {
                            name = v,
                            type = 'door',
                            id = i
                        }
                    end
                end
            end

            for i = 0, #LIGHT do
                local v = LIGHT[i]

                if v then
                    if vehicle:getLightState(i) == 1 then
                        cache[#cache + 1] = {
                            name = v,
                            type = 'light',
                            id = i
                        }
                    end
                end
            end

            for i = 0, #PANELS do
                local v = PANELS[i]

                if v then
                    if vehicle:getPanelState(i) >= 1 then
                        cache[#cache + 1] = {
                            name = v,
                            type = 'panel',
                            id = i
                        }
                    end
                end
            end

            local tires = {vehicle:getWheelStates()}

            for i = 0, #tires do
                local v = tires[i]

                if v then
                    if v >= 1 then
                        cache[#cache + 1] = {
                            name = TIRE[i],
                            type = 'tire',
                            id = i
                        }
                    end
                end
            end

            if #cache == 0 then
                repair.panel.hide()
                return
            end

            repair.panel.vehicle = vehicle
            repair.panel.list = cache

            repair.panel.show()
        end
    }
}

call = {
    events = {
        start = function()
            registerEvent('call:show', resourceRoot, call.panel.show)
            registerEvent('call:update', resourceRoot, call.system.update)
        end,
    },

    panel = {
        state = false,

        activeButton = false,
        buttons = {},

        list = {},

        render = function()
            cursorUpdate()

            call.panel.buttons = {}
            scroll.buttons = {}

            local w, h = 736 * scale, 538 * scale
            local x, y = (screen.x - w) / 2, (screen.y - h) / 2

            local fade = 1

            dxDrawRectangleRounded(x, y, w, h, 11, tocolor(65, 66, 77, 0.96 * fade))

            dxDrawImageBlend(x + 24 * scale, y + 29 * scale, 28 * scale, 28 * scale, icon['repair'], tocolor(255, 255, 255, fade))
            dxDrawText('Mecânico', x + 63 * scale, y + 31 * scale, 0, 0, tocolor(255, 255, 255, fade), 1, getFont('medium', 26))
            dxDrawText('Painel de chamados', x + 201 * scale, y + 32 * scale, 0, 0, tocolor(187, 187, 187, fade), 1, getFont('light', 24))

            scroll.draw('list', x + 717 * scale, y + 78 * scale, 6 * scale, 421 * scale, tocolor(87, 88, 100, 0.5 * fade), tocolor(143, 147, 192, 0.5 * fade), 5, #call.panel.list)
            scroll.buttons['scroll:list'] = {x + 20 * scale, y + 78 * scale, 690 * scale, 421 * scale}

            for i = 1, 5 do
                local index = i + scroll.getValue('list')
                local v = call.panel.list[index]

                if v then
                    if not isElement(v.player) then
                        table.remove(call.panel.list, index)
                        break
                    end

                    dxDrawRectangleRounded(x + 20 * scale, y + (78 + (85 * (i - 1))) * scale, 690 * scale, 81 * scale, 1, tocolor(87, 88, 100, 0.5 * fade))

                    dxDrawText('Nome', x + 44 * scale, y + (92 + (85 * (i - 1))) * scale, 0, 0, tocolor(255, 255, 255, fade), 1, getFont('medium', 24))
                    dxDrawText(v.player.name, x + 44 * scale, y + (122 + (85 * (i - 1))) * scale, 0, 0, tocolor(187, 187, 187, fade), 1, getFont('light', 24))

                    dxDrawText('Localização', x + 283 * scale, y + (92 + (85 * (i - 1))) * scale, 0, 0, tocolor(255, 255, 255, fade), 1, getFont('medium', 24))
                    dxDrawText(v.location, x + 283 * scale, y + (122 + (85 * (i - 1))) * scale, 0, 0, tocolor(187, 187, 187, fade), 1, getFont('light', 24))

                    dxDrawImage(x + 644 * scale, y + (103 + (85 * (i - 1))) * scale, 32 * scale, 32 * scale, icon['check'], tocolor(184, 234, 183, fade))
                    call.panel.buttons['accept:' .. index] = {x + 644 * scale, y + (103 + (85 * (i - 1))) * scale, 32 * scale, 32 * scale}
                end
            end
        end,

        click = function(button, state)
            if button == 'left' then
                if state == 'down' then
                    call.panel.activeButton = false

                    for i, v in pairs(call.panel.buttons) do
                        if isCursorInBox(unpack(v)) then
                            call.panel.activeButton = i
                            break
                        end
                    end
                elseif state == 'up' then
                    if call.panel.activeButton and isCursorInBox(unpack(call.panel.buttons[call.panel.activeButton])) then
                        local buttonDetails = split(call.panel.activeButton, ':')

                        if buttonDetails[1] == 'accept' then
                            triggerServerEvent('call:accept', resourceRoot, call.panel.list[tonumber(buttonDetails[2])].player)
                        end
                    end
                end
            end
        end,

        show = function()
            if call.panel.state then
                return
            end

            call.panel.toggle(true)
        end,

        hide = function()
            if not call.panel.state then
                return
            end

            call.panel.toggle(false)
        end,

        toggle = function(state)
            if state then
                if not call.panel.state then
                    createIcons()

                    bindKey('backspace', 'down', call.panel.hide)

                    addEventHandler('onClientRender', root, call.panel.render)
                    addEventHandler('onClientClick', root, call.panel.click)
                end
            else
                if call.panel.state then
                    removeEventHandler('onClientRender', root, call.panel.render)
                    removeEventHandler('onClientClick', root, call.panel.click)

                    unbindKey('backspace', 'down', call.panel.hide)

                    repair.panel.vehicle = false
                    repair.panel.list = {}
                end
            end

            showCursor(state)

            call.panel.state = state
        end,
    },

    system = {
        update = function(list)
            call.panel.list = list
        end
    }
}

point = {
    colshapes = {},

    events = {
        start = function()
            addEventHandler('onClientColShapeHit', root, point.events.hit)

            registerEvent('point:create', resourceRoot, point.system.create)
            registerEvent('point:destroy', resourceRoot, point.system.destroy)
        end,

        hit = function(player)
            if player ~= localPlayer then
                return
            end

            for i, v in pairs(point.colshapes) do
                if v[1] == source then
                    triggerServerEvent('point:hit', resourceRoot, v[3], encode(i))
                    source:destroy()
                    point.colshapes[i] = nil
                    return
                end
            end
        end
    },

    panel = {
        state = false,

        render = function()
            for i, v in pairs(point.colshapes) do
                local posX, posY, posZ = getElementPosition(v[1])
                local x, y = getScreenFromWorldPosition(posX, posY, posZ + 1)

                if x and y then
                    local playerX, playerY, playerZ = getElementPosition(localPlayer)
                    local distance = getDistanceBetweenPoints3D(posX, posY, posZ, playerX, playerY, playerZ)
                    local startY = 0

                    do
                        startY = y
                        local font = getFont('light', 28)
                        local text = v[2]
                        dxDrawText(text, x - dxGetTextWidth(text, 1, font) / 2, startY, 0, 0, tocolor(255, 255, 255), 1, font)
                    end

                    do
                        local font = getFont('medium', 31)
                        startY = startY + dxGetFontHeight(1, font) + 2
                        local text = math.floor(distance) .. 'm'
                        dxDrawText(text, x - dxGetTextWidth(text, 1, font) / 2, startY, 0, 0, tocolor(255, 255, 255), 1, font)
                    end
                end
            end
        end,

        toggle = function(state)
            if state then
                if not point.panel.state then
                    addEventHandler('onClientRender', root, point.panel.render)
                end
            else
                if point.panel.state then
                    removeEventHandler('onClientRender', root, point.panel.render)
                end
            end

            point.panel.state = state
        end
    },

    system = {
        create = function(index, text, target)
            local colshape = createColSphere(target.position, 10)
            point.colshapes[index] = {colshape, text, target}

            if not point.panel.state then
                point.panel.toggle(true)
            end
        end,

        destroy = function(index)
            if not point.colshapes[index] then
                return
            end

            point.colshapes[index][1]:destroy()
            point.colshapes[index] = nil

            if #point.colshapes == 0 then
                point.panel.toggle(false)
            end
        end
    }
}

bindKey('backspace', 'down', function()
    repair.panel.toggle(false)
end)

core.start()

