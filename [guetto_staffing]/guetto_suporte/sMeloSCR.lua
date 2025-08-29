--[[
███╗░░░███╗███████╗██╗░░░░░░█████╗░  ░██████╗░█████╗░██████╗░
████╗░████║██╔════╝██║░░░░░██╔══██╗  ██╔════╝██╔══██╗██╔══██╗
██╔████╔██║█████╗░░██║░░░░░██║░░██║  ╚█████╗░██║░░╚═╝██████╔╝
██║╚██╔╝██║██╔══╝░░██║░░░░░██║░░██║  ░╚═══██╗██║░░██╗██╔══██╗
██║░╚═╝░██║███████╗███████╗╚█████╔╝  ██████╔╝╚█████╔╝██║░░██║
╚═╝░░░░░╚═╝╚══════╝╚══════╝░╚════╝░  ╚═════╝░░╚════╝░╚═╝░░╚═╝
]]

function sendMessageServer( player, msg, type )
	return exports['guetto_notify']:showInfobox(player, type, msg)
end

addCommandHandler("staff", 
function (thePlayer, cmd)
    if thePlayer and isElement(thePlayer) and getElementType(thePlayer) == "player" then 
        for i,v in ipairs(config.Comandos[cmd].aclsPerm) do 
            if aclGetGroup(v[1]) and isObjectInACLGroup("user."..getAccountName(getPlayerAccount(thePlayer)), aclGetGroup(v[1])) then 
                if config.Comandos[cmd].estarDePro and not getElementData(thePlayer, "onProt") then return sendMessageServer(thePlayer, "Você deve estar de /pro para executar este comando!", "info") end 
                if getElementData(thePlayer, "MeloSCR:StaffAtivo") then
                    local key = getPlayerSerial(thePlayer)    
                    local hashtoKey = toJSON({type = "remove"})
                    encodeString('aes128', hashtoKey, {key = key:sub(17)}, function(enc, iv)
                        triggerClientEvent(thePlayer, "squady.onWall", resourceRoot, thePlayer, enc, iv)
                    end)
                    sendMessageServer(thePlayer, "Modo staff desativado com sucesso!", "success")
                    setElementData(thePlayer, "MeloSCR:StaffAtivo", false)
                    setElementData(thePlayer, "MeloSCR:NC", false)
                    if getElementData(thePlayer, "MeloSCR:Fly") then 
                        triggerClientEvent(thePlayer, "onClientFlyToggle", thePlayer)
                    end
                    setElementAlpha(thePlayer, 255)
                    if config.Comandos[cmd].Logs.ativo then 
                        sendDiscordMessage("O Staff: "..removeHex(getPlayerName(thePlayer)).." ("..(getElementData(thePlayer, "ID") or "N/A")..") desativou o modo staff!", config.Comandos[cmd].Logs.webhook)
                    end
                else 
                    if not getElementData(thePlayer, "MeloSCR:Fly") then 
                        triggerClientEvent(thePlayer, "onClientFlyToggle", thePlayer)
                    end
                    local key = getPlayerSerial(thePlayer)    
                    local hashtoKey = toJSON({type = "add"})
                    encodeString('aes128', hashtoKey, {key = key:sub(17)}, function(enc, iv)
                        triggerClientEvent(thePlayer, "squady.onWall", resourceRoot, thePlayer, enc, iv)
                    end)
                    setElementAlpha(thePlayer, 0)
                    setElementData(thePlayer, "MeloSCR:StaffAtivo", true)
                    setElementData(thePlayer, "MeloSCR:NC", true)
                    sendMessageServer(thePlayer, "Modo staff ativado com sucesso!", "success")
                    if config.Comandos[cmd].Logs.ativo then 
                        sendDiscordMessage("O Staff: "..removeHex(getPlayerName(thePlayer)).." ("..(getElementData(thePlayer, "ID") or "N/A")..") ativou o modo staff!", config.Comandos[cmd].Logs.webhook)
                    end 
                end 
                
                break
            elseif i == #config.Comandos[cmd].aclsPerm then 
                sendMessageServer(thePlayer, "Você não tem permissão para executar este comando!", "error")
            end 
        end 
    end 
end)

function Unbug(playerSource, commandName, id)
	if isObjectInACLGroup("user."..getAccountName(getPlayerAccount(playerSource)), aclGetGroup("Staff")) or isObjectInACLGroup("user."..getAccountName(getPlayerAccount(playerSource)), aclGetGroup("Staff")) then
		if not getElementData(playerSource, "onProt") then return notifyS(playerSource, 'Você precisa ativar o /pro.', 'error') end 
		if id and tonumber(id) then
			for _, players in pairs(getElementsByType("player")) do
				if getElementData(players, "ID") == tonumber(id) then
					setElementFrozen(players, false)
					toggleAllControls(players, true)
					setPlayerHudComponentVisible(players, "crosshair", true)
					setPedAnimation(players, nil)
					setElementCollisionsEnabled(players, true)
					setElementAlpha(players, 255)
					sendMessageServer(playerSource, "Você desbugou o jogador "..getPlayerName(players), "success")
					sendMessageServer(players, "Você foi desbugado pelo Staff "..getPlayerName(playerSource), "info")
				end
			end
		end
	end
end
addCommandHandler("unbug", Unbug)

function Pegar_Veiculo(Player)
	if isObjectInACLGroup ( "user." ..getAccountName(getPlayerAccount(Player)), aclGetGroup ("Staff")) then
		if not getElementData(Player, "onProt") then return sendMessageServer(Player, 'Você precisa ativar o /pro.', 'error') end 
	local Veiculo_Perto = getNearestElement(Player, "vehicle", 5)
	local Ticket = getElementData(Player, "AntiBugGuizin")
	if Veiculo_Perto then
	if Ticket == false then
	attachElements(Veiculo_Perto, Player, 2, 0, 0)
	setElementData(Player, "AntiBugGuizin", true)
	sendMessageServer(Player, "você pegou o veículo", "success")
	else
	detachElements(Veiculo_Perto, Player)
	setElementData(Player, "AntiBugGuizin", false)
	sendMessageServer(Player, "você soltou o veículo", "success")
	end
	end
	else
	sendMessageServer(Player, "você não tem permisão para isto", "error")
	end
	end
