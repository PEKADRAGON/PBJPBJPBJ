local data;
local state = false;

local function onSedexDrawOrders()
    dxDrawText((data[1]).."/"..(data[2]), 580, 0, 200, 100, tocolor(255, 255, 255, 255), 1.5, "default", "center", "center", false, false, false, false, false)
end

addEvent("Sedex >> Show Orders", true);
addEventHandler("Sedex >> Show Orders", root, 
    function(state)
        if (state) then
            addEventHandler("onClientRender", root, onSedexDrawOrders);
            state = true;
        else
            removeEventHandler("onClientRender", root, onSedexDrawOrders);
            state = false;
        end
    end
);

addEvent("Sedex >> Update Orders", true);
addEventHandler("Sedex >> Update Orders", root, 
    function(infos)
        data = infos;
    end
);

-----

local thePed;
local pedData = {};

addEventHandler("onClientRender", root, 
    function()
        local mX, mY, mZ = getCameraMatrix();
        local bX, bY, bZ = getPedBonePosition(thePed, 4);
        if (getDistanceBetweenPoints3D(mX, mY, mZ, bX, bY, bZ) <= 15) then
            if (isLineOfSightClear(mX, mY, mZ, bX, bY, bZ, true, false, false)) then
                local wX, wY = getScreenFromWorldPosition(bX, bY, bZ + 0.3);
                if (wX and wY) then
                    dxDrawText(system['attributes']['ped'].name, wX - 20, wY - 50, 50, 50, tocolor(255, 255, 255, 255), 1.3, "default", "center", "center", false, false, false, true, false)		
                end
            end
        end
    end
);

local function onCancelPedDamage()
    return cancelEvent();
end

addEventHandler("onClientClick", root, 
    function(button, state, _, _, _, _, _, clickedWorld)
        if (button == "left" and state == "down") then
            if (clickedWorld and isElement(clickedWorld) and getElementType(clickedWorld) == "ped") then
                if (clickedWorld == thePed) then
                    local pX, pY, pZ = getElementPosition(localPlayer); 
                    local pedX, pedY, pedZ = getElementPosition(thePed);
                    if (getDistanceBetweenPoints3D(pX, pY, pZ, pedX, pedY, pedZ) <= 3) then
                        if (isLineOfSightClear(pX, pY, pZ, pedX, pedY, pedZ, true, false, false)) then
                            if (getElementData(localPlayer, "Emprego") ~= "Sedex") then 
                                return geral.cNotify(localPlayer, "Você não trabalha aqui!", "error");
                            end
                            triggerServerEvent("Sedex >> Ped interaction", localPlayer, localPlayer, pedData[thePed]);
                        end
                    else
                        geral.cNotify(localPlayer, "Você está muito distante do NPC!", "info");
                    end
                end
            end
        end
    end
);

for k, v in ipairs(system['attributes'].positions) do
    thePed = createPed(system['attributes']['ped'].skin, v['pos'][1], v['pos'][2], v['pos'][3], v.rot);
    addEventHandler("onClientPedDamage", thePed, onCancelPedDamage);
    setElementFrozen(thePed, true);
    pedData[thePed] = k;

    if (system['attributes']['ped']['animation'].use) then
        setPedAnimation(thePed, system['attributes']['ped']['animation'].block, system['attributes']['ped']['animation'].anim, -1, true);
    end 
end
