--##################################
--## Script feito por zJoaoFtw_   ##
--## Design feito por Golf        ##
--##################################

config = {
    ["Mensagem Start"] = true, --Caso esteja false ele não irá aparecer a mensagem!
    ["Marker Assaltar"] = {2484.286, 1038.98, 10.814},
    ["Markers Coletar"] = {
        {2476.649, 1053.652, 10.814}, -- 1
        {2474.691, 1053.754, 10.814}, -- 2
        {2472.393, 1053.815, 10.814}, -- 3
		{2469.866, 1053.879, 10.814}, -- 4
        {2470.082, 1047.924, 10.814}, -- 5
        {2472.348, 1047.903, 10.814}, -- 6
        {2474.643, 1047.855, 10.814}, -- 7
        {2476.903, 1047.996, 10.814}, -- 8
        {2491.506, 1053.8, 10.814}, -- 9
		
		{2493.709, 1053.706, 10.814}, -- 10
        {2496.085, 1053.734, 10.816}, -- 11
        {2498.463, 1053.758, 10.816}, -- 12
        {2498.779, 1047.824, 10.814}, -- 13
        {2496.159, 1047.873, 10.814}, -- 14
        {2493.98, 1047.853, 10.814}, -- 15
		{2491.6, 1047.836, 10.814}, -- 16
        {2491.569, 1036.03, 10.814}, -- 17
		{2493.767, 1036.118, 10.814}, -- 18

        {2495.816, 1036.079, 10.814}, -- 18
        {2498.439, 1036.04, 10.816}, -- 18
        {2498.345, 1030.02, 10.814}, -- 18
        {2496.009, 1030.072, 10.814}, -- 18
        {2493.634, 1030.081, 10.814}, -- 18
        {2491.646, 1030.045, 10.814}, -- 18
    },
    ["Markers Vender"] = {
        {-2430.64, 66.859, 35.172, "Everyone"},
        {-1587.417, 2650.123, 55.859, "Everyone"},
    },
    ["Joias"] = {
       --{"Rubi", {716, 318, 49, 42}, ":Script_inventory65/assets/images/itens/72.png", 72, 0, 15000},
       --{"Ouro", {716, 318, 49, 42}, ":Script_inventory65/assets/images/itens/73.png", 73, 0, 20000},
       --{"Prata", {716, 318, 49, 42}, ":Script_inventory65/assets/images/itens/75.png", 75, 0, 5000},
       --{"Ferro", {716, 318, 49, 42}, ":Script_inventory65/assets/images/itens/74.png", 74, 0, 5000},

        {"Tiara-de-Ouro", {716, 318, 49, 42}, ":guetto_inventory/assets/images/itens/85.png", 85, 0, 25000},
        {"Corrente-de-Ouro", {716, 318, 49, 42}, ":guetto_inventory/assets/images/itens/86.png", 86, 0, 20000},
        {"Correntinha-Falsa", {716, 318, 49, 42}, ":guetto_inventory/assets/images/itens/87.png", 87, 0, 13000},
        {"Aliança", {716, 318, 49, 42}, ":guetto_inventory/assets/images/itens/89.png", 89, 0, 5000},
        {"Anel-Maçon", {716, 318, 49, 42}, ":guetto_inventory/assets/images/itens/90.png", 90, 0, 15000},
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

local tableNumberAccents = { ["{"] = true, ["}"] = true, ["["] = true, ["]"] = true, ["!"] = true, ["@"] = true, ["#"] = true, ["$"] = true, ["%"] = true, ["¨"] = true, ["&"] = true, ["*"] = true, ["("] = true, [")"] = true, ["-"] = true, ["="] = true, ["_"] = true, ["+"] = true, ["/"] = true, ["\\"] = true, ["|"] = true, ["."] = true, [","] = true, ["<"] = true, [">"] = true, [":"] = true, [";"] = true, ["~"] = true, ["^"] = true, ["`"] = true, ["?"] = true, ['"'] = true,  ["'"] = true,  [' '] = true, ["Ç"] = true, ["ü"] = true, ["é"] = true, ["â"] = true, ["ä"] = true, ["à"] = true, ["å"] = true, ["ç"] = true, ["ê"] = true, ["ë"] = true, ["è"] = true, ["ï"] = true, ["î"] = true, ["ì"] = true, ["Ä"] = true, ["Å"] = true, ["É"] = true, ["æ"] = true, ["Æ"] = true, ["ô"] = true, ["ö"] = true, ["ò"] = true, ["û"] = true, ["ù"] = true, ["ÿ"] = true, ["Ö"] = true, ["Ü"] = true, ["¢"] = true, ["£"] = true, ["¥"] = true, ["₧"] = true, ["ƒ"] = true, ["á"] = true, ["í"] = true, ["ó"] = true, ["ú"] = true, ["ñ"] = true, ["Ñ"] = true, ["ª"] = true, ["º"] = true, ["¿"] = true, ["⌐"] = true, ["¬"] = true, ["½"] = true, ["¼"] = true, ["¡"] = true, ["«"] = true, ["»"] = true, ["░"] = true, ["▒"] = true, ["▓"] = true, ["│"] = true, ["┤"] = true, ["╡"] = true, ["╢"] = true, ["╖"] = true, ["╕"] = true, ["╣"] = true, ["║"] = true, ["╗"] = true, ["╝"] = true, ["╜"] = true, ["╛"] = true, ["┐"] = true, ["└"] = true, ["┴"] = true, ["┬"] = true, ["├"] = true, ["─"] = true, ["┼"] = true, ["╞"] = true, ["╟"] = true, ["╚"] = true, ["╔"] = true, ["╩"] = true, ["╦"] = true, ["╠"] = true, ["═"] = true, ["╬"] = true, ["╧"] = true, ["╨"] = true, ["╤"] = true, ["╥"] = true, ["╙"] = true, ["╘"] = true, ["╒"] = true, ["╓"] = true, ["╫"] = true, ["╪"] = true, ["┘"] = true, ["┌"] = true, ["█"] = true, ["▄"] = true, ["▌"] = true, ["▐"] = true, ["▀"] = true, ["α"] = true, ["ß"] = true, ["Γ"] = true, ["π"] = true, ["Σ"] = true, ["σ"] = true, ["µ"] = true, ["τ"] = true, ["Φ"] = true, ["Θ"] = true, ["Ω"] = true, ["δ"] = true, ["∞"] = true, ["φ"] = true, ["ε"] = true, ["∩"] = true, ["≡"] = true, ["±"] = true, ["≥"] = true, ["≤"] = true, ["⌠"] = true, ["⌡"] = true, ["÷"] = true, ["≈"] = true, ["°"] = true, ["∙"] = true, ["·"] = true, ["√"] = true, ["ⁿ"] = true, ["²"] = true, ["■"] = true, ["´"] = true, ["à"] = true, ["á"] = true, ["â"] = true, ["ã"] = true, ["ä"] = true, ["ç"] = true, ["è"] = true, ["é"] = true, ["ê"] = true, ["ë"] = true, ["ì"] = true, ["í"] = true, ["î"] = true, ["ï"] = true, ["ñ"] = true, ["ò"] = true, ["ó"] = true, ["ô"] = true, ["õ"] = true, ["ö"] = true, ["ù"] = true, ["ú"] = true, ["û"] = true, ["ü"] = true, ["ý"] = true, ["ÿ"] = true, ["À"] = true, ["Á"] = true, ["Â"] = true, ["Ã"] = true, ["Ä"] = true, ["Ç"] = true, ["È"] = true, ["É"] = true, ["Ê"] = true, ["Ë"] = true, ["Ì"] = true, ["Í"] = true, ["Î"] = true, ["Ï"] = true, ["Ñ"] = true, ["Ò"] = true, ["Ó"] = true, ["Ô"] = true, ["Õ"] = true, ["Ö"] = true, ["Ù"] = true, ["Ú"] = true, ["Û"] = true, ["Ü"] = true, ["Ý"] = true,}
function verifyNumber(str)
    local noAccentsStr = false
    for strChar in string.gfind(str, "([%z\1-\127\194-\244][\128-\191]*)") do
        if (tableNumberAccents[strChar]) then
            noAccentsStr = tableNumberAccents[strChar]
        end
    end
    return noAccentsStr
end