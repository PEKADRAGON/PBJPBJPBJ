function callProgress ( player, title, description, icon, time )
    
    if not player then 
        return iprint ( "player not found" )
    end

    if not title then 
        return iprint ( "title not found" )
    end

    if not description then
        return iprint ( "description not found" )
    end

    if not icon then
        return iprint ( "icon not found" )
    end

    if not time then
        return iprint ( "time not found" )
    end

    return triggerClientEvent ( player, "guetto.progress", resourceRoot, {title = title, description = description, icon = icon, icon, time = time} )
end;