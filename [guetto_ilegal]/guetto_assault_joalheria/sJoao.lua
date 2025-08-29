hackeadoRecente = false
marker_vender = {}
marker_coletar = {}
tableJoia = {}
local pms = 0

addEventHandler("onResourceStart", resourceRoot,
function()
    if config["Mensagem Start"] then
        outputDebugString("["..getResourceName(getThisResource()).."] Startado com sucesso!")
    end
    for i, v in ipairs(config["Markers Coletar"]) do
        
        marker_coletar[i]  = createMarker ( v[1], v[2], v[3]-0.9, 'cylinder', 1.5, 139, 100, 255, 0 )
        setElementData(marker_coletar[i], "markerData", {title = "Joalheria", desc = "Faça quest para roubar.", icon = "checkpoint"})

       -- setElementData(marker_coletar[i], 'marker_custom',  20)
        setElementVisibleTo(marker_coletar[i], root, false)
        addEventHandler("onMarkerHit", marker_coletar[i],
        function(player, dim)
            if getElementType(player) == "player" then
                if dim then
                    if isElement(marker_coletar[i]) then
                        if isElementVisibleTo(marker_coletar[i], root) then
                            setElementVisibleTo(marker_coletar[i], root, false)
                            triggerClientEvent(player, "JOAO.openJoalheria", player, "coletar")
                        end
                    end
                end
            end
        end)
    end
    for i, v in ipairs(config["Markers Vender"]) do
        marker_vender[i]  = createMarker ( v[1], v[2], v[3]-0.9, 'cylinder', 1.5, 139, 100, 255, 0 )
       -- marker_vender[i] = exports["bvr_marker"]:createMarker("marker", Vector3 (v[1], v[2], v[3]-0.9, "cylinder", 1.1, 0, 0, 0, 0))
        --setElementData(marker_coletar[i], 'marker_custom',  11)
        setElementData(marker_vender[i], "markerData", {title = "Vender joias", desc = "Compramos joias ilegais", icon = "checkpoint"})
        createBlipAttachedTo(marker_vender[i], 26)
        addEventHandler("onMarkerHit", marker_vender[i],
        function(player, dim)
            if getElementType(player) == "player" then
                if dim then
                    if aclGetGroup(v[4]) and isObjectInACLGroup("user."..puxarConta(player), aclGetGroup(v[4])) then
                        tableJoia[player] = {}
                        for i, v in ipairs(config["Joias"]) do
                            table.insert(tableJoia[player], {idJoia = v[4], qntJoia = exports["guetto_inventory"]:getItem(player, v[4])})
                        end
                        triggerClientEvent(player, "JOAO.openJoalheria", player, "vender", tableJoia[player])
                    end
                end
            end
        end)
    end
    marker_hackear = createMarker(config["Marker Assaltar"][1], config["Marker Assaltar"][2],config["Marker Assaltar"][3]-0.9, "cylinder", 1.1, 0, 0, 0, 0)
    setElementData(marker_hackear, "markerData", {title = "Joalheria", desc = "Faça quest para roubar.", icon = "checkpoint"})
    createBlipAttachedTo(marker_hackear, 28)
    setElementData(marker_hackear, 'marker_custom',  11)
    addEventHandler("onMarkerHit", marker_hackear,
    function(player, dim)
        if getElementType(player) == "player" then
            if dim then
                if hackeadoRecente then
                    notifyS(player, "A joalheria já foi hackeada recentemente!", "error")
                else
                    triggerClientEvent(player, "JOAO.openJoalheria", player, "index")
                end
            end
        end
    end)
end)

returnPms = function()
    allPlayers = getElementsByType('player')
    for _, v in ipairs(allPlayers) do
        if (getElementData(v, 'service.police') == true) then
            pms = pms + 1
        end
    end
    return pms
end

