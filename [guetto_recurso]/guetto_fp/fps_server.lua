function resourceStart ( resource )
	 if resource == getThisResource() then
		local allplayers = getElementsByType ( "player" )
		for pKey,thep in ipairs(allplayers) do
			bindPlayer(thep)
		end	
	 end
end
addEventHandler ( "onResourceStart", getRootElement(), resourceStart )

function bindPlayer(player)
	if (player) then
		bindKey ( player, "backwards", "both", strafe )
	else
		if isElement(source) then
			bindKey ( source, "backwards", "both", strafe )
		end
	end
end
addEventHandler ( "onPlayerJoin", getRootElement(), bindPlayer )

function strafe(player, key, keystate)
	if keystate == "up" then
		setPedAnimation(player)
	else
		setPedAnimation( player, "ped", "FightSh_BWD", -1, true, true, false)
	end
end
