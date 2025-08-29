local tex = dxCreateTexture ("textures/flame.dds")
local shader = dxCreateShader (shader_raw)
dxSetShaderValue (shader, "Tex0", tex)

local globalSize = 1.6

local vals = {}
local sizes = {}

local framesVeh = {}

local maxStageUp = 6
local maxStageDown = 14

local screenW, screenH = guiGetScreenSize()
local globalSc = screenW / 1440 * 2

local imgSize = 80 -- размер изображения
local imgPlus = 10 -- на сколько последующее изображение становится больше (если не нужно, чтоб увеличивалось, указать 0)

addEventHandler ("onClientHUDRender", root, function(dt)	
	for el, frames in pairs (framesVeh) do
		if el and isElement(el) then
			local exhaustPos = Vector3(getVehicleDummyPosition (el, "exhaust"))-- Vector3(10, 10, 10)
			local posVeh = Vector3(el.position)
			local rotVeh = Vector3(el.rotation)

			local velocity = el.velocity
			
			for side, data in pairs (framesVeh[el].flames) do
			
				local currentTime = ((getTickCount()-data.startTick)/10)
				
				local progress = currentTime * #data.data-1 / #data.data
				local index = math.ceil(progress)
				
				for i, v in pairs (data.data) do
					if side == 1 then
						newPos = Vector3(getPositionFromElementOffset(el, exhaustPos.x, exhaustPos.y, exhaustPos.z))
					else
						newPos = Vector3(getPositionFromElementOffset(el, -exhaustPos.x, exhaustPos.y, exhaustPos.z))
					end
					local cX, cY, cZ = getCameraMatrix()					
						
					local moveX_offset = math.cos(math.rad(rotVeh.z + 90)) * 0.15
					local moveY_offset = math.sin(math.rad(rotVeh.z + 90)) * 0.15
					
					local moveX = math.cos(math.rad(rotVeh.z + 90)) * v.dist
					local moveY = math.sin(math.rad(rotVeh.z + 90)) * v.dist
					
					local cos = math.cos(math.rad(rotVeh.z + 90)) * (globalSize + i*0.15) * 0.2
					local sin = math.sin(math.rad(rotVeh.z + 90)) * (globalSize + i*0.15) * 0.2
					
					local cos2 = math.cos(math.rad(rotVeh.z)) * v.x
					local sin2 = math.sin(math.rad(rotVeh.z)) * v.x
					
					local mathVec = Vector3 (moveX_offset, moveY_offset, v.z) - Vector3 (moveX, moveY, 0) - Vector3(cos, sin, 0) - Vector3(cos2, 0, 0)
					
					local ps = newPos + mathVec
					local scrX, scrY = getScreenFromWorldPosition(ps)					
					local distance = getDistanceBetweenPoints3D(cX, cY, cZ, ps)	
								
					-- if (scrX) and isLineOfSightClear(cX, cY, cZ, ps, true, true, false, true, false, false, false) and distance < 30 then
					if (scrX) and isLineOfSightClear(cX, cY, cZ, ps, true, true, true, true, false, false, false) then
						-- local scale = globalSc / distance *imgSize+i*imgPlus
						local scale = globalSc/math.max(1,distance)*(imgSize+i*imgPlus)
						
						dxDrawImage(scrX-scale/2, scrY-scale/2, scale, scale, shader, math.random(0,180), 0, 0, tocolor(255, 255, 255, 255))
					end
				end
				
				if progress > #data.data then
					regenOtstrel (el, side)
				end
			end
		else
			removeOtstrel(el)
		end
	end
end)

function math.clamp(value, minValue, maxValue)
	return math.max(minValue, math.min(value, maxValue))
end


function removeOtstrel (veh)
	framesVeh[veh] = nil
end

