local animTimer = {}
local phone = {}
local TimerCall = {}
local TimerMedic = {}


chamado = {}
typeChamado = {}

function registerEvent (event, ...)
	addEvent(event, true)
	addEventHandler(event, ...)
end

function getPlayerFromCall(id) 
	if tonumber(id) then 
		for i, player in ipairs(getElementsByType('player')) do 
			if player ~= source then 
				if (getElementData(player, 'Call') or false) ~= false then 
					if getElementData(player, 'Call') == tonumber(id) then 
						return player
					end
				end
			end
		end
	end
	return false
end

registerEvent('SD > onCallSystem:execute', root, function ( player )
	if player and isElement(player) then 
		if not chamado[player] or (chamado[player] == false) then
			local tipo = 'SAMU'
            outputChatBox('#8d6af0[GCRP] #FFFFFFVocê chamou um '..tipo..'.', player, 255, 255, 255, true)
            messageToPlayers('#8d6af0[GCRP] #FFFFFFO jogador '..getPlayerName(player)..' chamou '..tipo..'.\n#8d6af0[GCRP] #FFFFFFUtilize /aceitar '..(getElementData(player, 'ID') or 'N/A'), tipo)
            chamado[player] = true
			typeChamado[player] = tipo
            setTimer(function(player)
                if isElement(player) then
                    if chamado[player] then
                        chamado[player] = false
                        outputChatBox('#8d6af0[GCRP] #FFFFFFVocê já pode chamar outro '..tipo..'.', player, 255, 255, 255, true)
                    end
                end
            end, 4 * 60000, 1, player)
        end
	end
end)

function getPlayerReceiver(receiver) 
	for i, player in ipairs(getElementsByType('player')) do 
		if player ~= receiver then 
			if (getElementData(player, 'Recebendo') or false) ~= false then 
				if getElementData(player, 'Recebendo') == receiver then 
					return player
				end
			end
		end
	end
	return false
end

addEventHandler('onResourceStart', getResourceRootElement(getThisResource()),
	function ()
		connection = dbConnect('sqlite', 'celular.sqlite')
		dbExec(connection, 'create table if not exists celular (conta, wallpaper, settings)')	
		dbExec(connection, 'create table if not exists contatos (conta, id, nome)')
		dbExec(connection, "create table if not exists datas(login, credits)")	
		dbExec(connection, 'create table if not exists notes(login, title, nota)')	

		for _, player in ipairs(getElementsByType('player')) do
			if not isGuestAccount(getPlayerAccount(player)) then
				bindKey(player, config.tecla[1], config.tecla[2], openCelular)
			end
		end

		for _, player in ipairs(getElementsByType('player')) do 
			removeElementData(player, 'Call') 
			removeElementData(player, 'Recebendo')
		end
	end
)