addCommandHandler("cpegar", Pegar_Veiculo)

function getNearestElement(thePlayer, elementType, distance)
	local nearestElement = false
	local px, py, pz = getElementPosition(thePlayer)
	local pInt = getElementInterior(thePlayer)
	local pDim = getElementDimension(thePlayer)
	for _, e in pairs(getElementsByType(elementType)) do
	local eInt, eDim = getElementInterior(e), getElementDimension(e)
	if eInt == pInt and eDim == pDim and e ~= thePlayer then
	local ex, ey, ez = getElementPosition(e)
	local dis = getDistanceBetweenPoints3D(px, py, pz, ex, ey, ez)
	if dis < distance then
	nearestElement = e
	end
	end
	end
	return nearestElement
	end

addCommandHandler("nc",
function(player)
    if player and isElement(player) and getElementType(player) == "player" then  
        if aclGetGroup("Staff") and isObjectInACLGroup("user."..getAccountName(getPlayerAccount(player)), aclGetGroup("Staff")) then
            if (getElementData(player, "onProt") or false) then
                if (getElementData(player, "MeloSCR:NC") or false) then
                    setElementData(player, "MeloSCR:NC", false)
                    local key = getPlayerSerial(player)    
                    local hashtoKey = toJSON({type = "remove"})
                    setElementAlpha(player, 255)
                    sendMessageServer(player, "Você desativou o NC com sucesso!", "success")
                else
                    setElementAlpha(player, 0)
                    setElementData(player, "MeloSCR:NC", true)
                    sendMessageServer(player, "Você ativou o NC com sucesso!", "success")
                end
            end
        end
    end 
end)


function cordTeleporte(player, cmd, ...)
    if player and isElement(player) and getElementType(player) == 'player' then 
        if isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(player)), aclGetGroup('Console')) then
            if (...) then 
                local posA = {...}
                if posA then
                    if split(posA[1], ',')[1] and split(posA[2], ',')[1] and posA[3] then
                        if getPedOccupiedVehicle(player) then 
                            setElementPosition(getPedOccupiedVehicle(player), split(posA[1], ',')[1], split(posA[2], ',')[1], posA[3])
                        else 
                            setElementPosition(player, split(posA[1], ',')[1], split(posA[2], ',')[1], posA[3])
                        end 
                    end
                end
            end 
        end 
    end 
end
addCommandHandler('tppos', cordTeleporte)

addCommandHandler("fly", 
function (thePlayer, cmd)
    if thePlayer and isElement(thePlayer) and getElementType(thePlayer) == "player" then 
        for i,v in ipairs(config.Comandos[cmd].aclsPerm) do 
            if aclGetGroup(v[1]) and isObjectInACLGroup("user."..getAccountName(getPlayerAccount(thePlayer)), aclGetGroup(v[1])) then 
                if config.Comandos[cmd].estarDePro and not getElementData(thePlayer, "onProt") then return sendMessageServer(thePlayer, "Você deve estar de /pro para executar este comando!", "info") end 
                if getElementData(thePlayer, "MeloSCR:Fly") then 
                    if config.Comandos[cmd].Logs.ativo then 
                        sendDiscordMessage("O Staff: "..removeHex(getPlayerName(thePlayer)).." ("..(getElementData(thePlayer, "ID") or "N/A")..") desativou o /fly!", config.Comandos[cmd].Logs.webhook)
                    end 
                else 
                    if config.Comandos[cmd].Logs.ativo then 
                        sendDiscordMessage("O Staff: "..removeHex(getPlayerName(thePlayer)).." ("..(getElementData(thePlayer, "ID") or "N/A")..") ativou o /fly!", config.Comandos[cmd].Logs.webhook)
                    end 
                end 
                triggerClientEvent(thePlayer, "onClientFlyToggle", thePlayer)
                break
            elseif i == #config.Comandos[cmd].aclsPerm then 
                sendMessageServer(thePlayer, "Você não tem permissão para executar este comando!", "error")
            end 
        end 
    end 
end)

addCommandHandler("v", 
function (thePlayer, cmd)
    if thePlayer and isElement(thePlayer) and getElementType(thePlayer) == "player" then 
        for i,v in ipairs(config.Comandos[cmd].aclsPerm) do 
            if aclGetGroup(v[1]) and isObjectInACLGroup("user."..getAccountName(getPlayerAccount(thePlayer)), aclGetGroup(v[1])) then 
                if config.Comandos[cmd].estarDePro and not getElementData(thePlayer, "onProt") then return sendMessageServer(thePlayer, "Você deve estar de /pro para executar este comando!", "info") end 
                if getElementAlpha(thePlayer) == 0 then 
                    setElementAlpha(thePlayer, 255)
                    sendMessageServer(thePlayer, "Modo invisivel desativado com sucesso!", "success")
                    if config.Comandos[cmd].Logs.ativo then 
                        sendDiscordMessage("O Staff: "..removeHex(getPlayerName(thePlayer)).." ("..(getElementData(thePlayer, "ID") or "N/A")..") desativou o modo invisivel!", config.Comandos[cmd].Logs.webhook)
                    end 
                else 
                    setElementAlpha(thePlayer, 0)
                    sendMessageServer(thePlayer, "Modo invisivel ativado com sucesso!", "success")
                    if config.Comandos[cmd].Logs.ativo then 
                        sendDiscordMessage("O Staff: "..removeHex(getPlayerName(thePlayer)).." ("..(getElementData(thePlayer, "ID") or "N/A")..") ativou o modo invisivel!", config.Comandos[cmd].Logs.webhook)
                    end 
                end 
                
                break
            elseif i == #config.Comandos[cmd].aclsPerm then 
                sendMessageServer(thePlayer, "Você não tem permissão para executar este comando!", "error")
            end 
        end 
    end 
end)

