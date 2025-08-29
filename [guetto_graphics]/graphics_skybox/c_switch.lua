function ToggleSkybox( state )
	if state then
		startShaderResource()
	else
		stopShaderResource()
	end
end
addEvent( "ToggleSkybox" )
addEventHandler( "ToggleSkybox", root, ToggleSkybox )

function onSettingsChange_handler( changed, values )
	if changed.skybox then
		if values.skybox then
			startShaderResource()
		else
			stopShaderResource()
		end
	end
end
addEvent( "onSettingsChange" )
addEventHandler( "onSettingsChange", root, onSettingsChange_handler )

addCommandHandler( "skybox",
	function()
		if not (state) then 
			state = true 
			triggerEvent( "ToggleSkybox", resourceRoot, true )
		else
			state = false
			triggerEvent( "ToggleSkybox", resourceRoot, false )
		end
	end
)