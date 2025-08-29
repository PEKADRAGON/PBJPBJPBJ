local inicio, caminhao, colshape1, colshape2, ocupado1, ocupado2, marker, capacidade, veiculo_col, blip_lixeira = {}, {}, {}, {}, {}, {}, {}, {}, {}, {}
local lixeira, lixo, sucatas_lixeira = {}, {}, {} 

for i, v in ipairs(config.inicios) do 
    inicio[i] = createMarker(v[1], v[2], v[3] - 0.9, 'cylinder', 1.4, 255, 255, 255, 0)
    setElementData(inicio[i], 'markerData', {title = 'Lixeiro', desc = 'Inicie seu trabalho aqui!', icon = 'trash'})

    setElementData(inicio[i], 'marker_custom', v[4]) 

    addEventHandler('onMarkerHit', inicio[i], 
        function(player) 
            if isElement(player) and getElementType(player) == 'player' and not isPedInVehicle(player) then 
                if (getElementData(player, 'Emprego') or 'Desempregado') == 'Lixeiro' then 
                    if not isElement(caminhao[player]) then 
                        caminhao[player] = createVehicle(408, v[5], v[6], v[7], v[8], v[9], v[10], 'LIXEIRO')
                        message(player, "Você pegou o caminhão! Digite /lixeiras para localizar as lixeiras no mapa.", "info")
                        capacidade[ caminhao[player] ] = 0 
                        marker[ caminhao[player] ] = createMarker(v[5], v[6], v[7], 'cylinder', 1.3, r, g, b, 0) veiculo_col[ marker[ caminhao[player] ] ] = caminhao[player]
                        attachElements(marker[ caminhao[player] ], caminhao[player], 0, -4, -1)

                        addEventHandler('onMarkerHit', marker[ caminhao[player] ], 
                            function(player) 
                                if isElement(player) and getElementType(player) == 'player' and not isPedInVehicle(player) then  
                                    if isElement(lixo[player]) then
                                        destroyElement(lixo[player]) 
                                        triggerClientEvent(player, 'Pedro.playSoundLixeiro', player, 'assets/trash.mp3')
                                        if capacidade[ veiculo_col[source] ] < 50 then 
                                            capacidade[ veiculo_col[source] ] = capacidade[ veiculo_col[source] ]  + 1
                                            setPedAnimation(player, 'BASEBALL', 'BAT_PART')

                                            local lixoss = config.possibilidades[math.random(1, #config.possibilidades)]
                                            message(player, 'Você pegou um item ('..lixoss..')', 'success')
                                            exports['guetto_inventory']:giveItem(player, lixoss, 1)

                                            message(player, 'Você carregou o caminhão.', 'success')
                                            message(player, 'Capacidade do caminhão '..capacidade[ veiculo_col[source] ]..' / 50.', 'info')
                                            
                                            setTimer(function(player)
                                                if isElement(player) then 
                                                    setPedAnimation(player, nil) 
                                                end
                                            end, 450, 1, player)     
                                        else 
                                            message(player, 'O caminhão está lotado.', '') 
                                        end
                                    end
                                end    
                            end
                        )

                        colshape1[caminhao[player]] = createColSphere(v[5], v[6], v[7], 1.2) veiculo_col[colshape1[caminhao[player]]] = caminhao[player]
                        attachElements(colshape1[caminhao[player]], caminhao[player], -1.5, -4, 0)

                        colshape2[caminhao[player]] = createColSphere(v[5], v[6], v[7], 1.2) veiculo_col[colshape2[caminhao[player]]] = caminhao[player]
                        attachElements(colshape2[caminhao[player]], caminhao[player], 1.5, -4, 0)

                        ocupado1[ caminhao[player] ] = false 
                        ocupado2[ caminhao[player] ] = false  

                        addEventHandler('onColShapeHit', colshape1[caminhao[player]], 
                            function(player) 
                                if isElement(player) and getElementType(player) == 'player' and not isPedInVehicle(player) then  
                                    if not ocupado1[veiculo_col[source]] then 
                                        triggerClientEvent(player, 'Pedro.mensagemLixeiro', player, 'Pressione [E] para subir')
                                        bindKey(player, 'e', 'down', entrar_1, veiculo_col[source])    
                                    end
                                end     
                            end
                        )

                        addEventHandler('onColShapeLeave', colshape1[caminhao[player]], 
                            function(player) 
                                if isElement(player) and getElementType(player) == 'player' and not isPedInVehicle(player) then  
                                    triggerClientEvent(player, 'Pedro.removeMensagemLixeiro', player)
                                    unbindKey(player, 'e', 'down', entrar_1)    
                                end     
                            end
                        )

                        addEventHandler('onColShapeHit', colshape2[caminhao[player]], 
                            function(player) 
                                if isElement(player) and getElementType(player) == 'player' and not isPedInVehicle(player) then  
                                    if not ocupado2[veiculo_col[source]] then 
                                        triggerClientEvent(player, 'Pedro.mensagemLixeiro', player, 'Pressione [E] para subir')
                                        bindKey(player, 'e', 'down', entrar_2, veiculo_col[source])    
                                    end
                                end     
                            end
                        )

                        addEventHandler('onColShapeLeave', colshape2[caminhao[player]], 
                            function(player) 
                                if isElement(player) and getElementType(player) == 'player' and not isPedInVehicle(player) then  
                                    triggerClientEvent(player, 'Pedro.removeMensagemLixeiro', player)
                                    unbindKey(player, 'e', 'down', entrar_2)    
                                end     
                            end
                        )

                        addEventHandler('onElementDestroy', caminhao[player], 
                            function()
                                if isElement(colshape1[caminhao[player]]) then destroyElement(colshape1[caminhao[player]]) end 
                                if isElement(colshape2[caminhao[player]]) then destroyElement(colshape2[caminhao[player]]) end 

                                if isElement(ocupado1[ caminhao[player] ]) then 
                                    unbindKey(ocupado1[ caminhao[player] ], 'e', 'down', entrar_1)   
                                    unbindKey(ocupado1[ caminhao[player] ], 'e', 'down', entrar_2)   
                                    unbindKey(ocupado1[ caminhao[player] ], 'e', 'down', sair_caminhao)   
                                    ocupado1[ caminhao[player] ] = false 
                                end 

                                if isElement(ocupado2[ caminhao[player] ]) then 
                                    unbindKey(ocupado2[ caminhao[player] ], 'e', 'down', entrar_1)   
                                    unbindKey(ocupado2[ caminhao[player] ], 'e', 'down', entrar_2)   
                                    unbindKey(ocupado2[ caminhao[player] ], 'e', 'down', sair_caminhao)   
                                    ocupado2[ caminhao[player] ] = false 
                                end 
                            end
                        )

                    else
                        message(player, 'Você já tem um caminnhão em andamento.', 'info')
                    end  
                end      
            end 
        end
    )
end

function entrar_1(player, _, _, vehicle) 
    if not ocupado1[ vehicle ] then 
        ocupado1[ vehicle ] = player

        if vehicle and isElement(vehicle) then 
            attachElements(player, vehicle, -1.2, -3.5, 0)
            bindKey(player, 'e', 'down', sair_caminhao, vehicle)
            triggerClientEvent(player, 'Pedro.removeMensagemLixeiro', player)
            triggerClientEvent(player, 'Pedro.mensagemLixeiro', player, 'Pressione [E] para sair')
        end

    end
    unbindKey(player, 'e', 'down', entrar_1)
end

function entrar_2(player, _, _, vehicle) 
    if not ocupado2[ vehicle ] then 
        ocupado2[ vehicle ] = player
        setElementCollisionsEnabled(player, false)
        attachElements(player, vehicle, 1.2, -3.5, 0)
        bindKey(player, 'e', 'down', sair_caminhao, vehicle)
        triggerClientEvent(player, 'Pedro.removeMensagemLixeiro', player)
        triggerClientEvent(player, 'Pedro.mensagemLixeiro', player, 'Pressione [E] para sair')
    end
    unbindKey(player, 'e', 'down', entrar_2)
end

function sair_caminhao(player, _, _, vehicle) 
    if ocupado1[ vehicle ] == player then ocupado1[ vehicle ] = false end 
    if ocupado2[ vehicle ] == player then ocupado2[ vehicle ] = false end 
    setElementCollisionsEnabled(player, true)
    detachElements(player)
    triggerClientEvent(player, 'Pedro.removeMensagemLixeiro', player)
    unbindKey(player, 'e', 'down', sair_caminhao)
end

for i, v in ipairs(config.lixeiras) do 
    lixeira[i] = createObject(3035, v[1], v[2], v[3], v[4], v[5], v[6]) 
    blip_lixeira[i] = createBlipAttachedTo(lixeira[i], 36, _, _, _, _, _, _)
    setElementVisibleTo(blip_lixeira[i], root, false)
    sucatas_lixeira[lixeira[i]] = config.sucatas_por_lixeira 
    setElementData(lixeira[i], 'lixeira', 'Lixeira disponível')
    setElementFrozen(lixeira[i], true)
    
    addEventHandler('onElementClicked', lixeira[i], 
        function(b, s, player)
            if ( b == 'left' ) and ( s == 'down' ) then 
                local pos = {getElementPosition(player)} 
                if getDistanceBetweenPoints3D(pos[1], pos[2], pos[3], v[1], v[2], v[3])  <= 5 then 
                    if (getElementData(player, 'Emprego') or 'Desempregado') == 'Lixeiro' then 
                        if not isElement(lixo[player]) then 
                            if sucatas_lixeira[lixeira[i]] > 0 then 
                                sucatas_lixeira[lixeira[i]] = sucatas_lixeira[lixeira[i]] - 1
                                setPedAnimation(player, 'BAR', 'Barcustom_get') 
                                setTimer(function(player)
                                    if isElement(player) then 
                                        lixo[player] = createObject(1265, unpack({getElementPosition(player)})) 
                                        setElementCollisionsEnabled(lixo[player], false)
                                        exports['bone_attach']:attachElementToBone(lixo[player], player, 12, 0, 0, 0.25, 180, -45)        
                                        setPedAnimation(player, nil) 
                                    end
                                end, 2000, 1, player)     
                                if sucatas_lixeira[ lixeira[i] ] <= 0 then 
                                    setElementData(lixeira[i], 'lixeira', 'Lixeira Vazia')
                                end
                            else
                                message(player, 'Essa lixeira não tem sucatas.', 'error')    
                            end
                        else 
                            message(player, 'Você já está com um lixo na mão.', 'error')
                        end
                    end
                end
            end
        end
    )
end

setTimer(function()
    for i, v in ipairs(lixeira) do 
        sucatas_lixeira[v] = config.sucatas_por_lixeira    
        setElementData(v, 'lixeira', 'Lixeira disponível')
    end
end, config.tempo_lixeiras * 60000, 0)


local loja = {}
for i, v in ipairs(config.lojas) do 
    loja[i] = createMarker(v[1], v[2], v[3], 'cylinder', 1.4, r, g, b, 0)
    setElementData(loja[i], 'markerData', {title = 'Lixeiro', desc = 'Venda suas sucatas aqui!', icon = 'office'})

    addEventHandler('onMarkerHit', loja[i], 
        function(player) 
            if isElement(player) and getElementType(player) == 'player' and not isPedInVehicle(player) then 
                local total = 0
                local lixoss = 0 

                for i, v in ipairs(config.lixos) do 
                    if (exports['guetto_inventory']:getItem(player, v) ~= 0) then 
                        total = total + (exports['guetto_inventory']:getItem(player, v) * config.precos[v])
                        lixoss = lixoss + (exports['guetto_inventory']:getItem(player, v))
                    end 
                end
                
                if peixess ~= 0 then 
                    triggerClientEvent(player, 'Pedro.printLojaLixos', player, total, lixoss)
                else
                    message(player, 'Você não tem items!', 'error')
                end
            end 
        end
    )
end

addEvent('Pedro.venderLixos', true) 
addEventHandler('Pedro.venderLixos', resourceRoot, 
    function(value) 

        if value <= 0 then 
            return false 
        end

        if not client then 
            return false 
        end
        
        if source ~= getResourceDynamicElementRoot(getThisResource()) then 
            return outputDebugString( " Resource | ".. (getResourceName(getThisResource())).." | ".. (getPlayerName(client)).." # "..(getElementData(client, 'ID') or "N/A").." | Serial | "..getPlayerSerial(client).."  | IP | "..(getPlayerIP(client)).."", 1 )
        end

        givePlayerMoney(client, tonumber(value))
        

        for i, v in ipairs(config.lixos) do 
            if (exports['guetto_inventory']:getItem(client, v)) then 
                exports['guetto_inventory']:takeItem(client, v, (exports['guetto_inventory']:getItem(client, v) or 0))
            end 
        end 

        local xp = (getElementData(client, "XP") or 0)
        local randomXP = math.random(100, 200);
        local isVip = exports["guetto_util"]:isPlayerVip(client)

        if isVip then 
            setElementData(client, "XP", xp + (randomXP * 2))
            message(client, 'Você recebeu o dobro de xp por ser vip! '..(randomXP * 2)..' de XP!', 'success')
        else
            setElementData(client, "XP", xp + randomXP)
            message(client, 'Você recebeu '..(randomXP * 2)..' de XP!', 'success')
        end
     
    end
)

local descarregamento = {}
for i, v in ipairs(config.descarregar) do 
    descarregamento[i] = createMarker(v[1], v[2], v[3], 'cylinder', 4.5, r, g, b, 0)
    setElementData(descarregamento[i], 'markerData', {title = 'Lixeiro', desc = 'Descarregue seu caminhão aqui!', icon = 'truck'})

    addEventHandler('onMarkerHit', descarregamento[i], 
        function(player) 
            if isElement(player) and getElementType(player) == 'player' and isPedInVehicle(player) then 
                if getElementModel(getPedOccupiedVehicle(player)) == 408 then 
                    if (getElementData(player, 'Emprego') or 'Desempregado') == 'Lixeiro' then 
                        local vehicle = getPedOccupiedVehicle(player) 
                        toggleAllControls(player, false)
                        setElementFrozen(vehicle, true)

                        exports["guetto_progress"]:callProgress(player, "Lixeiro", "Você está descarregando as sucatas!", "martelo", 30000) 
                        triggerClientEvent(player, 'Pedro.playSoundLixeiro', player, 'assets/Audio_caminhao_descarregando.mp3')
                        setTimer(function(player, vehicle)
                            if isElement(player) and isElement(vehicle) then 
                                toggleAllControls(player, true)
                                if capacidade[vehicle] then 
                                    givePlayerMoney(player, capacidade[vehicle] * config.sucata_descarregada)
                                    message(player, 'Você entregou sua rota e recebeu R$'..(capacidade[vehicle] * config.sucata_descarregada)..'.', 'success')
                                end
                            
                                destroyElement(vehicle)
                            end 
                        end, 30000, 1, player, vehicle)

                    end 
                end
            end
        end
    )
end

addCommandHandler('lixeiras', 
    function(player)
        if (getElementData(player, 'Emprego') or 'Desempregado') == 'Lixeiro' then 
            if isElement(blip_lixeira[1]) then 
                if isElementVisibleTo(blip_lixeira[1], player) then 
                    for i, v in ipairs(blip_lixeira) do 
                        setElementVisibleTo(v, player, false) 
                    end
                else 
                    for i, v in ipairs(blip_lixeira) do 
                        setElementVisibleTo(v, player, true) 
                    end
                end
            end
        end
    end
)

addEventHandler('onPlayerWasted', root,
    function()
        if lixo[source] and isElement(lixo[source]) then 
            destroyElement(lixo[source])
            lixo[source] = nil 
        end
    end
)

addEventHandler('onPlayerQuit', root,
    function()
        if lixo[source] and isElement(lixo[source]) then 
            destroyElement(lixo[source])
            lixo[source] = nil 
        end
    end
)

function message(player, text, type) 
    return exports['guetto_notify']:showInfobox(player, type, text)
end