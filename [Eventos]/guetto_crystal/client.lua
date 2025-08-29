local objs = {}



function createCrystal (pos)

	local obj = Object (1213, pos + Vector3(0, 0, 0.3))

	obj.scale = 0.08

	obj.collisions = false

	

	-- local mrk = Marker (pos - Vector3(0, 0, 1), "cylinder", 7, 255, 0, 0, 0)

	local mrk = createColSphere (pos, 4)

	

	local blip = createBlipAttachedTo (obj, Config.blip)

	if not Config.testMode then

		blip.visibleDistance = Config.visibleDistance

		blip:setData ("DoNotDrawOnMaximap", true)

	end



	objs[obj] = {}

	

	local data = objs[obj]

	

	data.prevPos = Vector3(obj.position)

	data.marker = mrk

	data.blip = blip

	data.collecting = false

	data.collected = false

	data.startTick = nil

end



addEvent ("startCreateCrystall", true)

addEventHandler ("startCreateCrystall", resourceRoot, function(posTable)

	for k, v in pairs (objs) do

		if v.marker and isElement (v.marker) then

			v.marker:destroy()

		end

		if v.blip and isElement (v.blip) then

			v.blip:destroy()

		end

		

		objs[k] = nil

		

		if k and isElement(k) then

			k:destroy()

		end

	end

	objs = {}

	collectgarbage ()

		

	if not posTable or #posTable == 0 then

		local prevRandom = {}

		for i = 1, Config.maxCristall do

			local random = math.random (#points)

			while prevRandom[random] do

				random = math.random (#points)

			end

			createCrystal (Vector3 (unpack(points[random])))

		end

		

		local t = {}

		for k, v in pairs (objs) do

			if not v.collected and not v.collecting then

				table.insert (t, {getElementPosition(k)})

			end

		end



		triggerServerEvent ("updateMyPoses", resourceRoot, t)

	else

		for i, v in ipairs (posTable) do

			createCrystal (Vector3 (unpack(v)))

		end

	end

end)



addEvent ("delAllCristal", true)

addEventHandler ("delAllCristal", resourceRoot, function()

	for k, v in pairs (objs) do

		if v.marker and isElement (v.marker) then

			v.marker:destroy()

		end

		if v.blip and isElement (v.blip) then

			v.blip:destroy()

		end

		

		if k and isElement(k) then

			k:destroy()

		end

	end

	objs = {}

	collectgarbage ()

end)



-- addCommandHandler ("col", function()

	-- triggerServerEvent ("collectCrystal", resourceRoot)

-- end)



-- addEventHandler ("onClientMarkerHit", resourceRoot, function(el)

addEventHandler ("onClientColShapeHit", resourceRoot, function(el)

	if el.type ~= "player" then return end

	if el ~= localPlayer then return end

	

	local obj = getObjFromMarker (source)

	if not obj then return end

	

	if el.vehicle and el.vehicle:getOccupant() ~= el then return end 

	

	-- if Vector3()

	-- local val = math.abs(Vector3 (el.position).z - Vector3(obj.position).z)

	-- if val > 2 then return end

	

	objs[obj].collecting = true

	

	objs[obj].marker:destroy()

	objs[obj].marker = nil

	

	objs[obj].blip:destroy()

	objs[obj].blip = nil

	

	triggerServerEvent ("collectCrystal", resourceRoot)

	

	if localPlayer:getData ("crystal:collected") + 1 == Config.maxCristall then

		playSound("files/pickup_last.wav")

		collectLastCrystal ()

	else

		playSound("files/pickup.mp3")

		collectCrystal ()

	end

end)



addEventHandler ("onClientRender", root, function()

	local val = getEasingValue (getTickCount()/1000, "SineCurve")

	for i, v in ipairs (getElementsByType ("object", resourceRoot, true)) do

		if objs[v] and (getDistanceBetweenPoints3D (v.position, localPlayer.position) < 100) then

			local data = objs[v]

			if not data.collected then

				v.rotation = Vector3(v.rotation) + Vector3 (0, 0, 0.5)

				v.position = data.prevPos + Vector3 (0, 0, 0.2*val)

				

				local posX, posY, posZ = getElementPosition(localPlayer)

				

				dxDrawMaterialLine3D(data.prevPos + Vector3 (0, 0, 2*val), data.prevPos - Vector3 (0, 0, 2*val), assets.blik, 4*val,tocolor(255, 255, 255, 60))

				

				if data.collecting then

					if not data.startTick then data.startTick = getTickCount() end

					

					local progress1 = math.min (1, (getTickCount()-data.startTick)/1000)

					local progress2 = math.min (1, (getTickCount()-data.startTick)/1000/2)

					

					local newx, newy, newz = interpolateBetween (data.prevPos, Vector3(localPlayer.position) + Vector3 (0, 0, 1), progress2, "OutQuad")

					

					v.scale = 0.08 * (1 - progress1)

					

					if progress1 >= 1 then

						data.collected = true

						

						objs[v] = nil

						v:destroy()

						

						collectgarbage()

						

						local t = {}

						-- if 

						for k, v in pairs (objs) do

							if not v.collected and not v.collecting then

								table.insert (t, {getElementPosition(k)})

							end

						end

						

						triggerServerEvent ("updateMyPoses", resourceRoot, t)

					end

					

					data.prevPos = Vector3 (newx, newy, newz)

				end

			end

		end

	end

end)



function getObjFromMarker (el)

	for obj, data in pairs (objs) do

		if data.marker == el then

			return obj

		end

	end

	return nil

end

