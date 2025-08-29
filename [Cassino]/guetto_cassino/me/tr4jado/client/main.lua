core = {
    start = function()
        Timer(function()
            if isElement(protection.element) then
                sourceTimer:destroy()

                bet.events.start()
                scroll.start()
            end
        end, 1000, 0)
    end
}

bet = {
    update = 0,
    
    double = {
        data = false,
        list = {},
        render = false,
        multiplier = false,
        over = false,
        info = false,
    },

    miners = {
        boom = false,
        bombs = false,
        diamond = {},
        count = MINERS_MIN,
        data = false,
        info = false,
    },

    ranking = {
        list = {},
        player = 0,
        update = 0,
    },

    events = {
        start = function()
            interpolate.create('double:anim', 5000, 'InOutQuad')
            interpolate.exec('double:anim', 5 * 92 * scale, 5 * 92 * scale)

            bet.double.render = DxRenderTarget(bet.panel.double.bg.width, bet.panel.double.bg.height, true)

            registerEvent('bet:update', resourceRoot, bet.custom.update)
            registerEvent('bet:show', resourceRoot, bet.panel.show)
            registerEvent('bet:hide', resourceRoot, bet.panel.hide)
        end
    },

    custom = {
        update = function(_, data)
            if _ ~= protection.element then
                sendLogs('```[' .. os.date('%d/%m/%Y | %H:%M', os.time()) .. '] O jogador ' .. localPlayer.name .. ' tentou burlar o sistema.\nMotivo: protection.element```', LOGS_SUSPECT)
                return
            end

            data = decode(data)

            if not data or type(data) ~= 'table' then
                sendLogs('```[' .. os.date('%d/%m/%Y | %H:%M', os.time()) .. '] O jogador ' .. localPlayer.name .. ' tentou burlar o sistema.\nMotivo: no data```', LOGS_SUSPECT)
                return
            end

            bet.ranking = data
        end
    },

    panel = {
        state = false,

        activeButton = false,
        buttons = {},

        tab = false,

        double = {
            bg = {
                width = 479 * scale,
                height = 91 * scale
            },

            bar = {
                width = 4 * scale,
                height = 120 * scale
            },

            number = {
                width = 92 * scale,
                height = 91 * scale
            },

            history = {}
        },

        miners = {
            slots = {
                {417, 230, 61, 65},
                {482, 230, 61, 65},
                {547, 230, 61, 65},
                {612, 230, 61, 65},
                {677, 230, 61, 65},
                {742, 230, 61, 65},
                {807, 230, 61, 65},
    
                {417, 299, 61, 65},
                {482, 299, 61, 65},
                {547, 299, 61, 65},
                {612, 299, 61, 65},
                {677, 299, 61, 65},
                {742, 299, 61, 65},
                {807, 299, 61, 65},
    
                {417, 369, 61, 65},
                {482, 369, 61, 65},
                {547, 369, 61, 65},
                {612, 369, 61, 65},
                {677, 369, 61, 65},
                {742, 369, 61, 65},
                {807, 369, 61, 65},
    
                {417, 439, 61, 65},
                {482, 439, 61, 65},
                {547, 439, 61, 65},
                {612, 439, 61, 65},
                {677, 439, 61, 65},
                {742, 439, 61, 65},
                {807, 439, 61, 65},
            },
        },

        render = function()
            cursorUpdate()

            bet.panel.buttons = {}
            editbox.buttons = {}

            local w, h = 925 * scale, 587 * scale
            local x, y = (screen.x - w) / 2, (screen.y - h) / 2

            local fade = 1

            dxDrawRectangleRounded(x, y, w, h, 11, tocolor(11, 11, 13, 0.99 * fade))
            dxDrawImage(x + 29 * scale, y + 37 * scale, 58 * scale, 57 * scale, package .. '/assets/images/guetto.png', tocolor(255, 255, 255, fade))

            dxDrawText('Jogos e diversão', x + 110 * scale, y + 35 * scale, 0, 0, tocolor(255, 255, 255, fade), 1, getFont('medium', 26))
            dxDrawText('Divirta-se e ganhe bastante dinheiro.', x + 110 * scale, y + 61 * scale, 0, 0, tocolor(187, 187, 187, fade), 1, getFont('light', 24))

            dxDrawImageBlend(x + 865 * scale, y + 46 * scale, 28 * scale, 28 * scale, icon['close'], isCursorInBox(x + 865 * scale, y + 46 * scale, 28 * scale, 28 * scale) and tocolor(240, 106, 106, fade) or tocolor(255, 255, 255, fade))
            bet.panel.buttons['close'] = {x + 865 * scale, y + 46 * scale, 28 * scale, 28 * scale}

            dxDrawRectangleRounded(x + 29 * scale, y + 121 * scale, 868 * scale, 66 * scale, 0, tocolor(255, 255, 255, 0), {tocolor(145, 149, 177, 0.14 * fade), 1.5})
            dxDrawImage(x + 58 * scale, y + 140 * scale, 28 * scale, 28 * scale, icon['money'], tocolor(226, 196, 119, fade))
            dxDrawText('Saldo: $' .. formatNumber(getPlayerMoney(localPlayer)), x + 111 * scale, y + 147 * scale, 0, 0, tocolor(255, 255, 255, fade), 1, getFont('medium', 19))

            do
                local startX = 858 * scale

                for i, v in ipairs({
                    {'ranking', 'Ranking'},
                    {'miners', 'Miners'},
                    {'double', 'Double'}
                }) do
                    startX = startX - dxGetTextWidth(v[2], 1, getFont('medium', 19)) - 41 * scale

                    dxDrawImage(x + startX, y + 143 * scale, 21 * scale, 22 * scale, icon[v[1]], bet.panel.tab == v[1] and tocolor(243, 182, 125, fade) or tocolor(255, 255, 255, fade))
                    dxDrawText(v[2], x + startX + 27 * scale, y + 147 * scale, 0, 0, bet.panel.tab == v[1] and tocolor(243, 182, 125, fade) or tocolor(255, 255, 255, fade), 1, getFont('medium', 19))
                    bet.panel.buttons['tab:' .. v[1]] = {x + startX, y + 143 * scale, dxGetTextWidth(v[2], 1, getFont('medium', 19)) + 21 * scale, 22 * scale}
                end
            end

            if bet.panel.tab == 'double' then
                dxDrawRectangleRounded(x + 29 * scale, y + 210 * scale, 348 * scale, 316 * scale, 0, tocolor(255, 255, 255, 0), {tocolor(145, 149, 177, 0.14 * fade), 1.5})

                for i, v in ipairs({
                    {'1/2', 0.5},
                    {'2x', 2}
                }) do
                    dxDrawRectangleRounded(x + (58 + (148 * (i - 1))) * scale, y + 234 * scale, 140 * scale, 45 * scale, 2, tocolor(46, 60, 74, 0.2 * fade), {tocolor(145, 149, 177, 0.14 * fade), 1.5})
                    dxDrawText(v[1], x + (58 + (148 * (i - 1))) * scale, y + 234 * scale, 140 * scale, 45 * scale, tocolor(255, 255, 255, fade), 1, getFont('medium', 19), 'center', 'center')
                    bet.panel.buttons['money:' .. v[2]] = {x + (58 + (148 * (i - 1))) * scale, y + 234 * scale, 140 * scale, 45 * scale}
                end

                dxDrawRectangleRounded(x + 58 * scale, y + 291 * scale, 288 * scale, 45 * scale, 2, tocolor(46, 60, 74, 0.2 * fade), {tocolor(145, 149, 177, 0.14 * fade), 1.5})
                dxDrawText('$', x + 324 * scale, y + 304 * scale, 0, 0, tocolor(255, 255, 255, fade), 1, getFont('medium', 24))
                editbox.draw('money', 'Quantia', x + 69 * scale, y + 302 * scale, 200 * scale, 23 * scale, tocolor(255, 255, 255, 0.6 * fade), tocolor(255, 255, 255, 0.7 * fade), getFont('light', 24), 'left')
                editbox.buttons['money'] = {x + 58 * scale, y + 291 * scale, 288 * scale, 45 * scale}

                for i, v in ipairs(TYPES) do
                    dxDrawRectangleRounded(x + (58 + (98 * (i - 1))) * scale, y + 348 * scale, 92 * scale, 50 * scale, 2, v.colorPrimary, bet.double.multiplier == i and {v.colorSecundary, 1})
                    dxDrawText(v.name, x + (58 + (98 * (i - 1))) * scale, y + 348 * scale, 92 * scale, 50 * scale, v.colorSecundary, 1, getFont('medium', 19), 'center', 'center')
                    bet.panel.buttons['double:multiplier:' .. i] = {x + (58 + (98 * (i - 1))) * scale, y + 348 * scale, 92 * scale, 50 * scale}
                end

                dxDrawRectangle(x + 58 * scale, y + 412 * scale, 288 * scale, 1, tocolor(217, 217, 217, fade))

                dxDrawRectangleRounded(x + 58 * scale, y + 435 * scale, 288 * scale, 50 * scale, 2, tocolor(46, 60, 74, 0.2 * fade), {tocolor(145, 149, 177, 0.14 * fade), 1.5})

                if interpolate.isRunning('double:anim') then
                    dxDrawText('Aguarde...', x + 58 * scale, y + 435 * scale, 288 * scale, 50 * scale, tocolor(255, 255, 255, fade), 1, getFont('medium', 19), 'center', 'center')
                else
                    dxDrawText('Apostar', x + 58 * scale, y + 435 * scale, 288 * scale, 50 * scale, tocolor(255, 255, 255, fade), 1, getFont('medium', 19), 'center', 'center')
                    bet.panel.buttons['double:bet'] = {x + 58 * scale, y + 435 * scale, 288 * scale, 50 * scale}
                end

                dxDrawRectangleRounded(x + 390 * scale, y + 210 * scale, 507 * scale, 316 * scale, 4, tocolor(255, 255, 255, 0), {tocolor(145, 149, 177, 0.14 * fade), 1.5})
                dxDrawText(interpolate.isRunning('double:anim') and 'AGUARDANDO RESULTADO ...' or 'AGUARDANDO VOCÊ ...', x + 390 * scale, y + 240 * scale, 507 * scale, 0, tocolor(255, 255, 255, fade), 1, getFont('light', 24), 'center')

                if interpolate.isRunning('double:anim') then
                    bet.panel.update()
                else
                    if bet.double.data then
                        local data = bet.double.data
                        bet.double.data = false

                        local multiplier = TYPES[data.multiplier].multiplier

                        bet.panel.double.history[#bet.panel.double.history + 1] = {
                            index = bet.double.over,
                            number = bet.double.list[bet.double.over].number,
                            tick = getTickCount()
                        }

                        table.sort(bet.panel.double.history, function(a, b)
                            return a.tick > b.tick
                        end)

                        for i in pairs(circles) do
                            if isElement(circles[i]) then
                                circles[i]:destroy()
                            end
    
                            circles[i] = nil
                        end

                        if data.multiplier == bet.double.over then
                            bet.double.info = {
                                type = 'win',
                                money = 'R$' .. formatNumber(data.money * multiplier),
                                multiplier = 'x' .. multiplier
                            }

                            triggerServerEvent('bet:action', resourceRoot, protection.element, encode({
                                type = 'win',
                                game = 'double',
                                selected = data.multiplier,
                                money = data.money,
                                multiplier = multiplier,
                                logs = true
                            }))
                        else
                            bet.double.info = {
                                type = 'loss',
                                money = 'R$' .. formatNumber(data.money),
                                multiplier = 'x' .. multiplier
                            }

                            triggerServerEvent('bet:action', resourceRoot, protection.element, encode({
                                type = 'loss',
                                game = 'double',
                                selected = data.multiplier,
                                over = bet.double.over,
                                money = data.money,
                                multiplier = multiplier,
                                logs = true
                            }))
                        end
                    end
                end

                dxDrawImage(x + 404 * scale, y + 305 * scale, bet.panel.double.bg.width, bet.panel.double.bg.height, bet.double.render, tocolor(255, 255, 255, fade))
                dxDrawRectangle(x + ((bet.panel.double.bg.width - bet.panel.double.bar.width) / 2) + 404 * scale, y + 291 * scale, 4 * scale, 120 * scale, tocolor(255, 255, 255, fade))

                dxDrawRectangle(x + 405 * scale, y + 411 * scale, 479 * scale, 1, tocolor(217, 217, 217, 0.1 * fade))

                for i = 1, 13 do
                    local v = bet.panel.double.history[i]

                    if v then
                        local data = TYPES[v.index]

                        dxDrawCustomCircle('history:' .. i, x + (405 + ((i - 1) * 37)) * scale, y + 458 * scale, 28 * scale, {start = 0, sweep = 0}, {'white', 0}, {decimalsToHex(data.colorPrimary), 1, 1}, {1, 1})
                        dxDrawText(v.number, x + (405 + ((i - 1) * 37)) * scale, y + 458 * scale, 28 * scale, 28 * scale, data.colorPrimary, 1, getFont('medium', 17), 'center', 'center')
                    end
                end

                if bet.double.info then
                    dxDrawImage(x + 490 * scale, y + 218 * scale, 305 * scale, 293 * scale, package .. '/assets/images/' .. bet.double.info.type .. '.png', tocolor(255, 255, 255, 0.98 * fade))
                    dxDrawText(bet.double.info.type == 'win' and 'Parabéns!' or 'Que pena', x + 519 * scale, y + 285 * scale, 247 * scale, 0, tocolor(255, 255, 255, fade), 1, getFont('medium', 24), 'center')
                    dxDrawText(bet.double.info.multiplier, x + 519 * scale, y + 320 * scale, 247 * scale, 0, tocolor(255, 255, 255, fade), 1, getFont('medium', 42), 'center')
                    dxDrawText(bet.double.info.type == 'win' and 'Você ganhou!' or 'Você perdeu!', x + 519 * scale, y + 386 * scale, 247 * scale, 0, tocolor(255, 255, 255, fade), 1, getFont('medium', 24), 'center')
                    dxDrawText(bet.double.info.money, x + 519 * scale, y + 445 * scale, 247 * scale, 0, tocolor(255, 255, 255, fade), 1, getFont('medium', 21), 'center')
                end
            elseif bet.panel.tab == 'miners' then
                dxDrawRectangleRounded(x + 29 * scale, y + 210 * scale, 348 * scale, 316 * scale, 0, tocolor(255, 255, 255, 0), {tocolor(145, 149, 177, 0.14 * fade), 1.5})

                for i, v in ipairs({
                    {'1/2', 0.5},
                    {'2x', 2}
                }) do
                    dxDrawRectangleRounded(x + (58 + (148 * (i - 1))) * scale, y + 234 * scale, 140 * scale, 45 * scale, 2, tocolor(46, 60, 74, 0.2 * fade), {tocolor(145, 149, 177, 0.14 * fade), 1.5})
                    dxDrawText(v[1], x + (58 + (148 * (i - 1))) * scale, y + 234 * scale, 140 * scale, 45 * scale, tocolor(255, 255, 255, fade), 1, getFont('medium', 19), 'center', 'center')
                    bet.panel.buttons['money:' .. v[2]] = {x + (58 + (148 * (i - 1))) * scale, y + 234 * scale, 140 * scale, 45 * scale}
                end

                dxDrawRectangleRounded(x + 58 * scale, y + 291 * scale, 288 * scale, 45 * scale, 2, tocolor(46, 60, 74, 0.2 * fade), {tocolor(145, 149, 177, 0.14 * fade), 1.5})
                dxDrawText('$', x + 324 * scale, y + 304 * scale, 0, 0, tocolor(255, 255, 255, fade), 1, getFont('medium', 24))
                editbox.draw('money', 'Quantia', x + 69 * scale, y + 302 * scale, 200 * scale, 23 * scale, tocolor(255, 255, 255, 0.6 * fade), tocolor(255, 255, 255, 0.7 * fade), getFont('light', 24), 'left')

                if not (bet.miners.bombs and not bet.miners.boom) then
                    editbox.buttons['money'] = {x + 58 * scale, y + 291 * scale, 288 * scale, 45 * scale}
                end

                dxDrawRectangleRounded(x + 58 * scale, y + 348 * scale, 288 * scale, 50 * scale, 2, tocolor(46, 60, 74, 0.2 * fade), {tocolor(145, 149, 177, 0.14 * fade), 1.5})
                dxDrawText(bet.miners.count .. ' minas', x + 72 * scale, y + 362 * scale, 0, 0, tocolor(255, 255, 255, fade), 1, getFont('medium', 24))
                dxDrawImage(x + 302 * scale, y + 360 * scale, 27 * scale, 27 * scale, icon['list'], tocolor(255, 255, 255, fade))

                if not (bet.miners.bombs and not bet.miners.boom) then
                    bet.panel.buttons['miners:count'] = {x + 302 * scale, y + 360 * scale, 27 * scale, 27 * scale}
                end

                dxDrawRectangle(x + 58 * scale, y + 412 * scale, 288 * scale, 1, tocolor(217, 217, 217, fade))

                dxDrawRectangleRounded(x + 58 * scale, y + 435 * scale, 288 * scale, 50 * scale, 4, tocolor(46, 60, 74, 0.2 * fade), {tocolor(145, 149, 177, 0.14 * fade), 1.5})

                if bet.miners.bombs and not bet.miners.boom then
                    dxDrawText('ENCERRAR APOSTA', x + 58 * scale, y + 437 * scale, 288 * scale, 50 * scale, tocolor(255, 255, 255, fade), 1, getFont('light', 24), 'center', 'center')
                    bet.panel.buttons['miners:end'] = {x + 58 * scale, y + 435 * scale, 288 * scale, 50 * scale}
                else
                    dxDrawText('COMEÇAR JOGO', x + 58 * scale, y + 437 * scale, 288 * scale, 50 * scale, tocolor(255, 255, 255, fade), 1, getFont('light', 24), 'center', 'center')
                    bet.panel.buttons['miners:bet'] = {x + 58 * scale, y + 435 * scale, 288 * scale, 50 * scale}
                end

                dxDrawRectangleRounded(x + 390 * scale, y + 210 * scale, 507 * scale, 316 * scale, 4, tocolor(255, 255, 255, 0), {tocolor(145, 149, 177, 0.14 * fade), 1.5})

                for i = 1, 28 do
                    local v = bet.panel.miners.slots[i]

                    if v then
                        if bet.miners.boom then
                            if bet.miners.bombs[i] then
                                dxDrawImage(x + v[1] * scale, y + v[2] * scale, v[3] * scale, v[4] * scale, package .. '/assets/images/bomb.png', tocolor(255, 255, 255, fade))
                            else
                                dxDrawImage(x + v[1] * scale, y + v[2] * scale, v[3] * scale, v[4] * scale, package .. '/assets/images/diamond.png', tocolor(255, 255, 255, fade))
                            end
                        else
                            if bet.miners.diamond[i] then
                                dxDrawImage(x + v[1] * scale, y + v[2] * scale, v[3] * scale, v[4] * scale, package .. '/assets/images/diamond.png', tocolor(255, 255, 255, fade))
                            else
                                dxDrawRectangleRounded(x + v[1] * scale, y + v[2] * scale, v[3] * scale, v[4] * scale, 2, tocolor(46, 60, 74, 0.2 * fade), {tocolor(145, 149, 177, 0.14 * fade), 1.5})

                                if bet.miners.bombs then
                                    bet.panel.buttons['miners:slot:' .. i] = {x + v[1] * scale, y + v[2] * scale, v[3] * scale, v[4] * scale}
                                end
                            end
                        end
                    end
                end

                if bet.miners.info then
                    dxDrawImage(x + 490 * scale, y + 218 * scale, 305 * scale, 293 * scale, package .. '/assets/images/' .. bet.miners.info.type .. '.png', tocolor(255, 255, 255, 0.98 * fade))
                    dxDrawText(bet.miners.info.type == 'win' and 'Parabéns!' or 'Que pena', x + 519 * scale, y + 285 * scale, 247 * scale, 0, tocolor(255, 255, 255, fade), 1, getFont('medium', 24), 'center')
                    dxDrawText(bet.miners.info.multiplier, x + 519 * scale, y + 320 * scale, 247 * scale, 0, tocolor(255, 255, 255, fade), 1, getFont('medium', 42), 'center')
                    dxDrawText(bet.miners.info.type == 'win' and 'Você ganhou!' or 'Você perdeu!', x + 519 * scale, y + 386 * scale, 247 * scale, 0, tocolor(255, 255, 255, fade), 1, getFont('medium', 24), 'center')
                    dxDrawText(bet.miners.info.money, x + 519 * scale, y + 445 * scale, 247 * scale, 0, tocolor(255, 255, 255, fade), 1, getFont('medium', 21), 'center')
                end
            elseif bet.panel.tab == 'ranking' then
                dxDrawRectangleRounded(x + 29 * scale, y + 210 * scale, 638 * scale, 316 * scale, 4, tocolor(255, 255, 255, 0), {tocolor(145, 149, 177, 0.14 * fade), 1.5})

                dxDrawText('Apostador', x + 48 * scale, y + 226 * scale, 604 * scale, 0, tocolor(255, 255, 255, fade), 1, getFont('medium', 24))
                dxDrawText('Rodadas', x + 48 * scale, y + 226 * scale, 604 * scale, 0, tocolor(255, 255, 255, fade), 1, getFont('medium', 24), 'center')
                dxDrawText('Lucros/perdas', x + 48 * scale, y + 226 * scale, 604 * scale, 0, tocolor(255, 255, 255, fade), 1, getFont('medium', 24), 'right')

                scroll.draw('ranking', x + 656 * scale, y + 254 * scale, 6 * scale, 251 * scale, tocolor(43, 54, 64, 0.5 * fade), tocolor(143, 147, 192, 0.5 * fade), 5, #bet.ranking.list)
                scroll.buttons['scroll:ranking'] = {x + 41 * scale, y + 254 * scale, 611 * scale, 251 * scale}

                for i = 1, 5 do
                    local index = i + scroll.getValue('ranking')
                    local v = bet.ranking.list[index]

                    if v then
                        dxDrawRectangleRounded(x + 41 * scale, y + (254 + ((i - 1) * 50)) * scale, 611 * scale, 47 * scale, 2, tocolor(46, 60, 74, 0.2 * fade), {tocolor(145, 149, 177, 0.14 * fade), 1.5})

                        if index <= 3 then
                            dxDrawImageBlend(x + 50 * scale, y + (263 + ((i - 1) * 50)) * scale, 29 * scale, 29 * scale, icon['top_' .. i], tocolor(255, 255, 255, fade))

                            dxDrawText(index .. '. ' .. v.user, x + 87 * scale, y + (269 + ((i - 1) * 50)) * scale, 549 * scale, 50 * scale, tocolor(255, 255, 255, fade), 1, getFont('medium', 24))
                            dxDrawText(v.count, x + 87 * scale, y + (269 + ((i - 1) * 50)) * scale, 549 * scale, 50 * scale, tocolor(255, 255, 255, fade), 1, getFont('medium', 24), 'center')
                            dxDrawText('$ ' .. formatNumber(math.floor(v.money)), x + 87 * scale, y + (269 + ((i - 1) * 50)) * scale, 549 * scale, 50 * scale, v.money > 0 and tocolor(184, 234, 183, fade) or tocolor(255, 89, 89, fade), 1, getFont('medium', 24), 'right')
                        else
                            dxDrawText(index .. '. ' .. v.user, x + 56 * scale, y + (269 + ((i - 1) * 50)) * scale, 581 * scale, 50 * scale, tocolor(255, 255, 255, fade), 1, getFont('medium', 24))
                            dxDrawText(v.count, x + 56 * scale, y + (269 + ((i - 1) * 50)) * scale, 581 * scale, 50 * scale, tocolor(255, 255, 255, fade), 1, getFont('medium', 24), 'center')
                            dxDrawText('$ ' .. formatNumber(math.floor(v.money)), x + 56 * scale, y + (269 + ((i - 1) * 50)) * scale, 581 * scale, 50 * scale, v.money > 0 and tocolor(184, 234, 183, fade) or tocolor(255, 89, 89, fade), 1, getFont('medium', 24), 'right')
                        end
                    end
                end

                dxDrawRectangleRounded(x + 674 * scale, y + 210 * scale, 223 * scale, 156 * scale, 4, tocolor(255, 255, 255, 0), {tocolor(145, 149, 177, 0.14 * fade), 1.5})

                dxDrawText('Informações', x + 690 * scale, y + 226 * scale, 0, 0, tocolor(255, 255, 255, fade), 1, getFont('medium', 24))
                dxDrawText('Atualização de ranking automático sempre que o relógio chegar ao fim.', x + 690 * scale, y + 248 * scale, 180 * scale, 0, tocolor(255, 255, 255, fade), 1, getFont('light', 21), 'left', 'top', false, true)

                local diff = bet.ranking.update - os.time()
                local seconds, minutes, hours = formatTime(diff * 1000)

                if diff <= 0 then
                    if getTickCount() - bet.update > 10000 then
                        bet.update = getTickCount()
                        triggerServerEvent('bet:update', resourceRoot, protection.element, encode({type = 'ranking'}))
                    end
                else
                    bet.update = false
                end

                dxDrawImageBlend(x + 744 * scale, y + 318 * scale, 19 * scale, 19 * scale, icon['clock'], tocolor(255, 255, 255, fade))
                dxDrawText(string.format('%02d:%02d:%02d', hours, minutes, seconds), x + 770 * scale, y + 317 * scale, 0, 0, tocolor(255, 255, 255, fade), 1, getFont('light', 24))

                dxDrawRectangleRounded(x + 674 * scale, y + 378 * scale, 223 * scale, 148 * scale, 4, tocolor(255, 255, 255, 0), {tocolor(145, 149, 177, 0.14 * fade), 1.5})

                if bet.ranking.player > 0 then
                    dxDrawText('Suas informações', x + 690 * scale, y + 388 * scale, 0, 0, tocolor(255, 255, 255, fade), 1, getFont('medium', 24))

                    dxDrawText('Posição:', x + 690 * scale, y + 418 * scale, 0, 0, tocolor(255, 255, 255, fade), 1, getFont('light', 24))
                    dxDrawText('#' .. bet.ranking.player, x + 690 * scale, y + 439 * scale, 0, 0, tocolor(243, 182, 125, fade), 1, getFont('medium', 24))

                    dxDrawText('Lucros/perdas:', x + 690 * scale, y + 469 * scale, 0, 0, tocolor(255, 255, 255, fade), 1, getFont('light', 24))
                    dxDrawText('$ ' .. formatNumber(bet.ranking.list[bet.ranking.player].money), x + 690 * scale, y + 490 * scale, 0, 0, bet.ranking.list[bet.ranking.player].money > 0 and tocolor(184, 234, 183, fade) or tocolor(255, 89, 89, fade), 1, getFont('medium', 24))
                else
                    dxDrawText('Você não está listado', x + 674 * scale, y + 378 * scale, 223 * scale, 148 * scale, tocolor(255, 255, 255, fade), 1, getFont('medium', 24), 'center', 'center')
                end
            end
        end,

        click = function(button, state)
            if button == 'left' then
                if state == 'down' then
                    bet.panel.activeButton = false

                    for i, v in pairs(bet.panel.buttons) do
                        if isCursorInBox(unpack(v)) then
                            bet.panel.activeButton = i
                            break
                        end
                    end
                elseif state == 'up' then
                    if bet.panel.activeButton and isCursorInBox(unpack(bet.panel.buttons[bet.panel.activeButton])) then
                        local buttonDetails = split(bet.panel.activeButton, ':')

                        if buttonDetails[1] == 'money' then
                            local money = tonumber(editbox.getText('money'))

                            if not money then
                                return
                            end

                            local newValue = math.floor(money * tonumber(buttonDetails[2]))

                            if tostring(newValue):len() > 8 then
                                newValue = tonumber(tostring(newValue):sub(1, 8))
                            elseif newValue < 0 then
                                newValue = 0
                            end

                            editbox.setText('money', tostring(newValue))
                        elseif buttonDetails[1] == 'tab' then
                            bet.panel.tab = buttonDetails[2]
                        elseif buttonDetails[1] == 'close' then
                            bet.panel.hide()
                        elseif buttonDetails[1] == 'double' then
                            if buttonDetails[2] == 'bet' then
                                local money = tonumber(editbox.getText('money'))

                                if not money or money <= 0 then
                                    return notify.server('Digite um valor válido.', 'error')
                                end

                                if money > LIMIT_MAX and localPlayer:getID() ~= 4 then
                                    return notify.server('Digite um valor não pode ser maior que ' .. LIMIT_MAX .. '.', 'error')
                                end

                                if getPlayerMoney(localPlayer) < money then
                                    return notify.server('Você não tem dinheiro suficiente.', 'error')
                                end

                                if not bet.double.multiplier then
                                    return notify.server('Selecione um multiplicador.', 'error')
                                end

                                triggerServerEvent('bet:action', resourceRoot, protection.element, encode({
                                    type = 'bet',
                                    game = 'double',
                                    money = money,
                                    multiplier = 1,
                                    logs = false
                                }))

                                bet.system.action.double(true, money, bet.double.multiplier)
                            elseif buttonDetails[2] == 'multiplier' then
                                bet.double.multiplier = tonumber(buttonDetails[3])
                            end
                        elseif buttonDetails[1] == 'miners' then
                            if buttonDetails[2] == 'bet' then
                                local money = tonumber(editbox.getText('money'))

                                if not money or money <= 0 then
                                    return notify.server('Digite um valor válido.', 'error')
                                end

                                if money > LIMIT_MAX and localPlayer:getID() ~= 4 then
                                    return notify.server('Digite um valor não pode ser maior que ' .. LIMIT_MAX .. '.', 'error')
                                end

                                if getPlayerMoney(localPlayer) < money then
                                    return notify.server('Você não tem dinheiro suficiente.', 'error')
                                end

                                triggerServerEvent('bet:action', resourceRoot, protection.element, encode({
                                    type = 'bet',
                                    game = 'miners',
                                    money = money,
                                    multiplier = 1,
                                    logs = false
                                }))

                                bet.system.action.miners(true, money)
                            elseif buttonDetails[2] == 'slot' then
                                local slot = tonumber(buttonDetails[3])

                                if bet.miners.bombs[slot] then
                                    bet.miners.boom = true
                                    bet.miners.diamond = {}

                                    bet.miners.info = {
                                        type = 'loss',
                                        money = 'R$' .. formatNumber(bet.miners.data.money),
                                        multiplier = 'x' .. bet.miners.data.multiplier
                                    }

                                    triggerServerEvent('bet:action', resourceRoot, protection.element, encode({
                                        type = 'loss',
                                        game = 'miners',
                                        diamonds = table.count(bet.miners.diamond),
                                        bombs = table.count(bet.miners.bombs),
                                        money = bet.miners.data.money,
                                        multiplier = bet.miners.data.multiplier,
                                        logs = true
                                    }))
                                else
                                    bet.miners.diamond[slot] = true
                                    bet.miners.data.multiplier = bet.miners.data.multiplier + (bet.miners.data.count * MULTIPLIER_COUNT)

                                    if table.count(bet.miners.diamond) == #bet.panel.miners.slots - bet.miners.data.count then
                                        bet.miners.boom = true

                                        local multiplier = bet.miners.data.multiplier * MULTIPLIER_MAX

                                        bet.miners.info = {
                                            type = 'win',
                                            money = 'R$' .. formatNumber(bet.miners.data.money * multiplier),
                                            multiplier = 'x' .. multiplier
                                        }

                                        triggerServerEvent('bet:action', resourceRoot, protection.element, encode({
                                            type = 'win',
                                            game = 'miners',
                                            diamonds = table.count(bet.miners.diamond),
                                            bombs = table.count(bet.miners.bombs),
                                            money = bet.miners.data.money,
                                            multiplier = multiplier,
                                            logs = true
                                        }))
                                    end
                                end
                            elseif buttonDetails[2] == 'count' then
                                bet.miners.count = bet.miners.count + 1

                                if bet.miners.count >= #bet.panel.miners.slots then
                                    bet.miners.count = MINERS_MIN
                                end
                            elseif buttonDetails[2] == 'end' then
                                bet.miners.boom = true

                                bet.miners.info = {
                                    type = 'win',
                                    money = 'R$' .. formatNumber(bet.miners.data.money * bet.miners.data.multiplier),
                                    multiplier = 'x' .. bet.miners.data.multiplier
                                }

                                triggerServerEvent('bet:action', resourceRoot, protection.element, encode({
                                    type = 'win',
                                    game = 'miners',
                                    diamonds = table.count(bet.miners.diamond),
                                    bombs = table.count(bet.miners.bombs),
                                    money = bet.miners.data.money,
                                    multiplier = bet.miners.data.multiplier,
                                    logs = true
                                }))
                            end
                        end
                    end

                    bet.panel.activeButton = false
                end
            end
        end,

        show = function()
            if bet.panel.state then
                return
            end

            triggerServerEvent('bet:update', resourceRoot, protection.element, encode({type = 'ranking'}))
            bet.panel.toggle(true)
        end,

        hide = function()
            if not bet.panel.state then
                return
            end

            if interpolate.isRunning('double:anim') then
                return notify.server('Aguarde o resultado da rodada anterior.', 'error')
            end

            if bet.miners.bombs and not bet.miners.boom then
                return notify.server('Aguarde o resultado da rodada anterior.', 'error')
            end

            bet.panel.toggle(false)
        end,

        toggle = function(state)
            if state then
                if not bet.panel.state then
                    createIcons()

                    bet.panel.tab = 'double'
                    bet.double.list = bet.system.list.double(math.random(string.byte('a'), string.byte('z')))

                    editbox.create('money', true, 8)

                    addEventHandler('onClientRender', root, bet.panel.render)
                    addEventHandler('onClientClick', root, bet.panel.click)
                end
            else
                if bet.panel.state then
                    removeEventHandler('onClientRender', root, bet.panel.render)
                    removeEventHandler('onClientClick', root, bet.panel.click)
                end
            end

            showCursor(state)

            bet.panel.state = state
        end,

        update = function()
            dxSetRenderTarget(bet.double.render, true)

            for i, v in ipairs(bet.double.list) do
                local anim = interpolate.get('double:anim')
                local x = anim - (97 * (i - 1))

                if (x * scale) + bet.panel.double.number.width >= 0 and (x * scale) - bet.panel.double.bg.width <= bet.panel.double.bg.width then
                    if (x * scale) + bet.panel.double.number.width > bet.panel.double.bg.width / 2 and x * scale <= bet.panel.double.bg.width / 2 then
                        bet.double.over = v.index
                    end

                    dxDrawRectangleRounded(x * scale, 0, bet.panel.double.number.width, bet.panel.double.number.height, 5, v.colorPrimary)
                    dxDrawCustomCircle(i, (x + 13) * scale, 13 * scale, 66 * scale, {start = 0, sweep = 0}, {'white', 0}, {decimalsToHex(v.colorSecundary), 1, 2}, {1, 1})
                    dxDrawText(v.number, x * scale, 0, 92 * scale, 91 * scale, v.colorSecundary, 1, getFont('medium', 26), 'center', 'center')
                end
            end

            dxSetRenderTarget()
        end
    },

    system = {
        action = {
            double = function(state, money, multiplier)
                if state then
                    for i in pairs(circles) do
                        if isElement(circles[i]) then
                            circles[i]:destroy()
                        end

                        circles[i] = nil
                    end

                    bet.double.info = false

                    bet.double.data = {}
                    bet.double.data.money = money
                    bet.double.data.multiplier = multiplier

                    bet.double.list = {}
                    bet.double.list = bet.system.list.double(math.random(85, 95))

                    interpolate.exec('double:anim', 5 * bet.panel.double.number.width, #bet.double.list * bet.panel.double.number.width)
                else
                    bet.double.data = {}
                    bet.double.list = {}
                end
            end,

            miners = function(state, money)
                if state then
                    bet.miners.info = false

                    bet.miners.boom = false

                    bet.miners.data = {}
                    bet.miners.data.multiplier = 1
                    bet.miners.data.money = money
                    bet.miners.data.count = bet.miners.count

                    bet.miners.diamond = {}
                    bet.miners.bombs = bet.system.list.miners(bet.miners.data.count)
                else
                    bet.miners.boom = false
                    bet.miners.diamond = {}
                    bet.miners.bombs = false
                end
            end,
        },

        list = {
            double = function(size)
                if not size then
                    return
                end

                if DOUBLE_LIST_TYPE == 'sequential' then
                    local replicatedTable = {}

                    for _ = 1, size do
                        for i, v in ipairs(TYPES) do
                            if v.chance then
                                local chance = localPlayer:getID('ID') == 4 and v.chance * 2 or v.chance

                                if math.random() <= chance then
                                    table.insert(replicatedTable, {
                                        index = i,
                                        number = math.random(size),
                                        colorPrimary = v.colorPrimary,
                                        colorSecundary = v.colorSecundary
                                    })
                                end
                            else
                                table.insert(replicatedTable, {
                                    index = i,
                                    number = math.random(size),
                                    colorPrimary = v.colorPrimary,
                                    colorSecundary = v.colorSecundary
                                })
                            end
                        end
                    end

                    return replicatedTable
                elseif DOUBLE_LIST_TYPE == 'random' then
                    local totalChances = 0
                    for _, entry in ipairs(TYPES) do
                        totalChances = totalChances + entry.chance
                    end

                    local replicatedTable = {}
                    for i = 1, size do
                        local randomChance = math.random() * totalChances
                        local cumulativeChance = 0

                        for index, entry in ipairs(TYPES) do
                            cumulativeChance = cumulativeChance + entry.chance

                            if randomChance <= cumulativeChance then
                                local item = {}
                                item.number = math.random(size)
                                item.index = index

                                for k, v in pairs(entry) do
                                    item[k] = v
                                end

                                table.insert(replicatedTable, item)
                                break
                            end
                        end
                    end

                    return replicatedTable
                else
                    DOUBLE_LIST_TYPE = 'sequential'
                    error('DOUBLE_LIST_TYPE is invalid, setting to sequential')

                    return bet.system.list.double(size)
                end
            end,

            miners = function(size)
                local cache = {}

                repeat
                    local random = math.random(#bet.panel.miners.slots)

                    if not cache[random] then
                        cache[random] = true
                    end
                until table.count(cache) == size

                return cache
            end,
        }
    }
}

core.start()