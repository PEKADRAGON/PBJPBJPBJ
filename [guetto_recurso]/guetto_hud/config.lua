config = {
    components = {
        {
            id = "armor",
            icon = 'assets/images/icon-armor.png',
            color = {69, 137, 238},
            size = {41, 45},
            func = function (element)
                return getPedArmor(element)
            end;
        };
        {
            id = "life",
            icon = 'assets/images/icon-armor.png',
            color = {255, 43, 92},
            size = {44, 40},
            func = function (element)
                return getElementHealth(element)
            end;
        };
        {
            id = "food",
            icon = 'assets/images/icon-armor.png',
            color = {248, 193, 79},
            size = {30, 34},
            func = function (element)
                return getElementData(element, "fome") or 0;
            end;
        };
        {
            id = "thirst",
            icon = 'assets/images/icon-armor.png',
            color = {111, 254, 251},
            size = {34, 40},
            func = function (element)
                return getElementData(element, "sede") or 0;
            end;
        };
    };    
    
    components_hud = {
        'health';
        'armour';
        'money';
        'clock';
        'breath';
        'weapon';
        'ammo';
        'radar';
        'wanted';
        'vehicle_name';
        'area_name';
    };

}

function getPlayerInteraction(player)
    if not player or not isElement(player) then 
        return false 
    end

    local cache = {}
    local account = getAccountName(getPlayerAccount(player))

    for _, interaction in ipairs(config.interactions) do 
        local settings = config.interactions_settings[interaction]
        
        if settings.type == 'acl' then
            local aclGroup = aclGetGroup(settings.acl)
            if isObjectInACLGroup('user.'..account, aclGroup) then
                if not settings.elementData or getElementData(player, settings.elementData) then 
                    table.insert(cache, interaction)
                end
            end
        end
    end

    return cache
end

function createEventHandler (eventName, ...)
    addEvent (eventName, true)
    return addEventHandler (eventName, ...);
end

function removeHex (s)
    return s:gsub ("#%x%x%x%x%x%x", "") or false
end

_getPlayerName = getPlayerName

function getPlayerName ( player )
    return removeHex (_getPlayerName(player))
end

sendMessageServer = function (player, msg, type)
    return exports['guetto_notify']:showInfobox(player, type, msg)
end;

sendMessageClient = function (msg, type)
    return exports['guetto_notify']:showInfobox(type, msg)
end;

function formatNumber (number, stepper)
    local left, center, right = string.match (math.floor (number), '^([^%d]*%d)(%d*)(.-)$');
    return left .. string.reverse (string.gsub (string.reverse (center), '(%d%d%d)', '%1' .. (stepper or '.'))) .. right;
end