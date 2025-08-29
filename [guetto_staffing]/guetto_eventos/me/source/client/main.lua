local resource = {};
local functions = {};

----                    ---- ----                    ---- ----                    ----
---- Cálculos do Render ---- ---- Cálculos do Render ---- ---- Cálculos do Render ----
----                    ---- ----                    ---- ----                    ----

local screenW, screenH = guiGetScreenSize();
local screenScale = math.min(math.max(screenH / 768, 0.70), 2); -- Caso o painel seja muito grande, retirar o limite e deixar apenas o (screenH / 768).

local parentW, parentH = (715 * screenScale), (615 * screenScale); -- Comprimento e Largura do painel.
local parentX, parentY = ((screenW - parentW) / 2), ((screenH - parentH) / 2); -- Posição X e Y do painel.

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

functions.checkerButtons = function()
    resource.activeButton = false;
    for k, v in pairs(resource.buttons) do
        if (functions.isCursorOnElement(v[1], v[2], v[3], v[4])) then
            resource.activeButton = k;
            break
        end
    end
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

----        ---- ----        ---- ----        ----
---- Render ---- ---- Render ---- ---- Render ----
----        ---- ----        ---- ----        ----

functions.onPanelRender = function()
    resource.buttons = {};
    local alpha = interpolateBetween(resource['transition']['alpha'][1], 0, 0, resource['transition']['alpha'][2], 0, 0, ((getTickCount() - resource['transition'].tickCount) / 400), "Linear");

    if (alpha == 0 and resource['transition']['alpha'][2] == 0) then
        if (config['attributes']['hud'].use) then config['attributes']['hud'].showHud(localPlayer, true); end
        removeEventHandler("onClientRender", root, functions.onPanelRender);
        removeEventHandler("onClientClick", root, functions.onPlayerClick);
        removeEventHandler("onClientKey", root, functions.onPlayerKey);
        functions.onLoadLibs(false);
        resource.state = false;
        showCursor(false);
        return;
    end

    dxDrawImage(0, 0, 715, 615, "me/assets/image/background.png", 0, 0, 0, tocolor(255, 255, 255, alpha), true)
    dxDrawText("Eventos", 151, 101, 125, 25, tocolor(255, 255, 255, alpha), 1.00, resource['libs']['fonts'][1], "left", "center", false, false, true, false, false)
    dxDrawImage(564, 101, 25, 25, "me/assets/image/icons/close.png", 0, 0, 0, (resource.activeButton == "close" and fadeButton("close", 400, 255, 255, 255, alpha, alpha) or fadeButton("close", 400, 255, 255, 255, (alpha * 0.5), (alpha * 0.5))), true)
    resource['buttons'].close = {564, 101, 25, 25};

    dxDrawText("OPÇÕES", 148, 144, 175, 25, tocolor(141, 106, 240, alpha), 1.00, resource['libs']['fonts'][2], "left", "center", false, false, true, false, false)
    
    dxDrawText("Dar veículo", 125, 180, 219, 15, tocolor(214, 214, 214, alpha), 1.00, resource['libs']['fonts'][1], "left", "center", false, false, true, false, false)
    dxDrawImage(279, 201, 30, 30, "me/assets/image/icons/fix.png", 0, 0, 0, (resource.activeButton == "fix" and tocolor(255, 255, 255, alpha) or tocolor(27, 28, 28, alpha)), true)
    dxDrawImage(243, 201, 30, 30, "me/assets/image/icons/trash.png", 0, 0, 0, (resource.activeButton == "trash" and tocolor(141, 106, 240, alpha) or tocolor(141, 106, 240, (alpha * 0.6))), true)
    dxDrawImage(314, 201, 30, 30, "me/assets/image/icons/confirm.png", 0, 0, 0, (resource.activeButton == "confirm:01" and tocolor(141, 106, 240, alpha) or tocolor(141, 106, 240, (alpha * 0.6))), true)
    if (resource['libs']['edits'][1][1] and isElement(resource['libs']['edits'][1][2])) then dxDrawText((guiGetText(resource['libs']['edits'][1][2]) or "").."|", 169, 201, 69, 30, tocolor(214, 214, 214, alpha), 1.00, resource['libs']['fonts'][3], "left", "center", false, false, true, false, false)
    elseif (#guiGetText(resource['libs']['edits'][1][2]) >= 1) then dxDrawText((guiGetText(resource['libs']['edits'][1][2]) or ""), 169, 201, 69, 30, tocolor(214, 214, 214, alpha), 1.00, resource['libs']['fonts'][3], "left", "center", false, false, true, false, false)
    else dxDrawText("429", 169, 201, 69, 30, tocolor(214, 214, 214, alpha), 1.00, resource['libs']['fonts'][3], "left", "center", false, false, true, false, false) end
    resource['buttons']['edit:vehicle'] = {169, 201, 69, 30};
    resource['buttons']['confirm:01'] = {314, 201, 30, 30};
    resource['buttons'].trash = {243, 201, 30, 30};
    resource['buttons'].fix = {279, 201, 30, 30};

    dxDrawText("Definir vida", 370, 180, 219, 15, tocolor(214, 214, 214, alpha), 1.00, resource['libs']['fonts'][1], "left", "center", false, false, true, false, false)
    dxDrawImage(559, 201, 30, 30, "me/assets/image/icons/confirm.png", 0, 0, 0, (resource.activeButton == "confirm:02" and tocolor(141, 106, 240, alpha) or tocolor(141, 106, 240, (alpha * 0.6))), true)
    if (resource['libs']['edits'][2][1] and isElement(resource['libs']['edits'][2][2])) then dxDrawText((guiGetText(resource['libs']['edits'][2][2]) or "").."|", 414, 201, 139, 30, tocolor(214, 214, 214, alpha), 1.00, resource['libs']['fonts'][3], "left", "center", false, false, true, false, false)
    elseif (#guiGetText(resource['libs']['edits'][2][2]) >= 1) then dxDrawText((guiGetText(resource['libs']['edits'][2][2]) or ""), 414, 201, 139, 30, tocolor(214, 214, 214, alpha), 1.00, resource['libs']['fonts'][3], "left", "center", false, false, true, false, false)
    else dxDrawText("100", 414, 201, 139, 30, tocolor(214, 214, 214, alpha), 1.00, resource['libs']['fonts'][3], "left", "center", false, false, true, false, false) end
    resource['buttons']['edit:health'] = {414, 201, 139, 30};
    resource['buttons']['confirm:02'] = {559, 201, 30, 30};

    dxDrawText("Definir arma", 125, 261, 219, 15, tocolor(214, 214, 214, alpha), 1.00, resource['libs']['fonts'][1], "left", "center", false, false, true, false, false)
    dxDrawImage(314, 281, 30, 30, "me/assets/image/icons/confirm.png", 0, 0, 0, (resource.activeButton == "confirm:03" and tocolor(141, 106, 240, alpha) or tocolor(141, 106, 240, (alpha * 0.6))), true)
    if (resource['libs']['edits'][3][1] and isElement(resource['libs']['edits'][3][2])) then dxDrawText((guiGetText(resource['libs']['edits'][3][2]) or "").."|", 169, 281, 139, 30, tocolor(214, 214, 214, alpha), 1.00, resource['libs']['fonts'][3], "left", "center", false, false, true, false, false)
    elseif (#guiGetText(resource['libs']['edits'][3][2]) >= 1) then dxDrawText((guiGetText(resource['libs']['edits'][3][2]) or ""), 169, 281, 139, 30, tocolor(214, 214, 214, alpha), 1.00, resource['libs']['fonts'][3], "left", "center", false, false, true, false, false)
    else dxDrawText("30", 169, 281, 139, 30, tocolor(214, 214, 214, alpha), 1.00, resource['libs']['fonts'][3], "left", "center", false, false, true, false, false) end
    resource['buttons']['edit:weapon'] = {169, 281, 139, 30};
    resource['buttons']['confirm:03'] = {314, 281, 30, 30};

    dxDrawText("Definir colete", 370, 261, 219, 15, tocolor(214, 214, 214, alpha), 1.00, resource['libs']['fonts'][1], "left", "center", false, false, true, false, false)
    dxDrawImage(559, 281, 30, 30, "me/assets/image/icons/confirm.png", 0, 0, 0, (resource.activeButton == "confirm:04" and tocolor(141, 106, 240, alpha) or tocolor(141, 106, 240, (alpha * 0.6))), true)
    if (resource['libs']['edits'][4][1] and isElement(resource['libs']['edits'][4][2])) then dxDrawText((guiGetText(resource['libs']['edits'][4][2]) or "").."|", 414, 281, 139, 30, tocolor(214, 214, 214, alpha), 1.00, resource['libs']['fonts'][3], "left", "center", false, false, true, false, false)
    elseif (#guiGetText(resource['libs']['edits'][4][2]) >= 1) then dxDrawText((guiGetText(resource['libs']['edits'][4][2]) or ""), 414, 281, 139, 30, tocolor(214, 214, 214, alpha), 1.00, resource['libs']['fonts'][3], "left", "center", false, false, true, false, false)
    else dxDrawText("100", 414, 281, 139, 30, tocolor(214, 214, 214, alpha), 1.00, resource['libs']['fonts'][3], "left", "center", false, false, true, false, false) end
    resource['buttons']['edit:armor'] = {414, 281, 139, 30};
    resource['buttons']['confirm:04'] = {559, 281, 30, 30};

    dxDrawText("Trancar evento", 159, 347, 156, 15, tocolor(214, 214, 214, alpha), 1.00, resource['libs']['fonts'][1], "left", "center", false, false, true, false, false)
    dxDrawText("Congelar todos", 404, 347, 156, 15, tocolor(214, 214, 214, alpha), 1.00, resource['libs']['fonts'][1], "left", "center", false, false, true, false, false)
    if (resource['checkbox'][1]) then dxDrawImage(125, 342, 26, 26, "me/assets/image/button/checkbox.png", 0, 0, 0, tocolor(141, 106, 240, alpha), true) end
    if (resource['checkbox'][2]) then dxDrawImage(370, 342, 26, 26, "me/assets/image/button/checkbox.png", 0, 0, 0, tocolor(141, 106, 240, alpha), true) end
    resource['buttons']['checkbox:01'] = {125, 342, 26, 26};
    resource['buttons']['checkbox:02'] = {370, 342, 26, 26};

    dxDrawText("NOVO EVENTO", 151, 386, 175, 25, tocolor(141, 106, 240, alpha), 1.00, resource['libs']['fonts'][2], "left", "center", false, false, true, false, false)

    dxDrawText("Dimensão", 125, 423, 219, 15, tocolor(214, 214, 214, alpha), 1.00, resource['libs']['fonts'][1], "left", "center", false, false, true, false, false)
    dxDrawImage(314, 443, 30, 30, "me/assets/image/icons/confirm.png", 0, 0, 0, (resource.activeButton == "confirm:05" and tocolor(141, 106, 240, alpha) or tocolor(141, 106, 240, (alpha * 0.6))), true)
    if (resource['libs']['edits'][5][1] and isElement(resource['libs']['edits'][5][2])) then dxDrawText((guiGetText(resource['libs']['edits'][5][2]) or "").."|", 169, 443, 139, 30, tocolor(214, 214, 214, alpha), 1.00, resource['libs']['fonts'][3], "left", "center", false, false, true, false, false)
    elseif (#guiGetText(resource['libs']['edits'][5][2]) >= 1) then dxDrawText((guiGetText(resource['libs']['edits'][5][2]) or ""), 169, 443, 139, 30, tocolor(214, 214, 214, alpha), 1.00, resource['libs']['fonts'][3], "left", "center", false, false, true, false, false)
    else dxDrawText("0", 169, 443, 139, 30, tocolor(214, 214, 214, alpha), 1.00, resource['libs']['fonts'][3], "left", "center", false, false, true, false, false) end
    resource['buttons']['edit:dimension'] = {169, 443, 139, 30};
    resource['buttons']['confirm:05'] = {314, 443, 30, 30};
    
    dxDrawText("Interior", 370, 423, 219, 15, tocolor(214, 214, 214, alpha), 1.00, resource['libs']['fonts'][1], "left", "center", false, false, true, false, false)
    dxDrawImage(559, 443, 30, 30, "me/assets/image/icons/confirm.png", 0, 0, 0, (resource.activeButton == "confirm:06" and tocolor(141, 106, 240, alpha) or tocolor(141, 106, 240, (alpha * 0.6))), true)
    if (resource['libs']['edits'][6][1] and isElement(resource['libs']['edits'][6][2])) then dxDrawText((guiGetText(resource['libs']['edits'][6][2]) or "").."|", 414, 443, 139, 30, tocolor(214, 214, 214, alpha), 1.00, resource['libs']['fonts'][3], "left", "center", false, false, true, false, false)
    elseif (#guiGetText(resource['libs']['edits'][6][2]) >= 1) then dxDrawText((guiGetText(resource['libs']['edits'][6][2]) or ""), 414, 443, 139, 30, tocolor(214, 214, 214, alpha), 1.00, resource['libs']['fonts'][3], "left", "center", false, false, true, false, false)
    else dxDrawText("0", 414, 443, 139, 30, tocolor(214, 214, 214, alpha), 1.00, resource['libs']['fonts'][3], "left", "center", false, false, true, false, false) end
    resource['buttons']['edit:interior'] = {414, 443, 139, 30};
    resource['buttons']['confirm:06'] = {559, 443, 30, 30};

    dxDrawImage(126, 481, 149, 30, "me/assets/image/button/button-01.png", 0, 0, 0, (resource.activeButton == "destroy" and fadeButton("destroy:btn", 400, 141, 106, 240, alpha, alpha) or fadeButton("destroy:btn", 400, 0, 0, 0, (alpha * 0.08), (alpha * 0.08))), true)
    dxDrawText("Destruir evento", 126, 481, 149, 30, (resource.activeButton == "destroy" and fadeButton("destroy:txt", 400, 33, 34, 33, alpha, alpha) or fadeButton("destroy:txt", 400, 141, 106, 240, alpha, alpha)), 1.00, resource['libs']['fonts'][3], "center", "center", false, false, true, false, false)
    resource['buttons'].destroy = {126, 481, 149, 30};
    
    dxDrawImage(283, 481, 149, 30, "me/assets/image/button/button-01.png", 0, 0, 0, (resource.activeButton == "join" and fadeButton("join:btn", 400, 141, 106, 240, alpha, alpha) or fadeButton("join:btn", 400, 0, 0, 0, (alpha * 0.08), (alpha * 0.08))), true)
    dxDrawText("Entrar no evento", 283, 481, 149, 30, (resource.activeButton == "join" and fadeButton("join:txt", 400, 33, 34, 33, alpha, alpha) or fadeButton("join:txt", 400, 141, 106, 240, alpha, alpha)), 1.00, resource['libs']['fonts'][3], "center", "center", false, false, true, false, false)
    resource['buttons'].join = {283, 481, 149, 30};
    
    dxDrawImage(441, 481, 149, 30, "me/assets/image/button/button-01.png", 0, 0, 0, (resource.activeButton == "create" and fadeButton("create:btn", 400, 141, 106, 240, alpha, alpha) or fadeButton("create:btn", 400, 0, 0, 0, (alpha * 0.08), (alpha * 0.08))), true)
    dxDrawText("Criar evento", 441, 481, 149, 30, (resource.activeButton == "create" and fadeButton("create:txt", 400, 33, 34, 33, alpha, alpha) or fadeButton("create:txt", 400, 141, 106, 240, alpha, alpha)), 1.00, resource['libs']['fonts'][3], "center", "center", false, false, true, false, false)
    resource['buttons'].create = {441, 481, 149, 30};
    functions.checkerButtons();
end

----                  ---- ----                  ---- ----                  ----
---- Resource Manager ---- ---- Resource Manager ---- ---- Resource Manager ----
----                  ---- ----                  ---- ----                  ----

functions.onLoadInfos = function()
    resource = 
    {
        ['libs'] = {},
        ['data'] = {},
        ['buttons'] = {},
        
        ['state'] = true,
        ['activeButton'] = false,
        ['checkbox'] = {[1] = true, [2] = true},

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
                [1] = dxCreateFont("me/assets/fonts/inter-semibold.ttf", 12),
                [2] = dxCreateFont("me/assets/fonts/inter-extrabold.ttf", 12),
                [3] = dxCreateFont("me/assets/fonts/inter-semibold.ttf", 11),
            },

            ['edits'] =
            {
                [1] = {false, guiCreateEdit(9999, 9999, 0, 0, "", false)},
                [2] = {false, guiCreateEdit(9999, 9999, 0, 0, "", false)},
                [3] = {false, guiCreateEdit(9999, 9999, 0, 0, "", false)},
                [4] = {false, guiCreateEdit(9999, 9999, 0, 0, "", false)},
                [5] = {false, guiCreateEdit(9999, 9999, 0, 0, "", false)},
                [6] = {false, guiCreateEdit(9999, 9999, 0, 0, "", false)},
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

functions.onPlayerClick = function(button, state)
    if (button == "left" and state == "down") then
        if (resource['transition']['alpha'][2] == 255) then
            resource['libs']['edits'][1][1] = false; resource['libs']['edits'][2][1] = false; resource['libs']['edits'][3][1] = false; 
            resource['libs']['edits'][4][1] = false; resource['libs']['edits'][5][1] = false; resource['libs']['edits'][6][1] = false;

            if (resource.activeButton == "close") then
                triggerEvent("Eventos >> Manager render", resourceRoot, false);

            elseif (resource.activeButton == "edit:vehicle") then
                if (guiEditSetCaretIndex(resource['libs']['edits'][1][2], (string.len(guiGetText(resource['libs']['edits'][1][2]))))) then
                    guiSetProperty(resource['libs']['edits'][1][2], "ValidationString", "[0-9]*");
                    guiEditSetMaxLength(resource['libs']['edits'][1][2], 3);
                    guiBringToFront(resource['libs']['edits'][1][2]);
                    guiSetInputMode("no_binds_when_editing");
                    resource['libs']['edits'][1][1] = true;
                end

            elseif (resource.activeButton == "edit:health") then
                if (guiEditSetCaretIndex(resource['libs']['edits'][2][2], (string.len(guiGetText(resource['libs']['edits'][2][2]))))) then
                    guiSetProperty(resource['libs']['edits'][2][2], "ValidationString", "[0-9]*");
                    guiEditSetMaxLength(resource['libs']['edits'][2][2], 3);
                    guiBringToFront(resource['libs']['edits'][2][2]);
                    guiSetInputMode("no_binds_when_editing");
                    resource['libs']['edits'][2][1] = true;
                end

            elseif (resource.activeButton == "edit:weapon") then
                if (guiEditSetCaretIndex(resource['libs']['edits'][3][2], (string.len(guiGetText(resource['libs']['edits'][3][2]))))) then
                    guiSetProperty(resource['libs']['edits'][3][2], "ValidationString", "[0-9]*");
                    guiEditSetMaxLength(resource['libs']['edits'][3][2], 2);
                    guiBringToFront(resource['libs']['edits'][3][2]);
                    guiSetInputMode("no_binds_when_editing");
                    resource['libs']['edits'][3][1] = true;
                end

            elseif (resource.activeButton == "edit:armor") then
                if (guiEditSetCaretIndex(resource['libs']['edits'][4][2], (string.len(guiGetText(resource['libs']['edits'][4][2]))))) then
                    guiSetProperty(resource['libs']['edits'][4][2], "ValidationString", "[0-9]*");
                    guiEditSetMaxLength(resource['libs']['edits'][4][2], 3);
                    guiBringToFront(resource['libs']['edits'][4][2]);
                    guiSetInputMode("no_binds_when_editing");
                    resource['libs']['edits'][4][1] = true;
                end

            elseif (resource.activeButton == "edit:dimension") then
                if (guiEditSetCaretIndex(resource['libs']['edits'][5][2], (string.len(guiGetText(resource['libs']['edits'][5][2]))))) then
                    guiSetProperty(resource['libs']['edits'][5][2], "ValidationString", "[0-9]*");
                    guiEditSetMaxLength(resource['libs']['edits'][5][2], 4);
                    guiBringToFront(resource['libs']['edits'][5][2]);
                    guiSetInputMode("no_binds_when_editing");
                    resource['libs']['edits'][5][1] = true;
                end

            elseif (resource.activeButton == "edit:interior") then
                if (guiEditSetCaretIndex(resource['libs']['edits'][6][2], (string.len(guiGetText(resource['libs']['edits'][6][2]))))) then
                    guiSetProperty(resource['libs']['edits'][6][2], "ValidationString", "[0-9]*");
                    guiEditSetMaxLength(resource['libs']['edits'][6][2], 4);
                    guiBringToFront(resource['libs']['edits'][6][2]);
                    guiSetInputMode("no_binds_when_editing");
                    resource['libs']['edits'][6][1] = true;
                end
           
            elseif (resource.activeButton == "confirm:01") then
                if (#guiGetText(resource['libs']['edits'][1][2]) == 0) then
                    guiSetText(resource['libs']['edits'][1][2], "429");
                end

                triggerServerEvent("Eventos >> Change options", resourceRoot, "vehicle", guiGetText(resource['libs']['edits'][1][2]));
                return;

            elseif (resource.activeButton == "confirm:02") then
                if (#guiGetText(resource['libs']['edits'][2][2]) == 0) then
                    guiSetText(resource['libs']['edits'][2][2], "100");
                end

                triggerServerEvent("Eventos >> Change options", resourceRoot, "health", guiGetText(resource['libs']['edits'][2][2]));
                return;

            elseif (resource.activeButton == "confirm:03") then
                if (#guiGetText(resource['libs']['edits'][3][2]) == 0) then
                    guiSetText(resource['libs']['edits'][3][2], "30");
                end

                triggerServerEvent("Eventos >> Change options", resourceRoot, "weapon", guiGetText(resource['libs']['edits'][3][2]));
                return;

            elseif (resource.activeButton == "confirm:04") then
                if (#guiGetText(resource['libs']['edits'][4][2]) == 0) then
                    guiSetText(resource['libs']['edits'][4][2], "100");
                end

                triggerServerEvent("Eventos >> Change options", resourceRoot, "armor", guiGetText(resource['libs']['edits'][4][2]));
                return;

            elseif (resource.activeButton == "confirm:05") then
                if (#guiGetText(resource['libs']['edits'][5][2]) == 0) then
                    guiSetText(resource['libs']['edits'][5][2], "0");
                end

                triggerServerEvent("Eventos >> Change options", resourceRoot, "dimension", guiGetText(resource['libs']['edits'][5][2]));
                return;

            elseif (resource.activeButton == "confirm:06") then
                if (#guiGetText(resource['libs']['edits'][6][2]) == 0) then
                    guiSetText(resource['libs']['edits'][6][2], "0");
                end

                triggerServerEvent("Eventos >> Change options", resourceRoot, "interior", guiGetText(resource['libs']['edits'][6][2]));
                return;

            elseif (resource.activeButton == "checkbox:01") then
                triggerServerEvent("Eventos >> Change options", resourceRoot, "lock", (not resource['checkbox'][1]));
                resource['checkbox'][1] = (not resource['checkbox'][1]);
                return;

            elseif (resource.activeButton == "checkbox:02") then
                triggerServerEvent("Eventos >> Change options", resourceRoot, "freeze", (not resource['checkbox'][2]));
                resource['checkbox'][2] = (not resource['checkbox'][2]);
                return;

            elseif (resource.activeButton == "destroy") then
                triggerServerEvent("Eventos >> Destroy event", resourceRoot);
                return;

            elseif (resource.activeButton == "join") then
                triggerServerEvent("Eventos >> Join event", resourceRoot);
                return;

            elseif (resource.activeButton == "create") then
                triggerServerEvent("Eventos >> Create event", resourceRoot);
                return;
            
            elseif (resource.activeButton == "fix") then
                triggerServerEvent("Eventos >> Change options", resourceRoot, "fix");
                return;

            elseif (resource.activeButton == "trash") then
                triggerServerEvent("Eventos >> Change options", resourceRoot, "trash");
                return;
            end
        end
    end
end

functions.onPlayerKey = function(button, state)
    if (resource['transition']['alpha'][2] == 255) then
        if (button == "backspace" and state) then
            triggerEvent("Eventos >> Manager render", resourceRoot, false);
        end
    end
end

addEvent("Eventos >> Manager data", true);
addEventHandler("Eventos >> Manager data", resourceRoot,
    function(lock, freeze)
        resource['checkbox'][1] = lock;
        resource['checkbox'][2] = freeze;
    end
);

addEvent("Eventos >> Manager render", true);
addEventHandler("Eventos >> Manager render", resourceRoot,
    function(state)
        if (state) then
            if (resource.state) then
                return;
            end

            functions.onLoadInfos();
            if (config['attributes']['hud'].use) then config['attributes']['hud'].showHud(localPlayer, false); end
            addEventHandler("onClientRender", root, functions.onPanelRender);
            addEventHandler("onClientClick", root, functions.onPlayerClick);
            addEventHandler("onClientKey", root, functions.onPlayerKey);
            functions.onLoadLibs(true);
            showCursor(true);
        else
            if (not resource.state) then
                return;
            end

            if (resource['transition']['alpha'][1] == 0) then
                resource['transition'].tickCount = getTickCount();
                resource['transition'].alpha = {255, 0};
            end
        end
    end
);