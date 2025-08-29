--| Vars

screenW, screenH = guiGetScreenSize()
sx, sy = (screenW/1920), (screenH/1080)

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

local textures = { }

_dxDrawImage = dxDrawImage
function dxDrawImage(x, y, w, h, img, ...)
    local x, y, w, h = aToR(x, y, w, h)

    if not textures[img] then 
        textures[img] = dxCreateTexture(img)
    end

    return _dxDrawImage(x, y, w, h, textures[img], ...)
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

function convertTime(ms) 
    local min = math.floor ( ms/60000 ) 
    local sec = math.floor( (ms/1000)%60 ) 
    if min < 10 then 
        min = "0"..min
    end 
    if sec < 10 then 
        sec = "0"..sec
    end 
    return min, sec 
end