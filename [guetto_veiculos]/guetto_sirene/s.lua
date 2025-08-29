local vehicleLightsTimer = {} -- darin werden alle Fahrzeuge und Timer gespeichert, deren Sirenen angeschaltet sind.

function toggleVehicleLights(vehicle) 
    if not isElement(vehicle) then return end
	local model = getElementModel(vehicle)
	--[[if getVehicleOverrideLights(vehicle) ~= 2 then 
		setVehicleOverrideLights(vehicle, 2)
		local type = vehiclesSirenSound[model].type

		if type == "emergency" then 
			vehicleLightsEmergency(vehicle)
		elseif type == "yellow" then 
			vehicleLightsYellow(vehicle) 
		elseif type == "undercover" then 
			vehicleLightsUndercover(vehicle) 
		elseif type == "police" then 
			vehicleLightsPolice(vehicle) 
		end 
	else
		if isTimer(vehicleLightsTimer[vehicle]) then
			killTimer(vehicleLightsTimer[vehicle])
			vehicleLightsTimer[vehicle] = nil
		end
		setVehicleOverrideLights(vehicle, 1)
	end]]

	if hasStrobe(model) then	
		createStrobe(vehicle, model)		
	end	
end
addEvent("toggleVehicleLights", true)
addEventHandler("toggleVehicleLights", resourceRoot, toggleVehicleLights)

function vehicleLightsPolice(vehicle)
	if not isElement(vehicle) then return end
	rotRechts(vehicle)
	vehicleLightsTimer[vehicle] = setTimer(blauLinks,300,1,vehicle)
	vehicleLightsTimer[vehicle] = setTimer(lichtAus,500,1,vehicle)
	vehicleLightsTimer[vehicle] = setTimer(lichtWeiss,600,1,vehicle)
	vehicleLightsTimer[vehicle] = setTimer(lichtAus,700,1,vehicle)
	vehicleLightsTimer[vehicle] = setTimer(lichtWeiss,800,1,vehicle)
	vehicleLightsTimer[vehicle] = setTimer(lichtAus,900,1,vehicle)
	vehicleLightsTimer[vehicle] = setTimer(blauLinks,1300,1,vehicle)
	vehicleLightsTimer[vehicle] = setTimer(rotRechts,1600,1,vehicle)
	vehicleLightsTimer[vehicle] = setTimer(lichtAus,1800,1,vehicle)
	vehicleLightsTimer[vehicle] = setTimer(lichtWeiss,1900,1,vehicle)
	vehicleLightsTimer[vehicle] = setTimer(lichtAus,2000,1,vehicle)
	vehicleLightsTimer[vehicle] = setTimer(lichtWeiss,2100,1,vehicle)
	vehicleLightsTimer[vehicle] = setTimer(lichtAus,2200,1,vehicle)
	vehicleLightsTimer[vehicle] = setTimer(vehicleLightsPolice,2500,1,vehicle)
end

function vehicleLightsUndercove(vehicle)
	if not isElement(vehicle) then return end
	rotRechts(vehicle)
	vehicleLightsTimer[vehicle] = setTimer(lichtAus,100,1,vehicle)
	vehicleLightsTimer[vehicle] = setTimer(rotRechts,250,1,vehicle)
	vehicleLightsTimer[vehicle] = setTimer(lichtAus,350,1,vehicle)
	vehicleLightsTimer[vehicle] = setTimer(blauLinks,750,1,vehicle)
	vehicleLightsTimer[vehicle] = setTimer(lichtAus,850,1,vehicle)
	vehicleLightsTimer[vehicle] = setTimer(blauLinks,1000,1,vehicle)
	vehicleLightsTimer[vehicle] = setTimer(lichtAus,1100,1,vehicle)
	vehicleLightsTimer[vehicle] = setTimer(vehicleLightsUndercover,1500,1,vehicle)
end

