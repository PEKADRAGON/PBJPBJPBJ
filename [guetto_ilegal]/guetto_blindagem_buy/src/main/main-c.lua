--| Vars

screenW, screenH = guiGetScreenSize()
sx, sy = (screenW/1920), (screenH/1080)

--/ Ator

function aToR(X, Y, sX, sY)
    local xd = X/1920 or X
    local yd = Y/1080 or Y
    local xsd = sX/1920 or sX
    local ysd = sY/1080 or sY
    return xd * screenW, yd * screenH, xsd * screenW, ysd * screenH
end

_dxDrawCircle = dxDrawCircle
function dxDrawCircle(x, y, w, h, ...)
    local x, y, w, h = aToR(x, y, w, h)
    return _dxDrawCircle(x, y, w, h, ...)
end


_dxDrawRectangle = dxDrawRectangle
function dxDrawRectangle(x, y, w, h, ...)
    local x, y, w, h = aToR(x, y, w, h)
    return _dxDrawRectangle(x, y, w, h, ...)
end

_dxDrawText = dxDrawText
function dxDrawText(text, x, y, w, h, ...)
    local x, y, w, h = aToR(x, y, w + x, h + y)
    return _dxDrawText(text, x, y, w, h, ...)
end

_dxDrawImage = dxDrawImage
function dxDrawImage(x, y, w, h, ...)
    local x, y, w, h = aToR(x, y, w, h)
    return _dxDrawImage(x, y, w, h, ...)
end

_dxDrawImageSection = dxDrawImageSection
function dxDrawImageSection(x, y, w, h, ...)
    local x, y, w, h = aToR(x, y, w, h)
    return _dxDrawImageSection(x, y, w, h, ...)
end

function isCursorOnElement (x, y, w, h)
    local x, y, w, h = aToR(x, y, w, h)
    if isCursorShowing() then
        local mx, my = getCursorPosition()
        local resx, resy = guiGetScreenSize()
        mousex, mousey = mx * resx, my * resy
        if mousex > x and mousex < x + w and mousey > y and mousey < y + h then
            return true
        else
            return false
        end
    end
end

local ui = {}

ui.svgs = {
    ['rectangle'] = svgCreate(444, 197, [[
        <svg width="444" height="197" viewBox="0 0 444 197" fill="none" xmlns="http://www.w3.org/2000/svg">
            <rect width="444" height="197" rx="20" fill="#121212" fill-opacity="0.95"/>
        </svg>
    ]]);
    ['button'] = svgCreate(356, 51, [[
        <svg width="356" height="51" viewBox="0 0 356 51" fill="none" xmlns="http://www.w3.org/2000/svg">
        <rect width="356" height="51" rx="2" fill="white"/>
        </svg>
    ]]);
}

function ui.draw ( )
    local alpha = interpolateBetween(ui.alpha[1], 0, 0, ui.alpha[2], 0, 0, (getTickCount ( ) - ui.alpha[3]) / 400, 'OutQuad')

    dxDrawImage(720, 665, 444, 197, ui.svgs['rectangle'], 0, 0, 0, tocolor(255, 255, 255, alpha))
    dxDrawImage(764, 786, 356, 51, ui.svgs['button'], 0, 0, 0, isCursorOnElement(764, 786, 356, 51) and tocolor(56, 57, 57, alpha) or tocolor(34, 35, 35, alpha))

    dxDrawText("BLINDAGEM", 764, 691, 94, 16, tocolor(193, 159, 114, alpha), 1, exports['guetto_assets']:dxCreateFont('bold', 15), 'left', 'top');

    dxDrawText("Deseja blindar este veículo?", 764, 712, 364, 52, tocolor(121, 121, 121, alpha), 1, exports['guetto_assets']:dxCreateFont('regular', 17), 'left', 'top');
    dxDrawText("R$ ".. formatNumber(ui.price, "."), 764, 740, 364, 52, tocolor(255, 255, 255, alpha), 1, exports['guetto_assets']:dxCreateFont('regular', 18), 'left', 'top');
    dxDrawText("CONFIRMAR", 764, 786, 356, 51, tocolor(255, 255, 255, alpha), 1, exports['guetto_assets']:dxCreateFont('bold', 18), 'center', 'center');

    if not ui.visible and alpha <= 0 then 
        removeEventHandler('onClientRender', root, ui.draw)
    end
end

addEventHandler("onClientClick", root, function(button, state)
    if (button == "left" and state == "down") then 
        if ui.visible then 
            if isCursorOnElement(764, 786, 356, 51) then 
                triggerServerEvent("guetto_blindagem:buy", resourceRoot)
                ui.toggle(false)
            end
        end
    end
end)

function ui.toggle(state)
    if state and not ui.visible then 
        ui.visible = true 
        ui.alpha = {0, 255, getTickCount()}
        showCursor(true)
        showChat(false)
        addEventHandler('onClientRender', root, ui.draw)
    elseif not state and ui.visible then 
        ui.visible = false 
        ui.alpha = {255, 0, getTickCount()}

        showChat(true)
        showCursor(false)
    end
end

createEvent("guetto_blindagem:open", resourceRoot, function (model)
    ui.price = config["Modelos"][model] or config["Modelos"]["Default"]
    ui.toggle(true)
end)