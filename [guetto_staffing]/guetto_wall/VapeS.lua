addEventHandler("onResourceStart", resourceRoot,
function()
if config["Mensagem Start"] then
    outputDebugString("["..getResourceName(getThisResource()).."] Startado com sucesso, qualquer bug contacte vape.#0001")
  end
end)

addCommandHandler("wall", function ( player, cmd )
  local account = getAccountName ( getPlayerAccount ( player ) );
  
  if not isObjectInACLGroup("user."..account, aclGetGroup("Staff")) then 
    return false 
  end

  triggerClientEvent ( player, "squady.onWall", resourceRoot)
end)

addCommandHandler("wallcar", function ( player, cmd )
  local account = getAccountName ( getPlayerAccount ( player ) );
  
  if not isObjectInACLGroup("user."..account, aclGetGroup("Staff")) then 
    return false 
  end

  triggerClientEvent ( player, "squady.onWall.Veh", resourceRoot)
end)
