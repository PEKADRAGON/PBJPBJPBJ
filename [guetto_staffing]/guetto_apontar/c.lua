bindKey("mouse2", "both", function(key, state)
	if getElementData(localPlayer, "cuffedBy") then return end
	if getElementHealth(localPlayer) <= 30 then return end
	if getPedOccupiedVehicle(localPlayer) then return end
	if state == "down" then
	local pedSlot = getPedWeaponSlot(localPlayer)
	if pedSlot ~= 0 then return end
		triggerServerEvent("pointTheFinger", resourceRoot)

		toggleControl("fire", false)
		toggleControl("action", false) 
		setPedControlState("fire", false)

		setElementData(localPlayer, "pointFinger", true)

		setPlayerHudComponentVisible("crosshair", false)
	else
	if not getElementData(localPlayer, "pointFinger") then return end
		triggerServerEvent("stopPointTheFinger", resourceRoot)

		setElementData(localPlayer, "pointFinger", nil)

		toggleControl("fire", true)
		toggleControl("action", true) 

		setPedWeaponSlot(localPlayer, 0)

		setPlayerHudComponentVisible("crosshair", true)
	end
end)

local txd = engineLoadTXD("files/invisible.txd", 350)
engineImportTXD(txd, 350)
local dff = engineLoadDFF("files/invisible.dff", 350)
engineReplaceModel(dff, 350)