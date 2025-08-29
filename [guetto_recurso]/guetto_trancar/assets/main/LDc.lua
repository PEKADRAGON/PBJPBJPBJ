--[[
    --» sᴄʀɪᴘᴛ ғᴇɪᴛᴏ ᴘᴏʀ » Pedro Developer
--]]

addEvent('onClientPlaySoundVehicle', true)
addEventHandler('onClientPlaySoundVehicle', root, 

    function(file, x, y, z)

        playSound3D(file, x, y, z)  

    end

)

setTimer(function()

    if (getPedOccupiedVehicle(localPlayer) and getVehicleType(getPedOccupiedVehicle(localPlayer)) == 'Automobile') then 

        if not (getElementData(localPlayer, 'belt')) then 

            --playSound('assets/sounds/ov.mp3')

        end

    end

end, 1000, 0)