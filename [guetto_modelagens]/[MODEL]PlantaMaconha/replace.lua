--[[
   __________ _  __    _______________  ____  ______
  / ____/ __ \ |/ /   / ___/_  __/ __ \/ __ \/ ____/
 / /   / /_/ /   /    \__ \ / / / / / / /_/ / __/   
/ /___/ ____/   |    ___/ // / / /_/ / _, _/ /___   
\____/_/   /_/|_|   /____//_/  \____/_/ |_/_____/   
                                                    
--]]

txd = engineLoadTXD("CPX2.txd", 1549 )
engineImportTXD(txd, 1549)
dff = engineLoadDFF("CPX1.dff", 1549 )
engineReplaceModel(dff, 1549)
col = engineLoadCOL ( "CPX2.col" )
engineReplaceCOL ( col, 1549 )
engineSetModelLODDistance(1549, 500) --ID do objeto e a distância que ele irá carregar - distancia está como 500

txd = engineLoadTXD("CPX2.txd", 1574 )
engineImportTXD(txd, 1574)
dff = engineLoadDFF("CPX2.dff", 1574 )
engineReplaceModel(dff, 1574)
col = engineLoadCOL ( "CPX2.col" )
engineReplaceCOL ( col, 1574 )
engineSetModelLODDistance(1574, 500)