local functions = {};

--[[
    Rendering calculations
--]]

local screenW, screenH = guiGetScreenSize();
local screenScale = math.min(math.max(screenH / 768, 0.70), 2); -- Caso o painel seja muito grande, retirar o limite e deixar apenas o (screenH / 768).

local parentW, parentH = (697 * screenScale), (476 * screenScale); -- Comprimento e Largura do painel.
local parentX, parentY = ((screenW - parentW) / 2), ((screenH - parentH) / 2); -- Posição X e Y do painel.

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

local client = {
    visible = false;
    visibleAnnounce = false;
    radius = {0, 255};
    radius_ = {0, 255};
    tick = nil;
    tick_ = nil;
    pag = 0;
    max = 12;
    corSelect = nil;
    color = {255, 255, 255};
    button = nil;
    text = nil;

    edits = {
        {false, guiCreateEdit(9999, 9999, 0, 0, "", false)};
        {false, guiCreateEdit(9999, 9999, 0, 0, "", false)};
    };
}

local function onClientRenderAnnouncement()
    local alpha = interpolateBetween(client["radius"][1], 0, 0, client["radius"][2], 0, 0, (getTickCount() - client["tick"])/300, "Linear")

    dxDrawImageSpacing(64, 49, 569, 377, 5, "assets/gfx/background.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
    dxDrawImageSpacing(572, 75, 32, 32, 5, "assets/gfx/close.png", 0, 0, 0, (functions.isCursorOnElement(572, 75, 32, 32) and tocolor(255, 121, 121, alpha) or tocolor(184, 184, 184, alpha)))

    dxDrawText(config["interface"]["tittle"], 85, 72, 154, 24, tocolor(255, 255, 255, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 16))
    dxDrawText(config["interface"]["sub.tittle"], 85, 96, 346, 18, tocolor(255, 255, 255, alpha), 1.0, exports['guetto_assets']:dxCreateFont("light", 13))

    if client["edits"][1][1] and isElement(client["edits"][1][2]) then
        dxDrawText((guiGetText(client["edits"][1][2]) or "").. "|", 102, 139, 340, 28, tocolor(client.color[1], client.color[2], client.color[3], alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 16), "left", "top", false, true, true, false, false)
        
    elseif (#guiGetText(client["edits"][1][2]) >= 1) then 
        dxDrawText((guiGetText(client["edits"][1][2]) or ""), 102, 139, 340, 28, tocolor(client.color[1], client.color[2], client.color[3], alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 16), "left", "top", false, true, true, false, false)
    else
        dxDrawText(config["interface"]["description"], 102, 139, 340, 28, tocolor(client.color[1], client.color[2], client.color[3], alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 14), "left", "top", false, true, true, false, false)
    end

    dxDrawText("Config de cores", 472, 136, 131, 11, tocolor(255, 255, 255, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 14))

    local c, r = 0, 0
    for i = 1, client["max"] do 
        local v = config["interface"]["cores"][(i + client["pag"])]
        if i > client["pag"] and c < client["max"] then 
            c = c + 1

            local countX = (472 + (505 - 472) * c - (505 - 472))
            local countY = (167 + (200 - 167) * r)

            if v then
                dxDrawImageSpacing(countX, countY, 22, 22, 5, "assets/gfx/eclipse.png", 0, 0, 0, tocolor(v[1], v[2], v[3], alpha), true)

                if functions.isCursorOnElement(countX, countY, 13, 13) or client["corSelect"] == i then 
                    dxDrawImageSpacing(countX, countY, 22, 22, 5, "assets/gfx/eclipse_select.png", 0, 0, 0, tocolor(255, 255, 255, alpha), true)
                end
                
                if (c >= 4) then 
                    c = 0
                    r = r + 1
                end
            end
        end
    end

    dxDrawImageSpacing(353, 304, 127, 42, 5, "assets/gfx/buttonselect.png", 0, 0, 0, (client["button"] == "global" and tocolor(193, 159, 114, alpha) or tocolor(87, 88, 100, alpha)))
    dxDrawImageSpacing(485, 304, 127, 42, 5, "assets/gfx/buttonselect.png", 0, 0, 0, (client["button"] == "private" and tocolor(193, 159, 114, alpha) or tocolor(87, 88, 100, alpha)))

    dxDrawText("GLOBAL", 353, 304, 127, 42, tocolor(255, 255, 255, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 16 ), "center", "center")
    dxDrawText("PRIVADO", 485, 304, 127, 42, tocolor(255, 255, 255, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 16), "center", "center")

    if client["edits"][2][1] and isElement(client["edits"][2][2]) then
        dxDrawText((guiGetText(client["edits"][2][2]) or "").. "|", 259, 314, 15, 23, tocolor(219, 219, 219, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 16), "center", "top", false, false, true, false, false)
        
    elseif (#guiGetText(client["edits"][2][2]) >= 1) then 
        dxDrawText((guiGetText(client["edits"][2][2]) or ""), 259, 314, 15, 23, tocolor(219, 219, 219, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 16), "center", "top", false, false, true, false, false)
    else
        dxDrawText("ID", 259, 314, 15, 23, tocolor(219, 219, 219, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 16), "center", "top", false, false, true, false, false)
    end

    dxDrawImageSpacing(85, 355, 527, 48, 5, "assets/gfx/button.png", 0, 0, 0, (functions.isCursorOnElement(85, 355, 527, 48) and tocolor(193, 159, 114, alpha) or tocolor(87, 88, 100, alpha)))
    dxDrawText("ANUNCIAR AGORA", 85, 355, 527, 48, tocolor(255, 255, 255, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 16), "center", "center")
end

function onClientRenderAnnounce()
    if client["visibleAnnounce"] then 
        local anim = interpolateBetween(client["radius_"][1], 0, 0, client["radius_"][2], 0, 0, (getTickCount() - client["tick_"])/500, "Linear")
        local width, textHeight = dxGetTextSize(client["text"], (1336-1030), 1.0, exports['guetto_assets']:dxCreateFont("light", 16), true)
        local bgHeight = textHeight + 60
        local bgY = 13 - 125
        
        dxDrawImage(156, bgY, 386, bgHeight, "assets/gfx/bg_announce.png", 0, 0, 0, tocolor(255, 255, 255, anim), true)
        dxDrawText("Anúncio", 156, bgY+18, 386, 23, tocolor(255, 255, 255, anim), 1.0, exports['guetto_assets']:dxCreateFont("medium", 16), "center", "top", false, false, true, false, false )
        
        dxDrawText(client["text"], 175, bgY+37, 350, bgHeight, tocolor(client["color"][1], client["color"][2], client["color"][3], anim), 1.0, exports['guetto_assets']:dxCreateFont("light", 20), "center", "top", false, true, true, false, false)
        
        local currentTime = getTickCount()
        local elapsedTime = currentTime - startTime
        local progress = elapsedTime / duration
        
        progress = math.max(0, math.min(1, progress))
        
        local barWidth = 238
        local barHeight = 3
        local barX = 230
        local barY = bgY + bgHeight - 17
        
        dxDrawImage(barX, barY, barWidth, barHeight, "assets/gfx/bg_progress.png", 0, 0, 0, tocolor(92, 93, 104, anim), true)
        dxDrawImageSection(barX, barY, barWidth * progress, barHeight, 0, 0, barWidth * progress, barHeight, "assets/gfx/bg_progress.png", 0, 0, 0, tocolor(193, 159, 114, anim), true)
    end
end

addEvent("squady.openAnnouncement", true)
addEventHandler("squady.openAnnouncement", getRootElement(), function()
    if not client["visible"] and not client["tick"] then 
        client["visible"] = true;
        client["radius"] = {0, 255};
        client["tick"] = getTickCount();
        client["corSelect"] = nil;
        client["color"] = {255, 255, 255};
        client["button"] = nil;
        addEventHandler("onClientRender", getRootElement(), onClientRenderAnnouncement)
        showCursor(true)
    elseif client["visible"] and client["tick"] then 
        client["visible"] = false;
        client["radius"] = {255, 0};
        client["tick"] = getTickCount();
        setTimer(function()
            client["tick"] = nil 
            removeEventHandler("onClientRender", getRootElement(), onClientRenderAnnouncement)
            showCursor(false)
        end, 300, 1)
    end
end)

addEvent("squady.openAnnounce", true)
addEventHandler("squady.openAnnounce", getRootElement(), function(description)
    if not client["visibleAnnounce"] then 
        client["visibleAnnounce"] = true;
        client["text"] = description;
        client["radius_"] = {0, 255};
        client["tick_"] = getTickCount();
        
        duration = config["gerais"]["time.announce"] * 1000
        startTime = getTickCount()
        
        addEventHandler("onClientRender", root, onClientRenderAnnounce)
        setTimer(function()
            if client["visibleAnnounce"] then
                client["tick_"] = nil
                client["visibleAnnounce"] = false;
                removeEventHandler("onClientRender", root, onClientRenderAnnounce)
            end
        end, config["gerais"]["time.announce"] * 1000, 1)
    end
end)

bindKey("backspace", "down", function()
    if client["visible"] and client["tick"] then
        client["visible"] = false;
        client["radius"] = {255, 0};
        client["tick"] = getTickCount();
        setTimer(function()
            client["tick"] = nil 
            removeEventHandler("onClientRender", getRootElement(), onClientRenderAnnouncement)
            showCursor(false)
        end, 300, 1)
    end
end)

addEventHandler ("onClientClick", getRootElement(), function(button, state)
	if client["visible"] and button == "left" and state == "down" then
        client["edits"][1][1] = false
        client["edits"][2][1] = false

        if functions.isCursorOnElement(85, 128, 374, 167) then 
            if (guiEditSetCaretIndex(client["edits"][1][2], (string.len(guiGetText(client["edits"][1][2]))))) then 
                guiEditSetMaxLength(client["edits"][1][2], 250)
                guiBringToFront(client["edits"][1][2])
                guiSetInputMode("no_binds_when_editing")
                client["edits"][1][1] = true
            end
        elseif functions.isCursorOnElement(183, 304, 166, 42) then
            if (guiEditSetCaretIndex(client["edits"][2][2], (string.len(guiGetText(client["edits"][2][2]))))) then 
                guiEditSetMaxLength(client["edits"][2][2], 6)
                guiBringToFront(client["edits"][2][2])
                guiSetInputMode("no_binds_when_editing")
                client["edits"][2][1] = true
            end
        end

        if functions.isCursorOnElement(353, 304, 127, 42) then 
            client["button"] = "global"
        elseif functions.isCursorOnElement(485, 304, 127, 42) then
            client["button"] = "private"
        end

        if functions.isCursorOnElement(572, 75, 32, 32) then 
            if client["visible"] and client["tick"] then
                client["visible"] = false;
                client["radius"] = {255, 0};
                client["tick"] = getTickCount();
                setTimer(function()
                    client["tick"] = nil 
                    removeEventHandler("onClientRender", getRootElement(), onClientRenderAnnouncement)
                    showCursor(false)
                end, 300, 1)
            end
        elseif functions.isCursorOnElement(85, 355, 527, 48) then
            if guiGetText(client["edits"][1][2]) == "" or guiGetText(client["edits"][1][2]) == config["interface"]["description"] then
                sendMessage("client", localPlayer, "Você deve inserir uma descrição antes de enviar um anúncio.", "error")
            else
                if client["button"] then
                    local key = getPlayerSerial(localPlayer)    
                    local hashtoKey = toJSON({description = guiGetText(client["edits"][1][2]), receiver = guiGetText(client["edits"][2][2]), button = client["button"]})

                    encodeString('aes128', hashtoKey, {key = key:sub(17)}, function(enc, iv)
                        triggerServerEvent('squady.sendAnnounce', resourceRoot, enc, iv)
                    end)
                else
                    sendMessage("client", localPlayer, "Você precisa selecionar se o anúncio é global ou privado.", "error")
                end
            end
        end

        local c, r = 0, 0
        for i = 1, client["max"] do 
            local v = config["interface"]["cores"][(i + client["pag"])]
            if i > client["pag"] and c < client["max"] then 
                c = c + 1

                local countX = (472 + (505 - 472) * c - (505 - 472))
                local countY = (167 + (200 - 167) * r)

                if v then
                    if functions.isCursorOnElement(countX, countY, 22, 22) then
                        client["corSelect"] = i
                        client["color"] = {v[1], v[2], v[3]}
                    end

                    if (c >= 4) then 
                        c = 0
                        r = r + 1
                    end
                end
            end
        end
    end
end)