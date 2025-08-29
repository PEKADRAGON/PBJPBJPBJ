local instance = {}

function createBarbers()
	for id, v in ipairs(lojas["Barbearias"]["pos"]) do 
		local marker = createMarker(v[1], v[2], v[3] - 0.9, "cylinder", 2, 107, 201, 48, 0)

		setElementData(marker , 'markerData', {title = 'Barbearia', desc = 'Fique na régua!', icon = 'entrada'})

		createBlipAttachedTo(marker, 7)

		addEventHandler("onClientMarkerHit", marker, function(plr, md)
			if plr == localPlayer and md then
			if not canUseShop() then return end
				sendMessageClient("Aperte 'e' para entrar", "info")
				bindKey("e", "down", openBarber, source, v[4], id)
			end
		end)

		addEventHandler("onClientMarkerLeave", marker, function(plr, md)
			if plr == localPlayer and md then
				unbindKey("e", "down", openBarber)
			end
		end)
	end
end



function barberKey ( button, state )
	if button == "backspace" and state then 
		closeBarber( )
	elseif button == "enter" and state then 
		payBarber(1)
	end
end


createBarbers()

function openBarber(btn, state, marker)
    if not canUseShop() or not isElementWithinMarker(localPlayer, marker) then return end
	local cid = getElementData(localPlayer, "ID")

	unbindKey("e", "down", openBarber)

	local x,y,z = getElementPosition(localPlayer)
	setElementData(localPlayer, "characterQuit", {x,y,z,0,0})

	setElementInterior(localPlayer, lojas["Barbearias"]["spawn"].interior)
	setElementPosition(localPlayer, unpack(lojas["Barbearias"]["spawn"].posplayer))
	setElementDimension(localPlayer, cid)

	setElementFrozen(localPlayer, true)
	toggleAllControls(false)

	preview = createCustomPed(unpack(lojas["Barbearias"]["spawn"].posped))
	setElementDimension(preview, cid)
	setElementInterior(preview, lojas["Barbearias"]["spawn"].interior)
	setElementRotation(preview, 0, 0, lojas["Barbearias"]["spawn"].rot)

	local genero = getElementData(localPlayer, "characterGenre")
	local character = getElementData(localPlayer, "characterClothes")
	
	if genero == 1 then
		idBarba = character[genero]["face"]["barbas"]
	else
		idBarba = character[genero]["face"]["makeups"]
	end

	idSombrancelha = character[genero]["face"]["eyebrows"]
	idCabeloBaixo = character[genero]["face"]["lowhair"]
	idCabelo = character[genero]["hair"]["id"] 
	idCorCabelo = character[genero]["hair"]["color"]

	instance.windows[1].select = idSombrancelha;
	instance.windows[2].select = idCabeloBaixo;
	instance.windows[3].select = idCabelo;
	instance.windows[4].select = idCorCabelo;
	instance.windows[5].select = idBarba;

	qntCabeloBaixo = #tabelaRoupas[genero]["facetextures"]["lowhair"]
	qntCabelos = #tabelaRoupas[genero]["cabelos"][idCabelo]
	qntSombrancelhas = #tabelaRoupas[genero]["facetextures"]["eyebrows"]
	
	if genero == 1 then
		qntBarbas = #tabelaRoupas[genero]["facetextures"]["barbas"]
	else
		qntBarbas = #tabelaRoupas[genero]["facetextures"]["makeups"]
	end

	valorCabeloBaixo = 0
	valorSombrancelha = 0
	valorCabelo = 0
	valorBarba = 0

	totalValue = 0;

	addEventHandler("onClientPlayerWasted", localPlayer, onDeadBarber)
	addEventHandler("onClientClick", root, barberClick)
	addEventHandler("onClientKey", root, barberKey)

	addEventHandler("onClientRender", root, renderBarber)

	setTargetElement(preview)
	setFreelookEvents(true,2)
end

