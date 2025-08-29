local tubarao1 = {}
local tubarao2 = {}
local centro = {}
local sharkPass = {}

local plrCache = {}

function check()
	local players = getElementsByType("player", root, true)
	for k, v in ipairs(players) do
		if getElementHealth(v) > 20 and not getElementData(v, "admin >> duty") then
			local x2,y2,z2 = getElementPosition(v)
			local zone = getZoneName(x2,y2,z2)
			if zone ~= "Los Santos" and zone ~= "Tierra Robada" then
				if isElementInWater(v) and not isPedInVehicle(v) then
					if not sharkPass[v] then
						sharkPass[v] = 1
					end
					sharkPass[v] = sharkPass[v]+2
					local x,y,z = getElementPosition(v)
					if z < 1 then
						if not centro[v] then
							if isElement(tubarao1[v]) then
								destroyElement(tubarao1[v])
								tubarao1[v] = nil
							end
							centro[v] = createObject(3027,x,y,z-5)
							setElementAlpha(centro[v],0)
							tubarao1[v] = createObject (1608,x+10,y,z-5)
							attachElements(tubarao1[v],centro[v],0+10,0,-0.3)
						end
						moveObject(tubarao1[v],1000,x,y,z,0,0,179.9)
						if sharkPass[v] > 8 then
							sharkPass[v] = nil
							tubarao2[v] = createObject(1608,x,y-15,z-10,45,0,0)
							moveObject(tubarao2[v],1000,x,y-5,z+1,-45,0,0)

							setTimer(function(tubarao2,v)
								if isElement(tubarao2[v]) then
									local vx, vy, vz = getElementPosition(tubarao2[v])
									local sx = x - vx
									local sy = y - vy
									local sz = z - vz
									local new = sx^2 + sy^2 + sz^2
									if new < 30 then
									local H = getElementHealth(v)
										if H < 30 then
											setElementHealth(v,1)
											setPedHeadless(v,true)
											setTimer(function (v)
												local x,y,z = getElementPosition (v)
												killPed ( v, nil, nil, 9 )
											end,2500, 1,v)	
											setTimer (function (v)
												setPedHeadless(v,false)
											end,4500, 1,v)
										else
											setElementHealth(v,H-100)
										end
										triggerClientEvent("ClientSharkFxBlood", getRootElement(), x, y, z )
									end
									triggerClientEvent("ClientSharkFxSplash", getRootElement(), x, y, z )
									moveObject(tubarao2[v],1000,x,y+15,z-10,-45,0,0)
								end
							end,1000,1,tubarao2,v)

							setTimer(function(v)
								if isElement(v) then
									--[[if isElement(tubarao1[v]) then
										destroyElement(tubarao1[v])
										tubarao1[v] = nil
									end
									if isElement(centro[v]) then
										destroyElement(centro[v])
										centro[v] = nil
									end]]
									if isElement(tubarao2[v]) then
										destroyElement(tubarao2[v])
										tubarao2[v] = nil
									end
									sharkPass[v] = nil
								end
							end,5000, 1,v)
						end
					else
						deleteSharks (v)
					end
				else
					deleteSharks (v)
				end
			end
		end
	end
end

function deleteSharks(player)
	if isElement(player) then
		setTimer(function(player)
			if isElement(tubarao1[player]) then
				destroyElement(tubarao1[player])
				tubarao1[player] = nil
			end
			if isElement(centro[player]) then
				destroyElement(centro[player])
				centro[player] = nil
			end
			if isElement(tubarao2[player]) then
				destroyElement(tubarao2[player])
				tubarao2[player] = nil
			end
			sharkPass[player] = nil
		end,5000, 1,player)
	end
end

function onLoad()
	local players = getElementsByType("player", root, true)
	for k,v in ipairs(players) do
		if isElement(tubarao1[v]) then
			destroyElement(tubarao1[v])
			tubarao1[v] = nil
		end
		if isElement(centro[v]) then
			destroyElement(centro[v])
			centro[v] = nil
		end
		if isElement(tubarao2[v]) then
			destroyElement(tubarao2[v])
			tubarao2[v] = nil
		end
		sharkPass[v] = nil
	end
	setTimer(check, 5000, 0)
end
addEventHandler("onMapLoad", getRootElement(), onLoad)
onLoad()

addEventHandler("onPlayerQuit", getRootElement(), function()
	if isElement(tubarao1[source]) then
		destroyElement(tubarao1[source])
		tubarao1[source] = nil
	end
	if isElement(centro[source]) then
		destroyElement(centro[source])
		centro[source] = nil
	end
	if isElement(tubarao2[source]) then
		destroyElement(tubarao2[source])
		tubarao2[source] = nil
	end
	if sharkPass[v] then
		sharkPass[v] = nil
	end
end)