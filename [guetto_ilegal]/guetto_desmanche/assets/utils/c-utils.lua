-- // Responsive and Customizable functions

screen = Vector2(guiGetScreenSize())
middle = Vector2(screen.x / 2, screen.y / 2)
screenScale = math.min(1.2, math.max(0.7, (screen.y / 1080)))

function respc(value)
    return value * screenScale
end

_dxDrawText = dxDrawText
function dxDrawText(boolean, text, x, y, w, h, ...)
    if boolean then 
        return _dxDrawText(text, x, y, w + x, h + y, ...)
    else
        return _dxDrawText(text, x, y, w, h, ...)
    end
end

function Vector(x, y, z)
    return {x = x, y = y, z = z}
end

function isCursorOnElement (x, y, width, height) -- Verificação do cursor do Client.
    if not isCursorShowing () then
        return false
    end
    
    local cursor = {getCursorPosition ()}
    local cursorx, cursory = (cursor[1] * screen.x), (cursor[2] * screen.y)
    
    return cursorx >= x and cursorx <= (x + width) and cursory >= y and cursory <= (y + height)
end

local fonts = {}
function getFont(font, size)
    local index = font .. size

    if not fonts[index] then
        fonts[index] = dxCreateFont('assets/fonts/' .. font .. '.ttf', size, false, "cleartype_natural")
    end

    return fonts[index]
end

function getNameFromPart(part)
	local returnValue, Tabela, Tabela2 = false, {}, {}
	for k, v in pairs(config["partTable"]) do
		if v[1] == part then
			returnValue, Tabela, Tabela2 = v[2], v[4], v[3]
			break
		end
	end
	return returnValue, Tabela, Tabela2
end

function dxDrawTextOnElement(TheElement,text,height,distance,R,G,B,alpha,size,font,...)
	local x, y, z = getElementPosition(TheElement)
	local x2, y2, z2 = getCameraMatrix()
	local distance = distance or 20
	local height = height or 1

	if (isLineOfSightClear(x, y, z+2, x2, y2, z2, ...)) then
		local sx, sy = getScreenFromWorldPosition(x, y, z+height)
		if(sx) and (sy) then
			local distanceBetweenPoints = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
			if(distanceBetweenPoints < distance) then
				dxDrawText(false, text, sx+2, sy+2, sx, sy, tocolor(R or 255, G or 255, B or 255, alpha or 255), (size or 1)-(distanceBetweenPoints / distance), font or "arial", "center", "center")
			end
		end
	end
end

function getComponentRealName(name)
    for i,v in ipairs(config["partTable"]) do 
        if v[2] == name then 
            return v[1]
        end 
    end 
end 

function getPartPosition(element, part)
	local x, y, z = false, nil, nil
	if getElementType(element) == "vehicle" then
		x, y, z = getVehicleComponentPosition(element, part, "world")
	end
	return x,y,z
end

function getAllComponentsVehicleAndGiveMoney(thePlayer, theVehicle, NomeParte)
    local components = getVehicleComponents(theVehicle)
    contage = 0
    for k in pairs(components) do
        local nameComponent = getNameFromPart(k)
        if nameComponent then 
            contage = contage + 1
        end 
    end
    triggerServerEvent("squady.giveMoneyFromPart", resourceRoot, theVehicle, contage, NomeParte)
end 
addEvent("squady.getAllComponentsVehicleAndGiveMoney", true)
addEventHandler("squady.getAllComponentsVehicleAndGiveMoney", root, getAllComponentsVehicleAndGiveMoney)