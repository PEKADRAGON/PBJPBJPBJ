local screenW, screenH = guiGetScreenSize()
local screenWidth,screenHeight = guiGetScreenSize()
local messageType = false;

local zoom = 1
if screenW < 1920 then
    zoom = math.min(2, 1920 / screenW)
end

screenX, screenY = guiGetScreenSize()

function reMap(x, in_min, in_max, out_min, out_max)
	return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min
end

responsiveMultipler = reMap(screenX, 1024, 1920, 0.75, 1)

function resp(num)
	return num * responsiveMultipler
end

function respc(num)
	return math.ceil(num * responsiveMultipler)
end

function getResponsiveMultipler()
	return responsiveMultipler
end

alertTypes = {
	success = {"Sucess", "", {0, 0, 0}, "files/sounds/success.wav"};
	error = {"Error", "", {0, 0, 0}, "files/sounds/error.wav"};
	warning = {"Warning", "", {0, 0, 0}, "files/sounds/warning.wav"};
	info = {"info", "", {0, 0, 0}, "files/sounds/info.wav"};
}

local infobox = {}
local iconSize = respc(35)
local Roboto14 = dxCreateFont("files/fonts/Regular.ttf", 17)

function showInfobox(type, msg, msg2, imgPath, color)
	if not (type and msg) then
		return
	end

	if msg2 and utf8.len(msg2) <= 0 then
		msg2 = nil
	end
	
	if imgPath then
		infobox.icon = imgPath
	else
		infobox.icon = alertTypes[type][2]
	end

	if color then
		infobox.color = color
	else
		infobox.color = alertTypes[type][3]
	end
	
	local messageWidth = math.max(dxGetTextWidth(msg, 0.85, Roboto14), dxGetTextWidth(msg2 or "", 0.85, Roboto14)) + 20
	local tileWidth = iconSize + messageWidth
	
	infobox.tileWidth = tileWidth
	infobox.tileHeight = math.max(dxGetFontHeight(0.85, Roboto14) * (msg2 and 2 or 1) + 10, respc(40))
	infobox.tilePosX = (screenX - tileWidth) / 2
	
	infobox.moveDownTick = getTickCount()
	infobox.moveUpTick = infobox.moveDownTick + 1000 + ((msg and utfLen(msg) or 0) + (msg2 and utfLen(msg2) or 0)) * 125
	
	infobox.state = true
	infobox.message = {msg, msg2}
	
	if alertTypes[type][4] then
		if (sound and isElement(sound)) then 
			destroyElement(sound)
			return
		end
		sound = playSound(alertTypes[type][4])
	end

	if msg2 then
	--outputConsole("[" .. alertTypes[type][1] .. "]: " .. msg .. ", " .. msg2)
	else
	--outputConsole("[" .. alertTypes[type][1] .. "]: " .. msg)
	end
	messageType = type
end
addEvent("showInfobox", true)
addEventHandler("showInfobox", root, showInfobox)

addEventHandler("onClientRender", getRootElement(),
	function ()
		if not infobox or not infobox.state then
			return
		end
		
		local tickCount = getTickCount()
		local x = infobox.tilePosX
		local y = -infobox.tileHeight
		local alpha = 0
		
		if tickCount >= infobox.moveDownTick and tickCount <= infobox.moveUpTick then
			alpha, y = interpolateBetween(0, -infobox.tileHeight, 0, 1, 50, 0, (tickCount - infobox.moveDownTick) / 500, "OutQuad")
		elseif tickCount >= infobox.moveUpTick then
			local progress = (tickCount - infobox.moveUpTick) / 500
			alpha, y = interpolateBetween(1, 50, 0, 0, -infobox.tileHeight, 0, progress, "OutQuad")
		
			if progress > 1 then
				infobox.state = false
			end
		end
		

		if (messageType == "success") then 
			dxDrawImage(screenW-1600/zoom, 0/zoom, 1353/zoom, 613/zoom, "files/images/success.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
		elseif (messageType == "error") then 
			dxDrawImage(screenW-1600/zoom, 0/zoom, 1353/zoom, 613/zoom, "files/images/error.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
		elseif (messageType == "warning") then 
			dxDrawImage(screenW-1600/zoom, 0/zoom, 1353/zoom, 613/zoom, "files/images/warning.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
		elseif (messageType == "info") then 
			dxDrawImage(screenW-1600/zoom, 0/zoom, 1353/zoom, 613/zoom, "files/images/info.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
		end



		-- ** töltő csík
		local progress = (tickCount - infobox.moveDownTick) / (infobox.moveUpTick - infobox.moveDownTick)

		if progress <= 1 then
		--dxDrawRectangle(x, y + infobox.tileHeight - 95, infobox.tileWidth * (0.7 - progress), 2, tocolor(infobox.color[1], infobox.color[2], infobox.color[3], 255 * alpha))
		end

		-- ** Content
		local iconSizeEx = iconSize * 0.75

		--dxDrawImage(math.floor(x + (infobox.tileHeight - iconSizeEx) / 2), math.floor(y + (infobox.tileHeight - iconSizeEx) / 2), iconSizeEx, iconSizeEx, infobox.icon, 0, 0, 0, tocolor(infobox.color[1], infobox.color[2], infobox.color[3], alpha * 255))
		
		if infobox.message[2] then
			dxDrawText(infobox.message[1] .. "\n" .. infobox.message[2], x + infobox.tileHeight, y, x + infobox.tileWidth, y + infobox.tileHeight, tocolor(255, 255, 255, alpha * 255), 0.5, Roboto14, "center", "center", true, false, false, true)
		else
			dxDrawText(infobox.message[1], x + infobox.tileHeight, y, x + infobox.tileWidth, y + infobox.tileHeight, tocolor(255, 255, 255, alpha * 255), 0.5, Roboto14, "center", "center", true, false, false, true)
		end
	end, true, "low-999999999"
)