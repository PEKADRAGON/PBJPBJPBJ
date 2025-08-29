local database = dbConnect('sqlite', 'assets/database/database.db');
atms = {}
local cache = {}
blip = {}

addEventHandler("onResourceStart", resourceRoot, function ( )

    if database then 
        dbExec(database, "CREATE TABLE IF NOT EXISTS `GuettoBank` (`account`, `balance`)");
    end

    for i, v in ipairs(config.positions) do 
        local x, y, z, rx, ry, rz = unpack(v);
        
        atms[i] = createObject(2942, x, y, z, rx, ry, rz);
        blip[i] = createBlip(x, y, z, 52)
        cache[atms[i]] = i

        setElementData(atms[i], "guetto.bank", true)
        setElementFrozen(atms[i], true)
    end

    for i, v in ipairs(getElementsByType('player')) do 
        setPlayerBalance(v)
    end

end)

function setPlayerBalance ( player )
    if not isGuestAccount(getPlayerAccount(player)) then 
        local account = getAccountName(getPlayerAccount(player));
        local query = dbQuery(database, "SELECT * FROM `GuettoBank` WHERE `account`=?", account);
        local result = dbPoll(query, -1);
        if #result > 0 then 
            setElementData(player, "guetto.bank.balance", result[1].balance);
        else
            dbExec(database, "INSERT INTO `GuettoBank` (`account`, `balance`) VALUES (?, ?)", account, 0);
            setElementData(player, "guetto.bank.balance", 0);
        end
    end
end

-- Event´s 

addEventHandler("onElementClicked", root, function (button, state, player)
    if button == 'left' and state == 'down' then 
        if getElementData(source, 'guetto.bank') then 
            local x, y, z = getElementPosition(player);
            local x2, y2, z2 = getElementPosition(source);
            local distance = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2);
            if distance <= 5 then 
                if not isGuestAccount(getPlayerAccount(player)) then 

                    if (getElementData(source, "assaultado")) then 
                        return config.sendMessageServer(player, "Esse caixa está indisponível no momento!", "error")
                    end

                   triggerClientEvent(player, "guetto.interaction", resourceRoot, cache[source])
                end;
            end
        end
    end
end)

addEventHandler("onPlayerLogin", root, function ( )
    setPlayerBalance(source)
end)

addEventHandler('onPlayerQuit', root, function ()
    local money = (getElementData(source, 'guetto.bank.balance') or 0);
    local result = dbPoll(dbQuery(database, 'SELECT * FROM `GuettoBank` WHERE `account` =? ', getAccountName(getPlayerAccount(source))), -1)
    if #result ~= 0 then 
        dbExec(database, "UPDATE `GuettoBank` SET `balance`=? WHERE `account`=?", money, getAccountName(getPlayerAccount(source)));
    end
end)

registerEventHandler("guetto.deposit.bank", resourceRoot, function ( player, hash, iv )
    local serial = getPlayerSerial(player);
    decodeString("aes128", hash,  { key = serial:sub(17), iv = iv }, function ( data )
        
        local dados = fromJSON(data);
        local value = tonumber(dados.value);
        local sald = getPlayerMoney(player);

        if value > sald then 
            return config.sendMessageServer(player, "Você não tem saldo suficiente para realizar essa operação.", "error")
        end;

        local data = (getElementData(player, "guetto.bank.balance") or 0);

        takePlayerMoney(player, value)
        setElementData(player, "guetto.bank.balance", data + value);

        dbExec(database, "UPDATE `GuettoBank` SET `balance`=? WHERE `account`=?", data + value, getAccountName(getPlayerAccount(player)));
        config.sendMessageServer(player, "Você depositou R$"..formatNumber ( value, '.' ).." na sua conta bancária.", "success")
    end)
end)

