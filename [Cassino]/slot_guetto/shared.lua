slot = {
    candys = {
        {"banana", 0.7},
        {"grape", 0.10},
        {"watermelon", 0.5},
        {"plum", 0.2},
        {"apple", 0.5},
        {"blue", 0.1},
        {"green", 0.2},
        {"purple", 0.2},
        {"heart", 0.2},
        {"candy", 0.1},
    },
    multipliers = {
        {"low", 3, { {2, 2}, {3, 0.7}, {4, 0.6}, {5, 0.5}, {6, 0.4}, {7, 0.3} }},
        {"medium", 0.3, { {8, 0.3}, {9, 0.2}, {10, 0.4}, {11, 0.1}, {12, 0.3} }},
        {"high", 0.1, { {13, 0.2}, {14, 0.1}, {70, 0.1}, {80, 0}, {90, 0}, {100, 0} }},
    },
    multipliersvalue = 45, -- Quanto mais você aumenta a dificuldade de obter esse multiplicador, menos multiplicador você obtém.
    multipliersvaluefarm = 400, -- Quanto mais você aumenta a dificuldade de conseguir um multiplicador nesta fazenda, menos multiplicador você ganha.
    betindex = 1,
    bets = {100, 500, 1000},
    volume = true,
}

markers = {
   -- {-698.73309, 955.18433, 12.31808 - 0.9, 'cylinder',  1.5, 139, 100, 255, 0, int = 0, dim = 0};
   -- {-711.43390, 952.47455, 12.37015 - 0.9, 'cylinder',  1.5, 139, 100, 255, 0, int = 0, dim = 0};
}

candys = {
    sizes = {
        ["banana"] = {125, 125},
        ["grape"] = {125, 125},
        ["watermelon"] = {125, 125},
        ["plum"] = {125, 125},
        ["apple"] = {125, 125},
        ["blue"] = {125, 125},
        ["green"] = {150, 150},
        ["purple"] = {125, 125},
        ["heart"] = {125, 125},
        ["candy"] = {150, 150},

        ["low"] = {125, 125},
        ["medium"] = {130, 130},
        ["high"] = {145, 145},
    },
    profits = {
        ["banana"] = {{8, 9, 0.50}, {10, 11, 1.50}, {12, 999, 4}},
        ["grape"] = {{8, 9, 0.80}, {10, 11, 1.80}, {12, 999, 8}},
        ["watermelon"] = {{8, 9, 1}, {10, 11, 2}, {12, 999, 10}},
        ["plum"] = {{8, 9, 1.60}, {10, 11, 2.40}, {12, 999, 16}},
        ["apple"] = {{8, 9, 2}, {10, 11, 3}, {12, 999, 20}},
        ["blue"] = {{8, 9, 4}, {10, 11, 4}, {12, 999, 24}},
        ["green"] = {{8, 9, 10}, {10, 11, 10}, {12, 999, 30}},
        ["purple"] = {{8, 9, 20}, {10, 11, 20}, {12, 999, 50}},
        ["heart"] = {{8, 9, 50}, {10, 11, 50}, {12, 999, 100}},
        ["candy"] = {{3, 4, 6}, {5, 5, 10}, {6, 999, 200}},
    }
}


--
function table.flip(theTable)
    assert(type(theTable) == "table", "Bad argument @ 'table.flip' [Expected table at argument 1, got "..(type(theTable)).."]")
    local newTable = {}
    for i = 1, #theTable do
        newTable[i] = theTable[#theTable-(i-1)]
    end
    return newTable
end

function formatNumber(number)
    local sep = ","
	assert(type(tonumber(number))=="number", "Bad argument @'formatNumber' [Expected number at argument 1 got "..type(number).."]")
	assert(not sep or type(sep)=="string", "Bad argument @'formatNumber' [Expected string at argument 2 got "..type(sep).."]")
	local money = number
	for i = 1, tostring(money):len()/3 do
		money = string.gsub(money, "^(-?%d+)(%d%d%d)", "%1"..sep.."%2")
	end
	return money
end