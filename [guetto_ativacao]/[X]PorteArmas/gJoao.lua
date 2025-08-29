--##################################
--## Script feito por zJoaoFtw_   ##
--## Design feito por Golf        ##
--##################################

config = {
    ["Mensagem Start"] = true, --Caso esteja false ele não irá aparecer a mensagem!
    ["Markers"] = {
        {2059.046, -1884.709, 13.703, 0, 0, "index"},
        {201.04, 167.166, 1003.023, 3, 3,  "giveporte"},
        {201.148, 169.708, 1003.023, 3, 3, "removeporte"},
    },
    ["Minimo"] = {
        Acertos = 9,
        Level = 5,
        Dinheiro = 50000,
    },
    ["Questions"] = {
        {
            Answer = 1,
            Title = "1. Nas armas semiautomaticas, o disparo e o acionamento do gatilho nao sao automaticas",
            ["Questions"] = {
                {"A", "Correto"},
                {"B", "Errado"},
            },
        },
        {
            Answer = 1,
            Title = "2. De acordo com as regras de segurança, não se deve atirar em água, em rocha ou em qualquer superfícies nas quais os projeteis posso ricochetear",
            ["Questions"] = {
                {"A", "Correto"},
                {"B", "Errado"},

                
            },
        },
        {
            Answer = 2,
            Title = "3. As armas cujo sistema automático prepara o acionamento do próximo disparo, colocando o projetil em posição de disparo, bastando o simples toque no gatilho denominam-se?",
            ["Questions"] = {
                {"A", "Automáticas"},
                {"B", "De repetição manual do sistema de acionamento"},
                {"C", "Semiautomáticas"},
                
            },
        },
        {
            Answer = 2,
            Title = "4.  A utilização de luneta telescópica classifica a arma de fogo, quanto ao aparelho de pontaria, como de mira aberta",
            ["Questions"] = {
                {"A", "Correta"},
                {"B", "Errado"},                
            },
        },
        {
            Answer = 1,
            Title = "5. O  tiro instintivo pode ser realizado na posição de joelhos",
            ["Questions"] = {
                {"A", "Correta"},
                {"B", "Errado"},                
            },
        },
        {
            Answer = 1,
            Title = "6. Arma portátil pode ser transportada por um só homem, ou seja ela longa ou curta. Já as armas de porte são aquelas que podem ser transportadas em coldre",
            ["Questions"] = {
                {"A", "Correta"},
                {"B", "Errado"},
                
            },
        },
        {
            Answer = 2,
            Title = "7. Com qual idade é permitido tirar o porte de armas?",
            ["Questions"] = {
                {"A", "17"},
                {"B", "18 "},
                {"C", "19"},
            },
        },
        {
            Answer = 2,
            Title = "8. O que acontece se eu for pego com uma arma mas não possuir porte?",
            ["Questions"] = {
                {"A", "Estará livre de problemas."},
                {"B", "Estará cometendo um crime inafiançável."},                
            },
        },
        {
            Answer = 4,
            Title = "9. Qual armamento é permitido usar com o porte de armas?",
            ["Questions"] = {
                {"A", "Pistolas e fuzis."},
                {"B", "Submetralhadores e fuzis."},
                {"C", "Fuzis e rifles de precisão. "},
                {"D", "Pistolas e submetralhadoras."},
                
            },
        },
        {
            Answer = 1,
            Title = "10. Os projéteis deformáveis são chamados genericamente de bala dundum e receberam esse nome por terem sido usados pela primeira vez pelos ingleses durante a guerra de independência da Índia, na localidade de Dum-Dum.",
            ["Questions"] = {
                {"A", "Correto."},
                {"B", "Incorreto."},
                
            },
        },
    },
}

formatNumber = function(number)   
    local formatted = number   
    while true do       
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2')     
        if ( k==0 ) then       
            break   
        end   
    end   
    return formatted 
end 

notifyS = function(player, message, type)
    return exports['guetto_notify']:showInfobox(player, type, message)
end

notifyC = function(message, type)
   return exports['guetto_notify']:showInfobox(type, message)
end

function removeHex(message)
	if (type(message) == "string") then
		while (message ~= message:gsub("#%x%x%x%x%x%x", "")) do
			message = message:gsub("#%x%x%x%x%x%x", "")
		end
	end
	return message or false
end

function puxarNome(player)
    return removeHex(getPlayerName(player))
end

function puxarID(player)
    return (getElementData(player, "ID") or 0)
end

function puxarConta(player)
    return getAccountName(getPlayerAccount(player))
end

function dadosMarker()
    return "cylinder", 1.1, 0, 0, 0, 90
end