-----------------------------------------------------------------------------------------------------------------------------------------
markers = {

    {2272.138, -2412.327, 20.718},
	{2291.362, -1929.505, 23.395},
    {2463.076, -1644.585, 23.098},
    {2421.574, -1534.542, 33.673},
	{2440.901, -1268.754, 33.727},
    {2532.296, -1037.87, 79.054},
    {2216.663, -1008.734, 70.607},
    {2083.294, -1230.374, 33.921},
    {1043.246, -1190.24, 31.391},
    {1370.671, -871.447, 39.696},
    {232.116, -1426.375, 23.55},
    {460.119, -1292.578, 25.057},
    {1289.128, -1415.222, 24.687},
    {2007.796, -1330.924, 33.844},
    {2138.81, -1400.391, 33.806},
    {2280.786, -1219.538, 33.933},
    {2542.829, -1246.551, 50.9},
    {2226.389, -1917.344, 13.547},
    {2342.768, -2339.662, 22.108},
    {1951.14, -2156.45, 23.411}
}


marker = {}
blip = {}
veh = {}
colshape = {}
escada1 = {}
guardar = {}

sendMessageServer = function (player, msg, type)
	return exports['guetto_notify']:showInfobox(player, type, msg)
end;

Pickup_Emprego = createPickup ( 2684.459, -1968.198, 13.547, 3, 1210)

-----------------------------------------------------------------------------------------------------------------------------------------
function InfoTrab(playerSource)
	local emprego = getElementData(playerSource, "Emprego") or "Desempregado"
	if emprego == "Eletricista" then
		sendMessageServer(playerSource, "Siga a marcação em sua tela para chegar no seu local de trabalho", 'info')
		triggerClientEvent(playerSource, "togglePoint", playerSource, 2681.397, -1970.831, 13.794)
	end
end
addCommandHandler("trabalho", InfoTrab)
-----------------------------------------------------------------------------------------------------------------------------------------
function startJob(playerSource)
    if not isPedInVehicle(playerSource) then
        local emprego = getElementData(playerSource, "Emprego") or "Desempregado"
        if emprego == "Eletricista" then
            if not isElement(veh[playerSource]) then
            	veh[playerSource] = createVehicle(552, 2696.41, -1969.796, 13.547, 0, 0, 268)
            	colshape[playerSource] = createColSphere(0, 0, 0, 1.5)
            	setElementVisibleTo(colshape[playerSource], root, false)
            	setElementVisibleTo(colshape[playerSource], playerSource, true)
            	attachElements(colshape[playerSource], veh[playerSource], 0, - 3.75, 0.5)
				setElementData(veh[playerSource], 'Owner', playerSource)
            	addEventHandler("onColShapeHit", colshape[playerSource], pickEscada)
				sendMessageServer(playerSource, "Siga a marcação em sua tela para consertar o poste", 'info')
				sendMessageServer(playerSource, "Digite /cancelar para cancelar seu trabalho", 'info')
        		iniciarJob(playerSource)
        	else
				sendMessageServer(playerSource, "Você já está trabalhando, Digite /cancelar para enceerrar", 'error')
        	end
        else
			sendMessageServer(playerSource, "Apenas eletricistas podem trabalhar aqui", 'error')
        end
    end
end
addEventHandler("onPickupHit", Pickup_Emprego, startJob)

