--[[
    .-.                     .-.
 .--' /                     \ '--.
 '--. \       _______       / .--'
     \ \   .-"       "-.   / /
      \ \ /     [?]     \ / /
       \ /               \ /
        \|   .--. .--.   |/
         | )/   | |   \( |
         |/ \__/   \__/ \|
         /      /^\      \
         \__    '='    __/
           |\         /|
           |\'"VUUUV"'/|
           \ `"""""""` /
            `-._____.-'
              / / \ \
             / /   \ \
            / /     \ \
         ,-' (       ) `-,
         `-'._)     (_.'-`
	   "GUETTO CITY RESOURCE"
		    (C) MatteO
	   G U E T T O - G R O U P
]]--

local _VER = "2.0"

local dvo = {}
dvo.shaders = {}

dvo.allowedElementType = {
	["vehicle"] = true;
}

dvo.texturesWhereApplyIt = {

		"predator92body128", "monsterb92body256a", "monstera92body256a", "andromeda92wing","fcr90092body128",

		"hotknifebody128b", "hotknifebody128a", "rcbaron92texpage64", "rcgoblin92texpage128", "rcraider92texpage128", 

		"rctiger92body128","rhino92texpage256", "petrotr92interior128","artict1logos","rumpo92adverts256","dash92interior128",

		"coach92interior128","combinetexpage128","hotdog92body256", "raindance92body128", "cargobob92body256", 

		"andromeda92body", "at400_92_256", "nevada92body256","polmavbody128a" , "sparrow92body128" , "hunterbody8bit256a" , 

		"seasparrow92floats64", "dodo92body8bit256" , "cropdustbody256", "beagle256", "hydrabody256", "rustler92body256", 

		"shamalbody256", "skimmer92body128", "stunt256", "maverick92body128", "leviathnbody8bit256", "remap", "vinil", "?emap*", "remap_body",  "body", "crome",
		"white", "rim_body", "body_k", "rimpaint", "advan_rs", "hre101p", "hreff01", "vossen", "workxts", "dusk5", "stamp", "razvarka", "bbs", "dusk10", "atv2", "hamman_editrace2", "dusk11",
	
}

local STREAMED_VEHS = { }
function dvo.onStream(vehicle)
	local vehicle = vehicle or source
	if getElementType( vehicle ) ~= "vehicle" then return end
	if dvo.allowedElementType[getElementType(vehicle)] then -- xz зач эта проверка
	if not getElementData(vehicle, "dvo.id") then return end
	if STREAMED_VEHS[ vehicle ] then return end
	--iprint(source)
	--дохуя дрочи для оптимизации
	addEventHandler( "onClientElementStreamOut", vehicle, onClientElementStreamOut_handler )
	addEventHandler( "onClientElementDestroy", vehicle, onClientElementStreamOut_handler )
	addEventHandler( "onClientElementDataChange", vehicle, onClientElementDataChange_handler )
		dvo.load(vehicle)
	STREAMED_VEHS[ vehicle ] = true
	end
end
addEventHandler("onClientElementStreamIn", root, dvo.onStream)
addEvent( "dvo.onStream", true )
addEventHandler( "dvo.onStream", getRootElement(), dvo.onStream )

