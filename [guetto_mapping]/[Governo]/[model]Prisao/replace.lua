local modelId = 16236

col = engineLoadCOL( "CPX.col" )
txd = engineLoadTXD( "CPX.txd" )
dff = engineLoadDFF( "CPX.dff", 0 )
    
engineReplaceCOL( col, modelId )
engineImportTXD( txd, modelId )
engineReplaceModel( dff, modelId )
engineSetModelLODDistance ( 16236 , 300 )

--------------------------------
   
local modelId = 16231

col = engineLoadCOL( "CPX2.col" )
txd = engineLoadTXD( "CPX.txd" )
dff = engineLoadDFF( "CPX2.dff", 0 )
    
engineReplaceCOL( col, modelId )
engineImportTXD( txd, modelId )
engineReplaceModel( dff, modelId )
engineSetModelLODDistance ( 16231 , 300 )

--------------------------------

txd = engineLoadTXD("CPX.txd", 1915 )
engineImportTXD(txd, 1915)
dff = engineLoadDFF("CPX3.dff", 1915 )
engineReplaceModel(dff, 1915)
col = engineLoadCOL ( "CPX3.col" )
engineReplaceCOL ( col, 1915 )
engineSetModelLODDistance(1915, 500)