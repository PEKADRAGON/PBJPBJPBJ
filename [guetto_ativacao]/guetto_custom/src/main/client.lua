local timer = {}

local interface = {}

interface.svgs = {

	['rectangle-main'] = svgCreate(383, 626, [[
		<svg width="383" height="626" viewBox="0 0 383 626" fill="none" xmlns="http://www.w3.org/2000/svg">
			<rect x="0.620116" y="0.620116" width="381.76" height="624.76" rx="9.37988" fill="#0D0E0F" fill-opacity="0.93" stroke="#1C2128" stroke-width="1.24023"/>
		</svg>
	]]);

	['rectangle-slot'] = svgCreate(48, 36, [[
		<svg width="48" height="36" viewBox="0 0 48 36" fill="none" xmlns="http://www.w3.org/2000/svg">
		<rect y="0.322021" width="47.339" height="34.9407" rx="2.25424" fill="white"/>
		</svg>
	]]);

	['rectangle-confirm'] = svgCreate(215, 46, [[
		<svg width="215" height="46" viewBox="0 0 215 46" fill="none" xmlns="http://www.w3.org/2000/svg">
			<rect width="215" height="46" rx="3" fill="white"/>
		</svg>
	]]);

	['rectangle-sexo'] = svgCreate(383, 82, [[
		<svg width="383" height="82" viewBox="0 0 383 82" fill="none" xmlns="http://www.w3.org/2000/svg">
			<rect x="0.620116" y="0.620116" width="381.76" height="80.7598" rx="9.37988" fill="#0D0E0F" fill-opacity="0.93" stroke="#1C2128" stroke-width="1.24023"/>
		</svg>
	]]);

	['button-sexo'] = svgCreate(112, 39, [[
		<svg width="112" height="39" viewBox="0 0 112 39" fill="none" xmlns="http://www.w3.org/2000/svg">
			<path d="M0 4C0 1.79086 1.79086 0 4 0H112V39H4C1.79086 39 0 37.2091 0 35V4Z" fill="white"/>
		</svg>
	]]);

	['icon-arrow'] = svgCreate(28, 28, [[
		<svg width="28" height="28" viewBox="0 0 28 28" fill="none" xmlns="http://www.w3.org/2000/svg">
			<path d="M17.7503 5.78297C17.6158 5.64225 17.4558 5.53056 17.2795 5.45433C17.1032 5.37811 16.9141 5.33887 16.7231 5.33887C16.5321 5.33887 16.343 5.37811 16.1667 5.45433C15.9904 5.53056 15.8304 5.64225 15.6959 5.78297L8.46213 13.2898C8.32653 13.4294 8.2189 13.5955 8.14545 13.7784C8.072 13.9614 8.03418 14.1576 8.03418 14.3558C8.03418 14.554 8.072 14.7503 8.14545 14.9332C8.2189 15.1162 8.32653 15.2822 8.46213 15.4218L15.6959 22.9287C15.8304 23.0694 15.9904 23.1811 16.1667 23.2573C16.343 23.3335 16.5321 23.3728 16.7231 23.3728C16.9141 23.3728 17.1032 23.3335 17.2795 23.2573C17.4558 23.1811 17.6158 23.0694 17.7503 22.9287C17.8859 22.7891 17.9935 22.623 18.067 22.4401C18.1404 22.2571 18.1782 22.0609 18.1782 21.8627C18.1782 21.6645 18.1404 21.4682 18.067 21.2853C17.9935 21.1023 17.8859 20.9363 17.7503 20.7967L11.5292 14.3558L17.7503 7.91492C17.8859 7.77535 17.9935 7.6093 18.067 7.42634C18.1404 7.24338 18.1782 7.04715 18.1782 6.84895C18.1782 6.65075 18.1404 6.45451 18.067 6.27155C17.9935 6.0886 17.8859 5.92254 17.7503 5.78297Z" fill="white"/>
		</svg>
	]])

}

function criarCabelo(player, remover, objeto)
	if not isElementStreamedIn(player) then return end
	local genero = getElementData(player, "characterGenre")
	if cabelo[player] then
		if isElement(cabelo[player]) then
			destroyElement(cabelo[player])
		end
		cabelo[player] = nil
	end
	if remover and remover == "remover" then
		local character = getElementData(player, "characterClothes")[genero]
		if cabelo[player] and character["hair"]["id"] > 1 then
			--setElementData(player, "cabelo:alpha", nil)
			excluirShader(player, "cabelo")
		end
	else
		local px, py, pz = getElementPosition(player)
		cabelo[player] = createObject(objeto[1], px, py, pz)
		setElementAlpha(cabelo[player], (getElementData(player, "cabelo:alpha") or 255))
		setObjectScale(cabelo[player], objeto[8])
		exports.RBR_bone3:attach(cabelo[player], player, 8, objeto[2], objeto[3], objeto[4], objeto[5], objeto[6], objeto[7])
		setElementDimension(cabelo[player],getElementDimension(player))
		setElementInterior(cabelo[player],getElementInterior(player))
	end
