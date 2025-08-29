local resources = {}

addEventHandler("onResourceStart", resourceRoot, function ()
    local categories = config["Others"]["categorias"]
    local resourcesConfig = config["Resources"]

    for _, category in ipairs(categories) do
        local categoryResources = resourcesConfig[category]
        if categoryResources then
            for i, v in ipairs(categoryResources) do
                local resourceName = string.lower(v[2])
                local txdPath = "assets/mods/" .. category .. "/" .. resourceName .. ".txd"
                local dffPath = "assets/mods/" .. category .. "/" .. resourceName .. ".dff"

                if fileExists(txdPath) and fileExists(dffPath) then
                    local openTxd = fileOpen(txdPath, true)
                    local openDff = fileOpen(dffPath, true)

                    if openTxd and openDff then
                        local size = fileGetSize(openTxd) + fileGetSize(openDff)

                        if not resources[category] then
                            resources[category] = {}
                        end

                        if category == categories[5] then

                        end
                        
                        table.insert(resources[category], {size})

                        fileClose(openTxd)
                        fileClose(openDff)
                    end
                else

                    outputDebugString("Houve uma falha ao procurar os seguintes arquivos:"..v[1]..' | '..v[2]..' | '..v[3], 0)
                end
            end
        end
    end
end)

registerEvent("vanish.get.mods", resourceRoot, function (player)
    triggerClientEvent(player, "vanish.trasfer.mods", resourceRoot, resources)
end)
