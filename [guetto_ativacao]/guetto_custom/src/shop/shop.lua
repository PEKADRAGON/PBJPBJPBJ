local selecionado = 0

local tempo = 0;

local row = 0;
local visibled = 14;

local painelX, painelY = 0, 0
local pngLoja = 125

local bxcategoria = 110
local bycategoria = 40
local margingrid = 40

local ycarrinho = 170
local yseparador = 50

function createShops()
	for id, v in ipairs(lojas["Lojas"]["pos"]) do 
		local marker = createMarker(v[1], v[2], v[3] - 0.9, "cylinder", 2, 107, 201, 48, 0)
		setElementData(marker , 'markerData', {title = 'Loja de roupas', desc = 'Fique mais estiloso!', icon = 'clothes'})
		createBlipAttachedTo(marker, 45)
		
		addEventHandler("onClientMarkerHit", marker, function(plr, md)
			if plr == localPlayer and md then
			if not canUseShop() then return end
				sendMessageClient("Aperte 'e' para entrar", "info")
				bindKey("e","down", openShop, source, v[4], id)
			end
		end)

		addEventHandler("onClientMarkerLeave", marker, function(plr, md)
			if plr == localPlayer and md then
				unbindKey("e","down", openShop)
			end
		end)
	end
end

function openShop(btn, state, marker, type, id)
	if not canUseShop() or not isElementWithinMarker(localPlayer, marker) then return end

	unbindKey("e", "down", openShop)

	window = 'camisas'
	select = 0;
	cart = {}
	price = 0;

	addEventHandler("onClientPlayerWasted", localPlayer, onDeadShop)

	local genre = getElementData(localPlayer,"characterGenre")
	loja = type
	carrinho = {}
	aba = "camisas"
	preco = 0
	selecionado = 0
	scrollPage = 0;

	local x,y,z = getElementPosition(localPlayer)
	setElementData(localPlayer, "characterQuit", {x,y,z,0,0})

	showChat(false)

	setElementFrozen(localPlayer, true)
	toggleAllControls(false)

	preview = createCustomPed(unpack(lojas["Lojas"]["spawn"].posped))
	setElementDimension(preview, getElementData(localPlayer, "ID"))
	setElementInterior(preview, lojas["Lojas"]["spawn"].interior)
	setElementRotation(preview, 0, 0, lojas["Lojas"]["spawn"].rot)

	setElementInterior(localPlayer, lojas["Lojas"]["spawn"].interior)
	setElementPosition(localPlayer, unpack(lojas["Lojas"]["spawn"].posplayer))
	setElementDimension(localPlayer, getElementData(localPlayer, "ID"))

	addEventHandler("onClientRender", root, renderShop)
	addEventHandler("onClientClick", root, shopClick)
	addEventHandler("onClientKey", root, shopKey)

	setTargetElement(preview)
	setFreelookEvents(true,1)
end

function exitShop()
    setCameraTarget(localPlayer)
    setElementFrozen(localPlayer, false)
    toggleAllControls(true)

    --setElementAlpha(localPlayer, 255)
    setElementInterior(localPlayer, 0)
    setElementDimension(localPlayer, 0)

	showChat(true)

	local respawn = getElementData(localPlayer, "characterQuit")
    setElementPosition(localPlayer, respawn[1], respawn[2], respawn[3])
	setElementData(localPlayer, "characterQuit", false)

	reloadCharacter(localPlayer, 900)
end

function closeShop()
	loja = false
	preco = 0
	carrinho = {}

	removeEventHandler("onClientPlayerWasted", localPlayer, onDeadShop)

	removeEventHandler("onClientRender", root, renderShop)
	removeEventHandler("onClientClick", root, shopClick)
	removeEventHandler("onClientKey", root, shopKey)
	
	exitShop()

	if preview then
		destroyElement(preview);
		unloadCharacter(preview);
	end
end

local svgs = {
	['background'] = svgCreate(383, 635, [[
		<svg width="383" height="635" viewBox="0 0 383 635" fill="none" xmlns="http://www.w3.org/2000/svg">
			<rect width="383" height="635" rx="10" fill="#0D0E0F" fill-opacity="0.93"/>
		</svg>
	]]);

	['rectangle-border'] =  svgCreate(193, 2, [[
		<svg width="193" height="2" viewBox="0 0 193 2" fill="none" xmlns="http://www.w3.org/2000/svg">
			<rect width="193" height="2" rx="1" fill="white"/>
		</svg>
	]]);

	['rectangle-slot'] = svgCreate(382, 64, [[
		<svg width="382" height="36" viewBox="0 0 382 36" fill="none" xmlns="http://www.w3.org/2000/svg">
			<rect width="382" height="36" fill="white"/>
		</svg>	
	]]);

	['rectangle-window'] = svgCreate(87, 43, [[
		<svg width="87" height="43" viewBox="0 0 87 43" fill="none" xmlns="http://www.w3.org/2000/svg">
			<rect width="87" height="43" rx="4" fill="white"/>
		</svg>
	]]);

}

