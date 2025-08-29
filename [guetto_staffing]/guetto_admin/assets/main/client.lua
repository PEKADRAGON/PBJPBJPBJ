local startTime
local select_weather = 0
local window = "index"
local sub_window = nil
local checking = false
local selectReasons = {}
local totalTime = 0
local eye_serial = false

local client = {
	radius = {255, 0};
	visible = false;
	tick = nil;

	pag_index = 0;
	pag_acls = 0;
	pag_options = 0;
	pag_resources = 0;
	pag_groups = 0;
	pag_weapons = 0;
	pag_punishment = 0;
	pag_bans = 0;
	pag_logs = 0;

	edits = {
		["CODE"] = {false, guiCreateEdit(9999, 9999, 0, 0, "", false)};
		["SEARCH"] = {false, guiCreateEdit(9999, 9999, 0, 0, "", false)};
		["EXECUTECOMMAND"] = {false, guiCreateEdit(9999, 9999, 0, 0, "", false)};
		["TIMESET/HOUR"] = {false, guiCreateEdit(9999, 9999, 0, 0, "", false)};
		["TIMESET/MINUTE"] = {false, guiCreateEdit(9999, 9999, 0, 0, "", false)};
		["GRAVITY"] = {false, guiCreateEdit(9999, 9999, 0, 0, "", false)};
		["GAMESPEED"] = {false, guiCreateEdit(9999, 9999, 0, 0, "", false)};
		["WAVEHEIGHT"] = {false, guiCreateEdit(9999, 9999, 0, 0, "", false)};
		["FPS"] = {false, guiCreateEdit(9999, 9999, 0, 0, "", false)};
		["ID"] = {false, guiCreateEdit(9999, 9999, 0, 0, "", false)};
		["ACL"] = {false, guiCreateEdit(9999, 9999, 0, 0, "", false)};
		["REASON"] = {false, guiCreateEdit(9999, 9999, 0, 0, "", false)};
		["TIMEPUNISH"] = {false, guiCreateEdit(9999, 9999, 0, 0, "", false)};
		["EDIT"] = {false, guiCreateEdit(9999, 9999, 0, 0, "", false)};
	};

	optionsIndexPage = {
		{"PUXAR", "tphere"};
		{"IR ATE ELE", "tp"};
		{"ESPECTAR", "spect"};
		{"EXPULSAR", "kick", modal = true};
		{"MUTAR", "mute", modal = true};
		{"RESETAR CONTA", "resetaccount"};
		{"SETAR NICK", "setnick", modal = true};
		{"SETAR VIDA", "setvida", modal = true};
		{"SETAR COLETE", "setcolete", modal = true};
		{"SETAR ARMAS", "setweapons", modal = true};
		{"SETAR DINHEIRO", "setmoney", modal = true};
		{"SETAR VEÍCULO", "setvehicle", modal = true};
		{"SETAR DIMENSÃO", "setdimension", modal = true};
		{"SETAR INTERIOR", "setinterior", modal = true};
		{"REPARAR", "repair"};
		{"DESTRUIR VEICULO", "destroy"};
	};

	windows = {
		{235, "JOGADORES", "index", "assets/images/user.png", 126, 248, 27, 27, 253, 467};
		{293, "RESOURCES", "resources", "assets/images/resources.png", 123, 304, 33, 33, 310, 412};
		{350, "SERVIDOR", "server", "assets/images/server.png", 126, 365, 27, 27, 368, 0};
		{408, "REGISTROS", "registers", "assets/images/list.png", 130, 425, 20, 20, 425, 0};
		{466, "BANIDOS", "bans", "assets/images/ban.png", 124, 479, 31, 31, 482, 0};
		{525, "ACL CONFIG", "aclmanager", "assets/images/aclconfig.png", 124, 537, 31, 31, 540, 0};
		{583, "PUNIÇÃO", "punishment", "assets/images/punishment.png", 122, 596, 30, 30, 601, 0};
	};
}

