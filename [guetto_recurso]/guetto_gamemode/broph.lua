local spawnpoints =
{
	{ 99999, 99999, 99999, 0 },
}

local vehicleDestroyTimers = {}
local validSkins = { 154 }
local playerVehicles = {}

local function spawn(player)
	if player and isElement(player) then
		local x,y,z,r = unpack(spawnpoints[math.random(1,#spawnpoints)])
		fadeCamera(player, true)
		setCameraTarget(player, player)
	end
end

local function onJoin()
	spawn(source)
end
local function initScript()
	resetMapInfo()
	local players = getElementsByType("player")
	for _,player in ipairs(players) do spawn(player) end
	addEventHandler("onPlayerJoin",root,onJoin)
end

addEventHandler("onResourceStart",resourceRoot,initScript)