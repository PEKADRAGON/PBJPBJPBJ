local blip1 = createBlip(1090.2177734375, -1475.5849609375, 22.74418258667, 0, 2, 255,102,255) --ls
setElementData(blip1, "icon", 50, false)
setElementData(blip1, "blipName", "Loja de acessórios", false)

local blip2 = createBlip(2247.6904296875, 2396.3974609375, 10.8203125, 0, 2, 255,102,255) --lv
setElementData(blip2, "icon", 50, false)
setElementData(blip2, "blipName", "Loja de acessórios", false)

local blip3 = createBlip(-2430.392578125, -154.60546875, 35.3203125, 0, 2, 255,102,255) --sf
setElementData(blip3, "icon", 50, false)
setElementData(blip3, "blipName", "Loja de acessórios", false)

screenW, screenH = guiGetScreenSize()
sx, sy = (screenW/1920), (screenH/1080)


function aToR(X, Y, sX, sY)
    local xd = X/1920 or X
    local yd = Y/1080 or Y
    local xsd = sX/1920 or sX
    local ysd = sY/1080 or sY
    return xd * screenW, yd * screenH, xsd * screenW, ysd * screenH
end


_dxDrawRectangle = dxDrawRectangle
function dxDrawRectangle(x, y, w, h, ...)
    local x, y, w, h = aToR(x, y, w, h)
    return _dxDrawRectangle(x, y, w, h, ...)
end

_dxDrawText = dxDrawText
function dxDrawText(text, x, y, w, h, ...)
    local x, y, w, h = aToR(x, y, w + x, h + y)
    return _dxDrawText(text, x, y, w, h, ...)
end

_dxDrawImage = dxDrawImage
function dxDrawImage(x, y, w, h, ...)
    local x, y, w, h = aToR(x, y, w, h)
    return _dxDrawImage(x, y, w, h, ...)
end

_dxDrawImageSection = dxDrawImageSection
function dxDrawImageSection(x, y, w, h, ...)
    local x, y, w, h = aToR(x, y, w, h)
    return _dxDrawImageSection(x, y, w, h, ...)
end

function isCursorOnElement (x, y, w, h)
    local x, y, w, h = aToR(x, y, w, h)
    if isCursorShowing() then
        local mx, my = getCursorPosition()
        local resx, resy = guiGetScreenSize()
        mousex, mousey = mx * resx, my * resy
        if mousex > x and mousex < x + w and mousey > y and mousey < y + h then
            return true
        else
            return false
        end
    end
end

local svgs = {
	['rectangle-window'] = svgCreate(87, 43, [[
		<svg width="87" height="43" viewBox="0 0 87 43" fill="none" xmlns="http://www.w3.org/2000/svg">
			<rect width="87" height="43" rx="4" fill="white"/>
		</svg>
	]]);

	['rectangle-slot'] = svgCreate(382, 64, [[
		<svg width="382" height="36" viewBox="0 0 382 36" fill="none" xmlns="http://www.w3.org/2000/svg">
			<rect width="382" height="36" fill="white"/>
		</svg>	
	]]);
}

local objects = {}

local tempo = 0
local row = 0

local acessorioLocal = {}

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
	{426, 161, 87, 43, "cabeca"};
	{426, 210, 87, 43, "rosto"};
	{426, 259, 87, 43, "mochilas"};
	{426, 308, 87, 43, "bandana"};
}

local slots_carts = {
	{44, 857, 83, 14};
	{44, 893, 83, 14};
	{44, 929, 83, 14};
	{44, 965, 83, 14};
	{44, 1001, 83, 14};
}

local types = {
	{32, 107, 186, 43, "comum", "LOJA CLASSICA"};
	{228, 107, 186, 43, "premium", "LOJA PREMIUM"};
}


