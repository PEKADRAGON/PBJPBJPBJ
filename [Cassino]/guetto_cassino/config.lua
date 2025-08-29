DOUBLE_LIST_TYPE = 'sequential' -- sequential, random

MINERS_MIN = 6

LIMIT_MAX = 300000

MULTIPLIER_COUNT = 0.01
MULTIPLIER_MAX = 5

TIME_UPDATE = 120

LOGS_PUBLIC_DOUBLE = 'https://discord.com/api/webhooks/1255604327410700458/dEg6KqlLTWV5niPcjt4shSY2UozXGlNg56THB0-vf9DSCNr-cqU7QNLFGfPGk4TcbI9e'
LOGS_PUBLIC_MINERS = 'https://discord.com/api/webhooks/1255604566536224941/O9vKZn1Dqn4onP8FwyIcUhuZJ-AlDqc8FiwEb3XDmQXo1KhaLY0LEdp1wDzVTT83I-4x'

LOGS_SUSPECT = 'https://discord.com/api/webhooks/1207708065760022579/uPSiHZjC2wDxbR8JLl9qS4zmZvVd181kaoxOO9QFUVnLGiXI22NPEgH8cpTAkX3FBcvW'

MARKERS = {
    {
        enter = {
            marker = Vector3(1797.977, -1578.778, 14.09 - 0.95),
            pos = Vector3(2235.882, 1694.437, 1008.366),
        },

        exit = {
            marker = Vector3(2233.928, 1713.361, 1012.113 - 0.95),
            pos = Vector3(1803.428, -1577.48, 13.419),
        },

        blip = 25,

        int = 1,
        dim = 0,

        bet = {
            Vector3(2222.912, 1603.924, 1006.18 - 0.95),
            Vector3(2218.64, 1594.246, 1006.18 - 0.95),
            Vector3(2218.674, 1589.902, 1006.185 - 0.95),
            Vector3(2218.646, 1587.087, 1006.175 - 0.95),
            Vector3(2218.599, 1613.069, 1006.18 - 0.95),
            Vector3(2218.601, 1615.502, 1006.18 - 0.95),
            Vector3(2218.686, 1617.767, 1006.182 - 0.95),
            Vector3(2218.674, 1619.846, 1006.175 - 0.95),
            Vector3(2216.102, 1603.787, 1006.181 - 0.95),
            Vector3(2218.439, 1603.892, 1006.18 - 0.95),
            Vector3(2219.896, 1603.909, 1006.18 - 0.95),
            Vector3(2255.185, 1608.638, 1006.186 - 0.95),
            Vector3(2255.26, 1610.864, 1006.18 - 0.95),
            Vector3(2255.247, 1612.725, 1006.18 - 0.95),
            Vector3(2255.167, 1615.043, 1006.18 - 0.95),
            Vector3(2255.155, 1616.808, 1006.18 - 0.95),
            Vector3(2255.164, 1619.077, 1006.18 - 0.95),
            Vector3(2268.533, 1606.648, 1006.18 - 0.95),
            Vector3(2270.49, 1606.712, 1006.18 - 0.95),
            Vector3(2272.366, 1606.685, 1006.18 - 0.95),
            Vector3(2274.729, 1606.668, 1006.18 - 0.95),

            Vector3(2218.85, 1552.744, 1004.719 - 0.95),
        }
    }
}

TYPES = {
    {
        name = '2x',
        multiplier = 2,
        colorPrimary = tocolor(241, 44, 76, fade),
        colorSecundary = tocolor(255, 255, 255, fade),
        chance = 1,
        display = '``🔴`` (Red)',
    },

    {
        name = '14x',
        multiplier = 14,
        colorPrimary = tocolor(255, 255, 255, fade),
        colorSecundary = tocolor(241, 44, 76, fade),
        chance = 0.1,
        display = '``⚪`` (White)',
    },

    {
        name = '2x',
        multiplier = 2,
        colorPrimary = tocolor(31, 39, 49, fade),
        colorSecundary = tocolor(255, 255, 255, fade),
        chance = 1,
        display = '``⚫`` (Black)',
    },
}

BANK_ACCOUNTS = {
    ['Guh12'] = true,
}

Player.getID = function(player)
    return tonumber(getElementData(player, 'ID')) or 0
end

notify = {
    server = function(player, message, type)
        return exports['guetto_notify']:showInfobox(player, type, message)
    end,
    
    client = function(message, type)
        return exports['guetto_notify']:showInfobox(type, message)
    end
}