function exitBarber()
    setCameraTarget(localPlayer)
    setElementFrozen(localPlayer, false)
    toggleAllControls(true)

   -- setElementAlpha(localPlayer, 255)
    setElementInterior(localPlayer, 0)
    setElementDimension(localPlayer, 0)

	local respawn = getElementData(localPlayer, "characterQuit")
    setElementPosition(localPlayer, respawn[1], respawn[2], respawn[3])
	setElementData(localPlayer, "characterQuit", false)

	reloadCharacter(localPlayer, 900)
end

function closeBarber()
	
	removeEventHandler("onClientRender", root, renderBarber)
	removeEventHandler("onClientPlayerWasted", localPlayer, onDeadBarber)
	removeEventHandler("onClientClick", root, barberClick)
	removeEventHandler("onClientKey", root, barberKey)

	exitBarber()
	if preview then
		unloadCharacter(preview)
		destroyElement(preview)
	end


	removeEventHandler("onClientRender", root, renderBarber)

	setElementFrozen(localPlayer, false)
	toggleAllControls(true)
	setFreelookEvents(false)
	setCameraTarget(localPlayer)
end

addEvent("paymentBarber", true)
addEventHandler("paymentBarber", root, function(state)
	if state then
		sendMessageClient("Você atualizou seu visual.", "success")
		closeBarber()
	else
		sendMessageClient("Compra cancelada.", "error")
	end
end)

instance.svgs = {

	['rectangle-main'] = svgCreate(383, 626, [[
		<svg width="383" height="626" viewBox="0 0 383 626" fill="none" xmlns="http://www.w3.org/2000/svg">
			<rect x="0.620116" y="0.620116" width="381.76" height="624.76" rx="9.37988" fill="#0D0E0F" fill-opacity="0.93" stroke="#1C2128" stroke-width="1.24023"/>
		</svg>
	]]);

	['rectangle-slot'] = svgCreate(48, 36, [[
		<svg width="48" height="36" viewBox="0 0 48 36" fill="none" xmlns="http://www.w3.org/2000/svg">
			<rect x="0.660156" y="0.322266" width="47.339" height="34.9407" rx="2.25424" fill="#C1C3C4"/>
		</svg>
	]]);

	['rectangle-value'] = svgCreate(383, 62, [[
		<svg width="383" height="62" viewBox="0 0 383 62" fill="none" xmlns="http://www.w3.org/2000/svg">
			<rect x="0.620116" y="0.620116" width="381.76" height="60.7598" rx="9.37988" fill="#0D0E0F" fill-opacity="0.93" stroke="#1C2128" stroke-width="1.24023"/>
		</svg>
	]]);
	
	['icon-arrow'] = svgCreate(28, 28, [[
		<svg width="28" height="28" viewBox="0 0 28 28" fill="none" xmlns="http://www.w3.org/2000/svg">
			<path d="M17.7503 5.78297C17.6158 5.64225 17.4558 5.53056 17.2795 5.45433C17.1032 5.37811 16.9141 5.33887 16.7231 5.33887C16.5321 5.33887 16.343 5.37811 16.1667 5.45433C15.9904 5.53056 15.8304 5.64225 15.6959 5.78297L8.46213 13.2898C8.32653 13.4294 8.2189 13.5955 8.14545 13.7784C8.072 13.9614 8.03418 14.1576 8.03418 14.3558C8.03418 14.554 8.072 14.7503 8.14545 14.9332C8.2189 15.1162 8.32653 15.2822 8.46213 15.4218L15.6959 22.9287C15.8304 23.0694 15.9904 23.1811 16.1667 23.2573C16.343 23.3335 16.5321 23.3728 16.7231 23.3728C16.9141 23.3728 17.1032 23.3335 17.2795 23.2573C17.4558 23.1811 17.6158 23.0694 17.7503 22.9287C17.8859 22.7891 17.9935 22.623 18.067 22.4401C18.1404 22.2571 18.1782 22.0609 18.1782 21.8627C18.1782 21.6645 18.1404 21.4682 18.067 21.2853C17.9935 21.1023 17.8859 20.9363 17.7503 20.7967L11.5292 14.3558L17.7503 7.91492C17.8859 7.77535 17.9935 7.6093 18.067 7.42634C18.1404 7.24338 18.1782 7.04715 18.1782 6.84895C18.1782 6.65075 18.1404 6.45451 18.067 6.27155C17.9935 6.0886 17.8859 5.92254 17.7503 5.78297Z" fill="white"/>
		</svg>
	]])

}


