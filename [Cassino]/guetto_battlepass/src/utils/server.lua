_triggerClientEvent = triggerClientEvent
function triggerClientEvent (element, eventName, elementSource, ...)
    return _triggerClientEvent (element, (string.find (eventName, 'atlas_resources.') and getResourceName (getThisResource ())..'->#'..eventName or eventName), elementSource, ...);
end

_triggerEvent = triggerEvent
function triggerEvent (eventName, elementSource, ...)
    return _triggerEvent ((string.find (eventName, 'atlas_resources.') and getResourceName (getThisResource ())..'->#'..eventName or eventName), elementSource, ...);
end

_triggerServerEvent = triggerServerEvent
function triggerServerEvent (eventName, elementSource, ...)
    return _triggerServerEvent ((string.find (eventName, 'atlas_resources.') and getResourceName (getThisResource ())..'->#'..eventName or eventName), elementSource, ...);
end

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
        if getElementData(player, "ID") == tonumber(id) then
            return player
        end
    end
    return false
end