end
createEvent("Conner.criarCabelo", getRootElement(), criarCabelo)

function cabeloalpha(player,alpha)
	if tonumber(alpha) then
		if cabelo[player] and isElement(cabelo[plwayer]) then
			setElementAlpha(cabelo[player], alpha)
			setElementData(player, "cabelo:alpha",alpha)
		end
	end
end
createEvent("Conner.cabeloalpha", getRootElement(), cabeloalpha)

function loadCharacter(player, time, setresponsefalse)
	if not player or timer[player] or not getElementData(player, "characterClothes") then return end
	if not time then time = 2000 end

	timer[player] = setTimer(function(player)
		timer[player] = nil
		if not isElement(player) then return end
		if shaders[player] then return end

		local genero = getElementData(player, "characterGenre")
		local cor = getElementData(player, "characterSkinColor")
		local character = getElementData(player, "characterClothes")[genero]
		local dutyClothes = getElementData(player, "dutyClothes")
		if not character or not cor or not genero then return end

		--Load body
		for i, v in pairs(corpo[genero]) do
			applyShader(player, "body", v[1], v[2], false, cor)
		end

		--Load face
		for i, v in pairs(character["face"]) do
			applyShader(player, "face", v, i)
		end

		--Load tatoo
		--[[for i, v in pairs(character["tatoo"]) do
			applyShader(player, "tatoo," v, i)
		end]]

		--Load clothes
		if not dutyClothes then
			for i, v in pairs(character["clothes"]) do
				if i ~= "casacos" then
					applyShader(player, "clothe", v, i)
				end
			end
			aplicarCasaco(player, character["clothes"]["casacos"])
		else
			for category, id in pairs(dutyClothes[genero]) do
				applyShader(player, "dutyclothes", id, category)
			end
		end

		--Load hair
		if not cabelo[player] then
			local id = character["hair"]["id"]
			local cor = character["hair"]["color"] or 1
			if id > 1 then
				criarCabelo(player, false, tabelaRoupas[genero]["cabelos"][id][cor][3])
				applyShader(player, "hair", id, false, false, cor)
			end
		end

	end, time, 1, player)
end
createEvent("loadCharacter", root, loadCharacter)

function unloadCharacter(player, removeClothes, removeDutyClothes)
	if not isElement(player) then return end
	if not shaders[player] then return end
	local genre = getElementData(player, "characterGenre")
	local characterClothes = getElementData(player, "characterClothes")
	local dutyClothes = getElementData(player, "dutyClothes")

	local idHair = characterClothes[genre]["hair"]["id"]
	local color = characterClothes[genre]["hair"]["color"] or 1

	--Destroy body
	for _, v in pairs(corpo[genre]) do
		excluirShader(player, v[2])
	end

	--Destroy hair
	if cabelo[player] then
		excluirShader(player, "cabelo")
		if isElement(cabelo[player]) then
			destroyElement(cabelo[player])
		end
		cabelo[player] = nil
	end

	--Destroy face
	for category, v in pairs(characterClothes[genre]["face"]) do
		removeTextureFace(player, category, tabelaRoupas[genre]["facetextures"][category][1][3])
	end

	--Destroy tatoo
	--for category, v in pairs(characterClothes[genre]["tatoo"]) do
		--removeTextureFace(player, category, tabelaRoupas[genre]["tatoo"..category][1][3])
	--end

	--Destroy clothes
	for category, v in pairs(characterClothes[genre]["clothes"]) do
		excluirShader(player, category)--CATEGORIA DA ROUPA, NOME DA TEXTURA DA ROUPA
	end

	--Destroy duty clothes
	if dutyClothes then
		for category, id in pairs(dutyClothes[genre]) do
			excluirShader(player, category)
		end
	end

	if removeClothes then
		setElementData(player, "characterClothes", nil)
	end

	if removeDutyClothes then
		setElementData(player, "dutyClothes", nil)
	end

	for category, v in pairs(shaders[player]) do
		if isElement(v) then
			destroyElement(v)
		end
	end

	shaders[player] = nil
end
createEvent("unloadCharacter", root, unloadCharacter)

function reloadCharacter(player, time, response, removeClothes, removeDutyClothes)
	unloadCharacter(player, removeClothes, removeDutyClothes)
	loadCharacter(player, time, response)
