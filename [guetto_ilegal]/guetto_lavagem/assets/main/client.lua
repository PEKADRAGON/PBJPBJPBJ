local functions = {};

--[[
    Rendering calculations
--]]

local screenW, screenH = guiGetScreenSize();
local screenScale = math.min(math.max(screenH / 1080, 0.70), 2); -- Caso o painel seja muito grande, retirar o limite e deixar apenas o (screenH / 768).

local parentW, parentH = (611 * screenScale), (536 * screenScale); -- Comprimento e Largura do painel.
local parentX, parentY = ((screenW - parentW) / 2), ((screenH - parentH) / 2); -- Posição X e Y do painel.

local assets = exports['guetto_assets']

--[[
    Useful rendering functions
--]]

functions.isCursorOnElement = function(x, y, width, height)
    x, y, width, height = functions.respX(x), functions.respY(y), functions.respC(width), functions.respC(height);
    if (not isCursorShowing()) then
        return false
    end

    local cX, cY = getCursorPosition();
    local cX, cY = (cX * screenW), (cY * screenH);
    local cursorX, cursorY = cX, cY;
    return (
        (cX >= x and cX <= x + width) and 
        (cY >= y and cY <= y + height)
    );
end

local _dxDrawImageSection = dxDrawImageSection;
local function dxDrawImageSection(x, y, width, height, u, v, uSize, vSize, ...)
    return _dxDrawImageSection(functions.respX(x), functions.respY(y), functions.respC(width), functions.respC(height), 0, 0, uSize, vSize, ...);
end

local _dxDrawText = dxDrawText;
local function dxDrawText(text, x, y, width, height, ...)
    return _dxDrawText(text, functions.respX(x), functions.respY(y), (functions.respX(x) + functions.respC(width)), (functions.respY(y) + functions.respC(height)), ...);
end

local _dxDrawRectangle = dxDrawRectangle;
local function dxDrawRectangle(x, y, width, height, ...)
    return _dxDrawRectangle(functions.respX(x), functions.respY(y), functions.respC(width), functions.respC(height), ...);
end

local _dxDrawImage = dxDrawImage;
local function dxDrawImage(x, y, width, height, ...)
    return _dxDrawImage(functions.respX(x), functions.respY(y), functions.respC(width), functions.respC(height), ...);
end

local _dxDrawImageSpacing = dxDrawImageSpacing;
local function dxDrawImageSpacing(x, y, width, height, spacing, ...)
	local padding = spacing * 2

	return dxDrawImage(x - spacing, y - spacing, width + padding, height + padding, ...)
end

local _dxCreateFont = dxCreateFont;
local function dxCreateFont(file, size)
    return _dxCreateFont(file, (size * screenScale));
end

functions.respX = function(x)
    return (parentX + (x * screenScale));
end

functions.respY = function(y)
    return (parentY + (y * screenScale));
end

functions.respC = function(scale)
    return (scale * screenScale);
end

local launderingStartTime = 0

local client = {
	["radius"] = {255, 0};
	["visible"] = false;
	["tick"] = nil;

	["edits"] = {
		["quantidade"] = {false, guiCreateEdit(9999, 9999, 0, 0, "", false)};
		["id-receiver"] = {false, guiCreateEdit(9999, 9999, 0, 0, "", false)};
		["taxa"] = {false, guiCreateEdit(9999, 9999, 0, 0, "", false)};
	};

	["fonts"] = {
	};
};

