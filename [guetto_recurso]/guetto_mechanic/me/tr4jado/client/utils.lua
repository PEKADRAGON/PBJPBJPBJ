screen = Vector2(guiGetScreenSize())
scale = math.min(screen.y / 1080, 2)

if math.abs(screen.x / screen.y) < 1.7 then
    scale = math.min(screen.x / 1920, 2)
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

function destroyRectangles()
    for i in pairs(rectangles) do
        rectangles[i]:destroy()
        rectangles[i] = nil
    end

    for i in pairs(strokes) do
        strokes[i]:destroy()
        strokes[i] = nil
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

            dxDrawRectangle(x, trackY, w, trackHeight, trackColor)
            dxDrawRectangle(x, gripY, w, gripHeight, gripColor)

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
    repair = {
        raw = [[
            <svg width='28' height='28' viewBox='0 0 28 28' fill='none' xmlns='http://www.w3.org/2000/svg'>
                <path d='M21.2656 2.07391C20.675 2.23329 20.164 2.57079 19.7656 3.05829L19.5218 3.35829H13.5125H7.50308L7.33902 3.18954C6.94058 2.78173 6.37808 2.55673 5.74527 2.55204C5.07964 2.55204 4.55933 2.76298 4.09527 3.23173C2.82027 4.52079 3.41558 6.67235 5.17339 7.13173C5.48277 7.21141 5.96089 7.22079 6.26558 7.15048C6.58902 7.07548 7.01558 6.85516 7.28277 6.6161L7.52183 6.40516H13.5406H19.5546L19.6671 6.56923C19.7281 6.66298 19.9062 6.85516 20.0656 7.00516C21.3406 8.1911 23.4171 7.95204 24.3828 6.5036C24.5 6.32548 24.5937 6.17079 24.5937 6.15673C24.5937 6.14266 24.0921 6.12391 23.4828 6.11454C22.4046 6.10048 22.3578 6.09579 22.1375 5.98329C21.889 5.85673 21.7343 5.69266 21.589 5.41141C21.2843 4.8161 21.5609 4.03798 22.175 3.75204C22.4046 3.64423 22.4562 3.63954 23.5062 3.63954C24.1062 3.63954 24.5937 3.62079 24.5937 3.59735C24.5937 3.49423 24.1906 2.96454 23.9234 2.72079C23.6187 2.43954 23.0796 2.1536 22.6625 2.05048C22.3578 1.98016 21.575 1.98954 21.2656 2.07391ZM6.6312 4.36141L6.92652 4.87235L6.6312 5.3786L6.34058 5.88954H5.74058H5.14527L4.96245 5.57079C4.85933 5.39735 4.72808 5.16766 4.66714 5.06454L4.55933 4.87235L4.85933 4.34735L5.15933 3.82235L5.74995 3.83641L6.33589 3.85048L6.6312 4.36141Z' fill='white'/>
                <path d='M8.71713 10.4422C7.91557 10.5781 7.07182 11.1594 6.43901 12.0078C6.11088 12.4531 5.66557 13.3391 5.4687 13.9484C5.3562 14.2953 5.0937 15.425 5.0937 15.5609C5.0937 15.575 4.96245 15.6687 4.79838 15.7625C4.41401 15.9969 3.80463 16.6156 3.56088 17.0234C2.87651 18.1672 2.67495 19.7141 3.0312 21.1391C3.19526 21.7953 3.50463 22.3953 3.94057 22.9062L4.20307 23.2109V24.6031V26H5.98432H7.76557V25.1562V24.3125H13.9999H20.2343V25.1562V26H22.0156H23.7968V24.6031V23.2109L24.0593 22.9062C24.4953 22.3953 24.8046 21.7953 24.9687 21.1391C25.3249 19.7141 25.1234 18.1672 24.439 17.0234C24.1953 16.6156 23.5859 15.9969 23.2015 15.7625C23.0374 15.6687 22.9062 15.575 22.9062 15.5609C22.9062 15.5469 22.8546 15.275 22.789 14.9609C22.3296 12.6922 21.1578 11.0469 19.6249 10.5172L19.3203 10.4141L14.1406 10.4094C11.2906 10.4047 8.85307 10.4187 8.71713 10.4422ZM19.5359 11.6891C20.2718 12.05 20.9468 12.9219 21.3593 14.0516C21.4718 14.3516 21.6874 15.1016 21.6874 15.1812C21.6874 15.2047 21.514 15.1859 21.2374 15.1437C21.1015 15.125 21.0874 15.1062 21.0593 14.9C20.8906 13.7047 19.9531 12.8656 18.7765 12.8656C17.6374 12.8656 16.6906 13.6719 16.5171 14.7922L16.4656 15.125L11.6093 15.1297C8.94214 15.1297 6.65932 15.1484 6.53745 15.1672C6.40151 15.1906 6.31245 15.1859 6.31245 15.1578C6.31245 15.0594 6.46713 14.5156 6.60307 14.1406C7.0812 12.8234 7.82182 11.9141 8.66088 11.6094C8.90463 11.5203 9.07339 11.5203 14.0703 11.5297L19.2265 11.5391L19.5359 11.6891ZM19.3156 13.7187C19.7984 13.9016 20.1968 14.3844 20.2765 14.8906L20.314 15.125H18.7765C17.5718 15.125 17.2343 15.1109 17.2343 15.0641C17.2343 14.9656 17.3609 14.5391 17.4218 14.4266C17.5859 14.1125 18.0031 13.775 18.3593 13.6672C18.5937 13.5969 19.0531 13.625 19.3156 13.7187ZM7.36714 18.4156C8.45464 18.9781 8.41714 20.5109 7.30151 21.0219C6.60307 21.3453 5.78745 21.0453 5.41245 20.3281C5.25776 20.0234 5.25776 19.3672 5.41245 19.0672C5.56713 18.7766 5.89995 18.4766 6.18588 18.3594C6.52807 18.2234 7.03901 18.2516 7.36714 18.4156ZM21.7999 18.3641C22.0999 18.4719 22.4234 18.7672 22.5874 19.0672C22.6765 19.2406 22.6953 19.3437 22.6953 19.6953C22.6953 20.1828 22.6109 20.4031 22.2874 20.7359C21.7531 21.2844 20.8203 21.2844 20.2671 20.7312C19.8265 20.2906 19.7093 19.5875 19.9859 19.0484C20.1499 18.725 20.5249 18.4203 20.8906 18.3078C21.1203 18.2375 21.5374 18.2656 21.7999 18.3641ZM18.3968 18.9734C18.6921 19.0766 18.6921 19.4703 18.3921 19.5781C18.1999 19.6437 9.79057 19.6437 9.61245 19.5781C9.28901 19.4516 9.27963 19.1 9.59839 18.9734C9.76245 18.9078 18.2093 18.9078 18.3968 18.9734ZM18.4484 20.3047C18.6265 20.3937 18.6734 20.5859 18.5562 20.7453L18.4671 20.8672H13.9999H9.53276L9.43901 20.7406C9.31714 20.5812 9.3687 20.3844 9.54682 20.2953C9.64057 20.2484 10.6109 20.2344 13.9906 20.2344C17.6984 20.2344 18.3359 20.2437 18.4484 20.3047Z' fill='white'/>
            </svg>
        ]],

        w = 28,
        h = 28
    },

    check = {
        raw = [[
            <svg width='32' height='32' viewBox='0 0 32 32' fill='none' xmlns='http://www.w3.org/2000/svg'>
                <path d='M21.4375 7.96978C21.3855 7.98833 19.5301 9.82154 17.3109 12.0407L13.2734 16.0745L11.4847 14.2858C10.4976 13.3024 9.64412 12.4786 9.58845 12.4563C9.45115 12.4081 9.20623 12.4081 9.10603 12.46C8.99099 12.5194 6.11873 15.3842 6.05193 15.5067C5.98513 15.6366 5.98513 15.9186 6.05193 16.0485C6.08162 16.1042 7.65505 17.6961 9.55134 19.5887C12.817 22.8469 13.0025 23.0288 13.151 23.051C13.2437 23.0659 13.3662 23.0585 13.4478 23.0325C13.5629 22.9954 14.665 21.9118 19.1886 17.3956C22.265 14.3229 24.833 11.7401 24.8924 11.6622C24.9814 11.5434 25 11.4803 25 11.3059C25 11.1315 24.9814 11.0684 24.8924 10.9497C24.833 10.8717 24.1613 10.1852 23.4006 9.42447C22.4654 8.49673 21.9681 8.02544 21.8754 7.98462C21.7195 7.92154 21.5748 7.91783 21.4375 7.96978Z' fill='white'/>
            </svg>
        ]],

        w = 32,
        h = 32
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