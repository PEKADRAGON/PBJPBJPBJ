local assault = {
    isEventHandlerAdded = false,
    animations = {0, 0, 0},
    timer = false,
    acertos = 0
}

local alpha = {0, 0, 0}
local index = false

local letters = {}
local current = false 

function assaultDraw ( )

    local time = interpolateBetween(assault.animations[2], 0, 0, assault.animations[1], 0, 0, (getTickCount() - assault.animations[3]) / assault.animations[2], 'Linear')
    local fade = interpolateBetween(alpha[1], 0, 0, alpha[2], 0, 0, (getTickCount() - alpha[3]) / 400, 'Linear')

    local minutes, seconds = convertTime (time)

    dxDrawImage(837, 370, 243, 243, "assets/assault/fundo.png", 0, 0, 0, tocolor(255, 255, 255, fade))
    dxDrawImage(916, 441, 87, 87, "assets/assault/effect.png", 0, 0, 0, tocolor(255, 255, 255, fade))
    dxDrawImage(908, 438, 94, 94, "assets/assault/bomb.png", 0, 0, 0, tocolor(255, 255, 255, fade))

    dxDrawCustomCircle('bg', 878, 409, 163, {start = 90, sweep = 0}, {'#232323', 0}, {'#232323', 1, 3}, {1, 1})
    dxDrawCustomCircle('timer', 878, 409, 163, {start = 90, sweep = 0}, {'#C19F72', 0}, {'#C19F72', 1, 3}, {time, assault.animations[2]})
    
    for i, v in ipairs (slots) do 
        
        if (v[5] == true) then 
            dxDrawImage(v[1], v[2], v[3], v[4], "assets/assault/circle.png", 0, 0, 0, tocolor(42, 68, 29, fade))
            dxDrawImage(v[1], v[2], v[3], v[4], "assets/assault/stroke.png", 0, 0, 0, tocolor(146, 251, 97, fade))
        else
            dxDrawImage(v[1], v[2], v[3], v[4], "assets/assault/circle.png", 0, 0, 0, tocolor(18, 18, 18, 0.80 * fade))
            dxDrawImage(v[1], v[2], v[3], v[4], "assets/assault/stroke.png", 0, 0, 0, tocolor(217, 217, 217, fade))
        end

    end
    
    dxDrawText(minutes..":"..seconds, 944, 534, 31, 20, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("light", 15), "center", "center")

    for i, v in ipairs(letters) do 
        local pos = slots[i]
        dxDrawText(v, pos[1], pos[2] + 3, pos[3], pos[4], tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("medium", 16), "center", "center")
    end
    
    if (time <= 0) then 
        assaultToggle(false)
    end

    dxDrawText("FINALIZE A QUEST PARA INICIAR O ROUBO.", 791, 637, 337, 20, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("medium", 17), "center", "center")
    dxDrawText("Pressione a tecla que aparece nos 4 cantos para instalar a bomba no caixa eletrônico. ", 797, 670, 326, 40, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("light", 13), "center", "center", false, true)

    current = time
end 

function onKey(button, state)
    if assault.isEventHandlerAdded then 
        local bool, index = getKeyExists(button)
        if button and state then
            if (bool) then 
                assault.acertos = assault.acertos + 1
                if (assault.acertos >= 4) then 
                    assaultToggle(false)
                    triggerServerEvent("AssaultFinish", resourceRoot, _index)
                end
                slots[index][5] = true
            else
                assault.animations[2] = current -  2000
            end
        end
    end
end

function getKeyExists(key)
    for i, v in ipairs(letters) do 
        if (string.lower(v) == string.lower(key) and not slots[i][5]) then 
            return true, i
        end
    end
    return false
end
function assaultToggle (state)

    if (spam and getTickCount() - spam <= 400) then 
        return false 
    end

    if (state and not assault.isEventHandlerAdded) then 

        slots = {
            {838, 467, 47, 47, false};
            {937, 369, 47, 47, false};
            {1031, 467, 47, 47, false};
            {937, 563, 47, 47, false};
        }

        assault.isEventHandlerAdded = true 
        assault.acertos = 0

        assault.animations = {0, config["assault"]["time"] * 1000, getTickCount()}
        alpha = {0, 255, getTickCount()}
        
        createRandomLetters()

        addEventHandler("onClientRender", root, assaultDraw)
        addEventHandler("onClientKey", root, onKey)

    elseif not (state and assault.isEventHandlerAdded) then 
        setElementFrozen(localPlayer, false)
        triggerServerEvent("AssaultFailed", resourceRoot)
        removeEventHandler("onClientKey", root, onKey)
        assault.isEventHandlerAdded = false 
        setTimer(function()
            removeEventHandler("onClientRender", root, assaultDraw)
            circles = {}
        end, 400, 1)
    end
    spam = getTickCount()
end

addEvent("AssaultMiniGameToggle", true)
addEventHandler("AssaultMiniGameToggle", resourceRoot,  
    function (index)
        assaultToggle(true)
        _index = index
    end
)

function createRandomLetters( )
    for i = 1, 4 do 
        local random = math.random(#config["assault"]["letters"])
        letters[i] = config["assault"]["letters"][random]
    end
    return letters
end
