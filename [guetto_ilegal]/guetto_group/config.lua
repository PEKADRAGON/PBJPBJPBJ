config = {

    ["others"] = {
        key = "f6",
        tipos = {"Facção", "Corporação", "Mec", "SAMU"}
    };

    ["Cargos"] = {
        
        ["Facção"] = {
            
            { name = "01",  permissoes = { expulsar = true, convidar = true, depositar = true, sacar = true, upar = true, rebaixar = true } };
            { name = "02",  permissoes = { expulsar = true, convidar = true, depositar = true, sacar = true, upar = true, rebaixar = true } };
            { name = "03",  permissoes = { expulsar = true, convidar = true, depositar = true, sacar = true, upar = true, rebaixar = true } };
            { name = "BRAÇO DIREITO",  permissoes = { expulsar = true, convidar = true, depositar = true, sacar = false, upar = true, rebaixar = true } };
            { name = "CHEFE",  permissoes = { expulsar = true, convidar = true, depositar = true, sacar = false, upar = true, rebaixar = true } };
            { name = "GERENTE GERAL",  permissoes = { expulsar = true, convidar = true, depositar = true, sacar = false, upar = true, rebaixar = true } };
            { name = "GERENTE",  permissoes = { expulsar = false, convidar = false, depositar = true, sacar = false, upar = false, rebaixar = false } };
            { name = "157",  permissoes = { expulsar = false, convidar = false, depositar = true, sacar = false, upar = false, rebaixar = false } };
            { name = "TRAFICANTE",  permissoes = { expulsar = false, convidar = false, depositar = true, sacar = false, upar = false, rebaixar = false } };
            { name = "AVIÃOZINHO",  permissoes = { expulsar = false, convidar = false, depositar = true, sacar = false, upar = false, rebaixar = false } };
            { name = "FOGUETEIRO",  permissoes = { expulsar = false, convidar = false, depositar = true, sacar = false, upar = false, rebaixar = false } };
            { name = "OLHEIRO",  permissoes = { expulsar = false, convidar = false, depositar = true, sacar = false, upar = false, rebaixar = false } };
            { name = "CRIA",  permissoes = { expulsar = false, convidar = false, depositar = true, sacar = false, upar = false, rebaixar = false } };

        };

        ["Corporação"] = {

            { name = "COMANDANTE GERAL", permissoes = { expulsar = true, convidar = true, depositar = true, sacar = true, upar = true, rebaixar = true } };
            { name = "COMANDANTE", permissoes = { expulsar = true, convidar = true, depositar = true, sacar = true, upar = true, rebaixar = true } };
            { name = "SUB-COMANDANTE", permissoes = { expulsar = true, convidar = true, depositar = true, sacar = true, upar = true, rebaixar = true } };
            { name = "TENENTE-CORONEL", permissoes = { expulsar = true, convidar = true, depositar = true, sacar = true, upar = true, rebaixar = true } };
            { name = "MAJOR", permissoes = { expulsar = true, convidar = true, depositar = true, sacar = false, upar = true, rebaixar = true } };
            { name = "CAPITÃO", permissoes = { expulsar = true, convidar = true, depositar = true, sacar = false, upar = true, rebaixar = true } };
            { name = "1º TENENTE", permissoes = { expulsar = false, convidar = true, depositar = true, sacar = false, upar = false, rebaixar = false } };
            { name = "2º TENENTE", permissoes = { expulsar = false, convidar = false, depositar = true, sacar = false, upar = false, rebaixar = false } };
            { name = "SUB-OFICIAL", permissoes = { expulsar = false, convidar = false, depositar = true, sacar = false, upar = false, rebaixar = false } };

            { name = "1º SARGENTO", permissoes = { expulsar = false, convidar = false, depositar = true, sacar = false, upar = false, rebaixar = false } };
            { name = "2º SARGENTO", permissoes = { expulsar = false, convidar = false, depositar = true, sacar = false, upar = false, rebaixar = false } };
            { name = "3º SARGENTO", permissoes = { expulsar = false, convidar = false, depositar = true, sacar = false, upar = false, rebaixar = false } };
            { name = "CABO", permissoes = { expulsar = false, convidar = false, depositar = true, sacar = false, upar = false, rebaixar = false } };
            { name = "SDº 1 CLASSE", permissoes = { expulsar = false, convidar = false, depositar = true, sacar = false, upar = false, rebaixar = false } };
            { name = "SDº 2 CLASSE", permissoes = { expulsar = false, convidar = false, depositar = true, sacar = false, upar = false, rebaixar = false } };
            { name = "ALUNO", permissoes = { expulsar = false, convidar = false, depositar = true, sacar = false, upar = false, rebaixar = false } };

        };

        ["Mec"] = {

            { name = "Dono", permissoes = { expulsar = true, convidar = true, depositar = true, sacar = true, upar = true, rebaixar = true } };
            { name = "Dono 02", permissoes = { expulsar = true, convidar = true, depositar = true, sacar = true, upar = true, rebaixar = true } };
            { name = "Dono 03", permissoes = { expulsar = true, convidar = true, depositar = true, sacar = true, upar = true, rebaixar = true } };
            { name = "Gerente", permissoes = { expulsar = true, convidar = true, depositar = true, sacar = true, upar = true, rebaixar = true } };
            { name = "Mecanico master", permissoes = { expulsar = true, convidar = false, depositar = true, sacar = true, upar = false, rebaixar = false } };
            { name = "Mecanico em teste", permissoes = { expulsar = true, convidar = false, depositar = true, sacar = true, upar = false, rebaixar = false } };

        };

        ["SAMU"] = {

            { name = "Diretor Geral", permissoes = { expulsar = true, convidar = true, depositar = true, sacar = true, upar = true, rebaixar = true } };
            { name = "Diretor", permissoes = { expulsar = true, convidar = true, depositar = true, sacar = true, upar = true, rebaixar = true } };
            { name = "Médico", permissoes = { expulsar = true, convidar = false, depositar = true, sacar = true, upar = false, rebaixar = false } };
            { name = "Enfermeiro", permissoes = { expulsar = true, convidar = false, depositar = true, sacar = true, upar = false, rebaixar = false } };
            { name = "Técnico de Enfermagem", permissoes = { expulsar = true, convidar = false, depositar = true, sacar = true, upar = false, rebaixar = false } };
            { name = "Auxiliar de Enfermagem", permissoes = { expulsar = true, convidar = false, depositar = true, sacar = true, upar = false, rebaixar = false } };

        };

    };

    sendMessageClient = function(message, type)
        return exports['guetto_notify']:showInfobox(type, message)
    end;
 
    sendMessageServer = function(player, message, type)
        return exports['guetto_notify']:showInfobox(player, type, message)
    end;

}

function registerEventHandler ( event, ... )
    addEvent( event, true )
    addEventHandler( event, ... )
end;

function removeHex (s)
    return s:gsub ("#%x%x%x%x%x%x", "") or false
end

_getPlayerName = getPlayerName 

function getPlayerName ( player )
    return removeHex ( _getPlayerName ( player ) )
end;

function getRolePosition ( type, role )
    if not config["Cargos"][type] then
        return false 
    end
    for i = 1, #config["Cargos"][type] do 
        if string.lower(config["Cargos"][type][i].name) == string.lower(role) then
            return i 
        end
    end
    return false 
end

function formatNumber(number, sep)
	assert(type(tonumber(number))=="number", "Bad argument @'formatNumber' [Expected number at argument 1 got "..type(number).."]")
	assert(not sep or type(sep)=="string", "Bad argument @'formatNumber' [Expected string at argument 2 got "..type(sep).."]")
	local money = number
	for i = 1, tostring(money):len()/3 do
		money = string.gsub(money, "^(-?%d+)(%d%d%d)", "%1"..sep.."%2")
	end
	return money
end


function tblSize ( t )

    if not t then 
        return false 
    end
    
    local c = 0

    for i, v in pairs ( t ) do 

        c = c + 1
    end

    return c
end