end
createEvent("reloadCharacter", root, reloadCharacter)

function changeGenre(player, newGenre)
    local oldGenre = getElementData(player, "characterGenre")
    if oldGenre == newGenre then return false end

	reloadCharacter(player, 900, true)

	setElementData(player, "characterGenre", newGenre)
	setElementModel(player, newGenre)
	
	return true
end

function changeSkinColor(player, newColor)
    local oldColor = getElementData(player, "characterSkinColor")
    if oldColor == newColor then return false end
	local genre = getElementData(player, "characterGenre")

	--Destroy
	for _, v in pairs(corpo[genre]) do
		excluirShader(player, v[2])
	end

	--Create
	for i, v in pairs(corpo[genre]) do
		applyShader(player, "body", v[1], v[2], false, newColor)
	end

	setElementData(player, "characterSkinColor", newColor)
	
    --loadCharacter(player, 900, true)
	return true
end

addEventHandler("onClientElementDestroy", root, function()
	if not cabelo[source] then return end
	if not isElement(cabelo[source]) then return end
	destroyElement(cabelo[source])
	cabelo[source] = nil
end)


interface.positions = {

	{91, 278, 48, 36, 'left', index = 1};
	{91, 380, 48, 36, 'left', index = 2};
	{91, 482, 48, 36, 'left', index = 3};
	{91, 584, 48, 36, 'left', index = 4};
	{91, 686, 48, 36, 'left', index = 5};

	{309, 278, 48, 36, 'right', index = 1};
	{309, 380, 48, 36, 'right', index = 2};
	{309, 482, 48, 36, 'right', index = 3};
	{309, 584, 48, 36, 'right', index = 4};
	{309, 686, 48, 36, 'right', index = 5};
}

interface.categorys = {
	
	{204, 240, 39, 14, 1, "Barbas", "barbas"},
	{204, 342, 39, 14, 1, "Tom de pele", "skincolor"},
	{202, 444, 45, 14, 1, "Cabelo", "lowhair", "face"},
	{182, 546, 85, 14, 1, "Sombrancelha", "eyebrows", "face"},
	{178, 648, 93, 14, 1, "Cor dos olhos", "eyes", "face"},

}

interface.sexo = {
	{167, 902, 112, 39, label = 'MASCULINO', gender = 1};
	{279, 902, 112, 39, label = 'FEMININO', gender = 2};
}

function showCreateCharacter()
	unloadCharacter(localPlayer)

	setElementAlpha(localPlayer,0)
	local pos = assets.positionCreateCharacter
	setElementPosition(localPlayer, 1216.31640625, -2036.9384765625, 67.293296813965)
	setCameraMatrix(assets.positionCreateCharacter.x + 1, assets.positionCreateCharacter.y - 0.3, assets.positionCreateCharacter.z + 0.9, assets.positionCreateCharacter.x - 1, assets.positionCreateCharacter.y - 0.3, assets.positionCreateCharacter.z + 0.3)
	setElementData(localPlayer, "characterClothes", defaultCharacter)
	setElementData(localPlayer, "characterGenre", 1)
	setElementData(localPlayer, "characterSkinColor", 1)
	setElementInterior(localPlayer, 0)
	setElementFrozen(localPlayer, true)

	assets.creationData = {}

	assets.creationData.pedPreview = createCustomPed(assets.positionCreateCharacter.x, assets.positionCreateCharacter.y, assets.positionCreateCharacter.z)
	if not assets.creationData.pedPreview then return false end
	setElementInterior(assets.creationData.pedPreview, 0)
	setElementDimension(assets.creationData.pedPreview, getElementDimension(localPlayer))
	setElementFrozen(assets.creationData.pedPreview, true)
	setElementRotation(assets.creationData.pedPreview, 0, 0, assets.rotationCreateCharacter)
	setPedAnimation(assets.creationData.pedPreview, "DANCING", "dnce_M_b", -1,true,false,false,false)
	
	setTimer(function()
		openCreationPanel()
    end,3000,1)
end

function openCreationPanel()

	assets.mouseTick = getTickCount()
	
	for i, v in ipairs (interface.categorys) do 
		assets.creationData[i] = {}
		assets.creationData[i].selected = 1
		if v[7] == "skincolor" then
			assets.creationData[i].limit = #tabelaRoupas[1]["skincolor"]
		else
			assets.creationData[i].limit = #tabelaRoupas[1]["facetextures"][v[7]]
		end
	end

	hair = {
		id = 1, 
		color = 1,
	}

	addEventHandler("onClientRender", root, renderCreation)
	addEventHandler("onClientClick", root, clickCreation)

	showCursor(true)
