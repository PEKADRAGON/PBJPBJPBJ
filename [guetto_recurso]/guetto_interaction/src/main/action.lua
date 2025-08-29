local isCarred = {}
local playerAnimation = {}
local bonePositions = {

    ['cuffed'] = {

        [32] = {26.57374382019, 61.337575733622, 59.206573486328},
        [33] = {27.843754291534, 15.3639249801636, 46.40625},
        [34] = {-81.018516340527, 342.87482380867, 326.11833715439},
    
        [22] = {338.839179039, 53.49357098341, 298.45233917236},
        [23] = {307.68748283386, 22.110015869141, 313.59375},
        [24] = {96.047592163086, 357.88313293457, 56.739406585693},

    },

    ['carrying'] = {

        [22] = {0, -30, 0},
        [23] = {80, -95, 20},
        [24] = {80, 30, 0},
        [32] = {0, -105, 10},
        [33] = {-40, -100, -30},

        [24] = {30, 70, -70}, 
        [34] = {-40, -70, -20},

    },
}

local function setAnimation(player, anim)
    if not (bonePositions[anim]) then return end
    for i, v in pairs(bonePositions[anim]) do 
        setElementBoneRotation(player, i, unpack(v))
    end
    updateElementRpHAnim(player)
end

addEventHandler('onClientPedsProcessed', root, function()

    for k, values in pairs(playerAnimation) do 
        if (values['player'] and isElement(values['player'])) then
            setAnimation(values['player'], values['anim'])
        else
            table.remove(playerAnimation, k)
        end 
    end

    for element in pairs(isCarred) do 
        if isElementStreamedIn(element) then 
            local carrier = getElementAttachedTo(element)
            if carrier and isElement(carrier) then 

                local rx, ry, rz = getElementRotation(carrier)
                setElementRotation(element, rx, ry, rz )

            else
                isCarred[element] = nil
            end
        else
            isCarred[element] = nil
        end
    end

end)

addEvent("FS:addAnim", true)
addEventHandler("FS:addAnim", resourceRoot, function(element, anim)

    for k, values in pairs(playerAnimation) do 
        if (values['player'] and isElement(values['player'])) then
            if (values['player'] == element) then 
                table.remove(playerAnimation, k)
            end
        else
            table.remove(playerAnimation, k)
        end 
    end

    playerAnimation[ #playerAnimation + 1 ] = {
        player = element,
        anim = anim
    }
    
end)

addEvent("FS:removeAnim", true)
addEventHandler("FS:removeAnim", resourceRoot, function(element)
    for k, values in pairs(playerAnimation) do 
        if (values['player'] and isElement(values['player'])) then
            if (values['player'] == element) then 
                table.remove(playerAnimation, k)
            end
        else
            table.remove(playerAnimation, k)
        end 
    end
end)

--| Animation ( IFPs )

addEvent("FS:setIFPAnimation", true)
addEventHandler("FS:setIFPAnimation", resourceRoot, function(element, anim)
    if not isElement(element) then return end
    setPedAnimation(element, 'fs.carry', anim, -1, false, true, false, true)
    isCarred[element] = true
end)

addEvent("FS:removeIFPAnimation", true)
addEventHandler("FS:removeIFPAnimation", resourceRoot, function(element)
    if not isElement(element) then return end
    setPedAnimation(element)
    isCarred[element] = nil
end)

--| Blocker's

addEventHandler("onClientKey", root, function(button, press)
    if press then 

        if not getElementData(localPlayer, "guetto.handcuffed") then
            return 
        end
        if config["blockers"]["binds"][button] then 
            cancelEvent()
        end
    end
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
    engineLoadIFP("assets/ifp/carry.ifp", "fs.carry")
end)
    