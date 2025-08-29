sendMessageServer = function (player, msg, type)
	return exports['guetto_notify']:showInfobox(player, type, msg)
end;

function vehicleHPVerify(damage)
	if (getElementHealth(source) - damage) <= 350 then
		setElementHealth(source, 350)
		setVehicleDamageProof(source, true)
		setVehicleEngineState(source, false)
		setElementData(source, "Engine", false)
		local driver = getVehicleController(source)
		if driver ~= nil then
			sendMessageServer(driver, "Seu veículo quebrou! Use um kit de reparo ou chame um mecânico", "info")
		end
	end
end
addEventHandler("onVehicleDamage", root, vehicleHPVerify)

addEventHandler("onVehicleEnter", root, function()
	if getElementHealth(source) <= 350 then
		local driver = getVehicleOccupant(source)
		sendMessageServer(driver, "Este veículo está quebrado! Use um kit de reparo ou chame um mecânico", "info")
	end
end)
