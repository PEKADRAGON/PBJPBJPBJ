--| Idle function's

isPlayerIdle = {}

function setPlayerIdle(player, state)
    if state then

        if not isPlayerIdle[player] then
            isPlayerIdle[player] = getTickCount() 
        end

    else

        if isPlayerIdle[player] then
            isPlayerIdle[player] = nil
        end
        
    end
end
addEvent("setPlayerIdle", true)
addEventHandler("setPlayerIdle", root, setPlayerIdle)

addEventHandler("onClientMinimize", root, function()
    triggerServerEvent("FS:forceIdle", localPlayer, localPlayer, true)
end)

addEventHandler("onClientRestore", root, function()
    triggerServerEvent("FS:forceIdle", localPlayer, localPlayer, false)
end)

--| Fly

local keys = {}
keys.up = "up"
keys.down = "up"
keys.f = "up"
keys.b = "up"
keys.l = "up"
keys.r = "up"
keys.a = "up"
keys.s = "up"
keys.m = "up"

addEvent("FS:toggleFly",true)
addEventHandler("FS:toggleFly", getLocalPlayer(), function(flyState)
	
	if flyState then
		addEventHandler("onClientRender",getRootElement(), flyingRender)
		bindKey("lshift","both",keyH)
		bindKey("rshift","both",keyH)
		bindKey("lctrl","both",keyH)
		bindKey("rctrl","both",keyH)
		
		bindKey("forwards","both",keyH)
		bindKey("backwards","both",keyH)
		bindKey("left","both",keyH)
		bindKey("right","both",keyH)
		
		bindKey("lalt","both",keyH)
		bindKey("space","both",keyH)
		bindKey("ralt","both",keyH)
		bindKey("mouse1","both",keyH)

		setElementCollisionsEnabled(getLocalPlayer(),false)
	else
		removeEventHandler("onClientRender",getRootElement(),flyingRender)
		unbindKey("mouse1","both",keyH)
		unbindKey("lshift","both",keyH)
		unbindKey("rshift","both",keyH)
		unbindKey("lctrl","both",keyH)
		unbindKey("rctrl","both",keyH)
		
		unbindKey("forwards","both",keyH)
		unbindKey("backwards","both",keyH)
		unbindKey("left","both",keyH)
		unbindKey("right","both",keyH)
		
		unbindKey("space","both",keyH)
		
		keys.up = "up"
		keys.down = "up"
		keys.f = "up"
		keys.b = "up"
		keys.l = "up"
		keys.r = "up"
		keys.a = "up"
		keys.s = "up"

		setElementCollisionsEnabled(getLocalPlayer(),true)
	end
end)

function flyingRender()
	local x,y,z = getElementPosition(getLocalPlayer())
	local speed = 10
	if keys.a=="down" then
		speed = 3
	elseif keys.s=="down" then
		speed = 50
	elseif keys.m=="down" then
		speed = 300
	end
	
	if keys.f=="down" then
		local a = rotFromCam(0)
		setElementRotation(getLocalPlayer(),0,0,a)
		local ox,oy = dirMove(a)
		x = x + ox * 0.1 * speed
		y = y + oy * 0.1 * speed
	elseif keys.b=="down" then
		local a = rotFromCam(180)
		setElementRotation(getLocalPlayer(),0,0,a)
		local ox,oy = dirMove(a)
		x = x + ox * 0.1 * speed
		y = y + oy * 0.1 * speed
	end
	
	if keys.l=="down" then
		local a = rotFromCam(-90)
		setElementRotation(getLocalPlayer(),0,0,a)
		local ox,oy = dirMove(a)
		x = x + ox * 0.1 * speed
		y = y + oy * 0.1 * speed
	elseif keys.r=="down" then
		local a = rotFromCam(90)
		setElementRotation(getLocalPlayer(),0,0,a)
		local ox,oy = dirMove(a)
		x = x + ox * 0.1 * speed
		y = y + oy * 0.1 * speed
	end
	
	if keys.up=="down" then
		z = z + 0.1*speed
	elseif keys.down=="down" then
		z = z - 0.1*speed
	end
	
	setElementPosition(getLocalPlayer(),x,y,z)
end

