--[[
    --» sᴄʀɪᴘᴛ ғᴇɪᴛᴏ ᴘᴏʀ » Pedro Developer
--]]

outputDebugString('[PEDRO DEVELOPER] RESOURCE '..getResourceName(getThisResource())..' ATIVADA COM SUCESSO', 4, 204, 82, 82)

local planes = {}
local package = {}
function drop()

	local random_table = config.positions[math.random(#config.positions)]
	local x, y, z = random_table[1], random_table[2], random_table[3]

	spawnAirplane(x, y, z)

end
setTimer(drop, config.dropFallTime, 0)

addCommandHandler(config.command, 

    function(player)

        if (getPlayerPermission(player)) then

            drop()
            config.notify(player, 'Você forçou um drop a cair!', 'success')

        end

    end

)

function spawnAirplane(x, y, z)

	triggerClientEvent(root, 'createPop', root, x, y, z)
	local X1, Y1, X2, Y2, zRot = getFlyPath(x, y, math.random(0,360), config.flyRadius)
	local index = #planes+1
	planes[index] = {}
	local plane = planes[index]
	plane.index = index
	plane.obj =  createObject(config.planeModel, X1, Y1, z+config.flyAltitude, 0, 0, zRot)
	setObjectScale(plane.obj, config.planeScale)
	setElementCollisionsEnabled(plane.obj, false)

	plane.lod = createObject(config.planeModel, X1, Y1, z+config.flyAltitude, 0, 0, 0, true)
	plane.blip = createBlipAttachedTo(plane.obj, 5)
	setObjectScale(plane.lod, config.planeScale)
	setLowLODElement(plane.obj, plane.lod)
	attachElements(plane.lod, plane.obj)
	moveObject(plane.obj, config.flyTime, X2, Y2, z+config.flyAltitude)
    iprint({x, y, z})

    plane.dropTimer = setTimer(function(position) 
        --triggerClientEvent(thePlayer, 'showInfobox', thePlayer, 'info',"Uma caixa de drop está sendo encaminhada agora por algum avião!")
		config.notify(root, 'Uma caixa de drop está sendo encaminhada agora por algum avião!', 'info')
        dropPackage(index, plane, position)

	end, config.flyTime/2, 1, {x, y, z})

	triggerClientEvent('setPlaneProperties', resourceRoot, plane.obj, config.flyTime, zRot)
	setTimer(function()

		for _,v in pairs(plane) do

			if isElement(v) then

				destroyElement(v)

			end

		end

		planes[index] = nil

	end, config.flyTime, 1)

end

local clickedTimes, delayColect = {}, {}
addEvent('onPackageLeavePlane', true)
addEventHandler('onPackageLeavePlane', root, 

    function(index, x, y, z, zPos)
        if planes[index].zPos then
        	return
        else
        	planes[index].zPos = zPos
        end

        local index = #package+1
        package[index] = {}
        local Package = package[index]
        local random_position = {x, y, z}
        iprint(random_position)
        Package.obj = createObject(2919, random_position[1], random_position[2], random_position[3] + config.flyAltitude)
        Package.parachute = createObject(2903, random_position[1], random_position[2], random_position[3] + config.flyAltitude)
        attachElements(Package.parachute, Package.obj, 0, 0, 6.6)

        setElementCollisionsEnabled(Package.parachute, false)
        local x, y = getElementPosition(Package.obj)
        local z = zPos
        Package.landPos = {x, y, z}
        Package.blip = createBlipAttachedTo(Package.obj, config.dropBlip)
        Package.radarArea = createRadarArea(random_position[1] - (config.radarAreaSize / 2), random_position[2] - (config.radarAreaSize / 2), config.radarAreaSize, config.radarAreaSize, 255, 0, 0, 200)
        moveObject(Package.obj, config.dropTime, random_position[1], random_position[2], random_position[3]+0.6)

        setTimer(function(object, blip, radarArea)

            if (isElement(object)) then 

                clickedTimes[object] = 0
                setElementFrozen(object, true)
                iprint(getElementPosition(object))
                --triggerClientEvent(thePlayer, 'showInfobox', thePlayer, 'info',"O airdrop acabou de aterrissar!")
                config.notify(root, 'O airdrop no chão, tenha 60% do inventario livre.', 'info')

                addEventHandler('onElementClicked', object, 

                    function(b, s, player)

                        local pos, posObject = {getElementPosition(player)}, {getElementPosition(source)}
                        if not (isPedInVehicle(player)) then 

                            if (getDistanceBetweenPoints3D(pos[1], pos[2], pos[3], posObject[1], posObject[2], posObject[3]) <= 3) then 

                                if (isTimer(delayColect[player])) then 

                                    return 

                                end 
                               -- triggerClientEvent(thePlayer, 'showInfobox', thePlayer, 'info',"Você coletou o airdrop e pegou alguns itens!")
                                config.notify(player, 'Você coletou o airdrop e pegou alguns itens!', 'info')
                                giveRandomItens(player)
                                
                                clickedTimes[source] = clickedTimes[source] + 1
                                if (clickedTimes[source] >= config.clickTimes) then
                                    
                                    destroyElement(source)   

                                    if (isElement(blip)) then 

                                        destroyElement(blip)

                                    end

                                    if (isElement(radarArea)) then 

                                        destroyElement(radarArea)

                                    end

                                end

                            end

                        end

                    end 

                )

            end

        end, config.dropTime, 1, Package.obj, Package.blip, Package.radarArea)

        setTimer(function(position)

            triggerClientEvent(root, 'onClientPlayAirdropSound', root, position)
        
        end, config.dropTime - 4000, 1, {random_position[1], random_position[2], random_position[3]})

        Package.parachuteTimer = setTimer(function()
        	if Package.parachute then

        		destroyElement(Package.parachute)

        	end

        end, config.dropTime+500, 1)

    end

)

function giveRandomItens(player)

    toggleAllControls(player, false)
    setElementFrozen(player, true)
    setPedAnimation(player, 'BOMBER', 'BOM_Plant_Loop')

    delayColect[player] = setTimer(function(player)

        if (isElement(player)) then

            setPedAnimation(player)
            setElementFrozen(player, false)
            toggleAllControls(player, true)

        end

    end, 2600 * 1, 1, player)

    local amount_itens = math.random(1, config.maxItens) 
    for i = 1, amount_itens do 

        local random_item = config.itens[math.random(#config.itens)]
        config.giveItem(player, random_item[1], random_item[2])

    end
    
end

function dropPackage(index, plane, position)

	triggerClientEvent('setPackageProperties', resourceRoot, index, plane.obj, position)

end

function getFlyPath(x, y, angle, radius)

	local X = radius * math.cos(angle)
	local Y = radius * math.sin(angle)
	local X1, Y1 = x+X, y+Y
	local X2, Y2 = x-X, y-Y
	local zRot = findRotation(X1, Y1, X2, Y2)
	
	return X1, Y1, X2, Y2, zRot

end

function findRotation( x1, y1, x2, y2 ) 

	local t = -math.deg( math.atan2( x2 - x1, y2 - y1 ) )
	return t < 0 and t + 360 or t

end

function getPlayerPermission(player)

    for i, v in ipairs(config.acls) do 

        if (isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(player)), aclGetGroup(v))) then 

            return true 

        end

    end

end