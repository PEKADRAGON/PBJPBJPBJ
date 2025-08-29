function getPlayerByID ( id )

    local result = false;

    if not id then 
        return false 
    end

    for k, v in ipairs(getElementsByType("player")) do
        if tonumber(getElementData(v, "ID")) == tonumber(id) then
            result = v
        end
    end

    return result
end

function getPlayerFromAccountName(name) 
    local acc = getAccount(name)
    if (not acc) or (isGuestAccount(acc)) then
        return false
    end
    return getAccountPlayer(acc)
end