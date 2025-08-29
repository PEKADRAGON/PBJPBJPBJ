addEvent ("collectCrystal", true)

addEventHandler ("collectCrystal", resourceRoot, function()

	local newData = (client.account:getData ("crystal:collected") and tonumber(client.account:getData ("crystal:collected")) or 0) + 1

	client.account:setData ("crystal:collected", newData)

	

	local newData1 = (client.account:getData ("crystal:collectedcount") and tonumber(client.account:getData ("crystal:collectedcount")) or 0) + 1

	client.account:setData ("crystal:collectedcount", newData1)

	client:setData ("crystal:collectedcount", newData1)

	

	client:setData ("crystal:collected", newData)

	

	if newData == Config.maxCristall then

		local newDataDays = (client.account:getData ("crystal:collectedDays") and tonumber(client.account:getData ("crystal:collectedDays")) or 0) + 1

		client.account:setData ("crystal:collectedDays", newDataDays)

		

		client:setData ("crystal:collectedDays", newDataDays)

		

		if newDataDays == 8 then

			client.account:setData ("crystal:collectedDays", 1)

			client:setData ("crystal:collectedDays", 1)

		end

		

		triggerClientEvent (client, "delAllCristal", resourceRoot)

	end

end)



function takePlayerCrystal (player, amount)

	local data = getPlayerCrystal(player) - amount

	player.account:setData ("crystal:collectedcount", data)

	player:setData ("crystal:collectedcount", data)

end



function givePlayerCrystal (player, amount)

	local data = getPlayerCrystal(player) + amount

	player.account:setData ("crystal:collectedcount", data)

	player:setData ("crystal:collectedcount", data)

end



function getPlayerCrystal (player)

	return player.account:getData ("crystal:collectedcount") and tonumber(player.account:getData ("crystal:collectedcount")) or 0

end



addEvent ("updateMyPoses", true)

addEventHandler ("updateMyPoses", resourceRoot, function(t)

	client.account:setData ("crystal:table", toJSON(t))

end)



function loadPlayerConfig (pl)

	local prevPoses = pl.account:getData ("crystal:table") and fromJSON (pl.account:getData ("crystal:table")) or false

	local prevData = pl.account:getData ("crystal:collected") and tonumber(pl.account:getData ("crystal:collected")) or 0

	pl:setData ("crystal:collected", prevData >= 0 and prevData or 0)

	

	local prevDataAll = pl.account:getData ("crystal:collectedcount") and tonumber(pl.account:getData ("crystal:collectedcount")) or 0

	pl:setData ("crystal:collectedcount", prevDataAll >= 0 and prevDataAll or 0)

	

	if prevDataAll < 0 then

		pl.account:setData ("crystal:collectedcount", 0)

	end

	

	local prevDataDays= pl.account:getData ("crystal:collectedDays") and tonumber(pl.account:getData ("crystal:collectedDays")) or 1

	pl:setData ("crystal:collectedDays", prevDataDays > 0 and prevDataDays or 1)

	

	local prevTime = pl.account:getData ("crystal:timestamp") and tonumber(pl.account:getData ("crystal:timestamp")) or false

	

	---===== У меня брат умер от этой комбинации

	-- if prevTime and prevTime < prevTime + 86400 then

	if prevTime and getRealTime().timestamp - prevTime < 86400 then -- Если не прошли 1 сутки

		if prevData < Config.maxCristall then

			if prevPoses and type(prevPoses) == "table" then

				triggerClientEvent (pl, "startCreateCrystall", resourceRoot, prevPoses)

				

				pl:setData ("crystal:collected", prevData)

			else

				triggerClientEvent (pl, "startCreateCrystall", resourceRoot)

				

				pl.account:setData ("crystal:timestamp", getRealTime().timestamp)

				pl.account:setData ("crystal:collected", 0)

			end

		end

	else

		triggerClientEvent (pl, "startCreateCrystall", resourceRoot)

		

		pl.account:setData ("crystal:timestamp", getRealTime().timestamp)

		pl.account:setData ("crystal:collected", 0)

	end

end



function savePlayerConfig (pl)

	

end

addEventHandler ("onPlayerQuit", root, function() savePlayerConfig(source) end)



addCommandHandler ("crystall-reset", function(pl) 

	pl.account:setData ("crystal:timestamp", nil)

	pl.account:setData ("crystal:collected", 0) 

	pl.account:setData ("crystal:table", nil)

	

	pl:setData ("crystal:table", nil)

	pl:setData ("crystal:timestamp", nil)

	

	pl:setData ("crystal:collected", (pl.account:getData ("crystal:collected") or 0))

	

	loadPlayerConfig (pl)

end)



addCommandHandler ("clearcrystalls", function(pl)

	for i, v in ipairs (getAccounts()) do

		v:setData("crystal:timestamp", nil)

		v:setData("crystal:collected", nil)

		v:setData("crystal:table", nil)

		v:setData("crystal:collectedDays", nil)

		v:setData("crystal:collectedcount", nil)

		

		local player = getAccountPlayer(v)

		if player then

			player:setData("crystal:timestamp", nil)

			player:setData("crystal:collected", nil)

			player:setData("crystal:table", nil)

			player:setData("crystal:collectedDays", nil)

			player:setData("crystal:collectedcount", nil)

			

			triggerClientEvent (player, "delAllCristal", resourceRoot)

			if player ~= pl then

				outputChatBox ("Admin limpou os dados de cristal de todos os jogadores!", player, 0, 255, 0)

			end

		end

	end

	

	outputChatBox ("Você limpou os dados de cristal de todos os jogadores!", pl, 0, 255, 0)

end, true)



addCommandHandler ("cr", function(pl)

	outputChatBox( "#FF8C00[R]#FFFFFF Você tem cristais: "..pl.account:getData ("crystal:collectedcount"), pl, 255, 255, 255, true ) 

end)





-- addEve







addEventHandler ("onPlayerLogin", root, function()

	loadPlayerConfig (source)

end)



addEventHandler ("onResourceStart", resourceRoot, function()

	setTimer (function()

		for i, v in ipairs (getElementsByType ("player")) do

			if not v.account.guest then

				loadPlayerConfig (v)

			end

		end

	end, 500, 1)

end)