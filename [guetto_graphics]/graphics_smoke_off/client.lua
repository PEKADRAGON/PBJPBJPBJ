local shader = nil

addEventHandler("onClientResourceStop", resourceRoot,
function()
	destroyShaders ()
end)

function setShaders()
	shader = dxCreateShader("texreplace.fx")
	if shader then
		engineApplyShaderToWorldTexture(shader, "collisionsmoke")
	end
end


function destroyShaders()
	if shader then
		engineRemoveShaderFromWorldTexture(shader,"collisionsmoke")
		destroyElement(shader)
		shader = nil
	end
	collectgarbage()
end

addEventHandler ("onClientElementDataChange", root, function(db, _, new)
	if source ~= localPlayer then return end
	if db ~= "shaders:smoke" then return end
	if new then
		setShaders()
	else
		destroyShaders()
	end
end)