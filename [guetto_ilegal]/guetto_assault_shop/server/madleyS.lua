local peds = createElement('MAD:PedsAssalto')
local cofre = createElement('MAD:Cofre')
local allpeds = {	};
local objects = {	};
local area = {	};

OBJECTSaSSALT = {}

for i ,v in ipairs(Config.AssaltoConfig) do
	area[i] = createColSphere(v['area'][1],v['area'][2],v['area'][3],v['area'][4])
	allpeds[i] = createPed(v['pedcfg'][1],v['pedcfg'][2],v['pedcfg'][3],v['pedcfg'][4],v['pedcfg'][5])
	objects[allpeds[i]] = createObject(v['cofrecfg'][1],v['cofrecfg'][2],v['cofrecfg'][3],v['cofrecfg'][4],v['cofrecfg'][5],v['cofrecfg'][6],v['cofrecfg'][7])
	setElementParent(allpeds[i],peds)
	setElementData(allpeds[i],'imortal',true)
	setElementData(allpeds[i],'Assaltado',false)    
	setElementParent(objects[allpeds[i]],cofre)
	createBlip(v['pedcfg'][2],v['pedcfg'][3],v['pedcfg'][4],v['blip'])

	addEventHandler('onColShapeLeave', area[i], 

		function(player, matchdimension)
			
			if (matchdimension) then 
			
				if (isElement(player) and getElementType(player) == 'player') then 

					if (isTimer(playerTimer[player])) then 

						killTimer(playerTimer[player])
					
					end
				
					if (isElement(object[player])) then 
				
						destroyElement(object[player])
						msgServer(player,'Você saiu da área permitida e perdeu a mochila','info')
				
					end

				end

			end

		end

	)

end

for i ,v in ipairs(getElementsByType('player')) do
	setElementData(v,'MAD:Assaltando',false)
	setElementData(v,'Digitando',nil)
end

createEvent = function(event,element,func)
	addEvent(''..event,true)
	addEventHandler(''..event,root,func)
end;

blips = {}
acionarAlarme = function(elementBase)
	local pos = {getElementPosition(elementBase)}
	blips[elementBase] = createBlip(pos[1],pos[2],pos[3],Config['GlobalConfigs']['blipassalto'])
	setElementVisibleTo(blips[elementBase],root,false)
	for i ,v in ipairs(getElementsByType('player')) do
		local acc = getAccountName(getPlayerAccount(v))
		if acc then  
			if isObjectInACLGroup('user.'..acc,aclGetGroup(Config['GlobalConfigs']['aclPolicial'])) then 
				setElementVisibleTo(blips[elementBase],v,true)
				msgServer(v,'Atenção uma lojinha esta sendo assaltada !','info')
			end
		end
	end
	triggerClientEvent('MAD:PLAYALARM',root,elementBase)
end
createEvent('MAD:ATIVARALARME',root,acionarAlarme)

function getPolicesMoment()

	local polices = 0 

	for i ,v in ipairs(getElementsByType('player')) do
		local acc = getAccountName(getPlayerAccount(v))

		if (getElementData(v, "service.police") == true) then 
			polices = polices + 1
		end

	end

	return polices 

end 

PLAYERS = {}
pedsemassalto = {}

addEventHandler( "onElementClicked", peds, 
function (mouseButton, buttonState, playerWhoClicked, clickPosX, clickPosY, clickPosZ) 
	if mouseButton == 'left' and buttonState == 'down' then
		if (ReturnDistance(source,playerWhoClicked) < 3 ) then

			if (getPolicesMoment() <= 0) then 

				return msgServer(playerWhoClicked, 'Não existem policiais online no momento.', 'error')

			end
			
			local id = getPedWeapon(playerWhoClicked)
			if not armas[id] then 
					if id ~= 0 then 
						msgServer(playerWhoClicked,'Voce nao pode assaltar com essa arma','error')
					else
						msgServer(playerWhoClicked,'Voce nao pode assaltar sem armas','error')
					end
				return 
			end
			if not getElementData(source,'Assaltado') then
				if PLAYERS[playerWhoClicked] then 
						msgServer(playerWhoClicked,'Voce ja esta participando de um assalto','error')
					return 
				end 
				local receive = GenerateAleatoryString()
				reiniciarAssalto(playerWhoClicked,source)
				triggerClientEvent(playerWhoClicked,'MD > Receive',playerWhoClicked,source,'✘ Caralho!! sou só o atendente mas tenta ☛ '..receive,receive)
					setElementFrozen(playerWhoClicked,true)    
					setPedAnimation (playerWhoClicked, "SHOP", "SHP_Gun_Aim", -1, true, false, true ) 
	    	    PLAYERS[playerWhoClicked] = {source}  
	    	    setPedAnimation(source, "SHOP", "SHP_Rob_GiveCash", -1, true, false, true ) 
				setTimer(function(player,ped) 
		    	    setPedAnimation(player, nil ) 
		    	    setPedAnimation(ped, nil ) 
		    	    setElementFrozen(player,false)  
    	    	    setElementData(ped,'Assaltado',true)  
					setElementFrozen(ped, true)
					setPedAnimation(ped, "CRACK", "crckdeth2", -1, false, true, false)
					msgServer(player,'Vá ate o cofre e digite a senha.','info')
				end,1000*Config['GlobalConfigs']['tempo_ocorrendoabordagem'],1,playerWhoClicked,source)
			else
				if PLAYERS[playerWhoClicked] then 
					if getElementData(source,'Assaltado') then 
						triggerClientEvent(playerWhoClicked,'MD > Receive',playerWhoClicked,source)
					end
				end 
			end
		end
	end
end)


