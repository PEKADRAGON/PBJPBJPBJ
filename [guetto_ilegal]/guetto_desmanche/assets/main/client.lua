local client = {state = false, markersDismantle = {}, dismantleOccupied = {}, vehicleBreaking = {}, dismantledParts = {}, inDismantledPart = false, vehicleDismantle = false};

addEventHandler('onClientRender', getRootElement(), function()
    for i, v in ipairs(client['markersDismantle']) do 
        if v and isElement(v) then 
            if getDistanceBetweenPoints3D(Vector3(getElementPosition(localPlayer)), Vector3(getElementPosition(v))) <= 20 then
                if client['dismantleOccupied'][v] and isTimer(client['dismantleOccupied'][v]) then 
                    local minutes = math.floor((math.floor(getTimerDetails(client['dismantleOccupied'][v]))/1000)/60)
                    local seconds = math.floor((math.floor(getTimerDetails(client['dismantleOccupied'][v]))/1000)-(minutes*60))
                    dxDrawTextOnElement(v, 'Zona Indisponível\nAguarde '..minutes..' minutos e '..seconds..' segundos', 1, 20, 193, 159, 114, 255, 1.5)
                else
                    dxDrawTextOnElement(v, 'Zona Disponível', 1, 20, 193, 159, 114, 255, 1.5)
                end
            end
        end
    end

	if isPedInVehicle(localPlayer) then return end

	if client.vehicleDismantle and isElement(client.vehicleDismantle) then 
		if not client['dismantledParts'][client.vehicleDismantle] then
			client['dismantledParts'][client.vehicleDismantle] = {}
		end

		if not isVehicleBlown(client.vehicleDismantle) then
			local pos = {getElementPosition(localPlayer)}
			local components = getVehicleComponents(client.vehicleDismantle)

			for k in pairs(components) do 
				if getNameFromPart(k) and not client['dismantledParts'][client.vehicleDismantle][k] then
					local posPart = {getPartPosition(client.vehicleDismantle, k)}

					if getNameFromPart(k) == 'Capô' then
						posPart[1] = posPart[1] + 0.05
						posPart[2] = posPart[2] - 1
						posPart[3] = posPart[3] - 0.1
					elseif getNameFromPart(k) == 'Malas' then 
						posPart[1] = posPart[1] + 0.04
						posPart[3] = posPart[3] - 0.1
					elseif getNameFromPart(k) == 'Porta dianteira esquerda' or getNameFromPart(k) == 'Porta dianteira direita' then 
						posPart[2] = posPart[2] + 0.6
					elseif getNameFromPart(k) == 'Porta traseira esquerda' or getNameFromPart(k) == 'Porta traseira direita' then
						posPart[2] = posPart[2] + 0.4
					end

					if posPart[1] then 
						if getDistanceBetweenPoints3D(pos[1], pos[2], pos[3], posPart[1], posPart[2], posPart[3]) < 2 then 
							local scX, scY = getScreenFromWorldPosition(posPart[1], posPart[2], posPart[3], 0, false)

							if scX then
								dxDrawImage(scX, scY, 20, 20, 'assets/gfx/tool.png', 0, 0, 0, (isCursorOnElement(scX, scY, 20, 20) and tocolor(193, 159, 114, 255) or tocolor(255, 255, 255, 190)))
							end
						end
					end
				end
			end
		end
	end
end)

addEventHandler('onClientPreRender', root, function()
	if client.vehicleMove then 
		if not isElement(client.vehicleMove) then 
			client.vehicleMove = false 
			return
		end

		local pos = {getElementPosition(client.vehicleMove)}
		local movePos = interpolateBetween(client.posZ, 0, 0, (client.posZ + 0.7), 0, 0, (getTickCount() - client.tickMoveUp) / 5000, 'Linear')
		setElementPosition(client.vehicleMove, pos[1], pos[2], movePos)

		if movePos >= (client.posZ + 5) then
			client.vehicleMove = false
		end
	end
end)

addEventHandler('onClientVehicleStartEnter', getRootElement(), function()
	if client['vehicleBreaking'][source] then 
		cancelEvent()
	end
end)

addEvent('squady.insertDismantle', true)
addEventHandler('squady.insertDismantle', getRootElement(), function(element)
	table.insert(client['markersDismantle'], element)
end)

addEvent('squady.insertVehicleDismantle', true)
addEventHandler('squady.insertVehicleDismantle', getRootElement(), function(element)
	client['vehicleBreaking'][element] = true
end)

addEvent('squady.insertVehicleDismantleParts', true)
addEventHandler('squady.insertVehicleDismantleParts', getRootElement(), function(vehicle, part)
	if not client['dismantledParts'][vehicle] then 
		client['dismantledParts'][vehicle] = {}
	end
	client['dismantledParts'][vehicle][part] = true
end)

