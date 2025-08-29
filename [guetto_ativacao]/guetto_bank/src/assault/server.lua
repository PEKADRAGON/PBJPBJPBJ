local timer = {}
local objeto = {}

addEvent("AssaultFinish", true)
addEventHandler("AssaultFinish", resourceRoot,  
    function (index)

        if not (source or (source ~= resourceRoot)) then 
            return false 
        end

        if (blip[index] and isElement(blip[index])) then 
            setBlipIcon(blip[index], 41)
        end

        local dados = config["positions"][index]
        config.sendMessageServer(client, "Bomba armada! Tempo estimado para explosão: 5 segundos.", "info")
        
        setTimer(function(player, obj)
            local random = math.random(RANDOM_QUANT[1], RANDOM_QUANT[2])

            createExplosion(dados[1], dados[2], dados[3], 0)
            setElementModel(obj, 2943)
            
            if (objeto[player] and isElement(objeto[player])) then 
                destroyElement(objeto[player])
                objeto[player] = nil 
               
                exports["guetto_inventory"]:giveItem(player, config["assault"]["dinheiroSujo"], random)
                config.sendMessageServer(player, "Você recebeu R$ "..formatNumber(random, ".").." por ter explodido esse caixinha. Agora fuja!", "info")
            else
                objeto[player] = createPickup(dados[1], dados[2] + 1, dados[3], 3, 1550)
                config.sendMessageServer(player, "A bomba explodiu! Volte e pegue a mochila com dinheiro.", "info")
            end
            

        end, 5000, 1, client, atms[index])
        

        setElementData(atms[index], "assaultado", true)

        toggleAllControls(client, true)
        setElementFrozen(client, false)
        setPedAnimation(client)

        timer[index] = setTimer(function(player, index, obj)
            
            if (blip[index] and isElement(blip[index])) then 
                setBlipIcon(blip[index], 52)
            end

            if objeto[player] and isElement(objeto[player]) then 
                destroyElement(objeto[player])
                objeto[player] = nil 
                config.sendMessageServer(player, 'Você demorou demais para pegar seu dinheiro e ele foi confiscado!', 'error')
            end

            removeElementData(atms[index], "assaultado")
            setElementModel(obj, 2942)

        end, config["assault"]["recuperar"] * 60000, 1, client, index, atms[index])

    end
)

addEvent("AssaultFailed", true)
addEventHandler("AssaultFailed", resourceRoot,  
    function ( )
        if not (source or (source ~= resourceRoot)) then 
            return false 
        end

        toggleAllControls(client, true)
        setElementFrozen(client, false)
        setPedAnimation(client)
    end
)


addEventHandler( "onPickupHit", resourceRoot, 
    function ( player ) 
        if player and isElement(player) and getElementType(player) == 'player' then 
            if not isPedInVehicle(player) then 
                local random = math.random(RANDOM_QUANT[1], RANDOM_QUANT[2])

                if objeto[player] and isElement(objeto[player]) then 
                    destroyElement(objeto[player])
                    objeto[player] = nil 
                end
                
                config.sendMessageServer(player, "Você recebeu R$ "..formatNumber(random, ".").." por ter explodido esse caixinha. Agora fuja!", "info")
                exports["guetto_inventory"]:giveItem(player, config["assault"]["dinheiroSujo"], random)
            else
                config.sendMessageServer(player, 'Saia do veículo!', 'error')
            end
        end
    end
)

addEventHandler('onPlayerWasted', root,
    function ( )
        if (objeto[source] and isElement(objeto[source])) then 
            destroyElement(objeto[source])
            objeto[source] = nil 
        end
    end
)

addEventHandler('onPlayerQuit', root,
    function ( )
        if (objeto[source] and isElement(objeto[source])) then 
            destroyElement(objeto[source])
            objeto[source] = nil 
        end
    end
)