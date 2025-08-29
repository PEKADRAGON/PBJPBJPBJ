local instance = {}

local x, y = (screen.x / 2) + respc(303), (screen.y - respc(418)) / 2

function instance.render ()
    CreateThread(function()
        while (instance.visible) do

            -- Cursor Update 
            cursorUpdate()

            -- Background
            dxDrawRoundedRectangle("background", x, y, respc(303), respc(418), tocolor(17, 17, 17, 0.96 * 255), 9, false)

            -- Title 
            dxDrawText("STATUS DA PLANTAÇÃO", x + respc(59), y + respc(30), respc(186), respc(16), tocolor(209, 209, 209, 255), 1, exports["guetto_assets"]:dxCreateFont("bold", 18), "center", "center")
            
            -- Sub Background´s
            dxDrawRoundedRectangle("subBackground:1", x + respc(31), y + respc(68), respc(244), respc(95), tocolor(101, 101, 101, 0.12 * 255), 6, false)
            dxDrawRoundedRectangle("subBackground:2", x + respc(31), y + respc(172), respc(244), respc(95), tocolor(101, 101, 101, 0.12 * 255), 6, false)

            -- Icon´s Sub Background
            dxDrawImage(x + respc(50), y + respc(88), respc(50), respc(56), "core/assets/icons/umidade.png", 0, 0, 0, tocolor(255, 255, 255, 255))
            dxDrawImage(x + respc(46), y + respc(189), respc(58), respc(59), "core/assets/icons/crescimento.png", 0, 0, 0, tocolor(255, 255, 255, 255))
            
            -- Text´s Sub Background

            dxDrawText("Umidade", x + respc(114), y + respc(88), respc(77), respc(24), tocolor(200, 200, 200, 255), 1, exports["guetto_assets"]:dxCreateFont("regular", 20), "left", "top")
            dxDrawText("Crescimento", x + respc(114), y + respc(192), respc(77), respc(24), tocolor(200, 200, 200, 255), 1, exports["guetto_assets"]:dxCreateFont("regular", 20), "left", "top")

            -- Button´s 

            dxDrawRoundedRectangle("button:1", x + respc(31), y + respc(281), respc(244), respc(49), isCursorOnElement(x + respc(31), y + respc(281), respc(244), respc(49)) and tocolor(217, 217, 217, 0.20 * 255) or tocolor(217, 217, 217, 0.12 * 255), 4, false)
            dxDrawRoundedRectangle("button:2", x + respc(31), y + respc(339), respc(244), respc(49), isCursorOnElement(x + respc(31), y + respc(339), respc(244), respc(49)) and tocolor(217, 217, 217, 0.20 * 255) or tocolor(217, 217, 217, 0.12 * 255), 4, false)

            -- Detail´s 
            if instance.element and isElement(instance.plant) then 
                local details = (getElementData(instance.element, "Guetto.VaseDeatails") or false)
                if details then 
                    local x2, y2, z2 = getElementPosition(instance.element);
                    local x3, y3, z3 = getElementPosition(instance.plant);

                    local floorPositions = (z2-z3)
                    local calcPositions = (100-((floorPositions*10)/30*100))

                    dxDrawText(math.floor(calcPositions).."%", x + respc(114), y + respc(217), respc(99), respc(31), math.floor(calcPositions) == 100 and tocolor(132, 203, 98, 255) or tocolor(121, 121, 121, 255), 1, exports["guetto_assets"]:dxCreateFont("bold", 23), "left", "center")
                    dxDrawText(math.floor(details.shower).."%", x + respc(114), y + respc(113), respc(99), respc(31), tocolor(121, 121, 121, 255), 1, exports["guetto_assets"]:dxCreateFont("bold", 23), "left", "center")
               
                    -- Button´s Text 

                    dxDrawText(math.floor(calcPositions) == 100 and "COLETAR" or "EM CRESCIMENTO", x + respc(31), y + respc(281), respc(244), respc(49), tocolor(184, 184, 184, 255), 1, exports["guetto_assets"]:dxCreateFont("bold", 19), "center", "center")
                    dxDrawText("IRRIGAÇÃO", x + respc(31), y + respc(339), respc(244), respc(49), tocolor(184, 184, 184, 255), 1, exports["guetto_assets"]:dxCreateFont("bold", 19), "center", "center")
                end
            end 
            coroutine.yield()
        end
    end)
end;

function instance.click (button, state)
    if button == "left" and state == "down" then 
        if isCursorOnElement(x + respc(31), y + respc(281), respc(244), respc(49)) then  -- Plantação
            if instance.element and isElement( instance.element ) and isElement(instance.plant) then
                local x2, y2, z2 = getElementPosition(instance.element);
                local x3, y3, z3 = getElementPosition(instance.plant);
                triggerServerEvent("onPlayerRequestPlantation", resourceRoot, instance.element, instance.plant)
                instance.toggle(false)
            end
        elseif isCursorOnElement(x + respc(31), y + respc(339), respc(244), respc(49)) then  -- Irrigação
            if instance.element and isElement(instance.element) then 
                local details = (getElementData(instance.element, "Guetto.VaseDeatails") or false)
                if details then 
                    triggerServerEvent("onPlayerRequestIrrigation", resourceRoot, instance.element, instance.plant)
                end
            end
        end
    end
end

function instance.toggle (state)
    if state and not instance.visible then 
        instance.visible = true 
        
        showCursor(true)
        showChat(false)

        addEventHandler("onClientClick", root, instance.click)
        instance.render()
    elseif not state and instance.visible then 
        instance.visible = false 

        showCursor(false)
        showChat(true)

        removeEventHandler("onClientClick", root, instance.click)
    end
end

createEvent("onPlayerShowDetailedPlantation", resourceRoot, function (object, plant)
    instance.toggle(true)

    instance.element = object;
    instance.plant = plant;
end)

addEventHandler("onClientKey", root, function(button, state)
    if (button == "backspace" and state) then 
        instance.toggle(false)
    end
end)

addEventHandler("onClientClick", root, function(button, state, _, _, _, _, _, element)
    if (button == "right" and state == "down") then 
        if (isElement(element) and getElementType(element) == "object" and (getElementData(element, "Guetto.VaseDeatails") or false)) then 
            local x, y, z = getElementPosition(element);
            local x2, y2, z2 = getElementPosition(localPlayer);
            if (getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) <= 5) then 
                local data = getElementData(element, "Guetto.VaseDeatails") or {}
            end
        end
    end
end)