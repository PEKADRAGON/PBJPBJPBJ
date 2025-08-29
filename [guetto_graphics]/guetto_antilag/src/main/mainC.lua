-- \\ Var´s //

interface = {}
local cache = {}
local proxPag = 0;

interface.dados = {};

interface.slidebarIsMove = false;
interface.animations = {}
interface.miraPage = 0;
interface.miraSelect = 1;
crosshair = false;

interface.state = false;
interface.crosSize = { 54, 54 }

interface.miras = {
    {1170, 439, 19, 19};
    {1204, 439, 19, 19};
    {1238, 439, 19, 19};
    {1272, 439, 19, 19};
    {1306, 439, 19, 19};
    {1340, 439, 19, 19};
    {1374, 439, 19, 19};
};

-- \\ Function´s //


function interfaceDraw ( )

    local y = 237
    local fade = 255

    dxDrawImage(448, y, 640, 606, "assets/images/fundo-settings.png", 0, 0, 0, tocolor(18, 18, 18, fade))
    dxDrawImage(1090, y, 382, 606, "assets/images/fundo-mira.png", 0, 0, 0, tocolor(255, 255, 255, fade))

    dxDrawImage(475, y + 24, 53, 49, "assets/images/pc.png", 0, 0, 0, tocolor(255, 255, 255, fade))

    dxDrawText("Painel gráfico", 551, y + 26, 295, 20, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("medium", 20), "left", "top")
    dxDrawText("Configure para melhorar ou dar qualidade ao jogo.", 551, y + 50, 295, 20, tocolor(187, 187, 187, fade), 1, exports['guetto_assets']:dxCreateFont("light", 15), "left", "top")

    dxDrawText("PAINEL DE MIRA", 1198, y + 25, 167, 20, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("medium", 20), "left", "top")
    
    dxDrawText("Tamanho", 1123, y + 80, 76, 23, tocolor(187, 187, 187, fade), 1, exports['guetto_assets']:dxCreateFont("light", 16), "left", "top")
    dxDrawText("Opacidade", 1123, y + 126, 76, 23, tocolor(187, 187, 187, fade), 1, exports['guetto_assets']:dxCreateFont("light", 16), "left", "top")

    dxDrawText("Cor da mira", 1221, y + 253, 120, 25, tocolor(187, 187, 187, fade), 1, exports['guetto_assets']:dxCreateFont("light", 20), "left", "top")

    local r, g, b = colorpicker.getColor("color>picker:1", 1)

    if interface.miraSelect then 
        local data = config["miras"][interface.miraSelect]
        if data then 

            slidebar.create("tamanho>mira", 1123, 346, 166, 5, 19, 12, "assets/images/slide-bar-bg.png", "assets/images/circle.png", tocolor(217, 217, 217, 0.20 * 255), tocolor(193, 159, 114, 255), tocolor(255, 255, 255, 255), 100)
            slidebar.create("opacidade>mira", 1123, 392, 166, 5, 19, 12, "assets/images/slide-bar-bg.png", "assets/images/circle.png", tocolor(217, 217, 217, 0.20 * 255), tocolor(193, 159, 114, 255), tocolor(255, 255, 255, 255), 255)

            local tamanhoMira = slidebar.getValue("tamanho>mira")
            local opacidadeMira = slidebar.getValue("opacidade>mira")

            local size = 54 / 100 * tamanhoMira
            local posX = 1090 + 350 / 2 - size / 2
            local posY = 305 + 115 / 2 - size / 2
     
            dxDrawText(tamanhoMira.."%", 1258, 317, 31, 23, tocolor(187, 187, 187, 255), 1, exports['guetto_assets']:dxCreateFont("light", 14), "left", "top")
            dxDrawText(opacidadeMira.."%", 1258, 363, 31, 23, tocolor(187, 187, 187, 255), 1, exports['guetto_assets']:dxCreateFont("light", 14), "left", "top")

            dxDrawImage(posX + 54*2, posY, size, size, data[1], 0, 0, 0, tocolor(r, g, b, opacidadeMira))
        end
    end
    
    local linha = 0;
    for index, value in ipairs(config["settings"]) do 
        if (index > proxPag and linha < 6) then
            linha = linha + 1

            local py = 332 +(( 74 + 4) * (linha-1) )

            dxDrawImage(472, py, 586, 74, "assets/images/select.png", 0, 0, 0, tocolor(255, 255, 255, fade))
            dxDrawText(value.title, 488, py + 18, 177, 15, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('medium', 15), 'left', 'top')
            dxDrawText(value.description, 488, py + 37, 177, 15, tocolor(187, 187, 187, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'left', 'top')

            if value.type == "checkbox" then 

                if not cache[value.title] then 
                    cache[value.title] = false;
                end

                dxDrawImage(964, py + 23, 72, 27, "assets/images/checkbox-bg.png", 0, 0, 0, cache[value.title] and tocolor(193, 159, 114, 255) or tocolor(22, 22, 22, 255), true)
                
                if cache[value.title] then 
                    dxDrawImage(1001, py + 26, 30, 19, "assets/images/checkbox-rectangle.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
                else
                    dxDrawImage(969, py + 26, 30, 19, "assets/images/checkbox-rectangle.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
                end
                
            elseif value.type == "slidebar" then 

                if not cache[value.title] then 
                    cache[value.title] = {
                        value = 50,
                        percent = 50,
                    };
                end

                if cache[value.title] then 

                    local circleX = 865 + cache[value.title].value - 19 / 2
    
                    dxDrawImage ( 865, py + 47, 166, 5, "assets/images/slide-bar-bg.png", 0, 0, 0, tocolor(255, 255, 255, 0.20 * 255), true);
                    dxDrawImage ( 865, py + 47, cache[value.title].value, 5, "assets/images/slide-bar-bg.png", 0, 0, 0, tocolor(193, 159, 114, 255), true);
                    dxDrawImage ( circleX, py + 44, 19, 12, "assets/images/circle.png", 0, 0, 0, tocolor(255, 255, 255, 255), true);
    
                    dxDrawText(math.floor(cache[value.title].percent).."%", 1000, py + 17, 31, 23, tocolor(187, 187, 187, 255), 1, exports['guetto_assets']:dxCreateFont("light", 14), "left", "top")
                end

            end

            if interface.slidebarIsMove == value.title then 
                local cx, cy = getCursorPosition ( )
                local tx, ty = cx * 1920, cy * 1080
                cache[value.title].value = math.min(math.max(tx - 865, 0), 166)
                cache[value.title].percent = math.floor((cache[value.title].value / 166 * 100))
            end

        end
    end

    for index, value in ipairs(interface.miras) do 
        local data = config["miras"][index + interface.miraPage]
        if data then 
            dxDrawImage(value[1], value[2], value[3], value[4], data[1], 0, 0, 0, interface.miraSelect == index + interface.miraPage and tocolor(129, 237, 1, 255) or isCursorOnElement(value[1], value[2], value[3], value[4]) and tocolor(129, 237, 1, 255) or tocolor(255, 255, 255, 255))
        end
    end

    dxDrawImage(1106, 758, 350, 52, "assets/images/button-apply-mira.png", 0, 0, 0, isCursorOnElement(1106, 758, 350, 52) and tocolor(193, 159, 114, 255) or tocolor(22, 22, 22, 255))
    dxDrawText("APLICAR", 1106, 762, 350, 52, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("medium", 20), "center", "center")
end;

addEventHandler("onClientClick", root, function ( button, state )
    if interface.state then 
        if button == "left" and state == "down" then 
            if isCursorOnElement(1106, 428, 44, 40) then 
                if interface.miraPage > 0 then 
                    interface.miraPage = interface.miraPage - 1
                end
            elseif isCursorOnElement(1412, 428, 44, 40) then 
                if interface.miraPage + 7 < #config["miras"] then 
                    interface.miraPage = interface.miraPage + 1
                end
            end
            local linha = 0;
            for index, value in ipairs(config["settings"]) do 
                if (index > proxPag and linha < 6) then
                    linha = linha + 1
                    local py = 332 +(( 74 + 4) * (linha-1) )
                    if value.type == "checkbox" then 
    
                        if cache[value.title] then 
    
                            if isCursorOnElement(1001, py + 26, 30, 19) then 
                                cache[value.title] = false
                                GuettoExecuteAction(value.title, cache[value.title] )
                            end
    
                        else
    
                            if isCursorOnElement(969, py + 26, 30, 19) then 
                                cache[value.title] = true
                                GuettoExecuteAction(value.title, cache[value.title] )
                            end
    
                        end
                        
                    elseif value.type == "slidebar" then 
                        local circleX = 865 + cache[value.title].value - 19 / 2
                        if isCursorOnElement(circleX, py + 44, 19, 12) then 
                            if not interface.slidebarIsMove then 
                                interface.slidebarIsMove = value.title 
                            end
                        end
                    end
                end
            end
            for index, value in ipairs(interface.miras) do 
                local data = config["miras"][index + interface.miraPage]
                if data then 
                    if isCursorOnElement(value[1], value[2], value[3], value[4]) then 
                        interface.miraSelect = index + interface.miraPage 
                        break
                    end
                end
            end
    
            if isCursorOnElement(1106, 758, 350, 52) then 
                local r, g, b = colorpicker.getColor("color>picker:1", 1)
                interface.dados.mira.index = interface.miraSelect
                interface.dados.mira.tamanho = 54 / 100 * slidebar.getValue("tamanho>mira")
                interface.dados.mira.cor = {r, g, b}
                interface.dados.mira.opacidade = slidebar.getValue("opacidade>mira")
                setPlayerAim()
                config.sendMessageClient("Dados da mira aplicados com sucesso!", "info")
                triggerServerEvent("Anti>Lag>Apply>Modifications", resourceRoot, interface.dados)
            end
    
        elseif button == "left" and state == "up" then 
            if interface.slidebarIsMove then 
                if interface.slidebarIsMove == "Limitar FPS" then
                    local fps = math.floor(cache[interface.slidebarIsMove].percent)      
                    
                    GuettoExecuteAction(interface.slidebarIsMove, fps < 25 and 25 or fps)
    
                elseif interface.slidebarIsMove == "Renderização do mapa" then
                    
                    GuettoExecuteAction(interface.slidebarIsMove, math.floor(cache[interface.slidebarIsMove].percent) )
    
                elseif interface.slidebarIsMove == "Tamanho do sol/lua" then 
    
                    GuettoExecuteAction(interface.slidebarIsMove, math.floor(cache[interface.slidebarIsMove].percent) )
                end
    
                interface.slidebarIsMove = false
            end
        end
    end
end)

function interfaceOpen ( )
    if not interface.state then 
        interface.state = true 
        interface.slidebarIsMove = false;
        showCursor(true)
        slidebar.showning("opacidade>mira", true)
        slidebar.showning("tamanho>mira", true)
        colorpicker.create( "color>picker:1", 1122, 539, 318, 150, 22, 22, "assets/images/pallet.png", "assets/images/pallet-circle.png" )
        colorpicker.showning("color>picker:1", true)
        addEventHandler("onClientRender", root, interfaceDraw)
    end
end;

function interfaceClose ( )
    if interface.state then 
        interface.state = false 
        showCursor(false)
        slidebar.showning("opacidade>mira", false)
        slidebar.showning("tamanho>mira", false)
        colorpicker.showning("color>picker:1", false)
        removeEventHandler("onClientRender", root, interfaceDraw)
    end
end

bindKey(config["others"].key, "down", function ( )
    if not interface.state then 
        interfaceOpen ( )
    else
        interfaceClose()
    end
end)

function interfaceKey (button, press)
    if (button == 'mouse_wheel_down' and press) then
        proxPag = proxPag + 1
        if (proxPag > (#config["settings"] - 6)) then
            proxPag = (#config["settings"] - 6)
        end
    elseif (button == 'mouse_wheel_up' and press) then
        if (proxPag > 0) then
            proxPag = proxPag - 1
        end
    end
end

function getConfigFromTitle  ( title )
    for i, v in ipairs(config["settings"]) do 
        if v.title == title then 
            return v 
        end
    end
    return false;
end

function reciveInfos ( dados )
    interface.dados = dados

    for i, v in pairs(interface.dados.data) do 
        local config_cache = getConfigFromTitle ( i )

        if config_cache then 
            if config_cache.type == "slidebar" then 
                cache[i] = {
                    value = 166 / 100 * tonumber(v),
                    percent = tonumber(v),
                };
            elseif config_cache.type == "checkbox" then 
                cache[i] = v
            end
        end

        GuettoExecuteAction(i, type(v) == "number" and tonumber(v) or v)
    end

    setPlayerAim()
end


-- \\ Event´s //

addEventHandler("onClientKey", root, interfaceKey)
registerEventHandler("Send>Anti>Lag>Infos", resourceRoot, reciveInfos)

function tblSize ( t )
    local c = 0;

    for i, v in pairs ( t ) do 
        c = c + 1
    end

    return c
end

local Shader;
local Texture;


function setPlayerAim ( )
    if ( interface.dados or interface.dados.mira ) then 
        
        Texture = config["miras"][interface.dados.mira.index][1]
        Shader = dxCreateShader("assets/shader/texreplace.fx")
        
        local textureWidth, textureHeight = interface.dados.mira.tamanho, interface.dados.mira.tamanho
        local tempRenderTarget = dxCreateRenderTarget(textureWidth/2, textureHeight/2, true)
        
        addEventHandler("onClientRender", root, function ()
            
            dxSetRenderTarget(tempRenderTarget, true)
            dxDrawImage(0, 0, textureWidth, textureHeight, Texture, 0, 0, 0, tocolor(interface.dados.mira.cor[1], interface.dados.mira.cor[2], interface.dados.mira.cor[3], interface.dados.mira.opacidade))
            dxSetRenderTarget()
        
            engineApplyShaderToWorldTexture(Shader, "siteM16")
            dxSetShaderValue(Shader, "gTexture", tempRenderTarget)
            setPlayerHudComponentVisible("crosshair", true)
        end)
    end
end