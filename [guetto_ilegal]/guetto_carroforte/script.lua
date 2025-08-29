local Elements = {}
local bag = {}
local explosion_process = false 

local function startScript()
	if (Elements) then
		for name,elem in pairs(Elements) do
			if isElement(Elements[name]) then
				destroyElement(Elements[name])
			end
		end
		Elements = {}
	end

	explosion_process = false
	onAttack = false
	timerMove = false
	flatWheels = 0

	id = math.random(1,#path)
	
	local x,y,z = path[id][1].posX,path[id][1].posY,path[id][1].posZ
	local rx,ry,rz = path[id][1].rotX,path[id][1].rotY,path[id][1].rotZ
	
	Elements["Vehicle"] = createVehicle(428, x, y, z, rx, ry, rz)
	Elements["Bot1"] = createPed(282, x, y, z)

	setElementData(Elements["Vehicle"], "onVehicleStrongCar", false)

	warpPedIntoVehicle(Elements["Bot1"], Elements["Vehicle"], 0)
	setElementHealth (Elements["Bot1"], 30)
	
	Elements["Bot2"] = createPed(282, x, y, z)
	warpPedIntoVehicle(Elements["Bot2"], Elements["Vehicle"], 1)
	setElementHealth (Elements["Bot2"], 30)
	
	Elements["Object"] = createObject(2212, x, y, z, rx, ry, rz)
	setElementAlpha(Elements["Object"], 0)
	setElementCollisionsEnabled(Elements["Object"], false)
	attachElements(Elements["Vehicle"], Elements["Object"])
	
	Elements["Arrow"] = createMarker(x, y, z, "arrow", 1, 0, 200, 0)
	attachElements(Elements["Arrow"], Elements["Object"], 0, -1, 3)
	
	Elements["Cylinder"] = createMarker(x, y, z, "cylinder", 1.5, 0, 200, 0, 155)
	setElementAlpha(Elements["Cylinder"], 0)
	attachElements(Elements["Cylinder"], Elements["Object"], 0, -3.5, -0.7)
	
	Elements["Bomb"] = createObject(1654, x, y, z)
	setElementAlpha(Elements["Bomb"], 0)
	setElementCollisionsEnabled(Elements["Bomb"], false)
	attachElements(Elements["Bomb"], Elements["Object"], 0, -2, 0.4)
	
	Elements["Blip"] = createBlipAttachedTo(Elements["Object"], 51)

	startWalk()
	setTimer(startScript,(get("timerRestart")*60000),1)
end

addCommandHandler("carroforte",
	function(p)
		outputChatBox(" ---- #C19F72[GUETTO Carro Forte]#FFFFFF ----",p,255,255,255,true)
		if (isTimer(timerMove)) then
			outputChatBox("* Está em atividade? #00FF00Sim",p,255,255,255,true)
			outputChatBox("* Como localizá-lo? Icone dolar no radar (F11)",p,255,255,255,true)
			outputChatBox("* Como assaltá-lo? Fure os pneus e depois mate os guardas, e então exploda o cofre",p,255,255,255,true)
		else
			outputChatBox("* Está em atividade? #FF0000Não",p,255,255,255,true)
			if isElement(Elements["Blip"]) and getBlipIcon(Elements["Blip"]) == 36 then
				outputChatBox("* Já foi assaltado? Sim",p,255,255,255,true)
				outputChatBox("* Como localizá-lo? Icone S vermelho no radar (F11)",p,255,255,255,true)
			end
		end
	end
)

function startWalk()
	local i = 1
	outputChatBox("#C19F72[GUETTO Carro Forte]#FFFFFF A transportadora de valores inicou suas atividades (/carroforte)",root,255,255,255,true)
	timerMove = setTimer(function()
		i = i+1
		local pos = {path[id][i].posX, path[id][i].posY, path[id][i].posZ}
		local rot = {path[id][i].rotX, path[id][i].rotY, path[id][i].rotZ}
		setElementRotation(Elements["Object"], unpack(rot))
		moveObject(Elements["Object"], 1000, unpack(pos))
		
		-- Fix bug sync
		if (not isPedDead(Elements["Bot1"])) then
			if Elements["Bot1"] and isElement(Elements["Bot1"]) then 
				setElementPosition(Elements["Bot1"], unpack(pos))
			end
		else
			removePedFromVehicle(Elements["Bot1"])
		end
		if (not isPedDead(Elements["Bot2"])) then
			if Elements["Bot2"] and isElement(Elements["Bot2"]) then 
				setElementPosition(Elements["Bot2"], unpack(pos))
			end
		else
			removePedFromVehicle(Elements["Bot2"])
		end
		
		if (i == (#path[id]-1)) then
			finishWalk()
		end
	end,1000, #path[id]-1)
end

function finishWalk()
	if (isTimer(timerMove)) then killTimer(timerMove) end

	outputChatBox("#A4A4A4[Carro Forte]#FFFFFF A transportadora de valores chegou com #04B404sucesso#FFFFFF ao seu destino",root,255,255,255,true)

	for name,elem in pairs(Elements) do
		if isElement(Elements[name]) then
			destroyElement(Elements[name])
		end
	end

	Elements = {}
end

addEventHandler("onVehicleDamage", root,
	function(loss)
		if (not isElement(Elements["Vehicle"])) then 
			return false 
		end;
		if (source == Elements["Vehicle"]) then
			if (not onAttack) then
				outputChatBox("#A4A4A4[Carro Forte] #DBA901ATENÇÃO #FFFFFF- A transportadora de valores está sobre ataque",root,255,255,255,true)
				onAttack = true
			end
			local whells = {getVehicleWheelStates(source)}
			for i,v in pairs(whells) do
				if (v == 1) then
					whells[i] = 2
					flatWheels = flatWheels + 1
				else
					whells[i] = -1
				end
				if i == 4 then setVehicleWheelStates(source,unpack(whells)) end
			end
			if (flatWheels >= 4) then
				if (timerMove and isTimer (timerMove)) then 
					killTimer ( timerMove )
					timerMove = nil 
				end
				setElementData(Elements["Vehicle"], "onVehicleStrongCar", true)
				if Elements["Cylinder"] and isElement(Elements["Cylinder"]) then 
					setElementAlpha(Elements["Cylinder"], 155)
				end
			end
			setElementHealth(source, getElementHealth(source)+loss)
		end
	end
)

addEventHandler("onMarkerHit", resourceRoot, function ( player )
	if (player and isElement(player) and getElementType(player) == "player" and not isPedInVehicle(player)) then 
		if (Elements["Cylinder"] == source) then 
			if not (explosion_process) then 
				if (Elements["Vehicle"] and isElement(Elements["Vehicle"]) and getElementType(Elements["Vehicle"]) == "vehicle") then 
					if (getElementData(Elements["Vehicle"], "onVehicleStrongCar") == true) then 
						explosion_process = true 
	
						setElementAlpha(Elements["Cylinder"], 0)
						setPedAnimation(player, "grenade", "WEAPON_throw", 700, false, true, true, false)
	
						setElementAlpha(Elements["Bomb"], 255)
						setElementAttachedOffsets(Elements["Bomb"], 0, -3, 0.4)
	
						if Elements["Cylinder"] and isElement(Elements["Cylinder"]) then 
							destroyElement(Elements["Cylinder"])
							Elements["Cylinder"] = nil 
						end

						setTimer(function (player)
							if (player and isElement(player) and getElementType(player) == "player" and not isPedInVehicle(player)) then 
	
								outputChatBox("#A4A4A4[Carro Forte] #DBA901ATENÇÃO #FFFFFF- O jogador "..getPlayerName(player).."#FFFFFF explodiu o cofre do carro forte",root,255,255,255,true)
								
								if getPlayerWantedLevel(player) < 6 then
									setPlayerWantedLevel(player,getPlayerWantedLevel(player)+1)
								end
	
								local x,y,z = getElementPosition(Elements["Bomb"])
	
								createExplosion(x, y, z, 0)
								setElementAlpha(Elements["Bomb"], 0)
								setElementAttachedOffsets(Elements["Bomb"], 0, -2, 0.4)
	
								if Elements["Vehicle"] and isElement(Elements["Vehicle"]) then 
									setVehicleDoorOpenRatio(Elements["Vehicle"],4,1,0)
									setVehicleDoorOpenRatio(Elements["Vehicle"],5,1,0)
									setVehicleDoorState(Elements["Vehicle"],4,2)
									setVehicleDoorState(Elements["Vehicle"],5,2)
								end
	
								if Elements["Blip"] and isElement(Elements["Blip"]) then 
									setBlipIcon(Elements["Blip"], 36)
								end
				
								if Elements["Arrow"] and isElement(Elements["Arrow"]) then 
									setMarkerColor(Elements["Arrow"],200,0,0,255)
								end
																
								if Elements["Pickup"] and isElement(Elements["Pickup"]) then 
									destroyElement(Elements["Pickup"])
									Elements["Pickup"] = nil 
								end
	
								Elements["Pickup"] = createMarker(x, y, z-1, 'cylinder', 1.1, 135, 0, 255, 90)
								setElementData(Elements["Vehicle"], "onVehicleStrongCar", false)
								--triggerClientEvent(root, 'onCreateEffect', root)

								addEventHandler("onMarkerHit", Elements["Pickup"], function (player)
									if (player and isElement(player) and getElementType(player) == "player" and not isPedInVehicle(player)) then 
										local random = math.random( 10000, 50000 )
	
										if random then
											exports["guetto_inventory"]:giveItem(player, 100, random)
	
											notifyS(player, "Você pegou R$"..random, "info")
											
											if Elements["Pickup"] and isElement(Elements["Pickup"]) then 
												destroyElement(Elements["Pickup"])
												Elements["Pickup"] = nil 
											end
											
											if bag[player] and isElement(bag[player]) then 
												destroyElement(bag[player])
												bag[player] = nil 
											end
									
											local x,y,z = getElementPosition(player)
									
											--bag[player] = createObject(1833, x,y,z)
											--exports["bone_attach"]:attachElementToBone(bag[player], player, 3, 0, -0.005, -0.18, 0, 0, 90)
									
											if isElement(Elements["Bot1"]) then destroyElement(Elements["Bot1"]) end
											if isElement(Elements["Bot2"]) then destroyElement(Elements["Bot2"]) end
											
											setTimer(function(source)
												if isElement(Elements["Vehicle"]) then destroyElement(Elements["Vehicle"]) end
												if isElement(Elements["Arrow"]) then destroyElement(Elements["Arrow"]) end
											end, 0.2*60000, 1, source)

											setTimer(function(player)
												if isElement(bag[player]) and bag[player] then
													destroyElement(bag[player])
												end
											end, 1*60000, 1, player)
										end
									end
								end)
							end
						end, 8000, 1, player)
					end
				end
			end
		end
	end
end)

function notifyS ( player, message, type )
	return exports['guetto_notify']:showInfobox(player, type, message)
end

setTimer( startScript, 5000, 1 )

