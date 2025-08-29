core = {
    start = function()
        local minersMultiplier = (28 * MULTIPLIER_COUNT) * MULTIPLIER_MAX
        local doubleMultiplier = 0

        for i, v in ipairs(TYPES) do
            doubleMultiplier = doubleMultiplier + v.multiplier
        end

        doubleMultiplier = doubleMultiplier * MULTIPLIER_MAX

        MULTIPLIER_ALLOW = math.max(minersMultiplier, doubleMultiplier)

        TIME_UPDATE = TIME_UPDATE * 60000

        Timer(function()
            if isElement(protection.element) then
                sourceTimer:destroy()

                connection = Connection('sqlite', 'database/main.db')

                if connection then
                    connection:exec('CREATE TABLE IF NOT EXISTS players (user, money, count)')
                    connection:exec('CREATE TABLE IF NOT EXISTS bank (money)')

                    connection:query(function(query)
                        local result = query:poll(-1)

                        if #result == 0 then
                            connection:exec('INSERT INTO bank (money) VALUES (?)', 0)
                        end
                    end, 'SELECT * FROM bank')
                end

                bet.events.start()
            end
        end, 1000, 0)
    end
}

bet = {
    markers = {},

    update = 0,
    ranking = {},
    timer = false,

    events = {
        start = function()
            for i, v in ipairs(MARKERS) do
                local enter = Marker(v.enter.marker, 'cylinder', 1, 141, 106, 240, 0)
                setElementData(enter, "markerData", {title = "Entrada", desc = "Entre no cassino", icon = "entrada"})

                local exit = Marker(v.exit.marker, 'cylinder', 1, 141, 106, 240, 0)
                setElementData(exit, "markerData", {title = "Saida", desc = "Saia no cassino", icon = "entrada"})

                Blip.createAttachedTo(enter, v.blip)

                exit:setInterior(v.int)
                exit:setDimension(v.dim)

                bet.markers[enter] = {i, 'enter'}
                bet.markers[exit] = {i, 'exit'}

                for _, pos in ipairs(v.bet) do
                    local marker = Marker(pos, 'cylinder', 1, 141, 106, 240, 0)
                    setElementData(marker, "markerData", {title = "Apostas", desc = "Realize suas apostas", icon = "slotMachine"})

                    marker:setInterior(v.int)
                    marker:setDimension(v.dim)

                    bet.markers[marker] = {i, 'bet'}
                end
            end

            addCommandHandler('cassino', bet.commands.cassino)

            addEventHandler('onMarkerHit', resourceRoot, bet.events.marker.hit)
            addEventHandler('onMarkerLeave', resourceRoot, bet.events.marker.leave)

            registerEvent('bet:action', resourceRoot, bet.custom.action)
            registerEvent('bet:update', resourceRoot, bet.custom.update)

            bet.system.update()
        end,

        marker = {
            hit = function(player, dimension)
                if not dimension then
                    return
                end

                if player.type ~= 'player' then
                    return
                end

                local data = bet.markers[source]

                if not data then
                    return
                end

                if data[2] == 'enter' then
                    local datas = MARKERS[data[1]]

                    fadeCamera(player, false)

                    Timer(function()
                        player:setPosition(datas.enter.pos)
                        player:setInterior(datas.int)
                        player:setDimension(datas.dim)
                        fadeCamera(player, true)
                    end, 1000, 1)
                elseif data[2] == 'exit' then
                    local datas = MARKERS[data[1]]

                    fadeCamera(player, false)

                    Timer(function()
                        player:setPosition(datas.exit.pos)
                        player:setInterior(0)
                        player:setDimension(0)
                        fadeCamera(player, true)
                    end, 1000, 1)
                elseif data[2] == 'bet' then
                    triggerClientEvent(player, 'bet:show', resourceRoot)
                end
            end,

            leave = function(player, dimension)
                if player.type ~= 'player' then
                    return
                end

                if not bet.markers[source] then
                    return
                end

                triggerClientEvent(player, 'bet:hide', resourceRoot)
            end
        }
    },

    commands = {
        cassino = function(player, command, type)
            if not BANK_ACCOUNTS[player.account.name] then
                return
            end

            if type == 'update' then
                bet.system.update()
                notify.server(player, 'O ranking do cassino foi atualizado.', 'success')
            elseif type == 'banco' then
                local money = bet.system.bank.get()
                notify.server(player, 'O banco do cassino possui $' .. formatNumber(money) .. '.', 'info')
            elseif type == 'resgatar' then
                local money = bet.system.bank.get()

                if money <= 0 then
                    notify.server(player, 'O banco do cassino está vazio.', 'error')
                    return
                end

                bet.system.bank.take(money)
                player:giveMoney(money)

                notify.server(player, 'Você retirou $' .. formatNumber(money) .. ' do banco do cassino.', 'success')
            else
                notify.server(player, 'Use: /cassino [update/banco/resgatar]', 'error')
            end
        end
    },

    custom = {
        action = function(_, data)
            data = decode(data)

            if _ ~= protection.element or not data or type(data) ~= 'table' then
                sendLogs('```[' .. os.date('%d/%m/%Y | %H:%M', os.time()) .. '] O jogador ' .. client.name .. ' tentou burlar o sistema.\nMotivo: protection element```', LOGS_SUSPECT)
                return false
            end

            if data.multiplier > MULTIPLIER_ALLOW or data.money < 0 then
                sendLogs('```[' .. os.date('%d/%m/%Y | %H:%M', os.time()) .. '] O jogador ' .. client.name .. ' tentou burlar o sistema.\nMotivo: multiplier/money no allow```', LOGS_SUSPECT)
                return
            end

            local amount = data.money

            if data.type == 'win' then
                amount = amount * data.multiplier

                client:giveMoney(amount)

                if data.multiplier > 1 then
                    connection:query(function(query, player)
                        local result = query:poll(-1)

                        if #result == 0 then
                            connection:exec('INSERT INTO players (user, money, count) VALUES (?, ?, ?)', player.account.name, amount, 1)
                        else
                            connection:exec('UPDATE players SET money = ?, count = ? WHERE user = ?', math.floor(tonumber(result[1].money) + amount), result[1].count + 1, player.account.name)
                        end
                    end, {client}, 'SELECT * FROM players WHERE user = ?', client.account.name)

                    bet.system.bank.take(amount)

                    if data.logs then
                        if data.game == 'miners' then
                            sendCustomLogs('🟢 WIN', 0x8FE879, LOGS_PUBLIC_MINERS, {
                                name = '`🐱‍👤` Informações',
                                value = string.format('\n`🧑` **Jogador:** %s\n`🔒` **Valor apostado:** %s\n`🤑` **Valor ganho:** %s', client.name .. ' ('.. client:getID() ..')', formatNumber(data.money), formatNumber(amount)),
                                inline = true
                            }, {
                                name = '`🎰` Resultado',
                                value = string.format('\n`🎲` **Multiplicador:** %sx\n`💎` **Diamantes:** %s\n`💣` **Bombas:** %s', data.multiplier, data.diamonds .. '/' .. 28 - data.bombs, '0/' .. data.bombs),
                                inline = true
                            })
                        elseif data.game == 'double' then
                            sendCustomLogs('🟢 WIN', 0x8FE879, LOGS_PUBLIC_DOUBLE, {
                                name = '`🐱‍👤` Informações',
                                value = string.format('\n`🧑` **Jogador:** %s\n`🔒` **Valor apostado:** %s\n`🤑` **Valor ganho:** %s', client.name .. ' ('.. client:getID() ..')', formatNumber(data.money), formatNumber(amount)),
                                inline = true
                            }, {
                                name = '`🎰` Resultado',
                                value = string.format('\n`🎲` **Multiplicador:** %sx\n`🎨` **Cor escolhida:** %s', data.multiplier, TYPES[data.selected].display),
                                inline = true
                            })
                        end
                    end
                end
            elseif data.type == 'loss' then
                connection:query(function(query, player)
                    local result = query:poll(-1)

                    if #result == 0 then
                        connection:exec('INSERT INTO players (user, money, count) VALUES (?, ?, ?)', player.account.name, -amount, 1)
                    else
                        connection:exec('UPDATE players SET money = ?, count = ? WHERE user = ?', math.floor(tonumber(result[1].money) - amount), result[1].count + 1, player.account.name)
                    end
                end, {client}, 'SELECT * FROM players WHERE user = ?', client.account.name)

                bet.system.bank.give(amount)

                if data.logs then
                    if data.game == 'miners' then
                        sendCustomLogs('🔴 LOSS', 0xFF5050, LOGS_PUBLIC_MINERS, {
                            name = '`🐱‍👤` Informações',
                            value = string.format('\n`🧑` **Jogador:** %s\n`🔒` **Valor apostado:** %s', client.name .. ' ('.. client:getID() ..')', formatNumber(data.money)),
                            inline = true
                        }, {
                            name = '`🎰` Resultado',
                            value = string.format('\n`🎲` **Multiplicador:** %sx\n`💎` **Diamantes:** %s\n`💣` **Bombas:** %s', data.multiplier, data.diamonds .. '/' .. 28 - data.bombs, '1/' .. data.bombs),
                            inline = true
                        })
                    elseif data.game == 'double' then
                        sendCustomLogs('🔴 LOSS', 0xFF5050, LOGS_PUBLIC_DOUBLE, {
                            name = '`🐱‍👤` Informações',
                            value = string.format('\n`🧑` **Jogador:** %s\n`🔒` **Valor apostado:** %s', client.name .. ' ('.. client:getID() ..')', formatNumber(data.money)),
                            inline = true
                        }, {
                            name = '`🎰` Resultado',
                            value = string.format('\n`🎲` **Multiplicador:** %sx\n`🎨` **Cor escolhida:** %s\n`🤞` **Cor sorteada:** %s', data.multiplier, TYPES[data.selected].display, TYPES[data.over].display),
                            inline = true
                        })
                    end
                end
            elseif data.type == 'bet' then
                if client.money < amount then
                    notify.server(client, 'Você não possui dinheiro suficiente para realizar esta aposta.', 'error')
                    sendLogs('```[' .. os.date('%d/%m/%Y | %H:%M', os.time()) .. '] O jogador ' .. client.name .. ' tentou burlar o sistema.\nMotivo: no money```', LOGS_SUSPECT)
                    return
                end

                client:takeMoney(amount)
            else
                sendLogs('```[' .. os.date('%d/%m/%Y | %H:%M', os.time()) .. '] O jogador ' .. client.name .. ' tentou burlar o sistema.\nMotivo: no type```', LOGS_SUSPECT)
            end
        end,

        update = function(_, data)
            if _ ~= protection.element then
                sendLogs('```[' .. os.date('%d/%m/%Y | %H:%M', os.time()) .. '] O jogador ' .. client.name .. ' tentou burlar o sistema.\nMotivo: protection element```', LOGS_SUSPECT)
                return
            end

            data = decode(data)

            if not data or type(data) ~= 'table' then
                sendLogs('```[' .. os.date('%d/%m/%Y | %H:%M', os.time()) .. '] O jogador ' .. client.name .. ' tentou burlar o sistema.\nMotivo: no data```', LOGS_SUSPECT)
                return
            end

            if data.type == 'ranking' then
                local index = 0

                for i, v in ipairs(bet.ranking) do
                    if v.user == client.account.name then
                        index = i
                        break
                    end
                end

                triggerClientEvent(client, 'bet:update', resourceRoot, protection.element, encode({list = bet.ranking, player = index, update = bet.update}))
            else
                sendLogs('```[' .. os.date('%d/%m/%Y | %H:%M', os.time()) .. '] O jogador ' .. client.name .. ' tentou burlar o sistema.\nMotivo: no type```', LOGS_SUSPECT)
            end
        end
    },

    system = {
        update = function()
            bet.ranking = {}
            bet.update = os.time() + TIME_UPDATE / 1000

            connection:query(function(query)
                local result = query:poll(-1)
                bet.ranking = result

                table.sort(bet.ranking, function(a, b)
                    return a.money > b.money
                end)
            end, 'SELECT * FROM players')

            if isElement(bet.timer) then
                bet.timer:destroy()
            end

            bet.timer = Timer(function()
                bet.system.update()
            end, TIME_UPDATE, 1)
        end,

        bank = {
            give = function(amount)
                connection:query(function(query)
                    local result = query:poll(-1)
                    connection:exec('UPDATE bank SET money = ? WHERE money = ?', math.floor(tonumber(result[1].money) + amount), tonumber(result[1].money))
                end, 'SELECT * FROM bank')
            end,

            take = function(amount)
                connection:query(function(query)
                    local result = query:poll(-1)
                    connection:exec('UPDATE bank SET money = ? WHERE money = ?', math.floor(tonumber(result[1].money) - amount), tonumber(result[1].money))
                end, 'SELECT * FROM bank')
            end,

            get = function()
                local result = connection:query('SELECT * FROM bank'):poll(-1)
                return tonumber(result[1].money)
            end
        }
    }
}

core.start()