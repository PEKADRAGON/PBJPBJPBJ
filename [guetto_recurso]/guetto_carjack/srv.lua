function checkCarJack(thePlayer, seat, jacked)
	if jacked and seat == 0 then
		cancelEvent()
		outputChatBox("#8b1a1a[!] CarJack é proibido.", thePlayer,0,0,0,true)
	end
   
	if (getElementData(thePlayer, "dead") == 1) then
		outputChatBox(">>#ffffff Você não pode entrar em um veículo enquanto estiver ferido.",thePlayer,255,0,0,true)
		cancelEvent()
	end
   
   	if (getElementData(thePlayer, "guetto.handcuffed") == 1) and (seat == 0) then
		outputChatBox(">>#ffffff Você não pode sentar-se no banco do motorista de um veículo enquanto estiver algemado.",thePlayer,255,0,0,true)
		cancelEvent()
	end
end
addEventHandler("onVehicleStartEnter", getRootElement(), checkCarJack)