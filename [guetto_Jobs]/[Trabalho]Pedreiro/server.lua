-----------------------------------------------------------------------------------------------------------------------------------------
local pickup = createPickup(1268.638, -1269.426, 13.492, 3, 1210, 1)
local blip = createBlipAttachedTo(pickup, 42)
local cavar = createMarker(1229.845, -1245.374, 17.89999, "cylinder", 1.1, 0, 0, 0, 0)
setElementData(cavar, "markerData", {title = "Cavar", desc = "Cave aqui sua carga!", icon = "checkpoint"})
local entregar = createMarker(1280.125, -1256.978, 13.7-0.9, "cylinder", 1.1, 0, 0, 0, 0)
setElementData(entregar, "markerData", {title = "Entregar", desc = "Entrega sua carga aqui!", icon = "checkpoint"})
setElementVisibleTo(cavar, root, false)
setElementVisibleTo(entregar, root, false)

-----------------------------------------------------------------------------------------------------------------------------------------
saco = {}
timerEntregar = {}
-----------------------------------------------------------------------------------------------------------------------------------------

addCommandHandler("infos",
function(player)
	if player and isElement(player) then
		if getElementData(player, "Emprego") == "Pedreiro" then
			if not isTimer(TimerEmprego) then
				blip = createBlip(1280.485, -1257.612, 12.642, 41)
				setElementVisibleTo(blip, root, false)
				setElementVisibleTo(blip, player, true)
				sendMessageServer(player, "Seu local de emprego foi marcado em seu GPS com sucesso!", "info")
				triggerClientEvent(player, "JOAO.marcadorJobs", player, 1280.485, -1257.612, 12.642, 0, 0, "Emprego")
				TimerEmprego = setTimer(function()
					if player and isElement(player) then
						triggerClientEvent(player, "JOAO.removeMarcadorJobs", player)
						if isElement(blip) then destroyElement(blip) end
					end
				end, 60000, 1)
			else
				sendMessageServer(player, "Você já tem um local de emprego marcado!", "error")
			end
		end
	end
end)

sendMessageServer = function(player, message, type)
	return exports['guetto_notify']:showInfobox(player, type, message)
end;

-----------------------------------------------------------------------------------------------------------------------------------------
function startJob(playerSource)
	if getElementType(playerSource) == 'player' then
		if (getElementData(playerSource, "Emprego") ~= "Pedreiro") then 
			return sendMessageServer(playerSource, "Você não trabalha aqui!", "error")
		end
		if not isElementVisibleTo(cavar, playerSource) and not isElementVisibleTo(entregar, playerSource) then
			giveWeapon(playerSource, 6)
			sendMessageServer(playerSource, "Vá até o local indicado para encher os sacos de areia.", "info")
			outputChatBox(" ", playerSource, 30, 144, 255, true)
			outputChatBox("[EMPREGO]:#FFFFFF Digite #FFFF00/cancelar #FFFFFF para cancelar seu trabalho.", playerSource, 30, 144, 255, true)
			setElementVisibleTo(cavar, playerSource, true)
			addEventHandler("onPlayerQuit", playerSource, reset)
			addEventHandler("onPlayerWasted", playerSource, reset)
			setElementData(playerSource, "Emprego", "Pedreiro")
		else
			sendMessageServer(playerSource, "Você precisa de uma 'Pá' para este trabalho", "error")
		end
	end
end
addEventHandler("onPickupHit", pickup, startJob)

-----------------------------------------------------------------------------------------------------------------------------------------

