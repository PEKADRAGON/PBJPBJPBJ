checkbox = {
    data = {},

    start = function()
        addEventHandler("onClientClick", root, checkbox.click)
    end,

    create = function (index, backgroundImg, rectangleImg, trackColor, activeColor)
        if not checkbox.data[index] then 
            checkbox.data[index] = {
                backgroundImg = backgroundImg,
                rectangleImg = rectangleImg,
                trackColor = trackColor,
                activeColor = activeColor,
                animation = false, 
                tick = getTickCount(), 
                start = 969, 
                destiny = 969, 
                active = false, 
                buttons = {},
            }
        end
    end,

    setProperties = function(index, x, y, w, h, rw, rh)
        if checkbox.data[index] then 
            checkbox.data[index].x = x
            checkbox.data[index].y = y
            checkbox.data[index].w = w
            checkbox.data[index].h = h
            checkbox.data[index].rw = rw
            checkbox.data[index].rh = rh
        end
    end,

    draw = function()
        for i, v in pairs(checkbox.data) do 
            v.animation = interpolateBetween(v.start, 0, 0, v.destiny, 0, 0, (getTickCount() - v.tick) / 400, 'InOutBack')
            dxDrawImage(v.x, v.y, v.w, v.h, v.backgroundImg, 0, 0, 0, v.active and v.activeColor or v.trackColor, true)
            dxDrawImage(v.animation, v.y + v.h / 2 - v.rh / 2, v.rw, v.rh, v.rectangleImg, 0, 0, 0, tocolor(255, 255, 255, 255), true)
        end 
    end,

    click = function(button, state)
        if button == 'left' then 
            if state == "down" then 
                active = false;
                for i, v in pairs(checkbox.data) do 
                    if isCursorOnElement(v.x, v.y, v.w, v.h) then 
                        active = i 
                        break
                    end
                end
            elseif state == "up" then 
                if active then 
                    if not checkbox.data[active].active then 
                        checkbox.data[active].start = 969
                        checkbox.data[active].destiny = 1001
                        checkbox.data[active].tick = getTickCount()
                        checkbox.data[active].active = true
                    else
                        checkbox.data[active].start = 1001
                        checkbox.data[active].destiny = 969
                        checkbox.data[active].tick = getTickCount()
                        checkbox.data[active].active = false
                    end
                end
            end
        end
    end
}

checkbox.start()
