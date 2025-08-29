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
engineImportTXD ( txd,8555) --Coloque o ID do objeto que você quer modificar
col = engineLoadCOL ( "Kuro.col" ) --Coloque o nome do arquivo COL
engineReplaceCOL ( col,8555) --Coloque o ID do objeto que você quer modificar
dff = engineLoadDFF ( "Kuro.dff", 0 ) --Coloque o nome do DFF e não mexa nesse 0
engineReplaceModel ( dff,8555,false ) --Coloque o ID do objeto que você quer modificar
engineSetModelLODDistance(8555, 9999) --ID do objeto e a distância que ele irá carregar - distancia está como 500
setOcclusionsEnabled(false)

txd = engineLoadTXD ( "Kuro.txd" ) --Coloque o nome do TXD
engineImportTXD ( txd,1901) --Coloque o ID do objeto que você quer modificar
col = engineLoadCOL ( "Kuro2.col" ) --Coloque o nome do arquivo COL
engineReplaceCOL ( col,1901) --Coloque o ID do objeto que você quer modificar
dff = engineLoadDFF ( "Kuro2.dff", 0 ) --Coloque o nome do DFF e não mexa nesse 0
engineReplaceModel ( dff,1901,false ) --Coloque o ID do objeto que você quer modificar
engineSetModelLODDistance(1901, 9999) --ID do objeto e a distância que ele irá carregar - distancia está como 500
setOcclusionsEnabled(false)

