function Silah()
	id= 338
    local txd = engineLoadTXD ('baglama.txd')
    engineImportTXD(txd,id)
    local dff = engineLoadDFF('baglama.dff',id)
    engineReplaceModel(dff,id)
end
addEventHandler('onClientResourceStart',getResourceRootElement(getThisResource()),Silah)


-- Model 3D Warehouse, Author : Ali K.
-- Müzik : Harun Murat ÖZGÜÇ : https://www.youtube.com/watch?v=diAkfxeaibs
-- Script : SparroWMTA

-- SparroW MTA : https://sparrow-mta.blogspot.com
-- Facebook : https://www.facebook.com/sparrowgta/
-- İnstagram : https://www.instagram.com/sparrowmta/
-- Discord : https://discord.gg/DzgEcvy




