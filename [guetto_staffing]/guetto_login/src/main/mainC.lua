--| Var's 

local screenW, screenH = guiGetScreenSize()
local assets = exports['guetto_assets']

interface = {}

interface["panel"] = {}
interface["password_cache"] = false

interface["dispair"] = {
    {1215, 216, 119, 168},
    {1205, 472, 161, 181},
    {573, 660, 119, 118},
    {514, 496, 119, 118},
}

local editbox = {
    account = false;
    password = false;

    password_1 = false;
    password_2 = false;

    select = 0;
}

local buttons = false

function render ( )
    
    buttons = {}

    interface["animations"]["general"]["alpha"] = interpolateBetween(interface["animations"]["general"]["i"], 0, 0, interface["animations"]["general"]["f"], 0, 0, (getTickCount ( ) - interface["animations"]["general"]["tick"]) / 400, 'Linear')

    dxDrawImage(0, 0, 1920, 1080, "assets/images/fundo.png", 0, 0, 0, tocolor(255, 255, 255, 255))
    dxDrawImage(527, 262, 852, 569, "assets/images/content.png", 0, 0, 0, tocolor(255, 255, 255, interface["animations"]["general"]["alpha"]))
 
    if interface["panel"]["page"] == "register" then 
   
        dxDrawImage(980, 241, 505, 628, "assets/images/person-register.png", 0, 0, 0, tocolor(255, 255, 255, interface["animations"]["general"]["alpha"]))
        dxDrawImage(1319, 249, 73, 73, "assets/images/circle2.png", 0, 0, 0, tocolor(255, 255, 255, interface["animations"]["general"]["alpha"]))
        dxDrawImage(1337, 267, 37, 37, "assets/images/retornar.png", 0, 0, 0, isCursorOnElement(1319, 249, 73, 73) and tocolor(193, 159, 114, interface["animations"]["general"]["alpha"]) or tocolor(217, 217, 217, interface["animations"]["general"]["alpha"]))
        
        dxDrawImage(552, 404, 428, 77, "assets/images/input.png", 0, 0, 0, tocolor(255, 255, 255, interface["animations"]["general"]["alpha"]))
        dxDrawImage(552, 494, 428, 77, "assets/images/input.png", 0, 0, 0, tocolor(255, 255, 255, interface["animations"]["general"]["alpha"]))
        dxDrawImage(552, 584, 428, 77, "assets/images/input.png", 0, 0, 0, tocolor(255, 255, 255, interface["animations"]["general"]["alpha"]))

        dxDrawImage(573, 421, 40, 44, "assets/images/user.png", 0, 0, 0, tocolor(217, 217, 217, interface["animations"]["general"]["alpha"]))
        dxDrawImage(573, 513, 40, 40, "assets/images/key.png", 0, 0, 0, tocolor(217, 217, 217, interface["animations"]["general"]["alpha"]))
        dxDrawImage(576, 608, 37, 37, "assets/images/question.png", 0, 0, 0, tocolor(255, 255, 255, interface["animations"]["general"]["alpha"]))

        dxDrawText("Cadastre-se para acessar nossa cidade e se divertir\ncom a gente um novo estilo de RP..", 555, 331, 289, 36, tocolor(255, 255, 255, interface["animations"]["general"]["alpha"]), 1, exports['guetto_assets']:dxCreateFont("light", 14), "left", "top")
 
        local user = guiGetText(editbox.account);
        local password = interface["password_cache"] == true and passwordViewer() or guiGetText(editbox.password);

        dxDrawText(editbox.select == 1 and user.."|" or user, 640, 430, 55, 23, editbox.select == 1 and tocolor(255, 255, 255, 255) or tocolor(94, 94, 94, interface["animations"]["general"]["alpha"]), 1, exports['guetto_assets']:dxCreateFont("light", 18), "left", "top")
        dxDrawText(editbox.select == 2 and password.."|" or password, 640, 520, 45, 23, editbox.select == 2 and tocolor(255, 255, 255, 255) or tocolor(94, 94, 94, interface["animations"]["general"]["alpha"]), 1, exports['guetto_assets']:dxCreateFont("light", 18), "left", "top")

        local rotation = interpolateBetween(interface["animations"]["rotation"]["i"], 0, 0, interface["animations"]["rotation"]["f"], 0, 0, (getTickCount ( ) - interface["animations"]["rotation"]["tick"]) / 200, 'Linear')

        if (rotation == 180) then 
            dxDrawImage(552, 670, 428, 211, "assets/images/modal.png", 0, 0, 0, tocolor(255, 255, 255, interface["animations"]["general"]["alpha"]))
            for i, v in ipairs(config["midia"]) do 
                dxDrawText(v, 574, 695 + (i-1) * 46, 144, 23, isCursorOnElement(574, 695 + (i-1) * 46, 144, 23) and tocolor(193, 159, 114, interface["animations"]["general"]["alpha"]) or interface["panel"]["select_search"] == i and tocolor(193, 159, 114, interface["animations"]["general"]["alpha"]) or tocolor(94, 94, 94, interface["animations"]["general"]["alpha"]), 1, exports['guetto_assets']:dxCreateFont("regular", 18), "left", "top")
                buttons[i] = {574, 695 + (i-1) * 46, 144, 23}
            end
        else
            dxDrawRectangle(552, 689, 428, 1, tocolor(255, 255, 255, 0.09 * interface["animations"]["general"]["alpha"]))
            dxDrawImage(552, 719, 428, 59, "assets/images/button-controller.png", 0, 0, 0, isCursorOnElement(552, 719, 428, 59) and tocolor(193, 159, 114, 0.26 * interface["animations"]["general"]["alpha"]) or tocolor(107, 107, 107, 0.26 * interface["animations"]["general"]["alpha"]))
            dxDrawText("CONFIRMAR", 552, 721, 428, 59, tocolor(255, 255, 255, interface["animations"]["general"]["alpha"]), 1, exports['guetto_assets']:dxCreateFont("regular", 20), "center", "center")
        end;

        dxDrawText(interface["panel"]["select_search"] == 0 and "Onde nos encontrou?" or config["midia"][interface["panel"]["select_search"]], 640, 610, 154, 23, tocolor(94, 94, 94, interface["animations"]["general"]["alpha"]), 1, exports['guetto_assets']:dxCreateFont("light", 18), "left", "top")
        dxDrawImage(926, 610, 26, 26, "assets/images/expand.png", rotation, 0, 0, isCursorOnElement(926, 610, 26, 26) and tocolor(193, 159, 114, interface["animations"]["general"]["alpha"]) or tocolor(94, 94, 94, interface["animations"]["general"]["alpha"]))

    else
        
        if interface["panel"]["page"] == "login" then 

            dxDrawImage(987, 248, 497, 583, "assets/images/person.png", 0, 0, 0, tocolor(255, 255, 255, interface["animations"]["general"]["alpha"]))

            dxDrawImage(552, 404, 428, 77, "assets/images/input.png", 0, 0, 0, tocolor(255, 255, 255, interface["animations"]["general"]["alpha"]))
            dxDrawImage(552, 494, 428, 77, "assets/images/input.png", 0, 0, 0, tocolor(255, 255, 255, interface["animations"]["general"]["alpha"]))
            
            dxDrawImage(552, 652, 428, 59, "assets/images/button-controller.png", 0, 0, 0, isCursorOnElement(552, 652, 428, 59) and tocolor(193, 159, 114, 0.26 * interface["animations"]["general"]["alpha"]) or tocolor(107, 107, 107, 0.26 * interface["animations"]["general"]["alpha"]))
            dxDrawImage(552, 719, 428, 59, "assets/images/button-controller.png", 0, 0, 0, isCursorOnElement(552, 719, 428, 59) and tocolor(193, 159, 114, 0.26 * interface["animations"]["general"]["alpha"]) or tocolor(107, 107, 107, 0.26 * interface["animations"]["general"]["alpha"]))
    
            dxDrawText("ACESSAR", 552, 654, 428, 59, tocolor(255, 255, 255, interface["animations"]["general"]["alpha"]), 1, exports['guetto_assets']:dxCreateFont("regular", 20), "center", "center")
            dxDrawText("CRIAR UMA CONTA", 552, 720, 428, 59, tocolor(255, 255, 255, interface["animations"]["general"]["alpha"]), 1, exports['guetto_assets']:dxCreateFont("regular", 20), "center", "center")
            dxDrawText("Bem vindo(a), a cidade você pode entrar diretamente\nou fazer seu registro.", 555, 331, 289, 36, tocolor(255, 255, 255, interface["animations"]["general"]["alpha"]), 1, exports['guetto_assets']:dxCreateFont("light", 14), "left", "top")
        
            if (interface["panel"]["saved"] ==  true) then 
                dxDrawImage(559, 602, 26, 26, "assets/images/lembrar.png", 0, 0, 0, tocolor(255, 255, 255, interface["animations"]["general"]["alpha"]))
            else
                dxDrawImage(559, 602, 26, 26, isCursorOnElement(559, 602, 20, 20) and "assets/images/lembrar.png" or "assets/images/circle.png", 0, 0, 0, isCursorOnElement(559, 602, 20, 20) and tocolor(255, 255, 255, interface["animations"]["general"]["alpha"]) or tocolor(217, 217, 217, 0.10 * interface["animations"]["general"]["alpha"]))
            end
    
            dxDrawText("Lembrar-me", 601, 600, 88, 23, tocolor(94, 94, 94, interface["animations"]["general"]["alpha"]), 1, exports['guetto_assets']:dxCreateFont("regular", 17), "left", "top")
         
            dxDrawImage(573, 421, 40, 44, "assets/images/user.png", 0, 0, 0, tocolor(217, 217, 217, interface["animations"]["general"]["alpha"]))
            dxDrawImage(573, 513, 40, 40, "assets/images/key.png", 0, 0, 0, tocolor(217, 217, 217, interface["animations"]["general"]["alpha"]))
    
            dxDrawImage(921, 517, 32, 32, "assets/images/olho.png", 0, 0, 0, tocolor(107, 107, 107, interface["animations"]["general"]["alpha"]))
    
            local user = guiGetText(editbox.account);
            local password = interface["password_cache"] == true and passwordViewer() or guiGetText(editbox.password);
    
            dxDrawText(editbox.select == 1 and user.."|" or user, 640, 430, 55, 23, editbox.select == 1 and tocolor(255, 255, 255, 255) or tocolor(94, 94, 94, interface["animations"]["general"]["alpha"]), 1, exports['guetto_assets']:dxCreateFont("light", 18), "left", "top")
            dxDrawText(editbox.select == 2 and password.."|" or password, 640, 520, 45, 23, editbox.select == 2 and tocolor(255, 255, 255, 255) or tocolor(94, 94, 94, interface["animations"]["general"]["alpha"]), 1, exports['guetto_assets']:dxCreateFont("light", 18), "left", "top")

            dxDrawImage(53, 967, 59, 59, "assets/images/info.png", 0, 0, 0, tocolor(255, 255, 255, interface["animations"]["general"]["alpha"]))
            dxDrawText("CONTA PERDIDA?", 136, 972, 129, 23, tocolor(193, 159, 114, interface["animations"]["general"]["alpha"]), 1, exports['guetto_assets']:dxCreateFont('medium', 14), 'left', 'top')
            dxDrawText("Clique aqui para recuperar.", 136, 998, 208, 23, isCursorOnElement(136, 998, 208, 23) and tocolor(193, 159, 114, interface["animations"]["general"]["alpha"]) or tocolor(255, 255, 255, interface["animations"]["general"]["alpha"]), 1, exports['guetto_assets']:dxCreateFont('medium', 14), 'left', 'top')

        elseif interface["panel"]["page"] == "recover" then 
            
            dxDrawImage(981, 268, 503, 601, "assets/images/person-recover.png", 0, 0, 0, tocolor(255, 255, 255, interface["animations"]["general"]["alpha"]))
            dxDrawText("Contas registradas em seu serial, gentileza escolher qual\ndeseja recuperar.", 555, 338, 307, 36, tocolor(255, 255, 255, interface["animations"]["general"]["alpha"]), 1, exports['guetto_assets']:dxCreateFont("light", 14), "left", "top")
            
            if interface["panel"]["accounts"] and #interface["panel"]["accounts"] ~= 0 then 
            
                for i, v in ipairs(interface["panel"]["accounts"]) do 
                    local offSetY = 404 + (i-1) * 90
                    dxDrawImage(552, offSetY, 428, 77, "assets/images/input.png", 0, 0, 0, isCursorOnElement(552, offSetY, 428, 77) and tocolor(193, 159, 114, interface["animations"]["general"]["alpha"]) or interface["panel"]["account.select"] == i and tocolor(193, 159, 114, interface["animations"]["general"]["alpha"]) or tocolor(255, 255, 255, interface["animations"]["general"]["alpha"]) )
                    dxDrawImage(575, offSetY + 77 / 2 - 38 / 2, 38, 38, "assets/images/user.png", 0, 0, 0, tocolor(217, 217, 217, interface["animations"]["general"]["alpha"]))
                    dxDrawText(v.accountName, 632, offSetY + 77 / 2 - 23 / 2, 93, 23, tocolor(255, 255, 255, interface["animations"]["general"]["alpha"]), 1, exports['guetto_assets']:dxCreateFont('light', 18), 'left', 'top')
                end;
            
            end

            dxDrawRectangle(552, 689, 428, 1, tocolor(255, 255, 255, 0.09 * interface["animations"]["general"]["alpha"]))
            dxDrawImage(552, 719, 428, 59, "assets/images/button-controller.png", 0, 0, 0, isCursorOnElement(552, 719, 428, 59) and tocolor(193, 159, 114, 0.26 * interface["animations"]["general"]["alpha"]) or tocolor(107, 107, 107, 0.26 * interface["animations"]["general"]["alpha"]))
            dxDrawText("RECUPERAR", 552, 721, 428, 59, tocolor(255, 255, 255, interface["animations"]["general"]["alpha"]), 1, exports['guetto_assets']:dxCreateFont('light', 18), 'center', 'center')
       
            
        dxDrawImage(1319, 249, 73, 73, "assets/images/circle2.png", 0, 0, 0, tocolor(255, 255, 255, interface["animations"]["general"]["alpha"]))
        dxDrawImage(1337, 267, 37, 37, "assets/images/retornar.png", 0, 0, 0, isCursorOnElement(1319, 249, 73, 73) and tocolor(193, 159, 114, interface["animations"]["general"]["alpha"]) or tocolor(217, 217, 217, interface["animations"]["general"]["alpha"]))

        elseif interface["panel"]["page"] == "accounts" then 
            dxDrawText("Você escolheu o usuário abaixo para resetar a senha lembre-se\nque você poderá fazer isso somente uma vez a cada 24 horas.", 555, 342, 339, 36, tocolor(255, 255, 255, interface["animations"]["general"]["alpha"]), 1, exports['guetto_assets']:dxCreateFont("light", 14), "left", "top")
            
            dxDrawImage(552, 404, 428, 77, "assets/images/rectangle-account.png", 0, 0, 0, tocolor(255, 255, 255, interface["animations"]["general"]["alpha"]))
            dxDrawText(interface["panel"]["accounts"][interface["panel"]["account.select"]].accountName, 552, 406, 428, 77, tocolor(255, 255, 255, interface["animations"]["general"]["alpha"]), 1, exports['guetto_assets']:dxCreateFont('light', 18), 'center', 'center')
       
            dxDrawImage(552, 494, 428, 77, "assets/images/input.png", 0, 0, 0, tocolor(255, 255, 255, interface["animations"]["general"]["alpha"]))
            dxDrawImage(552, 584, 428, 77, "assets/images/input.png", 0, 0, 0, tocolor(255, 255, 255, interface["animations"]["general"]["alpha"]))

            dxDrawImage(574, 513, 40, 40, "assets/images/key.png", 0, 0, 0, tocolor(217, 217, 217, interface["animations"]["general"]["alpha"]))
            dxDrawImage(574, 603, 40, 40, "assets/images/key.png", 0, 0, 0, tocolor(217, 217, 217, interface["animations"]["general"]["alpha"]))

            dxDrawImage(981, 268, 503, 601, "assets/images/person-recover.png", 0, 0, 0, tocolor(255, 255, 255, interface["animations"]["general"]["alpha"]))

            local password_1 = guiGetText(editbox.password_1);
            local password_2 = guiGetText(editbox.password_2);

            dxDrawText(editbox.select == 3 and password_1.."|" or password_1, 640, 522, 45, 23,  editbox.select == 3 and tocolor(255, 255, 255, interface["animations"]["general"]["alpha"]) or tocolor(94, 94, 94, interface["animations"]["general"]["alpha"]), 1, exports['guetto_assets']:dxCreateFont("light", 18), "left", "top")
            dxDrawText(editbox.select == 4 and password_2.."|" or password_2, 640, 612, 118, 23, editbox.select == 4 and tocolor(255, 255, 255, interface["animations"]["general"]["alpha"]) or tocolor(94, 94, 94, interface["animations"]["general"]["alpha"]), 1, exports['guetto_assets']:dxCreateFont("light", 18), "left", "top")

            dxDrawRectangle(552, 689, 428, 1, tocolor(255, 255, 255, 0.09 * interface["animations"]["general"]["alpha"]))
            dxDrawImage(552, 719, 428, 59, "assets/images/button-controller.png", 0, 0, 0, isCursorOnElement(552, 719, 428, 59) and tocolor(193, 159, 114, 0.26 * interface["animations"]["general"]["alpha"]) or tocolor(107, 107, 107, 0.26 * interface["animations"]["general"]["alpha"]))
            dxDrawText("ALTERAR SENHA", 552, 721, 428, 59, tocolor(255, 255, 255, interface["animations"]["general"]["alpha"]), 1, exports['guetto_assets']:dxCreateFont("light", 18), "center", "center")
            
            dxDrawImage(1319, 249, 73, 73, "assets/images/circle2.png", 0, 0, 0, tocolor(255, 255, 255, interface["animations"]["general"]["alpha"]))
            dxDrawImage(1337, 267, 37, 37, "assets/images/retornar.png", 0, 0, 0, isCursorOnElement(1319, 249, 73, 73) and tocolor(193, 159, 114, interface["animations"]["general"]["alpha"]) or tocolor(217, 217, 217, interface["animations"]["general"]["alpha"]))
        end

    end

    dxDrawImage(555, 287, 173, 40, "assets/images/logo.png", 0, 0, 0, tocolor(255, 255, 255, interface["animations"]["general"]["alpha"]))

    dxDrawText(string.upper(config["Others"]["discord"]), 863, 980, 192, 25, tocolor(255, 255, 255, interface["animations"]["general"]["alpha"]), 1, exports['guetto_assets']:dxCreateFont("bold", 18), "left", "top")
    dxDrawImage(28, 33, 129, 43, "assets/images/fundo-musica.png", 0, 0, 0, tocolor(255, 255, 255, interface["animations"]["general"]["alpha"]))

    dxDrawText("Musica", 28, 35, 129, 43, tocolor(255, 255, 255, interface["animations"]["general"]["alpha"]), 1, exports['guetto_assets']:dxCreateFont("regular", 15), "center", "center")
    dxDrawImage(1750, 42, 127, 67, "assets/images/autorais.png", 0, 0, 0, tocolor(255, 255, 255, interface["animations"]["general"]["alpha"]))
    dxDrawImage(175, 43, 24, 24, "assets/images/sound.png", 0, 0, 0, isCursorOnElement(175, 43, 24, 24) and tocolor(193, 159, 114, interface["animations"]["general"]["alpha"]) or tocolor(255, 255, 255, interface["animations"]["general"]["alpha"]))

    if interface["panel"]["showningSound"] then 
        slidebar.create("soung", {210, 53, 116, 5}, tocolor(80, 81, 91, 255), tocolor(193, 159, 114, 255), 100)
        local soung = slidebar.getSlidePercent("soung")
        dxDrawText(soung..'%', 337, 43, 40, 15, tocolor(255, 255, 255, interface["animations"]["general"]["alpha"]), 1, exports['guetto_assets']:dxCreateFont('medium', 15), 'right', 'top')
    end
