config = {
    ["object"] = 2605, -- Objeto da mesa
    ["times"] = {20000, 20000, 20000}, -- Tempo que cada ped vai aparecer na mesa, aleatorio
    ["acls_booster"] = {"Console"}; -- Lista de acls que podem usar o booster
    ["id_mesa"] = 126; -- ID do item da mesa 
    ["id_dinheiro_sujo"] = 100; -- ID do item do dinheiro sujo

    ["values"] = { -- Lista de valores das drogas
        [96] = {1000, 2000};
        [124] = {1000, 2000};
        [1] = {1000, 2000};
    };

    ["itens"] = {
        {
            item = "Maconha",
            id = 96,
            imagem = "assets/itens/maconha.png",
        },

        {
            item = "Cocaína",
            id = 124,
            imagem = "assets/itens/coca.png",
        },

        {
            item = "Lança-perfume",
            id = 1,
            imagem = "assets/itens/lanca.png",
        },

        {
            item = "Ecstasy",
            id = 1,
            imagem = "assets/itens/mdma.png",
        },

        {
            item = "LSD",
            id = 1,
            imagem = "assets/itens/lsd.png",
        },
    };
}

sendMessageServer = function (player, msg, type)
    return exports['guetto_notify']:showInfobox(player, type, msg)
end;

sendMessageClient = function (msg, type)
    return exports['guetto_notify']:showInfobox(type, msg)
end;

function formatNumber(number, sep)
	assert(type(tonumber(number))=="number", "Bad argument @'formatNumber' [Expected number at argument 1 got "..type(number).."]")
	assert(not sep or type(sep)=="string", "Bad argument @'formatNumber' [Expected string at argument 2 got "..type(sep).."]")
	sep = sep or '.'
	local money = number
	for i = 1, tostring(money):len()/3 do
		money = string.gsub(money, "^(-?%d+)(%d%d%d)", "%1"..sep.."%2")
	end
	return money
end