--
-- c_switch.lua
--

----------------------------------------------------------------
----------------------------------------------------------------
-- Effect switching on and off
--
--	To switch on:
--			triggerEvent( "switchCarPaintReflectLite", root, true )
--
--	To switch off:
--			triggerEvent( "switchCarPaintReflectLite", root, false )
--
----------------------------------------------------------------
----------------------------------------------------------------

--------------------------------
-- onClientResourceStart
--		Auto switch on at start
--------------------------------

local state = false

addEventHandler( "onClientResourceStart", getResourceRootElement( getThisResource()),
	function()
		outputDebugString('/reflexo to switch the effect')
	end
)

addCommandHandler( "reflexo",
	function()
		if not (state) then 
			state = true 
			triggerEvent( "switchCarPaintReflectLite", resourceRoot, true )
		else
			state = false
			triggerEvent( "switchCarPaintReflectLite", resourceRoot, false )
		end
	end
)


--------------------------------
-- Switch effect on or off
--------------------------------
function switchCarPaintReflectLite( cprlOn )
	outputDebugString( "switchCarPaintReflectLite: " .. tostring(cprlOn) )
	if cprlOn then
		startCarPaintReflectLite()
	else
		stopCarPaintReflectLite()
	end
end

addEvent( "switchCarPaintReflectLite", true )
addEventHandler( "switchCarPaintReflectLite", resourceRoot, switchCarPaintReflectLite )