function dvo.load(vehicle, player)
	--local controller = getVehicleController(vehicle)
	--if controller then
		local id = getElementData(vehicle, "dvo.id")
		local r, g, b = unpack(getElementData(vehicle, "dvo.color") or {255, 255, 255})
		if id then
			if dvo.shaders[vehicle] then
				if isElement(dvo.shaders[vehicle].vehicle) then
					for index,texture in ipairs(dvo.texturesWhereApplyIt) do
						engineRemoveShaderFromWorldTexture(dvo.shaders[vehicle].shader, texture, dvo.shaders[vehicle].vehicle)
					end
				end
				if isElement(dvo.shaders[vehicle].shader) then
					destroyElement(dvo.shaders[vehicle].shader)
				end
			end
			local shaderBody = dxCreateShader("type"..id..".fx", 1, 100, true)
			dxSetShaderValue(shaderBody, "intensity", 1)
			dxSetShaderValue(shaderBody, "rate", 1)
			dxSetShaderValue(shaderBody, "opacity", 1)
			dxSetShaderValue(shaderBody, "amp", 0.5)
			dxSetShaderValue(shaderBody, "color", r/255, g/255, b/255)
			dxSetShaderValue(shaderBody, "resolution", 1, 1)
			dxSetShaderValue(shaderBody, "surfacePosition", 0.5)
			dxSetShaderValue(shaderBody, "inten", 0.05)
			dxSetShaderValue(shaderBody, "iResolution", 1, 1)
			dxSetShaderValue(shaderBody, "mfw", 0, 1, 0)
			dxSetShaderValue(shaderBody, "mleft", 1, 0, 0)
			dxSetShaderValue(shaderBody, "vehspeed", 0.5)
			for index,texture in ipairs(dvo.texturesWhereApplyIt) do
				engineApplyShaderToWorldTexture(shaderBody, texture, vehicle)
			end
			dvo.shaders[vehicle] = {shader=shaderBody; vehicle=vehicle}
	end
end

dvo.amp = 4

function dvo.soundAmp(key) -- just for testing, but fun to test
	if key == "mouse_wheel_up" then
		dvo.amp = dvo.amp+1
	elseif key == "mouse_wheel_down" then
		dvo.amp = dvo.amp-1
	end
end

dvo.beat = true

function dvo.animatedDVO()
	if dvo.beat then
		local vehicle = getPedOccupiedVehicle(localPlayer)
		if isElement(dvo.song) then
			if dvo.shaders[localPlayer] and isElement(dvo.shaders[localPlayer].shader) then
				local soundFFT = getSoundFFTData(dvo.song, 8192, 3)
				if soundFFT then
					local value = soundFFT[1]*dvo.amp
					--dxDrawText("Amplitud: "..dvo.amp, 20, 400)	-- just for testing
					dxSetShaderValue(dvo.shaders[localPlayer].shader, "intensity", value)
				end
			end
		else
			if dvo.shaders[localPlayer] and isElement(dvo.shaders[localPlayer].shader) then
				dxSetShaderValue(dvo.shaders[localPlayer].shader, "intensity", 1)
			end
		end
	end
end
addEventHandler("onClientRender", root, dvo.animatedDVO)

function dvo.onClientSoundStarted(reason)
	if eventName == "onClientSoundStarted" then
		if isElement(source) and reason == "play" and getSoundLength(source) > 60 then -- check if sound is longer than 60 seconds so we can count it as a song
			dvo.song = source
		end	
	elseif eventName == "onClientSoundStream" then
		if reason then -- in onClientSoundStream event, first argument parsed is if the streaming was successful
			dvo.song = source
		end
	end
end
addEventHandler("onClientSoundStarted", root, dvo.onClientSoundStarted)

function dvo.onClientSoundStopped()
	if dvo.song == source then
		dvo.song = nil
	end
end
addEventHandler("onClientSoundStopped", root, dvo.onClientSoundStopped)

function dvo.toggleBeat()
	if dvo.beat then
		dvo.beat = false
		if dvo.shaders[localPlayer] and isElement(dvo.shaders[localPlayer].shader) then
			dxSetShaderValue(dvo.shaders[localPlayer].shader, "intensity", 1)
		end
		--outputChatBox("#eeeeee[DVO] #eeeeeeSound animation #ee0000DISABLED",255,255,255,true)
	else
		dvo.beat = true
		--outputChatBox("#eeeeee[DVO] #eeeeeeSound animation #00ee00ENABLED",255,255,255,true)
	end
end
addCommandHandler("dvobeat", dvo.toggleBeat)

