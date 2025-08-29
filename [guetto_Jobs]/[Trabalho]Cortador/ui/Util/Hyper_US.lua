---------- SERVER --------------------

getAclPlayer = 
function(player,acl)
    if aclGetGroup ( acl ) then
        if isObjectInACLGroup("user." ..getAccountName(getPlayerAccount(player)), aclGetGroup(acl)) then
            return true
        end
    else
        outputDebugString ( "O Sistema não identificou a acl "..acl..", por favor crie a acl informada!", 3,5,162,238 ) 
    end
    return false
end

--if(id) then
--local playerID = tonumber(id)
--if(playerID) then
--local targetPlayer, targetPlayerName = getPlayerID(playerID)
getPlayerID =
function(id)
    v = false
    for i, player in ipairs (getElementsByType("player")) do
        if getElementData(player, Hyper_Config.Gerais.SystemID) == id then
            v = player
            break
        end
    end
    return v
end



getNearestPlayer =
function(player,distance, type)
    local lastMinDis = distance-0.0001
    local nearestVeh = false
    local px,py,pz = getElementPosition(player)
    local pint = getElementInterior(player)
    local pdim = getElementDimension(player)
    
    for _,v in pairs(getElementsByType(type)) do
        local vint,vdim = getElementInterior(v),getElementDimension(v)
        if vint == pint and vdim == pdim then
            local vx,vy,vz = getElementPosition(v)
            local dis = getDistanceBetweenPoints3D(px,py,pz,vx,vy,vz)
            if v ~= player then
                if dis < distance then
                    if dis < lastMinDis then 
                        lastMinDis = dis
                        nearestVeh = v
                    end
                end
            end
        end
    end
    return nearestVeh
end