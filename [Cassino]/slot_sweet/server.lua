local data = {}

for i, v in ipairs ( markers ) do 
    local marker = createMarker(v[1], v[2], v[3], v[4], v[5], v[6], v[7], v[8], v[9])
    setElementData(marker, 'markerData', {title = 'Cassino', desc = 'Sweet Bonanza', icon = 'slotMachine'})
    data[marker] = i
    setElementDimension(marker, v.dim)
    setElementInterior(marker, v.int)
end

addEventHandler('onMarkerHit', resourceRoot, function ( player, dim )
    if player and isElement(player) and getElementType(player) == 'player' and not isPedInVehicle(player) then 
        if data[source] then 
            triggerClientEvent (player, 'sweet:panel', resourceRoot)
        end
    end
end)