--
-- c_switch.lua
--

----------------------------------------------------------------
----------------------------------------------------------------
-- Effect switching on and off
--
--	To switch on:
--			triggerEvent( "switchFxaa", root, 2 )
--
--	To switch off:
--			triggerEvent( "switchFxaa", root, 0 )
--
----------------------------------------------------------------
----------------------------------------------------------------


--------------------------------
-- Switch effect on or off
--------------------------------
function switchFxaa( aaOn )
	if aaOn then
		enableFxaa()
	else
		disableFxaa()
	end
end

addEvent( "switchFxaa", true )
addEventHandler( "switchFxaa", root, switchFxaa )
