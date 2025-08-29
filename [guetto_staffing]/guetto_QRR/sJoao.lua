addEventHandler("onResourceStart", resourceRoot,
function()
    if config["Mensagem Start"] then
        outputDebugString("["..getResourceName(getThisResource()).."] Startado com sucesso!")
    end
end)

qrrState = {}
blip = {}

addCommandHandler("qrr",
function(player)
    if aclGetGroup(config["ACL"]) and isObjectInACLGroup("user."..getAccountName(getPlayerAccount(player)), aclGetGroup(config["ACL"])) then
        if (getElementData(player, config["ElementData"]) or false) then
            if qrrState[player] then
                notifyS(player, "Você já está com QRR ativo!", "error")
            else
                qrrState[player] = true
                notifyS(player, "Você solicitou um QRR Máximo!", "success")
                blip[player] = createBlipAttachedTo(player, config["ID Blip"])
                setElementVisibleTo(blip[player], root, false)
                for i, v in ipairs(getElementsByType("player")) do
                    if (getElementData(v, config["ElementData"]) or false) then
                        if v ~= player then
                            setElementVisibleTo(blip[player], v, true)
                            notifyS(v, "O jogador(a) "..puxarNome(player).." #"..puxarID(player).." solicitou QRR máximo!", "warning")
                        end
                    end
                end
            end
        end
    end
end)

addCommandHandler("qrroff",
function(player)
    if aclGetGroup(config["ACL"]) and isObjectInACLGroup("user."..getAccountName(getPlayerAccount(player)), aclGetGroup(config["ACL"])) then
        if (getElementData(player, config["ElementData"]) or false) then
            if not qrrState[player] then
                notifyS(player, "Você não está com QRR ativo!", "error")
            else
                qrrState[player] = false
                notifyS(player, "Você retirou um QRR Máximo!", "success")
                if isElement(blip[player]) then destroyElement(blip[player]) end
            end
        end
    end
end)

--Funções utils

function messageDiscord(message, link)
	sendOptions = {
	    queueName = "dcq",
	    connectionAttempts = 3,
	    connectTimeout = 5000,
	    formFields = {
	        content="```\n"..message.."```"
	    },
	}
	fetchRemote(link, sendOptions, function () return end)
end

function getPlayerFromID(id)
    if tonumber(id) then
        for _, player in ipairs(getElementsByType('player')) do
            if getElementData(player, 'ID') and (getElementData(player, 'ID') == tonumber(id)) then
                return player
            end
        end
    end
    return false
end

function getPlayerFromAccountName(name) 
    local acc = getAccount(name)
    if not acc or isGuestAccount(acc) then
        return false
    end
    return getAccountPlayer(acc)
end