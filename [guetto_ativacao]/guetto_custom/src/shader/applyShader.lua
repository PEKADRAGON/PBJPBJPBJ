local textures = {}
shaders = {}
cabelo = {}

local shaderdata = [[
	texture tex;
	technique replace {
		pass P0 {
			Texture[0] = tex;
		}
	}
]]

function createAllTextures()
	for genre = 1, 2 do
		--Load body textures
		for color=1, #tabelaRoupas[1]["skincolor"] do
			for texture=1, 5 do
				local directory = string.format("assets/images/character/%s/texturascorpo/%s/%s.dds", genre, color, texture)
				if not textures[directory] then
					textures[directory] = dxCreateTexture(directory, "dxt1", false, "wrap")
				end
			end
		end
		--Load clothes textures
		for _, clothes in pairs(tabelaRoupas[genre]["clothes"]) do
			for i, v in pairs(clothes) do
				local directory = v[1]
				if not textures[directory] then
					textures[directory] = dxCreateTexture(directory, "dxt1", false, "wrap")
				end
			end
		end
		--Load face textures
		for _, faces in pairs(tabelaRoupas[genre]["facetextures"]) do
			for i, v in pairs(faces) do
				local directory = v[2]
				if not textures[directory] then
					textures[directory] = dxCreateTexture(directory, "dxt1", false, "wrap")
				end
			end
		end
		--Load hair textures
		for _, hairs in pairs(tabelaRoupas[genre]["cabelos"]) do
			for i, v in pairs(hairs) do
				local directory = v[1]
				if not textures[directory] then
					textures[directory] = dxCreateTexture(directory, "dxt1", false, "wrap")
				end
			end
		end

		--Load clothes faction
		for _, clothes in pairs(tabelaFardas[genre]) do
			for i, v in pairs(clothes) do
				local directory = v[1]
				if not textures[directory] then
					textures[directory] = dxCreateTexture(directory, "dxt1", false, "wrap")
				end
			end
		end
	end
end

createAllTextures()

function getTexture(directory)
	if not directory then return false end
	if textures[directory] then
		return textures[directory]
	end
	return false
end

function criarShader(player, categoria, texturename, type, directory)
	if not shaders[player] then shaders[player] = {} end

	if categoria then
		if isElement(shaders[player][categoria]) then
			engineRemoveShaderFromWorldTexture(shaders[player][categoria], "*")
			destroyElement(shaders[player][categoria])
			shaders[player][categoria] = nil
		end
	end

	if texturename then
		if type == "body" then

			if isElement(shaders[player][texturename]) then
				engineRemoveShaderFromWorldTexture(shaders[player][texturename], "*")
				destroyElement(shaders[player][texturename])
				shaders[player][texturename] = nil
			end
			shaders[player][texturename] = dxCreateShader(shaderdata, 0, 0, false, "ped")
			engineApplyShaderToWorldTexture(shaders[player][texturename], texturename, player)
			if directory then
				aplicarTextura(shaders[player][texturename], directory)
			end

		elseif type == "face" then
			if isElement(shaders[player][categoria]) then
				engineRemoveShaderFromWorldTexture(shaders[player][categoria], "*")
				destroyElement(shaders[player][categoria])
				shaders[player][categoria] = nil
			end
			shaders[player][categoria] = dxCreateShader(shaderdata, 0, 0, true, "ped")
			engineRemoveShaderFromWorldTexture(shaders[player][categoria], "*")
			engineApplyShaderToWorldTexture(shaders[player][categoria], texturename, player)
			if directory then
				aplicarTextura(shaders[player][categoria], directory)
			end

		elseif type == "hair" then
			if isElement(shaders[player]["cabelo"]) then
				engineRemoveShaderFromWorldTexture(shaders[player]["cabelo"], "*")
				destroyElement(shaders[player]["cabelo"])
				shaders[player]["cabelo"] = nil
			end
			shaders[player]["cabelo"] = dxCreateShader(shaderdata, 0, 0, false, "object")
			engineApplyShaderToWorldTexture(shaders[player]["cabelo"], texturename, cabelo[player])
			if directory then
				aplicarTextura(shaders[player]["cabelo"], directory)
			end
			
		elseif type == "other" then
			shaders[player][categoria] = dxCreateShader(shaderdata, 0, 0, false, "ped")
			engineApplyShaderToWorldTexture(shaders[player][categoria], texturename, player)
			if directory then
				aplicarTextura(shaders[player][categoria], directory)
			end
		end
	end