function Cavar(playerSource)
	if getElementType(playerSource) == 'player' then
		if not isPedInVehicle(playerSource) then
			if not isElement(saco[playerSource]) then
				if getPedWeapon(playerSource, current) == 6 then
					setElementVisibleTo(cavar, playerSource, false)
					setElementFrozen(playerSource, true)
					setPedAnimation(playerSource, "CHAINSAW", "WEAPON_csawlo", -1, true, false, false)
					exports["guetto_progress"]:callProgress(playerSource, "Pedreiro", "Você está cavando!", "martelo", 11000) 
					setTimer(function()
						if playerSource and isElement(playerSource) then
							saco[playerSource] = createObject(2060, 0, 0, 0)
							setElementFrozen(playerSource, false)
							setPedAnimation(playerSource, "CARRY", "liftup", 1.0, false)
							setPedAnimation(playerSource, nil)
							toggleControl(playerSource, "jump", false)
							toggleControl(playerSource, "fire", false)
							toggleControl(playerSource, "aim_weapon", false)
							toggleControl(playerSource, "crouch", false)
							setPedAnimation(playerSource, "CARRY", "crry_prtial", 4.1, true, true, true)
							exports.bone_attach:attachElementToBone(saco[playerSource], playerSource, 11, -0.18, 0.13, 0.1, 90, 0, 8)
							setElementVisibleTo(entregar, playerSource, true)
							sendMessageServer(playerSource, "Leve o saco de areia até o local indicado para receber seu pagamento.", "info")
						end
					end, 11300, 1)
				else
					sendMessageServer(playerSource, "Você precisa estar com uma 'Pá' em mãos para cavar.", "error")
				end
			end
		end
	end
end
addEventHandler("onMarkerHit", cavar, Cavar)
-----------------------------------------------------------------------------------------------------------------------------------------
function Entregar(playerSource)
	if getElementType(playerSource) == 'player' then
		local Emprego = getElementData(playerSource, "Emprego") or "Desempregado"
		if Emprego == "Pedreiro" then
			if isElement(saco[playerSource]) then
				if not isTimer(timerEntregar[playerSource]) then
					setPedAnimation(playerSource, "CARRY", "putdwn", 1.0, false, false, false, true)
					setElementVisibleTo(entregar, playerSource, false)
					timerEntregar[playerSource] = setTimer(function()
						setPedAnimation(playerSource, "CARRY", "liftup", 0.0, false, false, false, false)
						destroyElement(saco[playerSource])
						saco[playerSource] = nil
						toggleAllControls(playerSource, true)
						setElementVisibleTo(cavar, playerSource, true)
						local money = config["Money"]
						local expp = (getElementData(playerSource, 'XP') or 0)
						local isVip = exports["guetto_util"]:isPlayerVip(playerSource)

						if (isVip) then 
							setElementData(playerSource, "XP", expp+100)
						else
							setElementData(playerSource, "XP", expp+50)
						end
						
						givePlayerMoney(playerSource, money)
						sendMessageServer(playerSource, "Você recebeu "..money.." reais", "info")
					end, 1000, 1)
				end
			end
		end
	end
end
addEventHandler("onMarkerHit", entregar, Entregar)
-----------------------------------------------------------------------------------------------------------------------------------------
function cancel(source)
    local emprego = getElementData(source, "Emprego")
    if emprego == "Pedreiro" then
        if isElementVisibleTo(cavar, source) or isElementVisibleTo(entregar, source) then
        	if isElement(saco[source]) then destroyElement(saco[source]) saco[source] = nil end
        	if isTimer(timerEntregar[source]) then killTimer(timerEntregar[source]) timerEntregar[source] = nil end
            toggleAllControls(source, true)
            setPedAnimation(source, "CARRY", "liftup", 0.0, false, false, false, false)
            setElementFrozen(source, false)
			takeWeapon(source, 6)
			takeWeapon(source, 6) 
            sendMessageServer(source, "Você concluido o serviço", "success")
            setElementVisibleTo(entregar, source, false)
            setElementVisibleTo(cavar, source, false)
			removeEventHandler("onPlayerQuit", source, reset)
			removeEventHandler("onPlayerWasted", source, reset)
        end
    end
end
addCommandHandler("cancelar", cancel)

-----------------------------------------------------------------------------------------------------------------------------------------
function reset()
    local emprego = getElementData(source, "Emprego")
    if emprego == "Pedreiro" then
        if isElementVisibleTo(cavar, source) or isElementVisibleTo(entregar, source) then
        	if isElement(saco[source]) then destroyElement(saco[source]) saco[source] = nil end
        	if isTimer(timerEntregar[source]) then killTimer(timerEntregar[source]) timerEntregar[source] = nil end
            toggleAllControls(source, true)
            setPedAnimation(source, "CARRY", "liftup", 0.0, false, false, false, false)
            setElementFrozen(source, false)
            setElementVisibleTo(entregar, source, false)
            setElementVisibleTo(cavar, source, false)
			removeEventHandler("onPlayerQuit", source, reset)
			removeEventHandler("onPlayerWasted", source, reset)
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------