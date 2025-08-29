function vehicleDataChange(theKey, oldValue, newValue)
    local vehicle = source
    if not (vehicle) then return end
    if not (newValue) then return end
    if (vehicle:getType() ~= "vehicle") then return end

    local vehicleId = vehicle:getModel()
    if not (vehicleId) then return end
    if not (config["vehiclesPlotagem"][vehicleId]) then return end
    if not (config["vehiclesPlotagem"][vehicleId][theKey]) then return end

    Async:foreachPairs(config["vehiclesPlotagem"][vehicleId][theKey], function(_, v)
        applyShaderPlotagem(vehicle, v["TextureName"], v["LocalPNG"])
    end)
end
addEventHandler("onClientElementDataChange", getRootElement(), vehicleDataChange)