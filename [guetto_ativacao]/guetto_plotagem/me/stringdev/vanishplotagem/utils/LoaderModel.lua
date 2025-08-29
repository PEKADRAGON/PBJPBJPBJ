function startLoadModels(startedRes)
    if (startedRes ~= getThisResource()) then return end
    
    if not (isActive()) then return end
    
    for modelId, cnfg in pairs(config["vehiclesDefaults"]) do
		if (cnfg["LocalTXD"]:find("_encrypted")) then
			downloadFile(cnfg["Txd"])
		else
			local txd = engineLoadTXD(cnfg["LocalTXD"])
			engineImportTXD(txd, modelId)
		end

		if (cnfg["LocalDFF"]:find("_encrypted")) then
			downloadFile(cnfg["LocalDFF"])
		else
			local dff = engineLoadDFF(cnfg["LocalDFF"])
			engineReplaceModel(dff, modelId)
		end
    end
end
addEventHandler("onClientResourceStart", getRootElement(), startLoadModels)

function onDownloadFinish(file, success)
    if (source ~= resourceRoot) then return end
    if not (success) then return end
    
	if not (findTableByFileName(file)) then return end

	local modelId = findTableByFileName(file)
	replaceFile(getResourceName(getThisResource()), file, config["vehiclesDefaults"][modelId]["Password"], modelId)
end
addEventHandler("onClientFileDownloadComplete", getRootElement(), onDownloadFinish)

function findTableByFileName(fileName)
    local modelSearch = false

    for modelId, cnfg in pairs(config["Models"]) do
        if (cnfg["LocalTXD"] == fileName) then
            modelSearch = modelId
            break
        end
        
        if (cnfg["LocalDFF"] == fileName) then
			modelSearch = modelId
			break
		end
    end

    return modelSearch
end

local replace = {
    txd = {load = engineLoadTXD, replace = engineImportTXD},
    dff = {load = engineLoadDFF, replace = engineReplaceModel},
    col = {load = engineLoadCOL, replace = engineReplaceCOL}
}

function replaceFile(sourceResource, originalFile, key, id)
    if (originalFile:sub(1, 1) ~= ":") and sourceResource then
        file = ":"..(sourceResource).."/"..originalFile
    end

    if (fileExists(file)) then
        local replaceType = file:match("%.(%a+)")
        if (replaceType) then
            if (replace[replaceType:gsub("_encrypted$", "")]) then
                local compiledFile = File.open(file, true)
                if (compiledFile) then
                    local load = replace[replaceType:gsub("_encrypted$", "")].load(decodeString("tea", compiledFile:read(compiledFile:getSize()), { key = key }))
                    replace[replaceType:gsub("_encrypted$", "")].replace(load, id)
                    compiledFile:close()
                    fileDelete(file)
                end
            end
        end
    end
end