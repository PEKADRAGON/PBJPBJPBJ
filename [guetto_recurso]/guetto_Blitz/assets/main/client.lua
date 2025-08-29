local resource = {state = false, createdSpike = {}, sound = nil, previousPosition = nil}
local pos = Vector2(screen.x / 2 - respc(512 / 2), screen.y - respc(300))

local elements = {
    {pos.x + respc(42), pos.y + respc(87), respc(52), respc(52), 'Cone pequeno', pos.x + respc(21), pos.y + respc(150), respc(97), respc(20), 'assets/images/cone-pequeno.png', 1238};
    {pos.x + respc(171), pos.y + respc(89), respc(50), respc(50), 'Faixa de prego', pos.x + respc(148), pos.y + respc(150), respc(97), respc(20), 'assets/images/faixa-de-prego.png', 2892, length = 10.04, width = 1.23, height = 0.24};
    {pos.x + respc(293), pos.y + respc(88), respc(51), respc(51), 'Cone grande', pos.x + respc(270), pos.y + respc(150), respc(97), respc(20), 'assets/images/cone-grande.png', 1237};
    {pos.x + respc(418), pos.y + respc(88), respc(51), respc(51), 'Barreira', pos.x + respc(396), pos.y + respc(150), respc(97), respc(20), 'assets/images/barreira.png', 1228};
}

local function onDraw ()
    interpolate = lerp(interpolate or 0, resource.state and 1 or 0, 0.05)

    if interpolate <= 0.01 then
        return removeEventHandler('onClientRender', root, onDraw)
    end

    dxDrawImageSpacing(pos.x, pos.y, respc(512), respc(184), 5, 'assets/images/background.png', 0, 0, 0, tocolor(255, 255, 255, interpolate * 255))
    dxDrawText('Painel Blitz', pos.x + respc(52), pos.y + respc(12), respc(84), respc(24), tocolor(199, 199, 199, interpolate * 255), 1.0, exports['guetto_assets']:dxCreateFont('regular', respc(18 * 0.88)))
    dxDrawText('Utilize os botões do mouse para movimentar os objetos.', pos.x + respc(52), pos.y + respc(32), respc(84), respc(24), tocolor(94, 94, 94, interpolate * 255), 1.0, exports['guetto_assets']:dxCreateFont('regular', respc(15 * 0.88)))

    dxDrawImageSpacing(pos.x + respc(466), pos.y + respc(16), respc(30), respc(30), 3, 'assets/images/bin.png', 0, 0, 0, (isCursorOnElement(pos.x + respc(450), pos.y, respc(62), respc(62)) and tocolor(243, 182, 125, interpolate * 255) or tocolor(94, 94, 94, interpolate * 255)))
    
    for i, v in ipairs(elements) do 
        dxDrawImageSpacing(v[1], v[2], v[3], v[4], 3, v[10], 0, 0, 0, (isCursorOnElement(v[1], v[2], v[3], v[4]) and tocolor(243, 182, 125, interpolate * 255) or tocolor(94, 94, 94, interpolate * 255)))
        dxDrawText(v[5], v[6], v[7], v[8], v[9], (isCursorOnElement(v[1], v[2], v[3], v[4]) and tocolor(243, 182, 125, interpolate * 255) or tocolor(94, 94, 94, interpolate * 255)), 1.0, exports['guetto_assets']:dxCreateFont('regular', respc(16 * 0.88)), 'center', 'center')
    end

    if isCursorOnElement(pos.x + respc(450), pos.y, respc(62), respc(62)) then 
        dxDrawImageSpacing(pos.x + respc(433), pos.y - respc(40), respc(96), respc(31), 3, 'assets/images/info.png', 0, 0, 0, tocolor(255, 255, 255, interpolate * 255))
        dxDrawText('Deletar tudo', pos.x + respc(433), pos.y - respc(42), respc(96), respc(31), tocolor(255, 255, 255, interpolate * 255), 1.0, exports['guetto_assets']:dxCreateFont('regular', respc(13 * 0.88)), 'center', 'center')
    end

    if (resource.object and isElement(resource.object)) then
        if getKeyState('arrow_l') then 
            local pos = {getElementRotation(resource.object)}
            setElementRotation(resource.object, pos[1], pos[2], pos[3] - 1)

        elseif getKeyState('arrow_r') then 
            local pos = {getElementRotation(resource.object)}
            setElementRotation(resource.object, pos[1], pos[2], pos[3] + 1)

        elseif getKeyState('arrow_u') then 
            local pos = {getElementPosition(resource.object)}
            setElementPosition(resource.object, pos[1], pos[2], pos[3] + 0.1)
        elseif getKeyState('arrow_d') then
            local pos = {getElementPosition(resource.object)}
            setElementPosition(resource.object, pos[1], pos[2], pos[3] - 0.1)
        end
    end
end

local function onPlayerTogglePanel (state)
    if isPedInVehicle(localPlayer) then
        return false
    end

    if resource.state then 
        showCursor(false)
        resource.state = nil 
    else
        resource.state = true
        showCursor(true)
        addEventHandler('onClientRender', root, onDraw)
    end
end

bindKey('backspace', 'down', function()
    showCursor(false)
    resource.state = nil 
end)    

function objectBreakble (object)
    if isObjectBreakable(object) then
        setObjectBreakable(object, false)
    end
end

local objectsSpeaks = {}
local coolShape = {}

