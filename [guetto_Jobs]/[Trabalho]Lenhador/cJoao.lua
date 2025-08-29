local currentWood = false
local woodHit = 0
local lumberVehMarker = {}
local lumberMarkerTick = 0
local lumberEtick = 0

local ped = createPed(0, -1061.057, -1192.168, 129.219, 274.786)
setElementFrozen(ped, true)
setPedAnimation(ped, 'COP_AMBIENT', 'Coplook_think', -1, true, false, false)

local markerDescarregar = {}
addEventHandler('onClientClick', root, function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedWorld)
	if button == "right" and state == "down" or button == "left" and state == "down" then
		if clickedWorld == ped then
			if getElementData(localPlayer, 'Emprego') == config['ElementData'] then
				local playerPosX, playerPosY, playerPosZ = getElementPosition(localPlayer)
				local pedPosX, pedPosY, pedPosZ = getElementPosition(ped)
				if getDistanceBetweenPoints3D(playerPosX, playerPosY, playerPosZ, pedPosX, pedPosY, pedPosZ) <= 5 then
					if not getElementData(localPlayer, 'Trabalhando Lenhador') then
                        startLumberJack()
                        createBlip(74.587, -250.036, 1.578, 41)
					else
                        stopLumberJack()
					end
				end
			else
				notifyC('Você não trabalha de Lenhador.', 'error')
			end
		end
    end
end)

function startLumberJack()
    
    triggerServerEvent('spawnarVehicle', resourceRoot)

    lumberMarkerTick = getTickCount()
    markerDescarregar[1] = createMarker(62.985847473145, -246.51533508301, 1.578125-0.9, "cylinder", 3.0, 139, 0, 255, 0)
    setElementData(markerDescarregar[1], "markerData", {title = "Descarregar", desc = "Descarregue a madeira!", icon = "checkpoint"})
    markerDescarregar[2] = createBlip(62.985847473145, -246.51533508301, 1.578125, 41)
    addEventHandler('onClientMarkerHit', markerDescarregar[1],
    function(hitElement)
        if hitElement == localPlayer then 
            local veh = getPedOccupiedVehicle(localPlayer)
            if veh and veh == getElementData(localPlayer, 'Veh Lenhador') then 
                local woods = getElementData(veh, 'Madeiras')
                if woods > 0 then 
                    triggerServerEvent('derrubarMadeira', resourceRoot, veh)
                else 
                    notifyC('Não há árvores no caminhão!', 'error')
                    return
                end
            end
        end
    end)
    setElementData(localPlayer, 'Trabalhando Lenhador', true)
end

function stopLumberJack()
    for k,v in pairs(markerDescarregar) do 
        if isElement(v) then 
            destroyElement(v)
        end
    end
    markerDescarregar = {}

    triggerServerEvent('removerVehicle', resourceRoot)

    setElementData(localPlayer, 'Trabalhando Lenhador', false)
end

addEventHandler('onClientColShapeHit', root, 
function(element)
    if getElementType(element) == 'player' and element == localPlayer and getElementData(localPlayer, 'Emprego') == 'Lenhador' then 
        if source then 
            local obj = getElementData(source, 'objectMadeira')
            if obj and isElement(obj) then 
                currentWood = obj
                removeEventHandler('onClientRender', root, drawWoodStats)
                addEventHandler('onClientRender', root, drawWoodStats)
            end
        end
    end
end)

addEventHandler('onClientColShapeLeave', root, 
function(element)
    if getElementType(element) == 'player' and element == localPlayer and getElementData(localPlayer, 'Emprego') == 'Lenhador' then 
        local obj = getElementData(source, 'objectMadeira')
        if obj and isElement(obj) then 
            currentWood = false
            removeEventHandler('onClientRender', root, drawWoodStats)
        end
    end
end)


function drawWoodStats()
    if not currentWood then return end
    local ox, oy, oz = getElementPosition(currentWood)
    local x, y = getScreenFromWorldPosition(ox, oy, oz+2)
    if getElementData(localPlayer, 'Trabalhando Lenhador') then
        if x and y then 
            dxDrawRectangle(x-155, y-25, 310, 50, tocolor(0, 0, 0, 180))
            dxDrawRectangle(x-150, y-20, getElementData(currentWood, 'vidaMadeira')*3, 40, tocolor(73, 166, 252, 250))
        end
    end
end
addEventHandler('onClientRender', root, drawWoodStats)

