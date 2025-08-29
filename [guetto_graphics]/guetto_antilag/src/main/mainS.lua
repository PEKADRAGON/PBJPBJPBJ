local database = dbConnect("sqlite", "src/database/database.db");
local dados = { }

-- \\ Function´s  //

loadPlayerData = function ( player )
    if not isGuestAccount(getPlayerAccount(player)) then 
                    
        local account = getAccountName ( getPlayerAccount ( player ) ) 
        local query = dbPoll( dbQuery( database, "SELECT * FROM `Anti-Lag` WHERE `account` = ?", account ) , - 1)

        if #query ~= 0 then 

            dados[account] = fromJSON(query[1].Dados);

        else
            
            if not dados[account] then 
                dados[account] = {
                    data = { };
                    mira = { index = 1, tamanho = 54, opacidade = 255, cor = { 255, 255, 255 } };
                }
            end;

            for index, value in ipairs( config["settings"] ) do 

                if value.type == "slidebar" then 
                    if value.title == "Limitar FPS" then 
                        dados[account].data[value.title] = 100;
                    else
                        dados[account].data[value.title] = 50;
                    end
                elseif value.type == "checkbox" then 
                    
                    if value.title == "Ruas" then 
                        dados[account].data[value.title] = true;
                    end

                    if value.title == "Chat" then 
                        dados[account].data[value.title] = true;
                    end

                    if value.title == "Plotagem" then 
                        dados[account].data[value.title] = true;
                    end

                    if value.title == "Mini mapa (fora do veículo)" then 
                        dados[account].data[value.title] = false;
                        setElementData(player, "minimap", false)
                    end

                    if not dados[account].data[value.title] then 
                        dados[account].data[value.title] = false 
                    end
                end

            end

            if dados[account] then 
                dbExec(database, "INSERT INTO `Anti-Lag` VALUES (?, ?) ", account, toJSON(dados[account]))
            end

        end

        setTimer ( function (player) 
            triggerClientEvent ( player, "Send>Anti>Lag>Infos", resourceRoot, dados[account] )
        end, 500, 1, player)
    end
end;

quit = function ( )
    local account = getAccountName(getPlayerAccount(source));

    if not dados[account] then 
        return 
    end

    dbExec(database, "UPDATE `Anti-Lag` SET `Dados` = ? WHERE `account` = ? ", toJSON(dados[account]), account)
end;

stop = function ( )
    for _, player in ipairs(getElementsByType("player")) do 
        if not isGuestAccount(getPlayerAccount(player)) then 
            local account = getAccountName(getPlayerAccount(player))
            if dados[account] then 
                dbExec(database, "UPDATE `Anti-Lag` SET `Dados` = ? WHERE `account` = ? ", toJSON(dados[account]), account)
            end
        end
    end
end;

login = function ( )
    loadPlayerData(source)
end;


-- \\ Event´s //

addEventHandler("onResourceStart", resourceRoot, 
    function ( )

        if database and isElement(database) then 

            dbExec(database, "CREATE TABLE IF NOT EXISTS `Anti-Lag`(account TEXT NOT NULL, Dados JSON NOT NULL)")

            for i, player in ipairs(getElementsByType("player")) do 
                loadPlayerData(player)
            end

            print("Database conectada!")
        end

    end
)

registerEventHandler("Anti>Lag>Apply>Modifications", resourceRoot, function (data)

    if not client then 
        return 
    end

    if source ~= resourceRoot then 
        return 
    end

    local account = getAccountName(getPlayerAccount(client))

    if not dados[account] then 
        return 
    end

    dados[account] = data;
end)

addEventHandler("onResourceStop", resourceRoot, stop)
addEventHandler("onPlayerQuit", root, quit)
addEventHandler("onPlayerLogin", root, login)
