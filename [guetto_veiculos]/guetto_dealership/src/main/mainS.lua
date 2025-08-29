local estoques = {}
local delay = {}
local drive = { }
local dimension = 1

addEventHandler('onResourceStart', resourceRoot,
    function ( )
        database = dbConnect('sqlite', 'src/database/database.db')

        if not database or not isElement(database) then 
            return print ('guetto_dealership | database is failed connected!')
        end
    
        dbExec(database, "CREATE TABLE IF NOT EXISTS `Estoque`(Model `TEXT NOT NULL`, Categoria `TEXT NOT NULL`, Estoque `TEXT NOT NULL`)")
        dbExec(database, "CREATE TABLE IF NOT EXISTS `Garagem`(ID INTEGER PRIMARY KEY AUTOINCREMENT, accountName `TEXT NOT NULL`, model `TEXT NOT NULL`, state `TEXT NOT NULL`, seguro `TEXT NOT NULL`, IPVA `TEXT NOT NULL`, infos `JSON NOT NULL`, dados `JSON NOT NULL`, plate `TEXT NOT NULL`)")
        dbExec(database, "CREATE TABLE IF NOT EXISTS `Slots` (accountName `TEXT NOT NULL`, Slots `TEXT NOT NULL` )")
        dbExec(database, "CREATE TABLE IF NOT EXISTS `Slots_Buy` (accountName `TEXT NOT NULL`, Slots `TEXT NOT NULL` )")
    
        for index, v in ipairs ( config['Others'].categorys ) do 
            if not estoques[v] then 
                estoques[v] = { }
            end
            for i, value in ipairs ( config.vehicles[v] ) do 
                local result = dbPoll(dbQuery(database, "SELECT * FROM `Estoque` WHERE `Model` = ?", value.model), - 1)
                if (result and #result == 0) then 
                    dbExec(database, "INSERT INTO `Estoque` VALUES (?, ?, ?)", value.model, v, value.stock)
                    estoques[v][#estoques[v] + 1] = {
                        Estoque = value.stock,
                        Categoria = v,
                        Model = value.model
                    }
                else
                    local query = dbPoll(dbQuery(database, 'SELECT * FROM `Estoque` WHERE `Model` = ?', value.model), - 1)
                    estoques[v][#estoques[v] + 1] = query[1]
                end
            end
        end

        local query = dbPoll(dbQuery(database, 'SELECT * FROM `Garagem`'), - 1)



        for i, v in ipairs (query) do 
            local json = fromJSON(v['infos'])

            if json[4] == 'coins' then 
                local data = getVehicleConfigFromModel(tonumber(v['model']))
                local targetValue = data.coins and data.coins * 10000 or data.money 
                dbExec(database, "UPDATE `Garagem` SET `infos` = ? WHERE `accountName` = ? AND `model` = ?", toJSON({data.name, targetValue, data.brand, 'coins'}), v['accountName'], v['model'])
            end
          
        end

    end
)


for i, v in ipairs ( config.positions["dealership"] ) do 
    local marker_conce = createMarker(v[1], v[2], v[3] - 0.9, 'cylinder', 1.5, 139, 100, 255, 0)
    createBlipAttachedTo(marker_conce, 55)
    setElementData(marker_conce , 'markerData', {title = 'Concessionária', desc = 'Compre aqui seu veículo!', icon = 'exchange'})
    addEventHandler('onMarkerHit', marker_conce,  
        function ( player, dim )
            if player and isElement(player) and getElementType(player) == 'player' and dim then 
                if not isPedInVehicle(player) then 
                    triggerClientEvent ( player, 'onPlayerDrawDealerShip', resourceRoot, estoques )
                end
            end
        end
    )
end

function getDb()
    return database
end

function getVehicleDadosFromPlate ( plate )
    if not plate then 
        return false 
    end
    local result = dbPoll(dbQuery(database, 'SELECT * FROM `Garagem` WHERE `plate` = ? ', plate), - 1)
    return result
end


local shape = createColSphere ( config['Test-Drive']['spawn'][1], config['Test-Drive']['spawn'][2], config['Test-Drive']['spawn'][3], config['Test-Drive']['radius'] )

function getPlayerVehicle ( player, model )
    if not player then 
        return false 
    end

    if not model then 
        return false 
    end

    local query = dbPoll(dbQuery(database, 'SELECT * FROM `Garagem` WHERE `accountName` = ? AND `model` = ?', getAccountName(getPlayerAccount(player)), tonumber(model)), - 1)

    if #query == 0 then 
        return false 
    end

    return true 
end


function getPlayerVehicles ( player )
    if not player then 
        return false 
    end

    return dbPoll(dbQuery(database, 'SELECT * FROM `Garagem` WHERE `accountName` = ?', getAccountName(getPlayerAccount(player))), - 1) 
end


function getCountSlots ( player )
    if not player then 
        return false 
    end

    local account = getAccountName(getPlayerAccount(player))
    local query = dbPoll(dbQuery(database, 'SELECT * FROM `Slots_Buy` WHERE `accountName` = ?', account), - 1)
    local slots = getPlayerSlots(player) or 2;

    if #query == 0 then return slots end

    return slots + tonumber(query[1].Slots)
end

function getPlayerSlots ( player )

    if not player then 
        return false
    end

    local accountName = getAccountName(getPlayerAccount(player))

    for i, v in ipairs ( config['Others'].vips ) do 
        
        if isObjectInACLGroup('user.'..accountName, aclGetGroup(v)) then 
            return config["Slots"][v]
        end

    end

    return false 
end


function getPlayerTotalVehicles ( player )
    if not player then 
        return false 
    end

    local account = getAccountName(getPlayerAccount(player))
    local query = dbPoll(dbQuery(database, 'SELECT * FROM `Garagem` WHERE `accountName` = ?', account), - 1)

    return #query
end

function isVehicleSpawned (id)
    if not id then 
        return false 
    end

    local result = false 

    for i, v in ipairs ( getElementsByType ( 'vehicle' ) ) do 
        if (getElementData(v, 'Guh.VehicleID') == id) then 
            result = v 
        end
    end

    return result
end

function closeDealerShip ( player )
    if not player then 
        return false 
    end
    return triggerClientEvent(player, 'onClientCloseDealerShip', resourceRoot)
end

addEvent('onPlayerBuyVehicle', true)
addEventHandler('onPlayerBuyVehicle', resourceRoot,
    function (data, color)

        if not client then 
            return false 
        end

        if source ~= getResourceDynamicElementRoot(getThisResource()) then 
            return outputDebugString( " Resource | ".. (getResourceName(getThisResource())).." | ".. (getPlayerName(client)).." # "..(getElementData(client, 'ID') or "N/A").." | Serial | "..getPlayerSerial(client).."  | IP | "..(getPlayerIP(client)).."", 1 )
        end

        if (delay[client] and getTickCount ( ) - delay[client] <= config["Actions"]["delay"]) then return config.sendMessageServer(client, 'Aguarde!', 'error') end 

        local method = data.coins and data.coins or data.money and data.money
        local estoque = dbPoll(dbQuery(database, 'SELECT * FROM `Estoque` WHERE `Model` = ?', data.model), -1)
           
        if tonumber(estoque[1].Estoque) <= 0 then 
            return config.sendMessageServer(client, 'Esse veículo não possui estoque disponível!', 'error')
        end

        if (getPlayerVehicle(client, tonumber(data.model))) then 
            return config.sendMessageServer(client, 'Você já possui esse veículo em sua garagem!', 'error')
        end

        if (getPlayerTotalVehicles(client) + 1 > getCountSlots(client)) then 
            return config.sendMessageServer(client, 'Você não possui mais espaço na sua garagem!', 'error')
        end

        if data.coins then 
            if getElementData(client, 'guetto.points') < method  then 
                return config.sendMessageServer(client, 'Você não possui coins suficientes!', 'error')
            end
            setElementData(client, 'guetto.points', (getElementData(client, 'guetto.points') or 0) - method)
        end
        
        if data.money then 
            if getPlayerMoney(client) < method then 
                return config.sendMessageServer(client, 'Você não possui dinheiro suficientes!', 'error')
            end
            takePlayerMoney(client, method)
        end

        dados_veh = { vida = 1000, gasolina = 100, tunagem = {}, color = color, light = {255, 255, 255}, malas = {}, multas = 0 }
        
        dbExec(database, 'INSERT INTO `Garagem` (`accountName`, `model`, `state`, `seguro`, `IPVA`, `infos`, `dados`, `plate`) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', getAccountName(getPlayerAccount(client)), data.model, "guardado", "Não", (getRealTime().timestamp)+604800, toJSON({data.name, method, data.brand, data.coins and 'coins' or data.money and 'money'}), toJSON({dados_veh}), 'SEM PLACA')
        dbExec(database, "UPDATE `Estoque` SET `Estoque` = ? WHERE `Model` = ?", tonumber(estoque[1].Estoque) - 1, data.model)

        if data.money then 
            config.sendMessageServer(client, 'Você comprou um '..data.name..' por R$ '.. formatNumber(data.money, '.') ..' com sucesso!', 'success')
        end
        
        if data.coins then 
            config.sendMessageServer(client, 'Você comprou um '..data.name..' pro GP '.. formatNumber(data.coins, '.') ..' com sucesso!', 'success')
        end

        closeDealerShip(client)
    end
)

function setVehicleGaragem ( player, name, brand, model, type_vehicle )
    if player and isElement(player) and model and type_vehicle then 
        if not (getPlayerVehicle(player, tonumber(model))) then 
            local settings = getVehicleConfigFromModel (tonumber(model))
            if settings then 
                local targetValue = settings.coins and settings.coins * 10000 or settings.money 
                dados_veh = { vida = 1000, gasolina = 100, tunagem = {}, color = color, light = {255, 255, 255}, malas = {}, multas = 0 }
                dbExec(database, 'INSERT INTO `Garagem` (`accountName`, `model`, `state`, `seguro`, `IPVA`, `infos`, `dados`, `plate`) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', getAccountName(getPlayerAccount(player)), model, "guardado", "Não", (getRealTime().timestamp)+604800, toJSON({name, targetValue, brand, type_vehicle}), toJSON({dados_veh}), 'SEM PLACA')
                return true
            end
        end
    end
    return false 
end


local drive_cache = {}

function isPlayerInDriveTest ( player )
    if not player then 
        return false 
    end

    return drive[player] and true or false 
end

function stopTestDrive ( player )
    if not player then 
        return false 
    end

    if not isPlayerInDriveTest(player) then 
        return false 
    end

    if isElement(drive[player].vehicle) then
        destroyElement(drive[player].vehicle)
    end

    if isTimer(drive[player].timer) then 
        killTimer(drive[player].timer)
    end
    
    setElementDimension(player, 0)

    setTimer(function(player)
        setElementPosition(player, drive_cache[player][1], drive_cache[player][2], drive_cache[player][3])
    end, 1000, 1, player)
    
    drive[player] = nil 
    dimension = dimension - 1
end

addEvent('onDealerShipDrive', true)
addEventHandler('onDealerShipDrive', resourceRoot,
    function ( data )
        if not client then 
            return false 
        end

        if source ~= getResourceDynamicElementRoot(getThisResource()) then 
            return outputDebugString( " Resource | ".. (getResourceName(getThisResource())).." | ".. (getPlayerName(client)).." # "..(getElementData(client, 'ID') or "N/A").." | Serial | "..getPlayerSerial(client).."  | IP | "..(getPlayerIP(client)).."", 1 )
        end

        if (isPlayerInDriveTest(player)) then 
            return config.sendMessageServer(client, 'Você já está em um test-drive!', 'error')
        end

        drive[client] = {}
        drive_cache[client] = {getElementPosition(client)}
        drive[client].vehicle = createVehicle(data.model, config['Test-Drive']['spawn'][1], config['Test-Drive']['spawn'][2], config['Test-Drive']['spawn'][3], config['Test-Drive']['spawn'][4], config['Test-Drive']['spawn'][5], config['Test-Drive']['spawn'][6] )
        
        warpPedIntoVehicle(client, drive[client].vehicle)
        setElementDimension(client, dimension)
        
        dimension = dimension + 1

        drive[client].timer = setTimer(function(player)
            stopTestDrive(player)
            config.sendMessageServer(player, 'Seu test-drive foi finalizado!', 'info')
        end, config['Test-Drive']['time'] * 60000, 1, client)

        config.sendMessageServer(client, 'Você iniciou o test-drive!', 'info')
    end
)

addEventHandler('onColShapeLeave', shape,
    function ( element, dimension )
        if (element and isElement(element) and getElementType(element) == 'player') then 
            if isPedInVehicle(element) then 
                if isPlayerInDriveTest(element) then 
                    stopTestDrive(element)
                    config.sendMessageServer(element, 'Você saiu da area e seu test-drive foi cancelado!', 'error')
                end
            end
        end
    end
)

addEventHandler('onPlayerQuit', root,
    function ( )
        stopTestDrive(source)
    end
)

addEventHandler('onVehicleExit', root, function (player)
    if isPlayerInDriveTest(player) then 
        stopTestDrive(player)
    end
end)

addEventHandler('onPlayerWasted', root, function ()
    if isPlayerInDriveTest(source) then 
        stopTestDrive(source)
    end
end)

addCommandHandler("changestate", function(player)
    if isObjectInACLGroup("user."..getAccountName(getPlayerAccount(player)), aclGetGroup("Console")) then 
        dbExec(database, "UPDATE `Garagem` SET `state` = ?", 'guardado')
    end
end)

addCommandHandler('deletevehicles', function(player, cmd, account)
    if isObjectInACLGroup("user."..getAccountName(getPlayerAccount(player)), aclGetGroup("Console")) then 
        if not account then return config.sendMessageServer(player, 'Digite a conta do jogador!', 'error') end;
        local qh = dbPoll(dbQuery(database, 'SELECT * FROM `Garagem` WHERE `accountName` = ?', account), -1)
        if #qh == 0 then return config.sendMessageServer(player, 'Conta não encontrada!', 'error') end;
        dbExec(database, 'DELETE FROM `Garagem` WHERE `accountName` = ?', account)
        config.sendMessageServer(player, 'Você deletou todos os veículos do jogador!', 'info')
    end
end)

local dados_veh = {}

for i, v in ipairs ( config.positions["garage"] ) do
    local marker_garagem = createMarker(v.marker[1], v.marker[2], v.marker[3] - 0.9, 'cylinder', 1.5, 139, 100, 255, 0)
    setElementData(marker_garagem, 'markerData', {title = 'Garagem', desc = 'Retire aqui seu veículo!', icon = 'garage'})
    createBlipAttachedTo(marker_garagem, 46)
    addEventHandler('onMarkerHit', marker_garagem,  
        function ( player, dim )
            if player and isElement(player) and getElementType(player) == 'player' and dim then 
                local query = dbPoll(dbQuery(database, 'SELECT * FROM `Garagem` WHERE `accountName` = ?', getAccountName(getPlayerAccount(player))), - 1)
                if #query == 0 then return config.sendMessageServer(player, 'Você não possui veículos em sua garagem!', 'error') end 
                local slots = getCountSlots (player) 
                triggerClientEvent(player, 'onPlayerDrawGaragem', resourceRoot, query, slots, i)
            end
        end
    )
end

function getVehicleProxFromID ( player, id )
    if not player then return false end 
    if not id then return false end 

    local x, y, z = getElementPosition(player)
    local result = false 

    for i, v in ipairs ( getElementsByType ('vehicle') ) do 
        local x2, y2, z2 = getElementPosition ( v )
        local distance = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)

        if distance <= 8 and getElementData(v, 'Guh.VehicleID') == id then 
            result = v
        end

    end
    return result
end

function getVehicleOwner ( vehicle )
    if dados_veh[vehicle] then 
        return dados_veh[vehicle].owner
    end
    return false
end

function isVehicleFromConce(theVehicle)
    if theVehicle and isElement(theVehicle) and dados[theVehicle] then 
        for i,v in ipairs((getVehicleType(theVehicle) == "Automobile" and config['Veiculos']['Carros'] or config['Veiculos']['Motos'])) do 
            if v[2] == getElementModel(theVehicle) then 
                return true, v[4]
            end 
        end 
    end 
    return false
end

function saveDadosVeh (vehicle)
    if vehicle and isElement(vehicle) and getElementType(vehicle) == 'vehicle' and dados_veh[vehicle] then 
        database = dbConnect('sqlite', 'src/database/database.db')

        local account = dados_veh[vehicle].account
        local model = getElementModel(vehicle)
        local vehicleID = dados_veh[vehicle].id
        
        local result = dbPoll(dbQuery(database, 'SELECT * FROM Garagem WHERE model = ? AND accountName = ?', model, account), -1)
        
        if #result ~= 0 then 
        
            local vehicle_tuning = {
                engineAcceleration = getElementData(vehicle, "tuning.engineAcceleration") or false,
                freio = getElementData(vehicle, "tuning.freio") or false,
                maxVelocity = getElementData(vehicle, "tuning.maxVelocity") or false,
                pneu = getElementData(vehicle, "danihe->vehicles->wheels") or false,
                neonA = toJSON(getElementData(vehicle, "danihe->vehicles->neon") or false),
                suspensao = getElementData(vehicle, "tuning.suspensao") or false,
                upgrades = toJSON(getVehicleUpgrades(vehicle)),
                sticker = toJSON(getElementData(vehicle, "danihe->vehicles->stickers")),  
                wheelB = toJSON(getElementData(vehicle, "danihe->vehicles->wheelsBack") or false),  
                wheelF = toJSON(getElementData(vehicle, "danihe->vehicles->wheelsFront") or false), 
                nitro = toJSON(getElementData(vehicle, "danihe->tuning->nitro") or false), 
                customexhaust = toJSON(getElementData(vehicle, "danihe->tuning->customexhaust") or false), 
                nitropercent = toJSON(getElementData(vehicle, "danihe->tuning->nitroprecent") or false), 
                variant = toJSON(getElementData(vehicle, "danihe->vehicles->variant") or false), 
                lsd = {toJSON(getElementData(vehicle, 'tuning.lsdDoor') or false)},
                bodyColor = toJSON(getElementData(vehicle, "danihe->vehicles->bodyColor") or false),
                drivetype = toJSON(getElementData(vehicle, "danihe->vehicles->drivetype") or false), 
                ecu = toJSON(getElementData(vehicle, "danihe->tuning->ecu") or false), 
                turbo = toJSON(getElementData(vehicle, "danihe->tuning->turbo") or false), 
                air = toJSON(getElementData(vehicle, "danihe->tuning->airride") or false), 
                airlevel = toJSON(getElementData(vehicle, "danihe->tuning->airride_level") or false),   
                diff = toJSON(getElementData(vehicle, "danihe->tuning->diff") or false), 
                chain = toJSON(getElementData(vehicle, "danihe->tuning->chain") or false), 
                gear = toJSON(getElementData(vehicle, "danihe->tuning->gear") or false), 
                clutch = toJSON(getElementData(vehicle, "danihe->tuning->clutch") or false),
                tires = toJSON(getElementData(vehicle, "danihe->tuning->tires") or false),
                weight = toJSON(getElementData(vehicle, "danihe->tuning->weight") or false),
                chassis = toJSON(getElementData(vehicle, "danihe->tuning->chassis") or false),
                suspension = toJSON(getElementData(vehicle, "danihe->tuning->suspension") or false),
                brakes = toJSON(getElementData(vehicle, "danihe->tuning->brakes") or false),
                flywheel = toJSON(getElementData(vehicle, "danihe->tuning->flywheel") or false),
                oil_cooler = toJSON(getElementData(vehicle, "danihe->tuning->oil_cooler") or false),
                intercooler = toJSON(getElementData(vehicle, "danihe->tuning->intercooler") or false),
                pistons = toJSON(getElementData(vehicle, "danihe->tuning->pistons") or false),
                engine = toJSON(getElementData(vehicle, "danihe->tuning->engine") or false),
                valve = toJSON(getElementData(vehicle, "danihe->tuning->valve") or false),
                camshaft = toJSON(getElementData(vehicle, "danihe->tuning->camshaft") or false),
                exhaust = toJSON(getElementData(vehicle, "danihe->tuning->exhaust") or false),
                ignite = toJSON(getElementData(vehicle, "danihe->tuning->ignite") or false),
                fuelsystem = toJSON(getElementData(vehicle, "danihe->tuning->fuelsystem") or false),
                airintake = toJSON(getElementData(vehicle, "danihe->tuning->airintake") or false),

            }
            
            local data_vehicle = fromJSON(result[1].dados)
            local infos = fromJSON(result[1].infos)
            local name, value, brand, type = infos[1], infos[2], infos[3], infos[4]
            local IPVA = result[1].IPVA
         
            local dados_vehicle_save = {
                vida = getElementHealth(vehicle),
                gasolina = getElementData(vehicle, 'gasolina') or 0,
                tunagem = vehicle_tuning,
                color = {getVehicleColor(vehicle, true)},
                light = {getVehicleHeadLightColor(vehicle)},
                malas = {},
                multas = 0
            }
            
            local infos_veh = {name, value, brand, type}
            dbExec(database, 'UPDATE `Garagem` SET `dados` = ?, `infos` = ?, `IPVA` = ?, `seguro` = ?, `state` = ?, `plate` = ? WHERE `ID` = ?', toJSON({dados_vehicle_save}), toJSON(infos_veh), IPVA, result[1].seguro, result[1].state == "spawnado" and "guardado" or result[1].state, result[1].plate, vehicleID)
        end
    end
end

function setDadosVeh ( vehicle, dados )
    if vehicle and isElement(vehicle) then 
        
        if dados.color then 
            setVehicleColor(vehicle, unpack(dados.color))
        end

        if dados.gasolina then 
            setElementData(vehicle, 'gasolina', tonumber(dados.gasolina))
        end

        if dados.vida then 
            setElementHealth(vehicle, math.max(350, tonumber(dados.vida)))
        end
        iprint(dados.tunagem.upgrades)
        if dados.tunagem.upgrades then 
            for i, v in ipairs (fromJSON(dados.tunagem.upgrades)) do 
                addVehicleUpgrade(vehicle, v)
            end  
        end

        if dados.tunagem.airintake then 
            setElementData(vehicle, "danihe->tuning->airintake", fromJSON(dados.tunagem.airintake))
        end

        if dados.tunagem.fuelsystem then 
            setElementData(vehicle, "danihe->tuning->fuelsystem", fromJSON(dados.tunagem.fuelsystem))
        end

        if dados.tunagem.ignite then 
            setElementData(vehicle, "danihe->tuning->ignite", fromJSON(dados.tunagem.ignite))
        end

        if dados.tunagem.exhaust then 
            setElementData(vehicle, "danihe->tuning->exhaust", fromJSON(dados.tunagem.exhaust))
        end

        if dados.tunagem.camshaft then 
            setElementData(vehicle, "danihe->tuning->camshaft", fromJSON(dados.tunagem.camshaft))
        end

        if dados.tunagem.valve then 
            setElementData(vehicle, "danihe->tuning->valve", fromJSON(dados.tunagem.valve))
        end

        if dados.tunagem.engine then 
            setElementData(vehicle, "danihe->tuning->engine", fromJSON(dados.tunagem.engine))
        end

        if dados.tunagem.pistons then 
            setElementData(vehicle, "danihe->tuning->pistons", fromJSON(dados.tunagem.pistons))
        end 

        if dados.tunagem.intercooler then 
            setElementData(vehicle, "danihe->tuning->intercooler", fromJSON(dados.tunagem.intercooler))
        end 

        if dados.tunagem.oil_cooler then 
            setElementData(vehicle, "danihe->tuning->oil_cooler", fromJSON(dados.tunagem.oil_cooler))
        end 

        if dados.tunagem.flywheel then 
            setElementData(vehicle, "danihe->tuning->flywheel", fromJSON(dados.tunagem.flywheel))
        end 

        if dados.tunagem.brakes then 
            setElementData(vehicle, "danihe->tuning->brakes", fromJSON(dados.tunagem.brakes))
        end 
        
        if dados.tunagem.chassis then 
            setElementData(vehicle, "danihe->tuning->chassis", fromJSON(dados.tunagem.chassis))
        end 

        if dados.tunagem.suspension then 
            setElementData(vehicle, "danihe->tuning->suspension", fromJSON(dados.tunagem.suspension))
        end 

        if dados.tunagem.weight then 
            setElementData(vehicle, "danihe->tuning->weight", fromJSON(dados.tunagem.weight))
        end 

        if dados.tunagem.diff then 
            setElementData(vehicle, "danihe->tuning->diff", fromJSON(dados.tunagem.diff))
        end

        if dados.tunagem.chain then 
            setElementData(vehicle, "danihe->tuning->chain", fromJSON(dados.tunagem.chain))
        end

        if dados.tunagem.gear then 
            setElementData(vehicle, "danihe->tuning->gear", fromJSON(dados.tunagem.gear))
        end 

        if dados.tunagem.tires then 
            setElementData(vehicle, "danihe->tuning->tires", fromJSON(dados.tunagem.tires))
        end 

        if dados.tunagem.clutch then 
            setElementData(vehicle, "danihe->tuning->clutch", fromJSON(dados.tunagem.clutch))
        end

        if dados.tunagem.neonA then 
            setElementData(vehicle, "danihe->vehicles->neon", fromJSON(dados.tunagem.neonA))
        end

        if dados.tunagem.ecu then 
            setElementData(vehicle, "danihe->tuning->ecu", fromJSON(dados.tunagem.ecu))
        end

        if dados.tunagem.air then 
            setElementData(vehicle, "danihe->tuning->airride", fromJSON(dados.tunagem.air))
        end

        if dados.tunagem.airlevel then 
            setElementData(vehicle, "danihe->tuning->airride_level", fromJSON(dados.tunagem.airlevel))
        end

        if dados.tunagem.turbo then 
            setElementData(vehicle, "danihe->tuning->turbo", fromJSON(dados.tunagem.turbo))
        end

        if dados.tunagem.nitro then 
            setElementData(vehicle, "danihe->tuning->nitro", fromJSON(dados.tunagem.nitro))
        end

        if dados.tunagem.nitropercent then 
            setElementData(vehicle, "danihe->tuning->nitroprecent", fromJSON(dados.tunagem.nitropercent))
        end

        if dados.tunagem.customexhaust then 
            setElementData(vehicle, "danihe->tuning->customexhaust", fromJSON(dados.tunagem.customexhaust))
        end

        if dados.tunagem.bodyColor then 
            setElementData(vehicle, "danihe->vehicles->bodyColor", fromJSON(dados.tunagem.bodyColor))
        end

        if dados.tunagem.variant then 
            setElementData(vehicle, "danihe->vehicles->variant", fromJSON(dados.tunagem.variant))
        end

        if dados.tunagem.drivetype then 
            setElementData(vehicle, "danihe->vehicles->drivetype", fromJSON(dados.tunagem.drivetype))
        end

        if dados.tunagem.wheelB then 
            setElementData(vehicle, "danihe->vehicles->wheelsBack", fromJSON(dados.tunagem.wheelB))
        end

        if dados.tunagem.wheelF then 
            setElementData(vehicle, "danihe->vehicles->wheelsFront", fromJSON(dados.tunagem.wheelF))
        end

        if dados.tunagem.sticker then
            setElementData(vehicle, "danihe->vehicles->stickers", fromJSON(dados.tunagem.sticker))
        end

    end
end

function closeGaragem ( player )
    if not player then return false  end
    return triggerClientEvent(player, 'onPlayerCloseGaragem', resourceRoot)
end

addEvent('onPlayerGarageSpawnVehicle', true)
addEventHandler('onPlayerGarageSpawnVehicle', resourceRoot,
    function ( dados, i )
        
        if not client then 
            return false 
        end

        if source ~= getResourceDynamicElementRoot(getThisResource()) then 
            return outputDebugString( " Resource | ".. (getResourceName(getThisResource())).." | ".. (getPlayerName(client)).." # "..(getElementData(client, 'ID') or "N/A").." | Serial | "..getPlayerSerial(client).."  | IP | "..(getPlayerIP(client)).."", 1 )
        end

        local qh = dbPoll(dbQuery(database, 'SELECT * FROM `Garagem` WHERE `accountName` = ? AND `model` = ?', getAccountName(getPlayerAccount(client)), tonumber(dados.model)), - 1)
        if #qh == 0 then return config.sendMessageServer(client, 'Esse veículo não foi encontrado na sua garagem!', 'error') end 
        
        if qh[1].state == "apreendido" then 
            return config.sendMessageServer(client, "Vá até o detran para recuperar seu veículo!", "error")
        end

        if qh[1].state == 'spawnado' then 
            
            local vehicle = getVehicleProxFromID ( client, qh[1].ID )
            if not vehicle then return config.sendMessageServer(client, 'Seu veículo está muito distante!', 'error') end 
       
            destroyElement(vehicle)
            closeGaragem(client)
       
            config.sendMessageServer(client, 'Você guardou seu veículo com sucesso!', 'info')
       
        elseif qh[1].state == 'guardado' then 
            if (getRealTime().timestamp >= tonumber(qh[1].IPVA)) then return config.sendMessageServer(client, 'Pague o IPVA do seu veículo!', 'error') end 
            
            local vehicle = createVehicle(tonumber(qh[1].model), config.positions['garage'][i].spawm[1], config.positions['garage'][i].spawm[2], config.positions['garage'][i].spawm[3], config.positions['garage'][i].rotation[1], config.positions['garage'][i].rotation[2], config.positions['garage'][i].rotation[3] )
            local dados = fromJSON(qh[1].dados)

            setDadosVeh(vehicle, dados[1])
            closeGaragem(client)
            
            warpPedIntoVehicle(client, vehicle)
            config.sendMessageServer(client, 'Você spawnou o veículo com sucesso!', 'info')
            
            setElementData(vehicle, 'Guh.VehicleID', tonumber(qh[1].ID))
            setElementData(vehicle, 'Owner', getAccountName(getPlayerAccount(client)))

            setVehiclePlateText(vehicle, qh[1].plate)
            dbExec(database, 'UPDATE `Garagem` SET `state` = ? WHERE `accountName` = ? AND `model` = ?', 'spawnado', getAccountName(getPlayerAccount(client)), tonumber(qh[1].model))
            dados_veh[vehicle] = {owner = getAccountName(getPlayerAccount(client)), id = qh[1].ID, account = getAccountName(getPlayerAccount(client))}
        end
    
    end
)

addEventHandler('onPlayerLogin', root, function ( )
    for i, v in pairs (dados_veh) do
        if v.owner == getAccountName(getPlayerAccount(source)) then 
            if (i and isElement(i)) then 
                setElementData(i, 'Owner', getAccountName(getPlayerAccount(source)))
            end
        end
    end
end)


addEvent("onPlayerBuySlot", true)
addEventHandler("onPlayerBuySlot", resourceRoot,
    function ( slot, price )
        if not client then 
            return false 
        end 

        if source ~= getResourceDynamicElementRoot(getThisResource()) then 
            return outputDebugString( " Resource | ".. (getResourceName(getThisResource())).." | ".. (getPlayerName(client)).." # "..(getElementData(client, 'ID') or "N/A").." | Serial | "..getPlayerSerial(client).."  | IP | "..(getPlayerIP(client)).."", 1 )
        end

        local query = dbPoll(dbQuery(database, "SELECT * FROM `Slots_Buy` WHERE `accountName` = ?", getAccountName(getPlayerAccount(client))), -1)
        if #query ~= 0 and tonumber(query[1].Slots) >= slot then return config.sendMessageServer(client, "Você já possui esse slot liberado!", "error") end 
        
        local coins = getElementData(client, "guetto.points") or 0

        if coins < tonumber(price) then return config.sendMessageServer(client, "Você não possui coins suficiente para comprar esse slot!", "error") end 

        if #query ~= 0 then 
            dbExec(database, "UPDATE `Slots_Buy` SET `Slots` = ? WHERE `accountName` = ?", tonumber(query[1].Slots) + 1, getAccountName(getPlayerAccount(client)))
        else
            dbExec(database, "INSERT INTO `Slots_Buy` VALUES (?, ?)", getAccountName(getPlayerAccount(client)), 1)
        end
        
        config.sendMessageServer(client, "Você comprou o slot com sucesso!", "info")        
        setElementData(client, "guetto.points", coins - price)
    end
)

addEventHandler('onElementDestroy', root, 
    function ()
        if source and isElement(source) and getElementType(source) == 'vehicle' then 
            if dados_veh[source] then 
                saveDadosVeh(source)
                local result = dbPoll(dbQuery(database, 'SELECT * FROM Garagem WHERE ID = ? AND accountName', dados_veh[source].id, dados_veh[source].account), -1)
                if #result ~= 0 then
                    if result[1]['state'] == 'spawnado' then
                        dbExec(database, 'UPDATE Garagem SET state = ? WHERE ID = ?', 'guardado', dados_veh[source].id)
                    end
                end
            end
        end
    end
)

function setVehicleState(vehicle, state)

    if not (vehicle and state) then return false end
    if not dados_veh[vehicle] then return false end

    local queryHandle = dbQuery(database, 'SELECT * FROM Garagem WHERE ID = ? AND accountName = ?', dados_veh[vehicle].id, dados_veh[vehicle].account)
    if not queryHandle then return false end

    local result = dbPoll(queryHandle, -1)
    if not result then return false end

    if #result == 0 then return false end

    local success = dbExec(database, "UPDATE `Garagem` SET state = ? WHERE `accountName` = ? AND `ID` = ?", state, dados_veh[vehicle].account, dados_veh[vehicle].id)
    return success
end



function stopResource()
    for i, v in ipairs(getElementsByType('vehicle')) do
        if dados_veh[v] then
            saveDadosVeh(v)
            local result = dbPoll(dbQuery(database, 'SELECT * FROM Garagem WHERE ID = ? AND accountName = ?', getElementModel(v), dados_veh[v].account), -1)
            if (#result ~= 0) and (type(result) == 'table') then
                if result[1]['state'] == 'spawnado' then
                    dbExec(database, 'UPDATE Garagem SET state = ? WHERE ID = ? AND accountName = ?', 'guardado', dados_veh[v].id, dados_veh[v].account)
                end
            end
        end
    end
end
addEventHandler('onResourceStop', resourceRoot, stopResource)
