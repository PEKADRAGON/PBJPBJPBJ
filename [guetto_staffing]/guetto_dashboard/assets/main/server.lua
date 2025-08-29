local resource = {cards = {}}
local playerStats = {}

local function getPlayerBanner(player)
    local acl = getPlayerPermissionCard(player)
    local elementData = getPlayerDataCard(player)

    local bannerIndex
    if elementData then
        bannerIndex = elementData
    elseif acl then
        bannerIndex = acl
    else
        bannerIndex = #config.banners
    end

    return {player = player, card = config.banners[bannerIndex]}
end

local function requestInfos (data) 
    if not client then 
        return
    end

    local cache = {}
    if not data then 
        for k = 1, table.getn(getElementsByType("player")) do 
            local player = getElementsByType("player")[k]
            local name = getPlayerName(player);

            local id = getElementData(player, "ID") or 0;
            local banner = getPlayerBanner(player)

            table.insert(cache, {
                name = name,
                element = player,
                id = id,
                banner = banner,
            })
        end
    else
        for k = 1, table.getn(getElementsByType("player")) do 
            local player = getElementsByType("player")[k]
            if getElementData(player, data) then 
                local name = getPlayerName(player);
                local id = getElementData(player, "ID") or 0;
                local banner = getPlayerBanner(player)
                table.insert(cache, {
                    name = name,
                    element = player,
                    id = id,
                    banner = banner,
                })
            end
        end
    end

    local group, role = exports["guetto_group"]:getPlayerGroup(client), exports["guetto_group"]:getPlayerRoleInGroup(client)
    local stats = playerStats[getAccountName(getPlayerAccount(client))]

    return triggerClientEvent(client, "guetto.sendInfoClient", resourceRoot, {cache = cache, group = group, role = role, stats = stats})
end

local function updatePlayerDeathStats (player)
    local account = getPlayerAccount(player)
    if account and not isGuestAccount(account) then
        local playerName = getAccountName(account)
        if playerStats[playerName] then
            playerStats[playerName].deaths = playerStats[playerName].deaths + 1
        else
            playerStats[playerName] = {
                kills = 0,
                deaths = 1
            }
        end
    end
end

local function updatePlayerKillStats (player)
    local account = getPlayerAccount(player)
    if account and not isGuestAccount(account) then
        local playerName = getAccountName(account)
        if playerStats[playerName] then
            playerStats[playerName].kills = playerStats[playerName].kills + 1
        else
            playerStats[playerName] = {
                kills = 1,
                deaths = 0
            }
        end
    end
end

local function onPlayerWasted (_, killer)
    updatePlayerDeathStats(source)
    if killer and getElementType(killer) == "player" then
        updatePlayerKillStats(killer)
    end
end

registerEvent("guetto.requestInfos", resourceRoot, requestInfos)

addEventHandler("onPlayerWasted", root, onPlayerWasted)