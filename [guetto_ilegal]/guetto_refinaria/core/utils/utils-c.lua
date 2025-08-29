--/ Events

local events = {}
local _addEventHandler = addEventHandler
local _removeEventHandler = removeEventHandler

function addEventHandler(eventName, attachedTo, theFunction, propagate, priority)
    local added = _addEventHandler(eventName, attachedTo, theFunction, propagate, priority)
    if not added then 
        error('Não foi possível executar a função, verifique os argumentos.', 2)
        return 
    end
    if not events[eventName] then
        events[eventName] = {}
    end
    if not events[eventName][theFunction] then 
        events[eventName][theFunction] = attachedTo
    else
        error('Essa função já está sendo executada.', 2)
        return
    end
end

function removeEventHandler(eventName, attachedTo, theFunction, propagate, priority)
    if not events[eventName] then
        return false
    end
    if not events[eventName][theFunction] then 
        error('Essa função não está adicionada.', 2)
        return
    end
    local removed = _removeEventHandler(eventName, attachedTo, theFunction, propagate, priority)
    if not removed then 
        error('Não foi possível executar a função, verifique os argumentos.', 2)
        return 
    end
    events[eventName][theFunction] = nil 
end

function isEventHandlerAdded(eventName, attachedTo, theFunction)
    if not events[eventName] then
        return false
    end
    if not events[eventName][theFunction] then 
        return false
    end
    if (events[eventName][theFunction] == attachedTo) then 
        return true
    end
    return false
end

--| Render

function CreateThread(callback)
    local thread = coroutine.create(callback)
    local function resume()
        local status, result = coroutine.resume(thread)
        if (not status) then error(result, 2) end
        if (coroutine.status(thread) ~= 'dead') then
            setTimer(resume, 0, 1)
        end
    end
    resume()
end

