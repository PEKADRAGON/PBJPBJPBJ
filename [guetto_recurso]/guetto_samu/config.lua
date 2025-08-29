--[[
      ______                        __      __                       ______   __    __               
 /      \                      |  \    |  \                     /      \ |  \  |  \              
|  $$$$$$\ __    __   ______  _| $$_  _| $$_     ______        |  $$$$$$\ \$$ _| $$_    __    __ 
| $$ __\$$|  \  |  \ /      \|   $$ \|   $$ \   /      \       | $$   \$$|  \|   $$ \  |  \  |  \
| $$|    \| $$  | $$|  $$$$$$\\$$$$$$ \$$$$$$  |  $$$$$$\      | $$      | $$ \$$$$$$  | $$  | $$
| $$ \$$$$| $$  | $$| $$    $$ | $$ __ | $$ __ | $$  | $$      | $$   __ | $$  | $$ __ | $$  | $$
| $$__| $$| $$__/ $$| $$$$$$$$ | $$|  \| $$|  \| $$__/ $$      | $$__/  \| $$  | $$|  \| $$__/ $$
 \$$    $$ \$$    $$ \$$     \  \$$  $$ \$$  $$ \$$    $$       \$$    $$| $$   \$$  $$ \$$    $$
  \$$$$$$   \$$$$$$   \$$$$$$$   \$$$$   \$$$$   \$$$$$$         \$$$$$$  \$$    \$$$$  _\$$$$$$$
                                                                                       |  \__| $$
                                                                                        \$$    $$
                                                                                         \$$$$$$
]]
config = {

    ["Others"] = {

        ["resusit"] = 4; 
        ["VidaCair"] = 20;
        ["vips"] = {"Console"};
        
    };

    ["Datas"] = {
        ["SAMU"] = "service.samu"
    };

    ['damages block'] = {
        [23] = true;
    },
    
    ["Ui"] = {
        ["Cor"] = {193, 159, 114}
    };
    
    ["Macas"] = {
        {1528.304, -1790.057, 13.664 -1, 0, 0, 89.938},
        {1528.648, -1793.642, 13.664 -1, 0, 0, 89.938},
        {1528.677, -1798.123, 13.664 -1, 0, 0, 89.938},
    };

    ["Songs"] = {
        
        {
            ["title"] = "Coração por um fio", 
            ["url"] = "https://cdn.discordapp.com/attachments/949102333361532998/1233074812335820942/heart.mp3?ex=662bc5e8&is=662a7468&hm=f1c0461a140f3ee9a9666f9265781d281d3887c44db055a996d967a65bc93183&"
        },

    };

    ["Damages"] = {
        [0] = "Tapão no pé da ureia",
        [19] = "Rocket",
        [37] = "Queimado",
        [49] = "Impacto",
        [50] = "Lâminas de helicóptero",
        [51] = "Explosão",
        [52] = "Atropelado",
        [53] = "Afogado",
        [54] = "Queda",
        [55] = "Desconhecido",
        [56] = "Luta",
        [57] = "Arma",
        [59] = "Granda de tanque",
        [63] = "Queimado (a)",
        [1] = "Soqueira",
        [2] = "Taco de golf",
        [3] = "Cacetete",
        [4] = "Faca",
        [5] = "Taco de golf",
        [6] = "Pá",
        [8] = "Katana",
        [9] = "Motosserra",
        [22] = "Colt 45",
        [23] = "Silenced",
        [24] = "Deagle",
        [25] = "12",
        [26] = "Serrada",
        [27] = "Spas 12",
        [28] = "Uzi",
        [29] = "MP5",
        [31] = "M4",
        [30] = "AK-47",
        [32] = "Tec-9",
        [33] = "Rifle",
        [34] = "Sniper",
        [35] = "Bazuca",
        [16] = "Granada",
        [17] = "Gás lacrimogêneo",
        [18] = "Molotov",
    };

    sendMessageClient = function(message, type)
        return exports['guetto_notify']:showInfobox(type, message)
    end;
 
    sendMessageServer = function(player, message, type)
        return exports['guetto_notify']:showInfobox(player, type, message)
    end;

}

function registerEventHandler ( event, ... )
    addEvent( event, true )
    addEventHandler( event, ... )
end;
