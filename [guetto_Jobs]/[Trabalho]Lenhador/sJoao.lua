local trees = {}
local attachPos = { 
    {-0.7, -1,0},
    {0, -1, 0},
    {0.7, -1, 0},
    {0.3, -1, 0.42},
    {-0.3, -1, 0.42},
    {0, -1, 0.9}
}

addCommandHandler("infos",
function(player)
	if getElementData(player, "Emprego") == "Lenhador" then
		if not isTimer(TimerEmprego) then
			blip = createBlip(-1061.057, -1192.168, 129.219, 41)
			setElementVisibleTo(blip, root, false)
			setElementVisibleTo(blip, player, true)
			notifyS(player, "Seu local de emprego foi marcado em seu GPS com sucesso!", "info")
			triggerClientEvent(player, "JOAO.marcadorJobs", player, -1061.057, -1192.168, 129.219, 0, 0, "Emprego")
			TimerEmprego = setTimer(function()
				triggerClientEvent(player, "JOAO.removeMarcadorJobs", player)
				if isElement(blip) then destroyElement(blip) end
			end, 60000, 1)
		else
			notifyS(player, "Você já tem um local de emprego marcado!", "error")
		end
	end
end)

function treeSpawn()
    local x, y, z = -1201.5726318359, -1058.2330322266, 129.00483703613
    local id = 0
    local tick = getTickCount()
    Async:iterate(1,18,function(i)
		for k=1,13 do
            local obj = createObject(654, x+(i*10), y+(k*10), z-1)
            local col = createColSphere(x+(i*10), y+(k*10), z, 1.5)
            trees[id] = {x+(i*10), y+(k*10), z, obj, col}
            setElementData(col, "objectMadeira", obj)
            setElementData(col, "idMadeira", id)
            setElementData(obj, "colshapeMadeira", col)
            setElementData(obj, "vidaMadeira", 100)
            setElementData(obj, "idMadeira", id)
            id = id + 1
		end
    end)
    for i, v in ipairs(getElementsByType("player")) do
        if getElementData(v, 'Veh Lenhador') then
            setElementData(v, 'Veh Lenhador', false)
        end
        if getElementData(v, 'Trabalhando Lenhador') then
            setElementData(v, 'Trabalhando Lenhador', false)
        end
    end
end
addEventHandler("onResourceStart", resourceRoot, treeSpawn)

function respawnTree(id)
    local x, y, z, obj, col, cutted = unpack(trees[id])

    if not col then 
        col = createColSphere(x, y, z, 1.5)
    end
    if not obj then 
        obj = createObject(654, x, y, z-1)
    end
    setElementData(col, "objectMadeira", obj)
    setElementData(col, "idMadeira", id)
    setElementData(obj, "colshapeMadeira", col)
    setElementData(obj, "vidaMadeira", 100)
    setElementData(obj, "idMadeira", id)
end

addEvent("brokenWood", true)
addEventHandler("brokenWood", root,
function(obj)
    if not client then
        return
    end

    local player = client

    setElementFrozen(player, true)
    local x, y, z = getElementPosition(obj)
    local mx, my, mz = 0,0,0
    local randed = math.random(0,2)
    if randed == 1 then
        mx, my, mz = 0, 80, 0
    elseif randed == 0 then
        mx, my, mz = 80, 0, 0
    elseif randed == 2 then 
        mx, my, mz = 80, 80, 0
    end
    local col = getElementData(obj, "colshapeMadeira")
    if isElement(col) then 
        destroyElement(col)
        trees[getElementData(obj, "idMadeira")][5] = false
    end
    local id = getElementData(obj, "idMadeira")
    if moveObject(obj, 2000, x, y, z, mx, my, mz) then
        setTimer(function()
            if isElement(obj) then 
                trees[getElementData(obj, "idMadeira")][4] = false
                destroyElement(obj)
            end
            setElementFrozen(player, false)
            local obj = createObject(684, 0, 0, 0)
            setElementCollisionsEnabled(obj, false)
            setObjectScale(obj, 0.5)
            setPedAnimation(player, "CARRY", "liftup", 1000, false)
            exports.bone_attach:attachElementToBone(obj, player, 12, 0, 0.2, 0, 0, 0, -110)
            setPedAnimation(player, "CARRY", "crry_prtial", 1, false)
            setElementData(player,"comMadeira",obj)
            notifyS(player, "Você cortou a árvore com sucesso, coloque-a no veículo de trabalho.", 'success')
            setTimer(function()
                respawnTree(id)
            end, 1000*60*5, 1)
        end, 3000, 1)
    end
end)

vehicle = {}

