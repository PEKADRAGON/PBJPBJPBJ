local plotageFx = [[
    texture vanishPlotagem;

    technique TexReplace
    {
        pass P0
        {
            Texture[0] = vanishPlotagem;
        }
    }
]]

vehicles = { }

Async:setPriority(1000, 100)

function onDownloadPriority()
    if not (isActive()) then return end

    Async:foreachPairs(config["downloadsPriority"], function (_, filePath)
        loadImgEncrypted(filePath)
    end)

    Async:foreach(getElementsByType("vehicle", getRootElement(getThisResource()), true), function(vehicle, _)
        local vehicleId = vehicle:getModel()
        if (config["vehiclesPlotagem"][vehicleId]) then
            for data, texture in pairs(config["vehiclesPlotagem"][vehicleId]) do
                if (vehicle:getData(data)) then
                    Async:foreachPairs(texture, function(_, v)
                        applyShaderPlotagem(vehicle, v["TextureName"], v["LocalPNG"])
                    end)
                end
            end
        end
    end)
end
addEventHandler("onClientResourceStart", resourceRoot, onDownloadPriority)

function applyShaderPlotagem(vehicleElement, textureName, localArchive)
    if not (isActive()) then return end
    
    if not (vehicleElement) and not (isElement(vehicleElement)) and not (getElementType(vehicleElement) == "vehicle") then 
        return 
    end
    if not (textureName) then 
        return 
    end
    if not (localArchive) then 
        return 
    end
    if not (isElement(vehicleElement)) and not vehicleElement and not (isElementStreamedIn(vehicleElement)) then 
        return 
    end
    
    if (vehicles[vehicleElement] and vehicles[vehicleElement][textureName]) then
        removeShaderPlotagem(element, textureName)
    end

    local loading = loadImgEncrypted(localArchive)
    if not (loading) then return end
    
    if not (vehicles[vehicleElement]) then
        vehicles[vehicleElement] = { }
    end

    local shader = false
    if (vehicles[vehicleElement][textureName]) then
        shader = vehicles[vehicleElement][textureName].shader
    else
        local newShader = DxShader(plotageFx, 0, 0, false, "vehicle")
        if not (newShader) then return end

        shader = newShader
    end

    shader:setValue("vanishPlotagem", loading)

    if not (vehicleElement and isElement (vehicleElement) and vehicleElement:getType () == "vehicle") then
        return
    end

    shader:removeFromWorldTexture(textureName, vehicleElement)
    shader:applyToWorldTexture(textureName, vehicleElement)

    vehicles[vehicleElement][textureName] = { shader = shader }
end
addEvent("vanish.applyShaderPlotagem", true)
addEventHandler("vanish.applyShaderPlotagem", getRootElement(), applyShaderPlotagem)

function removeShaderPlotagem(vehicleElement, textureName)
    if not (vehicleElement) then return end
    if not (textureName) then return end
    if not (vehicles[vehicleElement]) then return end
    if not (vehicles[vehicleElement][textureName]) then return end

    vehicles[vehicleElement][textureName].shader:removeFromWorldTexture(textureName, vehicleElement)
end
addEvent("vanish.removeShaderPlotagem", true)
addEventHandler("vanish.removeShaderPlotagem", getRootElement(), removeShaderPlotagem)