addEventHandler('onClientKey', root,
function(button,state)
    if getElementData(localPlayer, 'Emprego') == 'Lenhador' and not isPedInVehicle(localPlayer) then
        if button == 'mouse1' and state then 
            if currentWood then 
                local target = getPedTarget(localPlayer)
                if target == currentWood then 
                    if getKeyState('mouse1') and woodHit+1000 < getTickCount() and not isCursorShowing() and getPedWeapon(localPlayer) == 10 then 
                        setElementData(currentWood, 'vidaMadeira', getElementData(currentWood, 'vidaMadeira')-math.random(8, 15))
                        if getElementData(currentWood, 'vidaMadeira') < 0 then 
                            setElementData(currentWood, 'vidaMadeira',0)
                            triggerServerEvent('brokenWood', resourceRoot, currentWood)
                            setControl(false)
                            currentWood = false
                            removeEventHandler('onClientRender', root, drawWoodStats)
                        end
                        woodHit = getTickCount()
                    end
                end
            end
        end
    end
end)

addEventHandler('onClientRender', root,
function()
    if getElementData(localPlayer, 'Emprego') == 'Lenhador' and not isPedInVehicle(localPlayer) then 
        for k,veh in ipairs(getElementsByType('vehicle')) do 
            if getElementModel(veh) == 578 then 
                local px, py, pz = getElementPosition(localPlayer)
                local vx, vy, vz = getVehicleComponentPosition(veh, 'chassis_vlo', 'world')
                if vx and vy and vz and getDistanceBetweenPoints3D(vx, vy, vz, px, py, pz) < 3 then 
                    local x, y = getScreenFromWorldPosition(vx, vy, vz)
                    if x and y then 
                        shadowedText('Pressione #aa00ffE #FFFFFFpara colocar\n#FFFFFF'..(getElementData(veh,'Madeiras') or 0)..'/6 Quantidade', x-100, y, x+100, 0, tocolor(255,255,255), 1, 'default', 'center', 'top', false, false, false, true)
                        if getKeyState('e') and lumberEtick+500 < getTickCount() and not isCursorShowing() then
                            if not getElementData(localPlayer, 'comMadeira') then 
                                notifyC('Você não tem uma madeira na sua mão!', 'error')
                                lumberEtick = getTickCount()
                                return
                            end
                            if (getElementData(veh, 'Madeiras') or 0)+1 > 6 then 
                                notifyC('Não cabe mais madeira no carrinho, a madeira em sua mão foi descartada.', 'error')
                                triggerServerEvent('removePlayerWood', resourceRoot)
                                setControl(true)
                                lumberEtick = getTickCount()
                                return
                            end
                            triggerServerEvent('colocarMadeiraVehicle', resourceRoot, veh)
                            setControl(true)
                            lumberEtick = getTickCount()
                        end
                    end
                end
            end
        end
    end
end)

function shadowedText(text, x, y, w, h, color, fontsize, font, aligX, alignY)
    dxDrawText(text:gsub('#%x%x%x%x%x%x',''), x, y+1, w, h+1, tocolor(0,0,0,255), fontsize, font, aligX, alignY, false, false, true, true) 
    dxDrawText(text:gsub('#%x%x%x%x%x%x',''), x, y-1, w, h-1, tocolor(0,0,0,255), fontsize, font, aligX, alignY, false, false, true, true)
    dxDrawText(text:gsub('#%x%x%x%x%x%x',''), x-1, y, w-1, h, tocolor(0,0,0,255), fontsize, font, aligX, alignY, false, false, true, true) 
    dxDrawText(text:gsub('#%x%x%x%x%x%x',''), x+1, y, w+1, h, tocolor(0,0,0,255), fontsize, font, aligX, alignY, false, false, true, true) 
    dxDrawText(text, x, y, w, h, color, fontsize, font, aligX, alignY, false, false, true, true)
end
function setControl(state)
    toggleControl('accelerate', state)
    toggleControl('brake', state)
    toggleControl('enter_exit', state)
    toggleControl('sprint', state)
    toggleControl('jump', state)
    toggleControl('crouch', state)
    toggleControl('fire', state)
    toggleControl('enter_passenger', state)
end
setControl(true)

addEventHandler("onClientResourceStart", resourceRoot, function()
txd = engineLoadTXD( "assets/machado.txd", 321 ) 
engineImportTXD ( txd, 321 ) 
dff = engineLoadDFF ( "assets/machado.dff", 321 ) 
engineReplaceModel ( dff, 321 ) 
end)