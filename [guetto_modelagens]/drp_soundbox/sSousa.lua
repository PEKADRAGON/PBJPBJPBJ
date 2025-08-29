local jblmao = { }
local jblchao = { }
local tempCol = { }

function jbl(thePlayer)
    local accName = getAccountName ( getPlayerAccount ( thePlayer ) ) -- get his account name
        if exports['guetto_inventory']:getItem(thePlayer, 33) == 0 then 
            return message(thePlayer, "Você não possui uma JBL.", "error")
        end 
        if isObjectInACLGroup ("user."..accName, aclGetGroup ( ACL) ) then
           if getElementData(thePlayer, "rocketz:jbl") == "chao" then 
               message(thePlayer, "Você possuí uma JBL no chão.", "error")
           else
           if not getElementData(thePlayer, "rocketz:jbl") then
                   if getElementData(thePlayer, "rocketz:flood") ~= true then
                   dimensao = getElementDimension(thePlayer)
                   jblmao[thePlayer] = createObject(2226,0,0,0) 
                   setElementDimension(jblmao[thePlayer], dimensao)
                   setElementData(thePlayer, "rocketz:jbl", true)
                   setObjectScale ( jblmao[thePlayer], 0.95)
                   exports.bone_attach:attachElementToBone(jblmao[thePlayer],thePlayer,12,0,0,0.4,0,180,0)
                   setElementData(thePlayer, "rocketz:flood", true)
                   triggerEvent("server->applyJBL", thePlayer, jblmao)
                   message(thePlayer, "Você pegou uma JBL.", "success")
                   setTimer(function ()
                       setElementData(thePlayer, "rocketz:flood", nil)
                   end, 2000, 1)
               else
                   message(thePlayer, "Aguarde um pouco.", "error")
               end
           else
               if getElementData(thePlayer, "rocketz:flood") ~= true then
                   setElementData(thePlayer, "rocketz:jbl", nil)
                   destroyElement(jblmao[thePlayer])
                   local jblmao = jblmao[thePlayer]
                   triggerClientEvent(root, "pararmsc", root, thePlayer, jblmao)
                   setElementData(thePlayer, "rocketz:flood", true)
                   setTimer(function ()
                       setElementData(thePlayer, "rocketz:flood", nil)
                   end, 2000, 1)
               else
                   message(thePlayer, "Aguarde um pouco.", "error")
                       end
                   end
               end
        end
end 
addCommandHandler(configpegarjblmao, jbl)

function soltarjbl(thePlayer, x, y, z)
    local x, y, z = getElementPosition(thePlayer)
    local rx, ry, rz = getElementRotation(thePlayer)
    if getElementData(thePlayer, "rocketz:jbl") == true then
        if getElementData(thePlayer, "rocketz:flood") == true then
            message(thePlayer, "Aguarde um pouco.", "error")
        else
            setElementData(thePlayer, "rocketz:jbl", "chao")
            setPedAnimation(thePlayer, "bomber", "BOM_Plant_Loop", -1, true, false, false)
            setElementData(thePlayer, "rocketz:flood", true)
            setTimer(function ()
        	setPedAnimation(thePlayer)
        	exports.bone_attach:detachElementFromBone(jblmao[thePlayer], thePlayer)
        	moveObject(jblmao[thePlayer], 0,x, y, z-1)
        	tempCol[thePlayer] = createColSphere (x, y, z, 2)
            message(thePlayer, "Você soltou sua JBL.", "success")
            setTimer(function ()
                setElementData(thePlayer, "rocketz:flood", nil)
            end, 2000, 1)
        end, 500, 1)
    end
    else
        message(thePlayer, "Você não possuí uma JBL em mãos.", "error")
    end
end
addCommandHandler(configsoltarjbl, soltarjbl)

