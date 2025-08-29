config = {
    time = 25; -- Tempo que o player tem para conseguir destravar o veículo.
    animation = {'BOMBER', 'BOM_Plant', -1, true, false, true, false}; -- Animação do player ao destravar o veículo.
    inventoryName = 'guetto_inventory';
    item = 49; -- ID do item que o player precisa para conseguir destravar o veículos.
    elementData = 'veh:lock'; -- Elementdata do veículo trancado.
}

function sendMessage (action, element, message, type)
    if action == "client" then
        return exports['guetto_notify']:showInfobox(type, message)
    elseif action == "server" then
        return  exports['guetto_notify']:showInfobox(element, type, message)
    end
end

function getSettings()
    return config
end