function getPlayerAclsVip ( player )
	for i = 1, #VIPS do 
		if isObjectInACLGroup("user."..getAccountName(getPlayerAccount(player)), aclGetGroup(VIPS[i])) then
			return true 
		end
	end
	return false
end

function startRes(res)
    if (res ~= getThisResource()) then return end

    for id, pro in pairs(WEAPONS_PROPERTIES) do
        for propertyName, propertyValue in pairs(pro["Properties"]) do
            local weaponName = getWeaponNameFromID(id)
            if (weaponName) then
                for _, player in ipairs(getElementsByType("player")) do
                    if getPlayerAclsVip(player) then
                        setWeaponProperty(weaponName:lower(), "pro", propertyName, propertyValue)
                        setWeaponProperty(weaponName:lower(), "std", propertyName, propertyValue)
                        setWeaponProperty(weaponName:lower(), "poor", propertyName, propertyValue)
                    end
                end
            end
        end
    end
end
addEventHandler("onResourceStart", getRootElement(), startRes)

local function reloadWeapon()
    reloadPedWeapon(client)
end
addEvent("relWep", true)
addEventHandler("relWep", root, reloadWeapon)
