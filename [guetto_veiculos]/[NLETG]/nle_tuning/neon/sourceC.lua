



local lastTick = getTickCount()
local s = {guiGetScreenSize()}

local vehicle_neons = {}

addEventHandler("onClientRender",root,
	function()
		for vehicle,table in pairs(vehicle_neons) do
			if vehicle and isElement(vehicle) and getElementType(vehicle) == 'vehicle' then 
				local int,dim = getElementInterior(vehicle),getElementDimension(vehicle)
				--local int2,dim2 = getElementInterior(object["left"])
				--outputChatBox(object["left"])
				for name,object in pairs(table) do
					local int2,dim2 = getElementInterior(object),getElementDimension(object)
					if int ~= int2 then
						setElementInterior(object,int)
					end
					if dim ~= dim2 then
						setElementDimension(object,dim)
					end
				end
			end
		end
	end
)


local componentsVehiclePositions = {

	[ 411 ] = {
		['right'] = {-0.5, 0, -0.42, 0,-0.5,0};
		['left'] = {0.5, 0, -0.42, 0,0.5,0};
	};

	[ 566 ] = {
		['right'] = {-0.5, 0, -0.42, 0,-0.5,0};
		['left'] = {0.5, 0, -0.42, 0,0.5,0};
	};

	[ 561 ] = {
		['right'] = {-0.5, 0, -0.42, 0,-0.5,0};
		['left'] = {0.5, 0, -0.42, 0,0.5,0};
	};
	
	[ 540 ] = {
		['right'] = {-0.5, 0, -0.42, 0,-0.5,0};
		['left'] = {0.5, 0, -0.42, 0,0.5,0};
	};

	[ 479 ] = {
		['right'] = {-0.5, 0, -0.42, 0,-0.5,0};
		['left'] = {0.5, 0, -0.42, 0,0.5,0};
	};

	[ 547 ] = {
		['right'] = {-0.7,0,-0.3,0,-0.5,0};
		['left'] = {0.7,0,-0.3,0,0.5,0};
	};

	[ 580 ] = {
		['right'] = {-0.7,0,-0.35,0,-0.5,0};
		['left'] = {0.7,0,-0.35,0,0.5,0};
	};

	[ 541 ] = {
		['right'] = {-0.5, 0, -0.25, 0,-0.5,0};
		['left'] = {0.5, 0, -0.25, 0,0.5,0};
	};

	[ 562 ] = {
		['right'] = {-0.5,0,-0.25,0,-0.5,0};
		['left'] = {0.5,0,-0.25,0,0.5,0};
	};

	[ 415 ] = {
		['right'] = {-0.5,0,-0.25,0,-0.5,0};
		['left'] = {0.5,0,-0.25,0,0.5,0};
	};

	[ 474 ] = {
		['right'] = {-0.5,0,-0.25,0,-0.5,0};
		['left'] = {0.5,0,-0.25,0,0.5,0};
	};

	[ 405 ] = {
		['right'] = {-0.5,0,-0.50,0,-0.5,0};
		['left'] = {0.5,0,-0.50,0,0.5,0};
	};

	[ 529 ] = {
		['right'] = {-0.5,0,-0.50,0,-0.5,0};
		['left'] = {0.5,0,-0.50,0,0.5,0};
	};

	[ 527 ] = {
		['right'] = {-0.5,0,-0.50,0,-0.5,0};
		['left'] = {0.5,0,-0.50,0,0.5,0};
	};

	[ 426 ] = {
		['right'] = {-0.5,0,-0.45,0,-0.5,0};
		['left'] = {0.5,0,-0.45,0,0.5,0};
	};

	[ 550 ] = {
		['right'] = {-0.5,0,-0.35,0,-0.5,0};
		['left'] = {0.5,0,-0.35,0,0.5,0};
	};

	[ 516 ] = {
		['right'] = {-0.5,0,-0.14,0,-0.5,0};
		['left'] = {0.5,0,-0.14,0,0.5,0};
	};

	
	[ 458 ] = {
		['right'] = {-0.5,0,-0.25,0,-0.5,0};
		['left'] = {0.5,0,-0.25,0,0.5,0};
	};

	[ 404 ] = {
		['right'] = {-0.5,0,-0.25,0,-0.5,0};
		['left'] = {0.5,0,-0.25,0,0.5,0};
	};

	[ 400 ] = {
		['right'] = {-0.5,0,-0.25,0,-0.5,0};
		['left'] = {0.5,0,-0.25,0,0.5,0};
	};

	[ 604 ] = {
		['right'] = {-0.5,0,-0.25,0,-0.5,0};
		['left'] = {0.5,0,-0.25,0,0.5,0};
	};

	[ 496 ] = {
		['right'] = {-0.5,0,-0.25,0,-0.5,0};
		['left'] = {0.5,0,-0.25,0,0.5,0};
	};

	[ 526 ] = {
		['right'] = {-0.5,0,-0.25,0,-0.5,0};
		['left'] = {0.5,0,-0.25,0,0.5,0};
	};

	[ 545 ] = {
		['right'] = {-0.5,0,-0.40,0,-0.5,0};
		['left'] = {0.5,0,-0.40,0,0.5,0};
	};

	[ 422 ] = {
		['right'] = {-0.5,0,-0.55,0,-0.5,0};
		['left'] = {0.5,0,-0.55,0,0.5,0};
	};

	[ 419 ] = {
		['right'] = {-0.5,0,-0.55,0,-0.5,0};
		['left'] = {0.5,0,-0.55,0,0.5,0};
	};

	[ 579 ] = {
		['right'] = {-0.5,0,-0.55,0,-0.5,0};
		['left'] = {0.5,0,-0.55,0,0.5,0};
	};

	[ 507 ] = {
		['right'] = {-0.5,0,-0.55,0,-0.5,0};
		['left'] = {0.5,0,-0.55,0,0.5,0};
	};

	[ 518 ] = {
		['right'] = {-0.5,0,-0.55,0,-0.5,0};
		['left'] = {0.5,0,-0.55,0,0.5,0};
	};

	[ 551 ] = {
		['right'] = {-0.5,0,-0.40,0,-0.5,0};
		['left'] = {0.5,0,-0.40,0,0.5,0};
	};

	[ 602 ] = {
		['right'] = {-0.5,0,-0.50,0,-0.5,0};
		['left'] = {0.5,0,-0.50,0,0.5,0};
	};

}

