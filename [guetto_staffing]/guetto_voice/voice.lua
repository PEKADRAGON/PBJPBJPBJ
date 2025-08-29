local streamedOut = {}

local voiceData = {}
local voiceEnable = {}

local fonts = {
    dxCreateFont('archives/regular.ttf', 12); 
}

addEventHandler("onClientPreRender", root,
	function ()

        voiceData = {}
        local players = getElementsByType("player", root) -- table of sounds which will be transformed into 3D
        for k, v in ipairs(players) do
            if (v ~= localPlayer) then 
                -- Modify the sound's volume and pan to make it seem 3D, based on MTA source code
                
                local inRadioWithMe = false 
                local sFreq = getElementData(v, "frequency");
                local lFreq = getElementData(localPlayer, "frequency");
                if (lFreq == sFreq) then 
                    if (getElementData(v, "radio.talking")) then 
                        setSoundEffectEnabled(v, "compressor", false);
                        setSoundVolume(v, 4);
                        inRadioWithMe = true;

                        if voiceEnable[v] then
                            table.insert(voiceData, '('..(getElementData(v, 'ID') or 'N/A')..') - Rádio')
                        end
                    end
                end

                local inPhoneWithMe = false
                local call = (getElementData(localPlayer, 'Call') or false)
        	    local callS = (getElementData(v, 'Call') or false) 

                if call and callS and (call == callS) then
                   	setSoundEffectEnabled(v, "compressor", false);
                    setSoundVolume(v, 4);
                    inPhoneWithMe = true;

                    if voiceEnable[v] then
                        table.insert(voiceData, '('..(getElementData(v, 'ID') or 'N/A')..') - Celular2')
                    end
                end

                if isElementStreamedIn(v) and not (inRadioWithMe) and not (inPhoneWithMe) then 
                    local vecSoundPos = v.position
                    local vecCamPos = Camera.position
                    local fDistance = (vecSoundPos - vecCamPos).length
                    local fMaxVol = v:getData("maxVol") or 15
                    local fMinDistance = v:getData("minDist") or 5
                    local fMaxDistance = v:getData("maxDist") or 25
                            
                    -- Limit panning when getting close to the min distance
                    local fPanSharpness = 1.0
                    if (fMinDistance ~= fMinDistance * 2) then
                        fPanSharpness = math.max(0, math.min(1, (fDistance - fMinDistance) / ((fMinDistance * 2) - fMinDistance)))
                    end
                    
                    local fPanLimit = (0.65 * fPanSharpness + 0.35)
                    
                    -- Pan
                    local vecLook = Camera.matrix.forward.normalized
                    local vecSound = (vecSoundPos - vecCamPos).normalized
                    local cross = vecLook:cross(vecSound)
                    local fPan = math.max(-fPanLimit, math.min(-cross.z, fPanLimit))
                    
                    local fDistDiff = fMaxDistance - fMinDistance;
                    
                    -- Transform e^-x to suit our sound
                    local fVolume
                    if (fDistance <= fMinDistance) then
                        fVolume = fMaxVol
                    elseif (fDistance >= fMaxDistance) then
                        fVolume = 0.0
                    else
                        fVolume = math.exp(-(fDistance - fMinDistance) * (5.0 / fDistDiff)) * fMaxVol
                    end

                    setSoundPan(v, fPan)
                    -- Additionally add a compressor effect if there's occlusion (something in the way of line of sight) (todo: make the volume change smoother)
                    if isLineOfSightClear(localPlayer.position, vecSoundPos, true, true, false, true, false, true, true, localPlayer) then -- line of sight clear
                        setSoundVolume(v, fVolume)
                        setSoundEffectEnabled(v, "compressor", false)

                        if voiceEnable[v] then 
                            table.insert(voiceData, '('..(getElementData(v, 'ID') or '???')..') - Próximo')
                        end
                    else
                        local fVolume = fVolume * 0.5 -- reduce volume by half
                        local fVolume = fVolume < 0.01 and 0 or fVolume -- treshold of 0.01 (anything below is forced to 0)
                        setSoundVolume(v, fVolume)
                        setSoundEffectEnabled(v, "compressor", true)
                    end
                else
                    if (not inRadioWithMe and not inPhoneWithMe) then 
                        local fVolume = 0 
                        local fVolume = fVolume * 0.5 -- reduce volume by half
                        local fVolume = fVolume < 0.01 and 0 or fVolume -- treshold of 0.01 (anything below is forced to 0)
                        setSoundVolume(v, fVolume)
                        setSoundEffectEnabled(v, "compressor", true)
                    end
                end
            end
        end
    end
, false)

local x, y = guiGetScreenSize()
local startX, startY =  x - 10, y - 319
addEventHandler('onClientRender', root, 
    function()
        for i, v in ipairs(voiceData) do 
            dxDrawText(v, startX - dxGetTextWidth(v, 1, "default", true), startY + (19 * (i - 1)), 0, 0, tocolor(255, 255, 255, alpha), 1, "default", 'left', 'top', false, false, false, false)
        end
    end
)

addEventHandler("onClientElementStreamIn", root,
    function ()
        if source:getType() == "player" then
            triggerServerEvent("proximity-voice::broadcastUpdate", localPlayer, getElementsByType("player", root))
        end
    end
)

addEventHandler("onClientElementStreamOut", root,
    function ()
        --if source:getType() == "player" then
        --    triggerServerEvent("proximity-voice::broadcastUpdate", localPlayer, getElementsByType("player", root, true))
        --    setSoundVolume(source, 0)
        --    setSoundPan(source, 0)
        --end
    end
)

addEventHandler("onClientResourceStart", resourceRoot,
    function ()
        triggerServerEvent("proximity-voice::broadcastUpdate", localPlayer, getElementsByType("player", root)) -- request server to start broadcasting voice data once the resource is loaded (to prevent receiving voice data while this script is still downloading)
    end
, false)

addEventHandler('onClientPlayerVoiceStart', root,
    function ()
    voiceEnable[source] = true 
    end
)

addEventHandler('onClientPlayerVoiceStop', root,
    function ()
        voiceEnable[source] = nil 
    end
)