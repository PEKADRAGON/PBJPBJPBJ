local animEnable = {}
local syncPlayers = {}
local musicPlaying = {}

addCommandHandler("tocarv",
	function(player)
		local amount = exports['guetto_inventory']:getItem(player, 1)
		if not animEnable[player] then
			if amount == 0 then outputChatBox("[!]#FFFFFF Você não tem um violao.", player, 0, 255, 0, true) return end
			animEnable[player] = true
			triggerClientEvent(syncPlayers, "baglama", player, true)
			outputChatBox("[!]#FFFFFF Você está tocando violão. (Para cancelar /tocarv)", player, 0, 255, 0, true)
			--giveWeapon(player, 7, 1, true)
			
			-- Müziği başlat
			if not musicPlaying[player] then
				musicPlaying[player] = true
				triggerClientEvent(getElementsByType('player'), "playMusic", resourceRoot, player)
			end
		else
			animEnable[player] = false
			triggerClientEvent(syncPlayers, "baglama", player, false)
			outputChatBox("[!]#FFFFFF Você guardou o violão.", player, 255, 0, 0, true)
			--takeWeapon(player, 7)

			-- Müziği durdur
			if musicPlaying[player] then
				musicPlaying[player] = false
				triggerClientEvent(getElementsByType('player'), "stopMusic", resourceRoot, player)
			end
		end
	end
)

addEvent("onClientSync", true)
addEventHandler("onClientSync", resourceRoot,
    function()
        table.insert(syncPlayers, client)
		for player, enable in pairs(animEnable) do
			if enable then
				triggerClientEvent(client, "baglama", player, true)
			end
		end
    end 
)

addEventHandler("onPlayerQuit", root,
    function()
        for i, player in ipairs(syncPlayers) do
            if source == player then 
                table.remove(syncPlayers, i)
                break
            end 
        end
        animEnable[source] = nil
        musicPlaying[source] = nil
    end
)

addEventHandler("onPlayerWasted", root,
    function()
        if musicPlaying[source] then
            musicPlaying[source] = false
            triggerClientEvent(source, "stopMusic", resourceRoot)
        end
        if animEnable[source] then
            animEnable[source] = false
           -- takeWeapon(source, 7)
        end
    end
)

-- Model 3D Warehouse, Author : Ali K.
-- Müzik : Harun Murat ÖZGÜÇ : https://www.youtube.com/watch?v=diAkfxeaibs
-- Script : SparroWMTA

-- SparroW MTA : https://sparrow-mta.blogspot.com
-- Facebook : https://www.facebook.com/sparrowgta/
-- İnstagram : https://www.instagram.com/sparrowmta/
-- Discord : https://discord.gg/DzgEcvy