instance.positions = {
	{91, 294, 48, 36, 'left', index = 1};
	{91, 396, 48, 36, 'left', index = 2};
	{91, 498, 48, 36, 'left', index = 3};
	{91, 600, 48, 36, 'left', index = 4};
	{91, 702, 48, 36, 'left', index = 5};

	{309, 294, 48, 36, 'right', index = 1};
	{309, 396, 48, 36, 'right', index = 2};
	{309, 498, 48, 36, 'right', index = 3};
	{309, 600, 48, 36, 'right', index = 4};
	{309, 702, 48, 36, 'right', index = 5};
}

instance.windows = {
	
	{ 

		label = 'Sombrancelhas', 
		select = 1, 
		x = 185, 
		y = 256, 
		w = 79, 
		h = 14,

		gender = {
			[1] = 'eyebrows',
			[2] = 'eyebrows',
		}

	};

	{ 

		label = 'Cabelo baixo', 
		select = 1, 
		x = 191, 
		y = 358,
		w = 66, 
		h = 14,

		gender = {
			[1] = 'lowhair',
			[2] = 'lowhair',
		}
	
	};

	{ 
	
		label = 'Careca', 
		select = 1, 
		x = 206, 
		y = 460, 
		w = 36, 
		h = 14,

		gender = {
			[1] = 'hair',
			[2] = 'hair',
		}

	
	};

	{ 
		label = 'Cor do cabelo', 
		select = 1, 
		x = 189, 
		y = 562, 
		w = 70, 
		h = 14,

		gender = {
			[1] = 'hair',
			[2] = 'hair',
		}
	
	};

	{ 
		label = 'Barba/bigode', 
		select = 1, 
		x = 190, 
		y = 664, 
		w = 69, 
		h = 14,

		gender = {
			[1] = 'barbas',
			[2] = 'makeups',
		}

	};

}



function renderBarber()
	local genero = getElementData(localPlayer,"characterGenre")
	local corDaPele = getElementData(localPlayer,"characterSkinColor")

	-- Background

	dxDrawImage(
		32, 221, 383, 626, instance.svgs['rectangle-main'], 0, 0, 0, tocolor(255, 255, 255, 255)
	)

	--Título
	if genero == 1 then

		dxDrawText("BARBEARIA ORLANDO", 33, 141, 262, 30, tocolor(255, 255, 255, 255), 1, exports["guetto_assets"]:dxCreateFont("bold", 25), "left", "top")
		dxDrawText("Pra deixar seu cabelo na régua de cria.", 33, 170, 239, 18, tocolor(188, 184, 184, 255), 1, exports["guetto_assets"]:dxCreateFont("regular", 15), "left", "top")

	else

		dxDrawText("Salão Rosângela Hair", 33, 141, 262, 30, tocolor(255, 255, 255, 255), 1, exports["guetto_assets"]:dxCreateFont("bold", 25), "left", "top")
		dxDrawText("Pra deixar seu cabelo na régua de cria.", 33, 170, 239, 18, tocolor(188, 184, 184, 255), 1, exports["guetto_assets"]:dxCreateFont("regular", 15), "left", "top")

	end

	for i = 1, #instance.windows do 
		local v = instance.windows[i]

		dxDrawText(
			v.select, v.x, v.y + 45, v.w, v.h, tocolor(255, 255, 255, 255), 1, exports['guetto_assets']:dxCreateFont('regular', 12), 'center', 'top'
		)

		dxDrawText(
			v.label, v.x, v.y, v.w, v.h, tocolor(255, 255, 255, 255), 1, exports['guetto_assets']:dxCreateFont('regular', 12), 'center', 'top'
		)
	end

	for index, value in ipairs (instance.positions) do
		local x, y, w, h = value[1], value[2], value[3], value[4];

		dxDrawImage(x, y, w, h, instance.svgs['rectangle-slot'], 0, 0, 0, isCursorOnElement(x, y, w, h) and tocolor(158, 158, 158, 255) or tocolor(193, 195, 196, 255))
		dxDrawImage(x + w / 2 - 28 / 2, y + h / 2 - 28 /2, 28, 28, instance.svgs['icon-arrow'], value[5] == 'left' and 0 or 180, 0, 0, tocolor(255, 255, 255, 255))

		dxDrawRectangle(94, y + h - 1, 260, 1, tocolor(193, 195, 196, 255))
	end

	dxDrawImage(
		1458, 968, 443, 71, 'assets/images/faixa.png', 0, 0, 0, tocolor(255, 255, 255, 255)
	)

