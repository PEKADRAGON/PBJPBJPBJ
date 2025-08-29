local armaSkinTexture = {}

function setArmaStickerC(player, armaNome, armaId)
    if not armaSkinTexture[player] then
        armaSkinTexture[player] = {armaNome = armaNome, armaId = armaId}
    end
    applyArmaSticker(player)
end
addEvent('setArmaStickerC', true)
addEventHandler('setArmaStickerC', getRootElement(), setArmaStickerC)

function removerArmaStickerC(player)
    if armaSkinTexture[player] then
        destroyArmaSticker(player)
        armaSkinTexture[player] = nil
    end
end
addEvent('removerArmaStickerC', true)
addEventHandler('removerArmaStickerC', getRootElement(), removerArmaStickerC)

function applyArmaSticker(player)
    if armaSkinTexture[player] then
        local armaNome = armaSkinTexture[player].armaNome
        local armaId = armaSkinTexture[player].armaId
        
        armaSkinTexture[player].shader = dxCreateShader('files/fx/texturechanger.fx', 0, 100, false, 'ped')
        armaSkinTexture[player].texture = dxCreateTexture(armaId)

        if armaSkinTexture[player].shader and armaSkinTexture[player].texture then
            dxSetShaderValue(armaSkinTexture[player].shader, 'TEXTURE', armaSkinTexture[player].texture)
            engineApplyShaderToWorldTexture(armaSkinTexture[player].shader, '*' .. armaNome .. '*', player)
        end
    end
end

function destroyArmaSticker(player)
    if armaSkinTexture[player] then
        if armaSkinTexture[player].shader and isElement(armaSkinTexture[player].shader) then
            destroyElement(armaSkinTexture[player].shader)
        end
        if armaSkinTexture[player].texture and isElement(armaSkinTexture[player].texture) then
            destroyElement(armaSkinTexture[player].texture)
        end
    end
end

function onClientElementStreamIn()
    local elementType = getElementType(source)
    if elementType == 'player' then
        applyArmaSticker(source)
    end
end
addEventHandler('onClientElementStreamIn', root, onClientElementStreamIn)

function onClientElementStreamOut()
    local elementType = getElementType(source)
    if elementType == 'player' then
        destroyArmaSticker(source)
    end
end
addEventHandler('onClientElementStreamOut', root, onClientElementStreamOut)

function onClientResourceStart()
    for _, player in ipairs(getElementsByType('player', root, true)) do
        if isElementStreamedIn(player) then
            applyArmaSticker(player)
        end
    end
end
addEventHandler('onClientResourceStart', resourceRoot, onClientResourceStart)

function onClientPlayerQuit()
    local player = source
    removerArmaStickerC(player)
end
addEventHandler('onClientPlayerQuit', root, onClientPlayerQuit)
