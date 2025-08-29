local shaders = {}
local textura = {}

function setTexJBL(element, texture)
	if texture == "0" then
		destroyElement(shaders[element])
	else
		if element and texture then
			shaders[element] = dxCreateShader("assets/shader/texturechanger.fx")
			textura[element] = dxCreateTexture("assets/texturas/" .. texture .. ".png")

			if shaders[element] and textura[element] then
				dxSetShaderValue(shaders[element], "TEXTURE", textura[element])
				engineApplyShaderToWorldTexture(shaders[element], "JBL", element)
			end
		end
	end
end
addEvent("client->applyTextureJBL", true)
addEventHandler("client->applyTextureJBL", root, setTexJBL)