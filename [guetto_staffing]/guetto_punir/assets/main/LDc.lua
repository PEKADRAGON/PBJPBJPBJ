--[[
    --» sᴄʀɪᴘᴛ ғᴇɪᴛᴏ ᴘᴏʀ » Pedro Developer
--]]

local screen = {guiGetScreenSize ( )}
local resW, resH = 1366, 768
local sx, sy = (screen[1] / resW), (screen[2] / resH)

local fonts = {

    dxCreateFont('assets/fonts/sbold.ttf', sy * 9);
    dxCreateFont('assets/fonts/regular.ttf', sy * 8, false, 'cleartype_natural');
    dxCreateFont('assets/fonts/regular.ttf', sy * 9);
    dxCreateFont('assets/fonts/sbold.ttf', sy * 13);

}


function drawStaffBan() 

    local alpha = interpolateBetween(interpolate[1], 0, 0, interpolate[2], 0, 0, ((getTickCount() - tick) / 500), 'Linear')

    drawBorder(10, 524, 249, 317, 270, tocolor(31, 31, 31, alpha))
    dxDrawImage(536, 261, 23, 23, 'assets/images/title.png', 0, 0, 0, tocolor(255, 255, 255, alpha))
    dxDrawText('Banimentos', 566, 265, 62, 15, tocolor(255, 255, 255, alpha * 0.65), 1, fonts[1])

    dxDrawImage(814, 267, 15, 15, 'assets/images/exit.png', 0, 0, 0, tocolor(63, 63, 63, alpha))
    if (isMouseInPosition(814, 267, 15, 15)) then 

        if not (exitTick) then exitTick = getTickCount() end 
        local animation = interpolateBetween(0, 0, 0, 255, 0, 0, ((getTickCount() - exitTick) / 500), 'Linear')
        dxDrawImage(814, 267, 15, 15, 'assets/images/exit.png', 0, 0, 0, tocolor(73, 184, 232, animation))

    else

        exitTick = nil 

    end

    dxDrawText('Nosso painel de banimentos é feito para regularizar e garantir uma boa experiências para nossos jogadores, punindo aqueles que não respeitam nossas regras.', 536, 293, 296, 39, tocolor(255, 255, 255, alpha * 0.4), 1, fonts[2], 'left', 'top', false, true)

    drawBorder(5, 536, 347, 293, 35, tocolor(26, 26, 26, alpha))
    dxDrawText(selectEdit == 1 and guiGetText(idEdit)..'|' or guiGetText(idEdit), 536, 347, 293, 35, tocolor(255, 255, 255, alpha * 0.4), 1, fonts[3], 'center', 'center')

    drawBorder(5, 536, 387, 293, 35, tocolor(26, 26, 26, alpha))
    dxDrawText(selectEdit == 2 and guiGetText(timeEdit)..'|' or guiGetText(timeEdit), 536, 387, 293, 35, tocolor(255, 255, 255, alpha * 0.4), 1, fonts[3], 'center', 'center')

    drawBorder(5, 536, 427, 293, 35, tocolor(26, 26, 26, alpha))
    dxDrawText(selectEdit == 3 and guiGetText(reasonEdit)..'|' or guiGetText(reasonEdit), 536, 427, 293, 35, tocolor(255, 255, 255, alpha * 0.4), 1, fonts[3], 'center', 'center')

    drawBorder(5, 536, 467, 293, 35, tocolor(26, 26, 26, alpha))
    dxDrawText('Aplicar punição', 536, 467, 293, 35, tocolor(255, 255, 255, alpha * 0.4), 1, fonts[2], 'center', 'center')
    if (isMouseInPosition(536, 467, 293, 35)) then 

        if not (applyTick) then applyTick = getTickCount() end 
        local animation = interpolateBetween(0, 0, 0, 255, 0, 0, ((getTickCount() - applyTick) / 500), 'Linear')
        drawBorder(5, 536, 467, 293, 35, tocolor(73, 184, 232, animation))
        dxDrawText('Aplicar punição', 536, 467, 293, 35, tocolor(31, 31, 31, animation), 1, fonts[2], 'center', 'center')

    else

        applyTick = nil 

    end  
    
end

