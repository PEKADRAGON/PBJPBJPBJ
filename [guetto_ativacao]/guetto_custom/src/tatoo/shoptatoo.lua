addEvent("Conner.abrirTatuagens", true)
addEventHandler("Conner.abrirTatuagens", root, function()
	if not isEventHandlerAdded("onClientRender", root, dxPainelTatuagem) then 
		exports["RBR_Carregar"]:showLoading("Carregando tatuagens", 2000)
		setElementData(localPlayer,"togHUD",false);
		local x,y,z = getElementPosition(localPlayer)
		setElementData(localPlayer, "characterQuit", {x,y,z,0,0})
		showChat(false)
		setElementFrozen(localPlayer, true)

		local temp = createCustomPed(unpack(lojas["Tatuagem"]["spawn"].posped))
		setElementDimension(temp, getElementData( player, "acc >> id")+5)
		setElementInterior(temp, lojas["Tatuagem"]["spawn"].interior)
		setElementRotation(temp, 0, 0, lojas["Tatuagem"]["spawn"].rot)

		toggleAllControls(false)
		setTimer(function()
			local genero = (getElementData(localPlayer, "characterGenre"))
			local tatoo = getElementData(localPlayer, "jogador:Tatoo")

			idRosto = tatoo[genero]["rosto"]

			idPeito = tatoo[genero]["peito"]
			
			idBraco = tatoo[genero]["bracos"]

			idEstomago = tatoo[genero]["estomago"] 
			
			idCostas = tatoo[genero]["costas"]
			
			idPanturrilha = tatoo[genero]["panturrilha"]

			qntRosto = 0
			qntPeito = 0
			qntEstomago = 0
			qntBracos = 0
			qntPanturrilha = 0

			valorRosto = 0
			valorPeito = 0
			valorEstomago = 0
			valorBracos = 0
			valorPanturrilha = 0

			for i,_ in pairs(tabelaRoupas["1"]["tatoorosto"]) do
				if i ~= 0 then
					qntRosto = qntRosto + 1
				end
			end
			
			for i,_ in pairs(tabelaRoupas["1"]["tatoopeito"]) do
				if i ~= 0 then
					qntPeito = qntPeito + 1
				end
			end
				iprint(qntPeito)
			for i,_ in pairs(tabelaRoupas["1"]["tatoobracos"]) do
				if i ~= 0 then
					qntBracos = qntBracos + 1
				end
			end

			for i,_ in pairs(tabelaRoupas["1"]["tatoopanturrilha"]) do
				if i ~= 0 then
					qntPanturrilha = qntPanturrilha + 1
				end
			end
			
			for i,_ in pairs(tabelaRoupas["1"]["tatooestomago"]) do
				if i ~= 0 then
					qntEstomago = qntEstomago + 1
				end
			end
			
			addEventHandler("onClientRender", root, dxPainelTatuagem)
			showCursor(true)
		end, lojas["Tatuagem"]["tempoabrir"],1)
	end
end)

function fecharTatuagem()
		if isEventHandlerAdded("onClientRender", root, dxPainelTatuagem) then 
			exports["RBR_Carregar"]:showLoading("Carregando cidade", 2000)

			removeEventHandler("onClientRender", root, dxPainelTatuagem)

			triggerServerEvent("Conner.sairTatuagem", localPlayer, localPlayer)

			setTimer(function()
				removeEventHandler("onClientRender", root, dxPainelTatuagem)
				setElementData(localPlayer,"togHUD",true);
				setElementFrozen(localPlayer, false)
				toggleAllControls(true)
				showChat(true)
				showCursor(false)
				setCameraTarget(localPlayer)
				setElementData(localPlayer, "characterQuit", false)
			end,lojas["Tatuagem"]["tempoabrir"],1)
		end
end

