local _event = addEvent
local _eventH = addEventHandler
local MarkerCortador = {};
local MarkerInfos = {};
local PedCortador = {};
local IndexSelect = {};
local Veh = {};
local GraosCavar = {};
local markeratt = {};
local previousIndex = {};
local Blip = createBlip(-112.383, 53.109, 3.117, 42)
register =
function(event, ...)
    _event(event, true)
    _eventH(event, ...)
end

--getResourceName(getThisResource())..   |   if element and isElement(element) and getElementType(element) == "player" then || end

for i, v in ipairs(Hyper_Config['Inicio']) do
    MarkerCortador[i] = createMarker(v.Pos[1], v.Pos[2], v.Pos[3] -1, 'cylinder', v.Marker.Size, unpack(v.Marker.Color))
    PedCortador[i] = createPed(v.IDPed, v.Pos[1], v.Pos[2], v.Pos[3], v.Pos[4])
    setElementFrozen(PedCortador[i], true)
    MarkerInfos[MarkerCortador[i]] = i
end

addEventHandler('onMarkerHit', resourceRoot, function(player, sameDimension)
    local indexMarker = MarkerInfos[source]
    if getElementType( player ) == 'player' and not isGuestAccount( getPlayerAccount( player ) ) and not isPedInVehicle( player ) and sameDimension then
        if MarkerCortador[indexMarker] then
            triggerClientEvent(player, getResourceName(getThisResource())..'OpenBind', player, indexMarker)
            IndexSelect[player] = indexMarker
        end
    end
end)

addEventHandler('onMarkerLeave', resourceRoot, function(player, sameDimension)
    local indexMarker = MarkerInfos[source]
    if getElementType( player ) == 'player' and not isGuestAccount( getPlayerAccount( player ) ) and not isPedInVehicle( player ) and sameDimension then
        if MarkerCortador[indexMarker] then
            triggerClientEvent(player, getResourceName(getThisResource())..'CloseBind', player)
            IndexSelect[player] = nil
        end
    end
end)