-----------------------------------------------------------------------------------------------------------------------------------------
function iniciarJob(playerSource)
	local random = math.random(#markers)
	marker[playerSource] = createMarker(markers[random][1], markers[random][2], markers[random][3] -1, "cylinder", 1.25, 30, 144, 255, 0)
	blip[playerSource] = createBlipAttachedTo(marker[playerSource], 0)
	setElementVisibleTo(marker[playerSource], root, false)
	setElementVisibleTo(marker[playerSource], playerSource, true)
	setElementVisibleTo(blip[playerSource], root, false)
	setElementVisibleTo(blip[playerSource], playerSource, true)
	triggerClientEvent(playerSource, "sound", resourceRoot, markers[random][1], markers[random][2], markers[random][3])
	triggerClientEvent(playerSource, "togglePoint", playerSource, markers[random][1], markers[random][2], markers[random][3])
	addEventHandler("onMarkerHit", marker[playerSource], consertar)
end
-----------------------------------------------------------------------------------------------------------------------------------------
function pickEscada(playerSource)
	if colshape[playerSource] and isElement(colshape[playerSource]) then 
		if isElementWithinColShape(playerSource, colshape[playerSource]) then

			if not isElement(escada1[playerSource]) then

				toggleControl(playerSource, "sprint", false)
				toggleControl(playerSource, "jump", false)
				
				toggleControl(playerSource, "crouch", false)
				toggleControl(playerSource, "enter_exit", false)
				sendMessageServer(playerSource, "Posicione a escada e presione 'E' para colocá-la no local", 'info')
				
				escada1[playerSource] = createObject(1437, 0, 0, 0)

				setElementVisibleTo(escada1[playerSource], root, false)

				setElementVisibleTo(escada1[playerSource], playerSource, true)

				setElementCollisionsEnabled(escada1[playerSource], false)
				
				attachElements(escada1[playerSource], playerSource, 0, 1, 0, -25, 0, 0)
				
				setElementAlpha(escada1[playerSource], 200)

				bindKey(playerSource, "e", "down", releaseEscada)
			else
				if isElementAttached(escada1[playerSource]) then
					destroyElement(escada1[playerSource])
					escada1[playerSource] = nil
					toggleControl(playerSource, "sprint", true)
					toggleControl(playerSource, "jump", true)
					toggleControl(playerSource, "crouch", true)
					toggleControl(playerSource, "enter_exit", true)
					unbindKey(playerSource, "e", "down", guardarEscada)
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
function releaseEscada(playerSource)
	if isElement(escada1[playerSource]) then
    	toggleControl(playerSource, "sprint", true)
    	toggleControl(playerSource, "jump", true)
    	toggleControl(playerSource, "crouch", true)
    	local x, y, z = getElementPosition(playerSource)
    	guardar[playerSource] = createMarker(x, y, z -1, "cylinder", 1.25, 30, 144, 255, 80, playerSource)
    	local _, _, rot = getElementRotation(playerSource)
    	setElementCollisionsEnabled(escada1[playerSource], true)
    	detachElements(escada1[playerSource], playerSource)
    	setElementRotation(escada1[playerSource], -25, _, rot)
    	setElementAlpha(escada1[playerSource], 255)
        setElementVisibleTo(escada1[playerSource], root, true)
    	unbindKey(playerSource, "e", "down", releaseEscada)
    	bindKey(playerSource, "e", "down", guardarEscada)
		sendMessageServer(playerSource, "Presione 'E' para guardar a escada", 'info')
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
function consertar(playerSource)
	if marker[playerSource] and isElement(marker[playerSource]) then 
		if isElementWithinMarker(playerSource, marker[playerSource]) then
			setElementFrozen(playerSource, true)
			setPedAnimation(playerSource, "casino", "dealone", -1, true, false, false)
			sendMessageServer(playerSource, "Consertando...", 'info')
			exports["guetto_progress"]:callProgress(playerSource, "Eletricista", "Você está concertando um poste", "martelo", 30000) 
			setTimer(function(playerSource)
				local isVip = exports["guetto_util"]:isPlayerVip(playerSource)
				local expGain = isVip and 560*2 or 560
				local money = math.random(money1, money2)
				local exp = (getElementData(playerSource, "XP") or 0)
				setElementData(playerSource, "XP", exp + expGain)
				givePlayerMoney(playerSource, money)
				sendMessageServer(playerSource, "Você recebeu "..money.." reais", 'info')
				triggerClientEvent(playerSource, "sound", resourceRoot, "stop")
				setElementFrozen(playerSource, false)
				setPedAnimation(playerSource, nil)
				if marker[playerSource] and isElement(marker[playerSource]) then 
					destroyElement(marker[playerSource])
					marker[playerSource] = nil
				end
				if blip[playerSource] and isElement(blip[playerSource]) then 
					destroyElement(blip[playerSource])
					blip[playerSource] = nil
				end
				iniciarJob(playerSource)
			end, 30000, 1, playerSource)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
function guardarEscada(playerSource)
	if guardar[playerSource] and isElement(guardar[playerSource]) then 
		if isElementWithinMarker(playerSource, guardar[playerSource]) then
			destroyElement(escada1[playerSource])
			escada1[playerSource] = nil
			destroyElement(guardar[playerSource])
			guardar[playerSource] = nil
			toggleControl(playerSource, "enter_exit", true)
			unbindKey(playerSource, "e", "down", guardarEscada)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
function cancel(source)
	local emprego = getElementData(source, "Emprego")
	if emprego == "Eletricista" then
		if isElement(veh[source]) then
			if isElement(escada1[source]) then destroyElement(escada1[source]) escada1[source] = nil end
			if isElement(veh[source]) then destroyElement(veh[source]) veh[source] = nil end
			if isElement(marker[source]) then destroyElement(marker[source]) marker[source] = nil end
			if isElement(guardar[source]) then destroyElement(guardar[source]) guardar[source] = nil end
			if isElement(blip[source]) then destroyElement(blip[source]) blip[source] = nil end
			if isElement(colshape[source]) then destroyElement(colshape[source]) colshape[source] = nil end
			toggleAllControls(source, true)
			unbindKey(source, "e", "down", guardarEscada)
			unbindKey(source, "e", "down", releaseEscada)
			triggerClientEvent(source, "sound", resourceRoot, "stop")
			triggerClientEvent(source, "togglePoint", source)
		end
	end
end
addCommandHandler("cancelar", cancel)
-----------------------------------------------------------------------------------------------------------------------------------------
function reset()
	local emprego = getElementData(source, "Emprego")

	if (veh[source] and isElement(veh[source])) then
		destroyElement(veh[source])
		veh[source] = nil 
	end;

	if isElement(escada1[source]) then 
		destroyElement(escada1[source]) 
		escada1[source] = nil 
	end
	
	if isElement(marker[source]) then 
		destroyElement(marker[source]) 
		marker[source] = nil 
	end
	
	if isElement(guardar[source]) then 
		destroyElement(guardar[source]) 
		guardar[source] = nil 
	end
	
	if isElement(blip[source]) then 
		destroyElement(blip[source]) 
		blip[source] = nil 
	end

	if isElement(colshape[source]) then 
		destroyElement(colshape[source]) 
		colshape[source] = nil 
	end

	toggleAllControls(source, true)
	unbindKey(source, "e", "down", guardarEscada)
	unbindKey(source, "e", "down", releaseEscada)
	triggerClientEvent(source, "sound", resourceRoot, "stop")
	triggerClientEvent(source, "togglePoint", source)

end

addEventHandler("onPlayerQuit", root, reset)
addEventHandler("onPlayerWasted", root, reset)



function message(player, text, type) 
	sendMessageServer(player, text, type)
end
-----------------------------------------------------------------------------------------------------------------------------------------
