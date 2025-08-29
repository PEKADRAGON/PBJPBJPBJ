local Global = {
    Interface = {Buttons = false}
}

local resourcesLoaded = {}
local assets = exports['guetto_assets']

core = function ( )
    
    interpolate.create('animation.fade', 300, 'Linear')
    interpolate.create('animation.pos', 400, 'InOutQuad')

    scroll.start()
    editbox.events.start()

    -- Event´s

    registerEvent('vanish.trasfer.mods', resourceRoot, recipeMods)
    addCommandHandler("mods", function ( )
        if isPedInVehicle(localPlayer) then 
            return config.sendMessageClient("Saia do veículo!", "info")
        end
        toggle(not Global.Interface.State and true or false)
    end)
end;

Global.Interface.Positions = {
    ["Categorias"] = {
        {153 * scale, 64 * scale, 115 * scale, 20 * scale, 'Veiculos'};
        {295 * scale, 64 * scale, 129 * scale, 20 * scale, 'Exclusivos'};
        {451 * scale, 64 * scale, 160 * scale, 20 * scale, 'Armamentos'};
        {638 * scale, 64 * scale, 160 * scale, 20 * scale, 'Corps'};
        {750 * scale, 64 * scale, 106 * scale, 20 * scale, 'Facs'};
    };
}

local download = {
    count = 0;
    resources = {};
}

