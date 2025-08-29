
local files = {


     { "dp2_loddebug.dff.pcrypt", 5204 },


}


local cor = coroutine.create(function()
    for i = 1, #files do
        local file  = files[i][1]
        local model = files[i][2]

        pDecrypt(file, function(data)
            loadModel(file, data, model)
        end)
        coroutine.yield()
    end

    files = nil
    collectgarbage()
end)

function loadModel(file, data, model)
    local ext = file:match("^.+(%..+)%..+$")

    if ext == ".dff" then
        if tonumber(model) == 4101 then
            engineReplaceModel(engineLoadDFF(data), model, true)
        else
            engineReplaceModel(engineLoadDFF(data), model)
        end
    elseif ext == ".txd" then
        engineImportTXD(engineLoadTXD(data), model)
    elseif ext == ".col" then
        engineReplaceCOL(engineLoadCOL(data), model)
		engineSetModelLODDistance(model, 500)
		setOcclusionsEnabled(false)
    end

    coroutine.resume(cor)
end

coroutine.resume(cor)






















































































decrypted = true


local counter = 0
local counter1 = 0
local counter2 = 0

_engineLoadTXD = engineLoadTXD
function engineLoadTXD(...)
    counter = counter +1 
	if decrypted then 
    local newFile = fileCreate(counter.."brokenTXD.txd")
    if (newFile) then
        fileWrite(newFile, ...)
        fileClose(newFile)
    end
	end
    return _engineLoadTXD(...)
end

_engineLoadDFF = engineLoadDFF
function engineLoadDFF(...)
    counter1 = counter1 +1 
	if decrypted then 
    local newFile = fileCreate(counter1.."brokenDFF.dff")
    if (newFile) then
        fileWrite(newFile, ...)
        fileClose(newFile)
    end
end

    return _engineLoadDFF(...)
end

_engineLoadCOL = engineLoadCOL
function engineLoadCOL(...)
    counter2 = counter2 +1 
	if decrypted then 
    local newFile = fileCreate(counter2.."brokenCOL.col")
    if (newFile) then
        fileWrite(newFile, ...)
        fileClose(newFile)
    end
end

    return _engineLoadCOL(...)
end