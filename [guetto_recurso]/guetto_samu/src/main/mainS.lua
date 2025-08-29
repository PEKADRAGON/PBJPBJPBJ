-- \\ Var´s //

local fallen = {}
local fallenTime = {}
local fallen_block = {}
local blips = {}
local weaponFallen = { }
local healing = {}
local stretchers = {}

-- \\ Function´s //

start = function ( )

    for index, player in ipairs ( getElementsByType('player') ) do 
        local Data = getElementData(player, "Player.Fallen") or false; 
        if Data then 
            fallen[getAccountName(getPlayerAccount(player))] = Data;
            setTimer ( function ( player )
                revivePlayer(player)
            end, 1000, 1, player)

        end
    end;

    for index, value in ipairs(config["Macas"]) do 
        stretchers[index] = createObject(1997, value[1], value[2], value[3], value[4], value[5], value[6])
        addEventHandler("onElementClicked", stretchers[index], function(button, state, player)
            if source == stretchers[index] and isElement(source) and getElementType(source) == "object" and (getElementModel(stretchers[index]) == 1997) then
                local pos = {getElementPosition(player)}
                local posobj = {getElementPosition(source)}
                if (getDistanceBetweenPoints3D(pos[1], pos[2], pos[3], posobj[1], posobj[2], posobj[3]) < 5) then
                    if not (getElementData(source, "JOAO.lyingStretcher") or false) then
                        triggerClientEvent(player, "Stretchers>Toggle", resourceRoot, true, stretchers[index])
                    end
                end
            end
        end)
    end
    
end;

getPlayerVip = function ( player )

    if not player then 
        return false;
    end

    local account = getAccountName(getPlayerAccount(player))

    for i, v in ipairs(config["Others"]["vips"]) do 
       
        if not aclGetGroup(v) then 
            return 
        end

        if not isObjectInACLGroup("user."..account, aclGetGroup(v)) then 
            return false 
        end

    end

    return true;
end;


revivePlayer = function ( player, target )

    if not (player or not isElement(player)) then 
        return false 
    end

    if player and isElement(player) and getElementType(player) == 'player' then 
        local account = getAccountName(getPlayerAccount(player))

        if not fallen[account] then 
            return false 
        end
    
        local Data = getElementData(player, "Player.Fallen") or false; 
    
        if not Data then 
            return false
        end
    
        local account = getAccountName(getPlayerAccount(player))
    
        setElementFrozen(player, false)
        toggleAllControls(player, true)
        
        killPed(player)
    
        if fallen_block[player] and isTimer (fallen_block[player]) then 
            killTimer (fallen_block[player])
        end;
    
        fallen[account] = nil
    
        removeElementData(player, "Player.Fallen")
    end


end;

login = function (  )

    local account = getAccountName(getPlayerAccount(source))

    if not fallen[account] then 
        return 
    end

    setPlayerFallen ( fallen[account].attaker, source, fallen[account].causing)
end;

quit = function ( )
    
    if not source then 
        return 
    end

    if blips[source] and isElement(blips[source]) then destroyElement(blips[source])
        blips[source] = nil 
    end

    if not fallenTime[source] or not isTimer(fallenTime[source]) then 
        return 
    end

    killTimer(fallenTime[source])
    fallenTime[source] = nil 
end

getPlayerSamu = function ( )
    local c = 0 
    for _, player in ipairs (getElementsByType('player')) do 
        if getElementData(player, "service.samu") then 
            c = c + 1
        end
    end
    return c
end

wasted = function ( )

    if blips[source] and isElement(blips[source]) then 
        destroyElement(blips[source])
        blips[source] = nil 
    end

    local account = getAccountName(getPlayerAccount(source))
    if fallen[account] then 
        fallen[account] = nil 
    end
    
    toggleAllControls(source, true)
    setElementFrozen(source, false)

    removeElementData(source, "Player.Fallen")
    triggerClientEvent(source, "client.inteface.toggle", resourceRoot, false, nil)
end;

local timer = {}
local mortes = {}

