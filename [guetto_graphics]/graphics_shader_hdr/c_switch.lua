function onDataChange(theKey, oldValue, newValue)
    if (getElementType(source) == "player") and source == localPlayer and (theKey == "contrast") then
        if newValue == true then
		enableContrast()
	else
		disableContrast()
        end
    end
end
addEventHandler("onClientElementDataChange", root, onDataChange)

addCommandHandler( "hdr",
	function()
		if not (state) then 
			state = true 
            enableContrast()
			--triggerEvent( "switchCarPaintReflectLite", resourceRoot, true )
		else
			state = false
            disableContrast()
			--triggerEvent( "switchCarPaintReflectLite", resourceRoot, false )
		end
	end
)