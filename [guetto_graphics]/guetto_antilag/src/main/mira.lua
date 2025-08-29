--[[
    local x, y = 1920, 1080

local aimPositions = {
	['1920x1080'] = { normal = {1015, 431}; vehicle = {1015, 431} };
	['1680x1050'] = { normal = {888, 420}; vehicle = {888, 420} };
	['1600x1024'] = { normal = {845, 409}; vehicle = {845, 409} };
	['1600x900'] = { normal = {845, 360}; vehicle = {845, 360} };
	['1440x900'] = { normal = {760, 360}; vehicle = {760, 360} };
	['1366x768'] = { normal = {720, 307}; vehicle = {720, 307} };
	['1360x768'] = { normal = {717, 307}; vehicle = {717, 307} };
	['1280x1024'] = { normal = {675, 409}; vehicle = {675, 409} };
	['1280x960'] = { normal = {674, 384}; vehicle = {674, 384} };
	['1280x800'] = { normal = {675, 319}; vehicle = {675, 319} };
	['1280x768'] = { normal = {675, 307}; vehicle = {675, 307} };
	['1280x720'] = { normal = {675, 288}; vehicle = {675, 288} };
	['1176x664'] = { normal = {620, 265}; vehicle = {620, 265} };
	['1152x864'] = { normal = {607, 345}; vehicle = {607, 345} };
	['1024x768'] = { normal = {539, 307}; vehicle = {539, 307} };
	['800x600'] = { normal = {420, 240}; vehicle = {420, 240} };
	['720x576'] = { normal = {378, 230}; vehicle = {378, 230} };
	['720x480'] = { normal = {378, 192}; vehicle = {378, 192} };
	['640x480'] = { normal = {336, 192}; vehicle = {336, 192} };
}


addEventHandler('onClientRender', root, function()
    if interface.dados and interface.dados.mira then
        if (getPedWeapon(localPlayer) == 34) then 
            if not (isPlayerHudComponentVisible('crosshair')) then 
                setPlayerHudComponentVisible('crosshair', true) 
            end 
            return
        else
            if (isPlayerHudComponentVisible('crosshair')) then 
                setPlayerHudComponentVisible('crosshair', false) 
            end
        end
        if (isPedAiming(localPlayer)) then 
            if (aimPositions[x..'x'..y]) then 
                local aimPosition = aimPositions[x..'x'..y].normal 
                if (isPedInVehicle(localPlayer)) then 
                    aimPosition = aimPositions[x..'x'..y].vehicle  
                end
                local posX = (1920 - interface.dados.mira.tamanho) / 2 
                local posY = (1080 - interface.dados.mira.tamanho) / 2

                local color = tocolor(interface.dados.mira.cor[1], interface.dados.mira.cor[2], interface.dados.mira.cor[3], interface.dados.mira.opacidade)
                _dxDrawImage(posX,posY, interface.dados.mira.tamanho, interface.dados.mira.tamanho, config["miras"][interface.dados.mira.index][1], 0, 0, 0, color, false, true)
                if (isPlayerHudComponentVisible('crosshair')) then 
                    setPlayerHudComponentVisible('crosshair', false) 
                end 
            else
                if (isPedInVehicle (localPlayer)) then
                    local color = tocolor(interface.dados.mira.cor[1], interface.dados.mira.cor[2], interface.dados.mira.cor[3], interface.dados.mira.opacidade)
                    _dxDrawImage (x / 2 + (interface.dados.mira.tamanho/2), y / 2 - (interface.dados.mira.tamanho/2), interface.dados.mira.tamanho, interface.dados.mira.tamanho, config["miras"][interface.dados.mira.index][1], 0, 0, 0, color, false, true)
                else
                    local ax, ay, az = getPedTargetStart (localPlayer)
                    screenWorld = {getScreenFromWorldPosition (ax, ay, az)}
                    local color = tocolor(interface.dados.mira.cor[1], interface.dados.mira.cor[2], interface.dados.mira.cor[3], interface.dados.mira.opacidade)
                    --_dxDrawImage(math.floor(screenWorld[1]), math.floor(screenWorld[2]), interface.dados.mira.tamanho, interface.dados.mira.tamanho, config["miras"][interface.dados.mira.index][1], 0, 0, 0, color, false, true)
                end
            end
        end
    else
        setPlayerHudComponentVisible('crosshair', true) 
    end
end)
]]