addEvent('squady.insertCooldown', true)
addEventHandler('squady.insertCooldown', getRootElement(), function(element, timer)
	client['dismantleOccupied'][element] = setTimer(function() end, timer, 1)
end)

addEvent('squady.removeCooldown', true)
addEventHandler('squady.removeCooldown', getRootElement(), function(element)
	if client['dismantleOccupied'][element] and isTimer(client['dismantleOccupied'][element]) then 
		killTimer(client['dismantleOccupied'][element])
		client['dismantleOccupied'][element] = nil 
	end

	client['dismantledParts'][element] = {}
	client.vehicleDismantle = nil;
	client.state = false;
end)

addEvent('squady.startDismantle', true)
addEventHandler('squady.startDismantle', getRootElement(), function(vehicle)
	if not client.state then 
		client.tick = getTickCount()
		client.vehicleDismantle = vehicle
		client.overPart = nil
		client.state = true
	else
		client['vehicleDismantle'] = nil
		client['overPart'] = nil
		client['state'] = false
		client.state = false;
	end
end)

addEvent('squady.moveUpVehicle', true)
addEventHandler('squady.moveUpVehicle', resourceRoot, function(vehicle, pos)
	client.vehicleMove = vehicle
	client.posZ = pos
	client.tickMoveUp = getTickCount()
end)

addEventHandler('onClientClick', root, function(button, state)
	if client.state and button == 'left' and state == 'down' then 
		if client.vehicleDismantle and isElement(client.vehicleDismantle) then 
			if not client['dismantledParts'][client.vehicleDismantle] then
				client['dismantledParts'][client.vehicleDismantle] = {}
			end
	
			if not isVehicleBlown(client.vehicleDismantle) then
				local pos = {getElementPosition(localPlayer)}
				local components = getVehicleComponents(client.vehicleDismantle)
	
				for k in pairs(components) do 
					if getNameFromPart(k) and not client['dismantledParts'][client.vehicleDismantle][k] then
						local posPart = {getPartPosition(client.vehicleDismantle, k)}
	
						if getNameFromPart(k) == 'Capô' then
							posPart[1] = posPart[1] + 0.05
							posPart[2] = posPart[2] - 1
							posPart[3] = posPart[3] - 0.1
						elseif getNameFromPart(k) == 'Malas' then 
							posPart[1] = posPart[1] + 0.04
							posPart[3] = posPart[3] - 0.1
						elseif getNameFromPart(k) == 'Porta dianteira esquerda' or getNameFromPart(k) == 'Porta dianteira direita' then 
							posPart[2] = posPart[2] + 0.6
						elseif getNameFromPart(k) == 'Porta traseira esquerda' or getNameFromPart(k) == 'Porta traseira direita' then
							posPart[2] = posPart[2] + 0.4
						end
	
						if posPart[1] then 
							if getDistanceBetweenPoints3D(pos[1], pos[2], pos[3], posPart[1], posPart[2], posPart[3]) < 2 then 
								local scX, scY = getScreenFromWorldPosition(posPart[1], posPart[2], posPart[3], 0, false)
	
								if scX then
									if isCursorOnElement(scX, scY, 20, 20) and not client.inDismantledPart then 
										client['overPart'] = k
										local namePart, _, tableType = getNameFromPart(client['overPart'])
										client.inDismantledPart = true
										triggerServerEvent('squady.dismantlePartVehicle', resourceRoot, client.vehicleDismantle, tableType, client['overPart'], namePart)
									end
								end
							end
						end
					end
				end
			end
		end
	end
end)

addEvent('squady.removePartFromVehicle', true)
addEventHandler('squady.removePartFromVehicle', getRootElement(), function(vehicle, component)
	if not client['dismantledParts'][vehicle] then 
		client['dismantledParts'][vehicle] = {}
	end
	client['dismantledParts'][vehicle][component] = true
	client.inDismantledPart = false

	local realName = getComponentRealName(component)
	if realName then 
		setVehicleComponentVisible(vehicle, realName, false)
	end
end)

addEvent('squady.getAllComponents', true)
addEventHandler('squady.getAllComponents', getRootElement(), function(vehicle)
	if vehicle and isElement(vehicle) then 
		local components = getVehicleComponents(vehicle)
		count = 0

		if not client['dismantledParts'][vehicle] then
			client['dismantledParts'][vehicle] = {}
		end

		for k in pairs(components) do 
			if getNameFromPart(k) and not client['dismantledParts'][vehicle][k] then
				count = count + 1
			end
		end

		if count == 0 then 
			triggerServerEvent('squady.finishDismantle', resourceRoot, vehicle)
		end
	end
end)