local sx, sy = guiGetScreenSize()
local zoom = 1
local baseX = 1900
local minZoom = 2
if sx < baseX then
    zoom = math.min(minZoom, baseX/sx)
end

local guiInfo = {
	x = (sx - 225/zoom)/2,
	y = sy - 160/zoom,
	w = 225/zoom,
	h = 48/zoom,

	buttons = {
		[1] = {"sound:1", "Sirene 1", "sound.png"},
		[2] = {"sound:2", "Sirene 2", "sound.png"},
		[3] = {"sound:3", "Sirene 3", "sound.png"},
		[4] = {"light:1", "Giroflex 1", "light.png"},
		[5] = {"strobe:1", "Farol piscando", "light.png"},
	},

	activeButtonDef = {
		sound = false, 
		light = false, 
		strobe = false
	},

	--exports.RBR_Framework:getFont(12)
}

local svg = {
    [1] = [[
        <svg width="225" height="48" viewBox="0 0 225 48" fill="none" xmlns="http://www.w3.org/2000/svg">
		<rect width="225" height="48" rx="10" fill="white"/>
		</svg>
    ]],
}

local svgs = {
    rounded = svgCreate(225, 48, svg[1])
}


local draggingPanel = false

local sirenSounds = {}
local airhornSounds = {}

function showPanel(veh)

	if (isEventHandlerAdded("onClientRender", root, render)) then 
		removeEventHandler("onClientRender", root, render)
	end

	if (isEventHandlerAdded("onClientClick", root, click)) then 
		removeEventHandler("onClientClick", root, click)
	end

	addEventHandler("onClientRender", root, render)
	addEventHandler("onClientClick", root, click)

	inVehicle = veh
end

function closePanel()
	removeEventHandler("onClientRender", root, render)
	removeEventHandler("onClientClick", root, click)
	
	if isElement(inVehicle) then
		setElementData(inVehicle, "vehicleSirenSound", nil)
	end
	inVehicle = nil
end

local buttons = {}
local activeButton = false

function render()
	if not isPedInVehicle(localPlayer) then closePanel() end

	local absX, absY = getCursorPosition()
	if isCursorShowing() then
		absX = absX * sx
		absY = absY * sy
		if getKeyState("mouse1") then
			if absX >= guiInfo.x and absX <= guiInfo.x + guiInfo.w and absY >= guiInfo.y and absY <= guiInfo.y + guiInfo.h and not activeButton and not draggingPanel then
				draggingPanel = {absX, absY, guiInfo.x, guiInfo.y}
			end
			if draggingPanel then
				guiInfo.x = absX - draggingPanel[1] + draggingPanel[3]
				guiInfo.y = absY - draggingPanel[2] + draggingPanel[4]
			end
		elseif draggingPanel then
			draggingPanel = false
		end
	else
		absX, absY = -1, -1
		if draggingPanel then
			draggingPanel = false
		end
	end

	dxDrawImage(guiInfo.x, guiInfo.y, guiInfo.w, guiInfo.h, svgs.rounded, 0, 0, 0, tocolor(28, 28, 29, 255))

	local c = 0
	for i, v in ipairs(guiInfo.buttons) do
		drawControlButton(guiInfo.x + 10/zoom + (i - 1) * 40/zoom, guiInfo.y + 7/zoom, 35/zoom, 35/zoom, split(v[1], ":")[1], tonumber(split(v[1], ":")[2]), "files/" .. v[3])
		buttons[v[1]] = {guiInfo.x + 10/zoom + (i - 1) * 40/zoom, guiInfo.y + 7/zoom, 35/zoom, 35/zoom}
	end

	activeButton = false

	if isCursorShowing() then
		for k, v in pairs(buttons) do
			if absX >= v[1] and absX <= v[1] + v[3] and absY >= v[2] and absY <= v[2] + v[4] then
				activeButton = k
				break
			end
		end
	end
end

