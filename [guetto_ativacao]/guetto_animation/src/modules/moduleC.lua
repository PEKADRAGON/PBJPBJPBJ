screen = {guiGetScreenSize()}
scale = math.min(screen[2] / 1080, 2)

local _dxDrawText = dxDrawText
function dxDrawText(text, x, y, w, h, ...)
    return _dxDrawText(text, x, y, x + w, y + h, ...)
end

local _dxDrawImage = dxDrawImage
function dxDrawImage(x, y, w, h, img, color, rot, rotX, rotY, post)
    return _dxDrawImage(x, y, w, h, img, rot or 0, rotX or 0, rotY or 0, color, post)
end

local _tocolor = tocolor
function tocolor(r, g, b, a)
    return _tocolor(r, g, b, (a or 1) * 255)
end

function dxDrawImageBlend(x, y, w, h, svg, color)
    local alpha = (color and tonumber(bitExtract(color, 24, 8))) or 255

    if alpha < 255 then
        dxDrawImage(x, y, w, h, svg, color)
    else
        dxSetBlendMode('add')
        dxDrawImage(x, y, w, h, svg, color)
        dxSetBlendMode('blend')
    end
end

local rectangles = {}
local strokes = {}
function dxDrawRectangleRounded(x, y, w, h, radius, color, stroke)
    radius = radius * scale
    local index = w .. h .. radius

    if not rectangles[index] then
        rectangles[index] = svgCreate(w, h, string.format([[
            <svg width='%s' height='%s' xmlns='http://www.w3.org/2000/svg'>
                <rect width='%s' height='%s' rx='%s' fill='white'/>
            </svg>
        ]], w, h, w, h, radius))
    else
        dxDrawImageBlend(x, y, w, h, rectangles[index], color)
    end

    if stroke then
        if not strokes[index] then
            strokes[index] = svgCreate(w, h, string.format([[
                <svg width='%s' height='%s' xmlns='http://www.w3.org/2000/svg'>
                    <rect x='%s' y='%s' width='%s' height='%s' rx='%s' fill-opacity='0' stroke='white' stroke-width='%s'/>
                </svg>
            ]], w + stroke[2], h + stroke[2], stroke[2] / 2, stroke[2] / 2, w, h, radius, stroke[2]))
        else
            dxDrawImageBlend(x, y, w, h, strokes[index], stroke[1])
        end
    end
end

local fonts = {}
function getFont(font, size)
    local index = font .. size

    if not fonts[index] then
        fonts[index] = dxCreateFont('assets/fonts/' .. font .. '.ttf', size * scale)
    end

    return fonts[index]
end

cursor = {}
function cursorUpdate()
    cursor.state = isCursorShowing()

    if not cursor.state then
        return
    end

    local cursorX, cursorY = getCursorPosition()
    cursor.x, cursor.y = cursorX * screen[1], cursorY * screen[2]
end

function isCursorInBox(x, y, width, heigth)
    if not cursor.state then
        return false
    end

    return cursor.x >= x and cursor.x <= x + width and cursor.y >= y and cursor.y <= y + heigth
end

function destroyAllSvgs ()
    for i, v in pairs(rectangles) do 
        if isElement(v) then 
            destroyElement(v)
        end
    end
    for k, value in pairs(strokes) do 
        if isElement(value) then 
            destroyElement(value)
        end
    end
    strokes = {}
    rectangles = {}
end;

function reMap(value, low1, high1, low2, high2)
    return (value - low1) * (high2 - low2) / (high1 - low1) + low2
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
                        if isCursorInBox(unpack(v)) then
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
                        if isCursorInBox(unpack(v)) then
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

            dxDrawRectangleRounded(x, trackY, w, trackHeight, w, trackColor)
            dxDrawRectangleRounded(x, gripY, w, gripHeight, w, gripColor)

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

