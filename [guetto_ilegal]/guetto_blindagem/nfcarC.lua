local screen = {guiGetScreenSize()}
local x2, y2 = (screen[1]/1920), (screen[2]/1080)
local x, y = (screen[1]/1366), (screen[2]/768)

local font = dxCreateFont("Roboto-Medium.ttf", x*10)

addEventHandler("onClientRender", root,
function()
    ---dxDrawRectangle(x2 * 40, y2 * 848, x2 * 309, y2 * 192, tocolor(0, 0, 0, 255))
    local vehicle = getPedOccupiedVehicle(localPlayer)
    if vehicle then
        if (getElementData(vehicle, "VehBlindagem")) then
            local blindagemState = (getElementData(vehicle, "VehBlindagem") or 0)
            dxDrawText("BLINDAGEM "..blindagemState.."%", x * 40, y * 875, x * 246, y * 602, tocolor(255, 255, 255, 255), 1.00, font, "center", "center", false, false, true, false, false)
        end
    end
end)

local function perderBlindagem(attacker)
    if getElementData(source, "VehBlindagem") and type(getElementData(source, "VehBlindagem")) == "number" then 
        if getElementData(source, "VehBlindagem") <= 0 then
            setElementData(source, "VehBlindagem", 0)
        else
            setElementData(source, "VehBlindagem", getElementData(source, "VehBlindagem") - 1)
            cancelEvent()
        end
    end
end
addEventHandler("onClientVehicleDamage", getRootElement(), perderBlindagem)

addEventHandler("onClientPlayerDamage", localPlayer, function ( )
    if (getPedOccupiedVehicle(localPlayer) and getElementData(getPedOccupiedVehicle(localPlayer), "VehBlindagem")) then 
        cancelEvent()
    end
end)

addEvent("protegerPlayer", true)
addEventHandler("protegerPlayer", localPlayer, function(state)
	invencible = state
end)