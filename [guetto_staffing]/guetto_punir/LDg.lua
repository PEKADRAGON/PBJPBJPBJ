config = {

    webhook = 'https://discord.com/api/webhooks/1281730388414431323/oVbVtmgYaetNDa2JBWN3gOpTjaeLCnEzZ5zmIDoy8L0lQI6LSEo_iCI63M9x3saDK_Yq', 
    notify = function(player, text, type)
        return exports['guetto_notify']:showInfobox(player, type, text)
    end;

    command = 'abrirpunir'; 
    command2 = 'liberar'; 
    acls = { -- acls que podem punir / liberar 
        'Resp-Banimentos', 
    }, 

    blockKeys = {
    
        ['F1'] = true; 
        ['F2'] = true; 
        ['F3'] = true; 
        ['F4'] = true; 
        ['F5'] = true; 
        ['F6'] = true; 
        ['F7'] = true; 
        ['F8'] = true; 
        ['F9'] = true; 
        ['F10'] = true; 
        ['F11'] = true; 
        ['G'] = true; 
        ['F'] = true; 
        ['B'] = true; 
        
    };

    banimento = {
        area = {1544.218, -1352.837, 329.475, 25},  -- x, y, largura, altura para ver a area digite /showcol
        spawn_punido = {1544.218, -1352.837, 329.475}, -- local que o jogador sera enviado quando for punido 
        spawn_liberado = {1462.053, -1142.192, 24.391}, -- local que o jogador sera enviado quando for liberado 
    };
}