local window = "index"
local vips_activies = {}
local last_transactions = {}

local client = {
	radius = {255, 0};
	radiusActive = {255, 0};
	visible = false;
	visibleActive = false;
	tick = nil;
	tickActive = nil;

	pag_category = 0;
	pag_index = 0;
	pag_vips = 0;
	pag_actives = 0;
	pag_keys = 0;
	pag_keysactive = 0;
	pag_coins = 0;
	pag_logs = 0;

	edits = {
		["ID"] = {false, guiCreateEdit(9999, 9999, 0, 0, "", false)};
		["QUANTIDADE/DIAS"] = {false, guiCreateEdit(9999, 9999, 0, 0, "", false)};
		["QUANTIDADE"] = {false, guiCreateEdit(9999, 9999, 0, 0, "", false)};
		["SEARCH"] = {false, guiCreateEdit(9999, 9999, 0, 0, "", false)};
	};

	windows = {
		{134, 129, 260, 53, "Área inicial", "index"};
		{134, 186, 260, 53, "Gerenciar vip", "vip"};
		{134, 243, 260, 53, "Gerenciar keys", "keys"};
		{134, 300, 260, 53, "Gerenciar pontos", "pontos"};
		{134, 357, 260, 53, "Logs", "logs"};
	};
}

local function onDraw ()

	local alpha = interpolateBetween (client.radius[1], 0, 0, client.radius[2], 0, 0, (getTickCount ( ) - client.tick)/300, "Linear")

	dxDrawImageSpacing(89, 57, 993, 634, 5, "assets/images/background.png", 0, 0, 0, tocolor(255, 255, 255, alpha))

	line = 0
	for i, v in ipairs(client.windows) do
		if i > client.pag_category and line < 5 then 
			line = line + 1

			local count = (129 + (186 - 129) * i - (186 - 129))

			dxDrawImageSpacing(134, count, 260, 53, 5, "assets/images/bg.png", 0, 0, 0, tocolor(255, 255, 255, alpha))

			if functions.isCursorOnElement(134, count, 260, 53) or window == v[6] then
				dxDrawImageSpacing(134, count, 260, 53, 5, "assets/images/bg_select.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
				dxDrawImageSpacing(145, count+14, 26, 26, 5, "assets/images/"..v[6]..".png", 0, 0, 0, tocolor(141, 106, 240, alpha))
				dxDrawText(v[5], 184, count+15, 82, 23, tocolor(141, 106, 240, alpha), 1.0, getFont("light", 12))
			else
				dxDrawImageSpacing(145, count+14, 26, 26, 5, "assets/images/"..v[6]..".png", 0, 0, 0, tocolor(96, 92, 105, alpha))
				dxDrawText(v[5], 184, count+15, 82, 23, tocolor(217, 217, 217 , alpha), 1.0, getFont("light", 12))
			end
		end
	end

	if window == "index" then 
		dxDrawText("Renda mensal:", 431, 107, 151, 30, tocolor(217, 217, 217, alpha), 1.0, getFont("medium", 16))
		dxDrawText("$ "..convertNumber(sumAllValues()).."", 948, 107, 101, 30, tocolor(143, 199, 108, alpha), 1.0, getFont("medium", 16), "right", "top", false, false, false, false, false)
	
		dxDrawImageSpacing(431, 151, 618, 161, 5, "assets/images/bg_activies.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
		dxDrawText("VIPS ATIVOS", 453, 177, 118, 30, tocolor(210, 209, 209, alpha), 1.0, getFont("regular", 16))
		dxDrawText("PONTOS EM USO", 767, 177, 159, 30, tocolor(210, 209, 209, alpha), 1.0, getFont("regular", 16))

		if vips_active then
			dxDrawText(#vips_active, 453, 222, 13, 30, tocolor(210, 209, 209, alpha), 1.0, getFont("regular", 16))
		end
		dxDrawText(convertNumber(allPoints()), 767, 222, 13, 30, tocolor(210, 209, 209, alpha), 1.0, getFont("regular", 16))

		dxDrawImageSpacing(431, 335, 13, 13, 5, "assets/images/eclipse.png", 0, 0, 0, tocolor(217, 217, 217, alpha))
		dxDrawText("Histórico de atividades", 456, 326, 219, 30, tocolor(217, 217, 217, alpha), 1.0, getFont("regular", 15))

		dxDrawText("Proprietario", 461, 369, 40, 23, tocolor(210, 209, 209, alpha), 1.0, getFont("regular", 12))
		dxDrawText("Data", 666, 369, 40, 23, tocolor(210, 209, 209, alpha), 1.0, getFont("regular", 12))
		dxDrawText("Valor", 815, 369, 40, 23, tocolor(210, 209, 209, alpha), 1.0, getFont("regular", 12))
		dxDrawText("Tipo", 999, 369, 40, 23, tocolor(210, 209, 209, alpha), 1.0, getFont("regular", 12))

		line = 0 
		for i, v in ipairs(last_transactions) do
			if v.state == "Ativado" then
				if i > client.pag_index and line < 4 then 
					line = line + 1

					local count = (401 + (466 - 401) * line - (466 - 401))

					if functions.isCursorOnElement(431, count, 618, 58) then 
						dxDrawImageSpacing(431, count, 618, 58, 5, "assets/images/bg_gridlist.png", 0, 0, 0, tocolor(141, 106, 240, alpha))
					else
						dxDrawImageSpacing(431, count, 618, 58, 5, "assets/images/bg_gridlist.png", 0, 0, 0, tocolor(83, 80, 89, alpha))
					end

					dxDrawText(v.player, 461, count+16, 40, 23, tocolor(154, 154, 154, alpha), 1.0, getFont("regular", 12))
					dxDrawText(timestampToDateString(v.date), 666, count+16, 40, 23, tocolor(154, 154, 154, alpha), 1.0, getFont("regular", 12), "center", "top")
					
					if (type(v.price) == 'number') then 
						dxDrawText("$ "..v.price.."", 815, count+16, 40, 23, tocolor(102, 204, 170, alpha), 1.0, getFont("regular", 12), "center", "top")
					else
						dxDrawText("undefined", 815, count+16, 40, 23, tocolor(102, 204, 170, alpha), 1.0, getFont("regular", 12), "center", "top")
					end

					if v.product ~= "vPoints" then 
						dxDrawText("VIP", 993, count+16, 40, 23, tocolor(154, 154, 154, alpha), 1.0, getFont("regular", 12), "right", "top")
					else
						dxDrawText("PONTOS", 993, count+16, 40, 23, tocolor(154, 154, 154, alpha), 1.0, getFont("regular", 12), "right", "top")
					end
				end
			end
		end

	elseif window == "vip" then 
		dxDrawText("ID", 461, 107, 15, 23, tocolor(210, 209, 209, alpha), 1.0, getFont("regular", 12))
		dxDrawText("Proprietario", 593, 107, 15, 23, tocolor(210, 209, 209, alpha), 1.0, getFont("regular", 12))
		dxDrawText("Produto", 964, 107, 15, 23, tocolor(210, 209, 209, alpha), 1.0, getFont("regular", 12))

		line = 0
		for i, v in ipairs(vips_active) do
			if ((guiGetText(client["edits"]["SEARCH"][2]) == "" or guiGetText(client["edits"]["SEARCH"][2]) == "Pesquisar...") or string.find(string.lower(v.player), string.lower(guiGetText(client["edits"]["SEARCH"][2]))) or (guiGetText(client["edits"]["SEARCH"][2]) == "" or guiGetText(client["edits"]["SEARCH"][2]) == "Pesquisar...") or string.find(string.lower(v.id_player), string.lower(guiGetText(client["edits"]["SEARCH"][2])))) then
				if (i > client.pag_actives and line < 7) then 
					line = line + 1

					local count = (139 + (204 - 139) * line - (204 - 139))

					if functions.isCursorOnElement(431, count, 618, 58) or select_activies == i then 
						dxDrawImageSpacing(431, count, 618, 58, 5, "assets/images/bg_gridlist.png", 0, 0, 0, tocolor(141, 106, 240, alpha))
					else
						dxDrawImageSpacing(431, count, 618, 58, 5, "assets/images/bg_gridlist.png", 0, 0, 0, tocolor(83, 80, 89, alpha))
					end

					dxDrawText("#"..v.id_player.."", 461, count+16, 40, 23, tocolor(154, 154, 154, alpha), 1.0, getFont("regular", 12))
					dxDrawText(v.player, 593, count+16, 125, 23, tocolor(154, 154, 154, alpha), 1.0, getFont("regular", 12))
					dxDrawText(v.product, 945, count+16, 82, 23, tocolor(154, 154, 154, alpha), 1.0, getFont("regular", 12), "right", "top")

				end
			end
		end

		dxDrawImageSpacing(431, 600, 279, 49, 5, "assets/images/bg_search.png", 0, 0, 0, tocolor(255, 255, 255, alpha))

		if (client.edits["SEARCH"][1] and isElement(client.edits["SEARCH"][2])) then
			dxDrawText((guiGetText(client.edits["SEARCH"][2]) or "").. "|", 494, 612, 83, 23, tocolor(88, 85, 96, alpha), 1.0, getFont("regular", 12))
			
		elseif (#guiGetText(client.edits["SEARCH"][2]) >= 1) then 
			dxDrawText((guiGetText(client.edits["SEARCH"][2]) or ""), 494, 612, 83, 23, tocolor(88, 85, 96, alpha), 1.0, getFont("regular", 12))
		else
			dxDrawText("Pesquisar...", 494, 612, 83, 23, tocolor(88, 85, 96, alpha), 1.0, getFont("regular", 12))
		end

		dxDrawImageSpacing(718, 600, 163, 49, 5, "assets/images/button.png", 0, 0, 0, (functions.isCursorOnElement(718, 600, 163, 49) and tocolor(141, 106, 240, alpha) or tocolor(53, 50, 63, alpha)))
		dxDrawImageSpacing(886, 600, 163, 49, 5, "assets/images/button.png", 0, 0, 0, (functions.isCursorOnElement(886, 600, 163, 49) and tocolor(141, 106, 240, alpha) or tocolor(53, 50, 63, alpha)))
		dxDrawText("SETAR VIP", 718, 602, 163, 49, tocolor(210, 209, 209, alpha), 1.0, getFont("regular", 12), "center", "center", false, false, false, false, false)
		dxDrawText("REMOVER VIP", 886, 602, 163, 49, tocolor(210, 209, 209, alpha), 1.0, getFont("regular", 12), "center", "center", false, false, false, false, false)

		if modalvip then 
			dxDrawImageSpacing(89, 57, 993, 634, 5, "assets/images/bg_modal.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
			dxDrawText("SETAR VIP", 359, 197, 453, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("medium", 15), "center", "center", false, false, false, false, false)
			dxDrawText("PREENCHA OS DADOS ABAIXO", 359, 231, 453, 15, tocolor(255, 255, 255, alpha), 1.0, getFont("light", 12), "center", "center", false, false, false, false, false)

			if (client.edits["ID"][1] and isElement(client.edits["ID"][2])) then
				dxDrawText((guiGetText(client.edits["ID"][2]) or "").. "|", 390, 289, 391, 70, tocolor(121, 118, 129, alpha), 1.0, getFont("medium", 12), "center", "center")
				
			elseif (#guiGetText(client.edits["ID"][2]) >= 1) then 
				dxDrawText((guiGetText(client.edits["ID"][2]) or ""), 390, 289, 391, 70, tocolor(121, 118, 129, alpha), 1.0, getFont("medium", 12), "center", "center")
			else
				dxDrawText("ID DO JOGADOR", 390, 289, 391, 70, tocolor(121, 118, 129, alpha), 1.0, getFont("medium", 12), "center", "center")
			end

			if vip_select == nil then 
				vip_text = "Nenhum VIP selecionado"
			else
				vip_text = vip_select
			end

			if select_vip then 
				dxDrawRectangle(390, 436, 391, 177, tocolor(74, 70, 85, alpha))
				dxDrawImageSpacing(735, 385, 24, 24, 5, "assets/images/arrowc.png", 0, 0, 0, (functions.isCursorOnElement(735, 385, 24, 24) and tocolor(141, 106, 240, alpha) or tocolor(188, 187, 189, alpha)))

				dxDrawText(vip_text, 390, 361, 391, 70, tocolor(255, 255, 255, alpha), 1.0, getFont("medium", 12), "center", "center")

				dxDrawText("Selecione o plano.", 406, 448, 138, 15, tocolor(255, 255, 255, alpha), 1.0, getFont("medium", 12))

				line = 0
				for i, v in ipairs(config.vips) do 
					if (i > client.pag_vips and line < 5) then 
						line = line + 1
						
						local count = (472 + (497 - 472) * line - (497 - 472))

						dxDrawText(v[1], 406, count, 150, 15, (functions.isCursorOnElement(406, count, 51, 15) and tocolor(141, 106, 240, alpha) or tocolor(168, 168, 168, alpha)), 1.0, getFont("light", 12))
					end
				end
			else
				dxDrawImageSpacing(735, 385, 24, 24, 5, "assets/images/arrowb.png", 0, 0, 0, (functions.isCursorOnElement(735, 385, 24, 24) and tocolor(141, 106, 240, alpha) or tocolor(188, 187, 189, alpha)))
				dxDrawText(vip_text, 390, 361, 391, 70, tocolor(255, 255, 255, alpha), 1.0, getFont("medium", 12), "center", "center")
			end
			if not select_vip then
				if (client.edits["QUANTIDADE/DIAS"][1] and isElement(client.edits["QUANTIDADE/DIAS"][2])) then
					dxDrawText((guiGetText(client.edits["QUANTIDADE/DIAS"][2]) or "").. "|", 390, 436, 391, 70, tocolor(121, 118, 129, alpha), 1.0, getFont("medium", 12), "center", "center")
					
				elseif (#guiGetText(client.edits["QUANTIDADE/DIAS"][2]) >= 1) then 
					dxDrawText((guiGetText(client.edits["QUANTIDADE/DIAS"][2]) or ""), 390, 436, 391, 70, tocolor(121, 118, 129, alpha), 1.0, getFont("medium", 12), "center", "center")
				else
					dxDrawText("QUANTIDADE DE DIAS", 390, 436, 391, 70, tocolor(121, 118, 129, alpha), 1.0, getFont("medium", 12), "center", "center")
				end
			end

			if not select_vip then 
				dxDrawText("CONFIRMAR", 439, 533, 116, 20, (functions.isCursorOnElement(439, 533, 116, 20) and tocolor(157, 227, 114, alpha) or tocolor(255, 255, 255, alpha)), 1.0, getFont("regular", 14))
				dxDrawText("CANCELAR", 630, 533, 116, 20, (functions.isCursorOnElement(630, 533, 116, 20) and tocolor(229, 99, 99, alpha) or tocolor(255, 255, 255, alpha)), 1.0, getFont("regular", 14))
			end
		end

	elseif window == "keys" then 
		dxDrawText("Key", 461, 107, 15, 23, tocolor(210, 209, 209, alpha), 1.0, getFont("regular", 12))
		dxDrawText("Gerador", 666, 107, 15, 23, tocolor(210, 209, 209, alpha), 1.0, getFont("regular", 12))
		dxDrawText("Tipo", 978, 107, 15, 23, tocolor(210, 209, 209, alpha), 1.0, getFont("regular", 12))

		line = 0
		for i, v in ipairs(keys_active) do
			if ((guiGetText(client["edits"]["SEARCH"][2]) == "" or guiGetText(client["edits"]["SEARCH"][2]) == "Pesquisar...") or string.find(string.lower(v.key), string.lower(guiGetText(client["edits"]["SEARCH"][2]))) or (guiGetText(client["edits"]["SEARCH"][2]) == "" or guiGetText(client["edits"]["SEARCH"][2]) == "Pesquisar...") or string.find(string.lower(v.activator), string.lower(guiGetText(client["edits"]["SEARCH"][2])))) then
				if (i > client.pag_keysactive and line < 7) then 
					line = line + 1

					local count = (139 + (204 - 139) * line - (204 - 139))

					if functions.isCursorOnElement(431, count, 618, 58) or select_key == i then 
						dxDrawImageSpacing(431, count, 618, 58, 5, "assets/images/bg_gridlist.png", 0, 0, 0, tocolor(141, 106, 240, alpha))
					else
						dxDrawImageSpacing(431, count, 618, 58, 5, "assets/images/bg_gridlist.png", 0, 0, 0, tocolor(83, 80, 89, alpha))
					end

					dxDrawText(v.key, 461, count+16, 40, 23, tocolor(154, 154, 154, alpha), 1.0, getFont("regular", 12))
					dxDrawText(v.activator, 666, count+16, 125, 23, tocolor(154, 154, 154, alpha), 1.0, getFont("regular", 12))
					
					if v.type == "Vip" then 
						dxDrawText("VIP", 945, count+16, 82, 23, tocolor(154, 154, 154, alpha), 1.0, getFont("regular", 12), "right", "top")
					else
						dxDrawText("PONTOS: "..v.quantity.."", 945, count+16, 82, 23, tocolor(154, 154, 154, alpha), 1.0, getFont("regular", 12), "right", "top")
					end
				end
			end
		end

		dxDrawImageSpacing(431, 600, 279, 49, 5, "assets/images/bg_search.png", 0, 0, 0, tocolor(255, 255, 255, alpha))

		if (client.edits["SEARCH"][1] and isElement(client.edits["SEARCH"][2])) then
			dxDrawText((guiGetText(client.edits["SEARCH"][2]) or "").. "|", 494, 612, 83, 23, tocolor(88, 85, 96, alpha), 1.0, getFont("regular", 12))
			
		elseif (#guiGetText(client.edits["SEARCH"][2]) >= 1) then 
			dxDrawText((guiGetText(client.edits["SEARCH"][2]) or ""), 494, 612, 83, 23, tocolor(88, 85, 96, alpha), 1.0, getFont("regular", 12))
		else
			dxDrawText("Pesquisar...", 494, 612, 83, 23, tocolor(88, 85, 96, alpha), 1.0, getFont("regular", 12))
		end

		dxDrawImageSpacing(718, 600, 163, 49, 5, "assets/images/button.png", 0, 0, 0, (functions.isCursorOnElement(718, 600, 163, 49) and tocolor(141, 106, 240, alpha) or tocolor(53, 50, 63, alpha)))
		dxDrawImageSpacing(886, 600, 163, 49, 5, "assets/images/button.png", 0, 0, 0, (functions.isCursorOnElement(886, 600, 163, 49) and tocolor(141, 106, 240, alpha) or tocolor(53, 50, 63, alpha)))
		dxDrawText("GERAR KEY", 718, 602, 163, 49, tocolor(210, 209, 209, alpha), 1.0, getFont("regular", 12), "center", "center", false, false, false, false, false)
		dxDrawText("DELETAR KEY", 886, 602, 163, 49, tocolor(210, 209, 209, alpha), 1.0, getFont("regular", 12), "center", "center", false, false, false, false, false)

		if modalkey then 
			dxDrawImageSpacing(89, 57, 993, 634, 5, "assets/images/bg_modal2.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
			dxDrawText("GERAR KEY", 359, 242, 453, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("medium", 15), "center", "center", false, false, false, false, false)
			dxDrawText("PREENCHA OS DADOS ABAIXO", 359, 276, 453, 15, tocolor(255, 255, 255, alpha), 1.0, getFont("light", 12), "center", "center", false, false, false, false, false)
			
			--if vip_select == "Pontos" then
				if (client.edits["QUANTIDADE"][1] and isElement(client.edits["QUANTIDADE"][2])) then
					dxDrawText((guiGetText(client.edits["QUANTIDADE"][2]) or "").. "|", 390, 401, 391, 70, tocolor(121, 118, 129, alpha), 1.0, getFont("medium", 12), "center", "center")
					
				elseif (#guiGetText(client.edits["QUANTIDADE"][2]) >= 1) then 
					dxDrawText((guiGetText(client.edits["QUANTIDADE"][2]) or ""), 390, 401, 391, 70, tocolor(121, 118, 129, alpha), 1.0, getFont("medium", 12), "center", "center")
				else
					dxDrawText("QUANTIDADE", 390, 401, 391, 70, tocolor(121, 118, 129, alpha), 1.0, getFont("medium", 12), "center", "center")
				end
			--else
			--	if (client.edits["QUANTIDADE/DIAS"][1] and isElement(client.edits["QUANTIDADE/DIAS"][2])) then
			--		dxDrawText((guiGetText(client.edits["QUANTIDADE/DIAS"][2]) or "").. "|", 390, 401, 391, 70, tocolor(121, 118, 129, alpha), 1.0, getFont("medium", 12), "center", "center")
			--		
			--	elseif (#guiGetText(client.edits["QUANTIDADE/DIAS"][2]) >= 1) then 
			--		dxDrawText((guiGetText(client.edits["QUANTIDADE/DIAS"][2]) or ""), 390, 401, 391, 70, tocolor(121, 118, 129, alpha), 1.0, getFont("medium", 12), "center", "center")
			--	else
			--		dxDrawText("QUANTIDADE DE DIAS", 390, 401, 391, 70, tocolor(121, 118, 129, alpha), 1.0, getFont("medium", 12), "center", "center")
			--	end
			--end
			
			if vip_select == nil then 
				vip_texto = "Nenhum produto selecionado"
			else
				vip_texto = vip_select
			end

			if select_product then 
				dxDrawRectangle(390, 436-30, 391, 200, tocolor(74, 70, 85, alpha))
				dxDrawImageSpacing(735, 385-30, 24, 24, 5, "assets/images/arrowc.png", 0, 0, 0, (functions.isCursorOnElement(735, 385-30, 24, 24) and tocolor(141, 106, 240, alpha) or tocolor(188, 187, 189, alpha)))

				dxDrawText(vip_texto, 390, 361-30, 391, 70, tocolor(255, 255, 255, alpha), 1.0, getFont("medium", 12), "center", "center")

				dxDrawText("Selecione o produto.", 406, 448-30, 138, 15, tocolor(255, 255, 255, alpha), 1.0, getFont("medium", 12))

				line = 0
				for i, v in ipairs(config.productsKey) do 
					if (i > client.pag_vips and line < 6) then 
						line = line + 1
						
						local count = (472 + (497 - 472) * line - (497 - 472))

						dxDrawText(v[1], 406, count-30, 150, 15, (functions.isCursorOnElement(406, count-30, 51, 15) and tocolor(141, 106, 240, alpha) or tocolor(168, 168, 168, alpha)), 1.0, getFont("light", 12))
					end
				end
			else
				dxDrawImageSpacing(735, 385-30, 24, 24, 5, "assets/images/arrowb.png", 0, 0, 0, (functions.isCursorOnElement(735, 385-30, 24, 24) and tocolor(141, 106, 240, alpha) or tocolor(188, 187, 189, alpha)))
				dxDrawText(vip_texto, 390, 361-30, 391, 70, tocolor(255, 255, 255, alpha), 1.0, getFont("medium", 12), "center", "center")
			end

			if not select_product then 
				dxDrawText("CONFIRMAR", 439, 496, 116, 20, (functions.isCursorOnElement(439, 496, 116, 20) and tocolor(157, 227, 114, alpha) or tocolor(255, 255, 255, alpha)), 1.0, getFont("regular", 14))
				dxDrawText("CANCELAR", 630, 496, 116, 20, (functions.isCursorOnElement(630, 496, 116, 20) and tocolor(229, 99, 99, alpha) or tocolor(255, 255, 255, alpha)), 1.0, getFont("regular", 14))
			end
		end

	elseif window == "pontos" then 
		dxDrawText("Jogador", 461, 107, 15, 23, tocolor(210, 209, 209, alpha), 1.0, getFont("regular", 12))
		dxDrawText("Quantidade", 1010, 107, 15, 23, tocolor(210, 209, 209, alpha), 1.0, getFont("regular", 12), "right", "top")

		line = 0
		for i, v in ipairs(last_transactions) do
			if ((guiGetText(client["edits"]["SEARCH"][2]) == "" or guiGetText(client["edits"]["SEARCH"][2]) == "Pesquisar...") or string.find(string.lower(v.player), string.lower(guiGetText(client["edits"]["SEARCH"][2]))) or (guiGetText(client["edits"]["SEARCH"][2]) == "" or guiGetText(client["edits"]["SEARCH"][2]) == "Pesquisar...") or string.find(string.lower(v.id_player), string.lower(guiGetText(client["edits"]["SEARCH"][2])))) then
				if (i > client.pag_coins and line < 7) then
					if v.product == "vPoints" and v.state == "Ativado" then
						line = line + 1

						local count = (139 + (204 - 139) * line - (204 - 139))

						if functions.isCursorOnElement(431, count, 618, 58) then 
							dxDrawImageSpacing(431, count, 618, 58, 5, "assets/images/bg_gridlist.png", 0, 0, 0, tocolor(141, 106, 240, alpha))
						else
							dxDrawImageSpacing(431, count, 618, 58, 5, "assets/images/bg_gridlist.png", 0, 0, 0, tocolor(83, 80, 89, alpha))
						end

						dxDrawText(""..v.player.." #"..v.id_player.."", 461, count+16, 40, 23, tocolor(154, 154, 154, alpha), 1.0, getFont("regular", 12))
						dxDrawText(v.days, 945, count+16, 82, 23, tocolor(154, 154, 154, alpha), 1.0, getFont("regular", 12), "right", "top")
					end
				end
			end
		end

		dxDrawImageSpacing(431, 600, 279, 49, 5, "assets/images/bg_search.png", 0, 0, 0, tocolor(255, 255, 255, alpha))

		if (client.edits["SEARCH"][1] and isElement(client.edits["SEARCH"][2])) then
			dxDrawText((guiGetText(client.edits["SEARCH"][2]) or "").. "|", 494, 612, 83, 23, tocolor(88, 85, 96, alpha), 1.0, getFont("regular", 12))
			
		elseif (#guiGetText(client.edits["SEARCH"][2]) >= 1) then 
			dxDrawText((guiGetText(client.edits["SEARCH"][2]) or ""), 494, 612, 83, 23, tocolor(88, 85, 96, alpha), 1.0, getFont("regular", 12))
		else
			dxDrawText("Pesquisar...", 494, 612, 83, 23, tocolor(88, 85, 96, alpha), 1.0, getFont("regular", 12))
		end

		dxDrawImageSpacing(718, 600, 163, 49, 5, "assets/images/button.png", 0, 0, 0, (functions.isCursorOnElement(718, 600, 163, 49) and tocolor(141, 106, 240, alpha) or tocolor(53, 50, 63, alpha)))
		dxDrawImageSpacing(886, 600, 163, 49, 5, "assets/images/button.png", 0, 0, 0, (functions.isCursorOnElement(886, 600, 163, 49) and tocolor(141, 106, 240, alpha) or tocolor(53, 50, 63, alpha)))
		dxDrawText("SETAR PONTOS", 718, 602, 163, 49, tocolor(210, 209, 209, alpha), 1.0, getFont("regular", 12), "center", "center", false, false, false, false, false)
		dxDrawText("REMOVER PONTOS", 886, 602, 163, 49, tocolor(210, 209, 209, alpha), 1.0, getFont("regular", 12), "center", "center", false, false, false, false, false)

		if modalpontos then 
			dxDrawImageSpacing(89, 57, 993, 634, 5, "assets/images/bg_modal2.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
			dxDrawText("SETAR PONTOS", 359, 242, 453, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("medium", 15), "center", "center", false, false, false, false, false)
			dxDrawText("PREENCHA OS DADOS ABAIXO", 359, 276, 453, 15, tocolor(255, 255, 255, alpha), 1.0, getFont("light", 12), "center", "center", false, false, false, false, false)

			if (client.edits["ID"][1] and isElement(client.edits["ID"][2])) then
				dxDrawText((guiGetText(client.edits["ID"][2]) or "").. "|", 390, 326, 391, 70, tocolor(121, 118, 129, alpha), 1.0, getFont("medium", 12), "center", "center")
				
			elseif (#guiGetText(client.edits["ID"][2]) >= 1) then 
				dxDrawText((guiGetText(client.edits["ID"][2]) or ""), 390, 326, 391, 70, tocolor(121, 118, 129, alpha), 1.0, getFont("medium", 12), "center", "center")
			else
				dxDrawText("ID DO JOGADOR", 390, 326, 391, 70, tocolor(121, 118, 129, alpha), 1.0, getFont("medium", 12), "center", "center")
			end

			if (client.edits["QUANTIDADE"][1] and isElement(client.edits["QUANTIDADE"][2])) then
				dxDrawText((guiGetText(client.edits["QUANTIDADE"][2]) or "").. "|", 390, 401, 391, 70, tocolor(121, 118, 129, alpha), 1.0, getFont("medium", 12), "center", "center")
				
			elseif (#guiGetText(client.edits["QUANTIDADE"][2]) >= 1) then 
				dxDrawText((guiGetText(client.edits["QUANTIDADE"][2]) or ""), 390, 401, 391, 70, tocolor(121, 118, 129, alpha), 1.0, getFont("medium", 12), "center", "center")
			else
				dxDrawText("QUANTIDADE (VPOINTS)", 390, 401, 391, 70, tocolor(121, 118, 129, alpha), 1.0, getFont("medium", 12), "center", "center")
			end

			dxDrawText("CONFIRMAR", 439, 496, 116, 20, (functions.isCursorOnElement(439, 496, 116, 20) and tocolor(157, 227, 114, alpha) or tocolor(255, 255, 255, alpha)), 1.0, getFont("regular", 14))
			dxDrawText("CANCELAR", 630, 496, 116, 20, (functions.isCursorOnElement(630, 496, 116, 20) and tocolor(229, 99, 99, alpha) or tocolor(255, 255, 255, alpha)), 1.0, getFont("regular", 14))
		end

		if modalremove then 
			dxDrawImageSpacing(89, 57, 993, 634, 5, "assets/images/bg_modal2.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
			dxDrawText("REMOVER PONTOS", 359, 242, 453, 20, tocolor(255, 255, 255, alpha), 1.0, getFont("medium", 15), "center", "center", false, false, false, false, false)
			dxDrawText("PREENCHA OS DADOS ABAIXO", 359, 276, 453, 15, tocolor(255, 255, 255, alpha), 1.0, getFont("light", 12), "center", "center", false, false, false, false, false)

			if (client.edits["ID"][1] and isElement(client.edits["ID"][2])) then
				dxDrawText((guiGetText(client.edits["ID"][2]) or "").. "|", 390, 326, 391, 70, tocolor(121, 118, 129, alpha), 1.0, getFont("medium", 12), "center", "center")
				
			elseif (#guiGetText(client.edits["ID"][2]) >= 1) then 
				dxDrawText((guiGetText(client.edits["ID"][2]) or ""), 390, 326, 391, 70, tocolor(121, 118, 129, alpha), 1.0, getFont("medium", 12), "center", "center")
			else
				dxDrawText("ID DO JOGADOR", 390, 326, 391, 70, tocolor(121, 118, 129, alpha), 1.0, getFont("medium", 12), "center", "center")
			end

			if (client.edits["QUANTIDADE"][1] and isElement(client.edits["QUANTIDADE"][2])) then
				dxDrawText((guiGetText(client.edits["QUANTIDADE"][2]) or "").. "|", 390, 401, 391, 70, tocolor(121, 118, 129, alpha), 1.0, getFont("medium", 12), "center", "center")
				
			elseif (#guiGetText(client.edits["QUANTIDADE"][2]) >= 1) then 
				dxDrawText((guiGetText(client.edits["QUANTIDADE"][2]) or ""), 390, 401, 391, 70, tocolor(121, 118, 129, alpha), 1.0, getFont("medium", 12), "center", "center")
			else
				dxDrawText("QUANTIDADE (VPOINTS)", 390, 401, 391, 70, tocolor(121, 118, 129, alpha), 1.0, getFont("medium", 12), "center", "center")
			end

			dxDrawText("CONFIRMAR", 439, 496, 116, 20, (functions.isCursorOnElement(439, 496, 116, 20) and tocolor(157, 227, 114, alpha) or tocolor(255, 255, 255, alpha)), 1.0, getFont("regular", 14))
			dxDrawText("CANCELAR", 630, 496, 116, 20, (functions.isCursorOnElement(630, 496, 116, 20) and tocolor(229, 99, 99, alpha) or tocolor(255, 255, 255, alpha)), 1.0, getFont("regular", 14))
		end

	elseif window == "logs" then 
		dxDrawText("Hístorico", 461, 107, 15, 23, tocolor(210, 209, 209, alpha), 1.0, getFont("regular", 12))
		dxDrawText("Data", 978, 107, 15, 23, tocolor(210, 209, 209, alpha), 1.0, getFont("regular", 12))

		for i = 1, 7 do 
			local index = #last_transactions - client.pag_logs - i + 1

			if index > 0 then 
				local v = last_transactions[index]

				local count = (139 + (204 - 139) * i - (204 - 139))

				if functions.isCursorOnElement(431, count, 618, 58) then 
					dxDrawImageSpacing(431, count, 618, 58, 5, "assets/images/bg_gridlist.png", 0, 0, 0, tocolor(141, 106, 240, alpha))
				else
					dxDrawImageSpacing(431, count, 618, 58, 5, "assets/images/bg_gridlist.png", 0, 0, 0, tocolor(83, 80, 89, alpha))
				end

				if v.state == "Ativado" then 
					if v.product == "vPoints" then
						dxDrawText(""..v.activator.." #"..v.id_activator.." ativou "..v.days.." "..v.product.." para "..v.player.." #"..v.id_player.."", 461, count+17, 470, 23, tocolor(154, 154, 154, alpha), 1.0, getFont("regular", 11), "left", "top", true, false, false, false, false)
					else
						dxDrawText(""..v.activator.." #"..v.id_activator.." ativou um VIP "..v.product.." de "..v.days.." dia(s) para "..v.player.." #"..v.id_player.."", 461, count+17, 470, 23, tocolor(154, 154, 154, alpha), 1.0, getFont("regular", 11), "left", "top", true, false, false, false, false)
					end
				elseif v.state == "Removido" then 
					if v.product == "vPoints" then
						dxDrawText(""..v.activator.." #"..v.id_activator.." removeu "..v.days.." "..v.product.." de "..v.player.." #"..v.id_player.."", 461, count+17, 470, 23, tocolor(154, 154, 154, alpha), 1.0, getFont("regular", 11), "left", "top", true, false, false, false, false)
					else
						dxDrawText(""..v.activator.." #"..v.id_activator.." removeu o VIP "..v.product.." de "..v.player.."", 461, count+17, 470, 23, tocolor(154, 154, 154, alpha), 1.0, getFont("regular", 11), "left", "top", true, false, false, false, false)
					end
				end

				dxDrawText(timestampToDateString(v.data), 1010, count+17, 15, 23, tocolor(154, 154, 154, alpha), 1.0, getFont("regular", 11), "right", "top")
			end
		end
	end
end

local function onDrawnActive ()
	dxDrawImage(434, 40-150, 292, 100, "assets/images/effect.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
	
	dxDrawImageSpacing(400, 48-150, 61, 61, 5, "assets/images/b1.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
	dxDrawImageSpacing(692, 48-150, 61, 61, 5, "assets/images/b2.png", 0, 0, 0, tocolor(255, 255, 255, alpha))

	dxDrawImageSpacing(480, 38-150, 24, 24, 5, "assets/images/f1.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
	dxDrawImageSpacing(654, 38-150, 24, 24, 5, "assets/images/f2.png", 0, 0, 0, tocolor(255, 255, 255, alpha))

	dxDrawText("ATIVAÇÃO", 523, 40-150, 106, 30, tocolor(255, 255, 255, alpha), 1.0, getFont("semibold", 18))
	if type_active == "Pontos" then
		dxDrawText("O jogador "..activator_player.." ("..activator_playerID..") ativou\n "..activator_playerVIP.." Pontos com sucesso!", 406, 70-150, 341, 46, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 14), "center", "top")
	else
		dxDrawText("O jogador "..activator_player.." ("..activator_playerID..") ativou\num VIP "..activator_playerVIP.." com sucesso!", 406, 70-150, 341, 46, tocolor(255, 255, 255, alpha), 1.0, getFont("regular", 14), "center", "top")
	end
end

registerEvent("squady.openManagerVIP", root, function()
	if not client.visible and client.radius[2] == 0 then 
		client.visible = true
		client.radius = {0, 255}
		client.tick = getTickCount()
		guiSetText(client.edits["ID"][2], "")
		guiSetText(client.edits["QUANTIDADE/DIAS"][2], "")
		guiSetText(client.edits["QUANTIDADE"][2], "")
		guiSetText(client.edits["SEARCH"][2], "")
		showCursor(true)
		addEventHandler("onClientRender", root, onDraw)
	elseif client.visible and client.radius[2] == 255 then 
		client.visible = false 
		client.radius = {255, 0}
		client.tick = getTickCount()
		setTimer(function()
			showCursor(false)
			removeEventHandler("onClientRender", root, onDraw)
		end, 300, 1)
	end
end)

bindKey("backspace", "down", function()
	if client.visible and client.radius[2] == 255 then 
		client.visible = false 
		client.radius = {255, 0}
		client.tick = getTickCount()
		setTimer(function()
			showCursor(false)
			removeEventHandler("onClientRender", root, onDraw)
		end, 300, 1)
	end
end)

registerEvent("squady.onDrawnActive", root, function(activator, activatorID, activatorVIP, type)
	if not client.visibleActive and client.radiusActive[2] == 0 then
		client.visibleActive = true
		client.radiusActive = {0, 255}
		client.tickActive = getTickCount()

		type_active = type
		activator_player = activator
		activator_playerID = activatorID
		activator_playerVIP = activatorVIP

		if not isElement(music_play) then
			music_play = playSound(config.musicas[math.random(#config.musicas)], false)
			setSoundVolume(music_play, 0.5)
		end

		addEventHandler("onClientRender", root, onDrawnActive)
		setTimer(function()
			client.visibleActive = false
			client.radiusActive = {255, 0}
			client.tickActive = getTickCount()
			removeEventHandler("onClientRender", root, onDrawnActive)
			if isElement(music_play) then 
				destroyElement(music_play)
			end
		end, 15 * 1000, 1)
	end
end)

addEventHandler("onClientClick", root, function(button, state)
	if client.visible and client.radius[2] == 255 and button == "left" and state == "down" then 
		client.edits["ID"][1] = false
		client.edits["QUANTIDADE/DIAS"][1] = false
		client.edits["QUANTIDADE"][1] = false
		client.edits["SEARCH"][1] = false
		
		for i, v in ipairs(client.windows) do
			if functions.isCursorOnElement(v[1], v[2], v[3], v[4]) then 
				window = v[6]
				modalvip = false
				select_activies = nil
				guiSetText(client.edits["ID"][2], "")
				guiSetText(client.edits["QUANTIDADE/DIAS"][2], "")
				guiSetText(client.edits["QUANTIDADE"][2], "")
				guiSetText(client.edits["SEARCH"][2], "")
				break
			end
		end

		if window == "vip" then 
			if functions.isCursorOnElement(718, 600, 163, 49) then 
				if not modalvip then 
					modalvip = true
				end

			elseif functions.isCursorOnElement(431, 600, 279, 49) then 
				if (guiEditSetCaretIndex(client.edits["SEARCH"][2], (string.len(guiGetText(client.edits["SEARCH"][2]))))) then 
					guiEditSetMaxLength(client.edits["SEARCH"][2], 16)
					guiBringToFront(client.edits["SEARCH"][2])
					guiSetInputMode("no_binds_when_editing")
					client.edits["SEARCH"][1] = true
				end
			end

			line = 0
			for i, v in ipairs(vips_active) do 
				if (i > client.pag_actives and line < 7) then 
					line = line + 1

					local count = (139 + (204 - 139) * line - (204 - 139))

					if functions.isCursorOnElement(431, count, 618, 58) then 
						if select_activies then 
							select_activies = nil
						else
							select_activies = i
						end

						vip_remove = v
					end
				end
			end

			if functions.isCursorOnElement(886, 600, 163, 49) then 
				if select_activies then 

					local key = getPlayerSerial(localPlayer)    
					local hashtoKey = toJSON({vip = vip_remove})

					encodeString('aes128', hashtoKey, {key = key:sub(17)}, function(enc, iv)
						triggerServerEvent("squady.removeVIP", resourceRoot, enc, iv)
					end)
				end
			end

			if modalvip then 
				if functions.isCursorOnElement(390, 286, 391, 70) then 
					if (guiEditSetCaretIndex(client.edits["ID"][2], (string.len(guiGetText(client.edits["ID"][2]))))) then 
						guiSetProperty(client.edits["ID"][2], "ValidationString", "^[0-9]*")
						guiEditSetMaxLength(client.edits["ID"][2], 6)
						guiBringToFront(client.edits["ID"][2])
						guiSetInputMode("no_binds_when_editing")
						client.edits["ID"][1] = true
					end

				elseif functions.isCursorOnElement(390, 436, 391, 70) then 
					if not select_vip then
						if (guiEditSetCaretIndex(client.edits["QUANTIDADE/DIAS"][2], (string.len(guiGetText(client.edits["QUANTIDADE/DIAS"][2]))))) then 
							guiSetProperty(client.edits["QUANTIDADE/DIAS"][2], "ValidationString", "^[0-9]*")
							guiEditSetMaxLength(client.edits["QUANTIDADE/DIAS"][2], 2)
							guiBringToFront(client.edits["QUANTIDADE/DIAS"][2])
							guiSetInputMode("no_binds_when_editing")
							client.edits["QUANTIDADE/DIAS"][1] = true
						end
					end

				elseif functions.isCursorOnElement(439, 533, 116, 20) then 
					if vip_select ~= nil and guiGetText(client.edits["ID"][2]) ~= "" and guiGetText(client.edits["QUANTIDADE/DIAS"][2]) ~= "" then 
						
						local key = getPlayerSerial(localPlayer)    
						local hashtoKey = toJSON({receiver_id = guiGetText(client.edits["ID"][2]), vip = vip_select, time = guiGetText(client.edits["QUANTIDADE/DIAS"][2])})

						encodeString('aes128', hashtoKey, {key = key:sub(17)}, function(enc, iv)
							triggerServerEvent('squady.activeVipByID', resourceRoot, enc, iv)
						end)
						
					else
						sendMessage("client", localPlayer, "Preencha todos os campos.", "error")
					end

				elseif functions.isCursorOnElement(630, 533, 116, 20) then 
					if not select_vip then
						modalvip = false
					end

				elseif functions.isCursorOnElement(735, 385, 24, 24) then 
					if not select_vip then 
						select_vip = true
					else
						select_vip = false
					end
				end

				if select_vip then 
					line = 0
					for i, v in ipairs(config.vips) do 
						if (i > client.pag_vips and line < 5) then 
							line = line + 1
							
							local count = (472 + (497 - 472) * line - (497 - 472))

							if functions.isCursorOnElement(406, count, 51, 15) then 
								vip_select = v[1]
								select_vip = false
							end
						end
					end
				end
			end

		elseif window == "pontos" then 
			if functions.isCursorOnElement(718, 600, 163, 49) then 
				if not modalpontos then 
					modalpontos = true
				end

			elseif functions.isCursorOnElement(886, 600, 163, 49) then 
				if not modalremove then 
					modalremove = true
				end

			elseif functions.isCursorOnElement(431, 600, 279, 49) then 
				if (guiEditSetCaretIndex(client.edits["SEARCH"][2], (string.len(guiGetText(client.edits["SEARCH"][2]))))) then 
					guiEditSetMaxLength(client.edits["SEARCH"][2], 16)
					guiBringToFront(client.edits["SEARCH"][2])
					guiSetInputMode("no_binds_when_editing")
					client.edits["SEARCH"][1] = true
				end
			end
			
			if modalpontos then 
				if functions.isCursorOnElement(390, 326, 391, 70) then 
					if (guiEditSetCaretIndex(client.edits["ID"][2], (string.len(guiGetText(client.edits["ID"][2]))))) then 
						guiSetProperty(client.edits["ID"][2], "ValidationString", "^[0-9]*")
						guiEditSetMaxLength(client.edits["ID"][2], 6)
						guiBringToFront(client.edits["ID"][2])
						guiSetInputMode("no_binds_when_editing")
						client.edits["ID"][1] = true
					end

				elseif functions.isCursorOnElement(390, 401, 391, 70) then 
					if (guiEditSetCaretIndex(client.edits["QUANTIDADE"][2], (string.len(guiGetText(client.edits["QUANTIDADE"][2]))))) then 
						guiSetProperty(client.edits["QUANTIDADE"][2], "ValidationString", "^[0-9]*")
						guiEditSetMaxLength(client.edits["QUANTIDADE"][2], 4)
						guiBringToFront(client.edits["QUANTIDADE"][2])
						guiSetInputMode("no_binds_when_editing")
						client.edits["QUANTIDADE"][1] = true
					end

				elseif functions.isCursorOnElement(439, 496, 116, 20) then 
					if guiGetText(client.edits["ID"][2]) ~= "" and guiGetText(client.edits["QUANTIDADE"][2]) ~= "" then 

						local key = getPlayerSerial(localPlayer)    
						local hashtoKey = toJSON({amount = guiGetText(client.edits["QUANTIDADE"][2]), target = guiGetText(client.edits["ID"][2])})

						encodeString('aes128', hashtoKey, {key = key:sub(17)}, function(enc, iv)
							triggerServerEvent('squady.activeCoinsByID', resourceRoot, enc, iv)
						end)
					else
						sendMessage("client", localPlayer, "Preencha todos os campos.", "error")
					end

				elseif functions.isCursorOnElement(630, 496, 116, 20) then 
					modalpontos = false
				end
			end

			if modalremove then 
				if functions.isCursorOnElement(390, 326, 391, 70) then 
					if (guiEditSetCaretIndex(client.edits["ID"][2], (string.len(guiGetText(client.edits["ID"][2]))))) then 
						guiSetProperty(client.edits["ID"][2], "ValidationString", "^[0-9]*")
						guiEditSetMaxLength(client.edits["ID"][2], 6)
						guiBringToFront(client.edits["ID"][2])
						guiSetInputMode("no_binds_when_editing")
						client.edits["ID"][1] = true
					end

				elseif functions.isCursorOnElement(390, 401, 391, 70) then 
					if (guiEditSetCaretIndex(client.edits["QUANTIDADE"][2], (string.len(guiGetText(client.edits["QUANTIDADE"][2]))))) then 
						guiSetProperty(client.edits["QUANTIDADE"][2], "ValidationString", "^[0-9]*")
						guiEditSetMaxLength(client.edits["QUANTIDADE"][2], 4)
						guiBringToFront(client.edits["QUANTIDADE"][2])
						guiSetInputMode("no_binds_when_editing")
						client.edits["QUANTIDADE"][1] = true
					end

				elseif functions.isCursorOnElement(439, 496, 116, 20) then 
					if guiGetText(client.edits["ID"][2]) ~= "" and guiGetText(client.edits["QUANTIDADE"][2]) ~= "" then 
						triggerServerEvent("squady.removeCoinsByID", resourceRoot, guiGetText(client.edits["QUANTIDADE"][2]), guiGetText(client.edits["ID"][2]))
					else
						sendMessage("client", localPlayer, "Preencha todos os campos.", "error")
					end

				elseif functions.isCursorOnElement(630, 496, 116, 20) then 
					modalremove = false
				end
			end

		elseif window == "keys" then 
			if functions.isCursorOnElement(718, 600, 163, 49) then 
				if not modalkey then 
					modalkey = true
				end

			elseif functions.isCursorOnElement(431, 600, 279, 49) then 
				if (guiEditSetCaretIndex(client.edits["SEARCH"][2], (string.len(guiGetText(client.edits["SEARCH"][2]))))) then 
					guiEditSetMaxLength(client.edits["SEARCH"][2], 16)
					guiBringToFront(client.edits["SEARCH"][2])
					guiSetInputMode("no_binds_when_editing")
					client.edits["SEARCH"][1] = true
				end
			end

			line = 0
			for i, v in ipairs(keys_active) do
				if ((guiGetText(client["edits"]["SEARCH"][2]) == "" or guiGetText(client["edits"]["SEARCH"][2]) == "Pesquisar...") or string.find(string.lower(v.key), string.lower(guiGetText(client["edits"]["SEARCH"][2]))) or (guiGetText(client["edits"]["SEARCH"][2]) == "" or guiGetText(client["edits"]["SEARCH"][2]) == "Pesquisar...") or string.find(string.lower(v.activator), string.lower(guiGetText(client["edits"]["SEARCH"][2])))) then
					if (i > client.pag_keysactive and line < 7) then 
						line = line + 1

						local count = (139 + (204 - 139) * line - (204 - 139))

						if functions.isCursorOnElement(431, count, 618, 58) then 
							if select_key then 
								select_key = nil
							else
								select_key = i
							end	

							key_remove = v
						end
					end
				end
			end

			if functions.isCursorOnElement(886, 600, 163, 49) then 
				if select_key then 
					triggerServerEvent("squady.deleteKeys", localPlayer, localPlayer, key_remove.key)
				end
			end

			if modalkey then 
				if functions.isCursorOnElement(390, 401, 391, 70) then 
					if (guiEditSetCaretIndex(client.edits["QUANTIDADE"][2], (string.len(guiGetText(client.edits["QUANTIDADE"][2]))))) then 
						guiEditSetMaxLength(client.edits["QUANTIDADE"][2], 16)
						guiSetProperty(client.edits["QUANTIDADE"][2], "ValidationString", "^[0-9]*")
						guiBringToFront(client.edits["QUANTIDADE"][2])
						guiSetInputMode("no_binds_when_editing")
						client.edits["QUANTIDADE"][1] = true
					end

				elseif functions.isCursorOnElement(439, 496, 116, 20) then

					if vip_select == "Pontos" then 
						if guiGetText(client.edits["QUANTIDADE"][2]) ~= "" then 

							local key = getPlayerSerial(localPlayer)    
							local hashtoKey = toJSON({key = "vPoints", type = "vPoints", amount = guiGetText(client.edits["QUANTIDADE"][2])})
							
							encodeString('aes128', hashtoKey, {key = key:sub(17)}, function(enc, iv)
								triggerServerEvent('squady.createKeys', resourceRoot, enc, iv)
							end)


						else
							sendMessage("client", localPlayer, "Preencha a quantidade de pontos.", "error")	
						end
					else
						if vip_select ~= nil and guiGetText(client.edits["QUANTIDADE"][2]) ~= "" then 

							local key = getPlayerSerial(localPlayer)    
							local hashtoKey = toJSON({key = "Vip", type = vip_select, amount = guiGetText(client.edits["QUANTIDADE"][2])})

							encodeString('aes128', hashtoKey, {key = key:sub(17)}, function(enc, iv)
								triggerServerEvent('squady.createKeys', resourceRoot, enc, iv)
							end)
						else
							sendMessage("client", localPlayer, "Preencha a quantidade de dias do vip.", "error")
						end
					end

				elseif functions.isCursorOnElement(630, 496, 116, 20) then 
					if not select_product then
						modalkey = false
					end

				elseif functions.isCursorOnElement(735, 385-30, 24, 24) then 
					if not select_product then 
						select_product = true
					else
						select_product = false
					end
				end

				if select_product then 
					line = 0
					for i, v in ipairs(config.productsKey) do 
						if (i > client.pag_vips and line < 6) then 
							line = line + 1
							
							local count = (472 + (497 - 472) * line - (497 - 472))

							if functions.isCursorOnElement(406, count-30, 51, 15) then 
								vip_select = v[1]
								select_product = false
							end
						end
					end
				end
			end
		end
	end
end)

registerEvent("squady.insertVipTable", root, function(data)
	if data then 
		vips_active = {}

		for i, v in ipairs(data) do 
			table.insert(vips_active, {player = v.account, id_player = v.id_account, product = v.vip, date = v.date, price = v.value})
		end
	end
end)

registerEvent("squady.insertLastTable", root, function(data)
	if data then 
		last_transactions = {}
		for i, v in ipairs(data) do 
			table.insert(last_transactions, {activator = v.activator, id_activator = v.id_activator,  player = v.proprietary, id_player = v.id_proprietary, product = v.type, days = v.quantity, data = v.date, state = v.timestamp, price = v.value})
		end
	end
end)

registerEvent("squady.insertKeysTable", root, function(data)
	if data then 
		keys_active = {}

		for i, v in ipairs(data) do 
			table.insert(keys_active, {activator = v.target, key = v.key, type = v.type, vip = v.vip, quantity = v.quantity, date = v.timestamp})
		end
	end
end)

registerEvent("squady.pasteKey", root, function(key)
	if key then 
		setClipboard("usarkey "..key.."")
	end
end)

function sumAllValues()
	local totale = 0

	for i, v in ipairs(last_transactions) do 
		if type(v.price) == 'number' then 
			totale = totale + v.price
		end
	end

	return totale
end

function allPoints()
	local totale = 0

	for i, v in ipairs(last_transactions) do 
		if v.product == "vPoints" then 
			totale = totale + v.price
		end
	end

	return totale
end

function scrollBar(button)
    if client.visible then
		if window == "index" then 
			if functions.isCursorOnElement(338, 271, 640, 350) then 
				if button == "mouse_wheel_up" and client.pag_index > 0 then
					client.pag_index = client.pag_index - 1
				elseif button == "mouse_wheel_down" and (#last_transactions - 4 > 0) then
					client.pag_index = client.pag_index + 1
					if client.pag_index > #last_transactions - 4 then
						client.pag_index = #last_transactions - 4
					end
				end
			end

		elseif window == "vip" then 
			if button == "mouse_wheel_up" and client.pag_actives > 0 then
				client.pag_actives = client.pag_actives - 1
			elseif button == "mouse_wheel_down" and (#vips_active - 7 > 0) then
				client.pag_actives = client.pag_actives + 1
				if client.pag_actives > #vips_active - 7 then
					client.pag_actives = #vips_active - 7
				end
			end

		elseif window == "keys" then
			if button == "mouse_wheel_up" and client.pag_keysactive > 0 then
				client.pag_keysactive = client.pag_keysactive - 1
			elseif button == "mouse_wheel_down" and (#keys_active - 7 > 0) then
				client.pag_keysactive = client.pag_keysactive + 1
				if client.pag_keysactive > #keys_active - 7 then
					client.pag_keysactive = #keys_active - 7
				end
			end

		elseif window == "pontos" then 
			if button == "mouse_wheel_up" and client.pag_coins > 0 then
				client.pag_coins = client.pag_coins - 1
			elseif button == "mouse_wheel_down" and (#last_transactions - 7 > 0) then
				client.pag_coins = client.pag_coins + 1
				if client.pag_coins > #last_transactions - 7 then
					client.pag_coins = #last_transactions - 7
				end
			end

		elseif window == "logs" then 
			if button == "mouse_wheel_up" and client.pag_logs > 0 then
				client.pag_logs = client.pag_logs - 1
			elseif button == "mouse_wheel_down" and (#last_transactions - 7 > 0) then
				client.pag_logs = client.pag_logs + 1
				if client.pag_logs > #last_transactions - 7 then
					client.pag_logs = #last_transactions - 7
				end
			end

		end
    end
end

bindKey("mouse_wheel_up", "down", scrollBar)
bindKey("mouse_wheel_down", "down", scrollBar)