local function blindar(vehicle, state)
    if (config["Gerais"]["BlindagemPorTiro"] == true) then
        if (state) and (vehicle) then
            if (state=="sim") then
                setVehicleDamageProof(vehicle, true)
                setElementData(vehicle, "VehBlindagem", config["Gerais"]["QuantiaDisparo"])
            elseif (state=="não") then
                setVehicleDamageProof(vehicle, false)
                removeElementData(vehicle, "VehBlindagem")
            end
        end
    elseif (config["Gerais"]["BlindagemPorTiro"] == false) then
        setVehicleDamageProof(vehicle, true)
    end
end

TimerA = {}

local function removerinvencibilidade(player)
	triggerClientEvent(player, "protegerPlayer", player, false)
end
addEventHandler ( "onVehicleExit", getRootElement(), removerinvencibilidade )

local function ativarinvencibilidade(player) 
	local vehicles = getPedOccupiedVehicle(player)
    if vehicles and isElement(vehicles) then 
        if getElementData(vehicles, "VehBlindagem") then
            triggerClientEvent(player, "protegerPlayer", player, true)
        end
    end
end
addEventHandler ("onVehicleEnter", getRootElement(), ativarinvencibilidade )