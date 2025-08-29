function abseilStart()
	if getElementData(client,"abseiling") then return end
	local veh = getPedOccupiedVehicle(client)
	if not veh then return end
	if getVehicleType(veh) ~= "Helicopter" then return end
	local seat = getPedOccupiedVehicleSeat(client)
	setElementData(client,"abseiling",tostring(seat))
	setElementData(client,"abseilspeed",-0.25)
	
	removePedFromVehicle(client)
	
	--setVehicleDoorState(veh,seat+2,4)
	setVehicleDoorOpenRatio(veh,seat+2,1,500)
	
	local ped = createPed(0,0,0,0)
	warpPedIntoVehicle(ped,veh,seat)
	
	setElementData(client,"abseilped",ped)
	setElementData(ped,"isabseilped",true)
	
	triggerClientEvent("doStartAbseil", resourceRoot, client, veh, seat, ped)
	
	setTimer(abseil,3400,1,client,veh,seat,ped)
end
addEvent("doStartPlayerAbseil", true)
addEventHandler("doStartPlayerAbseil", resourceRoot, abseilStart)

function abseilCancel()
	if getElementData(client,"abseiling") then
		local ped = getElementData(client,"abseilped")
		triggerClientEvent("doCancelAbseil",client)
		if getPedOccupiedVehicleSeat(ped) == 0 then
			triggerClientEvent("doAddVehicleToWatch",getPedOccupiedVehicle(ped))
		else
			if getElementData(ped,"isabseilped") then
				destroyElement(ped)
			end
		end
	end
end
addEvent("doCancelPlayerAbseil", true)
addEventHandler("doCancelPlayerAbseil", resourceRoot, abseilCancel)

function abseil(player,veh,seat,ped)
	setElementData(player,"abseiling", true)
	detachElements(player,ped)
end

addEvent("doSetPos", true)
addEventHandler("doSetPos", resourceRoot, function(x, y, z)
	setElementPosition(client, x, y, z)

	setPedAnimation(client, "ped", "abseil", -1,false,false,false)
	setElementData(client, "animation", {"ped", "abseil"})

	local x,y,z = getElementVelocity(client)
	setElementVelocity(client,x,y,-0.25)
end)

function stopAbseilAnimation(ped)
	setPedAnimation(client)
	removeElementData(client, "animation")
	
	if getPedOccupiedVehicleSeat(ped) == 0 then
		if getElementData(ped,"isabseilped") then
			triggerClientEvent("doAddVehicleToWatch",getPedOccupiedVehicle(ped))
		end
	else
		if getElementData(ped,"isabseilped") then
			destroyElement(ped)
		end
	end
end
addEvent("doForceStopAbseiling",true)
addEventHandler("doForceStopAbseiling", resourceRoot, stopAbseilAnimation)

function deletePiltoDummy(plr)
	local ped = getVehicleOccupant(plr,0)
	if ped then
		if getElementData(ped,"isabseilped") then
			destroyElement(getVehicleOccupant(plr,0))
			triggerClientEvent("doRemoveVehicleToWatch",plr)
		end
	end
end
addEvent("doRemovePilotDummy",true)
addEventHandler("doRemovePilotDummy", resourceRoot, deletePiltoDummy)

function checkForDummiesToDelete()
	local ped = getVehicleOccupant(source,0)
	if ped then
		if getElementType(ped) == "ped" then
			if getElementData(ped,"isabseilped") then
				destroyElement(ped)
			end
		end
	end
end
addEventHandler("onVehicleExplode", root, checkForDummiesToDelete)