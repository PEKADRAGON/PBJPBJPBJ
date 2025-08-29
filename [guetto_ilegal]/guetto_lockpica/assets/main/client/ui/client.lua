local screenWidth, screenHeight = getResponsiveValues()

local settings = getSettings()

local rendering = false
local toggleRender

local tickStart
local pinHit = 0
local pinValues = {}
local rot = 0

local nearestVehicle
local unlocked = {}

local parentW, parentH = respc(302), respc(260)
local parentX, parentY = (screenWidth - parentW) / 2, screenHeight - parentH - respc(25)

local barPositionX = new 'Animation'()
local barRotation = new 'Animation'()

local timeDuration = settings.time * 1000

local function generateRandomPinValues()
    local randomGap = math.random(10, 28)
    return {
        gap = randomGap,
        attempts = 4,
        c = 0,
        i = parentY + respc(80),
        f = parentY + respc(80)
    }
end

fonts = {
    ['poppins_regular14'] = dxCreateFont('assets/fonts/Poppins-Regular.ttf', respc(18 * 0.95)),
    ['poppins_regular13'] = dxCreateFont('assets/fonts/Poppins-Regular.ttf', respc(16)),
}

local function renderHandler()
    local timeElapsed = getTickCount() - tickStart
    local duration = timeElapsed / timeDuration

    dxDrawImage(parentX, parentY, parentW, parentH, 'assets/images/background.png')

    dxDrawText('Lockpick', parentX + respc(52), parentY + respc(10), respc(68), respc(24), tocolor(199, 199, 199, 255), 1.0, exports['guetto_assets']:dxCreateFont("regular", 16), 'left', 'top')
    dxDrawText('Mentalize #C19F72 #C19F72E #5E5E5E no tempo certo', parentX + respc(52), parentY + respc(31), respc(176), respc(19), tocolor(94, 94, 94, 255), 1.0, exports['guetto_assets']:dxCreateFont("regular", 14), 'left', 'top', false, false, false, true, false)

    dxDrawRectangle(parentX + respc(10), parentY + respc(248), respc(279), respc(2), tocolor(51, 46, 51, 255))

    local barTimeW = respc(279) / 100 * (100 - (duration * 100))
    dxDrawRectangle(parentX + respc(10), parentY + respc(248), math.max(barTimeW), respc(2), tocolor(193, 159, 114, 255))

    local gapX = 0
    for i = 1, 8 do
        local gapY = pinValues[i].gap
        local pinX = parentX + respc(14) + gapX
        local pinY = parentY + respc(80) + respc(gapY)

        pinValues[i].c = lerp(pinValues[i].i, pinValues[i].f, 0.1)
        pinValues[i].i = pinValues[i].c
        pinValues[i].f = pinY

        dxDrawRectangle(pinX + (respc(22) - respc(4)) / 2, parentY + respc(81), respc(4), respc(62), tocolor(51, 46, 51, 200))
        dxDrawImage(pinX, pinValues[i].c, respc(22), respc(107), 'assets/images/pin.png', 0, 0, 0, tocolor(255, 255, 255, 255))
    
        gapX = gapX + respc(36)
    end

    dxDrawImage(barPositionX:get(), parentY + respc(210), respc(162), respc(16), 'assets/images/bar.png', barRotation:get(), 0, 0, tocolor(255, 255, 255, 255))
    
    if (barPositionX:isFinish()) then
        local current = barPositionX:get()

        if (current >= parentX + respc(160)) then
            barPositionX:exec(current, parentX + respc(-140), 2000, 'Linear')
        else
            barPositionX:exec(current, parentX + respc(160), 2000, 'Linear')
        end
    end

    if (barRotation:isFinish()) then
        local current = barRotation:get() or 0

        if (current >= 0) then
            barRotation:exec(current, 0, 100, 'Linear')
        else
            barRotation:exec(current, 0, 100, 'Linear')
        end
    end

    for i = 1, 10 do
        local pin = pinValues[i]
        if (pin) then
            if (not (pin.gap > 0) and not unlocked[i] and pin.attempts <= 0) then
                unlocked[i] = true
            end
        end
    end

    if (#unlocked >= 10) then
        return toggleRender.hide()
    end

    if (duration >= 1) then
        return toggleRender.hide()
    end
end

local function keyHandler(k, p)
    if (not p) then return end

    if (k == 'e') then

        if cooldownClick then
            local tick = getTickCount()
            if tick < (cooldownClick + 200) then
                cancelEvent()
                return
            end
        end

        cooldownClick = getTickCount()
        
        local gapX = 0
        for i = 1, 8 do
            local pin = pinValues[i]
            local pinX = parentX + respc(14) + gapX
            local pinW = respc(22)
            local barX = (barPositionX:get() + respc(160 - 7))
            
            if (barX >= pinX and barX <= (pinX + pinW)) then
                if (pin.attempts > 0) then
                    pinHit = i
                    pin.attempts = pin.attempts - 1
                    local diff = pin.gap - 0
                    local reduce = diff ~= 0 and math.floor(diff / pin.attempts) or 0
                    pin.gap = math.max(pin.gap - reduce, 0)
                    break
                end
            end
            
            gapX = gapX + respc(36)
        end

        if (pinValues[pinHit]) then 
            local pinY = parentY + respc(104) + respc(pinValues[pinHit].gap)
            local barDiff = (pinY) - (parentY + parentH + respc(14))
            local rotation = math.deg(math.atan2(barDiff, respc(382)))
            barRotation:exec(rot, rotation, 100, 'Linear')
        end
        cancelEvent()
    else
        cancelEvent()
    end
end

toggleRender = {
    show = function()

        local vehicle = getNearestVehicle(localPlayer, 4)
        if (not vehicle) then
            return sendMessage('client', localPlayer, 'Você precisa estar próximo de um veículo para usar a LockPick.', 'error')
        end

        if (not isVehicleLocked(vehicle)) then
            return sendMessage('client', localPlayer, 'Este veículo já está destravado', 'error')
        end

        if (rendering) then return end

        nearestVehicle = vehicle

        triggerServerEvent('removeLockPick', resourceRoot)
        triggerServerEvent('onPlayerChangeAnimation', resourceRoot, true)

        for i = 1, 10 do
            pinValues[i] = generateRandomPinValues()
        end

        tickStart = getTickCount()
        barPositionX:exec(parentX + respc(-140), parentX + respc(160), 2000, 'Linear')

        toggleControl('jump', false)

        addEventHandler('onClientRender', root, renderHandler)
        addEventHandler('onClientKey', root, keyHandler)
        rendering = true
        unlocked = {}

    end,

    hide = function()
        if (not rendering) then return end

        tickStart = nil
        toggleControl('jump', true)

        removeEventHandler('onClientRender', root, renderHandler)
        removeEventHandler('onClientKey', root, keyHandler)
        rendering = false
         
        for i = 1, 8 do
            local pin = pinValues[i]
            if (pin) then
                if (pin.gap > 0) then
                    triggerServerEvent('onPlayerChangeAnimation', resourceRoot, false)
                    return sendMessage('client', localPlayer, 'Você não conseguiu destravar o veículo.', 'error')
                end
            end
        end

        triggerServerEvent('onPlayerChangeAnimation', resourceRoot, false)
        triggerServerEvent('onServerLockpick', resourceRoot, nearestVehicle)
        nearestVehicle = nil
    end
}

function useLockPick()
    if (rendering) then return end
    toggleRender.show()
end

addEvent('useLockPick', true)
addEventHandler('useLockPick', root, useLockPick)