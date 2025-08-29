function loadHandling(vehicle)
	if vehicle then
		local engineAcceleration = getElementData(vehicle, "tuning.engineAcceleration") or false
		local freio = getElementData(vehicle, "tuning.freio") or false
		local maxVelocity = getElementData(vehicle, "tuning.maxVelocity") or false
		local pneu = getElementData(vehicle, "tuning.pneu") or false
		local neonA = getElementData(vehicle, "tuning.neonA") or false
		local suspensao = getElementData(vehicle, "tuning.suspensao") or false
		if config["Carros"][(getElementModel(vehicle))] then
			for i, v in pairs(config["Carros"][(getElementModel(vehicle))]) do
				if i == "engineAcceleration" then
					setVehicleHandling(vehicle, "engineAcceleration", (engineAcceleration and v+engineAcceleration or v))
				elseif i == "maxVelocity" then
					setVehicleHandling(vehicle, "maxVelocity", (maxVelocity and v+maxVelocity[1] or v))
				elseif i == "brakeDeceleration" then
					setVehicleHandling(vehicle, "brakeDeceleration", (freio and v+freio[1] or v))
				elseif i == "suspensionLowerLimit" then
					setVehicleHandling(vehicle, "suspensionLowerLimit", (suspensao and v+suspensao[1] or v))
				else
					setVehicleHandling(vehicle, i, v)
				end
			end
		end
	end
end

tunning = {}

function loadHandlings()
	for k, v in ipairs(getElementsByType('vehicle')) do
		if (not tunning[v]) then
			loadHandling(v)
		end
	end
end
addEventHandler('onResourceStart', getResourceRootElement(getThisResource()), loadHandlings)

function vehicleEnter()
	if (not tunning[source]) then
		loadHandling(source)
	end
end
addEventHandler('onVehicleEnter', getRootElement(), vehicleEnter)

addEvent('tr4jado.onVehicleTunning ',true)
addEventHandler('tr4jado.onVehicleTunning', root, function(vehicle)
	if (isElement(vehicle)) then
		tunning[vehicle] = true
	end
end)

veh = {}

addCommandHandler('cv', function(player, _, id)
	local id = tonumber(id)
	if id then
		if (isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(player)), aclGetGroup('Console'))) then 
			if (isElement(veh[player])) then destroyElement(veh[player]) end
			local x, y, z = getElementPosition(player)
			local int = getElementInterior(player)
			local dim = getElementDimension(player)
			veh[player] = createVehicle(tonumber(id), x, y, z)
			if (isElement(veh[player])) then
				warpPedIntoVehicle(player, veh[player])
				setElementData(veh[player], 'Owner', getAccountName(getPlayerAccount(player)))
				setVehicleEngineState(veh[player], true)
			end
		end 
	end
end)

function setPacote(player)
	local vehicle = getPedOccupiedVehicle(player)
	setElementData(vehicle, "fuel.gasoline", 100)
	setVehicleDamageProof(vehicle, true)
end

function getSuspension(idVehicle)
	if config["Carros"][idVehicle] and config["Carros"][idVehicle]["suspensionLowerLimit"] then
		return config["Carros"][idVehicle]["suspensionLowerLimit"]
	end
	return 0
end