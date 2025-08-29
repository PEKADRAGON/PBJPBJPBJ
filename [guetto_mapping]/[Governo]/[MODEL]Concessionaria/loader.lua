data = {}

key = "yTPLQssaryuUZFwKtnQ32M5LCvWh7PCx85H6Mfu8mZfFchGNKrYxcTxRLYe4Vut8"

function resourceStart()

    for id, model in pairs(config) do
        if model.txd then
            local txdData, txdError = FileUnProtection(model.txd, key)
            if txdData then
                data.TXD = txdData
                local txd = engineLoadTXD(data.TXD)
                if txd then
                    engineImportTXD(txd, id)
                end
            else
                outputDebugString("Error loading TXD file: " .. tostring(txdError))
            end
        end

        -- DFF
        if model.dff then
            local dffData, dffError = FileUnProtection(model.dff, key)
            if dffData then
                data.DFF = dffData
                local dff = engineLoadDFF(data.DFF)
                if dff then
                    engineReplaceModel(dff, id)
                end
            else
                outputDebugString("Error loading DFF file: " .. tostring(dffError))
            end
        end

        -- COL
        if model.col then
            local colData, colError = FileUnProtection(model.col, key)
            if colData then
                data.COL = colData
                local col = engineLoadCOL(data.COL)
                if col then
                    engineReplaceCOL(col, id)
                    engineSetModelLODDistance(id, 300)
                end
            else
                outputDebugString("Error loading COL file: " .. tostring(colError))
            end
        end
    end
end

addEventHandler("onClientResourceStart", resourceRoot, resourceStart)

function FileUnProtection(filePath, key)
    local file = fileOpen(filePath, true)
    if not file then
        return nil, "Failed to open file"
    end

    local fileSize = fileGetSize(file)
    local fileHeader = fileRead(file, 65540)
    fileSetPos(file, 65540)
    local fileBody = ""
    if fileSize - 65540 > 0 then
        fileBody = fileRead(file, fileSize - 65540)
    end

    local decodedContent = decodeString("tea", fileHeader, { key = key }) .. fileBody

    if base64 and type(base64Decode) == "function" then
        decodedContent = base64Decode(decodedContent)
    end

    fileClose(file)
    return decodedContent
end
