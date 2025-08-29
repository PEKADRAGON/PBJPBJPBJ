--[[
    --» sᴄʀɪᴘᴛ ғᴇɪᴛᴏ ᴘᴏʀ » Pedrooooo#1554
--]]

local x, y = guiGetScreenSize() 
local startX, startY = (x - 235), (y / 2 - 166)

local fonts = {
    dxCreateFont('assets/fonts/regular.ttf', 13); 
    dxCreateFont('assets/fonts/regular.ttf', 15); 
    dxCreateFont('assets/fonts/regular.ttf', 20); 
}

function draw_firefighter()
    local alpha = interpolateBetween(interpolate[1], 0, 0, interpolate[2], 0, 0, ((getTickCount() - tick) / 500), 'Linear')
    dxDrawImage(startX, startY, 222, 332, 'assets/base.png', 0, 0, 0, tocolor(255, 255, 255, alpha))
    dxDrawText(config.description, (startX + 111) - (dxGetTextWidth(config.description, 1, fonts[1]) / 2), startY + 82, 0, 0, tocolor(192, 192, 192, alpha), 1, fonts[1])

    for i = 1, 3 do 
        drawBorder(2, startX + 153, (startY + 128) + (48 * (i - 1)), 57, 19, (isMouseInPosition(startX + 153, (startY + 128) + (48 * (i - 1)), 57, 19) and tocolor(100, 78, 238, alpha) or tocolor(54, 58, 66, alpha)))
        dxDrawText('PEGAR', (startX + 182) - (dxGetTextWidth('PEGAR', 1, fonts[1]) / 2), (startY + 128) + (48 * (i - 1)), 0, 0, tocolor(255, 255, 255, alpha), 1, fonts[1])
    end

    drawBorder(2, startX + 5, startY + 269, 212, 23, (isMouseInPosition(startX + 5, startY + 269, 212, 23) and tocolor(100, 78, 238, alpha) or tocolor(54, 58, 66, alpha)))
    dxDrawText('ENTREGAR MATERIAL', (startX + 111) - (dxGetTextWidth('ENTREGAR MATERIAL', 1, fonts[2]) / 2), startY + 268, 0, 0, tocolor(255, 255, 255, alpha), 1, fonts[2])

    drawBorder(2, startX + 5, startY + 296, 212, 23, (isMouseInPosition(startX + 5, startY + 296, 212, 23) and tocolor(255, 90, 90, alpha) or tocolor(54, 58, 66, alpha)))
    dxDrawText('FECHAR', (startX + 111) - (dxGetTextWidth('FECHAR', 1, fonts[2]) / 2), startY + 296, 0, 0, tocolor(255, 255, 255, alpha), 1, fonts[2])
end

addEventHandler('onClientClick', root, 
    function(b, s) 
        if (b == 'left' and s == 'down') then 
            if (isEventHandlerAdded('onClientRender', root, draw_firefighter)) then 
                if (isMouseInPosition(startX + 5, startY + 269, 212, 23)) then 
                    triggerServerEvent('onPlayerGiveBackFirefighterItens', localPlayer, localPlayer)
                elseif (isMouseInPosition(startX + 5, startY + 296, 212, 23)) then   
                    removeFirefighter() 
                else
                    for i = 1, 3 do
                        if (isMouseInPosition(startX + 153, (startY + 128) + (48 * (i - 1)), 57, 19)) then
                            if (i == 1) then 
                                triggerServerEvent('onPlayerColectFirefighterSkin', localPlayer, localPlayer)
                            elseif (i == 2) then 
                                triggerServerEvent('onPlayerGetFirefighterItens', localPlayer, localPlayer) 
                            elseif (i == 3) then 
                                triggerServerEvent('onPlayerGetVehicleFirefighterVehicle', localPlayer, localPlayer, index)
                            end
                        return end 
                    end
                end
            end
        end
    end
)

addEvent('onClientDrawFirefighter', true)
addEventHandler('onClientDrawFirefighter', root, 
    function(index_)
        if not (isEventHandlerAdded('onClientRender', root, draw_firefighter)) then 
            tick, interpolate, index = getTickCount(), {0, 255}, index_
            addEventHandler('onClientRender', root, draw_firefighter)
            showCursor(true)
        end
    end
)

function removeFirefighter()
    if (isEventHandlerAdded('onClientRender', root, draw_firefighter)) then 
        if (interpolate[1] == 0) then 
            tick, interpolate = getTickCount(), {255, 0}
            showCursor(false) 
            setTimer(function()
                removeEventHandler('onClientRender', root, draw_firefighter)
            end, 500, 1)
        end
    end
end

