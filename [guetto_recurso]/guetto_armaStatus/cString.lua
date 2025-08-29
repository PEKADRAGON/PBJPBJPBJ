-- Recol armas
-- function onClientStartResource()
--     for id, pro in pairs(WEAPONS_PROPERTIES) do
--         for propertyName, propertyValue in pairs(pro) do
-- 			local weaponName = getWeaponNameFromID(id)
-- 			if (weaponName) then
--             	setWeaponProperty(weaponName:lower(), _, propertyName, propertyValue)
-- 			end
--         end
--     end
-- end
-- addEventHandler("onClientResourceStart", resourceRoot, onClientStartResource)

-- Sons armas
local distance = 200
local explostionDistance = 150

function playSounds(weapon, ammo, ammoInClip)
	if (cSoundsEnabled) then
		local x, y, z = getElementPosition(source)
		if (weapon == 31) then -- AR-15
			if (ammoInClip == 0 and reloadSoundEnabled) then
				mgReload("assets/sounds/weapon/m4.wav", x, y, z)
			else
				local sound = playSound3D("assets/sounds/weapon/m4.wav", x, y, z)
				setSoundMaxDistance(sound, distance)
			end
		elseif (weapon == 22) then --pistol
			if (ammoInClip == 0 and reloadSoundEnabled) then
			    
				pistolReload("assets/sounds/weapon/pistole.wav", x, y, z)
			else
				local sound = playSound3D("assets/sounds/weapon/pistole.wav", x, y, z)
				setSoundMaxDistance(sound, distance)
			end
		elseif (weapon == 24) then -- Deagle
			if (ammoInClip == 0 and reloadSoundEnabled) then
				pistolReload("assets/sounds/weapon/deagle.wav", x, y, z)
			else
				local sound = playSound3D("assets/sounds/weapon/deagle.wav", x, y, z)
				setSoundMaxDistance(sound, distance)
			end
		elseif (weapon == 25 or weapon == 26 or weapon == 27) then -- Shotguns
			if (weapon == 25) then
				local sound = playSound3D("assets/sounds/weapon/shotgun.wav", x, y, z)
				setSoundMaxDistance(sound, distance)
				shotgunReload(x,y,z)
			else
				local sound = playSound3D("assets/sounds/weapon/shotgun.wav", x, y, z)
				local shellSound = playSound3D("assets/sounds/reload/shotgun_shell.wav", x, y, z)
				setSoundMaxDistance(sound, distance)
			end
		elseif (weapon == 28) then -- UZI
			if (ammoInClip == 0) then						
				mgReload("assets/sounds/weapon/uzi.wav", x, y, z)
			else
				local sound = playSound3D("assets/sounds/weapon/uzi.wav", x, y, z)
				setSoundMaxDistance(sound, distance)
			end
		elseif (weapon == 29) then -- MP5
			if (ammoInClip == 0 and reloadSoundEnabled) then
				mgReload("assets/sounds/weapon/mp5.wav", x,y,z)
			else
				local sound = playSound3D("assets/sounds/weapon/mp5.wav", x,y,z)
				setSoundMaxDistance(sound, distance)
			end
		elseif (weapon == 32) then -- Tec-9
			if (ammoInClip == 0) then						
				tec9Reload(x,y,z)
			else
				local sound = playSound3D("assets/sounds/weapon/tec-9.wav", x, y, z)
				setSoundMaxDistance(sound, distance)
			end
		elseif (weapon == 30) then -- AK-47
			if (ammoInClip == 0 and reloadSoundEnabled) then
				mgReload("sounds/weapon/ak.wav", x,y,z)
			else
				local sound = playSound3D("assets/sounds/weapon/ak.wav", x, y, z)
				setSoundMaxDistance(sound, distance)
			end
		elseif (weapon == 33 or weapon == 34) then -- Sniper
			local sound = playSound3D("assets/sounds/weapon/sniper.wav", x, y, z)
			setSoundMaxDistance(sound, distance)
		end
	end
end
addEventHandler("onClientPlayerWeaponFire", getRootElement(), playSounds)

local blockedTasks = {
    ["TASK_SIMPLE_JUMP"] = true,
    ["TASK_SIMPLE_LAND"] = true,
    ["TASK_SIMPLE_SWIM"] = true,
    ["TASK_SIMPLE_FALL"] = true,
    ["TASK_SIMPLE_CLIMB"] = true,
    ["TASK_SIMPLE_GET_UP"] = true,
    ["TASK_SIMPLE_IN_AIR"] = true,
    ["TASK_SIMPLE_HIT_HEAD"] = true,
    ["TASK_SIMPLE_NAMED_ANIM"] = true,
    ["TASK_SIMPLE_CAR_GET_IN"] = true,
    ["TASK_SIMPLE_GO_TO_POINT"] = true,
    ["TASK_SIMPLE_CAR_OPEN_DOOR_FROM_OUTSIDE"] = true,
}