end

function closeCreationPanel()
	removeEventHandler("onClientRender", root, renderCreation)
	removeEventHandler("onClientClick", root, clickCreation)

	setCameraTarget (localPlayer)
	destroyPed(assets.creationData.pedPreview)
	assets.creationData = nil
	assets.mouseTick = nil

	showCursor(false)
end

function renderCreation()
	
	dxDrawText(
		"CRIAÇÃO DE PERSONAGEM", 32, 118, 256, 24, tocolor(255, 255, 255, 255), 1, exports['guetto_assets']:dxCreateFont('bold', 20), 'left', 'top'
	)

	dxDrawText(
		"Tenha um visual unico, crie escolha as\ncaracteristicas fisicas do seu personagem.", 32, 147, 265, 36, tocolor(188, 184, 184, 255), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'left', 'top'
	)

	dxDrawImage(
		32, 221, 383, 626, interface.svgs['rectangle-main'], 0, 0, 0, tocolor(255, 255, 255, 255)
	)

	local genero = getElementData(assets.creationData.pedPreview, "characterGenre")

	for i = 1, #interface.categorys do 
		local v = interface.categorys[i]
		
		dxDrawText(
			string.upper(v[6]), v[1], v[2], v[3], v[4], tocolor(255, 255, 255, 255), 1, exports['guetto_assets']:dxCreateFont('regular', 12), 'center', 'top'
		)

		if (genero ==  1) then 
			dxDrawText(
				assets.creationData[i].selected, v[1], v[2] + 45, v[3], v[4], tocolor(255, 255, 255, 255), 1, exports['guetto_assets']:dxCreateFont('regular', 12), 'center', 'top'
			)
		else
			if ( v[6] ==  "Cabelo" ) then 
				dxDrawText(
					hair.id, v[1], v[2] + 45, v[3], v[4], tocolor(255, 255, 255, 255), 1, exports['guetto_assets']:dxCreateFont('regular', 12), 'center', 'top'
				)
			else
				dxDrawText(
					assets.creationData[i].selected, v[1], v[2] + 45, v[3], v[4], tocolor(255, 255, 255, 255), 1, exports['guetto_assets']:dxCreateFont('regular', 12), 'center', 'top'
				)
			end
		end

	end

	for index, value in ipairs (interface.positions) do
		local x, y, w, h = value[1], value[2], value[3], value[4];

		dxDrawImage(x, y, w, h, interface.svgs['rectangle-slot'], 0, 0, 0, isCursorOnElement(x, y, w, h) and tocolor(158, 158, 158, 255) or tocolor(193, 195, 196, 255))
		dxDrawImage(x + w / 2 - 28 / 2, y + h / 2 - 28 /2, 28, 28, interface.svgs['icon-arrow'], value[5] == 'left' and 0 or 180, 0, 0, tocolor(255, 255, 255, 255))

		dxDrawRectangle(94, y + h - 1, 260, 1, tocolor(193, 195, 196, 255))
	end

	dxDrawImage(
		116, 763, 215, 46, interface.svgs['rectangle-confirm'], 0, 0, 0, isCursorOnElement(116, 763, 215, 46) and tocolor (94, 140, 79, 255) or tocolor(120, 188, 98, 255)
	)

	dxDrawImage(
		32, 880, 383, 82, interface.svgs['rectangle-sexo'], 0, 0, 0, tocolor(255, 255, 255, 255)
	)
	
	dxDrawText(
		"Sexo:", 69, 912, 36, 18, tocolor(255, 255, 255, 255), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'left', 'top'
	)

	dxDrawText(
		string.upper("CONFIRMAR"), 116, 763, 215, 46, tocolor(255, 255, 255, 255), 1, exports['guetto_assets']:dxCreateFont('bold', 16), 'center', 'center'
	)

	for i, v in ipairs(interface.sexo) do 
		local x, y, w, h = v[1], v[2], v[3], v[4];

		dxDrawImage(
			x, y, w, h, interface.svgs['button-sexo'], 0, 0, 0, genero == v.gender and tocolor(71, 114, 177, 255) or isCursorOnElement(x, y, w, h) and tocolor(71, 114, 177, 255) or tocolor(41, 43, 45, 255)
		)

		dxDrawText(
			v.label, x, y, w, h, tocolor(255, 255, 255, 255), 1, exports['guetto_assets']:dxCreateFont('regular', 12), 'center', 'center'
		)
	end

end