local function onDraw ()

	local alpha = interpolateBetween (client.radius[1], 0, 0, client.radius[2], 0, 0, (getTickCount ( ) - client.tick)/300, "Linear")

	if verification == true then 
		dxDrawImageSpacing(464, 168, 429, 564, 5, "assets/images/bg_verification.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
		dxDrawText("PAINEL P V2", 464, 190, 429, 17, tocolor(160, 160, 160, alpha), 1.0, getFont("light", 9), "center", "top")
		dxDrawImageSpacing(625, 219, 107, 107, 5, "assets/images/shield.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
		dxDrawText("AUTENTICAÇÃO DE CONTA", 464, 340, 429, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 12), "center", "top")
		dxDrawText("SUA CONTA PERTENCE A UMA ACL COM DIREITOS DE\nADMINISTRADOR, POR TANTO É NECESSARIO QUE VOCÊ\nDIGITE O CODIGO DE ACESSO ABAIXO.", 464, 386, 429, 51, tocolor(160, 160, 160, alpha), 1.0, getFont("regular", 7), "center", "center")
		dxDrawImage(516, 476, 326, 62, "assets/images/button_verification.png", 0, 0, 0, tocolor(48, 48, 61, alpha))

		if (client.edits["CODE"][1] and isElement(client.edits["CODE"][2])) then
			dxDrawText((guiGetText(client.edits["CODE"][2]) or "").. "|", 516, 478, 326, 62, tocolor(160, 160, 160, alpha), 1.0, getFont("regular", 11), "center", "center")
			
		elseif (#guiGetText(client.edits["CODE"][2]) >= 1) then 
			dxDrawText((guiGetText(client.edits["CODE"][2]) or ""), 516, 478, 326, 62, tocolor(160, 160, 160, alpha), 1.0, getFont("regular", 11), "center", "center")
		else
			dxDrawText("CÓDIGO", 516, 478, 326, 62, tocolor(160, 160, 160, alpha), 1.0, getFont("regular", 11), "center", "center")
		end

		dxDrawImage(516, 547, 326, 62, "assets/images/button_verification.png", 0, 0, 0, functions.isCursorOnElement(516, 547, 326, 62) and tocolor(107, 74, 201, alpha) or tocolor(193, 159, 114, alpha))
		dxDrawText("ACESSAR", 516, 549, 326, 62, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 11), "center", "center")
		
		dxDrawText("VOCÊ TEM 1 TENTATIVA CASO CONTRARIO SERÁ EXPULSO.", 464, 655, 429, 17, tocolor(227, 127, 114, alpha), 1.0, getFont("light", 7), "center", "center")
	else
		if checking then 
			dxDrawImageSpacing(464, 168, 429, 564, 5, "assets/images/bg_verification.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
			dxDrawText("PAINEL P V2", 464, 190, 429, 17, tocolor(160, 160, 160, alpha), 1.0, getFont("light", 9), "center", "top")
			dxDrawImageSpacing(625, 344, 107, 107, 5, "assets/images/shield.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
			dxDrawText("VERIFICANDO CÓDIGO", 464, 460, 429, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 12), "center", "top")
			dxDrawText("OBRIGADO POR SE VERIFICAR, VOCÊ SÓ TERÁ QUE\nFAZER ISSO NOVAMENTE DEPOIS DE 12 HORAS.", 464, 510, 429, 34, tocolor(160, 160, 160, alpha), 1.0, getFont("regular", 7), "center", "center")
		
			local elapsedTime = getTickCount() - startTime
			local progress = math.min((elapsedTime / 5000) * 100, 100)
			
			dxDrawRectangle(508, 610, 341, 8, tocolor(48, 48, 61, alpha))
			dxDrawRectangle(508, 610, 341 * (progress / 100), 8, tocolor(193, 159, 114, alpha))

			dxDrawText(math.floor(progress).."%", 464, 635, 429, 17, tocolor(160, 160, 160, alpha), 1.0, getFont("light", 9), "center", "center")

			if elapsedTime >= 5000 then
				checking = false
				startTime = nil
			end

		else
			dxDrawImageSpacing(94, 61, 1169, 778, 5, "assets/images/background.png", 0, 0, 0, tocolor(255, 255, 255, alpha))

			--dxDrawImage(116, 83, 64, 64, ":[BVR]Login/assets/avatars/"..(getElementData(localPlayer, "Avatar") or 0)..".png", 0, 0, 0, tocolor(255, 255, 255, alpha))
			dxDrawText(""..getPlayerName(localPlayer).." #"..(getElementData(localPlayer, "ID") or "N/A").."", 204, 91, 103, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10))
			dxDrawText("Administração", 204, 118, 103, 20, tocolor(193, 159, 114, alpha), 1.0, getFont("regular", 10))

			dxDrawText("Recursos administradores", 124, 202, 193, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10))

			for i, v in ipairs(client.windows) do
				if functions.isCursorOnElement(94, v[1], 311, 55) or window == v[3] then 
					dxDrawRectangle(95, v[1], 311, 55, tocolor(193, 159, 114, alpha))
				else
					dxDrawRectangle(95, v[1], 311, 55, tocolor(32, 32, 32, alpha))
				end
				dxDrawImageSpacing(v[5], v[6], v[7], v[8], 5, v[4], 0, 0, 0, tocolor(255, 255, 255, alpha))
				dxDrawText(v[2], 170, v[9], 86, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("medium", 10))
			end

			if window == "index" then 
				dxDrawImageSpacing(437, 83, 803, 359, 0, "assets/images/bg_players.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
				
				if select_player then
					dxDrawText("Nome da conta:", 467, 104, 116, 20, tocolor(144, 144, 144, alpha), 1.0, getFont("regular", 10))
					dxDrawText("Carteira:", 467, 150, 116, 20, tocolor(144, 144, 144, alpha), 1.0, getFont("regular", 10))
					dxDrawText("Banco:", 467, 196, 116, 20, tocolor(144, 144, 144, alpha), 1.0, getFont("regular", 10))
					dxDrawText("GP:", 467, 242, 116, 20, tocolor(144, 144, 144, alpha), 1.0, getFont("regular", 10))
					dxDrawText("Serial:", 467, 288, 116, 20, tocolor(144, 144, 144, alpha), 1.0, getFont("regular", 10))
					dxDrawText("Veículo:", 467, 334, 116, 20, tocolor(144, 144, 144, alpha), 1.0, getFont("regular", 10))

					dxDrawText("Vida:", 1075, 106, 116, 20, tocolor(144, 144, 144, alpha), 1.0, getFont("regular", 10))
					dxDrawText("Colete:", 1075, 155, 116, 20, tocolor(144, 144, 144, alpha), 1.0, getFont("regular", 10))
					dxDrawText("Roupa:", 1075, 204, 116, 20, tocolor(144, 144, 144, alpha), 1.0, getFont("regular", 10))
					dxDrawText("Local:", 1075, 253, 116, 20, tocolor(144, 144, 144, alpha), 1.0, getFont("regular", 10))
					dxDrawText("Ping:", 1075, 302, 116, 20, tocolor(144, 144, 144, alpha), 1.0, getFont("regular", 10))
					dxDrawText("Dimensão:", 1075, 351, 116, 20, tocolor(144, 144, 144, alpha), 1.0, getFont("regular", 10))
					dxDrawText("Interior:", 1075, 400, 116, 20, tocolor(144, 144, 144, alpha), 1.0, getFont("regular", 10))

					dxDrawText(data_players[select_player].account, 600, 104, 116, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10))
					dxDrawText("R$ "..convertNumber(data_players[select_player].money).."", 542, 150, 116, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10))
					dxDrawText("R$ "..convertNumber((getElementData(data_players[select_player].element, "guetto.bank.balance") or 0)).."", 528, 196, 116, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10))
					dxDrawText("GP "..convertNumber((getElementData(data_players[select_player].element, "guetto.points") or 0)).."", 540, 242, 116, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10))
					dxDrawText(eye_serial and "******************************" or  ""..getPlayerSerial(data_players[select_player].element).."", 525, 288, 116, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10))
					
					local vehicle = getPedOccupiedVehicle(data_players[select_player].element)

					dxDrawText(vehicle and ""..getVehicleNameFromModel(getElementModel(vehicle)).." ("..convertNumber(math.floor(getElementHealth(vehicle)/10)).."%)" or "Nenhum", 538, 334, 116, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10))

					dxDrawImageSpacing(860, 282, 32, 32, 5, "assets/images/eye.png", 0, 0, 0, functions.isCursorOnElement(860, 282, 32, 32) and tocolor(193, 159, 114, alpha) or tocolor(85, 83, 87, alpha))

					dxDrawRectangle(467, 375, 568, 45, (functions.isCursorOnElement(467, 375, 568, 45) and tocolor(193, 159, 114, alpha) or tocolor(32, 32, 32, alpha)))
					dxDrawText("VER ACLS", 467, 377, 568, 45, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 9), "center", "center")

					dxDrawText(math.floor(getElementHealth(data_players[select_player].element)).."%", 1121, 106, 116, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10))
					dxDrawText(math.floor(getPedArmor(data_players[select_player].element)).."%", 1135, 155, 116, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10))
					dxDrawText(math.floor(getElementModel(data_players[select_player].element)), 1136, 204, 116, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10))
					dxDrawText("Brasil", 1127, 253, 116, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10))
					dxDrawText(getPlayerPing(data_players[select_player].element).."ms", 1120, 302, 116, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10))
					dxDrawText(convertNumber(getElementDimension(data_players[select_player].element)), 1164, 351, 116, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10))
					dxDrawText(convertNumber(getElementInterior(data_players[select_player].element)), 1143, 400, 116, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10))

				else
					dxDrawText("Nenhum jogador selecionado", 465, 110, 161, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10))
				end

				dxDrawImage(441, 464, 585, 46, "assets/images/bg_search2.png", 0, 0, 0, tocolor(255, 255, 255, alpha))

				if (client.edits["SEARCH"][1] and isElement(client.edits["SEARCH"][2])) then
					dxDrawText((guiGetText(client.edits["SEARCH"][2]) or "").. "|", 499, 477, 111, 21, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 9))
					
				elseif (#guiGetText(client.edits["SEARCH"][2]) >= 1) then 
					dxDrawText((guiGetText(client.edits["SEARCH"][2]) or ""), 499, 477, 111, 21, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 9))
				else
					dxDrawText("Pesquisar jogador", 499, 477, 111, 21, tocolor(86, 86, 86, alpha), 1.0, getFont("regular", 9))
				end

				dxDrawText("Nome do jogador", 457, 520, 95, 23, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 9))
				dxDrawText("Identificador", 903, 520, 95, 23, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 9))

				line = 0 
				for i, v in ipairs(data_players) do 
					if isElement(v.element) then
						if ((guiGetText(client["edits"]["SEARCH"][2]) == "" or guiGetText(client["edits"]["SEARCH"][2]) == "Pesquisar jogador") or string.find(string.lower(getPlayerName(v.element)), string.lower(guiGetText(client["edits"]["SEARCH"][2]))) or (guiGetText(client["edits"]["SEARCH"][2]) == "" or guiGetText(client["edits"]["SEARCH"][2]) == "Pesquisar jogador") or string.find(string.lower((getElementData(v.element, "ID") or "N/A")), string.lower(guiGetText(client["edits"]["SEARCH"][2])))) then
							if (i > client.pag_index and line < 4) then 
								line = line + 1

								local count = (551 + (618 - 551) * line - (618 - 551))

								if functions.isCursorOnElement(440, count, 585, 62) or select_player == i then 
									dxDrawImage(440, count, 585, 62, "assets/images/gridlist_players.png", 0, 0, 0, tocolor(193, 159, 114, alpha))
								else
									dxDrawImage(440, count, 585, 62, "assets/images/gridlist_players.png", 0, 0, 0, tocolor(33, 33, 33, alpha))
								end

								dxDrawImageSpacing(454, count+20, 23, 23, 5, "assets/images/user.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
								dxDrawText(getPlayerName(v.element), 494, count+20, 133, 23, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10))
								dxDrawText("#"..(getElementData(v.element, "ID") or "N/A"), 858, count+20, 133, 23, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "right", "top")
							end
						end
					end
				end

				dxDrawRectangle(1234, 467, 6, 345, tocolor(59, 54, 68, alpha))

				if getKeyState("mouse1") and isCursorShowing() and (functions.isCursorOnElement(1234, 467, 6, 345) or moving) then 
					cursorY, client.pag_options = scrollBar(#client.optionsIndexPage, 7, 467, 745, "y")
					moving = true
				end

				dxDrawRectangle(1234, cursorY, 6, 65, tocolor(193, 159, 114, alpha))

				line = 0 
				for i, v in ipairs(client.optionsIndexPage) do 
					if (i > client.pag_options and line < 7) then 
						line = line + 1
						
						local count = (467 + (517 - 467) * line - (517 - 467))
						
						dxDrawRoundedRectangle(1035, count, 192, 45, 2, (functions.isCursorOnElement(1035, count, 192, 45) and tocolor(193, 159, 114, alpha) or tocolor(32, 32, 32, alpha)))
						dxDrawText(v[1], 1035, count+2, 192, 45, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 9), "center", "center")
					end
				end

				if sub_window == "acls" then 
					dxDrawImageSpacing(415, 61, 848, 778, 5, "assets/images/bg_modal.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
					dxDrawImageSpacing(989, 282, 40, 40, 5, "assets/images/close.png", 0, 0, 0, (functions.isCursorOnElement(989, 282, 40, 40) and tocolor(255, 121, 121, alpha) or tocolor(255, 255, 255, alpha)))

					dxDrawText(""..getPlayerName(data_players[select_player].element).." #"..(getElementData(data_players[select_player].element, "ID") or "N/A").."", 630, 296, 418, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "top")

					line = 0 
					for i, v in ipairs(data_players[select_player].acls) do 
						if (i > client.pag_acls and line < 7) then 
							line = line + 1

							local count = (354 + (389 - 354) * line - (389 - 354))

							dxDrawText(v, 630, count, 418, 20, tocolor(184, 181, 194, alpha), 1.0, getFont("regular", 10), "center", "top")
						end
					end

				elseif sub_window == "kick" then 
					dxDrawImageSpacing(415, 61, 848, 778, 5, "assets/images/bg_modal.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
					dxDrawImageSpacing(989, 282, 40, 40, 5, "assets/images/close.png", 0, 0, 0, (functions.isCursorOnElement(989, 282, 40, 40) and tocolor(255, 121, 121, alpha) or tocolor(255, 255, 255, alpha)))

					dxDrawText("EXPULSAR JOGADOR", 630, 296, 418, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "top")
					dxDrawText("Motivo", 679, 339, 51, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10))
					
					dxDrawRectangle(678, 368, 322, 147, tocolor(32, 32, 32, alpha/2))

					if (client.edits["EDIT"][1] and isElement(client.edits["EDIT"][2])) then
						dxDrawText((guiGetText(client.edits["EDIT"][2]) or "").. "|", 695, 379, 292, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "left", "top", false, true, false, false, false)
						
					elseif (#guiGetText(client.edits["EDIT"][2]) >= 1) then 
						dxDrawText((guiGetText(client.edits["EDIT"][2]) or ""), 695, 379, 292, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "left", "top", false, true, false, false, false)
					else
						dxDrawText("...", 695, 379, 292, 20, tocolor(104, 102, 109, alpha), 1.0, getFont("regular", 10), "left", "top", false, true, false, false, false)
					end

					dxDrawRoundedRectangle(678, 538, 322, 61, 5, (functions.isCursorOnElement(678, 538, 322, 61) and tocolor(193, 159, 114, alpha) or tocolor(32, 32, 32, alpha)))
					dxDrawText("CONFIRMAR", 678, 540, 322, 61, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")

				elseif sub_window == "mute" then 
					dxDrawImageSpacing(415, 61, 848, 778, 5, "assets/images/bg_modal.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
					dxDrawImageSpacing(989, 282, 40, 40, 5, "assets/images/close.png", 0, 0, 0, (functions.isCursorOnElement(989, 282, 40, 40) and tocolor(255, 121, 121, alpha) or tocolor(255, 255, 255, alpha)))

					dxDrawText("MUTAR JOGADOR", 630, 296, 418, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "top")
					dxDrawText("Motivo", 679, 339, 51, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10))
					
					dxDrawRectangle(678, 368, 322, 147, tocolor(32, 32, 32, alpha/2))

					if (client.edits["EDIT"][1] and isElement(client.edits["EDIT"][2])) then
						dxDrawText((guiGetText(client.edits["EDIT"][2]) or "").. "|", 695, 379, 292, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "left", "top", false, true, false, false, false)
						
					elseif (#guiGetText(client.edits["EDIT"][2]) >= 1) then 
						dxDrawText((guiGetText(client.edits["EDIT"][2]) or ""), 695, 379, 292, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "left", "top", false, true, false, false, false)
					else
						dxDrawText("...", 695, 379, 292, 20, tocolor(104, 102, 109, alpha), 1.0, getFont("regular", 10), "left", "top", false, true, false, false, false)
					end

					dxDrawRoundedRectangle(678, 538, 322, 61, 5, (functions.isCursorOnElement(678, 538, 322, 61) and tocolor(193, 159, 114, alpha) or tocolor(32, 32, 32, alpha)))
					dxDrawText("CONFIRMAR", 678, 540, 322, 61, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")

				elseif sub_window == "setnick" then 
					dxDrawImageSpacing(415, 61, 848, 778, 5, "assets/images/bg_modal.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
					dxDrawImageSpacing(989, 282, 40, 40, 5, "assets/images/close.png", 0, 0, 0, (functions.isCursorOnElement(989, 282, 40, 40) and tocolor(255, 121, 121, alpha) or tocolor(255, 255, 255, alpha)))

					dxDrawText("SETAR NICK", 630, 296, 418, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "top")
					dxDrawText("Escolha um novo nome para esta conta", 630, 344, 418, 20, tocolor(170, 170, 170, alpha), 1.0, getFont("regular", 9), "center", "top")

					dxDrawRectangle(678, 413, 322, 65, tocolor(32, 32, 32, alpha/2))

					if (client.edits["EDIT"][1] and isElement(client.edits["EDIT"][2])) then
						dxDrawText((guiGetText(client.edits["EDIT"][2]) or "").. "|", 678, 415, 322, 65, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")
						
					elseif (#guiGetText(client.edits["EDIT"][2]) >= 1) then 
						dxDrawText((guiGetText(client.edits["EDIT"][2]) or ""), 678, 415, 322, 65, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")
					else
						dxDrawText("...", 678, 415, 322, 65, tocolor(104, 102, 109, alpha), 1.0, getFont("regular", 10), "center", "center")
					end

					dxDrawRectangle(679, 509, 321, 1, tocolor(255, 255, 255, alpha/3))

					dxDrawRoundedRectangle(678, 538, 322, 61, 5, (functions.isCursorOnElement(678, 538, 322, 61) and tocolor(193, 159, 114, alpha) or tocolor(32, 32, 32, alpha)))
					dxDrawText("CONFIRMAR", 678, 540, 322, 61, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")

				elseif sub_window == "setvida" then 
					dxDrawImageSpacing(415, 61, 848, 778, 5, "assets/images/bg_modal.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
					dxDrawImageSpacing(989, 282, 40, 40, 5, "assets/images/close.png", 0, 0, 0, (functions.isCursorOnElement(989, 282, 40, 40) and tocolor(255, 121, 121, alpha) or tocolor(255, 255, 255, alpha)))

					dxDrawText("SETAR VIDA", 630, 296, 418, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "top")
					dxDrawText("Escolha a quantidade que deseja setar de vida\npara essa conta.", 630, 344, 418, 20, tocolor(170, 170, 170, alpha), 1.0, getFont("regular", 9), "center", "top")

					dxDrawRectangle(678, 413, 322, 65, tocolor(32, 32, 32, alpha/2))

					if (client.edits["EDIT"][1] and isElement(client.edits["EDIT"][2])) then
						dxDrawText((guiGetText(client.edits["EDIT"][2]) or "").. "|", 678, 415, 322, 65, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")
						
					elseif (#guiGetText(client.edits["EDIT"][2]) >= 1) then 
						dxDrawText((guiGetText(client.edits["EDIT"][2]) or ""), 678, 415, 322, 65, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")
					else
						dxDrawText("...", 678, 415, 322, 65, tocolor(104, 102, 109, alpha), 1.0, getFont("regular", 10), "center", "center")
					end

					dxDrawRectangle(679, 509, 321, 1, tocolor(255, 255, 255, alpha/3))

					dxDrawRoundedRectangle(678, 538, 322, 61, 5, (functions.isCursorOnElement(678, 538, 322, 61) and tocolor(193, 159, 114, alpha) or tocolor(32, 32, 32, alpha)))
					dxDrawText("CONFIRMAR", 678, 540, 322, 61, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")

				elseif sub_window == "setcolete" then 
					dxDrawImageSpacing(415, 61, 848, 778, 5, "assets/images/bg_modal.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
					dxDrawImageSpacing(989, 282, 40, 40, 5, "assets/images/close.png", 0, 0, 0, (functions.isCursorOnElement(989, 282, 40, 40) and tocolor(255, 121, 121, alpha) or tocolor(255, 255, 255, alpha)))

					dxDrawText("SETAR COLETE", 630, 296, 418, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "top")
					dxDrawText("Escolha a quantidade que deseja setar de vida\npara essa conta.", 630, 344, 418, 20, tocolor(170, 170, 170, alpha), 1.0, getFont("regular", 9), "center", "top")

					dxDrawRectangle(678, 413, 322, 65, tocolor(32, 32, 32, alpha/2))

					if (client.edits["EDIT"][1] and isElement(client.edits["EDIT"][2])) then
						dxDrawText((guiGetText(client.edits["EDIT"][2]) or "").. "|", 678, 415, 322, 65, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")
						
					elseif (#guiGetText(client.edits["EDIT"][2]) >= 1) then 
						dxDrawText((guiGetText(client.edits["EDIT"][2]) or ""), 678, 415, 322, 65, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")
					else
						dxDrawText("...", 678, 415, 322, 65, tocolor(104, 102, 109, alpha), 1.0, getFont("regular", 10), "center", "center")
					end

					dxDrawRectangle(679, 509, 321, 1, tocolor(255, 255, 255, alpha/3))

					dxDrawRoundedRectangle(678, 538, 322, 61, 5, (functions.isCursorOnElement(678, 538, 322, 61) and tocolor(193, 159, 114, alpha) or tocolor(32, 32, 32, alpha)))
					dxDrawText("CONFIRMAR", 678, 540, 322, 61, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")

				elseif sub_window == "setweapons" then 
					dxDrawImageSpacing(415, 61, 848, 778, 5, "assets/images/bg_modal.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
					dxDrawImageSpacing(989, 282, 40, 40, 5, "assets/images/close.png", 0, 0, 0, (functions.isCursorOnElement(989, 282, 40, 40) and tocolor(255, 121, 121, alpha) or tocolor(255, 255, 255, alpha)))

					dxDrawText("SETAR ARMAS", 630, 296, 418, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "top")

					line = 0 
					for i, v in ipairs(config.weapons) do 
						if (i > client.pag_weapons and line < 3) then 
							line = line + 1

							local count = (334 + (400 - 334) * line - (400 - 334))

							if functions.isCursorOnElement(678, count, 322, 51) or select_weapon == i then 
								dxDrawRoundedRectangle(678, count, 322, 61, 5, tocolor(193, 159, 114, alpha))
							else
								dxDrawRoundedRectangle(678, count, 322, 61, 5, tocolor(32, 32, 32, alpha/2))
							end

							dxDrawText(v[1], 678, count+2, 322, 61, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")
						end
					end

					dxDrawRoundedRectangle(678, 538, 322, 61, 5, (functions.isCursorOnElement(678, 538, 322, 61) and tocolor(193, 159, 114, alpha) or tocolor(32, 32, 32, alpha)))
					dxDrawText("CONFIRMAR", 678, 540, 322, 61, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")
				elseif sub_window == "setmoney" then 
					dxDrawImageSpacing(415, 61, 848, 778, 5, "assets/images/bg_modal.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
					dxDrawImageSpacing(989, 282, 40, 40, 5, "assets/images/close.png", 0, 0, 0, (functions.isCursorOnElement(989, 282, 40, 40) and tocolor(255, 121, 121, alpha) or tocolor(255, 255, 255, alpha)))

					dxDrawText("SETAR DINHEIRO", 630, 296, 418, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "top")
					dxDrawText("Escolha a quantidade que deseja aplicar no\nsaldo desta conta.", 630, 344, 418, 20, tocolor(170, 170, 170, alpha), 1.0, getFont("regular", 9), "center", "top")

					dxDrawRectangle(678, 413, 322, 65, tocolor(32, 32, 32, alpha/2))

					if (client.edits["EDIT"][1] and isElement(client.edits["EDIT"][2])) then
						dxDrawText((guiGetText(client.edits["EDIT"][2]) or "").. "|", 678, 415, 322, 65, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")
						
					elseif (#guiGetText(client.edits["EDIT"][2]) >= 1) then 
						dxDrawText((guiGetText(client.edits["EDIT"][2]) or ""), 678, 415, 322, 65, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")
					else
						dxDrawText("...", 678, 415, 322, 65, tocolor(104, 102, 109, alpha), 1.0, getFont("regular", 10), "center", "center")
					end

					dxDrawRoundedRectangle(679, 494, 30, 25, 3, (select_money == "money") and tocolor(193, 159, 114, alpha) or tocolor(64, 60, 75, alpha))
					dxDrawRoundedRectangle(813, 494, 30, 25, 3, (select_money == "pontos") and tocolor(193, 159, 114, alpha) or tocolor(64, 60, 75, alpha))
					dxDrawRoundedRectangle(907, 494, 30, 25, 3, (select_money == "bank") and tocolor(193, 159, 114, alpha) or tocolor(64, 60, 75, alpha))

					dxDrawText("Dinheiro", 720, 496, 61, 20, tocolor(170, 170, 170, alpha), 1.0, getFont("regular", 10))
					dxDrawText("GP", 855, 496, 61, 20, tocolor(170, 170, 170, alpha), 1.0, getFont("regular", 10))
					dxDrawText("Banco", 947, 496, 61, 20, tocolor(170, 170, 170, alpha), 1.0, getFont("regular", 10))

					dxDrawRoundedRectangle(678, 538, 322, 61, 5, (functions.isCursorOnElement(678, 538, 322, 61) and tocolor(193, 159, 114, alpha) or tocolor(32, 32, 32, alpha)))
					dxDrawText("CONFIRMAR", 678, 540, 322, 61, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")

				elseif sub_window == "setvehicle" then 
					dxDrawImageSpacing(415, 61, 848, 778, 5, "assets/images/bg_modal.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
					dxDrawImageSpacing(989, 282, 40, 40, 5, "assets/images/close.png", 0, 0, 0, (functions.isCursorOnElement(989, 282, 40, 40) and tocolor(255, 121, 121, alpha) or tocolor(255, 255, 255, alpha)))

					dxDrawText("SETAR VEÍCULO", 630, 296, 418, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "top")
					dxDrawText("Escolha o veículo (ID) que deseja setar\nno jogador.", 630, 344, 418, 20, tocolor(170, 170, 170, alpha), 1.0, getFont("regular", 9), "center", "top")

					dxDrawRectangle(678, 413, 322, 65, tocolor(32, 32, 32, alpha/2))

					if (client.edits["EDIT"][1] and isElement(client.edits["EDIT"][2])) then
						dxDrawText((guiGetText(client.edits["EDIT"][2]) or "").. "|", 678, 415, 322, 65, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")
						
					elseif (#guiGetText(client.edits["EDIT"][2]) >= 1) then 
						dxDrawText((guiGetText(client.edits["EDIT"][2]) or ""), 678, 415, 322, 65, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")
					else
						dxDrawText("...", 678, 415, 322, 65, tocolor(104, 102, 109, alpha), 1.0, getFont("regular", 10), "center", "center")
					end

					dxDrawRectangle(679, 509, 321, 1, tocolor(255, 255, 255, alpha/3))

					dxDrawRoundedRectangle(678, 538, 322, 61, 5, (functions.isCursorOnElement(678, 538, 322, 61) and tocolor(193, 159, 114, alpha) or tocolor(32, 32, 32, alpha)))
					dxDrawText("CONFIRMAR", 678, 540, 322, 61, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")

				elseif sub_window == "setdimension" then 
					dxDrawImageSpacing(415, 61, 848, 778, 5, "assets/images/bg_modal.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
					dxDrawImageSpacing(989, 282, 40, 40, 5, "assets/images/close.png", 0, 0, 0, (functions.isCursorOnElement(989, 282, 40, 40) and tocolor(255, 121, 121, alpha) or tocolor(255, 255, 255, alpha)))

					dxDrawText("SETAR DIMENSÃO", 630, 296, 418, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "top")
					dxDrawText("Escolha a dimensão que deseja setar\nno jogador.", 630, 344, 418, 20, tocolor(170, 170, 170, alpha), 1.0, getFont("regular", 9), "center", "top")

					dxDrawRectangle(678, 413, 322, 65, tocolor(32, 32, 32, alpha/2))

					if (client.edits["EDIT"][1] and isElement(client.edits["EDIT"][2])) then
						dxDrawText((guiGetText(client.edits["EDIT"][2]) or "").. "|", 678, 415, 322, 65, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")
						
					elseif (#guiGetText(client.edits["EDIT"][2]) >= 1) then 
						dxDrawText((guiGetText(client.edits["EDIT"][2]) or ""), 678, 415, 322, 65, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")
					else
						dxDrawText("...", 678, 415, 322, 65, tocolor(104, 102, 109, alpha), 1.0, getFont("regular", 10), "center", "center")
					end

					dxDrawRectangle(679, 509, 321, 1, tocolor(255, 255, 255, alpha/3))

					dxDrawRoundedRectangle(678, 538, 322, 61, 5, (functions.isCursorOnElement(678, 538, 322, 61) and tocolor(193, 159, 114, alpha) or tocolor(32, 32, 32, alpha)))
					dxDrawText("CONFIRMAR", 678, 540, 322, 61, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")

				elseif sub_window == "setinterior" then 
					dxDrawImageSpacing(415, 61, 848, 778, 5, "assets/images/bg_modal.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
					dxDrawImageSpacing(989, 282, 40, 40, 5, "assets/images/close.png", 0, 0, 0, (functions.isCursorOnElement(989, 282, 40, 40) and tocolor(255, 121, 121, alpha) or tocolor(255, 255, 255, alpha)))

					dxDrawText("SETAR INTERIOR", 630, 296, 418, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "top")
					dxDrawText("Escolha o interior que deseja setar\nno jogador.", 630, 344, 418, 20, tocolor(170, 170, 170, alpha), 1.0, getFont("regular", 9), "center", "top")

					dxDrawRectangle(678, 413, 322, 65, tocolor(32, 32, 32, alpha/2))

					if (client.edits["EDIT"][1] and isElement(client.edits["EDIT"][2])) then
						dxDrawText((guiGetText(client.edits["EDIT"][2]) or "").. "|", 678, 415, 322, 65, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")
						
					elseif (#guiGetText(client.edits["EDIT"][2]) >= 1) then 
						dxDrawText((guiGetText(client.edits["EDIT"][2]) or ""), 678, 415, 322, 65, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")
					else
						dxDrawText("...", 678, 415, 322, 65, tocolor(104, 102, 109, alpha), 1.0, getFont("regular", 10), "center", "center")
					end

					dxDrawRectangle(679, 509, 321, 1, tocolor(255, 255, 255, alpha/3))

					dxDrawRoundedRectangle(678, 538, 322, 61, 5, (functions.isCursorOnElement(678, 538, 322, 61) and tocolor(193, 159, 114, alpha) or tocolor(32, 32, 32, alpha)))
					dxDrawText("CONFIRMAR", 678, 540, 322, 61, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")

				end

			elseif window == "resources" then
				dxDrawImageSpacing(437, 83, 580, 145, 0, "assets/images/bg_resources.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
				dxDrawText("Resource Selecionado", 465, 104, 161, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10))
				
				if select_resource then 
					dxDrawText("Nome:", 467, 145, 161, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10))
					dxDrawText("Dev:", 467, 185, 161, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10))
					dxDrawText("IPB:", 741, 145, 161, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10))
					dxDrawText("Versão:", 741, 185, 161, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10))

					dxDrawText(resource_selected.name, 526, 145, 195, 20, tocolor(193, 159, 114, alpha), 1.0, getFont("regular", 10), "left", "top", true, false, false, false, false)
					dxDrawText(resource_selected.dev, 513, 185, 195, 20, tocolor(193, 159, 114, alpha), 1.0, getFont("regular", 10), "left", "top", true, false, false, false, false)
					dxDrawText(resource_selected.version, 810, 185, 195, 20, tocolor(193, 159, 114, alpha), 1.0, getFont("regular", 10), "left", "top", true, false, false, false, false)
					dxDrawText("Não especificado", 782, 145, 195, 20, tocolor(193, 159, 114, alpha), 1.0, getFont("regular", 10), "left", "top", true, false, false, false, false)
				else
					dxDrawText("Nenhum resource selecionado", 465, 155, 161, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10))
				end

				dxDrawRectangle(1035, 83, 203, 45, (functions.isCursorOnElement(1035, 83, 203, 45) and tocolor(193, 159, 114, alpha) or tocolor(32, 32, 32, alpha)))
				dxDrawRectangle(1035, 132, 203, 45, (functions.isCursorOnElement(1035, 132, 203, 45) and tocolor(193, 159, 114, alpha) or tocolor(32, 32, 32, alpha)))
				dxDrawRectangle(1035, 182, 203, 45, (functions.isCursorOnElement(1035, 182, 203, 45) and tocolor(193, 159, 114, alpha) or tocolor(32, 32, 32, alpha)))
				dxDrawText("DESLIGAR", 1035, 84, 203, 45, tocolor(255, 255, 255, alpha), 1.0, getFont("medium", 9), "center", "center")
				dxDrawText("LIGAR", 1035, 133, 203, 45, tocolor(255, 255, 255, alpha), 1.0, getFont("medium", 9), "center", "center")
				dxDrawText("REINICIAR", 1035, 183, 203, 45, tocolor(255, 255, 255, alpha), 1.0, getFont("medium", 9), "center", "center")

				dxDrawImage(437, 245, 525, 58, "assets/images/bg_executecommand.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
				dxDrawImageSpacing(456, 259, 31, 31, 5, "assets/images/computer.png", 0, 0, 0, tocolor(255, 255, 255, alpha))

				if (client.edits["EXECUTECOMMAND"][1] and isElement(client.edits["EXECUTECOMMAND"][2])) then
					dxDrawText((guiGetText(client.edits["EXECUTECOMMAND"][2]) or "").. "|", 510, 264, 427, 21, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 9), "left", "top", true, false, false, false, false)
					
				elseif (#guiGetText(client.edits["EXECUTECOMMAND"][2]) >= 1) then 
					dxDrawText((guiGetText(client.edits["EXECUTECOMMAND"][2]) or ""), 510, 264, 427, 21, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 9), "left", "top", true, false, false, false, false)
				else
					dxDrawText("EXECUTE COMMAND", 510, 264, 427, 21, tocolor(86, 86, 86, alpha), 1.0, getFont("regular", 9), "left", "top", true, false, false, false, false)
				end

				dxDrawImage(968, 245, 134, 58, "assets/images/button_executecommand.png", 0, 0, 0, (functions.isCursorOnElement(968, 245, 134, 58) and tocolor(193, 159, 114, alpha) or tocolor(33, 33, 33, alpha)))
				dxDrawImage(1106, 245, 134, 58, "assets/images/button_executecommand.png", 0, 0, 0, (functions.isCursorOnElement(1106, 245, 134, 58) and tocolor(193, 159, 114, alpha) or tocolor(33, 33, 33, alpha)))
				dxDrawText("SERVER", 968, 245, 134, 58, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 9), "center", "center")
				dxDrawText("CLIENT", 1106, 245, 134, 58, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 9), "center", "center")

				dxDrawImageSpacing(437, 322, 803, 2, 5, "assets/images/line.png", 0, 0, 0, tocolor(255, 255, 255, alpha/3))
				dxDrawImage(437, 336, 801, 58, "assets/images/bg_search.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
				dxDrawImageSpacing(455, 351, 28, 28, 5, "assets/images/lupa.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
				
				if (client.edits["SEARCH"][1] and isElement(client.edits["SEARCH"][2])) then
					dxDrawText((guiGetText(client.edits["SEARCH"][2]) or "").. "|", 507, 355, 111, 21, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 9))
					
				elseif (#guiGetText(client.edits["SEARCH"][2]) >= 1) then 
					dxDrawText((guiGetText(client.edits["SEARCH"][2]) or ""), 507, 355, 111, 21, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 9))
				else
					dxDrawText("Pesquisar resource", 507, 355, 111, 21, tocolor(86, 86, 86, alpha), 1.0, getFont("regular", 9))
				end

				dxDrawRectangle(1234, 412, 6, 397, tocolor(59, 54, 68, alpha))

				if getKeyState("mouse1") and isCursorShowing() and (functions.isCursorOnElement(1234, 412, 6, 397) or moving) then 
					cursorY, client.pag_resources = scrollBar(#client.optionsIndexPage, 6, 412, 744, "y")
					moving = true
				end

				dxDrawRectangle(1234, cursorY, 6, 65, tocolor(193, 159, 114, alpha))

				line = 0 
				for i, v in ipairs(data_resources) do 
					if ((guiGetText(client["edits"]["SEARCH"][2]) == "" or guiGetText(client["edits"]["SEARCH"][2]) == "Pesquisar resources") or string.find(string.lower(v.name), string.lower(guiGetText(client["edits"]["SEARCH"][2]))) or (guiGetText(client["edits"]["SEARCH"][2]) == "" or guiGetText(client["edits"]["SEARCH"][2]) == "Pesquisar resources")) then
						if (i > client.pag_resources and line < 6) then 
							line = line + 1

							local count = (412 + (479 - 412) * line - (479 - 412))

							if functions.isCursorOnElement(437, count, 790, 62) or select_resource == i then 
								dxDrawImage(437, count, 790, 62, "assets/images/gridlist.png", 0, 0, 0, tocolor(193, 159, 114, alpha))
							else
								dxDrawImage(437, count, 790, 62, "assets/images/gridlist.png", 0, 0, 0, tocolor(33, 33, 33, alpha))
							end

							dxDrawImageSpacing(456, count +15, 33, 33, 5, "assets/images/resources.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
							dxDrawText(v.name, 516, count+20, 133, 23, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10))
							dxDrawText(v.state, 1070, count+20, 133, 23, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "right", "top")
						end
					end
				end

			elseif window == "server" then
				dxDrawImageSpacing(432, 82, 585, 395, 5, "assets/images/bg_server.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
				dxDrawImageSpacing(458, 361, 543, 2, 5, "assets/images/line.png", 0, 0, 0, tocolor(255, 255, 255, alpha/3))

				dxDrawText("Horário:", 460, 117, 53, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10))
				dxDrawText("Gravidade:", 460, 167, 53, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10))
				dxDrawText("Velocidade do jogo:", 460, 217, 53, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10))
				dxDrawText("Altura da onda:", 460, 267, 53, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10))
				dxDrawText("Frames (FPS):", 460, 317, 53, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10))
				dxDrawText("Tempo (clima):", 460, 374, 53, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10))

				dxDrawText(data_config.hour, 527, 117, 53, 20, tocolor(193, 159, 114, alpha), 1.0, getFont("regular", 10))
				dxDrawText(mathfloorcustom(data_config.gravity), 552, 167, 53, 20, tocolor(193, 159, 114, alpha), 1.0, getFont("regular", 10))
				dxDrawText(data_config.gamespeed, 620, 217, 53, 20, tocolor(193, 159, 114, alpha), 1.0, getFont("regular", 10))
				dxDrawText(data_config.wave_height, 588, 267, 53, 20, tocolor(193, 159, 114, alpha), 1.0, getFont("regular", 10))
				dxDrawText(data_config.fps_limit, 580, 317, 53, 20, tocolor(193, 159, 114, alpha), 1.0, getFont("regular", 10))
				dxDrawText(select_weather.." ("..config.weatherTemp[select_weather]..")", 585, 374, 53, 20, tocolor(193, 159, 114, alpha), 1.0, getFont("regular", 10))

				dxDrawRectangle(460, 412, 336, 44, tocolor(32, 32, 32, alpha))
				dxDrawImage(750, 419, 38, 31, "assets/images/arrowleft.png", 0, 0, 0, (functions.isCursorOnElement(750, 419, 38, 31) and tocolor(255, 255, 255, alpha/1.5) or tocolor(255, 255, 255, alpha)))
				dxDrawImage(469, 419, 38, 31, "assets/images/arrowright.png", 0, 0, 0, (functions.isCursorOnElement(469, 419, 38, 31) and tocolor(255, 255, 255, alpha/1.5) or tocolor(255, 255, 255, alpha)))
				dxDrawText(select_weather.." ("..config.weatherTemp[select_weather]..")", 460, 414, 336, 44, tocolor(183, 183, 183, alpha), 1.0, getFont("regular", 8), "center", "center")

				dxDrawRectangle(805, 412, 134, 44, (functions.isCursorOnElement(805, 412, 134, 44) and tocolor(193, 159, 114, alpha) or tocolor(32, 32, 32, alpha)))
				dxDrawText("SET", 805, 414, 134, 44, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")

				dxDrawRectangle(644, 106, 84, 41, tocolor(32, 32, 32, alpha/5))
				dxDrawRectangle(737, 106, 84, 41, tocolor(32, 32, 32, alpha/5))
				dxDrawRectangle(644, 156, 177, 41, tocolor(32, 32, 32, alpha/5))
				dxDrawRectangle(644, 206, 177, 41, tocolor(32, 32, 32, alpha/5))
				dxDrawRectangle(644, 256, 177, 41, tocolor(32, 32, 32, alpha/5))
				dxDrawRectangle(644, 306, 177, 41, tocolor(32, 32, 32, alpha/5))

				if (client.edits["TIMESET/HOUR"][1] and isElement(client.edits["TIMESET/HOUR"][2])) then
					dxDrawText((guiGetText(client.edits["TIMESET/HOUR"][2]) or "").. "|", 644, 108, 84, 41, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")
					
				elseif (#guiGetText(client.edits["TIMESET/HOUR"][2]) >= 1) then 
					dxDrawText((guiGetText(client.edits["TIMESET/HOUR"][2]) or ""), 644, 108, 84, 41, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")
				else
					dxDrawText("00", 644, 108, 84, 41, tocolor(68, 65, 75, alpha), 1.0, getFont("regular", 10), "center", "center")
				end

				if (client.edits["TIMESET/MINUTE"][1] and isElement(client.edits["TIMESET/MINUTE"][2])) then
					dxDrawText((guiGetText(client.edits["TIMESET/MINUTE"][2]) or "").. "|", 737, 108, 84, 41, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")
					
				elseif (#guiGetText(client.edits["TIMESET/MINUTE"][2]) >= 1) then 
					dxDrawText((guiGetText(client.edits["TIMESET/MINUTE"][2]) or ""), 737, 108, 84, 41, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")
				else
					dxDrawText("00", 737, 108, 84, 41, tocolor(68, 65, 75, alpha), 1.0, getFont("regular", 10), "center", "center")
				end

				if (client.edits["GRAVITY"][1] and isElement(client.edits["GRAVITY"][2])) then
					dxDrawText((guiGetText(client.edits["GRAVITY"][2]) or "").. "|", 644, 158, 177, 41, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")
					
				elseif (#guiGetText(client.edits["GRAVITY"][2]) >= 1) then 
					dxDrawText((guiGetText(client.edits["GRAVITY"][2]) or ""), 644, 158, 177, 41, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")
				else
					dxDrawText(mathfloorcustom(data_config.gravity), 644, 158, 177, 41, tocolor(68, 65, 75, alpha), 1.0, getFont("regular", 10), "center", "center")
				end

				if (client.edits["GAMESPEED"][1] and isElement(client.edits["GAMESPEED"][2])) then
					dxDrawText((guiGetText(client.edits["GAMESPEED"][2]) or "").. "|", 644, 208, 177, 41, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")
					
				elseif (#guiGetText(client.edits["GAMESPEED"][2]) >= 1) then 
					dxDrawText((guiGetText(client.edits["GAMESPEED"][2]) or ""), 644, 208, 177, 41, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")
				else
					dxDrawText(data_config.gamespeed, 644, 208, 177, 41, tocolor(68, 65, 75, alpha), 1.0, getFont("regular", 10), "center", "center")
				end

				if (client.edits["WAVEHEIGHT"][1] and isElement(client.edits["WAVEHEIGHT"][2])) then
					dxDrawText((guiGetText(client.edits["WAVEHEIGHT"][2]) or "").. "|", 644, 258, 177, 41, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")
					
				elseif (#guiGetText(client.edits["WAVEHEIGHT"][2]) >= 1) then 
					dxDrawText((guiGetText(client.edits["WAVEHEIGHT"][2]) or ""), 644, 258, 177, 41, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")
				else
					dxDrawText(data_config.wave_height, 644, 258, 177, 41, tocolor(68, 65, 75, alpha), 1.0, getFont("regular", 10), "center", "center")
				end
				
				if (client.edits["FPS"][1] and isElement(client.edits["FPS"][2])) then
					dxDrawText((guiGetText(client.edits["FPS"][2]) or "").. "|", 644, 308, 177, 41, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")
					
				elseif (#guiGetText(client.edits["FPS"][2]) >= 1) then 
					dxDrawText((guiGetText(client.edits["FPS"][2]) or ""), 644, 308, 177, 41, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")
				else
					dxDrawText(data_config.fps_limit, 644, 308, 177, 41, tocolor(68, 65, 75, alpha), 1.0, getFont("regular", 10), "center", "center")
				end

				dxDrawRectangle(826, 106, 115, 41, (functions.isCursorOnElement(826, 106, 115, 41) and tocolor(193, 159, 114, alpha) or tocolor(32, 32, 32, alpha)))
				dxDrawRectangle(826, 156, 115, 41, (functions.isCursorOnElement(826, 156, 115, 41) and tocolor(193, 159, 114, alpha) or tocolor(32, 32, 32, alpha)))
				dxDrawRectangle(826, 206, 115, 41, (functions.isCursorOnElement(826, 206, 115, 41) and tocolor(193, 159, 114, alpha) or tocolor(32, 32, 32, alpha)))
				dxDrawRectangle(826, 256, 115, 41, (functions.isCursorOnElement(826, 256, 115, 41) and tocolor(193, 159, 114, alpha) or tocolor(32, 32, 32, alpha)))
				dxDrawRectangle(826, 306, 115, 41, (functions.isCursorOnElement(826, 306, 115, 41) and tocolor(193, 159, 114, alpha) or tocolor(32, 32, 32, alpha)))
				
				dxDrawText("SET", 826, 108, 115, 41, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")
				dxDrawText("SET", 826, 158, 115, 41, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")
				dxDrawText("SET", 826, 208, 115, 41, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")
				dxDrawText("SET", 826, 258, 115, 41, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")
				dxDrawText("SET", 826, 308, 115, 41, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")

				dxDrawRectangle(1039, 83, 203, 45, (functions.isCursorOnElement(1039, 83, 203, 45) and tocolor(193, 159, 114, alpha) or tocolor(32, 32, 32, alpha)))
				dxDrawRectangle(1039, 133, 203, 45, (functions.isCursorOnElement(1039, 133, 203, 45) and tocolor(193, 159, 114, alpha) or tocolor(32, 32, 32, alpha)))
				dxDrawRectangle(1039, 183, 203, 45, (functions.isCursorOnElement(1039, 183, 203, 45) and tocolor(193, 159, 114, alpha) or tocolor(32, 32, 32, alpha)))
				dxDrawRectangle(1039, 233, 203, 45, (functions.isCursorOnElement(1039, 233, 203, 45) and tocolor(193, 159, 114, alpha) or tocolor(32, 32, 32, alpha)))
				dxDrawRectangle(1039, 283, 203, 45, (functions.isCursorOnElement(1039, 283, 203, 45) and tocolor(193, 159, 114, alpha) or tocolor(32, 32, 32, alpha)))
				dxDrawRectangle(1039, 333, 203, 45, (functions.isCursorOnElement(1039, 333, 203, 45) and tocolor(193, 159, 114, alpha) or tocolor(32, 32, 32, alpha)))
				dxDrawRectangle(1039, 383, 203, 45, (functions.isCursorOnElement(1039, 383, 203, 45) and tocolor(193, 159, 114, alpha) or tocolor(32, 32, 32, alpha)))
				dxDrawRectangle(1039, 433, 203, 45, (functions.isCursorOnElement(1039, 433, 203, 45) and tocolor(193, 159, 114, alpha) or tocolor(32, 32, 32, alpha)))

				dxDrawText("DEFINIR SENHA", 1039, 85, 203, 45, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 8), "center", "center")
				dxDrawText("RESETAR SENHA", 1039, 135, 203, 45, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 8), "center", "center")
				dxDrawText("MUDAR GAMETYPE", 1039, 185, 203, 45, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 8), "center", "center")
				dxDrawText("INICIAR MANUTENÇÃO", 1039, 235, 203, 45, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 8), "center", "center")
				dxDrawText("EXPULSAR TODOS", 1039, 285, 203, 45, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 8), "center", "center")
				dxDrawText("SENHA AUTOMATICA", 1039, 335, 203, 45, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 8), "center", "center")
				dxDrawText("MANUTENÇÃO ATIVA", 1039, 385, 203, 45, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 8), "center", "center")
				dxDrawText("CLEAR CHAT", 1039, 435, 203, 45, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 8), "center", "center")

				dxDrawRectangle(437, 498, 805, 1, tocolor(60, 57, 70, alpha))

				if sub_window == "setpassword" then 
					dxDrawImageSpacing(415, 61, 848, 778, 5, "assets/images/bg_modal.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
					dxDrawImageSpacing(989, 282, 40, 40, 5, "assets/images/close.png", 0, 0, 0, (functions.isCursorOnElement(989, 282, 40, 40) and tocolor(255, 121, 121, alpha) or tocolor(255, 255, 255, alpha)))

					dxDrawText("SETAR SENHA", 630, 296, 418, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "top")
					dxDrawText("Escolha a senha que deseja setar\nno servidor.", 630, 344, 418, 20, tocolor(170, 170, 170, alpha), 1.0, getFont("regular", 9), "center", "top")

					dxDrawRectangle(678, 413, 322, 65, tocolor(32, 32, 32, alpha/2))

					if (client.edits["EDIT"][1] and isElement(client.edits["EDIT"][2])) then
						dxDrawText((guiGetText(client.edits["EDIT"][2]) or "").. "|", 678, 415, 322, 65, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")
						
					elseif (#guiGetText(client.edits["EDIT"][2]) >= 1) then 
						dxDrawText((guiGetText(client.edits["EDIT"][2]) or ""), 678, 415, 322, 65, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")
					else
						dxDrawText("...", 678, 415, 322, 65, tocolor(104, 102, 109, alpha), 1.0, getFont("regular", 10), "center", "center")
					end

					dxDrawRectangle(679, 509, 321, 1, tocolor(255, 255, 255, alpha/3))

					dxDrawRoundedRectangle(678, 538, 322, 61, 5, (functions.isCursorOnElement(678, 538, 322, 61) and tocolor(193, 159, 114, alpha) or tocolor(32, 32, 32, alpha)))
					dxDrawText("CONFIRMAR", 678, 540, 322, 61, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")

				elseif sub_window == "changeGameType" then 
					dxDrawImageSpacing(415, 61, 848, 778, 5, "assets/images/bg_modal.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
					dxDrawImageSpacing(989, 282, 40, 40, 5, "assets/images/close.png", 0, 0, 0, (functions.isCursorOnElement(989, 282, 40, 40) and tocolor(255, 121, 121, alpha) or tocolor(255, 255, 255, alpha)))

					dxDrawText("SETAR GAMETYPE", 630, 296, 418, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "top")
					dxDrawText("Escolha o gametype que deseja setar\nno servidor.", 630, 344, 418, 20, tocolor(170, 170, 170, alpha), 1.0, getFont("regular", 9), "center", "top")

					dxDrawRectangle(678, 413, 322, 65, tocolor(32, 32, 32, alpha/2))

					if (client.edits["EDIT"][1] and isElement(client.edits["EDIT"][2])) then
						dxDrawText((guiGetText(client.edits["EDIT"][2]) or "").. "|", 678, 415, 322, 65, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")
						
					elseif (#guiGetText(client.edits["EDIT"][2]) >= 1) then 
						dxDrawText((guiGetText(client.edits["EDIT"][2]) or ""), 678, 415, 322, 65, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")
					else
						dxDrawText("...", 678, 415, 322, 65, tocolor(104, 102, 109, alpha), 1.0, getFont("regular", 10), "center", "center")
					end

					dxDrawRectangle(679, 509, 321, 1, tocolor(255, 255, 255, alpha/3))

					dxDrawRoundedRectangle(678, 538, 322, 61, 5, (functions.isCursorOnElement(678, 538, 322, 61) and tocolor(193, 159, 114, alpha) or tocolor(32, 32, 32, alpha)))
					dxDrawText("CONFIRMAR", 678, 540, 322, 61, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")

				end

			elseif window == "registers" then 
				dxDrawImageSpacing(433, 83, 809, 726, 5, "assets/images/bg_registers.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
				dxDrawText("Registros gerais", 465, 111, 60, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10))
				dxDrawText("Data", 1169, 111, 60, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10))

				for i = 1, 9 do 
					local index = #data_logs - client.pag_logs - i + 1

					if index > 0 then 
						local v = data_logs[index]

						local count = (149 + (220 - 149) * i - (220 - 149))

						--dxDrawRectangle(445, count, 785, 68, (functions.isCursorOnElement(445, count, 785, 68) and tocolor(50, 48, 57, alpha) or tocolor(32, 32, 32, alpha)))

						dxDrawText(v.data, 466, count+24, 625, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "left", "top", true, false, false, false, false)

						dxDrawText(timestampToDateString(v.timestamp), 1109, count+24, 96, 20, tocolor(137, 137, 137, alpha), 1.0, getFont("regular", 10), "right", "top")
					end	
				end

			elseif window == "bans" then 
				dxDrawImageSpacing(433, 83, 809, 645, 5, "assets/images/bg_bans.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
				dxDrawText("Banidos", 466, 111, 60, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10))
				dxDrawText("Responsável", 746, 111, 60, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10))
				dxDrawText("Status do ban", 1100, 111, 60, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10))

				line = 0 
				for i, v in ipairs(data_bans) do 
					if (i > client.pag_bans and line < 8) then 
						line = line + 1

						local count = (149 + (220 - 149) * line - (220 - 149))

						if functions.isCursorOnElement(445, count, 785, 68) or select_ban == i then 
							dxDrawRectangle(445, count, 785, 68, tocolor(193, 159, 114, alpha))
						else
							dxDrawRectangle(445, count, 785, 68, tocolor(32, 32, 32, alpha))
						end

						dxDrawText(""..v.account.." #"..v.id.."", 466, count+24, 103, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10))
						dxDrawText(v.author, 746, count+24, 103, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "top")
						if v.time == 0 then 
							dxDrawText("Permanente", 1105, count+24, 103, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "right", "top")
						else
							dxDrawText(""..math.floor(v.time / 60).." minutos", 1105, count+24, 103, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "right", "top")
						end
					end
				end

				dxDrawRectangle(1015, 748, 215, 49, (functions.isCursorOnElement(1015, 748, 215, 49) and tocolor(193, 159, 114, alpha) or tocolor(32, 32, 32, alpha)))
				dxDrawText("DESBANIR", 1015, 750, 215, 49, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")

			elseif window == "aclmanager" then
				dxDrawImageSpacing(434, 82, 461, 615, 5, "assets/images/bg_aclmanager.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
				dxDrawText("Gerenciador de ACL", 453, 104, 142, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10))

				if not select_group and select_group == nil then
					line = 0 
					for i, v in ipairs(data_groups) do 
						if ((guiGetText(client["edits"]["SEARCH"][2]) == "" or guiGetText(client["edits"]["SEARCH"][2]) == "Pesquisar resources") or string.find(string.lower(v.name), string.lower(guiGetText(client["edits"]["SEARCH"][2]))) or (guiGetText(client["edits"]["SEARCH"][2]) == "" or guiGetText(client["edits"]["SEARCH"][2]) == "Pesquisar resources")) then
							if (i > client.pag_groups and line < 17) then 
								line = line + 1

								local count = (144 + (176 - 144) * line - (176 - 144))

								if functions.isCursorOnElement(476, count, 295, 20) then 
									dxDrawImageSpacing(453, count+5, 11, 11, 5, "assets/images/polygon.png", 0, 0, 0, tocolor(193, 159, 114, alpha))
									dxDrawText(v[1], 476, count, 68, 20, tocolor(193, 159, 114, alpha), 1.0, getFont("regular", 10))
								else
									dxDrawImageSpacing(453, count+5, 11, 11, 5, "assets/images/polygon.png", 0, 0, 0, tocolor(108, 104, 119, alpha))
									dxDrawText(v[1], 476, count, 68, 20, tocolor(108, 104, 119, alpha), 1.0, getFont("regular", 10))
								end
							end
						end
					end
				end

				dxDrawRectangle(912, 83, 322, 61, tocolor(34, 34, 34, alpha))

				if (client.edits["ID"][1] and isElement(client.edits["ID"][2])) then
					dxDrawText((guiGetText(client.edits["ID"][2]) or "").. "|", 912, 85, 322, 61, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")
					
				elseif (#guiGetText(client.edits["ID"][2]) >= 1) then 
					dxDrawText((guiGetText(client.edits["ID"][2]) or ""), 912, 85, 322, 61, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")
				else
					dxDrawText("ID/RG", 912, 85, 322, 61, tocolor(86, 86, 86, alpha), 1.0, getFont("regular", 10), "center", "center")
				end

				dxDrawRectangle(912, 149, 322, 61, (functions.isCursorOnElement(912, 149, 322, 61) and tocolor(193, 159, 114, alpha) or tocolor(32, 32, 32, alpha)))
				dxDrawRectangle(912, 215, 322, 61, (functions.isCursorOnElement(912, 215, 322, 61) and tocolor(193, 159, 114, alpha) or tocolor(32, 32, 32, alpha)))
				dxDrawText("ADICIONAR NA ACL", 912, 151, 322, 61, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")
				dxDrawText("REMOVER DA ACL", 912, 217, 322, 61, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")

				dxDrawText("CRIADOR DE ACL", 912, 469, 117, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10))

				dxDrawRectangle(912, 501, 322, 61, tocolor(34, 34, 34, alpha))

				if (client.edits["ACL"][1] and isElement(client.edits["ACL"][2])) then
					dxDrawText((guiGetText(client.edits["ACL"][2]) or "").. "|", 912, 503, 322, 61, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")
					
				elseif (#guiGetText(client.edits["ACL"][2]) >= 1) then 
					dxDrawText((guiGetText(client.edits["ACL"][2]) or ""), 912, 503, 322, 61, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")
				else
					dxDrawText("NOME DA ACL", 912, 503, 322, 61, tocolor(86, 86, 86, alpha), 1.0, getFont("regular", 10), "center", "center")
				end

				dxDrawRectangle(912, 569, 322, 61, (functions.isCursorOnElement(912, 569, 322, 61) and tocolor(193, 159, 114, alpha) or tocolor(32, 32, 32, alpha)))
				dxDrawRectangle(912, 637, 322, 61, (functions.isCursorOnElement(912, 637, 322, 61) and tocolor(193, 159, 114, alpha) or tocolor(32, 32, 32, alpha)))
				dxDrawText("CRIAR ACL", 912, 571, 322, 61, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")
				dxDrawText("EXCLUIR ACL", 912, 639, 322, 61, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")

				if select_group and select_group ~= nil and select_group ~= 0 then 
					dxDrawImageSpacing(434, 82, 461, 615, 5, "assets/images/bg_aclselect.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
					dxDrawImageSpacing(844, 92, 40, 40, 5, "assets/images/close.png", 0, 0, 0, (functions.isCursorOnElement(844, 92, 40, 40) and tocolor(255, 121, 121, alpha) or tocolor(255, 255, 255, alpha)))
					
					dxDrawText(data_groups[select_group][1]..":", 460, 102, 80, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10))

					line = 0
					for i, v in ipairs(data_groups[select_group][2]) do 
						if (i > client.pag_groups and line < 17) then 
							line = line + 1

							local count = (144 + (176 - 144) * line - (176 - 144))
							dxDrawText(v, 460, count, 95, 20, tocolor(108, 104, 119, alpha), 1.0, getFont("regular", 10))
						end
					end
				end

			elseif window == "punishment" then 
				dxDrawImageSpacing(434, 82, 461, 615, 5, "assets/images/bg_aclmanager.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
				dxDrawText("Punições aplicáveis", 453, 104, 142, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10))

				line = 0
				for i, v in ipairs(config.punishment.reasons) do 
					if (i > client.pag_punishment and line < 17) then 
						line = line + 1

						local count = (144 + (176 - 144) * line - (176 - 144))

						if functions.isCursorOnElement(476, count, 295, 20) or selectReasons[v.name] then 
							dxDrawImageSpacing(453, count+5, 11, 11, 5, "assets/images/polygon.png", 0, 0, 0, tocolor(193, 159, 114, alpha))
							dxDrawText(""..v.name.." ( "..v.minutes.." minutos )", 476, count, 68, 20, tocolor(193, 159, 114, alpha), 1.0, getFont("regular", 10))
						else
							dxDrawImageSpacing(453, count+5, 11, 11, 5, "assets/images/polygon.png", 0, 0, 0, tocolor(108, 104, 119, alpha))
							dxDrawText(""..v.name.." ( "..v.minutes.." minutos )", 476, count, 68, 20, tocolor(108, 104, 119, alpha), 1.0, getFont("regular", 10))
						end 
					end
				end

				dxDrawRectangle(912, 83, 322, 61, tocolor(34, 34, 34, alpha))

				if (client.edits["ID"][1] and isElement(client.edits["ID"][2])) then
					dxDrawText((guiGetText(client.edits["ID"][2]) or "").. "|", 912, 85, 322, 61, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")
					
				elseif (#guiGetText(client.edits["ID"][2]) >= 1) then 
					dxDrawText((guiGetText(client.edits["ID"][2]) or ""), 912, 85, 322, 61, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")
				else
					dxDrawText("ID/RG", 912, 85, 322, 61, tocolor(86, 86, 86, alpha), 1.0, getFont("regular", 10), "center", "center")
				end

				dxDrawRectangle(912, 154, 322, 157, tocolor(34, 34, 34, alpha))

				if (client.edits["REASON"][1] and isElement(client.edits["REASON"][2])) then
					dxDrawText((guiGetText(client.edits["REASON"][2]) or "").. "|", 930, 175, 287, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "left", "top", false, true, false, false, false)
					
				elseif (#guiGetText(client.edits["REASON"][2]) >= 1) then 
					dxDrawText((guiGetText(client.edits["REASON"][2]) or ""), 930, 175, 287, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "left", "top", false, true, false, false, false)
				else
					dxDrawText("Descrição/motivo", 930, 175, 287, 20, tocolor(86, 86, 86, alpha), 1.0, getFont("regular", 10), "left", "top", false, true, false, false, false)
				end

				dxDrawRectangle(912, 321, 322, 61, tocolor(34, 34, 34, alpha))

				if (client.edits["TIMEPUNISH"][1] and isElement(client.edits["TIMEPUNISH"][2])) then
					dxDrawText((guiGetText(client.edits["TIMEPUNISH"][2]) or "").. "|", 928, 341, 146, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10))
					
				elseif (#guiGetText(client.edits["TIMEPUNISH"][2]) >= 1) then 
					dxDrawText((guiGetText(client.edits["TIMEPUNISH"][2]) or ""), 928, 341, 146, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10))
				else
					dxDrawText("Tempo da punição", 928, 341, 146, 20, tocolor(86, 86, 86, alpha), 1.0, getFont("regular", 10))
				end

				dxDrawRectangle(912, 393, 322, 61, tocolor(34, 34, 34, alpha))
				dxDrawText("Tempo:", 926, 414, 53, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10))
				dxDrawText(totalTime.." minutos", 1172, 414, 43, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "right", "top")

				dxDrawRectangle(912, 474, 326, 1, tocolor(77, 74, 87, alpha))
				
				dxDrawRectangle(912, 494, 103, 61, (selectType == "minutes" and tocolor(193, 159, 114, alpha) or tocolor(34, 34, 34, alpha)))
				dxDrawRectangle(1021, 494, 103, 61, (selectType == "hours" and tocolor(193, 159, 114, alpha) or tocolor(34, 34, 34, alpha)))
				dxDrawRectangle(1131, 494, 103, 61, (selectType == "days" and tocolor(193, 159, 114, alpha) or tocolor(34, 34, 34, alpha)))
				dxDrawRectangle(912, 565, 322, 61, (selectType == "permanent" and tocolor(193, 159, 114, alpha) or tocolor(34, 34, 34, alpha)))

				dxDrawText("MINUTOS", 912, 496, 103, 61, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 9), "center", "center")
				dxDrawText("HORAS", 1021, 496, 103, 61, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 9), "center", "center")
				dxDrawText("DIAS", 1131, 496, 103, 61, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 9), "center", "center")
				dxDrawText("PERMANENTE", 912, 567, 322, 61, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 9), "center", "center")

				dxDrawRectangle(912, 636, 322, 61, (functions.isCursorOnElement(912, 636, 322, 61) and tocolor(193, 159, 114, alpha) or tocolor(32, 32, 32, alpha)))
				dxDrawText("APLICAR BANIMENTO", 912, 638, 322, 61, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 10), "center", "center")

			end
		end
	end
end

registerEvent("squady.openAdminPanel", root, function(verification_)
	if not client.visible and client.radius[2] == 0 then 
		client.visible = true
		client.radius = {0, 255}
		client.tick = getTickCount()
		client.pag_resources = 0
		client.pag_groups = 0
		client.pag_punishment = 0
		select_resource = nil
		select_player = nil
		select_ban = nil
		select_group = nil
		selectReasons = {}
		selectType = nil
		window = "index"
		sub_window = nil
		cursorY = 467
		verification = verification_
		guiSetText(client.edits["CODE"][2], "")
		showCursor(true)
		showChat(false)
		addEventHandler("onClientRender", root, onDraw)
	elseif client.visible and client.radius[2] == 255 then 
		client.visible = false 
		client.radius = {255, 0}
		client.tick = getTickCount()
		setTimer(function()
			showCursor(false)
			showChat(true)
			removeEventHandler("onClientRender", root, onDraw)
		end, 300, 1)
	end
end)

registerEvent("squady.verifyPanel", root, function(player, hash, iv)
	decodeString('aes128', hash, {key = getPlayerSerial(player):sub(17), iv = iv}, function(decoded)
		if decoded then 
			if verification then 
				verification = false
				checking = true
				startTime = getTickCount()
			end
		else
			outputDebugString("Decoding failed")
		end
	end)
end)

registerEvent("squady.receiveDataAdminPanel", root, function(player, hash, iv)
	decodeString('aes128', hash, {key = getPlayerSerial(player):sub(17), iv = iv}, function(decoded)
		if decoded then 
			local data = fromJSON(decoded)

			if data then
				verify_acl = data.verify_acl
				data_resources = data.resources
				data_config = data.config
				data_groups = data.groups
				data_bans = data.bans
				data_logs = data.logs
			end
		else
			outputDebugString("Decoding failed")
		end
	end)
end)

registerEvent("squady.receiveDataPlayersPanel", root, function(data)
	if data then 
		data_players = data
	end
end)

registerEvent("squady.staffLogin", root, function(boolean)
	if isElement(localPlayer) then 
		if boolean then
			addEventHandler("onClientKey", root, keyBlocks)
			toggleAllControls(false)
			setElementFrozen(localPlayer, true)
		else
			removeEventHandler("onClientKey", root, keyBlocks)
			toggleAllControls(true)
			setElementFrozen(localPlayer, false)
		end
	end
end)

function keyBlocks(button, press)
	if press then 
		cancelEvent()
	end
end

bindKey("p", "down", function()
	if client.visible and client.radius[2] == 255 then 
		client.visible = false 
		client.radius = {255, 0}
		client.tick = getTickCount()
		setTimer(function()
			showCursor(false)
			showChat(true)
			removeEventHandler("onClientRender", root, onDraw)
		end, 300, 1)
	else
		triggerServerEvent("squady.verifyAdminPanel", resourceRoot)
	end
end)

addEventHandler("onClientClick", root, function(button, state)
	if client.visible and client.radius[2] == 255 and button == "left" and state == "down" then 
		client.edits["CODE"][1] = false
		client.edits["SEARCH"][1] = false
		client.edits["EXECUTECOMMAND"][1] = false
		client.edits["TIMESET/HOUR"][1] = false
		client.edits["TIMESET/MINUTE"][1] = false
		client.edits["GRAVITY"][1] = false
		client.edits["GAMESPEED"][1] = false
		client.edits["WAVEHEIGHT"][1] = false
		client.edits["FPS"][1] = false
		client.edits["ACL"][1] = false
		client.edits["ID"][1] = false
		client.edits["REASON"][1] = false
		client.edits["TIMEPUNISH"][1] = false
		client.edits["EDIT"][1] = false
		
		for i, v in ipairs(client.windows) do
			if functions.isCursorOnElement(95, v[1], 311, 55) and not sub_window then 
				window = v[3]
				client.pag_resources = 0
				client.pag_groups = 0
				client.pag_punishment = 0
				select_resource = nil
				select_player = nil
				select_ban = nil
				select_group = nil
				selectReasons = {}
				selectType = nil
				cursorY = v[10]
				guiSetText(client.edits["CODE"][2], "")
				guiSetText(client.edits["SEARCH"][2], "")
				guiSetText(client.edits["EXECUTECOMMAND"][2], "")
				guiSetText(client.edits["TIMESET/HOUR"][2], "")
				guiSetText(client.edits["TIMESET/MINUTE"][2], "")
				guiSetText(client.edits["GRAVITY"][2], "")
				guiSetText(client.edits["GAMESPEED"][2], "")
				guiSetText(client.edits["WAVEHEIGHT"][2], "")
				guiSetText(client.edits["FPS"][2], "")
				guiSetText(client.edits["ACL"][2], "")
				guiSetText(client.edits["ID"][2], "")
				guiSetText(client.edits["REASON"][2], "")
				guiSetText(client.edits["TIMEPUNISH"][2], "")
				guiSetText(client.edits["EDIT"][2], "")
				break
			end
		end

		if verification then 
			if functions.isCursorOnElement(516, 476, 326, 62) and not sub_window then 
				if (guiEditSetCaretIndex(client.edits["CODE"][2], (string.len(guiGetText(client.edits["CODE"][2]))))) then 
					guiEditSetMaxLength(client.edits["CODE"][2], 6)
					guiSetProperty(client.edits["CODE"][2], "ValidationString", "^[0-9]*")
					guiBringToFront(client.edits["CODE"][2])
					guiSetInputMode("no_binds_when_editing")
					client.edits["CODE"][1] = true
				end

			elseif functions.isCursorOnElement(516, 547, 326, 62) and not sub_window then 
				local code = guiGetText(client.edits["CODE"][2])
				if code ~= "" then
					triggerServerEvent("squady.useAdminCode", resourceRoot, code)
				else
					sendMessage("client", localPlayer, "Você precisa digitar o código de verificação para acessar o painel.", "error")
				end
			end
		else

			if window == "index" then 
				if functions.isCursorOnElement(441, 464, 585, 46) and not sub_window then 
					if (guiEditSetCaretIndex(client.edits["SEARCH"][2], (string.len(guiGetText(client.edits["SEARCH"][2]))))) then 
						guiEditSetMaxLength(client.edits["SEARCH"][2], 30)
						guiBringToFront(client.edits["SEARCH"][2])
						guiSetInputMode("no_binds_when_editing")
						client.edits["SEARCH"][1] = true
					end
				end

				line = 0 
				for i, v in ipairs(data_players) do 
					if isElement(v.element) then
						if ((guiGetText(client["edits"]["SEARCH"][2]) == "" or guiGetText(client["edits"]["SEARCH"][2]) == "Pesquisar jogador") or string.find(string.lower(getPlayerName(v.element)), string.lower(guiGetText(client["edits"]["SEARCH"][2]))) or (guiGetText(client["edits"]["SEARCH"][2]) == "" or guiGetText(client["edits"]["SEARCH"][2]) == "Pesquisar jogador") or string.find(string.lower((getElementData(v.element, "ID") or "N/A")), string.lower(guiGetText(client["edits"]["SEARCH"][2])))) then
							if (i > client.pag_index and line < 4) then 
								line = line + 1

								local count = (551 + (618 - 551) * line - (618 - 551))

								if functions.isCursorOnElement(437, count, 585, 62) then 
									select_player = i
								end
							end
						end
					end
				end

				line = 0 
				for i, v in ipairs(client.optionsIndexPage) do 
					if (i > client.pag_options and line < 7) then 
						line = line + 1
						
						local count = (467 + (517 - 467) * line - (517 - 467))
						
						if functions.isCursorOnElement(1035, count, 192, 45) and not sub_window then 
							if v then 
								if select_player then 
									if v.modal then 
										sub_window = v[2]
									else
										local key = getPlayerSerial(localPlayer)    
										local hashtoKey = toJSON({id = (getElementData(data_players[select_player].element, "ID") or "N/A"), type = v[2], edit = 0})
										encodeString('aes128', hashtoKey, {key = key:sub(17)}, function(enc, iv)
											triggerServerEvent("squady.manageUser", resourceRoot, enc, iv)
										end)
									end
								else
									sendMessage("client", localPlayer, "Você precisa selecionar um jogador para executar essa ação.", "error")
								end
							end
						end
					end
				end

				if functions.isCursorOnElement(860, 282, 32, 32) and not sub_window then 
					if select_player then
						eye_serial = not eye_serial
					end

				elseif functions.isCursorOnElement(467, 375, 568, 45) and not sub_window then 
					if select_player then
						sub_window = "acls"
					end

				elseif functions.isCursorOnElement(989, 282, 40, 40) then 
					if select_player then 
						sub_window = nil
						select_money = nil
						guiSetText(client.edits["EDIT"][2], "")
					end
				end

				if sub_window == "kick" then 
					if functions.isCursorOnElement(678, 368, 322, 147) then 
						if (guiEditSetCaretIndex(client.edits["EDIT"][2], (string.len(guiGetText(client.edits["EDIT"][2]))))) then 
							guiEditSetMaxLength(client.edits["EDIT"][2], 100)
							guiBringToFront(client.edits["EDIT"][2])
							guiSetInputMode("no_binds_when_editing")
							client.edits["EDIT"][1] = true
						end

					elseif functions.isCursorOnElement(678, 538, 322, 61) then 
						local edit = guiGetText(client.edits["EDIT"][2])

						if edit and edit ~= "" then 
							local key = getPlayerSerial(localPlayer)    
							local hashtoKey = toJSON({id = (getElementData(data_players[select_player].element, "ID") or "N/A"), type = "kick", edit = edit})
							encodeString('aes128', hashtoKey, {key = key:sub(17)}, function(enc, iv)
								triggerServerEvent("squady.manageUser", resourceRoot, enc, iv)
								select_player = nil
								sub_window = nil
							end)
						else
							sendMessage("client", localPlayer, "Você precisa digitar um motivo para executar essa ação.", "error")
						end
					end

				elseif sub_window == "mute" then 
					if functions.isCursorOnElement(678, 368, 322, 147) then 
						if (guiEditSetCaretIndex(client.edits["EDIT"][2], (string.len(guiGetText(client.edits["EDIT"][2]))))) then 
							guiEditSetMaxLength(client.edits["EDIT"][2], 100)
							guiBringToFront(client.edits["EDIT"][2])
							guiSetInputMode("no_binds_when_editing")
							client.edits["EDIT"][1] = true
						end

					elseif functions.isCursorOnElement(678, 538, 322, 61) then 
						local edit = guiGetText(client.edits["EDIT"][2])

						if edit and edit ~= "" then 
							local key = getPlayerSerial(localPlayer)    
							local hashtoKey = toJSON({id = (getElementData(data_players[select_player].element, "ID") or "N/A"), type = "mute", edit = edit})
							encodeString('aes128', hashtoKey, {key = key:sub(17)}, function(enc, iv)
								triggerServerEvent("squady.manageUser", resourceRoot, enc, iv)
							end)
						else
							sendMessage("client", localPlayer, "Você precisa digitar um motivo para executar essa ação.", "error")
						end
					end

				elseif sub_window == "setnick" then 
					if functions.isCursorOnElement(678, 413, 322, 65) then 
						if (guiEditSetCaretIndex(client.edits["EDIT"][2], (string.len(guiGetText(client.edits["EDIT"][2]))))) then 
							guiEditSetMaxLength(client.edits["EDIT"][2], 16)
							guiBringToFront(client.edits["EDIT"][2])
							guiSetInputMode("no_binds_when_editing")
							client.edits["EDIT"][1] = true
						end

					elseif functions.isCursorOnElement(678, 538, 322, 61) then 
						local edit = guiGetText(client.edits["EDIT"][2])

						if edit and edit ~= "" then 
							local key = getPlayerSerial(localPlayer)    
							local hashtoKey = toJSON({id = (getElementData(data_players[select_player].element, "ID") or "N/A"), type = "setnick", edit = edit})
							encodeString('aes128', hashtoKey, {key = key:sub(17)}, function(enc, iv)
								triggerServerEvent("squady.manageUser", resourceRoot, enc, iv)
							end)
						else
							sendMessage("client", localPlayer, "Você precisa digitar um nick para executar essa ação.", "error")
						end
					end

				elseif sub_window == "setvida" then 
					if functions.isCursorOnElement(678, 413, 322, 65) then 
						if (guiEditSetCaretIndex(client.edits["EDIT"][2], (string.len(guiGetText(client.edits["EDIT"][2]))))) then 
							guiEditSetMaxLength(client.edits["EDIT"][2], 3)
							guiSetProperty(client.edits["EDIT"][2], "ValidationString", "^[0-9]*")
							guiBringToFront(client.edits["EDIT"][2])
							guiSetInputMode("no_binds_when_editing")
							client.edits["EDIT"][1] = true
						end

					elseif functions.isCursorOnElement(678, 538, 322, 61) then 
						local edit = guiGetText(client.edits["EDIT"][2])

						if edit and edit ~= "" then 
							local key = getPlayerSerial(localPlayer)    
							local hashtoKey = toJSON({id = (getElementData(data_players[select_player].element, "ID") or "N/A"), type = "setvida", edit = edit})
							encodeString('aes128', hashtoKey, {key = key:sub(17)}, function(enc, iv)
								triggerServerEvent("squady.manageUser", resourceRoot, enc, iv)
							end)
						else
							sendMessage("client", localPlayer, "Você precisa digitar uma quantidade para executar essa ação.", "error")
						end
					end

				elseif sub_window == "setcolete" then 
					if functions.isCursorOnElement(678, 413, 322, 65) then 
						if (guiEditSetCaretIndex(client.edits["EDIT"][2], (string.len(guiGetText(client.edits["EDIT"][2]))))) then 
							guiEditSetMaxLength(client.edits["EDIT"][2], 3)
							guiSetProperty(client.edits["EDIT"][2], "ValidationString", "^[0-9]*")
							guiBringToFront(client.edits["EDIT"][2])
							guiSetInputMode("no_binds_when_editing")
							client.edits["EDIT"][1] = true
						end

					elseif functions.isCursorOnElement(678, 538, 322, 61) then 
						local edit = guiGetText(client.edits["EDIT"][2])

						if edit and edit ~= "" then 
							local key = getPlayerSerial(localPlayer)    
							local hashtoKey = toJSON({id = (getElementData(data_players[select_player].element, "ID") or "N/A"), type = "setcolete", edit = edit})
							encodeString('aes128', hashtoKey, {key = key:sub(17)}, function(enc, iv)
								triggerServerEvent("squady.manageUser", resourceRoot, enc, iv)
							end)
						else
							sendMessage("client", localPlayer, "Você precisa digitar uma quantidade para executar essa ação.", "error")
						end
					end

				elseif sub_window == "setmoney" then
					if functions.isCursorOnElement(678, 413, 322, 65) then 
						if (guiEditSetCaretIndex(client.edits["EDIT"][2], (string.len(guiGetText(client.edits["EDIT"][2]))))) then 
							guiEditSetMaxLength(client.edits["EDIT"][2], 15)
							guiSetProperty(client.edits["EDIT"][2], "ValidationString", "^[0-9]*")
							guiBringToFront(client.edits["EDIT"][2])
							guiSetInputMode("no_binds_when_editing")
							client.edits["EDIT"][1] = true
						end

					elseif functions.isCursorOnElement(679, 494, 30, 25) then 
						select_money = "money"
					
					elseif functions.isCursorOnElement(813, 494, 30, 25) then 
						select_money = "pontos"
						
					elseif functions.isCursorOnElement(907, 494, 30, 25) then 
						select_money = "bank"

					elseif functions.isCursorOnElement(678, 538, 322, 61) then 
						local edit = guiGetText(client.edits["EDIT"][2])

						if edit and edit ~= "" then 
							if select_money and select_money ~= nil then 
								local key = getPlayerSerial(localPlayer)    
								local hashtoKey = toJSON({id = (getElementData(data_players[select_player].element, "ID") or "N/A"), type = select_money, edit = edit})
								encodeString('aes128', hashtoKey, {key = key:sub(17)}, function(enc, iv)
									triggerServerEvent("squady.setMoney", resourceRoot, enc, iv)
								end)
							else
								sendMessage("client", localPlayer, "Você precisa selecionar um tipo de dinheiro para executar essa ação.", "error")
							end
						else
							sendMessage("client", localPlayer, "Você precisa digitar uma quantidade para executar essa ação.", "error")
						end
					end

				elseif sub_window == "setweapons" then 
					line = 0 
					for i, v in ipairs(config.weapons) do 
						if (i > client.pag_weapons and line < 3) then 
							line = line + 1

							local count = (334 + (400 - 334) * line - (400 - 334))

							if functions.isCursorOnElement(678, count, 322, 51) then 
								select_weapon = i
							end
						end
					end

					if functions.isCursorOnElement(678, 538, 322, 61) then 
						if select_weapon then
							local key = getPlayerSerial(localPlayer)    
							local hashtoKey = toJSON({id = (getElementData(data_players[select_player].element, "ID") or "N/A"), type = "setweapons", edit = config.weapons[select_weapon]})
							encodeString('aes128', hashtoKey, {key = key:sub(17)}, function(enc, iv)
								triggerServerEvent("squady.manageUser", resourceRoot, enc, iv)
							end)
						else
							sendMessage("client", localPlayer, "Você precisa selecionar uma arma para executar essa ação.", "error")
						end
					end

				elseif sub_window == "setvehicle" then 
					if functions.isCursorOnElement(678, 413, 322, 65) then 
						if (guiEditSetCaretIndex(client.edits["EDIT"][2], (string.len(guiGetText(client.edits["EDIT"][2]))))) then 
							guiEditSetMaxLength(client.edits["EDIT"][2], 3)
							guiSetProperty(client.edits["EDIT"][2], "ValidationString", "^[0-9]*")
							guiBringToFront(client.edits["EDIT"][2])
							guiSetInputMode("no_binds_when_editing")
							client.edits["EDIT"][1] = true
						end

					elseif functions.isCursorOnElement(678, 538, 322, 61) then 
						local edit = guiGetText(client.edits["EDIT"][2])

						if edit and edit ~= "" then 
							local key = getPlayerSerial(localPlayer)    
							local hashtoKey = toJSON({id = (getElementData(data_players[select_player].element, "ID") or "N/A"), type = "setvehicle", edit = edit})
							encodeString('aes128', hashtoKey, {key = key:sub(17)}, function(enc, iv)
								triggerServerEvent("squady.manageUser", resourceRoot, enc, iv)
							end)
						else
							sendMessage("client", localPlayer, "Você precisa digitar uma quantidade para executar essa ação.", "error")
						end
					end

				elseif sub_window == "setdimension" then 
					if functions.isCursorOnElement(678, 413, 322, 65) then 
						if (guiEditSetCaretIndex(client.edits["EDIT"][2], (string.len(guiGetText(client.edits["EDIT"][2]))))) then 
							guiEditSetMaxLength(client.edits["EDIT"][2], 5)
							guiSetProperty(client.edits["EDIT"][2], "ValidationString", "^[0-9]*")
							guiBringToFront(client.edits["EDIT"][2])
							guiSetInputMode("no_binds_when_editing")
							client.edits["EDIT"][1] = true
						end

					elseif functions.isCursorOnElement(678, 538, 322, 61) then 
						local edit = guiGetText(client.edits["EDIT"][2])

						if edit and edit ~= "" then 
							local key = getPlayerSerial(localPlayer)    
							local hashtoKey = toJSON({id = (getElementData(data_players[select_player].element, "ID") or "N/A"), type = "setdimension", edit = edit})
							encodeString('aes128', hashtoKey, {key = key:sub(17)}, function(enc, iv)
								triggerServerEvent("squady.manageUser", resourceRoot, enc, iv)
							end)
						else
							sendMessage("client", localPlayer, "Você precisa digitar uma quantidade para executar essa ação.", "error")
						end
					end

				elseif sub_window == "setinterior" then 
					if functions.isCursorOnElement(678, 413, 322, 65) then 
						if (guiEditSetCaretIndex(client.edits["EDIT"][2], (string.len(guiGetText(client.edits["EDIT"][2]))))) then 
							guiEditSetMaxLength(client.edits["EDIT"][2], 5)
							guiSetProperty(client.edits["EDIT"][2], "ValidationString", "^[0-9]*")
							guiBringToFront(client.edits["EDIT"][2])
							guiSetInputMode("no_binds_when_editing")
							client.edits["EDIT"][1] = true
						end

					elseif functions.isCursorOnElement(678, 538, 322, 61) then 
						local edit = guiGetText(client.edits["EDIT"][2])

						if edit and edit ~= "" then 
							local key = getPlayerSerial(localPlayer)    
							local hashtoKey = toJSON({id = (getElementData(data_players[select_player].element, "ID") or "N/A"), type = "setinterior", edit = edit})
							encodeString('aes128', hashtoKey, {key = key:sub(17)}, function(enc, iv)
								triggerServerEvent("squady.manageUser", resourceRoot, enc, iv)
							end)
						else
							sendMessage("client", localPlayer, "Você precisa digitar uma quantidade para executar essa ação.", "error")
						end
					end
				end

			elseif window == "resources" then 
				line = 0 
				for i, v in ipairs(data_resources) do 
					if ((guiGetText(client["edits"]["SEARCH"][2]) == "" or guiGetText(client["edits"]["SEARCH"][2]) == "Pesquisar resources") or string.find(string.lower(v.name), string.lower(guiGetText(client["edits"]["SEARCH"][2]))) or (guiGetText(client["edits"]["SEARCH"][2]) == "" or guiGetText(client["edits"]["SEARCH"][2]) == "Pesquisar resources")) then
						if (i > client.pag_resources and line < 6) then 
							line = line + 1

							local count = (412 + (479 - 412) * line - (479 - 412))

							if functions.isCursorOnElement(437, count, 790, 62) and not sub_window then 
								select_resource = i
								resource_selected = {
									name = v.name,
									dev = v.author,
									ipb = v.ipb,
									version = v.version,
									state = v.state
								}
							end
						end
					end
				end

				if functions.isCursorOnElement(437, 336, 801, 58) and not sub_window then 
					if (guiEditSetCaretIndex(client.edits["SEARCH"][2], (string.len(guiGetText(client.edits["SEARCH"][2]))))) then 
						guiEditSetMaxLength(client.edits["SEARCH"][2], 30)
						guiBringToFront(client.edits["SEARCH"][2])
						guiSetInputMode("no_binds_when_editing")
						client.edits["SEARCH"][1] = true
					end

				elseif functions.isCursorOnElement(437, 245, 525, 58) and not sub_window then 
					if (guiEditSetCaretIndex(client.edits["EXECUTECOMMAND"][2], (string.len(guiGetText(client.edits["EXECUTECOMMAND"][2]))))) then 
						guiEditSetMaxLength(client.edits["EXECUTECOMMAND"][2], 90)
						guiBringToFront(client.edits["EXECUTECOMMAND"][2])
						guiSetInputMode("no_binds_when_editing")
						client.edits["EXECUTECOMMAND"][1] = true
					end
				
				elseif functions.isCursorOnElement(1035, 133, 203, 45) and not sub_window then 
					if select_resource then
						local key = getPlayerSerial(localPlayer)    
						local hashtoKey = toJSON({name = resource_selected.name, type = "start"})
						encodeString('aes128', hashtoKey, {key = key:sub(17)}, function(enc, iv)
							triggerServerEvent("squady.manageResources", resourceRoot, enc, iv)
						end)
					else
						sendMessage("client", localPlayer, "Você precisa selecionar um resource para executar essa ação.", "error")
					end

				elseif functions.isCursorOnElement(1035, 83, 203, 45) and not sub_window then 
					if select_resource then
						local key = getPlayerSerial(localPlayer)    
						local hashtoKey = toJSON({name = resource_selected.name, type = "stop"})
						encodeString('aes128', hashtoKey, {key = key:sub(17)}, function(enc, iv)
							triggerServerEvent("squady.manageResources", resourceRoot, enc, iv)
						end)
					else
						sendMessage("client", localPlayer, "Você precisa selecionar um resource para executar essa ação.", "error")
					end

				elseif functions.isCursorOnElement(1035, 183, 183, 45) and not sub_window then 
					if select_resource then

						local key = getPlayerSerial(localPlayer)    
						local hashtoKey = toJSON({name = resource_selected.name, type = "restart"})
						encodeString('aes128', hashtoKey, {key = key:sub(17)}, function(enc, iv)
							triggerServerEvent("squady.manageResources", resourceRoot, enc, iv)
						end)
					else
						sendMessage("client", localPlayer, "Você precisa selecionar um resource para executar essa ação.", "error")
					end

				elseif functions.isCursorOnElement(968, 245, 134, 58) and not sub_window then 
					local command = guiGetText(client.edits["EXECUTECOMMAND"][2])

					if command ~= "" then 
						local key = getPlayerSerial(localPlayer)    
						local hashtoKey = toJSON({command = command, type = "execute_command"})
						encodeString('aes128', hashtoKey, {key = key:sub(17)}, function(enc, iv)
							triggerServerEvent("squady.executeCommandSerer", resourceRoot, enc, iv)
						end)
					else
						sendMessage("client", localPlayer, "Você precisa digitar um comando para executar.", "error")
					end

				elseif functions.isCursorOnElement(1106, 245, 134, 58) and not sub_window then
					local command = guiGetText(client.edits["EXECUTECOMMAND"][2])

					if command ~= "" then 
						executeCommandClient(command)
					else
						sendMessage("client", localPlayer, "Você precisa digitar um comando para executar.", "error")
					end
				end

			elseif window == "server" then
				if functions.isCursorOnElement(644, 106, 84, 41) and not sub_window then 
					if (guiEditSetCaretIndex(client.edits["TIMESET/HOUR"][2], (string.len(guiGetText(client.edits["TIMESET/HOUR"][2]))))) then 
						guiEditSetMaxLength(client.edits["TIMESET/HOUR"][2], 2)
						guiSetProperty(client.edits["TIMESET/HOUR"][2], "ValidationString", "^[0-9]*")
						guiBringToFront(client.edits["TIMESET/HOUR"][2])
						guiSetInputMode("no_binds_when_editing")
						client.edits["TIMESET/HOUR"][1] = true
					end

				elseif functions.isCursorOnElement(737, 106, 84, 41) and not sub_window then 
					if (guiEditSetCaretIndex(client.edits["TIMESET/MINUTE"][2], (string.len(guiGetText(client.edits["TIMESET/MINUTE"][2]))))) then 
						guiEditSetMaxLength(client.edits["TIMESET/MINUTE"][2], 2)
						guiSetProperty(client.edits["TIMESET/MINUTE"][2], "ValidationString", "^[0-9]*")
						guiBringToFront(client.edits["TIMESET/MINUTE"][2])
						guiSetInputMode("no_binds_when_editing")
						client.edits["TIMESET/MINUTE"][1] = true
					end

				elseif functions.isCursorOnElement(644, 156, 177, 41) and not sub_window then
					if (guiEditSetCaretIndex(client.edits["GRAVITY"][2], (string.len(guiGetText(client.edits["GRAVITY"][2]))))) then 
						guiEditSetMaxLength(client.edits["GRAVITY"][2], 6)
						guiSetProperty(client.edits["GRAVITY"][2], "ValidationString", "^[0-9.]*")
						guiBringToFront(client.edits["GRAVITY"][2])
						guiSetInputMode("no_binds_when_editing")
						client.edits["GRAVITY"][1] = true
					end

				elseif functions.isCursorOnElement(644, 206, 177, 41) and not sub_window then
					if (guiEditSetCaretIndex(client.edits["GAMESPEED"][2], (string.len(guiGetText(client.edits["GAMESPEED"][2]))))) then 
						guiEditSetMaxLength(client.edits["GAMESPEED"][2], 2)
						guiSetProperty(client.edits["GAMESPEED"][2], "ValidationString", "^[0-9]*")
						guiBringToFront(client.edits["GAMESPEED"][2])
						guiSetInputMode("no_binds_when_editing")
						client.edits["GAMESPEED"][1] = true
					end

				elseif functions.isCursorOnElement(644, 256, 177, 41) and not sub_window then
					if (guiEditSetCaretIndex(client.edits["WAVEHEIGHT"][2], (string.len(guiGetText(client.edits["WAVEHEIGHT"][2]))))) then 
						guiEditSetMaxLength(client.edits["WAVEHEIGHT"][2], 3)
						guiSetProperty(client.edits["WAVEHEIGHT"][2], "ValidationString", "^[0-9]*")
						guiBringToFront(client.edits["WAVEHEIGHT"][2])
						guiSetInputMode("no_binds_when_editing")
						client.edits["WAVEHEIGHT"][1] = true
					end

				elseif functions.isCursorOnElement(644, 306, 177, 41) and not sub_window then
					if (guiEditSetCaretIndex(client.edits["FPS"][2], (string.len(guiGetText(client.edits["FPS"][2]))))) then 
						guiEditSetMaxLength(client.edits["FPS"][2], 4)
						guiSetProperty(client.edits["FPS"][2], "ValidationString", "^[0-9]*")
						guiBringToFront(client.edits["FPS"][2])
						guiSetInputMode("no_binds_when_editing")
						client.edits["FPS"][1] = true
					end

				elseif functions.isCursorOnElement(750, 419, 38, 31) and not sub_window then 
					if select_weather < #config.weatherTemp then 
						select_weather = select_weather + 1
					end

				elseif functions.isCursorOnElement(469, 419, 38, 31) and not sub_window then 
					if select_weather > 0 then 
						select_weather = select_weather - 1
					end

				elseif functions.isCursorOnElement(805, 412, 134, 44) and not sub_window then 
					local key = getPlayerSerial(localPlayer)    
					local hashtoKey = toJSON({type = "weather", table = {select_weather}})
					encodeString('aes128', hashtoKey, {key = key:sub(17)}, function(enc, iv)
						triggerServerEvent("squady.manageServerConfig", resourceRoot, enc, iv)
					end)

				elseif functions.isCursorOnElement(826, 106, 115, 41) and not sub_window then
					local hour = tonumber(guiGetText(client.edits["TIMESET/HOUR"][2]))
					local minute = tonumber(guiGetText(client.edits["TIMESET/MINUTE"][2]))

					if hour and minute then
						if hour >= 0 and hour <= 23 then
							if minute >= 0 and minute <= 59 then 
								local key = getPlayerSerial(localPlayer)    
								local hashtoKey = toJSON({type = "time", table = {hour, minute}})
								encodeString('aes128', hashtoKey, {key = key:sub(17)}, function(enc, iv)
									triggerServerEvent("squady.manageServerConfig", resourceRoot, enc, iv)
								end)
							else
								sendMessage("client", localPlayer, "Minutos inválidos.", "error")
							end
						else
							sendMessage("client", localPlayer, "Hora inválida.", "error")
						end
					else
						sendMessage("client", localPlayer, "Valores de hora e/ou minutos inválidos.", "error")
					end

				elseif functions.isCursorOnElement(826, 156, 115, 41) and not sub_window then 
					local gravity = tonumber(guiGetText(client.edits["GRAVITY"][2]))

					if gravity then 
						if gravity <= 1 then 
							local key = getPlayerSerial(localPlayer)    
							local hashtoKey = toJSON({type = "gravitation", table = {gravity}})
							encodeString('aes128', hashtoKey, {key = key:sub(17)}, function(enc, iv)
								triggerServerEvent("squady.manageServerConfig", resourceRoot, enc, iv)
							end)
						else
							sendMessage("client", localPlayer, "Valor de gravidade inválido.", "error")
						end
					else
						sendMessage("client", localPlayer, "Valor de gravidade inválido.", "error")
					end 

				elseif functions.isCursorOnElement(826, 206, 115, 41) and not sub_window then 
					local gamespeed = tonumber(guiGetText(client.edits["GAMESPEED"][2]))

					if gamespeed then 
						if gamespeed >= 0 and gamespeed <= 10 then 
							local key = getPlayerSerial(localPlayer)    
							local hashtoKey = toJSON({type = "gamespeed", table = {gamespeed}})
							encodeString('aes128', hashtoKey, {key = key:sub(17)}, function(enc, iv)
								triggerServerEvent("squady.manageServerConfig", resourceRoot, enc, iv)
							end)
						else
							sendMessage("client", localPlayer, "Valor de gamespeed inválido.", "error")
						end
					else
						sendMessage("client", localPlayer, "Valor de gamespeed inválido.", "error")
					end

				elseif functions.isCursorOnElement(826, 256, 115, 41) and not sub_window then 
					local waveheight = tonumber(guiGetText(client.edits["WAVEHEIGHT"][2]))

					if waveheight then 
						if waveheight >= 0 and waveheight <= 100 then 
							local key = getPlayerSerial(localPlayer)    
							local hashtoKey = toJSON({type = "waveheight", table = {waveheight}})
							encodeString('aes128', hashtoKey, {key = key:sub(17)}, function(enc, iv)
								triggerServerEvent("squady.manageServerConfig", resourceRoot, enc, iv)
							end)
						else
							sendMessage("client", localPlayer, "Valor de waveheight inválido.", "error")
						end
					else
						sendMessage("client", localPlayer, "Valor de waveheight inválido.", "error")
					end
					
				elseif functions.isCursorOnElement(826, 306, 115, 41) and not sub_window then 
					local fps = tonumber(guiGetText(client.edits["FPS"][2]))

					if fps then 
						if fps >= 0 and fps <= 1000 then 
							local key = getPlayerSerial(localPlayer)    
							local hashtoKey = toJSON({type = "fpslimit", table = {fps}})
							encodeString('aes128', hashtoKey, {key = key:sub(17)}, function(enc, iv)
								triggerServerEvent("squady.manageServerConfig", resourceRoot, enc, iv)
							end)
						else
							sendMessage("client", localPlayer, "Valor de fps inválido.", "error")
						end
					else
						sendMessage("client", localPlayer, "Valor de fps inválido.", "error")
					end

				elseif functions.isCursorOnElement(1039, 83, 203, 45) and not sub_window then
					sub_window = "setpassword"

				elseif functions.isCursorOnElement(1039, 133, 203, 45) and not sub_window then
					local key = getPlayerSerial(localPlayer)    
					local hashtoKey = toJSON({type = "reset_password", table = "reset_password"})
					encodeString('aes128', hashtoKey, {key = key:sub(17)}, function(enc, iv)
						triggerServerEvent("squady.manageServerConfig", resourceRoot, enc, iv)
					end)

				elseif functions.isCursorOnElement(1039, 183, 203, 45) and not sub_window then
					sub_window = "changeGameType"

				elseif functions.isCursorOnElement(1039, 233, 203, 45) and not sub_window then
					local key = getPlayerSerial(localPlayer)    
					local hashtoKey = toJSON({type = "start_maintenance", table = "start_maintenance"})
					encodeString('aes128', hashtoKey, {key = key:sub(17)}, function(enc, iv)
						triggerServerEvent("squady.manageServerConfig", resourceRoot, enc, iv)
					end)

				elseif functions.isCursorOnElement(1039, 283, 203, 45) and not sub_window then
					local key = getPlayerSerial(localPlayer)    
					local hashtoKey = toJSON({type = "kick_all_players", table = "kick_all_players"})
					encodeString('aes128', hashtoKey, {key = key:sub(17)}, function(enc, iv)
						triggerServerEvent("squady.manageServerConfig", resourceRoot, enc, iv)
					end)

				elseif functions.isCursorOnElement(1039, 333, 203, 45) and not sub_window then
					local key = getPlayerSerial(localPlayer)    
					local hashtoKey = toJSON({type = "set_password_automatic", table = "set_password_automatic"})
					encodeString('aes128', hashtoKey, {key = key:sub(17)}, function(enc, iv)
						triggerServerEvent("squady.manageServerConfig", resourceRoot, enc, iv)
					end)

				elseif functions.isCursorOnElement(1039, 383, 203, 45) and not sub_window then
					local key = getPlayerSerial(localPlayer)    
					local hashtoKey = toJSON({type = "on_going_maintenance", table = "on_going_maintenance"})
					encodeString('aes128', hashtoKey, {key = key:sub(17)}, function(enc, iv)
						triggerServerEvent("squady.manageServerConfig", resourceRoot, enc, iv)
					end)

				elseif functions.isCursorOnElement(1039, 433, 203, 45) and not sub_window then
					local key = getPlayerSerial(localPlayer)    
					local hashtoKey = toJSON({type = "clear_chat", table = "clear_chat"})
					encodeString('aes128', hashtoKey, {key = key:sub(17)}, function(enc, iv)
						triggerServerEvent("squady.manageServerConfig", resourceRoot, enc, iv)
					end)

				elseif functions.isCursorOnElement(989, 282, 40, 40) then 
					sub_window = nil
					guiSetText(client.edits["EDIT"][2], "")
					
				elseif functions.isCursorOnElement(678, 413, 322, 65) then 
					if sub_window == "setpassword" or sub_window == "changeGameType" then 
						if (guiEditSetCaretIndex(client.edits["EDIT"][2], (string.len(guiGetText(client.edits["EDIT"][2]))))) then 
							guiEditSetMaxLength(client.edits["EDIT"][2], 100)
							guiBringToFront(client.edits["EDIT"][2])
							guiSetInputMode("no_binds_when_editing")
							client.edits["EDIT"][1] = true
						end
					end		
				end

				if sub_window == "setpassword" then 
					if functions.isCursorOnElement(678, 538, 322, 61) then 
						if sub_window == "setpassword" then 
							local edit = guiGetText(client.edits["EDIT"][2])

							if edit and edit ~= "" then 
								local key = getPlayerSerial(localPlayer)    
								local hashtoKey = toJSON({type = "set_password", table = {edit}})
								encodeString('aes128', hashtoKey, {key = key:sub(17)}, function(enc, iv)
									triggerServerEvent("squady.manageServerConfig", resourceRoot, enc, iv)
								end)
							else
								sendMessage("client", localPlayer, "Você precisa digitar uma senha para executar essa ação.", "error")
							end
						end
					end

				elseif sub_window == "changeGameType" then
					if functions.isCursorOnElement(678, 538, 322, 61) then 
						if sub_window == "changeGameType" then 
							local edit = guiGetText(client.edits["EDIT"][2])

							if edit and edit ~= "" then 
								local key = getPlayerSerial(localPlayer)    
								local hashtoKey = toJSON({type = "set_gametype", table = {edit}})
								encodeString('aes128', hashtoKey, {key = key:sub(17)}, function(enc, iv)
									triggerServerEvent("squady.manageServerConfig", resourceRoot, enc, iv)
								end)
							else
								sendMessage("client", localPlayer, "Você precisa digitar algo para executar essa ação.", "error")
							end
						end
					end
				end

			elseif window == "bans" then
				line = 0 
				for i, v in ipairs(data_bans) do 
					if (i > client.pag_bans and line < 8) then 
						line = line + 1

						local count = (149 + (220 - 149) * line - (220 - 149))

						if functions.isCursorOnElement(445, count, 785, 68) then 
							select_ban = i
						end
					end
				end

				if functions.isCursorOnElement(1015, 748, 215, 49) then 
					if select_ban then 
						triggerServerEvent("squady.unpunishmentPlayer", resourceRoot, localPlayer, nil, data_bans[select_ban].id)
						select_ban = nil
					else
						sendMessage("client", localPlayer, "Você precisa selecionar um jogador para executar essa ação.", "error")
					end
				end

			elseif window == "aclmanager" then 
				if functions.isCursorOnElement(912, 83, 322, 61) and not sub_window then 
					if (guiEditSetCaretIndex(client.edits["ID"][2], (string.len(guiGetText(client.edits["ID"][2]))))) then 
						guiEditSetMaxLength(client.edits["ID"][2], 6)
						guiSetProperty(client.edits["ID"][2], "ValidationString", "^[0-9]*")
						guiBringToFront(client.edits["ID"][2])
						guiSetInputMode("no_binds_when_editing")
						client.edits["ID"][1] = true
					end

				elseif functions.isCursorOnElement(912, 501, 322, 61) and not sub_window then 
					if (guiEditSetCaretIndex(client.edits["ACL"][2], (string.len(guiGetText(client.edits["ACL"][2]))))) then 
						guiEditSetMaxLength(client.edits["ACL"][2], 25)
						guiBringToFront(client.edits["ACL"][2])
						guiSetInputMode("no_binds_when_editing")
						client.edits["ACL"][1] = true
					end
				end

				if not select_group and select_group == nil then
					line = 0 
					for i, v in ipairs(data_groups) do 
						if ((guiGetText(client["edits"]["SEARCH"][2]) == "" or guiGetText(client["edits"]["SEARCH"][2]) == "Pesquisar resources") or string.find(string.lower(v.name), string.lower(guiGetText(client["edits"]["SEARCH"][2]))) or (guiGetText(client["edits"]["SEARCH"][2]) == "" or guiGetText(client["edits"]["SEARCH"][2]) == "Pesquisar resources")) then
							if (i > client.pag_groups and line < 17) then 
								line = line + 1

								local count = (144 + (176 - 144) * line - (176 - 144))

								if functions.isCursorOnElement(476, count, 295, 20) then 
									select_group = i
								end
							end
						end
					end
				end

				if functions.isCursorOnElement(844, 92, 40, 40) then
					select_group = nil

				elseif functions.isCursorOnElement(912, 149, 322, 61) and not sub_window then 
					if select_group and select_group ~= nil and select_group ~= 0 then
						local id = tonumber(guiGetText(client.edits["ID"][2]))

						if id and id ~= "" then
							local key = getPlayerSerial(localPlayer)    
							local hashtoKey = toJSON({type = "add", id = id, acl = data_groups[select_group][1]})
							encodeString('aes128', hashtoKey, {key = key:sub(17)}, function(enc, iv)
								triggerServerEvent("squady.manageGroups", resourceRoot, enc, iv)
							end)
						else
							sendMessage("client", localPlayer, "Você precisa digitar um ID para adicionar.", "error")
						end
					else
						sendMessage("client", localPlayer, "Você precisa selecionar um grupo para executar essa ação.", "error")
					end

				elseif functions.isCursorOnElement(912, 215, 322, 61) and not sub_window then 
					if select_group and select_group ~= nil and select_group ~= 0 then
						local id = tonumber(guiGetText(client.edits["ID"][2]))

						if id and id ~= "" then
							local key = getPlayerSerial(localPlayer)    
							local hashtoKey = toJSON({type = "remove", id = id, acl = data_groups[select_group][1]})
							encodeString('aes128', hashtoKey, {key = key:sub(17)}, function(enc, iv)
								triggerServerEvent("squady.manageGroups", resourceRoot, enc, iv)
							end)
						else
							sendMessage("client", localPlayer, "Você precisa digitar um ID para remover.", "error")
						end
					else
						sendMessage("client", localPlayer, "Você precisa selecionar um grupo para executar essa ação.", "error")
					end

				elseif functions.isCursorOnElement(912, 569, 322, 61) and not sub_window then 
					local acl = guiGetText(client.edits["ACL"][2])

					if acl and acl ~= "" then
						local key = getPlayerSerial(localPlayer)    
						local hashtoKey = toJSON({type = "create", acl = acl})
						encodeString('aes128', hashtoKey, {key = key:sub(17)}, function(enc, iv)
							triggerServerEvent("squady.manageGroups", resourceRoot, enc, iv)
						end)
					else
						sendMessage("client", localPlayer, "Você precisa digitar um nome para criar.", "error")
					end

				elseif functions.isCursorOnElement(912, 637, 322, 61) and not sub_window then 
					if select_group and select_group ~= nil and select_group ~= 0 then
						local key = getPlayerSerial(localPlayer)    
						local hashtoKey = toJSON({type = "destroy", acl = data_groups[select_group][1]})
						encodeString('aes128', hashtoKey, {key = key:sub(17)}, function(enc, iv)
							triggerServerEvent("squady.manageGroups", resourceRoot, enc, iv)
						end)
						select_group = nil
						client.pag_groups = 0
					else
						sendMessage("client", localPlayer, "Você precisa selecionar um grupo para executar essa ação.", "error")
					end
				end

			elseif window == "punishment" then

				line = 0
				for i, v in ipairs(config.punishment.reasons) do 
					if (i > client.pag_punishment and line < 17) then 
						line = line + 1

						local count = (144 + (176 - 144) * line - (176 - 144))

						if functions.isCursorOnElement(476, count, 295, 20) then
							local reason = guiGetText(client.edits["REASON"][2])
							local time = guiGetText(client.edits["TIMEPUNISH"][2])

							if reason and reason == "" and time and time == "" then
								if not selectReasons[v.name] then 
									selectReasons[v.name] = v.minutes 
								else
									selectReasons[v.name] = nil
								end

								local selectedTotalTime = 0

								for i, v in pairs(selectReasons) do
									selectedTotalTime = selectedTotalTime + v
								end

								totalTime = selectedTotalTime
							else
								sendMessage("client", localPlayer, "Para selecionar punições predefinidas você não pode descrever um motivo ou tempo.", "error")
							end
						end 
					end
				end

				if functions.isCursorOnElement(912, 83, 322, 61) and not sub_window then 
					if (guiEditSetCaretIndex(client.edits["ID"][2], (string.len(guiGetText(client.edits["ID"][2]))))) then 
						guiEditSetMaxLength(client.edits["ID"][2], 6)
						guiSetProperty(client.edits["ID"][2], "ValidationString", "^[0-9]*")
						guiBringToFront(client.edits["ID"][2])
						guiSetInputMode("no_binds_when_editing")
						client.edits["ID"][1] = true
					end

				elseif functions.isCursorOnElement(912, 154, 322, 157) and not sub_window then
					if totalTime == 0 then
						if (guiEditSetCaretIndex(client.edits["REASON"][2], (string.len(guiGetText(client.edits["REASON"][2]))))) then 
							guiEditSetMaxLength(client.edits["REASON"][2], 100)
							guiBringToFront(client.edits["REASON"][2])
							guiSetInputMode("no_binds_when_editing")
							client.edits["REASON"][1] = true
						end
					else
						sendMessage("client", localPlayer, "Para descrever um motivo você não pode selecionar punições predefinidas", "error")
					end

				elseif functions.isCursorOnElement(912, 321, 322, 61) and not sub_window then
					if totalTime == 0 then 
						if (guiEditSetCaretIndex(client.edits["TIMEPUNISH"][2], (string.len(guiGetText(client.edits["TIMEPUNISH"][2]))))) then 
							guiEditSetMaxLength(client.edits["TIMEPUNISH"][2], 6)
							guiSetProperty(client.edits["TIMEPUNISH"][2], "ValidationString", "^[0-9]*")
							guiBringToFront(client.edits["TIMEPUNISH"][2])
							guiSetInputMode("no_binds_when_editing")
							client.edits["TIMEPUNISH"][1] = true
						end
					else
						sendMessage("client", localPlayer, "Para descrever um tempo você não pode selecionar punições predefinidas", "error")
					end

				elseif functions.isCursorOnElement(912, 494, 103, 61) then 
					selectType = "minutes"

				elseif functions.isCursorOnElement(1021, 494, 103, 61) then 
					selectType = "hours"

				elseif functions.isCursorOnElement(1131, 494, 103, 61) then 
					selectType = "days"

				elseif functions.isCursorOnElement(912, 565, 322, 61) then 
					selectType = "permanent"

				elseif functions.isCursorOnElement(912, 636, 322, 61) then 
					if totalTime == 0 then 
						local id = tonumber(guiGetText(client.edits["ID"][2]))
						local reason = guiGetText(client.edits["REASON"][2])
						local time = guiGetText(client.edits["TIMEPUNISH"][2])

						if id and id ~= "" then
							if reason and reason ~= "" then
								if time and time ~= "" then
									if selectType and selectType ~= nil and selectType ~= 0 then
										local key = getPlayerSerial(localPlayer)    
										local hashtoKey = toJSON({target = id, reason = reason, time = time, type = selectType})
										encodeString('aes128', hashtoKey, {key = key:sub(17)}, function(enc, iv)
											triggerServerEvent("squady.applyPunishment", resourceRoot, enc, iv)
										end)
									else
										sendMessage("client", localPlayer, "Você precisa selecionar um tipo de tempo.", "error")
									end
								else
									sendMessage("client", localPlayer, "Você precisa digitar um tempo para punir.", "error")
								end
							else
								sendMessage("client", localPlayer, "Você precisa digitar um motivo para punir.", "error")
							end
						else
							sendMessage("client", localPlayer, "Você precisa digitar um ID para punir.", "error")
						end
					elseif totalTime > 0 then
						local id = tonumber(guiGetText(client.edits["ID"][2]))

						if id and id ~= "" then 
							if selectType ~= "permanent" and selectType ~= nil then

								local reasonsStr = ""
								for i, v in pairs(selectReasons) do
									reasonsStr = reasonsStr .. i .. ", "
								end
								reasonsStr = string.sub(reasonsStr, 1, -3)

								local key = getPlayerSerial(localPlayer)    
								local hashtoKey = toJSON({target = id, reason = reasonsStr, time = totalTime, type = selectType})
								encodeString('aes128', hashtoKey, {key = key:sub(17)}, function(enc, iv)
									triggerServerEvent("squady.applyPunishment", resourceRoot, enc, iv)
								end)
							else
								sendMessage("client", localPlayer, "Você precisa selecionar um tipo de tempo que não seja permanente.", "error")
							end
						else
							sendMessage("client", localPlayer, "Você precisa digitar um ID para punir.", "error")
						end
					end
				end
			end
		end
		if moving then 
			moving = false
		end
	end
end)

function scrollBar(button, press)
	if client.visible then 
		if window == "index" then 
			if functions.isCursorOnElement(1022, 450, 241, 389) then 
				if button == "mouse_wheel_up" and press then 
					if client.pag_options > 0 then 
						client.pag_options = client.pag_options - 1
					end

					if #client.optionsIndexPage > 7 then 
						cursorY = scrollBarMove(#client.optionsIndexPage, 7, 467, 745, "y", client.pag_options)
					end

				elseif button == "mouse_wheel_down" and press then 
					client.pag_options = client.pag_options + 1

					if client.pag_options > #client.optionsIndexPage - 7 then
						client.pag_options = #client.optionsIndexPage - 7
					end

					if #client.optionsIndexPage > 7 then 
						cursorY = scrollBarMove(#client.optionsIndexPage, 7, 467, 745, "y", client.pag_options)
					end
				end
			end

			if functions.isCursorOnElement(415, 535, 620, 304) then 
				if button == "mouse_wheel_up" and client.pag_index > 0 then
					client.pag_index = client.pag_index - 1
				elseif button == "mouse_wheel_down" and (#data_players - 7 > 0) then
					client.pag_index = client.pag_index + 1
					if client.pag_index > #data_players - 7 then
						client.pag_index = #data_players - 7
					end
				end
			end

			if sub_window == "acls" then 
				if functions.isCursorOnElement(630, 262, 418, 376) then 
					if button == "mouse_wheel_up" and client.pag_acls > 0 then
						client.pag_acls = client.pag_acls - 1
					elseif button == "mouse_wheel_down" and (#data_players[select_player].acls - 7 > 0) then
						client.pag_acls = client.pag_acls + 1
						if client.pag_acls > #data_players[select_player].acls - 7 then
							client.pag_acls = #data_players[select_player].acls - 7
						end
					end
				end

			elseif sub_window == "setweapons" then 
				if functions.isCursorOnElement(630, 262, 418, 376) then 
					if button == "mouse_wheel_up" and client.pag_weapons > 0 then
						client.pag_weapons = client.pag_weapons - 1
					elseif button == "mouse_wheel_down" and (#config.weapons - 3 > 0) then
						client.pag_weapons = client.pag_weapons + 1
						if client.pag_weapons > #config.weapons - 3 then
							client.pag_weapons = #config.weapons - 3
						end
					end
				end

			end

		elseif window == "resources" then 
			if functions.isCursorOnElement(415, 394, 848, 445) then 
				if button == "mouse_wheel_up" and press then 
					if client.pag_resources > 0 then 
						client.pag_resources = client.pag_resources - 1
					end

					if #data_resources > 6 then 
						cursorY = scrollBarMove(#data_resources, 6, 412, 744, "y", client.pag_resources)
					end

				elseif button == "mouse_wheel_down" and press then 
					client.pag_resources = client.pag_resources + 1

					if client.pag_resources > #data_resources - 6 then
						client.pag_resources = #data_resources - 6
					end

					if #data_resources > 6 then 
						cursorY = scrollBarMove(#data_resources, 6, 412, 744, "y", client.pag_resources)
					end
				end
			end

		elseif window == "aclmanager" then 
			if functions.isCursorOnElement(415, 61, 485, 650) then 
				if button == "mouse_wheel_up" and client.pag_groups > 0 then
					client.pag_groups = client.pag_groups - 1
				elseif button == "mouse_wheel_down" and (#data_groups - 17 > 0) then
					client.pag_groups = client.pag_groups + 1
					if client.pag_groups > #data_groups - 17 then
						client.pag_groups = #data_groups - 17
					end
				end
			end

		elseif window == "punishment" then 
			if functions.isCursorOnElement(415, 61, 485, 650) then 
				if button == "mouse_wheel_up" and client.pag_punishment > 0 then
					client.pag_punishment = client.pag_punishment - 1
				elseif button == "mouse_wheel_down" and (#config.punishment.reasons - 17 > 0) then
					client.pag_punishment = client.pag_punishment + 1
					if client.pag_punishment > #config.punishment.reasons - 17 then
						client.pag_punishment = #config.punishment.reasons - 17
					end
				end
			end

		elseif window == "registers" then 
			if functions.isCursorOnElement(433, 83, 809, 726) then 
				if button == "mouse_wheel_up" and client.pag_logs > 0 then
					client.pag_logs = client.pag_logs - 1
				elseif button == "mouse_wheel_down" and (#data_logs - 9 > 0) then
					client.pag_logs = client.pag_logs + 1
					if client.pag_logs > #data_logs - 9 then
						client.pag_logs = #data_logs - 9
					end
				end
			end

		elseif window == "bans" then 
			if functions.isCursorOnElement(433, 83, 809, 645) then 
				if button == "mouse_wheel_up" and client.pag_bans > 0 then
					client.pag_bans = client.pag_bans - 1
				elseif button == "mouse_wheel_down" and (#data_bans - 8 > 0) then
					client.pag_bans = client.pag_bans + 1
					if client.pag_bans > #data_bans - 8 then
						client.pag_bans = #data_bans - 8
					end
				end
			end
		end
	end
end
addEventHandler("onClientKey", root, scrollBar)

function scrollBar (total, max, inicial, final, type)
    if string.lower(type) == 'y' then 
        screen = guiGetScreenSize()
        _,cy = getCursorPosition()
        inicial = (inicial*(screen/1080)) / screen
        final = (final*(screen/1080)) / screen 
    end  
    if cy >= (final) then 
        cy = (final)
    elseif cy <= (inicial) then 
        cy = (inicial)
    end             
    g = (screen *  (final)) - (screen * (inicial))   
    a = (screen *  cy) - (screen * (inicial))
    cursorYProgress = screen * (cy / (screen/1080)) 
    proxPag = (total-max)/g*(a)
    return cursorYProgress, proxPag
end

function scrollBarMove(total, max, inicial, final, type, prox)
    if string.lower(type) == 'y' then 
    	screen = guiGetScreenSize()
        inicial = (inicial*(screen/1080)) / screen
        final = (final*(screen/1080)) / screen 
    end     
    cy = (((final-inicial)/(total-max))*prox)+inicial
    g = math.floor((screen *  (final)) - (screen * (inicial)))    
    a = math.floor((screen *  cy) - (screen * (inicial)))
    cursorYProgress = screen * (cy / (screen/1080)) 
    return cursorYProgress
end

function executeCommandClient(command)
	if not config.permissionsFunctions[verify_acl]["execute_command"] then 
		sendMessage("client", localPlayer, "Você não possui permissão para realizar essa ação.", "error")
		return
	end

	local not_returned
	local command_function, msgError = loadstring("return "..command)

	if msgError then 
		command_function, msgError = loadstring(command)
	end

	if msgError then 
		sendMessage("client", localPlayer, "Falha ao executar o comando.", "error")
		return
	end

	local results = {pcall(command_function)}
	
	if not results[1] then 
		sendMessage("client", localPlayer, "Falha ao executar o comando.", "error")
		return
	end

	local result_string = ""
	local first = true 

	for i = 2, #results do 
		if first then 
			first = false
		else
			result_string = result_string..", "
		end

		local result_type = type(results[i])

		if isElement(results[i]) then 
			result_type = "element:"..getElementType(results[i])
		end

		result_string = result_string..tostring(results[i])
	end

	if #results > 1 then 
		outputDebugString("Result command line: "..result_string)
		sendMessage("client", localPlayer, "Comando executado com sucesso.", "success")
		return
	end

	sendMessage("client", localPlayer, "Comando executado com sucesso.", "success")
end