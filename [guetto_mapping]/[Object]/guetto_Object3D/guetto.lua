if fileExists("guetto.lua") then
	fileDelete("guetto.lua")
end

local object = {

	[1] = {ID = 2942, dff = "model/caixaFleeca.dff", txd = "model/caixaFleeca.txd", col = "model/caixaFleeca.col"},
	[2] = {ID = 14391, dff = "model/mesadj.dff", txd = "model/mesadj.txd", col = "model/mesadj.col"}, -- 1429
	[3] = {ID = 1550, dff = "model/gun_para.dff", txd = "model/gun_para.txd", col = "model/caixaFleeca.col"}, 
	[4] = {ID = 2461, dff = "model/katana.dff", txd = "model/katana.txd", col = "model/caixaFleeca.col"},
	[5] = {ID = 1911, dff = "model/gang.dff", txd = "model/gang.txd"}, -- Black
	[6] = {ID = 1910, dff = "model/gang.dff", txd = "model/gang1.txd"}, -- Pink
	--[7] = {ID = 1909, dff = "model/gang.dff", txd = "model/gang2.txd"}, -- Camuflada
	[7] = {ID = 1899, dff = "model/DemonGold.dff", txd = "model/DemonGold.txd"}, -- Camuflada
--	[8] = {ID = 4821, dff = "model/4821.dff", txd = "model/4821.txd", col = "model/4821.col"}, -- Loja Modelada
	[8] = {ID = 14437, dff = "model/ilha.dff", txd = "model/ilha.txd", col = "model/ilha.col"}, -- Loja Modelada wooden_box
	--[10] = {ID = 1429, dff = "model/wooden_box.dff", txd = "model/wooden_box.txd", col = "model/wooden_box.col"}, -- Bau antigo rust
	[9] = {ID = 1815, dff = "model/tool_cupboard.dff", txd = "model/tool_cupboard.txd", col = "model/tool_cupboard.col"}, -- Armario antigo rust
	[10] = {ID = 2105, dff = "model/vest.dff", txd = "model/vest.txd"}, -- proteção rust
	[11] = {ID = 1738, dff = "model/helmet.dff", txd = "model/helmet.txd"}, -- proteção rust
	[12] = {ID = 2903, dff = "model/airdrop.dff", txd = "model/airdrop.txd"}, -- airdrop rust
	[13] = {ID = 4600, dff = "model/bank2.dff", txd = "model/bank2.txd", col = "model/bank2.col"}, -- Banco
	[14] = {ID = 1337, dff = "model/bombox.dff", txd = "model/bombox.txd", col = "model/bombox.col"}, -- caixa
	[15] = {ID = 2605, dff = "model/MesaIlegal.dff", txd = "model/MesaIlegal.txd"}, -- caixa]]
	[16] = {ID = 339, dff = "model/cutelo.dff", txd = "model/cutelo.txd"}, -- Cutelo
	[17] = {ID = 1886, dff = "model/asas.dff", txd = "model/asas.txd"}, -- Cutelo
	[18] = {ID = 1906, dff = "model/cinturao.dff", txd = "model/cinturao.txd"}, -- Cutelo
	[19] = {ID = 1879, dff = "model/colete1.dff", txd = "model/colete1.txd"}, -- Cutelo
	[20] = {ID = 1908, dff = "model/colete2.dff", txd = "model/colete2.txd"}, -- Cutelo
	[21] = {ID = 1953, dff = "model/mergulho.dff", txd = "model/mergulho.txd"}, -- Cutelo
	[22] = {ID = 1893, dff = "model/bagnike.dff", txd = "model/bagnike.txd"}, -- Cutelo
	[23] = {ID = 1893, dff = "model/bagnike.dff", txd = "model/bagnike.txd"}, -- Cutelo
	[24] = {ID = 1882, dff = "model/cavalo.dff", txd = "model/cavalo.txd"}, 
	--[25] = {ID = 1884, dff = "model/mochila3.dff", txd = "model/mochila3.txd"},
	--[26] = {ID = 1885, dff = "model/mochila4.dff", txd = "model/mochila4.txd"},
	[25] = {ID = 1888, dff = "model/mochila5.dff", txd = "model/mochila5.txd"},
	[26] = {ID = 1889, dff = "model/mochila6.dff", txd = "model/mochila6.txd"},
	--[33] = {ID = 1916, dff = "model/wreath.dff", txd = "model/wreath.txd"},
	--[34] = {ID = 1917, dff = "model/5.dff", txd = "model/5.txd"},
	--[35] = {ID = 1918, dff = "model/2.dff", txd = "model/2.txd"},
	--[36] = {ID = 1919, dff = "model/assaswhite.dff", txd = "model/assaswhite.txd"},
	--[37] = {ID = 1920, dff = "model/assasblack.dff", txd = "model/assasblack.txd"},
	[27] = {ID = 2206, dff = "model/2206.dff", txd = "model/2206.txd"},
	[28] = {ID = 2344, dff = "model/2344.dff", txd = "model/2344.txd"},
  }
  
  addEventHandler("onClientResourceStart", resourceRoot,
  function()
	  for i, data in pairs(object) do
		  local dff = engineLoadDFF(data.dff, data.ID)
		  local txd = engineLoadTXD(data.txd)
		  local col = nil
		  
		  if data.col then
			  col = engineLoadCOL(data.col)
		  end
  
		  if txd then
			  engineImportTXD(txd, data.ID)
		  end
  
		  if dff then
			  engineReplaceModel(dff, data.ID)
		  end
  
		  if col then
			  engineReplaceCOL(col, data.ID)
		  end
  
		  engineSetModelLODDistance(data.ID, 2000)
	  end
  end)
  