end;

function openInterface ( )
    if not isEventHandlerAdded ("onClientRender", root, render) then 

        interface = {
            animations = {

                general = {
                    alpha = 0,
                    i = 0,
                    f = 255,
                    tick = getTickCount ( )
                },

                rotation = {
                    tick = 0,
                    i = 0,
                    f = 0,
                },

                buttons = {},
            },
            
            panel = {
                showning = false,
                page = "login",
                state = false,
                rotation = 0,
                select_search = 0,
                passwordVisible = false;
                showningSound = false,
                sound = playSound(config["sounds"][math.random(#config["sounds"])]["url"])
            },
        }        
      
        setElementData(localPlayer, "guetto.showning.hud", true)
        
        showCursor(true)
        showChat(false)

        if editbox.account and isElement(editbox.account) then 
            destroyElement(editbox.account)
        end

        if editbox.password and isElement(editbox.password) then 
            destroyElement(editbox.password)
        end

        if editbox.password_1 and isElement(editbox.password_1) then 
            destroyElement(editbox.password_1)
        end

        if editbox.password_2 and isElement(editbox.password_2) then 
            destroyElement(editbox.password_2)
        end

        editbox.account = guiCreateEdit(1000, 1000, 0, 0, "Usuário", false);
        editbox.password = guiCreateEdit(1000, 1000, 0, 0, "Senha", false);

        editbox.password_1 = guiCreateEdit(1000, 1000, 0, 0, "Senha", false);
        editbox.password_2 = guiCreateEdit(1000, 1000, 0, 0, "Confirmar Senha", false);

        local account, password = loadLoginFromXML()

        if (account and #account ~= 0 and account ~= "nil") and (password and #password ~= 0 and password ~= "nil") then 
            interface["password_cache"] = true

            guiSetText(editbox.account, account)
            guiSetText(editbox.password, password)

            interface["panel"]["saved"] = true;
        end

        setSoundVolume(interface["panel"]["sound"], 1)
        addEventHandler("onClientRender", root, render)
    end

end;

function closeInterface ( )
    if isEventHandlerAdded ("onClientRender", root, render) then 
        interface["animations"]["general"]["i"] = 255
        interface["animations"]["general"]["f"] = 0
        interface["animations"]["general"]["tick"] = getTickCount ( )
        interface["panel"]["state"] = false
        if interface["panel"]["sound"] then 
            stopSound(interface["panel"]["sound"])
        end
        setTimer ( function ( )
            slidebar.destroyAllSlid()
            removeEventHandler("onClientRender", root, render)
            setElementData(localPlayer, "guetto.showning.hud", false)
        end, 400, 1 )
        showCursor(false)
        showChat(true)
    end
end;


addEventHandler("onClientClick", root, function (button, state)
    if isEventHandlerAdded("onClientRender", root, render) then 
        if button == 'left' and state == 'down' then
            
            if (interface["animations"]["rotation"]["f"] == 180 and interface["panel"]["page"] == "register" ) then 
                for i, v in ipairs(buttons) do 
                    if isCursorOnElement(unpack(v)) then 
                        interface["panel"]["select_search"] = i
                    end
                end
            end

            if interface["panel"]["page"] == "login" then 
                
                if (editbox.select == 1 and string.len(guiGetText(editbox.account)) == 0) then
                    guiSetText(editbox.account, "Usuário")
                    editbox.select = 0
                elseif (editbox.select == 2 and string.len(guiGetText(editbox.password)) == 0) then
                    guiSetText(editbox.password, "Senha")
                    editbox.select = 0
                end
                if editbox.select and editbox.select ~= 0  then 
                    editbox.select = 0 
                end

                if isCursorOnElement(921, 517, 32, 32) then 
                   
                    if not (interface["password_cache"]) then 
                        interface["password_cache"] = true
                    else
                        interface["password_cache"] = false 
                    end

                elseif isCursorOnElement(552, 404, 428, 77) then -- Input account
               
                    if editbox.select == 0 then 
                        if guiEditSetCaretIndex(editbox.account, string.len(guiGetText(editbox.account))) and guiGetText(editbox.account) == "Usuário" then
                            guiBringToFront(editbox.account)
                            guiSetInputMode('no_binds_when_editing')
                            guiSetText(editbox.account, "")
                            editbox.select = 1
                        else
                            guiBringToFront(editbox.account)
                            guiSetInputMode('no_binds_when_editing')
                            guiSetText(editbox.account, "")
                            editbox.select = 1
                        end
                    end
               
                elseif isCursorOnElement( 552, 494, 428, 77 ) then  -- Input password
                    
                    if editbox.select == 0 then 
                        if guiEditSetCaretIndex(editbox.password, string.len(guiGetText(editbox.password))) and guiGetText(editbox.password) == "Senha" then
                            guiBringToFront(editbox.password)
                            guiSetInputMode('no_binds_when_editing')
                            guiSetText(editbox.password, "")
                            editbox.select = 2
                        else
                            guiBringToFront(editbox.password)
                            guiSetInputMode('no_binds_when_editing')
                            guiSetText(editbox.password, "")
                            editbox.select = 2
                        end
                    end
                end

            elseif interface["panel"]["page"] == "register" then 

                if (editbox.select == 1 and string.len(guiGetText(editbox.account)) == 0) then
                    guiSetText(editbox.account, "Usuário")
                    editbox.select = 0
                elseif (editbox.select == 2 and string.len(guiGetText(editbox.password)) == 0) then
                    guiSetText(editbox.password, "Senha")
                    editbox.select = 0
                end
                if editbox.select and editbox.select ~= 0  then 
                    editbox.select = 0 
                end

                if isCursorOnElement(552, 404, 428, 77) then -- Input account
                    if editbox.select == 0 then 
                        if guiEditSetCaretIndex(editbox.account, string.len(guiGetText(editbox.account))) and guiGetText(editbox.account) == "Usuário" then
                            guiBringToFront(editbox.account)
                            guiSetInputMode('no_binds_when_editing')
                            guiSetText(editbox.account, "")
                            editbox.select = 1
                        else
                            guiBringToFront(editbox.account)
                            guiSetInputMode('no_binds_when_editing')
                            guiSetText(editbox.account, "")
                            editbox.select = 1
                        end
                    end
                elseif isCursorOnElement( 552, 494, 428, 77 ) then  -- Input password 
                    if editbox.select == 0 then 
                        if guiEditSetCaretIndex(editbox.password, string.len(guiGetText(editbox.password))) and guiGetText(editbox.password) == "Senha" then
                            guiBringToFront(editbox.password)
                            guiSetInputMode('no_binds_when_editing')
                            guiSetText(editbox.password, "")
                            editbox.select = 2
                        else
                            guiBringToFront(editbox.password)
                            guiSetInputMode('no_binds_when_editing')
                            guiSetText(editbox.password, "")
                            editbox.select = 2
                        end
                    end
                end

            elseif interface["panel"]["page"] == "accounts" then 

                if (editbox.select == 3 and string.len(guiGetText(editbox.password_1)) == 0) then
                    guiSetText(editbox.password_1, "Senha")
                    editbox.select = 0
                elseif (editbox.select == 4 and string.len(guiGetText(editbox.password_2)) == 0) then
                    guiSetText(editbox.password_2, "Confirmar Senha")
                    editbox.select = 0
                end
                
                if editbox.select and editbox.select ~= 0  then 
                    editbox.select = 0 
                end

                if isCursorOnElement(552, 494, 428, 77) then -- Password Input 1
                    if editbox.select == 0 then 
                        if guiEditSetCaretIndex(editbox.password_1, string.len(guiGetText(editbox.password_1))) and guiGetText(editbox.password_1) == "Senha" then
                            guiBringToFront(editbox.password_1)
                            guiSetInputMode('no_binds_when_editing')
                            guiSetText(editbox.password_1, "")
                            editbox.select = 3
                        else
                            guiBringToFront(editbox.password_1)
                            guiSetInputMode('no_binds_when_editing')
                            guiSetText(editbox.password_1, "")
                            editbox.select = 3
                        end
                    end
                elseif isCursorOnElement(552, 584, 428, 77) then -- Password Input 2 
                    if editbox.select == 0 then 
                        if guiEditSetCaretIndex(editbox.password_2, string.len(guiGetText(editbox.password_2))) and guiGetText(editbox.password_2) == "Confirmar Senha" then
                            guiBringToFront(editbox.password_2)
                            guiSetInputMode('no_binds_when_editing')
                            guiSetText(editbox.password_2, "")
                            editbox.select = 4
                        else
                            guiBringToFront(editbox.password_2)
                            guiSetInputMode('no_binds_when_editing')
                            guiSetText(editbox.password_2, "")
                            editbox.select = 4
                        end
                    end
                end

            end

            if isCursorOnElement(552, 652, 428, 59) then 

                if interface["panel"]["page"] == "login" then 
                    local key = getPlayerSerial(localPlayer)    
                    
                    if (guiGetText(editbox.account) == "Usuário" or string.len(guiGetText(editbox.account)) == 0 or guiGetText(editbox.account) == "") then 
                        return config.sendMessageClient("Digite um usário!", "error")
                    end

                    if (guiGetText(editbox.password) == "Senha" or string.len(guiGetText(editbox.password)) == 0 or guiGetText(editbox.password) == "") then 
                        return config.sendMessageClient("Digite uma senha!", "error")
                    end
    
                    local hashtoKey = toJSON({ user = guiGetText(editbox.account), password = guiGetText(editbox.password)})
    
                    encodeString('aes128', hashtoKey, {key = key:sub(17)}, function(enc, iv)
                        triggerServerEvent("guetto.login", resourceRoot, localPlayer, enc, iv)
                    end)

                    saveLoginToXML(guiGetText(editbox.account), guiGetText(editbox.password))
                end

            elseif isCursorOnElement(136, 998, 208, 23) then 
                
                if interface["panel"]["page"] == "login" then 
                    interface["animations"]["general"]["tick"] = getTickCount()
                    interface["panel"]["page"] = 'recover'
                    triggerServerEvent("guetto.recover.accounts", resourceRoot, localPlayer)
                end

            elseif isCursorOnElement(552, 719, 428, 59) then
                
                if interface["panel"]["page"] == "login" then 
                   
                    interface["animations"]["general"]["tick"] = getTickCount()
                    interface["panel"]["page"] = "register" 
                    interface["panel"]["rotation"] = 0

                elseif interface["panel"]["page"] == "register" then 

                    if (guiGetText(editbox.account) == "Usuário" or string.len(guiGetText(editbox.account)) == 0 or guiGetText(editbox.account) == "") then 
                        return config.sendMessageClient("Digite um usário!", "error")
                    end

                    if (guiGetText(editbox.password) == "Senha" or string.len(guiGetText(editbox.password)) == 0 or guiGetText(editbox.password) == "") then 
                        return config.sendMessageClient("Digite uma senha!", "error")
                    end
                    if (interface["panel"]["select_search"] == 0) then 
                        return config["sendMessageClient"]( "Selecione onde nos encontrou!", "error")
                    end;

                    local key = getPlayerSerial(localPlayer)    
                    local hashtoKey = toJSON({ user = guiGetText(editbox.account), password = guiGetText(editbox.password), search = config["midia"][interface["panel"]["select_search"]]})
                    
                    encodeString('aes128', hashtoKey, {key = key:sub(17)}, function(enc, iv)
                        triggerServerEvent("guetto.register", resourceRoot, localPlayer, enc, iv)
                    end)

                elseif interface["panel"]["page"] == "accounts" then 

                    if (guiGetText(editbox.password_1) == "Senha" or string.len(guiGetText(editbox.password_1)) == 0 or guiGetText(editbox.password_1) == "") then 
                        return config.sendMessageClient("Digite a nova senha!", "error")
                    end

                    if (guiGetText(editbox.password_2) == "Confirmar Senha" or string.len(guiGetText(editbox.password_2)) == 0 or guiGetText(editbox.password_2) == "") then 
                        return config.sendMessageClient("Digite a nova senha!", "error")
                    end
    
                    if guiGetText(editbox.password_1) ~= guiGetText(editbox.password_2) then 
                        return config["sendMessageClient"]( "As senhas não coincidem!", "error")
                    end;

                    if #guiGetText(editbox.password_1) <= 4 and #guiGetText(editbox.password_2) <= 4 then 
                        return config["sendMessageClient"]( "Senha muito curta!", "error")
                    end;

                    local key = getPlayerSerial(localPlayer)    
                    local hashtoKey = toJSON({ user = interface["panel"]["accounts"][interface["panel"]["account.select"]].accountName, password = guiGetText(editbox.password_1)})
                    
                    
                    encodeString('aes128', hashtoKey, {key = key:sub(17)}, function(enc, iv)
                        triggerServerEvent("guetto.recover", resourceRoot, localPlayer, enc, iv)
                    end)

                    saveLoginToXML(interface["panel"]["accounts"][interface["panel"]["account.select"]].accountName, guiGetText(editbox.password_1))
                end

            elseif isCursorOnElement(926, 610, 26, 26) then 
                if (getTickCount ( ) - interface["animations"]["rotation"]["tick"] <= 200) then 
                    return 
                end;
                if (interface["animations"]["rotation"]["f"] == 180) then 
                    interface["animations"]["rotation"]["i"] = 180
                    interface["animations"]["rotation"]["f"] = 0
                    interface["animations"]["rotation"]["tick"] = getTickCount ( )
                else
                    interface["animations"]["rotation"]["i"] = 0
                    interface["animations"]["rotation"]["f"] = 180
                    interface["animations"]["rotation"]["tick"] = getTickCount ( )
                end

            elseif isCursorOnElement(559, 602, 20, 20) then 
                if interface["panel"]["page"] == "login" then 
                    if not interface["panel"]["saved"] then

                        if (guiGetText(editbox.account) == "Usuário" or string.len(guiGetText(editbox.account)) == 0 or guiGetText(editbox.account) == "") then 
                            return config.sendMessageClient("Digite um usário!", "error")
                        end

                        if (guiGetText(editbox.password) == "Senha" or string.len(guiGetText(editbox.password)) == 0 or guiGetText(editbox.password) == "") then 
                            return config.sendMessageClient("Digite uma senha!", "error")
                        end

                        interface["panel"]["saved"] = true 
                        saveLoginToXML(guiGetText(editbox.account), guiGetText(editbox.password))
                    else
                        interface["panel"]["saved"] = false
                        
                        guiSetText(editbox.account, "Usuário")
                        guiSetText(editbox.password, "Senha")

                        saveLoginToXML(nil, nil)
                    end
                end
            elseif isCursorOnElement(1319, 249, 73, 73) then 
                if interface["panel"]["page"] == "register" then
                    interface["animations"]["general"]["tick"] = getTickCount()
                    interface["panel"]["page"] = "login" 
                elseif interface["panel"]["page"] == "recover" then 
                    interface["animations"]["general"]["tick"] = getTickCount()
                    interface["panel"]["page"] = "login" 
                elseif interface["panel"]["page"] == "accounts" then 
                    interface["animations"]["general"]["tick"] = getTickCount()
                    interface["panel"]["page"] = "recover" 
                end
            elseif isCursorOnElement(175, 43, 24, 24) then 
                if interface["panel"]["showningSound"] then 
                    interface["panel"]["showningSound"] = false 
                else
                    interface["panel"]["showningSound"] = true 
                end
            end 
            if (interface["panel"]["page"] == "recover") then
                if interface["panel"]["accounts"] and #interface["panel"]["accounts"] ~= 0 then 
                    for i, v in ipairs(interface["panel"]["accounts"]) do 
                        local offSetY = 404 + (i-1) * 90 
                        if isCursorOnElement(552, offSetY, 428, 77) then 
                            interface["panel"]["account.select"] = i
                            break
                        end
                    end
                end
                if isCursorOnElement(552, 719, 428, 59) then 
                    if interface["panel"]["account.select"] and interface["panel"]["account.select"] ~= 0 then 
                        interface["panel"]["page"] = "accounts"
                    else
                        return config["sendMessageClient"]( "Selecione uma conta!", "error")
                    end
                end
            end
        end
    end
end)

function passwordViewer ( state )
    local password = guiGetText(editbox.password);
    local str = ""
    if (password) then 
        for i = 1, #password do 
            str = str.."*"
        end
    end
    return str
end;

registerEventHandler("guetto.hidden.login", resourceRoot, function ( )
    closeInterface ( )
end)

registerEventHandler("guetto.hidden.register", resourceRoot, function ( )
    interface["panel"]["page"] = "login"
end)

registerEventHandler("guetto.send.client.accounts", resourceRoot, function (accounts)
    interface["panel"]["accounts"] = accounts
    interface["panel"]["account.select"] = 0
end)

registerEventHandler("guetto.update.password", resourceRoot, function (account, password)
    interface["animations"]["general"]["tick"] = getTickCount()
    interface["panel"]["page"] = "login"

    saveLoginToXML(account, password)

    local user, pass = loadLoginFromXML()

    if (user and pass) then 
        guiSetText(editbox.password, pass)
    end

    interface.panel.saved = true
end)

function hiddenPassword ( )
    
    local result = "";
    local _, password = loadLoginFromXML() 

    if password then 
        
        for i = 1, #password do 
            result = result.."*"
        end
    
        return result
    end

    return "*****"
end;

slidebar.events.start()

registerEventHandler('guetto.open.login', resourceRoot, function ( )
    openInterface()
end)


triggerServerEvent('guetto.request.login', resourceRoot, localPlayer)


--[[
    

local isInterpolating = false
local startTime
local endTime
local startPos
local endPos

function startCameraTransition()
    if isInterpolating then return end
    
    local x, y, z = getElementPosition(localPlayer)
    
    local fx, fy, fz = getPedHeadPosition (localPlayer)
    startPos = {x, y, z + 200} 
    endPos = {fx, fy, fz} 
    
    startTime = getTickCount()
    endTime = startTime + 3000
    
    isInterpolating = true
    addEventHandler("onClientRender", root, updateCameraPosition)
    setElementFrozen(localPlayer, true)
    toggleAllControls(false)
end

function updateCameraPosition()
    local now = getTickCount()
    local elapsedTime = now - startTime
    local duration = endTime - startTime
    
    local progress = elapsedTime / duration
    
    if now >= endTime then
        isInterpolating = false
        removeEventHandler("onClientRender", root, updateCameraPosition)
        setCameraTarget(localPlayer)
        setElementFrozen(localPlayer, false)
        toggleAllControls(true)
        return
    end
    
    local x, y, z = interpolateBetween(
        startPos[1], startPos[2], startPos[3],
        endPos[1], endPos[2], endPos[3],
        progress, "Linear"
    )
    
    setCameraMatrix(x, y, z, endPos[1], endPos[2], endPos[3])
end

function getPedHeadPosition(ped)
    local x, y, z = getElementPosition(ped)
    local boneZ = 0.9 
    
    if isPedDucked(ped) then
        boneZ = boneZ - 0.5 
    end
    
    z = z + boneZ
    
    return x, y, z
end

]]