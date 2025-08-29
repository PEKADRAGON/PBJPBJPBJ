addEvent("server->applyTextureJBL", true)
addEventHandler("server->applyTextureJBL", root, function(element, texture)
    if element and texture then
        triggerClientEvent(root, "client->applyTextureJBL", root, element, texture)
    end
end)