function click(button, state)
	if button ~= "left" or state ~= "down" then return end
	if not activeButton then return end
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if not vehicle then return end
	local selected = split(activeButton, ":")
	if selected[1] == "sound" then
		local soundID = tonumber(selected[2])

		if activeControls.sound == soundID then
			activeControls.sound = false
		else
			activeControls.sound = soundID
		end
		setElementData(inVehicle, "vehicleSirenSound", {"sirenNormal", activeControls.sound})

	elseif selected[1] == "light" then
		local lightID = tonumber(selected[2])

		if activeControls.light == lightID then
			activeControls.light= false
		else
			activeControls.light = lightID
		end
		triggerServerEvent("toggleVehicleLights", resourceRoot, vehicle)

	elseif selected[1] == "strobe" then
		local strobeID = tonumber(selected[2])

		if activeControls.strobe == strobeID then
			activeControls.strobe= false
		else
			activeControls.strobe = strobeID
		end
	end

	setElementData(vehicle, "vehicle.siren", activeControls)
	--[[if source == localPlayer and (seat == 0 or seat == 1) then
		local data = getElementData(vehicle, "vehicle.siren")
		activeControls = data and data or guiInfo.activeButtonDef
	end]]
end

function drawControlButton(x, y, w, h, type, id, img)
	if activeControls[type] == id then
		dxDrawImage(x + 5/zoom, y + 5/zoom, w - 10/zoom, h - 10/zoom, img, 0, 0, 0, tocolor(193, 159, 114, 255))
	else
		local color = 255
		if isMouseInPosition(x + 5/zoom, y + 5/zoom, w - 10/zoom, h - 10/zoom) then
			color = 150
		end
		dxDrawImage(x + 5/zoom, y + 5/zoom, w - 10/zoom, h - 10/zoom, img, 0, 0, 0, tocolor(color, color, color, color))
	end
end

addEventHandler("onClientPlayerVehicleEnter", getRootElement(), function(vehicle, seat)
	if source ~= localPlayer or seat > 1 then return end
	local model = getElementModel(vehicle)
	if not vehiclesSirenSound[model] then return end
	local data = getElementData(vehicle, "vehicle.siren")
	activeControls = data and data or guiInfo.activeButtonDef
	showPanel(vehicle)
end)

addEventHandler("onClientVehicleStartExit", getRootElement(), function(vehicle, seat)
	if source ~= localPlayer or seat > 1 then return end
	local model = getElementModel(vehicle)
	if not vehiclesSirenSound[model] then return end
	closePanel(vehicle)
end)

function playSoundSiren(type, active, veh)
	if not veh or not isElement(veh) then return end
	local model = getElementModel(veh) 
	local x, y, z = getElementPosition(veh)
	if type == "air" then
		if active then
			if vehiclesSirenSound[model] then
				if isElement(airhornSounds[veh]) then
					destroyElement(airhornSounds[veh])
				end

				local horn = vehiclesSirenSound[model].horn
				if horn then
					airhornSounds[veh] = playSound3D("sirens/"..horn, x, y, z, true)
					setSoundMaxDistance(airhornSounds[veh], 200)
					attachElements(airhornSounds[veh], veh)
					setSoundVolume(airhornSounds[veh], 0.3)
				end
			end
		else
			if isElement(airhornSounds[veh]) then
				destroyElement(airhornSounds[veh])
			end
		end
	elseif type == "sirenNormal" then
		if active then
			if vehiclesSirenSound[model] then
				if isElement(sirenSounds[veh]) then
					destroyElement(sirenSounds[veh])
				end

				local sound = vehiclesSirenSound[model]["siren"][active]
				if sound then
					sirenSounds[veh] = playSound3D("sirens/"..sound, x, y, z, true)
					setSoundMaxDistance(sirenSounds[veh], 200)
					attachElements(sirenSounds[veh], veh)
					setSoundVolume(sirenSounds[veh], 0.3)
				end
			end
		else
			if isElement(sirenSounds[veh]) then
				destroyElement(sirenSounds[veh])
			end
		end
	end