function keyH(key,state)
	if key=="lshift" or key=="rshift" then
		keys.s = state
	end	
	if key=="lctrl" or key=="rctrl" then
		keys.down = state
	end	
	if key=="forwards" then
		keys.f = state
	end	
	if key=="backwards" then
		keys.b = state
	end	
	if key=="left" then
		keys.l = state
	end	
	if key=="right" then
		keys.r = state
	end	
	if key=="lalt" or key=="ralt" then
		keys.a = state
	end	
	if key=="space" then
		keys.up = state
	end	
	if key=="mouse1" then
		keys.m = state
	end	
end

--| noClip misc

function rotFromCam(rzOffset)
	local cx,cy,_,fx,fy = getCameraMatrix(getLocalPlayer())
	local deltaY,deltaX = fy-cy,fx-cx
	local rotZ = math.deg(math.atan((deltaY)/(deltaX)))
	if deltaY >= 0 and deltaX <= 0 then
		rotZ = rotZ+180
	elseif deltaY <= 0 and deltaX <= 0 then 
		rotZ = rotZ+180
	end
	return -rotZ+90 + rzOffset
end

function dirMove(a)
	local x = math.sin(math.rad(a))
	local y = math.cos(math.rad(a))
	return x,y
end

--| Copy 

addEvent("FS:copyString", true)
addEventHandler("FS:copyString", root, function(string)
    setClipboard(string)
end)

--| Wall hack

isWallEnabled = {}
function playerWallRender()
    local allPlayers = getElementsByType("player")
    if allPlayers and #allPlayers ~= 0 then
        for i = 1, #allPlayers do
            local targetPlayer = allPlayers[i]
            if isElement(targetPlayer) then
                if (targetPlayer ~= localPlayer) then
                    local x, y, z = getElementPosition(localPlayer)
                    local ax, ay, az = getElementPosition(targetPlayer)
                    if getDistanceBetweenPoints3D(x, y, z, ax, ay, az) <= config["general"]["wallDistance"] then
                        dxDrawLine3D(x, y, z, ax, ay, az, tocolor (255, 82, 82, 175), 0.5, true)
                        dxDrawTextOnElement(targetPlayer, "Vida: "..math.floor (getElementHealth(targetPlayer)).."% | Colete: "..math.floor(getPedArmor(targetPlayer)).."% | ID: "..(getElementData(targetPlayer, "ID") or "N/A").."\nArma: "..getWeaponNameFromID(getPedWeapon(targetPlayer)).." | Nome: "..getPlayerName(targetPlayer).."", tocolor(255, 255, 255, 255), 0.6, ps_regular)
                    end
                end
            else
                table.remove(allPlayers, i)
            end
        end
    end
end

addEvent("VC:ToggleWall", true)
addEventHandler("VC:ToggleWall", getRootElement(), function(wallState)
    if wallState then 
        addEventHandler("onClientRender", getRootElement(), playerWallRender)
        isWallEnabled[source] = true
    else
        removeEventHandler("onClientRender", getRootElement(), playerWallRender)
        isWallEnabled[source] = nil
    end
end)

--| Wall util's

function dxDrawTextOnElement(element, text, color, size, font, ...)
    local camPosXl, camPosYl, camPosZl = getPedBonePosition(element, 6)
    local camPosXr, camPosYr, camPosZr = getPedBonePosition(element, 7)
    local x,y,z = (camPosXl + camPosXr) / 2, (camPosYl + camPosYr) / 2, (camPosZl + camPosZr) / 2

    local posx, posy = getScreenFromWorldPosition(x, y, z + 0.25)
    local cx, cy, cz = getCameraMatrix()
    local px, py, pz = getElementPosition(element)

    local distance = getDistanceBetweenPoints3D(cx, cy, cz, px, py, pz)
    local posx, posy = getScreenFromWorldPosition(x, y, z+0.020*distance+0.10)

    if posx and posy then
        local textSize = dxGetTextWidth(text, size, font, false)
        dxDrawText(text, posx - (0.5 * textSize), (posy - (sy*30)), posx - (0.5 * textSize), (posy - (sy*1.5)), color, size, font, "left", "top", false, false, false)
    end
end