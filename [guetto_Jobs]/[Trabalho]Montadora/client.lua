local buildingCar = false
local buildingPart = false
local partObject = false
local carryMarker = false
local buildMarker = false
local currentCarry = false
local coolDown = {}
local vehiclePosition = {339.20593261719, 43.7, 990.15374755859, 90}
local avaibleVehicles = {
	{491, 0.1, -0.25},
}
local needParts = {
	["boot_dummy"] = {
		["conveyor"] = {-1, 0, -0.85, 0, 0, 90},
		["carry"] = {0, -0.3, -0.6, 0, 0, 180},
		["position"] = {1.5, 0, 0},
	},
	["bonnet_dummy"] = {
		["conveyor"] = {2, 0, -0.85, 0, 0, 90},
		["carry"] = {0, -0.2, -0.6, 0, 0, 0},
		["position"] = {-2.5, 0, 0},
	},
	["door_lf_dummy"] = {
		["conveyor"] = {-1, -0.2, -0.8, 0, 85, 90},
		["carry"] = {0.6, 0, -0.2, 0, 0, -90},
		["position"] = {0.5, -0.6, 0},
	},
	["door_rf_dummy"] = {
		["conveyor"] = {-1, 0.2, -0.8, 0, -85, 90},
		["carry"] = {-0.6, 0, -0.2, 0, 0, 90},
		["position"] = {0.5, 0.6, 0},
	},
	["wheel_lf_dummy"] = {
		["conveyor"] = {0, 0, 0, 0, 0, 0},
		["carry"] = {0, 0, 0, 0, 0, 0},
		["position"] = {0, -0.6, 0},
	},
	["wheel_rf_dummy"] = {
		["conveyor"] = {0, 0, 0, 0, 0, 0},
		["carry"] = {0, 0, 0, 0, 0, 0},
		["position"] = {0, 0.6, 0},
	},
	["wheel_lb_dummy"] = {
		["conveyor"] = {0, 0, 0, 0, 0, 0},
		["carry"] = {0, 0, 0, 0, 0, 0},
		["position"] = {0, -0.6, 0},
	},
	["wheel_rb_dummy"] = {
		["conveyor"] = {0, 0, 0, 0, 0, 0},
		["carry"] = {0, 0, 0, 0, 0, 0},
		["position"] = {0, 0.6, 0},
	},
}
local components = {
	"boot_dummy","ug_nitro","wheel_rf_dummy","wheel_lb_dummy","wheel_rb_dummy",
	"wheel_lf_dummy","door_lr_dummy","chassis_vlo","door_rf_dummy",
	"misc_b","chassis_dummy","misc_a","bonnet_dummy","bump_front_dummy", "chassis",
	"windscreen_dummy","exhaust_ok","door_lf_dummy","door_rr_dummy","bump_rear_dummy"
}

function getNextBuildPart()
	if not buildingCar then return end
	local nextPart = false
	for k in pairs(needParts) do
		if not getVehicleComponentVisible(buildingCar, k) then
			nextPart = k
			break
		end
	end
	return nextPart
end

function sendMessageClient ( msg, type )
	return exports['guetto_notify']:showInfobox(type, msg)
end

function takePart(el, md)
	if el == localPlayer and md and not isPedInVehicle(el) and not isPedDucked(el) then 
		if componentPosTimer then killTimer(componentPosTimer) end
		carringPart = true
		toggleControl("sprint", false)
		toggleControl("crouch", false)
		toggleControl("jump", false)
		if isElement(carryMarker) then
			destroyElement(carryMarker)
		end
		removeEventHandler("onClientColShapeHit", col, takePart)
		destroyElement(col)
		col = false
		carryPos = needParts[currentCarry]["carry"]
		moveZ = 0
		if string.find(currentCarry, "door") then
			for k,v in pairs(avaibleVehicles) do
				if v[1] == getElementModel(buildingPart) then
					moveZ = v[3]
				end
			end
		end
		attachElements(buildingPart, localPlayer, 0, 0.4, 1 + moveZ)
		setVehicleComponentPosition(buildingPart, currentCarry, carryPos[1], carryPos[2], carryPos[3])
		setVehicleComponentRotation(buildingPart, currentCarry, carryPos[4], carryPos[5], carryPos[6])
		setPedAnimation(localPlayer, "CARRY", "liftup105", -1, false, true, false, false)
		setTimer(function(player)
			setPedAnimation(localPlayer, "CARRY", "crry_prtial", 1, false, true)
		end, 500, 1, client)
		createBuildMarker(currentCarry)
	end