local loja = 'suburban'
local default_text = 'Nenhuma descrição encontrada'

local slots = {
	{32, 185, 382, 36};
	{32, 221, 382, 36};
	{32, 257, 382, 36};
	{32, 293, 382, 36};
	{32, 329, 382, 36};
	{32, 365, 382, 36};
	{32, 401, 382, 36};
	{32, 437, 382, 36};
	{32, 473, 382, 36};
	{32, 509, 382, 36};
	{32, 545, 382, 36};
	{32, 581, 382, 36};
	{32, 617, 382, 36};
	{32, 653, 382, 36};
	{32, 689, 382, 36};
	{32, 725, 382, 36};
}

local windows = {
	{426, 161, 87, 43, "camisas", "Torso A"};
	{426, 210, 87, 43, "casacos", "Torso B"};
	{426, 259, 87, 43, "calcas", "Pernas"};
	{426, 308, 87, 43, "tenis", "Pé"};
}

local slots_carts = {
	{44, 857, 83, 14};
	{44, 893, 83, 14};
	{44, 929, 83, 14};
	{44, 965, 83, 14};
	{44, 1001, 83, 14};
}


function renderShop()
	if not loja then return end
	
	dxDrawImage(32, 161, 383, 611, "assets/images/background.png", 0, 0, 0, tocolor(255, 255, 255, 255))

	dxDrawImage(127, 174, 193, 2, svgs['rectangle-border'], 0, 0, 0, tocolor(53, 57, 63, 255))
	
	dxDrawText(string.upper(loja), 33, 90, 135, 30, tocolor(255, 255, 255, 255), 1, exports['guetto_assets']:dxCreateFont('bold', 25), 'left', 'top')
	dxDrawText(lojas[string.lower(loja)]['text'] or default_text, 33, 119, 332, 18, tocolor(188, 184, 184, 255), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'left', 'top')
	
	for i, v in ipairs(windows) do 
		local x, y, w, h = v[1], v[2], v[3], v[4]
		dxDrawImage(x, y, w, h, svgs['rectangle-window'], 0, 0, 0, window == v[5] and tocolor(49, 50, 51, 0.93 * 255) or isCursorOnElement(x, y, w, h) and tocolor(49, 50, 51, 0.93 * 255) or tocolor(13, 14, 15, 0.93 * 255))
		dxDrawText(string.upper(v[5]), x, y, w, h, tocolor(255, 255, 255, 255), 1, exports['guetto_assets']:dxCreateFont('regular', 14), 'center', 'center')
	end
		
	local plrData = getElementData(localPlayer, "characterData")
	local character = getElementData(localPlayer, "characterClothes")
	local gender = getElementData(localPlayer,"characterGenre")

	for i, v in ipairs (slots) do 
		local x, y, w, h = v[1], v[2], v[3], v[4]
		local index = i + scrollPage

		if lojas[string.lower(loja)][gender][window][index] then
			dxDrawImage(x, y, w, h, svgs['rectangle-slot'], 0, 0, 0, select == lojas[string.lower(loja)][gender][window][index][1] and tocolor(193, 159, 114, 255) or isCursorOnElement(x, y, w, h) and tocolor(193, 159, 114, 255) or tocolor(55, 55, 55, 0.12 * 255))
			
			if character[gender][window] == index then
				dxDrawText(lojas[loja][gender][window][index][1], x + 11, y + 11, 78, 36, tocolor(255, 255, 255, 255), 1, exports['guetto_assets']:dxCreateFont('regular', 12), "left", "center", false, false, false, false, false)
			else
				dxDrawText(lojas[loja][gender][window][index][1], x + 11, y, 78, h, tocolor(255, 255, 255, 255), 1, exports['guetto_assets']:dxCreateFont('regular', 12), "left", "center", false, false, false, false, false)
			end

			dxDrawText("R$ "..lojas[loja][gender][window][index][2], x + 329, y, 37, h, tocolor(255, 255, 255, 255), 1, exports['guetto_assets']:dxCreateFont('regular', 12), "right", "center", false, false, false, false, false)
		end

	end

	dxDrawImage(
		32, 803, 383, 235, 'assets/images/cart-background.png', 0, 0, 0, tocolor(255, 255, 255, 255)
	)	

	dxDrawText(
		'CARRINHO DE COMPRAS', 50, 821, 134, 14, tocolor(255, 255, 255, 255), 1, exports['guetto_assets']:dxCreateFont('regular', 14), 'left', 'top'
	)

	dxDrawText(
		'TOTAL:', 278, 821, 134, 14, tocolor(255, 255, 255, 255), 1, exports['guetto_assets']:dxCreateFont('regular', 14), 'left', 'top'
	)

	dxDrawText(
		'R$ '..formatNumber(getTotalPriceCart(), '.'), 327, 821, 66, 14, tocolor(255, 255, 255, 255), 1, exports['guetto_assets']:dxCreateFont('regular', 14), 'right', 'top'
	)

	dxDrawImage(
		1458, 968, 443, 71, "assets/images/faixa.png", 0, 0, 0, tocolor(255, 255, 255, 255)
	)

	local line = 0
	for i, v in pairs (cart) do 
		line = line + 1
		if slots_carts[line] then 
			dxDrawText(v[3], slots_carts[line][1], slots_carts[line][2], slots_carts[line][3], slots_carts[line][4], tocolor(255, 255, 255, 255), 1, exports['guetto_assets']:dxCreateFont('regular', 14), 'left', 'center')
			dxDrawText('R$ '..v[4], slots_carts[line][1] + 227, slots_carts[line][2], slots_carts[line][3], slots_carts[line][4], tocolor(255, 255, 255, 255), 1, exports['guetto_assets']:dxCreateFont('regular', 14), 'left', 'center')
		end
	end

