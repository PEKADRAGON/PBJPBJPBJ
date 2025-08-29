function createShops()
    for i,v in ipairs(lojas) do
        local marker = createMarker(v[1], v[2], v[3] - 0.9, "cylinder", 1.5, 107, 201, 48, 0)
        setElementData(marker , 'markerData', {title = 'Loja de acessórios', desc = 'Fique mais estiloso!', icon = 'clothes'})

        addEventHandler("onMarkerHit", marker, function(player, dm)
            if not dm or not player then return end
            if player and isElement(player) and getElementType(player) == 'player' and not isPedInVehicle(player) then 
                sendMessageServer(player, "Pressione 'e' para entrar.", "info")
                bindKey(player, "e", "down", openShop, marker)
            end
        end)

        addEventHandler("onMarkerLeave", marker, function(player, dm)
            if not dm then return end
            if player and isElement(player) and getElementType(player) == 'player' and not isPedInVehicle(player) then 
                unbindKey(player, "e", "down", openShop)
            end
        end)
    end
end

createShops()

function openShop(player, b, s, m)
    if not isElementWithinMarker(player, m) then return end
    local x,y,z = getElementPosition(player)
    setElementData(player, "characterQuit", {x, y, z, 0, 0}, false)
    objetosalpha(player,0)

    setElementDimension(player, getElementData(player, "ID"))
    setElementFrozen(player, true)
    setElementInterior(player, 14)
    setElementPosition(player, 199.193, -158.724, 1000.523)
    setElementRotation(player,0,0,230)
    triggerClientEvent(player, "openShopAcccessories", resourceRoot)
end

function exitShopAccessories()
    objetosalpha(client, 255)
    setElementFrozen(client, false)
    setElementAlpha(client, 255)
    setElementInterior(client, 0)
	setElementDimension(client, 0)

    local respawn = getElementData(client, "characterQuit")
    setElementPosition(client, respawn[1], respawn[2], respawn[3])
    setElementData(client, "characterQuit", false)
end
addEvent("exitShopAccessories", true)
addEventHandler("exitShopAccessories", root, exitShopAccessories)

function objetosalpha(player,alpha)
	if alpha and tonumber(alpha) then
		if getElementData(player, "objeto:Cabeca") and isElement(getElementData(player, "objeto:Cabeca")) then
			setElementAlpha(getElementData(player, "objeto:Cabeca"), alpha)
		end
		if getElementData(player, "objeto:Rosto") and isElement(getElementData(player, "objeto:Rosto")) then
			setElementAlpha(getElementData(player, "objeto:Rosto"), alpha)
		end
		if getElementData(player, "objeto:Mochila") and isElement(getElementData(player, "objeto:Mochila")) then
			setElementAlpha(getElementData(player, "objeto:Mochila"), alpha)
		end
		if getElementData(player, "objeto:Radio") and isElement(getElementData(player, "objeto:Radio")) then
			setElementAlpha(getElementData(player, "objeto:Radio"), alpha)
		end
		if getElementData(player, "objeto:Bandana") and isElement(getElementData(player, "objeto:Bandana")) then
			setElementAlpha(getElementData(player, "objeto:Bandana"), alpha)
		end
	end
end


