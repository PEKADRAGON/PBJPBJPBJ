entrar = createMarker(1833.016, -1125.637, 24.68-0.9, 'cylinder', 1.5, 255, 215, 0, 0)
blip = createBlip(1832.887, -1125.766, 24.68, 42)
local coolDown = {}

setElementData(entrar , 'markerData', {title = 'Montadora de veículos', desc = 'Inicie seu emprego!', icon = 'office'})

addEventHandler("onMarkerHit", entrar, 
function (player)
    if getElementType(player) == "player" then 
        triggerClientEvent(player, "startJobb", player)
    end 
end)

sair = createMarker(322.54031, 37.75314, 990.55627-0.9, 'cylinder', 1.5, 255, 215, 0, 0)
setElementData(sair , 'markerData', {title = 'Montadora de veículos', desc = 'Sair do trabalho!', icon = 'saida'})

function notifyS ( player, msg, type )
	return exports['guetto_notify']:showInfobox( player, type, msg )
end

addEventHandler("onMarkerHit", sair, 
function (player)
    if getElementType(player) == "player" then 
        triggerClientEvent(player, "endJobb", player)
    end 
end)

addEvent("OnPlayerSendMoney", true)
addEventHandler("OnPlayerSendMoney", resourceRoot, function (qnt)

    if not client then 
        return false 
    end

	if getElementData(client, "Emprego") ~= "Montadora" then
		return false
	end

    local isVip = exports["guetto_util"]:isPlayerVip(client)
    local money = isVip and math.random(3750, 4500) or math.random(2500, 3000)
    local expGain = isVip and 800 or 560
    local bonusText = isVip and " [BONUS]" or ""

    givePlayerMoney(client, money)
    local exp = (getElementData(client, "XP") or 0)
    setElementData(client, "XP", exp + expGain)
    notifyS(client, "Você ganhou R$ " .. money .. ",00" .. bonusText, "success")
end)

function setComponentVisible(vehicle, part, boolean)
	triggerClientEvent(root, "setComponentVisible", root, vehicle, part, boolean)
end

function setVehicleVisibleTo(vehicle, player)
	setElementData(vehicle, "vehicle:build:owner", player)
	triggerClientEvent(root, "loadPlayerVehicle", root, vehicle)
end

addEvent("setSkin", true)
addEventHandler("setSkin", resourceRoot, function(plr, skin)
	setElementModel(plr, skin)
end)

addEvent("startJob", true)
addEventHandler("startJob", resourceRoot, function(plr)
	toggleElementGhostmode(plr, true)
end)

addEvent("endJob", true)
addEventHandler("endJob", resourceRoot, function(plr)
	toggleElementGhostmode(plr, false)
end)

function toggleElementGhostmode(element, bool)
	if bool then
		ghost = createElement("ghostElement")
		setElementData(ghost, "ghostElement", element)
	else
		for k,v in pairs(getElementsByType("ghostElement")) do
			if getElementData(v, "ghostElement") == element then
				destroyElement(v)
			end
		end
	end
end