--[[
    local fireEffect = {}
addEvent('onClientVehicleStartFire', true)
addEventHandler('onClientVehicleStartFire', root, 
    function(vehicle)
        if (isElement(vehicle)) then 
            if (isElement(fireEffect[vehicle])) then 
                destroyElement(fireEffect[vehicle]) 
            end
            local x, y, z = getElementPosition(vehicle)
            fireEffect[vehicle] = createEffect('fire_car', x, y, z, _, _, _, 0, true)
            attachEffect(fireEffect[vehicle], vehicle, Vector3(0, 0, 0))
        end
    end
)
]]

addEvent('onClientDestroyVehicleFire', true)
addEventHandler('onClientDestroyVehicleFire', root, 
    function(vehicle)
        if (isElement(vehicle)) then 
            setElementData(vehicle, 'onFireVehicle', nil)
            if (isElement(fireEffect[vehicle])) then 
                destroyElement(fireEffect[vehicle]) 
            end
        end
    end
)

addEventHandler('onClientVehicleWeaponHit', root, 
    function(weaponType, hitElement, hitX, hitY, hitZ, model, materialID)
        if (weaponType == 1) then 
            if (isElement(hitElement) and getElementType(hitElement) == 'vehicle' and getElementData(hitElement, 'onFireVehicle')) then 
                local remain_fire = getElementData(hitElement, 'onFireVehicle') 
                if (tonumber(remain_fire)) then 
                    if (tonumber(remain_fire) > 0) then 
                        setElementData(hitElement, 'onFireVehicle', tonumber(remain_fire) - 2)
                    else 
                        setElementData(hitElement, 'onFireVehicle', nil)

                        if (isElement(fireEffect[hitElement])) then 
                            destroyElement(fireEffect[hitElement]) 
                        end

                        triggerServerEvent('onPlayerDestroyVehicleFire', localPlayer, hitElement)

                        local controller = getVehicleController(source)
                        if (isElement(controller)) then 
                            triggerServerEvent('onPlayerReceiveFirefighterSuccessReport', localPlayer, controller)
                        end
                    end
                else
                    setElementData(hitElement, 'onFireVehicle', nil)

                    if (isElement(fireEffect[hitElement])) then 
                        destroyElement(fireEffect[hitElement]) 
                    end
                end
            end
        end
    end
)

--addEventHandler('onClientRender', root, 
--    function()
--        if (isPedInVehicle(localPlayer)) then 
--            local vehicle = getPedOccupiedVehicle(localPlayer)
--            if (isElement(vehicle)) then 
--                if (getElementData(vehicle, 'onFireVehicle')) then 
--                    if not (tick_intoxication) then 
--                        tick_intoxication = getTickCount() 
--                    end 
--
--                    if not (died_intoxication) then 
--                        local time_intoxication = interpolateBetween(300, 0, 0, 0, 0, 0, ((getTickCount() - tick_intoxication) / (300 * 1000)), 'Linear')
--                      --  dxDrawText('VOCÊ TEM '..math.floor(time_intoxication)..' SEGUNDOS ANTES DE MORRER DE INTOXICAÇÃO', x / 2 - (dxGetTextWidth('VOCÊ TEM '..math.floor(time_intoxication)..' SEGUNDOS ANTES DE MORRER DE INTOXICAÇÃO', 1, fonts[3]) / 2), y - 80, 0, 0, tocolor(255, 255, 255, alpha), 1, fonts[3])
--
--                        if (time_intoxication == 0) then 
--                            triggerServerEvent('onPlayerIntoxicationDeath', localPlayer, localPlayer)
--                            died_intoxication = true 
--                        end
--                    end
--                return else  
--                    tick_intoxication = nil 
--                    died_intoxication = nil 
--                end
--            return else
--                tick_intoxication = nil 
--                died_intoxication = nil 
--            end
--        return end
--
--        tick_intoxication = nil 
--        died_intoxication = nil 
--    end
--)

--function draw_firefighterDoor()
--    local alpha = interpolateBetween(0, 0, 0, 255, 0, 0, ((getTickCount() - tick_door) / 500), 'Linear')
--    dxDrawText('PRESSIONE "#644EEEH#FFFFFF" PARA ABRIR A PORTA', x / 2 - (dxGetTextWidth('PRESSIONE "#644EEEH#FFFFFF" PARA ABRIR A PORTA', 1, fonts[3], true) / 2), y - 80, 0, 0, tocolor(255, 255, 255, alpha), 1, fonts[3], 'left', 'top', false, false, false, true)
--end

