local resource = {radius = {255, 0, 0}, state = false, moveY = {0, 0, 0}}
local scroll, maxScroll, isDragging, dragOffset = 0, 0, false, 0
local assets = exports['guetto_assets'];

local categorys = {
	{99, 246, 180, 26, "index", "assets/images/list.png", 99, 246, 26, 26, "Jogadores onlines"};
	{99, 299, 137, 26, "person", "assets/images/user.png", 99, 299, 26, 26, "Personagem"};
	{99, 352, 145, 23, "ranking", "assets/images/ranking.png", 99, 353, 26, 21, "Ranking geral"};
	{99, 402, 101, 23, "missions", "assets/images/icon-missions.png", 99, 399, 26, 26, "Missões"};
}

local function onDraw ()

	local alpha = interpolateBetween (resource.radius[1], 0, 0, resource.radius[2], 0, 0, (getTickCount ( ) - resource.radius[3])/400, "Linear")
	moveY = interpolateBetween (resource.moveY[1], 0, 0, resource.moveY[2], 0, 0, (getTickCount ( ) - resource.moveY[3])/350, "Linear")

	dxDrawImageSpacing(68, moveY, 1072, 702, 5, "assets/images/background.png", 0, 0, 0, tocolor(255, 255, 255, alpha))

	for i, v in ipairs(categorys) do
		if functions.isCursorOnElement(v[1], moveY + v[2] - 49, v[3], v[4]) or resource.window == v[5] then 
			dxDrawImageSpacing(v[7], moveY + v[8] - 49, v[9], v[10], 3, v[6], 0, 0, 0, tocolor(193, 159, 114, alpha))
			dxDrawText(v[11], v[7] + 40, moveY + v[8] - 49, v[9], v[10], tocolor(193, 159, 114, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 13))
		else
			dxDrawImageSpacing(v[7], moveY + v[8] - 49, v[9], v[10], 3, v[6], 0, 0, 0, tocolor(153, 153, 153, alpha))
			dxDrawText(v[11], v[7] + 40, moveY + v[8] - 49, v[9], v[10], tocolor(153, 153, 153, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 13))
		end
	end

	dxDrawText("Guetto group", 68, moveY + 687 - 49, 330, 23, tocolor(193, 159, 114, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 13), "center", "center")

	if resource.window == "index" then 

		dxDrawText("Jogadores online", 409, moveY + 93 - 49, 140, 23, tocolor(255, 255, 255, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 13))
		dxDrawText("Todos que estão jogando no momento", 409, moveY + 116 - 49, 140, 23, tocolor(160, 160, 160, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 13))

		dxDrawRoundedRectangle(763, moveY + 87 - 49, 336, 66, 4, tocolor(217, 217, 217, alpha/42.75))

		dxDrawImageSpacing(790, moveY + 108 - 49, 23, 23, 3, "assets/images/users.png", 0, 0, 0, (resource.select == "staff" and tocolor(193, 159, 114, alpha) or tocolor(174, 174, 174, alpha)))
		dxDrawImageSpacing(865, moveY + 108 - 49, 23, 23, 3, "assets/images/mechanic.png", 0, 0, 0, (resource.select == "mechanic" and tocolor(193, 159, 114, alpha) or tocolor(174, 174, 174, alpha)))
		dxDrawImageSpacing(940, moveY + 108 - 49, 23, 23, 3, "assets/images/police.png", 0, 0, 0, (resource.select == "police" and tocolor(193, 159, 114, alpha) or tocolor(174, 174, 174, alpha)))
		dxDrawImageSpacing(1015, moveY + 108 - 49, 23, 23, 3, "assets/images/medic.png", 0, 0, 0, (resource.select == "medic" and tocolor(193, 159, 114, alpha) or tocolor(174, 174, 174, alpha)))

		dxDrawText(resource.staff, 821, moveY + 108 - 49, 25, 23, (resource.select == "staff" and tocolor(193, 159, 114, alpha) or tocolor(174, 174, 174, alpha)), 1.0, exports['guetto_assets']:dxCreateFont("medium", 13))
		dxDrawText(resource.mechanic, 896, moveY + 108 - 49, 25, 23, (resource.select == "mechanic" and tocolor(193, 159, 114, alpha) or tocolor(174, 174, 174, alpha)), 1.0, exports['guetto_assets']:dxCreateFont("medium", 13))
		dxDrawText(resource.police, 971, moveY + 108 - 49, 25, 23, (resource.select == "police" and tocolor(193, 159, 114, alpha) or tocolor(174, 174, 174, alpha)), 1.0, exports['guetto_assets']:dxCreateFont("medium", 13))
		dxDrawText(resource.medic, 1046, moveY + 108 - 49, 25, 23, (resource.select == "medic" and tocolor(193, 159, 114, alpha) or tocolor(174, 174, 174, alpha)), 1.0, exports['guetto_assets']:dxCreateFont("medium", 13))

		dxDrawRoundedRectangle(409, moveY + 670 - 49, 320, 53, 6, tocolor(217, 217, 217, alpha / 32.75))
		dxDrawImageSpacing(426, moveY + 683 - 49, 28, 28, 3, "assets/images/search.png", 0, 0, 0, tocolor(255, 255, 255, alpha))

		dxDrawEditbox("editbox:search", "Pesquisar", 409, moveY + 672 - 49, 320, 53, {focus = tocolor(255, 255, 255, alpha), normal = tocolor(86, 86, 86, alpha), background = tocolor(0, 0, 0, 0)}, {"center", "center"}, exports['guetto_assets']:dxCreateFont("medium", 13), {block = false, number = false, max_characters = 16, password = false})

		maxScroll = math.max(0, #resource.players - 6)
		animatedScroll = lerp(animatedScroll or 0, scroll, 0.05)

		local scrollBar = animatedScroll / maxScroll 

		dxDrawRectangle(1110, moveY + 169 - 49, 5, 487, tocolor(28, 28, 28, alpha))

		if maxScroll > 0 then 
			dxDrawRectangle(1110, moveY + ((169) + (scrollBar * 340)) - 49, 5, 149, tocolor(193, 159, 114, alpha))
		else
			dxDrawRectangle(1110, moveY + 169 - 49, 5, 149, tocolor(193, 159, 114, alpha))
		end

		local content = dxEditboxGetText("editbox:search")
		local line = 0

		for index = scroll + 1, #resource.players do 
			if line >= 6 then 
				break
			end
			local v = resource.players[index]

			if content == "" or content == "Pesquisar" or string.find(string.lower(v.name), string.lower(content)) or string.find(string.lower(v.id), string.lower(content)) then

				local count = (251 + (333 - 251) * line - (333 - 251))
				--local count = (169 + (251 - 169) * line - (251 - 169))

				local job = getElementData(v.element, config.datas.elements.job) or "Desempregado"
				local level = getElementData(v.element, config.datas.elements.level) or 1

				dxDrawImage(409, moveY + count - 49, 690, 78, v.banner.card.image, 0, 0, 0, tocolor(255, 255, 255, alpha))
				dxDrawText(v.name.. "#"..v.id, 438, moveY + count + 16 - 49, 102, 23, tocolor(255, 255, 255, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 13))
				dxDrawText(job, 438, moveY + count + 35 - 49, 102, 23, tocolor(255, 255, 255, alpha), 1.0, exports['guetto_assets']:dxCreateFont("light", 13))

				dxDrawImageSpacing(790 + 40, moveY + count + 20 - 49, 36, 36, 3, "assets/images/nivel.png", 0, 0, 0, tocolor(255, 255, 255, alpha))

				dxDrawImageSpacing(1004, moveY + count + 23 - 49, 30, 30, 3, "assets/images/ping.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
				if v.element then 
					dxDrawText(level, 836 + 40, moveY + count + 27 - 49, 25, 23, tocolor(255, 255, 255, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 13))
					dxDrawText(getPlayerPing(v.element), 1043, moveY + count + 27 - 49, 25, 23, tocolor(255, 255, 255, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 13))
				end

				line = line + 1
			end
		end

		--for i, v in ipairs(resource.players) do 
		--	if (i > resource.actualPage and line < 6) then 
		--		if (content == "" or content == "Pesquisar" or string.find(string.lower(v.name), string.lower(content)) or string.find(string.lower(v.id), string.lower(content))) then
		--			line = line + 1
--
		--			local count = (169 + (251 - 169) * line - (251 - 169))
		--			local job = getElementData(v.element, config.datas.elements.job) or "Desempregado"
		--			local level = getElementData(v.element, config.datas.elements.level) or 1
--
		--			dxDrawImage(409, moveY + count - 49, 690, 78, v.banner.card.image, 0, 0, 0, tocolor(255, 255, 255, alpha))
		--			dxDrawText(v.name.. "#"..v.id, 438, moveY + count + 16 - 49, 102, 23, tocolor(255, 255, 255, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 13))
		--			dxDrawText(job, 438, moveY + count + 35 - 49, 102, 23, tocolor(255, 255, 255, alpha), 1.0, exports['guetto_assets']:dxCreateFont("light", 13))
--
		--			dxDrawImageSpacing(790 + 40, moveY + count + 20 - 49, 36, 36, 3, "assets/images/nivel.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
		--			dxDrawText(level, 836 + 40, moveY + count + 27 - 49, 25, 23, tocolor(255, 255, 255, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 13))
--
		--			dxDrawImageSpacing(1004, moveY + count + 23 - 49, 30, 30, 3, "assets/images/ping.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
		--			dxDrawText(getPlayerPing(v.element), 1043, moveY + count + 27 - 49, 25, 23, tocolor(255, 255, 255, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 13))
		--		end
		--	end
		--end

		dxDrawRoundedRectangle(740, moveY + 670 - 49, 359, 53, 6, tocolor(217, 217, 217, alpha / 32.75))
		dxDrawRoundedRectangle(740, moveY + 670 - 49, 359 * ((#getElementsByType("player") / config.settings.players)), 53, 6, tocolor(193, 159, 114, alpha / 2))

		dxDrawImageSpacing(762, moveY + 685 - 49, 24, 24, 3, "assets/images/game.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
		dxDrawText("Onlines:", 803, moveY + 683 - 49, 61, 23, tocolor(236, 236, 236, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 13))
		dxDrawText((#getElementsByType("player")).."/"..config.settings.players.."", 1012, moveY + 683 - 49, 56, 23, tocolor(236, 236, 236, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 13), "right", "top")
	
	elseif resource.window == "person" then 
		dxDrawImage(417, moveY + 71 - 49, 717, 639, "assets/images/bg_person.png", 0, 0, 0, tocolor(255, 255, 255, alpha))

		dxDrawText("Personagem", 457, moveY + 99 - 49, 97, 23, tocolor(255, 255, 255, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 13))
		dxDrawText("Todas as suas informações", 457, moveY + 122 - 49, 208, 23, tocolor(160, 160, 160, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 13))

		local level = getElementData(localPlayer, config.datas.elements.level) or 1
		local exp, level = getElementData(localPlayer, config.datas.elements.exp) or 1, getElementData(localPlayer, config.datas.elements.level) or 1
		local max = level * 800
		local job = getElementData(localPlayer, config.datas.elements.job) or "Desempregado"
		local moneybank = getElementData(localPlayer, config.datas.elements.bank) or 0
		local money = getPlayerMoney(localPlayer)

		local width = 477 * (exp / max) or 1;
		dxDrawText("Experiência", 457, moveY + 164 - 49, 97, 23, tocolor(255, 255, 255, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 13))
		dxDrawText(""..exp.."#404040/"..max.."", 837, moveY + 164 - 49, 97, 23, tocolor(255, 255, 255, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 13), "right", "top", false, false, false, true, false)

		--dxDrawRoundedRectangle(457, moveY + 198 - 49, 477, 5, 2, tocolor(217, 217, 217, alpha / 20))
		--dxDrawRoundedRectangle(457, moveY + 198 - 49, width, 5, 2, tocolor(193, 159, 114, alpha))

		dxDrawRectangle(457, moveY + 198 - 49, 477, 5, tocolor(217, 217, 217, alpha / 20))
		dxDrawRectangle(457, moveY + 198 - 49, width, 5, tocolor(193, 159, 114, alpha))

		dxDrawText("Nível", 1015, moveY + 83 - 49, 49, 30, tocolor(193, 159, 114, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 14))
		dxDrawText(level, 990, moveY + 120 - 49, 100, 37, tocolor(193, 159, 114, alpha), 1.0, exports['guetto_assets']:dxCreateFont("regular", 20), "center", "top")

		dxDrawText("Nome", 498, moveY + 282 - 49, 46, 23, tocolor(255, 255, 255, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 13))
		dxDrawText(""..getPlayerName(localPlayer).." #"..(getElementData(localPlayer, "ID") or "N/A").."", 498, moveY + 305 - 49, 46, 23, tocolor(163, 163, 163, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 13))

		dxDrawText("Emprego", 498, moveY + 355 - 49, 46, 23, tocolor(255, 255, 255, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 13))
		dxDrawText(job, 498, moveY + 378 - 49, 46, 23, tocolor(163, 163, 163, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 13))

		dxDrawText("Banco", 835, moveY + 282 - 49, 46, 23, tocolor(255, 255, 255, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 13))
		dxDrawText("$ "..convertNumber(moneybank), 835, moveY + 305 - 49, 46, 23, tocolor(163, 163, 163, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 13))

		dxDrawText("Dinheiro", 835, moveY + 355 - 49, 46, 23, tocolor(255, 255, 255, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 13))
		dxDrawText("$ "..convertNumber(money), 835, moveY + 378 - 49, 46, 23, tocolor(163, 163, 163, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 13))

		dxDrawText("Finalizações", 502, moveY + 481 - 49, 86, 23, tocolor(255, 255, 255, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 13))

		if resource.stats then 
			dxDrawText(resource.stats.kills, 502, moveY + 501 - 49, 86, 23, tocolor(163, 163, 163, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 13))
		else
			dxDrawText("0", 502, moveY + 501 - 49, 86, 23, tocolor(163, 163, 163, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 13))
		end

		dxDrawText("Mortes", 725, moveY + 481 - 49, 86, 23, tocolor(255, 255, 255, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 13))

		if resource.stats then 
			dxDrawText(resource.stats.deaths, 725, moveY + 501 - 49, 86, 23, tocolor(163, 163, 163, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 13))
		else
			dxDrawText("0", 725, moveY + 501 - 49, 86, 23, tocolor(163, 163, 163, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 13))
		end

		dxDrawText("Rank", 972, moveY + 481 - 49, 86, 23, tocolor(255, 255, 255, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 13))
		dxDrawText("Em breve", 972, moveY + 501 - 49, 86, 23, tocolor(163, 163, 163, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 13))

		dxDrawText("Organização", 502, moveY + 615 - 49, 98, 23, tocolor(255, 255, 255, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 13))

		if resource.group then 
			dxDrawText(resource.group, 502, moveY + 641 - 49, 86, 23, tocolor(163, 163, 163, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 13))
		else
			dxDrawText("População", 502, moveY + 641 - 49, 86, 23, tocolor(163, 163, 163, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 13))
		end
		
		dxDrawText("Cargo", 722, moveY + 615 - 49, 98, 23, tocolor(255, 255, 255, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 13))
		if resource.role then
			dxDrawText(resource.role, 722, moveY + 641 - 49, 86, 23, tocolor(163, 163, 163, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 13))
		else
			dxDrawText("Civil", 722, moveY + 641 - 49, 86, 23, tocolor(163, 163, 163, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 13))
		end
		
		dxDrawText("Rank org.", 972, moveY + 615 - 49, 98, 23, tocolor(255, 255, 255, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 13))
		dxDrawText("Em breve", 972, moveY + 641 - 49, 86, 23, tocolor(163, 163, 163, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 13))

	elseif resource.window == "ranking" then 
		dxDrawImage(600, moveY + 177 - 49, 338, 104, "assets/images/rank.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
		dxDrawText("Ranking geral", 440 - 37, moveY + 350 - 49, 740, 23, tocolor(255, 255, 255, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 13), "center", "top")
		dxDrawText("Olá, jogadores! Em breve, ativaremos nosso sistema de ranking, que incluirá\ncategorias de dinheiro, armas e KD. Aguardem!", 440 - 37, moveY + 384 - 49, 740, 23, tocolor(160, 160, 160, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 13), "center", "top")
		dxDrawText("EM BREVE", 440 - 37, moveY + 491 - 49, 740, 23, tocolor(193, 159, 114, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 18), "center", "top")

	elseif resource.window == "missions" then
		dxDrawImageSpacing(724, moveY + 177 - 49, 80, 80, 3, "assets/images/missions.png", 0, 0, 0, tocolor(255, 255, 255, alpha))

		dxDrawText("Missões", 398, moveY + 313 - 49, 742, 23, tocolor(255, 255, 255, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 13), "center", "top")
		dxDrawText("Futuramente, vocês poderão utilizar este canal para visualizar\nmissões diárias e metas para evoluir seus personagens e subir no ranking global.", 398, moveY + 362 - 49, 742, 23, tocolor(160, 160, 160, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 13), "center", "top")
		dxDrawText("EM BREVE", 398, moveY + 464 - 49, 742, 23, tocolor(193, 159, 114, alpha), 1.0, exports['guetto_assets']:dxCreateFont("medium", 18), "center", "top")
	end
end

local function scoreboardClose ()
	if (resource.state) then 

		resource.radius[1] = 255
		resource.radius[2] = 0
		resource.radius[3] = getTickCount ( )

		resource.moveY[1] = 49
		resource.moveY[2] = 100
		resource.moveY[3] = getTickCount ( )

		setTimer(function()
			
			showCursor(false)
			showChat(true)
			removeEventHandler("onClientRender", root, onDraw)
			dxEditboxDestroy ("editbox:search")

			resource.state = nil 

			resource.radius[1] = nil 
			resource.radius[2] = nil
			resource.radius[3] = nil

			resource.moveY[1] = nil
			resource.moveY[2] = nil
			resource.moveY[3] = nil

			resource.window = nil 

			resource.maxVisible = nil 
			resource.actualPage = nil

			resource.police = nil
			resource.medic = nil 
			resource.mechanic = nil

			resource.players = nil
			destroyElements()
		end, 250, 1)

	end
end

local function scoreboardOpen ()
	if not (resource.state) then 

		resource.players = {}
		resource.inserteds = {}

		triggerServerEvent("guetto.requestInfos", resourceRoot, false)

		resource.police = getCountServices("police")
		resource.medic = getCountServices("medic")
		resource.mechanic = getCountServices("mechanic")
		resource.staff = getCountServices("staff")

		resource.state = true 
		resource.window = "index"

		resource.maxVisible = 6 
		resource.actualPage = 0

		resource.radius[1] = 0
		resource.radius[2] = 255
		resource.radius[3] = getTickCount ( )

		resource.moveY[1] = 100
		resource.moveY[2] = 49
		resource.moveY[3] = getTickCount ( )

		resource.select = ""

		showCursor(true)
		showChat(false)
		addEventHandler("onClientRender", root, onDraw)
	else 
		scoreboardClose()
	end
end

local function sendInfoClient (tbl)
	resource.players = tbl.cache
	resource.group = tbl.group 
	resource.role = tbl.role
	resource.stats = tbl.stats

	table.sort(resource.players, function (a, b)
		return a.banner.card.priority < b.banner.card.priority
	end)
end

function getPlayerStats(playerID)
    local playerKills = resource.kills[tostring(playerID)] or 0
    local playerDeaths = resource.deaths[tostring(playerID)] or 0
    return playerKills, playerDeaths
end

local function onClientClick (button, state)
	if (resource.state and button == "left" and state == "down") then

		if moving then 
			moving = false
		end

		for i, v in ipairs(categorys) do
			if functions.isCursorOnElement(v[1], moveY + v[2] - 49, v[3], v[4]) then 
				resource.window = v[5]
			end
		end

		if resource.window == "index" then 
			if functions.isCursorOnElement(790, moveY + 108 - 49, 23, 23) then 
				if not resource.select then 
					triggerServerEvent("guetto.requestInfos", resourceRoot, config.datas.services.staff)
					resource.select = "staff"
				else
					triggerServerEvent("guetto.requestInfos", resourceRoot, false)
					resource.select = false
				end

			elseif functions.isCursorOnElement(865, moveY + 108 - 49, 23, 23) then
				if not resource.select then 
					triggerServerEvent("guetto.requestInfos", resourceRoot, config.datas.services.mechanic)
					resource.select = "mechanic"
				else
					triggerServerEvent("guetto.requestInfos", resourceRoot, false)
					resource.select = false
				end

			elseif functions.isCursorOnElement(940, moveY + 108 - 49, 23, 23) then
				if not resource.select then 
					triggerServerEvent("guetto.requestInfos", resourceRoot, config.datas.services.police)
					resource.select = "police"
				else
					triggerServerEvent("guetto.requestInfos", resourceRoot, false)
					resource.select = false
				end

			elseif functions.isCursorOnElement(1015, moveY + 108 - 49, 23, 23) then
				if not resource.select then 
					triggerServerEvent("guetto.requestInfos", resourceRoot, config.datas.services.medic)
					resource.select = "medic"
				else
					triggerServerEvent("guetto.requestInfos", resourceRoot, false)
					resource.select = false
				end

			end
		end
	end	
end

function onClientMouseMove(_, _, cursorX, cursorY)
    if isDragging then
        local mouseY = cursorY - 169
        scroll = math.max(0, math.min(maxScroll, math.floor(maxScroll * mouseY / (340))))
    end
end


function onClientMouseClick(button, state, _, cursorX, cursorY)
    if button == 'left' and state == 'down' and functions.isCursorOnElement(1110, 169, 5, 487) then
        if #resource.players > 6 then
            isDragging = true
            dragOffsetY = cursorY - (169 + scroll / maxScroll * (149))
        end
	elseif button == 'left' and state == 'up' then 
		isDragging = false
    end
end

addEventHandler('onClientCursorMove', root, onClientMouseMove)
addEventHandler('onClientClick', root, onClientMouseClick)

local function scrollBar (button)
	if (resource.state) then 
		if (resource.window == "index") then 

			if #resource.players > 6 then
				if button == 'mouse_wheel_up' then
					scroll = math.max(0, scroll - 1)
				elseif button == 'mouse_wheel_down' then
					scroll = math.min(#resource.players - 6, scroll + 1)
				end
			end

				--if (button == "mouse_wheel_up" and resource.actualPage > 0) then 
				--	resource.actualPage = resource.actualPage - 1
				--	cursorY = scrollBarMove(#resource.players, 6, 169, 507, "y", resource.actualPage)
--
				--elseif (button == "mouse_wheel_down" and (#resource.players - 6 > 0)) then 
				--	resource.actualPage = resource.actualPage + 1
				--	cursorY = scrollBarMove(#resource.players, 6, 169, 507, "y", resource.actualPage)
--
				--	if resource.actualPage > #resource.players - 6 then 
				--		resource.actualPage = #resource.players - 6
				--	end
				--end
		end
	end
end

registerEvent("guetto.sendInfoClient", resourceRoot, sendInfoClient)

addEventHandler("onClientClick", root, onClientClick)

bindKey("mouse_wheel_up", "down", scrollBar)
bindKey("mouse_wheel_down", "down", scrollBar)
bindKey(config.settings.bind, "down", scoreboardOpen)

function lerp(a, b, t)
    return math.max(a + (b - a) * t, 0)
end