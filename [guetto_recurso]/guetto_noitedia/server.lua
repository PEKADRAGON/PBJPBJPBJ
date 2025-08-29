function messageS (player, message, type)
    return exports['guetto_notify']:showInfobox(player, type, message)
end

addCommandHandler("gordo", 
    function(player)
        if (getElementModel(player) ~= 0) then
          
            messageS(player, "Você não está com a skin do CJ!", "success");
            return;
        end
        
        messageS(player, "Você ficou gordo!", "success");
        setPedStat(player, 21, 1000);
        return;
    end
);

addCommandHandler("magro", 
    function(player)
        if (getElementModel(player) ~= 0) then
            messageS(player, "Você não está com a skin do CJ!", "success");
            return;
        end
        
        messageS(player, "Você ficou magro!", "success");
        setPedStat(player, 21, 0);
        return;
    end
);

addCommandHandler("forte", 
    function(player)
        if (getElementModel(player) ~= 0) then
            messageS(player, "Você não está com a skin do CJ!", "success");
            return;
        end
        
        messageS(player, "Você ficou forte!", "success");
        setPedStat(player, 23, 1000);
        return;
    end
);

addCommandHandler("fraco", 
    function(player)
        if (getElementModel(player) ~= 0) then
            messageS(player, "Você não está com a skin do CJ!", "success");
            return;
        end
        
        messageS(player, "Você ficou fraco!", "success");
        setPedStat(player, 23, 0);
        return;
    end
);