addCommandHandler("dvproximo", 
function (thePlayer, cmd)
    if thePlayer and isElement(thePlayer) and getElementType(thePlayer) == "player" then 
        for i,v in ipairs(config.Comandos[cmd].aclsPerm) do 
            if aclGetGroup(v[1]) and isObjectInACLGroup("user."..getAccountName(getPlayerAccount(thePlayer)), aclGetGroup(v[1])) then 
                if config.Comandos[cmd].estarDePro and not getElementData(thePlayer, "onProt") then return sendMessageServer(thePlayer, "Você deve estar de /pro para executar este comando!", "info") end 
                tabelaDistancias = {}
                for indx,theVehicle in ipairs(getElementsByType("vehicle", getRootElement())) do 
                    if getDistanceBetweenPoints3D(Vector3(getElementPosition(theVehicle)), Vector3(getElementPosition(thePlayer))) <= config.Comandos[cmd].distanciaVeiculo then 
                        table.insert(tabelaDistancias, {theVehicle, getDistanceBetweenPoints3D(Vector3(getElementPosition(theVehicle)), Vector3(getElementPosition(thePlayer)))})
                    end 
                end     
                if #tabelaDistancias > 0 then 
                    table.sort(tabelaDistancias, function (a,b) return a[2] < b[2] end)
                    local destroyVehicle = tabelaDistancias[1][1]
                    if destroyVehicle and isElement(destroyVehicle) then 
                        destroyElement(destroyVehicle)
                        sendMessageServer(thePlayer, "Veículo destruido com sucesso!", "success")
                        if config.Comandos[cmd].Logs.ativo then 
                            sendDiscordMessage("O Staff: "..removeHex(getPlayerName(thePlayer)).." ("..(getElementData(thePlayer, "ID") or "N/A")..") destruiu um veículo próximo!", config.Comandos[cmd].Logs.webhook)
                        end 
                    end 
                else 
                    sendMessageServer(thePlayer, "Não tem nenhum veículo proximo a você!", "error")
                end 
                break
            elseif i == #config.Comandos[cmd].aclsPerm then 
                sendMessageServer(thePlayer, "Você não tem permissão para executar este comando!", "error")
            end 
        end 
    end 
end)

addCommandHandler("dv", 
function (thePlayer, cmd, id)
    if thePlayer and isElement(thePlayer) and getElementType(thePlayer) == "player" then 
        for i,v in ipairs(config.Comandos[cmd].aclsPerm) do 
            if aclGetGroup(v[1]) and isObjectInACLGroup("user."..getAccountName(getPlayerAccount(thePlayer)), aclGetGroup(v[1])) then 
                if config.Comandos[cmd].estarDePro and not getElementData(thePlayer, "onProt") then return sendMessageServer(thePlayer, "Você deve estar de /pro para executar este comando!", "info") end 
                if id and tonumber(id) then 
                    local theTarget = getPlayerFromID(id)
                    if theTarget and isElement(theTarget) and getElementType(theTarget) == "player" then 
                        if getPedOccupiedVehicle(theTarget) then 
                            destroyElement(getPedOccupiedVehicle(theTarget))  
                            sendMessageServer(thePlayer, "Veículo destruido com sucesso!", "error")
                            if config.Comandos[cmd].Logs.ativo then 
                                sendDiscordMessage("O Staff: "..removeHex(getPlayerName(thePlayer)).." ("..(getElementData(thePlayer, "ID") or "N/A")..") destruiu o veículo do Jogador: "..removeHex(getPlayerName(theTarget)).." ("..(getElementData(theTarget, "ID") or "N/A")..")", config.Comandos[cmd].Logs.webhook)
                            end 
                        else 
                            sendMessageServer(thePlayer, "Este jogador não está em um veículo!", "error")
                        end 
                    else    
                        sendMessageServer(thePlayer, "Jogador não encontrado!", "error")
                    end 
                else 
                    sendMessageServer(thePlayer, "SINTAX: /"..cmd.." ID", "error")
                end 
                break
            elseif i == #config.Comandos[cmd].aclsPerm then 
                sendMessageServer(thePlayer, "Você não tem permissão para executar este comando!", "error")
            end 
        end 
    end 
end)

function isVehicleOccupied(vehicle)
    assert(isElement(vehicle) and getElementType(vehicle) == "vehicle", "Bad argument @ isVehicleOccupied [expected vehicle, got " .. tostring(vehicle) .. "]")
    local _, occupant = next(getVehicleOccupants(vehicle))
    return occupant and true, occupant
end

addCommandHandler("dvall", 
function (thePlayer, cmd, id)
    if thePlayer and isElement(thePlayer) and getElementType(thePlayer) == "player" then 
        for i,v in ipairs(config.Comandos[cmd].aclsPerm) do 
            if aclGetGroup(v[1]) and isObjectInACLGroup("user."..getAccountName(getPlayerAccount(thePlayer)), aclGetGroup(v[1])) then 
                for index, value in ipairs ( getElementsByType("vehicle") ) do
                    if not (getElementData(value, "vehicle.desmanche")) then 
                        if not isVehicleOccupied ( value ) then 
                            destroyElement(value)
                        end
                    end
                end
                sendMessageServer(thePlayer, "Todos os veículos desocupados foram destruidos!", "success")
            end
        end 
    end 
end)

