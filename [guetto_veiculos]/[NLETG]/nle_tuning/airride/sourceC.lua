



local lastTick = getTickCount()
local s = {guiGetScreenSize()}
local ar_timer

function toggleAirride(cmd,level)
	if isTimer(ar_timer) then return end
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if vehicle then
		local airride = getElementData(vehicle,"danihe->tuning->airride") or 0
		local airride_level = getElementData(vehicle,"danihe->tuning->airride_level") or 3
		if airride > 0 then
			if tonumber(level) then
				level = tonumber(level)
				if level >= 0 and level <= 5 then
					if level == airride_level then
						outputChatBox("#d64c45[Um erro ocorreu]:#dedede Seu veículo está atualmente neste nível #d6af42airride#dedede! #d6af42(" .. level .. ")",0,0,0,true)
					else
						if getElementSpeed(vehicle,2) > 0 then
							outputChatBox("#d64c45[Um erro ocorreu]:#dedede Você não pode parar #d6af42airride#dedede na hora!",0,0,0,true)
						else
							if getElementData(vehicle,"vehicle.handbrake") then
								outputChatBox("#d64c45[Um erro occira]:#dedede Com #d6af42handbrake acionado#dedede não pode usar #d6af42airride!",0,0,0,true)
							else
								triggerServerEvent("changeAirrideLevel",resourceRoot,localPlayer,vehicle,airride_level,level)
								ar_timer = setTimer(function() end,2000,1)
							end
						end
					end
				else
					outputChatBox("#d64c45[Ocorreu um erro]:#dedede Errado #d6af42airride#dedede nível inserido! #d6af42(" .. level .. ")",0,0,0,true)
				end
			else
				outputChatBox("#d6af42[Usar]:#dedede /" .. cmd .. " [Nível (0-5)]",0,0,0,true)
				outputChatBox("#dededeAtualmente: #d6af42airride#dedede nível: #d6af42" .. airride_level,0,0,0,true)
			end
		end
	end
end
addCommandHandler("airride",toggleAirride)
addCommandHandler("ar",toggleAirride)
addCommandHandler("air",toggleAirride)

addEvent("playbackAirride",true)
addEventHandler("playbackAirride",localPlayer,
	function(vehicle)
		playSound3D("sounds/airride.ogg",Vector3(getElementPosition(vehicle)))
	end
)