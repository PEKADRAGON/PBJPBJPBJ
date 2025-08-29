--[[
    --» sᴄʀɪᴘᴛ ғᴇɪᴛᴏ ᴘᴏʀ » Pedro Developer
--]]

addEvent('createPop', true)
addEventHandler('createPop', root, 

    function(x, y, z)

        local destroyEffectTime = config.flyTime * 0.85 
        local signalFX = createEffect('spraycan', x, y, z-0.1, 0, 0, 0, 8191)
        smokeFX = createEffect('riot_smoke', x, y, z, -90, 0, 0, 8191)

        setTimer(function()
            smokeFX = createEffect('riot_smoke', x, y, z, -90, 0, 0, 8191)
        end, destroyEffectTime/2, 1)

        createEffect('camflash', x, y, z, 0, 0, 0, 8191)
        createEffect('shootlight', x, y, z, -90, 0, 0, 8191)
        local teargasObj = createObject(343, x, y, z-0.2, 90, 0, math.random(0,360))
        setElementCollisionsEnabled(teargasObj,false)

        local popSnd = playSound3D('assets/sounds/pop.mp3', x, y, z, false)
        setSoundMaxDistance(popSnd, 100)

        setTimer(function()
            
            if (isElement(signalFX)) then 

                destroyElement(signalFX)
            
            end

            if isElement(smokeFX) then

                destroyElement(smokeFX)

            end

            destroyElement(teargasObj)

        end, destroyEffectTime, 1)

    end

)

addEvent('setPlaneProperties', true)
addEventHandler('setPlaneProperties', root, 

    function(obj, flyTime, zRot)

	    local x, y, z = getElementPosition(obj)
	    local modelID = getElementModel(obj)
	    attachSoundToElement('assets/sounds/jet.wav', obj, flyTime)
	    engineSetModelLODDistance(modelID, 300)

    end

)

addEvent('setPackageProperties', true)
addEventHandler('setPackageProperties', root, 

    function(index, plane, position)

	    local zPos = 0
	    triggerServerEvent('onPackageLeavePlane', resourceRoot, index, position[1], position[2], position[3], zPos)

    end

)

addEvent('onClientPlayAirdropSound', true)
addEventHandler('onClientPlayAirdropSound', root, 

    function(position)

        local sound = playSound('assets/sounds/sfx.mp3')

    end

)

addEventHandler('onClientResourceStart', root, 

    function()

        local txd = engineLoadTXD('assets/textura/texture.txd')
        engineImportTXD(txd, 2919)
        engineSetModelLODDistance(2919, 300)

        engineImportTXD(txd, 2903)
        engineSetModelLODDistance(2903, 300)

        engineImportTXD(txd, 1681)
        engineSetModelLODDistance(1681, 300)

    end

)
------------------------------------------------
function attachSoundToElement(path, elem, duration)
	local x, y, z = getElementPosition(elem)
	local sound = playSound3D(path, x, y, z, true)
	attachElements(sound, elem)
	setSoundVolume(sound, 1)
	setSoundMaxDistance(sound, 1500)
	setTimer(destroyElement, duration, 1, sound)
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

function math.round(num, decimals)
    decimals = math.pow(10, decimals or 0)
    num = num * decimals
    if num >= 0 then num = math.floor(num + 0.5) else num = math.ceil(num - 0.5) end
    return num / decimals
end

function dxRectangleRounded(x, y, w, h, color, postGUI)
    dxDrawRectangle(x, y, w, h, color, postGUI)
    dxDrawRectangle(x + 2, y - 1, w - 4, 1, color, postGUI)
    dxDrawRectangle(x + 2, y + h, w - 4, 1, color, postGUI)
    dxDrawRectangle(x - 1, y + 2, 1, h - 4, color, postGUI)
    dxDrawRectangle(x + w, y + 2, 1, h - 4, color, postGUI)
end
------------------------------------------------        