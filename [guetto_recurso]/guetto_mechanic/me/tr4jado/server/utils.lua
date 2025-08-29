function registerEvent(event, element, callback)
    addEvent(event, true)
    addEventHandler(event, element, callback)
end