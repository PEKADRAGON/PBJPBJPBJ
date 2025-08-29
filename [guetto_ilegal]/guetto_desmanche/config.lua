config = {

    dismantles = {
        {pos = {1426.082, -2858.71, 1.31-0.9}, acl = 'MLC', rot = {0, 0, 62.214}};
        {pos = {2499.148, -2024.861, 13.547-0.9}, acl = 'BALLAS', rot = {0, 0, 179.594}};
        {pos = {-1105.634, -1697.388, 76.497-0.9}, acl = 'UT', rot = {0, 0, 179.594}};
        {pos = {-470.124, -59.923, 60.401-0.9}, acl = 'TDC', rot = {0, 0, 179.594}};
        {pos = {528.028, 1486.293, 12.604-0.9}, acl = 'PCC', rot = {0, 0, 179.594}};
        {pos = {1932.987, 163.09, 37.275-0.9}, acl = 'YKZ', rot = {0, 0, 179.594}};
        

    };
    
    settings = {
        timeDismantlePart = 1; -- Tempo para desmontar uma peça em segundos.
        cooldownNextDismantling = 5; -- Tempo para desmontar outro veiculo em minutos.
        
        percentages = {
            percentageDismantle = 0.70; -- Porcentagem de lucro para desmontar um veiculo.
            percentageMotorcycle = 0.70; -- Porcentagem de lucro para desmontar uma moto.
        };
    };

    partTable = {
        {'bonnet_dummy', 'Capô', 0, {0, 2, -1.4}};
        {'boot_dummy', 'Malas', 1, {0, -1.5, -1.4}};
        {'door_lf_dummy', 'Porta dianteira esquerda', 2, {-0.5, -0.5, -1.1}};
        {'door_rf_dummy', 'Porta dianteira direita', 3, {0.5, -0.5, -1.1}};
        {'door_lr_dummy', 'Porta traseira esquerda', 4, {-0.5, -0.5, -1.1}};
        {'door_rr_dummy', 'Porta traseira direita', 5, {0.5, -0.5, -1.1}};
        {'wheel_rf_dummy', 'Roda dianteira direita', {-1, -1, 2, -1}, {0.5, 0, -0.5}};
        {'wheel_lf_dummy', 'Roda dianteira esquerda', {2, -1, -1, -1}, {-0.5, 0, -0.5}};
        {'wheel_rb_dummy', 'Roda traseira direita', {-1, -1, -1, 2}, {0.5, 0, -0.5}};
        {'wheel_lb_dummy', 'Roda traseira esquerda', {-1, 2, -1, -1}, {-0.5, 0, -0.5}};
    };
};

function sendMessage (action, element, message, type)
    if action == "client" then
        return exports['guetto_notify']:showInfobox(type, message) 
    elseif action == "server" then
        return exports['guetto_notify']:showInfobox(element, type, message) 
    end
end
