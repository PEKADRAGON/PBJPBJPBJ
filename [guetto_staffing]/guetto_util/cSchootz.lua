local screen = {guiGetScreenSize()} local x, y = (screen[1]/1366), (screen[2]/768)

sendMessageClient = function(message, type)
    return exports['guetto_notify']:showInfobox(type, message)
end;

function copyDiscord()
    setClipboard('discord.gg/rpguetto')
    sendMessageClient('Você copiou o discord com sucesso.', 'success')
end
addCommandHandler('discord', copyDiscord)

function copyDiscord2()
    setClipboard('discord.gg/rpguetto')
    sendMessageClient('Você copiou o discord com sucesso.', 'success')
end
addCommandHandler('dc', copyDiscord2)

addEventHandler("onClientPedDamage", root,
function()
    if isElement(source) and getElementType(source) == "ped" then
        if (getElementData(source, "JOAO.imortalPed") or false) then
            cancelEvent()
        end
    end
end)

local quitReasons = {
    unknown = "Desconhecida",
    quit = "Desconectado",
    kicked = "Kickado",
    banned = "Banido",
    ["bad connection"] = "Mal Conexão",
    ["timed out"] = "Tempo Esgotado"
}

addEventHandler("onClientPlayerQuit", getRootElement(),
    function (reason)
        if getElementData(source, "MeloSCR:Logado") then
            local playerPosX, playerPosY, playerPosZ = getElementPosition(localPlayer)
            local sourcePosX, sourcePosY, sourcePosZ = getElementPosition(source)
            local distance =  getDistanceBetweenPoints3D(playerPosX, playerPosY, playerPosZ, sourcePosX, sourcePosY, sourcePosZ)

            if distance <= 10 then
                local playerName = getPlayerName(source)
                local idPlayer = (getElementData(source, 'ID') or 0)
                local quitReason = quitReasons[string.lower(reason)]
                sendMessageClient('O jogador(a) '..playerName..' ('..idPlayer..') saiu da cidade próximo a você! ('..quitReason..')', 'info')
            end
        end
    end
)

--for i,v in ipairs(getElementsByType("player")) do
--    triggerServerEvent("Goiaba.setAnimationPhone", getResourceRootElement(getResourceFromName('bcr_phone')), v, 1 )
--end

--[[
function playMusic(link)
    if isElement(sound) then
        destroyElement(sound)
    end
    sound = playSound(link)
end
addEvent('playMusic', true)
addEventHandler('playMusic', root, playMusic)
]]

addCommandHandler('camera', function()
    local x, y, z, lx, ly, lz, l2, l3 = getCameraMatrix()
    local x, lx = x + 1, lx + 1
    setClipboard(x..', '..y..', '..z..', '..lx..', '..ly..', '..lz..', '..l2..', '..l3)
end)
-- Funções uteis -- 

function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
    if type(sEventName) == 'string' and isElement(pElementAttachedTo) and type(func) == 'function' then
        local aAttachedFunctions = getEventHandlers(sEventName, pElementAttachedTo)
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


local functions = {};
local cache = {};
local explosions = {
    [12] = true,
    [11] = true,
    [10] = true,
    [9] = true,
    [8] = true,
    [6] = true,
    [3] = true,
    [2] = true,
    [1] = true,
    [0] = true
}

functions.explosionEvent = function(x, y, z, theType)
    cancelEvent()
    return;
end

functions.functionHook = function(resource, module, ...)
    if (module ~= "blowVehicle" and module ~= "createExplosion" and module ~= "createProjectile") then
        return;
    end

    local args = {...};
    triggerServerEvent("Anti Cheat >> Explosion", resourceRoot, localPlayer, args[7]);
    return "skip";
end


addDebugHook("preFunction", functions.functionHook, {"blowVehicle", "createExplosion", "createProjectile"});
addEventHandler("onClientExplosion", root, functions.explosionEvent);

setTimer(function ( )
    local x, y, z = getElementPosition ( localPlayer )
    extinguishFire ( x, y, z, 20 )
end, 1000, 0)

addEventHandler('onClientPlayerDamage', root, function (atacker, damage, causing)
    if damage == 16 or damage == 37 or damage == 51 or damage == 63 then 
        cancelEvent()
    end
end)

local coolDown = {}

addEventHandler("onClientPlayerWeaponFire", root, function (weapon, _, _, _, _, element)
    if not coolDown[source] then 
        coolDown[source] = {
            dispair = 1,
            tick = getTickCount ( )
        }
    end;

    if (coolDown[source].dispair >= 30  and (getTickCount ( ) - coolDown[source].tick <= 1000)) then 
        cancelEvent()
        coolDown[source] = nil
    end

    coolDown[source].dispair = coolDown[source].dispair + 1
end)    
