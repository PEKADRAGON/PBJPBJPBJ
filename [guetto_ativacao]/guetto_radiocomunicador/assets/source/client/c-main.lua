local resource = {};
local functions = {};

----                    ---- ----                    ---- ----                    ----
---- Cálculos do Render ---- ---- Cálculos do Render ---- ---- Cálculos do Render ----
----                    ---- ----                    ---- ----                    ----

local screenW, screenH = guiGetScreenSize();
local screenScale = math.min(math.max(screenH / 768, 0.70), 2); -- Caso o painel seja muito grande, retirar o limite e deixar apenas o (screenH / 768).

local parentW, parentH = (187 * screenScale), (407 * screenScale); -- Comprimento e Largura do painel.
local parentX, parentY = (screenW - (parentW + (20 * screenScale))), (361 * screenScale); -- Posição X e Y do painel.

----                         ---- ----                         ---- ----                         ----
---- Funções Úteis do Render ---- ---- Funções Úteis do Render ---- ---- Funções Úteis do Render ----
----                         ---- ----                         ---- ----                         ----

functions.isCursorOnElement = function(x, y, width, height)
    x, y, width, height = functions.respX(x), functions.respY(y), functions.respC(width), functions.respC(height);
    if (not isCursorShowing()) then
        return false;
    end

    local cX, cY = getCursorPosition();
    local cX, cY = (cX * screenW), (cY * screenH);
    local cursorX, cursorY = cX, cY;
    return (
        (cX >= x and cX <= x + width) and 
        (cY >= y and cY <= y + height)
    );
end

functions.isEditBoxActive = function()
    for k = 1, #resource['libs'].edits do
        if (resource['libs']['edits'][k][1]) then
            return true;
        end
    end
    return false;
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

local _dxCreateFont = dxCreateFont;
local function dxCreateFont(file, size)
    return _dxCreateFont(file, (size * screenScale), _, "cleartype");
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

----        ---- ----        ---- ----        ----
---- Render ---- ---- Render ---- ---- Render ----
----        ---- ----        ---- ----        ----

