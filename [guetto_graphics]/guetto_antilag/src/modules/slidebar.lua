local screenW, screenH = 1920, 1080;

slidebar = {
    data = { };

    start = function ( )
        addEventHandler("onClientClick", root, slidebar.click)
        addEventHandler("onClientRender", root, slidebar.draw)
    end;

    create = function ( index, x, y, w, h, cw, ch, background, circle, trackColor, mainColor, circleColor, max )
        if not slidebar.data[index] then 
            slidebar.data[index] = {}
            slidebar.data[index].x = x;
            slidebar.data[index].y = y;
            slidebar.data[index].w = w;
            slidebar.data[index].h = h;
            slidebar.data[index].cw = cw;
            slidebar.data[index].ch = ch;
            slidebar.data[index].background = background;
            slidebar.data[index].circle = circle;
            slidebar.data[index].trackColor = trackColor;
            slidebar.data[index].mainColor = mainColor;
            slidebar.data[index].max = max;
            slidebar.data[index].value = 50;
            slidebar.data[index].percent = 50;
            slidebar.data[index].active = false;
            slidebar.data[index].showning = true;
        end
    end;

    getValue = function ( index )
        if not slidebar.data[index] then 
            return 0 
        end

        return slidebar.data[index].percent
    end;

    showning = function (index, state)
        if slidebar.data[index] then 
            slidebar.data[index].showning = state 
        end
    end;

    draw =  function ( )
        for i, v in pairs ( slidebar.data ) do 
            if v.showning then 
                local circleX = v.x + v.value - v.ch / 2
                dxDrawImage ( v.x, v.y, v.w, v.h, v.background, 0, 0, 0, v.trackColor, true);
                dxDrawImage ( v.x, v.y, v.value, v.h, v.background, 0, 0, 0, v.mainColor, true);
                dxDrawImage ( circleX, v.y - v.h / 2 , v.cw, v.ch, v.circle, 0, 0, 0,  v.circleColor, true);
                if v.state then 
                    local cx, cy = getCursorPosition ( )
                    local tx, ty = cx * screenW, cy * screenH
        
                    v.value = math.min(math.max(tx - v.x, 0), v.w)
                    v.percent = math.floor((v.value / v.w * v.max))
                end
            end
        end
    end;

    click = function ( button, state )
        if button == "left" then 
            for i, v in pairs ( slidebar.data ) do
                if v.showning then 
                    if state == "down" then
                        if isCursorOnElement(v.x + v.value - v.ch / 2, v.y - v.h / 2 , v.cw, v.ch) then 
                            v.state = true;
                        end
                    elseif state == "up" then 
                        if v.state then 
                            v.state = false;
                        end;
                    end 
                end
            end
        end
    end;
}

slidebar.start()

