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
    ['icon-box'] = {
        w = respc(30),
        h = respc(30),
        path = [[
            <svg width="30" height="30" viewBox="0 0 30 30" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M12.5 3.75H5C4.66848 3.75 4.35054 3.8817 4.11612 4.11612C3.8817 4.35054 3.75 4.66848 3.75 5V12.5C3.75 12.8315 3.8817 13.1495 4.11612 13.3839C4.35054 13.6183 4.66848 13.75 5 13.75H12.5C12.8315 13.75 13.1495 13.6183 13.3839 13.3839C13.6183 13.1495 13.75 12.8315 13.75 12.5V5C13.75 4.66848 13.6183 4.35054 13.3839 4.11612C13.1495 3.8817 12.8315 3.75 12.5 3.75ZM25 3.75H17.5C17.1685 3.75 16.8505 3.8817 16.6161 4.11612C16.3817 4.35054 16.25 4.66848 16.25 5V12.5C16.25 12.8315 16.3817 13.1495 16.6161 13.3839C16.8505 13.6183 17.1685 13.75 17.5 13.75H25C25.3315 13.75 25.6495 13.6183 25.8839 13.3839C26.1183 13.1495 26.25 12.8315 26.25 12.5V5C26.25 4.66848 26.1183 4.35054 25.8839 4.11612C25.6495 3.8817 25.3315 3.75 25 3.75ZM12.5 16.25H5C4.66848 16.25 4.35054 16.3817 4.11612 16.6161C3.8817 16.8505 3.75 17.1685 3.75 17.5V25C3.75 25.3315 3.8817 25.6495 4.11612 25.8839C4.35054 26.1183 4.66848 26.25 5 26.25H12.5C12.8315 26.25 13.1495 26.1183 13.3839 25.8839C13.6183 25.6495 13.75 25.3315 13.75 25V17.5C13.75 17.1685 13.6183 16.8505 13.3839 16.6161C13.1495 16.3817 12.8315 16.25 12.5 16.25ZM21.25 16.25C22.2283 16.25 23.185 16.537 24.0018 17.0754C24.8186 17.6138 25.4595 18.3799 25.8451 19.279C26.2307 20.178 26.3442 21.1704 26.1714 22.1333C25.9985 23.0962 25.5471 23.9872 24.8728 24.696C24.1986 25.4048 23.3313 25.9003 22.3783 26.121C21.4252 26.3418 20.4284 26.2781 19.5112 25.9379C18.594 25.5977 17.7967 24.9959 17.2182 24.2071C16.6396 23.4183 16.3052 22.477 16.2563 21.5L16.25 21.25L16.2563 21C16.3204 19.7188 16.8745 18.5113 17.804 17.6272C18.7335 16.743 19.9672 16.25 21.25 16.25Z" fill="#C19F72"/>
            </svg>
        ]]
    };
    ['icon-info'] = {
        w = respc(24),
        h = respc(24),
        path = [[
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M11.5 16.5H12.5V11H11.5V16.5ZM12 9.577C12.1747 9.577 12.321 9.518 12.439 9.4C12.557 9.282 12.6157 9.13567 12.615 8.961C12.6143 8.78633 12.5553 8.64033 12.438 8.523C12.3207 8.40567 12.1747 8.34667 12 8.346C11.8253 8.34533 11.6793 8.40433 11.562 8.523C11.4447 8.64167 11.3857 8.788 11.385 8.962C11.3843 9.136 11.4433 9.282 11.562 9.4C11.6807 9.518 11.8267 9.577 12 9.577ZM12.003 21C10.7583 21 9.58833 20.764 8.493 20.292C7.39767 19.8193 6.44467 19.178 5.634 18.368C4.82333 17.558 4.18167 16.606 3.709 15.512C3.23633 14.418 3 13.2483 3 12.003C3 10.7577 3.23633 9.58767 3.709 8.493C4.181 7.39767 4.82133 6.44467 5.63 5.634C6.43867 4.82333 7.391 4.18167 8.487 3.709C9.583 3.23633 10.753 3 11.997 3C13.241 3 14.411 3.23633 15.507 3.709C16.6023 4.181 17.5553 4.82167 18.366 5.631C19.1767 6.44033 19.8183 7.39267 20.291 8.488C20.7637 9.58333 21 10.753 21 11.997C21 13.241 20.764 14.411 20.292 15.507C19.82 16.603 19.1787 17.556 18.368 18.366C17.5573 19.176 16.6053 19.8177 15.512 20.291C14.4187 20.7643 13.249 21.0007 12.003 21Z" fill="#909090"/>
            </svg>
        ]]
    };
    ['rectangle-item'] = {
        w = respc(451),
        h = respc(39),
        path = [[
            <svg width="451" height="39" viewBox="0 0 451 39" fill="none" xmlns="http://www.w3.org/2000/svg">
                <rect width="451" height="39" rx="1" fill="white"/>
            </svg>
        ]]
    };
    ['icon-alert'] = {
        w = respc(36),
        h = respc(36),
        path = [[
            <svg width="36" height="36" viewBox="0 0 36 36" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M34.2755 17.3879L26.54 4.14678C26.4354 3.96709 26.2856 3.81795 26.1055 3.71423C25.9253 3.61052 25.7212 3.55584 25.5133 3.55566H10.0377C9.83005 3.55603 9.62609 3.6108 9.44616 3.71451C9.26623 3.81822 9.1166 3.96726 9.01218 4.14678L1.27551 17.389C1.16672 17.5747 1.10938 17.786 1.10938 18.0012C1.10938 18.2164 1.16672 18.4278 1.27551 18.6134L9.01329 31.8546C9.11771 32.0341 9.26734 32.1831 9.44727 32.2868C9.6272 32.3905 9.83116 32.4453 10.0388 32.4457H25.5144C25.7221 32.4453 25.926 32.3905 26.106 32.2868C26.2859 32.1831 26.4355 32.0341 26.54 31.8546L34.2755 18.6112C34.3843 18.4255 34.4416 18.2142 34.4416 17.999C34.4416 17.7838 34.3843 17.5725 34.2755 17.3868M16.5266 9.11122H19.0266V21.3334H16.5266V9.11122ZM17.7755 28.0001C17.4459 28.0001 17.1236 27.9024 16.8496 27.7192C16.5755 27.5361 16.3619 27.2758 16.2357 26.9712C16.1096 26.6667 16.0766 26.3316 16.1409 26.0083C16.2052 25.685 16.3639 25.388 16.597 25.1549C16.8301 24.9218 17.1271 24.7631 17.4504 24.6988C17.7737 24.6345 18.1088 24.6675 18.4133 24.7936C18.7179 24.9198 18.9782 25.1334 19.1613 25.4075C19.3444 25.6816 19.4422 26.0038 19.4422 26.3334C19.4422 26.7755 19.2666 27.1994 18.954 27.512C18.6415 27.8245 18.2175 28.0001 17.7755 28.0001Z" fill="#C19F72"/>
            </svg>
        ]]
    }
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