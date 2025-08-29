--──────────────────────────────/ DATABASE \──────────────────────────────
local db = dbConnect( 'sqlite' , 'database.db' ) 
--──────────────────────────────/ EVENT RESOURCE START \──────────────────────────────
addEventHandler( 'onResourceStart' , resourceRoot , 
    function()
        local resName = getResourceName( getThisResource( ) )
        if ( db ) then
            dbExec( db , 'CREATE TABLE IF NOT EXISTS Global ( ID , Account )' )
            outputDebugString( ''..resName..': Banco de dados conectado!' , 4 , 0 , 148 , 222 )
            local query = dbPoll(dbQuery(db, 'SELECT * FROM `Global`'), - 1)
            if #query ~= 0 then 
                for i = 1, #query do 
                    local v = query[i]
                    local element = getPlayerFromAccountName(v.Account);
                    if element and isElement(element) then 
                        setElementData(element, 'ID', v.ID)
                    end
                end
            end
        else
            stopResource( getThisResource( ) )
            outputDebugString( ''..resName..': Banco de dados falhou!' , 4 , 255 , 0 , 0 )
        end
    end
)

--──────────────────────────────/ EVENT LOGIN \──────────────────────────────

addEventHandler( 'onPlayerLogin' , root , 
    function( _ , acc )
        if ( not isGuestAccount( acc ) ) then
            local numberColumn = dbPoll( dbQuery( db , 'SELECT * FROM Global' ), - 1 )
            local dataFromAccount = dbPoll( dbQuery( db , 'SELECT * FROM Global WHERE Account = ?', getAccountName( acc ) ), - 1 )
            if ( #dataFromAccount > 0 ) then
                setElementData( source , 'ID' , tonumber(dataFromAccount[1]['ID']) )
            else
                dbExec( db , 'INSERT INTO Global ( ID , Account ) VALUES( ? , ? )' , tonumber( #numberColumn + Config['ID']['ID_INIT'] ), getAccountName( acc ) )
                setElementData( source , 'ID' , tonumber( #numberColumn + Config['ID']['ID_INIT'] ) )
            end
        end
    end
)
--──────────────────────────────/ SET ID \──────────────────────────────

addCommandHandler( 'setidmat' , 
    function( player , _ , id , newid )
        if ( not isGuestAccount( getPlayerAccount( player ) ) ) then
            if isObjectInACLGroup( 'user.'..getAccountName( getPlayerAccount( player ) ), aclGetGroup( "Console" ) ) then
                if ( id and tonumber( id ) ) then
                    local client = getPlayerID( id )
                    if client then
                        if ( newid and tonumber( newid ) ) then
                            if id ~= newid then
                                local perdeuID = getdata( newid )
                                if not perdeuID then
                                    Config['ID']['Infobox']( player , 'Você setou ID: '..newid..' para o: '..removeHex( getPlayerName( client ) ) , 'success' )
                                    Config['ID']['Infobox']( client , 'o STAFF: '..removeHex( getPlayerName( player ) )..' alterou seu ID para: '..newid , 'success' )
                                    setElementData( client , 'ID' , tonumber(newid) )
                                    dbExec( db , 'UPDATE Global SET ID = ? WHERE Account = ?' , tonumber(newid) , getAccountName( getPlayerAccount( client ) ) )
                                else
                                    local client1 = getPlayerID( tonumber(newid) )
                                    if client1 then
                                        Config['ID']['Infobox']( player , 'Você setou ID: '..tonumber(newid)..' para o: '..removeHex( getPlayerName( client ) ) , 'success' )
                                        Config['ID']['Infobox']( client , 'o STAFF: '..removeHex( getPlayerName( player ) )..' alterou seu ID para: '..newid , 'success' )
                                        Config['ID']['Infobox']( client1 , 'o STAFF: '..removeHex( getPlayerName( player ) )..' alterou seu ID para: '..id , 'success' )
                                        -- setdata    
                                        setElementData( client , 'ID' , tonumber(newid) )
                                        setElementData( client1 , 'ID' , tonumber(id) )
                                        -- database
                                        dbExec( db , 'UPDATE Global SET ID = ? WHERE Account = ?' , tonumber(newid) , getAccountName( getPlayerAccount( client ) ) )
                                        dbExec( db , 'UPDATE Global SET ID = ? WHERE Account = ?' , tonumber(id) , getAccountName( getPlayerAccount( client1 ) ) )
                                    else
                                        Config['ID']['Infobox']( player , 'Você setou ID: '..newid..' para o: '..removeHex( getPlayerName( client ) ) , 'success' )
                                        Config['ID']['Infobox']( client , 'o STAFF: '..removeHex( getPlayerName( player ) )..' alterou seu ID para: '..newid , 'success' )
                                        -- setdata
                                        setElementData( client , 'ID' , tonumber(newid) )
                                        dbExec( db , 'UPDATE Global SET ID = ? WHERE Account = ?' , tonumber(newid) , getAccountName( getPlayerAccount( client ) ) )
                                        dbExec( db , 'UPDATE Global SET ID = ? WHERE Account = ?' , tonumber(id) , getAccountName( getPlayerAccount( client1 ) ) )
                                    end
                                end
                            else
                                Config['ID']['Infobox']( player , 'Digite algum ID diferente para setar ao jogador!', 'info' )
                            end
                        else
                            Config['ID']['Infobox']( player , 'Digite o novo ID do jogador!', 'info' )
                        end
                    else
                        Config['ID']['Infobox']( player , 'O Jogador de ID: '..(id)..' não foi encontrado!', 'error' )
                    end
                else
                    Config['ID']['Infobox']( player , 'Digite o ID do jogador!', 'info' )
                end
            end
        end
    end
)


addCommandHandler('deletarconta', 
    function ( player, cmd, id )
        if ( not isGuestAccount( getPlayerAccount( player ) ) ) then
            if isObjectInACLGroup( 'user.'..getAccountName( getPlayerAccount( player ) ), aclGetGroup( "Console" ) ) then
                if ( id and tonumber( id ) ) then 
                    local target = getdata( tonumber ( 5 ) )
                    if #target == 0 then return Config['ID']['Infobox']( player , 'Conta não encontrada!', 'info' ) end 
                    dbExec(db, 'DELETE FROM Global WHERE ID = ?', tonumber ( id ) )
                    Config['ID']['Infobox']( player , 'Conta deletada com sucesso!', 'info' )
                else
                    Config['ID']['Infobox']( player , 'Digite o id!', 'info' )
                end
            end
        end
    end
)

--──────────────────────────────/ UTIL`S \──────────────────────────────

function getdata( id )
    if id then
        local q = dbPoll( dbQuery( db , 'SELECT * FROM Global WHERE ID = ?' , id ), - 1 )
        if #q > 0 then
            return q
        end
    end 
    return false
end

function getSerialByID(id)
    local result = dbPoll(dbQuery(db, 'SELECT * FROM Global WHERE ID = ?', id), -1)
    if #result ~= 0 then
        return getAccountSerial(getAccount(result[1]['Account'])), result[1]['Account']
    end
end

function getIdByConta(id)
    local result = dbPoll(dbQuery(db, "SELECT * FROM Global WHERE ID = ?", id), - 1)
    if #result ~= 0 then
        return result[1]["Global"], result[1]["Account"]
    end
end

function getIdByAccount ( account )
    local result = dbPoll(dbQuery(db, 'SELECT * FROM Global WHERE Account = ?', account), -1)
    if #result ~= 0 then
        return result[1]['ID']
    end
    return false 
end

function getID(id)
    local result = dbPoll(dbQuery(db, "SELECT * FROM Global WHERE ID = ?", id), - 1)
    if #result ~= 0 then
        return result[1]["Global"]
    else
        if getAccount(id) then
            if getAccountID(getAccount(id)) then
                return getAccountID(getAccount(id))
            end
        end
    end
    return 0
end

function getPlayerID( id )
    if id then
        local id = tonumber(id)
        print(type(id))
        for _, player in ipairs( getElementsByType( 'player' ) ) do
            if getElementData( player , 'ID' ) == id then
                return player
            end
        end
    end
    return false
end

function removeHex(s)
    if type (s) == "string" then
        while (s ~= s:gsub ("#%x%x%x%x%x%x", "")) do
            s = s:gsub ("#%x%x%x%x%x%x", "")
        end
    end
    return s or false
end

addCommandHandler( 'id' , 
    function( player , _ , id )
        if id then
            local client = getPlayerID( id )
            if client and isElement( client ) then
                Config['ID']['Infobox']( player , 'ID: '..id..' | NOME: '..getPlayerName( client ) , 'success' )
            else
                Config['ID']['Infobox']( player , 'O Jogador não foi encontrado!' , 'error' )
            end
        else
            Config['ID']['Infobox']( player , 'Digite o ID do jogador!' , 'info' )
        end
    end
)

function getPlayerFromAccountName(name) 
    local acc = getAccount(name)
    if (not acc) or (isGuestAccount(acc)) then
        return false
    end
    return getAccountPlayer(acc)
end