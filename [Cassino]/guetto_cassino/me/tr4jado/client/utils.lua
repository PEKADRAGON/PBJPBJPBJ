screen = Vector2(guiGetScreenSize())
scale = math.min(screen.y / 1080, 2)

if math.abs(screen.x / screen.y) < 1.7 then
    scale = math.min(screen.x / 1920, 2)
else
    scale = math.min(screen.y / 1080, 2)
end

local _dxDrawText = dxDrawText
function dxDrawText(text, x, y, w, h, ...)
    return _dxDrawText(text, x, y, x + w, y + h, ...)
end

local _dxDrawImage = dxDrawImage
function dxDrawImage(x, y, w, h, img, color, rot, rotX, rotY)
    return _dxDrawImage(x, y, w, h, img, rot or 0, rotX or 0, rotY or 0, color)
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

local textWidth = {}
local _dxGetTextWidth = dxGetTextWidth
function dxGetTextWidth(text, scale, font)
    local index = text .. scale .. tostring(font)

    if not textWidth[index] then
        textWidth[index] = _dxGetTextWidth(text, scale, font)
    end

    return textWidth[index]
end

local rectangles = {}
local strokes = {}
function dxDrawRectangleRounded(x, y, w, h, radius, color, stroke)
    radius = radius * scale
    local index = w .. h .. radius .. type(color)

    if not rectangles[index] then
        if type(color) == 'table' then
            rectangles[index] = svgCreate(w, h, string.format([[
                <svg width='%s' height='%s' fill='none' xmlns='http://www.w3.org/2000/svg'>
                    <rect width='%s' height='%s' rx='%s' fill='url(#fallet_paint_linear)'/>

                    <defs>
                        <linearGradient id='fallet_paint_linear' x1='%s' y1='%s' x2='%s' y2='%s' gradientUnits='userSpaceOnUse'>
                            <stop stop-color='%s'/>
                            <stop offset='1' stop-color='%s'/>
                        </linearGradient>
                    </defs>
                </svg>                
            ]], w, h, w, h, radius, 0, h / 2, w, h / 2, color[1], color[2]))
        else
            rectangles[index] = svgCreate(w, h, string.format([[
                <svg width='%s' height='%s' xmlns='http://www.w3.org/2000/svg'>
                    <rect width='%s' height='%s' rx='%s' fill='white'/>
                </svg>
            ]], w, h, w, h, radius))
        end
    else
        if type(color) == 'table' then
            dxDrawImageBlend(x, y, w, h, rectangles[index], tocolor(255, 255, 255, color[3]))
        else
            dxDrawImageBlend(x, y, w, h, rectangles[index], color)
        end
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

circles = {}
function dxDrawCustomCircle(index, x, y, size, offset, color, stroke, values)
    if not circles[index] then
        local strokeSize = stroke[3] or 0
        local radius = (size - strokeSize) / 2
        local radiusLenght = (2 * math.pi) * radius

        local svg = svgCreate(size, size, string.format([[
            <svg width='%s' height='%s' fill='none' xmlns='http://www.w3.org/2000/svg'>
                <circle cx='%s' cy='%s' r='%s' transform='rotate(-%s %s %s)' fill='%s' fill-opacity='%s' stroke='%s' stroke-opacity='%s' stroke-width='%s' stroke-dasharray='%s' stroke-dashoffset='%s' stroke-linecap='round' stroke-linejoin='round'/>
            </svg>
        ]], size, size, size / 2, size / 2, radius, offset.start + 90, size / 2, size / 2, color[1] or '#FFFFFF', color[2] or 1, stroke[1] or '#FFFFFF', stroke[2] or 0, strokeSize, radiusLenght, radiusLenght * offset.sweep))

        local xml = svgGetDocumentXML(svg)

        circles[index] = {
            svg = svg,
            xml = xml,
            radiusLenght = radiusLenght,
            circle = xmlFindChild(xml, 'circle', 0),
        }
    else
        local data = circles[index]

        xmlNodeSetAttribute(data.circle, 'stroke-dashoffset', data.radiusLenght - ((data.radiusLenght * (1 - offset.sweep)) / values[2] * values[1]))
        svgSetDocumentXML(data.svg, data.xml)

        dxDrawImageBlend(x, y, size, size, circles[index].svg)
    end
end

function destroyRectangles()
    for i in pairs(rectangles) do
        if isElement(rectangles[i]) then
            rectangles[i]:destroy()
        end

        rectangles[i] = nil
    end

    for i in pairs(strokes) do
        if isElement(strokes[i]) then
            strokes[i]:destroy()
        end

        strokes[i] = nil
    end

    for i in pairs(circles) do
        if isElement(circles[i]) then
            circles[i]:destroy()
        end

        circles[i] = nil
    end
end

local font = {
    ['light'] = 'Poppins-Light.ttf',
    ['medium'] = 'Poppins-Medium.ttf',
}

local fonts = {}
function getFont(type, size)
    local path = font[type]

    if not path then
        error('[' .. Resource.getThis().name .. ']: Font not found: ' .. type)
        return 'default'
    end

    size = getSizeFontFigma(package .. '/assets/fonts/' .. path, size)

    if not size then
        return 'default'
    end

    size = size * scale

    local index = path .. size

    if not fonts[index] then
        fonts[index] = DxFont(package .. '/assets/fonts/' .. path, size)
    end

    return fonts[index]
end

local sizes = {}
function getSizeFontFigma(path, height)
    local index = path .. height

    if not sizes[index] then
        local size = 1

        while true do
            local font = DxFont(path, size)
            local fontH = font:getHeight(1)

            font:destroy()

            if fontH == math.floor(height) then
                sizes[index] = size
                return
            end

            size = size + 1

            if size == 100 then
                sizes[index] = 1
                break
            end
        end
    end

    return sizes[index]
end

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
    cursor.x, cursor.y = cursorX * screen.x, cursorY * screen.y
end

function isCursorInBox(x, y, width, heigth)
    if not cursor.state then
        return false
    end

    return cursor.x >= x and cursor.x <= x + width and cursor.y >= y and cursor.y <= y + heigth
end

function registerEvent(event, element, callback)
    addEvent(event, true)
    addEventHandler(event, element, callback)
end

function sendLogs(message, webhook)
    local postData = {
        queueName = 'dcq',
        connectionAttempts = 3,
        connectTimeout = 5000,
        formFields = {
            content=' \n' .. message .. ' '
        },
    }

    fetchRemote(webhook, postData, function() end)
end

function formatNumber(amount)
    local left, center, right = string.match(math.floor(amount), '^([^%d]*%d)(%d*)(.-)$')
    return left .. string.reverse(string.gsub(string.reverse(center), '(%d%d%d)', '%1.')) .. right
end

function formatTime(ms)
    local totalseconds = math.floor(ms / 1000)

    local seconds = totalseconds % 60
    local minutes = math.floor(totalseconds / 60)
    local hours = math.floor(minutes / 60)

    minutes = minutes % 60
    hours = hours % 24

    return seconds, minutes, hours
end

function removeHex(text)
    return string.gsub(text, '#' .. string.rep('%x', 6), '')
end

function table.count(t)
    local count = 0

    for _ in pairs(t) do
        count = count + 1
    end

    return count
end

function decimalsToHex(color)
    return toHEX(toRGB(color))
end

function toRGB(color)
	color = tonumber(color)

	local r = bitExtract(color, 16, 8)
	local g = bitExtract(color, 8, 8)
	local b = bitExtract(color, 0, 8)
	local a = bitExtract(color, 24, 8)

	return r, g, b, a
end

function toHEX(r, g, b)
	return string.format('#%.2X%.2X%.2X', r, g, b)
end