--| Resolution calc ( Var's )

screen = Vector2(guiGetScreenSize())

--| Resolution calc ( Responsive )

screenScale = math.min(1.2, math.max(0.9, (screen.y / 1080)))

function respc(value)
    return value * screenScale
end

--| Resolution calc ( Function's )

_dxDrawText = dxDrawText
function dxDrawText(text, x, y, w, h, ...)
    return _dxDrawText(text, x, y, (w + x), (h + y), ...)
end

--| Font's & image's

local tableTextures = {
    imgElements = { };
    fontsElements = { };
}

_dxDrawImage = dxDrawImage
function dxDrawImage(x, y, w, h, path, ...)
    if not path then 
        return 
    end
    if (type (path) ~= 'string') then
        return _dxDrawImage(x, y, w, h, path, ...)
    end
    if (not tableTextures.imgElements[path]) then
        tableTextures.imgElements[path] = dxCreateTexture (path, 'argb', true, 'clamp')
    end
    if (tableTextures.imgElements[path] and isElement (tableTextures.imgElements[path])) then
        return _dxDrawImage(x, y, w, h, tableTextures.imgElements[path], ...)
    else
        return print ('['..getResourceName (getThisResource ( ))..'] - Erro ao carregar a textura: ' .. path)
    end
end

_dxCreateFont = dxCreateFont
function dxCreateFont(path, size, ...)
    if (not tableTextures.fontsElements[path]) then
        tableTextures.fontsElements[path] = { }
    end
    if (not tableTextures.fontsElements[path][size]) then
        tableTextures.fontsElements[path][size] = _dxCreateFont ('core/assets/fonts/'..path, respc(size * 0.75), false, "cleartype")
    end
    return tableTextures.fontsElements[path][size]
end

function dxGetFont(path, size)
    if (not tableTextures.fontsElements[path]) then
        return false
    end
    if (not tableTextures.fontsElements[path][size]) then
        return false
    end
    return tableTextures.fontsElements[path][size]
end

--| Cursor 

cursor = {};

function cursorUpdate ()
    cursor.state = isCursorShowing ();
    if (cursor.state) then
        local cursorX, cursorY = getCursorPosition ();
        cursor.x, cursor.y = cursorX * screen.x, cursorY * screen.y;
    end
end

function isCursorOnElement(x, y, width, heigth)
    local x, y, width, heigth = x, y, width, heigth
    if not (cursor.state) then
        return false;
    end
    return (( cursor.x >= x and cursor.x <= x + width ) and ( cursor.y >= y and cursor.y <= y + heigth ));
end

--| SVG Rectangle ( Var's )

local svgRectangles = {}
local svgCache = {}

--| SVG Rectangle ( Function's )

function dxDrawRoundedRectangle(id, x, y, w, h, color, radius, post)
    if not svgRectangles[id] then

        local rectPath = string.format([[
            <svg width="%s" height="%s" viewBox="0 0 %s %s" fill="none" xmlns="http://www.w3.org/2000/svg">
            <rect width="%s" height="%s" rx="%s" fill="#FFFFFF"/>
            </svg>
        ]], w, h, w, h, w, h, radius)

        svgRectangles[id] = svgCreate(respc(w), respc(h), rectPath)
        dxSetTextureEdge(svgRectangles[id], "mirror")

    end
    if svgRectangles[id] then
        dxDrawImage(x, y, w, h, svgRectangles[id], 0, 0, 0, color, post)
    end
end

function dxDrawStrokedRoundRectangle(id, x, y, width, height, rectColor, strokeColor, strokeHeight, radius, post)
    if not svgCache[id] then 

        local rectPath = string.format([[
            <svg width="%s" height="%s" viewBox="0 0 %s %s" fill="none" xmlns="http://www.w3.org/2000/svg">
                <rect width="%s" height="%s" rx="%s" fill="white"/>
            </svg>
        ]], width, height, width, height, width, height, radius)

        local strokePath = string.format([[
            <svg width="%s" height="%s" viewBox="0 0 %s %s" fill="none" xmlns="http://www.w3.org/2000/svg">
                <rect x="%s" y="%s" width="%s" height="%s" rx="%s" stroke="white" stroke-width="%s" />
            </svg>
        ]], width, height, width, height, (strokeHeight/2), (strokeHeight/2), (width - strokeHeight), (height - strokeHeight), radius - (strokeHeight/2), strokeHeight)

        svgCache[id] = {
            rect = svgCreate(respc(width), respc(height), rectPath),
            stroke = svgCreate(respc(width), respc(height), strokePath)
        }

        dxSetTextureEdge(svgCache[id]['rect'], "mirror")
        dxSetTextureEdge(svgCache[id]['stroke'], "mirror")

    end
    if svgCache[id] then 
        dxDrawImage(x, y, width, height, svgCache[id]["rect"], 0, 0, 0, rectColor, post)
        dxDrawImage(x, y, width, height, svgCache[id]["stroke"], 0, 0, 0, strokeColor, post)
    end
end

--| SVG image's

images = {}
imagesPath = {

}

function loadSVGs()
    images = {}
    for id, data in pairs(imagesPath) do
        images[id] = svgCreate(respc(data["w"]), respc(data["h"]), data["path"])
        dxSetTextureEdge(images[id], "border")
    end
end

function destroySVGs()
    for id, data in pairs(images) do 
        if images[id] and isElement(images[id]) then 
            destroyElement(images[id])
        end
        images[id] = nil 
    end
    images = {}
end

addEventHandler("onClientResourceStart", resourceRoot, loadSVGs)

--| Misc

local interpolates = {}
function fadeButton(id, x, y, w, h, init, final, time, easing)

    if not isCursorShowing() then
        return 0
    end

    if not interpolates[id] then 
        interpolates[id] = {
            value = init,
        }
    end

    if isCursorOnElement(x, y, w, h) then 

        if not interpolates[id]["tick"] then 
            interpolates[id]["old"] = interpolates[id]
            interpolates[id]["tick"] = getTickCount()
            interpolates[id]["tick_out"] = nil
        end
        interpolates[id]["value"][1], interpolates[id]["value"][2], interpolates[id]["value"][3] = interpolateBetween(interpolates[id]["old"]["value"][1], interpolates[id]["old"]["value"][2], interpolates[id]["old"]["value"][3], final[1], final[2], final[3], (getTickCount() - interpolates[id]["tick"]) / time, easing)
        
    else

        if not interpolates[id]["tick_out"] then 
            interpolates[id]["old"] = interpolates[id]
            interpolates[id]["tick_out"] = getTickCount()
            interpolates[id]["tick"] = nil
        end
        interpolates[id]["value"][1], interpolates[id]["value"][2], interpolates[id]["value"][3] = interpolateBetween(interpolates[id]["old"]["value"][1], interpolates[id]["old"]["value"][2], interpolates[id]["old"]["value"][3], init[1], init[2], init[3], (getTickCount() - interpolates[id]["tick_out"]) / time, easing)

    end

    return interpolates[id]["value"][1], interpolates[id]["value"][2], interpolates[id]["value"][3]
end

function clearButtons()
    interpolates = {}
end

--| Animation's

local animations = {}

function createAnimation(identify, initial, finish, duration, easing)
    if (animations[identify]) then return false end

    animations[identify] = {
        initial = initial,
        finish = finish,
        duration = duration,
        easing = easing or 'Linear'
    }
end

function execAnimation(identify, initial, finish, duration, easing)
    if (not animations[identify]) then return false end

    animations[identify].initial = initial or animations[identify].initial
    animations[identify].finish = finish or animations[identify].finish
    animations[identify].duration = duration or animations[identify].duration
    animations[identify].easing = easing or animations[identify].easing
    animations[identify].tick = getTickCount()
    return true
end

function getAnimation(identify)
    if (not animations[identify]) then return false end

    local progress = (getTickCount() - animations[identify].tick) / animations[identify].duration

    if (progress >= 1) then
        return animations[identify].finish
    end

    return interpolateBetween(
        animations[identify].initial, 0, 0,
        animations[identify].finish, 0, 0,
        progress,
        animations[identify].easing
    )
end

function isAnimationRunning(identify)
    if (not animations[identify]) then return false end

    local progress = (getTickCount() - animations[identify].tick) / animations[identify].duration

    if (not (progress >= 1)) then
        return true
    end

    return false
end

function destroyAnimation(identify)
    if (not animations[identify]) then return false end

    animations[identify] = nil
    return true
end

--| Rotation

local rotationData = {}

function generateRotation(id)

    if not rotationData[id] then
        rotationData[id] = 0
    end

    if (rotationData[id] >= 360) then 
        rotationData[id] = 0
    else
        rotationData[id] = (rotationData[id] + 2)
    end

    return rotationData[id]
end