local function reloadTimer()
    if (blockedTasks[getPedSimplestTask(localPlayer)]) then return end
	if (isPedAiming(localPlayer)) then return end

	local weapon = localPlayer:getWeapon() or 0
	local weaponClip = getPedAmmoInClip(getLocalPlayer(), getPedWeaponSlot(getLocalPlayer()))

	if not (WEAPONS_PROPERTIES[weapon]) then return end
	if not (WEAPONS_PROPERTIES[weapon]["Properties"]) then return end
	if not (WEAPONS_PROPERTIES[weapon]["Properties"]["maximum_clip_ammo"]) then return end
	if (weaponClip == WEAPONS_PROPERTIES[weapon]["Properties"]["maximum_clip_ammo"]) then return end
	
	triggerServerEvent("relWep", localPlayer)
	if (reloadSoundEnabled) then
		local weapon = localPlayer:getWeapon() or 0
		local x, y, z = getElementPosition(localPlayer)
		if (weapon == 32) then -- Tec-9					
			tec9Reload(x, y, z)
		end

		if (weapon == 31) then -- AR-15
			weaponReload(x, y, z)
		end
		
		if (weapon == 30) then -- AK-47
			weaponReload(x, y, z)
		end

		if (weapon == 29) then -- MP5
			weaponReload(x, y, z)
		end

		if (weapon == 28) then -- UZI				
			weaponReload(x, y, z)
		end

		if (weapon == 24) then -- Deagle
			pistolReload(nil, x, y, z)
		end

		if (weapon == 22) then --pistol
			pistolReload(nil, x, y, z)
		end

		if (weapon == 25 or weapon == 26 or weapon == 27) then
			shotgunReload(x, y, z)
		end
	end
end

local function reloadWeapon()
	local weapon = localPlayer:getWeapon() or 0
    if (weapon == 0) then return end

	local weaponClip = getPedAmmoInClip(getLocalPlayer(), getPedWeaponSlot(getLocalPlayer()))
    local weaponAmmo = getPedTotalAmmo(getLocalPlayer()) - getPedAmmoInClip(getLocalPlayer())

	setTimer(reloadTimer, 50, 1)
end
bindKey("r", "down", reloadWeapon)

function mgReload(soundPath, x, y, z)
	local sound = playSound3D(soundPath, x, y, z)
	setSoundMaxDistance(sound, distance)
				
	local clipinSound = playSound3D("assets/sounds/reload/mg_clipin.wav", x, y, z)
	setTimer(function()
		local relSound = playSound3D("assets/sounds/reload/mg_clipin.wav", x, y, z)
	end, 1250, 1)
end

reloadSound = false
function weaponReload(x, y, z)
	if not (isSoundFinished(reloadSound)) then return end

	reloadSound = playSound3D("assets/sounds/reload/mg_clipin.wav", x, y, z)
	setTimer(function()
		reloadSound = playSound3D("assets/sounds/reload/mg_clipin.wav", x, y, z)
	end, 1250, 1)
end

function tec9Reload(x, y, z)
	local sound = playSound3D("assets/sounds/weapon/tec-9.wav", x, y, z)
	setSoundMaxDistance(sound, distance)
				
	local clipinSound = playSound3D("assets/sounds/reload/mg_clipin.wav", x, y, z)
	setTimer(function()
		local relSound = playSound3D("assets/sounds/reload/mg_clipin.wav", x, y, z)
	end, 1000, 1)
end

function pistolReload(soundPath, x,y,z)
	if (soundPath) then
		local sound = playSound3D(soundPath, x, y, z)
		setSoundMaxDistance(sound, distance)
	end
	setTimer(function()
		local relSound = playSound3D("assets/sounds/reload/pistol_reload.wav", x, y, z)
	end, 500, 1)
end

function shotgunReload(x,y,z)
	setTimer(function()
		local relSound = playSound3D("assets/sounds/reload/shotgun_reload.wav", x, y, z)
		local shellSound = playSound3D("assets/sounds/reload/shotgun_shell.wav", x, y, z)
	end, 500, 1)
end

function clientExplosion(x, y, z, theType)
    if (explosionEnabled) then
        if (theType == 0) then -- Granada
            local explSound = playSound3D("assets/sounds/explosion/explosion1.wav", x,y,z)
            setSoundMaxDistance(explSound, explostionDistance)
        elseif (theType == 4 or theType == 5 or theType == 6 or theType == 7) then --car, car quick, boat, heli
            local explSound = playSound3D("assets/sounds/explosion/explosion3.wav", x,y,z)
            setSoundMaxDistance(explSound, explostionDistance)
        end
    end
