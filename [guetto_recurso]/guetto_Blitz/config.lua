config = {
    others = {
        commands = {
            ['open panel'] = {command = 'blitz', permission = 'Corporação'};
            ['destroy blitz'] = {command = 'destruirblitz', permission = 'Staff'};
        };

        distance_move = 15;
        limit_objects = 15;
        cooldown_objects = 1 * 1000; -- 1 segundos 
    };
};

function sendMessage (action, element, message, type)
    if action == 'client' then
        return exports['guetto_notify']:showInfobox(type, message)
    elseif action == 'server' then
        return exports['guetto_notify']:showInfobox(element, type, message)
    end
end