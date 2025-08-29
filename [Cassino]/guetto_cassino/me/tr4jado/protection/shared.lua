local encodeRandom = 4 -- quanto maior, mais seguro, mais pesado (recomendado: 1-3)

function encode(str)
    local init = str

    if type(init) == 'table' then
        init = toJSON(str)
    end

    for i = 1, encodeRandom do
        init = base64Encode(init)
    end

    return init
end

function decode(str)
    local init = str

    for i = 1, encodeRandom do
        init = base64Decode(init)
    end

    return fromJSON(init) or init
end