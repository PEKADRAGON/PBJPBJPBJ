function switchSBlurShader(el_data_key, new_data)
    if (el_data_key == "shader:blur") then
        if getElementData(localPlayer, el_data_key) then
		enableDoF()
	else
		disableDoF()
	end
    end
end
addEventHandler("onClientElementDataChange", root, switchSBlurShader)