addEvent("JOAO.startHackJOALHERIA", true)
addEventHandler("JOAO.startHackJOALHERIA", root,
function(player)
    returnPms()
    if pms < 3 then 
        notifyS(player, 'Você não pode assaltar a joalheria pois não tem policial online!', 'error')
    else
        for i, v in ipairs(marker_coletar) do
            if isElement(v) then
                setElementVisibleTo(v, root, true)
            end
        end
    end   
    blipHack = createBlip(config["Marker Assaltar"][1], config["Marker Assaltar"][2],config["Marker Assaltar"][3], 20)
    setElementVisibleTo(blipHack, root, false)
    for i, v in ipairs(getElementsByType("player")) do
        if (getElementData(v, "service.police") or false) then
            setElementVisibleTo(blipHack, v, true)
            notifyS(v, "O assalto a joalheira começou, prioridade!", "warning")
        end
    end
    hackeadoRecente = true
    setTimer(function()
        if isElement(blipHack) then destroyElement(blipHack) end
        for i, v in ipairs(marker_coletar) do
            if isElement(v) then
                setElementVisibleTo(v, root, false)
            end
        end
    end, 10*60000, 1)
    triggerClientEvent(root, "JOAO.tocarSomJoalheria", player)
    setTimer(function()
        hackeadoRecente = false
        for i, v in ipairs(marker_coletar) do
            if isElement(v) then
                setElementVisibleTo(v, root, false)
            end
        end
    end, 300*60000, 1)
end)

addEvent("JOAO.coletarJoia", true)
addEventHandler("JOAO.coletarJoia", root,
function(player, tableJoia, quantiaJoia)
    if tableJoia and quantiaJoia then
        if exports["guetto_inventory"]:giveItem(player, tableJoia[4], quantiaJoia) then
            notifyS(player, "Você pegou "..quantiaJoia.."x "..tableJoia[1].." com sucesso!", "success")
            exports["guetto_util"]:messageDiscord("O jogador(a) "..(exports["guetto_util"]:puxarNome(source)).." ("..(exports["guetto_util"]:puxarID(source))..") Pegou "..quantiaJoia.."x "..tableJoia[1].." com sucesso", "https://discord.com/api/webhooks/1051773891665739777/Oa-BMxDLKqNn1TOThlRlhTlyw8o6Yvg5sRb0xcL0jpIxFvcbhi2ih-4xXHe9MN_VQDCX")
        end
    end
end)



addEvent("JOAO.venderJoia", true)
addEventHandler("JOAO.venderJoia", root,
function(player, tableJoia)
    local qntJoia = exports["guetto_inventory"]:getItem(player, tableJoia[4])
    if qntJoia >= tableJoia[5] then
        exports["guetto_inventory"]:giveItem(player, 100, (qntJoia*tableJoia[6]))
        exports["guetto_inventory"]:takeItem(player, tableJoia[4], qntJoia)
        notifyS(player, "Você vendeu "..qntJoia.."x de "..tableJoia[1].." por R$ "..formatNumber(qntJoia*tableJoia[6])..",00", "success")
        exports["guetto_util"]:messageDiscord("O jogador(a) "..(exports["guetto_util"]:puxarNome(source)).." ("..(exports["guetto_util"]:puxarID(source))..") Vendeu "..qntJoia.."x jóia de "..tableJoia[1].." por R$"..formatNumber(qntJoia*tableJoia[6])..",00", "https://discord.com/api/webhooks/1051773891665739777/Oa-BMxDLKqNn1TOThlRlhTlyw8o6Yvg5sRb0xcL0jpIxFvcbhi2ih-4xXHe9MN_VQDCX")
        tableJoia[player] = {}
        for i, v in ipairs(config["Joias"]) do
            table.insert(tableJoia[player], {idJoia = v[4], qntJoia = exports["guetto_inventory"]:getItem(player, v[4])})
        end
        triggerClientEvent(player, "JOAO.attJoia", player, tableJoia[player])
    else
        notifyS(player, "Você não tem as mesmas jóias do painel!", "error")
    end
end)