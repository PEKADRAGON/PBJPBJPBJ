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
    exports['guetto_notify']:showInfobox(player, type, message)
end

notifyC = function(message, type)
    exports['guetto_notify']:showInfobox(type, message)
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

local tableAccents = {["à"] = "a",["á"] = "a",["â"] = "a",["ã"] = "a",["ä"] = "a",["ç"] = "c",["è"] = "e",["é"] = "e",["ê"] = "e",["ë"] = "e",["ì"] = "i",["í"] = "i",["î"] = "i",["ï"] = "i",["ñ"] = "n",["ò"] = "o",["ó"] = "o", ["ô"] = "o",["õ"] = "o",["ö"] = "o",["ù"] = "u",["ú"] = "u",["û"] = "u",["ü"] = "u",["ý"] = "y",["ÿ"] = "y",["À"] = "A",["Á"] = "A",["Â"] = "A",["Ã"] = "A",["Ä"] = "A",["Ç"] = "C",["È"] = "E",["É"] = "E",["Ê"] = "E",["Ë"] = "E",["Ì"] = "I",["Í"] = "I",["Î"] = "I",["Ï"] = "I",["Ñ"] = "N",["Ò"] = "O",["Ó"] = "O",["Ô"] = "O",["Õ"] = "O",["Ö"] = "O",["Ù"] = "U",["Ú"] = "U",["Û"] = "U",["Ü"] = "U",["Ý"] = "Y"}
function removeAccents(str)
	local noAccentsStr = ""
	for strChar in string.gfind(str, "([%z\1-\127\194-\244][\128-\191]*)") do
		if (tableAccents[strChar] ~= nil) then
			noAccentsStr = noAccentsStr..tableAccents[strChar]
		else
			noAccentsStr = noAccentsStr..strChar
		end
	end
	return noAccentsStr
end