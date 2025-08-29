protection = {
    element = false,
    key = 'my_secret_key',

    start = function()
        addEvent('protection_request', true)
        addEventHandler('protection_request', resourceRoot, protection.transfer)

        addEventHandler('onPlayerLogin', root, protection.login)
    end,

    transfer = function()
        local letters = {'A', 'B', 'C', 'D', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'}

        local key = ''

        for _ = 1, math.random(10, 20) do
            key = key .. letters[math.random(1, #letters)]
        end

        protection.element = createElement(key, math.random(10000))
        protection.key = string.rep(string.char(math.random(string.byte('Z'), string.byte('a'))), 10)

        triggerClientEvent('protection_transfer', resourceRoot, protection.element, protection.key)
    end,

    login = function()
        if not protection.element then
            error('Protection element not found.')
            return
        end

        triggerClientEvent('protection_transfer', resourceRoot, protection.element)
    end
}

protection.start()