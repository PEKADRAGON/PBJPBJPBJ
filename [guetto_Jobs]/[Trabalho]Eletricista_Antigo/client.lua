function playsound(x, y, z)
	if x == "stop" then
		if isElement(som) then
    		stopSound(som)
    		destroyElement(fx)
    	end
    else
		if isElement(som) then
			stopSound(som)
			destroyElement(fx)
		end
		som = playSound3D("sfx/sound.mp3", x, y, z, true)
		fx = createEffect("prt_spark_2", x, y, z)
	end
end
addEvent("sound", true)
addEventHandler("sound", resourceRoot, playsound)