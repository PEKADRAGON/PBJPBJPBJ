local marker = {}

for i, v in ipairs(config) do 
    marker[i] = createMarker(v[1], v[2], v[3], 'cylinder', 1.3, r, g, b, a) 
    if v.blip then 
        createBlipAttachedTo(marker[i], v.blip)
    end
    setElementData(marker[i], 'markerData', {title = 'Porta', desc = 'Uma simples porta.', icon = 'entrada'})
    setElementDimension(marker[i], v[13]) 
    setElementInterior(marker[i], v[11])


    setElementInterior(marker[i], v[11])
    addEventHandler('onMarkerHit', marker[i], 
        function(player) 
            if isElement(player) and getElementType(player) == 'player' then 
                if getElementDimension(source) == getElementDimension(player) then 
                    triggerClientEvent(player, 'Pedro.onPainelTeleport', player, i)
                end
            end
        end
    )

    addEventHandler('onMarkerLeave', marker[i], 
        function(player) 
            if isElement(player) and getElementType(player) == 'player' then 
                triggerClientEvent(player, 'Pedro.onClosePainelTeleport', player)
            end
        end
    )
end


addEvent('Pedro.onPlayerUseTeleport', true)
addEventHandler('Pedro.onPlayerUseTeleport', root, 
    function(player, i)
        setElementPosition(player, config[i][4], config[i][5], config[i][6])
        setElementRotation(player, config[i][7], config[i][8], config[i][9])
        setElementInterior(player, config[i][10])
        setElementDimension(player, config[i][14]) 
    end
)
