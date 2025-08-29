addEventHandler("onClientResourceStart", resourceRoot, function()
	IFP = engineLoadIFP("files/roll.ifp", "Rolling")
	if IFP then
        outputDebugString("♡ "..getResourceName(getThisResource()).. ": Animação carregada com sucesso, qualquer bug contacte vanessa.021!", 4, 176, 107, 255)
	else
        outputDebugString("♡ "..getResourceName(getThisResource()).. ": Erro no processamento da animação, qualquer bug contacte vanessa.021!", 4, 245, 108, 108)
	end
end)

SetAnimation = function(...)
    setPedAnimation(...);
end
addEvent('animations > SetAnimation',true)
addEventHandler("animations > SetAnimation", root, SetAnimation);

addEventHandler('onClientPreRender', root, function()
    if (isPedAiming(localPlayer)) then
        if (getPedWeapon(localPlayer) == 32) then return end
        if (getPedWeapon(localPlayer) == 22) then return end
        if isPedDead(localPlayer) then return end
        if isPedWearingJetpack(localPlayer) then return end
        if getPedOccupiedVehicle(localPlayer) then return end
        if not isPedOnGround(localPlayer) then return end

        for _, key in pairs({'a', 'w', 'd'}) do
            if (getKeyState(key)) then
                if (getKeyState('lalt')) then
                    if ((getTickCount() - (Rolling or 0)) < 3000) then
                        return
                    end

                    local roll

                    if (key == 'a') then
                        roll = 'Left'
                    elseif (key == 'd') then
                        roll = 'Right'
                    elseif (key == 'w') then
                        roll = 'Front'
                    end

                    triggerServerEvent('animations > SyncRoll', localPlayer, localPlayer, "Rolling", "VRolling_" .. roll, -1, false, true, false, false)
                    Rolling = getTickCount()
                end
            end
        end
    end
end)


function isPedAiming (thePedToCheck)
	if isElement(thePedToCheck) then
		if getElementType(thePedToCheck) == "player" or getElementType(thePedToCheck) == "ped" then
			if getPedTask(thePedToCheck, "secondary", 0) == "TASK_SIMPLE_USE_GUN" or isPedDoingGangDriveby(thePedToCheck) then
				return true
			end
		end
	end
	return false
end