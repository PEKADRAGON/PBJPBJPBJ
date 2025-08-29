local interface = {}
local cache = {}

interface["animations"] = {
    ["alpha"] = {0, 0, 0};
    ["progress"] = {0, 0, 0};
}

local Timer = false;

function draw ( )
    if Timer and isTimer(Timer) then 

        local fade = interpolateBetween (interface["animations"]["alpha"][1], 0, 0, interface["animations"]["alpha"][2], 0, 0, (getTickCount ( ) - interface["animations"]["alpha"][3]) / 400, "Linear")
        local progress = interpolateBetween(interface["animations"]["progress"][1], 0, 0, interface["animations"]["progress"][2], 0, 0, (getTickCount() - interface["animations"]["progress"][3]) / cache["time"] or 60000, "Linear")
        local current = (string.format("%4d", tostring(getTimerDetails(Timer)/1000)))

        dxDrawImage(713, 823, 494, 88, "assets/images/fundo.png", 0, 0, 0, tocolor(255, 255, 255, fade))
    
        dxDrawText(cache["title"] or "", 809, 834, 128, 23, tocolor(217, 217, 217, fade), 1, getFont("bold", 15), "left", "top")
        dxDrawText(cache["description"] or "", 809, 857, 243, 18, tocolor(120, 120, 120, fade), 1, getFont("regular", 14), "left", "top")
    
        dxDrawImage(809, 889, 264, 5, "assets/images/rectangle-progress.png", 0, 0, 0, tocolor(45, 45, 45, fade)) 
        dxDrawImage(809, 889, progress, 5, "assets/images/rectangle-progress.png", 0, 0, 0, tocolor(193, 159, 114, fade)) 
    
        if cache["icon"] and fileExists("assets/icons/"..(cache["icon"])..".png") then
            dxDrawImage(743, 851, 28, 28, "assets/icons/"..(cache["icon"])..".png", 0, 0, 0, tocolor(255, 255, 255, fade))
        end
    
        dxDrawText(os.date("%M:%S", current), 1095, 880, 33, 18, tocolor(120, 120, 120, fade), 1, getFont("regular", 15), "left", "top")
    end

end

local function managementInterface ( ... )
    local arguments = ...
    if arguments["state"] == true then 
        if not isEventHandlerAdded("onClientRender", root, draw) then 
            interface["animations"]["alpha"][1], interface["animations"]["alpha"][2], interface["animations"]["alpha"][3] = 0, 255, getTickCount()
            interface["animations"]["progress"][1], interface["animations"]["progress"][2], interface["animations"]["progress"][3] = 0, 264, getTickCount()
            addEventHandler("onClientRender", root, draw) 
        end
    elseif arguments["state"] == false then 
        if isEventHandlerAdded("onClientRender", root, draw) then 
            removeEventHandler("onClientRender", root, draw) 
        end
    end
end

addEvent("guetto.progress", true)
addEventHandler("guetto.progress", resourceRoot, function ( ... )
    local arguments = ...

    cache["title"] = arguments["title"]
    cache["description"] = arguments["description"]
    cache["icon"] = arguments["icon"]
    cache["time"] = arguments["time"]

    managementInterface({state = true})

    Timer = setTimer ( function ( )
        managementInterface({state = false})
    end, cache["time"], 1)
end)