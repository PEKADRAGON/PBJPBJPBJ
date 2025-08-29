txd = engineLoadTXD ( "rota.txd" )
engineImportTXD ( txd, 327 )
col = engineLoadCOL ( "rota.col" )
engineReplaceCOL ( col, 327 )
dff = engineLoadDFF ( "rota.dff", 0 )
engineReplaceModel ( dff, 327 )
engineSetModelLODDistance(327, 999999999)





-- Onde estiver ID, coloque o ID do objeto que você quer substituir.
-- Onde estiver NOME, você coloca o nome dos arquivos na pasta "Skins".
-- No engineSetModelLODDistance você coloca a ID do objeto, logo em seguida a distância que você quer que ele renderize, o máximo permitido pelo MTA é 170.