end

function toggleVehicleSirenSound(btn, state)
	if not inVehicle or not isElement(inVehicle) then return end
	if state == "down" then
		setElementData(inVehicle, "vehicleSirenSound", {"air", true})
	elseif state == "up" then
		setElementData(inVehicle, "vehicleSirenSound", nil)
	end
end

local vehicleLightData = {}
local luzesFarolTempo = {}

function luzesFarol(vehicle, state)
	if isElement(vehicle) then
		if state then
			setVehicleLightState(vehicle, 0, 1)
			setVehicleLightState(vehicle, 3, 1)
			setVehicleLightState(vehicle, 1, 0)
			setVehicleLightState(vehicle, 2, 0)
			setVehicleHeadLightColor(vehicle, 255, 255, 255) -- 0, 0, 255
		else
			setVehicleLightState(vehicle, 0, 0)
			setVehicleLightState(vehicle, 3, 0)
			setVehicleLightState(vehicle, 1, 1)
			setVehicleLightState(vehicle, 2, 1)
			setVehicleHeadLightColor(vehicle, 255, 255, 255) -- 255, 0, 0
		end

		luzesFarolTempo[vehicle] = setTimer(luzesFarol, 150, 1, vehicle, not state)
	else
		luzesFarolTempo[vehicle] = nil
	end
end

addEventHandler("onClientElementDataChange", root, function(dataName, oldValue, data)
	if dataName ~= "vehicle.siren" then return end
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if not vehicle or source ~= vehicle then return end
	local seat = getPedOccupiedVehicleSeat(localPlayer)
	if seat > 1 then return end
	activeControls = data and data or guiInfo.activeButtonDef
end)

addEventHandler("onClientElementDataChange", root, function(dataName, oldValue, data)
	if dataName ~= "vehicle.siren" then return end
	if data.strobe then
		if vehicleLightData[source] then return end
		vehicleLightData[source] = {}

		for i = 0, 3 do
			vehicleLightData[source][i] = getVehicleLightState(source, i)
		end

		vehicleLightData[source].color = {getVehicleHeadLightColor(source)}
		vehicleLightData[source].override = getVehicleOverrideLights(source)

		setVehicleOverrideLights(source, 2)

		luzesFarolTempo[source] = setTimer(luzesFarol, 150, 1, source, true)
	else
		if isTimer(luzesFarolTempo[source]) then killTimer(luzesFarolTempo[source]) end
		if not vehicleLightData[source] then return end

		for i = 0, 3 do
			setVehicleLightState(source, i, vehicleLightData[source][i])
		end

		setVehicleHeadLightColor(source, unpack(vehicleLightData[source].color))
		setVehicleOverrideLights(source, vehicleLightData[source].override)

		vehicleLightData[source] = nil
	end
end)


addEventHandler("onClientElementDataChange", root, function(dataName, oldData, data)
	if dataName ~= "vehicleSirenSound" then return end
	if data then
		playSoundSiren(data[1], data[2], source)
	else
		if not oldData or not oldData[1] then return end
		playSoundSiren(oldData[1], false, source)
	end
end)

addEventHandler("onClientElementDestroy", root, function()
	if getElementType(source) ~= "vehicle" then return end
	if airhornSounds[source] and isElement(airhornSounds[source]) then
		destroyElement(airhornSounds[source])
	end
	if sirenSounds[source] and isElement(sirenSounds[source]) then
		destroyElement(sirenSounds[source])
	end
end)

function isMouseInPosition(x, y, width, height, noAffectCursor)
	if (not isCursorShowing()) then
		return false
	end
    local cx, cy = getCursorPosition()
    local cx, cy = (cx*sx), (cy*sy)
    if (cx >= x and cx <= x + width) and (cy >= y and cy <= y + height) then
        return true
    else
        return false
    end
end

function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
    if type( sEventName ) == 'string' and isElement( pElementAttachedTo ) and type( func ) == 'function' then
        local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
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