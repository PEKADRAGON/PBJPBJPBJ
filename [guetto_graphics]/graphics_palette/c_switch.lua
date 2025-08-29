function switchSColorShader(el_data_key, new_data)
    	if (el_data_key == "shader:colors") then
    	if getElementData(localPlayer, el_data_key) then
			enablePalette()
		else
			disablePalette()
		end
    end
end
addEventHandler("onClientElementDataChange", root, switchSColorShader)

