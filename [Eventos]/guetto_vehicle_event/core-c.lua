addEventHandler("onClientVehicleDamage", root, function()
    if getElementData(source, "EventVehicle") then 
        cancelEvent()
    end
end)