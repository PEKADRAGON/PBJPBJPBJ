local destroy = {}

destroy.svg = {
    ['rectangle'] = svgCreate(425, 199, [[
        <svg width="425" height="199" viewBox="0 0 425 199" fill="none" xmlns="http://www.w3.org/2000/svg">
            <rect width="425" height="199" rx="20" fill="#121212" fill-opacity="0.9"/>
        </svg>
    ]]);
    ['button'] = svgCreate(168, 58, [[
        <svg width="168" height="58" viewBox="0 0 168 58" fill="none" xmlns="http://www.w3.org/2000/svg">
            <rect width="168" height="58" rx="7" fill="white"/>
        </svg>
    ]])
}

function destroy.render ()
    local alpha = interpolateBetween(destroy.alpha[1], 0, 0, destroy.alpha[2], 0, 0, ( getTickCount ( ) - destroy.alpha[3] ) / 400, 'OutQuad')

    dxDrawImage(747, 708, 425, 199, destroy.svg['rectangle'], 0, 0, 0, tocolor(255, 255, 255, alpha))

    dxDrawImage(785, 824, 168, 58, destroy.svg['button'], 0, 0, 0, isCursorOnElement(785, 824, 168, 58) and tocolor(193, 159, 114, alpha) or tocolor(34, 35, 35, alpha))
    dxDrawImage(966, 824, 168, 58, destroy.svg['button'], 0, 0, 0, isCursorOnElement(966, 824, 168, 58) and tocolor(193, 159, 114, alpha) or tocolor(34, 35, 35, alpha))

    dxDrawText("GUARDAR VEÍCULO", 785, 742, 151, 16, tocolor(193, 159, 114, alpha), 1, exports['guetto_assets']:dxCreateFont('bold', 16), 'left', 'top')
    dxDrawText("Deseja realmente guardar este carro?", 785, 770, 336, 24, tocolor(121, 121, 121, alpha), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'left', 'top')

    dxDrawText("NEGAR", 785, 824, 168, 58, tocolor(255, 255, 255, alpha), 1, exports['guetto_assets']:dxCreateFont('bold', 16), 'center', 'center')
    dxDrawText("ACEITAR", 966, 824, 168, 58, tocolor(255, 255, 255, alpha), 1, exports['guetto_assets']:dxCreateFont('bold', 16), 'center', 'center')

    if not destroy.visible and alpha <= 0 then 
        removeEventHandler('onClientRender', root, destroy.render)
    end
end

function destroy.click (button, state)
    if button == 'left' and state == 'down' then 
        if isCursorOnElement(966, 824, 168, 58) then 
            triggerServerEvent("onPlayerDestroyVehicle", resourceRoot, destroy.acl)
            destroy.toggle(false)
        elseif isCursorOnElement(785, 824, 168, 58) then 
            destroy.toggle(false)
        end
    end
end

function destroy.toggle (state)
    if state and not destroy.visible then
        destroy.visible = true
        destroy.alpha = {0, 255, getTickCount()}
        showCursor(true)
        showChat(false)

        addEventHandler('onClientRender', root, destroy.render)
        addEventHandler('onClientClick', root, destroy.click)
    elseif not state and destroy.visible then 
        destroy.visible = false 
        destroy.alpha = {255, 0, getTickCount()}
        
        showCursor(false)
        showChat(true)

        removeEventHandler('onClientClick', root, destroy.click)
    end
end

createEvent('toggleDestroyVehicle', resourceRoot, function(acl)
    destroy.acl = acl
    destroy.toggle(true)
end)