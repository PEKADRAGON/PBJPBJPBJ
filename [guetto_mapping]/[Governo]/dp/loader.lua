
local files = {


	{ "portadp.txd.pcrypt", 1492 },
	{ "portadp.dff.pcrypt", 1492 },
	{ "dp2_2.col.pcrypt", 5139 },


	{ "dp2.txd.pcrypt", 5134 },
	{ "dp2_ruas.txd.pcrypt", 5121 },
	{ "dp2_portao.txd.pcrypt", 3055 },
	{ "dp2_lod.txd.pcrypt", 5321 },
	{ "dp2_ruas.txd.pcrypt", 5139 },
	{ "dp2_alpha.txd.pcrypt", 5374 },
	{ "dp2_porta.txd.pcrypt", 1494 },


	{ "dp2.dff.pcrypt", 5134 },
	{ "dp2_2lod.dff.pcrypt", 5139 },
	{ "dp2_ruas.dff.pcrypt", 5121 },
	{ "dp2_portao.dff.pcrypt", 3055 },
	{ "dp2_lod.dff.pcrypt", 5321 },
	{ "dp2_canais2.dff.pcrypt", 5404 },
	{ "dp2_canais.dff.pcrypt", 5270 },
	{ "dp2_2.dff.pcrypt", 5139 },
	{ "dp2_alpha.dff.pcrypt", 5374 },
	{ "dp2_fios.dff.pcrypt", 5231 },
	{ "dp2_porta.dff.pcrypt", 1494 },


	{ "dp2.col.pcrypt", 5134 },
	{ "dp2_ruas.col.pcrypt", 5121 },
	{ "dp2_portao.col.pcrypt", 3055 },
	{ "dp2_canais2.col.pcrypt", 5404 },
	{ "dp2_canais.col.pcrypt", 5270 },
	{ "dp2_alpha.col.pcrypt", 5374 },

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
        if tonumber(model) == 1908 or string.find(file, "dp2") or string.find(file, "concessionaria") then
            engineReplaceModel(engineLoadDFF(data), model, true)
        else
            engineReplaceModel(engineLoadDFF(data), model)
        end
    elseif ext == ".txd" then
        engineImportTXD(engineLoadTXD(data), model)
    elseif ext == ".col" then
        engineReplaceCOL(engineLoadCOL(data), model)
		--engineSetModelLODDistance(model, 500)
		--setOcclusionsEnabled(false)
    end

    coroutine.resume(cor)
end

coroutine.resume(cor)
