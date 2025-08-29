function getPlayerByID ( id )
    local result = false;

    for i, v in ipairs(getElementsByType('player')) do 
        if (getElementData(v, 'ID') == tonumber(id)) then 
            result = v 
        end
    end;

    return result
end;
