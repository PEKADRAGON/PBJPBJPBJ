function lerp(from, to, progress)
    return from + (to - from) * progress
end

function getNearestVehicle(player, distance)
    local x, y, z = getElementPosition(player)
    local vehicles = getElementsByType('vehicle', root, true)
    local nearest = nil
    local nearestDistance = distance
    for i, vehicle in ipairs(vehicles) do
        local vx, vy, vz = getElementPosition(vehicle)
        local dis = getDistanceBetweenPoints3D(x, y, z, vx, vy, vz)
        if (dis < nearestDistance) then
            nearest = vehicle
            nearestDistance = dis
        end
    end
    return nearest
end