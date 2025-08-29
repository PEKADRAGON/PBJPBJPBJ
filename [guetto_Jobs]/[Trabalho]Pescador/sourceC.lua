local fishingRods = {}
local fishingFloats = {}

local reelingSounds = {}

addEventHandler("onClientResourceStart", resourceRoot, function()
	setTimer(engineLoadIFP, 1000, 1, "files/anims.ifp", "fishing")
end)

function canStartFishing(x, y, z)
	if x and y and z then
		if not getElementData(localPlayer, "fishing.hasRod") then
			return false
		end

		local isWater, wX, wY, wZ = testLineAgainstWater(x, y, z, x, y, z + MAX_DROP_DISTANCE)
		local closeEnough = getDistanceBetweenPoints3D(x, y, z, getElementPosition(localPlayer)) <= 20
		local playerX, playerY, playerZ = getElementPosition(localPlayer)
		
		local hit = processLineOfSight(x, y, z, x, y, z + MAX_DROP_DISTANCE)

		return isWater and not hit and closeEnough
	end

	return false
end

local lastAction = 0

function clickHandler(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
	if button == "right" and state == "down" then
		if not isPedInVehicle(localPlayer) then
			local worldX, worldY, worldZ = getWorldFromScreenPosition(absoluteX, absoluteY, math.random(15, 25))

			if getElementData(localPlayer, "fishing") then
				toggleAllControls(false)
				triggerServerEvent("stopFishing", resourceRoot)
				return
			end

			if not canStartFishing(worldX, worldY, worldZ) then 
				return 
			end

			if lastAction + 3000 < getTickCount() then
				triggerServerEvent("startFishing", resourceRoot, worldX, worldY, 0)
				toggleAllControls(true)

				lastAction = getTickCount()
			else
				sendPlayerMessage('client', 'Você só pode usar a vara de pescar a cada 3 segundos.', 'info')
			end
		end
	end
end
addEventHandler("onClientClick", root, clickHandler)

function applyFishingAnimation(animName, normalSpeed, loop)
	setPedAnimation(source, animName[1], animName[2], -1, loop)
	local x, y, z = getElementPosition(source)
	
	if animName[2] == ANIM_NAMES.CAST[2] then
		playSound3D("files/cast.mp3", x, y, z, false)
	elseif animName[2] == ANIM_NAMES.IDLE[2] and not normalSpeed then
		setSoundVolume(playSound3D("files/splash.mp3", x, y, z, false), 5)
	elseif animName[2] == ANIM_NAMES.IDLE[2] and normalSpeed then
		reelingSounds[source] = playSound3D("files/reeling.mp3", x, y, z, true)
	end

	local player = source
	setTimer(function()
		local amount = normalSpeed and 1 or 0.5
		setPedAnimationSpeed(player, animName[2], amount)
	end, 1000, 1)
end
addEvent("applyFishingAnimation", true)
addEventHandler("applyFishingAnimation", root, applyFishingAnimation)

function syncRodsAndFloats(rods, floats)
	fishingRods = rods
	fishingFloats = floats
end
addEvent("syncRodsAndFloats", true)
addEventHandler("syncRodsAndFloats", root, syncRodsAndFloats)

function renderCastLines()
	for player, rod in pairs(fishingRods) do
		local float = fishingFloats[player]
		
		if isElement(rod) and isElement(float) then
			local rodX, rodY, rodZ = getPositionFromElementOffset(rod, 0.055, 0.0008, -1.28)
			local rodTipX, rodTipY, rodTipZ = getElementPosition(rod)
			dxDrawLine3D(rodTipX, rodTipY, rodTipZ + 0.005, rodX, rodY, rodZ, 0x99817253, 0.3)

			local floatX, floatY, floatZ = getElementPosition(float)
			dxDrawLine3D(rodX, rodY, rodZ, floatX, floatY, floatZ, 0x99817253, 0.4)
		end
	end
end
addEventHandler("onClientRender", root, renderCastLines)

addEvent("stopReelingSound", true)
addEventHandler("stopReelingSound", root, function()
	if isElement(reelingSounds[source]) then
		stopSound(reelingSounds[source])
	end
end)

function onMinigameFailed()
	sendPlayerMessage('client', 'O peixe escapou do anzol.', 'error')
	triggerServerEvent("stopFishing", resourceRoot)
end
addEvent("onFishingMinigameFailed", true)
addEventHandler("onFishingMinigameFailed", root, onMinigameFailed)

function onMinigameSucceeded()

	if not getElementData(localPlayer, "FinishedFishing") then
		return 
	end

	local randomFish = math.random(1, #FISHES)
	local itemName = FISHES[randomFish].name

	bindKey("mouse1", "down", takeFish, FISHES[randomFish].id)
	bindKey("mouse2", "down", throwFish)

	sendPlayerMessage('client', 'Você pegou o seguinte peixe: ' .. itemName .. '. Você pode vende-lo com um clique esquerdo e jogar o peixe de volta com um clique direito.', 'success')
	sendPlayerMessage('client', 'Você pode vende-lo com um clique esquerdo e jogar o peixe de volta com um clique direito.', 'success')

	triggerServerEvent("stopFishing", resourceRoot, true)
	triggerServerEvent("toggleRod", resourceRoot, false)

	setElementData(localPlayer, "FinishedFishing", false)
end
addEvent("onFishingMinigameSucceeded", true)
addEventHandler("onFishingMinigameSucceeded", root, onMinigameSucceeded)


local pedRod = createPed(0, 154.212, -1942.274, 3.773, 0)
setElementData(pedRod, "ped.rod", true)
setElementData(pedRod, 'ped.assault', true)
setElementFrozen(pedRod, true)

function onPedClick(b, s, _, _, _, _, _, element)
	if b == "left" and s == "down" then
		if element and isElement(element) and getElementType(element) == "ped" then
			local distance = getDistanceBetweenPoints3D(Vector3(getElementPosition(localPlayer)), Vector3(getElementPosition(element)))

			if distance < 5 then
				if getElementData(element, "ped.rod") then
					triggerServerEvent("toggleRod", resourceRoot)
				end
			end
		end
	end
end
addEventHandler("onClientClick", root, onPedClick) 

function throwFish()
	sendPlayerMessage('client', 'Você jogou de volta com sucesso o peixe capturado.', 'success')
	triggerServerEvent("removeFish", resourceRoot)

	unbindKey("mouse1", "down", takeFish)
	unbindKey("mouse2", "down", throwFish)
end

function takeFish(key, keyState, fishItem)
	triggerServerEvent("removeFish", resourceRoot, true, fishItem)
	unbindKey("mouse1", "down", takeFish)
	unbindKey("mouse2", "down", throwFish)
end

function getPositionFromElementOffset(element,offX,offY,offZ)
	if not isElement(element) then 
		return 
	end
	local m = getElementMatrix(element)
	local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]
	local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
	local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
	return x, y, z
end


addEventHandler('onClientResourceStart', resourceRoot,
function()
	txd = engineLoadTXD( "files/rod.txd" )
	dff = engineLoadDFF( "files/rod.dff" )

	engineImportTXD( txd, 338 )
	engineReplaceModel( dff, 338 )
end)