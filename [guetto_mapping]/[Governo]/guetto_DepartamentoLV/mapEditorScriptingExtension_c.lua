-- FILE: mapEditorScriptingExtension_c.lua
-- PURPOSE: Prevent the map editor feature set being limited by what MTA can load from a map file by adding a script file to maps
-- VERSION: RemoveWorldObjects (v1) AutoLOD (v2) BreakableObjects (v1)

function setLODsClient(lodTbl)
	for model in pairs(lodTbl) do
		engineSetModelLODDistance(model, 300)
	end
end
addEvent("setLODsClient", true)
addEventHandler("setLODsClient", resourceRoot, setLODsClient)

addEventHandler('onClientResourceStart',resourceRoot,function () 
	txd = engineLoadTXD ( "ByCorleone.txd" ) --Coloque o nome do TXD
	engineImportTXD ( txd, 6966 ) --Coloque o ID do objeto que você quer modificar
	col = engineLoadCOL ( "ByCorleone.col" ) --Coloque o nome do arquivo COL
	engineReplaceCOL ( col, 6966 ) --Coloque o ID do objeto que você quer modificar
	dff = engineLoadDFF ( "ByCorleone.dff", 0 ) --Coloque o nome do DFF e não mexa nesse 0
	engineReplaceModel ( dff, 6966 ) --Coloque o ID do objeto que você quer modificar
	engineSetModelLODDistance(6966, 500) --ID do objeto e a distância que ele irá carregar - distancia está como 500
end)
