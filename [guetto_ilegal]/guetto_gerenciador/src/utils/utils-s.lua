function math.round (number, decimals, method)
    local decimals = decimals or 1;
    local factor = 10 ^ decimals;

    if (method == 'ceil' or method == 'floor') then
        return math[method](number * factor) / factor;
    else
        return tonumber (('%.' .. decimals .. 'f'):format (number));
    end
end

function getElementSpeed (vehicle)
    if not (vehicle and isElement (vehicle)) then
        return 0;
    end

    local vx, vy, vz = getElementVelocity (vehicle);
    return math.sqrt (vx^2 + vy^2 + vz^2) * 180;
end

function getPlayerFromID(id)
    for i, player in ipairs (getElementsByType("player")) do
        if getElementData(player, "ID") == id then
            return player
        end
    end
    return false
end

function getPlayerNearest (player)
    if not (player) then 
        return false 
    end
    local x, y, z = getElementPosition(player)
    local result = false 
    for i, v in ipairs(getElementsByType("player")) do 
        local x2, y2, z2 = getElementPosition(v)
        if (getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) <= 3) then 
            if player ~= v then 
                result = v
            end
        end
    end
    return result
end

function getVehicleNearest (player)
    if not (player) then 
        return false 
    end
    local x, y, z = getElementPosition(player)
    local result = false 
    for i, v in ipairs(getElementsByType("vehicle")) do
        local x2, y2, z2 = getElementPosition(v) 
        if (getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) <= 5) then 
            result = v
        end
    end
    return result
end

function isPlayerHavePermission (player, acl)
    if not (player) then 
        return false 
    end
    local result = false;
    local account = getAccountName(getPlayerAccount(player))
    if (type(acl) == 'table') then 
        for i, v in pairs (acl) do 
            if (isObjectInACLGroup('user.'..account, aclGetGroup(v))) then 
                result = true 
            end
        end 
    elseif (type(acl) == 'string') then 
        if aclGetGroup(acl) then 
            if (isObjectInACLGroup('user.'..account, aclGetGroup(acl))) then 
                result = true 
            end
        else
            print("Guetto_Gerenciador Acl: "..acl.." Não foi encontrada!")
        end
    end
    return result
end