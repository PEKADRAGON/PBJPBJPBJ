addEvent("MeloSCR:CopiarPos", true)
addEventHandler("MeloSCR:CopiarPos", root,
function (x, y, z)
    setClipboard(table.concat ( { math.round ( x, 3 ), math.round ( y, 3 ), math.round ( z, 3 ), int }, ', ' ))
end)

addEvent("MeloSCR:CopiarRot", true)
addEventHandler("MeloSCR:CopiarRot", root,
function (x, y, z)
    setClipboard(table.concat ( { math.round ( x, 3 ), math.round ( y, 3 ), math.round ( z, 3 ), int }, ', ' ))
end)

function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end

