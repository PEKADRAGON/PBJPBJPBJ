config = {
    ElementData = "Lenhador",
}

notifyS = function(player, message, type)
   return exports['guetto_notify']:showInfobox(player, type, message)
end

notifyC = function(message, type)
    return exports['guetto_notify']:showInfobox(type, message) 
end

function formatNumber ( number )   
    local formatted = number   
    while true do       
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2')     
        if ( k==0 ) then       
            break   
        end
    end
    return formatted 
end 
