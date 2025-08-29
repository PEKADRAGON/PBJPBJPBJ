local assets = exports['guetto_assets']

local windows = {
    {827, 733, 36, 36, 'destrancar', 'assets/images/door.png'};
    {890, 737, 34, 28, 'adicionar', 'assets/images/adicionar.png'};
    {951, 737, 28, 28, 'entrar', 'assets/images/entrar.png'};
    {1006, 737, 28, 28, 'vender', 'assets/images/vender.png'};
    {1061, 735, 32, 32, 'iptu', 'assets/images/iptu.png'};
}

local alpha = {}
local isEventHandlerAdded = false 

function draw ( )
    local fade = interpolateBetween (alpha[1], 0, 0, alpha[2], 0, 0, (getTickCount() - alpha[3]) / 400, 'Linear')
 
    if house_dados then 
        if (house_dados.free == 'false' or house_dados.free == '1') then 
            dxDrawRoundedRectangle(802, 712, 317, 164, tocolor(18, 18, 18, fade), 8)

            for i, v in ipairs (windows) do 
                dxDrawImage(v[1], v[2], v[3], v[4], v[6], 0, 0, 0, select_window == v[5] and tocolor(193, 159, 114, fade) or isCursorOnElement(v[1], v[2], v[3], v[4]) and tocolor(193, 159, 114, fade) or tocolor(171, 171, 171, fade))
                
                if isCursorOnElement(v[1], v[2], v[3], v[4]) then 
                    dxDrawImage(v[1] - 131 / 2 + v[3] / 2, v[2] - 36 - 10, 131, 43, 'assets/images/pop-up.png', 0, 0, 0, tocolor(49, 49, 49, fade))
                  
                    if (v[5] == 'destrancar') then 
                        if house_dados.state == "locked" then
                            dxDrawText(string.upper('destrancar'), v[1] - 131 / 2 + v[3] / 2, v[2] - 36 - 12, 131, 43, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'center', 'center')
                        elseif house_dados.state == 'open' then 
                            dxDrawText(string.upper("trancar"), v[1] - 131 / 2 + v[3] / 2, v[2] - 36 - 12, 131, 43, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'center', 'center')
                        end
                    else
                        dxDrawText(string.upper(v[5]), v[1] - 131 / 2 + v[3] / 2, v[2] - 36 - 12, 131, 43, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'center', 'center')
                    end
                end
        
            end
        
            dxDrawRectangle(802, 794, 317, 1, tocolor(255, 255, 255, 0.12 * fade))
            dxDrawImage(827, 812, 42, 42, 'assets/images/icon-house.png', 0, 0, 0, tocolor(175, 175, 175, fade))
        
            if house_dados then 
                dxDrawText(house_dados.model, 894, 810, 63, 23, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('medium', 15), 'left', 'center')
                dxDrawText(house_dados.accountName, 1020, 833, 63, 23, tocolor(193, 159, 114, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'left', 'center')
            end
        
            if (sub_window == "iptu") then 
                dxDrawRoundedRectangle(802, 557, 317, 147, tocolor(18, 18, 18, fade), 8)
                dxDrawText('Pagamento de IPTU', 827, 575, 123, 23, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'left', 'center')
                dxDrawText('Para você continuar a ter acesso a casa\nvocê precisa pagar a taxa para o governo.', 827, 600, 260, 46, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 13), 'left', 'center', false, false, false, true)
                dxDrawText("$ "..(formatNumber(tonumber(house_dados.price * 0.5), '.')), 895, 653, 131, 31, tocolor(30, 161, 111, fade), 1, exports['guetto_assets']:dxCreateFont('medium', 19), 'center', 'center')
                dxDrawText("Aperte [ENTER] para confirmar", 837, 884, 245, 23, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'center', 'center')
            end

            dxDrawText('Propriedade de:', 894, 833, 63, 23, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('medium', 15), 'left', 'center')
        
            if (select_window == "adicionar") then 
                dxDrawEditbox(827, 661, 278, 28, 20, "ID")
           
                dxDrawRoundedRectangle(802, 618, 317, 86, tocolor(18, 18, 18, fade), 8)
                dxDrawText('Adicionar/remover', 827, 629, 126, 23, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'left', 'center')
           
                if isBoxActive("ID") then 
                    dxDrawText(getEditboxText("ID").."|", 827, 661, 15, 19, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 15), "left", "center")
                else
                    dxDrawText((#getEditboxText("ID") ~= 0) and getEditboxText("ID") or "ID", 827, 661, 15, 19, tocolor(94, 94, 94, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 15), "left", "center")
                end
        
                dxDrawText("Aperte [ENTER] para confirmar", 837, 884, 245, 23, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'center', 'center')

            elseif (select_window == "vender") then 
                
                dxDrawRoundedRectangle(802, 641, 317, 63, tocolor(18, 18, 18, fade), 8)
                dxDrawText("JOGADORES", 839, 661, 87, 63, isCursorOnElement(839, 661, 87, 63) and tocolor(193, 159, 114, fade) or tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'left', 'top')
                dxDrawText("GOVERNO", 1003, 661, 87, 63, isCursorOnElement(1003, 661, 87, 63) and tocolor(193, 159, 114, fade) or tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'left', 'top')

                if (sub_window == "player") then 

                    dxDrawEditbox(890, 614, 49, 23, 20, "ID")
                    dxDrawEditbox(827, 654, 87, 63, 20, "VALOR")

                    dxDrawRoundedRectangle(802, 557, 317, 147, tocolor(18, 18, 18, fade), 8)

                    dxDrawText("ID/RG:", 827, 615, 87, 63, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'left', 'top')
                    dxDrawText("VALOR:", 827, 654, 87, 63, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'left', 'top')
                    dxDrawText("Vender para jogadores.", 827, 575, 153, 23, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'left', 'top')
    
                    if isBoxActive("ID") then 
                        dxDrawText(getEditboxText("ID").."|", 890, 615, 49, 23, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 15), "left", "center")
                    else
                        dxDrawText((#getEditboxText("ID") ~= 0) and getEditboxText("ID") or "#0000", 890, 615, 49, 23, tocolor(94, 94, 94, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 15), "left", "center")
                    end

                    if isBoxActive("VALOR") then 
                        dxDrawText(getEditboxText("VALOR").."|", 890, 655, 49, 23, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 15), "left", "center")
                    else
                        dxDrawText((#getEditboxText("VALOR") ~= 0) and getEditboxText("VALOR") or "$", 890, 655, 49, 23, tocolor(94, 94, 94, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 15), "left", "center")
                    end

                    dxDrawText("Aperte [ENTER] para confirmar", 837, 884, 245, 23, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'center', 'center')

                elseif (sub_window == "gov") then 
                    dxDrawRoundedRectangle(802, 557, 317, 147, tocolor(18, 18, 18, fade), 8)
                    dxDrawText('Vender para o governo', 827, 575, 123, 23, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'left', 'center')
                    dxDrawText('O Valor desta casa é de #1EA16F$ '..(formatNumber(tonumber(house_dados.price * 0.5), '.'))..', \n#FFFFFFVocê receberá 50% do valor.', 827, 618, 260, 46, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 14), 'left', 'center', false, false, false, true)
                    dxDrawText("Aperte [ENTER] para confirmar", 837, 884, 245, 23, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'center', 'center')
                end
            end

        elseif (house_dados.free == 'true') then 
            
            dxDrawRoundedRectangle(802, 712, 317, 164, tocolor(18, 18, 18, fade), 8)
            dxDrawRoundedRectangle(802, 557, 317, 147, tocolor(18, 18, 18, fade), 8)
            dxDrawImage(827, 740, 42, 42, 'assets/images/icon-house.png', 0, 0, 0, tocolor(175, 175, 175, fade))
    
            if house_dados then 
                dxDrawText(house_dados.model, 894, 741, 63, 23, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('medium', 15), 'left', 'center')
            end
    
            dxDrawText('Propriedade de:', 894, 761, 105, 23, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('medium', 15), 'left', 'center')
            dxDrawText('Disponível', 1020, 761, 70, 23, tocolor(124, 159, 114, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'left', 'center')
            dxDrawText('COMPRAR CASA', 904, 822, 112, 23, isCursorOnElement(904, 822, 112, 23) and tocolor(193, 159, 114, fade) or tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'left', 'center')
       
            dxDrawText('Informações.', 827, 575, 86, 23, tocolor(255, 255, 255, fade) or tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'left', 'center')
            dxDrawText('#FFFFFFO Valor desta casa é de #1EA16F$ '..(formatNumber(tonumber(house_dados.price), '.'))..',\n#FFFFFFVocê poderá compra-la agora mesmo..', 827, 605, 260, 23, tocolor(255, 255, 255, fade) or tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 13), 'left', 'top', false, false, false, true)
            dxDrawText('Obs: ', 827, 663, 253, 19, tocolor(235, 73, 73, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 14), 'left', 'top', false, false, false, true)
        end 

    end
    
end

addEventHandler('onClientClick', root,
    function (button, state)
        if button == 'left' and state == 'down' then 
            if isEventHandlerAdded then 
                if (house_dados.free == 'false') then 
                    for i, v in ipairs (windows) do 
                        if isCursorOnElement(v[1], v[2], v[3], v[4]) then 
                            if v[5] == 'entrar' then 
                                local res_element = getResourceDynamicElementRoot(getResourceFromName('guetto_house'))
                                triggerServerEvent("onPlayerEnterHouse", res_element, house_dados)
                                toggle(false)
                            elseif v[5] == "destrancar" then 
                                local res_element = getResourceDynamicElementRoot(getResourceFromName('guetto_house'))
                                triggerServerEvent("onPlayerUnlockedHouse", res_element, house_dados)
                            elseif v[5] == "iptu" then 
                                sub_window = "iptu"
                            end
                            select_window = v[5]
                            break
                        end 
                    end
                    if select_window == 'vender' then 
                        if isCursorOnElement(839, 661, 87, 63) then 
                            sub_window = "player"
                        elseif isCursorOnElement(1003, 661, 87, 63) then 
                            sub_window = "gov"
                        end
                    end
                elseif (house_dados.free == 'true') then 
                    if isCursorOnElement(904, 822, 112, 23) then 
                        local res_element = getResourceDynamicElementRoot(getResourceFromName('guetto_house'))
                        triggerServerEvent("onPlayerBuyHouse", res_element, house_dados)
                        toggle(false)
                    end
                end
            end
        end
    end
)

function toggle(state)
    if state and not isEventHandlerAdded then 
        isEventHandlerAdded = true 
        select_window = false
        sub_window = false
        alpha = {0, 255, getTickCount()}
        showCursor(true)
        addEventHandler("onClientRender", root, draw)
    elseif not state and isEventHandlerAdded then 
        isEventHandlerAdded = false
        alpha = {255, 0, getTickCount()}
        showCursor(false)
        setTimer(function()
            removeEventHandler("onClientRender", root, draw)
        end, 400, 1)
    end
end

addEvent("onPlayerHouseToggle", true)
addEventHandler("onPlayerHouseToggle", resourceRoot,
    function ( state, _house )
        if state then 
            house_dados = _house 
            toggle(true)
        else
            toggle(false)
            house_dados = nil
        end
    end
)

bindKey("backspace", "down",
    function ()
        toggle(false)
    end
)

local oferter = {
    isEventHandlerAdded = false,
    dados = false,
    alpha = {},
    value = false,
}

function drawOferter ( )
    local alpha = interpolateBetween(oferter.alpha[1], 0, 0, oferter.alpha[2], 0, 0, (getTickCount() - oferter.alpha[3]) / 400, 'Linear')
    
    dxDrawRoundedRectangle(782, 417, 355, 245, tocolor(18, 18, 18, alpha), 8)
    
    dxDrawText("Oferta de residência", 893, 435, 134, 23, tocolor(255, 255, 255, alpha), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'left', 'top')
    
    local target = getElementData(localPlayer, "reciver_oferter") or false;
    
    dxDrawText("O jogador "..(target and removeHex(getPlayerName(target)..'#'..(getElementData(target, 'ID') or 'N/A')) or 'N/A').." quer te vender\numa Mansão 1 pelo valor abaixo:", 827, 476, 265, 46, tocolor(255, 255, 255, alpha), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'center', 'center')

    if oferter.value then 
        dxDrawText('$ '..formatNumber(oferter.value, '.'), 880, 540, 160, 36, tocolor(30, 161, 111, alpha), 1, exports['guetto_assets']:dxCreateFont('medium', 22), 'center', 'center')
    end

    dxDrawText('ACEITAR', 882, 612, 59, 23, isCursorOnElement(882, 612, 59, 23) and tocolor(193, 159, 114, alpha) or tocolor(255, 255, 255, alpha), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'center', 'center')
    dxDrawText('RECUSAR', 970, 612, 67, 23, isCursorOnElement(970, 612, 67, 23) and tocolor(193, 159, 114, alpha) or tocolor(255, 255, 255, alpha), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'center', 'center')
end

addEventHandler('onClientClick', root,
    function(button, state)
        if button == 'left' and state == 'down' then 
            if oferter.isEventHandlerAdded then 
                if isCursorOnElement(882, 612, 59, 23) then 
                    local res_element = getResourceDynamicElementRoot(getResourceFromName('guetto_house'))
                    triggerServerEvent("onPlayerAcceptOferter", res_element, oferter.dados, oferter.value)
                elseif isCursorOnElement(970, 612, 67, 23) then
                    local res_element = getResourceDynamicElementRoot(getResourceFromName('guetto_house'))
                    triggerServerEvent("onPlayerRefuseOferter", res_element)
                    toggleOferter(false)
                end
            end
        end
    end
)

function toggleOferter (state)
    if state and not oferter.isEventHandlerAdded then 
        oferter.isEventHandlerAdded = true
        oferter.alpha = {0, 255, getTickCount()}
        showCursor(true)
        addEventHandler('onClientRender', root, drawOferter)
    elseif not state and oferter.isEventHandlerAdded then 
        oferter.isEventHandlerAdded = false 
        oferter.alpha = {255, 0, getTickCount()}
        showCursor(false)
        setTimer(function()
            removeEventHandler('onClientRender', root, drawOferter)
        end, 400, 1)
    end
end

addEvent("onPlayerOferterToggle", true)
addEventHandler("onPlayerOferterToggle", resourceRoot,
    function (state, dados, valor)
        if state then 
            toggleOferter(true)
        else
            toggleOferter(false)
        end
        oferter.value = valor
        oferter.dados = dados
    end
)

bindKey("enter", "down",
    function ( )
        if isEventHandlerAdded then 
            if select_window and select_window == "adicionar" then 
                if #getEditboxText("ID") == 0 or getEditboxText("ID") == "ID" or getEditboxText("ID") == "" then 
                    return config.sendMessageClient("Digite o id do jogador!", "error")
                end
                local res_element = getResourceDynamicElementRoot(getResourceFromName('guetto_house'))
                triggerServerEvent("setPlayerOwnerHouse", res_element, house_dados, getEditboxText("ID"))
            elseif sub_window and sub_window == "gov" then 
                if spam and getTickCount ( ) - spam <= 1000 then return end 
                local res_element = getResourceDynamicElementRoot(getResourceFromName('guetto_house'))
                triggerServerEvent("onPlayerHouseSellingGov", res_element, house_dados)
                toggle(false)
                spam = getTickCount()
            elseif sub_window and sub_window == "iptu" then 
                if spam and getTickCount ( ) - spam <= 1000 then return end 
                local res_element = getResourceDynamicElementRoot(getResourceFromName('guetto_house'))
                triggerServerEvent("onPlayerHousePayIPTU", res_element, house_dados)
                toggle(false)
                spam = getTickCount()
            elseif select_window and select_window == "vender" and sub_window == "player" then 
                local id = getEditboxText("ID");
                local valor = getEditboxText("VALOR");
                local res_element = getResourceDynamicElementRoot(getResourceFromName('guetto_house'))
                if #id == 0 or id == 'ID' or id == '' then return config.sendMessageClient("Digite o id do jogador!", "error") end 
                if #valor == 0 or valor == 'VALOR' or id == '' then return config.sendMessageClient("Digite o valor da residência!", "error") end 
                triggerServerEvent("onPlayerHouseSellingPlayer", res_element, id, valor, house_dados)
                toggleOferter(false)
            end
        end
    end
)

addEvent("updateClientInfos", true)
addEventHandler("updateClientInfos", resourceRoot,
    function ( infos )
        house_dados = infos;
    end
)