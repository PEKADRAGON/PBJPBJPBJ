Veiculos = {
    [598] = {'service.police', 'service.samu'},
    [597] = {'service.police', 'service.samu'},
    [596] = {'service.police', 'service.samu'},
    [585] = {'service.police', 'service.samu'},
    [523] = {'service.police', 'service.samu'},
    [490] = {'service.police', 'service.samu'},
    [416] = {'service.samu'},
    [525] = {'service.mechanic'},
}

Ambulancias = {
    [416] = true,
}

sendMessageServer = function (player, msg, type)
    return exports['guetto_notify']:showInfobox(player, type, msg)
end;


enterVehicle = function(player, assento)
    local Modelo = getElementModel(source)
    if assento ~= 0 and 1 and Ambulancias[Modelo] then return end 
    for i, v in pairs(Veiculos) do
        if Modelo == i then
            if isPlayerACL(player, v) then 
            else
                cancelEvent()
                sendMessageServer(player, "Você não pode entrar em uma viatura!", "error")
            end
        end
    end
end
addEventHandler('onVehicleStartEnter', root, enterVehicle)

-- Funções uteis --

function isPlayerACL(player, table)
    for _, acl in ipairs(table) do
        if getElementData(player, acl) then
            return true 
        end
    end
    return false
end