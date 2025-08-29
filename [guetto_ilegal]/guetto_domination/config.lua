-- config's resource.
local config = {
    Geral = {
        eventNotification = 'addBox'; -- Evento da sua infobox.

        key_domination = 'f'; -- Tecla para dominar a área.

        weapons = {
            [22] = true;
            [23] = true;
            [24] = true;
            [25] = true;
            [26] = true;
            [27] = true;
            [28] = true;
            [29] = true;
            [32] = true;
            [30] = true;
            [31] = true;
            [33] = true;
            [34] = true;
        };
    };

    Groups = {
        {
            acl = 'MLC';
            color = {251, 212, 52};

            twoChest = true;
            idChest = 41;
            idChest2 = 37;
        };

        {
            acl = 'UT';
            color = {16, 16, 16};

            twoChest = true;
            idChest = 3;
            idChest2 = 27;
        };

        {
            acl = 'BDM';
            color = {14, 131, 40};

            twoChest = true;
            idChest = 55;
            idChest2 = 56;
        };

        {
            acl = 'TDF';
            color = {0, 71, 255};

            twoChest = true;
            idChest = 55;
            idChest2 = 56;
        };

        {
            acl = 'KATIARA';
            color = {116, 116, 116};

            twoChest = false;
            idChest = 66;
            --idChest2 = 67;
        };

        {
            acl = 'CND';
            color = {255, 255, 255};

            twoChest = false;
            idChest = 68;
           -- idChest2 = 67;
        };

        
        {
            acl = 'TDC';
            color = {235, 255, 0};

            twoChest = false;
            idChest = 43;
           -- idChest2 = 67;
        };

    };

    Areas = {
        [1] = {1552.556, -2878.871, 8.51, index = 1};
        [2] = {-1123.604, -1668.515, 76.472, index = 2};
        [3] = {1972.097, 204.862, 36.51, index = 3};
        [4] = {2655.919, -749.262, 92.929, index = 4};
        [5] = {1352.76, -157.981, 21.555, index = 5};
        [6] = {-460.951, -1715.938, 11.989, index = 6};
        [7] = {-456.492, -89.369, 60.418, index = 7};
    };
};

-- export's resource.
function getConfig ()
    return config;
end

function sendMessage (actionName, ...)
    if not (actionName and tostring (actionName)) then
        return false;
    end
    if (actionName == 'server') then 
        local playerElement, message, type = ...;
        return exports['guetto_notify']:showInfobox(playerElement, type, message)
    elseif (actionName == "client") then 
        local message, type = ...;
        return exports['guetto_notify']:showInfobox(type, message)
    end
end

function getColorFaction (faction)
    if not (faction and tostring (faction)) then
        return false;
    end

    for i = 1, #config.Groups do
        local v = config.Groups[i];

        if (v.acl == faction) then
            return v.color[1], v.color[2], v.color[3];
        end
    end

    return false;
end