end

function aplicarTextura(shader, directory)
	if not directory or not shader then return end
	local texture = textures[directory]
	if not texture then return end
	dxSetShaderValue(shader, "tex", texture)
end

function excluirShader(player, category)
	if not shaders[player] or not shaders[player][category] then return end
	if isElement(shaders[player][category]) then
		engineRemoveShaderFromWorldTexture(shaders[player][category], "*")
		destroyElement(shaders[player][category])
	end
	shaders[player][category] = nil
end
createEvent("Conner.excluirShader", root, excluirShader)

function removeTextureFace(player, category, texturename)
	local genero = getElementData(player, "characterGenre")
	if not shaders[player] or not shaders[player][category] then return end
	if isElement(shaders[player][category]) then
		engineRemoveShaderFromWorldTexture(shaders[player][category], "*")
		destroyElement(shaders[player][category])
	end
	shaders[player][category] = nil
end

function reconstructBodyPart(player, bodyPart)
	local genero = getElementData(player, "characterGenre")
	local skinColor = getElementData(player, "characterSkinColor")
	for texturename, directory in pairs(tabelaRoupas[genero]["body"][bodyPart]) do
		criarShader(player, false, texturename, "body", string.format("assets/images/character/%s/texturascorpo/%s/%s.dds", genero, skinColor, directory))
	end
end

function removerTextura(player, textura)
	local genero = getElementData(player, "characterGenre")
	if not tabelaRoupas[genero]["removercorpo"][textura] then return end
	for i, directory in pairs(tabelaRoupas[genero]["removercorpo"][textura]) do
		if directory ~= "" then
			excluirShader(player, directory)
		end
	end
end

function aplicarCasaco(player, id, carrinho)-- jogador, diretorio, tipo de roupa(textura), id da roupa(Index de onde é clicado), nome da categoria da roupa
	if not isElement(player) or not isElementStreamedIn(player) then return end
	local genero = getElementData(player, "characterGenre")
	local roupas = getElementData(player,"characterClothes")[genero]
	local textura = tabelaRoupas[genero]["clothes"]["casacos"][id][2]
	--Carregar parte do corpo de onde será aplicado a roupa
	if id <= 1 then--Remover
		excluirShader(player, "casacos")
		reconstructBodyPart(player, "torso")

		--Carregar camisa
		if carrinho then
			camisa = carrinho[1]
		else
			camisa = roupas["clothes"]["camisas"]
		end
		if camisa > 1 then
			local directory = tabelaRoupas[genero]["clothes"]["camisas"][camisa][1]
			local texturename = tabelaRoupas[genero]["clothes"]["camisas"][camisa][2]
			criarShader(player, "camisas", texturename, "other", directory)
			if tabelaRoupas[genero]["removercorpo"][texturename] then
				removerTextura(player, texturename);
			end
		end
	else--Se adicionar o casaco remove a categoria camisa
		excluirShader(player, "camisas")
		if tabelaRoupas[genero]["removercorpo"][textura] then
			removerTextura(player, textura);
		end
		local diretorio = tabelaRoupas[genero]["clothes"]["casacos"][id][1]
		criarShader(player, "casacos", tabelaRoupas[genero]["clothes"]["casacos"][id][2], "other", diretorio)
	end
end
createEvent("Conner.aplicarCasaco", root, aplicarCasaco)