addEventHandler('onClientClick', root, 

    function(b, s) 

        if ( b == 'left' ) and ( s == 'down' ) then 

            if isEventHandlerAdded('onClientRender', root, drawStaffBan) then 

                selectEdit = 0 

                if guiGetText(idEdit) == '' then 

                    guiSetText(idEdit, 'ID do jogador') 

                end 

                if guiGetText(timeEdit) == '' then 

                    guiSetText(timeEdit, 'Tempo do banimento (Minutos)')

                end 

                if guiGetText(reasonEdit) == '' then 

                    guiSetText(reasonEdit, 'Motivo do banimento') 

                end

                if isMouseInPosition(536, 347, 293, 35) then 

                    if guiEditSetCaretIndex(idEdit, string.len(guiGetText(idEdit))) then

                        guiBringToFront(idEdit)
                        guiSetInputMode('no_binds_when_editing')
                        selectEdit = 1

                        if guiGetText(idEdit) == 'ID do jogador' then 

                            guiSetText(idEdit, '') 

                        end 

                    end

                elseif isMouseInPosition(536, 387, 293, 35) then 

                    if guiEditSetCaretIndex(timeEdit, string.len(guiGetText(timeEdit))) then

                        guiBringToFront(timeEdit)
                        guiSetInputMode('no_binds_when_editing')
                        selectEdit = 2

                        if guiGetText(timeEdit) == 'Tempo do banimento (Minutos)' then 

                            guiSetText(timeEdit, '') 

                        end 

                    end

                elseif isMouseInPosition(536, 427, 293, 35) then 

                    if guiEditSetCaretIndex(reasonEdit, string.len(guiGetText(reasonEdit))) then

                        guiBringToFront(reasonEdit)
                        guiSetInputMode('no_binds_when_editing')
                        selectEdit = 3

                        if guiGetText(reasonEdit) == 'Motivo do banimento' then 

                            guiSetText(reasonEdit, '') 

                        end

                    end

                elseif isMouseInPosition(814, 267, 15, 15) then 

                    removeStaffBan()    

                elseif (isMouseInPosition(536, 467, 293, 35)) then
                    
                    local encoded = toJSON({guiGetText(idEdit), guiGetText(timeEdit), 'Minutos', guiGetText(reasonEdit), banMethod})
                    local serial = getPlayerSerial(localPlayer);

                    encodeString("aes128", encoded, { key = serial:sub(17) } , function ( enc, env )
                        triggerServerEvent('onPlayerBaned', resourceRoot, enc, env)
                    end)

                end

            end

        end

    end

)

addEvent('onClientPainelPunir', true)
addEventHandler('onClientPainelPunir', root, 

    function() 

        if not isEventHandlerAdded('onClientRender', root, drawStaffBan) then 

            tick, interpolate = getTickCount(), {0, 255}
            addEventHandler('onClientRender', root, drawStaffBan) 
            showCursor(true)
            
            if isElement(idEdit) then 

                destroyElement(idEdit) 

            end

            if isElement(timeEdit) then 

                destroyElement(timeEdit) 

            end

            if isElement(reasonEdit) then 

                destroyElement(reasonEdit) 

            end
            
            idEdit = guiCreateEdit(1000, 1000, 0, 0, 'ID do jogador', false)
            timeEdit = guiCreateEdit(1000, 1000, 0, 0, 'Tempo do banimento (Minutos)', false)
            reasonEdit = guiCreateEdit(1000, 1000, 0, 0, 'Motivo do banimento', false)

            guiSetProperty(idEdit, 'ValidationString', '[0-9]*')
            guiSetProperty(timeEdit, 'ValidationString', '[0-9]*')

            guiEditSetMaxLength(idEdit, 10)
            guiEditSetMaxLength(timeEdit, 10)
            guiEditSetMaxLength(reasonEdit, 34)

        else

            removeStaffBan()   

        end

    end

)

function removeStaffBan()

    if (isEventHandlerAdded('onClientRender', root, drawStaffBan)) then 

        if (interpolate[1] == 0) then 

            tick, interpolate = getTickCount(), {255, 0}
            showCursor(false)
            setTimer(function()

                removeEventHandler('onClientRender', root, drawStaffBan)

            end, 500, 1)

        end

    end

end


