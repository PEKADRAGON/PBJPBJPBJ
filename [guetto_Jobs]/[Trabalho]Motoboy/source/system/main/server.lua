-- addEventHandler('onResourceStart', resourceRoot, function()
--     if (hasObjectPermissionTo(getThisResource(), 'function.startResource', true)) then
--         if (getResourceFromName('labz_pattach')) then
--             if (getResourceState(getResourceFromName('labz_pattach')) == 'loaded') then
--                 startResource(getResourceFromName('labz_pattach'))
                
--                 outputDebugString('[174 Roleplay] O resource \'labz_pattach\' foi iniciado.', 4, 31, 139, 76)
--             elseif (getResourceState(getResourceFromName('labz_pattach')) ~= 'running') then
--                 outputDebugString('[174 Roleplay] O resource \'labz_pattach\' não está corretamente inserido, por favor arrume o mesmo.', 4, 31, 139, 76)

--                 cancelEvent()
--             end
--         else
--             outputDebugString('[174 Roleplay] O resource \'labz_pattach\' não está no servidor, por favor coloque-o.', 4, 31, 139, 76)

--             cancelEvent()
--         end

--         if (getResourceState(getResourceFromName('labz_pattach')) == 'running') then
--             outputDebugString('[174 Roleplay] O resource \''..getResourceName(getThisResource())..'\' foi iniciado sem erros.', 4, 31, 139, 76)
--         end
--     else
--         outputDebugString('[174 Roleplay] O resource \''..getResourceName(getThisResource())..'\' está sem permissão.', 4, 31, 139, 76)

--         cancelEvent()
--     end
-- end)

-- addCustomEventHandler('notify', function(player, message, type)
--     addNotification(player, message, type)
-- end)