addEventHandler('onClientKey', root, 
    function(key, press)
        if (isEventHandlerAdded('onClientRender', root, draw_firefighterDoor) and press) then
            if (key == 'h' or key == 'H') then
                triggerServerEvent('onFirefighterOpenDoor', localPlayer, localPlayer, vehicle)
                removeEventHandler('onClientRender', root, draw_firefighterDoor)
                cancelEvent()
            end
        end 
    end
)

--addEvent('onClientDrawFirefighterDoor', true)
--addEventHandler('onClientDrawFirefighterDoor', root, 
--    function(vehicle_)
--        if not (isEventHandlerAdded('onClientRender', root, draw_firefighterDoor)) then 
--            tick_door, vehicle = getTickCount(), vehicle_
--            addEventHandler('onClientRender', root, draw_firefighterDoor)
--        end
--    end
--)

--addEvent('onClientRemoveFirefighterDoor', true)
--addEventHandler('onClientRemoveFirefighterDoor', root, 
--    function()
--        removeEventHandler('onClientRender', root, draw_firefighterDoor)
--    end
--)

local randomFire, randomFireEffect = {}, {}
addEvent('onClientCreateFire', true)
addEventHandler('onClientCreateFire', root, 
    function(x, y, z, index)
        if (isElement(randomFireEffect[index])) then 
            destroyElement(randomFireEffect[index])
        end

        randomFireEffect[index] = createEffect('fire_car', x, y, z, _, _, _, 0, true)
        setElementData(randomFireEffect[index], 'onFireVehicle', 50)

        setTimer(function(index, x, y, z)
            addEventHandler('onClientVehicleWeaponHit', root, 
                function(weaponType, hitElement, hitX, hitY, hitZ, model, materialID)
                    if (weaponType == 1) then 
                        if (isElement(randomFireEffect[index])) then 
                            if (getDistanceBetweenPoints3D(x, y, z, hitX, hitY, hitZ) <= 4) then 
                                local remain_fire = getElementData(randomFireEffect[index], 'onFireVehicle') 
                                if (tonumber(remain_fire)) then 
                                    if (tonumber(remain_fire) > 0) then 
                                        setElementData(randomFireEffect[index], 'onFireVehicle', tonumber(remain_fire) - 2)
                                    else 
                                        setElementData(randomFireEffect[index], 'onFireVehicle', nil)
                                    
                                        if (isElement(randomFireEffect[index])) then 
                                            destroyElement(randomFireEffect[index]) 
                                        end
                                    
                                        triggerServerEvent('onPlayerDestroyNaturalFire', localPlayer, index)
                                        
                                        if (getVehicleController(source)) then 
                                            triggerServerEvent('onPlayerReceiveNaturalFightSuccessMessage', source, (getVehicleController(source)), index)
                                        end
                                    end
                                else
                                    setElementData(randomFireEffect[index], 'onFireVehicle', nil)
                                
                                    if (isElement(randomFireEffect[index])) then 
                                        destroyElement(randomFireEffect[index]) 
                                    end
                                end
                            end
                        end
                    end
                end
            )
        end, 100, 1, index, x, y, z)
    end 
)

addEvent('onClientDestroyNaturalFire', true)
addEventHandler('onClientDestroyNaturalFire', root,
    function(index)
        if (isElement(randomFireEffect[index])) then 
            destroyElement(randomFireEffect[index])
        end
    end
)
------------------------------------------------
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

function formatNumber(number, sep)
	assert(type(tonumber(number))=="number", "Bad argument @'formatNumber' [Expected number at argument 1 got "..type(number).."]")
	assert(not sep or type(sep)=="string", "Bad argument @'formatNumber' [Expected string at argument 2 got "..type(sep).."]")
	local money = number
	for i = 1, tostring(money):len()/3 do
		money = string.gsub(money, "^(-?%d+)(%d%d%d)", "%1"..sep.."%2")
	end
	return money
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

local attachedEffects = {}

-- Taken from https://wiki.multitheftauto.com/wiki/GetElementMatrix example
function getPositionFromElementOffset(element,offX,offY,offZ)
	local m = getElementMatrix ( element )  -- Get the matrix
	local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform
	local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
	local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
	return x, y, z  -- Return the transformed point
end

function attachEffect(effect, element, pos)
	attachedEffects[effect] = { effect = effect, element = element, pos = pos }
	addEventHandler("onClientElementDestroy", effect, function() attachedEffects[effect] = nil end)
	addEventHandler("onClientElementDestroy", element, function() attachedEffects[effect] = nil end)
	return true
end

addEventHandler("onClientPreRender", root, 	
	function()
		for fx, info in pairs(attachedEffects) do
			local x, y, z = getPositionFromElementOffset(info.element, info.pos.x, info.pos.y, info.pos.z)
			setElementPosition(fx, x, y, z)
		end
	end
)
------------------------------------------------        