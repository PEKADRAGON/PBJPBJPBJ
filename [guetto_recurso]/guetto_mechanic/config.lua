DOORS = {
    [0] = 'Capô',
    [1] = 'Porta-Malas',
    [2] = 'Porta frente esquerda',
    [3] = 'Porta frente direita',
    [4] = 'Porta traseira esquerda',
    [5] = 'Porta traseira direita'
}

LIGHT = {
    [0] = 'Farol esquerda',
    [1] = 'Farol direita'
}

PANELS = {
    [0] = 'Painel frontal esquerdo',
    [1] = 'Painel frontal direito',
    [2] = 'Painel traseiro esquerdo',
    [3] = 'Painel traseiro direito',
    [4] = 'Para-brisa',
    [5] = 'Para-choque dianteiro',
    [6] = 'Para-choque traseiro'
}

TIRE = {
    [0] = 'Pneu dianteiro esquerdo',
    [1] = 'Pneu dianteiro direito',
    [2] = 'Pneu traseiro esquerdo',
    [3] = 'Pneu traseiro direito'
}


notify = {
    server = function(player, message, type)
        return exports['guetto_notify']:showInfobox(player, type, message)
    end,
}

Player.getID = function(self)
    return self:getData('ID') or 0
end

Player.isPermission = function(self, permission)
    if not permission then
        return false
    end

    if type(permission) == 'string' then
        permission = {permission}
    end

    for _, v in ipairs(permission) do
        if ACLGroup.get(v):doesContainObject('user.' .. getAccountName(getPlayerAccount(self))) then
            return true
        end
    end

    return false
end

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