setPlayerFallen = function ( attaker, player, causing )
    local killer = attaker

    if not isElement(player) then
        return
    end

    if getElementData(player, 'onProt') then
        return
    end 

    if (getPedOccupiedVehicle(player) and getElementData(getPedOccupiedVehicle(player), "VehBlindagem")) then 
        return 
    end
    
    if not (mortes[killer]) then 
        mortes[killer] = 1
    end
   
    timer[killer] = setTimer(function(attaker)
        mortes[killer] = nil 
    end, 10000, 1, killer)

    if (mortes[killer] >= 10) then 
        if (timer[killer] and isTimer(timer[killer])) then 
            killTimer(timer[killer])
            timer[killer] = nil 
        end
        kickPlayer(killer, 'Você foi kikado por Pegasus AC')
    end


    local serviceSamus = getPlayerSamu()

    --[[
        if serviceSamus <= 0 then
        killPlayer(player, killer)
        return
    end
]]

    if getPedOccupiedVehicle(player) and getElementData(getPedOccupiedVehicle(player), 'JOAO.blindagemVehicle') then
        return 
    end

    local isPlayerVIp = getPlayerVip ( player )
    local account = getAccountName(getPlayerAccount(player))

    if causing == "Queda" then 
        executeCommandHandler("voiceptt", player, 0)

        removePedFromVehicle(player)
        setElementFrozen(player, true)

        setPedAnimation(player, "SWEET", "Sweet_injuredloop", -1, true, false, false)
        
        setControlState(player, "aim_weapon", false)  
        setControlState(player, "fire", false)

        if fallen_block[player] and isTimer (fallen_block[player]) then 
            killTimer (fallen_block[player])
        end;

        fallen_block[player] = setTimer ( function (player)
            if not (player and isElement(player)) then 
                return false;
            end

            if not fallen[account] then 
                return false 
            end

            if fallen[account] then 
                toggleAllControls(player, false)
                setPedAnimation(player, "SWEET", "Sweet_injuredloop", -1, true, false, false)
            end   
        end, 1000, 0, player)

        fallen[account] = {
            attaker = killer;
            target = "Queda";
            causing = causing;
            time = isPlayerVIp and (config["Others"]["resusit"] * 60000) * 0.80 or getElementData(player, "Guh.ReducaoDesmaio") and (config["Others"]["resusit"] * 60000) * 0.50 or (config["Others"]["resusit"] * 60000)
        };

        fallenTime[player] = setTimer ( function ( player )
            revivePlayer ( player, _ )
            if blips[player] and isElement(blips[player]) then destroyElement (blips[player]) end
        end, fallen[account].time, 1, player)

        if blips[player] and isElement(blips[player]) then 
            destroyElement (blips[player])
            blips[player] = nil 
        end

        blips[player] = createBlipAttachedTo(player, 21)
        setElementVisibleTo(blips[player], root, false)

        for i, v in ipairs(getElementsByType("player")) do 
            if (getElementData(v, config["Datas"]["SAMU"]) == true) then 
                setElementVisibleTo(blips[player], v, true)
                config.sendMessageServer(v, "Um jogador está precisando de ajuda!", "info")
               -- outputChatBox(player.."SAMU: Um jogador ferido precisad e ajuda. ", root, 255, 255, 255, true )
            end
        end;

        setElementData(player, 'Player.Fallen', fallen[account])
        triggerClientEvent(player, "client.inteface.toggle", resourceRoot, true, fallen[account])
    else

        executeCommandHandler("voiceptt", player, 0)

        if killer and isElement(killer) and getElementType(killer) == "player" then 
            weaponFallen[player] = getPedWeapon(killer)
        end

        setElementFrozen(player, true)
        setPedAnimation(player, "SWEET", "Sweet_injuredloop", -1, true, false, false)
        
        setControlState(player, "aim_weapon", false)  
        setControlState(player, "fire", false)

        if fallen_block[player] and isTimer (fallen_block[player]) then 
            killTimer (fallen_block[player])
        end;

        fallen_block[player] = setTimer ( function (player)

            if not (player and isElement(player)) then 
                return false;
            end

            if not fallen[account] then 
                return false 
            end

            if not fallen[account] then 
                return 
            end
            
            toggleAllControls(player, false)
            setPedAnimation(player, "SWEET", "Sweet_injuredloop", -1, true, false, false)
        end, 1000, 0, player)

        fallen[account] = {
            attaker = killer;
            target = getPlayerName(player);
            causing = weaponFallen[player] and weaponFallen[player] or causing;
            time = isPlayerVIp and (config["Others"]["resusit"] * 60000) * 0.50 or (config["Others"]["resusit"] * 60000)
        };

        fallenTime[player] = setTimer ( function ( player )
            revivePlayer ( player, killer )
            if blips[player] and isElement(blips[player]) then destroyElement (blips[player]) end
        end, fallen[account].time, 1, player)

        if blips[player] and isElement(blips[player]) then 
            destroyElement (blips[player])
            blips[player] = nil 
        end

        blips[player] = createBlipAttachedTo(player, 21)
        setElementVisibleTo(blips[player], root, false)

        for i, v in ipairs(getElementsByType("player")) do 
            if (getElementData(v, config["Datas"]["SAMU"]) == true) then 
                setElementVisibleTo(blips[player], v, true)
                config.sendMessageServer(v, "Um jogador está precisando de ajuda!", "info")
               -- outputChatBox(player.."SAMU: Um jogador ferido precisad e ajuda. ", root, 255, 255, 255, true )
            end
        end;

        setElementData(player, 'Player.Fallen', fallen[account])
        triggerClientEvent(player, "client.inteface.toggle", resourceRoot, true, fallen[account])   
    end