function render()

	dxDrawImage(
		32, 161, 383, 611, 'arquivos/background.png', 0, 0, 0, tocolor(255, 255, 255, 255)
	)

	dxDrawText(
		'ACESSORIOS', 33, 42, 157, 30, tocolor(255, 255, 255, 255), 1, exports['guetto_assets']:dxCreateFont('bold', 25), 'left', 'top'
	)

	dxDrawText(
		'Loja de acessorios, para você que gosta de andar na moda.', 33, 71, 368, 18, tocolor(188, 184, 184, 255), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'left', 'top'
	)

	for i, v in ipairs (types) do 
		local x, y, w, h = v[1], v[2], v[3], v[4]
		
		dxDrawImage(
			x, y, w, h, 'arquivos/rectangle-window.png', 0, 0, 0, categoria == v[5] and tocolor(213, 223, 233, 0.93 * 255) or tocolor(13, 14, 15, 0.93 * 255)
		)

		dxDrawText(
			v[6], x, y, w, h, categoria == v[5] and tocolor(16, 18, 21,  255) or tocolor(255, 255, 255, 255), 1, exports['guetto_assets']:dxCreateFont('bold', 13), 'center', 'center'
		)
	end

	for i, v in ipairs(windows) do 
		local x, y, w, h = v[1], v[2], v[3], v[4]
		dxDrawImage(x, y, w, h, svgs['rectangle-window'], 0, 0, 0, aba == v[5] and tocolor(49, 50, 51, 0.93 * 255) or isCursorOnElement(x, y, w, h) and tocolor(49, 50, 51, 0.93 * 255) or tocolor(13, 14, 15, 0.93 * 255))
		dxDrawText(string.upper(v[5]), x, y, w, h, tocolor(255, 255, 255, 255), 1, exports['guetto_assets']:dxCreateFont('regular', 14), 'center', 'center')
	end


	for i, v in ipairs (slots) do 
		local x, y, w, h = v[1], v[2], v[3], v[4]
		local index = i + scrollPage
		if acessorioLocal[aba][index] then
			if acessorioLocal[aba][index].naloja then
				dxDrawImage(x, y, w, h, svgs['rectangle-slot'], 0, 0, 0, selecionado == index and tocolor(193, 159, 114, 255) or isCursorOnElement(x, y, w, h) and tocolor(193, 159, 114, 255) or tocolor(55, 55, 55, 0.12 * 255))
				dxDrawText(acessorioLocal[aba][index].nome, x + 11, y, 78, 36, tocolor(255, 255, 255, 255), 1, exports['guetto_assets']:dxCreateFont('regular', 12), "left", "center", false, false, false, false, false)
				dxDrawText("R$ "..acessorioLocal[aba][index].preco, x + 329, y, 37, h, tocolor(255, 255, 255, 255), 1, exports['guetto_assets']:dxCreateFont('regular', 12), "right", "center", false, false, false, false, false)
			end
		end
	end


	dxDrawImage(
		32, 803, 383, 235, 'arquivos/cart-background.png', 0, 0, 0, tocolor(255, 255, 255, 255)
	)	

	dxDrawText(
		'CARRINHO DE COMPRAS', 50, 821, 134, 14, tocolor(255, 255, 255, 255), 1, exports['guetto_assets']:dxCreateFont('regular', 14), 'left', 'top'
	)

	dxDrawText(
		'TOTAL:', 278, 821, 134, 14, tocolor(255, 255, 255, 255), 1, exports['guetto_assets']:dxCreateFont('regular', 14), 'left', 'top'
	)

	dxDrawText(
		'R$ '..formatNumber(getPriceCar(), '.'), 327, 821, 66, 14, tocolor(255, 255, 255, 255), 1, exports['guetto_assets']:dxCreateFont('regular', 14), 'right', 'top'
	)

	dxDrawImage(
		1458, 968, 443, 71, "arquivos/faixa.png", 0, 0, 0, tocolor(255, 255, 255, 255)
	)

	local line = 0
	for i, v in pairs(carrinho) do
		line = line + 1
		if slots_carts[line] and v then
			dxDrawText(v[3], slots_carts[line][1], slots_carts[line][2], slots_carts[line][3], slots_carts[line][4], tocolor(255, 255, 255, 255), 1, exports['guetto_assets']:dxCreateFont('regular', 14), 'left', 'center')
			dxDrawText('R$ '..formatNumber(v[1], '.'), slots_carts[line][1] + 280, slots_carts[line][2], slots_carts[line][3], slots_carts[line][4], tocolor(255, 255, 255, 255), 1, exports['guetto_assets']:dxCreateFont('regular', 14), 'left', 'center')
		end
	end
	
