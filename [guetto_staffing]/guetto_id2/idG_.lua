Config = {
    ['ID'] = {
        ['ACL'] = 'Console', -- ACL
        ['CMD'] = 'setid', -- Comando para setar ID | /setid [ID] [NEWID]
        
        ['ID_INIT'] = 490, -- Id que ira começar a registrar! 
        
        ['Infobox'] = function( e , m , t )
            exports['guetto_notify']:showInfobox(e, t, m) 
        end, 
    },
}