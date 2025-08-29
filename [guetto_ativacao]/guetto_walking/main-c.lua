for id, response in pairs(config["animation"]) do
    engineLoadIFP(response.ifp, 'guetto.animation '..response.skin)
end

createPlayerAnimation = function(element, gender)

    for id, response in pairs(config["animation"][gender].replaces) do
        engineReplaceAnimation(element, 'ped', response, 'guetto.animation '..config["animation"][gender].skin, response)
    end

end

addEventHandler('onClientResourceStart', resourceRoot, function ( )
    local gender = getElementData(localPlayer, 'characterGenre') or 1   
    createPlayerAnimation(localPlayer, gender)
end)
