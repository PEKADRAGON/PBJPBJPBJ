function getPlayerAcl (player, acl)
    
    if not player or not isElement(player) then 
        return false;
    end;

    if not acl then 
        return false;
    end;

    if not aclGetGroup(acl) then 
        return print ( "Error: Group not found" );
    end;

    local accountName = getAccountName(getPlayerAccount(player));

    if (isObjectInACLGroup('user.'..accountName, aclGetGroup(acl))) then 
        return true 
    end;

    return false
end;

function Sync(...) 

    if table.getn(arg) == 0 then

        return false;

    end

    local Threads = {};
    local FuncParam = {};


    for i = 1, table.getn(arg) do

        if type(arg[i]) ~= 'table' then

            Threads[i] = coroutine.create( arg[i] )

        end

    end

    for i = 1, table.getn(Threads) do

        coroutine.resume( Threads[i], Threads, arg[ (table.getn(arg) - table.getn(Threads)) + i ] and arg[ (table.getn(arg)- table.getn(Threads)) + i ] or {} )

    end

    return { arg, Threads };
end