addEventHandler('onElementClicked', resourceRoot, function(b,s, player)
    if getElementType( player ) == 'player' and not isGuestAccount( getPlayerAccount( player ) ) and not isPedInVehicle( player ) then
        if getElementData(player, "Emprego") ~= "Cortador de grama" then 
            return outputMessage(player, "Você não trabalha aqui!", "error")
        end
        local Index = IndexSelect[player]
        if Index then
            if PedCortador[Index] then
                if isElement(Veh[player]) then destroyElement(Veh[player]) end
                local v = Hyper_Config['Inicio'][Index]
                Veh[player] = createVehicle(Hyper_Config.carModel, unpack(v['Carro']))
                warpPedIntoVehicle(player, Veh[player])
                triggerClientEvent(player, getResourceName(getThisResource())..'CloseBind', player)
                local EntregasAleatorias = math.random(#Hyper_Config['Rota'])
                previousIndex[player] = EntregasAleatorias
                GraosCavar[player] = createMarker(Hyper_Config['Rota'][EntregasAleatorias]['Pos'][1], Hyper_Config['Rota'][EntregasAleatorias]['Pos'][2], Hyper_Config['Rota'][EntregasAleatorias]['Pos'][3] -1, 'cylinder', 2, Hyper_Config.Gerais.CorServer[1], Hyper_Config.Gerais.CorServer[2], Hyper_Config.Gerais.CorServer[3], 100, player)
                markeratt[player] = GraosCavar[player]
                addEventHandler("onMarkerHit", GraosCavar[player], Entregando)
                outputMessage(player, "Carro retirado com sucesso", "success")
            end
        end
    end
end)

Entregando = function(player)
    if markeratt[player] and markeratt[player] == source then  
        if getPedOccupiedVehicle(player) and getElementModel(getPedOccupiedVehicle(player)) ~= Hyper_Config.carModel then 
            outputMessage(player, "Você não esta com o veiculo adequado.", "error")
            return false
        end
        if isElement( GraosCavar[player] ) then destroyElement( GraosCavar[player] ) end
        markeratt[player] = false  
        toggleAllControls(player,false)
        setElementFrozen(Veh[player], true)
        outputMessage(player, "Cortando, aguarde...", "info")
        setTimer(function(player)
            if getPedOccupiedVehicle(player) and getElementModel(getPedOccupiedVehicle(player)) ~= Hyper_Config.carModel or not getPedOccupiedVehicle(player) then 
                toggleAllControls(player,true)
                outputMessage(player, "Você não esta com o veiculo adequado e o trabalho foi encerrado.", "error")
                return false
            end
            local EntregasAleatorias = math.random(#Hyper_Config['Rota'])
            while previousIndex[player] == EntregasAleatorias do 
                EntregasAleatorias = math.random(#Hyper_Config['Rota'])
            end
            previousIndex[player] = EntregasAleatorias
            local money = math.random(Hyper_Config.money[1], Hyper_Config.money[2])
            local xp = math.random(Hyper_Config.xp[1], Hyper_Config.xp[2])
            local player_xp = getElementData(player, "XP") or 0;
            GraosCavar[player] = createMarker(Hyper_Config['Rota'][EntregasAleatorias]['Pos'][1], Hyper_Config['Rota'][EntregasAleatorias]['Pos'][2], Hyper_Config['Rota'][EntregasAleatorias]['Pos'][3] -1, 'cylinder', 2, Hyper_Config.Gerais.CorServer[1], Hyper_Config.Gerais.CorServer[2], Hyper_Config.Gerais.CorServer[3], 100)
            markeratt[player] = GraosCavar[player] 
            setElementVisibleTo ( GraosCavar[player], root, false)
            setElementVisibleTo ( GraosCavar[player], player, true)
            
            local isVip = exports["guetto_util"]:isPlayerVip(player)

            if isVip then 
                setElementData(player, "XP", player_xp + (xp * 2))
                outputMessage(player, "Você recebeu o drobo de xp por ser vip e ganhou R$"..money, "success")
            else
                setElementData(player, "XP", player_xp + xp)
                outputMessage(player, "Você ganhou R$"..money, "success")
            end

            addEventHandler("onMarkerHit", GraosCavar[player], Entregando)
            toggleAllControls(player,true)
            setElementFrozen(Veh[player], false)
            givePlayerMoney(player, money)
        end, Hyper_Config.cutTime*1000, 1, player)
    end
end

-- Pedro

function finishJob (player)
    if player and isElement(player) then 
        if GraosCavar[player] and isElement(GraosCavar[player]) then 
            destroyElement(GraosCavar[player])
            GraosCavar[player] = nil
        end
        if markeratt[player] and isElement(markeratt[player]) then 
           destroyElement(markeratt[player])
           markeratt[player] = nil
        end
        if Veh[player] and isElement(Veh[player]) then 
            destroyElement(Veh[source])
            Veh[player] = nil
        end
        if previousIndex[player] then 
            previousIndex[player] = nil
        end
    end
end

addEventHandler("onPlayerQuit", root, function()
    if Veh[source] then 
        finishJob(source)
    end
end)

addEventHandler("onPlayerVehicleExit", root, function(veh)
    if getElementModel(veh) == Hyper_Config.carModel or Veh[source] and isElement(Veh[source]) then 
        finishJob(source)
        outputMessage(source, "Você saiu do veiculo e seu expediente foi encerrado.", "info")
    end
end)



--[[
    getAclPlayer(parametro, ACL) -- puxar ACL


    if(id) then
    local playerID = tonumber(id)
    if(playerID) then
    local targetPlayer, targetPlayerName = getPlayerID(playerID)


    local target = getNearestPlayer(source, 1.0, "player")
    if target then

    exports.ProgressBarra:BarsHs(element, 60,"ORDENHANDO",238,205,5, true)

    getResourceName(getThisResource())..
    
    if element and isElement(element) and getElementType(element) == "player" then      || end
]]--