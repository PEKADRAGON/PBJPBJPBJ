function engine()
    txd = engineLoadTXD("files/wglass.txd") 
    engineImportTXD(txd, 1649)
end
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), engine)