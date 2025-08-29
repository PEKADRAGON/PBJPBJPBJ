local x, y = guiGetScreenSize() 
local startX, startY = (x - 235), (y / 2 - 166)

function draw ( )
    local time_intoxication = interpolateBetween(30, 0, 0, 0, 0, 0, ((getTickCount() - tick) / (30 * 1000)), 'Linear')

    dxDrawText('VOCÊ TEM '..math.floor(time_intoxication)..' SEGUNDOS ANTES DE MORRER', x / 2 - (dxGetTextWidth('VOCÊ TEM '..math.floor(time_intoxication)..' SEGUNDOS ANTES DE MORRER', 1, exports['guetto_assets']:dxCreateFont('medium', 15)) / 2), y - 40, 0, 0, tocolor(255, 255, 255, alpha), 1, exports['guetto_assets']:dxCreateFont('medium', 15))

    if (time_intoxication <= 0) then 
        removeEventHandler('onClientRender', root, draw)
    end
end

addEvent('onPlayerShowFire', true)
addEventHandler('onPlayerShowFire', root, function ( x, y, z )
    createFire ( x, y, z, 10 )
    local sound = playSound3D('fire.mp3', x, y, z, true)
    setTimer ( function ( ) 
        extinguishFire ( x, y, z, 10 )
        if sound and isElement(sound) then 
            destroyElement(sound)
        end
    end, 30000, 1)
end)

addEvent('onPlayerShowText', true)
addEventHandler('onPlayerShowText', resourceRoot, function ( )
    tick = getTickCount()
    addEventHandler('onClientRender', root, draw)
end)