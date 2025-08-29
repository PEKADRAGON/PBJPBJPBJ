--[[

██╗░░░██╗░█████╗░███╗░░██╗███████╗░██████╗░██████╗░█████╗░  ░██████╗░█████╗░██████╗░
██║░░░██║██╔══██╗████╗░██║██╔════╝██╔════╝██╔════╝██╔══██╗  ██╔════╝██╔══██╗██╔══██╗
╚██╗░██╔╝███████║██╔██╗██║█████╗░░╚█████╗░╚█████╗░███████║  ╚█████╗░██║░░╚═╝██████╔╝
░╚████╔╝░██╔══██║██║╚████║██╔══╝░░░╚═══██╗░╚═══██╗██╔══██║  ░╚═══██╗██║░░██╗██╔══██╗
░░╚██╔╝░░██║░░██║██║░╚███║███████╗██████╔╝██████╔╝██║░░██║  ██████╔╝╚█████╔╝██║░░██║
░░░╚═╝░░░╚═╝░░╚═╝╚═╝░░╚══╝╚══════╝╚═════╝░╚═════╝░╚═╝░░╚═╝  ╚═════╝░░╚════╝░╚═╝░░╚═╝

- Todos os direitos reservados a FiveShop.

- E tudo quanto fizerdes, seja por meio de palavras ou ações, fazei em o Nome do Senhor Jesus, oferecendo por intermédio dele graças a Deus Pai.
]]--

local screenX, screenY = guiGetScreenSize()

local regular = dxCreateFont('files/regular.ttf', 14)

function reMap(x, in_min, in_max, out_min, out_max)
    return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min
end

responsiveMultipler = reMap(screenX, 1024, 1920, 0.75, 1)

function respc(num)
    return math.ceil(num * responsiveMultipler)
end

local registerEvent = function(eventName, element, func)
	addEvent(eventName, true)
	addEventHandler(eventName, element, func)
end

local mineColshape = createColRectangle(-820.41381835938, -1932.8894042969, 150, 100)
local receivedOres = {}
local oreW, oreH = 100, 100
local jobPed = nil
local dropPed = nil
local jobActive = false
local currentMiningValue = 0
local lastMiningValue = 0
local showMinigame = false
local showOres = false

addEventHandler("onClientResourceStart", resourceRoot, function ()
	jobPed = createPed(290,Confg["posped"][1],Confg["posped"][2],Confg["posped"][3],Confg["posped"][4])
    createBlipAttachedTo(jobPed,11,2,255,0,0,255,0,255)
	setElementFrozen(jobPed, true)
    setPedAnimation(jobPed, "COP_AMBIENT", "Coplook_think", -1, true, false, false)
end)

function startJob()
    sendMessageClient("Você iniciou a mineração com sucesso! Vai para a mina", "info")
    triggerServerEvent("onStartMinerador", resourceRoot)
    jobActive = true
end

function stopJob()
    sendMessageClient("Você terminou de minerar!", "info")
    jobActive = false
end

local startTick = nil

function startMining()
    if currentMiningValue < 100 then
        startTick = getTickCount()
        lastMiningValue = currentMiningValue
        currentMiningValue = currentMiningValue + math.random(5, 15)
        triggerServerEvent("NS:Sminer", localPlayer)
        if currentMiningValue >= 100 then
            currentMiningValue = 100
            setTimer(function()
                stopMining()
            end, 1500, 1)
        end
    end
end

function stopMining()
    triggerServerEvent("NS:STminer", localPlayer)
    showMiningGame()
end

local stoneState = 0
local clickCounter = 0
local lastClickTick = 0

function showMiningGame()
    stoneState = 0
    showMinigame = true
    clickCounter = 0
    changeStoneCrosshair()
end

function hideMiningGame()
    showMinigame = false
end

registerEvent("sarp_miningC:playMiningSound", root, function()
    local x, y, z = getElementPosition(source)
	playSound3D("files/mining.mp3", x, y, z)
end)

local lastHit = getTickCount()
local coolDown = 1500 

addEventHandler("onClientKey", root, function(button, press)
    if isElementWithinColShape(localPlayer, mineColshape) and jobActive then
        if getPedWeapon(localPlayer) == 6 then
            if button == "mouse1" and press then
                if lastHit < getTickCount() - coolDown then
                    lastHit = getTickCount()
                    startMining()   
                end
            end
        end
    end
end)

local barW, barH = 251, 10
local barX, barY = (screenX - barW) * 0.5, screenY - 5 - 46 - barH - 5

local crosshairW, crosshairH = respc(40), respc(40)
local crosshairX, crosshairY = 0, 0

local stoneW, stoneH = respc(400), respc(200)
local stoneX, stoneY = (screenX / 2) - (stoneW / 2), (screenY / 2) - (stoneH / 2)

local pickaxeW, pickaxeH = respc(40), respc(40)

