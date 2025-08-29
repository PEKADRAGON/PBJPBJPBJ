function removeHex(s)
    local g, c = string.gsub, 0
    repeat
        s, c = g(s, '#%x%x%x%x%x%x', '')
    until c == 0
    return s
end