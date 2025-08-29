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

function isPlayerHavePermission(element, permissions)
    if (isElementPlayer(element)) then
        if (permissions and type(permissions) == "table") then
            for k, v in ipairs(permissions) do
                if (isObjectInACLGroup("user."..(getAccountName(getPlayerAccount(element))), aclGetGroup(v))) then
                    return true;
                end
            end
        elseif (permissions and type(permissions) == "string") then
            if (isObjectInACLGroup("user."..(getAccountName(getPlayerAccount(element))), aclGetGroup(permissions))) then
                return true;
            end
        end
    end
    return false;
end

function createDiscordLogs(title, description, link, image)
    local data = {
        embeds = {
            {
                ["color"] = 16711680,
                ["title"] = title,
                
                ["description"] = description,
                
                ['thumbnail'] = {
                    ['url'] = "https://i.imgur.com/ixS8xZG.png",
                },

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