functions.onPanelRender = function()
    resource.buttons = {};
    local alpha = interpolateBetween(resource['transition']['alpha'][1], 0, 0, resource['transition']['alpha'][2], 0, 0, ((getTickCount() - resource['transition'].tickCount) / 400), "Linear");

    if (alpha == 0 and resource['transition']['alpha'][2] == 0) then
        if (system['attributes']['hud'].use) then system['attributes']['hud'].showHud(localPlayer, true); end
        removeEventHandler("onClientRender", root, functions.onPanelRender);
        removeEventHandler("onClientClick", root, functions.onPlayerClick);
        removeEventHandler("onClientKey", root, functions.onPlayerKey);
        functions.onLoadLibs(false);
        resource.state = false;
        showCursor(false);
        return;
    end

    dxDrawImage(0, 0, 187, 407, "assets/archives/imgs/radio.png", 0, 0, 0, tocolor(255, 255, 255, alpha), true)
    if (resource['libs']['edits'][1][1] and isElement(resource['libs']['edits'][1][2])) then dxDrawText((guiGetText(resource['libs']['edits'][1][2]) or "").."|", 41, 288, 104, 100, tocolor(55, 55, 55, alpha), 1.00, resource['libs']['fonts'][1], "center", "center", false, false, true, false, false)
    elseif (#guiGetText(resource['libs']['edits'][1][2]) >= 1) then dxDrawText((guiGetText(resource['libs']['edits'][1][2]) or ""), 41, 288, 104, 100, tocolor(55, 55, 55, alpha), 1.00, resource['libs']['fonts'][1], "center", "center", false, false, true, false, false)
    else dxDrawText("0", 41, 288, 104, 100, tocolor(55, 55, 55, alpha), 1.00, resource['libs']['fonts'][1], "center", "center", false, false, true, false, false) end
end

----                  ---- ----                  ---- ----                  ----
---- Resource Manager ---- ---- Resource Manager ---- ---- Resource Manager ----
----                  ---- ----                  ---- ----                  ----

functions.onLoadInfos = function()
    resource = 
    {
        ['libs'] = {},
        ['buttons'] = {},
        
        ['state'] = true,
        ['activeButton'] = false,

        ['transition'] =
        {
            alpha = {0, 255},
            tickCount = getTickCount()
        }
    };
end

functions.onLoadLibs = function(state)
    if (state) then
        resource.libs =
        {
            ['fonts'] = 
            {
                [1] = dxCreateFont("assets/archives/fonts/ds-digital.ttf", 26)
            },

            ['edits'] =
            {
                {false, guiCreateEdit(9999, 9999, 0, 0, "", false)},
            }
        };
    else
        for index, array in pairs(resource.libs) do
            for k, v in ipairs(array) do
                if (type(v) == "table") then
                    destroyElement(v[2]);
                    break;
                end
                destroyElement(v);
            end
        end
        resource.libs = {};
    end
end

----                 ---- ----                 ---- ----                 ----
---- Resource Events ---- ---- Resource Events ---- ---- Resource Events ----
----                 ---- ----                 ---- ----                 ----

bindKey(system['attributes'].talk, "both",  
    function(key, state)
        if (state == "down") then 
            if (getElementData(localPlayer, "frequency")) then
                triggerServerEvent("Radio Comunicador >> Add animations", resourceRoot, localPlayer);
                setElementData(localPlayer, "radio.talking", true);
                playSound("assets/archives/sounds/on.mp3", false);
            end

        elseif (state == "up") then 
            if (getElementData(localPlayer, "frequency")) then
                triggerServerEvent("Radio Comunicador >> Remove animations", resourceRoot, localPlayer);
                setElementData(localPlayer, "radio.talking", false);
                playSound("assets/archives/sounds/off.mp3", false);
            end
        end
    end
);

functions.onPlayerClick = function(button, state, abX, abY)
    if (button == "left" and state == "down") then
        if (resource['transition']['alpha'][2] == 255) then
            resource['libs']['edits'][1][1] = false;
            if (functions.isCursorOnElement(76, 142, 35, 45)) then
                triggerServerEvent("Radio Comunicador >> Change frequency", resourceRoot, localPlayer, 0);
                return;

            elseif (functions.isCursorOnElement(142, 152, 50, 45)) then
                if (guiGetText(resource['libs']['edits'][1][2]):len() < 0 and tonumber(guiGetText(resource['libs']['edits'][1][2]))) then
                    geral.cNotify(localPlayer, getSystemLanguage("messages", "main", "frequency not inserted"), "warning");
                    return;
                end

                triggerServerEvent("Radio Comunicador >> Change frequency", resourceRoot, localPlayer, tonumber(guiGetText(resource['libs']['edits'][1][2])));
                return;

            elseif (functions.isCursorOnElement(41, 288, 104, 100)) then
                if (guiEditSetCaretIndex(resource['libs']['edits'][1][2], (string.len(guiGetText(resource['libs']['edits'][1][2]))))) then
                    guiSetProperty(resource['libs']['edits'][1][2], "ValidationString", "[0-9]*");
                    guiEditSetMaxLength(resource['libs']['edits'][1][2], 3);
                    guiBringToFront(resource['libs']['edits'][1][2]);
                    guiSetInputMode("no_binds_when_editing");
                    resource['libs']['edits'][1][1] = true;
                end
            end
        end
    end
end

functions.onPlayerKey = function(button, state)
    if (resource['transition']['alpha'][2] == 255) then
        if (button == "backspace" and state) then
            if (functions.isEditBoxActive()) then
                return;
            end

            triggerEvent("Radio Comunicador >> Manager render", resourceRoot, false);

        elseif (button == "enter" and state) then
            if (guiGetText(resource['libs']['edits'][1][2]):len() < 0 and tonumber(guiGetText(resource['libs']['edits'][1][2]))) then
                geral.cNotify(localPlayer, getSystemLanguage("messages", "main", "frequency not inserted"), "warning");
                return;
            end

            if (tonumber(guiGetText(resource['libs']['edits'][1][2])) < 0 and tonumber(guiGetText(resource['libs']['edits'][1][2])) > 999) then
                geral.cNotify(localPlayer, getSystemLanguage("messages", "main", "frequency not inserted"), "warning");
                return;
            end

            triggerServerEvent("Radio Comunicador >> Change frequency", resourceRoot, localPlayer, tonumber(guiGetText(resource['libs']['edits'][1][2])));
            return;
        end
    end
end

addEvent("Radio Comunicador >> Manager render", true);
addEventHandler("Radio Comunicador >> Manager render", root,
    function()
        if (not resource.state) then
            functions.onLoadInfos();
            if (system['attributes']['hud'].use) then system['attributes']['hud'].showHud(localPlayer, false); end
            addEventHandler("onClientRender", root, functions.onPanelRender);
            addEventHandler("onClientClick", root, functions.onPlayerClick);
            addEventHandler("onClientKey", root, functions.onPlayerKey);
            functions.onLoadLibs(true);
            showCursor(true);

            if (getElementData(localPlayer, "frequency")) then
                guiSetText(resource['libs']['edits'][1][2], getElementData(localPlayer, "frequency"));
            end
        else
            if (resource['transition']['alpha'][1] == 0) then
                resource['transition'].tickCount = getTickCount();
                resource['transition'].alpha = {255, 0};
            end
        end
    end
);

----        ---- ----        ---- ----        ----
---- Others ---- ---- Others ---- ---- Others ----
----        ---- ----        ---- ----        ----

local animations = {};

addEventHandler("onClientPedsProcessed", root, 
    function()
        for k, player in pairs(animations) do 
            if (player and isElement(player)) then
               -- setElementBoneRotation(player, 5, 0, 0, -30);		-- cabeça
                setElementBoneRotation(player, 32, -30, -30, 50); -- Ombro
                setElementBoneRotation(player, 33, 0, -160, 0);		-- mao 
                setElementBoneRotation(player, 34, -120, 0, 0); -- MAO2
                updateElementRpHAnim(player);
            else
                table.remove(animations, k);
            end 
        end
    end
);

addEvent("Radio Comunicador >> Add client animations", true)
addEventHandler("Radio Comunicador >> Add client animations", resourceRoot, 
    function(element)
        for k, player in pairs(animations) do 
            if (player and isElement(player)) then
                if (player == element) then 
                    table.remove(animations, k);
                end
            else
                table.remove(animations, k);
            end 
        end
        table.insert(animations, element);
    end
);

addEvent("Radio Comunicador >> Remove client animations", true)
addEventHandler("Radio Comunicador >> Remove client animations", resourceRoot, 
    function(element)
        for k, player in pairs(animations) do 
            if (player and isElement(player)) then
                if (player == element) then 
                    table.remove(animations, k);
                end
            else
                table.remove(animations, k);
            end 
        end
    end
);

addEventHandler("onClientResourceStart", resourceRoot, 
    function()
        if (system['attributes']['object'].use) then
            engineImportTXD(engineLoadTXD("assets/archives/models/radinho.txd"), system['attributes']['object'].model);
            engineReplaceModel(engineLoadDFF("assets/archives/models/radinho.dff", system['attributes']['object'].model), system['attributes']['object'].model);
        end
    end
);