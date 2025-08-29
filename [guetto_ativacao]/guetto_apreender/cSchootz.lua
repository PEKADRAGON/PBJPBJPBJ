local screen = {guiGetScreenSize()} local x, y = (screen[1]/1360), (screen[2]/768)

local fonts = {
	['SFProText-Regular'] = dxCreateFont('files/SFProText-Regular.ttf', x * 10)
}

dxDraw = function()
	dxDrawImage(x * 571, y * 237, x * 186, y *  293, 'files/base.png', 0, 0, 0, tocolor(255, 255, 255, 255), false)
	if isMouseInPosition(x * 579, y * 429, x * 171, y * 40) then 
		dxDrawImage(x * 579, y * 429, x * 171, y * 40, 'files/button.png', 0, 0, 0, tocolor(193, 159, 114, 255), false)
	else
		dxDrawImage(x * 579, y * 429, x * 171, y * 40, 'files/button.png', 0, 0, 0, tocolor(47, 50, 52, 255), false)
	end
	if isMouseInPosition(x * 579, y * 474, x * 171, y * 40) then 
		dxDrawImage(x * 579, y * 474, x * 171, y * 40, 'files/button.png', 0, 0, 0, tocolor(193, 159, 114, 255), false)
	else
		dxDrawImage(x * 579, y * 474, x * 171, y * 40, 'files/button.png', 0, 0, 0, tocolor(47, 50, 52, 255), false)
	end
	dxDrawText("APRENDER", x * 583, y * 431, x * 751, y * 466, tocolor(255, 255, 255, 255), 1.00, fonts['SFProText-Regular'], 'center', 'center', false, false, false, false, false)
	dxDrawText("CANCELAR", x * 583, y * 476, x * 751, y * 511, tocolor(255, 255, 255, 255), 1.00, fonts['SFProText-Regular'], 'center', 'center', false, false, false, false, false)
end

openDx = function()
	if not isEventHandlerAdded('onClientRender', root, dxDraw) then
		addEventHandler('onClientRender', root, dxDraw)
		showCursor(true)
	end
end
addEvent('Schootz.openDetranPanel', true)
addEventHandler('Schootz.openDetranPanel', root, openDx)

closeDx = function()
	if isEventHandlerAdded('onClientRender', root, dxDraw) then
		removeEventHandler('onClientRender', root, dxDraw)
		showCursor(false)
	end
end

clickFunctions = function(button, state)
	if (button == 'left') and (state == 'down') then
		if isEventHandlerAdded('onClientRender', root, dxDraw) then
			if isMouseInPosition(x * 579, y * 474, x * 171, y * 40) then 
				closeDx()
			elseif isMouseInPosition(x * 579, y * 429, x * 171, y * 40) then
				triggerServerEvent('Schootz.AprenderVehicle', resourceRoot, localPlayer) 
			end
		end
	end
end
addEventHandler('onClientClick', root, clickFunctions)

-- Funções Uteis --

isMouseInPosition = function(pos_x, pos_y, wigth, height)
	if (not isCursorShowing()) then
		return false
	end
	local cursor_x, cursor_y = getCursorPosition()
	local cursor_x, cursor_y = (cursor_x * screen[1]), (cursor_y * screen[2])
	return ((cursor_x >= pos_x and cursor_x <= pos_x + wigth) and (cursor_y >= pos_y and cursor_y <= pos_y + height))
end

isEventHandlerAdded = function(eventName, attachedTo, handlerFunction)
	if (type(eventName) == 'string') and (isElement(attachedTo)) and (type(handlerFunction) == 'function') then
		local attachedFunction = getEventHandlers(eventName, attachedTo)
		if (type(attachedFunction) == 'table') and (#attachedFunction > 0) then
			for i, v in ipairs(attachedFunction) do
				if (v == handlerFunction) then
					return true
				end
			end
		end
	end
	return false
end