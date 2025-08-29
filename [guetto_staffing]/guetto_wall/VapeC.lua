local font = dxCreateFont("font.ttf", 10)

function convertNumber(number)
    local formatted = number
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2')
        if k == 0 then
            break
        end
    end
    return formatted
end

function dxDrawTextOnElement(TheElement, text, height, R, G, B, alpha, size, font, ...)
    local x, y, z = getElementPosition(TheElement)
    local sx, sy = getScreenFromWorldPosition(x, y, z + height)
    if sx and sy then
        dxDrawText(text, sx + 2, sy + 2, sx, sy, tocolor(R or 255, G or 255, B or 255, alpha or 255), size, font or "font", "center", "center", false, false, false, true, false)
    end
end

function onDraw ()
    local result = getElementsByType('player')
    if result and #result ~= 0 then
        for i = 1, #result do
            local other = result[i]
            if isElement(other) then
                if other ~= localPlayer then
                    local x, y, z = getElementPosition(localPlayer)
                    local ax, ay, az = getElementPosition(other)
                    if getElementHealth(other) > 0 then
                        --dxDrawLine3D(x, y, z, ax, ay, az, tocolor(unpack(config["Color"])), config["Lines"], true)
                        dxDrawTextOnElement(other, " " .. config["HexColor"] .. "" .. (getElementData(other, config["IDSystem"]) or "N/A") .. " | " .. getPlayerName(other) .. "#FFFFFF", 1, 255, 255, 255, 255, config["Font"], "font")
                    end
                end
            end
        end
    end
end

local state = false; 
addEvent("squady.onWall", true)
addEventHandler("squady.onWall", resourceRoot, function()
    if not state then 
        state = true 
        addEventHandler("onClientRender", root, onDraw)
    else
        state = false 
        removeEventHandler("onClientRender", root, onDraw)
    end
end)

function onDrawVeh ( )
    local result = getElementsByType('vehicle')
    if result and #result ~= 0 then
        for i = 1, #result do
            local other = result[i]
            if isElement(other) then
                if other ~= localPlayer then
                    local x, y, z = getElementPosition(localPlayer)
                    local ax, ay, az = getElementPosition(other)
                    if getElementHealth(other) > 0 then
                        local model = getElementModel(other)
                        local life = getElementHealth(other)
                        --dxDrawLine3D(x, y, z, ax, ay, az, tocolor(unpack(config["Color"])), config["Lines"], true)
                        dxDrawTextOnElement(other, "Modelo: ["..(model).."]\nVida: ["..life.."]", 1, 255, 255, 255, 255, config["Font"], "font")
                    end
                end
            end
        end
    end
end

local stateveh = false; 
addEvent("squady.onWall.Veh", true)
addEventHandler("squady.onWall.Veh", resourceRoot, function()
    if not stateveh then 
        stateveh = true 
        addEventHandler("onClientRender", root, onDrawVeh)
    else
        stateveh = false 
        removeEventHandler("onClientRender", root, onDrawVeh)
    end
end)