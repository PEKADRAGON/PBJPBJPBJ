function removeHex(s)
    local g, c = string.gsub, 0
    repeat
        s, c = g(s, '#%x%x%x%x%x%x', '')
    until c == 0
    return s
end

function getVehicleNearest (player)
    if not (player) then 
        return false 
    end
    local x, y, z = getElementPosition(player);
    local result = false
    for i, v in ipairs(getElementsByType('vehicle')) do 
        local x2, y2, z2 = getElementPosition(v)
        local distance = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
        if distance <= 20 then 
            result = v
        end
    end
    return result
end

function getElementSpeed(theElement)
    assert(isElement(theElement), "Bad argument 1 @ getElementSpeed (element expected, got " .. type(theElement) .. ")")
    local elementType = getElementType(theElement)
    assert(elementType == "player" or elementType == "ped" or elementType == "object" or elementType == "vehicle" or elementType == "projectile", "Invalid element type @ getElementSpeed (player/ped/object/vehicle/projectile expected, got " .. elementType .. ")")
    assert((unit == nil or type(unit) == "string" or type(unit) == "number") and (unit == nil or (tonumber(unit) and (tonumber(unit) == 0 or tonumber(unit) == 1 or tonumber(unit) == 2)) or unit == "m/s" or unit == "km/h" or unit == "mph"), "Bad argument 2 @ getElementSpeed (invalid speed unit)")
    unit = unit == nil and 0 or ((not tonumber(unit)) and unit or tonumber(unit))
    local mult = (unit == 0 or unit == "m/s") and 50 or ((unit == 1 or unit == "km/h") and 180 or 111.84681456)
    return (Vector3(getElementVelocity(theElement)) * mult).length
end