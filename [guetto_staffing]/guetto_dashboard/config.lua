config = {
    settings = {
        bind = "tab";
        players = 300;
    };

    datas = {
        elements = {
            bank = "guetto.bank.balance";
            coins = "guetto.points";
            avatar = "Avatar";
            job = "Emprego";
            level = "Level";
            exp = "XP";
        };

        services = {
            staff = "onProt";
            police = "service.police";
            medic = "service.samu";
            mechanic = "service.mechanic";
        };
    };

    banners = {
        {priority = 1, type = "acl", image = "assets/cards/fundador.png", group = "Console"}; -- elementData (onProt)
        {priority = 2, type = "acl", image = "assets/cards/diretor.png", group = "Diretor"};
        {priority = 2, type = "acl", image = "assets/cards/vdiretor.png", group = "Vice-diretor"};
        {priority = 3, type = "acl", image = "assets/cards/moderador.png", group = "Moderador"};
        {priority = 4, type = "acl", image = "assets/cards/patrocinador.png", group = "Patrocinador"};
        {priority = 5, type = "acl", image = "assets/cards/marginal.png", group = "Marginal de grife"};
        {priority = 6, type = "acl", image = "assets/cards/visionario.png", group = "Visionário"};
        {priority = 7, type = "acl", image = "assets/cards/criminoso.png", group = "Criminoso"};
        {priority = 8, type = "acl", image = "assets/cards/luxuria.png", group = "Luxuria"};
        {priority = 9, type = "acl", image = "assets/cards/youtube.png", group = "Influenciador"};
        {priority = 10, type = "acl", image = "assets/cards/suporte.png", group = "Staff"};
        {priority = 11, type = "acl", image = "assets/cards/everyone.png", group = "Everyone"};
    };
}

function sendMessage (action, element, message, type)
    if action == "client" then
        return exports['guetto_notify']:showInfobox(type, message)
    elseif action == "server" then
        return exports['guetto_notify']:showInfobox(player, type, message)
    end
end

function convertNumber(amount)
    local left, center, right = string.match(math.floor(amount), '^([^%d]*%d)(%d*)(.-)$')
    return left .. string.reverse(string.gsub(string.reverse(center), '(%d%d%d)', '%1.')) .. right
end

function registerEvent(event, element, callback)
    addEvent(event, true)
    addEventHandler(event, element, callback)
end

_getPlayerName = getPlayerName;
function getPlayerName(element)
    return _getPlayerName(element):gsub("#%x%x%x%x%x%x", "") or _getPlayerName(element);
end