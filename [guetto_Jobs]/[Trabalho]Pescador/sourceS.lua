local fishingRods = {}
local fishingFloats = {}

local caughtFishes = {}

local catchTimers = {}

addEventHandler("onResourceStart", resourceRoot, function()
	for k, v in pairs(getElementsByType("player")) do
		setElementData(v, "fishing.hasRod", false)
	end
end)

function createRod(player)
	local rod = createObject(ROD_OBJECT_ID, 0, 0, 0)
	exports.bone_attach:attachElementToBone(rod, player, 12, 0, 0.02, 0.05, 180, 90, 0)
	fishingRods[player] = rod
	sendPlayerMessage('server', player, 'Voçé pegou sua vara de pescar.', 'success')
	setElementData(player, "fishing.hasRod", true)
	updateRodsAndFloats()
end

local BlipEmprego = createBlip(154.212, -1942.274, 3.773, 42)

addCommandHandler("infos",
function(player)
	if player and isElement(player) then
		if getElementData(player, "Emprego") == "Pescador" then
			if not isTimer(TimerEmprego) then
				blip = createBlip(154.212, -1942.274, 3.773, 10.82, 41)
				setElementVisibleTo(blip, root, false)
				setElementVisibleTo(blip, player, true)
				sendPlayerMessage('server', player, "Seu local de emprego foi marcado em seu GPS com sucesso!", "success")
				triggerClientEvent(player, "JOAO.marcadorJobs", player, 154.212, -1942.274, 3.773, 0, 0, "Emprego")
				TimerEmprego = setTimer(function()
					if player and isElement(player) then
						triggerClientEvent(player, "JOAO.removeMarcadorJobs", player)
						if isElement(blip) then destroyElement(blip) end
					end
				end, 60000, 1)
			else
				sendPlayerMessage('server', player, "Você já tem um local de emprego marcado!", "error")
			end
		end
	end
end)


function destroyRod()
	if not client then
		return
	end

	local player = client
	
	if fishingFloats[player] then
		stopFishing(player)
	end

	if fishingRods[player] then
		destroyElement(fishingRods[player])
		fishingRods[player] = nil
		if fishingFloats[player] then
			destroyFloat(player)
		end
		updateRodsAndFloats()
	end

	destroyCatchTimer(player)

	setElementData(player, "fishing.hasRod", false)
end

function toggleRod()
	if not client then
		return
	end

	local player = client

	if getElementData(player, 'Emprego') ~= 'Pescador' then
		sendPlayerMessage('server', player, 'Você não é um pescador.', 'error')
		return 
	end

	if fishingRods[player] then
		destroyRod(player)

		if getElementData(player, "player.Fishing") then
			stopFishing(player)
		end
	else
		createRod(player)
	end
end
addEvent("toggleRod", true)
addEventHandler("toggleRod", root, toggleRod)

function createFloat(player, x, y, z)
	destroyFloat(player)

	local float = createObject(3003, x, y, 0)
	setElementCollisionsEnabled(float, false)
	fishingFloats[player] = float
	updateRodsAndFloats()

	setElementData(player, "fishing", true)

	createCatchTimer(player)
end

function destroyFloat(player)
	if fishingFloats[player] then
		destroyElement(fishingFloats[player])
		fishingFloats[player] = nil
		updateRodsAndFloats()
	end

	setElementData(player, "fishing", false)
end

function createCatchTimer(player)
	destroyCatchTimer(player)
	local catchTime = math.random(CATCH_TIME_MIN, CATCH_TIME_MAX)

	catchTimers[player] = setTimer(function()
		triggerClientEvent("applyFishingAnimation", player, ANIM_NAMES.EXHAUST, true)
		sendPlayerMessage('server', player, 'Algo preso no anzol! O minijogo começará em 5 segundos, Use as setas esquerda e direita para manter o peixe na área escura.', 'info')
		
		triggerClientEvent(player, "startFishingMinigame", player)
	end, catchTime, 1)

end

function destroyCatchTimer(player)
	local timer = catchTimers[player]

	if timer then
		if isTimer(timer) then
			killTimer(timer)
		end

		catchTimers[player] = nil
	end
end

function updateRodsAndFloats()
	triggerClientEvent("syncRodsAndFloats", root, fishingRods, fishingFloats)
end

function startFishing(x, y, z)
	if not client then
		return
	end

	local player = client
	triggerClientEvent("applyFishingAnimation", player, ANIM_NAMES.CAST)
	local pX, pY = getElementPosition(player)
	setElementRotation(player, 0, 0, findRotation(pX, pY, x, y))

	setTimer(function()
		triggerClientEvent("applyFishingAnimation", player, ANIM_NAMES.IDLE)
		createFloat(player, x, y, z)
	end, 1200, 1)

	setElementData(player, "player.Fishing", true)
end
addEvent("startFishing", true)
addEventHandler("startFishing", root, startFishing)

function stopFishing(hasCatch)

	if not client then
		return
	end

	local player = client

	destroyFloat(player)

	setPedAnimation(player)
	updateRodsAndFloats()


	destroyCatchTimer(player)

	if hasCatch then
		local caughtFish = createObject(1608, 0, 0, 0)
		setObjectScale(caughtFish, 0.02)
		exports.bone_attach:attachElementToBone(caughtFish, player, 12, 0, 0.05, 0.05, 90, -90, 0)

		caughtFishes[player] = caughtFish

		triggerClientEvent("applyFishingAnimation", player, ANIM_NAMES.HOLDING)
	end

	triggerClientEvent(player, "stopFishingMinigame", player)
	triggerClientEvent("stopReelingSound", player)

	setElementData(player, "player.Fishing", false)
end
addEvent("stopFishing", true)
addEventHandler("stopFishing", root, stopFishing)

addEvent("removeFish", true)
addEventHandler("removeFish", root, function(takeIt, fishItemId)

	if not client then 
		return
	end

	if getElementData(client, 'Emprego') ~= 'Pescador' then
		sendPlayerMessage('server', client, 'Você não é um pescador.', 'error')
		return
	end

	if isElement(caughtFishes[client]) then
		if not takeIt then
			triggerClientEvent("applyFishingAnimation", client, ANIM_NAMES.THROW, false, false)
		end

		local moneyRaiming = math.random(FISH_PRICE_MIN, FISH_PRICE_MAX)

		givePlayerMoney(client, moneyRaiming)

		local expp = (getElementData(client, 'XP') or 0)
		local isVip = exports["guetto_util"]:isPlayerVip(client)

		if (isVip) then 
			setElementData(client, "XP", expp+350)
		else
			setElementData(client, "XP", expp+280)
		end

		sendPlayerMessage('server', client, 'Você Vendeu com sucesso o peixe que pescou e ganhou R$ ' ..moneyRaiming.. '.', 'success')
		destroyElement(caughtFishes[client])
		toggleRod(client)
	end

	setTimer(setPedAnimation, 1000, 1, client)
end)

addEventHandler("onPlayerQuit", root, function()
	if getElementData(source, "fishing.hasRod") then
		destroyRod(source)
	end
	if isElement(caughtFishes[source]) then
		destroyElement(caughtFishes[source])
	end
end)

function findRotation(x1, y1, x2, y2)
	local t = -math.deg(math.atan2(x2 - x1, y2 - y1))
	return t < 0 and t + 360 or t
end