editbox = {
    activeButton = false,
    actived = false,
    allSelected = false,
    buttons = {},
    data = {},
    state = false,

    toggle = function(state)
        if state then
            if not editbox.state then
                addEventHandler('onClientPreRender', root, editbox.preRender)
                addEventHandler('onClientClick', root, editbox.click)
                addEventHandler('onClientCharacter', root, editbox.character)
                addEventHandler('onClientKey', root, editbox.key)
                addEventHandler('onClientPaste', root, editbox.paste)
            end
        else
            if editbox.state then
                removeEventHandler('onClientPreRender', root, editbox.preRender)
                removeEventHandler('onClientClick', root, editbox.click)
                removeEventHandler('onClientCharacter', root, editbox.character)
                removeEventHandler('onClientKey', root, editbox.key)
                removeEventHandler('onClientPaste', root, editbox.paste)
            end
        end

        editbox.state = state
    end,

    draw = function(index, text, x, y, w, h, color, colorSelected, font, align, wordBreak, mask)
        if not editbox.data[index] then return end

        local textW, textH = dxGetTextSize(mask and editbox.getText(index):gsub('.', '•') or editbox.getText(index), w, 1, 1, font, wordBreak)

        dxDrawText((editbox.getText(index) ~= '' or editbox.actived == index) and (mask and editbox.getText(index):gsub('.', '•') or editbox.getText(index)) or text, x, y, w, h, editbox.actived == index and colorSelected or color, 1, font, wordBreak and align or (textW > w and 'right' or align), wordBreak and (textH > h and 'bottom' or 'top') or 'top', true, wordBreak)

        if align == 'center' and textW <= w then
            local centerX, centerY =  (w - textW) / 2, (h - dxGetFontHeight(1, font)) / 2
            x, y = x + centerX, y + centerY
        end

        if editbox.actived == index and editbox.allSelected then
            if not isCursorShowing() then editbox.actived = false end

            dxDrawRectangle(x, y, textW > w and w or textW, h, tocolor(29, 161, 242, 50))
        end
    end,

    preRender = function()
        local actived = editbox.actived
        if actived then
            local data = editbox.data[actived]

            if data.backspace.state then
                if getTickCount() - data.backspace.tick >= 500 then
                    if getTickCount() - data.backspace.last >= 50 then
                        editbox.data[actived].text = utf8.remove(data.text, -1, -1)
                        data.backspace.last = getTickCount()
                    end
                end
            end
        end
    end,

    character = function(key)
        local actived = editbox.actived
        if actived then
            local data = editbox.data[actived]

            if data.isNumber then
                if not tonumber(key) then
                    key = ''
                end
            end

            if editbox.allSelected then
                editbox.data[actived].text = key
                editbox.allSelected = false
            else
                if #data.text + 1 <= data.max then
                    editbox.data[actived].text = data.text .. key
                end
            end
        end
    end,

    key = function(key, press)
        local actived = editbox.actived
        if actived then
            local data = editbox.data[actived]

            if key == 'backspace' then
                if press then
                    if editbox.allSelected then
                        editbox.data[actived].text = ''
                    else
                        editbox.data[actived].text = utf8.remove(data.text, -1, -1)

                        editbox.data[actived].backspace.tick = getTickCount()
                        editbox.data[actived].backspace.state = true
                    end
                else
                    editbox.data[actived].backspace.state = false
                end
            end

            if getKeyState('lctrl') then
                if key == 'a' then
                    editbox.allSelected = true
                elseif key == 'c' then
                    if editbox.allSelected then
                        setClipboard(editbox.getText(actived))
                    end
                elseif key == 'x' then
                    if editbox.allSelected then
                        setClipboard(editbox.getText(actived))
                        editbox.setText(actived, '')
                        editbox.allSelected = false
                    end
                end
            end

            if (not getKeyState('lctrl') and key ~= 'v') then
                cancelEvent()
            end
        end
    end,

    paste = function(text)
        local actived = editbox.actived
        if actived then
            if editbox.allSelected then
                editbox.data[actived].text = text
                editbox.allSelected = false
            else
                editbox.data[actived].text = editbox.data[actived].text .. text
            end
        end
    end,

    click = function(button, state)
        if button == 'left' then
            if state == 'down' then
                editbox.actived = false
                editbox.allSelected = false
                editbox.activeButton = false

                for i, v in pairs(editbox.buttons) do
                    if isCursorInBox(unpack(v)) then
                        editbox.activeButton = i
                        break
                    end
                end
            elseif state == 'up' then
                if editbox.activeButton then
                    local buttonData = editbox.buttons[editbox.activeButton]

                    if isCursorInBox(buttonData[1], buttonData[2], buttonData[3], buttonData[4]) then
                        editbox.actived = editbox.activeButton
                    end

                    editbox.activeButton = false
                end
            end
        end
    end,

    create = function(index, isNumber, max)
        editbox.toggle(true)

        if not editbox.data[index] then
            editbox.data[index] = {
                text = '',
                isNumber = isNumber,
                max = max or 9999999,

                backspace = {
                    state = false,
                    last = 0,
                    tick = 0
                }
            }
        end
    end,

    destroy = function(index)
        if editbox.data[index] then
            editbox.data[index] = nil

            if #editbox.data == 0 then
                editbox.toggle(false)
            end
        else
            if index == 'all' then
                editbox.data = {}
                editbox.toggle(false)
            end
        end
    end,

    setState = function(index)
        editbox.actived = index
    end,

    setText = function(index, text)
        if not editbox.data[index] then
            return false
        end

        editbox.data[index].text = text
    end,

    getText = function(index)
        if not editbox.data[index] then
            return false
        end

        return editbox.data[index].text
    end
}

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
            scroll.data[index].max = visibleItems
            scroll.data[index].total = currentItems
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
                easing = easing or 'Linear',
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
            animation.running = false
            return animation.final
        end

        animation.running = true

        return interpolateBetween(animation.initial, 0, 0, animation.final, 0, 0, progress, animation.easing)
    end,

    isRunning = function(index) 
        local animation = interpolate.data[index]
        local progress = (getTickCount () - animation.tick) / animation.duration

        if progress >= 1 then
            return false
        end

        return true
    end
}

