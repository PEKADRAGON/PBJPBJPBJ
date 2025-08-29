local fonts = {
    ['RobotoCondensed-Medium'] = dxCreateFont('files/fonts/RobotoCondensed-Medium.ttf', 8),
    ['RobotoCondensed-Medium1'] = dxCreateFont('files/fonts/RobotoCondensed-Medium.ttf', 9),
}

local selects = {
    {569, 322, 228, 19},
    {569, 345, 228, 19},
    {569, 369, 228, 19},
    {569, 392, 228, 19},
}

local selects_text = {
    {609, 324, 45, 14},
    {609, 348, 45, 14},
    {609, 372, 45, 14},
    {609, 394, 45, 14},
}

local selects_text1 = {
    {714, 324, 45, 14},
    {714, 348, 45, 14},
    {714, 372, 45, 14},
    {714, 394, 45, 14},
}

function dxDraw()
    dxDrawImage(569, 266, 228, 235, 'files/images/base.png', 0, 0, 0, tocolor(255, 255, 255, 255), false)
    dxDrawText('X', 749, 274, 45, 14, tocolor(255, 255, 255, 255), 1.00, fonts['RobotoCondensed-Medium1'], 'center', 'center', false, false, false, false, false)
    linha = 0 
    for i,v in ipairs(config['Veiculos']) do
        if (i > proxPage and linha < #selects) then
            linha = linha + 1
            if selectVeh == i then
                dxDrawImage(selects[linha][1], selects[linha][2], selects[linha][3], selects[linha][4], 'files/images/select.png', 0, 0, 0, tocolor(255, 255, 255, 100), false)
            else
                dxDrawImage(selects[linha][1], selects[linha][2], selects[linha][3], selects[linha][4], 'files/images/select.png', 0, 0, 0, tocolor(29, 29, 29, 255), false)
            end
            dxDrawText(v[1], selects_text[linha][1], selects_text[linha][2], selects_text[linha][3], selects_text[linha][4], tocolor(255, 255, 255, 255), 1.00, fonts['RobotoCondensed-Medium1'], 'center', 'center', false, false, false, false, false)
            dxDrawText('R$'..v[3], selects_text1[linha][1], selects_text1[linha][2], selects_text1[linha][3], selects_text1[linha][4], tocolor(255, 255, 255, 255), 1.00, fonts['RobotoCondensed-Medium1'], 'center', 'center', false, false, false, false, false)
        end
    end
    if isCursorOnElement(628, 469, 118, 19) then 
        dxDrawImage(628, 469, 118, 19, 'files/images/button.png', 0, 0, 0, tocolor(139, 0, 255, 255), false)
    else 
        dxDrawImage(628, 469, 118, 19, 'files/images/button.png', 0, 0, 0, tocolor(29, 29, 29, 255), false)
    end
    dxDrawText('Alugar', 664, 472, 45, 14, tocolor(255, 255, 255, 255), 1.00, fonts['RobotoCondensed-Medium1'], 'center', 'center', false, false, false, false, false)
end

function openBarcos()
    if not isEventHandlerAdded('onClientRender', root, dxDraw) then
        addEventHandler('onClientRender', root, dxDraw)
        showCursor(true)
        proxPage = 0
    end
end
addEvent('Schootz.openBarcos', true)
addEventHandler('Schootz.openBarcos', root, openBarcos)

function closeBarcos()
    if isEventHandlerAdded('onClientRender', root, dxDraw) then
        removeEventHandler('onClientRender', root, dxDraw)
        showCursor(false)
    end
end

function clickFunctions(button, state)
    if button == "left" and state == "down" then
        if isEventHandlerAdded("onClientRender", root, dxDraw) then
            linha = 0
            for i, v in ipairs(config['Veiculos']) do
                if (i > proxPage and linha < #selects) then
                    linha = linha + 1
                    if isCursorOnElement(selects[linha][1], selects[linha][2], selects[linha][3], selects[linha][4]) then
                        selectVeh = i
                    end
                end
            end
            if isCursorOnElement(628, 469, 118, 19) then
                if selectVeh then
                    triggerServerEvent('Schootz.alugarVehicle', localPlayer, localPlayer, selectVeh)
                    selectVeh = 0
                end
            end
            if isCursorOnElement(749, 274, 45, 14) then
                closeBarcos()
            end
        end
    end 
end
addEventHandler("onClientClick", root, clickFunctions)

-- Funções uteis --

function isEventHandlerAdded(sEventName, pElementAttachedTo, func)
    if type( sEventName ) == 'string' and isElement( pElementAttachedTo ) and type( func ) == 'function' then
        local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
        if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
            for i, v in ipairs( aAttachedFunctions ) do
                if v == func then
                    return true
                end
            end
        end
    end
    return false
end