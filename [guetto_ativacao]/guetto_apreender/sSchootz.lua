marker = {}

Markers = function()
	for i,v in ipairs(config['Markers']) do
		marker[i] = createMarker(v[1], v[2], v[3]-0.9, 'cylinder',  1.5, 139, 100, 255, 100)
		addEventHandler('onMarkerHit', marker[i], PassarMarker)
	end
end
addEventHandler('onResourceStart', resourceRoot, Markers)

function isPlayerInGroup (player)
	if not player or not isElement(player) or getElementType(player) ~= 'player' then 
		return false 
	end
	
	local account = getAccountName(getPlayerAccount(player))

	for i = 1, #config['Geral']['AclAbrir'] do 
		local v = config['Geral']['AclAbrir'][i]
		if isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(player)), aclGetGroup(v)) then 
			return true 
		end
	end
	return false
end

PassarMarker = function(player)
	if getElementType(player) == 'player' then
		if not isPlayerInGroup(player) then
			notifyS(player, 'Você não está na acl!', 'error')
		else 
			triggerClientEvent(player, 'Schootz.openDetranPanel', player)
		end
	end
end

function getVehiclesNearest (player)
	if not (player) then 
		return false 
	end

	local x, y, z = getElementPosition(player)
	local result = false 
 
	for i, v in ipairs (getElementsByType('vehicle')) do 
		local x2, y2, z2 = getElementPosition(v)
		if getDistanceBetweenPoints3D ( x, y, z, x2, y2, z2 ) <= 5 then 
			result = v
		end
	end

	return result
end

AprenderVehicle = function(player)
	local getCarProx = getVehiclesNearest(player);
	if not getCarProx then 
		notifyS(player, 'Não existe nenhum veículo proxímo a você!', 'error')
	else
		local vehicleDealership = getElementData(getCarProx, 'Guh.VehicleID') or false
		if not vehicleDealership then
			notifyS(player, 'Este veículo não pode ser preso pois não e da concessonaria!', 'error')
		else

			local value = 0

			if exports['guetto_dealership']:getVehicleConfigFromModel(getElementModel(getCarProx)).money then 
				value = exports['guetto_dealership']:getVehicleConfigFromModel(getElementModel(getCarProx)).money
			elseif exports['guetto_dealership']:getVehicleConfigFromModel(getElementModel(getCarProx)).coins then 
				value = exports['guetto_dealership']:getVehicleConfigFromModel(getElementModel(getCarProx)).coins
			end

			local ValorVeiculo = math.floor(value/135*10)
			notifyS(player, 'Você prendeu este veículo e recebeu R$'..formatNumber(ValorVeiculo)..'!', 'success')
			exports['guetto_dealership']:setVehicleState(getCarProx, 'apreendido')
			if isElement(getCarProx) and destroyElement(getCarProx) then end
			givePlayerMoney(player, ValorVeiculo)
		end
	end
end
addEvent('Schootz.AprenderVehicle', true)
addEventHandler('Schootz.AprenderVehicle', root, AprenderVehicle)

-- Funções uteis -- 

formatNumber = function(number) 
    while true do      
        number, k = string.gsub(number, "^(-?%d+)(%d%d%d)", '%1.%2')    
        if k==0 then      
            break   
        end  
    end  
    return number
end
