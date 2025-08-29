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


local circles = {}
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

function convertTime ( ms ) 
    if ( ms and type ( ms ) == "number" ) then 
    local milliseconds = math.floor((ms % 1000) / 100)
    local seconds = math.floor((ms / 1000) % 60)
    local minutes = math.floor((ms / (1000 * 60)) % 60)
	return minutes, seconds, milliseconds
    end 
end 