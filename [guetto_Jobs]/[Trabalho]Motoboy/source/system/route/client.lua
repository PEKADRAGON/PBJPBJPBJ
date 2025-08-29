local panel

local fonts = {
    ['extrabold_inter'] = dxCreateFont('assets/fonts/Inter-ExtraBold.ttf', 15);
    ['semibold_inter'] = dxCreateFont('assets/fonts/Inter-SemiBold.ttf', 15);
}

local function render()
    dxDrawSvgRectangle(parent.x, parent.y, (500 * scale), (242 * scale), 10, 0, 0, 0, tocolor(32, 31, 33, (255 / 100 * 95)))
    
    dxDrawImage(parent.x + (35 * scale), parent.y + (20 * scale), (20 * scale), (20 * scale), 'assets/images/scooter.png', 0, 0, 0, tocolor(255, 255, 255, 255))
    dxDrawText('Moto-Boy', parent.x + (67 * scale), parent.y + (18 * scale), (92 * scale), (24 * scale), tocolor(255, 255, 255, 255), 1, fonts['semibold_inter'], 'left', 'center')
   -- dxDrawImage(parent.x + (462 * scale), parent.y + (20 * scale), (22 * scale), (22 * scale), 'assets/images/logo.png', 0, 0, 0, tocolor(255, 255, 255, 255))

    dxDrawText('Você devera entregar as caixas de pizzas nas casas.', parent.x + (35 * scale), parent.y + (89 * scale), (430 * scale), (48 * scale), tocolor(255, 255, 255, 255), 1, fonts['semibold_inter'], 'left', 'center', false, true)

    dxDrawSvgRectangle(parent.x + (175 * scale), parent.y + (181 * scale), (150 * scale), (35 * scale), 4, 0, 0, 0, (isCursorOnPosition(parent.x + (175 * scale), parent.y + (181 * scale), (150 * scale), (35 * scale)) and colorAnimation('confirm_route', 1500, 119, 255, 208, 255) or colorAnimation('confirm_route', 1500, 0, 239, 157, 255)))
    dxDrawText(((getElementData(localPlayer, "player > emp") == "motoboy") and 'PARAR' or 'INICIAR'), parent.x + (175 * scale), parent.y + (181 * scale), (150 * scale), (35 * scale), tocolor(255, 255, 255, 255), 1, fonts['extrabold_inter'], 'center', 'center')
end

local function onClientEvents(...)
    if (eventName == 'onClientClick') then
        local b, s = ...
        
        if (s == 'down') then
            if (b == 'left') then
                if (isCursorOnPosition(parent.x + (175 * scale), parent.y + (181 * scale), (150 * scale), (35 * scale))) then
                    if (panel.inService) then
                        triggerServerEvent('receptTrigger_route_s', localPlayer, 'stop')
                    else
                        triggerServerEvent('receptTrigger_route_s', localPlayer, 'start')
                    end

                    panel.inService = not panel.inService
                end
            end
        end
    elseif (eventName == 'onClientKey') then
        local b, s = ...

        if (s and (b == 'backspace' or b == 'escape')) then
            panel:delete()
            cancelEvent()
        end
    end
end

addCustomEventHandler('receptTrigger_route_c', function(...)
    local type, inService = ...

    if (type == 'new') then
        new 'c_route'(inService)
    else
        panel:delete()
    end
end)

class 'c_route' {
    constructor = function(self, service)
        if (not panel) then
            self.state = setTimer(render, 0, 0)
            self.inService = service
            showCursor(true)

            addEventHandler('onClientClick', root, onClientEvents)
            addEventHandler('onClientKey', root, onClientEvents)

            panel = self
        end
    end,

    delete = function(self)
        killTimer(self.state)
        showCursor(false)

        removeEventHandler('onClientClick', root, onClientEvents)
        removeEventHandler('onClientKey', root, onClientEvents)

        self = nil
        panel = nil
    end
}