function dvo.command(cmd, id, vehicle)
	local id = tonumber(id)
	--iprint("не оч")	
	if id and id > 0 and id < 49 then
		--outputChatBox("#eeeeee[Sat9] #eeeeeeСменил винил на: "..id,255,255,255,true)
		--local vehicle = getPedOccupiedVehicle(localPlayer)
		setElementData(localPlayer, "dvo.id", id)
		setElementData(vehicle, "dvo.id", id)
		dvo.manageDVO("save", id)
		--if vehicle then
			--paintjob = getVehiclePaintjob (vehicle)
			--if tonumber ( paintjob ) > 0 and tonumber ( paintjob ) < 3 then
			dvo.load(vehicle)
			dvo.load(vehicle)
			--iprint("клиент топ")
		--end
	--end
end
end
addEvent( "detachNeon", true )
addEventHandler( "detachNeon", root, dvo.command )




function dvo.color(cmd, r, g, b)
	local r, g, b = (r and tonumber(r) or 255), (g and tonumber(g) or 255), (b and tonumber(b) or 255)
	setElementData(getPedOccupiedVehicle(localPlayer), "dvo.color", {r, g, b})
	if dvo.shaders[vehicle] and isElement(dvo.shaders[getPedOccupiedVehicle(localPlayer)].vehicle) and isElement(dvo.shaders[getPedOccupiedVehicle(localPlayer)].shader) then
		dxSetShaderValue(dvo.shaders[getPedOccupiedVehicle(localPlayer)].shader, "color", r/255, g/255, b/255)
	end
	dvo.load(getPedOccupiedVehicle(localPlayer))
	--outputChatBox("#eeeeee[DVO] #eeeeeeNew color: "..r..", "..g.." "..b,255,255,255,true)
end
addCommandHandler("dvocolor", dvo.color)

function dvo.manageDVO(handler, id)
	local path = "id.dat"
	local exists = fileExists(path)
	if handler == "load" then
		if exists then
			local file = fileOpen(path, true)
			local content = fileRead(file, fileGetSize(file))
			fileClose(file)
			return tonumber(content)
		else
			return false
		end
	elseif handler == "save" and id then
		local file = fileCreate("id.dat")
		fileWrite(file, tostring(id))
		fileClose(file)
	end
end

function dvo.remove(cmd)
	local id = getElementData(localPlayer, "dvo.id")
	if id then
		setElementData(localPlayer, "dvo.id", false)
		dvo.manageDVO("delete")
		if isElement(dvo.shaders[localPlayer].shader) then		
			if isElement(dvo.shaders[localPlayer].vehicle) then
				for index,texture in ipairs(dvo.texturesWhereApplyIt) do
					engineRemoveShaderFromWorldTexture(dvo.shaders[localPlayer].shader, texture, dvo.shaders[localPlayer].vehicle)
				end
			end
			destroyElement(dvo.shaders[localPlayer].shader)
		end
	end
end
addCommandHandler("dvoremove", dvo.remove)

--оптимизация
function onClientElementDataChange_handler( key )
	if getElementType( source ) ~= "vehicle" then return end
	if key ~= "dvo.id" then return end
	dvo.load( source )
end

addEventHandler("onClientResourceStart", resourceRoot, function()
	for k,v in pairs( getElementsByType( "vehicle", root, true ) ) do
		dvo.onStream( v )
	end
end)

function onClientElementStreamOut_handler( vehicle )
	local vehicle = vehicle or source
	STREAMED_VEHS[ vehicle ] = nil
	if dvo.shaders[ vehicle ] then
		for k, v in pairs( dvo.shaders[ vehicle ] ) do
			if isElement( v ) then
				destroyElement( v )
			end
		end
		dvo.shaders[ vehicle ] = nil
	end
	removeEventHandler( "onClientElementStreamOut", vehicle, onClientElementStreamOut_handler )
	removeEventHandler( "onClientElementDestroy", vehicle, onClientElementStreamOut_handler )
	removeEventHandler( "onClientElementDataChange", vehicle, onClientElementDataChange_handler )
end