local function createSpike(element, object, position, rotation) 
    resource.createdSpike[(getElementData(element, 'ID') or 0)] = {}
    
    local rotated_x1, rotated_y1 = rotateAround(rotation - 1, -elements[2].width / 2, -elements[2].length / 2)
    local rotated_x2, rotated_y2 = rotateAround(rotation - 1, elements[2].width / 2, -elements[2].length / 2)
    local rotated_x3, rotated_y3 = rotateAround(rotation - 1, elements[2].width / 2, elements[2].length / 2)
    local rotated_x4, rotated_y4 = rotateAround(rotation - 1, -elements[2].width / 2, elements[2].length / 2)

    resource.createdSpike[(getElementData(element, 'ID') or 1)].col = createColPolygon(
        position[1], position[2],

        position[1] + rotated_x1,
        position[2] + rotated_y1,

        position[1] + rotated_x2,
        position[2] + rotated_y2,

        position[1] + rotated_x3,
        position[2] + rotated_y3,

        position[1] + rotated_x4,
        position[2] + rotated_y4
    )

    objectsSpeaks[resource.createdSpike[(getElementData(element, 'ID') or 1)].col] = object
    table.insert(coolShape, resource.createdSpike[(getElementData(element, 'ID') or 1)].col)

    addEventHandler('onClientColShapeHit', resource.createdSpike[(getElementData(element, 'ID') or 1)].col, onClientColShapeHit)
end

local function deleteSpike (element)
    for i, v in ipairs(coolShape) do 
        if isElement(v) then 
            destroyElement(v)
        end
    end

    resource.createdSpike[(getElementData(element, 'ID') or 0)] = nil
end

function onClientColShapeHit (vehicle, dimMatch)
    if (vehicle and getElementType(vehicle) == 'vehicle') then 
        if isElement(resource.sound) then 
            stopSound(resource.sound)
        end

        local position = {getElementPosition(vehicle)}
        resource.sound = playSound3D('assets/sounds/spike.wav', position[1], position[2], position[3] + 0.1, false)

        triggerServerEvent('squady.pierceWheel', resourceRoot, objectsSpeaks[source])
    end
end

local function onClientClick(button, state, _, _, _, _, _, object) 
    if (resource.state) then 
        if (button == 'left' and state == 'down') then 
            if isElement(object) then 
                if getElementType(object) == 'object' then 
                    if (getElementData(object, 'element:blitz') or false) ~= false then 
                        if not isElement(resource.object) then 
                            resource.object = object
                            createElementOutlineEffect(resource.object, true)
                            setElementCollisionsEnabled(resource.object, false)
                        end
                    end
                end
            end

            for i, v in ipairs(elements) do
                if isCursorOnElement(v[1], v[2], v[3], v[4]) then 
                    triggerServerEvent('squady.createBlitz', resourceRoot, v[11])
                end
            end

            if isCursorOnElement(pos.x + respc(450), pos.y, respc(62), respc(62)) then 
                triggerServerEvent('squady.deleteBlitz', resourceRoot)
            end
        end
    end

    if (button == 'left' and state == 'up') then 
        if (resource.object and isElement(resource.object)) then
            destroyElementOutlineEffect(resource.object)
            setElementCollisionsEnabled(resource.object, true)
            local pos = {getElementPosition(resource.object)}
            local rotation = {getElementRotation(resource.object)}
            triggerServerEvent('squady.moveObjectPosition', resourceRoot, resource.object, pos[1], pos[2], pos[3], rotation[1], rotation[2], rotation[3])
            resource.object = nil
        end
    end
end

local function onClientCursorMove ()
    if isCursorShowing() then 
        if (resource.object and isElement(resource.object)) then
            local screenx, screeny, worldx, worldy, worldz = getCursorPosition()
            local px, py, pz = getCameraMatrix()
            local hit, x, y, z, elementHit = processLineOfSight(px, py, pz, worldx, worldy, worldz)
            local tx, ty, tz = getElementPosition(localPlayer)
            local rx, ry, rz = getElementPosition(resource.object)

            if (x) and (y) and (z) then 
                local distance = getDistanceBetweenPoints3D(tx, ty, tz, x, y, z)
                
                if distance > 20 then
                    if resource.previousPosition then
                        setElementPosition(resource.object, unpack(resource.previousPosition))
                    end
                else
                    resource.previousPosition = { rx, ry, rz }
                    
                    if getElementModel(resource.object) == 2892 then
                        moveObject(resource.object, 20, x, y, z + 1)
                    elseif getElementModel(resource.object) == 1228 then
                        moveObject(resource.object, 20, x, y, z + 0.4)
                    elseif getElementModel(resource.object) == 1238 then
                        moveObject(resource.object, 20, x, y, z + 0.3)
                    elseif getElementModel(resource.object) == 1237 then
                        moveObject(resource.object, 20, x, y, z)
                    end
                end
            end
        end
    end     
end

registerEvent('squady.togglePanelBlitz', resourceRoot, onPlayerTogglePanel)
registerEvent('squady.objectBreakble', resourceRoot, objectBreakble)

registerEvent('squady.createSpike', resourceRoot, createSpike)
registerEvent('squady.deleteSpike', resourceRoot, deleteSpike)

addEventHandler('onClientClick', root, onClientClick)
addEventHandler('onClientCursorMove', root, onClientCursorMove)