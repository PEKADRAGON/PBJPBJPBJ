-- \\ Var´s //

local interface = { }
local assets = exports['guetto_assets']
local isEventHandlerAdded = false;

interface.animations = {}
interface.positions = {}

interface.animations.fade = {0, 0, 0}
interface.animations.moveY = {0, 0, 0}

interface.positions.windows = {
    {46, 98, 206, 53, "", "assets/images/home.png", "Inicio"};
    {46, 155, 206, 53, "", "assets/images/members.png", "Membros"};
    {46, 212, 206, 53, "", "assets/images/bank.png", "Banco"};
    {46, 269, 206, 53, "", "assets/images/convidar.png", "Convidar"};
}

interface.positions.logs = {
    
    {754, 256, 676, 59 };
    {754, 319, 676, 59 };
    {754, 382, 676, 59 };
    {754, 445, 676, 59 };
    {754, 508, 676, 59 };

}

interface.positions.members = {
    {754, 79, 659, 59};
    {754, 142, 659, 59};
    {754, 205, 659, 59};
    {754, 268, 659, 59};
    {754, 331, 659, 59};
    {754, 394, 659, 59};
}

-- \\ Function´s //

function draw ( )

    local fade = interpolateBetween ( interface.animations.fade[1], 0, 0, interface.animations.fade[2], 0, 0, ( getTickCount ( ) - interface.animations.fade[3] ) / 400, "Linear" )
    local y = interpolateBetween ( interface.animations.moveY[1], 0, 0, interface.animations.moveY[2], 0, 0, ( getTickCount ( ) - interface.animations.moveY[3] ) / 400, "InOutBack" )

    if not interface.data then 
        if tblSize ( interface.invites ) ~= 0 then 
            
            dxDrawImage(651, y, 617, 597, "assets/images/convites.png", 0, 0, 0, tocolor(255, 255, 255, fade))
            dxDrawText("CONVITES DE GRUPOS", 881, y + 12, 157, 23, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("light", 15), "center", "top")

            dxDrawText("Grupo deseja você:", 651 + 103, y + 90, 145, 24, tocolor(152, 152, 152, fade), 1, exports['guetto_assets']:dxCreateFont("light", 15), "center", "top")
            dxDrawText(interface.invites.Grupo, 651 + 95, y + 118, 161, 23, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("regular", 15), "center", "top")

            dxDrawText("Lider", 651 + 42, y + 192, 145, 24, tocolor(152, 152, 152, fade), 1, exports['guetto_assets']:dxCreateFont("light", 15), "left", "top")
            dxDrawText("Membros", 651 + 42, y + 273, 145, 24, tocolor(152, 152, 152, fade), 1, exports['guetto_assets']:dxCreateFont("light", 15), "left", "top")
            dxDrawText("Dominação", 651 + 42, y + 354, 145, 24, tocolor(152, 152, 152, fade), 1, exports['guetto_assets']:dxCreateFont("light", 15), "left", "top")

            dxDrawText(interface.invites.Owner, 651 + 42, y + 220, 145, 24, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("regular", 15), "left", "top")
            dxDrawText(interface.invites.Members, 651 + 42, y + 301, 145, 24, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("regular", 15), "left", "top")
            dxDrawText(interface.invites.Dominacao, 651 + 42, y + 382, 145, 24, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("regular", 15), "left", "top")
            
            dxDrawImage(651 + 331, y + 92, 286, 463, interface.invites.Type == "Corporação" and "assets/images/corporacao.png" or "assets/images/faccao.png", 0, 0, 0, tocolor(255, 255, 255, fade))

            dxDrawRoundedRectangle(651 + 20, y + 455, 311, 54, isCursorOnElement(651 + 20, y + 455, 311, 54) and tocolor(193, 159, 114, 0.70 * fade) or tocolor(39, 39, 39, fade), 4)
            dxDrawRoundedRectangle(651 + 20, y + 514, 311, 54, isCursorOnElement(651 + 20, y + 514, 311, 54) and tocolor(193, 159, 114, 0.70 * fade) or tocolor(39, 39, 39, fade), 4)

            dxDrawText("ACEITAR GRUPO", 651 + 20, y + 455 + 3, 311, 54, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("regular", 15), "center", "center")
            dxDrawText("RECUSAR GRUPO", 651 + 20, y + 514 + 3, 311, 54, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("regular", 15), "center", "center")
        else
            
            dxDrawImage(651, y, 617, 551, "assets/images/semgrupo.png", 0, 0, 0, tocolor(255, 255, 255, fade))
            dxDrawText("CONVITES DE GRUPOS", 881, y + 12, 157, 23, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("light", 15), "center", "top")

            dxDrawText("VOCÊ NÃO TEM CONVITE DE GRUPO", 651 + 178, y + 356, 260, 23, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("medium", 15), "center", "top")
            dxDrawText("“Talvez seja por que você é ruim na bala.”", 651 + 154, y + 379, 309, 23, tocolor(193, 159, 114, fade), 1, exports['guetto_assets']:dxCreateFont("light", 15), "center", "top")

        end
    else

        dxDrawImage(467, y, 985, 597, "assets/images/fundo.png", 0, 0, 0, tocolor(255, 255, 255, fade))

        dxDrawText("PAINEL DE GRUPO", 467 + 87, y + 49, 123, 23, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("light", 15), "center", "top")
    
        for i, v in ipairs ( interface.positions.windows ) do 
       
            dxDrawRoundedRectangle(467 + v[1], y + v[2], v[3], v[4], tocolor(33, 33, 33, fade), 6)
            
            if isCursorOnElement(467 + v[1], y + v[2], v[3], v[4]) then
                dxDrawImage(467 + v[1], y + v[2], v[3], v[4], "assets/images/stroke.png")
            end

            dxDrawImage(467 + v[1] + 15, y + v[2] + v[4] / 2 - 27 / 2, 29, 29, v[6], 0, 0, 0, tocolor(255, 255, 255, fade))
            dxDrawText(v[7], 467 + v[1] + 52, y + v[2] + 15, 110, 23, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("light", 15), "left", "top")

            if interface.window == v[7] then 
                dxDrawImage(467 + v[1], y + v[2], v[3], v[4], "assets/images/stroke.png")
            end
            
        end

        dxDrawRoundedRectangle(498, y + 367, 235, 200, tocolor(22, 22, 22, fade), 9)
    
        dxDrawText("Saldo do grupo", 513, y + 386, 132, 24, tocolor(152, 152, 152, fade), 1, exports['guetto_assets']:dxCreateFont("light", 15), "left", "top")
        dxDrawText("Sua contribuição", 513, y + 481, 132, 24, tocolor(152, 152, 152, fade), 1, exports['guetto_assets']:dxCreateFont("light", 15), "left", "top")
        
        if interface.data.Cofre then 
            dxDrawText("R$ "..formatNumber(tonumber(interface.data.Cofre), "."), 513, y + 414, 132, 24, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("regular", 15), "left", "top")
        end
    
        if interface.playerData.Contribution then 
            dxDrawText("R$ "..formatNumber(tonumber(interface.playerData.Contribution), "."), 513, y + 509, 132, 24, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("regular", 15), "left", "top")
        end

        if interface.window == "Inicio" then 

            dxDrawRoundedRectangle(467 + 287, y + 37, 468, 172, tocolor(33, 33, 33, 0.34 * fade), 3)

            dxDrawRoundedRectangle(467 + 761, y + 37, 202, 53, isCursorOnElement(467 + 761, y + 37, 202, 53) and tocolor(193, 159, 114, 0.70 * fade) or tocolor(33, 33, 33, 0.34 * fade), 5)
            dxDrawRoundedRectangle(467 + 761, y + 96, 202, 113, tocolor(33, 33, 33, 0.34 * fade), 3)

            dxDrawText("Grupo", 467 + 313, y + 59, 48, 23, tocolor(210, 209, 209, fade), 1, exports['guetto_assets']:dxCreateFont("bold", 15), "left", "top")
            dxDrawText(interface.data.Name, 467 + 313, y + 87, 187, 23, tocolor(193, 159, 114, fade), 1, exports['guetto_assets']:dxCreateFont("regular", 15), "left", "top")

            dxDrawText("Dono", 467 + 784, y + 125, 41, 23, tocolor(210, 209, 209, fade), 1, exports['guetto_assets']:dxCreateFont("bold", 15), "left", "top")
            dxDrawText(interface.data.Owner, 467 + 784, y + 153, 187, 23, tocolor(193, 159, 114, fade), 1, exports['guetto_assets']:dxCreateFont("regular", 15), "left", "top")
            
            local actual, max = interface.data.Members, interface.data.Capacity
            local logs = fromJSON(interface.data.Logs)

            dxDrawText("Membros", 467 + 313, y + 125, 48, 23, tocolor(210, 209, 209, fade), 1, exports['guetto_assets']:dxCreateFont("bold", 15), "left", "top")
            dxDrawText(""..actual.."/"..max.."", 467 + 313, y + 153, 187, 23, tocolor(193, 159, 114, fade), 1, exports['guetto_assets']:dxCreateFont("regular", 15), "left", "top")
             
            dxDrawImage(467 + 596, y, 131, 209, interface.data.Type == "Corporação" and "assets/images/corporacao.png" or "assets/images/faccao.png", 0, 0, 0, tocolor(255, 255, 255, fade))
            dxDrawText("SAIR DO GRUPO", 467 + 806, y + 52, 112, 23, tocolor(217, 217, 217, fade), 1, exports['guetto_assets']:dxCreateFont("light", 15), "left", "top")

            dxDrawText("Atividade", 467 + 302, y + 224, 70, 23, tocolor(217, 217, 217, fade), 1, exports['guetto_assets']:dxCreateFont("light", 15), "left", "top")
            dxDrawText("Data", 467 + 899, y + 224, 70, 23, tocolor(217, 217, 217, fade), 1, exports['guetto_assets']:dxCreateFont("light", 15), "left", "top")

            dxDrawText(interface.data.Acl, 467 + 649, y + 164, 38, 30, tocolor(193, 159, 114, fade), 1, exports['guetto_assets']:dxCreateFont("bold", 20), "left", "top")

            for i = 1, #interface.positions.logs do 
                local v = logs[i]
                if v then 
                    dxDrawText(v or "", interface.positions.logs[i][1] + 21, y + interface.positions.logs[i][2] + 18, 229, 23, tocolor(217, 217, 217, fade), 1, exports['guetto_assets']:dxCreateFont("light", 15), "left", "top")
                    dxDrawText(timestampToDateString(tonumber(v.date)) or "", interface.positions.logs[i][1] + 569, y + interface.positions.logs[i][2] + 18, 229, 23, tocolor(217, 217, 217, fade), 1, exports['guetto_assets']:dxCreateFont("light", 15), "left", "top")
                    dxDrawRoundedRectangle(interface.positions.logs[i][1], y + interface.positions.logs[i][2], interface.positions.logs[i][3], interface.positions.logs[i][4], isCursorOnElement(interface.positions.logs[i][1], y + interface.positions.logs[i][2], interface.positions.logs[i][3], interface.positions.logs[i][4]) and tocolor(73, 73, 73, 0.30 * fade) or tocolor(33, 33, 33, 0.20 * fade), 6)
                end
            end

        elseif interface.window == "Membros" then

            dxDrawText("Membros", 467 + 302, y + 45, 71, 23, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("light", 16), "left", "top")
            dxDrawText("Cargo", 467 + 623, y + 45, 71, 23, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("light", 16), "left", "top")
            dxDrawText("Membros", 467 + 851, y + 45, 71, 23, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("light", 16), "left", "top")

            scroll.draw("members", 1423, y + 79, 5, 374, tocolor(36, 36, 36, fade), tocolor(193, 159, 114, fade), 6, #interface.members)
            scroll.buttons["scroll:members"] = {467 + 287, y + 79, 669, 374 }

            if interface.members and #interface.members ~= 0 then 
                for i = 1, #interface.positions.members do 
                    local v = interface.members[i + scroll.getValue("members")]
                    if v then 
                        dxDrawRoundedRectangle(interface.positions.members[i][1], y + interface.positions.members[i][2], interface.positions.members[i][3], interface.positions.members[i][4], interface.select_member == i + scroll.getValue("members") and tocolor(73, 73, 73, 0.30 * fade) or isCursorOnElement(interface.positions.members[i][1], y + interface.positions.members[i][2], interface.positions.members[i][3], interface.positions.members[i][4]) and tocolor(73, 73, 73, 0.30 * fade) or tocolor(33, 33, 33, 0.20 * fade), 4)
                        dxDrawText(v.Account..' #'..v.Id, interface.positions.members[i][1] + 21, y + interface.positions.members[i][2] + 18, 111, 23, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("light", 15), "left", "top")
                        dxDrawText(v.Role, interface.positions.members[i][1] + 336, y + interface.positions.members[i][2] + 18, 111, 23, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("light", 15), "left", "top")
                        dxDrawText(v.Status, interface.positions.members[i][1] + 587, y + interface.positions.members[i][2] + 18, 111, 23, v.Status == 'Online' and tocolor(137, 165, 120, fade) or tocolor(249, 81, 80, fade), 1, exports['guetto_assets']:dxCreateFont("light", 15), "left", "top")
                    end
                end
            end

            if interface.select_member ~= 0 then 
                local data = interface.members[interface.select_member]
                if (data) then 
                    local pos = getRolePosition (data.Type, data.Role)
           
                    dxDrawRoundedRectangle(467 + 287, y + 465, 671, 102, tocolor(22, 22, 22, fade), 4)
                    
                    dxDrawText("Membro(a),", 467 + 308, y + 490, 92, 23, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("light", 15), "left", "top")
                    
                    if data then 
                        dxDrawText(data.Account, 467 + 308, y + 518, 111, 23, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("light", 15), "left", "top")
                    end
    
                    dxDrawRoundedRectangle(467 + 618, y + 498, 149, 37, isCursorOnElement(467 + 618, y + 498, 149, 37) and tocolor(73, 73, 73, 0.30 * fade) or tocolor(217, 217, 217, 0.04 * fade),  5)
                    dxDrawRoundedRectangle(467 + 775, y + 498, 149, 37, isCursorOnElement(467 + 775, y + 498, 149, 37) and tocolor(73, 73, 73, 0.30 * fade) or tocolor(217, 217, 217, 0.04 * fade),  5)
    
                    dxDrawText("UPAR", 467 + 775, y + 498 + 2, 149, 37, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("medium", 15), "center", "center")
                    if pos and pos == #config["Cargos"][data.Type] then 
                        dxDrawText("EXPULSAR", 467 + 618, y + 498 + 2, 149, 37, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("medium", 15), "center", "center")
                    else
                        dxDrawText("REBAIXAR", 467 + 618, y + 498 + 2, 149, 37, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("medium", 15), "center", "center")
                    end
                end
            end

        elseif interface.window == "Banco" then

            dxDrawRoundedRectangle(467 + 287, y + 37, 331, 340, tocolor(22, 22, 22, fade), 9)
            dxDrawRoundedRectangle(467 + 627, y + 37, 331, 340, tocolor(22, 22, 22, fade), 9)   

            dxDrawImage(467 + 409, y + 85, 87, 87, "assets/images/porco.png", 0, 0, 0, tocolor(255, 255, 255, fade))
            dxDrawImage(467 + 750, y + 86, 85, 85, "assets/images/dinheiro.png", 0, 0, 0, tocolor(255, 255, 255, fade))

            dxDrawText("Saldo do grupo", 467 + 287, y + 220, 331, 24, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("medium", 15), "center", "top")
            dxDrawText("Sua contribuição", 467 + 627, y + 220, 331, 24, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("medium", 15), "center", "top")

            dxDrawText("R$ "..formatNumber(tonumber(interface.data.Cofre), "."), 467 + 409, y + 266, 87, 87, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("regular", 20), "center", "center")
            dxDrawText("R$ "..formatNumber(interface.playerData.Contribution,  "."), 467 + 750, y + 266, 85, 85, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("regular", 20), "center", "center")

            dxDrawRoundedRectangle(467 + 287, y + 390, 671, 63, tocolor(33, 33, 33, 0.20 * fade), 5)
            dxDrawEditbox(467 + 287, y + 390, 671, 63, 25, "BancoGrupo")
            
            if isBoxActive("BancoGrupo") then 
                dxDrawText(getEditboxText("BancoGrupo").."|", 1056, y + 407, 68, 30, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("bold", 20), "center", "top")
            else
                dxDrawText((#getEditboxText("BancoGrupo") ~= 0) and getEditboxText("BancoGrupo") or "VALOR", 1056, y + 407, 68, 30, tocolor(217, 217, 217, fade), 1, exports['guetto_assets']:dxCreateFont("bold", 20), "center", "top")
            end

            dxDrawRoundedRectangle(467 + 287, y + 465, 671, 102, tocolor(22, 22, 22, fade), 5)

            dxDrawText("Membro(a),", 775, y + 490, 92, 24, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("medium", 15), "left", "top")
            dxDrawText(interface.playerData.Account, 775, y + 518, 111, 23, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("light", 15), "left", "top")

            dxDrawRoundedRectangle(467 + 618, y + 498, 149, 37, isCursorOnElement(467 + 618, y + 498, 149, 37) and tocolor(73, 73, 73, 0.30 * fade) or tocolor(217, 217, 217, 0.04 * fade),  5)
            dxDrawRoundedRectangle(467 + 775, y + 498, 149, 37, isCursorOnElement(467 + 775, y + 498, 149, 37) and tocolor(73, 73, 73, 0.30 * fade) or tocolor(217, 217, 217, 0.04 * fade),  5)
      
            dxDrawText("DEPOSITAR", 467 + 618, y + 498 + 2, 149, 37, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("medium", 15), "center", "center")
            dxDrawText("SACAR", 467 + 775, y + 498 + 2, 149, 37, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("medium", 15), "center", "center")

        elseif interface.window == "Convidar" then
        
            dxDrawImage(467, y, 985, 597, "assets/images/blur.png", 0, 0, 0, tocolor(255, 255, 255, fade))
            dxDrawImage(833, y + 220, 254, 193, "assets/images/bg-recrutar.png", 0, 0, 0, tocolor(255, 255, 255, fade))

            dxDrawText("RECRUTAR MEMBROS", 882, y + 184, 157, 23, tocolor(217, 217, 217, fade), 1, exports['guetto_assets']:dxCreateFont("medium", 15), "left", "top")
            dxDrawText("ID DO RECRUTADO", 894, y + 239, 132, 23, tocolor(217, 217, 217, fade), 1, exports['guetto_assets']:dxCreateFont("light", 15), "left", "top")

            dxDrawRoundedRectangle(848, y + 270, 224, 46, tocolor(24, 24, 24, fade), 5)
            dxDrawRoundedRectangle(848, y + 333, 224, 46, isCursorOnElement(848, y + 333, 224, 46) and tocolor(73, 73, 73, 0.50 * fade) or tocolor(34, 34, 34, fade), 5)

            dxDrawEditbox(848, y + 270, 224, 46, 15, "ID-RECRUTAR")
            
            if isBoxActive("ID-RECRUTAR") then 
                dxDrawText(getEditboxText("ID-RECRUTAR").."|", 848, y + 273, 224, 46, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("light", 15), "center", "center")
            else
                dxDrawText((#getEditboxText("ID-RECRUTAR") ~= 0) and getEditboxText("ID-RECRUTAR") or "ID", 848, y + 273, 224, 46, tocolor(217, 217, 217, fade), 1, exports['guetto_assets']:dxCreateFont("light", 15), "center", "center")
            end

            dxDrawText("RECRUTAR", 848, y + 333 + 2, 224, 46, tocolor(217, 217, 217, fade), 1, exports['guetto_assets']:dxCreateFont("light", 15), "center", "center")
            dxDrawText("[BACKSPACE] PARA VOLTAR", 872, y + 431, 175, 20, tocolor(217, 217, 217, fade), 1, exports['guetto_assets']:dxCreateFont("regular", 15), "left", "top")
        end

    end


    
end

function toggle ( state )
    if state then 
        isEventHandlerAdded = true 
        
        interface.animations.fade[1], interface.animations.fade[2], interface.animations.fade[3] = 0, 255, getTickCount ()
        interface.animations.moveY[1], interface.animations.moveY[2], interface.animations.moveY[3] = 0, 241, getTickCount ()

        interface.window = "Inicio"
        interface.select_member = 0;

        showCursor(true)
        showChat(false)
        addEventHandler("onClientRender", root, draw)
    else
        isEventHandlerAdded = false;

        interface.animations.fade[1], interface.animations.fade[2], interface.animations.fade[3] = 255, 0, getTickCount ()
        interface.animations.moveY[1], interface.animations.moveY[2], interface.animations.moveY[3] = 241, 0, getTickCount ()

        setTimer ( function ( )
            showCursor(false)
            showChat(true)
            removeEventHandler("onClientRender", root, draw)
            destroyElements()
        end, 400, 1)
    end
end

local function onClientClick ( button, state )
    if isEventHandlerAdded then 
        if button == "left" and state == "down" then 
            if not interface.data then 
                if tblSize ( interface.invites ) ~= 0 then
                    if isCursorOnElement(651 + 20, 241 + 455, 311, 54) then  -- Aceitar Grupo
                        triggerServerEvent("Guetto:Client:acceptInvite", resourceRoot, interface.invites)
                        toggle(false)
                    elseif isCursorOnElement(651 + 20, 241 + 514, 311, 54) then  -- Recusar Grupo
                        triggerServerEvent("Guetto:Client:refuseInvite", resourceRoot, interface.invites)
                        toggle(false)
                    end
                end
            else
                
                for i, v in ipairs ( interface.positions.windows ) do 
                    if isCursorOnElement(467 + v[1], 241 + v[2], v[3], v[4]) then
                        interface.window = v[7]
                    end
                end

                if interface.window == "Inicio" then 
                    
                    if isCursorOnElement(467 + 761, 242 + 37, 202, 53) then 
                        triggerServerEvent("Guetto:Client:Quit", resourceRoot)
                        toggle ( false )
                    end

                elseif interface.window == "Membros" then 
                    for i = 1, #interface.positions.members do 
                        local v = interface.members[i + scroll.getValue("members")]
                        if isCursorOnElement(interface.positions.members[i][1], 242 + interface.positions.members[i][2], interface.positions.members[i][3], interface.positions.members[i][4]) then
                            if v then 
                                interface.select_member = i + scroll.getValue("members")
                            end
                            break 
                        end
                    end
                    if interface.select_member ~= 0 then 
                        if isCursorOnElement(467 + 618, 242 + 498, 149, 37) then

                            if interface.playerData.Account ~= interface.data.Owner then 
                                if interface.playerData.Role == interface.members[interface.select_member].Role then 
                                    return config.sendMessageClient("Voce não possui permissão para rebaixar um cargo igual ou superior ao seu!", "error")
                                end
                            end

                            local positionMyRole = getRolePosition ( interface.playerData.Type, interface.playerData.Role )
                            local positionTargetRole =  getRolePosition ( interface.members[interface.select_member].Type, interface.members[interface.select_member].Role )
                            
                            if config["Cargos"][interface.playerData.Type][positionMyRole].permissoes.rebaixar == false then
                                return config.sendMessageClient("Voce não possui permissão para rebaixar o membro!", "error")
                            end

                            if positionTargetRole == #config["Cargos"][interface.playerData.Type] then 

                                if config["Cargos"][interface.playerData.Type][positionMyRole].permissoes.expulsar == false then
                                    return config.sendMessageClient("Voce não possui permissão para expulsar o membro!", "error")
                                end

                                triggerServerEvent("Guetto:Client:Expulsar", resourceRoot, interface.members[interface.select_member].Account)
                            else
                                triggerServerEvent("Guetto:Client:downgradeRole", resourceRoot, interface.members[interface.select_member].Account)
                            end


                        elseif isCursorOnElement(467 + 775, 242 + 498, 149, 37) then

                            if interface.playerData.Role == interface.members[interface.select_member].Role then 
                                return config.sendMessageClient("Voce não upar um cargo igual ou superior ao seu!", "error")
                            end

                            local positionMyRole = getRolePosition ( interface.playerData.Type, interface.playerData.Role )
                            local positionTargetRole =  getRolePosition ( interface.members[interface.select_member].Type, interface.members[interface.select_member].Role )

                            if config["Cargos"][interface.playerData.Type][positionMyRole].permissoes.upar == false then
                                return config.sendMessageClient("Voce não possui permissão para upar o membro!", "error")
                            end

                            if positionMyRole < positionTargetRole then 
                                triggerServerEvent("Guetto:Client:upgradeRole", resourceRoot, interface.members[interface.select_member].Account)
                            else
                                config.sendMessageClient("Voce não upar um cargo igual ou superior ao seu!", "error")
                            end
                        end
                    end
                elseif interface.window == "Banco" then
                    
                    if isCursorOnElement(467 + 618, 242 + 498, 149, 37) then
                    
                        local positionMyRole = getRolePosition ( interface.playerData.Type, interface.playerData.Role )
                    
                        if config["Cargos"][interface.playerData.Type][positionMyRole].permissoes.depositar == false then
                            return config.sendMessageClient("Voce não possui permissão para depositar no cofre do grupo!", "error")
                        end

                        local value = getEditboxText("BancoGrupo")
                        
                        if #value == 0 or value == "VALOR" then 
                            return config.sendMessageClient("Por favor, digite um valor!", "error")
                        end

                        if spam and getTickCount() - spam <= 1000 then return end 
                        triggerServerEvent("Guetto:Client:deposit", resourceRoot, value)
                        spam = getTickCount()

                    elseif isCursorOnElement(467 + 775, 242 + 498, 149, 37) then 

                        local positionMyRole = getRolePosition ( interface.playerData.Type, interface.playerData.Role )

                        if config["Cargos"][interface.playerData.Type][positionMyRole].permissoes.sacar == false then
                            return config.sendMessageClient("Voce não possui permissão para sacar do cofre do grupo!", "error")
                        end

                        local value = getEditboxText("BancoGrupo")

                        if #value == 0 or value == "VALOR" then 
                            return config.sendMessageClient("Por favor, digite um valor!", "error")
                        end

                        if spam and getTickCount() - spam <= 1000 then return end 

                        triggerServerEvent("Guetto:Client:sacar", resourceRoot, value)
                        spam = getTickCount()
                    end

                elseif interface.window == "Convidar" then
                    if isCursorOnElement(848, 242 + 333, 224, 46) then 
                        local value = getEditboxText("ID-RECRUTAR")

                        if #value == 0 or value == "ID" then
                            return config.sendMessageClient("Por favor, digite o ID do membro!", "error")
                        end

                        triggerServerEvent("Guetto:Client:invite", resourceRoot, value)
                    end
                end
            end
        end
    end
end

-- \\ Event´s //

bindKey(config.others.key, "down", function()
    
    if interface.delay and getTickCount ( ) - interface.delay <= 400 then 
        return false 
    end

    interface.delay = getTickCount ()

    if not isEventHandlerAdded then
        triggerServerEvent("Guetto:GetInfos", resourceRoot)
    else
        toggle ( false )
    end

end)

function reciverPlayerInfos ( data, invites, members, playerData )
    if #data == 0 then 
        interface.data = false 
        interface.members = false
        interface.playerData = false
    else
        interface.data = data[1]
        interface.members = members
        interface.playerData = playerData[1]
    end
    interface.invites = invites
    toggle ( isEventHandlerAdded and false or true )
end

registerEventHandler("Guetto:Client:receiveInfos", resourceRoot, reciverPlayerInfos)
addEventHandler("onClientClick", root, onClientClick)


-- \\ Create Group //

local isEventHandlerAdded_Create = false;

function CreateGroupDraw ( )

    dxDrawImage(714, 280, 492, 519, "assets/images/createGroup.png", 0, 0, 0, tocolor(255, 255, 255, 255))
    dxDrawText("CRIAR GRUPOS NO GUETTO", 864, 292, 193, 23, tocolor(255, 255, 255, 255), 1, exports['guetto_assets']:dxCreateFont("light", 15), "center", "top")

    dxDrawText("Nome do grupo", 735, 351, 118, 23, tocolor(255, 255, 255, 255), 1, exports['guetto_assets']:dxCreateFont("light", 15), "left", "top")
    dxDrawText("ACL", 1052, 351, 118, 23, tocolor(255, 255, 255, 255), 1, exports['guetto_assets']:dxCreateFont("light", 15), "left", "top")

    dxDrawRoundedRectangle(735, 381, 309, 59, tocolor(33, 33, 33, 0.20 * 255), 6)
    dxDrawRoundedRectangle(1052, 381, 134, 59, tocolor(33, 33, 33, 0.20 * 255), 6)

    dxDrawRoundedRectangle(735, 449, 451, 59, tocolor(33, 33, 33, 0.20 * 255), 6)

    dxDrawRoundedRectangle(735, 517, 229, 116, tocolor(33, 33, 33, 0.20 * 255), 6)
    dxDrawRoundedRectangle(970, 517, 229, 116, tocolor(33, 33, 33, 0.20 * 255), 6)

    dxDrawImage(1168 - 24, 468, 24, 24, "assets/images/arrow.png", 0, 0, 0, isCursorOnElement(1168 - 24, 468, 24, 24) and tocolor(193, 159, 114, 255) or tocolor(177, 177, 177, 255))
    dxDrawImage(753, 468, 24, 24, "assets/images/arrow.png", 180, 0, 0, isCursorOnElement(753, 468, 24, 24) and tocolor(193, 159, 114, 255) or tocolor(177, 177, 177, 255))

    dxDrawRoundedRectangle(735, 680, 451, 59, isCursorOnElement(735, 680, 451, 59) and tocolor(193, 159, 114, 0.80 * 255) or tocolor(33, 33, 33, 0.20 * 255), 6)
    dxDrawText("CRIAR GRUPO", 735, 683, 451, 59, tocolor(255, 255, 255, 225), 1, exports['guetto_assets']:dxCreateFont("light", 18), "center", "center")
    
    dxDrawEditbox(735, 381, 309, 59, 20, "Nome do Grupo")
    dxDrawEditbox(1052, 381, 134, 59, 10, "ACL")
    dxDrawEditbox(735, 517, 229, 116, 10, "Quantidade")
    dxDrawEditbox(970, 517, 229, 116, 10, "Lider")
    
    if isBoxActive("Nome do Grupo") then 
        dxDrawText(getEditboxText("Nome do Grupo").."|", 755, 399, 51, 23, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("medium", 16), "left", "top")
    else
        dxDrawText((#getEditboxText("Nome do Grupo") ~= 0) and getEditboxText("Nome do Grupo") or "Guetto..", 755, 399, 51, 23, tocolor(94, 94, 94, fade), 1, exports['guetto_assets']:dxCreateFont("medium", 16), "left", "top")
    end

    if isBoxActive("ACL") then 
        dxDrawText(getEditboxText("ACL").."|", 1068, 399, 32, 23, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("medium", 16), "left", "top")
    else
        dxDrawText((#getEditboxText("ACL") ~= 0) and getEditboxText("ACL") or "GTO..", 1068, 399, 32, 23, tocolor(94, 94, 94, fade), 1, exports['guetto_assets']:dxCreateFont("medium", 16), "left", "top")
    end

    if isBoxActive("Quantidade") then 
        dxDrawText(getEditboxText("Quantidade").."|", 753, 569, 13, 30, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("medium", 16), "left", "top")
    else
        dxDrawText((#getEditboxText("Quantidade") ~= 0) and getEditboxText("Quantidade") or "0", 753, 569, 3132, 30, tocolor(94, 94, 94, fade), 1, exports['guetto_assets']:dxCreateFont("medium", 16), "left", "top")
    end

    if isBoxActive("Lider") then 
        dxDrawText(getEditboxText("Lider").."|", 992, 569, 18, 30, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("medium", 16), "left", "top")
    else
        dxDrawText((#getEditboxText("Lider") ~= 0) and getEditboxText("Lider") or "#", 992, 569, 18, 30, tocolor(94, 94, 94, fade), 1, exports['guetto_assets']:dxCreateFont("medium", 16), "left", "top")
    end

    dxDrawText(config["others"]["tipos"][selectType], 735, 449, 451, 59, tocolor(255, 255, 255, 255), 1, exports['guetto_assets']:dxCreateFont("light", 15), "center", "center")
 
    dxDrawText("Quantidade", 753, 531, 90, 23, tocolor(255, 255, 255, 255), 1, exports['guetto_assets']:dxCreateFont("light", 15), "center", "center")
    dxDrawText("Lider", 992, 531, 90, 23, tocolor(255, 255, 255, 255), 1, exports['guetto_assets']:dxCreateFont("light", 15), "left", "center")
end

function CreateGroupToggle ( state )
    if state then 
        isEventHandlerAdded_Create = true 
        selectType = 1;
        showCursor(true)
        showChat(false)
        addEventHandler("onClientRender", root, CreateGroupDraw)
    else
        isEventHandlerAdded_Create = false
        showCursor(false)
        showChat(true)
        removeEventHandler("onClientRender", root, CreateGroupDraw)
    end
end

addEventHandler("onClientClick", root, function (button, state)
    if isEventHandlerAdded_Create then
        if button == "left" and state == "down" then 
            if isCursorOnElement(1168 - 24, 468, 24, 24) then
            
                if selectType < #config["others"].tipos then 
                    selectType = selectType + 1
                end
            
            elseif isCursorOnElement(753, 468, 24, 24) then 
            
                if selectType > 1 then 
                    selectType = selectType - 1
                end
            
            elseif isCursorOnElement(735, 680, 451, 59) then 
                local name = getEditboxText("Nome do Grupo")
                
                if #name == 0 or name == "Nome do Grupo" then 
                    return config.sendMessageClient("Por favor, digite um nome para o grupo!", "error")
                end

                local acl = getEditboxText("ACL")
                local quantity = getEditboxText("Quantidade")
                local leader = getEditboxText("Lider")

                if #acl == 0 or acl == "ACL" then 
                    return config.sendMessageClient("Por favor, digite uma ACL!", "error")
                end

                if #quantity == 0 or quantity == "Quantidade" then 
                    return config.sendMessageClient("Por favor, digite a quantidade de membros do grupo!", "error")
                end

                if #leader == 0 or leader == "Lider" then 
                    return config.sendMessageClient("Por favor, digite o lider do grupo!", "error")
                end
                
                triggerServerEvent("Guetto:createGroup", resourceRoot, name, config["others"]["tipos"][selectType], acl, tonumber(quantity), leader)
            end 
        end
    end
end)

registerEventHandler("Guetto:Client:createGroup", resourceRoot, function ( )
    CreateGroupToggle ( not isEventHandlerAdded_Create and true or false )
end)

registerEventHandler("Guetto:Client:UpdateDados", resourceRoot, function (  data, members, playerData )
    interface.data = data[1]
    interface.members = members
    interface.playerData = playerData[1]
end)

bindKey("backspace", "down", function ( )
    if isEventHandlerAdded then
        if interface.window == "Convidar" then 
            interface.window = "Inicio"
        else
            toggle(false)
        end    
    end
    if isEventHandlerAdded_Create then 
        CreateGroupToggle ( false )
    end
end)

function timestampToDateString(timestamp)
    local dateTable = os.date("*t", timestamp)
    local dateString = string.format("%02d/%02d/%04d", dateTable.day, dateTable.month, dateTable.year)
    return dateString
end