local function onClientRenderMoneyLaundry()
	local alpha = interpolateBetween (client["radius"][1], 0, 0, client["radius"][2], 0, 0, (getTickCount ( ) - client["tick"])/400, "Linear")	

	if window == "index" then 
		dxDrawImageSpacing(71, 63, 470, 411, 5, "assets/gfx/bg.png", 0, 0, 0, tocolor(255, 255, 255, alpha), true)

		dxDrawImageSpacing(454, 96, 54, 54, 5, "assets/gfx/bg_close.png", 0, 0, 0, tocolor(255, 255, 255, alpha), true)
		dxDrawImageSpacing(469, 111, 24, 24, 5, "assets/gfx/close.png", 0, 0, 0, (functions.isCursorOnElement(454, 96, 54, 54) and tocolor(156, 121, 255, alpha) or tocolor(193, 159, 114, alpha)), true)
	
		dxDrawText("Lavagem de dinheiro", 103, 91, 149, 21, tocolor(255, 255, 255, alpha/1.2), 1.0, exports['guetto_assets']:dxCreateFont("medium", 14), "left", "top", false, false, true, false, false)
		dxDrawText("Lave o dinheiro dos seus\nclientes aqui.", 103, 123, 251, 42, tocolor(255, 255, 255, alpha/3.7), 1.0, exports['guetto_assets']:dxCreateFont("medium", 14), "left", "top", false, false, true, false, false)

		dxDrawImageSpacing(107, 208, 262, 47, 5, "assets/gfx/bg_qntd.png", 0, 0, 0, tocolor(255, 255, 255, alpha), true)
		dxDrawImageSpacing(376, 208, 129, 47, 5, "assets/gfx/bg_id.png", 0, 0, 0, tocolor(255, 255, 255, alpha), true)
		dxDrawImageSpacing(107, 270, 217, 47, 5, "assets/gfx/bg_taxa.png", 0, 0, 0, tocolor(255, 255, 255, alpha), true)

		if (client["edits"]["quantidade"][1] and isElement(client["edits"]["quantidade"][2])) then
			dxDrawText(convertNumber((guiGetText(client["edits"]["quantidade"][2]) or "")).. "|", 126, 221, 82, 21, tocolor(255, 255, 255, alpha/3.7), 1.0, exports['guetto_assets']:dxCreateFont("medium", 14), "left", "top", false, false, true, false, false)
			
		elseif (#guiGetText(client["edits"]["quantidade"][2]) >= 1) then 
			dxDrawText(convertNumber((guiGetText(client["edits"]["quantidade"][2]) or "")), 126, 221, 82, 21, tocolor(255, 255, 255, alpha/3.7), 1.0, exports['guetto_assets']:dxCreateFont("medium", 14), "left", "top", false, false, true, false, false)
		else
			dxDrawText("Quantidade", 126, 221, 82, 21, tocolor(255, 255, 255, alpha/3.7), 1.0, exports['guetto_assets']:dxCreateFont("medium", 14), "left", "top", false, false, true, false, false)
		end

		if (client["edits"]["id-receiver"][1] and isElement(client["edits"]["id-receiver"][2])) then
			dxDrawText((guiGetText(client["edits"]["id-receiver"][2]) or "").. "|", 400, 221, 15, 21, tocolor(255, 255, 255, alpha/3.7), 1.0, exports['guetto_assets']:dxCreateFont("medium", 14), "left", "top", false, false, true, false, false)
			
		elseif (#guiGetText(client["edits"]["id-receiver"][2]) >= 1) then 
			dxDrawText((guiGetText(client["edits"]["id-receiver"][2]) or ""), 400, 221, 15, 21, tocolor(255, 255, 255, alpha/3.7), 1.0, exports['guetto_assets']:dxCreateFont("medium", 14), "left", "top", false, false, true, false, false)
		else
			dxDrawText("ID", 400, 221, 15, 21, tocolor(255, 255, 255, alpha/3.7), 1.0, exports['guetto_assets']:dxCreateFont("medium", 14), "left", "top", false, false, true, false, false)
		end

		if (client["edits"]["taxa"][1] and isElement(client["edits"]["taxa"][2])) then
			dxDrawText((guiGetText(client["edits"]["taxa"][2]) or "").. "|", 126, 283, 120, 21, tocolor(255, 255, 255, alpha/3.7), 1.0, exports['guetto_assets']:dxCreateFont("medium", 14), "left", "top", false, false, true, false, false)
			
		elseif (#guiGetText(client["edits"]["taxa"][2]) >= 1) then 
			dxDrawText((guiGetText(client["edits"]["taxa"][2]) or ""), 126, 283, 120, 21, tocolor(255, 255, 255, alpha/3.7), 1.0, exports['guetto_assets']:dxCreateFont("medium", 14), "left", "top", false, false, true, false, false)
		else
			dxDrawText("Taxa de lavagem", 126, 283, 120, 21, tocolor(255, 255, 255, alpha/3.7), 1.0, exports['guetto_assets']:dxCreateFont("medium", 14), "left", "top", false, false, true, false, false)
		end

		dxDrawImageSpacing(349, 270, 47, 47, 5, "assets/gfx/eclipse.png", 0, 0, 0, tocolor(255, 255, 255, alpha), true)
		dxDrawImageSpacing(361, 283, 23, 23, 5, "assets/gfx/money.png", 0, 0, 0, tocolor(255, 255, 255, alpha), true)

		dxDrawImageSpacing(107, 373, 398, 59, 5, "assets/gfx/button.png", 0, 0, 0, (functions.isCursorOnElement(107, 373, 398, 59) and tocolor(255, 255, 255, alpha/1.2) or tocolor(255, 255, 255, alpha)), true)
		dxDrawText("Lavar Dinheiro", 107, 373, 398, 59, tocolor(255, 255, 255, alpha/1.8), 1.0, exports['guetto_assets']:dxCreateFont("medium", 14), "center", "center", false, false, true, false, false)
	
	elseif window == "loading" then 
		dxDrawImageSpacing(71, 158, 470, 221, 5, "assets/gfx/bg_loading.png", 0, 0, 0, tocolor(255, 255, 255, alpha), true)
		dxDrawText("Lavando dinheiro...", 237, 303, 138, 21, tocolor(255, 255, 255, alpha/3.7), 1.0, exports['guetto_assets']:dxCreateFont("medium", 14), "left", "top", false, false, true, false, false)

		local currentTime = getTickCount()
		local elapsedTime = currentTime - launderingStartTime

		if not spin then spin = 0 end 
		spin = spin + 3

		if elapsedTime < 5000 then 
			dxDrawImageSpacing(276, 219, 60, 60, 5, "assets/gfx/loading.png", spin, 0, 0, tocolor(255, 255, 255, alpha), true)
		else
			launderingStartTime = 0
		end

	elseif window == "offer" then
		dxDrawImageSpacing(71, 158, 470, 221, 5, "assets/gfx/bg_offer.png", 0, 0, 0, tocolor(255, 255, 255, alpha), true)

		dxDrawImageSpacing(451, 186, 54, 54, 5, "assets/gfx/bg_close.png", 0, 0, 0, tocolor(255, 255, 255, alpha), true)
		dxDrawImageSpacing(466, 201, 24, 24, 5, "assets/gfx/close.png", 0, 0, 0, (functions.isCursorOnElement(466, 201, 24, 24) and tocolor(156, 121, 255, alpha) or tocolor(193, 159, 114, alpha)), true)

		dxDrawText("Proposta de lavagem", 107, 193, 159, 21, tocolor(255, 255, 255, alpha/1.2), 1.0, exports['guetto_assets']:dxCreateFont("medium", 14), "left", "top", false, false, true, false, false)
		dxDrawText(""..oferrorName.." enviou uma proposta\npara lavar seu dinheiro sujo.", 108, 222, 251, 42, tocolor(255, 255, 255, alpha/3.7), 1.0, exports['guetto_assets']:dxCreateFont("medium", 14), "left", "top", false, false, true, false, false)
	
		dxDrawImageSpacing(107, 288, 398, 59, 5, "assets/gfx/button.png", 0, 0, 0, (functions.isCursorOnElement(107, 288, 398, 59) and tocolor(255, 255, 255, alpha/1.2) or tocolor(255, 255, 255, alpha)), true)
		dxDrawText("Aceitar proposta", 107, 288, 398, 59, tocolor(255, 255, 255, alpha/1.8), 1.0, exports['guetto_assets']:dxCreateFont("medium", 14), "center", "center", false, false, true, false, false)
	end
end

addEvent("squady.openMoneyLaundry", true)
addEventHandler("squady.openMoneyLaundry", getRootElement(), function()
	if not client["visible"] and client["radius"][2] == 0 then
		client["visible"] = true;
		client["radius"] = {0, 255};
		client["tick"] = getTickCount ();
		window = "index";
		guiSetText(client["edits"]["quantidade"][2], "")
		guiSetText(client["edits"]["id-receiver"][2], "")
		guiSetText(client["edits"]["taxa"][2], "")
		showCursor (true)
		addEventHandler ("onClientRender", getRootElement (), onClientRenderMoneyLaundry)
	elseif client["visible"] and client["radius"][2] == 255 then 
		client["visible"] = false;
		client["radius"] = {255, 0};
		client["tick"] = getTickCount ();
		window = nil;
		setTimer (function ()
			showCursor (false)
			removeEventHandler ("onClientRender", getRootElement (), onClientRenderMoneyLaundry)
		end, 300, 1)
	end
end)

addEvent("squady.closeMoneyLaundry", true)
addEventHandler("squady.closeMoneyLaundry", getRootElement(), function()
	if client["visible"] and client["radius"][2] == 255 then
		client["visible"] = false;
		client["radius"] = {255, 0};
		client["tick"] = getTickCount ();
		window = nil;
		setTimer (function ()
			showCursor (false)
			removeEventHandler ("onClientRender", getRootElement (), onClientRenderMoneyLaundry)
		end, 300, 1)
	end
end)

addEvent("squady.openDrawOffer", true)
addEventHandler("squady.openDrawOffer", getRootElement(), function(offeror_, offeror_name, quantity_, porcentagem)
	if not client["visible"] and client["radius"][2] == 0 then
		client["visible"] = true;
		client["radius"] = {0, 255};
		client["tick"] = getTickCount ();
		window = "offer"
		offeror = offeror_
		oferrorName = offeror_name
		quantity = quantity_
		percentage = porcentagem
		showCursor (true)
		addEventHandler ("onClientRender", getRootElement (), onClientRenderMoneyLaundry)
		timer_expire = setTimer(function()
			if client["visible"] and window == "offer" then 
				client["visible"] = false
				client["radius"] = {255, 0}
				client["tick"] = getTickCount ()
				setTimer(function()
					window = nil;
					showCursor(false)
					removeEventHandler("onClientRender", getRootElement(), onClientRenderMoneyLaundry)
				end, 300, 1)
			end
		end, 1 * 60000, 1)
	end
end)

addEvent("squady.changeStateMoneyLaundry", true)
addEventHandler("squady.changeStateMoneyLaundry", getRootElement(), function()
	window = "loading"
	launderingStartTime = getTickCount()
end)

addEventHandler ("onClientClick", getRootElement(), function(button, state)
	if client["visible"] and button == "left" and state == "down" then
		client["edits"]["quantidade"][1] = false
		client["edits"]["id-receiver"][1] = false
		client["edits"]["taxa"][1] = false

		if window == "index" then
			if functions.isCursorOnElement(454, 96, 54, 54) then 
				if client["visible"] and client["radius"][2] == 255 then
					client["visible"] = false;
					client["radius"] = {255, 0};
					client["tick"] = getTickCount ();
					setTimer (function ()
						showCursor(false)
						removeEventHandler("onClientRender", getRootElement (), onClientRenderMoneyLaundry)
					end, 300, 1)
				end
			end

			if functions.isCursorOnElement(107, 208, 262, 47) then 
				if (guiEditSetCaretIndex(client["edits"]["quantidade"][2], (string.len(guiGetText(client["edits"]["quantidade"][2]))))) then 
					guiSetProperty(client["edits"]["quantidade"][2], "ValidationString", "^[0-9]*")
					guiEditSetMaxLength(client["edits"]["quantidade"][2], 12)
					guiBringToFront(client["edits"]["quantidade"][2])
					guiSetInputMode("no_binds_when_editing")
					client["edits"]["quantidade"][1] = true
				end

			elseif functions.isCursorOnElement(376, 208, 129, 47) then 
				if (guiEditSetCaretIndex(client["edits"]["id-receiver"][2], (string.len(guiGetText(client["edits"]["id-receiver"][2]))))) then 
					guiSetProperty(client["edits"]["id-receiver"][2], "ValidationString", "^[0-9]*")
					guiEditSetMaxLength(client["edits"]["id-receiver"][2], 6)
					guiBringToFront(client["edits"]["id-receiver"][2])
					guiSetInputMode("no_binds_when_editing")
					client["edits"]["id-receiver"][1] = true
				end

			elseif functions.isCursorOnElement(107, 270, 217, 47) then 
				if (guiEditSetCaretIndex(client["edits"]["taxa"][2], (string.len(guiGetText(client["edits"]["taxa"][2]))))) then 
					guiSetProperty(client["edits"]["taxa"][2], "ValidationString", "^[0-9]*")
					guiEditSetMaxLength(client["edits"]["taxa"][2], 2)
					guiBringToFront(client["edits"]["taxa"][2])
					guiSetInputMode("no_binds_when_editing")
					client["edits"]["taxa"][1] = true
				end
			end

			if functions.isCursorOnElement(107, 373, 398, 59) then 
				triggerServerEvent("squady.sendOffer", localPlayer, localPlayer, guiGetText(client["edits"]["quantidade"][2]), guiGetText(client["edits"]["id-receiver"][2]), guiGetText(client["edits"]["taxa"][2]))
			end
		end
			
		if window == "offer" then 
			if functions.isCursorOnElement(107, 288, 398, 59) then 
				triggerServerEvent("squady.responseOffer", resourceRoot, localPlayer, "accept", offeror, quantity, percentage)
				if client["visible"] and client["radius"][2] == 255 then
					client["visible"] = false;
					client["radius"] = {255, 0};
					client["tick"] = getTickCount ();
					window = nil;
					setTimer (function ()
						showCursor (false)
						removeEventHandler ("onClientRender", getRootElement (), onClientRenderMoneyLaundry)
					end, 300, 1)
				end
				if isTimer(timer_expire) then 
					killTimer(timer_expire)
				end

			elseif functions.isCursorOnElement(451, 186, 54, 54) then 
				triggerServerEvent("squady.responseOffer", localPlayer, "refuse")
				if client["visible"] and client["radius"][2] == 255 then
					client["visible"] = false;
					client["radius"] = {255, 0};
					client["tick"] = getTickCount ();
					window = nil;
					setTimer (function ()
						showCursor (false)
						removeEventHandler ("onClientRender", getRootElement (), onClientRenderMoneyLaundry)
					end, 300, 1)
				end
				if isTimer(timer_expire) then 
					killTimer(timer_expire)
				end
			end
		end
	end
end)