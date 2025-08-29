addEvent('animations > SyncRoll',true)
addEventHandler('animations > SyncRoll',root,function(...)
    triggerClientEvent(root, 'animations > SetAnimation', root, ...)
end)