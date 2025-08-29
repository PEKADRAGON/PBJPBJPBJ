function registerEvent(event, element, callback)
    addEvent(event, true)
    addEventHandler(event, element, callback)
end

function sendLogs(message, webhook)
    local postData = {
        queueName = 'dcq',
        connectionAttempts = 3,
        connectTimeout = 5000,
        formFields = {
            content=' \n' .. message .. ' '
        },
    }

    fetchRemote(webhook, postData, function() end)
end

function sendCustomLogs(title, color, webhook, ...)
    local fields = {...}

    local data = {
        embeds = {
            {
                title = title,
                color = color,
                fields = {},

                thumbnail = {
                    url = "https://images-ext-1.discordapp.net/external/_09eK5yIwNJf4azhr4wRoc_hCK84uZWJqJxG6AtcB9c/%3Fsize%3D2048/https/cdn.discordapp.com/icons/986179463647752272/a_63e0158fbdcabd3019bb9e13d03b74c6.gif?width=341&height=341"
                },

                footer = {
                    text = 'Hoje ás ' .. os.date ('%H:%M') .. ' | ' .. os.date ('%d/%m/%Y'),
                    icon_url = "https://images-ext-1.discordapp.net/external/_09eK5yIwNJf4azhr4wRoc_hCK84uZWJqJxG6AtcB9c/%3Fsize%3D2048/https/cdn.discordapp.com/icons/986179463647752272/a_63e0158fbdcabd3019bb9e13d03b74c6.gif?width=341&height=341",
                },
            }
        }
    }

    for i = 1, #fields do
        table.insert(data['embeds'][1]['fields'], fields[i])
    end

    data = toJSON (data)
    data = data:sub(2, -2)

    local post = {
        connectionAttempts = 5,
        connectTimeout = 7000,
        headers = {
            ['Content-Type'] = 'application/json'
        },
        postData = data
    }

    return fetchRemote(webhook, post, function() end)
end

function formatNumber(amount)
    local left, center, right = string.match(math.floor(amount), '^([^%d]*%d)(%d*)(.-)$')
    return left .. string.reverse(string.gsub(string.reverse(center), '(%d%d%d)', '%1.')) .. right
end