end

function openShopAcccessories()
	toggleAllControls(false)
	open()
end
addEvent("openShopAcccessories", true)
addEventHandler("openShopAcccessories", root, openShopAcccessories)

function open()
	statusPainel = true
	scrollPage = 0;

	carrinho = {}

	showChat(false)

	changePage("cabeca")
	changeCategory("comum")
	
	setFreelookEvents(true, 1)
	bindKey("enter", "up", buyItem)

	addEventHandler("onClientRender", root, render)
	addEventHandler("onClientClick", root, click)
	addEventHandler("onClientKey", root, key)
end

function changePage(page)
	aba = page
	selecionado = 0
	local c =  0
	acessorioLocal[page] = {}
	for i=1, #acessorios[page] do
		if acessorios[page][i].naloja then
			if (categoria == "premium" and acessorios[page][i].premium) or (categoria == "comum" and not acessorios[page][i].premium) then
				c = c +1
				acessorioLocal[page][c] = {}
				acessorioLocal[page][c] = acessorios[page][i]
				acessorioLocal[page][c]["index"] = i
			end
		end
	end
end

function changeCategory(category)
	categoria = category
	selecionado = 0

	destroyAllAccessoriesTemp()

	local c =  0
	acessorioLocal[aba] = {}
	for i=1, #acessorios[aba] do
		if acessorios[aba][i].naloja then
			if (categoria == "premium" and acessorios[aba][i].premium) or (categoria == "comum" and not acessorios[aba][i].premium) then
				c = c +1
				acessorioLocal[aba][c] = {}
				acessorioLocal[aba][c] = acessorios[aba][i]
				acessorioLocal[aba][c]["index"] = i
			end
		end
	end

	carrinho = {}
	for tab, _ in pairs(acessorios) do
		carrinho[tab] = false
	end

	totalPrice = getPriceCar()
end

function buyItem()
	local totalPrice = getPriceCar()
	if totalPrice > 0 then
		triggerServerEvent("Acessorios.comprar", resourceRoot, true, {carrinho, totalPrice})
	end
end

--[[
function buyItem()
	local totalPrice = getPriceCar()
	if totalPrice > 0 then
		triggerser
		triggerServerEvent("createPayment", resourceRoot, totalPrice, "Acessorios.comprar", (categoria == "premium" and "justPremiumPoints" or "card"), {carrinho, totalPrice})
	end
end
]]

function getPriceCar()
	local price = 0
	for i, v in pairs(carrinho) do
		if v then
			price = price + v[1]
		end
	end
	return price
end

function close()

	valorTotal = 0
	valorCabeca = 0
	valorMochila = 0

	valorTotalBTC = 0
	valorCabecaBTC = 0
	valorMochilaBTC = 0

	statusPainel = false

	removeEventHandler("onClientRender", root, render)
	removeEventHandler("onClientClick", root, click)
	removeEventHandler("onClientKey", root, key)

	unbindKey("enter", "up", buyItem)

	triggerServerEvent("exitShopAccessories", resourceRoot)

	destroyAllAccessoriesTemp()
	showChat(true)

	toggleAllControls(true)
	setFreelookEvents(false)
	setCameraTarget(localPlayer)
	
end

function key(button,press)
	if (button == "backspace" and press) then 
		close()
	elseif (button == "mouse_wheel_down" and press) then 
		local gender = getElementData(localPlayer,"characterGenre")
		if isCursorOnElement(32, 161, 383, 611) then 
			if acessorioLocal[aba] then
				local totalWindows = #acessorioLocal[aba]
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

