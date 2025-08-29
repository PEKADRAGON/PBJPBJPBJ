local modal = {}

modal.panel = {}
modal.panel.isEventHandlerAdded = false

local modalPosition = Vector2(middle.x + 187 * scale, position.y - 129 * scale)

function drawModal ( )
    
    y = animation.get('modal-moviment')
    local alpha = animation.get('modal-alpha')

    dxDrawImage(modalPosition.x, y, 187 * scale, 117 * scale, 'images/rectangle-modal.png', 0, 0, 0, tocolor(23, 24,  30, alpha))
    
    dxDrawImage(modalPosition.x + 187 * scale / 2 - 156 * scale / 2, y + 22 * scale, 156 * scale, 36 * scale, 'images/input-value.png', 0, 0, 0, tocolor(37, 38, 46, alpha))
    dxDrawImage(modalPosition.x + 187 * scale / 2 - 156 * scale / 2, y + 68 * scale, 156 * scale, 33 * scale, 'images/rectangle-confirm.png', 0, 0, 0, isCursorOnElement(modalPosition.x + 187 * scale / 2 - 156 * scale / 2, y + 68 * scale, 156 * scale, 33 * scale) and button.exec('modal-confirm', 500, 166, 133, 103, alpha, alpha) or button.exec('modal-confirm', 500, 37, 38, 46, alpha, alpha))

    dxDrawText('CONFIRMAR', modalPosition.x + 187 * scale / 2 - 156 * scale / 2, y + 70 * scale, 156 * scale, 33 * scale, tocolor(211, 211, 211, alpha), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'center', 'center')
    dxCreateEditbox("EditBox:Money", {modalPosition.x + 187 * scale / 2 - 156 * scale / 2, y + 22 * scale, 156 * scale, 36 * scale}, 10, {211, 211, 211, alpha}, exports['guetto_assets']:dxCreateFont('regular', 15), 'VALOR', true, false, true, false, false)

    if not modal.panel.isEventHandlerAdded and alpha <= 0 then 
        dxEditboxDestroy("EditBox:Money")
        removeEventHandler('onClientRender', root, drawModal)
        showCursor(false)
    end
end

function toggleModal ( state )
    if state and not modal.panel.isEventHandlerAdded then 
        modal.panel.isEventHandlerAdded = true 
        
        if animation.isRunning('modal-alpha') then 
            return false 
        end

        animation.exec('modal-alpha', 0, 255, 500, 'Linear')
        animation.exec('modal-moviment', position.y - 117 * scale, modalPosition.y, 500, 'Linear')
        
        addEventHandler('onClientRender', root, drawModal)
    elseif not state and modal.panel.isEventHandlerAdded then 
        modal.panel.isEventHandlerAdded = false

        if animation.isRunning('modal-alpha') then 
            return false 
        end

        animation.exec('modal-alpha', 255, 0, 500, 'Linear')
        animation.exec('modal-moviment', modalPosition.y, position.y - 117 * scale, 500, 'Linear')
    end
end

function isModalEnable ( )
    return modal.panel.isEventHandlerAdded
end

addEventHandler('onClientResourceStart', resourceRoot, function()
    modal.panel.moviment = animation.new('modal-moviment', 0, modalPosition.y, 500, 'OutQuad', false)
    modal.panel.alpha = animation.new('modal-alpha', 0, 255, 500, 'OutQuad', false)
end)

addEventHandler('onClientClick', root, function(button, state)
    if button == 'left' and state == 'down' then 
        if modal.panel.isEventHandlerAdded then 
            if isCursorOnElement(modalPosition.x + 187 * scale / 2 - 156 * scale / 2, y + 68 * scale, 156 * scale, 33 * scale) then 

                if dxEditboxGetText("EditBox:Money").content == "VALOR" or dxEditboxGetText("EditBox:Money").content == "" then 
                    return sendMessageClient("Digite o valor!", "error") 
                end

                local res = getResourceDynamicElementRoot(getResourceFromName(getResourceName(getThisResource())))

                triggerServerEvent("onPlayerSendCash", res, {
                    element = instance.element,
                    amount = dxEditboxGetText("EditBox:Money").content,
                    type = instance.modal
                })
            end
        end
    end
end)

bindKey('backspace', 'down', function()
    if not dxEditBoxEnable("EditBox:Money") and isModalEnable() then 
        toggleModal(false)
    end
end)