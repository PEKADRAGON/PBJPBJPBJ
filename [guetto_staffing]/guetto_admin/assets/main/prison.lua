local client = {
    visible = false
};

local function onDrawPrison ()
    if data then 
        local realTime = math.floor(interpolateBetween(data.tempo, 0, 0, 0, 0, 0, ((getTickCount()-data.tickTime)/(data.tempo*1000)), "Linear"))
        
        if realTime == 0 then 
            triggerServerEvent("squady.removePlayerFromPrison", localPlayer, localPlayer)
            setTimer(function()
                data = nil
            end, 1000, 1)
        end

        dxDrawImageSpacing(423, 722, 511, 167, 5, "assets/images/bg_prison.png", 0, 0, 0, tocolor(255, 255, 255, alpha))

        dxDrawText("PUNIDO", 481, 743, 74, 30, tocolor(255, 255, 255, alpha), 1.0, getFont("medium", 10))
        dxDrawText("Você sofreu uma punição e deve aguardar.", 441, 776, 74, 30, tocolor(187, 187, 187, alpha), 1.0, getFont("regular", 9))
        dxDrawText("Motivo:", 444, 818, 74, 30, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10))
        dxDrawText(data.motivo, 515, 818, 74, 30, tocolor(141, 106, 240, alpha), 1.0, getFont("regular", 10))
        dxDrawText(formatSeconds(realTime), 860, 739, 56, 30, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "right", "top")

        setElementData(localPlayer, "time.left.punish", realTime)

        local pos = {getElementPosition(localPlayer)}

        if getDistanceBetweenPoints3D(pos[1], pos[2], pos[3], config.punishment.prison.pos[1], config.punishment.prison.pos[2], config.punishment.prison.pos[3]) > 10 then 
            setElementPosition(localPlayer, config.punishment.prison.pos[1], config.punishment.prison.pos[2], config.punishment.prison.pos[3])
        end
    end
end

registerEvent("squady.punishRender", root, function(time, reason)
    if time and reason then 
        data = {
            tickTime = getTickCount();
            tempo = time;
            motivo = reason;
        };
        client.visible = true
        addEventHandler("onClientRender", root, onDrawPrison)
    else
        data = nil
        client.visible = false
        removeEventHandler("onClientRender", root, onDrawPrison)
    end
end)

function formatSeconds (segundos)
    local minutos = math.floor(segundos / 60)
    local segundosRestantes = segundos % 60
    return string.format("%02d:%02d", minutos, segundosRestantes)
end