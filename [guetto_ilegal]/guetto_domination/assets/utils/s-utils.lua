local config = getConfig ();

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

function addCustomEventHandler (eventName, ...)
    addEvent (getResourceName (getThisResource ())..'->#'..eventName, true);
    return addEventHandler (getResourceName (getThisResource ())..'->#'..eventName, ...);
end

function formatNumber (number)
    local fNumber = tostring (number):reverse ():gsub ('(%d%d%d)', '%1.'):gsub ('^(,?)', ''):reverse ();

    if (fNumber:sub (1, 1) == '.') then
        fNumber = fNumber:sub (2);
    end

    return fNumber;
end

function isElementPlayer (element)
    if (element and isElement (element) and getElementType (element) == 'player') then
        return true;
    end
    return false;
end

function isElementHasPermission (element, permission)
    if (isElementPlayer (element)) then
        if (permission and type (permission) == 'table') then
            for k, v in ipairs (permission) do
                if (isObjectInACLGroup ('user.'..(getAccountName (getPlayerAccount (element))), aclGetGroup (v))) then
                    return true;
                end
            end
        elseif (permission and type (permission) == 'string') then
            if (isObjectInACLGroup ('user.'..(getAccountName (getPlayerAccount (element))), aclGetGroup (permission))) then
                return true;
            end
        end
    end
    return false;
end