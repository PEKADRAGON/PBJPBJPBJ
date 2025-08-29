local objects = {}

addEvent("accessoriesCreateObject", true)
addEventHandler("accessoriesCreateObject", root, function(player, item)

    if not (player or not isElement(player) or getElementType(player) ~= 'player' or not item) then 
        return false 
    end

    local data, categoria = getAcessorioSettings(item)

    if not data then 
        return print("Houve uma falha ao tentar equipar esse acessorio!")
    end

    if objects[player] and objects[player][categoria] then
        if isElement(objects[player][categoria]) then 
            destroyElement(objects[player][categoria])
            objects[player][categoria] = nil 

            if data.removercabelo then 
                triggerClientEvent("Conner.cabeloalpha", resourceRoot, player, 255)
            end
        end
    else
        
        if not objects[player] then
            objects[player] = {}
        end


        local x, y, z, rx, ry, rz = unpack(data.pos)
        local tx, ty, tz = unpack(data.tamanho)

        objects[player][categoria] = createObject(data.idobjeto, 0, 0, 0)

        setElementData(objects[player][categoria], "objectData", {categoria, item})
        setObjectScale(objects[player][categoria], tx, ty, tz)

        exports.pattach:attach(objects[player][categoria], player, data.osso, x, y, z, rx, ry, rz, tx, ty, tz)

        if getElementData(player, "characterGenre") == 1 and data.removercabelo then
            triggerClientEvent("Conner.cabeloalpha", resourceRoot, player, 0)
        end

        if data.nometextura ~= "" then
            setElementData(objects[player][categoria], "accessorieTexture", {
                directory = data.diretorio,
                texturename = data.nometextura,
                category = categoria
            })
        end
    end

end)

function destroyAllObjects(element)
    if not objects[element] then return end
    for i,v in pairs(objects[element]) do
        if isElement(v) then
            destroyElement(v)
        end
    end
    objects[element] = nil
end

addEventHandler("onPlayerQuit", root, function()
    destroyAllObjects(source)
end)

addEventHandler("onPlayerWasted", root, function(ammo, attacker, weapon, bodypart)
	destroyAllObjects(source)
end)