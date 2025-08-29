local sx, sy = guiGetScreenSize ()
local px = sx/1920

assets = {
	crystal = dxCreateTexture ("files/Crystal.png"),
	back = dxCreateTexture ("files/diamonds_back.png"),
	front = dxCreateTexture ("files/diamonds_front.png"),
	blik = dxCreateTexture ("files/blik.png"),
	light_blik = dxCreateTexture ("files/light_blik.png"),
	light = dxCreateTexture ("files/diamond_light.png"),
	day = dxCreateTexture ("files/day_background.png"),
}

local font1 = dxCreateFont ("files/OpenSans-Regular.ttf", 11*px, true)
local font2 = dxCreateFont ("files/OpenSans-Regular.ttf", 13*px, true)

local colorTheme = tocolor(127, 252, 160, 0)--10, 173, 89

local count = 0
local toggle = true
local updateCountTimer = nil

local alpha = {
	[1] = 0,
	[2] = 0,
	[3] = 0,
}

local ticks = {
	[1] = nil,
	[2] = nil,
	[3] = nil,
	[4] = nil,
}

local startY = sy-40*px

local function draw ()
	if toggle then
		local val1 = math.min (1, getEasingValue ((getTickCount() - ticks[1])/1000/1, "InQuad"))
		if val1 >= 1 then
			if not ticks[2] then
				ticks[2] = getTickCount()
			end
		else
			alpha[1] = 255 * val1
			alpha[4] = alpha[1]
		end
		
		if ticks[2] then
			local val2 = math.min (1, getEasingValue ((getTickCount() - ticks[2])/1000/0.7, "InQuad"))
			if val2 >= 1 then
				if not ticks[3] then
					ticks[3] = getTickCount()
				end
			else
				alpha[2] = 255 * val2
				alpha[5] = alpha[2]
				if alpha[5]>= 245 then
					alpha[5] = 255
				end
			end
		end
		
		if ticks[3] then
			local val3 = math.min (1, getEasingValue ((getTickCount() - ticks[3])/1000/0.6, "InQuad"))
			if val3 >= 1 then
				if not isTimer (updateCountTimer) then
					updateCountTimer = setTimer (updateCount, 200, 0)
				end
			else
				alpha[3] = 255 * val3
			end
		end
	else
		local val4 = 1 - math.min (1, getEasingValue ((getTickCount() - ticks[4])/1000, "InQuad"))
		alpha[1] = 255 * val4
		alpha[2] = 255 * val4
		alpha[3] = 255 * val4
		alpha[4] = 255
		alpha[5] = 255
		
		if alpha[1] <= 0 then
			for i = 1, 4 do
				ticks[i] = nil
			end
			
			removeEventHandler("onClientRender", root, draw)
			return
		end
	end

	dxDrawImage (sx/2 - 1798/2*px, 0, 1798*px, 457*px, assets.light_blik, 0, 0, 0, tocolor(255, 255, 255, alpha[1]*0.8))
	
	dxDrawImage (sx/2 - 125*px, sy - startY - 125*px + (alpha[4]/255)^(1/15)*50*px, 250*px, 250*px, assets.light, getTickCount()/20, 0, 0, colorTheme + tocolor(0, 0, 0, alpha[1]*0.4))
	dxDrawImage (sx/2 - 125*px, sy - startY - 125*px + (alpha[4]/255)^(1/15)*50*px, 250*px, 250*px, assets.light, getTickCount()/-20, 0, 0, colorTheme + tocolor(0, 0, 0, alpha[1]*0.4))

	dxDrawImage (sx/2 - 125*px, sy - startY - 125*px + (alpha[4]/255)^(1/15)*50*px, 250*px, 250*px, assets.light, getTickCount()/20, 0, 0, tocolor(255, 255, 255, alpha[1]*0.1))
	dxDrawImage (sx/2 - 125*px, sy - startY - 125*px + (alpha[4]/255)^(1/15)*50*px, 250*px, 250*px, assets.light, getTickCount()/-20, 0, 0, tocolor(255, 255, 255, alpha[1]*0.1))

	dxDrawImage (sx/2 - 75*px, sy - startY - 44*px + (alpha[4]/255)^(1/15)*50*px, 150*px, 88*px, assets.back, 0, 0, 0, tocolor(255, 255, 255, alpha[1]))
	dxDrawImage (sx/2 - 75*px, sy - startY - 44*px + (alpha[4]/255)^(1/15)*50*px, 150*px, 88*px, assets.front, 0, 0, 0, tocolor(255, 255, 255, alpha[1]))

	dxCreateRect (sx/2 - 25*px - ((alpha[5] or 0)/255)*60*px, sy - startY  + 125*px, 50*px + ((alpha[5] or 0)/255)*120*px, 40*px, alpha[2], "Вы нашли кристалл", font1)
	
	--dxCreateText ("ЕЖЕДНЕВНЫЙ ПОИСК ИГРУШЕК", sx/2 - 200*px, sy - startY + 50*px + 4*px, 400*px, 20*px, tocolor(0, 0, 0, alpha[2]), font1, "center", "center")
	--dxCreateText ("ЕЖЕДНЕВНЫЙ ПОИСК ИГРУШЕК", sx/2 - 200*px, sy - startY + 50*px, 400*px, 20*px, colorTheme + tocolor(0, 0, 0, alpha[2]), font1, "center", "center")
	
	--dxCreateText ("ВЫ СОБРАЛИ "..count.." ИЗ "..Config.maxCristall, sx/2 - 200*px, sy - startY + 90*px + 4*px, 400*px, 20*px, tocolor(0, 0, 0, alpha[3]), font2, "center", "center")
	dxCreateText (""..(localPlayer:getData ("crystal:collected") or 5).." / "..Config.maxCristall, sx/2 - 200*px, sy - startY + 180*px, 400*px, 20*px, tocolor(255, 255, 255, alpha[3]), font2, "center", "center")
