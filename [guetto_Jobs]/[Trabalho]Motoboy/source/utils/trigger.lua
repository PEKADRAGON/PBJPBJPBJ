function addCustomEventHandler(name, func, getPropagated, priority)
    addEvent(name, true)
    return addEventHandler(name, root, func, getPropagated, priority)
end