_getPlayerName = getPlayerName;
function getPlayerName(element)
    return _getPlayerName(element):gsub("#%x%x%x%x%x%x", "") or _getPlayerName(element);
end

function isElementPlayer(element)
    if (element and isElement(element) and getElementType(element) == "player") then
        return true;
    end
    return false;
end

function formatNumber(number) 
    while true do      
        number, k = string.gsub(number, "^(-?%d+)(%d%d%d)", '%1.%2');
        if (k == 0) then      
            break;
        end  
    end  
    return number;
end

function setElementWeapons(element, weapons)
    if (isElementPlayer(element)) then
        for k, v in ipairs(weapons) do
            giveWeapon(element, v.weapon, v.ammo);
        end
    end
    return false;
end

function getPlayerByID(id)
    local searchedPlayer;
    if (id and type(id) == "number") then
        Async:forEach(getElementsByType("player"),
            function(player)
                if (others.getPlayerID(player) == id) then
                    searchedPlayer = player;
                end
            end
        );
    end
    return searchedPlayer;
end

function getElementWeapons(element)
    local weapons = {};
    if (isElementPlayer(element)) then
        for i = 1, 12 do
            local arma = getPedWeapon(element, i);
            if (arma and arma > 0) then
                local municao = getPedTotalAmmo(element, i);
                if (municao and municao > 0) then
                    table.insert(weapons, {['weapon'] = arma, ['ammo'] = municao});
                end
            end
        end
    end
    return weapons;
end

function isPlayerHavePermission(element, permissions)
    if (isElementPlayer(element)) then
        if (permissions and type(permissions) == "table") then
            for k, v in ipairs(permissions) do
                if aclGetGroup(v) and (isObjectInACLGroup("user."..(getAccountName(getPlayerAccount(element))), aclGetGroup(v))) then
                    return true;
                end
            end
        elseif (permissions and type(permissions) == "string") then
            if aclGetGroup(permissions) and (isObjectInACLGroup("user."..(getAccountName(getPlayerAccount(element))), aclGetGroup(permissions))) then
                return true;
            end
        end
    end
    return false;
end

function createDiscordLogs(title, description, fields, link, image)
    local data = {
        embeds = {
            {
                ['color'] = 16711680,
                ['title'] = title,
                
                ['description'] = "> "..(description),
                ['fields'] = fields,
                
                ['image'] = {
                    ['url'] = image
                },

                ["footer"] = {
                    ["text"] = "Roman Store Inc.",
                    ['icon_url'] = "https://i.imgur.com/moOkjDz.png"
                },
            }
        },
    }

    data = toJSON(data);
    data = data:sub(2, -2);
    fetchRemote(link, {["queueName"] = "logs", ["connectionAttempts"] = 5, ["connectTimeout"] = 5000, ["headers"] = {["Content-Type"] = "application/json"}, ['postData'] = data}, function() end);
end