local icons = {
    money = {
        raw = [[
            <svg width='28' height='28' viewBox='0 0 28 28' fill='none' xmlns='http://www.w3.org/2000/svg'>
                <path d='M14.4594 5.19533C12.5125 5.19204 10.0734 5.80728 7.66719 7.05962C5.26477 8.31197 3.36055 9.95259 2.24274 11.5549C1.12438 13.1518 0.821957 14.6393 1.37211 15.7002C1.92282 16.7557 3.31516 17.3627 5.26696 17.3627C7.21875 17.3682 9.65782 16.7502 12.0586 15.5034C14.4648 14.251 16.368 12.6049 17.4836 11.0081C18.6047 9.41118 18.9 7.92368 18.3531 6.86275C17.8008 5.80728 16.4117 5.19533 14.4594 5.19533ZM19.4852 9.03931C19.2938 9.87603 18.8781 10.7346 18.293 11.5713C17.057 13.3377 15.0391 15.0604 12.5125 16.3729C9.98594 17.6909 7.4211 18.3526 5.26641 18.3526C4.24922 18.3526 3.30641 18.1995 2.5118 17.8768L3.09094 18.9924C3.64219 20.0534 5.03071 20.6604 6.9836 20.6604C8.93594 20.6604 11.375 20.0479 13.7758 18.7956C16.182 17.5487 18.0852 15.9026 19.2008 14.3002C20.3164 12.7034 20.6227 11.2159 20.0703 10.1604L19.4852 9.03931ZM21.0602 9.95806C21.6727 11.4182 21.1805 13.1956 20.0102 14.8635C18.9766 16.3456 17.3961 17.7838 15.4383 18.987C16.0453 19.0526 16.6797 19.0854 17.325 19.0854C20.032 19.0854 22.482 18.5057 24.2102 17.6034C25.9438 16.701 26.8953 15.5198 26.8953 14.3276C26.8953 13.1354 25.9438 11.9542 24.2102 11.0518C23.3297 10.5924 22.2578 10.2151 21.0602 9.95806ZM26.8953 16.7831C26.3375 17.4338 25.5719 18.0081 24.6695 18.4784C22.7555 19.4737 20.1742 20.0698 17.325 20.0698C16.1656 20.0698 15.05 19.9713 14.0055 19.7854C12.7367 20.4252 11.4625 20.901 10.2375 21.2127C10.3031 21.251 10.3688 21.2838 10.4398 21.3221C12.168 22.2245 14.618 22.8042 17.325 22.8042C20.032 22.8042 22.482 22.2245 24.2102 21.3221C25.9438 20.4198 26.8953 19.2385 26.8953 18.0463V16.7831Z' fill='white'/>
            </svg>
        ]],

        w = 28,
        h = 28
    },

    double = {
        raw = [[
            <svg width='21' height='22' viewBox='0 0 21 22' fill='none' xmlns='http://www.w3.org/2000/svg'>
                <path d='M10.3393 2.54434C10.3737 2.60855 10.4328 2.73438 10.4722 2.83089C10.5373 2.98581 10.593 3.07293 10.7886 3.31784L10.8501 3.3962L10.7116 3.48971C10.5276 3.61226 10.4202 3.62817 10.1253 3.58696C9.70423 3.52914 9.38091 3.64532 9.13267 3.94317C9.03564 4.06154 9.0086 4.1368 8.82625 4.77886L8.62757 5.48186L6.62176 5.69377C5.518 5.81051 4.57786 5.91953 4.52929 5.93402C4.39086 5.97599 4.26772 6.11486 4.22389 6.27843C4.18951 6.40672 4.19758 6.45357 4.26928 6.59652C4.34332 6.74355 4.37344 6.77224 4.50791 6.82202C4.67039 6.88275 4.65349 6.88166 8.31666 6.48822C8.35217 6.48399 8.32914 6.60844 8.21141 7.04782L8.06016 7.61229L7.9242 7.55523C7.77627 7.49153 7.66974 7.50424 7.56997 7.59438C7.52094 7.63624 7.42911 7.87631 7.2411 8.42405C7.07153 8.92861 6.95375 9.22704 6.90684 9.28666C6.84022 9.36849 6.73581 9.39895 6.06342 9.53503C5.64069 9.62457 5.25089 9.71949 5.19802 9.75002C5.06789 9.82515 5.02235 9.99513 5.08934 10.13C5.12049 10.1933 5.38862 10.437 5.76041 10.7429C6.10035 11.0265 6.40502 11.3006 6.43554 11.3535C6.48249 11.4348 6.48277 11.5621 6.43644 12.2096C6.40685 12.6279 6.38929 13.0014 6.39822 13.045C6.40801 13.0854 6.44558 13.1505 6.48274 13.1914L6.54511 13.2665L6.30753 14.1275L6.06588 14.9909L5.80042 15.0195C5.3542 15.0683 5.14629 15.267 5.19637 15.5932C5.23352 15.8266 5.34611 15.9324 5.60057 15.9834L5.8005 16.0198L5.70849 16.4145C5.60359 16.8573 5.61451 17.0218 5.75085 17.2955C5.85925 17.5067 6.04428 17.6629 6.31792 17.7706C6.57318 17.8699 6.67254 17.9481 6.76473 18.1172C6.85074 18.2708 6.86636 18.4435 6.81989 18.6682L6.78288 18.8577L6.51656 18.8894C6.32533 18.9104 6.19658 18.9034 6.05226 18.8647C5.85983 18.8131 5.85106 18.8073 5.79627 18.6655C5.68346 18.3809 5.45738 18.0316 5.30012 17.9C5.04522 17.6839 4.90778 17.6196 4.50602 17.5154C4.13227 17.4221 4.12585 17.4204 4.05605 17.3089C3.99884 17.2145 3.87328 16.1565 3.33924 11.1322C2.98135 7.79827 2.69826 5.04465 2.70857 5.00617C2.73779 4.89712 2.85876 4.79204 3.01838 4.73512C3.2469 4.65198 3.56284 4.44789 3.70569 4.2868C3.9175 4.04793 4.0292 3.82349 4.12121 3.42878C4.20183 3.08945 4.20933 3.07427 4.30693 3.01792C4.42892 2.94749 5.57633 2.82182 5.72706 2.86221C5.81366 2.88541 5.85701 2.94171 6.01643 3.23193C6.15088 3.4742 6.24932 3.60714 6.36449 3.70331C6.94439 4.18181 7.74609 4.11475 8.24533 3.54729C8.41859 3.34965 8.43446 3.31609 8.55081 2.95884C8.66395 2.60072 8.67404 2.57593 8.77226 2.53006C8.82747 2.50361 9.12953 2.45392 9.44419 2.42136C10.109 2.352 10.2448 2.3712 10.3393 2.54434Z' fill='white'/>
                <path d='M17.7617 4.96709C17.8523 5.03949 17.8963 5.19568 17.8833 5.39842C17.8702 5.60117 17.9568 5.95781 18.0701 6.16348C18.2272 6.44963 18.3934 6.62478 18.677 6.81077C18.818 6.90013 18.9586 7.01686 18.9892 7.06972L19.044 7.16005L17.4387 13.1511L15.8335 19.1421L15.7408 19.1928C15.6879 19.2234 15.5078 19.2542 15.3369 19.2634C14.9435 19.2817 14.6153 19.4035 14.3458 19.6269C14.1653 19.7744 13.9408 20.0477 13.9133 20.1503C13.8867 20.2498 13.7265 20.3856 13.62 20.3983C13.4771 20.4185 12.4033 20.141 12.2695 20.0502C12.1676 19.9816 12.1416 19.899 12.1218 19.6394C12.0917 19.2257 11.9119 18.8578 11.6172 18.6104C11.4775 18.4905 11.4191 18.4645 11.1209 18.3846C10.8066 18.3004 10.7664 18.2965 10.5481 18.3412C10.1053 18.4288 9.73473 18.7213 9.54753 19.1249L9.45147 19.3295L8.73947 19.1387C7.83184 18.8955 7.84295 18.9053 7.81739 18.4619C7.79497 18.0709 7.73577 17.8557 7.58465 17.5987C7.44527 17.3619 7.22972 17.1529 6.93392 16.974C6.58 16.7554 6.41802 17.5267 8.25018 10.689C10.0823 3.85129 9.83697 4.60021 10.2528 4.58788C10.6016 4.58167 10.8969 4.50609 11.1368 4.36757C11.402 4.21176 11.5487 4.062 11.7619 3.74101C12.0057 3.36979 12.0057 3.36979 12.8201 3.60176C13.4365 3.77723 13.4493 3.78067 13.5112 3.88319C13.545 3.93692 13.5735 4.06143 13.5774 4.16217C13.5868 4.56342 13.7585 4.93599 14.0664 5.21099C14.2362 5.35962 14.2666 5.37463 14.5841 5.45971C14.8824 5.53963 14.9459 5.54633 15.1268 5.51233C15.513 5.44392 15.8535 5.21206 16.0841 4.86478C16.1486 4.76519 16.2495 4.65815 16.3055 4.62849C16.4055 4.57621 16.4224 4.5773 17.0399 4.73588C17.5227 4.85837 17.6941 4.91119 17.7617 4.96709ZM11.1024 6.26615C10.7336 6.35981 10.6056 6.78614 10.866 7.05872C10.9491 7.14629 11.0348 7.1727 13.9117 7.94355C17.1445 8.80979 16.9784 8.77558 17.1678 8.6201C17.3541 8.46376 17.3992 8.26961 17.3013 8.05776C17.187 7.81743 17.3319 7.86658 14.1545 7.01175C11.2456 6.23231 11.2424 6.23145 11.1024 6.26615ZM13.4564 8.91124C13.3768 8.95178 13.1644 9.18017 12.8446 9.56541C12.3562 10.1564 12.2777 10.2316 12.1523 10.2633C12.1127 10.2699 11.7342 10.2201 11.3093 10.1509C10.6676 10.0442 10.5205 10.0289 10.4361 10.0613C10.3097 10.1099 10.233 10.2165 10.2309 10.3397C10.2309 10.3913 10.3951 10.7275 10.6329 11.1487C10.8542 11.5414 11.0431 11.9014 11.0552 11.9459C11.0814 12.0663 11.0451 12.1632 10.7078 12.8703C10.4799 13.3489 10.3952 13.5496 10.4022 13.6134C10.4131 13.7263 10.5306 13.8781 10.6236 13.903C10.6685 13.9151 11.0553 13.8571 11.49 13.7742C12.0079 13.6758 12.3114 13.6334 12.3852 13.6532C12.4558 13.6721 12.6974 13.8606 13.1 14.2056C13.4382 14.4956 13.7442 14.7392 13.7859 14.7504C13.8596 14.7701 14.0182 14.7301 14.0803 14.678C14.1464 14.6235 14.1852 14.3761 14.236 13.7504C14.3118 12.7876 14.2242 12.9222 15.1135 12.3871C15.6171 12.0855 15.8851 11.9063 15.9143 11.8488C15.9659 11.7458 15.9351 11.5657 15.8535 11.4854C15.8202 11.4558 15.4587 11.304 15.0465 11.1488C14.5343 10.9566 14.2825 10.8444 14.2398 10.7986C14.1979 10.7496 14.1334 10.4642 14.0402 9.92702C13.8926 9.07966 13.8388 8.9209 13.6689 8.87535C13.6079 8.85902 13.5288 8.87219 13.4564 8.91124ZM8.70041 15.1408C8.33861 15.2467 8.23629 15.6799 8.50888 15.9454C8.61271 16.0454 8.61592 16.0463 11.5248 16.8257C14.3985 17.5957 14.4369 17.606 14.5897 17.5747C14.9621 17.5061 15.0993 17.0582 14.8334 16.7807C14.7559 16.698 14.6188 16.6579 11.7869 15.8991C8.90362 15.1265 8.81616 15.1065 8.70041 15.1408Z' fill='white'/>
            </svg>
        ]],

        w = 22,
        h = 22
    },

    miners = {
        raw = [[
            <svg width='21' height='22' viewBox='0 0 21 22' fill='none' xmlns='http://www.w3.org/2000/svg'>
                <path d='M17.6935 2.89245C17.5945 2.94958 16.6804 4.08456 16.6347 4.20263C16.5509 4.42353 16.7147 4.64062 16.9584 4.64062C17.0841 4.64062 17.1375 4.61777 17.2327 4.51494C17.4002 4.33593 18.101 3.45613 18.1506 3.35711C18.3067 3.07146 17.9715 2.72868 17.6935 2.89245Z' fill='white'/>
                <path d='M17.1299 4.94655C16.9585 5.11793 16.9966 5.38073 17.2098 5.49118C17.3241 5.54831 17.4307 5.55593 18.0706 5.54831C18.7828 5.53689 18.8019 5.53308 18.8971 5.44548C19.0304 5.31979 19.0342 5.07223 18.9085 4.95416C18.8247 4.87418 18.7904 4.87037 18.0135 4.87037C17.2594 4.87037 17.2022 4.87418 17.1299 4.94655Z' fill='white'/>
                <path d='M15.9111 4.9488C15.5835 5.00212 15.3055 5.16208 15.176 5.36775C15.0237 5.61531 15.0084 5.85145 15.1075 6.42655C15.1532 6.68554 15.1798 6.9293 15.1646 6.97119C15.1532 7.00928 15.0998 7.05879 15.0465 7.08164C14.818 7.16924 14.7799 7.14258 14.1591 6.52558C13.4431 5.81717 13.4431 5.81717 13.0508 6.13329C12.449 6.61699 11.7025 6.76933 10.9598 6.56367C9.8439 6.25516 8.44232 6.30468 7.29591 6.70078C5.12879 7.44346 3.56344 9.23734 3.1064 11.5035C3.03022 11.8767 3.0188 12.0443 3.0188 12.7908C3.02261 13.5335 3.03403 13.7011 3.1064 14.04C3.23208 14.6228 3.36158 15.0036 3.60533 15.5178C4.8698 18.1686 7.75295 19.6007 10.6551 19.0141C11.0893 18.9265 11.8015 18.679 12.2205 18.4657C14.2391 17.4564 15.5302 15.533 15.7283 13.2402C15.7778 12.6727 15.7359 11.9986 15.6254 11.4844C15.595 11.3435 15.5416 11.115 15.5112 10.9703C15.435 10.6237 15.4388 10.3076 15.5264 9.96098C15.6178 9.60678 15.6978 9.44681 15.9682 9.09261C16.2843 8.66985 16.2767 8.64319 15.7587 8.12521L15.3398 7.70626L15.4464 7.65294C15.5988 7.57677 15.6826 7.49298 15.7625 7.34063C15.8768 7.11211 15.8882 6.87217 15.7968 6.35419C15.7511 6.0952 15.7245 5.84383 15.7359 5.80194C15.7625 5.69148 15.9035 5.63435 16.2234 5.60388C16.4367 5.58484 16.5167 5.56199 16.5852 5.49343C16.7147 5.36394 16.7033 5.16208 16.5624 5.01735C16.4405 4.89548 16.3224 4.88405 15.9111 4.9488ZM10.0686 8.31564C11.8739 8.63176 13.2526 9.9229 13.744 11.7625C13.8544 12.17 13.8849 13.1069 13.8049 13.5716C13.4926 15.3464 12.1862 16.7709 10.4533 17.2279C9.10883 17.5821 7.74534 17.3155 6.57989 16.4738C6.279 16.2567 5.75341 15.7082 5.54774 15.3997C4.9993 14.5809 4.75174 13.7696 4.75174 12.8099C4.75174 12.0519 4.90027 11.4159 5.23924 10.7532C5.87529 9.49252 7.1131 8.57082 8.50707 8.31945C8.91459 8.24709 9.65347 8.24328 10.0686 8.31564Z' fill='white'/>
                <path d='M8.63665 8.91123C7.79875 9.05976 7.06368 9.45205 6.46191 10.0767C5.92108 10.6365 5.58973 11.2688 5.42977 12.0305C5.36502 12.3314 5.3574 12.4875 5.37264 12.9636C5.38406 13.3102 5.41834 13.6263 5.45643 13.7634C5.77636 14.9441 6.5 15.8392 7.55119 16.3533C8.22532 16.6847 8.86136 16.8028 9.64975 16.7494C10.979 16.6542 12.2206 15.8163 12.8262 14.6052C13.1194 14.011 13.2108 13.6492 13.2337 12.9636C13.2489 12.4914 13.2413 12.3314 13.1766 12.0305C12.8681 10.5413 11.7712 9.3835 10.2934 8.98359C9.94302 8.88837 8.99847 8.84648 8.63665 8.91123ZM9.44028 9.99288C9.52026 10.0348 9.56215 10.0957 9.59643 10.2176C9.63452 10.3623 9.65737 10.3852 9.82114 10.4461C10.2515 10.5946 10.64 11.1241 10.6819 11.6116C10.7009 11.8134 10.6933 11.8439 10.6057 11.9315C10.3924 12.1448 10.0839 11.9848 10.0839 11.6611C10.0801 11.5011 9.95825 11.2612 9.82114 11.1431C9.75259 11.086 9.68022 11.0403 9.66118 11.0403C9.64214 11.0403 9.6269 11.3678 9.6269 11.821V12.6018L9.89732 12.7351C10.2134 12.8951 10.4762 13.1464 10.5905 13.394C10.6552 13.5349 10.6743 13.6454 10.6743 13.9158C10.6743 14.2129 10.659 14.2852 10.5676 14.4757C10.4229 14.7727 10.1715 15.0203 9.87446 15.1574C9.65737 15.2602 9.6269 15.2907 9.60405 15.405C9.57739 15.5497 9.43266 15.6868 9.30317 15.6868C9.17367 15.6868 9.02894 15.5497 9.00228 15.405C8.97943 15.2907 8.94896 15.2602 8.73187 15.1574C8.27864 14.9479 7.95871 14.5023 7.92063 14.0301C7.90539 13.8053 7.9092 13.7939 8.02727 13.6949C8.09202 13.6378 8.18342 13.5921 8.22532 13.5921C8.34339 13.5921 8.52239 13.7939 8.52239 13.9348C8.52239 14.1595 8.71283 14.4795 8.91468 14.5861C8.97562 14.6204 8.97943 14.5747 8.97943 13.8282V13.0322L8.72425 12.9027C8.41575 12.7465 8.14914 12.4952 8.02727 12.24C7.94729 12.0838 7.93205 11.9924 7.93205 11.7258C7.93205 11.4478 7.94729 11.3678 8.0425 11.1621C8.17961 10.8651 8.51478 10.5375 8.78519 10.4461C8.94896 10.3852 8.97181 10.3623 9.0099 10.2176C9.04037 10.1033 9.08607 10.0348 9.15844 9.99669C9.29174 9.92433 9.30317 9.92433 9.44028 9.99288Z' fill='white'/>
                <path d='M8.78506 11.1399C8.53749 11.3494 8.44609 11.7684 8.59462 12.0121C8.66318 12.1226 8.89551 12.332 8.95264 12.332C8.96787 12.332 8.9793 12.0388 8.9793 11.6846C8.9793 11.3151 8.96406 11.0371 8.94502 11.0371C8.92598 11.0371 8.85361 11.0828 8.78506 11.1399Z' fill='white'/>
                <path d='M9.62671 13.9529C9.62671 14.5776 9.63052 14.6195 9.69526 14.5852C9.99996 14.4176 10.1752 13.9187 10.0304 13.633C9.96949 13.5188 9.72573 13.2864 9.6648 13.2864C9.64194 13.2864 9.62671 13.5492 9.62671 13.9529Z' fill='white'/>
                <path d='M16.7757 5.67071C16.7338 5.69357 16.6805 5.76974 16.65 5.8421C16.6043 5.95255 16.6043 5.99064 16.65 6.09347C16.7224 6.27248 17.6441 7.25892 17.7583 7.28939C18.0249 7.35414 18.2496 7.13324 18.1811 6.87044C18.162 6.78665 17.5108 6.02492 17.2213 5.7507C17.0842 5.6212 16.9128 5.59073 16.7757 5.67071Z' fill='white'/>
            </svg>            
        ]],

        w = 21,
        h = 22
    },

    ranking = {
        raw = [[
            <svg width='21' height='22' viewBox='0 0 21 22' fill='none' xmlns='http://www.w3.org/2000/svg'>
                <path d='M5.74875 4.04673C4.17492 4.31235 2.86008 5.45122 2.30226 7.03501C2.0632 7.70571 1.98683 8.2436 2.01008 9.06372C2.03332 9.94692 2.17277 10.5047 2.56789 11.3215C3.13898 12.5002 4.155 13.6756 6.1007 15.4055C7.05031 16.2489 10.2112 18.9549 10.2777 18.9815C10.3573 19.0114 10.6429 19.0114 10.7226 18.9815C10.789 18.9549 13.9466 16.2522 14.8995 15.4055C17.4694 13.1211 18.5353 11.6768 18.9005 9.99009C18.9935 9.57173 19.0267 8.61548 18.9669 8.16724C18.8175 7.04497 18.3892 6.11196 17.6819 5.35825C16.8353 4.45845 15.7562 3.99692 14.4978 3.99692C13.5681 3.99692 12.8077 4.24263 12.0573 4.78052C11.5726 5.13247 10.9816 5.78657 10.6462 6.3477C10.5798 6.4606 10.5134 6.55356 10.5001 6.55356C10.4868 6.55356 10.4204 6.4606 10.354 6.3477C10.1482 6.00903 9.79289 5.55747 9.48742 5.252C8.83664 4.60454 8.06301 4.1895 7.24953 4.05005C6.87433 3.98696 6.1173 3.98364 5.74875 4.04673Z' fill='white'/>
            </svg>            
        ]],

        w = 21,
        h = 21
    },

    detail = {
        raw = [[
            <svg width='479' height='122' viewBox='0 0 479 122' fill='none' xmlns='http://www.w3.org/2000/svg'>
            </svg>            
        ]],

        w = 479,
        h = 122
    },

    list = {
        raw = [[
            <svg width='27' height='27' viewBox='0 0 27 27' fill='none' xmlns='http://www.w3.org/2000/svg'>
                <path d='M1.64371 22.9016C1.53707 22.8406 1.4071 22.7188 1.30713 22.5781C0.773924 21.8281 0.963878 20.4594 1.65371 20.0984L1.84033 20H9.00193H16.1635L16.3502 20.0984C17.2166 20.5531 17.2166 22.4469 16.3502 22.9016L16.1635 23L8.99194 22.9953C1.86699 22.9953 1.82034 22.9953 1.64371 22.9016Z' fill='#B5B5B5'/>
                <path d='M1.72418 14.9016C1.60421 14.8406 1.45799 14.7188 1.34552 14.5781C0.745664 13.8281 0.959362 12.4594 1.73542 12.0984L1.94537 12H10.0022H18.059L18.2689 12.0984C19.2437 12.5531 19.2437 14.4469 18.2689 14.9016L18.059 15L9.99093 14.9953C1.97537 14.9953 1.92288 14.9953 1.72418 14.9016Z' fill='#B5B5B5'/>
                <path d='M1.85627 6.63926C1.68752 6.5707 1.48185 6.43359 1.32365 6.27539C0.4799 5.43164 0.780486 3.8918 1.87209 3.48574L2.1674 3.375H13.5H24.8326L25.1279 3.48574C26.499 3.99727 26.499 6.12773 25.1279 6.63926L24.8326 6.75L13.4842 6.74473C2.20959 6.74473 2.13576 6.74473 1.85627 6.63926Z' fill='#B5B5B5'/>
            </svg>
        ]],

        w = 27,
        h = 27
    },

    slot = {
        raw = [[
            <svg width='61' height='65' viewBox='0 0 61 65' fill='none' xmlns='http://www.w3.org/2000/svg'>
                <rect x='0.25' y='0.25' width='60.5' height='64.5' rx='4.75' fill='url(#paint0_linear_1368_364)' stroke='#495B6D' stroke-width='0.5'/>

                <defs>
                    <linearGradient id='paint0_linear_1368_364' x1='2.25926' y1='12.8879' x2='47.6881' y2='53.5912' gradientUnits='userSpaceOnUse'>
                        <stop stop-color='#1A252D'/>
                        <stop offset='0.295242' stop-color='#141E26'/>
                        <stop offset='0.76036' stop-color='#111A21'/>
                        <stop offset='1' stop-color='#121D26'/>
                    </linearGradient>
                </defs>
            </svg>
        ]],

        w = 61,
        h = 65
    },

    top_1 = {
        raw = [[
            <svg width='29' height='29' viewBox='0 0 29 29' fill='none' xmlns='http://www.w3.org/2000/svg'>
                <path d='M13.7127 3.22656L13.1293 3.56641L12.4439 3.44746C12.0644 3.38516 11.7019 3.34551 11.6283 3.3625C11.5603 3.38516 11.2884 3.6457 11.0279 3.95156L10.5464 4.50664L9.88375 4.62559C9.52125 4.69355 9.16442 4.78418 9.09645 4.83516C9.01149 4.8918 8.88688 5.13535 8.72262 5.58848L8.4734 6.2625L7.93532 6.56836C7.13102 7.02148 7.13668 7.02148 7.13668 7.68418C7.13668 8.53945 7.11969 8.59043 6.64957 9.1625C6.41735 9.4457 6.21344 9.7459 6.19645 9.83652C6.17379 9.94414 6.24176 10.2104 6.39469 10.6465L6.62692 11.2979L6.38903 11.9775C6.23043 12.4477 6.16813 12.7082 6.19078 12.8102C6.21344 12.8895 6.42867 13.1953 6.66657 13.4842L7.10836 14.0053L7.12535 14.7529C7.14235 15.1834 7.17633 15.5289 7.21598 15.5799C7.24996 15.6309 7.55016 15.8291 7.87867 16.0217L8.48473 16.3729L8.6943 16.9732C8.81324 17.3018 8.96617 17.6303 9.02848 17.7096C9.14742 17.8455 9.4193 17.9191 10.3709 18.0891C10.5295 18.1174 10.6314 18.1967 10.8636 18.4799C11.413 19.1596 11.5263 19.2559 11.7302 19.2559C11.8379 19.2559 12.1947 19.2162 12.5232 19.1596L13.1236 19.0689L13.7466 19.4145C14.0865 19.607 14.4263 19.7656 14.5 19.7656C14.5736 19.7656 14.9134 19.607 15.2533 19.4145L15.8763 19.0689L16.4767 19.1596C16.8052 19.2162 17.1621 19.2559 17.2697 19.2559C17.4736 19.2559 17.5869 19.1596 18.1363 18.4799C18.2949 18.2873 18.4761 18.1174 18.5441 18.1061C18.6064 18.0891 18.9179 18.0324 19.2295 17.9758C19.9488 17.8512 20.0111 17.7889 20.3056 16.9732L20.5209 16.3672L21.0873 16.0443C21.3988 15.8687 21.6933 15.6762 21.75 15.6195C21.8349 15.5289 21.8519 15.376 21.8746 14.7586L21.8916 14.0053L22.3334 13.4842C22.5713 13.1953 22.7865 12.8895 22.8091 12.8102C22.8318 12.7082 22.7695 12.4477 22.6109 11.9775L22.373 11.2979L22.6052 10.6465C22.7582 10.2104 22.8261 9.94414 22.8035 9.83652C22.7865 9.7459 22.5826 9.4457 22.3504 9.1625C21.8802 8.59043 21.8632 8.53945 21.8632 7.68418C21.8632 7.02148 21.8689 7.02148 21.0646 6.56836L20.5265 6.2625L20.283 5.58848C20.113 5.12402 19.9998 4.8918 19.9091 4.83516C19.8355 4.78984 19.4787 4.69355 19.1162 4.62559L18.4535 4.50664L17.972 3.95156C17.7115 3.6457 17.4396 3.38516 17.3716 3.3625C17.298 3.34551 16.9355 3.38516 16.556 3.44746L15.8707 3.56641L15.2816 3.22656C14.8681 2.99434 14.6246 2.88672 14.4943 2.88672C14.364 2.88672 14.1148 3 13.7127 3.22656ZM16.0519 5.34492C20.5832 6.55137 22.1861 12.1248 18.9859 15.5289C17.6888 16.9109 15.7291 17.6529 13.9222 17.4547C10.8353 17.1205 8.49039 14.6566 8.34313 11.6037C8.18453 8.4375 10.4672 5.69043 13.6787 5.18633C13.775 5.175 14.2168 5.16934 14.6699 5.18066C15.3382 5.19199 15.5931 5.22598 16.0519 5.34492Z' fill='#FFE074'/>
                <path d='M13.6333 6.11405C12.9197 6.24432 12.0871 6.5785 11.5037 6.97499C11.1242 7.23553 10.5011 7.84725 10.2179 8.24374C9.89507 8.69686 9.5439 9.43319 9.39663 9.99393C9.29468 10.3621 9.27202 10.6113 9.26636 11.2967C9.26636 12.2369 9.36265 12.7467 9.6855 13.4547C10.6371 15.5617 12.846 16.8135 15.1117 16.5359C17.2867 16.2697 19.0312 14.7517 19.6089 12.6221C19.7845 11.9537 19.7845 10.6623 19.6033 9.99393C19.3541 9.0537 18.8386 8.18709 18.1476 7.5244C17.4906 6.90135 16.8166 6.51053 15.933 6.24999C15.5308 6.13104 15.2873 6.09706 14.6699 6.08573C14.2507 6.0744 13.7806 6.08573 13.6333 6.11405Z' fill='#FFE074'/>
                <path d='M6.62692 20.4566C5.83395 21.799 5.15993 22.9602 5.13727 23.0338C5.02399 23.3453 5.26755 23.6738 5.60173 23.6738C5.71501 23.6738 6.35505 23.6002 7.02341 23.5039C7.69177 23.4133 8.25817 23.334 8.27517 23.334C8.29782 23.334 8.52438 23.9004 8.77927 24.5914C9.28337 25.9564 9.37966 26.1094 9.71384 26.1094C9.83278 26.1094 9.95739 26.0584 10.048 25.9791C10.1273 25.9111 10.8806 24.682 11.7246 23.249C12.5742 21.816 13.3162 20.5643 13.3728 20.4623L13.4804 20.2867L13.2256 20.1451C12.9707 19.9979 12.965 19.9979 12.5402 20.0828C11.5093 20.2754 11.1129 20.1508 10.5011 19.4314C10.2859 19.1766 10.0707 18.9613 10.0254 18.95C9.98005 18.9387 9.70251 18.882 9.41364 18.8311C8.82458 18.7178 8.50173 18.5422 8.27517 18.208C8.20153 18.1004 8.1279 18.0098 8.10524 18.0098C8.08825 18.0154 7.41989 19.1143 6.62692 20.4566Z' fill='#FFE074'/>
                <path d='M20.6172 18.3043C20.3227 18.6441 20.1584 18.7234 19.4391 18.8594C19.1445 18.916 18.8727 18.9953 18.833 19.0406C18.799 19.0803 18.6178 19.2898 18.4309 19.5051C17.8814 20.1451 17.4566 20.2697 16.4598 20.0828C16.035 19.9979 16.0293 19.9979 15.7744 20.1451L15.5195 20.2867L15.6271 20.4623C15.6838 20.5643 16.4258 21.816 17.2754 23.249C18.1193 24.682 18.8727 25.9111 18.952 25.9848C19.0426 26.0584 19.1672 26.1094 19.2861 26.1094C19.6203 26.1094 19.7166 25.9564 20.2207 24.5914C20.4813 23.9004 20.7191 23.334 20.7531 23.334C20.7871 23.334 21.3479 23.4133 22.0049 23.5039C22.6562 23.6002 23.285 23.6738 23.3982 23.6738C23.7324 23.6738 23.976 23.3453 23.8627 23.0338C23.8061 22.8639 20.94 18.0154 20.9004 18.0154C20.8834 18.0154 20.7588 18.1457 20.6172 18.3043Z' fill='#FFE074'/>
            </svg>
        ]],

        w = 29,
        h = 29
    },

    top_2 = {
        raw = [[
            <svg width='29' height='29' viewBox='0 0 29 29' fill='none' xmlns='http://www.w3.org/2000/svg'>
                <path d='M13.7127 3.22656L13.1293 3.56641L12.4439 3.44746C12.0644 3.38516 11.7019 3.34551 11.6283 3.3625C11.5603 3.38516 11.2884 3.6457 11.0279 3.95156L10.5464 4.50664L9.88375 4.62559C9.52125 4.69355 9.16442 4.78418 9.09645 4.83516C9.01149 4.8918 8.88688 5.13535 8.72262 5.58848L8.4734 6.2625L7.93532 6.56836C7.13102 7.02148 7.13668 7.02148 7.13668 7.68418C7.13668 8.53945 7.11969 8.59043 6.64957 9.1625C6.41735 9.4457 6.21344 9.7459 6.19645 9.83652C6.17379 9.94414 6.24176 10.2104 6.39469 10.6465L6.62692 11.2979L6.38903 11.9775C6.23043 12.4477 6.16813 12.7082 6.19078 12.8102C6.21344 12.8895 6.42867 13.1953 6.66657 13.4842L7.10836 14.0053L7.12535 14.7529C7.14235 15.1834 7.17633 15.5289 7.21598 15.5799C7.24996 15.6309 7.55016 15.8291 7.87867 16.0217L8.48473 16.3729L8.6943 16.9732C8.81324 17.3018 8.96617 17.6303 9.02848 17.7096C9.14742 17.8455 9.4193 17.9191 10.3709 18.0891C10.5295 18.1174 10.6314 18.1967 10.8636 18.4799C11.413 19.1596 11.5263 19.2559 11.7302 19.2559C11.8379 19.2559 12.1947 19.2162 12.5232 19.1596L13.1236 19.0689L13.7466 19.4145C14.0865 19.607 14.4263 19.7656 14.5 19.7656C14.5736 19.7656 14.9134 19.607 15.2533 19.4145L15.8763 19.0689L16.4767 19.1596C16.8052 19.2162 17.1621 19.2559 17.2697 19.2559C17.4736 19.2559 17.5869 19.1596 18.1363 18.4799C18.2949 18.2873 18.4761 18.1174 18.5441 18.1061C18.6064 18.0891 18.9179 18.0324 19.2295 17.9758C19.9488 17.8512 20.0111 17.7889 20.3056 16.9732L20.5209 16.3672L21.0873 16.0443C21.3988 15.8687 21.6933 15.6762 21.75 15.6195C21.8349 15.5289 21.8519 15.376 21.8746 14.7586L21.8916 14.0053L22.3334 13.4842C22.5713 13.1953 22.7865 12.8895 22.8091 12.8102C22.8318 12.7082 22.7695 12.4477 22.6109 11.9775L22.373 11.2979L22.6052 10.6465C22.7582 10.2104 22.8261 9.94414 22.8035 9.83652C22.7865 9.7459 22.5826 9.4457 22.3504 9.1625C21.8802 8.59043 21.8632 8.53945 21.8632 7.68418C21.8632 7.02148 21.8689 7.02148 21.0646 6.56836L20.5265 6.2625L20.283 5.58848C20.113 5.12402 19.9998 4.8918 19.9091 4.83516C19.8355 4.78984 19.4787 4.69355 19.1162 4.62559L18.4535 4.50664L17.972 3.95156C17.7115 3.6457 17.4396 3.38516 17.3716 3.3625C17.298 3.34551 16.9355 3.38516 16.556 3.44746L15.8707 3.56641L15.2816 3.22656C14.8681 2.99434 14.6246 2.88672 14.4943 2.88672C14.364 2.88672 14.1148 3 13.7127 3.22656ZM16.0519 5.34492C20.5832 6.55137 22.1861 12.1248 18.9859 15.5289C17.6888 16.9109 15.7291 17.6529 13.9222 17.4547C10.8353 17.1205 8.49039 14.6566 8.34313 11.6037C8.18453 8.4375 10.4672 5.69043 13.6787 5.18633C13.775 5.175 14.2168 5.16934 14.6699 5.18066C15.3382 5.19199 15.5931 5.22598 16.0519 5.34492Z' fill='#D0D0D0'/>
                <path d='M13.6333 6.11405C12.9197 6.24432 12.0871 6.5785 11.5037 6.97499C11.1242 7.23553 10.5011 7.84725 10.2179 8.24374C9.89507 8.69686 9.5439 9.43319 9.39663 9.99393C9.29468 10.3621 9.27202 10.6113 9.26636 11.2967C9.26636 12.2369 9.36265 12.7467 9.6855 13.4547C10.6371 15.5617 12.846 16.8135 15.1117 16.5359C17.2867 16.2697 19.0312 14.7517 19.6089 12.6221C19.7845 11.9537 19.7845 10.6623 19.6033 9.99393C19.3541 9.0537 18.8386 8.18709 18.1476 7.5244C17.4906 6.90135 16.8166 6.51053 15.933 6.24999C15.5308 6.13104 15.2873 6.09706 14.6699 6.08573C14.2507 6.0744 13.7806 6.08573 13.6333 6.11405Z' fill='#D0D0D0'/>
                <path d='M6.62692 20.4566C5.83395 21.799 5.15993 22.9602 5.13727 23.0338C5.02399 23.3453 5.26755 23.6738 5.60173 23.6738C5.71501 23.6738 6.35505 23.6002 7.02341 23.5039C7.69177 23.4133 8.25817 23.334 8.27517 23.334C8.29782 23.334 8.52438 23.9004 8.77927 24.5914C9.28337 25.9564 9.37966 26.1094 9.71384 26.1094C9.83278 26.1094 9.95739 26.0584 10.048 25.9791C10.1273 25.9111 10.8806 24.682 11.7246 23.249C12.5742 21.816 13.3162 20.5643 13.3728 20.4623L13.4804 20.2867L13.2256 20.1451C12.9707 19.9979 12.965 19.9979 12.5402 20.0828C11.5093 20.2754 11.1129 20.1508 10.5011 19.4314C10.2859 19.1766 10.0707 18.9613 10.0254 18.95C9.98005 18.9387 9.70251 18.882 9.41364 18.8311C8.82458 18.7178 8.50173 18.5422 8.27517 18.208C8.20153 18.1004 8.1279 18.0098 8.10524 18.0098C8.08825 18.0154 7.41989 19.1143 6.62692 20.4566Z' fill='#D0D0D0'/>
                <path d='M20.6172 18.3043C20.3227 18.6441 20.1584 18.7234 19.4391 18.8594C19.1445 18.916 18.8727 18.9953 18.833 19.0406C18.799 19.0803 18.6178 19.2898 18.4309 19.5051C17.8814 20.1451 17.4566 20.2697 16.4598 20.0828C16.035 19.9979 16.0293 19.9979 15.7744 20.1451L15.5195 20.2867L15.6271 20.4623C15.6838 20.5643 16.4258 21.816 17.2754 23.249C18.1193 24.682 18.8727 25.9111 18.952 25.9848C19.0426 26.0584 19.1672 26.1094 19.2861 26.1094C19.6203 26.1094 19.7166 25.9564 20.2207 24.5914C20.4813 23.9004 20.7191 23.334 20.7531 23.334C20.7871 23.334 21.3479 23.4133 22.0049 23.5039C22.6562 23.6002 23.285 23.6738 23.3982 23.6738C23.7324 23.6738 23.976 23.3453 23.8627 23.0338C23.8061 22.8639 20.94 18.0154 20.9004 18.0154C20.8834 18.0154 20.7588 18.1457 20.6172 18.3043Z' fill='#D0D0D0'/>
            </svg>
        ]],

        w = 29,
        h = 29
    },

    top_3 = {
        raw = [[
            <svg width='29' height='29' viewBox='0 0 29 29' fill='none' xmlns='http://www.w3.org/2000/svg'>
                <path d='M13.7127 3.22656L13.1293 3.56641L12.4439 3.44746C12.0644 3.38516 11.7019 3.34551 11.6283 3.3625C11.5603 3.38516 11.2884 3.6457 11.0279 3.95156L10.5464 4.50664L9.88375 4.62559C9.52125 4.69355 9.16442 4.78418 9.09645 4.83516C9.01149 4.8918 8.88688 5.13535 8.72262 5.58848L8.4734 6.2625L7.93532 6.56836C7.13102 7.02148 7.13668 7.02148 7.13668 7.68418C7.13668 8.53945 7.11969 8.59043 6.64957 9.1625C6.41735 9.4457 6.21344 9.7459 6.19645 9.83652C6.17379 9.94414 6.24176 10.2104 6.39469 10.6465L6.62692 11.2979L6.38903 11.9775C6.23043 12.4477 6.16813 12.7082 6.19078 12.8102C6.21344 12.8895 6.42867 13.1953 6.66657 13.4842L7.10836 14.0053L7.12535 14.7529C7.14235 15.1834 7.17633 15.5289 7.21598 15.5799C7.24996 15.6309 7.55016 15.8291 7.87867 16.0217L8.48473 16.3729L8.6943 16.9732C8.81324 17.3018 8.96617 17.6303 9.02848 17.7096C9.14742 17.8455 9.4193 17.9191 10.3709 18.0891C10.5295 18.1174 10.6314 18.1967 10.8636 18.4799C11.413 19.1596 11.5263 19.2559 11.7302 19.2559C11.8379 19.2559 12.1947 19.2162 12.5232 19.1596L13.1236 19.0689L13.7466 19.4145C14.0865 19.607 14.4263 19.7656 14.5 19.7656C14.5736 19.7656 14.9134 19.607 15.2533 19.4145L15.8763 19.0689L16.4767 19.1596C16.8052 19.2162 17.1621 19.2559 17.2697 19.2559C17.4736 19.2559 17.5869 19.1596 18.1363 18.4799C18.2949 18.2873 18.4761 18.1174 18.5441 18.1061C18.6064 18.0891 18.9179 18.0324 19.2295 17.9758C19.9488 17.8512 20.0111 17.7889 20.3056 16.9732L20.5209 16.3672L21.0873 16.0443C21.3988 15.8687 21.6933 15.6762 21.75 15.6195C21.8349 15.5289 21.8519 15.376 21.8746 14.7586L21.8916 14.0053L22.3334 13.4842C22.5713 13.1953 22.7865 12.8895 22.8091 12.8102C22.8318 12.7082 22.7695 12.4477 22.6109 11.9775L22.373 11.2979L22.6052 10.6465C22.7582 10.2104 22.8261 9.94414 22.8035 9.83652C22.7865 9.7459 22.5826 9.4457 22.3504 9.1625C21.8802 8.59043 21.8632 8.53945 21.8632 7.68418C21.8632 7.02148 21.8689 7.02148 21.0646 6.56836L20.5265 6.2625L20.283 5.58848C20.113 5.12402 19.9998 4.8918 19.9091 4.83516C19.8355 4.78984 19.4787 4.69355 19.1162 4.62559L18.4535 4.50664L17.972 3.95156C17.7115 3.6457 17.4396 3.38516 17.3716 3.3625C17.298 3.34551 16.9355 3.38516 16.556 3.44746L15.8707 3.56641L15.2816 3.22656C14.8681 2.99434 14.6246 2.88672 14.4943 2.88672C14.364 2.88672 14.1148 3 13.7127 3.22656ZM16.0519 5.34492C20.5832 6.55137 22.1861 12.1248 18.9859 15.5289C17.6888 16.9109 15.7291 17.6529 13.9222 17.4547C10.8353 17.1205 8.49039 14.6566 8.34313 11.6037C8.18453 8.4375 10.4672 5.69043 13.6787 5.18633C13.775 5.175 14.2168 5.16934 14.6699 5.18066C15.3382 5.19199 15.5931 5.22598 16.0519 5.34492Z' fill='#C49674'/>
                <path d='M13.6333 6.11405C12.9197 6.24432 12.0871 6.5785 11.5037 6.97499C11.1242 7.23553 10.5011 7.84725 10.2179 8.24374C9.89507 8.69686 9.5439 9.43319 9.39663 9.99393C9.29468 10.3621 9.27202 10.6113 9.26636 11.2967C9.26636 12.2369 9.36265 12.7467 9.6855 13.4547C10.6371 15.5617 12.846 16.8135 15.1117 16.5359C17.2867 16.2697 19.0312 14.7517 19.6089 12.6221C19.7845 11.9537 19.7845 10.6623 19.6033 9.99393C19.3541 9.0537 18.8386 8.18709 18.1476 7.5244C17.4906 6.90135 16.8166 6.51053 15.933 6.24999C15.5308 6.13104 15.2873 6.09706 14.6699 6.08573C14.2507 6.0744 13.7806 6.08573 13.6333 6.11405Z' fill='#C49674'/>
                <path d='M6.62692 20.4566C5.83395 21.799 5.15993 22.9602 5.13727 23.0338C5.02399 23.3453 5.26755 23.6738 5.60173 23.6738C5.71501 23.6738 6.35505 23.6002 7.02341 23.5039C7.69177 23.4133 8.25817 23.334 8.27517 23.334C8.29782 23.334 8.52438 23.9004 8.77927 24.5914C9.28337 25.9564 9.37966 26.1094 9.71384 26.1094C9.83278 26.1094 9.95739 26.0584 10.048 25.9791C10.1273 25.9111 10.8806 24.682 11.7246 23.249C12.5742 21.816 13.3162 20.5643 13.3728 20.4623L13.4804 20.2867L13.2256 20.1451C12.9707 19.9979 12.965 19.9979 12.5402 20.0828C11.5093 20.2754 11.1129 20.1508 10.5011 19.4314C10.2859 19.1766 10.0707 18.9613 10.0254 18.95C9.98005 18.9387 9.70251 18.882 9.41364 18.8311C8.82458 18.7178 8.50173 18.5422 8.27517 18.208C8.20153 18.1004 8.1279 18.0098 8.10524 18.0098C8.08825 18.0154 7.41989 19.1143 6.62692 20.4566Z' fill='#C49674'/>
                <path d='M20.6172 18.3043C20.3227 18.6441 20.1584 18.7234 19.4391 18.8594C19.1445 18.916 18.8727 18.9953 18.833 19.0406C18.799 19.0803 18.6178 19.2898 18.4309 19.5051C17.8814 20.1451 17.4566 20.2697 16.4598 20.0828C16.035 19.9979 16.0293 19.9979 15.7744 20.1451L15.5195 20.2867L15.6271 20.4623C15.6838 20.5643 16.4258 21.816 17.2754 23.249C18.1193 24.682 18.8727 25.9111 18.952 25.9848C19.0426 26.0584 19.1672 26.1094 19.2861 26.1094C19.6203 26.1094 19.7166 25.9564 20.2207 24.5914C20.4813 23.9004 20.7191 23.334 20.7531 23.334C20.7871 23.334 21.3479 23.4133 22.0049 23.5039C22.6562 23.6002 23.285 23.6738 23.3982 23.6738C23.7324 23.6738 23.976 23.3453 23.8627 23.0338C23.8061 22.8639 20.94 18.0154 20.9004 18.0154C20.8834 18.0154 20.7588 18.1457 20.6172 18.3043Z' fill='#C49674'/>
            </svg>            
        ]],

        w = 29,
        h = 29
    },

    close = {
        raw = [[
            <svg width='28' height='28' viewBox='0 0 28 28' fill='none' xmlns='http://www.w3.org/2000/svg'>
                <path fill-rule='evenodd' clip-rule='evenodd' d='M23.8995 6.92714C24.2746 6.55207 24.4853 6.04336 24.4853 5.51293C24.4853 4.98249 24.2746 4.47379 23.8995 4.09871C23.5244 3.72364 23.0157 3.51293 22.4853 3.51293C21.9548 3.51293 21.4461 3.72364 21.0711 4.09871L14 11.1698L6.92893 4.09871C6.55386 3.72364 6.04515 3.51293 5.51472 3.51293C4.98429 3.51293 4.47558 3.72364 4.10051 4.09871C3.72543 4.47379 3.51472 4.98249 3.51472 5.51293C3.51472 6.04336 3.72543 6.55207 4.10051 6.92714L11.1716 13.9982L4.1005 21.0693C3.72543 21.4443 3.51472 21.9531 3.51472 22.4835C3.51472 23.0139 3.72543 23.5226 4.10051 23.8977C4.47558 24.2728 4.98429 24.4835 5.51472 24.4835C6.04515 24.4835 6.55386 24.2728 6.92893 23.8977L14 16.8266L21.0711 23.8977C21.4461 24.2728 21.9548 24.4835 22.4853 24.4835C23.0157 24.4835 23.5244 24.2728 23.8995 23.8977C24.2746 23.5226 24.4853 23.0139 24.4853 22.4835C24.4853 21.9531 24.2746 21.4443 23.8995 21.0693L16.8284 13.9982L23.8995 6.92714Z' fill='white'/>
            </svg>
        ]],

        w = 28,
        h = 28
    },

    clock = {
        raw = [[
            <svg width='19' height='19' viewBox='0 0 19 19' fill='none' xmlns='http://www.w3.org/2000/svg'>
                <path d='M8.3125 1.1875V2.00391H8.70215H9.0918V2.18945V2.375H9.5H9.9082V2.18945V2.00391H10.2979H10.6875V1.1875V0.371094H9.5H8.3125V1.1875Z' fill='#C1C1C1'/>
                <path d='M3.1729 0.764453C2.03364 0.95 1.15786 1.72187 0.846143 2.80918C0.727393 3.22109 0.727393 3.90391 0.846143 4.31582C0.935205 4.63125 1.05767 4.89473 1.23579 5.1582C1.3731 5.35859 1.92603 5.9375 1.98169 5.9375C2.00396 5.9375 2.3936 5.56641 2.84634 5.11367L3.67388 4.28984L3.83716 4.44941L4.00415 4.6127L4.21567 4.43086C4.33071 4.33066 4.47915 4.20449 4.54224 4.14883L4.65728 4.05234L4.4606 3.84824L4.26392 3.64785L5.09888 2.83887C5.55903 2.39355 5.93755 2.00762 5.93755 1.98535C5.93755 1.92598 5.36235 1.37676 5.15825 1.23574C4.70181 0.927734 4.24907 0.783008 3.67388 0.760742C3.45864 0.75332 3.23599 0.757031 3.1729 0.764453Z' fill='#C1C1C1'/>
                <path d='M15.0479 0.764453C14.6322 0.83125 14.1721 1.00938 13.8529 1.22832C13.6451 1.36934 13.0625 1.92598 13.0625 1.98164C13.0625 2.00391 13.4336 2.39355 13.8863 2.84629L14.7139 3.67383L14.532 3.85566C14.4318 3.95586 14.3576 4.05234 14.365 4.0709C14.3836 4.11914 14.9439 4.60156 14.9811 4.60156C14.9959 4.60156 15.0812 4.53105 15.1666 4.4457L15.3262 4.28984L16.1537 5.11367C16.6064 5.56641 16.9961 5.9375 17.0184 5.9375C17.074 5.9375 17.6307 5.35488 17.7717 5.14707C17.9275 4.91699 18.0871 4.56445 18.1687 4.26387C18.2615 3.93359 18.2615 3.19141 18.1687 2.86113C17.8979 1.87031 17.1668 1.12441 16.2094 0.853516C15.9422 0.775586 15.2854 0.727344 15.0479 0.764453Z' fill='#C1C1C1'/>
                <path d='M8.49805 3.21444C5.42539 3.63007 3.04668 5.95311 2.46406 9.11112C2.4084 9.408 2.39355 9.65663 2.39726 10.3543C2.39726 11.1558 2.40469 11.2635 2.49746 11.6939C2.80547 13.1412 3.46601 14.3547 4.5125 15.3863C6.1082 16.9598 8.38301 17.6908 10.6133 17.3457C12.8955 16.9932 14.8549 15.5719 15.8939 13.5086C16.6732 11.9648 16.8514 10.2764 16.4209 8.56561C15.7715 6.01249 13.8195 4.016 11.3406 3.37772C10.4982 3.16249 9.37012 3.09569 8.49805 3.21444ZM10.1234 4.01229C12.9363 4.3203 15.1443 6.34647 15.7047 9.1371C15.816 9.69374 15.8271 10.8516 15.7232 11.3748C15.4375 12.8109 14.7955 13.9799 13.7639 14.9299C12.71 15.9021 11.3332 16.4959 9.93418 16.5812C9.41094 16.6146 8.73555 16.5775 8.33105 16.4959C5.72598 15.9726 3.8 14.0207 3.27676 11.3748C3.17285 10.8478 3.18398 9.69003 3.29531 9.1371C3.6998 7.14803 4.9207 5.53378 6.69824 4.64686C7.76328 4.11249 8.98789 3.88612 10.1234 4.01229Z' fill='#C1C1C1'/>
                <path d='M8.75797 4.77793C7.83395 4.92637 7.08805 5.21582 6.35328 5.70195C5.89684 6.00625 5.20289 6.71133 4.88746 7.18633C3.41793 9.40176 3.68883 12.3148 5.52946 14.1814C6.60192 15.265 7.9861 15.8477 9.50016 15.8477C11.556 15.8477 13.4115 14.7381 14.406 12.916C14.8588 12.0922 15.1074 10.9529 15.0517 10.0029C14.9664 8.64473 14.4468 7.43125 13.5525 6.48867C12.6656 5.55723 11.53 4.96348 10.3017 4.79277C10.0308 4.75566 8.96207 4.74453 8.75797 4.77793ZM9.76364 6.08418L9.87125 6.1918V7.90254V9.61328L10.016 9.74688C10.1904 9.90273 10.298 10.1811 10.2646 10.3852C10.2423 10.5225 10.2461 10.5262 11.0402 11.3203C11.7935 12.0773 11.838 12.1293 11.838 12.2592C11.838 12.5115 11.6265 12.6934 11.4039 12.6377C11.3371 12.6229 11.0179 12.3334 10.5207 11.8398L9.74137 11.068L9.49645 11.0531C9.30348 11.042 9.21442 11.016 9.09567 10.9381C8.67262 10.6598 8.61696 10.1217 8.96578 9.76543L9.12906 9.60215V7.89883V6.1918L9.23668 6.08418C9.32203 5.99883 9.3777 5.97656 9.50016 5.97656C9.62262 5.97656 9.67828 5.99883 9.76364 6.08418Z' fill='#C1C1C1'/>
                <path d='M3.69609 15.7783C3.60703 16.1754 3.33984 17.7674 3.33984 17.8935C3.33984 18.2572 3.61816 18.5578 3.98555 18.5875C4.33437 18.6172 4.4123 18.5652 5.09512 17.8972C5.43652 17.5596 5.71484 17.2701 5.71484 17.2553C5.71484 17.2367 5.63691 17.181 5.54043 17.1217C4.98008 16.8025 4.43086 16.3869 3.98184 15.949C3.72949 15.7041 3.71465 15.693 3.69609 15.7783Z' fill='#C1C1C1'/>
                <path d='M14.6955 16.2262C14.2984 16.5861 13.6416 17.0389 13.1777 17.2764L12.9773 17.3766L13.5117 17.9109C14.0832 18.4824 14.2464 18.5938 14.521 18.5938C14.74 18.5938 14.8699 18.5418 15.0257 18.3971C15.1742 18.2523 15.2521 18.0891 15.2521 17.8998C15.2521 17.7477 14.9107 16.0703 14.881 16.0703C14.8699 16.074 14.7882 16.1408 14.6955 16.2262Z' fill='#C1C1C1'/>
            </svg>
        ]],

        w = 19,
        h = 19
    }
}

icon = {}
function createIcons()
    for i, v in pairs(icons) do
        icon[i] = svgCreate(v.w, v.h, v.raw)
    end
end

function destroyIcons()
    for i in pairs(icons) do
        if icon[i] then
            icon[i]:destroy()
        end
    end
end