function pagarTatuagem(valor)
	local genero = (getElementData(localPlayer,"characterGenre"))
	if getElementData(localPlayer, "char >> money") < valor then   
		exports.RBR_notificacao:create("Você não tem dinheiro suficiente.", "error")
		return
	else

		triggerServerEvent("Conner.pagarTatuagem", localPlayer, localPlayer, (idPanturrilha), "panturrilha")
		triggerServerEvent("Conner.pagarTatuagem", localPlayer, localPlayer, (idPeito), "peito")
		triggerServerEvent("Conner.pagarTatuagem", localPlayer, localPlayer, (idRosto), "rosto")
		triggerServerEvent("Conner.pagarTatuagem", localPlayer, localPlayer, (idBraco), "bracos")
		
		exports.RBR_notificacao:create("Você pagou R$ "..valor, "success")
		setElementData(localPlayer, "char >> money", getElementData(localPlayer, "char >> money") - valor)
		
		triggerServerEvent("personagem.salvar", localPlayer, localPlayer)
		fecharTatuagem()
	end
end


local dxPainelTatuagem = function()
	if not getElementData(localPlayer,"network") then return end
	local genero = (getElementData(localPlayer,"characterGenre"))
	local corDaPele = (getElementData(localPlayer,"characterSkinColor"))
	--Fundo DX
	dxDrawRectangle(20/zoom, 180/zoom, 400/zoom, 440/zoom, tocolor(18, 18, 18, 255))
	dxDrawRectangle(20/zoom, 230/zoom, 400/zoom, 2/zoom, tocolor(121, 130, 184, 255))--Barrinha de cima

	dxDrawText("Tatuagens",50/zoom, 1/zoom, 400/zoom, 410/zoom,tocolor(255,255,255,255),1/zoom ,regular, "center", "center", false)

	dxDrawText(tabelaRoupas[genero]["tatoorosto"][(idRosto)][1],50/zoom, 140/zoom, 400/zoom, 410/zoom,tocolor(255,255,255,255),1/zoom ,assets.fonts.small, "center", "center", false)
	
	dxDrawText(tabelaRoupas[genero]["tatoopeito"][(idPeito)][1],50/zoom, 240/zoom, 400/zoom, 410/zoom,tocolor(255,255,255,255),1/zoom ,assets.fonts.small, "center", "center", false)

	dxDrawText(tabelaRoupas[genero]["tatoobracos"][(idBraco)][1],50/zoom, 340/zoom, 400/zoom, 410/zoom,tocolor(255,255,255,255),1/zoom ,assets.fonts.small, "center", "center", false)

	dxDrawText(tabelaRoupas[genero]["tatooestomago"][(idEstomago)][1],50/zoom, 440/zoom, 400/zoom, 410/zoom,tocolor(255,255,255,255),1/zoom ,assets.fonts.small, "center", "center", false)

	dxDrawText(tabelaRoupas[genero]["tatoopanturrilha"][(idPanturrilha)][1],50/zoom, 540/zoom, 400/zoom, 410/zoom,tocolor(255,255,255,255),1/zoom ,assets.fonts.small, "center", "center", false)


	--Sombrancelhas
	if isCursorInPosition(40/zoom, 260/zoom, 30/zoom, 30/zoom) then 
		corBS1 = tocolor(30,30,30,255)
	else
		corBS1 = tocolor(40,40,40,255)
	end
	if isCursorInPosition(370/zoom, 260/zoom, 30/zoom, 30/zoom) then 
		corBS2 = tocolor(30,30,30,255)
	else
		corBS2 = tocolor(40,40,40,255)
	end

	--Cabelo baixo
	if isCursorInPosition(40/zoom, 310/zoom, 30/zoom, 30/zoom) then 
		corBCB1 = tocolor(30,30,30,255)
	else
		corBCB1 = tocolor(40,40,40,255)
	end
	if isCursorInPosition(370/zoom, 310/zoom, 30/zoom, 30/zoom) then 
		corBCB2 = tocolor(30,30,30,255)
	else
		corBCB2 = tocolor(40,40,40,255)
	end

	--Cabelo
	if isCursorInPosition(40/zoom, 360/zoom, 30/zoom, 30/zoom) then 
		corBC1 = tocolor(30,30,30,255)
	else
		corBC1 = tocolor(40,40,40,255)
	end
	if isCursorInPosition(370/zoom, 360/zoom, 30/zoom, 30/zoom) then 
		corBC2 = tocolor(30,30,30,255)
	else
		corBC2 = tocolor(40,40,40,255)
	end

	--Cor cabelo
	if isCursorInPosition(40/zoom, 410/zoom, 30/zoom, 30/zoom) then 
		corCC1 = tocolor(30,30,30,255)
	else
		corCC1 = tocolor(40,40,40,255)
	end
	if isCursorInPosition(370/zoom, 410/zoom, 30/zoom, 30/zoom) then 
		corCC2 = tocolor(30,30,30,255)
	else
		corCC2 = tocolor(40,40,40,255)
	end

	--Barbas / Maquiagens
	if isCursorInPosition(40/zoom, 460/zoom, 30/zoom, 30/zoom) then 
		corBM1 = tocolor(30,30,30,255)
	else
		corBM1 = tocolor(40,40,40,255)
	end
	if isCursorInPosition(370/zoom, 460/zoom, 30/zoom, 30/zoom) then 
		corBM2 = tocolor(30,30,30,255)
	else
		corBM2 = tocolor(40,40,40,255)
	end

	--Comprar
	if isCursorInPosition(40/zoom, 510/zoom, 175/zoom, 40/zoom) then 
		corComprar = tocolor(30,30,30,255)
	else
		corComprar = tocolor(40,40,40,255)
	end

	--Fechar
	if isCursorInPosition(225/zoom, 510/zoom, 175/zoom, 40/zoom) then 
		corFechar = tocolor(30,30,30,255)
	else
		corFechar = tocolor(40,40,40,255)
	end

	--Botão sombrancelha
	dxDrawRectangle(40/zoom, 260/zoom, 30/zoom, 30/zoom, corBS1)
	dxDrawText("<",-290/zoom, 140/zoom, 400/zoom, 410/zoom,tocolor(255,255,255,255),1/zoom ,assets.fonts.small, "center", "center", false)

	dxDrawRectangle(370/zoom, 260/zoom, 30/zoom, 30/zoom, corBS2)
	dxDrawText(">",380/zoom, 140/zoom, 400/zoom, 410/zoom,tocolor(255,255,255,255),1/zoom ,assets.fonts.small, "center", "center", false)
	
	--Botão cabelo baixo
	dxDrawRectangle(40/zoom, 310/zoom, 30/zoom, 30/zoom, corBCB1)
	dxDrawText("<",-290/zoom, 240/zoom, 400/zoom, 410/zoom,tocolor(255,255,255,255),1/zoom ,assets.fonts.small, "center", "center", false)

	dxDrawRectangle(370/zoom, 310/zoom, 30/zoom, 30/zoom, corBCB2)
	dxDrawText(">",380/zoom, 240/zoom, 400/zoom, 410/zoom,tocolor(255,255,255,255),1/zoom ,assets.fonts.small, "center", "center", false)

	--Botão cabelo
	dxDrawRectangle(40/zoom, 360/zoom, 30/zoom, 30/zoom, corBC1)
	dxDrawText("<",-290/zoom, 340/zoom, 400/zoom, 410/zoom,tocolor(255,255,255,255),1/zoom ,assets.fonts.small, "center", "center", false)

	dxDrawRectangle(370/zoom, 360/zoom, 30/zoom, 30/zoom, corBC2)
	dxDrawText(">",380/zoom, 340/zoom, 400/zoom, 410/zoom,tocolor(255,255,255,255),1/zoom ,assets.fonts.small, "center", "center", false)

	--Botão cor cabelo
	dxDrawRectangle(40/zoom, 410/zoom, 30/zoom, 30/zoom, corCC1)
	dxDrawText("<",-290/zoom, 440/zoom, 400/zoom, 410/zoom,tocolor(255,255,255,255),1/zoom ,assets.fonts.small, "center", "center", false)

	dxDrawRectangle(370/zoom, 410/zoom, 30/zoom, 30/zoom, corCC2)
	dxDrawText(">",380/zoom, 440/zoom, 400/zoom, 410/zoom,tocolor(255,255,255,255),1/zoom ,assets.fonts.small, "center", "center", false)

	--Botão barbas/maquiagens
	dxDrawRectangle(40/zoom, 460/zoom, 30/zoom, 30/zoom, corBM1)
	dxDrawText("<",-290/zoom, 540/zoom, 400/zoom, 410/zoom,tocolor(255,255,255,255),1/zoom ,assets.fonts.small, "center", "center", false)

	dxDrawRectangle(370/zoom, 460/zoom, 30/zoom, 30/zoom, corBM2)
	dxDrawText(">",380/zoom, 540/zoom, 400/zoom, 410/zoom,tocolor(255,255,255,255),1/zoom ,assets.fonts.small, "center", "center", false)

	--Comprar e fechar
	dxDrawRectangle(40/zoom, 510/zoom, 175/zoom, 40/zoom, corComprar)
	dxDrawText("Comprar",-140/zoom, 650/zoom, 400/zoom, 410/zoom,tocolor(255,255,255,255),1/zoom ,assets.fonts.small, "center", "center", false)

	dxDrawRectangle(225/zoom, 510/zoom, 175/zoom, 40/zoom, corFechar)
	dxDrawText("Fechar",220/zoom, 650/zoom, 400/zoom, 410/zoom,tocolor(255,255,255,255),1/zoom ,assets.fonts.small, "center", "center", false)

	dxDrawText("Valor total R$ "..valorRosto+valorPeito+valorBracos+valorPanturrilha,50/zoom, 750/zoom, 400/zoom, 410/zoom,tocolor(255,255,255,255),1/zoom ,assets.fonts.small, "center", "center", false)
