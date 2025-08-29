local screenW, screenH = 1920, 1080

function reMap(value, low1, high1, low2, high2)
    return (value - low1) * (high2 - low2) / (high1 - low1) + low2
end

cursor = {}
function cursorUpdate()
    cursor.state = isCursorShowing()

    if not cursor.state then
        return
    end

    local cursorX, cursorY = getCursorPosition()
    cursor.x, cursor.y = cursorX * screenW, cursorY * screenH
end

scroll = {
    activeButton = false,
    data = {},
    buttons = {},

    draggingGrips = {},

    start = function()
        addEventHandler('onClientClick', root, scroll.click)
        addEventHandler('onClientKey', root, scroll.key)
    end,

    create = function(index, max, total)
        scroll.data[index] = {
            gripPoses = 0,
            offset = 0,
            max = max,
            total = total
        }
    end,

    click = function(button, state)
        if button == 'left' then
            if state == 'down' then
                scroll.activeButton = false

                for i, v in pairs(scroll.buttons) do
                    if split(i, ':')[1] == 'scrollbar' then
                        if isCursorOnElement(unpack(v)) then
                            scroll.activeButton = i
                            break
                        end
                    end
                end

                if scroll.activeButton then
                    local buttonDetails = split(scroll.activeButton, ':')

                    local index = buttonDetails[2]
                    scroll.draggingGrips[index] = cursor.y - scroll.data[index].gripPoses

                    scroll.activeButton = false
                end
            elseif state == 'up' then
                scroll.draggingGrips = {}
            end
        end
    end,

    key = function(key, press)
        if press then
            if key == 'mouse_wheel_down' or key == 'mouse_wheel_up' then
                scroll.activeButton = false
    
                for i, v in pairs(scroll.buttons) do
                    if split(i, ':')[1] == 'scroll' then
                        if isCursorOnElement(unpack(v)) then
                            scroll.activeButton = i
                            break
                        end
                    end
                end

                if scroll.activeButton then
                    local buttonDetails = split(scroll.activeButton, ':')
                    local data = scroll.data[buttonDetails[2]]

                    local offset = data.offset

                    if key == 'mouse_wheel_down' and offset < data.total - data.max then
                        offset = offset + 1
                    elseif key == 'mouse_wheel_up' and offset > 0 then
                        offset = offset - 1
                    end

                    scroll.data[buttonDetails[2]].offset = offset

                    scroll.activeButton = false
                end
            end
        end
    end,

    draw = function(index, x, y, w, h, trackColor, gripColor, visibleItems, currentItems)
        local trackY = y
        local trackHeight = h

        local gripHeight = (trackHeight / currentItems) * visibleItems

        if not scroll.data[index] then
            scroll.create(index, visibleItems, currentItems)
        else
            if scroll.data[index].max ~= visibleItems then
                scroll.data[index].max = visibleItems
            end

            if scroll.data[index].total ~= currentItems then
                scroll.data[index].total = currentItems
            end
        end

        if currentItems > visibleItems then
            if scroll.draggingGrips[index] then
                scroll.data[index].gripPoses = cursor.y - scroll.draggingGrips[index]

                if scroll.data[index].gripPoses < trackY then
                    scroll.data[index].gripPoses = trackY
                elseif scroll.data[index].gripPoses > trackY + trackHeight - gripHeight then
                    scroll.data[index].gripPoses = trackY + trackHeight - gripHeight
                end

                scroll.data[index].offset = math.floor(reMap(scroll.data[index].gripPoses, trackY, trackY + trackHeight - gripHeight, 0, 1) * (currentItems - visibleItems))
            end

            local gripY = trackY + (trackHeight / currentItems) * math.min(scroll.data[index].offset, currentItems - visibleItems)

            if gripY < trackY then
                gripY = trackY
            elseif gripY > trackY + trackHeight - gripHeight then
                gripY = trackY + trackHeight - gripHeight
            end

            scroll.data[index].gripPoses = gripY

            dxDrawRectangle(x, trackY, w, trackHeight, trackColor)
            dxDrawRectangle(x, gripY, w, gripHeight,  gripColor)

            scroll.buttons['scrollbar:' .. index] = {x, gripY, w, gripHeight}
        end
    end,

    setValue = function(index, value)
        if not scroll.data[index] then
            return false
        end

        scroll.data[index].offset = value
    end,

    getValue = function(index)
        if not scroll.data[index] then
            return 0
        end

        return scroll.data[index].offset
    end
}

scroll.start()