interpolate = {
    data = {},
    running = false,

    create = function(index, duration, easing)
        if not interpolate.data[index] then
            interpolate.data[index] = {
                initial = 0,
                final = 0,
                duration = duration,
                easing = easing,
                tick = 0
            }

            return interpolate.data[index]
        end

        return false
    end,

    exec = function(index, initial, final, duration, easing)
        if interpolate.data[index] then
            interpolate.data[index].initial = initial
            interpolate.data[index].final = final
            interpolate.data[index].duration = duration or interpolate.data[index].duration
            interpolate.data[index].easing = easing or interpolate.data[index].easing
            interpolate.data[index].tick = getTickCount()

            return true
        end

        return false
    end,

    get = function(index)
        local animation = interpolate.data[index]
        local progress = (getTickCount() - animation.tick) / animation.duration

        if progress >= 1 then
            interpolate.running = false
            return animation.final
        end

        interpolate.running = true

        return interpolateBetween(animation.initial, 0, 0, animation.final, 0, 0, progress, animation.easing)
    end,

    isRunning = function(index) 
        local animation = interpolate.data[index]
        local progress = (getTickCount() - animation.tick) / animation.duration

        if progress >= 1 then
            return false
        end

        return true
    end
}

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

    destroyAllSlid = function ( )
        for i, v in pairs(slidebar.data) do 
            v = nil 
        end
        slidebar.data = {}
        slidebar.state = false;
        removeEventHandler('onClientRender', root, slidebar.draw)
        removeEventHandler('onClientClick', root, slidebar.click)
    end;

    draw = function ( )
        cursorUpdate()
    
        local w, h = 1304 * scale, 807 * scale;
        local x, y = (screen[1] - w) / 2, (screen[2] - h) / 2

        for i, v in pairs(slidebar.data) do 

            dxDrawRectangle(v.pos[1], v.pos[2], v.pos[3], v.pos[4], v.colorBackground, true)
            dxDrawRectangle(v.pos[1], v.pos[2], v.progress, v.pos[4],  v.colorInProgress, true)
            dxDrawRectangle(v.pos[1] + v.progress, v.pos[2] + v.pos[4] / 2 - 33 * scale / 2, 21 * scale, 33 * scale,  tocolor(217, 217, 217, 1), true)

            local totalPos = v.pos[1] + v.progress

            dxDrawRectangle(totalPos + 21 * scale / 2 - 114 * scale / 2, 476 * scale, 114 * scale, 39 * scale,  tocolor(66, 66, 66, 0.50 * 1), true)
            dxDrawText('$ '..(formatNumber(math.floor(v.percent), '.'))..'', totalPos + 21 * scale / 2 - 114 * scale / 2, 476 * scale, 114 * scale, 39 * scale, tocolor(255, 255, 255, 1), 1, getFont('medium', 12), 'center', 'center', false, false, true)
            
            if v.active then 
                local cursorX, cursorY = getCursorPosition ( )
    
                local sensitivity = 0.1
                local speed = 1.0
    
                v.progress = math.min(math.max((cursorX * screen[1] - v.pos[1]) * speed, 0), v.pos[3])
                v.percent = ( v.progress / v.pos[3] * v.total )
            end
        end

        dxDrawText('$1', x + 61  * scale, y + 425 * scale, 0, 0, tocolor(255, 255, 255, 1), 1, getFont('medium', 12), 'left', 'top', false, false, true)
        dxDrawText('$500', x + 1191  * scale, y + 425 * scale, 0, 0, tocolor(255, 255, 255, 1), 1, getFont('medium', 12), 'left', 'top', false, false, true)
    end;

    click = function(button, state)
        if button == 'left' then 
            if state == 'down' then 
                for i, v in pairs(slidebar.data) do 
                    if isCursorInBox(v.pos[1] + v.progress, v.pos[2] + v.pos[4] / 2 - 33 * scale / 2, 21 * scale, 33 * scale) then 
                        v.active = true
                    end
                end
            elseif state == 'up' then 
                for i, v in pairs(slidebar.data) do 
                    if v.active then 
                        v.active = false
                    end
                end
            end
        end
    end;

}

function convertTime(milissegundos)
    local segundos = milissegundos / 1000
    local minutos = math.floor(segundos / 60)
    local segundos_restantes = math.floor(segundos % 60)
    local resultado_lua = string.format("%d:%02d", minutos, segundos_restantes)
    return resultado_lua
end


Icons = {
    Vip = svgCreate(15, 15, [[<svg width="15" height="15" viewBox="0 0 15 15" fill="none" xmlns="http://www.w3.org/2000/svg"> <path d="M7.5 1L14 7.5L7.5 14L1 7.5L7.5 1Z" fill="white"/> </svg> ]])
}

local color_animation = {};

function colorAnimation(id, duration, r2, g2, b2, alpha, verify)
    if not color_animation[id] then
        color_animation[id] = {id = id, duration = duration, alpha = alpha, r = r2, g = g2, b = b2, lastR = r2, lastG = g2, lastB = b2, lastA = alpha, tick = nil}
    end
    if r2 ~= color_animation[id].lastR or g2 ~= color_animation[id].lastG or b2 ~= color_animation[id].lastB or alpha ~= color_animation[id].lastA then
        color_animation[id].tick = getTickCount()
        color_animation[id].lastR = r2
        color_animation[id].lastG = g2
        color_animation[id].lastB = b2
        color_animation[id].lastA = alpha
    elseif color_animation[id].r == r2 and color_animation[id].g == g2 and color_animation[id].b == b2 and color_animation[id].alpha == alpha then
        color_animation[id].tick = nil
    end
    if color_animation[id].tick then
        local interpolate = {interpolateBetween(color_animation[id].r, color_animation[id].g, color_animation[id].b, r2, g2, b2, (getTickCount() - color_animation[id].tick) / color_animation[id].duration, 'Linear')}
        local interpolateAlpha = interpolateBetween(color_animation[id].alpha, 0, 0, alpha, 0, 0, (getTickCount() - color_animation[id].tick) / color_animation[id].duration, 'Linear')

        color_animation[id].r = interpolate[1]
        color_animation[id].g = interpolate[2]
        color_animation[id].b = interpolate[3]
        color_animation[id].alpha = interpolateAlpha
    end
    if (verify and ((verify > 0 and verify < 1) and true or false) or false) then
        color_animation[id].alpha = alpha
    end
    return tocolor(color_animation[id].r, color_animation[id].g, color_animation[id].b, color_animation[id].alpha)
end