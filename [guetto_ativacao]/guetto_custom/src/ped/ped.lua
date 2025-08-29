function createCustomPed(x, y, z, time, data)
	if not x or not y or not z then return false end
	local ped = false
	if not data then
		local genre = getElementData(localPlayer, "characterGenre")
		ped = createPed(genre, x, y, z)
		setElementData(ped, "characterGenre", genre)
		setElementData(ped, "characterSkinColor", getElementData(localPlayer, "characterSkinColor"))
		setElementData(ped, "characterClothes", getElementData(localPlayer, "characterClothes"))

		loadCharacterPed(ped, time)
	else
		ped = createPed(data.genre, x, y, z)
		setElementData(ped, "characterGenre", data.genre)
		setElementData(ped, "characterSkinColor", data.skinColor)
		setElementData(ped, "characterClothes", data.clothes or defaultCharacter)

		loadCharacterPed(ped, time, data.response)
	end
	return ped
end

function destroyPed(ped)
	if not isElement(ped) then return false end
	unloadCharacter(ped)
	destroyElement(ped)
	return true
end

function loadCharacterPed(ped, time, setresponsefalse)
	if not ped then return end
	if shaders[ped] then return end
    local genero = getElementData(ped, "characterGenre")
    local cor = getElementData(ped, "characterSkinColor")
    local character = getElementData(ped, "characterClothes")[genero]
    if not character or not cor or not genero then return end

    setTimer(function(cor, genero, ped)
        if not isElement(ped) then return end
        --Load body
        for i, v in pairs(corpo[genero]) do
            applyShader(ped, "body", v[1], v[2], false, cor)
        end

        --Load face
        for i, v in pairs(character["face"]) do
            applyShader(ped, "face", v, i)
        end

        --Load tatoo
        --[[for i, v in pairs(character["tatoo"]) do
            applyShader(ped, "tatoo," v, i)
        end]]

        --Load clothes
        for i, v in pairs(character["clothes"]) do
            if i ~= "casacos" then
                applyShader(ped, "clothe", v, i)
            end
        end
        aplicarCasaco(ped, character["clothes"]["casacos"])

        --Load hair
        if not cabelo[ped] then
            local id = character["hair"]["id"]
            local cor = character["hair"]["color"] or 1
            if id > 1 then
                criarCabelo(ped, false, tabelaRoupas[genero]["cabelos"][id][cor][3])
                applyShader(ped, "hair", id, false, false, cor)
            end
        end


    end, (time or 500), 1, cor, genero, ped)
end