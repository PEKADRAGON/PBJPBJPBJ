HandlingAntiga = {}

addEventHandler("onPlayerLogin", root, 
function ()
    HandDrift(source)
end)

addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), 
function ()
    for i,v in ipairs(getElementsByType('player')) do 
        bindKey(v, "lshift", "down", 
        function (thePlayer)
            if thePlayer and isElement(thePlayer) and getElementType(thePlayer) == "player" and isPedInVehicle(thePlayer) and getVehicleOccupant(getPedOccupiedVehicle(thePlayer), 0) == thePlayer and getVehicleType(getPedOccupiedVehicle(thePlayer)) == "Automobile" and config.IDSPerm[getElementModel(getPedOccupiedVehicle(thePlayer))] then 
                HandlingAntiga[getPedOccupiedVehicle(thePlayer)] = getVehicleHandling(getPedOccupiedVehicle(thePlayer))
                for i,v in pairs(config.HandlingDrift) do 
                    setVehicleHandling(getPedOccupiedVehicle(thePlayer), i, v)
                end 
            end 
        end)
        bindKey(v, "lshift", "up", 
        function (thePlayer)
            if thePlayer and isElement(thePlayer) and getElementType(thePlayer) == "player" and isPedInVehicle(thePlayer) and getVehicleOccupant(getPedOccupiedVehicle(thePlayer), 0) == thePlayer  and getVehicleType(getPedOccupiedVehicle(thePlayer)) == "Automobile" and config.IDSPerm[getElementModel(getPedOccupiedVehicle(thePlayer))] then 
                for i,v in pairs(HandlingAntiga[getPedOccupiedVehicle(thePlayer)]) do 
                    setVehicleHandling(getPedOccupiedVehicle(thePlayer), i, v)
                end 
            end 
        end)
    end 
end)

function HandDrift(thePlayer)
    bindKey(thePlayer, "lshift", "down", 
    function (thePlayer)
        if thePlayer and isElement(thePlayer) and getElementType(thePlayer) == "player" and isPedInVehicle(thePlayer) and getVehicleOccupant(getPedOccupiedVehicle(thePlayer), 0) == thePlayer  and getVehicleType(getPedOccupiedVehicle(thePlayer)) == "Automobile" and config.IDSPerm[getElementModel(getPedOccupiedVehicle(thePlayer))] then 
            HandlingAntiga[getPedOccupiedVehicle(thePlayer)] = getVehicleHandling(getPedOccupiedVehicle(thePlayer))
            for i,v in pairs(config.HandlingDrift) do 
                setVehicleHandling(getPedOccupiedVehicle(thePlayer), i, v)
            end 
        end 
    end)
    bindKey(thePlayer, "lshift", "up", 
    function (thePlayer)
        if thePlayer and isElement(thePlayer) and getElementType(thePlayer) == "player" and isPedInVehicle(thePlayer) and getVehicleOccupant(getPedOccupiedVehicle(thePlayer), 0) == thePlayer  and getVehicleType(getPedOccupiedVehicle(thePlayer)) == "Automobile" and config.IDSPerm[getElementModel(getPedOccupiedVehicle(thePlayer))] then 
            for i,v in pairs(HandlingAntiga[getPedOccupiedVehicle(thePlayer)]) do 
                setVehicleHandling(getPedOccupiedVehicle(thePlayer), i, v)
            end 
        end 
    end)
end 