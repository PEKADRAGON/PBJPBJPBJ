--| Async

Async:setPriority("low")

--| AFK Identifier

local idleTimer = {}
local idlePlayers = {}

addEventHandler("onResourceStart", resourceRoot, function()

    --| Create a AFK players identifier
    idleTimer = setTimer(function()
        
        local elements = getElementsByType("player")
        Async:foreach(elements, function(player)

            if not isGuestAccount(getPlayerAccount(player)) then 

                if not idlePlayers[player] then 

                    if (getPlayerIdleTime(player) / 1000) >= config["idle"]["idleMin"] then
                        idlePlayers[player] = getTickCount()
                        triggerClientEvent(root, "setPlayerIdle", resourceRoot, player, true)
                    end

                else

                    if (idlePlayers[player] ~= "stateForced") then  
                        if (getPlayerIdleTime(player) / 1000) <= 10 then
                            idlePlayers[player] = nil
                            triggerClientEvent(root, "setPlayerIdle", resourceRoot, player, false)
                        end
                    end

                end

                if config["idle"]["kickPlayer"] then 
                    if (getPlayerIdleTime(player) / 1000) >= config["idle"]["toleranceTime"] then
                        kickPlayer(player, "[ Anti AFK ]", config["idle"]["kickMessage"])
                    end
                end
                
            end

        end)

    end, (config["idle"]["verifyTimer"] * 1000), 0)

end)

function forceIdle(player, state)

    if isGuestAccount(getPlayerAccount(player)) then 
        return 
    end

    if state then 
        if not idlePlayers[player] then
            idlePlayers[player] = "stateForced"
            triggerClientEvent(root, "setPlayerIdle", resourceRoot, player, true)
        end
    else
        if idlePlayers[player] and (idlePlayers[player] == "stateForced") then 
            idlePlayers[player] = nil
            triggerClientEvent(root, "setPlayerIdle", resourceRoot, player, false)
        end
    end

end
addEvent("FS:forceIdle", true)
addEventHandler("FS:forceIdle", root, forceIdle)