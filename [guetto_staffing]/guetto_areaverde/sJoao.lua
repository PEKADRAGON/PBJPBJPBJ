colshape = {}
areaverde = {}

addEventHandler("onResourceStart", resourceRoot,
function()
    for i, v in ipairs(getElementsByType('player')) do
        if (getElementData(v, "onProt") == false) then 
            setElementAlpha(v, 255)
        end
    end
    if config["Mensagem Start"] then
        outputDebugString("["..getResourceName(getThisResource()).."] Startado com sucesso!")
    end
    for i, v in ipairs(config["Areas"]) do
        colshape[i] = createColSphere(v[1], v[2], v[3], v[4])
        areaverde[i] = createRadarArea(v[1]-60, v[2]-60, 150, 150, 0, 255, 0, 90)
        addEventHandler("onColShapeHit", colshape[i],
        function(player, dim)
            if player and isElement(player) and getElementType(player) == "player" then
                if dim then
                    setPedWeaponSlot(player, 0)
                    toggleControl(player, "fire", false)
                    toggleControl(player, "action", false)
                    toggleControl(player, "aim_weapon", false)
                    toggleControl(player, "vehicle_fire", false)
                    toggleControl(player, "vehicle_secondary_fire", false)
                    toggleControl(player, "next_weapon", false)
                    toggleControl(player, "previous_weapon", false)
                    setElementData(player, "JOAO.removeDano", true)
                    triggerClientEvent(player, "JOAO.godMode", player, true)
                    triggerClientEvent(player, "onPlayerEnterColShape", resourceRoot, true)
                end
            end
        end)
        addEventHandler("onColShapeLeave", colshape[i],
        function(player, dim)
            if player and isElement(player) and getElementType(player) == "player" then
                toggleControl(player, "fire", true)
                toggleControl(player, "action", true)
                toggleControl(player, "aim_weapon", true)
                toggleControl(player, "vehicle_fire", true)
                toggleControl(player, "vehicle_secondary_fire", true)
                toggleControl(player, "next_weapon", true)
                toggleControl(player, "previous_weapon", true)
                removeElementData(player, "JOAO.removeDano")
                triggerClientEvent(player, "onPlayerEnterColShape", resourceRoot, false)
                triggerClientEvent(player, "JOAO.godMode", player, false)
            end
        end)
    end
end)
