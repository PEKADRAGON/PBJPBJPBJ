local screen = {guiGetScreenSize()} local x, y = (screen[1]/1366), (screen[2]/768)

local fontt = dxCreateFont('assets/font.ttf', 13)

function dxDraw()
    local w = dxGetTextWidth(message, 1, fontt)
    dxDrawText(message, (screen[1] / 2) - (w / 2), screen[2] - 57, 0, 0, tocolor(255, 255, 255, 255), 1, fontt)
end

addEvent('Pedro.mensagemLixeiro', true)
addEventHandler('Pedro.mensagemLixeiro', root, 
    function(mensagem) 
        if not isEventHandlerAdded('onClientRender', root, dxDraw) then 
            addEventHandler('onClientRender', root, dxDraw) 
            message = mensagem 
        end
    end
)

addEvent('Pedro.removeMensagemLixeiro', true)
addEventHandler('Pedro.removeMensagemLixeiro', root, 
    function()
        removeEventHandler('onClientRender', root, dxDraw)
    end
)

local font_loja = dxCreateFont('assets/font.ttf', 10)

function dxDrawLoja()
    local alpha = interpolateBetween(0, 0, 0, 255, 0, 0, ((getTickCount() - tick2) / 500), 'Linear') 
    dxDrawImage(x * 533, y * 344, x * 300, y * 80, 'assets/loja.png', 0, 0, 0, tocolor(255, 255, 255, alpha)) 
    dxDrawText('Você tem '..total_sucatas..' sucatas avaliados em R$'..formatNumber(amount, '.')..'', x * 531, y * 371, x * 832, y * 391, tocolor(255, 255, 255, alpha), 1.00, font_loja, "center", "center", false, false, true, false, false)
end

bindKey('backspace', 'down', 
    function()
        if isEventHandlerAdded('onClientRender', root, dxDrawLoja) then  
            removeEventHandler('onClientRender', root, dxDrawLoja) 
            showCursor(false)
        end    
    end
)

addEventHandler('onClientClick', root, 
    function(b, s)
        if ( b == 'left' ) and ( s == 'down' ) then 
            if isEventHandlerAdded('onClientRender', root, dxDrawLoja) then 
                if isMouseInPosition(x * 633, y * 401, x * 100, y * 15) then 
                    local res_element = getResourceDynamicElementRoot(getResourceFromName('[Trabalho]Lixeiro'))
                    triggerServerEvent('Pedro.venderLixos', res_element, amount)
                    removeEventHandler('onClientRender', root, dxDrawLoja) 
                    showCursor(false)   
                end    
            end 
        end 
    end
)

addEvent('Pedro.printLojaLixos', true)
addEventHandler('Pedro.printLojaLixos', root, 
    function(amountt, total_sucatass)
        if not isEventHandlerAdded('onClientRender', root, dxDrawLoja) then 
            tick2 = getTickCount() 
            addEventHandler('onClientRender', root, dxDrawLoja) 
            showCursor(true)  
            amount = amountt
            total_sucatas = total_sucatass
        end
    end
)

addEvent('Pedro.playSoundLixeiro', true)
addEventHandler('Pedro.playSoundLixeiro', root, 
    function(sound)
        playSound(sound) 
    end
)

function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
    if type( sEventName ) == 'string' and isElement( pElementAttachedTo ) and type( func ) == 'function' then
        local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
        if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
            for i, v in ipairs( aAttachedFunctions ) do
                if v == func then
                    return true
                end
            end
        end
    end
    return false
end

function isMouseInPosition ( x, y, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
	local sx, sy = guiGetScreenSize ( )
	local cx, cy = getCursorPosition ( )
	local cx, cy = ( cx * sx ), ( cy * sy )
	
	return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end

function formatNumber(number, sep)
	assert(type(tonumber(number))=="number", "Bad argument @'formatNumber' [Expected number at argument 1 got "..type(number).."]")
	assert(not sep or type(sep)=="string", "Bad argument @'formatNumber' [Expected string at argument 2 got "..type(sep).."]")
	local money = number
	for i = 1, tostring(money):len()/3 do
		money = string.gsub(money, "^(-?%d+)(%d%d%d)", "%1"..sep.."%2")
	end
	return money
end

local lixeiras = {}
for i, v in ipairs(getElementsByType('object')) do 
    if (getElementData(v, 'lixeira')) then 
        table.insert(lixeiras, v)
        setObjectBreakable(v, false)
    end
end

addEventHandler('onClientRender', root, 
    function()
        for i, v in ipairs(lixeiras) do 
            if isElement(v) then 
                if (getElementData(localPlayer, 'Emprego') or 'Desempregado') == 'Lixeiro' then 
                    dxDrawTextOnElement(v, (getElementData(v, 'lixeira') or ''))   
                end 
            end         
        end
    end
)

function dxDrawTextOnElement(TheElement,text,height,distance,R,G,B,alpha,size,font,...)
	local x, y, z = getElementPosition(TheElement)
	local x2, y2, z2 = getCameraMatrix()
	local distance = distance or 20
	local height = height or 1

	if (isLineOfSightClear(x, y, z+2, x2, y2, z2, ...)) then
		local sx, sy = getScreenFromWorldPosition(x, y, z+height)
		if(sx) and (sy) then
			local distanceBetweenPoints = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
			if(distanceBetweenPoints < distance) then
				dxDrawText(text, sx+2, sy+2, sx, sy, tocolor(R or 255, G or 255, B or 255, alpha or 255), (size or 1)-(distanceBetweenPoints / distance), fontt)
			end
		end
	end
end