local screenW, screenH = 1920, 1080;

clamp = function(value, min, max)
    return math.max(min, math.min(max, value))
end

colorpicker = {
    data = {};

    start = function()
        addEventHandler("onClientRender", root, colorpicker.draw)
        addEventHandler("onClientClick", root, colorpicker.click)
    end;

    create = function(index, x, y, w, h, width, height, palletImg, cursorImg)
        if not colorpicker.data[index] then 
            colorpicker.data[index] = { }
            colorpicker.data[index].x = x
            colorpicker.data[index].y = y
            colorpicker.data[index].w = w
            colorpicker.data[index].h = h
            colorpicker.data[index].width = width
            colorpicker.data[index].height = height
            colorpicker.data[index].palletImg = palletImg
            colorpicker.data[index].cursorImg = cursorImg
            colorpicker.data[index].select = {x = 0, y = 0}
            colorpicker.data[index].active = false
            colorpicker.data[index].showning = true
            
            colorpicker.data[index].texture = dxCreateTexture(palletImg)
            colorpicker.data[index].pixels = dxGetTexturePixels(colorpicker.data[index].texture)
            colorpicker.data[index].palletW, colorpicker.data[index].palletH = dxGetPixelsSize(colorpicker.data[index].pixels)
        end
    end;
    
    destroy = function ( index )
        if colorpicker.data[index] then 
            colorpicker.data[index] = nil 
        end 
    end;

    draw = function()
        for i, v in pairs(colorpicker.data) do 
            if v.showning then 

                dxDrawImage(v.x, v.y, v.w, v.h, v.palletImg, 0, 0, 0, tocolor(255, 255, 255, 255), true)
            
                if v.active then
                    local cx, cy = getCursorPosition()
                    if cx and cy then
                        local tx, ty = cx * screenW, cy * screenH
                        local cursorX = tx - v.x - v.width / 2
                        local cursorY = ty - v.y - v.height / 2
                        
                        cursorX = math.max(0, math.min(v.w - v.width, cursorX))
                        cursorY = math.max(0, math.min(v.h - v.height, cursorY))
                        
                        v.select.x = cursorX
                        v.select.y = cursorY
                    end
                end
    
                dxDrawImage(v.x + v.select.x, v.y + v.select.y, v.width, v.height, v.cursorImg, 0, 0, 0, tocolor(255, 255, 255, 255), true)
            end
        end
    end;

    showning = function ( index, state )
        if colorpicker.data[index] then 
            colorpicker.data[index].showning = state
        end
    end;    

    getColor = function(index, opacity)
        if not colorpicker.data[index] then 
            return 0, 0, 0
        end

        local x, y = colorpicker.data[index].select.x, colorpicker.data[index].select.y
        local relativeX, relativeY = x / colorpicker.data[index].w, y / colorpicker.data[index].h
        local r, g, b = dxGetPixelColor(colorpicker.data[index].pixels, relativeX * colorpicker.data[index].palletW, relativeY * colorpicker.data[index].palletH)

        if opacity then
            opacity = clamp(opacity, 0, 1)
            r = math.floor(r * opacity)
            g = math.floor(g * opacity)
            b = math.floor(b * opacity)
        end
    
        return r, g, b
    end;

    click = function(button, state)
        if button == "left" then 
            for i, v in pairs(colorpicker.data) do 
                if v.showning then 
                    if state == "down" then 
                        if isCursorOnElement(v.x, v.y, v.w, v.h) then 
                            v.active = true
                            break
                        end
                    elseif state == "up" then 
                        if v.active then 
                            v.active = false
                            break
                        end
                    end
                end
            end
        end
    end
}

colorpicker.start()
