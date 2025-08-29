local editbox = {}
local mouseOnElement
local editpress

function dxDrawEditbox(x, y, w, h, max, id)
    if id then
        local id = tonumber(id)
        if not editbox[id] then
            editbox[id] = {
                ["Ativada"] = false,
                ["Texto"] = "",
                ["Maximo"] = max,
            }
        else
            if isCursorOnElement(x, y, w, h) then
                mouseOnElement = id
                editbox[mouseOnElement]["Posicao"] = {x, y, w, h}
            else
                if mouseOnElement and editbox[mouseOnElement]["Posicao"] then
                    if not isCursorOnElement(unpack(editbox[mouseOnElement]["Posicao"])) then 
                        editbox[mouseOnElement]["Posicao"] = nil
                        mouseOnElement = nil
                    end
                end
            end
        end
    end
end

addEventHandler("onClientClick", getRootElement(), function(button, state)
    if button == "left" and state == "down" then 
        if mouseOnElement then
            if editbox[mouseOnElement]["Posicao"] and isCursorOnElement(unpack(editbox[mouseOnElement]["Posicao"])) then 
                if editpress ~= mouseOnElement then 
                    if editbox[editpress] then 
                        editbox[editpress]["Ativada"] = false
                    end
                    editpress = mouseOnElement
                    if editbox[editpress] then 
                        editbox[editpress]["Ativada"] = true
                    end
                end
            end
        end
        if editbox[editpress] then 
            if not editbox[editpress]["Posicao"] then
                editbox[editpress]["Ativada"] = false
                editpress = nil
            end
        end
    end
end)

function setTextOnEdibox(texto, id)
    if id then
        if editbox[id] then 
            editbox[id]["Texto"] = texto 
        end
    end
end

function destroyBox()
    editbox = {}
    mouseOnElement = nil
    editpress = nil
end

function isBoxActive(id)
    local active = false 
    if editbox[id] then 
        active = editbox[id]["Ativada"]
    end
    return active
end

function getEditboxText(id)
    local text = ""
    if editbox[id] then
        if editbox[id]["Texto"] and #editbox[id]["Texto"] ~= 0 then
            text = editbox[id]["Texto"]
        else
            text = "" 
        end
    end
    return text
end

addEventHandler("onClientCharacter", getRootElement(), function(key)
    if editbox[editpress] and editbox[editpress]["Ativada"] then
        if editbox[editpress]["Texto"] then
            if #editbox[editpress]["Texto"] < editbox[editpress]["Maximo"] then
                editbox[editpress]["Texto"] = editbox[editpress]["Texto"]..key
            end
        else
            editbox[editpress]["Texto"] = ""
        end
    end
end)

local function deleteCharacter(button, press)  
    if editbox[editpress] then
        if button == "backspace" then
            if editbox[editpress]["Ativada"] then
                if press then

                    if #editbox[editpress]["Texto"] > 0 then
                        editbox[editpress]["Texto"] = string.sub(editbox[editpress]["Texto"], 1, #editbox[editpress]["Texto"] - 1) 
                    else
                        editbox[editpress]["Texto"] = ""
                        editbox[editpress]["Ativada"] = false
                        editpress = nil
                    end

                end
            end
        end
    end
end
addEventHandler("onClientKey", getRootElement(), deleteCharacter)

addEventHandler("onClientKey", getRootElement(), function(button, press)
    if editbox[editpress] and editbox[editpress]["Ativada"] then
        cancelEvent()
    end
end)