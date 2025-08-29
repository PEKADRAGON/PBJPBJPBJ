local activeVtrs = config.DefaultStateLag

function isActive()
    return activeVtrs
end

function changeState(state)
    activeVtrs = state

    if not (state) then
        for vehicleId, vehicleData in pairs(config["vehiclesDefaults"]) do
            engineRestoreModel(vehicleId)
        end
        return
    end

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
    onDownloadPriority()
end