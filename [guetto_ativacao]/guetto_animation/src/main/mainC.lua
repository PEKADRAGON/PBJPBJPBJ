local Global = {
    ["Interface"] = {
        ["State"] = false,
        ["Select"] = false,
        ["Categoria"] = "Danças",
        ["Buttons"] = false,
        ["IFPS"] = {},
        ["Spam"] = false
    };
    
    ['Players'] = {};

    ["Favorite"] = {
        ["Positions"] = {},
        ['Animations'] = {},
        ['Buttons'] = false;
    };
}

core = function ( )

    interpolate.create('animation.fade', 300, 'Linear')
    interpolate.create('animation.x', 400, 'InOutQuad')
    
    editbox.events.start()
    scroll.start()
    
    -- Function´s
    loadIFPS()
    loadModels()
    
    bindKey(config['Others'].bind, 'down', function()
            toggle(not Global['Interface']['State'] and true or false)
    end)

    bindKey('space', 'down', function ( )
        if Global['Interface']['State'] or Global['Favorite']['State'] then 
            stopPlayerAnimation()
        end
    end)

    bindKey('backspace', 'down', function()
        toggleFavorite(false)
    end)

    bindKey("'", 'down', function()
        toggleFavorite(not Global['Favorite']['State'] and true or false)
    end)

    --Event´s
    registerEvent('vanish.set.ifp', resourceRoot, setPlayerAnimationIFP)
    registerEvent('vanish.set.custom.animation', resourceRoot, loadPlayerAnimation)
    addEventHandler('onClientPedsProcessed', root, proccessAnim)
end;


