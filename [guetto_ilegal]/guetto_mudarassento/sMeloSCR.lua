local delay = {}

local vehicles_block = {
    [416] = true
}

function mudarAssento(thePlayer, cmd)
    if thePlayer and isElement(thePlayer) and getElementType(thePlayer) == "player" then 
        local vehicle = getPedOccupiedVehicle(thePlayer)

        if (delay[thePlayer] and getTickCount ( ) - delay[thePlayer] <= 400) then 
            return 
        end

        if vehicle then 
            if ( vehicles_block[getElementModel(vehicle)] ) then
                return 
            end

            for i,v in pairs(getVehicleOccupants(vehicle)) do 
                if i == (tonumber(string.sub(cmd, 2,2))-1) then 
                    return 
                end 
            end
           
            warpPedIntoVehicle(thePlayer, vehicle, (tonumber(string.sub(cmd, 2,2))-1)) 
            delay[thePlayer] = getTickCount ( )
        end 
    end 
end 
addCommandHandler("p1", mudarAssento)
addCommandHandler("p2", mudarAssento)
addCommandHandler("p3", mudarAssento)
addCommandHandler("p4", mudarAssento)