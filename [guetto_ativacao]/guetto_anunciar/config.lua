config = {
    ["gerais"] = {
        ["command.announce"] = "anunciar";
        ["permissions"] = {"Console", "Fundador", "Ajudante", "CEO", "Diretor", "Moderador-geral", "Gerente", "Supervisor", "Coordenador", "Administrador", "Administrador.G", "Moderador-geral", "Moderador", "Staff"};
        ["element.data-id"] = "ID";
        ["time.announce"] = 10; -- / Tempo em segundos que o anúncio ficara visivel na tela.
    };

    ["interface"] = {
        ["tittle"] = "Painel de Anúncios";
        ["sub.tittle"] = "Personalize o anúncio da maneira que deseja.";
        ["description"] = "Descrição...";

        ["cores"] = { -- // Limite máximo de 12 cores.
            {255, 255, 255}; 
            {60, 60, 60}; 
            {141, 106, 240}; 
            {89, 205, 255}; 
            {255, 34, 34}; 
            {255, 201, 11}; 
            {255, 107, 0};
            {254, 161, 94};
            {251, 47, 255};
            {6, 76, 255};
            {0, 255, 102};
            {255, 10, 157};
        };
    };

    ["logs"] = { -- // Caso não queira utilizar logs coloque "false".
        ["log"] = true;
        ["web-hook"] = "https://discord.com/api/webhooks/1255969887847845909/nuaiqMZC0m90MNM2-jQzQAEmeEkfkkQf_3xgMjqQBWbmznwKaUFMJ9SNuE3uuIyQM3JZ";
    };
};

function sendMessage (action, element, message, type)
    if action == "client" then
        return triggerEvent ("addBox", element, type, message)
    elseif action == "server" then
        return triggerClientEvent (element, "addBox", element, type, message)
    end
end