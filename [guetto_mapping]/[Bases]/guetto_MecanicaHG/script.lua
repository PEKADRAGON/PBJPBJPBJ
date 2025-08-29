--[[
   ▄█   ▄█▄ ███    █▄     ▄████████  ▄██████▄                                  ▄▄▄▄███▄▄▄▄       ███        ▄████████ 
  ███ ▄███▀ ███    ███   ███    ███ ███    ███                               ▄██▀▀▀███▀▀▀██▄ ▀█████████▄   ███    ███ 
  ███▐██▀   ███    ███   ███    ███ ███    ███                               ███   ███   ███    ▀███▀▀██   ███    ███ 
 ▄█████▀    ███    ███  ▄███▄▄▄▄██▀ ███    ███                               ███   ███   ███     ███   ▀   ███    ███ 
▀▀█████▄    ███    ███ ▀▀███▀▀▀▀▀   ███    ███                               ███   ███   ███     ███     ▀███████████ 
  ███▐██▄   ███    ███ ▀███████████ ███    ███                               ███   ███   ███     ███       ███    ███ 
  ███ ▀███▄ ███    ███   ███    ███ ███    ███                               ███   ███   ███     ███       ███    ███ 
  ███   ▀█▀ ████████▀    ███    ███  ▀██████▀                                 ▀█   ███   █▀     ▄████▀     ███    █▀  
  ▀                      ███    ███                                                                                  




   \  |   _ \   __ \   ____|  |       ___|      ___ /   __ \  
  |\/ |  |   |  |   |  __|    |     \___ \        _ \   |   | 
  |   |  |   |  |   |  |      |           |        ) |  |   | 
 _|  _| \___/  ____/  _____| _____| _____/      ____/  ____/  
 --]]

txd = engineLoadTXD ( "Kuro.txd" ) --Coloque o nome do TXD
engineImportTXD ( txd, 13078) --Coloque o ID do objeto que você quer modificar
col = engineLoadCOL ( "Kuro.col" ) --Coloque o nome do arquivo COL
engineReplaceCOL ( col, 13078 ) --Coloque o ID do objeto que você quer modificar
dff = engineLoadDFF ( "Kuro.dff", 0 ) --Coloque o nome do DFF e não mexa nesse 0
engineReplaceModel ( dff, 13078,false ) --Coloque o ID do objeto que você quer modificar
dff = engineLoadDFF ( "Kuro1.dff", 0 ) --Coloque o nome do DFF e não mexa nesse 0
engineReplaceModel ( dff, 13082,false ) --Coloque o ID do objeto que você quer modificar
engineSetModelLODDistance(13078, 9999) --ID do objeto e a distância que ele irá carregar - distancia está como 500
setOcclusionsEnabled(false)
