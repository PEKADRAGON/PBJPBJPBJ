local weapons = {
    [5] = 22;
    [6] = 24;
    [7] = 31;
    [8] = 30;
    [9] = 29;
    [10] = 34;
    [11] = 25
}

function refreshClientInventory ( player, target )
    return triggerClientEvent(player, "guetto.refreshInventory", resourceRoot, exports["guetto_inventory"]:getPlayerInventory(target))
end;

registerEventHandler("guetto.saquear.saquear", resourceRoot, function ( player, target, hash, iv )

    
    if source ~= resourceRoot then 
        return error ("[ ".. (getResourceName(getThisResource())) .." ] Event dected possible attack!  PlayerInfos: [Name: "..getPlayerName(player).." | IP: "..getPlayerIP(player).." | Serial: "..getPlayerSerial(player).." | Account: "..getAccountName(getPlayerAccount(player)).."]!")
    end

    if player ~= client then 
        return error ("[ ".. (getResourceName(getThisResource())) .." ] Event dected possible attack!  PlayerInfos: [Name: "..getPlayerName(player).." | IP: "..getPlayerIP(player).." | Serial: "..getPlayerSerial(player).." | Account: "..getAccountName(getPlayerAccount(player)).."]!")
    end;

    if not target or not isElement(target) then 
        return config.sendMessageServer(player, "Cidadão não encontrado!", "error")
    end;

    if getElementData(target, "guetto.open.inventory") then 
        triggerClientEvent(target, "onPlayerInventoryClose", resourceRoot)
    end

    decodeString("aes128", hash, {key = getPlayerSerial(player):sub(17), iv = iv}, function (data)
        local dados = fromJSON(data);
        if (dados and type(dados) == 'table') then 
            if (dados.item) then 
                local qnt = dados.amount;
                local settings_item = exports["guetto_inventory"]:getConfigItem(tonumber(dados.item[2]))
                local money = getPlayerMoney(target);
                
                if settings_item and type(settings_item) == 'table' then 
   
                    if settings_item.others.saquear == true then 
                        return config.sendMessageServer(player, "Você não pode saquear esse item!", "error")
                    end

                    if (weapons[dados.item[2]]) then 
                        takeWeapon(player, weapons[dados.item[2]])
                    end
            
                    exports["guetto_inventory"]:takeItem(target, dados.item[2], qnt)
                    exports["guetto_inventory"]:giveItem(player , dados.item[2], qnt)
                    refreshClientInventory ( player, target )
                else
                    iprint ('guetto_saquear reciver the value: '..dados)
                end
            end
        end
    end);
end)


registerEventHandler("guetto.saquear.all", resourceRoot, function ( player, target, hash, iv )

    if source ~= resourceRoot then 
        return error ("[ ".. (getResourceName(getThisResource())) .." ] Event dected possible attack!  PlayerInfos: [Name: "..getPlayerName(player).." | IP: "..getPlayerIP(player).." | Serial: "..getPlayerSerial(player).." | Account: "..getAccountName(getPlayerAccount(player)).."]!")
    end

    if player ~= client then 
        return error ("[ ".. (getResourceName(getThisResource())) .." ] Event dected possible attack!  PlayerInfos: [Name: "..getPlayerName(player).." | IP: "..getPlayerIP(player).." | Serial: "..getPlayerSerial(player).." | Account: "..getAccountName(getPlayerAccount(player)).."]!")
    end;

    if not target or not isElement(target) then 
        return config.sendMessageServer(player, "Cidadão não encontrado!", "error")
    end;

    decodeString("aes128", hash, {key = getPlayerSerial(player):sub(17), iv = iv}, function (data)
        local dados = fromJSON(data);
        
        if (dados and type(dados) == 'table') then 
            if (dados.item) then 
                for i = 1, #dados.item do 
                    local v = dados.item[i]
                    if v.item then 
                        local dados = exports["guetto_inventory"]:getConfigItem(tonumber(v.item))
                        if dados and type(dados) == 'table' then 
                            if (dados.others.saquear == false) then 
                                if not space then 
                                    if (weapons[v.item]) then 
                                        takeWeapon(target, weapons[v.item])
                                    end
                                    exports["guetto_inventory"]:takeItem(target, v.item, v.amount)
                                    exports["guetto_inventory"]:giveItem(player, v.item, v.amount)
                                else
                                    return config.sendMessageServer(player, "Você não tem espaço suficiente no inventário!", "error")
                                end
                            end
                        else
                            iprint ('guetto_saquear reciver the value: '..dados)
                        end
                    end
                end
            end
        end
        
        config.sendMessageServer(player, "Você saqueou todos os itens do cidadão!", "success")
        config.sendMessageServer(target, "Você teve todos seus itens saqueados por "..getPlayerName(player).."!", "info")
        refreshClientInventory ( player, target )
    end)
end)

addEventHandler("onPlayerQuit", root, function ( )
    if getElementData(source, "guetto.saquando") and isElement(getElementData(source, "guetto.saquando")) then 
        setElementData(getElementData(source, "guetto.saquando"), "guetto.sendoSaqueado", false)
    end
end)

addEventHandler("onPlayerWasted", root, function ( )
    if getElementData(source, "guetto.saquando") and isElement(getElementData(source, "guetto.saquando")) then 
        setElementData(getElementData(source, "guetto.saquando"), "guetto.sendoSaqueado", false)
    end
end)

addEvent("onPlayerCloseRevist", true)
addEventHandler("onPlayerCloseRevist", resourceRoot, function ( )
    if not client or ( source ~=  resourceRoot ) then 
        return false 
    end

    if getElementData(client, "guetto.saquando") and isElement(getElementData(client, "guetto.saquando")) then 
        setElementData(getElementData(client, "guetto.saquando"), "guetto.sendoSaqueado", false)
        setElementData(client, "guetto.saquando", false)
    end
end)