registerEventHandler("guetto.saque.bank", resourceRoot, function ( player, hash, iv )
    local serial = getPlayerSerial(player);
    decodeString("aes128", hash,  { key = serial:sub(17), iv = iv }, function ( data )
        local dados = fromJSON(data);

        local value = tonumber(dados.value);
        local sald = (getElementData(player, "guetto.bank.balance") or 0);

        if value > sald then 
            return config.sendMessageServer(player, "Você não tem saldo suficiente para realizar essa operação.", "error")
        end;
        
        if value <= 0 then 
            return false 
        end

        givePlayerMoney(player, value)
        setElementData(player, "guetto.bank.balance", sald - value);

        dbExec(database, "UPDATE `GuettoBank` SET `balance`=? WHERE `account`=?", sald - value, getAccountName(getPlayerAccount(player)));
        config.sendMessageServer(player, "Você sacou R$"..formatNumber ( value, '.' ).." da sua conta bancária.", "success")
    end)    
end)

registerEventHandler("guetto.transfer.bank", resourceRoot, function ( player, hash, iv )
    local serial = getPlayerSerial(player);
    decodeString("aes128", hash,  { key = serial:sub(17), iv = iv }, function ( data )
        local dados = fromJSON(data);

        local target = getPlayerByID ( tonumber ( dados.id ) )
        local value = tonumber(dados.value);

        if value <= 0 then 
            return false 
        end

        if not target then 
            return config.sendMessageServer(player, "O jogador não está online.", "error")
        end;

        if target == player then 
            return config.sendMessageServer(player, "Você não pode transferir para você mesmo.", "error")
        end;

        local sald = (getElementData(player, "guetto.bank.balance") or 0);
        local sald2 = (getElementData(target, "guetto.bank.balance") or 0);

        if value > sald then 
            return config.sendMessageServer(player, "Você não tem saldo suficiente para realizar essa operação.", "error")
        end;

        setElementData(player, "guetto.bank.balance", sald - value);
        setElementData(target, "guetto.bank.balance", sald2 + value);

        dbExec(database, "UPDATE `GuettoBank` SET `balance`=? WHERE `account`=?", sald - value, getAccountName(getPlayerAccount(player)));
        dbExec(database, "UPDATE `GuettoBank` SET `balance`=? WHERE `account`=?", sald2 + value, getAccountName(getPlayerAccount(target)));

        config.sendMessageServer(player, "Você transferiu R$"..formatNumber ( value, '.' ).." para "..getPlayerName(target), "success")
    end)
end)

addEventHandler("onResourceStart", resourceRoot, function ( )
    for _, player in ipairs (getElementsByType("player")) do 
        setElementFrozen(player, false)
        toggleAllControls(player, true)
        setPedAnimation(player)
    end
end)

addCommandHandler("resetbalanceid", function(player, cmd, id)
    if (player) then 
        if isObjectInACLGroup("user."..getAccountName(getPlayerAccount(player)), aclGetGroup("Console")) then 
            if not id then 
                return config.sendMessageServer(player, "Digite o id do jogador!", "error")
            end
            local target = getPlayerFromID(id);
            if not target then return config.sendMessageServer(player, "Cidadão não encontrado!", "error") end 
            setElementData(target, "guetto.bank.balance", 0)
            dbExec(database, "UPDATE `GuettoBank` SET `balance`=? WHERE `account`=?", 0, getAccountName(getPlayerAccount(target)));
            config.sendMessageServer(player, "Conta do banco resetada com sucesso!", "info")
        end
    end
end)

addCommandHandler("resetbalanceconta", function(player, cmd, account)
    if (player) then 
        if isObjectInACLGroup("user."..getAccountName(getPlayerAccount(player)), aclGetGroup("Console")) then 
            if not account then 
                return config.sendMessageServer(player, "Digite a conta do cidadão!", "error")
            end
            local qh = dbPoll(dbQuery(database, "SELECT * FROM `GuettoBank` WHERE `account` = ?", account), - 1)
            if #qh == 0 then return config.sendMessageServer(player, "Cidadão não encontrado!", "error") end 
            dbExec(database, "UPDATE `GuettoBank` SET `balance`=? WHERE `account`=?", 0, account);
            config.sendMessageServer(player, "Conta do banco resetada com sucesso!", "info")
        end
    end
end)

function getPlayerFromID(id)
    local id = tonumber(id)
    local result = false;
    for i, v in ipairs(getElementsByType('player')) do 
        if (v and isElement(v)) then 
            if (getElementData(v, 'ID') == id) then 
                result = v 
            end
        end
    end
    return result
end;