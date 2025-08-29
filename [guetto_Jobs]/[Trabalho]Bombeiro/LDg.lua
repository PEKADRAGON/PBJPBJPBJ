--[[
    --» sᴄʀɪᴘᴛ ғᴇɪᴛᴏ ᴘᴏʀ » Pedrooooo#1554
--]]

config = {  
    description = 'Vidas alheias e riquezas salvar'; -- texto editavel no painel 

    infosPanel = {
        skin = 278;

        itens = { -- itens que serão givados ao clicar no segundo botão (item, quantidade)
            {21, 2}; 
        };

        vehicle = 407; -- id do veiculo 
    };

    acls = { -- acls que se identificam como bombeiros 
        'CBMESP'; 
    };

    markers = {
        {
            marker_position = {1685.936, -1454.674, 17.159-1}; -- x, y, z
            vehicle_position = {1702.33, -1457.503, 13.639, 0, 0, 0};
        };
    };


    healthVehicle = 350; -- vida do veiculo para começar a pegar fogo

    timeRandomFires = 5; -- tempo em minutos que um fogo aleatório sera criado
    randomFires = { -- x, y, z

        {1399.089, 458.759, 20.202};
        {1440.094, 52.081, 32.863};
        {2234.733, 69.246, 26.484};
        {360.968, -1551.214, 32.941};
        {161.032, -174.976, 1.578};
        {1850.05, 772.795, 10.82};
        {1896.832, -1712.273, 13.64};
        {2408.917, -1671.202, 13.575};
        {2470.121, -1246.423, 28.262};
        {2020.148, -1053.746, 24.66};
        {298.771, -1427.21, 14};

    };
}

r, g, b, a = 255, 215, 0, 0

function getItem(player, item)
    return exports['guetto_inventory']:getItem(player, item)
end

function giveItem(player, item, amount)
    return exports['guetto_inventory']:giveItem(player, item, amount)
end

function takeItem(player, item, amount)
    return exports['guetto_inventory']:takeItem(player, item, amount)
end

function message(player, text, type) 
    exports['guetto_notify']:showInfobox(player, type, text)
end

function messageC(text, type)
    triggerEvent('onClientAddInfo', localPlayer, type, text, type)
end