end
addEventHandler("onClientExplosion", getRootElement(), clientExplosion)

--[[

-- Texturas armas
txd = engineLoadTXD("assets/models/ak47.txd") 
engineImportTXD( txd, 355 ) 
dff = engineLoadDFF("assets/models/ak47.dff", 355) 
engineReplaceModel( dff, 355 )

txd = engineLoadTXD("assets/models/ar15.txd", 356)
engineImportTXD(txd, 356)
dff = engineLoadDFF("assets/models/ar15.dff", 356)
engineReplaceModel(dff, 356)

txd = engineLoadTXD("assets/models/shotgun.txd") 
engineImportTXD(txd, 349) 
dff = engineLoadDFF("assets/models/shotgun.dff", 349) 
engineReplaceModel(dff, 349)

txd = engineLoadTXD("assets/models/mp5.txd") 
engineImportTXD(txd, 353) 
dff = engineLoadDFF("assets/models/mp5.dff", 353) 
engineReplaceModel(dff, 353)

txd = engineLoadTXD("assets/models/glock2.txd") 
engineImportTXD(txd, 352) 
dff = engineLoadDFF("assets/models/glock2.dff", 352) 
engineReplaceModel(dff, 352)

txd = engineLoadTXD("assets/models/glock.txd") 
engineImportTXD(txd, 346) 
dff = engineLoadDFF("assets/models/glock.dff", 346) 
engineReplaceModel(dff, 346)

txd = engineLoadTXD("assets/models/usp.txd") 
engineImportTXD(txd, 347 ) 
dff = engineLoadDFF("assets/models/usp.dff", 347) 
engineReplaceModel(dff, 347)

txd = engineLoadTXD("assets/models/sniper.txd") 
engineImportTXD(txd, 358) 
dff = engineLoadDFF("assets/models/sniper.dff", 358) 
engineReplaceModel(dff, 358)

txd = engineLoadTXD("assets/models/sniper2.txd") 
engineImportTXD(txd, 357) 
dff = engineLoadDFF("assets/models/sniper2.dff", 357) 
engineReplaceModel(dff, 357)

txd = engineLoadTXD("assets/models/deagle.txd") 
engineImportTXD(txd, 348) 
dff = engineLoadDFF("assets/models/deagle.dff", 348) 
engineReplaceModel(dff, 348)

txd = engineLoadTXD("assets/models/tec9.txd") 
engineImportTXD(txd, 372) 
dff = engineLoadDFF("assets/models/tec9.dff", 372) 
engineReplaceModel(dff, 372)

txd = engineLoadTXD("assets/models/jetpack.txd") 
engineImportTXD(txd, 370) 
dff = engineLoadDFF("assets/models/jetpack.dff", 370) 
engineReplaceModel(dff, 370)


]]

-- UTILS
function isPedAiming (thePedToCheck)
	if isElement(thePedToCheck) then
		if getElementType(thePedToCheck) == "player" or getElementType(thePedToCheck) == "ped" then
			if getPedTask(thePedToCheck, "secondary", 0) == "TASK_SIMPLE_USE_GUN" or isPedDoingGangDriveby(thePedToCheck) then
				return true
			end
		end
	end
	return false
end

function isSoundFinished(theSound)
	if not (theSound) then
		return true
    end
	
	if not (getSoundPosition(theSound)) then
		return true
	end
	
	if not (getSoundLength(theSound)) then
		return true
	end

	return (getSoundPosition(theSound) == getSoundLength(theSound))
end



local position = false;
local startTick = false;

onPlayerFire = function(w, a, aC, hX, hY, hZ, hE)
    local sx, sy, sz = getPedWeaponMuzzlePosition(source)
    position = {sx, sy, sz, hX, hY, hZ}
    startTick = getTickCount()

    removeEventHandler("onClientRender", root, onRender)
    addEventHandler("onClientRender", root, onRender)

end
addEventHandler("onClientPlayerWeaponFire", root, onPlayerFire)


onRender = function()
    if position then

        local OnFireDraw = getElementData(localPlayer, "FireOn") or false
        if(getPedWeapon(localPlayer) == 37) or (getPedWeapon(localPlayer) == 36) or (getPedWeapon(localPlayer) == 35) then
        return end;
        if OnFireDraw == false then
        return end;

        local startX, startY, startZ, endX, endY, endZ = unpack(position)
        local newX, newY, newZ = interpolateBetween(startX, startY, startZ, endX, endY, endZ, (getTickCount() - startTick) / 150, "Linear")

        dxDrawLine3D(newX, newY, newZ, endX, endY, endZ, tocolor(249, 255, 61, 255), 2.5)

    end
end