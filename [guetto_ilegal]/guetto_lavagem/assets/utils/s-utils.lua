others = {  
    ["getPlayerID"] = function(element)
        return getElementData(element, "ID") or "N/A";
    end,
};

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

function isPlayerInACL(player)
    for i, v in ipairs(config["system"]["permissions"]) do
        if aclGetGroup(v) and isObjectInACLGroup("user."..getAccountName(getPlayerAccount(player)), aclGetGroup(v)) then
            return true
        end
    end
    return false
end

function convertNumber(number)   
    local formatted = number   
    while true do       
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2')     
        if ( k==0 ) then       
            break   
        end   
    end   
    return formatted 
end