function clickCreation(button,state,x,y,wx,wy,wz,clickElement)
    if button == "left" and state == "down" then
		local character = getElementData(localPlayer, "characterClothes")
		for i, v in ipairs(interface.sexo) do 
			local x, y, w, h = v[1], v[2], v[3], v[4];
			if isCursorOnElement(x, y, w, h) then 
				changeGenre(assets.creationData.pedPreview, v.gender)
				break 
			end
		end
		if isCursorOnElement(116, 763, 215, 46) then 
			triggerServerEvent("Conner.finalizarPersonagem", resourceRoot, getElementData(assets.creationData.pedPreview, "characterClothes"), getElementData(assets.creationData.pedPreview, "characterGenre"), getElementData(assets.creationData.pedPreview, "characterSkinColor"))
			closeCreationPanel()
		end
		for index, value in ipairs (interface.positions) do
			local x, y, w, h = value[1], value[2], value[3], value[4];
			if isCursorOnElement(x, y, w, h) then 
				if value[5] == 'right' then 
					local genero = getElementData(assets.creationData.pedPreview, "characterGenre")
					if assets.creationData[value.index].selected >= assets.creationData[value.index].limit then
						assets.creationData[value.index].selected = 1
					else
						assets.creationData[value.index].selected = assets.creationData[value.index].selected + 1
					end
					if interface.categorys[value.index][7] == "skincolor" then
						changeSkinColor(assets.creationData.pedPreview, assets.creationData[value.index].selected)
					else
						if (genero == 1) then 
							applyShader(assets.creationData.pedPreview, interface.categorys[value.index][8], assets.creationData[value.index].selected, interface.categorys[value.index][7])
							setNewCharacterData(assets.creationData.pedPreview, interface.categorys[value.index][8], interface.categorys[value.index][7], assets.creationData[value.index].selected)
						else
							if ( interface.categorys[value.index][6] ==  "Cabelo" ) then 
								hair.id  = hair.id  + 1
								if hair.id > #tabelaRoupas[genero]["cabelos"] then 
									hair.id = 1
									return
								end
								criarCabelo(assets.creationData.pedPreview, false, tabelaRoupas[genero]["cabelos"][hair.id][hair.color][3])
								applyShader(assets.creationData.pedPreview, "hair", hair.id, false, false, hair.color)
							else
								applyShader(assets.creationData.pedPreview, interface.categorys[value.index][8], assets.creationData[value.index].selected, interface.categorys[value.index][7])
								setNewCharacterData(assets.creationData.pedPreview, interface.categorys[value.index][8], interface.categorys[value.index][7], assets.creationData[value.index].selected)
							end
						end
					end
				elseif value[5] == 'left' then 
					local genero = getElementData(assets.creationData.pedPreview, "characterGenre")
					if assets.creationData[value.index].selected <= 1 then
						assets.creationData[value.index].selected = 1
					else
						assets.creationData[value.index].selected = assets.creationData[value.index].selected - 1
					end
					if interface.categorys[value.index][7] == "skincolor" then
						changeSkinColor(assets.creationData.pedPreview, assets.creationData[value.index].selected)
					else
						if (genero == 1) then -- Homem
							applyShader(assets.creationData.pedPreview, interface.categorys[value.index][8], assets.creationData[value.index].selected, interface.categorys[value.index][7])
							setNewCharacterData(assets.creationData.pedPreview, interface.categorys[value.index][8], interface.categorys[value.index][7], assets.creationData[value.index].selected)
						else
							if ( interface.categorys[value.index][6] ==  "Cabelo" ) then 
								if (hair.id <= 1) then 
									hair.id = 1
								else
									hair.id = hair.id - 1
								end
								criarCabelo(assets.creationData.pedPreview, false, tabelaRoupas[genero]["cabelos"][hair.id][hair.color][3])
								applyShader(assets.creationData.pedPreview, "hair", hair.id, false, false, hair.color)
							else
								applyShader(assets.creationData.pedPreview, interface.categorys[value.index][8], assets.creationData[value.index].selected, interface.categorys[value.index][7])
								setNewCharacterData(assets.creationData.pedPreview, interface.categorys[value.index][8], interface.categorys[value.index][7], assets.creationData[value.index].selected)
							end
						end
					end
				end
				break 
			end
		end

	end
end


function canUseShop()
	local model = getElementModel(localPlayer)
	if isPedInVehicle(localPlayer) then return false end
	if skinsCustom[model] then
		if skinsCustom[model] == "woman" or skinsCustom[model] == "man" then
			return true
		end
	end
	return false
end

createEvent("onPlayerCreateCharacter", resourceRoot, function ( )
	showCreateCharacter()
end)

engineStreamingFreeUpMemory(104857600) 


