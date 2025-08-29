local resource = {transition = {0, 0, getTickCount()}, state = false}
local alpha = 0

local function onDraw ()
    local transition = interpolateBetween(resource.transition[1], 0, 0, resource.transition[2], 0, 0, (getTickCount ( ) - resource.transition[3]) / 200, "Linear")
    
    alpha = math.min(alpha + 5, 255)

    dxDrawImage(0, 0, 1920, 1080, "assets/images/background.png", 0, 0, 0, tocolor(255, 255, 255, alpha))

    if (resource.window == "index") then 
        
        dxDrawRoundedRectangle(60, 24, 72, 72, 50, tocolor(193, 159, 114, alpha))
        dxDrawImage(63, 27, 66, 66, "assets/avatars/"..(getElementData(localPlayer, 'Avatar') or 0)..".png", 0, 0, 0, tocolor(255, 255, 255, alpha))

        dxDrawText("Guetto pontos", 152, 35, 109, 23, tocolor(255, 255, 255, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 13))
        dxDrawText("GP "..convertNumber((getElementData(localPlayer, config.datas.coins) or 0)), 152, 60, 109, 23, tocolor(139, 139, 139, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 11))

        dxDrawImageSpacing(60, 219, 54, 52, 5, "assets/images/gun.png", 0, 0, 0, tocolor(255, 255, 255, alpha))

        dxDrawText("Contas", 138, 218, 73, 30, tocolor(255, 255, 255, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 15))
        dxDrawText("Escolha sua conta para jogar.", 138, 249, 73, 30, tocolor(210, 210, 210, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 13))

        dxDrawText("Em nossa cidade, empregamos os recursos adquiridos pelos jogadores para aprimorar tanto a experiência de jogo quanto o ambiente virtual. É fundamental\nsalientar que a conta é propriedade da nossa administração, e é estritamente proibida qualquer forma de venda externa ou extorno de valores.", 60, 940, 1181, 68, tocolor(160, 160, 160, alpha), 1.0, exports['guetto_assets']:dxCreateFont("light", 11))
        dxDrawText("Todos os direitos reservados. © 2020 - 2024. Multijogador Guetto Group.", 60, 1010, 1181, 68, tocolor(160, 160, 160, alpha), 1.0, exports['guetto_assets']:dxCreateFont("bold", 11))

        local line = 0 
        for i = 1, config.others.max_characters do 
            if (i > resource.actualPage and line < 5) then 
                line = line + 1

                local count = (306 + (388 - 306) * line - (388 - 306))

                if isCursorOnElement(60, count, 340, 79) or resource.select == i then 
                    dxDrawImageSpacing(60, count, 340, 79, 5, "assets/images/bg_person-select.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
                else
                    dxDrawImageSpacing(60, count, 340, 79, 5, "assets/images/bg_person.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
                end

                if (resource.dados and resource.dados[i]) then 
                    local v = resource.dados[i]

                    dxDrawImageSpacing(77, count+16, 46, 46, 5, "assets/images/user.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
                    dxDrawText(v.name, 146, count+17, 186, 23, tocolor(255, 255, 255, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 11))
                    dxDrawText(""..math.floor(v.hours_played).." Horas jogadas", 146, count+38, 186, 23, tocolor(193, 159, 114, alpha), 1.0, exports['guetto_assets']:dxCreateFont("bold", 11))
                    dxDrawImageSpacing(422, count+21, 28, 28, 5, "assets/images/trash.png", 0, 0, 0, (isCursorOnElement(422, count+21, 28, 28) and tocolor(193, 159, 114, alpha) or tocolor(255, 255, 255, alpha)))
                else
                    dxDrawImageSpacing(77, count+16, 46, 46, 5, "assets/images/user-create.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
                    dxDrawText("Criação de personagem", 146, count+17, 186, 23, tocolor(255, 255, 255, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 11))
                    dxDrawText(config.others.price_characters[i] == 0 and "Grátis" or "GP "..convertNumber(config.others.price_characters[i]), 146, count+38, 186, 23, tocolor(139, 139, 139, alpha), 1.0, exports['guetto_assets']:dxCreateFont("bold", 11))
                end

                dxDrawRoundedRectangle(60, 737, 339, 73, 8, (isCursorOnElement(60, 737, 339, 73) and tocolor(193, 159, 114, alpha) or tocolor(33, 33, 33, alpha)))
                dxDrawText("CONTINUAR", 60, 737, 339, 73, tocolor(255, 255, 255, alpha), 1.0, exports['guetto_assets']:dxCreateFont("regular", 14), "center", "center")
            end 
        end
    
    elseif (resource.window == "createCharacter") then
        
        dxDrawText("Em nossa cidade, empregamos os recursos adquiridos pelos jogadores para aprimorar tanto a experiência de jogo quanto o ambiente virtual. É fundamental\nsalientar que a conta é propriedade da nossa administração, e é estritamente proibida qualquer forma de venda externa ou extorno de valores.", 60, 940, 1181, 68, tocolor(160, 160, 160, alpha), 1.0, exports['guetto_assets']:dxCreateFont("light", 11))
        dxDrawText("Todos os direitos reservados. © 2020 - 2024. Multijogador Guetto Group.", 60, 1010, 1181, 68, tocolor(160, 160, 160, alpha), 1.0, exports['guetto_assets']:dxCreateFont("bold", 11))

        dxDrawRoundedRectangle(195, 177, 70, 70, 50, tocolor(255, 255, 255, alpha))
        dxDrawImage(198, 180, 64, 64, fileExists("assets/avatars/"..(resource.avatar_select)..".png") and "assets/avatars/"..(resource.avatar_select)..".png", 0, 0, 0, tocolor(255, 255, 255, alpha))
        dxDrawImageSpacing(310, 200, 24, 24, 5, "assets/images/arrow.png", 0, 0, 0, (isCursorOnElement(310, 200, 24, 24) and tocolor(193, 159, 114, alpha) or tocolor(255, 255, 255, alpha)))
        dxDrawImageSpacing(128, 200, 24, 24, 5, "assets/images/arrow.png", 180, 0, 0, (isCursorOnElement(128, 200, 24, 24) and tocolor(193, 159, 114, alpha) or tocolor(255, 255, 255, alpha)))

        dxDrawText("Informações pessoais.", 60, 273, 215, 28, tocolor(255, 255, 255, alpha), 1.0, exports['guetto_assets']:dxCreateFont("regular", 15))

        dxDrawImageSpacing(60, 330, 339, 66, 5, "assets/images/bg_infos.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
        dxDrawImageSpacing(60, 405, 339, 66, 5, "assets/images/bg_infos.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
        dxDrawImageSpacing(60, 480, 339, 66, 5, "assets/images/bg_infos.png", 0, 0, 0, tocolor(255, 255, 255, alpha))

        dxDrawEditbox("editbox:name", "Nome", 60, 330, 339, 66, {focus = tocolor(255, 255, 255, 255), normal = tocolor(255, 255, 255, 255/2), background = tocolor(0, 0, 0, 0)}, {"center", "center"}, exports['guetto_assets']:dxCreateFont("regular", 14), {block = false, number = false, max_characters = 20, password = false})
        dxDrawEditbox("editbox:surname", "Sobrenome", 60, 405, 339, 66, {focus = tocolor(255, 255, 255, 255), normal = tocolor(255, 255, 255, 255/2), background = tocolor(0, 0, 0, 0)}, {"center", "center"}, exports['guetto_assets']:dxCreateFont("regular", 14), {block = false, number = false, max_characters = 20, password = false})
        dxDrawEditbox("editbox:age", "Idade", 60, 480, 339, 66, {focus = tocolor(255, 255, 255, 255), normal = tocolor(255, 255, 255, 255/2), background = tocolor(0, 0, 0, 0)}, {"center", "center"}, exports['guetto_assets']:dxCreateFont("regular", 14), {block = false, number = true, max_characters = 2, password = false})

        dxDrawText("Selecione a cidade.", 60, 555, 215, 28, tocolor(255, 255, 255, alpha), 1.0, exports['guetto_assets']:dxCreateFont("regular", 15))

        dxDrawImageSpacing(60, 602, 339, 66, 5, "assets/images/bg_infos.png", 0, 0, 0, tocolor(255, 255, 255, alpha))

        dxDrawImageSpacing(87, 622, 24, 24, 5, "assets/images/arrow.png", 180, 0, 0, (isCursorOnElement(87, 622, 24, 24) and tocolor(193, 159, 114, alpha) or tocolor(255, 255, 255, alpha)))
        dxDrawImageSpacing(345, 622, 24, 24, 5, "assets/images/arrow.png", 0, 0, 0, (isCursorOnElement(345, 622, 24, 24) and tocolor(193, 159, 114, alpha) or tocolor(255, 255, 255, alpha)))
        dxDrawText(config.panel.citys[resource.currentIndexCity][1], 60, 602, 339, 66, tocolor(255, 255, 255, alpha), 1.0, exports['guetto_assets']:dxCreateFont("regular", 13), "center", "center")

        dxDrawText("Selecione o gênero.", 60, 682, 215, 28, tocolor(255, 255, 255, alpha), 1.0, exports['guetto_assets']:dxCreateFont("regular", 15))

        dxDrawImageSpacing(60, 729, 339, 66, 5, "assets/images/bg_infos.png", 0, 0, 0, tocolor(255, 255, 255, alpha))

        dxDrawImageSpacing(87, 750, 24, 24, 5, "assets/images/arrow.png", 180, 0, 0, (isCursorOnElement(87, 750, 24, 24) and tocolor(193, 159, 114, alpha) or tocolor(255, 255, 255, alpha)))
        dxDrawImageSpacing(345, 750, 24, 24, 5, "assets/images/arrow.png", 0, 0, 0, (isCursorOnElement(345, 750, 24, 24) and tocolor(193, 159, 114, alpha) or tocolor(255, 255, 255, alpha)))

        dxDrawText(config.panel.genres[resource.currentIndexGenre][1], 60, 729, 339, 66, tocolor(255, 255, 255, alpha), 1.0, exports['guetto_assets']:dxCreateFont("regular", 13), "center", "center")

        dxDrawRoundedRectangle(60, 830, 339, 73, 8, (isCursorOnElement(60, 830, 339, 73) and tocolor(193, 159, 114, alpha) or tocolor(33, 33, 33, alpha)))
        dxDrawText("CONFIRMAR", 60, 830, 339, 73, tocolor(255, 255, 255, alpha), 1.0, exports['guetto_assets']:dxCreateFont("regular", 14), "center", "center")
    end

    dxDrawRectangle(0, 0, 1920, 1080, tocolor(0, 0, 0, transition))
end

local function charactersClose ()
	if (resource.state) then 

        setTimer(function()

            showCursor(false)
            showChat(true)

            removeEventHandler("onClientRender", root, onDraw)
            setElementData(localPlayer, "BloqHud", false)

            dxEditboxDestroy ("all")

            resource.state = nil 

            setCameraTarget(localPlayer)

            if ped and isElement(ped) then
                destroyElement(ped)
            end

            resource.window = nil 
            resource.actualPage = nil
        end, 250, 1)
    end
end

local function charactersOpen (dados, hours_played)
	if not (resource.state) then 
        
		showCursor(true)
        showChat(false)

        resource.state = true 
		resource.actualPage = 0
        resource.dados = dados
        resource.hours_played = hours_played

        resource.window = "index"
		resource.select = 0

        resource.avatar_select = 0
        resource.currentIndexCity = 1
        resource.currentIndexGenre = 1

        cursorY = 401

        setCameraMatrix(unpack(config.others.camera_matrix))
        ped = createPed(0, config.others.position[1], config.others.position[2], config.others.position[3], config.others.position[4])

        setElementData(localPlayer, "BloqHud", true)

		addEventHandler("onClientRender", root, onDraw)
	else 
		charactersClose()
	end
end

local function charactersOpen (dados, hours_played, clothes)
	if not (resource.state) then 

        local player_clothes = false 

        if not (clothes) then 
            player_clothes = 0
        else
            local data = clothes[1];

              player_clothes = {
                clothes = fromJSON(data.characters),
                genre = tonumber(data.gender),
                skinColor = tonumber(data.color)
            }
        end

		showCursor(true)
        showChat(false)

        resource.state = true 
		resource.actualPage = 0
        resource.dados = dados
        resource.hours_played = hours_played

        resource.window = "index"
		resource.select = 0

        resource.avatar_select = 0
        resource.currentIndexCity = 1
        resource.currentIndexGenre = 1

        cursorY = 401

        setCameraMatrix(unpack(config.others.camera_matrix))

        if (player_clothes == 0) then 
            ped = createPed(0, config.others.position[1], config.others.position[2], config.others.position[3])
        else
            ped = exports["guetto_custom"]:createCustomPed(config.others.position[1], config.others.position[2], config.others.position[3], 1000, player_clothes)
        end

        setElementData(localPlayer, "BloqHud", true)
		addEventHandler("onClientRender", root, onDraw)
	else 
		charactersClose()
	end
end

local function charactersReturn ()
    if (resource.state) then
        if (resource.window == "createCharacter") then
            if (getTickCount() - resource.transition[3]) <= 200 then 
                return
            end

            resource.transition[1] = 0
            resource.transition[2] = 255
            resource.transition[3] = getTickCount()

            setTimer(function()
                resource.transition[1] = 255
                resource.transition[2] = 0
                resource.transition[3] = getTickCount()

                resource.window = "index"

                resource.select = 0
                resource.avatar_select = 0
                resource.currentIndexCity = 1
                resource.currentIndexGenre = 1

                dxEditboxDestroy ("all")
            end, 200, 1)
        end
    end
end

local function updateSkin (type)
    if type == "Masculino" then 
        if ped and isElement(ped) then 
            destroyElement(ped)
            ped = createPed(0, config.others.position[1], config.others.position[2], config.others.position[3], config.others.position[4])
        end
    elseif type == "Feminino" then 
        if ped and isElement(ped) then 
            destroyElement(ped)
            ped = createPed(150, config.others.position[1], config.others.position[2], config.others.position[3], config.others.position[4])
        end
    end
end

local function onClientClick (button, state)
    if (resource.state) then 
        if (button == "left" and state == "down") then
            if (resource.window == "index") then 
                local line = 0 
                for i = 1, config.others.max_characters do 
                    if (i > resource.actualPage and line < 5) then 
                        line = line + 1

                        local count = (306 + (388 - 306) * line - (388 - 306))

                        if (resource.dados and resource.dados[i]) then 
                            local v = resource.dados[i]

                            if isCursorOnElement(60, count, 340, 79) then 
                                
                                if (resource.person_click) then 
                                    return sendMessage("client", "Vá com calma!", "info")
                                end

                                resource.select = i
                                resource.select_character = v

                                resource.person_click = true

                                triggerServerEvent("guetto.select.character", resourceRoot, resource.select, v)

                            elseif isCursorOnElement(422, count+21, 28, 28) then 
                                triggerServerEvent("guetto.onPlayerDeleteCharacter", resourceRoot, {select = i, id = v.ID})

                            end
                        else
                            if isCursorOnElement(60, count, 340, 79) then   
                                resource.select = i
                                resource.select_character = nil
                            end
                        end
                    end 
                end
            end

            if (resource.window == "index") then 
                if isCursorOnElement(60, 737, 339, 73) then
                    if (resource.select and resource.select ~= 0 and resource.select ~= nil) then
                        if resource.select_character then
                            triggerServerEvent("guetto.onPlayerSelectPlayCharacter", resourceRoot, {select = resource.select, user = resource.select_character.login, password = resource.select_character.password, name = resource.select_character.name, type = config.panel.genres[resource.currentIndexGenre][1]})
                            
                            charactersClose ()
                        else
                            local coins = getElementData(localPlayer, config.datas.coins) or 0 
                            if coins < config.others.price_characters[resource.select] then
                                sendMessage("client", localPlayer, "Seus GPs é insuficiente.", "error")
                                return
                            end

                            if (getTickCount() - resource.transition[3]) <= 200 then 
                                return
                            end

                            resource.transition[1] = 0
                            resource.transition[2] = 255
                            resource.transition[3] = getTickCount()

                            setTimer(function()
                                resource.transition[1] = 255
                                resource.transition[2] = 0
                                resource.transition[3] = getTickCount()
                                resource.indexCharacter = resource.select
                                resource.window = "createCharacter"
                            end, 200, 1)
                        end
                    else
                        sendMessage("client", localPlayer, "Você precisa selecionar um personagem.", "error")
                    end
                end
            end
            
            if (resource.window == "createCharacter") then
                if isCursorOnElement(310, 200, 24, 24) then 
                    if (resource.avatar_select < 118) then
                        resource.avatar_select = resource.avatar_select + 1
                    end
                elseif isCursorOnElement(128, 200, 24, 24) then 
                    if (resource.avatar_select > 0) then
                        resource.avatar_select = resource.avatar_select - 1
                    end
                elseif isCursorOnElement(87, 622, 24, 24) then 
                    resource.currentIndexCity = resource.currentIndexCity % #config.panel.citys + 1

                elseif isCursorOnElement(345, 622, 24, 24) then
                    resource.currentIndexCity = (resource.currentIndexCity - 2 + #config.panel.citys) % #config.panel.citys + 1

                elseif isCursorOnElement(87, 750, 24, 24) then 
                    resource.currentIndexGenre = resource.currentIndexGenre % #config.panel.genres + 1
                    updateSkin(config.panel.genres[resource.currentIndexGenre][1])
                        
                elseif isCursorOnElement(345, 750, 24, 24) then 
                    resource.currentIndexGenre = (resource.currentIndexGenre - 2 + #config.panel.genres) % #config.panel.genres + 1
                    updateSkin(config.panel.genres[resource.currentIndexGenre][1])

                elseif isCursorOnElement(60, 830, 339, 73) then 
                    local contents = {
                        name = dxEditboxGetText("editbox:name"),
                        surname = dxEditboxGetText("editbox:surname"),
                        age = dxEditboxGetText("editbox:age")
                    }

                    contents.fullName = contents.name.." "..contents.surname

                    if (contents.name ~= "" and contents.surname ~= "" and contents.age ~= "") then
                        triggerServerEvent("guetto.onPlayerCreateCharacter", resourceRoot, {name = contents.fullName, city = config.panel.citys[resource.currentIndexCity][1], gender = config.panel.genres[resource.currentIndexGenre][1], age = contents.age, avatar = resource.avatar_select, index = resource.indexCharacter})
                    else
                        sendMessage("client", localPlayer, "Preencha todos os campos.", "error")
                    end
                end
            end
        end
    end
end

local function updateCharactersData (dados, totalHours)
    if dados then 
        resource.dados = dados
        resource.hours_played = totalHours
    end
    charactersReturn ()
end

local function onClientKey ()
    if (resource.state) then 
        if config.block_keys then 
            --cancelEvent()
        end
    end
end

local function scrollBar(button)
    if (resource.state) then

        if button == "mouse_wheel_up" and resource.actualPage > 0 then
            resource.actualPage = resource.actualPage - 1

        elseif button == "mouse_wheel_down" and (config.others.max_characters - 5 > 0) then
            resource.actualPage = resource.actualPage + 1
            if resource.actualPage > config.others.max_characters - 5 then
                resource.actualPage = config.others.max_characters - 5
            end
        end
	end
end

registerEvent("guetto.update.character.custom", resourceRoot, function (clothes)
    
    local player_clothes = false 

    if not (clothes) then 
        player_clothes = 0
    else
        local data = clothes[1];

          player_clothes = {
            clothes = fromJSON(data.characters),
            genre = tonumber(data.gender),
            skinColor = tonumber(data.color)
        }
    end

    if (ped and isElement(ped)) then 
        destroyElement(ped)
    end

    if (player_clothes == 0) then 
        ped = createPed(0, config.others.position[1], config.others.position[2], config.others.position[3])
    else
        ped = exports["guetto_custom"]:createCustomPed(config.others.position[1], config.others.position[2], config.others.position[3], 1000, player_clothes)
    end

    resource.person_click = false
end)

bindKey("mouse_wheel_up", "down", scrollBar)
bindKey("mouse_wheel_down", "down", scrollBar)

registerEvent("guetto.openCharacters", resourceRoot, charactersOpen)
registerEvent("guetto.closeCharacters", resourceRoot, charactersClose)
registerEvent("guetto.updateCharactersData", resourceRoot, updateCharactersData)



addEventHandler("onClientClick", root, onClientClick)
addEventHandler("onClientKey", root, onClientKey)

bindKey("backspace", "down", charactersReturn)