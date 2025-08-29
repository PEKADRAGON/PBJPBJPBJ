--============================================================

--Desenvolvido por Trust Store: https://discord.gg/ah7Dgt7B4b

--============================================================

license = {
    ["Email"] = "matteoui97@gmail.com", -- Coloque o email do seu discord em "seuemail" mantendo as ""
    ["Key"] = "HRJ-ZDX-NKQ-TRUST" -- Coloque a sua key de ativação
}


--Obs: Não sabe como ativar o mapa? de uma olhada em nossos tutoriais: https://youtube.com/playlist?list=PLyk7YT4YZ3CoE5J9W9Q_QvRSDpAo1lZgn

--============================================================

configurar = {
	
	idioma = "portugues", -- Idioma dos sistemas do pedagio (portugues, english, espanol)
	
	tempocancela = 3000, -- tempo que a cancela vai demorar para fechar apos aberta (em milisegundos) (colocar um valor muito baixo pode bugar o sistema)
	
	valorsemparar = 2500, -- Valor do sem parar
	
	valorpedagio = 500, -- Valor do pedagio
	
	moedalocal = "R$", -- Moeda da sua preferencia
	
	aclsemp = {"Console", "Visionário", "Corporação", "Marginal de grife" }, -- Acls que podem passar no sem parar sem pagar
	
	acllucro = {"Pedagio"}, -- Acl que pode abrir o painel de lucro de retirar o dinheiro do lucro do pedagio
	
	comandopainel = "pdg100", -- Comando que quem estiver na acl acima digita para abrir o painel de lucro
	
	msgauto = false, -- Mensagem automatica mostrando quantos sem parar tem ao se aproximar do pedagio (true = sim | false = não)

	corrgbmarker = {32, 87, 107, 10}, -- Cor RGB do marker do Sem Parar (R, G, B, Alpha)
	
	infobox = false, -- Infobox (true = sim, false = mensagens serão exibidas no chat)
	
	TrustnotifyS = function (player, message, type) -- Vincule a sua infobox, colocando abaixo o trigger ou o export (Lado do servidor)
		return exports['guetto_notify']:showInfobox(player,message,type)
	end,
	
	error = "error", -- Variavel erro da sua infobox
	info = "info", -- Variavel info da sua infobox
	-----------------------------------------
	----------------Pedagios-----------------
	-----------------------------------------
	
	
	pedagios = { -- Localização dos pedagios ("simples" ou "duplo", posX, posY, posZ, rotX, rotY, rotZ) ("simples" vai ser o pedagio pequeno e duplo vai ser o pedagio "grande")
		{"simples", 45.721817016602, -1531.1181640625, 3.9275350570679, 0, 0, 83.500030517578}, -- ponte praia
		{"simples", -14.727641105652, -1334.4134521484, 9.6277780532837, 0, 0, 309.0166015625}, -- ponte praia 2 sentido interior
		{"simples", 3.075660943985, -1356.1624755859, 9.2819776535034, 0, 0, 309.01672363281}, -- ponte praia 2 sentido ls
		{"duplo", -2932.5590820312, -1530.7655029297, 9.5844774246216, 0, 0, 4}, -- baixo sf
		{"duplo", -2681.7153320312, 1312.2902832031, 54.187423706055, 0, 0, 0}, -- topo sf
		{"duplo", -1128.7891845703, 1112.0798339844, 36.938335418701, 0, 0, 317}, -- ponte sf
		{"simples", -1390.4004, -816.87933, 80.42032, 0, 0, 92.25 }, -- entrada sf
		{"simples", 514.68323, 480.92096, 17.66369, 0, 0, 35.25 }, -- lv ponte branca
		{"duplo", 1699.6924, 411.73373, 29.33374, 0, 0, -18.751 }, -- lv ponte duplo
		{"simples", -169.20035, 362.76242, 10.81213, 0, 0, -14.5 }, -- lv ponte vermelha
		{"simples", 3532.69, -792.442, 22.462-1, 0, 0, 90 }, -- lv ponte vermelha
	},
	
	markerssemp ={ -- Markers para comprar o sem parar (posX, posY, posZ, rotX, rotY, rotZ, "cabine" ou "marker") ("cabine" vai aparecer a model da cabine junto ao marker e "marker" aparecera somente o marker)	
		{784.66, -1287.114, 13.633-1, 0, 0, 90, "cabine"}, -- LS PROXIMO A GROOVE STREET
	},
	
	-----------------------------------------
	------------Sistema Bancario-------------
	-----------------------------------------
	getBankMoney = function(player)
		return getElementData(player, "guetto.bank.balance") -- Get Element Data do seu sistema bancario
	end,
	
	setBankMoney = function(player, quant)
		return setElementData(player, "guetto.bank.balance", quant) -- Set Element Data do seu sistema bancario
	end,
	
	
	-----------------------------------------
	-----------Sistema de Dinheiro-----------
	-----------------------------------------
	
	-- Caso seu sistema de dinheiro seja o mesmo do mta sa mantenha como esta, caso contrario modifique para o seu sistema.
	getMoney = function(player)
		return getPlayerMoney(player) -- Função getPlayerMoney
	end,
	
	giveMoney = function(player, quant)
		return givePlayerMoney(player, quant) -- Função givePlayerMoney
	end,
	
	takeMoney = function(player, quant)
		return takePlayerMoney(player, quant) -- Função takePlayerMoney
	end,
	
	-----------------------------------------
	--------------Anti Conflito--------------
	-----------------------------------------

	idpedagioduplo = 9623, -- id do pedagio duplo
	idpedagiosimples = 1876, -- id do pedagio simples
	idcabine = 1870, -- id do objeto da cabine do sem parar
	idplaca = 1868, -- id da placa de pedagio a 1km
	
}