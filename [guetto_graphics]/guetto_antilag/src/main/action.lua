function GuettoExecuteAction (title, value)
    if (title == "Limitar FPS") then
        
        setFPSLimit(value)
        config.sendMessageClient( 'Você alterou o limite de FPS para '..value..'.', 'success')
        
    elseif (title == "Renderização do mapa") then 
        
        setFarClipDistance(1500 * (value / 100))

    elseif (title == "Tamanho do sol/lua") then 

        setSunSize(value / 500 * value)
        setMoonSize(value / 500 * value)

    elseif (title == "Disparo realista") then 

        if value == true then 
            setElementData( localPlayer, "FireOn", true )
            config.sendMessageClient("Fire ativado!", "info")
        elseif value == false then 
            setElementData( localPlayer, "FireOn", false )
            config.sendMessageClient("Fire desativado!", "info")
        end

    elseif (title == "Mini mapa (fora do veículo)") then 

        setElementData(localPlayer, "minimap", value)
        config.sendMessageClient("Mini mapa "..(value and "Ativado" or "Desativado").."!", "info")

    elseif (title == "Ruas") then 

        if value == true then 
            triggerEvent( "toggleRoads2", localPlayer, true )
        elseif value == false then 
            triggerEvent( "toggleRoads2", localPlayer, false )
        end

        --exports['[BVR]Ruas']:loadMod(value)
        config.sendMessageClient("Ruas "..(value and "Ativadas" or "Desativadas").."!", "info")

    elseif (title == "Vignette FX") then 

        if value == true then 
            triggerEvent( "toggleVignette", localPlayer, true )
        elseif value == false then 
            triggerEvent( "toggleVignette", localPlayer, false )
        end
        config.sendMessageClient("Vignette "..(value and "Ativadas" or "Desativadas").."!", "info")


    elseif title == 'Chat' then
        
        showChat(value)
        config.sendMessageClient("Chat "..(value and "Ativadas" or "Desativadas").."!", "info")

    elseif title == 'Céu Realista' then

        triggerEvent("ToggleSkybox", localPlayer, value)
        config.sendMessageClient("Céu Realista "..(value and "Ativado" or "Desativado").."!", "info")

    elseif title == 'Àgua Realista' then
        
        if getVersion().sortable < "1.3.0" then
            config.sendMessageClient("O recurso não é compatível com este cliente.", "error")
            return
        end

        if value == true then 
            triggerEvent( "ToggleWater", localPlayer, true )
        elseif value == false then
            triggerEvent( "ToggleWater", localPlayer, false )
        end
        
        --exports["shader_water"]:manageWater(value)
        config.sendMessageClient("Àgua Realista "..(value and "Ativado" or "Desativado").."!", "info")

    elseif title == "Hud" then 
        
        setElementData(localPlayer, "guetto.showning.hud", (value and true or false))
        config.sendMessageClient("Hud "..(value and "Ativado" or "Desligada").."!", "info")

    elseif title == 'FXAA (Anti-aliasing)' then

        if tonumber(dxGetStatus().VideoCardPSVersion) < 3 then 
            config.sendMessageClient('client', _, "FXAA não é suportado para Model 3!", "error")
            return 
        end

        triggerEvent("switchFxaa", localPlayer, value)

        config.sendMessageClient("FXAA "..(value and "Ativado" or "Desligado").."!", "info")

    elseif title == 'Plotagem' then

        exports['guetto_plotagem']:changeState(value)
        config.sendMessageClient("Plotagem "..(value and "Ativado" or "Desligado").."!", "info")

    elseif title == 'Chat' then

        showChat(value)
        config.sendMessageClient("Chat "..(value and "Ativado" or "Desligado").."!", "info")
         
    elseif title == 'Reflexo realista' then

        if value == true then 
           --triggerEvent( "ToggleSUN", localPlayer, true )
            triggerEvent( "switchCarPaintReflectLite", root, true )
        elseif value == false then
            --triggerEvent( "ToggleSUN", localPlayer, false ) 
            triggerEvent( "switchCarPaintReflectLite", root, false )
        end

        config.sendMessageClient("Céu Realista "..(value and "Ativado" or "Desligado").."!", "info")

    elseif title == 'Pallet FX' then

        if value == true then 
            setElementData( localPlayer, "shader:colors", true )
        elseif value == false then 
            setElementData( localPlayer, "shader:colors", false )
        end
    config.sendMessageClient("Pallet  "..(value and "Ativado" or "Desligado").."!", "info")

    elseif title == 'Remover fumaça' then

        if value == true then 
            setElementData( localPlayer, "shaders:smoke", true )
        elseif value == false then 
            setElementData( localPlayer, "shaders:smoke", false )
        end
    config.sendMessageClient("Fumaça  "..(value and "Ativado" or "Desligado").."!", "info")


    elseif title == 'Contrast HDR' then

        if value == true then 
            setElementData( localPlayer, "contrast", true )
        elseif value == false then 
            setElementData( localPlayer, "contrast", false )
        end
    config.sendMessageClient("HDR  "..(value and "Ativado" or "Desligado").."!", "info")

    elseif title == 'Vegetação FX' then

        if value == true then 
            triggerEvent( "startTrees", localPlayer, true )
        elseif value == false then 
            triggerEvent( "stopTrees", localPlayer, false )
        end

        config.sendMessageClient("Vegetação FX "..(value and "Ativado" or "Desligado").."!", "info")

    elseif title == 'Vegetação do ambiente' then

        if value then
            for i = 615, 904 do
                restoreWorldModel (i, 999999999999999999999, 0, 0, 0)
            end
        else
            for i = 615, 904 do
                removeWorldModel (i, 999999999999999999999, 0, 0, 0)
            end
        end	

        config.sendMessageClient("Vegetação do ambiente "..(value and "Ativado" or "Desligado").."!", "info")

    elseif title == 'Folhas Effects' then

        if value then
            triggerEvent("JOAO.createSnowFlakes", localPlayer)
        else
            triggerEvent("JOAO.removeSnowFlakes", localPlayer)
        end

        config.sendMessageClient("Folhas Effects "..(value and "Ativado" or "Desligado").."!", "info")

    elseif title == 'Modo streaming' then

        if value == true then 
            setElementData( localPlayer, "streaming", true )
        elseif value == false then 
            setElementData( localPlayer, "streaming", false )
        end

        config.sendMessageClient("Streaming "..(value and "Ativado" or "Desligado").."!", "info")

    elseif title == 'Depth FX' then

        if value == true then 
            setElementData( localPlayer, "shader:blur", true )
        elseif value == false then 
            setElementData( localPlayer, "shader:blur", false )
        end

        config.sendMessageClient("Depth FX "..(value and "Ativado" or "Desligado").."!", "info")

    elseif title == 'Blur' then

        if value == true then 
            triggerEvent( "ToggleBlur", localPlayer, true )
        elseif value == false then 
            triggerEvent( "ToggleBlur", localPlayer, false )
        end

        config.sendMessageClient("Blur FX "..(value and "Ativado" or "Desligado").."!", "info")

    elseif title == 'Light FX' then

        if value == true then 
            triggerEvent( "toggleLight", localPlayer, true )
        elseif value == false then
            triggerEvent( "toggleLight", localPlayer, false )
        end

        config.sendMessageClient("Blur FX "..(value and "Ativado" or "Desligado").."!", "info")

    elseif title == 'SSAO' then

        if value == true then 
            triggerEvent( "ToggleSSAO", localPlayer, true )
        elseif value == false then 
            triggerEvent( "ToggleSSAO", localPlayer, false )
        end

        config.sendMessageClient("SSAO FX "..(value and "Ativado" or "Desligado").."!", "info")

    elseif title == 'LUT' then

        if value == true then 
            triggerEvent( "ToggleLut", localPlayer, true )
        elseif value == false then 
            triggerEvent( "ToggleLut", localPlayer, false )
        end
        config.sendMessageClient("LUT FX "..(value and "Ativado" or "Desligado").."!", "info")

    end



    interface.dados.data[title] = value
    triggerServerEvent("Anti>Lag>Apply>Modifications", resourceRoot, interface.dados)
end