function click(button, state)
	if (button == "left") and (state == "down") then
		--Change page

		for i, v in ipairs(windows) do 
			local x, y, w, h = v[1], v[2], v[3], v[4]
			if isCursorOnElement(x, y, w, h) then 
				changePage(v[5])
				scrollPage = 0;
				return
			end
		end

		for i, v in ipairs(types) do 
			local x, y, w, h = v[1], v[2], v[3], v[4]
			if isCursorOnElement(x, y, w, h) then 
				changeCategory(v[5])
				break 
			end
		end

		for i, v in ipairs (slots) do 
			local x, y, w, h = v[1], v[2], v[3], v[4]
			local index = i + scrollPage
			if acessorioLocal[aba][index] then
				if acessorioLocal[aba][index].naloja then
					if isCursorOnElement(x, y, w, h) then 
						if guiTick and guiTick + 300 > getTickCount() then return end
						guiTick = getTickCount()
						if selecionado == index then
							destroyTempAccesorie(aba)
							carrinho[aba] = false
							selecionado = 0
						else
							selecionado = index
							local name = acessorioLocal[aba][selecionado].nome
							if name == "Remover" then
								destroyTempAccesorie(aba)
								carrinho[aba] = false
								selecionado = 0
							else
								local premium = acessorioLocal[aba][selecionado].premium
								local price = acessorioLocal[aba][selecionado].preco
								carrinho[aba] = {price, premium, name, selecionado, acessorioLocal[aba][selecionado]}
								totalPrice = getPriceCar()
								createObjectTemp(aba, acessorioLocal[aba][selecionado].index)
							end
						end
						break 
					end	
				end
			end
		end

	end	
end

addEvent("onResponseAccessories", true)
addEventHandler("onResponseAccessories", root, function(state, price)
	if state then
        sendMessageClient(string.format("Acessórios comprados por R$%.2f", price), "success")
		carrinho = {}
		for tab, _ in pairs(acessorios) do
			carrinho[tab] = false
		end
		totalPrice = getPriceCar()
		selecionado = 0
	else
		sendMessageClient("A compra falhou!", "error")
	end
end)

function createObjectTemp(category, id)
	if isElement(objects[category]) then
        if acessorios[aba][id].nome == "Remover" and acessorios[aba][id].nometextura ~= "" then
            setElementData(objects[category], "accessorieTexture", nil, false)
            destroyElement(objects[category])
            objects[category] = nil
            return 
        else
            destroyElement(objects[category])
            objects[category] = nil
        end
    end
    
    local x, y, z = getElementPosition(localPlayer)
    objects[category] = createObject(acessorios[aba][id].idobjeto, x, y, z)
    if acessorios[aba][id].nometextura ~= "" then
        setElementData(objects[category], "accessorieTexture", {
            directory = acessorios[aba][id].diretorio,
            texturename = acessorios[aba][id].nometextura,
            category = aba
        }, false)
    end

    if aba == "cabeca" then
        if acessorios[aba][id].removercabelo == true then
            --triggerClientEvent("Conner.cabeloalpha", resourceRoot, localPlayer, 0);
        end
    end

    local tx, ty, tz = unpack(acessorios[aba][id].tamanho)
    setObjectScale(objects[category], tx, ty, tz)
    local xA, xY, xZ, rX, rY, rZ = unpack(acessorios[aba][id].pos)
    exports.pattach:attach(objects[category], localPlayer, acessorios[aba][id].osso, xA, xY, xZ, rX, rY, rZ)
end

function destroyTempAccesorie(category)
	if not objects[category] then return end
	if isElement(objects[category]) then
		destroyElement(objects[category])
	end
	objects[category] = nil
end

function destroyAllAccessoriesTemp()
	for i, v in pairs(objects) do
		if v and isElement(v) then
			destroyElement(v)
		end
	end
	objects = {}
end

