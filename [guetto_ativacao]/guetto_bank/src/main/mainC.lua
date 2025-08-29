-- Var´s 

local windows = {
    {847, 44, 38, 38, "assets/images/1.png"};
    {943, 44, 38, 38, "assets/images/2.png"};
    {1039, 46, 34, 34, "assets/images/3.png"};
}

local animation = {0, 0, 0};
local fade = { 0, 0, 0 }
local select = 1;
local windowsPos = false
local isEventHandlerAdded = false;

-- Func´s 

function interfaceDraw ( )

    
    local y = interpolateBetween(animation[1], 0, 0, animation[2], 0, 0, (getTickCount() - animation[3]) / 400, "InOutBack");
    local fade = interpolateBetween(fade[1], 0, 0, fade[2], 0, 0, (getTickCount() - fade[3]) / 400, "Linear");
    windowsPos = {}
    
    dxDrawImage(709, y, 501, 571, "assets/images/fundo.png", 0, 0, 0, tocolor(255, 255, 255, fade))

    for i, v in ipairs(windows) do 
        dxDrawImage(v[1], y + v[2], v[3], v[4], v[5], 0, 0, 0, select == i and tocolor(193, 159, 114, fade) or isCursorOnElement(v[1], y + v[2], v[3], v[4]) and tocolor(193, 159, 114, fade) or tocolor(42, 42, 48, fade))
        windowsPos[i] = {v[1], y + v[2], v[3], v[4]}
    end;

    dxDrawRectangle(732, y + 111, 456, 1, tocolor(255, 255, 255, 0.02 * fade))

    dxDrawImage(732, y + 126, 456, 83, "assets/images/button-saldo.png", 0, 0, 0, tocolor(217, 217, 217, 0.02 * fade))
    dxDrawText("Saldo bancário ", 764, y + 138, 114, 23, tocolor(116, 116, 116, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'left', 'top')
    
    dxDrawText('$ '..formatNumber((getElementData(localPlayer, "guetto.bank.balance") or 0), '.'), 764, y + 165, 96, 30, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('medium', 18), 'left', 'top')

    if select == 1 then 

        dxDrawText("Deposito bancário", 732, y + 238, 188, 30, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 18), 'left', 'top')
        dxDrawText("Guarde seu dinheiro conosco.", 732, y + 268, 223, 30, tocolor(116, 116, 116, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'left', 'top')

        dxDrawImage(732, y + 310, 456, 68, "assets/images/button-input.png", 0, 0, 0, tocolor(217, 217, 217, 0.02 * fade))
        dxDrawEditbox(732, y + 310, 456, 68, 10, "deposit", true)

        if isBoxActive("deposit") then 
            dxDrawText(getEditboxText("deposit").."|", 732, y + 312, 456, 68, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("light", 18), "center", "center")
        else
            dxDrawText((#getEditboxText("deposit") ~= 0) and getEditboxText("deposit") or "VALOR", 732, y + 312, 456, 68, tocolor(94, 94, 94, fade), 1, exports['guetto_assets']:dxCreateFont("light", 18), "center", "center")
        end

        dxDrawImage(732, y + 466, 456, 62, "assets/images/button-exec.png", 0, 0, 0, isCursorOnElement(732, y + 466, 456, 62) and tocolor(193, 159, 114, 0.26 * fade) or tocolor(217, 217, 217, 0.02 * fade))
        dxDrawText("DEPOSITAR", 732, y + 468, 456, 62, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'center', 'center')
    
    elseif select == 2 then 

        dxDrawText("Saque bancário", 732, y + 238, 188, 30, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 18), 'left', 'top')
        dxDrawText("Retire seu dinheiro com segurança.", 732, y + 268, 263, 23, tocolor(116, 116, 116, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'left', 'top')

        dxDrawImage(732, y + 310, 456, 68, "assets/images/button-input.png", 0, 0, 0, tocolor(217, 217, 217, 0.02 * fade))
        dxDrawEditbox(732, y + 310, 456, 68, 10, "saque", true)

        if isBoxActive("saque") then 
            dxDrawText(getEditboxText("saque").."|", 732, y + 312, 456, 68, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("light", 18), "center", "center")
        else
            dxDrawText((#getEditboxText("saque") ~= 0) and getEditboxText("saque") or "VALOR", 732, y + 312, 456, 68, tocolor(94, 94, 94, fade), 1, exports['guetto_assets']:dxCreateFont("light", 18), "center", "center")
        end

        dxDrawImage(732, y + 466, 456, 62, "assets/images/button-exec.png", 0, 0, 0, isCursorOnElement(732, y + 466, 456, 62) and tocolor(193, 159, 114, 0.26 * fade) or tocolor(217, 217, 217, 0.02 * fade))
        dxDrawText("SACAR", 732, y + 468, 456, 62, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'center', 'center')

    elseif select == 3 then 

        dxDrawText("Transferência bancário", 732, y + 232, 188, 30, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 18), 'left', 'top')
        dxDrawText("Envie seu dinheiro com segurança.", 732, y + 269, 263, 23, tocolor(116, 116, 116, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'left', 'top')

        dxDrawImage(732, y + 310, 456, 68, "assets/images/button-input.png", 0, 0, 0, tocolor(217, 217, 217, 0.02 * fade))
        dxDrawEditbox(732, y + 310, 456, 68, 10, "transfer", true)

        dxDrawImage(732, y + 382, 456, 68, "assets/images/button-input.png", 0, 0, 0, tocolor(217, 217, 217, 0.02 * fade))
        dxDrawEditbox(732, y + 382, 456, 68, 10, "transferID", true)

        if isBoxActive("transfer") then 
            dxDrawText(getEditboxText("transfer").."|", 732, y + 312, 456, 68, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("light", 18), "center", "center")
        else
            dxDrawText((#getEditboxText("transfer") ~= 0) and getEditboxText("transfer") or "VALOR", 732, y + 312, 456, 68, tocolor(94, 94, 94, fade), 1, exports['guetto_assets']:dxCreateFont("light", 18), "center", "center")
        end


        if isBoxActive("transferID") then 
            dxDrawText(getEditboxText("transferID").."|", 732, y + 384, 456, 68, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("light", 18), "center", "center")
        else
            dxDrawText((#getEditboxText("transferID") ~= 0) and getEditboxText("transferID") or "ID", 732, y + 384, 456, 68, tocolor(94, 94, 94, fade), 1, exports['guetto_assets']:dxCreateFont("light", 18), "center", "center")
        end

        dxDrawImage(732, y + 466, 456, 62, "assets/images/button-exec.png", 0, 0, 0, isCursorOnElement(732, y + 466, 456, 62) and tocolor(193, 159, 114, 0.26 * fade) or tocolor(217, 217, 217, 0.02 * fade))
        dxDrawText("TRANSFERIR VALOR", 732, y + 468, 456, 62, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'center', 'center')
    end

    dxDrawText("Para fechar o painel do banco", 846, y + 571 + 19, 228, 23, tocolor(193, 159, 114, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'left', 'top')

end;

function interfaceOpen ( )
    if not isEventHandlerAdded then 
        isEventHandlerAdded = true
        animation[1], animation[2], animation[3] = 0, 278, getTickCount ( )
        fade[1], fade[2], fade[3] = 0, 255, getTickCount ( )
        showCursor(true)
        addEventHandler("onClientRender", root, interfaceDraw)
    end
end;

function interfaceClose ( )
    if isEventHandlerAdded then 
        isEventHandlerAdded = false
        animation[1], animation[2], animation[3] = 278, 0, getTickCount ( )
        fade[1], fade[2], fade[3] = 255, 0, getTickCount ( )
        showCursor(false)
        setTimer (function ( )
            removeEventHandler("onClientRender", root, interfaceDraw)
        end, 400, 1)
    end
end;

addEventHandler("onClientClick", root, function ( button, state )
    if button == 'left' and state == 'down' then 
        if isEventHandlerAdded then 
            if select == 1 then 
                if isCursorOnElement(732, 744, 456, 62) then 
                    local value = getEditboxText("deposit");
                    
                    if #value == 0 then 
                        return config.sendMessageClient("Você precisa informar um valor para depositar.", "error")
                    end;

                    if value == "VALOR" then 
                        return config.sendMessageClient("Você precisa informar um valor para depositar.", "error")
                    end;

                    local serial = getPlayerSerial (localPlayer);
                    
                    local data = toJSON({
                        value = value,
                    })
                    
                    if tonumber(value) < 0 then 
                        return config.sendMessageClient("Você não pode depositar valores negativos.", "error")
                    end;

                    encodeString("aes128", data, {key = serial:sub(17)}, function ( enc, iv )
                        triggerServerEvent("guetto.deposit.bank", resourceRoot, localPlayer, enc, iv)
                    end)
                end

            elseif select == 2 then 
                if isCursorOnElement(732, 744, 456, 62) then 
                    local value = getEditboxText("saque");
                    
                    if #value == 0 then 
                        return config.sendMessageClient("Você precisa informar um valor para sacar.", "error")
                    end;
    
                    if value == "VALOR" then 
                        return config.sendMessageClient("Você precisa informar um valor para sacar.", "error")
                    end;
    
                    local serial = getPlayerSerial (localPlayer);
    
                    local data = toJSON({
                        value = value,
                    })
    
                    if tonumber(value) < 0 then 
                        return config.sendMessageClient("Você não pode sacar valores negativos.", "error")
                    end;
    
                    encodeString("aes128", data, {key = serial:sub(17)}, function ( enc, iv )
                        triggerServerEvent("guetto.saque.bank", resourceRoot, localPlayer, enc, iv)
                    end)
                end

            elseif select == 3 then 
                if isCursorOnElement(732, 744, 456, 62) then 

                    local value = getEditboxText("transfer");
                    local id = getEditboxText("transferID");
                    
                    if #value == 0 then 
                        return config.sendMessageClient("Você precisa informar um valor para transferir.", "error")
                    end;
    
                    if value == "VALOR" then 
                        return config.sendMessageClient("Você precisa informar um valor para transferir.", "error")
                    end;

                    if #id == 0 then 
                        return config.sendMessageClient("Você precisa informar um ID para transferir.", "error")
                    end;
    
                    if id == "ID" then 
                        return config.sendMessageClient("Você precisa informar um ID para transferir.", "error")
                    end;
    
                    local serial = getPlayerSerial (localPlayer);
    
                    local data = toJSON({
                        value = value,
                        id = id,
                    })
    
                    if tonumber(value) < 0 then 
                        return config.sendMessageClient("Você não pode transferir valores negativos.", "error")
                    end;
    
                    encodeString("aes128", data, {key = serial:sub(17)}, function ( enc, iv )
                        triggerServerEvent("guetto.transfer.bank", resourceRoot, localPlayer, enc, iv)
                    end)

                end
            end
            for i, v in ipairs(windowsPos) do 
                if isCursorOnElement(unpack(v)) then 
                    select = i
                    break;
                end 
            end
        end
    end
end)

registerEventHandler("guetto.open", resourceRoot, function ( )
    interfaceOpen()
end)

bindKey("backspace", "down", function ( )
    interfaceClose()
end)

addEventHandler("onClientObjectDamage", root, function ( )
    if getElementData(source, "guetto.bank") then 
        cancelEvent()
    end
end)
