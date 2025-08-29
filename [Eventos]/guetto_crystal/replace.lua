function createCrystal()

    local txd = engineLoadTXD('files/diamond.txd',true)

    engineImportTXD(txd, 1213)

	-- local col = engineLoadCOL('files/diamond.col', 0)

	-- engineReplaceCOL(col, 1213)

    local dff = engineLoadDFF('files/diamond.dff', 0)

    engineReplaceModel(dff, 1213)

end

addEventHandler("onClientResourceStart", resourceRoot, createCrystal)

