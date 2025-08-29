local timer = {}

registerEventHandler("Assault.Get.Item", resourceRoot, function (index)
    if not (client or (source ~= resourceRoot)) then 
        return false 
    end

    local amount = exports["guetto_inventory"]:getItem(client, config["assault"]["item"])
    
    if (amount == 0) then 
        return config.sendMessageServer(client, "Você ñao possui uma bomba em seu inventário!", "error")
    end

    exports["guetto_inventory"]:takeItem(client, config["assault"]["item"], 1)

    
    local x, y, z = getElementPosition(client)

    toggleAllControls(client, false)
    setElementFrozen(client, true)
    setPedAnimation(client, "bomber", "bom_plant", -1, true, false, false)

    triggerClientEvent(client, "AssaultMiniGameToggle", resourceRoot, index)
 
    for _, player in ipairs(getElementsByType('player')) do 
        if (getElementData(player, "service.police")) then 
            outputChatBox("#ff0000[Denuncia] #ffffff Uma caixinha está sendo roubada, veja a marcação em seu radar!", player, 255, 255, 255, true)
        end
    end

end)

