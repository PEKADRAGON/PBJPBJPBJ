local slots = {
    {935, 555, 248, 50, 962, 568, 24, 24, 1003, 572, 113, 16, label = "ABRIR BANCO", image = "assets/images/icon-bank.png"};
    {935, 612, 248, 50, 962, 622, 30, 30, 1003, 629, 125, 16, label = "ROUBAR CAIXA", image = "assets/images/icon-money.png"};
}

local alpha = {0, 0, 0}
local atm_index = false
local isEventHandlerAdded = false 

function interactionDraw ( )
    local fade = interpolateBetween(alpha[1], 0, 0, alpha[2], 0, 0, (getTickCount() - alpha[3]) / 400, 'Linear')

    for i, v in ipairs ( slots ) do 
        dxDrawImage(v[1], v[2], v[3], v[4], "assets/assault/rectangle.png", 0, 0, 0, isCursorOnElement(v[1], v[2], v[3], v[4]) and tocolor(193, 159, 114, fade) or tocolor(18, 18, 18, fade))
        dxDrawImage(v[5], v[6], v[7], v[8], v.image, 0, 0, 0, tocolor(255, 255, 255, fade))
        dxDrawText(v.label, v[9], v[10], v[11], v[12], tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("medium", 16), "center", "center")
    end
end

addEventHandler("onClientClick", root, function(button, state)
    if (button == "left" and state == "down" and isEventHandlerAdded) then 
        for i, v in ipairs ( slots ) do 
            if isCursorOnElement(v[1], v[2], v[3], v[4]) then 
                if (i == 1) then 
                    interfaceOpen()
                    interactionToggle(false)
                elseif (i == 2) then 
                    triggerServerEvent("Assault.Get.Item", resourceRoot, atm_index)
                    interactionToggle(false)
                end
                break 
            end
        end
    end
end)

function interactionToggle (state)
    if  cooldown and getTickCount() - cooldown <= 400 then return end
    if (state and not isEventHandlerAdded) then 
        isEventHandlerAdded = true 
        alpha = {0, 255, getTickCount()}
        showCursor(true)
        addEventHandler("onClientRender", root, interactionDraw)
    elseif not (state and isEventHandlerAdded) then 
        isEventHandlerAdded = false
        alpha = {255, 0, getTickCount()}
        showCursor(false)
        setTimer(function()
            removeEventHandler("onClientRender", root, interactionDraw)
        end, 400, 1)
    end
    cooldown = getTickCount()
end

addEvent("guetto.interaction", true)
addEventHandler("guetto.interaction", resourceRoot, 
    function (index)
        if not (isEventHandlerAdded) then 
            atm_index = index
            interactionToggle(true)
        end
    end
)


bindKey("backspace", "down",
    function ( )
        if (isEventHandlerAdded) then 
            interactionToggle(false)
        end
    end
)