addCommandHandler("setgas", 
function (thePlayer, cmd, id)
    if thePlayer and isElement(thePlayer) and getElementType(thePlayer) == "player" then 
        for i,v in ipairs(config.Comandos[cmd].aclsPerm) do 
            if aclGetGroup(v[1]) and isObjectInACLGroup("user."..getAccountName(getPlayerAccount(thePlayer)), aclGetGroup(v[1])) then 
                if config.Comandos[cmd].estarDePro and not getElementData(thePlayer, "onProt") then return sendMessageServer(thePlayer, "Você deve estar de /pro para executar este comando!", "info") end 
                if id and tonumber(id) then 
                    local theTarget = getPlayerFromID(id)
                    if theTarget and isElement(theTarget) and getElementType(theTarget) == "player" then 
                        if getPedOccupiedVehicle(theTarget) then 
                            setElementData(getPedOccupiedVehicle(theTarget), config.Comandos[cmd].elementGasolina, 100)  
                            sendMessageServer(thePlayer, "Veículo abastecido com sucesso!", "error")
                            if config.Comandos[cmd].Logs.ativo then 
                                sendDiscordMessage("O Staff: "..removeHex(getPlayerName(thePlayer)).." ("..(getElementData(thePlayer, "ID") or "N/A")..") abasteceu o veículo do Jogador: "..removeHex(getPlayerName(theTarget)).." ("..(getElementData(theTarget, "ID") or "N/A")..")", config.Comandos[cmd].Logs.webhook)
                            end 
                        else 
                            sendMessageServer(thePlayer, "Este jogador não está em um veículo!", "error")
                        end 
                    else    
                        sendMessageServer(thePlayer, "Jogador não encontrado!", "error")
                    end 
                else 
                    sendMessageServer(thePlayer, "SINTAX: /"..cmd.." ID", "error")
                end 
                break
            elseif i == #config.Comandos[cmd].aclsPerm then 
                sendMessageServer(thePlayer, "Você não tem permissão para executar este comando!", "error")
            end 
        end 
    end 
end)

addCommandHandler("setvida", 
function (thePlayer, cmd, id)
    if thePlayer and isElement(thePlayer) and getElementType(thePlayer) == "player" then 
        for i,v in ipairs(config.Comandos[cmd].aclsPerm) do 
            if aclGetGroup(v[1]) and isObjectInACLGroup("user."..getAccountName(getPlayerAccount(thePlayer)), aclGetGroup(v[1])) then 
                if config.Comandos[cmd].estarDePro and not getElementData(thePlayer, "onProt") then return sendMessageServer(thePlayer, "Você deve estar de /pro para executar este comando!", "info") end 
                if id and tonumber(id) then 
                    local theTarget = getPlayerFromID(id)
                    if theTarget and isElement(theTarget) and getElementType(theTarget) == "player" then 
                        sendMessageServer(thePlayer, "Vida setada com sucesso!", "success")
                        triggerEvent('JOAO.curarPlayer', thePlayer, thePlayer, theTarget)
                        if config.Comandos[cmd].Logs.ativo then 
                            sendDiscordMessage("O Staff: "..removeHex(getPlayerName(thePlayer)).." ("..(getElementData(thePlayer, "ID") or "N/A")..") recuperou a vida do Jogador: "..removeHex(getPlayerName(theTarget)).." ("..(getElementData(theTarget, "ID") or "N/A")..")", config.Comandos[cmd].Logs.webhook)
                        end 
                    else    
                        sendMessageServer(thePlayer, "Jogador não encontrado!", "error")
                    end 
                else 
                    sendMessageServer(thePlayer, "SINTAX: /"..cmd.." ID", "error")
                end 
                break
            elseif i == #config.Comandos[cmd].aclsPerm then 
                sendMessageServer(thePlayer, "Você não tem permissão para executar este comando!", "error")
            end 
        end 
    end 
end)

addCommandHandler("setcolete", 
function (thePlayer, cmd, id)
    if thePlayer and isElement(thePlayer) and getElementType(thePlayer) == "player" then 
        for i,v in ipairs(config.Comandos[cmd].aclsPerm) do 
            if aclGetGroup(v[1]) and isObjectInACLGroup("user."..getAccountName(getPlayerAccount(thePlayer)), aclGetGroup(v[1])) then 
                if config.Comandos[cmd].estarDePro and not getElementData(thePlayer, "onProt") then return sendMessageServer(thePlayer, "Você deve estar de /pro para executar este comando!", "info") end 
                if id and tonumber(id) then 
                    local theTarget = getPlayerFromID(id)
                    if theTarget and isElement(theTarget) and getElementType(theTarget) == "player" then 
                        setPedArmor(theTarget, 100)
                        sendMessageServer(thePlayer, "Colete setado com sucesso!", "success")
                        if config.Comandos[cmd].Logs.ativo then 
                            sendDiscordMessage("O Staff: "..removeHex(getPlayerName(thePlayer)).." ("..(getElementData(thePlayer, "ID") or "N/A")..") setou colete para o Jogador: "..removeHex(getPlayerName(theTarget)).." ("..(getElementData(theTarget, "ID") or "N/A")..")", config.Comandos[cmd].Logs.webhook)
                        end 
                    else    
                        sendMessageServer(thePlayer, "Jogador não encontrado!", "error")
                    end 
                else 
                    sendMessageServer(thePlayer, "SINTAX: /"..cmd.." ID", "error")
                end 
                break
            elseif i == #config.Comandos[cmd].aclsPerm then 
                sendMessageServer(thePlayer, "Você não tem permissão para executar este comando!", "error")
            end 
        end 
    end 
end)

