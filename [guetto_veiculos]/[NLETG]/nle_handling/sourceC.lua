



local lastTick = getTickCount()
local s = {guiGetScreenSize()}

function getDefaultHandling(vehicleModel)
	if vehicleHandlings[vehicleModel] then
		return vehicleHandlings[vehicleModel]
	end
end