function vehicleLightsEmergency (vehicle)
	if not isElement(vehicle) then return end
	rotLinks(vehicle)
	vehicleLightsTimer[vehicle] = setTimer(rotRechts,200,1,vehicle)
	vehicleLightsTimer[vehicle] = setTimer(lichtWeiss,400,1,vehicle)
	vehicleLightsTimer[vehicle] = setTimer(rotRechts,600,1,vehicle)
	vehicleLightsTimer[vehicle] = setTimer(rotLinks,800,1,vehicle)
	vehicleLightsTimer[vehicle] = setTimer(lichtWeiss,1000,1,vehicle)
	vehicleLightsTimer[vehicle] = setTimer(vehicleLightsEmergency,1200,1,vehicle)
end

function vehicleLightsYellow(vehicle)
	if not isElement(vehicle) then return end
	gelbRechts(vehicle)
	vehicleLightsTimer[vehicle] = setTimer(gelbLinks,300,1,vehicle)
	vehicleLightsTimer[vehicle] = setTimer(rotLinks,600,1,vehicle)
	vehicleLightsTimer[vehicle] = setTimer(rotRechts,900,1,vehicle)
	vehicleLightsTimer[vehicle] = setTimer(vehicleLightsYellow,1200,1,vehicle)
end

--alle Lichteinstellungen findet man hier

function rotRechts(vehicle)
	if not isElement(vehicle) then return end
	setVehicleLightState( vehicle,0,0)
	setVehicleLightState(vehicle,3,0)
	setVehicleLightState( vehicle,1,1)
	setVehicleLightState(vehicle,2,1)
	setVehicleHeadLightColor( vehicle, 255,0,0,255)
end

function rotLinks(vehicle)
	if not isElement(vehicle) then return end
	setVehicleLightState( vehicle,0,1)
	setVehicleLightState(vehicle,3,1)
	setVehicleLightState( vehicle,1,0)
	setVehicleLightState(vehicle,2,0)
	setVehicleHeadLightColor( vehicle, 255,0,0,255)
end

function blauRechts(vehicle)
	if not isElement(vehicle) then return end
	setVehicleLightState( vehicle,0,0)
	setVehicleLightState(vehicle,3,0)
	setVehicleLightState( vehicle,1,1)
	setVehicleLightState(vehicle,2,1)
	setVehicleHeadLightColor( vehicle, 0,0,255,255)
end

function blauLinks(vehicle)
	if not isElement(vehicle) then return end
	setVehicleLightState( vehicle,0,1)
	setVehicleLightState(vehicle,3,1)
	setVehicleLightState( vehicle,1,0)
	setVehicleLightState(vehicle,2,0)
	setVehicleHeadLightColor( vehicle, 0,0,255,255)
end

function gelbRechts(vehicle)
	if not isElement(vehicle) then return end
	setVehicleLightState( vehicle,0,1)
	setVehicleLightState(vehicle,3,1)
	setVehicleLightState( vehicle,1,0)
	setVehicleLightState(vehicle,2,0)
	setVehicleHeadLightColor( vehicle, 255,132,0,255)
end

function gelbLinks(vehicle)
	if not isElement(vehicle) then return end
	setVehicleLightState( vehicle,0,0)
	setVehicleLightState(vehicle,3,0)
	setVehicleLightState( vehicle,1,1)
	setVehicleLightState(vehicle,2,1)
	setVehicleHeadLightColor( vehicle, 255,132,0,255)
end

function lichtWeiss(vehicle)
	if not isElement(vehicle) then return end
	setVehicleLightState( vehicle,0,0)
	setVehicleLightState(vehicle,3,0)
	setVehicleLightState( vehicle,1,0)
	setVehicleLightState(vehicle,2,0)
	setVehicleHeadLightColor( vehicle, 255,255,255,255)
end

function lichtAus(vehicle)
	if not isElement(vehicle) then return end
	setVehicleLightState(vehicle,0,1)
	setVehicleLightState(vehicle,3,1)
	setVehicleLightState(vehicle,1,1)
	setVehicleLightState(vehicle,2,1)
