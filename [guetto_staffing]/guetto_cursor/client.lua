local sx, sy = guiGetScreenSize()
local zoom = 1920 / sx
local rot = 0 
--[[
Autor: AmLotte
Discord: AmLotte#8004
]]--
bindKey("m", "down", function()
    if isCursorShowing(localPlayer) == true then 
        removeEventHandler("onClientRender", root, gui_click)
        showCursor(false)
        if isTimer(XD1) then 
            killTimer(XD1)
        elseif isTimer(XD2) then 
            killTimer(XD2)
        end
    else
        addEventHandler("onClientRender", root, gui_click)
        showCursor(true)
        timery()
    end
end)

function timery ()
    if isCursorShowing(localPlayer) == true then  -- tak wiem mogłem zrobić to na getTickCount. ~AmLotte
        XD1= setTimer( function ()
            rot = rot + 5
            if rot > 1200 then 
                killTimer(XD1)
                XD2= setTimer( function ()
                    rot = rot - 5 
                    if rot < 0 then 
                        killTimer(XD2)
                        timery()
                    end
                end, 1,0)
            end
        end, 1, 0)
    end
end

function gui_click (el,md)
    if el ~= localPlayer and md then return end 
    cursor = {getCursorPosition()}
    dxDrawImage(cursor[1]*sx-11 / zoom, cursor[2]*sy-8 / zoom, 30 / zoom, 30 / zoom, "img/circle.png", rot+0, 0, 0, tocolor(255, 255, 255, 0), false)
    dxDrawImage(cursor[1]*sx-14 / zoom, cursor[2]*sy-11 / zoom, 37 / zoom, 37 / zoom, "img/circle.png", rot+130, 0, 0, tocolor(255, 255, 255, 255), false)
end 