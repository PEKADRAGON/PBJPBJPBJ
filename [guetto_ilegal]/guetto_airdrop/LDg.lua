--[[
    --» sᴄʀɪᴘᴛ ғᴇɪᴛᴏ ᴘᴏʀ » Pedro Developer
--]]

config = {
    
    notify = function(player, text, type)

        return exports['guetto_notify']:showInfobox(player, type, text)

    end; 

    giveItem = function(player, item, amount)

        return exports['guetto_inventory']:giveItem(player, item, amount);

    end;

    command = 'drop';
    clickTimes = 2; -- // Quantidade de vezes que pode ser clicado para ser looteado
    dropFallTime = 1 * 30 * 60000; -- tempo em que os drops vão cair, aleatoriamente
    radarAreaSize = 250;
    flyTime = 30000;
    flyRadius = 3400;
    flyAltitude = 300; 
    planeModel = 1681; 
    planeScale = 3.5; 
    dropTime = 60000;
    dropBlip = 0;
    maxItens = 3;

    positions = {
        {2171.168, -1005.444, 62.805};
        {769.055, -251.702, 13.144}; 
        {3311.797, -1344.45, 3.793}; 
        {2767.142, 464.654, 8.29};
        {1285.974, 246.887, 19.41};
        {867.798, -30.09, 63.195};
    };

    itens = { -- item, quantidade
    {54, 200};
    {63, 1};
    {38, 1};
    {25, 1};
    {12, 2};
    {59, 1};
    {53, 28};
    };  

    acls = {'Console'}; -- acls com acesso ao comando
}
