config = {
    ["Itens"] = {
        ["Pilula Azul"] = {

            {
                title = 'BÔNUS',
                description = 'R$ 50000',
                icon = 'core/assets/icons/dinheiro.png',
                size = {90, 90},
                type = 'money',
                amount = 50000,

                func = function ( player, quantidade )
                  --  local data = (getElementData(player, "guetto.points") or 0);
                    givePlayerMoney (player, tonumber(quantidade))
                   -- setElementData(player, "guetto.points", data + 25)
                end
            };

            {
                title = 'Pop 100',
                description = 'Motinha',

                icon = 'core/assets/icons/motinha.png',
                size = {90, 90},

                type = 'vehicle',
                model = 462,
                name = 'Pop 100',
                brand = 'Honda',

                func = function ( player, name, brand, model )
                    local isPlayerHasVehicle = exports["guetto_dealership"]:getPlayerVehicle (player, model) 
                    
                    if (isPlayerHasVehicle) then
                        return false
                    end

                    if exports["guetto_dealership"]:setVehicleGaragem(player, name, brand, model, "money") then
                        return true 
                    end

                    return false
                end 
            };

            {
                title = 'ACESSORIO',
                description = 'Misterioso',
                icon = 'core/assets/icons/caixa.png',
                size = {100, 100},
                type = 'item',
                id = 27,
                func = function ( player, item )
                    exports["guetto_inventory"]:giveItem(player, item, 10)
                end
            };

        };


        
        ["Pilula Vermelha"] = {

            {
                title = 'BÔNUS',
                description = 'R$ 25000',
                icon = 'core/assets/icons/dinheiro.png',
                size = {90, 90},
                type = 'money',
                amount = 25000,

                func = function ( player, quantidade )
                   -- local data = (getElementData(player, "guetto.points") or 0);
                    givePlayerMoney (player, tonumber(quantidade))
                 --   setElementData(player, "guetto.points", data + 25)
                end
            };

            {
                title = 'Hornet',
                description = 'Hornet',
                
                icon = 'core/assets/icons/motinha.png',
                size = {90, 90},
                
                type = 'vehicle',
                model = 461,
                name = 'Hornet',
                brand = 'Honda',

                func = function ( player, name, brand, model )
                    local isPlayerHasVehicle = exports["guetto_dealership"]:getPlayerVehicle (player, model) 
                    
                    if (isPlayerHasVehicle) then
                        return false
                    end

                    if exports["guetto_dealership"]:setVehicleGaragem(player, name, brand, model, "money") then
                        return true 
                    end

                    return false
                end 
            };

            {
                title = 'ACESSORIO',
                description = 'Misterioso',
                icon = 'core/assets/icons/caixa.png',
                size = {100, 100},
                type = 'item',
                id = 26,
                func = function ( player, item )
                    exports["guetto_inventory"]:giveItem(player, item, 10)
                end
            };

        };
    };
}

sendMessageServer = function (player, msg, type)
    return exports['guetto_notify']:showInfobox(player, type, msg)
end;

sendMessageClient = function (msg, type)
    return exports['guetto_notify']:showInfobox(type, msg)
end;


function createEvent (event, ...)
    addEvent(event, true)
    addEventHandler(event, ...)
end