function pegarjblchao(thePlayer)
    if getElementData(thePlayer, "rocketz:jbl") == "chao" then
        if isElementWithinColShape(thePlayer, tempCol[thePlayer]) then
            if getElementData(thePlayer, "rocketz:flood") == true then
                message(thePlayer, "Espere um pouco!", "error")
            else
                setPedAnimation(thePlayer, "bomber", "BOM_Plant_Loop", -1, true, false, false)
                setElementData(thePlayer, "rocketz:flood", true)
                setTimer(function ()
                    setPedAnimation(thePlayer)
                    setElementData(thePlayer, "rocketz:jbl", true)
                    exports.bone_attach:attachElementToBone(jblmao[thePlayer],thePlayer,12,0,0,0.4,0,180,0)
                    destroyElement(tempCol[thePlayer])
                    message(thePlayer, "Você pegou sua JBL.", "success")
                setTimer(function ()
                    setElementData(thePlayer, "rocketz:flood", nil)
                end, 2000, 1)
                end, 500, 1)
            end
        end
    end
end
addCommandHandler(configpegarjbl , pegarjblchao)
    

function setmusica(thePlayer, command, url)
    if getElementData(thePlayer, "rocketz:jbl") == true then
        if not url then
            message(thePlayer, "Use /musicajbl [URL]", "error")
        else
    	local x, y, z = getElementPosition(jblmao[thePlayer])
    	local jblmao = jblmao[thePlayer]
        message(thePlayer, "Você colocou uma música na sua JBL.", "success")
        triggerClientEvent(root, "tocarmsc", thePlayer, thePlayer, url, x, y , z, jblmao)
        end
    end
end
addCommandHandler(configsetmusica, setmusica)

function setTex(thePlayer, texture)
    if getElementData(thePlayer, "rocketz:flood") == true then
        message(thePlayer, "Aguarde um pouco.", "error")
    else
        if getElementData(thePlayer, "rocketz:jbl") == true then
            if not texture then
                message(thePlayer, "Use /settex [textura]", "error")
            else
                local jblmao = jblmao[thePlayer]
                setElementData(thePlayer, "rocketz:flood", true)
                triggerEvent("server->applyTextureJBL", thePlayer, jblmao, texture)
                message(thePlayer, "Textura setada com sucesso!", "success")
                setTimer(function ()
                    setElementData(thePlayer, "rocketz:flood", nil)
                end, 2000, 1)
            end
        else
            message(thePlayer, "Você não está com nenhuma JBL em mãos!", "error")
        end
    end
end

function stopmusica(thePlayer)
    local jblmao = jblmao[thePlayer]
    triggerClientEvent(root, "pararmsc", root, thePlayer, jblmao)
    message(thePlayer, "Você desligou sua JBL.", "success")
end
addCommandHandler(configpararmusica, stopmusica)

function stopScript()
    for k, v in ipairs(getElementsByType("player")) do 
        setElementData(v, "rocketz:jbl", nil)
        setElementData(v, "rocketz:flood", nil)
    end
end
addEventHandler("onResourceStop", getResourceRootElement(getThisResource()), stopScript)

function startScript()
    for k, v in ipairs(getElementsByType("player")) do 
        setElementData(v, "rocketz:jbl", nil)
        setElementData(v, "rocketz:flood", nil)
    end
end
addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), startScript)

function quitPlayer()
    if getElementData(source, "rocketz:jbl") == true or "chao" then
        if (jblmao[source] and isElement(jblmao[source])) then 
            exports.bone_attach:detachElementFromBone(jblmao[source], source)
            moveObject(jblmao[source], 0, 0, 0, 0)
            destroyElement(jblmao[source])
            triggerClientEvent(root, "pararmsc", root, thePlayer, jblmao)
            if tempCol[source] then
                destroyElement(tempCol[source])
            end
        end
    end
end
addEventHandler ( "onPlayerQuit", root, quitPlayer )
        

function message(player, msg, type)
    exports['guetto_notify']:showInfobox(player, type, msg)
end