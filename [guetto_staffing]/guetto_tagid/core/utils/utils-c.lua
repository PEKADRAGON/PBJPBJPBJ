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

_dxDrawImage = dxDrawImage
function dxDrawImage(x, y, w, h, ...)
    local x, y, w, h = aToR(x, y, w, h)
    return _dxDrawImage(x, y, w, h, ...)
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
        svgRectangles[radius] = svgCreate(w, h, Path)
        dxSetTextureEdge(svgRectangles[radius], "border")
    end
    if svgRectangles[radius] then
        dxSetBlendMode("modulate_add")
        dxDrawImage(x, y, w, h, svgRectangles[radius], 0, 0, 0, color, post)
        dxSetBlendMode("blend")
    end
end

function _dxDrawRoundedRectangle(x, y, w, h, color, radius, post)
    if not svgRectangles[radius] then
        local Path = string.format([[
            <svg width="%s" height="%s" viewBox="0 0 %s %s" fill="none" xmlns="http://www.w3.org/2000/svg">
            <rect opacity="1" width="%s" height="%s" rx="%s" fill="#FFFFFF"/>
            </svg>
        ]], w, h, w, h, w, h, radius)
        svgRectangles[radius] = svgCreate(w, h, Path)
    end
    if svgRectangles[radius] then
        dxSetBlendMode("modulate_add")
        _dxDrawImage(x, y, w, h, svgRectangles[radius], 0, 0, 0, color, post)
        dxSetBlendMode("blend")
    end
end

--| SVG Images

Images = {}

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

--| Misc

function simulateClear(name)
    local newName = name
    if string.find(name, "_") then 
        name = string.gsub(name, "_", " ")
    end
    return name
end

function formatSeconds(seconds)
    local formatedSeconds = {}
    local time = split( (seconds % 60),  '.')

    local sec = time[1]
    local min = math.floor ( ( seconds % 3600 ) / 60 )

    table.insert(formatedSeconds, {string.format('%.2d', "0"), string.format('%.2d', min), string.format('%.2d', sec)})

    return table.concat(formatedSeconds[1], ":")
end

function removeHex (s)
    if type (s) == "string" then
        while (s ~= s:gsub ("#%x%x%x%x%x%x", "")) do
            s = s:gsub ("#%x%x%x%x%x%x", "")
        end
    end
    return s or false
end