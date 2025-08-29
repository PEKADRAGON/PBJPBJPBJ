assets = exports['guetto_assets']

local Global = {
    ['Panel'] = {
        ['isEventHandlerAdded'] = false,
        ['alpha'] = {0, 0, 0},
        ['animation'] = {},
        ["modal"] = false;
        ['sequence'] = 1,
        ['interpolate'] = {},
        ["modal_alpha"] = {};
        ['animation_tick'] = {},
        ['page'] = 0,
    }
}

local slots = {
    {265, 922, 262, 99},
    {531, 922, 262, 99},
    {797, 922, 262, 99},
    {1063, 922, 262, 99},
    {1329, 922, 262, 99}
}

local categories = {
    {73, 260, 55, 55, 'CARROS'};
    {73, 344, 55, 55, 'MOTOS'};
    {73, 429, 55, 55, 'ESPECIAIS'};
    {73, 514, 55, 55, 'EXCLUSIVO'};
}

function getVehicleSpecs ( vehicle )
    if not vehicle or not isElement(vehicle) then
        return false 
    end;
    local capacity = getVehicleSpace(vehicle);
    local engine = getVehicleHandling(vehicle).engineAcceleration;

    return capacity, engine
end

local function draw()
    local currentTick = getTickCount()

    local fade = interpolateBetween(
        Global.Panel.alpha[1], 0, 0,
        Global.Panel.alpha[2], 0, 0,
        (getTickCount() - Global.Panel.alpha[3]) / 400,
        'Linear'
    )
    
    Global.Panel.interpolate[Global.Panel.sequence] = interpolateBetween(
        Global.Panel.animation[1], 0, 0,
        Global.Panel.animation[2], 0, 0,
        (currentTick - Global.Panel.animation[3]) / 600,
        'InOutQuad'
    )
    
    local seta_up = interpolateBetween(220, 0, 0, 215, 0, 0, (getTickCount() - Global.Panel.alpha[3]) / 900, 'SineCurve')
    local seta_down = interpolateBetween(576, 0, 0, 581, 0, 0, (getTickCount() - Global.Panel.alpha[3]) / 900, 'SineCurve')

    dxDrawImage(74, seta_down, 54, 31, 'assets/images/arrow.png', 180, 0, 0, tocolor(255, 255, 255, fade))
    dxDrawImage(74, seta_up, 54, 31, 'assets/images/arrow.png', 0, 0, 0, tocolor(255, 255, 255, fade))
    
    for i, v in ipairs(slots) do
        local data = config.vehicles[config['Others']['categorys'][Global.Panel.window]][i + Global.Panel.page]
        if data then
            if Global.Panel.sequence == i then
                dxDrawImage(v[1], Global.Panel.interpolate[Global.Panel.sequence], v[3], v[4], 'assets/images/slot.png', 0, 0, 0, tocolor(193, 159, 114, 0.94 * fade))
            elseif Global.Panel.sequence - 1 == i then
                if not Global.Panel.animation_tick[Global.Panel.sequence - 1] then
                    Global.Panel.animation_tick[Global.Panel.sequence - 1] = getTickCount()
                end
                Global.Panel.interpolate[Global.Panel.sequence - 1] = interpolateBetween(
                    906, 0, 0, 922, 0, 0,
                    (currentTick - Global.Panel.animation_tick[Global.Panel.sequence - 1]) / 600,
                    'InOutQuad'
                )
                dxDrawImage(v[1], Global.Panel.interpolate[Global.Panel.sequence - 1], v[3], v[4], 'assets/images/slot.png', 0, 0, 0, tocolor(18, 18, 18, 0.94 * fade))
            else
                dxDrawImage(v[1], v[2], v[3], v[4], 'assets/images/slot.png', 0, 0, 0, tocolor(18, 18, 18, 0.94 * fade))
            end
            dxDrawText(data.name, v[1] + 20, Global.Panel.sequence == i and Global.Panel.interpolate[Global.Panel.sequence] + 15 or Global.Panel.sequence - 1 == i and Global.Panel.interpolate[Global.Panel.sequence - 1] + 15 or v[2] + 15, 95, 26, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('bold', 15), 'left', 'top')
            dxDrawText(data.brand, v[1] + 20, Global.Panel.sequence == i and Global.Panel.interpolate[Global.Panel.sequence] + 44 or Global.Panel.sequence - 1 == i and Global.Panel.interpolate[Global.Panel.sequence - 1] + 44 or v[2] + 44, 95, 26, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'left', 'top')
            dxDrawText(Global.Panel.Estoque[config['Others']['categorys'][Global.Panel.window]][i + Global.Panel.page].Estoque, v[1] + 208, Global.Panel.sequence == i and Global.Panel.interpolate[Global.Panel.sequence] + 17 or Global.Panel.sequence - 1 == i and Global.Panel.interpolate[Global.Panel.sequence - 1] + 17 or v[2] + 17, 95, 26, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'left', 'top')
        end
    end

    for i, v in ipairs ( categories ) do 
        
        dxDrawImage(v[1], v[2], v[3], v[4], 'assets/images/circle.png', 0, 0, 0, tocolor(18, 18, 18, fade))
        dxDrawImage(v[1] + v[3] / 2 - 28 / 2, v[2] + v[4] / 2 - 28 /2, 28, 28, 'assets/images/'..v[5]..'.png', 0, 0, 0, tocolor(255, 255, 255, fade))

        if (config['Others']['categorys'][Global.Panel.window] == v[5]) then 
            dxDrawImage(v[1] + v[3] / 2 - 84 / 2, v[2] + v[4] / 2 - 84 / 2, 84, 84, 'assets/images/engine.png', Global.Panel.rotation, 0, 0, tocolor(189, 189, 189, fade))
            dxDrawText(config['Description'][v[5]], 155, v[2] + 28, 95, 26, tocolor(211, 211, 211, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'left', 'top')
            dxDrawText(v[5], 155, v[2] + 4, 95, 26, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('medium', 16), 'left', 'top')
            Global.Panel.rotation = Global.Panel.rotation + 1
        end
    end

    dxDrawImage(1571, 200, 299, 184, 'assets/images/rectangle-specs.png', 0, 0, 0, tocolor(18, 18, 18, fade))
    dxDrawImage(1571, 400, 299, 175, 'assets/images/rectangle-specs.png', 0, 0, 0, tocolor(18, 18, 18, fade))
    dxDrawImage(1571, 586, 299, 83, 'assets/images/rectangle-specs.png', 0, 0, 0, tocolor(18, 18, 18, fade))
    
    dxDrawImage(782, 830, 292, 68, 'assets/images/rectangle-price.png', 0, 0, 0, tocolor(255, 255, 255, fade))

    if (config.vehicles[config['Others']['categorys'][Global.Panel.window]][Global.Panel.sequence + Global.Panel.page].money) then 
        dxDrawText('R$ '..formatNumber(config.vehicles[config['Others']['categorys'][Global.Panel.window]][Global.Panel.sequence + Global.Panel.page].money, '.'), 782, 834, 292, 68, tocolor(30, 161, 111, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 26), 'center', 'center')
    elseif  (config.vehicles[config['Others']['categorys'][Global.Panel.window]][Global.Panel.sequence + Global.Panel.page].coins) then 
        dxDrawText('Gemas '..formatNumber(config.vehicles[config['Others']['categorys'][Global.Panel.window]][Global.Panel.sequence + Global.Panel.page].coins, '.'), 782, 834, 292, 68, tocolor(193, 159, 114, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 26), 'center', 'center')
    end

    -- Spec´s 

    dxDrawText('Especificações', 1587, 216, 99, 19, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'left', 'top')

    dxDrawText('Pressione enter para comprar o veículo', 1686, 694, 151, 38, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'left', 'top', false, true)
    dxDrawText('Pressione control para\niniciar o teste drive.', 1686, 765, 151, 38, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'left', 'top', false)

    dxDrawImage(1593, 258, 15, 16, 'assets/images/engine-icon.png', 0, 0, 0, tocolor(255, 255, 255, fade))
    dxDrawImage(1593, 314, 15, 16, 'assets/images/weight-icon.png', 0, 0, 0, tocolor(255, 255, 255, fade))

    dxDrawText('Motor', 1614, 255, 58, 19, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'left', 'top')
    dxDrawText('Espaço', 1614, 311, 58, 19, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'left', 'top')

    dxDrawText('Opacidade', 1588, 600, 88, 19, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'left', 'top')

    dxDrawImage(0, 0, 1920, 128, 'assets/images/banner.png', 0, 0, 0, tocolor(255, 255, 255, fade))
    dxDrawImage(829, 32, 263, 42, 'assets/images/conce-text.png', 0, 0, 0, tocolor(255, 255, 255, fade))
    
    dxDrawImage(184, 948, 60, 48, 'assets/images/button.png', 0, 0, 0, tocolor(255, 255, 255, fade))
    dxDrawImage(1612, 948, 60, 48, 'assets/images/button.png', 0, 0, 0, tocolor(255, 255, 255, fade))

    dxDrawText('Q', 184, 948, 60, 48, tocolor(18, 18, 18, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 25), 'center', 'center')
    dxDrawText('E', 1612, 948, 60, 48, tocolor(18, 18, 18, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 25), 'center', 'center')

    slidebar.create('slidebar.opacity', 1591, 637, 260, 6, 15, 15, 'assets/images/rectangle-slide.png', 'assets/images/icon-circle.png', fade, 255)
    local slide_percent = slidebar.getValue('slidebar.opacity')

    dxDrawText(slide_percent..'%', 1762, 600, 88, 19, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'right', 'top')

    if (vehicle and isElement(vehicle)) then 
        local r, g, b, a = colorpicker.getColor('colorpicker:vehicle', slide_percent)
        local r1,g1,b1,r2,g2,b2,r3,g3,b3,r4,g4,b4 = getVehicleColor(vehicle,true)
        setVehicleColor(vehicle,r,g,b,r2,g2,b2,r3,g3,b3,r4,g4,b4)
    end

    dxDrawImage(1571, 697, 99, 40, 'assets/images/button-action.png', 0, 0, 0, tocolor(255, 255, 255, fade))
    dxDrawImage(1571, 768, 99, 40, 'assets/images/button-action.png', 0, 0, 0, tocolor(255, 255, 255, fade))

    dxDrawText('ENTER', 1571, 697, 99, 40, tocolor(18, 18, 18, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'center', 'center')
    dxDrawText('CNTRL', 1571, 768, 99, 40, tocolor(18, 18, 18, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'center', 'center')

    if Global.Panel.modal then 
        local alpha = interpolateBetween(Global.Panel.modal_alpha[1], 0, 0, Global.Panel.modal_alpha[2], 0, 0, (getTickCount( ) - Global.Panel.modal_alpha[3]) / 400, 'Linear')
        local y = interpolateBetween(Global.Panel.modal[1], 0, 0, Global.Panel.modal[2], 0, 0, (getTickCount (  ) - Global.Panel.modal[3]) / 400, 'Linear')
   
        dxDrawImage(720, y, 479, 382, 'assets/images/modal.png', 0, 0, 0, tocolor(18, 18, 18, alpha))
        dxDrawText('CONFIRMAR COMPRA', 877, y + 36, 164, 23, tocolor(193, 159, 114, fade), 1, exports['guetto_assets']:dxCreateFont('bold', 17), 'center', 'top')
        dxDrawText('Você deseja realmente comprar um \n'..(Global.Panel.dados_veh.name)..' por:', 773, y + 68, 373, 44, tocolor(255, 255, 255, alpha), 1, exports['guetto_assets']:dxCreateFont('regular', 17), 'center', 'top')

        if (Global.Panel.dados_veh.money) then 
            dxDrawText('R$ '..formatNumber(Global.Panel.dados_veh.money, '.'), 780, y + 136, 373, 44, tocolor(30, 161, 111, alpha), 1, exports['guetto_assets']:dxCreateFont('regular', 25), 'center', 'top')
        elseif (Global.Panel.dados_veh.coins) then
            dxDrawText('Gemas '..formatNumber(Global.Panel.dados_veh.coins, '.'), 780, y + 136, 373, 44, tocolor(193, 159, 114, alpha), 1, exports['guetto_assets']:dxCreateFont('regular', 25), 'center', 'top')
        end

        dxDrawImage(771, y + 217, 378, 56, 'assets/images/button-modal.png', 0, 0, 0, isCursorOnElement(771, y + 217, 378, 56) and tocolor(193, 159, 114, alpha) or tocolor(42, 42, 48, alpha))
        dxDrawImage(771, y + 279, 378, 56, 'assets/images/button-modal.png', 0, 0, 0, isCursorOnElement(771, y + 279, 378, 56) and tocolor(193, 159, 114, alpha) or tocolor(42, 42, 48, alpha))

        dxDrawText('CONFIRMAR', 771, y + 217+2, 378, 56, tocolor(255, 255, 255, alpha), 1, exports['guetto_assets']:dxCreateFont('regular', 16), 'center', 'center')
        dxDrawText('DESISTIR', 771, y + 279+2, 378, 56, tocolor(255, 255, 255, alpha), 1, exports['guetto_assets']:dxCreateFont('regular', 16), 'center', 'center')
    end

    dxDrawRectangle(1588, 282, 265, 5, tocolor(217, 217, 217, 0.15 * fade))
    dxDrawRectangle(1588, 338, 265, 5, tocolor(217, 217, 217, 0.15 * fade))

    
    if (vehicle and isElement(vehicle)) then 
        local capacity, engine = getVehicleSpecs(vehicle)

        local capacity_animation = interpolate(0, capacity, 0.05, 'capacity')
        local engine_animation = interpolate(0, engine, 0.05, 'engine')
    
        capacity_animation = math.min(capacity_animation, capacity)
        engine_animation = math.min(engine_animation, engine)

        local capacity_bar_width = 100 * (capacity_animation / capacity)
        local engine_bar_width = 100 * (engine_animation / engine)
    
        dxDrawRectangle(1588, 282, capacity_bar_width, 5, tocolor(193, 159, 114, fade))
        dxDrawRectangle(1588, 338, engine_bar_width, 5, tocolor(193, 159, 114, fade))

        dxDrawText(math.floor(engine_animation)..'KM', 1805, 256, 48, 23, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'right', 'top')
        dxDrawText(math.floor(capacity_animation)..'Kg', 1805, 312, 48, 23, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'right', 'top')
    end

end

function onClientKey(button, state)
    if state then
        if not (Global.Panel.modal) then 
            if button == 'e' then
                if (Global.Panel.sequence + Global.Panel.page) < #config.vehicles[config['Others']['categorys'][Global.Panel.window]] then
                    Global.Panel.sequence = Global.Panel.sequence + 1
                    Global.Panel.animation = {922, 906, getTickCount()}
                    if Global.Panel.sequence > 5 then
                        Global.Panel.sequence = 1
                        Global.Panel.page = Global.Panel.page + 5
                    end
                    createVehicleConce ()
                end
            elseif button == 'q' then
                if Global.Panel.sequence > 1 then
                    Global.Panel.sequence = Global.Panel.sequence - 1
                    Global.Panel.animation = {922, 906, getTickCount()}
                    createVehicleConce ()
                elseif Global.Panel.page > 0 then
                    Global.Panel.sequence = 5
                    Global.Panel.page = Global.Panel.page - 5
                    Global.Panel.animation = {922, 906, getTickCount()}
                    createVehicleConce ()
                end
            elseif button == 'arrow_u' then 
                if (Global.Panel.window > 1) then 
                    Global.Panel.sequence = 1
                    Global.Panel.page = 0
                    Global.Panel.window = Global.Panel.window - 1
                    createVehicleConce()
                    setCameraMatrix(unpack(config['Matrix'][config['Others']['categorys'][Global.Panel.window]].camera))
                end
            elseif button == 'arrow_d' then 
                if (Global.Panel.window > 0 and Global.Panel.window < #config['Others']['categorys']) then 
                    Global.Panel.sequence = 1
                    Global.Panel.page = 0
                    Global.Panel.window = Global.Panel.window + 1
                    createVehicleConce()
                    setCameraMatrix(unpack(config['Matrix'][config['Others']['categorys'][Global.Panel.window]].camera))
                end 
            elseif button == 'enter' then 
                if not Global.Panel.modal then 
                    Global.Panel.modal = {470, 340, getTickCount()}
                    showCursor(true)
                    Global.Panel.modal_alpha = {0, 255, getTickCount()}
                    Global.Panel.dados_veh = config.vehicles[config['Others']['categorys'][Global.Panel.window]][Global.Panel.sequence + Global.Panel.page]
                end
            elseif button == 'backspace' then 
                if Global.Panel.modal then 
                    if not Timer and not isTimer(Timer) then 
                        Global.Panel.modal = {340, 470, getTickCount()}
                        Timer = setTimer(function()
                            Timer = nil
                            Global.Panel.modal = false
                        end, 400, 1)
                    end
                end
            end
        end
    end
end

function createVehicleConce ()
    if vehicle and isElement(vehicle) then destroyElement(vehicle) end
    vehicle = createVehicle ( config.vehicles[config['Others']['categorys'][Global.Panel.window]][Global.Panel.sequence + Global.Panel.page].model, unpack ( config['Matrix'][config['Others']['categorys'][Global.Panel.window]].spawn ) )
    interpolateDestroy()
end 

function onClientClick ( button, state )
    if button == 'left' then 
        if state == 'down' then 
            if Global.Panel.modal then 
                if isCursorOnElement(771, Global.Panel.modal[2] + 217, 378, 56) then 
                    local res_element = getResourceDynamicElementRoot(getResourceFromName('guetto_dealership'))
                    local color = {getVehicleColor(vehicle, true)}
                    triggerServerEvent('onPlayerBuyVehicle', res_element, config.vehicles[config['Others']['categorys'][Global.Panel.window]][Global.Panel.sequence + Global.Panel.page], color)
                    Global.Panel.modal = {340, 470, getTickCount()}
                    Global.Panel.modal_alpha = {255, 0, getTickCount()}
                    Timer = setTimer(function()
                        Timer = nil
                        Global.Panel.modal = false
                    end, 400, 1)
                elseif isCursorOnElement(771, Global.Panel.modal[2] + 279, 378, 56) then 
                    if not Timer and not isTimer(Timer) then 
                        Global.Panel.modal = {340, 470, getTickCount()}
                        Global.Panel.modal_alpha = {255, 0, getTickCount()}
                        Timer = setTimer(function()
                            Timer = nil
                            Global.Panel.modal = false
                        end, 400, 1)
                    end
                end
            end
        end
    end
end

local function toggle(state)
    if state and not Global.Panel.isEventHandlerAdded then

        Global.Panel.isEventHandlerAdded = true
        Global.Panel.alpha = {0, 255, getTickCount()}

        Global.Panel.sequence = 1
        Global.Panel.rotation = 90
        Global.Panel.interpolate = {}
        Global.Panel.animation = {922, 906, getTickCount()}
        Global.Panel.animation_tick = {}
        Global.Panel.page = 0
        Global.Panel.window = 1 
        Global.Panel.modal = false

        showCursor(true)
        showChat(false)
        slidebar.start()

        setElementData(localPlayer, 'bloqInterface', true)
        setElementData(localPlayer, 'guetto.showning.hud', true)
        setElementData(localPlayer, "BloqHotBar", true)

        setElementFrozen(localPlayer, true)


        addEventHandler('onClientKey', root, onClientKey)
        addEventHandler('onClientRender', root, draw)
        addEventHandler('onClientClick', root, onClientClick)

        colorpicker.create('colorpicker:vehicle', 1588, 422, 266, 131, 24, 24, 'assets/images/colorpicker.png', 'assets/images/cursor.png')
        setCameraMatrix(unpack(config['Matrix'][config['Others']['categorys'][Global.Panel.window]].camera))
        createVehicleConce()

        TimerRotation = setTimer(function ( )
            if (vehicle and isElement(vehicle)) then 
                local rx, ry, rz = getElementRotation ( vehicle )
                setElementRotation(vehicle, rx, ry, rz - 0.5)
            end
        end, 1, 0)

    elseif not state and Global.Panel.isEventHandlerAdded then
        if vehicle and isElement(vehicle) then destroyElement(vehicle) end

        Global.Panel.isEventHandlerAdded = false
        Global.Panel.alpha = {255, 0, getTickCount()}
        
        showCursor(false)
        showChat(true)
        setCameraTarget(localPlayer)

        setElementFrozen(localPlayer, false)
        setElementData(localPlayer, 'bloqInterface', false)
        setElementData(localPlayer, 'guetto.showning.hud', false)
        setElementData(localPlayer, "BloqHotBar", false)

        colorpicker.destroy('colorpicker:vehicle')
        
        if TimerRotation and isTimer(TimerRotation) then 
            killTimer(TimerRotation)
        end
        
        setTimer(function()
            removeEventHandler('onClientRender', root, draw)
            removeEventHandler('onClientKey', root, onClientKey)
            removeEventHandler('onClientClick', root, onClientClick)
            slidebar.destroy()
        end, 400, 1)
    end
end


addEvent('onPlayerDrawDealerShip', true)
addEventHandler('onPlayerDrawDealerShip', resourceRoot,
    function ( estoque )
        Global.Panel.Estoque = estoque
        toggle(true)
    end
)

bindKey('backspace', 'down',
    function ( )
        if not (Global.Panel.modal) then 
            toggle(false)
        end
    end
)

bindKey('lctrl', 'down',
    function ( )
        if Global.Panel.isEventHandlerAdded and not (Global.Panel.modal) then 
            local res_element = getResourceDynamicElementRoot(getResourceFromName('guetto_dealership'))
            triggerServerEvent("onDealerShipDrive", res_element, config.vehicles[config['Others']['categorys'][Global.Panel.window]][Global.Panel.sequence + Global.Panel.page])
            toggle(false)
        end
    end
)

addEvent('onClientCloseDealerShip', true)
addEventHandler('onClientCloseDealerShip', resourceRoot,
    function ( )
        toggle(false)
    end
)

setCameraTarget(localPlayer)
setElementFrozen(localPlayer, false)
