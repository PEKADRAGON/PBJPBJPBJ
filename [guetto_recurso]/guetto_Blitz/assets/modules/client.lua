-- // Responsive and Customizable functions

screen = Vector2(guiGetScreenSize())
middle = Vector2(screen.x / 2, screen.y / 2)
screenScale = math.min(1.2, math.max(0.7, (screen.y / 1080)))

function respc(value)
    return value * screenScale
end

_dxDrawText = dxDrawText
function dxDrawText(text, x, y, w, h, ...)
    return _dxDrawText(text, x, y, w + x, h + y, ...)
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

local _dxDrawImageSpacing = dxDrawImageSpacing;
function dxDrawImageSpacing(x, y, width, height, spacing, ...)
	local padding = spacing * 2

	return dxDrawImage(x - spacing, y - spacing, width + padding, height + padding, ...)
end

function lerp(a, b, t)
    return math.max(a + (b - a) * t, 0)
end

function registerEvent(event, element, callback)
    addEvent(event, true)
    addEventHandler(event, element, callback)
end

-- // Useful functions create effect

local colorizePed = {50 / 255, 179 / 255, 239 / 255, 1} 
local specularPower = 1.3
local effectMaxDistance = 10
local isPostAura = true

local scx, scy = guiGetScreenSize ()
local effectOn = nil
local myRT = nil
local myShader = nil
local isMRTEnabled = false
local outlineEffect = {}
local PWTimerUpdate = 110

function enableOutline(isMRT)
	if isMRT and isPostAura then 
		myRT = dxCreateRenderTarget(scx, scy, true)
		myShader = dxCreateShader("assets/shader/edge.fx")
		if not myRT or not myShader then 
			isMRTEnabled = false
			return
		else
			dxSetShaderValue(myShader, "sTex0", myRT)
			dxSetShaderValue(myShader, "sRes", scx, scy)
			isMRTEnabled = true
		end
	else
		isMRTEnabled = false
	end
	pwEffectEnabled = true
end

function disableOutline()
	if isElement(myRT) then
		destroyElement(myRT)
	end
    if isElement(myShader) then
        destroyElement(myShader)
    end

    myRT = nil
    myShader = nil
end

function destroyElementOutlineEffect(element)
    if outlineEffect[element] then
		destroyElement(outlineEffect[element])
		outlineEffect[element] = nil
        disableOutline()
	end
end

function createElementOutlineEffect(element, isMRT)
    if not myRT or not myShader then
        enableOutline(isMRT)
    end
    effectOn = true
    if not outlineEffect[element] then
		if isMRT then 
			outlineEffect[element] = dxCreateShader("assets/shader/wall_mrt.fx", 1, 0, true, "all")
		else
			outlineEffect[element] = dxCreateShader("assets/shader/wall.fx", 1, 0, true, "all")
		end
		if not outlineEffect[element] then return false
		else
			if myRT then
				dxSetShaderValue (outlineEffect[element], "secondRT", myRT)
			end
			dxSetShaderValue(outlineEffect[element], "sColorizePed",colorizePed)
			dxSetShaderValue(outlineEffect[element], "sSpecularPower",specularPower)
			engineApplyShaderToWorldTexture ( outlineEffect[element], "*" , element )
			engineRemoveShaderFromWorldTexture(outlineEffect[element],"muzzle_texture*", element)
			if not isMRT then
				if getElementAlpha(element)==255 then setElementAlpha(element, 254) end
			end
		return true
		end
    end
end

addEventHandler( "onClientPreRender", root,
    function()
		if not pwEffectEnabled or not isMRTEnabled or not effectOn then return end
		dxSetRenderTarget( myRT, true )
		dxSetRenderTarget()
    end
, true, "high" )

addEventHandler( "onClientHUDRender", root,
    function()
		if not pwEffectEnabled or not isMRTEnabled or not effectOn or not myShader then return end
		dxDrawImage( 0, 0, scx, scy, myShader )
    end
)

addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()),
	function()
		local isMRT = false
		if dxGetStatus().VideoCardNumRenderTargets > 1 then
			isMRT = true 
		end
	end
)

-- // Useful functions create spike 

function rotateAround(angle, offsetX, offsetY, baseX, baseY)
	angle = math.rad(angle)

	offsetX = offsetX or 0
	offsetY = offsetY or 0

	baseX = baseX or 0
	baseY = baseY or 0

	return baseX + offsetX * math.cos(angle) - offsetY * math.sin(angle), baseY + offsetX * math.sin(angle) + offsetY * math.cos(angle)
end