local sx, sy = guiGetScreenSize ()

local px = sx/1920



local font1 = dxCreateFont ("files/tahoma.ttf", 16*px, true)

local font2 = dxCreateFont ("files/tahoma.ttf", 26*px, true)

local font3 = dxCreateFont ("files/tahoma.ttf", 14*px, true)

local font4 = dxCreateFont ("files/tahoma.ttf", 14*px, false)

local fontBig = dxCreateFont ("files/font.ttf", 28*px, false)

local fontSmall = dxCreateFont ("files/font.ttf", 15*px, false)



local colorTheme = tocolor(127, 252, 160, 0)--10, 173, 89



local count = 0

local toggle = true

local updateCountTimer = nil



local alpha = {

	[1] = 255,

	[2] = 0,

	[3] = 0,

	[4] = 0,

	[5] = 0,

	[6] = 0,

}



local ticks = {

	[1] = nil,

	[2] = nil,

	[3] = nil,

	[4] = nil,

	[5] = nil,

}



local daysTicks = {

	[1] = {

		tick = nil,

		alpha = 0,

		val = 0,

		val2 = 0,

	},

	[2] = {

		tick = nil,

		alpha = 0,

		val = 0,

		val2 = 0,

	},

	[3] = {

		tick = nil,

		alpha = 0,

		val = 0,

		val2 = 0,

	},

	[4] = {

		tick = nil,

		alpha = 0,

		val = 0,

		val2 = 0,

	},

	[5] = {

		tick = nil,

		alpha = 0,

		val = 0,

		val2 = 0,

	},

	[6] = {

		tick = nil,

		alpha = 0,

		val = 0,

		val2 = 0,

	},

	[7] = {

		tick = nil,

		alpha = 0,

		val = 0,

		val2 = 0,

	},

}



local countMyDays = 6