draw = function ( )
    cursorUpdate()
    
    Global['Interface']['Buttons'] = { }

    local fade = interpolate.get('animation.fade')

    local w, h = 591 * scale, 441 * scale;
    local x, y = interpolate.get('animation.x'), 234 * scale;

    dxDrawRectangleRounded(x, y, w, h, 11, tocolor(42, 39, 50, fade))

    dxDrawText('Painel de animações', x + 74 * scale, y + 31 * scale, 0, 0, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'left', 'top')
    
    dxDrawImage(x + 19 * scale, y + 17 * scale, 43 * scale, 43 * scale, "assets/images/icons/dance.png", tocolor(255, 255, 255, fade))
    dxDrawRectangleRounded(x + 301 * scale, y + 19 * scale, 260 * scale, 39 * scale, 3, tocolor(56, 53, 64, fade))

    dxDrawRectangleRounded(x, y + 72 * scale, 591 * scale, 1 * scale, 1, tocolor(255, 255, 255, 0.20 * fade))
    dxDrawRectangleRounded(x, 684 * scale, 591 * scale, 92 * scale, 11, tocolor(42, 39, 50, fade))

    dxDrawText(Global['Interface']['Categoria'], x + 12 * scale, y + 88 * scale, 0, 0, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'left', 'top')

    local offSetY = y + 114 * scale
    local width, height = 555 * scale, 49 * scale

    editbox.create('Pesquisar', 'search', x + 355 * scale, y + 28 * scale, 555 * scale, 49 * scale, 0, 0, 30, fade, exports['guetto_assets']:dxCreateFont('regular', 15))
    dxDrawImage(x + 316 * scale, y + 27 * scale, 24 * scale, 24 * scale, 'assets/images/icons/pesquisar.png', tocolor(255, 255, 255, fade))
    
    local content = editbox.utils.getValue('search')
    local line = 0

    scroll.draw('scroll.animations', x + 573 * scale, y + 114 * scale, 6  * scale, 304 * scale, tocolor(49, 46, 57, fade), tocolor(193, 159, 114, fade), 6, #config['Animations'][Global['Interface']['Categoria']])
    scroll.buttons['scroll:scroll.animations'] = {x, y, w, h}

    for i = 1, 6 do 
        local v = config['Animations'][Global['Interface']['Categoria']][i + scroll.getValue('scroll.animations')]
    
        if (v) then 
            if (content == '' or content == 'Pesquisar' or string.find ( string.lower(v.name), string.lower(content) ) or string.find ( string.lower(v.others.command), string.lower(content) ) ) then 
                local bool, _, indexFavorite = getFavoriteExists ( i + scroll.getValue('scroll.animations') )

                line = line + 1
                dxDrawRectangleRounded(x + 12 * scale, offSetY, width, height, 2, isCursorInBox(x + 12 * scale, offSetY, width, height) and tocolor(64, 59, 75, fade) or tocolor(48, 45, 57, fade))
            
                dxDrawText(v.name, x + 74 * scale, offSetY + 13 * scale, 0, 0, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'left', 'top')
                dxDrawText('/'..v.others.command, x + 397 * scale, offSetY + 13 * scale, 0, 0, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'left', 'top')
                
                dxDrawImage(x + 19 * scale, offSetY + height / 2 - 42 * scale / 2, 42 * scale, 42 * scale, "assets/images/icons/star-small.png", isCursorInBox(x + 19 * scale, offSetY + height / 2 - 42 * scale / 2, 42 * scale, 42 * scale) and tocolor(193, 159, 114, fade) or bool and indexFavorite == i and tocolor(193, 159, 114, fade) or tocolor(168, 168, 168, fade))
                
                Global['Interface']['Buttons']['button:animations:'.. i + scroll.getValue('scroll.animations') ] = { x + 55 * scale, offSetY, width, height }
                Global['Interface']['Buttons']['button:stars:'.. line + scroll.getValue('scroll.animations')] = { x + 19 * scale, offSetY + height / 2 - 42 * scale / 2, 42 * scale, 42 * scale }
                offSetY = offSetY + height + 2 * scale
            end;
        end
    end;

    for i, v in ipairs(config['Categorys']) do 
        local offX, offY, width, height, text, icon = unpack(v)

        dxDrawImage(x + offX * scale, 684 * scale + 92 * scale / 2 - height * scale / 2, width * scale, height * scale, icon, Global['Interface']['Categoria'] == text and tocolor(193, 159, 114, fade) or isCursorInBox(x + offX * scale, 684 * scale + 92 * scale / 2 - height * scale / 2, width * scale, height * scale) and tocolor(193, 159, 114, fade) or tocolor(255, 255, 255, fade))
    
        if isCursorInBox(x + offX * scale, 684 * scale + 92 * scale / 2 - height * scale / 2, width * scale, height * scale) then 
            dxDrawRectangleRounded(x + offX * scale - 129 * scale / 2 + width / 2, 761 * scale, 129 * scale, 35 * scale, 3, tocolor(63, 60, 73, fade))
            dxDrawText(text, x + offX * scale - 129 * scale / 2 + width / 2, 763 * scale, 129 * scale, 35 * scale, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'center', 'center')
        end

        Global['Interface']['Buttons']['button:categorys:'.. i] = { x + offX * scale, 684 * scale + 92 * scale / 2 - height * scale / 2, width * scale, height * scale }
    end;

end;

toggle = function ( state )
    if Global['Interface']['Spam'] and getTickCount ( ) - Global['Interface']['Spam'] <= 400 then 
        return 
    end

    if state then 
        if not interpolate.isRunning('animation.fade') then 
            interpolate.exec('animation.fade', 0, 1)
            interpolate.exec('animation.x', 0, 34 * scale)
            showCursor(true)
            addEventHandler('onClientRender', root, draw)
            addEventHandler('onClientClick', root, click)
        end;
    else
        if not interpolate.isRunning('animation.fade') then 
            interpolate.exec('animation.fade', 1, 0)
            interpolate.exec('animation.x', 34 * scale, 0)
            setTimer (function( )
                showCursor(false)
                removeEventHandler('onClientRender', root, draw)
                removeEventHandler('onClientClick', root, click)
            end, 400, 1)
        end;
    end
    Global['Interface']['Spam'] = getTickCount();
    Global['Interface']['State'] = state;
end;

stopPlayerAnimation = function ( )
    return triggerServerEvent('vanish.stop.animation', resourceRoot, localPlayer)
end;

click = function(button, state)
    if button == 'left' then 
        if state == 'down' then 
            Global['Interface']['Select'] = false;

            for i, v in pairs(Global['Interface']['Buttons']) do 
                if isCursorInBox(unpack(v)) then 
                    Global['Interface']['Select'] = i
                    break 
                end
            end;
        elseif state == 'up' then 
            if Global['Interface']['Select'] then 
                local separete = split(Global['Interface']['Select'], ':')
                Global['Interface']['Select'] = false;

                if separete[1] == 'button' then 

                    if separete[2] == 'categorys' then 

                        Global['Interface']['Categoria'] = config['Categorys'][tonumber(separete[3])][5]
                        scroll.setValue('scroll.animations', 0)
                  
                    elseif separete[2] == 'stars' then
        
                        if #Global['Favorite']['Animations'] >= 6 then 
                            return config.sendMessageClient('Você atingiu o limite de animações favoritadas!', 'error')
                        end;

                        local bool, index = getFavoriteExists ( tonumber(separete[3]) )

                        if bool then 
                            table.remove(Global['Favorite']['Animations'], index)
                            
                            Global.Favorite.Positions[index][6] = false
                        else

                            Global['Favorite']['Animations'][#Global['Favorite']['Animations'] + 1] = {
                                index = tonumber(separete[3]),
                                data = config['Animations'][Global['Interface']['Categoria']][tonumber(separete[3])]
                            }
                            
                            for _, v in ipairs(Global.Favorite.Positions) do 
                                if not v[6] then 
                                    v[6] = true
                                    break
                                end
                            end
                        end
                        config.sendMessageClient('Animação '..(bool and 'removida' or 'adicionada')..' aos favoritos!', bool and 'error' or 'success')
                    elseif separete[2] == 'animations' then 

                        if spam and getTickCount ( ) - spam <= config['Others']['coolDown'] then 
                            return config.sendMessageClient('Aguarde '..math.floor((config['Others']['coolDown'] - (getTickCount() - Global['Interface']['Spam']))/1000)..' segundos para executar uma nova animação!', 'error')
                        end

                        local key = getPlayerSerial(localPlayer)    

                        local hashtoKey = toJSON({
                            dados = config['Animations'][Global['Interface']['Categoria']][tonumber(separete[3])], 
                            key = key
                        })

                        encodeString('aes128', hashtoKey, {key = key:sub(17)}, function(enc, iv)
                            triggerServerEvent ( 'vanish.set.animation', resourceRoot, localPlayer, enc, iv )
                        end)

                        spam = getTickCount ( )
                    end;
                end
            end
        end
    end
end;


loadIFPS = function ( )
    for i, v in ipairs(config['IFPS']) do 
        engineLoadIFP('assets/ifps/'..(v)..'.ifp', v)
    end;
end;

loadModels = function ( )
    for _, v in ipairs(config['Objects']) do
        engineImportTXD(engineLoadTXD('assets/models/'..(v.Name)..'.txd'), v.Model)
        engineReplaceModel(engineLoadDFF('assets/models/'..(v.Name)..'.dff'), v.Model)
    end
end;

loadPlayerAnimation = function (player, tbl)
    if Global['Players'][player] then 
        Global['Players'][player] = nil 
        return
    end

    if tbl then 
        Global['Players'][player] = {
            block = tbl.category,
            anim = tbl.animation,
            time = tbl.options[1],
            tick = getTickCount()
        }
    end;

end;

function isnan(x) 
    if (x ~= x) then 
        return true 
    end 
    if type(x) ~= "number" then 
       return false 
    end 
    if tostring(x) == tostring((-1)^0.5) then 
        return true 
    end 
    return false 
end 

proccessAnim = function()
    for player, v in pairs(Global['Players']) do
        if isElement(player) then
            if isElementStreamable(player) and isElementStreamedIn(player) then
                local datas = config['CUSTOM_ANIMATIONS'][v.block][v.anim][(isPedDucked(player) and config['CUSTOM_ANIMATIONS'][v.block][v.anim].onDuck) and 'onDuck' or 'BonesRotation']
                for bone, rot in pairs(datas) do
                    local actualBone = {getElementBoneRotation(player, bone)}
                    if actualBone and type(actualBone) == 'table' and type(rot) == 'table' then 
                        if #actualBone <= 0 or #rot <= 0 then 
                            return 
                        end
                       setElementBoneRotation(player, bone, rot[1], rot[2], rot[3])
                    end
                end
                updateElementRpHAnim(player)
                if player == localPlayer then
                    if datas.blockVehicle and isPedInVehicle(player) then
                        stopPlayerAnimation()
                    end
                end
            end
        else
            Global['Players'][player] = nil
        end
    end
end

setPlayerAnimationIFP = function ( player, category, anim )
    setPedAnimation( player, category, anim )
end;

getFavoriteExists = function (index)
    for i, v in ipairs(Global['Favorite']['Animations']) do 
        if v.index == index then 
            return true, i, v.index
        end
    end
    return false;
end

Global.Favorite.Positions = {
    {207 * scale, 51 * scale, 44 * scale, 42 * scale, 'assets/images/bg/1.png', false};
    {348 * scale, 128 * scale, 45 * scale, 50 * scale, 'assets/images/bg/2.png', false};
    {348 * scale, 285 * scale, 45 * scale, 50 * scale, 'assets/images/bg/2.png', false};
    {207 * scale, 367 * scale, 44 * scale, 42 * scale, 'assets/images/bg/1.png', false};
    {64 * scale, 286 * scale, 56 * scale, 48 * scale, 'assets/images/bg/3.png', false};
    {64 * scale, 127 * scale, 56 * scale, 48 * scale, 'assets/images/bg/3.png', false};
}

drawFavorite = function()
    cursorUpdate()

    Global['Favorite']['Buttons'] = { }

    local w, h = 460 * scale, 460 * scale
    local x, y = (screen[1] - w) / 2, (screen[2] - h) / 2

    dxDrawImage(x, y, w, h, "assets/images/bg/favorite.png", tocolor(255, 255, 255, 1))

    local selectedIdx = nil

    for i, v in ipairs(Global.Favorite.Positions) do 
        if v[6] == true then 

            local itemX, itemY, itemW, itemH = x + v[1], y + v[2], 187 * scale, 199 * scale
            local detectAreaX = itemX - (itemW / 2)
            local detectAreaY = itemY - (itemH / 2)
            local detectAreaW = itemW
            local detectAreaH = itemH
    
            if isCursorInBox(detectAreaX, detectAreaY, detectAreaW, detectAreaH) then
                selectedIdx = i
            end
    
            dxDrawImage(x + v[1], y + v[2], v[3], v[4], v[5], tocolor(255, 255, 255, 1), 0, 0, 0, true)
           
            Global['Favorite']['Buttons']['Animations:'..i] = {x, y, w, h}
        end
    end

    if selectedIdx then
        dxDrawImage(x, y, w, h, "assets/images/bg/select.png", tocolor(255, 255, 255, 1), 360 / 6 * (selectedIdx - 1))
    end

    if selectedIdx and Global['Favorite']['Animations'][selectedIdx] then
        local width = dxGetTextWidth(Global['Favorite']['Animations'][selectedIdx].data.name, 1, exports['guetto_assets']:dxCreateFont('light', 15), false)
        dxDrawText(Global['Favorite']['Animations'][selectedIdx].data.name, x + 144 * scale + 172 * scale / 2 - width / 2, y + 232 * scale, width, 23 * scale, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('light', 15), 'left', 'top')
    end

    dxDrawText('FAVORITOS', x + 187 * scale, y + 208 * scale, 82 * scale, 23 * scale, tocolor(255, 255, 255, fade), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'left', 'top')

    dxDrawText('PRESSIONE BACKSPACE PARA ENCERRAR ANIMAÇÃO', x + 52 * scale, y + 500 * scale, 0, 0, tocolor(255, 255, 255, 1), 1, exports['guetto_assets']:dxCreateFont('regular', 15), 'left', 'top' )
end

toggleFavorite = function (state)
    if state then 
        showCursor(true)
        addEventHandler('onClientRender', root, drawFavorite)
        addEventHandler('onClientClick', root, clickFavorite)
    else
        showCursor(false)
        removeEventHandler('onClientRender', root, drawFavorite)
        removeEventHandler('onClientClick', root, clickFavorite)
    end
    Global['Favorite']['State'] = state;
end;

clickFavorite = function (button, state)
    if button == 'left' then 
        if state == 'down' then 
            Global['Favorite']['Select'] = false;
            for i, v in pairs(Global['Favorite']['Buttons']) do 
                if isCursorInBox(unpack(v)) then 
                    Global['Favorite']['Select'] = i;
                    break
                end
            end
        elseif state == 'up' then 
            if Global['Favorite']['Select'] then 
                local separete = split(Global['Favorite']['Select'], ':')
                if separete[1] == 'Animations' then 
                    local index = tonumber(separete[2])
                    local key = getPlayerSerial(localPlayer)    

                    local hashtoKey = toJSON({
                        dados = Global['Favorite']['Animations'][index].data, 
                        key = key
                    })
                    encodeString('aes128', hashtoKey, {key = key:sub(17)}, function(enc, iv)
                        triggerServerEvent ( 'vanish.set.animation', resourceRoot, localPlayer, enc, iv )
                    end)
                    toggleFavorite(false)
                end
                Global['Favorite']['Select'] = false;
            end
        end
    end
end;

core ( )
