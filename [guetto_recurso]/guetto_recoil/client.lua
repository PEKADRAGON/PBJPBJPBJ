function recoil()
	local rotation = 360 - getPedCameraRotation(localPlayer)
	if math.random(1, 2) == 1 then
		setPedCameraRotation(localPlayer, rotation + 0.35)
	else
		setPedCameraRotation(localPlayer, rotation - 0.35)
	end
end
addEventHandler("onClientPlayerWeaponFire", localPlayer, recoil)