draw = function ( )
    cursorUpdate()
    
    Global.Interface.Buttons = { }

    local pos, fade = interpolate.get('animation.pos'), interpolate.get('animation.fade')

    local w, h = 1121 * scale, 746 * scale
    local x, y = (screen[1] - w) / 2, pos
        
    dxDrawRectangleRounded(x, y, w, h, 11, tocolor(18, 18, 18, fade))
    dxDrawImage(x + 43 * scale, y + 47 * scale, 69 * scale, 54 * scale, "assets/images/logo/logo.png", tocolor(255, 255, 255, fade))

    for i, v in ipairs(Global.Interface.Positions["Categorias"]) do 
        dxDrawImage(x + v[1], y + v[2], 15 * scale, 15 * scale, "assets/images/icons/polygon.png", isCursorInBox(x + v[1] + 28 * scale, y + v[2] - 6 * scale, v[3], v[4]) and tocolor(193, 159, 114, fade) or Global.Interface.Page == v[5] and tocolor(193, 159, 114, fade) or tocolor(169, 169, 169, fade))
        dxDrawText(v[5], x + v[1] + 28 * scale, y + v[2] - 6 * scale, 0, 20 * scale, isCursorInBox(x + v[1] + 28 * scale, y + v[2] - 6 * scale, v[3], v[4]) and tocolor(193, 159, 114, fade) or Global.Interface.Page == v[5] and tocolor(193, 159, 114, fade) or tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("regular", 18), 'left', 'top')
        Global.Interface.Buttons['categorys:'..i] = {x + v[1] + 28 * scale, y + v[2] - 6 * scale, v[3], v[4]}
    end

    dxDrawRectangleRounded(x + 25 * scale, y + 26 * scale, 1071 * scale, 95 * scale, 5, tocolor(0, 0, 0, 0), {tocolor(255, 255, 255, 0.20 * fade), 1.5})
    dxDrawRectangleRounded(x + 995 * scale, y + 45 * scale, 80 * scale, 57 * scale, 5, tocolor(0, 0, 0, 0), {tocolor(255, 255, 255, 0.20 *  fade), 1.5})

    dxDrawRectangleRounded(x + 25 * scale, y + 149 * scale, 1070 * scale, 47 * scale, 5, tocolor(217, 217, 217, 0.11 * fade))
    dxDrawRectangleRounded(x + 25 * scale, y + 149 * scale, 1070 * scale, 483 * scale, 5, tocolor(0, 0, 0, 0), {tocolor(255, 255, 255, 0.20 * fade), 1.3})
    dxDrawImage(x + 1007 * scale, y + 52 * scale, 51 * scale, 44 * scale, "assets/images/icons/quit.png", isCursorInBox(x + 1007 * scale, y + 52 * scale, 51 * scale, 44 * scale) and tocolor(193, 159, 114, fade) or tocolor(255, 255, 255, fade))

    dxDrawText("ARQUIVOS", x + 53 * scale, y + 160 * scale, 79 * scale, 15 * scale, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'left', 'top')
    dxDrawText("PESO", x + 323 * scale, y + 160 * scale, 79 * scale, 15 * scale, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'left', 'top')
    dxDrawText("STATUS", x + 601 * scale, y + 160 * scale, 79 * scale, 15 * scale, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'left', 'top')
    dxDrawText("MICRO AÇÕES", x + 907 * scale, y + 160 * scale, 79 * scale, 15 * scale, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'left', 'top')

    dxDrawRectangleRounded(x + 25 * scale, y + 652 * scale, 188 * scale, 57 * scale, 5, tocolor(0, 0, 0, 0), {isCursorInBox(x + 25 * scale, y + 652 * scale, 188 * scale, 57 * scale) and tocolor(193, 159, 114, fade) or tocolor(255, 255, 255, 0.20 * fade), 1.5})
    dxDrawRectangleRounded(x + 223 * scale, y + 652 * scale, 188 * scale, 57 * scale, 5, tocolor(0, 0, 0, 0), {isCursorInBox(x + 223 * scale, y + 652 * scale, 188 * scale, 57 * scale) and tocolor(193, 159, 114, fade) or tocolor(255, 255, 255, 0.20 * fade), 1.5})
    dxDrawRectangleRounded(x + 421 * scale, y + 652 * scale, 188 * scale, 57 * scale, 5, tocolor(0, 0, 0, 0), {isCursorInBox(x + 421 * scale, y + 652 * scale, 188 * scale, 57 * scale) and tocolor(193, 159, 114, fade) or tocolor(255, 255, 255, 0.20 * fade), 1.5})

    dxDrawRectangleRounded(x + 619 * scale, y + 652 * scale, 476 * scale, 57 * scale, 5, tocolor(0, 0, 0, 0), {isCursorInBox(x + 619 * scale, y + 652 * scale, 476 * scale, 57 * scale) and tocolor(193, 159, 114, fade) or tocolor(255, 255, 255, 0.20 * fade), 1.5})

    dxDrawText('ATIVAR TODOS', x + 25 * scale, y + 654 * scale, 188 * scale, 57 * scale, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'center', 'center')
    dxDrawText('DESATIVAR TODOS', x + 223 * scale, y + 654 * scale, 188 * scale, 57 * scale, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'center', 'center')
    dxDrawText('EXCLUIR TODOS', x + 421 * scale, y + 654 * scale, 188 * scale, 57 * scale, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'center', 'center')

    dxDrawImage(x + 634 * scale, y + 667 * scale, 28 * scale, 28 * scale, "assets/images/icons/search.png", tocolor(255, 255, 255, fade))

    editbox.create('Pesquisar', 'pesquisarResource', x + 687 * scale, y + 670 * scale, 134 * scale, 15 * scale, 476 * scale, 57 * scale, 15, fade, exports['guetto_assets']:dxCreateFont('regular', 15))
    scroll.draw('scroll.mods', -screen[1], -screen[2], 1 * scale, 1 * scale, tocolor(255, 255, 255, fade), tocolor(255, 255, 255, fade), 6, #config["Resources"][Global.Interface.Page])
    scroll.buttons["scroll:scroll.mods"] = {x, y, w, h}

    local offSetY = y + 211 * scale
    local line = 0
    local content = editbox.utils.getValue('pesquisarResource')

    for i = 1, 6 do 
        local v = config["Resources"][Global.Interface.Page][scroll.getValue('scroll.mods') + i]
        
        if v then 
            if (content == '' or content == 'Pesquisar' or string.find( string.lower(v[1]), string.lower(content) )) then 
                line = line + 1

                dxDrawRectangleRounded ( x + 33 * scale, offSetY, 1055 * scale, 64 * scale, 3, isCursorInBox(x + 33 * scale, offSetY, 1055 * scale, 64 * scale) and tocolor(22, 22, 22, fade) or tocolor( 33, 32, 32, fade ) )

                dxDrawText(v[1]..' ('.. (v[2])..')', x + 53 * scale, offSetY + 20 * scale, 0, 0, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("regular", 15), 'left', 'top')
                dxDrawText( ( fileExists("assets/mods/"..v[3].."/"..v[2]..".txd") and fileExists("assets/mods/"..v[3].."/"..v[2]..".dff") ) and not v[4] and "Desativado" or (fileExists("assets/mods/"..v[3].."/"..v[2]..".txd") and fileExists("assets/mods/"..v[3].."/"..v[2]..".dff")) and v[4] and "Baixado e Ativado" or "Não baixado", x + 601 * scale, offSetY + 20 * scale, 0, 0, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'left', 'top')
    
                dxDrawImage(x + 890 * scale, offSetY + 18 * scale, 29 * scale, 29 * scale, "assets/images/icons/on.png",  isCursorInBox(x + 890 * scale, offSetY + 18 * scale, 29 * scale, 29 * scale) and tocolor(193, 159, 114, fade) or tocolor(159, 159, 159, fade))
                dxDrawImage(x + 954 * scale, offSetY + 18 * scale, 29 * scale, 29 * scale, "assets/images/icons/excluir.png", isCursorInBox(x + 954 * scale, offSetY + 18 * scale, 29 * scale, 29 * scale) and tocolor(193, 159, 114, fade) or tocolor(159, 159, 159, fade))
                dxDrawImage(x + 1018 * scale, offSetY + 16 * scale, 33 * scale, 33 * scale, "assets/images/icons/download.png", isCursorInBox(x + 1018 * scale, offSetY + 16 * scale, 33 * scale, 33 * scale) and tocolor(193, 159, 114, fade) or tocolor(159, 159, 159, fade))
                
                if isCursorInBox(x + 890 * scale, offSetY + 18 * scale, 29 * scale, 29 * scale) then 
             
                    dxDrawImage(x + 890 * scale + 29 * scale / 2 - 77 * scale / 2, offSetY + 46 * scale + 5 * scale, 77 * scale, 29 * scale, "assets/images/icons/hover.png", tocolor(91, 87, 102, fade), 0, 0, 0, true)
                    
                    if ( fileExists("assets/mods/"..v[3].."/"..v[2]..".txd") and fileExists("assets/mods/"..v[3].."/"..v[2]..".dff") ) and not v[4] then 
                        dxDrawText("ATIVAR", x + 890 * scale + 29 * scale / 2 - 77 * scale / 2, offSetY + 48 * scale + 5 * scale, 77 * scale, 29 * scale, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'center', 'center', false, false, true)
                    else
                        dxDrawText("DESATIVAR", x + 890 * scale + 29 * scale / 2 - 77 * scale / 2, offSetY + 48 * scale + 5 * scale, 77 * scale, 29 * scale, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'center', 'center', false, false, true)
                    end
             
                elseif isCursorInBox(x + 954 * scale, offSetY + 18 * scale, 29 * scale, 29 * scale) then
             
                    dxDrawImage(x + 954 * scale + 29 * scale / 2 - 77 * scale / 2, offSetY + 46 * scale + 5 * scale, 77 * scale, 29 * scale, "assets/images/icons/hover.png", tocolor(91, 87, 102, fade), 0, 0, 0, true)
                    dxDrawText("DELETAR", x + 954 * scale + 29 * scale / 2 - 77 * scale / 2, offSetY + 48 * scale + 5 * scale, 77 * scale, 29 * scale, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'center', 'center', false, false, true)
             
                elseif isCursorInBox(x + 1018 * scale, offSetY + 16 * scale, 33 * scale, 33 * scale) then
             
                    dxDrawImage(x + 1018 * scale + 33 * scale / 2 - 77 * scale / 2, offSetY + 46 * scale + 5 * scale, 77 * scale, 29 * scale, "assets/images/icons/hover.png", tocolor(91, 87, 102, fade), 0, 0, 0, true)
                    dxDrawText("BAIXAR", x + 1018 * scale + 33 * scale / 2 - 77 * scale / 2, offSetY + 48 * scale + 5 * scale, 77 * scale, 29 * scale, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'center', 'center', false, false, true)
                    
                end

                if Global.Resources and Global.Resources[Global.Interface.Page] then 

                    if not (Global.Resources[Global.Interface.Page][scroll.getValue('scroll.mods') + line]) then 
                        dxDrawText("Undefined", x + 323 * scale, offSetY + 20 * scale, 0, 0, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("regular", 15), 'left', 'top')
                    else
                        dxDrawText(sizeFormat(Global.Resources[Global.Interface.Page][scroll.getValue('scroll.mods') + line][1]), x + 323 * scale, offSetY + 20 * scale, 0, 0, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("regular", 15), 'left', 'top')
                    end
                    --if (Global.Resources[Global.Interface.Page][scroll.getValue('scroll.mods') + line][1]) then 
                    --    dxDrawText(sizeFormat(Global.Resources[Global.Interface.Page][scroll.getValue('scroll.mods') + line][1]), x + 323 * scale, offSetY + 20 * scale, 0, 0, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("regular", 15), 'left', 'top')
                    --else
                    --    dxDrawText("Undefined", x + 323 * scale, offSetY + 20 * scale, 0, 0, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont("regular", 15), 'left', 'top')
                    --end
                end

                Global.Interface.Buttons['enable_select:'..scroll.getValue('scroll.mods') + i] = {x + 890 * scale, offSetY + 18 * scale, 29 * scale, 29 * scale}
                Global.Interface.Buttons['delet_select:'..scroll.getValue('scroll.mods') + i] = {x + 954 * scale, offSetY + 18 * scale, 29 * scale, 29 * scale}
                Global.Interface.Buttons['download_select:'..scroll.getValue('scroll.mods') + i] = {x + 1018 * scale, offSetY + 16 * scale, 33 * scale, 33 * scale}
                offSetY = offSetY + 64 * scale + 4 * scale
            end
        end
    end
    Global.Interface.Buttons['enable-all'] = {x + 25 * scale, y + 652 * scale, 188 * scale, 57 * scale}
    Global.Interface.Buttons['off-all'] = {x + 223 * scale, y + 652 * scale, 188 * scale, 57 * scale}
    Global.Interface.Buttons['delet-all'] = {x + 421 * scale, y + 652 * scale, 188 * scale, 57 * scale}
    Global.Interface.Buttons['close'] = {x + 1007 * scale, y + 52 * scale, 51 * scale, 44 * scale}
end;

toggle = function (state)
    if state then 
        if not interpolate.isRunning('animation.pos') and not interpolate.isRunning('animation.fade') then 
            interpolate.exec('animation.pos', 0, (screen[2] - 746 * scale) / 2)
            interpolate.exec('animation.fade', 0, 1)
            Global.Interface.Page = "Veiculos"
            scroll.setValue('scroll.mods', 0)
            showCursor(true)
            showChat(false)
            addEventHandler('onClientRender', root, draw)
            addEventHandler('onClientClick', root, click)
        end
    else
        if not interpolate.isRunning('animation.pos') and not interpolate.isRunning('animation.fade') then 
            interpolate.exec('animation.pos', (screen[2] - 746 * scale) / 2, 0)
            interpolate.exec('animation.fade', 1, 0)
            showCursor(false)
            showChat(true)
            setTimer (function ( )
                removeEventHandler('onClientRender', root, draw)
                removeEventHandler('onClientClick', root, click)
            end, 400, 1)
        end
    end
    Global.Interface.State = state
end

click = function (button, state)
    if button == 'left' then 
        if state == 'down' then 
            Global.Interface.Select = false;

            for i, v in pairs(Global.Interface.Buttons) do 
                if isCursorInBox(v[1], v[2], v[3], v[4]) then 
                    Global.Interface.Select = i
                    break
                end
            end
        elseif state == 'up' then 
            if Global.Interface.Select then 
                local separate = split (Global.Interface.Select, ':')
               
                Global.Interface.Select = false;
               
                if separate[1] == 'categorys' then 
               
                    Global.Interface.Page = Global.Interface.Positions["Categorias"][tonumber(separate[2])][5]
                    scroll.setValue('scroll.mods', 0)

                elseif separate[1] == 'resources' then 
                    
                elseif separate[1] == 'enable-all' then 
               
                    for i, v in ipairs(config["Resources"][Global.Interface.Page]) do 
                        if not v[4] then 
                            addDownloadQueue(v[2], v[1], Global.Interface.Page, true)
                            v[4] = true
                        end
                    end
               
                    saveCacheToXML(true)
                elseif separate[1] == 'off-all' then
                    
                    for i, v in ipairs(config["Resources"][Global.Interface.Page]) do 
                        if fileExists("assets/mods/"..v[3].."/"..v[2]..".txd") and fileExists("assets/mods/"..v[3].."/"..v[2]..".dff") then 
                            engineRestoreModel(v[2])
                            v[4] = false
                        end
                    end

                    saveCacheToXML(false)
                elseif separate[1] == 'delet-all' then
                    
                    for i, v in ipairs(config["Resources"][Global.Interface.Page]) do 
                        if fileExists("assets/mods/"..Global.Interface.Page.."/"..tostring(v[2])..".txd") and fileExists("assets/mods/"..Global.Interface.Page.."/"..tostring(v[2])..".dff") then 
                            engineRestoreModel(v[2])
                        	fileDelete("assets/mods/"..Global.Interface.Page.."/"..tostring(v[2])..".dff")
							fileDelete("assets/mods/"..Global.Interface.Page.."/"..tostring(v[2])..".txd")
                            v[4] = false;
                        end
                    end

                    saveCacheToXML(false)
                elseif separate[1] == 'enable_select' then 
                    local index = tonumber(separate[2])
                    local dados = config["Resources"][Global.Interface.Page][index]
                
                    if dados[4] then 
                        engineRestoreModel(dados[2])
                        dados[4] = false
                    else
                        addDownloadQueue(dados[2], dados[1], Global.Interface.Page, true)
                        dados[4] = true
                    end

                
                elseif separate[1] == 'delet_select' then
                    local index = tonumber(separate[2])
                    local dados = config["Resources"][Global.Interface.Page][index]
                
                    engineRestoreModel(dados[2])

                    if fileExists("assets/mods/"..Global.Interface.Page.."/"..tostring(dados[2])..".txd") and fileExists("assets/mods/"..Global.Interface.Page.."/"..tostring(dados[2])..".dff") then 
                        fileDelete("assets/mods/"..Global.Interface.Page.."/"..tostring(dados[2])..".dff")
                        fileDelete("assets/mods/"..Global.Interface.Page.."/"..tostring(dados[2])..".txd")
                    end
                    
                    dados[4] = false

                elseif separate[1] == 'download_select' then 

                    local index = tonumber(separate[2])
                    local dados = config["Resources"][Global.Interface.Page][index]

                    if dados[4] then 
                        if fileExists("assets/mods/"..Global.Interface.Page.."/"..tostring(dados[2])..".txd") and fileExists("assets/mods/"..Global.Interface.Page.."/"..tostring(dados[2])..".dff") then 
                            engineRestoreModel(dados[2])
                
                            fileDelete("assets/mods/"..Global.Interface.Page.."/"..tostring(dados[2])..".dff")
                            fileDelete("assets/mods/"..Global.Interface.Page.."/"..tostring(dados[2])..".txd")
                    
                            dados[4] = false

                        end

                    else
                        addDownloadQueue(dados[2], dados[1], Global.Interface.Page, true)
                        dados[4] = true
                    end

                elseif separate[1] == 'close' then 
                    toggle(false)
                end
            end
        end
    end
end


recipeMods = function(resources)
    if loadCacheFromXML() ~= false and loadCacheFromXML() ~= false then
        for _, categoria in ipairs(config["Others"].categorias) do
            for i, v in ipairs(config["Resources"][categoria]) do
                if not v[4] then
                    if fileExists("assets/mods/" .. categoria .. "/" .. string.lower(tostring(v[2])) .. ".txd") and fileExists("assets/mods/" .. categoria .. "/" .. string.lower(tostring(v[2])) .. ".dff") then
                        addDownloadQueue(v[2], v[1], categoria, true)
                        v[4] = true
                    end
                end
            end
        end
    end
    Global.Resources = resources
end


addDownloadQueue = function(file, model, category)
    local folder = string.lower(file)

    download.resources["assets/mods/" .. category .. "/" .. folder .. ".txd"] = { model, folder, category }
    download.resources["assets/mods/" .. category .. "/" .. folder .. ".dff"] = { model, folder, category }

    if not (resourcesLoaded[tonumber(folder)]) then 
        resourcesLoaded[tonumber(folder)] =  { model, folder, category }
    end

    download.count = download.count + 2

    downloadFile("assets/mods/" .. category .. "/" .. folder .. ".txd")
    downloadFile("assets/mods/" .. category .. "/" .. folder .. ".dff")
end

addEventHandler('onClientResourceStart', resourceRoot, function ( )
    triggerServerEvent('vanish.get.mods', resourceRoot, localPlayer)
end)

removeDownloadQueue = function(file)
	for i, v in pairs(download.resources) do 
		if i == file then
			download.resources[i] = false
			break
		end
	end
	download.count = download.count - 1
end

addEventHandler("onClientFileDownloadComplete", resourceRoot, function(file, success)
    if success then
        local name = tostring(download.resources[file][2])
        if string.find(file, ".txd") then
            local txd = engineLoadTXD(file)
            if txd then
                engineImportTXD(txd, download.resources[file][2])
                removeDownloadQueue(name)
            else
                outputDebugString("Erro ao carregar arquivo TXD: " .. file)
            end
        elseif string.find(file, ".dff") then
            local dff = engineLoadDFF(tostring(file))
            if dff then
                engineReplaceModel(dff, tonumber(download.resources[file][2]))
                removeDownloadQueue(name)
            else
                outputDebugString("Erro ao carregar arquivo DFF: " .. file)
            end
        end
    else
        outputDebugString("Erro ao baixar arquivo: " .. file)
    end
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
    core()
end)
--[[

addEventHandler( "onClientElementStreamOut", root, 
    function ()
        if source and isElement(source) then
            if source and isElement(source) and getElementType(source) == "vehicle" or getElementType(source) == 'player' then
                if resourcesLoaded[getElementModel(source)] and resourcesLoaded[getElementModel(source)][4] then 
                    if fileExists("assets/mods/" .. resourcesLoaded[getElementModel(source)][3] .. "/" .. getElementModel(source) .. ".txd") then 
                        engineRestoreModel(resourcesLoaded[getElementModel(source)][2])
                        resourcesLoaded[getElementModel(source)][4]  = false;
                    end
                end
            end
        end
    end
)

addEventHandler( "onClientElementStreamIn", root, 
    function ()
        if source and isElement(source) and getElementType(source) == "vehicle" or getElementType(source) == 'player' then
            if resourcesLoaded[getElementModel(source)] and not resourcesLoaded[getElementModel(source)][4] then 
                if fileExists("assets/mods/" .. resourcesLoaded[getElementModel(source)][3] .. "/" .. getElementModel(source) .. ".txd") then 
                    addDownloadQueue(resourcesLoaded[getElementModel(source)][2], resourcesLoaded[getElementModel(source)][1], resourcesLoaded[getElementModel(source)][3])
                    resourcesLoaded[getElementModel(source)][4] = true;
                end
            end
        end
    end
)
]]