local function draw ()

	local startY = 960*px

	

	if toggle then

		local val1 = getEasingValue (math.min(1, (getTickCount() - ticks[1])/1000/2), "OutBack", _, _, 3)

		if val1 >= 1 then

			if not ticks[2] then

				ticks[2] = getTickCount()

			end

		end

		

		local val2 = 0

		local valAlpha = 0

		if ticks[2] then

			val2 = getEasingValue (math.min(1, (getTickCount() - ticks[2])/1000/1.5), "OutBounce", _, _, 3)

			valAlpha = getEasingValue (math.min(1, (getTickCount() - ticks[2])/1000/1.5), "InQuad")

			

			if math.min(1, (getTickCount() - ticks[2])/1000/1.5) == 1 then

				if not ticks[3] then

					ticks[3] = getTickCount()

					ticks[4] = getTickCount()

				end

			else

				alpha[2] = 255 * valAlpha

			end

		end

		

		if ticks[3] then

			val1 = 1 + 0.2*getEasingValue ((getTickCount() - ticks[3])/1000/1.5, "SineCurve")

		end

		

		local valAlpha2 = 0

		if ticks[4] then

			valAlpha2 = getEasingValue (math.min(1, (getTickCount() - ticks[4])/1000), "InQuad")

			if valAlpha2 >= 1 then

				if not daysTicks[1].tick then

					daysTicks[1].tick = getTickCount()

				end

			else

				alpha[3] = 255 * valAlpha2

			end

		end

			

		dxDrawImage (sx/2 - 64*px * val1, sy - startY - 64*px - 50*px * val1 + 50*px*val2, 128*px * val1, 128*px * val1, assets.light, getTickCount()/20, 0, 0, colorTheme + tocolor(0, 0, 0, alpha[1]))

		dxDrawImage (sx/2 - 40*px * val1, sy - startY - 40*px - 50*px * val1 - 23*px * (1 - val1) + 50*px*val2, 80*px * val1, 80*px * val1, assets.crystal, 0, 0, 0, tocolor(255, 255, 255, alpha[1]))



		startY = startY - 80*px



		local pix = 2*px



		local text01 = "Você vai cuidar de seus cristais!"



		dxCreateText (text01, 0-pix, sy - startY - pix, sx, 20*px, tocolor(0, 0, 0, alpha[2]*0.1), fontBig, "center", "center")

		dxCreateText (text01, 0+pix, sy - startY - pix, sx, 20*px, tocolor(0, 0, 0, alpha[2]*0.1), fontBig, "center", "center")

		dxCreateText (text01, 0-pix, sy - startY + pix, sx, 20*px, tocolor(0, 0, 0, alpha[2]*0.1), fontBig, "center", "center")

		dxCreateText (text01, 0+pix, sy - startY + pix, sx, 20*px, tocolor(0, 0, 0, alpha[2]*0.1), fontBig, "center", "center")



		dxCreateText (text01, 0, sy - startY, sx, 20*px, tocolor(255, 255, 255, alpha[2]), fontBig, "center", "center")



		startY = startY - 50*px



		local pix = 2*px



		-- iprint (getTickCount(), countMyDays, countMyDays and prices[countMyDays], countMyDays and (prices[countMyDays] and prices[countMyDays].money))

		local text01 = "Por completar uma tarefa diária\nvocê recebeu: "..ConvertNumber(prices[countMyDays].money).." ₽"



		dxCreateText (text01, 0-pix, sy - startY - pix, sx, 20*px, tocolor(0, 0, 0, alpha[2]*0.1), fontSmall, "center", "center")

		dxCreateText (text01, 0+pix, sy - startY - pix, sx, 20*px, tocolor(0, 0, 0, alpha[2]*0.1), fontSmall, "center", "center")

		dxCreateText (text01, 0-pix, sy - startY + pix, sx, 20*px, tocolor(0, 0, 0, alpha[2]*0.1), fontSmall, "center", "center")

		dxCreateText (text01, 0+pix, sy - startY + pix, sx, 20*px, tocolor(0, 0, 0, alpha[2]*0.1), fontSmall, "center", "center")



		dxCreateText (text01, 0, sy - startY, sx, 20*px, tocolor(255, 255, 255, alpha[2]), fontSmall, "center", "center")

		

		--[[startY = startY - 80*px

		

		dxCreateText ("ВСЕ ЛИСТЬЯ СОБРАНЫ", sx/2 - 200*px, sy - startY + 4*px, 400*px, 20*px, tocolor(0, 0, 0, 200 * (alpha[2]/255)), font2, "center", "center")

		dxCreateText ("ВСЕ ЛИСТЬЯ СОБРАНЫ", sx/2 - 200*px, sy - startY, 400*px, 20*px, colorTheme + tocolor(0, 0, 0, alpha[2]), font2, "center", "center")

		

		startY = startY - 40*px

		

		dxCreateText ("ЕЖЕДНЕВНОЕ ЗАДАНИЕ ВЫПОЛНЕНО", sx/2 - 200*px, sy - startY + 4*px, 400*px, 20*px, tocolor(0, 0, 0, 200 * (alpha[3]/255)), font1, "center", "center")

		dxCreateText ("ЕЖЕДНЕВНОЕ ЗАДАНИЕ ВЫПОЛНЕНО", sx/2 - 200*px, sy - startY, 400*px, 20*px, colorTheme + tocolor(0, 0, 0, alpha[3]), font1, "center", "center")

		

		startY = startY - 120*px

		

		local startPos = sx/2 - 64*px * (countMyDays)

		for k = 1, countMyDays do

			local offsetX = (130*px)*(k-1)

		

			if daysTicks[k].tick then

				daysTicks[k].val = getEasingValue (math.min(1, (getTickCount() - daysTicks[k].tick)/300), "InQuad")

				

				if daysTicks[k].val >= 1 then

					if k + 1 <= countMyDays then

						if not daysTicks[k + 1].tick then

							daysTicks[k + 1].tick = getTickCount()

						end

					end

					

					if k == countMyDays then

						if daysTicks[countMyDays-1] then

							if getTickCount() - daysTicks[countMyDays-1].tick > 1000 then

								if not daysTicks[k].tick2 then

									daysTicks[k].tick2 = getTickCount()

								end

								daysTicks[k].val2 = getEasingValue ((getTickCount() - daysTicks[k].tick2)/1000/1.2, "SineCurve")

								

								if (getTickCount() - daysTicks[k].tick2) > 1000 then

									if not ticks[5] then

										ticks[5] = getTickCount()

									end

								end

							end

						else

							if getTickCount() - (daysTicks[countMyDays].tick + 1000) > 1000 then

								if not daysTicks[k].tick2 then

									daysTicks[k].tick2 = getTickCount()

								end

								daysTicks[k].val2 = getEasingValue ((getTickCount() - daysTicks[k].tick2)/1000/1.2, "SineCurve")

								

								if (getTickCount() - daysTicks[k].tick2) > 1000 then

									if not ticks[5] then

										ticks[5] = getTickCount()

									end

								end

							end

						end

					end

				end

				daysTicks[k].alpha = 255 * daysTicks[k].val

			end

			if k == countMyDays then

				dxDrawImage (

					startPos + offsetX - 26*px*(daysTicks[k].val) - (10*px*daysTicks[k].val2), 

					sy - startY - 90*px + 180*px*(1-daysTicks[k].val) - 26*px*(1-daysTicks[k].val) - (10*px*daysTicks[k].val2), 

					180*px*daysTicks[k].val + (20*px*daysTicks[k].val2), 

					180*px*daysTicks[k].val + (20*px*daysTicks[k].val2), 

					

					assets.light, getTickCount()/20, 0, 0, tocolor(255, 255, 255, daysTicks[k].alpha))

			end

			dxDrawImage (

				startPos + offsetX - (10*px*daysTicks[k].val2), 

				sy - startY - 64*px + 128*px*(1-daysTicks[k].val) - (10*px*daysTicks[k].val2), 

				128*px*daysTicks[k].val + (20*px*daysTicks[k].val2), 

				128*px*daysTicks[k].val + (20*px*daysTicks[k].val2), 

				

				assets.day, 0, 0, 0, tocolor(255, 255, 255, daysTicks[k].alpha))

				

			dxCreateText ("День\n"..k, 

				startPos + offsetX, 

				sy - startY - 64*px + 128*px*(1-daysTicks[k].val), 

				128*px*daysTicks[k].val, 

				128*px*daysTicks[k].val, tocolor(255, 255, 255, daysTicks[k].alpha), k == countMyDays and font1 or font3, "center", "center", false, false, daysTicks[k].tick2 and (1 + (0.2 * daysTicks[k].val2)) or daysTicks[k].val)

		end

		

		startY = startY - 130*px

		

		local valAlpha3 = 0

		if ticks[5] then

			valAlpha3 = getEasingValue (math.min(1, (getTickCount() - ticks[5])/1000), "InQuad")

			if valAlpha3 >= 1 then

				if not ticks[6] then

					ticks[6] = getTickCount()

				end

			else

				alpha[4] = 255 * valAlpha3

			end

		end

		

		dxCreateText ("НАГРАДА", sx/2 - 200*px, sy - startY + 4*px, 400*px, 20*px, tocolor(0, 0, 0, 200 * (alpha[4]/255)), font1, "center", "center")

		dxCreateText ("НАГРАДА", sx/2 - 200*px, sy - startY, 400*px, 20*px, colorTheme + tocolor(0, 0, 0, alpha[4]), font1, "center", "center")

		

		startY = startY - 40*px

		

		local valAlpha4 = 0

		if ticks[6] then

			valAlpha4 = getEasingValue (math.min(1, (getTickCount() - ticks[6])/1000), "InQuad")

			if valAlpha4 >= 1 then

				if not ticks[7] then

					ticks[7] = getTickCount()

				end

			else

				alpha[5] = 255 * valAlpha4

			end

		end]]

		

