local screen = {guiGetScreenSize()}
local sx, sy = (screen[1]/1366), (screen[2]/768)

function isMouseInPosition(x,y,w,h)
    if isCursorShowing() then
        local sx,sy = guiGetScreenSize()
        local cx,cy = getCursorPosition()
        local cx,cy = (cx*sx),(cy*sy)
        if (cx >= x and cx <= x+w) and (cy >= y and cy <= y+h) then
            return true
        end
    end
end

_dxDrawImage = dxDrawImage
function dxDrawImage (x, y, w, h, ...)
    local x, y, w, h = sx * x, sy * y, sx * w, sy * h
    return _dxDrawImage (x, y, w, h, ...)
end

_dxDrawImageSection = dxDrawImageSection
function dxDrawImageSection (x, y, w, h, ...)
    local x, y, w, h = sx * x, sy * y, sx * w, sy * h
    return _dxDrawImageSection (x, y, w, h, ...)
end

_isMouseInPosition = isMouseInPosition
function isMouseInPosition (x, y, w, h)
    local x, y, w, h = sx * x, sy * y, sx * w, sy * h
    return _isMouseInPosition (x, y, w, h)
end

_dxCreateFont = dxCreateFont
function dxCreateFont (file, tamanho)
    local tamanho = sx * tamanho
    return _dxCreateFont (file, tamanho)
end

_dxDrawRectangle = dxDrawRectangle
function dxDrawRectangle (x, y, w, h, ...)
    local x, y, w, h = sx * x, sy * y, sx * w, sy * h
    return _dxDrawRectangle (x, y, w, h, ...)
end

_dxDrawText = dxDrawText
function dxDrawText (text, x, y, w, h, ...)
    local x, y, w, h = sx * x, sy * y, sx * w, sy * h
    return _dxDrawText (text, x, y, w, h, ...)
end

sound = {}
edits = {}
dadosMusicTocando = {}

local font = dxCreateFont("files/fonts/Roboto-Regular.ttf", 10)
local font2 = dxCreateFont("files/fonts/Roboto-Regular.ttf", 8)

function dx()
    dxDrawImage(390, 159, 586, 450, "files/imgs/base.png")
    dxDrawImage(711, 260, 5, 45, "files/imgs/scroll.png")
    createEditBox(434, 224, 288, 25, select == 1 and tocolor(255, 255, 255, 255) or tocolor(48, 48, 49, 255), font, 1)
    linha = 0
    for i, v in ipairs(Pesquisa) do
        if (i > proxPage and linha < 8) then
            linha = linha + 1
            dxDrawImage(408, (231 + 29 * linha), 50, 25, "files/imgs/music_pesq.png")
            if isMouseInPosition(683, (234 + 29 * linha), 19, 19) then
                dxDrawImage(683, (234 + 29 * linha), 19, 19, "files/imgs/play.png", 0, 0, 0, tocolor(155, 111, 199))
            else
                dxDrawImage(683, (234 + 29 * linha), 19, 19, "files/imgs/play.png")
            end
            if isMouseInPosition(653, (231 + 29 * linha), 25, 25) or favoriteMusics[v[1]] then
                dxDrawImage(653, (231 + 29 * linha), 25, 25, "files/imgs/favorite.png", 0, 0, 0, tocolor(155, 111, 199))
            else
                dxDrawImage(653, (231 + 29 * linha), 25, 25, "files/imgs/favorite.png", 0, 0, 0, tocolor(48, 48, 49))
            end
            dxDrawText(v[2], 448, (231 + 29 * linha), 650, (255 + 29 * linha), tocolor(255, 255, 255, 255), 1.00, font2, "left", "center", true, false, false, false, false)
        end
    end
    if isElement(sound[indexMarker]) then
        dxDrawImage(408, 498, 314, 65, "files/imgs/cage_tocando.png")
        dxDrawImage(408, 518, 50, 25, "files/imgs/music_pesq.png")
        if isMouseInPosition(683, 521, 19, 19) then
            dxDrawImage(683, 521, 19, 19, "files/imgs/play.png", 0, 0, 0, tocolor(155, 111, 199))
        else
            dxDrawImage(683, 521, 19, 19, "files/imgs/play.png")
        end
        dxDrawText("tocando:", 453, 516, 655, 531, tocolor(129, 129, 130, 255), 1.00, font2, "left", "center", false, false, false, false, false)
        dxDrawText(dadosMusicTocando[indexMarker][2], 453, 531, 655, 546, tocolor(255, 255, 255, 255), 1.00, font2, "left", "center", true, false, false, false, false)
    end
    linhaTwo = 0
    for i, v in ipairs(dataMusics) do
        if (i > proxPageFavorites and linhaTwo < 7) then
            linhaTwo = linhaTwo + 1
            dxDrawImage(772, (170 + 54 * linhaTwo), 181, 50, "files/imgs/cage_fav.png")
            dxDrawImage(776, (175 + 54 * linhaTwo), 40, 40, "files/imgs/music_fav.png")
            if isMouseInPosition(934, (176 + 54 * linhaTwo), 13, 13) then
                dxDrawImage(934, (176 + 54 * linhaTwo), 13, 13, "files/imgs/play.png", 0, 0, 0, tocolor(155, 111, 199))
            else
                dxDrawImage(934, (176 + 54 * linhaTwo), 13, 13, "files/imgs/play.png")
            end
            if isMouseInPosition(933, (192 + 54 * linhaTwo), 14, 10) then
                dxDrawImage(933, (192 + 54 * linhaTwo), 14, 10, "files/imgs/remove.png", 0, 0, 0, tocolor(155, 111, 199))
            else
                dxDrawImage(933, (192 + 54 * linhaTwo), 14, 10, "files/imgs/remove.png", 0, 0, 0, tocolor(145, 145, 135))
            end
            dxDrawText("música favorita", 811, (180 + 54 * linhaTwo), 891, (195 + 54 * linhaTwo), tocolor(129, 129, 130, 255), 1.00, font2, "left", "center", false, false, false, false, false)
            dxDrawText(v.nameMusic, 811, (196 + 54 * linhaTwo), 924, (211 + 54 * linhaTwo), tocolor(255, 255, 255, 255), 1.00, font2, "left", "center", true, false, false, false, false)
        end
    end