end

--

local markersStrobe = {}
local markerTimerOff = {}
local markerTimerLights = {}

local posStrobe = {
--[[
	[597] = {
		[1] = Vector3(0.6, -0.1, 0.86),
		[2] = Vector3(0.2, 0.07, 0.86),
		[3] = Vector3(-0.2, 0.07, 0.86),
		[4] = Vector3(-0.6, -0.1, 0.86),
	},
	[596] = {
		[1] = Vector3(0.6, -0.18, 1.35),
		[2] = Vector3(0.2, 0.04, 1.35),
		[3] = Vector3(-0.2, 0.04, 1.35),
		[4] = Vector3(-0.6, -0.18, 1.35),
	},
]]
}

function createStrobe(vehicle, model)
	if not markersStrobe[vehicle] then
		markersStrobe[vehicle] = {			
			m1 = createMarker(0,0,0, "corona", 0.3, 255,255,255,255), 
			m2 = createMarker(0,0,0, "corona", 0.3, 255,255,255,255),
			m3 = createMarker(0,0,0, "corona", 0.3, 255,255,255,255), 
			m4 = createMarker(0,0,0, "corona", 0.3, 255,255,255,255)
		}
		
		attachElements(markersStrobe[vehicle].m1,vehicle, posStrobe[model][1])
		attachElements(markersStrobe[vehicle].m2,vehicle, posStrobe[model][2])
		attachElements(markersStrobe[vehicle].m3,vehicle, posStrobe[model][3])
		attachElements(markersStrobe[vehicle].m4,vehicle, posStrobe[model][4])

		timerMarkerLights(vehicle)
	else
        destroyStrobe(vehicle)
	end
end

function destroyStrobe(vehicle)
	destroyElement(markersStrobe[vehicle].m1)
	destroyElement(markersStrobe[vehicle].m2)
	destroyElement(markersStrobe[vehicle].m3)
	destroyElement(markersStrobe[vehicle].m4)
	markersStrobe[vehicle] = nil

	if isTimer(markerTimerOff[vehicle]) then killTimer(markerTimerOff[vehicle]) end
	markerTimerOff[vehicle] = nil

	if isTimer(markerTimerLights[vehicle]) then killTimer(markerTimerLights[vehicle]) end
	markerTimerLights[vehicle] = nil
end

function timerMarkerLights(vehicle)
	lightsMarkerOn(vehicle)
	markerTimerOff[vehicle] = setTimer(lightsMarkerOff, 500, 1, vehicle)
	markerTimerLights[vehicle] = setTimer(timerMarkerLights, 1000, 1, vehicle)
end

function lightsMarkerOn(vehicle)
	if isElement(vehicle) then
		setMarkerColor(markersStrobe[vehicle].m1, 255,0,0,80)
		setMarkerColor(markersStrobe[vehicle].m2, 0,0,255,80)
		setMarkerColor(markersStrobe[vehicle].m3, 0,0,255,80)
		setMarkerColor(markersStrobe[vehicle].m4, 255,0,0,80)
	else 
		destroyStrobe(vehicle)
	end
end

function lightsMarkerOff(vehicle)
	if isElement(vehicle) then
		if not markersStrobe[vehicle] then return end
		setMarkerColor(markersStrobe[vehicle].m1, 0,0,255,80)
		setMarkerColor(markersStrobe[vehicle].m2, 255,0,0,80)
		setMarkerColor(markersStrobe[vehicle].m3, 255,0,0,80)
		setMarkerColor(markersStrobe[vehicle].m4, 0,0,255,80)
	else 
		destroyStrobe(vehicle)
	end
end

function hasStrobe(model)
	if posStrobe[model] then
		return true
	end
	return false
end

addEventHandler("onElementDestroy", root, function()
	if getElementType(source) ~= "vehicle" then return end
	if not markersStrobe[source] then return end
	destroyStrobe(source)
end)