config = {
    ['attributes'] = {
        hud = { -- Configurações da interface do seu servidor.
            use = true, -- Opção para aparecer / sumir a interface (hud, velocimetro e minimapa) do seu servidor (true para sim e false para não).
            showHud = function(element, state) -- função para aparecer / sumir a interface (hud, velocimetro e minimapa).
                triggerEvent("interface", element, state); -- element = jogador que está abrindo o celular /// state = true para aparecer a interface ou false para sumir a interface.
                return;
            end 
        },

        panel = {
            command = "evento",
            permissions = {"Console", "Moderador-geral", "Administrador", "Diretor"}
        }
    }
};

others = {
    ['getPlayerID'] = function(element)
        return getElementData(element, "ID") or "N/A";
    end
};

notify = {
    ['success'] = "success",
    ['warning'] = "warning",
    ['error'] = "error",
    ['info'] = "info"
};

geral = {
    ['sNotify'] = function(element, message, type)
        return exports['guetto_notify']:showInfobox(player, type, message)
    end,

    ['cNotify'] = function(element, message, type)
        return exports['guetto_notify']:showInfobox(type, message)
    end
};
