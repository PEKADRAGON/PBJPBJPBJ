config = {
    panel = {
        command = "gerenciador";
        datacoins = "guetto.points";
    };

    vips = {
        {"Marginal de grife"};
        {"Visionário"};
        {"Criminoso"};
        {"Luxuria"};
        {"Patrocinador"};
    };

    productsKey = {
        {"Marginal de grife"};
        {"Visionário"};
        {"Criminoso"};
        {"Luxuria"};
        {"Pontos"};
    };

    ["ativação"] = {
        ["Marginal de grife"] = 50000;
        ["Visionário"] = 30000;
        ["Criminoso"] = 20000;
        ["Luxuria"] = 10000;
    };

    prices = {
        ["Pontos"] = 1;
        ["Marginal de grife"] = 50;
        ["Visionário"] = 35;
        ["Criminoso"] = 25;
        ["Luxuria"] = 15;
    };

    musicas = {
        "https://cdn.discordapp.com/attachments/1237941791546933259/1278457775466483764/Joga_na_Frequencia_do_Radio_-_Mc_Rodrigo_do_CN_xs.mp3?ex=66d0e016&is=66cf8e96&hm=4d1596574521ac0fecb8c82628f7eb3f9feebcd1fc095ea4e83016ace5843365&";
    };

    logs = {
        log = true;
        web_hook = "https://discord.com/api/webhooks/1107614519502577716/CgEJPl9aHzWZgn6SYLNwVAQGjOBO34DsKkHxNo4f275J_VI06xfe7GF2Ab3e8EzgO82i";
    };
}

function sendMessage (action, element, message, type)
    if action == "client" then
        return exports['guetto_notify']:showInfobox(type, message)
    elseif action == "server" then
        return exports['guetto_notify']:showInfobox(element, type, message)
    end
end