end

function updateCount()
	if count + 1 <= (localPlayer:getData ("crystal:collected") or 5) then
		count = count + 1
	else
		killTimer (sourceTimer)
		
		setTimer (function()
			ticks[4] = getTickCount()
			toggle = false 
		end, 1000, 1)
	end
end

function collectCrystal ()
	count = 0
	toggle = true
	ticks[1] = getTickCount()
	setElementData ( localPlayer, "crystalInfo", "open" )
	setTimer ( function()
		setElementData ( localPlayer, "crystalInfo", "close" )
	end, 3000, 1 )
	
	addEventHandler("onClientRender", root, draw)
end

--collectCrystal()

function dxCreateText (text, x, y, w, h, color, font, left, top, colored, border, scale)
	if border then
		dxDrawText (text, x-1, y-1, x + w, y + h, tocolor(0,0,0), scale or 1, font, left, top, _, _, _, colored or false)
		dxDrawText (text, x+1, y+1, x + w, y + h, tocolor(0,0,0), scale or 1, font, left, top, _, _, _, colored or false)
		
		dxDrawText (text, x-1, y+1, x + w, y + h, tocolor(0,0,0), scale or 1, font, left, top, _, _, _, colored or false)
		dxDrawText (text, x+1, y-1, x + w, y + h, tocolor(0,0,0), scale or 1, font, left, top, _, _, _, colored or false)
	end
	dxDrawText (text, x, y, x + w, y + h, color, scale or 1, font, left, top, _, _, _, colored or false)
end

function dxText(x, y, w, h, text)
	dxDrawText(text, x, y, w + x, h + y, tcolor, 1, font2, "center", "top", false, true, false, false, false)
end

function dxCreateRect (x, y, w, h, alpha, text, font)
	local bgcolor = tocolor(26, 26, 26, alpha*0.7 or 255*0.7)
	local tcolor = tocolor(255, 255, 255, alpha or 255)
	dxDrawRectangle(x, y, w, h, bgcolor, false)
	dxDrawRectangle(x, y+h-2.5, w, 0.5, tocolor(127, 252, 160, alpha or 255), false)
	dxDrawRectangle(x+2.5, y, 0.5, h, tocolor(127, 252, 160, alpha or 255), false)
	dxDrawRectangle(x, y+h-5*px, 5*px, 5*px, tocolor(127, 252, 160, alpha or 255), false)
	dxDrawRectangle(x+w-5*px, y, 5*px, 5*px, tocolor(127, 252, 160, alpha or 255), false)
	dxDrawText(text, x, y, w + x, h - 3*px + y, tcolor, 1, font, "center", "center", true, false, false, false, false)
end