end

function vehiclePickup()
	if buildPed then destroyElement(buildPed) end
	buildPed = createPed(50, 338.71884155273, 39.476722717285, 990.55627441406)
	setPedControlState(buildPed, "forwards", true)
	setPedControlState(buildPed, "walk", true)
	local money = math.random(2500,3000)
	local exp = (getElementData(localPlayer, "XP") or 0)

	
	setTimer(function()
		warpPedIntoVehicle(buildPed, buildingCar)
		setElementFrozen(buildingCar, false)
		alpha = 250
		speed = 0
		setTimer(function()
			if buildingCar then
				alpha = alpha - 10
				speed = speed + 1
				setElementAlpha(buildingCar, alpha)
				setElementAlpha(buildPed, alpha)
				setElementVelocity(buildingCar, -speed / 100, 0, 0)
			end
		end, 50, 25)
		setTimer(function()
			
			triggerServerEvent("OnPlayerSendMoney", resourceRoot)

			destroyElement(buildPed)
			buildPed = false
			createBuildCar()
			setTimer(function()
				local nextPart = getNextBuildPart()
				createBuildPart(nextPart)
			end, 1000, 1)
		end, 1500, 1)
	end, 1500, 1)
end

function addPart(el, md)
	if el == localPlayer and md and not isPedInVehicle(el) then
		carringPart = false
		toggleControl("sprint", true)
		toggleControl("crouch", true)
		toggleControl("jump", true)
		setPedControlState(localPlayer, "walk", false)
		removeEventHandler("onClientColShapeHit", colAdd, addPart)
		if isElement(buildMarker) then
			destroyElement(buildMarker)
		end
		sendMessageClient("Colocando Peça","info")
		triggerEvent("progressBar",localPlayer,"2000")
		addingActive = getTickCount()
		--playSound("sounds/repair.mp3")
		setPedAnimation(localPlayer, "bomber","bom_plant")
		setVehicleComponentVisible(buildingCar, currentCarry, true)
		local nextPart = getNextBuildPart()
		if nextPart then
			destroyBuildPart()
			setTimer(function()
				createBuildPart(nextPart)
			end, 2000, 1)
		else
			destroyBuildPart()
			setTimer(function()
				vehiclePickup()
			end, 2000, 1)
		end
		setTimer(function()
			addingActive = false
			setPedAnimation(localPlayer)
		end, 2000, 1)
	end
end


function createBuildMarker(part)
	if not buildingCar then return end
	x, y, z = getVehicleComponentPosition(buildingCar, part)
	x, y, z = vehiclePosition[1] - y + needParts[part]["position"][1], vehiclePosition[2] + x + needParts[part]["position"][2], vehiclePosition[3] + z + needParts[part]["position"][3]
	z = getGroundPosition(x, y, z + 1) + 1
	if isElement(buildMarker) then
		destroyElement(buildMarker)
	end
	buildMarker =  createMarker(x, y, z-1, 'cylinder', 1.5, 255, 215, 0, 0)
	setElementData(buildMarker , 'markerData', {title = 'Montadora de veículos', desc = 'Coloque o componente aqui!', icon = 'checkpoint'})
	colAdd = createColSphere(x, y, z, 1)
	addEventHandler("onClientColShapeHit", colAdd, addPart)
end

function destroyBuildPart()
	if not buildingCar then return end
	if partObject then detachElements(partObject, localPlayer) end
	if buildingPart then destroyElement(buildingPart) buildingPart = false end
	if col then destroyElement(col) col = false end
	if colAdd then destroyElement(colAdd) colAdd = false end
	if functionTimer then killTimer(functionTimer) functionTimer = false end
end

function showOneComponent(part)
	if carringPart then return end
	if not buildingPart then return end
	for k, v in pairs(components) do
		setVehicleComponentVisible(buildingPart, v, false)
	end
	setVehicleComponentVisible(buildingPart, part, true)
	setVehicleComponentPosition(buildingPart, part, partsData[1], partsData[2], partsData[3])
	setVehicleComponentRotation(buildingPart, part, partsData[4], partsData[5], partsData[6])
end

