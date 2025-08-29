function startRes(res)
    if (res ~= getThisResource()) then return end
end
addEventHandler("onResourceStart", getRootElement(), startRes)