end

addEventHandler("onClientKey",root,function(button,press)
	if isEventHandlerAdded("onClientRender", root, dxPainelTatuagem) then 
	if not getElementData(localPlayer,"network") then return end
		--Rotacionar
			if (button == "arrow_l" and press) then
				triggerServerEvent("Conner.rotacionar",localPlayer,localPlayer,0)
			elseif (button == "arrow_r" and press) then
				triggerServerEvent("Conner.rotacionar",localPlayer,localPlayer,1)
			end
	end
end)

addEventHandler("onClientClick",root,function(button,state)
	if isEventHandlerAdded("onClientRender", root, dxPainelTatuagem) then 
	if not getElementData(localPlayer,"network") then return end
		if button == "left" and state == "down" and guiTick+500 < getTickCount() then 
			local datatatoo = getElementData(localPlayer, "jogador:Tatoo")
			local genero = (getElementData(localPlayer,"characterGenre"))
			if isCursorInPosition(40/zoom, 510/zoom, 175/zoom, 40/zoom) then--Comprar		
				pagarTatuagem(valorRosto+valorPeito+valorBracos+valorPanturrilha)
				guiTick = getTickCount();
			elseif isCursorInPosition(225/zoom, 510/zoom, 175/zoom, 40/zoom) then--Fechar
				fecharTatuagem()
				guiTick = getTickCount();

			elseif isCursorInPosition(370/zoom, 260/zoom, 30/zoom, 30/zoom) then--Próximo
				setCameraMatrix(unpack(lojas["Tatuagem"]["cameras"]["rosto"]))
				idRosto = idRosto+1
				if idRosto > qntRosto then
					idRosto = 1
				end
				local idRostoData = datatatoo[genero]["rosto"]
				if (idRostoData == (idRosto)) or (tabelaRoupas[genero]["tatoorosto"][(idRosto)][4] == "remover") then
					valorSombrancelha = 0
				else
					valorSombrancelha = tabelaRoupas[genero]["tatoorosto"][(idRosto)][4]
				end
				triggerServerEvent("Conner.applyTatooPed", localPlayer, localPlayer, idRosto, "tatoorosto")
				guiTick = getTickCount();
			elseif isCursorInPosition(40/zoom, 260/zoom, 30/zoom, 30/zoom) then--Anterior
				idRosto = idRosto-1
				setCameraMatrix(unpack(lojas["Tatuagem"]["cameras"]["rosto"]))
				if idRosto < 1 then
					idRosto = qntRosto
				end
				local idRostoData = datatatoo[genero]["rosto"]
				if (idRostoData == (idRosto)) or (tabelaRoupas[genero]["tatoorosto"][(idRosto)][4] == "remover") then
					valorSombrancelha = 0
				else
					valorSombrancelha = tabelaRoupas[genero]["tatoorosto"][(idRosto)][4]
				end
				triggerServerEvent("Conner.applyTatooPed", localPlayer, localPlayer, idRosto, "tatoorosto")
				guiTick = getTickCount();

			elseif isCursorInPosition(370/zoom, 310/zoom, 30/zoom, 30/zoom) then--Próximo
				idPeito = idPeito+1
				setCameraMatrix(unpack(lojas["Tatuagem"]["cameras"]["peito"]))
				if idPeito > qntPeito then
					idPeito = 1
				end
				local idPeitoData = datatatoo[genero]["peito"]
				if (idPeitoData == (idPeito)) or (tabelaRoupas[genero]["tatoopeito"][(idPeito)][4] == "remover") then
					valorPeito = 0
				else
					valorPeito = tabelaRoupas[genero]["tatoopeito"][(idPeito)][4]
				end
				triggerServerEvent("Conner.applyTatooPed", localPlayer, localPlayer, idPeito, "tatoopeito")
				guiTick = getTickCount();
			elseif isCursorInPosition(40/zoom, 310/zoom, 30/zoom, 30/zoom) then--Anterior
				idPeito = idPeito-1
				setCameraMatrix(unpack(lojas["Tatuagem"]["cameras"]["peito"]))
				if idPeito < 1 then
					idPeito = qntPeito
				end
				local idPeitoData = datatatoo[genero]["peito"]
				if (idPeitoData == (idPeito)) or (tabelaRoupas[genero]["tatoopeito"][(idPeito)][4] == "remover") then
					valorPeito = 0
				else
					valorPeito = tabelaRoupas[genero]["tatoopeito"][(idPeito)][4]
				end
				triggerServerEvent("Conner.applyTatooPed", localPlayer, localPlayer, idPeito, "tatoopeito")
				guiTick = getTickCount();

			elseif isCursorInPosition(370/zoom, 360/zoom, 30/zoom, 30/zoom) then--Próximo
				idBraco = idBraco+1
				setCameraMatrix(unpack(lojas["Tatuagem"]["cameras"]["bracos"]))
				if idBraco > qntBracos then
					idBraco = 1
				end
				local idBracoData = datatatoo[genero]["bracos"]
				if (idBracoData == (idBraco)) or (tabelaRoupas[genero]["tatoobracos"][(idBraco)][4] == "remover") then
					valorBracos = 0
				else
					valorBracos = tabelaRoupas[genero]["tatoobracos"][(idBraco)][4]
				end
				triggerServerEvent("Conner.applyTatooPed", localPlayer, localPlayer, idBraco, "tatoobracos")
				guiTick = getTickCount();
			elseif isCursorInPosition(40/zoom, 360/zoom, 30/zoom, 30/zoom) then--Anterior
				idBraco = idBraco-1
				setCameraMatrix(unpack(lojas["Tatuagem"]["cameras"]["bracos"]))
				if idBraco < 1 then
					idBraco = qntBracos
				end
				local idBracoData = datatatoo[genero]["bracos"]
				if (idBracoData == (idBraco)) or (tabelaRoupas[genero]["tatoobracos"][(idBraco)][4] == "remover") then
					valorBracos = 0
				else
					valorBracos = tabelaRoupas[genero]["tatoobracos"][(idBraco)][4]
				end
				triggerServerEvent("Conner.applyTatooPed", localPlayer, localPlayer, idBraco, "tatoobracos")
				guiTick = getTickCount();

			elseif isCursorInPosition(370/zoom, 410/zoom, 30/zoom, 30/zoom) then--Próximo
				idEstomago = idEstomago+1
				setCameraMatrix(unpack(lojas["Tatuagem"]["cameras"]["estomago"]))
				if idEstomago > qntEstomago then
					idEstomago = 1
				end
				local idEstomagoData = datatatoo[genero]["estomago"]
				if (idEstomagoData == (idEstomago)) or (tabelaRoupas[genero]["tatooestomago"][(idEstomago)][4] == "remover") then
					valorEstomago = 0
				else
					valorEstomago = tabelaRoupas[genero]["tatooestomago"][(idEstomago)][4]
				end
				triggerServerEvent("Conner.applyTatooPed", localPlayer, localPlayer, idEstomago, "tatooestomago")
				guiTick = getTickCount();
			elseif isCursorInPosition(40/zoom, 410/zoom, 30/zoom, 30/zoom) then--Anterior
				idEstomago = idEstomago-1
				setCameraMatrix(unpack(lojas["Tatuagem"]["cameras"]["estomago"]))
				if idEstomago < 1 then
					idEstomago = qntEstomago
				end
				local idEstomagoData = datatatoo[genero]["estomago"]
				if (idEstomagoData == (idEstomago)) or (tabelaRoupas[genero]["tatooestomago"][(idEstomago)][4] == "remover") then
					valorEstomago = 0
				else
					valorEstomago = tabelaRoupas[genero]["tatooestomago"][(idEstomago)][4]
				end
				triggerServerEvent("Conner.applyTatooPed", localPlayer, localPlayer, idEstomago, "tatooestomago")
				guiTick = getTickCount();

			elseif isCursorInPosition(40/zoom, 460/zoom, 30/zoom, 30/zoom) then--Anterior
				idPanturrilha = idPanturrilha+1
				setCameraMatrix(unpack(lojas["Tatuagem"]["cameras"]["panturrilha"]))
				if idPanturrilha > qntPanturrilha then
					idPanturrilha = 1
				end
				local idPanturrilhaData = datatatoo[genero]["panturrilha"]
				if (idPanturrilhaData == (idPanturrilha)) or (tabelaRoupas[genero]["tatoopanturrilha"][(idPanturrilha)][4] == "remover") then
					valorPanturrilha = 0
				else
					valorPanturrilha = tabelaRoupas[genero]["tatoopanturrilha"][(idPanturrilha)][4]
				end
				triggerServerEvent("Conner.applyTatooPed", localPlayer, localPlayer, idPanturrilha, "tatoopanturrilha")
				guiTick = getTickCount();
			elseif isCursorInPosition(370/zoom, 460/zoom, 30/zoom, 30/zoom) then--Anterior
				idPanturrilha = idPanturrilha-1
				setCameraMatrix(unpack(lojas["Tatuagem"]["cameras"]["panturrilha"]))
				if idPanturrilha < 1 then
					idPanturrilha = qntPanturrilha
				end
				local idPanturrilhaData = datatatoo[genero]["panturrilha"]
				if (idPanturrilhaData == (idPanturrilha)) or (tabelaRoupas[genero]["tatoopanturrilha"][(idPanturrilha)][4] == "remover") then
					valorPanturrilha = 0
				else
					valorPanturrilha = tabelaRoupas[genero]["tatoopanturrilha"][(idPanturrilha)][4]
				end
				triggerServerEvent("Conner.applyTatooPed", localPlayer, localPlayer, idPanturrilha, "tatoopanturrilha")
				guiTick = getTickCount();
			end
		end
	end
end)

addEventHandler("onClientPlayerWasted",getLocalPlayer(),function()
	removeEventHandler("onClientRender", root, dxPainelTatuagem)
	triggerServerEvent("Conner.sairTatuagem", localPlayer, localPlayer)
end)