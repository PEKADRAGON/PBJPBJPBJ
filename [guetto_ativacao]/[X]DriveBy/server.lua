-----------------------------------------------------------------------------------------------------------------------------------------
allowedWeapons = {
	[22] = true,
	[24] = true,
	[25] = true,
	[29] = true,
	[32] = true,
	[30] = true,
	[31] = true,
}

allowedWeaponsP1 = {
	[22] = true;
	[23] = true;
	[24] = true;
}

-----------------------------------------------------------------------------------------------------------------------------------------
function driveBy(playerSource, _, state)
	if isPedInVehicle(playerSource) then
		if getPedOccupiedVehicleSeat(playerSource) ~= 0 then
			if state == "down" then
				if not isPedDoingGangDriveby(playerSource) then
					local weapon = getPedWeapon(playerSource)
					if allowedWeapons[weapon] then
						setPedWeaponSlot(playerSource, 0)
						setPedDoingGangDriveby(playerSource, true)
						setPedWeaponSlot(playerSource, getSlotFromWeapon(weapon))
					end
				end
			elseif state == "up" then
				if isPedDoingGangDriveby(playerSource) then
					setPedDoingGangDriveby(playerSource, false)
				end
			end
		else
			if state == 'down' then 
				if not isPedDoingGangDriveby(playerSource) then
					local weapon = getPedWeapon(playerSource)
					if allowedWeaponsP1[weapon] and getVehicleType(getPedOccupiedVehicle(playerSource)) == "Bike" then
						setPedWeaponSlot(playerSource, 0)
						setPedDoingGangDriveby(playerSource, true)
						setPedWeaponSlot(playerSource, getSlotFromWeapon(weapon))
					end
				end
			elseif state == "up" then
				if isPedDoingGangDriveby(playerSource) then
					setPedDoingGangDriveby(playerSource, false)
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
function onStart()
	for _, players in pairs(getElementsByType("player")) do
		bindKey(players, "mouse2", "both", driveBy)
	end
end
addEventHandler("onResourceStart", resourceRoot, onStart)
-----------------------------------------------------------------------------------------------------------------------------------------
function onLogin()
	if not isKeyBound(source, "mouse2", "both", driveBy) then
		bindKey(source, "mouse2", "both", driveBy)
	end
end
addEventHandler("onPlayerLogin", root, onLogin)
-----------------------------------------------------------------------------------------------------------------------------------------