addEventHandler('onPlayerLogin', root,
	function (_, account)
		bindKey(source, config.tecla[1], config.tecla[2], openCelular)
		local data = dbPoll(dbQuery(connection, 'select * from celular where conta = ?', getAccountName(account)), - 1)
		if (#data ~= 0) then
			local settings = fromJSON(data[1]['settings'])
			if settings then
				setElementData(source, 'Ligação', settings[1])
				setElementData(source, 'Ligação de estranhos', settings[2])
				setElementData(source, 'Mensagens', settings[3])
				setElementData(source, 'Mensagens de estranhos', settings[4])
			end
		end

		local result = dbPoll(dbQuery(connection,"SELECT * FROM datas WHERE login=?", getAccountName(getPlayerAccount(source))), -1) 
        if #result > 0 then 
            for i, dado in ipairs(result) do 
                setElementData(source, "Mbs", dado["credits"])
            end
        end
	end
) 

addEventHandler('onPlayerQuit', root,
	function ()
		if not isGuestAccount(getPlayerAccount(source)) then
			local result = dbPoll(dbQuery(connection, 'select * from celular where conta = ?', getAccountName(getPlayerAccount(source))), - 1)
			if (#result ~= 0) then
				dbExec(connection, 'update celular set settings = ? where conta = ?', toJSON({(getElementData(source, 'Ligação') or 'sim'), (getElementData(source, 'Ligação de estranhos') or 'sim'), (getElementData(source, 'Mensagens') or 'sim'), (getElementData(source, 'Mensagens de estranhos') or 'sim')}), getAccountName(getPlayerAccount(source)))
			else
				dbExec(connection, 'insert into celular (conta, wallpaper, settings) values(?, ?, ?)', getAccountName(getPlayerAccount(source)), 2, toJSON({(getElementData(source, 'Ligação') or 'sim'), (getElementData(source, 'Ligação de estranhos') or 'sim'), (getElementData(source, 'Mensagens') or 'sim'), (getElementData(source, 'Mensagens de estranhos') or 'sim')}))
			end

			local result = dbPoll(dbQuery(connection,"SELECT * FROM datas WHERE login=?", getAccountName(getPlayerAccount(source))), -1)  
        	if #result > 0 then 
        	    dbExec(connection,"UPDATE datas SET credits=? WHERE login=?", (getElementData(source, "Mbs") or 0), getAccountName(getPlayerAccount(source)))
        	else 
        	    dbExec(connection,"INSERT INTO datas (login , credits) VALUES(?, ?)", getAccountName(getPlayerAccount(source)), (getElementData(source, "Mbs") or 0))
        	end
		end

		removePhone(source)
		if isTimer(TimerCall[source]) then killTimer(TimerCall[source]) end 
		if (getElementData(source, 'Call') or false) ~= false then 
			local receiver = getPlayerFromCall(getElementData(source, 'Call'))
			if isElement(receiver) then 
				setElementData(receiver, 'Recebendo', false)
				triggerClientEvent(receiver, 'Pedro.changeWindowCell', receiver, 'inicio')
				setElementData(receiver, 'Call', false)
			end
		end
	end
)

addEventHandler('onPlayerWasted', root, function()
	triggerClientEvent(source, 'Pedro.destroySound', source)
	if (getElementData(source, 'Call') or false) ~= false then 
		local receiver = getPlayerFromCall(getElementData(source, 'Call'))
		if isElement(receiver) then 
			setElementData(receiver, 'Recebendo', false)
			triggerClientEvent(receiver, 'Pedro.changeWindowCell', receiver, 'inicio')
			setElementData(receiver, 'Call', false)
		end
	end
	
	removePhone(source)
	if isTimer(TimerCall[source]) then killTimer(TimerCall[source]) end 
	setElementData(source, 'Call', false)
	setElementData(source, 'Recebendo', false)
	triggerClientEvent(source, 'Pedro.changeWindowCell', source, 'inicio')
end)

function openCelular (player)
	if (getElementData(player, 'FS:interaction')) then 
		return 
	end
	if not isElement(phone[player]) then
		local result = dbPoll(dbQuery(connection, 'select * from celular where conta = ?', getAccountName(getPlayerAccount(player))), - 1)
		if (#result ~= 0) then
			triggerClientEvent(player, 'Caio.onOpenCelular', player, result[1]['wallpaper'], 'add')
		else
			triggerClientEvent(player, 'Caio.onOpenCelular', player, 1, 'add')
		end
		local data = dbPoll(dbQuery(connection, 'select * from contatos where conta = ?', getAccountName(getPlayerAccount(player))), - 1)
		if (#data ~= 0) then
			for i, v in ipairs(data) do
				triggerClientEvent(player, 'Caio.onInsertTable', player, v['nome'], v['id'])
			end
		end
	else
		triggerClientEvent(player, 'Caio.onOpenCelular', player, 1, 'remove')
	end
end

function isContatoExists (player, id)
	local data = dbPoll(dbQuery(connection, 'select * from contatos where conta = ?', getAccountName(getPlayerAccount(player))), - 1)
	if (#data ~= 0) and (type(data) == 'table') then
		for i, v in ipairs(data) do
			if (tonumber(v['id']) == id) then
				return true
			end
		end
	end
	return false
end

function isContatoExistsName (player, name)
	local data = dbPoll(dbQuery(connection, 'select * from contatos where conta = ?', getAccountName(getPlayerAccount(player))), - 1)
	if (#data ~= 0) and (type(data) == 'table') then
		for i, v in ipairs(data) do
			if (v['nome'] == name) then
				return true
			end
		end
	end
	return false
end

function isMaxContatos (player)
	local data = dbPoll(dbQuery(connection, 'select * from contatos where conta = ?', getAccountName(getPlayerAccount(player))), - 1)
	if (#data >= tonumber(config.maxContatos)) then
		return true
	end
	return false
end

function removePhone(player)
	if isElement(phone[player]) then
		destroyElement(phone[player])
	end
	if (animTimer[player]) then
		killTimer(animTimer[player])
		animTimer[player] = nil
	end
	setPedAnimation(player)
end

registerEvent('Caio.onAdicionarContato', root,
	
	function (id, contato)

		if not client then
			return
		end

		local player = client

		if id and contato then

			if isContatoExists(player, id) then
				return config.notify_server(player, 'Você já possui este contato adicionado.', 'error')
			end

			if isContatoExistsName(player, contato) then
				return config.notify_server(player, 'Você já possui um contato com este nome.', 'error')
			end

			if isMaxContatos(player) then
				return config.notify_server(player, 'Você já possui o número máximo de contatos.', 'error')
			end

			if id == getElementData(player, 'ID') then
				return config.notify_server(player, 'Você não pode adicionar seu próprio número.', 'error')
			end
			
			dbExec(connection, 'insert into contatos (conta, id, nome) values(?, ?, ?)', getAccountName(getPlayerAccount(player)), id, contato)
			config.notify_server(player, 'Você adicionou o contato '..contato..'.', 'success')
			triggerClientEvent(player, 'Caio.onInsertTable', player, contato, id)

		end

	end

)

registerEvent('Caio.onDeleteContato', root,
	function (id)

		if not client then
			return
		end

		local player = client

		if (id) then
			local data = dbPoll(dbQuery(connection, 'select * from contatos where conta = ? and id = ?', getAccountName(getPlayerAccount(player)), id), - 1)
			if (#data ~= 0) then
				dbExec(connection, 'delete from contatos where conta = ? and id = ?', getAccountName(getPlayerAccount(player)), id)
			end
		end
	end
)

registerEvent('Caio.onSetNewWallpaper', root,
	function (wallpaper)
		if not client then
			return
		end

		local player = client

		local result = dbPoll(dbQuery(connection, 'select * from celular where conta = ?', getAccountName(getPlayerAccount(player))), - 1)
		if (#result ~= 0) then
			dbExec(connection, 'update celular set wallpaper = ? where conta = ?', tonumber(wallpaper), getAccountName(getPlayerAccount(player)))
		else
			dbExec(connection, 'insert into celular (conta, wallpaper, settings) values(?, ?, ?)', getAccountName(getPlayerAccount(player)), tonumber(wallpaper), toJSON({(getElementData(player, 'Ligação') or 'sim'), (getElementData(player, 'Ligação de estranhos') or 'sim'), (getElementData(player, 'Mensagens') or 'sim'), (getElementData(player, 'Mensagens de estranhos') or 'sim')}))
		end
		config.notify_server(player, 'Você alterou seu wallpaper com sucesso.', 'success')
	end
)

registerEvent('Goiaba.setAnimationPhone', resourceRoot, 
	function(value)
		if not client then
			return
		end

		local player = client

		if player and isElement(player) then
				
			if value then
				if (value == 1) then
					setPedWeaponSlot(player, 0)
					if isElement(phone[player]) then
						destroyElement(phone[player])
					end
					phone[player] = createObject(330, 0, 0, 0, 0, 0, 0)
					setObjectScale(phone[player], 1.5)
					exports.bone_attach:attachElementToBone(phone[player], player, 12, 0, 0.01, 0.03, -15, 270, -15)
					setPedAnimation(player, 'ped','phone_in', 1000, false, false, false, true)
					animTimer[player] = setTimer(function(player)
						if isElement(player) then
							setPedAnimationProgress(player, 'phone_in', 0.8)
						end
					end, 500, 0, player)
				elseif (value == 2) then
					removePhone(player)
					setPedAnimation(player, 'ped', 'phone_out', 50, false, false, false, false)
				end
			end
		end
	end
)

local BlipLoc = {} local TimerLoc = {} local delayLoc = {}
registerEvent('Pedro.enviarLocalização', root, 
	function(id)
		if not client then
			return
		end

		local player = client

		if tonumber(id) then 
			local receiver = getPlayerFromID(tonumber(id))
			if isElement(receiver) then 
				if isTimer(delayLoc[player]) then
					config.notify_server(player, 'Você já enviou a localização recentemente.', 'info')
					return
				end
				if isTimer(TimerLoc[player]) then killTimer(TimerLoc[player]) end 
				if isElement(BlipLoc[player]) then destroyElement(BlipLoc[player]) end
				
				BlipLoc[player] = createBlipAttachedTo(player, config.blipLocID)
				setElementVisibleTo(BlipLoc[player], root, false)	
				setElementVisibleTo(BlipLoc[player], receiver, true)

				TimerLoc[player] = setTimer(function(player)
					if isElement(BlipLoc[player]) then destroyElement(BlipLoc[player]) end
				end, config.tempoLoc, 1, player)
				config.notify_server(player, 'Localização enviada com sucesso.', 'success')
				config.notify_server(receiver, 'Você recebeu a localização do jogador.', 'success')
				delayLoc[player] = setTimer(function () end, 60000, 1)
			else 
				config.notify_server(player, 'Indivíduo não está na cidade.', 'info')
			end
		else 
			config.notify_server(player, 'Digite um id para prosseguir.', 'info')
		end 
	end
)

local coolDown = {}

registerEvent('Caio.onEnviar', resourceRoot,
    function (id, amount)

		if not (client or (source ~= resourceRoot)) then 
			return false 
		end

		local player = client
        local receiver = getPlayerFromID(tonumber(id))

		if not (getElementData(client, "onPlayerMoneyClick") or false) then 
			return addBan(getPlayerIP(client), _, _, getPlayerSerial(client), "PEGASUS AC", "You are banned by PEGASUS AC!", 0)
		end;

		if (coolDown[player] and getTickCount() - coolDown[player] <= 60000) then 
			config.notify_server(player, 'Aguarde antes de enviar novamente.', 'info')
			return false
		else
			if not (coolDown[player]) then 
				coolDown[player] = getTickCount()
			else
				coolDown[player] = getTickCount()
			end
	
			if tonumber(amount) then
				if isElement(receiver) then
					local senderID = getElementData(player, 'ID')
					local receiverID = getElementData(receiver, 'ID')
					if senderID and receiverID and senderID == receiverID then
						config.notify_server(player, 'Você não pode enviar dinheiro para si mesmo.', 'info')
						return
					end
	
					if tonumber(amount) <= 0 then
						config.notify_server(player, 'Você deve enviar dinheiro com valor positivo ou maior que 0', 'info')
						return
					end
					
					if (getPlayerMoney(player) >= tonumber(amount)) then
	
						for i,v in ipairs(getElementsByType('player')) do
							if getElementData(v, 'onProt') then
								outputChatBox('#8d6af0[GCRP] #FFFFFFO jogador '..getPlayerName(player)..' ('..senderID..') enviou R$ '..config.convertNumber(amount)..' para #ffffff'..getPlayerName(receiver)..'#ffffff ('..receiverID..')', v, 255, 255, 255, true)
							end
						end
	
						takePlayerMoney(player, tonumber(amount))
						givePlayerMoney(receiver, tonumber(amount))
						config.notify_server(player, 'Você enviou R$ '..config.convertNumber(amount)..' para '..getPlayerName(receiver)..'.', 'info')
						config.notify_server(receiver, 'Você recebeu R$ '..config.convertNumber(amount)..' de '..getPlayerName(player)..'.', 'info')
						messageDiscord("O jogador(a) "..getPlayerName(player).."("..(senderID or 'N/A')..") transferiu R$ "..config.convertNumber(amount)..",00 para "..getPlayerName(receiver).."("..(receiverID or 'N/A')..")!", "https://discord.com/api/webhooks/1198373222404595854/9kLXkOvNsruJjYM3vCeadiYdJVjZE2WSFlK9Fi2WXlI67RIebI1W4quwE-9g5QUsH-T_")
						setElementData(client, "onPlayerMoneyClick", false)
					else
						config.notify_server(player, 'Você não possui dinheiro suficiente.', 'info')
					end
				else
					config.notify_server(player, 'Este ID não está online.', 'info')
				end
			else
				config.notify_server(player, 'Você precisa digitar um número.', 'info')
			end
		end
    end
)

registerEvent('Pedro.ligar', root, function(id)
	if not client then
		return
	end

	local player = client

	if tonumber(id) then 
		local receiver = getPlayerFromID(tonumber(id)) 
		if isElement(receiver) then
			if receiver == player then 
				return config.notify_server(player, 'Você não pode ligar para você mesmo.', 'info') 
			end
			
			if (getElementData(receiver, 'Recebendo') or false) == false then 
				if (getElementData(receiver, 'Call') or false) == false then 
					if (getElementData(receiver, 'Ligação') or 'sim') == 'sim' then
						if (getElementData(receiver, 'Ligação de estranhos') or 'sim') == 'não' then
							if not isContatoExists(receiver, getElementData(player, 'ID')) then
								return config.notify_server(player, 'Este jogador está com a ligação de estranhos desativada.', 'info')
							end
						end
						
						if not isElement(phone[receiver]) then
							openCelular(receiver)
						end
						
						triggerClientEvent(player, 'Pedro.changeWindowCell', player, 'Chamando', (getElementData(receiver, 'Avatar') or 0))
						triggerClientEvent(player, 'Pedro.tocarSom', player, 'Files/Sons/chamando.mp3')
						triggerClientEvent(receiver, 'Pedro.changeWindowCell', receiver, 'Recebendo', (getElementData(player, 'Avatar') or 0))
						triggerClientEvent(receiver, 'Pedro.tocarSom', receiver, 'Files/Sons/recebendo_ligacao.mp3')
						
						setElementData(receiver, 'Recebendo', player)
						setElementData(player, 'Call', id)
						
						if isTimer(TimerCall[player]) then 
							killTimer(TimerCall[player]) 
						end 
						
						TimerCall[player] = setTimer(function(player, receiver)
							if isElement(player) then 
								removeElementData(player, 'Call')
								triggerClientEvent(player, 'Pedro.changeWindowCell', player, 'inicio')
								triggerClientEvent(player, 'Pedro.destroySound', player)
							end
							
							if isElement(receiver) then 
								removeElementData(receiver, 'Recebendo')
								removeElementData(receiver, 'Call')
								triggerClientEvent(receiver, 'Pedro.destroySound', receiver)
							end
						end, 30000, 1, player, receiver)
					else
						config.notify_server(player, 'Este jogador está com a ligação desativada.', 'info')
					end
				else 
					config.notify_server(player, 'Indivíduo está em uma chamada.', 'info')
				end
			else 
				config.notify_server(player, 'Indivíduo está recebendo uma chamada.', 'info')
			end
		else 
			config.notify_server(player, 'Indivíduo não está na cidade.', 'info')
		end
	else 
		config.notify_server(player, 'Digite um número válido.', 'info')
	end
end)

registerEvent('Pedro.atender', root, 
    function()
		if not client then
			return
		end

		local player = client

        if (getElementData(player, 'Recebendo') or false) ~= false then 
			local receiver = getElementData(player, 'Recebendo')
			if isElement(receiver) then 
           		if isTimer(TimerCall[receiver]) then killTimer(TimerCall[receiver]) end
           		setElementData(player, 'Call', (getElementData(player, 'ID') or 'N/A'))
				triggerClientEvent(player, 'Pedro.changeWindowCell', player, 'Ligação', (getElementData(receiver, 'Avatar') or 0))
				triggerClientEvent(receiver, 'Pedro.changeWindowCell', receiver, 'Ligação', (getElementData(player, 'Avatar') or 0))
				triggerClientEvent(receiver, 'Pedro.destroySound', receiver)
           		setElementData(player, 'Recebendo', false)
				triggerClientEvent(player, 'Pedro.destroySound', player)
				setElementData(receiver, 'Mbs', (getElementData(receiver, 'Mbs') or 0) - 5)
				setElementData(player, 'Mbs', (getElementData(player, 'Mbs') or 0) - 5)
				return 
			end
			removeElementData(player, 'Call')
			removeElementData(player, 'Recebendo')
			triggerClientEvent(player, 'Pedro.changeWindowCell', player, 'inicio')
			triggerClientEvent(player, 'Pedro.destroySound', player)
        end
    end
)

registerEvent('Pedro.recusar', root, 
    function()
		if not client then
			return
		end

		local player = client

        if (getElementData(player, 'Recebendo') or false) ~= false then 
            if isTimer(TimerCall[player]) then killTimer(TimerCall[player]) end
            setElementData(player, 'Call', false)
            local receiver = (getElementData(player, 'Recebendo'))
            if isElement(receiver) then 
                setElementData(receiver, 'Call', false)
                triggerClientEvent(receiver, 'Pedro.changeWindowCell', receiver, 'inicio')
				triggerClientEvent(receiver, 'Pedro.destroySound', receiver)
				config.notify_server(receiver, 'Chamada encerrada', 'info')
            end

			config.notify_server(player, 'Chamada encerrada', 'info')
            setElementData(player, 'Recebendo', false)
            triggerClientEvent(player, 'Pedro.changeWindowCell', player, 'inicio')
			triggerClientEvent(player, 'Pedro.destroySound', player)
        end
    end
)

registerEvent('Pedro.encerrar', root, 
    function()
		if not client then
			return
		end

		local player = client

        if (getElementData(player, 'Call') or false) ~= false then 
			local receiver = getPlayerFromCall(getElementData(source, 'Call'))
			if isElement(receiver) then
				setElementData(receiver, 'Recebendo', false)
				triggerClientEvent(receiver, 'Pedro.changeWindowCell', receiver, 'inicio')
				setElementData(receiver, 'Call', false)
				triggerClientEvent(receiver, 'Pedro.destroySound', receiver)
			else 
				local receiver = getPlayerReceiver(player)
				if isElement(receiver) then 
					setElementData(receiver, 'Recebendo', false)
					triggerClientEvent(receiver, 'Pedro.changeWindowCell', receiver, 'inicio')
					setElementData(receiver, 'Call', false)
					triggerClientEvent(receiver, 'Pedro.destroySound', receiver)
				end
			end

			if isTimer(TimerCall[player]) then killTimer(TimerCall[player]) end
            setElementData(player, 'Call', false)
            setElementData(player, 'Recebendo', false)
            triggerClientEvent(player, 'Pedro.changeWindowCell', player, 'inicio')
			triggerClientEvent(player, 'Pedro.destroySound', player)
			config.notify_server(player, 'Chamada encerrada', 'info')
        end
    end
)

registerEvent('Goiaba.onSendMessage', root, 
	function(id, message)

		if not client then
			return
		end

		local player = client

		if tonumber(id) then 
			if message then 
				local receiver = getPlayerFromID(tonumber(id))
				if isElement(receiver) then 
					if (getElementData(receiver, 'Mensagens') or 'sim') == 'não' then 
						return config.notify_server(player, 'Individuo não esta aceitando mensagens.', 'info')
					end

					if (getElementData(receiver, 'Mensagens de estranhos') or 'sim') == 'não' then 
						if (isContatoExists(receiver, getElementData(player, 'ID')) == false) then
							return config.notify_server(player, 'Individuo não esta aceitando mensagens de estranhos.', 'info')
						end
					end

					triggerClientEvent(player, 'Pedro.insertMessage', player, getPlayerName(receiver) ..getPlayerName(player), message, 'enviado', (getElementData(receiver, 'Avatar') or 0), getPlayerName(receiver), id)
					triggerClientEvent(receiver, 'Pedro.insertMessage', receiver,  getPlayerName(player) ..getPlayerName(receiver), message, 'recebido', (getElementData(player, 'Avatar') or 0), getPlayerName(player), (getElementData(player, 'ID') or false))
					config.notify_server(player, 'Mensagem enviada.', 'info')
					config.notify_server(receiver, 'Mensagem recebida do individuo '..getPlayerName(player)..'.', 'info')
				else 
					config.notify_server(player, 'Individuo não esta presente', 'info')
				end
			end
		end
	end
)

registerEvent('Pedro.addNote', root, 
	function(title, note)
		if not client then
			return
		end

		local player = client

		local result = dbPoll(dbQuery(connection, 'Select * from notes Where login = ? and title = ?', getAccountName(getPlayerAccount(player)), title), - 1)
		if #result == 0 then 
			if note ~= '' then 
				dbExec(connection, 'Insert into Notes(login, title, nota) Values(?, ?, ?)', getAccountName(getPlayerAccount(player)), title, note)
				config.notify_server(player, 'Nota registrada', 'info')
			else 
				config.notify_server(player, 'Digite algo na nota', 'info')
			end
		else
			config.notify_server(player, 'Você já tem uma nota com esse titulo!!!', 'info')
		end
	end
)

registerEvent('Pedro.removeNote', root, 
	function(title)
		if not client then
			return
		end

		local player = client

		local result = dbPoll(dbQuery(connection, 'Select * from notes Where login = ? and title = ?', getAccountName(getPlayerAccount(player)), title), - 1)
		if #result ~= 0 then 
			dbExec(connection, 'Delete from Notes where login = ? and title = ?', getAccountName(getPlayerAccount(player)), title)
			config.notify_server(player, 'Nota apagada.', 'info')
		else
			config.notify_server(player, 'Essa nota não existe', 'info')
		end
	end
)

registerEvent('Pedro.makeNotes', root, 
	function()
		if not client then
			return
		end

		local player = client

		local result = dbPoll(dbQuery(connection, 'Select * from notes Where login = ?', getAccountName(getPlayerAccount(player))), - 1)
		if #result ~= 0 then
			for i, v in ipairs(result) do 
				triggerClientEvent(player, 'Pedro.makeNotesC', player, v['title'], v['nota'])
			end	
		end
	end
)
-----=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-----


registerEvent('Caio.onChamarOcorrencia', root,
    function(tipo)
		if not client then 
			return
		end

		local player = client

        if not chamado[player] or (chamado[player] == false) then
			if tipo == 'Policial' then
				outputChatBox('#8d6af0[GCRP] #FFFFFFVocê chamou um '..tipo..'.', player, 255, 255, 255, true)
				messageToPlayers('#8d6af0[GCRP] #FFFFFFO jogador '..getPlayerName(player)..' chamou '..tipo..'.\n#8d6af0[GCRP] #FFFFFFUtilize /aceitar '..(getElementData(player, 'ID') or 'N/A'), tipo)
				chamado[player] = true
				typeChamado[player] = tipo
				setTimer(function(player)
					if isElement(player) then
						if chamado[player] then
							chamado[player] = false
							outputChatBox('#8d6af0[GCRP] #FFFFFFVocê já pode chamar outro '..tipo..'.', player, 255, 255, 255, true)
						end
                    end
				end, 4 * 60000, 1, player)
			elseif tipo == 'MEC' then
				triggerEvent('mechanic:call', player)
            end
        end
    end
)

blipsS = {}

addCommandHandler('aceitar',
    function(player, _, id)
        if (id) then
            local receiver = getPlayerFromID(tonumber(id))
            if (receiver) then
				if typeChamado[receiver] and isObjectInACLGroup('user.'..getAccountName(getPlayerAccount(player)), aclGetGroup(typeChamado[receiver])) then
                    if chamado[receiver] or (chamado[receiver] == true) then
                        chamado[receiver] = false
						if (typeChamado[receiver] == 'STAFF') then
                        	local pos = {getElementPosition(receiver)}
                        	setElementPosition(player, pos[1] + 1, pos[2], pos[3])
                        else
							blipsS[receiver] = createBlipAttachedTo(receiver, 41)
							setElementVisibleTo(blipsS[receiver], root, false)
							setElementVisibleTo(blipsS[receiver], player, true)
							setTimer(function(blip)
								if isElement(blip) then
									destroyElement(blip)
								end
							end, 3*60000, 1, blipsS[receiver])
						end
						outputChatBox('#8d6af0[GCRP] #FFFFFFO '..typeChamado[receiver]..' '..getPlayerName(player)..' aceitou seu chamado.', receiver, 255, 255, 255, true)
                        outputChatBox('#8d6af0[GCRP] #FFFFFFVocê aceitou o chamado do jogador '..getPlayerName(receiver)..'.', player, 255, 255, 255, true)
                    else
                        outputChatBox('#8d6af0[GCRP] #FFFFFFO jogador '..getPlayerName(receiver)..' não chamou '..typeChamado[receiver]..'.', player, 255, 255, 255, true)
                    end
                else
                    outputChatBox('#8d6af0[GCRP] #FFFFFFEste jogador não existe.', player, 255, 255, 255, true)
                end
            else
                outputChatBox('#8d6af0[GCRP] #FFFFFFDigite o ID do jogador.', player, 255, 255, 255, true)
            end
        end
    end     
)

function messageToPlayers (message, acl)
    if (message) then
        for i, v in ipairs(getElementsByType('player')) do
            if not isGuestAccount(getPlayerAccount(v)) then
                if aclGetGroup(acl) and isObjectInACLGroup('user.'.. getAccountName(getPlayerAccount(v)), aclGetGroup(acl)) then
                    outputChatBox(message, v, 255, 255, 255, true)
                end
            end
        end
    end
end

function getPlayerFromID (id)
    if (id) then
        for i, v in ipairs(getElementsByType('player')) do
            if not isGuestAccount(getPlayerAccount(v)) then
                if (getElementData(v, 'ID') or 'N/A') == tonumber(id) then
                    return v
                end
            end
        end
    end
    return false
end

local tableAccents = {["à"] = "a",["á"] = "a",["â"] = "a",["ã"] = "a",["ä"] = "a",["ç"] = "c",["è"] = "e",["é"] = "e",["ê"] = "e",["ë"] = "e",["ì"] = "i",["í"] = "i",["î"] = "i",["ï"] = "i",["ñ"] = "n",["ò"] = "o",["ó"] = "o", ["ô"] = "o",["õ"] = "o",["ö"] = "o",["ù"] = "u",["ú"] = "u",["û"] = "u",["ü"] = "u",["ý"] = "y",["ÿ"] = "y",["À"] = "A",["Á"] = "A",["Â"] = "A",["Ã"] = "A",["Ä"] = "A",["Ç"] = "C",["È"] = "E",["É"] = "E",["Ê"] = "E",["Ë"] = "E",["Ì"] = "I",["Í"] = "I",["Î"] = "I",["Ï"] = "I",["Ñ"] = "N",["Ò"] = "O",["Ó"] = "O",["Ô"] = "O",["Õ"] = "O",["Ö"] = "O",["Ù"] = "U",["Ú"] = "U",["Û"] = "U",["Ü"] = "U",["Ý"] = "Y"}
function removeAccents(str)
	local noAccentsStr = ""
	for strChar in string.gfind(str, "([%z\1-\127\194-\244][\128-\191]*)") do
		if (tableAccents[strChar] ~= nil) then
			noAccentsStr = noAccentsStr..tableAccents[strChar]
		else
			noAccentsStr = noAccentsStr..strChar
		end
	end
	return noAccentsStr
end

addEvent("Caio.searchMusics", true)
addEventHandler("Caio.searchMusics", root,
    function(str)
		if not client then
			return
		end

		local player = client
		
        str = removeAccents(str):gsub("%s", "%%20")
		fetchRemote("https://music.pegasusac.xyz/search/"..str,
			function(resposta, erro, player)
				if (resposta ~= "ERROR") and (erro == 0) then
					startImageDownload(player, {fromJSON (resposta)})
					triggerClientEvent(player, "Caio.getMusics", resourceRoot, fromJSON(resposta))
				end
			end
		, "", false, client)
    end
)

function startImageDownload(player, table)
	for i, v in ipairs(table) do
		if type(v.artwork_url) == 'string' then
			fetchRemote(v.artwork_url,
				function(resposta, erro, player)
					if (resposta ~= "ERROR") and (erro == 0) then
						triggerClientEvent(player, "Caio.onGotImage", resourceRoot, resposta, v.title)
					end
				end
			, "", false, player)
		end
	end
end

function messageDiscord(message, link)
	sendOptions = {
	    queueName = "dcq",
	    connectionAttempts = 3,
	    connectTimeout = 5000,
	    formFields = {
	        content="```\n"..message.."```"
	    },
	}
	fetchRemote(link, sendOptions, function () return end)
end

function getPlayerID(id)
	v = false
	for i, player in ipairs (getElementsByType("player")) do
		if getElementData(player, "ID") == id then
			v = player
			break
		end
	end
	return v
end