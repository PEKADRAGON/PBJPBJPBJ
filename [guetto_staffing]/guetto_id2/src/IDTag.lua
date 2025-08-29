local drawDistance = 25
g_StreamedInPlayers = {}
CorTag = tocolor(255, 255, 255)
local font = dxCreateFont('src/font.ttf', 10)

ver = true 
function onClientRender()
    local cx, cy, cz, lx, ly, lz = getCameraMatrix()
    for k, player in pairs(g_StreamedInPlayers) do
        if isElement(player) and isElementStreamedIn(player) then
            local vx, vy, vz = getPedBonePosition(player, 4)
            local dist = getDistanceBetweenPoints3D(cx, cy, cz, vx, vy, vz)
            if dist < drawDistance and isLineOfSightClear(cx, cy, cz, vx, vy, vz, true, false, false) then
                local x, y = getScreenFromWorldPosition(vx, vy, vz + 0.3)
                if x and y then
                    local ID = getElementData(player, "ID") or "N/A"
                    local w = dxGetTextWidth(ID, 0.1, font)
                    local h = dxGetFontHeight(1, font)
                    if ver == true then 
                        if getElementData(player, 'Samu') == true then 
                            dxDrawText(""..ID.."", x - 1 - w / 1, y - 1 - h - 12, w, h, tocolor(255, 0, 0, 255), 1.20, font, "left", "top", false, false, false, false, false)		
                        else
                            dxDrawText(""..ID.."", x - 1 - w / 1, y - 1 - h - 12, w, h, CorTag, 1.20, font, "left", "top", false, false, false, false, false)		
                        end
                    end
                end
            end
        else
            table.remove(g_StreamedInPlayers, k)
        end
    end
end
addEventHandler("onClientRender", root, onClientRender)

function onClientElementStreamIn()
    if getElementType(source) == "player" and source ~= getLocalPlayer() then
        setPlayerNametagShowing(source, false)
        table.insert(g_StreamedInPlayers, source)
    end
end
addEventHandler("onClientElementStreamIn", root, onClientElementStreamIn)

function onClientResourceStart(startedResource)
    visibleTick = getTickCount()
    counter = 0
    local players = getElementsByType("player")
    for k, v in pairs(players) do
        if isElementStreamedIn(v) and v ~= getLocalPlayer() then
            setPlayerNametagShowing(v, false)
            table.insert(g_StreamedInPlayers, v)
        end
    end
end
addEventHandler("onClientResourceStart", resourceRoot, onClientResourceStart)
