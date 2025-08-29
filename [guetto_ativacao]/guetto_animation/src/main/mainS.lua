local Global = { ['Objetos'] = { } }

core = function ( )
    registerEvent('vanish.set.animation', resourceRoot, setPlayerAnimation)
    registerEvent('vanish.stop.animation', resourceRoot, stopPlayerAnimation)
    addEventHandler('onPlayerQuit', resourceRoot, quitPlayer)

    for _, v in ipairs (config["Categorys"]) do
        for index, value in ipairs(config["Animations"][v[5]]) do 
            addCommandHandler(value.others.command, function (player, cmd)
                local key = getPlayerSerial(player)    
                local hashtoKey = toJSON({
                    dados = value, 
                    key = key
                })
                encodeString('aes128', hashtoKey, {key = key:sub(17)}, function(enc, iv)
                    triggerEvent ( 'vanish.set.animation', resourceRoot, player, enc, iv )
                end)
            end)
        end
    end
end;

setPlayerAnimation = function ( player, hash, iv )
    decodeString('aes128', hash, {key = getPlayerSerial(player):sub(17), iv = iv}, function(decoded)

        local data = fromJSON(decoded)

        if not data then 
            return print ( "Error: Dados não encontrados" )
        end;

        if isPedInVehicle(player) then 
            return config.sendMessageServer(player, 'Você não pode executar animações dentro de um veículo!', 'error')
        end;

        if isPedDead(player) then 
            return config.sendMessageServer(player, 'Você não pode executar animações morto!', 'error')
        end;

        if data.dados.others.type == 'walk' then 
           
            setPedWalkingStyle (player, data.dados.others.options.style)
            config.sendMessageServer(player, 'Estilo de andar '..(data.dados.name)..' selecionado!', 'success')
        
        elseif data.dados.others.type == 'dance' then 
            
            if (data.dados.others.IFP == true) then 
                triggerClientEvent(getElementsByType('player'), 'vanish.set.ifp', resourceRoot, player, data.dados.others.category, data.dados.others.animation)
            else
                setPedAnimation(player, data.dados.others.category,  data.dados.others.animation, unpack(data.dados.others.options))
            end

            config.sendMessageServer(player, 'Você selecionou a animação '..(data.dados.name)..'!', 'success')
        
        elseif data.dados.others.type == 'objects' then 
            if data.dados.others.Custom then 
                local custom = config['CUSTOM_ANIMATIONS'][data.dados.others.category][data.dados.others.animation]
                
                triggerClientEvent(getElementsByType('player'), 'vanish.set.custom.animation', resourceRoot, player, data.dados.others)
           
                if data.dados.others.IFP then 
                    triggerClientEvent(getElementsByType('player'), 'vanish.set.ifp', resourceRoot, player, data.dados.others.category, data.dados.others.animation)
                end

                if custom.Object then 
                    if Global['Objetos'][player] and isElement(Global['Objetos'][player]) then 
                        destroyElement(Global['Objetos'][player])
                        Global['Objetos'][player] = nil 
                    end;

                    Global['Objetos'][player] = createObject(custom.Object.Model, 0, 0, 0)
                    setObjectScale(Global['Objetos'][player], custom.Object.Scale or 1)

                    exports.pAttach:attach(Global['Objetos'][player], player, unpack(custom.Object.Offset))
                end

                setPedAnimation(player, data.dados.others.category,  data.dados.others.animation, unpack(data.dados.others.options))
            end

            config.sendMessageServer(player, 'Você selecionou a animação '..(data.dados.name)..'!', 'success')

        elseif data.dados.others.type == 'legal' then

            triggerClientEvent(getElementsByType('player'), 'vanish.set.custom.animation', resourceRoot, player, data.dados.others)
            config.sendMessageServer(player, 'Você selecionou a animação '..(data.dados.name)..'!', 'success')
        end;
    end)
end;

stopPlayerAnimation = function ( player )
    
    if Global['Objetos'][player] and isElement(Global['Objetos'][player]) then 
        destroyElement(Global['Objetos'][player])
        Global['Objetos'][player] = nil 
    end;

    if (getElementData(player, "zablokowany-realdriveby")) then 
        return config.sendMessageServer(player, 'Você não pode parar uma animação enquanto está paralizado!', 'info')
    end

    toggleControl(player, 'fire', true)
    toggleControl(player, 'jump', true)
    toggleControl(player, 'enter_passenger', true)
    
    setPedAnimation(player, nil)
    triggerClientEvent(getElementsByType('player'), 'vanish.set.custom.animation', resourceRoot, player, false)
end;


quitPlayer = function ( )
 
    if Global['Objetos'][source] and isElement(Global['Objetos'][source]) then 
        destroyElement(Global['Objetos'][source])
        Global['Objetos'][source] = nil 
    end;

    setPedAnimation(source, nil)
end;


core ( )