end

addEvent("JOAO.openPanelDJ", true)
addEventHandler("JOAO.openPanelDJ", root,
function(dataMusics_, indexMarker_)
    if not isEventHandlerAdded("onClientRender", root, dx) then
        EditBox("add")
        indexMarker = indexMarker_
        favoriteMusics = {}
        proxPageFavorites = 0
        dataMusics = {}
        if #dataMusics_ > 0 then
            dataMusics = fromJSON(dataMusics_[1]["musics"])
            for i, v in ipairs(dataMusics) do
                favoriteMusics[v.idMusic] = true
            end
        end
        select = false
        Pesquisa = {}
        proxPage = 0
        addEventHandler("onClientRender", root, dx)
        showCursor(true)
    end
end)

addEventHandler("onClientClick", root,
function(_, state)
    if state == "up" then
        if isEventHandlerAdded("onClientRender", root, dx) then
            if isMouseInPosition(434, 224, 288, 25) then
                select = false
                if guiEditSetCaretIndex(edits[1], string.len(guiGetText(edits[1]))) then
                    select = 1
                    guiBringToFront(edits[1])
                    guiSetInputMode("no_binds_when_editing") 
                    if (guiGetText(edits[1]) == "Buscar música") then 
                        guiSetText(edits[1], "")
                    end
                end
            end
            linha = 0
            for i, v in ipairs(Pesquisa) do
                if (i > proxPage and linha < 8) then
                    linha = linha + 1
                    if isMouseInPosition(683, (234 + 29 * linha), 19, 19) then
                        triggerServerEvent("JOAO.tocarMusicDJ", resourceRoot, Pesquisa[i], indexMarker, "normal")
                    end
                    if isMouseInPosition(653, (231 + 29 * linha), 25, 25) then
                        triggerServerEvent("JOAO.favoriteMusicDJ", resourceRoot, Pesquisa[i], indexMarker, "normal")
                    end
                end
            end
            if isElement(sound[indexMarker]) then
                if isMouseInPosition(683, 521, 19, 19) then
                    triggerServerEvent("JOAO.pararMusicDJS", resourceRoot, indexMarker)
                end
            end
            linhaTwo = 0
            for i, v in ipairs(dataMusics) do
                if (i > proxPageFavorites and linhaTwo < 7) then
                    linhaTwo = linhaTwo + 1
                    if isMouseInPosition(934, (176 + 54 * linhaTwo), 13, 13) then
                        triggerServerEvent("JOAO.tocarMusicDJ", resourceRoot, dataMusics[i], indexMarker, "favorite")
                    end
                    if isMouseInPosition(933, (192 + 54 * linhaTwo), 14, 10) then
                        triggerServerEvent("JOAO.favoriteMusicDJ", resourceRoot, dataMusics[i], indexMarker, "favorite")
                    end
                end
            end
        end
    end
end)

