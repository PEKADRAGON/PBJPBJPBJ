local screenW, screenH = 1920, 1080

slidebar = {
    data = { };

    start = function ( )
        addEventHandler("onClientClick", root, slidebar.click)
        addEventHandler("onClientRender", root, slidebar.draw)
    end;

    create = function ( index, x, y, w, h, cw, ch, background, circle, fade, max )
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
            slidebar.data[index].value = 255;
            slidebar.data[index].percent = 255;
            slidebar.data[index].active = false;
            slidebar.data[index].showning = true;
        end
        slidebar.data[index].fade = fade;
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

                local percent = interpolate(v.percent, v.percent, 0.05, i)

                local circleX = v.x + percent - v.ch / 2
                dxDrawImage ( v.x, v.y, v.w, v.h, v.background, 0, 0, 0, tocolor(255, 255, 255, 0.10 * v.fade), true);
                dxDrawImage ( v.x, v.y, percent, v.h, v.background, 0, 0, 0, tocolor(193, 159, 114, v.fade), true);
                dxDrawImage ( circleX, v.y + v.h / 2 - v.ch / 2, v.cw, v.ch, v.circle, 0, 0, 0,  tocolor(217, 217, 217, v.fade), true);
            
                if v.state then 
                    local cx, cy = getCursorPosition ( )
                    local tx, ty = 1920 * cx, 1080 * cy
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

    destroy = function ( )
        slidebar.data = { }
        removeEventHandler("onClientClick", root, slidebar.click)
        removeEventHandler("onClientRender", root, slidebar.draw)
    end
    
}