function dxDrawTimer()
    
    local remaintTime = interpolateBetween(time, 0, 0, 0, 0, 0, ((getTickCount() - tick_time) / time), 'Linear')
    local min, sec = convertTime(remaintTime)
    dxDrawText('Você sofreu uma punição e sera liberado em '..min..':'..sec..'\n('..reason..')', 502, 685, 362, 42, tocolor(203, 203, 203, 255), 1, fonts[4], 'center', 'center') 

    if remaintTime == 0 then 

        removeEventHandler('onClientRender', root, dxDrawTimer)

    end 

end

addEvent('addTimerPunir', true) 
addEventHandler('addTimerPunir', root, 

    function(time_, reason_)

        tick_time, time, reason = getTickCount(), time_, reason_

        if not isEventHandlerAdded('onClientRender', root, dxDrawTimer) then 

            addEventHandler('onClientRender', root, dxDrawTimer) 

        end

    end

)

addEvent('removeTimerPunir', true)
addEventHandler('removeTimerPunir', root, 

    function()

        removeEventHandler('onClientRender', root, dxDrawTimer)

    end

)

addEventHandler('onClientPlayerDamage', root,

    function()

        if source == localPlayer then 

            if isEventHandlerAdded('onClientRender', root, dxDrawTimer) then 

                cancelEvent()

            end

        end

    end

)

addEventHandler('onClientKey', root,

    function(key, state)

        if (isEventHandlerAdded('onClientRender', root, dxDrawTimer)) then 

            if (state) then

                if (config.blockKeys[key]) then 

                    cancelEvent()

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

function aToR (X, Y, sX, sY)
    local xd = X/resW or X
    local yd = Y/resH or Y
    local xsd = sX/resW or sX
    local ysd = sY/resH or sY
    return xd * screen[1], yd * screen[2], xsd * screen[1], ysd * screen[2]
end

function isMouseInPosition(x, y, w, h)
	if isCursorShowing() then
        local x, y, w, h = aToR (x, y, w, h)
		local sx,sy = guiGetScreenSize()
		local cx,cy = getCursorPosition()
		local cx,cy = (cx*sx),(cy*sy)
		if (cx >= (x) and cx <= x+w) and (cy >= y and cy <= y+h) then
			return true
		end
	end
end

_dxDrawRectangle = dxDrawRectangle
function dxDrawRectangle (x, y, w, h, ...)
    local x, y, w, h = aToR (x, y, w, h)
    return _dxDrawRectangle (x, y, w, h, ...)
end

_dxDrawText = dxDrawText
function dxDrawText (text, x, y, w, h, ...)
    local x, y, w, h = aToR (x, y, w, h)
    return _dxDrawText (text, x, y, (w + x), (h + y), ...)
end

_dxDrawImage = dxDrawImage
function dxDrawImage (x, y, w, h, ...)
    if (x == 0 and y == 0 and w == screen[1] and h == screen[2]) then 
        return _dxDrawImage (x, y, w, h, ...)
    else
        local x, y, w, h = aToR (x, y, w, h)
        return _dxDrawImage (x, y, w, h, ...)
    end
end

size = {}
function drawBorder ( radius, x, y, width, height, color, colorStroke, sizeStroke, postGUI )
    colorStroke = tostring(colorStroke)
    sizeStroke = tostring(sizeStroke)
    if (not size[height..':'..width]) then
        local raw = string.format([[
            <svg width='%s' height='%s' fill='none' xmlns='http://www.w3.org/2000/svg'>
                <mask id='path_inside' fill='#FFFFFF' >
                    <rect width='%s' height='%s' rx='%s' />
                </mask>
                <rect opacity='1' width='%s' height='%s' rx='%s' fill='#FFFFFF' stroke='%s' stroke-width='%s' mask='url(#path_inside)'/>
            </svg>
        ]], width, height, width, height, radius, width, height, radius, colorStroke, sizeStroke)
        size[height..':'..width] = svgCreate(width, height, raw)
    end
    if (size[height..':'..width]) then
        dxDrawImage(x, y, width, height, size[height..':'..width], 0, 0, 0, color, postGUI)
    end
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

function convertTime(ms) 
    local min = math.floor ( ms/60000 ) 
    local sec = math.floor( (ms/1000)%60 ) 

    if (min < 10) then 
        min = '0'..min 
    end 

    if (sec < 10) then 
        sec = '0'..sec 
    end 

    return min, sec 
end

setDevelopmentMode(true)
------------------------------------------------        