end;

function healingPlayer(player, receiver)


    if not isElement(receiver) then 
        return config.sendMessageServer(player, "Nenhum jogador especificado!", "info")
    end;

    local account = getAccountName(getPlayerAccount(receiver));

    if not fallen[account] then 
        return config.sendMessageServer(player, "Esse cidadão não precisa ser curado!", "error")
    end;

    if healing[player] then 
        return config.sendMessageServer(player, "Você já está curando um cidadão!", "error")
    end;

    healing[player] = true 
    
    setPedAnimation(player, "MEDIC", "CPR", -1)
    givePlayerMoney(player, 8000)

    local exp = (getElementData(player, "XP") or 0)
    setElementData(player, "XP", exp+8)

    config.sendMessageServer(player, "Você está curando o cidadão!", "info")

    setTimer(function(player) 
        config.sendMessageServer(player, "Cidadão curado com sucesso.", "info")
        healing[player] = false
        setPedAnimation(player, nil)

        if receiver and isElement(receiver) then 
            config.sendMessageServer(receiver, "Um médico curou você.", "info")
            setElementHealth(receiver, 25)
    
            if isElement(blips[receiver]) then destroyElement(blips[receiver]) end
            fallen[account] = nil
    
            toggleAllControls(receiver, true)
            setElementFrozen(receiver, false)
            setPedAnimation(receiver, nil)
            setElementCollisionsEnabled(receiver, true)
            setControlState(receiver , "aim_weapon", false)  
            setControlState(receiver , "fire", false)
            removeElementData(receiver, 'Player.Fallen')
        end


        setTimer(function(receiver)
            if receiver and isElement(receiver) then
                setControlState(receiver , "aim_weapon", false)  
                setControlState(receiver , "fire", false)
            end
        end, 1500, 1, receiver)

    triggerClientEvent(receiver, "client.inteface.toggle", resourceRoot, false, nil)
    end, 4000, 1, player, receiver)
end
addEvent("JOAO.curarPlayer", true)
addEventHandler("JOAO.curarPlayer", root, healingPlayer)

function healingPlayerFromTrigger(receiver)



    local account = getAccountName(getPlayerAccount(receiver));

    if not fallen[account] then 
        return print("Esse cidadão não precisa ser curado!", "error")
    end;

    if healing[receiver] then 
        return print("Você já está curando um cidadão!", "error")
    end;

    healing[receiver] = true 
    


    setTimer(function(receiver) 
        healing[receiver] = false
        setPedAnimation(receiver, nil)

        if receiver and isElement(receiver) then 
            setElementHealth(receiver, 25)
    
            if isElement(blips[receiver]) then destroyElement(blips[receiver]) end
            fallen[account] = nil
    
            toggleAllControls(receiver, true)
            setElementFrozen(receiver, false)
            setPedAnimation(receiver, nil)
            setElementCollisionsEnabled(receiver, true)
            setControlState(receiver , "aim_weapon", false)  
            setControlState(receiver , "fire", false)
            removeElementData(receiver, 'Player.Fallen')
        end


        setTimer(function(receiver)
            if receiver and isElement(receiver) then
                setControlState(receiver , "aim_weapon", false)  
                setControlState(receiver , "fire", false)
            end
        end, 1500, 1, receiver)

    triggerClientEvent(receiver, "client.inteface.toggle", resourceRoot, false, nil)
    end, 4000, 1, receiver, receiver)
