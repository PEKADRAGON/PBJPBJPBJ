local screen = {guiGetScreenSize()} local x, y = (screen[1]/1366), (screen[2]/768)

function dxDraw()
    local alpha = interpolateBetween(0, 0, 0, 255, 0, 0, ((getTickCount() - tick) / 600), 'Linear') 
    if not closed then 
        y_interpolated = interpolateBetween(screen[2], 0, 0, 648, 0, 0, ((getTickCount() - tick) / 350), 'Linear') 
    else 
        y_interpolated = interpolateBetween(648, 0, 0, screen[2], 0, 0, ((getTickCount() - tick) / 350), 'Linear') 
    end

    dxDrawImage(x * 553, y * y_interpolated, x * 260, y * 50, 'assets/base.png', 0, 0, 0, tocolor(255, 255, 255, alpha))
end

addEvent('Pedro.onPainelTeleport', true)
addEventHandler('Pedro.onPainelTeleport', root, 
    function(i)
        removeEventHandler('onClientRender', root, dxDraw)    
        if not isEventHandlerAdded('onClientRender', root, dxDraw) then 
            tick = getTickCount()
            closed = false 
            index = i
            addEventHandler('onClientRender', root, dxDraw)     
        end    
    end
)

addEvent('Pedro.onClosePainelTeleport', true)
addEventHandler('Pedro.onClosePainelTeleport', root, 
function()
    if isEventHandlerAdded('onClientRender', root, dxDraw) then 
        tick = getTickCount()
        closed = true 
        
        print(i)
        setTimer(function()
            removeEventHandler('onClientRender', root, dxDraw)    
        end, 400, 1)
    end    
end
)

addEventHandler('onClientKey', root, 
    function(key, press)
        if isEventHandlerAdded('onClientRender', root, dxDraw) then 
            if press then 
                if key == 'e' or key == 'E' then 
                    removeEventHandler('onClientRender', root, dxDraw)    
                    triggerServerEvent('Pedro.onPlayerUseTeleport', localPlayer, localPlayer, index)
                    playSound('assets/interaction.wav')
                end
            end
        end
    end
)

------------------------------------------------
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
------------------------------------------------