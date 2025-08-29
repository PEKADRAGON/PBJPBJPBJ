addCommandHandler("getpos", 
function (player)
    if aclGetGroup("Console") and isObjectInACLGroup("user."..getAccountName(getPlayerAccount(player)), aclGetGroup("Console")) then 
        --exports.FR_DxMessages:addBox(player, "Posição Copiada!", "success")
        iprint("Posição Copiada!")
        local x, y, z = getElementPosition(player)
        triggerClientEvent(player, "MeloSCR:CopiarPos", player, tonumber(x), tonumber(y), tonumber(z))
    end 
end)

addCommandHandler("getrot", 
function (player)
    if aclGetGroup("Console") and isObjectInACLGroup("user."..getAccountName(getPlayerAccount(player)), aclGetGroup("Console")) then 
        iprint("Rotação Copiada Copiada!")
        local x, y, z = getElementRotation(player)
        triggerClientEvent(player, "MeloSCR:CopiarRot", player, tonumber(x), tonumber(y), tonumber(z))
    end 
end)

