function loadWeaponSkin(player, id, nome)
    if (nome) and (id) then
        local table = config.armas
        if isWeaponNameSkin(id, nome) == true then
            for i, v in ipairs(table) do 
                if tonumber(id) == tonumber(v.idWeapon) and nome == v.nameSkin then
                    if (getPedWeapon(player) ~= v.idWeapon) then config.notifyS(player, 'Equipe a arma para equipar a skin', 'error') return end
                    triggerClientEvent(root, 'setArmaStickerC', root, player, v.weaponName, v.imagem)
                    config.notifyS(player, 'Você equipou a skin ' .. (v.nameSkin) .. ' com sucesso.', 'success')
                    break
                end
            end
        end
    end
end

function isWeaponNameSkin(id, name)
    local table = config.armas

    value = false
    for i, v in ipairs(table) do 
        if tonumber(id) == tonumber(v.idWeapon) and name == v.nameSkin then 
            value = true
        end
    end
    return value

end