bags = {}
cofres = {}
object, playerTimer = {}, {}
createEvent('MAD > TakeMoneySHOP',getRootElement(),function(player)
	setElementFrozen(player,true)
	setElementData(player,'Digitando',nil)
	setElementData(cofres[player],'AssaltadoRecentemente',true)
	setPedAnimation (player, "BOMBER", "BOM_Plant", -1, true, false, false)
	triggerEvent('MAD:ATIVARALARME',player,player)
	msgServer(player,'O Dono da mercearia Ativou o alarme e os visinhos avisaram a policia fique alerta','info')

	setTimer(function(player)

		if (isElement(player)) then 

			if (isElement(object[player])) then 

				destroyElement(object[player])
		
			end

			object[player] = createObject(1550, 0, 0, 0)
			exports.pAttach:attach(object[player], player,  3, -0.02,-0.19,-0.01,-7.2,0,0)
			--exports['bone_attach']:attachElementToBone(object[player], player, 3, 0, - 0.2, 0, 0, 0, 0)
			msgServer(player,'Você tem '..Config['GlobalConfigs']['tempobolsa']..' segundos para ficar com a bolsa, caso saia da lojinha irá','info')
			msgServer(player,'Caso saia da lojinha nesse tempo você irá perder a mochila de dinheiro','info')
			setElementFrozen(player,false)    
			setPedAnimation(player,nil)

			if (isTimer(playerTimer[player])) then 

				killTimer(playerTimer[player])
			
			end
			
			playerTimer[player] = setTimer(function(player)

				if (isElement(player)) then 

					if (isElement(object[player])) then 

						destroyElement(object[player])
				
					end

					local money = math.random(Config['GlobalConfigs']['max_and_min_money'][1],Config['GlobalConfigs']['max_and_min_money'][2])
					exports["guetto_inventory"]:giveItem(player, 100, math.random(Config['GlobalConfigs']['max_and_min_money'][1],Config['GlobalConfigs']['max_and_min_money'][2]))
				end 

			end,Config['GlobalConfigs']['tempobolsa']*1000,1, player)

		end 

	end,Config['GlobalConfigs']['tempopegarmoney']*1000,1, player)

end)

addEventHandler( "onPlayerWasted", getRootElement(), 
function (totalAmmo, killer, killerWeapon, bodypart, stealth) 

	if (isTimer(playerTimer[source])) then 

		killTimer(playerTimer[source])
	
	end

	if (isElement(object[source])) then 

		destroyElement(object[source])

	end

	if Config['GlobalConfigs']['perder_ao_morrer'] then 
		setElementData(source,moneySujo,nil)
		setElementData(source,'Digitando',nil)
	end
end)

addEventHandler( "onPlayerQuit", getRootElement(), 
function () 

	if (isTimer(playerTimer[source])) then 

		killTimer(playerTimer[source])
	
	end

	if (isElement(object[source])) then 

		destroyElement(object[source])

	end

end)

timers = {}
function reiniciarAssalto(player,ped)
	timers[ped] = setTimer(function(player,ped)
		setPedAnimation(ped,nil)
	    setElementData(ped,'Assaltado',nil)
	    if PLAYERS[player] then 
	    	PLAYERS[player] = nil 
	    end
	    if isElement(cofres[player]) then   
	    	setElementData(cofres[player],'AssaltadoRecentemente',nil)
		end
		if isElement(blips[player]) then 
			destroyElement(blips[player])
		end
	end,Config['GlobalConfigs']['tempo_reinciar_assalto']*60000,1,player,ped)
end


addEventHandler( "onElementClicked", cofre, 
function (mouseButton, buttonState, playerWhoClicked, clickPosX, clickPosY, clickPosZ) 
	if mouseButton == 'left' and buttonState == 'down' then
		if (ReturnDistance(source,playerWhoClicked) < 3 ) then
			if getElementData(playerWhoClicked,'Digitando') then 
				return 
			end
			local data = PLAYERS[playerWhoClicked]
			if data then
				if source == objects[data[1]] then 
					if not getElementData(source,'AssaltadoRecentemente') then 
						msgServer(playerWhoClicked,'Digite a senha para abrir o cofre Voce tem 3 tentativas','info')
					 	setElementData(playerWhoClicked,'Digitando',true)
					 	cofres[playerWhoClicked] = source
					 	triggerClientEvent(playerWhoClicked,'MAD:OPENCOFRE',playerWhoClicked)
					 else
					 	msgServer(playerWhoClicked,'Esse Cofre Foi assaltado recentemente','info')
					 end
				else
					msgServer(playerWhoClicked,'Renda o atendente para que ele possa lhe dar a senha.','info')
			 	end
			else
				msgServer(playerWhoClicked,'Renda o atendente para que ele possa lhe dar a senha.','info')
			end
		end
	end
end)





function onStealthKill (targetPed)
    if (getElementData (targetPed, "imortal")) then
        cancelEvent()
    end
end
addEventHandler ("onPlayerStealthKill", root, onStealthKill)



GenerateAleatoryString = function()
	local stringsreturn = ''
	local strings = {'1','2','3','4','5','6','7','8','9'};
	for i = 1 , 4 do
		local strindex = math.random(1,#strings)
		stringsreturn = stringsreturn..strings[strindex]
	end
	return stringsreturn
end


ReturnDistance = function(player1,player2)
	local pos = {}
	pos[player1] = {getElementPosition(player1)}; 
	pos[player2] = {getElementPosition(player2)};
	return getDistanceBetweenPoints3D(pos[player1][1],pos[player1][2],pos[player1][3],pos[player2][1],pos[player2][2],pos[player2][3]) 
end