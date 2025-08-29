tableLevel = {}

addEventHandler("onResourceStart", resourceRoot,
function()
    db = dbConnect("sqlite", "dados.db")
    dbExec(db, 'CREATE TABLE IF NOT EXISTS LevelSystem (Conta, XP, Level)')
    setTimer(function()
        for i, v in ipairs(getElementsByType("player")) do
            if not isGuestAccount(getPlayerAccount(v)) then 
                local xp = getElementData(v, "XP") or 0
                local level = getElementData(v, "Level") or 0

                xp = tonumber(xp) or 0
                level = tonumber(level) or 0

                if xp <= 0 and level <= 0 then
                    setElementData(v, "XP", 0)
                    setElementData(v, "Level", level + 1)
                    outputChatBox('#A68959[GUETTO] #FFFFFFParábens você upou para o level #A68959('..(level+1)..')#FFFFFF com sucesso!', v, 255, 255, 255, true)
                else
                    setElementData(v, "Level", level + 1)
                    outputChatBox('#A68959[GUETTO] #FFFFFFParábens você upou para o level #A68959('..(level+1)..')#FFFFFF com sucesso!', v, 255, 255, 255, true)
                end
            end 
        end
    end, 60*60000, 0)
    dbQuery(saveQuery, db, "SELECT * FROM LevelSystem")
end)


function outputChange(theKey, oldValue, newValue)
    if source and isElement(source) and (getElementType(source) == "player") then 
		if (theKey == "XP") then
            if not oldValue then
                oldValue = 0
            end
            if not newValue then
                newValue = 0
            end
            if newValue <= 0 or oldValue <= 0 then 
                return 
            end
			outputChatBox('#A68959[GUETTO] #FFFFFFParábens você ganhou #A68959('..(tonumber(newValue)-tonumber(oldValue))..')#FFFFFF de XP!', source, 255, 255, 255, true)
			outputChatBox('#A68959[GUETTO] #FFFFFFProgresso: '..newValue..'/'..((getElementData(source, 'Level') or 0) * 800)..'', source, 255, 255, 255, true)
		end
    end
end
addEventHandler("onElementDataChange", root, outputChange)

addCommandHandler("setarlevel", 
function (player, cmd, id, quantidade)
	if getElementType(player) == "player" then
		if isObjectInACLGroup("user."..getAccountName(getPlayerAccount(player)), aclGetGroup("Console")) then 
			if tonumber(id) and tonumber(quantidade) then 
				local receiver = getPlayerFromID(id)
				if isElement(receiver) then
					local level = getElementData(receiver, "Level") or 0
					exports.FR_DxMessages:addBox(receiver, "Foi adicionado "..tonumber(quantidade).." de level em você!", "info")
					exports.FR_DxMessages:addBox(player, "Você adicionou "..tonumber(quantidade).." de level no "..getPlayerName(receiver).."!", "success")
					setElementData(receiver, "Level", tonumber(quantidade))
					setElementData(receiver, "XP", 0)
				end
			end 
		end 
	end 
end)

function quitLevel()
    if not isGuestAccount(getPlayerAccount(source)) then
        if tableLevel[getAccountName(getPlayerAccount(source))] then
			tableLevel[getAccountName(getPlayerAccount(source))].XP = (getElementData(source, 'XP') or 0)
			tableLevel[getAccountName(getPlayerAccount(source))].Level = (getElementData(source, 'Level') or 0)
            dbExec(db, 'UPDATE LevelSystem SET XP = ?, Level = ? WHERE Conta = ?', (getElementData(source, 'XP') or 0), (getElementData(source, 'Level') or 0), getAccountName(getPlayerAccount(source)))
        else
			tableLevel[getAccountName(getPlayerAccount(source))] = {
				Conta = getAccountName(getPlayerAccount(source)),
				XP = (getElementData(source, 'XP') or 0),
				Level = (getElementData(source, 'Level') or 0),
			}
            dbExec(db, 'INSERT INTO LevelSystem (Conta, XP, Level) VALUES(?, ?, ?)', getAccountName(getPlayerAccount(source)), (getElementData(source, 'XP') or 0), (getElementData(source, 'Level') or 0))
        end
    end
end
addEventHandler('onPlayerQuit', root, quitLevel)

function joinLevel(_, account)
    if tableLevel[getAccountName(account)] then
		setElementData(source, 'XP', tableLevel[getAccountName(account)].XP)
        setElementData(source, 'Level', tableLevel[getAccountName(account)].Level)
	else
		setElementData(source, "XP", 0)
		setElementData(source, "Level", 0)
    end
end
addEventHandler('onPlayerLogin', root, joinLevel)

function getPlayerFromID(id)
    id = tonumber(id)
    for i,v in ipairs(getElementsByType("player")) do 
        if getElementData(v, "ID") == id then 
            return v
        end 
    end 
    return false
end 

function puxarLevel(conta)
	if tableLevel[conta] then
		return tableLevel[conta].Level
	end
	return 0
end

function getRankingLevel ()
    local query = dbPoll(dbQuery(db, "SELECT * FROM LevelSystem ORDER BY Level DESC LIMIT 15"), -1)
    if #query > 0 then
        return query
    end
    return 0
end

function saveQuery(queryTable)
    local result = dbPoll(queryTable, 0)
    for i=1, #result do
        local row = result[i]
        tableLevel[row.Conta] = row
    end
end

addEventHandler("onElementDataChange", root,
    function (key, old, new)
        if (source and isElement(source) and getElementType(source) == 'player') then 
            if (key == "XP") then
                local level = getElementData(source, 'Level') or 0
                local xp = getElementData(source, 'XP') or 0

                xp = tonumber(xp) or 0
                level = tonumber(level) or 0

				if tonumber(xp) >= tonumber(level*config["Geral"].Level) then
                    setElementData(source, "Level", level + 1)
                    setElementData(source, "XP", 0)
					outputChatBox('#A68959[GUETTO] #FFFFFFParábens você upou para o level #A68959('..level..')#FFFFFF com sucesso!', source, 255, 255, 255, true)
                end
            end
        end
    end 
)