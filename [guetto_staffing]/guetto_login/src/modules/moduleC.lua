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

    return fonts[index] or 'default'
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
                progress = 50,
                percent = 50,
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
        if not interface["panel"]["showningSound"] then 
            return 
        end

        for i, v in pairs(slidebar.data) do 

            dxDrawRectangle(v.pos[1], v.pos[2], v.pos[3], v.pos[4], v.colorBackground, true)
            dxDrawRectangle(v.pos[1], v.pos[2], v.progress, v.pos[4],  v.colorInProgress, true)
            dxDrawImage(v.pos[1] + v.progress, v.pos[2] + v.pos[4] / 2 - 13 / 2, 13, 13, "assets/images/circle-slide.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)

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
                    if isCursorOnElement(v.pos[1] + v.progress, v.pos[2] + v.pos[4] / 2 - 13 / 2, 13, 13) then 
                        v.active = true
                    end
                end
            elseif state == 'up' then 
                for i, v in pairs(slidebar.data) do 
                    if v.active then 
                        v.active = false
                        setSoundVolume(interface.panel.sound, tonumber(v.percent) / 50)
                        break
                    end
                end
            end
        end
    end;

}

function loadLoginFromXML()
	local xml_save_log_File = xmlLoadFile('assets/xml/userdata.xml')
	if not xml_save_log_File then
		xml_save_log_File = xmlCreateFile('assets/xml/userdata.xml', 'Login')
	end
	local usernameNode = xmlFindChild(xml_save_log_File, 'username', 0)
	local passwordNode = xmlFindChild(xml_save_log_File, 'password', 0)
	if usernameNode and passwordNode then
		return xmlNodeGetValue(usernameNode), xmlNodeGetValue(passwordNode)
	end
	xmlUnloadFile(xml_save_log_File)
    return false;
end

function saveLoginToXML(username, password)
	local xml_save_log_File = xmlLoadFile('assets/xml/userdata.xml')
	if not xml_save_log_File then
		xml_save_log_File = xmlCreateFile('assets/xml/userdata.xml', 'Login')
	end
	if (username ~= '') then
		local usernameNode = xmlFindChild(xml_save_log_File, 'username', 0)
		if not usernameNode then
			usernameNode = xmlCreateChild(xml_save_log_File, 'username')
		end
		xmlNodeSetValue(usernameNode, tostring(username))
	end
	if (password ~= '') then
		local passwordNode = xmlFindChild(xml_save_log_File, 'password', 0)
		if not passwordNode then
			passwordNode = xmlCreateChild(xml_save_log_File, 'password')
		end
		xmlNodeSetValue(passwordNode, tostring(password))
	end
	xmlSaveFile(xml_save_log_File)
	xmlUnloadFile(xml_save_log_File)
end