addCommandHandler("kill", 
function (thePlayer, cmd, id)
    if thePlayer and isElement(thePlayer) and getElementType(thePlayer) == "player" then 
        for i,v in ipairs(config.Comandos[cmd].aclsPerm) do 
            if aclGetGroup(v[1]) and isObjectInACLGroup("user."..getAccountName(getPlayerAccount(thePlayer)), aclGetGroup(v[1])) then 
                if config.Comandos[cmd].estarDePro and not getElementData(thePlayer, "onProt") then return sendMessageServer(thePlayer, "Você deve estar de /pro para executar este comando!", "info") end 
                if id and tonumber(id) then 
                    local theTarget = getPlayerFromID(id)
                    if theTarget and isElement(theTarget) and getElementType(theTarget) == "player" then 
                        killPed(theTarget)
                        sendMessageServer(thePlayer, "Player morto com sucesso!", "success")
                        if config.Comandos[cmd].Logs.ativo then 
                            sendDiscordMessage("O Staff: "..removeHex(getPlayerName(thePlayer)).." ("..(getElementData(thePlayer, "ID") or "N/A")..") deu /kill no Jogador: "..removeHex(getPlayerName(theTarget)).." ("..(getElementData(theTarget, "ID") or "N/A")..")", config.Comandos[cmd].Logs.webhook)
                        end 
                    else    
                        sendMessageServer(thePlayer, "Jogador não encontrado!", "error")
                    end 
                else 
                    sendMessageServer(thePlayer, "SINTAX: /"..cmd.." ID", "error")
                end 
                break
            elseif i == #config.Comandos[cmd].aclsPerm then 
                sendMessageServer(thePlayer, "Você não tem permissão para executar este comando!", "error")
            end 
        end 
    end 
end)

addCommandHandler("pro", 
function (thePlayer, cmd)
    if thePlayer and isElement(thePlayer) and getElementType(thePlayer) == "player" then 
        for i,v in ipairs(config.Comandos[cmd].aclsPerm) do
            if aclGetGroup(v[1]) and isObjectInACLGroup("user."..getAccountName(getPlayerAccount(thePlayer)), aclGetGroup(v[1])) then 
                if getElementData(thePlayer, "onProt") then 
                    setElementData(thePlayer, "onProt", false)
                    sendMessageServer(thePlayer, "Modo pro desativado!", "info")
                    local key = getPlayerSerial(thePlayer)    
                    local hashtoKey = toJSON({type = "remove"})
                    encodeString('aes128', hashtoKey, {key = key:sub(17)}, function(enc, iv)
                        triggerClientEvent(thePlayer, "squady.onWall", resourceRoot, thePlayer, enc, iv)
                    end)
                    setElementData(thePlayer, "FS:adminDuty", nil)
                    if not isObjectInACLGroup("user."..getAccountName(getPlayerAccount(thePlayer)), aclGetGroup("Console")) then
                        triggerEvent("JOAO.setBannerScore", thePlayer, thePlayer, "nenhum", _, "Everyone")
                    end
                    triggerEvent("JOAO.alternateNickPRO", thePlayer, thePlayer, "tirar")
                    if config.Comandos[cmd].Logs.ativo then 
                        sendDiscordMessage("O Staff: "..removeHex(getPlayerName(thePlayer)).." ("..(getElementData(thePlayer, "ID") or "N/A")..") desativou o modo pro!", config.Comandos[cmd].Logs.webhook)
                    end 
                else 
                    setElementData(thePlayer, "onProt", true)
                    local playerRole = isPlayerInACLs(thePlayer, config["Roles"]["adminRoles"])
                    if playerRole then
                        setElementData(thePlayer, "FS:adminDuty", playerRole["role"])
                    end
                    local key = getPlayerSerial(thePlayer)    
                    local hashtoKey = toJSON({type = "remove"})
                    encodeString('aes128', hashtoKey, {key = key:sub(17)}, function(enc, iv)
                        triggerClientEvent(thePlayer, "squady.onWall", resourceRoot, thePlayer, enc, iv)
                    end)
                    triggerEvent("JOAO.alternateNickPRO", thePlayer, thePlayer, "colocar")
                    sendMessageServer(thePlayer, "Modo pro ativado!", "info")
                    if isObjectInACLGroup("user."..getAccountName(getPlayerAccount(thePlayer)), aclGetGroup("Console")) then
                        triggerEvent("JOAO.setBannerScore", thePlayer, thePlayer, "files/imgs/fundador.png", _, "Fundador")
                    else
                        triggerEvent("JOAO.setBannerScore", thePlayer, thePlayer, "files/imgs/staff.png", _, "STAFF")
                    end
                    if config.Comandos[cmd].Logs.ativo then 
                        sendDiscordMessage("O Staff: "..removeHex(getPlayerName(thePlayer)).." ("..(getElementData(thePlayer, "ID") or "N/A")..") ativou o modo pro!", config.Comandos[cmd].Logs.webhook)
                    end 
                end 
                break
            elseif i == #config.Comandos[cmd].aclsPerm then 
                sendMessageServer(thePlayer, "Você não tem permissão para executar este comando!", "error")
            end 
        end 
    end 
end)

addCommandHandler("puxar", 
function (thePlayer, cmd, id)
    if thePlayer and isElement(thePlayer) and getElementType(thePlayer) == "player" then 
        for i,v in ipairs(config.Comandos[cmd].aclsPerm) do 
            if aclGetGroup(v[1]) and isObjectInACLGroup("user."..getAccountName(getPlayerAccount(thePlayer)), aclGetGroup(v[1])) then 
                if config.Comandos[cmd].estarDePro and not getElementData(thePlayer, "onProt") then return sendMessageServer(thePlayer, "Você deve estar de /pro para executar este comando!", "info") end 
                if id and tonumber(id) then 
                    local theTarget = getPlayerFromID(id)
                    if theTarget and isElement(theTarget) and getElementType(theTarget) == "player" then 
                        local pX, pY, pZ = getElementPosition(thePlayer)
                        setElementDimension(theTarget, getElementDimension(thePlayer))
                        setElementInterior(theTarget, getElementInterior(thePlayer))
                        if getPedOccupiedVehicle(theTarget) then 
                            setElementPosition(getPedOccupiedVehicle(theTarget), pX, pY, pZ+3)
                        else 
                            setElementPosition(theTarget, pX, pY, pZ+3)
                        end 
                        
                        if config.Comandos[cmd].Logs.ativo then 
                            sendDiscordMessage("O Staff: "..removeHex(getPlayerName(thePlayer)).." ("..(getElementData(thePlayer, "ID") or "N/A")..") puxou o Jogador: "..removeHex(getPlayerName(theTarget)).." ("..(getElementData(theTarget, "ID") or "N/A")..")", config.Comandos[cmd].Logs.webhook)
                        end 
                        sendMessageServer(thePlayer, "Player puxado com sucesso!", "success")
                    else    
                        sendMessageServer(thePlayer, "Jogador não encontrado!", "error")
                    end 
                else 
                    sendMessageServer(thePlayer, "SINTAX: /"..cmd.." ID", "error")
                end 
                break
            elseif i == #config.Comandos[cmd].aclsPerm then 
                sendMessageServer(thePlayer, "Você não tem permissão para executar este comando!", "error")
            end 
        end 
    end 
end)

