local playerMoney = getPlayerMoney ( localPlayer )
local messages =  { }
local sx, sy = guiGetScreenSize ( )

addEventHandler ( "onClientRender", root, function ( )
	local tick = getTickCount ( )
	if ( playerMoney ~= getPlayerMoney ( localPlayer ) ) then
		local pM = getPlayerMoney ( localPlayer ) 
		if ( pM > playerMoney ) then
			local diff = pM - playerMoney
			table.insert ( messages, { diff, true, tick + 5000, 180 } )
			playSound("money.mp3")
		else
			local diff = playerMoney - pM
			table.insert ( messages, { diff, false, tick + 5000, 180 } )
			playSound("money.mp3")
		end
		playerMoney = pM
	end
	
	if ( #messages > 7 ) then
		table.remove ( messages, 1 )
	end
	
	for index, data in ipairs ( messages ) do
		local v1 = data[1]
		local v2 = data[2]
		local v3 = data[3]
		local v4 = data[4]
		
		if ( v2 ) then
			dxDrawText ( "+ $"..convertNumber ( v1 ), sx - 155, (sy+145)-(index*655), 50, 20, tocolor ( 0, 223, 86, v4+255 ), 1, 'pricedown' )
		else
			dxDrawText ( "- $"..convertNumber ( v1 ), sx - 155, (sy+145)-(index*655), 50, 20, tocolor ( 255, 0, 0, v4+255 ), 1, 'pricedown' )
		end
		
		if ( tick >= v3 ) then
			messages[index][4] = v4-2
			if ( v4 <= 25 ) then
				table.remove ( messages, index )
			end
		end
	end
end )



function convertNumber ( number )  
	local formatted = number  
	while true do      
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')    
		if ( k==0 ) then      
			break   
		end  
	end  
	return formatted
end