function closeMenu()
    if isEventHandlerAdded("onClientRender", root, dx) then
        EditBox("destroy")
        removeEventHandler("onClientRender", root, dx)
        showCursor(false)
    end
end
bindKey("backspace", "down", closeMenu)

addEventHandler("onClientKey", root,
function (button, press)
	if isEventHandlerAdded("onClientRender", root, dx) then
		if button == "enter" and press then
            if select == 1 then
                if guiGetText(edits[1]) == "" or guiGetText(edits[1]) == "Buscar música" then
                    notifyC("Você precisa digitar o nome da música!", "error")
                else
                    triggerServerEvent("JOAO.pesquisarMusicDJ", resourceRoot, guiGetText(edits[1]))
                end
            end
		end
	end
end)

addEvent('JOAO.tocarMusicCDJ', true)
addEventHandler('JOAO.tocarMusicCDJ', root,
function(index, x, y, z, int, dim, dataMusic, typeK)
    if dataMusic then
        if isElement(sound[index]) then stopSound(sound[index]) end
        if typeK == "normal" then
            dadosMusicTocando[index] = dataMusic
        else
            dadosMusicTocando[index] = {dataMusic.idMusic, dataMusic.nameMusic}
        end
        
        sound[index] = playSound3D("https://server1.mtabrasil.com.br/play?id="..(typeK == "normal" and dataMusic[1] or dataMusic.idMusic), x, y, z, false)

        setElementInterior(sound[index], int)
        setElementDimension(sound[index], dim)
        setSoundVolume(sound[index], 0.8)
        setSoundMaxDistance(sound[index], 100)
    end
end) 

addEvent('JOAO.pararMusicDJC', true)
addEventHandler('JOAO.pararMusicDJC', root,
function(index)
    if isElement(sound[index]) then
        destroyElement(sound[index]) 
    end
end)

addEvent("JOAO.attFavoritesMusicsDJ", true)
addEventHandler("JOAO.attFavoritesMusicsDJ", root,
function(dataMusics_)
    dataMusics = fromJSON(dataMusics_[1]["musics"])
    favoriteMusics = {}
    for i, v in ipairs(dataMusics) do
        favoriteMusics[v.idMusic] = true
    end
end)

function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
    if type( sEventName ) == "string" and isElement( pElementAttachedTo ) and type( func ) == "function" then
        local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
        if type( aAttachedFunctions ) == "table" and #aAttachedFunctions > 0 then
            for i, v in ipairs( aAttachedFunctions ) do
                if v == func then
                    return true
                end
            end
        end
    end
    return false
end

function createEditBox(x, y, w, h, color, fontType, typeBox)
    if (dxGetTextWidth((select == typeBox and guiGetText(edits[typeBox])..'|' or guiGetText(edits[typeBox])), 1.00, fontType) <= w - 10) then
        dxDrawText(select == typeBox and guiGetText(edits[typeBox])..'|' or guiGetText(edits[typeBox]), x + 5, y, x + w - 10, y + h, color, 1.00, font, "left", "center", true, false, false, false, false)
    else
        dxDrawText(select == typeBox and guiGetText(edits[typeBox])..'|' or guiGetText(edits[typeBox]), x + 5, y, x + w - 10, y + h, color, 1.00, font, "right", "center", true, false, false, false, false)
    end
end

function EditBox(tipo)
    if tipo == 'destroy' then
        for i=1, #edits do
            if isElement(edits[i]) then 
                destroyElement(edits[i])
            end
        end
    elseif tipo == 'add' then
        edits[1] = guiCreateEdit(-1000, -1000, 325, 50, 'Buscar música', false)
        guiEditSetMaxLength(edits[1], 200)
	end 
end

addEvent('JOAO.sendInfoMusicsDJ', true)
addEventHandler('JOAO.sendInfoMusicsDJ', root,
function(musics)
    Pesquisa = {}
    for i, v in pairs(musics.items) do
        if (v.type == "video") then 
            Pesquisa[i] = {v.id, v.name, v.description, v.author.name, v.thumbnail, v.duration, v.url}
        end
    end
end)

function convertTime(timeInString)
    if timeInString then
        local splitado = split(timeInString, ":")
        return (tonumber(splitado[2]*1000)+tonumber(splitado[1]*60000))
    end
    return 0
end