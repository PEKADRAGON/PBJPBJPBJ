function AndrixxClient ()
txd = engineLoadTXD("vgshpground.txd") 
engineImportTXD(txd, 10770 )

txd2 = engineLoadTXD("contachou1_lae2.txd") 
engineImportTXD(txd2, 11245 )

txd3 = engineLoadTXD("sw_library.txd") 
engineImportTXD(txd3, 9314 )
end
addEventHandler( "onClientResourceStart", resourceRoot, AndrixxClient )
