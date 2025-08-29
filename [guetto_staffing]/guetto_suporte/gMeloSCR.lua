--[[
███╗░░░███╗███████╗██╗░░░░░░█████╗░  ░██████╗░█████╗░██████╗░
████╗░████║██╔════╝██║░░░░░██╔══██╗  ██╔════╝██╔══██╗██╔══██╗
██╔████╔██║█████╗░░██║░░░░░██║░░██║  ╚█████╗░██║░░╚═╝██████╔╝
██║╚██╔╝██║██╔══╝░░██║░░░░░██║░░██║  ░╚═══██╗██║░░██╗██╔══██╗
██║░╚═╝░██║███████╗███████╗╚█████╔╝  ██████╔╝╚█████╔╝██║░░██║
╚═╝░░░░░╚═╝╚══════╝╚══════╝░╚════╝░  ╚═════╝░░╚════╝░╚═╝░░╚═╝
]]

config = {

    Roles = {
        ['adminRoles'] = {
            { acl = "Console", role = "fundador" },
            { acl = "Staff", role = "staff" },
            { acl = "Developer", role = "developer" },
        },
    },

    Comandos = {

        ["pro"] = {
            aclsPerm = {
                {"Staff"},
            },

            Logs = {
                ativo = true,
                webhook =  "https://discordapp.com/api/webhooks/1246892726704930978/gbZYcJcwAesV73plIps3jgCBigIfT_aTY4f43zzbNMPfN3ECHIoh6pWaP-uvrPWnbNnm",
            },
        },

        ["staff"] = {
            aclsPerm = {
                {"Staff"},
            },

            Logs = {
                ativo = true,
                webhook =  "https://discordapp.com/api/webhooks/1246892726704930978/gbZYcJcwAesV73plIps3jgCBigIfT_aTY4f43zzbNMPfN3ECHIoh6pWaP-uvrPWnbNnm",
            },

            estarDePro = true, --Ele deve estar de /pro para executar o comando?
        },
        ["dvproximo"] = {
            aclsPerm = {
                {"Staff"},
            },

            distanciaVeiculo = 10, 

            Logs = {
                ativo = true,
                webhook =  "https://discordapp.com/api/webhooks/1246892726704930978/gbZYcJcwAesV73plIps3jgCBigIfT_aTY4f43zzbNMPfN3ECHIoh6pWaP-uvrPWnbNnm",
            },

            estarDePro = true, --Ele deve estar de /pro para executar o comando?
        },
        ["dv"] = {
            aclsPerm = {
                {"Staff"},
            },

            Logs = {
                ativo = true,
                webhook =  "https://discordapp.com/api/webhooks/1246892726704930978/gbZYcJcwAesV73plIps3jgCBigIfT_aTY4f43zzbNMPfN3ECHIoh6pWaP-uvrPWnbNnm",
            },

            estarDePro = true, --Ele deve estar de /pro para executar o comando?
        },

        ["dvall"] = {
            aclsPerm = {
                {"Staff"},
            },

            Logs = {
                ativo = true,
                webhook =  "https://discordapp.com/api/webhooks/1246892726704930978/gbZYcJcwAesV73plIps3jgCBigIfT_aTY4f43zzbNMPfN3ECHIoh6pWaP-uvrPWnbNnm",
            },

            estarDePro = true, 
        },

        ["setgas"] = {
            aclsPerm = {
                {"Staff"},
            },

            elementGasolina = "Gasolina",

            Logs = {
                ativo = true,
                webhook =  "https://discordapp.com/api/webhooks/1246892726704930978/gbZYcJcwAesV73plIps3jgCBigIfT_aTY4f43zzbNMPfN3ECHIoh6pWaP-uvrPWnbNnm",
            },

            estarDePro = true, --Ele deve estar de /pro para executar o comando?
        },

        ["setvida"] = {
            aclsPerm = {
                {"Console"},
                {"Moderador"},
            },

            Logs = {
                ativo = true,
                webhook =  "https://discordapp.com/api/webhooks/1246892726704930978/gbZYcJcwAesV73plIps3jgCBigIfT_aTY4f43zzbNMPfN3ECHIoh6pWaP-uvrPWnbNnm",
            },

            estarDePro = true, --Ele deve estar de /pro para executar o comando?
        },

        
        ["setcolete"] = {
            aclsPerm = {
                {"Staff"},
                {"Moderador"},
            },

            Logs = {
                ativo = true,
                webhook =  "https://discordapp.com/api/webhooks/1246892726704930978/gbZYcJcwAesV73plIps3jgCBigIfT_aTY4f43zzbNMPfN3ECHIoh6pWaP-uvrPWnbNnm",
            },

            estarDePro = true, --Ele deve estar de /pro para executar o comando?
        },

        ["kill"] = {
            aclsPerm = {
                {"Staff"},
            },

            Logs = {
                ativo = true,
                webhook =  "https://discordapp.com/api/webhooks/1246892726704930978/gbZYcJcwAesV73plIps3jgCBigIfT_aTY4f43zzbNMPfN3ECHIoh6pWaP-uvrPWnbNnm",
            },

            estarDePro = true, --Ele deve estar de /pro para executar o comando?
        },

        ["puxar"] = {
            aclsPerm = {
                {"Staff"},
            },

            Logs = {
                ativo = true,
                webhook =  "https://discordapp.com/api/webhooks/1246892726704930978/gbZYcJcwAesV73plIps3jgCBigIfT_aTY4f43zzbNMPfN3ECHIoh6pWaP-uvrPWnbNnm",
            },
            
            estarDePro = true, --Ele deve estar de /pro para executar o comando?
        },

        ["tp"] = {
            aclsPerm = {
                {"Staff"},
            },

            Logs = {
                ativo = true,
                webhook =  "https://discordapp.com/api/webhooks/1246892726704930978/gbZYcJcwAesV73plIps3jgCBigIfT_aTY4f43zzbNMPfN3ECHIoh6pWaP-uvrPWnbNnm",
            },
            
            estarDePro = true, --Ele deve estar de /pro para executar o comando?
        },

        ["tpcarro"] = {
            aclsPerm = {
                {"Staff"},
            },

            Logs = {
                ativo = true,
                webhook =  "https://discordapp.com/api/webhooks/1246892726704930978/gbZYcJcwAesV73plIps3jgCBigIfT_aTY4f43zzbNMPfN3ECHIoh6pWaP-uvrPWnbNnm",
            },
            
            estarDePro = true, --Ele deve estar de /pro para executar o comando?
        },

        ["ss"] = {
            aclsPerm = {
                {"Staff"},
            },

            Logs = {
                ativo = true,
                webhook =  "https://discordapp.com/api/webhooks/1246892726704930978/gbZYcJcwAesV73plIps3jgCBigIfT_aTY4f43zzbNMPfN3ECHIoh6pWaP-uvrPWnbNnm",
            },
            
            estarDePro = true, --Ele deve estar de /pro para executar o comando?
        },

        ["fixproximo"] = {
            aclsPerm = {
                {"Staff"},
            },

            Logs = {
                ativo = true,
                webhook =  "https://discordapp.com/api/webhooks/1246892726704930978/gbZYcJcwAesV73plIps3jgCBigIfT_aTY4f43zzbNMPfN3ECHIoh6pWaP-uvrPWnbNnm",
            },
            
            estarDePro = true, --Ele deve estar de /pro para executar o comando?
        },

        ["fix"] = {
            aclsPerm = {
                {"Console"},
                {"Staff"},
            },

            Logs = {
                ativo = true,
                webhook =  "https://discordapp.com/api/webhooks/1246892726704930978/gbZYcJcwAesV73plIps3jgCBigIfT_aTY4f43zzbNMPfN3ECHIoh6pWaP-uvrPWnbNnm",
            },
            
            estarDePro = true, --Ele deve estar de /pro para executar o comando?
        },

        ["puxarcarro"] = {
            aclsPerm = {
                {"Staff"},
            },

            Logs = {
                ativo = true,
                webhook =  "https://discordapp.com/api/webhooks/1246892726704930978/gbZYcJcwAesV73plIps3jgCBigIfT_aTY4f43zzbNMPfN3ECHIoh6pWaP-uvrPWnbNnm",
            },
            
            distanciaVeiculo = 10, 
            
            estarDePro = true, --Ele deve estar de /pro para executar o comando?
        },

        ["fly"] = {
            aclsPerm = {
                {"Console"},
            },

            Logs = {
                ativo = true,
                webhook =  "https://discordapp.com/api/webhooks/1246892726704930978/gbZYcJcwAesV73plIps3jgCBigIfT_aTY4f43zzbNMPfN3ECHIoh6pWaP-uvrPWnbNnm",
            },
            
            estarDePro = true, --Ele deve estar de /pro para executar o comando?
        },

        ["v"] = {
            aclsPerm = {
                {"Console"},
            },

            Logs = {
                ativo = true,
                webhook =  "https://discordapp.com/api/webhooks/1246892726704930978/gbZYcJcwAesV73plIps3jgCBigIfT_aTY4f43zzbNMPfN3ECHIoh6pWaP-uvrPWnbNnm",
            },
            
            estarDePro = true, --Ele deve estar de /pro para executar o comando?
        },

        ["fixproximo"] = {
            aclsPerm = {
                {"Console"},
            },

            Logs = {
                ativo = true,
                webhook =  "https://discordapp.com/api/webhooks/1246892726704930978/gbZYcJcwAesV73plIps3jgCBigIfT_aTY4f43zzbNMPfN3ECHIoh6pWaP-uvrPWnbNnm",
            },
            distanciaVeiculo = 10, 

            estarDePro = true, --Ele deve estar de /pro para executar o comando?
        },

        ["congelar"] = {
            aclsPerm = {
                {"Staff"},
            },

            Logs = {
                ativo = true,
                webhook =  "https://discordapp.com/api/webhooks/1246892726704930978/gbZYcJcwAesV73plIps3jgCBigIfT_aTY4f43zzbNMPfN3ECHIoh6pWaP-uvrPWnbNnm",
            },

            estarDePro = true, --Ele deve estar de /pro para executar o comando?
        },

    },

    Notify = {
        export = true, 
        nomescriptouevento = "guetto_notify",
        funcaoexport = "showInfobox",  --false caso nao seja por export
    },
    
}

function removeHex(message)
	if (type(message) == "string") then
		while (message ~= message:gsub("#%x%x%x%x%x%x", "")) do
			message = message:gsub("#%x%x%x%x%x%x", "")
		end
	end
	return message or false
end

formatNumber = function(number)   
    local formatted = number   
    while true do       
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2')     
        if ( k==0 ) then       
            break   
        end   
    end   
    return formatted 
end 