addCommandHandler("tp", 
function (thePlayer, cmd, id)
    if thePlayer and isElement(thePlayer) and getElementType(thePlayer) == "player" then 
        for i,v in ipairs(config.Comandos[cmd].aclsPerm) do 
            if aclGetGroup(v[1]) and isObjectInACLGroup("user."..getAccountName(getPlayerAccount(thePlayer)), aclGetGroup(v[1])) then 
                if config.Comandos[cmd].estarDePro and not getElementData(thePlayer, "onProt") then return sendMessageServer(thePlayer, "Você deve estar de /pro para executar este comando!", "info") end 
                if id and tonumber(id) then 
                    local theTarget = getPlayerFromID(id)
                    if theTarget and isElement(theTarget) and getElementType(theTarget) == "player" then 
                        local pX, pY, pZ = getElementPosition(theTarget)
                        setElementDimension(thePlayer, getElementDimension(theTarget))
                        setElementInterior(thePlayer, getElementInterior(theTarget))
                        setElementPosition(thePlayer, pX, pY, pZ+3)
                       
                        if config.Comandos[cmd].Logs.ativo then 
                            sendDiscordMessage("O Staff: "..removeHex(getPlayerName(thePlayer)).." ("..(getElementData(thePlayer, "ID") or "N/A")..") deu tp no Jogador: "..removeHex(getPlayerName(theTarget)).." ("..(getElementData(theTarget, "ID") or "N/A")..")", config.Comandos[cmd].Logs.webhook)
                        end 
                        sendMessageServer(thePlayer, "Você se teleportou ao player com sucesso!", "success")
                    else    
                        sendMessageServer(thePlayer, "Jogador não encontrado!", "error")
                    end 
                else 
                    sendMessageServer(thePlayer, "SINTAX: /"..cmd.." ID", "error")
                end 
                break
            elseif i == #config.Comandos[cmd].aclsPerm then 
                sendMessageServer(thePlayer, "Você não tem permissão para executar este comando!", "error")
            end 
        end 
    end 
end)

addCommandHandler("tpcarro", 
function (thePlayer, cmd, id)
    if thePlayer and isElement(thePlayer) and getElementType(thePlayer) == "player" then 
        for i,v in ipairs(config.Comandos[cmd].aclsPerm) do 
            if aclGetGroup(v[1]) and isObjectInACLGroup("user."..getAccountName(getPlayerAccount(thePlayer)), aclGetGroup(v[1])) then 
                if config.Comandos[cmd].estarDePro and not getElementData(thePlayer, "onProt") then return sendMessageServer(thePlayer, "Você deve estar de /pro para executar este comando!", "info") end 
                if id and tonumber(id) then 
                    local theTarget = getPlayerFromID(id)
                    if theTarget and isElement(theTarget) and getElementType(theTarget) == "player" then 
                        local pX, pY, pZ = getElementPosition(theTarget)
                        setElementDimension(thePlayer, getElementDimension(theTarget))
                        setElementInterior(thePlayer, getElementInterior(theTarget))
                        if getPedOccupiedVehicle(theTarget) then 
                            warpPedIntoVehicle(thePlayer, getPedOccupiedVehicle(theTarget))
                        else 
                            setElementPosition(thePlayer, pX, pY, pZ+3)
                        end 
                       
                        if config.Comandos[cmd].Logs.ativo then 
                            sendDiscordMessage("O Staff: "..removeHex(getPlayerName(thePlayer)).." ("..(getElementData(thePlayer, "ID") or "N/A")..") deu tp no Jogador: "..removeHex(getPlayerName(theTarget)).." ("..(getElementData(theTarget, "ID") or "N/A")..")", config.Comandos[cmd].Logs.webhook)
                        end 
                        sendMessageServer(thePlayer, "Você se teleportou ao player com sucesso!", "success")
                    else    
                        sendMessageServer(thePlayer, "Jogador não encontrado!", "error")
                    end 
                else 
                    sendMessageServer(thePlayer, "SINTAX: /"..cmd.." ID", "error")
                end 
                break
            elseif i == #config.Comandos[cmd].aclsPerm then 
                sendMessageServer(thePlayer, "Você não tem permissão para executar este comando!", "error")
            end 
        end 
    end 
end)

