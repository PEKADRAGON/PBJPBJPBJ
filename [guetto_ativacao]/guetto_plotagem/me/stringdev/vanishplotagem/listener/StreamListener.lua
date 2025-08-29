function onVehicleStreamIn()
    local vehicle = source
    if not (vehicle) then return end
    if (vehicle:getType() ~= "vehicle") then return end

    local vehicleId = vehicle:getModel()
    if not (vehicleId) then return end
    if not (config["vehiclesPlotagem"][vehicleId]) then return end

    for data, texture in pairs(config["vehiclesPlotagem"][vehicleId]) do
        if (vehicle:getData(data)) then
            Async:foreachPairs(texture, function(_, v)
                applyShaderPlotagem(vehicle, v["TextureName"], v["LocalPNG"])
            end)
        end
    end
end
addEventHandler("onClientElementStreamIn", getRootElement(), onVehicleStreamIn)

function onVehicleStreamOut()
    local vehicle = source
    if not (vehicle) then return end
    if (vehicle:getType() ~= "vehicle") then return end

    local vehicleId = vehicle:getModel()
    if not (vehicleId) then return end
    if not (config["vehiclesPlotagem"][vehicleId]) then return end
    if not (vehicles[vehicle]) then return end

    for textureName, tbl in pairs(vehicles[vehicle]) do
        tbl.shader:removeFromWorldTexture(textureName, vehicle)
    end
end
addEventHandler("onClientElementStreamOut", getRootElement(), onVehicleStreamOut)