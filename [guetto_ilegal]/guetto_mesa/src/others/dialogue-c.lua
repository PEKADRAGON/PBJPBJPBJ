dialogue = {}

dialogue.functions = {}
dialogue.ui = {}
dialogue.svgs = {}

dialogue.labels = {
    "Tem a braba ai?",
    "Ta tendo do verdin ai?",
    "O skank ta do bom? me vende ai!",
}

dialogue.svgs = {
    ['rectangle'] = svgCreate(425, 199, [[
        <svg width="425" height="199" viewBox="0 0 425 199" fill="none" xmlns="http://www.w3.org/2000/svg">
        <rect width="425" height="199" rx="20" fill="#121212" fill-opacity="0.9"/>
        </svg>
    ]]);

    ['button'] = svgCreate(168, 58, [[
        <svg width="168" height="58" viewBox="0 0 168 58" fill="none" xmlns="http://www.w3.org/2000/svg">
        <rect width="168" height="58" rx="7" fill="white"/>
        </svg>
    ]]);

}

function dialogue.functions.draw ( )

    dxDrawImage(747, 708, 425, 199, dialogue.svgs['rectangle'], 0, 0, 0, tocolor(255, 255, 255, 255))
    dxDrawText('CLIENTE DA BOCA', 787, 742, 141, 16, tocolor(193, 159, 114, 255), 1, exports['guetto_assets']:dxCreateFont('bold', 16), 'left', 'top')

    local text = dialogue.labels[dialogue.ui.random] or 'Tem a braba?'

    dxDrawText('#797979'..text..' #C19F72X'..ui.amount, 787, 770, 336, 24, tocolor(121, 121, 121, 255), 1, exports['guetto_assets']:dxCreateFont('regular', 16), 'left', 'top', false, false, false, true)

    dxDrawImage(785, 824, 168, 58, dialogue.svgs['button'], 0, 0, 0, isCursorOnElement(785, 824, 168, 58) and tocolor(165, 75, 75, 255) or tocolor(34, 35, 35, 255))
    dxDrawImage(966, 824, 168, 58, dialogue.svgs['button'], 0, 0, 0, isCursorOnElement(966, 824, 168, 58) and tocolor(104, 165, 75, 255) or tocolor(34, 35, 35, 255))

    dxDrawText("NEGAR", 785, 824, 168, 58, tocolor(255, 255, 255, 255), 1, exports["guetto_assets"]:dxCreateFont("bold", 15), "center", "center")
    dxDrawText("ACEITAR", 966, 824, 168, 58, tocolor(255, 255, 255, 255), 1, exports["guetto_assets"]:dxCreateFont("bold", 15), "center", "center")
end

function dialogue.functions.click (button, state)
    if button == 'left' and state == 'down' and dialogue.ui.visible then
        if isCursorOnElement(785, 824, 168, 58) then 
            
            element.destroyPed(localPlayer)
            dialogue.functions.toggle(false)

            local random = math.random(#config["times"])

            setTimer(function()
                if (isHaveItemTable(ui.mesa)) then 
                    element.createPed(localPlayer, ui.mesa)
                    print(true)
                else
                    element.destroyPed(localPlayer)
                    sendMessageClient("Você não possui mais drogas em sua mesa.", "error")
                end
            end, config["times"][random], 1)

            sendMessageClient("Você recusou a venda.", "info")
        elseif isCursorOnElement(966, 824, 168, 58) then 

            element.destroyPed(localPlayer)
            dialogue.functions.toggle(false)
            
            local bool, i = isHaveItemTable (ui.mesa)
            if bool then 
                local data = getElementData(ui.mesa, "table.itens")[i]
                triggerServerEvent("onPlayerAcceptProposal", resourceRoot, data, ui.amount, ui.mesa)
                dialogue.functions.toggle(false)
            else
                element.destroyPed(localPlayer)
                sendMessageClient("Você não possui mais drogas em sua mesa.", "error")
            end
        end
    end
end 

function dialogue.functions.toggle (state)
    if state and not dialogue.ui.visible then
        dialogue.ui.visible = true
        showCursor(true)
        dialogue.ui.random =  math.random(#dialogue.labels)
        addEventHandler('onClientRender', root, dialogue.functions.draw)
        addEventHandler('onClientClick', root, dialogue.functions.click)
    elseif not state and dialogue.ui.visible then
        dialogue.ui.visible = false
        showCursor(false)
        removeEventHandler('onClientRender', root, dialogue.functions.draw)
        removeEventHandler('onClientClick', root, dialogue.functions.click)
    end
end

addEvent("onDrawDialogue", true)
addEventHandler("onDrawDialogue", resourceRoot, function ()
    dialogue.functions.toggle(true)
end)