end


function barberClick ( button, state )
	if button == "left" and state == "down" then 
		
		local genero = getElementData(localPlayer, "characterGenre")
		local corDaPele = getElementData(localPlayer, "characterSkinColor")
		local character = getElementData(localPlayer, "characterClothes")

		for i, v in ipairs (instance.positions) do 
			if isCursorOnElement(v[1], v[2], v[3], v[4]) then 

				if guiTick and guiTick + 500  >= getTickCount ( ) then 
					return 
				end

				local reference = instance.windows[v.index]
				if reference.label == "Sombrancelhas" then 
					if v[5] == "right" then
						instance.windows[v.index].select = instance.windows[v.index].select + 1
						
						if instance.windows[v.index].select > qntSombrancelhas then 
							instance.windows[v.index].select = 1
						end

						if (character[genero]["face"]["eyebrows"] == (instance.windows[v.index].select)) or (instance.windows[v.index].select == 1) then
							valorSombrancelha = 0
						else
							valorSombrancelha = tabelaRoupas[genero]["facetextures"]["eyebrows"][instance.windows[v.index].select][4]
						end

						applyShader(preview, "face", instance.windows[v.index].select, "eyebrows")
						guiTick = getTickCount();
					elseif v[5] == "left" then 

						instance.windows[v.index].select = instance.windows[v.index].select - 1

						if instance.windows[v.index].select <= 0 then
							instance.windows[v.index].select = qntSombrancelhas
						end
						
						local idSombrancelhaData = character[genero]["face"]["eyebrows"]
						if (idSombrancelhaData == (instance.windows[v.index].select)) or (idSombrancelha == 1) then
							valorSombrancelha = 0
						else
							valorSombrancelha = tabelaRoupas[genero]["facetextures"]["eyebrows"][instance.windows[v.index].select][4]
						end
						
						applyShader(preview, "face", instance.windows[v.index].select, "eyebrows")
						guiTick = getTickCount();
					end

				elseif reference.label == "Careca" then 
					if v[5] == "right" then

						instance.windows[v.index].select = instance.windows[v.index].select + 1
						instance.windows[4].select = 1

						if instance.windows[v.index].select > #tabelaRoupas[genero]["cabelos"] then
							instance.windows[v.index].select = 1
						end

						qntCabelos = #tabelaRoupas[genero]["cabelos"][instance.windows[v.index].select]
			
						local idcabeloData = character[genero]["hair"]["id"]
						local corcabeloData = character[genero]["hair"]["color"]
						
						if (idcabeloData == instance.windows[v.index].select and corcabeloData == instance.windows[4].select) or instance.windows[v.index].select == 1 then
							valorCabelo = 0
						else
							valorCabelo = 1
						end

						iprint(tabelaRoupas[genero]["cabelos"][instance.windows[v.index].select][instance.windows[4].select][2], tabelaRoupas[genero]["cabelos"][instance.windows[v.index].select][instance.windows[4].select][3])

						criarCabelo(preview, tabelaRoupas[genero]["cabelos"][instance.windows[v.index].select][instance.windows[4].select][2], tabelaRoupas[genero]["cabelos"][instance.windows[v.index].select][instance.windows[4].select][3])
						applyShader(preview, "hair", instance.windows[v.index].select, false, false, instance.windows[4].select)
						guiTick = getTickCount();

					elseif v[5] == "left" then 

						instance.windows[v.index].select = instance.windows[v.index].select - 1
						instance.windows[4].select = 1


						if instance.windows[v.index].select <= 0 then
							instance.windows[v.index].select = 1
						end

						qntCabelos = #tabelaRoupas[genero]["cabelos"][instance.windows[v.index].select]
			
						local idcabeloData = character[genero]["hair"]["id"]
						local corcabeloData = character[genero]["hair"]["color"]
						
						if (idcabeloData == instance.windows[v.index].select and corcabeloData == instance.windows[4].select) or instance.windows[v.index].select == 1 then
							valorCabelo = 0
						else
							valorCabelo = tabelaRoupas[genero]["cabelos"][idcabeloData][instance.windows[4].select][5]
						end

						criarCabelo(preview, tabelaRoupas[genero]["cabelos"][instance.windows[v.index].select][instance.windows[4].select][2], tabelaRoupas[genero]["cabelos"][instance.windows[v.index].select][instance.windows[4].select][3])
						applyShader(preview, "hair", instance.windows[v.index].select, false, false, instance.windows[4].select)
						guiTick = getTickCount();

					end

				elseif reference.label == "Cabelo baixo" then 
					if v[5] == "right" then

						instance.windows[v.index].select = instance.windows[v.index].select + 1
					
						if instance.windows[v.index].select > qntCabeloBaixo then
							instance.windows[v.index].select = 1
						end

						local idCabeloBaixoData = character[genero]["face"]["lowhair"]
						if idCabeloBaixoData == instance.windows[v.index].select or instance.windows[v.index].select == 1 then
							valorCabeloBaixo = 0
						else
							valorCabeloBaixo = tabelaRoupas[genero]["facetextures"]["lowhair"][instance.windows[v.index].select][4]
						end

						applyShader(preview, "face", instance.windows[v.index].select, "lowhair")
						guiTick = getTickCount();

					elseif v[5] == "left" then 

						instance.windows[v.index].select = instance.windows[v.index].select - 1
					
						if instance.windows[v.index].select <= 0 then
							instance.windows[v.index].select = 1
						end

						local idCabeloBaixoData = character[genero]["face"]["lowhair"]
						if idCabeloBaixoData == instance.windows[v.index].select or instance.windows[v.index].select == 1 then
							valorCabeloBaixo = 0
						else
							valorCabeloBaixo = tabelaRoupas[genero]["facetextures"]["lowhair"][instance.windows[v.index].select][4]
						end

						applyShader(preview, "face", instance.windows[v.index].select, "lowhair")
						guiTick = getTickCount();
						
					end

				elseif reference.label == "Barba/bigode" then 

					if v[5] == "right" then 

						instance.windows[v.index].select = instance.windows[v.index].select + 1
					
						if instance.windows[v.index].select > qntBarbas then
							instance.windows[v.index].select = 1
						end
	
						if genero == 1 then
							idBarbaData = character[genero]["face"]["barbas"]
						else
							idBarbaData = character[genero]["face"]["makeups"]
						end
	
						if (idBarbaData == instance.windows[v.index].select or instance.windows[v.index].select == 1) then
							valorBarba = 0
						else
							if genero == 1 then
								valorBarba = tabelaRoupas[genero]["facetextures"]["barbas"][instance.windows[v.index].select][4]
							else
								valorBarba = tabelaRoupas[genero]["facetextures"]["makeups"][instance.windows[v.index].select][4]
							end
						end
	
						if genero == 1 then
							applyShader(preview, "face", instance.windows[v.index].select, "barbas")
						else
							applyShader(preview, "face", instance.windows[v.index].select, "makeups")
						end
	
						guiTick = getTickCount();

					elseif v[5] == "left" then 

						instance.windows[v.index].select = instance.windows[v.index].select - 1
					
						if instance.windows[v.index].select <= 0 then
							instance.windows[v.index].select = 1
						end
	
						if genero == 1 then
							idBarbaData = character[genero]["face"]["barbas"]
						else
							idBarbaData = character[genero]["face"]["makeups"]
						end
	
						if (idBarbaData == instance.windows[v.index].select or instance.windows[v.index].select == 1) then
							valorBarba = 0
						else
							if genero == 1 then
								valorBarba = tabelaRoupas[genero]["facetextures"]["barbas"][instance.windows[v.index].select][4]
							else
								valorBarba = tabelaRoupas[genero]["facetextures"]["makeups"][instance.windows[v.index].select][4]
							end
						end
	
						if genero == 1 then
							applyShader(preview, "face", instance.windows[v.index].select, "barbas")
						else
							applyShader(preview, "face", instance.windows[v.index].select, "makeups")
						end
	
						guiTick = getTickCount();

					end

				elseif reference.label == "Cor do cabelo" then  

					if v[5] == "right" then 
						local idCabelo = instance.windows[3].select;
						
						if idCabelo ~= 1 then
							instance.windows[v.index].select = instance.windows[v.index].select + 1
							
							if instance.windows[v.index].select > qntCabelos then
								instance.windows[v.index].select = 1
							end
							

							local idcabeloData = character[genero]["hair"]["id"]
							local corcabeloData = character[genero]["hair"]["color"]

							if (idcabeloData == idCabelo and corcabeloData == instance.windows[v.index].select) or idCabelo == 1 then
								valorCabelo = 0
							else
								valorCabelo = tabelaRoupas[genero]["cabelos"][idCabelo][instance.windows[v.index].select][5]
							end
			
							applyShader(preview, "hair", idCabelo, false, false, instance.windows[v.index].select)
							guiTick = getTickCount();
						end

					elseif v[5] == "left" then 
						local idCabelo = instance.windows[3].select;
						
						if idCabelo ~= 1 then
							instance.windows[v.index].select = instance.windows[v.index].select - 1
							
							if instance.windows[v.index].select <= 0 then
								instance.windows[v.index].select = 1
							end

							local idcabeloData = character[genero]["hair"]["id"]
							local corcabeloData = character[genero]["hair"]["color"]

							if (idcabeloData == idCabelo and corcabeloData == instance.windows[v.index].select) or idCabelo == 1 then
								valorCabelo = 0
							else
								valorCabelo = tabelaRoupas[genero]["cabelos"][idCabelo][instance.windows[v.index].select][5]
							end
			
							applyShader(preview, "hair", idCabelo, false, false, instance.windows[v.index].select)
							guiTick = getTickCount();
						end
					end
				end
				break 
			end
		end
	end
end


function payBarber(valor)
	local genre = getElementData(localPlayer, "characterGenre")
	
	local carrinho = {};

	for i, v in ipairs ( instance.windows ) do 

		if ( v["label"] == "Careca" ) then 
			if not (carrinho[i]) then 
				carrinho[i] = {v['select'], v['gender'][genre], instance.windows[4]['select']}
			end
		else
			if not (carrinho[i]) then
				if v["label"] ~= "Cor do cabelo" then 
					carrinho[i] = {v['select'], v['gender'][genre]}
				end
			end
		end

	end

	triggerServerEvent("payCharacterBarber", resourceRoot, true, valor, carrinho)
	--triggerServerEvent("createPayment", resourceRoot, valor, "payCharacterBarber", "card", carrinho)
end

function onDeadBarber()
	removeEventHandler("onClientRender", root, renderBarber)
	removeEventHandler("onClientPlayerWasted", localPlayer, onDeadBarber)
	removeEventHandler("onClientClick", root, barberClick)
	exitBarber()
	if preview then
		unloadCharacter(preview)
		destroyElement(preview)
	end
end

	