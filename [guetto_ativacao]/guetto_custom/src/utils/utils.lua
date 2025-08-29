sx, sy = guiGetScreenSize()
zoom = 1920/sx


assets = {
    activeAnimation = false,

    positionCreateCharacter = Vector3(1210.2952880859, -2037.1646728516, 69.0078125),
    rotationCreateCharacter = 269.53286743164,
    cameraCreateCharacter = {1212.5852050781,-2037.2318115234,69.80419921875,1211.5904541016,-2037.2027587891,69.705986022949},


    alpha = {
		main = 0,
		bg = 0,
	},

    positions = {
		startX_def = 30/zoom,
		startX = -600/zoom,

		logoY_def = 60/zoom,
		logoY = -230/zoom,
	},

}



function isCursorInPosition(psx, psy, pssx, pssy)
    if not isCursorShowing() then return end
    cx, cy = getCursorPosition()
    cx, cy = cx * sx, cy * sy
    if cx >= psx and cx <= psx + pssx and cy >= psy and cy <= psy + pssy then
        return true, cx, cy
    else
        return false
    end
end

function createEvent(eventname, ...)
    addEvent(eventname, true)
    addEventHandler(eventname, ...)
end

local anims, animID = { }, 0
local rendering = false 

local function renderAnimations( )
    local now = getTickCount( )
    for k,v in ipairs(anims) do
        v.onChange(interpolateBetween(v.from[1], v.from[2], v.from[3], v.to[1], v.to[2], v.to[3], (now - v.start) / v.duration, v.easing))
        if now >= v.start+v.duration then
            table.remove(anims, k)
            if type(v.onEnd) == "function" then
                v.onEnd( )
            end
            if #anims == 0 then 
                rendering = false
                removeEventHandler("onClientRender", root, renderAnimations)
            end
        end
    end
end

function animate(f, t, easing, duration, onChange, onEnd)
    if #anims == 0 and not rendering then 
        addEventHandler("onClientRender", root, renderAnimations)
        rendering = true
    end
    assert(type(f) == "table", "Bad argument @ 'animate' [expected table at argument 1, got "..type(f).."]")
    assert(type(t) == "table", "Bad argument @ 'animate' [expected table at argument 2, got "..type(t).."]")
    assert(type(easing) == "string", "Bad argument @ 'animate' [Invalid easing at argument 3]")
    assert(type(duration) == "number", "Bad argument @ 'animate' [expected number at argument 4, got "..type(duration).."]")
    assert(type(onChange) == "function", "Bad argument @ 'animate' [expected function at argument 5, got "..type(onChange).."]")
    f = {f[1] or 0, f[2] or 0, f[3] or 0}
    t = {t[1] or 0, t[2] or 0, t[3] or 0}
    animID = animID+1
    table.insert(anims, {id=animID, from = f, to = t, easing = easing, duration = duration, start = getTickCount( ), onChange = onChange, onEnd = onEnd})
    return animID
end

function finishAnimation(anim)
    for k, v in ipairs(anims) do 
        if v.id == anim then 
            v.onChange(v.to[1], v.to[2], v.to[3])
            if v.onEnd then v.onEnd() end
            v.start = 0
            return true
        end
    end
end 

function deleteAnimation(anim)
    for k, v in ipairs(anims) do 
        if v.id == anim then 
            table.remove(anims, k)
            break
        end
    end
end

screenW, screenH = guiGetScreenSize()
sx, sy = (screenW/1920), (screenH/1080)


function aToR(X, Y, sX, sY)
    local xd = X/1920 or X
    local yd = Y/1080 or Y
    local xsd = sX/1920 or sX
    local ysd = sY/1080 or sY
    return xd * screenW, yd * screenH, xsd * screenW, ysd * screenH
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
