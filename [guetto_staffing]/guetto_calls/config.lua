local config = {
    Geral = {
        eventNotification = 'addBox'; -- Evento da sua infobox.

        panel = {
            call = {
                type = 'bind'; -- Tipo de abrir o painel de chamados. (command ou bind)

                key_bind = 'f9'; -- So funciona se o tipo for (bind).
                command = 'chamados'; -- So funciona se o tipo for (command).
            };
            
            manager = {
                type = 'command'; -- Tipo de abrir o painel de gerenciamento. (command ou bind)
                acl = {'Staff'}; -- ACL para abrir o painel de gerenciamento.
                requiresService = false; -- Para abrir o painel de gerenciamento, precisa estar em serviço.

                key_bind = 'f6'; -- So funciona se o tipo for (bind).
                command = 'chamados'; -- So funciona se o tipo for (command).
            };
        };
    };

    Reasons = {
        [1] = 'Reporte rápido';
        [2] = 'Bugs';
        [3] = 'Assunto pessoal';
    };

    Datas = {
        staff = 'onProt';
    };
};

-- export's resource.
function getConfig ()
    return config;
end

function removeHex (s)
    return s:gsub ("#%x%x%x%x%x%x", "") or false
end

_getPlayerName = getPlayerName

function getPlayerName ( player )
    return removeHex(_getPlayerName(player))
end

function message (actionName, ...)
    if not (actionName and tostring (actionName)) then
        return false;
    end

    if not (actionName ~= 'server') then
        local element, message, type = ...;

        if not (element and isElement (element)) then
            return false;
        end

        exports['guetto_notify']:showInfobox(element, type, message)
    end

    if not (actionName ~= 'client') then
        local message, type = ...;

        exports['guetto_notify']:showInfobox(type, message)
    end
end