protection = {
    element = false,
    key = 'my_secret_key',

    start = function()
        addEvent('protection_transfer', true)
        addEventHandler('protection_transfer', resourceRoot, protection.receiver)

        triggerServerEvent('protection_request', resourceRoot)
    end,

    receiver = function(element, key)
        protection.element = element
        protection.key = key
        addEvent('protection_transfer', false)
    end
}

protection.start()