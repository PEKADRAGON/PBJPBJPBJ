config = {
    ["Gerais"] = { 
        ["QuantiaDisparo"] = 300; -- Quantidade de tiro que o veiculo tem que toma para acabar a blindagem
        ["BlindagemPorTiro"] = true; -- Caso queira a blindagem por total de tiro que vc definir no QuantiaDisparo deixe em true, caso queira que fique blindado para sempre deixe false
        ["MostraPorcentagem"] = true; -- Caso queira que mostre um texto em cima do veiculo mostrando a porcentagem da blindagem deixe em true, caso não queira deixe em false
		["Comando"] = "blindar"; -- Comando que vai ser usado para ativar a blindagem
    };
    ["Permission"] = {
        [402] = "Console"; -- [ID do Veículo] = "ACL desse Veículo".
	    [497] = "Policial"; -- [ID do Veículo] = "ACL desse Veículo".
		[487] = "Policial"; -- [ID do Veículo] = "ACL desse Veículo".
    };	
    Tempo = 1, -- Definido em minutos
}

--getElementData Caso Queira Vincular Com Hud
--getElementData: VehBlindagem

notifyS = function(player, message, type)
    --triggerClientEvent(player, "Notaify", player, message, type) -- FIVEM 
    exports['FR_DxMessages']:addBox(player, message, type)
end