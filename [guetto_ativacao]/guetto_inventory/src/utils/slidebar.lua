slidebar = {
    data = {};
    state = false;

    events = {
        start = function ( )

            if not slidebar.state then 
                slidebar.state = true 
                addEventHandler('onClientRender', root, slidebar.draw)
                addEventHandler('onClientClick', root, slidebar.click)
            end

        end;
    };

    create = function (id, pos, colorBackground, colorInProgress, total) 
        if not slidebar.data[id] then 
            slidebar.data[id] = {
                pos = pos,
                colorBackground = colorBackground,
                colorInProgress = colorInProgress,
                progress = 0,
                percent = 0,
                total = total,
                active = false,
            }
            slidebar.events.start()
        end
    end;

    setValue = function(id, value)
        if slidebar.data[id] then 
            slidebar.data[id].progress = tonumber(value)
        end
    end;

    getSlidePercent = function (id)
        if not slidebar.data[id] then return 0 end
        return math.floor(slidebar.data[id].percent)
    end;


    draw = function ( )

        for i, v in pairs(slidebar.data) do 
            local circleX = v.pos[1] + v.percent - 16 / 2

            dxDrawRectangle(v.pos[1], v.pos[2], v.pos[3], v.pos[4], v.colorBackground, true)
            dxDrawRectangle(v.pos[1], v.pos[2], v.progress, v.pos[4],  v.colorInProgress, true)
            dxDrawImage(v.pos[1] + (v.progress - 9), v.pos[2] + v.pos[4] / 2 - 16 / 2, 16, 16, "assets/images/icon-slide.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)

            local totalPos = v.pos[1] + v.progress

            if v.active then 
                local cursorX, cursorY = getCursorPosition ( )
    
                local sensitivity = 0.1
                local speed = 1.0
    
                v.progress = math.min(math.max((cursorX * 1920 - v.pos[1]) * speed, 0), v.pos[3])
                v.percent = ( v.progress / v.pos[3] * v.total )
            end
        end
    end;

    click = function(button, state)
        if button == 'left' then 
            if state == 'down' then 
                for i, v in pairs(slidebar.data) do 
                    if isCursorOnElement(v.pos[1] + (v.progress - 9), v.pos[2] + v.pos[4] / 2 - 18 / 2, 18, 18) then 
                        v.active = true
                    end
                end
            elseif state == 'up' then 
                for i, v in pairs(slidebar.data) do 
                    if v.active then 
                        v.active = false
                        break
                    end
                end
            end
        end
    end;

    destroyAllSlid = function ( )
        for i, v in pairs (slidebar.data) do 
            if v then 
                v = nil 
            end
        end
        slidebar.data = {}
        slidebar.state = false, 
        removeEventHandler('onClientRender', root, slidebar.draw)
        removeEventHandler('onClientClick', root, slidebar.click)
    end;

}