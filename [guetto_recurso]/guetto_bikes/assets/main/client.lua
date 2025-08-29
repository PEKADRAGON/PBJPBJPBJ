local resource = {radius = {255, 0, 0}, state = false, tick = 0, moveY = {0, 0, 0}}

local function onDraw ()
	local alpha = interpolateBetween (resource.radius[1], 0, 0, resource.radius[2], 0, 0, (getTickCount ( ) - resource.radius[3])/400, "Linear")
	moveY = interpolateBetween (resource.moveY[1], 0, 0, resource.moveY[2], 0, 0, (getTickCount ( ) - resource.moveY[3])/300, "Linear")

	dxDrawImageSpacing(69, moveY, 787, 470, 5, "assets/images/background.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
	dxDrawText("ALUGUEL DE BICICLETAS", 130, moveY + 123 - 59, 232, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("medium", 14))
	dxDrawText("Escolha o modelo que mais te agrada", 130, moveY + 150 - 59, 299, 34, tocolor(108, 104, 119, alpha), 1.0, getFont("regular", 11))
	dxDrawText("e se locomova pela nossa cidade.", 130, moveY + 166 - 59, 299, 34, tocolor(108, 104, 119, alpha), 1.0, getFont("regular", 11))

	dxDrawImage(126, moveY + 207 - 59, 295, 75, "assets/images/bg_model.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
	dxDrawImage(126, moveY + 291 - 59, 295, 75, "assets/images/bg_model.png", 0, 0, 0, tocolor(255, 255, 255, alpha))

	dxDrawText("Modelo", 143, moveY + 223 - 59, 57, 15, tocolor(157, 157, 157, alpha), 1.0, getFont("regular", 11))
	dxDrawText(config.bikes[resource.select].title, 143, moveY + 246 - 59, 57, 15, tocolor(255, 255, 255, alpha), 1.0, getFont("bolditalic", 14))

	dxDrawText("Valor do aluguel", 143, moveY + 307 - 59, 57, 15, tocolor(157, 157, 157, alpha), 1.0, getFont("regular", 11))
	dxDrawText("$ "..convertNumber(config.bikes[resource.select].price).."", 143, moveY + 330 - 59, 57, 15, tocolor(255, 255, 255, alpha), 1.0, getFont("bolditalic", 14))

	dxDrawImage(454, moveY + 102 - 59, 402, 400, config.bikes[resource.select].directory, 0, 0, 0, tocolor(255, 255, 255, alpha))

	dxDrawImage(126, moveY + 468 - 59, 33, 34, "assets/images/description.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
	dxDrawText(config.others.description[1], 170, moveY + 466 - 59, 299, 34, tocolor(108, 104, 119, alpha), 1.0, getFont("regular", 11))
	dxDrawText(config.others.description[2], 170, moveY + 483 - 59, 299, 34, tocolor(108, 104, 119, alpha), 1.0, getFont("regular", 11))
	
	dxDrawImage(659, moveY + 407 - 59, 60, 60, "assets/images/prox.png", 0, 0, 0, (functions.isCursorOnElement(659, moveY + 407 - 59, 60, 60) and colorAnimation ("right", 1000, 113, 81, 147, alpha, alpha) or colorAnimation ("right", 1000, 90, 90, 90, alpha, alpha)))
	dxDrawImage(591, moveY + 407 - 59, 60, 60, "assets/images/prox.png", 180, 0, 0, (functions.isCursorOnElement(591, moveY + 407 - 59, 60, 60) and colorAnimation ("left", 1000, 113, 81, 147, alpha, alpha) or colorAnimation ("left", 1000, 90, 90, 90, alpha, alpha)))

	dxDrawImage(126, moveY + 384 - 59, 299, 60, "assets/images/button.png", 0, 0, 0, (functions.isCursorOnElement(126, moveY + 384 - 59, 299, 60) and colorAnimation ("button", 1000, 113, 81, 147, alpha, alpha) or colorAnimation ("button", 1000, 60, 60, 60, alpha, alpha)))
	dxDrawText("ALUGAR BIKE", 126, moveY + 387 - 59, 299, 60, tocolor(255, 255, 255, alpha), 1.0, getFont("medium", 13), "center", "center")
end

function bikeClose ()
	if (resource.state) then 

		resource.radius[1] = 255
		resource.radius[2] = 0
		resource.radius[3] = getTickCount ( )

		resource.moveY[1] = 59
		resource.moveY[2] = screenH + 10
		resource.moveY[3] = getTickCount ( )

		setTimer(function()

			showCursor(false)

			removeEventHandler("onClientRender", root, onDraw)

			resource.state = nil 

			resource.radius[1] = nil 
			resource.radius[2] = nil
			resource.radius[3] = nil

			resource.moveY[1] = nil
			resource.moveY[2] = nil
			resource.moveY[3] = nil

		end, 250, 1)
	end
end

local function bikeOpen (dados)
	if not (resource.state) then 

		resource.state = true 
		resource.select = 1

		resource.radius[1] = 0
		resource.radius[2] = 255
		resource.radius[3] = getTickCount ( )

		resource.moveY[1] = screenH + 10
		resource.moveY[2] = 59
		resource.moveY[3] = getTickCount ( )

		resource.tick = getTickCount()

		showCursor(true)
		addEventHandler("onClientRender", root, onDraw)
	else 
		bikeClose()
	end
end

local function onClientClick (button, state)
	if (resource.state and button == "left" and state == "down") then
		if functions.isCursorOnElement(659, moveY + 407 - 59, 60, 60) then 
			if resource.select < #config.bikes then 
				resource.select = resource.select + 1
			end
		elseif functions.isCursorOnElement(591, moveY + 407 - 59, 60, 60) then 
			if resource.select > 1 then
				resource.select = resource.select - 1
			end

		elseif functions.isCursorOnElement(126, moveY + 384 - 59, 299, 60) then 
			triggerServerEvent("squady.onPlayerBuyBike", resourceRoot, resource.select)
		end
	end
end

bindKey("backspace", "down", bikeClose)
addEventHandler("onClientClick", root, onClientClick)

registerEvent("squady.showBikePanel", resourceRoot, bikeOpen)
registerEvent("squady.hideBikePanel", resourceRoot, bikeClose)