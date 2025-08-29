function showInfobox(element, type, msg, msg2, imgPath, color)
	if isElement(element) then
		triggerClientEvent(element,"showInfobox", resourceRoot, type, msg, msg2, imgPath, color)
	end
end