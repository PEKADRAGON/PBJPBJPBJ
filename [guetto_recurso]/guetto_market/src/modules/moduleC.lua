--| Vars

screenW, screenH = guiGetScreenSize()
sx, sy = (screenW/1920), (screenH/1080)

--/ Events

local _Events = {}
_addEventHandler = addEventHandler
_removeEventHandler = removeEventHandler

function addEventHandler(eventName, attachedTo, theFunction, propagate, priority)
    local stt = _addEventHandler(eventName, attachedTo, theFunction, propagate, priority)
    if stt then
        table.insert(_Events, {eventName = eventName, attachedTo = attachedTo, theFunction = theFunction})
        return true
    else
        error('HOUVE UM IMPREVISTO AO EXECUTAR A FUNÇÃO, CHEQUE A LINHA ACIMA', 2)
    end
    return false
end

function removeEventHandler(eventName, attachedTo, theFunction)
    local stt = _removeEventHandler(eventName, attachedTo, theFunction)
    if (stt) then
        for i, evento in ipairs(_Events) do
            if (evento.eventName == eventName and evento.attachedTo == attachedTo and evento.theFunction == theFunction) then
                table.remove(_Events, i)
                return true
            end
        end
    else
        error('HOUVE UM IMPREVISTO AO EXECUTAR A FUNÇÃO, CHEQUE A LINHA ACIMA', 2)
    end
    return false
end

function isEventHandlerAdded(eventName, attachedTo, theFunction)
    for i, evento in ipairs(_Events) do
        if (evento.eventName == eventName and evento.attachedTo == attachedTo and evento.theFunction == theFunction) then
            return true
        end
    end
    return false
end

--/ Ator

function aToR(X, Y, sX, sY)
    local xd = X/1920 or X
    local yd = Y/1080 or Y
    local xsd = sX/1920 or sX
    local ysd = sY/1080 or sY
    return xd * screenW, yd * screenH, xsd * screenW, ysd * screenH
end

_dxDrawCircle = dxDrawCircle
function dxDrawCircle(x, y, w, h, ...)
    local x, y, w, h = aToR(x, y, w, h)
    return _dxDrawCircle(x, y, w, h, ...)
end

_dxDrawRectangle = dxDrawRectangle
function dxDrawRectangle(x, y, w, h, ...)
    local x, y, w, h = aToR(x, y, w, h)
    return _dxDrawRectangle(x, y, w, h, ...)
end

_dxDrawText = dxDrawText
function dxDrawText(text, x, y, w, h, ...)
    local x, y, w, h = aToR(x, y, w + x, h + y)
    return _dxDrawText(text, x, y, w, h, ...)
end

local texture = {}
_dxDrawImage = dxDrawImage
function dxDrawImage(x, y, w, h, img, ...)
    if not texture[img] then 
        texture[img] = dxCreateTexture(img)
    end
    local x, y, w, h = aToR(x, y, w, h)
    return _dxDrawImage(x, y, w, h, texture[img], ...)
end

_dxDrawImageSection = dxDrawImageSection
function dxDrawImageSection(x, y, w, h, ...)
    local x, y, w, h = aToR(x, y, w, h)
    return _dxDrawImageSection(x, y, w, h, ...)
end

function isCursorOnElement (x, y, w, h)
    local x, y, w, h = aToR(x, y, w, h)
    if isCursorShowing() then
        local mx, my = getCursorPosition()
        local resx, resy = guiGetScreenSize()
        mousex, mousey = mx * resx, my * resy
        if mousex > x and mousex < x + w and mousey > y and mousey < y + h then
            return true
        else
            return false
        end
    end
end

--| SVG Rectangles

local svgRectangles = {}

function dxDrawRoundedRectangle(x, y, w, h, color, radius, post)
    if not svgRectangles[radius] then
        local Path = string.format([[
            <svg width="%s" height="%s" viewBox="0 0 %s %s" fill="none" xmlns="http://www.w3.org/2000/svg">
            <rect opacity="1" width="%s" height="%s" rx="%s" fill="#FFFFFF"/>
            </svg>
        ]], w, h, w, h, w, h, radius)
        svgRectangles[radius] = svgCreate(sx*w, sy*h, Path)
    end
    if svgRectangles[radius] then
        dxSetBlendMode("modulate_add")
        dxDrawImage(x, y, w, h, svgRectangles[radius], 0, 0, 0, color, post)
        dxSetBlendMode("blend")
    end
end

--| SVG Images

Images = {}
ImagesPath = {

}

function loadImages()
    Images = {}
    for i, v in pairs(ImagesPath) do
        if v["Format"] == "svg" then
            Images[i] = svgCreate(v["Width"], v["Height"], v["Path"])
            dxSetTextureEdge(Images[i], "border")
        else
            Images[i] = v["Path"]
        end
    end
end
addEventHandler("onClientResourceStart", resourceRoot, loadImages)

local fonts = {}
function getFont(font, size)
    local index = font .. size

    if not fonts[index] then
        fonts[index] = dxCreateFont('assets/fonts/' .. font .. '.ttf', sx * size, false, "cleartype")
    end

    return fonts[index]
end

--| Misc

function formatNumber(number, sep)
	assert(type(tonumber(number))=="number", "Bad argument @'formatNumber' [Expected number at argument 1 got "..type(number).."]")
	assert(not sep or type(sep)=="string", "Bad argument @'formatNumber' [Expected string at argument 2 got "..type(sep).."]")
	local money = number
	for i = 1, tostring(money):len()/3 do
		money = string.gsub(money, "^(-?%d+)(%d%d%d)", "%1"..sep.."%2")
	end
	return money
end


function convertTime(ms) 
    local min = math.floor ( ms/30000 ) 
    local sec = math.floor( (ms/1000)%60 ) 
    return min, sec 
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


slidebar = {
    data = {};
    state = false;

    events = {
        start = function ( )
            if not isEventHandlerAdded('onClientRender', root, slidebar.draw) then
                addEventHandler('onClientRender', root, slidebar.draw)
            end
            if not isEventHandlerAdded('onClientClick', root, slidebar.click) then
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
                percent = 1,
                total = total,
                active = false,
            }
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

            dxDrawRectangle(v.pos[1], v.pos[2], v.pos[3], v.pos[4], v.colorBackground, true)
            dxDrawRectangle(v.pos[1], v.pos[2], v.progress, v.pos[4],  v.colorInProgress, true)
            dxDrawImage(v.pos[1] + (v.progress - 9), v.pos[2] + v.pos[4] / 2 - 32 / 2, 32, 32, "assets/images/icon-slide.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)

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
                    if isCursorOnElement(v.pos[1] + (v.progress - 9), v.pos[2] + v.pos[4] / 2 - 32 / 2, 32, 32) then 
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
        if isEventHandlerAdded('onClientRender', root, slidebar.draw) then
            removeEventHandler('onClientRender', root, slidebar.draw)
        end
        if isEventHandlerAdded('onClientClick', root, slidebar.click) then
            removeEventHandler('onClientClick', root, slidebar.click)
        end
        slidebar.data = {}
    end;

}