--		dxCreateText ("Деньги: "..(prices[countMyDays].money).." руб.", sx/2 - 200*px - (100*px * (1-valAlpha4)), sy - startY + 2*px, 400*px, 20*px, tocolor(0, 0, 0, 200 * (alpha[5]/255)), font4, "center", "center")

		--dxCreateText ("Деньги: "..(prices[countMyDays].money).." руб.", sx/2 - 200*px - (100*px * (1-valAlpha4)), sy - startY, 400*px, 20*px, colorTheme + tocolor(0, 0, 0, alpha[5]), font4, "center", "center")

	

		if ticks[4] then

			if getTickCount() - ticks[4] > 3000 then

				toggle = false

			end

		end

	else

		local val = math.min(1, getEasingValue ((getTickCount() - (ticks[4]+3000))/1000, "InQuad"))

		

		for k, v in pairs (alpha) do

			alpha[k] = 255 - 255*val

		end

		for k, v in pairs (daysTicks) do

			daysTicks[k].alpha = 255 - 255*val

		end

		

		if alpha[1] == 0 then

			removeEventHandler("onClientRender", root, draw)

			return

		end

		

		local val1 = 1

		local val2 = 1

		local valAlpha4 = 1

		

		if ticks[3] then

			val1 = 1 + 0.2*getEasingValue ((getTickCount() - ticks[3])/1000/1.5, "SineCurve")

		end

			

		dxDrawImage (sx/2 - 64*px * val1, sy - startY - 64*px - 50*px * val1 + 50*px*val2, 128*px * val1, 128*px * val1, assets.light, getTickCount()/20, 0, 0, colorTheme + tocolor(0, 0, 0, alpha[1]))

		dxDrawImage (sx/2 - 40*px * val1, sy - startY - 40*px - 50*px * val1 - 23*px * (1 - val1) + 50*px*val2, 80*px * val1, 80*px * val1, assets.crystal, 0, 0, 0, tocolor(255, 255, 255, alpha[1]))



		startY = startY - 80*px



		local pix = 2*px



		local text01 = "Você coletou todos os cristais!"



		dxCreateText (text01, 0-pix, sy - startY - pix, sx, 20*px, tocolor(0, 0, 0, alpha[2]*0.1), fontBig, "center", "center")

		dxCreateText (text01, 0+pix, sy - startY - pix, sx, 20*px, tocolor(0, 0, 0, alpha[2]*0.1), fontBig, "center", "center")

		dxCreateText (text01, 0-pix, sy - startY + pix, sx, 20*px, tocolor(0, 0, 0, alpha[2]*0.1), fontBig, "center", "center")

		dxCreateText (text01, 0+pix, sy - startY + pix, sx, 20*px, tocolor(0, 0, 0, alpha[2]*0.1), fontBig, "center", "center")



		dxCreateText (text01, 0, sy - startY, sx, 20*px, tocolor(255, 255, 255, alpha[2]), fontBig, "center", "center")



		startY = startY - 50*px



		local pix = 2*px



		-- iprint (getTickCount(), countMyDays, countMyDays and prices[countMyDays], countMyDays and (prices[countMyDays] and prices[countMyDays].money))

		local text01 = "Por completar uma tarefa diária\nvocê recebeu: "..ConvertNumber(prices[countMyDays].money).." $"



		dxCreateText (text01, 0-pix, sy - startY - pix, sx, 20*px, tocolor(0, 0, 0, alpha[2]*0.1), fontSmall, "center", "center")

		dxCreateText (text01, 0+pix, sy - startY - pix, sx, 20*px, tocolor(0, 0, 0, alpha[2]*0.1), fontSmall, "center", "center")

		dxCreateText (text01, 0-pix, sy - startY + pix, sx, 20*px, tocolor(0, 0, 0, alpha[2]*0.1), fontSmall, "center", "center")

		dxCreateText (text01, 0+pix, sy - startY + pix, sx, 20*px, tocolor(0, 0, 0, alpha[2]*0.1), fontSmall, "center", "center")



		dxCreateText (text01, 0, sy - startY, sx, 20*px, tocolor(255, 255, 255, alpha[2]), fontSmall, "center", "center")

		

		--[[startY = startY - 80*px

		

		dxCreateText ("ВСЕ ЛИСТЬЯ СОБРАНЫ", sx/2 - 200*px, sy - startY + 4*px, 400*px, 20*px, tocolor(0, 0, 0, 200 * (alpha[2]/255)), font2, "center", "center")

		dxCreateText ("ВСЕ ЛИСТЬЯ СОБРАНЫ", sx/2 - 200*px, sy - startY, 400*px, 20*px, colorTheme + tocolor(0, 0, 0, alpha[2]), font2, "center", "center")

		

		startY = startY - 40*px

		

		dxCreateText ("ЕЖЕДНЕВНОЕ ЗАДАНИЕ ВЫПОЛНЕНО", sx/2 - 200*px, sy - startY + 4*px, 400*px, 20*px, tocolor(0, 0, 0, 200 * (alpha[3]/255)), font1, "center", "center")

		dxCreateText ("ЕЖЕДНЕВНОЕ ЗАДАНИЕ ВЫПОЛНЕНО", sx/2 - 200*px, sy - startY, 400*px, 20*px, colorTheme + tocolor(0, 0, 0, alpha[3]), font1, "center", "center")

		

		startY = startY - 120*px

		

		local startPos = sx/2 - 64*px * (countMyDays)

		for k = 1, countMyDays do

			local offsetX = (130*px)*(k-1)

		

			if daysTicks[k].tick then

				daysTicks[k].val = getEasingValue (math.min(1, (getTickCount() - daysTicks[k].tick)/300), "InQuad")

				

				if daysTicks[k].val >= 1 then

					if k + 1 <= countMyDays then

						if not daysTicks[k + 1].tick then

							daysTicks[k + 1].tick = getTickCount()

						end

					end

					

					if k == countMyDays then

						if daysTicks[countMyDays-1] then

							if getTickCount() - daysTicks[countMyDays-1].tick > 1000 then

								if not daysTicks[k].tick2 then

									daysTicks[k].tick2 = getTickCount()

								end

								daysTicks[k].val2 = getEasingValue ((getTickCount() - daysTicks[k].tick2)/1000/1.2, "SineCurve")

								

								if (getTickCount() - daysTicks[k].tick2) > 1000 then

									if not ticks[5] then

										ticks[5] = getTickCount()

									end

								end

							end

						else

							if getTickCount() - (daysTicks[countMyDays].tick + 1000) > 1000 then

								if not daysTicks[k].tick2 then

									daysTicks[k].tick2 = getTickCount()

								end

								daysTicks[k].val2 = getEasingValue ((getTickCount() - daysTicks[k].tick2)/1000/1.2, "SineCurve")

								

								if (getTickCount() - daysTicks[k].tick2) > 1000 then

									if not ticks[5] then

										ticks[5] = getTickCount()

									end

								end

							end

						end

					end

				end

				

				if toggle and daysTicks[k].alpha ~= 255 then

					daysTicks[k].alpha = 255 * daysTicks[k].val

				end

			end

			if k == countMyDays then

				dxDrawImage (

					startPos + offsetX - 26*px*(daysTicks[k].val) - (10*px*daysTicks[k].val2), 

					sy - startY - 90*px + 180*px*(1-daysTicks[k].val) - 26*px*(1-daysTicks[k].val) - (10*px*daysTicks[k].val2), 

					180*px*daysTicks[k].val + (20*px*daysTicks[k].val2), 

					180*px*daysTicks[k].val + (20*px*daysTicks[k].val2), 

					

					assets.light, getTickCount()/20, 0, 0, tocolor(255, 255, 255, daysTicks[k].alpha))

			end

			dxDrawImage (

				startPos + offsetX - (10*px*daysTicks[k].val2), 

				sy - startY - 64*px + 128*px*(1-daysTicks[k].val) - (10*px*daysTicks[k].val2), 

				128*px*daysTicks[k].val + (20*px*daysTicks[k].val2), 

				128*px*daysTicks[k].val + (20*px*daysTicks[k].val2), 

				

				assets.day, 0, 0, 0, tocolor(255, 255, 255, daysTicks[k].alpha))

				

			dxCreateText ("День\n"..k, 

				startPos + offsetX, 

				sy - startY - 64*px + 128*px*(1-daysTicks[k].val), 

				128*px*daysTicks[k].val, 

				128*px*daysTicks[k].val, tocolor(255, 255, 255, daysTicks[k].alpha), k == countMyDays and font1 or font3, "center", "center", false, false, daysTicks[k].tick2 and (1 + (0.2 * daysTicks[k].val2)) or daysTicks[k].val)

		end

		

		startY = startY - 130*px

		

		dxCreateText ("НАГРАДА", sx/2 - 200*px, sy - startY + 4*px, 400*px, 20*px, tocolor(0, 0, 0, 200 * (alpha[4]/255)), font1, "center", "center")

		dxCreateText ("НАГРАДА", sx/2 - 200*px, sy - startY, 400*px, 20*px, colorTheme + tocolor(0, 0, 0, alpha[4]), font1, "center", "center")

		

		startY = startY - 40*px

		

		dxCreateText ("Деньги: "..prices[countMyDays].money.." руб.", sx/2 - 200*px - (100*px * (1-valAlpha4)), sy - startY + 2*px, 400*px, 20*px, tocolor(0, 0, 0, 200 * (alpha[5]/255)), font4, "center", "center")

		dxCreateText ("Деньги: "..prices[countMyDays].money.." руб.", sx/2 - 200*px - (100*px * (1-valAlpha4)), sy - startY, 400*px, 20*px, colorTheme + tocolor(0, 0, 0, alpha[5]), font4, "center", "center")]]



	end

end

function ConvertNumber(number)

	local formatted = number   

	while true do       

		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", "%1 %2")     

		if (k == 0) then       

			break   

		end

	end   

	return formatted 

end

function collectLastCrystal ()

	count = 0

	toggle = true

	

	countMyDays = localPlayer:getData ("crystal:collectedDays") or 1

	-- source.account:setData ("crystal:collected", 9)

	ticks[1] = getTickCount()

	ticks[2] = nil

	ticks[3] = nil

	ticks[4] = nil

	ticks[5] = nil



	alpha[1] = 255

	alpha[2] = 0

	alpha[3] = 0

	alpha[4] = 0

	alpha[5] = 0

	alpha[6] = 0

	

	addEventHandler("onClientRender", root, draw)

	playSound("files/finish.mp3")

end



--addCommandHandler ( "ld", collectLastCrystal )