addCommandHandler("ss", 
function (thePlayer, cmd, idplayer, idskin)
    if thePlayer and isElement(thePlayer) and getElementType(thePlayer) == "player" then 
        for i,v in ipairs(config.Comandos[cmd].aclsPerm) do 
            if aclGetGroup(v[1]) and isObjectInACLGroup("user."..getAccountName(getPlayerAccount(thePlayer)), aclGetGroup(v[1])) then 
                if config.Comandos[cmd].estarDePro and not getElementData(thePlayer, "onProt") then return sendMessageServer(thePlayer, "Você deve estar de /pro para executar este comando!", "info") end 
                if idplayer and idskin then 
                    idskin = tonumber(idskin)
                    if getElementModel(thePlayer) == idskin then
                        sendMessageServer(thePlayer, "Você já está com essa skin!", "error")
                    else
                        local theTarget = getPlayerFromID(idplayer)
                        if theTarget and isElement(theTarget) and getElementType(theTarget) == "player" then 
                            if setElementModel(theTarget, idskin) then 
                                setElementModel(theTarget, idskin)
                                sendMessageServer(thePlayer, "Skin setada com sucesso!", "success")
                                if config.Comandos[cmd].Logs.ativo then 
                                    sendDiscordMessage("O Staff: "..removeHex(getPlayerName(thePlayer)).." ("..(getElementData(thePlayer, "ID") or "N/A")..") setou a skin de ID: "..idskin.."!", config.Comandos[cmd].Logs.webhook)
                                end 
                            else 
                                sendMessageServer(thePlayer, "Esta skin não existe!", "error")
                            end
                        end
                    end
                else 
                    sendMessageServer(thePlayer, "SINTAX: /"..cmd.." (ID PLAYER) (ID SKIN)", "error")
                end 
                break
            elseif i == #config.Comandos[cmd].aclsPerm then 
                sendMessageServer(thePlayer, "Você não tem permissão para executar este comando!", "error")
            end 
        end 
    end 
end)


addCommandHandler("fix", 
function (thePlayer, cmd, id)
    if thePlayer and isElement(thePlayer) and getElementType(thePlayer) == "player" then 
        for i,v in ipairs(config.Comandos[cmd].aclsPerm) do 
            if aclGetGroup(v[1]) and isObjectInACLGroup("user."..getAccountName(getPlayerAccount(thePlayer)), aclGetGroup(v[1])) then 
                if config.Comandos[cmd].estarDePro and not getElementData(thePlayer, "onProt") then return sendMessageServer(thePlayer, "Você deve estar de /pro para executar este comando!", "info") end 
                if id and tonumber(id) then 
                    local theTarget = getPlayerFromID(id)
                    if theTarget and isElement(theTarget) and getElementType(theTarget) == "player" then 
                        if getPedOccupiedVehicle(theTarget) then 
                            fixVehicle(getPedOccupiedVehicle(theTarget))
                        end 
                        if config.Comandos[cmd].Logs.ativo then 
                            sendDiscordMessage("O Staff: "..removeHex(getPlayerName(thePlayer)).." ("..(getElementData(thePlayer, "ID") or "N/A")..") deu fix no Jogador: "..removeHex(getPlayerName(theTarget)).." ("..(getElementData(theTarget, "ID") or "N/A")..")", config.Comandos[cmd].Logs.webhook)
                        end 
                        sendMessageServer(thePlayer, "Veículo reparado com sucesso!", "success")
                    else    
                        sendMessageServer(thePlayer, "Jogador não encontrado!", "error")
                    end 
                else 
                    sendMessageServer(thePlayer, "SINTAX: /"..cmd.." ID", "error")
                end 
                break
            elseif i == #config.Comandos[cmd].aclsPerm then 
                sendMessageServer(thePlayer, "Você não tem permissão para executar este comando!", "error")
            end 
        end 
    end 
end)

addCommandHandler("puxarcarro", 
function (thePlayer, cmd, id)
    if thePlayer and isElement(thePlayer) and getElementType(thePlayer) == "player" then 
        for i,v in ipairs(config.Comandos[cmd].aclsPerm) do 
            if aclGetGroup(v[1]) and isObjectInACLGroup("user."..getAccountName(getPlayerAccount(thePlayer)), aclGetGroup(v[1])) then 
                if config.Comandos[cmd].estarDePro and not getElementData(thePlayer, "onProt") then return sendMessageServer(thePlayer, "Você deve estar de /pro para executar este comando!", "info") end 
                tabelaDistancias = {}
                for indx,theVehicle in ipairs(getElementsByType("vehicle", getRootElement())) do 
                    if getDistanceBetweenPoints3D(Vector3(getElementPosition(theVehicle)), Vector3(getElementPosition(thePlayer))) <= config.Comandos[cmd].distanciaVeiculo then 
                        table.insert(tabelaDistancias, {theVehicle, getDistanceBetweenPoints3D(Vector3(getElementPosition(theVehicle)), Vector3(getElementPosition(thePlayer)))})
                    end 
                end     
                if #tabelaDistancias > 0 then 
                    table.sort(tabelaDistancias, function (a,b) return a[2] < b[2] end)
                    local destroyVehicle = tabelaDistancias[1][1]
                    if destroyVehicle and isElement(destroyVehicle) then 
                        local pX, pY, pZ = getElementPosition(thePlayer)
                        setElementPosition(destroyVehicle, pX, pY, pZ+3)
                        sendMessageServer(thePlayer, "Veículo puxado com sucesso!", "success")
                        if config.Comandos[cmd].Logs.ativo then 
                            sendDiscordMessage("O Staff: "..removeHex(getPlayerName(thePlayer)).." ("..(getElementData(thePlayer, "ID") or "N/A")..") puxou para si um veículo próximo!", config.Comandos[cmd].Logs.webhook)
                        end 
                    end 
                else 
                    sendMessageServer(thePlayer, "Não tem nenhum veículo proximo a você!", "error")
                end 
                break
            elseif i == #config.Comandos[cmd].aclsPerm then 
                sendMessageServer(thePlayer, "Você não tem permissão para executar este comando!", "error")
            end 
        end 
    end 
end)


