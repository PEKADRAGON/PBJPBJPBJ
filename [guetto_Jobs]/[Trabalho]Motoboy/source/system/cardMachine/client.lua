local panel

local fonts = {
    ['bold_inter'] = dxCreateFont('assets/fonts/Inter-Bold.ttf', 9);
    ['black_inter'] = dxCreateFont('assets/fonts/Inter-Black.ttf', 7);
    ['semibold_inter'] = dxCreateFont('assets/fonts/Inter-SemiBold.ttf', 11);
    ['medium_inter'] = dxCreateFont('assets/fonts/Inter-Medium.ttf', 11);
}

local function render()
    if (panel.tab ~= 'success') then
        dxDrawImage((48 * scale), ((screen.y - (557 * scale)) / 2) - (180 * scale), (296 * scale), (204 * scale), 'assets/images/order.png', 0, 0, 0, tocolor(255, 255, 255, 255))

        dxDrawText('PEDIDO #'..string.rep('0', (4 - #panel.request.id))..panel.request.id, ((48 * scale) + (34 * scale)), ((screen.y - (557 * scale)) / 2) - (180 * scale) + (21 * scale), (228 * scale), (17 * scale), tocolor(10, 28, 43, 255), 1, fonts['bold_inter'])
        dxDrawText('1x '..panel.request.food[1], ((48 * scale) + (34 * scale)), ((screen.y - (557 * scale)) / 2) - (180 * scale) + (74 * scale), (228 * scale), (17 * scale), tocolor(10, 28, 43, 255), 1, fonts['bold_inter'], 'left', 'top', false, true)
        dxDrawText('1x '..panel.request.drink[1], ((48 * scale) + (34 * scale)), ((screen.y - (557 * scale)) / 2) - (180 * scale) + (108 * scale), (228 * scale), (17 * scale), tocolor(10, 28, 43, 255), 1, fonts['bold_inter'], 'left', 'top', false, true)
        dxDrawText('VALOR TOTAL: R$ '..formatNumber((panel.request.food[2] + panel.request.drink[2]), '.')..',00', ((48 * scale) + (34 * scale)), ((screen.y - (557 * scale)) / 2) - (180 * scale) + (159 * scale), (228 * scale), (17 * scale), tocolor(10, 28, 43, 255), 1, fonts['bold_inter'], 'left', 'top', false, true)
    end
      
    if (panel.tab == 'success') then
        local y = (((screen.y - (557 * scale)) / 2) - ((interpolate(-2, 132, 0.03, 'notinha')) * scale))

        dxDrawImage((48 * scale), y, (296 * scale), (204 * scale), 'assets/images/order.png', 0, 0, 0, tocolor(255, 255, 255, 255))
        dxDrawText('SRRP Bank', ((48 * scale) + (13 * scale)), y + (9 * scale), (270 * scale), (17 * scale), tocolor(10, 28, 43, 255), 1, fonts['bold_inter'])
        dxDrawText('Cupom Fiscal', ((48 * scale) + (13 * scale)), y + (26 * scale), (270 * scale), (17 * scale), tocolor(10, 28, 43, 255), 1, fonts['bold_inter'])
        dxDrawText('1x '..panel.request.food[1], ((48 * scale) + (13 * scale)), y + (46 * scale), (270 * scale), (27 * scale), tocolor(10, 28, 43, 255), 1, fonts['bold_inter'], 'left', 'top', false, true)
        dxDrawText('1x '..panel.request.drink[1], ((48 * scale) + (13 * scale)), y + (75 * scale), (270 * scale), (27 * scale), tocolor(10, 28, 43, 255), 1, fonts['bold_inter'], 'left', 'top', false, true)
        dxDrawText('VALOR TOTAL: R$ '..formatNumber((panel.request.food[2] + panel.request.drink[2]), '.')..',00', ((48 * scale) + (13 * scale)), y + (110 * scale), (270 * scale), (27 * scale), tocolor(10, 28, 43, 255), 1, fonts['bold_inter'], 'right', 'top', false, true)
        
        dxDrawImage((32 * scale), ((screen.y - (557 * scale)) / 2), (361 * scale), (557 * scale), 'assets/images/cardMachine_success.png', 0, 0, 0, tocolor(255, 255, 255, 255))
    elseif (panel.tab == 'error') then
        dxDrawImage((32 * scale), ((screen.y - (557 * scale)) / 2), (361 * scale), (557 * scale), 'assets/images/cardMachine_error.png', 0, 0, 0, tocolor(255, 255, 255, 255))
    else
        dxDrawImage((32 * scale), ((screen.y - (557 * scale)) / 2), (361 * scale), (557 * scale), 'assets/images/cardMachine.png', 0, 0, 0, tocolor(255, 255, 255, 255))
    
        dxDrawText('BEM-VINDO!', ((32 * scale) + (38 * scale)), ((screen.y - (557 * scale)) / 2) + (143 * scale), (257 * scale), (11 * scale), tocolor(255, 255, 255, 255), 1, fonts['black_inter'], 'center', 'top')
    end

    if (panel.tab == 'start') then
        dxDrawText('R$ '..(#panel.cardMachine.price == 0 and '0' or panel.cardMachine.price)..',00', ((32 * scale) + (38 * scale)), ((screen.y - (557 * scale)) / 2) + (172 * scale), (257 * scale), (11 * scale), tocolor(255, 255, 255, 255), 1, fonts['semibold_inter'], 'center', 'top')
        dxDrawText('INSIRA O VALOR', ((32 * scale) + (38 * scale)), ((screen.y - (557 * scale)) / 2) + (212 * scale), (257 * scale), (19 * scale), tocolor(255, 255, 255, 255), 1, fonts['medium_inter'], 'center', 'top')
    elseif (panel.tab == 'proximity') then
        dxDrawImage(((32 * scale) + (143 * scale)), ((screen.y - (557 * scale)) / 2) + (164 * scale), (47 * scale), (45 * scale), 'assets/images/proximity.png', 0, 0, 0, tocolor(255, 255, 255, 255))
        dxDrawText((panel.cardMachine.time and (panel.cardInMove and 'AGUARDE...') or 'APROXIME O CARTÃO'), ((32 * scale) + (38 * scale)), ((screen.y - (557 * scale)) / 2) + (212 * scale), (257 * scale), (19 * scale), tocolor(255, 255, 255, 255), 1, fonts['medium_inter'], 'center', 'top')
    
        dxDrawImage(interpolate(panel.cards.black[1].x, panel.cards.black[2].x, 0.15, 'black.x'), interpolate(panel.cards.black[1].y, panel.cards.black[2].y, 0.15, 'black.y'), (255 * scale), (166 * scale), 'assets/images/card_black.png')
        dxDrawImage(interpolate(panel.cards.blue[1].x, panel.cards.blue[2].x, 0.15, 'blue.x'), interpolate(panel.cards.blue[1].y, panel.cards.blue[2].y, 0.15, 'blue.y'), (255 * scale), (166 * scale), 'assets/images/card_blue.png')
        dxDrawImage(interpolate(panel.cards.gold[1].x, panel.cards.gold[2].x, 0.15, 'gold.x'), interpolate(panel.cards.gold[1].y, panel.cards.gold[2].y, 0.15, 'gold.y'), (255 * scale), (166 * scale), 'assets/images/card_gold.png')

        if (panel.cardInMove) then
            local cursor = getCursorPosition()
            
            panel.cards[panel.cardInMove[1]][2] = Vector2((cursor.x - panel.cardInMove[2].x), ((cursor.y  - panel.cardInMove[2].y)))

            if (isElementOnPosition(((32 * scale) + (38 * scale)), ((screen.y - (557 * scale)) / 2) + (88 * scale), (257 * scale), (198 * scale), panel.cards[panel.cardInMove[1]][2].x, panel.cards[panel.cardInMove[1]][2].y, (255 * scale), (166 * scale))) then
                if (not panel.cardMachine.time) then
                    panel.cardMachine.time = os.time()
                else
                    if ((os.time() - panel.cardMachine.time) >= 3) then
                        if (panel.cardInMove[1] == panel.correctCard) then
                            playSound('assets/sounds/order.mp3')

                            panel.tab = 'success'

                            setInterpolate('notinha', nil)
                        else
                            playSound('assets/sounds/error.mp3')

                            panel.tab = 'error'

                            setTimer(function()
                                panel.tab = 'start'

                                panel.cardMachine.price = ''
                            end, 3000, 1)

                            if (panel.cardInMove[1] == 'black') then
                                panel.cards.black[2] = Vector2(((screen.x - (510 * scale)) / 2), (screen.y - (124 * scale) + (82 * scale)))
                            elseif (panel.cardInMove[1] == 'blue') then
                                panel.cards.blue[2] = Vector2(((screen.x - (510 * scale)) / 2 + (255 * scale)), (screen.y - (124 * scale)))
                            elseif (panel.cardInMove[1] == 'gold') then
                                panel.cards.gold[2] = Vector2(((screen.x - (510 * scale)) / 2 + (255 * scale)), (screen.y - (124 * scale) + (82 * scale)))
                            end
        
                            panel.cardInMove = nil
                        end
                    end
                end
            else
                if (panel.cardMachine.time) then
                    panel.cardMachine.time = nil
                end
            end
        end
    end
end

local function onClientEvents(...)
    if (eventName == 'onClientClick') then
        local b, s = ...
        
        if (s == 'down') then
            if (b == 'left') then
                if (panel.tab == 'start') then
                    if (isCursorOnPosition(((32 * scale) + (50 * scale)), ((screen.y - (557 * scale)) / 2) + (336 * scale), (66 * scale), (28 * scale))) then
                        if (#panel.cardMachine.price <= 2) then
                            panel.cardMachine.price = panel.cardMachine.price..'1'

                            playSound('assets/sounds/bip.mp3')
                        end
                    elseif (isCursorOnPosition(((32 * scale) + (135 * scale)), ((screen.y - (557 * scale)) / 2) + (336 * scale), (66 * scale), (28 * scale))) then
                        if (#panel.cardMachine.price <= 2) then
                            panel.cardMachine.price = panel.cardMachine.price..'2'

                            playSound('assets/sounds/bip.mp3')
                        end
                    elseif (isCursorOnPosition(((32 * scale) + (223 * scale)), ((screen.y - (557 * scale)) / 2) + (336 * scale), (66 * scale), (28 * scale))) then
                        if (#panel.cardMachine.price <= 2) then
                            panel.cardMachine.price = panel.cardMachine.price..'3'

                            playSound('assets/sounds/bip.mp3')
                        end
                    elseif (isCursorOnPosition(((32 * scale) + (50 * scale)), ((screen.y - (557 * scale)) / 2) + (372 * scale), (66 * scale), (28 * scale))) then
                        if (#panel.cardMachine.price <= 2) then
                            panel.cardMachine.price = panel.cardMachine.price..'4'

                            playSound('assets/sounds/bip.mp3')
                        end
                    elseif (isCursorOnPosition(((32 * scale) + (135 * scale)), ((screen.y - (557 * scale)) / 2) + (372 * scale), (66 * scale), (28 * scale))) then
                        if (#panel.cardMachine.price <= 2) then
                            panel.cardMachine.price = panel.cardMachine.price..'5'

                            playSound('assets/sounds/bip.mp3')
                        end
                    elseif (isCursorOnPosition(((32 * scale) + (223 * scale)), ((screen.y - (557 * scale)) / 2) + (372 * scale), (66 * scale), (28 * scale))) then
                        if (#panel.cardMachine.price <= 2) then
                            panel.cardMachine.price = panel.cardMachine.price..'6'

                            playSound('assets/sounds/bip.mp3')
                        end
                    elseif (isCursorOnPosition(((32 * scale) + (50 * scale)), ((screen.y - (557 * scale)) / 2) + (409 * scale), (66 * scale), (28 * scale))) then
                        if (#panel.cardMachine.price <= 2) then
                            panel.cardMachine.price = panel.cardMachine.price..'7'

                            playSound('assets/sounds/bip.mp3')
                        end
                    elseif (isCursorOnPosition(((32 * scale) + (135 * scale)), ((screen.y - (557 * scale)) / 2) + (409 * scale), (66 * scale), (28 * scale))) then
                        if (#panel.cardMachine.price <= 2) then
                            panel.cardMachine.price = panel.cardMachine.price..'8'

                            playSound('assets/sounds/bip.mp3')
                        end
                    elseif (isCursorOnPosition(((32 * scale) + (223 * scale)), ((screen.y - (557 * scale)) / 2) + (409 * scale), (66 * scale), (28 * scale))) then
                        if (#panel.cardMachine.price <= 2) then
                            panel.cardMachine.price = panel.cardMachine.price..'9'

                            playSound('assets/sounds/bip.mp3')
                        end
                    elseif (isCursorOnPosition(((32 * scale) + (135 * scale)), ((screen.y - (557 * scale)) / 2) + (447 * scale), (66 * scale), (28 * scale))) then
                        if (#panel.cardMachine.price <= 2) then
                            if (#panel.cardMachine.price > 0) then
                                panel.cardMachine.price = panel.cardMachine.price..'0'

                            playSound('assets/sounds/bip.mp3')
                            end
                        end
                    elseif (isCursorOnPosition(((32 * scale) + (135 * scale)), ((screen.y - (557 * scale)) / 2) + (489 * scale), (66 * scale), (28 * scale))) then
                        panel.cardMachine.price = utf8.remove(panel.cardMachine.price, #panel.cardMachine.price, #panel.cardMachine.price)

                        playSound('assets/sounds/bip.mp3')
                    elseif (isCursorOnPosition(((32 * scale) + (223 * scale)), ((screen.y - (557 * scale)) / 2) + (489 * scale), (66 * scale), (28 * scale))) then
                        if (tonumber(panel.cardMachine.price) == (panel.request.food[2] + panel.request.drink[2])) then
                            panel.tab = 'proximity'
                        else
                            --triggerServerEvent('notify', localPlayer, localPlayer, 'erro', 'Você errou o preço do pedido, apague e escreva novamente.')
                        end

                        playSound('assets/sounds/bip.mp3')
                    end
                elseif (panel.tab == 'proximity') then
                    local cursor = getCursorPosition()

                    if (isCursorOnPosition(panel.cards.black[1].x, panel.cards.black[1].y, (255 * scale), (166 * scale))) then
                        panel.cardInMove = {'black', Vector2((cursor.x - panel.cards.black[1].x), (cursor.y - panel.cards.black[1].y))}
                    elseif (isCursorOnPosition(panel.cards.gold[1].x, panel.cards.gold[1].y, (255 * scale), (166 * scale))) then
                        panel.cardInMove = {'gold', Vector2((cursor.x - panel.cards.gold[1].x), (cursor.y - panel.cards.gold[1].y))}
                    elseif (isCursorOnPosition(panel.cards.blue[1].x, panel.cards.blue[1].y, (255 * scale), (166 * scale))) then
                        panel.cardInMove = {'blue', Vector2((cursor.x - panel.cards.blue[1].x), (cursor.y - panel.cards.blue[1].y))}
                    end
                elseif (panel.tab == 'success') then
                    if (isCursorOnPosition((48 * scale), (((screen.y - (557 * scale)) / 2) - ((getInterpolate('notinha')) * scale)), (296 * scale), (204 * scale))) then
                        setCameraTarget(localPlayer)
                        triggerServerEvent('receptTrigger_route_s', localPlayer, 'regenerate', (panel.request.food[2] + panel.request.drink[2]))

                        panel:delete()
                    end
                end
            end
        elseif (s == 'up') then
            if (b == 'left') then
                if (panel.cardInMove) then
                    if (panel.cardInMove[1] == 'black') then
                        panel.cards.black[2] = Vector2(((screen.x - (510 * scale)) / 2), (screen.y - (124 * scale) + (82 * scale)))
                    elseif (panel.cardInMove[1] == 'blue') then
                        panel.cards.blue[2] = Vector2(((screen.x - (510 * scale)) / 2 + (255 * scale)), (screen.y - (124 * scale)))
                    elseif (panel.cardInMove[1] == 'gold') then
                        panel.cards.gold[2] = Vector2(((screen.x - (510 * scale)) / 2 + (255 * scale)), (screen.y - (124 * scale) + (82 * scale)))
                    end

                    panel.cardInMove = nil

                    panel.cardMachine.time = nil
                end
            end
        end
    end
end

local function generateRequestProduct(type)
    if (config.requestProducts[type]) then
        if (not productsAvaliable) then
            productsAvaliable = {}
        end

        if (not productsAvaliable[type]) then
            productsAvaliable[type] = {}

            for i, v in pairs(config.requestProducts[type]) do
                table.insert(productsAvaliable[type], {i, v})
            end    
        end

        return productsAvaliable[type][math.random(#productsAvaliable[type])]
    end
end

addCustomEventHandler('receptTrigger_cardMachine_c', function(...)
    local type = ...

    if (type == 'new') then
        new 'c_cardMachine'()
    else
        if (panel) then
            panel:delete()
        end
    end
end)

class 'c_cardMachine' {
    constructor = function(self)
        if (not panel) then
            self.state = setTimer(render, 0, 0)
            self.tab = 'start'

            self.request = {id = tostring(math.random(9999)), food = generateRequestProduct('foods'), drink = generateRequestProduct('drinks')}

            self.cardMachine = {price = ''}
            self.cards = {
                black = {Vector2(((screen.x - (510 * scale)) / 2), (screen.y - (124 * scale) + (82 * scale))), Vector2(((screen.x - (510 * scale)) / 2), (screen.y - (124 * scale) + (82 * scale)))},
                blue = {Vector2(((screen.x - (510 * scale)) / 2 + (255 * scale)), (screen.y - (124 * scale))), Vector2(((screen.x - (510 * scale)) / 2 + (255 * scale)), (screen.y - (124 * scale)))},
                gold = {Vector2(((screen.x - (510 * scale)) / 2 + (255 * scale)), (screen.y - (124 * scale) + (82 * scale))), Vector2(((screen.x - (510 * scale)) / 2 + (255 * scale)), (screen.y - (124 * scale) + (82 * scale)))}
            }

            self.correctCard = math.random(3)
            if (self.correctCard == 3) then
                self.correctCard = 'gold'
            elseif (self.correctCard == 2) then
                self.correctCard = 'blue'
            else
                self.correctCard = 'black'
            end

            if (isChatVisible()) then
                self.chat = true

                showChat(false)
            end
            showCursor(true)

            addEventHandler('onClientClick', root, onClientEvents)

            panel = self
        end
    end,

    delete = function(self)
        killTimer(self.state)
        
        if (self.chat) then
            showChat(true)
        end
        showCursor(false)
        setCameraTarget(localPlayer)
        
        removeEventHandler('onClientClick', root, onClientEvents)
        
        self = nil
        panel = nil
    end
}