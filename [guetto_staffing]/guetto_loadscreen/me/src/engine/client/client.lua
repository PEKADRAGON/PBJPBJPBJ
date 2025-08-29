local Global = {
    Others = {
        InterfaceVisibile = true,
        SoundActive = false,
        ImageRandom = math.random(#config.images),
        MusicIndex = 1,
    },
    Interface = {
        Animations = {
            Alpha = {0, 255, getTickCount ( ), false},
            personAlpha = {0, 255, getTickCount ( ), false},
        },
    },
}

local load = { }
local str = "..."
local count = 0

local clientBackgroundRotation = 0
local clientBlockTransition = false

tick = getTickCount()

--local guiInfo = {
--    browser = {
--        volume = 0,
--        dimness = 90,
--	    url = "https://www.youtube.com/embed/yr6rZj9q9KY?autoplay=1", -- "https://www.youtube.com/embed/QT8HpYUY4Rc?autoplay=1",
--        loadTime = 8000,  
--
--    }
--}
--
--function loadBrowser() 
--    loadBrowserURL(guiInfo.browser.browser, guiInfo.browser.url)
--end
--
--function onBrowserLoad(url)
--    if url == guiInfo.browser.url then
--        setTimer(setBrowserVolume, 1000, 2, guiInfo.browser.browser, guiInfo.browser.volume)
--    end
--end

local sound = playSound(config.musics[Global.Others.MusicIndex].path)
setSoundVolume(sound, 0.5)

function Draw( )
    
    --dxDrawImage(0, 0, 1920, 1080, guiInfo.browser.browser, 0, 0, 0,tocolor(255,255,255,255))
    dxDrawImage(0, 0, 1920, 1080, "me/assets/icons/icon-cinematic.png", 0, 0, 0, tocolor(255,255,255,255))
    local alpha = interpolateBetween (Global.Interface.Animations.Alpha[1], 0, 0, Global.Interface.Animations.Alpha[2], 0, 0, (getTickCount ( ) - Global.Interface.Animations.Alpha[3]) / 1000, "Linear")
    local alphaPerson = interpolateBetween (Global.Interface.Animations.personAlpha[1], 0, 0, Global.Interface.Animations.personAlpha[2], 0, 0, (getTickCount ( ) - Global.Interface.Animations.personAlpha[3]) / 1000, "Linear")

    local oldTick = getTickCount ( )
    local currentTime = oldTick - Global.Interface.Animations.Alpha[3]

    local oldTick2 = getTickCount ( )
    local currentTime2 = oldTick2 - Global.Interface.Animations.personAlpha[3]

    if (currentTime2 >= 1100 and not Global.Interface.Animations.personAlpha[4]) then 
        Global.Interface.Animations.personAlpha[4] = true
        Global.Interface.Animations.personAlpha[1] = 255
        Global.Interface.Animations.personAlpha[2] = 0
        Global.Interface.Animations.personAlpha[3] = getTickCount ( )
        math.randomseed( getTickCount() )
        Global.Others.ImageRandom = math.random( 1, #config.images )
    elseif (currentTime2 >= 10000 and Global.Interface.Animations.personAlpha[4]) then
        Global.Interface.Animations.personAlpha[4] = false
        Global.Interface.Animations.personAlpha[1] = 0
        Global.Interface.Animations.personAlpha[2] = 255
        Global.Interface.Animations.personAlpha[3] = getTickCount ( )
    end

    if (currentTime >= 1000 and not Global.Interface.Animations.Alpha[4]) then 
        Global.Interface.Animations.Alpha[4] = true
        Global.Interface.Animations.Alpha[1] = 255
        Global.Interface.Animations.Alpha[2] = 0
        Global.Interface.Animations.Alpha[3] = getTickCount ( )
        if (count < 3) then 
            count = count + 1
        end
    elseif (currentTime >= 1000 and Global.Interface.Animations.Alpha[4]) then
        Global.Interface.Animations.Alpha[4] = false
        Global.Interface.Animations.Alpha[1] = 0
        Global.Interface.Animations.Alpha[2] = 255
        Global.Interface.Animations.Alpha[3] = getTickCount ( )
        if (count >= 3) then
            count = 0 
        end
    end


    if clientBackgroundRotation >= 7 then
        clientBlockTransition = true
    elseif clientBackgroundRotation <= -7 then
        clientBlockTransition = false
    end
    if clientBlockTransition then
        local rotation = interpolate(7.32, -7.32, 0.01, "Lerp2")
        clientBackgroundRotation = rotation
    else
        local rotation = interpolate(-7.32, 7.32, 0.01, "Lerp2")
        clientBackgroundRotation = rotation
    end

    local fundo1 = interpolateBetween(0, 0, 0, -1920, 0, 0, (getTickCount()-tick)/45000, 'SineCurve')
    local fundo2 = interpolateBetween(1920, 0, 0, 0, 0, 0, (getTickCount()-tick)/45000, 'SineCurve')
  
    dxDrawImage(0, 0, 1920, 1080, config.images[Global.Others.ImageRandom].background, 0, 0, 0, tocolor(255, 255, 255, 255))
   -- dxDrawImage(0, 0, 1920, 1080, config.images[Global.Others.ImageRandom].image, 0, 0, 0, tocolor(255, 255, 255, 255))
    dxDrawImage(fundo1, 0, 1920, 1080, "me/assets/background/1.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
    dxDrawImage(fundo2, 0, 1920, 1080, "me/assets/background/2.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
    
    local fftMul = 0
    if isElement(sound) then
        local FFT = getSoundFFTData(sound, 2048, 0)
        
        if FFT then
            FFT[1] = math.sqrt(FFT[1]) * 2

            if FFT[1] < 0 then
                FFT[1] = 0
            elseif FFT[1] > 1 then
                FFT[1] = 1
            end

            fftMul = FFT[1]

            if alpha > 0 then
            dxDrawImage(0, 0, 1920, 1080, "me/assets/background/light.png", 0, 0, 0, tocolor(38, 126, 240, 255 * FFT[1]))
            dxDrawImage(0, 0, 1920, 1080, "me/assets/background/light.png", 180, 0, 0, tocolor(240, 38, 38, 255 * FFT[1]))
            end
        end
    end
    
    --dxDrawImage(0, 0, 1920, 1080, "me/assets/background/blur.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
    --dxDrawImage(878-810, 31, 64.84, 74.95, "me/assets/icons/icon-logo.png", 0, 0, 0, tocolor(255, 255, 255, 255))

    
    --dxDrawText(config.images[Global.Others.ImageRandom].title, 130-70, 981-40, 46, 20, tocolor(255, 255, 255, 255), 1, dxCreateFont("me/assets/fonts/Montserrat-Bold.ttf", 20), "left", "top")
    --dxDrawText(config.images[Global.Others.ImageRandom].description, 130-70, 981, 515, 18, tocolor(255, 255, 255, 255), 1, dxCreateFont("me/assets/fonts/Montserrat-Light.ttf", 15), "left", "top")

   
   -- dxDrawText("Instalando arquivos" .. string.sub(str, 1, count) .. "", 1541, 981, 67, 16, tocolor(255, 255, 255, alpha), 1, exports['guetto_assets']:dxCreateFont, "left", "top", false, false, true)


    if downloaded and total then
        local progress = interpolate(0, tonumber(downloaded), 0.03, "progressDownload") -- Converta downloaded para número
        dxDrawText("Instalando arquivos" .. string.sub(str, 1, count) .. "", 1541, 981, 67, 16, tocolor(255, 255, 255, alpha), 1, exports['guetto_assets']:dxCreateFont("bold", 12), "left", "top", false, false, true)
        --dxDrawText("Baixando arquivo: " .. string.sub(str, 1, count) .. "", 1541, 981, 67, 16, tocolor(255, 255, 255, 255), 1, dxCreateFont("me/assets/fonts/Montserrat-Regular.ttf", 12), "left", "top", false, false, true)
        dxDrawText(math.floor(progress) .. "/" .. math.floor(tonumber(total)) .. "[mb]", 1788, 981, 94, 16, tocolor(255, 255, 255, 255), 1, exports['guetto_assets']:dxCreateFont("bold", 12), "left", "top", false, false, true)
        dxDrawRectangle(1541, 1002, 345, 7, tocolor(45, 50, 51), true)
        dxDrawRectangle(1541, 1002, (progress * 345) / tonumber(total), 7, tocolor(206, 205, 255, 255), true)
    end
    
    
    if isElement(sound) then
        if isSoundPaused(sound) then
            if isCursorOnElement(1812, 59, 30, 30) then
                dxDrawImage(1812, 59, 30, 30, "me/assets/background/play.png", 0, 0, 0, tocolor(255, 255, 255, 255))
            else
                dxDrawImage(1812, 59, 30, 30, "me/assets/background/play.png", 0, 0, 0, tocolor(255, 255, 255, 255))
            end
        else
            if isCursorOnElement(1812, 59, 30, 30) then
                dxDrawImage(1812, 59, 30, 30, "me/assets/background/pause.png", 0, 0, 0, tocolor(255, 255, 255, 255))
            else
                dxDrawImage(1812, 59, 30, 30, "me/assets/background/pause.png", 0, 0, 0, tocolor(255, 255, 255, 255))
            end
        end
        dxDrawText("#B0B1B2Tocando agora\n#DDDDDE"..config.musics[Global.Others.MusicIndex].author..".", 1478, 30, 314, 86, tocolor(255, 255, 255, 255), 1, exports['guetto_assets']:dxCreateFont("light", 10), "right", "center", false, false, true, true, false)
    end

    dxDrawRectangle(0, 0, 1920, 1080, tocolor(0, 0, 0, alphaPerson))
end
function openPanel()
    if not isEventHandlerAdded("onClientRender", root, Draw) then
        triggerServerEvent("SQX.offVoice", localPlayer, localPlayer, true)
        addEventHandler("onClientRender", root, Draw)
        showCursor(true)
	    setTransferBoxVisible(false)
        showChat(false)
       -- guiInfo.browser.browser = createBrowser(1920, 1080, false, false)
        --addEventHandler("onClientBrowserCreated", guiInfo.browser.browser, loadBrowser)
        --addEventHandler("onClientBrowserDocumentReady" , guiInfo.browser.browser, onBrowserLoad) 
    end
end
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), openPanel)


addEventHandler("onClientTransferBoxProgressChange", root, function(downloadedSize, totalSize)
    percentage = math.min((downloadedSize / totalSize) * 100, 100)
    downloaded = string.format("%.2f", downloadedSize / (1024 * 1024)) -- Correção aqui
    total = string.format("%.2f", totalSize / 1048576) -- Correção aqui
end)


addEventHandler("onClientClick", root,  
    function (button, state)
        if (button ~= "left") then 
            return 
        end
        if (state == "down") then 
            if Global.Others.InterfaceVisibile then 
                if (isCursorOnElement(1812, 59, 30, 30) and not Global.Others.SoundActive) then 
                    Global.Others.SoundActive = true
                    setSoundPaused(sound, true)
                elseif (isCursorOnElement(1812, 59, 30, 30) and Global.Others.SoundActive) then
                    Global.Others.SoundActive = false
                    setSoundPaused(sound, false)
                end
            end
        end
    end
)

addEventHandler("onClientTransferBoxVisibilityChange", getRootElement(),
function(isVisible)
    if isEventHandlerAdded("onClientRender", root, Draw) then
        closeMenu()
    end
end)

addEventHandler("onClientSoundStopped", root,
    function (reason)
        if (source == sound) then 
            if (reason == "finished") then 
                if (Global.Others.MusicIndex <= #config.musics) then 
                    Global.Others.MusicIndex = Global.Others.MusicIndex + 1
                    sound = playSound(config.musics[Global.Others.MusicIndex].path)
                    setSoundVolume(sound, 0.5)
                elseif (Global.Others.MusicIndex > #config.musica) then 
                    Global.Others.MusicIndex = Global.Others.MusicIndex - 1
                    sound = playSound(config.musics[Global.Others.MusicIndex].path)
                    setSoundVolume(sound, 0.5)
                end
            end
        end
    end
)

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


function load.removeLoadScreen ()    
    if (isTransferBoxActive()) then
        setTimer(load.removeLoadScreen, 3000, 1)
    else 
        if sound and isElement(sound) then
            stopSound(sound)
            sound = nil
        end
        triggerServerEvent("SQX.offVoice", localPlayer, localPlayer, false)
        showChat(true)
        showCursor(false)
        removeEventHandler('onClientRender', root, Draw)
    end
end
setTimer(load.removeLoadScreen, 3000, 1)

