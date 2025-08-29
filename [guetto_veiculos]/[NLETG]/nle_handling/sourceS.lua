



addEventHandler("onResourceStart", resourceRoot, function()
    local vehicles = getElementsByType("vehicle")
    for _, vehicle in ipairs(vehicles) do
        local vehicleModel = getElementModel(vehicle)
        local vehicleHandling = vehicleHandlings[vehicleModel]
        if vehicleHandling then
            for flag, value in pairs(vehicleHandling) do
                setVehicleHandling(vehicle, flag, value)
            end
        end
    end
end)

function getDefaultHandling(vehicleModel)
	if vehicleHandlings[vehicleModel] then
		return vehicleHandlings[vehicleModel]
	end
end

function loadHandlingForVehicle(vehicle)
    if vehicleHandlings[getElementModel(vehicle)] then
    	for flag, value in pairs(vehicleHandlings[getElementModel(vehicle)]) do
           setVehicleHandling(vehicle, flag, value)
       	end
    end
end