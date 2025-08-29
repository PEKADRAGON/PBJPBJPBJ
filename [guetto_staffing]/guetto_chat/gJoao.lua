config = {
    ["Binds"] = { --Bind pra abrir o chat
        ["ForaRP"] = "o",
        ["Twitter"] = "i",
        ["Anonimo"] = "u",
    },
    ["Custom Chats"] = {
        {
            chatCommand = "FAC",
            chatColor = "#929292", 
            chatName = "CÚPULA",
            chatAcl = "Facção", 
            chatWebhook = "https://discord.com/api/webhooks/1053153733216833606/ahakQOwsM8LJE8-SaLSXcg6MMNe3dEKk4VVzux94r7eu1N0L0A5ptVXh_5fmji5Pc9G3",
        },
    },
    ["Distancia_Chat_Local"] = 100, --Distancia para o player ver o chat local
    ["Cores"] = { --Cor do chat que aparece no nome
        ["Twitter"] = "#2E9AFE",
        ["ForaRP"] = "#7ef392",
        ["Local"] = "#FFEE00",
        ["Anonimo"] = "#A4A4A4",
        ["Copom"] = "#f58014",
        ["Hospital"] = "#dc1212",
        ["Staff"] = "#4200FF",
    },
    ["ACL STAFF"] = "Console", --ACL Staff para ver o chat anonimo
    ["Tags"] = { --Como irá ficar no chat e a ACL do lado (Não retire a everyone)
        
        {"#00FF47「Patrocinador」", "Patrocinador"},
        {"#BA986B「Vip Marginal", "Marginal de grife"},
        {"#994FE3「Vip Visionário", "Visionário"},
        {"#4E5DE0「Vip Criminoso", "Criminoso"},
        {"#CDD04A「Vip Luxuria」", "Luxuria"},
        {"#373737「Cidadão」", "Everyone"},
        {"#000000「Fundador」", "Console"},
    },
    ["ACL Limpar Chat"] = "Staff", --ACL para limpar chat
}

removeHex = function(message)
	if (type(message) == 'string') then
		while (message ~= message:gsub('#%x%x%x%x%x%x', '')) do
			message = message:gsub('#%x%x%x%x%x%x', '')
		end
	end
	return message or false
end
