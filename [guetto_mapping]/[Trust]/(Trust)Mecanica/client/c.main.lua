Models = {
    [5774] = {
      Dff = "arquivos/models/mec.dff_encrypted",
      Col = "arquivos/models/mec.col_encrypted",
      IVDff = "arquivos/models/iv/mecdff.iv",
      IVCol = "arquivos/models/iv/meccol.iv",
      DFFTransparency = false,
      Password = "trustst147892023",
    },
    [5886] = {
      Dff = "arquivos/models/ptmec.dff_encrypted",
      Col = "arquivos/models/ptmec.col_encrypted",
      IVDff = "arquivos/models/iv/ptmecdff.iv",
      IVCol = "arquivos/models/iv/ptmeccol.iv",
      DFFTransparency = false,
      Password = "trustst147892023",
    },
  }



addEventHandler("onClientResourceStart", resourceRoot, function()
    txd = engineLoadTXD("arquivos/models/texturas.txd")
    engineImportTXD(txd, 5774)
    engineImportTXD(txd, 5886)
    carro = createVehicle(451, 1052.888, -1009.105, configurar.alturacarro1, 0, 0, 45)
    setElementFrozen(carro, true)
    setVehicleColor(carro, configurar.Corcarro1[1], configurar.Corcarro1[2], configurar.Corcarro1[3])
    carro2 = createVehicle(506, 1052.888, -1000.283, configurar.alturacarro2, 0, 0, 45)
    setElementFrozen(carro2, true)
    setVehicleColor(carro2, configurar.Corcarro2[1], configurar.Corcarro2[2], configurar.Corcarro2[3])
    
    for r6_10, r7_10 in pairs(Models) do
        if r7_10.Txd and r7_10.Txd ~= "" then
            if r7_10.Txd:find("_encrypted") then
                downloadFile(r7_10.Txd)
            else
                engineImportTXD(engineLoadTXD(r7_10.Txd), r6_10)
            end
        end
        if r7_10.Dff and r7_10.Dff ~= "" then
            if r7_10.Dff:find("_encrypted") then
                downloadFile(r7_10.Dff)
            else
                engineReplaceModel(engineLoadDFF(r7_10.Dff), r6_10)
            end
        end
        if r7_10.Col and r7_10.Col ~= "" then
            if r7_10.Col:find("_encrypted") then
                downloadFile(r7_10.Col)
            else
                engineReplaceCOL(engineLoadCOL(r7_10.Col), r6_10)
            end
        end
    end
end)

function onDownloadFinish(r0_11, r1_11)
    -- line: [163, 169] id: 11
    if not r1_11 then
        return 
    end
    if not findTableByFileName(r0_11) then
        return 
    end
    local r2_11 = findTableByFileName(r0_11)
    replaceFile(getResourceName(getThisResource()), r0_11, Models[r2_11].Password, getIvFile(r0_11, r2_11), r2_11, Models[r2_11].DFFTransparency)
end
addEventHandler("onClientFileDownloadComplete", resourceRoot, onDownloadFinish)


function getIvFile(r0_12, r1_12)
    -- line: [172, 182] id: 12
    if r0_12:find("txd") then
        return Models[r1_12].IVTxd
    elseif r0_12:find("dff") then
        return Models[r1_12].IVDff
    elseif r0_12:find("col") then
        return Models[r1_12].IVCol
    else
        return false
    end
end

function findTableByFileName(r0_13)
    -- line: [184, 205] id: 13
    local r1_13 = false
    for r5_13, r6_13 in pairs(Models) do
        if r6_13.Txd == r0_13 then
            r1_13 = r5_13
            break
        elseif r6_13.Dff == r0_13 then
            r1_13 = r5_13
            break
        elseif r6_13.Col == r0_13 then
            r1_13 = r5_13
            break
        end
    end
    return r1_13
end


local replace = {
    txd = {load = engineLoadTXD, replace = engineImportTXD},
    col = {load = engineLoadCOL, replace = engineReplaceCOL},
    dff = {load = engineLoadDFF, replace = engineReplaceModel} 
}

function replaceFile(resourceName, originalFile, key, ivFileName, id, transparency)
    if originalFile:sub(1, 1) ~= ":" and resourceName then
        file = ":" .. resourceName .. "/" .. originalFile
    end
    if fileExists(file) then
        local replaceType = file:match("%.(%a+)")
        if replaceType then
            if replace[replaceType:gsub("_encrypted$", "")] then
                local compiledFile = File.open(file, true)
                local ivFile = File.open(ivFileName, true)
                if compiledFile then
                    local load = replace[replaceType:gsub("_encrypted$", "")].load(decodeString("aes128", compiledFile:read(compiledFile:getSize()), { key = key, iv = ivFile:read(ivFile:getSize()) }))
                    replace[replaceType:gsub("_encrypted$", "")].replace(load, id, transparency)
                    compiledFile:close()
                    ivFile:close()
                    fileDelete(ivFileName)
                end
            end
        end
    end
end







--trustst147896325
--trustst147892023
