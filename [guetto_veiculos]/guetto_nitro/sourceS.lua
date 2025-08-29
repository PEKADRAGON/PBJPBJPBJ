local nosTypes = {}
local nosLevels = {}
local nosTimers = {}
local nosRefillTimers = {}

addEventHandler("onResourceStart", resourceRoot,
	function ()
		for k,v in pairs(getElementsByType("player")) do
			if isPedInVehicle(v) then
				toggleNosKey(v, true)
			else
				toggleNosKey(v, false)
			end
		end
	end
)

function setVehicleBooster (player, nitroLevel)
	if not player then 
		return false 
	end;

	if not nitroLevel then 
		return false 
	end;

	nitroLevel = tonumber(nitroLevel)

	if nitroLevel then
		local currentVehicle = getPedOccupiedVehicle(player)

		if currentVehicle then
			nitroLevel = math.max(1, math.min(nitroLevel, 4))

			if not nosLevels[currentVehicle] then
				nosLevels[currentVehicle] = nitroLevel
			else
				nosLevels[currentVehicle] = nosLevels[currentVehicle] + nitroLevel
			end

			nosTypes[currentVehicle] = "purple"

			for seatId, seatOccuper in pairs(getVehicleOccupants(currentVehicle)) do
				triggerClientEvent(seatOccuper, "gotVehicleNosLevel", currentVehicle, nosLevels[currentVehicle], nosTypes[currentVehicle] == "purple", true, 1000, 1000)
			end
		end
	end
end;


function toggleNosKey(sourcePlayer, keyState)
	if keyState then
		bindKey(sourcePlayer, "n", "down", activateNos)
	else
		unbindKey(sourcePlayer, "n", "down", activateNos)
	end
end

function activateNos(keyPresser)
	local currentVehicle = getPedOccupiedVehicle(keyPresser)

	if currentVehicle then
		local currentSeat = getPedOccupiedVehicleSeat(keyPresser)

		if currentSeat == 0 then
			if nosTimers[currentVehicle] then
				return print("nos is already active")
			end

			if nosRefillTimers[currentVehicle] then
				return print("nos is refilling")
			end

			if not nosLevels[currentVehicle] then
				return print("nos is not installed")
			end

			nosLevels[currentVehicle] = nosLevels[currentVehicle] - 1

			local nosPurple = nosTypes[currentVehicle] == "purple"
			local nosTime = 3640 * (nosPurple and 1 or 0.6)
			local nosRefillTime = 15000

			if nosLevels[currentVehicle] <= 0 then
				nosRefillTime = nosTime
			end

			setVehicleHandling(currentVehicle, "engineAcceleration", getVehicleHandling(currentVehicle).engineAcceleration * 4.8)

			nosTimers[currentVehicle] = setTimer(
				function ()
					triggerClientEvent(root, "nosEffectState", currentVehicle, false)

					setVehicleHandling(currentVehicle, "engineAcceleration", getVehicleHandling(currentVehicle).engineAcceleration / 4.8)

					nosTimers[currentVehicle] = nil
				end,
			nosTime, 1)

			if nosRefillTime ~= nosTime then
				nosRefillTimers[currentVehicle] = setTimer(
					function ()
						nosRefillTimers[currentVehicle] = nil
					end,
				nosRefillTime, 1)
			end

			triggerClientEvent(root, "nosEffectState", currentVehicle, true, nosPurple)

			for seatId, seatOccuper in pairs(getVehicleOccupants(currentVehicle)) do
				triggerClientEvent(seatOccuper, "gotVehicleNosLevel", currentVehicle, nosLevels[currentVehicle], nosPurple, true, nosTime, nosRefillTime)
			end

			if nosLevels[currentVehicle] <= 0 then
				nosTypes[currentVehicle] = nil
				nosLevels[currentVehicle] = nil
			end
		end
	end
end