function regenOtstrel(veh, side)
	local t = framesVeh[veh]
	if not t then return end 
	
	t.flames[side].startTick = getTickCount()
	t.flames[side].stage = t.flames[side].stage + 1
	t.flames[side].data = {}
	
	local maxStage = t.flames[side].isDownShift and maxStageDown or maxStageUp
	
	if t.flames[side].stage <= maxStage then
		for i = 1, math.random(2, 3) do
			
			t.flames[side].data[i] = {}
			
			-- t.flames[side].data[i].x = math.random(-10, 10)/400
			-- t.flames[side].data[i].z = math.random(-10, 10)/400
			t.flames[side].data[i].x = 0
			t.flames[side].data[i].z = 0
			
			-- t.flames[side].data[i].dist = math.random(10, 30)/100
			local prev = t.flames[side].data[i-1]
			t.flames[side].data[i].dist = (prev and prev.dist or 0) + math.random(5, 20)/160
		end
		
		if t.flames[side].isDownShift and t.flames[side].stage % 5 == 0 then
			soundOtstrel (veh, t.flames[side].isDownShift)
			-- setTimer(soundOtstrel, 100, 2, veh, t.flames[side].isDownShift)
		end
	else
		if t.flames[1] and t.flames[1].stage > maxStage then
			if t.flames[2] and t.flames[2].stage < maxStage then
				return
			end
			
			removeOtstrel (veh)
		end
	end
end

function soundOtstrel (veh, isDownShift)
	if not getElementData(veh, "AddOtsrel" ) then return end
	-- local sound = playSound3D(":defaulttstats/sounds/als/"..(isDownShift and "1" or math.random(1, 13))..".wav", veh.position, false)
	local sound = playSound3D(":defaulttstats/sounds/als/"..(math.random(1, 13))..".wav", veh.position, false)
	-- local sound = playSound3D("sounds/11.wav", veh.position, false)
	attachElements(sound, veh)
	setSoundVolume(sound, 1.5)
	setSoundSpeed(sound, 1.5)
	
	setSoundEffectEnabled(sound, "echo", true)
	setSoundEffectEnabled(sound, "compressor", true)
end

function addOtstrel (veh, isDownShift)

	if not getElementData(veh, "AddOtsrel" ) then return end
	local t = {}
	t.flames = {}
	
	for side = 1, isDoubleExhauts(veh) and 2 or 1 do
		if not t.flames[side] then 
			t.flames[side] = {
				startTick = getTickCount(),
				stage = 1,
				isDownShift = isDownShift,
				data = {},
			}
			
			soundOtstrel (veh, isDownShift)
		end
		
		for i = 1, math.random(3, 4) do
			
			t.flames[side].data[i] = {}
			
			t.flames[side].data[i].x = 0--math.random(-10, 10)/100
			t.flames[side].data[i].z = 0--math.random(-10, 10)/500
			
			t.flames[side].data[i].dist = 0--math.random(10, 30)/100
		end
	end
	
	framesVeh[veh] = t
end

-- addEventHandler ("onClientResourceStart", resourceRoot, function()
	 -- addOtstrel (localPlayer.vehicle)
-- end)

-- local prevVeh = nil

-- function funcInput()
	-- for i, v in ipairs (getElementsByType("vehicle", root, true)) do
		-- addOtstrel (v)
	-- end
-- end
-- bindKey( "h", "down", funcInput )

function getPositionFromElementOffset(element,offX,offY,offZ)
	local m = getElementMatrix ( element )  -- Get the matrix
	local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform
	local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
	local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
	return x, y, z  -- Return the transformed point
end

local bytes = {["2"] = true, ["6"] = true, ["A"] = true, ["E"] = true}
function isDoubleExhauts (veh)
    local handling = getVehicleHandling (veh)["modelFlags"]
    local newHandling = string.format ("%X", handling)
    local reversedHex = string.reverse ( newHandling )..string.rep ( "0", 8 - string.len ( newHandling ) )
	
    local byte4 = string.sub(reversedHex, 4, 4)
    if bytes[byte4] then
        return true
    else
        return false
    end
end

---------------------------------------------------------------
-- Sitemiz : https://sparrow-mta.blogspot.com/

-- Facebook : https://facebook.com/sparrowgta/
-- İnstagram : https://instagram.com/sparrowmta/
-- YouTube : https://www.youtube.com/@TurkishSparroW/

-- Discord : https://discord.gg/DzgEcvy
---------------------------------------------------------------