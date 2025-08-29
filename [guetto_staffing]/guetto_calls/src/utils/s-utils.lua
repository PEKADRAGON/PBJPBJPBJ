local config = getConfig ();

-- util's server.
function createEventHandler (eventName, ...)
    addEvent (eventName, true);
    addEventHandler (eventName, ...);
end

function isElementHavePermission (player, permission)
    if not (player and isElement (player) and player:getType () == 'player') then
        return false;
    end

    if (type (permission) == 'table') then
        for i, v in ipairs (permission) do
            if (isObjectInACLGroup ('user.'..(getAccountName (getPlayerAccount (player))), aclGetGroup (v))) then
                return true;
            end
        end
    elseif (type (permission) == 'string') then
        if (isObjectInACLGroup ('user.'..(getAccountName (getPlayerAccount (player))), aclGetGroup (permission))) then
            return true;
        end
    end

    return false;
end

function convertTimestamp (timestamp)
    local formatted_date;

    if (type (timestamp) == 'number') then
        formatted_date = os.date ('%H:%M', timestamp);
    else
        return 'Invalid timestamp';
    end

    return formatted_date;
end

function convertTime (ms)
    local seconds = math.floor (ms / 1000);
    local minutes = math.floor (seconds / 60);
    local hours = math.floor (minutes / 60);

    return string.format ('%02d:%02d:%02d', hours, minutes % 60, seconds % 60);
end