end
addEvent("GUETTO.curarPlayerFromTrigger", true)
addEventHandler("GUETTO.curarPlayerFromTrigger", root, healingPlayerFromTrigger)

addCommandHandler('curartodosjogadores', function (player)
    if isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(player)), aclGetGroup('Console')) then 
        for i = 1, #getElementsByType('player') do 
            healingPlayer(player, getElementsByType('player')[i])
        end
    end
end)

manageStretcher = function ( stretcher, pos, rot, type )

    if not client then 
        return 
    end

    if source ~= resourceRoot then 
        return 
    end

    if type == "deitar" then 
        setElementData(stretcher, "Stretcher.Used", true)
        setTimer(function()
            setElementData(stretcher, "Stretcher.Used", false)
        end, 5*60000, 0)
        setElementPosition(client, pos[1]+0.2, pos[2]+0.5, pos[3]+2, true)
        setElementRotation(client, rot[1], rot[2], rot[3]+90)
        setPedAnimation(client, 'crack', 'crckdeth2')
        setElementData(client, "JOAO.lyingStretcher", stretcher)
        setElementData(stretcher, "Stretcher.Used", true)
        triggerClientEvent(client, "Stretchers>Toggle", resourceRoot, false, nil)
    elseif type == "sair" then 
        if (getElementData(client, "JOAO.lyingStretcher") or false) then
            setPedAnimation(client, nil)
            setElementFrozen(client, false)
            toggleAllControls(client, true)
            setElementData((getElementData(client, "JOAO.lyingStretcher") or false), "JOAO.usedStretcher", false)
            setElementData(client, "JOAO.lyingStretcher", false)
        end
    elseif type == "tratamento" then
        if getElementHealth(client) >= 99 then
            config.sendMessageServer(client, "Você não precisa se curar!", "error")
        else
            setElementData(stretcher, "Stretcher.Used", true)
            setTimer(function()
                setElementData(stretcher, "Stretcher.Used", false)
            end, 5*60000, 0)
            setElementPosition(client, pos[1]+0.2, pos[2]+0.5, pos[3]+2, true)
            setElementRotation(client, rot[1], rot[2], rot[3]+90)
            setElementFrozen(client, true)
            toggleAllControls(client, false)
            setElementData(client, "JOAO.lyingStretcher", stretcher)
            setPedAnimation(client, 'crack', 'crckdeth2')
            triggerClientEvent(client, "Stretchers>Toggle", resourceRoot, false, nil)
            removeElementData(client, 'Player.Fallen')
            setTimer(function(player)
                if player and isElement(player) and getElementType(player) == 'player' then
                    local aaa = (getElementData(player, "JOAO.lyingStretcher") or false)
                    if aaa then
                        setElementData(aaa, "Stretcher.Used", false)
                    end
                    setElementData(player, "JOAO.lyingStretcher", false)
                    setPedAnimation(player, nil)
                    setElementFrozen(player, false)
                    toggleAllControls(player, true)
                    setElementHealth(player, 100)
                end
            end, 60000, 1, client)
        end
    end;

end;


-- \\ Event´s //

addEventHandler("onResourceStart", resourceRoot, start)
registerEventHandler("fallen>player", resourceRoot, setPlayerFallen)
registerEventHandler("manage>stretcher", resourceRoot, manageStretcher)
addEventHandler("onPlayerLogin", root, login)
addEventHandler("onPlayerWasted", root, wasted)
addEventHandler("onPlayerQuit", root, quit)

addEventHandler ( "onPlayerDamage", root, function (attacker, weapon, bodypart, loss) 
    if attacker and isElement(attacker) and getElementType(attacker) == 'player' then 
        local life = getElementHealth(source);
        if not (getElementData(source, "Player.Fallen")) then 
            if math.floor (life - loss) <= 20  then
                local causing = config["Damages"][tonumber(weapon)] 
                setPlayerFallen ( attacker, source, causing)
            end
        end
    end
end) 