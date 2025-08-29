local rotX, rotY = 0, 0
local cameraDistance = 0
local isEnabled = false

browserElementLookOptions = {
	target = getLocalPlayer(),
	[1] = {
		mouseSensitivity = 1,
		maxYAngle = 188,
		camZOffset = 0,
		invertedX = -1,
		invertedY = -1,
		distance = 4,
		minDistance = 2,
		maxDistance = 3,
		scrollUnits = 2,
		scrollSpeed = 0.1,
		up = "mouse_wheel_up",
		down = "mouse_wheel_down"
	},
	[2] = {
		mouseSensitivity = 1,
		maxYAngle = 80,
		camZOffset = 0.7,
		invertedX = -1,
		invertedY = -1,
		distance = 1,
		minDistance = 0.5,
		maxDistance = 1.5,
		scrollUnits = 2,
		scrollSpeed = 0.1,
		up = "mouse_wheel_up",
		down = "mouse_wheel_down"
	}
}

function setTargetElement(new)
	if new then
		local rx, ry, rz = getElementRotation(new)
		rotX = rx+90
	end
	browserElementLookOptions.target = new
end

local getPlayerFov = function()
	return dxGetStatus()["SettingFOV"]
end

function elementLookFrame()
	if not browserElementLookOptions.target or not isElement(browserElementLookOptions.target) then return end
	if not isElementLookEnabled() then return end
	if ( cameraDistance ~= browserElementLookOptions[isEnabled].distance ) then
		resetCamDist()
	end
	local camAngleX = browserElementLookOptions[isEnabled].invertedX * rotX / 120
	local camAngleY = browserElementLookOptions[isEnabled].invertedY * rotY / 120
	local camTargetX, camTargetY, camTargetZ = getElementPosition(browserElementLookOptions.target)
	camTargetZ = camTargetZ + browserElementLookOptions[isEnabled].camZOffset
	local distX = math.cos ( camAngleY ) * cameraDistance
	local camPosX = camTargetX + ( ( math.cos ( camAngleX ) ) * distX )
	local camPosY = camTargetY + ( ( math.sin ( camAngleX ) ) * distX )
	local camPosZ = camTargetZ + math.sin ( camAngleY ) * cameraDistance
	setCameraMatrix ( camPosX, camPosY, camPosZ, camTargetX, camTargetY, camTargetZ, 0, getPlayerFov() )
end

function elementLookMouse ( cX, cY, aX, aY )
	if not isElementLookEnabled() then return end
	if isMTAWindowActive() then return end
	if isCursorShowing() then return end
	local width, height = guiGetScreenSize()
	aX = aX - width / 2
	aY = aY - height / 2
	rotX = rotX + aX * browserElementLookOptions[isEnabled].mouseSensitivity
	rotY = rotY - aY * browserElementLookOptions[isEnabled].mouseSensitivity
	if rotY < -browserElementLookOptions[isEnabled].maxYAngle then
		rotY = -browserElementLookOptions[isEnabled].maxYAngle
	elseif rotY > browserElementLookOptions[isEnabled].maxYAngle then
		rotY = browserElementLookOptions[isEnabled].maxYAngle
	end
	rotX = keepInRange ( toRad(360), rotX )
end

function resetCamDist()
	local multiplier = math.abs ( cameraDistance - browserElementLookOptions[isEnabled].distance )
	if multiplier < 0.1 then
		multiplier = 0
	end
	local newDistance = browserElementLookOptions[isEnabled].scrollSpeed * multiplier
	
	if cameraDistance < browserElementLookOptions[isEnabled].distance then
		if cameraDistance + newDistance < browserElementLookOptions[isEnabled].distance then
			cameraDistance = cameraDistance + newDistance
		else cameraDistance = browserElementLookOptions[isEnabled].distance
		end
	elseif cameraDistance - newDistance > browserElementLookOptions[isEnabled].distance then
			cameraDistance = cameraDistance - newDistance
		else cameraDistance = browserElementLookOptions[isEnabled].distance
	end
end

function keepInRange ( range, angle )
	if angle > range then
		while angle > range do
			angle = angle - range
		end
	elseif angle < 0 then
		while angle < 0 do
			angle = angle + range
		end
	end
	return angle
end

function toRad ( angle )
	return ( math.rad ( angle ) * 120 )
end

function toDeg ( angle )
	return ( math.deg ( angle / 120 ) )
end

function math.round ( value )
	return math.floor ( value + 0.5 )
end

function scrollDown()
	if isCursorShowing() then return end
	if browserElementLookOptions[isEnabled].distance + browserElementLookOptions[isEnabled].scrollUnits < browserElementLookOptions[isEnabled].maxDistance then
		browserElementLookOptions[isEnabled].distance = browserElementLookOptions[isEnabled].distance + browserElementLookOptions[isEnabled].scrollUnits 
	else
		browserElementLookOptions[isEnabled].distance = browserElementLookOptions[isEnabled].maxDistance
	end
end

function scrollUp()
	if isCursorShowing() then return end
	if browserElementLookOptions[isEnabled].distance - browserElementLookOptions[isEnabled].scrollUnits > browserElementLookOptions[isEnabled].minDistance then
		browserElementLookOptions[isEnabled].distance = browserElementLookOptions[isEnabled].distance - browserElementLookOptions[isEnabled].scrollUnits 
	else
		browserElementLookOptions[isEnabled].distance = browserElementLookOptions[isEnabled].minDistance
	end
end

function isElementLookEnabled()
	return isEnabled
end

function setFreelookEvents(bool,state)
	if bool then
		if not isEnabled then
			isEnabled = state or 1
			bindKey(browserElementLookOptions[isEnabled].down, "down", scrollDown)
			bindKey(browserElementLookOptions[isEnabled].up, "down", scrollUp)
			addEventHandler("onClientRender", root, elementLookFrame)
			addEventHandler("onClientCursorMove", root, elementLookMouse)
		end
	else
		if isEnabled then
			unbindKey(browserElementLookOptions[isEnabled].up, "down", scrollUp)
			unbindKey(browserElementLookOptions[isEnabled].down, "down", scrollDown)
			removeEventHandler("onClientRender", root, elementLookFrame)
			removeEventHandler("onClientCursorMove", root,elementLookMouse)
			isEnabled = false
		end
	end
end