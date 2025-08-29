function dx()
    cancelEvent ()
end
  
addEvent("JOAO.godMode",true)
addEventHandler("JOAO.godMode", root,
function(type_)
    if type_ then
        if (source == getLocalPlayer()) then
            if not isEventHandlerAdded('onClientPlayerDamage', root, dx) then
                addEventHandler("onClientPlayerDamage", root, dx)
            end
        end
    else
        if (source == getLocalPlayer()) then
            if isEventHandlerAdded('onClientPlayerDamage', root, dx) then
                removeEventHandler("onClientPlayerDamage", root, dx)
            end
        end
    end
end)

addEventHandler("onClientPlayerDamage", root,
function()
    if (getElementData(source, "JOAO.removeDano") or false) then
        cancelEvent()
    end
end)
 
addEventHandler("onClientPlayerStealthKill", localPlayer,
function(targetPlayer)
    if (getElementData(targetPlayer, "JOAO.removeDano") or false) then
        cancelEvent()
    end
end)

addEventHandler("onClientPlayerWeaponFire", localPlayer,
function()
    if (getElementData(source, "JOAO.removeDano") or false) then
        takeAllWeapons(source)
    end
end)

addEvent("onPlayerEnterColShape", true)
addEventHandler("onPlayerEnterColShape", root, function (state)
    if state then 
        for _, otherPlayer in ipairs(getElementsByType("player")) do
            setElementCollidableWith(localPlayer, otherPlayer, false)
        end
    else
        for _, otherPlayer in ipairs(getElementsByType("player")) do
            setElementCollidableWith(localPlayer, otherPlayer, true)
        end
    end
end)


addEventHandler("onClientKey", root, function(button, state)
    if getElementData(localPlayer, "JOAO.removeDano")then 
        if getBoundKeys('fire')[button] then
            cancelEvent()
        end
    end
end)

function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
    if type( sEventName ) == 'string' and isElement( pElementAttachedTo ) and type( func ) == 'function' then
        local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
        if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
            for i, v in ipairs( aAttachedFunctions ) do
                if v == func then
                    return true
                end
            end
        end
    end
    return false
end