function createBuildPart(part)
	destroyBuildPart()
	currentCarry = part
	if not buildingPart then
		buildingPart = createVehicle(getElementModel(buildingCar), 0, 0, 0)
		setElementCollisionsEnabled(buildingPart, false)
		setElementCollidableWith(getCamera(), buildingPart, false)
		setElementCollidableWith(buildingPart, getCamera(), false)
		setElementData(buildingPart, "vehicle:ghost:off", true)
	end
	if not partObject then
		partObject = createObject(2000, 0, 0, 0)
		setElementCollisionsEnabled(partObject, false)
	end
	partsData = needParts[part]["conveyor"]
	movetoZ = 0
	if partsData[3] == 0 then
		movetoZ = -0.1
	end
	if isTimer(showingTimer) then
		killTimer(showingTimer)
	end
	if isElement(carryMarker) then
		destroyElement(carryMarker)
	end
	setElementModel(buildingPart, getElementModel(buildingCar))
	r, g, b = getVehicleColor(buildingCar, true)
	setVehicleColor(buildingPart, r, g, b)
	attachElements(buildingPart, partObject)
	setElementPosition(partObject, 353.63305664063, 43.683124542236, 985.32788085938 + movetoZ)
	setElementAlpha(partObject, 0)
	showingTimer = setTimer(showOneComponent, 1000, 10, part)
	functionTimer = setTimer(function()
		functionTimer = false
		setElementPosition(partObject, 353.63305664063, 43.683124542236, 991.32788085938)
		setElementAlpha(partObject, 255)
		setElementAlpha(partObject, 0)
		moveObject(partObject, 3000, 349.14828491211, 43.618270874023, 991.33227539063 + movetoZ)
		functionTimer = setTimer(function()
			functionTimer = false
			carryMarker = createMarker(346.86895751953, 43.608123779297, 989.55627441406, 'cylinder', 1.5, 255, 215, 0, 0)
			setElementData(carryMarker , 'markerData', {title = 'Montadora de veículos', desc = 'Pegue o componente do veículo!', icon = 'magazineBox'})
			col = createColSphere(346.86895751953, 43.608123779297, 989.55627441406, 1.5)
			addEventHandler("onClientColShapeHit", col, takePart)
		end, 3000, 1)
	end, 1000, 1)
end

function createBuildCar()
	fadeCamera(false, 0.1)
	if buildingCar then
		destroyElement(buildingCar)
		buildingCar = false
	end
	setTimer(function()
		local random = avaibleVehicles[math.random(1, #avaibleVehicles)]
		buildingCar = createVehicle(random[1], vehiclePosition[1], vehiclePosition[2], vehiclePosition[3] + random[2], 0, 0, vehiclePosition[4])
		setElementFrozen(buildingCar, true)
		setElementData(buildingCar, "vehicle:ghost:off", true)
	end, 100, 1)
	setTimer(function()
		for k, v in pairs(components) do
			if v ~= "chassis" then
				setVehicleComponentVisible(buildingCar, v, false)
			end
		end
		fadeCamera(true, 1)
	end, 1000, 1)
end


function endJob()
	destroyBuildPart()
	carringPart = false
	toggleControl("sprint", true)
	toggleControl("crouch", true)
	toggleControl("jump", true)
	setElementData(localPlayer, "player:job", false)
	setElementPosition(localPlayer, 1829.352, -1125.651, 23.888)
	setElementRotation(localPlayer, 0, 0, 90)
	triggerServerEvent("endJob", resourceRoot, localPlayer)
	if ambient then
		stopSound(ambient)
	end
end
addEvent("endJobb", true)
addEventHandler("endJobb", root, endJob)

function startJob()
	local job = getElementData(localPlayer, "SX:Level") or 0
	if (isPedInVehicle(localPlayer)) then
		sendMessageClient("Saia do veículo.", "error")
		return
	end
	if (getElementData(localPlayer, "Emprego") ~= "Montadora") then 
		return sendMessageClient("Você não trabalha aqui!", "error")
	end
	if ( job >= 0 ) then
		fadeCamera(false, 0.1)
		--ambient = playSound("sounds/ambient.mp3")
		setElementData(localPlayer, "player:job", "factory")
		triggerServerEvent("startJob", resourceRoot, localPlayer)
		setTimer(function()
			fadeCamera(true, 1)
			setElementPosition(localPlayer, 325.53198242188, 38.200031280518, 990.55627441406)
			setElementRotation(localPlayer, 0,0,268.10610961914)
			createBuildCar()
			setTimer(function()
				createBuildPart(getNextBuildPart())
			end, 2000, 1)
		end, 2000, 1)		
	end
end
addEvent("startJobb", true)
addEventHandler("startJobb", root, startJob)