addEvent("spawnarVehicle", true)
addEventHandler("spawnarVehicle", resourceRoot,
function ()

    if not client then
        return
    end

    local player = client

    vehicle[player] = createVehicle(578, -1071.82, -1226.375, 129.219, 0, 0, 271.968)
    setVehicleColor(vehicle[player], 255, 255, 255, 255, 255, 255)
    setElementData(player, "Veh Lenhador", vehicle[player])
    setElementData(vehicle[player], 'Owner', player)
    setElementData(vehicle[player], "Madeiras", 0)
    warpPedIntoVehicle(player, vehicle[player])
    giveWeapon(player, 10, 5)
    triggerClientEvent(player, "togglePoint", resourceRoot, -1115.14, -1052.997, 130.21, 0, 0)
    notifyS(player, 'Você spawnou o veículo com sucesso, vá até a plantação de madeiras para trabalhar', 'success')
end)

addEvent("removerVehicle", true)
addEventHandler("removerVehicle", root,
function()

    if not client then
        return 
    end

    local player = client

    local veh = getPedOccupiedVehicle(player)
    if veh and getElementData(player, "Veh Lenhador") then
        for k,v in pairs(getAttachedElements(veh)) do
            if isElement(v) then 
                destroyElement(v)
            end
        end
        setElementData(player, "Veh Lenhador", false)
    end
    if isElement(vehicle[player]) and vehicle[player] then
        destroyElement(vehicle[player])
    end
    takeWeapon(player, 10)
    notifyS(player, 'Você finalizou o serviço com sucesso!', 'info')
end)

addEvent("removePlayerWood", true)
addEventHandler("removePlayerWood", root,
function(player)

    local wood = getElementData(player, "comMadeira")

    if wood and isElement(wood) then 
        exports.bone_attach:detachElementFromBone(wood)
        destroyElement(wood)
        setElementData(player, "comMadeira", false)
    end
end)

addEvent("colocarMadeiraVehicle", true)
addEventHandler("colocarMadeiraVehicle", root,
function(veh)


    if not client then
        return
    end
    
    local player = client
    
    triggerEvent("removePlayerWood", player, player)
    
    
    local woodCount = getElementData(veh, "Madeiras")
    local obj = createObject(684, 0, 0, 0)
    
    if woodCount +1 >= 6 then 
        triggerClientEvent(player, "togglePoint", resourceRoot, 62.985847473145, -246.51533508301, 1.578125, 0, 0)
        notifyS(client, 'Leve a madeira até a posição marcada em sua tela!', 'info')
    end

    setObjectScale(obj, 0.5)
    setElementCollisionsEnabled(obj, false)
    local aPos = attachPos[woodCount+1]
    attachElements(obj, veh, aPos[1], aPos[2], aPos[3])
    setPedAnimation(player)
    setElementData(veh, "Madeiras", woodCount+1)
end)

addEvent("derrubarMadeira", true)
addEventHandler("derrubarMadeira", root,
function(veh)

    if not client then
        return
    end

    local player = client

    local vehicle = getPedOccupiedVehicle(player)
    if vehicle == veh then 
        local woods = getElementData(veh, "Madeiras")
        if woods > 0 then 
            notifyS(player, "Você despejou as árvores com sucesso.", "success")
            local money = 0
            local xp = 0
            local isVip = exports["guetto_util"]:isPlayerVip(player)

            for i=1, woods do 
                local ganhoPorMadeira = math.random(3000, 5000)
                local xpPorMadeira = math.random(1000, 1500)
                money = money + ganhoPorMadeira
                xp = xp + xpPorMadeira
            end
            for k,v in pairs(getAttachedElements(veh)) do 
                if isElement(v) then 
                    destroyElement(v)
                end
            end
            setElementData(veh, "Madeiras", 0)
            local vehHP = getElementHealth(veh)
            if vehHP < 900 then 
                local reparo = math.floor(1000-vehHP)
                notifyS(player, "O empregador deduziu do seu salário por causa do veículo quebrado! Taxa de reparo: R$ "..formatNumber(reparo)..",00", "warning")
                money = money - reparo
                fixVehicle(veh)
            end

            local exp = (getElementData(player, "XP") or 0)
            
            if ( isVip ) then 
                setElementData(player, "XP", exp + (xp * 2))
                notifyS(player, "Você recebeu o dobro de xp por ser vip e ganhou R$ "..money..",00", "success")
            else
                setElementData(player, "XP", exp + xp)
                notifyS(player, "Você ganhou R$ "..money..",00", "success")
            end

            givePlayerMoney(player, tonumber(money))
            notifyS(player, "Você ganhou R$ "..money..",00", "success")
        end
    end
end)

addEventHandler("onPlayerQuit", root,
function()
    local obj = getElementData(source, "comMadeira")
    if obj and isElement(obj) then 
        exports.bone_attach:detachElementFromBone(obj)
        destroyElement(obj)
    end
    if isElement(wood) then
        destroyElement(wood)
    end
    if isElement(vehicle[source]) then
        destroyElement(vehicle[source])
    end
end)
