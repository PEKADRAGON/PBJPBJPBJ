local animTable = {
    ifp = {},
    anims = {
        "gang_drivebyrhs_bwd",
        "gang_drivebyrhs_fwd",
    }
}

addEventHandler("onClientResourceStart", resourceRoot, function()
    -- Carregar o IFP
    animTable.ifp["block"] = "drivebys"
    animTable.ifp["ifp"] = engineLoadIFP("drivebys.ifp", animTable.ifp["block"])

    -- Verificar se o IFP foi carregado com sucesso
    if animTable.ifp["ifp"] then
        outputDebugString("IFP file loaded successfully.")
        for _, v in ipairs(animTable.anims) do
            for _, p in ipairs(getElementsByType("player")) do
                -- Verificar se o jogador é válido
                if p and isElement(p) then
                    -- Substituir a animação para cada jogador
                    engineReplaceAnimation(p, "drivebys", v, animTable.ifp["block"], v)
                end
            end
        end
    else
        -- Exibir uma mensagem de erro se falhar ao carregar o IFP
        outputDebugString("Failed to load IFP file. Please check the file path and name.")
    end
end)
