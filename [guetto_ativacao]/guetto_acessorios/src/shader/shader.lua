local shader = {}
local textures = {}
local shaderdata = [[
	texture tex;
	technique replace {
		pass P0 {
			Texture[0] = tex;
		}
	}
]]

function createAllTextures()
	for category, _ in pairs(acessorios) do
		for i, v in pairs(acessorios[category]) do
			if v.diretorio and v.diretorio ~= "" then
				textures[v.diretorio] = dxCreateTexture(string.format(":%s", v.diretorio), "dxt1", false, "wrap")
			end
		end
	end
end

createAllTextures()

function createShader(element, diretorio, textureName)
	local textura = textures[diretorio]
	if not textura then return false end
	if not isElement(element) then return end
	if not isElementStreamedIn(element) then return end
	shader[element] = dxCreateShader(shaderdata, 0, 90, false)
	engineApplyShaderToWorldTexture(shader[element], textureName, element)
	dxSetShaderValue(shader[element], "tex", textura)
	return shader[element]
end

function destroyShader(element)
	if not shader[element] then return end
	engineRemoveShaderFromWorldTexture(shader[element], "*")
	destroyElement(shader[element])
	shader[element] = nil
end

function onChangeDataTexture(theKey, oldValue, newValue)
    if getElementType(source) ~= "object" or theKey ~= "accessorieTexture" then return end
	local data = getElementData(source, "accessorieTexture")
	if data then
		setTimer(function(source)
			createShader(source, data.directory, data.texturename)
		end, 70, 1, source)
	else
		destroyShader(source)
	end
end
addEventHandler("onClientElementDataChange", root, onChangeDataTexture)

addEventHandler("onClientElementStreamOut", getRootElement(), function() 
	if getElementType(source) ~= "object" then return end
	if not shader[source] then return end
	if isElement(shader[source]) then
		destroyElement(shader[source])
	end
	shader[source] = nil
end)

addEventHandler("onClientElementStreamIn", getRootElement(), function()
    if getElementType(source) ~= "object" then return end
	if shader[source] then return end
	local data = getElementData(source, "accessorieTexture")
	if not data then return end
	createShader(source, data.directory, data.texturename)
end)

addEventHandler("onClientElementDestroy", getRootElement(), function()
	if getElementType(source) ~= "object" then return end
	if not shader[source] then return end
	destroyShader(source)
end)