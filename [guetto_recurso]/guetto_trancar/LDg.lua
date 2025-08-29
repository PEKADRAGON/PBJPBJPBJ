--[[
    --» sᴄʀɪᴘᴛ ғᴇɪᴛᴏ ᴘᴏʀ » Pedro Developer
--]]

config = {

    notify = function(player, text, type)
    
        return exports['guetto_notify']:showInfobox(player, type, text)

    end;

    minimunVehicleEngine = 350; -- // Vida minima para ligar o veículo

    lockKey = 'k';
    lightsKey = 'l';
    beltKey = 'x';
    engineKey = 'j'; 

}