config = {

    ["Others"] = {
    };


    sendMessageServer = function (player, msg, type)
        return exports['guetto_notify']:showInfobox(player, type, msg)
    end;

    sendMessageClient = function (msg, type)
        return exports['guetto_notify']:showInfobox(type, msg)
    end;

}

function removeHex (s)
    return s:gsub ("#%x%x%x%x%x%x", "") or false
end

_getPlayerName = getPlayerName

function getPlayerName (player)
    if not player or not isElement(player) then 
        return false;
    end;
    return removeHex(_getPlayerName(player))
end

function registerEventHandler ( event, ... )
    addEvent( event, true )
    addEventHandler( event, ... )
end;