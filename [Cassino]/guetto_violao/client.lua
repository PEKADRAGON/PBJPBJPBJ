local ifp = engineLoadIFP("baglama.ifp", "baglama")
local musicSound

addEvent("baglama", true)
addEventHandler("baglama", root,
	function(enable)
		if (enable) then 
			setPedAnimation(source, "baglama", "cj_guitar_play", -1, true, false)
			Object = createObject(1563, 0, 0, 0)
    		exports.pAttach:attach(Object, source, 4, 0.08,0.21,-0.27,151.2,0,-169.2)
		else 
			setPedAnimation(source)
		end		
	end
)

addEventHandler("onClientResourceStart", resourceRoot,
    function()
        triggerServerEvent("onClientSync", resourceRoot)
	end
)

addEventHandler("onClientResourceStop", resourceRoot,
	function()
		if ifp then
			for _, player in ipairs(getElementsByType("player")) do
				local _, baglama = getPedAnimation(player)
				if (baglama == "cj_guitar_play") then
					setPedAnimation(player)
				end
			end
			destroyElement(ifp)
		end

		if isElement(musicSound) then
			destroyElement(musicSound)
		end
	end
)

local soundViolao = {}

addEvent("playMusic", true)
addEventHandler("playMusic", resourceRoot, function (player)
   
	if soundViolao[player] and isElement(soundViolao[player]) then 
		destroyElement(soundViolao[player])
		soundViolao[player] = nil 
	end

    local x, y, z = getElementPosition(localPlayer)
    soundViolao[player] = playSound3D("mp3/baglama.mp3", x, y, z, true)
    setSoundMaxDistance(soundViolao[player], 15) 
	setSoundVolume(soundViolao[player], 0.2)
end)

-- Müzik durdurma event'i
addEvent("stopMusic", true)
addEventHandler("stopMusic", resourceRoot, function (player)

	if soundViolao[player] and isElement(soundViolao[player]) then 
		stopSound(soundViolao[player])
		soundViolao[player] = nil 
	end

	if Object and isElement(Object) then 
		destroyElement(Object)
		Object = nil 
	end

end)

-- Müzik konumunu oyuncu ile senkronize etme
addEventHandler("onClientRender", root, function()
    if isElement(musicSound) then
        local x, y, z = getElementPosition(localPlayer)
        setElementPosition(musicSound, x, y, z)
    end
end)

-- Model 3D Warehouse, Author : Ali K.
-- Müzik : Harun Murat ÖZGÜÇ : https://www.youtube.com/watch?v=diAkfxeaibs
-- Script : SparroWMTA

-- SparroW MTA : https://sparrow-mta.blogspot.com
-- Facebook : https://www.facebook.com/sparrowgta/
-- İnstagram : https://www.instagram.com/sparrowmta/
-- Discord : https://discord.gg/DzgEcvy