addEvent("Acessorios.comprar", true)
addEventHandler("Acessorios.comprar", resourceRoot, function(state, data)
    if not (client or (source ~= resourceRoot)) then 
        return false 
    end
	
	local price = data[2]
	local money = getPlayerMoney(client)

	if price <= 0 then 
		return false 
	end

	if money < price then
		return sendMessageServer(client, "Dinheiro insuficiente!", "error")
	end

	if not state then 
		return sendMessageServer(client, 'Houve uma falha ao tentar compra esse acessório!', 'info')
	end
	
	local result = false;

	for category, v in pairs(data[1]) do
		if v then
			if (v[5]['premium']) == true then 
				local preco = v[5]['preco']
				if (getElementData(client, "guetto.points") or 0) < preco then 
					return sendMessageServer(client, "Gemas points suficiente!", "info")
				else
					local x, y, z, rx, ry, rz = unpack(v[5].pos)
					local tx, ty, tz = unpack(v[5].tamanho)

					local temp = {
						["accessories"] = {
							pos = {x, y, z, rx, ry, rz, tx, ty, tz},
							category = category,
							id = v[5].index
						},
						["premium"] = v[2]
					}

					giveAccessorie(client, temp.accessories.category, temp.accessories.id, temp.accessories.premium)
					setElementData(client, "guetto.points", (getElementData(client, "guetto.points") or 0) - preco)
				end
			else
				local x, y, z, rx, ry, rz = unpack(v[5].pos)
				local tx, ty, tz = unpack(v[5].tamanho)

				local temp = {
					["accessories"] = {
						pos = {x, y, z, rx, ry, rz, tx, ty, tz},
						category = category,
						id = v[5].index
					},
					["premium"] = v[2]
				}

				giveAccessorie(client, temp.accessories.category, temp.accessories.id, temp.accessories.premium)
				local preco = v[5]['preco']
				takePlayerMoney(client, preco)
			end
		end
	end
    triggerClientEvent(client, "onResponseAccessories", resourceRoot, state, data[2])
end)


function giveAccessorie(plr, category, id, premium)
    local data = acessorios[category][id]
    if not data then return false end
    local x, y, z, rx, ry, rz = unpack(data.pos)
    local tx, ty, tz = unpack(data.tamanho)
    local temp = {
        ["accessories"] = {
            pos = {x, y, z, rx, ry, rz, tx, ty, tz},
            category = category,
            id = id
        },
        ["premium"] = premium and true or data.premium
    }
    local give = exports["guetto_inventory"]:giveItem(plr, data.iditem, 1)
    return give
end

addCommandHandler("criaracessorio", function(source,cmd,id,categoria, premium)
    if getElementData(source, "ID") ~= 2 then return end
    if not id or not categoria or not tonumber(premium) or not tonumber(id) or not tonumber(id) then outputChatBox("Use /"..cmd.." [ID] [Categoria: 1-Cabeça, 2-Rosto, 3-Bandana, 4-Mochila] [PREMIUM: 1 ou 0]",source, 255,255,255,true) return end
    local id = tonumber(id)
    local premium = tonumber(premium)
    local categoria = tonumber(categoria)
    if categoria == 1 then
        categoria = "cabeca"
    elseif categoria == 2 then
        categoria = "rosto"
    elseif categoria == 3 then
        categoria = "bandana"
    elseif categoria == 4 then
        categoria = "mochilas"
    end

    if not acessorios[categoria][id] then return end
    local x, y, z, rx, ry, rz = unpack(acessorios[categoria][id].pos)
    local tx, ty, tz = unpack(acessorios[categoria][id].tamanho)

    local temp = {
        ["accessories"] = {
            pos = {x, y, z, rx, ry, rz, tx, ty, tz},
            category = categoria,
            id = id
        },
        ["premium"] = premium == 1 and 1 or false
    }

    local give = exports.RBR_inventory:givePlayerItem(source, acessorios[categoria][id].iditem, 1, 0, 1, temp)
    if give then
    end
end, false)

--[[
addEvent("Acessorios.salvarPosicoes", true)
addEventHandler("Acessorios.salvarPosicoes", root, function(element, x, y, z, rx, ry, rz, tx, ty, tz)
    toggleAllControls(source, true)

    exports.pattach:setPositionOffset(element, x, y, z)
    exports.pattach:setRotationOffset(element, rx, ry, rz)

    local data = getElementData(element, "objectData")
	if data then
        local items = getElementData(source, "itemsTable")
        for slot, item in pairs(items[1]) do 
            if item[2] == data[3] then
                items[1][slot][6]["accessories"]["pos"] = {x, y, z, rx, ry, rz, tx, ty, tz}

                exports.RBR_engine:query("UPDATE rbr_items SET outros=? WHERE dbid=? LIMIT 1", toJSON(items[1][slot][6]), item[2])
                setElementData(source, "itemsTable", items)
                break
            end
        end
    end

	if tx and ty and tz then
		setObjectScale(element, tx, ty, tz)
	end
end)]]


--[[
]]


function canUseShop(plr)
	local model = getElementModel(plr)
	if isPedInVehicle(plr) then return false end
	if model == 1 or model == 2 then return true end
	return false
end