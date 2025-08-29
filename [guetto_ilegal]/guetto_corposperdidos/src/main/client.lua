local state = false;
local text = "";

local screenW, screenH = guiGetScreenSize();
local x, y = (screenW / 1920), (screenH / 1080)
local offSetYt = { 0, 0, 0 }
local fadet = { 0, 0, 0 }

function interfaceDraw ( )
    local offSetY = interpolateBetween (offSetYt[1], 0, 0, offSetYt[2], 0, 0, (getTickCount ( ) - offSetYt[3]) / 400, "Linear")
    local fade = interpolateBetween (fadet[1], 0, 0, fadet[2], 0, 0, (getTickCount ( ) - fadet[3]) / 400, "Linear")

    local width = dxGetTextWidth(text, 1.5, "bold")
    dxDrawText(text, x, offSetY, screenW, y * 34, tocolor(255, 255, 255, fade), 1.5, "bold", "center", "top")
end;


function interfaceOpen ( )
    if not isEventHandlerAdded("onClientRender", root, interfaceDraw) then 
        state = true 
        offSetYt[1], offSetYt[2], offSetYt[3] = y * 900, y * 890, getTickCount()
        fadet[1], fadet[2], fadet[3] = 0, 255, getTickCount()
        addEventHandler("onClientRender", root, interfaceDraw)
    end
end

function interfaceClose ( )
    if isEventHandlerAdded("onClientRender", root, interfaceDraw) then 
        state = false
        offSetYt[1], offSetYt[2], offSetYt[3] = 890, y * 900, getTickCount()
        fadet[1], fadet[2], fadet[3] = 255, 0, getTickCount()
        setTimer(function()
            removeEventHandler("onClientRender", root, interfaceDraw)
        end, 400, 1)
    end
end

addCustomEvent("draw>message", resourceRoot, function ( state, message )

    if state then 
        interfaceOpen()
    else
        interfaceClose()
    end

    text = message;
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