end

addEvent("paymentClothes", true)
addEventHandler("paymentClothes", root, function(state)
	if state then
		sendMessageClient("Você comprou novas roupas.", "success")
		closeShop()
		setElementFrozen(localPlayer, false)
		toggleAllControls(true)
		setFreelookEvents(false)
		setCameraTarget(localPlayer)  
	else
		sendMessageClient("Compra cancelada.", "error")
	end
end)

function shopKey(button,press)
	
	if not press then
		return 
	end


	if (button == "backspace") then 
		closeShop()
		setElementFrozen(localPlayer, false)

		toggleAllControls(true)
		setFreelookEvents(false)

		setCameraTarget(localPlayer)  
	elseif (button == "enter") then 
		payShop()
	elseif (button == "mouse_wheel_down" and press) then 
		local gender = getElementData(localPlayer,"characterGenre")
		if isCursorOnElement(32, 161, 383, 611) then 
			if lojas[string.lower(loja)][gender][window] then
				local totalWindows = #lojas[string.lower(loja)][gender][window]
				local windowsPerPage = 16
				if totalWindows > windowsPerPage + scrollPage then
					scrollPage = scrollPage + 1
				end
			end
		end
	elseif (button == "mouse_wheel_up" and press) then 
		if isCursorOnElement(32, 161, 383, 611) then 
			if scrollPage > 0 then 
				scrollPage = scrollPage - 1
			end
		end
	end
end



function shopClick (button, state)
	if button == "left" and state == "down" then 
		local character = getElementData(localPlayer, "characterClothes")
		local gender = getElementData(localPlayer,"characterGenre")

		for i, v in ipairs(windows) do -- Categorys
			local x, y, w, h = v[1], v[2], v[3], v[4]
			if isCursorOnElement(x, y, w, h) then 
				window = v[5]
				delay = getTickCount()
				scrollPage = 0
				break 
			end
		end
		
		for i, v in ipairs (slots) do 
			local x, y, w, h = v[1], v[2], v[3], v[4]
			local index = i + scrollPage
			if lojas[string.lower(loja)][gender][window][index] then

				if isCursorOnElement(x, y, w, h) then 

					if (i == select) or character[gender][window] == i then
						cart[window] = nil 
						select = 0;

						if window == "casacos" then
							aplicarCasaco(preview, character[gender]["clothes"]["casacos"], cart["camisas"])
						else
							applyShader(preview, "clothe", character[gender]["clothes"][window], window)
						end

						return
					else
						select = lojas[loja][gender][window][index][3];
						cart[window] = {select, window, lojas[loja][gender][window][index][1], lojas[loja][gender][window][index][2]}
					end

					if window == "casacos" then
						aplicarCasaco(preview, select)
						return
					else
						if (window == "camisas" and cart["casacos"]) and cart["casacos"][1] > 1 then 
							cart[window] = nil
							sendMessageClient("A camisa está por baixo do casaco!", "info")
						else
							applyShader(preview, "clothe", select, window)
						end
					end
					delay = getTickCount()
					break 
				end
			end
		end
	end
end


function payShop()
	if checkShopProducts() then
		triggerServerEvent("payCharacterClothes", resourceRoot, true, {cart, "clothe"}, getTotalPriceCart() )
	else
		sendMessageClient("Coloque algo no seu carrinho!", "info")
	end
end

function checkShopProducts()
	for i,v in pairs(cart) do
		return true
	end
	return false
end

function getTotalPriceCart ()
	local count = 0;
	for i, v in pairs (cart) do 
		count = count + v[4]
	end
	return count
end

function onDeadShop()
	closeShop()
end

createShops()