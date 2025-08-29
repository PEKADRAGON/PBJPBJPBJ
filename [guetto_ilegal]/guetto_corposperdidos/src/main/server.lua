local marker_pegar = {}
local marker_entregar = {}
local Timer = {}
local CoolDown = { }
local PlayerData = { }
local hasPlayerItem = { }
local marker_data = {}
local minutes = 1;

sendMessageServer = function(player, message, type)
	return exports['guetto_notify']:showInfobox(player, type, message)
end;

addEventHandler("onResourceStart", resourceRoot, function ( )

	for i = 1, #config["Markers"]["Pegar"] do 
		local v = config["Markers"]["Pegar"][i]

		marker_pegar[i] = createMarker ( v[1], v[2], v[3] - 1, v[4], v[5], v[6], v[7], v[8], v[9])
		marker_data[marker_pegar[i]] = i 
		
		setElementData(marker_pegar[i], 'markerData', {title = 'Cemitério clandestino', desc = 'Orgãos ilegais', icon = 'caixao'})
	end


	for i = 1, #config["Markers"]["Entregar"] do 
		local v = config["Markers"]["Entregar"][i]

		marker_entregar[i] = createMarker ( v[1], v[2], v[3] - 1, v[4], v[5], v[6], v[7], v[8], v[9])
		setElementData(marker_entregar[i], 'markerData', {title = 'Mercado de orgãos', desc = 'Vendas de orgãos ilegais.', icon = 'checkpoint'})
		
		addEventHandler("onMarkerHit", marker_entregar[i], function (player, dimension)
			if player and isElement(player) and getElementType(player) == "player" and dimension then 
				if isPedInVehicle(player) then
					return sendMessageServer(player, "Saia do veículo!", "error")
				end
				bindKey(player,"e", "down", pressEntregar)
				triggerClientEvent(player, "draw>message", resourceRoot, true, "PRESSIONE [E] PARA VENDER SEUS ITENS!")
			end
		end)

		addEventHandler("onMarkerLeave", marker_entregar[i], function (player, dimension)
			if player and isElement(player) and getElementType(player) == "player" and dimension then 
				unbindKey(player,"e", "down", pressEntregar)
				triggerClientEvent(player, "draw>message", resourceRoot, false, "PRESSIONE [E] PARA VENDER SEUS ITENS!")
			end
		end)

	end

end)


addEventHandler("onMarkerHit", resourceRoot, function (player, dimension)
	if player and isElement(player) and getElementType(player) == "player" and dimension then 
		
		if marker_data[source] then 
		
			if isPedInVehicle(player) then
				return sendMessageServer(player, "Saia do veículo!", "error")
			end

			if (isKeyBound(player, "e", "down")) then 
				unbindKey(player, "e", "down")
			end
			
			bindKey(player,"e", "down", function(player, key, state, index)
				pressPegar ( player, index )
				triggerClientEvent(player, "draw>message", resourceRoot, true, "PRESSIONE [E] PARA PEGAR OS ITENS!")
			end, marker_data[source])
			

			triggerClientEvent(player, "draw>message", resourceRoot, true, "PRESSIONE [E] PARA PEGAR OS ITENS!")

		end
	end
end)


addEventHandler("onMarkerLeave", resourceRoot, function (player, dimension)
	if player and isElement(player) and getElementType(player) == "player" and dimension then 
		if marker_data[source] then 
			triggerClientEvent(player, "draw>message", resourceRoot, false, "PRESSIONE [E] PARA PEGAR OS ITENS!")
			unbindKey(player,"e", "down", pressPegar)
		end
	end
end)

function isPlayerMarkerPegar ( player )
	local result = false 
	for i, v in pairs ( marker_pegar ) do 
		if isElementWithinMarker (player, v) then 
			result = true 
		end
	end
	return result
end

function isPlayerMarkerEntregar ( player )
	local result = false 
	for i, v in pairs ( marker_entregar ) do 
		if isElementWithinMarker (player, v) then 
			result = true 
		end
	end
	return result
end

function pressEntregar (player)
	if not (isPlayerMarkerEntregar(player)) then 
		return false 
	end
	
	hasPlayerItem[player] = true

	for i, v in ipairs (config["Markers"]["Pegar"]) do 
		local item = v.item
		local qnt = exports["guetto_inventory"]:getItem(player, item) 
		if qnt ~= 0 then 
			local random = math.random(1, 2)
			local value = v.amount[random] * qnt
			exports["guetto_inventory"]:takeItem (player, item, qnt)
			exports["guetto_inventory"]:giveItem (player, 100, value)
			sendMessageServer(player, "Você vendeu seus itens ilegais!", "info")
		end
	end

end

function pressPegar (player, index)

	if not player or not isElement(player) or getElementType( player ) ~= "player" then 
		return false 
	end;
	
	if not isPlayerMarkerPegar (player) then 
		return false 
	end

	if isPedInVehicle(player) then
		return sendMessageServer(player, "Saia do veículo!", "error")
	end
	if Timer[player] and isTimer (Timer[player]) then 
		return sendMessageServer(player, "Você já está pegando itens!", "info")
	end

	if CoolDown[player] and CoolDown[player][index] and isTimer (CoolDown[player][index]) then 
		return sendMessageServer(player, "Aguarde para poder pegar itens novamente!", "error")
	end

	if not CoolDown[player] then 
		CoolDown[player] = { }
	end

	local data = config["Markers"]["Pegar"][index]

	setPedAnimation(player, 'BOMBER', 'BOM_Plant', -1, true, false, false, false)
	toggleAllControls(player, false)

	Timer[player] = setTimer (function ( player )

		setPedAnimation(player)
		toggleAllControls(player, true)

		exports["guetto_inventory"]:giveItem(player, data.item, 1)
		sendMessageServer(player, "Você pegou os itens!", "info")

		killTimer(Timer[player])
		Timer[player] = nil 

	end, 2000, 1, player)

	messagePolice()
	CoolDown[player][index] = setTimer(function()
	end, 1 * 60000, 1)
end


function messagePolice ()
	for i, v in ipairs ( getElementsByType ('player') ) do 
		local account = getAccountName (getPlayerAccount(v));
		if (isObjectInACLGroup("user."..account, aclGetGroup("Corporação"))) then 
			if (getElementData(v, "service.police")) then 
				outputChatBox("#f70000[Denuncia] #ffffffEstão mexendo nos corpos alheios!", v, 255, 255, 255, true)
			end
		end
	end
end

addEventHandler('onPlayerWasted', root, function ( )
	triggerClientEvent(source, "draw>message", resourceRoot, false, "PRESSIONE [E] PARA VENDER SEUS ITENS!")
end)