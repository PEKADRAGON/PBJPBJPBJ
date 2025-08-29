function replaceModel(modelID, modelType, filePath, customPath)
    if not modelID or not modelType or not filePath then
        return
    end

    local modelPath = string.format("models/%s/%s", filePath, modelType)

    if customPath then
        modelPath = "models/"..customPath.."/"..filePath
    end

    if fileExists(modelPath .. ".guettodff") then
        local file = fileOpen(modelPath .. ".guettodff")
        local encodedData = teaDecodeBinary(fileRead(file, fileGetSize(file)), EncriptionKey)
        engineImportTXD(engineLoadTXD(encodedData), modelID)
        fileClose(file)
    end

    if fileExists(modelPath .. ".guettocol") and modelType ~= "build" then
        local file = fileOpen(modelPath .. ".guettocol")
        local encodedData = teaDecodeBinary(fileRead(file, fileGetSize(file)), EncriptionKey)
        fileClose(file)
        engineReplaceModel(engineLoadDFF(encodedData), modelID)
        engineSetModelLODDistance(modelID, 2000)
    end

    if fileExists(modelPath .. ".guettotxd") then
        local file = fileOpen(modelPath .. ".guettotxd")
        local encodedData = teaDecodeBinary(fileRead(file, fileGetSize(file)), EncriptionKey)
        engineReplaceCOL(engineLoadCOL(encodedData), modelID)
        fileClose(file)
    end

    return true
end

for _, item in ipairs(replaces) do
    replaceModel(item.model, item.type, item.file, item.path)
end