function addNeon(vehicle)
	if vehicle then
		if getVehicleType(vehicle) == "Bike" then return end
		if isElementStreamedIn(vehicle) then
			local neon_id = getElementData(vehicle,"danihe->vehicles->neon") or 0
			if neon_objects[neon_id] then
				if vehicle_neons[vehicle] then
					removeNeon(vehicle)
					addNeon(vehicle)
				else

					vehicle_neons[vehicle] = {}
					local pos = Vector3(getElementPosition(vehicle))
					local model = getElementModel(vehicle);

			
					if (not componentsVehiclePositions[model]) then 
						return print ('Modelo do veículo: '..model..' não existe na tabela!')
					end;
					
					local right = componentsVehiclePositions[model]['right']
					local left = componentsVehiclePositions[model]['left']

					vehicle_neons[vehicle]["left"] = createObject(neon_objects[neon_id],pos.x,pos.y,pos.z)
			
					setElementInterior(vehicle_neons[vehicle]["left"],getElementInterior(vehicle))
					setElementDimension(vehicle_neons[vehicle]["left"],getElementDimension(vehicle))

					setElementCollisionsEnabled(vehicle_neons[vehicle]["left"],false)

					attachElements(
						vehicle_neons[vehicle]["left"], vehicle, 
						left[1], left[2] , left[3] , left[4] , left[5] , left[6] 
					)

					vehicle_neons[vehicle]["right"] = createObject(neon_objects[neon_id],pos.x,pos.y,pos.z)

					setElementInterior(vehicle_neons[vehicle]["right"],getElementInterior(vehicle))
					setElementDimension(vehicle_neons[vehicle]["right"],getElementDimension(vehicle))

					setElementCollisionsEnabled(vehicle_neons[vehicle]["right"],false)

					attachElements(
						vehicle_neons[vehicle]["right"], vehicle, 
						right[1], right[2] , left[3] , left[4] , left[5] , left[6] 
					)


				end
			else
				if vehicle_neons[vehicle] then
					removeNeon(vehicle)
				end
			end
		end
	end
end

function removeNeon(vehicle)
	if vehicle then
		if getVehicleType(vehicle) == "Bike" then return end	
		if vehicle_neons[vehicle] then
			if (vehicle_neons[vehicle]["right"] and isElement(vehicle_neons[vehicle]["right"]) and vehicle_neons[vehicle]["left"] and isElement(vehicle_neons[vehicle]["left"])) then 
				destroyElement(vehicle_neons[vehicle]["left"])
				destroyElement(vehicle_neons[vehicle]["right"])
				vehicle_neons[vehicle] = nil
			end
		end
	end
end

addEventHandler("onClientResourceStart",resourceRoot,
	function()
		for k,v in ipairs(getElementsByType("vehicle")) do
			if isElementStreamedIn(v) then
				addNeon(v)
			end
		end
	end
)

addEventHandler("onClientElementStreamIn",root,
	function()
		if getElementType(source) == "vehicle" then
			addNeon(source)
		end
	end
)

addEventHandler("onClientElementStreamOut",root,
	function()
		if getElementType(source) == "vehicle" then
			removeNeon(source)
		end
	end
)

addEventHandler("onClientElementDestroy",root,
	function()
		if getElementType(source) == "vehicle" then
			removeNeon(source)
		end
	end
)


addEventHandler("onClientElementDataChange",root,
	function(data)
		if getElementType(source) == "vehicle" and isElementStreamedIn(source) then
			if data == "danihe->vehicles->neon" then
				addNeon(source)
			end
		end
	end
)