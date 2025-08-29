local time = 25

function displayLoadedRes(res)
    setWeaponProperty(23, "poor", "damage", 0)
    setWeaponProperty(23, "std", "damage", 0)
    setWeaponProperty(23, "pro", "damage", 0)
end

function onParalyzed(element)
    if not client then
        return false
    end

    local resourceRootElement = getResourceDynamicElementRoot(getResourceFromName("guetto_taser"))
    if not resourceRootElement or source ~= resourceRootElement then
        outputDebugString(getPlayerName(client) .. "#" .. (getElementData(client, "ID") or "N/A") .. " [" .. (getResourceName(getThisResource())) .. "] Tentativa de utilizar trigger", 1)
        return banPlayer(client, false, false, true, "Banned By Guh And Pegasus AC", "Tentativa de utilização de trigger, caso foi um erro, por favor contate em discord.gg/rpguetto!")
    end

    if element and isElement(element) then
        setElementFrozen(element, true)
        setPedAnimation(element, "ped", "HIT_walk")
        setElementData(element, "zablokowany-realdriveby", true)
        
        setTimer(function()
            if isElement(element) then
                setElementFrozen(element, false)
                setPedAnimation(element)
                toggleControl(element, "fire", true)
                setElementData(element, "zablokowany-realdriveby", false)
            end
        end, time * 1000, 1)
        
        toggleControl(element, "fire", false)

        if getElementType(element) == 'player' and isPedInVehicle(element) then
            toggleControl(element, "accelerate", false)
            toggleControl(element, "enter_exit", false)
            toggleControl(element, "brake_reverse", false)
            toggleControl(element, "vehicle_fire", false)
            toggleControl(element, "vehicle_secondary_fire", false)
            toggleControl(element, "vehicle_look_left", false)
            toggleControl(element, "vehicle_look_right", false)
            toggleControl(element, "vehicle_mouse_look", false)
            toggleControl(element, "fire", false)

            setTimer(function()
                if isElement(element) then
                    toggleControl(element, "accelerate", true)
                    toggleControl(element, "enter_exit", true)
                    toggleControl(element, "brake_reverse", true)
                    toggleControl(element, "vehicle_fire", true)
                    toggleControl(element, "vehicle_secondary_fire", true)
                    toggleControl(element, "vehicle_look_left", true)
                    toggleControl(element, "vehicle_look_right", true)
                    toggleControl(element, "vehicle_mouse_look", true)
                    toggleControl(element, "fire", true)
                end
            end, time * 1000, 1)
        end
    end
end

addEvent("onParalyze", true)
addEventHandler("onParalyze", resourceRoot, onParalyzed)

function onveh(element)
    if not client then
        return false
    end

    if not element or not isElement(element) then
        return false
    end

    local resourceRootElement = getResourceDynamicElementRoot(getResourceFromName("guetto_taser"))
    if not resourceRootElement or source ~= resourceRootElement then
        return outputDebugString(getPlayerName(client) .. "Tentativa de trigger de outro recurso detectada", 1)
    end

    local vehheal = getElementHealth(element)
    setElementHealth(element, vehheal)
end

addEvent("onVehicle", true)
addEventHandler("onVehicle", resourceRoot, onveh)
