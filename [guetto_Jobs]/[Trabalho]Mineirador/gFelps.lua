--[[

██╗░░░██╗░█████╗░███╗░░██╗███████╗░██████╗░██████╗░█████╗░  ░██████╗░█████╗░██████╗░
██║░░░██║██╔══██╗████╗░██║██╔════╝██╔════╝██╔════╝██╔══██╗  ██╔════╝██╔══██╗██╔══██╗
╚██╗░██╔╝███████║██╔██╗██║█████╗░░╚█████╗░╚█████╗░███████║  ╚█████╗░██║░░╚═╝██████╔╝
░╚████╔╝░██╔══██║██║╚████║██╔══╝░░░╚═══██╗░╚═══██╗██╔══██║  ░╚═══██╗██║░░██╗██╔══██╗
░░╚██╔╝░░██║░░██║██║░╚███║███████╗██████╔╝██████╔╝██║░░██║  ██████╔╝╚█████╔╝██║░░██║
░░░╚═╝░░░╚═╝░░╚═╝╚═╝░░╚══╝╚══════╝╚═════╝░╚═════╝░╚═╝░░╚═╝  ╚═════╝░░╚════╝░╚═╝░░╚═╝

- Todos os direitos reservados a FiveShop.

- E tudo quanto fizerdes, seja por meio de palavras ou ações, fazei em o Nome do Senhor Jesus, oferecendo por intermédio dele graças a Deus Pai.
]]--

Confg = { 
	posped = {-826.30041503906, -1898.1466064453, 11.811317443848,180}, --=={ pox x,y,z e r }==--
    elementdata = "Minerador", --=={ elementdata trabalho }==--
	ores = { --=={ index, tipo, arquivo, id }==--
		[1] = {"Bronze ", "files/coal.png", 56},
		[2] = {"Ouro", "files/gold.png", 58},
		[3] = {"Diamante", "files/diamond.png", 55},
	},
	precos = { --=={ Tipo, preço }==--
		["Bronze"] = {4200},
		["Ouro"] = {5400},
		["Diamante"] = {6000},
	},
}

sendMessageServer = function (player, msg, type)
	return exports['guetto_notify']:showInfobox(player, type, msg)
end;

sendMessageClient = function (msg, type)
	return exports['guetto_notify']:showInfobox(type, msg)
end;
