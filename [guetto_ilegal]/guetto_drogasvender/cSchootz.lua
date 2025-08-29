local screen = {guiGetScreenSize()} local x, y = (screen[1]/1366), (screen[2]/768)

local font = dxCreateFont('files/font.ttf', 10)



startTraffic = function(elemento) 
    if cooldown and cooldown[elemento] then 
        cooldown[elemento] = false
    end 
end

function dxDraw()

    dxDrawRectangle(positionCursor[1], positionCursor[2], 236, 42, tocolor(24, 26, 28, alpha), false)
    if isMouseInPosition(positionCursor[1], positionCursor[2], 236, 42) then
        dxDrawRectangle(positionCursor[1], positionCursor[2], 4, 42, tocolor(223, 195, 96, alpha), false)
    end
    dxDrawImage(positionCursor[1]+30, positionCursor[2]+7, 28, 28, 'files/icon.png', 0, 0, 0, tocolor(255, 255, 255, alpha), false)
    dxDrawText('OFERECER DROGAS', positionCursor[1]+58+178/2-dxGetTextWidth('OFERECER DROGAS', 1, font)/2, positionCursor[2]+13, 0, 0, tocolor(255, 255, 255, alpha), 1, font)

end

function openPainel()
    if not isEventHandlerAdded('onClientRender', root, dxDraw) then
        addEventHandler('onClientRender', root, dxDraw)
        showCursor(true)
        
    end
end

function closePainel()
    if isEventHandlerAdded('onClientRender', root, dxDraw) then
        removeEventHandler('onClientRender', root, dxDraw)
        showCursor(false)
    end
end
bindKey('backspace', 'down', closePainel)

function clickFunction(button, state, _, _, _, _, _, element)
    if (button == 'left') and (state == 'down') then 
        if isEventHandlerAdded('onClientRender', root, dxDraw) then
            if isMouseInPosition(positionCursor[1], positionCursor[2], 236, 42) then
                if (getElementData(pedatual, "MeloSCR:DelayVenderDrogas")) then
                    exports.FR_DxMessages:addBox('Alguem vendeu drogas recentemente para este NPC!', 'error')
                else
                    triggerServerEvent('Schootz.venderDrogas', localPlayer, localPlayer, pedatual)  
                    closePainel()
                    playSoundFrontEnd(1)
                end
            end
        else
            if element and getElementType(element) == 'ped' then
                for i,v in ipairs(PedsImortais) do
                    if element == v then
                        local posped = {getElementPosition(element)}
                        local pospla = {getElementPosition(localPlayer)}
                        if getDistanceBetweenPoints3D(posped[1], posped[2], posped[3], pospla[1], pospla[2], pospla[3]) < 5 then
                            local cx, cy = getCursorPosition()
							local mx, my = cx * screen[1], cy * screen[2]
							positionCursor = {mx, my}
                            openPainel()
                            pedatual = element
                        end
                    end
                end
            end
        end
    end
end
addEventHandler('onClientClick', root, clickFunction)

function isMouseInPosition(x,y,w,h)
	if isCursorShowing() then
		local sx,sy = guiGetScreenSize()
		local cx,cy = getCursorPosition()
		local cx,cy = (cx*sx),(cy*sy)
		if (cx >= x and cx <= x+w) and (cy >= y and cy <= y+h) then
			return true
		end
	end
end

PedsImortais = {}

function CancelDamage(tablePeds)
    PedsImortais = tablePeds
end 
addEvent('MeloSCR:CancelDamage', true)
addEventHandler('MeloSCR:CancelDamage', getRootElement(), CancelDamage)

addEventHandler('onClientPedDamage', root, 
    function () 
        for i,v in ipairs(PedsImortais) do 
            if source == v then 
                if source and isElement(source)  then 
                    cancelEvent()
                end  
            end 
        end 
    end)

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