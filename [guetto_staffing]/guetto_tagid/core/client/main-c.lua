--| Var's

nearElements = {}
local animations = {}
local duty = {}
local show = false;

addEventHandler('onClientKey', root, function(button, state)
    if button == 'F9' then 
        if state then 
            if not show then 
                show = true 
            end
        else
            if show then 
                show = false 
            end
        end
    end
end)

--| Async

Async:setPriority("high")

--| Font's

ps_regular = dxCreateFont("core/assets/fonts/ps_regular.ttf", sx*20, false, "cleartype")

--| Render

function renderNames()
    if (getElementData(localPlayer, "streaming")) then 
        return false 
    end

    if not show then 
        return 
    end

    if not isWallEnabled[localPlayer] then 
        local cx, cy, cz = getCameraMatrix()
        if nearElements and (#nearElements ~= 0) then 
            
            for i = 1, #nearElements do 
                local element = nearElements[i]
                if isElement(element) and isElementStreamedIn(element) then 

                    if (element ~= localPlayer) then  
                        if (getElementAlpha(element) > 0) then 
                            local vx, vy, vz = getPedBonePosition(element, 4)
                            local distance = getDistanceBetweenPoints3D(cx, cy, cz, vx, vy, vz)
                            if (distance < config["names"]["drawDistance"]) and isLineOfSightClear(cx, cy, cz, vx, vy, vz, true, false, false) then
                                local x, y = getScreenFromWorldPosition(vx, vy, vz + config["names"]["scale"]["height"])
                                if x and y then

                                    local role = getElementData(element, "FS:adminDuty")
                                    local id = getElementData(element, config["elements"]["id"]) or 0

                                    if role then 

                                        if animations[element] then 
                                            
                                            if not duty[element] then 
                                                duty[element] = {
                                                    position = 30,
                                                    tick = getTickCount(),
                                                    action = true,
                                                }
                                            end

                                            if not duty[element]["action"] then 
                                                local old = duty[element]
                                                duty[element] = {
                                                    position = old["smooth"],
                                                    tick = getTickCount(),
                                                    action = true,
                                                }
                                            end
                                            duty[element]["smooth"] = interpolateBetween(duty[element]["position"], 0, 0, 30, 0, 0, (getTickCount() - duty[element]["tick"]) / 400, "OutQuad")

                                            if not config["roles"][role] then
                                                return
                                            end
                                            if not config["roles"][role]["isJob"] then
                                                local textSize = dxGetTextWidth(simulateClear( getPlayerName(element) ).. " #"..config["roles"][role]["color"].."("..config["roles"][role]["name"]..") ("..id..")", (config["names"]["scale"]["font"]/sx), ps_regular, true)
                                                _dxDrawText(simulateClear(  simulateClear( getPlayerName(element) ) ).. " #"..config["roles"][role]["color"].."("..config["roles"][role]["name"]..") #FFFFFF("..id..")", x - ((sx*textSize) / 2), y - sy*10, sx*textSize, sy*30, tocolor(255, 255, 255, 255), config["names"]["scale"]["font"], ps_regular, "left", "top", false, false, false, true)
                                            else
                                                local textSize = dxGetTextWidth("#"..config["roles"][role]["color"]..""..config["roles"][role]["name"].."", (config["names"]["scale"]["font"]/sx), ps_regular, true)
                                                _dxDrawText("#"..config["roles"][role]["color"]..""..config["roles"][role]["name"].."", x - ((sx*textSize) / 2), y - sy*10, sx*textSize, sy*30, tocolor(255, 255, 255, 255), config["names"]["scale"]["font"], ps_regular, "left", "top", false, false, false, true)
                                            end
                                            
                                        else

                                            if not duty[element] then 
                                                duty[element] = {
                                                    position = 0,
                                                    tick = getTickCount(),
                                                    action = false,
                                                }
                                            end

                                            if duty[element]["action"] then 
                                                local old = duty[element]
                                                duty[element] = {
                                                    position = old["smooth"],
                                                    tick = getTickCount(),
                                                    action = false,
                                                }
                                            end
                                            duty[element]["smooth"] = interpolateBetween(duty[element]["position"], 0, 0, 0, 0, 0, (getTickCount() - duty[element]["tick"]) / 400, "OutQuad")

                                            if (config["roles"][role]) then 
                                                if not config["roles"][role]["isJob"] then
                                                    local textSize = dxGetTextWidth(simulateClear( getPlayerName(element) ).. " #"..config["roles"][role]["color"].."("..config["roles"][role]["name"]..") ("..id..")", (config["names"]["scale"]["font"]/sx), ps_regular, true)
                                                    _dxDrawText(simulateClear( getPlayerName(element) ).. " #"..config["roles"][role]["color"].."("..config["roles"][role]["name"]..") #FFFFFF("..id..")", x - ((sx*textSize) / 2), y - sy*10, sx*textSize, sy*30, tocolor(255, 255, 255, 255), config["names"]["scale"]["font"], ps_regular, "left", "top", false, false, false, true)
                                                else
                                                    local textSize = dxGetTextWidth("#"..config["roles"][role]["color"]..""..config["roles"][role]["name"].."", (config["names"]["scale"]["font"]/sx), ps_regular, true)
                                                    _dxDrawText("#"..config["roles"][role]["color"]..""..config["roles"][role]["name"].."", x - ((sx*textSize) / 2), y - sy*10, sx*textSize, sy*30, tocolor(255, 255, 255, 255), config["names"]["scale"]["font"], ps_regular, "left", "top", false, false, false, true)
                                                end
                                            end
                                            
                                        end

                                    else

                                        if config["names"]["showName"] then 
                                            local textSize = dxGetTextWidth(simulateClear( getPlayerName(element) ).. " ("..id..")", (config["names"]["scale"]["font"]/sx), ps_regular, false)
                                            if (getElementHealth(element) <= 1) then

                                                if not animations[element] then 
                                                    animations[element] = {}
                                                end

                                                if not animations[element]["flashing"] then
                                                    animations[element]["flashing"] = {
                                                        tick = getTickCount(),
                                                        r, g, b = 255, 255, 255,
                                                    }
                                                end
                                                
                                                if (getTickCount() - animations[element]["flashing"]["tick"]) >= 800 then 
                                                    animations[element]["flashing"]["tick"] = getTickCount()
                                                end
                                                
                                                if (animations[element]["flashing"]["r"] == 241) then 
                                                    animations[element]["flashing"]["r"], animations[element]["flashing"]["g"], animations[element]["flashing"]["b"] = interpolateBetween(241, 107, 107, 255, 255, 255, (getTickCount() - animations[element]["flashing"]["tick"]) / 800, "OutQuad")
                                                else 
                                                    animations[element]["flashing"]["r"], animations[element]["flashing"]["g"], animations[element]["flashing"]["b"] = interpolateBetween(241, 107, 107, 255, 255, 255, (getTickCount() - animations[element]["flashing"]["tick"]) / 800, "OutQuad")
                                                end

                                                _dxDrawText(simulateClear( removeHex(getPlayerName(element)) ).. " ("..id..")", x - ((sx*textSize) / 2), y - sx*10, sx*textSize, sy*30, tocolor(animations[element]["flashing"]["r"], animations[element]["flashing"]["g"], animations[element]["flashing"]["b"], 255), config["names"]["scale"]["font"], ps_regular, "left", "top")
                                            else
                                                _dxDrawText(simulateClear( removeHex(getPlayerName(element)) ).. " ("..id..")", x - ((sx*textSize) / 2), y - sx*10, sx*textSize, sy*30, tocolor(255, 255, 255, 255), config["names"]["scale"]["font"], ps_regular, "left", "top")
                                            end
                                        else
                                            local textSize = dxGetTextWidth("("..id..")", (config["names"]["scale"]["font"]/sx), ps_regular, false)
                                            if (getElementHealth(element) < 2) then 

                                                if not animations[element] then 
                                                    animations[element] = {}
                                                end

                                                if not animations[element]["flashing"] then
                                                    animations[element]["flashing"] = {
                                                        tick = getTickCount(),
                                                        r, g, b = 255, 255, 255,
                                                    }
                                                end
                                                
                                                if (getTickCount() - animations[element]["flashing"]["tick"]) >= 800 then 
                                                    animations[element]["flashing"]["tick"] = getTickCount()
                                                end
                                                
                                                if (animations[element]["flashing"]["r"] == 241) then 
                                                    animations[element]["flashing"]["r"], animations[element]["flashing"]["g"], animations[element]["flashing"]["b"] = interpolateBetween(241, 107, 107, 255, 255, 255, (getTickCount() - animations[element]["flashing"]["tick"]) / 800, "OutQuad")
                                                else 
                                                    animations[element]["flashing"]["r"], animations[element]["flashing"]["g"], animations[element]["flashing"]["b"] = interpolateBetween(241, 107, 107, 255, 255, 255, (getTickCount() - animations[element]["flashing"]["tick"]) / 800, "OutQuad")
                                                end
                                                
                                                _dxDrawText("("..id..")", x - ((sx*textSize) / 2), y - sy*10, sx*textSize, sy*30, tocolor(animations[element]["flashing"]["r"], animations[element]["flashing"]["g"], animations[element]["flashing"]["b"], 255), config["names"]["scale"]["font"], ps_regular, "left", "top")
                                            else
                                                _dxDrawText("("..id..")", x - ((sx*textSize) / 2), y - sy*10, sx*textSize, sy*30, tocolor(255, 255, 255, 255), config["names"]["scale"]["font"], ps_regular, "left", "top")
                                            end
                                        end
                                        
                                    end
                                    
                                    --| When player typing identifier
                                    if getElementData(element, "isPlayerTyping") then 

                                        if not animations[element] then 
                                            animations[element] = {}
                                        end

                                        if not animations[element]["typing"] then 

                                            animations[element]["typing"] = {
                                                text = ".",
                                                tick = getTickCount()
                                            }

                                        else

                                            if (getTickCount() - animations[element]["typing"]["tick"]) >= 400 then 
                                                
                                                if #animations[element]["typing"]["text"] ~= 3 then 
                                                    animations[element]["typing"]["text"] = animations[element]["typing"]["text"].."."
                                                else
                                                    animations[element]["typing"]["text"] = "."
                                                end
                                                animations[element]["typing"]["tick"] = getTickCount()

                                            end 

                                            local textSize = dxGetTextWidth(animations[element]["typing"]["text"], ((config["names"]["scale"]["font"] + 0.2)/sx), ps_regular, true)
                                            _dxDrawText(animations[element]["typing"]["text"], x - ((sx*textSize) / 2), (y - sy*10) - sy*30, sx*textSize, sy*30, tocolor(255, 255, 255, 255), (config["names"]["scale"]["font"] + 0.2), ps_regular, "left", "top")
                                            dxSetBlendMode("add")
                                            _dxDrawImage(x - ((sy*22) / 2), (y - sy*10) - sy*30, sx*22, sy*14, Images["keyboard"])
                                            dxSetBlendMode("blend")
                                            
                                        end 
                                        
                                    --| Player idleTime identifier
                                    elseif isPlayerIdle[element] then 
                                        
                                        if not animations[element] then 
                                            animations[element] = {}
                                        end
                                        
                                        if not animations[element]["idle"] then 
                                            
                                            animations[element]["idle"] = {
                                                tick = getTickCount()
                                            }
                                            
                                        else
                                            
                                            local textSize = dxGetTextWidth(formatSeconds( (getTickCount() - animations[element]["idle"]["tick"]) / 1000), ((config["names"]["scale"]["font"] - 0.1)/sx), ps_regular, true)
                                            _dxDrawText(formatSeconds( (getTickCount() - animations[element]["idle"]["tick"]) / 1000), x - ((sx*textSize) / 2), (y - sy*10) - sy*20, sx*textSize, sy*30, tocolor(255, 255, 255, 255), (config["names"]["scale"]["font"] - 0.1), ps_regular, "left", "top")
                                            dxSetBlendMode("add")
                                            _dxDrawImage(x - ((sx*textSize) / 2) + (sx*textSize) + sx*3, (y - sy*10) - sy*20, sx*22.6, sy*8.6, Images["afk"])
                                            dxSetBlendMode("blend")
                                            
                                        end 

                                    elseif getElementData(element, "isPlayerTalking") then 

                                        if not animations[element] then 
                                            animations[element] = {}
                                        end

                                        if not animations[element]["talking"] then 

                                            animations[element]["talking"] = {
                                                tick = getTickCount(),
                                                voices = {}
                                            }

                                        else

                                            Async:iterate(1, 7, function(voice)
                                                
                                                if animations[element] and animations[element]["talking"] and animations[element]["talking"]["voices"] then

                                                    if not animations[element]["talking"]["voices"][voice] then 
                                                        animations[element]["talking"]["voices"][voice] = {}
                                                    else

                                                        if not animations[element]["talking"]["voices"][voice]["tick"] then 
                                                            animations[element]["talking"]["voices"][voice] = {
                                                                tick = getTickCount(),
                                                                first = math.random(5, 18),
                                                                last = math.random(5, 18),
                                                            }
                                                        else
                                                            if (getTickCount() - animations[element]["talking"]["voices"][voice]["tick"]) >= 200 then 
                                                                local old = animations[element]["talking"]["voices"][voice]
                                                                animations[element]["talking"]["voices"][voice] = {
                                                                    tick = getTickCount(),
                                                                    first = old["last"],
                                                                    last = math.random(5, 18),
                                                                }
                                                            end 
                                                        end
                                                        
                                                        animations[element]["talking"]["voices"][voice]["size"] = interpolateBetween(animations[element]["talking"]["voices"][voice]["first"], 0, 0, animations[element]["talking"]["voices"][voice]["last"], 0, 0, (getTickCount() - animations[element]["talking"]["voices"][voice]["tick"]) / 200, "OutQuad")
                                                        _dxDrawRectangle((x - (sx*28/2)) + (voice * (sx*4)), ((y - (sy*10)) - (sy*10)) - ((sy*animations[element]["talking"]["voices"][voice]["size"]) / 2), sx*2, sy*animations[element]["talking"]["voices"][voice]["size"], tocolor(255, 255, 255, 250), false)

                                                    end

                                                end
                                                
                                            end)
                                            
                                        end 

                                    elseif getElementData(element, 'Desmaiado') then  

                                        if not animations[element] then 
                                            animations[element] = {}
                                        end

                                        if not animations[element]["vitalSing"] then 
                                            animations[element]["vitalSing"] = {
                                                start = getTickCount(),
                                                tick = getTickCount(),
                                                showWidth = 0,
                                            }
                                        end

                                        if (getTickCount() - animations[element]["vitalSing"]["tick"]) >= 2000 then 
                                            animations[element]["vitalSing"]["tick"] = getTickCount()
                                        end
                                    
                                        animations[element]["vitalSing"]["showWidth"] = interpolateBetween(0, 0, 0, 80, 0, 0, (getTickCount() - animations[element]["vitalSing"]["tick"]) / 2000, "Linear")
                                        _dxDrawImageSection(x - ((sx*80)/2), (y - sy*10) - sy*55, (sx*80)/80*animations[element]["vitalSing"]["showWidth"], sx*31, 0, 0, 114/114*animations[element]["vitalSing"]["showWidth"], 31, Images["vitalSign"], 0, 0, 0, tocolor(244, 107, 107, 180), false)
                                        
                                        local textSize = dxGetTextWidth(formatSeconds( (getTickCount() - animations[element]["vitalSing"]["start"]) / 1000), ((config["names"]["scale"]["font"] - 0.2)/sx), ps_regular, true)
                                        _dxDrawText(formatSeconds( (getTickCount() - animations[element]["vitalSing"]["start"]) / 1000), x - ((sx*textSize) / 2), (y - sy*10) - sy*15, sx*textSize, sy*30, tocolor(255, 255, 255, 255), (config["names"]["scale"]["font"] - 0.2), ps_regular, "left", "top")

                                    else
                                        animations[element] = nil 
                                    end
                                    
                                end
                            end
                        end

                    end
                else
                    table.remove(nearElements, i)
                end

            end

            --| Identify player typing
            if isChatBoxInputActive() then 
                setElementData(localPlayer, "isPlayerTyping", true)
            else
                if getElementData(localPlayer, "isPlayerTyping") then 
                    setElementData(localPlayer, "isPlayerTyping", nil)
                end
            end

            --| Identify player talking
            if getKeyState(getKeyBoundToCommand("voiceptt")) then 
                setElementData(localPlayer, "isPlayerTalking", true)
            else
                if getElementData(localPlayer, "isPlayerTalking") then 
                    setElementData(localPlayer, "isPlayerTalking", nil)
                end
            end
        end
    end
end
addEventHandler("onClientRender", root, renderNames)

--| Event's

function isPlayerInNearElements(player)
    for _, element in ipairs(nearElements) do
        if element == player then
            return true
        end
    end
    return false
end

addEventHandler("onClientElementStreamIn", root, function()
    if source and isElement(source) and (getElementType(source) == "player") then
        if not isPlayerInNearElements(source) then
            setPlayerNametagShowing(source, false)
            nearElements[#nearElements + 1] = source
        end
    end
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
    local players = getElementsByType("player")
    for i = 1, #players do
        if players[i] and isElement(players[i]) and isElementStreamedIn(players[i]) then 
            setPlayerNametagShowing(players[i], false)
            nearElements[ #nearElements + 1 ] = players[i]
        end
    end
end)

setPedTargetingMarkerEnabled(false)