addEventHandler("onClientRender", root, function()
    if isElementWithinColShape(localPlayer, mineColshape) and jobActive and not showMinigame and not showOres then
        dxDrawRectangle(barX, barY, barW, barH, tocolor(31, 31, 31, 240))  

        if startTick then
            local currentTick = getTickCount()
            local elapsedTick = currentTick - startTick
            local endTick = startTick + 1200
            local duration = endTick - startTick
            local barProgress = elapsedTick / duration
            local barFill = interpolateBetween(
                lastMiningValue / 100, 0, 0,
                currentMiningValue / 100, 0, 0,
                barProgress, "Linear"
            )
            dxDrawRectangle(barX + 2, barY + 2, (barW - 4) * barFill, barH - 4, tocolor(7, 112, 196, 240))  
        end  
    end

    if showMinigame then
        dxDrawImage(stoneX, stoneY, stoneW, stoneH, "files/stone" .. stoneState .. ".png")
		dxDrawImage(crosshairX, crosshairY, crosshairW, crosshairH, "files/crosshair.png")
        
		if isCursorShowing() then
			local relX, relY = getCursorPosition()
			local cursorX, cursorY = relX * screenX, relY * screenY
            setCursorAlpha(0)
            local pickaxeRX = 0
            if getKeyState("mouse1") then
                pickaxeRX = -30
            end
			dxDrawImage(cursorX - respc(10), cursorY - respc(10), pickaxeW, pickaxeH, "files/pickaxe.png", pickaxeRX, 0, 0)
        end
        
    elseif showOres then
        
		for k, v in pairs(receivedOres) do
			dxDrawImage(v[2], v[3], oreW, oreH, Confg["ores"][v[1]][2])
		end
		
		if isCursorShowing() then
			local relX, relY = getCursorPosition()
			local cursorX, cursorY = relX * screenX, relY * screenY
			setCursorAlpha(0)
			dxDrawImage(cursorX - respc(10), cursorY - respc(10), pickaxeW, pickaxeH, "files/zsak.png", pickaxeRX, 0, 0)
		end

    end
end)

addEventHandler("onClientClick", root, function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedWorld)
    if button == "left" and state == "down" then
        if clickedWorld == jobPed then
            local playerPosX, playerPosY, playerPosZ = getElementPosition(localPlayer)
			local pedPosX, pedPosY, pedPosZ = getElementPosition(jobPed)
				if getDistanceBetweenPoints3D(playerPosX, playerPosY, playerPosZ, pedPosX, pedPosY, pedPosZ) <= 3 then
                    if getElementData(localPlayer, "Emprego") == Confg["elementdata"] then
                        if jobActive then
                            stopJob()
                        else
                            startJob()
                        end
                    else 
                        sendMessageClient("Você não trabalha de minerador","error")
                    end
                end
            end 
        end
    if showMinigame then
        if state == "down" then
            if cursorInBox(crosshairX, crosshairY, crosshairW, crosshairH) then
                if getTickCount() - lastClickTick >= 350 then
                    lastClickTick = getTickCount()
                    playSound("files/pickaxe.mp3")
                    clickCounter = clickCounter + 1
                    if clickCounter % 2 == 0 then
                        changeStoneCrosshair()
                        changeStoneState()
                    end
                end
            end
        end
    elseif showOres then
        for k, v in pairs(receivedOres) do
            dxDrawImage(v[2], v[3], oreW, oreH, Confg["ores"][v[1]][2])
            if cursorInBox(v[2], v[3], oreW, oreH) then
                if #receivedOres == 1 then
                    showOres = false
                    setCursorAlpha(255)
                    lastMiningValue = 0
                    currentMiningValue = 0   
                end
                table.remove(receivedOres, k)
                triggerServerEvent("NS:Giveore",resourceRoot,Confg["ores"][v[1]][3])
            end
        end
    end
end)

function dropOresFromStone()
	showOres = true
	local count = 1
	for i = 1, count do
		local chance = math.random(1, #Confg["ores"])
		local randomX, randomY = generateRandomPointBetween(0, 0, screenX, screenY, oreW, oreH)
		receivedOres[i] = {chance, randomX, randomY}
	end
end

function changeStoneState()
	if clickCounter == 10 then -- 10
		stoneState = 1
	elseif clickCounter == 20 then -- 20
		stoneState = 2
	elseif clickCounter == 26 then -- 26
		hideMiningGame()
		dropOresFromStone()
	end
end

function changeStoneCrosshair()
	if showMinigame then
		crosshairX, crosshairY = generateRandomPointBetween(stoneX + respc(25), stoneY, stoneW - respc(105), stoneH - respc(20), crosshairW, crosshairH)
	end
end

function cursorInBox(x, y, w, h)
	if x and y and w and h then
		if isCursorShowing() then
			if not isMTAWindowActive() then
				local cursorX, cursorY = getCursorPosition()
				
				cursorX, cursorY = cursorX * screenX, cursorY * screenY
				
				if cursorX >= x and cursorX <= x + w and cursorY >= y and cursorY <= y + h then
					return true
				end
			end
		end
	end
	
	return false
end

function generateRandomPointBetween(x, y, w1, h1, w2, h2)
    x = x + math.floor(math.random() * ((x + w1 - w2) - x))
    y = y + math.floor(math.random() * ((y + h1 - h2) - y))
    return x, y
end

function dxDrawTextPed()
    dxDrawTextOnElement(jobPed, '[NPC] Mineirador (Trabalho)', 1, 20.1, 0, 0, 0, 255, 1, regular)
    dxDrawTextOnElement(jobPed, '#00AAFF[NPC] #FFFFFFMineirador #00AAFF(Trabalho)', 1, 20, 255, 255, 255, 255, 1, regular)
end
addEventHandler('onClientRender', getRootElement(), dxDrawTextPed)

function dxDrawTextOnElement(TheElement, text, height, distance, R, G, B, alpha, size, font, ...)
    local x, y, z = getElementPosition(TheElement)
    local x2, y2, z2 = getCameraMatrix()
    local distance = distance or 20
    local height = height or 1
    local value1 = 2
    local value2 = 2
    if (isLineOfSightClear(x, y, z+2, x2, y2, z2, ...)) then
        local sx, sy = getScreenFromWorldPosition(x, y, z+height)
        if(sx) and (sy) then
            local distanceBetweenPoints = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
            if(distanceBetweenPoints < distance) then
                dxDrawText(text, sx+value1, sy+value2, sx, sy, tocolor(R or 255, G or 255, B or 255, alpha or 255), (size or 1)-(distanceBetweenPoints / distance), font or 'default', 'center', 'center', false, false, false, true, false)
            end
        end
    end
end