function applyShader(player, type, id, categoria, remover, cor)
	if not isElement(player) or not isElementStreamedIn(player) then return end
	local genero = getElementData(player, "characterGenre")

	if type == "body" then
		criarShader(player, false, categoria, "body", string.format("assets/images/character/%s/texturascorpo/%s/%s.dds", genero, cor, tabelaRoupas[genero]["body"][id][categoria]))

	elseif type == "face" then
		if categoria == "barbas" or categoria == "makeups" then
			categoria = (genero == 1 and "barbas" or "makeups")
		end
		local diretorio = tabelaRoupas[genero]["facetextures"][categoria][id][2]
		local bodyPart = tabelaRoupas[genero]["facetextures"][categoria][id][3]
		local remover = tabelaRoupas[genero]["facetextures"][categoria][id][4]
		
		if remover == "remover" then
			removeTextureFace(player, categoria, bodyPart)
		else
			criarShader(player, categoria, bodyPart, "face", diretorio)
		end

	elseif type == "tatoo" then
		if not string.find(categoria,"tatoo") then
			categoria = "tatoo"..categoria
		end
		local table = tabelaRoupas[genero][categoria]
		local diretorio = table[id][2]
		local bodyPart = table[id][3]
		local remover = table[id][4]
		if remover == "remover" then
			removeTextureFace(player, tatoo, bodyPart)
		else
			criarShader(player, tatoo, bodyPart, "face", diretorio)--"other"
		end

	elseif type == "clothe" then
		local diretorio = tabelaRoupas[genero]["clothes"][categoria][id][1]
		local texturename = tabelaRoupas[genero]["clothes"][categoria][id][2]
		--Carregar parte do corpo de onde será aplicado a roupa
		if tabelaRoupas[genero]["clothes"][categoria][id][3] then
			local bodyPart = tabelaRoupas[genero]["clothes"][categoria][id][3]
			if (bodyPart == "torso" or bodyPart == "pernas" or bodyPart == "pes") then
				reconstructBodyPart(player, bodyPart)
			end
		end
		
		local roupas = getElementData(player,"characterClothes")[genero]
		if categoria == "camisas" then
			if roupas["clothes"]["casacos"] > 1 then
				excluirShader(player, "casacos")
			end
		end
		
		--Remover partes do corpo
		if tabelaRoupas[genero]["removercorpo"][texturename] then
			removerTextura(player, texturename)
		end
		criarShader(player, categoria, tabelaRoupas[genero]["clothes"][categoria][id][2], "other", diretorio)

	elseif type == "dutyclothes" then
		local diretorio = tabelaFardas[genero][categoria][id][1]
		local texturename = tabelaFardas[genero][categoria][id][2]
		--Carregar parte do corpo de onde será aplicado a roupa
		--[[if tabelaFardas[genero][categoria][id][3] then
			local bodyPart = tabelaFardas[genero][categoria][id][3]
			if (bodyPart == "torso" or bodyPart == "pernas" or bodyPart == "pes") then
				reconstructBodyPart(player, bodyPart)
			end
		end]]
		
		--Remover partes do corpo
		if tabelaRoupas[genero]["removercorpo"][texturename] then
			removerTextura(player, texturename)
		end
		criarShader(player, categoria, tabelaFardas[genero][categoria][id][2], "other", diretorio)

	elseif type == "hair" then
		criarShader(player, false, tabelaRoupas[genero]["cabelos"][id][cor][2], "hair", tabelaRoupas[genero]["cabelos"][id][cor][1])
	end
end
createEvent("Conner.applyShader", root, applyShader)

addEventHandler("onClientElementStreamIn", root, function() 
    if getElementType(source) ~= "player" then return end
	loadCharacter(source)
end, true, "low-9999")

addEventHandler("onClientElementStreamOut", root, function() 
	if getElementType(source) ~= "player" or source == localPlayer then return end
	unloadCharacter(source)
end, true, "low-9999")

addEventHandler("onClientPlayerQuit", root, function()
	unloadCharacter(source)
end)

--[[setTimer(function() MEXX
	for plr, _ in pairs(shaders) do
		if not isElementStreamedIn(plr) then
			unloadCharacter(plr)
		end
	end
end, 40000, 0)]]

addCommandHandler("cnrprint",function()
	iprint(shaders)
	outputChatBox ("Used memory by the GTA streamer: "..engineStreamingGetUsedMemory()..".")
end)