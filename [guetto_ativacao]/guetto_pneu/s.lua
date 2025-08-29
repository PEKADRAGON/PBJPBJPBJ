local config = {
    object = 1327;

    locations = {
        { tire = {1937.409, 158.523, 37.245}; acl = 'HARAN'};
        { tire = {-1117.206, -1603.614, 76.374}; acl = 'UT'};
        { tire = {2698.435, -766.185, 101.587}; acl = 'TDF'};
        { tire = {2460.626, -1717.054, 13.536}; acl = 'BDP'};
    };

}

local spam = {}
local data = {}
local tires = {}

for i = 1, #config.locations do 
    local v = config.locations[i];
    local x, y, z = v.tire[1], v.tire[2], v.tire[3]

    tires[i] = createObject(config.object, x, y, (z - 1.5))
    setObjectScale(tires[i], 3.15, 0.7, 0.7)
    setElementRotation(tires[i], 0, 90, 0)
    data[tires[i]] = i
end

sendMessageServer = function (player, msg, type)
    return exports['guetto_notify']:showInfobox(player, type, msg)
end

function findRotation(x1, y1, x2, y2)
    local t = -math.deg( math.atan2( x2 - x1, y2 - y1 ) )
    return t < 0 and t + 360 or t
end

function getPlayerFromID (id)
    if not id then 
        return false 
    end
    local result = false;
    for i, v in ipairs ( getElementsByType ( 'player' ) ) do 
        if getElementData( v, 'ID') == tonumber(id) then 
            result = v 
        end
    end
    return result
end;

function isPlayerTire ( player )
    if not data[player] then 
        return false 
    end
    return true 
end

function getPlayerDistanceToTire (player)
    if not player then 
        return false 
    end
    
    local result = false;
    local positions = {};
    
    local x, y, z = getElementPosition(player);
    local account = getAccountName (getPlayerAccount(player));

    for i, v in pairs(tires) do 
        if v and isElement(v) then 
            local x2, y2, z2 = getElementPosition(v);
            local distance = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
            if distance <= 10 and isObjectInACLGroup("user."..account, aclGetGroup( config.locations[data[v]].acl )) then 
                result = v
                positions = {x2, y2, z2} 
            end
        end
    end
    return result, positions
end

local target_player = {}

addCommandHandler('colocar', 
    function ( player, cmd, id )

        if not (id) then 
            return sendMessageServer(player, 'Digite o id do jogador que você deseja colocar no pneu!', 'info')
        end;
        
        local element = getPlayerFromID(tonumber(id));
        
        if not (element) then 
            return sendMessageServer(player, 'Jogador não encontrado!', 'error')
        end;

        local x, y, z = getElementPosition(player)
        local x2, y2, z2 = getElementPosition(element);

        if getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) >= 5 then 
            return sendMessageServer(player, 'Você está muito distânte do jogador!', 'error')
        end;
 
        local tire, pos = getPlayerDistanceToTire (player);
    
        if not (tire) then 
            return sendMessageServer(player, 'Você está muito distânte de um pneu!', 'error')
        end;

        setElementPosition(element, pos[1], pos[2], pos[3] + 1)
        setElementFrozen(element, true)
        toggleAllControls(element, false)

        setElementData (element, 'isPlayerInTire', true)
        target_player[player] = element

        sendMessageServer(player, 'Você colocou o jogador no pneu!', 'info')
        sendMessageServer(element, 'Você foi colocado no pneu!', 'info')        
    end
)

addCommandHandler('fogo', 
    function ( player, cmd )

        local tire, pos = getPlayerDistanceToTire (player);
        
        if not (tire) then 
            return sendMessageServer(player, 'Você está muito distânte de um pneu!', 'error')
        end;

        if spam[player] and getTickCount ( ) - spam[player] <= 2 * 60000 then 
            return false 
        end

        local x, y, z = getElementPosition(target_player[player])
        local rot = findRotation(x, y, pos[1], pos[2])

        setElementRotation(player, 0, 0, rot)
       
        setPedAnimation(player, "GRENADE", "WEAPON_throwu", -1, false, false, false, false)
        sendMessageServer(player, 'Você colocou fogo no pneu!', 'info')

        setTimer(function(x, y, z, player)
            triggerClientEvent(root, 'onPlayerShowFire', root, x, y, z)

            setTimer(function (player)
                if player and isElement(player) then 
                    if target_player[player] and isElement(target_player[player]) then 
                        killPed(target_player[player])
                    end
                end
            end, 30000, 1, player)

        end, 520, 1, pos[1], pos[2], pos[3], player)
    end
)

addEventHandler('onPlayerWasted', root, 
    function ( )    
        if (getElementData(source, 'isPlayerInTire') or false) then 
            removeElementData(source, 'isPlayerInTire')
            setElementFrozen(source, false)
            toggleAllControls(source, true)
        end
    end
)