function setFreeze(playerSource, commandName, id)
	if not getElementData(playerSource, "onProt") then 
        return 
        sendMessageServer(theTarget, "O Staff"..getPlayerName(playerSource).." Você precisa está de /pro", "info") 
    end 
    if (id) then
		local playerID = tonumber(id)
        local theTarget = getPlayerFromID(id)
		if (theTarget) then
			if isElementFrozen(theTarget) then
				setElementFrozen(theTarget, false)
				toggleAllControls(theTarget, true)
                sendMessageServer(playerSource, "Você descongelou o jogador: "..getPlayerName(theTarget).." !", "info")
				sendMessageServer(theTarget, "O Staff"..getPlayerName(playerSource).." te descongelou", "info")
				sendDiscordMessage('O Staff '..getPlayerName(playerSource)..' ('..(getElementData(playerSource, 'ID') or 'N/A')..') Descongelou o jogador:  '..getPlayerName(theTarget)..'  ('..(getElementData(theTarget, 'ID') or 'N/A')..')', config.Comandos[commandName].Logs.webhook)
			else
                sendMessageServer(playerSource, "Você congelou o jogador: "..getPlayerName(theTarget).." !", "info")
				setElementFrozen(theTarget, true)
				toggleAllControls(theTarget, false)
				sendMessageServer(theTarget, "O Staff"..getPlayerName(playerSource).." te congelou", "info")
				sendDiscordMessage('O Staff '..getPlayerName(playerSource)..' ('..(getElementData(playerSource, 'ID') or 'N/A')..') Congelou o jogador:  '..getPlayerName(theTarget)..'  ('..(getElementData(theTarget, 'ID') or 'N/A')..')', config.Comandos[commandName].Logs.webhook)
			end
		else
			sendMessageServer(playerSource, "ID informado inválido", "error")
		end
	else
		sendMessageServer(playerSource, "Insira o ID do jogador desejado", "error")
	end
end
addCommandHandler("congelar", setFreeze)

addCommandHandler("fixproximo",
function (thePlayer, cmd)
    if thePlayer and isElement(thePlayer) and getElementType(thePlayer) == "player" then
        for i,v in ipairs(config.Comandos[cmd].aclsPerm) do
            if aclGetGroup(v[1]) and isObjectInACLGroup("user."..getAccountName(getPlayerAccount(thePlayer)), aclGetGroup(v[1])) then
                if config.Comandos[cmd].estarDePro and not getElementData(thePlayer, "onProt") then return sendMessageServer(thePlayer, "Você deve estar de /pro para executar este comando!", "info") end
                local tabelaDistancias = {}
                for indx,theVehicle in ipairs(getElementsByType("vehicle", getRootElement())) do
                    if getDistanceBetweenPoints3D(Vector3(getElementPosition(theVehicle)), Vector3(getElementPosition(thePlayer))) <= config.Comandos[cmd].distanciaVeiculo then
                        table.insert(tabelaDistancias, {theVehicle, getDistanceBetweenPoints3D(Vector3(getElementPosition(theVehicle)), Vector3(getElementPosition(thePlayer)))})
                    end
                end
                if #tabelaDistancias > 0 then
                    table.sort(tabelaDistancias, function (a,b) return a[2] < b[2] end)
                    local nearestVehicle = tabelaDistancias[1][1]
                    if nearestVehicle and isElement(nearestVehicle) and getElementType(nearestVehicle) == "vehicle" then
                        fixVehicle(nearestVehicle)
                        setVehicleEngineState(nearestVehicle, false)
                        sendMessageServer(thePlayer, "Você consertou o veículo mais próximo!", "success")
                    end
                else
                    sendMessageServer(thePlayer, "Não tem nenhum veículo próximo a você!", "error")
                end
                break
            elseif i == #config.Comandos[cmd].aclsPerm then
                sendMessageServer(thePlayer, "Você não tem permissão para executar este comando!", "error")
            end
        end
    end
end)

sendMessageServer = function (thePlayer, message, type)
    return exports['guetto_notify']:showInfobox(thePlayer, type, message)
end

function getPlayerFromID(id)
    id = tonumber(id)
    if id then 
        for i,thePlayer in ipairs(getElementsByType("player")) do 
            if thePlayer and isElement(thePlayer) and getElementType(thePlayer) == "player" then 
                local theID = getElementData(thePlayer, "ID") or "N/A"
                if tonumber(theID) and tonumber(theID) == id then 
                    return thePlayer
                end 
            end 
        end 
    end 
end

function isPlayerInACLs(player, table)
    local playerRole
    if player and isElement(player) and (getElementType(player) == "player") then

        if isGuestAccount(getPlayerAccount(player)) then
            return false
        end

        local accName = getAccountName(getPlayerAccount(player))
        for i = 1, #table do
            if aclGetGroup(table[i]["acl"]) and isObjectInACLGroup("user." ..accName, aclGetGroup(table[i]["acl"])) then 
                playerRole = table[i]
                break
            end
        end

    end
    return playerRole
end

function sendDiscordMessage(message, theWebhook)
	sendOptions = {
		queueName = "dcq",
		connectionAttempts = 3,
		connectTimeout = 5000,
		formFields = {
		  content="```"..message.."```"
		},
	}   
		fetchRemote(theWebhook, sendOptions, function()end)
end 


addCommandHandler('desfrezartodos', function(player)
    if aclGetGroup('Staff') and isObjectInACLGroup("user." ..getAccountName(getPlayerAccount(player)), aclGetGroup('Staff')) then 
        for i, v in ipairs ( getElementsByType('player')) do 
            setPedAnimation(v)
            setElementFrozen(v, false)
            setElementHealth(v, 100)
        end
    end
end)

addCommandHandler('setlevel',
    function ( player, cmd, id, qnt )
        if aclGetGroup('Console') and isObjectInACLGroup("user." ..getAccountName(getPlayerAccount(player)), aclGetGroup('Console')) then 
            if not id then return sendMessageServer(player, 'Digite o id!', 'error') end
            local target = getPlayerFromID(tonumber(id))
            if not target then return sendMessageServer(player, 'Jogador não encontrado!', 'error') end 
            if not qnt then return sendMessageServer(player, 'Digite a quantidade!', 'error') end 
            setElementData(target, 'Level', tonumber(qnt))
            sendMessageServer(player, 'Você setou level com sucesso!', 'info')
        end
    end
)